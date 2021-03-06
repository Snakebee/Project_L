package  units
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FlxBar;
	import maps.*;
	import weapons.*;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class RangedEnemy extends Enemy
	{
		private var isBadAss:Boolean = false;
		private var spriteAddons:FlxGroup;
		private var enemyBullets:FlxGroup;
		private var firstShotDelay:FlxDelay;
		private var fireable:Boolean = false;
		private var delayStarted:Boolean = false;
		
		private var weapon:FlxWeapon;
		private var weaponID:uint;
		
		public function RangedEnemy(_player:Player, _map:Map, _enemyBullets:FlxGroup, _spriteAddons:FlxGroup, _gibsGroup:FlxGroup, _enemyBars:FlxGroup,  _itemEmitter:FlxEmitter = null, _weaponID:int=-1, _hasPatrol:Boolean=true) 
		{
			super(_player, _map,  _itemEmitter, _hasPatrol);
			spriteAddons = _spriteAddons;
			enemyBullets = _enemyBullets;
			
			patrolSpeed = 60;
			alertSpeed = 160;
			if (_weaponID < 0) health = 3;
			else
			{
				isBadAss = true;
				health = 6;
			}
			attackValue = 1;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			loadGraphic(AssetsRegistry.guyPNG, true, true, 54, 64);
			width = 22;
			height = 38;
			offset.x = 16;
			offset.y = 13;
			this.addAnimation("idle", [24], 60);
			this.addAnimation("run", [16, 17, 18, 19, 20, 21], 10);
			this.addAnimation("walk", [16, 17, 18, 19, 20, 21], 5);
			if (_hasPatrol) this.play("walk");
			else this.play("idle");
			
			lifeBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, this.width, lifeBarHeight, this, "health", 0, health);
			lifeBar.createFilledBar(0xffFF0000, 0xff00FF00);
			lifeBar.trackParent(0, lifeBarOffset);
			lifeBar.visible = false;
			_enemyBars.add(lifeBar);
			
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 50, 10, true);
			_gibsGroup.add(gibs);
			
			var whichFacing:uint = Math.round(Math.random());
			
			if (whichFacing > 0) _facing = LEFT;
			else _facing = RIGHT;
			
			
			if(_weaponID < 0) weaponID = GameData.weapon[Math.floor(Math.random() * GameData.weapon.length)];
			else weaponID = _weaponID;
			
			chooseGun();
			
			var shotDelay:uint = FlxMath.rand(150, 301);
			
			firstShotDelay = new FlxDelay(shotDelay);
			firstShotDelay.callback = setFireable;
			
			
		}
		
		protected function chooseGun():void
		{
			if (weaponID == GameData.NORMAL_GUN)
			{
				weapon = new BaseGun("normal", this, true);
				weapon.makePixelBullet(25, 12, 12, 0xffFFFFFF, 5, 13);
				weapon.setBulletSpeed(400);
				weapon.setBulletBounds(new FlxRect(0, 0, map.tileMap.width, map.tileMap.height));
				weapon.setFireRate(GameData.NORMAL_RATE);
				weapon.setPreFireCallback(null, AssetsRegistry.shootMP3);
			}
			
			else if (weaponID == GameData.BOUNCE_GUN)
			{
				weapon = new BounceGun("bounce", this, true);
				weapon.makePixelBullet(25, 12, 12, 0xffffffff, 5, 13)
				weapon.setBulletBounds(new FlxRect(0, 0, map.tileMap.width, map.tileMap.height));
				weapon.setBulletSpeed(250);
				weapon.setFireRate(GameData.BOUNCE_RATE/2);
				weapon.setBulletElasticity(0.8);
				weapon.setBulletLifeSpan(2000);
				weapon.setPreFireCallback(null, AssetsRegistry.bounceGunMP3);
			}
			
			else if (weaponID == GameData.CROSSBOW)
			{
				weapon = new Crossbow("crossbow", enemyBullets, this, true);
				weapon.makePixelBullet(10, 12, 12, 0xffffffff, 5, 13);
				weapon.setBulletBounds(new FlxRect(0, 0, map.tileMap.width, map.tileMap.height));
				weapon.setBulletSpeed(600);
				weapon.setFireRate(GameData.CROSSBOW_RATE);
				weapon.setPreFireCallback(null, AssetsRegistry.shootMP3); 
			}
			
			else if (weaponID == GameData.SPREAD_GUN)
			{
				weapon = new SpreadGun("spread", this, true);
				weapon.makePixelBullet(25, 12, 12, 0xffFFFFFF, 5, 13);
				weapon.setBulletBounds(new FlxRect(0, 0, map.tileMap.width, map.tileMap.height));
				weapon.setBulletSpeed(600);
				weapon.setFireRate(GameData.SPREAD_RATE);
				weapon.setBulletLifeSpan(450);
				weapon.setPreFireCallback(null, AssetsRegistry.shotGunMP3); 
			}
			
			else if (weaponID == GameData.SNIPER)
			{
				weapon = new Sniper("sniper", this, true);
				weapon.makePixelBullet(25, 12, 12, 0xffFFFFFF, 5, 13);
				weapon.setBulletBounds(new FlxRect(0, 0, map.tileMap.width, map.tileMap.height));
				weapon.setBulletSpeed(600);
				weapon.setFireRate(GameData.SNIPER_RATE);
				weapon.setPreFireCallback(null, AssetsRegistry.sniperMP3);
			}
			
			enemyBullets.add(weapon.group);
			
		}
		
		override public function update():void
		{
			super.update();
			
			if (((aware && inSight) || (aware && weaponID == GameData.BOUNCE_GUN)) && this.onScreen())
			{
				// play run
				this.play("run");
				
				if (!delayStarted)
				{
					firstShotDelay.start();
					delayStarted = true;
				}
				
				if(fireable) weapon.fireAtTarget(player);
			}
		}
		
		override public function kill():void
		{
			super.kill();
			
			if (isBadAss)
			{
				GameData.weapon.push(weaponID);
				player.playNewWeapon();
			}
			
			//play sound
			if (this.onScreen()) FlxG.play(AssetsRegistry.rangedDieMP3);
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			if (firstShotDelay != null)
			{
				firstShotDelay.abort();
				firstShotDelay = null;
			}
		}
		
		private function setFireable():void
		{
			fireable = true;
		}
	}

}