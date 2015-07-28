package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.BodyContext;
	import com.zillix.zlxnape.BodyMap;
	import com.zillix.zlxnape.BodyRegistry;
	import com.zillix.zlxnape.PixelBodyReader;
	import com.zillix.zlxnape.ZlxNapeSprite;
	import com.zillix.zlxnape.PixelProcessor;
	import com.zillix.zlxnape.CallbackTypes;
	import nape.phys.Body;
	import nape.geom.Vec2;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	/**
	 * Uses the PixelBodyReader to read several bodies from the same input image.
	 * @author zillix
	 */
	public class PixelBodyReaderDemo extends ZlxNapeDemo 
	{
		[Embed(source = "data/pixelTest1.png")]	public var PixelTest:Class;
		
		private var _bodyMap:BodyMap;
		
		public function PixelBodyReaderDemo() 
		{
			var pixelBodyReader:PixelBodyReader  = new PixelBodyReader(scale);
			_bodyMap = pixelBodyReader.readPixels(PixelTest, -1, PixelProcessor.SIMPLE_RECTANGLE_HORIZONTAL);
			
			super();
			
			// Place several pillars on the map.
			// Body indicies will be [1, n), since the player body is on the top and will be index 0
			for (var i:int = 1; i < _bodyMap.bodyCount; i++)
			{
				var pillarBody:Body = _bodyMap.getBodyByIndex(i);
				var pillar:ZlxNapeSprite = new ZlxNapeSprite(FlxG.width / 5 + i * FlxG.width / 6, FlxG.height * 2 / 3);
				pillar.scale = scalePoint;
				
				// NOTE: Full disclosure, I'm not completely sure why the bodies need to be shifted.
				pillarBody.translateShapes(Vec2.weak( -12, -4));
				
				// Extract the pixels from the bodyMap and put them on the sprite
				pillar.pixels = _bodyMap.getBitmapDataForBody(pillarBody);
				
				pillar.loadBody(pillarBody, _context, pillar.width, pillar.height);
				
				// Mark these as 'ground', so the player can jump again if he lands on them
				pillar.addCbType(CallbackTypes.GROUND);
				add(pillar);
			}
		}
		
		override protected function setUpPlayer() : void
		{
			_player = new Player(FlxG.width / 2, FlxG.height / 4);
			
			var playerBody:Body = _bodyMap.getBodyByIndex(0);
			_player.scale = scalePoint;
			
			// NOTE: Full disclosure, I'm not completely sure why the bodies need to be shifted.
			playerBody.translateShapes(Vec2.weak(-scale / 2, -scale / 2));
			
			// Extract the pixels from the bodyMap and put them on the sprite
			_player.pixels = _bodyMap.getBitmapDataForBody(playerBody);
			
			_player.loadBody(playerBody, _context, _player.width, _player.height);
			
			// Normally the player can't rotate, but it looks way cooler if he can in this demo.
			_player.canRotate = true
			
			// Give the player a more powerful jump, since he has much more mass now!
			_player.jumpSpeed = 700;
			
			add(_player);
		}
		
		override public function get instructionsText() : String
		{
			return super.instructionsText + "\nARROWS: Move player";
		}
		
	}

}