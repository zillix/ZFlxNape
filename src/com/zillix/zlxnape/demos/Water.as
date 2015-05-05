package com.zillix.zlxnape.demos 
{
	import com.zillix.zlxnape.BodyContext;
	import com.zillix.zlxnape.*;
	import nape.phys.BodyType;
	import nape.phys.FluidProperties;
	
	/**
	 * ...
	 * @author zillix
	 */
	public class Water extends ZlxNapeSprite 
	{
		public static var DENSITY:int = 3;
		
		public function Water(X:Number, Y:Number, Width:Number, Height:Number, Context:BodyContext)
		{
			super(X, Y);
			createBody(Width, Height, Context, BodyType.STATIC);
			var fluidProperties:FluidProperties = new FluidProperties(DENSITY, 2);
			body.setShapeFluidProperties(fluidProperties);
			collisionMask = 0;
			fluidMask = ~InteractionGroups.NO_COLLIDE;
			fluidEnabled = true;
			
			makeGraphic(Width, Height, 0x220000ff);
	
		}
	}
}