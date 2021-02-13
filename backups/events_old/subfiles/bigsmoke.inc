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
* Filename: bigsmoke.pwn                                                         *
* Author: dr_vista                                                               *
*********************************************************************************/

new Float:BigSmokeSpawns[][] = {
	{2532.9614,-1281.3271,1048.2891},
	{2524.3040,-1281.9133,1048.2891},
	{2520.3289,-1280.6376,1054.6406},
	{2542.9700,-1282.7721,1054.6406},
	{2542.3420,-1300.4220,1054.6406},
	{2546.8904,-1288.1726,1054.6406},
	{2553.3010,-1281.7985,1054.6470},
	{2568.7739,-1306.1091,1054.6406},
	{2581.2690,-1301.6436,1060.9922},
	{2579.9753,-1285.3286,1065.3594},
	{2551.5872,-1294.1041,1060.9844},
	{2568.3835,-1283.0282,1044.1250},
	{2575.8843,-1283.1638,1044.1250},
	{2566.9451,-1297.7665,1037.7734},
	{2566.3384,-1282.9639,1031.4219},
	{2572.0032,-1304.9718,1031.4219},
	{2546.4976,-1301.6432,1031.4219},
	{2530.7329,-1289.0771,1031.4219},
	{2527.4521,-1289.3014,1031.4219},
	{2543.1543,-1321.8826,1031.4219}
};

forward bs_EventStart(playerid);
public bs_EventStart(playerid)
{
    new
	    string[128];
	    
    Event_ID = BIGSMOKE;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Bigsmoke {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
}

forward bs_PlayerJoinEvent(playerid);
public bs_PlayerJoinEvent(playerid)
{
	if(FFAArmour == 1)
    {
		SetPlayerArmour(playerid, 99);
	}

	else
	{
	    SetPlayerArmour(playerid, 0);
	}

	new randomnum = random(20);
	SetPlayerHealth(playerid, 99);
	SetPlayerInterior(playerid, 2);
	SetPlayerPos(playerid, BigSmokeSpawns[randomnum][0], BigSmokeSpawns[randomnum][1], BigSmokeSpawns[randomnum][2]);
	SetPlayerVirtualWorld(playerid, 1500);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, FFAWeapons, 500);
	GameTextForPlayer(playerid, "~R~~n~~n~ Big ~h~ Smoke!", 800, 3);
}
