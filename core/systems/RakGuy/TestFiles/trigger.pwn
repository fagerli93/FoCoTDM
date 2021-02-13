#include <YSI\y_hooks>

#define TRIGGER_ADMIN 4

new FirePressed[MAX_PLAYERS];
new Trigger[128];
new CurrTBStrike[MAX_PLAYERS];
new TotalTBStrike[MAX_PLAYERS];
new CurrSTBStrike[MAX_PLAYERS];
new TotalSTBStrike[MAX_PLAYERS];
new WatchTriggerBot[MAX_PLAYERS];
new tbmsg[2400];

stock TB_IsPlayerAiming(playerid)
{
	if(GetPlayerCameraMode(playerid) == 7 || GetPlayerCameraMode(playerid) == 8 || GetPlayerCameraMode(playerid) == 46 || GetPlayerCameraMode(playerid) == 51 || GetPlayerCameraMode(playerid) == 53)
		return 1;
	return 0;
}

stock SendAdminsOnlyMessage(minrank, msg[])
{
	foreach (Player, i)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "Not_Authenticated") == 1) {
				continue;
			}
			if(FoCo_Player[i][admin] >= minrank)
			{
				SendClientMessage(i, COLOR_YELLOW, msg);
			}
		}
	}
	return 1;
}

stock TriggerBotLog(playerid, msg[])
{
	new entry[256];
    format(entry, sizeof(entry), "Date %s:%i| %s\r\n", TimeStamp(), gettime(), msg);
    new FileName[128];
    format(FileName, sizeof(FileName), "FoCo_Scriptfiles/Logs/Trigger_Bot/%s.txt", PlayerName(playerid));
    new File:hFile;
    hFile = fopen(FileName, io_append);
    fwrite(hFile, entry);
    fclose(hFile);
	return 1;
}
			//AntiCheatMessage(Trigger);			//AntiCheatMessage(Trigger);
hook OnPlayerUpdate(playerid)
{	
	if(TB_IsPlayerAiming(playerid))
	{
	    if(NetStats_GetConnectedTime(playerid) - LastCTime[playerid] > 1000)
	    {
			new keys, ud, lr;
			GetPlayerKeys(playerid, keys, ud, lr);
			if(keys & KEY_FIRE && !FirePressed[playerid])
			{
			    if(WatchTriggerBot[playerid] != -1)
			    {
			        format(tbmsg, sizeof(tbmsg), "~b~%s(%i) ~g~pressed ~r~fire ~g~key.", PlayerName(playerid), playerid);
					if(AdminLvl(WatchTriggerBot[playerid]) >= 4)
					{
						GameTextForPlayer(WatchTriggerBot[playerid], tbmsg, 1000, 4);
					}
			    }
				FirePressed[playerid] = NetStats_GetConnectedTime(playerid);
			}
			else if(!(keys & KEY_FIRE) && FirePressed[playerid])
			{
				if(NetStats_GetConnectedTime(playerid)-FirePressed[playerid] <= 16)
				{
				    CurrTBStrike[playerid]++;
					format(Trigger, sizeof(Trigger), "%s has been striked for trigger-bot(Time: %i).", PlayerName(playerid), NetStats_GetConnectedTime(playerid)-FirePressed[playerid]);
	                TriggerBotLog(playerid, Trigger);
				}

				else if(NetStats_GetConnectedTime(playerid)-FirePressed[playerid] <= 45)
				{
				    CurrSTBStrike[playerid]++;
	   				format(Trigger, sizeof(Trigger), "%s has been striked for advanced-trigger-bot(Time: %i).", PlayerName(playerid), NetStats_GetConnectedTime(playerid)-FirePressed[playerid]);
	                TriggerBotLog(playerid, Trigger);
				}
    			if(WatchTriggerBot[playerid] != -1)
			    {
			        format(tbmsg, sizeof(tbmsg), "~b~%s(%i) ~g~released ~r~fire ~g~key after ~r~%i~w~ms.", PlayerName(playerid), playerid, NetStats_GetConnectedTime(playerid)-FirePressed[playerid]);
					if(AdminLvl(WatchTriggerBot[playerid]) >= TRIGGER_ADMIN)
					{
						GameTextForPlayer(WatchTriggerBot[playerid], tbmsg, 1000, 4);
					}
				}
				FirePressed[playerid] = 0;
			}
		}
	}
	else if(CurrTBStrike[playerid] > 3)
	{
	    TotalTBStrike[playerid]++;
		format(Trigger, sizeof(Trigger), "%s is possibly using normal trigger-bot(Strikes: %i)(Warnings: %i).", PlayerName(playerid), TotalTBStrike[playerid], CurrTBStrike[playerid]);
	    if(TotalTBStrike[playerid] % 5 == 0)
	    {
			SendAdminsOnlyMessage(TRIGGER_ADMIN, Trigger);
			SendAdminsOnlyMessage(TRIGGER_ADMIN, "[NOTICE]: Kindly note down the name and contact Lead for more info.");
		}
		
		TriggerBotLog(playerid, Trigger);
	    CurrTBStrike[playerid] = 0;
	}
	else if(CurrSTBStrike[playerid] > 3)
	{
	    TotalSTBStrike[playerid]++;
		format(Trigger, sizeof(Trigger), "%s is possibly using advanced trigger-bot(Strikes: %i)(Warnings: %i).", PlayerName(playerid), TotalSTBStrike[playerid], CurrSTBStrike[playerid]);
	    if(TotalSTBStrike[playerid] % 5 == 0)
	    {
			SendAdminsOnlyMessage(TRIGGER_ADMIN, Trigger);
			SendAdminsOnlyMessage(TRIGGER_ADMIN, "[NOTICE]: Kindly note down the name and contact Lead for more info.");
		}
		TriggerBotLog(playerid, Trigger);
	    CurrSTBStrike[playerid] = 0;
	}
	else
	{
	    CurrTBStrike[playerid] = 0;
        CurrSTBStrike[playerid] = 0;
	}
	return 1;
}

