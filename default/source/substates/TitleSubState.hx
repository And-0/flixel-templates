package substates;


#if mobile
import extension.gpg.GooglePlayGames;
import extension.nativedialog.NativeDialog;
#end

import flash.text.TextFormat;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.input.mouse.FlxMouseEventManager;
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
class TitleSubState extends FlxSubState
{
	private var title:FlxText;
	
	private var msg:FlxText;
	public var sigTitleClosed:FlxSignal;
	private var btnSound:FlxSprite;
	private var btnMusic:FlxSprite;
	private var gplay:FlxSprite;
	private var gpAchievements:FlxButton;
	private var loggingIn:Bool = false;
	private var ginit:Bool = false;//Has google play been initialized?
	
	#if (mobile || neko)
	private var touchDelayTimer:FlxTimer;
	private var canTouch:Bool = false;
	#end
	
	public function new(BGColor:FlxColor=FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		closeCallback = closedState;
		sigTitleClosed = new FlxSignal();
	}
	
	override public function create():Void 
	{
		super.create();
		
		#if (mobile || neko)
		touchDelayTimer = new FlxTimer();
		#end
		
		//Google Play
		#if (mobile || neko)
		Reg.sigLoggedIn.add(updateGPlayButton);
		#end
		
		title = new FlxText(0, 0, 0, "GAME", 48);
		title.alignment = FlxTextAlign.CENTER;
		title.screenCenter(FlxAxes.X);
		
		msg = new FlxText(0, title.y + title.height + 36, FlxG.width, "Tap to start!", 16);
		msg.alignment = FlxTextAlign.CENTER;
		
		//Audio buttons
		btnSound = new FlxSprite(24, FlxG.height-24);
		btnSound.loadGraphic(AssetPaths.btnsnd__png, true, 48, 48);
		btnSound.y -= btnSound.height;
		
		btnMusic = new FlxSprite(btnSound.x + btnSound.width + 16, btnSound.y);
		btnMusic.loadGraphic(AssetPaths.btnmus__png, true, 48, 48);
		
		#if (mobile || neko)
		gplay = new FlxSprite(FlxG.width - 88, btnSound.y);
		gplay.loadGraphic(AssetPaths.gplay__png, true, 64, 64);
		
		gpAchievements = new FlxButton(gplay.x - 64 - 8, gplay.y, null, showAchievements);
		gpAchievements.loadGraphic(AssetPaths.gplayachievements__png);
		gpAchievements.visible = false;
		#end
		
		#if mobile
		FlxMouseEventManager.add(btnSound, null, null, toggleSound);
		FlxMouseEventManager.add(btnMusic, null, null, toggleMusic);
		FlxMouseEventManager.add(gplay, null, null, gplayLogin);
		#else
		FlxMouseEventManager.add(btnSound, null, toggleSound);
		FlxMouseEventManager.add(btnMusic, null, toggleMusic);
		#end
		
		add(title);
		add(msg);
		add(btnSound);
		add(btnMusic);
		#if (mobile || neko)
		add(gplay);
		add(gpAchievements);
		#end
		
		updateButtons();
		
		//Touch hack
		#if (mobile || neko)
		touchDelayTimer.start(0.6, enableTouch);
		#end
		
	}
	
	private function closedState():Void{
		gplay.kill();
		btnMusic.kill();
		btnSound.kill();
		sigTitleClosed.dispatch();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justReleased && touch.y < btnSound.y - 24) {close(); };
		}
		#else
		if (FlxG.mouse.justReleased && FlxG.mouse.y < btnSound.y-24){
			close();
		}
		#end
	}
	
	private function updateButtons():Void{
		btnSound.animation.frameIndex = (Reg.soundOn) ? 0 : 1;
		btnMusic.animation.frameIndex = (Reg.musicOn) ? 0 : 1;
		updateGPlayButton();
	}
	
	private function toggleSound(s:FlxSprite):Void{
		if (!canTouch) return;
		Reg.toggleSound();
		btnSound.animation.frameIndex = (Reg.soundOn) ? 0 : 1;
	}
	
	private function toggleMusic(s:FlxSprite):Void{
		if (!canTouch) return;
		Reg.toggleMusic();
		btnMusic.animation.frameIndex = (Reg.musicOn) ? 0 : 1;
		if (Reg.musicOn){
			//FlxG.sound.playMusic(AssetPaths.waves__ogg,0.2);
		} else{
			//FlxG.sound.music.stop();
		}
	}
	
	#if mobile
	//Triggered on button press
	private function gplayLogin(s:FlxSprite):Void{
		if (!canTouch) return;
		trace("LoginPressed");
		
		if (gplay.animation.frameIndex == 0 && !Reg.loggedIn){//Log in
			loggingIn = true;
			if (!ginit){
				GooglePlayGames.init(false);
			} else{
				GooglePlayGames.login();
			}
		} else{//Show score
			trace("Trying to show leaderboard");
			GooglePlayGames.displayScoreboard(Reg.scoreboardID);
		}
		
	}
	#end
	
	private function enableTouch(t:FlxTimer):Void{
		canTouch = true;
	}
	
	private function updateGPlayButton():Void{
		#if mobile
		trace("Updating gplay button: " + Reg.loggedIn);
		if (Reg.loggedIn){
			gplay.animation.frameIndex = 1;
			gpAchievements.visible = true;
		} else{
			gplay.animation.frameIndex = 0;
			gpAchievements.visible = false;
		}
		#end
	}
	
	private function showAchievements():Void{
		#if mobile
		GooglePlayGames.displayAchievements();
		#end
	}
}