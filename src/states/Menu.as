package states 
{
	import core.Game;
	import interfaces.IState;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import core.Assets;
	
	/**
	 * ...
	 * @author LB & MLR
	 */
	public class Menu extends Sprite implements IState 
	{

		private var game:Game;
		private var boutonPlay:Button;
		private var boutonShop:Button;
		private var menuBack:Image;
		private var boutonCredits:Button;

		public function Menu(pGame:Game) 
		{
			super();
			this.game = pGame;
			//trace("Menu constructeur");
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Création d'un objet du type bouton
			// en paramètres, 3 params, dont les deux derniers sont facultatifs
			// 1 - Texture à l'état haut
			// 2 - Texte du bouton
			// 3 - Texture à l'état bas
			menuBack = new Image(Assets._menuBackground);
			addChild(menuBack);
			
			boutonPlay = new Button(Assets._btnTextureAtlas.getTexture("btn_up"),
											"Play",
											Assets._btnTextureAtlas.getTexture("btn_down"));
			// Le coefficient de zoom lorsqu'on clique
			boutonPlay.scaleWhenDown = 0.9;
			boutonPlay.pivotX = boutonPlay.width * 0.5;
			boutonPlay.pivotY = boutonPlay.height * 0.5;
			boutonPlay.fontColor = 0x000000;
			boutonPlay.x = stage.stageWidth * 0.5;
			boutonPlay.y = stage.stageHeight *0.5 - boutonPlay.height/2 - 100;
			boutonPlay.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(boutonPlay);
			
			boutonShop = new Button(Assets._btnTextureAtlas.getTexture("btn_up"),
											"Shop",
											Assets._btnTextureAtlas.getTexture("btn_down"));
			boutonShop.scaleWhenDown = 0.9;
			boutonShop.pivotX = boutonShop.width * 0.5;
			boutonShop.pivotY = boutonShop.height * 0.5;
			boutonShop.fontColor = 0x000000;
			boutonShop.x = stage.stageWidth * 0.5;
			boutonShop.y = stage.stageHeight *0.5 - boutonPlay.height/2;
			boutonShop.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(boutonShop);
			
			boutonCredits = new Button(Assets._btnTextureAtlas.getTexture("btn_up"),
											"Credits",
											Assets._btnTextureAtlas.getTexture("btn_down"));
			boutonCredits.scaleWhenDown = 0.9;
			boutonCredits.pivotX = boutonCredits.width * 0.5;
			boutonCredits.pivotY = boutonCredits.height * 0.5;
			boutonCredits.fontColor = 0x000000;
			boutonCredits.x = stage.stageWidth * 0.5;
			boutonCredits.y = stage.stageHeight *0.5 - boutonPlay.height/2 + 100;
			boutonCredits.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(boutonCredits);
			
		}
		
		private function onTriggered(e:Event):void
		{
			switch(e.currentTarget)
			{
				case boutonPlay:
					this.game.changeState(Game.PLAY_STATE);
					break;

				case boutonShop:
					this.game.changeState(Game.SHOP_STATE);
					break;

				case boutonCredits:
					this.game.changeState(Game.CREDITS_STATE);
					break;
			}			
		}
		
		/* INTERFACE interfaces.IState */
		
		public function destroy():void 
		{
			// Libère les ressources utilisées par le bouton
			// ainsi que les listeners
			boutonPlay.removeFromParent(true);
			boutonPlay = null;
			
			boutonShop.removeFromParent(true);
			boutonShop = null;
			
			boutonCredits.removeFromParent(true);
			boutonCredits = null;

			removeFromParent(true);
		}
		
	}

}