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
* Filename: pEar_Clanwar.pwn                                                     *
* Author: pEar	                                                                 *
*********************************************************************************/


#include <YSI\y_hooks>

#define CW_MAX_PLAYERS 10			// Max players in the clanwar on each team.
#define CW_MIN_PLAYERS 2			// Minimum amount of members in the clanwar. 
#define CW_MAX_WEAPONS 5			// Amount of different weapons. 5 should be plenty enough
#define CW_OFFICIAL 1
#define CW_NONOFFICIAL 0
#define CW_DEFAULT_AMMO 5000		// Default ammo.
#define CW_RANK_INVITE 2 			// Rank 1 & 2 can request and accept clanwar


/*
	DIALOG OVERVIEW:
	
	DIALOG_CLANWAR_MAIN
	DIALOG_CLANWAR_REQUEST_CONFIRM

	/clanwar edit - DIALOG_CLANWAR_MAIN (DIALOG_STYLE_TABLIST_HEADERS)
	- Opponent - If -1, show N/A
	- Members per team: default of CW_MIN_PLAYERS
	- Mode - Give default of -1, show N/A
	- Map - Give default of -1, show N/A - Only show the maps if mode is not -1
	- Weapons: Show new dialog which gives weapons. 
	- Official ClanWar or Trial - Give default of trial.

	DIALOG_CLANWAR_MODE (DIALOG_STYLE_LIST)
	- Team DeathMatch
	- A/D
	
	DIALOG_CLANWAR_MAP (DIALOG_STYLE_LIST)
	- Only show maps that work with the mode.

	DIALOG_CLANWAR_WEAPONS (DIALOG_STYLE_TABLIST_HEADERS)
	- Max 5 weapons, give option for both weapon and ammo. Set default ammo to 5000.

	COMMAND OVERVIEW:
	- /clanwar: Will return [USAGE]: /clanwar (accept, deny, edit, request, ready, invite, kick)
	- /clanwar edit: Will show the main dialog.
	- /clanwar request: Will send error if not all options for the clanwar edit function has been edited. Otherwise show confirm clanwar dialog.
	- /clanwar ready: Both clanwar leaders will have to do the command in order to start the clanwar. Will teleport both teams to respective positions and have a freeze timer of 30 seconds.
		Will have to add error checking, make sure both teams are actually ready with enough clan members online and enough members invited.
	- /clanwar accept: Only clan rank 1 & 2 can accept a clanwar. Will set the player that accepted as the clanwar leader which enables him to do clanwar invite and clanwar ready.
		Members will use the same command when they are being being invited by their clanleader. Error check that the clanwar is not already full.
	- /clanwar deny: -==- ^, will do the same, with the exception that it will cancel the whole clanwar.
	- /clanwar invite: The clanwar has to be accepted and only the clanwar leader of each team can use it. Show amount of members needed to start.
	- /clanwar kick: Only the clanwar leader can kick a member of their own team and only before he/she has done /clanwar ready.
	- /clanwar inviteall: Easier for the clanleader if he wants to invite all his clanmembers and its first to join.

	Useful PVars:
		CW_AtClanWar - if = 1, then he is at a clanwar.
		CW_Invited, give the ID of the clan leader

*/



enum ClanWar_Info_Main {
	cw_team1,				// Team 1
	cw_team2,				// Opponent. Will be indexed into the other team.
	cw_members,				// Amount of members per team
	cw_mode,				// Mode, 0 = TDM, 1 = A/D etc.
	cw_map,					// Map, indexed into some map to the given mode.
	cw_official,			// 0 = Trial, 1 = Official.
	cw_invited,				// Will be set to one when the invite has been sent. Default 0, just to check if clan leaders can do /clanwar accept.
	cw_started				// Will be set when the clanwar is started.
};


// Will often have to index into the cw_enemy column in order to reach the main ClanWar information thingy,
enum ClanWar_Info_Stats {
	cw_accepted,
	cw_enemy,
	cw_kills,
	cw_deaths,
	cw_slots_left,
	cw_leader,
	cw_ready,
	cw_main 				// This is used to store the team that initiated the clanwar, so that the other team may have access to its information more easily. 
};

