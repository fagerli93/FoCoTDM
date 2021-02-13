#if !defined MAIN_INIT
#error "Compiling from wrong script. (foco.pwn)"
#endif

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

forward AJailPlayer(playerid, targetid, reason[], time, arecord);
forward AWarnPlayer(playerid, targetid, reason[], arecord);
forward AKickPlayer(playerid, targetid, reason[], arecord);
forward ABanPlayer(playerid, targetid, reason[], arecord);
forward ATempBanPlayer(playerid, targetid, reason[], days, arecord);
forward AntiCheatMessage(message[]);
forward DebugMsg(message[]);

forward SendErrorMessage(playerid, message[]);
forward IsPlayerLoggedIn(playerid);

forward SendClanMessage(cclan, color, message[]);

forward GetTeamSkin(cclan, rank);
forward GetPlayerClan(playerid);
forward GetPlayerClanRank(playerid);

forward IsDev(playerid, dev_level);
forward SetEventFFA(type);

forward Event_Currently_On();

forward AddPlayerHealth(playerid, Float:amount);
forward DialogLog(msg[]);

forward IsValidPlayerID(playerid, targetid);

