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
*                        (c) Copyright                                           *
*  Owners: Simon Fagerli (pEar) - Lee Percox (Shaney) - Warren Bickley (WazzaJB) *
*         Developers: Marcel, RakGuy, FKu, Chilco, dr_vista, Fletcher            *
*                                                                                *
* Filename: pEar_Stadium_Bloodbowl.pwn                                           *
* Author:  pEar                                                                  *
*********************************************************************************/

#define STADIUM_BLOODBOWL_EVENT_SLOTS 40

new Partner[MAX_PLAYERS];

new const event_IRC_Array[MAX_EVENTS][ events ] = {
 {0, "Mad Doggs Mansion"},
 {1, "Bigsmoke"},
 {2, "Minigun Wars"},
 {3, "Brawl"},
 {4, "Hydra Wars"},
 {5, "Gun Game"},
 {6, "Jefferson TDM"},
 {7, "Area 51 TDM"},
 {8, "Army vs. Terrorists"},
 {9, "Navy Seals Vs. Terrorists"},
 {10, "Compound Attack"},
 {11, "Oil Rig Terrorists"},
 {12, "Team Drug Run"},
 {13, "Monster Sumo"},
 {14, "Banger Sumo"},
 {15, "SandKing Sumo"},
 {16, "SandKing Sumo Reloaded"},
 {17, "Destruction Derby"},
 {18, "Pursuit"},
 {19, "Plane-ram"},
 {20, "Construction-TDM"},
 {21, "High-speed pursuit"},
 {22, "Stadium Bloodbowl"}
};

enum
{
	MADDOGG,            // 0
	BIGSMOKE,           // 1
	MINIGUN,            // 2
	BRAWL,              // 3
	HYDRA,              // 4
	GUNGAME,            // 5
	JEFFTDM,            // 6
	AREA51,             // 7
	ARMYVSTERRORISTS,   // 8
	NAVYVSTERRORISTS,   // 9
	COMPOUND,           // 10
	OILRIG,             // 11
	DRUGRUN,            // 12
	MONSTERSUMO,        // 13
	BANGERSUMO,         // 14
	SANDKSUMO,          // 15
	SANDKSUMORELOADED,  // 16
	DESTRUCTIONDERBY,   // 17
	PURSUIT,            // 18
	PLANE,              // 19
	CONSTRUCTION,       // 20
	HIGHSPEEDPURSUIT,   // 21
	STADIUMBLOODBOWL	// 22
};

new const eventSlots[MAX_EVENTS] = {-1, -1, 16, -1, 11, -1, 28, 42, 18, 31, 32, 32, 58, 15, 15, 15, 15, 15, 26, 33, 30, 26, 45}; /* -1 = unlimited slots */

new Float:Stadium_BloodbowlVehicles[20][4] = {	// 1 spawn gives two people a place, meaning vehicles spawns*2. 20 vehicle spawns = 40 event slots.
	{-1487.9503, 948.6742, 1036.4143, 331.1508},
	{-1493.6749, 953.3163, 1036.5151, 311.7878},
	{-1498.5704, 957.3622, 1036.7136, 307.7336},
	{-1502.5250, 961.9633, 1036.7982, 309.4149},
	{-1506.4374, 966.2076, 1036.8748, 297.4643},
	{-1503.0835, 1029.3323, 1037.7778, 229.5491},
	{-1503.0842, 1029.3307, 1037.9153, 229.5470},
	{-1499.5011, 1034.0929, 1037.8533, 229.5013},
	{-1493.2800, 1040.1741, 1037.9418, 219.1696},
	{-1487.3741, 1044.8291, 1038.1464, 219.1251},
	{-1324.2618, 943.7834, 1036.0544, 38.7016},
	{-1319.2021, 945.4254, 1036.2015, 30.2235},
	{-1314.6283, 948.0765, 1036.2227, 29.4437},
	{-1307.9503, 951.7319, 1036.1514, 44.7470},
	{-1303.5898, 954.8865, 1036.3271, 46.2569},
	{-1311.7109, 1040.6564, 1037.7709, 131.0656},
	{-1307.6323, 1038.4761, 1037.7312, 141.6597},
	{-1303.3785, 1035.3929, 1037.5433, 144.4167},
	{-1298.2478, 1032.0842, 1037.4753, 139.6332},
	{-1293.7252, 1028.0569, 1037.3937, 138.3239}
};

