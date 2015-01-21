package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.SpriteChain;
	import com.zillix.zlxnape.ZlxNapeSprite;
	
	/**
	 * ...
	 * @author zillix
	 */
	public class SpriteChainDemo extends ZlxNapeDemo 
	{
		private var _chain:SpriteChain;
		
		public function SpriteChainDemo() 
		{
			super();
			
			chain = new SpriteChain(space);
			chain.addSprite(player);
			var box:ZlxNapeSprite;
			for (var i:int = 0; i < 10; i++)
			{
				box = spawnBox(Math.random() * (FlxG.width - 200 + 100), Math.random() * (FlxG.height - 100));
				box.collisionMask = ~InteractionGroups.BOX;
				chain.addSprite(box);
			}
		}
		
		override protected function setupPlayer()
		{
			player = new Player(10, 10, space);
			add(player);
		}
		
		override public function update() : void
		{
			super.update();
			
			if (FlxG.keys.U)
			{
				if (chain)
				{
					chain.contract(30 * FlxG.elapsed);
				}
				
				if (connectedGroup)
				{
					connectedGroup.contract(100 * FlxG.elapsed);
				}
			}
		}
		
	}

}