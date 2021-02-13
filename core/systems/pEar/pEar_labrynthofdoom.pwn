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
* Filename: pEar_labrynthofdoom.pwn                                              *
* Author: pEar         		                                                     *
*********************************************************************************/

new Float:spawns[][] = {
	
};

new Big_Guy;
new minigun_pickup;

forward lod_EventStart(playerid);
public lod_EventStart(playerid)
{
	Big_Guy = -1;
	minigun_pickup = CreatePickup(362, 8, -1301.1038, -159.8598, 14.1521, 1400);
    FoCo_Event_Rejoin = 0;
	event_count = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	new
	    string[128];

	Event_ID = LABOFDOOM;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Labyrinth of Doom {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
}

forward lod_PlayerJoinEvent(playerid);
public lod_PlayerJoinEvent(playerid)
{
	event_count++;
	SetPlayerHealth(playerid, 50);
	SetPlayerVirtualWorld(playerid, 1400);
	SetPlayerInterior(playerid, 15);
	ResetPlayerWeapons(playerid);
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ Labyrinth of Doom! ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);

	SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
	SetPVarInt(playerid, "MotelColor", GetColor(playerid));
	SetPlayerSkin(playerid, 83);
	GivePlayerWeapon(playerid, 1, 1);
	SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: Your goal is to be the last survivor in the maze. Kill at any cost and avoid the maze killer!");
	SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: A minigun is spawned in the middle of the maze. Reach it first and receive a minigun and become the invisible maze killer!");
	SetPlayerColor(playerid, 0x2200FF);		// Blue-ish	
}

forward lod_PlayerLeftEvent(playerid);
public lod_PlayerLeftEvent(playerid)
{
	new string[128];
	event_count--;
	new i;
	if(event_count == 1)
	{
		foreach(Player, i)
		{
			if(GetPVarInt(i, "PlayerStatus") == 1)
			{
				winner = i;
				break;
			}	
		}
		format(string, sizeof(string), "[EVENT]: %s(%d) won the Labyrinth of Doom event!", PlayerName(i), i);
		EndEvent();
		return 1;
	}
    if(GetPlayerSkin(playerid) == 149)
	{
		new Float:x, float:y, float:z;
		GetPlayerPos(playerid, x, y, z);
		SendClientMessageToAll(COLOR_GREEN, "[INFO]: The maze killer was killed! His minigun is up for grabs!");
		minigun_pickup = CreatePickup(362, 8, x, y, z, 1400);
	}
	else
	{
		format(string, sizeof(string), "[EVENT]: Amount of players alive: %d", event_count);
		SendClientMessageToAll(COLOR_GREEN, string);
	}
	return 1;
}

forward lod_OneSecond();
public lod_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Labyrinth of Doom is now in progress and can not be joined. The minigun has spawned in the middle of the maze!");

	foreach(Event_Players, player)
	{
		TogglePlayerControllable(player, 1);
		increment = 0;
		GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
	}
	
	return 1;
}
