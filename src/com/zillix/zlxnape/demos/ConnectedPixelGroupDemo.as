package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.ConnectedPixelGroup;
	import com.zillix.zlxnape.ZlxNapeSprite;
	import com.zillix.zlxnape.InteractionGroups;
	import com.zillix.utils.ZMathUtils;
	
	import org.flixel.FlxG;
	
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author zillix
	 */
	public class ConnectedPixelGroupDemo extends ZlxNapeDemo 
	{
		[Embed(source = "data/pixelTest3.png")]	public var PixelTest3:Class;
		[Embed(source = "data/pixelTest4.png")]	public var PixelTest4:Class;
		
		protected var _connectedGroup1:ConnectedPixelGroup;
		protected var _connectedGroup2:ConnectedPixelGroup;
		
		public function ConnectedPixelGroupDemo() 
		{
			_space.gravity.y = 0;
			
			var boxList1:Vector.<ZlxNapeSprite> = new Vector.<ZlxNapeSprite>();
			var boxList2:Vector.<ZlxNapeSprite> = new Vector.<ZlxNapeSprite>();
			
			var spawnedBox:ZlxNapeSprite;
			for (var i:int = 0; i < 8; i++)
			{
				for (var j:int = 0; j < 8; j++)
				{
					var amt:uint = (i + j);
					var blockColor:uint = 0xffff0000;
					
					if (amt % 2 == 0)
					{
						
						blockColor = 0xff0000ff;
					}
					
					spawnedBox = spawnBox(200 + i * 30,
						100 + j * 30, 20, 0, blockColor);
					spawnedBox.canRotate = false;
					spawnedBox.collisionGroup = InteractionGroups.BOX;
					spawnedBox.collisionMask = ~InteractionGroups.BOX;
					
					if (amt % 2 == 0)
					{
						boxList1.push(spawnedBox);
					}
					else
					{
						boxList2.push(spawnedBox);
					}
				}
			}
			
			_connectedGroup1 = new ConnectedPixelGroup(_space, boxList1);
			_connectedGroup1.loadImage(PixelTest3);
			
			_connectedGroup2 = new ConnectedPixelGroup(_space, boxList2);
			_connectedGroup2.loadImage(PixelTest4);
		}
		
		override protected function doDebugDraw() : void
		{
			super.doDebugDraw();
			_connectedGroup1.debugDraw(_debug);
			_connectedGroup2.debugDraw(_debug);
		}
		
		
		override public function update() : void
		{
			super.update();
			
			if (FlxG.keys.LEFT)
			{
				_connectedGroup1.contract(50 * FlxG.elapsed);
			}
			
			if (FlxG.keys.RIGHT)
			{
				_connectedGroup2.contract(50 * FlxG.elapsed);
			}
		}
		
		override protected function get instructionsText() : String
		{
			return super.instructionsText + "\n\n\n\n\nLeft: Contract Blue" +
				"\nRight: Contract Red";
		}
	}

}