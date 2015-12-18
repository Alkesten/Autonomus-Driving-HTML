# Transmission Protocol

## UDP Packet
The header has 8 octets (bytes = B) = 2 * (2 * 8) bit. source port (2 B) + destination port (2 B) + length (2 B) + checksum (2 B)
The UDP payload has to be filled up until octets are completed.


## Commands
The payload has to start with the specific id of the type of command. The id (binary) is one byte long. 

### Receive
* speed 
	* id: 11 (0000 1011)
	* values: 4 char

* gyroscope
	* id: 12 (0000 1100)
	* values: 3 char

* distance
	* id: 13 (0000 1101)
	* values: 8 unsigned char

* video
	* id: 14 (0000 1110)
	* values: (640x480 = 307.200 bits) -> 640 bit / 32 bit = 20 * 480 lines = 9.600 UDP payload lines
		* <i>(38400 bytes per frame / 548 MTU = 71 packages) -> transmit just the diff would decrease overhead. Which codec?</i>


### Trasmit
* speed and direction
	* id: 21 (0001 0101)
	* values: 2 char (speed and direction - nagativ and positive)

* stop
	* id: 22 (0001 0110)
	* values: 1 char

* parking
	* id: 23 (0001 0111)
	* values: 1 char

* instruction
	* id: 24 (0001 1000)
	* values: 1 char (for length = commands) + legth * chars (one for each direction/command)

* request video command
	* id: 25 (0001 1001)
	* values: 1 char