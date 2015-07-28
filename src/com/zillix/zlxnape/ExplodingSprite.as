package com.zillix.zlxnape
{
	import com.zillix.zlxnape.demos.ZlxNapeDemo;
	import com.zillix.zlxnape.interfaces.IBoxSpawner;
	import flash.display.BitmapData;
	import nape.geom.Vec2List;
	import nape.phys.BodyType;
	import nape.phys.Body;
	import nape.shape.Shape;
	import nape.shape.ShapeIterator;
	import nape.space.Space;
	import nape.geom.Vec2;
	
	import org.flixel.*;
	/**
	 * Uses a PolygonReader to read in an image, which creates a body of the appropriate shape.
	 * Can explode into individual pieces, each with the correct color.
	 * @author zillix
	 */
	public class ExplodingSprite extends ZlxNapeSprite 
	{
		private var _pixelBodyReader:PixelBodyReader;
		private var _bodyMap:BodyMap;
		private var _boxSpawner:IBoxSpawner;
		
		function ExplodingSprite(X:Number, Y:Number, boxSpawner:IBoxSpawner):void
		{
			super(X, Y);
			_boxSpawner = boxSpawner;
		}
		
		public function readImage(ImageClass:Class, pixelScale:int, bodyContext:BodyContext) : void
		{
			_pixelBodyReader = new PixelBodyReader(pixelScale);
			
			// Read the body, joining all colors into the same body.
			_bodyMap = _pixelBodyReader.readPixels(ImageClass ,-1, PixelProcessor.COLOR_SINGLE_BODY);
			loadGraphic(ImageClass);
			this.scale.x = pixelScale;
			this.scale.y = pixelScale;
			
			var body:Body = _bodyMap.getBodyByIndex();
			body.translateShapes(Vec2.weak(0, height/2));
			
			loadBody(body, bodyContext, width, width); 
		}
		
		public function explode() : void
		{
			this.kill();
			
			var shape:Shape;
			var iterator:ShapeIterator = body.shapes.iterator();
			var bodyCOM:Vec2 = body.position;
			var worldVerts:Vec2List;
			var comVector:Vec2 = Vec2.get();
			var tangentVector:Vec2 = Vec2.get();
			var velocityVector:Vec2 = Vec2.get();
			var box:ZlxNapeSprite;
			var explodeSpeed:Number = 5;
			var index:int = 0;
			
			// Eject each pixel as a box with the correct color
			while (iterator.hasNext())
			{
				shape = iterator.next();
				worldVerts = shape.castPolygon.worldVerts;
				comVector.set(shape.worldCOM.sub(bodyCOM, true));
				velocityVector.set(comVector.copy(true).normalise().mul(explodeSpeed, true));
				if (body.angularVel != 0)
				{
					tangentVector = comVector.perp();
					if (body.angularVel < 0)
					{
						// Point it the other way
						tangentVector.length = -1;
					}
					velocityVector.addeq(tangentVector.normalise().mul(body.angularVel * comVector.length))
				}
				var color:uint = _bodyMap.shapeColors[index];
				box = _boxSpawner.spawnBox(worldVerts.at(0).x, worldVerts.at(0).y, scale.x, angle, color);
				box.body.velocity.set(velocityVector);
				
				index++;
			}
			
		
			comVector.dispose();
			tangentVector.dispose();
			velocityVector.dispose();
		}
		
		override public function update() : void
		{
			super.update();
		}
		
	}
	
}