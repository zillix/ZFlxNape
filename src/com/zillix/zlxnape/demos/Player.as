package com.zillix.zlxnape.demos
{
	
	import com.zillix.zlxnape.BodyContext;
	import com.zillix.zlxnape.BodyRegistry;
	import com.zillix.zlxnape.ZlxNapeSprite;
	import com.zillix.zlxnape.CallbackTypes;
	import com.zillix.zlxnape.InteractionGroups;
	import com.zillix.utils.ZMathUtils;
	import nape.phys.Material;
	
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
		
		private const _zeroFriction:Material = new Material(-.5, 0, 0, .875, 0);
		private const _normalFriction:Material = new Material( -.5, 1, 0.38, 0.875, 0.005);
		
		public function Player(X:Number, Y:Number)
		{
			super(X, Y);
			
			maxVelocity.x = 100;
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
			
			makeGraphic(Width, Height, 0xff00ff00);
			
			_body.cbTypes.add(CallbackTypes.PLAYER);
			collisionGroup = InteractionGroups.PLAYER;
		}
		
		override public function addDefaultCbTypes() : void
		{
			super.addDefaultCbTypes();
			addCbType(CallbackTypes.PLAYER);
			collisionGroup = InteractionGroups.PLAYER;
			collisionMask = ~InteractionGroups.NO_COLLIDE;
			
			_body.allowRotation = false;
		
		}
		
		public function onLand() : void
		{
			_canJump = true;
		}
		
		protected function onStartMoving():void {
			this.body.setShapeMaterials(_zeroFriction);
		}

		protected function onStopMoving():void {
			this.body.setShapeMaterials(_normalFriction);
		}
		
		override public function update() : void
		{
			super.update();
			
			processInput();
		}
		
		protected function processInput() : void
		{
			var keyPressed:Boolean = false;
			
			if (FlxG.keys.pressed("RIGHT"))
			{
				_body.velocity.x = X_SPEED;
				keyPressed = true;
			}
			
			if (FlxG.keys.pressed("LEFT"))
			{
				_body.velocity.x = -X_SPEED;
				keyPressed = true;
			}
			
			if (FlxG.keys.justPressed("UP"))
			{
				if (_canJump)
				{
					_canJump = false;
					_body.applyImpulse(new Vec2(0, -JUMP_SPEED));
					keyPressed = true;
				}
			}
			
			if (!keyPressed)
			{
				onStopMoving();
			}
			else
			{
				onStartMoving();
			}
		}
		
	}
	
}