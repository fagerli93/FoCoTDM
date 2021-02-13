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
* Filename: Ban_System.pwn                                                 	 	 *
* Author: pEar	                                                                 *
*********************************************************************************/

/*
	Creating this to hopefully replace the samp.ban which lags out the server.
*/

#include <YSI\y_hooks>

enum BanHandler_DialogOverview {
	IP_1,
	IP_2,
	IP_3,
	IP_4,
	TIME_TYPE,
	TIME,
	REASON[128],
	PID,
	NAME[MAX_PLAYER_NAME]
};

new DialogVarBanIP[MAX_PLAYERS][BanHandler_DialogOverview];


hook OnPlayerConnect(playerid)
{
	ban_handler(playerid);
	return 1;
}

forward ban_handler(playerid);
public ban_handler(playerid)
{
	new IP[16], query[512], IP_Ranges[3][56], i, j, tmp;
	if(GetPlayerIp(playerid, IP, 16) == 0)
	{
		AKickPlayer(-1, playerid, "Invalid IP connection");
	}

	IP_Ranges[0] = IP;
	DebugMsg(IP);
	for(i = 1; i < 3; i++)
	{
		for(j = sizeof(IP); j >= 0; j--)
		{
			tmp = strfind(IP, ".", false, j);
			if(tmp != -1)
			{
				strdel(IP, tmp, sizeof(IP));
				IP_Ranges[i] = IP;
				DebugMsg(IP);
				break;
			}
		}
	}

	format(query, sizeof(query), "SELECT `ib_id`, `ib_ip`, `ib_unbantime`, `ib_banned`, `ib_tempbanned` FROM `FoCo_Bans` WHERE `ib_ip`='%s' AND `ib_banned`='1' OR `ib_ip`='%s' AND `ib_banned`='1' OR `ib_ip`='%s' AND `ib_banned`='1'", IP_Ranges[0], IP_Ranges[1], IP_Ranges[2]);
	mysql_query(query, MYSQL_THREAD_BAN_HANDLER, playerid, con);
	return 1;
}

forward BanPlayer(playerid, targetid, reason[], isPublic);
public BanPlayer(playerid, targetid, reason[], isPublic)
{
	new BanningAdmin[MAX_PLAYER_NAME];
	if(targetid == INVALID_PLAYER_ID)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid playerid/name");
	}
	if(playerid == -1)
	{	
		format(BanningAdmin, sizeof(BanningAdmin), "The Guardian");
	}
	else
	{
		format(BanningAdmin, sizeof(BanningAdmin), "%s", PlayerName(playerid));
		FoCo_Player[playerid][admin_bans]++;
	}


	new string[256];
	format(string, sizeof(string), "[AdmCMD]: %s you have been banned by %s for %s", PlayerName(targetid), BanningAdmin, reason);
	SendClientMessage(targetid, COLOR_NOTICE, string);
	SendClientMessage(targetid, COLOR_NOTICE, "If you find this ban wrongful you can appeal at: www.forum.focotdm.com");

	if(isPublic != 0)
	{
		format(string, sizeof(string), "[AdmCMD]: %s has banned %s(%d), Reason: %s", BanningAdmin, PlayerName(targetid), targetid, reason);
		SendClientMessageToAll(COLOR_GLOBALNOTICE, string);	
	}

	format(string, sizeof(string), "AdmCmd(%d): %s banned User %s, IP: %s", ACMD_BAN, BanningAdmin, PlayerName(targetid), ipstring[targetid]);
	SendAdminMessage(ACMD_BAN,string);
	AdminLog(string);

	IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
	FoCo_Player[targetid][banned] = 1;
	mysql_real_escape_string(reason, reason);

	SQL_AdminRecordInsert(playerid, targetid, 3, reason);
	SQL_BanUser(targetid, 1);
	SQL_BanIP(-1, ipstring[targetid], 1, 0, -1, reason, FoCo_Player[targetid][id], BanningAdmin);
	Kick(targetid);
	return 1;
}

