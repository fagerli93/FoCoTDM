
#include <YSI\y_hooks>


forward lod_EventStart(playerid);
forward lod_PlayerJoinEvent(playerid);
forward lod_PlayerLeftEvent(playerid);
forward lod_OneSecond();
forward lod_CreatePickups();

new LOD_Pickups_Wpns[24][2]={
	{38, 250},			// Weapons...
	{4, 1},				// Knife		
	{4, 1},
	{5, 1},				// Baseball bat
	{5, 1},
	{5, 1},
	{8, 1},				// Katana
	{8, 1},
	{8, 1},
	{16, 1},			// Grenade
	{22, 16},			// Colts	
	{22, 16},
	{24, 6},			// Deagle
	{24, 6},
	{24, 6},
	{25, 4},			// Shotgun
	{25, 4},
	{27, 4},			// Spaz
	{28, 16},			// Uzi	
	{29, 16},			// Tec9
	{29, 12},
	{33, 4},			// Rifle
	{-2, -1},			// Health
	{-3, -2}			// Armour	
};
	
new Float:LODSpawns[][] = {
//       {X,           Y,        Z,      F.Angle},
	{-1269.31079, -184.90305, 14.48314, 316.20010},
	{-1290.38855, -194.80191, 14.48314, 288.60019},
	{-1295.84851, -186.64136, 14.48314, 278.34042},
	{-1314.94373, -190.27203, 14.48314, 371.76038},
	{-1313.26184, -179.47920, 14.48314, 472.74030},
	{-1326.71619, -169.87340, 14.48314, 559.02032},
	{-1333.54614, -163.37999, 14.48314, 687.72015},
	{-1324.27710, -141.02721, 14.48314, 658.86047},
	{-1313.45068, -171.29492, 14.48314, 921.24042},
	{-1316.32080, -152.14087, 14.48314, 658.86047},
	{-1311.41321, -136.53891, 14.48314, 853.20038},
	{-1313.51331, -125.69548, 14.48314, 658.86047},
	{-1289.26099, -120.86032, 14.48314, 613.74091},
	{-1289.46631, -125.68723, 14.48314, 483.42111},
	{-1294.40320, -139.28931, 14.48314, 433.44128},
	{-1281.11902, -139.04866, 14.48314, 433.44128},
	{-1285.06506, -156.10376, 14.48314, 734.40088},
	{-1275.04504, -158.18692, 14.48314, 909.90088},
	{-1258.81458, -159.21292, 14.48314, 986.58105},
	{-1265.82983, -182.27867, 14.48314, 228.84012},
	{-1295.44727, -177.97021, 14.48314, 846.48071},
	{-1301.97693, -146.63158, 14.48314, 1064.52026},
	{-1305.83057, -163.73715, 14.48314, 1041.12012},
	{-1313.37573, -185.90051, 14.48314, 460.62039},
	{-1318.69202, -161.32632, 14.48314, 821.94043},
	{-1266.31335, -167.60268, 14.48314, 965.28082},
	{-1283.51465, -181.74178, 14.48314, 288.60019},
	{-1318.03076, -174.03755, 14.48314, 678.66016},
	{-1272.98914, -181.81252, 14.48314, 228.84012},
	{-1279.70813, -165.89082, 14.48314, 709.92096},
	{-1272.47229, -137.41809, 14.48314, 404.64114},
	{-1299.66858, -142.83426, 14.48314, 1224.78015},
	{-1301.51013, -126.38577, 14.48314, 1289.99988},
	{-1322.37671, -143.40271, 14.48314, 798.60046},
	{-1279.20776, -173.71681, 14.48314, 528.06079},
	{-1274.75757, -192.12358, 14.48314, 299.16016},
	{-1327.66943, -152.61955, 14.48314, 658.86047},
	{-1286.42285, -139.81818, 14.48314, 445.20129},
	{-1302.89551, -181.95766, 14.48314, 846.48071},
	{-1289.26941, -152.22482, 14.48314, 1284.06055},
	{-1293.30994, -165.06348, 14.48314, 1065.12048},
	{-1298.57678, -130.32242, 14.48314, 488.94128},
	{-1273.75208, -127.14831, 14.48314, 397.08121},
	{-1336.02368, -157.08954, 14.48314, 715.86035},
	{-1263.15369, -167.18446, 14.48314, 1072.92114},
	{-1285.36133, -126.66288, 14.48314, 1141.80090},
	{-1268.06006, -142.97409, 14.48314, 758.76086},
	{-1302.00891, -172.96091, 14.48314, 952.20056},
	{-1301.86499, -153.43987, 14.41613, 1130.22021},
	{-1312.75818, -153.16017, 14.48314, 797.82080}
};

