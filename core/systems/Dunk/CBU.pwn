#include <YSI\y_hooks>

new bool:CLAN_BA_USED[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
	CLAN_BA_USED[playerid]=false;
	return 1;
}
hook OnPlayerDeath(playerid)
{
	CLAN_BA_USED[playerid]=false;
	return 1;
}

new cbu_msg[128];

//============[BACKUP SYSTEM]============
CMD:abk(playerid, params[])
{
	if(FoCo_Player[playerid][clan] == -1)
	{
	   SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to be in a clan to use this command.");
	   return 1;
	}
	new targetid, Float:cpos[3];

	if(sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, COLOR_GREY, "/a(ccept)b(ac)k(up) [PlayerID/Name]");

	if(!IsPlayerConnected(targetid))
	    return SendClientMessage(playerid, -1, "Not connected.");
	if(FoCo_Team[targetid] != FoCo_Team[playerid])
	{
	    return SendClientMessage(playerid, COLOR_OOC, "[ERROR]: Player is not in your team.");
	}
	if(GetPVarInt(targetid, "PlayerStatus") != PLAYERSTATUS_NORMAL)
	    return SendClientMessage(playerid, COLOR_OOC, "[ERROR]: You can not use this command now.");
	if(CLAN_BA_USED[targetid] == false)
	{
		return SendClientMessage(playerid, COLOR_OOC, "[ERROR]: Player has not requested back-up. He is good on his own.");
	}
	else if(CLAN_BA_USED[targetid] == true)
	{
        DisablePlayerCheckpoint(playerid);
		format(cbu_msg, sizeof(cbu_msg), "You have accepted a backup call from %s(%d), a marker has been set to their location.", PlayerName(targetid), targetid);
		SendClientMessage(playerid, COLOR_OOC, cbu_msg);
		format(cbu_msg, sizeof(cbu_msg), "%s(%d) has accepted your backup request.", PlayerName(playerid), playerid);
		SendClientMessage(targetid, COLOR_OOC, cbu_msg);
		SendClientMessage(playerid, COLOR_LIGHTORANGE, "[NOTICE]: Use /clearcheckpoint to remove check-point.");
		GetPlayerPos(targetid, cpos[0], cpos[1], cpos[2]);
		SetPlayerCheckpoint(playerid, cpos[0], cpos[1], cpos[2], 5.0);
	}
	return 1;
}

CMD:cr(playerid, params[])
{
	if(FoCo_Player[playerid][clan] == -1)
	{
	   SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to be in a clan to use this command.");
	   return 1;
	}
	SendClientMessage(playerid, COLOR_OOC, "You are no longer responding.");
    DisablePlayerCheckpoint(playerid);
    return 1;
}

CMD:cbk(playerid, params[])
{
	if(FoCo_Player[playerid][clan] == -1)
	{
	   SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to be in a clan to use this command.");
	   return 1;
	}
	if(CLAN_BA_USED[playerid] == false)
	{
	    format(cbu_msg, sizeof(cbu_msg), "You have not requested backup.");
		SendClientMessage(playerid, COLOR_OOC, cbu_msg);
	}
	else if(CLAN_BA_USED[playerid] == true)
	{
	    format(cbu_msg, sizeof(cbu_msg), "You have canceled your backup request.");
		SendClientMessage(playerid, COLOR_OOC, cbu_msg);
		format(cbu_msg, sizeof(cbu_msg), "[CLAN]: %s has canceled their backup request.", PlayerName(playerid));
		foreach (Player, i)
		{
			if(gPlayerLogged[i] == 1)
			{
				if(FoCo_Team[i] == FoCo_Team[playerid])
				{
				   	SendClientMessage(i, COLOR_NEWOOC, cbu_msg);
				}
				else if(WatchGAdmin[i] == FoCo_Team[playerid] && FoCo_Player[i][admin] >= ACMD_WATCHTEAMCHAT)
				{
			       	SendClientMessage(i, COLOR_NEWOOC, cbu_msg);
		       	}
			}
		}
		CLAN_BA_USED[playerid] = false;
	}
	return 1;
}

CMD:bk(playerid, params[])
{
	if(FoCo_Player[playerid][clan] == -1)
	{
	   SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to be in a clan to use this command.");
	   return 1;
	}
	format(cbu_msg, sizeof(cbu_msg), "[INFO] You can also use Y to request backup.");
	SendClientMessage(playerid, COLOR_GREY, cbu_msg);
	new CLAN_P[28];
	GetPlayer2DZone(playerid, CLAN_P, sizeof(CLAN_P));
	format(cbu_msg, sizeof(cbu_msg), "[CLAN]: %s has requested backup at: %s, use /abk [playerid] to get their posistion marked on your map.", PlayerName(playerid), CLAN_P);
	foreach (Player, i)
	{
		if(gPlayerLogged[i] == 1)
		{
			if(FoCo_Team[i] == FoCo_Team[playerid])
			{
			   	SendClientMessage(i, COLOR_NEWOOC, cbu_msg);
			}
			else if(WatchGAdmin[i] == FoCo_Team[playerid] && FoCo_Player[i][admin] >= ACMD_WATCHTEAMCHAT)
			{
		       	SendClientMessage(i, COLOR_NEWOOC, cbu_msg);
	       	}
		}
	}
	CLAN_BA_USED[playerid] = true;
 	return 1;
}

CMD:clearcheckpoint(playerid, params[])
{
	DisablePlayerCheckpoint(playerid);
	return SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Checkpoint removed from map.");
}
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(FoCo_Player[playerid][clan] != -1)
	{
		if (HOLDING(KEY_YES))
		{
		    if(CLAN_BA_USED[playerid] == false)
		    {
		    	//SendClientMessage(playerid, COLOR_LIGHTORANGE, "[DEBUG]: KEY PRESSED: 'Y'");
		    	//SendClientMessage(playerid, COLOR_LIGHTORANGE, "[DEBUG]: BACKUP REQUESTED 1...");
	    		new CLAN_P[28];
		        GetPlayer2DZone(playerid, CLAN_P, sizeof(CLAN_P));
				format(cbu_msg, sizeof(cbu_msg), "[CLAN]: %s has requested backup at: %s, use /abk [playerid] to get their posistion marked on your map.", PlayerName(playerid), CLAN_P);
	    		foreach (Player, i)
				{
					if(gPlayerLogged[i] == 1)
				    {
				    	if(FoCo_Team[i] == FoCo_Team[playerid])
				        {
				        	SendClientMessage(i, COLOR_NEWOOC, cbu_msg);
			         	}
				        else if(WatchGAdmin[i] == FoCo_Team[playerid] && FoCo_Player[i][admin] >= ACMD_WATCHTEAMCHAT)
				        {
				        	SendClientMessage(i, COLOR_NEWOOC, cbu_msg);
			         	}
					}
				}
	    		SendClientMessage(playerid, COLOR_GREY, "[INFO] You can use /cbk to cancel your backup request.");
				CLAN_BA_USED[playerid] = true;
			}
		}
	}
	return 1;
}
//=================[END SYSTEM]===================
