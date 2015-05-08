package com.zillix.zlxnape.renderers
{
	import com.zillix.zlxnape.ZlxNapeSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import flash.utils.getTimer;
	import com.zillix.utils.ZMathUtils;
	
	/**
	 * This fluid rendering implementation borrowed somewhat from here:
	 * http://monsterbraininc.com/2013/10/liquid-simulation-in-as3-nape/
	 * @author zillix
	 */
	public class BlurRenderer  extends FlxSprite
	{
		// Used for determining how soft the edges will be.
		// Min detail has no soft edges.
		public static const DETAIL_MIN:int = 0;
		public static const DETAIL_MID:int = 1;
		public static const DETAIL_MAX:int = 2;
		
		private var _detailLevel:int;
		
		private var _transMatrix:Matrix;
		
		private var _drawCanvasData:BitmapData;
		private var _drawCanvasDataCopy:BitmapData;
		
		private var _sourceSprite:Sprite;
		
		protected var _blurFilter:BlurFilter = new BlurFilter(8, 8, 6);
		private var _group:Array;
		
		private var _nextDrawTime:int = 0;
		private static const DRAW_FREQ:Number = .02;
		
		private var _maxThresholdColor:uint;
		private var _midThresholdColor:uint;
		private var _minThresholdColor:uint;
		
		private static var zeroPoint:Point = new Point(0, 0);
		
		// Internally used to determine min bounding box that needs to be updated
		private var _minPoint:Point = new Point();
		private var _maxPoint:Point = new Point();
		private var _lastMinPoint:Point = new Point();
		private var _lastMaxPoint:Point = new Point();
		private var _updateRect:Rectangle = new Rectangle();
		private var _destPoint:Point = new Point(0, 0);
		
		private var _rotateSprites:Boolean; // Defaults to true. Set to false if you are only drawing circles.
		
		private var _camera:FlxCamera;
		
		
		public function BlurRenderer(ScreenWidth:Number, 
									ScreenHeight:Number, 
									Group:Array,
									SourceSprite:Sprite,
									Camera:FlxCamera,
									Color:uint = 0xffffff,
									RotateSprites:Boolean = true,
									DetailLevel:int = DETAIL_MIN)
		{
			super(0, 0);
			
			_camera = Camera;
			_rotateSprites = RotateSprites;
			
			_sourceSprite = SourceSprite;
			
			_minThresholdColor = ZMathUtils.setAlpha(Color, 255);
			_midThresholdColor = ZMathUtils.setAlpha(Color, 187);
			_maxThresholdColor = ZMathUtils.setAlpha(Color, 55);
			
			scrollFactor = new FlxPoint(0, 0);
			
			_drawCanvasData = new BitmapData(ScreenWidth, ScreenHeight, false, 0x00FFFFFF);
			_drawCanvasDataCopy = new BitmapData(ScreenWidth, ScreenHeight, true, 0x00FFFFFF);
			
			_transMatrix = new Matrix();
			
			_group = Group;
			_detailLevel = DetailLevel;
		}
		
		override public function draw() : void
		{
			var time:int = getTimer();
			
			if (_group.length == 0)
			{
				return;
			}
			
			if (time > _nextDrawTime)
			{
				_nextDrawTime = time + 1000 * DRAW_FREQ;
			
				_drawCanvasData.fillRect(_drawCanvasData.rect, 0x00000000);
				
				// Reset the update rectangle
				_minPoint.x = _drawCanvasData.width;
				_minPoint.y = _drawCanvasData.height;
				_maxPoint.x = 0;
				_maxPoint.y = 0;
				
				for (var i:int = 0; i < _group.length; i++)
				{
					var member:FlxSprite = _group[i] as FlxSprite;
					if (!member || !member.active)
					{
						continue;
					}
					
					var xPos:int = member.x - _camera.scroll.x;
					var yPos:int = member.y - _camera.scroll.y;
					var buffer:int = 30;	// padding added to the min rectangle
					var scale:Number = member.scale.x;
					
					// Only draw things that are onscreen
					if (scale > 0
						&& xPos >= -buffer && xPos < _drawCanvasData.width + buffer
						&& yPos >= -buffer && yPos < _drawCanvasData.height + buffer)
					{
						// Calculate the minimum bounding box of what needs to be redrawn
						_minPoint.x = Math.min(_minPoint.x, xPos - buffer); 
						_minPoint.y = Math.min(_minPoint.y, yPos - buffer);
						_maxPoint.x = Math.max(_maxPoint.x, xPos + buffer); 
						_maxPoint.y = Math.max(_maxPoint.y, yPos + buffer);
					
						_transMatrix.scale(scale, scale);
						
						// Don't bother rotating the sprites if we don't need to (for circles)
						if (_rotateSprites)
						{
							_transMatrix.rotate(ZMathUtils.toRadians(member.angle));
						}
						
						_transMatrix.tx = xPos;
						_transMatrix.ty = yPos;
 						_drawCanvasData.draw(_sourceSprite, _transMatrix);
						
						if (_rotateSprites)
						{
							_transMatrix.rotate(-ZMathUtils.toRadians(member.angle));
						}
						
						_transMatrix.scale(1 / scale, 1 / scale);
					}
					
				}
				
				if (_maxPoint.x - _minPoint.x <= 0)
				{
					// Don't redraw if nothing is onscreen
					return;
				}
				
				// Keep everything in sane bounds
				_minPoint.x = Math.max(0, _minPoint.x);
				_minPoint.y = Math.max(0, _minPoint.y);
				
				_maxPoint.x = Math.min(_drawCanvasData.width, _maxPoint.x);
				_maxPoint.y = Math.min(_drawCanvasData.height, _maxPoint.y);
				
				
				
				// Calculate the minimum rectangle needed to update the image
				
				_destPoint.x = Math.min(_minPoint.x, _lastMinPoint.x);
				_destPoint.y = Math.min(_minPoint.y, _lastMinPoint.y);
				
				_updateRect.x = _destPoint.x;
				_updateRect.y = _destPoint.y;
				_updateRect.width = Math.max(_maxPoint.x, _lastMaxPoint.x) - _updateRect.x;
				_updateRect.height =  Math.max(_maxPoint.y, _lastMaxPoint.y) - _updateRect.y;
				
				// Blur the bitmapdata
				_drawCanvasData.applyFilter(_drawCanvasData, _updateRect, _destPoint, _blurFilter);
				
				// Copy the pixels to the output, then use the threshold operation to project the blurred image to different alpha values.
				_drawCanvasDataCopy.fillRect(_updateRect, 0x00000000);
				
				if (_detailLevel >= DETAIL_MAX)
				{
					_drawCanvasDataCopy.threshold(_drawCanvasData, _updateRect, _destPoint, ">", 0XFF2b2b2b, _maxThresholdColor, 0xFFFFFFFF, false);
				}
				if (_detailLevel >= DETAIL_MID)
				{
					_drawCanvasDataCopy.threshold(_drawCanvasData, _updateRect, _destPoint, ">", 0XFF2c2c2c, _midThresholdColor, 0xFFFFFFFF, false);
				}
				_drawCanvasDataCopy.threshold(_drawCanvasData,_updateRect, _destPoint, ">", 0XFF2d2d2d, _minThresholdColor, 0xFFFFFFFF, false);
				
				_lastMaxPoint.x = _maxPoint.x;
				_lastMaxPoint.y = _maxPoint.y;
				_lastMinPoint.x = _minPoint.x;
				_lastMinPoint.y = _minPoint.y;
			}
			
			_camera.buffer.draw(_drawCanvasDataCopy,_matrix,null,blend,null,antialiasing);
		}
	}
	
}