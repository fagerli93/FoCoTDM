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
* Filename: oilrig.pwn                                                           *
* Author: dr_vista                                                               *
*********************************************************************************/

new Float:swatoilrigspawns1[][] = {
	{-4989.2671,-1060.4849,62.3481,268.9522}, // SWATspawn1
	{-4989.2139,-1058.8197,62.3481,269.9485}, // SWATspawn2
	{-4989.2607,-1056.6619,62.3481,265.9313}, // SWATspawn3
	{-4989.2803,-1054.1078,62.3481,269.1208}, // SWATspawn4
	{-4989.1377,-1051.6665,62.3481,267.9237}, // SWATspawn5
	{-4989.0537,-1049.2660,62.3481,268.2932}, // SWATspawn6
	{-4989.0015,-1046.9961,62.3481,268.3495}, // SWATspawn7
	{-4988.9907,-1044.8541,62.3481,269.0324}, // SWATspawn8
	{-4989.0864,-1042.5729,62.3481,269.0886}, // SWATspawn9
	{-4984.8403,-1042.4364,62.3481,269.1448}, // SWATspawn10
	{-4984.7739,-1044.3013,62.3481,268.5744}, // SWATspawn11
	{-4984.6982,-1046.3790,62.3481,268.6869}, // SWATspawn12
	{-4984.5972,-1048.5526,62.3481,268.7432}, // SWATspawn13
	{-4984.3262,-1051.0364,62.3481,268.4861}, // SWATspawn14
	{-4984.2212,-1053.4729,62.3481,271.9891}, // SWATspawn15
	{-4984.1616,-1055.9543,62.3481,269.2253}, // SWATspawn16
	{-4984.1226,-1058.9647,62.3481,267.7148} // SWATspawn17
};

new Float:terroristoilrigspawns1[][] = { // terrorissts
	{-4848.1548,-1105.7831,52.1931,89.7017}, // Terrorspawn1
	{-4848.2217,-1104.4656,52.1929,87.5171}, // Terrorspawn2
	{-4848.2749,-1102.7365,52.1956,89.8487}, // Terrorspawn4
	{-4848.3560,-1101.0161,52.2002,89.0294}, // Terrorspawn3
	{-4848.4229,-1099.3506,52.2047,88.4292}, // Terrorspawn5
	{-4848.5532,-1097.4938,52.2097,88.2838}, // Terrorspawn6
	{-4848.5591,-1095.4310,52.2152,88.8179}, // Terrorspawn7
	{-4848.6245,-1093.4357,52.2206,87.7901}, // Terrorspawn8
	{-4854.3359,-1106.2627,52.1862,93.3493}, // Terrorspawn9
	{-4854.3325,-1104.7566,52.1902,89.1057}, // Terrorspawn10
	{-4854.3599,-1103.3361,52.1940,87.8238}, // Terrorspawn11
	{-4854.4463,-1101.3271,52.1994,91.0379}, // Terrorspawn12
	{-4854.5317,-1099.6100,52.2040,89.9278}, // Terrorspawn13
	{-4854.5986,-1097.7080,52.2283,89.0495}, // Terrorspawn14
	{-4854.8691,-1095.8661,52.2276,93.9821}, // Terrorspawn15
	{-4854.9053,-1094.2699,52.2275,89.5147}, // Terrorspawn16
	{-4854.8970,-1092.4136,52.2275,85.0473} // Terrorspawn17
};

forward oilrig_EventStart(playerid);
public oilrig_EventStart(playerid)
{
    FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	new
	    string[128];

	Event_ID = OILRIG;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Oil Rig Terrorists {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
}

forward oilrig_PlayerJoinEvent(playerid);
public oilrig_PlayerJoinEvent(playerid)
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
		SetPlayerPos(playerid, swatoilrigspawns1[increment][0], swatoilrigspawns1[increment][1], swatoilrigspawns1[increment][2] + 4);
		SetPlayerFacingAngle(playerid, swatoilrigspawns1[increment][3]);
		Motel_Team = 1;
		increment++;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the Oil Rig.");
	}
	else
	{
 		SetPVarInt(playerid, "MotelTeamIssued", 2);
		SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 221);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, terroristoilrigspawns1[increment-1][0], terroristoilrigspawns1[increment-1][1], terroristoilrigspawns1[increment-1][2]);
		SetPlayerFacingAngle(playerid, terroristoilrigspawns1[increment-1][3]);
		Motel_Team = 0;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the Oil Rig ...");
	}
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 27, 500);
	GivePlayerWeapon(playerid, 31, 500);
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ Oil Rig Terrorists ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
}

forward oilrig_PlayerLeftEvent(playerid);
public oilrig_PlayerLeftEvent(playerid)
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
		return 1;
	}
	
	else if(t2 == 0)
	{
		EndEvent();
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: SWAT have won the event!");
		increment = 0;
		return 1;
	}
	
	if(Iter_Count(Event_Players) == 1)
	{
		EndEvent();
	}
}

forward oilrig_OneSecond();
public oilrig_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Oil Rig Terrorists is now in progress and can not be joined");

	foreach(Event_Players, player)
	{
		TogglePlayerControllable(player, 1);
		increment = 0;
		GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
	}
}
