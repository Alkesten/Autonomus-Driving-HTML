import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.util.BitSet;

public class ServerThread implements Runnable{

	//connection settings
	private int carPort;
	private DatagramSocket dgramSocket;
	
	private boolean speedRequested,gyroscopeRequested,distanceRequested,videoRequested; 

	
	public ServerThread(int carPort) {
		// TODO Auto-generated constructor stub
	}


	@Override
	public void run() { 
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
}
