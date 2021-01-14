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
	private var _grpText:FlxTypedGroup<FlxText>;
	
	private var wasdTxt:FlxText;
	private var _txtShoot:FlxText;
	
	override public function create():Void
	{
		FlxG.mouse.visible = false;
		FlxG.camera.bgColor = FlxColor.GRAY;
		FlxG.camera.fade(FlxColor.BLACK, 5, true);
		FlxG.sound.playMusic("assets/music/ambience.ogg", 0.5);
		
		_map = new FlxOgmoLoader(AssetPaths.level1__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 32, 32, "Floors");
		_mWalls.setTileProperties(1, FlxObject.ANY);
		add(_mWalls);
		
		_grpPeople = new FlxTypedGroup<FlxSprite>();
		add(_grpPeople);
		
		_grpEnemies = new FlxTypedGroup<Enemy>();
		add(_grpEnemies);
		
		_grpText = new FlxTypedGroup<FlxText>();
		add(_grpText);
		
		playerBullets = new FlxTypedGroup<Bullet>();
		add(playerBullets);
		
		_enemyThoughts = new FlxTypedGroup<Thoughts>();
		add(_enemyThoughts);
		
		_player = new Player(20, 300, playerBullets);
		_grpPeople.add(_player);
		
		_map.loadEntities(placeEntities, "entities");
		
		FlxG.worldBounds.setSize(10000, 10000);
		
		wasdTxt = new FlxText(_player.x - 64, _player.y - 100, 0, "A & D == Move", 16);
		wasdTxt.color = FlxColor.BLACK;
		add(wasdTxt);
		
		_txtShoot = new FlxText(170, 720, 0, "Spacebar to shoot", 16);
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
		FlxG.camera.snapToTarget();
		FlxG.camera.deadzone = FlxRect.get(0, cinemaBar.height, FlxG.width, cinemaBar2.y);
		
		_grpPeople.forEach(initPeople);
		_grpEnemies.forEach(initPeople);
		
		var vig:FlxSprite = new FlxSprite().loadGraphic("assets/images/vignetteresized.png", false, 640, 480);
		vig.scrollFactor.x = vig.scrollFactor.y = 0;
		vig.setGraphicSize(FlxG.width, FlxG.height);
		vig.updateHitbox();
		vig.alpha = 0.4;
		add(vig);
		
		_grpText.forEach(changeColorintro);
		
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
			var enemy:Enemy = new Enemy(x, y, playerBullets);
			_grpEnemies.add(enemy);
		}
		else if (entityName == "text")
		{
			var textSpr:FlxText = new FlxText(x, y, 0, Std.string(entityData.get("displayText")), 32);
			textSpr.color = FlxColor.WHITE;
			_grpText.add(textSpr);
		}
	}
	
	private function initPeople(p:FlxSprite):Void
	{
		p.acceleration.y = 600;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		/*
		if (_player.x >= _txtShoot.x)
		{
			_txtShoot.visible = true;
			wasdTxt.visible = false;
		}
		*/
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
		
		if (_player.y >= 1800 && !finalLevel)
		{
			finalLevel = true;
			FlxG.camera.fade(FlxColor.WHITE, 0.05, false, finalFade);
			FlxG.sound.play("assets/sounds/colorSwap.ogg", 0.8);
			FlxG.sound.music.stop();
			_player.color = FlxG.random.getObject(Enemy.colorArray);
		}
	}
	
	private var finalLevel:Bool = false;
	
	private function enemyThink(e:Enemy, ?textOverride:String):Void
	{
		e.justThought = true;
		
		FlxG.sound.play("assets/sounds/pop" + FlxG.random.int(1, 3) + ".ogg", FlxG.random.float(0.5, 0.7));
		
		var thoughtText:String;
		
		if (e.finalSection)
		{
			thoughtText = thoughtArray[FlxG.random.int(0, thoughtArray.length)];
		}
		else
		{
			if (e.color == FlxColor.BLACK)
			{
				thoughtText = "insert same opinion here";
			}
			else
			{
				thoughtText = "insert different opinion here";
			}
		}
		
		var thought:Thoughts = new Thoughts(e.x + FlxG.random.float(-100, 100), e.y - FlxG.random.float(10, 100), 150, thoughtText, 16);
		add(thought);
		
		if (e.finalSection)
		{
			thought.color = FlxColor.WHITE;
		}
		else
		{
			thought.color = FlxColor.BLACK;
		}
		
		if (textOverride != null)
		{
			thought.text = textOverride;
		}
		
		FlxTween.tween(thought, {y: thought.y - FlxG.random.float(8, 15)}, 1.25, {ease:FlxEase.quartOut});
		
	}
	
	private function followCheck(e:Enemy):Void
	{
		e.acceleration.x = 0;
		if (!e.finalSection)
		{
			if (e.y > _player.y && e.velocity.y == 0 && e.color == FlxColor.BLACK)
			{
				e.velocity.y -= 360;
			}
			
			if (e.color == FlxColor.BLACK)
			{
				
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
			if (FlxG.overlap(b, e) && e.color != FlxColor.BLACK)
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
	
	private function finalFade():Void
	{
		FlxG.camera.fade(FlxColor.WHITE, 3, true);
		FlxG.camera.bgColor = FlxColor.BLACK;
		FlxG.sound.playMusic("assets/music/SomewhatOKIDKLMAO_V2.ogg", 0.7);
		FlxG.sound.music.fadeIn(15, 0, 0.7);
		
		
		_grpText.forEach(changeColor);
	}
	
	private function changeColor(t:FlxText):Void
	{
		t.color = FlxColor.WHITE;
	}
	
	
	private function changeColorintro(t:FlxText):Void
	{
		t.color = FlxColor.BLACK;
	}
	
	
	private var thoughtArray:Array<String> = 
	[
		"I like anime a lot",
		"You know some pop music isn't that bad",
		"Crunchy peanut butter is alright",
		"Dogs are pretty alright",
		"Children are cool as hell",
		"Cats are cool",
		"Water is really better than soda",
		"La La Land was a good movie",
		"Carly Rae Jepsen music is my favourite",
		"I'm a bit obnoxious online because I'm kinda shy in person",
		"I envy others success",
		"I often feel under appreciated",
		"I don't like watching sports",
		"I love Newgrounds a LOT",
		"I feel guilty for not appreciating my heritage",
		"Videogames are the best",
		"I haven't watched anime for a while",
		"I miss my old home sometimes, even though it sucked",
		"The internet isn't as bad as many claim it is",
		"insert something political here",
		"My family is super cool",
		"Shoutouts to Simpleflips",
		"What kind of music do you like?",
		"Wait, this game wasn't about racism?",
		"I spend too much time on Twitter",
		"Hip hop, man that stuff's my jam!",
		"Hifumi from New Game is best waifu",
		"I don't really like berries",
		"High school was kinda alright",
		"Teens are alright",
		"Dogs are meh",
		"Buzzfeed is alright nowadays"
	];
	
}