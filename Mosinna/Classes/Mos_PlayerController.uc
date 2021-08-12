// ===================================================
//  Mos_PlayerController
// ---------------------------------------------------
//  For ConsolePrint and BroadcastEcho
// ===================================================

class Mos_PlayerController extends KFPlayerController;

reliable client event TeamMessage( PlayerReplicationInfo PRI, coerce string S, name Type, optional float MsgLifeTime  )
{
	if ( PRI == None && S != "" && Type == 'Console')
	{
		LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText("[Mosinna : Console Printer]\n  " $ Repl(S, "\n", "\n  "));
	}

	else if ( PRI == None && S != "" && TypeIsColor(Type) )
	{
		if ( None != MyGFxManager.PartyWidget )
		{
			MyGFxManager.PartyWidget.ReceiveMessage( S, string(Type) );
		}

		if (MyGFxManager != none)
		{
			if( None != MyGFxManager.PostGameMenu )
			{
				MyGFxManager.PostGameMenu.ReceiveMessage( S, string(Type) );
			}
		}

		if( None != MyGFxHUD && None != MyGFxHUD.HudChatBox )
		{
			MyGFxHUD.HudChatBox.AddChatMessage(S, string(Type));
		}
	}
	else if(!(StopBroadcast(S)))
	{
		// Everything else is processed as usual
		super.TeamMessage( PRI, S, Type, MsgLifeTime );
	}
}

//	Recognize color
function bool TypeIsColor(name Type){
	switch(Type){
		case '00FF0A': //Green
		case 'FF0000': //Red
		case 'F8FF00': //Yellow
		case '00DCCE': //Blue
		case 'FF20B7': //Pink
			return true;
	}
	return false;
}

//	This is idea to hide specific messages
function bool StopBroadcast(string s){
	/*
	switch(s){
		case "SthToBeDeleted":
			return true;
	}
	*/
	return false;
}

function Restrict9mm(){
	local Weapon Weap;

	Weap = Pawn.Weapon;
	if(Weap.ItemName == class'KFGameContent.KFWeap_Pistol_9mm'.default.ItemName){
		Weap.Destroyed();
	}
	else SetTimer(0.5f, false, 'Restrict9mm');
}

defaultproperties
{
	PerkList.Remove((PerkClass=class'KFPerk_Berserker'))
	PerkList.Remove((PerkClass=class'KFPerk_Commando'))
	PerkList.Remove((PerkClass=class'KFPerk_Support'))
	PerkList.Remove((PerkClass=class'KFPerk_Demolitionist'))
	PerkList.Remove((PerkClass=class'KFPerk_Firebug'))
	PerkList.Remove((PerkClass=class'KFPerk_Gunslinger'))
	PerkList.Remove((PerkClass=class'KFPerk_Swat'))
}