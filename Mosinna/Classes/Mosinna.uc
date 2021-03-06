// ===================================================
//  Mosinna
// ---------------------------------------------------
//  This game mode is for those who love Mosin Nagant.
// ===================================================

class Mosinna extends KFGameInfo_Survival
	config(Mosinna);

var config byte WaveToArmor;
var config byte WaveToFillGrenade;
var config int StartingMM;
var config bool bIncreaseMM;
var config bool bDisableRobots;
var config bool b6PHP;

var int increment;
var int QPcount;
var bool bAbomLikeBloat;


////[Initialize Section]////
// Called every launching maps
event InitGame(string Options, out string ErrorMessage){
	super.InitGame(Options, ErrorMessage);

	InitValue();
	SetTimer(1.f, false, 'SetPartyWidget');
}

//	InitializeValue
function InitValue(){
	if(WaveToArmor == 0) WaveToArmor = 4;
	if(WaveToFillGrenade == 0) WaveToFillGrenade = 2; 
}

//	You can see a chat box even if you play on solo
function SetPartyWidget(){
	local KFPlayerController KFPC;

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC){							
		KFPC.MyGFxManager.PartyWidget.PartyChatWidget.SetVisible(true);
	}
}

//	Force Long and HoE Game
function bool UsesModifiedLength()
{
	return true;
}
function SetModifiedGameLength()
{
    GameLength = GL_Long;
}
function bool UsesModifiedDifficulty()
{
	return true;
}
function SetModifiedGameDifficulty()
{
	super.SetModifiedGameDifficulty();

	GameDifficulty = 3;
}


////[Broadcast Section]////
//	Control ChatCommand
event Broadcast(Actor Sender, coerce string Msg, optional name Type){
	local string MsgHead,MsgBody;
	local array<String> splitbuf;

	super.Broadcast(Sender, Msg, Type);

	if ( Type == 'Say' ){
		Msg = Locs(Msg);
		ParseStringIntoArray(Msg,splitbuf," ",true);
		//if(splitbuf.length < 2) splitbuf.length = 2;
		MsgHead = splitbuf[0];
		MsgBody = splitbuf[1];

		if(Msg == "!help") LogHelp();
		else if(MsgHead == "!info"){
			if(MsgBody == "") DisplaySettings();
			else if(MsgBody == "full") LogInfo();
			else if(MsgBody == "spec") DisplaySpectatorInfo();
			else if (MsgBody == "kill") DisplayPlayerKills(KFPlayerController(Sender));
			else if (MsgBody == "match") DisplayMatchKills();
		}
		else if (MsgHead == "!smm"){
			if(MsgBody != ""){
				StartingMM = Max(int(MsgBody), 0);
				SaveConfig();
			}
			BroadcastEcho("StartingMaxMonsters = " $ string(StartingMM));
		}
		else if (MsgHead == "!imm"){
			if(MsgBody != ""){
				bIncreaseMM = bool(MsgBody);
				SaveConfig();
			}
			BroadcastEcho("IncreaseMaxMonsters = " $ string(bIncreaseMM));
		}
		else if (MsgHead == "!dr"){
			if(MsgBody != ""){
				bDisableRobots = bool(MsgBody);
				SaveConfig();
			}
			BroadcastEcho("DisableRobots = " $ string(bDisableRobots));
		}
		else if(MsgHead == "!6php"){
			if(MsgBody != ""){
				b6PHP = bool(MsgBody);
				SaveConfig();
			}
			BroadcastEcho("6PHP = " $ string(b6PHP));
		}
		else if(MsgHead == "!wta"){
			if(MsgBody != ""){
				WaveToArmor = Max(byte(MsgBody), 2);
				SaveConfig();
			}
			BroadcastEcho("WaveToArmor = " $ string(WaveToArmor));
		}
		else if(MsgHead == "!wtfg"){
			if(MsgBody != ""){
				WaveToFillGrenade = Max(byte(MsgBody), 2);
				SaveConfig();
			}
			BroadcastEcho("WaveToFillGrenade = " $ string(WaveToFillGrenade));
		}
		else if(MsgHead == "!alb"){
			if(MsgBody != "") bAbomLikeBloat = bool(MsgBody);
			BroadcastEcho("AbomLikeBloat = " $ string(bAbomLikeBloat));
		}
		else if (Left(Msg,6) == "!monyo"){
			BroadcastEcho("もにょもにょもにょ～！");
		}
	}
}

