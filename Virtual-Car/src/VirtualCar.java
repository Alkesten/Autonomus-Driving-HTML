/**
 * virtual car for testing
 * @author Moritz Kellermann
 */

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.util.BitSet;

public class VirtualCar {
	
	//connection settings
	private int carPort, appPort;
	private InetAddress appIPv4;
	private DatagramSocket dgramSocket;
	
	//variables for transmission
	private byte[] distance = new byte[8]; //distances
	private byte[] xyz = new byte[3]; //gyroscope
	private byte[] speed = new byte[4]; //speed front and back, left and right
	
	//received variables
	private byte[] rxInstruction; //tour instructions
	private byte rxSpeed,rxDirection; //speed and direction in percent
	private boolean stop,park;
	private boolean speedRequested,gyroscopeRequested,distanceRequested,videoRequested; 
	
	
	/**
	 * creates a new object of VirtualCar with an rx and tx socket
	 * @param appIPv4
	 * @param appPort
	 * @param carPort
	 */
	public VirtualCar(InetAddress appIPv4, int appPort, int carPort){
		try {
			dgramSocket = new DatagramSocket(carPort);
		} catch (SocketException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		this.appIPv4 = appIPv4;
		this.carPort = carPort;
		this.appPort = appPort;
		
		setDistance(new byte[] {0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08});
		setSpeed(new byte[] {0x64,0x64,0x64,0x64}); //100% for all wheels =0x64
		setGyroscope(new byte[] {0x01,0x02,0x03});
	}
	
	public void setDistance(byte[] distance){
		for(int i=0; i<8; i++){
			this.distance[i] = distance[i];
		}
	}
	
	public void setSpeed(byte[] speed){
		for(int i=0; i<4; i++){
			this.speed[i] = speed[i];
		}
	}
	
	public void setGyroscope(byte[] xyz){
		for(int i=0; i<3; i++){
			this.xyz[i] = xyz[i];
		}
	}
	
	public void listen() { 
		try {
	        byte[] receivedData = new byte[8];

	        System.out.printf("Listening on udp:%s:%d%n",
	                InetAddress.getLocalHost().getHostAddress(), carPort);     
	        DatagramPacket receivedPacket = new DatagramPacket(receivedData,
	                           receivedData.length);

	        while(true)
	        {
	        	  dgramSocket.receive(receivedPacket);
	              String sentence = new String( receivedPacket.getData(), 0,
	                                 receivedPacket.getLength() );
	              System.out.println("RECEIVED: " + sentence);
	              
	              // TODO ACK?
	              processReceived(receivedPacket);
	        }
	      } catch (IOException e) {
	              System.out.println(e);
	      }
	      finally {
	    	  dgramSocket.close();
	      }
	}
	
	private void processReceived(DatagramPacket receivedPacket){
		byte[] payload = receivedPacket.getData();
		
		int id = payload[0];
		byte[] newPayload = removeId(payload);
		
		switch(id){
			case 21: 
				receiveSpeedDirection(newPayload);
				break;
			case 22:
				receiveStop();
				break;
			case 23:
				receiveParking();
				break;
			case 24:
				receiveInstruction(newPayload);
				break;
			case 25:
				receiveDataRequest(newPayload);
				break;
			default:
				System.out.println("Unknown id received: " + id);
				break;
		}
	}
	
	private byte[] removeId(byte[] payload){
		byte[] array = new byte[payload.length-1];
		
		for(int i=0;i < payload.length;i++){
            array[i] = payload[i+1];
		}
		
		return array;
	}
	
	private void receiveSpeedDirection(byte[] payload){
		rxSpeed = payload[0];
		rxDirection = payload[1];
	}
	
	private void receiveStop(){
		stop = true;
	}
	
	private void receiveParking(){
		park = true;
	}
	
	private void receiveInstruction(byte[] payload){
		rxInstruction = payload;
	}
	
	private void receiveDataRequest(byte[] payload){
		BitSet bits = new BitSet(4);
	    for (int i = 4; i < 8; i++)
	    {
	        bits.set(i, (payload[0] & 1) == 1);
	        payload[0] >>= 1;
	    }
	    
	    speedRequested = bits.get(0);
	    gyroscopeRequested = bits.get(1);
	    distanceRequested = bits.get(2);
	    videoRequested = bits.get(3);
	    
	    transmitRequestedData();
	}
	
	private void transmitRequestedData() {
		// TODO Auto-generated method stub
		while(true){
			if(speedRequested){
				sendSpeed();
			}
			if(gyroscopeRequested){
				sendGyroscope();
			}
			if(distanceRequested){
				sendDistance();
			}
			if(videoRequested){
				sendVideo();
			}
		}
	}

	/**
	 * creates a datagram packet and sends it via the datagram socket to the app.
	 * @param payload
	 */
	private void sendDatagram(byte[] payload){
		DatagramPacket sendPacket = new DatagramPacket(payload, payload.length, appIPv4, appPort);
		try {
			dgramSocket.send(sendPacket);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void sendSpeed(){
		byte id = 0x0B;
		byte[] payload = generatePayload(id,speed);
		
		sendDatagram(payload);
	}
	
	public void sendGyroscope(){
		byte id = 0x0C;
		byte[] payload = generatePayload(id,xyz);

		sendDatagram(payload);
	}
	
	public void sendDistance(){
		byte id = 0x0D;
		byte[] payload = generatePayload(id,distance);

		sendDatagram(payload);
	}
	
	public void sendVideo(){
		byte id = 0x0E;
		//TODO
		throw new UnsupportedOperationException();
	}
	
	/**
	 * adds the id to the byte array.
	 * @param id
	 * @param array
	 * @return
	 */
	private byte[] generatePayload(byte id, byte[] array){
		byte[] payload = new byte[array.length + 1];
		payload[0] = id;
		for(int i=0;i < array.length;i++){
            payload[i+1] = array[i];
		}
		return payload;
	}
}
