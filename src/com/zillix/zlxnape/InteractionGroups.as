package com.zillix.zlxnape
{
	
	/**
	 * Tracks the enums for various interaction groups.
	 * These are used to filter collisions between different objects.
	 * In reality, you'll want to copy this file or extend it on your own.
	 * 
	 * The interaction groups in Nape are used as bit flags, so each group needs to be
	 * a power of 2.
	 * @author zillix
	 */
	public class InteractionGroups 
	{
		public static var NO_COLLIDE:int = 0;
		public static var PLAYER:int = 1 << 0;
		public static var TERRAIN:int = 1 << 1
		public static var BOSS:int = 1 << 2;
		public static var SEGMENT:int = 1 << 3;
		public static var BUBBLE:int = 1 << 4;
		public static var BOX:int = 1 << 5;
		public static var ENEMY:int = 1 << 6;
	}
	
}