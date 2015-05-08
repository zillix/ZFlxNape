package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.BodyContext;
	import com.zillix.zlxnape.BodyMap;
	import com.zillix.zlxnape.BodyRegistry;
	import com.zillix.zlxnape.PolygonReader;
	import com.zillix.zlxnape.ZlxNapeSprite;
	import nape.phys.Body;
	import nape.geom.Vec2;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author zillix
	 */
	public class PolygonReaderDemo extends ZlxNapeDemo 
	{
		[Embed(source = "data/pixelTest1.png")]	public var PixelTest:Class;
		
		public static const SCALE:int = 20;
		
		public function PolygonReaderDemo() 
		{
			var scale:FlxPoint = new FlxPoint(SCALE, SCALE);
			var polygonReader:PolygonReader = new PolygonReader(SCALE);
			var bodyMap:BodyMap = polygonReader.readPolygon(PixelTest, -1, PolygonReader.SIMPLE_RECTANGLE_HORIZONTAL);
			
			var playerBody:Body = bodyMap.getBodyByIndex(0);
			var context:BodyContext = new BodyContext(_space, _bodyRegistry);
			_player.loadBody(playerBody, context, 25, 25);
			playerBody.translateShapes(Vec2.weak(-_player.width, -_player.height));
			
			_player.pixels = bodyMap.getBitmapDataForBody(playerBody);
			_player.scale = scale;
			add(_player);
			
			var objBody:Body = bodyMap.getBodyByIndex(1);
			var obj:ZlxNapeSprite = new ZlxNapeSprite(300, 200);
			obj.loadBody(objBody, new BodyContext(_space, _bodyRegistry), 20, 20);
			obj.pixels = bodyMap.getBitmapDataForBody(objBody);
			obj.scale = scale;
			add(obj);
		}
		
		override protected function setUpPlayer() : void
		{
			_player = new Player(200, 10);
			_player.createBody(20, 20, new BodyContext(_space, _bodyRegistry));
			add(_player);
		}
		
		override protected function get instructionsText() : String
		{
			return super.instructionsText + "\nARROWS: Move player";
		}
		
	}

}