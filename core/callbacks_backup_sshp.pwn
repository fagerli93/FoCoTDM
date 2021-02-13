#if !defined MAIN_INIT
#error "Compiling from wrong script. (foco.pwn)"
#endif

public OnGameModeInit()
{
    SetGameModeText("FoCo TDM V4 | Rev: 997");
	AntiDeAMX();
	Saving_Connect();
	CreateObjects();

	ShowPlayerMarkers(1);
    EnableStuntBonusForAll(0);
    DisableInteriorEnterExits();
    AllowInteriorWeapons(1);
    
   	//SetTimer("OneSecondTimer", 1000, true);
	SetTimer("TenMinuteTimer", 600000, true);
	//SetTimer("OneMinuteTimer", 60000, true);
	//SetTimer("AimbotCheck", 1000, true);

	new string[64];
	format(string, 64, "SERVER RESTARTED AT : %s", TimeStamp());
	notes(string);
	
	starttime = gettime();

    mysql_query("UPDATE `FoCo_Players` SET `online`= '0'", MYSQL_SET_ONLINE_DEFAULT, con);
	mysql_query("SELECT * FROM `FoCo_Teams` ORDER BY `ID` ASC");
	mysql_query("SELECT * FROM FoCo_Groups", MYSQL_LOADGROUPS, 0, con);
	LoadTeams();
	#if defined BIGDRULESCMD
	LoadRules();
	#endif
	
	foreach (FoCoTeams, teamid)
	{
		if(FoCo_Teams[teamid][team_type] == 1)
		{
			FoCo_Teams[teamid][team_class] = AddPlayerClass(FoCo_Teams[teamid][team_skin_1], FoCo_Teams[teamid][team_spawn_x], FoCo_Teams[teamid][team_spawn_y], FoCo_Teams[teamid][team_spawn_z], 0.0, 0, 0, 0, 0, 0, 0);
		}
		else
		{
			FoCo_Teams[teamid][team_class] = -1;
		}
	}
	
	clanselectid = AddPlayerClass(0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	mysql_free_result();
	
	LoadScript();
	/*
	* Textdraw Creation
	*/

	FoCoTDMTD = TextDrawCreate(592.000000, 20.000000, "~r~F~w~o~r~C~w~o~n~~r~~h~~h~TDM");
	TextDrawAlignment(FoCoTDMTD, 3);
	TextDrawBackgroundColor(FoCoTDMTD, 255);
	TextDrawFont(FoCoTDMTD, 2);
	TextDrawLetterSize(FoCoTDMTD, 0.400000, 1.300000);
	TextDrawColor(FoCoTDMTD, -1);
	TextDrawSetOutline(FoCoTDMTD, 1);
	TextDrawSetProportional(FoCoTDMTD, 1);

	AchieveBoxTD = TextDrawCreate(310.000000, 342.000000, "~n~~n~~n~");
	TextDrawAlignment(AchieveBoxTD, 2);
	TextDrawBackgroundColor(AchieveBoxTD, 255);
	TextDrawFont(AchieveBoxTD, 1);
	TextDrawLetterSize(AchieveBoxTD, 0.500000, 1.000000);
	TextDrawColor(AchieveBoxTD, -1);
	TextDrawSetOutline(AchieveBoxTD, 0);
	TextDrawSetProportional(AchieveBoxTD, 1);
	TextDrawSetShadow(AchieveBoxTD, 1);
	TextDrawUseBox(AchieveBoxTD, 1);
	TextDrawBoxColor(AchieveBoxTD, 200);
	TextDrawTextSize(AchieveBoxTD, 100.000000, -182.000000);

	AchieveAqcTD = TextDrawCreate(323.000000, 344.000000, "~r~A~w~chievement ~r~A~w~cquired~r~!");
	TextDrawAlignment(AchieveAqcTD, 2);
	TextDrawBackgroundColor(AchieveAqcTD, 255);
	TextDrawFont(AchieveAqcTD, 3);
	TextDrawLetterSize(AchieveAqcTD, 0.370000, 1.000000);
	TextDrawColor(AchieveAqcTD, -1);
	TextDrawSetOutline(AchieveAqcTD, 0);
	TextDrawSetProportional(AchieveAqcTD, 1);
	TextDrawSetShadow(AchieveAqcTD, 1);
	TextDrawUseBox(AchieveAqcTD, 1);
	TextDrawBoxColor(AchieveFoCoTD, -156);
	TextDrawTextSize(AchieveAqcTD, 30.000000, 142.000000);

	AchieveFoCoTD = TextDrawCreate(236.000000, 346.000000, "~r~F~w~o~n~C~r~o");
	TextDrawAlignment(AchieveFoCoTD, 2);
	TextDrawBackgroundColor(AchieveFoCoTD, 255);
	TextDrawFont(AchieveFoCoTD, 2);
	TextDrawLetterSize(AchieveFoCoTD, 0.390000, 1.000000);
	TextDrawColor(AchieveFoCoTD, -1);
	TextDrawSetOutline(AchieveFoCoTD, 0);
	TextDrawSetProportional(AchieveFoCoTD, 1);
	TextDrawSetShadow(AchieveFoCoTD, 1);
	TextDrawUseBox(AchieveFoCoTD, 1);
	TextDrawBoxColor(AchieveFoCoTD, -156);
	TextDrawTextSize(AchieveFoCoTD, 256.000000, 22.000000);

	
	for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
	{
		FailedLoginAttempts[playerid] = 0;	// 
		MoneyDeathTD[playerid] = TextDrawCreate(610.000000, 100.000000, "~w~-~r~600");
	    TextDrawAlignment(MoneyDeathTD[playerid], 3);
		TextDrawBackgroundColor(MoneyDeathTD[playerid], 255);
		TextDrawFont(MoneyDeathTD[playerid], 2);
		TextDrawLetterSize(MoneyDeathTD[playerid], 0.400000, 1.300000);
		TextDrawColor(MoneyDeathTD[playerid], -1);
		TextDrawSetOutline(MoneyDeathTD[playerid], 1);
		TextDrawSetProportional(MoneyDeathTD[playerid], 1);
		
		MoneyDeathVIPTD[playerid] = TextDrawCreate(610.000000, 115.000000, "~w~-~r~600");
	    TextDrawAlignment(MoneyDeathVIPTD[playerid], 3);
		TextDrawBackgroundColor(MoneyDeathVIPTD[playerid], 255);
		TextDrawFont(MoneyDeathVIPTD[playerid], 2);
		TextDrawLetterSize(MoneyDeathVIPTD[playerid], 0.400000, 1.300000);
		TextDrawColor(MoneyDeathVIPTD[playerid], -1);
		TextDrawSetOutline(MoneyDeathVIPTD[playerid], 1);
		TextDrawSetProportional(MoneyDeathVIPTD[playerid], 1);
		
		AchieveInfoTD[playerid] = TextDrawCreate(322.000000, 355.000000, "~r~K~w~ill 10 enemies in a single life!~n~~r~+~w~10score");
		TextDrawAlignment(AchieveInfoTD[playerid], 2);
		TextDrawBackgroundColor(AchieveInfoTD[playerid], 255);
		TextDrawFont(AchieveInfoTD[playerid], 2);
		TextDrawLetterSize(AchieveInfoTD[playerid], 0.200000, 0.699999);
		TextDrawColor(AchieveInfoTD[playerid], -1);
		TextDrawSetOutline(AchieveInfoTD[playerid], 0);
		TextDrawSetProportional(AchieveInfoTD[playerid], 1);
		TextDrawSetShadow(AchieveInfoTD[playerid], 1);

		SelectionTD[playerid] = TextDrawCreate(328.000000, 381.000000, "~r~<< ~w~ItemName~r~>>~n~Extra Info");
		TextDrawAlignment(SelectionTD[playerid], 2);
		TextDrawBackgroundColor(SelectionTD[playerid], 255);
		TextDrawFont(SelectionTD[playerid], 2);
		TextDrawLetterSize(SelectionTD[playerid], 0.619999, 2.200000);
		TextDrawSetOutline(SelectionTD[playerid], 1);
		TextDrawSetProportional(SelectionTD[playerid], 1);//Centered for each resolution

		Blackout3[playerid] = TextDrawCreate(197.000000, 185.000000, "Select a Clan");
		TextDrawAlignment(Blackout3[playerid], 2);
		TextDrawBackgroundColor(Blackout3[playerid], 255);
		TextDrawFont(Blackout3[playerid], 2);
		TextDrawLetterSize(Blackout3[playerid], 0.490000, 2.000000);
		TextDrawColor(Blackout3[playerid], -1);
		TextDrawSetOutline(Blackout3[playerid], 1);
		TextDrawSetProportional(Blackout3[playerid], 1);

		// Create the textdraws:
		CurrLeader[playerid] = TextDrawCreate(283.000000, 400.000000, "Current Leader");
		TextDrawAlignment(CurrLeader[playerid], 3);
		TextDrawBackgroundColor(CurrLeader[playerid], 255);
		TextDrawFont(CurrLeader[playerid], 3);
		TextDrawLetterSize(CurrLeader[playerid], 0.500000, 1.000000);
		TextDrawColor(CurrLeader[playerid], -1);
		TextDrawSetOutline(CurrLeader[playerid], 1);
		TextDrawSetProportional(CurrLeader[playerid], 1);

		CurrLeaderName[playerid] = TextDrawCreate(291.000000, 414.000000, " ");
		TextDrawAlignment(CurrLeaderName[playerid], 3);
		TextDrawBackgroundColor(CurrLeaderName[playerid], 255);
		TextDrawFont(CurrLeaderName[playerid], 3);
		TextDrawLetterSize(CurrLeaderName[playerid], 0.400000, 0.899999);
		TextDrawColor(CurrLeaderName[playerid], 16777215);
		TextDrawSetOutline(CurrLeaderName[playerid], 1);
		TextDrawSetProportional(CurrLeaderName[playerid], 1);

		GunGame_MyKills[playerid] = TextDrawCreate(630.000000, 414.000000, " ");
		TextDrawAlignment(GunGame_MyKills[playerid], 3);
		TextDrawBackgroundColor(GunGame_MyKills[playerid], 255);
		TextDrawFont(GunGame_MyKills[playerid], 3);
		TextDrawLetterSize(GunGame_MyKills[playerid], 0.400000, 0.899999);
		TextDrawColor(GunGame_MyKills[playerid], 16777215);
		TextDrawSetOutline(GunGame_MyKills[playerid], 1);
		TextDrawSetProportional(GunGame_MyKills[playerid], 1);

		GunGame_Weapon[playerid] = TextDrawCreate(620.000000, 400.000000, " ");
		TextDrawAlignment(GunGame_Weapon[playerid], 3);
		TextDrawBackgroundColor(GunGame_Weapon[playerid], 255);
		TextDrawFont(GunGame_Weapon[playerid], 3);
		TextDrawLetterSize(GunGame_Weapon[playerid], 0.500000, 1.000000);
		TextDrawColor(GunGame_Weapon[playerid], -1);
		TextDrawSetOutline(GunGame_Weapon[playerid], 1);
		TextDrawSetProportional(GunGame_Weapon[playerid], 1);

		KillTD[playerid] = TextDrawCreate(330.000000, 422.000000, " ");
		TextDrawAlignment(KillTD[playerid], 2);
		TextDrawBackgroundColor(KillTD[playerid], 255);
		TextDrawFont(KillTD[playerid], 2);
		TextDrawLetterSize(KillTD[playerid], 0.260000, 1.000000);
		TextDrawColor(KillTD[playerid], 16777215);
		TextDrawSetOutline(KillTD[playerid], 1);
		TextDrawSetProportional(KillTD[playerid], 1);

		ClanOneTD[playerid] = TextDrawCreate(630.000000, 389.000000, " ");
		TextDrawAlignment(ClanOneTD[playerid], 3);
		TextDrawBackgroundColor(ClanOneTD[playerid], 255);
		TextDrawFont(ClanOneTD[playerid], 2);
		TextDrawLetterSize(ClanOneTD[playerid], 0.360000, 1.000000);
		TextDrawColor(ClanOneTD[playerid], -16776961);
		TextDrawSetOutline(ClanOneTD[playerid], 1);
		TextDrawSetProportional(ClanOneTD[playerid], 1);

		ClanTwoTD[playerid] = TextDrawCreate(630.000000, 401.000000, " ");
		TextDrawAlignment(ClanTwoTD[playerid], 3);
		TextDrawBackgroundColor(ClanTwoTD[playerid], 255);
		TextDrawFont(ClanTwoTD[playerid], 2);
		TextDrawLetterSize(ClanTwoTD[playerid], 0.360000, 1.000000);
		TextDrawColor(ClanTwoTD[playerid], -16776961);
		TextDrawSetOutline(ClanTwoTD[playerid], 1);
		TextDrawSetProportional(ClanTwoTD[playerid], 1);
		afkTimer[playerid] = -1;

	}
	
	event_OnGameModeInit();

	CW_ScoreTD = TextDrawCreate(595.000000, 375.000000, "SCORES");
	TextDrawAlignment(CW_ScoreTD, 3);
	TextDrawBackgroundColor(CW_ScoreTD, 255);
	TextDrawFont(CW_ScoreTD, 1);
	TextDrawLetterSize(CW_ScoreTD, 0.310000, 1.000000);
	TextDrawColor(CW_ScoreTD, -1);
	TextDrawSetOutline(CW_ScoreTD, 1);
	TextDrawSetProportional(CW_ScoreTD, 1);

	// IG Channel
	gBotID[0] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_1_NICKNAME, BOT_1_REALNAME, BOT_1_USERNAME);
//	IRC_SetIntData(gBotID[0], E_IRC_CONNECT_DELAY, 3);
	gBotID[1] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_2_NICKNAME, BOT_2_REALNAME, BOT_2_USERNAME);
//	IRC_SetIntData(gBotID[1], E_IRC_CONNECT_DELAY, 6);
	gBotID[2] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_3_NICKNAME, BOT_3_REALNAME, BOT_3_USERNAME);
//	IRC_SetIntData(gBotID[2], E_IRC_CONNECT_DELAY, 9);
	gMain = IRC_CreateGroup();

	// Echo channel
	gBotID[3] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_4_NICKNAME, BOT_4_REALNAME, BOT_4_USERNAME);
//	IRC_SetIntData(gBotID[3], E_IRC_CONNECT_DELAY, 12);
	gBotID[4] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_5_NICKNAME, BOT_5_REALNAME, BOT_5_USERNAME);
//	IRC_SetIntData(gBotID[4], E_IRC_CONNECT_DELAY, 15);
	gBotID[5] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_6_NICKNAME, BOT_6_REALNAME, BOT_6_USERNAME);
//	IRC_SetIntData(gBotID[5], E_IRC_CONNECT_DELAY, 18);
	gEcho = IRC_CreateGroup();

	// Leads Channel
	gBotID[6] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_7_NICKNAME, BOT_7_REALNAME, BOT_7_USERNAME);
//	IRC_SetIntData(gBotID[6], E_IRC_CONNECT_DELAY, 21);
	gBotID[7] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_8_NICKNAME, BOT_8_REALNAME, BOT_8_USERNAME);
//	IRC_SetIntData(gBotID[7], E_IRC_CONNECT_DELAY, 23);
	gBotID[8] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_9_NICKNAME, BOT_9_REALNAME, BOT_9_USERNAME);
//	IRC_SetIntData(gBotID[8], E_IRC_CONNECT_DELAY, 26);
	gLeads = IRC_CreateGroup();

	// Admin Channel
	gBotID[9] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_10_NICKNAME, BOT_10_REALNAME, BOT_10_USERNAME);
//	IRC_SetIntData(gBotID[9], E_IRC_CONNECT_DELAY, 29);
	gBotID[10] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_11_NICKNAME, BOT_11_REALNAME, BOT_11_USERNAME);
//	IRC_SetIntData(gBotID[10], E_IRC_CONNECT_DELAY, 32);
	gAdmin = IRC_CreateGroup();
	gBotID[11] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_12_NICKNAME, BOT_12_REALNAME, BOT_12_USERNAME);
	gBotID[12] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_13_NICKNAME, BOT_13_REALNAME, BOT_13_USERNAME);
	gTRAdmin = IRC_CreateGroup();
	BotsConnected = 1;
	Event_ID = -1;          // To allow for autojoining, otherwise will bug up before any events are started.
	new k;
	for(k = 0; k <= 99; k++)
	{
		ClanSkinSwitch[k] = 0;
	}
	return 1;
}

