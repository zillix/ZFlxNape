package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.BodyContext;
	import com.zillix.zlxnape.ExplodingSprite;
	import com.zillix.zlxnape.ZlxNapeSprite;
	
	import org.flixel.FlxG;
	/**
	 * Creates an explodingSprite instance by loading a frog image.
	 * When the Space key is pressed, explode the frog.
	 * @author zillix
	 */
	public class ColoredBodyDemo extends ZlxNapeDemo 
	{
		[Embed(source = "data/pixelTest2.png")]	public var PixelTest2:Class;
		
		private var _explodingSprite:ExplodingSprite;
		
		public function ColoredBodyDemo() 
		{
			_explodingSprite = new ExplodingSprite(FlxG.width / 2, FlxG.height / 2, this);
			_explodingSprite.readImage(PixelTest2, scale, new BodyContext(_space, _bodyRegistry));
			_explodingSprite.body.angularVel = 2;	// Give it a little kick for fun
			add(_explodingSprite);
		}
		
		override public function update() : void
		{
			super.update();
			
			if (FlxG.keys.justPressed("SPACE") && _explodingSprite.alive)
			{
				_explodingSprite.explode();
			}
		}
		
		override public function get instructionsText() : String
		{
			return super.instructionsText + "\nSpace: Explode";
		}
		
		override protected function get gravity() : int
		{
			// No gravity for this demo!
			return 0;
		}
		
	}

}