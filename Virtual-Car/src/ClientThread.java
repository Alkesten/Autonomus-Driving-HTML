import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;

/**
 * Thread class for sending data via UDP to the app.
 * 
 * @author Moritz Kellermann (moritz.kellermann [at] in.tum.de)
 *
 */
public class ClientThread extends Thread{
	private InetAddress appIPv4;
	private int appPort;
	private VirtualCar car;
	private DatagramSocket dgramSocket;

	/**
	 * Create a new ClientThread object for outgoing UDP packets.
	 * 
	 * @param appIPv4 IPv4 address of the Node.js server
	 * @param appPort Port of the Node.js server (should be 1024 or higher)
	 * @param car the car itself for accessing data.
	 */
	public ClientThread(InetAddress appIPv4, int appPort, VirtualCar car) {
		this.car = car;
		this.appIPv4 = appIPv4;
		this.appPort = appPort;
		
		try {
			dgramSocket = new DatagramSocket(this.appPort);
		} catch (SocketException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void run() {
		while(true){
			if(car.server.isDistanceRequested())
				sendDistance();
			if(car.server.isGyroscopeRequested())
				sendGyroscope();
			if(car.server.isSpeedRequested())
				sendSpeed();
			if(car.server.isVideoRequested())
				sendVideo();
			
			try {
				sleep(1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * Creates a new array and adds the ID to Index [0].
	 * 
	 * @param id id of the service
	 * @param array buffer without the id
	 * @return the payload with the id at index [0] (array.length+1)
	 */
	private byte[] addId(byte id, byte[] array){
		byte[] payload = new byte[array.length + 1];
		payload[0] = id;
		for(int i=0;i < array.length;i++){
            payload[i+1] = array[i];
		}
		return payload;
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
		byte[] payload = addId(id,car.getSpeed());
		
		sendDatagram(payload);
	}
	
	public void sendGyroscope(){
		byte id = 0x0C;
		byte[] payload = addId(id,car.getGyroscop());

		sendDatagram(payload);
	}
	
	public void sendDistance(){
		byte id = 0x0D;
		byte[] payload = addId(id,car.getDistance());

		sendDatagram(payload);
	}
	
	public void sendVideo(){
		byte id = 0x0E;
		//TODO
	}
}
