package units 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	import maps.Map;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.plugin.photonstorm.FlxBar;
	 
	public class SkeletonArcher extends Skeleton
	{
		private var weapon:FlxWeapon;
		
		public function SkeletonArcher(_player:Player, _map:Map, _gibsGroup:FlxGroup, _enemyBullets:FlxGroup, _enemyBars:FlxGroup,  _itemEmitter:FlxEmitter=null) 
		{
			super(_player, _map, _gibsGroup, _enemyBars,  _itemEmitter);
			
			patrolSpeed = 160;
			alertSpeed = 200;
			health = 3;
			attackValue = 1;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			lifeBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, this.width, lifeBarHeight, this, "health", 0, health);
			lifeBar.createFilledBar(0xffFF0000, 0xff00FF00);
			lifeBar.trackParent(0, lifeBarOffset);
			lifeBar.visible = false;
			_enemyBars.add(lifeBar);
	
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 50, 10, true);
			_gibsGroup.add(gibs);
			
			weapon = new FlxWeapon("normal", this);
			weapon.makePixelBullet(12, 14, 14);
			weapon.setBulletSpeed(400);
			weapon.setBulletBounds(new FlxRect(0, 0, map.tileMap.width, map.tileMap.height));
			weapon.setFireRate(800);
			weapon.setPreFireCallback(null, AssetsRegistry.shootMP3);
			
			_enemyBullets.add(weapon.group);
		}
		
		override public function update():void
		{
			super.update();
			
			if (aware && solid && inSight && onScreen())
			{
				weapon.fireAtTarget(player);
			}
		}	
		
	}

}