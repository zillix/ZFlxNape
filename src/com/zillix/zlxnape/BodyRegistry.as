package com.zillix.zlxnape 
{
	import flash.utils.Dictionary;
	import nape.phys.Body;
	import nape.phys.Interactor;
	/**
	 * ...
	 * @author zillix
	 */
	public class BodyRegistry 
	{
		private var _bodyMap:Dictionary;
		
		public function BodyRegistry() 
		{
			_bodyMap = new Dictionary(true);
		}
		
		public function registerBody(obj:ZlxNapeSprite, body:Body) : void
		{
			_bodyMap[body] = obj;
		}
		
		public function unregisterBody(obj:ZlxNapeSprite, body:Body) : void
		{
			delete _bodyMap[body];
		}
		
		public function getSprite(interactor:Interactor) : ZlxNapeSprite
		{
			if (interactor == null || !_bodyMap.hasOwnProperty(interactor))
			{
				return null;
			}
			
			return _bodyMap[interactor];
		}
		
	}

}