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
* Filename:	pEar_MaxPlayersPerIP.pwn	                                         *
* Author: pEar                                                                   *
*********************************************************************************/

#include <YSI\y_hooks>
#include <YSI\y_timers>

new 
	MaxPlayersPerIP,
	MAX_OPLAYERS,
	IPs[MAX_PLAYERS][16],
	IPs_Alike[MAX_PLAYERS];
	
	
hook OnGameModeInit()
{
	MaxPlayersPerIP = 3;
	MAX_OPLAYERS = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		IPs_Alike[i] = 0;
		for(new k = 0; k < 16; k++)
		{
			IPs[i][k] = -1;
		}
	}
	return 1;
}

hook OnPlayerConnect(playerid)
{
	new i;
	new IP[16];
	IPs_Alike[playerid] = 0;
	GetPlayerIp(playerid, IP, sizeof(IP));
	
	for(i = 0; i < 16; i++)
	{
		IPs[playerid][i] = IP[i];
	}
	if(playerid > MAX_OPLAYERS)
	{
		MAX_OPLAYERS = playerid;
	}
	for(i = 0; i < MAX_OPLAYERS; i++)
	{
		if(i != playerid)
		{
			if(strcmp(IPs[playerid], IPs[i], true) == 0)
			{
				IPs_Alike[playerid]++;
			}
		}
	}
	if((IPs_Alike[playerid] + 1) > MaxPlayersPerIP)
	{
		new kickstring[56];
		format(kickstring, sizeof(kickstring), "Max %d player(s) per IP allowed!", MaxPlayersPerIP);
		SendClientMessage(playerid, COLOR_WARNING, kickstring);
		if(playerid == INVALID_PLAYER_ID)
		{
			return 1;
		}
		new string[256];
		format(string, sizeof(string), "AdmCmd(%d): The Guardian has kicked %s(%d), Reason: Max %d player(s) per IP allowed!", ACMD_KICK, PlayerName(playerid), playerid, MaxPlayersPerIP);
		AdminLog(string);
		SendAdminMessage(1, string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', 'The Guardian', '2', 'Max %d player(s) per IP allowed!', '%s')", FoCo_Player[playerid][id], MaxPlayersPerIP, TimeStamp());
		mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
		SetTimerEx("KickPlayer", 1000, false, "d", playerid);
		return 1;
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	//DebugMsg("MPIP_BG");
	new i;
	for(i = 0; i < 16; i++)
	{
		IPs[playerid][i] = -1;
	}
	//DebugMsg("MPIP_Done");
	return 1;
}

task CountHighestPlayer[60000]()
{
	new i;
	for(i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(i > MAX_OPLAYERS)
			{
				MAX_OPLAYERS = i;
			}
		}
	}
}

CMD:maxplayersperip(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_MAXPLAYERSPERIP))
	{
		if(!CMD_Auth(playerid)) return 1;
		new amount;
		if(sscanf(params, "i", amount))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /maxplayersperip [AMOUNT]");
		}
		if(amount < 1 || amount > 10)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Sorry bud, min is 1 and max is 10!");
		}
		MaxPlayersPerIP = amount;
		new string[128];
		format(string, sizeof(string), "[INFO]: Updated max players per IP to %d", MaxPlayersPerIP);
		SendClientMessage(playerid, COLOR_GREEN, string);
		SendAdminMessage(ACMD_MAXPLAYERSPERIP, string);
	}
	return 1;
}