new Float:Stadium_BloodbowlCheckpoints[100][4] = {
	{-1408.8765, 941.7247, 1033.6873, 91.2974}, 
	{-1429.7853, 942.2817, 1033.6831, 86.5974}, 
	{-1458.8950, 949.3118, 1033.1333, 72.8106}, 
	{-1478.6597, 958.5971, 1033.5320, 59.0238}, 
	{-1494.3760, 972.8959, 1033.6569, 38.9702}, 
	{-1502.7825, 1000.2673, 1034.2667, 1.0567}, 
	{-1487.6326, 1026.4801, 1034.9248, 308.4160}, 
	{-1462.4230, 1041.1141, 1035.0728, 293.6890}, 
	{-1443.0945, 1046.7657, 1035.2094, 283.3488}, 
	{-1415.7434, 1049.5743, 1035.6565, 271.1285}, 
	{-1386.3716, 1049.3999, 1035.5809, 269.5618}, 
	{-1363.9260, 1048.0658, 1034.9614, 260.7884}, 
	{-1337.3864, 1042.0410, 1034.7651, 251.3882}, 
	{-1311.3639, 1027.5645, 1034.2889, 233.8412}, 
	{-1295.7496, 1002.0981, 1033.2521, 194.3607}, 
	{-1300.9503, 975.0450, 1033.3839, 146.1069}, 
	{-1322.6097, 956.0301, 1033.1825, 121.6667}, 
	{-1343.6356, 946.5152, 1033.6505, 106.6266}, 
	{-1367.2815, 942.4914, 1033.3879, 94.4064}, 
	{-1384.3535, 941.4581, 1033.9681, 92.8398}, 
	{-1397.5378, 940.8755, 1034.4122, 94.0931}, 
	{-1410.2062, 936.1327, 1036.4640, 90.6230}, 
	{-1432.6008, 937.5068, 1036.5278, 84.0430}, 
	{-1451.7988, 940.9031, 1036.6310, 78.7163}, 
	{-1471.5601, 946.7853, 1036.7589, 69.9428}, 
	{-1478.9911, 949.4982, 1036.8081, 69.9428}, 
	{-1516.6705, 982.5448, 1037.4446, 351.9221}, 
	{-1514.1805, 1002.1899, 1037.7606, 352.8621}, 
	{-1468.5824, 1050.6508, 1038.4906, 287.0615}, 
	{-1448.1549, 1054.9696, 1038.5236, 281.7348}, 
	{-1428.0112, 1057.8013, 1038.5398, 273.9013}, 
	{-1400.8627, 1058.4507, 1038.5046, 269.8279}, 
	{-1373.3806, 1058.3702, 1038.4611, 269.8279}, 
	{-1345.7632, 1054.1390, 1038.3351, 256.6677}, 
	{-1325.8263, 1048.9292, 1038.2109, 247.5809}, 
	{-1284.7744, 1012.6663, 1037.5421, 213.4273}, 
	{-1285.2552, 984.3572, 1037.0660, 168.8132}, 
	{-1343.0930, 938.4152, 1036.4023, 103.7596}, 
	{-1374.5500, 936.6756, 1036.4216, 89.6595}, 
	{-1395.9659, 936.2520, 1036.4424, 90.5995}, 
	{-1408.6588, 955.3882, 1026.7114, 92.4795}, 
	{-1431.3568, 955.4802, 1026.9581, 80.5727}, 
	{-1454.1471, 961.5899, 1027.1029, 67.7259}, 
	{-1475.9585, 978.2302, 1027.2178, 38.8990}, 
	{-1480.0403, 1007.1528, 1027.7504, 338.4251}, 
	{-1465.0327, 1024.8411, 1028.3588, 313.0448}, 
	{-1448.3688, 1033.3810, 1028.6938, 285.1579}, 
	{-1418.1332, 1036.4545, 1028.2590, 271.6843}, 
	{-1386.6074, 1037.4259, 1028.5681, 268.8642}, 
	{-1360.7920, 1034.7844, 1028.1128, 261.3441}, 
	{-1338.9221, 1028.2994, 1028.0939, 246.6173}, 
	{-1320.1821, 1014.2968, 1027.8314, 205.5702}, 
	{-1313.7289, 991.0211, 1027.3745, 161.0764}, 
	{-1330.6343, 968.1699, 1026.9989, 131.3095}, 
	{-1357.5540, 956.8351, 1026.8766, 103.1093}, 
	{-1381.4694, 953.9590, 1027.1072, 93.3959}, 
	{-1394.8656, 953.2396, 1027.3135, 91.5158}, 
	{-1395.8054, 965.5766, 1024.7705, 90.8892}, 
	{-1416.4878, 966.0800, 1024.7336, 86.5024}, 
	{-1435.9182, 968.8821, 1024.7728, 77.1024}, 
	{-1456.0437, 979.1264, 1024.9629, 35.1153}, 
	{-1463.1448, 1000.0408, 1025.2688, 324.6147}, 
	{-1443.9705, 1019.2353, 1025.5712, 287.0142}, 
	{-1416.0232, 1024.4496, 1025.6248, 273.2274}, 
	{-1388.5046, 1024.9912, 1025.6779, 268.5273}, 
	{-1369.2072, 1024.0426, 1025.5642, 266.0205}, 
	{-1347.5155, 1018.4344, 1025.5544, 242.2069}, 
	{-1331.3927, 998.6005, 1025.1569, 183.6129}, 
	{-1339.5748, 979.3945, 1024.8232, 147.8926}, 
	{-1358.5352, 968.6292, 1024.7190, 116.5590}, 
	{-1380.6511, 965.9304, 1024.7161, 93.0588}, 
	{-1390.8060, 965.3878, 1024.7804, 93.0588}, 
	{-1407.4202, 976.9630, 1023.8633, 93.3721}, 
	{-1424.0138, 976.8098, 1023.9089, 86.4787}, 
	{-1439.1005, 981.1017, 1023.9756, 62.3518}, 
	{-1450.1165, 990.7211, 1024.2166, 23.8115}, 
	{-1449.9717, 1002.4943, 1024.4446, 307.0440}, 
	{-1428.2614, 1012.3792, 1024.4441, 278.8436}, 
	{-1405.6608, 1014.9860, 1024.5479, 272.5769}, 
	{-1384.0947, 1015.0499, 1024.5383, 269.7568}, 
	{-1361.4015, 1012.7278, 1024.4218, 259.4166}, 
	{-1349.7394, 1001.9887, 1024.1296, 188.6025}, 
	{-1357.1749, 984.0550, 1023.8448, 127.5019}, 
	{-1377.1642, 978.8651, 1023.7993, 95.2283}, 
	{-1394.3997, 977.8340, 1023.8074, 91.7816}, 
	{-1406.8201, 987.7028, 1023.9895, 90.8416}, 
	{-1421.0182, 987.3072, 1024.0037, 90.8416}, 
	{-1433.7295, 987.7783, 1024.0356, 87.3949}, 
	{-1442.5996, 992.6671, 1024.1406, 18.4609}, 
	{-1437.9655, 1003.5031, 1024.3091, 307.3336}, 
	{-1422.7236, 1006.6021, 1024.3320, 280.3867}, 
	{-1402.9635, 1008.6957, 1024.3292, 277.8799}, 
	{-1388.7167, 1010.0701, 1024.3308, 268.1664}, 
	{-1369.6593, 1009.4593, 1024.2913, 268.1664}, 
	{-1356.4971, 1005.9938, 1024.2065, 210.5125}, 
	{-1371.5103, 1000.0126, 1024.1321, 103.6648}, 
	{-1390.9431, 994.9473, 1024.0848, 96.7714}, 
	{-1408.6385, 993.8338, 1024.0922, 91.1314}, 
	{-1421.1089, 993.5883, 1024.1138, 91.1314}, 
	{-1430.3608, 993.4067, 1024.1265, 91.1314}
};

	/* Stadium Bloodbowl */
	forward stadium_bloodbowl_EventStart(playerid);
	forward stadium_bloodbowl_PlayerJoinEvent(playerid);
	
