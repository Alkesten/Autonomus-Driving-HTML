import java.net.InetAddress;

/**
 * 
 * @author Moritz Kellermann
 *
 */
public class VirtualCar {
	//variables for transmission
	private byte[] distance = new byte[8]; //distances
	private byte[] xyz = new byte[3]; //gyroscope
	private byte[] speed = new byte[4]; //speed front and back, left and right
	
	//received variables
	private byte[] rxInstruction; //tour instructions
	private byte rxSpeed,rxDirection; //speed and direction in percent
	private boolean stop,park;
	//private boolean speedRequested,gyroscopeRequested,distanceRequested,videoRequested; 
	
	protected ServerThread server;
	protected ClientThread client;
	protected Thread serverThread, clientThread;
	
	public VirtualCar(InetAddress appIPv4, int appPort, int carPort){
		setDistance(new byte[] {0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08});
		setSpeed(new byte[] {0x64,0x64,0x64,0x64}); //100% for all wheels =0x64
		setGyroscope(new byte[] {0x01,0x02,0x03});
		
		createThread(appIPv4, appPort, carPort);
		startThreads();
	}
	
	public VirtualCar(InetAddress appIPv4, int appPort, int carPort, byte[] distance, byte[] speed, byte[] xyz){
		setDistance(distance);
		setSpeed(speed);
		setGyroscope(xyz);
		
		createThread(appIPv4, appPort, carPort);
		startThreads();
	}
	
	private void createThread(InetAddress appIPv4, int appPort, int carPort){
		server = new ServerThread(carPort, this);
		client = new ClientThread(appIPv4, appPort, this);
		
		serverThread = new Thread(server);
		clientThread = new Thread(client);
	}
	
	private void startThreads(){
		serverThread.start();
		clientThread.start();
	}
	
	public byte[] getDistance() {
		return distance;
	}
	
	public void setDistance(byte[] distance){
		for(int i=0; i<8; i++){
			this.distance[i] = distance[i];
		}
	}
	
	public byte[] getSpeed() {
		return speed;
	}
	
	public void setSpeed(byte[] speed){
		for(int i=0; i<4; i++){
			this.speed[i] = speed[i];
		}
	}
	
	public byte[] getGyroscop() {
		return xyz;
	}
	
	public void setGyroscope(byte[] xyz){
		for(int i=0; i<3; i++){
			this.xyz[i] = xyz[i];
		}
	}

	public byte[] getRxInstruction() {
		return rxInstruction;
	}

	public void setRxInstruction(byte[] rxInstruction) {
		this.rxInstruction = rxInstruction;
	}

	public byte getRxSpeed() {
		return rxSpeed;
	}

	public void setRxSpeed(byte rxSpeed) {
		this.rxSpeed = rxSpeed;
	}
	
	public byte getRxDirection() {
		return rxDirection;
	}

	public void setRxDirection(byte rxDirection) {
		this.rxDirection = rxDirection;
	}

	public boolean isStop() {
		return stop;
	}

	public void setStop(boolean stop) {
		this.stop = stop;
	}

	public boolean isPark() {
		return park;
	}

	public void setPark(boolean park) {
		this.park = park;
	}
}
