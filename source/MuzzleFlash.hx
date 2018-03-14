package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author ninjaMuffin
 */
class MuzzleFlash extends FlxSprite 
{

	private var lifeSpan:Int = 4;
	private var counter:Int = 0;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(32, 32);
		angle = 45;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		counter += 1;
		if (counter == 3)
		{
			color = FlxColor.BLACK;
			alpha = 0.6;
		}
		
		if (counter >= lifeSpan)
		{
			kill();
		}
		
	}
	
}