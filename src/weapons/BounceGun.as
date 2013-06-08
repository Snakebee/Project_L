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
		
		private var spriteAddons:FlxGroup;
		
		public function BounceGun(name:String, _spriteAddons:FlxGroup, parentRef:* = null, xVariable:String = "x", yVariable:String = "y") 
		{
			super(name, parentRef, xVariable, yVariable);
			
			spriteAddons = _spriteAddons;
		}
		
		override public function makePixelBullet(quantity:uint, width:int = 2, height:int = 2, color:uint = 0xffffffff, offsetX:int = 0, offsetY:int = 0):void
		{
			group = new FlxGroup(quantity);
			
			for (var b:uint = 0; b < quantity; b++)
			{
				var tempBullet:BounceBullet = new BounceBullet(this, b, spriteAddons);
				
				tempBullet.makeGraphic(width, height, color);
				tempBullet.width = width;
				tempBullet.height = height;
				
				tempBullet.setTrail();
				
				group.add(tempBullet);
			}
			
			positionOffset.x = offsetX;
			positionOffset.y = offsetY;
		}
		
	}

}