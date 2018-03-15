package;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private var _player:Player;
	private var playerBullets:FlxTypedGroup<Bullet>;
	
	private var _enemy:Enemy;
	private var _enemyThoughts:FlxTypedGroup<Thoughts>;
	
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	
	private var _grpPeople:FlxTypedGroup<FlxSprite>;
	
	override public function create():Void
	{
		FlxG.camera.bgColor = FlxColor.GRAY;
		
		_map = new FlxOgmoLoader(AssetPaths.level1__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 32, 32, "Floors");
		_mWalls.setTileProperties(1, FlxObject.ANY);
		add(_mWalls);
		
		_grpPeople = new FlxTypedGroup<FlxSprite>();
		add(_grpPeople);
		
		playerBullets = new FlxTypedGroup<Bullet>();
		add(playerBullets);
		
		_enemyThoughts = new FlxTypedGroup<Thoughts>();
		add(_enemyThoughts);
		
		_player = new Player(20, 300, playerBullets);
		_grpPeople.add(_player);
		
		_enemy = new Enemy(400, 300);
		_grpPeople.add(_enemy);
		
		
		var barHeight:Float = 50;
		
		var cinemaBar:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, Std.int(barHeight), FlxColor.BLACK);
		add(cinemaBar);
		var cinemaBar2:FlxSprite = new FlxSprite(0, FlxG.height - barHeight).makeGraphic(FlxG.width, Std.int(barHeight), FlxColor.BLACK);
		add(cinemaBar2);
		
		cinemaBar.scrollFactor.x = cinemaBar.scrollFactor.y = 0;
		cinemaBar2.scrollFactor.x = cinemaBar2.scrollFactor.y = 0;
		
		FlxG.camera.follow(_player, FlxCameraFollowStyle.SCREEN_BY_SCREEN, 0.25);
		
		_grpPeople.forEach(initPeople);
		
		super.create();
	}
	
	private function initPeople(p:FlxSprite):Void
	{
		p.acceleration.y = 600;
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
		
		FlxG.collide(_grpPeople, _mWalls);
		
		if (FlxMath.distanceBetween(_player, _enemy) < 94 && !_enemy.justThought)
		{
			enemyThink();
		}
	}
	
	private function enemyThink():Void
	{
		_enemy.justThought = true;
		var thought:Thoughts = new Thoughts(_enemy.x, _enemy.y - 68, 100, "This is my thought", 16);
		add(thought);
		
		FlxTween.tween(thought, {y: thought.y - 10}, 1.25, {ease:FlxEase.quartOut});
		
	}
	
	
	private function collisionCheck(b:Bullet):Void
	{
		if (FlxG.overlap(b, _enemy) && _enemy.color != FlxColor.WHITE)
		{
			_enemy.hit();
			_enemy.x += b.velocity.x * FlxG.random.float(0.001, 0.01);
			var flash:MuzzleFlash = new MuzzleFlash(b.x, b.y);
			add(flash);
			
			b.kill();
		}
	}
	
}