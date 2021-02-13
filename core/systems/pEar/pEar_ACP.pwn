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
* Filename: pEar_ACP.pwn                                                         *
* Author: pEar	                                                                 *
*********************************************************************************/

#include <YSI\y_hooks>

#define DIALOG_ACP 345
#define DIALOG_ACP_ATEAM 346
#define DIALOG_ACP_RFC 347
#define DIALOG_ACP_DELETECAR 348
#define DIALOG_ACP_CREATECAR 349
#define DIALOG_ACP_SETHPALL 350
#define DIALOG_ACP_SETARMOURALL 351
#define DIALOG_ACP_GIVEALLWEAPON 352
#define DIALOG_ACP_BOTS 353
#define DIALOG_ACP_RESETSTATS 354
#define DIALOG_ACP_BANIPRANGE 355
#define DIALOG_ACP_SETSTAT 356
#define DIALOG_ACP_CHANGENAME 357
#define DIALOG_ACP_SETCAR 358
#define DIALOG_ACP_SETACH 359
#define DIALOG_ACP_AGIVE 360
#define DIALOG_ACP_SETADMIN 361
#define DIALOG_ACP_SETTRIALADMIN 362
#define DIALOG_ACP_ATURF 363
#define DIALOG_ACP_MOTD 364
#define DIALOG_ACP_RULES 365
#define DIALOG_ACP_MAXPLAYERSPERIP 366
#define DIALOG_ACP_GIVEALLWEAPONAMMO 367
#define DIALOG_ACP_SETCAR_PLATE 368
#define DIALOG_ACP_SETCAR_C1 369
#define DIALOG_ACP_SETCAR_C2 370
#define DIALOG_ACP_AGIVE_NAME 371
#define DIALOG_ACP_AGIVE_MONEY 372
#define DIALOG_ACP_AGIVE_KILLSTREAK 373
#define DIALOG_ACP_SETADMIN_NAME 374
#define DIALOG_ACP_SETTRIALADMIN_NAME 375
#define DIALOG_ACP_RULES_ADD 376
#define DIALOG_ACP_RULES_REMOVE 377
#define DIALOG_ACP_RULES_EDIT 378
#define DIALOG_ACP_RULES_EDIT2 379

new A_Authenticate[MAX_PLAYERS];

hook OnGameModeInit()
{
	for(new i = 0; i < MAX_PLAYERS; i++) {
		A_Authenticate[i] = -1;
	}
}


hook OnPlayerConnect(playerid) 
{
	A_Authenticate[playerid] = -1;
	return 1;
}

forward A_Auth(playerid);
public A_Auth(playerid) {
	return 1;
}

forward showACP(playerid);
public showACP(playerid) {
	new dialog_string[1024];
	format(dialog_string, sizeof(dialog_string), "Command\tLevel\nClan Management(ateam)\t%d\nRemove From Clan\t%d\nDelete Car\t%d\nCreate Car\t%d\nGet All\t%d\nSet Hp All\t%d\nSet Armour All\t%d\nGive All Weapon\t%d\n(Dis)Connect Bots\t%d\nTog Main\t%d\nReset Stats\t%d\nBan IP Range\t%d\nReload Restricted Skins\t%d\nSet Stats\t%d\nChange Name\t%d\nSet Car\t%d\nRadio Management\t%d", 
		ACMD_ATEAM, ACMD_REMOVEFROMCLAN, ACMD_DELETECAR, ACMD_CREATECAR, ACMD_GETALL, ACMD_SETHPALL, ACMD_SETARMOURALL, ACMD_GIVEALLWEAPON, ACMD_CONNECTBOTS, ACMD_TOGMAIN, ACMD_RESETSTATS, ACMD_BANIPRANGE, ACMD_RELOAD_RESTRICTED_SKINS, ACMD_SETSTAT, ACMD_CHANGENAME, ACMD_SETCAR, ACMD_ARADIO);
	/* Full access, otherwise level 4 access. */
	if(AdminLvl(playerid) > ACMD_ACP) {
		new dialog2_string[512];
		format(dialog2_string, sizeof(dialog2_string), "\nSpectators\t%d\nSet Achievement\t%d\nA-Give\t%d\nDis/Enable Shopsys\t%d\nSet Admin\t%d\nSet Trial Admin\t%d\nRestart Server\t%d\nTurf Management\t%d\nMsg Of The Day\t%d\nKick All\t%d\nRules Management\t%d\nMax Players Per IP\t%d",
			ACMD_SPECTATORS, ACMD_SETACH, ACMD_AGIVE, ACMD_SHOPSYS, ACMD_SETADMIN, ACMD_SETTRIALADMIN, ACMD_ENDROUND, ACMD_ATURF, ACMD_MOTD, ACMD_KICKALL, ACMD_RULES, ACMD_MAXPLAYERSPERIP);
		strcat(dialog_string, dialog2_string, sizeof(dialog_string));
		return ShowPlayerDialog(playerid, DIALOG_ACP, DIALOG_STYLE_TABLIST_HEADERS, "Admin Control Panel", dialog_string, "Select", "Cancel");
	} else {
		return ShowPlayerDialog(playerid, DIALOG_ACP, DIALOG_STYLE_TABLIST_HEADERS, "Admin Control Panel", dialog_string, "Select", "Cancel");
	} 
}



