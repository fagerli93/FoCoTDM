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
* Filename: eHotFloor.pwn	                                                     *
* Author: pEar                                                                   *
*********************************************************************************/
#include <YSI/y_hooks>

#define HOTLAVA_OBJECTS_AMT 100			// Amount of objects	
#define HOTLAVA_INT 0					// Interior
#define HOTLAVA_WORLD 1300				// World
#define HOTLAVA_PICKUPS 5				// Amount of pickups
#define HOTLAVA_PICKUPS_ROTATE 8		// Time interval for when to rotate pickups
#define HOTLAVA_MAXDISCO 10 			// Amount of floors that are "disco" at the same time, aka can be removed.


forward HotLava_EventStart(playerid);
forward HotLava_PlayerJoinEvent(playerid);
forward HotLava_PlayerLeftEvent(playerid);
forward HotLava_OneSecond();
forward HotLava_CreateObjects();
forward HotLava_SetDisco(Object_ID, ONOFF);
forward HotLava_StarterDisco();
forward Timer_Delete1Disco();
forward Timer_RotateHotLavaPickups();
forward HotLava_PickNewDisco(OldFloor);
forward HotLava_SetDisco(Object_ID, ONOFF);
forward HotLava_CreatePickups();
forward HotLava_RotatePickups();
forward HotLava_DeletePickups();
forward HotLava_DeleteObjects();

new HotLava_Objects[HOTLAVA_OBJECTS_AMT];		// To save the ObjectID	
new HotLava_Pickups[HOTLAVA_PICKUPS][3];		// To save the pickupid, what floor its on + weapontype
new HotLava_Disco[HOTLAVA_MAXDISCO];			// For the floors that is about to disappear

new eCount;

new HotLava_Weapons[5][2] = {
	{16, 1},
	{39, 1},
	{42, 100},
	{41, 100},
	{5, 1}
};


