package com.zillix.zlxnape
{
	import nape.callbacks.CbType;
	import nape.shape.Polygon;
	import nape.shape.Shape;
    import org.flixel.*;
 
	import nape.geom.Mat23;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.space.Space;
	import nape.phys.BodyType;
	import nape.phys.Material;
	
	import com.zillix.utils.ZMathUtils;
	
	public class ZlxNapeSprite extends FlxSprite
    {
		
		public static const DIRECTION_FORWARD:uint = 1;
		public static const DIRECTION_LEFT:uint = 2;
		public static const DIRECTION_RIGHT:uint = 3;
		public static const DIRECTION_BACKWARDS:uint = 4;
		
		protected var _body:Body; public function get body() : Body { return _body; }
		
		private var _origOffset:Vec2; public function get origOffset():Vec2 {return _origOffset;}
        
		private var _target:FlxObject;
		
		private var _maxSpeed:Number = 1000;
		private var _accelerationRate:Number = 0;
		
		protected var _bodyRegistry:BodyRegistry;
        
        public function ZlxNapeSprite(X:Number, 
			Y:Number, 
			Width:Number, 
			Height:Number, 
			space:Space,
			bodyRegistry:BodyRegistry,
			bodyType:BodyType =  null):void
        {
            super(X, Y);
			
			// So we can use the FlxObject movement variables without worrying about Flixel trying to move it
			moves = false;
			
			if (bodyType == null)
			{
				bodyType = BodyType.DYNAMIC;
			}
			
		    width = Width;
            height = Height;
			_origOffset = new Vec2(width / 2, height / 2);
			_body = new Body(bodyType);
			_body.shapes.add(new Polygon( Polygon.box(Width, Height)));
			_body.position.set(new Vec2(x, y).add(origOffset));
			_body.setShapeMaterials(Material.wood());
			_body.space = space;
			collisionGroup = InteractionGroups.GROUND;
		
			_bodyRegistry = bodyRegistry;
			_bodyRegistry.registerBody(this, _body);
	    }
        
        override public function update():void
        {
          	x = _body.position.x - _origOffset.x;
			y = _body.position.y - _origOffset.y;
			angle = ZMathUtils.toDegrees(_body.rotation);
			
			if (_body.type != BodyType.STATIC)
			{
				
				if (_body.velocity.length > _maxSpeed)
				{
					// apparently this works 0.0
					_body.velocity.length = _maxSpeed;
				}
				
				// Check max x/y after we've checked max speed
				
				if (_body.velocity.x > maxVelocity.x)
				{
					_body.velocity.x = maxVelocity.x;
				}
				
				if (_body.velocity.x < -maxVelocity.x)
				{
					_body.velocity.x = -maxVelocity.x;
				}
				
				if (_body.velocity.y > maxVelocity.y)
				{
					_body.velocity.y = maxVelocity.y;
				}
				
				if (_body.velocity.y < -maxVelocity.y)
				{
					_body.velocity.y = -maxVelocity.y;
				}
			}
			
			if (_target != null)
			{
				_body.applyImpulse(Vec2.weak(_target.x, _target.y).sub(Vec2.weak(x, y), true).mul(_accelerationRate * FlxG.elapsed));
			}
			
			super.update();
	    }
		
		override public function kill():void
		{
			_body.space.bodies.remove(_body);
			_bodyRegistry.unregisterBody(this, _body);
			super.kill();
		}
		
		public function addCbType(type:CbType) : void
		{
			_body.cbTypes.add(type);
		}
		
		public function set collisionGroup(group:uint) : void
		{
			for (var i:int = 0; i < _body.shapes.length; i++)
			{
				Shape(_body.shapes.at(i)).filter.collisionGroup = group;
			}
		}
		
		public function set collisionMask(mask:uint) : void
		{
			for (var i:int = 0; i < _body.shapes.length; i++)
			{
				Shape(_body.shapes.at(i)).filter.collisionMask = mask;
			}
		}
		
		public function followTarget(obj:FlxObject, acceleration:Number, maxSpeed:Number) : void
		{
			_target = obj;
			_maxSpeed = maxSpeed;
			_accelerationRate = acceleration;
		}
		
		public function set maxSpeed(speed:Number ) : void
		{
			_maxSpeed = speed;
		}
		
		public function disable() : void
		{
			visible = false;
			_body.space = null;
		}
		
		public function enable(space:Space) : void
		{
			visible = true;
			_body.space = space;
		}
		
		public function loadBody(body:Body, copyFields:Boolean = true) : void
		{
			body.space = _body.space;
			
			if (copyFields)
			{
				body.position.set(_body.position);
				body.setShapeMaterials(_body.shapes.at(0).material);
				body.velocity.set( _body.velocity);
			}
			_body.space = null;
			_body = body;
		}
		
		public static function getOppositeDirection(direction:uint) : uint
		{
			switch (direction)
			{
				case DIRECTION_FORWARD:
					return DIRECTION_BACKWARDS;
					
				case DIRECTION_BACKWARDS:
					return DIRECTION_FORWARD;
				
				case DIRECTION_LEFT:
					return DIRECTION_RIGHT;
					
				case DIRECTION_RIGHT:
					return DIRECTION_LEFT;
					
				default:
					trace("ZlxNapeSprite.getOppositeDirection: Unknown direction " + direction);
					return DIRECTION_FORWARD;
				
			}
		}
		
		public function getEdgeVector(direction:uint) : Vec2
		{
			switch (direction)
			{
				case DIRECTION_FORWARD:
					return Vec2.get(width / 2, 0);
					
				case DIRECTION_BACKWARDS:
					return Vec2.get( -width / 2, 0);
				
				case DIRECTION_LEFT:
					return Vec2.get(0, -height / 2);
					
				case DIRECTION_RIGHT:
					return Vec2.get(0, height / 2);
					
				default:
					trace("ZlxNapeSprite.getEdgeVector: Unknown direction " + direction);
					return Vec2.get(width / 2, 0);
				
			}
		}
    }
}