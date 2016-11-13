package;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.group.FlxGroup;

/**
 * ...
 * @author Andrej
 */
class DrjGroup extends FlxTypedGroup<FlxObject>
{
	public var x(default, set):Float = 0;
	function set_x(X){
		x = X;
		updateMembers();
		return x;
	}
	
	public var y(default,set):Float = 0;
	function set_y(Y){
		y = Y;
		updateMembers();
		return y;
	}
	
	private var updatePos:Bool = false;
	private var memberMap:Map<FlxObject,Array<Float>>;
	
	public function new(?X=0, ?Y=0) 
	{
		super();
		x = X;
		y = Y;
		memberMap = new Map<FlxObject,Array<Float>>();
	}
	
	
	override public function add(Object:FlxObject):FlxObject 
	{
		//updatePos = true;
		memberMap.set(Object, [Object.x,Object.y]);
		return super.add(Object);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (updatePos){
			//updatePosition();
		}
	}
	
	public function updatePosition():Void{
		trace("UPDATING GROUP POSITION");
		var i:Int = 0;
		var obj:FlxObject = null;
		var newx:Float = 4000;
		var newy:Float = 4000;
		
		while (i < length)
		{
			obj = members[i++];
			
			if (obj != null && obj.exists && obj.active)
			{
				newx = (obj.x < newx) ? obj.x : newx;
				newy = (obj.y < newy) ? obj.y : newy;
			}
		}
		trace("DrjGroup pos: " + newx + " : " + newy);
		x = newx;
		y = newy;
		updatePos = false;
		updateMembers();
	}
	
	public function setPosition(X:Float, Y:Float):Void{
		x = X;
		y = Y;
		updateMembers();
	}
	
	private function updateMembers():Void{
		var i:Int = 0;
		var obj:FlxObject = null;
		
		while (i < length)
		{
			obj = members[i++];
			
			if (obj != null && obj.exists && obj.active)
			{
				obj.x = x + memberMap[obj][0];
				obj.y = y + memberMap[obj][1];
			}
		}
	}
}