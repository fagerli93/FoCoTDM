/*

					*********************************************************************************
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
					* Filename: turfwar.pwn                                                          *
					* Author: Shaney & dr_vista                                                      *
					**********************************************************************************
	OVERVIEW:

		- Turfs load in from database.
		- Turfs can be added and deleted in-game.
		- Turfs can be given a perk. (Extra Ammo for owners. || Extra Armour || Double Money on Kills || 5% extra damage || Grenades || Access to /medipack)
		- Turfs can be re-captured after 20 minutes of original capture.
		- You start turf capture by entering the turf dynamic pickup.
		- You must remain in the Gang Zone / Within close distance to the checkpoint for 3 minutes without being killed.
		- You cannot be in a vehicle to take over the turf.

		- There will be 1 timer. (1 minute timer, which every minute calls TurfWar_Check())
		- Maximum of 10 Turfs

	Table SQL:
	create table FoCo_Turfs (
		ID INT AUTO_INCREMENT PRIMARY KEY,
		gz_name varchar(40),
		gz_pickup_x float,
		gz_pickup_y float,
		gz_pickup_z float,
		gz_pickup_world int,
		gz_pickup_int int,
		gz_pickup_model int,
		gz_pickup_type int,
		gz_min_x float,
		gz_min_y float,
		gz_max_x float,
		gz_max_y float,
		gz_perk int
	);

	INSERT INTO FoCo_Turfs (gz_name, gz_pickup_x, gz_pickup_y, gz_pickup_z, gz_pickup_world, gz_pickup_int, gz_pickup_model, gz_pickup_type, gz_min_x, gz_min_y, gz_max_x, gz_max_y, gz_perk) VALUES ('Available Turf', '0.0', '0.0', '0.0', '0', '0', '1318', '1', '0.0', '0.0', '0.0', '0.0', '0');

	TODO:


*/
#include <YSI\y_hooks>

// Defines
#define MAX_TURFS 10

#define TURF_PICKUP_DISTANCE 50.0

#define DIALOG_TURF_INFO 600
#define DIALOG_TURF_EDIT 601
#define DIALOG_TURF_RESET 602
#define DIALOG_TURF_INFO_2 603
#define DIALOG_TURF_EDIT_TOOLS 604
#define DIALOG_TURF_EDIT_NAME 605
#define DIALOG_TURF_EDIT_PERK 606

#define DIALOG_TURF_TIME 529

#define FT_TAKEOVER_TIME 60 /* Take Over time in seconds */
#define FT_INTERVAL_BETWEEN_TAKEOVERS 120 /* Interval between take overs in minutes */

#define FT_PERK_AMMO 0
#define FT_PERK_ARMOUR 1
#define FT_PERK_DOUBLE_MONEY 2
#define FT_PERK_EXTRA_DAMAGE 3
#define FT_PERK_GRENADES 4
#define FT_PERK_MEDIPACK 5

#define MAX_TURF_NAME 21



// Variables Here.
enum E_FoCo_Turfs
{
	FT_ID,
	FT_PICKUP_ID,
	FT_GZ_ID,
	FT_NAME[MAX_TURF_NAME+1],
	Float:FT_PICKUP_X,
	Float:FT_PICKUP_Y,
	Float:FT_PICKUP_Z,
	FT_PICKUP_WORLD,
	FT_PICKUP_INT,
	FT_PICKUP_MODEL,
	FT_PICKUP_TYPE,
	Float:FT_MIN_X,
	Float:FT_MIN_Y,
	Float:FT_MAX_X,
	Float:FT_MAX_Y,
	FT_PERK,
	FT_TEAM,
	FT_TEAM_COLOR[9],
	FT_PLAYER_GAINED[25],
	FT_TAKEOVER,
	bool:FT_TAKEOVER_START,
	FT_TAKEOVER_PLAYER,
	FT_LAST_TAKEOVER,
	FT_TAKEOVER_ICON
};
new FoCo_Turfs[MAX_TURFS][E_FoCo_Turfs];

new Turf_Perks[6][] = {
	{"Extra Ammo"},
	{"Extra Armour"},
	{"Double Money On Kills"},
	{"5% Extra Damage"},
	{"Grenades"},
	{"Access to /medipack"}
};

new
	TurfSys_Zone_Edit[MAX_PLAYERS] = -1,
	TurfSys_Zone_Takeover = -1,
	TurfSys_TakeOverTimer,
	TurfSys_TakeOverInProgress,
	TurfSys_InAreaTimer,
	Float:TurfSys_Min_X[MAX_PLAYERS] = 0.0,
	Float:TurfSys_Min_Y[MAX_PLAYERS] = 0.0,
	TurfSys_GlobalTurf;



