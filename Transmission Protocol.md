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


## UDP Packet
The header has 8 byte = `2 * (2 * 8) bit`. source port (2 byte) + destination port (2 byte) + length (2 byte) + checksum (2 byte)
The UDP payload has to be filled up until octets are completed. All hex values are presented in __big endian__.


## Commands
__All transmissions are send as UDP packets__. The payload has to start with the specific ID of the type of command. The ID is one byte long. 

### Receive
* __speed__ 
	* ID: 11 (`0x0B`)
	* values: 5 UInt8: ID + front left + front right + back left + back right
		* <i>values are rounded down to UInt8</i>

* __gyroscope__
	* ID: 12 (`0x0C`)
	* values: 4 UInt8: ID + x + y + z
		* <i>values are rounded down to UInt8</i>

* __distance__
	* ID: 13 (`0x0D`)
	* values: 17 UInt8: ID + d1 + d2 + d3 + d4 + d5 + d6 + d7 + d8
		* d1-8: 8 * (2 UInt8 = UInt16 Big Endian)
		* d1-8: clockwise 1-8 d1 = front left, d2 = front straight, d3 = front right, d4 = right side ...
		* <i>values are rounded down to UInt16 (1 = 1 cm). UInt16 is splitted up into 2 UInt8 [UInt8,UInt8] __big endian__</i>

* __video__
	* ID: 14 (`0x0E`)
	* values: 1.285 UInt8: ID + seq + block + 16 image rows
		* seq (3 UInt8): consecutively numbered sequence starts at 0
		* block (1 UInt8): to Idetify the image fragment 0-29 
		* image fragment (1.280 byte): (total image: 640x480 = 307.200 bit) split up in 30 parts = 307.200 bit / 30 = 10.240 bit = 1.280 byte per image fragment

* __current instruction__
	* ID: 15 (`0x0F`)
	* values: 2 + [length of instruction array] UInt8: ID + length + array of instructions
		* length (1 UInt8): length of instruction array
		* instructions[] (length * UInt8): range between 0 and 4: 0 = turn left, 1 = go straight, 2 = turn right, park = 3, stop = 4

### Trasmit
* __connection handshake__
	* ID: 20 (`0x14`)
	* values: 5 UInt8: ID + dataport + videoport
		* dataport (2 UInt8 = UInt16 Big Endian): 0-65535 (car listens on UDP port 3030)
		* videoport (2 UInt8 = UInt16 Big Endian): 0-65535 
			* eg. 3040 = `0x0BE0`

* __speed and direction__
	* ID: 21 (`0x15`)
	* values: 3 UInt8: ID + speed + direction
		* speed: range between 0 and 200: 0 = stop, 1-100 = forwards, 101-200 = backwards
		* direction: range between 0 and 100: where 0-49 is left and 51-100 right, 50 is straight

* __stop__
	* ID: 22 (`0x16`)
	* values: 1 UInt8: ID

* __parking__
	* ID: 23 (`0x17`)
	* values: 1 UInt8: ID

* __instruction__
	* ID: 24 (`0x18`)
	* values: 2 + [length of instruction array] UInt8: ID + length + array of instructions
		* length (1 UInt8): length of instruction array
		* instructions[] (length * UInt8): range between 0 and 4: 0 = turn left, 1 = go straight, 2 = turn right, park = 3, stop = 4

* __request data command__
	* ID: 25 (`0x19`)
	* values: 2 UInt8: ID + requested data
		* requestet datatypes (1 UInt8):
			* speed (`0b0000 1000 = 0x08`)
			* gyroscope (`0000 0100 = 0x04`)
			* distance (`0000 0010 = 0x02`)
			* video (`0000 0001 = 0x01`)
				* <i>example: request speed and distance: ```0b0000 1000 + 0b0000 0010 = 0b0000 1010 = 0x0A```</i>
