#if !defined MAIN_INIT
#error "Compiling from wrong script. (foco.pwn)"
#endif
// Testing

#define INFINITY (Float:0x7F800000)

/* ADMIN COMMANDS ARE ORDERED AS THEY APPEAR ON /ah */

#if defined PTS
CMD:pdmxyz(playerid, params[])
{
	new targetid, rank;
	if (sscanf(params, "ui", targetid, rank))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /pdmxyz [ID/Name] [Rank]");
		return 1;
	}
	if(targetid == INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
		return 1;
	}
	if(rank > 5)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid amount, must be below or equal to 5.");
		return 1;
	}
	new string[156];
	format(string, sizeof(string), "[AdmCMD]: %s %s has made you a %s (Rank %i).", GetPlayerStatus(playerid), PlayerName(playerid), AdRankNames[rank], rank);
	SendClientMessage(targetid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Make sure you update yourself on the new commands by visiting the forum section for admins & /ahelp");
	SendClientMessage(targetid, COLOR_NOTICE, string);
	format(string, sizeof(string), "AdmCmd(%d): %s %s has made %s an admin(%d)",ACMD_SETADMIN, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), rank);
	SendAdminMessage(ACMD_SETADMIN,string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	FoCo_Player[targetid][admin] = rank;
	if(rank == 5)
	{
		GiveAchievement(targetid, 98);
	}
	else
	{
		GiveAchievement(targetid, 97);
	}
	return 1;
}

CMD:test(playerid, params[]) {
	new string[512];
	format(string, sizeof(string), "Test: %d", FoCo_Playerstats[playerid][deaths]);
	//DebugMsg(string);
	return 1;
}

CMD:dgoto(playerid, params[])
{
	new targetid;
	if (sscanf(params, "u", targetid))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /goto [ID/Name]");
		return 1;
	}
	if(targetid == INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
		return 1;
	}
	if(GetPlayerState(targetid) == 9 || GetPlayerState(targetid) == 7)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  This player is currently spectating or not yet spawned.");
		return 1;
	}
	new string[128], Float:px, Float:py, Float:pz, vw_world, vw_int;
	GetPlayerPos(targetid, px, py, pz);
	vw_world = GetPlayerVirtualWorld(targetid);
	vw_int = GetPlayerInterior(targetid);
	SetPlayerVirtualWorld(playerid, vw_world);
	SetPlayerInterior(playerid, vw_int);
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		SetVehiclePos(GetPlayerVehicleID(playerid), px, py, pz);
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), vw_world);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), vw_int);
	}
	else
	SetPlayerPos(playerid, px+1, py, pz+1);
	format(string, sizeof(string), "                You teleported to %s.", PlayerName(targetid));
	SendClientMessage(playerid, COLOR_CMDNOTICE, string);
	return 1;
}
#endif


CMD:specfix(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
	    new targetid;
		if(sscanf(params, "u", targetid))
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /specfix [PlayerName/PlayerID]");
		if(IsValidPlayerID(playerid, targetid))
		{
			TogglePlayerSpectating(targetid, 0);
			new string[128];
			format(string, sizeof(string), "AdmCmd(%i): %s %s has spec-fixed %s(%i).", 1, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
			SendAdminMessage(1, string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			format(string, sizeof(string), "[NOTICE]: %s %s has fixed your spec-bug.", GetPlayerStatus(playerid), PlayerName(playerid));
			SendClientMessage(targetid, COLOR_NOTICE, string);
		}
	}
	return 1;
}

CMD:teaminfo(playerid, params[]) 
{
	if(IsAdmin(playerid, 1)) {
		new msg[1024];
		foreach (FoCoTeams, i)
		{
			if(FoCo_Teams[i][team_type] != 0)
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
		return ShowPlayerDialog(playerid, DIALOG_TEAMINFO, DIALOG_STYLE_LIST, "Team Information", msg, "Select", "Cancel");
	}
	return 1;
}

CMD:teamids(playerid, params[])
{
	return cmd_teaminfo(playerid, params);
}

CMD:getplayerxyz(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new targetid;
		if(sscanf(params, "u", targetid)) {
			return SendClientMessage(playerid, COLOR_SYNTAX, "/getxyz [ID]");
		}
		new Float:x, Float:y, Float:z;
		GetPlayerPos(targetid, x, y, z);
		new string[156];
		format(string, sizeof(string), "%s's(%d) xyz: %f, %f, %f", PlayerName(targetid), targetid, x, y, z);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	return 1;
}

CMD:gxyz(playerid, params[])
{
	return cmd_getplayerxyz(playerid, params);
}

CMD:gotogas(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GOTOGAS))
	{
		SetPlayerPos(playerid, 1949.1503,-1772.6453,19.5250);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
	}
	return 1;
}

CMD:gotopizza(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GOTOGAS))
	{
		SetPlayerPos(playerid, 2103.3020,-1768.7687,13.3949);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
	}
	return 1;
}

CMD:localplayers(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_LOCALPLAYERS))
	{
		new range;
		if(sscanf(params, "d", range))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /localplayers [range]");
			range = 100;
		}
		if(range < 5 || range > 500)
		{
			return SendErrorMessage(playerid, "The minimum range is 5 meters and the max is 500.");
		}
		new Float:X, Float:Y, Float:Z;
		GetPlayerPos(playerid, X, Y, Z);
		new string[MAX_PLAYER_NAME + 30];
		foreach(Player, i)
		{
			if(IsPlayerInRangeOfPoint(i, range, X, Y, Z))
			{
				format(string, sizeof(string), "%s(%d) is within %d meters.", PlayerName(i), i, range);
				SendClientMessage(playerid, COLOR_SYNTAX, string);
			}
		}
	}
	
	return 1;
}

CMD:astopanim(playerid, params[])
{
	new targetid, string[128];
	if(IsAdmin(playerid, ACMD_ASTOPANIM))
	{
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: /astopanim [ID]");
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid playerid/name");
		}
		#if defined GuardianProtected
		ClearAnimations(targetid);
		#else
		ClearAnimations(targetid);
		#endif
		StopLoopingAnim(targetid);
		format(string, sizeof(string), "[INFO]: %s %s(%d) has force-stopped your current animation.", GetPlayerStatus(playerid), PlayerName(playerid), playerid);
		SendClientMessage(targetid, COLOR_SYNTAX, string);
		format(string, sizeof(string), "AdmCmd(%d): %s(%d) has force-stopped %s's(%d) animation.", ACMD_ASTOPANIM, PlayerName(playerid), playerid, PlayerName(targetid), targetid);
		SendAdminMessage(ACMD_ASTOPANIM, string);
	}
	return 1;
}

CMD:astopanimation(playerid, params[])
{
	cmd_astopanim(playerid, params);
	return 1;
}

// || IsTrialAdmin(playerid) && AdminsOnline() == 0   // ADD AFTER THE ISADMIN FUNCTION WHEN YOU WANT TRIALSADMINS TO BE ABLE TO TO THE CMD WHEN NO ADMINS ARE ONLINE
CMD:deathstreaks(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_DEATHSTREAKS))
	{
	    new string[128];
	    new deathppl = 0;
	    foreach(Player, i)
		{
		    if(i != INVALID_PLAYER_ID)
		    {
      			if(FoCo_Player[i][level] <= 5)
			    {
	      			if(CurrentDeathStreak[i] >= 5)
					{
					    deathppl++;
						if(CurrentDeathStreak[i] >= 5 && CurrentDeathStreak[i] < 10)
						{
						    format(string, sizeof(string), "%s(%d) is currently on a %d death streak and should have an extra MP5 with 90 ammo on spawn.", PlayerName(i), i, CurrentDeathStreak[i]);
						    SendClientMessage(playerid, COLOR_SYNTAX, string);
						}
						else if(CurrentDeathStreak[i] >= 10 && CurrentDeathStreak[i] < 20)
						{
						    format(string, sizeof(string), "%s(%d) is currently on a %d death streak and should have an extra M4 with 100 ammo on spawn.", PlayerName(i), i, CurrentDeathStreak[i]);
						    SendClientMessage(playerid, COLOR_SYNTAX, string);
						}
						else
						{
							format(string, sizeof(string), "%s(%d) is currently on a %d death streak and should have an extra spas with 50 ammo and 50 armour on spawn.", PlayerName(i), i, CurrentDeathStreak[i]);
						    SendClientMessage(playerid, COLOR_SYNTAX, string);
						}
					}
			    }
		    }
		    
		}
		if(deathppl == 0)
  		{
	 		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There are no-one currently on a death streak!");
		  	return 1;
  		}
	}
	return 1;
}

CMD:setachievement(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETACH))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
	    new targetid, ach_id, value;
	    new string[256];
	    if(sscanf(params, "uii", targetid, ach_id, value))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: /setachievement [ID] [Ach_ID] [Value]");
	    }
	    if(ach_id < 0)
	    {
            return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Achievement ID has to be higher than 0.");
	    }
	    if(ach_id > AMOUNT_ACHIEVEMENTS)
	    {
	         format(string, sizeof(string), "[ERROR]: Achievement ID has to be lower than %d", AMOUNT_ACHIEVEMENTS);
	         SendClientMessage(playerid, COLOR_WARNING, string);
	         return 1;
	    }
	    if(targetid == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid playerid/name.");
	    }
	    if(value < 0 || value > 1)
	    {
	        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Value has to be either 0 or 1.");
	    }
		UpdateAchievementStatus(playerid, ach_id, value);
		
		if(value == 0)
		{
		    format(string, sizeof(string), "[INFO]: %s's(%d) achievement status for achievement number %d has been set to {FF0000}incomplete{FF0000}.", PlayerName(targetid), targetid, ach_id);
		    SendClientMessage(playerid, COLOR_SYNTAX, string);
		    format(string, sizeof(string), "AdmCmd(%d): %s(%d) has set %s's(%d) achievement status for achievement number %d to {FF0000}incomplete{FF0000}.", ACMD_SETACH, PlayerName(playerid), playerid, PlayerName(targetid), targetid, ach_id);
		    SendAdminMessage(ACMD_SETACH, string);
		    return 1;
		}
		else
		{
			format(string, sizeof(string), "[INFO]: %s's(%d) achievement status for achievement number %d has been set to {15ED9A}completed{15ED9A}.", PlayerName(targetid), targetid, ach_id);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			format(string, sizeof(string), "AdmCmd(%d): %s(%d) has set %s's(%d) achievement status for achievement number %d to {15ED9A}completed{15ED9A}.", ACMD_SETACH, PlayerName(playerid), playerid, PlayerName(targetid), targetid, ach_id);
		    SendAdminMessage(ACMD_SETACH, string);
		    return 1;
		}
	}
	return 1;
}

CMD:onplayerdeathmsg(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_ONPLAYERDEATH))
	{
	    if(OnPlayerDeathMsg[playerid] == 0)
	    {
	        OnPlayerDeathMsg[playerid] = 1;
	        SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: OnPlayerDeath messages has been enabled.");
	        return 1;
	    }
	    else
	    {
	        OnPlayerDeathMsg[playerid] = 0;
	        SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: OnPlayerDeath messages has been disabled.");
	        return 1;
	    }
	}
	return 1;
}

CMD:onplayerdisconnectmsg(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_ONPLAYERDISCONNECT))
	{
	    if(OnPlayerDisconnectMsg[playerid] == 0)
	    {
	        OnPlayerDisconnectMsg[playerid] = 1;
	        SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: OnPlayerDisonnect messages has been enabled.");
	        return 1;
	    }
	    else
	    {
	        OnPlayerDisconnectMsg[playerid] = 0;
	        SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: OnPlayerDisconnect messages has been disabled.");
	        return 1;
	    }
	}
	return 1;
}

CMD:wvs(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_WVS))
	{
	    new string[128];
		new Float:x, Float:y, Float:z;
		new skinid;
		new vehicle;
		new targetid;
		new interiour;

		if(sscanf(params, "u", targetid))
	 	{
	  		SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /wvs [ID]");
	    	return 1;
	    }
	    if (targetid == INVALID_PLAYER_ID)
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This player is not connected");
	        return 1;
	    }
	    format(string,sizeof(string), "%s's(%d) world, vehicle and skin", PlayerName(targetid),targetid);
	    SendClientMessage(playerid, COLOR_SYNTAX, string);
	    SendClientMessage(playerid, COLOR_SYNTAX, "-----------------------------------------");
		format(string, sizeof(string), "Virtual World: %d", GetPlayerVirtualWorld(targetid));
		SendClientMessage(playerid, COLOR_NOTICE, string);
		GetPlayerPos(targetid, x, y, z);
		format(string, sizeof(string), "xyz: %f,%f,%f", x, y, z);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		skinid = GetPlayerSkin(targetid);
		format(string, sizeof(string), "Skin ID: %d", skinid);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		interiour = GetPlayerInterior(targetid);
		format(string,sizeof(string), "Interior: %d", interiour);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		vehicle = GetPlayerVehicleID(targetid);
		if(vehicle == 0)
		{
		    SendClientMessage(playerid,COLOR_NOTICE, "Vehicle ID: No vehicle ID found");
		}
		else
		{
			format(string, sizeof(string), "Vehicle ID: %d", vehicle);
			SendClientMessage(playerid, COLOR_NOTICE, string);
		}
		return 1;
	}
	return 1;
}

CMD:savestatsall(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SAVESTATSALL))
	{
	    new string[150];
		foreach(Player, i)
		{
		    if(IsPlayerConnected(i))
		    {
		        DataSave(i);
				format(string, sizeof(string), "[INFO]: Your data has been saved by %s %s(%d).", GetPlayerStatus(playerid), PlayerName(playerid), playerid);
				SendClientMessage(i, COLOR_GLOBALNOTICE, string);
		    }
		}
		SendClientMessage(playerid, COLOR_GLOBALNOTICE, "[INFO]: All player data has been saved!");
		format(string, sizeof(string), "AdmCmd(%d): %s %s(%d) has saved all players data.", ACMD_SAVESTATSALL, GetPlayerStatus(playerid), PlayerName(playerid), playerid);
		SendAdminMessage(ACMD_SAVESTATSALL, string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	}
	return 1;
}

CMD:savestats(playerid, params[])
{
	new string[150], targetid;
	if(IsAdmin(playerid, ACMD_SAVESTATS))
	{
		if(sscanf(params, "u", targetid))
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /savestats [ID]");
		    return 1;
		}
		if(!IsPlayerConnected(targetid))
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid ID/Name.");
		    return 1;
		}
		DataSave(targetid);
		format(string, sizeof(string), "[INFO]: Your data has been saved by %s %s(%d).", GetPlayerStatus(playerid), PlayerName(playerid), playerid);
		SendClientMessage(targetid, COLOR_GLOBALNOTICE, string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s(%d) has saved %s(%d) stats.", ACMD_SAVESTATS, GetPlayerStatus(playerid), PlayerName(playerid), playerid, PlayerName(targetid), targetid);
		SendAdminMessage(ACMD_SAVESTATS, string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	}
	return 1;
}


CMD:arearm(playerid, params[])
{
	if(IsAdmin(playerid,ACMD_AREARM))
	{
		new targetid, string[128];
		if(sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /arearm [id]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		new Float:Health, Float:Armour, cweapons[13][2], mainhand = GetPlayerWeapon(targetid);
		GetPlayerHealth(targetid, Health);
		GetPlayerArmour(targetid, Armour);
		ResetPlayerWeapons(targetid);
		for (new i = 0; i < 13; i++)
		{
			GetPlayerWeaponData(targetid, i, cweapons[i][0], cweapons[i][1]);
			GivePlayerWeapon(targetid, cweapons[i][0], cweapons[i][1]);
		}

		SetPlayerArmedWeapon(targetid, mainhand);
		SetPlayerHealth(targetid, Health);
		SetPlayerArmour(targetid, Armour);

		format(string, sizeof(string), "AdmCmd(%d): %s %s has reset %s(%d) items.",ACMD_AREARM, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
		SendAdminMessage(ACMD_AREARM,string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	}
	return 1;
}

CMD:weapondamages(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_WEAPONDAMAGES))
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[NOTE]: Turfs will boost the weapon damages by 5 percent - This will be in (). Values IG may vary by 0.005!");
	    SendClientMessage(playerid, COLOR_WARNING, "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
	    SendClientMessage(playerid, COLOR_SYNTAX, "PISTOLS - Colt 45: 8.25 (8.6625) - SD Pistol: 13.20 (13.86) - Deagle: 46.2 (48.51)");
	    SendClientMessage(playerid, COLOR_WARNING, "SMGS - MP5: 8.25 (8.6625) - Tec9: 6.6 (6.93) - Uzi: 6.6 (6.93)");
	    SendClientMessage(playerid, COLOR_WARNING, "ASSAULT RIFLES - M4: 9.9 (10.395) - AK47: 9.9 (10.395)");
	    SendClientMessage(playerid, COLOR_WARNING, "RIFLES - County Rifle: 24.25 (25.4625) - Sniper Rifle: 41.25 (43.3125)");
	}
	return 1;
}

CMD:wdmgs(playerid, params[])
{
	return cmd_weapondamages(playerid, params);
}

CMD:setdrunk(playerid, params[])
{
	new targetid, amount;
	new string[128];
	if(IsAdmin(playerid,ACMD_SETDRUNK))
	{
	    if(sscanf(params, "ui", targetid, amount))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setdrunk [ID] [Amount] (2000+)");
	        return 1;
	    }
	    if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
	    if(amount < 2000 || amount > 50000)
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Amount can't be less than 2000 or bigger than 50 000)");
	        return 1;
	    }
	    if(FoCo_Player[targetid][admin] >= FoCo_Player[playerid][admin] && FoCo_Player[playerid][id] != 368 && playerid != targetid)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command on other admins with the same or higher admin level as yourself. Naughty!");
		    return 1;
		}
	    SetPlayerDrunkLevel(targetid, amount);
		format(string, sizeof(string), "You set %s's (%d) drunklevel to %d",PlayerName(targetid), targetid, amount);
	    SendClientMessage(playerid, COLOR_NOTICE, string);
	    AdminLog(string);
	}
    return 1;
}

CMD:resetguns(playerid, params[])
{
	new targetid, string[128];
	if(IsAdmin(playerid, ACMD_RESETGUNS))
	{
	    if(sscanf(params, "u", targetid))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /resetguns [ID]");
	        return 1;
	    }
	    if(targetid == INVALID_PLAYER_ID)
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "[ERROR]: Invalid ID/Name.");
			return 1;
	    }
	    ResetPlayerWeapons(targetid);
	    GiveGuns(targetid);

		format(string, sizeof(string), "AdmCmd(%d): %s %s has reset %s(%d) guns.", ACMD_RESETGUNS, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
		SendAdminMessage(ACMD_RESETGUNS,string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	}
	return 1;
}

CMD:as(playerid, params[]) // temp as
{
	if(IsAdmin(playerid,ACMD_AS))
	{
		new targetid, string[128];
		if(sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /as [id]");
			return 1;
		}

		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}

		new Float:Health, Float:Armour, world, int, vehid, cweapons[13][2], mainhand;

		GetPlayerHealth(targetid, Health);
		GetPlayerArmour(targetid, Armour);
		int = GetPlayerInterior(targetid);
		world = GetPlayerVirtualWorld(targetid);
		vehid = GetPlayerVehicleID(targetid);
		mainhand = GetPlayerWeapon(targetid);

		for (new i = 0; i < 13; i++)
		{
			GetPlayerWeaponData(targetid, i, cweapons[i][0], cweapons[i][1]);
		}

		format(string, sizeof(string), "==========[Anti Vars For %s]==========", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "General | Health: %f :: Armour: %f :: Interior: %d :: World: %d", Health, Armour, int, world);
		SendClientMessage(playerid, COLOR_GRAD2, string);
		format(string, sizeof(string), "Current | VehicleID: %d :: MainHandWep: %s", vehid, WeapNames[mainhand][WeapName]);
		SendClientMessage(playerid, COLOR_GRAD2, string);
		format(string, sizeof(string), "Wep 0-1 | Slot0: %s (%d) :: Slot1: %s (%d)", WeapNames[cweapons[0][0]][WeapName], cweapons[0][1], WeapNames[cweapons[1][0]][WeapName], cweapons[1][1]);
		SendClientMessage(playerid, COLOR_GRAD2, string);
		format(string, sizeof(string), "Wep 2-3 | Slot2: %s (%d) :: Slot3: %s (%d)", WeapNames[cweapons[2][0]][WeapName], cweapons[2][1], WeapNames[cweapons[3][0]][WeapName], cweapons[3][1]);
		SendClientMessage(playerid, COLOR_GRAD2, string);
		format(string, sizeof(string), "Wep 4-5 | Slot4: %s (%d) :: Slot5: %s (%d)", WeapNames[cweapons[4][0]][WeapName], cweapons[4][1], WeapNames[cweapons[5][0]][WeapName], cweapons[5][1]);
		SendClientMessage(playerid, COLOR_GRAD2, string);
		format(string, sizeof(string), "Wep 6-7 | Slot6: %s (%d) :: Slot7: %s (%d)", WeapNames[cweapons[6][0]][WeapName], cweapons[6][1], WeapNames[cweapons[7][0]][WeapName], cweapons[7][1]);
		SendClientMessage(playerid, COLOR_GRAD2, string);
		format(string, sizeof(string), "Wep 8-9 | Slot8: %s (%d) :: Slot9: %s (%d)", WeapNames[cweapons[8][0]][WeapName], cweapons[8][1], WeapNames[cweapons[9][0]][WeapName], cweapons[9][1]);
		SendClientMessage(playerid, COLOR_GRAD2, string);
		format(string, sizeof(string), "Wep 10-11 | Slot10: %s (%d) :: Slot11: %s (%d)", WeapNames[cweapons[10][0]][WeapName], cweapons[10][1], WeapNames[cweapons[11][0]][WeapName], cweapons[11][1]);
		SendClientMessage(playerid, COLOR_GRAD2, string);
		format(string, sizeof(string), "Wep 12 | Slot12: %s (%d)", WeapNames[cweapons[12][0]][WeapName], cweapons[12][1]);
		SendClientMessage(playerid, COLOR_GRAD2, string);
		SendClientMessage(playerid, COLOR_GREEN, "============================================");

		SendClientMessage(playerid, COLOR_WARNING, "-- This command informs of what's on them. Not what they should or shouldn't have.");
		SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Use /adas for advanced weapon details.");
	}
	return 1;
}

CMD:undercover(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_UNDERCOVER))
	{
		if(aUndercover[playerid] == 0)
		{
			aUndercover[playerid] = 1;
			SendClientMessage(playerid, COLOR_NOTICE, "[UnderCover]: Activated");
		}
		else
		{
			aUndercover[playerid] = 0;
			SendClientMessage(playerid, COLOR_NOTICE, "[UnderCover]: De-Activated");
		}
	}
	return 1;
}

CMD:spectators(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SPECTATORS))
	{
		new string[128], count;
		foreach(Player, i)
		{
			if(Spectating[i] != -1)
			{
				format(string, sizeof(string), "[Spec Report]: %s is spectating %s", PlayerName(i), PlayerName(Spectating[i]));
				SendClientMessage(playerid, COLOR_NOTICE, string);
				count++;
			}
		}
		if(count == 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "Nobody is speccing anybody you fucktard.");
		}
	}
	return 1;
}



