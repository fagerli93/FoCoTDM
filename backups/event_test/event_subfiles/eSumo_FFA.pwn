
new Timer:SumoFallCheckTimer;

forward monster_EventStart(playerid);
forward monster_PlayerJoinEvent(playerid);
forward banger_EventStart(playerid);
forward banger_PlayerJoinEvent(playerid);
forward sandking_EventStart(playerid);
forward sandking_PlayerJoinEvent(playerid);
forward sandkingR_EventStart(playerid);
forward sandkingR_PlayerJoinEvent(playerid);
forward derby_EventStart(playerid);
forward derby_PlayerJoinEvent(playerid);
forward sumo_PlayerLeftEvent(playerid);
forward sumo_OneSecond();

new Float:sumoSpawnsType1[15][4] =
{
	{3770.844238, -1525.422973, 36.218750, 165.782379},
	{3760.332275, -1526.346435, 36.218750, 165.782379},
	{3781.483886, -1496.333984, 36.218650, 165.782379},
	{3747.465820, -1493.134521, 36.218750, 165.782379},
	{3753.536376, -1434.557739, 36.169601, 165.782379},
	{3778.360351, -1435.679443, 36.169586, 165.782379},
	{3632.698974, -1549.674072, 36.247207, 170.496109},
	{3651.617675, -1549.627441, 36.247196, 170.496109},
	{3664.941894, -1527.715209, 36.247135, 170.496109},
	{3621.671630, -1490.709472, 36.247188, 170.496109},
	{3665.038574, -1485.096679, 36.247230, 170.496109},
	{3634.828857, -1405.810913, 36.234485, 170.496109},
	{3622.596191, -1338.279785, 36.238059, 170.496109},
	{3622.376708, -1264.447509, 36.170368, 170.496109},
	{3681.760498, -1316.780395, 36.240844, 170.496109}
};

new Float:sumoSpawnsType2[15][4] = {
	{4791.94726562,-2043.65002441,14.0,82.00000000},
	{4790.67578125,-2049.04931641,14.0,71.99597168},
	{4788.72070312,-2053.98779297,14.0,65.99340820},
	{4786.09472656,-2058.88867188,14.0,55.98986816},
	{4792.23144531,-2037.80468750,14.0,95.99597168},
	{4791.53466797,-2032.01013184,14.0,101.99304199},
	{4790.06250000,-2026.42871094,14.0,111.99157715},
	{4787.96728516,-2021.58862305,14.0,119.98913574},
	{4784.91601562,-2016.86865234,14.0,129.98718262},
	{4780.93212891,-2012.68615723,14.0,137.98461914},
	{4777.05224609,-2009.32250977,14.0,141.98266602},
	{4772.77148438,-2006.47973633,14.0,151.98132324},
	{4767.81347656,-2004.35412598,14.0,161.98144531},
	{4762.79931641,-2002.90576172,14.0,168.48138428},
	{4757.82128906,-2002.34020996,14.0,177.98120117}
};

new Float:sumoSpawnsType3[15][4] = {
	{1488.4178,6265.4429,27.5201,359.7072},
	{1488.2949,6232.3647,27.4989,359.8356},
	{1469.1898,6246.8521,27.2210,90.6164},
	{1502.7943,6247.6836,27.7414,88.2535},
	{1405.6884,6244.0596,25.9826,139.4007},
	{1320.5160,6202.5352,26.0507,96.7300},
	{1280.3342,6213.2788,26.0509,95.6704},
	{1257.2800,6277.6987,26.0462,358.0646},
	{1282.4304,6320.6533,26.0062,322.3025},
	{1401.2308,6351.6323,26.8068,275.0645},
	{1446.4875,6319.3984,23.5806,199.6965},
	{1478.3333,6296.5176,25.7071,270.5961},
	{1535.2900,6257.3018,25.6623,186.7137},
	{1531.9629,6193.7227,25.7719,16.0374},
	{1631.1805,6259.5181,25.7823,176.3534}
};

