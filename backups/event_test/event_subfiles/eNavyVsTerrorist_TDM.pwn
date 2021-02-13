forward navy_EventStart(playerid);
forward navy_PlayerJoinEvent(playerid);
forward navy_PlayerLeftEvent(playerid);
forward navy_OneSecond();


new Float:navySealsBoat[][] = {
	{-1451.8934,489.2393,3.0414,0.9636},
	{-1439.5277,489.2123,3.0414,357.9584},
	{-1435.7106,491.3882,3.0391,93.1610}, // Boatspawn_3
	{-1436.4033,495.6390,3.0391,93.1610}, // Boatspawn_4
	{-1446.0100,501.4157,3.0414,87.9335}, // Boatspawn_5
	{-1439.6398,501.8853,3.0414,359.0356}, // Boatspawn_6
	{-1432.6844,504.3380,3.0414,88.6373}, // Boatspawn_7
	{-1433.0454,508.8413,3.0414,88.6373}, // Boatspawn_8
	{-1437.2540,513.3931,3.0414,174.5301}, // Boatspawn_9
	{-1453.8115,513.5035,3.0414,177.5172}, // Boatspawn_10
	{-1424.9127,513.7139,3.0391,88.2392}, // Boatspawn_11
	{-1424.7781,508.5562,3.0391,95.7319}, // Boatspawn_12
	{-1426.6696,503.5713,3.0391,89.7576 }, // Boatspawn_13
	{-1427.1627,497.9672,3.0391,89.7576}, // Boatspawn_14
	{-1428.3741,492.3010,3.0391,89.7576}, // Boatspawn_15
	{-1429.5172,488.9036,3.0391,103.5731}, // Boatspawn_16
	{-1347.6814,500.0701,18.2344,3.1124} // Boatspawn_17
};

new Float:navyVehicles[][e_DrugRunVehicles] = { // 9 vehicles
	{476,-1270.1177,499.6811,18.9408,269.5298},
	{476,-1293.3729,492.2342,18.9422,270.5231},
	{476,-1303.7994,508.0874,18.9414,269.9069},
	{476,-1404.7931,493.4467,18.9422,356.9377},
	{476,-1458.4177,501.1433,18.9834,270.8403},
	{497,-1418.0540,516.1037,18.4192,270.9501},
	{497,-1420.1477,492.0164,18.4092,357.8716},
	{430,-1445.0782,497.6998,-0.2108,89.1427},
	{430,-1438.6812,504.7648,-0.1138,93.3837},
	{430,-1438.7063,509.4692,-0.1682,91.9946},
	{430,-1471.4034,488.0244,-0.2879,90.2242},
	{473,-1444.8440,491.8952,-0.2713,90.8142}
};

new Float:NavyTerroristVehicles[][e_DrugRunVehicles] = {
	{473,-544.2135,1290.1025,-0.2869,60.3390},
	{473,-545.9045,1301.1432,-0.2776,69.1840},
	{473,-544.9697,1308.0038,-0.2525,64.3189}
};

new Float:terroristsBoat[][] = {
	{-1434.3325,1481.8838,1.8672,276.5517},
	{-1434.2948,1484.1460,1.8672,268.4611},
	{-1434.2507,1486.6434,1.8672,268.5173},
	{-1434.2252,1489.7177,1.8672,268.5735},
	{-1434.3741,1494.6810,1.8672,267.6897},
	{-1433.8632,1498.0852,1.8672,263.3593},
	{-1413.2545,1497.2257,1.8672,265.6650},
	{-1406.1989,1497.3625,1.8672,271.3051},
	{-1394.2034,1497.2762,1.8735,271.3051},
	{-1390.7335,1493.5171,1.8735,86.3641},
	{-1390.7863,1490.1801,1.8735,88.0595},
	{-1391.1282,1486.5408,1.8672,82.7890},
	{-1391.2137,1483.8008,1.8672,84.7253},
	{-1391.6104,1480.9357,1.8672,85.0948},
	{-1400.5376,1482.9449,1.8672,90.7348},
	{-1408.2819,1483.0409,1.8672,90.7348}
};

public navy_EventStart(playerid)
{
	FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

   	new
	    string[256];
		
	Event_ID = NAVYVSTERRORISTS;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Navy Seals vs. Terrorists {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	
	
	for(new i; i < 12; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			new eCarID = CreateVehicle(navyVehicles[i][modelID], navyVehicles[i][dX], navyVehicles[i][dY], navyVehicles[i][dZ], navyVehicles[i][Rotation], -1, -1, 600000);
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


public navy_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);

	if(Motel_Team == 0)
	{
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		PlayerEventStats[playerid][pteam] = 1;
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 287);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, navySealsBoat[increment][0], navySealsBoat[increment][1], navySealsBoat[increment][2]);
		SetPlayerFacingAngle(playerid, navySealsBoat[increment][3]);
		Motel_Team = 1;
		increment++;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the boat in the checkpoint and eliminate all terrorist activity.");
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		PlayerEventStats[playerid][pteam] = 2;
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 221);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, terroristsBoat[increment-1][0], terroristsBoat[increment-1][1], terroristsBoat[increment-1][2]);
		SetPlayerFacingAngle(playerid, terroristsBoat[increment-1][3]);
		Motel_Team = 0;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the boat at all costs ...");
	}


	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 29, 750);
	GivePlayerWeapon(playerid, 31, 500);
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ Navy Seals Vs. Terrorists ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
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


public navy_PlayerLeftEvent(playerid)
{
   	new
	   	t1,
		t2,
		msg[128];

    if(GetPlayerSkin(playerid) == 221)
	{
		Team1_Motel++;
	}
	else if(GetPlayerSkin(playerid) == 287)
	{
		Team2_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: Navy Seals %d - %d Terrorists", Team1_Motel, Team2_Motel);
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
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Navy Seals have won the event!");
		Event_Bet_End(0);
		return 1;
	}
	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}
	return 1;
}


public navy_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Navy Seals Vs. Terrorists is now in progress and can not be joined");
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
			DisablePlayerCheckpoint(i);
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				SetPlayerCheckpoint(i, -1446.6353,1502.6423,1.7366, 4.0);
			}
		}
	}
}