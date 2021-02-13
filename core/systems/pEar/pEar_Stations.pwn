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
* Filename: pEar_Stations.pwn                                                    *
* Author: pEar	                                                                 *
*********************************************************************************/

#define DIALOG_SETSTATION 105
#define DIALOG_SETSTATION2 114
#define DIALOG_ARADIO 382
#define DIALOG_ARADIO_ADD 383
#define DIALOG_ARADIO_ADD_URL 384
#define DIALOG_ARADIO_REMOVE 385
#define DIALOG_ARADIO_EDIT 386
#define DIALOG_ARADIO_EDIT_NAME 387
#define DIALOG_ARADIO_EDIT_URL 388
#define DIALOG_ARADIO_CONFIRM 389

#define MYSQL_STATIONS_SET 100
#define MYSQL_STATIONS_CHECK 101
#define MYSQL_STATION_ADD 102
#define MYSQL_RADIO_SELECT 103
#define MYSQL_ARADIO_EDIT 104
#define MYSQL_ARADIO_REMOVE 105
#define MYSQL_ARADIO_ADD_SELECT 106
#define MYSQL_ARADIO_ADD_NEW 107

#define ACMD_ARADIO 4

#include <YSI\y_hooks>


forward pEar_Stations_OnQueryFinish(query[], resultid, extraid, connectionHandle);
public pEar_Stations_OnQueryFinish(query[], resultid, extraid, connectionHandle)
{
	new string[256];
	switch(resultid)
	{
		case MYSQL_STATION_ADD: return 1;
		case MYSQL_STATIONS_CHECK: {
			mysql_store_result();
			new stations[1024];
			if(mysql_num_rows() > 0) {
				new result[160];
				new ID, Station[156];
				while(mysql_fetch_row_format(result)) {
					sscanf(result, "p<|>ds[156]", ID, Station);
					if(strlen(stations) == 0) {
						format(stations, sizeof(stations), "ID\tStation\nTurn Off!\n%d\t%s \n", ID, Station);
					} else {
						format(stations, sizeof(stations), "%s\n%d\t%s \n", stations, ID, Station);
					}
				}
			} else {
				format(stations, sizeof(stations), "No valid stations\n");
			}
			ShowPlayerDialog(extraid, DIALOG_SETSTATION, DIALOG_STYLE_TABLIST_HEADERS, "Select Station", stations, "Select", "Cancel");
			mysql_free_result();
			return 1;
		}
		case MYSQL_STATIONS_SET: {
			mysql_store_result();
			if(mysql_num_rows() > 0) {
				new result[320];
				if(mysql_fetch_row_format(result)) {
					new ID, Enabled, Station[156], Url[156];
					sscanf(result, "p<|>ds[156]ds[156]", ID, Station, Enabled, Url);
					if(Enabled != 1) {
						mysql_free_result();
						return SendErrorMessage(extraid, "This station is unfortunately disabled.");
					}
					StopAudioStreamForPlayer(extraid);
					PlayAudioStreamForPlayer(extraid, Url);
					format(string, sizeof(string), "[NOTICE]: You tuned into %s", Station);
					SendClientMessage(extraid, COLOR_LIGHTBLUE2, string);
					format(string, sizeof(string), "%s has tuned into %s", PlayerName(extraid), Station);
					SetPlayerChatBubble(extraid, string, COLOR_ACTIONS, 40.0, 5000);
				}
			} else {
				mysql_free_result();
				return SendErrorMessage(extraid, "No such station. Use /setstation to see a list of stations.");
			}
			mysql_free_result();
			return 1;
		}
		case MYSQL_RADIO_SELECT: {
			mysql_store_result();
			new stations[1024];
			if(mysql_num_rows() > 0) {
				new result[320];
				new ID, Enabled, Station[156], Url[156];
				while(mysql_fetch_row_format(result)) {
					sscanf(result, "p<|>ds[156]ds[156]", ID, Station, Enabled, Url);
					if(strlen(stations) == 0) {
						format(stations, sizeof(stations), "ID\tStation\n%d\t%s\n", ID, Station);
					} else {
						format(stations, sizeof(stations), "%s\n%d\t%s\n", stations, ID, Station);
					}
				}
			} else {
				format(stations, sizeof(stations), "No valid stations");
			}
			mysql_free_result();
			if(GetPVarInt(extraid, "ARadio") == 1) {
				return ShowPlayerDialog(extraid, DIALOG_ARADIO_REMOVE, DIALOG_STYLE_TABLIST_HEADERS, "Radio Management - Remove Station", stations, "Remove!", "Cancel");
			} else {
				return ShowPlayerDialog(extraid, DIALOG_ARADIO_EDIT, DIALOG_STYLE_TABLIST_HEADERS, "Radio Management - Edit Station", stations, "Select", "Cancel");
			}
		}
		case MYSQL_ARADIO_EDIT:  {
			if(mysql_affected_rows() > 0) {
				format(string, sizeof(string), "AdmCmd(%d): %s %s updated a radio station.", ACMD_ARADIO, GetPlayerStatus(extraid), PlayerName(extraid));
				SendAdminMessage(ACMD_ARADIO, string);
				AdminLog(string);
				return SendClientMessage(extraid, COLOR_GREEN, "Successfully updated the radio station");
			} else {
				return SendErrorMessage(extraid, "Something went wrong!");
			}
		}
		case MYSQL_ARADIO_REMOVE: {
			if(mysql_affected_rows() > 0) {
				format(string, sizeof(string), "AdmCmd(%d): %s %s removed a radio station.", ACMD_ARADIO, GetPlayerStatus(extraid), PlayerName(extraid));
				SendAdminMessage(ACMD_ARADIO, string);
				AdminLog(string);
				return SendClientMessage(extraid, COLOR_GREEN, "Successfully removed the radio station");
			} else {
				return SendErrorMessage(extraid, "Something went wrong!");
			}
		}
		case MYSQL_ARADIO_ADD_SELECT: {
			DebugMsg("MYSQL_ARADIO_ADD_SELECT");
			mysql_store_result();
			new query2[512];
			new st_name[156], st_url[156];
			GetPVarString(extraid, "ARadio_Add_Name", st_name, sizeof(st_name));
			GetPVarString(extraid, "ARadio_Add_URL", st_url, sizeof(st_url));
			mysql_real_escape_string(st_name, st_name, con);
			mysql_real_escape_string(st_url, st_url, con);
			if(mysql_num_rows() > 0) {
				new result[320], ID;
				mysql_fetch_row_format(result);
				sscanf(result, "p<|>d", ID);
				format(query2, sizeof(query2), "UPDATE FoCo_Stations SET `Station`='%s', `Url`='%s', `Enabled`='1' WHERE `ID`='%d'", st_name, st_url, ID);
			} else {
				format(query2, sizeof(query2), "INSERT INTO FoCo_Stations FoCo_Stations (`Station`, `Url`) VALUES ('%s', '%s')", st_name, st_url);
			}
			mysql_query(query2, MYSQL_ARADIO_ADD_NEW, extraid, con);
			DeletePVar(extraid, "ARadio");
			DeletePVar(extraid, "ARadio_Add_Name");
			DeletePVar(extraid, "ARadio_Add_URL");
			mysql_free_result();
			return 1;
		}
		case MYSQL_ARADIO_ADD_NEW: {
			if(mysql_affected_rows() > 0) {
				format(string, sizeof(string), "AdmCmd(%d): %s %s addded a new radio station.", ACMD_ARADIO, GetPlayerStatus(extraid), PlayerName(extraid));
				SendAdminMessage(ACMD_ARADIO, string);
				AdminLog(string);
				return SendClientMessage(extraid, COLOR_GREEN, "Successfully added a new radio station");
			} else {
				return SendErrorMessage(extraid, "Something went wrong!");
			}
		}
	}
	return 1;
}

