# Transmission Protocol

## UDP Packet
The header has 8 octets = 2 x 32 bits
The UDP payload has to be filled up until octets are completed.


## Commands
The payload has to start with the specific id of the type of command. 

### Receive
#### speed 
id: 
values: 4 x char

#### gyroscope
id:
values: 3 x char

#### distance
id:
values: 8 x unsigned char

#### video
id:
values: (640x480 = 307.200 bits) -> 640 bit / 32 bit = 20 * 480 lines = 9.600 UDP payload lines
(38400 bytes per frame) -> transmit just the diff would decrease overhead. Which codec?


### Trasmit
#### speed and direction
id:
values: 2 char (speed and direction - nagativ and positive)

#### stop
id:
values: 1 char

#### parking
id:
values: 1 char

#### instruction
id:
values: 1 char (for length = commands) + leght * chars (one for each command)

#### recive video commadn
id:
values: 1 char