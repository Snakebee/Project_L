package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	 import org.flixel.*;
	 import org.flixel.plugin.photonstorm.*;
	 import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	 
	 import maps.*;
	 import units.*;
	 import hud.*;
	 import items.*;
	 import weapons.*;
	 import menu.PauseMenu;
	 import util.*;
	 
	public class DungeonCrawl extends PlayState
	{
		
		public function DungeonCrawl() 
		{
		}
		
		override public function create():void
		{
			super.create();
			
			if (GameData.level < 10) areaHeader.text = " 0" + String(GameData.level);
			else areaHeader.text = " " + String(GameData.level);
		}
		
		override public function update():void
		{
			super.update();
			
			
			FlxG.overlap(player, playerHazzardsGroup, hurtObject);
			FlxG.overlap(enemiesGroup, playerBulletsGroup, hurtObject);
			FlxG.overlap(player, itemsGroup, itemPickup);
			
			//test key
			if (FlxG.keys.justPressed("SPACE"))
			{
				//diamondCounter.changeQuantity(1);
				//lifeBar.increaseBarRange();
				//player.active = !player.active;
				//FlxG.mute = !FlxG.mute;
				//trace(FlxG.mute);
			}
			
		}
		
		override public function stageInit():void
		{
			map = new DungeonMap(player, enemiesGroup, playerHazzardsGroup, collideableEnemies, enemyBullets, itemsGroup, gibsGroup, 
				lightsGroup, lifeBar, diamondCounter, spriteAddons, enemyBars, levelComplete);
		}
		
		override public function bgmInit():void
		{
			
			FlxG.playMusic(AssetsRegistry.BGM_dungeonMP3);
			if (!PauseMenu.isMusicOn) FlxG.music.pause();
			FlxG.music.survive = false;

		}
		
		
		protected function levelComplete():void
		{
			player.solid = false;
			player.alive = false;
			player.velocity.x = player.velocity.y = 0;
			
			FlxControl.clear();
			
			hudGroup.add(new TransitionScreen("levelcomplete", goNextState));
		}
		
		override public function goNextState():void
		{
			super.goNextState();
			
			GameData.level++;
			GameData.completionTime += time;
			
			FlxG.switchState(new Hub());
		}
		
		
	}

}