
forward minigun_EventStart(playerid);
forward minigun_PlayerJoinEvent(playerid);
forward minigun_PlayerLeftEvent(playerid);
forward minigun_OneSecond();

new Float:minigunSpawnsType1[][] = {
	{1360.8236,2197.9639,9.7578,171.2087},
	{1396.4573,2176.7610,9.7578,84.2131},
	{1397.0870,2157.2017,11.0234,188.2790},
	{1410.2015,2100.4004,12.0156,359.9406},
	{1406.4691,2123.8171,17.2344,90.5182},
	{1406.5967,2183.2200,17.2344,84.8548},
	{1296.8109,2212.5212,12.0156,265.6498},
	{1300.6083,2207.5505,17.2344,183.5323},
	{1359.4872,2208.0378,17.2344,179.7720},
	{1298.4968,2198.1011,11.0234,178.2052},
	{1304.8771,2101.3682,11.0156,275.3395},
	{1396.1423,2101.5391,11.0156,89.8678},
	{1384.2648,2185.5144,11.0234,134.6748},
	{1330.3446,2204.9385,13.3759,358.6869},
	{1403.9540,2153.5938,13.2266,274.7129},
	{1396.5599,2103.8850,39.0228,48.1240},
	{1302.0127,2197.8630,39.0228,225.1588}
};

public minigun_EventStart(playerid)
{
   	new
	    string[256];

	Event_ID = MINIGUN;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Minigun Wars {%06x}event. Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	SendClientMessageToAll(COLOR_CMDNOTICE,  "[EVENT]: 30 seconds before it starts, type /join!");
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	
	return 1;
}


public minigun_PlayerJoinEvent(playerid)
{
    if(EventPlayersCount() == 17)
	{
		return SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
	}

	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerPos(playerid, minigunSpawnsType1[increment][0], minigunSpawnsType1[increment][1], minigunSpawnsType1[increment][2]);
	SetPlayerFacingAngle(playerid, minigunSpawnsType1[increment][3]);
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
	GivePlayerWeapon(playerid, 38, 3000);
	GameTextForPlayer(playerid, "~R~~n~~n~ MINIGUN ~n~ WARS", 1500, 3);
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


public minigun_PlayerLeftEvent(playerid)
{
    SetPVarInt(playerid, "LeftEventJust", 1);

	if(EventPlayersCount() == 1)
	{
		new
				msg[128];
	        
		foreach(Player, i)
		{
			if(GetPVarInt(i, "InEvent") == 1)
			{
				winner = i;
				break;
			}
		}
		
		format(msg, sizeof(msg), "				%s has won the Minigun Wars event!", PlayerName(winner));
		SendClientMessageToAll(COLOR_NOTICE, msg);
		GiveAchievement(winner, 80);
		SendClientMessage(winner, COLOR_NOTICE, "You have won the Minigun Wars event! You have earnt 10 score!");
		FoCo_Player[winner][score] += 10;
		lastEventWon = winner;
		Event_Bet_End(winner);
		EndEvent();
	}
	return 1;
}


public minigun_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Minigun wars is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
		}
	}
}