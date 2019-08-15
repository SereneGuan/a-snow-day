package fight
{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.display.DisplayObject;
	import flash.utils.Timer;

	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.danzen.frameworks.Easy;

	public class Fight extends MovieClip
	{
		//movieClip
		private var serene:Serene;
		private var aldo:Aldo;
		private var boyBall:BoyBall;
		private var girlBall:GirlBall;
	
		//moving
		private var sW:Number;
		private var sH:Number;
		private var walkSpeed:Number = 3;
		private var myTimer:Timer;

		//jumping
		private var AjumpPower:Number = 0;
		private var SjumpPower:Number = 0;
		private var AisJumping:Boolean = false;
		private var SisJumping:Boolean = false;
		private var ground:Number = 500;
		private var setGravity:Number = 10;

		//heart
		private var iheartNum:int = 7;
		private var jheartNum:int = 7;
		private var iheart:Heart;
		private var jheart:Heart;
		//heart holder
		private var iSprite:Sprite;
		private var jSprite:Sprite;

		//throwing snowBalls
		private var aldoCheck:Boolean = false;
		private var sereneCheck:Boolean = false;
		
		//intro
		private var intro:Intro;
		private var doStart:StartButton;
		private var revealTimer:Timer;
		




		public function Fight()
		{
			// constructor code
			trace("go");

			sW = stage.stageWidth;
			sH = stage.stageHeight;
			
			//intro = new Intro;
			//doStart = new StartButton;
			
			//addChild(intro);
			//addChild(doStart);
					
			startGame();
			init();
			
			
			
			//doStart.buttonMode = true;
			//doStart.addEventListener(MouseEvent.CLICK, introPage);
			
			
			
			
		}


		function init()
		{   
			/*doStart.buttonMode = true;
			doStart.mouseEnabled = true;
			doStart.addEventListener(MouseEvent.CLICK, introPage);
			*/
			stage.addEventListener(KeyboardEvent.KEY_DOWN, doKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, doKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,snowBall);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,kneelDown);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, doJump);
			stage.addEventListener(Event.ENTER_FRAME, doFall);
			
			
			aldo.addEventListener(Event.ENTER_FRAME, doMove);
			serene.addEventListener(Event.ENTER_FRAME, doMove);
			
			
			
			
			
			
			
			

		}
		
		
		//startPage
		/*private function introPage(e:MouseEvent):void
		{
						
			removeChild(intro);
			removeChild(doStart);
			startGame();
			addChild(introPage);
			addChild(doStart);
			
			doStart.buttonMode = false;
			doStart.mouseEnabled = false;
			doStart.removeEventListener(MouseEvent.MOUSE_DOWN, startGame);
		}*/

		//startGame
		private function startGame()
		{
			doStart.buttonMode = false;
			doStart.mouseEnabled = false;
			doStart.removeEventListener(MouseEvent.MOUSE_DOWN, startGame);			
			TweenMax.to(doStart, .7, {alpha:0, ease:Quad.easeInOut});
		

			//get snowBalls
			boyBall=new BoyBall();
			girlBall=new GirlBall();
			addChild(boyBall);
			addChild(girlBall);


			//get aldo
			aldo=new Aldo();
			addChild(aldo);
			aldo.x = 200;//aldo positon
			aldo.moveCheck = true;

			//get serene
			serene=new Serene();
			addChild(serene);
			serene.x = sW - 200 - serene.width;//serene position
			serene.moveCheck = true;
			//get hearts
			jSprite=new Sprite();
			addChild(jSprite);
			iSprite=new Sprite();
			addChild(iSprite);

			//aldo get hearts
			for (var i:uint = 0; i < iheartNum; i++)
			{
				iheart = new Heart();
				iSprite.addChild(iheart);
				iheart.x = i * 55;
				iheart.name = "iheart" + i;
			}
			//serene get hearts
			for (var j:uint = 0; j < jheartNum; j++)
			{
				jheart = new Heart();
				jSprite.addChild(jheart);
				jheart.x = (sW - 55) - (j * 55);//jheart position
				jheart.name = "jheart" + j;
				//trace(i);
			}

			boyBall.x = aldo.x;
			girlBall.x = serene.x;

			setChildIndex(boyBall, numChildren-1);
			setChildIndex(girlBall, numChildren-1);

		}//end startGame



		//move characters
		private function doKeyDown(e:KeyboardEvent):void
		{

			//move Aldo
			if (e.keyCode == Keyboard.A)
			{
				aldo.toLeft = true;
				aldo.scaleX = -1;
				//aldo.gotoAndPlay(1);
				boyBall.scaleX = -1;
			}
			else if (e.keyCode == Keyboard.D)
			{
				aldo.toRight = true;
				aldo.scaleX = 1;
				//aldo.gotoAndPlay(1);
				//boyBall.x = aldo.x;
				boyBall.scaleX = 1;
			}
			//move Serene
			if (e.keyCode == Keyboard.LEFT)
			{
				serene.toLeft = true;
				serene.scaleX = 1;
				//serene.gotoAndPlay(1);
				girlBall.scaleX = 1;
			}
			else if (e.keyCode == Keyboard.RIGHT)
			{
				serene.toRight = true;
				serene.scaleX = -1;
				//serene.gotoAndPlay(1);
				girlBall.scaleX = -1;
			}//set serene boundary

		}

		//stop moving
		private function doKeyUp(e:KeyboardEvent):void
		{

			//stop aldo
			if (e.keyCode == Keyboard.A)
			{
				aldo.toLeft = false;
			}
			else if (e.keyCode == Keyboard.D)
			{
				aldo.toRight = false;
			}//end stop aldo

			//stop serene
			if (e.keyCode == Keyboard.LEFT)
			{
				serene.toLeft = false;
			}
			else if (e.keyCode == Keyboard.RIGHT)
			{
				serene.toRight = false;
			}//end stop serene

		}
		
		// move
		private function doMove(e:Event):void
		{
			myTimer = new Timer(2*1000,1);
			myTimer.addEventListener(TimerEvent.TIMER, aldoRelease);
			myTimer.addEventListener(TimerEvent.TIMER, sereneRelease);
			
			if (aldo.moveCheck)
			{

				if (aldo.toLeft)
				{
					aldo.x -=  walkSpeed;
					boyBall.x = aldo.x;
					aldo.gotoAndPlay(2);
				}
				if (aldo.toRight)
				{
					aldo.x +=  walkSpeed;
					boyBall.x = aldo.x;
					aldo.gotoAndPlay(2);
				}
			}

			if (serene.moveCheck)
			{
				if (serene.toLeft)
				{
					serene.x -=  walkSpeed;
					girlBall.x = serene.x;
					serene.gotoAndPlay(2);
				}
				if (serene.toRight)
				{
					serene.x +=  walkSpeed;
					girlBall.x = serene.x;
					serene.gotoAndPlay(2);
				}
			}

			//set aldo boundary
			if (aldo.x < aldo.width)
			{
				aldo.x = aldo.width;
			}
			else if (aldo.x>sW-aldo.width)
			{
				aldo.x = sW - aldo.width;
			}
			//serene boundary
			if (serene.x < 0)
			{
				serene.x = 0;
			}
			else if (serene.x>sW)
			{
				serene.x = sW;
			}


			//aldo is being hit
			if (aldo.hitTestObject(girlBall))
			{
				//trace("aldo is being hit");
				girlBall.x = serene.x;// reset girl's snowBall position
				girlBall.y = serene.y;
				iheartNum--;//lose heart

				TweenMax.killTweensOf(girlBall);
				sereneCheck = false;
				
				// frozen aldo
				if (girlBall.currentFrame == 2)
				{
					aldo.moveCheck = false;
					myTimer.start();
					
				
				}	

				// aldo loses heart
				if (iheartNum>=0)
				{
					//trace(iheartNum);
					var iheartObject:DisplayObject = iSprite.getChildAt(iheartNum);
					iSprite.removeChild(iheartObject);
				}
			}
			else
			{
				getDie();// if (iheartNum == 0) then gameOver
			}
			

			//serene is being hit
			if (serene.hitTestObject(boyBall))
			{
				// reset girl's boyBall position
				boyBall.x = aldo.x;
				boyBall.y = aldo.y;
				jheartNum--;

				TweenMax.killTweensOf(boyBall);
				aldoCheck = false;
				
				// frozen serene
				if (boyBall.currentFrame == 2)
				{
					serene.moveCheck = false;
					myTimer.start();
				
				}	

				// serene loses heart
				if (jheartNum>=0)
				{
					//trace(jheartNum);
					var jheartObject:DisplayObject = jSprite.getChildAt(jheartNum);
					jSprite.removeChild(jheartObject);
				}
			}
			else
			{
				getDie();// if (iheartNum == 0) then gameOver
			}

		}//end move




		//doJump
		private function doJump(e:KeyboardEvent):void
		{
			//aldo jump
			if (e.keyCode == Keyboard.W && ! AisJumping)
			{
				AjumpPower = 30;
				AisJumping = true;
				boyBall.y = aldo.y;

			}
			//serene jump
			if (e.keyCode == Keyboard.UP && ! SisJumping)
			{
				SjumpPower = 30;
				SisJumping = true;
				girlBall.y = serene.y;
			}
		}



		//doFall
		private function doFall(e:Event):void
		{
			//aldo fall
			if (AisJumping)
			{
				aldo.y -=  AjumpPower;
				AjumpPower -=  2;
				boyBall.y = aldo.y;
			}

			if (aldo.y + setGravity < ground)
			{
				aldo.y +=  setGravity;
			}
			else
			{
				AisJumping = false;
				aldo.y = ground;
			}

			//serene fall
			if (SisJumping)
			{
				serene.y -=  SjumpPower;
				SjumpPower -=  2;
				girlBall.y = serene.y;
			}

			if (serene.y + setGravity < ground)
			{
				serene.y +=  setGravity;
			}
			else
			{
				SisJumping = false;
				serene.y = ground;
			}
		}






		private function kneelDown(e:KeyboardEvent):void
		{
			//Aldo
			if (e.keyCode == Keyboard.S)
			{
				trace("Aldo down");

			}
			//Serene
			if (e.keyCode == Keyboard.DOWN)
			{
				trace("Serene down");
			}

		}



		
		// release frozen
		private function aldoRelease(e:TimerEvent)
		{
			aldo.moveCheck = true;
		}
		private function sereneRelease(e:TimerEvent)
		{
			aldo.moveCheck = true;
		}





		//Snowball events
		private function snowBall(e:KeyboardEvent)
		{

			//Aldo's snowball
			if (e.keyCode == 32 && aldoCheck == false)
			{//32 == space
				trace("serene");
				var bbEnd:Number = Math.floor(Math.random() * ((serene.x-150) - (serene.x+300))+(serene.x+300));
				aldoCheck = true;
				boyBall.x = aldo.x;
				boyBall.y = aldo.y;
				TweenMax.to(boyBall, 1.4, {bezierThrough:[{x:aldo.x+(serene.x-aldo.x)/2, y:serene.y-200}, {x:bbEnd, y:serene.y+serene.height-boyBall.height}], ease:Sine.easeInOut, onComplete: aldoDone});

				boyBall.gotoAndStop(Easy.randomRound(1,2));

				/*if(Math.random()<.7)
				{
				removeChild(boyBall.boySmallBall);
				}
				else
				{
				removeChild(boyBall.boyBigBall)
				}*/

			}


			//Serene's snowball
			if (e.keyCode == 16 && sereneCheck == false)
			{//16 == shift
				trace("aldo");
				var gbEnd:Number = Math.floor(Math.random() * ((aldo.x-300) - (aldo.x+150))+(aldo.x+150));
				sereneCheck = true;
				girlBall.x = serene.x;
				girlBall.y = serene.y;
				TweenMax.to(girlBall, 1.4, {bezierThrough:[{x:aldo.x+(serene.x-aldo.x)/2, y:serene.y-200}, {x:gbEnd, y:aldo.y+aldo.height-girlBall.height}], ease:Sine.easeInOut, onComplete: sereneDone});

				girlBall.gotoAndStop(Easy.randomRound(1,2));
				
			}
		}//end snowBall




		// can't press keyboard twice
		private function aldoDone()
		{
			aldoCheck = false;
		}
		private function sereneDone()
		{
			sereneCheck = false;
		}




		//GAME OVER
		private function getDie():void
		{

			if (iheartNum<=0)
			{

				trace("Winner:Serene");

			}
			else if (jheartNum<=0)
			{
				trace("Winner:Aldo");

			}


		}







	}
}