import java.io.IOException;
import java.net.DatagramPacket;
import java.net.InetAddress;

public class ClientThread implements Runnable{
	private InetAddress appIPv4;
	private int appPort;

	public ClientThread(InetAddress appIPv4, int appPort) {
		// TODO Auto-generated constructor stub
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub
		
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

}