CMD:setstation(playerid, params[])
{
	new station, query[512];
	if (sscanf(params, "d", station)) {
		format(query, sizeof(query), "SELECT `ID`, `Station` FROM FoCo_Stations");
		mysql_query(query, MYSQL_STATIONS_CHECK, playerid, con);
	} else {
		if(station == 0) {
			return ShowPlayerDialog(playerid, DIALOG_SETSTATION2, DIALOG_STYLE_INPUT,"Webradio","Enter a valid URL to the stations playlist file (.pls) below !","Start","Cancel");
		}
		format(query, sizeof(query), "SELECT * FROM FoCo_Stations WHERE ID='%d'", station);
		mysql_query(query, MYSQL_STATIONS_SET, playerid, con);
	}
	return 1;
}

CMD:radio(playerid, params[])
{
	cmd_setstation(playerid, params);
	return 1;
}

CMD:setstationoff(playerid, params[])
{
	StopAudioStreamForPlayer(playerid);
	return 1;
}

CMD:aradio(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_ARADIO)) {
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		ShowPlayerDialog(playerid, DIALOG_ARADIO, DIALOG_STYLE_LIST, "Radio Management", "Add RadioStation\nRemove RadioStation\nEdit RadioStation", "Select", "Cancel");
	}
	return 1;
}

