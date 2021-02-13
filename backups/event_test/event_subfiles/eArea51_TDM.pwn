

forward area51_EventStart(playerid);
forward area51_PlayerJoinEvent(playerid);
forward area51_PlayerLeftEvent(playerid);
forward area51_OneSecond();

	/* Area 51*/

new Float:area51SpawnsCrim[][] = {
	{279.3872,1853.4196,8.7649,46.6290}, // scientists
	{279.3697,1857.1285,8.7578,86.3993}, // scientists
	{280.2726,1859.4811,8.7578,87.3393}, // scientists
	{280.0467,1863.3972,8.7578,132.7731}, // scientists
	{276.7597,1863.0476,8.7578,183.9194}, // scientists
	{273.2761,1862.8348,8.7649,176.0860}, // scientists
	{270.2394,1862.8462,8.7649,177.3394}, // scientists
	{266.1837,1862.7073,8.7649,177.3394}, // scientists
	{265.0922,1860.5519,8.7649,267.3394}, // scientists
	{264.8591,1858.8806,8.7578,267.3394}, // scientists
	{264.7762,1856.1311,8.7578,267.3394}, // scientists
	{264.8020,1853.6237,8.7578,267.2669}, // scientists
	{266.6061,1853.9335,8.7578,357.2668}, // scientists
	{268.2514,1852.7816,8.7578,357.2668}, // scientists
	{270.1913,1854.0057,8.7649,357.2668}, // scientists
	{272.4178,1854.2007,8.7649,357.2668}, // scientists
	{273.9746,1853.4885,8.7649,357.2668}, // scientists
	{275.8936,1854.1243,8.7649,357.2668}, // scientists
	{278.6028,1854.1470,8.7649,357.2668}, // scientists
	{271.3033,1857.2720,8.7578,356.8086}, // scientists
	{277.1699,1857.9691,8.7578,7.7753}, // scientists
	{274.6574,1870.0833,8.7578,188.0887} // scientists
};

new Float:area51SpawnsAF[][] = {
	{249.1421,1858.6547,14.0840,31.2755}, // specialforces
	{246.4541,1857.9417,14.0840,356.8085}, // specialforces
	{242.3931,1858.0775,14.0840,357.4352}, // specialforces
	{239.4496,1858.6327,14.0840,357.4352}, // specialforces
	{239.4159,1862.8751,14.0579,177.4352}, // specialforces
	{242.6534,1866.6704,11.4609,87.4352}, // specialforces
	{242.8867,1870.2795,11.4609,87.4352}, // specialforces
	{243.0420,1873.9398,11.4531,87.4352}, // specialforces
	{242.8285,1878.4154,11.4609,87.4352}, // specialforces
	{240.5322,1879.2211,11.4609,177.4352}, // specialforces
	{238.9083,1877.0898,11.4609,267.4352}, // specialforces
	{239.2016,1873.7242,11.4609,267.4352}, // specialforces
	{224.1701,1868.5939,13.1406,96.7394}, // specialforces
	{224.1644,1864.7734,13.1406,96.7394}, // specialforces
	{223.9597,1860.0316,13.1470,96.7394}, // specialforces
	{220.4644,1855.2480,12.9439,96.7394}, // specialforces
	{211.6315,1857.9827,13.1406,276.7394}, // specialforces
	{205.3705,1860.3811,13.1406,276.7394}, // specialforces
	{205.6592,1864.9984,13.1406,276.7394}, // specialforces
	{205.0756,1870.8951,13.1406,276.7394}, // specialforces
	{210.2287,1873.6332,13.1406,186.7395}, // specialforces
	{213.9226,1873.4716,13.1406,186.7395} // specialforces
};

public area51_EventStart(playerid)
{
   	new
	    string[256];

	FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	Event_ID = AREA51;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}United Special Forces vs. Nuclear Scientists Team DM {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	
	return 1;
}


public area51_PlayerJoinEvent(playerid)
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
		SetPlayerPos(playerid, area51SpawnsAF[increment][0], area51SpawnsAF[increment][1], area51SpawnsAF[increment][2]);
		SetPlayerFacingAngle(playerid, area51SpawnsAF[increment][3]);
		Motel_Team = 1;
		increment++;
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		PlayerEventStats[playerid][pteam] = 2;
		////SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 70);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, area51SpawnsCrim[increment-1][0], area51SpawnsCrim[increment-1][1], area51SpawnsCrim[increment-1][2]);
		SetPlayerFacingAngle(playerid, area51SpawnsCrim[increment-1][3]);
		Motel_Team = 0;
	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 25, 500);
	GivePlayerWeapon(playerid, 31, 500);
	GameTextForPlayer(playerid, "~R~~n~~n~ Area 51 ~h~ TDM!~n~~n~ ~w~You are now in the queue", 4000, 3);
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


public area51_PlayerLeftEvent(playerid)
{
	new
	    t1,
	    t2;
	new
	    msg[128];

    if(GetPlayerSkin(playerid) == 70)
	{
		Team1_Motel++;
	}

	else if(GetPlayerSkin(playerid) == 287)
	{
		Team2_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: US Special Forces %d - %d Nuclear Scientists", Team1_Motel, Team2_Motel);
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
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Nuclear Scientists have won the event!");
		Event_Bet_End(1);
		return 1;
	}
	else if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The US Special Forces have won the event!");
		Event_Bet_End(0);
		return 1;
	}
	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}
	return 1;
}


public area51_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Area 51 DM is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
	return 1;
}