package 
{
	import org.flixel.*;
	[SWF(width="370", height="320", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	public class Main extends FlxGame
	{
		public function Main():void
		{
			super(370, 320, PlayState, 1);
			useSystemCursor = true;
		}
	}
}