// Index into the team ID.
new ClanWars[MAX_TEAMS][ClanWar_Info_Main];

// Stats per team. Index into the clan ID.
new ClanWarInfo[MAX_TEAMS][ClanWar_Info_Stats];

// Index into the team ID.
new ClanWar_Members[MAX_TEAMS][CW_MAX_PLAYERS];

// One for weapon, one for ammo. Default ammo of 5000.
new ClanWar_Weapons[MAX_TEAMS][CW_MAX_WEAPONS][2];


hook OnGameModeInit()
{
	for(new i = 0; i < MAX_TEAMS; i++)
	{
		ClanWars[i][cw_opponent] = -1;						// 0 = police, so has to be -1
		ClanWars[i][cw_members] = CW_MIN_PLAYERS;			// Put it as minimum, otherwise bug ja
		ClanWars[i][cw_mode] = -1;							// Let em wiggas choose
		ClanWars[i][cw_map] = -1;							// ^
		ClanWars[i][cw_official] = CW_NONOFFICIAL;			// Easier that way yo
		ClanWars[i][cw_invited] = -1;						// NO!!! 0 = police again
		ClanWars[i][cw_ready] = 0;							// No they not ready
		ClanWars[i][cw_started] = 0;						// No they didnt start
		ClanWarInfo[i][cw_accepted] = -1;					// If -1, then the clanleader has yet to accept it. When it is set to 1
		ClanWarInfo[i][cw_enemy] = -1;
		ClanWarInfo[i][cw_kills] = 0;
		ClanWarInfo[i][cw_deaths] = 0;
		ClanWarInfo[i][cw_slots_left] = CW_MIN_PLAYERS;
		for(new k = 0; k < CW_MAX_PLAYERS; k++)
		{
			ClanWar_Members[i][k] = -1;						// All players yo.
		}
		for(new k = 0; k < CW_MAX_WEAPONS; k++)
		{
			ClanWar_Weapons[i][k][0] = 0;					// The weapon ID.
			ClanWar_Weapons[k][k][1] = CW_DEFAULT_AMMO;		// Default ammo.
		}
	}
	return 1;
}



