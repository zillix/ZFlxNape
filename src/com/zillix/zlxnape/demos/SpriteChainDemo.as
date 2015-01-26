package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.SpriteChain;
	import com.zillix.zlxnape.ZlxNapeSprite;
	import org.flixel.FlxG;
	import com.zillix.zlxnape.InteractionGroups;
	
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
			
			_chain = new SpriteChain(_space);
			_chain.addSprite(_player);
			var box:ZlxNapeSprite;
			for (var i:int = 0; i < 10; i++)
			{
				box = spawnBox(Math.random() * (FlxG.width - 200 + 100), Math.random() * (FlxG.height - 100));
				box.collisionMask = ~InteractionGroups.BOX;
				_chain.addSprite(box);
			}
		}
		
		override protected function setUpPlayer() : void
		{
			_player = new Player(10, 10, _space, _bodyRegistry);
			add(_player);
		}
		
		override public function update() : void
		{
			super.update();
			
			if (FlxG.keys.U)
			{
				_chain.contract(30 * FlxG.elapsed);
			}
		}
		
	}

}