package com.zillix.zlxnape.demos
{
	import com.zillix.zlxnape.BodyRegistry;
	import com.zillix.zlxnape.ConnectedPixelGroup;
	import com.zillix.zlxnape.EchoSprite;
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
	public class ZlxNapeDemo extends FlxGroup
	{
		[Embed(source = "../../../../data/player.png")]	public var BoxSprite:Class;
		[Embed(source = "../../../../data/pixelTest1.png")]	public var PixelTest:Class;
		[Embed(source = "../../../../data/pixelTest2.png")]	public var PixelTest2:Class;
		
		private static const CLEAN_FREQ:int = 1;
		private var _cleanTime:Number = 0;
		
		protected var _player:Player;
		protected var _boss:Boss;
		
		protected var _foreground:FlxGroup;
		protected var _background:FlxGroup;
		
		protected var _boxes:FlxGroup;
		protected var _deadBoxes:FlxGroup;
		
		protected var _space:Space;
		
		private var _bodyRegistry:BodyRegistry;
		
		protected var _debug:Debug;
		
		protected var DEBUG_DRAW:Boolean = false;
		
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
			
			// Test0- echo art
			//echoSprite = new EchoSprite(100, 100, new FlxPoint(FlxG.width/2, FlxG.height/2), new FlxPoint(FlxG.width, FlxG.height), 0xff88ff88, space);
			//foreground.add(echoSprite);
			
			// Test1- extracting/contracting tentacles
			
		/*	for (var i:int = 0; i < 200; i++)
			{
				spawnBox(Math.random() * FlxG.width, Math.random() * FlxG.height);
			}
			/*
		
			
			player = new Player(10, 10, space);
			add(player);
			boss = new Boss(100, 10, space);
			add(boss);*/
			
			
			// Test2- reading bodies from pngs
			/*var polygonReader:PolygonReader = new PolygonReader(20);
			var bodyMap:BodyMap = polygonReader.readPolygon(PixelTest, -1, PolygonReader.SIMPLE_RECTANGLE_HORIZONTAL);
			var body:Body = bodyMap.getBodyByIndex();
			player = new Player(200, 10, space);
			body.translateShapes(Vec2.weak(-player.width / 2, -player.height / 2));
			
			player.loadBody(bodyMap.getBodyByIndex());
			
			add(player);
			
			var obj:ZlxNapeSprite = new ZlxNapeSprite(300, 200, 20, 20, space);
			obj.loadBody(bodyMap.getBodyByIndex(1));
			add(obj);*/
			
			// Test3- chains
			/*player = new Player(10, 10, space);
			add(player);
			chain = new SpriteChain(space);
			chain.addSprite(player);
			var box:ZlxNapeSprite;
			for (var i:int = 0; i < 10; i++)
			{
				box = spawnBox(Math.random() * (FlxG.width - 200 + 100), Math.random() * (FlxG.height - 100));
				box.collisionMask = ~InteractionGroups.BOX;
				chain.addSprite(box);
			}
			*/
			
			// Test4- colored bodies
			//var obj:ZlxNapeSprite = new ZlxNapeSprite(200, 200, 20, 20, space);
			/*var obj:ExplodingSprite = new ExplodingSprite(200, 200, 20, 20, space);
			obj.readImage(PixelTest2);
			add(obj);
			*/
			
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
		
		protected function spawnBox(x:Number, y:Number, width:int = 20, angle:Number = 0, color:uint = 0) : ZlxNapeSprite
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