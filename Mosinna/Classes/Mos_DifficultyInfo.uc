// ===================================================
//  Mos_DifficultyInfo
// ---------------------------------------------------
//  To set 6PHP
// ===================================================

class Mos_DifficultyInfo extends KFGameDifficulty_Survival
	within Mosinna
	DependsOn(Mosinna);

function GetVersusHealthModifier(KFPawn_Monster P, byte NumLivingPlayers, out float HealthMod, out float HeadHealthMod)
{	
	super.GetVersusHealthModifier(P, (b6PHP) ? 6 : NumLivingPlayers, HealthMod, HeadHealthMod);
}

function GetAIHealthModifier(KFPawn_Monster P, float ForGameDifficulty, byte NumLivingPlayers, out float HealthMod, out float HeadHealthMod, optional bool bApplyDifficultyScaling=true)
{
	super.GetAIHealthModifier(P, ForGameDifficulty, (b6PHP) ? 6 : NumLivingPlayers, HealthMod, HeadHealthMod, bApplyDifficultyScaling);
}