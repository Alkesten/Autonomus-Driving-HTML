/**
 * @author Moritz Kellermann (moritz.kellermann [at] in.tum.de)
 */

/*
 * connection configuration variables
 */
var LPORT = 33333; //local port of the app
var RPORT = 33334; //remote port of the car
var LIP = '127.0.0.1'; //local IP address of the phone/app
var RIP = '192.168.1.10' //remote IP address of the car
var REST_Port = 30000;

/*
 * data for transmission to the car
 */
var instruction = [] //array of tour instructions

/*
 * received data from the car
 */
var speedFL, speedFR, speedBL, speedBR; //speed front and back - left and right
var gx, gy, gz; //gyroscope x,y,z;
var d1,d2,d3,d4,d5,d6,d7,d8; //distance sensors 1-8

//creates a new UDP socket
const dgram = require('dgram');
const socket = dgram.createSocket('udp4');
socket.bind(LPORT); //binds local socket to listener port 'LPORT'

/**
 * listen event: processes incoming UDP packets given their id.
 */
socket.on('message', function(msg, rinfo){
	console.log("RECEIVED: id: "+ msg[0] + ", length: "+ msg.length + ", address: "+ rinfo.address + ", port: " + rinfo.port);
	switch(msg[0]){
		case 11: //speed
			console.log("Speed Data Received");
			speedFL = msg[1];
			speedFR = msg[2];
			speedBL = msg[3];
			speedBR = msg[4];
			break;
		case 12: //gyroscope
			console.log("Gyroscope Data Received");
			gx = msg[1];
			gy = msg[2];
			gz = msg[3];
			break;
		case 13: //distance
			console.log("Distance Data Received");
			d1 = msg[1];
			d2 = msg[2];
			d3 = msg[3];
			d4 = msg[4];
			d5 = msg[5];
			d6 = msg[6];
			d7 = msg[7];
			d8 = msg[8];
			break;
		default: //unknown id
			console.log("Unknown ID: "+ msg[0] + " - Message as been dropped!");
			break;
	}
});

/**
 * transmits the buffer via UDP connection
 * @param {buffer} buffer - payload of the UDP packet
 */
function transmit(buffer){
	if(buffer === undefinded){
		throw "argument is empty!";
	}
	
	if(typeof buffer === 'Buffer'){//instanceof TypedArray better?
		//TODO buffer = payload without header?
		//TODO message size check, otherwise UDP packet will be dropped silently!
		const length = buffer.length;
		const offset = 0;
		socket.send(buffer, offset, length, RPORT, RIP)
	} else {
		throw "@param 'buffer' has to be typeof 'Buffer' (Node.js Buffer object)";
	}
}

/**
* @param {number} speed - range between 0 and 100
* @param {number} direction - range between 0 and 100 where 0-49 is left and 51-100 right, 50 is straight
*/
function setSpeedDirection(speed, direction){	
	const id = 0x15; //id for speed & direction: 21
	
	for(i=0; arguments.length; i++){
		//check for empty parameter
		if(arguements[i] === undefinded){
			throw "arguments are empty!";
		}
		//check for right type
		if(typeof arguements[i] === 'number'){
		//check for range
			if(arguements[i] < 0 || arguements[i] > 100){
				throw "out of range <0 || >100";
			} else {
				var a = [];	
				a[0] = id;
				a[1] = speed.toString(16);
				a[2] = direction.toString(16);
				
				const buffer = new Buffer(a);
				
				transmit(buffer);
			}
		} else {
			throw "not all arguments are type of number";
		}
	}
}

/**
 * stops the car immediately.
 */
function setStop(){
	const id = 0x16; //id for stop: 22
	
	var a = [];	
	a[0] = id;
	
	const buffer = new Buffer(a);
	
	transmit(buffer);
}

/**
 * parks the car.
 */
function setPark(){
	const id = 0x17; //id for parking: 23

	var a = [];	
	a[0] = id;
	
	const buffer = new Buffer(a);
	
	transmit(buffer);
}

/**
 * fills the tour instruction array.
 * @param {number} cmd - range between 0 and 2: 0 = turn left, 1 = go straight, 2 = turn right, 3 = park, 4 = stop
 */
function buildInstruction(cmd){
	if(cmd === undefinded){
		throw "Argument is empty!";
	}
	if(typeof cmd === 'number'){
		if(cmd === 0 || cmd === 1 || cmd === 2 || cmd === 3 || cmd === 4){
			instruction.push(cmd.toString(16)); //adds direction at the end of the instruction array
		} else {
			throw "@param 'cmd' is out of range! Range has to be between 0 and 2: 0 = turn left, 1 = go straight, 2 = turn right, 3 = park, 4 = stop.";
		}
	} else {
		throw "@param 'cmd' has to be type of 'number'";
	}
}

/**
 * Sends the builded instruction array.
 */
function setTour(){
	const id = 0x18; //id for instruction: 24

	var prefix = [];
	prefix[0] = id;
	prefix[1] = instruction.length.toString(16);
	const a = prefix.concat(instruction); //concatenates prefix array (id and length) and instructions array
	
	const buffer = new Buffer(a);
	
	transmit(buffer);
}

/**
 * requests or stops the request of data.
 * @param {number} speed - >0 for request speed wheel 1-4
 * @param {number} gyroscope - >0 for request gyroscope x,y,z
 * @param {number} distance - >0 for request distance d1-8
 * @param {number} video - >0 for request video stream
 */
function requestData(speed, gyroscope, distance, video){
	const id = 0x19; //id for request data: 25
	var request = 0;
	
	if(speed){
		request = request + 8;
	}
	if(gyroscope){
		request = request + 4;
	}
	if(distance){
		request = request + 2;
	}
	if(video){
		request = request + 1;
	}
	
	var a = [];
	a[0] = id;
	a[1] = request;
	
	const buffer = new Buffer(a);
	
	transmit(buffer);
}


//Express app: communication between JS/HTML and the server (node.js) via REST
const express = require('express');
const bodyParser = require("body-parser");
const app = express();
app.listen(REST_Port);

//configuring express to use body-parser as middle-ware.
app.use(bodyParser.urlencoded({
	extended : false
}));
app.use(bodyParser.json());

app.get('/speed', function(req, res) {
	res.send([ speedFL, speedFR, speedBL, speedBR ]);
});

app.get('/gyroscope', function(req, res) {
	res.send([ gx, gy, gz ]);
});

app.get('/distance', function(req, res) {
	res.send([ d1, d2, d3, d4, d5, d6, d7, d8 ]);
});

app.post('/request', function(req, res) {
	//FIXME parse to boolean
	var reqSpeed = req.body.speed;
	var reqDistance = req.body.distance;
	var reqGyroscope = req.body.gyroscope;
	var reqVideo = req.body.video;

	requestData(reqSpeed, reqGyroscope, reqDistance, reqVideo);
});

app.post('/stop', function(req, res) {
	setStop();	
});

app.post('/park', function(req, res) {
	setPark();
});

app.post('/instruction', function(req, res) {
	//TODO accept unknown array length
	res.send('POST request to homepage');
});
