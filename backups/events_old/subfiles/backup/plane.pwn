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
* Filename: plane.pwn                                                            *
* Author: pEar                                                             		 *
*********************************************************************************/


new Float:PlaneSpawnType1[][] = {
	{1328.5518,-1559.9976,85.5482,261.6124},    //Rooftop dawgs
	{1329.3683,-1557.3896,85.5463,261.6124},	//Rooftop dawgs
	{1330.0658,-1555.1370,85.5476,261.6124},    //Rooftop dawgs
	{1330.5431,-1552.1804,85.5474,261.6124},    //Rooftop dawgs
	{1331.0220,-1548.7018,85.5472,261.6124},    //Rooftop dawgs
	{1332.2554,-1546.1392,85.5466,261.6124},    //Rooftop dawgs
	{1332.7635,-1543.0079,85.5463,261.6124},    //Rooftop dawgs
	{1333.5088,-1540.2433,85.5416,261.6124},    //Rooftop dawgs
	{1334.3801,-1537.4669,85.5403,261.6124},    //Rooftop dawgs
	{1344.9246,-1538.3875,85.5469,261.6124},    //Rooftop dawgs
	{1344.9893,-1542.0388,85.5469,261.6124},    //Rooftop dawgs
	{1345.0310,-1545.0365,85.5469,261.6124},    //Rooftop dawgs
	{1345.0284,-1548.6929,85.5469,261.6124},    //Rooftop dawgs
	{1344.9261,-1553.1475,85.5469,261.6124},    //Rooftop dawgs
	{1345.2081,-1555.5400,85.5469,261.6124},    //Rooftop dawgs
	{1344.5015,-1558.4845,85.5469,261.6124},    //Rooftop dawgs
	{1344.6753,-1561.6006,85.5469,261.6124},    //Rooftop dawgs
	{1344.7461,-1564.0417,85.5469,261.6124},    //Rooftop dawgs
	{1355.2986,-1568.8292,85.5469,255.3456},    //Rooftop dawgs
	{1356.7955,-1566.4377,85.5469,255.3456},    //Rooftop dawgs
	{1358.2108,-1563.1442,85.5469,255.3456},    //Rooftop dawgs
	{1358.7550,-1560.6874,85.5469,255.3456},    //Rooftop dawgs
	{1359.8666,-1557.1820,85.5469,255.3456},    //Rooftop dawgs
	{1360.7386,-1553.7102,85.5469,255.3456},    //Rooftop dawgs
	{1362.2638,-1551.1743,85.5469,255.3456},    //Rooftop dawgs
	{1363.5792,-1548.6090,85.5469,255.3456},    //Rooftop dawgs
	{1363.4777,-1545.8019,85.5469,255.3456},    //Rooftop dawgs
	{1364.0255,-1543.0754,85.5469,255.3456},    //Rooftop dawgs
	{1365.5203,-1540.6907,85.5469,255.3456}    	//Rooftop dawgs
};

new Float:planeSpawnsType2[][] = {
	{1925.0658,-2493.0122,13.5391,357.6970},    //Plane boiis
	{1931.4568,-2492.7917,13.5391,357.6970},    //Plane boiis
	{1928.3070,-2500.7466,13.5391,5.5304}    	//Plane boiis
};

new Float:PlaneVehicles[][e_DrugRunVehicles] = { // 9 vehicles
	{476,1975.9609,-2465.9646,14.2023,1.1585},      //Rustler
	{476,1964.0143,-2466.1470,14.2526,358.0305},    //Rustler
	{513,1951.4690,-2465.6086,14.0839,4.4540},      //Stunt
	{513,1942.2288,-2467.2751,14.0909,5.0026},      //Stunt
	{511,1926.2672,-2467.2434,14.9142,0.1272},      //Bigugly shit
	{512,1909.5729,-2469.3928,13.8225,4.2735},      //Crop/farm plane
	{512,1897.4233,-2469.6670,13.8198,1.8400},      //Crop/farm plane
	{553,1902.1135,-2493.8718,14.8745,91.1515},     //Big one
	{519,1952.4246,-2493.4648,14.4610,270.0481}     //Shamal
};

forward plane_EventStart(playerid);
public plane_EventStart(playerid)
{
	FoCo_Event_Rejoin = 0;
	plane_team1 = 0;
	plane_team2 = 0;

	foreach(Player, i)
	{
	    FoCo_Event_Died[i] = 0;
	}

	new
	    string[128];

	Event_ID = PLANE;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Plane Survival {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;

	for(new i; i < 33; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			new eCarID = CreateVehicle(PlaneVehicles[i][modelID], PlaneVehicles[i][dX], PlaneVehicles[i][dY], PlaneVehicles[i][dZ], PlaneVehicles[i][Rotation], -1, -1, 600000);
			SetVehicleVirtualWorld(eCarID, 1500);
			eventVehicles[i] = eCarID;
			Iter_Add(Event_Vehicles, eCarID);
		}

		else
		{
			break;
		}
	}

    PlaneFallCheckTimer = repeat PlaneFallCheck();
	return 1;
}

forward plane_PlayerJoinEvent(playerid);
public plane_PlayerJoinEvent(playerid)
{
    SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);

	if(Motel_Team == 0 || Team1_Motel == 10 || Team1_Motel == 20)
	{
		Motel_Team = 1;
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		SetPlayerColor(playerid, COLOR_BLUE);
		plane_team1++;
		SetPlayerSkin(playerid, 61);
		SetPlayerPos(playerid, planeSpawnsType2[increment][0], planeSpawnsType2[increment][1], planeSpawnsType2[increment][2]);
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Ram the hobos off the roof with a plane of your own choosing.");
	}
    else
	{
	    Team1_Motel++;
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		SetPlayerSkin(playerid, 137);
		SetPlayerColor(playerid, COLOR_RED);
		plane_team2++;
        SetPlayerPos(playerid, PlaneSpawnType1[increment][0], PlaneSpawnType1[increment][1], PlaneSpawnType1[increment][2]);
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Stay alive!");

 	}

 	ResetPlayerWeapons(playerid);
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ Plane Survival! ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
	return 1;

}

forward plane_PlayerLeftEvent(playerid);
public plane_PlayerLeftEvent(playerid)
{
	new msg[128];

    if(GetPVarInt(playerid, "MotelTeamIssued") == 1)
	{
	    plane_team1--;
		format(msg, sizeof(msg), "[EVENT SCORE]: Pilots %d - %d Hobos", plane_team1, plane_team2);
		SendClientMessageToAll(COLOR_NOTICE, msg);
	}

	if(GetPVarInt(playerid, "MotelTeamIssued") == 2)
	{
		plane_team2--;
		format(msg, sizeof(msg), "[EVENT SCORE]: Pilots %d - %d Hobos", plane_team1, plane_team2);
		SendClientMessageToAll(COLOR_NOTICE, msg);
	}

	if(plane_team1 == 0)
	{
	    SendClientMessageToAll(COLOR_NOTICE, "[NOTICE]: The event ended due to all pilots dying.");
		EndEvent();
	}

	else if(plane_team2 == 0)
	{
     	SendClientMessageToAll(COLOR_NOTICE, "[NOTICE]: The event ended due to all hobos falling off the roof.");
		EndEvent();
	}


	SetPVarInt(playerid, "MotelTeamIssued", 0);
	return 1;
}

forward plane_OneSecond();
public plane_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Plane Survival is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
}

