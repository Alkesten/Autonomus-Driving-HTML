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
	//variables for transmission
	private byte[] distance = new byte[8]; //distances
	private byte[] xyz = new byte[3]; //gyroscope
	private byte[] speed = new byte[4]; //speed front and back, left and right
	
	//received variables
	private byte[] rxInstruction; //tour instructions
	private byte rxSpeed,rxDirection; //speed and direction in percent
	private boolean stop,park;
	private boolean speedRequested,gyroscopeRequested,distanceRequested,videoRequested; 
	
	ServerThread server;
	ClientThread client;
	
	/**
	 * creates a new object of VirtualCar with an rx and tx socket
	 * @param appIPv4
	 * @param appPort
	 * @param carPort
	 */
	public VirtualCar(InetAddress appIPv4, int appPort, int carPort){
		setDistance(new byte[] {0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08});
		setSpeed(new byte[] {0x64,0x64,0x64,0x64}); //100% for all wheels =0x64
		setGyroscope(new byte[] {0x01,0x02,0x03});
		
		server = new ServerThread(carPort);
		client = new ClientThread(appIPv4, appPort);
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
}
