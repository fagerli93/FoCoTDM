#include <YSI\y_hooks>

enum PunishmentDetails
{
	pd_pdid,
	pd_udbid,
	pd_aname[30],
	pd_type,
	pd_reason[150],
	pd_ptime,
	pd_date[20]
}

new LoadedJRecord[MAX_PLAYERS][5][PunishmentDetails];
new LoadedKRecord[MAX_PLAYERS][5][PunishmentDetails];
new LoadedBRecord[MAX_PLAYERS][5][PunishmentDetails];
new LoadedWRecord[MAX_PLAYERS][5][PunishmentDetails];
new pdmsg[256];
new pd_dmsg[1280];

enum
{
	BANS = 0,
	KICKS = 1, 
	JAILS = 2,
	WARNS = 3
};
new pCurrentRecordWatch[MAX_PLAYERS];

stock ClearARecord(playerid)
{
	for(new i = 0; i < 5; i++)
	{
		LoadedJRecord[playerid][i][pd_pdid] = -1;
		LoadedKRecord[playerid][i][pd_pdid] = -1;
		LoadedBRecord[playerid][i][pd_pdid] = -1;
		LoadedWRecord[playerid][i][pd_pdid] = -1;
	}
}

hook OnGameModeInit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		ClearARecord(i);
	}
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	ClearARecord(playerid);
}

hook OnPlayerConnect(playerid)
{
	ClearARecord(playerid);
}

timer LoadAdminRecord[5000](playerid)
{
	if(playerid != INVALID_PLAYER_ID)
	{
		if(IsPlayerConnected(playerid)) //Make sure he didn't get kicked.
		{
			format(pdmsg, sizeof(pdmsg), "SELECT * FROM `FoCo_AdminRecords` WHERE `user` = '%d' AND `actiontype` = '1' ORDER BY `ID` DESC LIMIT 5;", FoCo_Player[playerid][id]);
			mysql_query(pdmsg, MYSQLTHREAD_JAILREC, playerid, con);
			format(pdmsg, sizeof(pdmsg), "SELECT * FROM `FoCo_AdminRecords` WHERE `user` = '%d' AND `actiontype` = '2' ORDER BY `ID` DESC LIMIT 5;", FoCo_Player[playerid][id]);
			mysql_query(pdmsg, MYSQLTHREAD_KICKREC, playerid, con);
			format(pdmsg, sizeof(pdmsg), "SELECT * FROM `FoCo_AdminRecords` WHERE `user` = '%d' AND `actiontype` = '3' ORDER BY `ID` DESC LIMIT 5;", FoCo_Player[playerid][id]);
			mysql_query(pdmsg, MYSQLTHREAD_BANREC, playerid, con);
			format(pdmsg, sizeof(pdmsg), "SELECT * FROM `FoCo_AdminRecords` WHERE `user` = '%d' AND `actiontype` = '5' ORDER BY `ID` DESC LIMIT 5;", FoCo_Player[playerid][id]);
			mysql_query(pdmsg, MYSQLTHREAD_WARNREC, playerid, con);
		}
	}
}

forward LoadRecord_OnQueryFinish(query[], resultid, extraid, connectionHandle);
public LoadRecord_OnQueryFinish(query[], resultid, extraid, connectionHandle)
{
	new resultline[300], playerid = extraid, rowc = 0;
	switch(resultid)
	{
		case MYSQLTHREAD_JAILREC:
		{
			mysql_store_result();
			if(mysql_num_rows() > 0)
			{
				while(mysql_fetch_row_format(resultline))
				{
				    //print(resultline);
					if(!sscanf(resultline, "e<p<|>dds[30]ds[150]ds[20]>", LoadedJRecord[playerid][rowc]))
						rowc++;
				}
			}
			mysql_free_result();
		}
		case MYSQLTHREAD_KICKREC:
		{
			mysql_store_result();
			if(mysql_num_rows() > 0)
			{
				while(mysql_fetch_row_format(resultline))
				{
				    //print(resultline);
					if(!sscanf(resultline, "e<p<|>dds[30]ds[150]ds[20]>", LoadedKRecord[playerid][rowc]))
						rowc++;
				}
			}
			mysql_free_result();
		}
		case MYSQLTHREAD_BANREC:
		{
			mysql_store_result();
			if(mysql_num_rows() > 0)
			{
				while(mysql_fetch_row_format(resultline))
				{
				    //print(resultline);
					if(!sscanf(resultline, "e<p<|>dds[30]ds[150]ds[20]>", LoadedBRecord[playerid][rowc]))
						rowc++;
				}
			}
			mysql_free_result();
		}
		case MYSQLTHREAD_WARNREC:
		{
			mysql_store_result();
			if(mysql_num_rows() > 0)
			{
				while(mysql_fetch_row_format(resultline))
				{
				    //print(resultline);
					if(!sscanf(resultline, "e<p<|>dds[30]ds[150]ds[20]>", LoadedWRecord[playerid][rowc]))
						rowc++;
				}
			}
			mysql_free_result();
		}
	}
}
forward ARecord_OnPlayerLogin(playerid);
public ARecord_OnPlayerLogin(playerid)
{
	defer LoadAdminRecord(playerid); //Timer of 15 seconds to avoid checking bitches with Connection Spam or shit..
	return 1;
}

