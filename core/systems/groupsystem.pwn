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
* Filename:  groupsystem.pwn                                                     *
* Author:  	 dr_vista       													 *
*********************************************************************************/

/* Includes */

#include <YSI\y_hooks>

/* Defines */

#define MAX_GROUPS 20
#define MAX_GROUP_MEMBERS 20
#define GROUP_NAME_LENGTH 30
#define MIN_GRI_SEC 5

/* Main group variable */

enum e_Group
{
	gs_dbid,
	gs_name[GROUP_NAME_LENGTH],
	gs_leader,
	gs_leader_name[MAX_PLAYER_NAME],
	gs_member[MAX_GROUP_MEMBERS],
	gs_members,
	bool:gs_isperm
}

static
		gGroups[MAX_GROUPS][e_Group];

/*  SQL Threads enum */

enum
{
	MYSQL_SETLEADER = 89,
	MYSQL_LOADGROUPS,
	MYSQL_INSERTGROUP,
	MYSQL_QUERYUPDATEID,
	MYSQL_SELECTGROUP,
	MYSQL_DELETEGROUP
}		
		
/* Variables */

static
		PlayerGroupID[MAX_PLAYERS], /* -1 = No group. Any other number is the player's group ID */
		PlayerInvited[MAX_PLAYERS],
		PlayerJoinRequest[MAX_PLAYERS];
		
static
		groupsenabled;
new GroupLastInvite[MAX_PLAYERS]; //To Avoid /gri spam
new GroupLastJoin[MAX_PLAYERS]; //To Avoid /grj Spam
/* Forwards */
		
forward ResetGroup(groupid);
forward SendGroupMessage(groupid, senderid, msg[]);
forward SendGroupLeaderMessage(groupid, msg[]);
forward PlayerJoinGroup(playerid, groupid);
forward PlayerRequestedJoin(playerid, groupid);
forward PlayerLeftGroup(playerid, groupid);
forward SetGroupLeader(playerid, groupid);
forward ShowPlayerGroupList(playerid, groupid);
//forward GroupChatLog(string[]);

/* Callback hooks */

hook OnGameModeInit()
{
	for(new i = 0; i < MAX_GROUPS; i++)
	{
		ResetGroup(i);
	}
	
	groupsenabled = 1;
	//mysql_query("SELECT * FROM FoCo_Groups", MYSQL_LOADGROUPS, 0, con);
}

hook OnPlayerConnect(playerid)
{
	PlayerGroupID[playerid] = -1;
	PlayerInvited[playerid] = -1;
	PlayerJoinRequest[playerid] = -1;
	GroupLastInvite[playerid] = 0;
	GroupLastJoin[playerid] = 0;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(PlayerGroupID[playerid] != -1)
	{
		PlayerLeftGroup(playerid, PlayerGroupID[playerid]);
	}
}

forward G_OnQueryFinish(query[], resultid, extraid, connectionHandle);
public G_OnQueryFinish(query[], resultid, extraid, connectionHandle)
{
	switch(resultid)
	{
		case MYSQL_SETLEADER: return 1;

		case MYSQL_LOADGROUPS:
		{
			new 
				idx = extraid;
			
			mysql_store_result();
			
			new
				tmp_gdbidstr,
				tmp_gname[30],
				tmp_gleadname[24],
				results[200];
				
			while(mysql_fetch_row(results))
			{
				
				sscanf(results, "p<|>ds[30]s[24]", tmp_gdbidstr, tmp_gname, tmp_gleadname);
				
				gGroups[idx][gs_dbid] = tmp_gdbidstr;
			
				strcat(gGroups[idx][gs_name], tmp_gname);
				strcat(gGroups[idx][gs_leader_name], tmp_gleadname);
				
				gGroups[idx][gs_isperm] = true;
				
				idx++;
				
				if(idx >= MAX_GROUPS)
				{
					printf("Group error: max groups reached.");
					break;
				}
			}
			
			mysql_free_result();
		}
		
		case MYSQL_INSERTGROUP:
		{
			if(mysql_errno() == 0)
			{
				gGroups[extraid][gs_dbid] = mysql_insert_id();
			}
		}
		
		case MYSQL_DELETEGROUP:
		{
			if(gGroups[extraid][gs_members] == 0)
			{
				ResetGroup(extraid);
			}
		}
	}
	
	return 1;
}

/* Functions */

