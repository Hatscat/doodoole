package states 
{
	import core.Assets;
	import core.Game;
	import interfaces.IState;
	import flash.ui.Keyboard;
	import classes.Doodle;
	import classes.Stick;
	import classes.NormalStick;
	import classes.MovingStick;
	import starling.events.KeyboardEvent;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.core.Starling;
	import starling.text.TextField;
	import starling.utils.Color;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author LB & MLR
	 */
	public class Play extends Sprite implements IState 
	{
		private var game:Game;
		private var boutonRetour:Button;
		private var doodleMovie:classes.Doodle;
		private var touchesObj:Object = new Object();
		
		public static const xVelocityMax:int 	= 10;
		public static const yVelocityMax:int 	= 50;
		public static const GRAVITY:Number 		= 0.9;
		public static const INERTIA:Number 		= 0.7;
		public static const Score_w:int 		= 200;
		public static const Score_h:int 		= 75;
		
		private var time:Number;
		private var xVelocity:Number;
		private var yVelocity:Number;
		private var score:int;
		private var i:int;
		private var midStageY:int;
		private var canJump:Boolean;
		private var scoreText:TextField;
	
		private var normalStickArr:Vector.<NormalStick>;
		private var stageStickArr:Vector.<Stick>;
		private var movingStickArr:Vector.<MovingStick>;
		//private var brokenStickArr:Vector.<BrokenStick>;
		//private var glassStickArr:Vector.<GlassStick>;
		
		public function Play (pGame:Game) 
		{
			super();
			this.game = pGame;
			trace("play state");
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			midStageY = stage.stageHeight * 0.5;
			
			scoreText = new TextField(Score_w, Score_h, "text", "Arial", 24, Color.RED);
			scoreText.hAlign = HAlign.LEFT;
			scoreText.vAlign = VAlign.TOP;
			stage.addChild(scoreText);
			
			stage.addChild(Assets._SmokePartSystem);
			Starling.juggler.add(Assets._SmokePartSystem);
			
			doodleMovie = new Doodle();
			stage.addChild(doodleMovie);
			Starling.juggler.add(doodleMovie);
			
			stage.addChild(Assets._StarsPartSystem);
			Assets._StarsPartSystem.start();
			Starling.juggler.add(Assets._StarsPartSystem);
			
			// OPTIMISATION
			doodleMovie.touchable = false;
			
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
			
			restart();
		}
		
		private function resetGame () : void
		{
			stage.removeEventListener(Event.ENTER_FRAME, boucle);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			score = 0;
			time = 0;
			xVelocity = 0;
			canJump = true;
			yVelocity = yVelocityMax;
			doodleMovie.x = stage.stageWidth * 0.5;
			doodleMovie.y = stage.stageHeight * 0.9;
			Assets._SmokePartSystem.emitterX = Assets._StarsPartSystem.emitterX = doodleMovie.x;
			Assets._SmokePartSystem.emitterY = doodleMovie.y + doodleMovie.height / 4;
			Assets._StarsPartSystem.emitterY = doodleMovie.y;
			normalStickArr = new Vector.<NormalStick>;
			movingStickArr = new Vector.<MovingStick>;
			//brokenStickArr = new Vector.<BrokenStick>;
			//glassStickArr = new Vector.<GlassStick>;
			stageStickArr = new Vector.<Stick>;
			stageStickArr.push(new NormalStick());
			stage.addChild(stageStickArr[0]);
			stageStickArr[0].x = stage.stageWidth / 2;
			stageStickArr[0].y = stage.stageHeight - 30;
		}
		
		private function startGame () : void
		{
			// GESTION DES EVENTS
			stage.addEventListener(Event.ENTER_FRAME, boucle);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function restart () : void
		{
			resetGame();
			startGame();
		}
		
		private function boucle (e:Event) : void
		{
			time += 1 / 0.06; // stage.frameRate
			
			if (doodleMovie.y <= midStageY && yVelocity < 0)
			{
				doodleMovie.y = midStageY;
				//for each (var stick:Stick in stageStickArr)
					//stick.y -= yVelocity;
				score -= yVelocity;
				scoreText.text = String(score);
			}
			else
			{
				if (canJump)
				{
					canJump = false;
					yVelocity -= yVelocityMax;
				}
				doodleMovie.y += yVelocity;
			}
			
			doodleMovie.x += xVelocity;
			xVelocity *= INERTIA;
			yVelocity *= GRAVITY;
			
			//trace(yVelocity);
			
			
			if (touchesObj[Keyboard.RIGHT])
			{
				if ( !doodleMovie.isPlaying )
				{
					launchPlayAnim();
				}
				updatePlayAnim(1);
			}				
			else if (touchesObj[Keyboard.LEFT])
			{
				if ( !doodleMovie.isPlaying )
				{
					launchPlayAnim();
				}
				updatePlayAnim(-1);
			}
			else
			{
				doodleMovie.stop();
				Assets._SmokePartSystem.stop();
			}
			
			Assets._SmokePartSystem.emitterX = Assets._StarsPartSystem.emitterX = doodleMovie.x;
			Assets._SmokePartSystem.emitterY = Assets._StarsPartSystem.emitterY = doodleMovie.y;
		}
		
		
		private function onKeyDown (e:KeyboardEvent) : void
		{
			touchesObj[e.keyCode] = true;
		}
		
		private function onKeyUp (e:KeyboardEvent) : void
		{
			touchesObj[e.keyCode]= false;
		}
		
		private function launchPlayAnim ():void 
		{
			Assets._SmokePartSystem.start();
			doodleMovie.play();
		}
		
		private function updatePlayAnim (dir:Number) : void 
		{
			doodleMovie.scaleX = 1 * dir;
			xVelocity += xVelocityMax * dir;
			
			if (doodleMovie.x < 0)
			{
				doodleMovie.x = stage.stageWidth;
			}
			else if (doodleMovie.x > stage.stageWidth)
			{
				doodleMovie.x = 0;
			}
		}
		
		private function onTriggered(e:Event) : void
		{
			this.game.changeState(Game.MENU_STATE);
		}
		
		
		/* INTERFACE interfaces.IState */
		
		public function destroy () : void 
		{
			resetGame();
			scoreText.removeFromParent(true);
			scoreText = null;
			boutonRetour.removeFromParent(true);
			boutonRetour = null;
			doodleMovie.removeFromParent(true);
			doodleMovie = null;
			
			removeFromParent(true);
		}
		
	}

}