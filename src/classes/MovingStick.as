package classes 
{
	/**
	 * ...
	 * @author Hatscat
	 */
	public class MovingStick extends Stick 
	{
		public var hVelocity:Number = 0;
		public static const SPEED_X:Number = 3.5;
	
		public function MovingStick () 
		{
			super("plat_move");
			hVelocity = Math.random() > 0.5 ? SPEED_X : -SPEED_X;
		}
		
	}

}