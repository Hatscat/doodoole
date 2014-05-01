package classes 
{
	import starling.events.Event;
	/**
	 * ...
	 * @author Hatscat
	 */
	public class BrokenStick extends Stick 
	{
	
		public function BrokenStick () 
		{
			super();
			this.color = 0x7C5A2C;
		}
		public function drop():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			this.alpha *= 0.9;
		}
		
		private function onRemove(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
	}

}