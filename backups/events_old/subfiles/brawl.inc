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
* Filename: brawl.pwn                                                            *
* Author: dr_vista                                                               *
*********************************************************************************/

forward brawl_EventStart(playerid);
public brawl_EventStart(playerid)
{
    if(BrawlX == 0.0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Set the brawl point first");
		return 1;
	}
	
   	new
	    string[128];

	Event_ID = BRAWL;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Brawl event. {%06x}Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
}

forward brawl_PlayerJoinEvent(playerid);
public brawl_PlayerJoinEvent(playerid)
{
	GiveAchievement(playerid, 24);
	SetPVarInt(playerid,"PlayerStatus",1);
	SetPlayerPos(playerid, BrawlX, BrawlY, BrawlZ);
	SetPlayerFacingAngle(playerid, BrawlA);
	SetPlayerInterior(playerid, BrawlInt);
	SetPlayerHealth(playerid, 99);
	SetPlayerArmour(playerid, 0);
	SetPlayerVirtualWorld(playerid, BrawlVW);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ The ~h~ Brawl!", 800, 3);
}
