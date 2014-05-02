package classes 
{
	import core.Assets;
	import core.Game;
	import starling.display.MovieClip;
	
	/**
	 * ...
	 * @author Lucien Boudy
	 */
	public class Doodle extends MovieClip 
	{
		public function Doodle ()
		{
			super(Assets._nyanCatTextureAtlas.getTextures(Game.skin == 1 ? "nyanCatMod1_" : "nyanCatMod2_"), 15);
			
			this.pivotX = this.width * 0.5;
			this.pivotY = this.height * 0.5;
		}
	}
}