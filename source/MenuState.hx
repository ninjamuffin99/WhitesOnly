package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	private var instructions:FlxText;
	private var inputs:FlxInputText;
	private var btnEnter:FlxButton;
	private var thingsLiked:FlxText;
	private var thingsDisliked:FlxText;
	
	private var tempLikesArray:Array<String> = [];
	private var tempDislikesArray:Array<String> = [];
	
	override public function create():Void
	{
		instructions = new FlxText(0, 32, 0, "Type in things you like then press enter", 16);
		instructions.screenCenter(X);
		add(instructions);
		
		thingsLiked = new FlxText(20, 66, 0, "things you like: ", 16);
		add(thingsLiked);
		
		thingsDisliked = new FlxText(FlxG.width - 300, 66, 0, "things you DO NOT like: ", 16);
		thingsDisliked.alignment = FlxTextAlign.RIGHT;
		add(thingsDisliked);
		
		inputs = new FlxInputText(0, 170, 200, "", 16);
		inputs.screenCenter(X);
		add(inputs);
		
		btnEnter = new FlxButton(0, inputs.y + inputs.height + 16, "Enter", addThingsLiked);
		btnEnter.screenCenter(X);
		add(btnEnter);
		
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (inputs.hasFocus && FlxG.keys.justPressed.ENTER)
		{
			addThingsLiked();
		}
	}
	
	private function addThingsLiked():Void
	{
		if (inputs.text.length > 1)
		{
			if (tempLikesArray.length <= 5)
			{
				thingsLiked.text += "\n" + inputs.text;
				tempLikesArray.push(inputs.text);
				
			}
			else
			{
				thingsDisliked.text += "\n" + inputs.text;
				tempDislikesArray.push(inputs.text);
			}
			inputs.text = "";
			
			if (tempDislikesArray.length >= 5)
			{
				FlxG.switchState(new PlayState());
			}
		}
	}
}