new Float:LODWeapSpawns[][]=
{
//       {X           Y          Z},
	{-1300.97205, -159.67439, 13.83044},//Minigun
	{-1313.61536, -175.36996, 13.83044},
	{-1279.37183, -181.09349, 13.83044},
	{-1282.68872, -152.78357, 13.83044},
	{-1290.02942, -128.65575, 13.83044},
	{-1313.65784, -143.80534, 13.83044},
	{-1313.74316, -164.69156, 13.83044},
	{-1308.84253, -192.16008, 13.83044},
	{-1290.51270, -159.48505, 13.83044},
	{-1290.82776, -186.10498, 13.83044},
	{-1275.25024, -172.27773, 13.83044},
	{-1317.84070, -157.21277, 13.83044},
	{-1325.45667, -185.79550, 13.83044},
	{-1264.94653, -163.76163, 13.83044},
	{-1302.67725, -165.69922, 13.83044},
	{-1269.81775, -147.92334, 13.83044},
	{-1294.41589, -171.37044, 13.83044},
	{-1331.27710, -144.20746, 13.83044},
	{-1293.93787, -133.99074, 13.83044},
	{-1322.97827, -160.46480, 13.83044},
	{-1286.4387,-143.4553,13.83044},
	{-1305.2832,-123.7546,13.83044},
	{-1328.6385,-152.8032,13.83044},
	{-1274.6973,-160.9594,13.83044}
};

forward LOD_MazeKillerTimer();
public LOD_MazeKillerTimer()
{
	SetPlayerColor(Maze_Killer, COLOR_RED);
	SendClientMessageToAll(COLOR_GREEN, "[EVENT]: The maze killer is marked in RED, he may have a minigun or he might've ran out of ammo.");
	SendClientMessageToAll(COLOR_GREEN, "[EVENT]: If you kill him, you will become the maze killer!");
	return 1;
}

public lod_EventStart(playerid)
{
	Maze_Killer = -1;
	lod_CreatePickups();
    FoCo_Event_Rejoin = 0;
	event_count = 0;
	rotate_pickups_lod = LOD_EVENT_SLOTS - 1;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	new
	    string[128];

	Event_ID = LOD;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Labyrinth of Doom {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	
	return 1;
}


public lod_CreatePickups()
{
	new i;
	for(i = 0; i < MAX_LOD_PICKUPS; i++)
	{
		LOD_Pickups[i] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[i][0]), 19, LODWeapSpawns[i][0], LODWeapSpawns[i][1], LODWeapSpawns[i][2], 1400, 15, -1, 100);
	}
	return 1;
}

public lod_PlayerJoinEvent(playerid)
{
	event_count++;
	SetPlayerHealth(playerid, 50);
	SetPlayerArmour(playerid, 0);
	SetPlayerVirtualWorld(playerid, 1400);
	SetPlayerInterior(playerid, 15);
	ResetPlayerWeapons(playerid);
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ Labyrinth of Doom! ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
	SetPlayerPos(playerid, LODSpawns[increment][0], LODSpawns[increment][1], LODSpawns[increment][2]);
	SetPlayerFacingAngle(playerid, LODSpawns[increment][3]+180.0);

	SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
	SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
	SetPlayerSkin(playerid, 33);
	GivePlayerWeapon(playerid, 1, 1);
	SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: Your goal is to be the last survivor in the maze. Kill at any cost and avoid the maze killer!");
	SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: A minigun is spawned in the middle of the maze. Reach it first and receive a minigun and become the invisible maze killer!");
	SetPlayerColor(playerid, COLOR_BLUE);
	increment++;
	
	return 1;
}