new Float:sumoSpawnsType4[15][4] = {
	{-1484.40002441,949.40002441,1037.90002441,334.00000000},
	{-1488.30004883,951.59997559,1037.90002441,333.99536133},
	{-1492.69995117,954.00000000,1037.90002441,333.99536133},
	{-1497.09997559,957.29998779,1037.90002441,333.99536133},
	{-1501.09997559,960.90002441,1037.90002441,327.99536133},
	{-1504.40002441,964.20001221,1038.00000000,333.99536133},
	{-1508.40002441,968.40002441,1037.80004883,333.99536133},
	{-1511.69995117,971.70001221,1038.09997559,333.99536133},
	{-1514.69995117,975.59997559,1038.19995117,325.99536133},
	{-1517.40002441,980.50000000,1038.19995117,309.99536133},
	{-1518.90002441,984.29998779,1038.19995117,293.99475098},
	{-1520.90002441,992.09997559,1038.30004883,283.99414062},
	{-1520.30004883,988.20001221,1038.19995117,289.99414062},
	{-1521.40002441,997.29998779,1038.40002441,277.99108887},
	{-1521.09997559,1002.00000000,1038.40002441,265.98706055}
};

new Float:sumoSpawnsType5[15][4] = {
	{4272.3604,999.4564,500.6275,86.5218},
	{4176.0195,945.9434,500.5341,101.3996},
	{4047.7341,999.1551,500.5143,86.9434},
	{4091.0955,1146.4822,500.4341,1.6999},
	{4012.9485,1277.9446,500.5084,89.1949},
	{4042.1272,1191.2253,476.9365,180.4632},
	{4213.5005,1279.0221,504.7436,266.9754},
	{4370.5264,1093.3694,500.5674,323.3853},
	{4194.9370,1094.6921,500.5842,179.4744},
	{4189.2437,907.8942,524.1190,273.7524},
	{4290.7930,913.4462,524.2849,2.1497},
	{4369.5400,1054.1501,524.1741,270.7135},
	{4169.1250,1095.0826,500.5882,182.0604},
	{4027.7532,999.4358,500.5151,357.7991},
	{4004.3616,1135.5791,500.4542,359.5936}
};

timer SumoFallCheck[1000]()
{
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			new Float:vx, Float:vy, Float:vz;
			GetVehiclePos(Event_PlayerVeh[i], vx, vy, vz);
			if(vz < 8.0 || GetPlayerState(i) != PLAYER_STATE_DRIVER)
			{
			    SetPlayerHealth(i, 0);
				PlayerLeftEvent(i);	
			}
		}
	}
}

public monster_EventStart(playerid)
{
   	new
	    string[128];

    Event_ID = MONSTERSUMO;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Monster Sumo event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "[EVENT]: 30 seconds before it starts, type /join!", COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	
	return 1;
}

public banger_EventStart(playerid)
{
   	new
	    string[128];

	Event_ID = BANGERSUMO;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Banger Sumo event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "[EVENT]: 30 seconds before it starts, type /join!", COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
		
	return 1;
}

public sandking_EventStart(playerid)
{
   	new
	    string[128];

	Event_ID = SANDKSUMO;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}SandKing Sumo event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "[EVENT]: 30 seconds before it starts, type /join!", COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
		
	return 1;
}

public sandkingR_EventStart(playerid)
{
   	new
	    string[128];

	Event_ID = SANDKSUMORELOADED;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}SandKing Sumo Reloaded event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "[EVENT]: 30 seconds before it starts, type /join!",COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
		
	return 1;
}

public derby_EventStart(playerid)
{
   	new
	    string[128];

	Event_ID = DESTRUCTIONDERBY;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Destruction Derby event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "30 seconds before it starts, type /join!", COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
		
	return 1;
}

public monster_PlayerJoinEvent(playerid)
{
    SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 505);

	SetPlayerPos(playerid, sumoSpawnsType1[increment][0], sumoSpawnsType1[increment][1], sumoSpawnsType1[increment][2]+5);
	SetPlayerFacingAngle(playerid, sumoSpawnsType1[increment][3]);
	Event_PlayerVeh[playerid] = CreateVehicle(556, sumoSpawnsType1[increment][0], sumoSpawnsType1[increment][1], sumoSpawnsType1[increment][2], sumoSpawnsType1[increment][3], -1, -1, 15);
	SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType1[increment][3]);

	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
	TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);
	increment++;
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	}
	
	return 1;
}

