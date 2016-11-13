package;
import entities.Collider;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flash.Lib;
import flash.net.URLRequest;
import flixel.util.FlxDestroyUtil;
/**
 * ...
 * @author Andrej
 */
class DRJ
{

	public function new() 
	{
		
	}
	
	public static function clear(arr:Array<Dynamic>){
        #if (cpp||php)
           arr.splice(0,arr.length);
        #else
           untyped arr.length = 0;
        #end
    }
	
	public static function clearGroup(grp:FlxTypedGroup<Dynamic>){
		grp.forEach(function(obj:Dynamic){
			FlxDestroyUtil.destroy(obj);
		});
		grp.clear();
	}
	
	public static inline function approach(val:Float, max:Float, step:Float):Float{
		return (val < max ? Math.min(val + step, max) : Math.max(val - step, max));
	}
	
	public static inline function clamp(val:Float, min:Float, max:Float):Float{
		return Math.max(min, Math.min(val, max));
	}
	
	public static inline function sign(v:Float):Int{
		return v < 0 ? -1 : v == 0 ? 0 : 1;
	}
	
	public static inline function tryCol(a:Collider, b:Collider):Bool{
		return (a.canCollide && b.canCollide);
	}
	
	//Random stuff
	public static inline function getRandomEnum<T>(e:Enum<T>):Null<T>
	{
		return (e!=null) ? getRandomFromArray(Type.allEnums(e)) : null;
	}
	
	public static inline function getRandomFromArray<T>(arr:Array<T>):Null<T>
	{
		return (arr != null && arr.length > 0) ? arr[FlxG.random.int(0,arr.length-1)] : null;
	}
	
	//Round a number to the nearest factor of f
	public static inline function roundTo(n:Int,f:Int):Int{
		return (Math.round(n / f)) * f;
	}
	
	//Return a random number between start and end, rounded to the nearest factor of f
	public static inline function getRandomRoundedTo(start:Int,end:Int,f:Int):Int{
		return (roundTo( FlxG.random.int(start,end), f ));
	}
	
	public static inline function openLink(URL:String, Target:String = "_blank"):Void
	{
		var prefix:String = "";
		Lib.getURL(new URLRequest(prefix + URL), Target);
	}
	
}