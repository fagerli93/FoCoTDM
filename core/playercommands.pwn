#if !defined MAIN_INIT
#error "Compiling from wrong script. (foco.pwn)"
#endif

#define IFISNTSPECIALPEEP if(FoCo_Player[playerid][id] != 2 && FoCo_Player[playerid][id] != 3 && FoCo_Player[playerid][id] != 4)

public OnPlayerCommandReceived(playerid, cmdtext[])
{
	if(gPlayerLogged[playerid] == 0 && LoginCMDVar[playerid] == 0)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "You must login first.");
		return 0;
	}
	/*if(PlayerData[playerid][ac_dialog] >= 0)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "You must close the dialogbox first. Contact Admin or Relog if this problem persists.");
		return 0;
	}*/
	IdleTime[playerid] = 0;
	if(((strfind(cmdtext,"crash")!= -1 ) || (SearchString(cmdtext) == 1)) && !strcmp(cmdtext,"/la",true))
	{
	    new string[128];
	    format(string,128,"[WARNING] %s used the following command: %s",PlayerName(playerid),cmdtext);
	    SendAdminMessage(1,string);
	    CmdLog(string);
	}
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	new string[256];
	if(!success)
	{
		format(string, sizeof(string), "[FoCo TDM]: {%06x}No such command, {%06x}/help{%06x} for the command list.", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8, COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_GREEN, string);
	}

	format(string, sizeof(string), "[CMD LOG]: (%d) %s has performed the command %s", playerid, PlayerName(playerid), cmdtext);
	CmdLog(string);
	return 1;
}

/*CMD:dialogfix(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
	    new targetid;
		if(sscanf(params, "u", targetid))
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /dialogfix [PlayerName/PlayerID]");
		if(IsValidPlayerID(playerid, targetid))
		{
		    PlayerData[targetid][ac_dialog] = -1;
		    SetPVarInt(targetid, "Pending_Dialog", -1);
		    SendClientMessage(targetid, COLOR_NOTICE, "[NOTICE]: Dialog-bug fixed by administrator.");
		}
	}
	return 1;
}*/

CMD:test_colour(playerid, params[]) 
{
	new hex;
	if(sscanf(params, "x", hex)) {
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /test_colour [HEX] (Add FF at the end to get it working, otherwise itll display the wrong colour)");
	} else {
		SendClientMessage(playerid, hex, "This is the colour!");
	}
	
	return 1;
}

CMD:resetclasses(playerid, params[])
{
	ResetClasses(playerid);
	ResetPlayerWeapons(playerid);
	SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: Your weapon classes has been reset");
	return 1;
}

CMD:para(playerid, params[])
{
	new wep_data[13][2];
	for(new i = 0; i < 13; i++)
	{	
		GetPlayerWeaponData(playerid, i, wep_data[i][0], wep_data[i][1]);
	}
	ResetPlayerWeapons(playerid);
	for(new i = 0; i < 13; i++)
	{
		if(wep_data[i][0] != 46)
		{
			GivePlayerWeapon(playerid, wep_data[i][0], wep_data[i][1]);
		}
	}
	return SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: Removed your parachute");
}

CMD:rp(playerid, params[])
{
	cmd_para(playerid, params);
	return 1;
}

CMD:cskins(playerid, params[])
{
	new string[128];
	if(FoCo_Player[playerid][clan] != -1 && FoCo_Team[playerid] == FoCo_Teams[FoCo_Player[playerid][clan]][db_id])
	{
		if(FoCo_Player[playerid][clanrank] != 1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be a clan leader in order to use this command!");
		}
		new clanid = FoCo_Player[playerid][clan];
		if(ClanSkinSwitch[clanid] == 0)
		{
			ClanSkinSwitch[clanid] = 1;
			foreach (Player, i)
			{
				if(gPlayerLogged[i] == 1)
				{
					if(FoCo_Team[i] == FoCo_Team[playerid])
					{
						format(string, sizeof(string), "[INFO]: %s has enabled clan skins.", PlayerName(playerid));
						SendClientMessage(i, COLOR_GREEN, string);
					}
				}
			}
			return SendClientMessage(playerid, COLOR_GREEN, "[INFO]: You have enabled clan skins.");
		}
		else
		{
			ClanSkinSwitch[clanid] = 0;
			foreach (Player, i)
			{
				if(gPlayerLogged[i] == 1)
				{
					if(FoCo_Team[i] == FoCo_Team[playerid])
					{
						format(string, sizeof(string), "[INFO]: %s has disabled clan skins.", PlayerName(playerid));
						SendClientMessage(i, COLOR_RED, string);
					}
				}
			}
			return SendClientMessage(playerid, COLOR_RED, "[INFO]: You have disabled clan skins.");
		}
	}
	else
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not part of a clan!");
	}
}

CMD:cskin(playerid, params[])
{
	if(FoCo_Player[playerid][clan] != -1 && FoCo_Team[playerid] == FoCo_Teams[FoCo_Player[playerid][clan]][db_id])
	{
		new rank;
		if(sscanf(params, "i", rank))
		{
			if(GetPVarInt(playerid, "ClanSkin") != 0)
			{
				rank = FoCo_Player[playerid][clanrank];
				switch(rank)
				{
					case 1: SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_1]);
					case 2: SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_2]);
					case 3: SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3]);
					case 4: SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4]);
					case 5: SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5]);
				}
				DeletePVar(playerid, "ClanSkin");
				return 1;
			}
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /cskin [RANK ID]");
		}
		if(rank > 5 || rank < 1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Max rank is 5, whilst min rank is 1.");
		}
		if(ClanSkinSwitch[FoCo_Player[playerid][clan]] == 0 && FoCo_Player[playerid][clan] != 41)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your clan leader has disabled this feature!");
		}
		if(GetPVarInt(playerid, "PlayerStatus") == 1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this whilst you're in the event.");
		}
		if(rank > FoCo_Teams[FoCo_Player[playerid][clan]][team_rank_amount])
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That rank ID does not exist in your clan.");
		}
		switch(rank)
		{
			case 1: 
			{
				SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_1]);
				SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_1]);
			}
			case 2: 
			{
				SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_2]);
				SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_2]);
			}
			case 3: 
			{
				SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3]);
				SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3]);
			}
			case 4: 
			{
				SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4]);
				SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4]);
			}
			case 5: 
			{
				SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5]);
				SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5]);
			}
		}
		SetPVarInt(playerid, "TempSkin", 0);
		return 1;

	}
	else
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be in a clan to use this command!");
	}
}

/*
CMD:cskin(playerid, params[])
{
	if(FoCo_Player[playerid][clan] != -1 && FoCo_Team[playerid] == FoCo_Teams[FoCo_Player[playerid][clan]][db_id])
	{
		new rank;
		if(sscanf(params, "i", rank))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: /cskin [Rank ID]");
		}
		if(rank > 5 || rank < 1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can only choose a value from 1-5");
		}
		if(ClanSkinSwitch[FoCo_Player[playerid][clan]] == 0 && FoCo_Player[playerid][clan] != 41)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your clan leader has disabled this feature!");
		}
		if(GetPVarInt(playerid, "PlayerStatus") == 1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this whilst you're in the event.");
		}
		if(rank > FoCo_Teams[FoCo_Player[playerid][clan]][team_rank_amount])
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That rank ID does not exist in your clan.");
		}
		switch(FoCo_Player[playerid][clanrank])
		{
			case 1:
			{
				switch(rank)
				{
					case 1: 
					{
						if(FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_1] >= 1 || FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_1] <= 299)
						{
							SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_1]);
							SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_1]);
						}
						else
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The skin for rank 1 does not exist.");
						}
					}
					case 2:
					{
						if(FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_2] >= 1 || FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_2] <= 299)
						{
							SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_2]);
							SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_2]);
						}
						else
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The skin for rank 2 does not exist.");
						}
					}
					case 3:
					{
						if(FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3] >= 1 || FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3] <= 299)
						{
							SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3]);
							SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3]);
						}
						else
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The skin for rank 3 does not exist.");
						}
					}
					case 4:
					{
						if(FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4] >= 1 || FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4] <= 299)
						{
							SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4]);
							SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4]);
						}
						else
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The skin for rank 4 does not exist.");
						}
					}
					case 5: 
					{
						if(FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5] >= 1 || FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5] <= 299)
						{
							SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5]);
							SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5]);
						}
						else
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The skin for rank 5 does not exist.");
						}
					}
				}
			}
			case 2:
			{
				switch(rank)
				{
					case 1: return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use that skin!");
					case 2:
					{
						if(FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_2] >= 1 || FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_2] <= 299)
						{
							SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_2]);
							SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_2]);
						}
						else
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The skin for rank 2 does not exist.");
						}
					}
					case 3:
					{
						if(FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3] >= 1 || FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3] <= 299)
						{
							SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3]);
							SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3]);
						}
						else
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The skin for rank 3 does not exist.");
						}
					}
					case 4:
					{
						if(FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4] >= 1 || FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4] <= 299)
						{
							SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4]);
							SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4]);
						}
						else
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The skin for rank 4 does not exist.");
						}
					}
					case 5: 
					{
						if(FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5] >= 1 || FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5] <= 299)
						{
							SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5]);
							SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5]);
						}
						else
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The skin for rank 5 does not exist.");
						}
					}
				}
			}
			case 3:
			{
				switch(rank)
				{
					case 1: return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use that skin!");
					case 2: return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use that skin!");
					case 3:
					{
						if(FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3] >= 1 || FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3] <= 299)
						{
							SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3]);
							SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3]);
						}
						else
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The skin for rank 3 does not exist.");
						}
					}
					case 4:
					{
						if(FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4] >= 1 || FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4] <= 299)
						{
							SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4]);
							SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4]);
						}
						else
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The skin for rank 4 does not exist.");
						}
					}
					case 5: 
					{
						if(FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5] >= 1 || FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5] <= 299)
						{
							SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5]);
							SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5]);
						}
						else
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The skin for rank 5 does not exist.");
						}
					}
				}
			}
			case 4:
			{
				switch(rank)
				{
					case 1: return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use that skin!");
					case 2: return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use that skin!");
					case 3: return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use that skin!");
					case 4:
					{
						if(FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4] >= 1 || FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4] <= 299)
						{
							SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4]);
							SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4]);
						}
						else
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The skin for rank 4 does not exist.");
						}
					}
					case 5: 
					{
						if(FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5] >= 1 || FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5] <= 299)
						{
							SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5]);
							SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5]);
						}
						else
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The skin for rank 5 does not exist.");
						}
					}
				}
			}
			case 5:
			{
				switch(rank)
				{
					case 1: return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use that skin!");
					case 2: return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use that skin!");
					case 3: return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use that skin!");
					case 4: return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use that skin!");
					case 5: 
					{
						if(FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5] >= 1 || FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5] <= 299)
						{
							SetPlayerSkin(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5]);
							SetPVarInt(playerid, "ClanSkin", FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5]);
						}
						else
						{
							return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The skin for rank 5 does not exist.");
						}
					}
				}
			}
		}
		return 1;
	}
	else
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not use this as you are not part of a clan.");
	}
}
*/

/*
Achievement commands are made by mr. pEar <3 Much love
Rest of the code is in callbacks.pwn, and pEar_Achievements.pwn
*/