// SQL-Loading
forward TurfSys_LoadGangZones();
public TurfSys_LoadGangZones()
{
	mysql_store_result();
    new zones[15][100],
		results[290],
		string[22],
		col[9],
		i = 0;
	while(mysql_fetch_row(results))
	{
		split(results, zones, '|');
		FoCo_Turfs[i][FT_ID] = strval(zones[0]);
		FoCo_Turfs[i][FT_PICKUP_X] = floatstr(zones[2]);
		FoCo_Turfs[i][FT_PICKUP_Y] = floatstr(zones[3]);
		FoCo_Turfs[i][FT_PICKUP_Z] = floatstr(zones[4]);
		FoCo_Turfs[i][FT_PICKUP_WORLD] = strval(zones[5]);
		FoCo_Turfs[i][FT_PICKUP_INT] = strval(zones[6]);
		FoCo_Turfs[i][FT_PICKUP_MODEL] = strval(zones[7]);
		FoCo_Turfs[i][FT_PICKUP_TYPE] = strval(zones[8]);
		FoCo_Turfs[i][FT_MIN_X] = floatstr(zones[9]);
		FoCo_Turfs[i][FT_MIN_Y] = floatstr(zones[10]);
		FoCo_Turfs[i][FT_MAX_X] = floatstr(zones[11]);
		FoCo_Turfs[i][FT_MAX_Y] = floatstr(zones[12]);
		FoCo_Turfs[i][FT_PERK] = strval(zones[13]);
		format(string, sizeof(string), "%s", zones[1]);
		FoCo_Turfs[i][FT_NAME] = string;
		format(col, sizeof(col), "0xC3C3C3");
		FoCo_Turfs[i][FT_TEAM_COLOR] = col;
		FoCo_Turfs[i][FT_TAKEOVER_START] = false;

		FoCo_Turfs[i][FT_PICKUP_ID] = CreateDynamicPickup(FoCo_Turfs[i][FT_PICKUP_MODEL], FoCo_Turfs[i][FT_PICKUP_TYPE], FoCo_Turfs[i][FT_PICKUP_X], FoCo_Turfs[i][FT_PICKUP_Y], FoCo_Turfs[i][FT_PICKUP_Z], FoCo_Turfs[i][FT_PICKUP_WORLD], FoCo_Turfs[i][FT_PICKUP_INT], -1, TURF_PICKUP_DISTANCE);
		FoCo_Turfs[i][FT_GZ_ID] = GangZoneCreate(FoCo_Turfs[i][FT_MIN_X], FoCo_Turfs[i][FT_MIN_Y], FoCo_Turfs[i][FT_MAX_X], FoCo_Turfs[i][FT_MAX_Y]);
		printf("[%d] Turf Created! - GZID: %d - PIKID: %d - PKX: %f - PKY: %f - PKZ: %f - PKMODEL: %d - PKTYPE: %d - PKWORLD: %d - PKINT: %d", i, FoCo_Turfs[i][FT_GZ_ID], FoCo_Turfs[i][FT_PICKUP_ID], FoCo_Turfs[i][FT_PICKUP_X], FoCo_Turfs[i][FT_PICKUP_Y], FoCo_Turfs[i][FT_PICKUP_Z], FoCo_Turfs[i][FT_PICKUP_MODEL], FoCo_Turfs[i][FT_PICKUP_TYPE], FoCo_Turfs[i][FT_PICKUP_WORLD], FoCo_Turfs[i][FT_PICKUP_INT]);
		i++;
	}
	mysql_free_result();
    return 1;
}

hook OnGameModeInit()
{
	SetTimer("TurfSys_InitChooseTurf", 10000, false);
	return 1;
}

forward TurfSys_InitChooseTurf();
public TurfSys_InitChooseTurf()
{
    for(new i; i < MAX_TURFS; i++)
	{
	    if(FoCo_Turfs[i][FT_PICKUP_X] != 0.0 || FoCo_Turfs[i][FT_PICKUP_Y] != 0.0 || FoCo_Turfs[i][FT_PICKUP_Z] != 0.0)
	    {
			FoCo_Turfs[i][FT_TAKEOVER_START] = true;
			break;
		}
	}
}

hook OnPlayerSpawn(playerid)
{
    TurfSys_Zone_Edit[playerid] = -1;
    
    for(new i = 0; i < MAX_TURFS; i++)
	{
		if(FoCo_Turfs[i][FT_PICKUP_TYPE] != 0)
		{
			GangZoneShowForPlayer(playerid, FoCo_Turfs[i][FT_GZ_ID], hexstr(FoCo_Turfs[i][FT_TEAM_COLOR]));
			if(FoCo_Turfs[i][FT_TAKEOVER] == 1)
			{
				GangZoneFlashForPlayer(playerid, FoCo_Turfs[i][FT_GZ_ID], COLOR_RED);
			}
		}
		
		if(FoCo_Turfs[i][FT_TAKEOVER_START] == true)
		{
			new string[61];
			format(string, sizeof(string), "[TURF]: Turf %s is available for capture.", FoCo_Turfs[i][FT_NAME]);
			SendClientMessage(playerid, COLOR_GREEN, string);
		}
	}

    SetPVarInt(playerid, "ExtraDamage", false);
    SetPVarInt(playerid, "Medipack", false);

   	SetTimerEx("TurfSys_GivePerks", 2000, false, "di", 0, playerid);
   	return 1;
}

