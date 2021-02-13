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
* Filename: pEar_ReportSys.pwn                                                   *
* Author: pEar	                                                                 *
*********************************************************************************/

/*
	INCLUDES
*/

#include <YSI\y_hooks>


/*
	DEFINES
*/
#define MAX_REPORTS_PER_PLAYER 3
#define MAX_REPORTS_TO_SHOW 15
#define MAX_REPORT_LEN_TO_SHOW 20
#define REPORT_DELAY 10 						// 5 seconds between each report.

/*
	FUNCTION FORWARDS
*/
forward SendReportMessage(minrank, message[]);
forward DeleteReport(playerid, report_id);
forward AcceptReport(playerid, report_id);
forward MinCalc(sec);


/*
	ENUMS AND VARIABLES/ARRAYS
*/
enum p_report {
	p_playerid,
	p_targetid,
	p_time,
	p_reason[128]
};

new p_reports[MAX_PLAYERS * MAX_REPORTS_PER_PLAYER][p_report];	// All reports
new DialogOverview[MAX_REPORTS_TO_SHOW];						// Needed to keep overview when doing the dialogs
new DialogOverviewPlayer[MAX_PLAYERS][MAX_REPORTS_PER_PLAYER];
new DialogReport[MAX_PLAYERS];									// Used to keep track of what report is being accepted or deleted.

// Keeps track of active reports
new Player_Active_Reports[MAX_PLAYERS];

// Keeps track of index into the global report table.
new Player_Reports[MAX_PLAYERS][MAX_REPORTS_PER_PLAYER];

/*
	HOOKS
*/

