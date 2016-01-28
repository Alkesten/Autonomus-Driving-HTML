# Transmission Protocol
## MTU and payload
The __MTU__ is __1.468 byte__


__payload__ if __UDP__ is used:
```
1.468 MTU
- 20 IP header
- 8 UDP header
= 1.440 byte
```


__payload__ if __TCP__ is used:
```
1.468 MTU
- 20 IP header
- 20 TCP header
= 1.428 byte
```

## UDP Packet
The header has 8 byte = `2 * (2 * 8) bit`. source port (2 byte) + destination port (2 byte) + length (2 byte) + checksum (2 byte)
The UDP payload has to be filled up until octets are completed. All hex values are presented in __big endian__.


## Commands
The payload has to start with the specific id of the type of command. The id is one byte long. 

### Receive
* __speed__ 
	* id: 11 (`0x0B`)
	* values: 5 char: id + front left + front right + back left + back right
		* <i>values are rounded down to char</i>

* __gyroscope__
	* id: 12 (`0x0C`)
	* values: 4 char: id + x + y + z
		* <i>values are rounded down to char</i>

* __distance__
	* id: 13 (`0x0D`)
	* values: 9 unsigned char: id + d1 + d2 + d3 + d4 + d5 + d6 + d7 + d8
		* d1-8: clockwise 1-8 d1 = front left, d2 = front straight, d3 = front right, d4 = right side ...
		* <i>values are rounded down to char</i>

* __video__
	* id: 14 (`0x0E`)
	* values: 1.285 char: id + seq + block + 16 image rows
		* seq (3 byte): consecutively numbered sequence start at 0
		* block (1 byte): to idetify the image fragment 0-29 
		* immage fragment (1.280 byte): (total image: 640x480 = 307.200 bit) split up in 30 parts = 307.200 bit / 30 = 10.240 bit = 1.280 byte per image fragment

* current instruction
	* id: 15 (`0x0F`)
	* values: 2 + [length of instruction array] char: id + length + array of instructions
		* length (1 byte): length of instruction array
		* instructions[] ([length] byte): range between 0 and 4: 0 = turn left, 1 = go straight, 2 = turn right, park = 3, stop = 4

### Trasmit
* __connection handshake__
	* id: 20 (`0x14`)
	* values: 5 char: id + dataport + videoport
		* dataport (2 byte): 0-65535
		* videoport (2 byte): 0-65535 

* __speed and direction__
	* id: 21 (`0x15`)
	* values: 3 char: id + speed + direction
		* speed: range between 0 and 100
		* direction: range between 0 and 100: where 0-49 is left and 51-100 right, 50 is straight

* __stop__
	* id: 22 (`0x16`)
	* values: 1 char: id

* __parking__
	* id: 23 (`0x17`)
	* values: 1 char: id

* __instruction__
	* id: 24 (`0x18`)
	* values: 2 + [length of instruction array] char: id + length + array of instructions
		* length (1 byte): length of instruction array
		* instructions[] ([length] byte): range between 0 and 4: 0 = turn left, 1 = go straight, 2 = turn right, park = 3, stop = 4

* __request data command__
	* id: 25 (`0x19`)
	* values: 2 char: id + requested data
		* requestet datatypes (1 byte):
			* speed (`0b0000 1000 = 0x08`)
			* gyroscope (`0000 0100 = 0x04`)
			* distance (`0000 0010 = 0x02`)
			* video (`0000 0001 = 0x01`)
				* <i>example: request speed and distance: ```0b0000 1000 + 0b0000 0010 = 0b0000 1010 = 0x0A```</i>
