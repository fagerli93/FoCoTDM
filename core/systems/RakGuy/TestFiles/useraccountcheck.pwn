#include <YSI\y_hooks>

new PlayerNameRequest[24]; 
new LastCheckPending;

CMD:checkaccountstatus(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		if(gettime() - LastCheckPending < 10 || LastCheckPending == -1)
			return SendClientMessage(playerid, COLOR_WARNING,  "[ERROR]: Do not spam!! Wait for last request to be completed.");
		new pName[24];
		if(sscanf(params, "s[24]", pName))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /checkaccountstatus [UserName]");
		}
		mysql_real_escape_string(pName, pName);
		new querymsg[500];
		format(querymsg, sizeof(querymsg), "SELECT PInfo.jail, PInfo.banned, Connection.ip, Connection.timestamp FROM FoCo_Players PInfo INNER JOIN(SELECT FoCo_Connections.ip, FoCo_Connections.timestamp FROM FoCo_Connections WHERE FoCo_Connections.userid =(SELECT FoCo_Players.ID FROM FoCo_Players WHERE username = '%s' LIMIT 1) ORDER BY ID DESC LIMIT 1)Connection WHERE PInfo.ID =(SELECT FoCo_Players.ID FROM FoCo_Players WHERE username = '%s' LIMIT 1);", pName, pName);
		mysql_query(querymsg, MYSQLTHREAD_USERINFO, playerid, con);
		format(querymsg, 200, "AdmCmd(1): %s %s is checking account status of %s.", GetPlayerStatus(playerid), PlayerName(playerid), pName);
		SendAdminMessage(1, querymsg);
		PlayerNameRequest = pName;
		LastCheckPending = -1;
	}
	return 1;
}

CMD:cas(playerid, params[])
{
	cmd_checkaccountstatus(playerid, params);
	return 1;
}

forward LoadUACC_OnQueryFinish(query[], resultid, extraid, connectionHandle);
public LoadUACC_OnQueryFinish(query[], resultid, extraid, connectionHandle)
{
	new resultline[150];
	switch(resultid)
	{
		case MYSQLTHREAD_USERINFO:
		{
			mysql_store_result();
			if(mysql_num_rows() > 0)
			{
				new timestamp[20], isjailed, isbanned, lastip[16];
				mysql_fetch_row_format(resultline);
				sscanf(resultline, "p<|>iis[16]s[20]", isjailed, isbanned, lastip, timestamp);
				format(resultline, sizeof(resultline), "AdmCmd(1): %s is currently %s and", PlayerNameRequest, (isbanned == 0) ? ("not banned") : ("banned"));
				if(isjailed > 0)
					format(resultline, sizeof(resultline), "%s is in jail for %i second", resultline, isjailed);
				else
					format(resultline, sizeof(resultline), "%s is not in jail", resultline, isjailed);
				format(resultline, sizeof(resultline), "%s and was last seen on %s with %s.", resultline, timestamp, lastip);
				SendAdminMessage(1, resultline);
			}
			else
			{
				format(resultline, sizeof(resultline), "AdmCmd(1): There is no account in database named %s.", PlayerNameRequest);
				SendAdminMessage(1, resultline);
			}
			LastCheckPending = gettime();
			mysql_free_result();
		}
	}
	return 1;
}
