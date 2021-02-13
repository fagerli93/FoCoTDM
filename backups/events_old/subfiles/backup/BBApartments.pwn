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
* Filename: BBApartment.pwn	                                                     *
* Author: pEar                                                              	 *
*********************************************************************************/

new Float:BBApartmentsspawn1[][] = {		// BB Apartment people spawn
	{190.3132,-107.4339,1.5487,266.3274},
	{190.2736,-104.8103,1.5486,271.0839},
	{190.5507,-110.0279,1.5487,268.3201},
	{190.6228,-112.2011,1.5488,269.3164},
	{190.2792,-102.5096,1.5477,269.6859},
	{177.5211,-107.4390,1.5429,89.8871},
	{177.5719,-110.4006,1.5428,88.0632},
	{177.5737,-104.6745,1.5428,87.8061},
	{177.5076,-102.3599,1.5494,88.8024},
	{177.2934,-112.5610,1.5495,88.8586},
	{184.1357,-111.2745,1.5391,177.9023},
	{186.2462,-111.4259,1.5391,179.2681},
	{188.9073,-111.2340,1.5391,180.8910},
	{181.1453,-111.0482,1.5391,178.1272},
	{178.6138,-111.2409,1.5391,179.7500},
	{184.1820,-104.0410,1.5391,1.5411},
	{181.3587,-103.9759,1.5391,0.9706},
	{178.6289,-103.9821,1.5391,357.8936},
	{186.4406,-104.0211,1.5391,357.6364},
	{188.9251,-103.9696,1.5391,358.0060
};

new Float:BBApartmentsspawn2[][] = {  		// BB Apartment people outside spawn
	{82.4859,-199.6205,1.5523,267.3867},
	{93.2241,-188.9318,1.4844,352.3008},
	{109.3611,-176.0876,1.5569,270.7048},
	{156.4855,-196.2015,5.0786,342.3304},
	{198.3395,-190.2608,7.5781,272.5693},
	{217.7787,-38.5138,10.0644,152.5849},
	{198.6599,-46.9922,10.0644,173.2650},
	{170.8556,-53.9015,1.5781,178.5917},
	{156.1466,-22.3064,1.5781,271.6292},
	{211.0651,24.9308,2.5708,274.1357},
	{202.7008,38.9834,2.5781,181.4114},
	{183.3735,16.3418,1.6330,150.1340},
	{202.4465,-34.7089,2.5703,350.0755},
	{221.0620,-23.4257,4.3617,178.6804},
	{174.7283,-40.3829,11.0373,181.5801},
	{69.3533,-150.8756,1.1874,273.7010},
	{76.0323,-82.9678,0.6920,256.7807},
	{160.4008,-163.1417,1.5781,97.3253},
	{200.4492,-153.9004,1.5781,181.9260},
	{133.7859,-43.5811,1.5781,192.2430},
	{151.3686,-6.4486,1.5781,268.6972},
	{152.0195,-54.5756,11.9588,207.9100},
	{92.7098,-158.6802,5.3547,305.6708},
	{92.1433,-165.0647,2.5938,267.8365},
	{160.8755,-181.7011,1.5781,265.9564},
	{210.5902,-180.6003,5.0786,7.1638},
	{207.7047,-201.7129,16.6039,1.8372},
	{167.0102,-198.2654,5.0786,348.0738},
	{110.4080,-133.3884,10.1395,279.1399},
	{85.4125,-86.9179,0.8665,259.3763}
};

forward BBApartments_EventStart(playerid);
public BBApartments_EventStart(playerid)
{
    FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	new
	    string[128];

	Event_ID = BBApartments;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}BBApartments TDM {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	Motel_Team1 = 0;
	Motel_Team2 = 0;
}

forward BBApartments_PlayerJoinEvent(playerid);
public BBApartments_PlayerJoinEvent(playerid)
{
	SetPlayerVirtualWorld(playerid, 1400);
	SetPlayerInterior(playerid, 0);

	if(Motel_Team == 0)
	{
	    SetPlayerArmour(playerid,99);
		SetPlayerHealth(playerid,99);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 3, 1);
		GivePlayerWeapon(playerid, 16, 1);
		GivePlayerWeapon(playerid, 24, 500);
		GivePlayerWeapon(playerid, 25, 100);
		GivePlayerWeapon(playerid, 31, 500);
		Team1++;
		SetPVarInt(playerid, "Team", 1);
		SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 283);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, BBApartmentsspawn1[increment][0], BBApartmentsspawn1[increment][1], BBApartmentsspawn1[increment][2] + 4);
		SetPlayerFacingAngle(playerid, BBApartmentsspawn1[increment][3]);
		Motel_Team = 1;
		increment++;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the apartments and DON'T let the rednecks plant the bomb!");
	}
	else
	{
		Team2++;
		SetPlayerArmour(playerid,25);
		SetPlayerHealth(playerid,99);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 6, 1);
		GivePlayerWeapon(playerid, 18, 1);
		GivePlayerWeapon(playerid, 24, 500);
		GivePlayerWeapon(playerid, 25, 100);
		GivePlayerWeapon(playerid, 3, 500);
		GivePlayerWeapon(playerid, 30, 500);
 		SetPVarInt(playerid, "Team", 2);
		SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 33);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, BBApartmentsspawn2[increment-1][0], BBApartmentsspawn2[increment-1][1], BBApartmentsspawn2[increment-1][2]);
		SetPlayerFacingAngle(playerid, BBApartmentsspawn2[increment-1][3]);
		Motel_Team = 0;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the apartments and plant the bomb!");
	}
	if (GetPVarInt(playerid, "Team") == 2 && Team2 == 15)
	{
		GivePlayerWeapon(playerid, 33, 50);
		SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You have been assigned a sniper rifle. Use it to its full potential.");
	}
	if ((GetPVarInt(playerid, "Team") == 2) && Team2 == 25)
	{
		GivePlayerWeapon(playerid, 35, 2);
		SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You have been assigned an RPG. Don't waste it!");
	}
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ BlueBerry Apartment Assault! ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
}

forward BBApartments_PlayerLeftEvent(playerid);
public BBApartments_PlayerLeftEvent(playerid)
{
	if(GetPVarInt(playerid, "Team") == 1)
	{
		Team1--;
	}
	else if(GetPVarInt(playerid, "Team") == 2)
	{
		Team2--;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: Sheriff's %d - %d Rednecks", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);

	SetPVarInt(playerid, "MotelTeamIssued", 0);

	if(Team1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Sheriff's won the event!");
		return 1;
	}

	else if(Team2 == 0)
	{
		EndEvent();
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Rednecks won the event!");
		increment = 0;
		return 1;
	}

	if(Iter_Count(Event_Players) == 1)
	{
		EndEvent();
	}
}

forward BBApartments_OneSecond();
public BBApartments_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: BBApartments TDM is now in progress and can not be joined");

	foreach(Event_Players, player)
	{
		TogglePlayerControllable(player, 1);
		increment = 0;
		GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
	}
}
