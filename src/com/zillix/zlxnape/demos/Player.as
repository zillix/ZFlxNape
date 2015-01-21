package com.zillix.zlxnape.demos
{
	
	import com.zillix.zlxnape.BodyRegistry;
	import com.zillix.zlxnape.ZlxNapeSprite;
	import com.zillix.zlxnape.CallbackTypes;
	import com.zillix.zlxnape.InteractionGroups;
	import com.zillix.utils.ZMathUtils;
	
	import nape.callbacks.InteractionListener;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionType;
	import nape.shape.Polygon;
	import nape.shape.Shape;
    import org.flixel.*;
 
	import nape.geom.Mat23;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.space.Space;
	import nape.phys.BodyType;
	
	
	/**
	 * ...
	 * @author zillix
	 */
	public class Player extends ZlxNapeSprite 
	{
		
		public var X_SPEED:int = 40;
		public var JUMP_SPEED:int = 50;
		public var DASH_SPEED:int = 100;
		public var DASH_ANGLE_SPEED:int = 20000;
		
		private var _canJump:Boolean = false;
		public function Player(X:Number, Y:Number, space:Space, bodyRegistry:BodyRegistry)
		{
			super(X, Y, 25, 25, space, bodyRegistry, BodyType.DYNAMIC);
			makeGraphic(25, 25, 0xff00ff00);
			
			maxVelocity.x = 100;
			
			_body.cbTypes.add(CallbackTypes.PLAYER);
			collisionGroup = InteractionGroups.PLAYER;
			
		}
		
		public function onLand() : void
		{
			_canJump = true;
		}
		
		public function onAbsorb(box:ZlxNapeSprite) : void
		{
			if (FlxG.keys.F)
			{
				box.collisionGroup = InteractionGroups.DEAD_BOX;
				box.collisionMask = ~(InteractionGroups.BOX | InteractionGroups.PLAYER);
				box.color = 0xff000000;
				box.alpha = .5;
				
				// TODO: remove boxes
				//PlayState.instance.boxes.remove(box, true);
				//PlayState.instance.deadBoxes.add(box);
				
				
				//box.kill();
				//box.body.applyImpulse(Vec2.weak(box.x, box.y).sub(Vec2.weak(x, y), true).mul(100));
			}
		}
		
		override public function update() : void
		{
			super.update();
			
			if (FlxG.keys.pressed("D"))
			{
				_body.velocity.x = X_SPEED;
			}
			
			if (FlxG.keys.pressed("A"))
			{
				_body.velocity.x = -X_SPEED;
			}
			
			if (FlxG.keys.justPressed("W"))
			{
				if (_canJump)
				{
					_canJump = false;
					_body.applyImpulse(new Vec2(0, -JUMP_SPEED));
				}
			}
			
			if (FlxG.keys.justPressed("E"))
			{
				_body.applyImpulse(new Vec2(DASH_SPEED, 0));
				_body.applyAngularImpulse(ZMathUtils.toRadians(DASH_ANGLE_SPEED));
			}
			
				if (FlxG.keys.justPressed("Q"))
			{
				_body.applyImpulse(new Vec2( -DASH_SPEED, 0));
				_body.applyAngularImpulse(ZMathUtils.toRadians(-DASH_ANGLE_SPEED));
			}
		}
		
	}
	
}