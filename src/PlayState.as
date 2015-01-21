package
{
	import com.zillix.zlxnape.demos.ConnectedPixelGroupDemo;
	import com.zillix.zlxnape.demos.EchoSpriteDemo;
	import com.zillix.zlxnape.demos.ZlxNapeDemo;
	
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
		
		override public function create():void
		{
			instance = this;
			FlxG.bgColor = 0xffffffff;
			
			// Test 1: EchoSprite effect
			//_activeDemo = new EchoSpriteDemo();
			
			// Test 2: SpriteChain Tentacles
			
			// Test 3:
			
			// Test 5: ConnectedPixelGroup
			_activeDemo = new ConnectedPixelGroupDemo();
			
			add(_activeDemo);
			
			Mouse.show();
			
			
		}
		
		override public function update():void
		{
			_activeDemo.update();
		}
	}
}