CMD:dev_note(playerid, params[])
{
	if(FoCo_Player[playerid][id] != 109979 || FoCo_Player[playerid][id] != 28975 || FoCo_Player[playerid][id] != 2852 || FoCo_Player[playerid][id] != 4762)
	{
		return 0;
	}
	else
	{
		new targetstr[255];
		if (sscanf(params, "s[255]", targetstr))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /dev_note [string]");
			return 1;
		}
		new string[255];
		format(string, sizeof(string), "Dev_Note: %s", targetstr);
		notes(string);
		SendClientMessage(playerid, COLOR_NOTICE, string);
	}
	return 1;
}

CMD:carownernamedb(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_CAROWNERNAMEDB))
	{
		new targetstr[25];
		if (sscanf(params, "s[25]", targetstr))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /carownernamedb [USERS NAME ONLY]");
			return 1;
		}
		new msg[250];
		format(msg, sizeof(msg), "SELECT * FROM `FoCo_Player_Vehicles` WHERE `oname`='%s'", targetstr);
		mysql_query(msg, MYSQL_THREAD_SEARCHMYCAR, playerid, con);
	}
	return 1;
}

CMD:watchpm(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_WATCHPM))
	{
		new string[180], targetid;
		if (sscanf(params, "u", targetid))
		{
		    if(WatchPMAdmin[playerid] != -1)
			{
				WatchPMAdmin[playerid] = -1;
				SendClientMessage(playerid, COLOR_NOTICE, "You stopped watching PM's.");
				return 1;
			}
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /watchpm [ID/Name]");
			return 1;
		}
		if(targetid == playerid)
	    {
	        SendClientMessage(playerid, COLOR_NOTICE, "You can't watch your own PM's.");
	        return 1;
		}
		WatchPMAdmin[playerid] = targetid;
		format(string, sizeof(string), "AdmCmd(%d): %s is now watching %s(%d) PM's.", ACMD_WATCHPM,PlayerName(playerid), PlayerName(targetid), targetid);
		SendAdminMessage(ACMD_WATCHPM,string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	}
	return 1;
}

CMD:moveintocar(playerid,params[])
{
	if(IsAdmin(playerid, ACMD_MOVEINTOCAR))
	{
		new string[128], targetid,vehicleid,option;
		if(sscanf(params, "uii", targetid,vehicleid,option))
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /moveintocar [ID/Name] [VehicleID] [Position] (0 = Driver, 1 = RF Pass., 2 = LB Pass., 3 = RB Pass,4+ = Coach)");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(option < 0 || option > 10)
		{
  			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can only choose seats between 0 and 10");
	    	return 1;
		}
		PutPlayerInVehicle(targetid,vehicleid,option);
		new actualvehicle = GetPlayerVehicleID(targetid);
		if(actualvehicle != vehicleid)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The vehicle ID is either invalid or the seat is taken.");
			return 1;
		}
		else
		{
			format(string, sizeof(string), "[INFO]: %s (%d) teleported you into a vehicle(%d).", PlayerName(playerid), playerid, vehicleid);
			SendClientMessage(targetid, COLOR_NOTICE, string);
			format(string,sizeof(string), "AcmdCmd(%d): %s teleported %s (%d) into vehicle ID %d in seat ID: %d", ACMD_MOVEINTOCAR,PlayerName(playerid), PlayerName(targetid),targetid,vehicleid,option);
			SendAdminMessage(ACMD_MOVEINTOCAR,string);
			IRC_GroupSay(gLeads,IRC_FOCO_LEADS,string);
			AdminLog(string);
		}
		
	}
	return 1;
}

CMD:watchteamchat(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_WATCHTEAMCHAT))
	{
		new string[180], targetid;
		if (sscanf(params, "i", targetid))
		{
			if(WatchGAdmin[playerid] >= 0)
			{
				WatchGAdmin[playerid] = -1;
				SendClientMessage(playerid, COLOR_NOTICE, "Chat stopped watching.");
				return 1;
			}

			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /watchteamchat [ID]");
			return 1;
		}

		WatchGAdmin[playerid] = targetid;
		format(string, sizeof(string), "AdmCmd(%d): %s %s is now watching team ID: %d's chat.",ACMD_WATCHTEAMCHAT,GetPlayerStatus(playerid), PlayerName(playerid), targetid);
		SendAdminMessage(ACMD_WATCHTEAMCHAT,string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	}
	return 1;
}

CMD:removefromclan(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_REMOVEFROMCLAN))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new string[255], targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /removefromclan [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}


		FoCo_Player[targetid][clan] = -1;
		FoCo_Player[targetid][clanrank] = -1;

		format(string, sizeof(string), "[AdmCMD]: You have been uninvited from your clan by %s %s.", GetPlayerStatus(playerid), PlayerName(playerid));
		SendClientMessage(targetid, COLOR_NOTICE, string);
		format(string, sizeof(string), "[AdmCMD]: You removed %s from their clan.", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has removed %s from their clan.",ACMD_REMOVEFROMCLAN, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
		SendAdminMessage(ACMD_REMOVEFROMCLAN,string);
		AdminLog(string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	}
	return 1;
}

CMD:rfclan(playerid, params[])
{
	return cmd_removefromclan(playerid, params);
}

CMD:agive(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_AGIVE))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new option[50], targetid, val, string[128];
		if (sscanf(params, "us[50] ", targetid, option))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "	[USAGE]: /agive [ID/PON] [Parameter]");
			SendClientMessage(playerid, COLOR_GRAD1, " [PARAMS]: Money - Jetpack - Killstreak - Boost");
			return 1;
	    }

		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  This player is not ingame.");
			return 1;
		}

		if(strcmp(option,"Money", true) == 0)
		{
			if (sscanf(params, "us[50]d", targetid, option, val))
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "	[USAGE]: /agive [ID/PoN] [money] [value]");
				return 1;
			}
			GivePlayerMoney(targetid, val);
			new moneystring[256];
			format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ AGIVE_ADCMD by %s(%i).", PlayerName(targetid), targetid, val, PlayerName(playerid), playerid);
			MoneyLog(moneystring);
			format(string, sizeof(string), "You have been given $%d from %s %s", val, GetPlayerStatus(playerid), PlayerName(playerid));
			SendClientMessage(targetid, COLOR_WHITE, string);
			format(string, sizeof(string), "AdmCmd(%d): %s %s has given %s $%d",ACMD_AGIVE, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), val);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendAdminMessage(ACMD_AGIVE, string);
			AdminLog(string);
			return 1;
		}
		else if(strcmp(option,"Jetpack", true) == 0)
		{
			SetPlayerSpecialAction(targetid, SPECIAL_ACTION_USEJETPACK);
			format(string, sizeof(string), "You have been given a jetpack from %s %s", GetPlayerStatus(playerid), PlayerName(playerid));
			SendClientMessage(targetid, COLOR_WHITE, string);
			format(string, sizeof(string), "AdmCmd(%d): %s %s has given %s a jetpack",ACMD_AGIVE, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendAdminMessage(ACMD_AGIVE,string);
			AdminLog(string);
			return 1;
		}
		else if(strcmp(option,"Killstreak", true) == 0)
		{
			if (sscanf(params, "us[50]d", targetid, option, val))
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "	[USAGE]: /agive [ID/PoN] [killstreak] [value]");
				return 1;
			}

			CurrentKillStreak[targetid] = val;
			format(string, sizeof(string), "You have been given a %d killstreak from %s %s", val, GetPlayerStatus(playerid), PlayerName(playerid));
			SendClientMessage(targetid, COLOR_WHITE, string);
			format(string, sizeof(string), "AdmCmd(%d): %s %s has given %s a %d killstreak",ACMD_AGIVE, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), val);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendAdminMessage(ACMD_AGIVE,string);
			AdminLog(string);
			return 1;
		}
		else if(strcmp(option,"Boost", true) == 0)
		{
			if(NitrousBoostEn[targetid] == 0)
			{
				NitrousBoostEn[targetid] = 1;
			}
			else
			{
				NitrousBoostEn[targetid] = 0;
			}
			format(string, sizeof(string), "Nitro Boost toggled by %s %s", GetPlayerStatus(playerid), PlayerName(playerid));
			SendClientMessage(targetid, COLOR_WHITE, string);
			format(string, sizeof(string), "AdmCmd(%d): %s %s has given %s nitro boost (toggled)",ACMD_AGIVE, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendAdminMessage(ACMD_AGIVE,string);
			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  This does not exsist");
		}
	}
	return 1;
}

/* LEVEL ONE ADMIN COMMANDS */

CMD:achat(playerid, params[])
{
	cmd_a(playerid, params);
	return 1;
}

CMD:a(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_A))
	{
		new message[256];
		if (sscanf(params, "s[256]", message))
		{
			format(message, sizeof(message), "[USAGE]: {%06x}/achat{%06x}[Message]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, message);
			return 1;
		}

		new string[256];
		if(strlen(message) > 80)
		{
		    new message2[300];
		 	strmid(message2,message,80,strlen(message),sizeof(message2));
		 	strmid(message,message,0,80,sizeof(message));
			format(string, sizeof(string), "%s {%06x}%s:{%06x} %s", GetPlayerStatus(playerid), COLOR_GREEN >>> 8,  PlayerName(playerid), COLOR_YELLOW >>> 8, message);
			SendAdminMessage(ACMD_A, string);
			format(string, sizeof(string), "%s %s (%d): %s", GetPlayerStatus(playerid), PlayerName(playerid),playerid, message);
			AdminChatLog(string);
			format(string, sizeof(string), "3[AChat]: %s {%06x}%s:{%06x} %s", GetPlayerStatus(playerid), COLOR_GREEN >>> 8,  PlayerName(playerid), COLOR_YELLOW >>> 8, message);
			IRC_GroupSay(gAdmin, IRC_FOCO_ADMIN, string);
			format(string, sizeof(string), "%s {%06x}%s:{%06x} %s", GetPlayerStatus(playerid), COLOR_GREEN >>> 8,  PlayerName(playerid), COLOR_YELLOW >>> 8, message2);
			SendAdminMessage(ACMD_A, string);
			format(string, sizeof(string), "%s %s (%d): %s", GetPlayerStatus(playerid), PlayerName(playerid),playerid, message2);
			AdminChatLog(string);
			format(string, sizeof(string), "3[AChat]: %s {%06x}%s:{%06x} %s", GetPlayerStatus(playerid), COLOR_GREEN >>> 8,  PlayerName(playerid), COLOR_YELLOW >>> 8, message2);
			IRC_GroupSay(gAdmin, IRC_FOCO_ADMIN, string);
		}
		else
		{
			format(string, sizeof(string), "%s {%06x}%s:{%06x} %s", GetPlayerStatus(playerid), COLOR_GREEN >>> 8,  PlayerName(playerid), COLOR_YELLOW >>> 8, message);
			SendAdminMessage(ACMD_A, string);
			format(string, sizeof(string), "%s %s (%d): %s", GetPlayerStatus(playerid), PlayerName(playerid),playerid, message);
			AdminChatLog(string);
			format(string, sizeof(string), "3[AChat]: %s {%06x}%s:{%06x} %s", GetPlayerStatus(playerid), COLOR_GREEN >>> 8,  PlayerName(playerid), COLOR_YELLOW >>> 8, message);
			IRC_GroupSay(gAdmin, IRC_FOCO_ADMIN, string);
		}
	}
	return 1;
}

CMD:aduty(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_ADUTY))
	{
		new string[128];
		if(ADuty[playerid] == 0)
		{
			ADuty[playerid] = 1;
			format(string, sizeof(string), "[NOTICE]: %s %s is now on duty.", GetPlayerStatus(playerid), PlayerName(playerid));
			AdminLog(string);
			AdutyOldColor[playerid] = GetPlayerColor(playerid);
			SetPlayerColor(playerid, COLOR_ADMIN);
			if(FoCo_Player[playerid][id] != 2 || FoCo_Player[playerid][id] != 4)
			{
				SendClientMessageToAll(COLOR_ADMIN, string);
			}
			IRC_GroupSay(gAdmin, IRC_FOCO_ADMIN, string);
			SetPlayerHealth(playerid, INFINITY);
			return 1;
		}
		else
		{
			ADuty[playerid] = 0;
			format(string, sizeof(string), "[NOTICE]: %s %s is now off duty.", GetPlayerStatus(playerid), PlayerName(playerid));
			AdminLog(string);
			if(FoCo_Player[playerid][id] != 2 || FoCo_Player[playerid][id] != 4)
			{
				SendClientMessageToAll(COLOR_ADMIN, string);
			}
			if(GetPVarInt(playerid,"PlayerStatus") == 1)
			{
			    SetPlayerColor(playerid, GetPVarInt(playerid, "MotelColor"));
			}
			else
			{
				SetPlayerColor(playerid, AdutyOldColor[playerid]);
			}
			IRC_GroupSay(gAdmin, IRC_FOCO_ADMIN, string);
			SetPlayerHealth(playerid, 99);
			GiveGuns(playerid);
		}
	}
	return 1;
}

CMD:goto(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GOTO))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /goto [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(GetPlayerState(targetid) == 9 || GetPlayerState(targetid) == 7)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  This player is currently spectating or not yet spawned.");
			return 1;
		}
		new string[128], Float:px, Float:py, Float:pz, vw_world, vw_int;
		GetPlayerPos(targetid, px, py, pz);
		vw_world = GetPlayerVirtualWorld(targetid);
		vw_int = GetPlayerInterior(targetid);
		SetPlayerVirtualWorld(playerid, vw_world);
		SetPlayerInterior(playerid, vw_int);
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			SetVehiclePos(GetPlayerVehicleID(playerid), px, py, pz);
			SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), vw_world);
			LinkVehicleToInterior(GetPlayerVehicleID(playerid), vw_int);
		}
		else
		SetPlayerPos(playerid, px+1, py, pz+1);
		format(string, sizeof(string), "                You teleported to %s.", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
	}
	return 1;
}

CMD:get(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GET))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /get [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		new string[128], Float:px, Float:py, Float:pz, vw_int, vw_world;
		GetPlayerPos(playerid, px, py, pz);
		vw_int = GetPlayerInterior(playerid);
		vw_world = GetPlayerVirtualWorld(playerid);
		SetPlayerInterior(targetid, vw_int);
		SetPlayerVirtualWorld(targetid, vw_world);
		if(GetPlayerState(targetid) == PLAYER_STATE_DRIVER)
		{
			SetVehicleVirtualWorld(GetPlayerVehicleID(targetid), vw_world);
			SetVehiclePos(GetPlayerVehicleID(targetid), px, py, pz);
			LinkVehicleToInterior(GetPlayerVehicleID(targetid), vw_int);
		}
		else
		SetPlayerPos(targetid, px+1, py, pz+1);
		format(string, sizeof(string), "You have teleported %s to you.", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		format(string, sizeof(string), "[NOTICE] %s has teleported you.", PlayerName(playerid));
		SendClientMessage(targetid, COLOR_NOTICE, string);
	}
	return 1;
}

CMD:aveh(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_AVEH))
	{
		new model[56], modelid, col1, col2;
		if(sscanf(params, "s[56]II", model, col1, col2))
		{
			SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: /veh [model] [col1] [col2]");
			return 1;
		}
		else
		{
			if(GetVehicleModelIDFromName(model) == -1)
			{
				modelid = strval(model);
			}
			else modelid = GetVehicleModelIDFromName(model);
			if(modelid < 400 || modelid > 611)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[ERROR]:  Invalid vehicle model.");
				return 1;
			}

			if(col1 < 0 || col1 > 255)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[ERROR]:  Invalid Color.");
				return 1;
			}

			if(col2 < 0 || col2 > 255)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[ERROR]:  Invalid Color.");
				return 1;
			}

			new Float:x, Float:y, Float:z, Float:angle, car, string[128];
			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, angle);
			new vw = GetPlayerVirtualWorld(playerid);
			new int = GetPlayerInterior(playerid);
			car = CreateVehicle(modelid, x, y, z, angle, col1, col2, 60000);
			TempVeh[car] = 1;
			FoCo_Vehicles[car][v_type] = VEHICLE_TYPE_TEMPORARY;
			FoCo_Vehicles[car][cint] = int;
			FoCo_Vehicles[car][cvw] = vw;
			LinkVehicleToInterior(car, int);
			SetVehicleVirtualWorld(car, vw);
			PutPlayerInVehicle(playerid, car, 0);
			format(string, sizeof(string), "AdmCmd(%d): %s %s has spawned a vehicle (Non-Saving) [Model: %d][ID: %d]",ACMD_AVEH, GetPlayerStatus(playerid), PlayerName(playerid), modelid,GetPlayerVehicleID(playerid));
			SendAdminMessage(ACMD_AVEH,string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			AdminLog(string);
		}
	}
	return 1;
}

CMD:gotols(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GOTOLS))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), 0);
			SetVehiclePos(GetPlayerVehicleID(playerid), 1522.9249,-1676.3263,13.5469);
		}
		else
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 1522.9249,-1676.3263,13.5469);
		}
		SetPlayerInterior(playerid, 0);
	}
	return 1;
}

CMD:gotolv(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GOTOLV))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), 0);
			SetVehiclePos(GetPlayerVehicleID(playerid), 2034.7997,1545.7374,10.8203);
		}
		else
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 2034.7997,1545.7374,10.8203);
		}
		SetPlayerInterior(playerid, 0);
	}
	return 1;
}

CMD:gotosf(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GOTOSF))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), 0);
			SetVehiclePos(GetPlayerVehicleID(playerid), -2611.1533,1369.2137,7.1712);
		}
		else
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, -2611.1533,1369.2137,7.1712);
		}
		SetPlayerInterior(playerid, 0);
	}
	return 1;
}

CMD:gotopickup(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GOTOPICKUP))
	{
		new targetid;
		if (sscanf(params, "i", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /gotopickup [Pickup ID]");
			return 1;
		}
		if(FoCo_Pickups[targetid][LP_pickupid] == 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid pickup ID.");
			return 1;
		}
		new string[128];
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			SetVehiclePos(GetPlayerVehicleID(playerid), FoCo_Pickups[targetid][LP_x], FoCo_Pickups[targetid][LP_y], FoCo_Pickups[targetid][LP_z]);
		}
		else SetPlayerPos(playerid, FoCo_Pickups[targetid][LP_x], FoCo_Pickups[targetid][LP_y], FoCo_Pickups[targetid][LP_z]);
		format(string, sizeof(string), "You teleport to pickup ID %d", targetid);
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
	}
	return 1;
}

CMD:gotoxyz(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GOTOXYZ))
	{
		new Float:xyz_x, Float:xyz_y, Float:xyz_z;
		if (sscanf(params, "fff", xyz_x, xyz_y, xyz_z))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /gotoxyz [x] [y] [z]");
			return 1;
		}

		new string[128];
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			SetVehiclePos(GetPlayerVehicleID(playerid), xyz_x, xyz_y, xyz_z);
		}else SetPlayerPos(playerid, xyz_x, xyz_y, xyz_z);
		format(string, sizeof(string), "You teleport to x: %f y: %f z: %f", xyz_x, xyz_y, xyz_z);
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
	}
	return 1;
}

CMD:togmain(playerid, params[])
{
 	if(IsAdmin(playerid, ACMD_TOGMAIN))
	{
		if(GlobalChatEnabled == 0)
		{
		    new string[128];
			SendClientMessageToAll(COLOR_WARNING, "[INFO]: Global chat enabled!");
			GlobalChatEnabled = 1;
			format(string, sizeof(string), "AdmCmd(%d): %s has enabled the global chat", ACMD_TOGMAIN,PlayerName(playerid));
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendAdminMessage(ACMD_TOGMAIN,string);
		}
		else if(GlobalChatEnabled == 1)
		{
			new string[128];
			SendClientMessageToAll(COLOR_WARNING, "[INFO]: Global chat disabled!");
			GlobalChatEnabled = 0;
			format(string, sizeof(string), "AdmCmd(%d): %s has disabled the global chat", ACMD_TOGMAIN, PlayerName(playerid));
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendAdminMessage(ACMD_TOGMAIN,string);
		}
	}
	return 1;
}

CMD:setint(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETINT))
	{
		new targetid;
		if (sscanf(params, "i", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setint [intID]");
			return 1;
		}

		SetPlayerInterior(playerid, targetid);
		SendClientMessage(playerid, COLOR_NOTICE, "Your interior has been set");
	}
	return 1;
}

CMD:setworld(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETWORLD))
	{
		new targetid;
		if (sscanf(params, "i", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setworld [worldID]");
			return 1;
		}

		SetPlayerVirtualWorld(playerid, targetid);
		SendClientMessage(playerid, COLOR_NOTICE, "Your world has been set");
	}
	return 1;
}

CMD:gotocar(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GOTOCAR))
	{
		new targetid;
		if (sscanf(params, "i", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /gotocar [Veh ID]");
			return 1;
		}
		new string[128], Float:px, Float:py, Float:pz;
		GetVehiclePos(targetid, px, py, pz);
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			SetVehiclePos(GetPlayerVehicleID(playerid), px, py, pz);
		}
		else SetPlayerPos(playerid, px+1, py, pz+1);
		format(string, sizeof(string), "You have teleported to vehicle ID %d.", targetid);
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
	}
	return 1;
}

CMD:despawncar(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_DESPAWNCAR))
	{
		new targetid, string[128];
		if (sscanf(params, "i", targetid))
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
				new vid = GetPlayerVehicleID(playerid);
				format(string, sizeof(string), "AdmCMD: Vehicle %d has been respawned", vid);
				SendClientMessage(playerid, COLOR_NOTICE, string);
				SetVehicleToRespawn(vid);
				SetVehiclePos(vid, FoCo_Vehicles[vid][cx], FoCo_Vehicles[vid][cy], FoCo_Vehicles[vid][cz]);
				SetVehicleZAngle(vid, FoCo_Vehicles[vid][cangle]);
				LinkVehicleToInterior(vid, FoCo_Vehicles[vid][cint]);
				SetVehicleVirtualWorld(vid, FoCo_Vehicles[vid][cvw]);
			}
			else
			{
				format(string, sizeof(string), "[USAGE]: {%06x}/despawncar{%06x}[ID]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
				SendClientMessage(playerid, COLOR_SYNTAX, string);
			}
			return 1;
		}
		format(string, sizeof(string), "AdmCMD: Vehicle %d has been respawned", targetid);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		SetVehicleToRespawn(targetid);
		SetVehiclePos(targetid, FoCo_Vehicles[targetid][cx], FoCo_Vehicles[targetid][cy], FoCo_Vehicles[targetid][cz]);
		SetVehicleZAngle(targetid, FoCo_Vehicles[targetid][cangle]);
		LinkVehicleToInterior(targetid, 0);
		SetVehicleVirtualWorld(targetid, 0);
	}
	return 1;
}

CMD:removewarn(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_REMOVEWARN))
	{
		new targetid, string[256];
		if (sscanf(params, "u", targetid))
		{
			format(string, sizeof(string), "[USAGE]: {%06x}/removewarn {%06x}[ID]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			return 1;
		}

		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		
		if(FoCo_Player[targetid][warns] <= 0)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot set this lower than 0");
		    return 1;
		}
		
		format(string, sizeof(string), "AdmCmd(%d): %s has removed 1 warning from %s (%d)",ACMD_REMOVEWARN,PlayerName(playerid), PlayerName(targetid), targetid);
		SendAdminMessage(ACMD_REMOVEWARN,string);
		AdminLog(string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		FoCo_Player[targetid][warns]--;
	}
	return 1;
}

