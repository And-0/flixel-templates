package helpers;

import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author Andrej
 */
class FlashingText extends FlxText
{

	private var _timer:Float = 0;
	private var _interval:Float = 0.2;
	private var _color:FlxColor = FlxColor.RED;
	
	public function new(X:Float=0, Y:Float=0, FieldWidth:Float=0, ?Text:String, Size:Int=8, EmbeddedFont:Bool=true, FlashColor:FlxColor, Interval=0.04) 
	{
		super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
		_color = FlashColor;
		_interval = Interval;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		_timer += elapsed;
		if (_timer >= _interval){
			_switchColor();
			_timer = 0;
		}
	}
	
	private inline function _switchColor():Void{
		this.color = (this.color == _color) ? FlxColor.WHITE : _color;
	}
	
}