new Float:HotLavaSpawns[100][3] = {
	{-1325.04236, -38.99037, 315.83129},
	{-1325.06238, -43.00336, 315.83129},
	{-1325.03809, -50.95611, 315.83129},
	{-1325.04590, -46.95227, 315.83129},
	{-1325.03052, -54.90028, 315.83129},
	{-1325.05591, -58.83403, 315.83129},
	{-1325.07178, -35.13192, 315.83129},
	{-1325.03296, -31.16065, 315.83129},
	{-1325.05676, -27.14945, 315.83129},
	{-1332.91614, -23.24766, 315.83129},
	{-1328.99780, -23.25156, 315.83129},
	{-1325.07678, -23.26660, 315.83129},
	{-1360.57532, -23.26512, 315.83129},
	{-1356.60547, -23.25020, 315.83129},
	{-1336.87549, -23.25648, 315.83129},
	{-1340.83655, -23.27451, 315.83129},
	{-1344.75415, -23.24675, 315.83129},
	{-1348.70227, -23.25860, 315.83129},
	{-1352.66785, -23.27390, 315.83129},
	{-1360.57263, -27.19129, 315.83129},
	{-1360.58142, -31.11603, 315.83129},
	{-1360.60205, -35.10261, 315.83129},
	{-1360.60657, -39.06613, 315.83129},
	{-1360.59290, -43.00441, 315.83129},
	{-1360.56750, -46.99152, 315.83129},
	{-1360.57483, -50.97253, 315.83129},
	{-1360.60913, -54.95314, 315.83129},
	{-1360.62622, -58.91488, 315.83129},
	{-1356.66577, -58.90964, 315.83129},
	{-1356.59583, -27.16965, 315.83129},
	{-1356.59863, -31.12849, 315.83129},
	{-1356.62146, -35.10458, 315.83129},
	{-1356.63574, -39.08411, 315.83129},
	{-1356.60486, -42.99942, 315.83129},
	{-1356.61926, -46.98406, 315.83129},
	{-1356.63391, -50.95860, 315.83129},
	{-1356.64868, -54.95394, 315.83129},
	{-1352.67297, -58.90933, 315.83129},
	{-1352.65759, -54.93424, 315.83129},
	{-1352.64905, -50.95204, 315.83129},
	{-1352.64941, -46.97109, 315.83129},
	{-1352.67664, -42.99039, 315.83129},
	{-1352.65308, -39.08185, 315.83129},
	{-1352.63306, -35.06963, 315.83129},
	{-1352.62805, -31.11941, 315.83129},
	{-1352.63843, -27.19353, 315.83129},
	{-1348.68518, -58.90380, 315.83129},
	{-1348.67834, -54.92022, 315.83129},
	{-1348.67139, -50.93648, 315.83129},
	{-1348.66736, -46.97561, 315.83129},
	{-1348.67566, -43.00715, 315.83129},
	{-1348.67041, -39.08803, 315.83129},
	{-1348.66541, -35.10290, 315.83129},
	{-1348.63843, -31.13586, 315.83129},
	{-1348.69275, -27.20925, 315.83129},
	{-1344.70605, -58.87401, 315.83129},
	{-1344.70361, -54.90023, 315.83129},
	{-1344.68091, -50.93701, 315.83129},
	{-1344.69983, -46.93708, 315.83129},
	{-1344.70959, -42.99032, 315.83129},
	{-1344.74475, -39.07287, 315.83129},
	{-1344.72156, -35.11003, 315.83129},
	{-1344.76147, -31.14415, 315.83129},
	{-1344.75623, -27.22277, 315.83129},
	{-1340.72791, -54.91198, 315.83129},
	{-1340.72949, -50.92691, 315.83129},
	{-1340.72437, -58.89553, 315.83129},
	{-1340.79260, -46.92686, 315.83129},
	{-1340.80676, -42.99842, 315.83129},
	{-1340.80688, -39.03880, 315.83129},
	{-1340.82788, -35.11507, 315.83129},
	{-1340.83276, -31.12970, 315.83129},
	{-1340.84412, -27.22088, 315.83129},
	{-1336.87573, -27.20867, 315.83129},
	{-1336.89172, -31.10860, 315.83129},
	{-1336.86145, -35.05815, 315.83129},
	{-1336.84412, -39.01952, 315.83129},
	{-1336.82239, -43.02003, 315.83129},
	{-1336.82703, -46.96984, 315.83129},
	{-1336.82239, -50.89503, 315.83129},
	{-1336.81750, -54.90057, 315.83129},
	{-1336.84839, -58.88559, 315.83129},
	{-1332.99707, -58.88642, 315.83129},
	{-1332.91614, -54.87609, 315.83129},
	{-1332.92065, -50.94764, 315.83129},
	{-1332.94360, -46.99157, 315.83129},
	{-1332.93738, -43.02204, 315.83129},
	{-1332.93823, -39.02057, 315.83129},
	{-1332.95605, -35.09764, 315.83129},
	{-1332.95435, -31.13017, 315.83129},
	{-1332.91235, -27.20729, 315.83129},
	{-1329.00403, -58.87101, 315.83129},
	{-1328.97424, -54.88081, 315.83129},
	{-1328.94080, -50.97627, 315.83129},
	{-1328.98938, -46.95166, 315.83129},
	{-1329.00708, -42.98401, 315.83129},
	{-1329.02161, -38.99137, 315.83129},
	{-1328.97424, -35.12236, 315.83129},
	{-1328.97266, -31.15610, 315.83129},
	{-1328.98511, -27.15332, 315.83129}
};	

public HotLava_EventStart(playerid)
{
	new string[256], i, j, k;
	
	FoCo_Event_Rejoin = 0;
	
	foreach(Player, k)
	{
		FoCo_Event_Died[k] = 0;
	}
	for(i = 0; i < 5; i++)
	{
		HotLava_Pickups[i][0] = -1;
		HotLava_Pickups[i][1] = -1;
		HotLava_Pickups[i][2] = -1;
		DebugMsg("Reset pickups array");
	}
	for(j = 0; j < 10; i++)
	{
		HotLava_Disco[j] = -1;
	}
	Event_ID = HOTLAVA;
	
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}HotLava{%06x} event. Type /join! Price: %f", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, FFA_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	HotLava_CreateObjects();
	HotLava_CreatePickups();
	eCount = 0;
	return 1;
}

