package classes 
{
	import starling.display.MovieClip;
	import core.Assets;
	
	/**
	 * ...
	 * @author Hatscat
	 */
	public class Bonus extends MovieClip 
	{
		public var kind:int = 0; // 1 = ressorts, 2 = chaussures, 3 = jetpack
		
		public function Bonus (textureToGet:String) : void
		{
			super(Assets._itemsTextureAtlas.getTextures(textureToGet), 10);
			
			this.pivotX = this.width * 0.5;
			this.pivotY = this.height;
		}
		
	}

}