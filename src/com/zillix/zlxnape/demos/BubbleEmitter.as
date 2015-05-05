package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.BodyContext;
	import com.zillix.zlxnape.ZlxNapeSprite;
	import com.zillix.utils.ZMathUtils;
	import flash.utils.getTimer;
	import org.flixel.FlxGroup;
	/**
	 * ...
	 * @author zillix
	 */
	public class BubbleEmitter 
	{
		private var _owner:ZlxNapeSprite;
		private var _emitting:Boolean = false;
		private var EMIT_COOLDOWN:Number = .2;
		private var _nextEmitTime:Number = 0;
		private var _minBubbleRadius:Number = 4;
		private var _maxBubbleRadius:Number = 8;
		private var _frequency:Number = 0;
		
		private var _bubbleLayer:FlxGroup;
		private var _bodyContext:BodyContext;
		
		public function BubbleEmitter(owner:ZlxNapeSprite,
			bubbleLayer:FlxGroup,
			context:BodyContext,
			frequency:Number = 0 )
		{
			if (frequency == 0)
			{
				frequency = EMIT_COOLDOWN;
			}
			_frequency = frequency;
			_owner = owner;
			_bubbleLayer = bubbleLayer;
			_bodyContext = context;
		}
		
		public function startEmit() : void
		{
			_emitting = true;
		}
		
		public function stopEmit() : void
		{
			_emitting = false;
		}
		
		public function update() : void
		{
			if (_emitting)
			{
				if (getTimer() > _nextEmitTime)
				{
					createBubble();
				}
			}
		}
		
		private function createBubble() : void
		{
			var radius:Number = ZMathUtils.randomBetween(_minBubbleRadius, _maxBubbleRadius);
			var bubble:Bubble = new Bubble(_owner.x, _owner.y, radius, _bodyContext);
			_bubbleLayer.add(bubble);
			_nextEmitTime = getTimer() + _frequency * 1000;
		}
		
	}
}