public banger_PlayerJoinEvent(playerid)
{
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 505);

	SetPlayerPos(playerid, sumoSpawnsType2[increment][0], sumoSpawnsType2[increment][1], sumoSpawnsType2[increment][2]+5);
	SetPlayerFacingAngle(playerid, sumoSpawnsType2[increment][3]);
	Event_PlayerVeh[playerid] = CreateVehicle(504, sumoSpawnsType2[increment][0], sumoSpawnsType2[increment][1], sumoSpawnsType2[increment][2], sumoSpawnsType2[increment][3], -1, -1, 15);

	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
	TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);
	increment++;
    new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	}
    return 1;
}

public sandking_PlayerJoinEvent(playerid)
{
    SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 505);

	SetPlayerPos(playerid, sumoSpawnsType3[increment][0], sumoSpawnsType3[increment][1], sumoSpawnsType3[increment][2]+5);
	SetPlayerFacingAngle(playerid, sumoSpawnsType3[increment][3]);
	Event_PlayerVeh[playerid] = CreateVehicle(495, sumoSpawnsType3[increment][0], sumoSpawnsType3[increment][1], sumoSpawnsType3[increment][2], sumoSpawnsType3[increment][3], -1, -1, 15);
	SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType3[increment][3]);

	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
	TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);
	increment++;
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	}
	return 1;
}

public sandkingR_PlayerJoinEvent(playerid)
{
    SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 505);

	SetPlayerPos(playerid, sumoSpawnsType5[increment][0], sumoSpawnsType5[increment][1], sumoSpawnsType5[increment][2]+5);
	SetPlayerFacingAngle(playerid, sumoSpawnsType5[increment][3]);
	Event_PlayerVeh[playerid] = CreateVehicle(495, sumoSpawnsType5[increment][0], sumoSpawnsType5[increment][1], sumoSpawnsType5[increment][2], sumoSpawnsType5[increment][3], -1, -1, 15);
	SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType5[increment][3]);

	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
	TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);
	increment++;
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	}
	return 1;
}

public derby_PlayerJoinEvent(playerid)
{
    SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 505);

	SetPlayerInterior(playerid, 15);
	SetPlayerPos(playerid, sumoSpawnsType4[increment][0], sumoSpawnsType4[increment][1], sumoSpawnsType4[increment][2]+5);
	SetPlayerFacingAngle(playerid, sumoSpawnsType4[increment][3]);
	Event_PlayerVeh[playerid] = CreateVehicle(504, sumoSpawnsType4[increment][0], sumoSpawnsType4[increment][1], sumoSpawnsType4[increment][2], sumoSpawnsType4[increment][3], -1, -1, 15);
	SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType4[increment][3]);
	LinkVehicleToInterior(Event_PlayerVeh[playerid], 15);

	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
	TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);
	increment++;
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	}
	return 1;
}

public sumo_PlayerLeftEvent(playerid)
{
  	SetPVarInt(playerid, "LeftEventJust", 1);
	RemovePlayerFromVehicle(playerid);
	event_SpawnPlayer(playerid);

	if(EventPlayersCount() == 1)
	{
		new msg[128];
		foreach(Player, i)
	  	{
			if(GetPVarInt(i, "InEvent") == 1)
			{
				winner = i;
				break;
			}
		}
		format(msg, sizeof(msg), "				%s has won the Sumo event!", PlayerName(winner));
		SendClientMessageToAll(COLOR_NOTICE, msg);
		GiveAchievement(winner, 81);
		SendClientMessage(winner, COLOR_NOTICE, "You have won Sumo event! You have earnt 10 score!");
		FoCo_Player[winner][score] += 10;
		lastEventWon = winner;
		Event_Bet_End(winner);
		EndEvent();
		return 1;
	}
	
	return 1;
}

public sumo_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Sumo is now in progress and can not be joined.");
	SumoFallCheckTimer = repeat SumoFallCheck();
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			SetVehicleParamsEx(Event_PlayerVeh[i], true, false, false, true, false, false, false);
			TogglePlayerControllable(i, 1);
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
			increment = 0;
		}
	}
	return 1;
}