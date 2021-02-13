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
* Filename: pEar_ClanWar.pwn                                                     *
* Author: pEar	                                                                 *
*********************************************************************************/

/*
	TO-DO:

- /clanwar as main function, add /clanwar edit, /clanwar start, /clanwar accept, /clanwar invite, /clanwar kick, /clanwar end


	USEFUL STUFF:
	FoCo_Player[MAX_PLAYERS][clan/clanrank]

	FoCo_Teams[MAX_TEAMS][dbid / teamname / team color / ]

	FoCo_Teams[FoCo_Player[pid][clan]][....]

*/

/*
	INCLUDES
*/
#include <YSI\y_hooks>


/*
	DEFINES
*/

#define MAX_CW_MEMBERS 10
#define MAX_CW_WPNS 5

#define CW_MAPS 1

#define CW_TEAM_1 0
#define CW_TEAM_2 1


/*
	ENUMS AND VARIABLES
*/
enum clanwar_info {
	cw_opponent,
	cw_participants,
	cw_type,							
	cw_map								
};	

// Main enum, keeps track of main information
new FoCo_ClanWars[MAX_TEAMS][clanwar_info];

// Keeps track of weapons.
new FoCo_ClanWars_Wpns[MAX_TEAMS][MAX_CW_WPNS][2];

// Keeps track of participants
new FoCo_ClanWars_Participants[MAX_TEAMS][MAX_CW_MEMBERS][2];

/*
	FUNCTION FORWARDING
*/


