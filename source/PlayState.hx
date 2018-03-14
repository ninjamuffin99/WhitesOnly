package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _enemy:Enemy;
	
	private var playerBullets:FlxTypedGroup<Bullet>;
	
	override public function create():Void
	{
		FlxG.camera.bgColor = FlxColor.GRAY;
		
		playerBullets = new FlxTypedGroup<Bullet>();
		add(playerBullets);
		
		_player = new Player(20, 300, playerBullets);
		add(_player);
		
		
		
		var barHeight:Float = 50;
		
		var cinemaBar:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, Std.int(barHeight), FlxColor.BLACK);
		add(cinemaBar);
		var cinemaBar2:FlxSprite = new FlxSprite(0, FlxG.height - barHeight).makeGraphic(FlxG.width, Std.int(barHeight), FlxColor.BLACK);
		add(cinemaBar2);
		
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (_player.justShot)
		{
			var flash:MuzzleFlash = new MuzzleFlash(_player.xPos, _player.y + 26);
			add(flash);
		}
		
	}
}