event_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_EVENTS)
	{
		if(!response)
		{
			return 1;
		}
		
		DialogIDOption[playerid] = listitem;
		
		switch(listitem)
		{
			case STADIUMBLOODBOWL:
			{
				if(Event_InProgress != -1)
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first.");
				}
				EventStart(STADIUMBLOODBOWL, playerid);
			}
		}
	}
	if(dialogid == DIALOG_BBWPN)
	{
		if(!response)
		{
			return 1;
		}
		else
		{
			switch(listitems)
			{
				case 0:
				{
					SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: You have been given an AK-47 with 75 ammo. Good luck!");
					GivePlayerWeapon(playerid, 30, 75);
					return 1;
				}
				case 1:
				{
					SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: You have been given an M4 with 50 ammo. Good luck!");
					GivePlayerWeapon(playerid, 31, 50);
					return 1;
				}
				case 2:
				{
					SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: You have been given a shotgun with 50 ammo. Good luck!");
					GivePlayerWeapon(playerid, 25, 50);
					return 1;
				}
				case 3:
				{
					SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: You have been given a rifle with 50 ammo. Good luck!");
					GivePlayerWeapon(playerid, 33, 50);
					return 1;
				}
				case 4:
				{
					SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: You have been given a colt with 200 ammo. Good luck!");
					GivePlayerWeapon(playerid, 22, 200);
					return 1;
				}
				case 5:
				{
					SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: You have been given a silencer pistol with 200 ammo. Good luck!");
					GivePlayerWeapon(playerid, 23, 200);
					return 1;
				}
				case 6: 
				{
					SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: You have been given a tec-9 with 150 ammo. Good luck!");
					GivePlayerWeapon(playerid, 32, 150);
					return 1;
				}
				case 7:
				{
					SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: You have been given an UZI with 150 ammo. Good luck!");
					GivePlayerWeapon(playerid, 28, 150);
					return 1;
				}
			}
		}
		return 1;	
	}
}

