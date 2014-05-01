package states 
{
	import core.Assets;
	import core.Game;
	import interfaces.IState;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author LB & MLR
	 */
	public class Shop extends Sprite implements IState 
	{
		private var game:Game;
		private var shopBack:Image;
		private var boutonRetour:Button;
		private var boutonSkin1:Button;
		private var boutonSkin2:Button;
		
		public function Shop(pGame:Game) 
		{
			super();
			this.game = pGame;
			trace("Shop");
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			shopBack = new Image(Assets._shopBackground);
			addChild(shopBack);
			
			boutonRetour = new Button(Assets._btnTextureAtlas.getTexture("btn_up"),
											"Retour",
											Assets._btnTextureAtlas.getTexture("btn_down"));
			boutonRetour.scaleWhenDown = 0.9;
			boutonRetour.pivotX = boutonRetour.width;
			boutonRetour.pivotY = 0;
			boutonRetour.fontColor = 0x000000;
			boutonRetour.x = stage.stageWidth/2 + 0.5*boutonRetour.width;
			boutonRetour.y = 110;
			boutonRetour.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(boutonRetour);
			
			boutonSkin1 = new Button(Assets._btnTextureAtlas.getTexture("btn_up"),
										(Game.skin == 1 ? "I Wear It" : Game.skinOwn.indexOf(1) != -1 ? "I HAS IT" : "I Should Buy It"),
										Assets._btnTextureAtlas.getTexture("btn_down"));
			boutonSkin1.scaleWhenDown = 0.9;
			boutonSkin1.fontColor = 0x000000;
			boutonSkin1.x = 50;
			boutonSkin1.y = 500;
			boutonSkin1.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(boutonSkin1);
			
			boutonSkin2 = new Button(Assets._btnTextureAtlas.getTexture("btn_up"),
									(Game.skin == 2 ? "I Wear It" : Game.skinOwn.indexOf(2) != -1 ? "I HAS IT" : "I Should Buy It"),
									Assets._btnTextureAtlas.getTexture("btn_down"));
			boutonSkin2.scaleWhenDown = 0.9;
			boutonSkin2.fontColor = 0x000000;
			boutonSkin2.x = 410;
			boutonSkin2.y = 500;
			boutonSkin2.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(boutonSkin2);
			
			//stage.addEventListener(TouchEvent.TOUCH, onTouched);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			// Starling.current.nativeStage accède à la display list de Flash
		}
		
		/*private function onTouched(e:TouchEvent):void
		{
		
		}*/
		
		private function onTriggered(e:Event):void
		{
			//stage.removeEventListener(TouchEvent.TOUCH, onTouched);
			//on regarde quel élément on a cliqué
			switch(e.target as Button)
			{
				case boutonRetour:
					stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					this.game.changeState(Game.MENU_STATE);
				break;
				
				case boutonSkin1:
					Game.skin = 1;
					boutonSkin1.text = "I Wear It";
					boutonSkin2.text = Game.skinOwn.indexOf(2) != -1 ? "I HAS IT" : "I Should Buy It";
				break;
				
				case boutonSkin2:
					Game.skin = 2;
					Game.skinOwn.push(2);
					boutonSkin1.text = Game.skinOwn.indexOf(1) != -1 ? "I HAS IT" : "I Should Buy It";
					boutonSkin2.text = "I Wear It";
				break;
				
			}

		}
		
		/* INTERFACE interfaces.IState */
		
		public function destroy():void 
		{
			boutonRetour.removeFromParent(true);
			boutonRetour = null;

			removeFromParent(true);
		}
		
	}

}