public OnGameModeExit()
{
	foreach(Player, i)
	{
		TextDrawHideForAll(CurrLeader[i]);
		TextDrawDestroy(CurrLeader[i]);
		TextDrawHideForAll(CurrLeaderName[i]);
		TextDrawDestroy(CurrLeaderName[i]);
		TextDrawHideForAll(GunGame_MyKills[i]);
		TextDrawDestroy(GunGame_MyKills[i]);
		TextDrawHideForAll(GunGame_Weapon[i]);
		TextDrawDestroy(GunGame_Weapon[i]);
		TextDrawHideForAll(KillTD[i]);
		TextDrawDestroy(KillTD[i]);
		TextDrawHideForAll(ClanOneTD[i]);
		TextDrawDestroy(ClanOneTD[i]);
		TextDrawHideForAll(ClanTwoTD[i]);
		TextDrawDestroy(ClanTwoTD[i]);
		TextDrawHideForAll(CW_ScoreTD);
		TextDrawDestroy(CW_ScoreTD);
	}
	IRC_Quit(gBotID[0], "Mow's Fault");
	IRC_Quit(gBotID[1], "Aero's Fault");
	IRC_Quit(gBotID[2], "Shaney's Fault");
	IRC_Quit(gBotID[3], "Khronos's Fault");
	IRC_Quit(gBotID[4], "amef's Fault");
	IRC_Quit(gBotID[5], "krisk's Fault");
	IRC_Quit(gBotID[6], "Garteus's Fault");
	IRC_Quit(gBotID[7], "Schleich's Fault");
	IRC_Quit(gBotID[8], "Shaney's Fault");
	IRC_Quit(gBotID[9], "Marcel's Fault");
	IRC_Quit(gBotID[10], "Simon's Fault");
	IRC_DestroyGroup(gEcho);
	IRC_DestroyGroup(gLeads);
	IRC_DestroyGroup(gMain);
	IRC_DestroyGroup(gAdmin);
	BotsConnected = 0;
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(gPlayerLogged[playerid] == 0) {
		SetPVarInt(playerid, "DisAllowSpawn", 1);
	}
	TextDrawShowForPlayer(playerid, Blackout3[playerid]);
	new playerteam;
	foreach(FoCoTeams, teamid)
	{
		if(FoCo_Team[playerid] == FoCo_Teams[teamid][team_members])
		{
			playerteam = teamid;
			FoCo_Teams[playerteam][team_members] ++;
		}
	}
	if(playerteam == 65535)
	{
		FoCo_Teams[playerteam][team_members] --;
	}
	new string[128];
	SetPlayerVirtualWorld(playerid,0);
	SetPlayerInterior(playerid,0);
	SetPlayerPos(playerid, 1834.6666,-1289.1736,49.4453);
	SetPlayerFacingAngle(playerid, 130.3488);
	SetPlayerCameraPos(playerid, 1829.6870,-1293.9259,52.1049);
	SetPlayerCameraLookAt(playerid, 1834.7651,-1286.7142,49.4453);

	foreach (FoCoTeams, teamid)
	{
		if(classid == FoCo_Teams[teamid][team_class] && FoCo_Teams[teamid][team_class] != -1 && FoCo_Teams[teamid][team_type] == 1)
		{
			if((GetAverageTeamMembers() + 2) < GetTeamMemberCount(FoCo_Teams[teamid][db_id])) {
				TextDrawSetString(Blackout3[playerid], "~w~-- This team is FULL. --");
				SetPVarInt(playerid, "DisAllowSpawn", 1);
			} else {
				format(string, sizeof(string), "~w~%s", FoCo_Teams[teamid][team_name]);
				TextDrawSetString(Blackout3[playerid], string);
				FoCo_Team[playerid] = FoCo_Teams[teamid][db_id];
				FoCo_Teams[teamid][team_members] ++;
				SetPlayerColor(playerid, hexstr(FoCo_Teams[teamid][team_color]));
				SetPVarInt(playerid, "DisAllowSpawn", 0);
			}
			return 1;
		}
	}
	if(classid == clanselectid)
	{
		if(FoCo_Player[playerid][clan] != -1)
		{
			format(string, sizeof(string), "~r~%s", FoCo_Teams[FoCo_Player[playerid][clan]][team_name]);
			TextDrawSetString(Blackout3[playerid], string);
			FoCo_Team[playerid] = FoCo_Teams[FoCo_Player[playerid][clan]][db_id];
			SetPlayerColor(playerid, hexstr(FoCo_Teams[FoCo_Player[playerid][clan]][team_color]));
			SetPVarInt(playerid, "DisAllowSpawn", 0);
			return 1;
		}
		format(string, sizeof(string), "~w~You are not in a clan");
		TextDrawSetString(Blackout3[playerid], string);
		SetPVarInt(playerid, "DisAllowSpawn", 1);
		return 1;
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	ban_handler(playerid);
	IsPlayerAuthenticated[playerid] = true; //To avoid it from blocking level0 players in OnPLayerRequestSpawn.
	event_OnPlayerConnect(playerid);
	FoCo_Player[playerid][cash] = 0;
	OnPlayerDisconnectMsg[playerid] = 0;
	OnPlayerDeathMsg[playerid] = 0;
	AdvStrike[playerid]=0; // ADded by Rak
	noname[playerid] = 0;
	
	ConLog[playerid] = 0;

	for(new i = 0; i < MAX_BLOCK; i++) //Empty the PM Block array for a new player connecting!
    {
		PeopleBlocking[playerid][i] = INVALID_PLAYER_ID;
	}
	FoCo_Player[playerid][users_carid] = -1;
	spawnSeconds[playerid] = -1;
	isAFK[playerid] = -1;
	afkHP[playerid] = -1;
	afkArmour[playerid] = -1;
	CurrentKillStreak[playerid] = 0;
	CurrentDeathStreak[playerid] = 0;
	Event_Kills[playerid] = -1;
	AutoJoin[playerid] = 0;
	SetPVarInt(playerid, "PlayerStatus", 0);        // Bug fix, kthxbye
	
	ClearTransVars(playerid);

	gPlayerUsingLoopingAnim[playerid] = 0;
	gPlayerAnimLibsPreloaded[playerid] = 0;

	antifall[playerid] = 0;
	antifallveh[playerid] = -1;
	antifallcheck[playerid] = 0;
	healAmount[playerid] = 0;

	FoCo_Player[playerid][onlinetime] = 0;
	FoCo_Player[playerid][admintime] = 0;
	specHP[playerid] = -1;
	specArmour[playerid] = -1;

//	pObject[playerid][slotreserved] = false;
//	pObject[playerid][omodel] = 0;

	wepObjEnable[playerid] = true;

	lastKiller[playerid] = -1;
	IsLastKillTK[playerid] = -1;

	FoCo_Classes[playerid][fc_melee] = 0;
	FoCo_Classes[playerid][fc_handguns] = 0;
	FoCo_Classes[playerid][fc_shotguns] = 0;
	FoCo_Classes[playerid][fc_submachine] = 0;
	FoCo_Classes[playerid][fc_assault] = 0;
	FoCo_Classes[playerid][fc_rifle] = 0;

	RemoveBuildingForPlayer(playerid, 1412, 1917.3203, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1912.0547, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1906.7734, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1927.8516, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1922.5859, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1938.3906, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1933.1250, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1948.9844, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1943.6875, -1797.4219, 13.8125, 0.25);

	RemoveBuildingForPlayer(playerid, 1302, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1209, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 955, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 956, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1775, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1776, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1977, 0.0, 0.0, 0.0, 6000.0); // sprunk machines

    RemoveBuildingForPlayer(playerid, 5357, 2177.9922, -2006.7578, 23.2891, 1.0);
	RemoveBuildingForPlayer(playerid, 5291, 2177.9922, -2006.7578, 23.2891, 1.0); // Requested by Dr_Death
	
	// For testing
	RemoveBuildingForPlayer(playerid, 700, 196.3438, -131.0313, 1.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 781, 164.7266, -130.1953, 0.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 781, 175.6250, -82.8125, 0.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 1351, 221.5156, -27.6953, 0.4609, 0.25);
	// .
	RemoveBuildingForPlayer(playerid, 785, -387.3672, -97.3594, 43.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 694, -616.1719, -156.0547, 74.4453, 0.25);
	// .
	RemoveBuildingForPlayer(playerid, 3869, -2116.6797, 131.0078, 42.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3866, -2116.6797, 131.0078, 42.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3872, -2064.2109, 210.1406, 41.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 3864, -2059.3438, 205.5313, 40.4688, 0.25);
	//.
	RemoveBuildingForPlayer(playerid, 3425, -466.4297, 2190.2734, 55.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 16054, -427.7734, 2238.2578, 44.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 3350, -429.0547, 2237.8359, 41.2109, 0.25);
	// .
	RemoveBuildingForPlayer(playerid, 1351, 2304.3438, 97.0781, 25.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 2232.8203, -89.4219, 29.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 2335.3750, -89.4766, 29.8125, 0.25);
	// Testing end

	hitSound[playerid] = true;
	justConnected[playerid] = 1;
	aUndercover[playerid] = 0;
	SetPVarInt(playerid, "SecretSpec", -1);
	FoCo_Team[playerid] = 65535;
	surfdeath[playerid] = -1;
	vehtimerspawning[playerid] = 0;
	death[playerid] = 1;
	ResetStats(playerid);
	//Saving_PlayerConnect(playerid); This was moved to continue, as otherwise it will show stuff to players that are banned..
	TextDrawShowForPlayer(playerid, FoCoTDMTD);
	Spectated[playerid] = -1;
	Spectating[playerid] = -1;
	WatchPMAdmin[playerid] = -1;
	SetPVarInt(playerid, "TogMainChat", -1);
	pmwarned[playerid] = 0;
	camera[playerid] = 0;
	return 1;
}
forward continue_OnPlayerConnect(playerid);
public continue_OnPlayerConnect(playerid)
{
	Saving_PlayerConnect(playerid);
	SendClientMessage(playerid, COLOR_RED, "[INFO] If the login box does not appear, use /login !!!");
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	FailedLoginAttempts[playerid] = 0;
	new string[128];
    FoCo_Disconnection(playerid);
	DataSave(playerid);
    nullvip(playerid);
    specHP[playerid] = -1;
	specArmour[playerid] = -1;
	afkHP[playerid] = -1;
	afkArmour[playerid] = -1;
	isAFK[playerid] = -1;
	afkHP[playerid] = -1;
	afkArmour[playerid] = -1;
	LastPMID[playerid] = -1;
	RconAttempt[playerid] = 0;
	canAFK[playerid] = 1;
	afkTimer[playerid] = -1;
	TextDrawHideForPlayer(playerid, CurrLeader[playerid]);
	TextDrawHideForPlayer(playerid, CurrLeaderName[playerid]);
	TextDrawHideForPlayer(playerid, GunGame_MyKills[playerid]);
	TextDrawHideForPlayer(playerid, GunGame_Weapon[playerid]);
	TextDrawSetString(KillTD[playerid], " ");
	TextDrawHideForPlayer(playerid, KillTD[playerid]);
	TextDrawHideForPlayer(playerid, ClanTwoTD[playerid]);
	TextDrawHideForPlayer(playerid, ClanOneTD[playerid]);
	TextDrawHideForPlayer(playerid, CW_ScoreTD);

	if(gPlayerLogged[playerid] == 1)
    {
		DeleteAllAttachedWeapons(playerid);
		DataSave(playerid);
		AchievementSave(playerid);
		DuelSave(playerid);
		SavePlayerStatsInfo(playerid);
		FoCo_Player[playerid][duels_won] = 0;
		FoCo_Player[playerid][duels_lost] = 0;

		ClanWar_Clan[playerid] = 0;
		ClanWar_Members[playerid] = 0;
		ClanWar_Package[playerid] = 0;
		ClanWar_Joining[playerid] = 0;
	}
	if(GetPVarInt(playerid, "PlayerStatus") == 3)
	{
		KillTimer(afkTimer[playerid]);
	}
	if(ManHuntID == playerid)
	{
		ManHuntID = -1;
		ManHuntSeconds = 0;
 	}
	if(trans[playerid] == 1)
	{
		DestroyVehicle(transveh[playerid]);
		trans[playerid] = 0;
		transveh[playerid] = -1;
		transslot[playerid] = -1;
	}
	lastKiller[playerid] = -1;

	KillTimer(deathSpec[playerid]);
	ClearTransVars(playerid);
	ClanWar_Trial[playerid] = 0;

	spawnSeconds[playerid] = -1;
	healAmount[playerid] = 0;
	OnlineTimer[playerid] = 0;
	AdutyTimer[playerid] = 0;
	Spawned[playerid] = 0;
	antifall[playerid] = 0;
	antifallveh[playerid] = -1;
	antifallcheck[playerid] = 0;
	NitrousBoostEn[playerid] = 0;
	//PursuitTimer = 0;
	
	afkX[playerid] = 0.0;
	afkY[playerid] = 0.0;
	afkZ[playerid] = 0.0;
	lastHit[playerid] = 0;
	clanCheck[playerid] = 0;
	carSQLCol[playerid] = 0;
	
	ModInteruptSave(playerid);
	TextDrawHideForPlayer(playerid, MoneyDeathTD[playerid]);
	TextDrawHideForPlayer(playerid, FoCoTDMTD);
	TextDrawHideForPlayer(playerid, AchieveBoxTD);
	TextDrawHideForPlayer(playerid, AchieveInfoTD[playerid]);
	TextDrawHideForPlayer(playerid, AchieveAqcTD);
	TextDrawHideForPlayer(playerid, AchieveFoCoTD);
	new leaveMsg[128], name[MAX_PLAYER_NAME], reasonMsg[8];
	switch(reason)
	{
		case 0: reasonMsg = "Timeout";
		case 1: reasonMsg = "Leaving";
		case 2: reasonMsg = "Kicked";
	}
	GetPlayerName(playerid, name, sizeof(name));
	format(leaveMsg, sizeof(leaveMsg), "3[DISCONNECTION]: %d %s left the server (%s) IP: %s", playerid, name, reasonMsg, ipstring[playerid]);
	IRC_GroupSay(gEcho, IRC_FOCO_ECHO, leaveMsg);
	format(leaveMsg, sizeof(leaveMsg), "[DISCONNECTION]: %d %s left the server (%s)", playerid, name, reasonMsg);
	ConnectionLog(leaveMsg);
	format(leaveMsg, sizeof(leaveMsg), "%s has disconnected. (%s) ({%06x}IP: %s{%06x})", PlayerName(playerid), reasonMsg, COLOR_GLOBALNOTICE >>> 8, ipstring[playerid], COLOR_SYNTAX >>> 8);
	foreach(new i : Player)
	{
		if(ConLog[i])
		{
			SendClientMessage(i, COLOR_SYNTAX, leaveMsg);
		}
		if(lastKiller[i] == playerid)
		{
			lastKiller[i] = -1;
		}
	}
	if(Spectated[playerid] != -1)
	{
		TogglePlayerSpectating(Spectated[playerid], 0);
		Spectating[Spectated[playerid]] = -1;
		Spectated[playerid] = -1;
	}
	if(Spectating[playerid] != -1)
	{
		if(FoCo_Player[playerid][admin] > 0)
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
			{
				Spectating[playerid] = -1;
				Spectated[Spectating[playerid]] = -1;
			}
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i++) // Remove a player from everybody's blocklist when he disconnects!
 	{
    	for(new z = 0; z < MAX_BLOCK; z++)
        {
        	if(PeopleBlocking[i][z] == playerid)
            {
            	PeopleBlocking[i][z] = INVALID_PLAYER_ID;
            }
         }
	}
	new Float:x, Float:y, Float:z, Float:Health, Float:Armour;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerHealth(playerid, Health);
	GetPlayerArmour(playerid, Armour);
	new timeHours, timeMinutes;
	gettime(timeHours, timeMinutes);
	foreach(Player, i)
	{
	    if(IsPlayerInRangeOfPoint(i, 30, x, y, z))
	    {
	        if(reason == 0)
	        {
	            format(string, sizeof(string), "[INFO]: %s(%d) timed out. (HP: %.1f, A: %.1f, T: %d:%d)", PlayerName(playerid), playerid, Health, Armour, timeHours, timeMinutes);
				SendClientMessage(i, COLOR_SYNTAX, string);
	        }
	        else if(reason == 1)
	        {
	            format(string, sizeof(string), "[INFO]: %s(%d) has disconnected. (HP: %.1f, A: %.1f, T: %d:%d)", PlayerName(playerid), playerid, Health, Armour, timeHours, timeMinutes);
				SendClientMessage(i, COLOR_SYNTAX, string);
	        }
	        else
			{
	            format(string, sizeof(string), "[INFO]: %s(%d) was kicked. (HP: %.1f, A: %.1f, T: %d:%d)", PlayerName(playerid), playerid, Health, Armour, timeHours, timeMinutes);
				SendClientMessage(i, COLOR_SYNTAX, string);
	        }
			
	    }
	}
	WatchGAdmin[playerid] = -1;
	FoCo_Player[playerid][clan] = -1; // To fix the bug reported by chilco (relog on another acc, be in a clan which you actually wouldnt be in?)
	// Bug fix to avoid shitty ahide shit.
	if(ahide[playerid] == 1)
	{
        ahide[playerid] = 0;
	}
	// Avoid bug
	if(WatchPMAdmin[playerid] != -1)
	{
	    WatchPMAdmin[playerid] = -1;
	}
	if(WatchGAdmin[playerid] != -1)
	{
	    WatchGAdmin[playerid] = -1;
	}
	event_OnPlayerDisconnect(playerid, reason);
	SetPVarInt(playerid, "PlayerStatus", 0);
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(ADuty[playerid])	return 1;
	
	lastHit[playerid] = GetUnixTime();
	if(issuerid != INVALID_PLAYER_ID)
	{
		if(hitSound[issuerid] == true && weaponid != 0 && weaponid != 37 && death[playerid] == 0)
		{
			PlayerPlaySound(issuerid,17802,0.0,0.0,0.0);
		}
	}
	if(afkTimer[playerid] != -1)
	{
		KillTimer(afkTimer[playerid]);
		afkTimer[playerid] = -1;
		SetPVarInt(playerid, "PlayerStatus", 0);
		afkHP[playerid] = -1;
		afkArmour[playerid] = -1;
		isAFK[playerid] = -1;
		canAFK[playerid] = 1;
		SendClientMessage(playerid, COLOR_NOTICE, "[AFK Notice]: You cannot go AFK as the 15 second timer had not finished before you took damage.");
	}
	AC_OnPlayerTakeDamage(playerid, issuerid, amount, weaponid, bodypart); //DR_VISTA ANTI_CHEAT CALL
	new Float:weapon_damage = 0.0, Float:overall;
	overall = amount;
	switch(weaponid)
	{
		case WEAPON_COLT45:
		{
			weapon_damage = amount * 0.10;
			overall = weapon_damage + amount;
		}
		case WEAPON_SILENCED:
		{
			weapon_damage = amount * 0.15;
			overall = weapon_damage + amount;
		}
		case WEAPON_SAWEDOFF:
		{
			weapon_damage = amount * -0.25;
			overall = amount + weapon_damage;
		}
		case WEAPON_SHOTGSPA:
		{
			weapon_damage = amount * -0.25;
			overall = amount + weapon_damage;
		}
		/*case WEAPON_UZI:
		{
			weapon_damage = amount * 0.10;
			overall = weapon_damage + amount;
		}
		case WEAPON_TEC9:
		{
			weapon_damage = amount * 0.10;
			overall = weapon_damage + amount;
		}*/
		/*
		case WEAPON_SNIPER:
		{
			weapon_damage = amount * 0.35;
			overall = weapon_damage + amount;
		}
		*/
		case WEAPON_RIFLE:
		{
			weapon_damage = amount * 0.65;
			overall = weapon_damage + amount;
		}
		case WEAPON_AK47:
		{
			weapon_damage = amount * 0.15;
			overall = weapon_damage + amount;
		}
		case WEAPON_MP5:
		{
			weapon_damage = amount * 0.15;
			overall = weapon_damage + amount;
		}
	}
	if(GetPVarInt(issuerid, "ExtraDamage") == 1) // Turf-Sys Perk +5% damage
	{
		overall = overall + (overall * 0.05);
	}
	takeDamageMath(playerid, issuerid, overall, weaponid, weapon_damage);
	giveDamageMath(playerid, issuerid, overall, weaponid, weapon_damage);
	
	return 1;
}

public OnPlayerSpawn(playerid)
{
	LoginCMDVar[playerid] = 0;
	if(justConnected[playerid] == 1)
	{
	    SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: If you need help, you can use /helpme <question>");
	}
	if(FoCo_Playerstats[playerid][kills] <= 2000)
	{
	    GameTextForPlayer(playerid, "~g~Use /class for weapons!", 3000, 1);
	}
	if(FoCo_Playerstats[playerid][kills] <= 10 && justConnected[playerid] == 1)
	{
	    ShowPlayerDialog(playerid,DIALOG_RULES,DIALOG_STYLE_MSGBOX,"Rules",rules_text,"Close","");
	}
	if(strlen(MessageOfTheDay) > 5 && justConnected[playerid] == 1)
	{
		ShowPlayerDialog(playerid, DIALOG_MOTD, DIALOG_STYLE_MSGBOX, "Message of the Day", MessageOfTheDay, "Ok", "Close");
		FoCo_Event_Died[playerid] = 0;
	}
	if(justConnected[playerid] == 1)
	{
		ShowPlayerDialog(playerid, DIALOG_CLASS_TOOLS, DIALOG_STYLE_LIST, "Class Tools", "1) Change Class\n2) Edit Class", "Select", "Close");
	}

	if(event_OnPlayerSpawn(playerid) == 2)
	{
		return 1;
	}
	if(AdminLvl(playerid) > 0)
	{
	    if(specHP[playerid] != -1)
	    {
	        if(specHP[playerid] < 99)
	        {
	            new string[256];
		        format(string, sizeof(string), "[INFO]: Your health has been set to %d and your armour has been set to %d due to speccing before spawn.",specHP[playerid],specArmour[playerid]);
		    	SendClientMessage(playerid, COLOR_GREEN, string);
	        }
	        
	        SetPlayerHealth(playerid, specHP[playerid]);
	    	SetPlayerArmour(playerid, specArmour[playerid]);
	    	
			specHP[playerid] = -1;
			specArmour[playerid] = -1;
	    }
     	else if(isAFK[playerid] != -1)
	    {
	        if(afkHP[playerid] < 99)
	        {
	            new string[256];
	            format(string, sizeof(string), "[INFO]: Your health has been set to %d and your armour has been set to %d due to AFKing before spawning.",afkHP[playerid],afkArmour[playerid]);
		    	SendClientMessage(playerid, COLOR_GREEN, string);
	        }
	        SetPlayerHealth(playerid, afkHP[playerid]);
	        SetPlayerArmour(playerid, afkArmour[playerid]);
	        afkHP[playerid] = -1;
	        afkArmour[playerid] = -1;
	    }
	    else
	    {
	        SetPlayerHealth(playerid, 99);
	    	SetPlayerArmour(playerid, 99);
	    }
	}
	else
	{
	    /*
	    Checks if they have been AFK, if true then it resets health and armour to what it was before. Courtesy of pEar.
	    */
	    if(afkHP[playerid] != -1)
	    {
	        if(afkHP[playerid] < 99)
	        {
	            new string[256];
	            format(string, sizeof(string), "[INFO]: Your health has been set to %d and your armour has been set to %d due to AFKing before spawning.",afkHP[playerid],afkArmour[playerid]);
		    	SendClientMessage(playerid, COLOR_GREEN, string);
	        }
	        SetPlayerHealth(playerid, afkHP[playerid]);
	        SetPlayerArmour(playerid, afkArmour[playerid]);
	        afkHP[playerid] = -1;
	        afkArmour[playerid] = -1;
	    }
	    else
	    {
	        if(ADuty[playerid] != 0)
	        {
	            SetPlayerHealth(playerid, INFINITY);
	        }
	        else
	        {
	            SetPlayerHealth(playerid, 99);
	        }
		    if(isVIP(playerid) > 0)
			{
				SetPlayerArmour(playerid, 99);
			}
			else
			{  
	  			if(FoCo_Player[playerid][level] == 7)
				{
					SetPlayerArmour(playerid, 65);
				}
				else if(FoCo_Player[playerid][level] == 8)
				{
					SetPlayerArmour(playerid, 75);
				}
				else if(FoCo_Player[playerid][level] == 9)
				{
					SetPlayerArmour(playerid, 85);
				}
				else if(FoCo_Player[playerid][level] >= 10)
				{
					SetPlayerArmour(playerid, 99);
				}
				else
				{
					SetPlayerArmour(playerid, 50);
				}
			}
	    }
	    
	}
	
	death[playerid] = 0;
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_SMOKE_CIGGY)
	{
		new acstring[128];
		format(acstring, 128, "[Guardian]: {%06x}%s(%d) is CJ bugged with ciggy",  COLOR_RED >>> 8, PlayerName(playerid), playerid);
		SendAdminMessage(1, acstring);
		SpawnPlayer(playerid);
	}
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	ClearAnimations(playerid);
	/////////////////////////
	TextDrawHideForPlayer(playerid, Blackout3[playerid]);
	TogglePlayerControllable(playerid, 1);

	if(!gPlayerAnimLibsPreloaded[playerid])
	{
   		PreloadAnimLib(playerid,"BOMBER");
   		PreloadAnimLib(playerid,"RAPPING");
    	PreloadAnimLib(playerid,"SHOP");
   		PreloadAnimLib(playerid,"BEACH");
   		PreloadAnimLib(playerid,"SMOKING");
    	PreloadAnimLib(playerid,"FOOD");
    	PreloadAnimLib(playerid,"ON_LOOKERS");
    	PreloadAnimLib(playerid,"DEALER");
		PreloadAnimLib(playerid,"CRACK");
		PreloadAnimLib(playerid,"CARRY");
		PreloadAnimLib(playerid,"COP_AMBIENT");
		PreloadAnimLib(playerid,"PARK");
		PreloadAnimLib(playerid,"INT_HOUSE");
		PreloadAnimLib(playerid,"FOOD");
		gPlayerAnimLibsPreloaded[playerid] = 1;
	}

	CheckLevel(playerid);
	Spawned[playerid] = 1;
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 1);
	if(FoCo_Player[playerid][jailed] > 0)
	{
		new leesdebug[128];
		format(leesdebug, sizeof(leesdebug), "Jail Val: %d", FoCo_Player[playerid][jailed]);
		SendClientMessage(playerid, COLOR_WARNING, leesdebug);
		SetPlayerPos(playerid, 154.1683,-1952.1167,47.8750);
		SetPlayerVirtualWorld(playerid, playerid);
		TogglePlayerControllable(playerid, 0);
		SendClientMessage(playerid, COLOR_WHITE, "Returned to jail");
		return 1;
	}
	SetPlayerVirtualWorld(playerid, FoCo_Teams[FoCo_Team[playerid]][team_spawn_world]);
	SetPlayerInterior(playerid, FoCo_Teams[FoCo_Team[playerid]][team_spawn_interior]);
	if(ADuty[playerid] != 0)
	{
		SetPlayerHealth(playerid, INFINITY);
		SetPlayerArmour(playerid, 9999);
		SetPlayerColor(playerid, COLOR_ADMIN);
	}
	else
	{
		SetPlayerColor(playerid, hexstr(FoCo_Teams[FoCo_Team[playerid]][team_color]));
	}
	new rank;
	if(FoCo_Player[playerid][clan] != -1 && FoCo_Team[playerid] == FoCo_Teams[FoCo_Player[playerid][clan]][db_id])
	{
		switch(FoCo_Player[playerid][clanrank])
		{
			case 1:
			{
				rank = FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_1];
			}
			case 2:
			{
				rank = FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_2];
			}
			case 3:
			{
				rank = FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_3];
			}
			case 4:
			{
				rank = FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_4];
			}
			case 5:
			{
				rank = FoCo_Teams[FoCo_Player[playerid][clan]][team_skin_5];
			}
		}
		if(GetPVarInt(playerid, "ClanSkin") != 0)
		{
			rank = GetPVarInt(playerid, "ClanSkin");
		}
		SetPlayerSkin(playerid, rank);
		SetPlayerPos(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_spawn_x], FoCo_Teams[FoCo_Player[playerid][clan]][team_spawn_y], FoCo_Teams[FoCo_Player[playerid][clan]][team_spawn_z]);
		SetPlayerVirtualWorld(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_spawn_world]);
		SetPlayerInterior(playerid, FoCo_Teams[FoCo_Player[playerid][clan]][team_spawn_interior]);
		if(ADuty[playerid] != 0)
		{
		    SetPlayerColor(playerid, COLOR_ADMIN);
		}
		else
		{
		    SetPlayerColor(playerid, hexstr(FoCo_Teams[FoCo_Player[playerid][clan]][team_color]));
		}
		
	}
	else
	{
		SetPlayerSkin(playerid, FoCo_Teams[FoCo_Team[playerid]][team_skin_1]);

		// SETTING OF TEAM SPAWN TO ALLOW /forceteam to work!
		SetPlayerPos(playerid, FoCo_Teams[FoCo_Team[playerid]][team_spawn_x], FoCo_Teams[FoCo_Team[playerid]][team_spawn_y], FoCo_Teams[FoCo_Team[playerid]][team_spawn_z]);
		SetPlayerVirtualWorld(playerid, FoCo_Teams[FoCo_Team[playerid]][team_spawn_world]);
		SetPlayerInterior(playerid, FoCo_Teams[FoCo_Team[playerid]][team_spawn_interior]);
		if(ADuty[playerid] != 0)
		{
		    SetPlayerColor(playerid, COLOR_ADMIN);
		}
		else
		{
		    SetPlayerColor(playerid, hexstr(FoCo_Teams[FoCo_Team[playerid]][team_color]));
		}
	}
	if(gPlayerLogged[playerid] == 1)
    {
        GiveGuns(playerid);
		SetPlayerVirtualWorld(playerid, 0);
	}

	if(GetPVarInt(playerid, "MotelSkin") > 0)
	{
		if(GetPVarInt(playerid, "TempSkin") > 0)
		{
			SetPlayerColor(playerid, GetPVarInt(playerid, "MotelColor"));
			SetPlayerSkin(playerid, GetPVarInt(playerid, "TempSkin"));
			DeletePVar(playerid, "MotelSkin");
			DeletePVar(playerid, "MotelColor");
		}
		else
		{	
			SetPlayerSkin(playerid, GetPVarInt(playerid, "MotelSkin"));
			SetPlayerColor(playerid, GetPVarInt(playerid, "MotelColor"));
			DeletePVar(playerid, "MotelSkin");
			DeletePVar(playerid, "MotelColor");
		}
		
	}

	TogglePlayerControllable(playerid, 1);
	SetTempSkin(playerid);