/*
	COMMANDS
*/
cmd:clanwar(playerid, params[])
{
	new targetid, string[256], option[50];
	if(FoCo_Player[playerid][clan] == -1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not in any clan!");
	}
	if(sscanf(params, "s[50]R(-1)", option, targetid))
	{
	    format(string, sizeof(string), "[USAGE]: {%06x}/clanwar {%06x}[edit/start/accept/invite/kick/leave/end]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
	    return SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	if(strcmp(option, "edit", true) == true)
	{
		if(FoCo_Player[playerid][clan] == -1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not the leader of a clan.");
		}
		new main_string[1024];
		main_string = CW_GetMainStr(playerid);
		ShowPlayerDialog(playerid, DIALOG_CLANWAR_EDIT, DIALOG_STYLE_TABLIST_HEADERS, "ClanWar Settings", main_string, "Edit", "Close");
	}
	else if(strcmp(option, "start", true) == true)
	{
		if(FoCo_Player[playerid][clan] == -1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not the leader of a clan.");
		}
	}
	else if(strcmp(option, "accept", true) == true)
	{
		return 1;
	}
	else if(strcmp(option, "invite", true) == true)
	{
		return 1;
	}
	else if(strcmp(option, "kick", true) == true)
	{
		return 1;
	}
	else if(strcmp(option, "leave", true) == true)
	{
		return 1;
	}
	else if(strcmp(option, "end", true) == true)
	{
		return 1;
	}
	return 1;
}

/*
	FUNCTIONS
*/

stock CW_GetMainStr(playerid)
{
	new string[1024];
	format(string, sizeof(string), "Opponent: %s\nParticipants per team: %d\nType: %s\nMap: %s\nWeapons: %s\n", CW_GetTeamStr(FoCo_ClanWars[FoCo_Player[playerid][clan]][cw_opponent]), FoCo_ClanWars[FoCo_Player[playerid][clan]][cw_members_per_team], CW_GetTypeStr(FoCo_ClanWars[FoCo_Player[playerid][clan]][cw_type]), 
		CW_GetMapStr(FoCo_ClanWars[FoCo_Player[playerid][clan]][cw_type], FoCo_ClanWars[FoCo_Player[playerid][clan]][cw_map]), CW_GetWpnStr(playerid));
	return string;
}

/*
 	Get the string with weapons and ammo for the clanwar. Used in CW_GetMainStr
*/
stock CW_GetWpnStr(playerid)
{
	new string[40*MAX_CW_WPNS], wpn[40];
	for(new i = 0; i < MAX_CW_WPNS; i++)
	{
		if(GetWeaponName(FoCo_ClanWars_Wpns[FoCo_Players[playerid][clan]][i][0], wpn, sizeof(wpn-8)) == 1)
		{
			format(wpn, sizeof(wpn), "%s(%d) - ", wpn, FoCo_ClanWars_Wpns[FoCo_Players[playerid][clan]][i][1])
			strcat(string, wpn, sizeof(string));
		}
		else
		{
			format(wpn, sizeof(wpn), "N/A - ")
			strcat(string, wpn, sizeof(string));
		}
	}
	strdel(string, sizeof(string)-2, sizeof(string));
	return string;
}

/*
	Return map name from map ID.
*/
stock CW_GetMapStr(type, map)
{
	new string[56];
	if(type == 0)
	{
		switch(map):
		{
			case 0:	
			{
				format(string, sizeof(string), "[A/D]: San Fierro Parking");
				break;
			}
			default: format(string, sizeof(string), "[A/D]: Not selected / Invalid");
		}	
	}
	else if(type == 1)
	{
		switch(map):
		{
			default: format(string, sizeof(string), "[TDM]: Not selected / Invalid");
		}
	}
	else
	{
		format(string, sizeof(string), "Not yet selected.");
	}
	return string;
}

stock CW_GetTypeStr(type)
{
	new string[24];
	if(type == 0)
	{
		format(string, sizeof(string), "Attack / Defence");
	}
	else if()
	{
		format(string, sizeof(string), "Team DeathMatch");
	}
	else
	{
		format(string, sizeof(string), "Not yet selected.");
	}
	return string;
}

stock CW_GetTeamStr(team)
{
	new string[128];
	if(team != -1)
	{
		format(string, sizeof(string), "%s", FoCo_Teams[team][team_name]);
	}
	else
	{
		format(string, sizeof(string), "Not yet selected");
	}
	
	return string;
}

/*
	HOOKS
*/

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	//new string[256];
	switch(dialogid)
	{
		case DIALOG_CLANWAR_EDIT: 
		{
			if(response)
			{
				return 1;
			}
		}
	}
	return 1;
}

hook OnGameModeInit()
{
	for(new i = 0; i < MAX_TEAMS; i++)
	{
		FoCo_ClanWars[i][cw_opponent] = -1;
		FoCo_ClanWars[i][cw_participants] = 0;
		FoCo_ClanWars[i][cw_type] = -1;
		FoCo_ClanWars[i][cw_map] = -1;
		for(new j = 0; j < 2; j++)
		{
			for(new k = 0; k < MAX_CW_MEMBERS; k++)
			{
				FoCo_ClanWars_Participants[i][j][k] = -1;
			}
		}
		for(new j = 0; j < MAX_CW_WPNS; j++)
		{
			for(new k = 0; k < 2; k++)
			{
				FoCo_ClanWars_Wpns[i][j][k] = -1;	
			}
		}
	}
	return 1;
}

/*
	XYZ COORDINATES
*/
	/*
new Float:cw_maps_xyz[MAX_CW_MEMBERS][CW_MAPS][4] = {

};
*/





CMD:clanwar(playerid, params[]) 
{
	if(GetPVarInt(playerid, "AtClanWar") == 1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are already at a clan war");
		return 1;
	}
	if(FoCo_Player[playerid][clan] == -1) {
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're not in a clan.");
		return 1;
	}
	
	if(FoCo_Team[playerid] != FoCo_Teams[FoCo_Player[playerid][clan]][db_id]) {
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You must be on your clan team first.");
		return 1;
	}
	
	if(GetPVarInt(playerid, "PlayerStatus") == 3) {
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Not whilst your in the AFK zone.");
		return 1;
	}
	
	if(GetPVarInt(playerid, "PlayerStatus") == 1) {
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Not whilst your in an event.");
		return 1;
	}
	
	if(GetPVarInt(playerid, "PlayerStatus") == 2)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are in a duel, leave that first...");
		return 1;
	}
	if(FoCo_Player[playerid][jailed] != 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please wait until your admin jail is over.");
		return 1;
	}
	
	new members_each, string[128], trial;
	if (sscanf(params, "ii", members_each, trial))
	{
		format(string, sizeof(string), "[USAGE]: {%06x}/clanwar {%06x} [members-each-team] [trial 0 = no | 1 = yes]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		return 1;
	}

	if(trial > 1 || trial < 0) 
	{
		format(string, sizeof(string), "[USAGE]: {%06x}/clanwar {%06x} [members-each-team] [trial 0 = no | 1 = yes]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		return 1;
	}
	
	if(members_each > 10 || members_each < 1) {
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need more than 1 player each and no more than 10.");
		return 1;
	}
	
	ClanWar_Members[playerid] = members_each;
	ClanWar_Trial[playerid] = trial;
	
	new msg[1024];
	foreach (FoCoTeams, i)
	{
		if(FoCo_Teams[i][team_type] == 2)
		{
			if(strlen(msg) == 0)
			{
				format(msg, sizeof(msg), "%d - %s", i, FoCo_Teams[i][team_name]);
			}
			else
			{
				format(msg, sizeof(msg), "%s \n%d - %s", msg, i, FoCo_Teams[i][team_name]);
			}
		}
	}
	
	ShowPlayerDialog(playerid, DIALOG_SHOW_CLANS_WAR, DIALOG_STYLE_LIST, "Choose a clan to war with", msg, "Select", "Close");
	return 1;
}

case DIALOG_SHOW_CLANS_WAR:
		{
			if(!response) {
				ClanWar_Members[playerid] = 0;
				ClanWar_Trial[playerid] = 0;
				return 1;
			}

			new item;
			sscanf(inputtext, "i", item);

			if(FoCo_Teams[item][team_clanwar_attending] == 1) {
				ClanWar_Members[playerid] = 0;
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That team is at a clan war");
				return 1;
			}

			new count = 0;
			foreach(Player, i)
			{
				if(FoCo_Team[i] == item)
				{
					count++;
				}
			}

			if(count < ClanWar_Members[playerid])
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There are not enough members on that team to do a clan war");
				ClanWar_Members[playerid] = 0;
				return 1;
			}

			ClanWar_Clan[playerid] = item;
			ShowPlayerDialog(playerid, DIALOG_SHOW_CLANS_WAR_WEAPONS, DIALOG_STYLE_LIST, "Choose a weapon pack.", "Deagle\nDeagle+m4\nDeagle+Spaz\nDeagle+m4+spaz\nDeagle+Sniper\nDeagle+Tec9\nSpaz\nAK47 + Deagle", "Select", "Close");
			return 1;
		}
		case DIALOG_SHOW_CLANS_WAR_WEAPONS:
		{
			if(!response)
			{
				ClanWar_Clan[playerid] = 0;
				ClanWar_Trial[playerid] = 0;
				ClanWar_Members[playerid] = 0;
				return 1;
			}

			ClanWar_Package[playerid] = listitem+1;

			ShowPlayerDialog(playerid, DIALOG_SHOW_CLANS_WAR_LOCATION, DIALOG_STYLE_LIST, "Choose a location.", "1 - Area 59\n2 - RC Battelground\n3 - Jefferson Motel\n4 - LV Warehouse\n5 - Mad Dogs\n6 - Army vs Terrorists\n7 - Kickstart Stadium\n8 - Caligulas\n9 - Meat Factory\n10 - SFCarrier", "Select", "Close");
			return 1;
		}
		case DIALOG_SHOW_CLANS_WAR_LOCATION:
		{
			if(!response)
			{
				ClanWar_Clan[playerid] = 0;
				ClanWar_Members[playerid] = 0;
				ClanWar_Package[playerid] = 0;
				ClanWar_Trial[playerid] = 0;
				return 1;
			}

			new location[100];
			format(location, sizeof(location), "[Clan War]: The Clan War will be held at: %s", GetLocation(listitem+1));

			new mstring[300];
			if(ClanWar_Trial[playerid] == 1) {
				format(mstring, sizeof(mstring), "[Clan War]: %s is challenging %s to a Trial War /accept clanwar ..(60 seconds)", FoCo_Teams[FoCo_Team[playerid]][team_name], FoCo_Teams[ClanWar_Clan[playerid]][team_name]);
			} else {
				format(mstring, sizeof(mstring), "[Clan War]: %s is challenging %s to a War /accept clanwar ..(60 seconds)", FoCo_Teams[FoCo_Team[playerid]][team_name], FoCo_Teams[ClanWar_Clan[playerid]][team_name]);
			}
			foreach(Player, i)
			{
				if(FoCo_Team[i] == ClanWar_Clan[playerid])
				{
					FoCo_Teams[FoCo_Team[i]][team_clanwar_enemy] = FoCo_Team[playerid];
					SendClientMessage(i, COLOR_NOTICE, mstring);
					SendClientMessage(i, COLOR_NOTICE, location);
				}

				if(FoCo_Team[i] == FoCo_Team[playerid])
				{
					FoCo_Teams[FoCo_Team[i]][team_clanwar_enemy] = ClanWar_Clan[playerid];
					SendClientMessage(i, COLOR_NOTICE, mstring);
					SendClientMessage(i, COLOR_NOTICE, location);
				}
			}
			FoCo_Teams[ClanWar_Clan[playerid]][team_clanwar_members] = ClanWar_Members[playerid];
			FoCo_Teams[FoCo_Team[playerid]][team_clanwar_members] = ClanWar_Members[playerid];
			FoCo_Teams[ClanWar_Clan[playerid]][team_clanwar_trial] = ClanWar_Trial[playerid];
			FoCo_Teams[FoCo_Team[playerid]][team_clanwar_trial] = ClanWar_Trial[playerid];
			KillTimer(ClanWar[playerid]);
			ClanWar[playerid] = SetTimerEx("ClanWarCheck", 60000, false, "iiiiii", FoCo_Team[playerid], ClanWar_Clan[playerid], ClanWar_Members[playerid], listitem+1, ClanWar_Package[playerid], ClanWar_Trial[playerid]);
			return 1;
		}
*/