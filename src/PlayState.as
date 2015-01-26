package
{
	import com.zillix.zlxnape.ConnectedPixelGroup;
	import com.zillix.zlxnape.demos.ColoredBodyDemo;
	import com.zillix.zlxnape.demos.ConnectedPixelGroupDemo;
	import com.zillix.zlxnape.demos.EchoSpriteDemo;
	import com.zillix.zlxnape.demos.PolygonReaderDemo;
	import com.zillix.zlxnape.demos.SpriteChainDemo;
	import com.zillix.zlxnape.demos.TentacleDemo;
	import com.zillix.zlxnape.demos.ZlxNapeDemo;
	
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
	
	

	public class PlayState extends FlxState
	{
		public static var instance:PlayState;
		
		private var _activeDemo:ZlxNapeDemo;
		private var _demoText:FlxText;
		
		override public function create():void
		{
			instance = this;
			FlxG.bgColor = 0xffffffff;
			
			_demoText = new FlxText(50, 10, 200,
				"1: Echo sprites" + 
				"\n2: Tentacles" + 
				"\n3: Polygon Reader" + 
				"\n4: Sprite chains" + 
				"\n5: Colored bodies" + 
				"\n6: Connected pixel groups" + 
				"\n\nClick: Spawn box" + 
				"\n\nP: Toggle debug draw");
			_demoText.setFormat(null, 8, 0x000000);
			add(_demoText);
			
			setDemo(new ColoredBodyDemo());
			
			Mouse.show();
			
			
		}
		
		override public function update():void
		{
			_activeDemo.update();
			
			if (FlxG.keys.justPressed("ONE"))
			{
				setDemo(new EchoSpriteDemo());
			}
			else if (FlxG.keys.justPressed("TWO"))
			{
				setDemo(new TentacleDemo());
			}
			else if (FlxG.keys.justPressed("THREE"))
			{
				setDemo(new PolygonReaderDemo());
			}
			else if (FlxG.keys.justPressed("FOUR"))
			{
				setDemo(new SpriteChainDemo());
			}
			else if (FlxG.keys.justPressed("FIVE"))
			{
				setDemo(new ColoredBodyDemo());
			}
			else if (FlxG.keys.justPressed("SIX"))
			{
				setDemo(new ConnectedPixelGroupDemo());
			}
		}
		
		private function setDemo(demo:ZlxNapeDemo) : void
		{
			if (_activeDemo != null)
			{
				remove(_activeDemo);
				_activeDemo.cleanUp();
			}
			_activeDemo = demo;
			add(_activeDemo);
		}
	}
}