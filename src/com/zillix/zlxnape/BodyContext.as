package com.zillix.zlxnape
{
	import com.zillix.zlxnape.BodyRegistry;
	import nape.phys.Body;
	import nape.space.Space;
	
	/**
	 * Simple structure to contain all information needed to construct a body.
	 * @author zillix
	 */
	public class BodyContext 
	{
		private var _space:Space;
		private var _bodyRegistry:BodyRegistry;
		
		public function BodyContext(space:Space, bodyRegistry:BodyRegistry)
		{
			_space = space;
			_bodyRegistry = bodyRegistry;
		}
		
		public function get space() : Space
		{
			return _space;
		}
		
		public function get bodyRegistry() : BodyRegistry
		{
			return _bodyRegistry;
		}
	}
	
}