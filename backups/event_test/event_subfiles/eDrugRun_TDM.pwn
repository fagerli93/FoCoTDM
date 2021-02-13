

new Timer:DrugDelayTimer;

forward drugrun_EventStart(playerid);
forward drugrun_PlayerJoinEvent(playerid);
forward drugrun_PlayerLeftEvent(playerid);
forward drugrun_OneSecond();




new Float:drugSpawnsType1[][] = {
	{386.3043,2548.5906,16.5391,174.1982},
	{386.2205,2546.2419,16.5391,177.9582},
	{386.1368,2543.9036,16.5391,177.9582},
	{386.0403,2541.1985,16.5391,177.9582},
	{385.9525,2538.7400,16.5391,177.9582},
	{385.8694,2536.4104,16.5391,177.9582},
	{385.7797,2533.8972,16.5391,177.9582},
	{385.6798,2531.1011,16.5491,177.9582},
	{383.5614,2530.6782,16.5759,177.9582},
	{383.5607,2533.7908,16.5391,177.9582},
	{383.8788,2536.5457,16.5391,177.9582},
	{383.9685,2539.5559,16.5391,177.9582},
	{383.9574,2542.3435,16.5391,177.9582},
	{383.9225,2544.8630,16.5391,177.9582},
	{383.7946,2547.6460,16.5391,177.9582},
	{381.6566,2547.5417,16.5391,177.9582},
	{381.5372,2544.2039,16.5391,177.9582},
	{381.4406,2541.4956,16.5391,177.9582},
	{381.3459,2538.8496,16.5391,177.9582},
	{381.2657,2536.6025,16.5391,177.9582},
	{381.1742,2534.0408,16.5482,177.9582},
	{381.0813,2531.4390,16.5880,177.9582},
	{379.1826,2531.0791,16.5973,177.9582},
	{379.3771,2533.8757,16.5763,177.9582},
	{379.3782,2536.8149,16.5391,177.9582},
	{378.6484,2539.3767,16.5391,177.9582},
	{379.3178,2540.9807,16.5391,177.9582},
	{379.2309,2544.4143,16.5391,177.9582},
	{379.1219,2547.0881,16.5391,177.9582},
	{379.1389,2548.8113,16.5391,177.9582}
};

new Float:drugSpawnsType2[][] = {
	{1754.4464,-1886.6516,13.5569,271.7347},
	{1756.4623,-1886.5906,13.5564,271.7347},
	{1759.0895,-1886.5109,13.5558,271.7347},
	{1761.2360,-1886.4458,13.5553,271.7347},
	{1763.8300,-1886.3678,13.5546,271.7347},
	{1766.9156,-1886.2738,13.5539,271.7347},
	{1769.2448,-1886.2031,13.5533,271.7347},
	{1769.6971,-1888.5441,13.5601,271.7347},
	{1767.4825,-1888.3868,13.5537,271.7347},
	{1765.1946,-1888.3080,13.5543,271.7347},
	{1762.0735,-1888.4391,13.5551,271.7347},
	{1758.4504,-1887.7513,13.5559,271.7347},
	{1755.7251,-1888.0513,13.5566,271.7347},
	{1752.6431,-1888.3499,13.5574,271.7347},
	{1752.7349,-1890.3278,13.5573,271.7347},
	{1755.6147,-1890.4915,13.5566,271.7347},
	{1758.5013,-1890.4045,13.5559,271.7347},
	{1761.5813,-1890.3114,13.5552,271.7347},
	{1764.6033,-1890.2196,13.5544,271.7347},
	{1767.3138,-1890.1372,13.5603,271.7347},
	{1770.0690,-1890.0535,13.5610,271.7347},
	{1770.9042,-1892.0048,13.5621,271.7347},
	{1768.0706,-1891.3242,13.5611,271.7347},
	{1765.2567,-1891.3208,13.5604,271.7347},
	{1763.0635,-1891.2950,13.5548,271.7347},
	{1760.6603,-1891.1453,13.5554,271.7347},
	{1758.0073,-1891.5461,13.5561,271.7347},
	{1755.7379,-1891.1418,13.5566,271.7347},
	{1753.4752,-1891.4116,13.5572,271.7347},
	{1753.9664,-1893.4374,13.5570,271.7347},
	{1755.9385,-1893.3779,13.5566,271.7347}
};

