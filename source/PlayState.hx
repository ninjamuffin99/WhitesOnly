package;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;
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
	private var _grpEnemies:FlxTypedGroup<Enemy>;
	
	private var wasdTxt:FlxText;
	private var _txtShoot:FlxText;
	
	override public function create():Void
	{
		FlxG.camera.bgColor = FlxColor.GRAY;
		FlxG.camera.fade(FlxColor.GRAY, 2, true);
		
		_map = new FlxOgmoLoader(AssetPaths.level1__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 32, 32, "Floors");
		_mWalls.setTileProperties(1, FlxObject.ANY);
		add(_mWalls);
		
		_grpPeople = new FlxTypedGroup<FlxSprite>();
		add(_grpPeople);
		
		_grpEnemies = new FlxTypedGroup<Enemy>();
		add(_grpEnemies);
		
		playerBullets = new FlxTypedGroup<Bullet>();
		add(playerBullets);
		
		_enemyThoughts = new FlxTypedGroup<Thoughts>();
		add(_enemyThoughts);
		
		_player = new Player(20, 300, playerBullets);
		_grpPeople.add(_player);
		
		_map.loadEntities(placeEntities, "entities");
		
		FlxG.worldBounds.setSize(10000, 10000);
		
		wasdTxt= new FlxText(_player.x - 64, _player.y - 100, 0, "A & D == Move", 16);
		add(wasdTxt);
		
		_txtShoot = new FlxText(_player.x + 100, _player.y - 100, 0, "Spacebar to shoot", 16);
		add(_txtShoot);
		_txtShoot.visible = false;
		
		
		var barHeight:Float = 50;
		
		var cinemaBar:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, Std.int(barHeight), FlxColor.BLACK);
		//add(cinemaBar);
		var cinemaBar2:FlxSprite = new FlxSprite(0, FlxG.height - barHeight).makeGraphic(FlxG.width, Std.int(barHeight), FlxColor.BLACK);
		//add(cinemaBar2);
		
		cinemaBar.scrollFactor.x = cinemaBar.scrollFactor.y = 0;
		cinemaBar2.scrollFactor.x = cinemaBar2.scrollFactor.y = 0;
		
		FlxG.camera.follow(_player, FlxCameraFollowStyle.SCREEN_BY_SCREEN, 0.25);
		FlxG.camera.deadzone = FlxRect.get(0, cinemaBar.height, FlxG.width, cinemaBar2.y);
		
		_grpPeople.forEach(initPeople);
		_grpEnemies.forEach(initPeople);
		
		super.create();
	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player")
		{
			_player.x = x;
			_player.y = y;
		}
		else if (entityName == "enemy")
		{
			var enemy:Enemy = new Enemy(x, y);
			_grpEnemies.add(enemy);
		}
	}
	
	private function initPeople(p:FlxSprite):Void
	{
		p.acceleration.y = 600;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (_player.x >= _txtShoot.x)
		{
			_txtShoot.visible = true;
			wasdTxt.visible = false;
		}
		
		if (_player.justShot)
		{
			var flash:MuzzleFlash = new MuzzleFlash(_player.xPos, _player.y + 26);
			add(flash);
			
			FlxG.camera.shake(0.01, 0.1);
		}
		
		playerBullets.forEachAlive(collisionCheck);
		
		FlxG.collide(_grpPeople, _mWalls);
		FlxG.collide(_grpEnemies, _mWalls);
		
		_grpEnemies.forEachAlive(followCheck);
		
		
	}
	
	private function enemyThink(e:Enemy, ?textOverride:String):Void
	{
		e.justThought = true;
		
		var thoughtText:String;
		
		if (e.color == FlxColor.WHITE)
		{
			thoughtText = "insert same opinion here";
		}
		else
		{
			thoughtText = "insert different opinion here";
		}
		
		var thought:Thoughts = new Thoughts(e.x + FlxG.random.float(-32, 32), e.y - 68, 150, thoughtText, 16);
		add(thought);
		
		if (textOverride != null)
		{
			thought.text = textOverride;
		}
		
		FlxTween.tween(thought, {y: thought.y - FlxG.random.float(8, 15)}, 1.25, {ease:FlxEase.quartOut});
		
	}
	
	private function followCheck(e:Enemy):Void
	{
		if (e.y > _player.y && e.velocity.y == 0 && e.color == FlxColor.WHITE)
		{
			e.velocity.y -= 300;
		}
		
		if (e.color == FlxColor.WHITE)
		{
			e.acceleration.x = 0;
			if (FlxMath.distanceBetween(e, _player) >= e.rndDistance)
			{
				var accel:Float = e.rndAccel;
				if (e.x > _player.x)
				{
					e.acceleration.x = -accel;
				}
				else
				{
					e.acceleration.x = accel;
				}
			}
		}
		
		if (FlxMath.distanceBetween(_player, e) < 94 && !e.justThought)
		{
			enemyThink(e);
		}
		
	}
	
	private function collisionCheck(b:Bullet):Void
	{
		for (e in _grpEnemies.members)
		{
			if (FlxG.overlap(b, e) && e.color != FlxColor.WHITE)
			{
				e.hit();
				e.x += b.velocity.x * FlxG.random.float(0.001, 0.01);
				muzzFlash(b);
			}
		}
		
		if (FlxG.collide(b, _mWalls))
		{
			muzzFlash(b);
		}
		
	}
	
	private function muzzFlash(b:Bullet):Void
	{
		var flash:MuzzleFlash = new MuzzleFlash(b.x, b.y);
		add(flash);
		
		b.kill();
	}
	
}