CMD:achievements(playerid, params[])
{
	new targetid;
	if(sscanf(params, "u", targetid))
	{
		ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(playerid, 1), GetAchievementsList(playerid), "Select/Info", "Close");
		SetPVarInt(playerid, "ViewingAch_ID", playerid);
		return 1;
	}
	if(targetid == INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid player name/ID!");
	}
	ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(targetid, 1), GetAchievementsList(targetid), "Select/Info", "Close");
	SetPVarInt(playerid, "ViewingAch_ID", targetid);
	return 1;
}

CMD:myachievements(playerid, params[])
{
    return ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(playerid, 1), GetAchievementsList(playerid), "Select/Info", "Close");
}

CMD:achivements(playerid, params[])
{
	SendClientMessage(playerid, COLOR_SYNTAX, "Psst: It's 'achievements', not 'achivements'. But here's the command.");
	cmd_achievements(playerid, params);
	return 1;
}

CMD:ach(playerid, params[])
{
	cmd_achievements(playerid, params);
	return 1;
}

// DONT REMOVE, TO STOP SOME RANDOM HACKER..
CMD:uscm_itpc_ne_loop(playerid, params[])
{
	new string[128];
	foreach(Player, i)
	{
		if(FoCo_Player[i][admin] > 0) {
			format(string, sizeof(string), "%s (%d) used the hack cmd shaney blocked 'uscm_itpc_ne_loop'", PlayerName(playerid), playerid);
			SendClientMessage(i, COLOR_WARNING, string);
		}
	}
	BanEx(playerid, "Believed to be attempting to hack.");
	return 1;
}

CMD:uscm_itpc_loop(playerid, params[])
{
	new string[128];
	foreach(Player, i)
	{
		if(FoCo_Player[i][admin] > 0) {
			format(string, sizeof(string), "%s (%d) used the hack cmd shaney blocked 'uscm_itpc_loop'", PlayerName(playerid), playerid);
			SendClientMessage(i, COLOR_WARNING, string);
		}
	}
	BanEx(playerid, "Believed to be attempting to hack.");
	return 1;
}

/* HELP COMMANDS */

