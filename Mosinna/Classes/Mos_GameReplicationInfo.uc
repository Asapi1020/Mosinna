// ===================================================
//  Mos_GameReplicationInfo
// ---------------------------------------------------
//  To modify wave recognization
// ===================================================

class Mos_GameReplicationInfo extends KFGameReplicationInfo;

//	Display wave 10 as wave 10, not final wave
simulated function bool IsFinalWave()
{
	return WaveNum == WaveMax;
}

//	Necessary because TotalAI on wave 11 must be 1 if these can be true
simulated function bool IsBossWave()
{
	return false;
}
simulated function bool IsBossWaveNext()
{
	return false;
}