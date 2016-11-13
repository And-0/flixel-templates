package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Andrej
 */
class DrjSprite extends Collider
{
	private var ghostTimer:Float = 0;
	private var ghost:Bool = false;
	
	public var invincible:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (ghost){
			if (ghostTimer > 0){
				ghostTimer -= elapsed;
			} else{
				setGhost(false);
			}
		}
		
		super.update(elapsed);
	}
	
	public function setGhost(Val:Bool):Void{
		ghost = Val;
		canCollide = !ghost;
	}
	
	public function setInvincible(Val:Bool):Void{
		invincible = Val;
	}
	
	public function hit(?Damage = 1, ?Inv = true):Void{
		if (invincible || ghost) return;
		this.hurt(Damage);
		setGhost(Inv);
	}
	
	
	
}