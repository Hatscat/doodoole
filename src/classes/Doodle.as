package classes 
{
	import core.Assets;
	import core.Game;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Lucien Boudy
	 */
	public class Doodle extends Sprite 
	{
		public var idle:MovieClip;
		public var jetPack:MovieClip;
		
		public function Doodle ()
		{
			idle = new MovieClip(Assets._nyanCatTextureAtlas.getTextures(Game.skin == 1 ? "nyanCatMod1_" : "nyanCatMod2_"), 15);
			idle.pivotX = this.width * 0.5;
			idle.pivotY = this.height * 0.5;
			
			jetPack = new MovieClip(Assets._nyanCatJetpackTextureAtlas.getTextures(Game.skin == 1 ? "nyanCatJetpackMod1_" : "nyanCatJetpackMod2_"), 15);
			jetPack.pivotX = this.width * 0.5;
			jetPack.pivotY = this.height * 0.5;
			jetPack.visible = false;
		}
	}
}