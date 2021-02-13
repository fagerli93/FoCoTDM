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
* Filename: pEar_setstats.pwn                                                    *
* Author: pEar	                                                                 *
*********************************************************************************/
#include <YSI\y_hooks>

/*
	Hooks:
		OnDialogResponse
		
*/



stock GetSetStatPage1(targetid)
{
	new list[1024], string[256];
	format(string, sizeof(string), "1) KILLS [Curr: %d]", FoCo_Playerstats[targetid][kills]); 
	strcat(list, string);
	format(string, sizeof(string), "2) DEATHS [Curr: %d]", FoCo_Playerstats[targetid][deaths]);
	strcat(list, string);
	format(string, sizeof(string), "3) LEVEL [Curr: %d]", FoCo_Player[targetid][level]);
	strcat(list, string);
	format(string, sizeof(string), "4) SCORE [Curr: %d]", FoCo_Player[targetid][score]);
	strcat(list, string);
	format(string, sizeof(string), "5) WARNINGS [Curr: %d]", FoCo_Player[targetid][warns]);
	strcat(list, string);
	format(string, sizeof(string), "6) SUICIDES [Curr: %d]", FoCo_Playerstats[targetid][suicides]);
	strcat(list, string);
	format(string, sizeof(string), "7) HIGHEST STREAK [Curr: %d]", FoCo_Playerstats[targetid][streaks]);
	strcat(list, string);
	format(string, sizeof(string), "8) TEMP SKIN [Curr: %d]", GetPlayerSkin(targetid));
	strcat(list, string);
	format(string, sizeof(string), "9) ONLINE TIME [Curr: %d]", FoCo_Player[targetid][onlinetime]);
	strcat(list, string);
	format(string, sizeof(string), "10) EMAIl [Curr: %s]", FoCo_Player[targetid][email]);
	strcat(list, string);
	return list;
}

stock GetSetStatPage2(targetid)
{
	new list[1024], string[256];
	format(string, sizeof(string), "1) ADMIN LEVEL [Curr: %d]", FoCo_Player[targetid][admin]);
	strcat(list, string);
	format(string, sizeof(string), "2) TRIAL-ADMIN LEVEL [Curr: %d]", FoCo_Player[targetid][tester];
	strcat(list, string);
	new donator[15];
	format(donator, sizeof(donator), "None");
	switch(FoCo_Player[targetid][donation])
	{
		case 1: format(donator, sizeof(donator), "Bronze");
		case 2: format(donator, sizeof(donator), "Silver");
		case 3: format(donator, sizeof(donator), "Gold");
	}
	format(string, sizeof(string), "3) DONATION STATUS [Curr: %s]", donator);
	strcat(list, string);
	format(string, sizeof(string), "4) NAMECHANGES [Curr: %d]", FoCo_Player[targetid][nchanges]);
	strcat(list, string);
	format(string, sizeof(string), "5) CLAN [Curr: %d]", FoCo_Player[targetid][clan]);
	strcat(list, string);
	format(string, sizeof(string), "6) CLAN RANK [Curr: %d]", FoCo_Player[targetid][clanrank]);
	strcat(list, string);
	return list;
}

stock GetSetStatPage3(targetid)
{
	new list[1024], string[256];
	format(string, sizeof(string), "1) Knife [Curr: %d]", FoCo_Playerstats[targetid][knife]);
	strcat(list, string);
	format(string, sizeof(string), "2) Chainsaw [Curr: %d]
	
	return list;
}

forward SetStats_OnDialogReponse(playerid, dialogid, response, listitem, inputtext[]);
public SetStats_OnDialogReponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		new string[512];
		case DIALOG_ASETSTAT:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						ShowPlayerDialog
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

CMD:setstats(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETSTATS))
	{
		new targetid;
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setstats [ID]");
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid ID/Name.");
		}
		new string[256];
		format(string, sizeof(string), "[INFO]: YOu are now setting %s's(%d) statistics.", PlayerName(targetid), targetid);
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		format(string, sizeof(string), "General\nAdmin, Tester, Donation\nClan\nWeapons\nAchievements");
		DialogOptionVar1[playerid] = targetid;
		ShowPlayerDialog(playerid, DIALOG_ASETSTAT, DIALG_STYLE_LIST, "Player Statistic Settings", string, "Select", "Cancel");
	}
	return 1;
}
