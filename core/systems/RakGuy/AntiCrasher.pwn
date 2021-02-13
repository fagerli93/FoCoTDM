#include <YSI\y_hooks>


hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	//DO WHAT YOU DO TO AVOID SPAM.. Like in BulletCrasher old version..
	if(GetPlayerWeapon(playerid)!= weaponid && hittype == 0 && hitid > MAX_PLAYERS && hitid != INVALID_PLAYER_ID && fX == 0.0 && fY == 0.0 && fZ == 0.0)
	{
	    ABanPlayer(-1, playerid, "BulletCrasher[LT]");
	    return 0;
	}
	else if((GetPlayerWeapon(playerid)!= weaponid || (hitid > MAX_PLAYERS && hitid != INVALID_PLAYER_ID ) || (fX == 0.0 && fY == 0.0 && fZ == 0.0))&& hittype == 0)
	{
	    return 0;
	}
	return 1;
}











