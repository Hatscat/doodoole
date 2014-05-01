package core
{
	import interfaces.IState;
	import starling.display.Sprite;
	import starling.events.Event;
	import states.Menu;
	import states.Play;
	import states.Shop;
	import states.Credits;
	
	/**
	 * ...
	 * @author LB & MLR
	 */
	public class Game extends Sprite
	{
		private var current_state:IState;
		public static const MENU_STATE : int 	= 0;
		public static const PLAY_STATE : int 	= 1;
		public static const SHOP_STATE : int 	= 2;
		public static const CREDITS_STATE : int = 3;
		public static var skin:int = 1;
		public static var skinOwn:Array = new Array(0, 1);

		public function Game()
		{
			super();
			Assets.init();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			changeState(MENU_STATE);
		}
		
		public function changeState(state:int):void
		{
			if(current_state != null)
			{
				current_state.destroy();
				current_state = null;
			}
			
			switch(state)
			{
				case MENU_STATE :
					current_state = new Menu(this);
					break;
					
				case PLAY_STATE :
					current_state = new Play(this);
					break;
					
				case SHOP_STATE :
					current_state = new Shop(this);
					break;
					
				case CREDITS_STATE :
					current_state = new Credits(this);
					break;
			}
			
			this.addChild(Sprite(current_state));
		}
	}
}