public HotLava_PlayerJoinEvent(playerid)
{
	if(eCounter >= 100)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The event is full");
	}	
	ResetPlayerWeapons(playerid);
	SetPlayerHealth(playerid, 150);
	SetPlayerArmour(playerid, 100);
	SetPlayerVirtualWorld(playerid, HOTLAVA_WORLD);
	SetPlayerInterior(playerid, HOTLAVA_INT);
	//SetPVarInt(playerid, "eSkin", GetPlayerSkin(playerid));
	//SetPVarInt(playerid, "eColor", GetPlayerColor(playerid));
	SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
	SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
	SetPlayerColor(playerid, COLOR_BLUE);
	SetPlayerSkin(playerid, 82); // elvis
	SetPVarInt(playerid, "InHotLava", 1);
	SetPlayerPos(playerid, HotLavaSpawns[eCounter][0], HotLavaSpawns[eCounter][1], HotLavaSpawns[eCounter][2]+1);
	
	SendClientMessage(playerid, COLOR_SYNTAX, "[EVENT]: The floor will disappear.. Your task is to be the last one alive, good luck!");
	GameTextForPlayer(playerid, "~R~~n~~n~ HotLava! ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
	
	eCounter++;
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -FFA_COST);
	        format(string, sizeof(string), "~r~-%d",FFA_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
 		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}

public HotLava_PlayerLeftEvent(playerid)
{
	new string[128], i;
	if(eCounter - 1 == 1)
	{
		foreach(Player, i)
		{
			if(GetPVarInt(i, "InHotLava") == 1)
			{
				format(string, sizeof(string), "[EVENT]: %s(%d) died and %s(%d) is therefore the winner of the HotLava event!", PlayerName(playerid), playerid, PlayerName(i), i);
				SendClientMessageToAll(COLOR_CMDNOTICE, string);
				break;
			}
		}
		EndEvent();
	}
	format(string, sizeof(string), "[EVENT]: %s(%d) died, there are %d survivors left!", PlayerName(playerid), playerid, eCounter-1);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	eCounter--;
	//SetPlayerColor(playerid, GetPVarInt(playerid, "eColor"));
	//SetPlayerSkin(playerid, GetPVarInt(playerid, "eSkin"));
	
	return 1;
}

public HotLava_OneSecond()
{
	new i;
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: HotLava is now in progress and can not be joined.");
	
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
	HotLava_StarterDisco();
	return 1;
}

public HotLava_StarterDisco()
{
	new i, rand, string[56];
	for(i = 0; i < HOTLAVA_MAXDISCO; i++)
	{
		PickingDisco:
		rand = random(100);
		format(string, sizeof(string), "Random Disco: Picked number: %d", rand);
		DebugMsg(string);
		for(j = 0; j < HOTLAVA_MAXDISCO; i++)
		{
			if(rand == HotLava_Disco[j])
			{
				DebugMsg("Disco: Number was already taken, picking a new one");
				goto PickingDisco;
			}
		}
		HotLava_Disco[i] = rand;
		HotLava_SetDisco(HotLava_Objects[rand], 1);
	}
	DebugMsg("Finished setting all starter disco floors");
	SetTimer("Timer_Delete1Disco", 3000, true);
	SetTimer("Timer_RotateHotLavaPickups", 8000, true);
	return 1;
}

public Timer_Delete1Disco()
{
	new rand, string[56];
	HotLava_1newDisco:
	rand = random(HOTLAVA_MAXDISCO);
	format(string, sizeof(string), "TimerD1Disco: Picked number %d to delete", rand);
	DebugMsg(string);
	DestroyDynamicObject(HotLava_Objects[HotLava_Disco[rand]]);
	HotLava_Objects[HotLava_Disco[rand]] = -1;
	HotLava_PickNewDisco(rand);
}

