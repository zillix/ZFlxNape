package com.zillix.zlxnape 
{
	/**
	 * This class is used to 
	 * @author zillix
	 */
	

	import flash.geom.Point;
	import flash.utils.Dictionary;
	import nape.phys.Body;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import nape.geom.Vec2;
	import nape.shape.ShapeList;
	import org.flixel.FlxPoint;
	
	

	public class PixelProcessor
	{
		// Each pixel is a [scale x scale] square body.
		public static const SIMPLE_SQUARE:uint = 1;
		
		// Similar to SIMPLE_SQUARE, but horizontally-adjacent squares get combined into one rectangle.
		// Very useful for optimizing bodies in large terrain.
		public static const SIMPLE_RECTANGLE_HORIZONTAL:uint = 2;
		
		// Same as SIMPLE_SQUARE, but ignores colors
		public static const SIMPLE_SINGLE_BODY:uint = 3;
		
		// Same as SIMPLE_SINGLE_BODY, but caches the pixel color for each shape
		public static const COLOR_SINGLE_BODY:uint = 4;
		
		// Simple rectangle horizontal + single body
		public static const RECTANGLE_HORIZONTAL_SINGLE_BODY:uint = 5;
	
		
		
		private var _scale:Number;
		private var _mode:uint;
		private var _bodyMap:BodyMap;
		private var _center:Boolean = false;
		
		private var _finalized:Boolean = false;
		
		// Used for finding the center point of the body
		private var _positionSumsByColor:Dictionary = new Dictionary();
		private var _numPixelsByColor:Dictionary = new Dictionary();
		
		private var _shapeColors:Vector.<uint>;
		
		
		function PixelProcessor(scale:Number, mode:uint, center:Boolean)
		{
			_scale = scale;
			_center = center;
			
			if (mode == 0)
			{
				mode = PixelProcessor.SIMPLE_SQUARE;
			}
			
			_mode = mode;
			_bodyMap = new BodyMap();
			_shapeColors = new Vector.<uint>();
		}
		

		private static const EMPTY:uint = 0xffffffff;
		private static const CLEAR:uint = 0x00000000;
		private static const BLACK:uint = 0xff000000;
		
		public function processPixel(color:uint, column:uint, row:uint, width:uint, height:uint) : void
		{
			if (_finalized)
			{
				trace("PolygonReader: Tried to process a pixel while finalized!");
				return;
			}
			
			// Don't process invalid pixels
			if (color == EMPTY || color == CLEAR)
			{
				return;
			}
			
			// Cache the color, so we can retreive them later if we want.
			if (_mode == COLOR_SINGLE_BODY)
			{
				_shapeColors.push(color);
			}
			
			
			// In single-body mode, treat every pixel as if they were the same color
			if (_mode == SIMPLE_SINGLE_BODY
				|| _mode == RECTANGLE_HORIZONTAL_SINGLE_BODY
				|| _mode == COLOR_SINGLE_BODY)
			{
				color = BLACK;
			}
			
			// Fetch the corresponding body for this color, if it exists.
			// If not, create a new body.
			var body:Body;
			if (_bodyMap.hasBodyOfColor(color))
			{
				body = _bodyMap.getBodyByColor(color);
			}
			else
			{
				body = new Body();
				_bodyMap.addBody(body, color);
			}
			
			// Register the pixel
			_bodyMap.addPixel(body, color, new FlxPoint(column, row));
			
			var x:Number = column * _scale;
			var y:Number = row * _scale;
			
			// Track the positions and quantities.
			// Used to calculate the center at the end.
			var point:Point;
			if (color in _positionSumsByColor)
			{
				point = _positionSumsByColor[color];
				point.x += x;
				point.y += y;
			}
			else
			{
				point = new Point(x, y);
			}
			
			
			var pixelCount:int = 0;
			if (color in _numPixelsByColor)
			{
				pixelCount = _numPixelsByColor[color];
			}
			
			_positionSumsByColor[color] = point;
			_numPixelsByColor[color] = pixelCount + 1;
			
			
			
			// In modes that coalesce rectangles horizontally, join
			// 	horizontally adjacent shapes into the same shape.
			var shape:Shape;
			if ((_mode == SIMPLE_RECTANGLE_HORIZONTAL
					|| _mode == RECTANGLE_HORIZONTAL_SINGLE_BODY)
				&& body.shapes.length > 0)
			{
				var lastShape:Shape = body.shapes.at(0);
				
				// Assumes each shape is a rectangle, with vert 0 as the topleft and vert 1 as the topright
				var point1:Vec2 = lastShape.castPolygon.localVerts.at(0);
				var point2:Vec2 = lastShape.castPolygon.localVerts.at(1);
				if (point1.y == y
					&& point2.x == x)
				{
					var lastShapeX:Number = point1.x;
					var lastShapeWidth:Number = point2.x - lastShapeX;
					body.shapes.remove(lastShape);
					shape = new Polygon(Polygon.rect(lastShapeX, y, _scale + lastShapeWidth, _scale));
				}
				else
				{
					shape = new Polygon(Polygon.rect(x, y, _scale, _scale));
				}
			}
			else
			{
				shape = new Polygon(Polygon.rect(x, y, _scale, _scale));
			}
			
			body.shapes.add(shape);
		}
		
		/*
		 * Repositions all of the bodies so that they are centered correctly.
		 */
		private function finalProcessing() : void
		{
			var point:Point;
			var body:Body;
			var numPixels:int;
			
			if (_center)
			{
				for (var color:String in _positionSumsByColor)
				{
					point = _positionSumsByColor[color];
					numPixels = Math.max(1, _numPixelsByColor[color]);
					body = _bodyMap.getBodyByColor(uint(color));
					
					body.translateShapes(Vec2.weak(-point.x / numPixels, -point.y / numPixels));
				}
			}
			
			if (_mode == COLOR_SINGLE_BODY)
			{
				_shapeColors.reverse();
				_bodyMap.setShapeColors(_shapeColors);
			}
		}
		
		/*
		 * Assume that ones a bodyMap is requested, we've finished reading all of the pixels.
		 */
		 
		public function getBodyMap() : BodyMap
		{
			if (!_finalized)
			{
				_finalized = true;
				finalProcessing();
			}
			return _bodyMap;
		}
	}
}