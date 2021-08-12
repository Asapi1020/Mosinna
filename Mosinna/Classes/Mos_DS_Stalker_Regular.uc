//=============================================================================
// Mos_DS_Stalker_Regular
//=============================================================================
// finally stalker cant be EDAR
//=============================================================================
class Mos_DS_Stalker_Regular extends KFDifficulty_Stalker
	abstract;

static function float GetSpecialSpawnChance(KFGameReplicationInfo KFGRI)
{
	return 0.f;
}
