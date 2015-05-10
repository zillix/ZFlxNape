package com.zillix.zlxnape
{
	import nape.callbacks.CbType;
	
	/**
	 * List of callback types, used for distinguishing collisions.
	 * In practical use, you'll want to add to this or copy it for your own use.
	 * @author zillix
	 */
	public class CallbackTypes 
	{
		public static var PLAYER:CbType = new CbType();
		public static var GROUND:CbType = new CbType();
		public static var ABSORB:CbType = new CbType();
		public static var BUBBLE:CbType = new CbType();
	}
	
}