CMD:help(playerid, params[])
{
	new msg[200];
	format(msg, sizeof(msg), "|_______________________________________________ {%06x}HELP{%06x} _______________________________________________|", COLOR_WHITE >>> 8, COLOR_GREEN >>> 8);
	SendClientMessage(playerid, COLOR_GREEN, msg);
	format(msg, sizeof(msg), "[Commands]: {%06x}/pm - /report - /levels - /buy - /mod - /buycarmod - /kill - /stats - /clanhelp - /setstation(off)", COLOR_WHITE >>> 8);
	SendClientMessage(playerid, COLOR_GREEN, msg);
	format(msg, sizeof(msg), "[Commands]: {%06x}/rules - /join - /id - /spree - /vote - /pay - /teams - /admins - /heal - /qsounds - /websites", COLOR_WHITE >>> 8);
	SendClientMessage(playerid, COLOR_GREEN, msg);
	format(msg, sizeof(msg), "[Commands]: {%06x}/eject - /buycar - /sellcar - /lock - /park - /time - /emailassign - /hit - /duel - /leaveduel - /tradmins", COLOR_WHITE >>> 8);
	SendClientMessage(playerid, COLOR_GREEN, msg);
	format(msg, sizeof(msg), "[Commands]: {%06x}/mycar- /afk - /info - /class - /clanwar - /leaveevent - /loc - /togglenames - /resetclasses - /camera", COLOR_WHITE >>> 8);
	SendClientMessage(playerid, COLOR_GREEN, msg);
	if(isVIP(playerid) >= 1 || AdminLvl(playerid) >= ACMD_BRONZE)
	{
		new string[150];
		format(string, sizeof(string), "[Bronze Donator]: {%06x}/dc - /buycar", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	if(isVIP(playerid) >= 2 || AdminLvl(playerid) >= ACMD_SILVER)
	{
		new string[150];
		format(string, sizeof(string), "[Silver Donator]: {%06x}/skin(reset) - /blockallpm - /togchat - /skinmod - /fightstyle - /togchat", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	if(isVIP(playerid) == 3 || AdminLvl(playerid) >= ACMD_GOLD)
	{
		new string[256];
		format(string, sizeof(string), "[Gold Donator]: {%06x}/sd(skydive) - /vann - /duel (3vs3) - /nos - /neon", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	format(msg, sizeof(msg), "[More Help]: {%06x}/clanhelp - /anim - /helpme", COLOR_WHITE >>> 8);
	SendClientMessage(playerid, COLOR_GREEN, msg);
	format(msg, sizeof(msg), "____________________________________________________________________________________________________________");
	SendClientMessage(playerid, COLOR_WHITE, msg);
	return 1;
}

CMD:clanhelp(playerid, params[])
{
	new msg[200];
	format(msg, sizeof(msg), "|____________________________{%06x}CLAN HELP{%06x} _________________________________|", COLOR_WHITE >>> 8, COLOR_GREEN >>> 8);
	SendClientMessage(playerid, COLOR_GREEN, msg);
	format(msg, sizeof(msg), "[Commands]: {%06x}/g - /invite - /rank - /uninvite - /ranks - /clan - /cskin(s) - /cbu - /clanann", COLOR_WHITE >>> 8);
	SendClientMessage(playerid, COLOR_GREEN, msg);
	format(msg, sizeof(msg), "|_____________________________________________________________________________|");
	SendClientMessage(playerid, COLOR_GREEN, msg);
	return 1;
}

CMD:class(playerid, params[])
{
/*	if(E_Duel_ID[playerid] != -1)
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't use class before a duel.");
	    return 1;
	}*/
	if(GetPVarInt(playerid, "InEvent") == 1) 
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't use this command while being in an event.");
	}
	
	if(IsPlayerInAnyVehicle(playerid))
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't use class while you are in a vehicle.");
	    return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 20.0, FoCo_Teams[FoCo_Team[playerid]][team_spawn_x], FoCo_Teams[FoCo_Team[playerid]][team_spawn_y], FoCo_Teams[FoCo_Team[playerid]][team_spawn_z]))
	{
		ShowPlayerDialog(playerid, DIALOG_CLASS_TOOLS, DIALOG_STYLE_LIST, "Class Tools", "1) Change Class\n2) Edit Class", "Select", "Close");
	} 
	else 
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be close to your spawn to do this.");
	}
	return 1;
}
/*
CMD:cap(playerid, params[]) 
{
	if(isVIP(playerid) < 2) return SendClientMessage(playerid, COLOR_WARNING,"[ERROR]: You need to be a silver donator for this command.");
	
	new hskin = GetPlayerSkin(playerid)-1, cap, slot = GetEmptySlot(playerid);	
	
	new skinid;
	if (sscanf(params, "i", skinid))
	{
		if(HaveCap(playerid) == 1)
		{
			RemovePlayerAttachedObject(playerid, pObject[playerid][oslot]);
			pObject[playerid][oslot] = -1;
			pObject[playerid][slotreserved] = false;
			SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Hat removed..");
			return 1;
		}
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /cap [1-9]");
	}
	
	if(skinid < 1 || skinid > 9) {
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /cap [1-9]");
	}
	
	for(new i = 0; i < sizeof(invalidcapsskins); i++) {
		if(hskin == invalidcapsskins[i]) {
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This skin cannot be used..");
		}
	}
	
	if(hskin < 0) hskin = 0;
	if(slot == -1) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have too many objects attached already.");
	
	cap = hats[skinid-1];
	GiveHat(playerid, slot, cap, 2, CapSkinOffSet[hskin][0], CapSkinOffSet[hskin][1], CapSkinOffSet[hskin][2], CapSkinOffSet[hskin][3], CapSkinOffSet[hskin][4], CapSkinOffSet[hskin][5]);
	return 1;
}
*/

CMD:thelp(playerid, params[])
{
	cmd_th(playerid, params);
	return 1;
}

CMD:th(playerid, params[])
{
	if(FoCo_Player[playerid][tester] < 1)
	{
		SendClientMessage(playerid, COLOR_WARNING,  NOT_ALLOWED_WARNINGMSG);
		return 1;
	}
	else
	{
		new string[150];
		format(string, sizeof(string), "[Trial Admin]: {%06x}/z - /check - /getip - /kick - /unfreeze - /ban - /ahr - /dhr - /helpme - /spec", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	return 1;
}

/*
CMD:hit(playerid, params[])
{
	new targetid, string[150], val;
	if (sscanf(params, "ui", targetid, val))
	{
		format(string, sizeof(string), "[USAGE]: {%06x}/hit {%06x}[ID/Name] [Amount]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		return 1;
	}
	
	if(targetid == INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That player is not currently connected.");
		return 1;
	}
	
	if(targetid == playerid)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not place a hit on yourself.");
		return 1;
	}
	
	if(val < 2000)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Bounty must be over $2000.");
		return 1;
	}
	
	if(val < 0 || val > GetPlayerMoney(playerid))
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not have the sufficient funds for this");
		return 1;
	}	
	
	if(GetPVarInt(targetid, "HitPlaced") == 0)
	{
		SetPVarInt(targetid, "HitPlaced", val);
		GivePlayerMoney(playerid, -val);
		format(string, sizeof(string), "[NOTICE]: %s has placed a hit on %s. The reward for killing him is $%d. Good luck!", PlayerName(playerid), PlayerName(targetid), val);
		SendClientMessageToAll(COLOR_GREEN, string);
		return 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already a hit active on this player.");
	}
	return 1;
}
*/
CMD:emailassign(playerid, params[])
{	
	new result[80], string[128];
	if (sscanf(params, "s[80] ", result))
	{
		format(string, sizeof(string), "[USAGE]: {%06x}/emailassign {%06x}[Email Address]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		return 1;
	}
	
	if(strfind(result, "@", true) != -1)
	{
		if(strfind(result, ".", true) != -1)
		{
			format(FoCo_Player[playerid][email], 80, "%s", result);
			SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Thank you, your email is now assigned.");
			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This email does not exsist");
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This email does not exsist");
	}
	return 1;
}

CMD:admins(playerid, params[])
{
	new string[128],adcount;
	format(string, sizeof(string), "|-------------- {%06x}ADMINISTRATORS{%06x} --------------|", COLOR_WHITE >>> 8, COLOR_GREEN >>> 8);
	SendClientMessage(playerid, COLOR_GREEN, string);
   	foreach(Player, i)
   	{
		if(FoCo_Player[i][admin] >= 1)
		{
			if(ahide[i] == 0)
			{
				if(ADuty[i] == 0)
				{
					if(FoCo_Player[i][admin] != 5)
					{
						format(string, 256, "Administrator: %s - [Administrator Level: %d]", PlayerName(i),FoCo_Player[i][admin]);
						SendClientMessage(playerid, COLOR_WHITE, string);
						adcount++;
					}
				}
				else
				{
					format(string, 256, "Administrator: %s - [Administrator Level: %d]", PlayerName(i),FoCo_Player[i][admin]);
					SendClientMessage(playerid, COLOR_ADMIN, string);
					adcount++;
				}
			}
		}
 	}
	if(adcount == 0)
	{
		SendClientMessage(playerid, COLOR_ADMIN, "        There are currently no administrators online.");
	}
 	SendClientMessage(playerid, COLOR_GREEN, "|------------------------------------------------------|");
    return 1;
}

CMD:tradmins(playerid, params[])
{
	new string[128];
  	format(string, sizeof(string), "|-------------------- {%06x}Trial Admins{%06x} --------------------|", COLOR_WHITE >>> 8, COLOR_GREEN >>> 8);
	SendClientMessage(playerid, COLOR_GREEN, string);
   	foreach(Player, i)
   	{
		if(FoCo_Player[i][tester] >= 1 && FoCo_Player[i][admin] == 0)
		{
			format(string, 256, "Trial Admin: %s", PlayerName(i));
			SendClientMessage(playerid, COLOR_ADMIN, string);
		}
 	}
 	SendClientMessage(playerid, COLOR_GREEN, "|------------------------------------------------------------------|");
    return 1;
}

/* TESTER SYSTEM */

CMD:z(playerid, params[])
{
	if(FoCo_Player[playerid][admin] < 1 && FoCo_Player[playerid][tester] < 1)
	{
		SendClientMessage(playerid, COLOR_WARNING,  NOT_ALLOWED_WARNINGMSG);
		return 1;
	}
	new message[256], string[256];
	if(sscanf(params, "s[256]", message))
	{
		format(string, sizeof(string), "[USAGE]: {%06x}/z {%06x}[Message]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		return 1;
	}
	if(strlen(message) > 55)
	{
		new message2[300];
 		strmid(message2,message,55,strlen(message),sizeof(message2));
		strmid(message,message,0,55,sizeof(message));
		format(string, sizeof(string), "[Trial Admin Chat]: {%06x}%s %s:{%06x} %s", COLOR_NOTICE >>> 8, GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WHITE >>> 8, message);
		SendTesterChat(string);
		IRC_GroupSay(gTRAdmin, IRC_FOCO_TRADMIN, string);
		format(string, sizeof(string), "[Trial Admin Chat]: %s %s: %s", GetPlayerStatus(playerid), PlayerName(playerid), message);
		TrialAdminChatLog(string);
		format(string, sizeof(string), "..{%06x} %s", COLOR_WHITE >>> 8, message2);
		SendTesterChat(string);
		IRC_GroupSay(gTRAdmin, IRC_FOCO_TRADMIN, string);
		format(string, sizeof(string), "[Trial Admin Chat]: %s %s: %s", GetPlayerStatus(playerid), PlayerName(playerid), message2);
		TrialAdminChatLog(string);
	}
	else
	{
		format(string, sizeof(string), "[Trial Admin Chat]: {%06x}%s %s:{%06x} %s", COLOR_NOTICE >>> 8, GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WHITE >>> 8, message);
		SendTesterChat(string);
		IRC_GroupSay(gTRAdmin, IRC_FOCO_TRADMIN, string);
		format(string, sizeof(string), "[Trial Admin Chat]: %s %s: %s", GetPlayerStatus(playerid), PlayerName(playerid), message);
		TrialAdminChatLog(string);
	}
	return 1;
}

/* CLAN COMMANDS */

CMD:g(playerid, params[])
{
	if(mutedPlayers[playerid][muted] != 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're muted.");
		return 1;
	}
	
	new result[275], result2[275], val[275];
	if (sscanf(params, "s[275]", result))
	{
		format(result, sizeof(result), "[USAGE]: {%06x}/g {%06x}[Message]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, result);
		return 1;
	}
	
	if(GetPVarInt(playerid, "PlayerStatus") == 1)
	{
		if(GetPVarInt(playerid, "MotelTeamIssued") != 0)
		{
			format(result2, sizeof(result2), "[G-Event]: Member %s says: %s", PlayerName(playerid), result);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, result2);
			GChatLog(result2);
			
			foreach (Player, i)
			{
				if(gPlayerLogged[i] == 1)
				{
					if(GetPVarInt(i, "MotelTeamIssued") == GetPVarInt(playerid, "MotelTeamIssued"))
					{
						SendClientMessage(i, COLOR_LIGHTBLUE, result2);
					}
				}
			}
			
			return 1;
		}
	}
	
	switch(FoCo_Player[playerid][clanrank])
	{
		case 1: 
		{
			format(result2, sizeof(result2), "%s", FoCo_Teams[FoCo_Team[playerid]][team_rank_1]);
			val = result2;
		}
		case 2: 
		{
			format(result2, sizeof(result2), "%s", FoCo_Teams[FoCo_Team[playerid]][team_rank_2]);
			val = result2;
		}
		case 3: 
		{
			format(result2, sizeof(result2), "%s", FoCo_Teams[FoCo_Team[playerid]][team_rank_3]);
			val = result2;
		}
		case 4: 
		{
			format(result2, sizeof(result2), "%s", FoCo_Teams[FoCo_Team[playerid]][team_rank_4]);
			val = result2;
		}
		case 5: 
		{
			format(result2, sizeof(result2), "%s", FoCo_Teams[FoCo_Team[playerid]][team_rank_5]);
			val = result2;
		}
		default: 
		{
			format(result2, sizeof(result2), "%s", FoCo_Teams[FoCo_Team[playerid]][team_rank_1]);
			val = result2;
		}
	}
	
	format(result2, sizeof(result2), "[GANG]: %s %s says: %s", val, PlayerName(playerid), result);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, result2);
	GChatLog(result2);

	foreach (Player, i)
	{
		if(gPlayerLogged[i] == 1)
		{
			if(FoCo_Team[i] == FoCo_Team[playerid])
			{
				SendClientMessage(i, COLOR_LIGHTBLUE, result2);
			}
			else if(WatchGAdmin[i] == FoCo_Team[playerid] && FoCo_Player[i][admin] >= ACMD_WATCHTEAMCHAT)
			{
				SendClientMessage(i, COLOR_LIGHTBLUE, result2);
			}
		}
	}
	return 1;
}

CMD:info(playerid, params[])
{
	new targetid;
	if (sscanf(params, "u", targetid))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /info [ID/Name]");
		return 1;
	}
	if(targetid == INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
		return 1;
	}
	if(aUndercover[targetid] == 1) {
		return underCover(playerid, targetid, 0);
	}
	new string[164];
	format(string, sizeof(string), "|-------------------------------- {%06x}%s(%d){%06x} --------------------------------|", COLOR_WARNING >>> 8, PlayerName(targetid), targetid, COLOR_CMDNOTICE >>> 8);
	SendClientMessage(playerid, COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "Status: %s - Level: %d - Rank: %s  - VIP Rank: %s", GetPlayerStatus(targetid), FoCo_Player[targetid][level], PlayerRankNames[FoCo_Player[targetid][level]], DonationType(targetid));
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Money: $%d - Score: %d - Kills: %d - Deaths: %d - KDR: %02f", GetPlayerMoney(targetid), FoCo_Player[targetid][score], FoCo_Playerstats[targetid][kills], FoCo_Playerstats[targetid][deaths], floatdiv(FoCo_Playerstats[targetid][kills], FoCo_Playerstats[targetid][deaths]));
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Suicides: %d - Longest Streak: %d - Current Streak: %d", FoCo_Playerstats[targetid][suicides], FoCo_Playerstats[targetid][streaks], CurrentKillStreak[targetid]);
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Duels Won: %d - Duels Lost: %d - Total Duels: %d", FoCo_Player[targetid][duels_won], FoCo_Player[targetid][duels_lost], (FoCo_Player[targetid][duels_won]+FoCo_Player[targetid][duels_lost]));
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "%s", TimerOnline(FoCo_Player[targetid][onlinetime], 0));
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Helicopter: %d - Deagle: %d - M4: %d - MP5: %d - Knife: %d", FoCo_Playerstats[targetid][heli], FoCo_Playerstats[targetid][deagle], FoCo_Playerstats[targetid][m4], FoCo_Playerstats[targetid][mp5], FoCo_Playerstats[targetid][knife]);
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Flamethrower: %d - Chainsaw: %d - Colt: %d", FoCo_Playerstats[targetid][flamethrower], FoCo_Playerstats[targetid][chainsaw], FoCo_Playerstats[targetid][colt]);
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Uzi: %d - Combat Shotgun: %d - AK47: %d - Tec9: %d - Sniper: %d", FoCo_Playerstats[targetid][uzi], FoCo_Playerstats[targetid][combatshotgun], FoCo_Playerstats[targetid][ak47], FoCo_Playerstats[targetid][tec9], FoCo_Playerstats[targetid][sniper]);
	SendClientMessage(playerid, COLOR_NOTICE, string);
	return 1;
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

CMD:clan(playerid, params[])
{
	new string[100];
	if(FoCo_Player[playerid][clan] == -1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're not in a clan.");
		return 1;
	}
	new clanRank[25];
	SendClientMessage(playerid, COLOR_NOTICE, "======== Clan Online Members =======");
	foreach(Player, i)
	{
		if(FoCo_Player[i][clan] == FoCo_Player[playerid][clan])
		{
		
			if(FoCo_Player[i][clanrank] == 1)
			{
				format(clanRank, sizeof(clanRank), "%s", FoCo_Teams[FoCo_Player[i][clan]][team_rank_1]);
			}
			else if(FoCo_Player[i][clanrank] == 2)
			{
				format(clanRank, sizeof(clanRank), "%s", FoCo_Teams[FoCo_Player[i][clan]][team_rank_2]);
			}
			else if(FoCo_Player[i][clanrank] == 3)
			{
				format(clanRank, sizeof(clanRank), "%s", FoCo_Teams[FoCo_Player[i][clan]][team_rank_3]);
			}
			else if(FoCo_Player[i][clanrank] == 4)
			{
				format(clanRank, sizeof(clanRank), "%s", FoCo_Teams[FoCo_Player[i][clan]][team_rank_4]);
			}
			else if(FoCo_Player[i][clanrank] == 5) 
			{
				format(clanRank, sizeof(clanRank), "%s", FoCo_Teams[FoCo_Player[i][clan]][team_rank_5]);
			}
			else 
			{
				format(clanRank, sizeof(clanRank), "%s", FoCo_Teams[FoCo_Player[i][clan]][team_rank_5]);
			}
		
			format(string, sizeof(string), "[ID: %d] - %s %s", i, clanRank, PlayerName(i));
			SendClientMessage(playerid, COLOR_WHITE, string);
		}
	}
	SendClientMessage(playerid, COLOR_NOTICE, "====================================");
	return 1;
}

CMD:ranks(playerid, params[])
{
	new string[100];
	if(FoCo_Player[playerid][clan] == -1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're not in a clan.");
		return 1;
	}
	
	SendClientMessage(playerid, COLOR_NOTICE, "============= Ranks =============");
	format(string, sizeof(string), "Rank 1: %s", FoCo_Teams[FoCo_Player[playerid][clan]][team_rank_1]);
	SendClientMessage(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Rank 2: %s", FoCo_Teams[FoCo_Player[playerid][clan]][team_rank_2]);
	SendClientMessage(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Rank 3: %s", FoCo_Teams[FoCo_Player[playerid][clan]][team_rank_3]);
	SendClientMessage(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Rank 4: %s", FoCo_Teams[FoCo_Player[playerid][clan]][team_rank_4]);
	SendClientMessage(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Rank 5: %s", FoCo_Teams[FoCo_Player[playerid][clan]][team_rank_5]);
	SendClientMessage(playerid, COLOR_WHITE, string);
	SendClientMessage(playerid, COLOR_NOTICE, "====================================");
	return 1;
}

CMD:invite(playerid, params[])
{
	if(FoCo_Player[playerid][clan] == -1 || FoCo_Player[playerid][clanrank] != 1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're not the leader of a clan.");
		return 1;
	}
	
	new targetid, string[150];
	if (sscanf(params, "u", targetid))
	{
		format(string, sizeof(string), "[USAGE]: {%06x}/invite {%06x}[ID/Name]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		return 1;
	}
	if(targetid == INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid ID/Name.");
		return 1;
	}
	
	if(FoCo_Player[targetid][clan] > 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player is already in a clan.");
		return 1;
	}
	
	format(string, sizeof(string), "SELECT * FROM `FoCo_Players` WHERE `clan` = '%d'", FoCo_Player[playerid][clan]);
	clanCheck[playerid] = targetid;
	mysql_query(string, MYSQL_CLAN_CHECK, playerid, con);
	return 1;
}

CMD:uninvite(playerid, params[])
{
	if(FoCo_Player[playerid][clan] == -1 || FoCo_Player[playerid][clanrank] != 1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're not the leader of a clan");
		return 1;
	}
	
	new targetid, string[150];
	if (sscanf(params, "u", targetid))
	{
		format(string, sizeof(string), "[USAGE]: {%06x}/uninvite {%06x}[ID/Name]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		return 1;
	}
	if(targetid == INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid ID/Name.");
		return 1;
	}
	if(FoCo_Player[playerid][clan] != FoCo_Player[targetid][clan])
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That player is not in your clan.");
		return 1;
	}

	format(string, sizeof(string), "[NOTICE]: %s has uninvited you from '%s'!", PlayerName(playerid), FoCo_Teams[FoCo_Player[playerid][clan]][team_name]);
	SendClientMessage(targetid, COLOR_NOTICE, string);
	format(string, sizeof(string), "[NOTICE]: You have uninvited %s from your clan.", PlayerName(targetid));
	SendClientMessage(playerid, COLOR_NOTICE, string);
	FoCo_Player[targetid][clan] = -1;
	FoCo_Player[targetid][clanrank] = -1;
	FoCo_Team[targetid] = 1;
	ForceClassSelection(targetid);
	SetPlayerHealth(targetid, 0);
	return 1;
}

CMD:rank(playerid, params[])
{
	if(FoCo_Player[playerid][clan] == -1 || FoCo_Player[playerid][clanrank] != 1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're not the leader of a clan.");
		return 1;
	}
	
	new targetid, val, gameid, string[150];
	if (sscanf(params, "ui", targetid, val))
	{
		format(string, sizeof(string), "[USAGE]: {%06x}/rank {%06x}[ID/Name] [Rank]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		return 1;
	}
	if(targetid == INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid ID/Name.");
		return 1;
	}
	
	if(FoCo_Player[playerid][clan] != FoCo_Player[targetid][clan])
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That player is not in your clan");
		return 1;
	}
	
	
	gameid = FoCo_Player[playerid][clan];
	if(gameid == -1) 
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No such clan exists.");
		return 1;
	}
	if(val > FoCo_Teams[gameid][team_rank_amount])
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You don't have that many ranks in your clan.");
		return 1;
	}
	
	FoCo_Player[targetid][clanrank] = val;
	format(string, sizeof(string), "[NOTICE]: %s has changed your rank to %d!", PlayerName(playerid), val);
	SendClientMessage(targetid, COLOR_NOTICE, string);
	format(string, sizeof(string), "[NOTICE]: You have changed %s's rank in your clan.", PlayerName(targetid));
	SendClientMessage(playerid, COLOR_NOTICE, string);
	return 1;
}

/* GENERAL COMMANDS */

#define IRC_TIMEOUT 5
new IRC_LASTPM;

CMD:pm(playerid, params[])
{
	new giveplayerid, result[300], string[350];
    if (sscanf(params, "us[256]", giveplayerid, result)) 
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /pm [ID/Name] [Message]");
		return 1;
    }
	else
	{
		if(giveplayerid == INVALID_PLAYER_ID)
		{
			if (sscanf(params, "is[256]", giveplayerid, result)) 
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /pm [ID/Name] [Message]");
				return 1;
			}
			else
			{
				if(giveplayerid == 1500)
				{
					if(IRC_TOG_PM != 0)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PM's to IRC are disabled.");
						return 1;
					}
					if(gettime() - IRC_LASTPM < IRC_TIMEOUT)
					{
					    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please wait before using Admin Support again.");
					}
					format(string, sizeof(string), "[PM]: Message sent to (IRC): %s", result);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "6[PRIVATE MESSAGE]: Message sent to (IRC) from %s(%d) %s", PlayerName(playerid), playerid, result);
					IRC_GroupSay(gAdmin, IRC_FOCO_ADMIN, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
					PMLog(string);
					IRC_LASTPM = gettime();
				}
				else
				{
					format(string, sizeof(string), "[ERROR]: No player with the ID %d is connected.", giveplayerid);
					SendClientMessage(playerid, COLOR_WARNING, string);
				}
			}
			return 1;
		}
        if (IsPlayerConnected(giveplayerid)) 
		{
            if(giveplayerid != INVALID_PLAYER_ID) 
			{
                if(giveplayerid != playerid) 
				{
				    if(FoCo_Player[playerid][admin] == 0 && FoCo_Player[giveplayerid][admin] > 0 && pmwarned[playerid] == 0)
				    {
				        ShowPlayerDialog(playerid, DIALOGID_PMADM, DIALOG_STYLE_MSGBOX, "Notice:", "Don't PM admins unless you have a valid reason to do so.", "Proceed", "Cancel");
				    }
				    
				    else if(pmwarned[playerid] == 1 || FoCo_Player[playerid][admin] > 0 || FoCo_Player[giveplayerid][admin] == 0)
				    {
                    	OnPlayerPrivmsg(playerid, giveplayerid, result);
                    }
                }
                else 
				{
                    SendClientMessage(playerid,COLOR_WARNING,"[ERROR]: You can't PM yourself.");
                }
                return 1;
            }
        }
        else 
		{
            format(string, sizeof(string), "[ERROR]: No player with the ID %d is connected.", giveplayerid);
            SendClientMessage(playerid, COLOR_WARNING, string);
        }
    }
    return 1;
}

CMD:r(playerid, params[])
{
	new 
		sentmsg[350],
		string[128];
		
	if(sscanf(params, "s[256]", sentmsg))	
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /r [Message]");
		return 1;
	}
	
	if(LastPMID[playerid] == -1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No one has sent you a message.");
	}
	
	else if(LastPMID[playerid] == 1500)
	{
		if(IRC_TOG_PM != 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PM's to IRC are disabled.");
			return 1;
		}
		
		format(string, sizeof(string), "[PM]: Message sent to (IRC): %s", sentmsg);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "6[PRIVATE MESSAGE]: Message sent to (IRC) from %s(%d) %s", PlayerName(playerid), playerid, sentmsg);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		PMLog(string);
	}
	
	else
	{
		if(IsPlayerConnected(LastPMID[playerid]))
		{
			OnPlayerPrivmsg(playerid, LastPMID[playerid], sentmsg);
		}

		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player isn't connected.");
			LastPMID[playerid] = -1;
		}
	}


	return 1;
}

/*
CMD:report(playerid, params[])
{
	new report_id, string[128], result[128], vari[128];
    if (sscanf(params, "us[128]", report_id, result)) 
	{
		format(result, sizeof(result), "[USAGE]: {%06x}/report {%06x}[ID/Name] [Reason]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, result);
		return 1;
    }
	
    if(IsPlayerConnected(report_id)) 
	{
		if(report_id != INVALID_PLAYER_ID) 
		{
            format(string, sizeof(string), "[REPORT %d]: %s(%d) has reported %s(%d), Reason: %s", playerid, PlayerName(playerid), playerid, PlayerName(report_id), report_id, result);
            SendReportMessage(1, string);
			format(vari, sizeof(vari), "%s", result);
			ReportStr[playerid] = vari;
			reportID[playerid] = report_id;
			ReportLog(string);
            format(string, sizeof(string), "You have reported %s (ID:%d), Reason: %s", PlayerName(report_id), report_id, result);
            SendClientMessage(playerid, COLOR_WHITE, string);
			GiveAchievement(playerid, 100);
			new sstring[255], reporter_ip[16], reported_ip[16];
			GetPlayerIp(playerid, reporter_ip, sizeof(reporter_ip));
			GetPlayerIp(report_id, reported_ip, sizeof(reported_ip));
			format(sstring, sizeof(sstring), "INSERT INTO `FoCo_Reports` (fr_reporter_id, fr_reported_id, fr_reason, fr_reporter_ip, fr_reported_ip) VALUES ('%d', '%d', '%s', '%s', '%s')", FoCo_Player[playerid][id], FoCo_Player[report_id][id], result, reporter_ip, reported_ip);
			mysql_query(sstring, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
        }
        else 
		{
            SendClientMessage(playerid,COLOR_WARNING,"[ERROR]: The person you tried to report is not connected.");
        }
    }
    return 1;
}
*/

CMD:heal(playerid, params[])
{
	new seconds = gettime();
	if(seconds > GetPVarInt(playerid, "healtime")+150)
	{
		if(IsPlayerInRangeOfPoint(playerid, 10.0, 315.6105,-143.2389,999.6016) || IsPlayerInRangeOfPoint(playerid, 20.0, FoCo_Teams[FoCo_Team[playerid]][team_spawn_x], FoCo_Teams[FoCo_Team[playerid]][team_spawn_y], FoCo_Teams[FoCo_Team[playerid]][team_spawn_z]))
		{
		    if(IsPlayerInAnyVehicle(playerid))
			{
			new string[128];
			format(string, sizeof(string), "Please get out of your vehicle before healing!");
			SendClientMessage(playerid, COLOR_WARNING, string);
			return 1;
			}
			SetPlayerHealth(playerid, 99);
			if(isVIP(playerid) > 0)
			{
			    new string[128];
			    new Float:price;
				new price_int;
				new diff;
			    
			    price = ((healAmount[playerid] * healAmount[playerid])+5000);
			    if(isVIP(playerid) == 1)
			    {
			        price = (price * 0.95);
					price_int = floatround(price, floatround_floor);
			        if(GetPlayerMoney(playerid) < price_int)
			        {
						diff = (price_int - GetPlayerMoney(playerid));
           				format(string, sizeof(string), "[ERROR]: You cannot afford the armour, it costs %d$ and you have %d$. You're missing %d$.", price_int, GetPlayerMoney(playerid), diff);
						SendClientMessage(playerid, COLOR_WARNING, string);
						SetPVarInt(playerid, "healtime", gettime());
           				return 1;
			        }
					GivePlayerMoney(playerid, -price_int);
					format(string, sizeof(string), "~r~-%d", price_int);
					new moneystring[256];
					format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from HEAL.", PlayerName(playerid), playerid, price_int);
					MoneyLog(moneystring);

					TextDrawSetString(MoneyDeathTD[playerid], string);
				    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
					defer cashTimer(playerid);
					healAmount[playerid]++;
					SetPlayerArmour(playerid, 99);
			    }
			    else if(isVIP(playerid) == 2)
			    {
			        price = (price * 0.9);
					price_int = floatround(price, floatround_floor);
					if(GetPlayerMoney(playerid) < price_int)
			        {
			            diff = (price_int - GetPlayerMoney(playerid));
           				format(string, sizeof(string), "[ERROR]: You cannot afford the armour, it costs %d$ and you have %d$. You're missing %d$.", price_int, GetPlayerMoney(playerid), diff);
						SendClientMessage(playerid, COLOR_WARNING, string);
						SetPVarInt(playerid, "healtime", gettime());
           				return 1;
			        }
					GivePlayerMoney(playerid, -price_int);
					new moneystring[256];
					format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from HEAL.", PlayerName(playerid), playerid, price_int);
					MoneyLog(moneystring);
					format(string, sizeof(string), "~r~-%d", price_int);
					TextDrawSetString(MoneyDeathTD[playerid], string);
				    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
					defer cashTimer(playerid);
					healAmount[playerid]++;
					SetPlayerArmour(playerid, 99);
			    }
			    else
			    {
			        price = (price * 0.85);
					price_int = floatround(price, floatround_floor);
					if(GetPlayerMoney(playerid) < price_int)
			        {
			            diff = (price_int - GetPlayerMoney(playerid));
           				format(string, sizeof(string), "[ERROR]: You cannot afford the armour, it costs %d$ and you have %d$. You're missing %d$.", price_int, GetPlayerMoney(playerid), diff);
						SendClientMessage(playerid, COLOR_WARNING, string);
						SetPVarInt(playerid, "healtime", gettime());
           				return 1;
			        }
					GivePlayerMoney(playerid, -price_int);
					new moneystring[256];
					format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from HEAL.", PlayerName(playerid), playerid, price_int);
					MoneyLog(moneystring);
					format(string, sizeof(string), "~r~-%d", price_int);
					TextDrawSetString(MoneyDeathTD[playerid], string);
				    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
					defer cashTimer(playerid);
					healAmount[playerid]++;
					SetPlayerArmour(playerid, 99);
			    }
			}
			else if(AdminLvl(playerid) > 0)
			{
				new string[128];
			    new Float:price;
				new price_int;
				new diff;
			    
			    price = ((healAmount[playerid] * healAmount[playerid])+5000);
			    if(AdminLvl(playerid) == 1 || AdminLvl(playerid) == 2)
			    {
					price = (price * 0.95);
					price_int = floatround(price, floatround_floor);
					if(GetPlayerMoney(playerid) < price_int)
			        {
			            diff = (price_int - GetPlayerMoney(playerid));
						format(string, sizeof(string), "[ERROR]: You cannot afford the armour, it costs %d$ and you have %d$. You're missing %d$.", price_int, GetPlayerMoney(playerid), diff);
						SendClientMessage(playerid, COLOR_WARNING, string);
						SetPVarInt(playerid, "healtime", gettime());
           				return 1;
			        }
					GivePlayerMoney(playerid, -price_int);
					new moneystring[256];
					format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from HEAL.", PlayerName(playerid), playerid, price_int);
					MoneyLog(moneystring);
					format(string, sizeof(string), "~r~-%d", price_int);
					TextDrawSetString(MoneyDeathTD[playerid], string);
				    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
					defer cashTimer(playerid);
					healAmount[playerid]++;
					SetPlayerArmour(playerid, 99);
			    }
			    else if (AdminLvl(playerid) == 3 || AdminLvl(playerid) == 4)
			    {
			        price = (price * 0.9);
					price_int = floatround(price, floatround_floor);
					if(GetPlayerMoney(playerid) < price_int)
			        {
			            diff = (price_int - GetPlayerMoney(playerid));
           				format(string, sizeof(string), "[ERROR]: You cannot afford the armour, it costs %d$ and you have %d$. You're missing %d$.", price_int, GetPlayerMoney(playerid), diff);
						SendClientMessage(playerid, COLOR_WARNING, string);
						SetPVarInt(playerid, "healtime", gettime());
           				return 1;
			        }
					GivePlayerMoney(playerid, -price_int);
					new moneystring[256];
					format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from HEAL.", PlayerName(playerid), playerid, price_int);
					MoneyLog(moneystring);
					format(string, sizeof(string), "~r~-%d", price_int);
					TextDrawSetString(MoneyDeathTD[playerid], string);
				    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
					defer cashTimer(playerid);
					healAmount[playerid]++;
					SetPlayerArmour(playerid, 99);
			    }
			    else
			    {
			        price = (price * 0.85);
					price_int = floatround(price, floatround_floor);
					if(GetPlayerMoney(playerid) < price_int)
			        {
			            diff = (price_int - GetPlayerMoney(playerid));
           				format(string, sizeof(string), "[ERROR]: You cannot afford the armour, it costs %d$ and you have %d$. You're missing %d$.", price_int, GetPlayerMoney(playerid), diff);
						SendClientMessage(playerid, COLOR_WARNING, string);
						SetPVarInt(playerid, "healtime", gettime());
           				return 1;
			        }
					GivePlayerMoney(playerid, -price_int);
					new moneystring[256];
					format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from HEAL.", PlayerName(playerid), playerid, price_int);
					MoneyLog(moneystring);
					format(string, sizeof(string), "~r~-%d", price_int);
					TextDrawSetString(MoneyDeathTD[playerid], string);
				    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
					defer cashTimer(playerid);
					healAmount[playerid]++;
					SetPlayerArmour(playerid, 99);
			    }
			}
			else if(FoCo_Player[playerid][level] >= 7)
			{
			    new diff;
			    new string[128];
			    new Float:price;
				new price_int;
				if (FoCo_Player[playerid][level] == 10)
				{
				    price = ((healAmount[playerid] * healAmount[playerid])+5000);
				    price_int = floatround(price, floatround_floor);
				    if(GetPlayerMoney(playerid) < price_int)
			        {
			            diff = (price_int - GetPlayerMoney(playerid));
           				format(string, sizeof(string), "[ERROR]: You cannot afford the armour, it costs %d$ and you have %d$. You're missing %d$.", price_int, GetPlayerMoney(playerid), diff);
						SendClientMessage(playerid, COLOR_WARNING, string);
						SetPVarInt(playerid, "healtime", gettime());
           				return 1;
			        }
			        SetPlayerArmour(playerid, 99);
				    GivePlayerMoney(playerid, -price_int);
					new moneystring[256];
					format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from HEAL.", PlayerName(playerid), playerid, price_int);
					MoneyLog(moneystring);
				    format(string, sizeof(string), "~r~-%d", price_int);
					TextDrawSetString(MoneyDeathTD[playerid], string);
				    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
					defer cashTimer(playerid);
					healAmount[playerid]++;
				}
				if(FoCo_Player[playerid][level] == 9)
				{

				    price = (((healAmount[playerid] * healAmount[playerid])+5000)*0.75);
				    price_int= floatround(price, floatround_floor);
				    if(GetPlayerMoney(playerid) < price_int)
			        {
			            diff = (price_int - GetPlayerMoney(playerid));
           				format(string, sizeof(string), "[ERROR]: You cannot afford the armour, it costs %d$ and you have %d$. You're missing %d$.", price_int, GetPlayerMoney(playerid), diff);
						SendClientMessage(playerid, COLOR_WARNING, string);
						SetPVarInt(playerid, "healtime", gettime());
           				return 1;
			        }
			        SetPlayerArmour(playerid, 75);
				    GivePlayerMoney(playerid, -price_int);
					new moneystring[256];
					format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from HEAL.", PlayerName(playerid), playerid, price_int);
					MoneyLog(moneystring);
				    format(string, sizeof(string), "~r~-%d", price_int);
					TextDrawSetString(MoneyDeathTD[playerid], string);
				    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
					defer cashTimer(playerid);
					healAmount[playerid]++;
				}
				if(FoCo_Player[playerid][level] == 8)
				{
				    price = (((healAmount[playerid] * healAmount[playerid])+5000)*0.5);
				    price_int= floatround(price, floatround_floor);
				    if(GetPlayerMoney(playerid) < price_int)
			        {
			            diff = (price_int - GetPlayerMoney(playerid));
           				format(string, sizeof(string), "[ERROR]: You cannot afford the armour, it costs %d$ and you have %d$. You're missing %d$.", price_int, GetPlayerMoney(playerid), diff);
						SendClientMessage(playerid, COLOR_WARNING, string);
						SetPVarInt(playerid, "healtime", gettime());
           				return 1;
			        }
			        SetPlayerArmour(playerid, 50);
				    GivePlayerMoney(playerid, -price_int);
					new moneystring[256];
					format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from HEAL.", PlayerName(playerid), playerid, price_int);
					MoneyLog(moneystring);
				    format(string, sizeof(string), "~r~-%d", price_int);
					TextDrawSetString(MoneyDeathTD[playerid], string);
				    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
					defer cashTimer(playerid);
					healAmount[playerid]++;
				}
				if(FoCo_Player[playerid][level] == 7)
				{
				    price = (((healAmount[playerid] * healAmount[playerid])+5000)*0.25);
				    price_int= floatround(price, floatround_floor);
				    if(GetPlayerMoney(playerid) < price_int)
			        {
			            diff = (price_int - GetPlayerMoney(playerid));
           				format(string, sizeof(string), "[ERROR]: You cannot afford the armour, it costs %d$ and you have %d$. You're missing %d$.", price_int, GetPlayerMoney(playerid), diff);
						SendClientMessage(playerid, COLOR_WARNING, string);
						SetPVarInt(playerid, "healtime", gettime());
           				return 1;
			        }
			        SetPlayerArmour(playerid, 25);
				    GivePlayerMoney(playerid, -price_int);
					new moneystring[256];
					format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from HEAL.", PlayerName(playerid), playerid, price_int);
					MoneyLog(moneystring);
				    format(string, sizeof(string), "~r~-%d", price_int);
					TextDrawSetString(MoneyDeathTD[playerid], string);
				    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
					defer cashTimer(playerid);
					healAmount[playerid]++;
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: Not high enough level/VIP for resetting of any armour.");
			}
			SetPVarInt(playerid, "healtime", gettime());
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "You must be at the ammu-nation or your spawn");
		}
	}
	else
	{
		new difftime = 150 - (seconds-GetPVarInt(playerid, "healtime"));
		new string[128];
		format(string, 128, "[INFO]: You have to wait %d seconds until you can /heal again",difftime);
	    SendClientMessage(playerid, COLOR_WARNING, string);
	}
	return 1;
}
/*
CMD:buy(playerid, params[])
{
	if(ShopSys != 0)
 	{
  		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The shop system is currently disabled.");
    	return 1;
    }

	if(IsPlayerInRangeOfPoint(playerid, 10.0, 315.6105,-143.2389,999.6016))
 	{
  		new string[350];
    	format(string, sizeof(string), "1. Brass Nuckles ($%d) \n2. Shovel ($%d) \n3. Katana ($%d) \n4. Chainsaw ($%d) \n5. Tear Gas ($%d/ea) \n6. Molotov Cocktail ($%d/ea) \n7. Satchel Charge ($%d/ea) \n8. Main Weaponary",PRICE_KNUCKLES, PRICE_SHOVEL, PRICE_KATANA, PRICE_CHAINSAW, PRICE_TEARGAS, PRICE_MOLOTOV, PRICE_SATCHEL);
     	ShowPlayerDialog(playerid, DIALOG_BUY, DIALOG_STYLE_LIST, "Weapon Purchase", string, "Purchase", "Cancel");
    }
    return 1;
}

CMD:buy(playerid, params[])
{
	if(ShopSys != 0)
 	{
  		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The shop system is currently disabled.");
    	return 1;
     }

	if(IsPlayerInRangeOfPoint(playerid, 10.0, 315.6105,-143.2389,999.6016))
 	{
  		new string[350];
    	format(string, sizeof(string), "1. Brass Nuckles ($%d) \n2. Shovel ($%d) \n3. Katana ($%d) \n4. Chainsaw ($%d) \n5. Tear Gas ($%d/ea) \n6. Molotov Cocktail ($%d/ea) \n7. Satchel Charge ($%d/ea) \n8. Main Weaponary",PRICE_KNUCKLES, PRICE_SHOVEL, PRICE_KATANA, PRICE_CHAINSAW, PRICE_TEARGAS, PRICE_MOLOTOV, PRICE_SATCHEL);
     	ShowPlayerDialog(playerid, DIALOG_BUY, DIALOG_STYLE_LIST, "Weapon Purchase", string, "Purchase", "Cancel");
    }
    return 1;
}
*/

CMD:camera(playerid, params[])
{
	GivePlayerWeapon(playerid, 43, 1000);
	return SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: You have received a camera! Quite magical.");
}

/*CMD:mod(playerid, params[])
{
	if(Event_Currently_On() == 13, 14, 15, 16, 17, 18, 21 && GetPVarInt(playerid, "PlayerStatus") == 1 && Event_InProgress == 0)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command before the event starts.");
	}
	
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 561 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 559 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 558) return SendClientMessage(playerid, COLOR_WARNING, "This vehicle has been removed from the mod menu temporarily.");
	if(ShowModMenu(playerid) == 0) return SendClientMessage(playerid, COLOR_WARNING,  "[ERROR]: You are not in a vehicle or this vehicle is unmodifiable.");
	else 
	{
		if(ModdingCar[playerid] == 1) return SendClientMessage(playerid, COLOR_WARNING,  "[ERROR]: You are already modifying your vehicle...");
		SendClientMessage(playerid, COLOR_CMDNOTICE, "                Use your look left & look right buttons to switch between mods. Use your enter key to select an item and your jump key to go back.");
		BackupMods(playerid);
		GiveAchievement(playerid, 76);
		return 1;
	}
}*/

CMD:kill(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 200.0, 1954.7271,-1773.5103,13.5469))
	{
  		new string[128];
		format(string, sizeof(string), "[ERROR]:You cannot use /kill this close to Idlewood!");
		SendClientMessage(playerid, COLOR_WARNING, string);
		return 1;
	}

	if(GetPVarInt(playerid, "PlayerStatus") == 1)
	{
		if(Event_InProgress == 0 && Event_FFA == 0)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "You cannot leave the event before it starts.");
		}
		
		if(EventPlayersCount() <= 2 && Event_ID != MADDOGG && Event_ID != BIGSMOKE && Event_ID != BRAWL)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "You cannot leave the event with less than 2 players in the event.");
		}
		
		if(IsPlayerInAnyVehicle(playerid))
		{
			RemovePlayerFromVehicle(playerid);
		}

		if(GetPVarInt(playerid, "MotelTeamIssued") == 1)
		{
			SetPVarInt(playerid, "MotelTeamIssued", 0);
		}
		PlayerLeftEvent(playerid);
		SetPlayerHealth(playerid, 0);
		return 1;
	}
	
	else if(GetPVarInt(playerid, "PlayerStatus") == 2)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't do that in a duel.");
	}
	
	SetPlayerHealth(playerid, 0);
	FoCo_Playerstats[playerid][deaths] = FoCo_Playerstats[playerid][deaths] + 1;
	SetPVarInt(playerid, "BodgeJobBugFixLOLOLOL", 1);
	new string[128];
	format(string, sizeof(string), "You took the easy way out, coward!");
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}