hook OnPlayerConnect(playerid)
{
	FirePressed[playerid] = 0;
	CurrTBStrike[playerid] = 0;
	CurrSTBStrike[playerid] = 0;
	TotalTBStrike[playerid] = 0;
	TotalSTBStrike[playerid] = 0;
	WatchTriggerBot[playerid] = -1;
	return 1;
}
hook OnPlayerDisconnect(playerid)
{
	FirePressed[playerid] = 0;
	CurrTBStrike[playerid] = 0;
	CurrSTBStrike[playerid] = 0;
	TotalTBStrike[playerid] = 0;
	TotalSTBStrike[playerid] = 0;
	WatchTriggerBot[playerid] = -1;
	return 1;
}

CMD:tblist(playerid, params[])
{
	if(IsAdmin(playerid, TRIGGER_ADMIN))
	{
		tbmsg="[ID]tName\tNormal-Strikes\tAdvanced-Strikes";
		new bool:flag;
		foreach(Player, i)
		{
		    if(TotalTBStrike[i] > 2 || TotalSTBStrike[i] > 5)
		    {
		        format(tbmsg, sizeof(tbmsg), "%s\n[%i]%s\t%i\t%i", tbmsg, i, PlayerName(i), TotalTBStrike[i], TotalSTBStrike[i]);
		        flag = true;
		    }
		}
		if(flag == true)
		{
		    ShowPlayerDialog(playerid, DIALOG_NORETURN, DIALOG_STYLE_TABLIST_HEADERS, "Trigger-Bot List", tbmsg, "Close", "");
		}
		else
		{
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No player has been striked for Trigger-Bot");
		}
	}
	return 1;
}

CMD:wtbot(playerid, params[])
{
	if(IsAdmin(playerid, TRIGGER_ADMIN))
	{
	    new targetid;
	    if(sscanf(params, "u", targetid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /wtbot [PlayerID/PlayerName]");
	    }
	    if(WatchTriggerBot[targetid] != -1)
	    {
	        if(WatchTriggerBot[targetid] != playerid)
	        {
				format(tbmsg, sizeof(tbmsg), "AdmCmd(%i): %s %s has bypassed your trigger-watch on %s(%i) and is currently taking over.", AdminLvl(playerid), GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
				if(AdminLvl(WatchTriggerBot[targetid]) >= 4)
					SendClientMessage(WatchTriggerBot[targetid], COLOR_WARNING, tbmsg);
				format(tbmsg, sizeof(tbmsg), "AdmCmd(%i): You have bypassed %s %s in trigger-watch on %s(%i).", AdminLvl(playerid), GetPlayerStatus(WatchTriggerBot[targetid]), PlayerName(WatchTriggerBot[targetid]), PlayerName(targetid), targetid);
				if(AdminLvl(playerid) >= 4)
					SendClientMessage(playerid, COLOR_WARNING, tbmsg);
				WatchTriggerBot[targetid] = playerid;
				format(tbmsg, sizeof(tbmsg), "AdmCmd(%i): %s %s is now watching %s(%i) for triggerbot.", 4, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
				SendAdminsOnlyMessage(5, tbmsg);
			}
			else
			{
				format(tbmsg, sizeof(tbmsg), "AdmCmd(%i): You have stopped your triggerbot-watch on %s(%i).", AdminLvl(playerid), PlayerName(targetid), targetid);
				if(AdminLvl(WatchTriggerBot[targetid]) >= 4)
					SendClientMessage(WatchTriggerBot[targetid], COLOR_WARNING, tbmsg);
				WatchTriggerBot[targetid] = -1;
				format(tbmsg, sizeof(tbmsg), "AdmCmd(%i): %s %s has stopped watching %s(%i) for triggerbot.", AdminLvl(playerid), GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
				SendAdminsOnlyMessage(5, tbmsg);
			}
		}
		else
		{
			format(tbmsg, sizeof(tbmsg), "AdmCmd(%i): You are now watching %s(%i).", AdminLvl(playerid), PlayerName(targetid), targetid);
			if(AdminLvl(playerid) >= 4)
				SendClientMessage(playerid, COLOR_WARNING, tbmsg);
			WatchTriggerBot[targetid] = playerid;
			format(tbmsg, sizeof(tbmsg), "AdmCmd(%i): %s %s is now watching %s(%i) for triggerbot.",  AdminLvl(playerid), GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
			SendAdminsOnlyMessage(5, tbmsg);
		}
	}
	return 1;
}












