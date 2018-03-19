package;

import flixel.FlxG;
import flixel.text.FlxText;

/**
 * ...
 * @author ninjaMuffin
 */
class Thoughts extends FlxText 
{
	private var lifeTimer:Float = 2.25;
	
	public function new(X:Float=0, Y:Float=0, FieldWidth:Float=0, ?Text:String, Size:Int=8, EmbeddedFont:Bool=true) 
	{
		super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		lifeTimer -= FlxG.elapsed;
		
		if (lifeTimer <= 0)
		{
			kill();
		}
		
	}
	
	public static var likes:Array<String> = 
	[
		
	];
	
}