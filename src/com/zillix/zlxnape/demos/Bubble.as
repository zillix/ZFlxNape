package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.BodyContext;
	import com.zillix.zlxnape.*;
	import flash.display.Shape;
	import flash.utils.getTimer;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Circle;
	
	/**
	 * ...
	 * @author zillix
	 */
	public class Bubble extends ZlxNapeSprite 
	{
		[Embed(source = "data/bubble.png")]	public var BubbleImage:Class;
		
		public var radius:Number = 0;
		public var initialRadius:Number;
		
		public var LIFESPAN:Number = 5;
		public var SHRINK_LIFESPAN:Number = 1;
		
		public var POP_LIFESPAN:Number = .7;
		
		private var _deathTime:Number = 0;
		
		private var _popped:Boolean = false;
		
		public function Bubble(X:Number, Y:Number, Radius:Number, Context:BodyContext, fade:Boolean = true)
		{
			super(X, Y);
			radius = Radius;
			createCircleBody(Radius, Context);
			loadGraphic(BubbleImage);
			
			initialRadius = Radius;
			setRadius(Radius);
			
			addCbType(CallbackTypes.BUBBLE);
			
			collisionMask = ~(InteractionGroups.NO_COLLIDE);
			collisionGroup = InteractionGroups.BUBBLE;
			
			if (fade)
			{
				_deathTime = getTimer() + LIFESPAN * 1000;
			}
			
			setMaterial(new Material(0, 5, 5, .6, 5));
			
			visible = false;
			
			_canRotate = false;
		}
		
		override public function update() : void
		{
			super.update();
			
			var time:int = getTimer();
			if (_deathTime > 0 &&
				time > _deathTime)
			{
				var killTime:Number = _deathTime + SHRINK_LIFESPAN * 1000;
				if (time > killTime)
				{
					this.kill();
					return;
				}
				
				setRadius((1 - (time - _deathTime) / (SHRINK_LIFESPAN * 1000)) * initialRadius);
			}
		}
		
		private function setRadius(Radius:Number) : void
		{
			radius = Radius;
			offset.x = offset.y = radius;
			scale.x = scale.y = radius * 2 / 10;
			
			if (radius > .01)
			{
				for (var i:int = 0; i < _body.shapes.length; ++i )
				{
					var circle:Circle = _body.shapes.at(i) as Circle;
					if (circle)
					{
						circle.radius = radius;
					}
				}
			}
		}
		
		
		
		public function onTouchAir() : void
		{
			if (!_popped)
			{
				_popped = true;
				
				_deathTime = getTimer();
			}
		}
		
		public function isShrinking() : Boolean
		{
			if (_popped)
			{return true;
			}
			
			return getTimer() > _deathTime;
		}
	}
	
}