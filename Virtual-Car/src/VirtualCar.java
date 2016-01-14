import java.net.InetAddress;

/**
 * Emulates the autonomous car for testing purpose.
 * 
 * @author Moritz Kellermann (moritz.kellermann [at] in.tum.de)
 *
 */
public class VirtualCar {
	//data for transmission to the app
	private byte[] distance = new byte[8];
	private byte[] xyz = new byte[3]; //gyroscope oder: [x,y,z]
	private byte[] speed = new byte[4]; //order: [front left, front right, back left, back right]
	
	//received data from the app
	private byte[] rxInstruction; //tour instructions
	private byte rxSpeed,rxDirection; //speed and direction in percent (0-100)
	private boolean stop,park; //true if the car should stop or park

	//Thread objects
	protected ServerThread server;
	protected ClientThread client;
	protected Thread serverThread, clientThread;
	
	/**
	 * Creates an new VirtualCar object with server/client threads and hardcoded values of distance, speed and gyroscope
	 * 
	 * @param appIPv4 IPv4 address of the Node.js server
	 * @param appPort Port of the Node.js server (should be 1024 or higher)
	 * @param carPort UDP Port of the car server socket (should be 1024 or higher)
	 */
	public VirtualCar(InetAddress appIPv4, int appPort, int carPort){
		setDistance(new byte[] {0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08});
		setSpeed(new byte[] {0x64,0x64,0x64,0x64}); //100(%) for all wheels = 0x64
		setGyroscope(new byte[] {0x01,0x02,0x03});
		
		createThread(appIPv4, appPort, carPort);
		startThreads();
	}
	
	/**
	 * Creates an new VirtualCar object with server/client threads.
	 * 
	 * @param appIPv4 IPv4 address of the Node.js server
	 * @param appPort Port of the Node.js server (should be 1024 or higher)
	 * @param carPort UDP Port of the car server socket (should be 1024 or higher)
	 * @param distance initial distance data of the car.
	 * @param speed initial speed data of the car.
	 * @param xyz initial gyroscope data of the car.
	 */
	public VirtualCar(InetAddress appIPv4, int appPort, int carPort, byte[] distance, byte[] speed, byte[] xyz){
		setDistance(distance);
		setSpeed(speed);
		setGyroscope(xyz);
		
		createThread(appIPv4, appPort, carPort);
		startThreads();
	}
	
	/**
	 * Creates new threads without starting 
	 */
	private void createThread(InetAddress appIPv4, int appPort, int carPort){
		server = new ServerThread(carPort, this);
		client = new ClientThread(appIPv4, appPort, this);
		
		serverThread = new Thread(server);
		clientThread = new Thread(client);
	}
	
	/**
	 * Starts client and server thread
	 */
	private void startThreads(){
		serverThread.start();
		clientThread.start();
	}
	
	/**
	 * @return actual distance of the car in following order: [d1,d2,d3,d4,d5,d6,d7,d8].
	 */
	public byte[] getDistance() {
		return distance;
	}
	
	/**
	 * Should only be called by sensors.
	 * 
	 * @param distance actual distance of the car in following order: [d1,d2,d3,d4,d5,d6,d7,d8].
	 */
	protected void setDistance(byte[] distance){
		for(int i=0; i<8; i++){
			this.distance[i] = distance[i];
		}
	}
	
	/**
	 * @return actual speed of the car in following order: [front left, front right, back left, back right].
	 */
	public byte[] getSpeed() {
		return speed;
	}
	
	/**
	 * Should only be called by sensors.
	 * 
	 * @param speed actual speed of the car in following order: [front left, front right, back left, back right].
	 */
	protected void setSpeed(byte[] speed){
		for(int i=0; i<4; i++){
			this.speed[i] = speed[i];
		}
	}
	
	/**
	 * 
	 * @return actual gyroscope values in following order: [x,y,z].
	 */
	public byte[] getGyroscop() {
		return xyz;
	}
	
	/**
	 * Should only be called by sensors.
	 * 
	 * @param xyz actual gyroscope values in following order: [x,y,z].
	 */
	protected void setGyroscope(byte[] xyz){
		for(int i=0; i<3; i++){
			this.xyz[i] = xyz[i];
		}
	}

	/**
	 * 
	 * @return array of the received instructions.
	 */
	public byte[] getRxInstruction() {
		return rxInstruction;
	}

	/**
	 * 
	 * @param rxInstruction range between 0 and 4: 0 = turn left, 1 = go straight, 2 = turn right, park = 3, stop = 4
	 */
	public void setRxInstruction(byte[] rxInstruction) {
		this.rxInstruction = rxInstruction;
		
		byte number = rxInstruction[0];
		rxInstruction[0] = (byte)0xFF;
		
		System.out.println("number of instructions: "+number);
		for(byte cmd : rxInstruction){
			switch(cmd)
			{
			case 0:
				System.out.println("left");
				break;
			case 1:
				System.out.println("straight");
				break;
			case 2:
				System.out.println("right");
				break;
			case 3:
				System.out.println("park");
				break;
			case 4:
				System.out.println("stop");
				break;
			case (byte)0xFF:
				//deleted number of instructions
				break;
			default:
				System.err.println("error in instruction: " + cmd);
				break;
			}
		}
	}

	/**
	 * 
	 * @return received speed in percent (0-100)
	 */
	public byte getRxSpeed() {
		return rxSpeed;
	}

	/**
	 * 
	 * @param rxSpeed sets the received speed in percent (0-100)
	 */
	public void setRxSpeed(byte rxSpeed) {
		this.rxSpeed = rxSpeed;
		System.out.println("new rxSpeed: "+this.rxSpeed);
	}
	
	/**
	 * 
	 * @return received direction: range between 0 and 100: where 0-49 is left and 51-100 right, 50 is straight
	 */
	public byte getRxDirection() {
		return rxDirection;
	}

	/**
	 * 
	 * @param rxDirection received direction: range between 0 and 100: where 0-49 is left and 51-100 right, 50 is straight
	 */
	public void setRxDirection(byte rxDirection) {
		this.rxDirection = rxDirection;
		System.out.println("new rxDirection: "+this.rxDirection);
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
