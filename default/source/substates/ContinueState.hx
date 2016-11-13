package substates;



#if mobile
import extension.gpg.GooglePlayGames;
import extension.unityads.UnityAds;
#end

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Andrej
 */
class ContinueState extends FlxSubState
{
	private var content:DrjGroup;
	private var bg:FlxSprite;
	private var title:FlxText;
	
	private var btnWatch:FlxButton;
	private var btnBuy:FlxButton;
	private var btnRestart:FlxButton;
	private var btnEnd:FlxButton;
	
	private var lblGems:FlxSprite;
	private var costGems:FlxText;
	private var lblTotalGems:FlxSprite;
	private var valTotalGems:FlxText;
	
	public var sigContinue:FlxSignal;
	public var sigEnd:FlxSignal;
	public var sigRestart:FlxSignal;
	
	private var touchDelayTimer:FlxTimer;
	private var canTouch:Bool = false;

	public function new(BGColor:FlxColor=FlxColor.TRANSPARENT) 
	{
		super(0xDD000000);
		sigContinue = new FlxSignal();
		sigEnd = new FlxSignal();
		sigRestart = new FlxSignal();
		closeCallback = onClosed;
	}
	
	override public function create():Void 
	{
		super.create();
		trace("Creating substate");
		
		#if (mobile || neko)
		touchDelayTimer = new FlxTimer();
		#end
		
		//Create background
		bg = new FlxSprite(0, 0);
		bg.makeGraphic(300-32, 400, 0xff004058);
		bg.screenCenter();
		
		//Create menu
		title = new FlxText(0, bg.y + 8, 0, "Continue?", 24);
		title.screenCenter(FlxAxes.X);
		
		btnEnd = new FlxButton(bg.x + bg.width, bg.y, null, endGame);
		btnEnd.loadGraphic(AssetPaths.xbtn__png);
		btnEnd.x -= btnEnd.width -16;
		btnEnd.y -= btnEnd.height/3;
		
		btnWatch = new FlxButton(0, title.y + 48, null, watchAd);
		btnWatch.loadGraphic(AssetPaths.btnad__png);
		btnWatch.screenCenter(FlxAxes.X);
		
		costGems = new FlxText(0, btnWatch.y, 100, Std.string(Reg.continueCost), 16);
		costGems.x = (btnWatch.x + btnWatch.width / 2) - costGems.width / 2;
		costGems.y = (btnWatch.y + btnWatch.height / 2) - costGems.height / 2;
		costGems.alignment = FlxTextAlign.RIGHT;
		
		lblGems = new FlxSprite(costGems.x, costGems.y);
		lblGems.loadGraphic(AssetPaths.gem__png);
		
		//Current total gems
		valTotalGems = new FlxText(0, btnBuy.y + btnBuy.height + 24, 64, Std.string(Reg.totalGems), 16);
		valTotalGems.screenCenter(FlxAxes.X);
		valTotalGems.alignment = FlxTextAlign.RIGHT;
		lblTotalGems = new FlxSprite(valTotalGems.x,valTotalGems.y);
		lblTotalGems.loadGraphic(AssetPaths.gem__png);
		
		//Restart button
		btnRestart = new FlxButton(0, 0, null, restartGame);
		btnRestart.loadGraphic(AssetPaths.btnrestart__png);
		btnRestart.screenCenter(FlxAxes.X);
		btnRestart.y = bg.y + bg.height - btnRestart.height - 24;
		
		//Add to stage
		content = new DrjGroup(0, 0);
		content.add(bg);
		content.add(title);
		content.add(btnEnd);
		content.add(btnWatch);
		content.add(lblGems);
		content.add(costGems);
		content.add(lblTotalGems);
		content.add(valTotalGems);
		content.add(btnRestart);
		
		content.forEach(function(o){o.scrollFactor.set(0, 0); });
		
		add(content);
		
		//Google Play
		#if mobile
		GooglePlayGames.setScore(Reg.scoreboardID, Reg.score);	
		Reg.sigWatchedAd.add(continueGame);
		
		
		if (Reg.hasSeenAd || !UnityAds.canShowAds()){
			btnWatch.alpha = 0.2;
			btnWatch.color = FlxColor.GRAY;
		}
		#end
		
		//Touch hack for Android
		#if (mobile || neko)
		touchDelayTimer.start(0.6, enableTouch);
		#end
	}
	
	override public function update(elapsed:Float):Void 
	{
		FlxG.watch.addQuick("Gems: ", Reg.totalGems);
		#if !FLX_NO_KEYBOARD
		if (FlxG.keys.justPressed.R){
			sigContinue.dispatch();
			close();
		}
		#end
		super.update(elapsed);
	}
	
	private function watchAd():Void{
		#if mobile
		if (!canTouch || Reg.hasSeenAd || !UnityAds.canShowAds()) return;
		trace("Watching ad");
		Reg.logEvent("WatchingAd");
		
		//EnhanceOpenFLExtension.showRewardedAd(EnhanceOpenFLExtension.REWARDED_PLACEMENT_NEUTRAL, getReward, noReward, failReward);
		var resShowAd:Bool = UnityAds.showAd("rewardedVideo");
				if (resShowAd) {
					trace("showing ad OK");
				}else {
					trace("notshowing ad");
				}
		#else
		sigContinue.dispatch();
		close();
		#end
	}
	
	private function getReward(Str:String, Num:Int):Void{
		trace("Reward get: " + Str + "::" + Std.string(Num));
		sigContinue.dispatch();
		close();
	}
	
	private function noReward():Void{
		trace("No Reward");
	}
	
	private function failReward():Void{
		trace("Reward failed");
	}
	
	private function restartGame():Void{
		sigRestart.dispatch();
		close();
	}
	
	private function endGame():Void{
		sigEnd.dispatch();
		close();
	}
	
	private function buyContinue():Void{
		if (!canTouch) return;
		if (Reg.totalGems >= Reg.continueCost){
			Reg.logEvent("BoughtContinue", {"Gems":Reg.totalGems});
			Reg.totalGems -= Reg.continueCost;
			Reg.continueCost *= 2;
			Reg.saveGame(Reg.saveSlot);
			sigContinue.dispatch();
			close();
		}
		
		
	}
	
	private function onClosed():Void{
		sigContinue.removeAll();
		sigEnd.removeAll();
	}
	
	private function continueGame():Void{
		trace("Current state: " + FlxG.state);
		sigContinue.dispatch();
		close();
	}
	
	private function enableTouch(t:FlxTimer):Void{
		canTouch = true;
	}
	
}