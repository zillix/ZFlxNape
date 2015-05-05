package com.zillix.zlxnape.renderers 
{
	import com.zillix.zlxnape.ZlxNapeSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import org.flixel.*;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import flash.utils.getTimer;
	
	/**
	 * This fluid rendering implementation borrowed somewhat from here:
	 * http://monsterbraininc.com/2013/10/liquid-simulation-in-as3-nape/
	 * @author zillix
	 */
	public class FluidRenderer  extends BlurRenderer
	{
		public function FluidRenderer(ScreenWidth:Number, 
					ScreenHeight:Number,
					Group:Array,
					CircleRadius:int = 10,
					Color:uint = 0)
		{
			if (Color == 0)
			{
				Color = 0xdd18C4C3;
			}
			
			var circleSprite:Sprite = new Sprite();
			circleSprite.graphics.beginFill(0xFF0000);
			circleSprite.graphics.drawCircle(0, 0, CircleRadius);
			circleSprite.graphics.endFill();
			super(ScreenWidth, ScreenHeight, Group, circleSprite, Color); 
			blurFilter = new BlurFilter(12, 12, 2);
		
		}
	}
	
}