hook OnGameModeInit()
{
	for(new i = 0; i < MAX_PLAYERS * MAX_REPORTS_PER_PLAYER; i++)
	{
		p_reports[i][p_playerid] = -1;
		p_reports[i][p_targetid] = -1;
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		Player_Active_Reports[i] = 0;
		for(new j = 0; j < MAX_REPORTS_PER_PLAYER; j++)
		{
			Player_Reports[i][j] = -1;
		}
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	Player_Active_Reports[playerid] = 0;
	for(new i = 0; i < MAX_REPORTS_PER_PLAYER; i++)
	{
		if(Player_Reports[playerid][i] != -1)
		{
			p_reports[Player_Reports[playerid][i]][p_playerid] = -1;
		}
		Player_Reports[playerid][i] = -1;
	}
	for(new i = 0; i < MAX_PLAYERS * MAX_REPORTS_PER_PLAYER; i++)
	{
		if(p_reports[i][p_targetid] == playerid && p_reports[i][p_playerid] != -1)
		{
			new string[256];
			format(string, sizeof(string), "[REPORT INFO]: The player %s(%d) which you reported for '%s' %d minutes ago, has logged off.", PlayerName(playerid), playerid, p_reports[i][p_reason], MinCalc(p_reports[i][p_time])); 
			SendClientMessage(p_reports[i][p_playerid], COLOR_WHITE, string);
			SendClientMessage(p_reports[i][p_playerid], COLOR_WHITE, "If you wish, you can report the player at www.forum.focotdm.com under the Report Player section.");
			for(new j = 0; j  < MAX_REPORTS_PER_PLAYER; j++)
			{
				if(Player_Reports[p_reports[i][p_playerid]][j] == i)
				{
					Player_Reports[p_reports[i][p_playerid]][j] = -1;
					Player_Active_Reports[p_reports[i][p_playerid]]--;
				}	
			}
			p_reports[i][p_playerid] = -1;
			p_reports[i][p_targetid] = -1;
		}	
	}

	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    print("ODR_pEar_RepSys");
	new string[512];
	switch(dialogid)
	{
		case DIALOG_REPORT_VIEW:
		{
			if(response)
			{
				if(p_reports[DialogOverview[listitem]][p_playerid] == -1)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Someone must've accepted this report already..");
				}
				format(string, sizeof(string), "Player: %s(%d)\nReported: %s(%d)\nTime: %d minutes ago\nReason: %s", PlayerName(p_reports[DialogOverview[listitem]][p_playerid]), p_reports[DialogOverview[listitem]][p_playerid], PlayerName(p_reports[DialogOverview[listitem]][p_targetid]), p_reports[DialogOverview[listitem]][p_targetid], MinCalc(p_reports[DialogOverview[listitem]][p_time]), p_reports[DialogOverview[listitem]][p_reason]);
				ShowPlayerDialog(playerid, DIALOG_REPORT_DETAILS, DIALOG_STYLE_MSGBOX, "Report System - Details", string, "Handle", "Back");
				DialogReport[playerid] = DialogOverview[listitem];
				return 1;
			}
			else
			{
				return 1;	
			}
		}
		case DIALOG_REPORT_DETAILS:
		{
			if(response)
			{
				if(p_reports[DialogReport[playerid]][p_playerid] == -1)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Someone must've accepted this report already..");
				}
				ShowPlayerDialog(playerid, DIALOG_REPORT_HANDLE, DIALOG_STYLE_LIST, "Report System - Handle", "Accept\nDelete", "Confirm", "Back");
				return 1;
			}
			else
			{
				new reports_string[1024];
				reports_string = GetAllReports();
				ShowPlayerDialog(playerid, DIALOG_REPORT_VIEW, DIALOG_STYLE_TABLIST_HEADERS, "Report System", reports_string, "View", "Close");
				return 1;
			}
		}
		case DIALOG_REPORT_HANDLE:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: 
					{
						if(p_reports[DialogReport[playerid]][p_playerid] == -1)
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Someone must've accepted this report already..");
						}
						AcceptReport(playerid, DialogReport[playerid]);
					}
					case 1: 
					{
						if(p_reports[DialogReport[playerid]][p_playerid] == -1)
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Someone must've accepted this report already..");
						}
						DeleteReport(playerid, DialogReport[playerid]);
						new reports_string[1024];
						reports_string = GetAllReports();
						ShowPlayerDialog(playerid, DIALOG_REPORT_VIEW, DIALOG_STYLE_TABLIST_HEADERS, "Report System", reports_string, "View", "Close");
					}
				}
				return 1;
			}
			else
			{
				new reports_string[1024];
				reports_string = GetAllReports();
				ShowPlayerDialog(playerid, DIALOG_REPORT_VIEW, DIALOG_STYLE_TABLIST_HEADERS, "Report System", reports_string, "View", "Close");
				return 1;
			}
		}
		case DIALOG_REPORT_VIEW_PLAYER:
		{
			if(!response)
			{
				return 1;
			}
			else
			{
				format(string, sizeof(string), "[REPORT INFO]: %s(%d) has deleted his report on %s(%d), ReportID: %d", PlayerName(playerid), playerid, PlayerName(p_reports[DialogOverviewPlayer[playerid][listitem]][p_targetid]), p_reports[DialogOverviewPlayer[playerid][listitem]][p_targetid], DialogOverviewPlayer[playerid][listitem]);
				SendAdminMessage(1, string);
				format(string, sizeof(string), "[REPORT INFO]: You deleted your report (RepID: %d) on %s(%d) for %s, %d minutes ago", DialogOverviewPlayer[playerid][listitem], PlayerName(p_reports[DialogOverviewPlayer[playerid][listitem]][p_targetid]), p_reports[DialogOverviewPlayer[playerid][listitem]][p_targetid], p_reports[DialogOverviewPlayer[playerid][listitem]][p_reason], MinCalc(p_reports[DialogOverviewPlayer[playerid][listitem]][p_time]));
				for(new i = 0; i < MAX_REPORTS_PER_PLAYER; i++)
				{
					if(Player_Reports[playerid][i] == DialogOverviewPlayer[playerid][listitem])
					{
						Player_Reports[playerid][i] = -1;	
					}
				}
				p_reports[DialogOverviewPlayer[playerid][listitem]][p_playerid] = -1;
				Player_Active_Reports[playerid]--;
				
				return SendClientMessage(playerid, COLOR_SYNTAX, string);
			}
		}
	}
	return 1;
}