CMD:acp(playerid, params[]) 
{
	if(IsAdmin(playerid, ACMD_ACP)) {
		if(!CMD_Auth(playerid)) return 1;
		showACP(playerid);
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    print("ODR_pEar_ACP");
	new string[128];
	switch(dialogid)
	{
		case DIALOG_ACP: {
			if(!response) return 1;
			switch(listitem)
			{
				case 0: return ShowPlayerDialog(playerid, DIALOG_ACP_ATEAM, DIALOG_STYLE_LIST, "Clan Management", "Create Clan\nEdit Clan\nDelete Clan\nInfo Clans", "Select", "Cancel");	
				case 1: return ShowPlayerDialog(playerid, DIALOG_ACP_RFC, DIALOG_STYLE_INPUT, "Remove From Clan", "Please enter who you'd like to remove from their clan:", "Remove!", "Cancel");
				case 2: return ShowPlayerDialog(playerid, DIALOG_ACP_DELETECAR, DIALOG_STYLE_INPUT, "Delete Car", "Please enter the ID of the car you'd like removed:", "Remove!", "Cancel");
				case 3: return ShowPlayerDialog(playerid, DIALOG_ACP_CREATECAR, DIALOG_STYLE_INPUT, "Create Car", "Format: CarID/Name Colour1 Colour2", "Create!", "Cancel");
				case 4: return cmd_getall(playerid, "");
				case 5: return ShowPlayerDialog(playerid, DIALOG_ACP_SETHPALL, DIALOG_STYLE_INPUT, "Set HP All", "Please enter a value you'd like everyone's HP to be set to:", "Done", "Cancel");
				case 6: return ShowPlayerDialog(playerid, DIALOG_ACP_SETARMOURALL, DIALOG_STYLE_INPUT, "Set Armour All", "Please enter a value you'd like everyone's armour to be set to:", "Done", "Cancel");
				case 7: return ShowPlayerDialog(playerid, DIALOG_ACP_GIVEALLWEAPON, DIALOG_STYLE_LIST, "Give Weapon All", "Knife\nBat\nKatana\nChainsaw\nDildo\nFlowers\nGrenade\nMolotov\n9mm\nSilenced\nDeagle\nShotgun\nSawnoff\nCombat Shotgun\nUzi\nMP5\nTec9\nAK47\nM4\nCountry Rifle\nSniper\nRPG\nHS RPG\nFlamethrower\nMinigun\nSpraycan\nExtinguisher\nParachute", "Select", "Cancel");
				case 8: return ShowPlayerDialog(playerid, DIALOG_ACP_BOTS, DIALOG_STYLE_LIST, "(Dis)Connect Bots", "Connect Bots\nDisconnect Bots", "Select", "Cancel");
				case 9: return cmd_togmain(playerid, "");
				case 10: return ShowPlayerDialog(playerid, DIALOG_ACP_RESETSTATS, DIALOG_STYLE_INPUT, "Reset Stats", "Enter the name/ID of the player:", "Select", "Cancel");
				case 11: return ShowPlayerDialog(playerid, DIALOG_ACP_BANIPRANGE, DIALOG_STYLE_INPUT, "Ban IP Range", "Format: XX.XX REASON", "Done", "Cancel");
				case 12: return cmd_reload_restricted_skins(playerid, "");
				case 13: return ShowPlayerDialog(playerid, DIALOG_ACP_SETSTAT, DIALOG_STYLE_INPUT, "Set Stats", "Enter the name/ID of the player:", "Select", "Cancel");
				case 14: return ShowPlayerDialog(playerid, DIALOG_ACP_CHANGENAME, DIALOG_STYLE_INPUT, "Change Name", "FORMAT: OLDNAME/ID NEWNAME", "Select", "Cancel");
				case 15: return ShowPlayerDialog(playerid, DIALOG_ACP_SETCAR, DIALOG_STYLE_LIST, "Set Car", "Spawn\nPlate\nColour1\nColour2", "Select", "Cancel");
				case 16: return cmd_aradio(playerid, "");
				case 17: return cmd_spectators(playerid, "");
				case 18: return ShowPlayerDialog(playerid, DIALOG_ACP_SETACH, DIALOG_STYLE_INPUT, "Set Achievement", "FORMAT: Name/ID Achievement_ID Value (1 = got it, 0 = not)", "Select", "Cancel");
				case 19: return ShowPlayerDialog(playerid, DIALOG_ACP_AGIVE, DIALOG_STYLE_LIST, "Give A-stuff", "Money\nJetpack\nKillStreak\nBoost", "Select", "Cancel");
				case 20: return cmd_shopsys(playerid, "");
				case 21: return ShowPlayerDialog(playerid, DIALOG_ACP_SETADMIN, DIALOG_STYLE_LIST, "Select Admin Level", "1) Junior Admin\n2) Admin\n3) Senior Admin\n4)IG-Lead Admin\n5) Lead Admin", "Select", "Cancel");
				case 22: return ShowPlayerDialog(playerid, DIALOG_ACP_SETTRIALADMIN, DIALOG_STYLE_LIST, "Set Trial Admin", "Remove Trial Admin\nSet Trial Admin", "Select", "Cancel");
				case 23: return cmd_endround(playerid, "");
				case 24: return ShowPlayerDialog(playerid, DIALOG_ACP_ATURF, DIALOG_STYLE_LIST, "Turf Management", "Info Turfs\nEdit Turfs\nReset Turfs\nStop Editing Turfs\nTurf Pickups\nGangZone", "Select", "Cancel");
				case 25: return ShowPlayerDialog(playerid, DIALOG_ACP_MOTD, DIALOG_STYLE_INPUT, "Message Of The Day", "Enter the new message of the day:", "Select", "Cancel");
				case 26: return cmd_kickall(playerid, "");
				case 27: return ShowPlayerDialog(playerid, DIALOG_ACP_RULES, DIALOG_STYLE_LIST, "Rules Management", "Add Rule\nRemove Rule\nEdit Rule", "Select", "Cancel");
				case 28: return ShowPlayerDialog(playerid, DIALOG_ACP_MAXPLAYERSPERIP, DIALOG_STYLE_INPUT, "Max Players Per IP", "Enter the max amount of players allowed per IP:", "Select", "Cancel");
				default: return 1;
			}
		}
		case DIALOG_ACP_ATEAM: {
			if(!response) return showACP(playerid);
			switch(listitem) {
				case 0: return cmd_ateam(playerid, "create");
				case 1: return cmd_ateam(playerid, "edit");
				case 2: return cmd_ateam(playerid, "delete");
				case 3: return cmd_ateam(playerid, "info");
				default: return 1;
			}
		}
		case DIALOG_ACP_RFC: {
			if(!response) return showACP(playerid);
			return cmd_removefromclan(playerid, inputtext);
		}
		case DIALOG_ACP_DELETECAR: {
			if(!response) return showACP(playerid);
			return cmd_deletecar(playerid, inputtext);
		}
		case DIALOG_ACP_CREATECAR: {
			if(!response) return showACP(playerid);
			return cmd_createcar(playerid, inputtext);
		}
		case DIALOG_ACP_SETHPALL: {
			if(!response) return showACP(playerid);
			return cmd_sethpall(playerid, inputtext);
		}
		case DIALOG_ACP_SETARMOURALL: {
			if(!response) return showACP(playerid);
			return cmd_setarmourall(playerid, inputtext);
		}
		case DIALOG_ACP_GIVEALLWEAPON: {
			if(!response) return showACP(playerid);
			SetPVarInt(playerid, "ACP_DialogVar", listitem);
			return ShowPlayerDialog(playerid, DIALOG_ACP_GIVEALLWEAPONAMMO, DIALOG_STYLE_INPUT, "Give All Weapon", "Enter the desired amount of ammo:", "Select", "Cancel");
		}
		case DIALOG_ACP_GIVEALLWEAPONAMMO: {
			if(!response) return showACP(playerid);
			switch(GetPVarInt(playerid, "ACP_DialogVar")) {
				case 0: format(string, sizeof(string), "%d %s", 4, inputtext);
				case 1: format(string, sizeof(string), "%d %s", 5, inputtext);
				case 2: format(string, sizeof(string), "%d %s", 8, inputtext);
				case 3: format(string, sizeof(string), "%d %s", 9, inputtext);
				case 4: format(string, sizeof(string), "%d %s", 10, inputtext);
				case 5: format(string, sizeof(string), "%d %s", 14, inputtext);
				case 6: format(string, sizeof(string), "%d %s", 16, inputtext);
				case 7: format(string, sizeof(string), "%d %s", 18, inputtext);
				case 8: format(string, sizeof(string), "%d %s", 22, inputtext);
				case 9: format(string, sizeof(string), "%d %s", 23, inputtext);
				case 10: format(string, sizeof(string), "%d %s", 24, inputtext);
				case 11: format(string, sizeof(string), "%d %s", 25, inputtext);
				case 12: format(string, sizeof(string), "%d %s", 26, inputtext);
				case 13: format(string, sizeof(string), "%d %s", 27, inputtext);
				case 14: format(string, sizeof(string), "%d %s", 28, inputtext);
				case 15: format(string, sizeof(string), "%d %s", 29, inputtext);
				case 16: format(string, sizeof(string), "%d %s", 32, inputtext);
				case 17: format(string, sizeof(string), "%d %s", 30, inputtext);
				case 18: format(string, sizeof(string), "%d %s", 31, inputtext);
				case 19: format(string, sizeof(string), "%d %s", 33, inputtext);
				case 20: format(string, sizeof(string), "%d %s", 34, inputtext);
				case 21: format(string, sizeof(string), "%d %s", 35, inputtext);
				case 22: format(string, sizeof(string), "%d %s", 36, inputtext);
				case 23: format(string, sizeof(string), "%d %s", 37, inputtext);
				case 24: format(string, sizeof(string), "%d %s", 38, inputtext);
				case 25: format(string, sizeof(string), "%d %s", 41, inputtext);
				case 26: format(string, sizeof(string), "%d %s", 42, inputtext);
				case 27: format(string, sizeof(string), "%d %s", 46, inputtext);
			}
			return cmd_giveallweapon(playerid, string);
		}
		case DIALOG_ACP_RESETSTATS: {
			if(!response) return showACP(playerid);
			return cmd_resetstats(playerid, inputtext);
		}
		case DIALOG_ACP_BANIPRANGE: {
			if(!response) return showACP(playerid);
			return cmd_banip(playerid, inputtext);
		}
		case DIALOG_ACP_SETSTAT: {
			if(!response) return showACP(playerid);
			return cmd_setstatnew(playerid, inputtext);
		}
		case DIALOG_ACP_CHANGENAME: {
			if(!response) return showACP(playerid);
			return cmd_changename(playerid, inputtext);
		}
		case DIALOG_ACP_SETCAR: {
			if(!response) return showACP(playerid);
			switch(listitem) {
				case 0: return cmd_setcar(playerid, "spawn");
				case 1: return ShowPlayerDialog(playerid, DIALOG_ACP_SETCAR_PLATE, DIALOG_STYLE_INPUT, "Set vehicle plate", "Enter the new plate:", "Select", "Cancel");
				case 2: return ShowPlayerDialog(playerid, DIALOG_ACP_SETCAR_C1, DIALOG_STYLE_INPUT, "Set vehicle colour 1", "Enter a new colour 1 for this vehicle:", "Select", "Cancel");
				case 3: return ShowPlayerDialog(playerid, DIALOG_ACP_SETCAR_C2, DIALOG_STYLE_INPUT, "Set vehicle colour 1", "Enter a new colour 2 for this vehicle:", "Select", "Cancel");
			}
		}
		case DIALOG_ACP_SETCAR_PLATE: {
			if(!response) return showACP(playerid);
			format(string, sizeof(string), "plate %s", inputtext);
			return cmd_setcar(playerid, string);
		}
		case DIALOG_ACP_SETCAR_C1: {
			if(!response) return showACP(playerid);
			format(string, sizeof(string), "color1 %s", inputtext);
			return cmd_setcar(playerid, string);
		}
		case DIALOG_ACP_SETCAR_C2: {
			if(!response) return showACP(playerid);
			format(string, sizeof(string), "color2 %s", inputtext);
			return cmd_setcar(playerid, string);
		}
		case DIALOG_ACP_SETACH: {
			if(!response) return showACP(playerid);
			return cmd_setachievement(playerid, inputtext);
		}
		case DIALOG_ACP_AGIVE: {
			if(!response) return showACP(playerid);
			SetPVarInt(playerid, "ACP_DialogVar", listitem);
			return ShowPlayerDialog(playerid, DIALOG_ACP_AGIVE_NAME, DIALOG_STYLE_INPUT, "Give A-Stuff", "Please enter the name/ID of the player:", "Select", "Cancel");
		}
		case DIALOG_ACP_AGIVE_NAME: {
			if(!response) return showACP(playerid);
			switch(GetPVarInt(playerid, "ACP_DialogVarString")) {
				case 0: {
					SetPVarString(playerid, "ACP_DialogVarString", inputtext);
					return ShowPlayerDialog(playerid, DIALOG_ACP_AGIVE_MONEY, DIALOG_STYLE_INPUT, "Give Money", "Please input the amount of money:", "Select", "Cancel");
				}
				case 1: format(string, sizeof(string), "%s jetpack", inputtext);
				case 2: {
					SetPVarString(playerid, "ACP_DialogVarString", inputtext);
					return ShowPlayerDialog(playerid, DIALOG_ACP_AGIVE_KILLSTREAK, DIALOG_STYLE_INPUT, "Give Killstreak", "Please input the killstreak amount:", "Select", "Cancel");
				}
				case 3: format(string, sizeof(string), "%s boost", inputtext);
			}
			return cmd_agive(playerid, string);
		}
		case DIALOG_ACP_AGIVE_MONEY: {
			if(!response) return showACP(playerid);
			new name[MAX_PLAYER_NAME];
			GetPVarString(playerid, "ACP_DialogVarString", name, sizeof(name));
			format(string, sizeof(string), "%s money %d", name, inputtext);
			return cmd_agive(playerid, string);
		}
		case DIALOG_ACP_AGIVE_KILLSTREAK: {
			if(!response) return showACP(playerid);
			new name[MAX_PLAYER_NAME];
			GetPVarString(playerid, "ACP_DialogVarString", name, sizeof(name));
			format(string, sizeof(string), "%s killstreak %d", name, inputtext);
			return cmd_agive(playerid, string);
		}
		case DIALOG_ACP_SETADMIN: {
			if(!response) return showACP(playerid);
			SetPVarInt(playerid, "ACP_DialogVar", listitem+1);
			return ShowPlayerDialog(playerid, DIALOG_ACP_SETADMIN_NAME, DIALOG_STYLE_LIST, "Set Admin", "Enter the name/ID of the admin:", "Select", "Cancel");
		}
		case DIALOG_ACP_SETADMIN_NAME: {
			if(!response) return showACP(playerid);
			format(string, sizeof(string), "%s %d", inputtext, GetPVarInt(playerid, "ACP_DialogVar"));
			return cmd_setadmin(playerid, string);
		}
		case DIALOG_ACP_SETTRIALADMIN: {
			if(!response) return showACP(playerid);
			SetPVarInt(playerid, "ACP_DialogVar", listitem);
			return ShowPlayerDialog(playerid, DIALOG_ACP_SETTRIALADMIN_NAME, DIALOG_STYLE_LIST, "Set Admin", "Enter the name/ID of the admin:", "Select", "Cancel");
		}
		case DIALOG_ACP_SETTRIALADMIN_NAME: {
			if(!response) return showACP(playerid);
			format(string, sizeof(string), "%s %d", inputtext, GetPVarInt(playerid, "ACP_DialogVar"));
			return cmd_settrialadmin(playerid, string);
		} 
		case DIALOG_ACP_ATURF: {
			if(!response) return showACP(playerid);
			switch(listitem) {
				case 0: return cmd_aturf(playerid, "info");
				case 1: return cmd_aturf(playerid, "edit");
				case 2: return cmd_aturf(playerid, "reset");
				case 3: return cmd_aturf(playerid, "stopedit");
			}
		}
		case DIALOG_ACP_MOTD: {
			if(!response) return showACP(playerid);
			return cmd_motd(playerid, inputtext);
		}
		case DIALOG_ACP_RULES: {
			if(!response) return showACP(playerid);
			SetPVarInt(playerid, "ACP_DialogVar", listitem);
			switch(listitem) {
				case 0: return ShowPlayerDialog(playerid, DIALOG_ACP_RULES_ADD, DIALOG_STYLE_INPUT, "Add rule", "Please enter the new rule:", "Select", "Cancel");
				case 1: return ShowPlayerDialog(playerid, DIALOG_ACP_RULES_REMOVE, DIALOG_STYLE_LIST, "Remove rule", rulestxt, "Select", "Cancel");
				case 2: return ShowPlayerDialog(playerid, DIALOG_ACP_RULES_EDIT, DIALOG_STYLE_LIST, "Edit rule", rulestxt, "Select", "Cancel");
			}
		}
		case DIALOG_ACP_RULES_ADD: {
			if(!response) return showACP(playerid);
			return cmd_addrule(playerid, inputtext);
		}
		case DIALOG_ACP_RULES_REMOVE: {
			if(!response) return showACP(playerid);
			format(string, sizeof(string), "%d", listitem);
			return cmd_removerule(playerid, string);
		}
		case DIALOG_ACP_RULES_EDIT: {
			if(!response) return showACP(playerid);
			SetPVarInt(playerid, "ACP_DialogVar", listitem);
			return ShowPlayerDialog(playerid, DIALOG_ACP_RULES_EDIT2, DIALOG_STYLE_INPUT, "Edit Rule", "Input the new rule:", "Select", "Cancel");
		}
		case DIALOG_ACP_RULES_EDIT2: {
			if(!response) return showACP(playerid);
			format(string, sizeof(string), "%d %s", GetPVarInt(playerid, "ACP_DialogVar"), inputtext);
			return cmd_editrule(playerid, string); 
		}
		case DIALOG_ACP_MAXPLAYERSPERIP: {
			if(!response) return showACP(playerid);
			return cmd_maxplayersperip(playerid, inputtext);
		}


	}
	return 0;
}



