/*********************************************************************************
*                                                                                *
*             ______     _____        _______ _____  __  __                      *
*            |  ____|   / ____|      |__   __|  __ \|  \/  |                     *
*            | |__ ___ | |     ___      | |  | |  | | \  / |                     *
*            |  __/ _ \| |    / _ \     | |  | |  | | |\/| |                     *
*            | | | (_) | |___| (_) |    | |  | |__| | |  | |                     *
*            |_|  \___/ \_____\___/     |_|  |_____/|_|  |_|                     *
*                                                                                *
*                                                                                *
*                        (c) Copyright                                           *
*  Owners: Simon Fagerli (pEar) - Lee Percox (Shaney) - Warren Bickley (WazzaJB) *
*         Developers: Marcel, RakGuy, FKu, Chilco, dr_vista, Fletcher            *
*                                                                                *
* Filename: pEar_TriggerBot.pwn                                                  *
* Author: pEar	                                                                 *
*********************************************************************************/

#include <YSI\y_hooks>

new triggerbot_flag[MAX_PLAYERS];

forward pEar_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);

hook OnGameModeInit()
{
	for(new i = 0; i < MAX_PLAYERS; i++) {
		triggerbot_flag[i] = 0;
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	triggerbot_flag[playerid] = 0;
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_FIRE) {
		triggerbot_flag[playerid] = 0;
		new string[128];
		format(string, sizeof(string), "%s(%d) fired a bullet", PlayerName(playerid), playerid);
		DebugMsg(string);
	}
	return 1;
}

public pEar_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(triggerbot_flag[playerid] != 0) {
		if(weaponid == 24 || weaponid == 31) {
			new string[128];
			format(string, sizeof(string), "%s(%d) might be using a triggerbot.", PlayerName(playerid), playerid);
			AntiCheatMessage(string);
		}
	}	
	triggerbot_flag[playerid] = 1;
	return 1;
}