/*
	FUNCTIONS
*/
public AcceptReport(playerid, report_id)
{
	new string[128];
	format(string, sizeof(string), "[REPORT INFO]: %s %s(%d) is now looking into your report, please be patient.", GetPlayerStatus(playerid), PlayerName(playerid), playerid);
	SendClientMessage(p_reports[report_id][p_playerid], COLOR_SYNTAX, string);
	
	FoCo_Player[playerid][reports]++;

	format(string, sizeof(string), "[REPORT INFO]: %s %s(%d) has accepted report %d", GetPlayerStatus(playerid), PlayerName(playerid), playerid, report_id);
	SendAdminMessage(ACMD_AR, string);
	IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
	format(string, sizeof(string), "You accepted report ID %d -  %s(%d) reported %s(%d) for %s, %d mins ago.", report_id, PlayerName(p_reports[report_id][p_playerid]), p_reports[report_id][p_playerid], PlayerName(p_reports[report_id][p_targetid]), p_reports[report_id][p_targetid], p_reports[report_id][p_reason], MinCalc(p_reports[report_id][p_time]));
	SendClientMessage(playerid, COLOR_WHITE, string);
	Player_Active_Reports[p_reports[report_id][p_playerid]]--;
	for(new i = 0; i < MAX_REPORTS_PER_PLAYER; i++)
	{
		// Reset for player as well.
		if(Player_Reports[p_reports[report_id][p_playerid]][i] == report_id)
		{
			Player_Reports[p_reports[report_id][p_playerid]][i] = -1;
		}
	}
	p_reports[report_id][p_playerid] = -1;
	return 1;
}

public DeleteReport(playerid, report_id)
{
	new string[128];
	format(string, sizeof(string), "[REPORT NOTICE]: %s %s(%d) has deleted report %d", GetPlayerStatus(playerid), PlayerName(playerid), playerid, report_id);
	SendAdminMessage(1, string);
	format(string, sizeof(string), "You deleted report ID %d - %s(%d) reported %s(%d) for %s, %d mins ago.", report_id, PlayerName(p_reports[report_id][p_playerid]), p_reports[report_id][p_playerid], PlayerName(p_reports[report_id][p_targetid]), p_reports[report_id][p_targetid], p_reports[report_id][p_reason], MinCalc(p_reports[report_id][p_time]));
	SendClientMessage(playerid, COLOR_WHITE, string);
	IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
	Player_Active_Reports[p_reports[report_id][p_playerid]]--;
	for(new i = 0; i < MAX_REPORTS_PER_PLAYER; i++)
	{
		// Reset for player as well.
		if(Player_Reports[p_reports[report_id][p_playerid]][i] == report_id)
		{
			Player_Reports[p_reports[report_id][p_playerid]][i] = -1;
		}
	}
	p_reports[report_id][p_playerid] = -1;
	return 1;
}

public SendReportMessage(minrank, message[])
{
	foreach (Player, i)
	{
		if(IsPlayerConnected(i))
		{
			if(FoCo_Player[i][admin] >= minrank)
			{
				SendClientMessage(i, COLOR_LIGHTORANGE, message);
			}
		}
	}
	IRC_GroupSay(gEcho, IRC_FOCO_ECHO, message);
	return 1;
}

public MinCalc(sec)
{
	new mins = 0;
	sec = gettime() - sec;
	while(sec >= 60)
	{
		sec -= 60;
		mins++;
	}
	return mins;
}

