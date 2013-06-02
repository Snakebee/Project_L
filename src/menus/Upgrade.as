package menus 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Upgrade extends FlxGroup
	{
		
		private var advanceConversation:Function;
		private var header:FlxText;
		
		public function Upgrade(_advanceConversation:Function) 
		{
			advanceConversation = _advanceConversation;
			
			header = new FlxText(37, 262, 468, "");
			header.setFormat("NES", 16);
			
			var background:FlxSprite = FlxGradient.createGradientFlxSprite(468, 209, [0xff0066FF, 0xff000066], 10);
			background.x = 22;
			background.y = 252;
			
			//buttonNormal.stamp(FlxGradient.createGradientFlxSprite(Width - 2, Height - 2, offColor), 1, 1);
			background.stamp(FlxGradient.createGradientFlxSprite(468, 174, [0xff0000FF, 0xff0099FF]), 22, 284);
			
			
			var vitality:FlxButtonPlus = new FlxButtonPlus(37, 299, null, null, "Vitality");
			var attack:FlxButtonPlus = new FlxButtonPlus(37, 329, null, null, "Attack");
			var defense:FlxButtonPlus = new FlxButtonPlus(37, 359, null, null, "Defense");
			var rate:FlxButtonPlus = new FlxButtonPlus(37, 389, null, null, "Rate");
			
			vitality.setMouseOverCallback(vitalityDescription);
			attack.setMouseOverCallback(attackDescription);
			defense.setMouseOverCallback(defenseDescription);
			rate.setMouseOverCallback(rateDescription);
			
			vitality.setMouseOutCallback(updateHeader);
			attack.setMouseOutCallback(updateHeader);
			defense.setMouseOutCallback(updateHeader);
			rate.setMouseOutCallback(updateHeader);
			
			var cancelButton:FlxButtonPlus = new FlxButtonPlus(37, 419, kill, null, "done");
			
			add(background);
			add(header);
			add(vitality);
			add(attack);
			add(defense);
			add(rate);
			add(cancelButton);
			
			
		}
		
		override public function update():void
		{
			super.update();
		}
		
		private function updateHeader(_description:String = null):void
		{
			switch(_description)
			{
				case "vitality":
					header.text = "Increases total health points";
					break;
				case "attack":
					header.text = "Increases damage done to foes";
					break;
				case "defense":
					header.text = "Decreases damage taken";
					break;
				case "rate":
					header.text = "Increases weapon fire rate";
					break;
				default:
					header.text = "";
					break;
			}
		}
		
		override public function kill():void
		{
			super.kill();
			advanceConversation();
		}
		
		private function vitalityDescription():void { updateHeader("vitality"); }
		private function attackDescription():void { updateHeader("attack"); }
		private function defenseDescription():void { updateHeader("defense"); }
		private function rateDescription():void { updateHeader("rate"); }
	}

}