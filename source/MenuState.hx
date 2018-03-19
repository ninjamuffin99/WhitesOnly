package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	private var _txtTitle:FlxText;
	private var _txtTitle2:FlxText;
	
	override public function create():Void
	{
		FlxG.camera.bgColor = FlxColor.GRAY;
		
		_txtTitle = new FlxText(0, 0, 0, "WHITES", 64);
		add(_txtTitle);
		_txtTitle.screenCenter();
		
		_txtTitle2 = new FlxText(0, FlxG.height / 2 + 52, 0, "ONLY", 64);
		_txtTitle2.color = FlxColor.BLACK;
		add(_txtTitle2);
		_txtTitle2.screenCenter(X);
		
		_txtTitle2.x += 40;
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.ANY)
		{
			FlxG.camera.camera.fade(FlxColor.GRAY, 2, false, finishFade);
		}
		
	}
	
	private function finishFade():Void
	{
		FlxG.switchState(new PlayState());
	}
}