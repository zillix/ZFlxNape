package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.BodyMap;
	import com.zillix.zlxnape.PolygonReader;
	import com.zillix.zlxnape.ZlxNapeSprite;
	import nape.phys.Body;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author zillix
	 */
	public class PolygonReaderDemo extends ZlxNapeDemo 
	{
		[Embed(source = "../../../../data/pixelTest1.png")]	public var PixelTest:Class;
		
		public function PolygonReaderDemo() 
		{
			var polygonReader:PolygonReader = new PolygonReader(20);
			var bodyMap:BodyMap = polygonReader.readPolygon(PixelTest, -1, PolygonReader.SIMPLE_RECTANGLE_HORIZONTAL);
			var body:Body = bodyMap.getBodyByIndex();
			body.translateShapes(Vec2.weak(-_player.width / 2, -_player.height / 2));
			
			_player.loadBody(bodyMap.getBodyByIndex());
			
			add(_player);
			
			var obj:ZlxNapeSprite = new ZlxNapeSprite(300, 200, 20, 20, _space, _bodyRegistry);
			obj.loadBody(bodyMap.getBodyByIndex(1));
			add(obj);
		}
		
		override protected function setUpPlayer() : void
		{
			_player = new Player(200, 10, _space, _bodyRegistry);
			add(_player);
		}
		
		override protected function get instructionsText() : String
		{
			return super.instructionsText + "\nWASD: Move player";
		}
		
	}

}