/*
	SQL ban for IPs. If banned == 1, the input id is ignored as a new case is created.
	If banned == 0, the function only sets the line in the field as 0, so we keep logs. Ignores everything else.
*/
forward SQL_BanIP(ib_id, ib_IP[], ib_banned, ib_temp, ib_unbantime, ib_reason[], ib_pid, ib_admin[]);
public SQL_BanIP(ib_id, ib_IP[], ib_banned, ib_temp, ib_unbantime, ib_reason[], ib_pid, ib_admin[])
{
	new query[512];
	if(ib_banned > 1 || ib_banned < 0)
	{
		return 1;
	}
	
	if(ib_banned == 1)
	{
		format(query, sizeof(query), "INSERT INTO `FoCo_Bans` (`ib_ip`, `ib_bantimestamp`, `ib_unbantime`, `ib_reason`, `ib_tempbanned`, `ib_pid`, `ib_admin`) VALUES ('%s', '%s', '%d', '%s', '%d', '%d', '%s')", ib_IP, TimeStamp(), ib_unbantime, ib_reason, ib_temp, ib_pid, ib_admin);
		mysql_query(query, MYSQL_THREAD_BANIP, ib_pid, con);
	}
	else
	{
		format(query, sizeof(query), "UPDATE FoCo_Bans SET `ib_banned`='0' WHERE `ib_id`='%d'", ib_id);
		mysql_query(query, MYSQL_THREAD_BANIP, ib_id, con);
	}
	
	return 1;
}

// Only updates the column in FoCo_Players. Use alongside SQL_BanIP if you want to properly ban a user.
forward SQL_BanUser(playerid, Banned);
public SQL_BanUser(playerid, Banned)
{
	new query[256];
	format(query, sizeof(query), "UPDATE `FoCo_Players` SET `banned` = '%d', tempban='%d' WHERE `username` = '%s'", Banned, Banned, PlayerName(playerid));
	mysql_query(query, MYSQL_ADMINACTION);
	return 1;
}

forward SQL_AdminRecordInsert(playerid, targetid, actiontype, reason[]);
public SQL_AdminRecordInsert(playerid, targetid, actiontype, reason[])
{
	new string[512];
	if(playerid != -1)
	{
		format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', '%d', '%d', '%s', '%s')", FoCo_Player[targetid][id], FoCo_Player[playerid][id], actiontype, reason, TimeStamp());
		mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, targetid, con);
	}
	else
	{
		format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', 'The Guardian', '%d', '%s', '%s')", FoCo_Player[targetid][id], actiontype, reason, TimeStamp());
		mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, targetid, con);
	}
	return 1;
}


CMD:ban(playerid, params[])//IF YOU EDIT THIS, EDIT THE GUARDIAN BANS
{
	if(IsAdmin(playerid, ACMD_BAN) || IsTrialAdmin(playerid))
	{
		new targetid, reason[128], string[256];
		if (sscanf(params, "us[128]", targetid, reason))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /ban [ID/Name] [Reason]");
			return 1;
		}
		if(isnull(reason))
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to type in a reason!");
		}

		if(FoCo_Player[targetid][id] == 368 && FoCo_Player[playerid][id] != 368 || FoCo_Player[targetid][id] == 28261 && FoCo_Player[playerid][id] != 28261)
		{
			format(string, sizeof(string), "%s banned himself by attempting to ban %s. How humiliating!", PlayerName(playerid), PlayerName(targetid));
			BanPlayer(-1, playerid, string, 1);
			return 1;
		}
		if(AdminLvl(playerid) == 0 && IsTrialAdmin(playerid) && AdminLvl(targetid) == 0)
		{
			BanPlayer(playerid, targetid, reason, 1);
			return 1;
		}
		if(FoCo_Player[targetid][admin] >= FoCo_Player[playerid][admin] && FoCo_Player[playerid][id] != 368 && playerid != targetid)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command on other admins with the same or higher admin level as yourself. Naughty!");
		    return 1;
		}
		BanPlayer(playerid, targetid, reason, 1);
	}
	return 1;
}

