package com.zillix.zlxnape
{
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
		function EchoSprite(X:Number, 
			Y:Number, 
			Width:int, 
			center:FlxPoint, 
			dimensions:FlxPoint, 
			color:uint, 
			space:Space, 
			bodyRegistry:BodyRegistry,
			backLayer:FlxGroup) : void
		{
			super(X, Y, Width, Width, space, bodyRegistry);
			makeGraphic(Width, Width, color);
			
			_centerPoint = center;
			_dimensions = dimensions;
			
			_echo = new FlxSprite(X, Y);
			_echo.makeGraphic(Width, Width, color * .5);
			_echo.alpha = .5;
			
			backLayer.add(_echo);
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