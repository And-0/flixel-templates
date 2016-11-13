package;



#if mobile
import extension.gpg.GooglePlayGames;
import ru.zzzzzzerg.linden.Flurry;
#end

import entities.Collider;
import entities.Explosion;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.system.FlxAssets;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import substates.ContinueState;
import substates.CountdownState;
import substates.EndState;
import substates.TitleSubState;


class PlayState extends FlxState
{
	public var poolEnemies:FlxTypedGroup<Collider>;
	public var poolExplosions:FlxTypedGroup<Explosion>;
	
	public var grpColliders:FlxTypedGroup<Collider>;
	public var grpHUD:FlxTypedGroup<FlxSprite>;
	
	public var lblScore:FlxText;
	public var lblHiscore:FlxText;
	public var tHiscore:FlxText;
	public var tScore:FlxText;
	public var score:Int = 0;
	public var prevScore:Int = 0;
	
	private var titleState:TitleSubState;
	
	
	override public function create():Void
	{
		super.create();
		//Basic Initialization
		#if !mobile
		FlxG.debugger.toggleKeys = [D];
		FlxG.mouse.visible = true;
		destroySubStates = true;
		#end
		
		Reg.init();
		Reg.loadGame(Reg.saveSlot);
		
		//Flurry
		#if mobile
		Flurry.onStartSession(Reg.flurryID);
		#end
		
		//Title screen
		titleState = new TitleSubState();
		titleState.sigTitleClosed.add(titleClosed);
		
		//Pools
		initPools();
		
		
		//Colliders
		grpColliders = new FlxTypedGroup<Collider>();
		poolEnemies.forEach(function(s:Collider){ if(s != null) grpColliders.add(s); });

		//Add to stage
		add(poolEnemies);
		add(poolExplosions);
		
		
		//Add HUD
		grpHUD = new FlxTypedGroup<FlxSprite>();
		lblScore = new FlxText(8, 0, 0, "SCORE");
		tScore = new FlxText(8, 8, 0, Std.string(Reg.score), 16);
		tScore.color = lblScore.color = FlxColor.WHITE;
		tScore.scrollFactor.set(0, 0);
		lblScore.scrollFactor.set(0, 0);
		tScore.visible = lblScore.visible = false;
		
		lblHiscore = new FlxText(0, 0, FlxG.width, "HISCORE");
		tHiscore = new FlxText(0, 8, FlxG.width, "0000", 16);
		lblHiscore.color = tHiscore.color = FlxColor.WHITE;
		lblHiscore.scrollFactor.set(0, 0);
		tHiscore.scrollFactor.set(0, 0);
		lblHiscore.alignment = tHiscore.alignment = FlxTextAlign.CENTER;
		lblHiscore.visible = tHiscore.visible = false;
		
		grpHUD.add(lblScore);
		grpHUD.add(tScore);
		grpHUD.add(lblHiscore);
		grpHUD.add(tHiscore);
		
		
		
		if (!Reg.skipTitle){
			openSubState(titleState);
		} else{
			Reg.skipTitle = false;
			startGame();
		}
	}
	
	
	private function titleClosed():Void{
		startGame();
	}
	
	public function startGame():Void{
		Reg.timesStarted++;
		Reg.ratingCounter++;
		
		tHiscore.text = Std.string(Reg.hiscore);
	}

	
	
	override public function update(elapsed:Float):Void
	{
		playerMovement();
		
		//HUD
		if (prevScore != score){
			updateHUD();
		}
		prevScore = score;
		
		super.update(elapsed);
	}
	
	
	
	private inline function playerMovement():Void{
		
	}
	
	public function updateHUD():Void{
		tScore.text = Std.string(Reg.score);
	}
	
	public function onPlayerKilled():Void{
		var sub = new ContinueState();
		sub.sigContinue.add(continueGame);
		sub.sigEnd.add(endGame);
		sub.sigRestart.add(restartGame);
		openSubState(sub);
	}
	
	
	private function endGame():Void{
		openSubState(new EndState());
	}
	
	private function restartGame():Void{
		Reg.skipTitle = true;
		FlxG.resetState();
	}
	
	//Called when the game is continued
	private function continueGame():Void{
		openSubState(new CountdownState(3, continuePlaying));
	}
	
	//Called upon restart, after countdown is over
	private function continuePlaying():Void{
		
	}
	
	private function initPools():Void{
		if(poolEnemies == null) poolEnemies = new FlxTypedGroup<Collider>();
		for (i in 0...5){
			var e = null;
			e = new Collider(0, 0);
			e.kill();
			poolEnemies.add(e);
		}
		
		if(poolExplosions == null) poolExplosions = new FlxTypedGroup<Explosion>();
		for (i in 0...5){
			var e = null;
			e = new Explosion(0, 0);
			e.kill();
			poolExplosions.add(e);
		}
	}
	
	private function explode(o:FlxObject):Void{
		//Reg.playSound(sndExplosion, true);
		var ex = poolExplosions.recycle(Explosion);
		ex.reset(o.x, o.y);
	}
}
