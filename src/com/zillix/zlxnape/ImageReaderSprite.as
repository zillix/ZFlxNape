package com.zillix.zlxnape 
{
	import com.zillix.zlxnape.interfaces.IBoxSpawner;
	import nape.phys.Material;
	import nape.space.Space;
	import flash.display.BitmapData;
	import nape.geom.Vec2List;
	import nape.phys.BodyType;
	import nape.phys.Body;
	import nape.shape.Shape;
	import nape.shape.ShapeIterator;
	import nape.geom.Vec2;
	import org.flixel.*;
	
	/**
	 * This class was used heavily in my game 'denudation':
	 * http://ludumdare.com/compo/ludum-dare-29/?action=preview&uid=2460
	 * 
	 * Given an image class and a scale, it constructs a body fitting the image,
	 * and loads the image onto the ZlxNapeSprite.
	 * 
	 * It also has the capability to explode into a bunch of small boxes.
	 * 
	 * 
	 * @author zillix
	 */
	public class ImageReaderSprite extends ZlxNapeSprite 
	{
		protected var _polygonReader:PolygonReader;
		protected var _bodyMap:BodyMap;
		protected var _explodeDimensions:Number;
		
		// We don't always want to eject *all* of the pixels in the shape.
		// This value is used as a modulus to throttle how many pixels get ejected.
		public var pixelEjectFrequency:int = 1; 
		
		public function ImageReaderSprite(X:Number, Y:Number)
		{
			super(X, Y);
			explodeDimensions = PlayState.PIXEL_WIDTH;
		}
		
		// Use the image to create a body constituted of the pixels in the image.
		public function readImage(ImageClass:Class, space:Space, pixelScale:int, mode:int = -1, onlyColor:uint = 0) : void
		{
			if (mode < 0)
			{
				mode = PolygonReader.COLOR_SINGLE_BODY;
			}
			_polygonReader = new PolygonReader(pixelScale);
			_bodyMap = _polygonReader.readPolygon(ImageClass ,-1, mode, false, onlyColor);
			
			// NOTE: this is pretty wasteful of resources
			var bitmapData:BitmapData = (new ImageClass).bitmapData;
			var imageWidth:int = bitmapData.width;
			var imageHeight:int = bitmapData.height;
			offset = new FlxPoint(imageWidth / 2, imageHeight / 2);
			
			var body:Body = _bodyMap.getBodyByIndex();
			body.type = BodyType.KINEMATIC;
			body.translateShapes(Vec2.weak(-imageWidth *pixelScale / 2, -imageHeight * pixelScale / 2));
			loadBody(body, space,0, 0);
		}
		
		// Use the image as the graphic for the ZlxNapeSprite.
		public function loadScaledGraphic(ImageClass:Class, pixelScale:Number, animated:Boolean = false, reverse:Boolean = false, spriteWidth:Number = 0, spriteHeight:Number = 0) : void
		{
			super.loadGraphic(ImageClass, animated, reverse, spriteWidth, spriteHeight);
			var imageWidth:int = this.width;
			var imageHeight:int = this.height;
			this.scale.x = pixelScale;
			this.scale.y = pixelScale;
			_defaultScale = pixelScale;
			offset = new FlxPoint(imageWidth / 2, imageHeight / 2);
		}
		
		/*
		 * Eject all of the pixels contained in the body.
		 */
		public function explode(boxSpawner:IBoxSpawner) : void
		{
			if (shouldKillOnExplosion)
			{
				kill();
			}
			var shape:Shape;
			var iterator:ShapeIterator = body.shapes.iterator();
			var bodyCOM:Vec2 = body.position;
			var worldVerts:Vec2List;
			var comVector:Vec2 = Vec2.get();
			var tangentVector:Vec2 = Vec2.get();
			var velocityVector:Vec2 = Vec2.get();
			var box:Absorbable;
			var explodeSpeed:Number = 100;
			var index:int = 0;
			while (iterator.hasNext())
			{
				shape = iterator.next();
				worldVerts = shape.castPolygon.worldVerts;
				comVector.set(shape.worldCOM.sub(bodyCOM, true));
				if (comVector.length > 0)
				{
					velocityVector.set(comVector.copy(true).normalise().mul(explodeSpeed, true));
				}
				
				// If the body has angular velocity, eject this pixel along the tangent vector.
				if (body.angularVel != 0)
				{
					tangentVector = comVector.perp();
					if (body.angularVel < 0)
					{
						// Point it the other way, so it goes out.
						tangentVector.length = -1;
					}
					velocityVector.addeq(tangentVector.normalise().mul(body.angularVel * comVector.length))
				}
				
				// Look up what color this pixel was.
				var color:uint = _bodyMap.shapeColors[index];
				
				// Spawn a pixel box!
				box = boxSpawner.spawnBox(worldVerts.at(0).x, worldVerts.at(0).y, explodeDimensions, angle, color);
				box.body.velocity.set(velocityVector);
				
				box.body.setShapeMaterials(Material.sand());
				box.body.rotation = Math.random() * 1 - .5;
				
				// For balance reasons, we may not want to eject *all* of the pixels.
				if (index % pixelEjectFrequency != 0)
				{
					// This is kind of a hacky way to make some of the pixels immediately disappear.
					box.startAbsorb();
				}
				index++;
			}
		
			comVector.dispose();
			tangentVector.dispose();
			velocityVector.dispose();
		}
		
		protected function get shouldKillOnExplosion() : Boolean { return true; }
	}

}