forward event_OnPlayerExitVehicle(playerid, vehicleid);
public event_OnPlayerExitVehicle(playerid, vehicleid)
{
    if(vehicleid == Event_PlayerVeh[playerid])
	{
		if(Event_ID == MONSTERSUMO || Event_ID == BANGERSUMO || Event_ID == SANDKSUMO || Event_ID == SANDKSUMORELOADED || Event_ID == DESTRUCTIONDERBY || Event_ID == HYDRA || Event_ID == STADIUMBLOODBOWL)
		{
			if(GetPVarInt(playerid, "InEvent") == 1)
			{
				new string[128];
				SetPVarInt(playerid, "FellOffEvent", 1);
				PlayerLeftEvent(playerid);
				SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: You have been removed from the event for leaving your vehicle.");
				foreach(Player, i)
				{
					if(GetPlayerVehicleID(i) == vehicleid && GetPlayerVehicleSeat(i) == 1)
					{
						SetPVarInt(i, "FellOffEvent", 1);
						PlayerLeftEvent(i);
						format(string, sizeof(string), "[NOTICE]: You have been removed from the event since %s(%d) left your vehicle as the driver.", PlayerName(playerid), playerid);
						return 1;
					}
				}
			}
		}
	}	
	return 1;
}

forward event_OnPlayerEnterCheckpoint(playerid);
public event_OnPlayerEnterCheckpoint(playerid)
{
	// ......... lots of other shits yo
	if(Event_ID == STADIUMBLOODBOWL && GetPVarInt(playerid, "PlayerStatus") == 1)
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			SetPVarInt(playerid, "FellOffEvent", 1);
			PlayerLeftEvent(playerid);
			SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: You have been removed from the event for leaving your vehicle.");
			return 1;
		}
		else
		{
			
		}
	}
	return 1;
}

public stadium_bloodbowl_EventStart()
{
	new
	    string[128];

	Event_ID = STADIUMBLOODBOWL;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Stadium Bloodbowl event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "[EVENT]: 30 seconds before it starts, type /join!", COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Motel_Team = 0;
	foreach(Player, i)
	{
		Partner[playerid] = -1;
	}
		
	return 1;
}

forward WeaponsListStadiumBB();
public WeaponsListStadiumBB()
{
	new List[528];
	strcat(list, "AK-47 - Ammo: 75"); 
	strcat(list, "M4 - Ammo: 50");
	strcat(list, "Shotgun - Ammo: 75");
	strcat(list, "Rifle - Ammo: 75");
	strcat(list, "Shotgun - Ammo: 50");
	strcat(list, "Colt - Ammo: 200");
	strcat(list, "Tec-9 - Ammo: 250");
	strcat(list, "Uzi - Ammo: 250");
	return List;
}