forward TurfSys_ShowGangZones(playerid, type);
public TurfSys_ShowGangZones(playerid, type)
{
	new
		string[110],
		item[MAX_TURF_NAME+1];

	for(new i = 0; i < MAX_TURFS; i++)
	{
		if(FoCo_Turfs[i][FT_PICKUP_TYPE] == 0)
		{
			strcat(string, " -- No Turf Added --\n");
		}

		else
		{
			format(item, sizeof(item), "%s\n", FoCo_Turfs[i][FT_NAME]);
			strcat(string, item);
		}
	}

	if(type == 1)
	{
		ShowPlayerDialog(playerid, DIALOG_TURF_INFO, DIALOG_STYLE_LIST, "Select a Turf", string, "Select", "Close");
	}

	if(type == 2)
	{
		ShowPlayerDialog(playerid, DIALOG_TURF_EDIT, DIALOG_STYLE_LIST, "Select a Turf", string, "Select", "Close");
	}

	if(type == 3)
	{
		ShowPlayerDialog(playerid, DIALOG_TURF_RESET, DIALOG_STYLE_LIST, "Select a Turf", string, "Select", "Close");
	}

	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_TURF_INFO:
		{
			if(!response) return 1;

			new
				string[230];
			format(string, sizeof(string), "Zone ID: %d\nZone Name: %s\nZone PickupID: %d\nZone DBID: %d\nZone PWorld: %d\nZone PType: %d\nZone Perk: %s\nZone Team Held: %d\nZone Color: %s\nZone Player Gained: %s\nZone Takeover: %d",
				FoCo_Turfs[listitem][FT_GZ_ID], FoCo_Turfs[listitem][FT_NAME], FoCo_Turfs[listitem][FT_PICKUP_ID], FoCo_Turfs[listitem][FT_ID], FoCo_Turfs[listitem][FT_PICKUP_WORLD], FoCo_Turfs[listitem][FT_PICKUP_TYPE], GetPerkName(FoCo_Turfs[listitem][FT_PERK]), FoCo_Turfs[listitem][FT_TEAM], FoCo_Turfs[listitem][FT_TEAM_COLOR], FoCo_Turfs[listitem][FT_PLAYER_GAINED], FoCo_Turfs[listitem][FT_TAKEOVER]);
			ShowPlayerDialog(playerid, DIALOG_TURF_INFO_2, DIALOG_STYLE_MSGBOX, "Turf Information:", string, "OK", "BACK");
		}
		case DIALOG_TURF_INFO_2:
		{
		    if(response)
			{
				return 1;
			}
			else
			{
		    	TurfSys_ShowGangZones(playerid, 1);
		    }
		}
		case DIALOG_TURF_EDIT:
		{
			if(!response) return 1;
			TurfSys_Zone_Edit[playerid] = listitem;
			ShowPlayerDialog(playerid, DIALOG_TURF_EDIT_TOOLS, DIALOG_STYLE_LIST, "Edit Turf List", "Pickup Position\nGangZone Position\nGangZone Name\nGangZone Perk", "Select", "Close");
		}
		case DIALOG_TURF_EDIT_TOOLS:
		{
				if(!response) return 1;
				switch(listitem)
				{
					case 0: return SendClientMessage(playerid, COLOR_NOTICE, "[TurfSys]: To set a new pickup position go to the location and type /aturf pickup.");
					case 1: return SendClientMessage(playerid, COLOR_NOTICE, "[TurfSys]: To set a new gangzone position go to the location and type /aturf gangzone.");
					case 2: return ShowPlayerDialog(playerid, DIALOG_TURF_EDIT_NAME, DIALOG_STYLE_INPUT, "New Turf Name", "Please select a name for the new turf.", "Select", "Close");
					case 3: return ShowPlayerDialog(playerid, DIALOG_TURF_EDIT_PERK, DIALOG_STYLE_LIST, "Select a Perk", "Extra Ammo\nExtra Armour\nDouble Money On Kills\n5% Extra Damage\nGrenades\nAccess to /medipack", "Select", "Close");
				}
		}
		case DIALOG_TURF_EDIT_NAME:
		{
			if(!response) return 1;
			
			if(strlen(inputtext) > MAX_TURF_NAME)
			{
			    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Max turf name is  "#MAX_TURF_NAME"");
			}

			new
				string[115],
				name[MAX_TURF_NAME+1];

			format(string, sizeof(string), "update FoCo_Turfs set gz_name = '%s' where `ID` = '%d'", inputtext, FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_ID]);
			mysql_query(string, THREAD_TURFSYS_UPDATE);

			format(name, sizeof(name), "%s", inputtext);
			FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_NAME] = name;

			format(string, sizeof(string), "AdmCmd(5): %s %s has updated gangzone %d (NAME: %s)", GetPlayerStatus(playerid), PlayerName(playerid), TurfSys_Zone_Edit[playerid], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_NAME]);
			SendAdminMessage(5, string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			return 1;
		}
		case DIALOG_TURF_EDIT_PERK:
		{
			if(!response) return 1;

			new
				string[95];

			format(string, sizeof(string), "update FoCo_Turfs set gz_perk = '%d' where `ID` = '%d'", listitem, FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_ID]);
			mysql_query(string, THREAD_TURFSYS_UPDATE);

			FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PERK] = listitem;

			format(string, sizeof(string), "AdmCmd(5): %s %s has updated gangzone %d (PERK: %s)", GetPlayerStatus(playerid), PlayerName(playerid), TurfSys_Zone_Edit[playerid], Turf_Perks[listitem][0]);
			SendAdminMessage(5, string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		}
		case DIALOG_TURF_RESET:
		{
			if(!response) return 1;
			TurfSys_ResetGangZone(playerid, listitem);
		}
	}
	return 1;
}

