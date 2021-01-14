package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ninjaMuffin
 */
class Bullet extends FlxSprite
{
	private var life:Float = 3;

	public var speed:Float;
	public var dir:Int;
	public var damage:Float;

	public function new(?X:Float = 0, ?Y:Float = 0, Speed:Float, Direction:Int, Damage:Float)
	{
		super(X, Y);

		makeGraphic(32, 20);

		speed = Speed;
		dir = Direction;
		damage = Damage;

		velocity.y = FlxG.random.float(-25, 25);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (dir == FlxObject.LEFT)
		{
			velocity.x = -speed;
		}
		if (dir == FlxObject.RIGHT)
		{
			velocity.x = speed;
		}

		life -= FlxG.elapsed;
		if (life < 0)
		{
			kill();
		}
	}
}
