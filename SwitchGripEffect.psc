ScriptName SwitchGripEffect extends ActiveMagicEffect


DynamicCombat_Config Property DComConfig Auto   
SwitchGripQuest Property myMod Auto
Spell Property StrikeBack Auto
Spell Property Momentum Auto 
Perk Property OneHandedDefense Auto
Perk Property OneHandedOffense Auto
Perk Property TwoHandedDefense Auto
Perk Property TwoHandedOffense Auto

Actor ActorRef
EquipSlot slotEither
EquipSlot slotLeft
EquipSlot slotRight
EquipSlot slotBoth


int iStanceNormal = 0
int iStanceSwapped = 0
int Normal = -1
int Defensive = 0
int Offensive = 1

bool isDefensive = true

int ONEHAND = 0
int ONEHAND_DEF = 2
int ONEHAND_OFF = 4
int TWOHAND = 1
int TWOHAND_DEF = 3
int TWOHAND_OFF = 5




Event OnPlayerLoadGame()
    int current_crc = FNIS_aa.GetInstallationCRC()
    if ( current_crc == 0 )
        ; Installation Error: no AA generated by FNIS
    ElseIf ( current_crc != myMod.myModCRC )
        myMod.my_1hmidle_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._1hmidle(), "SwitchGrip", true)
        myMod.my_1hmmt_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._1hmmt(), "SwitchGrip", true)
        myMod.my_1hmatk_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._1hmatk(), "SwitchGrip", true)
        myMod.my_1hmatkpow_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._1hmatkpow(), "SwitchGrip", true)
        myMod.my_1hmblock_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._1hmblock(), "SwitchGrip", true)
        myMod.my_sprint_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._sprint(), "SwitchGrip", true)
        myMod.my_2hmidle_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._2hmidle(), "SwitchGrip", true)
        myMod.my_2hmmt_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._2hmmt(), "SwitchGrip", true)
        myMod.my_2hmatk_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._2hmatk(), "SwitchGrip", true)
        myMod.my_2hmatkpow_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._2hmatkpow(), "SwitchGrip", true)
        myMod.my_2hmblock_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._2hmblock(), "SwitchGrip", true)
		myMod.my_2hwidle_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._2hwidle(), "SwitchGrip", true)
		myMod.my_2hwatk_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._2hwatk(), "SwitchGrip", true)
        myMod.my_2hwatkpow_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._2hwatkpow(), "SwitchGrip", true)
        myMod.my_2hwblock_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._2hwblock(), "SwitchGrip", true)
		myMod.my_magidle_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._magidle(), "SwitchGrip", true)
		myMod.my_h2hidle_base = FNIS_aa.GetGroupBaseValue(myMod.myModID, FNIS_aa._h2hidle(), "SwitchGrip", true)
        myMod.myModCRC = current_crc        
    endif
endEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
    ActorRef = akTarget
	
	slotEither = Game.GetForm(0x00013F44) As EquipSlot
	slotLeft = Game.GetForm(0x00013F43) As EquipSlot
	slotRight = Game.GetForm(0x00013F42) As EquipSlot
	slotBoth = Game.GetForm(0x00013F45) As EquipSlot
	
	FNIS_aa.SetAnimGroup(ActorRef, "_h2hidle", myMod.my_h2hidle_base, iStanceSwapped, "SwitchGrip", true)
endEvent

Event OnKeyDown(Int KeyCode)
    If KeyCode == DComConfig.iStanceKey
		isDefensive = !isDefensive
        ChooseStance()
    endIf
endEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	
	Weapon newWeapon = akBaseItem As Weapon
	If newWeapon != None && newWeapon.GetEquipType() == slotBoth && newWeapon.GetWeaponType() < 7
		newWeapon.SetEquipType(slotRight)
		return
	endIf
endEvent

Event OnObjectEquipped(Form akBaseForm, ObjectReference akReference)
	Weapon eWeapon = akBaseForm as Weapon
	int wRightType = ActorRef.GetEquippedItemType(1)
	int wLeftType = ActorRef.GetEquippedItemType(0)
	
	If eWeapon != none
		If wRightType == 1 || wRightType == 3 || wRightType == 4 	;ONE HANDED Weapon
			If wLeftType == 0 || wLeftType == 9 					;HELD IN TWO HANDS
				If GetState() != "ONEHBOTH"
					GoToState("ONEHBOTH")
				endIf
			Else 													;HELD IN ONE HAND
				If GetState() != "ONEHSINGLE"	
					GoToState("ONEHSINGLE")
				endIf
			endIf
		ElseIf wRightType == 5 || wRightType == 6 				;Two HANDED Weapon
			If wLeftType == 0 || wLeftType == 9 					;HELD IN TWO HANDS
				If GetState() != "TWOHSINGLE"	
					GoToState("TWOHSINGLE")
				endIf			
			Else 													;HELD IN ONE HAND
				If GetState() != "TWOHSINGLE"	
					GoToState("TWOHSINGLE")
				endIf
			endIf
		endIf
	endIf
endEvent

Function ChooseStance()

endFunction

