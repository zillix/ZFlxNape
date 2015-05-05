package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.*;
	import com.zillix.zlxnape.ZlxNapeSprite;
	import flash.geom.Point;
	import nape.geom.Vec2;
	import org.flixel.*;
	import nape.phys.*;
	
	/**
	 * ...
	 * @author zillix
	 */
	public class Plant extends ColorSprite 
	{
		[Embed(source = "data/frondSegment.png")]	public var FrondSegment:Class;
		
		public static const FALL_PLANT:int = 0;
		public static const RISE_PLANT:int = 1;
		public static const DRAPE_PLANT:int = 2;
		public static const TINY_PLANT:int = 3;
		
		private static const SEGMENT_WIDTH:int = 4;
		private static const SEGMENT_HEIGHT:int = 20;
		private static const SEGMENTCOLOR:uint = 0xff00ff00;
		
		private static const SUB_COLOR:uint = 0xffffff00;
		
		private var _chains:Vector.<BodyChain> = new Vector.<BodyChain>();
		
		public function Plant(X:Number, Y:Number, PlantLayer:FlxGroup, Context:BodyContext, Fronds:int = 3, FrondSize:int = 4, plantType:int = FALL_PLANT, minDist:int = 4, maxDist:int = 8)
		{
			super(X, Y, SUB_COLOR);
			createBody(60, 20, Context, BodyType.STATIC);
			
			// The base of the plant is invisible
			visible = false;
			
			var chain:BodyChain;
			var segmentCollisionMask:uint = InteractionGroups.PLAYER | InteractionGroups.BUBBLE | InteractionGroups.ENEMY;
			for (var i:int = 0; i < Fronds; i++)
			{
				var offsetVector:Vec2 = Vec2.get( -width / 2 + (width / (Fronds + 1) * (i + 1)), 0);
				
				
				chain = new BodyChain(this, offsetVector, PlantLayer, Context, FrondSize, SEGMENT_WIDTH, SEGMENT_HEIGHT, SEGMENTCOLOR, minDist, maxDist); 
				chain.segmentSpriteClass = FrondSegment;
				chain.segmentSpriteRotations = 32;
				chain.segmentSpriteScale = new FlxPoint(2, 2);
				chain.segmentCollisionMask = segmentCollisionMask;
				if (plantType == FALL_PLANT || plantType == DRAPE_PLANT)
				{
					chain.fluidMask = 0;
				}
				else
				{
					chain.fluidMask = ~0;
				}
				chain.segmentMaterial = Material.sand();
				chain.segmentDrag = new FlxPoint(30, 30);
				_chains.push(chain);
				chain.init();
			}
			
			collisionGroup = InteractionGroups.TERRAIN;
			collisionMask = ~(InteractionGroups.NO_COLLIDE | InteractionGroups.SEGMENT);
		
		}
	}
}