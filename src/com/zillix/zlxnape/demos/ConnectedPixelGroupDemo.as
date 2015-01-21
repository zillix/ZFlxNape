package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.ConnectedPixelGroup;
	import com.zillix.zlxnape.ZlxNapeSprite;
	
	import org.flixel.FlxG;
	
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author zillix
	 */
	public class ConnectedPixelGroupDemo extends ZlxNapeDemo 
	{
		[Embed(source = "../../../../data/pixelTest3.png")]	public var PixelTest3:Class;
		
		protected var _connectedGroup:ConnectedPixelGroup;
		
		public function ConnectedPixelGroupDemo() 
		{
			var boxList:Vector.<ZlxNapeSprite> = new Vector.<ZlxNapeSprite>();
			var spawnedBox:ZlxNapeSprite;
			for (var i:int = 0; i < 50; i++)
			{
				spawnedBox = spawnBox(Math.random() * (FlxG.width - 200 + 100), Math.random() * (FlxG.height - 100));
				boxList.push(spawnedBox);
			}
			
			_connectedGroup = new ConnectedPixelGroup(_space, boxList);
			_connectedGroup.loadImage(PixelTest3);
			
			var anchor:ZlxNapeSprite = _connectedGroup.usedSprites[0];
			anchor.body.position.set(Vec2.weak(200, 10));
			anchor.body.type = BodyType.KINEMATIC;
		}
		
		override protected function doDebugDraw() : void
		{
			super.doDebugDraw();
			_connectedGroup.debugDraw(_debug);
		}
		
		
	}

}