CMD:jailreason(playerid, params[])
{
	if(FoCo_Player[playerid][jailed] > 0)
	{
		format(pdmsg, sizeof(pdmsg), "[NOTICE]: You were last jailed by %s for %s on %s. Time Left in Jail: %i", LoadedJRecord[playerid][0][pd_aname], LoadedJRecord[playerid][0][pd_reason], LoadedJRecord[playerid][0][pd_date], FoCo_Player[playerid][jailed]);
		SendClientMessage(playerid, COLOR_NOTICE, pdmsg);
	}
	else
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You must be in A-Jail to use this command");
	}
	return 1;
}

stock ShowPlayerARecord(toplayerid, ofplayerid, actiontype)
{
	if(toplayerid == INVALID_PLAYER_ID || ofplayerid == INVALID_PLAYER_ID)
		return 1;
	if(!IsPlayerConnected(toplayerid) || !IsPlayerConnected(ofplayerid))
		return 1;
	if(actiontype < 0 || actiontype > 3)
		return 1;
	format(pd_dmsg, sizeof(pd_dmsg), "Punishment-ID\tPunished-By\tDate\tReason\n");
	switch(actiontype)
	{
		case BANS:
		{
			for(new i = 0; i < 5; i++)
			{
				if(LoadedBRecord[ofplayerid][i][pd_pdid] != -1)
					format(pd_dmsg, sizeof(pd_dmsg), "%s%i\t%s\t%s\t%s\n", pd_dmsg, LoadedBRecord[ofplayerid][i][pd_pdid], LoadedBRecord[ofplayerid][i][pd_aname], LoadedBRecord[ofplayerid][i][pd_date], LoadedBRecord[ofplayerid][i][pd_reason]);
				else
					break;
			}
		}
		case KICKS:
		{
			for(new i = 0; i < 5; i++)
			{
				if(LoadedKRecord[ofplayerid][i][pd_pdid] != -1)
					format(pd_dmsg, sizeof(pd_dmsg), "%s%i\t%s\t%s\t%s\n", pd_dmsg, LoadedKRecord[ofplayerid][i][pd_pdid], LoadedKRecord[ofplayerid][i][pd_aname], LoadedKRecord[ofplayerid][i][pd_date], LoadedKRecord[ofplayerid][i][pd_reason]);
				else
					break;
			}
		}
		case JAILS:
		{
			for(new i = 0; i < 5; i++)
			{
				if(LoadedJRecord[ofplayerid][i][pd_pdid] != -1)
					format(pd_dmsg, sizeof(pd_dmsg), "%s%i\t%s\t%s\t%s\n", pd_dmsg, LoadedJRecord[ofplayerid][i][pd_pdid], LoadedJRecord[ofplayerid][i][pd_aname], LoadedJRecord[ofplayerid][i][pd_date], LoadedJRecord[ofplayerid][i][pd_reason]);
				else
					break;
			}
		}
		case WARNS:
		{
			for(new i = 0; i < 5; i++)
			{
				if(LoadedWRecord[ofplayerid][i][pd_pdid] != -1)
					format(pd_dmsg, sizeof(pd_dmsg), "%s%i\t%s\t%s\t%s\n", pd_dmsg, LoadedWRecord[ofplayerid][i][pd_pdid], LoadedWRecord[ofplayerid][i][pd_aname], LoadedWRecord[ofplayerid][i][pd_date], LoadedWRecord[ofplayerid][i][pd_reason]);
				else
					break;
			}
		}
		default:
			return 1;
	}
	ShowPlayerDialog(toplayerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_TABLIST_HEADERS, "Admin Record",  pd_dmsg, "Done!", "");
	return 1;
}