new DrugRunVehicles[][e_DrugRunVehicles] =
{
	{431, 1804.9897, -1928.3383, 13.4915, 359.5247},
	{567,1805.2609,-1911.4696,13.2676,359.9748},
	{567,1796.8599,-1931.1780,13.2519,2.8630},
	{536,1785.3833,-1931.5442,13.1238,0.4821},
	{567,1790.4397,-1931.3499,13.2531,359.2782},
	{560,1778.6602,-1932.2065,13.0915,359.6266},
	{522,1775.8104,-1925.5791,12.9557,228.7756},
	{455,1776.7750,-1911.1565,13.8224,182.1264},
	{433,325.4319,2541.5896,17.2446,178.8733},
	{433,291.5707,2542.2861,17.2572,181.1078},
	{470,331.9542,2527.1885,16.7732,89.7045},
	{470,339.5666,2527.3247,16.7636,89.7131},
	{470,345.7501,2527.4158,16.7324,90.8450},
	{470,352.0356,2527.3730,16.7001,90.3715},
	{470,358.3670,2527.4417,16.6720,91.0383},
	{470,364.3454,2527.4082,16.6404,89.8504}
};

timer DrugDelay[1000]()
{
	foreach(Player, i)
	{
		if(EventDrugDelay[i] > -1)
		{
			if(EventDrugDelay[i] == 0)
			{
				SetPVarInt(i, "MotelTeamIssued", 0);
				EndEvent();
				increment = 0;
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: Criminals succesfully dropped off the drugs!");
				EventDrugDelay[i] = -1;
				stop DrugDelayTimer;
				return 1;
			}

			EventDrugDelay[i]--;
		}
	}
	return 1;
}

public drugrun_EventStart(playerid)
{
    FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
		EventDrugDelay[i] = -1;
	}
	
	DrugDelayTimer = repeat DrugDelay();

   	new
	    string[256];

	Event_ID = DRUGRUN;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Team Drug Run {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;

	Iter_Clear(Event_Vehicles);

	for(new i; i < 16; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			new eCarID = CreateVehicle(DrugRunVehicles[i][modelID], DrugRunVehicles[i][dX], DrugRunVehicles[i][dY], DrugRunVehicles[i][dZ], DrugRunVehicles[i][Rotation], 1, 1, 600000);
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


public drugrun_PlayerJoinEvent(playerid)
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
		SetPlayerSkin(playerid, 285);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, drugSpawnsType1[increment][0], drugSpawnsType1[increment][1], drugSpawnsType1[increment][2]);
		SetPlayerFacingAngle(playerid, drugSpawnsType1[increment][3]);
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the checkpoint, don't let a drug runner enter ...");
		SendClientMessage(playerid, COLOR_GREEN, ".. it else they will win, you will win by eliminating there team..");
		Motel_Team = 1;
		increment++;
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		PlayerEventStats[playerid][pteam] = 2;
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 21);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, drugSpawnsType2[increment-1][0], drugSpawnsType2[increment-1][1], drugSpawnsType2[increment-1][2]);
		SetPlayerFacingAngle(playerid, drugSpawnsType2[increment-1][3]);
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the checkpoint, don't let the SWAT team ...");
		SendClientMessage(playerid, COLOR_GREEN, ".. kill you else you will lose. Your team MUST drop off the package..");
		Motel_Team = 0;
	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 31, 500);
	GameTextForPlayer(playerid, "~R~~n~~n~ Team Drug ~h~ Run!~n~~n~ ~w~You are now in the queue", 4000, 3);
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


public drugrun_PlayerLeftEvent(playerid)
{
   	new
	   t1,
	   t2,
	   msg[128];

    if(GetPlayerSkin(playerid) == 285)
	{
		Team2_Motel++;
	}
	else if(GetPlayerSkin(playerid) == 21)
	{
		Team1_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: SWAT %d - %d Drug Runners", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);
	DisablePlayerCheckpoint(playerid);

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
	
	if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: S.W.A.T have won the event!");
		Event_Bet_End(0);
		return 1;
	}

	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}

	return 1;
}


public drugrun_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Team Drug Run is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
			SetPlayerCheckpoint(i, 1421.5542,2773.9951,10.8203, 4.0);
		}
	}
}