stock GetAllReports()
{
	new string[1024], reportAmount = 0;
	for(new i = 0; i < MAX_PLAYERS * MAX_REPORTS_PER_PLAYER; i++)
	{
		if(reportAmount >= MAX_REPORTS_TO_SHOW)
		{
			break;
		}
		if(p_reports[i][p_playerid] != -1)
		{
			DialogOverview[reportAmount] = i;
			reportAmount++;
			if(strlen(string) == 0)
			{
				// REPORT ID - PlayerID_Name(playerid) - TargetID_Name(targetid), Reason
				if(strlen(p_reports[i][p_reason]) <= MAX_REPORT_LEN_TO_SHOW)
				{
					format(string, sizeof(string), "%d\t%s(%d)\t%s(%d)\t%s(%d mins ago)", i, PlayerName(p_reports[i][p_playerid]), p_reports[i][p_playerid], PlayerName(p_reports[i][p_targetid]), p_reports[i][p_targetid], p_reports[i][p_reason], MinCalc(p_reports[i][p_time]));
				}
				else
				{
					new tmpstring[22];
					strmid(tmpstring, p_reports[i][p_reason], 0, MAX_REPORT_LEN_TO_SHOW - 2, sizeof(tmpstring) - 2);
					format(tmpstring, sizeof(tmpstring), "%s..", tmpstring);
					format(string, sizeof(string), "%d\t%s(%d)\t%s(%d)\t%s(%d mins ago)", i, PlayerName(p_reports[i][p_playerid]), p_reports[i][p_playerid], PlayerName(p_reports[i][p_targetid]), p_reports[i][p_targetid], tmpstring, MinCalc(p_reports[i][p_time]));
				}
			}
			else
			{
				if(strlen(p_reports[i][p_reason]) <= MAX_REPORT_LEN_TO_SHOW)
				{
					format(string, sizeof(string), "%s\n%d\t%s(%d)\t%s(%d)\t%s(%d mins ago)", string, i, PlayerName(p_reports[i][p_playerid]), p_reports[i][p_playerid], PlayerName(p_reports[i][p_targetid]), p_reports[i][p_targetid], p_reports[i][p_reason], MinCalc(p_reports[i][p_time]));
				}
				else
				{
					new tmpstring[22];
					strmid(tmpstring, p_reports[i][p_reason], 0, MAX_REPORT_LEN_TO_SHOW - 2, sizeof(tmpstring) - 2);
					format(tmpstring, sizeof(tmpstring), "%s..", tmpstring);
					format(string, sizeof(string), "%s\n%d\t%s(%d)\t%s(%d)\t%s(%d mins ago)", string, i, PlayerName(p_reports[i][p_playerid]), p_reports[i][p_playerid], PlayerName(p_reports[i][p_targetid]), p_reports[i][p_targetid], tmpstring, MinCalc(p_reports[i][p_time]));
				}
			}
		}
	}
	format(string, sizeof(string), "ReportID\tPlayer Name\tReported Name\tReason\n%s", string);
	return string;
}

/*
	Returns the string that is used when using /myreports. Figured I might need it else where as well
*/