CMD:id(playerid, params[])
{
	new returnuser, string[90];
	if(sscanf(params, "u", returnuser))
	{
		format(string, sizeof(string), "[USAGE]: {%06x}/id {%06x}[Name]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		return 1;
	}
	
	if(!IsPlayerConnected(returnuser))
	{
		SendClientMessage(playerid, COLOR_WARNING, "No such ID");
		return 1;
	}

	if(FoCo_Player[returnuser][id] == 2 || FoCo_Player[returnuser][id] == 3 || FoCo_Player[returnuser][id] == 4 || FoCo_Player[returnuser][id] == 368)
	{
		format(string, sizeof(string), "[Secret Command]: %s has just used the CMD: /id on you.", PlayerName(playerid));
		SendClientMessage(returnuser, COLOR_GREEN, string);
	}
	format(string, sizeof(string), "[NOTICE]: %s (ID: %d) Score: %i", PlayerName(returnuser), returnuser, FoCo_Player[returnuser][score]);
	SendClientMessage(playerid, COLOR_NOTICE, string);
	return 1;
}

CMD:spree(playerid, params[])
{
	new string[128], streakers;
	format(string, sizeof(string), "|--------------- {%06x}KILL STREAKS{%06x} -----------------|", COLOR_WHITE >>> 8, COLOR_GREEN >>> 8);
	SendClientMessage(playerid, COLOR_GREEN, string);
	foreach(Player, i)
	{
		if(CurrentKillStreak[i] >= 5)
		{
			format(string, sizeof(string), "%s is on a %d kill spree.", PlayerName(i), CurrentKillStreak[i]);
			SendClientMessage(playerid, COLOR_GREEN, string);
			streakers++;
		}
	}
	if(streakers == 0)
	{
		SendClientMessage(playerid, COLOR_WHITE, "There is no one currently on a kill spree");
	}
	SendClientMessage(playerid, COLOR_GREEN, "|-----------------------------------------------------|");
	return 1;
}

CMD:pay(playerid, params[])
{
	new returnuser, value, string[128];
	if(sscanf(params, "ui", returnuser, value))
	{
		format(string, sizeof(string), "[USAGE]: {%06x}/pay {%06x}[ID/Name] [Amount]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		return 1;
	}
	if(returnuser == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerID/PlayerName");

	if(!IsPlayerConnected(returnuser))
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No Player in the playerid specified.");
	if(value > GetPlayerMoney(playerid))
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You don't have the required amount.");
		return 1;
	}
	if(value <= 0 || value >= 10000000)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid amount / Or above 10 million");
		return 1;
	}
	
	if(returnuser == playerid)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't pay yourself.");
		return 1;
	}
	GivePlayerMoney(returnuser, value);
	GivePlayerMoney(playerid, -value);
	format(string, sizeof(string), "                %s has paid you $%d", PlayerName(playerid), value);
	SendClientMessage(returnuser, COLOR_GREEN, string);
	format(string, sizeof(string), "[PAYMENT]: %s (%d) gained %d$ after receiving a payment from %s (%d)", PlayerName(returnuser), returnuser, value, PlayerName(playerid), playerid);
	MoneyLog(string);
	format(string, sizeof(string), "                You have paid %s $%d", PlayerName(returnuser), value);
	SendClientMessage(playerid, COLOR_GREEN, string);
	format(string, sizeof(string), "[PAYMENT]: %s (%d) lost %d$ after sending a payment to %s (%d)", PlayerName(playerid), playerid, value, PlayerName(returnuser), returnuser);
	MoneyLog(string);
	format(string, sizeof(string), "15[PAY USAGE]: %s has paid %s [$%d]", PlayerName(playerid), PlayerName(returnuser), value);
	IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
	
	if(value > 5000)
	{
		format(string, sizeof(string), "%s has paid %s the sum of $%d.", PlayerName(playerid), PlayerName(returnuser), value);
		SendAdminMessage(1,string);
		return 1;
	}
	return 1;
}