CMD:warn(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_WARN) || IsTrialAdmin(playerid))
	{
		new targetid, string[256], reason[128], wstring[256];
		if (sscanf(params, "us", targetid, reason))
		{
			format(string, sizeof(string), "[USAGE]: {%06x}/warn {%06x}[ID] [Reason]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(FoCo_Player[targetid][admin] >= FoCo_Player[playerid][admin] && FoCo_Player[playerid][id] != 368 && playerid != targetid)
		{
			if(FoCo_Player[playerid][tester] > 0 && FoCo_Player[playerid][admin] == 0 && FoCo_Player[targetid][admin] == 0)
			{
				goto itskay;
			}
			else
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command on other admins with the same or higher admin level as yourself. Naughty!");
				return 1;
			}
		}
		itskay:
		format(string, sizeof(string), "AdmCmd(%d): %s has warned %s (%d) for %s",ACMD_WARN, PlayerName(playerid), PlayerName(targetid), targetid, reason);
		SendClientMessageToAll(COLOR_RED, string);
		AdminLog(string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		FoCo_Player[targetid][warns]++;
		FoCo_Player[playerid][admin_warns]++;
		DataSave(targetid);
		
		switch(FoCo_Player[targetid][warns])
		{
		    case 3:
			{
				format(wstring,128,"%d 5 Auto-Ajail for 3rd warning (%s)",targetid, reason);
				cmd_jail(playerid,wstring);
			}
			case 5:
			{
				format(wstring,128,"%d 10 Auto-Ajail for 5th warning (%s)",targetid, reason);
				cmd_jail(playerid,wstring);
			}
			case 7:
			{
				format(wstring,128,"%d 15 Auto-Ajail for 7th warning (%s)",targetid, reason);
				cmd_jail(playerid,wstring);
			}
			case 10:
			{
				format(wstring, 128, "%d 1 Auto-Tempban for 10 warnings (%s)",targetid, reason);
				cmd_tempban(playerid, wstring);
			}
			case 15:
			{
				format(wstring, 128, "%d 2 Auto-Tempban for 15 warnings (%s)",targetid, reason);
				cmd_tempban(playerid, wstring);
			}
			case 20..100:
			{
				format(wstring, 128, "%d Auto-Ban for %d warnings (%s)",targetid, FoCo_Player[targetid][warns], reason);
				cmd_ban(playerid, wstring);
			}
		}
		mysql_real_escape_string(reason, reason);
		format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', '%s', '5', '%s', '%s')", FoCo_Player[targetid][id], PlayerName(playerid), reason, TimeStamp());
		mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
	}
	return 1;
}

CMD:kick(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_KICK) || IsTrialAdmin(playerid))
	{
		new targetid, reason[128];
		if (sscanf(params, "us[128]", targetid, reason))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /kick [ID/Name] [Reason]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(AdminLvl(playerid) == 0 && IsTrialAdmin(playerid) && AdminLvl(targetid) == 0)
		{
            new string[256];
			format(string, sizeof(string), "AdmCmd(%d): %s has kicked %s(%d), Reason: %s", ACMD_KICK,PlayerName(playerid), PlayerName(targetid), targetid, reason);
			AdminLog(string);
			SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
			FoCo_Player[playerid][admin_kicks]++;
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
			mysql_real_escape_string(reason, reason);
			format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', '%s', '2', '%s', '%s')", FoCo_Player[targetid][id], PlayerName(playerid), reason, TimeStamp());
			mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
			SetTimerEx("KickPlayer", 1000, false, "d", targetid);
			return 1;
		}
		if(FoCo_Player[targetid][admin] >= FoCo_Player[playerid][admin] && FoCo_Player[playerid][id] != 368 && playerid != targetid)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command on other admins with the same or higher admin level as yourself. Naughty!");
		    return 1;
		}
  		new string[256];
		format(string, sizeof(string), "AdmCmd(%d): %s has kicked %s(%d), Reason: %s", ACMD_KICK,PlayerName(playerid), PlayerName(targetid), targetid, reason);
		AdminLog(string);
		SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
		FoCo_Player[playerid][admin_kicks]++;
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		mysql_real_escape_string(reason, reason);
		format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', '%s', '2', '%s', '%s')", FoCo_Player[targetid][id], PlayerName(playerid), reason, TimeStamp());
		mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
		SetTimerEx("KickPlayer", 1000, false, "d", targetid);
	}
	return 1;
}

CMD:kickall(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_KICKALL))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
	    foreach(Player, i)
	    {
	        Kick(i);
	    }
	}
	return 1;
}

