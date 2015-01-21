package com.zillix.zlxnape
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import nape.phys.Body;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	
	/**
	 * ...
	 * @author zillix
	 */
	public class PolygonReader 
	{
		// Each pixel is a [scale x scale] square body.
		public static const SIMPLE_SQUARE:uint = 1;
		// Similar to SIMPLE_SQUARE, but horizontally-adjacent squares get combined into one rectangle
		public static const SIMPLE_RECTANGLE_HORIZONTAL:uint = 2;
		// Same as SIMPLE_SQUARE, but ignores colors
		public static const SIMPLE_SINGLE_BODY:uint = 3;
		// Same as SIMPLE_SINGLE_BODY, but caches the pixel color for each shape
		public static const COLOR_SINGLE_BODY:uint = 4;
	
		
		private var _defaultScale:Number;
		function PolygonReader(defaultScale:Number )
		{
			_defaultScale = defaultScale;
		}
		
		public function readPolygon(ImageClass:Class, scale:Number = -1, mode:int = 0) : BodyMap
		{
			if (scale <= 0)
			{
				scale = _defaultScale;
			}
			
			var processor:PixelProcessor = new PixelProcessor(scale, mode);
			
			var bitmapData:BitmapData = (new ImageClass).bitmapData;
			if (bitmapData != null)
			{
				var column:uint;
				var pixel:uint;
				var bitmapWidth:uint = bitmapData.width;
				var bitmapHeight:uint = bitmapData.height;
			
				var endIndex:int = bitmapHeight - 1;
				var row:uint = 0;
				
				while(row < endIndex)
				{
					column = 0;
					while(column < bitmapWidth)
					{
						//Decide if this pixel/tile is solid (1) or not (0)
						pixel = bitmapData.getPixel32(column, row);
				
						processor.processPixel(pixel, column, row, bitmapWidth, bitmapHeight);
						
						column++;
					}
					if (row == endIndex)
					{
						break;
					}
					else
					{
						row++;
					}
				
				}
			}
			
			return processor.getBodyMap();
		}
		
	}
	
}

import flash.geom.Point;
import flash.utils.Dictionary;
import nape.phys.Body;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.geom.Vec2;
import nape.shape.ShapeList;
import PolygonReader;

class PixelProcessor
{
	private var _scale:Number;
	private var _mode:uint;
	private var _bodyMap:BodyMap;
	
	private var _finalized:Boolean = false;
	
	// Used for finding the center point of the body
	private var _positionSumsByColor:Dictionary = new Dictionary();
	private var _numPixelsByColor:Dictionary = new Dictionary();
	
	private var _shapeColors:Vector.<uint>;
	
	
	function PixelProcessor(scale:Number, mode:uint)
	{
		_scale = scale;
		
		if (mode == 0)
		{
			mode = PolygonReader.SIMPLE_SQUARE;
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
		
		if (color == EMPTY || color == CLEAR)
		{
			return;
		}
		
		if (_mode == PolygonReader.SIMPLE_SQUARE
			|| _mode == PolygonReader.SIMPLE_RECTANGLE_HORIZONTAL
			|| _mode == PolygonReader.SIMPLE_SINGLE_BODY
			|| _mode == PolygonReader.COLOR_SINGLE_BODY)
		{
			
			if (_mode == PolygonReader.COLOR_SINGLE_BODY)
			{
				_shapeColors.push(color);
			}
			
			
			if (_mode == PolygonReader.SIMPLE_SINGLE_BODY
				|| _mode == PolygonReader.COLOR_SINGLE_BODY)
			{
				color = BLACK;
			}
			
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
			
			var x:Number = column * _scale - _scale / 2;
			var y:Number = row * _scale - _scale / 2;
			
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
			
			
			
			var shape:Shape;
			if (_mode == PolygonReader.SIMPLE_RECTANGLE_HORIZONTAL
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
	}
	
	private function finalProcessing() : void
	{
		var point:Point;
		var body:Body;
		var numPixels:int;
		for (var color:String in _positionSumsByColor)
		{
			point = _positionSumsByColor[color];
			numPixels = Math.max(1, _numPixelsByColor[color]);
			body = _bodyMap.getBodyByColor(uint(color));
			
			body.translateShapes(Vec2.weak(-point.x / numPixels, -point.y / numPixels));
		}
		
		if (_mode == PolygonReader.COLOR_SINGLE_BODY)
		{
			_shapeColors.reverse();
			_bodyMap.setShapeColors(_shapeColors);
		}
	}
	
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