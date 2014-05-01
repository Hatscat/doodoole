package core
{
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.extensions.PDParticleSystem;

	public class Assets
	{
		[Embed(source="../../assets/btn.png")]
		private static const BtnSpriteSheet:Class;
	
		[Embed(source="../../assets/btn.xml",mimeType="application/octet-stream")]
		private static const BtnSpriteSheetXML:Class;
		
		[Embed(source="../../assets/menuBackground.png")]
		private static const menuBackground:Class;
		
		[Embed(source="../../assets/shopBackground.png")]
		private static const shopBackground:Class;
		
		[Embed(source="../../assets/creditBackground.png")]
		private static const creditBackground:Class;

		[Embed(source = "../../assets/sonic_LB.xml", mimeType = "application/octet-stream")]
		private static const SonicSpriteSheetXML:Class;
		[Embed(source="../../assets/sonic_LB.png")]
		private static const SonicSpriteSheet:Class;
		
		[Embed(source = "../../assets/particle.pex", mimeType = "application/octet-stream")]
		private static const SmokePartConfig:Class;
		[Embed(source = "../../assets/texture.png")]
		private static const SmokePartTex:Class;
		
		[Embed(source = "../../assets/particleetoile.pex", mimeType = "application/octet-stream")]
		private static const StarsPartConfig:Class;
		[Embed(source = "../../assets/textureetoile.png")]
		private static const StarsPartTex:Class;
		
		
		public static var _btnTextureAtlas:TextureAtlas;
		public static var _menuBackground:Texture;
		public static var _shopBackground:Texture;
		public static var _creditBackground:Texture;
		public static var _sonicTextureAtlas:TextureAtlas;
		public static var _SmokePartSystem:PDParticleSystem;
		public static var _StarsPartSystem:PDParticleSystem;
		
		public static function init():void
		{
			_btnTextureAtlas = new TextureAtlas(Texture.fromBitmap(new BtnSpriteSheet()), XML(new BtnSpriteSheetXML()));
			_menuBackground = Texture.fromBitmap(new menuBackground());
			_shopBackground = Texture.fromBitmap(new shopBackground());
			_creditBackground = Texture.fromBitmap(new creditBackground());
			_sonicTextureAtlas = new TextureAtlas(Texture.fromBitmap(new SonicSpriteSheet()), XML(new SonicSpriteSheetXML()));
			_SmokePartSystem = new PDParticleSystem (XML(new SmokePartConfig()), Texture.fromBitmap(new SmokePartTex()));
			_StarsPartSystem = new PDParticleSystem (XML(new StarsPartConfig()), Texture.fromBitmap(new StarsPartTex()));
		}
	}
}