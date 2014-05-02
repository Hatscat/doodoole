package states 
{
	import core.Assets;
	import core.Game;
	import interfaces.IState;
	import flash.ui.Keyboard;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import classes.Doodle;
	import classes.Bonus;
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
		
		public static const xVelocityMax:int 		= 1;
		public static const yVelocityMax:int 		= 20;
		public static const yVelocityMax_2:int 		= 50;
		public static const jetpackTimeBonus:int 	= 3333;
		public static const shoesTimeBonus:int 		= 3333;
		public static const GRAVITY:Number 			= 0.6;
		public static const INERTIA:Number 			= 0.95;
		public static const magicFind:Number 		= 666;
		public static const Score_w:int 			= 200;
		public static const Score_h:int 			= 75;
		public static const score2SpawnBigOnes:int 	= 90000;
		public static const plateformInterval:int 	= 210;
		public static const oneSecond:int 			= 1000;
		
		private var inputTimer:Number;
		private var jetpackTimer:Number;
		private var shoesTimer:Number;
		private var deltaTime:Number;
		private var oldTime:Number;
		private var I_AM_GOD:Boolean;
		private var can_big_jump:Boolean;
		private var jetpack_jump:Boolean;
		private var xVelocity:Number;
		private var yVelocity:Number;
		private var lastFeetPosY:Number;
		private var score:int;
		private var i:int;
		private var cpt:int = 0;
		private var midStageY:int;
		private var scoreText:TextField;
		private var gameOverTextfield:TextField;
		private var playBackground:Image;
		
		private var bonusArr:Vector.<Bonus>;
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
			
			scoreText = new TextField(Score_w, Score_h, "score", "Arial", 36, Color.WHITE);
			scoreText.hAlign = HAlign.LEFT;
			scoreText.vAlign = VAlign.TOP;
			stage.addChild(scoreText);
			
			gameOverTextfield = new TextField(300, 300, "Game Over", "Arial", 72, Color.PURPLE);
			gameOverTextfield.x = stage.stageWidth/2 - gameOverTextfield.width/2;
			gameOverTextfield.y = -200;
			stage.addChild(gameOverTextfield);
			
			stage.addChild(Assets._SmokePartSystem);
			Starling.juggler.add(Assets._SmokePartSystem);
			
			doodleMovie = new Doodle();
			stage.addChild(doodleMovie.idle);
			stage.addChild(doodleMovie.jetPack);
			Starling.juggler.add(doodleMovie.idle);
			Starling.juggler.add(doodleMovie.jetPack);
			
			stage.addChild(Assets._StarsPartSystem);
			Assets._StarsPartSystem.start();
			Starling.juggler.add(Assets._StarsPartSystem);
			
			// OPTIMISATION
			doodleMovie.idle.touchable = false;
			doodleMovie.jetPack.touchable = false;
			
			restart();
		}
		
		private function resetGame () : void
		{
			stage.removeEventListener(Event.ENTER_FRAME, boucle);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			I_AM_GOD = false;
			jetpack_jump = false;
			can_big_jump = false;
			score = 0;
			xVelocity = 0;
			yVelocity = yVelocityMax;
			lastFeetPosY = 0;
			inputTimer = 0;
			jetpackTimer = 0;
			shoesTimer = 0;
			deltaTime = 0;
			cpt = 0;
			gameOverTextfield.y = -400;
			oldTime = getTimer();
			doodleMovie.x = stage.stageWidth * 0.5;
			doodleMovie.idle.x = stage.stageWidth * 0.5;
			doodleMovie.jetPack.x = stage.stageWidth * 0.5;
			doodleMovie.y = stage.stageHeight * 0.9;
			doodleMovie.idle.y = stage.stageHeight * 0.9;
			doodleMovie.jetPack.y = stage.stageHeight * 0.9;
			Assets._SmokePartSystem.emitterX = Assets._StarsPartSystem.emitterX = doodleMovie.x;
			Assets._SmokePartSystem.emitterY = doodleMovie.y + doodleMovie.height / 4;
			Assets._StarsPartSystem.emitterY = doodleMovie.y;
			normalStickArr = new Vector.<NormalStick>;
			movingStickArr = new Vector.<MovingStick>;
			brokenStickArr = new Vector.<BrokenStick>;
			glassStickArr = new Vector.<GlassStick>;
			stageStickArr = new Vector.<Stick>;
			bonusArr = new Vector.<Bonus>;
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
			stage.addEventListener(Event.ENTER_FRAME, boucleMort);
			
		}
		
		private function boucle (e:Event) : void
		{
			deltaTime = (getTimer() - oldTime) * 0.06 || 1; // scalé sur 60fps
			oldTime = getTimer();
			
			if (jetpack_jump || getTimer() < jetpackTimer)
			{
				doodleMovie.idle.visible = false;
				doodleMovie.jetPack.visible = true;
				doodleMovie.pivotX = doodleMovie.jetPack.pivotX;
				doodleMovie.pivotY = doodleMovie.jetPack.pivotY;
				yVelocity = -yVelocityMax_2;
				launchPlayAnim();
			}
			
			if (doodleMovie.y <= midStageY && yVelocity < 0)
			{
				doodleMovie.y = midStageY;
				doodleMovie.idle.y = midStageY;
				doodleMovie.jetPack.y = midStageY;
				for each (var stick:Stick in stageStickArr)
					stick.y -= yVelocity;
				for each (var bonus:Bonus in bonusArr)
					bonus.y -= yVelocity;
				score -= yVelocity;
				scoreText.text = String(score);
			}
			else
			{
				doodleMovie.idle.visible = true;
				doodleMovie.jetPack.visible = false;
				doodleMovie.pivotX = doodleMovie.idle.pivotX;
				doodleMovie.pivotY = doodleMovie.idle.pivotY;
				if (yVelocity > 0) // en chute == peut collisionner
				{
					var doodle_box:Rectangle = doodleMovie.idle.getBounds(this);
					
					for each (var bonus:Bonus in bonusArr)
					{
						var bonus_box:Rectangle = bonus.getBounds(this);
					
						if (doodle_box.intersects(bonus_box) && lastFeetPosY < bonus.y) // loot !
						{
							trace("j'ai ramassé un item de type " + bonus.kind + " !!!");
							
							switch (bonus.kind)
							{
								case 1 : // un ressort
									can_big_jump = true;
								break;
								case 2 : // des chaussures
									shoesTimer = getTimer() + shoesTimeBonus;
								break;
								case 3 : // un jetpack
									jetpackTimer = getTimer() + jetpackTimeBonus;
								break;
							}
							
							bonus.y = stage.stageHeight * 1.1; // destruction
						}
					}
					
					if (getTimer() < shoesTimer)
					{
						can_big_jump = true;
					}
					
					for each (stick in stageStickArr)
					{
						var stick_box:Rectangle = stick.getBounds(this);
					
						if (doodle_box.intersects(stick_box) && lastFeetPosY < stick.y - stick.pivotY) // collision
						{
							if (stick is BrokenStick)
									BrokenStick(stick).drop();
							else
							{
								yVelocity = can_big_jump ? -yVelocityMax_2 : -yVelocityMax;
								if (stick is GlassStick)
									stick.y = stage.stageHeight * 1.1; // destruction
								can_big_jump = false;
							}
						}
						else if (doodleMovie.y > stage.stageHeight + doodleMovie.pivotY) // en bas
						{
							if (I_AM_GOD || !score)
								yVelocity = can_big_jump ? -yVelocityMax_2 : -yVelocityMax;
							else  // death
								gameOver();
						}
					}
				}
				else
				{
					lastFeetPosY = doodleMovie.y + doodleMovie.pivotY;
				}
				
				doodleMovie.y += yVelocity * deltaTime;
				doodleMovie.idle.y += yVelocity * deltaTime;
				doodleMovie.idle.y += yVelocity * deltaTime;
			}
			
			for each (stick in stageStickArr)
			{
				if (stick is MovingStick)
				{
					var temp:MovingStick = stick as MovingStick;
					temp.x += temp.hVelocity * deltaTime;
					if ((temp.x > stage.stageWidth - temp.width) && temp.hVelocity > 0 || (temp.x < temp.width) && temp.hVelocity < 0 || Math.random() < 0.01)
						temp.hVelocity *= -1;
				}
			}
			
			refreashSticks();
			
			doodleMovie.x += xVelocity * deltaTime;
			doodleMovie.idle.x += xVelocity * deltaTime;
			doodleMovie.jetPack.x += xVelocity * deltaTime;
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
			else if (!jetpack_jump)
			{
				/*doodleMovie.stop();*/
				Assets._SmokePartSystem.stop();
			}
			if (touchesObj[Keyboard.G] && inputTimer < getTimer())
			{
				inputTimer = getTimer() + oneSecond * 0.5;
				I_AM_GOD = !I_AM_GOD;
			}
			else if (touchesObj[Keyboard.J] && I_AM_GOD && inputTimer < getTimer())
			{
				inputTimer = getTimer() + oneSecond;
				jetpack_jump = !jetpack_jump;
			}
		
			Assets._SmokePartSystem.emitterX = Assets._StarsPartSystem.emitterX = doodleMovie.x;
			Assets._SmokePartSystem.emitterY = Assets._StarsPartSystem.emitterY = doodleMovie.y;
		}
		
		private function boucleMort (e:Event) : void
		{
				
			for each (var stick:Stick in stageStickArr)
			{
				if (!stick.tooHigh)
				{
					stick.y -= 20 * deltaTime;
					if (stick.y < -stick.width)
					{
						stick.tooHigh = true;
						cpt++;
					}
				}
			}
			
			for each (var bonus:Bonus in bonusArr)
			{
				bonus.removeFromParent(true);
				bonus = null;
			}
				
			if (cpt >= stageStickArr.length)
			{
				scoreText.y = 400;
				scoreText.text += " m";
				scoreText.fontSize = 72;
				scoreText.color = Color.RED;
				scoreText.x = stage.stageWidth / 2 - scoreText.width / 2 + 5;
				scoreText.width = scoreText.text.length * scoreText.fontSize;
				gameOverTextfield.y = 125;
				stage.removeEventListener(Event.ENTER_FRAME, boucleMort);
				boutonMenu = new Button(Assets._btnTextureAtlas.getTexture("btn_up"),
										"Menu",
										Assets._btnTextureAtlas.getTexture("btn_down"));
				boutonMenu.scaleWhenDown = 0.9;
				boutonMenu.pivotX = boutonMenu.width * 0.5;
				boutonMenu.pivotY = boutonMenu.height * 0.5;
				boutonMenu.fontColor = 0x000000;
				boutonMenu.fontSize = 30;
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
				boutonRestart.fontColor = 0x000000;
				boutonRestart.fontSize = 30;
				boutonRestart.x = stage.stageWidth * 0.5;
				boutonRestart.y = stage.stageHeight * 0.7;
				boutonRestart.addEventListener(Event.TRIGGERED, onRestartTriggered);
				addChild(boutonRestart);
			}
		}
		
		private function refreashSticks () : void
		{
			while (bonusArr.length && bonusArr[0].y > stage.stageHeight * 1.1)
			{
				stage.removeChild(bonusArr[0]);
				bonusArr.shift();
			}
			
			var stick:Stick;
			//add new sticks
			while (stageStickArr[0].y > stage.stageHeight * 1.1)
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
			while (stageStickArr[stageStickArr.length - 1].y > -plateformInterval * 1.5)
			{
				stick = getNewStick();
				stick.x = Math.random() * (stage.stageWidth - stick.width) + stick.width * 0.5;
				var max:Number = -plateformInterval * Math.min(1, score / (score2SpawnBigOnes * 0.15) + 0.5) + stick.height;
				var min:Number = -plateformInterval * Math.min(0.5, score / (score2SpawnBigOnes * 0.15)) - stick.height;
				stick.y = stageStickArr[stageStickArr.length - 1].y  + min + Math.random() * (max - min);
				stageStickArr.push(stick);
				stage.addChild(stick);
				
				var randBonus:int = Math.min(3, Math.random() * Math.random() * Math.random() * (score / magicFind) | 0);
				if (randBonus && !(stick is MovingStick))
				{
					var bonus:Bonus = getNewBonus(randBonus);
					bonus.x = stick.x;
					bonus.y = stick.y - stick.pivotY;
					bonusArr.push(bonus);
					stage.addChild(bonus);
					Starling.juggler.add(bonus);
					trace("un bonus de type " + randBonus + " est arrivée!");
				}
				
				var distance:Number = stageStickArr[stageStickArr.length - 2].y - stageStickArr[stageStickArr.length - 1].y;
				
				if (score > score2SpawnBigOnes * 0.04 && Math.random() < 0.1 && distance > yVelocityMax * 3)
				{
					stick = new BrokenStick();
					stick.x = Math.random() * (stage.stageWidth - stick.width) + stick.width * 0.5;
					stick.y = stageStickArr[stageStickArr.length - 1].y + Math.random() * (distance - yVelocityMax * 2) + yVelocityMax;
					stageStickArr.splice(stageStickArr.length - 1, 0, stick);
					stage.addChild(stick);
					Starling.juggler.add(stick);
					stick.stop();
				}
			}
		}
		
		public function getNewStick () : Stick
		{
			if (Math.random() < (score < score2SpawnBigOnes ? (score2SpawnBigOnes - score) * 0.1 / (score2SpawnBigOnes * 0.11) : 0.05))
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
		
		public function getNewBonus (kind:int) : Bonus
		{
			var b:Bonus;
			switch (kind) 
			{
				case 1: // ressort
					b = new Bonus("trampolineItem"); 
				break;
				case 2: // chaussure
					b = new Bonus("ressortItem"); 
				break;
				case 3: // jetpack
					b = new Bonus("superManItem");
				break;
			}
			b.kind = kind;
			return b;
		}
		
		private function onKeyDown (e:KeyboardEvent) : void
		{
			touchesObj[e.keyCode] = true;
		}
		
		private function onKeyUp (e:KeyboardEvent) : void
		{
			touchesObj[e.keyCode]= false;
		}
		
		private function launchPlayAnim () : void 
		{
			Assets._SmokePartSystem.start();
			
			if ( !doodleMovie.idle.isPlaying || !doodleMovie.jetPack.isPlaying)
			{
				doodleMovie.idle.play();
				doodleMovie.jetPack.play();
			}
		}
		
		private function updatePlayAnim (dir:Number) : void 
		{
			doodleMovie.scaleX = 1 * dir;
			doodleMovie.idle.scaleX = 1 * dir;
			doodleMovie.jetPack.scaleX = 1 * dir;
			xVelocity += xVelocityMax * dir;
			
			if (doodleMovie.x < 0)
			{
				doodleMovie.x = stage.stageWidth;
				doodleMovie.idle.x = stage.stageWidth;
				doodleMovie.jetPack.x = stage.stageWidth;
			}
			else if (doodleMovie.x > stage.stageWidth)
			{
				doodleMovie.x = 0;
				doodleMovie.idle.x = 0;
				doodleMovie.jetPack.x = 0;
			}
		}
		
		private function onMenuBtnTriggered (e:Event) : void
		{
			this.game.changeState(Game.MENU_STATE);
		}
		
		private function onRestartTriggered (e:Event) : void
		{
			this.game.changeState(Game.PLAY_STATE);
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
			doodleMovie.idle.removeFromParent(true);
			doodleMovie.idle = null;
			doodleMovie.jetPack.removeFromParent(true);
			doodleMovie.jetPack = null;
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