public lod_PlayerLeftEvent(playerid)
{
	new string[128];
	event_count--;
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
		format(string, sizeof(string), "[EVENT]: %s(%d) won the Labyrinth of Doom event!", PlayerName(winner), winner);
		SendClientMessageToAll(COLOR_GREEN, string);
		EndEvent();
		return 1;
	}
    if(playerid == Maze_Killer)
	{
		format(string, sizeof(string), "[EVENT]: %s(%d) the maze killer was killed! His minigun is up for grabs! There are %d players left.", PlayerName(Maze_Killer), Maze_Killer, event_count);
		SendClientMessageToAll(COLOR_GREEN, string);
		DestroyDynamicPickup(LOD_Pickups[0]);
		LOD_Pickups[0] = CreateDynamicPickup(Convert_Wpn_To_PickupID(38), 19, Maze_X, Maze_Y, Maze_Z, 1400, 15, -1, 100);
		Maze_Killer = -1;
		KillTimer(Timer_MazeKiller);
	}
	else
	{
		format(string, sizeof(string), "[EVENT]: %s(%d) died, there are %d players alive.", PlayerName(playerid), playerid, event_count);
		SendClientMessageToAll(COLOR_GREEN, string);
	}
	return 1;
}

public lod_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Labyrinth of Doom is now in progress and can not be joined. The minigun has spawned in the middle of the maze!");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
	return 1;
}