forward TurfSys_ResetGangZone(playerid, listitem);
public TurfSys_ResetGangZone(playerid, listitem)
{
	new str[9],
		name[MAX_TURF_NAME+1],
		string[265];
	// Delete Pickup
	
	DestroyDynamicPickup(FoCo_Turfs[listitem][FT_PICKUP_ID]);
	// Delete GangZone
	GangZoneHideForAll(FoCo_Turfs[listitem][FT_GZ_ID]);
	GangZoneDestroy(FoCo_Turfs[listitem][FT_GZ_ID]);

	// Reset Variables

	FoCo_Turfs[listitem][FT_PICKUP_ID] = 0;
	format(name, sizeof(name), "Available turf");
	FoCo_Turfs[listitem][FT_NAME] = name;
	FoCo_Turfs[listitem][FT_PICKUP_X] = 0.0;
	FoCo_Turfs[listitem][FT_PICKUP_Y] = 0.0;
	FoCo_Turfs[listitem][FT_PICKUP_Z] = 0.0;
	FoCo_Turfs[listitem][FT_PICKUP_WORLD] = 0;
	FoCo_Turfs[listitem][FT_PICKUP_INT] = 0;
	FoCo_Turfs[listitem][FT_PICKUP_MODEL] = 1318;
	FoCo_Turfs[listitem][FT_PICKUP_TYPE] = 1;
	FoCo_Turfs[listitem][FT_MIN_X] = 0.0;
	FoCo_Turfs[listitem][FT_MIN_Y] = 0.0;
	FoCo_Turfs[listitem][FT_MAX_X] = 0.0;
	FoCo_Turfs[listitem][FT_MAX_Y] = 0.0;
	FoCo_Turfs[listitem][FT_PERK] = 0;
	FoCo_Turfs[listitem][FT_TEAM] = 0;
	format(str, sizeof(str), "0xC3C3C3");
	FoCo_Turfs[listitem][FT_TEAM_COLOR] = str;
	FoCo_Turfs[listitem][FT_PLAYER_GAINED]  = 0;
	FoCo_Turfs[listitem][FT_TAKEOVER]  = 0;
	FoCo_Turfs[listitem][FT_TAKEOVER_START]  = false;
	FoCo_Turfs[listitem][FT_LAST_TAKEOVER] = 0;

	// Update Databse
	format(string, sizeof(string), "update FoCo_Turfs set gz_name = 'Available Turf', gz_pickup_x = '0.0', gz_pickup_y = '0.0', gz_pickup_z = '0.0', gz_pickup_world = '0', gz_pickup_type = '1', gz_min_x = '0.0', gz_min_y = '0.0', gz_max_x = '0.0', gz_max_y = '0.0', gz_perk = '0' where `ID` = '%d'", FoCo_Turfs[listitem][FT_ID]);
	mysql_query(string, THREAD_RESET_TURF);

	// inform IRC and admins
	format(string, sizeof(string), "AdmCmd(5): %s %s has reset gangzone %d", GetPlayerStatus(playerid), PlayerName(playerid), listitem);
	SendAdminMessage(5, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	return 1;
}

stock IsValidTurf(turfid)
{
	if(FoCo_Turfs[turfid][FT_PICKUP_X] + FoCo_Turfs[turfid][FT_PICKUP_Y] + FoCo_Turfs[turfid][FT_PICKUP_Z] == 0.0)
	    return 0;
	return 1;
}

hook OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	for(new i; i < MAX_TURFS; i++)
	{
	    if(pickupid == FoCo_Turfs[i][FT_PICKUP_ID] && IsValidTurf(i))
	    {
			if(TurfSys_TakeOverInProgress == 1)
		    {
		        if(FoCo_Turfs[i][FT_PICKUP_ID] != FoCo_Turfs[TurfSys_Zone_Takeover][FT_PICKUP_ID])
		        {
		        	return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot take over this turf as another one is being taken over at the moment.");
		        }

				if(FoCo_Turfs[i][FT_PICKUP_ID] == FoCo_Turfs[TurfSys_Zone_Takeover][FT_PICKUP_ID])
		        {
		            if(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER] == playerid)
		            {
		            	return 1;
		            }
		            
		            else
					{
					    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This turf is being taken over, therefore you cannot take it over.");
					}
				}
			}

			if(TurfSys_Zone_Edit[playerid] != -1)
			{
			    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot take over this turf when you're editing a turf.");
			}

			if(Spectating[playerid] != -1)
			{
			    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot take over this turf when you're spectating someone.");
			}

			if(ADuty[playerid] == 1)
			{
	            return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot take over this turf when you're on admin duty.");
			}
			
			if(FoCo_Turfs[i][FT_PICKUP_X] == 0.0 && FoCo_Turfs[i][FT_PICKUP_Y] == 0.0 && FoCo_Turfs[i][FT_PICKUP_Z] == 0.0)
			{
			    return 1;
			}

           	TurfSys_Zone_Takeover = i;

	    	if(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TEAM] == FoCo_Team[playerid])
	 		{
			    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your team already owns this turf.");
			}

			else
			{
			    if(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_START] == true)
			    {
			   		FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER] = playerid;
			   		TurfSys_BeginTakeover(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER]);
				}
				
				else
				{
				    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This turf is not available yet.");
				}
		    	return 1;
		    }
        }
    }
    return 1;
}

forward TurfSys_BeginTakeover(playerid);
public TurfSys_BeginTakeover(playerid)
{
	new
		string[76];

	format(string, sizeof(string), "[TURF]: %s is taking over turf %s", PlayerName(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER]), FoCo_Turfs[TurfSys_Zone_Takeover][FT_NAME]);

	SendClientMessageToAll(COLOR_GREEN, string);

	FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER] = 1;
	TurfSys_TakeOverInProgress = 1;

	GangZoneFlashForAll(FoCo_Turfs[TurfSys_Zone_Takeover][FT_GZ_ID], COLOR_RED);
	FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_ICON] = CreateDynamicMapIcon(FoCo_Turfs[TurfSys_Zone_Takeover][FT_PICKUP_X], FoCo_Turfs[TurfSys_Zone_Takeover][FT_PICKUP_Y], FoCo_Turfs[TurfSys_Zone_Takeover][FT_PICKUP_Z], 18, 0, -1, -1, -1, 500.0);

	TurfSys_TakeOverTimer = SetTimer("TurfSys_TakeOverComplete", FT_TAKEOVER_TIME*1000, 0);
	TurfSys_InAreaTimer = SetTimerEx("TurfSys_InArea", 3000, true, "i", playerid);

	return 1;
}