public ResetGroup(groupid)
{
	gGroups[groupid][gs_name][0] = ' ';
	gGroups[groupid][gs_leader] = -1;
	
	for(new j = 0; j < MAX_GROUP_MEMBERS; j++)
	{
		gGroups[groupid][gs_member][j] = -1;
	}
	
	gGroups[groupid][gs_members] = 0;
	
	return 1;
}

public SendGroupMessage(groupid, senderid, msg[])
{
	new
		string[128],
		leaderstr[128];
	

	if(senderid != -1)
	{
		if(gGroups[groupid][gs_leader] == senderid)
		{
			format(string, sizeof(string), "[GROUP]: {%06x}Leader ", COLOR_YELLOW >>> 8); 
		}
		
		else
		{
			string = "[GROUP]: ";
		}


		format(leaderstr, sizeof(leaderstr), "{%06x}%s (%d): {%06x}%s", COLOR_GLOBALNOTICE >>> 8, PlayerName(senderid), senderid, COLOR_WHITE >>> 8, msg);
		
		strcat(string, leaderstr);
		//IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		//GroupChatLog(string);
	}
	
	else
	{
		format(string, sizeof(string), "[GROUP]: %s ", msg);
	}
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	for(new i = 0; i < MAX_GROUP_MEMBERS; i++)
	{
		if(gGroups[groupid][gs_member][i] != -1)
		{
			SendClientMessage(gGroups[groupid][gs_member][i], COLOR_NEWOOC , string);
		}
	}
}

public SendGroupLeaderMessage(groupid, msg[])
{
	SendClientMessage(gGroups[groupid][gs_leader], COLOR_NEWOOC, msg);
}

public PlayerJoinGroup(playerid, groupid)
{
	new
		string[128];
		
	gGroups[groupid][gs_members]++;
	
	for(new i = 0; i < MAX_GROUP_MEMBERS; i++)
	{
		if(gGroups[groupid][gs_member][i] == -1)
		{
			gGroups[groupid][gs_member][i] = playerid;
			break;
		}
	}
	
	PlayerInvited[playerid] = -1;
	PlayerJoinRequest[playerid] = -1;
	
	PlayerGroupID[playerid] = groupid;
	
	format(string, sizeof(string), "%s (%d) has joined the group.", PlayerName(playerid), playerid);
	SendGroupMessage(groupid, -1, string);
	SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Use /gm to chat in the group.");

	if(gGroups[groupid][gs_isperm] == true && !strcmp(PlayerName(playerid), gGroups[groupid][gs_leader_name]))
	{
		SetGroupLeader(playerid, groupid);
	}
}

public PlayerRequestedJoin(playerid, groupid)
{
	new 
		string[128];
	
	PlayerJoinRequest[playerid] = groupid;
	
	format(string, sizeof(string), "[GROUP]: You have requested to join group %s (%d).", gGroups[groupid][gs_name], groupid);
	SendClientMessage(playerid, COLOR_LIGHTORANGE, string);
	
	format(string, sizeof(string), "[GROUP]: %s (%d) has requested to join your group. /gri %s to add him.", PlayerName(playerid), playerid, PlayerName(playerid));
	SendGroupLeaderMessage(groupid, string);
}

public PlayerLeftGroup(playerid, groupid)
{
	if(gGroups[groupid][gs_members] == 1 && gGroups[groupid][gs_isperm] == false)
	{
		PlayerGroupID[playerid] = -1;
		return ResetGroup(groupid);
	}
	
	else
	{
		new
			string[128];
		
		format(string, sizeof(string), "%s (%d) has left the group.", PlayerName(playerid), playerid);		
	
		SendGroupMessage(groupid, -1, string);
				
		gGroups[groupid][gs_members]--;
		
		for(new i = 0; i < MAX_GROUP_MEMBERS; i++)
		{
			if(playerid == gGroups[groupid][gs_member][i])
			{
				gGroups[groupid][gs_member][i] = -1;					
				break;
			}
		}
		
		PlayerGroupID[playerid] = -1;
		
		if(gGroups[groupid][gs_leader] == playerid)
		{
			for(new i = 0; i < MAX_GROUP_MEMBERS; i++)
			{
				if(gGroups[groupid][gs_member][i] != -1)
				{					
					SetGroupLeader(gGroups[groupid][gs_member][i], groupid);
					break;
				}
			}
		}
	}
	
	return 1;
}

