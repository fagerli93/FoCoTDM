/*********************************************************************************
*                                                                                *
*             ______     _____        _______ _____  __  __                      *
*            |  ____|   / ____|      |__   __|  __ \|  \/  |                     *
*            | |__ ___ | |     ___      | |  | |  | | \  / |                     *
*            |  __/ _ \| |    / _ \     | |  | |  | | |\/| |                     *
*            | | | (_) | |___| (_) |    | |  | |__| | |  | |                     *
*            |_|  \___/ \_____\___/     |_|  |_____/|_|  |_|                     *
*                                                                                *
*                                                                                *
*                                                                                *
*			######## ##     ## ######## ##    ## ########  ######                *
*			##       ##     ## ##       ###   ##    ##    ##    ##               *
*			##       ##     ## ##       ####  ##    ##    ##                     *
*			######   ##     ## ######   ## ## ##    ##     ######                *
*			##        ##   ##  ##       ##  ####    ##          ##               *
*			##         ## ##   ##       ##   ###    ##    ##    ##               *
*			########    ###    ######## ##    ##    ##     ######                *
*                                                                                *
*                                                                                *
*                        (c) Copyright                                           *
*  Owners: Simon Fagerli (pEar) - Lee Percox (Shaney) - Warren Bickley (WazzaJB) *
*         Developers: Marcel, RakGuy, FKu, Chilco, dr_vista, Fletcher            *
*                                                                                *
* Filename: navyvsterrorists.pwn                                                 *
* Author: dr_vista                                                               *
*********************************************************************************/

new Float:navySealsBoat[][] = {
	{-1475.6034,1483.3225,1.5800,228.1285},
	{-1476.3745,1481.5135,1.5800,247.6117},
	{-1477.0802,1479.5178,1.5800,246.7279}, // Boatspawn_3
	{-1444.9019,1501.1514,1.7366,98.2065}, // Boatspawn_4
	{-1447.0107,1503.8995,1.7366,140.2498}, // Boatspawn_5
	{-1456.7163,1481.0428,7.1016,87.0388}, // Boatspawn_6
	{-1456.1177,1485.5995,7.1016,84.1065}, // Boatspawn_7
	{-1456.3177,1497.4828,7.1016,104.9317}, // Boatspawn_8
	{-1463.0660,1497.6965,8.2578,268.1799}, // Boatspawn_9
	{-1463.1732,1494.8063,8.2578,266.3562}, // Boatspawn_10
	{-1463.2122,1491.9156,8.2578,267.6658}, // Boatspawn_11
	{-1463.1044,1489.0294,8.2501,266.1552}, // Boatspawn_12
	{-1463.2954,1486.1844,8.2501,267.7782}, // Boatspawn_13
	{-1463.3452,1480.7723,8.2578,268.8307}, // Boatspawn_14
	{-1463.4204,1483.3024,8.2578,268.4611}, // Boatspawn_15
	{-1452.0812,1477.6252,1.3031,269.8831}, // Boatspawn_16
	{-1446.9612,1477.6980,1.3031,271.1364} // Boatspawn_17
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

forward navy_EventStart(playerid);
public navy_EventStart(playerid)
{
	FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

   	new
	    string[128];

	Event_ID = NAVYVSTERRORISTS;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Navy Seals vs. Terrorists {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
}

forward navy_PlayerJoinEvent(playerid);
public navy_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);

	if(Motel_Team == 0)
	{
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
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
		SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 221);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, terroristsBoat[increment-1][0], terroristsBoat[increment-1][1], terroristsBoat[increment-1][2]);
		SetPlayerFacingAngle(playerid, terroristsBoat[increment-1][3]);
		Motel_Team = 0;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the boat at all costs ...");
	}


	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 27, 500);
	GivePlayerWeapon(playerid, 31, 500);
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ Navy Seals Vs. Terrorists ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
}

forward navy_PlayerLeftEvent(playerid);
public navy_PlayerLeftEvent(playerid)
{
   	new
	   	t1,
		t2;
		
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
		return 1;
	}
	else if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Navy Seals have won the event!");
		return 1;
	}
	if(Iter_Count(Event_Players) == 1)
	{
		EndEvent();
	}
}

forward navy_OneSecond();
public navy_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Navy Seals Vs. Terrorists is now in progress and can not be joined");
	foreach(Event_Players, player)
	{
		TogglePlayerControllable(player, 1);
		increment = 0;
		GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
		DisablePlayerCheckpoint(player);
		if(GetPVarInt(player, "MotelTeamIssued") == 1)
		{
			SetPlayerCheckpoint(player, -1446.6353,1502.6423,1.7366, 4.0);
		}
	}
}
