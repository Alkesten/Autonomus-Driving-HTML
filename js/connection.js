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