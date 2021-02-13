forward jefftdm_EventStart(playerid);
forward jefftdm_PlayerJoinEvent(playerid);
forward jefftdm_PlayerLeftEvent(playerid);
forward jefftdm_OneSecond();


new Float:motelSpawnsType1[][] = {
	{2189.9846,-1139.2814,1029.7969,238.2805},
	{2189.1294,-1143.9292,1029.7969,273.2783},
	{2191.0825,-1146.8323,1029.7969,3.2783},
	{2196.0771,-1147.2567,1029.7969,3.2783},
	{2199.7551,-1147.3477,1029.7969,3.2783},
	{2202.3135,-1144.9834,1029.7969,90.6991},
	{2201.8625,-1143.1967,1029.7969,90.6991},
	{2199.8345,-1142.1290,1029.7969,180.9399},
	{2199.4023,-1139.0775,1029.7969,180.9399},
	{2196.8816,-1138.9806,1029.7969,180.9399},
	{2194.9197,-1139.0475,1029.7969,180.9399},
	{2194.1277,-1143.8186,1029.7969,0.9399},
	{2197.0967,-1144.2506,1029.7969,267.8791},
	{2193.4351,-1145.3593,1029.7969,181.3983},
	{2190.3499,-1142.9524,1030.3516,265.8307}
};

new Float:motelSpawnsType2[][] = {
	{2221.1633,-1154.1404,1025.7969,357.2927}, // Spawn1
	{2219.7998,-1153.8639,1025.7969,351.7650}, // Spawn2
	{2218.6963,-1153.5408,1025.7969,346.4945}, // Spawn3
	{2216.5090,-1152.4301,1025.7969,305.1901}, // Spawn4
	{2215.8010,-1150.7072,1025.7969,268.6424}, // Spawn5
	{2215.8596,-1149.2339,1025.7969,270.2654}, // Spawn6
	{2216.0044,-1147.0659,1025.7969,269.3816}, // Spawn7
	{2218.3806,-1147.1096,1025.7969,178.2570}, // Spawn8
	{2219.6746,-1145.5049,1025.7969,272.0005}, // Spawn9
	{2224.2832,-1142.2668,1025.7969,178.9960}, // Spawn10
	{2225.2764,-1145.0853,1025.7969,138.9451}, // Spawn11
	{2226.0496,-1147.5005,1025.7969,108.6078}, // Spawn12
	{2226.9717,-1150.2124,1025.7969,90.1771}, // Spawn13
	{2224.8855,-1150.6051,1025.7969,83.0266},// Spawn14
	{2219.8657,-1149.2186,1025.7969,268.5779}, // Spawn15
	{2218.7021,-1150.7179,1025.7969,180.3060}, // Spawn16
	{2218.6985,-1148.3522,1025.7969,353.6372} // Spawn17
};

public jefftdm_EventStart(playerid)
{

   	new
	    string[256];

	FoCo_Event_Rejoin = 0;

    foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	Event_ID = JEFFTDM;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Jefferson Motel Team DM {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;

	return 1;
}


public jefftdm_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 15);

	if(Motel_Team == 0)
	{
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		PlayerEventStats[playerid][pteam] = 1;
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 285);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, motelSpawnsType1[increment][0], motelSpawnsType1[increment][1], motelSpawnsType1[increment][2]);
		SetPlayerFacingAngle(playerid, motelSpawnsType1[increment][3]);
		Motel_Team = 1;
		increment++;
	}

	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		PlayerEventStats[playerid][pteam] = 2;
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 50);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, motelSpawnsType2[increment-1][0], motelSpawnsType2[increment-1][1], motelSpawnsType2[increment-1][2]);
		SetPlayerFacingAngle(playerid, motelSpawnsType2[increment-1][3]);
		Motel_Team = 0;
	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 31, 500);
    TogglePlayerControllable(playerid, 0);
	GameTextForPlayer(playerid, "~R~~n~~n~ Motel ~h~ TDM!~n~~n~ ~w~You are now in the queue", 4000, 3);
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
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
 		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}


public jefftdm_PlayerLeftEvent(playerid)
{
    new
		t1,
		t2,
		msg[128];

	if(GetPlayerSkin(playerid) == 285)
	{
		Team2_Motel++;
	}
	else if(GetPlayerSkin(playerid) == 50)
	{
		Team1_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: S.W.A.T %d - %d Criminals", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);

	SetPVarInt(playerid, "MotelTeamIssued", 0);

	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				t1++;
			}
			else if(GetPVarInt(i, "MotelTeamIssued") == 2)
			{
				t2++;
			}
		}
	}

	if(t1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: Criminals have won the event!");
		Event_Bet_End(1);
		return 1;
	}

	else if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: S.W.A.T have won the event!");
		Event_Bet_End(0);
		return 1;
	}

	/*if(EventPlayersCount() == 1)
	{
		EndEvent();
	}*/
	return 1;
}


public jefftdm_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Jefferson Motel DM is now in progress and can not be joined");
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
}