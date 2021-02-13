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
* Filename: pursuit.pwn                                                          *
* Author: dr_vista                                                               *
*********************************************************************************/

new Float:pursuitVehicles[][] = {
	{565.6188,-1244.3657,16.9157,295.8679},
	{566.4626,-1238.9558,16.9824,294.7580},
	{563.5314,-1232.3390,16.9785,293.8539},
	{562.1167,-1228.7739,16.9802,293.5553},
	{570.1106,-1219.6626,17.3587,264.5331},
	{581.5428,-1241.3715,17.4123,324.3894},
	{546.8007,-1234.5836,16.5933,301.3257},
	{548.7852,-1240.2753,16.5859,298.6667},
	{551.3083,-1245.8103,16.5883,298.6719},
	{553.7662,-1248.9722,16.6187,302.2399},
	{612.4984,-1224.6945,17.8323,289.7163}
};

forward pursuit_EventStart(playerid);
public pursuit_EventStart(playerid)
{
    FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

   	new
	    string[128];

	Event_ID = PURSUIT;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Pursuit {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;

	new car;
	Iter_Clear(Event_Vehicles);
	for(new i = 0; i < 11; i++)
	{
		if(i == 10)
		{
			car = CreateVehicle(Random_Pursuit_Vehicle(), pursuitVehicles[i][0], pursuitVehicles[i][1], pursuitVehicles[i][2], pursuitVehicles[i][3], 1, 0, 600000);
			SetVehicleVirtualWorld(car, 1500);
			E_Pursuit_Criminal = car;
		}
		else
		{
			car = CreateVehicle(596, pursuitVehicles[i][0], pursuitVehicles[i][1], pursuitVehicles[i][2], pursuitVehicles[i][3], 1, 0, 600000);
			SetVehicleVirtualWorld(car, 1500);
		}
		
		Iter_Add(Event_Vehicles, car);
	}
}

forward pursuit_PlayerJoinEvent(playerid);
public pursuit_PlayerJoinEvent(playerid)
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
		SetPlayerColor(playerid, COLOR_RED);
		FoCo_Criminal = playerid;
		PlayerPursuitTimer[playerid] = SetTimerEx("EndPursuit", 300000, false, "i", playerid);
		SetPlayerSkin(playerid, 50);
		PutPlayerInVehicle(playerid, E_Pursuit_Criminal, 0);
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Stay alive, evade the PD ...");
		Motel_Team = 1;
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 280);
		SetPlayerColor(playerid, COLOR_BLUE);
		
		foreach(new i : Event_Vehicles)
		{
		    if(GetVehicleDriver(i) == INVALID_PLAYER_ID)
		    {
		        PutPlayerInVehicle(playerid, i, 0);
                LastVehicle[playerid] = i;
                break;
		    }
		}
		
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Take out the criminal car at all costs ...");
		
		if(FoCo_Criminal != INVALID_PLAYER_ID)
		{
			SetPlayerMarkerForPlayer( playerid, FoCo_Criminal, 0xFFFFFF00);
		}
 	}
 	
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 25, 500);
	GivePlayerWeapon(playerid, 29, 500);
	GameTextForPlayer(playerid, "~R~~n~~n~ Pursuit ~h~ ~n~~n~ ~w~You are now in the queue", 4000, 3);
}

forward pursuit_PlayerLeftEvent(playerid);
public pursuit_PlayerLeftEvent(playerid)
{
    if(GetPVarInt(playerid, "MotelTeamIssued") == 1)
	{
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the criminal being caught!");
		EndEvent();
		return 1;
	}

	new team_issue;
	foreach(new i : Player)
	{
		if(GetPVarInt(i, "MotelTeamIssued") == 2)
		{
			team_issue++;
		}
	}

	if(team_issue == 0)
	{
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the police being killed!");
		EndEvent();
	}

	SetPVarInt(playerid, "MotelTeamIssued", 0);
}

forward EndPursuit(playerid);
public EndPursuit(playerid)
{
	SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the criminal getting away!");
	EndEvent();

	SetPVarInt(playerid, "MotelTeamIssued", 0);
	SetPVarInt(playerid,"PlayerStatus",0);
	Motel_Team = 0;
	KillTimer(PlayerPursuitTimer[playerid]);
	return 1;
}

forward pursuit_OneSecond();
public pursuit_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Pursuit is now in progress and can not be joined");

	foreach(Event_Players, player)
	{
		TogglePlayerControllable(player, 1);
		increment = 0;
		GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
	}
}

forward Random_Pursuit_Vehicle();
public Random_Pursuit_Vehicle()
{
	new randVeh, vehicle;
	randVeh = random(50);
	switch(randVeh)
	{
		case 0: { vehicle = 402; }
		case 1: { vehicle = 405; }
		case 2: { vehicle = 402; }
		case 3: { vehicle = 426; }
		case 4: { vehicle = 434; }
		case 5: { vehicle = 439; }
		case 6: { vehicle = 402; }
		case 7: { vehicle = 489; }
		case 8: { vehicle = 495; }
		case 9: { vehicle = 412; }
		case 10: { vehicle = 419; }
		case 11: { vehicle = 421; }
		case 12: { vehicle = 422; }
		case 13: { vehicle = 426; }
		case 14: { vehicle = 436; }
		case 15: { vehicle = 445; }
		case 16: { vehicle = 466; }
		case 17: { vehicle = 467; }
		case 18: { vehicle = 470; }
		case 19: { vehicle = 474; }
		case 20: { vehicle = 475; }
		case 21: { vehicle = 477; }
		case 22: { vehicle = 491; }
		case 23: { vehicle = 492; }
		case 24: { vehicle = 500; }
		case 25: { vehicle = 506; }
		case 26: { vehicle = 508; }
		case 27: { vehicle = 516; }
		case 28: { vehicle = 517; }
		case 29: { vehicle = 526; }
		case 30: { vehicle = 527; }
		case 31: { vehicle = 529; }
		case 32: { vehicle = 533; }
		case 33: { vehicle = 534; }
		case 34: { vehicle = 535; }
		case 35: { vehicle = 536; }
		case 36: { vehicle = 537; }
		case 37: { vehicle = 540; }
		case 38: { vehicle = 542; }
		case 39: { vehicle = 549; }
		case 40: { vehicle = 550; }
		case 41: { vehicle = 555; }
		case 42: { vehicle = 566; }
		case 43: { vehicle = 567; }
		case 44: { vehicle = 575; }
		case 45: { vehicle = 576; }
		case 46: { vehicle = 579; }
		case 47: { vehicle = 580; }
		case 48: { vehicle = 587; }
		case 49: { vehicle = 602; }
		case 50: { vehicle = 603; }
	}
	return vehicle;
}


stock GetVehicleDriver(vid)
{
     foreach(new i : Player)
     {
          if(!IsPlayerConnected(i)) continue;
          if(GetPlayerVehicleID(i) == vid && GetPlayerSeat(playerid) == 0) return i;
     }
     
     return INVALID_PLAYER_ID;
}

