package;

#if mobile
import extension.gpg.GooglePlayGames;
import extension.unityads.UnityAds;
#end

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Andrej
 */
class LoadState extends FlxState
{
	private var oh:FlxSprite;
	private var forceSkip:Bool = false;
	private var _timer:FlxTimer;

	override public function create():Void 
	{
		super.create();
		
		//Google Play
		#if android
		GooglePlayGames.onLoginResult = Reg.onGPlayLogin;
		GooglePlayGames.onGetPlayerScore = Reg.playerScoreCallback;
		//GooglePlayGames.init(false);
		#end
		
		_timer = new FlxTimer();
		
		oh = new FlxSprite(0, 0, AssetPaths.ohlogo__png);
		oh.screenCenter(FlxAxes.X);
		add(oh);
		
		//Initialize Unity
		#if mobile
		UnityAds.onFetch = function(res:Bool):Void {
            trace("fetchResult = " + res);
			if (res){
				//fadeOut();
			} else{
				//_timer.start(4, fadeOut);
			}
        };
		
		UnityAds.onHide = function() {
            trace("onHide");
			Reg.hasSeenAd = true;
			Reg.sigWatchedAd.dispatch();
        };
		
		trace("Init Unity");
		UnityAds.init(Reg.unityID, false, false);
		#end
		
		
		FlxG.camera.fade(FlxColor.BLACK, 1, true, startTimer);
	}
	
	private function startTimer():Void{
		_timer.start(4, fadeOut);
	}
	
	private function fadeOut(?t:FlxTimer):Void{
		trace("fading out");
		FlxG.camera.fade(FlxColor.BLACK, 1, false, openMenu);
	}
	
	private function openMenu():Void{
		trace("switching states");
		FlxG.switchState(new PlayState());
	}
	
}