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
*                        (c) Copyright                                           *as
*  Owners: Simon Fagerli (pEar) - Lee Percox (Shaney) - Warren Bickley (WazzaJB) *
*         Developers: Marcel, RakGuy, FKu, Chilco, dr_vista, Fletcher            *
*                                                                                *
* Filename:  afksystem.pwn                                                       *
* Author:    Marcel                                                              *
*********************************************************************************/

#include <YSI\y_hooks>

CMD:afk(playerid, params[])
{
	new reason[50], string[50];
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
		return SendErrorMessage(playerid, "Please wait till you have spawned!");
	}
	if (sscanf(params, "s[50]", reason))
	{
		if(GetPVarInt(playerid, "PlayerStatus") == PLAYERSTATUS_AFK)
		{
		    KillTimer(afkTimer[playerid]);
			SendClientMessage(playerid, COLOR_NOTICE, "[AFK Notice]: You have returned from being AFK.");
			SpawnPlayer(playerid);
			SetPVarInt(playerid, "PlayerStatus", PLAYERSTATUS_NORMAL);
			return 1;
		}
		format(string, sizeof(string), "[USAGE]: {%06x}/afk{%06x} [reason]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		return 1;
	}
	if(isAFK[playerid] != -1 && canAFK[playerid] != -1)
	{
	    KillTimer(afkTimer[playerid]);
		SendClientMessage(playerid, COLOR_NOTICE, "[AFK Notice]: You have returned from being AFK.");
		SpawnPlayer(playerid);
		SetPVarInt(playerid, "PlayerStatus", PLAYERSTATUS_NORMAL);
		canAFK[playerid] = 1;
		return 1;
	}
	else
	{
		if(GetPVarInt(playerid, "InEvent") == 1)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[AFK Notice]: You cannot go AFK in an event");
			return 1;
		}
		if(ManHuntID == playerid)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[AFK Notice]: You cannot go AFK whilst you're the manhunt target");
			return 1;
		}
		if(FoCo_Player[playerid][jailed] != 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[AFK Notice]: You cannot go AFK whilst you're in admin jail.");
			return 1;
		}
		if(lastHit[playerid] > GetUnixTime() + 15)
		{
			SendClientMessage(playerid, COLOR_NOTICE, "[AFK Notice]: You cannot go AFK whilst you have been hit in the last 15 seconds.");
			return 1;
		}
		if(afkTimer[playerid] != -1)
		{
		    SendClientMessage(playerid, COLOR_NOTICE, "[AFK Notice]: You already typed /afk. Wait until the 15 seconds are over!");
		    return 1;
		}
		if(GetPVarInt(playerid, "PlayerStatus") == PLAYERSTATUS_INDUEL)
		{
		    SendClientMessage(playerid, COLOR_NOTICE, "[AFK Notice]: You cannot go AFK during a duel!");
		    return 1;
		}
		if(strlen(reason) > 10)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Max reason length is 10 characters.");
			return 1;
		}
		if(canAFK[playerid] == -1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to wait till you are teleported before using the /afk command again.");
		}
		canAFK[playerid] = -1;
		isAFK[playerid] = 1;
		format(string, sizeof(string), "%s", reason);
		afkReason[playerid] = string;
		afkTimer[playerid] = SetTimerEx("SetAFK", 15000, false, "i", playerid);
		SendClientMessage(playerid, COLOR_NOTICE, "[AFK Notice]: The AFK Timer has began, if you take no damage in 15 seconds, you will be");
		SendClientMessage(playerid, COLOR_NOTICE, "[AFK Notice]: ... teleported to the safe zone where you can AFK for 10 minutes.");
	}
	return 1;
}

hook OnGameModeInit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		afkTimer[i] = -1;
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	afkTimer[playerid] = -1;
	return 1;
}