CMD:unban(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_UNBAN))
	{
		new reason[128], banname[25];
		if (sscanf(params, "s[25]",banname))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /unban [Banned Username]");
			return 1;
		}
		new string[256];
        format(string, sizeof(string), "AdmCmd(%d): %s %s has unbanned User: %s", ACMD_UNBAN,GetPlayerStatus(playerid), PlayerName(playerid), banname);
		SendAdminMessage(ACMD_UNBAN,string);
		AdminLog(string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		DialogOptionVar3[playerid] = banname;
		DialogOptionVar4[playerid] = reason;
		format(string, sizeof(string), "SELECT * FROM `FoCo_Players` WHERE `username`='%s'", banname);
		mysql_query(string, MYSQL_UNBAN_THREAD, playerid, con);
	}
	return 1;
}


CMD:banip(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_BANIP))
	{
		new IPADD[4], string[256], reason[128];
		if(sscanf(params, "p<.>iiiis[128]", IPADD[0], IPADD[1], IPADD[2], IPADD[3], reason))
		{
			if(!sscanf(params, "p<.>iiis[128]", IPADD[0], IPADD[1], IPADD[2], reason))
			{
				if(AdminLvl(playerid) < ACMD_BANIPRANGE)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You may not ban IP-ranges!");
				}
				if(strlen(reason) < 5)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The reason needs to consist of atleast 5 charactes!");
				}
				if(IPADD[0] > 255 || IPADD[1] > 255 || IPADD[2] > 255 || IPADD[3] > 255)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: IP's can only go to 255, please try again with a valid IP address.");
				}
				format(string, sizeof(string), "AdmCmd(%d): %s %s has range-banned IP %d.%d.%d, Reason: %s",ACMD_BANIP, GetPlayerStatus(playerid), PlayerName(playerid), IPADD[0], IPADD[1], IPADD[2], reason);
				SendAdminMessage(ACMD_BANIP,string);

				mysql_real_escape_string(reason, reason);

				format(string, sizeof(string), "INSERT INTO `FoCo_Bans` (`ib_ip`, `ib_reason`, `ib_admin`) VALUES ('%d.%d.%d', '%s', '%s')", IPADD[0], IPADD[1], IPADD[2], reason, PlayerName(playerid));
				mysql_query(string);
				return 1;
			}
			if(!sscanf(params, "p<.>iis[128]", IPADD[0], IPADD[1], reason))
			{
				if(AdminLvl(playerid) < ACMD_BANIPRANGE)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You may not ban IP-ranges!");
				}
				if(strlen(reason) < 5)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The reason needs to consist of atleast 5 charactes!");
				}
				if(IPADD[0] > 255 || IPADD[1] > 255 || IPADD[2] > 255 || IPADD[3] > 255)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: IP's can only go to 255, please try again with a valid IP address.");
				}
				format(string, sizeof(string), "AdmCmd(%d): %s %s has range-banned IP %d.%d, Reason: %s",ACMD_BANIP, GetPlayerStatus(playerid), PlayerName(playerid), IPADD[0], IPADD[1], reason);
				SendAdminMessage(ACMD_BANIP,string);

				mysql_real_escape_string(reason, reason);

				format(string, sizeof(string), "INSERT INTO `FoCo_Bans` (`ib_ip`, `ib_reason`, `ib_admin`) VALUES ('%d.%d', '%s', '%s')", IPADD[0], IPADD[1], reason, PlayerName(playerid));
				mysql_query(string);
				return 1;
			}
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /banip IP_Address[xxx.xxx(.xxx)(.xxx)] [Reason]");
		}
		if(IPADD[0] > 255 || IPADD[1] > 255 || IPADD[2] > 255 || IPADD[3] > 255)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: IP's can only go to 255, please try again with a valid IP address.");
		}
		if(strlen(reason) < 5)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The reason needs to consist of atleast 5 charactes!");
		}
		format(string, sizeof(string), "AdmCmd(%d): %s %s has banned IP %d.%d.%d.%d, Reason: %s",ACMD_BANIP, GetPlayerStatus(playerid), PlayerName(playerid), IPADD[0], IPADD[1], IPADD[2], IPADD[3], reason);
		SendAdminMessage(ACMD_BANIP,string);

		mysql_real_escape_string(reason, reason);

		format(string, sizeof(string), "INSERT INTO `FoCo_Bans` (`ib_ip`, `ib_reason`, `ib_admin`) VALUES ('%d.%d.%d.%d', '%s', '%s')", IPADD[0], IPADD[1], IPADD[2], IPADD[3], reason, PlayerName(playerid));
		mysql_query(string);
	}
	return 1;
}