state ONEHBOTH
	Event OnBeginState()
		FNIS_aa.SetAnimGroup(ActorRef, "_1hmidle", myMod.my_1hmidle_base, TWOHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_1hmmt", myMod.my_1hmmt_base, TWOHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_1hmatk", myMod.my_1hmatk_base, TWOHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_1hmatkpow", myMod.my_1hmatkpow_base, TWOHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_1hmblock", myMod.my_1hmblock_base, TWOHAND, "SwitchGrip", true)
		FNIS_aa.SetAnimGroup(ActorRef, "_sprint", myMod.my_sprint_base, TWOHAND, "SwitchGrip", true)
		FNIS_aa.SetAnimGroup(ActorRef, "_magidle", myMod.my_magidle_base, TWOHAND, "SwitchGrip", true)
		ChooseStance()
	endEvent
	
	Function ChooseStance()
		If isDefensive
			FNIS_aa.SetAnimGroup(ActorRef, "_1hmidle", myMod.my_1hmidle_base, TWOHAND_DEF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_1hmmt", myMod.my_1hmmt_base, TWOHAND_DEF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_magidle", myMod.my_magidle_base, TWOHAND_DEF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_h2hidle", myMod.my_h2hidle_base, TWOHAND_DEF, "SwitchGrip", true)
			
			If !ActorRef.HasPerk(TwoHandedDefense)
				ActorRef.AddPerk(TwoHandedDefense)
				ActorRef.RemovePerk(TwoHandedOffense)
			endIf
		Else
			FNIS_aa.SetAnimGroup(ActorRef, "_1hmidle", myMod.my_1hmidle_base, TWOHAND_OFF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_1hmmt", myMod.my_1hmmt_base, TWOHAND_OFF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_magidle", myMod.my_magidle_base, TWOHAND_OFF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_h2hidle", myMod.my_h2hidle_base, TWOHAND_OFF, "SwitchGrip", true)
			If !ActorRef.HasPerk(TwoHandedOffense)
				ActorRef.AddPerk(TwoHandedOffense)
				ActorRef.RemovePerk(TwoHandedDefense)
			endIf
		endIf
	endFunction
	
endState

state ONEHSINGLE

;Player is wielding a one handed weapon normally, no changes

	Event OnBeginState()
		FNIS_aa.SetAnimGroup(ActorRef, "_1hmidle", myMod.my_1hmidle_base, ONEHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_1hmmt", myMod.my_1hmmt_base, ONEHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_1hmatk", myMod.my_1hmatk_base, ONEHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_1hmatkpow", myMod.my_1hmatkpow_base, ONEHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_1hmblock", myMod.my_1hmblock_base, ONEHAND, "SwitchGrip", true)
		FNIS_aa.SetAnimGroup(ActorRef, "_sprint", myMod.my_sprint_base, ONEHAND, "SwitchGrip", true)
		FNIS_aa.SetAnimGroup(ActorRef, "_magidle", myMod.my_magidle_base, ONEHAND, "SwitchGrip", true)
		ChooseStance()
	endEvent
	
	Function ChooseStance()
		If isDefensive
			FNIS_aa.SetAnimGroup(ActorRef, "_1hmidle", myMod.my_1hmidle_base, ONEHAND_DEF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_1hmmt", myMod.my_1hmmt_base, ONEHAND_DEF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_magidle", myMod.my_magidle_base, ONEHAND_DEF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_h2hidle", myMod.my_h2hidle_base, ONEHAND_DEF, "SwitchGrip", true)
			
			If !ActorRef.HasPerk(OneHandedDefense)
				ActorRef.AddPerk(OneHandedDefense)
				ActorRef.RemovePerk(OneHandedOffense)
			endIf
		Else
			FNIS_aa.SetAnimGroup(ActorRef, "_1hmidle", myMod.my_1hmidle_base, ONEHAND_OFF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_1hmmt", myMod.my_1hmmt_base, ONEHAND_OFF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_magidle", myMod.my_magidle_base, ONEHAND_OFF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_h2hidle", myMod.my_h2hidle_base, ONEHAND_OFF, "SwitchGrip", true)
			If !ActorRef.HasPerk(OneHandedOffense)
				ActorRef.AddPerk(OneHandedOffense)
				ActorRef.RemovePerk(OneHandedDefense)
			endIf
		endIf
	endFunction
endState

state TWOHBOTH

;Player is wielding a  Two handed weapon normally, no changes

	Event OnBeginState()
		FNIS_aa.SetAnimGroup(ActorRef, "_2hmidle", myMod.my_2hmidle_base, TWOHAND, "SwitchGrip", true)        
        FNIS_aa.SetAnimGroup(ActorRef, "_2hmmt", myMod.my_2hmmt_base, TWOHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_2hmatk", myMod.my_2hmatk_base, TWOHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_2hmatkpow", myMod.my_2hmatkpow_base, TWOHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_2hmblock", myMod.my_2hmblock_base, TWOHAND, "SwitchGrip", true)
		FNIS_aa.SetAnimGroup(ActorRef, "_2hwidle", myMod.my_2hwidle_base, TWOHAND, "SwitchGrip", true) 
		FNIS_aa.SetAnimGroup(ActorRef, "_2hwatk", myMod.my_2hwatk_base, TWOHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_2hwatkpow", myMod.my_2hwatkpow_base, TWOHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_2hwblock", myMod.my_2hwblock_base, TWOHAND, "SwitchGrip", true)
		FNIS_aa.SetAnimGroup(ActorRef, "_sprint", myMod.my_sprint_base, TWOHAND, "SwitchGrip", true)
		FNIS_aa.SetAnimGroup(ActorRef, "_magidle", myMod.my_magidle_base, TWOHAND, "SwitchGrip", true)
		FNIS_aa.SetAnimGroup(ActorRef, "_h2hidle", myMod.my_h2hidle_base, TWOHAND, "SwitchGrip", true)
		ChooseStance()		
	endEvent
	
	Function ChooseStance()
		If isDefensive
			FNIS_aa.SetAnimGroup(ActorRef, "_2hmidle", myMod.my_2hmidle_base, TWOHAND_DEF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_2hmmt", myMod.my_2hmmt_base, TWOHAND_DEF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_2hwidle", myMod.my_2hwidle_base, TWOHAND_DEF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_magidle", myMod.my_magidle_base, TWOHAND_DEF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_h2hidle", myMod.my_h2hidle_base, TWOHAND_DEF, "SwitchGrip", true)
			
			If !ActorRef.HasPerk(OneHandedDefense)
				ActorRef.AddPerk(OneHandedDefense)
				ActorRef.RemovePerk(OneHandedOffense)
			endIf
		Else
			FNIS_aa.SetAnimGroup(ActorRef, "_2hmidle", myMod.my_2hmidle_base, TWOHAND_OFF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_2hmmt", myMod.my_2hmmt_base, TWOHAND_OFF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_2hwidle", myMod.my_2hwidle_base, TWOHAND_OFF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_magidle", myMod.my_magidle_base, TWOHAND_OFF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_h2hidle", myMod.my_h2hidle_base, TWOHAND_OFF, "SwitchGrip", true)
			If !ActorRef.HasPerk(OneHandedOffense)
				ActorRef.AddPerk(OneHandedOffense)
				ActorRef.RemovePerk(OneHandedDefense)
			endIf
		endIf
	endFunction
endState

state TWOHSINGLE

;Player is wielding a Two handed weapon in one hand. Give them one handed weapon animations and reduce movement and attack speeds

	Event OnBeginState()
		FNIS_aa.SetAnimGroup(ActorRef, "_2hmidle", myMod.my_2hmidle_base, ONEHAND, "SwitchGrip", true)        
        FNIS_aa.SetAnimGroup(ActorRef, "_2hmmt", myMod.my_2hmmt_base, ONEHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_2hmatk", myMod.my_2hmatk_base, ONEHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_2hmatkpow", myMod.my_2hmatkpow_base, ONEHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_2hmblock", myMod.my_2hmblock_base, ONEHAND, "SwitchGrip", true)
		FNIS_aa.SetAnimGroup(ActorRef, "_2hwatk", myMod.my_2hwatk_base, ONEHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_2hwatkpow", myMod.my_2hwatkpow_base, ONEHAND, "SwitchGrip", true)
        FNIS_aa.SetAnimGroup(ActorRef, "_2hwblock", myMod.my_2hwblock_base, ONEHAND, "SwitchGrip", true)
		FNIS_aa.SetAnimGroup(ActorRef, "_sprint", myMod.my_sprint_base, ONEHAND, "SwitchGrip", true)
		ChooseStance()
	endEvent
	
	Function ChooseStance()
		If isDefensive
			FNIS_aa.SetAnimGroup(ActorRef, "_2hmidle", myMod.my_2hmidle_base, ONEHAND_DEF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_2hmmt", myMod.my_2hmmt_base, ONEHAND_DEF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_2hwidle", myMod.my_2hwidle_base, ONEHAND_DEF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_magidle", myMod.my_magidle_base, ONEHAND_DEF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_h2hidle", myMod.my_h2hidle_base, ONEHAND_DEF, "SwitchGrip", true)
			
			If !ActorRef.HasPerk(OneHandedDefense)
				ActorRef.AddPerk(OneHandedDefense)
				ActorRef.RemovePerk(OneHandedOffense)
			endIf
		Else
			FNIS_aa.SetAnimGroup(ActorRef, "_2hmidle", myMod.my_2hmidle_base, ONEHAND_OFF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_2hmmt", myMod.my_2hmmt_base, ONEHAND_OFF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_2hwidle", myMod.my_2hwidle_base, ONEHAND_OFF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_magidle", myMod.my_magidle_base, ONEHAND_OFF, "SwitchGrip", true)
			FNIS_aa.SetAnimGroup(ActorRef, "_h2hidle", myMod.my_h2hidle_base, ONEHAND_OFF, "SwitchGrip", true)
			If !ActorRef.HasPerk(OneHandedOffense)
				ActorRef.AddPerk(OneHandedOffense)
				ActorRef.RemovePerk(OneHandedDefense)
			endIf
		endIf
	endFunction
endState