CMD:jail(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_JAIL))
	{
		new targetid, reason[128], time;
		if (sscanf(params, "uis[128]", targetid, time, reason))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /jail [ID/Name] [Minutes] [Reason]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(GetPVarInt(targetid, "PlayerStatus") == 1 && Event_InProgress != -1)
		{
		    if(Event_InProgress == 0)
			{
			    SendClientMessage(playerid, COLOR_WARNING, "Please wait with jailing the player untill the event starts, otherwise all events will bug up.");
				return 1;
			}
			
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
		if(FoCo_Player[targetid][admin] >= FoCo_Player[playerid][admin] && FoCo_Player[playerid][id] != 368 && playerid != targetid)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command on other admins with the same or higher admin level as yourself. Naughty!");
		    return 1;
		}
		new string[256];
		format(string, sizeof(string), "AdmCmd(%d): %s has jailed %s(%d) for %d min, Reason: %s",ACMD_JAIL, PlayerName(playerid), PlayerName(targetid), targetid, time, reason);
		SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
		AdminLog(string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		FoCo_Player[targetid][jailed] = time*60;
		SetPlayerPos(targetid, 154.1683,-1952.1167,47.8750);
		SetPlayerVirtualWorld(targetid, targetid);
		SetPlayerInterior(targetid, 0);
		format(string, sizeof(string), "JAIL: %s (%d) jailed %s (%d) for %d mins, Reason: %s", PlayerName(playerid), playerid, PlayerName(targetid), targetid, time, reason);
		AdminLog(string);
		TogglePlayerControllable(targetid, 1);
		FoCo_Player[playerid][admin_jails]++;
		ResetPlayerWeapons(targetid);
		mysql_real_escape_string(reason, reason);
		format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`, `time`) VALUES ('%d', '%s', '1', '%s', '%s','%d')", FoCo_Player[targetid][id], PlayerName(playerid), reason, TimeStamp(),time);
		mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
	}
	return 1;
}

CMD:trans(playerid, params[])
{
	if(IsAdmin(playerid,ACMD_TRANS))
	{
		if(ADuty[playerid] == 0 && FoCo_Player[playerid][admin] < 5)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not use this unless you are on admin duty.");
			return 1;
		}
		if(GetPlayerInterior(playerid) != 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're in an interior, you will need to exit before this action can be completed.");
			return 1;
		}
		if(GetPlayerVirtualWorld(playerid) != 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're in a different world, you will need to exit before this action can be completed.");
			return 1;
		}
		if(trans[playerid] == 1)
		{
			DestroyVehicle(transveh[playerid]);
			transveh[playerid] = -1;
			trans[playerid] = 0;

			SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You have left transformer mode.");
			return 1;
		}

		new string[128];
		new Float:txx, Float:tyy, Float:tzz, Float:taa;
		GetPlayerPos(playerid, txx, tyy, tzz);
		GetPlayerFacingAngle(playerid, taa);

		transveh[playerid] = CreateVehicle(transmodel[playerid][0], txx, tyy, tzz, taa, transcolor[playerid][0], transcolor[playerid][1], 60);
		trans[playerid] = 1;
		transslot[playerid] = 0;
		PutPlayerInVehicle(playerid, transveh[playerid], 0);

		format(string, sizeof(string), "AdmCmd(%d): %s %s has entered transformer mode.",ACMD_TRANS, GetPlayerStatus(playerid), PlayerName(playerid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_TRANS,string);
		SendClientMessage(playerid, COLOR_CMDNOTICE, "[AdmCMD]: You have entered transformer mode, press your horn to switch vehicle.");
		SendClientMessage(playerid, COLOR_CMDNOTICE, "Remember you can use /transpref to customize your vehicle preferences. /trans again will leave transformer mode.");
	}
	return 1;
}

CMD:transpref(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_TRANSPREF))
	{
		new string[255];
		format(string, sizeof(string), "Vehicle slot one (Currently: %d)\nVehicle slot two (Currently: %d)\nVehicle slot three (Currently: %d)\nColour slot one (Currently: %d)\nColour slot two (Currently: %d)", transmodel[playerid][0], transmodel[playerid][1], transmodel[playerid][2], transcolor[playerid][0], transcolor[playerid][1]);
		ShowPlayerDialog(playerid, DIALOG_TRANSSYS_1, DIALOG_STYLE_LIST, "Select the slot you wish to edit:", string, "Select", "Cancel");
	}
	return 1;
}

CMD:transreset(playerid, params[])
{
	if(IsAdmin(playerid,ACMD_TRANSRESET))
	{
		if(trans[playerid] == 1)
		{
			SendClientMessage(playerid, COLOR_WARNING,  "[ERROR]: You must leave transformer mode before you clear your preferences.");
			return 1;
		}
		ClearTransVars(playerid);
		SendClientMessage(playerid, COLOR_CMDNOTICE, "[AdmCMD]: Transformer mode preferences have been reset to default.");
	}
	return 1;
}

CMD:deletecar(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_DELETECAR))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new vehicleID  = GetPlayerVehicleID(playerid);
		if(vehicleID == 0)
		{
			if(sscanf(params, "i", vehicleID))
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /deletecar [Optional: ID]");
				return 1;
			}
		}

		if(neon[vehicleID] != 0)
		{
			DestroyObject(neon[vehicleID]);
			DestroyObject(neon2[vehicleID]);
			neon[vehicleID] = 0;
			neon2[vehicleID] = 0;
		}

		foreach(Player, i)
		{
			if(transveh[i] == vehicleID)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't delete a vehicle that does not exist in the database.");
				return 1;
			}
			if(GetPVarInt(i, "VehSpawn") ==  vehicleID)
			{
				new paramss[128];
				format(paramss, 128, "%d", GetPVarInt(i, "VehSpawn"));
				cmd_ppk(i, paramss);
				return 1;
			}
		}
		new string[256];
		if(FoCo_Vehicles[vehicleID][cid] >= 1)
		{
			if(FoCo_Vehicles[vehicleID][coid] == 0)
			{
				format(string, sizeof(string), "DELETE FROM `FoCo_Vehicles` WHERE `ID`='%d'", FoCo_Vehicles[vehicleID][cid]); // test this
			}
			else
			{
				format(string, sizeof(string), "DELETE FROM `FoCo_Player_Vehicles` WHERE `ID`='%d'", FoCo_Vehicles[vehicleID][cid]); // test this
			}
			mysql_query(string, MYSQL_DEL_CAR, FoCo_Vehicles[vehicleID][cid], con);
		}
		nullcar(vehicleID);
		DestroyVehicle(vehicleID);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has deleted carID: %d",ACMD_DELETECAR, GetPlayerStatus(playerid), PlayerName(playerid), vehicleID);
		SendAdminMessage(ACMD_DELETECAR,string);
		AdminLog(string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	}
	return 1;
}

CMD:forceteam(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_FORCETEAM))
	{
		new string[255],targetid, team;
		if (sscanf(params, "ud", targetid, team))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /forceteam [ID/Name] [Team ID]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid ID/Name.");
			return 1;
		}
		if(FoCo_Teams[team][team_type] == 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid team ID.");
			return 1;
		}

		FoCo_Team[targetid] = team;
		SetPlayerHealth(targetid, 0);
		format(string, sizeof(string), "[AdmCMD]: %s %s has force switched your team to %s.", GetPlayerStatus(playerid), PlayerName(playerid), FoCo_Teams[FoCo_Team[targetid]][team_name]);
		SendClientMessage(targetid, COLOR_NOTICE, string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has force switched %s's team to %s.",ACMD_FORCETEAM, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), FoCo_Teams[FoCo_Team[targetid]][team_name]);
		SendAdminMessage(ACMD_FORCETEAM,string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		DeletePVar(targetid, "ClanSkin");
	}
	return 1;
}

CMD:aban(playerid, params[])
{
	new targetid, admen, reason[50];
	if(sscanf(params, "dus[50]", admen, targetid, reason))
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Something went wrong..");
	}
	ABanPlayer(admen, targetid, reason, 1);
	return 1;
}

/*
CMD:ban(playerid, params[])//IF YOU EDIT THIS, EDIT THE GUARDIAN BANS
{
	if(IsAdmin(playerid, ACMD_BAN) || IsTrialAdmin(playerid))
	{
		new targetid, reason[128];
		if (sscanf(params, "us[128]", targetid, reason))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /ban [ID/Name] [Reason]");
			return 1;
		}

		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(FoCo_Player[targetid][id] == 368 && FoCo_Player[playerid][id] != 368)
		{
		    new string[256];
			format(string, sizeof(string), "[AdmCMD]: You just banned yourself by attempting to ban pEar.");
			SendClientMessage(playerid, COLOR_NOTICE, string);
			SendClientMessage(playerid, COLOR_NOTICE, "If you find this ban wrongful you can appeal at: forum.focotdm.com");
			format(string, sizeof(string), "[AdmCMD]: %s banned himself by attempting to ban pEar. How humiliating!", PlayerName(playerid));
			SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
			AdminLog(string);
			format(string, sizeof(string), "AdmCmd(%d): %s %s banned User %s, IP: %s",ACMD_BAN,GetPlayerStatus(playerid),PlayerName(playerid), PlayerName(playerid), ipstring[playerid]);
			SendAdminMessage(ACMD_BAN,string);
			format(string, sizeof(string), "BAN: %s banned himself for attempting to ban pEar!", PlayerName(playerid));
			AdminLog(string);
			IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
			FoCo_Player[playerid][banned] = 1;
			FoCo_Player[playerid][admin_bans]++;
			format(string, sizeof(string), "UPDATE `FoCo_Players` SET `banned` = `1` WHERE `username` = '%s'",PlayerName(playerid));
			mysql_query(string,MYSQL_ADMINACTION);
			format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', '%s', '3', '%s', '%s')", FoCo_Player[playerid][id], PlayerName(playerid), reason, TimeStamp());
			mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
			Ban(playerid);
		}
		if(AdminLvl(playerid) == 0 && IsTrialAdmin(playerid) && AdminLvl(targetid) == 0)
		{
		    new string[256];
			format(string, sizeof(string), "[AdmCMD]: %s you have been banned by %s for %s", PlayerName(targetid), PlayerName(playerid),reason);
			SendClientMessage(targetid, COLOR_NOTICE, string);
			SendClientMessage(targetid, COLOR_NOTICE, "If you find this ban wrongful you can appeal at: forum.focotdm.com");
			format(string, sizeof(string), "[AdmCMD]: %s has banned %s(%d), Reason: %s", PlayerName(playerid), PlayerName(targetid), targetid, reason);
			SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
			AdminLog(string);
			format(string, sizeof(string), "AdmCmd(%d): %s %s banned User %s, IP: %s",ACMD_BAN,GetPlayerStatus(playerid),PlayerName(playerid), PlayerName(targetid), ipstring[targetid]);
			SendAdminMessage(ACMD_BAN,string);
			format(string, sizeof(string), "BAN: %s (%d) banned %s (%d) for: %s , IP: %s", PlayerName(playerid), playerid, PlayerName(targetid), targetid, reason, ipstring[targetid]);
			AdminLog(string);
			IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
			FoCo_Player[targetid][banned] = 1;
			FoCo_Player[playerid][admin_bans]++;
			mysql_real_escape_string(reason, reason);
			format(string, sizeof(string), "UPDATE `FoCo_Players` SET `banned` = `1` WHERE `username` = '%s'",PlayerName(targetid));
			mysql_query(string,MYSQL_ADMINACTION);
			format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', '%s', '3', '%s', '%s')", FoCo_Player[targetid][id], PlayerName(playerid), reason, TimeStamp());
			mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
			Ban(targetid);
			return 1;
		}
		if(FoCo_Player[targetid][admin] >= FoCo_Player[playerid][admin] && FoCo_Player[playerid][id] != 368 && playerid != targetid)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command on other admins with the same or higher admin level as yourself. Naughty!");
		    return 1;
		}

		new string[256];
		format(string, sizeof(string), "[AdmCMD]: %s you have been banned by %s for %s", PlayerName(targetid), PlayerName(playerid),reason);
		SendClientMessage(targetid, COLOR_NOTICE, string);
		SendClientMessage(targetid, COLOR_NOTICE, "If you find this ban wrongful you can appeal at: forum.focotdm.com");
		format(string, sizeof(string), "[AdmCMD]: %s has banned %s(%d), Reason: %s", PlayerName(playerid), PlayerName(targetid), targetid, reason);
		SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
		AdminLog(string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s banned User %s, IP: %s",ACMD_BAN,GetPlayerStatus(playerid),PlayerName(playerid), PlayerName(targetid), ipstring[targetid]);
		SendAdminMessage(ACMD_BAN,string);
		format(string, sizeof(string), "BAN: %s (%d) banned %s (%d) for: %s , IP: %s", PlayerName(playerid), playerid, PlayerName(targetid), targetid, reason, ipstring[targetid]);
		AdminLog(string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		FoCo_Player[targetid][banned] = 1;
		FoCo_Player[playerid][admin_bans]++;
		mysql_real_escape_string(reason, reason);
		format(string, sizeof(string), "UPDATE `FoCo_Players` SET `banned` = `1` WHERE `username` = '%s'",PlayerName(targetid));
		mysql_query(string,MYSQL_ADMINACTION);
		format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', '%s', '3', '%s', '%s')", FoCo_Player[targetid][id], PlayerName(playerid), reason, TimeStamp());
		mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
		Ban(targetid);
	}
	return 1;
}


CMD:banip(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_BANIP))
	{
		new ip[18], string[128];
		if (sscanf(params, "s[18]", ip))
		{
			format(string, sizeof(string), "[USAGE]: {%06x}/banip {%06x}[ip]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			return 1;
		}
		format(string, sizeof(string), "AdmCmd(%d): %s %s has banned IP %s",ACMD_BANIP, GetPlayerStatus(playerid), PlayerName(playerid), ip);
		SendAdminMessage(ACMD_BANIP,string);
		AdminLog(string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		format(string, sizeof(string), "banip %s", ip);
		FoCo_Player[playerid][admin_bans]++;
		SendRconCommand(string);
		//SendRconCommand("reloadbans");
	}
	return 1;
}

CMD:unbanip(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_BANIP))
	{
		new ip[18], string[128];
		if (sscanf(params, "s[18]", ip))
		{
			format(string, sizeof(string), "[USAGE]: {%06x}/unbanip {%06x}[ip]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			return 1;
		}
		format(string, sizeof(string), "AdmCmd(%d): %s %s has unbanned IP %s",ACMD_BANIP, GetPlayerStatus(playerid), PlayerName(playerid), ip);
		SendAdminMessage(ACMD_BANIP,string);
		AdminLog(string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		format(string, sizeof(string), "unbanip %s", ip);
		SendRconCommand(string);
		SendRconCommand("reloadbans");
	}
	return 1;
}


CMD:unban(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_UNBAN))
	{
		new reason[128], banname[25];
		if (sscanf(params, "s[25]",banname))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /unban [Banned Username]");
			return 1;
		}
		new string[256];
        format(string, sizeof(string), "AdmCmd(%d): %s %s has unbanned User: %s", ACMD_UNBAN,GetPlayerStatus(playerid), PlayerName(playerid), banname);
		SendAdminMessage(ACMD_UNBAN,string);
		AdminLog(string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		DialogOptionVar3[playerid] = banname;
		DialogOptionVar4[playerid] = reason;
		format(string, sizeof(string), "SELECT * FROM `FoCo_Players` WHERE `username`='%s'", banname);
		mysql_query(string, MYSQL_UNBAN_THREAD, playerid, con);
	}
	return 1;
}
*/


CMD:resetkey(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_RESETKEY))
	{
		new targetid, string[128];
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /resetkey [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		format(string, sizeof(string), "               You have set %s's carkey to -1", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		format(string, sizeof(string), "               %s %s has set your carkey to -1", GetPlayerStatus(playerid),  PlayerName(playerid));
		SendClientMessage(targetid, COLOR_NOTICE, string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has reset %s's carkey to -1", ACMD_RESETKEY,GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
		SendAdminMessage(ACMD_RESETKEY,string);
		new car_update[150];
		format(car_update, sizeof(car_update), "UPDATE `FoCo_Players` SET `carid` = '-1' WHERE `ID` = '%d'", FoCo_Player[targetid][id]);
		mysql_query(car_update, MYSQL_KEY_UPDATE, playerid, con);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		AdminLog(string);
		FoCo_Player[targetid][users_carid] = -1;
	}
	return 1;
}

CMD:unjail(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_UNJAIL))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /unjail [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		new string[128], adname[56], targetname[56];
		GetPlayerName(targetid, targetname, sizeof(targetname));
		GetPlayerName(playerid, adname, sizeof(adname));
		if(FoCo_Player[targetid][jailed] <= 0)
		{
			format(string, sizeof(string), "[AdmCMD]: %s is not in jail or has already served their sentence.", targetname);
			SendClientMessage(playerid, COLOR_CMDNOTICE, string);
			return 1;
		}
		FoCo_Player[targetid][jailed] = 0;
		SetPlayerVirtualWorld(targetid, 0);
		SetPlayerHealth(targetid, 0);
		SetPlayerInterior(targetid, 0);
		SendClientMessage(targetid, COLOR_NOTICE, "[NOTICE]: You are now free to enjoy the server, try not to break any rules!");
		format(string, sizeof(string), "[AdmCMD]: %s %s has unjailed you", GetPlayerStatus(playerid), adname);
		SendClientMessage(targetid, COLOR_NOTICE, string);
		format(string, sizeof(string), "[AdmCMD]: You have unjailed %s.", targetname);
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		format(string, sizeof(string), "[AdmCMD]: %s(%d) has released %s(%d) from admin jail.", adname,playerid, targetname, targetid);
		SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		AdminLog(string);
	}
	return 1;
}

CMD:freeze(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_FREEZE))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /freeze [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
		}
		new string[128];
		if(Froze[playerid] == 0)
		{
			format(string, sizeof(string), "%s %s has frozen you.", GetPlayerStatus(playerid), PlayerName(playerid));
			SendClientMessage(targetid, COLOR_NOTICE, string);
			format(string, sizeof(string), "[AdmCMD]: You froze %s", PlayerName(targetid));
			SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		}
		TogglePlayerControllable(targetid, 0);
		Froze[playerid] = 1;
	}
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_UNFREEZE))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /unfreeze [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		new string[128];
		if(Froze[playerid] == 1)
		{
			format(string, sizeof(string), "[AdmCmd]%s %s has unfroze you.", GetPlayerStatus(playerid), PlayerName(playerid));
			SendClientMessage(targetid, COLOR_NOTICE, string);
			format(string, sizeof(string), "[AdmCmd]: You unfroze %s", PlayerName(targetid));
			SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		}
		TogglePlayerControllable(targetid, 1);
		Froze[playerid] = 0;
	}
	return 1;
}

CMD:forcerules(playerid, params[])
{

	if(IsAdmin(playerid, ACMD_FORCERULES))
	{
		new targetid;
		if(sscanf(params, "u", targetid))
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /forcerules [ID]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		
		new string[128];
		format(string, sizeof(string), "[NOTICE] You were forced to read the rules by %s %s", GetPlayerStatus(playerid), PlayerName(playerid));
		SendClientMessage(targetid, COLOR_SYNTAX, string);
		format(string, sizeof(string), "[AdmCMD]: You forced %s to read the rules", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has forced %s to re-read the rules.",ACMD_FORCERULES, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
		SendAdminMessage(ACMD_FORCERULES,string);
		cmd_rules(targetid, params);
	}

	return 1;
}


CMD:getip(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GETIP) || IsTrialAdmin(playerid))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /getip [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		new string[128], ip[56];
		GetPlayerIp(targetid, ip, sizeof(ip));
		format(string, sizeof(string), "[AdmCMD]: Player %s's(%d) IP is %s", PlayerName(targetid), targetid, ip);
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
	}
	return 1;
}

CMD:ss(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SS))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /ss [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(FoCo_Player[targetid][admin] >= FoCo_Player[playerid][admin] && FoCo_Player[playerid][id] != 368 && playerid != targetid)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command on other admins with the same or higher admin level as yourself. Naughty!");
		    return 1;
		}
		new string[128], Float:health;
		GetPlayerHealth(targetid, health);
		format(string, sizeof(string), "[AdmCMD]: You performed a health slap on %s", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		SetPlayerHealth(targetid, health-25);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has silently performed a health slap on %s",ACMD_SS, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_SS,string);
	}
	return 1;
}

CMD:ssah(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SS))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /ssah [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(FoCo_Player[targetid][admin] >= FoCo_Player[playerid][admin] && FoCo_Player[playerid][id] != 368 && playerid != targetid)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command on other admins with the same or higher admin level as yourself. Naughty!");
		    return 1;
		}
		new string[128];
		format(string, sizeof(string), "[AdmCMD]: You performed a health/armour slap on %s", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		AddPlayerHealth(targetid, -25.0);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has silently performed a health/armour slap on %s",ACMD_SS, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_SS,string);
	}
	return 1;
}

CMD:slap(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SLAP))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /slap [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(FoCo_Player[targetid][admin] >= FoCo_Player[playerid][admin] && FoCo_Player[playerid][id] != 368 && playerid != targetid)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command on other admins with the same or higher admin level as yourself. Naughty!");
		    return 1;
		}
		new string[128],Float:px, Float:py, Float:pz;
		format(string, sizeof(string), "[AdmCMD]: %s %s has slapped you.", GetPlayerStatus(playerid), PlayerName(playerid));
		SendClientMessage(targetid, COLOR_NOTICE, string);
		format(string, sizeof(string), "[AdmCMD]: You slapped %s", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has slapped %s",ACMD_SLAP, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		GetPlayerPos(targetid, px, py, pz);
		SetPlayerPos(targetid, px, py, pz+5);
	}
	return 1;
}

CMD:superslap(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SUPERSLAP))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /slap [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(FoCo_Player[targetid][admin] >= FoCo_Player[playerid][admin] && FoCo_Player[playerid][id] != 368 && playerid != targetid)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command on other admins with the same or higher admin level as yourself. Naughty!");
		    return 1;
		}
		new string[128], Float:px, Float:py, Float:pz;

		format(string, sizeof(string), "[AdmCMD]: %s %s has super slapped you.", GetPlayerStatus(playerid), PlayerName(playerid));
		SendClientMessage(targetid, COLOR_NOTICE, string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has super slapped %s",ACMD_SUPERSLAP, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_SUPERSLAP,string);
		GetPlayerPos(targetid, px, py, pz);
		SetPlayerPos(targetid, px, py, pz+20);
	}
	return 1;
}

CMD:noname(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_NONAME))
	{
		new string[200], targetid;
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /noname [ID]");
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid ID");
		}
		if(noname[targetid] == 0)
		{
			foreach(Player, i)
			{
				ShowPlayerNameTagForPlayer(i, targetid, false);
			}
			noname[targetid] = 1;
			format(string, sizeof(string), "[INFO]: %s %s(%d) has hidden your nametag from other players.", GetPlayerStatus(playerid), PlayerName(playerid), playerid);
			SendClientMessage(targetid, COLOR_SYNTAX, string);
			format(string, sizeof(string), "[AdmCMD]: %s %s(%d) has hidden %s's(%d) nametag from other players. Revert this once it is needed!", GetPlayerStatus(playerid), PlayerName(playerid), playerid, PlayerName(targetid), targetid);
			SendAdminMessage(ACMD_NONAME, string);
			return 1;
		}
		else
		{
			foreach(Player, i)
			{
				ShowPlayerNameTagForPlayer(i, targetid, true);
			}
			noname[targetid] = 0;
			format(string, sizeof(string), "[INFO]: %s %s(%d) has made your nametag visable to other players.");
			SendClientMessage(targetid, COLOR_SYNTAX, string);
			format(string, sizeof(string), "[AdmCMD]: %s %s(%d) has made %s's(%d) nametag visable.", GetPlayerStatus(playerid), PlayerName(playerid), playerid, PlayerName(targetid), targetid);
			SendAdminMessage(ACMD_NONAME, string);
			return 1;
		}
	}
	return 1;
}

/*
CMD:mute(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_MUTE))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /mute [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		new string[128];
		format(string, sizeof(string), "[AdmCMD]: %s %s has muted you.", GetPlayerStatus(playerid), PlayerName(playerid));
		SendClientMessage(targetid, COLOR_NOTICE, string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has muted %s", ACMD_MUTE,GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_MUTE,string);
		format(string, sizeof(string), "[INFO]: %s was muted", PlayerName(targetid));
		SendClientMessageToAll(COLOR_RED, string);
		format(string, sizeof(string), "MUTE: %s (%d) muted %s (%d)", PlayerName(playerid), playerid, PlayerName(targetid), targetid);
		AdminLog(string);
		Muted[targetid] = 1;
		MutedBy[targetid] = playerid;
		MuteTime[targetid] = gettime();
		MutedByAdmin[targetid] = 1;
	}
	return 1;
}

CMD:unmute(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_UNMUTE))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /unmute [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		new string[128];
		format(string, sizeof(string), "[AdmCMD]: %s %s has unmuted you.", GetPlayerStatus(playerid), PlayerName(playerid));
		SendClientMessage(targetid, COLOR_NOTICE, string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has unmuted %s", ACMD_UNMUTE,GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_UNMUTE,string);
		format(string, sizeof(string), "[INFO]: %s was unmuted", PlayerName(targetid));
		SendClientMessageToAll(COLOR_RED, string);
		Muted[targetid] = 0;
		spam[targetid] = 0;
		MutedTime[targetid] = 0;
		MutedByAdmin[targetid] = 0;
	}
	return 1;
}
*/

CMD:spec(playerid, params[])
{
	return cmd_spectate(playerid, params);
}

CMD:awp(playerid, params[])
{
	return cmd_spectate(playerid, params);
}

CMD:spectate(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SPECTATE) || IsTrialAdmin(playerid) && AdminsOnline() == 0)
	{
		new targetid, string[256], his_world, his_int;
		if (sscanf(params, "u", targetid))
		{
			if(Spectating[playerid] != -1)
			{
				TogglePlayerSpectating(playerid, 0);
				format(string, sizeof(string), "You have stopped spectating %s", PlayerName(Spectating[playerid]));
				SendClientMessage(playerid, COLOR_CMDNOTICE, string);
				Spectated[Spectating[playerid]] = -1;
				Spectating[playerid] = -1;
				GiveGuns(playerid);
				return 1;
			}
			else
			{
				TogglePlayerSpectating(playerid, 0);
				SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /spectate [ID/Name]");
				return 1;
			}
		}
		if(targetid == INVALID_PLAYER_ID && targetid != playerid)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(targetid == playerid)
		{
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot spectate yourself!");
		}
		if(GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  That player is currently spectating.");
			return 1;
		}
		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) // Missing these lines will cause the Spectate Bug !??
		{
			if(Spectating[playerid] != -1)
			{
				Spectated[Spectating[playerid]] = -1;
				Spectating[playerid] = -1;
			}
		}
		his_world = GetPlayerVirtualWorld(targetid);
		his_int = GetPlayerInterior(targetid);
		format(string, sizeof(string), "[AdmCMD]: You are now spectating %s. Use /spectate to stop spectating.", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		new Float:Health,Float:Armour;
		GetPlayerHealth(playerid, Health);
		GetPlayerArmour(playerid, Armour);
		new Armour_int = floatround(Armour, floatround_ceil);
		new Health_int = floatround(Health, floatround_ceil);
		specHP[playerid] = Health_int;
		specArmour[playerid] = Armour_int;
		SetPlayerVirtualWorld(playerid, his_world);
		SetPlayerInterior(playerid, his_int);
		TogglePlayerSpectating(playerid, 1);
		//SetPlayerHealth(playerid, 99);
		//SetPlayerArmour(playerid, 0);
		if(FoCo_Player[targetid][admin] >= 5)
		{
		    format(string, sizeof(string), "[AdmCMD]: %s is now spectating you",PlayerName(playerid));
		    SendClientMessage(targetid, COLOR_CMDNOTICE, string);
		}
		if(IsPlayerInAnyVehicle(targetid))
		{
			PlayerSpectateVehicle(playerid, GetPlayerVehicleID(targetid));
		}
		else
		{
			PlayerSpectatePlayer(playerid, targetid);
		}
		Spectated[targetid] = playerid;
		Spectating[playerid] = targetid;
	}
	return 1;
}

CMD:ann(playerid, params[])
{
	return cmd_announce(playerid, params);
}

CMD:announce(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_ANNOUNCE))
	{
		new message[256];
		if (sscanf(params, "s[256]", message))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /ann[ounce] [Message]");
			return 1;
		}
		new string[256], val[128];
		format(string, sizeof(string), "[Announcement]: %s",message);
		SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
		AdminLog(val);
		format(val, sizeof(val), "AdmCmd(%d): %s %s made an announcement", ACMD_ANNOUNCE,GetPlayerStatus(playerid), PlayerName(playerid));
		SendAdminMessage(ACMD_ANNOUNCE,val);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, val);
		AdminLog(val);
	}
	return 1;
}

CMD:up(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_UP))
	{
		new Float:px, Float:py, Float:pz, amount;
		if (sscanf(params, "i", amount))
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
				GetPlayerPos(playerid, px, py, pz);
				SetVehiclePos(GetPlayerVehicleID(playerid), px, py, pz+4);
				return 1;
			}
			GetPlayerPos(playerid, px, py, pz);
			SetPlayerPos(playerid, px, py, pz+4);
			return 1;
		}
		if(IsPlayerInAnyVehicle(playerid))
		{
			GetPlayerPos(playerid, px, py, pz);
			SetVehiclePos(GetPlayerVehicleID(playerid), px, py, pz+amount);
			return 1;
		}
		GetPlayerPos(playerid, px, py, pz);
		SetPlayerPos(playerid, px, py, pz+amount);
	}
	return 1;
}

CMD:down(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_DOWN))
	{
		new Float:px, Float:py, Float:pz, amount;
		if (sscanf(params, "i", amount))
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
				GetPlayerPos(playerid, px, py, pz);
				SetVehiclePos(GetPlayerVehicleID(playerid), px, py, pz-4);
				return 1;
			}
			GetPlayerPos(playerid, px, py, pz);
			SetPlayerPos(playerid, px, py, pz-4);
			return 1;
		}
		if(IsPlayerInAnyVehicle(playerid))
		{
			GetPlayerPos(playerid, px, py, pz);
			SetVehiclePos(GetPlayerVehicleID(playerid), px, py, pz-amount);
			return 1;
		}
		GetPlayerPos(playerid, px, py, pz);
		SetPlayerPos(playerid, px, py, pz-amount);
	}
	return 1;
}

CMD:srw(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SRW))
	{
		new targetid;
		if (sscanf(params, "uf", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /srw [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		new string[128];
		format(string, sizeof(string), "[AdmCMD]: You removed all of %s's weapons.", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		ResetPlayerWeapons(targetid);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has silently removed %s weapons",ACMD_SRW, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_SRW,string);
	}
	return 1;
}

/*
CMD:reports(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_REPORTS))
	{
		new string[512], reportAmount;
		foreach(Player,i)
		{
			if(IsPlayerConnected(i))
			{
				if(reportID[i] != -1)
				{
					if(strlen(string) == 0)
					{
						format(string, sizeof(string), "%d -- Reporter: %s -- Reported: %s.", i, PlayerName(i), PlayerName(reportID[i]));
					}
					else
					{
						format(string, sizeof(string), "%s\n%d -- Reporter: %s -- Reported: %s.", string, i, PlayerName(i), PlayerName(reportID[i]));
					}

					if(reportAmount >= 15)
					{
						format(string, sizeof(string), "%s\n Only the latest 15 reports can be displayed", string);
					}
					reportAmount++;
				}
			}
		}
		ShowPlayerDialog(playerid, DIALOG_REPORT_VIEW, DIALOG_STYLE_LIST, "Report System", string, "View", "Close");
		SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: If the report box does not display, it's because there are no reports to handle");
	}
	return 1;
}

CMD:ar(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_AR))
	{
		new report_id, string[128];
		if (sscanf(params, "u", report_id))
		{
			format(string, sizeof(string), "[USAGE]: {%06x}/ar {%06x}[report_id]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			return 1;
		}

		if(report_id == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: : No such user");
			return 1;
		}

		if(reportID[report_id] == -1)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: : That user has not submitted a support request or another admin just accepted it.");
			return 1;
		}
		reportID[report_id] = -1;
		FoCo_Player[playerid][reports]++;
		format(string, sizeof(string), "[REPORT NOTICE]: %s %s has accepted report %d", GetPlayerStatus(playerid), PlayerName(playerid), report_id);
		SendAdminMessage(ACMD_AR,string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);

		format(string, sizeof(string), "[REPORT INFORMATION]: %s %s is now looking into your report, please be patient.", GetPlayerStatus(playerid),PlayerName(playerid));
		SendClientMessage(report_id, COLOR_SYNTAX, string);
	}
	return 1;
}

CMD:dr(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_DR))
	{
		new report_id, string[128];
		if (sscanf(params, "u", report_id))
		{
			format(string, sizeof(string), "[USAGE]: {%06x}/dr {%06x}[report_id]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			return 1;
		}

		if(report_id == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Report no longer valid.");
			return 1;
		}

		if(reportID[report_id] == -1)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  That user has not submitted a support request or another admin just accepted it.");
			return 1;
		}
		reportID[report_id] = -1;
		format(string, sizeof(string), "[REPORT NOTICE]: %s %s has deleted report %d", GetPlayerStatus(playerid), PlayerName(playerid), report_id);
		SendAdminMessage(1,string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
	}
	return 1;
}
*/

CMD:setclanhealth(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETCLANHEALTH))
	{
		new targetid, val;
		if (sscanf(params, "ii", targetid, val))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setclanhealth [clanID] [amount]");
			return 1;
		}

		foreach(Player, i)
		{
			if(FoCo_Player[i][clan] == targetid)
			{
				SetPlayerHealth(i, val);
			}
		}

		new string[255];
		format(string, sizeof(string), "AdmCmd(%d): %s %s has set clan %d's health to %d.",ACMD_SETCLANHEALTH, GetPlayerStatus(playerid), PlayerName(playerid), targetid, val);
		SendAdminMessage(ACMD_SETCLANHEALTH,string);
	}
	return 1;
}

CMD:setclanarmour(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETCLANARMOUR))
	{
		new targetid, val;
		if (sscanf(params, "ii", targetid, val))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setclanarmour [clanID] [amount]");
			return 1;
		}

		foreach(Player, i)
		{
			if(FoCo_Player[i][clan] == targetid)
			{
				SetPlayerArmour(i, val);
			}
		}

		new string[255];
		format(string, sizeof(string), "AdmCmd(%d): %s %s has set clan %d's armour to %d.",ACMD_SETCLANARMOUR, GetPlayerStatus(playerid), PlayerName(playerid), targetid, val);
		SendAdminMessage(ACMD_SETCLANARMOUR,string);
	}
	return 1;
}

CMD:removeclanweapons(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_REMOVECLANWEAPONS))
	{
		new targetid;
		if (sscanf(params, "i", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /removeclanweapons [clanID]");
			return 1;
		}

		foreach(Player, i)
		{
			if(FoCo_Player[i][clan] == targetid)
			{
				ResetPlayerWeapons(i);
			}
		}

		new string[255];
		format(string, sizeof(string), "AdmCmd(%d): %s %s has reset clan %d's weapons.",ACMD_REMOVECLANWEAPONS, GetPlayerStatus(playerid), PlayerName(playerid), targetid);
		SendAdminMessage(ACMD_REMOVECLANWEAPONS,string);
	}
	return 1;
}

CMD:giveclanweapons(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GIVECLANWEAPONS))
	{
		new targetid, val, val2;
		if (sscanf(params, "iii", targetid, val, val2))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /giveclanweapons [clanID] [Weapon] [Ammo]");
			return 1;
		}

		if(val > 38 || val < 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Not higher than 38 or less than 0 por-fav-or!!!!!!");
			return 1;
		}

		foreach(Player, i)
		{
			if(FoCo_Player[i][clan] == targetid)
			{
				GivePlayerWeapon(i, val, val2);
			}
		}

		new string[255];
		format(string, sizeof(string), "AdmCmd(%d): %s %s has given clan %d's weapon ID: %d with %d ammo.",ACMD_GIVECLANWEAPONS, GetPlayerStatus(playerid), PlayerName(playerid), targetid, val, val2);
		SendAdminMessage(ACMD_GIVECLANWEAPONS,string);
	}
	return 1;
}

CMD:getclan(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GETCLAN))
	{
		new targetid;
		if (sscanf(params, "i", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /getclan [clanID]");
			return 1;
		}

		new Float:clan_pos_x, Float:clan_pos_y, Float:clan_pos_z;
		GetPlayerPos(playerid, clan_pos_x, clan_pos_y, clan_pos_z);

		foreach(Player, i)
		{
			if(FoCo_Player[i][clan] == targetid)
			{
				SetPlayerPos(i, clan_pos_x, clan_pos_y, clan_pos_z);
				SetPlayerInterior(i, GetPlayerInterior(playerid));
				SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(playerid));
				SendClientMessage(i, COLOR_NOTICE, "---> Telported by a level 3/+ admin to his location");
			}
		}

		new string[255];
		format(string, sizeof(string), "AdmCmd(%d): %s %s has teleported clan %d to his position.",ACMD_GETCLAN, GetPlayerStatus(playerid), PlayerName(playerid), targetid);
		SendAdminMessage(ACMD_GETCLAN,string);
	}
	return 1;
}

/*CMD:countdown(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_COUNTDOWN))
	{
	    if(countdown > 0)
	    {
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Countdown already in progress");
			return 1;
	    }
	    else
	    {
     		new amount;
     		new string[2];
		    if(sscanf(params, "i", amount))
		    {
		    	SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /countdown [seconds]");
				return 1;
		    }
		    if(amount < 0 || amount > 60)
		    {
		        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Amount of seconds cannot be less than 0 or more than 60");
		        return 1;
		    }
			countdown = amount;
			CountDownTimer = repeat CountdownTimer();
			format(string, sizeof(string), "%d", amount);
			GameTextForAll(string, 400, 3);
	    }
	}
	return 1;
}*/

CMD:repair(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_REPAIR))
	{
		if(IsPlayerInAnyVehicle(playerid) == 0)
		{
			SendClientMessage(playerid, COLOR_WARNING,  "[ERROR]:  You need to be in a vehicle to use this command.");
			return 1;
		}
		if(FoCo_Player[playerid][admin] == 1)
		{
			new string[255];
			format(string, sizeof(string), "AdmCmd(%d): %s %s has repaired their current vehicle.",ACMD_REPAIR, GetPlayerStatus(playerid), PlayerName(playerid));
			SendAdminMessage(ACMD_REPAIR,string);
		}
		RepairVehicle(GetPlayerVehicleID(playerid));
		SendClientMessage(playerid, COLOR_CMDNOTICE, "[AdmCMD]: Your current vehicle has been repaired.");
	}
	return 1;
}

CMD:check(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_CHECK) || IsTrialAdmin(playerid))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /check [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(aUndercover[targetid] == 1)
		{
			return underCover(playerid,targetid, 0);
		}
		new string[128];
		format(string, sizeof(string), "|-------------------------------- {%06x}%s(%d){%06x} --------------------------------|", COLOR_WARNING >>> 8, PlayerName(targetid), targetid, COLOR_CMDNOTICE >>> 8);
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		format(string, sizeof(string), "DB-ID: %d - Status: %s - Level: %d - Rank: %s  - VIP Rank: %s", FoCo_Player[targetid][id], GetPlayerStatus(targetid), FoCo_Player[targetid][level], PlayerRankNames[FoCo_Player[targetid][level]], DonationType(targetid));
		SendClientMessage(playerid, COLOR_NOTICE, string);
		format(string, sizeof(string), "Money: $%d - Car DB-ID: %d Car IG-ID: %d - Score: %d - Kills: %d - Deaths: %d - KDR: %02f", GetPlayerMoney(targetid), FoCo_Player[targetid][users_carid], GetPVarInt(playerid, "VehSpawn"), FoCo_Player[targetid][score], FoCo_Playerstats[targetid][kills], FoCo_Playerstats[targetid][deaths], floatdiv(FoCo_Playerstats[targetid][kills], FoCo_Playerstats[targetid][deaths]));
		SendClientMessage(playerid, COLOR_NOTICE, string);
		format(string, sizeof(string), "Suicides: %d - Longest Streak: %d - Current Streak: %d", FoCo_Playerstats[targetid][suicides], FoCo_Playerstats[targetid][streaks], CurrentKillStreak[targetid]);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		format(string, sizeof(string), "Duels Won: %d - Duels Lost: %d - Total Duels: %d", FoCo_Player[targetid][duels_won], FoCo_Player[targetid][duels_lost], (FoCo_Player[targetid][duels_won]+FoCo_Player[targetid][duels_lost]));
		SendClientMessage(playerid, COLOR_NOTICE, string);
		format(string, sizeof(string), "Jailtime: %d - Skin: %d - Warnings: %d ", FoCo_Player[targetid][jailed], GetPlayerSkin(targetid), FoCo_Player[targetid][warns]);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		format(string, sizeof(string), "%s", TimerOnline(FoCo_Player[targetid][onlinetime], 0));
		SendClientMessage(playerid, COLOR_NOTICE, string);
		if(FoCo_Player[targetid][admin] != 0)
		{
			format(string, sizeof(string), "%s", TimerOnline(FoCo_Player[targetid][admintime], 1));
			SendClientMessage(playerid, COLOR_NOTICE, string);
			format(string, sizeof(string), "Admin Stats: Reports: %d - Kicks: %d - Warnings: %d - Jails: %d - Bans: %d", FoCo_Player[targetid][reports], FoCo_Player[targetid][admin_kicks], FoCo_Player[targetid][admin_warns], FoCo_Player[targetid][admin_jails], FoCo_Player[targetid][admin_bans]);
			SendClientMessage(playerid, COLOR_NOTICE, string);
		}
		format(string, sizeof(string), " ", COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		format(string, sizeof(string), "Helicopter: %d - Deagle: %d - M4: %d - MP5: %d - Knife: %d", FoCo_Playerstats[targetid][heli], FoCo_Playerstats[targetid][deagle], FoCo_Playerstats[targetid][m4], FoCo_Playerstats[targetid][mp5], FoCo_Playerstats[targetid][knife]);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		format(string, sizeof(string), "Flamethrower: %d - Chainsaw: %d - Colt: %d", FoCo_Playerstats[targetid][flamethrower], FoCo_Playerstats[targetid][chainsaw], FoCo_Playerstats[targetid][colt]);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		format(string, sizeof(string), "Uzi: %d - Combat Shotgun: %d - AK47: %d - Tec9: %d - Sniper: %d - Carepackages captured: %d", FoCo_Playerstats[targetid][uzi], FoCo_Playerstats[targetid][combatshotgun], FoCo_Playerstats[targetid][ak47], FoCo_Playerstats[targetid][tec9], FoCo_Playerstats[targetid][sniper], FoCo_Playerstats[targetid][cpgs_captured]);
		SendClientMessage(playerid, COLOR_NOTICE, string);
	}
	return 1;
}

CMD:bounty(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_BOUNTY))
	{
		new targetid, string[256];
		if (sscanf(params, "u", targetid))
		{
			format(string, sizeof(string), "[USAGE]: {%06x}/bounty{%06x} [ID]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			return 1;
		}

		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "INVALID_PLAYER_ID");
			return 1;
		}
		format(string, sizeof(string), "[INFO]: %s %s has placed a bounty on %s(%d) - Kill them for extra rewards!", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
		SendClientMessageToAll(COLOR_GREEN, string);
		SetPVarInt(targetid, "BOUNTY", 1);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has put a bounty on %s(%d)", ACMD_BOUNTY,GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
		SendAdminMessage(ACMD_BOUNTY,string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	}
	return 1;
}

CMD:tod(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_TOD))
	{
		new time;
		if (sscanf(params, "i", time))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /tod [TIME]");
			return 1;
		}
		if(time < 0 || time > 24)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid time, must be between 0 and 24.");
			return 1;
		}
		new string[128];
		SetWorldTime(time);
		format(string, sizeof(string), "AdmCmd(%d): %s %s changed the time of day to: %d",ACMD_TOD, GetPlayerStatus(playerid), PlayerName(playerid), time);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_TOD,string);
	}
	return 1;
}

CMD:weather(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_WEATHER))
	{
		new weather;
		if (sscanf(params, "i", weather))
		{
			new string[512];
			format(string, sizeof(string), "0) Extra Sunny(LA)\n1) Sunny(LA)\n2)Extra Sunny Smog(LA)\n3) Sunny Smog(LA)\n4) Cloudy(LA)\n5) Sunny(SF)\n6) Extra Sunny(SF)\n7) Cloudy(SF)\n8) Rainy(SF)\n9) Foggy(SF)\n10) Sunny(LV)\n11) Extra Sunny - heat waves(LV)\n12) Cloudy(LV)\n13) Extra Sunny Countryside\n14) Sunny Countryside\n15) Cloudy Countryside\n16) Rainy Countryside\n17) Extra Sunny Desert\n18) Sunny Desert\n19) Sandstorm Desert\n20) Underwater (Greenish, foggy)");
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /weather [ID]");
			ShowPlayerDialog(playerid, DIALOG_WEATHER, DIALOG_STYLE_LIST, "Weather Overview", string, "Select", "Close");
			return 1;
		}
		if(weather < 0 || weather > 20)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid weather ID, must be between 0 and 20.");
			return 1;
		}
		new string[128];
		SetWeather(weather);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has changed weather to %d",ACMD_WEATHER, GetPlayerStatus(playerid), PlayerName(playerid), weather);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_WEATHER,string);
	}
	return 1;
}

CMD:jetpack(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_JETPACK))
	{
		if(ADuty[playerid] == 0 && FoCo_Player[playerid][admin] < 4)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  You can not use this unless you are on admin duty.");
			return 1;
		}
		new string[128];
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has spawned a jetpack",ACMD_JETPACK, GetPlayerStatus(playerid), PlayerName(playerid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_JETPACK,string);
	}
	return 1;
}

CMD:clearchat(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_CLEARCHAT))
	{
		for(new i = 0; i < 200; i++)
		{
			SendClientMessageToAll(COLOR_CMDNOTICE, " ");
		}
		new string[128];
		format(string, sizeof(string), "AdmCmd(%d): %s %s has cleared the chat", ACMD_CLEARCHAT, GetPlayerStatus(playerid), PlayerName(playerid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_CLEARCHAT,string);
	}
	return 1;
}

CMD:akill(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_AKILL))
	{
		new targetid, reason[128];
		if (sscanf(params, "uS(No reason)[128]", targetid, reason))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /akill [ID/Name] [Optional: Reason]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(FoCo_Player[targetid][admin] >= FoCo_Player[playerid][admin] && FoCo_Player[playerid][id] != 368 && playerid != targetid)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command on other admins with the same or higher admin level as yourself. Naughty!");
		    return 1;
		}
		new string[128];
		if(strlen(reason) > 0)
		{
			format(string, sizeof(string), "[AdmCMD]: %s %s has killed you for %s.",GetPlayerStatus(playerid), PlayerName(playerid), reason);
		}
		else format(string, sizeof(string), "[AdmCMD]: %s %s has killed you.", GetPlayerStatus(playerid), PlayerName(playerid));
		SendClientMessage(targetid, COLOR_NOTICE, string);
		if(strlen(reason) > 0)
		{
			format(string, sizeof(string), "[AdmCMD]: You killed %s for %s.", PlayerName(targetid), reason);
		}
		else format(string, sizeof(string), "[AdmCMD]: You killed %s", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		SetPlayerHealth(targetid, 0.0);
		SetPVarInt(targetid, "AtEvent", 0);
		SetPVarInt(targetid, "PlayerStatus",0);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has admin killed %s",ACMD_AKILL, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_AKILL,string);
	}
	return 1;
}

CMD:despawnallcars(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_DESPAWNALLCARS))
	{
		new string[128];
		format(string, sizeof(string), "[NOTICE]: %s %s has respawned all unocupied vehicles!", GetPlayerStatus(playerid), PlayerName(playerid));
		SendClientMessageToAll(COLOR_NOTICE, string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has set all unocupied vehicles to respawn!",ACMD_DESPAWNALLCARS, GetPlayerStatus(playerid), PlayerName(playerid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_DESPAWNALLCARS,string);

		new bool:dontrespawn[MAX_VEHICLES];
		foreach(Player, i)
	    {
	       	if(IsPlayerInAnyVehicle(i))
			{
				dontrespawn[GetPlayerVehicleID(i)]=true;
			}
	    }
		for(new i = 0; i < MAX_VEHICLES; i++)
		{
			if(!dontrespawn[i])
			{
				SetVehicleToRespawn(i);
				SetVehiclePos(i, FoCo_Vehicles[i][cx], FoCo_Vehicles[i][cy], FoCo_Vehicles[i][cz]);
				SetVehicleZAngle(i, FoCo_Vehicles[i][cangle]);
				LinkVehicleToInterior(i, FoCo_Vehicles[i][cint]);
				SetVehicleVirtualWorld(i, FoCo_Vehicles[i][cvw]);
			}
		}
	}
	return 1;
}

CMD:getcar(playerid, params[])
{
	if(IsAdmin(playerid,ACMD_GETCAR))
	{
		new targetid;
		if (sscanf(params, "i", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /getcar [Veh ID]");
			return 1;
		}
		new string[128], Float:px, Float:py, Float:pz;
		new world;
		world = GetPlayerVirtualWorld(playerid);
		GetPlayerPos(playerid, px, py, pz);
		SetVehiclePos(targetid, px+5, py, pz+2);
		SetVehicleVirtualWorld(targetid, world);
		format(string, sizeof(string), "You teleported vehicle ID %d to you.", targetid);
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
	}
	return 1;
}

CMD:sethp(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETHP))
	{
		new targetid, Float:health;
		if (sscanf(params, "uf", targetid, health))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /sethp [ID/Name] [Amount]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
	    if(FoCo_Player[targetid][admin] >= FoCo_Player[playerid][admin] && FoCo_Player[playerid][id] != 368 && playerid != targetid)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command on other admins with the same or higher admin level as yourself. Naughty!");
		    return 1;
		}
		new string[128];
		format(string, sizeof(string), "[AdmCMD]: %s %s has set your health to %i.", GetPlayerStatus(playerid), PlayerName(playerid), floatround(health, floatround_round));
		SendClientMessage(targetid, COLOR_NOTICE, string);
		format(string, sizeof(string), "[AdmCMD]: You set %s's health to %i", PlayerName(targetid), floatround(health, floatround_round));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		SetPlayerHealth(targetid, health);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's health to %d.",ACMD_SETHP, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), floatround(health, floatround_round));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_SETHP,string);
	}
	return 1;
}

CMD:setarmour(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETARMOUR))
	{
		new targetid, Float:armour;
		if (sscanf(params, "uf", targetid, armour))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setarmour [ID/Name] [Amount]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(armour > 100)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid amount, must be below or equal to 100.");
			return 1;
		}
		new string[128];
		format(string, sizeof(string), "[AdmCMD]: %s %s has set your armour to %i.", GetPlayerStatus(playerid), PlayerName(playerid), floatround(armour, floatround_round));
		SendClientMessage(targetid, COLOR_NOTICE, string);
		SetPlayerArmour(targetid, armour);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's armour to %i.",ACMD_SETARMOUR, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), floatround(armour, floatround_round));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_SETARMOUR,string);
	}
	return 1;
}

CMD:sslap(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SSLAP))
	{
		new targetid, reason[128];
		if (sscanf(params, "u", targetid, reason))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /sslap [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		new string[128],Float:px, Float:py, Float:pz;
		format(string, sizeof(string), "AdmCmd(%d): %s %s has silently slapped %s",ACMD_SSLAP, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_SSLAP,string);
		GetPlayerPos(targetid, px, py, pz);
		SetPlayerPos(targetid, px, py, pz+5);
	}
	return 1;
}

CMD:sfreeze(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SFREEZE))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /sfreeze [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		new string[128];
		if(Froze[targetid] == 0)
		{
			format(string, sizeof(string), "[AdmCMD]: You silently froze %s", PlayerName(targetid));
			SendClientMessage(playerid, COLOR_CMDNOTICE, string);
			format(string, sizeof(string), "AdmCmd(%d): %s %s has silently froze %s",ACMD_SFREEZE, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendAdminMessage(ACMD_SFREEZE,string);
		}
		TogglePlayerControllable(targetid, 0);
		Froze[targetid] = 1;
	}
	return 1;
}

CMD:sunfreeze(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SUNFREEZE))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /sunfreeze [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		new string[128];
		if(Froze[playerid] == 1)
		{
			format(string, sizeof(string), "[AdmCMD]: You silently unfroze %s", PlayerName(targetid));
			SendClientMessage(playerid, COLOR_CMDNOTICE, string);
			format(string, sizeof(string), "AdmCmd(%d): %s %s has silently unfroze %s",ACMD_SUNFREEZE, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendAdminMessage(ACMD_SUNFREEZE,string);
		}
		TogglePlayerControllable(targetid, 1);
		Froze[playerid] = 0;
	}
	return 1;
}

CMD:cnn(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_CNN))
	{
		new message[256];
		if (sscanf(params, "s[256]", message))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /cnn [Message]");
			return 1;
		}
		new string[256], val[128];
		format(string, sizeof(string), "~g~%s~w~ ~n~%s", PlayerName(playerid), message);
		GameTextForAll(string, 5000, 4);
		format(val, sizeof(val), "AdmCmd(%d): %s %s has announced in game text: %s",ACMD_CNN, GetPlayerStatus(playerid),PlayerName(playerid), message);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, val);
	}
	return 1;
}

CMD:pcnn(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_CNN))
	{
		new message[256],targetid;
		if (sscanf(params, "ds[256]", targetid, message))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /pcnn [ID] [Message]");
			return 1;
		}
		new string[256];
		format(string, sizeof(string), "~w~Private msg from ~r~%s~w~ ~n~----------------------~n~%s", PlayerName(playerid), message);
		GameTextForPlayer(targetid, string, 8000, 4);
		format(string, sizeof(string), "PCNN sent to %s(%d): %s", PlayerName(targetid), targetid, message);
		SendClientMessage(playerid, COLOR_WHITE, string);
		AdminLog(string);
	}
	return 1;
}

CMD:askydive(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_ASKYDIVE))
	{
		if(ADuty[playerid] == 0 && FoCo_Player[playerid][admin] < 5)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  You can not use this unless you are on admin duty.");
			return 1;
		}
		if(GetPlayerInterior(playerid) != 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  You're in an interior, you will need to exit before this action can be completed.");
			return 1;
		}
		GameTextForPlayer(playerid, "~g~Green ~w~Light", 2500, 6);
		new Float:px, Float: py, Float:pz;
		GetPlayerPos(playerid, px, py, pz);
		SetPlayerPos(playerid, px, py, pz+750);
		GivePlayerWeapon(playerid, 46, 1);
	}
	return 1;
}

CMD:antifall(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_ANTIFALL))
	{
		if(ADuty[playerid] == 0 && FoCo_Player[playerid][admin] < 5)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  You can not use this unless you are on admin duty.");
			return 1;
		}
		if(antifall[playerid] == 1)
		{
			antifall[playerid] = 0;
			antifallveh[playerid] = -1;
			SendClientMessage(playerid, COLOR_CMDNOTICE, "[AdmCMD]: Anti fall is now disabled.");
			return 1;
		}
		antifallveh[playerid] = GetPlayerVehicleID(playerid);
		antifall[playerid] = 1;
		antifallcheck[playerid] = 1;
		new string[128];
		format(string, sizeof(string), "AdmCmd(%d): %s %s has enabled anti fall.", ACMD_ANTIFALL,GetPlayerStatus(playerid), PlayerName(playerid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_ANTIFALL,string);
		SendClientMessage(playerid, COLOR_CMDNOTICE, "[AdmCMD]: Anti fall is now enabled.");
		if(IsPlayerInAnyVehicle(playerid) == 1)
		{
			antifallveh[playerid] = GetPlayerVehicleID(playerid);
		}
	}
	return 1;
}

CMD:ppk(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_PPK))
	{
		new targetid, string[128];
		if (sscanf(params, "u", targetid))
		{
			format(string, sizeof(string), "[USAGE]: {%06x}/ppk (park player car) {%06x}[ID/Name]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			return 1;
		}

		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  That user is not connected.");
			return 1;
		}
		if(GetVehicleModel(GetPVarInt(targetid, "VehSpawn")) == 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  This vehicle does not exsist.");
			return 1;
		}
		Delete3DTextLabel(vehicle3Dtext[targetid]);
		
		if(GetPVarInt(targetid, "VehSpawn") > 0)
		{
			DestroyVehicle(GetPVarInt(targetid, "VehSpawn"));
		}
		SetPVarInt(targetid, "VehSpawn", -1);
		SendClientMessage(playerid, COLOR_NOTICE, "You have parked that players vehicle.");
		SendClientMessage(targetid, COLOR_WARNING, "An admin has parked your car.");
	}
	return 1;
}

/* LEVEL THREE ADMIN COMMANDS */


CMD:gcs(playerid, params[])
{
	cmd_gotoclanspawn(playerid, params);
	return 1;
}
CMD:gotoclanspawn(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GOTOCLANSPAWN))
	{
		new targetid;
		if (sscanf(params, "i", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /gotoclanspawn [Clan ID]");
			return 1;
		}
		if(FoCo_Teams[targetid][team_type] == 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid clan ID.");
			return 1;
		}
		new string[128];
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			SetVehiclePos(GetPlayerVehicleID(playerid), FoCo_Teams[targetid][team_spawn_x], FoCo_Teams[targetid][team_spawn_y], FoCo_Teams[targetid][team_spawn_z]+3);
		}
		else
		{
			SetPlayerPos(playerid, FoCo_Teams[targetid][team_spawn_x], FoCo_Teams[targetid][team_spawn_y], FoCo_Teams[targetid][team_spawn_z]+3);
			format(string, sizeof(string), "You teleported to the spawn location of clan ID %d", targetid);
			SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		}
	}
	return 1;
}

CMD:flip(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_FLIP))
	{
		new VehicleID, Float:X, Float:Y, Float:Z, Float:A;
		if (sscanf(params, "i", VehicleID))
		{
			if(IsPlayerInAnyVehicle(playerid) == 0)
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /flip [Optional: ID]");
				SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: Use /flip to flip the vehicle you are in.");
				return 1;
			}
			GetPlayerPos(playerid, X, Y, Z);
			VehicleID = GetPlayerVehicleID(playerid);
			SetVehiclePos(VehicleID, X, Y, Z);
			GetVehicleZAngle(VehicleID, A);
			SetVehicleZAngle(VehicleID, A);
			SendClientMessage(playerid, COLOR_CMDNOTICE, "[ERROR]:  Vehicle flipped, remember you can use /flip [ID] to flip a different vehicle.");
			return 1;
		}
		if(GetVehicleModel(VehicleID) == 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  That vehicle does not exist.");
			return 1;
		}
		GetVehiclePos(VehicleID, X, Y, Z);

	 	SetVehiclePos(VehicleID, X, Y, Z);
	 	GetVehicleZAngle(VehicleID, A);
	 	SetVehicleZAngle(VehicleID, A);
		SendClientMessage(playerid, COLOR_CMDNOTICE, "[AdmCMD]: Vehicle flipped, remember you can use /flip on its own to flip the vehicle you're in.");
	}
	return 1;
}

CMD:carcolor(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_CARCOLOR))
	{
		new targetid, color1, color2;
		if (sscanf(params, "idd", targetid, color1, color2))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /carcolor [ID] [Color 1] [Color 2]");
			return 1;
		}
		if(GetVehicleModel(targetid) == 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  That vehicle does not exist.");
			return 1;
		}
		if(color1 > 255 || color2 > 255)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid color ID. Color ID must be below 255");
			return 1;
		}
		ChangeVehicleColor(targetid, color1, color2);
		new string[256];
		format(string, sizeof(string), "AdmCmd(%d): %s %s has set vehicle(%d) color to COL1:%d COL2:%d",ACMD_CARCOLOR, GetPlayerStatus(playerid), PlayerName(playerid), targetid, color1, color2);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_CARCOLOR,string);
		SendClientMessage(playerid, COLOR_CMDNOTICE, "You have successfully changed the vehicles colors.");
	}
	return 1;
}

CMD:shopsys(playerid, params[])
{
    if(IsAdmin(playerid, ACMD_SHOPSYS))
	{
		new string[128];
		if(ShopSys == 0)
		{
			ShopSys = 1;
			format(string, sizeof(string), "[AdmCMD]: %s %s has switched off the gunshop sys.", GetPlayerStatus(playerid), PlayerName(playerid));
			SendClientMessageToAll(COLOR_NOTICE, string);
			format(string, sizeof(string), "AdmCmd(%d): %s %s has switched off the gunshop sys.",ACMD_SHOPSYS ,GetPlayerStatus(playerid), PlayerName(playerid));
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendAdminMessage(ACMD_SHOPSYS,string);
		}
		else
		{
			ShopSys = 0;
			format(string, sizeof(string), "[AdmCMD]: %s %s has switched on the gunshop sys.", GetPlayerStatus(playerid), PlayerName(playerid));
			SendClientMessageToAll(COLOR_NOTICE, string);
			format(string, sizeof(string), "AdmCmd(%d): %s %s has switched on the gunshop sys.",ACMD_SHOPSYS, GetPlayerStatus(playerid), PlayerName(playerid));
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendAdminMessage(ACMD_SHOPSYS,string);
		}
	}
	return 1;
}

CMD:givegun(playerid, params[])
{
	return cmd_giveweapon(playerid, params);
}

CMD:giveweapon(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GIVEGUN))
	{
		new targetid, gun[56], ammo, gunid;
		if (sscanf(params, "us[56]i", targetid, gun, ammo))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /giveweapon [Player ID/Name] [Weapon ID/Name] [Ammo]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid Player ID/Name.");
			return 1;
		}
		if(GetWeaponModelIDFromName(gun) == -1)
		{
			gunid = strval(gun);
			if(gunid < 0 || gunid > 48)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid Weapon ID/Name.");
				return 1;
			}
			if(gunid == 19||gunid == 20||gunid == 21)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid Weapon ID/Name.");
				return 1;
			}
		}
		else gunid = GetWeaponModelIDFromName(gun) ;
		new string[128];
		format(string, sizeof(string), "[AdmCMD]: %s %s has given you a %s with %i ammo.", GetPlayerStatus(playerid), PlayerName(playerid), WeapNames[gunid], ammo);
		SendClientMessage(targetid, COLOR_NOTICE, string);
		format(string, sizeof(string), "[AdmCMD]: You gave %s an %s with %i ammo", PlayerName(targetid), WeapNames[gunid], ammo);
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		if(gunid == 16 || gunid == 35 || gunid == 36 || gunid == 37 || gunid == 38)
		{
			SetPVarInt(targetid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
		}
		GivePlayerWeapon(targetid, gunid, ammo);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has given %s a %s",ACMD_GIVEGUN, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), WeapNames[gunid]);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_GIVEGUN,string);
	}
	return 1;
}

CMD:setskin(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETSKIN))
	{
		new targetid, skinid;
		if (sscanf(params, "ui", targetid, skinid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setskin [ID/Name] [Skin ID]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(IsValidSkin(skinid))
		{
		    new string[128];
			format(string, sizeof(string), "[AdmCMD]: You have set %s's skin to %d, they will keep it until they log out.", PlayerName(targetid), skinid);
			SendClientMessage(playerid, COLOR_CMDNOTICE, string);
			format(string, sizeof(string), "[AdmCMD]: %s %s has set your skin to %i, you will keep it until you log out.", GetPlayerStatus(playerid), PlayerName(playerid), skinid);
			SendClientMessage(targetid, COLOR_NOTICE, string);
			format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's skin to %d, they will keep it until they log out.",ACMD_SETSKIN, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), skinid);
			SendAdminMessage(ACMD_SETSKIN,string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SetPlayerSkin(targetid, skinid);
			SetPVarInt(targetid, "TempSkin", skinid);
			//ClearAnimations(playerid);
			//DeleteAllAttachedWeapons(playerid);
			//OnUpdateWepObj(playerid);
			/*if(HaveCap(playerid))
			{
				RemovePlayerAttachedObject(playerid, pObject[playerid][oslot]);
			}*/
			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  The skin ID you specified is not valid.");
			return 1;
		}
	}
	return 1;
}

CMD:removeskin(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_REMOVESKIN))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /removeskin [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		new string[255];
		format(string, sizeof(string), "[AdmCMD]: You have removed %s's custom skin, they should spawn with their default skin.", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		format(string, sizeof(string), "[AdmCMD]: %s %s has removed your custom skin.", GetPlayerStatus(playerid), PlayerName(playerid));
		SendClientMessage(targetid, COLOR_NOTICE, string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has removed %s's custom skin.",ACMD_REMOVESKIN, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
		SendAdminMessage(ACMD_REMOVESKIN,string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SetPVarInt(targetid, "TempSkin", 0);
		new rank;

		if(FoCo_Player[targetid][clan] != -1 && FoCo_Team[targetid] == FoCo_Teams[FoCo_Player[targetid][clan]][db_id])
		{
			switch(FoCo_Player[targetid][clanrank])
		{
			case 1:
		{
			rank = FoCo_Teams[FoCo_Player[targetid][clan]][team_skin_1];
		}
			case 2:
		{
			rank = FoCo_Teams[FoCo_Player[targetid][clan]][team_skin_2];
		}
			case 3:
		{
			rank = FoCo_Teams[FoCo_Player[targetid][clan]][team_skin_3];
		}
			case 4:
		{
			rank = FoCo_Teams[FoCo_Player[targetid][clan]][team_skin_4];
		}
			case 5:
		{
			rank = FoCo_Teams[FoCo_Player[targetid][clan]][team_skin_5];
		}
		}
			SetPlayerSkin(targetid, rank);
		}
		else
		{
			SetPlayerSkin(targetid, FoCo_Teams[FoCo_Team[targetid]][team_skin_1]);
		}
	}
	return 1;
}


CMD:removelocalguns(playerid, params[])
{
	return cmd_removelocalweapons(playerid, params);
}

CMD:removelguns(playerid, params[])
{
	cmd_removelocalweapons(playerid, params);
	return 1;
}

CMD:removelocalweapons(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_REMOVELOCALWEAPONS))
	{
	    new Float:distance;
	    new string[128];
	    if(sscanf(params,"f",distance))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /removelocalweapons [distance]");
			return 1;
		}
		if(distance > MAX_RANGE || distance < MIN_RANGE)
		{
		    format(string, sizeof(string), "[ERROR]: Range must be over %dm and under %dm!", MIN_RANGE, MAX_RANGE);
		    SendClientMessage(playerid, COLOR_WARNING, string);
		}
		new Float: x, Float: y, Float: z;
		GetPlayerPos(playerid, x, y, z);
		
		format(string, sizeof(string), "AdmCmd(%d): %s %s has removed players that are within %fm weapons",ACMD_REMOVECLANWEAPONS, GetPlayerStatus(playerid), PlayerName(playerid), distance);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_REMOVECLANWEAPONS,string);
		foreach(Player, i)
		{
		    if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
		    {
      			if(IsPlayerInRangeOfPoint(i, distance, x, y, z))
				{
				ResetPlayerWeapons(i);
				}
		    }
		}
	}
	return 1;
}

CMD:givelocalgun(playerid, params[])
{
	return cmd_givelocalweapon(playerid, params);
}

CMD:givelgun(playerid, params[])
{
	cmd_givelocalweapon(playerid, params);
	return 1;
}

CMD:givelocalweapon(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GIVELOCALWEAPON))
	{
	    new string[250];
		new gun[56], ammo, gunid, area;
		if (sscanf(params, "s[56]ii", gun, ammo, area))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /givelocalweapon [Weapon ID/Name] [Ammo] [Area]");
			return 1;
		}
		if(area < MIN_RANGE || area > MAX_RANGE)
		{
		    format(string, sizeof(string), "[ERROR]: Range must be over %dm and under %dm!", MIN_RANGE, MAX_RANGE);
			SendClientMessage(playerid, COLOR_WARNING, string);
			return 1;
		}
		if(GetWeaponModelIDFromName(gun) == -1)
		{
			gunid = strval(gun);
			if(gunid < 0 || gunid > 48)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid Weapon ID/Name.");
				return 1;
			}
			if(gunid == 19||gunid == 20||gunid == 21)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid Weapon ID/Name.");
				return 1;
			}
		}
		else gunid = GetWeaponModelIDFromName(gun);
		new Float: x, Float: y, Float: z;
		GetPlayerPos(playerid, x, y, z);
		
		format(string, sizeof(string), "AdmCmd(%d): %s %s has given players that are within %dm a %s. (Ammo: %d)",ACMD_GIVELOCALWEAPON, GetPlayerStatus(playerid), PlayerName(playerid), area, WeapNames[gunid], ammo);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_GIVELOCALWEAPON,string);
		foreach(Player, i)
		{
		    if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
		    {
		        if(IsPlayerInRangeOfPoint(i, area, x, y, z))
				{
					if(gunid == 16 || gunid == 35 || gunid == 36 || gunid == 37 || gunid == 38)
					{
						SetPVarInt(i, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
					}
					GivePlayerWeapon(i, gunid, ammo);
				}
		    }
		}
	}
	return 1;
}

CMD:setlocalhp(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETLOCALHP))
	{
		new health, area;
		new string[250];
		if (sscanf(params, "ii", health, area))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setlocalhp [Amount] [Area]");
			return 1;
		}
		if(health > 255 || health < 1 && AdminLvl(playerid) < 4)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid amount, must over 1 or below or equal to 255.");
			return 1;
		}
		if(area < MIN_RANGE|| area > MAX_RANGE)
		{
		    format(string, sizeof(string), "[ERROR]: Range must be over %dm and under %dm!", MIN_RANGE, MAX_RANGE);
		    SendClientMessage(playerid, COLOR_WARNING, string);
			return 1;
		}
		new Float: x, Float: y, Float: z;
		GetPlayerPos(playerid, x, y, z);
		
		format(string, sizeof(string), "AdmCmd(%d): %s %s has set the health of players that are within %dm to %d.",ACMD_SETLOCALHP, GetPlayerStatus(playerid), PlayerName(playerid), area, health);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_SETLOCALHP,string);
		foreach(Player, i)
		{
			if(IsPlayerInRangeOfPoint(i, area, x, y, z))
			{
				SetPlayerHealth(i, health);
			}
		}
	}
	return 1;
}

CMD:setlocalhealth(playerid, params[])
{
	cmd_setlocalhp(playerid, params);
	return 1;
}

CMD:setlhp(playerid, params[])
{
	cmd_setlocalhp(playerid, params);
	return 1;
}

CMD:setlarmour(playerid, params[])
{
	cmd_setlocalarmour(playerid, params);
	return 1;
}

CMD:setlocalarmour(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETLOCALARMOUR))
	{
		new armour, area;
		new string[250];
		if (sscanf(params, "ii", armour, area))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setlocalarmour [Amount] [Area]");
			return 1;
		}
		if(armour > 255 && AdminLvl(playerid) < 4)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid amount, must be below or equal to 255.");
			return 1;
		}
		if(area < MIN_RANGE || area > MAX_RANGE)
		{
		    format(string, sizeof(string), "[ERROR]: Range must be over %dm and under %dm!", MIN_RANGE, MAX_RANGE);
		    SendClientMessage(playerid, COLOR_WARNING, string);
			return 1;
		}
		new Float: x, Float: y, Float: z;
		format(string, sizeof(string), "AdmCmd(%d): %s %s has set the armour of players that are within %dm to %d.",ACMD_SETLOCALARMOUR, GetPlayerStatus(playerid), PlayerName(playerid), area, armour);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_SETLOCALARMOUR,string);
		GetPlayerPos(playerid, x, y, z);
		foreach(Player, i)
		{
			if(IsPlayerInRangeOfPoint(i, area, x, y, z))
			{
				SetPlayerArmour(i, armour);
			}
		}
	}
	return 1;
}

CMD:sethpall(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETHPALL))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new Float:health;
		if (sscanf(params, "f", health))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /sethpall [Amount]");
			return 1;
		}
		if(health > 100 || health < 1 && AdminLvl(playerid) != 5)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid amount, must be below or equal to 100.");
			return 1;
		}
		new string[128];
		format(string, sizeof(string), "[AdmCMD]: %s %s has set your health to %i.", GetPlayerStatus(playerid), PlayerName(playerid), floatround(health, floatround_round));
		SendClientMessageToAll(COLOR_NOTICE, string);
		format(string, sizeof(string), "[AdmCMD]: You set everyones health to %i", floatround(health, floatround_round));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has set everyones health to %i",ACMD_SETHPALL, GetPlayerStatus(playerid),PlayerName(playerid), floatround(health, floatround_round));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_SETHPALL,string);
		foreach(Player, i)
		{
			if(IsPlayerConnected(i))
			{
				SetPlayerHealth(i, health);
			}
		}
	}
	return 1;
}

CMD:freezelocal(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new freezerange, Float:P[3],str[128];
		if(sscanf(params, "d", freezerange)) return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /freezelocal [range]");
		if(freezerange < MIN_RANGE || freezerange > MAX_RANGE)
		{
		    format(str, sizeof(str), "[ERROR]: Range must over %dm and under %dm!", MIN_RANGE, MAX_RANGE);
		    SendClientMessage(playerid, COLOR_WARNING, str);
		    return 1;
		}
		GetPlayerPos(playerid, P[0], P[1], P[2]);
		format(str, sizeof(str), "AdmCmd(1): %s %s has frozen players that are within %dm", GetPlayerStatus(playerid), PlayerName(playerid), freezerange);
		SendAdminMessage(1, str);
		foreach(new i: Player)
		{
			if(IsPlayerInRangeOfPoint(i, freezerange, P[0], P[1], P[2]))
			{
				if(i != playerid) TogglePlayerControllable(i, 0);
			}
		}
	}
	return 1;
}

CMD:lfreeze(playerid, params[])
{
	cmd_freezelocal(playerid, params);
	return 1;
}

CMD:localfreeze(playerid, params[])
{
	cmd_freezelocal(playerid, params);
	return 1;
}

CMD:unfreezelocal(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new freezerange, Float:P[3],str[128];
		if(sscanf(params, "d", freezerange)) return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /unfreezelocal [range]");
		if(freezerange < MIN_RANGE || freezerange > MAX_RANGE)
		{
		    format(str, sizeof(str), "[ERROR]: Range must be over %dm and under %dm!", MIN_RANGE, MAX_RANGE);
		    SendClientMessage(playerid, COLOR_WARNING, str);
		    return 1;
		}
		GetPlayerPos(playerid, P[0], P[1], P[2]);
		format(str, sizeof(str), "AdmCmd(1): %s %s has unfrozen players that are within %dm", GetPlayerStatus(playerid), PlayerName(playerid), freezerange);
		SendAdminMessage(1, str);
		foreach(new i: Player)
		{
			if(IsPlayerInRangeOfPoint(i, freezerange, P[0], P[1], P[2])) TogglePlayerControllable(i, 1);
		}
	}
	return 1;
}

CMD:localunfreeze(playerid, params[])
{
	cmd_unfreezelocal(playerid, params);
	return 1;
}

CMD:lunfreeze(playerid, params[])
{
	cmd_unfreezelocal(playerid, params);
	return 1;
}

CMD:setarmourall(playerid, params[])
{
	if(IsAdmin(playerid,ACMD_SETARMOURALL))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new Float:armour;
		if (sscanf(params, "f", armour))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setarmour [Amount]");
			return 1;
		}
		if(armour > 100 && AdminLvl(playerid) != 5)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid amount, must be below or equal to 100.");
			return 1;
		}
		new string[128];
		format(string, sizeof(string), "[AdmCMD]: %s %s has set your armour to %i.", GetPlayerStatus(playerid), PlayerName(playerid), floatround(armour, floatround_round));
		SendClientMessageToAll(COLOR_NOTICE, string);
		format(string, sizeof(string), "[AdmCMD]: You set everyones armour to %i.", floatround(armour, floatround_round));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has set everyones armour to %i",ACMD_SETARMOURALL, GetPlayerStatus(playerid), PlayerName(playerid), floatround(armour, floatround_round));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_SETARMOURALL,string);
		foreach (Player, i)
		{
			if(IsPlayerConnected(i))
			{
				SetPlayerArmour(i, armour);
			}
		}
	}
	return 1;
}

CMD:giveallweapon(playerid, params[])
{
    if(IsAdmin(playerid, ACMD_GIVEALLWEAPON))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new string[128], wep, ammo;
		if (sscanf(params, "ii ", wep, ammo))
		{
			format(string, sizeof(string), "[USAGE]: {%06x}/giveallweapons {%06x} [weaponid] [ammo] ", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			return 1;
		}
		if(AdminLvl(playerid) < 5) {
			if(wep > 43 || wep < 1 || wep == 44 || wep == 45 && FoCo_Player[playerid][admin] < 5)
			{
				SendClientMessage(playerid, COLOR_WARNING, "Invalid ID");
				return 1;
			}
		}
		foreach(Player, i)
		{
			if(wep == 16 || wep == 35 || wep == 36 || wep == 37 || wep == 38)
			{
				SetPVarInt(i, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			}
			GivePlayerWeapon(i, wep, ammo);
		}
		format(string, sizeof(string), "AdmCmd(%d): %s %s has given everyone a %s with %d ammo",ACMD_GIVEALLWEAPON, GetPlayerStatus(playerid), PlayerName(playerid), WeapNames[wep], ammo);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_GIVEALLWEAPON,string);
	}
	return 1;
}

CMD:giveallgun(playerid, params[])
{
	cmd_giveallweapon(playerid, params);
	return 1;
}

CMD:givegunall(playerid, params[])
{
	cmd_giveallweapon(playerid, params);
	return 1;
}

CMD:rha(playerid, params[])
{
    if(IsAdmin(playerid, ACMD_RHA))
	{
	    new targetid, string[128];
		if (sscanf(params, "u", targetid))
		{
			SetPlayerHealth(playerid, 99.0);
			SetPlayerArmour(playerid, 99.0);
			format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's(%d) health and armour to 100", ACMD_RHA, GetPlayerStatus(playerid),PlayerName(playerid), PlayerName(playerid), playerid);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendAdminMessage(ACMD_RHA, string);
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /rha [ID]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid ID/Name.");
			return 1;
		}
		SetPlayerHealth(targetid, 99.0);
		SetPlayerArmour(targetid, 99.0);
		
		format(string, sizeof(string), "Your health and armour has been set to 100 by %s (%d).", PlayerName(playerid), playerid);
		SendClientMessage(targetid, COLOR_WHITE, string);
		format(string, sizeof(string), "You have set %s's(%d) health and armour to 100", PlayerName(targetid), targetid);
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has set %s's(%d) health and armour to 100", ACMD_RHA, GetPlayerStatus(playerid),PlayerName(playerid), PlayerName(targetid), targetid);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_RHA, string);
	}
	return 1;
}

CMD:localrha(playerid, params[])
{
    if(IsAdmin(playerid, ACMD_RHA))
	{
	    new range;
		if (sscanf(params, "i", range))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /rha [range]");
			return 1;
		}
		if(range > MAX_RANGE || range < MIN_RANGE)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Range must be over 1m and under 500m!");
			return 1;
		}
		new Float:x, Float:y, Float:z;
		new string[128];
		format(string, sizeof(string), "AdmCmd(%d): %s %s(%d) has given the players that are within %dm 100 armour and 100 HP.", ACMD_RHA, GetPlayerStatus(playerid), PlayerName(playerid),playerid, range);
		SendAdminMessage(ACMD_RHA, string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		GetPlayerPos(playerid, x, y, z);
		foreach(Player, i)
		{
		    if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
		    {
      			if(IsPlayerInRangeOfPoint(i, range, x, y, z))
				{
				    SetPlayerHealth(i, 99.0);
					SetPlayerArmour(i, 99.0);
					format(string, sizeof(string), "Your health and armour has been set to 100 by %s (%d).", PlayerName(playerid), playerid);
					SendClientMessage(i, COLOR_WHITE, string);
				}
		    }
		}
		return 1;
	}
	return 1;
}

CMD:lrha(playerid, params[])
{
	cmd_localrha(playerid, params);
	return  1;
}

CMD:explode(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_EXPLODE))
	{
		new targetid, reason[128];
		if (sscanf(params, "uS(No reason)[128]", targetid, reason))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /explode [ID/Name] [Optional: Reason]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "-- Invalid ID/Name.");
			return 1;
		}
		if(FoCo_Player[targetid][admin] >= FoCo_Player[playerid][admin] && FoCo_Player[playerid][id] != 368 && playerid != targetid)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command on other admins with the same or higher admin level as yourself. Naughty!");
		    return 1;
		}
		new string[128], Float:px, Float:py, Float:pz;
		if(strlen(reason) > 0)
		{
			format(string, sizeof(string), "[AdmCMD]: %s %s has exploded you for %s.",GetPlayerStatus(playerid), PlayerName(playerid), reason);
		}
		else format(string, sizeof(string), "[AdmCMD]: %s %s has exploded you.", GetPlayerStatus(playerid), PlayerName(playerid));
		SendClientMessage(targetid, COLOR_NOTICE, string);
		if(strlen(reason) > 0)
		{
			format(string, sizeof(string), "[AdmCMD]: You exploded %s for %s.", PlayerName(targetid), reason);
		}
		else format(string, sizeof(string), "[AdmCMD]: You exploded %s", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		GetPlayerPos(targetid, px, py, pz);
		CreateExplosion(px, py, pz, 6, 8);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has exploded %s",ACMD_EXPLODE, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_EXPLODE,string);
	}
	return 1;
}

CMD:setstat(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETSTAT))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setstat [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid ID/Name.");
			return 1;
		}
		new string[256];
		format(string, sizeof(string), "[AdmCMD]: You are now setting %s's statistics", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		format(string, sizeof(string), "Skin");
		if(FoCo_Player[playerid][admin] > 3)
		{
			strins(string, "\nKills\nScore\nLevel", strlen(string));
		}
		if(FoCo_Player[playerid][admin] > 3)
		{
			strins(string, "\nMoney\nClan Leader\nDeaths\nVehicle Car Key", strlen(string));
		}
		DialogOptionVar1[playerid] = targetid;
		ShowPlayerDialog(playerid, DIALOG_ASETSTAT1, DIALOG_STYLE_LIST, "Player Statistic Setting", string, "Select", "Cancel");
	}
	return 1;
}

CMD:aresetclasses(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_ARESETCLASSES))
	{
	    new targetid;
	    new string[128];
	    if(sscanf(params, "u", targetid))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /aresetclasses [ID] (This will also reset current weapons!)");
	        return 1;
	    }
	    if(targetid == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid ID/Name");
	    }
	    ResetClasses(targetid);
     	ResetPlayerWeapons(targetid);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has reset %s(%d) weapon classes.",ACMD_ARESETCLASSES, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
		SendAdminMessage(ACMD_ARESETCLASSES,string);
		AdminLog(string);
		format(string, sizeof(string), "[INFO]: %s %s has just reset your weapon classes. This will also reset your current weapons, so use /class again.", GetPlayerStatus(playerid), PlayerName(playerid));
		SendClientMessage(targetid, COLOR_SYNTAX, string);
	}
	return 1;
}

CMD:resetstats(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_RESETSTATS))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new targetid, option;
		if(sscanf(params, "ud", targetid,option))
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /resetstats [ID/Name] 1 (Make certain that you are resetting the right person, doing it to the wrong one will fuck your day up)");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid ID/Name");
		}
		new string[256];
		SendClientMessage(targetid, COLOR_WARNING, "Screen-shot the following! This is YOUR responsibility ! ! !");
		SendClientMessage(playerid, COLOR_WARNING, "Screen-shot the following! This is YOUR responsibility ! ! !");
		format(string, sizeof(string), "%s's stats before reset done by %s %s", PlayerName(targetid), GetPlayerStatus(playerid), PlayerName(playerid));
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		SendClientMessage(targetid, COLOR_SYNTAX, string);
		SendClientMessage(targetid, COLOR_WARNING, "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-");
		SendClientMessage(playerid, COLOR_WARNING, "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-");
		format(string, sizeof(string), "Kills: %d, Deaths: %d, Level %d, Score %d, Suicides: %d, Streaks %d, Money: %d", FoCo_Playerstats[targetid][kills],FoCo_Playerstats[targetid][deaths],FoCo_Player[targetid][level],FoCo_Player[targetid][score],FoCo_Playerstats[targetid][suicides],FoCo_Playerstats[targetid][streaks],GetPlayerMoney(targetid));
		SendClientMessage(targetid, COLOR_NOTICE, string);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		format(string, sizeof(string), "Knife: %d, Chainsaw %d, Colt %d, Deagle: %d, MP5: %d, Tec-9: %d, Uzi: %d",FoCo_Playerstats[targetid][knife],FoCo_Playerstats[targetid][chainsaw],FoCo_Playerstats[targetid][colt],FoCo_Playerstats[targetid][deagle],FoCo_Playerstats[targetid][mp5],FoCo_Playerstats[targetid][tec9],FoCo_Playerstats[targetid][uzi]);
		SendClientMessage(targetid, COLOR_NOTICE, string);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		format(string, sizeof(string), "Combat shotgun: %d, AK-47: %d, M4: %d, Sniper %d, Grenade: %d, Flamethrower %d, RPG: %d",FoCo_Playerstats[targetid][combatshotgun],FoCo_Playerstats[targetid][ak47],FoCo_Playerstats[targetid][m4],FoCo_Playerstats[targetid][sniper],FoCo_Playerstats[targetid][grenade],FoCo_Playerstats[targetid][flamethrower],FoCo_Playerstats[targetid][rpg]);
		SendClientMessage(targetid, COLOR_NOTICE, string);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		SendClientMessage(targetid, COLOR_WARNING, "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-");
		SendClientMessage(playerid, COLOR_WARNING, "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-");
		SendClientMessage(targetid, COLOR_WARNING, "SCREEN-SHOT IT!");
		SendClientMessage(playerid, COLOR_WARNING, "SCREEN-SHOT IT!");

		FoCo_Playerstats[targetid][kills] = 0;
		SetPlayerScore(targetid, 0);
		FoCo_Playerstats[targetid][deaths] = 0;
		FoCo_Player[targetid][level] = 0;
		FoCo_Player[targetid][score] = 0;
		FoCo_Playerstats[targetid][suicides] = 0;
		FoCo_Playerstats[targetid][streaks] = 0;
		FoCo_Playerstats[targetid][knife] = 0;
		FoCo_Playerstats[targetid][chainsaw] = 0;
		FoCo_Playerstats[targetid][colt] = 0;
		FoCo_Playerstats[targetid][deagle] = 0;
		FoCo_Playerstats[targetid][mp5] = 0;
		FoCo_Playerstats[targetid][tec9] = 0;
		FoCo_Playerstats[targetid][uzi] = 0;
		FoCo_Playerstats[targetid][combatshotgun] = 0;
		FoCo_Playerstats[targetid][ak47] = 0;
		FoCo_Playerstats[targetid][m4] = 0;
		FoCo_Playerstats[targetid][sniper] = 0;
		FoCo_Playerstats[targetid][grenade] = 0;
		FoCo_Playerstats[targetid][flamethrower] = 0;
		FoCo_Playerstats[targetid][rpg] = 0;
		SetPlayerMoney(targetid, 0);
		ResetClasses(targetid);
		ResetPlayerWeapons(targetid);
		format(string, sizeof(string), "AdmCmd(%d):  %s %s has reset %s's(%d) stats.", ACMD_RESETSTATS, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
  		SendAdminMessage(ACMD_RESETSTATS,string);
  		AdminLog(string);
		format(string, sizeof(string), "[INFO]: Your stats has been reset and saved by %s %s (%d). If this was an error, make sure you screenshot your stats and contact the admin that reset you.", GetPlayerStatus(playerid), PlayerName(playerid), playerid);
  		SendClientMessage(playerid, COLOR_SYNTAX, string);
  		DataSave(targetid);
	}
	return 1;
}

CMD:setstatnew(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETSTAT))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new targetid, option, amount;
		if (sscanf(params, "udd", targetid,option,amount))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setstatnew [ID/Name] [statcode] [amount]");
			SendClientMessage(playerid, COLOR_SYNTAX, "[1 - Level] [2 - Warnings] [3 - Tester] [4 - Donation ID] [5 - Score]");
			SendClientMessage(playerid, COLOR_SYNTAX, "[6 - Clan] [7 - Clanrank] [8 - Carid] [9 - Kills] [10 - Deaths]");
			SendClientMessage(playerid, COLOR_SYNTAX, "[11 - Suicides] [12 - Streaks] [13 - Deagle] [14 - M4] [15 - MP5]");
			SendClientMessage(playerid, COLOR_SYNTAX, "[16 - Knife] [17 - RPG] [18 - Flamethrower] [19 - Chainsaw] ");
			SendClientMessage(playerid, COLOR_SYNTAX, "[20 - Grenade] [21 - Colt] [22 - Uzi] [23 - Combat Shotgun] ");
			SendClientMessage(playerid, COLOR_SYNTAX, "[24 - AK47] [25 - Tec9] [26 - Sniper]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid ID/Name.");
			return 1;
		}
		new string[256];
		switch(option)
		{
		    case 1:
		    {
		        if(amount < 0 || amount > 100)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry.");
		            return 1;
				}
				else
				{
					format(string, 256, "[INFO]: %s %d old level was %d", PlayerName(targetid), targetid, FoCo_Player[targetid][level]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old level was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Player[targetid][level], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
				    FoCo_Player[targetid][level] = amount;
					format(string, 256, "[INFO]: %s %s has set your level to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s 's level to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 2:
			{
   				if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
                    format(string, 256, "[INFO]: %s %d old amount of warnings was %d", PlayerName(targetid), targetid, FoCo_Player[targetid][warns]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of warnings was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Player[targetid][warns], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
        			FoCo_Player[targetid][warns] = amount;
					format(string, 256, "[INFO]: %s %s has set your amount of warnings to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's warnings to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 3:
			{
   				if(amount < 0 || amount > 1)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry.");
		            return 1;
				}
				else
				{
				    FoCo_Player[targetid][tester] = amount;
					format(string, 256, "[INFO]: %s %s has made you a tester",GetPlayerStatus(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has made %s a tester", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 4:
			{
   				if(amount < 0 || amount > 10000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry.");
		            return 1;
				}
				else
				{
				    FoCo_Player[targetid][donation]=amount;
					format(string, 256, "[INFO]: %s %s has set your Donation-ID to %d. Please relog!",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					GiveAchievement(targetid, 64);
					format(string, 256, "[INFO]: %s %s has set %s's Donation-ID %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 5:
			{
   				if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry.");
		            return 1;
				}
				else
				{
				    format(string, 256, "[INFO]: %s %d old score was %d", PlayerName(targetid), targetid, FoCo_Player[targetid][score]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old score was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Player[targetid][score], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
				    FoCo_Player[targetid][score] = amount;
					format(string, 256, "[INFO]: %s %s has set your score to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s 's score to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 6:
			{
   				if(amount < 0 || amount > 50)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry.");
		            return 1;
				}
				else
				{
				    FoCo_Player[targetid][clan] = amount;
					format(string, 256, "[INFO]: %s %s has set your clan to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s 's clan to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 7:
			{
				if(amount < 0 || amount > 5)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry.");
		            return 1;
				}
				else
				{
				    FoCo_Player[targetid][clanrank] = amount;
					format(string, 256, "[INFO]: %s %s has set your clan rank to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s 's clan rank to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 8:
			{
				if(amount < 0 || amount > 100000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Contact Marcel !");
		            return 1;
				}
				else
				{
				    FoCo_Player[targetid][users_carid] = amount;
					format(string, 256, "[INFO]: %s %s has set your car id to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s 's car id to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 9:
			{
				if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
				    FoCo_Playerstats[targetid][kills] = amount;
					format(string, 256, "[INFO]: %s %s has set your kills to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's kills to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 10:
			{
				if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
				    FoCo_Playerstats[targetid][deaths] = amount;
					format(string, 256, "[INFO]: %s %s has set your deaths to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's deaths to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 11:
			{
			    if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
				    format(string, 256, "[INFO]: %s %d old suicide amount was %d", PlayerName(targetid), targetid, FoCo_Playerstats[targetid][suicides]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of suicides was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Playerstats[targetid][suicides], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
					FoCo_Playerstats[targetid][suicides] = amount;
				    format(string, 256, "[INFO]: %s %s has set your suicides to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's suicides to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 12:
			{
			    if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
				    format(string, 256, "[INFO]: %s %d old streaks amount was %d", PlayerName(targetid), targetid, FoCo_Playerstats[targetid][streaks]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of streaks was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Playerstats[targetid][streaks], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
				    FoCo_Playerstats[targetid][streaks] = amount;
					format(string, 256, "[INFO]: %s %s has set your streaks to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's streaks to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 13:
			{
			    if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
				    format(string, 256, "[INFO]: %s %d old deagle kills was %d", PlayerName(targetid), targetid, FoCo_Playerstats[targetid][deagle]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of deagle kills was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Playerstats[targetid][deagle], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
				    FoCo_Playerstats[targetid][deagle] = amount;
					format(string, 256, "[INFO]: %s %s has set your deagle kills to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's deagle kills to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 14:
			{
			    if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
                    format(string, 256, "[INFO]: %s %d old M4 kills was %d", PlayerName(targetid), targetid, FoCo_Playerstats[targetid][m4]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of M4 kills was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Playerstats[targetid][m4], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
        			FoCo_Playerstats[targetid][m4] = amount;
					format(string, 256, "[INFO]: %s %s has set your M4 kills to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's M4 kills to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 15:
			{
			    if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
                    format(string, 256, "[INFO]: %s %d old MP5 kills was %d", PlayerName(targetid), targetid, FoCo_Playerstats[targetid][mp5]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of MP5 kills was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Playerstats[targetid][mp5], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
        			FoCo_Playerstats[targetid][mp5] = amount;
					format(string, 256, "[INFO]: %s %s has set your MP5 kills to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's MP5 kills to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 16:
			{
			    if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
                    format(string, 256, "[INFO]: %s %d old knife kills was %d", PlayerName(targetid), targetid, FoCo_Playerstats[targetid][knife]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of knife kills was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Playerstats[targetid][knife], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
        			FoCo_Playerstats[targetid][knife] = amount;
					format(string, 256, "[INFO]: %s %s has set your knife kills to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's knife kills to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 17:
			{
                if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
                    format(string, 256, "[INFO]: %s %d old RPG kills was %d", PlayerName(targetid), targetid, FoCo_Playerstats[targetid][rpg]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of RPG kills was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Playerstats[targetid][rpg], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
        			FoCo_Playerstats[targetid][rpg] = amount;
					format(string, 256, "[INFO]: %s %s has set your RPG kills to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's RPG kills to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 18:
			{
                if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
                    format(string, 256, "[INFO]: %s %d old flamethrower kills was %d", PlayerName(targetid), targetid, FoCo_Playerstats[targetid][flamethrower]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of flamethrower kills was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Playerstats[targetid][flamethrower], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
        			FoCo_Playerstats[targetid][flamethrower] = amount;
					format(string, 256, "[INFO]: %s %s has set your flamethrower kills to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's flamethrower kills to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 19:    // Chainsaw Kills
			{
			    if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
                    format(string, 256, "[INFO]: %s %d old chainsaw kills was %d", PlayerName(targetid), targetid, FoCo_Playerstats[targetid][chainsaw]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of chainsaw kills was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Playerstats[targetid][chainsaw], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
        			FoCo_Playerstats[targetid][chainsaw] = amount;
					format(string, 256, "[INFO]: %s %s has set your chainsaw kills to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's chainsaw kills to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 20:    // Grenades Kills
			{
			    if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
    				format(string, 256, "[INFO]: %s %d old grenade kills was %d", PlayerName(targetid), targetid, FoCo_Playerstats[targetid][grenade]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of grenade kills was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Playerstats[targetid][grenade], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
        			FoCo_Playerstats[targetid][grenade] = amount;
					format(string, 256, "[INFO]: %s %s has set your grenade kills to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's grenade kills to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 21:    // Colt Kills
			{
			    if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
				    format(string, 256, "[INFO]: %s %d old colt kills was %d", PlayerName(targetid), targetid, FoCo_Playerstats[targetid][colt]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of colt kills was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Playerstats[targetid][colt], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
        			FoCo_Playerstats[targetid][colt] = amount;
					format(string, 256, "[INFO]: %s %s has set your colt kills to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's colt kills to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 22:    // Uzi Kills
			{
			    if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
                    format(string, 256, "[INFO]: %s %d old uzi kills was %d", PlayerName(targetid), targetid, FoCo_Playerstats[targetid][uzi]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of uzi kills was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Playerstats[targetid][uzi], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
        			FoCo_Playerstats[targetid][uzi] = amount;
					format(string, 256, "[INFO]: %s %s has set your uzi kills to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's uzi kills to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 23:    // Combat Shotgun Kills
			{
			    if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
    				format(string, 256, "[INFO]: %s %d old combat shotgun kills was %d", PlayerName(targetid), targetid, FoCo_Playerstats[targetid][combatshotgun]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of combat shotgun kills was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Playerstats[targetid][combatshotgun], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
        			FoCo_Playerstats[targetid][combatshotgun] = amount;
					format(string, 256, "[INFO]: %s %s has set your combat shotgun kills to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's combat shotgun kills to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 24:    // AK47 Kills
			{
   				if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
                    format(string, 256, "[INFO]: %s %d old AK47 kills was %d", PlayerName(targetid), targetid, FoCo_Playerstats[targetid][ak47]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of AK47 kills was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Playerstats[targetid][ak47], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
        			FoCo_Playerstats[targetid][ak47] = amount;
					format(string, 256, "[INFO]: %s %s has set your AK47 kills to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's AK47 kills to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 25:    // TEC9 Kills
			{
			    if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
                    format(string, 256, "[INFO]: %s %d old tec9 kills was %d", PlayerName(targetid), targetid, FoCo_Playerstats[targetid][tec9]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of tec9 kills was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Playerstats[targetid][tec9], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
        			FoCo_Playerstats[targetid][tec9] = amount;
					format(string, 256, "[INFO]: %s %s has set your tec9 kills to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's tec9 kills to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
			case 26:    // Sniper
			{
   				if(amount < 0 || amount > 1000000)
		        {
		            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Entry. Higher value required? Contact pEar/Marcel");
		            return 1;
				}
				else
				{
                    format(string, 256, "[INFO]: %s %d old sniper kills was %d", PlayerName(targetid), targetid, FoCo_Playerstats[targetid][sniper]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: Your old amount of sniper kills was %d and it has now been set by %s - Screenshot this in case it bugs up.", FoCo_Playerstats[targetid][sniper], PlayerName(playerid), PlayerName(playerid));
					SendClientMessage(targetid, COLOR_YELLOW, string);
        			FoCo_Playerstats[targetid][sniper] = amount;
					format(string, 256, "[INFO]: %s %s has set your sniper kills to %d",GetPlayerStatus(playerid), PlayerName(playerid), amount);
					SendClientMessage(targetid, COLOR_YELLOW, string);
					format(string, 256, "[INFO]: %s %s has set %s's sniper kills to %d", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), amount);
					SendAdminMessage(ACMD_SETSTAT, string);
				}
			}
		}
	}
	return 1;
}

CMD:getall(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GETALL))
	{
		new string[128], Float:here_x, Float:here_y, Float:here_z, here_world = GetPlayerVirtualWorld(playerid), here_int = GetPlayerInterior(playerid);
		GetPlayerPos(playerid, here_x, here_y, here_z);
		foreach(Player, i)
		{
			SetPlayerPos(i, here_x, here_y, here_z);
			SetPlayerVirtualWorld(i, here_world);
			SetPlayerInterior(i, here_int);
		}
		format(string, sizeof(string), "[AdmCMD]: %s %s has teleported everyone to his location.", GetPlayerStatus(playerid), PlayerName(playerid));
		SendClientMessageToAll(COLOR_NOTICE, string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	}
	return 1;
}

/* LEVEL FOUR ADMIN COMMANDS */

CMD:la(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_LA))
	{
		new message[256];
		if(sscanf(params, "s[256]", message))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /la [message]");
			return 1;
		}
		new string[256];

		if(strlen(message) > 80)
		{
		    new message2[300];
		 	strmid(message2,message,80,strlen(message),sizeof(message2));
		 	strmid(message,message,0,80,sizeof(message));
		 	format(string, sizeof(string), "{990012}[Lead Admin Chat] - {%06x}%s:{990012} %s", COLOR_LARED >>> 8, PlayerName(playerid), message);
			SendAdminMessage(ACMD_LA, string);
			format(string, sizeof(string), "[Lead Admin Chat] - %s (%d): %s", GetPlayerStatus(playerid), PlayerName(playerid),playerid, message);
			LeadAdminChatLog(string);
			format(string, sizeof(string), "3[Lead Admin Chat] - %s: %s", PlayerName(playerid), message);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			format(string, sizeof(string), "{990012}[Lead Admin Chat] - {%06x}%s:{990012} %s", COLOR_LARED >>> 8, PlayerName(playerid), message2);
			//old color: FFBE00
			SendAdminMessage(ACMD_LA, string);
			format(string, sizeof(string), "[Lead Admin Chat] - %s (%d): %s", PlayerName(playerid),playerid, message2);
			LeadAdminChatLog(string);
			format(string, sizeof(string), "3[Lead Admin Chat] - %s: %s", PlayerName(playerid), message2);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		}
		else
		{
			format(string, sizeof(string), "{990012}[Lead Admin Chat] - {%06x}%s:{990012} %s", COLOR_LARED >>> 8, PlayerName(playerid), message);
			SendAdminMessage(ACMD_LA, string);
			format(string, sizeof(string), "[Lead Admin Chat] - %s (%d): %s", PlayerName(playerid),playerid, message);
			LeadAdminChatLog(string);
			format(string, sizeof(string), "3[Lead Admin Chat] - %s: %s", PlayerName(playerid), message);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		}
	}
	return 1;
}

CMD:setadmin(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETADMIN) || FoCo_Player[playerid][id] == 368)
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new targetid, rank;
		if (sscanf(params, "ui", targetid, rank))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setadmin [ID/Name] [Rank]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(rank > 5)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid amount, must be below or equal to 5.");
			return 1;
		}
		new string[156];
		format(string, sizeof(string), "[AdmCMD]: %s %s has made you a %s (Rank %i).", GetPlayerStatus(playerid), PlayerName(playerid), AdRankNames[rank], rank);
		SendClientMessage(targetid, COLOR_NOTICE, string);
		format(string, sizeof(string), "Make sure you update yourself on the new commands by visiting the forum section for admins & /ahelp");
		SendClientMessage(targetid, COLOR_NOTICE, string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has made %s an admin(%d)",ACMD_SETADMIN, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), rank);
		SendAdminMessage(ACMD_SETADMIN,string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		FoCo_Player[targetid][admin] = rank;
		if(rank == 5)
		{
		    GiveAchievement(targetid, 98);
		}
		else
		{
		    GiveAchievement(targetid, 97);
		}
	}
	return 1;
}

CMD:settrialadmin(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETTRIALADMIN))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /settrialadmin [ID/Name]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		new string[128];
		if(!IsTrialAdmin(targetid))
		{
			format(string, sizeof(string), "[AdmCMD]: %s %s has made you a Trial Admin. Use /th to become accustomed to the commands!", GetPlayerStatus(playerid), PlayerName(playerid));
			SendClientMessage(targetid, COLOR_NOTICE, string);
			format(string, sizeof(string), "AdmCmd(%d): %s %s has made %s a Trial Admin.",ACMD_SETTRIALADMIN, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
			SendAdminMessage(ACMD_SETTRIALADMIN,string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			FoCo_Player[targetid][tester] = 1;
			GiveAchievement(targetid, 96);
		}
		else
		{
			format(string, sizeof(string), "[AdmCMD]: %s %s has removed your Trial Admin status.", GetPlayerStatus(playerid), PlayerName(playerid));
			SendClientMessage(targetid, COLOR_NOTICE, string);
			format(string, sizeof(string), "AdmCmd(%d): %s %s has removed %s's Trial Admin status.",ACMD_SETTRIALADMIN, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
			SendAdminMessage(ACMD_SETTRIALADMIN,string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			FoCo_Player[targetid][tester] = 0;
		}
	}
	return 1;
}


CMD:ns(playerid, params[])
{
	if(IsAdmin(playerid,ACMD_NS))
	{
		if(ADuty[playerid] == 0 && FoCo_Player[playerid][admin] < 5)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  You can not use this unless you are on admin duty.");
			return 1;
		}
		ShowPlayerDialog(playerid, DIALOG_ANITROUSBOOST, DIALOG_STYLE_LIST, "Nitrous Speed Selection", "Off\nLow\nMedium\nHigh", "Select", "Cancel");
	}
	return 1;
}

CMD:quicksumo(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_QUICKSUMO))
	{
		SetPlayerVirtualWorld(playerid, 505);
		SetPlayerPos(playerid, 1492.69921875,6248.00000000,25.00000000);
	}
	return 1;
}

CMD:createcar(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_CREATECAR))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new model[56], modelid, col1, col2, vehid;
		if(sscanf(params, "s[56]ii", model, col1, col2))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "	[USAGE]: /createcar [ID/Name] [Color 1] [Color 2]");
			return 1;
		}
		else
		{
			if(GetVehicleModelIDFromName(model) == -1)
			{
				modelid = strval(model);
			}
			else modelid = GetVehicleModelIDFromName(model);
			if(modelid < 400 || modelid > 611)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid model range - 400 to 611 only");
				return 1;
			}

			if(col1 < 0 || col1 > 255)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid color range - 0 to 255 only");
				return 1;
			}

			if(col2 < 0 || col2 > 255)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid color range - 0 to 255 only");
				return 1;
			}

			new str[MAX_PLAYER_NAME];
			format(str, sizeof(str), "%d %d %d", modelid, col1, col2);
			nameThread[playerid] = str; // just use this to pass the variables to the CallBack
			mysql_query_callback(playerid, "SELECT MAX(ID) FROM `FoCo_Vehicles`", "OnCreateVehicleThread", vehid, con);
		}
	}
	return 1;
}

CMD:setcar(playerid, params[])
{
    if(IsAdmin(playerid, ACMD_SETCAR))
	{
		if(!CMD_Auth(playerid)) return 1;
		new stat[20], type, string[128], vehid, Float:x, Float:y, Float:z, Float:angle, plate[16];
		if(!IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  You need to be in the vehicle you wish to change. ");
			return 1;
		}

		if(carsettimer[playerid] + 4 > GetUnixTime())
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Wait five seconds before the next command");
			return 1;
		}
		vehid = GetPlayerVehicleID(playerid);
		GetVehiclePos(vehid, x, y, z);
		GetVehicleZAngle(vehid, angle);
		if (sscanf(params, "s[20] ", stat))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setcar [Options]");
			SendClientMessage(playerid, COLOR_SYNTAX, "[PARAMS]: Spawn, Plate, Color1, Color2");
			return 1;
		}
		carsettimer[playerid] = GetUnixTime();
		if(strcmp(stat,"Spawn", true) == 0)
		{
			new query[255], vehids, model, col1, col2, carid;

			if(vehid == INVALID_VEHICLE_ID)
			{
				SendClientMessage(playerid, COLOR_WARNING, "Vehicle doesn't seem to exsist... try and delete it instead of moving it");
				return 1;
			}

			col1 = FoCo_Vehicles[vehid][ccol1];
			col2 = FoCo_Vehicles[vehid][ccol2];
			model = FoCo_Vehicles[vehid][cmodel];
			carid = FoCo_Vehicles[vehid][cid];

			DestroyVehicle(vehid);
			nullcar(vehid);

			vehids = CreateVehicle(model, x, y, z, angle, col1, col2, 120);
			FoCo_Vehicles[vehids][cmodel] = model;
			FoCo_Vehicles[vehids][cid] = carid;
			FoCo_Vehicles[vehids][cx] = x;
			FoCo_Vehicles[vehids][cy] = y;
			FoCo_Vehicles[vehids][cz] = z;
			FoCo_Vehicles[vehids][cangle] = angle;
			FoCo_Vehicles[vehids][cvw] = GetPlayerVirtualWorld(playerid);
			FoCo_Vehicles[vehids][cint] = GetPlayerInterior(playerid);
			LinkVehicleToInterior(vehids, FoCo_Vehicles[vehids][cint]);
			SetVehicleVirtualWorld(vehids, FoCo_Vehicles[vehids][cvw]);
			format(FoCo_Vehicles[vehids][cplate], 128,"FoCo TDM");
			SetVehicleNumberPlate(vehids, plate);

			format(string, sizeof(string), "AdmCmd(%d): %s has set vehicle %d's spawn",ACMD_SETCAR, PlayerName(playerid), vehids);
			SendAdminMessage(ACMD_SETCAR,string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			if(FoCo_Vehicles[vehids][coid] == 0)
			{
				format(query, sizeof(query), "UPDATE `FoCo_Vehicles` SET `x`='%f', `y`='%f', `z`='%f', `angle`='%f', `vw`='%d', `interior`='%d' WHERE `ID`='%d'", x, y, z, angle, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), FoCo_Vehicles[vehids][cid]); //Changed the WHERE vallue - Beanz
			}
			else
			{
				format(query, sizeof(query), "UPDATE `FoCo_Player_Vehicles` SET `x`='%f', `y`='%f', `z`='%f', `angle`='%f' WHERE `ID`='%d'", x, y, z, angle, FoCo_Vehicles[vehids][cid]); //Changed the WHERE vallue - Beanz
			}
			mysql_query_callback(playerid, query, "OnVehicleSpawnQueryAdmin", vehid, con);
		}
		else if(strcmp(stat, "plate", true) == 0)
		{
			if(sscanf(params, "s[20]s[20]", stat, plate))
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setcar plate [Text]");
			}
			else
			{
				if(strlen(plate) > 10)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Plate must be less than ten characters");
					return 1;
				}

				format(FoCo_Vehicles[vehid][cplate], 128,"%s",plate);
				SetVehicleNumberPlate(vehid, plate);
				SetVehicleToRespawn(vehid);
				if(FoCo_Vehicles[vehid][coid] == 0)
				{
					format(string, sizeof(string), "UPDATE `FoCo_Vehicles` SET `plate`='%s' WHERE `ID`='%d'", FoCo_Vehicles[vehid][cplate], FoCo_Vehicles[vehid][cid]);
				}
				else
				{
					format(string, sizeof(string), "UPDATE `FoCo_Player_Vehicles` SET `plate`='%s' WHERE `ID`='%d'", FoCo_Vehicles[vehid][cplate], FoCo_Vehicles[vehid][cid]);
				}
				mysql_query(string, MYSQL_PLATE_ADMIN_UPDATE, playerid, con);
				format(string, sizeof(string), "AdmCmd(%d): %s has set vehicle %d's license plate to %s", ACMD_SETCAR,PlayerName(playerid), vehid, plate);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
				SendAdminMessage(ACMD_SETCAR,string);
			}
		}
		else if(strcmp(stat,"Color1", true) == 0)
		{
			if(sscanf(params, "s[20]i", stat, type))
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setcar Color1 [Color]");
			}
			else
			{
				if(type > 255)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Car color must be below 255");
					return 1;
				}
				FoCo_Vehicles[vehid][ccol1] = type;
				ChangeVehicleColor(vehid, type, FoCo_Vehicles[vehid][ccol2]);
				format(string, sizeof(string), "AdmCmd(%d): %s has set vehicle %d's color ` to %d", ACMD_SETCAR,PlayerName(playerid), vehid, type);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
				SendAdminMessage(ACMD_SETCAR,string);
				if(FoCo_Vehicles[vehid][coid] == 0)
				{
					MySQLUpdateVehSingle("FoCo_Vehicles", FoCo_Vehicles[vehid][cid], "col1", type);
				}
				else
				{
					MySQLUpdateVehSingle("FoCo_Player_Vehicles", FoCo_Vehicles[vehid][cid], "col1", type);
				}
			}
		}
		else if(strcmp(stat,"Color2", true) == 0)
		{
			if(sscanf(params, "s[20]i", stat, type))
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /setcar Color2 [Color]");
			}
			else
			{
				if(type > 255)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Car color must be below 255");
					return 1;
				}
				FoCo_Vehicles[vehid][ccol2] = type;
				ChangeVehicleColor(vehid, FoCo_Vehicles[vehid][ccol1], type);
				format(string, sizeof(string), "AdmCmd(%d): %s has set vehicle %d's color 2 to %d", ACMD_SETCAR,PlayerName(playerid), vehid, type);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
				SendAdminMessage(ACMD_SETCAR,string);
				if(FoCo_Vehicles[vehid][coid] == 0)
				{
					MySQLUpdateVehSingle("FoCo_Vehicles", FoCo_Vehicles[vehid][cid], "col2", type);
				}
				else
				{
					MySQLUpdateVehSingle("FoCo_Player_Vehicles", FoCo_Vehicles[vehid][cid], "col2", type);
				}
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Unknown parameter.");
			return 1;
		}
	}
	return 1;
}

