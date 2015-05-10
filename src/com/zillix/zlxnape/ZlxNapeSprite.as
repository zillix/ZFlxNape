package com.zillix.zlxnape
{
	import nape.callbacks.CbType;
	import nape.phys.Compound;
	import nape.phys.FluidProperties;
	import nape.shape.Circle;
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
	
	/**
	 * This is the building block of ZlxNape.
	 * It is an implementation of a FlxSprite that contain a Nape Body.
	 * Offers many utility functions.
	 * @author zillix
	 */
	
	
	public class ZlxNapeSprite extends FlxSprite
    {
		// Directions relative to the body
		public static const DIRECTION_FORWARD:uint = 1;	// if angle == 0, this is to the right
		public static const DIRECTION_LEFT:uint = 2; // if angle == 0, this is up
		public static const DIRECTION_RIGHT:uint = 3; // if angle == 0, this is to the left
		public static const DIRECTION_BACKWARDS:uint = 4; // if angle == 0, this is down
		
		protected var _body:Body; 
		public function get body() : Body { return _body; }
		
		protected var _origOffset:Vec2; 
		public function get origOffset():Vec2 {return _origOffset;}
        
		private var _target:FlxObject;
		protected var _minFollowDist:Number = 50;
		
		protected var _maxSpeed:Number = 1000;
		private var _accelerationRate:Number = 0;
		
		protected var _bodyRegistry:BodyRegistry;
		protected var _bodyContext:BodyContext;
		
		protected var _defaultScale:Number = 1;
		
		private var _collisionGroup:uint = ~InteractionGroups.NO_COLLIDE;
		
		protected var _canRotate:Boolean = true;
		
		
        
        public function ZlxNapeSprite(X:Number, Y:Number)
        {
            super(X, Y);
			
			drag = new FlxPoint(0, 0);
			
			// So we can use the FlxObject movement variables without worrying about Flixel trying to move it
			moves = false;
	    }
		
		public function get defaultScale() : Number
		{
			return _defaultScale;
		}
		
		public function loadBody(body:Body, bodyContext:BodyContext, Width:Number, Height:Number, copyFields:Boolean = true) : void
		{
			_origOffset = new Vec2(Width / 2, Height / 2);
			
			if (body.space == null)
			{
				body.space = bodyContext.space;
			}
			
			if (_body != null)
			{
				if (copyFields)
				{
					body.position.set(_body.position);
					body.setShapeMaterials(_body.shapes.at(0).material);
					body.velocity.set( _body.velocity);
					body.compound = _body.compound;
				}
				
				_body.compound = null;
				_body.space = null;
			}
			else
			{
				body.position.set(Vec2.weak(x, y).add(origOffset));
			}
			
			_body = body;
			_bodyRegistry = bodyContext.bodyRegistry;
			_bodyRegistry.registerBody(this, _body);
			
			addDefaultCbTypes();
		}
		
		public function setCompound(com:Compound) : void
		{
			_body.compound = com;
		}
		
		public function createCircleBody(radius:Number, 
											bodyContext:BodyContext,
											bodyType:BodyType =  null,
											copyValues:Boolean = true,
											Scale:FlxPoint = null) : void
		{
			if (Scale == null)
			{
				Scale = new FlxPoint(1, 1);
			}
			
			initBody(bodyContext, bodyType, copyValues);
			
		    width = radius * 2 * Scale.x;
            height = radius * 2 * Scale.y;
			_origOffset = new Vec2(0, 0);
			_body.shapes.add(new Circle(radius * Scale.x));
			_body.position.set(new Vec2(x, y).add(origOffset));
			_body.setShapeMaterials(Material.wood());
			
			finishCreatingBody(bodyContext);
		}
		
		public function createBody(Width:Number, 
									Height:Number,
									bodyContext:BodyContext,
									bodyType:BodyType =  null,
									copyValues:Boolean = true,
									Scale:FlxPoint = null) : void
		{
			if (Scale == null)
			{
				Scale = new FlxPoint(1, 1);
			}
			
			initBody(bodyContext, bodyType, copyValues);
			
		    width = Width * Scale.x;
            height = Height * Scale.y;
			_origOffset = new Vec2(width / 2, height / 2);
			_body.shapes.add(new Polygon( Polygon.box(Width * Scale.x, Height * Scale.y)));
			_body.position.set(new Vec2(x, y).add(origOffset));
			_body.setShapeMaterials(Material.wood());
			
			finishCreatingBody(bodyContext);
		}
		
		private function initBody(bodyContext:BodyContext, bodyType:BodyType = null, copyValues:Boolean = true) : void
		{
			if (bodyType == null)
			{
				bodyType = BodyType.DYNAMIC;
			}
			
			var newBody:Body = new Body(bodyType);
			if (_body != null)
			{
				newBody.position.set(_body.position);
				newBody.setShapeMaterials(_body.shapes.at(0).material);
				newBody.velocity.set( _body.velocity)
				_body.space = null;
			}
			
			_body = newBody;
			
			_bodyRegistry = bodyContext.bodyRegistry;
			_bodyRegistry.registerBody(this, _body);
		}
		
		private function finishCreatingBody(bodyContext:BodyContext) : void
		{
			collisionGroup = ~InteractionGroups.NO_COLLIDE;
			collisionMask = ~InteractionGroups.NO_COLLIDE;
			_bodyContext = bodyContext;
			_body.space = bodyContext.space;
			_body.allowRotation = _canRotate;
			addDefaultCbTypes();
		}
        
        override public function update():void
        {
			if (_body == null)
			{
				return;
			}
			
          	x = _body.position.x - _origOffset.x;
			y = _body.position.y - _origOffset.y;
			
			if (_canRotate)
			{
				angle = ZMathUtils.toDegrees(_body.rotation);
			}
			
			if (_body.type != BodyType.STATIC)
			{
				
				if (_body.velocity.length > _maxSpeed)
				{
					// Yes, this works!
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
			
			if (drag.x > 0)
			{
				if (_body.velocity.x > 0)
				{
					_body.velocity.x = Math.max(0, _body.velocity.x - drag.x * FlxG.elapsed);
				}
				else
				{
					_body.velocity.x = Math.min(0, _body.velocity.x + drag.x * FlxG.elapsed);
				}
			}
			
			if (drag.y > 0)
			{
				if (_body.velocity.y> 0)
				{
					_body.velocity.y = Math.max(0, _body.velocity.y - drag.y * FlxG.elapsed);
				}
				else
				{
					_body.velocity.y = Math.min(0, _body.velocity.y + drag.y * FlxG.elapsed);
				}
			}
			
			if (_target != null)
			{
				var direction:Vec2 = Vec2.get(_target.x, _target.y).sub(Vec2.get(x, y));
				if (direction.length > _minFollowDist)
				{
					direction.length = 1;
					var mult:Vec2 = direction.mul(_accelerationRate * FlxG.elapsed);
					_body.applyImpulse(mult);
				}
			}
			
			super.update();
	    }
		
		override public function kill():void
		{
			if (_body.space != null)
			{
				_body.space.bodies.remove(_body);
			}
			_bodyRegistry.unregisterBody(this, _body);
			super.kill();
		}
		
		public function addDefaultCbTypes() : void {}
		
		public function addCbType(type:CbType) : void
		{
			_body.cbTypes.add(type);
		}
		
		public function removeCbType(type:CbType) : void
		{
			_body.cbTypes.remove(type);
		}
		
		public function set collisionGroup(group:uint) : void
		{
			_collisionGroup = group;
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
		
		public function set fluidMask(mask:uint) : void
		{
			for (var i:int = 0; i < _body.shapes.length; i++)
			{
				Shape(_body.shapes.at(i)).filter.fluidMask = mask;
			}
		}
		
		public function set fluidEnabled(enabled:Boolean) : void
		{
			for (var i:int = 0; i < _body.shapes.length; i++)
			{
				Shape(_body.shapes.at(i)).fluidEnabled = enabled;
			}
		}
		
		public function followTarget(obj:FlxObject, 
									acceleration:Number,
									maxSpeed:Number,
									followDistance:int = 50) : void
		{
			_target = obj;
			_maxSpeed = maxSpeed;
			_accelerationRate = acceleration;
			_minFollowDist = followDistance
		}
		
		public function set maxSpeed(speed:Number ) : void
		{
			_maxSpeed = speed;
		}
		
		public function disable() : void
		{
			visible = false;
			_body.space = null;
			active = false;
		}
		
		public function enable(space:Space) : void
		{
			visible = true;
			_body.space = space;
			active = true;
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
		
		public function makeFluid(density:Number, viscosity:Number) : void
		{
			var fluidProperties:FluidProperties = new FluidProperties(density, viscosity);
			for (var i:int = 0; i < _body.shapes.length; i++)
			{
				Shape(_body.shapes.at(i)).fluidEnabled = true;
				Shape(_body.shapes.at(i)).fluidProperties = fluidProperties;
			}
			
			body.type = BodyType.STATIC;
		}
		
		public function setMaterial(material:Material) : void
		{
			_body.setShapeMaterials(material);
		}
		
		public function set canRotate(val:Boolean) : void
		{
			_canRotate = val;
			body.allowRotation = val;
		}
    }
}