public SetGroupLeader(playerid, groupid)
{
	new
		string[128];
		
	gGroups[groupid][gs_leader] = playerid;
	
	format(string, sizeof(string), "%s (%d) is the new group leader.", PlayerName(playerid), playerid);
	SendGroupMessage(groupid, -1, string);
	
	if(gGroups[groupid][gs_isperm] == true)
	{
		new
			query[128];
		
		format(query, sizeof(query), "UPDATE `FoCo_Groups` SET `group_leader` = '%s' WHERE `ID` = '%d'", PlayerName(playerid), gGroups[groupid][gs_dbid]);
		mysql_query(query, MYSQL_SETLEADER, playerid, con);
	}
}

public ShowPlayerGroupList(playerid, groupid)
{
	new 
		string[50],
		memberstr[640],
		groupstr[64];
	
	format(string, sizeof(string), "{%06x}Leader: %s{%06x} (%d)\n", COLOR_YELLOW >>> 8, PlayerName(gGroups[groupid][gs_leader]),COLOR_WHITE >>> 8, gGroups[groupid][gs_leader]);
	strcat(memberstr, string);
	
	for(new i = 0; i < MAX_GROUP_MEMBERS; i++)
	{
		if(gGroups[groupid][gs_member][i] != -1 && gGroups[groupid][gs_member][i] != gGroups[groupid][gs_leader])
		{
			format(string, sizeof(string), "%s (%d)\n", PlayerName(gGroups[groupid][gs_member][i]), gGroups[groupid][gs_member][i]);
			strcat(memberstr, string);
		}
	}
	
	format(groupstr, sizeof(groupstr), "Group {%06x}%s's {%06x}member list:" ,COLOR_ADMIN >>> 8, gGroups[groupid][gs_name], COLOR_WHITE >>> 8);
	ShowPlayerDialog(playerid, DIALOG_GROUP_LIST, DIALOG_STYLE_MSGBOX, groupstr, memberstr, "Close", "");
}
/*
static GroupChatLog(string[])
{
    new entry[150];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/groupchat.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
	
	return 1;
}
*/
/* Commands */

CMD:groupcreate(playerid, params[])
{
	new 
		name[GROUP_NAME_LENGTH];
		
	if(sscanf(params, "s[30]", name))
	{
		return SendClientMessage(playerid, COLOR_NOTICE, "[USAGE]: /grc [Name]");
	}
	
	if(PlayerGroupID[playerid] != -1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're already in a group.");
	}
	
	for(new i = 0; i < MAX_GROUPS; i++)
	{
		if(!strcmp(name, gGroups[i][gs_name], true))
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This name is already taken.");
		}
	}
	
	new
		groupid = -1;

	for(new i = 0; i < MAX_GROUPS; i++)
	{
		if(gGroups[i][gs_members] == 0)
		{
			groupid = i;
			break;
		}
	}
	
	if(groupid == -1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Max amount of groups reached.");
	}	
	
	else
	{
		new
			string[128];
			
		format(gGroups[groupid][gs_name], GROUP_NAME_LENGTH, "%s", name);
		gGroups[groupid][gs_leader] = playerid;
		gGroups[groupid][gs_member][0] = playerid;
		gGroups[groupid][gs_members] = 1;
		PlayerGroupID[playerid] = groupid;
		
		PlayerInvited[playerid] = -1;
		PlayerJoinRequest[playerid] = -1;

		
		format(string, sizeof(string), "[INFO]: Successfully created group %s (%d).", gGroups[groupid][gs_name], groupid);
		SendClientMessage(playerid, COLOR_NOTICE, string);
	}
	
	return 1;
}

CMD:grc(playerid, params[])
{
	return cmd_groupcreate(playerid, params);
}

CMD:groupjoin(playerid, params[])
{
	if(NetStats_GetConnectedTime(playerid) - GroupLastJoin[playerid] < 10000)
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please wait 10 seconds before using /groupjoin command again.");
    GroupLastJoin[playerid] = NetStats_GetConnectedTime(playerid);
	new 
		groupname[30],
		groupid = -1;
	
	if(sscanf(params, "s[30]", groupname))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /grj [Name/ID]");
	}
	
	if(PlayerGroupID[playerid] != -1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Leave your group first before joining another one.");
	}
	
	if(IsNumeric(groupname))
	{
		new gid = strval(groupname);
		
		if(gid > MAX_GROUPS)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid group ID.");
		}
		
		if(gGroups[gid][gs_members] > 0)
		{
			groupid = gid;
		}
	}
	
	else
	{
		for(new i = 0; i < MAX_GROUPS; i++)
		{
			if(strcmp(groupname, gGroups[i][gs_name], true) == 0)
			{
				groupid = i;
				break;
			}
		}
		
	}
	
	if(groupid == -1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid group ID.");
	}
	
	else
	{
		if(gGroups[groupid][gs_members] == MAX_GROUP_MEMBERS)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The group is at full capacity.");
		}
		
		if(PlayerInvited[playerid] == groupid)
		{
			PlayerJoinGroup(playerid, groupid);
		}
		
		else
		{
			PlayerRequestedJoin(playerid, groupid);
		}
	}
	return 1;
}