//	Message Sender for chat boxes (Default text color is green)
//	Check PlayerController Class out for details if you want
function BroadcastEcho( string MsgStr, optional name TextColorName='00FF0A' )
{
	local PlayerController PC;
	
	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		BroadcastHandler.BroadcastText( None, PC, MsgStr, TextColorName );
	}
}

//	Message Sender for console screens
function LogToConsole( string Msg ){
	BroadcastEcho(Msg, 'Console');
}

//	Log settings to console
function LogInfo(){
	LogToConsole("WaveToArmor = " $ string(WaveToArmor) $"\n"$
				 "WaveToFillGrenade = " $ string(WaveToFillGrenade) $"\n"$
				 "StartingMaxMonsters = " $ string(StartingMM) $"\n"$
				 "IncreaseMaxMonsters = " $ string(bIncreaseMM) $"\n"$
				 "6PHP = " $ string(b6PHP) $"\n"$
				 "DisableRobots = " $ string(bDisableRobots) $"\n"$
				 "  If you want to know about chat commands, hit \"!help\" into a chat box.");
	BroadcastEcho("(See Console)");
}

//	Log help for chat commands
function LogHelp(){
	LogToConsole("[Available Chat Commands]" $"\n"$
				 "!help: Show this description in console" $"\n"$
				 "!info: Display current settings in a chat box" $"\n"$
				 "!info full: Display config values fully in console" $"\n"$
				 "!info spec: Display spectators' names" $"\n"$
				 "!info kill: Display your kill records" $"\n"$
				 "!info match: Display kill records of this match" $"\n"$
				 "!smm: Set starting MaxMonsters" $"\n"$
				 "!imm: Set if MaxMonsters increase automaticaly" $"\n"$
				 "!dr: Disable robots to spawn" $"\n"$
				 "!wta: Wave to fill your armor" $"\n"$
				 "!wtfg: Wave to fill your grenades" $"\n"$
				 "!alb: Bloat looks abomination" $"\n"$
				 "!6php: Force Zeds health to set as 6Players play");
	BroadcastEcho("(See Console)");
}

//	Display values
function DisplaySettings(){
	local string Msg;
	Msg = "[Mosinna! by Asapi]" $"\n"$
		  "MaxMonsters = " $ string(SpawnManager.GetMaxMonsters()) $"\n"$
		  "6PHP = " $ string(b6PHP);
	if(bDisableRobots) Msg $= "\nDisableRobots = " $ string(bDisableRobots);
	BroadcastEcho(Msg);
}

function DisplaySpectatorInfo(){
	local KFPlayerController KFPC;
	local array<string> Results;
	local string Msg;
	local int i;

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC){
		if ( KFPC.PlayerReplicationInfo.bOnlySpectator ) Results.AddItem(KFPC.PlayerReplicationInfo.PlayerName);
	}
	Msg = "[Spectators]";
	if (Results.length >= 1 && Results[0] != ""){		
		for(i=0; i<Results.length; i++){
			Msg $= Results[i];
		}
	}
	else Msg $= "No one spectates.";
	BroadcastEcho(Msg, 'FF20B7');
}


////[Section which depend on Game progress]////
// 	Called once when a match starts
function StartMatch(){
	super.StartMatch();
}

//		Called at every beginning of waves
function StartWave(){
	super.StartWave();

	SetTimer(0.25f, false, 'DisplaySettings');
}
//	Called every time players respawn
function RestartPlayer(Controller C){
	local KFPawn Player;
	local Mos_PlayerController MPC;
	
	super.RestartPlayer(C);

	Player = KFPawn(C.Pawn);
	MPC = Mos_PlayerController(C);
	ModLoadout(Player);
	MPC.Restrict9mm();
}

//	Called at every end of waves
function WaveEnded( EWaveEndCondition WinCondition ){
	
	if(WaveMax == WaveNum){
		DramaticEvent( 1, 6.f );
	}

	super.WaveEnded( WinCondition );

	IncrementIntence();
}

//	Literally called when trader opens
//	I deleted and added some features 
State TraderOpen
{
	function BeginState( Name PreviousStateName ){
		local KFPlayerController KFPC;

		if(WaveNum >= WaveToFillGrenade - 1) Mos_FillGrenade();
		if(WaveNum >= WaveToArmor - 1) Mos_FillArmor();

		ForEach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
		{
			if( KFPC.GetPerk() != none )
			{
				KFPC.GetPerk().OnWaveEnded();
			}
			KFPC.ApplyPendingPerks();
		}
		StartHumans();
		if ( AllowBalanceLogging() )
		{
			LogPlayersDosh(GBE_TraderOpen);
		}
		SetTimer(0.25f, false, nameof(CloseTraderTimer));
	}
}


