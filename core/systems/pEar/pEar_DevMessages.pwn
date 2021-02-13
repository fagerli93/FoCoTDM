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
* Filename: pEar_DevMessages.pwn                                                 *
* Author: pEar	                                                                 *
*********************************************************************************/

#include <YSI\y_hooks>

#define MAX_DEVS 5

new devs[MAX_DEVS];


hook OnGameModeInit()
{
	for(new i = 0; i < MAX_DEVS; i++)
	{
		devs[i] = -1;
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	//DebugMsg("DevM Start");
	if(FoCo_Player[playerid][dev] > 0)
	{
		for(new i = 0; i < MAX_DEVS; i++)
		{
			if(devs[i] == playerid)
			{
				devs[i] = -1;
				break;
			}
		}
	}
	//DebugMsg("DevM Done");
	return 1;
}

forward SendDevMessage(message[]);
public SendDevMessage(message[])
{
	new string[256];
	format(string, sizeof(string), "[DEV]: %s", message);
	for(new i = 0; i < MAX_DEVS; i++)
	{
		if(devs[i] != -1 && devs[i] != INVALID_PLAYER_ID && IsPlayerLoggedIn(devs[i]))
		{
			if(GetPVarInt(devs[i], "DevMsg") == 1)
			{
				SendClientMessage(devs[i], COLOR_GLOBALNOTICE, string);
			}
		}
	}
	return 1;
}


CMD:devmsg(playerid, params)
{
	if(IsDev(playerid, 1))
	{
		if(GetPVarInt(playerid, "DevMsg") == 1)
		{
			SendClientMessage(playerid, COLOR_GLOBALNOTICE, "[DEV]: Disabled dev messages.");
			SetPVarInt(playerid, "DevMsg", 0);	
		}
		else
		{
			SendClientMessage(playerid, COLOR_GLOBALNOTICE, "[DEV]: Enabled dev messages. If they don't show, then you dont have a dev spot.");
			SetPVarInt(playerid, "DevMsg", 1);	
		}
	}
	return 1;
}