public stadium_bloodbowl_PlayerJoinEvent(playerid)
{
	new temp;
	if(Motel_Team == 0)
	{
		Motel_Team = 1;
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 505);

		SetPlayerPos(playerid, Stadium_BloodbowlVehicles[increment][0], Stadium_BloodbowlVehicles[increment][1], Stadium_BloodbowlVehicles[increment][2]+5);
		SetPlayerFacingAngle(playerid, Stadium_BloodbowlVehicles[increment][3]);
		Event_PlayerVeh[playerid] = CreateVehicle(504, Stadium_BloodbowlVehicles[increment][0], Stadium_BloodbowlVehicles[increment][1], Stadium_BloodbowlVehicles[increment][2], Stadium_BloodbowlVehicles[increment][3], -1, -1, 15);

		SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
		SetPlayerArmour(playerid, 0);
		SetPlayerHealth(playerid, 99);
		ResetPlayerWeapons(playerid);
		GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
		TogglePlayerControllable(playerid, 0);
		SetCameraBehindPlayer(playerid);
		increment++;
		new string[32];
		if(FoCo_Player[playerid][level] >= MIN_LVL)
		{
			if(GetPlayerMoney(playerid) > MIN_CASH)
			{
				GivePlayerMoney(playerid, -TDM_COST);
				format(string, sizeof(string), "~r~-%d",TDM_COST);
				TextDrawSetString(MoneyDeathTD[playerid], string);
				TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
				defer cashTimer(playerid);
			}
		}
		temp = playerid;
		return 1;
	}
	else
	{
		Motel_Team = 0;
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 505);

		SetPlayerPos(playerid, Stadium_BloodbowlVehicles[increment][0], Stadium_BloodbowlVehicles[increment][1]+1, Stadium_BloodbowlVehicles[increment][2]+5);
		SetPlayerFacingAngle(playerid, Stadium_BloodbowlVehicles[increment][3]);
		Event_PlayerVeh[playerid] = CreateVehicle(504, Stadium_BloodbowlVehicles[increment][0], Stadium_BloodbowlVehicles[increment][1], Stadium_BloodbowlVehicles[increment][2], Stadium_BloodbowlVehicles[increment][3], -1, -1, 15);

		SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
		SetPlayerArmour(playerid, 0);
		SetPlayerHealth(playerid, 99);
		ResetPlayerWeapons(playerid);
		GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
		TogglePlayerControllable(playerid, 0);
		SetCameraBehindPlayer(playerid);
		increment++;
		new string[32];
		if(FoCo_Player[playerid][level] >= MIN_LVL)
		{
			if(GetPlayerMoney(playerid) > MIN_CASH)
			{
				GivePlayerMoney(playerid, -TDM_COST);
				format(string, sizeof(string), "~r~-%d",TDM_COST);
				TextDrawSetString(MoneyDeathTD[playerid], string);
				TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
				defer cashTimer(playerid);
			}
		}
		Partner[playerid] = temp;
		Partner[temp] = playerid;
		ShowPlayerDialog(playerid, DIALOG_BBWPN, DIALOG_STYLE_LIST, "Choose a weapon to use during the event", WeaponsListStadiumBB(), "Select", "");
		return 1;
	}
	
}