////[Others]////
//	Allow debug cheats such as EndCurrentWave, SetWave and WinMatch etc...
function bool AllowWaveCheats()
{
    return true;
}

//	IncrementDifficulty
function IncrementIntence(){
	local int PlayersCount;

	if(!bIncreaseMM){
		increment = 0;
		return;
	}

	PlayersCount = GetNumPlayers();
	if(PlayersCount <= 2) increment = 1;
	else if (PlayersCount <= 4) increment = 2;
	else if (PlayersCount == 5) increment = 3;
	else if (PlayersCount == 6) increment = 4;
	else increment = 5;

	increment *= WaveNum;
}

//	Set loadout weapons
function ModLoadout(KFPawn Player){
	local Inventory Inv;

	for(Inv=Player.InvManager.InventoryChain;Inv!=None;Inv=Inv.Inventory){
		if(Inv != None){
			Player.InvManager.RemoveFromInventory(Inv);			
		}
	}

	Player.CreateInventory(class'Mosinna.Mos_Weap_MosinNagant');
	Player.CreateInventory(class'Mosinna.Mos_Weap_MedicPistol');
}

//	Stats
function DisplayPlayerKills(KFPlayerController KFPC){
	local array<int> KillStats;
	local array<int> KillsBySize;

	KillStats.length=16;
	KillsBySize.length=3;
	
	CountKillStats(KFPC, KillStats);
	ParseKillsbySize(KillStats, KillsBySize);

	BroadcastEcho("[" $ KFPC.PlayerReplicationInfo.PlayerName $ "]" $"\n"$
			 		GetStatsDiscSummary(KillsbySize));
	LogToConsole(GetFullStatsDisc(KillStats));
}

function DisplayMatchKills(){
	local array<int> KillStats;
	local array<int> KillsBySize;
	local KFPlayerController KFPC;

	KillStats.length=16;
	KillsBySize.length=3;

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC){
		CountKillStats(KFPC, KillStats);
	}

	ParseKillsbySize(KillStats, KillsBySize);

	BroadcastEcho("[Wave 1" $ "~ " $ string(WaveNum) $ "]" $"\n"$
			 		GetStatsDiscSummary(KillsbySize));
	LogToConsole(GetFullStatsDisc(KillStats));
}

function CountKillStats(KFPlayerController KFPC, out array<int> KillStats){
	local array<ZedKillType> PersonalStats;
	local ZedKillType Status;

	PersonalStats = KFPC.MatchStats.ZedKillsArray;
	foreach PersonalStats(Status){
		switch(Status.MonsterClass){
			case class'KFGameContent.KFPawn_ZedClot_Cyst':
				KillStats[0] += Status.KillCount;
				break;
			case class'KFGameContent.KFPawn_ZedClot_Alpha':
				KillStats[1] += Status.KillCount;
				break;
			case class'KFGameContent.KFPawn_ZedClot_Slasher':
				KillStats[2] += Status.KillCount;
				break;
			case class'KFGameContent.KFPawn_ZedClot_AlphaKing':
				KillStats[3] += Status.KillCount;
				break;
			case class'KFGameContent.KFPawn_ZedGorefast':
				KillStats[4] += Status.KillCount;
				break;
			case class'KFGameContent.KFPawn_ZedGorefastDualBlade':
				KillStats[5] += Status.KillCount;
				break;
			case class'KFGameContent.KFPawn_ZedCrawler':
				KillStats[6] += Status.KillCount;
				break;
			case class'KFGameContent.KFPawn_ZedCrawlerKing':
				KillStats[7] += Status.KillCount;
				break;
			case class'KFGameContent.KFPawn_ZedStalker':
			case class'Mosinna.Mos_Pawn_ZedStalker_Regular':
				KillStats[8] += Status.KillCount;
				break;
			case class'KFGameContent.KFPawn_ZedBloat':
			case class'Mosinna.Mos_Pawn_ZedBloatFakeKing':
				KillStats[9] += Status.KillCount;
				break;
			case class'KFGameContent.KFPawn_ZedSiren':
				KillStats[10] += Status.KillCount;
				break;
			case class'KFGameContent.KFPawn_ZedHusk':
			case class'Mosinna.Mos_Pawn_ZedHusk_Regular':
				KillStats[11] += Status.KillCount;
				break;
			case class'KFGameContent.KFPawn_ZedDAR_EMP':
			case class'KFGameContent.KFPawn_ZedDAR_Laser':
			case class'KFGameContent.KFPawn_ZedDAR_Rocket':
				KillStats[12] += Status.KillCount;
				break;
			case class'KFGameContent.KFPawn_ZedFleshpoundMini':
				KillStats[13] += Status.KillCount;
				break;
			case class'KFGameContent.KFPawn_ZedFleshpound':
				KillStats[14] += Status.KillCount;
				break;
			case class'KFGameContent.KFPawn_ZedScrake':
				KillStats[15] += Status.KillCount;
				break;
		}
	}
}

