package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author ninjaMuffin
 */
class Player extends FlxSprite 
{
	private var bulletArray:FlxTypedGroup<Bullet>;
	public var justShot:Bool = false;
	private var rateOfFire:Int = 6;
	private var fireCoutner:Int = 0;
	public var xPos:Float = 0;
	
	private var knockBack:Float = 3;
	
	private var accel:Float = 3000;
	
	public var justThought:Bool = false;
	private var thoughtTimer:Float = 4;
	private var walkTmr:Float = 0.2;
	private var prevStep:Int = 1;

	public function new(?X:Float=0, ?Y:Float=0, playerBulletArray:FlxTypedGroup<Bullet>) 
	{
		super(X, Y);
		makeGraphic(64, 64);
		
		maxVelocity.x = 300;
		drag.x = 1400;
		
		bulletArray = playerBulletArray;
		color = FlxColor.WHITE;
	}
	
	override public function update(elapsed:Float):Void 
	{
		controls();
		
		super.update(elapsed);
		
		
		if (justThought)
		{
			thoughtTimer -= FlxG.elapsed;
			if (thoughtTimer <= 0)
			{
				justThought = false;
				thoughtTimer = 4;
			}
		}
	}
	
	private function controls():Void
	{
		var _left:Bool = FlxG.keys.anyPressed([A, LEFT]);
		var _right:Bool = FlxG.keys.anyPressed([D, RIGHT]);
		var _upP:Bool = FlxG.keys.anyJustPressed([W, UP]);
		
		var _shift:Bool = FlxG.keys.anyPressed([SHIFT, X]);
		
		var canJump:Bool = isTouching(FlxObject.FLOOR);
		
		if (_shift)
		{
			maxVelocity.x = 450;
		}
		else
		{
			maxVelocity.x = 300;
		}
		
		if (_left && _right)
		{
			_left = _right = false;
		}
		
		if (_upP && canJump)
		{
			FlxTween.tween(scale, {x: 0.8, y: 1.2}, 0.3, {ease:FlxEase.quadOut}).then(FlxTween.tween(scale, {x: 1, y: 1}, 0.5, {ease:FlxEase.quadInOut}));
			velocity.y -= 360;
		}
		
		acceleration.x = 0;
		
		if (_left || _right)
		{
			walkTmr -= FlxG.elapsed;
			
			if (walkTmr <= 0 && isTouching(FlxObject.FLOOR) && velocity.x != 0)
			{
				walkTmr = FlxG.random.float(0.3, 0.36);
				prevStep = FlxG.random.int(1, 4, [prevStep]);
				FlxG.sound.play("assets/sounds/walk" + Std.string(prevStep) + ".mp3");
			}
			
			if (_left)
			{
				acceleration.x = -accel;
				
				facing = FlxObject.LEFT;
			}
			if (_right)
			{
				acceleration.x = accel;
				
				facing = FlxObject.RIGHT;
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
				FlxG.sound.play("assets/sounds/bullet" + FlxG.random.int(1, 3) + ".mp3", FlxG.random.float(0.35, 0.55));
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
	
}