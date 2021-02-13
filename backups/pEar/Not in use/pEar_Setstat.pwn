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
* Filename: pEar_Setstat.pwn                                                     *
* Author: pEar	                                                                 *
*********************************************************************************/

#include <YSI\y_hooks>

enum DialogVarSetStat_Info {
	ss_targetid,
	ss_var,
	ss_var2,
	ss_var3
};

new DialogVarSetStat[MAX_PLAYERS][DialogVarSetStat_Info];

CMD:setstat(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETSTAT))
	{
		new targetid;
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setstat [ID]");
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid playerid/name");
		}
		new string[128];
		format(string, sizeof(string), "[INFO]: You are now editing %s's(%d) stats.");
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		DialogVarSetStat[playerid][ss_targetid] = targetid;
		ShowPlayerDialog(playerid, DIALOG_SETSTAT_TYPE, DIALOG_STYLE_LIST, "Player Statistic Setting", "General Statistics\nWeapon Statistics\nClan Statistics\nAdmin Related Statistics\nReset Statistics", "Configure", "Cancel");
	}
	return 1;
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    new string[512];

	switch(dialogid)
	{
		case DIALOG_SETSTAT_TYPE:
		{
			if(response)
			{
				DialogVarSetStat[extraid][ss_var] == listitem;
				switch(listitem)
				{
					case 0:
					{
						format(string, sizeof(string), "Kills:\t%d\nDeaths:\t%d\nLevel:\t%d\nScore:\t%d\nSkin:\t%d\nHighest Streak:\t%d\nDuels Won:\t%d\nDuels Lost:\t%d\nDuels Total:\t%d\n\nMoney:\t%d\nCar-ID:\t%d\nEmail:\t%s\nPassword:\t...(You can only change this)", 
							FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][kills], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][deaths], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][level], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][level], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][score], 
							FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][skin], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid][streaks], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][duels_won], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][duels_lost], 
							FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][duels_total], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][cash], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][users_carid], 
							FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][email]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_GENERAL, DIALOG_STYLE_TABLIST_HEADERS, "General Statistics", string, "Configure", "Cancel");
						return 1;
					}
					case 1:
					{
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPONTYPE, DIALOG_STYLE_LIST, "Weapon Statistics", "Melee Weapons\nPistols\nShotguns\nSMGs\nRifles\nExplosives & Misc", "Configure", "Cancel");
					}
					case 2:
					{
						if(FoCo_Player[DialogVarSetStat[extraid][ss_targetid][clan] != -1)
						{
							format(string, sizeof(string), "Clan:\t%s\nClan Rank:\t%d", FoCo_Teams[FoCo_Player[DialogVarSetStat[extraid][ss_targetid][clan]], FoCo_Player[DialogVarSetStat[extraid][ss_targetid][clanrank]);
							ShowPlayerDialog(extraid, DIALOG_SETSTAT_CLAN, DIALOG_STYLE_LIST, "Clan Statistics", string, "Configure", "Cancel"); 
						}
						else
						{
							format(string, sizeof(string), "Clan:\tNone\nClan Rank:\t%d", FoCo_Player[DialogVarSetStat[extraid][ss_targetid][clanrank]);
							ShowPlayerDialog(extraid, DIALOG_SETSTAT_CLAN, DIALOG_STYLE_LIST, "Clan Statistics", string, "Configure", "Cancel"); 
						}
					}
					case 4:
					{
						new admin_type = {"Regular Player", "Junior Admin", "Admin", "Senior Admin", "IG-Lead Admin", "Lead Admin"};
						new type = {"No", "Yes"};
						format(string, sizeof(string), "Admin:\t%s\nTrialAdmin:\t%d\nJail-Time:\t%d\nBanned:\t%d\nTemp-Banned:\t%d\nWarnings:\t%d\nReports:\t%d\nAdmin-Kicks:\t%d\nAdmin-Jails:\t%d\nAdmin-Bans:\t%d\nAdmin-Warns:\t%d", 
							admin_type[FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][admin]], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][tester]], 
							FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][jailed], type[FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][banned]]], type[FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][tempban]]], 
							FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][warnings]], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][reports]], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][admin_kicks]], 
							FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][admin_jails]], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][admin_bans]], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][admin_warns]]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_ADMIN, DIALOG_STYLE_TABLIST_HEADERS, "Admin Related Statistics", string, "Configure", "Cancel");
					}
					case 5:
					{
						new string, sizeof(string), "Are you sure you want to reset %s's(%d) statistics?", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_RESET, DIALOG_STYLE_LIST, "Confirm Statistics Reset", string, "Yes, I am absolutely sure", "No, please cancel this!");
					}
				}
			}
			else
			{
				return 1;
			}
		}
		case DIALOG_SETSTAT_GENERAL:
		{
			if(response)
			{
				DialogVarSetStat[extraid][ss_var2] = listitem;
				switch(listitem):
				{
					case 0:
					{
						format(string, sizeof(string), "%s's(%d) current kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][kills]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_GENERAL_SUBMIT, DIALOG_STYLE_INPUT, "General Statistics", string, "Submit", "Cancel");
					}
					case 1:
					{
						format(string, sizeof(string), "%s's(%d) current deaths: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][deaths]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_GENERAL_SUBMIT, DIALOG_STYLE_INPUT, "General Statistics", string, "Submit", "Cancel");
					}
					case 2:
					{
						format(string, sizeof(string), "%s's(%d) current level: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][level]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_GENERAL_SUBMIT, DIALOG_STYLE_INPUT, "General Statistics", string, "Submit", "Cancel");
					}
					case 3:
					{
						format(string, sizeof(string), "%s's(%d) current score: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][score]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_GENERAL_SUBMIT, DIALOG_STYLE_INPUT, "General Statistics", string, "Submit", "Cancel");
					}
					case 4:
					{
						format(string, sizeof(string), "%s's(%d) current skin: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][skin]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_GENERAL_SUBMIT, DIALOG_STYLE_INPUT, "General Statistics", string, "Submit", "Cancel");
					}
					case 5:
					{
						format(string, sizeof(string), "%s's(%d) current highest streak: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStat[DialogVarSetStat[extraid][ss_targetid]][streaks]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_GENERAL_SUBMIT, DIALOG_STYLE_INPUT, "General Statistics", string, "Submit", "Cancel");
					}
					case 6:
					{
						format(string, sizeof(string), "%s's(%d) current duels won: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][duels_won]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_GENERAL_SUBMIT, DIALOG_STYLE_INPUT, "General Statistics", string, "Submit", "Cancel");
					}
					case 7:
					{
						format(string, sizeof(string), "%s's(%d) current duels lost: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][duels_lost]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_GENERAL_SUBMIT, DIALOG_STYLE_INPUT, "General Statistics", string, "Submit", "Cancel");
					}
					case 8:
					{
						format(string, sizeof(string), "%s's(%d) current duels total: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][duels_total]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_GENERAL_SUBMIT, DIALOG_STYLE_INPUT, "General Statistics", string, "Submit", "Cancel");
					}
					case 9:
					{
						format(string, sizeof(string), "%s's(%d) current money: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][cash]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_GENERAL_SUBMIT, DIALOG_STYLE_INPUT, "General Statistics", string, "Submit", "Cancel");
					}
					case 10:
					{
						format(string, sizeof(string), "%s's(%d) current car-ID: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][users_carid]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_GENERAL_SUBMIT, DIALOG_STYLE_INPUT, "General Statistics", string, "Submit", "Cancel");
					}
					case 11:
					{
						format(string, sizeof(string), "%s's(%d) current email: %s", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][email]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_GENERAL_SUBMIT, DIALOG_STYLE_INPUT, "General Statistics", string, "Submit", "Cancel");
					}
					case 12:
					{
						format(string, sizeof(string), "You may only change %s's(%d) password", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_GENERAL_SUBMIT, DIALOG_STYLE_INPUT, "General Statistics", string, "Submit", "Cancel");
					}
				}
			}
			else
			{
				return 1;
			}
		}
		case DIALOG_SETSTAT_WEAPONTYPE:
		{
			if(response)
			{
				DialogVarSetStat[extraid][ss_var2] = listitem;
				switch(listitem)
				{
					case 0:
					{
						format(string, sizeof(string), "Fists\t%d\nKnife\t%d\nChainsaw:\t%d\nOther melee:\t%d", FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][fists], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][knife], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][chainsaw], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][melee]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SPECIFIC, DIALOG_STYLE_TABLIST_HEADERS, "Weapon Statistics - Melee", string, "Configure", "Cancel");
					}
					case 1:
					{
						format(string, sizeof(string), "Deagle\t%d\nColt:\t%d\nSilenced Pistol:\t%d", FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][deagle], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][colt], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][silenced_pistol]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SPECIFIC, DIALOG_STYLE_TABLIST_HEADERS, "Weapon Statistics - Pistols", string, "Configure", "Cancel");
					}
					case 2:
					{
						format(string, sizeof(string), "Shotgun\t%d\nSawnoff:\t%d\nCombat Shotgun:\t%d", FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][shotgun], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][sawnoff], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][combatshotgun]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SPECIFIC, DIALOG_STYLE_TABLIST_HEADERS, "Weapon Statistics - Shotguns", string, "Configure", "Cancel");
					}
					case 3:
					{
						format(string, sizeof(string), "MP5:\t%d\nUzi:\t%d\nTec9:\t%d", FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][mp5], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][uzi], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][tec9]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SPECIFIC, DIALOG_STYLE_TABLIST_HEADERS, "Weapon Statistics - SMGs", string, "Configure", "Cancel");
					}
					case 4:
					{
						format(string, sizeof(string), "M4:\t%d\nAK47:\t%d\nSniper:\t%d\nRifle:\t%d", FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][m4], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][ak47], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][sniper], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][rifle]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SPECIFIC, DIALOG_STYLE_TABLIST_HEADERS, "Weapon Statistics - Rifles", string, "Configure", "Cancel");
					}
					case 5:
					{
						format(string, sizeof(string), "RPG:\t%d\nFlamethrower:\t%d\nGrenade:\t%d\nMolotov:\t%d\n")
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SPECIFIC, DIALOG_STYLE_TABLIST_HEADERS, "Weapon Statistics - Explosives & Misc", string, "Configure", "Cancel");
					}
				}
			}
			else
			{
				return 1;
			}
		}
		case DIALOG_SETSTAT_CLAN:
		{
			if(response)
			{
				DialogVarSetStat[extraid][ss_var2] = listitem;
				switch(listitem)
				{
					case 0:
					{
						if(FoCo_Player[DialogVarSetStat[extraid][ss_targetid][clan] != -1)
						{
							format(string, sizeof(string), "%s's(%d) current clan: %s", PlayerName(FoCo_Player[DialogVarSetStat[extraid][ss_targetid]), FoCo_Player[DialogVarSetStat[extraid][ss_targetid], FoCo_Teams[FoCo_Player[DialogVarSetStat[extraid][ss_targetid][clan]]);
							ShowPlayerDialog(extraid, DIALOG_SETSTAT_CLAN_SUBMIT, DIALOG_STYLE_INPUT, "Clan Statistics - Confirm change of clan", string, "Submit", "Cancel");
						}
						else
						{
							format(string, sizeof(string), "%s's(%d) current clan: None", PlayerName(FoCo_Player[DialogVarSetStat[extraid][ss_targetid]), FoCo_Player[DialogVarSetStat[extraid][ss_targetid]);
							ShowPlayerDialog(extraid, DIALOG_SETSTAT_CLAN_SUBMIT, DIALOG_STYLE_INPUT, "Clan Statistics - Confirm change of clan", string, "Submit", "Cancel");
						}
					}
					case 1:
					{
						format(string, sizeof(string), "%s's(%d) current clan-rank: %d", PlayerName(FoCo_Player[DialogVarSetStat[extraid][ss_targetid]), FoCo_Player[DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid][clanrank]);
						ShowPlayerDialog(extraid, DIALOG_SETSTAT_CLAN_SUBMIT, DIALOG_STYLE_INPUT, "Clan Statistics - Confirm change of clan-rank", string, "Submit", "Cancel");
					}
				}
			}
			else
			{
				return 1;
			}
		}
		case DIALOG_SETSTAT_ADMIN:
		{
			new type = {"No", "Yes"};
			DialogVarSetStat[extraid][ss_var2] = listitem;
			case 0:
			{
				new admin_type = {"Regular Player", "Junior Admin", "Admin", "Senior Admin", "IG-Lead Admin", "Lead Admin"};
				format(string, sizeof(string), "%s's(%d) admin: %s", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], admin_type[FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][admin]]);
				ShowPlayerDialog(extraid, DIALOG_SETSTAT_ADMIN_SUBMIT, DIALOG_STYLE_INPUT, "Admin Related Statistics", string, "Confirm", "Cancel");
			}
			case 1:
			{
				format(string, sizeof(string), "%s's(%d) trail-admin: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][tester]);
				ShowPlayerDialog(extraid, DIALOG_SETSTAT_ADMIN_SUBMIT, DIALOG_STYLE_INPUT, "Admin Related Statistics", string, "Confirm", "Cancel");
			}
			case 2:
			{
				format(string, sizeof(string), "%s's(%d) jail-time: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][jail]);
				ShowPlayerDialog(extraid, DIALOG_SETSTAT_ADMIN_SUBMIT, DIALOG_STYLE_INPUT, "Admin Related Statistics", string, "Confirm", "Cancel");
			}
			case 3:
			{
				format(string, sizeof(string), "%s's(%d) jail-time: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], type[FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][banned]]);
				ShowPlayerDialog(extraid, DIALOG_SETSTAT_ADMIN_SUBMIT, DIALOG_STYLE_INPUT, "Admin Related Statistics", string, "Confirm", "Cancel");
			}
			case 4:
			{
				format(string, sizeof(string), "%s's(%d) banned: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][jail]);
				ShowPlayerDialog(extraid, DIALOG_SETSTAT_ADMIN_SUBMIT, DIALOG_STYLE_INPUT, "Admin Related Statistics", string, "Confirm", "Cancel");
			}
			case 5:
			{
				format(string, sizeof(string), "%s's(%d) temp-banned: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], type[FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][tempban]]);
				ShowPlayerDialog(extraid, DIALOG_SETSTAT_ADMIN_SUBMIT, DIALOG_STYLE_INPUT, "Admin Related Statistics", string, "Confirm", "Cancel");
			}
			case 6:
			{
				format(string, sizeof(string), "%s's(%d) warnings: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][warnings]);
				ShowPlayerDialog(extraid, DIALOG_SETSTAT_ADMIN_SUBMIT, DIALOG_STYLE_INPUT, "Admin Related Statistics", string, "Confirm", "Cancel");
			}
			case 7:
			{
				format(string, sizeof(string), "%s's(%d) reports: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][reports]);
				ShowPlayerDialog(extraid, DIALOG_SETSTAT_ADMIN_SUBMIT, DIALOG_STYLE_INPUT, "Admin Related Statistics", string, "Confirm", "Cancel");
			}
			case 8:
			{
				format(string, sizeof(string), "%s's(%d) admin-kicks: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][admin_kicks]);
				ShowPlayerDialog(extraid, DIALOG_SETSTAT_ADMIN_SUBMIT, DIALOG_STYLE_INPUT, "Admin Related Statistics", string, "Confirm", "Cancel");
			}
			case 9:
			{
				format(string, sizeof(string), "%s's(%d) admin-jails: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][admin_jails]);
				ShowPlayerDialog(extraid, DIALOG_SETSTAT_ADMIN_SUBMIT, DIALOG_STYLE_INPUT, "Admin Related Statistics", string, "Confirm", "Cancel");
			}
			case 10:
			{
				format(string, sizeof(string), "%s's(%d) admin-bans: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][admin_bans]);
				ShowPlayerDialog(extraid, DIALOG_SETSTAT_ADMIN_SUBMIT, DIALOG_STYLE_INPUT, "Admin Related Statistics", string, "Confirm", "Cancel");
			}
			case 11:
			{
				format(string, sizeof(string), "%s's(%d) admin-warns: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][admin_warns]);
				ShowPlayerDialog(extraid, DIALOG_SETSTAT_ADMIN_SUBMIT, DIALOG_STYLE_INPUT, "Admin Related Statistics", string, "Confirm", "Cancel");
			}
		}
		case DIALOG_SETSTAT_RESET:
		{
			if(response)
			{
				format(string, sizeof(string), "[INFO]: %s %s(%d) has initiated a complete reset of your stats.", GetPlayerStatus(extraid), PlayerName(extraid), extraid);
				SendClienetMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, string);
				SendClienetMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, "This will completely reset all your stats if you agree to resetting.");
				SendClienetMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, "Accept this reset via /resetaccept, or cancel this via /resetcancel.");
				ResetStats[extraid] = DialogVarSetStat[extraid][ss_targetid];
				ResetStats[DialogVarSetStat[extraid][ss_targetid]] = extraid;
				format(string, sizeof(string), "[INFO]: Initiated a complete reset of %s's(%d) stats. He has to accept for this to take effect.", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid]);
				SendClientMessage(extraid, COLOR_GLOBALNOTICE, string);
				return 1;
			}
			else
			{
				return 1;
			}
		}
		case DIALOG_SETSTAT_GENERAL_SUBMIT:
		{
			if(response)
			{
				if(!IsNumeric(inputtext) && listitem != 11)
				{
					return SendClientMessage(extraid, COLOR_WARNING, "[ERROR]: Input MUST be a number!");
				}
				new input = strval(inputtext);
				if(input < 0)
				{
					return SendClientMessage(extraid, COLOR_WARNING, "[ERROR]: Input can't be less than 0!");
				}
				switch(DialogVarSetStat[extraid][ss_var2])
				{
					case 0:
					{
						format(string, sizeof(string), "[INFO]: You have set %s's(%d) kills to: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input);
						SendClientMessage(extraid, COLOR_SYNTAX, string);
						format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's(%d) kills to: %d, they used to be: %d", ACMD_SETSTAT, GetPlayerStatus(extraid), PlayerName(extraid), PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input, FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][kills]);
						SendAdminMessage(ACMD_SETSTAT, string);
						AdminLog(string);
						format(string, sizeof(string), "[INFO]: %s %s(%d) has set your kills to %d. If this is a mistake, make sure to report this. Your old kills were: %d", GetPlayerStatus(extraid), PlayerName(extraid), extraid, input, FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][kills]);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, string);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, "It is recommended that you relog to make sure everything saves.");
						FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][kills] = input;
					}
					case 1:
					{
						format(string, sizeof(string), "[INFO]: You have set %s's(%d) deaths to: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input);
						SendClientMessage(extraid, COLOR_SYNTAX, string);
						format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's(%d) deaths to: %d, they used to be: %d", ACMD_SETSTAT, GetPlayerStatus(extraid), PlayerName(extraid), PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input, FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][deaths]);
						SendAdminMessage(ACMD_SETSTAT, string);
						AdminLog(string);
						format(string, sizeof(string), "[INFO]: %s %s(%d) has set your deaths to %d. If this is a mistake, make sure to report this. Your old deaths were: %d", GetPlayerStatus(extraid), PlayerName(extraid), extraid, input, FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][deaths]);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, string);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, "It is recommended that you relog to make sure everything saves.");
						FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][deaths] = input;
					}
					case 2:
					{
						if(input > 10)
						{
							return SendClientMessage(extraid, COLOR_WARNING, "[ERROR]: Max is 10!");
						}
						format(string, sizeof(string), "[INFO]: You have set %s's(%d) level to: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input);
						SendClientMessage(extraid, COLOR_SYNTAX, string);
						format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's(%d) level to: %d, it used to be: %d", ACMD_SETSTAT, GetPlayerStatus(extraid), PlayerName(extraid), PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][level]);
						SendAdminMessage(ACMD_SETSTAT, string);
						AdminLog(string);
						format(string, sizeof(string), "[INFO]: %s %s(%d) has set your level to %d. If this is a mistake, make sure to report this. Your old level was: %d", GetPlayerStatus(extraid), PlayerName(extraid), extraid, input, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][level]);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, string);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, "It is recommended that you relog to make sure everything saves.");
						FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][level] = input;
					}
					case 3:
					{
						format(string, sizeof(string), "[INFO]: You have set %s's(%d) score to: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input);
						SendClientMessage(extraid, COLOR_SYNTAX, string);
						format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's(%d) score to: %d, it used to be: %d", ACMD_SETSTAT, GetPlayerStatus(extraid), PlayerName(extraid), PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][score]);
						SendAdminMessage(ACMD_SETSTAT, string);
						AdminLog(string);
						format(string, sizeof(string), "[INFO]: %s %s(%d) has set your score to %d. If this is a mistake, make sure to report this. Your old level was: %d", GetPlayerStatus(extraid), PlayerName(extraid), extraid, input, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][score]);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, string);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, "It is recommended that you relog to make sure everything saves.");
						FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][score] = input;
					}
					case 4:
					{
						if(input > 311)
						{
							return SendClientMessage(extraid, COLOR_WARNING, "[ERROR]: Max is 311");
						}
						format(string, sizeof(string), "[INFO]: You have set %s's(%d) skin to: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input);
						SendClientMessage(extraid, COLOR_SYNTAX, string);
						format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's(%d) skin to: %d, it used to be: %d", ACMD_SETSTAT, GetPlayerStatus(extraid), PlayerName(extraid), PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][skin]);
						SendAdminMessage(ACMD_SETSTAT, string);
						AdminLog(string);
						format(string, sizeof(string), "[INFO]: %s %s(%d) has set your skin to %d. If this is a mistake, make sure to report this. Your old skin was: %d", GetPlayerStatus(extraid), PlayerName(extraid), extraid, input, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][skin]);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, string);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, "It is recommended that you relog to make sure everything saves.");
						FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][skin] = input;
					}
					case 5:
					{
						format(string, sizeof(string), "[INFO]: You have set %s's(%d) highest streak to: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input);
						SendClientMessage(extraid, COLOR_SYNTAX, string);
						format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's(%d) highest streak to: %d, it used to be: %d", ACMD_SETSTAT, GetPlayerStatus(extraid), PlayerName(extraid), PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input, FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][streaks]);
						SendAdminMessage(ACMD_SETSTAT, string);
						AdminLog(string);
						format(string, sizeof(string), "[INFO]: %s %s(%d) has set your highest streak to %d. If this is a mistake, make sure to report this. Your old highest streak was: %d", GetPlayerStatus(extraid), PlayerName(extraid), extraid, input, FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][streaks]);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, string);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, "It is recommended that you relog to make sure everything saves.");
						FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][streaks] = input;
					}
					case 6:
					{
						format(string, sizeof(string), "[INFO]: You have set %s's(%d) duels-won to: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input);
						SendClientMessage(extraid, COLOR_SYNTAX, string);
						format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's(%d) duels-won to: %d, it used to be: %d", ACMD_SETSTAT, GetPlayerStatus(extraid), PlayerName(extraid), PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][duels_won]);
						SendAdminMessage(ACMD_SETSTAT, string);
						AdminLog(string);
						format(string, sizeof(string), "[INFO]: %s %s(%d) has set your duels-won to %d. If this is a mistake, make sure to report this. Your old duels-won was: %d", GetPlayerStatus(extraid), PlayerName(extraid), extraid, input, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][duels_won]);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, string);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, "It is recommended that you relog to make sure everything saves.");
						FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][duels_won] = input;
					}
					case 7:
					{
						format(string, sizeof(string), "[INFO]: You have set %s's(%d) duels-lost to: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input);
						SendClientMessage(extraid, COLOR_SYNTAX, string);
						format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's(%d) duels-lost to: %d, it used to be: %d", ACMD_SETSTAT, GetPlayerStatus(extraid), PlayerName(extraid), PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][duels_lost]);
						SendAdminMessage(ACMD_SETSTAT, string);
						AdminLog(string);
						format(string, sizeof(string), "[INFO]: %s %s(%d) has set your duels-lost to %d. If this is a mistake, make sure to report this. Your old duels-lost was: %d", GetPlayerStatus(extraid), PlayerName(extraid), extraid, input, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][duels_lost]);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, string);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, "It is recommended that you relog to make sure everything saves.");
						FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][duels_lost] = input;
					}
					case 8:
					{
						format(string, sizeof(string), "[INFO]: You have set %s's(%d) duels-total to: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input);
						SendClientMessage(extraid, COLOR_SYNTAX, string);
						format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's(%d) duels-total to: %d, it used to be: %d", ACMD_SETSTAT, GetPlayerStatus(extraid), PlayerName(extraid), PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][duels_total]);
						SendAdminMessage(ACMD_SETSTAT, string);
						AdminLog(string);
						format(string, sizeof(string), "[INFO]: %s %s(%d) has set your duels-total to %d. If this is a mistake, make sure to report this. Your old duels-total was: %d", GetPlayerStatus(extraid), PlayerName(extraid), extraid, input, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][duels_total]);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, string);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, "It is recommended that you relog to make sure everything saves.");
						FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][duels_total] = input;
					}
					case 9:
					{
						format(string, sizeof(string), "[INFO]: You have set %s's(%d) money to: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input);
						SendClientMessage(extraid, COLOR_SYNTAX, string);
						format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's(%d) money to: %d, it used to be: %d", ACMD_SETSTAT, GetPlayerStatus(extraid), PlayerName(extraid), PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][cash]);
						SendAdminMessage(ACMD_SETSTAT, string);
						AdminLog(string);
						format(string, sizeof(string), "[INFO]: %s %s(%d) has set your money to %d. If this is a mistake, make sure to report this. Your money was: %d", GetPlayerStatus(extraid), PlayerName(extraid), extraid, input, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][cash]);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, string);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, "It is recommended that you relog to make sure everything saves.");
						FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][cash] = input;
					}
					case 10:
					{
						format(string, sizeof(string), "[INFO]: You have set %s's(%d) car-ID to: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input);
						SendClientMessage(extraid, COLOR_SYNTAX, string);
						format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's(%d) car-ID to: %d, it used to be: %d", ACMD_SETSTAT, GetPlayerStatus(extraid), PlayerName(extraid), PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], input, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][users_carid]);
						SendAdminMessage(ACMD_SETSTAT, string);
						AdminLog(string);
						format(string, sizeof(string), "[INFO]: %s %s(%d) has set your car-ID to %d. If this is a mistake, make sure to report this. Your old car-ID was: %d", GetPlayerStatus(extraid), PlayerName(extraid), extraid, input, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][users_carid]);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, string);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, "It is recommended that you relog to make sure everything saves.");
						FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][users_carid] = input;
					}
					case 11:
					{
						format(string, sizeof(string), "[INFO]: You have set %s's(%d) email to: %s", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], inputtext);
						SendClientMessage(extraid, COLOR_SYNTAX, string);
						format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's(%d) email to: %s, it used to be: %s", ACMD_SETSTAT, GetPlayerStatus(extraid), PlayerName(extraid), PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], inputtext, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][email]);
						SendAdminMessage(ACMD_SETSTAT, string);
						AdminLog(string);
						format(string, sizeof(string), "[INFO]: %s %s(%d) has set your email to %s. If this is a mistake, make sure to report this. Your old email was: %s", GetPlayerStatus(extraid), PlayerName(extraid), extraid, inputtext, FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][email]);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, string);
						SendClientMessage(DialogVarSetStat[extraid][ss_targetid], COLOR_GLOBALNOTICE, "It is recommended that you relog to make sure everything saves.");
						FoCo_Player[DialogVarSetStat[extraid][ss_targetid]][email] = inputtext;
					}
				}
			}
			else
			{
				return 1;
			}
		}
		case DIALOG_SETSTAT_WEAPON_SPECIFIC:
		{
			if(response)
			{
				DialogVarSetStat[extraid][ss_var3] = listitem;
				switch(DialogVarSetStat[extraid][ss_var])
				{
					case 0:
					{
						switch(DialogVarSetStat[extraid][ss_var2])
						{
							case 0:
							{
								format(string, sizeof(string), "%s's(%d) fist kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][fists]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - Fists", string, "Confirm", "Cancel");
							}
							case 1:
							{
								format(string, sizeof(string), "%s's(%d) knife kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][knife]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - Fists", string, "Confirm", "Cancel");
							}
							case 2:
							{
								format(string, sizeof(string), "%s's(%d) chainsaw kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][chainsaw]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - Chainsaw", string, "Confirm", "Cancel");
							}
							case 3:
							{
								format(string, sizeof(string), "%s's(%d) other melee kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][melee]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - Other melee", string, "Confirm", "Cancel");
							}
						}
					}
					case 1:
					{
						switch(DialogVarSetStat[extraid][ss_var2])
						{
							case 0:
							{
								format(string, sizeof(string), "%s's(%d) Deagle kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][deagle]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - Deagle", string, "Confirm", "Cancel");
							}
							case 1:
							{
								format(string, sizeof(string), "%s's(%d) Colt kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][colt]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - Colt", string, "Confirm", "Cancel");
							}
							case 2:
							{
								format(string, sizeof(string), "%s's(%d) Silenced Pistol kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][silenced_pistol]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - Silenced Pistol", string, "Confirm", "Cancel");
							}
						}
					}
					case 2:
					{
						switch(DialogVarSetStat[extraid][ss_var2])
						{
							case 0:
							{
								format(string, sizeof(string), "%s's(%d) Shotgun kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][shotgun]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - Shotgun", string, "Confirm", "Cancel");
							}
							case 1:
							{
								format(string, sizeof(string), "%s's(%d) Sawnoff kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][sawnoff]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - Sawnoff", string, "Confirm", "Cancel");
							}
							case 2:
							{
								format(string, sizeof(string), "%s's(%d) Combat-Shotgun kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][combatshotgun]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - Combat Shotgun", string, "Confirm", "Cancel");
							}
						}
					}
					case 3:
					{
						switch(DialogVarSetStat[extraid][ss_var2])
						{
							case 0:
							{
								format(string, sizeof(string), "%s's(%d) MP5 kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][mp5]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - MP5", string, "Confirm", "Cancel");
							}
							case 1:
							{
								format(string, sizeof(string), "%s's(%d) Uzi kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][uzi]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - Uzi", string, "Confirm", "Cancel");
							}
							case 2:
							{
								format(string, sizeof(string), "%s's(%d) Tec9 kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][tec9]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - tec9", string, "Confirm", "Cancel");
							}
						}
					}
					case 4:
					{
						switch(DialogVarSetStat[extraid][ss_var2])
						{
							case 0:
							{
								format(string, sizeof(string), "%s's(%d) M4 kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][ak47]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - M4", string, "Confirm", "Cancel");
							}
							case 1:
							{
								format(string, sizeof(string), "%s's(%d) AK47 kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][ak47]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - AK47", string, "Confirm", "Cancel");
							}
							case 2:
							{
								format(string, sizeof(string), "%s's(%d) Sniper kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][sniper]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - Sniper", string, "Confirm", "Cancel");
							}
							case 3:
							{
								format(string, sizeof(string), "%s's(%d) Rifle kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][rifle]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - Rifle", string, "Confirm", "Cancel");
							}
						}
					}
					case 5:
					{
						switch(DialogVarSetStat[extraid][ss_var2])
						{
							case 0:
							{
								format(string, sizeof(string), "%s's(%d) RPG kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][rpg]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - RPG", string, "Confirm", "Cancel");
							}
							case 1:
							{
								format(string, sizeof(string), "%s's(%d) flamethrower kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][flamethrower]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - Flamethrower", string, "Confirm", "Cancel");
							}
							case 2:
							{
								format(string, sizeof(string), "%s's(%d) Grenade kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][grenade]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - Grenade", string, "Confirm", "Cancel");
							}
							case 3:
							{
								format(string, sizeof(string), "%s's(%d) Molotov kills: %d", PlayerName(DialogVarSetStat[extraid][ss_targetid]), DialogVarSetStat[extraid][ss_targetid], FoCo_PlayerStats[DialogVarSetStat[extraid][ss_targetid]][molotov]);
								ShowPlayerDialog(extraid, DIALOG_SETSTAT_WEAPON_SUBMIT, DIALOG_STYLE_INPUT, "Weapon Statistics - Molotov", string, "Confirm", "Cancel");
							}
						}
					}
				}
			}
			else
			{
				return 1;
			}
		}
	}
	return 1;
}