function ParseKillsbySize(array<int> KillStats, out array<int> KillsBySize){
	local int i;

	for(i=0; i<16; i++){
		if(i<9) KillsBySize[0] += KillStats[i];
		else if(i<12) KillsBySize[1] += KillStats[i];
		else KillsBySize[2] += KillStats[i];
	}
}

function string GetStatsDiscSummary(array<int> KillsBySize){
	local string Result;
	local float total;
	local array<int> pct;
	local int i;

	total = float(KillsBySize[0] + KillsBySize[1] + KillsBySize[2]);
	for(i=0; i<3; i++){
		pct[i] = (total == 0) ? 0 : int((float(KillsBySize[i]) / total) * 100.f);
	}

	Result = "Trash: " $ string(KillsBySize[0]) $ " (" $ string(pct[0]) $ "%)" $"\n"$
			 "Medium: " $ string(KillsBySize[1]) $ " (" $ string(pct[1]) $ "%)" $"\n"$
			 "Large: " $ string(KillsBySize[2]) $ " (" $ string(pct[2]) $ "%)" $"\n"$
			 "(See Console for more)";
	return Result;
}

function string GetFullStatsDisc(array<int> KillStats){
	local string Result;
	local float total;
	local array<int> pct;
	local int i;

	for(i=0; i<16; i++){
		total += float(KillStats[i]);
	}
	for(i=0; i<16; i++){
		pct[i] = (total == 0) ? 0 : int((float(KillStats[i]) / total) * 100.f);
	}

	Result = "---------------------------" $"\n"$
			 "Cyst: " $ string(KillStats[0]) $ " (" $ string(pct[0]) $ "%)" $"\n"$
			 "AlphaClot: " $ string(KillStats[1]) $ " (" $ string(pct[1]) $ "%)" $"\n"$
			 "Slasher: " $ string(KillStats[2]) $ " (" $ string(pct[2]) $ "%)" $"\n"$
			 "Rioter: " $ string(KillStats[3]) $ " (" $ string(pct[3]) $ "%)" $"\n"$
			 "Gorefast: " $ string(KillStats[4]) $ " (" $ string(pct[4]) $ "%)" $"\n"$
			 "Gorefiend: " $ string(KillStats[5]) $ " (" $ string(pct[5]) $ "%)" $"\n"$
			 "Crawler: " $ string(KillStats[6]) $ " (" $ string(pct[6]) $ "%)" $"\n"$
			 "EliteCrawler: " $ string(KillStats[7]) $ " (" $ string(pct[7]) $ "%)" $"\n"$
			 "Stalker: " $ string(KillStats[8]) $ " (" $ string(pct[8]) $ "%)" $"\n"$
			 "---------------------------" $"\n"$
			 "Bloat: " $ string(KillStats[9]) $ " (" $ string(pct[9]) $ "%)" $"\n"$
			 "Siren: " $ string(KillStats[10]) $ " (" $ string(pct[10]) $ "%)" $"\n"$
			 "Husk: " $ string(KillStats[11]) $ " (" $ string(pct[11]) $ "%)" $"\n"$
			 "EDAR: " $ string(KillStats[12]) $ " (" $ string(pct[12]) $ "%)" $"\n"$
			 "---------------------------" $"\n"$
			 "Quarterpound: " $ string(KillStats[13]) $ " (" $ string(pct[13]) $ "%)" $"\n"$
			 "Fleshpound: " $ string(KillStats[14]) $ " (" $ string(pct[14]) $ "%)" $"\n"$
			 "Scrake: " $ string(KillStats[15]) $ " (" $ string(pct[15]) $ "%)";
	return Result;
}

