package 
{
	import core.Game;
	import flash.display.Sprite;
	import flash.events.Event;
	import interfaces.IState;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author LB & MLR
	 */
	[SWF(width=640, height=960, frameRate=60, backgroundColor=0xCCCCFF)]
	public class Main extends Sprite 
	{
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			var star:Starling = new Starling(Game, stage);
			star.antiAliasing = 1;
			star.showStats = false;
			star.simulateMultitouch = false;
			star.start();
		}
		
	}
	
}