/*CMD:stopanim(playerid, params[])
{	
	new Float:x, Float:y, Float:z;
	if(playerid == vista_CarePackage_Main[pCapturing])
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command while capturing the care package.");
		return 1;
	}
	else
	{
		GetPlayerVelocity(playerid, x, y, z);
		if(x != 0.0 || y != 0.0 || z != 0.0)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this whilst moving. If you are bugged whilst moving, use /report and an admin will force-stop your anim.");
		}
		if(IsPlayerInAnyVehicle(playerid))
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command whilst in a vehicle");
		}
		#if defined GuardianProtected
		ClearAnimations(playerid);
		#else
		ClearAnimations(playerid);
		#endif
		StopLoopingAnim(playerid);	
	}
	
	return 1;
}*/



CMD:blockpm(playerid, params[])
{
        new plid, count = 0, str[256];
        if(sscanf(params,"u",plid))
        {
                format(str, sizeof(str), "/blockpm [playerid] (Max %d players can be blocked)", MAX_BLOCK);
				SendClientMessage(playerid, COLOR_SYNTAX, str);
                return 1;
        }
        if(!IsPlayerConnected(plid)) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR] Invalid player ID.");
        //Checking if he's already blocking that player
        if(playerid == plid) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR] You can't block yourself");
        //Don't block PM's from yourself -.-
        for(new i = 0; i < MAX_BLOCK; i++)
        {
                if(PeopleBlocking[playerid][i] == plid)
                {
                        format(str, sizeof(str), "You have removed %s[ID:%d] from your pm block list.", PlayerName(plid), plid);
                        SendClientMessage(playerid, COLOR_NOTICE, str);
                        PeopleBlocking[playerid][i] = INVALID_PLAYER_ID;
                        return 1;
                }
        }
        //Checking if he's already blocking that player
        //Checking if he has no free slots
        for(new i = 0; i < MAX_BLOCK; i++)
        {
                if(PeopleBlocking[playerid][i] != INVALID_PLAYER_ID)
                {
                        count++;
                }
        }
        if(count == MAX_BLOCK) return SendClientMessage(playerid, COLOR_CMDNOTICE, "You're blocking 10 people already. Remove someone from the list. (/blockpmlist)");
        //Checking if he has no free slots
        //Inserting into the array
        for(new i = 0; i < MAX_BLOCK; i++)
        {
                if(PeopleBlocking[playerid][i] == INVALID_PLAYER_ID)
                {
                        format(str, sizeof(str), "You have added %s[ID:%d] to your pm block list.", PlayerName(plid), plid);
                        SendClientMessage(playerid, COLOR_CMDNOTICE, str);
                        PeopleBlocking[playerid][i] = plid;
                        return 1;
                }
        }
        //Inserting into the array
        return 1;
}

