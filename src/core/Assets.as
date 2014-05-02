package core
{
	import flash.media.Sound;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.extensions.PDParticleSystem;

	public class Assets
	{
		[Embed(source="../../assets/btn.png")]
		private static const BtnSpriteSheet:Class;
	
		[Embed(source="../../assets/btn.xml",mimeType="application/octet-stream")]
		private static const BtnSpriteSheetXML:Class;
		
		[Embed(source="../../assets/platformes.png")]
		private static const PlateformesSpriteSheet:Class;
		
		[Embed(source="../../assets/platformes.xml",mimeType="application/octet-stream")]
		private static const PlateformeSpriteSheetXML:Class;
		
		[Embed(source="../../assets/items.png")]
		private static const ItemsSpriteSheet:Class;
		
		[Embed(source="../../assets/items.xml",mimeType="application/octet-stream")]
		private static const ItemsSpriteSheetXML:Class;
		
		[Embed(source="../../assets/menuBackground.png")]
		private static const menuBackground:Class;
		
		[Embed(source="../../assets/shopBackground.png")]
		private static const shopBackground:Class;
		
		[Embed(source="../../assets/creditBackground.png")]
		private static const creditBackground:Class;
		
		[Embed(source="../../assets/gameBackground.png")]
		private static const playBackground:Class;

		[Embed(source = "../../assets/nyanCat.xml", mimeType = "application/octet-stream")]
		private static const nyanCatSpriteSheetXML:Class;
		[Embed(source="../../assets/nyanCat.png")]
		private static const nyanCatSpriteSheet:Class;
		
		[Embed(source = "../../assets/nyanCatJetpack.xml", mimeType = "application/octet-stream")]
		private static const nyanCatJetpackSpriteSheetXML:Class;
		[Embed(source="../../assets/nyanCatJetpack.png")]
		private static const nyanCatJetpackSpriteSheet:Class;
		
		[Embed(source = "../../assets/particle.pex", mimeType = "application/octet-stream")]
		private static const SmokePartConfig:Class;
		[Embed(source = "../../assets/texture.png")]
		private static const SmokePartTex:Class;
		
		[Embed(source = "../../assets/particleetoile.pex", mimeType = "application/octet-stream")]
		private static const StarsPartConfig:Class;
		[Embed(source = "../../assets/textureetoile.png")]
		private static const StarsPartTex:Class;
		
		public static var _btnTextureAtlas:TextureAtlas;
		public static var _plateformesTextureAtlas:TextureAtlas;
		public static var _itemsTextureAtlas:TextureAtlas;
		public static var _menuBackground:Texture;
		public static var _playBackground:Texture;
		public static var _shopBackground:Texture;
		public static var _creditBackground:Texture;
		public static var _nyanCatTextureAtlas:TextureAtlas;
		public static var _nyanCatJetpackTextureAtlas:TextureAtlas;
		public static var _SmokePartSystem:PDParticleSystem;
		public static var _StarsPartSystem:PDParticleSystem;
		
		
		[Embed(source="../../audio/nyanCat.mp3")]
		private static const NyanCat:Class;
		
		[Embed(source="../../audio/aaarg.mp3")]
		private static const Aaarg:Class;
		
		[Embed(source="../../audio/crack.mp3")]
		private static const Crack:Class;
		
		[Embed(source="../../audio/spowing.mp3")]
		private static const Spowing:Class;
		
		[Embed(source="../../audio/wouuiii.mp3")]
		private static const Wouuiii:Class;
		
		public static var _nyanCat:Sound;
		public static var _aaarg:Sound;
		public static var _crack:Sound;
		public static var _wouuiii:Sound;
		public static var _spowing:Sound;
		
		public static function init():void
		{
			_btnTextureAtlas = new TextureAtlas(Texture.fromBitmap(new BtnSpriteSheet()), XML(new BtnSpriteSheetXML()));
			_plateformesTextureAtlas = new TextureAtlas(Texture.fromBitmap(new PlateformesSpriteSheet()), XML(new PlateformeSpriteSheetXML()));
			_itemsTextureAtlas = new TextureAtlas(Texture.fromBitmap(new ItemsSpriteSheet()), XML(new ItemsSpriteSheetXML()));
			_menuBackground = Texture.fromBitmap(new menuBackground());
			_playBackground = Texture.fromBitmap(new playBackground());
			_shopBackground = Texture.fromBitmap(new shopBackground());
			_creditBackground = Texture.fromBitmap(new creditBackground());
			_nyanCatTextureAtlas = new TextureAtlas(Texture.fromBitmap(new nyanCatSpriteSheet()), XML(new nyanCatSpriteSheetXML()));
			_nyanCatJetpackTextureAtlas = new TextureAtlas(Texture.fromBitmap(new nyanCatJetpackSpriteSheet()), XML(new nyanCatJetpackSpriteSheetXML()));
			_SmokePartSystem = new PDParticleSystem (XML(new SmokePartConfig()), Texture.fromBitmap(new SmokePartTex()));
			_StarsPartSystem = new PDParticleSystem (XML(new StarsPartConfig()), Texture.fromBitmap(new StarsPartTex()));
			
			_nyanCat = new NyanCat();
			_aaarg = new Aaarg();
			_crack = new Crack();
			_wouuiii = new Wouuiii();
			_spowing = new Spowing();
		}
	}
}