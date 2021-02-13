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
* Filename: md.pwn                                                               *
* Author: dr_vista                                                               *
*********************************************************************************/

new Float:MadDogSpawns[][] = {
	{1263.6385,-785.9014,1091.9063,350.3100},
	{1286.0574,-773.1819,1091.9063,125.5029},
	{1273.1113,-786.8727,1089.9299,234.6888},
	{1287.5909,-787.6873,1089.9375,168.4299},
	{1275.2504,-806.2203,1089.9375,343.1032},
	{1287.5999,-803.9429,1089.9375,163.7300},
	{1274.9194,-812.7767,1089.9375,237.6540},
	{1287.4939,-817.5425,1089.9375,173.1067},
	{1283.2192,-836.4002,1089.9375,2.6517},
	{1278.3448,-811.8217,1085.6328,169.6600},
	{1291.7516,-826.0576,1085.6328,175.3000},
	{1258.6934,-836.8271,1084.0078,266.1441},
	{1247.4591,-828.0005,1084.0078,281.1843},
	{1241.9280,-821.6576,1083.1563,165.1048},
	{1231.1757,-808.4885,1084.0078,145.0280},
	{1243.5769,-817.6377,1084.0078,47.9172},
	{1267.7944,-812.7502,1084.0078,4.0501},
	{1245.6238,-803.8966,1084.0078,274.1459},
	{1270.5660,-795.3015,1084.1719,350.1416},
	{1253.7341,-793.5455,1084.2344,260.3591},
	{1234.2546,-756.3163,1084.0150,180.9400},
	{1256.3524,-767.4749,1084.0078,196.7027},
	{1261.5895,-779.9619,1084.0078,4.8685},
	{1276.6580,-765.4781,1084.0078,177.5891},
	{1303.3036,-781.4746,1084.0078,87.0349},
	{1297.5220,-794.7298,1084.0078,358.2882}
};

forward md_EventStart(playerid);
public md_EventStart(playerid)
{
	   	new
		    string[128];
	    
	    Event_ID = MADDOGG;
		format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Mad Dogg's Mansion DM {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
		SendClientMessageToAll(COLOR_CMDNOTICE, string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		Event_InProgress = 0;
}

forward md_PlayerJoinEvent(playerid);
public md_PlayerJoinEvent(playerid)
{
	if(Event_ID == MADDOGG)
	{
	    if(FFAArmour == 1)
        {
			SetPlayerArmour(playerid, 99);
		}

		else
		{
		    SetPlayerArmour(playerid, 0);
		}

		SetPlayerHealth(playerid, 99);
		SetPlayerVirtualWorld(playerid, 1500);
		SetPlayerInterior(playerid, 5);
		new randomnum = random(25);
		SetPlayerPos(playerid, MadDogSpawns[randomnum][0], MadDogSpawns[randomnum][1], MadDogSpawns[randomnum][2]);
		SetPlayerFacingAngle(playerid, MadDogSpawns[randomnum][3]);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, FFAWeapons, 500);
		GameTextForPlayer(playerid, "~R~~n~~n~ Mad ~h~ Dogs!", 800, 3);
	}
}
