
new Timer:HydraFallCheckTimer;
new Timer:hydraTime;


forward hydra_EventStart(playerid);
forward hydra_PlayerJoinEvent(playerid);
forward hydra_PlayerLeftEvent(playerid);
forward hydra_OneSecond();

new Float:hydraSpawnsType1[][] = {
	{1939.58178711,1365.82348633,16.76304626,272.00000000},
	{1939.77551270,1323.51635742,16.76304626,271.50000000},
	{1968.00170898,1185.41442871,63.80590057,0.00000000},
	{1955.27209473,1173.72131348,63.80590439,180.00000000},
	{2163.80175781,1502.10534668,32.08264542,320.00000000},
	{2164.01171875,1463.47900391,32.08404922,222.00000000},
	{2106.23974609,1462.88977051,32.08428955,124.00000000},
	{2106.60009766,1502.69543457,32.08437729,52.00000000},
	{1950.36877441,1628.54748535,23.68749237,272.00000000},
	{1953.65820312,1603.13574219,73.17739105,39.99572754},
	{1906.02832031,1628.63964844,73.17739105,270.00000000},
	{1955.29699707,1655.69946289,73.17520905,39.99572754}
};

timer HydraFallCheck[1000]()
{
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			if(GetPlayerState(i) != PLAYER_STATE_DRIVER)
			{
			    SetPlayerHealth(i, 0);
				PlayerLeftEvent(i);
			}
		}
	}
}

timer HydraEnd[480000]()
{
	EndEvent();
}

public hydra_EventStart(playerid)
{
    Event_ID = HYDRA;

	new
   	    string[256];
	
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Hydra wars event. Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	// SendClientMessageToAll(COLOR_CMDNOTICE, "[EVENT]: 30 seconds before it starts, type /join!");
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	HydraFallCheckTimer = repeat HydraFallCheck();
	Event_Delay = 30;
	
	return 1;
}


public hydra_PlayerJoinEvent(playerid)
{
    if(EventPlayersCount() == 12)
	{
		return SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
	}

	SetPlayerVirtualWorld(playerid, 505);
	SetPlayerPos(playerid, hydraSpawnsType1[increment][0], hydraSpawnsType1[increment][1], hydraSpawnsType1[increment][2]);
	Event_PlayerVeh[playerid] = CreateVehicle(520, hydraSpawnsType1[increment][0], hydraSpawnsType1[increment][1], hydraSpawnsType1[increment][2], hydraSpawnsType1[increment][3], -1, -1, 15);
	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	PutPlayerInVehicle(playerid, Event_PlayerVeh[playerid], 0);
	GameTextForPlayer(playerid, "~R~~n~~n~ HYDRA ~n~ WARS", 1500, 3);
	TogglePlayerControllable(playerid, 0);
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


public hydra_PlayerLeftEvent(playerid)
{
	SetPVarInt(playerid, "LeftEventJust", 1);
	event_SpawnPlayer(playerid);

	new
	    msg[128];

	if(EventPlayersCount() == 1)
	{
		
		foreach(Player, i)
		{
			if(GetPVarInt(i, "InEvent") == 1)
			{
				winner = i;
				break;
			}
		}
	
		format(msg, sizeof(msg), "				%s has won the Hydra Wars event!", PlayerName(winner));
		SendClientMessageToAll(COLOR_NOTICE, msg);
		GiveAchievement(winner, 82);
		SendClientMessage(winner, COLOR_NOTICE, "You have won the Hydra Wars event! You have earnt 10 score!");
		FoCo_Player[winner][score] = FoCo_Player[winner][score] + 10;
		lastEventWon = winner;
		Event_Bet_End(winner);
		EndEvent();
	}

	return 1;
}


public hydra_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Hydra wars is now in progress and can not be joined");
	hydraTime = defer HydraEnd();
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
		}
	}
}