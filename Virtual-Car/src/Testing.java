import java.net.InetAddress;
import java.net.UnknownHostException;

/**
 * 
 * @author Moritz Kellermann (moritz.kellermann [at] in.tum.de)
 *
 */
public class Testing {
	
	static private VirtualCar car;
	
	public static void main(String [] args){
		byte[] distance = new byte[] {0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08};
		byte[] speed = new byte[] {0x64,0x64,0x64,0x64};
		byte[] xyz = new byte[] {0x01,0x02,0x03};
		
		int appPort = 33333;
		int carPort = 33334;
		
		byte[] appIPv4RAW = new byte[] {127,0,0,1}; //Address of the VM
		InetAddress appIPv4;
		try {
			appIPv4 = InetAddress.getByAddress(appIPv4RAW);
			car = new VirtualCar(appIPv4,appPort,carPort,distance,speed,xyz);
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
