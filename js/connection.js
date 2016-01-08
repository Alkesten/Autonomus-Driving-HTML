/*
 * @author Moritz Kellermann
 */

//TODO IP and port should be dynamic
var LPORT = 33333; //local port of the app
var RPORT = 33334; //remote port of the car
var LIP = '127.0.0.1'; //local IP address of the phone/app
var RIP = '192.168.1.10' //remote IP address of the car
var intruction = [] //array of tour instructions

var main = function() {
	var dgram = require("dgram");
	server = dgram.createSocket('udp4');
	server.bind(LPORT); //binds local socket to listener port 'LPORT'
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
			if(arguements[i] < 0){
				return; //out of range <0
			}
			if(arguements[i] > 100){
				return; //out of range >100
			}
		} else {
			return; //not typeof number
		}
	}

	var a = [];	
	a[0] = id;
	a[1] = speed.toString(16);
	a[2] = direction.toString(16);
	
	var buffer = new Buffer(a);
	
	transmit(buffer);
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
 * @param {number} direction - range between 0 and 2: 0 = turn left, 1 = go straight, 2 = turn right
 */
function buildInstruction(direction){
	if(direction === undefinded){
		throw "Argument is empty!";
	}
	if(typeof direction === 'number'){
		if(direction === 0 || direction === 1 || direction === 2){
			intruction.push(direction); //adds direction at the end of the instruction array
		} else {
			throw "@param 'direction' is out of range! Range has to be between 0 and 2: 0 = turn left, 1 = go straight, 2 = turn right.";
		}
	} else {
		throw "@param 'direction' has to be type of 'number'";
	}
}

/**
 * Sends the builded instruction array.
 */
function setTour(){
	var id = 0x18; //id for instruction: 24

	var prefix = [];	
	prefix[0] = id;
	prefix[1] = intruction.length();
	var a = prefix.concat(instruction); //concatinates prefix array (id and length) and instructions array
	
	var buffer = new Buffer(a);
	
	transmit(buffer);
	}