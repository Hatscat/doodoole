package states 
{
	import core.Assets;
	import core.Game;
	import interfaces.IState;
	import starling.display.Button;
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
		private var boutonRetour:Button;
		
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
			
			boutonRetour = new Button(Assets._btnTextureAtlas.getTexture("btn_up"),
											"Retour",
											Assets._btnTextureAtlas.getTexture("btn_down"));
			boutonRetour.scaleWhenDown = 0.9;
			boutonRetour.pivotX = boutonRetour.width;
			boutonRetour.pivotY = 0;
			boutonRetour.fontColor = 0xffffff;
			boutonRetour.x = stage.stageWidth;
			boutonRetour.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(boutonRetour);
			
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
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.game.changeState(Game.MENU_STATE);
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