/*
	if(HaveCap(playerid) == 1)
	{
		new hskin = GetPlayerSkin(playerid)-1;
		GiveHat(playerid, pObject[playerid][oslot], pObject[playerid][omodel], 2, CapSkinOffSet[hskin][0], CapSkinOffSet[hskin][1], CapSkinOffSet[hskin][2], CapSkinOffSet[hskin][3], CapSkinOffSet[hskin][4], CapSkinOffSet[hskin][5]);
	}
*/
	Death_Streak_Reward(playerid);      // Gives boosts for players that is on a death spree.
	//event_OnPlayerSpawn(playerid);

	if(isAFK[playerid] != -1)
	{
	    SetPVarInt(playerid, "healtime", gettime()-600);
	}
	isAFK[playerid] = -1;
	afkTimer[playerid] = -1;
	justConnected[playerid] = 0;
	SetObjectBack(playerid);
 	#if defined TEST_GUNGAME
 	if(Event_ID == GUNGAME)
 	{
 	    GG_RejoinPlayer(playerid);
 	}
 	#endif
	if(AutoJoin[playerid] == 1)
	{
	    SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		PlayerJoinEvent(playerid);
	}
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	new msg[128];
	GameTextForPlayer(playerid, FoCo_Pickups[pickupid][LP_message], 5000, 3);
	if(FoCo_Player[playerid][admin] >= 1 && ADuty[playerid] == 1)
	{
		new string[128];
		format(string, sizeof(string), "[Admin Pickup]- ID(%d) - DBID(%d) - Model(%d) - Type(%d) - IssueType(%d)", FoCo_Pickups[pickupid][LP_IGID], FoCo_Pickups[pickupid][LP_DBID], FoCo_Pickups[pickupid][LP_pickupid], FoCo_Pickups[pickupid][LP_type], FoCo_Pickups[pickupid][LP_Selected_Type]);
		SendClientMessage(playerid, COLOR_ADWARNING, string);
	}

	switch(FoCo_Pickups[pickupid][LP_Selected_Type])
	{
		case 1:
		{
			if(GetPVarInt(playerid, "HealthPickup") == 1 && ADuty[playerid] != 1)
			{
				return 1;
			}
			format(msg, sizeof(msg), "FoCo_Pickups[pickupid][LP_Option_one]: %d", FoCo_Pickups[pickupid][LP_Option_one]);
			SendClientMessageToAll(COLOR_SYNTAX, msg);
			if(FoCo_Pickups[pickupid][LP_Option_one] > 0)
			{
				new Float:health;
				GetPlayerHealth(playerid, health);
				health = health+FoCo_Pickups[pickupid][LP_Option_one];
				SetPlayerHealth(playerid, health);
				format(msg, sizeof(msg), "[INFO]: You have been issued %d health, however you cannot get another health pickup until death.", FoCo_Pickups[pickupid][LP_Option_one]);
				SendClientMessage(playerid, COLOR_WHITE, msg);
				SetPVarInt(playerid, "HealthPickup", 1);
			}
			else
			{
			    return 1;
			}
			
		}
		case 2:
		{
			if(GetPVarInt(playerid, "ArmourPickup") == 1 && ADuty[playerid] != 1)
			{
				return 1;
			}
			if(FoCo_Pickups[pickupid][LP_Option_one] > 0)
			{
			    new Float:armour;
				GetPlayerArmour(playerid, armour);
				armour = armour+FoCo_Pickups[pickupid][LP_Option_one];
				SetPlayerArmour(playerid, armour);
				format(msg, sizeof(msg), "[INFO]: You have been issued %d armour, however you cannot get another armour pickup until death.", FoCo_Pickups[pickupid][LP_Option_one]);
				SendClientMessage(playerid, COLOR_WHITE, msg);
				SetPVarInt(playerid, "ArmourPickup", 1);
			}
			else
			{
			    return 1;
			}
			
		}
		case 3:
		{
			if(GetPVarInt(playerid, "WeaponPickup") == 1 && ADuty[playerid] != 1)
			{
				return 1;
			}
			GivePlayerWeapon(playerid, FoCo_Pickups[pickupid][LP_Option_one], 300);
			if(FoCo_Pickups[pickupid][LP_Option_one] == 16 || FoCo_Pickups[pickupid][LP_Option_one] == 35 || FoCo_Pickups[pickupid][LP_Option_one] == 36 || FoCo_Pickups[pickupid][LP_Option_one] == 37 || FoCo_Pickups[pickupid][LP_Option_one] == 38)
			{
				SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			}
			SendClientMessage(playerid, COLOR_WHITE, "[INFO]: Weapon Issued!");
			SetPVarInt(playerid, "WeaponPickup", 1);
		}
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	DebugMsg("Start OPD");
	SendDeathMessage(killerid, playerid, reason);
	new msg[256];
	new bonus = 0;
	new death_bonus = 0;
	GetPlayerPos(playerid, Maze_X, Maze_Y, Maze_Z);
	
    healAmount[playerid] = healAmount[playerid] + 1;
	SetPVarInt(playerid, "healtime", gettime()-600);
	DeleteAllAttachedWeapons(playerid);
	if(GetPVarInt(playerid, "AtClanWar") == 1 && FoCo_Teams[FoCo_Team[playerid]][team_clanwar_attending] == 1)
	{
		PlayerLeftClanWar(playerid, killerid);
	}
	//DebugMsg("1");
	if(killerid != INVALID_PLAYER_ID)
	{
		if(GetPVarInt(killerid, "PlayerStatus") == PLAYERSTATUS_NORMAL)           // Team-killing will only show when not in event, duel etc.
		{
			if(FoCo_Team[playerid] == FoCo_Team[killerid])
			{
			    if(GetPVarInt(playerid, "DuelException") != 1 && IsDead[playerid] == false)
			    {
       				if(IsLastKillTK[killerid] >= 1)
				    {
				        IsLastKillTK[killerid] += 1;
				    }
				    else
					{
						IsLastKillTK[killerid] = 1;
					}
					if(IsLastKillTK[killerid] >= 3)
					{
						if(AdminLvl(playerid) < 1 && IsTrialAdmin(playerid) < 1)
						{
						    new string[256];
							format(string, sizeof(string), "AdmCmd(%d): Guardian has auto-kicked %s(%d), Reason: Excessive team-killing.", ACMD_KICK, PlayerName(killerid), killerid);
							AdminLog(string);
							SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
							IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
							IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
							//mysql_real_escape_string(reason, reason);
							format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', 'Guardian', '2', 'Auto-kick for excessive team-killing', '%s')", FoCo_Player[killerid][id],TimeStamp());
							mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, killerid, con);
							SetTimerEx("KickPlayer", 1000, false, "d", killerid);
						}
					}
					else
					{
						if(IsLastKillTK[killerid] == 2)
						{
						    SetPlayerHealth(killerid, 0);
							SetPVarInt(killerid, "TKd", 1);
							FoCo_Playerstats[killerid][kills] -= (IsLastKillTK[killerid]*2) + 1;
							GameTextForPlayer(killerid, "~r~Team Killing~n~Is Not Allowed!",3000,5);
							format(msg, sizeof(msg), "[INFO]: Your kills has been decreased by %d and your money by %d for TKing.  You will be kicked if you TK again!",IsLastKillTK[killerid]*2,IsLastKillTK[killerid]*1000, IsLastKillTK[killerid]);
							SendClientMessage(killerid, COLOR_WARNING, msg);
						}
					    else
					    {
					        SetPlayerHealth(killerid, 0);
							SetPVarInt(killerid, "TKd", 1);
							FoCo_Playerstats[killerid][kills] -= (IsLastKillTK[killerid]*2) + 1;
							GameTextForPlayer(killerid, "~r~Team Killing~n~Is Not Allowed!",3000,5);
							format(msg, sizeof(msg), "[INFO]: Your kills has been decreased by %d and your money by %d for TKing.  Punishment will get harsher if you continue!",IsLastKillTK[killerid]*2,IsLastKillTK[killerid]*1000, IsLastKillTK[killerid]);
							SendClientMessage(killerid, COLOR_WARNING, msg);
					    }
					}
			    }
   			}
			else
			{
			    IsLastKillTK[killerid] = -1;
			}
		}
		if(reason == 50)
		{
		    if(GetPlayerVehicleID(killerid) != 0)
		    {
				SetVehicleToRespawn(GetPlayerVehicleID(killerid));
				HeliBladeStrike[killerid]++;
				SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Your death-count was not altered due to Heli-Blading.");
				SendClientMessage(playerid, COLOR_WARNING, "[WARNING]: Do not HeliBlade. You will be kicked, next time.");
				if(HeliBladeStrike[killerid] % 2 == 0 && !AdminLvl(killerid))
				{
				    AKickPlayer(-1, killerid, "Heliblading");
				}
			}
		}
		if(GetPVarInt(killerid, "PlayerStatus") == PLAYERSTATUS_INEVENT  && IsDead[playerid] == false)
		{
		    if(Event_Currently_On() == 0 || Event_Currently_On() == 1 || Event_Currently_On() == 2 || Event_Currently_On() == 3 || Event_Currently_On() == 4 || Event_Currently_On() == 22 || Event_Currently_On() == 23 || Event_Currently_On() == 26)
		    {
		        IsLastKillTK[killerid] = -1;
		    }
		    else
		    {	
		        if(GetPVarInt(playerid, "MotelTeamIssued") == GetPVarInt(killerid, "MotelTeamIssued"))
		        {
		            FoCo_Playerstats[killerid][kills] -= (IsLastKillTK[killerid]*2) + 1;
					GameTextForPlayer(killerid, "~r~Team Killing~n~Is Not Allowed!",3000,5);
					format(msg, sizeof(msg), "[INFO]: Your kills has been decreased by %d and your money by %d. Punishment will get harsher if you continue!",IsLastKillTK[killerid]*2,IsLastKillTK[killerid]*1000, IsLastKillTK[killerid]);
					SendClientMessage(killerid, COLOR_WARNING, msg);
		        }
		        else
		        {
		            IsLastKillTK[killerid] = -1;
		        }
		    }
		}
		//DebugMsg(".......");
		new qryString[255], Float:health, Float:armour, Float:x, Float:y, Float:z, Float:a;
		GetPlayerHealth(killerid, health);
		GetPlayerArmour(killerid, armour);
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(killerid, a);
		format(qryString, sizeof(qryString), "INSERT INTO FoCo_Deaths (KillerID, PlayerID, Weapon, KillerHealth, KillerArmour, Killer_X, Killer_Y, Killer_Z, Killer_Angle) VALUES ('%d', '%d', '%d', '%f', '%f', '%f', '%f', '%f', '%f')", FoCo_Player[killerid][id], FoCo_Player[playerid][id], reason, health, armour, x, y, z, a);
		mysql_query(qryString, MYSQL_DEATH, playerid, con);
		if(lastKiller[killerid] == playerid && GetPVarInt(playerid, "PlayerStatus") == 0 && FoCo_Team[playerid] != FoCo_Team[killerid])
		{
			GameTextForPlayer(killerid, "You got REVENGE on your last killer.. +2 kills", 3000, 4);
			FoCo_Playerstats[killerid][kills]++;
			lastKiller[killerid] = -1;
		}
		lastKiller[playerid] = killerid;
		lastKillReason[playerid] = reason;
		CurrentDeathStreak[killerid] = 0;
		CurrentDeathStreak[playerid]++;
		KillTimer(deathSpec[playerid]);
		new string[256];
		if(GetPVarInt(playerid,"PlayerStatus") != 2)
		{
			//Make sure you add the TEXT DRAW ACCORDINGLY..
			if(DeathCamTimer[playerid]== Spec_TimerFix)
			{
				TogglePlayerSpectating(playerid, 1);
				if(killerid != INVALID_PLAYER_ID) //Changed here
					PlayerSpectatePlayer(playerid, killerid); //Changed here..
				spawnSeconds[playerid]=7;
				DeathCamTimer[playerid]=repeat SpawnSeconds(playerid);
			}
			else
			{
				if(GetPlayerState(playerid)!=PLAYER_STATE_SPECTATING)
				{
					TogglePlayerSpectating(playerid, 1);
				}
				if(killerid != INVALID_PLAYER_ID) //Changed here..
					PlayerSpectatePlayer(playerid, killerid); //Changed here..
				EndSpecTimer(playerid);
				spawnSeconds[playerid]=7;
				DeathCamTimer[playerid]=repeat SpawnSeconds(playerid);
			}
			if(reason < 46 && reason > 0)
			{
				format(string, sizeof(string), "~b~~h~~h~You were killed by ~y~~h~%s~b~~h~~h~ with a ~y~~h~%s~b~~h~~h~, respawning ~y~%d seconds..", PlayerName(killerid), WeapNames[reason][WeapName], spawnSeconds[playerid]);
			}
			else
			{
				format(string, sizeof(string), "~b~~h~~h~You were killed by ~y~~h~%s~b~~h~~h~, respawning ~y~%d seconds..", PlayerName(killerid), spawnSeconds[playerid]);
			}
			TextDrawSetString(KillTD[playerid], string);
			TextDrawShowForPlayer(playerid, KillTD[playerid]);
		}
		if(FoCo_Player[killerid][level] > 10)
		{
			FoCo_Player[killerid][level] = 10;
		}

		if(FoCo_Player[killerid][score] < 0)
		{
			FoCo_Player[killerid][score] = 0;
		}
		if(GetPVarInt(playerid, "HitPlaced") != 0)
		{
		    bonus = GetPVarInt(playerid, "HitPlaced");
			format(msg, sizeof(msg), "[Hit Notice]: The hit on %s has now been claimed. $%d has been issued to %s.", PlayerName(playerid), GetPVarInt(playerid, "HitPlaced"), PlayerName(killerid));
			SendClientMessageToAll(COLOR_GREEN, msg);
			DeletePVar(playerid, "HitPlaced");
			format(msg, sizeof(msg), "[HIT]: %s (%d) gained %d$ by completing a hit contract on %s (%d).", PlayerName(killerid), killerid, GetPVarInt(playerid, "HitPlaced"), PlayerName(playerid), playerid);
			MoneyLog(msg);
		}
		if(ManHuntID != -1)
		{
			if(ManHuntID == playerid)
			{
			    if(FoCo_Team[playerid] != FoCo_Team[killerid])
				{
					bonus = (bonus + MANHUNT_BONUS);
					format(msg, sizeof(msg), "[ManHunt!]: %s has killed the manhunt target %s. He has recieved $5000 for this", PlayerName(killerid), PlayerName(playerid));
					SendClientMessageToAll(COLOR_GREEN, msg);
					ChatLog(msg);
					format(msg, sizeof(msg), "[MANHUNT]: %s (%d) gained 5000$ by killing the manhunt target 5s (%d).", PlayerName(killerid), killerid, PlayerName(playerid), playerid);
					MoneyLog(msg);
					ManHuntSeconds = GetUnixTime() - ManHuntSeconds;
					new manhuntsec = ManHuntSeconds * 3;

					if(ManHuntSeconds > 480)
					{
						foreach(Player, i)
						{
							if(FoCo_Team[i] == FoCo_Team[playerid])
						 	{
								SendClientMessage(i, COLOR_GREEN, "[ManHunt!]: Your team has been rewarded $1000 for keeping the manhunt target alive more then 8 minutes.");
							}
						}
					}

					format(msg, sizeof(msg), "[ManHunt!]: For lasting %d seconds, you have been rewarded $%d. Enjoy - You are no longer the target", ManHuntSeconds, manhuntsec);
					SendClientMessage(playerid, COLOR_GREEN, msg);
					death_bonus = manhuntsec;
					//GivePlayerMoney(playerid, manhuntsec);

					ManHuntID = -1;
					ManHuntSeconds = 0;
				}
			}
		}
		//FIRST KILL

		if(GetPVarInt(playerid, "BOUNTY") == 1)
		{
			bonus = (bonus + KILL_BOUNTY);
			new bounty[128], killers_name[MAX_PLAYER_NAME], playername[MAX_PLAYER_NAME];
			GetPlayerName(killerid, killers_name, sizeof(killers_name));
			GetPlayerName(playerid, playername, sizeof(playername));
			format(bounty, sizeof(bounty), "[INFO]: %s has killed %s. The bounty is now over", killers_name, playername);
			SendClientMessageToAll(COLOR_GREEN, bounty);
			format(bounty, sizeof(bounty), "[BOUNTY]: %s (%d) gained %d$ by killing the bounty %s (%d).", PlayerName(killerid), killerid, (bonus + KILL_BOUNTY), PlayerName(playerid), playerid);
			MoneyLog(bounty);
			SetPVarInt(playerid, "BOUNTY", 0);
		}
		if(ADuty[killerid] == 0 && reason != 50)
		{
			FoCo_Playerstats[killerid][kills]++;

			FoCo_Player[killerid][score]++;
			FoCo_Teams[killerid][team_score] ++;
		}
		

		SetPlayerScore(killerid, FoCo_Playerstats[killerid][kills]);
		SetPlayerScore(playerid, FoCo_Playerstats[playerid][kills]);
		if(FoCo_Team[playerid] != FoCo_Team[killerid])
		{
		    KillStreakMessage(playerid, killerid);
		}
		switch(CurrentKillStreak[killerid])
		{
			case 2:GameTextForPlayer(killerid, "~r~Double Kill!", 3000, 6);
			case 3:GameTextForPlayer(killerid, "~r~Triple Kill!", 3000, 6);
			case 4:GameTextForPlayer(killerid, "~r~Multi Kill!", 3000, 6);
			case 6:GameTextForPlayer(killerid, "~r~Killing Spree!", 3000, 6);
			case 7:GameTextForPlayer(killerid, "~r~Ludacrous Kill!", 3000, 6);
			case 8:GameTextForPlayer(killerid, "~r~Unstoppable!", 3000, 6);
			case 9:GameTextForPlayer(killerid, "~r~Holy Shit!", 3000, 6);
			case 10:GameTextForPlayer(killerid, "~r~Combo Whore!", 3000, 6);
		}
		//IRC MESSAGES & PER WEAPON ACHIEVEMENTS, put in function to avoid a shit ton of switches.
		IRC_Death_Messages(playerid, killerid, reason);
		if(FoCo_Team[playerid] != FoCo_Team[killerid])
		{
			if(CurrentKillStreak[playerid] == 0)
			{
				GameTextForPlayer(playerid, "~r~Humiliation!", 3000, 6);
			}
		}
	}
	else
	{
		//DebugMsg("Else");
		new qryString[255], Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		format(qryString, sizeof(qryString), "INSERT INTO FoCo_Deaths (KillerID, PlayerID, Weapon, KillerHealth, KillerArmour, Killer_X, Killer_Y, Killer_Z, Killer_Angle) VALUES ('%d', '%d', '%d', '%f', '%f', '%f', '%f', '%f', '%f')", 0, FoCo_Player[playerid][id], reason, 0.0, 0.0, x, y, z, a);
		mysql_query(qryString, MYSQL_DEATH, playerid, con);
		CurrentDeathStreak[playerid]++;
		KillTimer(deathSpec[playerid]);
		new string[256];
		//DebugMsg("21");
		if(GetPVarInt(playerid,"PlayerStatus") != 2)
		{
			//Make sure you add the TEXT DRAW ACCORDINGLY..
			if(DeathCamTimer[playerid]== Spec_TimerFix)
			{
				TogglePlayerSpectating(playerid, 1);
				if(killerid != INVALID_PLAYER_ID) //Changed here
					PlayerSpectatePlayer(playerid, killerid); //Changed here..
				spawnSeconds[playerid]=7;
				DeathCamTimer[playerid]=repeat SpawnSeconds(playerid);
			}
			else
			{
				if(GetPlayerState(playerid)!=PLAYER_STATE_SPECTATING)
				{
					TogglePlayerSpectating(playerid, 1);
				}
				if(killerid != INVALID_PLAYER_ID) //Changed here..
					PlayerSpectatePlayer(playerid, killerid); //Changed here..
				EndSpecTimer(playerid);
				spawnSeconds[playerid]=7;
				DeathCamTimer[playerid]=repeat SpawnSeconds(playerid);
			}
			if(reason < 46 && reason > 0)
			{
				format(string, sizeof(string), "~b~~h~~h~You were killed by ~y~~h~%s~b~~h~~h~ with a ~y~~h~%s~b~~h~~h~, respawning ~y~%d seconds..", PlayerName(killerid), WeapNames[reason][WeapName], spawnSeconds[playerid]);
			}
			else
			{
				format(string, sizeof(string), "~b~~h~~h~You were killed by ~y~~h~%s~b~~h~~h~, respawning ~y~%d seconds..", PlayerName(killerid), spawnSeconds[playerid]);
			}
			TextDrawSetString(KillTD[playerid], string);
			TextDrawShowForPlayer(playerid, KillTD[playerid]);
		}
	}
	//DebugMsg("....");
	new money = GetPlayerMoney(playerid);
	DebugMsg("Calling DuelDeath");
	DuelPlayerDeath(playerid,killerid,reason);
	DebugMsg("EndOf DuelDeath");
	TakeMoneyOnKill(playerid, killerid, money, death_bonus);
	GiveMoneyOnKill(playerid, killerid, bonus);
	event_OnPlayerDeath(playerid, killerid, reason);
	if(gPlayerUsingLoopingAnim[playerid])
	{
        gPlayerUsingLoopingAnim[playerid] = 0;
	}
	death[playerid] = 1;
	SetPlayerHealth( playerid, 99.0 );
	if(IsPlayerInAnyVehicle(playerid))
	{
		RemovePlayerFromVehicle(playerid);
	}
 	CurrentKillStreak[playerid] = 0;
	if(GetPVarInt(playerid, "BodgeJobBugFixLOLOLOL") == 0)
	{
		if(GetPlayerSurfingVehicleID(playerid) != INVALID_VEHICLE_ID)
		{
			surfdeath[playerid] = 10;
		}
	}
	else
	{
		SetPVarInt(playerid, "BodgeJobBugFixLOLOLOL", 0);
	}
	SetPVarInt(playerid, "HealthPickup", 0);
	SetPVarInt(playerid, "ArmourPickup", 0);
	SetPVarInt(playerid, "WeaponPickup", 0);
	//DebugMsg("22222");
	if(killerid != INVALID_PLAYER_ID)
	{
		if(ADuty[killerid] == 0 && reason != 50)
		{
			FoCo_Playerstats[playerid][deaths]++;
		}
	}
	//DebugMsg("33333333");
	if(FoCo_Player[playerid][level] > 10)
	{
		//DebugMsg("32323322");
		FoCo_Player[playerid][level] = 10;
	}
	if(FoCo_Player[playerid][score] < 0)
	{
		FoCo_Player[playerid][score] = 0;
	}
	if(killerid == INVALID_PLAYER_ID) //SWITCH NON PLAYER INOLVED DEATHS
	{
		//DebugMsg("plz");
		//GivePlayerMoney(playerid, -KILL_SUICIDE);
		//SUICIDE ACHIEVEMENT
		FoCo_Playerstats[playerid][suicides] ++;
		FoCo_Player[playerid][score]--;
		
		if(ManHuntID != -1)
		{
			if(ManHuntID == playerid)
			{
				format(msg, sizeof(msg), "[ManHunt]: %s has killed himself, therefore recieves nothing!!", PlayerName(playerid));
				SendClientMessageToAll(COLOR_GREEN, msg);

				ManHuntID = -1;
				ManHuntSeconds = 0;
			}
		}
	}
	DeletePVar(playerid, "sWepExc");	// Weapon hack shit, dont remove plz unless fixing completely. This is an easy fix for autoban weapon hacks
	//switch rank ups
	if(IsDead[playerid]==true)
	{
	    FakeDeath[playerid]++;
	    if(FakeDeath[playerid] %5 == 0)
	    {
	        ABanPlayer(-1, playerid, "FakeDeath");
	    }
	    return 1;
	}
	else
	{
        FakeDeath[playerid] = 0;
		IsDead[playerid] = true;
	}
	DebugMsg("End OPD");
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	SetVehiclePos(vehicleid, FoCo_Vehicles[vehicleid][cx], FoCo_Vehicles[vehicleid][cy], FoCo_Vehicles[vehicleid][cz]);
	SetVehicleZAngle(vehicleid, FoCo_Vehicles[vehicleid][cangle]);
	ChangeVehicleColor(vehicleid, FoCo_Vehicles[vehicleid][ccol1], FoCo_Vehicles[vehicleid][ccol2]);
	SetVehicleNumberPlate(vehicleid, FoCo_Vehicles[vehicleid][cplate]);

	SetVehicleVirtualWorld(vehicleid, FoCo_Vehicles[vehicleid][cvw]);
	LinkVehicleToInterior(vehicleid, FoCo_Vehicles[vehicleid][cint]);

	if(neon[vehicleid] != 0)
	{
		DestroyObject(neon[vehicleid]);
		DestroyObject(neon2[vehicleid]);
		neon[vehicleid] = 0;
		neon2[vehicleid] = 0;
	}

	if(FoCo_Vehicles[vehicleid][special_mod] > 0)
	{
		special_mods_add(vehicleid);
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	foreach(Player, i)
	{
		if(transveh[i] == vehicleid)
		{
			DestroyVehicle(vehicleid);
			trans[i] = 0;
			transveh[i] = -1;
			transslot[i] = -1;
			SendClientMessage(i, COLOR_NOTICE, "[NOTICE]: Your vehicle was destroyed, therefore you have been taken out of transformer mode.");
		}
	}
	if(TempVeh[vehicleid] == 1)
	{
		TempVeh[vehicleid] = 0;
		DestroyVehicle(vehicleid);
	}
	if(neon[vehicleid] != 0)
	{
		DestroyObject(neon[vehicleid]);
		DestroyObject(neon2[vehicleid]);
		neon[vehicleid] = 0;
		neon2[vehicleid] = 0;
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{
	#if defined RAKGUYIDLE
		IdleTime[playerid] = 0;
	#endif
	if(gPlayerLogged[playerid] == 0)
	{
		return 0;
	}

	if(mutedPlayers[playerid][muted] == 1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "You are muted!");
		return 0;
	}
    if(AdminLvl(playerid) == 0)
	{
		if(mutedPlayers[playerid][spam] > 3)
		{
  			SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: You have been muted for a minute, stop spamming the chat.");
  			mutePlayer(playerid, -1, 1);
			return 0;
   		}
 	}
	
	if(GetPVarInt(playerid, "TogMainChat") !=  -1)
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[INFO]: You togged your global chat. Untoggle to write messages");
	    return 0;
	}
	if(GlobalChatEnabled == 0 && FoCo_Player[playerid][admin] < 1)
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[INFO]: Global Chat is disabled by Admin");
	    return 0;
	}
	if(lastMessage[playerid] + 3 > GetUnixTime())
	{
		mutedPlayers[playerid][spam]++;
	}
	else
	{
		mutedPlayers[playerid][spam] = 0;
	}
	lastMessage[playerid] = GetUnixTime();
	new log[270];
	format(log, 270, "[%d] %s: %s",playerid, PlayerName(playerid), text);
	ChatLog(log);
	if(SearchString(text) == 1 && AdminLvl(playerid) < 1)
	{
		new ircMsg[256];
		format(ircMsg, sizeof(ircMsg), "[CHAT IGNORED]: %s[%d]: %s.", PlayerName(playerid), playerid, text);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, ircMsg);
		SendAdminMessage(1, ircMsg);
		SendClientMessage(playerid, COLOR_WARNING, "[WARNING]: You are not allowed to advertise/mention such sites-names. Spamming will get you banned.");
		AdvStrike[playerid]++;
		if(AdvStrike[playerid] == 5)
		{
		    ABanPlayer(-1, playerid, "Advertising");
		}
		CheatLog(ircMsg);
	}
	else
	{
		new ircMsg[256];
		AdvStrike[playerid]=0;
		format(ircMsg, sizeof(ircMsg), "7GAME CHAT: [%d] %s: %s", playerid, PlayerName(playerid), text);
		IRC_GroupSay(gMain, IRC_FOCO_MAIN, ircMsg);
		new message[270];
	    format(message, 270, "{%06x}[%d] %s{FFFFFF}: %s",GetPlayerColor(playerid) >>> 8,playerid, PlayerName(playerid), text);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
		    if(GetPVarInt(i, "TogMainChat") != 1)
		    {
	    		SendClientMessage(i,COLOR_WHITE, message);
			}
		}
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "", "", "", "");
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	event_OnPlayerExitVehicle(playerid, vehicleid);
	ModInteruptSave(playerid);
	LastVehicle[playerid] = vehicleid;
	antifallcheck[playerid] = 0;
	return 1;
}

public OnPlayerPrivmsg(playerid, recieverid, text[])
{
    new string[350];
    if(mutedPlayers[playerid][muted] == 0)
    {
		if(GetPVarInt(recieverid, "PMBLOCK") == 1 && FoCo_Player[playerid][admin] < 1)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That player is blocking all PMs");
			return 1;
		}
  		for(new i = 0; i < MAX_BLOCK; i++)
  		{
    		if(PeopleBlocking[recieverid][i] == playerid)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "This player is blocking PMs from you.");
			}
		}
		/* WatchPMAdmin[] contains the ID of the Player the Admin is watching */
		
		LastPMID[recieverid] = playerid;
		if(strlen(text) > 80)
		{
		    new text2[300];
		 	strmid(text2,text,80,strlen(text),sizeof(text2));
		 	strmid(text,text,0,80,300); // 300 = sizeof(text), text being the sent message, defined in cmd:pm as result with a length of 300

			if(FoCo_Player[playerid][admin] > 0)
			{
			 	format(string, sizeof(string), "[PM]: PM from {%06x}%s(%d){%06x}: %s", COLOR_GLOBALNOTICE >>> 8, PlayerName(playerid),playerid, COLOR_YELLOW >>> 8, text);
			}
			
			else
			{
			    format(string, sizeof(string), "[PM]: PM from %s(%d): %s", PlayerName(playerid),playerid, text);
			}
			
			SendClientMessage(recieverid, COLOR_YELLOW, string);
			format(string, sizeof(string), "[PM]: PM sent to %s(%d): %s", PlayerName(recieverid),recieverid, text);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			format(string, sizeof(string), "6[PRIVATE MESSAGE]: Message sent to %s(%d) from %s(%d): %s", PlayerName(recieverid), recieverid, PlayerName(playerid), playerid,  text);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			PMLog(string);
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
			    if(FoCo_Player[i][admin] >= 3)
			    {
					if(WatchPMAdmin[i] == playerid || WatchPMAdmin[i] == recieverid)
			        {
			    		format(string, sizeof(string), "[AdmWatchPM]: %s has sent a message to %s(%d): %s", PlayerName(playerid), PlayerName(recieverid),recieverid, text);
						SendClientMessage(i, COLOR_YELLOW, string);
					}
				}
			}
			
			if(FoCo_Player[playerid][admin] > 0)
			{
				format(string, sizeof(string), "[PM]: PM from {%06x}%s(%d){%06x}: %s", COLOR_GLOBALNOTICE >>> 8, PlayerName(playerid),playerid, COLOR_YELLOW >>> 8, text2);
				SendClientMessage(recieverid, COLOR_YELLOW, string);
			}
			
			else
			{
			    format(string, sizeof(string), "[PM]: PM from %s(%d): %s", PlayerName(playerid),playerid, text2);
				SendClientMessage(recieverid, COLOR_YELLOW, string);
			}
			SendClientMessage(recieverid, COLOR_YELLOW, "[INFO]: /r [text] to reply.");
			format(string, sizeof(string), "[PM]: PM sent to %s(%d): %s", PlayerName(recieverid),recieverid, text2);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			format(string, sizeof(string), "6[PRIVATE MESSAGE]: Message sent to %s(%d) from %s(%d): %s", PlayerName(recieverid), recieverid, PlayerName(playerid), playerid,  text2);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			PMLog(string);
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
			    if(FoCo_Player[i][admin] >= 3)
			    {
					if(WatchPMAdmin[i] == playerid || WatchPMAdmin[i] == recieverid)
			        {
			    		format(string, sizeof(string), "[AdmWatchPM]: %s has sent a message to %s(%d): %s", PlayerName(playerid), PlayerName(recieverid),recieverid, text2);
						SendClientMessage(i, COLOR_YELLOW, string);
					}
				}
			}
		}
		else
		{
		    if(FoCo_Player[playerid][admin] > 0)
		    {
	    		format(string, sizeof(string), "[PM]: PM from {%06x}%s(%d){%06x}: %s", COLOR_GLOBALNOTICE >>> 8, PlayerName(playerid),playerid, COLOR_YELLOW >>> 8, text);
				SendClientMessage(recieverid, COLOR_YELLOW, string);
			}
			
			else
			{
			    format(string, sizeof(string), "[PM]: PM from %s(%d): %s", PlayerName(playerid),playerid, text);
				SendClientMessage(recieverid, COLOR_YELLOW, string);
			}
			SendClientMessage(recieverid, COLOR_YELLOW, "[INFO]: /r [text] to reply.");
			format(string, sizeof(string), "[PM]: PM sent to %s(%d): %s", PlayerName(recieverid),recieverid, text);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			format(string, sizeof(string), "6[PRIVATE MESSAGE]: Message sent to %s(%d) from %s(%d): %s", PlayerName(recieverid), recieverid, PlayerName(playerid), playerid,  text);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			PMLog(string);
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
			    if(FoCo_Player[i][admin] >= 3)
			    {
					if(WatchPMAdmin[i] == playerid || WatchPMAdmin[i] == recieverid)
			        {
			    		format(string, sizeof(string), "[AdmWatchPM]: %s has sent a message to %s(%d): %s", PlayerName(playerid), PlayerName(recieverid),recieverid, text);
						SendClientMessage(i, COLOR_YELLOW, string);
					}
				}
			}
		}

    }
    else
    {
        SendClientMessage(playerid,COLOR_LIGHTYELLOW2,"[ERROR]: You are muted.");
    }
    return 0;
}

public OnPlayerIRCPrivmsg(user[], recieverid, text[])
{
    new string[350], sendname[MAX_PLAYER_NAME];
	GetPlayerName(recieverid, sendname, sizeof(sendname));
	LastPMID[recieverid] = 1500;
    format(string, sizeof(string), "[PM]: PM from %s(IRC)(ID: 1500): %s", user,text);
    SendClientMessage(recieverid, COLOR_YELLOW, string);
	format(string, sizeof(string), "6[PRIVATE MESSAGE]: Message sent to %s(%d) from %s(IRC): %s", sendname, recieverid, user, text);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	IRC_GroupSay(gAdmin, IRC_FOCO_ECHO, string);
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	switch(oldstate)
	{
		case PLAYER_STATE_DRIVER, PLAYER_STATE_PASSENGER:
		{
			ModInteruptSave(playerid);
		}
		case PLAYER_STATE_SPECTATING:
		{

		}
	}
	switch(newstate)
	{
		case PLAYER_STATE_PASSENGER:
		{
			LastVehicle[playerid] = GetPlayerVehicleID(playerid);
			if(GetPlayerWeapon(playerid) == 24 || GetPlayerWeapon(playerid) == 27)
			{
				SetPlayerArmedWeapon(playerid, 0);
			}
			if(Spectated[playerid] != -1)
			{
				if(FoCo_Player[Spectated[playerid]][admin] > 0)
				{
					if(GetPlayerState(Spectated[playerid]) == PLAYER_STATE_SPECTATING)
					{
						PlayerSpectateVehicle(Spectated[playerid], GetPlayerVehicleID(playerid));
					}
				}
			}
		}
		case PLAYER_STATE_DRIVER:
		{
			LastVehicle[playerid] = GetPlayerVehicleID(playerid);
			SetPlayerArmedWeapon(playerid, 0);

			if(Spectated[playerid] != -1)
			{
				if(FoCo_Player[Spectated[playerid]][admin] > 0)
				{
					if(GetPlayerState(Spectated[playerid]) == PLAYER_STATE_SPECTATING)
					{
						PlayerSpectateVehicle(Spectated[playerid], GetPlayerVehicleID(playerid));
					}
				}
			}
		}
		case PLAYER_STATE_SPECTATING:
		{
			DeleteAllAttachedWeapons(playerid);
		}
		case PLAYER_STATE_ONFOOT:
		{
			ModInteruptSave(playerid);
			if(Spectated[playerid] != -1)
			{
				if(FoCo_Player[Spectated[playerid]][admin] > 0)
				{
					if(GetPlayerState(Spectated[playerid]) == PLAYER_STATE_SPECTATING)
					{
						PlayerSpectatePlayer(Spectated[playerid], playerid);
					}
				}
			}
		}
	}
	if(oldstate == PLAYER_STATE_DRIVER ||  oldstate == PLAYER_STATE_PASSENGER && newstate == PLAYER_STATE_ONFOOT)
    {
        LastWeapon[playerid] = -1;
    }
	if(antifall[playerid] == 1)
    {
        if(oldstate == PLAYER_STATE_DRIVER)
        {
            if(newstate == PLAYER_STATE_ONFOOT)
            {
                if(antifallcheck[playerid] == 1)
                {
                    PutPlayerInVehicle(playerid, antifallveh[playerid], 0);
                }
            }
        }
        if(oldstate == PLAYER_STATE_PASSENGER)
        {
            if(newstate == PLAYER_STATE_ONFOOT)
            {
                if(antifallcheck[playerid] == 1)
                {
                    PutPlayerInVehicle(playerid, antifallveh[playerid], 2);
                }
            }
        }
        if(oldstate == PLAYER_STATE_ONFOOT)
        {
            if(newstate == PLAYER_STATE_DRIVER || PLAYER_STATE_PASSENGER)
            {
                antifallcheck[playerid] = 1;
                antifallveh[playerid] = GetPlayerVehicleID(playerid);
            }
        }
    }

	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	DisablePlayerCheckpoint(playerid);
	event_OnPlayerEnterCheckpoint(playerid);
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}


