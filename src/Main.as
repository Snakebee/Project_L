package 
{
	import menu.PauseMenu;
	import org.flixel.FlxGame;
	import org.flixel.FlxG;
	import flash.events.Event;
	import com.newgrounds.components.*;

	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	[SWF(width="540", height="480", backgroundColor="#000000")]
	[Frame(factoryClass = "Preloader")]
	
	public class Main extends FlxGame 
	{
		
		public function Main():void 
		{
			super(GameData.RENDER_WIDTH, GameData.RENDER_HEIGHT, TitleScreen, 1, 60, 60, false);
			
			FlxG.mouse.load(AssetsRegistry.crosshairPNG, 1, -14, -14);
			
			forceDebugger = true;
		}
		
		
		override protected function create(FlashEvent:Event):void
		{
			super.create(FlashEvent);
			stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
			stage.removeEventListener(Event.ACTIVATE, onFocus);
			
			var medalPopup:MedalPopup = new MedalPopup();
            medalPopup.x = GameData.RENDER_WIDTH / 2 - medalPopup.width / 2;
			medalPopup.y = GameData.RENDER_HEIGHT - medalPopup.height;
            stage.addChild(medalPopup);
		}
		

	}

}