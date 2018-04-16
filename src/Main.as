package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.LoaderInfo;
	import flash.external.ExternalInterface;
	import flash.display.DisplayObject;
	import flash.filters.*;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author josh
	 */
	public class Main extends MovieClip 
	{
		private var bg:MovieClip;
		private var upButtonMC:MovieClip;
		private var downButtonMC:MovieClip;
		private var rightButtonMC:MovieClip;
		private var leftButtonMC:MovieClip;
		private var startBg:MovieClip;
		private var startButton:MovieClip;
		private var gameOverBg:MovieClip;
		private var playAgain:MovieClip;
		
		private var stageWidth:Number      	= 800;
		private var stageHeight:Number     	= 600;
		
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			startScreen();
		}
		
		private function startSimon():void
		{
			bg					= new bgMC();
			upButtonMC			= new dullTopMC();
			downButtonMC		= new dullRightMC();
			leftButtonMC		= new dullLeftMC();
			rightButtonMC		= new dullBotMC();
			
			upButtonMC.type		= 'up';
			downButtonMC.type	= 'down';
			leftButtonMC.type 	= 'left';
			rightButtonMC.type 	= 'right'
			
			upButtonMC.x		= stageWidth / 2 - upButtonMC.width / 2 - 120;
			upButtonMC.y		= 40;
			
			downButtonMC.x 		= 420;
			downButtonMC.y		= 290;
			
			leftButtonMC.x		= stageWidth / 2 - upButtonMC.width / 2 - 120;
			leftButtonMC.y		= 290;
			
			rightButtonMC.x		= 420;
			rightButtonMC.y		= 40;
			
			
			
			//add elements to stage
			addChild(bg);
			addChild(upButtonMC);
			addChild(downButtonMC);
			addChild(leftButtonMC);
			addChild(rightButtonMC);
			
			//buutton glow
			 
			
			var yellowGlow:GlowFilter 	= new GlowFilter(0xf2e27d, 0, 300, 300, 3,1, true);
			var blueGlow:GlowFilter		= new GlowFilter(0x7cefef, 0, 300, 300, 3,1, true);
			var pinkGlow:GlowFilter		= new GlowFilter(0xe96bf4, 0, 300, 300, 3,1, true);
			var redGlow:GlowFilter		= new GlowFilter(0xf22b9f, 0, 300, 300, 3,1, true);
			
			upButtonMC.filters			= [yellowGlow];
			downButtonMC.filters		= [blueGlow];
			leftButtonMC.filters		= [pinkGlow];
			rightButtonMC.filters 		= [redGlow];
			
			function increaseGlow(btn:MovieClip, glow:GlowFilter):void
			{
				glow.alpha += 0.10;
				btn.filters = [glow];
			}
			
			function decreaseGlow(btn:MovieClip, glow:GlowFilter):void
			{
				glow.alpha -= 0.10;
				btn.filters = [glow]
			}
			
			function setDecreaseGlow(btn:MovieClip, glow:GlowFilter):void
			{
			   var decreaseInt:uint = setInterval(decreaseGlow, 25, btn, glow);
			   setTimeout(clearInterval, 400, decreaseInt);
			}
	
			
			
			function clickGlow(e:MouseEvent,  btn:MovieClip, glow:GlowFilter):void
			{
				var intervalId:uint = setInterval(increaseGlow, 25, btn, glow);
				setTimeout(clearInterval, 400, intervalId);
				setTimeout(setDecreaseGlow, 400, btn, glow);
				if (commands[currentCommand] === btn.type)
				{
					currentCommand++;
				}
				else 
				{
					currentCommand = 0
					gameOver();
				}
				
				if (currentCommand === commands.length)
				{
					currentCommand = 0;
					setTimeout(compTurn, 1500)
				}
			}
			
			function compClickGlow(btn:MovieClip, glow:GlowFilter):void
			{
				var intervalId:uint = setInterval(increaseGlow, 25, btn, glow);
				setTimeout(clearInterval, 400, intervalId)
				setTimeout(setDecreaseGlow, 400, btn, glow)
			}
			
			
			
			//game logic -----------------------------------------------------------------------------------------------------
			
			var commands:Array = [];
			var currentCommand:Number = 0;
			
			var glowFuncs:Object = 
			{
				up:			function() : void { compClickGlow(upButtonMC, yellowGlow) },
				down: 		function() : void { compClickGlow(downButtonMC, blueGlow) },
				right:		function() : void { compClickGlow(rightButtonMC, redGlow) },
				left:		function() : void { compClickGlow(leftButtonMC, pinkGlow) }
			}
			
			function getKeys(obj:Object):Array
			{
				var keys:Array = [];
				for (var i:String in obj)
				{
					keys.push(i)
				}
				return keys
			}
			
			var keys:Array = getKeys(glowFuncs);
			
			function compTurn():void
			{
				commands.push(keys[Math.floor(Math.random() * keys.length)])
				for (var i:Number = 0; i < commands.length; i++)
				{
					setTimeout(glowFuncs[commands[i]], 1000 * i)
				}
			}
			
			function playerTurn():void
			{
				
				//event listeners --------------------------------------------------------------------------------------------
			
				upButtonMC.addEventListener(MouseEvent.CLICK, function(e: MouseEvent) : void { clickGlow(e, upButtonMC, yellowGlow) });
				downButtonMC.addEventListener(MouseEvent.CLICK, function(e: MouseEvent) : void { clickGlow(e, downButtonMC, blueGlow) });
				rightButtonMC.addEventListener(MouseEvent.CLICK, function(e: MouseEvent) : void { clickGlow(e, rightButtonMC, redGlow) });
				leftButtonMC.addEventListener(MouseEvent.CLICK, function(e: MouseEvent) : void { clickGlow(e, leftButtonMC, pinkGlow) });
				
				// ---------------------------------------------------------------------------------------------------------------
			}
			
			compTurn();
			playerTurn();
			
			
		}
		
		private function startScreen():void
		{
			startBg 		= new startBgMC();
			startButton 	= new startButtonMC();
			
			startButton.x 	= 290;
			startButton.y 	= 340;
			
			addChild(startBg);
			addChild(startButton);
			
			function startGame():void
			{
				removeChild(startBg);
				removeChild(startButton);
				startSimon();
			}
			
			startButton.addEventListener(MouseEvent.CLICK, startGame)
		}
		
		
		private function gameOver():void
		{
			gameOverBg 		= new gameOverBgMC();
			playAgain 		= new playAgainMC();
			
			playAgain.x 	= 190;
			playAgain.y 	= 340;
			
			removeChildren(0, 4);
			
			addChild(gameOverBg);
			addChild(playAgain);
			
			function startGame():void
			{
				removeChild(gameOverBg);
				removeChild(playAgain);
				startSimon();
			}
			
			playAgain.addEventListener(MouseEvent.CLICK, startGame)
		}
	}
	
}