CMD:grj(playerid, params[])
{
	return cmd_groupjoin(playerid, params);
}

CMD:groups(playerid, params[])
{
	new 
		count = 0,
		grstring[48 * MAX_GROUPS + 18] = "Groups:\n\n";
	
	for(new i = 0; i < MAX_GROUPS; i++)
	{
		if(gGroups[i][gs_members] > 0 || gGroups[i][gs_isperm] == true)
		{
			new
				string[48];
			
			format(string, sizeof(string), "%s (%d) [ID: %d]\n", gGroups[i][gs_name], gGroups[i][gs_members], i);
			strcat(grstring, string);
			count++;
		}
	}
	
	if(count == 0)
	{
		return SendClientMessage(playerid, COLOR_LIGHTORANGE, "No groups are created at the moment.");
	}
	
	ShowPlayerDialog(playerid, DIALOG_GROUP_LIST, DIALOG_STYLE_MSGBOX, "Group list:", grstring, "Close", "");
	
	return 1;
}

CMD:groupmessage(playerid, params[])
{
	new
		message[128];
		
	if(sscanf(params, "s[128]", message))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /gm [text]");
	}
	
	if(PlayerGroupID[playerid] == -1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're not in a group.");
	}
	
	else
	{
		SendGroupMessage(PlayerGroupID[playerid], playerid, message);
	}
	
	return 1;
}

CMD:groupmsg(playerid, params[])
{
	return cmd_groupmessage(playerid, params);
}

CMD:gm(playerid, params[])
{
	return cmd_groupmessage(playerid, params);
}

CMD:groupinvite(playerid, params[])
{
	new
		targetid;
	
	if(sscanf(params, "?<MATCH_NAME_PARTIAL=1>u", targetid))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /gri [ID/Name]");
	}
	
	if(targetid == INVALID_PLAYER_ID)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player not connected.");
	}
	
	if(targetid == cellmin)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Multiple matches found, be more specific.");
	}
	
	if(PlayerGroupID[playerid] == -1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be in a group to use this command.");
	}
	
	if(gettime() - GroupLastInvite[playerid] < MIN_GRI_SEC)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please wait 5 seconds before using this command again.");
	}
	
	else
	{
		if(gGroups[PlayerGroupID[playerid]][gs_leader] != playerid)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be the group leader to use this command.");
		}
		
		else
		{
			if(PlayerJoinRequest[targetid] == PlayerGroupID[playerid])
			{
				PlayerJoinGroup(targetid, PlayerGroupID[playerid]);
			}
			
			else
			{
				new
					string[128];
					
				PlayerInvited[targetid] = PlayerGroupID[playerid];
				
				format(string, sizeof(string), "[GROUP]: You have invited %s (%d) to join the group.", PlayerName(targetid), targetid);
				SendClientMessage(playerid, COLOR_LIGHTORANGE, string);
				GroupLastInvite[playerid] = gettime();
				format(string, sizeof(string), "[GROUP]: %s (%d) has invited you to join his group %s. /grj to join.", PlayerName(playerid), playerid, gGroups[PlayerGroupID[playerid]][gs_name]);
				SendClientMessage(targetid, COLOR_LIGHTORANGE, string);
			}	
		}
	}

	return 1;
}

CMD:gri(playerid, params[])
{
	return cmd_groupinvite(playerid, params);
}

CMD:grleave(playerid, params[])
{
	if(PlayerGroupID[playerid] == -1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be in a group to use this command.");
	}
	
	new
		string[128];
	
	format(string, sizeof(string), "[GROUP]: You have left group %s (%d).", gGroups[PlayerGroupID[playerid]][gs_name], PlayerGroupID[playerid]);
	SendClientMessage(playerid, COLOR_NEWOOC, string);
	PlayerLeftGroup(playerid, PlayerGroupID[playerid]);
	
	return 1;
}

CMD:grl(playerid, params[])
{
	return cmd_grleave(playerid, params);
}

