package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Andrej
 */
class Explosion extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		//loadGraphic(AssetPaths.explosion__png, true, 32, 32);
		animation.add("default", [0, 1, 2, 3], 16, false);
		animation.finishCallback = animDone;
	}
	
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		animation.play("default");
	}
	
	private function animDone(s:String){
		if (s == "default") kill();
	}
	
}