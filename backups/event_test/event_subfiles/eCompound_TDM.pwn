forward compound_EventStart(playerid);
forward compound_PlayerJoinEvent(playerid);
forward compound_PlayerLeftEvent(playerid);
forward compound_OneSecond();

new Float:terroristcoumpoundattack[][] = {
	{-2180.1060,-268.1125,36.5156,273.4774}, // terrorits
	{-2180.0811,-265.7807,36.5156,269.0100}, // terrorits
	{-2180.0684,-263.1395,36.5156,271.2192}, // terrorits
	{-2179.9485,-260.2129,36.5156,267.1994}, // terrorits
	{-2179.9487,-257.7114,36.5156,267.1044}, // terrorits
	{-2184.7568,-253.8005,36.5156,267.2739}, // terrorits
	{-2184.5247,-251.0279,36.5156,265.7572}, // terrorits
	{-2184.3416,-248.1582,36.5156,266.0979}, // terrorits
	{-2184.1201,-245.0245,36.5156,264.3055}, // terrorits
	{-2183.7273,-242.0624,36.5156,263.6901}, // terrorits
	{-2185.4993,-238.8463,36.5220,268.0169}, // terrorits
	{-2185.2302,-235.9542,36.5220,264.1762}, // terrorits
	{-2184.8584,-232.8474,36.5156,267.1653}, // terrorits
	{-2184.5327,-230.1497,36.5156,262.6979}, // terrorits
	{-2181.9202,-227.0722,36.5156,260.0210}, // terrorits
	{-2170.1748,-237.7798,36.5156,357.3499}, // terrorits
	{-2166.4485,-237.7726,36.5156,358.0706} // terrorits
};

new Float:swatcompoundattack[][] = {
	{-1572.7030,748.0657,-5.2422,93.3019}, // cop
	{-1572.6538,744.2728,-5.2422,93.1385}, // cop
	{-1572.8400,740.5297,-5.2422,85.7576}, // cop
	{-1573.1174,736.6428,-5.2422,85.6028}, // cop
	{-1573.5133,732.7161,-5.2422,82.8390}, // cop
	{-1573.8737,728.5589,-5.2422,83.8352}, // cop
	{-1574.3877,724.3843,-5.2422,82.0114}, // cop
	{-1574.6088,719.8906,-5.2422,84.5743}, // cop
	{-1574.9963,715.1602,-5.2422,83.6905}, // cop
	{-1575.2784,708.9619,-5.2422,91.8934}, // cop
	{-1575.7524,702.8419,-4.9063,83.4896}, // cop
	{-1575.9858,697.0717,-4.9063,87.6192}, // cop
	{-1576.4403,691.0716,-5.2422,86.7354}, // cop
	{-1582.4408,684.6136,-5.2422,87.4182}, // cop
	{-1582.5164,680.3119,-4.9063,85.9078}, // cop
	{-1583.1206,676.1038,-4.9063,80.6373}, // cop
	{-1592.8230,674.3566,-4.9140,352.2764} // cop
};

new Float:compoundVehicles[][e_DrugRunVehicles] = {
 	{497,-1630.3750,654.6266,7.3591,268.2673},
 	{497,-1604.6624,655.1348,7.3591,273.0138},
 	{490,-1616.0300,742.7470,-4.9922,89.5245},
    {490,-1604.0100,741.7650,-4.9922,87.7661},
    {490,-1593.0900,741.0660,-4.9922,87.6814},
    {490,-1582.0300,740.5920,-4.9922,87.4882},
    {490,-1581.0500,724.7320,-4.9922,359.0400},
    {490,-1581.0800,710.8540,-4.9922,358.8570},
    {490,-1581.7600,699.9149,-4.9844,358.7741}
};

public compound_EventStart(playerid)
{
	FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

   	new
	    string[256];

	Event_ID = COMPOUND;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Compound Attack {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	
	for(new i; i < 9; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			new eCarID = CreateVehicle(compoundVehicles[i][modelID], compoundVehicles[i][dX], compoundVehicles[i][dY], compoundVehicles[i][dZ], compoundVehicles[i][Rotation], -1, -1, 600000);
			SetVehicleVirtualWorld(eCarID, 1500);
			eventVehicles[i] = eCarID;
			Iter_Add(Event_Vehicles, eCarID);
		}

		else
		{
			break;
		}
	}
	if(FoCo_Player[playerid][level] >= 3)
	{
	    if(GetPlayerMoney(playerid) > 5000)
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


public compound_PlayerJoinEvent(playerid)
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
		SetPlayerPos(playerid, swatcompoundattack[increment][0], swatcompoundattack[increment][1], swatcompoundattack[increment][2]);
		SetPlayerFacingAngle(playerid, swatcompoundattack[increment][3]);
		Motel_Team = 1;
		increment++;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the Compound.");
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		PlayerEventStats[playerid][pteam] = 2;
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 221);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, terroristcoumpoundattack[increment-1][0], terroristcoumpoundattack[increment-1][1], terroristcoumpoundattack[increment-1][2]);
		SetPlayerFacingAngle(playerid, terroristcoumpoundattack[increment-1][3]);
		Motel_Team = 0;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the Compound ...");
	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 33, 30);
	GivePlayerWeapon(playerid, 31, 500);
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ Compound Attack ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
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


public compound_PlayerLeftEvent(playerid)
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

	format(msg, sizeof(msg), "[EVENT SCORE]: SWAT %d - %d Terrorists", Team1_Motel, Team2_Motel);
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
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: SWAT have won the event!");
		Event_Bet_End(0);
		return 1;
	}

	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}
	return 1;
}


public compound_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Compound Attack is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				SetPlayerCheckpoint(i, -2126.5669,-84.7937,35.3203,2.3031);
			}
		}
	}
}