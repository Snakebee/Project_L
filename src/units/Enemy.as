package  units
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	
	import maps.Dungeon;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Enemy extends FlxSprite
	{
		
		protected var player:Player;
		protected var dungeon:Dungeon;
		protected var inSight:Boolean;
		public var aware:Boolean;
		protected var speed:int;
		protected var myPath:FlxPath;
		protected var patrolPath:FlxPath;
		protected var gibs:FlxEmitter;
		protected var itemEmitter:FlxEmitter
		private var enemyCoords:FlxPoint;
		private var playerCoords:FlxPoint;
		
		public function Enemy(_player:Player, _dungeon:Dungeon, _itemEmitter:FlxEmitter) 
		{
			super();
			
			player = _player;
			dungeon = _dungeon;
			itemEmitter = _itemEmitter;
			
			elasticity = 1;
			
			inSight = false;
			aware = false;
			
			gibs = new FlxEmitter(0, 0, 50);
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 20, 10, true, 0.5);
			gibs.particleDrag = new FlxPoint(300, 300);
			gibs.setXSpeed(-200,200);
			gibs.setYSpeed(-200,200);
			gibs.setRotation(0, 0);
			gibs.bounce = 0.5;
		}
		
		
		override public function update():void
		{
			
			enemyCoords = new FlxPoint(this.x + this.width / 2, this.y + this.height / 2);
			playerCoords = new FlxPoint(player.x + player.width / 2, player.y + player.height / 2);
			
			inSight = dungeon.dungeonMap.ray(enemyCoords, playerCoords);
			
			if (aware)
			{
				if ((myPath == null || this.path == patrolPath || this.pathSpeed == 0) && player.alive) 
				{
					destroyPath();
					
					myPath = calculatePath(enemyCoords, playerCoords);
					this.followPath(myPath, speed);
				}
				
				else this.path = dungeon.dungeonMap.findPath(enemyCoords, playerCoords);
			}
			
			else if ((!aware && inSight) && isEnemyNear())
			{
				aware = true;
				
				// Todo: signal aware sprite??
			}
			
			else
			{
				if (this.path == null || this.pathSpeed == 0)
				{
					if (this.pathSpeed == 0) destroyPath();
					
					patrolPath = calculatePath(enemyCoords, findRandEmptyTile());
					this.followPath(patrolPath, speed*2);
				}
				
			}
		}
		
		public function isEnemyNear():Boolean
		{
			return  (FlxVelocity.distanceBetween(this, player) <= (GameData.RENDER_WIDTH / 2 + GameData.RENDER_HEIGHT / 2) / 2) ? true : false;
		}
		
		private function findRandEmptyTile():FlxPoint
		{
			var randEmptyTile:FlxPoint = dungeon.emptySpaces[Math.floor(Math.random() * (dungeon.emptySpaces.length))];
			
			return new FlxPoint(randEmptyTile.x + Dungeon.TILE_SIZE / 2, randEmptyTile.y + Dungeon.TILE_SIZE / 2);
			
		}
		
		private function calculatePath(start:FlxPoint, end:FlxPoint):FlxPath
		{
			return dungeon.dungeonMap.findPath(start, end)
		}
		
		private function destroyPath():void
		{
			this.stopFollowingPath(true);
            this.velocity.x = this.velocity.y = 0;
			this.path = null;
			myPath = null
			patrolPath = null;
		}
		
		override public function hurt(_damagePoints:Number):void
		{
			super.hurt(_damagePoints);
			
			aware = true;
			
			//sound effect
			FlxG.play(AssetsRegistry.enemyHurtMP3);
		}
		
		override public function kill():void
		{
			super.kill();
			
			if(gibs != null)
			{
				gibs.at(this);
				gibs.start(true, 0, 0, 0);
			}
			
			if(itemEmitter != null)
			{
				itemEmitter.at(this);
				itemEmitter.start(true, 0, 0, 4);
			}
			
			//temp universal sound effect
			FlxG.play(AssetsRegistry.enemyDieMP3);
		}
		
		
		override public function draw():void
		{
			super.draw();
			if (this.path != null)
			{
				this.path.debugColor = 0xffFF0000;
				this.path.drawDebug();
			}
		}
		
	}
}