CMD:godcar(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GODCAR))
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		new Float:vhealth;
		GetVehicleHealth(vehicleid, vhealth);
		if(IsPlayerInAnyVehicle(playerid) == 0)
		{
			SendClientMessage(playerid, COLOR_WARNING,  "[ERROR]:  You need to be in a vehicle to use this command.");
			return 1;
		}
		RepairVehicle(vehicleid);
		new string[128];
		format(string, sizeof(string), "AdmCmd(%d): %s %s has enabled car god mode in their vehicle. (ID: %d)",ACMD_GODCAR, GetPlayerStatus(playerid), PlayerName(playerid), vehicleid);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_GODCAR,string);
		SendClientMessage(playerid, COLOR_CMDNOTICE, "[AdmCMD]: Vehicle HP set to 999999.9, remember to respawn it or use /godcar.");
		SetVehicleHealth(vehicleid, 999999.9);
	}
	return 1;
}

CMD:pickups(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_PICKUPS))
	{
		new option[50];
		if (sscanf(params, "s[50] ", option))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "	[USAGE]: /pickups [Parameter]");
			SendClientMessage(playerid, COLOR_GRAD1, " [PARAMS]: Add - Delete - Move ");
			return 1;
	    }

		if(strcmp(option,"Add", true) == 0)
		{
			ShowPlayerDialog(playerid, DIALOG_PICKUP1, DIALOG_STYLE_INPUT, "Pickup Name Creation", "Please choose a name for the pickup, also ensure you are stood at the location you wish for it to be!", "Select", "Close");
			return 1;
		}
		else if(strcmp(option, "Delete", true) == 0)
		{
			new pickid;
			if (sscanf(params, "s[50]d", option, pickid))
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "	[USAGE]: /pickups delete [ID]");
				return 1;
			}

			new string[300];
			format(string, sizeof(string), "Are you sure you want to delete PICKUP %d, this will permanantly erase it from the database. \n\n This was added by: %s \n\n This has the message: %s",
			pickid, FoCo_Pickups[pickid][LP_addedby], FoCo_Pickups[pickid][LP_message]);
			pickupdelID[playerid] = pickid;
			ShowPlayerDialog(playerid, DIALOG_PICKUPDEL, DIALOG_STYLE_MSGBOX, "Pickup Deletion", string, "Commit", "Cancel");
			return 1;
		}
		else if(strcmp(option, "move", true) == 0)
		{
			new pickid;
			if (sscanf(params, "s[50]d", option, pickid))
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "	[USAGE]: /pickups move [ID]");
				return 1;
			}

			new string[300];
			format(string, sizeof(string), "Are you sure you want to move PICKUP %d to the location your standing, this will permanantly move it. \n\n This was added by: %s \n\n This has the message: %s",
			pickid, FoCo_Pickups[pickid][LP_addedby], FoCo_Pickups[pickid][LP_message]);
			pickupdelID[playerid] = pickid;
			ShowPlayerDialog(playerid, DIALOG_PICKUPMOVE, DIALOG_STYLE_MSGBOX, "Pickup Move", string, "Commit", "Cancel");
			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid Param.");
		}
	}
	return 1;
}

