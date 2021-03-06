package dialogue 
{
	import hud.DiamondCounter;
	import hud.LifeBar;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import org.flixel.plugin.photonstorm.FlxGradient;
	import units.Girl;
	import units.Player;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class DialogueBox extends FlxGroup
	{
		protected var portrait:FlxSprite;
		protected var background:FlxSprite;
		protected var textField:FlxText;
		protected var isClickable:Boolean;
		protected var conversationActive:Boolean;
		
		protected var dialogueSet:Array;
		protected var counter:int = 0;
		
		protected var player:Player;
		protected var enemiesGroup:FlxGroup;
		protected var girl:Girl;
		protected var lifeBar:LifeBar;
		protected var setFireRate:Function;
		protected var diamondCounter:DiamondCounter;
		
		public function DialogueBox(_player:Player, _enemiesGroup:FlxGroup, _lifeBar:LifeBar, _setFireRate:Function, _diamondCounter:DiamondCounter, _girl:Girl=null) 
		{
			player = _player;
			girl = _girl;
			enemiesGroup = _enemiesGroup;
			
			lifeBar = _lifeBar;
			setFireRate = _setFireRate;
			diamondCounter = _diamondCounter;
			
			background = FlxGradient.createGradientFlxSprite(468, 136, [0xff0066FF, 0xff000066], 10);
			background.alpha = 0.6;
			
			textField = new FlxText(0, 0, 322, "");
			textField.setFormat("NES", 16, 0xffFFFFFF);
			
			portrait = new FlxSprite();
			
			background.x = 22+16;
			background.y = 322;
			
			textField.x = 153+16;
			textField.y = 332;
			
			portrait.x = 22+16;
			portrait.y = 278;
			
			add(background);
			add(portrait);
			add(textField);
			
			conversationActive = false;
			isClickable = true;
			
			toggle();
		}
		
		override public function update():void
		{
			super.update();
			
			if (conversationActive && isClickable)
			{
				if (FlxG.mouse.justPressed())
				{	
					counter++;
					
					if (counter == dialogueSet.length)
					{
						counter = 0;
						toggle();
						conversationActive = false;
						isClickable = true;
						dialogueSet = null;
						
						makeUnitsActive();
						return;
					}
					
					textField.text = dialogueSet[counter].message;
					changeCharPortrait(dialogueSet[counter].characterName);
					
					if (dialogueSet[counter].buttonsGroup != null)
					{
						isClickable = false;
						add(dialogueSet[counter].buttonsGroup);
					}
				}
			}
		}
		
		public function initConversation(_npcName:String):void
		{
			player.active = false;
			if(girl != null) girl.active = false;
			enemiesGroup.setAll("active", false);
			changeCharPortrait(_npcName);
			toggle();
			
			dialogueSet = DialogueRegistry.generateConversation(_npcName, advanceAfterButton, lifeBar, setFireRate, diamondCounter);
			
			textField.text = dialogueSet[counter].message;
			changeCharPortrait(dialogueSet[counter].characterName);
			conversationActive = true;
			
		}
		
		public function advanceAfterButton():void
		{
			
			//clear buttons
			dialogueSet[counter].buttonsGroup.kill();
			dialogueSet[counter].buttonsGroup.clear();
			
			counter++;
			isClickable = true;
			textField.text = dialogueSet[counter].message;
			changeCharPortrait(dialogueSet[counter].characterName);
			
		}
		
		public function changeCharPortrait(_characterName:String):void
		{
			switch(_characterName)
			{
				case "girl":
					portrait.loadGraphic(AssetsRegistry.girlPortraitPNG, false, false, 116, 174);
					break;
				case "beast":
					portrait.loadGraphic(AssetsRegistry.beastPortraitPNG, false, false, 116, 174);
					break;
				case "guy":
					portrait.loadGraphic(AssetsRegistry.guyPortraitPNG, false, false, 116, 174);
					break;
				default:
					throw new Error("Invalid character name was chosen");
					break;
			}
		}
		
		protected function toggle():void
		{
			background.visible = !background.visible;
			portrait.visible  = !portrait.visible;
			textField.visible = !textField.visible;
		}
		
		private function makeUnitsActive():void
		{
			player.active = true;
			if(girl != null) girl.active = true;
			enemiesGroup.setAll("active", true);
		}
		
	}

}