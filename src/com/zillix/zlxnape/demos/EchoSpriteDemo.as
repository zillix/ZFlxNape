package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.BodyContext;
	import com.zillix.zlxnape.EchoSprite;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author zillix
	 */
	public class EchoSpriteDemo extends ZlxNapeDemo 
	{
		private var _echoSprite:EchoSprite;
		
		public function EchoSpriteDemo() 
		{
			super();
			
			_echoSprite = new EchoSprite(100, 100, new FlxPoint(FlxG.width, FlxG.height), 0xff88ff88, _background);
			_echoSprite.createBody(20, 20, new BodyContext(_space, _bodyRegistry));
			_foreground.add(_echoSprite);
		}
		
		override public function update() : void
		{
			super.update();
			
			_echoSprite.x = FlxG.mouse.x;
			_echoSprite.y = FlxG.mouse.y;
		}
		
		override protected function onMousePressed() : void
		{
			super.onMousePressed();
			
			_echoSprite.centerPoint.x = FlxG.mouse.screenX;
			_echoSprite.centerPoint.y = FlxG.mouse.screenY;
		}
		
	}

}