forward TurfSys_InArea(playerid);
public TurfSys_InArea(playerid)
{
	if(!Turfwar_IsPlayerInCube(playerid, FoCo_Turfs[TurfSys_Zone_Takeover][FT_MIN_X], FoCo_Turfs[TurfSys_Zone_Takeover][FT_MAX_X], FoCo_Turfs[TurfSys_Zone_Takeover][FT_MIN_Y], FoCo_Turfs[TurfSys_Zone_Takeover][FT_MAX_Y], 0, FoCo_Turfs[TurfSys_Zone_Takeover][FT_PICKUP_Z]+30) || IsPlayerInAnyVehicle(playerid))
	{
	    new string[85];
	   	format(string, sizeof(string), "[TURF]: %s has failed to take over turf %s", PlayerName(playerid), FoCo_Turfs[TurfSys_Zone_Takeover][FT_NAME]);
		SendClientMessageToAll(COLOR_GREEN, string);
	    TurfSys_CancelTakeOver(playerid);
	}
	return 1;
}

forward TurfSys_TakeOverComplete();
public TurfSys_TakeOverComplete()
{
	/* Update the turf and set it claimed to the player's team */

	KillTimer(TurfSys_InAreaTimer);

	new
		string[138],
		col[9],
		strpos,
		trfquery[128+MAX_PLAYER_NAME];

	FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER] = -1;
	FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_START] = false;
	FoCo_Turfs[TurfSys_Zone_Takeover][FT_TEAM] = FoCo_Team[FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER]];

	format(col, sizeof(col), "%s", FoCo_Teams[FoCo_Team[FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER]]][team_color]);

	strpos = strfind(col, "0x", true);

    if(strpos != -1)
    {
		strdel(col, strpos, strpos+2);
    }

	strdel(col, 6, 8);
	strins(col, "88", 6);

	FoCo_Turfs[TurfSys_Zone_Takeover][FT_TEAM_COLOR] = col;
    format(FoCo_Turfs[TurfSys_Zone_Takeover][FT_PLAYER_GAINED], MAX_PLAYER_NAME, "%s", PlayerName(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER]));
    FoCo_Turfs[TurfSys_Zone_Takeover][FT_LAST_TAKEOVER] = GetUnixTime();

	TurfSys_GivePerks(1, FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER]);

	format(string, sizeof(string), "[TURF]: %s and his team %s have captured turf %s", PlayerName(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER]), FoCo_Teams[FoCo_Turfs[TurfSys_Zone_Takeover][FT_TEAM]][team_name], FoCo_Turfs[TurfSys_Zone_Takeover][FT_NAME]);
	GiveAchievement(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER], 65);
	SendClientMessageToAll(COLOR_GREEN, string);
	
	FoCo_PlayerStats_turf[FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER]]++;
	
	format(trfquery, sizeof(trfquery), "UPDATE `TBLNAME` SET `FIELDNAME  = `FIELDNAME` + 1 WHERE `USERNAMEFIELD` = %s", PlayerName(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER]));

	/* Gang Zone Reload */

	GangZoneHideForAll(FoCo_Turfs[TurfSys_Zone_Takeover][FT_GZ_ID]);
	GangZoneDestroy(FoCo_Turfs[TurfSys_Zone_Takeover][FT_GZ_ID]);

	FoCo_Turfs[TurfSys_Zone_Takeover][FT_GZ_ID] = GangZoneCreate(FoCo_Turfs[TurfSys_Zone_Takeover][FT_MIN_X], FoCo_Turfs[TurfSys_Zone_Takeover][FT_MIN_Y], FoCo_Turfs[TurfSys_Zone_Takeover][FT_MAX_X], FoCo_Turfs[TurfSys_Zone_Takeover][FT_MAX_Y]);
	GangZoneShowForAll(FoCo_Turfs[TurfSys_Zone_Takeover][FT_GZ_ID], hexstr(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TEAM_COLOR]));
	DestroyDynamicMapIcon(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_ICON]);
	
	TurfSys_GlobalTurf = TurfSys_Zone_Takeover+1;
	SetTimer("TurfSys_NextTurfAvailable", FT_INTERVAL_BETWEEN_TAKEOVERS*60000, false);

    FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER] = -1;
	TurfSys_Zone_Takeover = -1;
	TurfSys_TakeOverInProgress = 0;
	

	return 1;
}

forward TurfSys_NextTurfAvailable();
public TurfSys_NextTurfAvailable()
{
    new
		string[56];

	if(FoCo_Turfs[TurfSys_GlobalTurf][FT_PICKUP_X] == 0.0 && FoCo_Turfs[TurfSys_GlobalTurf][FT_PICKUP_Y] == 0.0 && FoCo_Turfs[TurfSys_GlobalTurf][FT_PICKUP_Z] == 0.0)
	{
	    TurfSys_GlobalTurf = 0;
	}

    FoCo_Turfs[TurfSys_GlobalTurf][FT_TAKEOVER_START] = true;
	format(string, sizeof(string), "[TURF]: Turf %s can now be captured.", FoCo_Turfs[TurfSys_GlobalTurf][FT_NAME]);
	SendClientMessageToAll(COLOR_GREEN, string);
	
	FoCo_Turfs[TurfSys_GlobalTurf][FT_TEAM] = 0;
	
	/* Gang Zone Reload */
	
	new colour[9];
	format(colour, sizeof(colour), "0xC3C3C3");
	FoCo_Turfs[TurfSys_GlobalTurf][FT_TEAM_COLOR] = colour;

	GangZoneHideForAll(FoCo_Turfs[TurfSys_GlobalTurf][FT_GZ_ID]);
	GangZoneDestroy(FoCo_Turfs[TurfSys_GlobalTurf][FT_GZ_ID]);

	FoCo_Turfs[TurfSys_GlobalTurf][FT_GZ_ID] = GangZoneCreate(FoCo_Turfs[TurfSys_GlobalTurf][FT_MIN_X], FoCo_Turfs[TurfSys_GlobalTurf][FT_MIN_Y], FoCo_Turfs[TurfSys_GlobalTurf][FT_MAX_X], FoCo_Turfs[TurfSys_GlobalTurf][FT_MAX_Y]);
	GangZoneShowForAll(FoCo_Turfs[TurfSys_GlobalTurf][FT_GZ_ID], hexstr(FoCo_Turfs[TurfSys_GlobalTurf][FT_TEAM_COLOR]));


}

