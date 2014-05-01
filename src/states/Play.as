package states 
{
	import core.Assets;
	import core.Game;
	import interfaces.IState;
	import flash.ui.Keyboard;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import classes.Doodle;
	import classes.Stick;
	import classes.NormalStick;
	import classes.MovingStick;
	import classes.BrokenStick;
	import classes.GlassStick;
	import starling.display.Image;
	import starling.events.KeyboardEvent;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.core.Starling;
	import starling.utils.RectangleUtil;
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
		private var boutonMenu:Button;
		private var boutonRestart:Button;
		private var doodleMovie:classes.Doodle;
		private var touchesObj:Object = new Object();
		
		public static const xVelocityMax:int 		= 5;
		public static const yVelocityMax:int 		= 21;
		public static const yVelocityMax_2:int 		= 50;
		public static const GRAVITY:Number 			= 0.7;
		public static const INERTIA:Number 			= 0.7;
		public static const Score_w:int 			= 200;
		public static const Score_h:int 			= 75;
		public static const score2SpawnBigOnes:int 	= 90000;
		//public static const oneSecond:int 			= 1000;
		public static const oneSecond:int 			= 1000;
		
		private var inputTimer:Number;
		private var jetpackTimer:Number;
		private var shoesTimer:Number;
		private var deltaTime:Number;
		private var oldTime:Number;
		private var I_AM_GOD:Boolean;
		private var big_jump:Boolean;
		private var jetpack_jump:Boolean;
		private var xVelocity:Number;
		private var yVelocity:Number;
		private var lastFeetPosY:Number;
		private var score:int;
		private var i:int;
		private var midStageY:int;
		private var scoreText:TextField;
		private var playBackground:Image;
		
		private var normalStickArr:Vector.<NormalStick>;
		private var stageStickArr:Vector.<Stick>;
		private var movingStickArr:Vector.<MovingStick>;
		private var brokenStickArr:Vector.<BrokenStick>;
		private var glassStickArr:Vector.<GlassStick>;
		
		public function Play (pGame:Game) 
		{
			super();
			this.game = pGame;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event) : void
		{
			playBackground = new Image(Assets._playBackground);
			addChild(playBackground);
			
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
			
			restart();
		}
		
		private function resetGame () : void
		{
			stage.removeEventListener(Event.ENTER_FRAME, boucle);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			I_AM_GOD = false;
			jetpack_jump = false;
			big_jump = false;
			score = 0;
			xVelocity = 0;
			yVelocity = yVelocityMax;
			lastFeetPosY = 0;
			inputTimer = 0;
			jetpackTimer = 0;
			shoesTimer = 0;
			deltaTime = 0;
			oldTime = getTimer();
			doodleMovie.x = stage.stageWidth * 0.5;
			doodleMovie.y = stage.stageHeight * 0.9;
			Assets._SmokePartSystem.emitterX = Assets._StarsPartSystem.emitterX = doodleMovie.x;
			Assets._SmokePartSystem.emitterY = doodleMovie.y + doodleMovie.height / 4;
			Assets._StarsPartSystem.emitterY = doodleMovie.y;
			normalStickArr = new Vector.<NormalStick>;
			movingStickArr = new Vector.<MovingStick>;
			brokenStickArr = new Vector.<BrokenStick>;
			glassStickArr = new Vector.<GlassStick>;
			stageStickArr = new Vector.<Stick>;
			stageStickArr.push(new NormalStick());
			stage.addChild(stageStickArr[0]);
			stageStickArr[0].x = Math.random() * (stage.stageWidth - Stick.STICK_WIDTH) + Stick.STICK_WIDTH * 0.5;
			stageStickArr[0].y = stage.stageHeight * 0.8;
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
		
		private function gameOver () : void
		{
			//stage.addChild(gameOverPanel);
			//so.data["highScores"] = so.data["highScores"].sortOn("score",Array.NUMERIC+Array.DESCENDING);
			//gameOverPanel.loadHighScore(so.data["highScores"]);
			
			stage.removeEventListener(Event.ENTER_FRAME, boucle);
			
			boutonMenu = new Button(Assets._btnTextureAtlas.getTexture("btn_up"),
											"Menu",
											Assets._btnTextureAtlas.getTexture("btn_down"));
			boutonMenu.scaleWhenDown = 0.9;
			boutonMenu.pivotX = boutonMenu.width * 0.5;
			boutonMenu.pivotY = boutonMenu.height * 0.5;
			boutonMenu.fontColor = 0xffffff;
			boutonMenu.x = stage.stageWidth * 0.5;
			boutonMenu.y = stage.stageHeight * 0.6;
			boutonMenu.addEventListener(Event.TRIGGERED, onMenuBtnTriggered);
			addChild(boutonMenu);
			
			boutonRestart = new Button(Assets._btnTextureAtlas.getTexture("btn_up"),
											"Restart",
											Assets._btnTextureAtlas.getTexture("btn_down"));
			boutonRestart.scaleWhenDown = 0.9;
			boutonRestart.pivotX = boutonRestart.width * 0.5;
			boutonRestart.pivotY = boutonRestart.height * 0.5;
			boutonRestart.fontColor = 0xffffff;
			boutonRestart.x = stage.stageWidth * 0.5;
			boutonRestart.y = stage.stageHeight * 0.7;
			boutonRestart.addEventListener(Event.TRIGGERED, onRestartTriggered);
			addChild(boutonRestart);
			
		}
		
		private function boucle (e:Event) : void
		{
			deltaTime = (getTimer() - oldTime) * 0.06 || 1; // scalé sur 60fps
			oldTime = getTimer();
			
			if (jetpack_jump)
			{
				yVelocity = -yVelocityMax_2;
			}
			
			if (doodleMovie.y <= midStageY && yVelocity < 0)
			{
				doodleMovie.y = midStageY;
				for each (var stick:Stick in stageStickArr)
					stick.y -= yVelocity;
				score -= yVelocity;
				scoreText.text = String(score);
			}
			else
			{
				for (i = 0; i < 2; i++) //incase break through
				{
					if (yVelocity > 0) // en chute == peut collisionner
					{
						var doodle_box:Rectangle = doodleMovie.getBounds(this);
						
						for each (stick in stageStickArr)
						{
							var stick_box:Rectangle = stick.getBounds(this);
						
							if ((doodle_box.intersects(stick_box) && lastFeetPosY < stick.y - stick.pivotY)// collision
								|| (doodleMovie.y > stage.stageHeight - doodleMovie.pivotY) // en bas
									&& (I_AM_GOD || !score))
							{
								if (stick is BrokenStick)
										BrokenStick(stick).drop();
								else
								{
									yVelocity = big_jump ? -yVelocityMax_2 : -yVelocityMax;
									if (stick is GlassStick)
										stick.y = stage.stageHeight + 200;
								}
							}
							else if (doodleMovie.y > stage.stageHeight + doodleMovie.pivotY) // death
							{
								//trace ("t'es mort !");
								gameOver();
							}
						}
					}
					else
					{
						lastFeetPosY = doodleMovie.y + doodleMovie.pivotY;
					}
				}
				
				doodleMovie.y += yVelocity * deltaTime;
			}
			
			//moving sticks  the Math.random()<0.01 drive them crazy
			for each (stick in stageStickArr)
			{
				if (stick is MovingStick)
				{
					var temp:MovingStick = stick as MovingStick;
					temp.x += temp.hVelocity;
					if ((temp.x > stage.stageWidth - temp.width) && temp.hVelocity > 0 || (temp.x < temp.width) && temp.hVelocity < 0 || Math.random() < 0.01)
						temp.hVelocity *= -1;
				}
			}
			
			refreashSticks();
			
			doodleMovie.x += xVelocity * deltaTime;
			xVelocity *= INERTIA;
			yVelocity += GRAVITY * deltaTime;
			
			if (touchesObj[Keyboard.RIGHT])
			{

				launchPlayAnim();

				updatePlayAnim(1);
			}				
			else if (touchesObj[Keyboard.LEFT])
			{

				launchPlayAnim();
				updatePlayAnim(-1);
			}
			else
			{
				/*doodleMovie.stop();*/
				Assets._SmokePartSystem.stop();
				
				if (touchesObj[Keyboard.G] && inputTimer < getTimer())
				{
					inputTimer = getTimer() + oneSecond * 0.5;
					I_AM_GOD = !I_AM_GOD;
				}
				if (touchesObj[Keyboard.J] && I_AM_GOD && inputTimer < getTimer())
				{
					inputTimer = getTimer() + oneSecond;
					jetpack_jump = !jetpack_jump;
				}
				
			}
			
			Assets._SmokePartSystem.emitterX = Assets._StarsPartSystem.emitterX = doodleMovie.x;
			Assets._SmokePartSystem.emitterY = Assets._StarsPartSystem.emitterY = doodleMovie.y;
		}
		
		private function refreashSticks():void
		{
			var stick:Stick;
			//add new sticks
			while (stageStickArr[0].y > stage.stageHeight)
			{
				stage.removeChild(stageStickArr[0]);
				stick = stageStickArr.shift();
				if (stick is NormalStick)
					normalStickArr.push(stick);
				else if (stick is MovingStick)
					movingStickArr.push(stick);
				else if (stick is GlassStick)
					glassStickArr.push(stick);
			}
			//remove old sticks
			while (stageStickArr[stageStickArr.length - 1].y > -300)
			{
				stick = getNewStick();
				stick.x = Math.random() * (stage.stageWidth - stick.width) + stick.width * 0.5;
				var max:Number = -200 * Math.min(1, score / 10000 + 0.5) + 10;
				var min:Number = -200 * Math.min(0.5, score / 10000) - 20;
				stick.y = stageStickArr[stageStickArr.length - 1].y  + min + Math.random()*(max-min);
				stageStickArr.push(stick);
				stage.addChild(stick);
				var distance:Number = stageStickArr[stageStickArr.length - 2].y - stageStickArr[stageStickArr.length - 1].y;
				if (Math.random() < 0.1 && distance > 60)
				{
					stick = new BrokenStick();
					stick.x = Math.random() * (stage.stageWidth - stick.width) + stick.width * 0.5;
					stick.y = stageStickArr[stageStickArr.length - 1].y + Math.random() * (distance-40) + 20;
					stageStickArr.splice(stageStickArr.length - 1,0, stick);
					stage.addChild(stick);
					Starling.juggler.add(stick);
					stick.stop();
				}
			}
		}
		
		public function getNewStick():Stick
		{
			if (Math.random() < (score < score2SpawnBigOnes ? (score2SpawnBigOnes * 0.1 - score) / (score2SpawnBigOnes * 0.11) : 0.05))
			{
				if (normalStickArr.length)
					return normalStickArr.pop();
				return new NormalStick();
			}
			else if (Math.random() < 0.5)
			{
				if (movingStickArr.length)
					return movingStickArr.pop();
				return new MovingStick();
			}
			else
			{
				if (glassStickArr.length)
					return glassStickArr.pop();
				return new GlassStick();
			}
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
			
			if ( !doodleMovie.isPlaying )
			{
				doodleMovie.play();
			}
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
		
		private function onMenuBtnTriggered (e:Event) : void
		{
			this.game.changeState(Game.MENU_STATE);
		}
		
		private function onRestartTriggered (e:Event) : void
		{
			this.game.changeState(Game.PLAY_STATE);
			//this.game.changeState(Game.MENU_STATE);
		}
		
		
		/* INTERFACE interfaces.IState */
		
		public function destroy () : void 
		{
			resetGame();
			scoreText.removeFromParent(true);
			scoreText = null;
			boutonMenu.removeFromParent(true);
			boutonMenu = null;
			boutonRestart.removeFromParent(true);
			boutonRestart = null;
			doodleMovie.removeFromParent(true);
			doodleMovie = null;
			
			for each (var a:Assets in Assets)
			{
				Assets[a].removeFromParent(true);
				Assets[a] = null;
			}
			for each (var stick:Stick in stageStickArr)
			{
				stick.removeFromParent(true);
				stick = null;
			}
			
			removeFromParent(true);
		}
		
	}

}