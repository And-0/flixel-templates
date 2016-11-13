package;
import haxe.io.Bytes;
import haxe.macro.Context;




/**
 * ...
 * @author Andrej
 */
class Macros
{
	public static macro function getGJKey(){
		Context.addResource("k", Bytes.ofString("oshitwaddup"));
		return macro $v{true};
	}
}