CMD:tempbanip(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_BANIP))
	{
		new string[256];
		if(sscanf(params, "p<.>iiiis[128]", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3], DialogVarBanIP[playerid][IP_4], DialogVarBanIP[playerid][REASON]))
		{
			if(!sscanf(params, "p<.>iiis[128]", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3], DialogVarBanIP[playerid][REASON]))
			{
				if(AdminLvl(playerid) < ACMD_BANIPRANGE)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You may not ban IP-ranges!");
				}
				if(strlen(DialogVarBanIP[playerid][REASON]) < 5)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Reason needs to be atleast 5 characters!");
				}
				if(DialogVarBanIP[playerid][IP_1] > 255 || DialogVarBanIP[playerid][IP_2] > 255 || DialogVarBanIP[playerid][IP_3] > 255 || DialogVarBanIP[playerid][IP_4] > 255)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: IP's can only go to 255, please try again with a valid IP address.");
				}
				format(string, sizeof(string), "Tempban IP-Range: %d.%d.%d", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3]);
				DialogVarBanIP[playerid][IP_4] = -1;
				ShowPlayerDialog(playerid, DIALOG_TEMPBANIP, DIALOG_STYLE_LIST, string, "TempBan for Hours\nTempBan for Days\nTempBan for Weeks\nTempBan for Months\nTempBan for Years", "Continue", "Cancel");
				return 1;
			}
			if(!sscanf(params, "p<.>iis[128]", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][REASON]))
			{
				if(AdminLvl(playerid) < ACMD_BANIPRANGE)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You may not ban IP-ranges!");
				}
				if(strlen(DialogVarBanIP[playerid][REASON]) < 5)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Reason needs to be atleast 5 characters!");
				}
				if(DialogVarBanIP[playerid][IP_1] > 255 || DialogVarBanIP[playerid][IP_2] > 255 || DialogVarBanIP[playerid][IP_3] > 255 || DialogVarBanIP[playerid][IP_4] > 255)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: IP's can only go to 255, please try again with a valid IP address.");
				}
				format(string, sizeof(string), "Tempban IP-Range: %d.%d", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2]);
				DialogVarBanIP[playerid][IP_3] = -1;
				DialogVarBanIP[playerid][IP_4] = -1;
				ShowPlayerDialog(playerid, DIALOG_TEMPBANIP, DIALOG_STYLE_LIST, string, "TempBan for Hours\nTempBan for Days\nTempBan for Weeks\nTempBan for Months\nTempBan for Years", "Continue", "Cancel");
				return 1;
			}
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /tempbanip IP_Address[xxx.xxx(.xxx)(.xxx)][Reason] (Time will decided later)");
		}
		if(strlen(DialogVarBanIP[playerid][REASON]) < 5)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Reason needs to be atleast 5 characters!");
		}
		if(DialogVarBanIP[playerid][IP_1] > 255 || DialogVarBanIP[playerid][IP_2] > 255 || DialogVarBanIP[playerid][IP_3] > 255 || DialogVarBanIP[playerid][IP_4] > 255)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: IP's can only go to 255, please try again with a valid IP address.");
		}
		format(string, sizeof(string), "Tempban IP: %d.%d.%d.%d", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3], DialogVarBanIP[playerid][IP_4]);
		ShowPlayerDialog(playerid, DIALOG_TEMPBANIP, DIALOG_STYLE_LIST, string, "TempBan for Hours\nTempBan for Days\nTempBan for Weeks\nTempBan for Months\nTempBan for Years", "Continue", "Cancel");
	}
	return 1;
}


