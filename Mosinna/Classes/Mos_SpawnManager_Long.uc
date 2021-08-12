// ===================================================
//  Mos_SpawnManager_Long
// ---------------------------------------------------
//  Modify MaxMonsters and SpawnCycle
// ===================================================

class Mos_SpawnManager_Long extends KFAISpawnManager
	within Mosinna;

//	Set MM
function int GetMaxMonsters(){
	if(StartingMM == 0) StartingMM = super.GetMaxMonsters();
	return StartingMM + increment;
}

//	To replace Zeds
function GetSpawnListFromSquad(byte SquadIdx, out array< KFAISpawnSquad > SquadsList, out array< class<KFPawn_Monster> >  AISpawnList){
	local int i;
	local class<KFPawn_Monster> TargetZed;

	super.GetSpawnListFromSquad(SquadIdx, SquadsList, AISpawnList);

	for ( i = 0; i < AISpawnList.Length; i++ ){
		if(bUpgradeZed(AISpawnList[i], TargetZed)){
			AISpawnList[i] = TargetZed;
		}
		if(bDisableRobots){
			if(AISpawnList[i] == AIClassList[AT_Stalker]){
				AISpawnList[i] = class'Mosinna.Mos_Pawn_ZedStalker_Regular';
			}
			else if (AISpawnList[i] == AIClassList[AT_Husk]){
				AISpawnList[i] = class'Mosinna.Mos_Pawn_ZedHusk_Regular';
			}
		}
		if(bAbomLikeBloat){
			if(AISpawnList[i] == AIClassList[AT_Bloat] || AISpawnList[i] == class'KFGameContent.KFPawn_ZedBloat'){
				AISpawnList[i] = class'Mosinna.Mos_Pawn_ZedBloatFakeKing';
			}
		}
	}
	AISpawnList.RemoveItem(AIClassList[AT_FleshpoundMini]);
}

DefaultProperties
{	
	EarlyWaveIndex=5

	// ---------------------------------------------
	// Wave settings
	// Hell On Earth
	DifficultyWaveSettings(3)={(Waves[0]=KFAIWaveInfo'GP_Spawning_ARCH.Long.HOE.ZED_Wave3_Long_HOE',
	                            Waves[1]=KFAIWaveInfo'GP_Spawning_ARCH.Long.HOE.ZED_Wave4_Long_HOE',
	                            Waves[2]=KFAIWaveInfo'GP_Spawning_ARCH.Long.HOE.ZED_Wave5_Long_HOE',
	                            Waves[3]=KFAIWaveInfo'GP_Spawning_ARCH.Long.HOE.ZED_Wave6_Long_HOE',
	                            Waves[4]=KFAIWaveInfo'GP_Spawning_ARCH.Long.HOE.ZED_Wave7_Long_HOE',
	                            Waves[5]=KFAIWaveInfo'GP_Spawning_ARCH.Long.HOE.ZED_Wave8_Long_HOE',
	                            Waves[6]=KFAIWaveInfo'GP_Spawning_ARCH.Long.HOE.ZED_Wave9_Long_HOE',
	                            Waves[7]=KFAIWaveInfo'GP_Spawning_ARCH.Long.HOE.ZED_Wave10_Long_HOE',
	                            Waves[8]=KFAIWaveInfo'GP_Spawning_ARCH.Long.HOE.ZED_Wave10_Long_HOE',
	                            Waves[9]=KFAIWaveInfo'GP_Spawning_ARCH.Long.HOE.ZED_Wave10_Long_HOE',
	                            Waves[10]=KFAIWaveInfo'GP_Spawning_ARCH.Long.HOE.ZED_Wave10_Long_HOE')}

	// Hell On Earth
	SoloWaveSpawnRateModifier(3)={(RateModifier[0]=1.0,     // Wave 1
	                               RateModifier[1]=1.0,     // Wave 2
	                               RateModifier[2]=1.0,     // Wave 3
	                               RateModifier[3]=1.0,     // Wave 4
	                               RateModifier[4]=1.0,     // Wave 5
	                               RateModifier[5]=1.0,     // Wave 6
	                               RateModifier[6]=1.0,     // Wave 7
	                               RateModifier[7]=1.0,     // Wave 8
	                               RateModifier[8]=1.0,     // Wave 9
	                               RateModifier[9]=1.0)}    // Wave 10

}
