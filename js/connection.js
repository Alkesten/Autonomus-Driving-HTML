// JavaScript Document
var LPORT = 33333; //local port of the app
var RPORT = 33334; //remote port of the car
var LIP = '127.0.0.1'; //local IP address of the phone/app
var RIP = '192.168.1.10' //remote IP address of the car

var main = function() {
	var dgram = require("dgram");
	server = dgram.createSocket('udp4');
	server.bind(PORT);
}

function transmit(buffer){
	server.send(buffer, offset, length, RPORT, address)
}

/**
* @param {number} speed - range between 0 and 100
* @param {number} direction - range between 0 and 100 where is 0-49 left and 51-100 right, 50 is straight
*/
function setSpeed(speed, direction){	
	for(i=0; arguments.length; i++){
		//check for empty parameter
		if(arguements[i] === undefinded){
			return;
		}
		//check for right type
		if(typeof arguements[i] === 'number'){
		//check for range
			if(arguements[i] < 0){
				return;
			}
			if(arguements[i] > 100){
				return;
			}
		} else {
			return;
		}
	}

	var id = 0x15; //21
	var a = [];
	
	a[0] = id;
	a[1] = speed.toString(16);
	a[2] = direction.toString(16);
	
	var buffer = new Buffer(a);
	
	transmit(buffer);
}

function setStop(){
	var id = 0x16; //22
	var a = [];	
	a[0] = id;
	
	var buffer = new Buffer(a);
	
	transmit(buffer);
}

function parking(){
 //TODO
}