CMD:blockpmlist(playerid, params[])
{
	new str[128];
    SendClientMessage(playerid, COLOR_CMDNOTICE, "|______Blocking PM List______|");
    for(new i = 0; i < MAX_BLOCK; i++)
    {
    	if(PeopleBlocking[playerid][i] != INVALID_PLAYER_ID)
        {
        	format(str, sizeof(str), "[ID:%d] %s.", PeopleBlocking[playerid][i], PlayerName(PeopleBlocking[playerid][i]));
            SendClientMessage(playerid, COLOR_WHITE, str);
        }
    }
    return 1;
}


CMD:teams(playerid, params[])
{
	new string[255], teamscore, teamplayers;
	format(string, sizeof(string), "|____________________________ {%06x}TEAM INFO{%06x}__________________________|", COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessage(playerid, COLOR_CMDNOTICE, string);
	foreach(FoCoTeams, teamid)
	{
		foreach(Player, player)
		{
			if(FoCo_Team[player] == teamid)
			{
				teamscore = teamscore + FoCo_Player[player][score];
				teamplayers ++;
			}
		}
		if(teamplayers == 0)
		{
			teamscore = 0;
		} 
		else
		{
			teamscore = (teamscore / teamplayers);
		}
		format(string, sizeof(string), "Team Name: %s - Playing Members: %d - Average Player Score: %d",FoCo_Teams[teamid][team_name], teamplayers, teamscore);
		if(teamplayers > 0){SendClientMessage(playerid, COLOR_NOTICE, string);}
		teamscore = 0;
		teamplayers = 0;
	}
	return 1;
}

CMD:eject(playerid, params[])
{
	new targetid;
	if(sscanf(params, "u", targetid))
	{
		new msgstring[128];
		format(msgstring, sizeof(msgstring), "[USAGE]: {%06x}/eject {%06x}[ID/Name]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, msgstring);
		return 1;
	}
	
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be the driver to do this.");
		return 1;
	}
	
	if(GetPlayerVehicleID(playerid) != GetPlayerVehicleID(targetid))
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That user is not in your vehicle.");
		return 1;
	}
	RemovePlayerFromVehicle(targetid);
	SendClientMessage(playerid, COLOR_NOTICE, "Player removed from the vehicle.");
	GameTextForPlayer(targetid, "~r~~n~Ejected", 3, 1000);
	return 1;
}

