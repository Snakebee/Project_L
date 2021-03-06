package weapons 
{
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import org.flixel.plugin.photonstorm.FlxMath;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class SpreadBullet extends Bullet
	{
		
		public function SpreadBullet(weapon:FlxWeapon, id:uint, _isEnemy:Boolean) 
		{
			super(weapon, id);
			
			attackValue = 1;
			
			if (_isEnemy)
			{
				attackValue = GameUtil.scaleDamage(attackValue);
			}
		}
		
		override public function fireAtMouse(fromX:int, fromY:int, speed:int, _deviation:Number):void
		{
			x = fromX + FlxMath.rand( -weapon.rndFactorPosition.x, weapon.rndFactorPosition.x);
			y = fromY + FlxMath.rand( -weapon.rndFactorPosition.y, weapon.rndFactorPosition.y);
			
			if (accelerates)
			{
				FlxVelocity.accelerateTowardsMouse(this, speed + FlxMath.rand( -weapon.rndFactorSpeed, weapon.rndFactorSpeed), maxVelocity.x, maxVelocity.y);
			}
			else
			{
				FlxVelocity.moveTowardsMouse(this, speed + FlxMath.rand( -weapon.rndFactorSpeed, weapon.rndFactorSpeed), 0, _deviation);
			}
			
			postFire();
		}
		
		override public function fireAtTarget(fromX:int, fromY:int, target:FlxSprite, speed:int, _deviation:Number):void
		{
			x = fromX + FlxMath.rand( -weapon.rndFactorPosition.x, weapon.rndFactorPosition.x);
			y = fromY + FlxMath.rand( -weapon.rndFactorPosition.y, weapon.rndFactorPosition.y);
			
			if (accelerates)
			{
				FlxVelocity.accelerateTowardsObject(this, target, speed + FlxMath.rand( -weapon.rndFactorSpeed, weapon.rndFactorSpeed), maxVelocity.x, maxVelocity.y);
			}
			else
			{
				FlxVelocity.moveTowardsObject(this, target, speed + FlxMath.rand( -weapon.rndFactorSpeed, weapon.rndFactorSpeed), 0, _deviation);
			}
			
			postFire();
		}
		
	}

}