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
* Filename: construction.pwn                                                     *
* Author: pEar                                                              	 *
*********************************************************************************/

new Float:constructionspawn1[][] = {		// Worker spawns
	{-2105.8777,132.7461,35.2208,84.3999},  
	{-2105.9705,130.5837,35.2083,87.5895},  
	{-2105.9905,128.0861,35.2340,86.7057},  
	{-2106.1968,125.5368,35.2601,87.0752},  
	{-2106.2571,122.5485,35.2908,87.4448},  
	{-2110.0081,122.7282,35.2889,86.5610},  
	{-2110.0093,125.4053,35.2615,86.3038},  
	{-2110.1201,128.0304,35.2345,86.9867},  
	{-2110.0186,130.4566,35.2103,84.8496},  
	{-2109.9939,133.1890,35.1421,86.4725},  
	{-2114.4136,133.4627,35.1809,87.4687},  
	{-2114.6108,130.9634,35.2025,85.9582},  
	{-2114.6724,128.4339,35.2229,86.3278},  
	{-2114.8159,125.8313,35.2447,87.0106},  
	{-2115.0244,123.0371,35.2857,88.3202} 	 
};

new Float:constructionspawn2[][] = {  		// Engineer spawns
	{-2082.0339,307.5149,35.4293,179.7911},  
	{-2083.8347,307.5473,35.4263,178.5939},  
	{-2085.6150,307.4026,35.4396,176.4568},  
	{-2087.9150,307.3770,35.4419,176.5130},  
	{-2090.9116,307.0113,35.4163,181.2693},  
	{-2090.9827,303.5557,35.3750,175.9987},  
	{-2088.4480,303.3395,35.4003,178.8750},  
	{-2085.8662,303.3599,35.4289,178.9312},  
	{-2084.1682,303.5374,35.4496,182.1208},  
	{-2081.7195,303.2591,35.4733,178.7303},  
	{-2081.8494,299.1623,35.4740,177.2198},  
	{-2083.8821,299.1319,35.4131,177.9026},  
	{-2086.2539,298.6504,35.3755,174.5122},  
	{-2088.4631,298.8038,35.3470,178.6417},  
	{-2090.8367,298.9302,35.3224,173.3712}  
};

forward construction_EventStart(playerid);
public construction_EventStart(playerid)
{
    FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	new
	    string[128];

	Event_ID = CONSTRUCTION;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}construction TDM {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	Motel_Team1 = 0;
	Motel_Team2 = 0;
}

forward construction_PlayerJoinEvent(playerid);
public construction_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1400);
	SetPlayerInterior(playerid, 0);
	
	if(Motel_Team == 0)
	{
		Team1++;
		SetPVarInt(playerid, "Team", 1);
		SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 27);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, constructionspawn1[increment][0], constructionspawn1[increment][1], constructionspawn1[increment][2] + 4);
		SetPlayerFacingAngle(playerid, constructionspawn1[increment][3]);
		Motel_Team = 1;
		increment++;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the Oil Rig.");
	}
	else
	{
		Team2++;
 		SetPVarInt(playerid, "Team", 2);
		SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 153);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, constructionspawn2[increment-1][0], constructionspawn2[increment-1][1], constructionspawn2[increment-1][2]);
		SetPlayerFacingAngle(playerid, constructionspawn2[increment-1][3]);
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

forward construction_PlayerLeftEvent(playerid);
public construction_PlayerLeftEvent(playerid)
{
	if(GetPVarInt(playerid, "Team") == 1)
	{
		Team1--;
	}
	else if(GetPVarInt(playerid, "Team") == 2)
	{
		Team2--;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: Workers %d - %d Engineers", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);

	SetPVarInt(playerid, "MotelTeamIssued", 0);
	
	if(Team1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The engineers have won the event!");
		return 1;
	}
	
	else if(Team2 == 0)
	{
		EndEvent();
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The workers have won the event!");
		increment = 0;
		return 1;
	}
	
	if(Iter_Count(Event_Players) == 1)
	{
		EndEvent();
	}
}

forward construction_OneSecond();
public construction_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Construction TDM is now in progress and can not be joined");

	foreach(Event_Players, player)
	{
		TogglePlayerControllable(player, 1);
		increment = 0;
		GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
	}
}