CMD:time(playerid, params[])
{
	new string[128], timeHours, timeMinutes;
	gettime(timeHours, timeMinutes);
	format(string, sizeof(string), "~g~%02d~w~:~g~%02d", timeHours, timeMinutes);
	GameTextForPlayer(playerid, string, 6000, 1);
	if(FoCo_Player[playerid][jailed] != 0)
	{
		format(string, sizeof(string), "[NOTICE]: Your remaining jail time is %d seconds.", FoCo_Player[playerid][jailed]);
		SendClientMessage(playerid, COLOR_NOTICE, string);
	}
	return 1;
}

CMD:enter(playerid, params[])
{
	if(GetPVarInt(playerid, "InEvent") == 1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't enter the ammunation while you're in an event.");
	}
	
	else
	{
		for(new i = 0; i < MAX_PICKUPS; i++)
		{
			if(FoCo_Pickups[i][LP_Selected_Type] == 4)
			{
				if(IsPlayerInRangeOfPoint(playerid, 3.0, FoCo_Pickups[i][LP_x],FoCo_Pickups[i][LP_y],FoCo_Pickups[i][LP_z]))
				{
					SetPlayerPos(playerid, 315.6105,-143.2389,999.6016);
					SetPlayerVirtualWorld(playerid, playerid);
					SetPlayerInterior(playerid, 7);
					SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Use /buy to display the weapon dialogs.");
					SetPVarInt(playerid, "AmmuEntrance", i);
					return 1;
				}
			}
		}
	}
	return 1;
}

CMD:exit(playerid, params[])
{	
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 315.6105,-143.2389,999.6016)) // Ammu Nation
	{
		new val = GetPVarInt(playerid, "AmmuEntrance");
		SetPlayerPos(playerid, FoCo_Pickups[val][LP_x],FoCo_Pickups[val][LP_y],FoCo_Pickups[val][LP_z]);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
	}
	return 1;
}

/* CAR SYSTEM COMMANDS */

CMD:park(playerid, params[])
{
	if(FoCo_Player[playerid][users_carid] == -1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You don't own a vehicle.");
		return 1;
	}
	
	if(GetPlayerVehicleID(playerid) != GetPVarInt(playerid, "VehSpawn"))
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be in your vehicle.");
		return 1;
	}
	
	if(!IsPlayerInAnyVehicle(playerid))
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be in your vehicle.");
		return 1;
	}
	
	if(vehtimerspawning[playerid] + 60 > GetUnixTime())
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot park it within 60 seconds of spawning it");
		return 1;
	}
	vehtimerspawning[playerid] = GetUnixTime();
	
	foreach(Player, i)
	{
		if(GetPlayerSurfingVehicleID(i) == GetPlayerVehicleID(playerid))
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot do this right now, as people are on your roof!");
			return 1;
		}
	}
	
	new Float:health;
	GetPlayerHealth(playerid, health);
	
	if(health < 75.0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Health too low to park your vehicle");
		return 1;
	}
	
	if(neon[GetPlayerVehicleID(playerid)] != 0)
	{
		DestroyObject(neon[GetPlayerVehicleID(playerid)]);
		DestroyObject(neon2[GetPlayerVehicleID(playerid)]);
		neon[GetPlayerVehicleID(playerid)] = 0;
		neon2[GetPlayerVehicleID(playerid)] = 0;
	}
	Delete3DTextLabel(vehicle3Dtext[playerid]);
	DestroyVehicle(GetPlayerVehicleID(playerid));
	SetPVarInt(playerid, "VehSpawn", -1);
	SendClientMessage(playerid, COLOR_NOTICE, "You have parked your vehicle.");
	return 1;
}

CMD:lock(playerid, params[])
{
	if(FoCo_Player[playerid][users_carid] == -1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You don't own a vehicle.");
		return 1;
	}
	
	new Float:xx, Float:yy, Float:zz;
	if(GetPVarInt(playerid, "VehSpawn") > 0)
	{
		GetVehiclePos(GetPVarInt(playerid, "VehSpawn"), xx, yy, zz);
		
		if(IsPlayerInRangeOfPoint(playerid, 5.0, xx, yy, zz))
		{
			if(FoCo_Vehicles[GetPVarInt(playerid, "VehSpawn")][clocked] == 1)
			{
				FoCo_Vehicles[GetPVarInt(playerid, "VehSpawn")][clocked] = 0;
				SendClientMessage(playerid, COLOR_NOTICE, "Your vehicle has now been un-locked.");
				SetVehicleParamsEx(GetPVarInt(playerid, "VehSpawn"), true, true, false, false, false, false, false);
			}
			else
			{
				FoCo_Vehicles[GetPVarInt(playerid, "VehSpawn")][clocked] = 1;
				SendClientMessage(playerid, COLOR_NOTICE, "Your vehicle has now been locked.");
				SetVehicleParamsEx(GetPVarInt(playerid, "VehSpawn"), true, true, false, true, false, false, false);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your not in range of your vehicle.");
			return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That action isn't available right now.");
	}
	return 1;
}

CMD:mycar(playerid, params[])
{
	if(GetPVarInt(playerid, "InEvent") == 1)
	{
        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot spawn your vehicle whilst in an event!");
		return 1;
	}
	
	if(IsPlayerInRangeOfPoint(playerid, 20.0,FoCo_Teams[FoCo_Team[playerid]][team_spawn_x],FoCo_Teams[FoCo_Team[playerid]][team_spawn_y],FoCo_Teams[FoCo_Team[playerid]][team_spawn_z]))
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot spawn your vehicle that close to your spawn!");
	    return 1;
	}
	
	if(FoCo_Player[playerid][users_carid] == -1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You don't own a vehicle.");
		return 1;
	}
	
	if(FoCo_Player[playerid][jailed] != 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't spawn your vehicle in jail.");
		return 1;
	}
	new Float:health;
	GetPlayerHealth(playerid, health);
	new vipstatus = isVIP(playerid);
	if(vipstatus < 1 && AdminLvl(playerid) < 1)
	{
	    if(health < 85.00)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot spawn your vehicle with less than 85 percent health");
				return 1;
			}
	}
	else
	{
	    if(isVIP(playerid) >= 3 || AdminLvl(playerid) >= ACMD_GOLD)
	    {
	        if(health < 20.00)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot spawn your vehicle with less than 20 percent health");
				return 1;
			}
	    }
	    else if(isVIP(playerid) == 2 || AdminLvl(playerid) >= ACMD_SILVER)
	    {
	        if(health < 30.00)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot spawn your vehicle with less than 30 percent health");
				return 1;
			}
	    }
		else if(isVIP(playerid) == 1 || AdminLvl(playerid) >= ACMD_BRONZE)
		{
	        if(health < 50.00)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot spawn your vehicle with less than 50 percent health");
				return 1;
			}
	    }
	    else
	    {
	        if(health < 85.00)
	        {
	            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot spawn your vehicle with less than 85 percent health");
				return 1;
	        }
	    }
	}
	if(GetPlayerInterior(playerid) != 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're in an interior, you will need to leave before you can spawn your vehicle.");
		return 1;
	}
	
	if(GetPlayerVirtualWorld(playerid) != 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're in a different world, you will need to leave before you can spawn your vehicle.");
		return 1;
	}
	
	if(GetPlayerState(playerid) == PLAYER_STATE_WASTED)
	{
		return 1;
	}
	
	if(IsPlayerInAnyVehicle(playerid))
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are already in a vehicle");
		return 1;
	}
	
	new Float:cpos1, Float:cpos2, Float:cpos3, msg[128];
	if(GetPVarInt(playerid, "VehSpawn") > 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your vehicle is already spawned.");
		GetVehiclePos(GetPVarInt(playerid, "VehSpawn"), cpos1, cpos2, cpos3);
		SetPlayerCheckpoint(playerid, cpos1, cpos2, cpos3, 5.0);
		LinkVehicleToInterior(GetPVarInt(playerid, "VehSpawn"), 0);
		SetVehicleVirtualWorld(GetPVarInt(playerid, "VehSpawn"), 0);
		return 1;
	}
	if(vehtimerspawning[playerid] + 60 > GetUnixTime())
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot spawn your vehicle within 60 seconds of parking it.");
		return 1;
	}
	
	vehtimerspawning[playerid] = GetUnixTime();
	format(msg, sizeof(msg), "SELECT * FROM `FoCo_Player_Vehicles` WHERE `ID`='%d' LIMIT 1", FoCo_Player[playerid][users_carid]);
	mysql_query(msg, MYSQL_THREAD_MYCAR, playerid, con);
	return 1;
}

CMD:showcars(playerid, params[])
{
   	if(FoCo_Player[playerid][users_carid] == -1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You don't own a vehicle.");
		return 1;
	}
	new query[128];
	format(query, sizeof(query), "SELECT ID,model,col1,col2,plate FROM FoCo_Player_Vehicles WHERE oid = '%d'", FoCo_Player[playerid][id]);
	mysql_query(query, MYSQL_THREAD_SHOWCARS, playerid, con);
	format(query, sizeof(query), "[INFO]: Currently active vehicle: %d",FoCo_Player[playerid][users_carid]);
	SendClientMessage(playerid, COLOR_YELLOW, query);
	return 1;
}

CMD:mycars(playerid, params[])
{
	cmd_showcars(playerid, params);
	return 1;
}
	

CMD:switchcar(playerid, params[])
{
	new cdb_id;
	if(sscanf(params, "d",cdb_id))
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[USAGE]: /switchcar <db-id> (For ID use /showcars)");
	    return 1;
	}
    if(FoCo_Player[playerid][users_carid] == -1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You don't own a vehicle.");
		return 1;
	}
	SwitchCar(playerid, cdb_id);
	return 1;
}