forward TurfSys_CancelTakeOver(playerid);
public TurfSys_CancelTakeOver(playerid)
{
	KillTimer(TurfSys_TakeOverTimer);
 	KillTimer(TurfSys_InAreaTimer);

	GangZoneStopFlashForAll(FoCo_Turfs[TurfSys_Zone_Takeover][FT_GZ_ID]);
   	DestroyDynamicMapIcon(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_ICON]);

	FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER] = -1;
	FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER] = -1;

	TurfSys_Zone_Takeover = -1;
	TurfSys_TakeOverInProgress = 0;

	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	if(TurfSys_Zone_Takeover != -1)
	{
	    if(playerid == FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER]) /* if the player dies while capturing, the capture has failed */
		{
		    new
				string[88];
	  		format(string, sizeof(string), "[TURF:] %s has died while taking over turf %s.", PlayerName(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER]), FoCo_Turfs[TurfSys_Zone_Takeover][FT_NAME]);
			SendClientMessageToAll(COLOR_GREEN, string);
			TurfSys_CancelTakeOver(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER]);
		}
	}
	
	for(new i; i < MAX_TURFS; i++)
	{
	    if(killerid != INVALID_PLAYER_ID)
	    {
		    if(FoCo_Turfs[i][FT_TEAM] == FoCo_Team[killerid] && FoCo_Turfs[i][FT_PERK] == FT_PERK_DOUBLE_MONEY)
		    {
	        	GivePlayerMoney(killerid, 300);
				new moneystring[256];
				format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from Turf_Taker_Kill.", PlayerName(killerid), killerid, 300);
				MoneyLog(moneystring);
			}
		}
	}

	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(TurfSys_Zone_Takeover != -1)
	{
		if(playerid == FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER]) /* if the player disconnects while capturing, the capture has failed */
		{
			new string[128];
			format(string, sizeof(string), "[TURF:] %s has quit while taking over turf %s", PlayerName(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER]), FoCo_Turfs[TurfSys_Zone_Takeover][FT_NAME]);
			SendClientMessageToAll(COLOR_GREEN, string);
			TurfSys_CancelTakeOver(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TAKEOVER_PLAYER]);
		}
	}
	return 1;
}

stock GetPerkName(pid)
{
	new str[20];
	format(str, sizeof(str), "%s", Turf_Perks[pid][0]);
	return str;
}

// Commands.