stock GetReportsForPlayer(playerid)
{
	new string[512];
	for(new i = 0; i < MAX_REPORTS_PER_PLAYER; i++)
	{
		if(Player_Reports[playerid][i] != -1)
		{
			// Keep control if there are any active reports for this player, so that he may delete them later in his /myreports
			DialogOverviewPlayer[playerid][i] = Player_Reports[playerid][i];
			if(strlen(string) == 0)
			{
				if(strlen(p_reports[Player_Reports[playerid][i]][p_reason]) <= MAX_REPORT_LEN_TO_SHOW)
				{
					format(string, sizeof(string), "%d\tYou\t%s(%d)\t%s(%d mins ago)", Player_Reports[playerid][i], PlayerName(p_reports[Player_Reports[playerid][i]][p_targetid]), p_reports[Player_Reports[playerid][i]][p_targetid], p_reports[Player_Reports[playerid][i]][p_reason], MinCalc(p_reports[Player_Reports[playerid][i]][p_time]));
				}
				else
				{
					new tmpstring[22];
					strmid(tmpstring, p_reports[Player_Reports[playerid][i]][p_reason], 0, MAX_REPORT_LEN_TO_SHOW - 2, sizeof(tmpstring) - 2);
					format(tmpstring, sizeof(tmpstring), "%s..", tmpstring);
					format(string, sizeof(string), "%d\tYou\t%s(%d)\t%s(%d mins ago)", Player_Reports[playerid][i], PlayerName(p_reports[Player_Reports[playerid][i]][p_targetid]), p_reports[Player_Reports[playerid][i]][p_targetid], tmpstring, MinCalc(p_reports[Player_Reports[playerid][i]][p_time]));
				}
				
			}
			else
			{
				if(strlen(p_reports[Player_Reports[playerid][i]][p_reason]) <= MAX_REPORT_LEN_TO_SHOW)
				{
					format(string, sizeof(string), "%s\n%d\tYou\t%s(%d)\t%s(%d mins ago)", string, Player_Reports[playerid][i], PlayerName(p_reports[Player_Reports[playerid][i]][p_targetid]), p_reports[Player_Reports[playerid][i]][p_targetid], p_reports[Player_Reports[playerid][i]][p_reason], MinCalc(p_reports[Player_Reports[playerid][i]][p_time]));
				}
				else
				{
					new tmpstring[22];
					strmid(tmpstring, p_reports[Player_Reports[playerid][i]][p_reason], 0, MAX_REPORT_LEN_TO_SHOW - 2, sizeof(tmpstring) - 2);
					format(tmpstring, sizeof(tmpstring), "%s..", tmpstring);
					format(string, sizeof(string), "%s\n%d\tYou\t%s(%d)\t%s(%d mins ago)", string, Player_Reports[playerid][i], PlayerName(p_reports[Player_Reports[playerid][i]][p_targetid]), p_reports[Player_Reports[playerid][i]][p_targetid], tmpstring, MinCalc(p_reports[Player_Reports[playerid][i]][p_time]));
				}
			}
		}
	}
	format(string, sizeof(string), "ReportID\tPlayer Name\tReported Name\tReason\n%s", string);
	return string;
}




/*
	COMMANDS
*/
CMD:report(playerid, params[])
{
	new targetid, string[128], reason[128];
    if (sscanf(params, "us[128]", targetid, reason)) 
	{
		format(string, sizeof(string), "[USAGE]: {%06x}/report {%06x}[ID/Name] [Reason]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		return SendClientMessage(playerid, COLOR_SYNTAX, string);
    }
    if(Player_Active_Reports[playerid] >= 3)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have reached the max amount of reports. Use /myreports to delete an old if something went wrong.");
	}
	for(new i = 0; i < MAX_REPORTS_PER_PLAYER; i++)
	{
		if(Player_Reports[playerid][i] != -1)
		{
			if((gettime() - p_reports[Player_Reports[playerid][i]][p_time]) <= REPORT_DELAY)
			{
				format(string, sizeof(string), "[ERROR]: You have to wait %d seconds between each time you use /report.", REPORT_DELAY);
				return SendClientMessage(playerid, COLOR_WARNING, string);
			}
		}
	}
	
    if(IsPlayerConnected(targetid)) 
	{
		for(new i = 0; i < MAX_PLAYERS * MAX_REPORTS_PER_PLAYER; i++)
		{
			if(p_reports[i][p_playerid] == -1)
			{
				p_reports[i][p_playerid] = playerid;
				p_reports[i][p_targetid] = targetid;
				p_reports[i][p_time] = gettime();
				p_reports[i][p_reason] = reason;
				for(new j = 0; j < MAX_REPORTS_PER_PLAYER; j++)
				{
					if(Player_Reports[playerid][j] == -1)
					{
						Player_Reports[playerid][j] = i;
						break;
					}
				}
				
				format(string, sizeof(string), "[REPORT %d]: %s(%d) has reported %s(%d), Reason: %s", i, PlayerName(playerid), playerid, PlayerName(targetid), targetid, reason);
	            SendReportMessage(1, string);
				ReportLog(string);
				Player_Active_Reports[playerid]++;

	            format(string, sizeof(string), "[RepID: %d] - You have reported %s(%d), Reason: %s", i, PlayerName(targetid), targetid, reason);
	            SendClientMessage(playerid, COLOR_WHITE, string);
				GiveAchievement(playerid, 100);

				new query[256], reporter_ip[16], reported_ip[16];
				GetPlayerIp(playerid, reporter_ip, sizeof(reporter_ip));
				GetPlayerIp(targetid, reported_ip, sizeof(reported_ip));
				mysql_real_escape_string(reason, reason);
				format(query, sizeof(query), "INSERT INTO `FoCo_Reports` (fr_reporter_id, fr_reported_id, fr_reason, fr_reporter_ip, fr_reported_ip) VALUES ('%d', '%d', '%s', '%s', '%s')", FoCo_Player[playerid][id], FoCo_Player[targetid][id], reason, reporter_ip, reported_ip);
				mysql_query(query, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
				return 1;
			}
		}
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Something went wrong, please report this on the forums, or via PM to a developer.");
    }
    else
    {
    	return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is no-one logged in that has that ID/Name");
    }
}

CMD:myreports(playerid, params[])
{
	if(Player_Active_Reports[playerid] == 0)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have no active reports.");
	}
	new string[512];
	string = GetReportsForPlayer(playerid);
	ShowPlayerDialog(playerid, DIALOG_REPORT_VIEW_PLAYER, DIALOG_STYLE_TABLIST_HEADERS, "My Reports", string, "Delete", "Close");
	return 1;
}

