package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.BodyContext;
	import com.zillix.zlxnape.renderers.FluidRenderer;
	import com.zillix.utils.ZGroupUtils;
	import org.flixel.*;
	
	/**
	 * Demonstrates the FluidRenderer, a BodyChain as a tether,
	 * 	and bodychains as plants.
	 * @author zillix
	 */
	public class WaterDemo extends ZlxNapeDemo 
	{
		private var _water:Water;
		private var _plantsLayer:FlxGroup = new FlxGroup();
		private var _bubbleLayer:FlxGroup = new FlxGroup();
		private var _tubeLayer:FlxGroup = new FlxGroup();
		
		private var _bubbleRenderer:FluidRenderer;
		
		private var _submarine:BreathingTube;
		
		
		public function WaterDemo() 
		{
			super();
			
			add(_bubbleLayer);
			
			_bubbleRenderer = new FluidRenderer(FlxG.width, FlxG.height, _bubbleLayer.members);
			add(_bubbleRenderer);
			
			add(_tubeLayer);
			
			add(_plantsLayer);
			
			_water = new Water(0, 0, FlxG.width, FlxG.height, new BodyContext(_space, _bodyRegistry));
			add(_water);
			
			var plantCount:int = 4;
			var i:int = 0;
			var plant:Plant;
			
			// Fall plants
			for (i = 0; i < plantCount; ++i)
			{
				plant = new Plant(FlxG.width / (plantCount + 1) * (i + 1), 30, _plantsLayer, _context);
				_plantsLayer.add(plant);
			}
			
			// Rise plants
			for (i = 0; i < plantCount; ++i)
			{
				plant = new Plant(FlxG.width / (plantCount + 1) * (i + 1), FlxG.height - 30, _plantsLayer, _context, 3, 4, Plant.RISE_PLANT);
				_plantsLayer.add(plant);
			}
			
			_submarine = new BreathingTube(400, 100, _tubeLayer, _player, _context);
			_submarine.init();
			_tubeLayer.add(_submarine);
		}
		
		override public function update() : void
		{
			super.update();
			
			ZGroupUtils.cleanGroup(_bubbleLayer);
			
			if (FlxG.keys.justPressed("E"))
			{
				_submarine.extend(1);
			}
		}
		
		override protected function setUpPlayer() : void
		{
			var swimPlayer:SwimPlayer = new SwimPlayer(FlxG.width / 2, FlxG.height / 2, _context);
			swimPlayer.bubbleEmitter = new BubbleEmitter(swimPlayer, _bubbleLayer, _context);
			_player = swimPlayer;
			add(_player);
		}
		
		override protected function get instructionsText() : String
		{
			return super.instructionsText +
				"\nSpace: Blow bubbles" +
				"\nARROWS: Move player" +
				"\nE: Extend tube";
		}
		
	}

}