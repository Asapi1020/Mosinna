// ===================================================
//  Mos_Weap_MosinNagant
// ---------------------------------------------------
//  Strength is not modified
// ===================================================

class Mos_Weap_MosinNagant extends KFWeap_Rifle_MosinNagant;

defaultproperties
{	
	bCanThrow = false
	bDropOnDeath = false
	bInfiniteSpareAmmo = true
	InventorySize=15
	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.15f), (Stat=EWUS_Damage1, Scale=1.15f), (Stat=EWUS_Weight, Add=0)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.3f), (Stat=EWUS_Damage1, Scale=1.3f), (Stat=EWUS_Weight, Add=0)))
}