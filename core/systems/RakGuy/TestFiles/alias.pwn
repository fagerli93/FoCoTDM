#include <YSI\y_hooks>

#define ALIAS_CHECK_TIME 30

new AliasMSG[2490];
new LAST_ALIAS_CHECK;

CMD:alias(playerid, params[])
{
	if(IsAdmin(playerid, 2))
	{
	    if(LAST_ALIAS_CHECK != -1)
	    {
			new aliasmsg[200];
			if((gettime() - LAST_ALIAS_CHECK) > ALIAS_CHECK_TIME)
			{
				new targetid, playerip[16];
				if(sscanf(params, "u", targetid))
				{
					return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /alias [UserName/UserID]");
				}
				if(targetid == INVALID_PLAYER_ID)
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerID.");
				if(!IsPlayerConnected(targetid))
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerID is not connected");
				GetPlayerIp(targetid, playerip, sizeof(playerip));
				format(aliasmsg, sizeof(aliasmsg), "SELECT DISTINCT username, banned, jail FROM FoCo_Players WHERE ID IN (SELECT DISTINCT userid FROM FoCo_Connections WHERE ip = '%s');", playerip);
				mysql_query(aliasmsg, MYSQLTHREAD_GRABALIAS, targetid, con);
				LAST_ALIAS_CHECK = -1;
				format(aliasmsg, sizeof(aliasmsg), "AdmCmd(2): %s %s is checking Aliases of %s(%i).", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
				SendAdminMessage(2, aliasmsg);
			}
			else
			{
				format(aliasmsg, sizeof(aliasmsg), "You must wait %i seconds before using this command again.", ALIAS_CHECK_TIME - (gettime() - LAST_ALIAS_CHECK));
				SendClientMessage(playerid, COLOR_WARNING, aliasmsg);
			}
		}
		else
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please wait till last check is completed");
	}	
	return 1;
}

CMD:alias2(playerid, params[])
{
	if(IsAdmin(playerid, 2))
	{
		if(LAST_ALIAS_CHECK != -1)
	    {
			new aliasmsg[256];
			if((gettime() - LAST_ALIAS_CHECK) > ALIAS_CHECK_TIME)
			{
				new targetid, playerip[16];
				if(sscanf(params, "u", targetid))
				{
					return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /alias2 [UserName/UserID]");
				}
				if(targetid == INVALID_PLAYER_ID)
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerID.");
				if(!IsPlayerConnected(targetid))
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerID is not connected");
				GetPlayerIp(targetid, playerip, sizeof(playerip));
				format(aliasmsg, sizeof(aliasmsg), "SELECT DISTINCT username, banned, jail FROM FoCo_Players WHERE ID IN (SELECT DISTINCT userid FROM FoCo_Connections WHERE ip IN(SELECT * FROM(SELECT DISTINCT ip FROM FoCo_Connections WHERE userid = '%i' ORDER BY ID DESC LIMIT 50)AS t));", FoCo_Player[targetid][id]);
				mysql_query(aliasmsg, MYSQLTHREAD_GRABALIAS, targetid, con);
				LAST_ALIAS_CHECK = -1;
				format(aliasmsg, sizeof(aliasmsg), "AdmCmd(2): %s %s is checking Aliases(2) of %s(%i).", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
				SendAdminMessage(2, aliasmsg);
			}
			else
			{
				format(aliasmsg, sizeof(aliasmsg), "You must wait %i seconds before using this command again.", ALIAS_CHECK_TIME - (gettime() - LAST_ALIAS_CHECK));
				SendClientMessage(playerid, COLOR_WARNING, aliasmsg);
			}
		}
		else
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please wait till last check is completed");
	}		
	return 1;
}

CMD:alias3(playerid, params[])
{
	if(IsAdmin(playerid, 2))
	{
	    if(LAST_ALIAS_CHECK != -1)
	    {
			new aliasmsg[200];
			if((gettime() - LAST_ALIAS_CHECK) > ALIAS_CHECK_TIME)
			{
				new targetid, playerip[16];
				if(sscanf(params, "u", targetid))
				{
					return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /alias3 [UserName/UserID]");
				}
				if(targetid == INVALID_PLAYER_ID)
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerID.");
				if(!IsPlayerConnected(targetid))
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerID is not connected");
				GetPlayerIp(targetid, playerip, sizeof(playerip));
				format(aliasmsg, sizeof(aliasmsg), "SELECT DISTINCT username, banned, jail FROM FoCo_Players WHERE ID IN (SELECT DISTINCT userid FROM FoCo_Connections WHERE serial = '%s');", GetGPCI(targetid));
				mysql_query(aliasmsg, MYSQLTHREAD_GRABALIAS, targetid, con);
				LAST_ALIAS_CHECK = -1;
				format(aliasmsg, sizeof(aliasmsg), "AdmCmd(2): %s %s is checking Aliases(3) of %s(%i).", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
				SendAdminMessage(2, aliasmsg);
			}
			else
			{
				format(aliasmsg, sizeof(aliasmsg), "You must wait %i seconds before using this command again.", ALIAS_CHECK_TIME - (gettime() - LAST_ALIAS_CHECK));
				SendClientMessage(playerid, COLOR_WARNING, aliasmsg);
			}
		}
		else
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please wait till last check is completed");
	}
	return 1;
}

CMD:alias4(playerid, params[])
{
	if(IsAdmin(playerid, 2))
	{
		if(LAST_ALIAS_CHECK != -1)
	    {
			new aliasmsg[256];
			if((gettime() - LAST_ALIAS_CHECK) > ALIAS_CHECK_TIME)
			{
				new targetid;
				if(sscanf(params, "u", targetid))
				{
					return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /alias4 [UserName/UserID]");
				}
				if(targetid == INVALID_PLAYER_ID)
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerID.");
				if(!IsPlayerConnected(targetid))
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerID is not connected");
				//format(aliasmsg, sizeof(aliasmsg), "SELECT DISTINCT username, banned, jail FROM FoCo_Players WHERE ID IN (SELECT DISTINCT userid FROM FoCo_Connections WHERE serial IN(SELECT * FROM(SELECT DISTINCT serial FROM FoCo_Connections WHERE (userid = '%i' AND serial <> 'NO_SERIAL') ORDER BY ID DESC LIMIT 50)AS t));", FoCo_Player[targetid][id]);
				format(aliasmsg, sizeof(aliasmsg), "SELECT DISTINCT username, banned, jail FROM FoCo_Players WHERE ID IN (SELECT DISTINCT UserID FROM FoCo_Connections WHERE serial IN (SELECT DISTINCT serial FROM FoCo_Connections WHERE UserID=(SELECT ID FROM FoCo_Players WHERE username='%s') AND serial NOT LIKE 'NO_SERIAL' ORDER BY ID DESC));", PlayerName(targetid));
				mysql_query(aliasmsg, MYSQLTHREAD_GRABALIAS, targetid, con);
				LAST_ALIAS_CHECK = -1;
				format(aliasmsg, sizeof(aliasmsg), "AdmCmd(2): %s %s is checking Aliases(4) of %s(%i).", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
				SendAdminMessage(2, aliasmsg);
			}
			else
			{
				format(aliasmsg, sizeof(aliasmsg), "You must wait %i seconds before using this command again.", ALIAS_CHECK_TIME - (gettime() - LAST_ALIAS_CHECK));
				SendClientMessage(playerid, COLOR_WARNING, aliasmsg);
			}
		}
		else
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please wait till last check is completed");
	}
	return 1;
}

forward LoadAlias_OnQueryFinish(query[], resultid, extraid, connectionHandle);
public LoadAlias_OnQueryFinish(query[], resultid, extraid, connectionHandle)
{
	new resultline[150], playerid = extraid, rowc = 0;
	switch(resultid)
	{
		case MYSQLTHREAD_GRABALIAS:
		{
			mysql_store_result();
			AliasMSG = "";
			if(mysql_num_rows() > 0)
			{
				format(AliasMSG, sizeof(AliasMSG), "PlayerName\tJailed\tBanned\n");
				while(mysql_fetch_row_format(resultline))
				{
					if(rowc < 80)
					{
					    new p_Name[24], pbanned, pjailed;
						sscanf(resultline, "p<|>s[24]dd", p_Name, pbanned, pjailed);
						format(AliasMSG, sizeof(AliasMSG), "%s{0000FF}%s\t%s\t%s\n", AliasMSG, p_Name, (pjailed > 0) ? ("{ff0000}Yes") : ("{00ff00}No"), (pbanned != 0) ? ("{ff0000}Yes") : ("{00ff00}No"));
						rowc++;
					}
					else
					{
						break;
					}
				}
				if(rowc > 0)
				{
					format(resultline, sizeof(resultline), "AdmCmd(2): Alias list of %s(%i) is now gathered. Use /showalias to see list", PlayerName(playerid), playerid);
					SendAdminMessage(2, resultline);
				}
				else
				{
					format(resultline, sizeof(resultline), "AdmCmd(2): There is no Alias for %s(%i).", PlayerName(playerid), playerid);
					SendAdminMessage(2, resultline);
				}
			}
			else
			{
			    SendAdminMessage(2, "AdmCmd(2): Alias list of requested player is empty.");
			}
			LAST_ALIAS_CHECK = gettime();
			mysql_free_result();
		}
	}
}

CMD:showalias(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_TABLIST_HEADERS, "Alias List", AliasMSG, "Close", "");
		return 1;
	}
	return 1;
}
