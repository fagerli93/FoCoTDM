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
* Filename: pEar_mute.pwn                                                        *
* Author: pEar - Credits to FKu for most of the /mutelist. Edited by me.	     *
*********************************************************************************/

#define MUTEL_DIALOG 510
#include <YSI\y_hooks>

/*

	Added to variables.pwn as some external files were whining.

enum muted_info {
	muted,					// Toggles if muted or not.
	mutedBy,				// Stores the admin that muted a player -> -1 if muted due to spam.
	muteTime,				// Stores time (unixtime) of when a player was muted.
	unmuteTime,				// Stores mute time in minutes
	spam 					// Stores spam amount
};

new mutedPlayers[MAX_PLAYERS][muted_info];
*/

forward mutePlayer(m_playerid, m_admin, m_time);
forward unmutePlayer(m_playerid, m_admin);          


new Timer:mutedPlayersTimer[MAX_PLAYERS];

CMD:mutelist(playerid,params)
{
 	if(IsAdmin(playerid, 1) || IsTrialAdmin(playerid))
 	{
	 	new text2[156],text[512];
	 	new count;
		foreach (new i : Player)
		{
			new mutedtime;
			if(mutedPlayers[i][muted]  == 1)
			{
			    if (mutedPlayers[i][mutedBy] != -1)
			    {
					mutedtime = (gettime() - mutedPlayers[i][muteTime])/60;
					format(text2,sizeof(text2),"%s(%d)\t%s(%d)\t%d Mins ago\t%d Mins\n",PlayerName(i), i, PlayerName(mutedPlayers[i][mutedBy]), mutedPlayers[i][mutedBy], mutedtime, mutedPlayers[i][unmuteTime]);
					strcat(text,text2,sizeof(text));
					count++;
				}
				else
				{
				    format(text2,sizeof(text2),"%s(%d)\tThe Guardian\t%d Mins ago\t%d Mins\n", PlayerName(i), i, mutedtime, mutedPlayers[i][unmuteTime]);
					strcat(text,text2,sizeof(text));
					count++;
				}
			}
		}
		format(text, sizeof(text), "Player\tAdmin\tMute Time\tUnmute Time\n%s", text);
		ShowPlayerDialog(playerid,MUTEL_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "Muted Players",text,"Close", "");
		if (count == 0)
		{
		    SendClientMessage(playerid,COLOR_WARNING, "[ERROR]: Ain't nobody's mouth stuffed with cock.");
		}
	}
	return 1;
}

CMD:mute(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_MUTE) || IsTrialAdmin(playerid))
	{
		new targetid, time;
		if (sscanf(params, "ui", targetid, time))
		{
			if(!sscanf(params, "u", targetid))
			{
				if(targetid == INVALID_PLAYER_ID)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
					return 1;
				}
				mutePlayer(targetid, playerid, -1);
				return 1;
			}
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /mute [ID/Name] [Time (In minutes)]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		mutePlayer(targetid, playerid, time);
		return 1;
		
	}
	return 1;
}

CMD:unmute(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_UNMUTE) || IsTrialAdmin(playerid))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /unmute [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		unmutePlayer(targetid, playerid);
	}
	return 1;
}

timer timer_mutePlayer[10000](playerid)
{
	mutedPlayers[playerid][muted] = 0;
	mutedPlayers[playerid][spam] = 0;
	mutedPlayers[playerid][muteTime] = 0;
	mutedPlayers[playerid][mutedBy] = 0;
	mutedPlayers[playerid][unmuteTime] = 0;
	if(IsPlayerConnected(playerid))
	{
		new string[128];
		format(string, sizeof(string), "[AdmCMD]: You have been automatically unmuted due to your mute time being over.");
		SendClientMessage(playerid, COLOR_NOTICE, string);
		format(string, sizeof(string), "%s(%d) has been auto-unmuted due to time.", PlayerName(playerid), playerid);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		format(string, sizeof(string), "[INFO]: %s was auto-unmuted", PlayerName(playerid));
		SendClientMessageToAll(COLOR_RED, string);
	}
	return 1;
}

