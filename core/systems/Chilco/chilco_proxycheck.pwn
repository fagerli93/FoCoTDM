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
* Filename: chilco_proxycheck.pwn                                                *
* Author: Chilco                                                                 *
*********************************************************************************/
#include <YSI\y_hooks>
#include <a_http>

new PlayerSession[MAX_PLAYERS];

forward OnLookupResponse(sessionid, response, data[]);
forward OnLookupComplete(playerid);

CMD:proxycheck(playerid, params[])
{
    if(IsAdmin(playerid,1))
	{
	    new user;
		if(sscanf(params, "d", user))
		{
	 		SendClientMessage(playerid, 0x999999FF, "USAGE: /proxycheck [playerID] (Hosting Provider indicates a proxy)");
	 		return 1;
		}

		if(!IsPlayerConnected(user)) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This player is not connected.");
		if(user == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Player ID.");

		new ip[16], lQuery[60];
		GetPlayerIp(user, ip, sizeof(ip));
		format(lQuery, sizeof(lQuery), "lookupffs.com/api.php?ip=%s", ip);

		SetPVarInt(playerid, "ProxyCheckID", user);
		static
		SessionIndex;
		SessionIndex++;
		PlayerSession[playerid] = SessionIndex;


		new msgstring[150], targetName[MAX_PLAYER_NAME];
		GetPlayerName(user, targetName,sizeof(targetName));
		format(msgstring, sizeof(msgstring), "{FFFF00}AdmCmd(1): %s %s is checking if %s(%d) is using a proxy...",GetPlayerStatus(playerid), PlayerName(playerid), targetName, user);
        SendAdminMessage(1, msgstring);

		HTTP(SessionIndex, HTTP_GET, lQuery, "", "OnLookupResponse");
	}
	return 1;
}

stock GetPlayerFromSession(sessionid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	if(IsPlayerConnected(i) && PlayerSession[i] == sessionid)
	return i;
	}

	return -1;
}

public OnLookupResponse(sessionid, response, data[])
{
	if(response==200)
	{
		new proxy;
	    proxy = strval(data[strfind(data, "<proxy>", true) + 7]);

	    new playerid;
		playerid = GetPlayerFromSession(sessionid);

		new str[120], pName[MAX_PLAYER_NAME], ISPtype[50];
		GetPlayerName(GetPVarInt(playerid, "ProxyCheckID"), pName, sizeof(pName));

		if(proxy == 0) format(ISPtype, sizeof(ISPtype), "{FFFFFF}Home Internet - (Negative Result)");
		if(proxy == 1) format(ISPtype, sizeof(ISPtype), "{FF0000}Hosting Provider - (Positive Result)");
		format(str,sizeof(str),"{FFFF00}[Proxy Check]: %s's ISP Type: %s", pName, ISPtype);

		SendAdminMessage(1, str);

	    CallLocalFunction("OnLookupComplete", "i", playerid);
	}
	else
	{
	    SendAdminMessage(1, "[GUARDIAN:] ProxyCheck server is currently down. Please contact devs.");
	}
	return 1;
}
