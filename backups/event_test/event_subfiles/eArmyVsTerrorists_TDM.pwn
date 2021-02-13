forward army_EventStart(playerid);
forward army_PlayerJoinEvent(playerid);
forward army_PlayerLeftEvent(playerid);
forward army_OneSecond();

new Float:armySpawnsType1[][] = {
	{-536.6452,1309.3185,3.7102,143.2186},
	{-535.7869,1307.3175,3.6655,144.8415},
	{-534.9776,1304.9730,3.5959,138.3177},
	{-534.4557,1302.6029,3.6028,133.0472},
	{-880.8651,1621.5620,30.8952,152.0271},
	{-880.4622,1617.4822,33.4015,245.7476},
	{-873.7017,1618.7975,33.4030,60.9587},
	{-883.3175,1615.1110,35.7468,240.8466},
	{-854.6778,1376.1045,1.2741,311.1262},
	{-851.0994,1372.8354,1.2741,315.1996}
};

new Float:armySpawnsType2[][] = {
	{-726.8176,1533.9048,40.1724,353.1638},
	{-729.1471,1534.0126,40.1633,356.0400},
	{-731.5231,1535.9725,40.2617,268.3620},
	{-729.3406,1538.0480,40.3969,2.6762},
	{-732.8348,1538.6995,40.4118,263.7181},
	{-730.0102,1539.9668,40.5042,164.1335},
	{-734.8888,1544.8472,39.0736,264.7473},
	{-734.6887,1547.8004,38.9713,266.9969},
	{-734.5697,1545.9861,41.5462,266.4031},
	{-734.1703,1555.2683,39.8209,272.7589}
};

public army_EventStart(playerid)
{
   	new
	    string[256];

	FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	Event_ID = ARMYVSTERRORISTS;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Army vs. Terrorists Team DM {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
		
	for(new i; i < 3; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			new eCarID = CreateVehicle(NavyTerroristVehicles[i][modelID], NavyTerroristVehicles[i][dX], NavyTerroristVehicles[i][dY], NavyTerroristVehicles[i][dZ], NavyTerroristVehicles[i][Rotation], -1, -1, 600000);
			SetVehicleVirtualWorld(eCarID, 1500);
			eventVehicles[i] = eCarID;
			Iter_Add(Event_Vehicles, eCarID);
		}

		else
		{
			break;
		}
	}

	return 1;
}


public army_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);
	if(Motel_Team == 0)
	{
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		PlayerEventStats[playerid][pteam] = 1;
		////SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 287);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, armySpawnsType1[increment][0], armySpawnsType1[increment][1], armySpawnsType1[increment][2]);
		SetPlayerFacingAngle(playerid, armySpawnsType1[increment][3]);
		Motel_Team = 1;
		increment++;
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		PlayerEventStats[playerid][pteam] = 2;
		////SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 73);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, armySpawnsType2[increment-1][0], armySpawnsType2[increment-1][1], armySpawnsType2[increment-1][2]);
		SetPlayerFacingAngle(playerid, armySpawnsType2[increment-1][3]);
		Motel_Team = 0;
	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 31, 750);
	GivePlayerWeapon(playerid, 34, 50);
	GameTextForPlayer(playerid, "~R~~n~~n~ Army vs. Terrorists ~h~ TDM!~n~~n~ ~w~You are now in the queue", 4000, 3);
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


public army_PlayerLeftEvent(playerid)
{
    new
		t1,
		t2,
		msg[128];

	if(GetPlayerSkin(playerid) == 287)
	{
		Team2_Motel++;
	}
	else if(GetPlayerSkin(playerid) == 73)
	{
		Team1_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: Army %d - %d Terrorists", Team1_Motel, Team2_Motel);
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
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Terrorists have won the event!");
		Event_Bet_End(1);
		return 1;
	}

	else if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Army have won the event!");
		Event_Bet_End(0);
		return 1;
	}

	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}

	return 1;
}


public army_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Army vs. Terrorists DM is now in progress and can not be joined");
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