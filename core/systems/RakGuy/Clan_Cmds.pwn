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
* Filename: clan_cmds.pwn                                                        *
* Author:   RakGuy                                                               *
*********************************************************************************/
#include <YSI\y_hooks>

new CLAN_MSG[250];

CMD:clanann(playerid, params[])
{
	if(FoCo_Player[playerid][clan] == -1)
	{
	   SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to be in a clan to use this command.");
	   return 1;
	}
	if(FoCo_Player[playerid][clan] == -1 || FoCo_Player[playerid][clanrank] != 1)
	{
	   SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're not the leader of a clan");
	   return 1;
	}
	else
	{
	    if(sscanf(params, "s[200]", CLAN_MSG))
	    {
	        SendClientMessage(playerid, -1, "[USAGE:] /cann [Message]");
	    }
	    else
	    {
			format(CLAN_MSG, sizeof(CLAN_MSG), "Clan Announcement by %s:  %s",PlayerName(playerid), CLAN_MSG);
    		foreach (Player, i)
			{
				if(gPlayerLogged[i] == 1)
			    {
			    	if(FoCo_Team[i] == FoCo_Team[playerid])
			        {
			        	SendClientMessage(i, COLOR_NEWOOC, CLAN_MSG);
		         	}
			        else if(WatchGAdmin[i] == FoCo_Team[playerid] && FoCo_Player[i][admin] >= ACMD_WATCHTEAMCHAT)
			        {
			        	SendClientMessage(i, COLOR_NEWOOC, CLAN_MSG);
		         	}
				}
			}
		}
		return 1;
	}
}

/*CMD:cbu(playerid, params[])
{
	if(FoCo_Player[playerid][clan] == -1)
	{
	   SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to be in a clan to use this command.");
	   return 1;
	}
	else
	{
	    new CLAN_B_MSG[50];
	    if(sscanf(params, "S(No specified reason)[30]", CLAN_B_MSG))
	    {
	        SendClientMessage(playerid, -1, "[USAGE:] /cann [Message]");
	    }
	    else
	    {
	        if(CLAN_BA_USED[playerid]==false)
	        {
		        new CLAN_P[28];
		        GetPlayer2DZone(playerid, CLAN_P, sizeof(CLAN_P));
				format(CLAN_MSG, sizeof(CLAN_MSG), "[Clan Backup:]%s(%i) has requested backup at %s, Reason: %s.",PlayerName(playerid), playerid,CLAN_P, CLAN_B_MSG);
	    		foreach (Player, i)
				{
					if(gPlayerLogged[i] == 1)
				    {
				    	if(FoCo_Team[i] == FoCo_Team[playerid])
				        {
				        	SendClientMessage(i, COLOR_NEWOOC, CLAN_MSG);
			         	}
				        else if(WatchGAdmin[i] == FoCo_Team[playerid] && FoCo_Player[i][admin] >= ACMD_WATCHTEAMCHAT)
				        {
				        	SendClientMessage(i, COLOR_NEWOOC, CLAN_MSG);
			         	}
					}
				}
				CLAN_BA_USED[playerid]=true;
			}
			else
			{
			    SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE:] Backup on the way, please wait.");
			}
		}
		return 1;
	}
}*/
