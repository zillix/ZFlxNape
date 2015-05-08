package com.zillix.zlxnape.demos
{
	import com.zillix.zlxnape.BodyChain;
	import com.zillix.zlxnape.BodyContext;
	import com.zillix.zlxnape.BodyRegistry;
	import com.zillix.zlxnape.ZlxNapeSprite;
	import com.zillix.zlxnape.CallbackTypes;
	import com.zillix.zlxnape.InteractionGroups;
	import com.zillix.zlxnape.ColorSprite;
	import flash.display.PixelSnapping;
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.space.Space;
	import nape.phys.BodyType;
	
	import org.flixel.*;
	
	/**
	 * ...
	 * @author zillix
	 */
	public class Boss extends ColorSprite 
	{
		private static const SEGMENT_WIDTH:int = 8;
		private static const SEGMENT_HEIGHT:int = 16;
		private static const MAX_SEGMENTS:int = 20;
		private static const SEGMENT_COLOR:uint = 0xffdddddd;
		private static const BOSS_COLOR:int = 0xffff22ff;
		
		private var _tentacle:BodyChain;
		private var _segments:Vector.<ZlxNapeSprite>;
		private var _segmentIndex:int = 0;
		private var _target:FlxObject;
		private var _joints:Vector.<PivotJoint>;
		private var _tentacleLayer:FlxGroup;
		
		public function Boss(X:Number, Y:Number, target:FlxObject, tentacleLayer:FlxGroup)
		{
			super(X, Y, BOSS_COLOR);
			_target = target;
			_tentacleLayer = tentacleLayer;
		}
		
		override public function createBody(Width:Number, 
											Height:Number, 
											bodyContext:BodyContext,
											bodyType:BodyType =  null,
											copyValues:Boolean = true,
											Scale:FlxPoint = null) : void
		{
			super.createBody(Width,
							Height,
							bodyContext,
							bodyType,
							copyValues,
							Scale);
			
			collisionGroup = InteractionGroups.BOSS;
			collisionMask = ~InteractionGroups.SEGMENT;
			
			addCbType(CallbackTypes.GROUND);
			
			_tentacle = new BodyChain(this,
										Vec2.get(),
										_tentacleLayer,
										_bodyContext,
										MAX_SEGMENTS,
										SEGMENT_WIDTH,
										SEGMENT_HEIGHT,
										SEGMENT_COLOR,
										1,
										4);
									
									
			_tentacle.init();
			_tentacle.followTarget(_target, 20, 100, 5);
			
			
			for (var j:int = 0; j < 10; j++)
			{
				withdrawSegment();
			}
		}
		
		public function withdrawSegment() : void
		{
			_tentacle.withdrawSegment();
		}
		
		public function extendSegment() : void
		{
			_tentacle.extendSegment();
		}
		
		public override function update() : void
		{
			super.update();
			_body.setVelocityFromTarget(new Vec2(FlxG.mouse.x, FlxG.mouse.y), _body.rotation, 5);
		}
	}
	
}