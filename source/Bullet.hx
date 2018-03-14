package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class Bullet extends FlxSprite 
{

	private var speed:Float;
	private var dir:Int;
	private var damage:Float;
	
	public function new(?X:Float=0, ?Y:Float=0, Speed:Float, Direction:Int, Damage:Float) 
	{
		super(X, Y);
		
		makeGraphic(32, 20);
		
		speed = Speed;
		dir = Direction;
		damage = Damage;
		
		velocity.y = FlxG.random.float( -20, 20);
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
		
	}
	
}