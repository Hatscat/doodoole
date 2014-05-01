package classes 
{
	import starling.display.MovieClip;
	import core.Assets;

	/**
	 * ...
	 * @author Lucien Boudy
	 */
	public class Stick extends MovieClip
	{
		public static const STICK_WIDTH:int 	= 80;
		static public const STICK_HEIGHT:int 	= 16;
		
		public function Stick (textureToGet:String) : void
		{
			super(Assets._plateformesTextureAtlas.getTextures(textureToGet), 10);
			
			this.pivotX = this.width * 0.5;
			this.pivotY = this.height * 0.5;
		}
	}
}