public Timer_RotateHotLavaPickups()
{
	HotLava_RotatePickups();
}

public HotLava_PickNewDisco(OldFloor)
{
	new rand, i;
	HotLava_PickingNewDisco:
	rand = random(HOTLAVA_OBJECTS_AMT);
	format(string, sizeof(string), "PickNewDisco: Picked %d", rand);
	DebugMsg(string);
	if(HotLava_Objects[rand] == -1)
	{
		DebugMsg("PickNewDisco: Floor already removed, picking another");
		goto HotLava_PickingNewDisco;
	}
	HotLava_SetDisco(HotLava_Objects[rand], 1);
	HotLava_Disco[OldFloor] = HotLava_Objects[rand];
	DebugMsg("Set the new floor disco");
	
	return 1;
}

public HotLava_CreateObjects()
{
	new i;
	for(i = 0; i <= HOTLAVA_OBJECTS_AMT; i++)
	{
		HotLava_Objects[i] = CreateDynamicObject(19128, HotLavaSpawns[i][0], HotLavaSpawns[i][1], HotLavaSpawns[i][2], 180.0, 0.0, 0.0, HOTLAVA_WORLD, HOTLAVA_INT); 
		SetDynamicObjectMaterial(HotLava_Objects[i], 0, 19454, "all_walls", "mp_motel_whitewall", 0xFFFFFFFF);//Add the White overcoat
	}
	DebugMsg("Created HotLava objects, event start.");
	return 1;
}

public HotLava_SetDisco(Object_ID, ONOFF)
{
	if(!ONOFF)
	{
		SetDynamicObjectMaterial(HotLava_Objects[Object_ID], 0, 19454, "all_walls", "mp_motel_whitewall", 0xFFFFFFFF);//Set it to White OverCoat
	}
	else
	{
		SetDynamicObjectMaterial(HotLava_Objects[Object_ID], 0, 19128, "none", "none", 0);//Set it back to Disco
	}
	return 1;
}

public HotLava_CreatePickups()
{
	new i, rand, rand_wpn, string[128];
	for(i = 0; i < HOTLAVA_PICKUPS; i++)
	{
		PickingNewRandomNumber:
		rand = random(100);
		format(string, sizeof(string), "Pickups: Picked space: %d", rand);
		DebugMsg(string);
		for(j = 0; i < HOTLAVA_PICKUPS; j++)
		{
			if(random == HotLava_Pickups[j][1])
			{
				DebugMsg("Pickups: Picked an already existing pickup position, getting a new");
				goto PickingNewRandomNumber;
			}
		}
		rand_wpn = random(5);
		HotLava_Pickups[i][0] = CreateDynamicPickup(Convert_Wpn_To_PickupID(HotLava_Weapons[rand_wpn][0]), 19, HotLavaSpawns[rand][0], HotLavaSpawns[rand][1], HotLavaSpawns[rand][2], 1300, 15, -1, 100);
		HotLava_Pickups[i][1] = rand;
		HotLava_Pickups[i][2] = HotLava_Weapons[rand_wpn][0]; // Keeping track of what weapon it is.
		DebugMsg("Created a pickup");
	}
	DebugMsg("All pickups created");
	return 1;
}

public HotLava_RotatePickups()
{
	new i;
	for(i = 0; i < HOTLAVA_PICKUPS; i++)
	{
		DestroyDynamicPickup(HotLava_Pickups[i][0]);
		HotLava_Pickups[i][1] = -1;
		HotLava_Pickups[i][2] = -1;
	}
	HotLava_CreatePickups();
	DebugMsg("Deleted and rotated pickups");
	return 1;
}