public OnPlayerRequestSpawn(playerid)
{
    if(gPlayerLogged[playerid] == 1 && IsPlayerAuthenticated[playerid] == true)
    {
		if(FoCo_Player[playerid][clan] >= 0)
		{
			new team_ID_descript;
			foreach(FoCoTeams, team)
			{
				if(FoCo_Player[playerid][clan] == team)
				{
					team_ID_descript++;
				}
			}

			if(team_ID_descript == 0)
			{
				new leesdebug[128];
				format(leesdebug, sizeof(leesdebug), "clan id before hand:  %d", FoCo_Player[playerid][clan]);
				SendClientMessage(playerid, COLOR_WARNING, leesdebug);
				SendClientMessage(playerid, COLOR_NOTICE, "Your clan has either been descripted or an error has occured in the DB...");
				SendClientMessage(playerid, COLOR_NOTICE, ".. Your clan value has been set to -1");
				FoCo_Player[playerid][clan] = -1;
			}
		}
		if(strlen(FoCo_Player[playerid][email]) > 3)
		{
        // Set the spawn info
		}
		else
		{
			new leesdebug[128];
			format(leesdebug, sizeof(leesdebug), "email val: %s", FoCo_Player[playerid][email]);
			SendClientMessage(playerid, COLOR_WARNING, leesdebug);
			SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: It appears you have no email assigned to your account..");
			SendClientMessage(playerid, COLOR_WARNING, ".. Please assign one to ensure account security and password resetting ..");
			SendClientMessage(playerid, COLOR_WARNING, ".. in case of an emergency. -  /emailassign. Thank you");
		}
	}
    else
    {
        if(SpawnAttempts[playerid] >= MAX_SPAWN_ATTEMPTS)
        {
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have been kicked for repeatedly attempting to spawn before logging in.");
			Kick(playerid);
			return 1;
        }
		if(gPlayerLogged[playerid] != 1)
			SendClientMessage(playerid, COLOR_NOTICE, "You must login before you can spawn!");
		else if(IsPlayerAuthenticated[playerid] == false)
		{
			SendClientMessage(playerid, COLOR_NOTICE, "You must complete Security procedure before you can spawn.");
		}
        SpawnAttempts[playerid]++;
        return 0;
    }
	if(GetPVarInt(playerid, "DisAllowSpawn") == 1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "You cannot spawn with this class.");
		return 0;
	}
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	/* Added by pEar to avoid component crashers. */
	if(componentid < 1000 || componentid > 1193)
	{
		new adm[156];
		format(adm, sizeof(adm), "%s (%d) might be trying to crash people by using a vehicle component crasher. If this spams, ban him.", PlayerName(playerid), playerid);
		AntiCheatMessage(adm); 
		return 0;
	}	
	new vehicleide = GetVehicleModel(vehicleid);
    new modok = islegalcarmod(vehicleide, componentid);

    if (!modok)
	{
		new string[150];
        format(string, sizeof(string), "[Invalid Mod Found] %s(%d) is possibly using a hacking tool on vehicle(%d) model(%d) component(%d)", PlayerName(playerid), playerid, vehicleid, vehicleide, componentid);
		SendAdminMessage(1,string);
		if(FoCo_Player[playerid][admin] == 0)
		{
			BanEx(playerid, "Hacking Illegal Server Mods");
			format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', 'Guardian', '3', 'Illegal Mods Found Possibly Hacking Tools', '%s')", FoCo_Player[playerid][id], TimeStamp());
			mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
		}
	}
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	if(Spectated[playerid] != -1)
	{
		if(FoCo_Player[Spectated[playerid]][admin] > 0)
		{
			if(GetPlayerState(Spectated[playerid]) == PLAYER_STATE_SPECTATING)
			{
				SetPlayerInterior(Spectated[playerid], newinteriorid);
				SetPlayerVirtualWorld(Spectated[playerid], GetPlayerVirtualWorld(playerid));
				PlayerSpectatePlayer(Spectated[playerid], playerid);
			}
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
/*	if(HOLDING(KEY_HANDBRAKE) && GetPlayerWeapon(playerid) == 34 && !IsPlayerInAnyVehicle(playerid))
	{
		if(HaveCap(playerid) == 1)
		{
			RemovePlayerAttachedObject(playerid, pObject[playerid][oslot]);
		}
	}
	else
	{
		if(HaveCap(playerid) == 1)
		{
			new hskin = GetPlayerSkin(playerid)-1;
			GiveHat(playerid, pObject[playerid][oslot], pObject[playerid][omodel], 2, CapSkinOffSet[hskin][0], CapSkinOffSet[hskin][1], CapSkinOffSet[hskin][2], CapSkinOffSet[hskin][3], CapSkinOffSet[hskin][4], CapSkinOffSet[hskin][5]);
		}
	}
*/
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && NitrousBoostEn[playerid] > 0)
	{
		if((((newkeys & (KEY_ACTION)) == (KEY_ACTION)) && ((oldkeys & (KEY_ACTION)) != (KEY_ACTION))))
		{
			new Float:x, Float:y, Float:z, Float:angle;
			new carid = GetPlayerVehicleID(playerid);
			GetVehicleVelocity(carid, x, y, z);
			GetVehicleZAngle(carid, angle);
			switch(NitrousBoostEn[playerid])
			{
				case 1:
				{
					x = 0.25 * floatcos(angle + 90.0, degrees) + x;
					y = 0.25 * floatsin(angle + 90.0, degrees) + y;
				}
				case 2:
				{
					x = 0.5 * floatcos(angle + 90.0, degrees) + x;
					y = 0.5 * floatsin(angle + 90.0, degrees) + y;
				}
				case 3:
				{
					x = 0.75 * floatcos(angle + 90.0, degrees) + x;
					y = 0.75 * floatsin(angle + 90.0, degrees) + y;
				}
			}
			SetVehicleVelocity(carid, x, y, z);
		}
	}
	if(ModdingCar[playerid] != 0)
	{
		new string[128];
		switch(oldkeys)
		{
			case 256:
			{
				//last mod
				switch(ModdingCar[playerid])
				{
					case 1://wheels
					{
						ModPosition[playerid] --;
						if(ModPosition[playerid] == 0){ModPosition[playerid] = 17;}
						format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModWheelArray[ModPosition[playerid]][Name], ModWheelArray[ModPosition[playerid]][Price]);
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
						AddVehicleComponent(GetPlayerVehicleID(playerid), ModWheelArray[ModPosition[playerid]][mID]);
					}
					case 3://lights
					{
						if(ModPosition[playerid] == 0 && VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights1] != 0){ModPosition[playerid] = 1;} else ModPosition[playerid] = 0;
						if(ModPosition[playerid] == 0)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights1]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights1]][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights1]][Price]);
						}
						if(ModPosition[playerid] == 1)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights2]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights2]][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights2]][Price]);
						}
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 4://fbumper
					{
						if(ModPosition[playerid] == 0 && VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper1] != 0){ModPosition[playerid] = 1;} else ModPosition[playerid] = 0;
						if(ModPosition[playerid] == 0)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper1]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper1]][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper1]][Price]);
						}
						if(ModPosition[playerid] == 1)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper2]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper2]][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper2]][Price]);
						}
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 5://rbumper
					{
						if(ModPosition[playerid] == 0 && VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper1] != 0){ModPosition[playerid] = 1;} else ModPosition[playerid] = 0;
						if(ModPosition[playerid] == 0)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper1]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper1]][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper1]][Price]);
						}
						if(ModPosition[playerid] == 1)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper2]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper2]][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper2]][Price]);
						}
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 6://sideskirts
					{
						if(ModPosition[playerid] == 0 && VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts1] != 0){ModPosition[playerid] = 1;} else ModPosition[playerid] = 0;
						if(ModPosition[playerid] == 0)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts1]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts1]][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts1]][Price]);
						}
						if(ModPosition[playerid] == 1)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts2]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts2]][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts2]][Price]);
						}
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 7://hood
					{
						if(ModPosition[playerid] == 0 && VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood1] != 0){ModPosition[playerid] = 1;} else ModPosition[playerid] = 0;
						if(ModPosition[playerid] == 0)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood1]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood1]][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood1]][Price]);
						}
						if(ModPosition[playerid] == 1)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood2]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood2]][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood2]][Price]);
						}
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 8://roof
					{
						if(ModPosition[playerid] == 0 && VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop1] != 0){ModPosition[playerid] = 1;} else ModPosition[playerid] = 0;
						if(ModPosition[playerid] == 0)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop1]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop1]][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop1]][Price]);
						}
						if(ModPosition[playerid] == 1)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop2]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop2]][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop2]][Price]);
						}
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 9://spoiler
					{
						if(ModPosition[playerid] == 0 && VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler1] != 0){ModPosition[playerid] = 1;} else ModPosition[playerid] = 0;
						if(ModPosition[playerid] == 0)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler1]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler1]][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler1]][Price]);
						}
						if(ModPosition[playerid] == 1)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler2]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler2]][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler2]][Price]);
						}
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 10://exhaust
					{
						if(ModPosition[playerid] == 0 && VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust1] != 0){ModPosition[playerid] = 1;} else ModPosition[playerid] = 0;
						if(ModPosition[playerid] == 0)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust1]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust1]][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust1]][Price]);
						}
						if(ModPosition[playerid] == 1)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust2]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust2]][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust2]][Price]);
						}
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
				}
			}
			case 64://look right
			{
				//Next mod
				switch(ModdingCar[playerid])
				{
					case 1:
					{
						ModPosition[playerid] ++;
						if(ModPosition[playerid] == 17){ModPosition[playerid] = 0;}
						format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModWheelArray[ModPosition[playerid]][Name], ModWheelArray[ModPosition[playerid]][Price]);
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
						AddVehicleComponent(GetPlayerVehicleID(playerid), ModWheelArray[ModPosition[playerid]][mID]);
					}
					case 3://lights
					{
						if(ModPosition[playerid] == 1 && VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights1] != 0){ModPosition[playerid] = 0;} else ModPosition[playerid] = 1;
						if(ModPosition[playerid] == 0)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights1]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights1]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights1]-1000][Price]);
						}
						if(ModPosition[playerid] == 1)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights2]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights2]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights2]-1000][Price]);
						}
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 4://fbumper
					{
						if(ModPosition[playerid] == 1 && VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper1] != 0){ModPosition[playerid] = 0;} else ModPosition[playerid] = 1;
						if(ModPosition[playerid] == 0)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper1]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper1]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper1]-1000][Price]);
						}
						if(ModPosition[playerid] == 1)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper2]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper2]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper2]-1000][Price]);
						}
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 5://rbumper
					{
						if(ModPosition[playerid] == 1 && VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper1] != 0){ModPosition[playerid] = 0;} else ModPosition[playerid] = 1;
						if(ModPosition[playerid] == 0)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper1]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper1]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper1]-1000][Price]);
						}
						if(ModPosition[playerid] == 1)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper2]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper2]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper2]-1000][Price]);
						}
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 6://sideskirts
					{
						if(ModPosition[playerid] == 1 && VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts1] != 0){ModPosition[playerid] = 0;} else ModPosition[playerid] = 1;
						if(ModPosition[playerid] == 0)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts1]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts1]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts1]-1000][Price]);
						}
						if(ModPosition[playerid] == 1)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts2]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts2]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts2]-1000][Price]);
						}
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 7://hood
					{
						if(ModPosition[playerid] == 1 && VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood1] != 0){ModPosition[playerid] = 0;} else ModPosition[playerid] = 1;
						if(ModPosition[playerid] == 0)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood1]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood1]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood1]-1000][Price]);
						}
						if(ModPosition[playerid] == 1)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood2]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood2]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood2]-1000][Price]);
						}
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 8://roof
					{
						if(ModPosition[playerid] == 1 && VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop1] != 0){ModPosition[playerid] = 0;} else ModPosition[playerid] = 1;
						if(ModPosition[playerid] == 0)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop1]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop1]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop1]-1000][Price]);
						}
						if(ModPosition[playerid] == 1)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop2]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop2]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop2]-1000][Price]);
						}
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 9://spoiler
					{
						if(ModPosition[playerid] == 1 && VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler1] != 0){ModPosition[playerid] = 0;} else ModPosition[playerid] = 1;
						if(ModPosition[playerid] == 0)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler1]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler1]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler1]-1000][Price]);
						}
						if(ModPosition[playerid] == 1)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler2]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler2]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler2]-1000][Price]);
						}
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 10://exhaust
					{
						if(ModPosition[playerid] == 1 && VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust1] != 0){ModPosition[playerid] = 0;} else ModPosition[playerid] = 1;
						if(ModPosition[playerid] == 0)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust1]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust1]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust1]-1000][Price]);
						}
						if(ModPosition[playerid] == 1)
						{
							AddVehicleComponent(GetPlayerVehicleID(playerid), VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust2]);
							format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust2]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust2]-1000][Price]);
						}
						TextDrawSetString(SelectionTD[playerid], string);
						TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
				}
			}
			case 16://enter key
			{
				//select option
				ShowModMenu(playerid);
				TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
			}
			case 32://lshift
			{
				//return to mod menu
				ShowModMenu(playerid);
				TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
			}
		}
	}

	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && trans[playerid] == 1)
	{
		if(GetPlayerVehicleID(playerid) == transveh[playerid])
		{
			if((((newkeys & (KEY_CROUCH)) == (KEY_CROUCH)) && ((oldkeys & (KEY_CROUCH) != (KEY_CROUCH)))))
			{
				new Float:txx, Float:tyy, Float:tzz, Float:taa;
				new Float:tvx, Float:tvy, Float:tvz;
				GetVehiclePos(GetPlayerVehicleID(playerid), txx, tyy, tzz);
				GetVehicleVelocity(transveh[playerid], tvx, tvy, tvz);
				GetVehicleZAngle(GetPlayerVehicleID(playerid), taa);

				new Passengers[20][2], count;
				for(new pasid = 0; pasid < 20; pasid++){Passengers[pasid][0] = -1;}
				/*Passenger code*/
				foreach(Player, pasid)
				{
					if(GetPlayerVehicleID(pasid) == GetPlayerVehicleID(playerid))
					{
						Passengers[count][0] = pasid;
						Passengers[count][1] = GetPlayerVehicleSeat(pasid);
					}
				}

				switch (transslot[playerid])
				{
					case 0:
					{
						DestroyVehicle(transveh[playerid]);
						transveh[playerid] = CreateVehicle(transmodel[playerid][1], txx, tyy, tzz, taa, transcolor[playerid][0], transcolor[playerid][1], 60);
						transslot[playerid] = 1;
						PutPlayerInVehicle(playerid, transveh[playerid], 0);
						SetVehicleVelocity(transveh[playerid], tvx, tvy, tvz);
					}
					case 1:
					{
						DestroyVehicle(transveh[playerid]);
						transveh[playerid] = CreateVehicle(transmodel[playerid][2], txx, tyy, tzz, taa, transcolor[playerid][0], transcolor[playerid][1], 60);
						transslot[playerid] = 2;
						PutPlayerInVehicle(playerid, transveh[playerid], 0);
						SetVehicleVelocity(transveh[playerid], tvx, tvy, tvz);
					}
					case 2:
					{
						DestroyVehicle(transveh[playerid]);
						transveh[playerid] = CreateVehicle(transmodel[playerid][0], txx, tyy, tzz, taa, transcolor[playerid][0], transcolor[playerid][1], 60);
						transslot[playerid] = 0;
						PutPlayerInVehicle(playerid, transveh[playerid], 0);
						SetVehicleVelocity(transveh[playerid], tvx, tvy, tvz);
					}
				}
				/*Passenger code*/
				for(new pasid = 0; pasid < 20; pasid++)
				{
					if(Passengers[pasid][0] != -1)
					{
						PutPlayerInVehicle(Passengers[pasid][0], transveh[playerid], Passengers[pasid][1]);
					}
				}
			}
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	if(!success)
	{
		new pip[16];
		for(new i = 0; i < MAX_PLAYERS; i++) {
			GetPlayerIp(i, pip, sizeof(pip));
			if(!strcmp(ip, pip, true))
			{
				if(RconAttempt[i] >= 3) {
					BanEx(i, "Too many incorrect RCON Attempts");
				}
				RconAttempt[i]++;
			}
		}
	}
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    if(response)
    {
        SendClientMessage(playerid, COLOR_NOTICE, "Attached object edition saved.");

        new string[128];
		format(string, sizeof(string), "Object Completed..  X: %f  - Y: %f  - Z:  %f   ::   rX: %f  - rY: %f  -  rZ: %f", fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		print(string);
    }
    else
    {
        SendClientMessage(playerid, COLOR_WARNING, "There was an error which stopped this saving.");
    }
    return 1;
}

public OnPlayerUpdate(playerid)
{
 	#if defined TEST_GUNGAME
 	if(Event_ID == GUNGAME)
 	{
 	    GG_OnPlayerUpdate(playerid);
 	}
 	#endif
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    event_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    Vote_OnDialogResponse(playerid,dialogid,response,listitem,inputtext);
    new string[512];

	switch(dialogid)
	{
		case DIALOG_WEATHER:
		{
			if(response)
			{
				SetWeather(listitem);
				format(string, sizeof(string), "AdmCmd(%d): %s %s has changed weather to %d",ACMD_WEATHER, GetPlayerStatus(playerid), PlayerName(playerid), listitem);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
				SendAdminMessage(ACMD_WEATHER,string);
				return 1;
			}
			else
			{
				return 1;
			}
		}
		case DIALOG_TOGGLEAC: 
		{
			if(response)
			{
				new ministr[10];
				switch(listitem)
				{
					case 0:
					{
						AC_NotificationDisabled[ac_not_all] = (AC_NotificationDisabled[ac_not_all]) ? false : true;
						if(AC_NotificationDisabled[ac_not_all])
						{
							format(ministr, sizeof(ministr), "disabled");
							Desync_Health = 1;
							Desync_Armour = 1;
							Desync_Weapons = 1;
							Desync_Ammo = 1;
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
							Desync_Health = 0;
							Desync_Armour = 0;
							Desync_Weapons = 0;
							Desync_Ammo = 0;
						}
						
						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: All]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
					case 1:
					{
						AC_NotificationDisabled[ac_not_airbreak] = (AC_NotificationDisabled[ac_not_airbreak]) ? false : true;
						if(AC_NotificationDisabled[ac_not_airbreak])
						{
							format(ministr, sizeof(ministr), "disabled");
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
						}
						
						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: Airbreak]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
					case 2:
					{
						AC_NotificationDisabled[ac_not_ammo] = (AC_NotificationDisabled[ac_not_ammo]) ? false : true;
						if(AC_NotificationDisabled[ac_not_ammo])
						{
							format(ministr, sizeof(ministr), "disabled");
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
						}
						
						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: Ammo]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
					case 3:
					{
						AC_NotificationDisabled[ac_not_armour] = (AC_NotificationDisabled[ac_not_armour]) ? false : true;
						if(AC_NotificationDisabled[ac_not_armour])
						{
							format(ministr, sizeof(ministr), "disabled");
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
						}
						
						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: Armour]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
					case 4:
					{
						AC_NotificationDisabled[ac_not_carhealth] = (AC_NotificationDisabled[ac_not_carhealth]) ? false : true;
						if(AC_NotificationDisabled[ac_not_carhealth])
						{
							format(ministr, sizeof(ministr), "disabled");
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
						}
						
						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: Car Health]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
					case 5:
					{	
						AC_NotificationDisabled[ac_not_carspeed] = (AC_NotificationDisabled[ac_not_carspeed]) ? false : true;
						if(AC_NotificationDisabled[ac_not_carspeed])
						{
							format(ministr, sizeof(ministr), "disabled");
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
						}
						
						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: Car Speed]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
					case 6:
					{
						AC_NotificationDisabled[ac_not_fly] = (AC_NotificationDisabled[ac_not_fly]) ? false : true;
						if(AC_NotificationDisabled[ac_not_fly])
						{
							format(ministr, sizeof(ministr), "disabled");
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
						}
						
						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: Fly]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
					case 7:
					{
						AC_NotificationDisabled[ac_not_health] = (AC_NotificationDisabled[ac_not_health]) ? false : true;
						if(AC_NotificationDisabled[ac_not_health])
						{
							format(ministr, sizeof(ministr), "disabled");
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
						}
						
						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: Health]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
					case 8:
					{
						AC_NotificationDisabled[ac_not_jetpack] = (AC_NotificationDisabled[ac_not_jetpack]) ? false : true;
						if(AC_NotificationDisabled[ac_not_jetpack])
						{
							format(ministr, sizeof(ministr), "disabled");
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
						}
						
						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: Jetpack]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
					case 9:
					{
						AC_NotificationDisabled[ac_not_mapclick] = (AC_NotificationDisabled[ac_not_mapclick]) ? false : true;
						if(AC_NotificationDisabled[ac_not_mapclick])
						{
							format(ministr, sizeof(ministr), "disabled");
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
						}
						
						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: Map Click]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
					case 10:
					{
						AC_NotificationDisabled[ac_not_modifieddmg] = (AC_NotificationDisabled[ac_not_modifieddmg]) ? false : true;
						if(AC_NotificationDisabled[ac_not_modifieddmg])
						{
							format(ministr, sizeof(ministr), "disabled");
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
						}
						
						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: Modified Dmg]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
					case 11:
					{
						AC_NotificationDisabled[ac_not_money] = (AC_NotificationDisabled[ac_not_money]) ? false : true;
						if(AC_NotificationDisabled[ac_not_money])
						{
							format(ministr, sizeof(ministr), "disabled");
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
						}
						
						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: Money]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
					case 12:
					{
						AC_NotificationDisabled[ac_not_weapons] = (AC_NotificationDisabled[ac_not_weapons]) ? false : true;
						if(AC_NotificationDisabled[ac_not_weapons])
						{
							format(ministr, sizeof(ministr), "disabled");
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
						}
						
						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: Weapons]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
					case 13:
					{
					    ShowPlayerDialog(playerid, DIALOG_TOGGLEAC1, DIALOG_STYLE_LIST, "Toggle AC Notifications 2", GetAntiCheatNotificationList1(), "Toggle", "Cancel");
					}
				}
			
				if(strlen(string) > 1)
		        {
		            IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					SendAdminMessage(ACMD_TOGGLEAC,string);
		        }
			}
			return 1;
		}
		case DIALOG_TOGGLEAC1:
		{
		    if(response)
		    {
		        new ministr[10];
		        switch(listitem)
		        {
					case 0:
					{
						if(Desync_Health == 0)
						{
							format(ministr, sizeof(ministr), "disabled");
							Desync_Health = 1;
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
							Desync_Health = 0;
						}

						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: Desynced Health]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
                    case 1:
					{
						if(Desync_Armour == 0)
						{
							format(ministr, sizeof(ministr), "disabled");
							Desync_Armour = 1;
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
							Desync_Armour = 0;
						}

						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: Desynced Armour]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
					case 2:
					{
						if(Desync_Weapons == 0)
						{
							format(ministr, sizeof(ministr), "disabled");
							Desync_Weapons = 1;
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
							Desync_Weapons = 0;
						}

						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: Desynced Weapons]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
                    case 3:
					{
						if(Desync_Ammo == 0)
						{
							format(ministr, sizeof(ministr), "disabled");
							Desync_Ammo = 1;
						}
						else
						{
							format(ministr, sizeof(ministr), "enabled");
							Desync_Ammo = 0;
						}

						format(string, sizeof(string), "AdmCmd(%d): %s %s has %s notifications on the anti-cheat. [Type: Desynced Ammo]",ACMD_TOGGLEAC, GetPlayerStatus(playerid), PlayerName(playerid), ministr);
					}
					case 4:
					{
					    ShowPlayerDialog(playerid, DIALOG_TOGGLEAC, DIALOG_STYLE_LIST, "Toggle AC Notifications", GetAntiCheatNotificationList(), "Toggle", "Cancel");
					}
		        }
		        if(strlen(string) > 1)
		        {
		            IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					SendAdminMessage(ACMD_TOGGLEAC,string);
		        }
		    }
		    else
		    {
		        return 1;
		    }
		}
		case DIALOG_LOG:
		{
			if(response == 1)
			{
				OnPlayerLoggin(playerid, inputtext);
			}
			else
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have been kicked, this server requires a user account to play");
				Kick(playerid);
				return 1;
			}
			return 1;
		}
		case DIALOG_REG:
		{
			if(response == 1)
			{
				OnPlayerRegister(playerid, inputtext);
			}
			else
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The server requires an account to continue. Please relog...");
				Kick(playerid);
			}
			return 1;
		}
		case DIALOG_RULES:
		{
			if(!gPlayerLogged[playerid])
			{
				if(!response)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Due to not accepting the rules, you have been kicked");
					Kick(playerid);
					return 1;
				}

			}
			return 1;
		}
		case DIALOG_TRANSSYS_1:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_TRANSSYS_2, DIALOG_STYLE_INPUT, "Input vehicle ID 1", "Input the vehicle ID below:\r\n\r\nYou can only select an ID between 400 & 611.", "Submit", "Close");
				}

				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_TRANSSYS_3, DIALOG_STYLE_INPUT, "Input vehicle ID 2", "Input the vehicle ID below:\r\n\r\nYou can only select an ID between 400 & 611.", "Submit", "Close");
				}

				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_TRANSSYS_4, DIALOG_STYLE_INPUT, "Input vehicle ID 3", "Input the vehicle ID below:\r\n\r\nYou can only select an ID between 400 & 611.", "Submit", "Close");
				}

				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_TRANSSYS_5, DIALOG_STYLE_INPUT, "Input colour ID 1", "Input the colour ID below:\r\n\r\nYou can only select an ID between 0 & 150.", "Submit", "Close");
				}

				case 4:
				{
					ShowPlayerDialog(playerid, DIALOG_TRANSSYS_6, DIALOG_STYLE_INPUT, "Input colour ID 2", "Input the colour ID below:\r\n\r\nYou can only select an ID between 0 & 150.", "Submit", "Close");
				}
			}
			return 1;
		}

		case DIALOG_TRANSSYS_2:
		{
			if(!response) return 1;

			new modelid =  strval(inputtext);
			if(GetVehicleModelIDFromName(inputtext) == -1)
			{
				modelid = strval(inputtext);
			}
			else modelid = GetVehicleModelIDFromName(inputtext);
			if(modelid < 400 || modelid > 611)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[[ERROR]:]: You must choose a vehicle ID between 400 & 611.");
				return 1;
			}
			else
			{
				transmodel[playerid][0] = modelid;
				SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Slot one vehicle has been selected.");
				format(string, sizeof(string), "Vehicle slot one (Currently: %d)\nVehicle slot two (Currently: %d)\nVehicle slot three (Currently: %d)\nColour slot one (Currently: %d)\nColour slot two (Currently: %d)", transmodel[playerid][0], transmodel[playerid][1], transmodel[playerid][2], transcolor[playerid][0], transcolor[playerid][1]);
				ShowPlayerDialog(playerid, DIALOG_TRANSSYS_1, DIALOG_STYLE_LIST, "Select the slot you wish to edit:", string, "Select", "Cancel");
				return 1;
			}
		}

		case DIALOG_TRANSSYS_3:
		{
			if(!response) return 1;

			new modelid =  strval(inputtext);
			if(GetVehicleModelIDFromName(inputtext) == -1)
			{
				modelid = strval(inputtext);
			}
			else modelid = GetVehicleModelIDFromName(inputtext);
			if(modelid < 400 || modelid > 611)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[[ERROR]:]: You must choose a vehicle ID between 400 & 611.");
				return 1;
			}
			else
			{
				transmodel[playerid][1] = modelid;
				SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Slot two vehicle has been selected.");
				format(string, sizeof(string), "Vehicle slot one (Currently: %d)\nVehicle slot two (Currently: %d)\nVehicle slot three (Currently: %d)\nColour slot one (Currently: %d)\nColour slot two (Currently: %d)", transmodel[playerid][0], transmodel[playerid][1], transmodel[playerid][2], transcolor[playerid][0], transcolor[playerid][1]);
				ShowPlayerDialog(playerid, DIALOG_TRANSSYS_1, DIALOG_STYLE_LIST, "Select the slot you wish to edit:", string, "Select", "Cancel");
			}
			return 1;
		}

		case DIALOG_TRANSSYS_4:
		{
			if(!response) return 1;

			new modelid =  strval(inputtext);
			if(GetVehicleModelIDFromName(inputtext) == -1)
			{
				modelid = strval(inputtext);
			}
			else modelid = GetVehicleModelIDFromName(inputtext);
			if(modelid < 400 || modelid > 611)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[[ERROR]:]: You must choose a vehicle ID between 400 & 611.");
				return 1;
			}
			else
			{
				transmodel[playerid][2] = modelid;
				SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Slot three vehicle has been selected.");
				format(string, sizeof(string), "Vehicle slot one (Currently: %d)\nVehicle slot two (Currently: %d)\nVehicle slot three (Currently: %d)\nColour slot one (Currently: %d)\nColour slot two (Currently: %d)", transmodel[playerid][0], transmodel[playerid][1], transmodel[playerid][2], transcolor[playerid][0], transcolor[playerid][1]);
				ShowPlayerDialog(playerid, DIALOG_TRANSSYS_1, DIALOG_STYLE_LIST, "Select the slot you wish to edit:", string, "Select", "Cancel");
			}
			return 1;
		}

		case DIALOG_TRANSSYS_5:
		{
			if(!response) return 1;

			new colorid = strval(inputtext);
			if(colorid < 0 || colorid > 150)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[[ERROR]:]: You must choose a colour ID between 0 & 150.");
				return 1;
			}
			transcolor[playerid][0] = colorid;
			SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Colour one has been succesfully set.");
			return 1;
		}

		case DIALOG_TRANSSYS_6:
		{
			if(!response) return 1;

			new colorid = strval(inputtext);
			if(colorid < 0 || colorid > 150)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[[ERROR]:]: You must choose a colour ID between 0 & 150.");
				return 1;
			}
			transcolor[playerid][1] = colorid;
			SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Colour two has been succesfully set.");
			return 1;
		}
		case DIALOG_LEVEL:
		{
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_LEVEL_GUNS, DIALOG_STYLE_MSGBOX, "Weapons List", "Level 0 and 1 get the normal deagle and knife.", "Ok", "Close");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_LEVEL_GUNS, DIALOG_STYLE_MSGBOX, "Weapons List", "Rank 2 will give you a shotgun ontop of the above.", "Ok", "Close");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_LEVEL_GUNS, DIALOG_STYLE_MSGBOX, "Weapons List", "Rank 3 will give you a MP5.", "Ok", "Close");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_LEVEL_GUNS, DIALOG_STYLE_MSGBOX, "Weapons List", "Rank 4 will give you 120 health.", "Ok", "Close");
				}
				case 4:
				{
					ShowPlayerDialog(playerid, DIALOG_LEVEL_GUNS, DIALOG_STYLE_MSGBOX, "Weapons List", "Rank 5 will give you 20 armour and an AK47.", "Ok", "Close");
				}
				case 5:
				{
					ShowPlayerDialog(playerid, DIALOG_LEVEL_GUNS, DIALOG_STYLE_MSGBOX, "Weapons List", "Rank 6 will give you an M4", "Ok", "Close");
				}
				case 6:
				{
					ShowPlayerDialog(playerid, DIALOG_LEVEL_GUNS, DIALOG_STYLE_MSGBOX, "Weapons List", "Rank 7 will give you 40 armour and a combat shotgun.", "Ok", "Close");
				}
				case 7:
				{
					ShowPlayerDialog(playerid, DIALOG_LEVEL_GUNS, DIALOG_STYLE_MSGBOX, "Weapons List", "Rank 8 will give you 150 health, 60 armour and a sniper ", "Ok", "Close");
				}
				case 8:
				{
					ShowPlayerDialog(playerid, DIALOG_LEVEL_GUNS, DIALOG_STYLE_MSGBOX, "Weapons List", "Rank 9 will give you grenades.", "Ok", "Close");
				}
				case 9:
				{
					ShowPlayerDialog(playerid, DIALOG_LEVEL_GUNS, DIALOG_STYLE_MSGBOX, "Weapons List", "Rank 10 will give you 100 armour and a flamethrower.", "Ok", "Close");
				}
			}
			return 1;
		}
		case DIALOG_LEVEL_GUNS:
		{
			return 1;
		}
		case DIALOG_CARMOD1:
		{
			new Float:angle, Float:x, Float:y, Float:z, Float:vvx, Float:vvy, Float:vvz;
			if(!response)
			{
				ExitModMenu(playerid);
				return 1;
			}
			new playveh = GetPlayerVehicleID(playerid);
			if(strcmp(inputtext, "Wheels", true) == 0)
			{
				ModdingCar[playerid] = 1;
				ModPosition[playerid] = 0;
				format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModWheelArray[ModPosition[playerid]][Name], ModWheelArray[ModPosition[playerid]][Price]);
				TextDrawSetString(SelectionTD[playerid], string);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				AddVehicleComponent(playveh, ModWheelArray[ModPosition[playerid]][mID]);
				GetVehiclePos(playveh, x, y, z);
				GetVehiclePos(playveh, vvx, vvy, vvz);
				GetVehicleZAngle(playveh, angle);
				angle = angle + 105.0;
				x += (5 * floatsin(-angle, degrees));
				y += (5 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);
			}
			else if(strcmp(inputtext, "Nitrous Oxide", true) == 0)
			{
				new nos1;
				if(GetVehicleComponentInSlot(playveh, CARMODTYPE_NITRO) != 1009)
				{
					nos1 = 1;
					strins(string, "2 Cans of Nitrous Oxide", strlen(string));
				}
				if(GetVehicleComponentInSlot(playveh, CARMODTYPE_NITRO) != 1008)
				{
					if(nos1 == 1)
					{
						strins(string, "\n5 Cans of Nitrous Oxide", strlen(string));
					}
					else
					{
						strins(string, "5 Cans of Nitrous Oxide", strlen(string));
						nos1 = 1;
					}
				}
				if(GetVehicleComponentInSlot(playveh, CARMODTYPE_NITRO) != 1010)
				{
					if(nos1 == 1)
					{
						strins(string, "\n10 Cans of Nitrous Oxide", strlen(string));
					}
					else
					{
						strins(string, "10 Cans of Nitrous Oxide", strlen(string));
					}
				}
				ShowPlayerDialog(playerid, DIALOG_CARMOD6, DIALOG_STYLE_LIST, "Vehicle Modification - Nitrous Oxide", string, "Purchase", "Go Back");
				return 1;
			}
			else if(strcmp(inputtext, "Hydraulics", true) == 0)
			{
				ModdingCar[playerid] = 2;
				format(string, sizeof(string), "Would you like to add hydraulics to your cart for a cost of {FF0000}${FFFFFF}%i?", ModInfoArray[87][Price]);
				ShowPlayerDialog(playerid, DIALOG_CARMOD2, DIALOG_STYLE_MSGBOX, "Vehicle Modification - Hydraulics", string, "Yes", "No");
			}
			else if(strcmp(inputtext, "Lights", true) == 0)
			{
				ModdingCar[playerid] = 3;
				ModPosition[playerid] = 0;
				AddVehicleComponent(playveh, VehNames[GetVehicleModel(playveh)-400][Lights1]);
				format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(playveh)-400][Lights1]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(playveh)-400][Lights1]-1000][Price]);
				TextDrawSetString(SelectionTD[playerid], string);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(playveh, x, y, z);
				GetVehiclePos(playveh, vvx, vvy, vvz);
				GetVehicleZAngle(playveh, angle);
				x += (5 * floatsin(-angle, degrees));
				y += (5 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);

			}
			else if(strcmp(inputtext, "Front Bumper", true) == 0)
			{
				ModdingCar[playerid] = 4;
				ModPosition[playerid] = 0;
				AddVehicleComponent(playveh, VehNames[GetVehicleModel(playveh)-400][FBumper1]);
				format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(playveh)-400][FBumper1]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(playveh)-400][FBumper1]-1000][Price]);
				TextDrawSetString(SelectionTD[playerid], string);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(playveh, x, y, z);
				GetVehiclePos(playveh, vvx, vvy, vvz);
				GetVehicleZAngle(playveh, angle);
				x += (5 * floatsin(-angle, degrees));
				y += (5 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);

			}
			else if(strcmp(inputtext, "Rear Bumper", true) == 0)
			{
				ModdingCar[playerid] = 5;
				ModPosition[playerid] = 0;
				AddVehicleComponent(playveh, VehNames[GetVehicleModel(playveh)-400][RBumper1]);
				format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(playveh)-400][RBumper1]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(playveh)-400][RBumper1]-1000][Price]);
				TextDrawSetString(SelectionTD[playerid], string);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(playveh, x, y, z);
				GetVehiclePos(playveh, vvx, vvy, vvz);
				GetVehicleZAngle(playveh, angle);
				angle = angle + 180.0;
				x += (5 * floatsin(-angle, degrees));
				y += (5 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);

			}
			else if(strcmp(inputtext, "Side Skirts", true) == 0)
			{
				ModdingCar[playerid] = 6;
				ModPosition[playerid] = 0;
				AddVehicleComponent(playveh, VehNames[GetVehicleModel(playveh)-400][SideSkirts1]);
				format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(playveh)-400][SideSkirts1]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(playveh)-400][SideSkirts1]-1000][Price]);
				TextDrawSetString(SelectionTD[playerid], string);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(playveh, x, y, z);
				GetVehiclePos(playveh, vvx, vvy, vvz);
				GetVehicleZAngle(playveh, angle);
				angle = angle + 105.0;
				x += (5 * floatsin(-angle, degrees));
				y += (5 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);

			}
			else if(strcmp(inputtext, "Hood", true) == 0)
			{
				ModdingCar[playerid] = 7;
				ModPosition[playerid] = 0;
				AddVehicleComponent(playveh, VehNames[GetVehicleModel(playveh)-400][Hood1]);
				format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(playveh)-400][Hood1]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(playveh)-400][Hood1]-1000][Price]);
				TextDrawSetString(SelectionTD[playerid], string);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(playveh, x, y, z);
				GetVehiclePos(playveh, vvx, vvy, vvz);
				GetVehicleZAngle(playveh, angle);
				x += (3 * floatsin(-angle, degrees));
				y += (3 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z+3);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);

			}
			else if(strcmp(inputtext, "Roof Scoop", true) == 0)
			{
				ModdingCar[playerid] = 8;
				ModPosition[playerid] = 0;
				AddVehicleComponent(playveh, VehNames[GetVehicleModel(playveh)-400][RoofScoop1]);
				format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(playveh)-400][RoofScoop1]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(playveh)-400][RoofScoop1]-1000][Price]);
				TextDrawSetString(SelectionTD[playerid], string);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(playveh, x, y, z);
				GetVehiclePos(playveh, vvx, vvy, vvz);
				GetVehicleZAngle(playveh, angle);
				x += (3 * floatsin(-angle, degrees));
				y += (3 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z+4);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);

			}
			else if(strcmp(inputtext, "Spoiler", true) == 0)
			{
				ModdingCar[playerid] = 9;
				ModPosition[playerid] = 0;
				AddVehicleComponent(playveh, VehNames[GetVehicleModel(playveh)-400][Spoiler1]);
				format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(playveh)-400][Spoiler1]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(playveh)-400][Spoiler1]-1000][Price]);
				TextDrawSetString(SelectionTD[playerid], string);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(playveh, x, y, z);
				GetVehiclePos(playveh, vvx, vvy, vvz);
				GetVehicleZAngle(playveh, angle);
				angle = angle + 165.0;
				x += (5 * floatsin(-angle, degrees));
				y += (5 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z+3);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);

			}
			else if(strcmp(inputtext, "Exhaust", true) == 0)
			{
				ModdingCar[playerid] = 10;
				ModPosition[playerid] = 0;
				AddVehicleComponent(playveh, VehNames[GetVehicleModel(playveh)-400][Exhaust1]);
				format(string, 128, "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[VehNames[GetVehicleModel(playveh)-400][Exhaust1]-1000][Name], ModInfoArray[VehNames[GetVehicleModel(playveh)-400][Exhaust1]-1000][Price]);
				TextDrawSetString(SelectionTD[playerid], string);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(playveh, x, y, z);
				GetVehiclePos(playveh, vvx, vvy, vvz);
				GetVehicleZAngle(playveh, angle);
				angle = angle + 180.0;
				x += (5 * floatsin(-angle, degrees));
				y += (5 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);

			}
			else if(strcmp(inputtext, "Empty Cart", true) == 0)
			{
				ExitModMenu(playerid);
				ShowModMenu(playerid);
			}
			else if(strcmp(inputtext, "Checkout", true) == 0)
			{
				ModdingCar[playerid] = 11;
				new modmatch = 0;
				GetVehiclePos(playveh, x, y, z);
				GetVehiclePos(playveh, vvx, vvy, vvz);
				GetVehicleZAngle(playveh, angle);
				angle = angle + 45.0;
				x += (5 * floatsin(-angle, degrees));
				y += (5 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z+3);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);

				ModCartTotal[playerid] = 0;
				if(GetVehicleComponentInSlot(playveh, CARMODTYPE_NITRO) != VehBackupArray[playerid][NOS])
				{
					modmatch = 1;
					format(string, sizeof(string), "Cart: {15D4ED}%s {FFFFFF}- {FF0000}${FFFFFF}%i", ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_NITRO)-1000][Name], ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_NITRO)-1000][Price]);
					SendClientMessage(playerid, COLOR_BLUE, string);
					ModCartTotal[playerid] = ModCartTotal[playerid] + ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_NITRO)-1000][Price];
				}
				if(VehBackupArray[playerid][Wheels] != GetVehicleComponentInSlot(playveh, CARMODTYPE_WHEELS))
				{
					modmatch = 1;
					for(new i = 0; i < 17; i++)
					{
						if(ModWheelArray[i][mID] == GetVehicleComponentInSlot(playveh, CARMODTYPE_WHEELS))
						{
							format(string, sizeof(string), "Cart: {15D4ED}%s {FFFFFF}- {FF0000}${FFFFFF}%i", ModWheelArray[i][Name], ModWheelArray[i][Price]);
							SendClientMessage(playerid, COLOR_BLUE, string);
							ModCartTotal[playerid] = ModCartTotal[playerid] + ModWheelArray[i][Price];
							i = 17;
						}
					}
				}
				if(GetVehicleComponentInSlot(playveh, CARMODTYPE_HYDRAULICS) != VehBackupArray[playerid][Hydraulics])
				{
					modmatch = 1;
					format(string, sizeof(string), "Cart: {15D4ED}%s {FFFFFF}- {FF0000}${FFFFFF}%i", ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_HYDRAULICS) -1000][Name], ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_HYDRAULICS) -1000][Price]);
					SendClientMessage(playerid, COLOR_BLUE, string);
					ModCartTotal[playerid] = ModCartTotal[playerid] + ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_HYDRAULICS) - 1000][Price];
				}
				if(GetVehicleComponentInSlot(playveh, CARMODTYPE_LAMPS) != VehBackupArray[playerid][Lights])
				{
					modmatch = 1;
					format(string, sizeof(string), "Cart: {15D4ED}%s {FFFFFF}- {FF0000}${FFFFFF}%i", ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_LAMPS)-1000][Name], ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_LAMPS)-1000][Price]);
					SendClientMessage(playerid, COLOR_BLUE, string);
					ModCartTotal[playerid] = ModCartTotal[playerid] + ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_LAMPS)-1000][Price];
				}
				if(GetVehicleComponentInSlot(playveh, CARMODTYPE_FRONT_BUMPER))
				{
					modmatch = 1;
					format(string, sizeof(string), "Cart: {15D4ED}%s {FFFFFF}- {FF0000}${FFFFFF}%i", ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_FRONT_BUMPER)-1000][Name], ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_FRONT_BUMPER)-1000][Price]);
					SendClientMessage(playerid, COLOR_BLUE, string);
					ModCartTotal[playerid] = ModCartTotal[playerid] + ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_FRONT_BUMPER)-1000][Price];
				}
				if(GetVehicleComponentInSlot(playveh, CARMODTYPE_REAR_BUMPER) != VehBackupArray[playerid][RBumper])
				{
					modmatch = 1;
					format(string, sizeof(string), "Cart: {15D4ED}%s {FFFFFF}- {FF0000}${FFFFFF}%i", ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_REAR_BUMPER)-1000][Name], ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_REAR_BUMPER)-1000][Price]);
					SendClientMessage(playerid, COLOR_BLUE, string);
					ModCartTotal[playerid] = ModCartTotal[playerid] + ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_REAR_BUMPER)-1000][Price];
				}
				if(GetVehicleComponentInSlot(playveh, CARMODTYPE_SIDESKIRT) !=VehBackupArray[playerid][SideSkirts])
				{
					modmatch = 1;
					format(string, sizeof(string), "Cart: {15D4ED}%s {FFFFFF}- {FF0000}${FFFFFF}%i", ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_SIDESKIRT)-1000][Name], ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_SIDESKIRT)-1000][Price]);
					SendClientMessage(playerid, COLOR_BLUE, string);
					ModCartTotal[playerid] = ModCartTotal[playerid] + ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_SIDESKIRT)-1000][Price];
				}
				if(GetVehicleComponentInSlot(playveh, CARMODTYPE_HOOD) != VehBackupArray[playerid][Hood])
				{
					modmatch = 1;
					format(string, sizeof(string), "Cart: {15D4ED}%s {FFFFFF}- {FF0000}${FFFFFF}%i", ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_HOOD)-1000][Name], ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_HOOD)-1000][Price]);
					SendClientMessage(playerid, COLOR_BLUE, string);
					ModCartTotal[playerid] = ModCartTotal[playerid] + ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_HOOD)-1000][Price];
				}
				if(GetVehicleComponentInSlot(playveh, CARMODTYPE_ROOF) != VehBackupArray[playerid][RoofScoop])
				{
					modmatch = 1;
					format(string, sizeof(string), "Cart: {15D4ED}%s {FFFFFF}- {FF0000}${FFFFFF}%i", ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_ROOF)-1000][Name], ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_ROOF)-1000][Price]);
					SendClientMessage(playerid, COLOR_BLUE, string);
					ModCartTotal[playerid] = ModCartTotal[playerid] + ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_ROOF)-1000][Price];
				}
				if(GetVehicleComponentInSlot(playveh, CARMODTYPE_SPOILER) !=VehBackupArray[playerid][Spoiler])
				{
					modmatch = 1;
					format(string, sizeof(string), "Cart: {15D4ED}%s {FFFFFF}- {FF0000}${FFFFFF}%i", ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_SPOILER)-1000][Name], ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_SPOILER)-1000][Price]);
					SendClientMessage(playerid, COLOR_BLUE, string);
					ModCartTotal[playerid] = ModCartTotal[playerid] + ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_SPOILER)-1000][Price];
				}
				if(GetVehicleComponentInSlot(playveh, CARMODTYPE_EXHAUST) != VehBackupArray[playerid][Exhaust])
				{
					modmatch = 1;
					format(string, sizeof(string), "Cart: {15D4ED}%s {FFFFFF}- {FF0000}${FFFFFF}%i", ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_EXHAUST)-1000][Name], ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_EXHAUST) -1000][Price]);
					SendClientMessage(playerid, COLOR_BLUE, string);
					ModCartTotal[playerid] = ModCartTotal[playerid] + ModInfoArray[GetVehicleComponentInSlot(playveh, CARMODTYPE_EXHAUST)-1000][Price];
				}
				if(modmatch == 0)
				{
					ShowPlayerDialog(playerid, DIALOG_CARMOD3, DIALOG_STYLE_MSGBOX, "Checkout", "{FFFFFF}Your cart is {FF0000}empty{FFFFFF}, no changes to your vehicle have been made, would you like to go back or exit?", "Go Back", "Exit");
				}
				else
				{
					if(isVIP(playerid) == 2)
					{
						format(string, sizeof(string), "{15D4ED}The total cost of your cart is {FF0000}${FFFFFF}0{15D4ED} as your a donator. \nAre you sure you would like to purchase these items?");
						ShowPlayerDialog(playerid, DIALOG_CARMOD4, DIALOG_STYLE_MSGBOX, "Checkout", string, "Purchase", "Go Back");
						return 1;
					}
					if(GetPlayerMoney(playerid) >= ModCartTotal[playerid])
					{
						format(string, sizeof(string), "{15D4ED}The total cost of your cart is {FF0000}${FFFFFF}%i{15D4ED}. \nAre you sure you would like to purchase these items?", ModCartTotal[playerid]);
						ShowPlayerDialog(playerid, DIALOG_CARMOD4, DIALOG_STYLE_MSGBOX, "Checkout", string, "Purchase", "Go Back");
					}
					else
					{
						format(string, sizeof(string), "{15D4ED}The total cost of your cart is {FF0000}${FFFFFF}%i{15D4ED}. \nYou can not afford this, you may go back or exit.", ModCartTotal[playerid]);
						ShowPlayerDialog(playerid, DIALOG_CARMOD5, DIALOG_STYLE_MSGBOX, "Checkout", string, "Go Back", "Exit");
					}
				}
			}
			return 1;
		}
		case DIALOG_CARMOD2:
		{
			if(!response) return ShowModMenu(playerid);
			new playveh = GetPlayerVehicleID(playerid);
			AddVehicleComponent(playveh, 1087);
			ShowModMenu(playerid);
		}
		case DIALOG_CARMOD3:
		{
			if(response) return ShowModMenu(playerid);
			ExitModMenu(playerid);
		}
		case DIALOG_CARMOD4:
		{
			if(!response) return ShowModMenu(playerid);

			if(isVIP(playerid) == 2)
			{
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
				GiveAchievement(playerid,  23);
				return 1;
			}

			if(GetPlayerMoney(playerid) < ModCartTotal[playerid])
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not afford this.");
				ExitModMenu(playerid);
			}
			else
			{
				GivePlayerMoney(playerid, -ModCartTotal[playerid]);
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
				GiveAchievement(playerid,  23);
			}
		}
		case DIALOG_CARMOD5:
		{
			if(response) return ShowModMenu(playerid);
			ExitModMenu(playerid);
		}
		case DIALOG_CARMOD6:
		{
			if(!response) return ShowModMenu(playerid);
			if(!strcmp(inputtext, "2 Cans of Nitrous Oxide"))
			{
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1009);
				ShowModMenu(playerid);
			}
			if(!strcmp(inputtext, "5 Cans of Nitrous Oxide"))
			{
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1008);
				ShowModMenu(playerid);
			}
			if(!strcmp(inputtext, "10 Cans of Nitrous Oxide"))
			{
				AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
				ShowModMenu(playerid);
			}
		}
		case DIALOG_ASETSTAT1:
		{
			if(!response) return 1;
			new targetname[56];
			GetPlayerName(DialogOptionVar1[playerid], targetname, sizeof(targetname));
			switch(listitem)
			{
				case 0:
				{
					DialogOptionVar2[playerid] = 1;
					format(string, sizeof(string), "Please enter a value you wish to set %s's skin to, it is currently set as %i", targetname, FoCo_Player[DialogOptionVar1[playerid]][skin]);
					ShowPlayerDialog(playerid, DIALOG_ASETSTAT2, DIALOG_STYLE_INPUT, "Player Stat Setting", string, "Accept", "Cancel");
				}
				case 1:
				{
					DialogOptionVar2[playerid] = 2;
					format(string, sizeof(string), "Please enter a value you wish to set %s's kills to, it is currently set as %i", targetname, FoCo_Playerstats[DialogOptionVar1[playerid]][kills]);
					ShowPlayerDialog(playerid, DIALOG_ASETSTAT2, DIALOG_STYLE_INPUT, "Player Stat Setting", string, "Accept", "Cancel");
				}
				case 2:
				{
					DialogOptionVar2[playerid] = 3;
					format(string, sizeof(string), "Please enter a value you wish to set %s's score to, it is currently set as %i", targetname, FoCo_Player[DialogOptionVar1[playerid]][score]);
					ShowPlayerDialog(playerid, DIALOG_ASETSTAT2, DIALOG_STYLE_INPUT, "Player Stat Setting", string, "Accept", "Cancel");
				}
				case 3:
				{
					DialogOptionVar2[playerid] = 4;
					format(string, sizeof(string), "Please enter a value you wish to set %s's level to, it is currently set as %i", targetname, FoCo_Player[DialogOptionVar1[playerid]][level]);
					ShowPlayerDialog(playerid, DIALOG_ASETSTAT2, DIALOG_STYLE_INPUT, "Player Stat Setting", string, "Accept", "Cancel");
				}
				case 4:
				{
					DialogOptionVar2[playerid] = 5;
					format(string, sizeof(string), "Please enter a value you wish to set %s's money to, it is currently set as %i", targetname, GetPlayerMoney(DialogOptionVar1[playerid]));
					ShowPlayerDialog(playerid, DIALOG_ASETSTAT2, DIALOG_STYLE_INPUT, "Player Stat Setting", string, "Accept", "Cancel");
				}
				case 5:
				{
					DialogOptionVar2[playerid] = 6;
					format(string, sizeof(string), "Please enter a value you wish to set %s's clan leadership to, it is currently set as %i", targetname, FoCo_Player[DialogOptionVar1[playerid]][clan]);
					ShowPlayerDialog(playerid, DIALOG_ASETSTAT2, DIALOG_STYLE_INPUT, "Player Stat Setting", string, "Accept", "Cancel");
				}
				case 6:
				{
					DialogOptionVar2[playerid] = 7;
					format(string, sizeof(string), "Please enter a value you wish to set %s's deaths to, it is currently set as %i", targetname, FoCo_Playerstats[DialogOptionVar1[playerid]][deaths]);
					ShowPlayerDialog(playerid, DIALOG_ASETSTAT2, DIALOG_STYLE_INPUT, "Player Stat Setting", string, "Accept", "Cancel");
				}
				case 7:
				{
					DialogOptionVar2[playerid] = 8;
					format(string, sizeof(string), "Please enter a value you wish to set %s's carkey to, it is currently set as %i.", targetname, FoCo_Player[DialogOptionVar1[playerid]][users_carid]);
					ShowPlayerDialog(playerid, DIALOG_ASETSTAT2, DIALOG_STYLE_INPUT, "Player Stat Setting", string, "Accept", "Cancel");
				}
			}
			return 1;
		}
		case DIALOG_ASETSTAT2:
		{
			if(!response) return 1;
			new targetname[56], adname[56];
			GetPlayerName(DialogOptionVar1[playerid], targetname, sizeof(targetname));
			GetPlayerName(playerid, adname, sizeof(adname));
			if(!IsNumeric(inputtext))
			{
				switch(DialogOptionVar2[playerid])
				{
					case 1:
					{
						format(string, sizeof(string), "Please enter a value you wish to set %s's skin to", targetname);
						ShowPlayerDialog(playerid, DIALOG_ASETSTAT2, DIALOG_STYLE_INPUT, "Player Stat Setting", string, "Accept", "Cancel");
					}
					case 2:
					{
						format(string, sizeof(string), "Please enter a value you wish to set %s's kills to, it is currently set as %i", targetname, FoCo_Playerstats[DialogOptionVar1[playerid]][kills]);
						ShowPlayerDialog(playerid, DIALOG_ASETSTAT2, DIALOG_STYLE_INPUT, "Player Stat Setting", string, "Accept", "Cancel");
					}
					case 3:
					{
						format(string, sizeof(string), "Please enter a value you wish to set %s's score to, it is currently set as %i", targetname, FoCo_Player[DialogOptionVar1[playerid]][score]);
						ShowPlayerDialog(playerid, DIALOG_ASETSTAT2, DIALOG_STYLE_INPUT, "Player Stat Setting", string, "Accept", "Cancel");
					}
					case 4:
					{
						format(string, sizeof(string), "Please enter a value you wish to set %s's level to, it is currently set as %i", targetname, FoCo_Player[DialogOptionVar1[playerid]][level]);
						ShowPlayerDialog(playerid, DIALOG_ASETSTAT2, DIALOG_STYLE_INPUT, "Player Stat Setting", string, "Accept", "Cancel");
					}
					case 5:
					{
						format(string, sizeof(string), "Please enter a value you wish to set %s's money to, it is currently set as %i", targetname, GetPlayerMoney(DialogOptionVar1[playerid]));
						ShowPlayerDialog(playerid, DIALOG_ASETSTAT2, DIALOG_STYLE_INPUT, "Player Stat Setting", string, "Accept", "Cancel");
					}
					case 6:
					{
						format(string, sizeof(string), "Please enter a value you wish to set %s's clan leadership to, it is currently set as %i", targetname, GetPlayerMoney(DialogOptionVar1[playerid]));
						ShowPlayerDialog(playerid, DIALOG_ASETSTAT2, DIALOG_STYLE_INPUT, "Player Stat Setting", string, "Accept", "Cancel");
					}
					case 7:
					{
						format(string, sizeof(string), "Please enter a value you wish to set %s's deaths to, it is currently set as %i", targetname, FoCo_Playerstats[DialogOptionVar1[playerid]][deaths]);
						ShowPlayerDialog(playerid, DIALOG_ASETSTAT2, DIALOG_STYLE_INPUT, "Player Stat Setting", string, "Accept", "Cancel");
					}
				}
				SendClientMessage(playerid, COLOR_WARNING, "               Your input can only contain numbers for this dialog.");
				return 1;
			}
			switch(DialogOptionVar2[playerid])
			{
				case 1:
				{
					if(IsValidSkin(strval(inputtext)))
					{
						format(string, sizeof(string), "               You have set %s's skin to %i", targetname, strval(inputtext));
						SendClientMessage(playerid, COLOR_CMDNOTICE, string);
						format(string, sizeof(string), "               %s %s has set your skin to %i", GetPlayerStatus(playerid), adname, strval(inputtext));
						SendClientMessage(DialogOptionVar1[playerid], COLOR_NOTICE, string);
						format(string, sizeof(string), "AdmCmd(3): %s %s has set %s's skin to %d", GetPlayerStatus(playerid), adname, targetname, strval(inputtext));
						SendAdminMessage(4,string);
						IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
						FoCo_Player[DialogOptionVar1[playerid]][skin] = strval(inputtext);
						SetPlayerSkin(DialogOptionVar1[playerid], strval(inputtext));
					}
					else
					{
						format(string, sizeof(string), "[ERROR]: %i is an invalid skin ID.", strval(inputtext));
						SendClientMessage(playerid, COLOR_WARNING, string);
					}
					return 1;
				}
				case 2:
				{
					format(string, sizeof(string), "               You have set %s's kills to %i", targetname, strval(inputtext));
					SendClientMessage(playerid, COLOR_CMDNOTICE, string);
					format(string, sizeof(string), "               %s %s has set your kills to %i", GetPlayerStatus(playerid),  adname,strval(inputtext));
					SendClientMessage(DialogOptionVar1[playerid], COLOR_NOTICE, string);
					format(string, sizeof(string), "AdmCmd(3): %s %s has set %s's kills to %d", GetPlayerStatus(playerid), adname, targetname, strval(inputtext));
					SendAdminMessage(4,string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					FoCo_Playerstats[DialogOptionVar1[playerid]][kills] = strval(inputtext);
					SetPlayerScore(DialogOptionVar1[playerid], strval(inputtext));
				}
				case 3:
				{
					format(string, sizeof(string), "               You have set %s's score to %i", targetname, strval(inputtext));
					SendClientMessage(playerid, COLOR_CMDNOTICE, string);
					format(string, sizeof(string), "               %s %s has set your score to %i", GetPlayerStatus(playerid), adname, strval(inputtext));
					SendClientMessage(DialogOptionVar1[playerid], COLOR_NOTICE, string);
					format(string, sizeof(string), "AdmCmd(3): %s %s has set %s's score to %d", GetPlayerStatus(playerid), adname, targetname, strval(inputtext));
					SendAdminMessage(4,string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					FoCo_Player[DialogOptionVar1[playerid]][score] = strval(inputtext);
				}
				case 4:
				{
					if(strval(inputtext) > 10) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Nothing higher then level ten can be set");
					format(string, sizeof(string), "               You have set %s's level to %i", targetname, strval(inputtext));
					SendClientMessage(playerid, COLOR_CMDNOTICE, string);
					format(string, sizeof(string), "               %s %s has set your level to %i", GetPlayerStatus(playerid),  adname,strval(inputtext));
					SendClientMessage(DialogOptionVar1[playerid], COLOR_NOTICE, string);
					format(string, sizeof(string), "AdmCmd(3): %s %s has set %s's level to %d", GetPlayerStatus(playerid), adname, targetname, strval(inputtext));
					SendAdminMessage(4,string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					FoCo_Player[DialogOptionVar1[playerid]][level] = strval(inputtext);
				}
				case 5:
				{
					format(string, sizeof(string), "               You have set %s's money to %i", targetname, strval(inputtext));
					SendClientMessage(playerid, COLOR_CMDNOTICE, string);
					format(string, sizeof(string), "               %s %s has set your money to %i", GetPlayerStatus(playerid), adname, strval(inputtext));
					SendClientMessage(DialogOptionVar1[playerid], COLOR_NOTICE, string);
					format(string, sizeof(string), "AdmCmd(3): %s %s has set %s's money to $%d", GetPlayerStatus(playerid), adname, targetname, strval(inputtext));
					SendAdminMessage(4,string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					#if defined GuardianProtected
						SetPlayerMoney(DialogOptionVar1[playerid], strval(inputtext));
					#endif
				}
				case 6:
				{
					if(FoCo_Teams[strval(inputtext)][team_type] == 1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot set someone leader of a global team");
						return 1;
					}
					format(string, sizeof(string), "               You have set %s's clan leadership to %i", targetname, strval(inputtext));
					SendClientMessage(playerid, COLOR_CMDNOTICE, string);
					format(string, sizeof(string), "               %s %s has set your clan leadership to ID %i", GetPlayerStatus(playerid), adname, strval(inputtext));
					SendClientMessage(DialogOptionVar1[playerid], COLOR_NOTICE, string);
					format(string, sizeof(string), "AdmCmd(3): %s %s has set %s's clan leadership to %d", GetPlayerStatus(playerid), adname, targetname, strval(inputtext));
					SendAdminMessage(4,string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					FoCo_Player[DialogOptionVar1[playerid]][clan] = FoCo_Teams[strval(inputtext)][db_id];
					FoCo_Player[DialogOptionVar1[playerid]][clanrank] = 1;
				}
				case 7:
				{
					format(string, sizeof(string), "               You have set %s's deaths to %i", targetname, strval(inputtext));
					SendClientMessage(playerid, COLOR_CMDNOTICE, string);
					format(string, sizeof(string), "               %s %s has set your deaths to %i", GetPlayerStatus(playerid),  adname,strval(inputtext));
					SendClientMessage(DialogOptionVar1[playerid], COLOR_NOTICE, string);
					format(string, sizeof(string), "AdmCmd(3): %s %s has set %s's deaths to %d", GetPlayerStatus(playerid), adname, targetname, strval(inputtext));
					SendAdminMessage(4,string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					FoCo_Playerstats[DialogOptionVar1[playerid]][deaths] = strval(inputtext);
				}
				case 8:
				{
					format(string, sizeof(string), "               You have set %s's carkey to %i", targetname, strval(inputtext));
					SendClientMessage(playerid, COLOR_CMDNOTICE, string);
					format(string, sizeof(string), "               %s %s has set your carkey to %i", GetPlayerStatus(playerid),  adname,strval(inputtext));
					SendClientMessage(DialogOptionVar1[playerid], COLOR_NOTICE, string);
					format(string, sizeof(string), "AdmCmd(3): %s %s has set %s's carkey to %d", GetPlayerStatus(playerid), adname, targetname, strval(inputtext));
					SendAdminMessage(4,string);
					new car_update[150];
					format(car_update, sizeof(car_update), "UPDATE `FoCo_Players` SET `carid` = '%d' WHERE `ID` = '%d'", strval(inputtext), FoCo_Player[DialogOptionVar1[playerid]][id]);
					mysql_query(car_update, MYSQL_UP_CAR_KEY,  playerid, con);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					FoCo_Player[DialogOptionVar1[playerid]][users_carid] = strval(inputtext);
				}
			}
			return 1;
		}
		case DIALOG_ANITROUSBOOST:
		{
			if(!response)
			{
				return 1;
			}
			NitrousBoostEn[playerid] = listitem;
			SendClientMessage(playerid, COLOR_CMDNOTICE, "               You have just set your nitrous speed. Use your normal nitrous button to use it.");
			return 1;
		}
		case DIALOG_NEON:
		{
			if(!response) return 1;
			if(!IsPlayerInAnyVehicle(playerid)) return 1;
			switch(listitem)
			{
				case 0:
				{
					new vehid = GetPlayerVehicleID(playerid);
					neon[vehid] = CreateObject(18648,0,0,0,0,0,0);
					neon2[vehid] = CreateObject(18648,0,0,0,0,0,0);
					AttachObjectToVehicle(neon[vehid], vehid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon2[vehid], vehid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					GameTextForPlayer(playerid, "~w~Neon ~g~ Activated!", 4000, 3);
				}
				case 1:
				{
					new vehid = GetPlayerVehicleID(playerid);
					neon[vehid] = CreateObject(18647,0,0,0,0,0,0);
					neon2[vehid] = CreateObject(18647,0,0,0,0,0,0);
					AttachObjectToVehicle(neon[vehid], vehid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon2[vehid], vehid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					GameTextForPlayer(playerid, "~w~Neon ~g~ Activated!", 4000, 3);
				}
				case 2:
				{
					new vehid = GetPlayerVehicleID(playerid);
					neon[vehid] = CreateObject(18649,0,0,0,0,0,0);
					neon2[vehid] = CreateObject(18649,0,0,0,0,0,0);
					AttachObjectToVehicle(neon[vehid], vehid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon2[vehid], vehid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					GameTextForPlayer(playerid, "~w~Neon ~g~ Activated!", 4000, 3);
				}
				case 3:
				{
					new vehid = GetPlayerVehicleID(playerid);
					neon[vehid] = CreateObject(18652,0,0,0,0,0,0);
					neon2[vehid] = CreateObject(18652,0,0,0,0,0,0);
					AttachObjectToVehicle(neon[vehid], vehid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon2[vehid], vehid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					GameTextForPlayer(playerid, "~w~Neon ~g~ Activated!", 4000, 3);
				}
				case 4:
				{
					new vehid = GetPlayerVehicleID(playerid);
					neon[vehid] = CreateObject(18651,0,0,0,0,0,0);
					neon2[vehid] = CreateObject(18651,0,0,0,0,0,0);
					AttachObjectToVehicle(neon[vehid], vehid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon2[vehid], vehid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					GameTextForPlayer(playerid, "~w~Neon ~g~ Activated!", 4000, 3);
				}
				case 5:
				{
					new vehid = GetPlayerVehicleID(playerid);
					neon[vehid] = CreateObject(18650,0,0,0,0,0,0);
					neon2[vehid] = CreateObject(18650,0,0,0,0,0,0);
					AttachObjectToVehicle(neon[vehid], vehid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon2[vehid], vehid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					GameTextForPlayer(playerid, "~w~Neon ~g~ Activated!", 4000, 3);
				}
			}
			return 1;
		}
		case DIALOG_PICKUP1:
		{
			if(!response) return 1;
			new size[128];
			format(size, sizeof(size), "%s", inputtext);
			DialogOptionVar3[playerid] = size;
			ShowPlayerDialog(playerid, DIALOG_PICKUP2, DIALOG_STYLE_INPUT, "Pickup ID", "Please insert below the pickup ID (NOTE: I icons are pickup 1239)", "Commit", "Cancel");
			return 1;
		}
		case DIALOG_PICKUP2:
		{
			if(!response) return 1;

			pickupdelID[playerid] = strval(inputtext);
			ShowPlayerDialog(playerid, DIALOG_PICKUP4, DIALOG_STYLE_INPUT, "Pickup Type", "Please insert the pickup type below. (NOTE: only pickup 19 should be used unless talking to Shaney first)", "Commit", "Cancel");
			return 1;
		}
		case DIALOG_PICKUP4:
		{
			if(!response) return 1;

			pickup_type[playerid] = strval(inputtext);
			ShowPlayerDialog(playerid, DIALOG_PICKUP5, DIALOG_STYLE_LIST, "Pickup Type", "1. Health\n2. Armour\n3. Weapon\n4. Ammu-Nation", "Select", "Close");
			return 1;
		}
		case DIALOG_PICKUP5:
		{
			if(!response) return 1;

			switch(listitem)
			{
				case 0:
				{
					pickup_list_selection[playerid] = 1;
					ShowPlayerDialog(playerid, DIALOG_PICKUP6, DIALOG_STYLE_INPUT, "Pickup Value", "Select the amount of health the user will be issued", "Select", "Close");
				}
				case 1:
				{
					pickup_list_selection[playerid] = 2;
					ShowPlayerDialog(playerid, DIALOG_PICKUP6, DIALOG_STYLE_INPUT, "Pickup Value", "Select the amount of armour the user will be issued", "Select", "Close");
				}
				case 2:
				{
					pickup_list_selection[playerid] = 3;
					ShowPlayerDialog(playerid, DIALOG_PICKUP6, DIALOG_STYLE_INPUT, "Pickup Value", "Select the weapon id the user will be issued", "Select", "Close");
				}
				case 3:
				{
					pickup_list_selection[playerid] = 4;
					ShowPlayerDialog(playerid, DIALOG_PICKUP3, DIALOG_STYLE_MSGBOX, "Pickup Created", "Pickup Created - Press \" Select \" to insert the pickup ", "Select", "Close");
				}
			}
			return 1;
		}
		case DIALOG_PICKUP6:
		{
			if(!response) return 1;

			if(pickup_list_selection[playerid] == 3 && strval(inputtext) == 35 || strval(inputtext) == 36 || strval(inputtext) == 38)
			{
				ShowPlayerDialog(playerid, DIALOG_PICKUP6, DIALOG_STYLE_INPUT, "Pickup Value", "Invalid weapon selection, pick something else.", "Select", "Close");
				return 1;
			}

			pickup_list_var1[playerid] = strval(inputtext);
			ShowPlayerDialog(playerid, DIALOG_PICKUP3, DIALOG_STYLE_MSGBOX, "Pickup Created", "Pickup Created - Press \" Select \" to insert the pickup ", "Select", "Close");
			return 1;
		}
		case DIALOG_PICKUP3:
		{
			if(!response)
			{
				return 1;
			}

			mysql_query("SELECT MAX(ID) FROM `FoCo_Pickups`", MYSQL_PICKUP_THREAD, playerid, con);
			return 1;
		}
		case DIALOG_PICKUPDEL:
		{
			if(!response)
			{
				SendClientMessage(playerid, COLOR_WARNING, "Pickup was not deleted.");
				return 1;
			}

			new adname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, adname, sizeof(adname));

			DestroyDynamicPickup(pickupdelID[playerid]);
			format(string, sizeof(string), "AdmCmd(5): %s %s has deleted pickup ID: %d", GetPlayerStatus(playerid), adname, pickupdelID[playerid]);
			SendAdminMessage(5,string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
			format(string, sizeof(string), "DELETE FROM `FoCo_Pickups` WHERE `ID` ='%d'", FoCo_Pickups[pickupdelID[playerid]][LP_DBID]);
			return 1;
		}
		case DIALOG_PICKUPMOVE:
		{
			if(!response)
			{
				SendClientMessage(playerid, COLOR_WARNING, "Pickup was not moved.");
				return 1;
			}

			new adname[MAX_PLAYER_NAME], Float:PosX, Float: PosY, Float: PosZ, val, pickid = pickupdelID[playerid];
			GetPlayerName(playerid, adname, sizeof(adname));
			GetPlayerPos(playerid, PosX, PosY, PosZ);

			FoCo_Pickups[pickid][LP_x] = PosX;
			FoCo_Pickups[pickid][LP_y] = PosY;
			FoCo_Pickups[pickid][LP_z] = PosZ;

			DestroyDynamicPickup(pickid);
			val = CreateDynamicPickup(FoCo_Pickups[pickid][LP_pickupid], FoCo_Pickups[pickid][LP_type], FoCo_Pickups[pickid][LP_x], FoCo_Pickups[pickid][LP_y], FoCo_Pickups[pickid][LP_z], FoCo_Pickups[pickid][LP_world], FoCo_Pickups[pickid][LP_interior], -1, FLOAT_PICKUP_DISTANCE);

			FoCo_Pickups[pickid][LP_IGID] = val;

			format(string, sizeof(string), "AdmCmd(5): %s %s has moved pickup ID: %d", GetPlayerStatus(playerid), adname, pickupdelID[playerid]);
			SendAdminMessage(5,string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SavePickups(pickupdelID[playerid]);
			return 1;
		}
		case DIALOG_CLASS_TOOLS:
		{
			if(!response) return 1;
			if(IsPlayerInAnyVehicle(playerid) == 1)
			{
				return 1;
			}

			switch(listitem)
			{
				case 0:
				{
					LoadClassString(playerid, 0);
				}
				case 1:
				{
					LoadClassString(playerid, 1);
				}
			}
			return 1;
		}
		case DIALOG_CLASSES:
		{
			if(IsPlayerInAnyVehicle(playerid) == 1)
			{
				return 1;
			}
			if(!response)
			{
				ShowPlayerDialog(playerid, DIALOG_CLASS_TOOLS, DIALOG_STYLE_LIST, "Class Tools", "1) Change Class\n2) Edit Class", "Select", "Close");
				return 1;
			}

			new item;
			sscanf(inputtext, "i", item);

			GiveClass(playerid, item);
			return 1;
		}
		case DIALOG_CLASS_EDIT:
		{
			if(IsPlayerInAnyVehicle(playerid) == 1)
			{
				return 1;
			}
			if(!response) return ShowPlayerDialog(playerid, DIALOG_CLASS_TOOLS, DIALOG_STYLE_LIST, "Class Tools", "1) Change Class\n2) Edit Class", "Select", "Close");

			new item;
			sscanf(inputtext, "i", item);

			DialogOptionVar5[playerid] = item;
			ShowPlayerDialog(playerid, DIALOG_EDIT_CLASS, DIALOG_STYLE_LIST, "Create a class", "Melee\nHand-Guns\nShot-Guns\nSubmachine Guns\nAssault Rifles\nRifles", "Select", "Back");
			//ShowPlayerDialog(playerid, DIALOG_EDIT_CLASS, DIALOG_STYLE_LIST, "Create a class", "Main Weapon\nSecondary Weapon\nSide Arm\nAdditional", "Select", "Back");
			return 1;
		}
		case DIALOG_EDIT_CLASS:
		{
			if(IsPlayerInAnyVehicle(playerid) == 1)
			{
				return 1;
			}
			if(!response)
			{
				ShowPlayerDialog(playerid, DIALOG_CLASS_TOOLS, DIALOG_STYLE_LIST, "Class Tools", "1) Change Class\n2) Edit Class", "Select", "Close");
				return 1;
			}

			switch(listitem)
			{
				case 0:
				{
					// Melee Weapon
					DialogOptionVar2[playerid] = 1;
					ShowPlayerDialog(playerid, DIALOG_CLASS_GUN, DIALOG_STYLE_LIST, "Select a Melee weapon", Class_Weapons(playerid, 1), "Submit", "Cancel");
				}
				case 1:
				{
					// Hand Guns weapon
					DialogOptionVar2[playerid] = 2;
					ShowPlayerDialog(playerid, DIALOG_CLASS_GUN, DIALOG_STYLE_LIST, "Select a Hand-gun for this class", Class_Weapons(playerid, 2), "Submit", "Cancel");
				}
				case 2:
				{
					// Shot Guns
					DialogOptionVar2[playerid] = 3;
					ShowPlayerDialog(playerid, DIALOG_CLASS_GUN, DIALOG_STYLE_LIST, "Select a Shotgun for this class", Class_Weapons(playerid, 3), "Submit", "Cancel");
				}
				case 3:
				{
					// Sub Machine Guns
					DialogOptionVar2[playerid] = 4;
					ShowPlayerDialog(playerid, DIALOG_CLASS_GUN, DIALOG_STYLE_LIST, "Select a Submachine Gun for this class", Class_Weapons(playerid, 4), "Submit", "Cancel");
				}
				case 4:
				{
					// Assault Rifles
					DialogOptionVar2[playerid] = 5;
					ShowPlayerDialog(playerid, DIALOG_CLASS_GUN, DIALOG_STYLE_LIST, "Select a Assault Rifle for this class", Class_Weapons(playerid, 5), "Submit", "Cancel");
				}
				case 5:
				{
					// Rifles
					DialogOptionVar2[playerid] = 6;
					ShowPlayerDialog(playerid, DIALOG_CLASS_GUN, DIALOG_STYLE_LIST, "Select a Rifle for this class", Class_Weapons(playerid, 6), "Submit", "Cancel");
				}
			}
			return 1;
		}
		case DIALOG_CLASS_GUN:
		{
			if(IsPlayerInAnyVehicle(playerid) == 1)
			{
				return 1;
			}
			if(!response) return SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: /class to change your class loadout near spawn.");

			new item;
			sscanf(inputtext, "i", item);

			weaponEditing[playerid] = item;

			updateClasses(playerid, DialogOptionVar5[playerid], DialogOptionVar2[playerid], weaponEditing[playerid]);

			ShowPlayerDialog(playerid, DIALOG_EDIT_CLASS, DIALOG_STYLE_LIST, "Create a class", "Melee\nHand-Guns\nShot-Guns\nSubmachine Guns\nAssault Rifles\nRifles", "Select", "Back");
			return 1;
		}
		case DIALOG_TEAMDEL:
		{
			if(!response)
			{
				SendClientMessage(playerid, COLOR_WARNING, "Team was not deleted.");
				return 1;
			}

			new adname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, adname, sizeof(adname));

			Iter_Remove(FoCoTeams, pickupdelID[playerid]);

			FoCo_Teams[pickupdelID[playerid]][team_rank_amount] = 0;
			FoCo_Teams[pickupdelID[playerid]][team_rank_1] = 0;
			FoCo_Teams[pickupdelID[playerid]][team_rank_2] = 0;
			FoCo_Teams[pickupdelID[playerid]][team_rank_3] = 0;
			FoCo_Teams[pickupdelID[playerid]][team_rank_4] = 0;
			FoCo_Teams[pickupdelID[playerid]][team_rank_5] = 0;
			FoCo_Teams[pickupdelID[playerid]][team_skin_1] = 0;
			FoCo_Teams[pickupdelID[playerid]][team_skin_2] = 0;
			FoCo_Teams[pickupdelID[playerid]][team_skin_3] = 0;
			FoCo_Teams[pickupdelID[playerid]][team_skin_4] = 0;
			FoCo_Teams[pickupdelID[playerid]][team_skin_5] = 0;
			FoCo_Teams[pickupdelID[playerid]][team_spawn_x] = 0.0;
			FoCo_Teams[pickupdelID[playerid]][team_spawn_y] = 0.0;
			FoCo_Teams[pickupdelID[playerid]][team_spawn_z] = 0.0;
			FoCo_Teams[pickupdelID[playerid]][team_spawn_interior] = 0;
			FoCo_Teams[pickupdelID[playerid]][team_spawn_world] = 0;
			FoCo_Teams[pickupdelID[playerid]][team_max_members] = 0;
			FoCo_Teams[pickupdelID[playerid]][team_type] = 0;

			format(string, sizeof(string), "AdmCmd(4): %s %s has deleted team ID: %d", GetPlayerStatus(playerid), adname, pickupdelID[playerid]);
			SendAdminMessage(4,string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			format(string, sizeof(string), "DELETE FROM `FoCo_Teams` WHERE `ID` ='%d'", FoCo_Teams[pickupdelID[playerid]][db_id]);
			mysql_query(string, MYSQL_DEL_TEAM, FoCo_Teams[pickupdelID[playerid]][db_id], con);
			FoCo_Teams[pickupdelID[playerid]][db_id] = 0;
			return 1;
		}
		case DIALOG_TEAMINFO:
		{
			if(!response) return 1;

			new item;
			sscanf(inputtext, "i", item);
			DialogOptionVar1[playerid] = item;

			format(string, sizeof(string), "TeamIGID: %d \nTeam: %s \n\nTeam_DBID: %d \nTeam Color: %s \nTeam Rank Amount: %d \nTeam Rank1: %s \nTeam Rank2: %s \nTeam Rank3: %s \nTeam Rank4: %s \nTeam Rank5: %s", item, FoCo_Teams[item][team_name], FoCo_Teams[item][db_id], FoCo_Teams[item][team_color], FoCo_Teams[item][team_rank_amount], FoCo_Teams[item][team_rank_1], FoCo_Teams[item][team_rank_2], FoCo_Teams[item][team_rank_3], FoCo_Teams[item][team_rank_4], FoCo_Teams[item][team_rank_5]);

			ShowPlayerDialog(playerid, DIALOG_TEAMINFO2, DIALOG_STYLE_MSGBOX, "Team Selected Info", string, "Next Page", "Cancel");
			return 1;
		}
		case DIALOG_TEAMINFO2:
		{
			if(!response) return 1;

			new item;
			item = DialogOptionVar1[playerid];

			format(string, sizeof(string), "Team skin1: %d \n Team Skin2: %d \n Team Skin3: %d \n Team Skin4: %d \n Team Skin5: %d \n Team SpawnX: %f \n Team SpawnY: %f \n Team SpawnZ: %f \n Team Spawn INT: %d \n Team Spawn World: %d \n Team MAX members: %d \n Team Type: %d",
				FoCo_Teams[item][team_skin_1], FoCo_Teams[item][team_skin_2], FoCo_Teams[item][team_skin_3], FoCo_Teams[item][team_skin_4], FoCo_Teams[item][team_skin_5], FoCo_Teams[item][team_spawn_x], FoCo_Teams[item][team_spawn_y], FoCo_Teams[item][team_spawn_z], FoCo_Teams[item][team_spawn_interior], FoCo_Teams[item][team_spawn_world], FoCo_Teams[item][team_max_members], FoCo_Teams[item][team_type]);

			ShowPlayerDialog(playerid, DIALOG_TEAMINFO3, DIALOG_STYLE_MSGBOX, "Team Selected Info", string, "O", "K");
			return 1;
		}
		case DIALOG_TEAMINFO3:
		{
			return 1;
		}
		case DIALOG_CREATETEAM:
		{
			if(!response && DialogOptionVar1[playerid] == 65535)
			{
				CallLocalFunction("OnDialogResponse", "d", playerid, "d", DIALOG_EDITTEAM1, "d", 1, "d", DialogOptionVar2[playerid], "s", "n/a");//calls the original dialog
				return 1;
			}
			else if(!response)
			{
				return 1;
			}

			new Float:team_x, Float:team_y, Float:team_z, pname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pname, sizeof(pname));
			GetPlayerPos(playerid, team_x, team_y, team_z);

			if(DialogOptionVar1[playerid] != 65535)
			{
				new tsize[35];
				format(tsize, sizeof(tsize), "%s", inputtext);
				teamSize[playerid] = tsize;
				mysql_query("SELECT MAX(ID) FROM `FoCo_Teams`", MYSQL_CREATE_TEAM_THREAD, playerid, con);
			}
			else
			{
				FoCo_Teams[DialogOptionVar2[playerid]][team_spawn_x] = team_x;
				FoCo_Teams[DialogOptionVar2[playerid]][team_spawn_y] = team_y;
				FoCo_Teams[DialogOptionVar2[playerid]][team_spawn_z] = team_z;
				format(string, sizeof(string), "AdmCmd(4): %s has edited clan %s's spawn location", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}
			SaveTeam(DialogOptionVar2[playerid]);
			return 1;
		}
		case DIALOG_CREATETEAM2:
		{
			if(!response && DialogOptionVar1[playerid] == 65535)
			{
				OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
				return 1;
			}
			else if(!response)
			{
				return 1;
			}
			new size[20];
			format(size, sizeof(size), "%s", inputtext);
			FoCo_Teams[DialogOptionVar2[playerid]][team_color] = size;

			if(DialogOptionVar1[playerid] != 65535)
			{
				ShowPlayerDialog(playerid, DIALOG_CREATETEAM3, DIALOG_STYLE_MSGBOX, "Team Creation", "Should this team be public or private? (Public = anyone can use) (Private = Clan)", "Public", "Private");
			}
			else
			{
				new pname[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pname, sizeof(pname));
				format(string, sizeof(string), "AdmCmd(4): %s has edited clan '%s's' color", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
				SendAdminMessage(4,string);
			}
			SaveTeam(DialogOptionVar2[playerid]);
			return 1;
		}
		case DIALOG_CREATETEAM3:
		{
			if(!response && DialogOptionVar1[playerid] == 65535)
			{
				OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
				return 1;
			}
			else if(!response)
			{
				FoCo_Teams[DialogOptionVar2[playerid]][team_type] = 2;
				ShowPlayerDialog(playerid, DIALOG_CREATETEAM4, DIALOG_STYLE_INPUT, "Team Creation", "Please select the amount of max members", "Continue", "Close");
				return 1;
			}

			new size[20];
			FoCo_Teams[DialogOptionVar2[playerid]][team_type] = 3;
			FoCo_Teams[DialogOptionVar2[playerid]][team_rank_amount] = 1;
			format(size, sizeof(size), "Team Member");
			FoCo_Teams[DialogOptionVar2[playerid]][team_rank_1] = size;

			if(DialogOptionVar1[playerid] != 65535)
			{
				ShowPlayerDialog(playerid, DIALOG_CREATETEAM5, DIALOG_STYLE_INPUT, "Team Creation", "Please select the Skin ID that this PUBLIC Group will use", "Finalize", "Close");
			}
			else
			{
				new pname[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pname, sizeof(pname));
				format(string, sizeof(string), "AdmCmd(4): %s has edited clan '%s's' accesibility", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}
			return 1;
		}
		case DIALOG_CREATETEAM4:
		{
			if(!response && DialogOptionVar1[playerid] == 65535)
			{
				OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
				return 1;
			}
			else if(!response)
			{
				SaveTeam(DialogOptionVar2[playerid]);
				return 1;
			}
			if(DialogOptionVar1[playerid] == 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
				{
					OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
					return 1;
				}
			}
			FoCo_Teams[DialogOptionVar2[playerid]][team_max_members] = strval(inputtext);

			if(DialogOptionVar1[playerid] != 65535)
			{
				ShowPlayerDialog(playerid, DIALOG_CREATETEAM6, DIALOG_STYLE_INPUT, "Team Creation", "How many ranks should this team have? (1 - 5 only)", "Continue", "Close");
			}
			else
			{
				new pname[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pname, sizeof(pname));
				format(string, sizeof(string), "AdmCmd(4): %s has edited clan '%s's' max members", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}
			SaveTeam(DialogOptionVar2[playerid]);
			return 1;
		}
		case DIALOG_CREATETEAM5:
		{
			if(!response && DialogOptionVar1[playerid] == 65535)
			{
				OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
				return 1;
			}
			else if(!response)
			{
				SaveTeam(DialogOptionVar2[playerid]);
				return 1;
			}
			if(DialogOptionVar1[playerid] == 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 2)
				{
					OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
					return 1;
				}
			}
			FoCo_Teams[DialogOptionVar2[playerid]][team_skin_1] = strval(inputtext);


			if(DialogOptionVar1[playerid] != 65535)
			{
				new pname[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pname, sizeof(pname));
				format(string, sizeof(string), "AdmCmd(4): %s has completed creating a GLOBAL clan", pname);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}
			else
			{
				new pname[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pname, sizeof(pname));
				format(string, sizeof(string), "AdmCmd(4): %s has edited clan '%s's' public skin", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}

			SaveTeam(DialogOptionVar2[playerid]);
			return 1;
		}
		case DIALOG_CREATETEAM6:
		{
			if(!response && DialogOptionVar1[playerid] == 65535)
			{
				OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
				return 1;
			}
			else if(!response)
			{
				SaveTeam(DialogOptionVar2[playerid]);
				return 1;
			}
			if(DialogOptionVar1[playerid] == 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
				{
					OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
					return 1;
				}
			}
			if(strval(inputtext) > 5 || strval(inputtext) < 1)
			{
				ShowPlayerDialog(playerid, DIALOG_CREATETEAM6, DIALOG_STYLE_INPUT, "Team Creation", "How many ranks should this team have? (1 - 5 only)", "Continue", "Close");
				return 1;
			}

			FoCo_Teams[DialogOptionVar2[playerid]][team_rank_amount] = strval(inputtext);

			if(DialogOptionVar1[playerid] != 65535)
			{
				ShowPlayerDialog(playerid, DIALOG_CREATETEAM7, DIALOG_STYLE_INPUT, "Team Creation", "Choose the name for the leader rank", "Continue", "Close");
			}
			else
			{
				new pname[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pname, sizeof(pname));
				format(string, sizeof(string), "AdmCmd(4): %s has edited clan '%s's' max rank", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}
			SaveTeam(DialogOptionVar2[playerid]);
			return 1;
		}
		case DIALOG_CREATETEAM7:
		{
			if(!response && DialogOptionVar1[playerid] == 65535)
			{
				OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
				return 1;
			}
			else if(!response)
			{
				SaveTeam(DialogOptionVar2[playerid]);
				return 1;
			}
			if(DialogOptionVar1[playerid] == 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
				{
					OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
					return 1;
				}
			}
			new size[20];
			format(size, sizeof(size), "%s", inputtext);
			FoCo_Teams[DialogOptionVar2[playerid]][team_rank_1] = size;

			if(DialogOptionVar1[playerid] != 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_rank_amount] > 1)
				{
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM8, DIALOG_STYLE_INPUT, "Team Creation", "Choose the name for the second rank", "Continue", "Close");
				}
				else
				{
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM12, DIALOG_STYLE_INPUT, "Team Creation", "Choose the skin for rank 1", "Continue", "Close");
				}
			}
			else
			{
				new pname[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pname, sizeof(pname));
				format(string, sizeof(string), "AdmCmd(4): %s has edited clan '%s's' rank 1 name", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}
			SaveTeam(DialogOptionVar2[playerid]);
			return 1;
		}
		case DIALOG_CREATETEAM8:
		{
			if(!response && DialogOptionVar1[playerid] == 65535)
			{
				OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
				return 1;
			}
			else if(!response)
			{
				SaveTeam(DialogOptionVar2[playerid]);
				return 1;
			}
			if(DialogOptionVar1[playerid] == 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
				{
					OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
					return 1;
				}
			}
			new size[20];
			format(size, sizeof(size), "%s", inputtext);
			FoCo_Teams[DialogOptionVar2[playerid]][team_rank_2] = size;

			if(DialogOptionVar1[playerid] != 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_rank_amount] > 2)
				{
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM9, DIALOG_STYLE_INPUT, "Team Creation", "Choose the name for the third rank", "Continue", "Close");
				}
				else
				{
					new pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, sizeof(pname));
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM12, DIALOG_STYLE_INPUT, "Team Creation", "Choose the skin for rank 1", "Continue", "Close");
				}
			}
			else
			{
				new pname[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pname, sizeof(pname));
				format(string, sizeof(string), "AdmCmd(4): %s has edited clan '%s's' rank 2 name", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}
			SaveTeam(DialogOptionVar2[playerid]);
			return 1;
		}
		case DIALOG_CREATETEAM9:
		{
			if(!response && DialogOptionVar1[playerid] == 65535)
			{
				OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
				return 1;
			}
			else if(!response)
			{
				SaveTeam(DialogOptionVar2[playerid]);
				return 1;
			}
			if(DialogOptionVar1[playerid] == 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
				{
					OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
					return 1;
				}
			}
			new size[20];
			format(size, sizeof(size), "%s", inputtext);
			FoCo_Teams[DialogOptionVar2[playerid]][team_rank_3] = size;

			if(DialogOptionVar1[playerid] != 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_rank_amount] > 3)
				{
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM10, DIALOG_STYLE_INPUT, "Team Creation", "Choose the name for the fourth rank", "Continue", "Close");
				}
				else
				{
					new pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, sizeof(pname));
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM12, DIALOG_STYLE_INPUT, "Team Creation", "Choose the skin for rank 1", "Continue", "Close");
				}

			}
			else
			{
				new pname[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pname, sizeof(pname));
				format(string, sizeof(string), "AdmCmd(4): %s has edited clan '%s's' rank 3 name", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}
			SaveTeam(DialogOptionVar2[playerid]);
			return 1;
		}
		case DIALOG_CREATETEAM10:
		{
			if(!response && DialogOptionVar1[playerid] == 65535)
			{
				OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
				return 1;
			}
			else if(!response)
			{
				SaveTeam(DialogOptionVar2[playerid]);
				return 1;
			}
			if(DialogOptionVar1[playerid] == 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
				{
					OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
					return 1;
				}
			}
			new size[20];
			format(size, sizeof(size), "%s", inputtext);
			FoCo_Teams[DialogOptionVar2[playerid]][team_rank_4] = size;

			if(DialogOptionVar1[playerid] != 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_rank_amount] > 4)
				{
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM11, DIALOG_STYLE_INPUT, "Team Creation", "Choose the name for the fifth rank", "Continue", "Close");
				}
				else
				{
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM12, DIALOG_STYLE_INPUT, "Team Creation", "Choose the skin for rank 1", "Continue", "Close");
				}
			}
			else
			{
				new pname[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pname, sizeof(pname));
				format(string, sizeof(string), "AdmCmd(4): %s has edited clan '%s's' rank 4 name", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}
			SaveTeam(DialogOptionVar2[playerid]);
			return 1;
		}
		case DIALOG_CREATETEAM11:
		{
			if(!response && DialogOptionVar1[playerid] == 65535)
			{
				OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
				return 1;
			}
			else if(!response)
			{
				SaveTeam(DialogOptionVar2[playerid]);
				return 1;
			}
			if(DialogOptionVar1[playerid] == 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
				{
					OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
					return 1;
				}
			}
			new size[20];
			format(size, sizeof(size), "%s", inputtext);
			FoCo_Teams[DialogOptionVar2[playerid]][team_rank_5] = size;

			if(DialogOptionVar1[playerid] != 65535)
			{
				ShowPlayerDialog(playerid, DIALOG_CREATETEAM12, DIALOG_STYLE_INPUT, "Team Creation", "Choose the skin for rank 1", "Continue", "Close");
			}
			else
			{
				new pname[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pname, sizeof(pname));
				format(string, sizeof(string), "AdmCmd(4): %s has edited clan '%s's' rank 5 name", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}
			SaveTeam(DialogOptionVar2[playerid]);
			return 1;
		}
		case DIALOG_CREATETEAM12:
		{
			if(!response && DialogOptionVar1[playerid] == 65535)
			{
				OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
				return 1;
			}
			else if(!response)
			{
				SaveTeam(DialogOptionVar2[playerid]);
				return 1;
			}
			if(DialogOptionVar1[playerid] == 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
				{
					OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
					return 1;
				}
			}
			if(strval(inputtext) > 285 || strval(inputtext) < 0)
			{
				ShowPlayerDialog(playerid, DIALOG_CREATETEAM12, DIALOG_STYLE_INPUT, "Team Creation", "Choose the skin for rank 1  ( 0 - 285 only )", "Continue", "Close");
				return 1;
			}
			FoCo_Teams[DialogOptionVar2[playerid]][team_skin_1] = strval(inputtext);
			if(DialogOptionVar1[playerid] != 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_rank_amount] > 1)
				{
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM13, DIALOG_STYLE_INPUT, "Team Creation", "Choose the skin for rank 2", "Continue", "Close");
				}
				else
				{
					new pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, sizeof(pname));
					format(string, sizeof(string), "AdmCmd(4): %s has completed creating a private clan", pname);
					SendAdminMessage(4,string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					//Iter_Add(FoCoTeams, DialogOptionVar2[playerid]);
				}
			}
			else
			{
				new pname[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pname, sizeof(pname));
				format(string, sizeof(string), "AdmCmd(4): %s has edited clan '%s's' rank 1 skin", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}
			SaveTeam(DialogOptionVar2[playerid]);
			return 1;
		}
		case DIALOG_CREATETEAM13:
		{
			if(!response && DialogOptionVar1[playerid] == 65535)
			{
				OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
				return 1;
			}
			else if(!response)
			{
				SaveTeam(DialogOptionVar2[playerid]);
				return 1;
			}
			if(DialogOptionVar1[playerid] == 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
				{
					OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
					return 1;
				}
			}
			if(strval(inputtext) > 285 || strval(inputtext) < 0)
			{
				ShowPlayerDialog(playerid, DIALOG_CREATETEAM13, DIALOG_STYLE_INPUT, "Team Creation", "Choose the skin for rank 2  ( 0 - 285 only )", "Continue", "Close");
				return 1;
			}

			FoCo_Teams[DialogOptionVar2[playerid]][team_skin_2] = strval(inputtext);

			if(DialogOptionVar1[playerid] != 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_rank_amount] > 2)
				{
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM14, DIALOG_STYLE_INPUT, "Team Creation", "Choose the skin for rank 3", "Continue", "Close");
				}
				else
				{
					new pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, sizeof(pname));
					format(string, sizeof(string), "AdmCmd(4): %s has completed creating a private clan", pname);
					SendAdminMessage(4,string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					//Iter_Add(FoCoTeams, DialogOptionVar2[playerid]);
				}
			}
			else
			{
				new pname[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pname, sizeof(pname));
				format(string, sizeof(string), "AdmCmd(4): %s has edited clan '%s's' rank 2 skin", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}
			SaveTeam(DialogOptionVar2[playerid]);
			return 1;
		}
		case DIALOG_CREATETEAM14:
		{
			if(!response && DialogOptionVar1[playerid] == 65535)
			{
				OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
				return 1;
			}
			else if(!response)
			{
				SaveTeam(DialogOptionVar2[playerid]);
				return 1;
			}
			if(DialogOptionVar1[playerid] == 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
				{
					OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
					return 1;
				}
			}
			if(strval(inputtext) > 285 || strval(inputtext) < 0)
			{
				ShowPlayerDialog(playerid, DIALOG_CREATETEAM14, DIALOG_STYLE_INPUT, "Team Creation", "Choose the skin for rank 3  ( 0 - 285 only )", "Continue", "Close");
				return 1;
			}

			FoCo_Teams[DialogOptionVar2[playerid]][team_skin_3] = strval(inputtext);

			if(DialogOptionVar1[playerid] != 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_rank_amount] > 3)
				{
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM15, DIALOG_STYLE_INPUT, "Team Creation", "Choose the skin for rank 4", "Continue", "Close");
				}
				else
				{
					new pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, sizeof(pname));
					format(string, sizeof(string), "AdmCmd(4): %s has completed creating a private clan", pname);
					SendAdminMessage(4,string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					//Iter_Add(FoCoTeams, DialogOptionVar2[playerid]);
				}
			}
			else
			{
				new pname[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pname, sizeof(pname));
				format(string, sizeof(string), "AdmCmd(4): %s has edited clan '%s's' rank 3 skin", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}
			SaveTeam(DialogOptionVar2[playerid]);
			return 1;
		}
		case DIALOG_CREATETEAM15:
		{
			if(!response && DialogOptionVar1[playerid] == 65535)
			{
				OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
				return 1;
			}
			else if(!response)
			{
				SaveTeam(DialogOptionVar2[playerid]);
				return 1;
			}
			if(DialogOptionVar1[playerid] == 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
				{
					OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
					return 1;
				}
			}
			if(strval(inputtext) > 285 || strval(inputtext) < 0)
			{
				ShowPlayerDialog(playerid, DIALOG_CREATETEAM15, DIALOG_STYLE_INPUT, "Team Creation", "Choose the skin for rank 4  ( 0 - 285 only )", "Continue", "Close");
				return 1;
			}

			FoCo_Teams[DialogOptionVar2[playerid]][team_skin_4] = strval(inputtext);
			if(DialogOptionVar1[playerid] != 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_rank_amount] > 4)
				{
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM16, DIALOG_STYLE_INPUT, "Team Creation", "Choose the skin for rank 5", "Continue", "Close");
				}
				else
				{
					new pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, sizeof(pname));
					format(string, sizeof(string), "AdmCmd(4): %s has completed creating a private clan", pname);
					SendAdminMessage(4,string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					//Iter_Add(FoCoTeams, DialogOptionVar2[playerid]);
				}
			}
			else
			{
				new pname[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pname, sizeof(pname));
				format(string, sizeof(string), "AdmCmd(4): %s has edited clan '%s's' rank 4 skin", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}
			SaveTeam(DialogOptionVar2[playerid]);
			return 1;
		}
		case DIALOG_CREATETEAM16:
		{
			if(!response && DialogOptionVar1[playerid] == 65535)
			{
				OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
				return 1;
			}
			else if(!response)
			{
				SaveTeam(DialogOptionVar2[playerid]);
				return 1;
			}
			if(DialogOptionVar1[playerid] == 65535)
			{
				if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
				{
					OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
					return 1;
				}
			}
			if(strval(inputtext) > 285 || strval(inputtext) < 0)
			{
				ShowPlayerDialog(playerid, DIALOG_CREATETEAM16, DIALOG_STYLE_INPUT, "Team Creation", "Choose the skin for rank 5  ( 0 - 285 only )", "Continue", "Close");
				return 1;
			}

			FoCo_Teams[DialogOptionVar2[playerid]][team_skin_5] = strval(inputtext);
			new pname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pname, sizeof(pname));
			if(DialogOptionVar1[playerid] != 65535)
			{
				format(string, sizeof(string), "AdmCmd(4): %s has completed creating a private clan. Use /pickups to create an armour symbol (ID: 1242, Type: 2)", pname);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
				//Iter_Add(FoCoTeams, DialogOptionVar2[playerid]);
			}
			else
			{
				format(string, sizeof(string), "AdmCmd(4): %s has edited clan '%s's' rank 5 skin", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
				SendAdminMessage(4,string);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			}
			SaveTeam(DialogOptionVar2[playerid]);
			return 1;
		}
		case DIALOG_EDITTEAM1:
		{
			if(!response)
			{
				return 1;
			}
			sscanf(inputtext, "i", DialogOptionVar2[playerid]);
			DialogOptionVar1[playerid] = 65535;
			format(string, sizeof(string), "{FFFFFF}Team Colour\nAccesibility");
			if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)//public/global
			{
				strins(string, "\n{4D4D4D}Max Members", strlen(string));
				strins(string, "\n{4D4D4D}Max Amount of Ranks{FFFFFF}", strlen(string));
				strins(string, "\nPublic Skin", strlen(string));
			}
			else
			{
				strins(string, "\nMax Members", strlen(string));
				strins(string, "\nMax Amount of Ranks", strlen(string));
				strins(string, "\n{4D4D4D}Public Skin{FFFFFF}", strlen(string));
			}
			if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 2)//private
			{
				switch(FoCo_Teams[DialogOptionVar2[playerid]][team_rank_amount])
				{
					case 1:
					{
						strins(string, "\nRank 1 Name", strlen(string));
						strins(string, "\nRank 1 Skin", strlen(string));
						strins(string, "\n{4D4D4D}Rank 2 Name", strlen(string));
						strins(string, "\n{4D4D4D}Rank 2 Skin", strlen(string));
						strins(string, "\n{4D4D4D}Rank 3 Name", strlen(string));
						strins(string, "\n{4D4D4D}Rank 3 Skin", strlen(string));
						strins(string, "\n{4D4D4D}Rank 4 Name", strlen(string));
						strins(string, "\n{4D4D4D}Rank 4 Skin", strlen(string));
						strins(string, "\n{4D4D4D}Rank 5 Name", strlen(string));
						strins(string, "\n{4D4D4D}Rank 5 Skin{FFFFFF}", strlen(string));
					}
					case 2:
					{
						strins(string, "\nRank 1 Name", strlen(string));
						strins(string, "\nRank 1 Skin", strlen(string));
						strins(string, "\nRank 2 Name", strlen(string));
						strins(string, "\nRank 2 Skin", strlen(string));
						strins(string, "\n{4D4D4D}Rank 3 Name", strlen(string));
						strins(string, "\n{4D4D4D}Rank 3 Skin", strlen(string));
						strins(string, "\n{4D4D4D}Rank 4 Name", strlen(string));
						strins(string, "\n{4D4D4D}Rank 4 Skin", strlen(string));
						strins(string, "\n{4D4D4D}Rank 5 Name", strlen(string));
						strins(string, "\n{4D4D4D}Rank 5 Skin{FFFFFF}", strlen(string));
					}
					case 3:
					{
						strins(string, "\nRank 1 Name", strlen(string));
						strins(string, "\nRank 1 Skin", strlen(string));
						strins(string, "\nRank 2 Name", strlen(string));
						strins(string, "\nRank 2 Skin", strlen(string));
						strins(string, "\nRank 3 Name", strlen(string));
						strins(string, "\nRank 3 Skin", strlen(string));
						strins(string, "\n{4D4D4D}Rank 4 Name", strlen(string));
						strins(string, "\n{4D4D4D}Rank 4 Skin", strlen(string));
						strins(string, "\n{4D4D4D}Rank 5 Name", strlen(string));
						strins(string, "\n{4D4D4D}Rank 5 Skin{FFFFFF}", strlen(string));
					}
					case 4:
					{
						strins(string, "\nRank 1 Name", strlen(string));
						strins(string, "\nRank 1 Skin", strlen(string));
						strins(string, "\nRank 2 Name", strlen(string));
						strins(string, "\nRank 2 Skin", strlen(string));
						strins(string, "\nRank 3 Name", strlen(string));
						strins(string, "\nRank 3 Skin", strlen(string));
						strins(string, "\nRank 4 Name", strlen(string));
						strins(string, "\nRank 4 Skin", strlen(string));
						strins(string, "\n{4D4D4D}Rank 5 Name", strlen(string));
						strins(string, "\n{4D4D4D}Rank 5 Skin{FFFFFF}", strlen(string));
					}
					case 5:
					{
						strins(string, "\nRank 1 Name", strlen(string));
						strins(string, "\nRank 1 Skin", strlen(string));
						strins(string, "\nRank 2 Name", strlen(string));
						strins(string, "\nRank 2 Skin", strlen(string));
						strins(string, "\nRank 3 Name", strlen(string));
						strins(string, "\nRank 3 Skin", strlen(string));
						strins(string, "\nRank 4 Name", strlen(string));
						strins(string, "\nRank 4 Skin", strlen(string));
						strins(string, "\nRank 5 Name", strlen(string));
						strins(string, "\n4Rank 5 Skin{FFFFFF}", strlen(string));
					}
				}
			}
			else
			{
				strins(string, "\n{4D4D4D}Rank 1 Name", strlen(string));
				strins(string, "\n{4D4D4D}Rank 1 Skin", strlen(string));
				strins(string, "\n{4D4D4D}Rank 2 Name", strlen(string));
				strins(string, "\n{4D4D4D}Rank 2 Skin", strlen(string));
				strins(string, "\n{4D4D4D}Rank 3 Name", strlen(string));
				strins(string, "\n{4D4D4D}Rank 3 Skin", strlen(string));
				strins(string, "\n{4D4D4D}Rank 4 Name", strlen(string));
				strins(string, "\n{4D4D4D}Rank 4 Skin", strlen(string));
				strins(string, "\n{4D4D4D}Rank 5 Name", strlen(string));
				strins(string, "\n{4D4D4D}Rank 5 Skin{FFFFFF}", strlen(string));
			}
			strins(string, "\nSpawn Position", strlen(string));
			strins(string, "\nName", strlen(string));
			ShowPlayerDialog(playerid, DIALOG_EDITTEAM2, DIALOG_STYLE_LIST, "Team Editing", string, "Select", "Cancel");
			return 1;
		}
		case DIALOG_EDITTEAM2:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM2, DIALOG_STYLE_INPUT, "Team Editing", "Please choose below the HEXADECIMAL colour you wish to use for this clans tag color \n\n ENSURE TO USE A HEX COLOR!", "Commit", "Go Back");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM3, DIALOG_STYLE_MSGBOX, "Team Editing", "Should this team be public or private? (Public = anyone can use) (Private = Clan)", "Public", "Private");
				}
				case 2:
				{
					if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
					{
						OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
						return 1;
					}
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM4, DIALOG_STYLE_INPUT, "Team Editing", "Please select the amount of max members", "Commit", "Go Back");
				}
				case 3:
				{
					if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
					{
						OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
						return 1;
					}
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM6, DIALOG_STYLE_INPUT, "Team Editing", "How many ranks should this team have? (1 - 5 only)", "Commit", "Go Back");
				}
				case 4:
				{
					if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 2)
					{
						OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
						return 1;
					}
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM5, DIALOG_STYLE_INPUT, "Team Editing", "Please select the Skin ID that this PUBLIC Group will use", "Finalize", "Go Back");
				}
				case 5:
				{
					if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
					{
						OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
						return 1;
					}
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM7, DIALOG_STYLE_INPUT, "Team Editing", "Choose the name for the leader rank", "Commit", "Go Back");
				}
				case 6:
				{
					if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
					{
						OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
						return 1;
					}
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM12, DIALOG_STYLE_INPUT, "Team Editing", "Choose the skin for rank 1", "Commit", "Go Back");
				}
				case 7:
				{
					if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
					{
						OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
						return 1;
					}
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM8, DIALOG_STYLE_INPUT, "Team Editing", "Choose the name for the second rank", "Commit", "Go Back");
				}
				case 8:
				{
					if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
					{
						OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
						return 1;
					}
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM13, DIALOG_STYLE_INPUT, "Team Editing", "Choose the skin for rank 2", "Commit", "Go Back");
				}
				case 9:
				{
					if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
					{
						OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
						return 1;
					}
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM9, DIALOG_STYLE_INPUT, "Team Editing", "Choose the name for the third rank", "Commit", "Go Back");
				}
				case 10:
				{
					if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
					{
						OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
						return 1;
					}
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM14, DIALOG_STYLE_INPUT, "Team Editing", "Choose the skin for rank 3", "Commit", "Go Back");
				}
				case 11:
				{
					if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
					{
						OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
						return 1;
					}
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM10, DIALOG_STYLE_INPUT, "Team Editing", "Choose the name for the fourth rank", "Commit", "Go Back");
				}
				case 12:
				{
					if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
					{
						OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
						return 1;
					}
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM15, DIALOG_STYLE_INPUT, "Team Editing", "Choose the skin for rank 4", "Commit", "Go Back");
				}
				case 13:
				{
					if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
					{
						OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
						return 1;
					}
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM11, DIALOG_STYLE_INPUT, "Team Editing", "Choose the name for the fifth rank", "Commit", "Go Back");
				}
				case 14:
				{
					if(FoCo_Teams[DialogOptionVar2[playerid]][team_type] == 1)
					{
						OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
						return 1;
					}
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM16, DIALOG_STYLE_INPUT, "Team Editing", "Choose the skin for rank 5", "Commit", "Go Back");
				}
				case 15:
				{
					ShowPlayerDialog(playerid, DIALOG_CREATETEAM, DIALOG_STYLE_MSGBOX, "Team Editing", "Would you like to change the teams spawn point to this location?", "Yes", "Go Back");
				}
				case 16:
				{
					ShowPlayerDialog(playerid, DIALOG_EDITTEAM3, DIALOG_STYLE_INPUT, "Team Editing", "Enter a name to change this team to.", "Commit", "Go Back");
				}
			}
		}
		case DIALOG_EDITTEAM3:
		{
			if(!response)
			{
				OnDialogResponse(playerid, DIALOG_EDITTEAM1, 1, DialogOptionVar2[playerid], "n/a");//calls the original dialog
				return 1;
			}
			new size[50];
			format(size, sizeof(size), "%s", inputtext);
			mysql_real_escape_string(size, size);
			new pname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pname, sizeof(pname));
			format(string, sizeof(string), "AdmCmd(4): %s has edited clan %s's name", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
			SendAdminMessage(4,string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			FoCo_Teams[DialogOptionVar2[playerid]][team_name] = size;
			SaveTeam(DialogOptionVar2[playerid]);
			return 1;
		}
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
		
		case DIALOG_RESTART:
		{
			if(!response)
			{
				return 1;
			}

			foreach(Player, i)
			{
				DataSave(i);
				SavePlayerStatsInfo(i);
				FoCo_Disconnection(i);
			}
			defer EndRoundTimer();
			new pname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pname, sizeof(pname));
			format(string, sizeof(string), "AdmCmd(5): %s has restarted the game server.", pname);
			SendAdminMessage(4,string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			GameTextForAll("~r~ SERVER RESTART IN 30 SECONDS", 5000, 3);
			return 1;
		}
		/*
		case DIALOG_REPORT_VIEW:
		{
			if(!response) return 1;

			new item, rmsg[256], pname[MAX_PLAYER_NAME], rname[MAX_PLAYER_NAME];
			sscanf(inputtext, "i", item);
			DialogOptionVar1[playerid] = item;

			GetPlayerName(item, pname, sizeof(pname));
			GetPlayerName(reportID[item], rname, sizeof(rname));
			format(rmsg, sizeof(rmsg), "ID: %d\nReporter: %s\nReported: %s\n\nReason: %s", item, pname, rname, ReportStr[item]);

			ShowPlayerDialog(playerid, DIALOG_REPORT_DISPLAY_DETAILS, DIALOG_STYLE_MSGBOX, "Report View", rmsg, "Accept", "Close");
			return 1;
		}
		case DIALOG_REPORT_DISPLAY_DETAILS:
		{
			if(!response) return 1;

			new pname[MAX_PLAYER_NAME];

			GetPlayerName(playerid, pname, sizeof(pname));
			reportID[DialogOptionVar1[playerid]] = -1;
			FoCo_Player[playerid][reports]++;
			format(string, sizeof(string), "[REPORT NOTICE]: %s %s has accepted report %d", GetPlayerStatus(playerid), pname, DialogOptionVar1[playerid]);
			SendAdminMessage(1,string);
			IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);

			format(string, sizeof(string), "[REPORT INFORMATION]: %s %s is now looking into your report, please be patient.", GetPlayerStatus(playerid), pname);
			SendClientMessage(DialogOptionVar1[playerid], COLOR_SYNTAX, string);
			return 1;
		}
		*/
		case DIALOG_BUYCAR_1:
		{
			if(!response)
			{
				TogglePlayerControllable(playerid, 1);
				return 1;
			}

			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_BUYCAR_2, DIALOG_STYLE_LIST, "Sports Vehicles - Select one for more info", "402 - Buffalo - $40000\n411 - Infernus - $150000\n415 - Cheetah - $95000\n429 - Banshee - $40000\n439 - Stalion - $40000\n451 - Turismo - $150000\n477 - ZR-350 - $95000\n480 - Comet - $75000\n506 - SuperGT - $150000\n541 - Bullet - $95000\n559 - Jester - $40000\n562 - Elegy - $40000", "Select", "Back");
					return 1;
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_BUYCAR_2, DIALOG_STYLE_LIST, "4x4 / Pickups - Select one for more info", "400 - Landstalker - $20000\n422 - Bobcat - $10000\n489 - Rancher - $20000\n490 - FBI Rancher - $30000\n543 - Sadler - $20000\n554 - Yosemite - $20000\n579 - Huntley - $20000\n470 - Patriot - $75000\n495 - Sandking - $75000", "Select", "Back");
					return 1;
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_BUYCAR_2, DIALOG_STYLE_LIST, "Saloon Vehicles - Select one for more info", "405 - Sentinel - $20000\n412 - Voodoo - $20000\n421 - Washington - $20000\n426 - Premier - $20000\n445 - Admiral - $20000\n492 - Greenwood - $20000\n536 - Blade - $20000\n550 - Sunrise - $30000\n560 - Sultan - $30000\n561 - Stratum - $30000\n566 - Tahoma - $30000\n567 - Savanna - $30000", "Select", "Back");
					return 1;
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_BUYCAR_2, DIALOG_STYLE_LIST, "Unique Vehicles - Select one for more info", "409 - Limo - $40000\n424 - BF Injection - $75000\n428 - Securicar - $50000\n433 - Barracks - $75000\n434 - Hotknife - $75000\n443 - Packer - $75000\n457 - Caddy - $20000\n494 - Hotring Racer - $75000\n502 - Hotring Racer - $75000\n503 - Hotring Racer - $75000\n504 - Blood Ring Racer - $75000\n573 - Dune - $75000", "Select", "Back");
					return 1;
				}
				case 4:
				{
					ShowPlayerDialog(playerid, DIALOG_BUYCAR_2, DIALOG_STYLE_LIST, "Mission Vehicles - Select one for more info", "403 - Linerunner - $75000\n408 - Trashmaster - $50000\n414 - Mule - $50000\n431 - Bus - $50000\n445 - Flatbed - $20000\n456 - Yankee - $50000\n459 - RC Van - $50000\n482 - Burrito - $50000\n498 - Boxville - $50000\n514 - Tanker - $75000\n515 - Roadtrain - $75000\n578 - DFT 30 - $75000", "Select", "Back");
					return 1;
				}
				case 5:
				{
					ShowPlayerDialog(playerid, DIALOG_BUYCAR_2, DIALOG_STYLE_LIST, "Motorbikes - Select one for more info", "461 - PCJ-600 - $40000\n468 - Sanchez - $40000\n462 - Faggio - $20000\n463 - Freeway - $30000\n521 - FCR-900 - $20000\n522 - NRG-500 - $50000", "Select", "Back");
					return 1;
				}
				case 6:
				{
					ShowPlayerDialog(playerid, DIALOG_BUYCAR_2, DIALOG_STYLE_LIST, "Other Vehicles - Select one for more info", "419 - Esperanto - $30000\n420 - Taxi - $30000\n442 - Romero - $30000\n531 - Tractor - $20000\n565 - Flash - $30000\n568 - Bandito - $40000", "Select", "Back");
					return 1;
				}
				case 7:
				{
					ShowPlayerDialog(playerid, DIALOG_BUYCAR_2, DIALOG_STYLE_LIST, "Donator Vehicles - Select one for more info", "544 - Fire Truck \n417 - Leviathan \n437 - Coach \n444 - Monster \n469 - Sparrow \n512 - CropDuster \n548 - Cargobob", "Select", "Back");
					return 1;
				}
			}
			return 1;
		}
		case DIALOG_BUYCAR_2:
		{
			if(!response)
			{
				if(isVIP(playerid) >= 1)
				{
					ShowPlayerDialog(playerid, DIALOG_BUYCAR_1, DIALOG_STYLE_LIST, "Vehicle Categories", "1. Sports Vehicles\n2. 4x4 / Pickups\n3. Saloons\n4. Unique\n5. Mission Vehicles\n6. Motorbikes\n7. Other\n.8. Donator Vehicles", "Select", "Close");
				}
				else
				{
					ShowPlayerDialog(playerid, DIALOG_BUYCAR_1, DIALOG_STYLE_LIST, "Vehicle Categories", "1. Sports Vehicles\n2. 4x4 / Pickups\n3. Saloons\n4. Unique\n5. Mission Vehicles\n6. Motorbikes\n7. Other", "Select", "Close");
				}
				return 1;
			}

			new item;
			sscanf(inputtext, "i", item);

			new price;
			if((isVIP(playerid) == 1) || IsAdmin(playerid, ACMD_BRONZE))
			{
				price = CarPrice(item)/100*70;
			}
			if((isVIP(playerid) == 2) || IsAdmin(playerid, ACMD_SILVER))
			{
				price = CarPrice(item)/100*50;
			}
			if((isVIP(playerid) == 3) || IsAdmin(playerid, ACMD_GOLD))
			{
				price = CarPrice(item)/100*25;
			}
   			if(isVIP(playerid) < 1)
			{
				price = CarPrice(item);
			}

			if(GetPlayerMoney(playerid) < price)
			{
				format(string, sizeof(string), "This vehicle is: $%d - You cannot afford this.", price);
				SendClientMessage(playerid, COLOR_GREEN, string);
				ShowPlayerDialog(playerid, DIALOG_BUYCAR_1, DIALOG_STYLE_LIST, "Vehicle Categories", "1. Sports Vehicles\n2. 4x4 / Pickups\n3. Saloons\n4. Unique\n5. Mission Vehicles\n6. Other", "Select", "Close");
				return 1;
			}
			else
			{
				format(string, sizeof(string), "This vehicle is: $%d - Click Cancel if you don't wish to purchase this item", price);
				SendClientMessage(playerid, COLOR_GREEN, string);
			}
			DialogOptionVar1[playerid] = item;
			ShowPlayerDialog(playerid, DIALOG_BUYCAR_3, DIALOG_STYLE_INPUT, "Color Selection", "Please insert a value for the color 1 you would like.\n\nHere is some assistance\n\n - Black: 0\n - White: 1\n - Blue: 2\n - Red: 3\n - Pink: 5\n - Yellow: 6", "Select", "Close");
			return 1;
		}
		case DIALOG_BUYCAR_3:
		{
			if(!response)
			{
				TogglePlayerControllable(playerid, 1);
				return 1;
			}

			DialogOptionVar2[playerid] = strval(inputtext);
			ShowPlayerDialog(playerid, DIALOG_BUYCAR_4, DIALOG_STYLE_INPUT, "Color Selection", "Please insert a value for the color 2 you would like.\n\nHere is some assistance\n\n - Black: 0\n - White: 1\n - Blue: 2\n - Red: 3\n - Pink: 5\n - Yellow: 6", "Select", "Close");
			return 1;
		}
		case DIALOG_BUYCAR_4:
		{
			if(!response)
			{
				TogglePlayerControllable(playerid, 1);
				return 1;
			}

			new price;
			if((isVIP(playerid) == 2) || IsAdmin(playerid, ACMD_SILVER)) {
				carSQLCol[playerid] = strval(inputtext);
				mysql_query("SELECT MAX(ID) FROM `FoCo_Player_Vehicles`", MYSQL_THREAD_B_CAR, playerid, con);
				return 1;
			} else {
				price = CarPrice(DialogOptionVar1[playerid]);
			}
			if(GetPlayerMoney(playerid) >= price)
			{
				carSQLCol[playerid] = strval(inputtext);
				mysql_query("SELECT MAX(ID) FROM `FoCo_Player_Vehicles`", MYSQL_THREAD_B_CAR, playerid, con);
				return 1;
			}
			else
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot afford this");
				TogglePlayerControllable(playerid, 1);
			}
			return 1;
		}
		case DIALOG_MOTD:
		{
			if(IsPlayerInRangeOfPoint(playerid, 5.0,FoCo_Teams[FoCo_Team[playerid]][team_spawn_x],FoCo_Teams[FoCo_Team[playerid]][team_spawn_y],FoCo_Teams[FoCo_Team[playerid]][team_spawn_z]))
			{
                ShowPlayerDialog(playerid, DIALOG_CLASS_TOOLS, DIALOG_STYLE_LIST, "Class Tools", "1) Change Class\n2) Edit Class", "Select", "Close");
			}
		}
		case DIALOGID_PMADM:
		{
		    if(response)
		    {
		        pmwarned[playerid] = 1;
		    }
		}
		case DIALOG_ACHIEVEMENTS:
	    {
			if(response)
			{
			    switch(listitem)
			    {
           			case 0:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH1, DIALOG_STYLE_MSGBOX, FoCo_Achievements[1][aname], FoCo_Achievements[1][adescription], "Back", "Close");
			        }
			        case 1:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH2, DIALOG_STYLE_MSGBOX, FoCo_Achievements[2][aname], FoCo_Achievements[2][adescription], "Back", "Close");
			        }
			        case 2:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH3, DIALOG_STYLE_MSGBOX, FoCo_Achievements[3][aname], FoCo_Achievements[3][adescription], "Back", "Close");
			        }
			        case 3:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH4, DIALOG_STYLE_MSGBOX, FoCo_Achievements[4][aname], FoCo_Achievements[4][adescription], "Back", "Close");
			        }
			        case 4:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH5, DIALOG_STYLE_MSGBOX, FoCo_Achievements[5][aname], FoCo_Achievements[5][adescription], "Back", "Close");
			        }
			        case 5:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH6, DIALOG_STYLE_MSGBOX, FoCo_Achievements[6][aname], FoCo_Achievements[6][adescription], "Back", "Close");
			        }
			        case 6:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH7, DIALOG_STYLE_MSGBOX, FoCo_Achievements[7][aname], FoCo_Achievements[7][adescription], "Back", "Close");
			        }
			        case 7:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH8, DIALOG_STYLE_MSGBOX, FoCo_Achievements[8][aname], FoCo_Achievements[8][adescription], "Back", "Close");
			        }
			        case 8:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH9, DIALOG_STYLE_MSGBOX, FoCo_Achievements[9][aname], FoCo_Achievements[9][adescription], "Back", "Close");
			        }
			        case 9:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH10, DIALOG_STYLE_MSGBOX, FoCo_Achievements[10][aname], FoCo_Achievements[10][adescription], "Back", "Close");
			        }
			        case 10:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH11, DIALOG_STYLE_MSGBOX, FoCo_Achievements[11][aname], FoCo_Achievements[11][adescription], "Back", "Close");
			        }
			        case 11:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH12, DIALOG_STYLE_MSGBOX, FoCo_Achievements[12][aname], FoCo_Achievements[12][adescription], "Back", "Close");
			        }
			        case 12:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH13, DIALOG_STYLE_MSGBOX, FoCo_Achievements[13][aname], FoCo_Achievements[13][adescription], "Back", "Close");
			        }
			        case 13:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH14, DIALOG_STYLE_MSGBOX, FoCo_Achievements[14][aname], FoCo_Achievements[14][adescription], "Back", "Close");
			        }
			        case 14:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH15, DIALOG_STYLE_MSGBOX, FoCo_Achievements[15][aname], FoCo_Achievements[15][adescription], "Back", "Close");
			        }
			        case 15:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH16, DIALOG_STYLE_MSGBOX, FoCo_Achievements[16][aname], FoCo_Achievements[16][adescription], "Back", "Close");
			        }
			        case 16:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH17, DIALOG_STYLE_MSGBOX, FoCo_Achievements[17][aname], FoCo_Achievements[17][adescription], "Back", "Close");
			        }
			        case 17:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH18, DIALOG_STYLE_MSGBOX, FoCo_Achievements[18][aname], FoCo_Achievements[18][adescription], "Back", "Close");
			        }
			        case 18:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Select/Info", "Close");
			        }
				}
			}
			else
			{
			    return 1;
			}
		}
		case DIALOG_ACHIEVEMENTS1:
		{
			if(response)
			{
			    switch(listitem)
			    {
					case 0:
					{
					    ShowPlayerDialog(playerid, DIALOG_ACH19, DIALOG_STYLE_MSGBOX, FoCo_Achievements[19][aname], FoCo_Achievements[19][adescription], "Back", "Close");
					}
					case 1:
					{
					    ShowPlayerDialog(playerid, DIALOG_ACH20, DIALOG_STYLE_MSGBOX, FoCo_Achievements[20][aname], FoCo_Achievements[20][adescription], "Back", "Close");
					}
					case 2:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH21, DIALOG_STYLE_MSGBOX, FoCo_Achievements[21][aname], FoCo_Achievements[21][adescription], "Back", "Close");
					}
					case 3:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH22, DIALOG_STYLE_MSGBOX, FoCo_Achievements[22][aname], FoCo_Achievements[22][adescription], "Back", "Close");
					}
					case 4:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH23, DIALOG_STYLE_MSGBOX, FoCo_Achievements[23][aname], FoCo_Achievements[23][adescription], "Back", "Close");
					}
					case 5:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH24, DIALOG_STYLE_MSGBOX, FoCo_Achievements[24][aname], FoCo_Achievements[24][adescription], "Back", "Close");
					}
					case 6:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH25, DIALOG_STYLE_MSGBOX, FoCo_Achievements[25][aname], FoCo_Achievements[25][adescription], "Back", "Close");
					}
					case 7:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH26, DIALOG_STYLE_MSGBOX, FoCo_Achievements[26][aname], FoCo_Achievements[26][adescription], "Back", "Close");
					}
					case 8:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH27, DIALOG_STYLE_MSGBOX, FoCo_Achievements[27][aname], FoCo_Achievements[27][adescription], "Back", "Close");
					}
					case 9:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH28, DIALOG_STYLE_MSGBOX, FoCo_Achievements[28][aname], FoCo_Achievements[28][adescription], "Back", "Close");
					}
					case 10:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH29, DIALOG_STYLE_MSGBOX, FoCo_Achievements[29][aname], FoCo_Achievements[29][adescription], "Back", "Close");
					}
					case 11:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH30, DIALOG_STYLE_MSGBOX, FoCo_Achievements[30][aname], FoCo_Achievements[30][adescription], "Back", "Close");
					}
					case 12:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH31, DIALOG_STYLE_MSGBOX, FoCo_Achievements[31][aname], FoCo_Achievements[31][adescription], "Back", "Close");
					}
					case 13:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH32, DIALOG_STYLE_MSGBOX, FoCo_Achievements[32][aname], FoCo_Achievements[32][adescription], "Back", "Close");
					}
					case 14:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH33, DIALOG_STYLE_MSGBOX, FoCo_Achievements[33][aname], FoCo_Achievements[33][adescription], "Back", "Close");
					}
					case 15:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH34, DIALOG_STYLE_MSGBOX, FoCo_Achievements[34][aname], FoCo_Achievements[34][adescription], "Back", "Close");
					}
					case 16:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH35, DIALOG_STYLE_MSGBOX, FoCo_Achievements[35][aname], FoCo_Achievements[35][adescription], "Back", "Close");
					}
					case 17:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH36, DIALOG_STYLE_MSGBOX, FoCo_Achievements[36][aname], FoCo_Achievements[36][adescription], "Back", "Close");
					}
					case 18:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Select/Info", "Close");
					}
					case 19:
					{
						ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Select/Info", "Close");
					}
					
			    }
			}
			else
			{
			    return 1;
			}
		}
		case DIALOG_ACHIEVEMENTS2:
		{
			if(response)
			{
			    switch(listitem)
			    {
					case 0:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH37, DIALOG_STYLE_MSGBOX, FoCo_Achievements[37][aname], FoCo_Achievements[37][adescription], "Back", "Close");
					}
					case 1:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH38, DIALOG_STYLE_MSGBOX, FoCo_Achievements[38][aname], FoCo_Achievements[38][adescription], "Back", "Close");
					}
					case 2:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH39, DIALOG_STYLE_MSGBOX, FoCo_Achievements[39][aname], FoCo_Achievements[39][adescription], "Back", "Close");
					}
					case 3:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH40, DIALOG_STYLE_MSGBOX, FoCo_Achievements[40][aname], FoCo_Achievements[40][adescription], "Back", "Close");
					}
					case 4:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH41, DIALOG_STYLE_MSGBOX, FoCo_Achievements[41][aname], FoCo_Achievements[41][adescription], "Back", "Close");
					}
					case 5:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH42, DIALOG_STYLE_MSGBOX, FoCo_Achievements[42][aname], FoCo_Achievements[42][adescription], "Back", "Close");
					}
					case 6:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH43, DIALOG_STYLE_MSGBOX, FoCo_Achievements[43][aname], FoCo_Achievements[43][adescription], "Back", "Close");
					}
					case 7:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH44, DIALOG_STYLE_MSGBOX, FoCo_Achievements[44][aname], FoCo_Achievements[44][adescription], "Back", "Close");
					}
					case 8:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH45, DIALOG_STYLE_MSGBOX, FoCo_Achievements[45][aname], FoCo_Achievements[45][adescription], "Back", "Close");
					}
					case 9:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH46, DIALOG_STYLE_MSGBOX, FoCo_Achievements[46][aname], FoCo_Achievements[46][adescription], "Back", "Close");
					}
					case 10:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH47, DIALOG_STYLE_MSGBOX, FoCo_Achievements[47][aname], FoCo_Achievements[47][adescription], "Back", "Close");
					}
					case 11:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH48, DIALOG_STYLE_MSGBOX, FoCo_Achievements[48][aname], FoCo_Achievements[48][adescription], "Back", "Close");
					}
					case 12:
					{
					    ShowPlayerDialog(playerid, DIALOG_ACH49, DIALOG_STYLE_MSGBOX, FoCo_Achievements[49][aname], FoCo_Achievements[49][adescription], "Back", "Close");
					}
					case 13:
					{
					    ShowPlayerDialog(playerid, DIALOG_ACH50, DIALOG_STYLE_MSGBOX, FoCo_Achievements[50][aname], FoCo_Achievements[50][adescription], "Back", "Close");
					}
					case 14:
					{
					    ShowPlayerDialog(playerid, DIALOG_ACH51, DIALOG_STYLE_MSGBOX, FoCo_Achievements[51][aname], FoCo_Achievements[51][adescription], "Back", "Close");
					}
					case 15:
					{
					    ShowPlayerDialog(playerid, DIALOG_ACH52, DIALOG_STYLE_MSGBOX, FoCo_Achievements[52][aname], FoCo_Achievements[52][adescription], "Back", "Close");
					}
					case 16:
					{
					    ShowPlayerDialog(playerid, DIALOG_ACH53, DIALOG_STYLE_MSGBOX, FoCo_Achievements[53][aname], FoCo_Achievements[53][adescription], "Back", "Close");
					}
					case 17:
					{
					    ShowPlayerDialog(playerid, DIALOG_ACH54, DIALOG_STYLE_MSGBOX, FoCo_Achievements[54][aname], FoCo_Achievements[54][adescription], "Back", "Close");
					}
					case 18:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Select/Info", "Close");
					}
					case 19:
					{
						ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Select/Info", "Close");
					}

			    }
			}
			else
			{
			    return 1;
			}
		}
		case DIALOG_ACHIEVEMENTS3:
		{
			if(response)
			{
			    switch(listitem)
			    {
					case 0:
					{
					    ShowPlayerDialog(playerid, DIALOG_ACH55, DIALOG_STYLE_MSGBOX, FoCo_Achievements[55][aname], FoCo_Achievements[55][adescription], "Back", "Close");
					}
					case 1:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH56, DIALOG_STYLE_MSGBOX, FoCo_Achievements[56][aname], FoCo_Achievements[56][adescription], "Back", "Close");
					}
					case 2:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH57, DIALOG_STYLE_MSGBOX, FoCo_Achievements[57][aname], FoCo_Achievements[57][adescription], "Back", "Close");
					}
					case 3:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH58, DIALOG_STYLE_MSGBOX, FoCo_Achievements[58][aname], FoCo_Achievements[58][adescription], "Back", "Close");
					}
					case 4:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH59, DIALOG_STYLE_MSGBOX, FoCo_Achievements[59][aname], FoCo_Achievements[59][adescription], "Back", "Close");
					}
					case 5:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH60, DIALOG_STYLE_MSGBOX, FoCo_Achievements[60][aname], FoCo_Achievements[60][adescription], "Back", "Close");
					}
					case 6:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH61, DIALOG_STYLE_MSGBOX, FoCo_Achievements[61][aname], FoCo_Achievements[61][adescription], "Back", "Close");
					}
					case 7:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH62, DIALOG_STYLE_MSGBOX, FoCo_Achievements[62][aname], FoCo_Achievements[62][adescription], "Back", "Close");
					}
					case 8:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH63, DIALOG_STYLE_MSGBOX, FoCo_Achievements[63][aname], FoCo_Achievements[63][adescription], "Back", "Close");
					}
					case 9:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH64, DIALOG_STYLE_MSGBOX, FoCo_Achievements[64][aname], FoCo_Achievements[64][adescription], "Back", "Close");
					}
					case 10:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH65, DIALOG_STYLE_MSGBOX, FoCo_Achievements[65][aname], FoCo_Achievements[65][adescription], "Back", "Close");
					}
					case 11:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH66, DIALOG_STYLE_MSGBOX, FoCo_Achievements[66][aname], FoCo_Achievements[66][adescription], "Back", "Close");
					}
					case 12:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH67, DIALOG_STYLE_MSGBOX, FoCo_Achievements[67][aname], FoCo_Achievements[67][adescription], "Back", "Close");
					}
					case 13:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH68, DIALOG_STYLE_MSGBOX, FoCo_Achievements[68][aname], FoCo_Achievements[68][adescription], "Back", "Close");
					}
					case 14:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH69, DIALOG_STYLE_MSGBOX, FoCo_Achievements[69][aname], FoCo_Achievements[69][adescription], "Back", "Close");
					}
					case 15:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH70, DIALOG_STYLE_MSGBOX, FoCo_Achievements[70][aname], FoCo_Achievements[70][adescription], "Back", "Close");
					}
					case 16:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH71, DIALOG_STYLE_MSGBOX, FoCo_Achievements[71][aname], FoCo_Achievements[71][adescription], "Back", "Close");
					}
					case 17:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH72, DIALOG_STYLE_MSGBOX, FoCo_Achievements[72][aname], FoCo_Achievements[72][adescription], "Back", "Close");
					}
					case 18:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Select/Info", "Close");
					}
					case 19:
					{
						ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Select/Info", "Close");
					}

			    }
			}
			else
			{
			    return 1;
			}
		}
		case DIALOG_ACHIEVEMENTS4:
		{
			if(response)
			{
			    switch(listitem)
			    {
					case 0:
					{
					    ShowPlayerDialog(playerid, DIALOG_ACH73, DIALOG_STYLE_MSGBOX, FoCo_Achievements[73][aname], FoCo_Achievements[73][adescription], "Back", "Close");
					}
					case 1:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH74, DIALOG_STYLE_MSGBOX, FoCo_Achievements[74][aname], FoCo_Achievements[74][adescription], "Back", "Close");
					}
					case 2:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH75, DIALOG_STYLE_MSGBOX, FoCo_Achievements[75][aname], FoCo_Achievements[75][adescription], "Back", "Close");
					}
					case 3:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH76, DIALOG_STYLE_MSGBOX, FoCo_Achievements[76][aname], FoCo_Achievements[76][adescription], "Back", "Close");
					}
					case 4:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH77, DIALOG_STYLE_MSGBOX, FoCo_Achievements[77][aname], FoCo_Achievements[77][adescription], "Back", "Close");
					}
					case 5:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH78, DIALOG_STYLE_MSGBOX, FoCo_Achievements[78][aname], FoCo_Achievements[78][adescription], "Back", "Close");
					}
					case 6:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH79, DIALOG_STYLE_MSGBOX, FoCo_Achievements[79][aname], FoCo_Achievements[79][adescription], "Back", "Close");
					}
					case 7:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH80, DIALOG_STYLE_MSGBOX, FoCo_Achievements[80][aname], FoCo_Achievements[80][adescription], "Back", "Close");
					}
					case 8:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH81, DIALOG_STYLE_MSGBOX, FoCo_Achievements[81][aname], FoCo_Achievements[81][adescription], "Back", "Close");
					}
					case 9:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH82, DIALOG_STYLE_MSGBOX, FoCo_Achievements[82][aname], FoCo_Achievements[82][adescription], "Back", "Close");
					}
					case 10:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH83, DIALOG_STYLE_MSGBOX, FoCo_Achievements[83][aname], FoCo_Achievements[83][adescription], "Back", "Close");
					}
					case 11:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH84, DIALOG_STYLE_MSGBOX, FoCo_Achievements[84][aname], FoCo_Achievements[84][adescription], "Back", "Close");
					}
					case 12:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH85, DIALOG_STYLE_MSGBOX, FoCo_Achievements[85][aname], FoCo_Achievements[85][adescription], "Back", "Close");
					}
					case 13:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH86, DIALOG_STYLE_MSGBOX, FoCo_Achievements[86][aname], FoCo_Achievements[86][adescription], "Back", "Close");
					}
					case 14:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH87, DIALOG_STYLE_MSGBOX, FoCo_Achievements[87][aname], FoCo_Achievements[87][adescription], "Back", "Close");
					}
					case 15:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH88, DIALOG_STYLE_MSGBOX, FoCo_Achievements[88][aname], FoCo_Achievements[88][adescription], "Back", "Close");
					}
					case 16:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS5, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 6), GetAchievementsList5(GetPVarInt(playerid, "ViewingAch_ID")), "Select/Info", "Close");
					}
					case 17:
					{
						ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Select/Info", "Close");
					}

			    }
			}
			else
			{
			    return 1;
			}
		}
		case DIALOG_ACHIEVEMENTS5:
		{
			if(response)
			{
			    switch(listitem)
			    {
					case 0:
					{
						ShowPlayerDialog(playerid, DIALOG_ACH89, DIALOG_STYLE_MSGBOX, FoCo_Achievements[89][aname], FoCo_Achievements[89][adescription], "Back", "Close");
					}
					case 1:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH90, DIALOG_STYLE_MSGBOX, FoCo_Achievements[90][aname], FoCo_Achievements[90][adescription], "Back", "Close");
					}
					case 2:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH91, DIALOG_STYLE_MSGBOX, FoCo_Achievements[91][aname], FoCo_Achievements[91][adescription], "Back", "Close");
					}
					case 3:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH92, DIALOG_STYLE_MSGBOX, FoCo_Achievements[92][aname], FoCo_Achievements[92][adescription], "Back", "Close");
					}
					case 4:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH93, DIALOG_STYLE_MSGBOX, FoCo_Achievements[93][aname], FoCo_Achievements[93][adescription], "Back", "Close");
					}
					case 5:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH94, DIALOG_STYLE_MSGBOX, FoCo_Achievements[94][aname], FoCo_Achievements[94][adescription], "Back", "Close");
					}
					case 6:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH95, DIALOG_STYLE_MSGBOX, FoCo_Achievements[95][aname], FoCo_Achievements[95][adescription], "Back", "Close");
					}
					case 7:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH96, DIALOG_STYLE_MSGBOX, FoCo_Achievements[96][aname], FoCo_Achievements[96][adescription], "Back", "Close");
					}
					case 8:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH97, DIALOG_STYLE_MSGBOX, FoCo_Achievements[97][aname], FoCo_Achievements[97][adescription], "Back", "Close");
					}
					case 9:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH98, DIALOG_STYLE_MSGBOX, FoCo_Achievements[98][aname], FoCo_Achievements[98][adescription], "Back", "Close");
					}
					case 10:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH99, DIALOG_STYLE_MSGBOX, FoCo_Achievements[99][aname], FoCo_Achievements[99][adescription], "Back", "Close");
					}
					case 11:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH100, DIALOG_STYLE_MSGBOX, FoCo_Achievements[100][aname], FoCo_Achievements[100][adescription], "Back", "Close");
					}
					case 12:
					{
                        ShowPlayerDialog(playerid, DIALOG_ACH101, DIALOG_STYLE_MSGBOX, FoCo_Achievements[101][aname], FoCo_Achievements[101][adescription], "Back", "Close");
					}
					case 13:
					{
						ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Select/Info", "Close");
					}
			    }
			}
			else
			{
			    return 1;
			}
		}
	    case DIALOG_ACH1:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH2:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH3:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH4:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH5:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH6:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH7:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH8:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH9:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH10:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH11:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH12:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH13:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH14:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH15:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH16:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH17:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH18:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 1), GetAchievementsList(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH19:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH20:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH21:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH22:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH23:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH24:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH25:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH26:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH27:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH28:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH29:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH30:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH31:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH32:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH33:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH34:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH35:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH36:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS1, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 2), GetAchievementsList1(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH37:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH38:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH39:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH40:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH41:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH42:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH43:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH44:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH45:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH46:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH47:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH48:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH49:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH50:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH51:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH52:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH53:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH54:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS2, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 3), GetAchievementsList2(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH55:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH56:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH57:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH58:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH59:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH60:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH61:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH62:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH63:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH64:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH65:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH66:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH67:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH68:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH69:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH70:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH71:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH72:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS3, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 4), GetAchievementsList3(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH73:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH74:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH75:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH76:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH77:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH78:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH79:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH80:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH81:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH82:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH83:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH84:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH85:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH86:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH87:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH88:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS4, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 5), GetAchievementsList4(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH89:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS5, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 6), GetAchievementsList5(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH90:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS5, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 6), GetAchievementsList5(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH91:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS5, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 6), GetAchievementsList5(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH92:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS5, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 6), GetAchievementsList5(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH93:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS5, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 6), GetAchievementsList5(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH94:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS5, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 6), GetAchievementsList5(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH95:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS5, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 6), GetAchievementsList5(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH96:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS5, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 6), GetAchievementsList5(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH97:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS5, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 6), GetAchievementsList5(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH98:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS5, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 6), GetAchievementsList5(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH99:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS5, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 6), GetAchievementsList5(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH100:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS5, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 6), GetAchievementsList5(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH101:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS5, DIALOG_STYLE_LIST, GetAchievementPage(GetPVarInt(playerid, "ViewingAch_ID"), 6), GetAchievementsList5(GetPVarInt(playerid, "ViewingAch_ID")), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid)
{
    return 1;
}

