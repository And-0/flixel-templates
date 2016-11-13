package substates;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Andrej
 */
class CountdownState extends FlxSubState
{
	private var counter:Float = 0;
	private var time:Int = 0;
	private var text:FlxText;
	private var _timer:FlxTimer;
	private var _toCall:Void->Void;

	public function new(Time:Int, TheCallback:Void->Void) 
	{
		super(FlxColor.TRANSPARENT);
		time = Time;
		_toCall = TheCallback;
		
		
	}
	
	override public function create():Void 
	{
		super.create();
		text = new FlxText(0, 0, 0, Std.string(time), 32);
		text.screenCenter();
		text.scrollFactor.set(0, 0);
		add(text);
		_timer = new FlxTimer().start(1, tickDown, time);
	}
	
	private function tickDown(t:FlxTimer):Void{
		time--;
		if (time == 0){
			_toCall();
			close();
		} else{
			text.text = Std.string(time);
		}
		
		
	}
	
}