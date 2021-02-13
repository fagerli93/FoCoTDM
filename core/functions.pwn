#if !defined MAIN_INIT
#error "Compiling from wrong script. (foco.pwn)"
#endif

/* SHIFTED TO ANOTHER FILE forwards.pwn...
forward SendAdminMessage(minrank, message[]);
forward SendTesterChat(message[]);
//forward OneSecondTimer();
//forward OneMinuteTimer();

forward OnPlayerLoggin(playerid, password[]); //Renamed due to y_XXX YSI System already bringing a OnPlayerLogin function !
forward OnPlayerRegister(playerid, password[]);

forward GiveAchievement(playerid, achieveid);
forward UpdateAchievementStatus(playerid, ach_id, value);
forward ModInteruptSave(playerid);
forward ShowModMenu(playerid);
forward IsVehicleModified(vehicleid);
forward BackupMods(playerid);
forward ExitModMenu(playerid);
forward TenMinuteTimer();
forward AdminsOnline();
forward PlayersOnline();
forward PublicTeams();
forward SendTesterMessage(message[]);
forward ResetStats(playerid);
forward LoadTeleports();
forward OnPlayerPrivmsg(playerid, recieverid, text[]);
forward OnPlayerIRCPrivmsg(user[], recieverid, text[]);
forward SaveTeam(team_use_ID);
forward SaveTeleport(valtp_id);
forward CreatePingHovers(playerid);
forward DestroyPingHovers(playerid);
forward UpdatePingHovers(playerid);
forward CreateAdminHover(playerid);
forward UpdateAdminHover(playerid);
forward DestroyAdminHover(playerid);
forward SetTempSkin (playerid); // BEANZ - Blame me if it don't work.
forward ShowPlayerTreeDialog(playerid, style, command[], params[], caption[], info[], button1[], button2[]);
forward IsAdmin(playerid, alevel);
forward AdminLvl(playerid);
forward IsTrialAdmin(playerid);
forward KickPlayer(playerid);
forward KillStreakMessage(playerid, killerid);
forward IRC_Death_Messages(playerid, killerid, reason);
forward SetAFK(playerid);
forward Death_Streak_Reward(playerid);
forward Convert_Wpn_To_PickupID(weapon_id);
forward TAdminsOnline();

forward AJailPlayer(playerid, targetid, reason[], time);
forward AWarnPlayer(playerid, targetid, reason[]);
forward AKickPlayer(playerid, targetid, reason[]);
forward ABanPlayer(playerid, targetid, reason[]);
forward ATempBanPlayer(playerid, targetid, reason[], days);
forward AntiCheatMessage(message[]);
forward DebugMsg(message[]);

forward SendErrorMessage(playerid, message[]);
forward IsPlayerLoggedIn(playerid);

forward SendClanMessage(cclan, color, message[]);

forward GetTeamSkin(cclan, rank);
forward GetPlayerClan(playerid);
forward GetPlayerClanRank(playerid);

forward IsDev(playerid, dev_level);
*/

/* Create a random string, default size of 10 chars*/
#define MAX_WORD_SIZE 128
new const allowed_letter_string[63] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
 
stock randomString(wordsize)
{
    new OutputWord[MAX_WORD_SIZE];
    for(new i = 0; i < wordsize; i++)
    {
        OutputWord[i] = allowed_letter_string[random(sizeof(allowed_letter_string))];
    }
    return OutputWord;
}
stock SendAdminMessageToArray(Array[], ArraySize, ArrayMSG[], AdmnLvl)
{
   for(new i = 0; i<ArraySize; i++)
   {
      if(Array[i] != -1)
      {
         if(AdminLvl(Array[i]) >= AdmnLvl)
         {
            SendClientMessage(Array[i], COLOR_YELLOW, ArrayMSG);
         }
      }
   }
   return 1;
}

stock GetEmptySlot(Array[], ArraySize, Empty_Value)
{
   for(new i = 0; i < ArraySize; i++)
   {
      if(Array[i] == Empty_Value)
         return i;
   }
   return -1;
}

stock FindValueInArray(value, Array[], ArraySize)
{
   for(new i = 0; i < ArraySize; i++)
   {
      if(Array[i] == value)
         return i;
   }
   return -1;
}

stock IsArrayEmpty(Array[], ArraySize, Empty_Value)
{
   new flag=0;
   for(new i = 0; i < ArraySize; i++)
   {
      if(Array[i] != Empty_Value)
         flag++;
   }
   return flag;
}

public SendErrorMessage(playerid, message[])
{
	new string[256];
	format(string, sizeof(string), "[ERROR]: %s", message);
	SendClientMessage(playerid, COLOR_WARNING, string);
	return 1;
}

/*public IsDev(playerid, dev_level)
{
	if(FoCo_Player[playerid][dev] >= dev_level)
	{
		return 1;
	}
	else
	{
		return -1;
	}
}*/

public GetTeamSkin(cclan, rank)
{
	switch(rank)
	{
		case 1:
		{
			return FoCo_Teams[cclan][team_skin_1];
		}
		case 2:
		{
			return FoCo_Teams[cclan][team_skin_2];
		}
		case 3:
		{	
			return FoCo_Teams[cclan][team_skin_3];
		}
		case 4:
		{
			return FoCo_Teams[cclan][team_skin_4];
		}
		case 5:
		{
			return FoCo_Teams[cclan][team_skin_5];
		}
		default: 
		{
			return -1;
		}
	}
	return -1;
}

stock GetTeamRankName(ccclan, rank)
{
	new string[20];
	switch(rank)
	{
		case 1:
		{
			format(string, sizeof(string), "%s", FoCo_Team[ccclan][team_rank_1]);
			return string;
		}
		case 2:
		{
			rformat(string, sizeof(string), "%s", FoCo_Team[ccclan][team_rank_2]);
			return string;
		}
		case 3:
		{	
			format(string, sizeof(string), "%s", FoCo_Team[ccclan][team_rank_3]);
			return string;
		}
		case 4:
		{
			format(string, sizeof(string), "%s", FoCo_Team[ccclan][team_rank_4]);
			return string;
		}
		case 5:
		{
			format(string, sizeof(string), "%s", FoCo_Team[ccclan][team_rank_5]);
			return string;
		}
		default 
		{
			format(string, sizeof(string), "None");
			return string;
		}
	}
}

public GetPlayerClan(playerid)
{
	return FoCo_Player[playerid][clan];
}

stock GetTeamName(team)
{
	new string[50];
	if(team == -1)
	{
		format(string, sizeof(string), "None");
		return string;
	}
	format(string, sizeof(string), "%s", FoCo_Teams[team][team_name]);
	return string;
}


public GetPlayerClanRank(playerid)
{
	return FoCo_Player[playerid][clanrank];
}

public IsPlayerLoggedIn(playerid)
{
	return gPlayerLogged[playerid];
}


public SendClanMessage(cclan, color, message[])
{
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, message);
	GChatLog(message);
	for(new i = 0; i < GetPlayerPoolSize(); i++)
	{
		if(gPlayerLogged[i] == 1)
		{
			if(FoCo_Player[i][clan] == cclan)
			{
				SendClientMessage(i, color, message);
			}
			else if(WatchGAdmin[i] == FoCo_Team[cclan] && FoCo_Player[i][admin] >= ACMD_WATCHTEAMCHAT)
			{
				SendClientMessage(i, color, message);
			}	
		}
	}
	return 1;
}

public DebugMsg(message[])
{
	#if defined PTS
	new string[256];
	format(string, sizeof(string), "[DEBUG]: %s", message);
	SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
	#endif
	return 1;
}

// -1 for money, -2 for health, -3 for armour,
public Convert_Wpn_To_PickupID(weapon_id)
{
	new pickup_id;
	switch(weapon_id)
	{
		case -1: pickup_id = 1212;
		case -2: pickup_id = 1240;
		case -3: pickup_id = 1242;
		case 1: pickup_id = 331;
		case 2: pickup_id = 333;
		case 3: pickup_id = 334;
		case 4: pickup_id = 335;
		case 5: pickup_id = 336;
		case 6: pickup_id = 337;
		case 7: pickup_id = 338;
		case 8: pickup_id = 339;
		case 9: pickup_id = 341;
		case 10: pickup_id = 321;
		case 11: pickup_id = 322;
		case 12: pickup_id = 323;
		case 13: pickup_id = 323;
		case 14: pickup_id = 325;
		case 15: pickup_id = 326;
		case 16: pickup_id = 342;
		case 17: pickup_id = 343;
		case 18: pickup_id = 344;
		case 22: pickup_id = 346;
		case 23: pickup_id = 347;
		case 24: pickup_id = 348;
		case 25: pickup_id = 349;
		case 26: pickup_id = 350;
		case 27: pickup_id = 351;
		case 28: pickup_id = 352;
		case 29: pickup_id = 353;
		case 30: pickup_id = 355;
		case 31: pickup_id = 356;
		case 32: pickup_id = 372;
		case 33: pickup_id = 357;
		case 34: pickup_id = 358;
		case 35: pickup_id = 359;
		case 36: pickup_id = 360;
		case 37: pickup_id = 361;
		case 38: pickup_id = 362;
		case 39: pickup_id = 363;
		case 40: pickup_id = 364;
		case 41: pickup_id = 365;
		case 42: pickup_id = 366;
		case 43: pickup_id = 367;
		case 44: pickup_id = 368;
		case 45: pickup_id = 369;
		case 46: pickup_id = 371;
		default: pickup_id = 1254;		// Single scull if somehow the input is wrong, to avoid crashing (Y)
	}
	return pickup_id;
}

public AntiCheatMessage(message[])
{
	if(strlen(message) < 2)
	{
		return 1;
	}
	new string[256];
	format(string, sizeof(string), "6[AntiCheat]: %s", message);
	IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
	format(string, sizeof(string), "[AntiCheat]: {%06x}%s",COLOR_RED >>> 8, message);
	CheatLog(string);
	return SendAdminMessage(1, string);
}


public AJailPlayer(playerid, targetid, reason[], time, arecord)
{
	if(playerid == -1)	// If guardian ban
	{
		if(targetid == INVALID_PLAYER_ID)
		{
			return 1;
		}
		if(GetPVarInt(targetid, "PlayerStatus") == 1 && Event_InProgress != -1)
		{
			if(IsPlayerInAnyVehicle(targetid))
			{
				RemovePlayerFromVehicle(targetid);
			}

			if(GetPVarInt(targetid, "MotelTeamIssued") == 1)
			{
				SetPVarInt(targetid, "MotelTeamIssued", 0);
			}

			PlayerLeftEvent(targetid);
			event_SpawnPlayer(targetid);
			SetPlayerVirtualWorld(targetid, 0);
			SetPlayerInterior(targetid, 0);
		}
		new string[256];
		format(string, sizeof(string), "AdmCmd(%d): The Guardian has jailed %s(%d) for %d min, Reason: %s",ACMD_JAIL, PlayerName(targetid), targetid, time, reason);
		SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
		AdminLog(string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		FoCo_Player[targetid][jailed] = time*60;
		SetPlayerPos(targetid, 154.1683,-1952.1167,47.8750);
		SetPlayerVirtualWorld(targetid, targetid);
		format(string, sizeof(string), "JAIL: The Guardian jailed %s (%d) for %d mins, Reason: %s", PlayerName(targetid), targetid, time, reason);
		AdminLog(string);
		TogglePlayerControllable(targetid, 1);
		ResetPlayerWeapons(targetid);
		mysql_real_escape_string(reason, reason);
		if(arecord) {
			format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', 'The Guardian', '1', '%s', '%s','%s')", FoCo_Player[targetid][id], reason, TimeStamp());
			mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, targetid, con);
		}
		
		return 1;
	}
	else
	{
		new string[256];
		format(string, sizeof(string), "%d %s %d", targetid, reason, time);
		cmd_jail(playerid, string);
		return 1;
	}
}

public AWarnPlayer(playerid, targetid, reason[], arecord)
{
	if(playerid == -1)
	{
		if(targetid == INVALID_PLAYER_ID)
		{
			return 1;
		}
		new string[256];
		format(string, sizeof(string), "AdmCmd(%d): The Guardian has warned %s (%d) for %s",ACMD_WARN, PlayerName(targetid), targetid, reason);
		SendClientMessageToAll(COLOR_RED, string);
		AdminLog(string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		mysql_real_escape_string(reason, reason);
		if(arecord) {
			format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', 'The Guardian', '5', '%s', '%s')", FoCo_Player[targetid][id], PlayerName(playerid), reason, TimeStamp());
			mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, targetid, con);
			FoCo_Player[targetid][warns]++; //To Fix Double Warn for UCP-LiveUpdate
		}
		DataSave(targetid);
		switch(FoCo_Player[targetid][warns])
		{
		    case 3:
			{
				format(string, sizeof(string), "Auto-Ajail for 3rd warning (%s)", reason);
				AJailPlayer(-1, targetid, string, 5, 1);
			}
			case 5:
			{
				format(string, sizeof(string), "Auto-Ajail for 5th warning (%s)", reason);
				AJailPlayer(-1, targetid, string, 10, 1);
			}
			case 7:
			{
				format(string, sizeof(string), "Auto-Ajail for 7th warning (%s)", reason);
				AJailPlayer(-1, targetid, string, 15, 1);
			}
			case 10:
			{
				format(string, sizeof(string), "Auto-Tempban for 10th warning (%s)", reason);
				ATempBanPlayer(-1, targetid, string, 1, 1);
			}
			case 15:
			{
				format(string, sizeof(string), "Auto-Tempban for 15th warning (%s)", reason);
				ATempBanPlayer(-1, targetid, string, 5, 1);
			}
			case 20..100:
			{
				format(string, sizeof(string), "Auto-Ban for %d warnings (%s)", FoCo_Player[targetid][warns], reason);
				ABanPlayer(-1, targetid, string, 1);
			}
		}
		return 1;
	}
	else
	{
		new string[256];
		format(string, sizeof(string), "%d %s", targetid, reason);
		cmd_warn(playerid, string);
		return 1;
	}
}

public AKickPlayer(playerid, targetid, reason[], arecord)
{
	if(playerid == -1)
	{
		if(targetid == INVALID_PLAYER_ID)
		{
			return 1;
		}
		new string[256];
		format(string, sizeof(string), "AdmCmd(%d): The Guardian has kicked %s(%d), Reason: %s", ACMD_KICK, PlayerName(targetid), targetid, reason);
		AdminLog(string);
		SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		mysql_real_escape_string(reason, reason);
		if(arecord) {
			format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', 'The Guardian', '2', '%s', '%s')", FoCo_Player[targetid][id], reason, TimeStamp());
			mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, targetid, con);
		}
		SetTimerEx("KickPlayer", 1000, false, "d", targetid);
		return 1;
	}
	else
	{
		new string[256];
		format(string, sizeof(string), "%d %s", targetid, reason);
		cmd_kick(playerid, string);
		return 1;
	}
}

