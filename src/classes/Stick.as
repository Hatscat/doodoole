package classes 
{
	import starling.display.Quad;

	/**
	 * ...
	 * @author Lucien Boudy
	 */
	public class Stick extends Quad 
	{
		public static const STICK_WIDTH:int 	= 80;
		static public const STICK_HEIGHT:int 	= 16;
		
		public function Stick () : void
		{
			super(STICK_WIDTH, STICK_HEIGHT);
			
			this.pivotX = this.width * 0.5;
			this.pivotY = this.height * 0.5;
		}
	}
}