CMD:showrecord(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new targetid, option[6];
		if(sscanf(params, "us[6]", targetid, option))
		{
		    if(!sscanf(params, "u", targetid))
		    {
				pCurrentRecordWatch[playerid] = targetid;
				return ShowPlayerDialog(playerid, DIALOG_AREC_OPTIONS, DIALOG_STYLE_LIST, "Select A-Record","BANS\nKICKS\nJAILS\nWARNS", "Select", "CANCEL");
			}
			else
			    return SendClientMessage(playerid, COLOR_WARNING, "[HINT]: You can use /showrecord [TargetID/Name] [Bans/Kicks/Jails/Warns].");
		}
		if(targetid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerName/ID.");
		if(!IsPlayerConnected(targetid))
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerName/ID is not connected.");
		if(!strcmp(option, "bans", true, 3))
		{
			ShowPlayerARecord(playerid, targetid, BANS);
		}
		else if(!strcmp(option, "kicks", true, 3))
		{
			ShowPlayerARecord(playerid, targetid, KICKS);
		}
		else if(!strcmp(option, "jails", true, 3))
		{
			ShowPlayerARecord(playerid, targetid, JAILS);
		}
		else if(!strcmp(option, "warns", true, 3))
		{
			ShowPlayerARecord(playerid, targetid, WARNS);
		}
		else
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Error retrieving Admin-Record of Player.");
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    print("ODR_RakGuy_LoadAR");
	if(dialogid == DIALOG_AREC_OPTIONS)
	{
		if(!response)
			return SendClientMessage(playerid, COLOR_WARNING, "[HINT]: You can also use /showrecord [TargetID/Name] [Bans/Kicks/Jails/Warns].");
		else
			return ShowPlayerARecord(playerid, pCurrentRecordWatch[playerid], listitem);
	}
	return 0;
}
/*enum PunishmentDetails
{
	pd_pdid,
	pd_udbid,
	pd_aname[30],
	pd_type,
	pd_reason[128],
	pd_ptime,
	pd_date[20]
}*/
CMD:debugrecord(playerid, params[])
{
	for(new i = 0; i<5; i++)
	{
		format(pd_dmsg, sizeof(pd_dmsg), "%i %i %s %i %s %i %s", LoadedJRecord[playerid][i][pd_pdid], LoadedJRecord[playerid][i][pd_udbid], LoadedJRecord[playerid][i][pd_aname], LoadedJRecord[playerid][i][pd_type],
		LoadedJRecord[playerid][i][pd_reason], LoadedJRecord[playerid][i][pd_date]);
		SendClientMessage(playerid, -1, pd_dmsg);
		format(pd_dmsg, sizeof(pd_dmsg), "%i %i %s %i %s %i %s", LoadedKRecord[playerid][i][pd_pdid], LoadedKRecord[playerid][i][pd_udbid], LoadedKRecord[playerid][i][pd_aname], LoadedKRecord[playerid][i][pd_type],
		LoadedKRecord[playerid][i][pd_reason], LoadedKRecord[playerid][i][pd_date]);
		SendClientMessage(playerid, -1, pd_dmsg);
		format(pd_dmsg, sizeof(pd_dmsg), "%i %i %s %i %s %i %s", LoadedBRecord[playerid][i][pd_pdid], LoadedBRecord[playerid][i][pd_udbid], LoadedBRecord[playerid][i][pd_aname], LoadedBRecord[playerid][i][pd_type],
		LoadedBRecord[playerid][i][pd_reason], LoadedBRecord[playerid][i][pd_date]);
		SendClientMessage(playerid, -1, pd_dmsg);
		format(pd_dmsg, sizeof(pd_dmsg), "%i %i %s %i %s %i %s", LoadedWRecord[playerid][i][pd_pdid], LoadedWRecord[playerid][i][pd_udbid], LoadedWRecord[playerid][i][pd_aname], LoadedWRecord[playerid][i][pd_type],
		LoadedWRecord[playerid][i][pd_reason], LoadedWRecord[playerid][i][pd_date]);
		SendClientMessage(playerid, -1, pd_dmsg);
	}
	return 1;
}
