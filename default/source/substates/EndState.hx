package substates;


#if mobile
import extension.gpg.GooglePlayGames;
import extension.nativedialog.NativeDialog;
import extension.unityads.UnityAds;
#end

import extension.share.Share;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.text.FlxTypeText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import helpers.FlashingText;

/**
 * ...
 * @author Andrej
 */
class EndState extends FlxSubState
{
	private var content:DrjGroup;
	private var bg:FlxSprite;
	private var title:FlxText;
	
	private var btnWatch:FlxButton;
	private var btnShare:FlxButton;
	private var btnRestart:FlxButton;
	
	private var lblScore:FlxText;
	private var tScore:FlxText;
	private var msgHiscore:FlashingText;
	
	private var touchDelayTimer:FlxTimer;
	private var canTouch:Bool = false;
	
	private var askAgain:Bool = false;


	public function new(BGColor:FlxColor=FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		closeCallback = onClosed;
	}
	
	override public function create():Void 
	{
		super.create();
		trace("Creating EndState");
		
		#if (mobile || neko)
		touchDelayTimer = new FlxTimer();
		#end
		Share.init(Share.TWITTER);
		
		bg = new FlxSprite(0, 0);
		bg.makeGraphic(300, 400, 0xff004058);
		bg.screenCenter();
		
		title = new FlxText(0, bg.y + 8, 0, "Game Over", 24);
		title.screenCenter(FlxAxes.X);
		
		lblScore = new FlxText(0, title.y + 48, bg.width, "Final Score", 16);
		lblScore.alignment = FlxTextAlign.CENTER;
		lblScore.screenCenter(FlxAxes.X);
		
		tScore = new FlxText(lblScore.x, lblScore.y + lblScore.height + 8, bg.width, Std.string(Reg.score), 16);
		tScore.alignment = FlxTextAlign.CENTER;
		

		msgHiscore = new FlashingText(tScore.x, tScore.y + tScore.height + 16, bg.width, "NEW RECORD!", 24, true, 0xffffa300, 0.08);
		msgHiscore.alignment = FlxTextAlign.CENTER;
		
		//Share button
		btnShare = new FlxButton(0, msgHiscore.y+msgHiscore.height+16, "", shareScore);
		btnShare.loadGraphic(AssetPaths.btnShare__png);
		btnShare.screenCenter(FlxAxes.X);
		
		if (Reg.score <= Reg.hiscore){
			btnShare.y = msgHiscore.y;
		}
		
		//Restart button
		btnRestart = new FlxButton(0, 0, null, restartGame);
		btnRestart.loadGraphic(AssetPaths.btnrestart__png);
		btnRestart.screenCenter(FlxAxes.X);
		btnRestart.y = bg.y + bg.height - btnRestart.height - 24;
		
		content = new DrjGroup(0, 0);
		content.add(bg);
		content.add(title);
		content.add(lblScore);
		content.add(tScore);
		content.add(btnShare);
		content.add(btnRestart);
		if (Reg.score > Reg.hiscore){
			content.add(msgHiscore);
		}
		
		content.forEach(function(o){o.scrollFactor.set(0, 0); });
		
		add(content);
		
		
		
		
		//Touch hack for mobile
		#if (mobile || neko)
		touchDelayTimer.start(0.6, enableTouch);
		#end
		
		#if mobile
		//Rating message
		NativeDialog.onConfirmMessageOk = ratingAccepted;
		NativeDialog.onConfirmMessageCancel = ratingDeclined;
		
		if (!Reg.rated && Reg.score > Reg.hiscore && Reg.ratingCounter >= 3){
			Reg.ratingCounter = 0;
			NativeDialog.confirmMessage("Hey there!", "Congratulations on that high score! Would you like to rate the game?", "Sure!", "Nah.");
		}
		#end
		
		
		//Set hiscore
		Reg.hiscore = (Reg.score > Reg.hiscore) ? Reg.score : Reg.hiscore;
		
		//Save highscore
		saveHiscore();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
	private function saveHiscore():Void{
		//Google Play
		#if mobile
		GooglePlayGames.setScore(Reg.scoreboardID, Reg.score);
		#end
	}
	
	
	private function restartGame():Void{
		FlxG.switchState(new PlayState());
	}
	
	private function onClosed():Void{

	}
	
	
	private function enableTouch(t:FlxTimer):Void{
		canTouch = true;
	}
	
	private function shareScore():Void{
		Share.share("I got " + Reg.score + " points in GAME! Try to beat that :P", '', '', '', '', "https://play.google.com/store/apps/details?id=com.ohsat.hxoverdive");
	}
	
	//Rating stuff
	private function ratingAccepted():Void{
		#if mobile
		if (askAgain){
			Reg.logEvent("NeverAskForRating",{"TimesDeclined":Reg.ratingsDeclined});
		} else{
			Reg.logEvent("RatingAccepted");
			DRJ.openLink("market://details?id=com.ohsat.hxoverdive");
		}
		Reg.rated = true;
		#end
	}
	
	private function ratingDeclined():Void{
		#if mobile
		Reg.logEvent("RatingDeclined");
		Reg.ratingsDeclined++;
		if (!Reg.rated && Reg.ratingsDeclined >= 2){
			askAgain = true;
			NativeDialog.confirmMessage("Alright, so...", "Should I stop asking you for a rating?", "Yes, please.", "No, ask again later.");
		}
		#end
	}
}