CMD:modify(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_MODIFY))
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You must actually be in a vehicle dumbass");
			return 1;
		}

		new vehid = GetPlayerVehicleID(playerid);
		new model = GetVehicleModel(vehid);
		new selected = 0;
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
				selected++;
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
				selected++;
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
				selected++;
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
				selected++;
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
				selected++;
			}
			case 536: // blade
			{
				AddVehicleComponent(vehid, 1010);
				AddVehicleComponent(vehid, 1103);
				AddVehicleComponent(vehid, 1105);
				AddVehicleComponent(vehid, 1106);
				AddVehicleComponent(vehid, 1108);
				ChangeVehiclePaintjob(vehid, 1);
				selected++;
			}
			case 535: // slamvan
			{
				AddVehicleComponent(vehid, 1010);
				AddVehicleComponent(vehid, 1113);
				AddVehicleComponent(vehid, 1115);
				AddVehicleComponent(vehid, 1117);
				AddVehicleComponent(vehid, 1118);
				ChangeVehiclePaintjob(vehid, 2);
				selected++;
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
				selected++;
			}
		}
		if(selected == 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This vehicle is not modable.");
			return 1;
		}
		else
		{
			FoCo_Vehicles[vehid][special_mod] = 1;
			new qry[128];
			if(FoCo_Vehicles[vehid][coid] == 0)
			{
				format(qry, sizeof(qry), "UPDATE `FoCo_Vehicles` SET `special_mod`='%d' WHERE `ID`='%d'", FoCo_Vehicles[vehid][special_mod], FoCo_Vehicles[vehid][cid]); //Changed the WHERE vallue - Beanz
			}
			else
			{
				format(qry, sizeof(qry), "UPDATE `FoCo_Player_Vehicles` SET `special_mod`='%d' WHERE `ID`='%d'", FoCo_Vehicles[vehid][special_mod], FoCo_Vehicles[vehid][cid]);
			}
			mysql_query(qry, MYSQL_FUNCTION_MOD, vehid, con);
			new string[130];
			format(string, sizeof(string), "AdmCmd(%d): %s %s has set a created car to spawn with a special modpack.",ACMD_MODIFY, GetPlayerStatus(playerid), PlayerName(playerid));
			SendAdminMessage(ACMD_MODIFY,string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		}
	}
	return 1;
}

