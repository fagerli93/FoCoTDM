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
* Filename:  afksystem.pwn                                                       *
* Author:    Marcel                                                              *
*********************************************************************************/

CMD:afk(playerid, params[])
{
	new reason[50], string[50];
	if (sscanf(params, "s[50]", reason))
	{
		if(GetPVarInt(playerid, "PlayerStatus") == 3)
		{
			KillTimer(afkTimer[playerid]);
			SendClientMessage(playerid, COLOR_NOTICE, "[AFK Notice]: You have been returned from being AFK.");
			SpawnPlayer(playerid);
			SetPVarInt(playerid, "PlayerStatus", 0);
			return 1;
		}
		format(string, sizeof(string), "[USAGE]: {%06x}/afk{%06x} [reason]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		return 1;
	}
	if(GetPVarInt(playerid, "PlayerStatus") == 3)
	{
		KillTimer(afkTimer[playerid]);
		SendClientMessage(playerid, COLOR_NOTICE, "[AFK Notice]: You have returned from being AFK.");
		SpawnPlayer(playerid);
		SetPVarInt(playerid, "PlayerStatus", 0);
		return 1;
	}
	if(GetPVarInt(playerid, "InEvent") == 1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[AFK Notice]: You cannot go AFK in an event");
		return 1;
	}
	if(ManHuntID == playerid)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[AFK Notice]: You cannot go AFK whilst your the manhunt target");
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
	if(GetPVarInt(playerid, "PlayerStatus") == 2)
	{
	    SendClientMessage(playerid, COLOR_NOTICE, "[AFK Notice]: You cannot go AFK during a duel!");
	    return 1;
	}
	if(strlen(reason) > 10)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Max reason length is 10 characters.");
		return 1;
	}
	format(string, sizeof(string), "%s", reason);
	afkReason[playerid] = string;
	afkTimer[playerid] = SetTimerEx("SetAFK", 15000, false, "i", playerid);
	SendClientMessage(playerid, COLOR_NOTICE, "[AFK Notice]: The AFK Timer has began, if you take no damage in 15 seconds, you will be");
	SendClientMessage(playerid, COLOR_NOTICE, "[AFK Notice]: ... teleported to the safe zone where you can AFK for 10 minutes.");
	return 1;
}
