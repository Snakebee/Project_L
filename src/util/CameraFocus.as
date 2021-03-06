package util 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	
	import units.Player;
	 
	public class CameraFocus extends FlxSprite
	{
		
		private var player:Player;
		private var angleBetween:Number;
		private const MIN_RADIUS:Number = 0;
		public var maxRadius:Number = 200;
		private var radius:Number;
		
		public function CameraFocus(_player:Player) 
		{
			super(_player.x, _player.y);
			player = _player;
			
			makeGraphic(player.width, player.height, 0x0);
			
			radius = MIN_RADIUS;
		}
		
		public function updateCamera():void
		{	
		
			angleBetween = FlxVelocity.angleBetweenMouse(player);
			
			//if (FlxVelocity.distanceToMouse(player) > radius)
			//{
				this.x = player.x + (radius * Math.cos(angleBetween));
				this.y = player.y + (radius * Math.sin(angleBetween));
			//}
			
			
			//Move the wand around the fairy
			
			if (FlxG.keys.pressed("SHIFT"))
			{
				if (radius < maxRadius) radius += 16;
				else radius = maxRadius;
			}
			
			else
			{
				if (radius > MIN_RADIUS)
				{
					radius -= 16;
				}
				else
				{
					radius = MIN_RADIUS;
					this.x = player.x;
					this.y = player.y;
				}
				
			}
			
		}
	}

}