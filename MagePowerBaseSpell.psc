ScriptName MagePowerBaseSpell extends ActiveMagicEffect
DynamicCombat_Config Property mpoConfig Auto
Spell Property MagePowerOverwhelming Auto
Spell Property MagePowerExhaustion Auto
Actor ActorRef
bool bPOAvailable
EquipSlot slotEither
EquipSlot slotLeft
EquipSlot slotRight
EquipSlot slotBoth
 

Event OnEffectStart(Actor akTarget, Actor akCaster)
    ActorRef = akTarget
	RegisterforKey(mpoConfig.iMagePowerKey)
	mpoConfig.MPChargeValue = 0.0
	bPOAvailable = True
	
	If ActorRef.HasSpell(MagePowerExhaustion)
		ActorRef.RemoveSpell(MagePowerExhaustion)
	endIf
	
	slotEither = Game.GetForm(0x00013F44) As EquipSlot
	slotLeft = Game.GetForm(0x00013F43) As EquipSlot
	slotRight = Game.GetForm(0x00013F42) As EquipSlot
	slotBoth = Game.GetForm(0x00013F45) As EquipSlot
endEvent

Event OnKeyDown(Int KeyCode)
    If KeyCode == mpoConfig.iMagePowerKey
		If !ActorRef.HasSpell(MagePowerOverwhelming)
			ActivatePowerOverwhelming()
		Else
			DeactivatePowerOverwhelming()
		endIf
		
    endIf
endEvent

Event OnSpellCast(Form akSpell)
    Spell spellCast = akSpell as Spell
    If spellCast && ActorRef.IsInCombat() && bPOAvailable
		If mpoConfig.MPChargeValue < 500.0
			mpoConfig.MPChargeValue += (spellCast.GetEffectiveMagickaCost(ActorRef) As float) * 0.25
		endIf
    endIf
endEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	Spell damageSource = akSource as Spell
	
	If damageSource != none && bPOAvailable
		If mpoConfig.MPChargeValue < 500.0
			mpoConfig.MPChargeValue += damageSource.GetMagickaCost() * 0.5
		endIf
	endIf		
endEvent

Function ActivatePowerOverwhelming()
	Spell rightSpell = ActorRef.GetEquippedSpell(1)
    Spell leftSpell = ActorRef.GetEquippedSpell(0)
    If (rightSpell != none && leftSpell != none) && bPOAvailable
		If !ActorRef.HasSpell(MagePowerOverwhelming) && mpoConfig.MPChargeValue > 50.0			
			ActorRef.AddSpell(MagePowerOverwhelming, false)						
			bPOAvailable = False
		endIf			
    endIf	
endFunction

Function DeactivatePowerOverwhelming()
	If ActorRef.HasSpell(MagePowerOverwhelming)
		ActorRef.RemoveSpell(MagePowerOverwhelming)
		Dispel()
	endIf
endFunction