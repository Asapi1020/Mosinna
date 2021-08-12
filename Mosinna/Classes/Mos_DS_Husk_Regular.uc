//=============================================================================
// Mos_DS_Husk_Regular
//=============================================================================
// No husk will be upgraded to EDAR
//=============================================================================
class Mos_DS_Husk_Regular extends KFDifficulty_Husk
	abstract;

static function float GetSpecialSpawnChance(KFGameReplicationInfo KFGRI)
{
	return 0.f;
}
