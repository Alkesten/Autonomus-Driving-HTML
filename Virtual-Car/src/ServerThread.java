import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.util.BitSet;

/**
 * Thread class for receiving data via UDP from the app.
 * 
 * @author Moritz Kellermann (moritz.kellermann [at] in.tum.de)
 *
 */
public class ServerThread extends Thread{
	//connection settings
	private int carPort;
	private DatagramSocket dgramSocket;
	private VirtualCar car;
	
	//true if the data is requested by the app
	private boolean speedRequested,gyroscopeRequested,distanceRequested,videoRequested; 

	/**
	 * Create a new ServerThread object for incoming UDP packets.
	 * 
	 * @param carPort the UDP port of the car (should be 1024 or higher).
	 * @param car the car itself for accessing data.
	 */
	public ServerThread(int carPort, VirtualCar car) {
		this.car = car;
		this.carPort = carPort;

		try {
			dgramSocket = new DatagramSocket(this.carPort);
		} catch (SocketException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void run() { 
		try {
	        byte[] receivedData = new byte[8]; //FIXME which size is needed?

	        System.out.printf("Listening on udp:%s:%d%n",
	                InetAddress.getLocalHost().getHostAddress(), carPort);     
	        DatagramPacket receivedPacket = new DatagramPacket(receivedData,
	                           receivedData.length);

	        while(true)
	        {
	        	  dgramSocket.receive(receivedPacket);
	        	  byte[] payload = receivedPacket.getData();
	        	  int id = payload[0];
	              
	              System.out.println("RECEIVED ID: " + id);
	              
	              //TODO ACK?
	              //TODO parallel receive and process? buffer?
	              processReceived(receivedPacket);
	        }
	      } catch (IOException e) {
	              System.out.println(e);
	      }
	      finally {
	    	  dgramSocket.close();
	      }
	}
	
	/**
	 * Analyze the packet via ID in the first payload byte and calls the necessary method.
	 * 
	 * @param receivedPacket received UDP packet.
	 */
	private synchronized void processReceived(DatagramPacket receivedPacket){
		byte[] payload = receivedPacket.getData();
		
		int id = payload[0];
		
		switch(id){
			case 21: 
				receiveSpeedDirection(removeId(payload));
				break;
			case 22:
				receiveStop();
				break;
			case 23:
				receiveParking();
				break;
			case 24:
				receiveInstruction(removeId(payload));
				break;
			case 25:
				receiveDataRequest(removeId(payload));
				break;
			default:
				System.out.println("Unknown ID: " + id);
				break;
		}
	}

	/**
	 *  Removes the ID from the payload for further process. Shifts all entries to the left. ([1] becomes [0])
	 * @param payload payload of the UDP packet with ID at index [0]
	 * @return new payload without ID - (payload.length-1)
	 */
	private byte[] removeId(byte[] payload){
		byte[] array = new byte[payload.length-1];
		
		for(int i=0;i < array.length;i++){
            array[i] = payload[i+1];
		}
		return array;
	}
	
	private void receiveSpeedDirection(byte[] payload){
		car.setRxSpeed(payload[0]);
		car.setRxDirection(payload[1]);
	}
	
	private void receiveStop(){
		car.setStop(true);
	}
	
	private void receiveParking(){
		car.setPark(true);
	}
	
	private void receiveInstruction(byte[] payload){
		car.setRxInstruction(payload);
	}
	
	private synchronized void receiveDataRequest(byte[] payload){
		BitSet bits = new BitSet(4);
	    for (int i = 4; i < 8; i++)
	    {
	        bits.set(i, (payload[0] & 1) == 1);
	        payload[0] >>= 1;
	    }
	    
	    //assign true or false to the variable
	    speedRequested = bits.get(0);
	    gyroscopeRequested = bits.get(1);
	    distanceRequested = bits.get(2);
	    videoRequested = bits.get(3);
	}

	public boolean isSpeedRequested() {
		return speedRequested;
	}

	public boolean isGyroscopeRequested() {
		return gyroscopeRequested;
	}

	public boolean isDistanceRequested() {
		return distanceRequested;
	}

	public boolean isVideoRequested() {
		return videoRequested;
	}
}