CMD:unbanip(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_BANIP))
	{
		new string[256];
		if(sscanf(params, "p<.>iiii", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3], DialogVarBanIP[playerid][IP_4]))
		{
			// Range unbans
			if(!sscanf(params, "p<.>iii", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3]))
			{
				DebugMsg("Trying to unban a range, left the last digit..");
				DialogVarBanIP[playerid][IP_4] = -1;
			}
			else if(!sscanf(params, "p<.>ii", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2]))
			{
				DebugMsg("Trying to unban a range, left the last TWO digit..");
				DialogVarBanIP[playerid][IP_3] = -1;
				DialogVarBanIP[playerid][IP_4] = -1;
			}
			else
			{
				return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /unbanip IP_Address[xxx.xxx(.xxx)(.xxx)]");	
			}
		}
		if(DialogVarBanIP[playerid][IP_1] > 255 || DialogVarBanIP[playerid][IP_2] > 255 || DialogVarBanIP[playerid][IP_3] > 255 || DialogVarBanIP[playerid][IP_4] > 255)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: IP's can only go to 255, please try again with a valid IP address.");
		}

		if(DialogVarBanIP[playerid][IP_3] == -1)
		{
			mysql_real_escape_string(DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_1]);
			mysql_real_escape_string(DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_2]);
			format(string, sizeof(string), "IP1: %d, IP2: %d, aka: %d.%d", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2]);
			DebugMsg(string);
			format(string, sizeof(string), "UPDATE `FoCo_Bans` SET `ib_banned`='0' WHERE `ib_ip`='%d.%d' AND `ib_banned`='1'", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2]);
			DebugMsg(string);
			mysql_query(string, MYSQL_THREAD_UNBANIP, playerid, con);
		}
		else if(DialogVarBanIP[playerid][IP_4] == -1)
		{
			mysql_real_escape_string(DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_1]);
			mysql_real_escape_string(DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_2]);
			mysql_real_escape_string(DialogVarBanIP[playerid][IP_3], DialogVarBanIP[playerid][IP_3]);
			format(string, sizeof(string), "IP1: %d, IP2: %d, IP3: %d, aka: %d.%d.%d", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3], DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3]);
			DebugMsg(string);
			format(string, sizeof(string), "UPDATE `FoCo_Bans` SET `ib_banned`='0' WHERE `ib_ip`='%d.%d.%d' AND `ib_banned`='1'", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3]);
			DebugMsg(string);
			mysql_query(string, MYSQL_THREAD_UNBANIP, playerid, con);
		}
		else
		{
			mysql_real_escape_string(DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_1]);
			mysql_real_escape_string(DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_2]);
			mysql_real_escape_string(DialogVarBanIP[playerid][IP_3], DialogVarBanIP[playerid][IP_3]);
			mysql_real_escape_string(DialogVarBanIP[playerid][IP_4], DialogVarBanIP[playerid][IP_4]);
			format(string, sizeof(string), "IP1: %d, IP2: %d, IP3: %d, IP4: %d, aka: %d.%d.%d.%d", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3], DialogVarBanIP[playerid][IP_4], DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3], DialogVarBanIP[playerid][IP_4]);
			DebugMsg(string);
			format(string, sizeof(string), "UPDATE `FoCo_Bans` SET `ib_banned`='0' WHERE `ib_ip`='%d.%d.%d.%d' AND `ib_banned`='1'", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3], DialogVarBanIP[playerid][IP_4]);
			DebugMsg(string);
			mysql_query(string, MYSQL_THREAD_UNBANIP, playerid, con);	
		}
		
	}
	return 1;
}


CMD:tempban(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_TEMPBAN))
	{
	    new targetid, reason[128];
	    if(sscanf(params, "us[156]", targetid, reason))
	    {
			SendClientMessage(playerid,COLOR_SYNTAX, "[USAGE]: /tempban [ID/Name] [Reason] (Time will be decided later)");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(FoCo_Player[targetid][admin] >= FoCo_Player[playerid][admin] && FoCo_Player[playerid][id] != 368 && playerid != targetid)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command on other admins with the same or higher admin level as yourself. Naughty!");
		    return 1;
		}
		DialogVarBanIP[playerid][REASON] = reason;
		DialogVarBanIP[playerid][PID] = targetid;
		DialogVarBanIP[playerid][NAME] = PlayerName(targetid);
		new string[MAX_PLAYER_NAME + 30];
		format(string, sizeof(string), "Tempban of %s(%d)", PlayerName(targetid), targetid);
		ShowPlayerDialog(playerid, DIALOG_TEMPBAN, DIALOG_STYLE_LIST, string, "TempBan for Hours\nTempBan for Days\nTempBan for Weeks\nTempBan for Months\nTempBan for Years", "Continue", "Cancel");
		return 1;
	}
	return 1;
}

