package;

import flixel.FlxCamera.FlxCameraFollowStyle;
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
		
		_enemy = new Enemy(400, 300);
		add(_enemy);
		
		
		
		var barHeight:Float = 50;
		
		var cinemaBar:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, Std.int(barHeight), FlxColor.BLACK);
		add(cinemaBar);
		var cinemaBar2:FlxSprite = new FlxSprite(0, FlxG.height - barHeight).makeGraphic(FlxG.width, Std.int(barHeight), FlxColor.BLACK);
		add(cinemaBar2);
		
		cinemaBar.scrollFactor.x = cinemaBar.scrollFactor.y = 0;
		cinemaBar2.scrollFactor.x = cinemaBar2.scrollFactor.y = 0;
		
		FlxG.camera.follow(_player, FlxCameraFollowStyle.SCREEN_BY_SCREEN, 0.25);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (_player.justShot)
		{
			var flash:MuzzleFlash = new MuzzleFlash(_player.xPos, _player.y + 26);
			add(flash);
			
			FlxG.camera.shake(0.01, 0.1);
		}
		
		playerBullets.forEachAlive(collisionCheck);
		
		
	}
	
	private function collisionCheck(b:Bullet):Void
	{
		if (FlxG.overlap(b, _enemy))
		{
			_enemy.hit();
			_enemy.x += b.velocity.x * FlxG.random.float(0.001, 0.01);
			var flash:MuzzleFlash = new MuzzleFlash(b.x, b.y);
			add(flash);
			
			b.kill();
		}
	}
	
}