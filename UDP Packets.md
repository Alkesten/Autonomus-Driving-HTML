# Transmission Protocol

## UDP Packet
The header has 8 octets = 2 x 32 bits. 
The UDP payload has to be filled up until octets are completed.


## Commands
The payload has to start with the specific id of the type of command. The id is one byte long. 

### Receive
* speed 
	* id: 11
	* values: 4 x char

* gyroscope
	* id: 12
	* values: 3 x char

* distance
	* id: 13
	* values: 8 x unsigned char

* video
	* id: 14
	* values: (640x480 = 307.200 bits) -> 640 bit / 32 bit = 20 * 480 lines = 9.600 UDP payload lines
		* **(38400 bytes per frame) -> transmit just the diff would decrease overhead. Which codec?**


### Trasmit
* speed and direction
	* id: 21
	* values: 2 char (speed and direction - nagativ and positive)

* stop
	* id: 22
	* values: 1 char

* parking
	* id: 23
	* values: 1 char

* instruction
	* id: 24
	* values: 1 char (for length = commands) + leght * chars (one for each command)

* request video command
	* id: 25
	* values: 1 char