CMD:aturf(playerid, params[])
{
	if(IsAdmin(playerid, 5))
	{
		if(!CMD_Auth(playerid)) return 1;
		new stat[20], string[255];
		if (sscanf(params, "s[20] ", stat))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: {FFFFFF}/aturf{969696} [Options]");
			SendClientMessage(playerid, COLOR_SYNTAX, "[PARAMS]: Info, Edit, Reset, Stopedit");
			SendClientMessage(playerid, COLOR_SYNTAX, "[PARAMS]: (If GZ Set) Pickup, GangZone");
			return 1;
		}

		if(strcmp(stat,"info", true) == 0)
		{
			TurfSys_ShowGangZones(playerid, 1);
		}
		else if(strcmp(stat,"edit", true) == 0)
		{
			TurfSys_ShowGangZones(playerid, 2);
		}
		else if(strcmp(stat, "reset", true) == 0)
		{
			TurfSys_ShowGangZones(playerid, 3);
		}
		else if(strcmp(stat, "pickup", true) == 0)
		{
			if(TurfSys_Zone_Edit[playerid] == -1) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have not set the TurfSys_Zone_Edit variable. Please /aturf edit first.");

			new Float:Tx, Float:Ty, Float:Tz;
			GetPlayerPos(playerid, Tx, Ty, Tz);

			FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_X] = Tx;
			FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_Y] = Ty;
			FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_Z] = Tz;
			FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_WORLD] = GetPlayerVirtualWorld(playerid);
			FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_INT] = GetPlayerInterior(playerid);
			FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_TYPE] = 1;
			FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_MODEL] = 1318;

			format(string, sizeof(string), "update FoCo_Turfs set gz_pickup_x = '%f', gz_pickup_y = '%f', gz_pickup_z = '%f', gz_pickup_world = '%d', gz_pickup_int = '%d', gz_pickup_model = '%d', gz_pickup_type = '%d' where `ID` = '%d'",
				FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_X], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_Y], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_Z], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_WORLD], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_INT], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_MODEL], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_TYPE], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_ID]);
			mysql_query(string, THREAD_TURFSYS_UPDATE);

			DestroyDynamicPickup(FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_ID]);
			FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_ID] = CreateDynamicPickup(FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_MODEL], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_TYPE], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_X], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_Y], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_Z], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_WORLD], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_INT], -1, TURF_PICKUP_DISTANCE);

			format(string, sizeof(string), "AdmCmd(5): %s %s has moved gangzone %d's pickup  (ID: %d)", GetPlayerStatus(playerid), PlayerName(playerid), TurfSys_Zone_Edit[playerid], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_PICKUP_ID]);
			SendAdminMessage(5, string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			return 1;
		}
		else if(strcmp(stat, "gangzone", true) == 0)
		{
			if(TurfSys_Zone_Edit[playerid] == -1) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have not set the TurfSys_Zone_Edit variable. Please /aturf edit first.");

			new Float:Tx, Float:Ty, Float:Tz;
			GetPlayerPos(playerid, Tx, Ty, Tz);

			if(TurfSys_Min_X[playerid] == 0.0) {
				TurfSys_Min_X[playerid] = Tx;
				TurfSys_Min_Y[playerid] = Ty;
				SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: We have stored the XYZ of your current pos. Please go to the MAX XY location.");
			} else {
				FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_MIN_X] = TurfSys_Min_X[playerid];
				FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_MIN_Y] = TurfSys_Min_Y[playerid];
				FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_MAX_X] = Tx;
				FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_MAX_Y] = Ty;

				TurfSys_Min_X[playerid] = 0.0;
				TurfSys_Min_Y[playerid] = 0.0;

				format(string, sizeof(string), "update FoCo_Turfs set gz_min_x = '%f', gz_min_y = '%f', gz_max_x = '%f', gz_max_y = '%f' where `ID` = '%d'",
					FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_MIN_X], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_MIN_Y], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_MAX_X], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_MAX_Y], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_ID]);
				mysql_query(string, THREAD_TURFSYS_UPDATE);

				GangZoneHideForAll(FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_GZ_ID]);
				GangZoneDestroy(FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_GZ_ID]);
				FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_GZ_ID] = GangZoneCreate(FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_MIN_X], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_MIN_Y], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_MAX_X], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_MAX_Y]);
				GangZoneShowForAll(FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_GZ_ID], 0xC3C3C3);
				FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_TEAM] = 0;

				format(string, sizeof(string), "AdmCmd(5): %s %s has moved gangzone %d's location (ID: %d)", GetPlayerStatus(playerid), PlayerName(playerid), TurfSys_Zone_Edit[playerid], FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_GZ_ID]);
				SendAdminMessage(5, string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}
			return 1;
		}

		else if(strcmp(stat, "stopedit", true) == 0)
		{
			if(TurfSys_Zone_Edit[playerid] == -1)
			{
			    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not editing any turf.");
			}

		    format(string, sizeof(string), "You have stopped editing turf %s", FoCo_Turfs[TurfSys_Zone_Edit[playerid]][FT_NAME]);
			SendClientMessage(playerid, COLOR_NOTICE, string);
			TurfSys_Zone_Edit[playerid] = -1;

			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Unknown parameter.");
			return 1;
		}
	}

	return 1;
}

CMD:medipack(playerid, params[])
{
	if(GetPVarInt(playerid, "Medipack") == 1)
	{
	    new Float:Health, string[125];
	    GetPlayerHealth(playerid, Health);
	    if(Health >= 99.0)
	    {
	        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your health is already full.");
		}

		if(Health + 25 > 99)
		{
		    SetPlayerHealth(playerid, 99);
			format(string,sizeof(string),"[Guardian]: {ff6347}%s has used the /medipack command (Old Health (%.2f), New health (%d))", PlayerName(playerid), Health, 99);
			SendAdminMessage(1, string);
		}

		else
		{
			SetPlayerHealth(playerid, Health + 25);
			format(string,sizeof(string),"[Guardian]: {ff6347}%s has used the /medipack command (Old Health (%.2f), New health (%.2f))", PlayerName(playerid), Health, Health + 25);
			SendAdminMessage(1, string);

	    }

	    SendClientMessage(playerid, COLOR_NOTICE, "[INFO:] You have been healed by the medipack.");
		SetPVarInt(playerid, "Medipack", 0);
	}

	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You have already been healed by the medipack or do not have the medipack as a turf perk.");
	}

	return 1;
}

CMD:turfs(playerid, params[])
{
	#pragma unused params
	new
	    currtime = GetUnixTime(),
		TurfSys_dialogstr[256], // Each line would be 78 chars long assuming the turf name would be as long as Idlewood Gas Station
		TurfSys_sourcestr[128],
		TurfSys_minutes,
		TurfSys_hours,
		cnt = 0;
		
		
	for(new i; i < MAX_TURFS; i++)
	{
	    if(FoCo_Turfs[i][FT_PICKUP_X] == 0.0 && FoCo_Turfs[i][FT_PICKUP_Y] == 0.0 && FoCo_Turfs[i][FT_PICKUP_X] == 0.0)
	    {
	        break;
	    }

		else
		{
		    if(FoCo_Turfs[i][FT_LAST_TAKEOVER] != 0)
		    {
		        TurfSys_hours = (currtime - FoCo_Turfs[i][FT_LAST_TAKEOVER]) / 3600;
		        TurfSys_minutes = (currtime - FoCo_Turfs[i][FT_LAST_TAKEOVER]) % 3600;
		        TurfSys_minutes = TurfSys_minutes / 60;

				format(TurfSys_sourcestr, sizeof(TurfSys_sourcestr), "Turf: %s - Owner: %s \n\tTime since capture: %d hour(s) and %d minute(s)\n", FoCo_Turfs[i][FT_NAME], FoCo_Teams[FoCo_Turfs[i][FT_TEAM]][team_name],TurfSys_hours, TurfSys_minutes);
				strcat(TurfSys_dialogstr, TurfSys_sourcestr);
				cnt++;
			}

			else
			{
				format(TurfSys_sourcestr, sizeof(TurfSys_sourcestr), "Turf: %s - Owner: N/A\n\tTime since capture: N/A\n", FoCo_Turfs[i][FT_NAME]);
			    strcat(TurfSys_dialogstr, TurfSys_sourcestr);
			    cnt++;
			}
		}
	}
	
	if(cnt == 0)
	{
	    format(TurfSys_dialogstr, sizeof(TurfSys_dialogstr), "No turfs");
	}
	
	ShowPlayerDialog(playerid, DIALOG_TURF_TIME, DIALOG_STYLE_LIST, "Turf infos:", TurfSys_dialogstr, "OK", "");
	
	return 1;
}

