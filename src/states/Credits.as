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
	
	/**
	 * ...
	 * @author LB & MLR
	 */
	public class Credits extends Sprite implements IState 
	{
		private var game:Game;
		private var boutonRetour:Button;
		private var creditBack:Image;
		private var carre:Quad;
		
		public function Credits(pGame:Game) 
		{
			super();
			this.game = pGame;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			creditBack = new Image(Assets._creditBackground);
			addChild(creditBack);
			boutonRetour = new Button(Assets._btnTextureAtlas.getTexture("btn_up"),
											"Retour",
											Assets._btnTextureAtlas.getTexture("btn_down"));
			boutonRetour.scaleWhenDown = 0.9;
			boutonRetour.pivotX = boutonRetour.width;
			boutonRetour.pivotY = 0;
			boutonRetour.fontColor = 0x000000;
			boutonRetour.fontSize = 30;
			boutonRetour.x = stage.stageWidth/2 + 0.5*boutonRetour.width;
			boutonRetour.y = 110;
			boutonRetour.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(boutonRetour);
			
		}
		
		private function onTriggered(e:Event):void
		{
			this.game.changeState(Game.MENU_STATE);
		}
		
		/* INTERFACE interfaces.IState */
		
		public function destroy():void 
		{
			boutonRetour.removeFromParent(true);
			boutonRetour = null;
			
			creditBack.removeFromParent(true);
			creditBack = null;
			
			removeFromParent(true);
		}
		
	}

}