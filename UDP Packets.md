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

* video *(deprecated)*
	* id: 14 (0000 1110)
	* values: (640x480 = 307.200 bits) <i>-> 640 bit / 32 bit = 20 * 480 lines = 9.600 UDP payload lines</i>
		* <i>(38.400 bytes per frame / 548 MTU = 71 packages) -> transmit just the diff would decrease overhead. Which codec?</i>


### Trasmit
* speed and direction
	* id: 21 (0001 0101)
	* values: 3 char: id + speed + direction
		* speed: range between 0 and 100
		* direction: range between 0 and 100: where 0-49 is left and 51-100 right, 50 is straight

* stop
	* id: 22 (0001 0110)
	* values: 1 char: id

* parking
	* id: 23 (0001 0111)
	* values: 1 char: id

* instruction
	* id: 24 (0001 1000)
	* values: 2 + (length of direction array) char: id + length + array of directions
		* directions: range between 0 and 2: 0 = turn left, 1 = go straight, 2 = turn right

* request video command
	* id: 25 (0001 1001)
	* values: 1 char: id

### Video
The video will be fetched from the car on another socket. 