stock Turfwar_IsPlayerInCube(playerid, Float: minx, Float: Maxx, Float: miny, Float: maxy, Float: MinZ, Float: MaxZ)
{
   new Float: x, Float: y, Float: z;
   GetPlayerPos(playerid, x, y, z);
   if (x > minx && x < Maxx && y > miny && y < maxy && z > MinZ && z < MaxZ) return 1;
   return 0;
}

forward TurfSys_GivePerks(type, playerid);
public TurfSys_GivePerks(type, playerid)
{
	if(GetPVarInt(playerid, "PlayerStatus") == 0)
	{
		switch(type)
		{
	        case 0:
			{
				for(new i = 0; i < MAX_TURFS; i++)
				{
				    if(FoCo_Turfs[i][FT_TEAM] == FoCo_Team[playerid] && IsValidTurf(i))
				    {
 						if(FoCo_Turfs[i][FT_PERK] == FT_PERK_AMMO)
						{

						    new weapons[13][2];

							for(new k; k < 13; k++)
							{
								GetPlayerWeaponData(playerid, k, weapons[k][0], weapons[k][1]);
	                            if(weapons[k][0] > 21 && weapons[k][0] < 35)
								{
									GivePlayerWeapon(playerid, weapons[k][0], weapons[k][1]+500);
								}
						 	}

						  	SendClientMessage(playerid, COLOR_NOTICE, "[TURF PERK]: You have received 500 extra ammo.");
						}

						else if(FoCo_Turfs[i][FT_PERK] == FT_PERK_ARMOUR)
						{
						    new Float:TurfSys_Armour;
						    GetPlayerArmour(playerid, TurfSys_Armour);
						    SetPlayerArmour(playerid, TurfSys_Armour+25);
						    SendClientMessage(playerid, COLOR_NOTICE, "[TURF PERK]: You have received extra armour.");

						}

						else if(FoCo_Turfs[i][FT_PERK] == FT_PERK_GRENADES)
						{
						 	GivePlayerWeapon(playerid, 16, 5);
					        SendClientMessage(playerid, COLOR_NOTICE, "[TURF PERK]: You have received grenades.");
					    }

					    else if(FoCo_Turfs[i][FT_PERK] == FT_PERK_MEDIPACK)
				  		{
					        SetPVarInt(playerid, "Medipack", true);
			           		SendClientMessage(playerid, COLOR_NOTICE, "[TURF PERK]: You have access to /medipack.");
					    }

					    else if(FoCo_Turfs[i][FT_PERK] == FT_PERK_EXTRA_DAMAGE)
					    {
					    	SetPVarInt(playerid, "ExtraDamage", true);
			  		    	SendClientMessage(playerid, COLOR_NOTICE, "[TURF PERK]: Your weapon damage is increased by 5 percent.");
					    }
					}
				}
			}

			case 1:
			{
			    #pragma unused playerid
			    foreach(new j : Player)
			    {
			        if(FoCo_Turfs[TurfSys_Zone_Takeover][FT_TEAM] == FoCo_Team[j])
			        {
			            if(FoCo_Turfs[TurfSys_Zone_Takeover][FT_PERK] == FT_PERK_AMMO)
						{
						    new wp[13][2];

							for(new o; o < 13; o++)
							{
								GetPlayerWeaponData(j, o, wp[o][0], wp[o][1]);
								if(weapons[o][0] > 21 && weapons[o][0] < 35)
								{
									GivePlayerWeapon(j, wp[o][0], wp[o][1]+500);
								}
	   					 	}

						  	SendClientMessage(j, COLOR_NOTICE, "[TURF PERK]: You have received 500 extra ammo.");
						}

						else if(FoCo_Turfs[TurfSys_Zone_Takeover][FT_PERK] == FT_PERK_ARMOUR)
						{
						    new Float:TurfSys_Armour;
						    GetPlayerArmour(j, TurfSys_Armour);
						    SetPlayerArmour(j, TurfSys_Armour+25);
						    SendClientMessage(j, COLOR_NOTICE, "[TURF PERK]: You have received extra armour.");

						}

						else if(FoCo_Turfs[TurfSys_Zone_Takeover][FT_PERK] == FT_PERK_GRENADES)
						{
						 	GivePlayerWeapon(j, 16, 5);
					        SendClientMessage(j, COLOR_NOTICE, "[TURF PERK]: You have received grenades.");
					    }

					    else if(FoCo_Turfs[TurfSys_Zone_Takeover][FT_PERK] == FT_PERK_MEDIPACK)
				  		{
					        SetPVarInt(j, "Medipack", true);
			           		SendClientMessage(j, COLOR_NOTICE, "[TURF PERK]: You have access to /medipack.");
					    }

					    else if(FoCo_Turfs[TurfSys_Zone_Takeover][FT_PERK] == FT_PERK_EXTRA_DAMAGE)
					    {
					    	SetPVarInt(j, "ExtraDamage", true);
			  		    	SendClientMessage(j, COLOR_NOTICE, "[TURF PERK]: Your weapon damage is increased by 5 percent.");
					    }
					}
				}
		    }
		}
	}
	
	else
	{
	    return 1;
	}

	return 1;
}
