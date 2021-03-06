package weapons 
{
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.*;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class BounceGun extends FlxWeapon
	{
		private var isEnemy:Boolean;
		
		public function BounceGun(name:String, parentRef:* = null, _isEnemy:Boolean=false, xVariable:String = "x", yVariable:String = "y") 
		{
			super(name, parentRef, xVariable, yVariable);
			isEnemy = _isEnemy;
		}
		
		override public function makePixelBullet(quantity:uint, width:int = 4, height:int = 4, color:uint = 0xffffffff, offsetX:int = 0, offsetY:int = 0):void
		{
			group = new FlxGroup(quantity);
			
			for (var b:uint = 0; b < quantity; b++)
			{
				var tempBullet:BounceBullet = new BounceBullet(this, b, isEnemy);
				
				tempBullet.makeGraphic(width, height, color);
				
				group.add(tempBullet);
			}
			
			positionOffset.x = offsetX;
			positionOffset.y = offsetY;
		}
		
	}

}