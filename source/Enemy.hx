package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ninjaMuffin
 */
class Enemy extends FlxSprite
{
	private var bulletArray:FlxTypedGroup<Bullet>;
	public var justShot:Bool = false;
	private var rateOfFire:Int = 6;
	private var fireCoutner:Int = 0;
	public var xPos:Float = 0;
	
	private var knockBack:Float = 3;
	
	
	private var whiteNess:Float = 0;
	public var justThought:Bool = false;
	private var thoughtTimer:Float = 4;
	
	public var rndDistance:Int = FlxG.random.int(16, 90);
	public var rndAccel:Float = FlxG.random.float(400, 850);
	public var rndDrag:Float = FlxG.random.float(900, 1800);
	
	public var canJump:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0, enemyBulletArray:FlxTypedGroup<Bullet>)
	{
		super(X, Y);
		makeGraphic(64, 64);
		color = FlxColor.BLACK;
		drag.x = rndDrag;
		maxVelocity.x = FlxG.random.float(240, 300);
		
		bulletArray = enemyBulletArray;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		canJump = isTouching(FlxObject.FLOOR);
		
		if (velocity.x > 0)
		{
			facing = FlxObject.RIGHT;
		}
		if (velocity.x < 0)
		{
			facing = FlxObject.LEFT;
		}
		
		if (whiteNess > 1)
		{
			color = FlxColor.WHITE;
		}
		else if (whiteNess > 0.9)
		{
			color = 0xFFBBBBBB;
		}
		else if (whiteNess > 0.8)
		{
			color = 0xFF999999;
		}
		else if (whiteNess > 0.6)
		{
			color = 0xFF777777;
		}
		else if (whiteNess > 0.4)
		{
			color = 0xFF333333;
		}
		else if (whiteNess > 0.2)
		{
			color = 0xFF101010;
		}
		
		if (justThought)
		{
			thoughtTimer -= FlxG.elapsed;
			if (thoughtTimer <= 0)
			{
				justThought = false;
				thoughtTimer = 4;
			}
		}
		
		if (color == FlxColor.WHITE)
		{
			shooting();
		}
		
	}
	
	private function shooting():Void
	{
		
		justShot = false;
		if (FlxG.keys.pressed.SPACE)
		{
			fireCoutner += 1;
			if (fireCoutner >= rateOfFire)
			{
				fireCoutner = 0;
				attack();
				justShot = true;
			}
		}
	}
	
	private function attack():Void
	{
		switch (facing) 
		{
			case FlxObject.RIGHT:
				xPos = x + 54;
				x -= knockBack;
			case FlxObject.LEFT:
				xPos = x - 22;
				x += knockBack;
			default:
				throw("OOPSIE WOOPSIE!! Uwu We madea fucky wucky!! A wittle fucko boingo! The code monkeys at our headquarters are working VEWY HAWD to fix this!");
		}
		
		var newBullet = new Bullet(xPos, y + 32, 1600, facing, 10);
		bulletArray.add(newBullet);
		
	}
	
	
	public function hit():Void
	{
		whiteNess += FlxG.random.float(0, 0.2);
	}

}