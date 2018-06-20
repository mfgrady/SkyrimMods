ScriptName StrikeBackEffect extends ActiveMagicEffect
Actor ActorRef
Bool isOnCooldown = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
    ActorRef = akTarget
endEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
        
	If abHitBlocked && !isOnCooldown
		
		Float damagemult = ActorRef.GetActorValue("attackDamageMult")
		
		ActorRef.ForceActorValue("attackDamageMult", damagemult * 2)
		Utility.Wait(2.5)
		
		ActorRef.ForceActorValue("attackDamageMult", damagemult)
		
		isOnCooldown = true
		RegisterForSingleUpdate(10.0)
	endIf
endEvent

Event OnUpdate()
	isOnCooldown = false
endEvent
	