#include <YSI\y_hooks>

new jmsg[MAX_PLAYERS][85];

forward JailEvade_OnPlayerLogin(playerid);
public JailEvade_OnPlayerLogin(playerid)
{
	new qmsg[256], playerip[16];
	GetPlayerIp(playerid, playerip, sizeof(playerip));
	format(qmsg, sizeof(qmsg), "SELECT DISTINCT username FROM FoCo_Players WHERE ID IN (SELECT DISTINCT userid FROM FoCo_Connections WHERE ip = '%s') AND jail > 0;", playerip);
	mysql_query(qmsg, MYSQLTHREAD_JAILEVADE, playerid, con);
	return 1;
}

forward CheckJailEvade_OnQueryFinish(query[], resultid, extraid, connectionHandle);
public CheckJailEvade_OnQueryFinish(query[], resultid, extraid, connectionHandle)
{
	new resultline[150], playerid = extraid, rowc = 0;
	switch(resultid)
	{
		case MYSQLTHREAD_JAILEVADE:
		{
			mysql_store_result();
			jmsg[playerid] = "";
			if(mysql_num_rows() > 0)
			{
				while(mysql_fetch_row_format(resultline))
				{
					if(rowc < 3)
					{
					    if(strcmp(PlayerName(playerid), resultline, true))
					    {
							format(jmsg[playerid], 85, "%s%s\n", jmsg[playerid], resultline);
							rowc++;
						}
					}
					else
					{
						if(strcmp(PlayerName(playerid), resultline, true))
					    {

							format(jmsg[playerid], 85, "%sMore A/Cs...", jmsg[playerid]);
							break;
						}
					}	
				}
				if(rowc > 0)
				{
					format(resultline, sizeof(resultline), "%s(%i) seems to be jail-evading.", PlayerName(playerid), playerid);
					AntiCheatMessage(resultline);
				}
			}
			mysql_free_result();
		}
	}
}

CMD:jailevade(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new targetid;
		if(sscanf(params, "u", targetid))
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /jailevade [PlayerName/PlayerID]");
		if(targetid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerID/PlayerName");
		if(!IsPlayerConnected(targetid))
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerID is not connected");
		else
			ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, "JailEvadeind A/Cs", jmsg[targetid], "Close", "");
	}
	return 1;
}