CMD:ar(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_AR))
	{
		new report_id, string[128];
		if (sscanf(params, "d", report_id))
		{
			format(string, sizeof(string), "[USAGE]: {%06x}/ar {%06x}[report_id]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			return 1;
		}

		if(p_reports[report_id][p_playerid] == -1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No such report exists, or another admin just accepted it.");
		}
		AcceptReport(playerid, report_id);
	}
	return 1;
}

CMD:dr(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_DR))
	{
		new report_id, string[128];
		if (sscanf(params, "d", report_id))
		{
			format(string, sizeof(string), "[USAGE]: {%06x}/dr {%06x}[report_id]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			return 1;
		}

		if(p_reports[report_id][p_playerid] == -1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No such report exists, or another admin just accepted it.");
		}
		DeleteReport(playerid, report_id);
	}
	return 1;
}

CMD:reports(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_REPORTS))
	{
		new string[1024];
		string = GetAllReports();
		ShowPlayerDialog(playerid, DIALOG_REPORT_VIEW, DIALOG_STYLE_TABLIST_HEADERS, "Report System", string, "View", "Close");
	}
	return 1;
}

#if defined PTS
CMD:player_reports(playerid, params[])
{
	new targetid;
	if(sscanf(params, "u", targetid))
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerID");
	}
	for(new i = 0; i < MAX_REPORTS_PER_PLAYER; i++)
	{
		new string[5];
		format(string, sizeof(string), "%d", Player_Reports[targetid][i]);
		DebugMsg(string);
	}
	return 1;
}

CMD:all_reports(playerid, params[])
{
	new start, end;
	if(sscanf(params, "ii", start, end))
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Start or end.");
	}
	for(new i = start; i < end; i++)
	{
		new string[12];
		format(string, sizeof(string), "[%d]: %d", i, p_reports[i][p_playerid]);
		DebugMsg(string);
	}
	return 1;
}

CMD:active_reports(playerid, params[])
{
	new targetid;
	if(sscanf(params, "u", targetid))
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid name/ID");
	}
	new string[12];
	format(string, sizeof(string), "[%d]: %d", targetid, Player_Active_Reports[targetid]);
	DebugMsg(string);
	return 1;
}
#endif