public ATempBanPlayer(playerid, targetid, reason[], days, arecord)
{
	if(playerid == -1)
	{
		if(targetid == INVALID_PLAYER_ID)
		{
			return 1;
		}
		new string[256];
		format(string, sizeof(string), "[AdmCMD]: The Guardian has banned %s(%d) for %d days, Reason: %s", PlayerName(targetid), targetid, days, reason);
		SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
		SendClientMessage(targetid, COLOR_NOTICE, "If you find this ban wrongful you can appeal at: forum.focotdm.com");
		AdminLog(string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		mysql_real_escape_string(reason, reason);
		if(arecord) {
			format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`, `time`) VALUES ('%d', 'The Guardian', '3', '[Tempban - %d days]: %s', '%s','%d')", FoCo_Player[targetid][id], days, reason, TimeStamp(),days);
			mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
		}
		
		FoCo_Player[targetid][tempban] = gettime()+(days*86400);
		Kick(targetid);
		return 1;
	}
	else
	{
		new string[256];
		format(string, sizeof(string), "%d %s", targetid, reason);
		cmd_tempban(playerid, string);
		return 1;
	}
}

public ABanPlayer(playerid, targetid, reason[])
{
	if(playerid == -1)
	{
		if(targetid == INVALID_PLAYER_ID)
		{
			return 1;
		}
		BanPlayer(playerid, targetid, reason, 1);
		return 1;
	}
	else
	{
		new string[256];
		format(string, sizeof(string), "%d %s", targetid, reason);
		cmd_ban(playerid, string);
		return 1;	
	}
}

//SSCANF_Option(MATCH_NAME_PARTIAL, 1);
//SSCANF_Option(CELLMIN_ON_MATCHES, 1);

public SetTempSkin (playerid)
{
	if(GetPVarInt(playerid, "TempSkin") != 0)
	{
		SetPlayerSkin(playerid, GetPVarInt(playerid, "TempSkin"));
		SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You have a custom skin, it has therefore been restored.");
	}
	return 1;
}

public KillStreakMessage(playerid, killerid)
{
    new killstreak[128], Float:health, Float:armour;
	CurrentKillStreak[killerid] ++;
	if(CurrentKillStreak[killerid] > FoCo_Playerstats[killerid][streaks])
	{
		FoCo_Playerstats[killerid][streaks] = CurrentKillStreak[killerid];
	}

	//KILL STREAK ACHIEVEMENTS
	if(CurrentKillStreak[killerid] >= 5)
	{

		GetPlayerHealth(killerid, health);
		GetPlayerArmour(killerid, armour);

		if(GetPVarInt(killerid, "IsOnKillStreak") == 0)
		{
			format(killstreak, sizeof(killstreak), "[INFO]: %s is currently on a kill streak, end it now!", PlayerName(killerid));
			SendClientMessageToAll(COLOR_GREEN, killstreak);
			SetPVarInt(killerid, "IsOnKillStreak", 1);
		}
		FoCo_Player[killerid][score] = FoCo_Player[killerid][score]+2;
		if(health < 100.0)
		{
			SetPlayerHealth(killerid, health+25.0);
		}
		else SetPlayerHealth(killerid, 99.0);
		if(CurrentKillStreak[killerid] >= 10)
		{
			FoCo_Player[killerid][score] = FoCo_Player[killerid][score]+3;
			if(armour < 100)
			{
				SetPlayerArmour(killerid, armour+25.0);
			}
			else SetPlayerArmour(killerid, 99);
		}
	}
	if(CurrentKillStreak[killerid] >= 10)
	{
 		if(CurrentKillStreak[killerid] == 10)
		{
			SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			GivePlayerWeapon(killerid, 16, 2);
			SendClientMessage(killerid, COLOR_SYNTAX, "[INFO]: For reaching a spree of 10, you have been rewarded with 2 grenades and extra money per kill.");
			format(killstreak, sizeof(killstreak), "[INFO]: %s is currently on a 10 kill streak! End it now and receive a reward!", PlayerName(killerid));
			SendClientMessageToAll(COLOR_GREEN, killstreak);
		}
		else if(CurrentKillStreak[killerid] == 20)
		{
			SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			GivePlayerWeapon(killerid, 16, 5);
			SendClientMessage(killerid, COLOR_SYNTAX, "[INFO]: For reaching a spree of 20, you have been rewarded with 5 grenades and extra money per kill.");
			format(killstreak, sizeof(killstreak), "[INFO]: %s is currently on a 20 kill streak! End it now and receive a reward!", PlayerName(killerid));
			SendClientMessageToAll(COLOR_GREEN, killstreak);
		}
		else if(CurrentKillStreak[killerid] == 30)
		{
			SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			GivePlayerWeapon(killerid, 35, 2);
			SendClientMessage(killerid, COLOR_SYNTAX, "[INFO]: For reaching a spree of 30, you have been rewarded with 2 RPGs and extra money per kill.");
			format(killstreak, sizeof(killstreak), "[INFO]: %s is currently on a 30 kill streak! End it now and receive a reward!", PlayerName(killerid));
			SendClientMessageToAll(COLOR_GREEN, killstreak);
		}
		else if(CurrentKillStreak[killerid] == 40)
		{
			SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			GivePlayerWeapon(killerid, 35, 5);
			SendClientMessage(killerid, COLOR_SYNTAX, "[INFO]: For reaching a spree of 40, you have been rewarded with 5 RPGs and extra money per kill.");
			format(killstreak, sizeof(killstreak), "[INFO]: %s is currently on a 30 kill streak! End it now and receive a reward!", PlayerName(killerid));
			SendClientMessageToAll(COLOR_GREEN, killstreak);
		}
	 	else if(CurrentKillStreak[killerid] == 50)
		{
			SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			GivePlayerWeapon(killerid, 38, 100);
			SendClientMessage(killerid, COLOR_SYNTAX, "[INFO]: For reaching a spree of 50, you have been rewarded with 100 bullets for the minigun and extra money per kill.");
			format(killstreak, sizeof(killstreak), "[INFO]: %s is currently on a 50 kill streak! End it now and receive a reward!", PlayerName(killerid));
			SendClientMessageToAll(COLOR_GREEN, killstreak);
		}
		else if(CurrentKillStreak[killerid] == 60)
		{
			SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			GivePlayerWeapon(killerid, 38, 50);
			SendClientMessage(killerid, COLOR_SYNTAX, "[INFO]: For reaching a spree of 60, you have been rewarded with 250 bullets for the minigun and extra money per kill.");
			format(killstreak, sizeof(killstreak), "[INFO]: %s is currently on a 60 kill streak! End it now and receive a reward!", PlayerName(killerid));
			SendClientMessageToAll(COLOR_GREEN, killstreak);
		}
		else if(CurrentKillStreak[killerid] == 70)
		{
			SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			GivePlayerWeapon(killerid, 36, 15);
			SendClientMessage(killerid, COLOR_SYNTAX, "[INFO]: For reaching a spree of 70, you have been rewarded with 15 heatseeker rounds and extra money per kill.");
			format(killstreak, sizeof(killstreak), "[INFO]: %s is currently on a 70 kill streak! End it now and receive a reward!", PlayerName(killerid));
			SendClientMessageToAll(COLOR_GREEN, killstreak);
		}
		else if(CurrentKillStreak[killerid] == 80)
		{
			SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			GivePlayerWeapon(killerid, 38, 50);
			SendClientMessage(killerid, COLOR_SYNTAX, "[INFO]: For reaching a spree of 80, you have been rewarded with 250 bullets for the minigun and extra money per kill.");
			format(killstreak, sizeof(killstreak), "[INFO]: %s is currently on a 80 kill streak! End it now and receive a reward!", PlayerName(killerid));
			SendClientMessageToAll(COLOR_GREEN, killstreak);
		}
		else if(CurrentKillStreak[killerid] == 90)
		{
			SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			GivePlayerWeapon(killerid, 38, 50);
			SendClientMessage(killerid, COLOR_SYNTAX, "[INFO]: For reaching a spree of 90, you have been rewarded with 250 bullets for the minigun and extra money per kill.");
			format(killstreak, sizeof(killstreak), "[INFO]: %s is currently on a 90 kill streak! End it now and receive a reward!", PlayerName(killerid));
			SendClientMessageToAll(COLOR_GREEN, killstreak);
		}
		else if(CurrentKillStreak[killerid] == 100)
		{
			SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			GivePlayerWeapon(killerid, 38, 150);
			SendClientMessage(killerid, COLOR_SYNTAX, "[INFO]: For reaching a spree of 100(!), you have been rewarded with 500 bullets for the minigun and extra money per kill.");
			format(killstreak, sizeof(killstreak), "[INFO]: %s is currently on a 100 kill streak! End it now and receive a reward!", PlayerName(killerid));
			SendClientMessageToAll(COLOR_GREEN, killstreak);
		}
		else if(CurrentKillStreak[killerid] > 100)
		{
		    format(killstreak, sizeof(killstreak), "[INFO]: %s is currently on a %d kill streak! End it now and receive a reward!", PlayerName(killerid), CurrentKillStreak[killerid]);
			SendClientMessageToAll(COLOR_GREEN, killstreak);
		}
		else
		{
		    return 1;
		}
	}
	return 1;
}

public IRC_Death_Messages(playerid, killerid, reason)
{
    new msg[256];
	switch(reason)
	{
		case 0, 1:
		{
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a UNARMED", PlayerName(playerid), PlayerName(killerid));
		}
		case 4:
		{
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a Knife", PlayerName(playerid), PlayerName(killerid));
			FoCo_Playerstats[killerid][knife] ++;
		}
		case 9:
		{
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a Chainsaw", PlayerName(playerid), PlayerName(killerid));
			FoCo_Playerstats[killerid][chainsaw] ++;
			GivePlayerMoney(killerid, KILL_CHAINSAW);
			new moneystring[256];
			format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from KILL_CHAINSAW.", PlayerName(killerid), killerid, KILL_CHAINSAW);
			MoneyLog(moneystring);
		}
		case 16:
		{
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a Grenade", PlayerName(playerid), PlayerName(killerid));
			FoCo_Playerstats[killerid][grenade] ++;
			GivePlayerMoney(killerid, KILL_GRENADE);
			new moneystring[256];
			format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from KILL_GRENADE.", PlayerName(killerid), killerid, KILL_GRENADE);
			MoneyLog(moneystring);
		}
		case 22, 23:
		{
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a (Silence) 9MM", PlayerName(playerid), PlayerName(killerid));
			FoCo_Playerstats[killerid][colt] ++;
		}
		case 24:
		{
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a Deagle", PlayerName(playerid), PlayerName(killerid));
			FoCo_Playerstats[killerid][deagle] ++;
		}
		case 25:
		{
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a Shotgun", PlayerName(playerid), PlayerName(killerid));
		}
		case 27:
		{
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a Combat Shotgun", PlayerName(playerid), PlayerName(killerid));
			FoCo_Playerstats[killerid][combatshotgun] ++;
		}
		case 28:
		{
			FoCo_Playerstats[killerid][uzi] ++;
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a UZI", PlayerName(playerid), PlayerName(killerid));
		}
		case 29:
		{
			FoCo_Playerstats[killerid][mp5] ++;
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a MP5", PlayerName(playerid), PlayerName(killerid));
		}
		case 30:
		{
			FoCo_Playerstats[killerid][ak47] ++;
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a ak47", PlayerName(playerid), PlayerName(killerid));
		}
		case 31:
		{
			FoCo_Playerstats[killerid][m4] ++;
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a m4", PlayerName(playerid), PlayerName(killerid));
		}
		case 32:
		{
			FoCo_Playerstats[killerid][tec9] ++;
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a tec9", PlayerName(playerid), PlayerName(killerid));
		}
		case 34:
		{
			FoCo_Playerstats[killerid][sniper] ++;
			GivePlayerMoney(killerid, KILL_SNIPER);
			new moneystring[256];
			format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from KILL_SNIPER.", PlayerName(killerid), killerid, KILL_SNIPER);
			MoneyLog(moneystring);
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a sniper", PlayerName(playerid), PlayerName(killerid));
		}
		case 35, 36:
		{
			FoCo_Playerstats[killerid][rpg] ++;
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a RPG", PlayerName(playerid), PlayerName(killerid));
		}
		case 37:
		{
			FoCo_Playerstats[killerid][flamethrower] ++;
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a FlameThrower", PlayerName(playerid), PlayerName(killerid));
		}
		case 38:
		{
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a minigun", PlayerName(playerid), PlayerName(killerid));
		}
		case 50:
		{
			FoCo_Playerstats[killerid][heli] ++;
			format(msg, sizeof(msg), "4[DEATH]: Player %s has been killed by %s with a Helicopter Blade!", PlayerName(playerid), PlayerName(killerid));
			FoCo_Player[killerid][score] = FoCo_Player[killerid][score] - 5;
			FoCo_Playerstats[killerid][kills] = FoCo_Playerstats[killerid][kills] - 2;
			SendClientMessage(killerid, COLOR_WARNING, "You just killed a player with heli blades, 5 points deducted & 2 kills removed.");
		}
	}
	IRC_GroupSay(gEcho, IRC_FOCO_ECHO, msg);
	KillLog(msg);
	return 1;
}

public Death_Streak_Reward(playerid)
{
	new deathstreak[128];
	if(CurrentDeathStreak[playerid] >= 5)
	{
 		if(FoCo_Player[playerid][level] <= 5)
		{
	 		if(CurrentDeathStreak[playerid] >= 5 && CurrentDeathStreak[playerid] < 10)
			{
				format(deathstreak, sizeof(deathstreak), "[INFO]: For being on a %d death streak, you have been given an MP5 to help you out. Cheer up soldier!", CurrentDeathStreak[playerid]);
				SendClientMessage(playerid, COLOR_SYNTAX, deathstreak);
				GivePlayerWeapon(playerid, 29, 90);
			}
			else if(CurrentDeathStreak[playerid] >= 10 && CurrentDeathStreak[playerid] < 20)
			{
			    format(deathstreak, sizeof(deathstreak), "[INFO]: For being on a %d death streak, you have been given an M4 to help you out. Cheer up soldier!", CurrentDeathStreak[playerid]);
				SendClientMessage(playerid, COLOR_SYNTAX, deathstreak);
				GivePlayerWeapon(playerid, 31, 100);
			}
			else
			{
			    format(deathstreak, sizeof(deathstreak), "[INFO]: For being on a %d death streak, you have been given a spas and 50 armour to help you out. Cheer up soldier!", CurrentDeathStreak[playerid]);
				SendClientMessage(playerid, COLOR_SYNTAX, deathstreak);
				GivePlayerWeapon(playerid, 27, 50);
				SetPlayerArmour(playerid, 50);
			}
		}
	}
	return 1;
}


public SetAFK(playerid)
{
	if(GetPVarInt(playerid, "InEvent") == 1)
	{
		KillTimer(afkTimer[playerid]);
		afkTimer[playerid] = -1;
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't go AFK in an event.");
	}
	
	new Float:Health, Float:Armour;
	GetPlayerHealth(playerid,Health);
	new Health_int = floatround(Health, floatround_floor);
	afkHP[playerid] = Health_int;
	GetPlayerArmour(playerid,Armour);
	new Armour_int = floatround(Armour, floatround_floor);
	afkArmour[playerid] = Armour_int;
	SetPVarInt(playerid, "afktime", gettime());
	SetPVarInt(playerid, "PlayerStatus", 3);
	ResetPlayerWeapons(playerid);
	
	GetPlayerPos(playerid, afkX[playerid], afkY[playerid], afkZ[playerid]);
	SetPlayerInterior(playerid, 0);
	SetPlayerPos(playerid, 2576.7861, 2712.2004, 22.9507); // afk spot
	SendClientMessage(playerid, COLOR_NOTICE, "[AFK Notice]: You are now in the safe-zone, don't kill anyone.. but you can AFK for 10 mins");
	SetPlayerVirtualWorld(playerid, playerid+1);
	canAFK[playerid] = 1;
	new string[128];
	SetPVarInt(playerid, "PlayerStatus", 3);
	format(string, sizeof(string), "[Guardian] %s has been teleported to the AFK zone. (Reason: %s)", PlayerName(playerid), afkReason[playerid]);
	SendAdminMessage(1, string);
	KillTimer(afkTimer[playerid]);
	afkTimer[playerid] = -1;
	return 1;
}

public ResetStats(playerid)
{
	gPlayerLogged[playerid] = 0; 
	SpawnAttempts[playerid] = 0;
	Spectating[playerid] = -1;
	Spectated[playerid] = -1;
	ADuty[playerid] = 0;
	Froze[playerid] = 0;
	mutedPlayers[playerid][muted] = 0;
	FoCo_Team[playerid] = 0;
	NitrousBoostEn[playerid] = 0;
	carsettimer[playerid] = 0;
	Spectated[playerid] = -1;
	AchievementTimer[playerid] = 0;
	ModdingCar[playerid] = 0;
	ModPosition[playerid] = 0;
	ModCartTotal[playerid] = 0;
	CurrentKillStreak[playerid] = 0;
	ShowingAchievement[playerid] = -1;
	AdutyOldColor[playerid] = 0;
	pickupdelID[playerid] = 0;
	DialogOptionVar3[playerid] = "";
	pickupModel[playerid] = 0;
	DialogOptionVar1[playerid] = 0;
	DialogOptionVar2[playerid] = 0;
	FoCo_Player[playerid][id] = 0;
	FoCo_Player[playerid][admin] = 0;
	FoCo_Player[playerid][tester] = 0;
	FoCo_Player[playerid][score] = 0;
	FoCo_Player[playerid][jailed] = 0;
	FoCo_Player[playerid][admin_kicks] = 0;
	FoCo_Player[playerid][admin_jails] = 0;
	FoCo_Player[playerid][admin_bans] = 0;
	FoCo_Player[playerid][admin_warns] = 0;
	
	//reportID[playerid] = -1;
	
	/*
	* Achievement Resetting
	*/
	for(new i = 0; i < AMOUNT_ACHIEVEMENTS; i++)
	{
		FoCo_PlayerAchievements[playerid][i] = 0;
	}
	/*
	*Player Stat resetting
	*/
	CurrentKillStreak[playerid] = 0;
	
	FoCo_Playerstats[playerid][deaths] = 0;
	FoCo_Playerstats[playerid][suicides] = 0;
	FoCo_Playerstats[playerid][helpups] = 0;
	FoCo_Playerstats[playerid][kills] = 0;
	FoCo_Playerstats[playerid][streaks] = 0;
	FoCo_Playerstats[playerid][heli] = 0;
	FoCo_Playerstats[playerid][deagle] = 0;
	FoCo_Playerstats[playerid][m4] = 0;
	FoCo_Playerstats[playerid][mp5] = 0;
	FoCo_Playerstats[playerid][knife] = 0;
	FoCo_Playerstats[playerid][rpg] = 0;
	FoCo_Playerstats[playerid][flamethrower] = 0;
	FoCo_Playerstats[playerid][chainsaw] = 0;
	FoCo_Playerstats[playerid][grenade] = 0;
	FoCo_Playerstats[playerid][colt] = 0;
	FoCo_Playerstats[playerid][uzi] = 0;
	FoCo_Playerstats[playerid][combatshotgun] = 0;
	FoCo_Playerstats[playerid][smg] = 0;
	FoCo_Playerstats[playerid][ak47] = 0;
	FoCo_Playerstats[playerid][tec9] = 0;
	FoCo_Playerstats[playerid][sniper] = 0;
	FoCo_Playerstats[playerid][assists] = 0;
	return 0;
}

/*stock hexstr(string[]) // By Y_Less || DISABLED DUE TO ALREADY BEING INCLUDED VIA YSI SYSTEM
{
    new
        ret,
        val,
        i;
    if (string[0] == '0' && (string[1] == 'x' || string[1] == 'X')) i = 2;
    while (string[i])
    {
        ret <<= 4;
        val = string[i++] - '0';
        if (val > 0x09) val -= 0x07;
        if (val > 0x0F) val -= 0x20;
        if (val < 0x01) continue;
        if (val < 0x10) ret += val;
    }
    return ret;
}*/

stock GetSkinType(playerid)
{
    new pSkin = GetPlayerSkin(playerid);
    for (new s = 0; s < sizeof(skins_normal); s++)
    {
        if(skins_normal[s][0] == pSkin) return 1;
    }
    for (new s = 0; s < sizeof(skins_hoods); s++)
    {
       if(skins_hoods[s][0] == pSkin) return 2;
    }
    for (new s = 0; s < sizeof(skins_thins); s++)
    {
		if(skins_thins[s][0] == pSkin) return 3;
    }
    for (new s = 0; s < sizeof(skins_big); s++)
    {
		if(skins_big[s][0] == pSkin) return 4;
    }
    for (new s = 0; s < sizeof(skins_bag); s++)
    {
        if(skins_bag[s][0] == pSkin) return 5;
    }
    for (new s = 0; s < sizeof(skins_bigger); s++)
    {
        if(skins_bigger[s][0] == pSkin) return 6;
    }
    for (new s = 0; s < sizeof(skins_granny); s++)
    {
        if(skins_granny[s][0] == pSkin) return 7;
    }
    for (new s = 0; s < sizeof(skins_army); s++)
    {
        if(skins_army[s][0] == pSkin) return 8;
    }
 
    return 1;
}

public AdminsOnline()
{
	new adcount = 0;
	foreach (Player, i)
	{
		if(IsPlayerConnected(i))
		{
			if(FoCo_Player[i][admin] > 0)
			{
				adcount ++;
			}
		}
	}
	return adcount;
}

public TAdminsOnline()
{
	new adcount = 0;
	foreach (Player, i)
	{
		if(IsPlayerConnected(i))
		{
			if(FoCo_Player[i][tester] > 0)
			{
				adcount ++;
			}
		}
	}
	return adcount;
}

stock DuelPos(input)
{
	new str[128];
	switch(input)
	{
		case 1:
		{
			format(str, sizeof(str), "Boxing Ring");
		}
		case 2:
		{
			format(str, sizeof(str), "City Hall");
		}
		case 3:
		{
			format(str, sizeof(str), "Drug Factory");
		}
		case 4:
		{
			format(str, sizeof(str), "Alhambra");
		}
		case 5:
		{
			format(str, sizeof(str), "Grotti");
		}
		case 6:
		{
			format(str, sizeof(str), "SUMO Ring");
		}
	}
	
	return str;
}

public GiveAchievement(playerid, achieveid)
{
	if(playerid != INVALID_PLAYER_ID && IsPlayerConnected(playerid))
	{
		if(FoCo_PlayerAchievements[playerid][achieveid] != 0)
		{
			return 1;
		}
		new string[128], description[56], cell1[12];
		format(string, sizeof(string), "[ACHIEVEMENT]: '%s' - You have gained %d score", FoCo_Achievements[achieveid][aname], FoCo_Achievements[achieveid][ascore]);
		SendClientMessage(playerid, COLOR_NOTICE, string);

		FoCo_PlayerAchievements[playerid][achieveid] = 1;

		format(description, sizeof(description), "%s", substr(FoCo_Achievements[achieveid][aname], 1, strlen(FoCo_Achievements[achieveid][aname])));
		format(cell1, sizeof(cell1), "%s", substr(FoCo_Achievements[achieveid][aname], 0, 1));
		format(string, sizeof(string), "~r~%s~w~%s!~n~~r~+~w~%i score", cell1, description, FoCo_Achievements[achieveid][ascore]);

		TextDrawSetString(AchieveInfoTD[playerid], string);
		TextDrawShowForPlayer(playerid, AchieveBoxTD);
		TextDrawShowForPlayer(playerid, AchieveInfoTD[playerid]);
		TextDrawShowForPlayer(playerid, AchieveAqcTD);
		TextDrawShowForPlayer(playerid, AchieveFoCoTD);

		defer achievementTimer(playerid);
	}
	return 1;
}

public UpdateAchievementStatus(playerid, ach_id, value)
{
    FoCo_PlayerAchievements[playerid][ach_id] = value;
    return 1;
}
/*Bug Fix for Bonus*/
timer cashTimer[5000](playerid)
{
	TextDrawHideForPlayer(playerid,MoneyDeathTD[playerid]);
}

timer cashVIPTimer[5000](playerid)
{
	TextDrawHideForPlayer(playerid,MoneyDeathVIPTD[playerid]);
}

timer cashTimerVIP[5000](playerid)
{
	TextDrawHideForPlayer(playerid, MoneyDeathVIPTD[playerid]);
}

/*
Created by pEar, blame him if it fails :(
*/
forward TakeMoneyOnKill(playerid, killerid, money, death_bonus);
public TakeMoneyOnKill(playerid, killerid, money, death_bonus)
{
	new string[64];
	new moneystring[256];
	new player_money = GetPlayerMoney(playerid);
	if(killerid != INVALID_PLAYER_ID)
	{
	    if(FoCo_Team[killerid] == FoCo_Team[playerid])      // If they are the same team
		{
		    if(GetPVarInt(killerid, "PlayerStatus") != 1)   // They are not in event so playerid gets 100 for getting TKd by killerid.
        	{
				if(GetPVarInt(playerid, "DuelException") != 1)  // Duel exception
				{
				    GivePlayerMoney(playerid, 100);
					
					format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from TAKEMONEYKILL_100.", PlayerName(playerid), playerid, 100);
					MoneyLog(moneystring);
					format(string, sizeof(string), "~g~+100");
			 		TextDrawSetString(MoneyDeathTD[playerid], string);
				 	TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
				 	defer cashTimer(playerid);
				 	return 1;
				}
				else
				{
    				if (killerid != INVALID_PLAYER_ID)
					{
						new Float:death_money = ((money / 100) * 0.1);
						new death_money_int = floatround(death_money, floatround_floor);

						if (death_money_int > MAX_DEATH_CASH)
						{
						    if(player_money - MAX_DEATH_CASH > 0)
						    {
						        TextDrawSetString(MoneyDeathTD[playerid], "~r~-250");
								
								format(moneystring, sizeof(moneystring), "%s(%d) lost $%d from MAX_DEATH_CASH.", PlayerName(playerid), playerid, MAX_DEATH_CASH);
								MoneyLog(moneystring);
	                            GivePlayerMoney(playerid, -MAX_DEATH_CASH);
	                            TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
								defer cashTimer(playerid);
						    }
							if(death_bonus > 0)
							{
							    format(string, sizeof(string), "~g~Bonus +%d",death_bonus);
								
								format(moneystring, sizeof(moneystring), "%s(%d) gained $%d from death_bonus.", PlayerName(playerid), playerid, death_bonus);
								MoneyLog(moneystring);
								TextDrawSetString(MoneyDeathVIPTD[playerid], string);
								GivePlayerMoney(playerid,death_bonus);
								TextDrawShowForPlayer(playerid, MoneyDeathVIPTD[playerid]);
								defer cashVIPTimer(playerid);
								new death_bonus_team = death_bonus * 3;
								if(death_bonus_team > 480)
								{
									foreach(Player, i)
									{
									    if(FoCo_Team[i] == FoCo_Team[playerid])
									    {
									        format(string, sizeof(string), "~g~Bonus +1000");
											TextDrawSetString(MoneyDeathVIPTD[i], string);
											
											format(moneystring, sizeof(moneystring), "%s(%d) gained $%d from TEAM_DEATH_BONUS1.", PlayerName(i), i, 1000);
											MoneyLog(moneystring);
											GivePlayerMoney(i,1000);
											TextDrawShowForPlayer(i, MoneyDeathVIPTD[i]);
											defer cashVIPTimer(i);
									    }
									}
								}
								return 1;
							}
						}
						else if(death_money_int < MIN_DEATH_CASH)
						{
						    if(player_money - MIN_DEATH_CASH > 0)
						    {
						        TextDrawSetString(MoneyDeathTD[playerid], "~r~-25");
	                            GivePlayerMoney(playerid, -MIN_DEATH_CASH);
								
								format(moneystring, sizeof(moneystring), "%s(%d) lost $%d from MIN_DEATH_CASH.", PlayerName(playerid), playerid, MIN_DEATH_CASH);
								MoneyLog(moneystring);
	                            TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
								defer cashTimer(playerid);
	         				}
							if(death_bonus > 0)
							{
				            	format(string, sizeof(string), "~g~Bonus +%d",death_bonus);
								TextDrawSetString(MoneyDeathVIPTD[playerid], string);
								GivePlayerMoney(playerid,death_bonus);
								
								format(moneystring, sizeof(moneystring), "%s(%d) gained $%d from death_bonus.", PlayerName(playerid), playerid, death_bonus);
								MoneyLog(moneystring);
								TextDrawShowForPlayer(playerid, MoneyDeathVIPTD[playerid]);
								defer cashVIPTimer(playerid);
								new death_bonus_team = death_bonus * 3;
								if(death_bonus_team > 480)
								{
									foreach(Player, i)
									{
									    if(FoCo_Team[i] == FoCo_Team[playerid])
									    {
									        format(string, sizeof(string), "~g~Bonus +1000");
											TextDrawSetString(MoneyDeathVIPTD[i], string);
											GivePlayerMoney(i,1000);
											
											format(moneystring, sizeof(moneystring), "%s(%d) gained $%d from TEAM_DEATH_BONUS2.", PlayerName(i), i, 1000);
											MoneyLog(moneystring);
											TextDrawShowForPlayer(i, MoneyDeathVIPTD[i]);
											defer cashVIPTimer(i);
									    }
									}
								}
								return 1;
							}
						}
						else
						{
						    format(string, sizeof(string), "~r~-%d", death_money_int);
						    TextDrawSetString(MoneyDeathTD[playerid], string);
						    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
							
							format(moneystring, sizeof(moneystring), "%s(%d) lost $%d from death_money_int.", PlayerName(playerid), playerid, death_money_int);
							MoneyLog(moneystring);
						    GivePlayerMoney(playerid, -death_money_int);
						    defer cashTimer(playerid);
						    if(death_bonus > 0)
							{
				                format(string, sizeof(string), "~g~Bonus +%d",death_bonus);
								TextDrawSetString(MoneyDeathVIPTD[playerid], string);
								GivePlayerMoney(playerid,death_bonus);
								
								format(moneystring, sizeof(moneystring), "%s(%d) gained $%d from death_bonus2.", PlayerName(playerid), playerid, death_bonus);
								MoneyLog(moneystring);
								TextDrawShowForPlayer(playerid, MoneyDeathVIPTD[playerid]);
								defer cashVIPTimer(playerid);
								new death_bonus_team = death_bonus * 3;
								if(death_bonus_team > 480)
								{
									foreach(Player, i)
									{
									    if(FoCo_Team[i] == FoCo_Team[playerid])
									    {
									        format(string, sizeof(string), "~g~Bonus +1000");
											TextDrawSetString(MoneyDeathVIPTD[i], string);
											
											format(moneystring, sizeof(moneystring), "%s(%d) gained $%d from team_death_bonus3.", PlayerName(playerid), playerid, 1000);
											MoneyLog(moneystring);
											GivePlayerMoney(i,1000);
											TextDrawShowForPlayer(i, MoneyDeathVIPTD[i]);
											defer cashVIPTimer(i);
									    }
									}
								}
								return 1;
							}
						}
					}
					else
					{
					    return 1;
					}
				}
        	}
        	if(Event_Currently_On() == 0 || Event_Currently_On() == 1 || Event_Currently_On() == 2 || Event_Currently_On() == 3 || Event_Currently_On() == 4)   // Checking if they are in a event where they should lose money.
     		{
       			if (killerid != INVALID_PLAYER_ID)
				{
					new Float:death_money = ((money / 100) * 0.1);
					new death_money_int = floatround(death_money, floatround_floor);

					if (death_money_int > MAX_DEATH_CASH)
					{
					    if(player_money - MAX_DEATH_CASH > 0)
					    {
					        TextDrawSetString(MoneyDeathTD[playerid], "~r~-250");
                            GivePlayerMoney(playerid, -MAX_DEATH_CASH);
							
							format(moneystring, sizeof(moneystring), "%s(%d) lost $%d from MAX_DEATH_CASH.", PlayerName(playerid), playerid, MAX_DEATH_CASH);
							MoneyLog(moneystring);
                            TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
							defer cashTimer(playerid);
					    }
						if(death_bonus > 0)
						{
						    format(string, sizeof(string), "~g~Bonus +%d",death_bonus);
							TextDrawSetString(MoneyDeathVIPTD[playerid], string);
							
							format(moneystring, sizeof(moneystring), "%s(%d) gained $%d from death_bonus4.", PlayerName(playerid), playerid, death_bonus);
							MoneyLog(moneystring);
							GivePlayerMoney(playerid,death_bonus);
							TextDrawShowForPlayer(playerid, MoneyDeathVIPTD[playerid]);
							defer cashVIPTimer(playerid);
							new death_bonus_team = death_bonus * 3;
							if(death_bonus_team > 480)
							{
								foreach(Player, i)
								{
								    if(FoCo_Team[i] == FoCo_Team[playerid])
								    {
								        format(string, sizeof(string), "~g~Bonus +1000");
										TextDrawSetString(MoneyDeathVIPTD[i], string);
										GivePlayerMoney(i,1000);
										
										format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from TEAM_BONUS_5.", PlayerName(i), i, 1000);
										MoneyLog(moneystring);
										TextDrawShowForPlayer(i, MoneyDeathVIPTD[i]);
										defer cashVIPTimer(i);
								    }
								}
							}
							return 1;
						}
					}
					else if(death_money_int < MIN_DEATH_CASH)
					{
					    if(player_money - MIN_DEATH_CASH > 0)
					    {
					        TextDrawSetString(MoneyDeathTD[playerid], "~r~-25");
                            GivePlayerMoney(playerid, -MIN_DEATH_CASH);
							
							format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from MIN_DEATH_CASH3.", PlayerName(playerid), playerid, MIN_DEATH_CASH);
							MoneyLog(moneystring);
                            TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
							defer cashTimer(playerid);
         				}
						if(death_bonus > 0)
						{
			            	format(string, sizeof(string), "~g~Bonus +%d",death_bonus);
							TextDrawSetString(MoneyDeathVIPTD[playerid], string);
							GivePlayerMoney(playerid,death_bonus);
							
							format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from death_bonus6.", PlayerName(playerid), playerid, death_bonus);
							MoneyLog(moneystring);
							TextDrawShowForPlayer(playerid, MoneyDeathVIPTD[playerid]);
							defer cashVIPTimer(playerid);
							new death_bonus_team = death_bonus * 3;
							if(death_bonus_team > 480)
							{
								foreach(Player, i)
								{
								    if(FoCo_Team[i] == FoCo_Team[playerid])
								    {
								        format(string, sizeof(string), "~g~Bonus +1000");
										TextDrawSetString(MoneyDeathVIPTD[i], string);
										GivePlayerMoney(i,1000);
										
										format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from TEAM_BONUS_6.", PlayerName(i), i, 1000);
										MoneyLog(moneystring);
										TextDrawShowForPlayer(i, MoneyDeathVIPTD[i]);
										defer cashVIPTimer(i);
								    }
								}
							}
							return 1;
						}
					}
					else
					{
					    format(string, sizeof(string), "~r~-%d", death_money_int);
					    TextDrawSetString(MoneyDeathTD[playerid], string);
					    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
					    GivePlayerMoney(playerid, -death_money_int);
						
						format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from death_money_int2.", PlayerName(playerid), playerid, death_money_int);
						MoneyLog(moneystring);
										
					    defer cashTimer(playerid);
					    if(death_bonus > 0)
						{
			                format(string, sizeof(string), "~g~Bonus +%d",death_bonus);
							TextDrawSetString(MoneyDeathVIPTD[playerid], string);
							GivePlayerMoney(playerid,death_bonus);
							
							format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from DEATH_BONUS_6.", PlayerName(playerid), playerid, death_bonus);
							MoneyLog(moneystring);
							TextDrawShowForPlayer(playerid, MoneyDeathVIPTD[playerid]);
							defer cashVIPTimer(playerid);
							new death_bonus_team = death_bonus * 3;
							if(death_bonus_team > 480)
							{
								foreach(Player, i)
								{
								    if(FoCo_Team[i] == FoCo_Team[playerid])
								    {
								        format(string, sizeof(string), "~g~Bonus +1000");
										TextDrawSetString(MoneyDeathVIPTD[i], string);
										GivePlayerMoney(i,1000);
										
										format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from TEAM_BONUS_6.", PlayerName(i), i, 1000);
										MoneyLog(moneystring);
										
										TextDrawShowForPlayer(i, MoneyDeathVIPTD[i]);
										defer cashVIPTimer(i);
								    }
								}
							}
							return 1;
						}
					}
				}
				else
				{
    				if(GetPVarInt(playerid, "TKd") == 1)
				    {
				        money = IsLastKillTK[playerid]*1000;
						format(string, sizeof(string), "~r~-%d", money);
				 		TextDrawSetString(MoneyDeathTD[playerid], string);
					 	TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
					 	defer cashTimer(playerid);
					 	SetPVarInt(playerid, "TKd", 0);
					 	return 1;
				    }
				    else
				    {
				        if(player_money - KILL_SUICIDE > 0)
				        {
				            GivePlayerMoney(playerid, -KILL_SUICIDE);
							
							format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from KILL_SUICIDE.", PlayerName(playerid), playerid, KILL_SUICIDE);
							MoneyLog(moneystring);
							format(string, sizeof(string), "~r~-%d", KILL_SUICIDE);
					 		TextDrawSetString(MoneyDeathTD[playerid], string);
						 	TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
						 	defer cashTimer(playerid);
				        }
				        return 1;
				    }
				}
     		}
     		else    // Should get money if TKd in a event where you should not be TKd.
		 	{
		 	    if(GetPVarInt(playerid, "MotelTeamIssued") == GetPVarInt(killerid, "MotelTeamIssued"))
		 	    {
		 	        GivePlayerMoney(playerid, 100);
					
					format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from MOTEL_TEAM.", PlayerName(playerid), playerid, 100);
					MoneyLog(moneystring);
					format(string, sizeof(string), "~g~+100");
			 		TextDrawSetString(MoneyDeathTD[playerid], string);
			 		TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
			 		defer cashTimer(playerid);
					return 1;
		 	    }
		 	    else
		 	    {
        			new Float:death_money = ((money / 100) * 0.1);
					new death_money_int = floatround(death_money, floatround_floor);
					if (death_money_int > MAX_DEATH_CASH)
					{
		                if(player_money - MAX_DEATH_CASH > 0)
		                {
		                    TextDrawSetString(MoneyDeathTD[playerid], "~r~-250");
						    GivePlayerMoney(playerid, -MAX_DEATH_CASH);
							
							format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from MAX_DEATH_CASH3.", PlayerName(playerid), playerid, MAX_DEATH_CASH);
							MoneyLog(moneystring);
						    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
							defer cashTimer(playerid);
		                }
						if(death_bonus > 0)
						{
		    				format(string, sizeof(string), "~g~Bonus +%d",death_bonus);
							TextDrawSetString(MoneyDeathVIPTD[playerid], string);
							GivePlayerMoney(playerid,death_bonus);
							
							format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from death_bonus7.", PlayerName(playerid), playerid, death_bonus);
							MoneyLog(moneystring);
							TextDrawShowForPlayer(playerid, MoneyDeathVIPTD[playerid]);
							defer cashVIPTimer(playerid);
							new death_bonus_team = death_bonus * 3;
							if(death_bonus_team > 480)
							{
								foreach(Player, i)
								{
				    				if(FoCo_Team[i] == FoCo_Team[playerid])
							    	{
				        				format(string, sizeof(string), "~g~Bonus +1000");
										TextDrawSetString(MoneyDeathVIPTD[i], string);
										GivePlayerMoney(i,1000);
										
										format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from TEAM_BONUS_7.", PlayerName(i), i, 1000);
										MoneyLog(moneystring);
										
										TextDrawShowForPlayer(i, MoneyDeathVIPTD[i]);
										defer cashVIPTimer(i);
						    		}
								}
							}
							return 1;
						}
					}
					else if(death_money_int < MIN_DEATH_CASH)
					{
					    if(player_money - MAX_DEATH_CASH > 0)
		                {
		                    TextDrawSetString(MoneyDeathTD[playerid], "~r~-25");
						    GivePlayerMoney(playerid, -MIN_DEATH_CASH);
							
							format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from MIN_DEATH_CASH4.", PlayerName(playerid), playerid, MIN_DEATH_CASH);
							MoneyLog(moneystring);
						    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
							defer cashTimer(playerid);
		                }
						if(death_bonus > 0)
						{
		   					format(string, sizeof(string), "~g~Bonus +%d",death_bonus);
							TextDrawSetString(MoneyDeathVIPTD[playerid], string);
							GivePlayerMoney(playerid,death_bonus);
							
							format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from death_bonus8.", PlayerName(playerid), playerid, death_bonus);
							MoneyLog(moneystring);
							TextDrawShowForPlayer(playerid, MoneyDeathVIPTD[playerid]);
							defer cashVIPTimer(playerid);
							new death_bonus_team = death_bonus * 3;
							if(death_bonus_team > 480)
							{
								foreach(Player, i)
								{
				    				if(FoCo_Team[i] == FoCo_Team[playerid])
								    {
				        				format(string, sizeof(string), "~g~Bonus +1000");
										TextDrawSetString(MoneyDeathVIPTD[i], string);
										GivePlayerMoney(i,1000);										
										
										format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from TEAM_BONUS_8.", PlayerName(i), i, 1000);
										MoneyLog(moneystring);
										
										TextDrawShowForPlayer(i, MoneyDeathVIPTD[i]);
										defer cashVIPTimer(i);
						    		}
								}
							}
							return 1;
						}
					}
					else
					{
		   				format(string, sizeof(string), "~r~-%d", death_money_int);
					    TextDrawSetString(MoneyDeathTD[playerid], string);
					    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
					    GivePlayerMoney(playerid, -death_money_int);
						
						format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from death_money_int5.", PlayerName(playerid), playerid, death_money_int);
						MoneyLog(moneystring);
					    defer cashTimer(playerid);
					    if(death_bonus > 0)
						{
		   					format(string, sizeof(string), "~g~Bonus +%d",death_bonus);
							
							format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from death_bonus9.", PlayerName(playerid), playerid, death_bonus);
							MoneyLog(moneystring);
							TextDrawSetString(MoneyDeathVIPTD[playerid], string);
							GivePlayerMoney(playerid,death_bonus);
							TextDrawShowForPlayer(playerid, MoneyDeathVIPTD[playerid]);
							defer cashVIPTimer(playerid);
							new death_bonus_team = death_bonus * 3;
							if(death_bonus_team > 480)
							{
								foreach(Player, i)
								{
				    				if(FoCo_Team[i] == FoCo_Team[playerid])
								    {
				        				format(string, sizeof(string), "~g~Bonus +1000");
										TextDrawSetString(MoneyDeathVIPTD[i], string);
										GivePlayerMoney(i,1000);										
										
										format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from TEAM_BONUS_9.", PlayerName(i), i, 1000);
										MoneyLog(moneystring);
										TextDrawShowForPlayer(i, MoneyDeathVIPTD[i]);
										defer cashVIPTimer(i);
						    		}
								}
							}
							return 1;
						}
					}
		 	    }
     		}
     		return 1;
		}
		else    // They are NOT on the same team.
		{
		    new Float:death_money = ((money / 100) * 0.1);
			new death_money_int = floatround(death_money, floatround_floor);
			if (death_money_int > MAX_DEATH_CASH)
			{
                if(player_money - MAX_DEATH_CASH > 0)
                {
                    TextDrawSetString(MoneyDeathTD[playerid], "~r~-250");
				    GivePlayerMoney(playerid, -MAX_DEATH_CASH);
					
					format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from MAX_DEATH_CASH15.", PlayerName(playerid), playerid, MAX_DEATH_CASH);
					MoneyLog(moneystring);
				    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
					defer cashTimer(playerid);
                }
				if(death_bonus > 0)
				{
    				format(string, sizeof(string), "~g~Bonus +%d",death_bonus);
					TextDrawSetString(MoneyDeathVIPTD[playerid], string);
					GivePlayerMoney(playerid,death_bonus);
					
					format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from death_bonus10.", PlayerName(playerid), playerid, death_bonus);
					MoneyLog(moneystring);
					TextDrawShowForPlayer(playerid, MoneyDeathVIPTD[playerid]);
					defer cashVIPTimer(playerid);
					new death_bonus_team = death_bonus * 3;
					if(death_bonus_team > 480)
					{
						foreach(Player, i)
						{
		    				if(FoCo_Team[i] == FoCo_Team[playerid])
					    	{
		        				format(string, sizeof(string), "~g~Bonus +1000");
								TextDrawSetString(MoneyDeathVIPTD[i], string);
								GivePlayerMoney(i,1000);									
								
								format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from TEAM_BONUS_10.", PlayerName(i), i, 1000);
								MoneyLog(moneystring);
										
								TextDrawShowForPlayer(i, MoneyDeathVIPTD[i]);
								defer cashVIPTimer(i);
				    		}
						}
					}
					return 1;
				}
			}
			else if(death_money_int < MIN_DEATH_CASH)
			{
			    if(player_money - MAX_DEATH_CASH > 0)
                {
                    TextDrawSetString(MoneyDeathTD[playerid], "~r~-25");
				    GivePlayerMoney(playerid, -MIN_DEATH_CASH);
					
					format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from MIN_DEATH_CASH10.", PlayerName(playerid), playerid, MIN_DEATH_CASH);
					MoneyLog(moneystring);
				    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
					defer cashTimer(playerid);
                }
				if(death_bonus > 0)
				{
   					format(string, sizeof(string), "~g~Bonus +%d",death_bonus);
					TextDrawSetString(MoneyDeathVIPTD[playerid], string);
					GivePlayerMoney(playerid,death_bonus);
					
					format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from death_bonus11.", PlayerName(playerid), playerid, death_bonus);
					MoneyLog(moneystring);
					TextDrawShowForPlayer(playerid, MoneyDeathVIPTD[playerid]);
					defer cashVIPTimer(playerid);
					new death_bonus_team = death_bonus * 3;
					if(death_bonus_team > 480)
					{
						foreach(Player, i)
						{
		    				if(FoCo_Team[i] == FoCo_Team[playerid])
						    {
		        				format(string, sizeof(string), "~g~Bonus +1000");
								TextDrawSetString(MoneyDeathVIPTD[i], string);
								GivePlayerMoney(i,1000);					
								
								format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from TEAM_BONUS_11.", PlayerName(i), i, 1000);
								MoneyLog(moneystring);
										
								TextDrawShowForPlayer(i, MoneyDeathVIPTD[i]);
								defer cashVIPTimer(i);
				    		}
						}
					}
					return 1;
				}
			}
			else
			{
   				format(string, sizeof(string), "~r~-%d", death_money_int);
			    TextDrawSetString(MoneyDeathTD[playerid], string);
			    TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
			    GivePlayerMoney(playerid, -death_money_int);
				
				format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from death_money_int.", PlayerName(playerid), playerid, death_money_int);
				MoneyLog(moneystring);
			    defer cashTimer(playerid);
			    if(death_bonus > 0)
				{
   					format(string, sizeof(string), "~g~Bonus +%d",death_bonus);
					TextDrawSetString(MoneyDeathVIPTD[playerid], string);
					GivePlayerMoney(playerid,death_bonus);
					
					format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from death_bonus12.", PlayerName(playerid), playerid, death_bonus);
					MoneyLog(moneystring);
					TextDrawShowForPlayer(playerid, MoneyDeathVIPTD[playerid]);
					defer cashVIPTimer(playerid);
					new death_bonus_team = death_bonus * 3;
					if(death_bonus_team > 480)
					{
						foreach(Player, i)
						{
		    				if(FoCo_Team[i] == FoCo_Team[playerid])
						    {
		        				format(string, sizeof(string), "~g~Bonus +1000");
								TextDrawSetString(MoneyDeathVIPTD[i], string);
								GivePlayerMoney(i,1000);					
										
								format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from TEAM_BONUS_12.", PlayerName(i), i, 1000);
								MoneyLog(moneystring);
										
								TextDrawShowForPlayer(i, MoneyDeathVIPTD[i]);
								defer cashVIPTimer(i);
				    		}
						}
					}
					return 1;
				}
			}
  		}
  		return 1;
	}
	else        // Either using /kill, /akill or suicided by falling down. Killerid is invalid.
	{
	    if(GetPVarInt(playerid, "TKd") == 1)
	    {
	        money = IsLastKillTK[playerid]*1000;
			format(string, sizeof(string), "~r~-%d", money);
	 		TextDrawSetString(MoneyDeathTD[playerid], string);
		 	TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
		 	defer cashTimer(playerid);
		 	SetPVarInt(playerid, "TKd", 0);
		 	return 1;
	    }
	    else
	    {
	        if(player_money - KILL_SUICIDE >= 0)
	        {
	            GivePlayerMoney(playerid, -KILL_SUICIDE);
				
				format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from KILL_SUICIDE_L.", PlayerName(playerid), playerid, KILL_SUICIDE);
				MoneyLog(moneystring);
				format(string, sizeof(string), "~r~-%d", KILL_SUICIDE);
		 		TextDrawSetString(MoneyDeathTD[playerid], string);
			 	TextDrawShowForPlayer(playerid,MoneyDeathTD[playerid]);
			 	defer cashTimer(playerid);
			 	return 1;
	        }
	        return 1;
	    }
	}
}
/*
Created by pEar, blame him if it fails :(
*/
forward GiveMoneyOnKill(playerid, killerid, bonus);
public GiveMoneyOnKill(playerid, killerid, bonus)
{
    new string[128], moneystring[256];
    if(killerid == INVALID_PLAYER_ID)
    {
        return 1;
    }
	if (playerid != INVALID_PLAYER_ID)
	{
        new total_money;
		new money;
		new vip_bonus;
		new Float: spree_money;
		new money_int;
	    if (isVIP(killerid) > 0 || AdminLvl(killerid) > 0)
		{
			money = 0;
		    if(FoCo_Team[playerid] == FoCo_Team[killerid])
		    {
		        if(GetPVarInt(killerid, "PlayerStatus") != 1)
		        {
		            if(GetPVarInt(playerid, "DuelException") != 1)
		            {
		                money = IsLastKillTK[killerid]*1000;
	        			format(string, sizeof(string), "~r~-%d", money);
						TextDrawSetString(MoneyDeathTD[killerid], string);
						GivePlayerMoney(killerid, -money);
						format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from GMOK_1.", PlayerName(killerid), killerid, money);
						MoneyLog(moneystring);
						TextDrawShowForPlayer(killerid,MoneyDeathTD[killerid]);
						defer cashTimer(killerid);
						return 1;
		            }
		            else
		            {
              			money = 0;
			            total_money = 0;
			            money = (KILL_CASH + (FoCo_Player[playerid][level]-FoCo_Player[killerid][level])*10);
				    	money_int = floatround(money, floatround_floor);
				    	format(string, sizeof(string), "~g~+%d", money_int);
						TextDrawSetString(MoneyDeathTD[killerid], string);
						GivePlayerMoney(killerid, money_int);
						format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from GMOK_money_int.", PlayerName(killerid), killerid, money_int);
						MoneyLog(moneystring);
						TextDrawShowForPlayer(killerid,MoneyDeathTD[killerid]);
						defer cashTimer(killerid);
						if(isVIP(killerid) == 1 || AdminLvl(killerid) == 1 || AdminLvl(killerid) == 2)
						{
						    vip_bonus = 20;
						}
						else if(isVIP(killerid) == 2 || AdminLvl(killerid) == 3 || AdminLvl(killerid) == 4)
						{
							vip_bonus = 40;

						}
						else if(isVIP(killerid) == 3 || AdminLvl(killerid) == 5)
						{
						    vip_bonus = 60;
						}

						format(string, sizeof(string), "~g~VIP +%d",vip_bonus);
						TextDrawSetString(MoneyDeathVIPTD[killerid], string);
						GivePlayerMoney(killerid,vip_bonus);
						format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from GMOK_vipbonus.", PlayerName(killerid), killerid, vip_bonus);
						MoneyLog(moneystring);
						TextDrawShowForPlayer(killerid, MoneyDeathVIPTD[killerid]);
						defer cashVIPTimer(killerid);
						SetPVarInt(playerid, "DuelException", 0);
						SetPVarInt(killerid, "DuelException", 0);
						return 1;
		            }
		        }
		        if(Event_Currently_On() == 0 || Event_Currently_On() == 1 || Event_Currently_On() == 2 || Event_Currently_On() == 3 || Event_Currently_On() == 4)
		        {
		            money = 0;
		            total_money = 0;
		            money = (KILL_CASH + (FoCo_Player[playerid][level]-FoCo_Player[killerid][level])*10);
			    	money_int = floatround(money, floatround_floor);
			    	format(string, sizeof(string), "~g~+%d", money_int);
					TextDrawSetString(MoneyDeathTD[killerid], string);
					GivePlayerMoney(killerid, money_int);
					format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from GMOK_moneyint.", PlayerName(killerid), killerid, money_int);
					MoneyLog(moneystring);
					TextDrawShowForPlayer(killerid,MoneyDeathTD[killerid]);
					defer cashTimer(killerid);
					if(isVIP(killerid) == 1 || AdminLvl(killerid) == 1 || AdminLvl(killerid) == 2)
					{
					    vip_bonus = 20;
					}
					else if(isVIP(killerid) == 2 || AdminLvl(killerid) == 3 || AdminLvl(killerid) == 4)
					{
						vip_bonus = 40;

					}
					else if(isVIP(killerid) == 3 || AdminLvl(killerid) == 5)
					{
					    vip_bonus = 60;
					}

					format(string, sizeof(string), "~g~VIP +%d",vip_bonus);
					TextDrawSetString(MoneyDeathVIPTD[killerid], string);
					GivePlayerMoney(killerid,vip_bonus);
					format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from GMOK_vip_bonus.", PlayerName(killerid), killerid, vip_bonus);
					MoneyLog(moneystring);
					TextDrawShowForPlayer(killerid, MoneyDeathVIPTD[killerid]);
					defer cashVIPTimer(killerid);
					return 1;

		        }
		        else
		        {
		            if(GetPVarInt(playerid, "MotelTeamIssued") == GetPVarInt(killerid, "MotelTeamIssued"))
					{
					    money = IsLastKillTK[killerid]*1000;
				        format(string, sizeof(string), "~r~-%d", money);
						TextDrawSetString(MoneyDeathTD[killerid], string);
						GivePlayerMoney(killerid, -money);
						format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from GMOK_vip_bonus.", PlayerName(killerid), killerid, money);
						MoneyLog(moneystring);
						TextDrawShowForPlayer(killerid,MoneyDeathTD[killerid]);
						defer cashTimer(killerid);
						return 1;
					}
					else
					{
						money = 0;
			            total_money = 0;
			            money = (KILL_CASH + (FoCo_Player[playerid][level]-FoCo_Player[killerid][level])*10);
				    	money_int = floatround(money, floatround_floor);
				    	format(string, sizeof(string), "~g~+%d", money_int);
						TextDrawSetString(MoneyDeathTD[killerid], string);
						GivePlayerMoney(killerid, money_int);
						format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from GMOK_money_int.", PlayerName(killerid), killerid, money_int);
						MoneyLog(moneystring);
						TextDrawShowForPlayer(killerid,MoneyDeathTD[killerid]);
						defer cashTimer(killerid);
						if(isVIP(killerid) == 1 || AdminLvl(killerid) == 1 || AdminLvl(killerid) == 2)
						{
						    vip_bonus = 20;
						}
						else if(isVIP(killerid) == 2 || AdminLvl(killerid) == 3 || AdminLvl(killerid) == 4)
						{
							vip_bonus = 40;

						}
						else if(isVIP(killerid) == 3 || AdminLvl(killerid) == 5)
						{
						    vip_bonus = 60;
						}
						format(string, sizeof(string), "~g~VIP +%d",vip_bonus);
						TextDrawSetString(MoneyDeathVIPTD[killerid], string);
						GivePlayerMoney(killerid,vip_bonus);						
						format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from GMOK_vip_bonus.", PlayerName(killerid), killerid, vip_bonus);
						MoneyLog(moneystring);
						TextDrawShowForPlayer(killerid, MoneyDeathVIPTD[killerid]);
						defer cashVIPTimer(killerid);
						return 1;
					}
		        }
		        
		    }
		    else
		    {
				money = 0;
		        total_money = 0;
		        
			    money = (KILL_CASH + (FoCo_Player[playerid][level]-FoCo_Player[killerid][level])*10);
			    money_int = floatround(money, floatround_floor);
			    if(CurrentKillStreak[killerid] >= 5)
			    {
			        if(CurrentKillStreak[killerid] >= 100)
			        {
			            spree_money = (money_int * 2);
			            money_int = floatround(spree_money, floatround_floor);
			            format(string, sizeof(string), "[INFO]: %s (%d) is currently on a %d spree! Use /loc to find his location and earn a MASSIVE reward for killing him!", PlayerName(killerid), killerid, CurrentKillStreak[killerid]);
			            SendClientMessageToAll(COLOR_GREEN, string);
			        }
			        else if(CurrentKillStreak[killerid] >= 90)
					{
					    spree_money = (money_int * 1.9);
					    money_int = floatround(spree_money, floatround_floor);
					}
					else if(CurrentKillStreak[killerid] >= 80)
					{
					    spree_money = (money_int * 1.8);
					    money_int = floatround(spree_money, floatround_floor);
					}
					else if(CurrentKillStreak[killerid] >= 70)
					{
					    spree_money = (money_int * 1.7);
					    money_int = floatround(spree_money, floatround_floor);
					}
					else if(CurrentKillStreak[killerid] >= 60)
					{
					    spree_money = (money_int * 1.6);
					    money_int = floatround(spree_money, floatround_floor);
					}
					else if(CurrentKillStreak[killerid] >= 50)
					{
					    spree_money = (money_int * 1.5);
					    money_int = floatround(spree_money, floatround_floor);
					}
					else if(CurrentKillStreak[killerid] >= 40)
					{
					    spree_money = (money_int * 1.4);
					    money_int = floatround(spree_money, floatround_floor);
					}
					else if(CurrentKillStreak[killerid] >= 30)
					{
					    spree_money = (money_int * 1.3);
					    money_int = floatround(spree_money, floatround_floor);
					}
					else if(CurrentKillStreak[killerid] >= 20)
					{
					    spree_money = (money_int * 1.2);
					    money_int = floatround(spree_money, floatround_floor);
					}
					else
					{
					    spree_money = (money_int * 1.1);
					    money_int = floatround(spree_money, floatround_floor);
					}
			    }
			    if(isVIP(killerid) == 1 || AdminLvl(killerid) == 1 || AdminLvl(killerid) == 2)
				{
				    vip_bonus = 20;
				}
				else if(isVIP(killerid) == 2 || AdminLvl(killerid) == 3 || AdminLvl(killerid) == 4)
				{
					vip_bonus = 40;

				}
				else if(isVIP(killerid) == 3 || AdminLvl(killerid) == 5)
				{
				    vip_bonus = 60;
				}
				format(string, sizeof(string), "~g~+%d", money_int);
				TextDrawSetString(MoneyDeathTD[killerid], string);
				GivePlayerMoney(killerid, money_int);						
				format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from GMOK_money_int.", PlayerName(killerid), killerid, money_int);
				MoneyLog(moneystring);
				TextDrawShowForPlayer(killerid,MoneyDeathTD[killerid]);
				defer cashTimer(killerid);
				if(bonus > 0)
				{
					total_money = (bonus + vip_bonus);
	    			format(string, sizeof(string), "~g~VIP/Bonus +%d",total_money);
					TextDrawSetString(MoneyDeathVIPTD[killerid], string);
					GivePlayerMoney(killerid,total_money);						
					format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from GMOK_VIPtotal_money.", PlayerName(killerid), killerid, total_money);
					MoneyLog(moneystring);
					TextDrawShowForPlayer(killerid, MoneyDeathVIPTD[killerid]);
					defer cashVIPTimer(killerid);
					return 1;
				}
				else
				{
	    			format(string, sizeof(string), "~g~VIP +%d",vip_bonus);
					TextDrawSetString(MoneyDeathVIPTD[killerid], string);
					GivePlayerMoney(killerid,vip_bonus);						
					format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from GMOK_VIP_Bonus.", PlayerName(killerid), killerid, vip_bonus);
					MoneyLog(moneystring);
					TextDrawShowForPlayer(killerid, MoneyDeathVIPTD[killerid]);
					defer cashVIPTimer(killerid);
					return 1;
				}
				
		    }
		    
		}
		else
		{
		    money = 0;
      		if(FoCo_Team[playerid] == FoCo_Team[killerid])
		    {
		        if(GetPVarInt(killerid, "PlayerStatus") != 1)
		        {
		            if(GetPVarInt(playerid, "MotelTeamIssued") == GetPVarInt(killerid, "MotelTeamIssued"))
		            {
		                if(GetPVarInt(playerid, "DuelException") != 1)
		                {
		                    money = IsLastKillTK[killerid]*1000;
					        format(string, sizeof(string), "~r~-%d", money);
							TextDrawSetString(MoneyDeathTD[killerid], string);
							GivePlayerMoney(killerid, -money);						
							format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from GMOK_lostmon.", PlayerName(killerid), killerid, money);
							MoneyLog(moneystring);
							TextDrawShowForPlayer(killerid,MoneyDeathTD[killerid]);
							defer cashTimer(killerid);
							return 1;
		                }
		                else
		                {
                  			money = 0;
				            total_money = 0;
				            money = (KILL_CASH + (FoCo_Player[playerid][level]-FoCo_Player[killerid][level])*10);
					    	money_int = floatround(money, floatround_floor);
					    	format(string, sizeof(string), "~g~+%d", money_int);
							TextDrawSetString(MoneyDeathTD[killerid], string);
							GivePlayerMoney(killerid, money_int);						
							format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from GMOK_money_int.", PlayerName(killerid), killerid, money_int);
							MoneyLog(moneystring);
							TextDrawShowForPlayer(killerid,MoneyDeathTD[killerid]);
							defer cashTimer(killerid);
		                    SetPVarInt(playerid, "DuelException", 0);
		                    SetPVarInt(killerid, "DuelException", 0);
		                    return 1;
		                }
		                
		            }
		        }
		        if(Event_Currently_On() == 0 || Event_Currently_On() == 1 || Event_Currently_On() == 2 || Event_Currently_On() == 3 || Event_Currently_On() == 4)
		        {
		            money = 0;
		            total_money = 0;
		            money = (KILL_CASH + (FoCo_Player[playerid][level]-FoCo_Player[killerid][level])*10);
			    	money_int = floatround(money, floatround_floor);
			    	format(string, sizeof(string), "~g~+%d", money_int);
					TextDrawSetString(MoneyDeathTD[killerid], string);
					GivePlayerMoney(killerid, money_int);						
					format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from GMOK_money_int.", PlayerName(killerid), killerid, money_int);
					MoneyLog(moneystring);
					TextDrawShowForPlayer(killerid,MoneyDeathTD[killerid]);
					defer cashTimer(killerid);
					return 1;
		        }
		        else
		        {
		            money = 1000;
			        format(string, sizeof(string), "~r~-%d", money);
					TextDrawSetString(MoneyDeathTD[killerid], string);
					GivePlayerMoney(killerid, -money);						
					format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from GMOK_money.", PlayerName(killerid), killerid, money);
					MoneyLog(moneystring);
					TextDrawShowForPlayer(killerid,MoneyDeathTD[killerid]);
					defer cashTimer(killerid);
					return 1;
		        }

		    }
	     	else
		    {
		        money = 0;
		        total_money = 0;
			    money = (KILL_CASH + (FoCo_Player[playerid][level]-FoCo_Player[killerid][level])*10);
			    money_int = floatround(money, floatround_floor);
			    if(CurrentKillStreak[killerid] >= 5)
			    {
			        if(CurrentKillStreak[killerid] >= 100)
			        {
			            spree_money = (money * 2);
			            money_int = floatround(spree_money, floatround_floor);
			            format(string, sizeof(string), "[INFO]: %s (%d) is currently on a %d spree! Use /loc to find his location and earn a MASSIVE reward for killing him!", PlayerName(killerid), killerid, CurrentKillStreak[killerid]);
			            SendClientMessageToAll(COLOR_GREEN, string);
			        }
			        else if(CurrentKillStreak[killerid] >= 90)
					{
					    spree_money = (money_int * 1.9);
					    money_int = floatround(spree_money, floatround_floor);
					}
					else if(CurrentKillStreak[killerid] >= 80)
					{
					    spree_money = (money_int * 1.8);
					    money_int = floatround(spree_money, floatround_floor);
					}
					else if(CurrentKillStreak[killerid] >= 70)
					{
					    spree_money = (money_int * 1.7);
					    money_int = floatround(spree_money, floatround_floor);
					}
					else if(CurrentKillStreak[killerid] >= 60)
					{
					    spree_money = (money_int * 1.6);
					    money_int = floatround(spree_money, floatround_floor);
					}
					else if(CurrentKillStreak[killerid] >= 50)
					{
					    spree_money = (money_int * 1.5);
					    money_int = floatround(spree_money, floatround_floor);
					}
					else if(CurrentKillStreak[killerid] >= 40)
					{
					    spree_money = (money_int * 1.4);
					    money_int = floatround(spree_money, floatround_floor);
					}
					else if(CurrentKillStreak[killerid] >= 30)
					{
					    spree_money = (money_int * 1.3);
					    money_int = floatround(spree_money, floatround_floor);
					}
					else if(CurrentKillStreak[killerid] >= 20)
					{
					    spree_money = (money_int * 1.2);
					    money_int = floatround(spree_money, floatround_floor);
					}
					else if(CurrentKillStreak[killerid] >= 10)
					{
					    spree_money = (money_int * 1.1);
					    money_int = floatround(spree_money, floatround_floor);
					}
			    }
				format(string, sizeof(string), "~g~+%d", money_int);
				TextDrawSetString(MoneyDeathTD[killerid], string);
				GivePlayerMoney(killerid, money_int);						
				format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from GMOK_spree_money_int.", PlayerName(killerid), killerid, money_int);
				MoneyLog(moneystring);
				TextDrawShowForPlayer(killerid,MoneyDeathTD[killerid]);
				defer cashTimer(killerid);

				if(bonus > 0)
				{
				    format(string, sizeof(string), "~g~Bonus +%d",bonus);
					TextDrawSetString(MoneyDeathVIPTD[killerid], string);
					GivePlayerMoney(killerid,bonus);						
					format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from GMOK_money_int_bonue.", PlayerName(killerid), killerid, bonus);
					MoneyLog(moneystring);
					TextDrawShowForPlayer(killerid, MoneyDeathVIPTD[killerid]);
					defer cashVIPTimer(killerid);
					return 1;
				}
				return 1;
			}
		}
	}
	return 1;
}

forward ClanWarCheck(clan_one, clan_two, members, location, weapons, trial);
public ClanWarCheck(clan_one, clan_two, members, location, weapons, trial) 
{
	new clan_one_count = 0;
	new clan_two_count = 0;
	
	foreach(Player, i)
	{
		if(FoCo_Team[i] == clan_one)
		{
			clan_one_count++;
		}
		
		if(FoCo_Team[i] == clan_two)
		{
			clan_two_count++;
		}
	}
	
	if(clan_one_count < members || clan_two_count < members) 
	{
		new string[200];
		format(string, sizeof(string), "[Clan War News]: Clan War Failed. Not enough members. %d required (Clan1: %d - Clan2: %d) accepted.", members, clan_one_count, clan_two_count);
		foreach(Player, i)
		{
			if(FoCo_Team[i] == clan_one || FoCo_Team[i] == clan_two)
			{
				SendClientMessage(i, COLOR_WARNING, string);
			}
		}
		
		FoCo_Teams[clan_one][team_clanwar_enemy] = 0;
		FoCo_Teams[clan_one][team_clanwar_members] = 0;
		FoCo_Teams[clan_two][team_clanwar_enemy] = 0;
		FoCo_Teams[clan_two][team_clanwar_members] = 0;
		return 1;
	}
	
	new inc = 0;
	new inc2 = 0;
	foreach(Player, i)
	{
		if(FoCo_Team[i] == clan_one || FoCo_Team[i] == clan_two)
		{
			if(ClanWar_Joining[i] == 1)
			{
				SetPlayerHealth(i, 99);
				SetPlayerArmour(i, 99);
				FoCo_Teams[FoCo_Team[i]][team_clanwar_kills] = 0;
				FoCo_Teams[FoCo_Team[i]][team_clanwar_deaths] = 0;
				switch(location)
				{
					case 1:
					{
						if(FoCo_Team[i] == clan_one) {
							SetPlayerPos(i, ClanWar_Area59[inc][0], ClanWar_Area59[inc][1], ClanWar_Area59[inc][2]);
							SetPlayerFacingAngle(i, ClanWar_Area59[inc][3]);
							SetPVarInt(i, "CW_TEAM", 1);
							SetPlayerInterior(i, 0);
							inc++;
						} else {
							SetPlayerPos(i, ClanWar_Area59[inc2+10][0], ClanWar_Area59[inc2+10][1], ClanWar_Area59[inc2+10][2]);
							SetPlayerFacingAngle(i, ClanWar_Area59[inc2+10][3]);
							SetPVarInt(i, "CW_TEAM", 2);
							SetPlayerInterior(i, 0);
							inc2++;
						}
						SetPlayerVirtualWorld(i, clan_one);
			
					}
					case 2:
					{
						if(FoCo_Team[i] == clan_one) {
							SetPlayerPos(i, ClanWar_RCBG[inc][0], ClanWar_RCBG[inc][1], ClanWar_RCBG[inc][2]);
							SetPlayerFacingAngle(i, ClanWar_RCBG[inc][3]);
							SetPlayerInterior(i, 10);
							SetPVarInt(i, "CW_TEAM", 1);
							inc++;
						} else {
							SetPlayerPos(i, ClanWar_RCBG[inc2+10][0], ClanWar_RCBG[inc2+10][1], ClanWar_RCBG[inc2+10][2]);
							SetPlayerFacingAngle(i, ClanWar_RCBG[inc2+10][3]);
							SetPVarInt(i, "CW_TEAM", 2);
							SetPlayerInterior(i, 10);
							inc2++;
						}
						SetPlayerVirtualWorld(i, clan_one);
					}
					case 3:
					{
						if(FoCo_Team[i] == clan_one) {
							SetPlayerPos(i, ClanWar_JeffMtl[inc][0], ClanWar_JeffMtl[inc][1], ClanWar_JeffMtl[inc][2]);
							SetPlayerFacingAngle(i, ClanWar_JeffMtl[inc][3]);
							SetPlayerInterior(i, 15);
							SetPVarInt(i, "CW_TEAM", 1);
							inc++;
						} else {
							SetPlayerPos(i, ClanWar_JeffMtl[inc2+10][0], ClanWar_JeffMtl[inc2+10][1], ClanWar_JeffMtl[inc2+10][2]);
							SetPlayerFacingAngle(i, ClanWar_JeffMtl[inc2+10][3]);
							SetPVarInt(i, "CW_TEAM", 2);
							SetPlayerInterior(i, 15);
							inc2++;
						}
						SetPlayerVirtualWorld(i, clan_one);
					}
					case 4:
					{
						if(FoCo_Team[i] == clan_one) {
							SetPlayerPos(i, ClanWar_LVWar[inc][0], ClanWar_LVWar[inc][1], ClanWar_LVWar[inc][2]);
							SetPlayerFacingAngle(i, ClanWar_LVWar[inc][3]);
							SetPlayerInterior(i, 0);
							SetPVarInt(i, "CW_TEAM", 1);
							inc++;
						} else {
							SetPlayerPos(i, ClanWar_LVWar[inc2+10][0], ClanWar_LVWar[inc2+10][1], ClanWar_LVWar[inc2+10][2]);
							SetPlayerFacingAngle(i, ClanWar_LVWar[inc2+10][3]);
							SetPVarInt(i, "CW_TEAM", 2);
							SetPlayerInterior(i, 0);
							inc2++;
						}
						SetPlayerVirtualWorld(i, clan_one);
					}
					case 5:
					{
						if(FoCo_Team[i] == clan_one) {
							SetPlayerPos(i, ClanWar_maddog[inc][0], ClanWar_maddog[inc][1], ClanWar_maddog[inc][2]);
							SetPlayerFacingAngle(i, ClanWar_maddog[inc][3]);
							SetPlayerInterior(i, 5);
							SetPVarInt(i, "CW_TEAM", 1);
							inc++;
						} else {
							SetPlayerPos(i, ClanWar_maddog[inc2+10][0], ClanWar_maddog[inc2+10][1], ClanWar_maddog[inc2+10][2]);
							SetPlayerFacingAngle(i, ClanWar_maddog[inc2+10][3]);
							SetPlayerInterior(i, 5);
							SetPVarInt(i, "CW_TEAM", 2);
							inc2++;
						}
						SetPlayerVirtualWorld(i, clan_one);
					}
					case 6:
					{
						if(FoCo_Team[i] == clan_one) {
							SetPlayerPos(i, ClanWar_army[inc][0], ClanWar_army[inc][1], ClanWar_army[inc][2]);
							SetPlayerFacingAngle(i, ClanWar_army[inc][3]);
							SetPlayerInterior(i, 0);
							SetPVarInt(i, "CW_TEAM", 1);
							inc++;
						} else {
							SetPlayerPos(i, ClanWar_army[inc2+10][0], ClanWar_army[inc2+10][1], ClanWar_army[inc2+10][2]);
							SetPlayerFacingAngle(i, ClanWar_army[inc2+10][3]);
							SetPlayerInterior(i, 0);
							SetPVarInt(i, "CW_TEAM", 2);
							inc2++;
						}
						SetPlayerVirtualWorld(i, clan_one);
					}
					case 7:
					{
						if(FoCo_Team[i] == clan_one) {
							SetPlayerPos(i, ClanWar_kss[inc][0], ClanWar_kss[inc][1], ClanWar_kss[inc][2]);
							SetPlayerFacingAngle(i, ClanWar_kss[inc][3]);
							SetPVarInt(i, "CW_TEAM", 1);
							SetPlayerInterior(i, 14);
							inc++;
						} else {
							SetPlayerPos(i, ClanWar_kss[inc2+10][0], ClanWar_kss[inc2+10][1], ClanWar_kss[inc2+10][2]);
							SetPlayerFacingAngle(i, ClanWar_kss[inc2+10][3]);
							SetPVarInt(i, "CW_TEAM", 2);
							SetPlayerInterior(i, 14);
							inc2++;
						}
						SetPlayerVirtualWorld(i, clan_one);
					}
					case 8:
					{
						if(FoCo_Team[i] == clan_one) {
							SetPlayerPos(i, ClanWar_Calig[inc][0], ClanWar_Calig[inc][1], ClanWar_Calig[inc][2]);
							SetPlayerFacingAngle(i, ClanWar_Calig[inc][3]);
							SetPVarInt(i, "CW_TEAM", 1);
							inc++;
							SetPlayerInterior(i, 1);
						} else {
							SetPlayerPos(i, ClanWar_Calig[inc2+10][0], ClanWar_Calig[inc2+10][1], ClanWar_Calig[inc2+10][2]);
							SetPlayerFacingAngle(i, ClanWar_Calig[inc2+10][3]);
							SetPVarInt(i, "CW_TEAM", 2);
							SetPlayerInterior(i, 1);
							inc2++;
						}
						SetPlayerVirtualWorld(i, clan_one);
					}
					case 9:
					{	
						if(FoCo_Team[i] == clan_one) {
							SetPlayerPos(i, ClanWar_Meat[inc][0], ClanWar_Meat[inc][1], ClanWar_Meat[inc][2]);
							SetPlayerFacingAngle(i, ClanWar_Meat[inc][3]);
							SetPVarInt(i, "CW_TEAM", 1);
							SetPlayerInterior(i, 1);
							inc++;
						} else {
							SetPlayerPos(i, ClanWar_Meat[inc2+10][0], ClanWar_Meat[inc2+10][1], ClanWar_Meat[inc2+10][2]);
							SetPlayerFacingAngle(i, ClanWar_Meat[inc2+10][3]);
							SetPVarInt(i, "CW_TEAM", 2);
							SetPlayerInterior(i, 1);
							inc2++;
						}
						SetPlayerVirtualWorld(i, clan_one);
					}
					case 10:
					{
						if(FoCo_Team[i] == clan_one) {
							SetPlayerPos(i, ClanWar_SFCar[inc][0], ClanWar_SFCar[inc][1], ClanWar_SFCar[inc][2]);
							SetPlayerFacingAngle(i, ClanWar_SFCar[inc][3]);
							SetPVarInt(i, "CW_TEAM", 1);
							SetPlayerInterior(i, 0);
							inc++;
						} else {
							SetPlayerPos(i, ClanWar_SFCar[inc2+10][0], ClanWar_SFCar[inc2+10][1], ClanWar_SFCar[inc2+10][2]);
							SetPlayerFacingAngle(i, ClanWar_SFCar[inc2+10][3]);
							SetPVarInt(i, "CW_TEAM", 2);
							SetPlayerInterior(i, 0);
							inc2++;
						}
						SetPlayerVirtualWorld(i, clan_one);
					}
				}
				SetPVarInt(i, "AtClanWar", 1);
				SetPlayerArmour(i, 99);
				SetPlayerHealth(i, 99);
				ResetPlayerWeapons(i);
				GiveClanWarWeapons(i, weapons);				
				GameTextForPlayer(i, "~R~~n~~n~ Clan ~h~ War!", 800, 3);
				TextDrawShowForPlayer(i, CW_ScoreTD);
				TextDrawShowForPlayer(i, ClanOneTD[i]);
				TextDrawShowForPlayer(i, ClanTwoTD[i]);
				
				new string[100];
				format(string, sizeof(string), "%s: ~w~0", FoCo_Teams[clan_one][team_name]);
				TextDrawSetString(ClanOneTD[i], string);
				format(string, sizeof(string), "%s: ~w~0", FoCo_Teams[clan_two][team_name]);
				TextDrawSetString(ClanTwoTD[i], string);
			}
		}
	}
	return 1;
}

forward PlayerLeftClanWar(playerid, killerid);
public PlayerLeftClanWar(playerid, killerid)
{
	new string[50];
	SetPVarInt(playerid, "AtClanWar", 0);
	ClanWar_Joining[playerid] = 0;
	
	FoCo_Teams[FoCo_Team[playerid]][team_clanwar_deaths]++;
	FoCo_Teams[FoCo_Teams[FoCo_Team[playerid]][team_clanwar_enemy]][team_clanwar_kills]++;
	
	new count = 0;
	
	foreach(Player, i) 
	{
		if(GetPVarInt(i, "AtClanWar") == 1 && FoCo_Teams[FoCo_Team[i]][team_clanwar_attending] == 1 && FoCo_Teams[FoCo_Team[i]][db_id] == FoCo_Team[playerid]) 
		{
			count++;
		}
		if(FoCo_Teams[FoCo_Team[i]][team_clanwar_attending] == 1 && FoCo_Teams[FoCo_Team[i]][db_id] == FoCo_Team[playerid])
		{
			if(GetPVarInt(playerid, "CW_TEAM") == 1) {
				format(string, sizeof(string), "%s: ~w~%d", FoCo_Teams[FoCo_Team[playerid]][team_name], FoCo_Teams[FoCo_Team[playerid]][team_clanwar_kills]);
				TextDrawSetString(ClanOneTD[i], string);
				format(string, sizeof(string), "%s: ~w~%d", FoCo_Teams[FoCo_Teams[FoCo_Team[playerid]][team_clanwar_enemy]][team_name], FoCo_Teams[FoCo_Teams[FoCo_Team[playerid]][team_clanwar_enemy]][team_clanwar_kills]);
				TextDrawSetString(ClanTwoTD[i], string);
			} else {
				format(string, sizeof(string), "%s: ~w~%d", FoCo_Teams[FoCo_Team[playerid]][team_name], FoCo_Teams[FoCo_Team[playerid]][team_clanwar_kills]);
				TextDrawSetString(ClanTwoTD[i], string);
				format(string, sizeof(string), "%s: ~w~%d", FoCo_Teams[FoCo_Teams[FoCo_Team[playerid]][team_clanwar_enemy]][team_name], FoCo_Teams[FoCo_Teams[FoCo_Team[playerid]][team_clanwar_enemy]][team_clanwar_kills]);
				TextDrawSetString(ClanOneTD[i], string);
			}
		}
		if(FoCo_Teams[FoCo_Teams[FoCo_Team[playerid]][team_clanwar_enemy]][team_clanwar_attending] == 1 && FoCo_Teams[FoCo_Teams[FoCo_Team[playerid]][team_clanwar_enemy]][db_id] == FoCo_Team[i])
		{
			if(GetPVarInt(playerid, "CW_TEAM") == 1) {
				format(string, sizeof(string), "%s: ~w~%d", FoCo_Teams[FoCo_Team[playerid]][team_name], FoCo_Teams[FoCo_Team[playerid]][team_clanwar_kills]);
				TextDrawSetString(ClanOneTD[i], string);
				format(string, sizeof(string), "%s: ~w~%d", FoCo_Teams[FoCo_Teams[FoCo_Team[playerid]][team_clanwar_enemy]][team_name], FoCo_Teams[FoCo_Teams[FoCo_Team[playerid]][team_clanwar_enemy]][team_clanwar_kills]);
				TextDrawSetString(ClanTwoTD[i], string);
			} else {
				format(string, sizeof(string), "%s: ~w~%d", FoCo_Teams[FoCo_Team[playerid]][team_name], FoCo_Teams[FoCo_Team[playerid]][team_clanwar_kills]);
				TextDrawSetString(ClanTwoTD[i], string);
				format(string, sizeof(string), "%s: ~w~%d", FoCo_Teams[FoCo_Teams[FoCo_Team[playerid]][team_clanwar_enemy]][team_name], FoCo_Teams[FoCo_Teams[FoCo_Team[playerid]][team_clanwar_enemy]][team_clanwar_kills]);
				TextDrawSetString(ClanOneTD[i], string);
			}
		}
	}
	SetPVarInt(playerid, "CW_TEAM", 0);
	if(count == 0)
	{
		EndClanWar(FoCo_Team[playerid], FoCo_Teams[FoCo_Team[playerid]][team_clanwar_enemy]);
	}
	return 1;
}

forward EndClanWar(clan_one, clan_two);
public EndClanWar(clan_one, clan_two)
{
	new string[250];
	if(FoCo_Teams[clan_one][team_clanwar_trial] == 1) {
		format(string, sizeof(string), "[Clan Wars]: %s has beat %s in a Trial Team Clan War.", FoCo_Teams[clan_two][team_name], FoCo_Teams[clan_one][team_name]);
		SendClientMessageToAll(COLOR_NOTICE, string);
	}
	else
	{
		format(string, sizeof(string), "[Clan Wars]: %s has beat %s in a Team Clan War.", FoCo_Teams[clan_two][team_name], FoCo_Teams[clan_one][team_name]);
		SendClientMessageToAll(COLOR_NOTICE, string);
		// UPDATE THE DATABASE!!!
		format(string, sizeof(string), "INSERT INTO FoCo_ClanWars (fcw_team_one, fcw_team_two, fcw_team_one_kills, fcw_team_two_kills, fcw_team_one_deaths, fcw_team_two_deaths, fcw_timestamp) VALUES ('%d', '%d', '%d', '%d', '%d', '%d', '%s')", clan_one, clan_two, FoCo_Teams[clan_one][team_clanwar_kills], FoCo_Teams[clan_two][team_clanwar_kills], FoCo_Teams[clan_one][team_clanwar_deaths], FoCo_Teams[clan_two][team_clanwar_deaths], TimeStamp());
		mysql_query(string, MYSQL_INSERT_CW, clan_one, con);
	}
	foreach(Player, i) 
	{
		if(FoCo_Team[i] == clan_one || FoCo_Team[i] == clan_two) {
			if(GetPVarInt(i, "AtClanWar") == 1) {
				SetPlayerPos(i, FoCo_Teams[FoCo_Team[i]][team_spawn_x], FoCo_Teams[FoCo_Team[i]][team_spawn_y], FoCo_Teams[FoCo_Team[i]][team_spawn_z]);
				SetPlayerVirtualWorld(i, 0);
				SetPlayerInterior(i, FoCo_Teams[FoCo_Team[i]][team_spawn_interior]);
				ResetPlayerWeapons(i);
				GiveGuns(i);
				SetPlayerHealth(i, 99);
				TogglePlayerControllable(i, 1);
			}
			SetPVarInt(i, "AtClanWar", 0);
			SetPVarInt(i, "CW_TEAM", 0);
			ClanWar_Clan[i] = 0;
			ClanWar_Members[i] = 0;
			ClanWar_Package[i] = 0;
			ClanWar_Joining[i] = 0;
			ClanWar_Trial[i] = 0;
			FoCo_Teams[FoCo_Team[i]][team_clanwar_members] = 0;
			FoCo_Teams[FoCo_Team[i]][team_clanwar_attending] = 0;
			FoCo_Teams[FoCo_Team[i]][team_clanwar_trial] = 0;
			TextDrawHideForPlayer(i, CW_ScoreTD);
			TextDrawHideForPlayer(i, ClanOneTD[i]);
			TextDrawHideForPlayer(i, ClanTwoTD[i]);
		}
	}
	return 1;
}

stock GiveClanWarWeapons(playerid, weapons)
{
	switch(weapons)
	{
		case 1:
		{
			GivePlayerWeapon(playerid, 24, 500);
		}
		case 2:
		{
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 31, 500);
		}
		case 3:
		{
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 27, 500);
		}
		case 4:
		{
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 27, 500);
			GivePlayerWeapon(playerid, 31, 500);
		}
		case 5:
		{
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 34, 500);
		}
		case 6:
		{
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 32, 500);
		}
		case 7:
		{
			GivePlayerWeapon(playerid, 27, 500);
		}
		case 8:
		{
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 30, 500);
		}
	}
	return 1;
}

/*public ShowModMenu(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid)) return 0;
	new vehmod = 0, moddialogstring[128], mod1 = 0;
	if(IsVehicleValidWheels(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Name])){vehmod = 1;}
	if(IsVehicleValidHydraulics(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Name])){vehmod = 1;}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights1] != 0){vehmod = 1;}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper1] != 0){vehmod = 1;}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper1] != 0){vehmod = 1;}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts1] != 0){vehmod = 1;}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood1] != 0){vehmod = 1;}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop1] != 0){vehmod = 1;}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler1] != 0){vehmod = 1;}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust1] != 0){vehmod = 1;}
	if(vehmod == 0) return 0;
	
	if(IsVehicleValidWheels(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Name]))
	{//Show wheel sub menu on list
		strins(moddialogstring, "Wheels", strlen(moddialogstring));
		mod1 = 1;
	}
	if(IsVehicleValidNOS(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Name]))
	{//Show wheel sub menu on list
		strins(moddialogstring, "\nNitrous Oxide", strlen(moddialogstring));
		mod1 = 1;
	}
	if(IsVehicleValidHydraulics(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Name]))
	{
		if(mod1 == 1){strins(moddialogstring, "\nHydraulics", strlen(moddialogstring));}else strins(moddialogstring, "Hydraulics", strlen(moddialogstring));
		mod1 = 1;
	}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights1] != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\nLights", strlen(moddialogstring));}else strins(moddialogstring, "Lights", strlen(moddialogstring));
		mod1 = 1;
	}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper1] != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\nFront Bumper", strlen(moddialogstring));}else strins(moddialogstring, "Front Bumper", strlen(moddialogstring));
		mod1 = 1;
	}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper1] != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\nRear Bumper", strlen(moddialogstring));}else strins(moddialogstring, "Rear Bumper", strlen(moddialogstring));
		mod1 = 1;
	}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts1] != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\nSide Skirts", strlen(moddialogstring));}else strins(moddialogstring, "Side Skirts", strlen(moddialogstring));
		mod1 = 1;
	}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood1] != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\nHood", strlen(moddialogstring));}else strins(moddialogstring, "Hood", strlen(moddialogstring));
		mod1 = 1;
	}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop1] != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\nRoof Scoop", strlen(moddialogstring));}else strins(moddialogstring, "Roof Scoop", strlen(moddialogstring));
		mod1 = 1;
	}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler1] != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\nSpoiler", strlen(moddialogstring));}else strins(moddialogstring, "Spoiler", strlen(moddialogstring));
		mod1 = 1;
	}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust1] != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\nExhaust", strlen(moddialogstring));}else strins(moddialogstring, "Exhaust", strlen(moddialogstring));
		mod1 = 1;
	}
	if(IsVehicleModified(GetPlayerVehicleID(playerid)))
	{
		strins(moddialogstring, "\n{E31919}Empty Cart", strlen(moddialogstring));
	}
	if(mod1 == 1)
	{
		SetCameraBehindPlayer(playerid);
		strins(moddialogstring, "\n{1EE2E6}Checkout", strlen(moddialogstring));
		ShowPlayerDialog(playerid, DIALOG_CARMOD1, DIALOG_STYLE_LIST, "Vehicle Modification Menu", moddialogstring, "Select", "Cancel");
		TogglePlayerControllable(playerid, 0);
		return 1;
	}
	return 0;
}

public IsVehicleModified(vehicleid)
{
	if(GetVehicleComponentInSlot(vehicleid, CARMODTYPE_NITRO) != 0){return true;}
	else if(GetVehicleComponentInSlot(vehicleid, CARMODTYPE_WHEELS) != 0){return true;}
	else if(GetVehicleComponentInSlot(vehicleid, CARMODTYPE_HYDRAULICS) != 0){return true;}
	else if(GetVehicleComponentInSlot(vehicleid, CARMODTYPE_HYDRAULICS) != 0){return true;}
	else if(GetVehicleComponentInSlot(vehicleid, CARMODTYPE_LAMPS) != 0){return true;}
	else if(GetVehicleComponentInSlot(vehicleid, CARMODTYPE_FRONT_BUMPER) != 0){return true;}
	else if(GetVehicleComponentInSlot(vehicleid, CARMODTYPE_REAR_BUMPER) != 0){return true;}
	else if(GetVehicleComponentInSlot(vehicleid, CARMODTYPE_SIDESKIRT) != 0){return true;}
	else if(GetVehicleComponentInSlot(vehicleid, CARMODTYPE_HOOD) != 0){return true;}
	else if(GetVehicleComponentInSlot(vehicleid, CARMODTYPE_ROOF) != 0){return true;}
	else if(GetVehicleComponentInSlot(vehicleid, CARMODTYPE_SPOILER) != 0){return true;}
	else if(GetVehicleComponentInSlot(vehicleid, CARMODTYPE_EXHAUST) != 0){ return true;}
	else return false;
}

public BackupMods(playerid)
{
	VehBackupArray[playerid][VehID] = GetPlayerVehicleID(playerid);
	VehBackupArray[playerid][NOS] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_NITRO);
	VehBackupArray[playerid][Wheels] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_WHEELS);
	VehBackupArray[playerid][Hydraulics] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_HYDRAULICS);
	VehBackupArray[playerid][Lights] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_LAMPS);
	VehBackupArray[playerid][FBumper] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_FRONT_BUMPER);
	VehBackupArray[playerid][RBumper] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_REAR_BUMPER);
	VehBackupArray[playerid][SideSkirts] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_SIDESKIRT);
	VehBackupArray[playerid][Hood] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_HOOD);
	VehBackupArray[playerid][RoofScoop] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_ROOF);
	VehBackupArray[playerid][Spoiler] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_SPOILER);
	VehBackupArray[playerid][Exhaust] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_EXHAUST);
	return 1;
}

public ExitModMenu(playerid)
{
	if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_NITRO) != 0)
	{
		if(VehBackupArray[playerid][NOS] != 0)
		{
			AddVehicleComponent(GetPlayerVehicleID(playerid), VehBackupArray[playerid][NOS]);
		}
		else RemoveVehicleComponent(GetPlayerVehicleID(playerid), GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_NITRO));
	}
	if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_WHEELS) != 0)
	{
		if(VehBackupArray[playerid][Wheels] != 0)
		{
			AddVehicleComponent(GetPlayerVehicleID(playerid), VehBackupArray[playerid][Wheels]);
		}
		else RemoveVehicleComponent(GetPlayerVehicleID(playerid), GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_WHEELS));
	}
	if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_HYDRAULICS) != 0)
	{
		if(VehBackupArray[playerid][Hydraulics] != 0)
		{
			AddVehicleComponent(GetPlayerVehicleID(playerid), VehBackupArray[playerid][Hydraulics]);
		}
		else RemoveVehicleComponent(GetPlayerVehicleID(playerid), GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_HYDRAULICS));
	}
	if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_LAMPS) != 0)
	{
		if(VehBackupArray[playerid][Lights] != 0)
		{
			AddVehicleComponent(GetPlayerVehicleID(playerid), VehBackupArray[playerid][Lights]);
		}
		else RemoveVehicleComponent(GetPlayerVehicleID(playerid), GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_LAMPS));
	}
	if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_FRONT_BUMPER) != 0)
	{
		if(VehBackupArray[playerid][FBumper] != 0)
		{
			AddVehicleComponent(GetPlayerVehicleID(playerid), VehBackupArray[playerid][FBumper]);
		}
		else RemoveVehicleComponent(GetPlayerVehicleID(playerid), GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_FRONT_BUMPER));
	}
	if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_REAR_BUMPER) != 0)
	{
		if(VehBackupArray[playerid][RBumper] != 0)
		{
			AddVehicleComponent(GetPlayerVehicleID(playerid), VehBackupArray[playerid][RBumper]);
		}
		else RemoveVehicleComponent(GetPlayerVehicleID(playerid), GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_REAR_BUMPER));
	}
	if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_SIDESKIRT) != 0)
	{
		if(VehBackupArray[playerid][SideSkirts] != 0)
		{
			AddVehicleComponent(GetPlayerVehicleID(playerid), VehBackupArray[playerid][SideSkirts]);
		}
		else RemoveVehicleComponent(GetPlayerVehicleID(playerid), GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_SIDESKIRT));
	}
	if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_HOOD) != 0)
	{
		if(VehBackupArray[playerid][Hood] != 0)
		{
			AddVehicleComponent(GetPlayerVehicleID(playerid), VehBackupArray[playerid][Hood]);
		}
		else RemoveVehicleComponent(GetPlayerVehicleID(playerid), GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_HOOD));
	}
	if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_ROOF) != 0)
	{
		if(VehBackupArray[playerid][RoofScoop] != 0)
		{
			AddVehicleComponent(GetPlayerVehicleID(playerid), VehBackupArray[playerid][RoofScoop]);
		}
		else RemoveVehicleComponent(GetPlayerVehicleID(playerid), GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_ROOF));
	}
	if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_SPOILER) != 0)
	{
		if(VehBackupArray[playerid][Spoiler] != 0)
		{
			AddVehicleComponent(GetPlayerVehicleID(playerid), VehBackupArray[playerid][Spoiler]);
		}
		else RemoveVehicleComponent(GetPlayerVehicleID(playerid), GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_SPOILER));
	}
	if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_EXHAUST) != 0)
	{
		if(VehBackupArray[playerid][Exhaust] != 0)
		{
			AddVehicleComponent(GetPlayerVehicleID(playerid), VehBackupArray[playerid][Exhaust]);
		}
		else RemoveVehicleComponent(GetPlayerVehicleID(playerid), GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_EXHAUST));
	}
	VehBackupArray[playerid][VehID] = 0;
	VehBackupArray[playerid][NOS] = 0;
	VehBackupArray[playerid][Wheels] = 0;
	VehBackupArray[playerid][Hydraulics] = 0;
	VehBackupArray[playerid][Lights] = 0;
	VehBackupArray[playerid][FBumper] = 0;
	VehBackupArray[playerid][RBumper] = 0;
	VehBackupArray[playerid][SideSkirts] = 0;
	VehBackupArray[playerid][Hood] = 0;
	VehBackupArray[playerid][RoofScoop] = 0;
	VehBackupArray[playerid][Spoiler] = 0;
	VehBackupArray[playerid][Exhaust] = 0;
	TogglePlayerControllable(playerid, 1);
	TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
	ModdingCar[playerid] = 0;
	ModPosition[playerid] = 0;
	SetCameraBehindPlayer(playerid);
	return 1;
}

public ModInteruptSave(playerid)
{
	if(GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_NITRO) != 0)
	{
		if(VehBackupArray[playerid][NOS] != 0)
		{
			AddVehicleComponent(VehBackupArray[playerid][VehID], VehBackupArray[playerid][NOS]);
		}
		else RemoveVehicleComponent(VehBackupArray[playerid][VehID], GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_NITRO));
	}
	if(GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_WHEELS) != 0)
	{
		if(VehBackupArray[playerid][Wheels] != 0)
		{
			AddVehicleComponent(VehBackupArray[playerid][VehID], VehBackupArray[playerid][Wheels]);
		}
		else RemoveVehicleComponent(VehBackupArray[playerid][VehID], GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_WHEELS));
	}
	if(GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_HYDRAULICS) != 0)
	{
		if(VehBackupArray[playerid][Hydraulics] != 0)
		{
			AddVehicleComponent(VehBackupArray[playerid][VehID], VehBackupArray[playerid][Hydraulics]);
		}
		else RemoveVehicleComponent(VehBackupArray[playerid][VehID], GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_HYDRAULICS));
	}
	if(GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_LAMPS) != 0)
	{
		if(VehBackupArray[playerid][Lights] != 0)
		{
			AddVehicleComponent(VehBackupArray[playerid][VehID], VehBackupArray[playerid][Lights]);
		}
		else RemoveVehicleComponent(VehBackupArray[playerid][VehID], GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_LAMPS));
	}
	if(GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_FRONT_BUMPER) != 0)
	{
		if(VehBackupArray[playerid][FBumper] != 0)
		{
			AddVehicleComponent(VehBackupArray[playerid][VehID], VehBackupArray[playerid][FBumper]);
		}
		else RemoveVehicleComponent(VehBackupArray[playerid][VehID], GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_FRONT_BUMPER));
	}
	if(GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_REAR_BUMPER) != 0)
	{
		if(VehBackupArray[playerid][RBumper] != 0)
		{
			AddVehicleComponent(VehBackupArray[playerid][VehID], VehBackupArray[playerid][RBumper]);
		}
		else RemoveVehicleComponent(VehBackupArray[playerid][VehID], GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_REAR_BUMPER));
	}
	if(GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_SIDESKIRT) != 0)
	{
		if(VehBackupArray[playerid][SideSkirts] != 0)
		{
			AddVehicleComponent(VehBackupArray[playerid][VehID], VehBackupArray[playerid][SideSkirts]);
		}
		else RemoveVehicleComponent(VehBackupArray[playerid][VehID], GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_SIDESKIRT));
	}
	if(GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_HOOD) != 0)
	{
		if(VehBackupArray[playerid][Hood] != 0)
		{
			AddVehicleComponent(VehBackupArray[playerid][VehID], VehBackupArray[playerid][Hood]);
		}
		else RemoveVehicleComponent(VehBackupArray[playerid][VehID], GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_HOOD));
	}
	if(GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_ROOF) != 0)
	{
		if(VehBackupArray[playerid][RoofScoop] != 0)
		{
			AddVehicleComponent(VehBackupArray[playerid][VehID], VehBackupArray[playerid][RoofScoop]);
		}
		else RemoveVehicleComponent(VehBackupArray[playerid][VehID], GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_ROOF));
	}
	if(GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_SPOILER) != 0)
	{
		if(VehBackupArray[playerid][Spoiler] != 0)
		{
			AddVehicleComponent(VehBackupArray[playerid][VehID], VehBackupArray[playerid][Spoiler]);
		}
		else RemoveVehicleComponent(VehBackupArray[playerid][VehID], GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_SPOILER));
	}
	if(GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_EXHAUST) != 0)
	{
		if(VehBackupArray[playerid][Exhaust] != 0)
		{
			AddVehicleComponent(VehBackupArray[playerid][VehID], VehBackupArray[playerid][Exhaust]);
		}
		else RemoveVehicleComponent(VehBackupArray[playerid][VehID], GetVehicleComponentInSlot(VehBackupArray[playerid][VehID], CARMODTYPE_EXHAUST));
	}
	VehBackupArray[playerid][VehID] = 0;
	VehBackupArray[playerid][NOS] = 0;
	VehBackupArray[playerid][Wheels] = 0;
	VehBackupArray[playerid][Hydraulics] = 0;
	VehBackupArray[playerid][Lights] = 0;
	VehBackupArray[playerid][FBumper] = 0;
	VehBackupArray[playerid][RBumper] = 0;
	VehBackupArray[playerid][SideSkirts] = 0;
	VehBackupArray[playerid][Hood] = 0;
	VehBackupArray[playerid][RoofScoop] = 0;
	VehBackupArray[playerid][Spoiler] = 0;
	VehBackupArray[playerid][Exhaust] = 0;
	TogglePlayerControllable(playerid, 1);
	TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
	ModdingCar[playerid] = 0;
	ModPosition[playerid] = 0;
	SetCameraBehindPlayer(playerid);
	return 1;
}*/

stock GetVehicleModelIDFromName(vehname[])
{
	for(new i = 0; i < 211; i++)
	{
		if (strfind(VehNames[i][Name], vehname, true) != -1) return i + 400;
	}
	return -1;
}

stock special_mods_add(vehid)
{
	new model = GetVehicleModel(vehid);	
	switch(model)
	{
		case 560:  // sultan
		{
			AddVehicleComponent(vehid, 1010); 
			AddVehicleComponent(vehid, 1026); 
			AddVehicleComponent(vehid, 1029); 
			AddVehicleComponent(vehid, 1033); 
			AddVehicleComponent(vehid, 1139); 
			AddVehicleComponent(vehid, 1170); 
			AddVehicleComponent(vehid, 1140);
			ChangeVehiclePaintjob(vehid, 1);
		}
		case 562:  // elegy
		{
			AddVehicleComponent(vehid, 1010); 
			AddVehicleComponent(vehid, 1148); 
			AddVehicleComponent(vehid, 1146); 
			AddVehicleComponent(vehid, 1172); 
			AddVehicleComponent(vehid, 1037); 
			AddVehicleComponent(vehid, 1038); 
			AddVehicleComponent(vehid, 1039);
			ChangeVehiclePaintjob(vehid, 0);
		}
		case 558:  // uranus
		{
			AddVehicleComponent(vehid, 1010); 
			AddVehicleComponent(vehid, 1167); 
			AddVehicleComponent(vehid, 1168); 
			AddVehicleComponent(vehid, 1164); 
			AddVehicleComponent(vehid, 1091); 
			AddVehicleComponent(vehid, 1092); 
			AddVehicleComponent(vehid, 1094);
			AddVehicleComponent(vehid, 1165);
			ChangeVehiclePaintjob(vehid, 2);
		}
		case 559:  // jester
		{
			AddVehicleComponent(vehid, 1010); 
			AddVehicleComponent(vehid, 1173); 
			AddVehicleComponent(vehid, 1160); 
			AddVehicleComponent(vehid, 1159); 
			AddVehicleComponent(vehid, 1162); 
			AddVehicleComponent(vehid, 1066); 
			AddVehicleComponent(vehid, 1067); 
			ChangeVehiclePaintjob(vehid, 1);
		}
		case 561:  // stratum
		{
			AddVehicleComponent(vehid, 1010); 
			AddVehicleComponent(vehid, 1056); 
			AddVehicleComponent(vehid, 1058); 
			AddVehicleComponent(vehid, 1061); 
			AddVehicleComponent(vehid, 1062); 
			AddVehicleComponent(vehid, 1064);
			AddVehicleComponent(vehid, 1156);
			AddVehicleComponent(vehid, 1157);
			ChangeVehiclePaintjob(vehid, 1);
		}
		case 536: // blade
		{
			AddVehicleComponent(vehid, 1010); 
			AddVehicleComponent(vehid, 1103); 
			AddVehicleComponent(vehid, 1105); 
			AddVehicleComponent(vehid, 1106); 
			AddVehicleComponent(vehid, 1108);
			ChangeVehiclePaintjob(vehid, 1);
		}
		case 535: // slamvan
		{
			AddVehicleComponent(vehid, 1010); 
			AddVehicleComponent(vehid, 1113); 
			AddVehicleComponent(vehid, 1115); 
			AddVehicleComponent(vehid, 1117); 
			AddVehicleComponent(vehid, 1118);
			ChangeVehiclePaintjob(vehid, 2);
		}
		case 565: // Flash
		{
			AddVehicleComponent(vehid, 1010); 
			AddVehicleComponent(vehid, 1045); 
			AddVehicleComponent(vehid, 1048); 
			AddVehicleComponent(vehid, 1050); 
			AddVehicleComponent(vehid, 1052); 
			AddVehicleComponent(vehid, 1053);
			ChangeVehiclePaintjob(vehid, 1);
		}
	}
	return 1;
}

forward StopDeathSpectate(playerid, killerid);
public StopDeathSpectate(playerid, killerid) 
{
	TogglePlayerSpectating(playerid, 0);
//	if(FoCo_Event == 15 && CEM[Rejoinable]==1) RejoinCEvent(playerid);
	return 1;
}

stock Class_Weapons(playerid, val)
{
	new itemStr[500];
	format(itemStr, sizeof(itemStr), "0 - Reset Weapon.");
	for(new i = 1; i < sizeof(class_slots); i++)
	{
		if(class_slots[i][1] == val)
		{
			if(FoCo_Player[playerid][level] >= class_slots[i][2] && class_slots[i][2] < 11)
			{
				format(itemStr, sizeof(itemStr), "%s\n%d - %s", itemStr, class_slots[i][0], WeapNames[class_slots[i][0]]);
			}
		}
	}
	return itemStr;
}

stock GiveGuns(playerid)
{
	if(GetPVarInt(playerid, "InEvent") == 1) 
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't use this command while being in an event.");
	}
	
	DeleteAllAttachedWeapons(playerid);
	ResetPlayerWeapons(playerid);

	if(gettime() > GetPVarInt(playerid, "healtime") + 600)
	{
		SetPlayerHealth(playerid, 99);
		SetPVarInt(playerid, "healtime", gettime());
	}
	if(isVIP(playerid) < 1 && AdminLvl(playerid) < 1)
	{
	    new INT_MELEE_AMMO = floatround(MELEE_AMMO_ONSPAWN,floatround_floor);
		new INT_HANDGUN_AMMO = floatround(HANDGUN_AMMO_ONSPAWN, floatround_floor);
		new INT_SUBMACHINEGUN_AMMO = floatround(SUBMACHINEGUN_AMMO_ONSPAWN, floatround_floor);
		new INT_ASSAULTRIFLE_AMMO = floatround(ASSAULTRIFLE_AMMO_ONSPAWN, floatround_floor);
		new INT_RIFLE_AMMO = floatround(RIFLE_AMMO_ONSPAWN, floatround_floor);
		GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_melee], INT_MELEE_AMMO);
		GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_handguns], INT_HANDGUN_AMMO);
		GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_shotguns], INT_SUBMACHINEGUN_AMMO);
		GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_submachine], INT_SUBMACHINEGUN_AMMO);
		GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_assault], INT_ASSAULTRIFLE_AMMO);
		GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_rifle], INT_RIFLE_AMMO);
	}
	else
	{
		if(isVIP(playerid) == 3 || AdminLvl(playerid) >= ACMD_GOLD)
		{
		    new INT_MELEE_AMMO = floatround(MELEE_AMMO_ONSPAWN,floatround_floor);
		    new GOLD_HANDGUN = floatround(Float:HANDGUN_AMMO_ONSPAWN * Float:EXTRA_GOLD_AMMO, floatround_round);
			new GOLD_SHOTGUN = floatround(Float:SHOTGUN_AMMO_ONSPAWN * Float:EXTRA_GOLD_AMMO, floatround_round);
			new GOLD_SUBMACHINEGUN = floatround(Float:SUBMACHINEGUN_AMMO_ONSPAWN * Float:EXTRA_GOLD_AMMO, floatround_round);
			new GOLD_ASSAULTRIFLE = floatround(Float:ASSAULTRIFLE_AMMO_ONSPAWN * Float:EXTRA_GOLD_AMMO, floatround_round);
			new GOLD_RIFLE = floatround(Float:RIFLE_AMMO_ONSPAWN * Float:EXTRA_GOLD_AMMO, floatround_round);
			GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_melee], INT_MELEE_AMMO);
		    GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_handguns], GOLD_HANDGUN);
	    	GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_shotguns], GOLD_SHOTGUN);
	    	GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_submachine], GOLD_SUBMACHINEGUN);
	    	GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_assault], GOLD_ASSAULTRIFLE);
	    	GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_rifle], GOLD_RIFLE);
		}
		else if(isVIP(playerid) == 2 || AdminLvl(playerid) >= ACMD_SILVER)
		{
		    new INT_MELEE_AMMO = floatround(MELEE_AMMO_ONSPAWN,floatround_floor);
			new SILVER_HANDGUN = floatround(Float:HANDGUN_AMMO_ONSPAWN * Float:EXTRA_SILVER_AMMO, floatround_round);
			new SILVER_SHOTGUN = floatround(Float:SHOTGUN_AMMO_ONSPAWN * Float:EXTRA_SILVER_AMMO, floatround_round);
			new SILVER_SUBMACHINEGUN = floatround(Float:SUBMACHINEGUN_AMMO_ONSPAWN * Float:EXTRA_SILVER_AMMO, floatround_round);
			new SILVER_ASSAULTRIFLE = floatround(Float:ASSAULTRIFLE_AMMO_ONSPAWN * Float:EXTRA_SILVER_AMMO, floatround_round);
			new SILVER_RIFLE = floatround(Float:RIFLE_AMMO_ONSPAWN * Float:EXTRA_SILVER_AMMO, floatround_round);
			GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_melee], INT_MELEE_AMMO);
   			GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_handguns], SILVER_HANDGUN);
	    	GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_shotguns], SILVER_SHOTGUN);
	    	GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_submachine], SILVER_SUBMACHINEGUN);
	    	GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_assault], SILVER_ASSAULTRIFLE);
	    	GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_rifle], SILVER_RIFLE);
		}
		else if(isVIP(playerid) == 1 || AdminLvl(playerid) >= ACMD_BRONZE)
		{
		    new INT_MELEE_AMMO = floatround(MELEE_AMMO_ONSPAWN,floatround_floor);
		    new BRONZE_HANDGUN = floatround(Float:HANDGUN_AMMO_ONSPAWN * Float:EXTRA_BRONZE_AMMO, floatround_round);
			new BRONZE_SHOTGUN = floatround(Float:SHOTGUN_AMMO_ONSPAWN * Float:EXTRA_BRONZE_AMMO, floatround_round);
			new BRONZE_SUBMACHINEGUN = floatround(Float:SUBMACHINEGUN_AMMO_ONSPAWN * Float:EXTRA_BRONZE_AMMO, floatround_round);
			new BRONZE_ASSAULTRIFLE = floatround(Float:ASSAULTRIFLE_AMMO_ONSPAWN * Float:EXTRA_BRONZE_AMMO, floatround_round);
			new BRONZE_RIFLE = floatround(Float:RIFLE_AMMO_ONSPAWN * Float:EXTRA_BRONZE_AMMO, floatround_round);
			GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_melee], INT_MELEE_AMMO);
   			GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_handguns], BRONZE_HANDGUN);
	    	GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_shotguns], BRONZE_SHOTGUN);
	    	GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_submachine], BRONZE_SUBMACHINEGUN);
	    	GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_assault], BRONZE_ASSAULTRIFLE);
	    	GivePlayerWeapon(playerid, FoCo_Classes[playerid][fc_rifle], BRONZE_RIFLE);
		}
		else
		{
		    return 1;
		}
	}
	
	return 1;
}

stock isVIP(playerid) 
{
	new tmpvip;
	tmpvip = FoCo_Donations[playerid][dtype];
	return tmpvip;
}

stock ValidNC(playerid)
{
	new tmpnc;
	tmpnc = FoCo_Player[playerid][nchanges];
	return tmpnc;
}

stock nullvip(playerid)
{
	FoCo_Donations[playerid][did] = 0;
	FoCo_Donations[playerid][dpid] = 0;
	FoCo_Donations[playerid][dbuy] = 0;
	FoCo_Donations[playerid][dexp] = 0;
	FoCo_Donations[playerid][dtype] = 0;
	FoCo_Donations[playerid][dcar1] = 0;
	FoCo_Donations[playerid][dcar2] = 0;
	FoCo_Donations[playerid][dcar3] = 0;
	return 1;
}

stock nullcar(vehid)
{
	FoCo_Vehicles[vehid][cid] = 0;
	FoCo_Vehicles[vehid][cmodel] = 0;
	FoCo_Vehicles[vehid][cx] = 0.0;
	FoCo_Vehicles[vehid][cy] = 0.0;
	FoCo_Vehicles[vehid][cz] = 0.0;
	FoCo_Vehicles[vehid][cangle] = 0.0;
	FoCo_Vehicles[vehid][ccol1] = 0;
	FoCo_Vehicles[vehid][ccol2] = 0;
    FoCo_Vehicles[vehid][coid] = 0;
	FoCo_Vehicles[vehid][cvw] = 0;
	FoCo_Vehicles[vehid][cint] = 0;
	FoCo_Vehicles[vehid][special_mod] = 0;
	FoCo_Vehicles[vehid][coid] = VEHICLE_TYPE_TEMPORARY;
	return 1;
}

stock TimeStamp()
{
	new stamp[256];
	new yyear,mmonth,dday,hhour,mmin;
	gettime(hhour,mmin);
	getdate(yyear,mmonth,dday);
	format(stamp, sizeof(stamp), "%02d/%02d/%02d - %02d:%02d",mmonth,dday,yyear,hhour,mmin);
	return stamp;
}

stock GetLocation(location)
{
	new string[50];
	switch(location)
	{
		case 1:
		{
			format(string, sizeof(string), "Area 59");
		}
		case 2:
		{
			format(string, sizeof(string), "RC Battleground");
		}
		case 3:
		{
			format(string, sizeof(string), "Jefferson Motel");
		}
		case 4:
		{
			format(string, sizeof(string), "LV Warehouse");
		}
		case 5:
		{
			format(string, sizeof(string), "Mad Doggs");
		}
		case 6:
		{
			format(string, sizeof(string), "Army Vs Terrorists");
		}
		case 7:
		{
			format(string, sizeof(string), "KickStart Stadium");
		}
		case 8:
		{
			format(string, sizeof(string), "Caligulas Basement");
		}
		case 9:
		{
			format(string, sizeof(string), "Meat Factory");
		}
		case 10:
		{
			format(string, sizeof(string), "SF Carrier");
		}
	}
	return string;
}

forward CheckLevel(pid);
public CheckLevel(pid)
{
	if(FoCo_Playerstats[pid][kills] < RANK_ONE)
	{
		FoCo_Player[pid][level] = 0;
		return 1;
	}
	if(FoCo_Playerstats[pid][kills] >= RANK_ONE && FoCo_Playerstats[pid][kills] < RANK_TWO)
	{
		FoCo_Player[pid][level] = 1;
		return 1;
	}
	if(FoCo_Playerstats[pid][kills] >= RANK_TWO && FoCo_Playerstats[pid][kills] < RANK_THREE)
	{
		FoCo_Player[pid][level] = 2;
		return 1;
	}
	if(FoCo_Playerstats[pid][kills] >= RANK_THREE && FoCo_Playerstats[pid][kills] < RANK_FOUR)
	{
		FoCo_Player[pid][level] = 3;
		return 1;
	}
	if(FoCo_Playerstats[pid][kills] >= RANK_FOUR && FoCo_Playerstats[pid][kills] < RANK_FIVE)
	{
		FoCo_Player[pid][level] = 4;
		return 1;
	}
	if(FoCo_Playerstats[pid][kills] >= RANK_FIVE && FoCo_Playerstats[pid][kills] < RANK_SIX)
	{
		FoCo_Player[pid][level] = 5;
		return 1;
	}
	if(FoCo_Playerstats[pid][kills] >= RANK_SIX && FoCo_Playerstats[pid][kills] < RANK_SEVEN)
	{
		FoCo_Player[pid][level] = 6;
		return 1;
	}
	if(FoCo_Playerstats[pid][kills] >= RANK_SEVEN && FoCo_Playerstats[pid][kills] < RANK_EIGHT)
	{
		FoCo_Player[pid][level] = 7;
		return 1;
	}
	if(FoCo_Playerstats[pid][kills] >= RANK_EIGHT && FoCo_Playerstats[pid][kills] < RANK_NINE)
	{
		FoCo_Player[pid][level] = 8;
		return 1;
	}
	if(FoCo_Playerstats[pid][kills] >= RANK_NINE && FoCo_Playerstats[pid][kills] < RANK_TEN)
	{
		FoCo_Player[pid][level] = 9;
		return 1;
	}
	if(FoCo_Playerstats[pid][kills] >= RANK_TEN)
	{
		FoCo_Player[pid][level] = 10;
		return 1;
	}
	return 1;
}

stock TimerOnline(timeGiven, switchStatus)
{
    new Days, Hours, Mins, Secs, string[180];
     
    Days = floatround((timeGiven / 86400), floatround_floor); 
    Secs = (timeGiven - (Days * 86400));
    Hours = floatround((Secs / 3600), floatround_floor);
    Secs = (Secs - (Hours * 3600)); 
    Mins = floatround((Secs / 60), floatround_floor);
    Secs = (Secs - (Mins * 60));
	
	switch(switchStatus)
	{
		case 0:
		{
			format(string, sizeof(string), "User has spent (%d) days - (%d) hours - (%d) minutes - (%d) seconds online.", Days, Hours, Mins, Secs);
		}
		case 1:
		{
			format(string, sizeof(string), "Admin Time: (%d) days - (%d) hours - (%d) minutes - (%d) seconds.", Days, Hours, Mins, Secs); 		
		}
	}
	return string;
}

/*public OneMinuteTimer()
{
    foreach(Player,i)
    {
        if(GetPVarInt(i, "PlayerStatus") == 3)
        {
	    	if(FoCo_Player[i][admin] < 1)
	    	{
	    	    if(gettime() > GetPVarInt(i, "afktime")+60000)
	    	    {
		    	    new string[256],kickstring[256];
			   		format(string, sizeof(string), "[AdmCMD]: Auto-Kick has kicked %s(%d), Reason: AFK", PlayerName(i), i);
					SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
					format(kickstring, sizeof(kickstring), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', 'Auto-Kick', '2', 'AFK [Auto-Kick]', '%s')", FoCo_Player[i][id],TimeStamp());
					mysql_query(kickstring, MYSQL_THREAD_ADMINRECORD_INSERT);
					Kick(i);
				}
			}
			else if(FoCo_Player[i][admin] >= 1 && FoCo_Player[i][admin] < 5)
			{
	    	    if(gettime() > GetPVarInt(i, "afktime")+90000)
	    	    {
		    	    new string[256],kickstring[256];
			   		format(string, sizeof(string), "[AdmCMD]: Auto-Kick has kicked %s(%d), Reason: AFK", PlayerName(i), i);
					SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
					format(kickstring, sizeof(kickstring), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', 'Auto-Kick', '2', 'AFK [Auto-Kick]', '%s')", FoCo_Player[i][id],TimeStamp());
					mysql_query(kickstring, MYSQL_THREAD_ADMINRECORD_INSERT);
					Kick(i);
				}
			}
		}
	}
	
	return 1;
}
*/
/*
public OneSecondTimer()
{
	Event_OneSecond();
	
	endroundtimer --;
	randommessagetimer ++;
	
	if(countdown != -1)
	{
		new string[10];
		if(countdown == 0)
		{
			format(string, sizeof(string), "BEGIN!");
			countdown = -1;
		}
		else
		{
			countdown--;
			format(string, sizeof(string), "%d", countdown);
		}
		GameTextForAll(string, 400, 3);
	}
	foreach (Player, i)
	{
		if(GetPlayerPing(i) >= 450 && GetPlayerPing(i) != 65535 && FoCo_Player[i][admin] == 0)
		{
			SetPVarInt(i, "pingkick", (GetPVarInt(i, "pingkick")+1));
			
			if(GetPVarInt(i, "pingkick") > 30)
			{
				SendClientMessage(i,COLOR_WARNING,"Kicked [HIGH PING LIMIT EXCEEDED]");
				new string[128];
				format(string, sizeof(string), "[PING KICK]: %s has been kicked for exceeding 450 ping for 30+ seconds.", PlayerName(i));
				SendClientMessageToAll(COLOR_NOTICE, string);
				Kick(i);
			}
		}
		else
		{
			SetPVarInt(i, "pingkick", 0);
		}
		if(spawnSeconds[i] != -1)
		{
			new string[128];
			if(IsPlayerConnected(lastKiller[i]))
			{
				if(lastKillReason[i] > 45 && lastKillReason[i] < 0)
				{
					lastKillReason[i] = 0;
				}
				if(spawnSeconds[i] < 6 && spawnSeconds[i] > 2)
				{
					format(string, sizeof(string), "~b~~h~~h~You were killed by ~y~~h~%s~b~~h~~h~ with a ~y~~h~%s~b~~h~~h~, respawning ~y~%d seconds..", PlayerName(lastKiller[i]), WeapNames[lastKillReason[i]][WeapName], spawnSeconds[i]-1);
				} 
				else if(spawnSeconds[i] < 3)
				{
					format(string, sizeof(string), "~b~~h~~h~You were killed by ~y~~h~%s~b~~h~~h~ with a ~y~~h~%s~b~~h~~h~, respawning ~g~~h~%d seconds..", PlayerName(lastKiller[i]), WeapNames[lastKillReason[i]][WeapName], spawnSeconds[i]-1);
				}
				else
				{
					format(string, sizeof(string), "~b~~h~~h~You were killed by ~y~~h~%s~b~~h~~h~ with a ~y~~h~%s~b~~h~~h~, respawning ~r~~h~%d seconds..", PlayerName(lastKiller[i]), WeapNames[lastKillReason[i]][WeapName], spawnSeconds[i]-1);
				}
			}
			else
			{
				format(string, sizeof(string), "~b~~h~~h~Your last killer has logged off, respawning ~r~~h~%d seconds..", spawnSeconds[i]-1);
			}
			
			TextDrawSetString(KillTD[i], string);
			if(spawnSeconds[i] <= 1) 
			{
				spawnSeconds[i] = -1;
				TextDrawSetString(KillTD[i], " ");
				TextDrawHideForPlayer(i, KillTD[i]);
			} 
			else
			{
				spawnSeconds[i]--;
			}
		}
		
		FoCo_Player[i][onlinetime]++;
		if(ADuty[i] != 0)
		{
			FoCo_Player[i][admintime]++;
			AdutyTimer[i]++;
		}
		if(surfdeath[i] > 0) surfdeath[i] --;
		else if(surfdeath[i] == 0)
		{
			surfdeath[i] = -1;
			SetPlayerHealth(i, 100.0);
		}
		if(FoCo_Player[i][jailed] > 0)
		{
			FoCo_Player[i][jailed] --;
			if(FoCo_Player[i][jailed]  <= 0)
			{
				TogglePlayerControllable(i, 1);
				SpawnPlayer(i);
				FoCo_Player[i][jailed] = 0;
				SetPlayerInterior(i, 0);
				SendClientMessage(i, COLOR_NOTICE, "[NOTICE]: You are now free to enjoy the server, try not to break any rules!");
			}
		}
		if(AchievementTimer[i] > 0)
		{
			AchievementTimer[i] --;
			if(AchievementTimer[i] == 0)
			{
				TextDrawHideForPlayer(i, AchieveBoxTD);
				TextDrawHideForPlayer(i, AchieveInfoTD[i]);
				TextDrawHideForPlayer(i, AchieveAqcTD);
				TextDrawHideForPlayer(i, AchieveFoCoTD);
			}
		}
	}
	if(randommessagetimer == 120)
	{
		randommessagetimer = 0;
		new i = random(11);
		SendClientMessageToAll(COLOR_BLUE, RandomMessages[i]);
	}
	if(endroundtimer == 1)
	{
		SendRconCommand("gmx");
	}
	return 1;
}*/

timer EndRoundTimer[30000]()
{
	SendRconCommand("gmx");
}

task randomMessage[120000]()
{
	new i = random(MAX_RNDMSGS);
	SendClientMessageToAll(COLOR_BLUE, RandomMessages[i]);
}

timer CountdownTimer[1000]()
{
	new string[10];
	if(countdown == 0)
	{
		format(string, sizeof(string), "BEGIN!");
		stop CountDownTimer;
	}
	else
	{
		countdown--;
		format(string, sizeof(string), "%d", countdown);
	}
	GameTextForAll(string, 400, 3);
}

ptask PingKick[1000](playerid)
{
	if(GetPlayerPing(playerid) >= 450 && GetPlayerPing(playerid) != 65535 && FoCo_Player[playerid][admin] == 0)
	{
		SetPVarInt(playerid, "pingkick", (GetPVarInt(playerid, "pingkick")+1));
		
		if(GetPVarInt(playerid, "pingkick") > 30)
		{
			SendClientMessage(playerid,COLOR_WARNING,"Kicked [HIGH PING LIMIT EXCEEDED]");
			new string[128];
			format(string, sizeof(string), "[PING KICK]: %s has been kicked for exceeding 450 ping for 30+ seconds.", PlayerName(playerid));
			SendClientMessageToAll(COLOR_NOTICE, string);
			Kick(playerid);
		}
	}
	else
	{
		SetPVarInt(playerid, "pingkick", 0);
	}
}

ptask OnlineTime[1000](playerid)
{
	FoCo_Player[playerid][onlinetime]++;
	if(ADuty[playerid] != 0)
	{
		FoCo_Player[playerid][admintime]++;
		AdutyTimer[playerid]++;
	}
}

stock EndSpecTimer(playerid)
{
	if(DeathCamTimer[playerid] != Spec_TimerFix)
	{
	    TextDrawSetString(KillTD[playerid], " ");
		TextDrawHideForPlayer(playerid, KillTD[playerid]);
	    stop DeathCamTimer[playerid];
	    spawnSeconds[playerid] = -1;
		DeathCamTimer[playerid] = Spec_TimerFix;
	}
	return 1;
}

timer SpawnSeconds[1000](playerid)
{
    new string[128];
	if(IsPlayerConnected(lastKiller[playerid]))
	{
		if(lastKillReason[playerid] > 45 && lastKillReason[playerid] < 0)
		{
			lastKillReason[playerid] = 0;
		}
		#if defined SERVERSIDED_HP
		if(spawnSeconds[playerid] > 5)
			PlayerSpectatePlayer(playerid, LastShotAtPlayer[playerid][SAD_Shooter]);
		#endif
		if(spawnSeconds[playerid] < 6 && spawnSeconds[playerid] > 2)
		{
			format(string, sizeof(string), "~b~~h~~h~You were killed by ~y~~h~%s~b~~h~~h~ with a ~y~~h~%s~b~~h~~h~, respawning ~y~%d seconds..", PlayerName(lastKiller[playerid]), WeapNames[lastKillReason[playerid]][WeapName], spawnSeconds[playerid]-1);
		}
		else if(spawnSeconds[playerid] < 3)
		{
			format(string, sizeof(string), "~b~~h~~h~You were killed by ~y~~h~%s~b~~h~~h~ with a ~y~~h~%s~b~~h~~h~, respawning ~g~~h~%d seconds..", PlayerName(lastKiller[playerid]), WeapNames[lastKillReason[playerid]][WeapName], spawnSeconds[playerid]-1);
		}
		else
		{
			format(string, sizeof(string), "~b~~h~~h~You were killed by ~y~~h~%s~b~~h~~h~ with a ~y~~h~%s~b~~h~~h~, respawning ~r~~h~%d seconds..", PlayerName(lastKiller[playerid]), WeapNames[lastKillReason[playerid]][WeapName], spawnSeconds[playerid]-1);
		}
	}
	else
	{
		format(string, sizeof(string), "~b~~h~~h~Your last killer has logged off, respawning ~r~~h~%d seconds..", spawnSeconds[playerid]-1);
	}
	TextDrawSetString(KillTD[playerid], string);
	//Till here - It wont cause any shit..
	//From here its edited.
	if((IsPlayerConnected(playerid)==0)|| spawnSeconds[playerid] <= 1 || GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
	{
		TogglePlayerSpectating(playerid, 0);
		EndSpecTimer(playerid);
	}
	else
	{
		spawnSeconds[playerid]--;
	}
}

ptask surfTimer[1000](playerid)
{
	if(surfdeath[playerid] > 0) surfdeath[playerid] --;
	else if(surfdeath[playerid] == 0)
	{
		surfdeath[playerid] = -1;
		SetPlayerHealth(playerid, 100.0);
	}
}

ptask JailTimer[1000](playerid)
{
	if(FoCo_Player[playerid][jailed] > 0)
	{
		FoCo_Player[playerid][jailed] --;
		if(FoCo_Player[playerid][jailed]  <= 0)
		{
			TogglePlayerControllable(playerid, 1);
			SpawnPlayer(playerid);
			FoCo_Player[playerid][jailed] = 0;
			SetPlayerInterior(playerid, 0);
			SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You are now free to enjoy the server, try not to break any rules!");
		}
	}
}

timer achievementTimer[6000](playerid)
{
	TextDrawHideForPlayer(playerid, AchieveBoxTD);
	TextDrawHideForPlayer(playerid, AchieveInfoTD[playerid]);
	TextDrawHideForPlayer(playerid, AchieveAqcTD);
	TextDrawHideForPlayer(playerid, AchieveFoCoTD);
}

iswheelmodel(modelid) {
    new wheelmodels[17] = {1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1096,1097,1098};
	for(new I = 0; I < sizeof(wheelmodels); I++) {
        if (modelid == wheelmodels[I])
            return true;     
    }
    return false;
}

IllegalCarNitroIde(carmodel) {  
    new illegalvehs[29] = { 581, 523, 462, 521, 463, 522, 461, 448, 468, 586, 509, 481, 510, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 590, 569, 537, 538, 570, 449 };
    for(new I = 0; I < sizeof(illegalvehs); I++) {
        if (carmodel == illegalvehs[I])
            return true;
    }   
    return false;
}

stock islegalcarmod(vehicleide, componentid) {
    new modok = false;
    if ( (iswheelmodel(componentid)) || (componentid == 1086) || (componentid == 1087) || ((componentid >= 1008) && (componentid <= 1010))) {
        new nosblocker = IllegalCarNitroIde(vehicleide);
        if (!nosblocker)
            modok = true;
    } else { 
		for(new I = 0; I < sizeof(legalmods); I++) {
            if (legalmods[I][0] == vehicleide) {        
                for(new J = 1; J < 22; J++) { 
                    if (legalmods[I][J] == componentid)
                        modok = true;
                }            
            }
        }
    }
    return modok;
}

stock IsPlayerNearSprunk(playerid)
{
	for(new i = 0; i < 43; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 10.0, SprunkLocations[i][0], SprunkLocations[i][1], SprunkLocations[i][2]))
		{
			return 1;
		}
	}
	return 0;
}

forward Manhunt_Event();
public Manhunt_Event()
{
	if(GetOnlinePlayers() == 0)
	{
		return 1;
	}

	new rand = random(GetOnlinePlayers());
	
	if(!IsPlayerConnected(rand)) {
		if(ManHuntFail == 3)
		{
			return 1;
		}
		ManHuntFail++;
		Manhunt_Event();
		return 1;
	}
	
	if(ADuty[rand] > 0)
	{
		if(ManHuntFail == 3)
		{
			SendAdminMessage(1,"Manhunt event has failed due to ADuty staff chosen");
			return 1;
		}
		ManHuntFail++;
		Manhunt_Event();
		return 1;
 	}

	if(GetPVarInt(rand, "PlayerStatus") == 3)
	{
		if(ManHuntFail == 3)
		{
			SendAdminMessage(1,"Manhunt event has failed due to afk player chosen");
			return 1;
		}
		ManHuntFail++;
		Manhunt_Event();
	}
	
	if(GetPVarInt(rand, "AtEvent") == 1) 
	{
		if(ManHuntFail == 3)
		{
			SendAdminMessage(1,"Manhunt event has failed due to player in event chosen");
			return 1;
		}
		ManHuntFail++;
		Manhunt_Event();
	}
	
	ManHuntFail = 0;
	ManHuntID = rand;
	ManHuntSeconds = GetUnixTime();
	
	SetPlayerColor(rand, COLOR_OOC);
	GivePlayerWeapon(rand, 31, 999);
	SetPlayerHealth(rand, 99);
	SetPlayerArmour(rand, 99);
	
	new string[128];
	format(string, sizeof(string), "[MANHUNT]: %s(%d) is now the target of manhunt, kill him for extra rewards!", PlayerName(rand), rand);
	SendClientMessageToAll(COLOR_GREEN, string);
	ChatLog(string);
	return 1;
}

public TenMinuteTimer()
{
	if(ManHuntTwenty >= 2 && GetMaxPlayers() > 4 && ManHuntID == -1 && Event_ID == -1)
	{
		ManHuntTwenty = 0;
		Manhunt_Event();
	}
	else
	{
		ManHuntTwenty++;
	}
	
	foreach (Player, i)
	{
		if(IsPlayerConnected(i))
		{
			if(gPlayerLogged[i] == 1)
			{
				DataSave(i);
				SavePlayerStatsInfo(i);
			}
		}
	}
	return 1;
}


stock IsKeyJustDown(key, newkeys, oldkeys)
{
	if((newkeys & key) && !(oldkeys & key)) return 1;
	return 0;
}

PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
}

StopLoopingAnim(playerid)
{
	gPlayerUsingLoopingAnim[playerid] = 0;
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
}

forward underCover(playerid, targetid, type);
public underCover(playerid, targetid, type) 
{
	switch(type) 
	{
		case 0: // .info
		{
			new string[128];
			format(string, sizeof(string), "|-------------------------------- {%06x}%s(%d){%06x} --------------------------------|", COLOR_WARNING >>> 8, PlayerName(targetid), targetid, COLOR_CMDNOTICE >>> 8);
			SendClientMessage(playerid, COLOR_CMDNOTICE, string);
			format(string, sizeof(string), "Status: Player - Level: 3 - Rank: %s  - VIP Rank: %s", PlayerRankNames[3], DonationType(targetid));
			SendClientMessage(playerid, COLOR_NOTICE, string);
			format(string, sizeof(string), "Money: $%d - Score: %d - Kills: 82 - Deaths: 12", GetPlayerMoney(targetid), FoCo_Player[targetid][score]);
			SendClientMessage(playerid, COLOR_NOTICE, string);
			format(string, sizeof(string), "Suicides: 5 - Longest Streak: 4 - Current Streak: %d", CurrentKillStreak[targetid]);
			SendClientMessage(playerid, COLOR_NOTICE, string);
			format(string, sizeof(string), " ", COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
			SendClientMessage(playerid, COLOR_CMDNOTICE, string);
			format(string, sizeof(string), "Helicopter: 5 - Deagle: 12 - M4: 8 - MP5: 3 - Knife: 2");
			SendClientMessage(playerid, COLOR_NOTICE, string);
			format(string, sizeof(string), "Flamethrower: %d - Chainsaw: %d - Colt: %d", FoCo_Playerstats[targetid][flamethrower], FoCo_Playerstats[targetid][chainsaw], FoCo_Playerstats[targetid][colt]);
			SendClientMessage(playerid, COLOR_NOTICE, string);
			format(string, sizeof(string), "Uzi: 4 - Combat Shotgun: 5 - AK47: 2 - Tec9: 4 - Sniper: 4");
			SendClientMessage(playerid, COLOR_NOTICE, string);
		}
	}
	return 1;
}

public SendAdminMessage(minrank, message[])
{
	foreach (Player, i)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "Not_Authenticated") == 1) {
				continue;
			}
			if(FoCo_Player[i][admin] >= minrank || FoCo_Player[i][tester] == 1 && AdminsOnline() == 0)
			{
				SendClientMessage(i, COLOR_YELLOW, message);
			}
		}
	}
	return 1;
}

public SendTesterChat(message[])
{
	foreach (Player, i)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(FoCo_Player[i][tester] == 1 || AdminLvl(i) >= 1)
	        {
	            SendClientMessage(i, COLOR_TESTER, message);
			}
		}
	}
	return 1;
}

/*
stock SendReportMessage(minrank, message[])
{
	foreach (Player, i)
	{
		if(IsPlayerConnected(i))
		{
			if(FoCo_Player[i][admin] >= minrank)
			{
				SendClientMessage(i, COLOR_LIGHTORANGE, message);
			}
		}
	}
	IRC_GroupSay(gEcho, IRC_FOCO_ECHO, message);
	return 1;
}
*/

stock GetPlayerStatus(playerid)
{
	new statusstring[56];
	if(aUndercover[playerid] == 1) 
	{
		format(statusstring, sizeof(statusstring), "Player");
		return statusstring;
	}
	if(FoCo_Player[playerid][id] == 109979)
	{
		format(statusstring, sizeof(statusstring), "Head Developer");
		return statusstring;
	}
	if(FoCo_Player[playerid][id] == 368 || FoCo_Player[playerid][id] == 28261) 
	{
		format(statusstring, sizeof(statusstring), "Manager");
		return statusstring;
	}
	if(FoCo_Player[playerid][id] == 2852)
	{
		format(statusstring, sizeof(statusstring), "Lead Developer");
		return statusstring;
	}
	if(FoCo_Player[playerid][admin] > 0)
	{
		format(statusstring, sizeof(statusstring), "%s", AdRankNames[FoCo_Player[playerid][admin]]);
		return statusstring;
	}
	if(FoCo_Player[playerid][tester] > 0)
	{
		format(statusstring, sizeof(statusstring), "Trial Admin");
		return statusstring;
	}
	if(isVIP(playerid) == 1)
	{
		format(statusstring, sizeof(statusstring), "Bronze Donator");
		return statusstring;
	}
	if(isVIP(playerid) == 2)
	{
		format(statusstring, sizeof(statusstring), "Silver Donator");
		return statusstring;
	}
	if(isVIP(playerid) == 3)
	{
		format(statusstring, sizeof(statusstring), "Gold Donator");
		return statusstring;
	}
	format(statusstring, sizeof(statusstring), "Player");
	return statusstring;
}

/*
* Useful Stock Functions
*/

stock PlayerName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, MAX_PLAYER_NAME);
    return name;
}

stock GetOnlinePlayers()
{
	new count;
	foreach (Player, i)
	{
		count++;
	}
	return count;
}
stock GetWeaponModelIDFromName(weapname[])
{
    for(new i = 0; i < 48; i++)
	{
        if (i == 19 || i == 20 || i == 21) continue;
		if (strfind(WeapNames[i][WeapName], weapname, true) != -1) return i;
	}
	return -1;
}

stock IsNumeric( string[ ] ) 
{
    for (new i = 0, j = strlen( string); i < j; i++) if ( string[i] > '9' || string[i] < '0') return 0; return 1;
}
stock IsAirVehicle(vehname[])
{
	#define MAX_AIR_VEHICLES 20

    new AirVehicles[MAX_AIR_VEHICLES] =
    {
		592, 577, 511, 512, 593, 520, 553, 476, 519, 
		460, 513, 548, 425, 417,  487, 488, 497, 563, 
		447, 469
    };
	
	new vid = GetVehicleModelIDFromName(vehname);
	for(new i = 0; i < MAX_AIR_VEHICLES; i++)
	{
		if(vid == AirVehicles[i])
		{
			return false;
		}
	}
	return true;
}

stock IsVehicleValidNOS(vehname[])
{
	#define MAX_INVALID_NOS_VEHICLES 29

    new InvalidNosVehicles[MAX_INVALID_NOS_VEHICLES] =
    {
		581,523,462,521,463,522,461,448,468,586,
		509,481,510,472,473,493,595,484,430,453,
		452,446,454,590,569,537,538,570,449
    };
	
	new vid = GetVehicleModelIDFromName(vehname);
	for(new i = 0; i < MAX_INVALID_NOS_VEHICLES; i++)
	{
		if(vid == InvalidNosVehicles[i])
		{
			return false;
		}
	}
	return true;
}

stock IsVehicleValidWheels(vehname[])
{
	#define MAX_INVALID_WHEEL_VEHICLES 78

    new InvalidNosVehicles[MAX_INVALID_WHEEL_VEHICLES] =
    {
		558,559,560,561,562,565,412,534,535,536,566,567,576,400,401,402,404,405,409,
		410,411,415,418,419,420,421,422,424,426,436,438,439,442,445,451,458,466,467,
		474,475,477,478,479,480,489,491,492,496,500,505,506,507,516,517,518,527,526,
		529,533,540,541,542,545,546,547,549,550,551,555,575,579,580,585,587,589,600,
		602,603
    };
	
	new vid = GetVehicleModelIDFromName(vehname);
	for(new i = 0; i < MAX_INVALID_WHEEL_VEHICLES; i++)
	{
		if(vid == InvalidNosVehicles[i])
		{
			return true;
		}
	}
	return false;
}

stock IsVehicleValidHydraulics(vehname[])
{
	#define MAX_INVALID_HYDRAULIC_VEHICLES 78


    new InvalidNosVehicles[MAX_INVALID_HYDRAULIC_VEHICLES] =
    {
		558,559,561,562,565,412,534,535,536,566,567,576,400,401,402,404,405,409,
		410,411,415,418,419,420,421,422,424,426,436,438,439,442,445,451,458,466,467,
		474,475,477,478,479,480,489,491,492,496,500,505,506,507,516,517,518,527,526,
		529,533,540,541,542,545,546,547,549,550,551,555,575,579,580,585,587,589,600,
		602,603
    };
	
	new vid = GetVehicleModelIDFromName(vehname);
	for(new i = 0; i < MAX_INVALID_HYDRAULIC_VEHICLES; i++)
	{
		if(vid == InvalidNosVehicles[i])
		{
			return true;
		}
	}
	return false;
}

stock DeleteAllAttachedWeapons(playerid)
{
    for (new obj = 0; obj < MAX_PLAYER_ATTACHED_OBJECTS; obj++)
    {
        RemovePlayerAttachedObject(playerid, obj);
    }
	return 1;
}

stock split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc))
	{
	    if(strsrc[i] == delimiter || i == strlen(strsrc))
	    {
	        len = strmid(strdest[aNum], strsrc, li , i , 128);
         	strdest[aNum][len] = 0;
          	li = i+1;
         	aNum++;
	    }
	    i++;
	}
	return 1;
}
/*
stock HaveCap(playerid) 
{
	if(pObject[playerid][omodel] > 0) {
		return 1;
	} else {
		return -1;
	}
}

GiveHat(playerid, slot, model, bone, Float:X, Float:Y, Float:Z, Float:RX, Float:RY, Float:RZ)
{
	pObject[playerid][slotreserved] = true;
	pObject[playerid][omodel] = model;
	pObject[playerid][oslot] = slot;
	SetPlayerAttachedObject(playerid, slot, model, bone, X, Y, Z, RX, RY, RZ);
	return 1;
}

GetEmptySlot(playerid)
{	
	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; ++i)
	{
		if(!IsPlayerAttachedObjectSlotUsed(playerid, i))
		{
			return i;
		}	
	}
	return -1;
}*/

stock CarPrice(vehid)
{
	new price;

	switch(vehid)
	{
		case 402, 429, 439, 559, 562, 409, 443, 461, 468, 521, 568:
		{
			price = 40000;
		}
		case 428, 408, 414, 431, 456, 459, 482, 498, 522:
		{
			price = 50000;
		}
		case 411, 451, 506:
		{
			price = 150000;
		}
		case 415,  477, 541:
		{
			price = 95000;
		}
		case 480, 424, 433, 434, 470, 495, 494, 502, 503, 504, 573, 403, 514, 515, 578:
		{
			price = 75000;
		}
		case 490, 550, 560, 561, 566, 567, 419, 420, 442, 463, 565:
		{
			price = 30000;
		}
		case 400, 489, 543, 554, 579, 405, 412, 421, 426, 445, 492, 536, 457, 462, 531:
		{
			price = 20000;
		}
		case 422:
		{
			price = 10000;
		}
	}
	return price;
}

forward ClearTransVars(playerid);
public ClearTransVars(playerid)
{
	trans[playerid] = 0;
	transveh[playerid] = -1;
	transslot[playerid] = -1;
	transmodel[playerid][0] = 415;
	transmodel[playerid][1] = 476;
	transmodel[playerid][2] = 468;
	transcolor[playerid][0] = 0;
	transcolor[playerid][1] = 0;
	
	return 1;
}

stock GetPublicTeamAmount() 
{
	new count = 0;
	foreach (FoCoTeams, teamid)
	{
		if(FoCo_Teams[teamid][team_type] == 1) 
		{
			count++;
		}
	}
	return count;
}

stock GetAverageTeamMembers() 
{
	return GetOnlinePlayers() / GetPublicTeamAmount();
}

stock GetTeamMemberCount(team_id)
{
	new count = 0;
	foreach(Player, i) {
		if(FoCo_Team[i] == team_id) {
			count++;
		}
	}
	return count;
}

stock intsplit(const strsrc[], strdest[], delimiter)
{
    new i, li;
    new aNum;
    new tmpstring[256];
    while(i <= strlen(strsrc))
    {
        if(strsrc[i] == delimiter || i == strlen(strsrc))
        {
            strmid(tmpstring, strsrc, li, i, 128);
            strdest[aNum] = strval(tmpstring);
            li = i+1;
            aNum++;
        }
        i++;
    }
    return 1;
}

stock FoCoIRC_GroupSay(groupid, const target[], const message[])
{
	new colour1[20], colour2[20], string[178];
	format(string, 178, "%s", message);
	for (new pos = 0; pos < strlen(message); pos++)
	{
		if(strfind(string, "{", false, pos) != -1)
		{
			pos = strfind(string, "{", false, pos);
			if(strfind(string, "}", false, pos+7) == pos+7)
			{
				
				strmid(colour1, string, pos+1, pos+7);
				strdel(string, pos, pos+8);
				
				new colins[20];
				format(colins, sizeof(colins), "16");
				
				format(colour2, sizeof(colour2), "%06x", COLOR_CMDNOTICE >>> 8);
				if(!strcmp(colour1, colour2, false, 7) && strlen(colour1) >= 6)
				{
					format(colins, sizeof(colins), IRCCOL_CMDNOTICE);
				}
				
				format(colour2, sizeof(colour2), "%06x", COLOR_GLOBALNOTICE >>> 8);
				if(!strcmp(colour1, colour2, false, 7) && strlen(colour1) >= 6)
				{
					format(colins, sizeof(colins), IRCCOL_GLOBALNOTICE);
				}
				
				format(colour2, sizeof(colour2), "%06x", COLOR_WARNING >>> 8);
				if(!strcmp(colour1, colour2, false, 7) && strlen(colour1) >= 6)
				{
					format(colins, sizeof(colins), IRCCOL_WARNING);
				}
				
				format(colour2, sizeof(colour2), "%06x", COLOR_NOTICE >>> 8);
				if(!strcmp(colour1, colour2, false, 7) && strlen(colour1) >= 6)
				{
					format(colins, sizeof(colins), IRCCOL_NOTICE);
				}
				
				format(colour2, sizeof(colour2), "%06x", COLOR_SYNTAX >>> 8);
				if(!strcmp(colour1, colour2, false, 7) && strlen(colour1) >= 6)
				{
					format(colins, sizeof(colins), IRCCOL_SYNTAX);
				}
				
				format(colour2, sizeof(colour2), "%06x", COLOR_ADMIN >>> 8);
				if(!strcmp(colour1, colour2, false, 7) && strlen(colour1) >= 6)
				{
					format(colins, sizeof(colins), IRCCOL_ADMIN);
				}
				
				format(colour2, sizeof(colour2), "%06x", COLOR_TESTER >>> 8);
				if(!strcmp(colour1, colour2, false, 7) && strlen(colour1) >= 6)
				{
					format(colins, sizeof(colins), IRCCOL_TESTER);
				}
				strins(string, colins, pos);
			}
			pos = pos + 6;
		}
		else pos = strlen(message);
	}
	return IRC_GroupSay(groupid, target, string);
}
#define IRC_GroupSay FoCoIRC_GroupSay

public IsAdmin(playerid, alevel)
{
	if(FoCo_Player[playerid][admin] >= alevel)
	{
		return 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, NOT_ALLOWED_WARNINGMSG);
		return 0;
	}
}

public IsDev(playerid, dev_level) {
	if(FoCo_Player[playerid][dev] >= dev_level) {
		return 1;
	} else {
		SendClientMessage(playerid, COLOR_WARNING, NOT_ALLOWED_WARNINGMSG);
		return 0;
	}
}

public AdminLvl(playerid)
{
	return FoCo_Player[playerid][admin];
}

public IsTrialAdmin(playerid)
{
	if(FoCo_Player[playerid][tester] == 1)
	{
		return 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_WARNING,  NOT_ALLOWED_WARNINGMSG);
		return 0;
	}
}

public KickPlayer(playerid)
{
	Kick(playerid);
	return 1;
}

ptask AimbotCheck[1000](playerid)
{
    new
		weapon,
		ammo;
	
	GetPlayerWeaponData(playerid, 0, weapon, ammo);
	
	if(weapon == 0 && ammo == 1000)
	{
		new
			string[255];
		
		format(string, sizeof(string), "[Guardian]: Banned %s(%d), Reason: Cheats Detected", PlayerName(playerid), playerid);
		SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
		
		format(string, sizeof(string), "[Guardian]: {ff6347}Player %s has been banned by the anticheat for using an aimbot.", PlayerName(playerid));
		SendAdminMessage(1, string);
		
		format(string, sizeof(string), "[Guardian]: %s you have been banned by the anticheat.", PlayerName(playerid));
		SendClientMessage(playerid, COLOR_NOTICE, string);
		SendClientMessage(playerid, COLOR_NOTICE, "If you find this ban wrongful you can appeal at: forum.focotdm.com");
		format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', 'Anti-Cheat', '3', 'Aimbot', '%s')", FoCo_Player[playerid][id], TimeStamp());
		mysql_query(string);
		format(string, sizeof(string), "UPDATE `FoCo_Players` SET `banned` = `1` WHERE `username` = '%s'",PlayerName(playerid));
		mysql_query(string);
		Ban(playerid);
	}
}

//#########################LOGGING##############################################

stock MoneyLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/money.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock SetMoneyLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/SetMoneyLog.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock CmdLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/cmds.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock CheatLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/anticheat.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock ChatLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/talk.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock GChatLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/gchat.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock PMLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/pm.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock ReportLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/report.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock xyza(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "%s,\r\n", string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/xyza.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock notes(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "NOTE: %s,\r\n", string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/notes.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock debug_freeze(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | DEBUG: %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/debug.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock AdminLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/adminlog.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

public DialogLog(msg[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), msg);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/dialoglog.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
	return 1;
}

stock TrialAdminLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/trialadminlog.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock AdminChatLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/adminchatlog.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock TrialAdminChatLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/trialadminchatlog.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock LeadAdminChatLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/leadadminchatlog.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock ConnectionLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/connectionlog.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock KillLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/killlog.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock HelpmeLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/helpmelog.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

stock EventLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/eventlog.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}
stock TrustedMemberChatLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/trustedmemberchatlog.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}
//##############################################################################

stock DonationType(playerid)
{
	new type[16];
	switch(FoCo_Donations[playerid][dtype])
	{
	    case 1: format(type,16,"Bronze");
	    case 2: format(type,16,"Silver");
	    case 3: format(type,16,"Gold");
		default: format(type,16,"None");
	}
	return type;
}

stock DonationExpire(playerid)
{
	new unix_now,difference,expire_date[16];
	unix_now = gettime();
	difference = FoCo_Donations[playerid][dexp] - unix_now;
	if(difference <= 0)
	{
	    format(expire_date,16,"Expired!");
	}
	else
	{
	    format(expire_date,16,"%d",difference);
	}
	return expire_date;
}



stock CountDonators(type)
{
	new count;
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(FoCo_Donations[i][dtype] == type)
	    {
	        count++;
		}
	}
	return count;
}

stock AmountCarsOwned(playerid)
{
	new amount=0;
	if(FoCo_Donations[playerid][dcar1] != 0)
	{
	    amount++;
	}
	if(FoCo_Donations[playerid][dcar2] != 0)
	{
	    amount++;
	}
	if(FoCo_Donations[playerid][dcar3] != 0)
	{
	    amount++;
	}
	return amount;
}

stock SwitchCar(playerid, carid)
{
	new string[128];
	if(FoCo_Donations[playerid][dcar1] == carid)
	{
	    format(string, sizeof(string), "[INFO]: Active vehicle set to: %d", carid);
	    SendClientMessage(playerid, COLOR_YELLOW, string);
	    FoCo_Player[playerid][users_carid] = carid;
	    return 1;
	}
	else if(FoCo_Donations[playerid][dcar2] == carid)
	{
	    format(string, sizeof(string), "[INFO]: Active vehicle set to: %d", carid);
	    SendClientMessage(playerid, COLOR_YELLOW, string);
		FoCo_Player[playerid][users_carid] = carid;
		return 1;
	}
	else if(FoCo_Donations[playerid][dcar3] == carid)
	{
	    format(string, sizeof(string), "[INFO]: Active vehicle set to: %d", carid);
	    SendClientMessage(playerid, COLOR_YELLOW, string);
	    FoCo_Player[playerid][users_carid] = carid;
	    return 1;
	}
	else
	{
	    format(string, sizeof(string), "[ERROR]: Invalid vehicle ID!");
		SendClientMessage(playerid, COLOR_WARNING, string);
		return 1;
	}
}
	

stock GetDefaultSkin(playerid)
{
	
	if(FoCo_Player[playerid][clan] != -1 && FoCo_Team[playerid] == FoCo_Teams[FoCo_Player[playerid][clan]][db_id])
	{
		switch(FoCo_Player[playerid][clanrank])
		{
			case 1:
			{
				return FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_1];
			}
			case 2:
			{
				return FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_2];
			}
			case 3:
			{
				return FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3];
			}
			case 4:
			{
				return FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4];
			}
			case 5:
			{
				return FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5];
			}
		}
		
	}

	else
	{
		return FoCo_Teams[FoCo_Team[playerid]][team_skin_1];
	}
	
	return 0;
}


	/* GetPlayer2DZone */

forward GetPlayer2DZone(playerid, zone[], len);
public GetPlayer2DZone(playerid, zone[], len) //Credits to Cueball, Betamaster, Mabako, and Simon (for finetuning).
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
 	for(new i = 0; i != sizeof(gSAZones); i++ )
 	{
		if(x >= gSAZones[i][SAZONE_AREA][0] && x <= gSAZones[i][SAZONE_AREA][3] && y >= gSAZones[i][SAZONE_AREA][1] && y <= gSAZones[i][SAZONE_AREA][4])
		{
		    return format(zone, len, gSAZones[i][SAZONE_NAME], 0);
		}
	}
	return 0;
}

forward ResetClasses(playerid);
public ResetClasses(playerid)
{
	new query[256];
	format(query, sizeof(query), "UPDATE FoCo_Classes SET melee='0' , handguns='0', shotguns='0', submachine='0', assault='0', rifle='0' WHERE player_id ='%d'",FoCo_Player[playerid][id]);
	mysql_query(query, MYSQL_RESETCLASS, playerid, con);
	return 1;
}

stock IsNotStanding(playerid)
{
	new Float:HH_SP[3];
	GetPlayerVelocity(playerid, HH_SP[0], HH_SP[1], HH_SP[2]);
    new Keys,ud,lr;
    GetPlayerKeys(playerid,Keys,ud,lr);
    HH_SP[0]=HH_SP[0]+HH_SP[1]+HH_SP[2];
	lr=lr+Keys+ud;
	if(HH_SP[0]==0.0 && (lr==0||lr==1024) || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK || GetPlayerState(playerid) == PLAYER_STATE_WASTED )
	{
	    return 0;
	}
	return 1;
}

//forward SetEventFFA(type);
public SetEventFFA(type)
{
    Event_FFA = type;
    return 1;
}

stock WeaponName(weaponid)
{
    new gunname[32];
	if(weaponid == 0)
	{
	    format(gunname,32,"None");
	    return gunname;
	}
    GetWeaponName(weaponid,gunname,sizeof(gunname));
    return gunname;
}

stock AddToPlayerHealth(playerid, Float:hp)
{
	new Float:tpHealth;
	GetPlayerHealth(playerid, tpHealth);
	if(99.0 - (tpHealth + hp) < 0.0)
	{
		SetPlayerHealth(playerid, 99.0);
		tpHealth = (tpHealth + hp) - 99.0;
		new Float:tpArmour;
		GetPlayerArmour(playerid, tpArmour);
		if((tpArmour + tpHealth) > 99.0)
		{
			SetPlayerArmour(playerid, 99.0);
		}
		else
		{
			SetPlayerArmour(playerid, tpArmour + tpHealth);
		}
	}
	else
	{
		SetPlayerHealth(playerid, tpHealth + hp);
	}
	return 1;
}

stock ReduceFromPlayerHealth(playerid, Float:hp)
{
	new Float:tpArmour;
	GetPlayerArmour(playerid, tpArmour);
	if((tpArmour - hp) < 0.0)
	{
		SetPlayerArmour(playerid, 0.0);
		tpArmour = -1 * (hp - tpArmour);
		new Float:tpHealth;
		GetPlayerHealth(playerid, tpHealth);
		if((tpHealth - tpArmour) <= 0.0)
		{
			SetPlayerHealth(playerid, 0.0);
		}
		else
		{
			SetPlayerArmour(playerid, tpHealth - tpArmour);
		}
	}
	else
	{
		SetPlayerHealth(playerid, tpArmour - hp);
	}
	return 1;
}


stock GetGPCI(playerid)
{
	new pserial[128];
	gpci(playerid, pserial, 128);
	return pserial;
}


public AddPlayerHealth(playerid, Float:amount)
{
	new Float:phealth, Float:parmour;
	if(amount > 0.0)
	{
		GetPlayerHealth(playerid, phealth);
		if(phealth + amount >= 99.0)
		{
			SetPlayerHealth(playerid, 99.0);
			amount = (phealth + amount) - 99.0;
			GetPlayerHealth(playerid, parmour);
			if(parmour + amount > 99.0)
			{
				SetPlayerArmour(playerid, 99.0);
			}
			else
			{
				SetPlayerArmour(playerid, parmour + amount);
			}
		}
		else
		{
			SetPlayerHealth(playerid, phealth + amount);
		}
	}
	else
	{
		GetPlayerArmour(playerid, parmour);
		if(parmour + amount < 0.0)
		{
			SetPlayerArmour(playerid, 0.0);
			amount = (parmour + amount);
			GetPlayerHealth(playerid, phealth);
			if(phealth + amount <= 0.0)
			{
				SetPlayerHealth(playerid, 0.0);
			}
			else
			{
				SetPlayerHealth(playerid, phealth + amount);
			}
		}
		else
		{
			SetPlayerArmour(playerid, parmour + amount);
		}
	}
	return 1;
}

public IsValidPlayerID(playerid, targetid)
{
	if(targetid == INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerName/PlayerID");
		return 0;
	}
	if(!IsPlayerConnected(targetid))
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerName/PlayerID");
		return 0;
	}
	return 1;
}
