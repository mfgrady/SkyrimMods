Scriptname MagePowerLevitateSpell extends Activemagiceffect
 
FormList Property fMagePowerObject Auto
EffectShader Property esMagePower Auto

ObjectReference oLevitationObject1
ObjectReference oLevitationObject2
Actor ActorRef
bool updateSecond = false

float defaultGravity = 1.35 ; I need SKSE to detect what this is :<

bool zeroGravity = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
	ActorRef = akTarget

	oLevitationObject1 = ActorRef.PlaceAtMe(fMagePowerObject.GetAt(0))	
	oLevitationObject2 = ActorRef.PlaceAtMe(fMagePowerObject.GetAt(0))
	
	GotoState("loading")
	
	utility.SetIniFloat("fInAirFallingCharGravityMult:Havok",0.1)
	zeroGravity = true
	
	esMagePower.Play(ActorRef)
	RegisterForSingleUpdate(0.05)
endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)

	GotoState("")
	utility.SetIniFloat("fInAirFallingCharGravityMult:Havok",defaultGravity)
	zeroGravity = false
	oLevitationObject1.Delete()
	oLevitationObject2.Delete()
	esMagePower.Stop(ActorRef)
endEvent


State loading
	Event OnUpdate()
		if (oLevitationObject1.Is3DLoaded() && oLevitationObject2.Is3DLoaded())
			oLevitationObject1.SetMotionType(oLevitationObject1.Motion_Keyframed)
			oLevitationObject1.SetAngle(0,0,0)
			
			oLevitationObject2.SetMotionType(oLevitationObject1.Motion_Keyframed)
			oLevitationObject2.SetAngle(0,0,0)

			GotoState("mounted")
			RegisterForSingleUpdate(0.05)
		else
			RegisterForSingleUpdate(0.05)
		endif
	endEvent

endState

State mounted
	Event OnUpdate()
		float Direction = ActorRef.GetAngleZ()
		float elevation = ActorRef.GetAngleX()

		; Make sure that elevation isn't to high
		if elevation < -30
			elevation = -30
		elseif elevation > 40
			elevation = 40
		endif
		
		; Enable gravity if we look down.
		if elevation > 20
			if zeroGravity
				utility.SetIniFloat("fInAirFallingCharGravityMult:Havok",defaultGravity)
				zeroGravity = false
		;		debug.notification("Normal G")
			endif
		elseif !zeroGravity
			utility.SetIniFloat("fInAirFallingCharGravityMult:Havok",0.1)
			zeroGravity = true
		;	debug.notification("Zero G")
		endif
	
		if (updateSecond)
			if (ActorRef.GetDistance(oLevitationObject1) > 70)
				oLevitationObject1.SetAngle(Math.cos(direction)*elevation, -math.sin(direction)*elevation, Direction)
				oLevitationObject1.SetPosition (ActorRef.X, ActorRef.y, (ActorRef.z))
				updateSecond = !updateSecond
			endif
		else
			if (ActorRef.GetDistance(oLevitationObject1) > 70)
				oLevitationObject2.SetAngle(Math.cos(direction)*elevation, -math.sin(direction)*elevation, Direction)
				oLevitationObject2.SetPosition (ActorRef.X, ActorRef.y, (ActorRef.z))
				updateSecond = !updateSecond
			endif
		endif
		RegisterForSingleUpdate(0.00)
	EndEvent
endState