CMD:eao(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_EAO))
	{
		new option;
		if (sscanf(params, "d", option))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "	[USAGE]: /eao [slot]");
			return 1;
	    }
		EditAttachedObject(playerid, option);
		SendClientMessage(playerid, COLOR_WARNING, "Editing Attached Object.");
	}
	return 1;
}

CMD:ateam(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_ATEAM))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new option[50];
		if (sscanf(params, "s[50] ", option))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "	[USAGE]: /ateam [Parameter]");
			SendClientMessage(playerid, COLOR_GRAD1, " [PARAMS]: Create - Edit - Delete - Info");
			return 1;
	    }

		if(strcmp(option,"Create", true) == 0)
		{
			DialogOptionVar1[playerid] = 0;
			ShowPlayerDialog(playerid, DIALOG_CREATETEAM, DIALOG_STYLE_INPUT, "Team Creation", "Welcome to Team Creation \n\n Please ensure you are at the spawn point you wish the clan to spawn at.\n\n Then type below the name of the clan.", "Next", "Close");
			return 1;
		}
		else if(strcmp(option,"Edit", true) == 0)
		{
			new msg[1024];
			foreach (FoCoTeams, i)
			{
				if(FoCo_Teams[i][team_type] != 0)
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
			DialogOptionVar1[playerid] = 65535;
			ShowPlayerDialog(playerid, DIALOG_EDITTEAM1, DIALOG_STYLE_LIST, "Team Editng", msg, "Select", "Cancel");
			return 1;
		}
		else if(strcmp(option,"Delete", true) == 0)
		{
			new teamid;
			if (sscanf(params, "s[50]d ", option, teamid))
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /ateam delete [ID]");
				return 1;
			}

			new string[300];
			format(string, sizeof(string), "Are you sure you want to delete TEAM %d, this will permanantly erase it from the database. Name: %s", teamid, FoCo_Teams[teamid][team_name]);

			pickupdelID[playerid] = teamid;
			ShowPlayerDialog(playerid, DIALOG_TEAMDEL, DIALOG_STYLE_MSGBOX, "Team Deletion", string, "Commit", "Cancel");
			return 1;
		}
		else if(strcmp(option,"Info", true) == 0)
		{
			new msg[1024];
			foreach (FoCoTeams, i)
			{
				if(FoCo_Teams[i][team_type] != 0)
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
			ShowPlayerDialog(playerid, DIALOG_TEAMINFO, DIALOG_STYLE_LIST, "Team Information", msg, "Select", "Cancel");
			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid parameter.");
		}
	}
	return 1;
}

