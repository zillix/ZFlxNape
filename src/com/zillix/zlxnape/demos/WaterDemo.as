package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.BodyContext;
	import com.zillix.zlxnape.renderers.FluidRenderer;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author zillix
	 */
	public class WaterDemo extends ZlxNapeDemo 
	{
		private var _water:Water;
		private var _plantsLayer:FlxGroup = new FlxGroup();
		private var _bubbleLayer:FlxGroup = new FlxGroup();
		
		private var _bubbleRenderer:FluidRenderer;
		
		
		public function WaterDemo() 
		{
			super();
			
			add(_bubbleLayer);
			
			_bubbleRenderer = new FluidRenderer(FlxG.width, FlxG.height, _bubbleLayer.members);
			add(_bubbleRenderer);
			
			add(_plantsLayer);
			
			_water = new Water(0, 0, FlxG.width, FlxG.height, new BodyContext(_space, _bodyRegistry));
			add(_water);
			
			var plantCount:int = 4;
			var i:int = 0;
			var plant:Plant;
			
			// Fall plants
			for (i = 0; i < plantCount; ++i)
			{
				plant = new Plant(FlxG.width / (plantCount + 1) * (i + 1), 0, _plantsLayer, _context);
				_plantsLayer.add(plant);
			}
			
			// Rise plants
			for (i = 0; i < plantCount; ++i)
			{
				plant = new Plant(FlxG.width / (plantCount + 1) * (i + 1), FlxG.height - 100, _plantsLayer, _context, 3, 4, Plant.RISE_PLANT);
				_plantsLayer.add(plant);
			}
			
		}
		
		override protected function setUpPlayer() : void
		{
			var swimPlayer:SwimPlayer = new SwimPlayer(10, 10, _context);
			swimPlayer.bubbleEmitter = new BubbleEmitter(swimPlayer, _bubbleLayer, _context);
			_player = swimPlayer;
			add(_player);
		}
		
	}

}