CMD:clanwar(playerid, params[]) 
{
	if(GetPVarInt(playerid, "AtClanWar") != 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are already at a clan war");
		return 1;
	}
	if(FoCo_Player[playerid][clan] == -1) {
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're not in a clan.");
		return 1;
	}
	
	if(FoCo_Team[playerid] != FoCo_Teams[FoCo_Player[playerid][clan]][db_id]) {
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You must be onyour clan team first.");
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
	
	new string[512], result[56], val;
	if(!sscanf(params, "s[56]", result))
	{
		if(strcmp(result, "edit", true) == 0)
		{
			format(string, sizeof(string), "-\t-\nOpponent:\t%s\nMembers Each Team:\t%d\nMode:\t%s\nMap:\t%s\nSelect Weapons\nOffical or Trial:\t%s", GetTeamName(ClanWars[FoCo_Player[playerid][clan]][cw_opponent]), ClanWars[FoCo_Player[playerid][clan]][cw_members], CW_GetMode(ClanWars[FoCo_Player[playerid][clan]][cw_mode]), CW_GetMap(ClanWars[FoCo_Player[playerid][clan]][cw_map]), CW_GetOfficial(ClanWars[FoCo_Player[playerid][clan]][cw_official]));
			ShowPlayerDialog(playerid, DIALOG_CLANWAR_MAIN, DIALOG_STYLE_TABLIST_HEADERS, "ClanWar System", string, "Select", "Close");
			return 1;
		}
		else if(strcmp(result, "request", true) == 0)
		{
			if(FoCo_Player[playerid][clanrank] == -1 || FoCo_Playerid[playerid][clanrank] < CW_RANK_INVITE)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not allowed to request a clanwar!");
			}
			if(ClanWar[FoCo_Player[playerid][clan]][cw_opponent] == -1 || ClanWar[FoCo_Player[playerid][clan]][cw_mode] == -1 || ClanWar[FoCo_Player[playerid][clan]][cw_map] == -1)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The clanwar setup has not been completed yet! Use /clanwar edit to do this.");
			}
			format(string, sizeof(string), "Opponent: %s\nMembers Each Team: %d\nMode: %s\nMap: %s\nWeapons: %s\nOffical or Trial: %s", GetTeamName(ClanWars[FoCo_Player[playerid][clan]][cw_opponent]), ClanWars[FoCo_Player[playerid][clan]][cw_members], CW_GetMode(ClanWars[FoCo_Player[playerid][clan]][cw_mode]), CW_GetMap(ClanWars[FoCo_Player[playerid][clan]][cw_map]), CW_GetWeapons(FoCo_Player[playerid][clan]), CW_GetOfficial(ClanWars[FoCo_Player[playerid][clan]][cw_official]));
			ShowPlayerDialog(playerid, DIALOG_CLANWAR_REQUEST_CONFIRM, DIALOG_STYLE_MSGBOX, "Confirm clanwar requst", string, "Confirm & Request", "Cancel");
			return 1;
		}
		else if(strcmp(result, "accept", true) == 0)
		{
			if(ClanWarInfo[FoCo_Player[playerid]][clan][cw_enemy] == -1)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No-one has invited you to a clanwar yet!");
			}
			if(ClanWars[ClanWarInfo[FoCo_Player[playerid][clan]][cw_enemy]][cw_invited] != 1)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No-one has invited you to a clanwar, or someone from your clan has denied the clanwar already");
			}
			// The clanleader is accepting the clanwar.
			if(ClanWarInfo[FoCo_Player[playerid][clan]][cw_accepted] == 0)
			{
				SendClientMessage(playerid, COLOR_GLOBALNOTICE, "[INFO]: You have accepted the clanwar request. Invite your members using /clanwar invite [ID]");
				ClanWarInfo[FoCo_Player[playerid][clan]][cw_accepted] = 1;
				ClanWarInfo[FoCo_Player[playerid][clan]][cw_kills] = 0;
				ClanWarInfo[FoCo_Player[playerid][clan]][cw_deahts] = 0;
				ClanWarInfo[FoCo_Player[playerid][clan]][cw_slots_left] = ClanWars[ClanWarInfo[FoCo_Player[playerid][clan]][cw_enemy]][cw_members] - 1;
				ClanWarInfo[FoCo_Player[playerid][clan]][cw_leader] = playerid;
				ClanWarInfo[FoCo_Player[playerid][clan]][cw_ready] = 0; // Not ready yet.
				format(string2, sizeof(string2), "[INFO]: %s has accepted a clanwar request from %s. If invited, use /clanwar accept", PlayerName(playerid), GetTeamName(ClanWarInfo[FoCo_Player[playerid][clan]][cw_enemy]));
				SendClanMessage(playerid, FoCo_Player[playerid][clan], string2);
				ClanWar_Player_Accept_ClanWar(playerid);
				return 1;
			}	
			// The clanleader has already accepted the clanwar, it is a clan member accepting.
			else
			{
				if(ClanWarInfo[FoCo_Player[playerid][clan]][cw_slots_left] == 0)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The clanwar is already full!");
				}
				// Using 0 here as that is the default return value when you use GetPVarInt.. Doesn't matter as 0 will always be police, so its cool.
				if(GetPVarInt(playerid, "CW_AtClanWar") != 0)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are already at a clanwar!");
				}
				if(GetPVarInt(playerid, "CW_Invited") != 1)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your clan leader has yet to invite you to any clanwar.");
				}
				ClanWar_Player_Accept_ClanWar(playerid);
				return 1;

			}
		}
		else if(strcmp(result, "deny", true) == 0)
		{
			// Clanleader denying the clanwar itself.
			if(ClanWarInfo[FoCo_Player[playerid][clan]][cw_accepted] == 0)
			{
				if(ClanWarInfo[FoCo_Player[playerid][clan]][cw_enemy] == -1)
				{
					return SendErrorMessage(playerid, "[ERROR]: No-one has invited you to a clanwar yet.");
				} 
				if(FoCo_Player[playerid][clanrank] < CW_RANK_INVITE)
				{
					return SendErrorMessage(playerid, "[ERROR]: You cannot deny a clanwar!"); 
				}
				if(ClanWars[ClanWarInfo[FoCo_Player[playerid][clan]][cw_enemy]][cw_invited] == 0)
				{
					return SendErrorMessage(playerid, "[ERROR]: No-one has invited you to a clanwar, or someone has denied it already");
				}
				format(string2, sizeof(string2), "[INFO]: %s has denied your clanwar request!", PlayerName(playerid))
				SendClientMessage(ClanWarsInfo[ClanWarInfo[FoCo_Player[playerid][clan]][cw_enemy]][cw_leader], COLOR_GLOBALNOTICE, string2);
				return 1;
			}
			return 1;
		}
		else if(strcmp(result, "ready", true) == 0)
		{
			if(GetPlayerClanRank(playerid) < CW_RANK_INVITE || GetPlayerClanRank(playerid) == -1)
			{
				return	SendErrorMessage(playerid, "Your clan rank is not high enough to do this!");
			}
			if(ClanWarInfo[GetPlayerClan(playerid)][cw_accepted] != 1)
			{
				return SendErrorMessage(playerid, "You have not yet accepted a clanwar!");
			}
			if(ClanWarInfo[GetPlayerClan(playerid)][cw_leader] != playerid)
			{
				return SendErrorMessage(playerid, "You are not the leader for your team, so you cannot use this command!");
			}
			if(ClanWarInfo[GetPlayerClan(playerid)][cw_slots_left] != 0)
			{
				return SendErrorMessage(playerid, "You have fill all the clanwar slots in order to ready up.");
			}
			for(new j = 0; j < CW_MAX_PLAYERS; j++)
			{
				if(ClanWar_Members[GetPlayerClan(playerid)][j] == -1 || ClanWar_Members[GetPlayerClan(playerid)][j] == INVALID_PLAYER_ID)
				{
					return SendErrorMessage(playerid, "One or more of your members have either logged off, or something else went wrong. Use /clanwar info for more information.");
				}
			}
			format(string2, sizeof(string2), "[CLANWAR]: %s(%d) has announced that his clan, %s, is ready for the clanwar!", PlayerName(playerid), playerid, GetTeamName(GetPlayerClan(playerid)));
			SendClanMessage(GetPlayerClan(playerid), COLOR_GREEN, string2);
			SendClanMessage(ClanWarInfo[GetPlayerClan(playerid)][cw_enemy], COLOR_GREEN, string2);
			ClanWarInfo[GetPlayerClan(playerid)][cw_ready] = 1;
			CW_Check_Readyness(GetPlayerClan(playerid));
			return 1;
		}
		else if(strcmp(result, "info", true) == 0)
		{
			format(string, sizeof(string), "-\t-\nOpponent:\t%s\nMembers Each Team:\t%d\nMode:\t%s\nMap:\t%s\nSelect Weapons\nOffical or Trial:\t%s\nWeapons:\tClick!\nMembers:\tClick!", GetTeamName(ClanWars[FoCo_Player[playerid][clan]][cw_opponent]), ClanWars[FoCo_Player[playerid][clan]][cw_members], CW_GetMode(ClanWars[FoCo_Player[playerid][clan]][cw_mode]), CW_GetMap(ClanWars[FoCo_Player[playerid][clan]][cw_map]), CW_GetOfficial(ClanWars[FoCo_Player[playerid][clan]][cw_official]));
			ShowPlayerDialog(playerid, DIALOG_CLANWAR_INFO, DIALOG_STYLE_TABLIST_HEADERS, "ClanWar System", string, "Select", "Close");
			return 1;
		}	
	}
	else if(!sscanf(params, "s[50]u", result, val))
	{
		if(strcmp(result, "invite", true) == 0)
		{
			if(GetPlayerClanRank(playerid) == -1 || GetPlayerClanRank(playerid < CW_RANK_INVITE))
			{
				return SendErrorMessage(playerid, "You are not allowed to invite anyone!");
			}
			if(ClanWarInfo[GetPlayerClan(playerid)][cw_accepted] != 1)
			{
				return SendErrorMessage(playerid, "You have not yet accepted a clanwar.");
			}
			if(ClanWarInfo[GetPlayerClan(playerid)][cw_leader] != playerid)
			{
				return SendErrorMessage(playerid, "You are not the clanwar leader for your team.");
			}
			if(ClanWarInfo[GetPlayerclan(playerid)][cw_slots_left] <= 0)
			{
				return SendErrorMessage(playerid, "Your clanwar team is already full. Use /clanwar kick if you want to add someone else.");
			}
			if(val == INVALID_PLAYER_ID)
			{
				return SendErrorMessage(playerid, "Invalid playername / ID");
			}
			if(GetPlayerClan(val) != GetPlayerClan(playerid))
			{
				return SendErrorMessage(playerid, "This player is not in your clan.");
			}
			for(new j = 0; j < ClanWars[ClanWarInfo[GetPlayerClan(playerid)][cw_main]][cw_members]; j++)
			{
				if(ClanWar_Members[GetPlayerClan(playerid)][j] == -1)
				{
					format(string2, sizeof(string2), "[CLANWAR INFO]: You have invited %s(%d) to the clanwar against %s.", PlayerName(val), val, GetTeamName(ClanWarInfo[GetPlayerClan(playerid)][cw_enemy]));
					SendClientMessage(playerid, COLOR_GREEN, string2);
					format(string2, sizeof(string2), "[CLANWAR INFO]: You have been invited to the clanwar against %s by %s(%d)", GetTeamName(ClanWarInfo[GetPlayerClan(playerid)][cw_enemy]), PlayerName(playerid), playerid);
					SendClientMessage(val, COLOR_GREEN, string2);
					SetPVarInt(val, "CW_Invited", 1);	// He is now invited.
					ClanWar_Members[GetPlayerClan(playerid)][j] = val);
					return 1;
				}
			}
			return 1;
		}	
		else if(strcmp(result, "kick", true) == 0)
		{
			if(GetPlayerClanRank(playerid) == -1 || GetPlayerClanRank(playerid < CW_RANK_INVITE))
			{
				return SendErrorMessage(playerid, "You are not allowed to kick anyone!");
			}
			if(ClanWarInfo[GetPlayerClan(playerid)][cw_accepted] != 1)
			{
				return SendErrorMessage(playerid, "You have not yet accepted a clanwar.");
			}
			if(ClanWarInfo[GetPlayerClan(playerid)][cw_leader] != playerid)
			{
				return SendErrorMessage(playerid, "You are not the clanwar leader for your team.");
			}
			if(ClanWars[ClanWarInfo[GetPlayerclan(playerid)][cw_main]][cw_members] == ClanWarInfo[GetPlayerClan(playerid)][cw_slots_left])
			{
				return SendErrorMessage(playerid, "There is no-one to kick from your clanwar as noone has accepted yet.");
			}
			if(val == INVALID_PLAYER_ID)
			{
				return SendErrorMessage(playerid, "Invalid playername / ID");
			}
			if(GetPlayerClan(val) != GetPlayerClan(playerid))
			{
				return SendErrorMessage(playerid, "This player is not in your clan.");
			}
			if(ClanWars[ClanWarInfo[GetPlayerClan(playerid)][cw_main]][cw_started] == 1)
			{
				return SendErrorMessage(playerid, "The clanwar has already started, no going back.");
			}
			if(ClanWarInfo[GetPlayerClan(playerid)][cw_ready] == 1)
			{
				return SendErrorMessage(playerid, "You have already accepted the clanwar. Use /clanwar unready if possible");
			}
			if(GetPVarInt(val, "AtClanWar") != 1)
			{
				return SendErrorMessage(playerid, "This player has yet to accept any clanwar, so no point kicking him..");
			}
			else
			{
				DeletePVar(val, "AtClanWar");
				DeletePVar(val, "CW_Invited");
				format(string2, sizeof(string2), "[CLANWAR]: %s(%d) has kicked you from the clanwar.", PlayerName(playerid), playerid);
				SendClientMessage(val, COLOR_GREEN, string2);
				format(string2, sizeof(string2), "[CLANWAR]: You have kicked %s(%d) from the clanwar.", PlayerName(val), val);
				SendClientMessage(playerid, COLOR_GREEN, string2);
				ClanWarInfo[GetPlayerClan(playerid)][cw_slots_left]--;
				for(new i = 0; i < ClanWars[ClanWarInfo[GetPlayerClan(playerid)][cw_main]][cw_members]; j++)
				{
					if(ClanWar_Members[GetPlayerClan(playerid)][i] == val)
					{
						ClanWar_Members[GetPlayerClan(playerid)][i] = -1;
					}
				}
				SpawnPlayer(val);
			}
			return 1;
		}
		else
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /clanwar (edit, request, accept, deny, invite [ID], kick, ready, info)");
		}
	}
	else
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /clanwar (edit, request, accept, deny, invite [ID], kick, ready, info)");
	}
}