CMD:add_station(playerid, params[]) 
{
	if(IsAdmin(playerid, ACMD_ADDSTATION)) {
		new station[156], url[156];
		if(sscanf(params, "s[156]s[156]", station, url)) {
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /add_station [Station_name] [URL]");
		} else {
			new query[512];
			format(query, sizeof(query), "INSERT INTO FoCo_Stations (Station, Url) VALUES ('%s', '%s')", station, url);
			mysql_query(query, MYSQL_STATION_ADD, playerid, con);
		}
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    print("ODR_pEar_Stations");
	switch(dialogid)
	{
		case DIALOG_SETSTATION:
		{
			if(!response) return 1;
			if(listitem == 1)
			{
			    ShowPlayerDialog(playerid, DIALOG_SETSTATION2, DIALOG_STYLE_INPUT,"Webradio","Enter a valid URL to the stations playlist file (.pls) below !","Start","Cancel");
			    return 1;
			}
			if(listitem == 0) {
				SendClientMessage(playerid, COLOR_GREEN, "Turned off radio.");
				return cmd_setstationoff(playerid, "");
			}
			new query[156];
			format(query, sizeof(query), "SELECT * FROM FoCo_Stations WHERE ID='%d'", listitem-1);
			mysql_query(query, MYSQL_STATIONS_SET, playerid, con);
			return 1;
		}
		case DIALOG_SETSTATION2:
		{
			if(!response) return 1;
			new string[156];
			StopAudioStreamForPlayer(playerid);
			PlayAudioStreamForPlayer(playerid, inputtext);
			format(string, sizeof(string), "[NOTICE]: You tuned into %s", inputtext);
			SendClientMessage(playerid, COLOR_LIGHTBLUE2, string);
			format(string, sizeof(string), "%s has tuned into %s", PlayerName(playerid), inputtext);
			SetPlayerChatBubble(playerid, string, COLOR_ACTIONS, 40.0, 5000);
			return 1;
		}
		case DIALOG_ARADIO: {
			if(!response) return 1;
			switch(listitem) {
				case 0: return ShowPlayerDialog(playerid, DIALOG_ARADIO_ADD, DIALOG_STYLE_INPUT, "Radio Station Management - Add New Station", "Please enter the name of the new station", "Done", "Cancel"); 
				default: {
					SetPVarInt(playerid, "ARadio", listitem);
					new query[512];
					format(query, sizeof(query), "SELECT * FROM FoCo_Stations");
					mysql_query(query, MYSQL_RADIO_SELECT, playerid, con);
					return 1;
				}
			}
		}
		case DIALOG_ARADIO_ADD: {
			if(!response) return 1;
			if(strlen(inputtext) >= 156) {
				return SendErrorMessage(playerid, "Name too long!");
			}
			SetPVarString(playerid, "ARadio_Add_Name", inputtext);
			return ShowPlayerDialog(playerid, DIALOG_ARADIO_ADD_URL, DIALOG_STYLE_INPUT, "Radio Station Management - Add New Station", "Please enter the URL of the new station (Has to be .pls)", "Done", "Cancel");
		}
		case DIALOG_ARADIO_ADD_URL: {
			if(!response) return 1;
			if(strlen(inputtext) >= 156) {
				return SendErrorMessage(playerid, "Name too long!");
			}
			SetPVarString(playerid, "ARadio_Add_URL", inputtext);
			SetPVarInt(playerid, "ARadio", 3);
			return ShowPlayerDialog(playerid, DIALOG_ARADIO_CONFIRM, DIALOG_STYLE_MSGBOX, "Radio Station Management - Confirm Addition", "Are you sure you want to add this station", "Yes", "No");
		}
		case DIALOG_ARADIO_REMOVE: {
			if(!response) return 1;
			if(listitem != 0) {
				SetPVarInt(playerid, "ARadio_Remove", listitem);
				return ShowPlayerDialog(playerid, DIALOG_ARADIO_CONFIRM, DIALOG_STYLE_MSGBOX, "Radio Management - Remove Station", "Are you sure you want to remove this station?", "Yes", "No");
			} else {
				return SendErrorMessage(playerid, "You cannot remove the selected radio station!");
			}
			
		}
		case DIALOG_ARADIO_EDIT: {
			if(!response) return 1;
			if(listitem != 0) {
				SetPVarInt(playerid, "ARadio_Edit", listitem);
				return ShowPlayerDialog(playerid, DIALOG_ARADIO_EDIT_NAME, DIALOG_STYLE_INPUT, "Radio Management - Edit Station", "Please enter the new radio station name", "Continue", "Cancel");
			} else {
				return SendErrorMessage(playerid, "You cannot edit the selected radio station!");
			}
		}
		case DIALOG_ARADIO_EDIT_NAME: {
			if(!response) return 1;
			if(strlen(inputtext) >= 156) {
				return SendErrorMessage(playerid, "The name is too long!");
			}
			SetPVarString(playerid, "ARadio_Edit_Name", inputtext);
			return ShowPlayerDialog(playerid, DIALOG_ARADIO_EDIT_URL, DIALOG_STYLE_INPUT, "Radio Management - Edit Station", "Please enter the new radio station URL (Has to be .pls)", "Save!", "Cancel");
		}
		case DIALOG_ARADIO_EDIT_URL: {
			if(!response) return 1;
			if(strlen(inputtext) >= 156) {
				return SendErrorMessage(playerid, "The URL is too long!");
			}
			SetPVarString(playerid, "ARadio_Edit_URL", inputtext);
			return ShowPlayerDialog(playerid, DIALOG_ARADIO_CONFIRM, DIALOG_STYLE_MSGBOX, "Radio Management - Edit Station", "Are you sure you want to make this change?", "Yes", "No");
		}
		case DIALOG_ARADIO_CONFIRM: {
			if(!response) return 1;
			new query[512];
			switch(GetPVarInt(playerid, "ARadio")) {
				case 1: {
					format(query, sizeof(query), "UPDATE FoCo_Stations SET `Station`='--EDITABLE--', `Url`='', `Enabled`='0' WHERE `ID`='%d'", GetPVarInt(playerid, "ARadio_Remove"));
					mysql_query(query, MYSQL_ARADIO_REMOVE, playerid, con);
					DeletePVar(playerid, "ARadio");
					DeletePVar(playerid, "ARadio_Remove");
					return 1;
				}
				case 2: {
					new st_name[156], st_url[156];
					GetPVarString(playerid, "ARadio_Edit_Name", st_name, sizeof(st_name));
					GetPVarString(playerid, "ARadio_Edit_URL", st_url, sizeof(st_url));
					mysql_real_escape_string(st_name, st_name, con);
					mysql_real_escape_string(st_url, st_url, con);
					
					format(query, sizeof(query), "UPDATE FoCo_Stations SET `Station`='%s', `Url`='%s', `Enabled`='1' WHERE `ID`='%d'", st_name, st_url, GetPVarInt(playerid, "ARadio_Edit"));
					mysql_query(query, MYSQL_ARADIO_EDIT, playerid, con);
					DeletePVar(playerid, "ARadio");
					DeletePVar(playerid, "ARadio_Edit_Name");
					DeletePVar(playerid, "ARadio_Edit_URL");
					DeletePVar(playerid, "ARadio_Edit");
					
					return 1;
				}
				case 3: {
					format(query, sizeof(query), "SELECT `ID` FROM FoCo_Stations WHERE `Enabled`!='1' ORDER BY ID ASC LIMIT 1");
					mysql_query(query, MYSQL_ARADIO_ADD_SELECT, playerid, con);
					return 1;
				}
				default: return SendErrorMessage(playerid, "Something went wrong, contact pEar about this.");
			}
		}
	}
	
	return 1;
}
