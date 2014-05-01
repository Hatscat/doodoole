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
	
	/**
	 * ...
	 * @author LB & MLR
	 */
	public class Credits extends Sprite implements IState 
	{
		private var game:Game;
		private var boutonRetour:Button;
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
			
			carre = new Quad(300, 300);
			carre.x = 200;
			carre.y = 200;
			carre.color = 0xDDDDDD;
			addChild(carre);
			carre.addEventListener(TouchEvent.TOUCH, onTouched);
		}
		
		private function onTouched(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			trace(touch.phase);
			
			if (touch.phase == TouchPhase.BEGAN)
			{
				carre.color = 0x00FFFF;
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				carre.color = 0x00FF00;
			}
			else if (touch.phase == TouchPhase.MOVED)
			{
				carre.color = 0xFFFF00;
			}
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
			
			carre.removeFromParent(true);
			carre = null;
			
			removeFromParent(true);
		}
		
	}

}