//	AutoFill
function Mos_FillGrenade(){
	local KFPawn Player;
	local KFPlayerController KFPC;

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC){
		Player = KFPawn(KFPC.Pawn);
		KFInventoryManager(Player.InvManager).AddGrenades(100);
	}
}
function Mos_FillArmor(){
	local KFPawn_Human Player;
	local KFPlayerController KFPC;

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC){
		Player = KFPawn_Human(KFPC.Pawn);
		Player.GiveMaxArmor();
	}
}

//	To upgrade zeds
function bool bUpgradeZed(class<KFPawn_Monster> PreZed, out class<KFPawn_Monster> PostZed){
	//	Cr>Bl (25%)
	if(PreZed == class'KFGameContent.KFPawn_ZedCrawler'){
		PostZed = class'KFGameContent.KFPawn_ZedBloat';
		return (FRand() < 0.25f) ? true : false;
	}
	//	St>Si (25%)
	if(PreZed == class'KFGameContent.KFPawn_ZedStalker'){
		PostZed = class'KFGameContent.KFPawn_ZedSiren';
		return (FRand() < 0.25f) ? true : false;
	}
	//	QP>FP
	if(PreZed == class'KFGameContent.KFPawn_ZedFleshpoundMini'){
		QPcount++;
		PostZed = class'KFGameContent.KFPawn_ZedFleshpound';
		if(WaveNum <= 5) return (QPcount % 4 == 0) ? true : false;
		else if(WaveNum <= 10) return (QPcount % 3 == 0) ? true : false;
		else return (QPcount % 2 == 0) ? true : false;
	}

	if(WaveNum <= 7) return false;
	//	Cr>Sc (15%)
	if(PreZed == class'KFGameContent.KFPawn_ZedCrawler'){
		PostZed = class'KFGameContent.KFPawn_ZedScrake';
		return (FRand() < 0.2f) ? true : false;
	}
	//	St>Gf*(15%)
	if(PreZed == class'KFGameContent.KFPawn_ZedStalker'){
		PostZed = class'KFGameContent.KFPawn_ZedGorefastDualBlade';
		return (FRand() < 0.2f) ? true : false;
	}

	if(WaveNum <= 8) return false;
	//	Cy>Al (100%)
	if(PreZed == class'KFGameContent.KFPawn_ZedClot_Cyst'){
		PostZed = class'KFGameContent.KFPawn_ZedClot_Alpha';
		return true;
	}
	//	Gf>Sc (20%)
	if(PreZed == class'KFGameContent.KFPawn_ZedGorefast'){
		PostZed = class'KFGameContent.KFPawn_ZedScrake';
		return (FRand() < 0.2f) ? true : false;
	}

	if(WaveNum <= 9) return false;
	//	Al>Si (66%)
	if(PreZed == class'KFGameContent.KFPawn_ZedClot_Alpha'){
		PostZed = class'KFGameContent.KFPawn_ZedSiren';
		return (FRand() < 0.66f) ? true : false;
	}
	//	Cr>Al*(20%)
	if(PreZed == class'KFGameContent.KFPawn_ZedCrawler'){
		PostZed = class'KFGameContent.KFPawn_ZedClot_AlphaKing';
		return (FRand() < 0.33f) ? true : false;
	}

	if(WaveNum <= 10) return false;
	//	Sl>Sc (33%)
	if(PreZed == class'KFGameContent.KFPawn_ZedClot_Slasher'){
		PostZed = class'KFGameContent.KFPawn_ZedScrake';
		return (FRand() < 0.33f) ? true : false;
	}
	//	St>Fp (20%)
	if(PreZed == class'KFGameContent.KFPawn_ZedStalker'){
		PostZed = class'KFGameContent.KFPawn_ZedFleshpound';
		return (FRand() < 0.33f) ? true : false;
	}

	return false;
}

function SetBossIndex()
{
	MyKFGRI.CacheSelectedBoss(0);
}

defaultproperties
{
	GameReplicationInfoClass = class'Mosinna.Mos_GameReplicationInfo'
	DifficultyInfoClass = class'Mosinna.Mos_DifficultyInfo'	
	SpawnManagerClasses(2) = class'Mosinna.Mos_SpawnManager_Long'
	PlayerControllerClass = class'Mosinna.Mos_PlayerController'
}