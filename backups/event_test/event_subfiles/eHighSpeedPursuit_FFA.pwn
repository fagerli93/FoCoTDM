
new Timer:HSPursuitTimer;

forward hspursuit_EventStart(playerid);
forward hspursuit_PlayerJoinEvent(playerid);
forward hspursuit_PlayerLeftEvent(playerid);
forward EndHSPursuit();
forward hspursuit_OneSecond();
forward RandomHS_Pursuit_Vehicle();

new Float:HSpursuitVehicles[][] = {
    {612.4984,-1224.6945,17.8323,289.7163}, // Pursuit vehicle  0
	{565.6188,-1244.3657,16.9157,295.8679}, // 
	{566.4626,-1238.9558,16.9824,294.7580}, //
	{563.5314,-1232.3390,16.9785,293.8539}, //
	{562.1167,-1228.7739,16.9802,293.5553}, //
	{570.1106,-1219.6626,17.3587,264.5331}, //
	{581.5428,-1241.3715,17.4123,324.3894}, //
	{546.8007,-1234.5836,16.5933,301.3257}, //
	{548.7852,-1240.2753,16.5859,298.6667}, //
	{551.3083,-1245.8103,16.5883,298.6719}, //
	{553.7662,-1248.9722,16.6187,302.2399}, //
	{544.7589,-1254.8802,16.3637,304.2602}, //
	{542.4852,-1250.9253,16.3521,300.5960}, //
	{540.0701,-1245.4398,16.3468,303.6496}, //
	{537.5844,-1241.2225,16.3265,301.9268}, //
	{530.2521,-1246.8922,16.1160,306.0346}, //
	{532.6643,-1250.7150,16.1437,305.6226}, //
	{536.0997,-1255.8051,16.1669,304.6418}, //
	{538.0214,-1259.7885,16.1732,306.9165}, //
	{523.6465,-1252.1454,15.9460,307.8360}, //
	{525.4552,-1256.6023,15.9496,307.9929}, //
	{529.3110,-1260.3461,16.0049,305.8422}, //
	{532.2231,-1264.5140,16.0315,306.3712}, //
	{550.2395,-1282.4430,17.4245,335.9597}, // Maverick 1  23
	{535.8637,-1280.3307,17.4137,324.3655}  // Maverick 2 24
};

timer EndHSPursuit[300000]()
{
	SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the criminal getting away!");
	GiveAchievement(FoCo_Criminal, 78);
	EndEvent();
	Motel_Team = 0;
}

public hspursuit_EventStart(playerid)
{
	FoCo_Event_Rejoin = 0;
    team_issue = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}
	
	new string[256];

	Event_ID = HIGHSPEEDPURSUIT;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}High-speed Pursuit {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	
	new car;
	caridx = 0;
	Iter_Clear(Event_Vehicles);
	for(new i = 0; i <= 24; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			if(i == 0)     // If you change this, also change the ones on top!!
			{
				car = CreateVehicle(RandomHS_Pursuit_Vehicle(), HSpursuitVehicles[i][0], HSpursuitVehicles[i][1], HSpursuitVehicles[i][2], HSpursuitVehicles[i][3], -1, -1, 600000);
				SetVehicleVirtualWorld(car, 1500);
				E_HSPursuit_Criminal = car;
				eventVehicles[i] = car;
			}
			else if (i == 10 || i == 24)    // If this is changed, change accordingly on top. Mavericks
 			{
   				car = CreateVehicle(497, HSpursuitVehicles[i][0], HSpursuitVehicles[i][1], HSpursuitVehicles[i][2], HSpursuitVehicles[i][3], 125, 125, 600000);
   				SetVehicleVirtualWorld(car, 1500);
      			eventVehicles[i] = car;
	        	Iter_Add(Event_Vehicles, car);
    		}
    		else if (i % 4 == 0)    // Cheetahs
    		{
    			car = CreateVehicle(415, HSpursuitVehicles[i][0], HSpursuitVehicles[i][1], HSpursuitVehicles[i][2], HSpursuitVehicles[i][3], 125, 125, 600000);
   				SetVehicleVirtualWorld(car, 1500);
      			eventVehicles[i] = car;
	        	Iter_Add(Event_Vehicles, car);
    		}
		    else        // Sultans
		    {
	    		car = CreateVehicle(560, HSpursuitVehicles[i][0], HSpursuitVehicles[i][1], HSpursuitVehicles[i][2], HSpursuitVehicles[i][3], 0, 1, 600000);
				SetVehicleVirtualWorld(car, 1500);
				eventVehicles[i] = car;
				Iter_Add(Event_Vehicles, car);
  			}
		}
		else
		{
			break;
		}
	}
	if (ForcedCriminal != -1)
	{
		PlayerJoinEvent(ForcedCriminal);
	    hspursuit_PlayerJoinEvent(ForcedCriminal);
	}
	return 1;
}

