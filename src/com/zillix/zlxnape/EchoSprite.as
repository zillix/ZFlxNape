package com.zillix.zlxnape
{
	import nape.phys.BodyType;
	import nape.space.Space;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * Very simple visual effect.
	 * Creates a shadow copy of the sprite that exists offset from the main sprite.
	 * @author zillix
	 */
	public class EchoSprite extends ZlxNapeSprite 
	{
		private var _echo:FlxSprite;
		private var _maxOffset:int = 10;
		private var _centerPoint:FlxPoint;
		private var _dimensions:FlxPoint;
		private var _backLayer:FlxGroup;
		function EchoSprite(X:Number, 
			Y:Number,
			screenDimensions:FlxPoint,
			color:uint,
			backLayer:FlxGroup) : void
		{
			super(X, Y);
			_dimensions = screenDimensions;
			_centerPoint = new FlxPoint(screenDimensions.x / 2, screenDimensions.y / 2);
			_backLayer = backLayer;
			this.color = color;
		}
		
		override public function createBody(Width:Number, Height:Number, bodyContext:BodyContext, bodyType:BodyType =  null, copyValues:Boolean = true) : void
		{
			super.createBody(Width, Height, bodyContext, bodyType, copyValues);
			
			makeGraphic(Width, Width, color);
			
			_echo = new FlxSprite(x, y);
			_echo.makeGraphic(Width, Width, color * .5);
			_echo.alpha = .5;
			
			_backLayer.add(_echo);
		}
		
		override public function update() : void
		{
			super.update();
			
			var xOffset:Number = (x - _centerPoint.x) / (_dimensions.x / 2);
			var yOffset:Number = (y - _centerPoint.y) / (_dimensions.y / 2);
			_echo.x = x + xOffset * _maxOffset;
			_echo.y = y + yOffset * _maxOffset;
			_echo.angle = angle;
		}
		
		public function get centerPoint() : FlxPoint
		{
			return _centerPoint;
		}
		
	}
	
}