CMD:endround(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_ENDROUND))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		ShowPlayerDialog(playerid, DIALOG_RESTART, DIALOG_STYLE_MSGBOX, "Restart Server", "You sure you want to restart the server? This will happen after 30 seconds and save all information.", "Yes", "No");
	}
	return 1;
}

CMD:changename(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_CHANGENAME))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new targetid, newname[MAX_PLAYER_NAME], string[255];
		if (sscanf(params, "us[20]", targetid, newname))
		{
			format(string, sizeof(string), "[USAGE]: {%06x}/changename {%06x}[id] [new name]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			return 1;
		}

		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID.");
			return 1;
		}

		if(strlen(newname) > 20)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your name can't be longer then 20 characters.");
			return 1;
		}
		
		if(strlen(newname) < 4)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your name can't be shorter than 4 characters.");
		    return 1;
		}
		
		if(FoCo_Player[targetid][admin] >= FoCo_Player[playerid][admin] && playerid != targetid)
		{
		    if(FoCo_Player[playerid][id] != 368)
		    {
			    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command on other admins with the same or higher admin level as yourself. Naughty!");
			    return 1;
		    }
		}

		new name[MAX_PLAYER_NAME];
		format(name, sizeof(name), "%s", newname);
		nameThread[playerid] = name;
		format(string, sizeof(string), "SELECT * FROM `FoCo_Players` WHERE `username`='%s' LIMIT 1", newname);
		mysql_query_callback(playerid, string, "OnNameChangeThread", targetid, con);
	}
	return 1;
}

CMD:motd(playerid, params[])
{
 	if(IsAdmin(playerid, ACMD_MOTD))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new motd[512];
		if(sscanf(params, "s[512]", motd))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /motd [message]");
			return 1;
		}
		format(MessageOfTheDay, 512, "%s",motd);
		new string[512];
		format(string, 512, "New Message defined: %s", MessageOfTheDay);
		SendClientMessage(playerid, COLOR_GREEN, string);
		SendClientMessageToAll(COLOR_GREEN, "[INFO]: New Message of the Day has been defined. Check with /showmotd !");
	}
	return 1;
}

CMD:spincar(playerid, params[])
{
 	if(IsAdmin(playerid, ACMD_SPINCAR))
	{
		new pid;
		if(sscanf(params, "d", pid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /spincar [Playerid]");
			return 1;
		}
		SetVehicleAngularVelocity(GetPlayerVehicleID(pid), 0.0, 0.0, 1.0);
	}
	return 1;
}

CMD:connectbots(playerid, params[])
{
 	if(IsAdmin(playerid, ACMD_CONNECTBOTS))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		if(FoCo_Player[playerid][admin] >= 4 && BotsConnected == 1)
		{
		    SendClientMessage(playerid, COLOR_RED, "[INFO]: Bots are already connected!");
		    return 1;
		}
		gBotID[0] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_1_NICKNAME, BOT_1_REALNAME, BOT_1_USERNAME);
//		IRC_SetIntData(gBotID[0], E_IRC_CONNECT_DELAY, 3);
		gBotID[1] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_2_NICKNAME, BOT_2_REALNAME, BOT_2_USERNAME);
//		IRC_SetIntData(gBotID[1], E_IRC_CONNECT_DELAY, 6);
		gBotID[2] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_3_NICKNAME, BOT_3_REALNAME, BOT_3_USERNAME);
//		IRC_SetIntData(gBotID[2], E_IRC_CONNECT_DELAY, 9);
		gMain = IRC_CreateGroup();

		gBotID[3] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_4_NICKNAME, BOT_4_REALNAME, BOT_4_USERNAME);
//		IRC_SetIntData(gBotID[3], E_IRC_CONNECT_DELAY, 12);
		gBotID[4] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_5_NICKNAME, BOT_5_REALNAME, BOT_5_USERNAME);
//		IRC_SetIntData(gBotID[4], E_IRC_CONNECT_DELAY, 14);
		gBotID[5] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_6_NICKNAME, BOT_6_REALNAME, BOT_6_USERNAME);
//		IRC_SetIntData(gBotID[5], E_IRC_CONNECT_DELAY, 16);
		gEcho = IRC_CreateGroup();

		gBotID[6] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_7_NICKNAME, BOT_7_REALNAME, BOT_7_USERNAME);
//		IRC_SetIntData(gBotID[6], E_IRC_CONNECT_DELAY, 18);
		gBotID[7] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_8_NICKNAME, BOT_8_REALNAME, BOT_8_USERNAME);
//		IRC_SetIntData(gBotID[7], E_IRC_CONNECT_DELAY, 20);
		gBotID[8] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_9_NICKNAME, BOT_9_REALNAME, BOT_9_USERNAME);
//		IRC_SetIntData(gBotID[8], E_IRC_CONNECT_DELAY, 22);
		gLeads = IRC_CreateGroup();

		gBotID[9] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_10_NICKNAME, BOT_10_REALNAME, BOT_10_USERNAME);
//		IRC_SetIntData(gBotID[9], E_IRC_CONNECT_DELAY, 29);
		gBotID[10] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_11_NICKNAME, BOT_11_REALNAME, BOT_11_USERNAME);
//		IRC_SetIntData(gBotID[10], E_IRC_CONNECT_DELAY, 32);
		gAdmin = IRC_CreateGroup();

		gBotID[11] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_12_NICKNAME, BOT_12_REALNAME, BOT_12_USERNAME);
 		gBotID[12] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_13_NICKNAME, BOT_13_REALNAME, BOT_13_USERNAME);
		gTRAdmin = IRC_CreateGroup();
		BotsConnected = 1;
	}
	return 1;
}
CMD:disconnectbots(playerid, params[])
{
 	if(IsAdmin(playerid, ACMD_DISCONNECTBOTS))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		if(FoCo_Player[playerid][admin] >= 4 && BotsConnected == 0)
		{
		    SendClientMessage(playerid, COLOR_RED, "[INFO]: Bots are already disconnected!");
		    return 1;
		}
	   	IRC_Quit(gBotID[0], "Mow's fault");
		IRC_Quit(gBotID[1], "Aero's fault");
		IRC_Quit(gBotID[2], "Shaney's fault");
		IRC_Quit(gBotID[3], "Khronos's fault");
		IRC_Quit(gBotID[4], "amef's fault");
		IRC_Quit(gBotID[5], "krisk's fault");
		IRC_Quit(gBotID[6], "Garteus's fault");
		IRC_Quit(gBotID[7], "Schleich's fault");
		IRC_Quit(gBotID[8], "Shaney's fault");
		IRC_Quit(gBotID[9], "Marcel's fault");
		IRC_Quit(gBotID[10], "Simon's Fault");
		IRC_Quit(gBotID[11], "Vista's fault");
		IRC_Quit(gBotID[12], "Death's fault");
		IRC_DestroyGroup(gEcho);
		IRC_DestroyGroup(gLeads);
		IRC_DestroyGroup(gMain);
		IRC_DestroyGroup(gAdmin);
		IRC_DestroyGroup(gTRAdmin);
		BotsConnected = 0;
	}
	return 1;
}

CMD:getxyz(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GETXYZ))
	{
		new aString[64], Float:coordinates[3];
		GetPlayerPos(playerid, coordinates[0], coordinates[1], coordinates[2]);
		format(aString, sizeof(aString), "Your co-ordinates are %f, %f, %f.", coordinates[0], coordinates[1], coordinates[2]);
		SendClientMessage(playerid, COLOR_CMDNOTICE, aString);
	}
	return 1;
}

CMD:xyzlog(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_XYZLOG))
	{
		new Float:x_x_x, Float:y_y_y, Float:z_z_z, Float:a_a_a, string[128];
		GetPlayerPos(playerid, x_x_x, y_y_y, z_z_z);
		GetPlayerFacingAngle(playerid, a_a_a);
		format(string, sizeof(string), "{%f, %f, %f, %f}", x_x_x, y_y_y, z_z_z, a_a_a);
		xyza(string);
	}
	return 1;
}

/*
CMD:tempban(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_TEMPBAN))
	{
	    new targetid, bantime, reason[156];
	    if(sscanf(params, "uds[156]", targetid, bantime, reason))
	    {
			SendClientMessage(playerid,COLOR_SYNTAX, "[USAGE]: /tempban [ID/Name] [time in days] [reason]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(FoCo_Player[targetid][admin] >= FoCo_Player[playerid][admin] && FoCo_Player[playerid][id] != 368 && playerid != targetid)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command on other admins with the same or higher admin level as yourself. Naughty!");
		    return 1;
		}
		new string[256];
		format(string, sizeof(string), "[AdmCMD]: %s has banned %s(%d) for %d days, Reason: %s", PlayerName(playerid), PlayerName(targetid), targetid,bantime, reason);
		SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
		SendClientMessage(targetid, COLOR_NOTICE, "If you find this ban wrongful you can appeal at: forum.focotdm.com");
		AdminLog(string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		FoCo_Player[playerid][admin_bans]++;
		mysql_real_escape_string(reason, reason);
		format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`, `time`) VALUES ('%d', '%s', '3', '[Tempban - %d days]: %s', '%s','%d')", FoCo_Player[targetid][id], PlayerName(playerid), bantime, reason, TimeStamp(),bantime);
		mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
		FoCo_Player[targetid][tempban] = gettime()+(bantime*86400);
		Kick(targetid);
	}
	return 1;
}
*/

CMD:ahide(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_AHIDE))
	{
	    if(ahide[playerid] == 0)
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO] Your name is now hidden on the /admins - list!");
	        ahide[playerid] = 1;
		}
		else if(ahide[playerid] == 1)
		{
		    SendClientMessage(playerid, COLOR_GREEN, "[INFO] Your name is now visible on the /admins - list!");
		    ahide[playerid] = 0;
		}
	}
	return 1;
}

forward PearMarcelVistaMessage(string[]);
public PearMarcelVistaMessage(string[])
{
	foreach (Player, i)
	{
		if(FoCo_Player[i][id] == 109979 || FoCo_Player[i][id] == 368 || FoCo_Player[i][id] == 28261 || FoCo_Player[i][id] == 4762)
		{
			SendClientMessage(i, COLOR_LIGHTBLUE, string);
		}
	}
	return 1;
}

CMD:pdm(playerid, params[])
{
	if(FoCo_Player[playerid][id] == 109979 || FoCo_Player[playerid][id] == 368 || FoCo_Player[playerid][id] == 28261 || FoCo_Player[playerid][id] == 4762)
	{
		new message[256];
		if (sscanf(params, "s[256]", message))
		{
			format(message, sizeof(message), "[USAGE]: {%06x}/pdm{%06x}[Message]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, message);
			return 1;
		}
		new string[256];
		if(strlen(message) > 80)
		{
		    new message2[300];
		 	strmid(message2,message,80,strlen(message),sizeof(message2));
		 	strmid(message,message,0,80,sizeof(message));
			format(string, sizeof(string), "[PDM-Chat] {%06x}%s:{%06x} %s", COLOR_YELLOW >>> 8,  PlayerName(playerid), COLOR_LIGHTBLUE >>> 8, message);
			PearMarcelVistaMessage(string);
			format(string, sizeof(string), "[PDM-Chat] {%06x}%s:{%06x} %s", COLOR_YELLOW >>> 8,  PlayerName(playerid), COLOR_LIGHTBLUE >>> 8, message2);
			PearMarcelVistaMessage(string);
		}
		else
		{
			format(string, sizeof(string), "[PDM-Chat] {%06x}%s:{%06x} %s", COLOR_YELLOW >>> 8,  PlayerName(playerid), COLOR_LIGHTBLUE >>> 8, message);
			PearMarcelVistaMessage(string);
		}
	}
	return 1;
}

CMD:spawnplayer(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SPAWNPLAYER))
	{
		new targetid;
		new string[128];
	    if(sscanf(params, "u", targetid))
	    {
			SendClientMessage(playerid,COLOR_SYNTAX, "USAGE: /spawnplayer [ID]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		new vid = GetPlayerVehicleID(targetid);
		
		if(vid)
		{
		    new
				Float:x,
				Float:y,
				Float:z;
				
			//remove them without the animation
			GetVehiclePos(vid,x,y,z),
			SetPlayerPos(targetid,x,y,z);
		}
		SpawnPlayer(targetid);
		format(string, sizeof(string), "[INFO]: You have despawned %s", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[INFO]: You have been despawned by %s %s", GetPlayerStatus(playerid), PlayerName(playerid));
		SendClientMessage(targetid, COLOR_WHITE, string);
        format(string, sizeof(string), "AdmCmd(%d): %s %s despawned %s(%d)", ACMD_SPAWNPLAYER, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
		SendAdminMessage(ACMD_SPAWNPLAYER, string);
		AdminLog(string);
	}
	return 1;
}

CMD:vinfo(playerid,params[])
{
	if(IsAdmin(playerid, ACMD_VINFO))
	{
	    new vehid, string[128];
	    if(sscanf(params, "d", vehid))
	    {
  			format(string, sizeof(string), "[USAGE]: {%06x}/vinfo{%06x}[Veh-ID]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			return 1;
		}
		format(string, sizeof(string), "Local ID: [%d] - DB ID: [%d] - Model: [%d]", vehid, FoCo_Vehicles[vehid][cid], FoCo_Vehicles[vehid][cmodel]);
		SendClientMessage(playerid, COLOR_YELLOW, string);
        format(string, sizeof(string), "cSpawn X: [%f] - cSpawn Y: [%f] - cSpawn Z: [%f] - cSpawn A: [%f]",FoCo_Vehicles[vehid][cx],FoCo_Vehicles[vehid][cy],FoCo_Vehicles[vehid][cz],FoCo_Vehicles[vehid][cangle]);
        SendClientMessage(playerid, COLOR_YELLOW, string);
        format(string, sizeof(string), "Color1: [%d] - Color2: [%d] - Plate: [%s] - Owner: [%s] - Owner ID: [%d]",FoCo_Vehicles[vehid][ccol1],FoCo_Vehicles[vehid][ccol2],FoCo_Vehicles[vehid][cplate],FoCo_Vehicles[vehid][coname],FoCo_Vehicles[vehid][coid]);
        SendClientMessage(playerid, COLOR_YELLOW, string);
        format(string, sizeof(string), "Locked: [%d] - VWorld: [%d] - Interior: [%d] - Special_Mod: [%d]",FoCo_Vehicles[vehid][clocked],FoCo_Vehicles[vehid][cvw],FoCo_Vehicles[vehid][cint],FoCo_Vehicles[vehid][special_mod]);
        SendClientMessage(playerid, COLOR_YELLOW, string);
	}
	return 1;
}

CMD:toggleac(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_TOGGLEAC))
	{
		ShowPlayerDialog(playerid, DIALOG_TOGGLEAC, DIALOG_STYLE_LIST, "Toggle AC Notifications", GetAntiCheatNotificationList(), "Toggle", "Cancel");
	}
	return 1;
}
