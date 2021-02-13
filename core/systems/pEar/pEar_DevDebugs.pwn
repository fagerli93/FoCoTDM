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
* Filename: pEar_DevDebugs.pwn                                                   *
* Author: pEar     															     *
*********************************************************************************/

#include <YSI\y_hooks>

new OPWS[MAX_PLAYERS];

#if defined PTS

hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	new string[256];
	format(string, sizeof(string), "[DEBUG]: OPWS - PID: %d, WeaponID: %d, HitType: %d, HitID: %d, fX: %f, fY: %f, fZ: %f", playerid, weaponid, hittype, hitid, fX, fY, fZ);
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(OPWS[i] == 1)
		{
			SendClientMessage(playerid, COLOR_GLOBALNOTICE, string);
		}
	}
	return 1;
}


CMD:dev_OPWS(playerid, params[])
{
	if(FoCo_Player[playerid][dev] == 1)
	{
		if(OPWS[playerid] != 1)
		{
			OPWS[playerid] = 1;
			return SendClientMessage(playerid, COLOR_GLOBALNOTICE, "[NOTICE]: Enabled development OnPlayerWeaponShot debugs");
		}
		else
		{
			OPWS[playerid] = 0;
			return SendClientMessage(playerid, COLOR_GLOBALNOTICE, "[NOTICE]: Disabled development OnPlayerWeaponShot debugs");
		}
	}
	else
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not a developer!");
	}
}

hook OnGameModeInit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		OPWS[i] = 0;
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	OPWS[playerid] = 0;
	return 1;
}

#endif