hook OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	new string[128];
	if(rotate_pickups_lod <= 0)
	{
		rotate_pickups_lod = LOD_EVENT_SLOTS-1;
	}
	if(pickupid >= LOD_Pickups[0] && pickupid <= LOD_Pickups[23])
	{
		if(pickupid ==  LOD_Pickups[0])
		{
			if(GetPVarInt(playerid, "PlayerStatus") == 1)
			{
				new Float:armour;
				GivePlayerWeapon(playerid, 38, 250);
				Maze_Killer = playerid;
				DestroyDynamicPickup(LOD_Pickups[0]);
				SetPlayerColor(playerid, 0xFFFFFF00);
				GetPlayerArmour(playerid, armour);
				if(armour+50 >= 100)
				{
					SetPlayerArmour(playerid, 99);
				}
				else
				{
					SetPlayerArmour(playerid, armour+50);
				}
				SetPlayerSkin(playerid, 149);
				format(string, sizeof(string), "[EVENT]: %s(%d) has found the minigun and is now the maze killer! He is invisible for 30 seconds, avoid at all cost!", PlayerName(playerid), playerid);
				SendClientMessageToAll(COLOR_GREEN, string);
				Timer_MazeKiller = SetTimer("LOD_MazeKillerTimer", 30000, false);	// 30 seconds
			}
		}
		else if(pickupid == LOD_Pickups[1])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[1][0], LOD_Pickups_Wpns[1][1]);
			DestroyDynamicPickup(LOD_Pickups[1]);
			LOD_Pickups[1] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[1][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[2])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[2][0], LOD_Pickups_Wpns[2][1]);
			DestroyDynamicPickup(LOD_Pickups[2]);
			LOD_Pickups[2] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[2][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[3])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[3][0], LOD_Pickups_Wpns[3][1]);
			DestroyDynamicPickup(LOD_Pickups[3]);
			LOD_Pickups[3] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[3][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[4])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[4][0], LOD_Pickups_Wpns[4][1]);
			DestroyDynamicPickup(LOD_Pickups[4]);
			LOD_Pickups[4] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[4][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[5])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[5][0], LOD_Pickups_Wpns[5][1]);
			DestroyDynamicPickup(LOD_Pickups[5]);
			LOD_Pickups[5] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[5][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[6])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[6][0], LOD_Pickups_Wpns[6][1]);
			DestroyDynamicPickup(LOD_Pickups[6]);
			LOD_Pickups[6] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[6][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[7])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[7][0], LOD_Pickups_Wpns[7][1]);
			DestroyDynamicPickup(LOD_Pickups[7]);
			LOD_Pickups[7] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[7][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[8])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[8][0], LOD_Pickups_Wpns[8][1]);
			DestroyDynamicPickup(LOD_Pickups[8]);
			LOD_Pickups[8] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[8][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[9])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[9][0], LOD_Pickups_Wpns[9][1]);
			DestroyDynamicPickup(LOD_Pickups[9]);
			LOD_Pickups[9] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[9][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[10])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[10][0], LOD_Pickups_Wpns[10][1]);
			DestroyDynamicPickup(LOD_Pickups[10]);
			LOD_Pickups[10] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[10][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[11])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[11][0], LOD_Pickups_Wpns[11][1]);
			DestroyDynamicPickup(LOD_Pickups[11]);
			LOD_Pickups[11] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[11][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[12])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[12][0], LOD_Pickups_Wpns[12][1]);
			DestroyDynamicPickup(LOD_Pickups[12]);
			LOD_Pickups[12] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[12][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[13])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[13][0], LOD_Pickups_Wpns[13][1]);
			DestroyDynamicPickup(LOD_Pickups[13]);
			LOD_Pickups[13] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[13][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[14])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[14][0], LOD_Pickups_Wpns[14][1]);
			DestroyDynamicPickup(LOD_Pickups[14]);
			LOD_Pickups[14] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[14][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[15])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[15][0], LOD_Pickups_Wpns[15][1]);
			DestroyDynamicPickup(LOD_Pickups[15]);
			LOD_Pickups[15] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[15][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[16])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[16][0], LOD_Pickups_Wpns[16][1]);
			DestroyDynamicPickup(LOD_Pickups[16]);
			LOD_Pickups[16] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[16][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[17])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[17][0], LOD_Pickups_Wpns[17][1]);
			DestroyDynamicPickup(LOD_Pickups[17]);
			LOD_Pickups[17] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[17][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[18])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[18][0], LOD_Pickups_Wpns[18][1]);
			DestroyDynamicPickup(LOD_Pickups[18]);
			LOD_Pickups[18] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[18][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[19])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[19][0], LOD_Pickups_Wpns[19][1]);
			DestroyDynamicPickup(LOD_Pickups[19]);
			LOD_Pickups[19] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[19][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[20])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[20][0], LOD_Pickups_Wpns[20][1]);
			DestroyDynamicPickup(LOD_Pickups[20]);
			LOD_Pickups[20] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[20][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[21])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[21][0], LOD_Pickups_Wpns[21][1]);
			DestroyDynamicPickup(LOD_Pickups[21]);
			LOD_Pickups[21] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[21][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[22])
		{
			new Float:health;
			GetPlayerHealth(playerid, health);
			if(health+20 >= 100)
			{
				SetPlayerHealth(playerid, 99);
			}
			else
			{
				SetPlayerHealth(playerid, health+20);
			}
			DestroyDynamicPickup(LOD_Pickups[22]);
			LOD_Pickups[22] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[22][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[23])
		{
			new Float:armour;
			GetPlayerArmour(playerid, armour);
			if(armour+20 >= 100)
			{
				SetPlayerArmour(playerid, 99);
			}
			else
			{
				SetPlayerArmour(playerid, armour+20);
			}
			SetPlayerArmour(playerid, armour+50);
			DestroyDynamicPickup(LOD_Pickups[23]);
			LOD_Pickups[23] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[23][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
	}
	
	return 1;
}