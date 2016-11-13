package;

#if mobile
import extension.gpg.GooglePlayGames;
import ru.zzzzzzerg.linden.Flurry;
#end

import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.FlxAccelerometer;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.util.FlxSave;
import flixel.util.FlxSignal;
import haxe.crypto.Base64;
import haxe.io.Bytes;



/**
 * ...
 * @author Andrej
 */
class Reg
{	
	//Constants
	static public var saveSlot:String = "slot1";
	static public var continueCost:Int = 1;
	
	//Values
	static public var score:Int = 0;
	static public var hiscore:Int = 0;
	static public var totalGems:Int = 0;
	
	//Default things
	static public var soundOn:Bool = true;
	static public var musicOn:Bool = true;

	static public var save:FlxSave = null;
	static public var saveInitialized:Bool = false;
	
	static public var skipTitle:Bool = false;
	

	//Google Play
	static public var loggedIn:Bool = false;
	static public var scoreboardID:String = "X";
	static public var sigLoggedIn:FlxSignal;
	
	//Unity Ads
	static public var unityID:String;
	static public var sigWatchedAd:FlxSignal;
	static public var hasSeenAd:Bool = false;
	
	//Flurry
	static public var flurryID:String;
	
	//Stats
	static public var timesStarted:Int = 0;
	static public var ratingCounter:Int = 0;
	static public var ratingsDeclined:Int = 0;
	static public var rated:Bool = false;
	
	public static function init():Void{
		if (sigLoggedIn == null){
			sigLoggedIn = new FlxSignal();
		}
		if (sigWatchedAd == null){
			sigWatchedAd = new FlxSignal();
		}
	}
	
	public static function initSave(slot:String):Void{
		if (!Reg.saveInitialized || Reg.save == null){
			trace("Save initialized");
			Reg.save = new FlxSave();
			Reg.save.bind(slot);
			Reg.saveInitialized = true;
		}
	}
	
	public static function saveGame(slot:String):Void{
		if (!Reg.saveInitialized) initSave(slot);
		trace("Saving game");
		Reg.save.data.hs = Base64.encode(Bytes.ofString(Std.string(Reg.hiscore)));
		Reg.save.flush();
	}
	
	public static function loadGame(slot:String):Void{
		if (!Reg.saveInitialized) initSave(slot);
		trace("Game loaded");
		//If no save available, save with default values
		if (Reg.save.data.hs == null){
			Reg.saveGame(slot);
		}
		
		//Set hiscore
		var s:String = Reg.save.data.hs;
		Reg.hiscore = (s != null) ? Std.parseInt(Base64.decode(s).toString()) : 0;

	}
	
	public static function playSound(snd:FlxSound,?Force:Bool=true){
		if (Reg.soundOn) snd.play(Force);
	}
	
	public static function toggleSound():Void{
		Reg.soundOn = !Reg.soundOn;
	}
	
	public static function toggleMusic():Void{
		Reg.musicOn = !Reg.musicOn;
	}
	
	public static function logEvent(eventID:String, ?params:Dynamic=null):Void{
		#if mobile
		Flurry.logEvent(eventID, params);
		#end
	}
	
	//GPlay stuff
	public static function onGPlayLogin(res:Int):Void{
		#if mobile
		trace("GPlay Login");
		if (res == 1){
			Reg.loggedIn = true;
			sigLoggedIn.dispatch();
			GooglePlayGames.getPlayerScore(Reg.scoreboardID);
		}
		#end
	}
	
	public static function playerScoreCallback(idScoreboard:String, score:Int):Void{
		#if mobile
		trace("Fetched hiscore"+Std.string(score)+" from board " + idScoreboard);
		//Reg.hiscore = score;
		if (score > Reg.hiscore){
			trace("Setting hiscore");
			Reg.hiscore = score;
		} else{
			//Syncing
			trace("Syncing score: "+Reg.hiscore);
			GooglePlayGames.setScore(Reg.scoreboardID, Reg.hiscore);
		}
		#end
	}
	
	
}