CMD:grleader(playerid, params[])
{
	new
		targetid;
	
	if(sscanf(params, "?<MATCH_NAME_PARTIAL=1>u", targetid))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /grleader [ID/Name]");
	}
	
	if(targetid == INVALID_PLAYER_ID)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player not connected.");
	}
	
	if(targetid == cellmin)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Multiple matches found, be more specific.");
	}
	
	if(PlayerGroupID[playerid] == -1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be in a group to use this command.");
	}
	
	else
	{
		if(gGroups[PlayerGroupID[playerid]][gs_leader] != playerid)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be the group leader to use this command.");
		}
		
		if(PlayerGroupID[playerid] != PlayerGroupID[targetid])
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot give leadership to someone that's not in your group.");
		}	
		
		else
		{
			new
				string[128];
			
			format(string, sizeof(string), "[GROUP]: You have set %s as the group leader.", PlayerName(targetid));
			SendClientMessage(playerid, COLOR_NEWOOC, string);
			format(string, sizeof(string), "[GROUP]: %s (%d) has set you as the group leader.", PlayerName(playerid), playerid);
			SendClientMessage(targetid, COLOR_NEWOOC, string);
			SetGroupLeader(targetid, PlayerGroupID[playerid]);
		}
	}
	
	return 1;
}

CMD:grouplist(playerid, params[])
{
	new 
		groupname[30],
		groupid = -1;
	
	if(sscanf(params, "s[30]", groupname))
	{
		if(PlayerGroupID[playerid] != -1)
		{
			ShowPlayerGroupList(playerid, PlayerGroupID[playerid]);
		}
		
		else
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /grlist [Name/ID]");
		}
	}
	
	if(IsNumeric(groupname))
	{
		new gid = strval(groupname);
		
		if(gid > MAX_GROUPS)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid group ID.");
		}
		
		if(gGroups[gid][gs_members] > 0)
		{
			groupid = gid;
		}
	}
	
	else
	{
		for(new i = 0; i < MAX_GROUPS; i++)
		{
			if(strcmp(groupname, gGroups[i][gs_name], true) == 0)
			{
				groupid = i;
				break;
			}
		}
		
	}
	
	if(groupid == -1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid group ID.");
	}
	
	else
	{
		ShowPlayerGroupList(playerid, groupid);
	}
	
	return 1;
}

CMD:grlist(playerid, params[])
{
	return cmd_grouplist(playerid, params);
}

CMD:grkick(playerid, params[])
{
	new 
		targetid;
		
	if(sscanf(params, "?<MATCH_NAME_PARTIAL=1>u", targetid))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /grkick [ID/Name]");
	}
	
	if(targetid == INVALID_PLAYER_ID)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player not connected.");
	}
	
	if(targetid == cellmin)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Multiple matches found, be more specific.");
	}
	
	if(PlayerGroupID[playerid] == -1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be in a group to use this command.");
	}
	
	if(gGroups[PlayerGroupID[playerid]][gs_leader] != playerid)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be the leader to use this command.");
	}
	
	if(PlayerGroupID[playerid] != PlayerGroupID[targetid])
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This player is not a member of your group.");
	}
	
	new
		string[128];
	
	format(string, sizeof(string), "%s (%d) has kicked %s (%d) from the group.", PlayerName(playerid), playerid, PlayerName(targetid), targetid);
	SendGroupMessage(PlayerGroupID[playerid], -1, string);
	PlayerLeftGroup(targetid, PlayerGroupID[playerid]);
	
	return 1;
}

CMD:grk(playerid, params[])
{
	return cmd_grkick(playerid, params);
}

CMD:groupcall(playerid, params[])
{
	if(PlayerGroupID[playerid] == -1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be in a group to use this command.");
	}
	
	new
		string[128],
		zone[28];
	
	GetPlayer2DZone(playerid, zone, sizeof(zone));
	format(string, sizeof(string), "%s (%d) requests help at %s!", PlayerName(playerid), playerid, zone);
	SendGroupMessage(PlayerGroupID[playerid], -1, string);
	
	return 1;
}

CMD:grcall(playerid, params[])
{
	return cmd_groupcall(playerid, params);
}