public unmutePlayer(m_playerid, m_admin)
{
	new string[128];
	if(m_admin == -1)
	{
		format(string, sizeof(string), "[AdmCMD]: The Guardian has auto-unmuted you.");
		SendClientMessage(m_playerid, COLOR_NOTICE, string);
		format(string, sizeof(string), "AdmCmd(%d): The Guardian has auto-unmuted %s", ACMD_UNMUTE, PlayerName(m_playerid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_UNMUTE,string);

		format(string, sizeof(string), "[INFO]: %s was unmuted", PlayerName(m_playerid));
		SendClientMessageToAll(COLOR_RED, string);

		mutedPlayers[m_playerid][muted] = 0;
		mutedPlayers[m_playerid][spam] = 0;
		mutedPlayers[m_playerid][muteTime] = 0;
		mutedPlayers[m_playerid][mutedBy] = 0;
		mutedPlayers[m_playerid][unmuteTime] = 0;
		stop mutedPlayersTimer[m_playerid];
	}
	else if(m_admin == -2) {
		format(string, sizeof(string), "[AdmCMD]: An admin on IRC has unmuted you.");
		SendClientMessage(m_playerid, COLOR_NOTICE, string);
		format(string, sizeof(string), "[IRC] AdmCmd(%d): The Guardian has unmuted %s", ACMD_UNMUTE, PlayerName(m_playerid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_UNMUTE,string);

		format(string, sizeof(string), "[INFO]: %s was unmuted", PlayerName(m_playerid));
		SendClientMessageToAll(COLOR_RED, string);

		mutedPlayers[m_playerid][muted] = 0;
		mutedPlayers[m_playerid][spam] = 0;
		mutedPlayers[m_playerid][muteTime] = 0;
		mutedPlayers[m_playerid][mutedBy] = 0;
		mutedPlayers[m_playerid][unmuteTime] = 0;
		stop mutedPlayersTimer[m_playerid];
	}
	else 
	{
		if(m_admin != INVALID_PLAYER_ID)
		{
			format(string, sizeof(string), "[AdmCMD]: %s %s has unmuted you.", GetPlayerStatus(m_admin), PlayerName(m_admin));
			SendClientMessage(m_playerid, COLOR_NOTICE, string);
			format(string, sizeof(string), "AdmCmd(%d): %s %s has unmuted %s", ACMD_UNMUTE,GetPlayerStatus(m_admin), PlayerName(m_admin), PlayerName(m_playerid));
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendAdminMessage(ACMD_UNMUTE,string);
		}

		format(string, sizeof(string), "[INFO]: %s was unmuted", PlayerName(m_playerid));
		SendClientMessageToAll(COLOR_RED, string);

		mutedPlayers[m_playerid][muted] = 0;
		mutedPlayers[m_playerid][spam] = 0;
		mutedPlayers[m_playerid][muteTime] = 0;
		mutedPlayers[m_playerid][mutedBy] = 0;
		mutedPlayers[m_playerid][unmuteTime] = 0;
		stop mutedPlayersTimer[m_playerid];
	}
	return 1;
}


public mutePlayer(m_playerid, m_admin, m_time)
{
	//Avoiding multiple mute Timers
	if(mutedPlayers[m_playerid][muted]  == 1)
	{
		stop mutedPlayersTimer[m_playerid];		
	}
	new string[128];
	if(m_admin == -1)
	{	
		// Permanent mute by the guardian.
		if(m_time == -1)
		{
			format(string, sizeof(string), "[AdmCMD]: The Guardian has auto-permanently muted you");
			SendClientMessage(m_playerid, COLOR_NOTICE, string);
			format(string, sizeof(string), "AdmCmd(%d): The Guardian has auto-permanently muted %s", ACMD_MUTE, PlayerName(m_playerid));
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendAdminMessage(ACMD_MUTE,string);
			format(string, sizeof(string), "[INFO]: %s was muted permanently by The Guardian", PlayerName(m_playerid));
			SendClientMessageToAll(COLOR_RED, string);
			format(string, sizeof(string), "MUTE: The Guardian auto-muted %s (%d) permanently", PlayerName(m_playerid), m_playerid);
			AdminLog(string);
			mutedPlayers[m_playerid][muted] = 1;
			mutedPlayers[m_playerid][mutedBy] = -1;
			mutedPlayers[m_playerid][muteTime] = gettime();
			mutedPlayers[m_playerid][unmuteTime] = -1;
		}
		else // Temporary mute by the guardian
		{
			format(string, sizeof(string), "[AdmCMD]: The Guardian has auto-muted you for %d minute(s).", m_time);
			SendClientMessage(m_playerid, COLOR_NOTICE, string);
			format(string, sizeof(string), "AdmCmd(%d): The Guardian has auto-muted %s for %d minute(s).", ACMD_MUTE, PlayerName(m_playerid), m_time);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendAdminMessage(ACMD_MUTE,string);
			format(string, sizeof(string), "[INFO]: %s was auto-muted for %d minute(s) by The Guardian ", PlayerName(m_playerid), m_time);
			SendClientMessageToAll(COLOR_RED, string);
			format(string, sizeof(string), "MUTE: The Guardian auto-muted %s (%d) for %d minute(s).", PlayerName(m_playerid), m_playerid, m_time);
			AdminLog(string);	
			mutedPlayers[m_playerid][muted] = 1;
			mutedPlayers[m_playerid][mutedBy] = -1;
			mutedPlayers[m_playerid][muteTime] = gettime();
			mutedPlayers[m_playerid][unmuteTime] = m_time;

			mutedPlayersTimer[m_playerid] = defer timer_mutePlayer[m_time * 60000](m_playerid);
		}
	}
	else if(m_admin == -2)
	{
		if(m_time == -1)
		{
			format(string, sizeof(string), "[AdmCMD]: An admin on IRC has auto-permanently muted you");
			SendClientMessage(m_playerid, COLOR_NOTICE, string);
			format(string, sizeof(string), "[IRC] AdmCmd(%d): The Guardian has auto-permanently muted %s", ACMD_MUTE, PlayerName(m_playerid));
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendAdminMessage(ACMD_MUTE,string);
			format(string, sizeof(string), "[INFO]: %s was muted permanently by The Guardian", PlayerName(m_playerid));
			SendClientMessageToAll(COLOR_RED, string);
			format(string, sizeof(string), "[IRC] MUTE: The Guardian auto-muted %s (%d) permanently", PlayerName(m_playerid), m_playerid);
			AdminLog(string);
			mutedPlayers[m_playerid][muted] = 1;
			mutedPlayers[m_playerid][mutedBy] = -1;
			mutedPlayers[m_playerid][muteTime] = gettime();
			mutedPlayers[m_playerid][unmuteTime] = -1;
		}
		else // Temporary mute by the guardian
		{
			format(string, sizeof(string), "[AdmCMD]: An admin on IRC has auto-muted you for %d minute(s).", m_time);
			SendClientMessage(m_playerid, COLOR_NOTICE, string);
			format(string, sizeof(string), "AdmCmd(%d): The Guardian has auto-muted %s for %d minute(s).", ACMD_MUTE, PlayerName(m_playerid), m_time);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendAdminMessage(ACMD_MUTE,string);
			format(string, sizeof(string), "[INFO]: %s was auto-muted for %d minute(s) by The Guardian ", PlayerName(m_playerid), m_time);
			SendClientMessageToAll(COLOR_RED, string);
			format(string, sizeof(string), "[IRC] MUTE: The Guardian auto-muted %s (%d) for %d minute(s).", PlayerName(m_playerid), m_playerid, m_time);
			AdminLog(string);	
			mutedPlayers[m_playerid][muted] = 1;
			mutedPlayers[m_playerid][mutedBy] = -1;
			mutedPlayers[m_playerid][muteTime] = gettime();
			mutedPlayers[m_playerid][unmuteTime] = m_time;

			mutedPlayersTimer[m_playerid] = defer timer_mutePlayer[m_time * 60000](m_playerid);
		}
	}
	else
	{
		// Permanent mute by admin.
		if(m_time == -1)
		{
			if(m_admin != INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "[AdmCMD]: %s %s has permanently muted you", GetPlayerStatus(m_admin), PlayerName(m_admin));
				SendClientMessage(m_playerid, COLOR_NOTICE, string);
				format(string, sizeof(string), "AdmCmd(%d): %s %s has permanently muted %s", ACMD_MUTE,GetPlayerStatus(m_admin), PlayerName(m_admin), PlayerName(m_playerid));
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
				SendAdminMessage(ACMD_MUTE,string);
				format(string, sizeof(string), "MUTE: %s (%d) muted %s (%d) permanently", PlayerName(m_admin), m_admin, PlayerName(m_playerid), m_playerid);
				AdminLog(string);
			}

			format(string, sizeof(string), "[INFO]: %s was muted permanently", PlayerName(m_playerid));
			SendClientMessageToAll(COLOR_RED, string);
			mutedPlayers[m_playerid][muted] = 1;
			mutedPlayers[m_playerid][mutedBy] = m_admin;
			mutedPlayers[m_playerid][muteTime] = gettime();
			mutedPlayers[m_playerid][unmuteTime] = -1;
		}
		else // Temporary mute by admin
		{
			if(m_admin != INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "[AdmCMD]: %s %s has muted you for %d minute(s).", GetPlayerStatus(m_admin), PlayerName(m_admin), m_time);
				SendClientMessage(m_playerid, COLOR_NOTICE, string);
				format(string, sizeof(string), "AdmCmd(%d): %s %s has muted %s for %d minute(s).", ACMD_MUTE, GetPlayerStatus(m_admin), PlayerName(m_admin), PlayerName(m_playerid), m_time);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
				SendAdminMessage(ACMD_MUTE,string);
				format(string, sizeof(string), "MUTE: %s (%d) muted %s (%d) for %d minute(s).", PlayerName(m_admin), m_admin, PlayerName(m_playerid), m_playerid, m_time);
				AdminLog(string);	
			}
			format(string, sizeof(string), "[INFO]: %s was muted for %d minute(s).", PlayerName(m_playerid), m_time);
			SendClientMessageToAll(COLOR_RED, string);
			mutedPlayers[m_playerid][muted] = 1;
			mutedPlayers[m_playerid][mutedBy] = m_admin;
			mutedPlayers[m_playerid][muteTime] = gettime();
			mutedPlayers[m_playerid][unmuteTime] = m_time;

			mutedPlayersTimer[m_playerid] = defer timer_mutePlayer[m_time * 60000](m_playerid);
		}
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(mutedPlayers[playerid][muted]  == 1)
	{
		new s_string[128];
		format(s_string, sizeof(s_string), "[GUADIAN]: %s(%i) has logged while being muted.", PlayerName(playerid), playerid);
		SendAdminMessage(1, s_string);
		mutedPlayers[playerid][muted] = 0;
		mutedPlayers[playerid][spam] = 0;
		mutedPlayers[playerid][muteTime] = 0;
		mutedPlayers[playerid][mutedBy] = 0;
		mutedPlayers[playerid][unmuteTime] = 0;
		stop mutedPlayersTimer[playerid];
	}
	return 1;
}

hook OnPlayerConnect(playerid, reason)
{
	mutedPlayers[playerid][muted] = 0;
	mutedPlayers[playerid][spam] = 0;
	mutedPlayers[playerid][muteTime] = 0;
	mutedPlayers[playerid][mutedBy] = 0;
	mutedPlayers[playerid][unmuteTime] = 0;
	lastMessage[playerid] = 0;
	return 1;
}
