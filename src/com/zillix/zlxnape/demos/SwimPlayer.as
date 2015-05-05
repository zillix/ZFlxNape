package com.zillix.zlxnape.demos 
{
	import nape.phys.Material;
	import org.flixel.*;
	import com.zillix.zlxnape.BodyContext;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author zillix
	 */
	public class SwimPlayer extends Player 
	{
		private var _bubbleEmitter:BubbleEmitter;
		
		public static var ACCELERATION:int = 5500;
		public static var MAX_SPEED:int = 20;
		
		public function SwimPlayer(X:Number, Y:Number, Context:BodyContext)
		{
			super(X, Y);
			
			createBody(16, 16, Context);
			
			setMaterial(new Material(1, 1, 2, Water.DENSITY - .2, 0.001));
			
			maxVelocity.x = MAX_SPEED;
			maxVelocity.y = MAX_SPEED;
		}
		
		public function set bubbleEmitter(emitter:BubbleEmitter) : void
		{
			_bubbleEmitter = emitter;
		}
		
		override public function update() : void
		{
			super.update();
		
			if (_bubbleEmitter != null)
			{
				_bubbleEmitter.update();
			}
		}
		
		override protected function processInput() : void
		{
			if (FlxG.keys.pressed("RIGHT"))
			{
				_body.applyImpulse(Vec2.get(ACCELERATION * FlxG.elapsed));
			}
			else if (FlxG.keys.pressed("LEFT"))
			{
				_body.applyImpulse(Vec2.get(-ACCELERATION * FlxG.elapsed));
			}
			if (FlxG.keys.pressed("UP"))
			{
				_body.applyImpulse(Vec2.get(0, -ACCELERATION * FlxG.elapsed));
			}
			else if (FlxG.keys.pressed("DOWN"))
			{
				_body.applyImpulse(Vec2.get(0, ACCELERATION * FlxG.elapsed));
			}
	
			if (_bubbleEmitter != null)
			{
				if (FlxG.keys.justPressed("SPACE"))
				{
					_bubbleEmitter.startEmit();
				}
				if (FlxG.keys.justReleased("SPACE"))
				{
					_bubbleEmitter.stopEmit();
				}
			}
		}
		
	}

}