CMD:datetounix(playerid, params[])
{
	new date[11], unix;
	if(sscanf(params, "s[11]", date))
	{
		return SendClientMessage(playerid, COLOR_WARNING, "Something went wrong..");
	}
	unix = DateToTimestamp(date);
	new string[24];
	format(string, sizeof(string), "Unix: %d", unix);
	DebugMsg(string);
	return 1;
}




hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new string[256];
	new type[5][] = {"Hour(s)", "Day(s)", "Week(s)", "Month(s)", "Year(s)"};
	switch(dialogid)
	{
		case DIALOG_TEMPBANIP: 
		{
			if(response)
			{
				//type[] = {"hours", "days", "weeks", "months", "years"};
				if(DialogVarBanIP[playerid][IP_3] == -1)
				{
					format(string, sizeof(string), "TempBan %d.%d for X %s.", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], type[listitem]);
				}
				else if(DialogVarBanIP[playerid][IP_4] == -1)
				{
					format(string, sizeof(string), "TempBan %d.%d.%d for X %s.", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3], type[listitem]);
				}
				else
				{
					format(string, sizeof(string), "TempBan %d.%d.%d.%d for X %s.", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3], DialogVarBanIP[playerid][IP_4], type[listitem]);
				}
				
				DialogVarBanIP[playerid][TIME_TYPE] = listitem;
				ShowPlayerDialog(playerid, DIALOG_TEMPBANIP_TIME, DIALOG_STYLE_INPUT, string, "Please only enter a number.", "Confirm", "Cancel");
			}
			else
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: Cancelled the temp IP ban.");
				return 1;
			}
		}
		case DIALOG_TEMPBANIP_TIME:
		{
			if(response)
			{
				if(!IsNumeric(inputtext))
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can only use a number here!");
				}
				else
				{
					DialogVarBanIP[playerid][TIME] = strval(inputtext);
					
					if(DialogVarBanIP[playerid][IP_3] == -1)
					{
						format(string, sizeof(string), "Range: %d.%d\nTimeType: %s\nTime Period: %d\nReason: %s", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], type[DialogVarBanIP[playerid][TIME_TYPE]], DialogVarBanIP[playerid][TIME], DialogVarBanIP[playerid][REASON]);
					}
					else if(DialogVarBanIP[playerid][IP_4] == -1)
					{
						format(string, sizeof(string), "Range: %d.%d.%d\nTimeType: %s\nTime Period: %d\nReason: %s", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3], type[DialogVarBanIP[playerid][TIME_TYPE]], DialogVarBanIP[playerid][TIME], DialogVarBanIP[playerid][REASON]);
					}	
					else
					{
						format(string, sizeof(string), "IP: %d.%d.%d.%d\nTimeType: %s\nTime Period: %d\nReason: %s", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3], DialogVarBanIP[playerid][IP_4], type[DialogVarBanIP[playerid][TIME_TYPE]], DialogVarBanIP[playerid][TIME], DialogVarBanIP[playerid][REASON]);
					}
					ShowPlayerDialog(playerid, DIALOG_TEMPBANIP_CONFIRM, DIALOG_STYLE_MSGBOX, "Confirmation of temp-ban", string, "Confirm", "Cancel");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: Cancelled the temp IP ban.");
				return 1;
			}
		}
		case DIALOG_TEMPBANIP_CONFIRM:
		{
			if(response)
			{
				new query[256];
				//new type[5][] = {"hour(s)", "day(s)", "week(s)", "month(s)", "year(s)"};
				mysql_real_escape_string(DialogVarBanIP[playerid][REASON], DialogVarBanIP[playerid][REASON]);

				new unbantime;
				switch(DialogVarBanIP[playerid][TIME_TYPE])
				{
					case 0: unbantime = gettime() + (DialogVarBanIP[playerid][TIME] * 3600); // Hours
					case 1: unbantime = gettime() + (DialogVarBanIP[playerid][TIME] * 86400); // Days 
					case 2: unbantime = gettime() + (DialogVarBanIP[playerid][TIME] * 604800); // Weeks
					case 3: unbantime = gettime() + (DialogVarBanIP[playerid][TIME] * 2629743); // Months 
					case 4: unbantime = gettime() + (DialogVarBanIP[playerid][TIME] * 31556926); // Years 
				}


				if(DialogVarBanIP[playerid][IP_3] == -1)
				{
					format(string, sizeof(string), "AdmCmd(%d): %s %s has temp-banned the IP-Range: %d.%d, Reason: %s for %d %s.",ACMD_BANIP, GetPlayerStatus(playerid), PlayerName(playerid), DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][REASON], DialogVarBanIP[playerid][TIME], type[DialogVarBanIP[playerid][TIME_TYPE]]);
					format(query, sizeof(query), "INSERT INTO `FoCo_Bans` (`ib_ip`, `ib_reason`, `ib_tempbanned`, `ib_unbantime`, `ib_admin`) VALUES ('%d.%d.%d.%d', '%s', '1', '%d', '%s')", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][REASON], unbantime, PlayerName(playerid));
				}
				else if(DialogVarBanIP[playerid][IP_4] == -1)
				{
					format(string, sizeof(string), "AdmCmd(%d): %s %s has temp-banned the IP-Range: %d.%d.%d, Reason: %s for %d %s.",ACMD_BANIP, GetPlayerStatus(playerid), PlayerName(playerid), DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3], DialogVarBanIP[playerid][REASON], DialogVarBanIP[playerid][TIME], type[DialogVarBanIP[playerid][TIME_TYPE]]);
					format(query, sizeof(query), "INSERT INTO `FoCo_Bans` (`ib_ip`, `ib_reason`, `ib_tempbanned`, `ib_unbantime`, `ib_admin`) VALUES ('%d.%d.%d', '%s', '1', '%d', '%s')", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3], DialogVarBanIP[playerid][REASON], unbantime, PlayerName(playerid));
				}	
				else
				{
					format(query, sizeof(query), "INSERT INTO `FoCo_Bans` (`ib_ip`, `ib_reason`, `ib_tempbanned`, `ib_unbantime`, `ib_admin`) VALUES ('%d.%d.%d.%d', '%s', '1', '%d', '%s')", DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3], DialogVarBanIP[playerid][IP_4], DialogVarBanIP[playerid][REASON], unbantime, PlayerName(playerid));
					format(string, sizeof(string), "AdmCmd(%d): %s %s has temp-banned IP: %d.%d.%d.%d, Reason: %s for %d %s.",ACMD_BANIP, GetPlayerStatus(playerid), PlayerName(playerid), DialogVarBanIP[playerid][IP_1], DialogVarBanIP[playerid][IP_2], DialogVarBanIP[playerid][IP_3], DialogVarBanIP[playerid][IP_4], DialogVarBanIP[playerid][REASON], DialogVarBanIP[playerid][TIME], type[DialogVarBanIP[playerid][TIME_TYPE]]);
				}
				
				SendAdminMessage(ACMD_BANIP,string);
				mysql_query(query);
				
			}
			else
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: Cancelled the temp IP ban.");
				return 1;
			}
		}
		case DIALOG_TEMPBAN:
		{
			if(response)
			{

				format(string, sizeof(string), "TempBan %s(%d) for X %s.", DialogVarBanIP[playerid][NAME], DialogVarBanIP[playerid][PID], type[listitem]);
				DialogVarBanIP[playerid][TIME_TYPE] = listitem;
				ShowPlayerDialog(playerid, DIALOG_TEMPBAN_TIME, DIALOG_STYLE_INPUT, string, "Please only enter a number.", "Confirm", "Cancel");
				return 1;
			}
			else
			{
				return SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: Cancelled the temp-ban.");
			}
		}
		case DIALOG_TEMPBAN_TIME:
		{
			if(response)
			{
				if(!IsNumeric(inputtext))
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can only use a number here!");
				}
				else
				{
					DialogVarBanIP[playerid][TIME] = strval(inputtext);
					new IP[16];
					GetPlayerIp(DialogVarBanIP[playerid][PID], IP, 16);
					format(string, sizeof(string), "Name: %s\nID: %d\nIP: %s\nTimeType: %s\nTime Period: %d\nReason: %s", DialogVarBanIP[playerid][NAME], DialogVarBanIP[playerid][PID], IP, type[DialogVarBanIP[playerid][TIME_TYPE]], DialogVarBanIP[playerid][TIME], DialogVarBanIP[playerid][REASON]);
				
					ShowPlayerDialog(playerid, DIALOG_TEMPBAN_CONFIRM, DIALOG_STYLE_MSGBOX, "Confirmation of temp-ban", string, "Confirm", "Cancel");
					return 1;
				}
			}
			else
			{
				return SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: Cancelled the temp-ban.");
			}
		}
		case DIALOG_TEMPBAN_CONFIRM:
		{
			if(response)
			{
				new query[512];
				if(strcmp(DialogVarBanIP[playerid][NAME], PlayerName(DialogVarBanIP[playerid][PID]), false) != 0)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The player you wanted to temp-ban has logged out. He has NOT been temp-banned!");
				}
				mysql_real_escape_string(DialogVarBanIP[playerid][REASON], DialogVarBanIP[playerid][REASON]);

				new unbantime;
				switch(DialogVarBanIP[playerid][TIME_TYPE])
				{
					case 0: unbantime = gettime() + (DialogVarBanIP[playerid][TIME] * 3600); // Hours
					case 1: unbantime = gettime() + (DialogVarBanIP[playerid][TIME] * 86400); // Days 
					case 2: unbantime = gettime() + (DialogVarBanIP[playerid][TIME] * 604800); // Weeks
					case 3: unbantime = gettime() + (DialogVarBanIP[playerid][TIME] * 2629743); // Months 
					case 4: unbantime = gettime() + (DialogVarBanIP[playerid][TIME] * 31556926); // Years 
				}

				format(string, sizeof(string), "[AdmCMD]: %s has banned %s(%d) for %d %s, Reason: %s", PlayerName(playerid), DialogVarBanIP[playerid][NAME], DialogVarBanIP[playerid][PID], DialogVarBanIP[playerid][TIME], type[DialogVarBanIP[playerid][TIME_TYPE]], DialogVarBanIP[playerid][REASON]);
				SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
				SendClientMessage(DialogVarBanIP[playerid][PID], COLOR_NOTICE, "If you find this ban wrongful you can appeal at: forum.focotdm.com");
				AdminLog(string);
				IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
				FoCo_Player[playerid][admin_bans]++;

				mysql_real_escape_string(DialogVarBanIP[playerid][REASON], DialogVarBanIP[playerid][REASON]);

				format(query, sizeof(query), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`, `time`) VALUES ('%d', '%s', '3', '[Tempban - %d %s]: %s', '%s','%d')", FoCo_Player[DialogVarBanIP[playerid][PID]][id], PlayerName(playerid), DialogVarBanIP[playerid][TIME], type[DialogVarBanIP[playerid][TIME_TYPE]], DialogVarBanIP[playerid][REASON], TimeStamp(), DialogVarBanIP[playerid][TIME]);
				DebugMsg(query);
				mysql_query(query, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);

				

				new IP[16];
				GetPlayerIp(DialogVarBanIP[playerid][PID], IP, 16);
				format(query, sizeof(query), "INSERT INTO `FoCo_Bans` (`ib_ip`, `ib_reason`, `ib_tempbanned`, `ib_unbantime`, `ib_pid`, `ib_admin`) VALUES ('%s', '%s', '1', '%d', '%d', '%s')", IP, DialogVarBanIP[playerid][REASON], unbantime, FoCo_Player[DialogVarBanIP[playerid][PID]][id], PlayerName(playerid));
				DebugMsg(query);
				format(string, sizeof(string), "AdmCmd(%d): %s %s has temp-banned IP: %s, Reason: %s for %d %s.",ACMD_BANIP, GetPlayerStatus(playerid), PlayerName(playerid), IP, DialogVarBanIP[playerid][REASON], DialogVarBanIP[playerid][TIME], type[DialogVarBanIP[playerid][TIME_TYPE]]);

				FoCo_Player[DialogVarBanIP[playerid][PID]][tempban] = unbantime;
				DebugMsg("Kick... Doesnt so we can see msg's :D");
				//Kick(DialogVarBanIP[playerid][PID]);
				
				return 1;
			}	
			else
			{
				return SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: Cancelled the temp-ban.");
			}
		}
	}
	return 1;
}