hook OnPlayerPickupDynamicPickup(playerid, pickupid)
{
	new string[128];
	if(pickupid >= HotLava_Pickups[0][0] && pickupid <= HotLava_Pickups[HOTLAVA_PICKUPS-1][0])
	{
		if(pickupid == HotLava_Pickups[0][0])
		{
			if(HotLava_Pickups[0][2] == 5)
			{
				GivePlayerWeapon(playerid, 5, 1);
			}
			else if(HotLava_Pickups[0][2] == 16)
			{
				GivePlayerWeapon(playerid, 16, 1);
			}
			else if(Hotlava_Pickups[0][2] == 39)
			{
				GivePlayerWeapon(playerid, 39, 1);
			}
			else if(HotLava_Pickups[0][2] == 41)
			{
				GivePlayerWeapon(playerid, 41, 100);
			}
			else if(HotLava_Pickups[0][2] == 42)
			{
				GivePlayerWeapons(playerid, 42, 100);
			}
		}
		else if (pickupid == HotLava_Pickups[1][0])
		{
			if(HotLava_Pickups[1][2] == 5)
			{
				GivePlayerWeapon(playerid, 5, 1);
			}
			else if(HotLava_Pickups[1][2] == 16)
			{
				GivePlayerWeapon(playerid, 16, 1);
			}
			else if(Hotlava_Pickups[1][2] == 39)
			{
				GivePlayerWeapon(playerid, 39, 1);
			}
			else if(HotLava_Pickups[1][2] == 41)
			{
				GivePlayerWeapon(playerid, 41, 100);
			}
			else if(HotLava_Pickups[1][2] == 42)
			{
				GivePlayerWeapons(playerid, 42, 100);
			}
		}
		else if (pickupid == HotLava_Pickups[2][0])
		{
			if(HotLava_Pickups[2][2] == 5)
			{
				GivePlayerWeapon(playerid, 5, 1);
			}
			else if(HotLava_Pickups[2][2] == 16)
			{
				GivePlayerWeapon(playerid, 16, 1);
			}
			else if(Hotlava_Pickups[2][2] == 39)
			{
				GivePlayerWeapon(playerid, 39, 1);
			}
			else if(HotLava_Pickups[2][2] == 41)
			{
				GivePlayerWeapon(playerid, 41, 100);
			}
			else if(HotLava_Pickups[2][2] == 42)
			{
				GivePlayerWeapons(playerid, 42, 100);
			}
		}
		else if (pickupid == HotLava_Pickups[3][0])
		{
			if(HotLava_Pickups[3][2] == 5)
			{
				GivePlayerWeapon(playerid, 5, 1);
			}
			else if(HotLava_Pickups[3][2] == 16)
			{
				GivePlayerWeapon(playerid, 16, 1);
			}
			else if(Hotlava_Pickups[3][2] == 39)
			{
				GivePlayerWeapon(playerid, 39, 1);
			}
			else if(HotLava_Pickups[3][2] == 41)
			{
				GivePlayerWeapon(playerid, 41, 100);
			}
			else if(HotLava_Pickups[3][2] == 42)
			{
				GivePlayerWeapons(playerid, 42, 100);
			}
		}
		else if (pickupid == HotLava_Pickups[4][0])
		{
			if(HotLava_Pickups[4][2] == 5)
			{
				GivePlayerWeapon(playerid, 5, 1);
			}
			else if(HotLava_Pickups[4][2] == 16)
			{
				GivePlayerWeapon(playerid, 16, 1);
			}
			else if(Hotlava_Pickups[4][2] == 39)
			{
				GivePlayerWeapon(playerid, 39, 1);
			}
			else if(HotLava_Pickups[4][2] == 41)
			{
				GivePlayerWeapon(playerid, 41, 100);
			}
			else if(HotLava_Pickups[4][2] == 42)
			{
				GivePlayerWeapons(playerid, 42, 100);
			}
		}
	}
	return 1;
}

public HotLava_DeletePickups()
{
	new i;
	for(i = 0; i < HOTLAVA_PICKUPS; i++)
	{
		DestroyDynamicPickup(HotLava_Pickups[i][0]);
	}
	DebugMsg("Destroyed all pickups");
	return 1;
}

public HotLava_DeleteObjects()
{
	new i;
	for(i = 0; i < HOTLAVA_OBJECTS_AMT; i++)
	{
		DestroyDynamicObject(HotLava_Objects[i]);
	}
	DebugMsg("Destroyed all objects");
	return 1;
}	





