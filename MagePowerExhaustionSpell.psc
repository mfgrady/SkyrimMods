ScriptName MagePowerExhaustionSpell extends ActiveMagicEffect   
Spell Property MagePowerSpell Auto


Actor ActorRef
float fBaseMoveSpeed
float fBaseMagickaRate
float fBaseStaminaRate

Event OnUpdate()
	Dispel()
endEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	ActorRef = akTarget
    fBaseMoveSpeed = ActorRef.GetBaseActorValue("SpeedMult")
	fBaseMagickaRate = ActorRef.GetBaseActorValue("MagickaRate")
	fBaseStaminaRate = ActorRef.GetBaseActorValue("StaminaRate")
	ActorRef.SetActorValue("SpeedMult", fBaseMoveSpeed * 0.75)
	ActorRef.ModActorValue("CarryWeight", 0.1)
	ActorRef.ModActorValue("CarryWeight", -0.1)
	ActorRef.SetActorValue("MagickaRate", fBaseMagickaRate * 0.5)
	ActorRef.SetActorValue("StaminaRate",0.0)
	RegisterForSingleUpdate(GetDuration())
	
	If ActorRef.HasSpell(MagePowerSpell)
		ActorRef.RemoveSpell(MagePowerSpell)
	endIf
endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)

	ActorRef.SetActorValue("SpeedMult", fBaseMoveSpeed)
	ActorRef.ModActorValue("CarryWeight", 0.1)
	ActorRef.ModActorValue("CarryWeight", -0.1)
	ActorRef.SetActorValue("MagickaRate", fBaseMagickaRate)
	ActorRef.SetActorValue("StaminaRate", fBaseStaminaRate)
	
	Debug.Notification("Your body has begun to store Magicka again")
	
	ActorRef.AddSpell(MagePowerSpell, false)
	
endEvent