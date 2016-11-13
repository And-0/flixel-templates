package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author Andrej
 */
class Collider extends FlxSprite
{
	public var canCollide:Bool = true;

	public function new(?X:Float=0, ?Y:Float=0, ?MakeGraphic=false) 
	{
		super(X, Y);
		if (MakeGraphic){
			makeGraphic(16, 16, FlxColor.LIME);
		}
	}
	
}