public sumo_PlayerLeftEvent(playerid)
{
  	SetPVarInt(playerid, "LeftEventJust", 1);
	RemovePlayerFromVehicle(playerid);
	event_SpawnPlayer(playerid);
	if(Event_ID == STADIUMBLOODBOWL)
	{
		if(EventPlayersCount() == 1)
		{
			new msg[128];
			foreach(Player, i)
			{
				if(GetPVarInt(i, "InEvent") == 1)
				{
					winner = i;
					break;
				}
			}
			if(Partner[winner] == -1)
			{
				format(msg, sizeof(msg), "[INFO]: %s(%d) has won the Stadium Bloodbowl event!", PlayerName(winner), winner);
				SendClientMessageToAll(COLOR_NOTICE, msg);
				GiveAchievement(winner, 81);
				SendClientMessage(winner, COLOR_NOTICE, "You have won the Stadium Bloodbowl event! You have earnt 10 score!");
				FoCo_Player[winner][score] += 10;
				lastEventWon = winner;
				Event_Bet_End(winner);
				EndEvent();
				return 1;
			}
			else
			{
				format(msg, sizeof(msg), "[INFO]: %s(%d) and %s(%d) has won the Stadium Bloodbowl event!", PlayerName(winner), winner, PlayerName(Partner[winner]), Partner[winner]);
				SendClientMessageToAll(COLOR_NOTICE, msg);
				GiveAchievement(Partner[winner], 81);
				GiveAchievement(winner, 81);
				SendClientMessage(winner, COLOR_NOTICE, "You have the Stadium Bloodbowl Sumo event! You have earnt 10 score!");
				SendClientMessage(Partner[winner], COLOR_NOTICE, "You have won the Stadium Bloodbowl event! You have earnt 10 score!");
				FoCo_Player[winner][score] += 10;
				FoCo_Player[Partner[winner]][score] += 10;
				lastEventWon = winner;
				EndEvent();
				return 1;
			}
		}
		if(EventPlayersCount() == 2)
		{
			winner = -1;
			foreach(Player, i)
			{
				if(GetPVarInt(i, "InEvent") == 1)
				{
					if(winner = -1)
					{
						winner = i;
					}
					break;
				}
			}
			if(GetPlayerVehicleID(winner) == GetPlayerVehicleID(Partner[winner]))
			{
				format(msg, sizeof(msg), "[INFO]: %s(%d) and %s(%d) has won the Stadium Bloodbowl event!", PlayerName(winner), winner, PlayerName(Partner[winner]), Partner[winner]);
				SendClientMessageToAll(COLOR_NOTICE, msg);
				GiveAchievement(Partner[winner], 81);
				GiveAchievement(winner, 81);
				SendClientMessage(winner, COLOR_NOTICE, "You have won Stadium Bloodbowl event! You have earnt 10 score!");
				SendClientMessage(Partner[winner], COLOR_NOTICE, "You have won Stadium Bloodbowl event! You have earnt 10 score!");
				FoCo_Player[winner][score] += 10;
				FoCo_Player[Partner[winner]][score] += 10;
				lastEventWon = winner;
				EndEvent();
				return 1;
			}	
		}
	}
	else if(EventPlayersCount() == 1)
	{
		new msg[128];
		foreach(Player, i)
	  	{
			if(GetPVarInt(i, "InEvent") == 1)
			{
				winner = i;
				break;
			}
		}
		format(msg, sizeof(msg), "				%s has won the Sumo event!", PlayerName(winner));
		SendClientMessageToAll(COLOR_NOTICE, msg);
		GiveAchievement(winner, 81);
		SendClientMessage(winner, COLOR_NOTICE, "You have won Sumo event! You have earnt 10 score!");
		FoCo_Player[winner][score] += 10;
		lastEventWon = winner;
		Event_Bet_End(winner);
		EndEvent();
		return 1;
	}
	else
	{
		return 1;
	}
}

public sumo_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Stadium Bloodbowl is now in progress and can not be joined.");
	SumoFallCheckTimer = repeat SumoFallCheck();
	if(Event_ID == STADIUMBLOODBOWL)
	{
		foreach(Player, i)
		{
			if(GetPVarInt(i, "InEvent") == 1 && GetPlayerVehicleSeat(playerid) == 0)
			{
				SetVehicleParamsEx(Event_PlayerVeh[i], true, false, false, true, false, false, false);
				TogglePlayerControllable(i, 1);
				GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
				increment = 0;
			}
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
	else
	{
		foreach(Player, i)
		{
			if(GetPVarInt(i, "InEvent") == 1)
			{
				SetVehicleParamsEx(Event_PlayerVeh[i], true, false, false, true, false, false, false);
				TogglePlayerControllable(i, 1);
				GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
				increment = 0;
			}
		}
	}
	
	return 1;
}

if(Event_ID == STADIUMBLOODBANG)
			{
				new
					Float:vehx,
					Float:vehy,
					Float:vehz,
					Float:vang,
					car,
					turn;
					
				car = 0;
				turn = 0;
				foreach(Player, i)
				{
					if(GetPVarInt(i, "InEvent") == 1)
					{
						if(turn == 0)
						{
							GetPlayerPos(i, vehx, vehy, vehz);
							GetPlayerFacingAngle(i, vang);
							SetVehiclePos(Event_PlayerVeh[car], vehx, vehy, vehz);
							SetVehicleZAngle(car, vang);
							PutPlayerInVehicle(i, Event_PlayerVeh[car], 0);
							SetVehicleParamsEx(Event_PlayerVeh[car], false, false, false, true, false, false, false);
							TogglePlayerControllable(i, 0);
							turn = 1;
						}
						else
						{
							GetPlayerPos(i, vehx, vehy, vehz);
							GetPlayerFacingAngle(i, vang);
							SetVehiclePos(Event_PlayerVeh[car], vehx, vehy, vehz);
							SetVehicleZAngle(car, vang);
							PutPlayerInVehicle(i, Event_PlayerVeh[car], 1);
							SetVehicleParamsEx(Event_PlayerVeh[car], false, false, false, true, false, false, false);
							TogglePlayerControllable(i, 0);
							turn = 0;
							car++;
						}
						
					}
				}
			}

