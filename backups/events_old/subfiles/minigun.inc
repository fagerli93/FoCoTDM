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
* Filename: minigun.pwn                                                          *
* Author: dr_vista                                                               *
*********************************************************************************/

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


forward minigun_EventStart(playerid);
public minigun_EventStart(playerid)
{
   	new
	    string[128];
	    
	Event_ID = MINIGUN;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Minigun Wars {%06x}event. 30 seconds before it starts, type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
}

forward minigun_PlayerJoinEvent(playerid);
public minigun_PlayerJoinEvent(playerid)
{
    if(Iter_Count(Event_Players) == 17)
	{
		return SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
	}

	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerPos(playerid, minigunSpawnsType1[increment][0], minigunSpawnsType1[increment][1], minigunSpawnsType1[increment][2]);
	SetPlayerFacingAngle(playerid, minigunSpawnsType1[increment][3]);
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 38, 3000);
	GameTextForPlayer(playerid, "~R~~n~~n~ MINIGUN ~n~ WARS", 1500, 3);
	TogglePlayerControllable(playerid, 0);
	increment++;
}

forward minigun_PlayerLeftEvent(playerid);
public minigun_PlayerLeftEvent(playerid)
{
    SetPVarInt(playerid, "LeftEventJust", 1);

	if(Iter_Count(Event_Players) == 1)
	{
		winner = Iter_Random(Event_Players);
		format(msg, sizeof(msg), "				%s has won the Minigun Wars event!", PlayerName(winner));
		SendClientMessageToAll(COLOR_NOTICE, msg);
		SendClientMessage(winner, COLOR_NOTICE, "You have won the Minigun Wars event! You have earnt 10 score!");
		FoCo_Player[winner][score] += 10;
		lastEventWon = winner;
		EndEvent();
	}
}

forward minigun_OneSecond();
public minigun_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Minigun wars is now in progress and can not be joined");

	foreach(Event_Players, player)
	{
		TogglePlayerControllable(player, 1);
		SendClientMessage(player, COLOR_NOTICE, "Fuck them bitches up playa!");
		increment = 0;
	}
}
