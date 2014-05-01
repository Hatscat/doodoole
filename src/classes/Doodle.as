package classes 
{
	import core.Assets;
	import starling.display.MovieClip;
	
	/**
	 * ...
	 * @author Lucien Boudy
	 */
	public class Doodle extends MovieClip 
	{
		public function Doodle ()
		{
			super(Assets._nyanCatTextureAtlas.getTextures("nyanCat"), 15);
			
			this.pivotX = this.width * 0.5;
			this.pivotY = this.height * 0.5;
		}
	}
}