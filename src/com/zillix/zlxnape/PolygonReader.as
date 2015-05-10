package com.zillix.zlxnape
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import nape.phys.Body;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	
	/**
	 * Wrapper around a pixelProcessor.
	 * Adds support for reading an input image, and feeding the pixels into a pixelProcessor.
	 * Outputs a BodyMap, with the bodies grouped according to the input mode.
	 * @author zillix
	 */
	public class PolygonReader 
	{
		private var _defaultScale:Number;
		function PolygonReader(defaultScale:Number )
		{
			_defaultScale = defaultScale;
		}
		
		public function readPolygon(ImageClass:Class, scale:Number = -1, mode:int = 0, center:Boolean = true, onlyColor:uint = 0x00000000) : BodyMap
		{
			if (scale <= 0)
			{
				scale = _defaultScale;
			}
			
			var processor:PixelProcessor = new PixelProcessor(scale, mode, center);
			
			var bitmapData:BitmapData = (new ImageClass).bitmapData;
			if (bitmapData != null)
			{
				var column:uint;
				var pixel:uint;
				var bitmapWidth:uint = bitmapData.width;
				var bitmapHeight:uint = bitmapData.height;
			
				var endIndex:int = bitmapHeight;
				var row:uint = 0;
				
				while(row < endIndex)
				{
					column = 0;
					while(column < bitmapWidth)
					{
						//Decide if this pixel/tile is solid (1) or not (0)
						pixel = bitmapData.getPixel32(column, row);
				
						// Skip this pixel if we're filtering just for one color, and it doesn't match that color
						if (onlyColor == 0 || pixel == onlyColor)
						{
							processor.processPixel(pixel, column, row, bitmapWidth, bitmapHeight);
						}
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