package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ninjaMuffin
 */
class Enemy extends FlxSprite
{

	private var whiteNess:Float = 0;
	public var justThought:Bool = false;
	private var thoughtTimer:Float = 4;
	public var rndDistance:Int = FlxG.random.int(16, 90);
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(64, 64);
		color = FlxColor.BLACK;
		drag.x = 500;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
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
		
	}
	
	public function hit():Void
	{
		whiteNess += FlxG.random.float(0, 0.2);
	}

}