package com.zillix.zlxnape.demos
{
	import com.zillix.zlxnape.BodyRegistry;
	import com.zillix.zlxnape.ConnectedPixelGroup;
	import com.zillix.zlxnape.EchoSprite;
	import com.zillix.zlxnape.interfaces.IBoxSpawner;
	import com.zillix.zlxnape.SpriteChain;
	import com.zillix.zlxnape.InteractionGroups;
	import com.zillix.zlxnape.ZlxNapeSprite;
	import com.zillix.zlxnape.CallbackTypes;
	import com.zillix.utils.ZMathUtils;
	import flash.utils.Dictionary;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.dynamics.CollisionArbiter;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.space.Space;
	import nape.util.BitmapDebug;
	import nape.util.Debug;
	import nape.geom.Vec2;
	import org.flixel.FlxPoint;
	
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author zillix
	 */
	public class ZlxNapeDemo extends FlxGroup implements IBoxSpawner
	{
		[Embed(source = "../../../../data/player.png")]	public var BoxSprite:Class;
		
		private static const CLEAN_FREQ:int = 1;
		private var _cleanTime:Number = 0;
		
		protected var _player:Player;
		
		protected var _foreground:FlxGroup;
		protected var _background:FlxGroup;
		
		protected var _boxes:FlxGroup;
		protected var _deadBoxes:FlxGroup;
		
		protected var _space:Space;
		
		protected var _bodyRegistry:BodyRegistry;
		
		protected var _debug:Debug;
		
		protected var DEBUG_DRAW:Boolean = false;
		
		public static const ECHO_SPRITE_DEMO:int = 1;
		public static const TENTACLE_DEMO:int = 2;
		public static const POLYGON_READER_DEMO:int = 3;
		public static const CONNECTED_PIXEL_GROUP_DEMO:int = 6;
		public static const SPRITE_CHAIN_DEMO:int = 4;
		
		public function ZlxNapeDemo() : void
		{
			_bodyRegistry = new BodyRegistry;
			
			_foreground = new FlxGroup();
			_background = new FlxGroup();
			
			add(_background);
			
			_space = new Space(new Vec2(0, 20));//70));
			
			var floor:ZlxNapeSprite = new ZlxNapeSprite(0, 450, 640, 30, _space, _bodyRegistry, BodyType.STATIC);
			floor.makeGraphic(640, 30, 0xff0000ff);
			floor.addCbType(CallbackTypes.GROUND);
			add(floor);
			
			floor = new ZlxNapeSprite(0, 0, 30, 480, _space, _bodyRegistry, BodyType.STATIC);
			floor.makeGraphic(30, 480, 0xff0000ff);
			floor.addCbType(CallbackTypes.GROUND);
			add(floor);
			
			floor = new ZlxNapeSprite(610, 0, 30, 480, _space, _bodyRegistry, BodyType.STATIC);
			floor.makeGraphic(30, 480, 0xff0000ff);
			floor.addCbType(CallbackTypes.GROUND);
			add(floor);
			
			_debug = new BitmapDebug(FlxG.width, FlxG.height, 0xdd000000, true );
			FlxG.stage.addChild(_debug.display);
			
			_boxes = new FlxGroup();
			_deadBoxes = new FlxGroup();
			
			add(_deadBoxes);
			
			add(_boxes);
			
			add(_foreground);
			
			setUpPlayer();
			
			setUpListeners();
		}
		
		override public function update() : void
		{
			super.update();
			
			_space.step(1 / 30, 5, 3);
			super.update();	
			
			if (DEBUG_DRAW)
			{
				_debug.clear();
				doDebugDraw();
				_debug.flush();
			}
			
			_cleanTime -= FlxG.elapsed;
			if (_cleanTime < 0)
			{
				// TODO: Clean
				_cleanTime = CLEAN_FREQ;
			}
			
			if (FlxG.mouse.justPressed())
			{
				onMousePressed();
			}
			
			if (FlxG.keys.justPressed("P"))
			{
				DEBUG_DRAW = !DEBUG_DRAW;
				if (!DEBUG_DRAW)
				{
					_debug.clear();
					_debug.flush();
				}
			}
		}
		
		protected function setUpPlayer() : void
		{
			// Overridden by children
		}
		
		protected function doDebugDraw() : void
		{
			_debug.draw(_space);
		}
		
		protected function onMousePressed() : void
		{
			spawnBox(FlxG.mouse.screenX, FlxG.mouse.screenY);
		}
		
		public function spawnBox(x:Number, y:Number, width:int = 20, angle:Number = 0, color:uint = 0) : ZlxNapeSprite
		{
			var color:uint = 0xff000000 + Math.random() * 0xffffff; 
			var box:EchoSprite = new EchoSprite(x, 
				y, 
				width, 
				new FlxPoint(FlxG.width / 2, FlxG.height / 2), 
				new FlxPoint(FlxG.width, FlxG.height),
				color, 
				_space,
				_bodyRegistry,
				_background);
			box.addCbType(CallbackTypes.GROUND);
			box.addCbType(CallbackTypes.ABSORB);
			box.collisionGroup = InteractionGroups.BOX;
			box.body.rotation = ZMathUtils.toRadians(angle);
			box.loadRotatedGraphic(BoxSprite, 32, -1, false, true);
			
			if (color != 0)
			{
				box.makeGraphic(width, width, color);
			}
			
			_boxes.add(box);
			
			return box;
		}
		
		private function setUpListeners() : void
		{
			var playerTouchGround:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, CallbackTypes.PLAYER, CallbackTypes.GROUND, onPlayerLand);
			_space.listeners.add(playerTouchGround);
	
			var absorb:InteractionListener = new InteractionListener(CbEvent.ONGOING, InteractionType.COLLISION, CallbackTypes.PLAYER, CallbackTypes.ABSORB, onPlayerAbsorb);
			_space.listeners.add(absorb);
		}
		
		private function onPlayerAbsorb(collision:InteractionCallback) : void
		{
			if (_bodyRegistry.getSprite(collision.int1) != null)
			{
				var obj:ZlxNapeSprite = _bodyRegistry.getSprite(collision.int1);
				var obj2:ZlxNapeSprite = _bodyRegistry.getSprite(collision.int2);
				if (obj is Player)
				{
					Player(obj).onAbsorb(obj2);
				}
			}
		}
		
		private function onPlayerLand(collision:InteractionCallback) : void
		{
			if (_bodyRegistry.getSprite(collision.int1) != null)
			{
				var colArb:CollisionArbiter = collision.arbiters.at(0) as CollisionArbiter;
				if (colArb.normal.y < 0)
				{
					var obj:ZlxNapeSprite = _bodyRegistry.getSprite(collision.int1);
					if (obj is Player)
					{
						Player(obj).onLand();
					}
				}
			}
		}
	}
	
}