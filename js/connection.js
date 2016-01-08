/*
 * @author Moritz Kellermann
 */

/*
 * connection configuration variables
 */
var LPORT = 33333; //local port of the app
var RPORT = 33334; //remote port of the car
var LIP = '127.0.0.1'; //local IP address of the phone/app
var RIP = '192.168.1.10' //remote IP address of the car
var socket;

/*
 * variables to transmit
 */
var instruction = [] //array of tour instructions

/*
 * reveived variables
 */
var speedFL, speedFR, speedBL, speedBR; //speed front and back - left and right
var gx, gy, gz; //gyroscope x,y,z;
var d1,d2,d3,d4,d5,d6,d7,d8; //distance sensors 1-8


var main = function() {
	var dgram = require("dgram");
	socket = dgram.createSocket('udp4');
	socket.bind(LPORT); //binds local socket to listener port 'LPORT'
}

//calls onIncommingMsg() on incomming message on the socket 
socket.on('message', onIncommingMsg(msg, rinfo));

/**
 * checks the id of the received packet and calls the right function.
 * @param {buffer object} msg - received UDP payload
 * @param {object} rinfo - Remote address information
 */
function onIncommingMsg(msg, rinfo){
	//TODO check if msg contains hex values.
	switch(msg[0]){
	case 11:
		speedFL = msg[1];
		speedFR = msg[2];
		speedBL = msg[3];
		speedBR = msg[4];
		break;
	case 12:
		gx = msg[1];
		gy = msg[2];
		gz = msg[3];
		break;
	case 13:
		d1 = msg[1];
		d2 = msg[2];
		d3 = msg[3];
		d4 = msg[4];
		d5 = msg[5];
		d6 = msg[6];
		d7 = msg[7];
		d8 = msg[8];
		break;
	default:
		console.log("Received message with unknown id: "+ msg[0] + ", length: "+ msg.length + ", address: "+ rinfo.address + ", port: " + rinfo.port + " - Message as been dropped.");
		break;
	}
}

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
		var length = buffer.length;
		var offset = 0;
		server.send(buffer, offset, length, RPORT, RIP)
	} else {
		throw "@param 'buffer' has to be typeof 'Buffer' (Node.js Buffer object)";
	}
}

/**
* @param {number} speed - range between 0 and 100
* @param {number} direction - range between 0 and 100 where 0-49 is left and 51-100 right, 50 is straight
*/
function setSpeedDirection(speed, direction){	
	var id = 0x15; //id for speed & direction: 21
	
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
				
				var buffer = new Buffer(a);
				
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
	var id = 0x16; //id for stop: 22
	
	var a = [];	
	a[0] = id;
	
	var buffer = new Buffer(a);
	
	transmit(buffer);
}

/**
 * parks the car.
 */
function setPark(){
	var id = 0x17; //id for parking: 23

	var a = [];	
	a[0] = id;
	
	var buffer = new Buffer(a);
	
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
	var id = 0x18; //id for instruction: 24

	var prefix = [];
	prefix[0] = id;
	prefix[1] = instruction.length.toString(16);
	var a = prefix.concat(instruction); //concatinates prefix array (id and length) and instructions array
	
	var buffer = new Buffer(a);
	
	transmit(buffer);
}