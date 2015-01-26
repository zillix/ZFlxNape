package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.ExplodingSprite;
	import com.zillix.zlxnape.ZlxNapeSprite;
	
	import org.flixel.FlxG;
	/**
	 * Creates an explodingSprite instance by loading a frog image.
	 * When the M key is pressed, explode the frog.
	 * @author zillix
	 */
	public class ColoredBodyDemo extends ZlxNapeDemo 
	{
		[Embed(source = "../../../../data/pixelTest2.png")]	public var PixelTest2:Class;
		
		private var _explodingSprite:ExplodingSprite;
		
		public function ColoredBodyDemo() 
		{
			_explodingSprite = new ExplodingSprite(200, 200, 20, 20, _space, _bodyRegistry, this);
			_explodingSprite.readImage(PixelTest2);
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
		
		override protected function get instructionsText() : String
		{
			return super.instructionsText + "\nSpace: Explode";
		}
		
	}

}