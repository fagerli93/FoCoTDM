

new Timer:PursuitTimer;

forward pursuit_EventStart(playerid);
forward pursuit_PlayerJoinEvent(playerid);
forward pursuit_PlayerLeftEvent(playerid);
forward EndPursuit();
forward pursuit_OneSecond();
forward Random_Pursuit_Vehicle();

new Float:pursuitVehicles[][] = {
	{612.4984,-1224.6945,17.8323,289.7163}, // Pursuit vehicle  0
	{565.6188,-1244.3657,16.9157,295.8679}, // 
	{566.4626,-1238.9558,16.9824,294.7580},	// 
	{563.5314,-1232.3390,16.9785,293.8539}, //
	{562.1167,-1228.7739,16.9802,293.5553}, //
	{570.1106,-1219.6626,17.3587,264.5331}, //
	{581.5428,-1241.3715,17.4123,324.3894}, //
	{546.8007,-1234.5836,16.5933,301.3257}, //
	{548.7852,-1240.2753,16.5859,298.6667}, //
	{551.3083,-1245.8103,16.5883,298.6719}, //
	{550.2395,-1282.4430,17.4245,335.9597}, // Maverick 1   10
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
	{535.8637,-1280.3307,17.4137,324.3655}  // Maverick 2 24
};

timer EndPursuit[300000]()
{
	SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the criminal getting away!");
	GiveAchievement(FoCo_Criminal, 78);
	EndEvent();
	Motel_Team = 0;
}

public pursuit_EventStart(playerid)
{
    FoCo_Event_Rejoin = 0;
    team_issue = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

   	new
	    string[256];

	Event_ID = PURSUIT;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Pursuit {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;


	new car;
	caridx = 0;
	Iter_Clear(Event_Vehicles);
	for(new i = 0; i < 25; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			if(i == 0)     // If you change this, also change the ones on top!!
			{
				car = CreateVehicle(Random_Pursuit_Vehicle(), pursuitVehicles[i][0], pursuitVehicles[i][1], pursuitVehicles[i][2], pursuitVehicles[i][3], -1, -1, 600000);
				SetVehicleVirtualWorld(car, 1500);
				E_Pursuit_Criminal = car;
				eventVehicles[i] = car;
			}
			else if (i == 10 || i == 24)    // If this is changed, change accordingly on top
 			{
   				car = CreateVehicle(497, pursuitVehicles[i][0], pursuitVehicles[i][1], pursuitVehicles[i][2], pursuitVehicles[i][3], 0, 1, 600000);
   				SetVehicleVirtualWorld(car, 1500);
      			eventVehicles[i] = car;
	        	Iter_Add(Event_Vehicles, car);
    		}
		    else
		    {
	    		car = CreateVehicle(596, pursuitVehicles[i][0], pursuitVehicles[i][1], pursuitVehicles[i][2], pursuitVehicles[i][3], 0, 1, 600000);
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
	    pursuit_PlayerJoinEvent(ForcedCriminal);
	}
	return 1;
}

public pursuit_PlayerJoinEvent(playerid)
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
			PursuitTimer = defer EndPursuit();
			SetPlayerSkin(playerid, 50);
			PutPlayerInVehicle(playerid, E_Pursuit_Criminal, 0);
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
		PursuitTimer = defer EndPursuit();
		SetPlayerSkin(playerid, 50);
		PutPlayerInVehicle(playerid, E_Pursuit_Criminal, 0);
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Stay alive, evade the PD ...");
		format(string, sizeof(string), "%s was chosen to be the criminal, kill him at all costs!",PlayerName(playerid));
		SendClientMessageToAll(COLOR_GREEN, string);
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
	//	//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
	//	//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
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


public pursuit_PlayerLeftEvent(playerid)
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
	//SetPlayerSkin(playerid, GetPVarInt(playerid, "MotelSkin"));
	//SetPlayerColor(playerid, GetPVarInt(playerid, "MotelColor"));

	return 1;
}


public pursuit_OneSecond()
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

public Random_Pursuit_Vehicle()
{
	new randVeh, vehicle;
	randVeh = random(50);
	switch(randVeh)
	{
		case 0: { vehicle = 402; }
		case 1: { vehicle = 405; }
		case 2: { vehicle = 402; }
		case 3: { vehicle = 426; }
		case 4: { vehicle = 434; }
		case 5: { vehicle = 439; }
		case 6: { vehicle = 402; }
		case 7: { vehicle = 489; }
		case 8: { vehicle = 495; }
		case 9: { vehicle = 412; }
		case 10: { vehicle = 419; }
		case 11: { vehicle = 421; }
		case 12: { vehicle = 422; }
		case 13: { vehicle = 426; }
		case 14: { vehicle = 436; }
		case 15: { vehicle = 445; }
		case 16: { vehicle = 466; }
		case 17: { vehicle = 467; }
		case 18: { vehicle = 470; }
		case 19: { vehicle = 474; }
		case 20: { vehicle = 475; }
		case 21: { vehicle = 477; }
		case 22: { vehicle = 491; }
		case 23: { vehicle = 492; }
		case 24: { vehicle = 500; }
		case 25: { vehicle = 506; }
		case 26: { vehicle = 508; }
		case 27: { vehicle = 516; }
		case 28: { vehicle = 517; }
		case 29: { vehicle = 526; }
		case 30: { vehicle = 527; }
		case 31: { vehicle = 529; }
		case 32: { vehicle = 533; }
		case 33: { vehicle = 534; }
		case 34: { vehicle = 535; }
		case 35: { vehicle = 536; }
		case 36: { vehicle = 537; }
		case 37: { vehicle = 540; }
		case 38: { vehicle = 542; }
		case 39: { vehicle = 549; }
		case 40: { vehicle = 550; }
		case 41: { vehicle = 555; }
		case 42: { vehicle = 566; }
		case 43: { vehicle = 567; }
		case 44: { vehicle = 575; }
		case 45: { vehicle = 576; }
		case 46: { vehicle = 579; }
		case 47: { vehicle = 580; }
		case 48: { vehicle = 587; }
		case 49: { vehicle = 602; }
		case 50: { vehicle = 603; }
	}
	return vehicle;
}