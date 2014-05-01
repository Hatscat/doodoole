package classes 
{
	import starling.core.Starling;
	import starling.events.Event;
	/**
	 * ...
	 * @author Hatscat
	 */
	public class BrokenStick extends Stick 
	{
	
		public function BrokenStick () 
		{
			super("plat_trap");
		}
		public function drop():void
		{
			this.play();
			this.addEventListener(Event.COMPLETE, destroy);
		}
		
		private function destroy(e:Event):void
		{
			this.removeEventListener(Event.COMPLETE, destroy);
			this.stop();
			Starling.juggler.remove(this);
			onRemove(null);
		}
		
		private function onRemove(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
	}

}