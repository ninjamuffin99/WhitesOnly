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
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(64, 64, FlxColor.BLACK);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		color = Std.int(0xFFFFFFFF * whiteNess);
	}
	
	public function hit():Void
	{
		whiteNess += FlxG.random.float(0, 0.2);
	}

}