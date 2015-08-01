package
{
	import com.zillix.zlxnape.ConnectedPixelGroup;
	import com.zillix.zlxnape.demos.ColoredBodyDemo;
	import com.zillix.zlxnape.demos.ConnectedPixelGroupDemo;
	import com.zillix.zlxnape.demos.PixelBodyReaderDemo;
	import com.zillix.zlxnape.demos.TentacleDemo;
	import com.zillix.zlxnape.demos.WaterDemo;
	import com.zillix.zlxnape.demos.ZlxNapeDemo;
	import flash.events.Event;
	
	import com.zillix.utils.ZGroupUtils;
	
	import adobe.utils.CustomActions;
	
	import flash.display.ColorCorrection;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import flash.utils.ByteArray;
	
	import org.flixel.*;
	import org.flixel.system.FlxTile;
	
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionType;
	import nape.dynamics.CollisionArbiter;
	import nape.geom.*;
	import nape.phys.*;
	import nape.space.*;
	import nape.util.*;
	
	/**
	 * This is a super straightforward wrapper that loads up various demos.
	 * @author zillix
	 */
	
	public class PlayState extends FlxState
	{
		public static var instance:PlayState;
		
		private var _activeDemo:ZlxNapeDemo;
		private var _demoText:FlxText;
		private var _instructions:FlxText;
		
		private var _demoList:Vector.<Class>;
		private var _demoLayer:FlxGroup;
		
		override public function create():void
		{
			instance = this;
			FlxG.bgColor = 0xff000000;
			
			_demoLayer = new FlxGroup();
			add(_demoLayer);
			
			_demoText = new FlxText(10, 10, 200,
				"1: Underwater" +
				"\n2: Tentacles" + 
				"\n3: Pixel Body Reader" + 
				"\n4: Colored bodies" + 
				"\n5: Connected pixel groups" +
				"\nClick: Spawn box" +
				"\n\nP: Toggle debug draw");
			_demoText.setFormat(null, 12, 0xffffffff);
			_demoText.shadow = 0xff000000;
			add(_demoText);
			
			_instructions = new FlxText(0, FlxG.height - 80, FlxG.width);
			_instructions.setFormat(null, 12, 0xffffffff, "center");
			_instructions.shadow = 0xff000000;
			add(_instructions);
			
			_demoList = Vector.<Class>(
				[
					WaterDemo,
					TentacleDemo,
					PixelBodyReaderDemo,
					ColoredBodyDemo,
					ConnectedPixelGroupDemo
				]
			);
			
			setDemo(0);
			
			// Start the game paused.
			// This can be disabled while testing locally.
			FlxG.stage.dispatchEvent(new Event(Event.DEACTIVATE));
		}
		
		override public function update():void
		{
			_activeDemo.update();
			
			if (FlxG.keys.justPressed("ONE"))
			{
				setDemo(0);
			}
			else if (FlxG.keys.justPressed("TWO"))
			{
				setDemo(1);
			}
			else if (FlxG.keys.justPressed("THREE"))
			{
				setDemo(2);
			}
			else if (FlxG.keys.justPressed("FOUR"))
			{
				setDemo(3);
			}
			else if (FlxG.keys.justPressed("FIVE"))
			{
				setDemo(4);
			}
		}
		
		private function setDemo(index:int) : void
		{
			if (index < 0 || index >= _demoList.length)
			{
				return;
			}
			
			var demoClass:Class = _demoList[index];
			var demo:ZlxNapeDemo = new demoClass() as ZlxNapeDemo;
			
			if (demo != null)
			{
				if (_activeDemo != null)
				{
					_demoLayer.remove(_activeDemo);
					_activeDemo.cleanUp();
				}
				_activeDemo = demo;
				_demoLayer.add(_activeDemo);
				_instructions.text = demo.instructionsText;
			}
		}
	}
}