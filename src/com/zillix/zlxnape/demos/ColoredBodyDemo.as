package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.ExplodingSprite;
	import com.zillix.zlxnape.ZlxNapeSprite;
	/**
	 * ...
	 * @author zillix
	 */
	public class ColoredBodyDemo extends ZlxNapeDemo 
	{
		[Embed(source = "../../../../data/pixelTest2.png")]	public var PixelTest2:Class;
		
		public function ColoredBodyDemo() 
		{
			var obj:ExplodingSprite = new ExplodingSprite(200, 200, 20, 20, _space, _bodyRegistry, this);
			obj.readImage(PixelTest2);
			add(obj);
		}
		
	}

}