CMD:grouphelp(playerid, params[])
{
	new 
		msg[150];
	format(msg, sizeof(msg), "|____________________________________________ {%06x}GROUP HELP{%06x} ____________________________________________|", COLOR_WHITE >>> 8, COLOR_GREEN >>> 8);
	SendClientMessage(playerid, COLOR_GREEN, msg);
	format(msg, sizeof(msg), "[Commands]: {%06x}/groups - /groupcreate (/grc) - /groupjoin (/grj) - /groupleave (/grl) - /groupinvite (/gri) - /groupmsg (/gm)", COLOR_WHITE >>> 8);
	SendClientMessage(playerid, COLOR_GREEN, msg);
	format(msg, sizeof(msg), "[Commands]: {%06x}/grouplist (/grlist) - /groupleader (/grleader) - /grkick (/grk) - /groupcall (/grcall)", COLOR_WHITE >>> 8);
	SendClientMessage(playerid, COLOR_GREEN, msg);
	
	return 1;
}

CMD:grhelp(playerid, params[])
{
	return cmd_grouphelp(playerid, params);
}	

CMD:setgroup(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETGROUP))
	{
		new
			groupid,
			status;
			
		if(sscanf(params, "dd", groupid, status))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setgroup [ID] [0/1] (0: Not permanent / 1: Permanent)");
		}
		
		new
			query[256];
		
		if(status)
		{
			if(gGroups[groupid][gs_isperm] == true)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The group is already permanent.");
			}
			
			
		//	format(query, sizeof(query), "SELECT * FROM `FoCo_Groups` WHERE `group_name` = '%s'", gGroups[groupid][gs_name]);
			format(query, sizeof(query), "INSERT INTO `FoCo_Groups` (group_name, group_leader) VALUES ('%s', '%s')", gGroups[groupid][gs_name], PlayerName(gGroups[groupid][gs_leader]));
				//mysql_free_result();
				//return mysql_query(g_query, MYSQL_INSERTGROUP, extraid, con);					
				
			if(mysql_query(query, MYSQL_INSERTGROUP, groupid, con))
			{
				new 
					string[128];
					
				format(string, sizeof(string), "AdmCmd(%d): %s %s has added group %s to the database.", ACMD_INSERTGROUP, GetPlayerStatus(playerid), PlayerName(playerid), gGroups[groupid][gs_name]);
				SendAdminMessage(ACMD_SETGROUP, string);
				format(string, sizeof(string), "[INFO]: Successfully added group %s (%d) into the database.", gGroups[groupid][gs_name], groupid);
				SendClientMessage(playerid, COLOR_NOTICE, string);
				format(string, sizeof(string), "%s %s has added your group to the database.", GetPlayerStatus(playerid), PlayerName(playerid));
				SendGroupMessage(groupid, -1, string);
			}
			
			else
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Failed to insert group into the database.");
			}
		}
		
		else
		{
			if(gGroups[groupid][gs_isperm] == false)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The group is already set not to save.");
			}
			
			format(query, sizeof(query), "DELETE FROM `FoCo_Groups` WHERE ID = '%d'", gGroups[groupid][gs_dbid]);
			
			if(mysql_query(query, MYSQL_DELETEGROUP, groupid, con))
			{
				new 
					string[128];
					
				format(string, sizeof(string), "AdmCmd(%d): %s %s has removed group %s from the database.", ACMD_SETGROUP, GetPlayerStatus(playerid), PlayerName(playerid), gGroups[groupid][gs_name]);
				SendAdminMessage(ACMD_SETGROUP, string);
				format(string, sizeof(string), "[INFO]: Successfully removed group %s (%d) from the database.", gGroups[groupid][gs_name], groupid);
				SendClientMessage(playerid, COLOR_NOTICE, string);
				format(string, sizeof(string), "%s %s has removed your group from the database.", GetPlayerStatus(playerid), PlayerName(playerid));
				SendGroupMessage(groupid, -1, string);			
			}
			
			else
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Failed to remove the group from the database.");
			}
		}
	}
	
	return 1;
}

CMD:toggroups(playerid, params)
{
	if(IsAdmin(playerid, ACMD_TOGGROUPS))
	{
		if(groupsenabled)
		{
			static
					string[128];
					
			groupsenabled = false;
			SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: Groups were disabled");
			format(string, sizeof(string), "AdmCmd(%d): %s %s has disabled the group system.", ACMD_ANTICBUG, GetPlayerStatus(playerid), PlayerName(playerid));
			SendAdminMessage(ACMD_TOGGROUPS, string);
		}
		
		else
		{
			static
					string[128];
					
			groupsenabled = true;
			SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: Groups were enabled");
			format(string, sizeof(string), "AdmCmd(%d): %s %s has enabled the group system.", ACMD_ANTICBUG, GetPlayerStatus(playerid), PlayerName(playerid));
			SendAdminMessage(ACMD_TOGGROUPS, string);
		}
	}
	
	return 1;
}