#define PI 3.141592653589793238462643383279502884

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	IdleTime[playerid] = 0;
	#if defined PTS
	RakGuy_OnPlayerWeaponShot_Test(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);	// This will only run for testserver
	new Float:angle;
	GetPlayerFacingAngle(playerid, angle);
	
	#endif
	#if !defined PTS
	RakGuy_OnPlayerWeaponShot_Main(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);	// This will run for main
	#endif

	new string[156];
	//format(string, sizeof(string), "WeaponID: %d, hittype: %d, hittid: %d, fx: %f, fy: %f, fz: %f", weaponid, hittype, hitid, fX, fY, fZ);
	//DebugMsg(string);

	// Weaponid can never be 0, as fists don't fire bullets... Hittype 168 and hitid 42677 is accurate for this specific crasher.
	if(weaponid < 22 || weaponid > 34 && weaponid != 38)
	{
		format(string, sizeof(string), "[AdmCMD]: The Guardian has banned %s(%d), Reason: AimCrasher (WpnID)[WpnID: %d, Hittype: %d, HitID: %d]", PlayerName(playerid), playerid, weaponid, hittype, hitid);
		AdminLog(string);
		format(string, sizeof(string), "AimCrasher");
		ABanPlayer(-1, playerid, string);
		return 0;
	}
	if(hittype < 0 || hittype > 4)
	{
		format(string, sizeof(string), "[AdmCMD]: The Guardian has banned %s(%d), Reason: AimCrasher (HitType)[WpnID: %d, Hittype: %d, HitID: %d]", PlayerName(playerid), playerid, weaponid, hittype, hitid);
		AdminLog(string);
		format(string, sizeof(string), "AimCrasher");
		ABanPlayer(-1, playerid, string);
		return 0;
	}
	// For bulletcrasher, made by mr pEar. Accurate, so allowed it to autoban
	if(hittype == 1)
	{
		if(fX >= 10000 || fY >= 10000 || fZ >= 10000)
		{
			format(string, sizeof(string), "[AdmCMD]: The Guardian has banned %s(%d), Reason: BulletCrasher [fX: %f, fY: %f, fZ: %f]", PlayerName(playerid), playerid, fX, fY, fZ);
			AdminLog(string);
			format(string, sizeof(string), "BulletCrasher");
			ABanPlayer(-1, playerid, string);
			return 0;
		}
	}
	return 1;
}

