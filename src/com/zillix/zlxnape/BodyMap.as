package com.zillix.zlxnape
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import nape.phys.Body;
	import org.flixel.FlxPoint;
	
	/**
	 * Used by several internal structures.
	 * Contains a list of bodies, with a quick lookup table for each body by its color.
	 * @author zillix
	 */
	public class BodyMap 
	{
		private var _bodiesByColor:Dictionary;
		private var _bodyList:Vector.<Body>;
		
		
		private var _pixelsByBody:Dictionary;
		
		
		private var _shapeColors:Vector.<uint>;
		
		function BodyMap()
		{
			_bodiesByColor = new Dictionary();
			_bodyList = new Vector.<Body>();
			_pixelsByBody = new Dictionary();
		}
		
		public function addBody(body:Body, color:uint) : void
		{
			if (color in _bodiesByColor)
			{
				trace("BodyMap: Overriding body of existing color " + color);
			}
			
			_bodiesByColor[color] = body;
			_bodyList.push(body);
			
			
		}
		
		public function addPixel(body:Body, color:uint, pixel:FlxPoint) : void
		{
			if (pixel != null)
			{
				
				if (_pixelsByBody[body] == null)
				{
					_pixelsByBody[body] = new Vector.<FlxPoint>();
				}
				
				_pixelsByBody[body].push(pixel);
			}
		}
		
		public function getBodyByIndex(index:int = 0) : Body
		{
			if (_bodyList.length <= index)
			{
				return null;
			}
			
			return _bodyList[index];
		}
		
		public function hasBodyOfColor(color:uint) : Boolean
		{
			return color in _bodiesByColor;
		}
		
		public function getBodyByColor(color:uint) : Body
		{
			if (color in _bodiesByColor)
			{
				return _bodiesByColor[color]
			}
			
			return null;
		}
		
		public function get bodyCount():int
		{
			return _bodyList.length;
		}
		
		public function setShapeColors(vector:Vector.<uint>) : void
		{
			_shapeColors = vector;
		}
		
		public function get shapeColors() : Vector.<uint>
		{
			return _shapeColors;
		}
		
		public function getBitmapDataForBody(body:Body) : BitmapData
		{
			if (_pixelsByBody[body] == null)
			{
				return null;
			}
			
			var color:uint = 0xff000000;
			for (var c:String in  _bodiesByColor)
			{
			
				var bdy:Body = _bodiesByColor[c];
				if (bdy == body)
				{
					color = uint(c);
				}
			}
			
			
			
			var pixels:Vector.<FlxPoint> = _pixelsByBody[body];
			var minPoint:FlxPoint;
			var maxPoint:FlxPoint;
			var pixel:FlxPoint;
			for each (pixel in pixels)
			{
				if (minPoint == null)
				{
					minPoint = new FlxPoint(pixel.x, pixel.y);
					maxPoint = new FlxPoint(pixel.x + 1, pixel.y + 1);
				}
				else
				{
					minPoint.x = Math.min(minPoint.x, pixel.x);
					minPoint.y = Math.min(minPoint.y, pixel.y);
					maxPoint.x = Math.max(maxPoint.x, pixel.x + 1);
					maxPoint.y = Math.max(maxPoint.y, pixel.y + 1);
				}
			}
			
			var bounds:Rectangle = new Rectangle(minPoint.x, minPoint.y, maxPoint.x - minPoint.x, maxPoint.y - minPoint.y);
			var bitmapData:BitmapData = new BitmapData(bounds.width, bounds.height, true);
			bitmapData.fillRect(new Rectangle(0, 0, bounds.width, bounds.height), 0x000000);
			for each (pixel in pixels)
			{
				bitmapData.setPixel32(pixel.x - minPoint.x, pixel.y - minPoint.y, color);
			}
			return bitmapData;
		}
		
	}
	
}