package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;

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

	public function new(?X:Float=0, ?Y:Float=0, playerBulletArray:FlxTypedGroup<Bullet>) 
	{
		super(X, Y);
		makeGraphic(64, 64);
		
		maxVelocity.x = 300;
		drag.x = 1400;
		
		bulletArray = playerBulletArray;
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		controls();
		
		super.update(elapsed);
		
	}
	
	private function controls():Void
	{
		var _left:Bool = FlxG.keys.anyPressed([A, LEFT]);
		var _right:Bool = FlxG.keys.anyPressed([D, RIGHT]);
		
		if (_left && _right)
		{
			_left = _right = false;
		}
		
		acceleration.x = 0;
		
		if (_left || _right)
		{
			var accel:Float = 3000;
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
			case FlxObject.LEFT:
				xPos = x - 22;
			default:
				throw("OOPSIE WOOPSIE!! Uwu We madea fucky wucky!! A wittle fucko boingo! The code monkeys at our headquarters are working VEWY HAWD to fix this!");
		}
		
		var newBullet = new Bullet(xPos, y + 32, 800, facing, 10);
		bulletArray.add(newBullet);
		
	}
	
}