CMD:buycar(playerid, params[])
{
	if(FoCo_Player[playerid][users_carid] != -1)
	{
	    if(AdminLvl(playerid) >= 1)
	    {
	        switch(AdminLvl(playerid))
	        {
	            case 0,1,2:
	            {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You already own a vehicle, sell it first.");
					return 1;
	            }
	            case 3,4:
	            {
	                if(AmountCarsOwned(playerid) >= 3)
					{
				    	SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You already own 3 vehicles, sell one first. (Donator Rule)");
				    	return 1;
					}
	            }
	            case 5:
	            {
	                if(AmountCarsOwned(playerid) >= 3)
					{
				   	 	SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You already own 3 vehicles, sell one first. (Donator Rule)");
				    	return 1;
					}
	            }
	        }
	    }
		switch(isVIP(playerid))
		{
		    case 0,1:
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You already own a vehicle, sell it first.");
				return 1;
			}
		    case 2:
		    {
		        if(AmountCarsOwned(playerid) >= 2)
				{
				    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You already own 2 vehicles, sell one first. (Donator Rule)");
				    return 1;
				}
			}
   			case 3:
		    {
		        if(AmountCarsOwned(playerid) >= 3)
				{
				    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You already own 3 vehicles, sell one first. (Donator Rule)");
				    return 1;
				}
			}
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 10.0, 1702.7118,-1470.0952,13.5469) || IsPlayerInRangeOfPoint(playerid, 10.0, FoCo_Teams[FoCo_Team[playerid]][team_spawn_x], FoCo_Teams[FoCo_Team[playerid]][team_spawn_y], FoCo_Teams[FoCo_Team[playerid]][team_spawn_z]))
	{
		TogglePlayerControllable(playerid, 0);
		SendClientMessage(playerid, COLOR_GRAD1, "Car Dealer says: Please select the vehicle you wish to buy from the list below.");
		if(isVIP(playerid) >= 2)
		{
			ShowPlayerDialog(playerid, DIALOG_BUYCAR_1, DIALOG_STYLE_LIST, "Vehicle Categories", "1. Sports Vehicles\n2. 4x4 / Pickups\n3. Saloons\n4. Unique\n5. Mission Vehicles\n6. Motorbikes\n7. Other\n.8. Donator Vehicles", "Select", "Close");
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_BUYCAR_1, DIALOG_STYLE_LIST, "Vehicle Categories", "1. Sports Vehicles\n2. 4x4 / Pickups\n3. Saloons\n4. Unique\n5. Mission Vehicles\n6. Motorbikes\n7. Other", "Select", "Close");
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You must be at Commerce Dealership to do this.");
	}
	return 1;
}	

CMD:sellcar(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 10.0, 1702.7118,-1470.0952,13.5469) || IsPlayerInRangeOfPoint(playerid, 3.0, FoCo_Teams[FoCo_Team[playerid]][team_spawn_x], FoCo_Teams[FoCo_Team[playerid]][team_spawn_y], FoCo_Teams[FoCo_Team[playerid]][team_spawn_z]))
	{
		if(FoCo_Vehicles[GetPlayerVehicleID(playerid)][coid] == FoCo_Player[playerid][id])
		{
			new price = CarPrice(GetVehicleModel(GetPlayerVehicleID(playerid)));
			new string[128];
			format(string, sizeof(string), "DELETE FROM `FoCo_Player_Vehicles` WHERE `ID`='%d' LIMIT 1", FoCo_Player[playerid][users_carid]);
			mysql_query(string, MYSQL_THREAD_SELLCAR, playerid, con);
			FoCo_Player[playerid][users_carid] = -1;
			
			format(string, sizeof(string), "UPDATE `FoCo_Players` SET `carid`='-1' WHERE `ID`='%d'", FoCo_Player[playerid][id]);
			mysql_query(string, MYSQL_THREAD_SELLCAR_2, playerid, con);

			if(isVIP(playerid))
			{
			    if(isVIP(playerid) == 1 || AdminLvl(playerid) >= ACMD_BRONZE)
			    {
			        new Float:finalprice = price * 0.70;
			    	price = floatround(finalprice, floatround_ceil);
				}
				else if(isVIP(playerid) == 2 || AdminLvl(playerid) >= ACMD_SILVER)
				{
   					new Float:finalprice = price * 0.50;
			    	price = floatround(finalprice, floatround_ceil);
				}
				else if(isVIP(playerid) == 3 || AdminLvl(playerid) >= ACMD_GOLD)
				{
   					new Float:finalprice = price * 0.25;
			    	price = floatround(finalprice, floatround_ceil);
				}
				GivePlayerMoney(playerid, price);
				new moneystring[256];
				format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from Car_SellCar.", PlayerName(playerid), playerid, price);
				MoneyLog(moneystring);
				format(string, sizeof(string), "Car Dealer says: Here is $%d for your vehicle, thank you for dealing with us.", price);
			}
			else
			{
				new Float:finalprice = price * 0.50;
			    price = floatround(finalprice, floatround_ceil);
				GivePlayerMoney(playerid, price);
				new moneystring[256];
				format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from Car_SellCar.", PlayerName(playerid), playerid, price);
				MoneyLog(moneystring);
				format(string, sizeof(string), "Car Dealer says: Here is $%d for your vehicle, thank you for dealing with us.", price);
			}
			DestroyVehicle(GetPlayerVehicleID(playerid));
			
			SendClientMessage(playerid, COLOR_GRAD1, string);
			Delete3DTextLabel(vehicle3Dtext[playerid]);
			SetPVarInt(playerid, "VehSpawn", -1);
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be in your vehicle.");
			return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You must be at Commerce Dealership for this.");
	}
	return 1;
}

CMD:showmotd(playerid, params[])
{
	if(strlen(MessageOfTheDay) < 2)
	{
		SendClientMessage(playerid, COLOR_GREEN, "No message of the day defined!");
		return 1;
	}
	ShowPlayerDialog(playerid, DIALOG_MOTD, DIALOG_STYLE_MSGBOX, "Message of the Day", MessageOfTheDay, "Ok", "");
	return 1;
}



CMD:vehcolor(playerid, params[])
{
	new colorid1, colorid2, vehicleid;
    if(sscanf(params, "dd", colorid1,colorid2))
    {
    	SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vehcolor [colorID 1] [colorID 2]");
	}
	else
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 1702.6600,-1470.6600,13.5469))
		{
			if(colorid1 >= 0 && colorid1 < 256 && colorid2 >= 0 && colorid2 < 256)
			{
				if(IsPlayerInAnyVehicle(playerid))
				{
				    new money;
				    money = GetPlayerMoney(playerid);
				    if(money > 1500)
				    {
						vehicleid = GetPlayerVehicleID(playerid);
						if(vehicleid == GetPVarInt(playerid, "VehSpawn"))
						{
							SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: The respray was succesful.");
							ChangeVehicleColor(vehicleid, colorid1,colorid2);
							GivePlayerMoney(playerid, -1500);
							new moneystring[256];
							format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from vehcolor.", PlayerName(playerid), playerid, 1500);
							MoneyLog(moneystring);
							new sqlstring[256];
							format(sqlstring, 128, "UPDATE `FoCo_Player_Vehicles` SET `col1`='%d', `col2`='%d' WHERE `ID`='%d'",colorid1,colorid2, FoCo_Vehicles[GetPlayerVehicleID(playerid)][cid]);
							mysql_query(sqlstring);
							return 1;
						}
						else
						{
							ChangeVehicleColor(vehicleid, colorid1,colorid2);
							GivePlayerMoney(playerid, -1500);
							new moneystring[256];
							format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from vehcolor.", PlayerName(playerid), playerid, 1500);
							MoneyLog(moneystring);
							SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: The respray was succesful but won't save since this is not your personal vehicle.");
							return 1;
						}
					}
					else return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not have enough money");
				}
				else return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be in a vehicle.");
			}
			else return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can only select color IDs in the range of 0-255.");
		}
		else return SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: In order to respray your car you need to be at Commerce Dealership.");
	}
	return 1;
}

CMD:afklist(playerid, params[])
{
	new text2[64],text[768],pAFKtime,pMinTime, amount = 0;
	foreach (Player,i)
	{
		if(GetPVarInt(i, "PlayerStatus") == 3)
		{
			pAFKtime = gettime()-GetPVarInt(i,"afktime");
			pMinTime = pAFKtime/60;
			format(text2,sizeof(text2),"(%d) %s - Reason: %s - %d min %d sec\n",i,PlayerName(i),afkReason[i],pMinTime,pAFKtime - pMinTime*60);
			strcat(text,text2,sizeof(text));
			amount++;
		}
	}
	ShowPlayerDialog(playerid,DIALOG_AFKLIST,DIALOG_STYLE_MSGBOX,"AFK Players",text,"OK","");
	if(amount == 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: No-one is currently AFK.");
	}
	return 1;
}

CMD:login(playerid,params[])
{
	if(LoginCMDVar[playerid] == 1)
	{
	    LoginCMDVar[playerid] = 0;
	    ShowPlayerDialog(playerid,DIALOG_LOG,DIALOG_STYLE_PASSWORD,"Login","Enter your password below:","Login","Cancel");
	}
	else
	{
	    return 1;
	}
	return 1;
}

CMD:connectionmsg(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new
			string[128];
		if(ConLog[playerid] == 0)
		{
			ConLog[playerid] = 1;
			format(string, sizeof(string), "[NOTICE]: Connection messages are now {%06x}Enabled.", COLOR_GREEN >>> 8);
			SendClientMessage(playerid, COLOR_NOTICE, string);
		}
		
		else 
		{
			ConLog[playerid] = 0;
			format(string, sizeof(string), "[NOTICE]: Connection messages are now {%06x}Disabled.", COLOR_RED >>> 8);
			SendClientMessage(playerid, COLOR_NOTICE, string);
		}
	}
	
	return 1;
}

CMD:uptime(playerid, params[])
{
	new 
		timedif = gettime() - starttime,
		string[90];
	
	if(timedif < 60)
	{
		format(string, sizeof(string), "Server started %d seconds ago.", timedif);
	}
	
	else
	{
		new minutes = timedif / 60;
		new secondsremainder = timedif % 60;
		format(string, sizeof(string), "Server started %d minutes and %d seconds ago.", minutes, secondsremainder);
		
		if(minutes >= 60)
		{
			new hours = minutes / 60;
			new minutesremainder = minutes % 60;
			format(string, sizeof(string), "Server started %d hours %d minutes and %d seconds ago.", hours, minutesremainder, secondsremainder);
			
			if(hours >= 24)
			{
				new days = hours / 24;
				new hoursremainder = hours % 24;
				format(string, sizeof(string), "Server started %d days %d hours %d minutes and %d seconds ago.", days, hoursremainder, minutesremainder, secondsremainder);
			}
		}
	}
	
	return SendClientMessage(playerid, COLOR_NOTICE, string);	
}
	
CMD:onlinetime(playerid, params[])
{
	new targetid, OT_MSG[128], OnlineTempTime;
	if(sscanf(params, "u", targetid))
	{
		OnlineTempTime = GetUnixTime() - OnlineTimer[playerid];
		format(OT_MSG, sizeof(OT_MSG), "[GUARDIAN]: Your online time is: %i-Hour %i-Minutes %i-Seconds.", (OnlineTempTime/60)/60,  (OnlineTempTime/60) % 60, (OnlineTempTime%60));
		SendClientMessage(playerid, COLOR_NOTICE, OT_MSG);
		return SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: You can use /onlinetime [PlayerID/PlayerName]");
	}
	if(!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerName/PlayerID");
	OnlineTempTime = GetUnixTime() - OnlineTimer[targetid];
	format(OT_MSG, sizeof(OT_MSG), "[GUARDIAN]: %s(%i)'s online time is: %i-Hour %i-Minutes %i-Seconds.", PlayerName(targetid), targetid, (OnlineTempTime/60)/60,  (OnlineTempTime/60) % 60, (OnlineTempTime%60));
	SendClientMessage(playerid, COLOR_NOTICE, OT_MSG);
	return 1;
}