/*
	Check if both teams have readied up, and error check.
	If both are ready, make sure you start the timer and teleport them to correct positions etc.
	Cancel clanwar if something is wrong I guess.
*/
public CW_Check_Readyness(clan)
{

}

forward ClanWar_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
public ClanWar_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    print("ODR_pEar_CW");
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
}

		


CMD:accept(playerid, params[])
{
	new result[20], string[128];
	if (sscanf(params, "s[20] ", result))
	{
		format(string, sizeof(string), "[USAGE]: {%06x}/accept {%06x}[Parameter]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string), "[PARAMS]: {%06x}clan - duel - clanwar", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		return 1;
	}
	
	if(strcmp(result,"clanwar", true) == 0)
	{
		if(FoCo_Teams[FoCo_Team[playerid]][team_clanwar_enemy] == 0) 
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have not been invited to any clan war.");
			return 1;
		}
		
		if(FoCo_Teams[FoCo_Team[playerid]][team_clanwar_members] == 0) 
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The clanwar is full, sorry.");
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
		
		FoCo_Teams[FoCo_Team[playerid]][team_clanwar_members]--;
		ClanWar_Joining[playerid] = 1;
		FoCo_Teams[FoCo_Team[playerid]][team_clanwar_attending] = 1;
		SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You are on the shortlist waiting for the event to start");
		SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Try to stay near spawn, so you don't die. If you die before the event");
		SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: .. you probably won't be teleported there as you will go into spectate..");
		return 1;
	}
	else if(strcmp(result,"clan", true) == 0)
	{
		if(GetPVarInt(playerid, "ClanInvite") < 1)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have not been invited to any clan.");
			return 1;
		}
		
		FoCo_Player[playerid][clan] = GetPVarInt(playerid, "ClanInvite");
		FoCo_Player[playerid][clanrank] = FoCo_Teams[FoCo_Player[playerid][clan]][team_rank_amount];
		if(FoCo_Player[playerid][clan] == 21)
		{
		    GiveAchievement(playerid, 99);
		}
		else
		{
		    GiveAchievement(playerid, 75);
		}
		
		format(string, sizeof(string), "                You have joined '%s'!", FoCo_Teams[FoCo_Player[playerid][clan]][team_name]);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		DeletePVar(playerid, "ClanInvite");
		return 1;
	}
	return 1;
}