public hspursuit_PlayerJoinEvent(playerid)
{
	new string[128];
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);

	if(ForcedCriminal != -1)
	{
 		if(ForcedCriminal == playerid)
   		{
        	Motel_Team = 1;
			SetPVarInt(playerid, "MotelTeamIssued", 1);
			SetPlayerColor(playerid, COLOR_RED);
			FoCo_Criminal = playerid;
			HSPursuitTimer = defer EndHSPursuit();
			SetPlayerSkin(playerid, 50);
			PutPlayerInVehicle(playerid, E_HSPursuit_Criminal, 0);
			SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Stay alive, evade the PD ...");
			format(string, sizeof(string), "%s was chosen to be the criminal, kill him at all costs!",PlayerName(playerid));
			SendClientMessageToAll(COLOR_GREEN, string);
			SendClientMessage(playerid, COLOR_NOTICE, "You have been chosen by an admin to be the criminal");
			ForcedCriminal = -1;
     	}
	}
	else if(Motel_Team == 0 && ForcedCriminal == -1)
	{
		Motel_Team = 1;
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		SetPlayerColor(playerid, COLOR_RED);
		FoCo_Criminal = playerid;
		HSPursuitTimer = defer EndHSPursuit();
		SetPlayerSkin(playerid, 50);
		PutPlayerInVehicle(playerid, E_HSPursuit_Criminal, 0);
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Stay alive, evade the PD ...");
		format(string, sizeof(string), "%s was chosen to be the criminal, kill him at all costs!",PlayerName(playerid));
		SendClientMessageToAll(COLOR_GREEN, string);
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		SetPlayerSkin(playerid, 280);
		SetPlayerColor(playerid, COLOR_BLUE);
		team_issue++;
		caridx++;
        PutPlayerInVehicle(playerid, eventVehicles[caridx], 0);
        

		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Take out the criminal car at all costs ...");

		if(FoCo_Criminal != INVALID_PLAYER_ID)
		{
			SetPlayerMarkerForPlayer( playerid, FoCo_Criminal, 0xFFFFFF00);
		}
 	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 25, 500);
	GameTextForPlayer(playerid, "~R~~n~~n~ Pursuit ~h~ ~n~~n~ ~w~You are now in the queue", 4000, 3);
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


public hspursuit_PlayerLeftEvent(playerid)
{
    if(playerid == FoCo_Criminal)
	{
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the criminal being caught!");
		Event_Bet_End(0);
		EndEvent();
	}

	if(GetPVarInt(playerid, "MotelTeamIssued") == 2)
	{
     	team_issue--;
	}

	if(team_issue == 0)
	{
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the police being killed!");
		Event_Bet_End(1);
		EndEvent();
	}
	SetPVarInt(playerid, "MotelTeamIssued", 0);

	return 1;
}


public hspursuit_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Pursuit is now in progress and can not be joined");

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

public RandomHS_Pursuit_Vehicle()
{
	new randVeh, vehicle;
	randVeh = random(30);
	switch(randVeh)
	{
		case 0: { vehicle = 402; }
		case 1: { vehicle = 411; }
		case 2: { vehicle = 415; }
		case 3: { vehicle = 424; }
		case 4: { vehicle = 429; }
		case 5: { vehicle = 451; }
		case 6: { vehicle = 461; }
		case 7: { vehicle = 463; }
		case 8: { vehicle = 468; }
		case 9: { vehicle = 471; }
		case 10: { vehicle = 477; }
		case 11: { vehicle = 494; }
		case 12: { vehicle = 495; }
		case 13: { vehicle = 496; }
		case 14: { vehicle = 502; }
		case 15: { vehicle = 503; }
		case 16: { vehicle = 506; }
		case 17: { vehicle = 509; }
		case 18: { vehicle = 541; }
		case 19: { vehicle = 555; }
		case 20: { vehicle = 556; }
		case 21: { vehicle = 559; }
		case 22: { vehicle = 560; }
		case 23: { vehicle = 562; }
		case 24: { vehicle = 565; }
		case 25: { vehicle = 568; }
		case 26: { vehicle = 581; }
		case 27: { vehicle = 587; }
		case 28: { vehicle = 589; }
		case 29: { vehicle = 602; }
		case 30: { vehicle = 603; }
	}
	return vehicle;
}