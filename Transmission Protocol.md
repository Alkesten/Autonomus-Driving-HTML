# Transmission Protocol

## UDP Packet
The header has 8 octets (bytes = B) = 2 * (2 * 8) bit. source port (2 B) + destination port (2 B) + length (2 B) + checksum (2 B)
The UDP payload has to be filled up until octets are completed. All hex values are presented in big endian.


## Commands
The payload has to start with the specific id of the type of command. The id (binary) is one byte long. 

### Receive
* speed 
	* id: 11 (0000 1011)
	* values: 5 char: id + front left + front right + back left + back right

* gyroscope
	* id: 12 (0000 1100)
	* values: 4 char: id + x + y + z

* distance
	* id: 13 (0000 1101)
	* values: 9 unsigned char: id + d1 + d2 + d3 + d4 + d5 + d6 + d7 + d8

* video
	* id: 14 (0000 1110)
	* values: (640x480 = 307.200 bit) = (80x60 = 4.800 byte) + 1 byte for the ID
		* MTU of Ethernet = 1.500 byte (= UDP payload [max. 1.472 B] + UDP header [8 B]+ IPv4 Header [20 B]) 
			* => manual or automatic UDP or IP fragmentation (incl. seq number)?
		* The video will be transmitted as byte[80][60] 2D array since we have just black and white (1 or 0).

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
		* directions: range between 0 and 4: 0 = turn left, 1 = go straight, 2 = turn right, park = 3, stop = 4

* request data command
	* id: 25 (0001 1001)
	* values: 2 char: id + requested data
		* requestet datatypes
			* speed (1000)
			* gyroscope (0100)
			* distance (0010)
			* video (0001)
			* <i>example: request speed and distance: 0b1000 + 0b0010 = 0b10010 = 0x0A</i>

### Video
The video will be fetched from the car on another socket. 
