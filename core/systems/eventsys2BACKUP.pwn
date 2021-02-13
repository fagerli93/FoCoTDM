/*
NOTES:
- TEST GUN GAME TD (%d / 16)

*/
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
* Filename:  eventsystem.pwn                                                     *
* Author:    Marcel                                                              *
*********************************************************************************/

//===============================[ADDON-FILES]==================================
//#include                        "../ftdm/Dev/events/subfiles/chilco_ctf.pwn"


//===============================[VARIABLES]====================================
/*
NOTE:
PlayerStatus - 0 normal, 1 in event, 2 Duel, 3 AFK
*/
new DrugEventVehicles[128];						// This is the variable where the vehicles are being stored for the drug event on creation.
new EventDrugDelay[MAX_PLAYERS] = -1;			// This is the timer which gets set to a value, which will decrease every second by 1 in OneSecondTimer(). When hits 0 is set to -1 and the crims win.
new E_Pursuit_Criminal;							// This stores the carID of the criminals vehicle.
new ManHuntID = -1;								// This stores the userID of who is currently the ManHunt target.
new ManHuntFail;								// This stores the amount of times manhunt has failed to set a target, due to it selecting online admins or false players.
new ManHuntTwenty;								// This is used for manhunt in the TenMinuteTimer(). It will be ++'d then when it hits 2, it will be reset to 0 and manhunt will begin.
new ManHuntSeconds; 							// This stores the UNIX timestamp of the player, when he is assigned manhunt.
new Motel_Team = 0;								// When set to 0 assigns a player to Team 1, when set to 1, assigns a player to Team 2.
new Team1_Motel = 0;							// This is used for storing the amount of players on team 1, in different events. (Not just MOTEL event!!)
new increment2 = 0;								// This is an incrimental value used when people type /join for deciding which team the user will go on.
new Team2_Motel = 0; 							// This is used for storing the amount of players on team 2, in different events. (Not just MOTEL event!!)
new MadDogsWeapon;								// This will store the weapon used in the mad dogs event.
new FoCo_Event = -1;							// This will store the current event that is running.
new FoCo_Event_Rejoin;							// This will store whether you can or cannot rejoin Mad Dogs.
new FoCo_Event_Died[MAX_PLAYERS];				// This stores if you died in an  event or not recently, used for the re joining if death is disabled.
new Event_Delay;								// this stores the timer for the delay after /event start has been selected.
new Event_InProgress;							// This stores 1 or 0 depending on whether the event is running or not.
new Event_PlayerVeh[MAX_PLAYERS] = -1;			// This stores the vehicle ID of the players car during SUMO events.
new Float:Brawl_X;								// Stores the X co ord of the brawl location.
new Float:Brawl_Y;								// Stores the Y co ord of the brawl location.
new Float:Brawl_Z;								// Stores the Z co ord of the brawl location.
new Float:Brawl_Angle;							// Stores the Angle co ord of the brawl location.
new Brawl_World;								// Stores the world ID of the brawl
new Brawl_Int;									// Stores the interior of a brawl.
new Sumo_Type;									// Chooses which SUMO you have began.
new PlayerPursuitTimer[MAX_PLAYERS];			// Stores the timer for the puruist event;
new FoCo_Criminal = -1;							// Stores the criminal id for the pursuit
new hydraTime;									// stores the settimer for hydra time.
new GunGameKills[MAX_PLAYERS];
new lastKillReason[MAX_PLAYERS];
new spawnSeconds[MAX_PLAYERS] = -1;
new lastGunGameWeapon[MAX_PLAYERS] = 38;

new Float:hydraSpawnsType1[][] = {
	{1939.58178711,1365.82348633,16.76304626,272.00000000},
	{1939.77551270,1323.51635742,16.76304626,271.50000000},
	{1968.00170898,1185.41442871,63.80590057,0.00000000},
	{1955.27209473,1173.72131348,63.80590439,180.00000000},
	{2163.80175781,1502.10534668,32.08264542,320.00000000},
	{2164.01171875,1463.47900391,32.08404922,222.00000000},
	{2106.23974609,1462.88977051,32.08428955,124.00000000},
	{2106.60009766,1502.69543457,32.08437729,52.00000000},
	{1950.36877441,1628.54748535,23.68749237,272.00000000},
	{1953.65820312,1603.13574219,73.17739105,39.99572754},
	{1906.02832031,1628.63964844,73.17739105,270.00000000},
	{1955.29699707,1655.69946289,73.17520905,39.99572754}
};

new Float:armySpawnsType1[][] = {
	{-536.6452,1309.3185,3.7102,143.2186},
	{-535.7869,1307.3175,3.6655,144.8415},
	{-534.9776,1304.9730,3.5959,138.3177},
	{-534.4557,1302.6029,3.6028,133.0472},
	{-880.8651,1621.5620,30.8952,152.0271},
	{-880.4622,1617.4822,33.4015,245.7476},
	{-873.7017,1618.7975,33.4030,60.9587},
	{-883.3175,1615.1110,35.7468,240.8466},
	{-854.6778,1376.1045,1.2741,311.1262},
	{-851.0994,1372.8354,1.2741,315.1996}
};

new Float:armySpawnsType2[][] = {
	{-726.8176,1533.9048,40.1724,353.1638},
	{-729.1471,1534.0126,40.1633,356.0400},
	{-731.5231,1535.9725,40.2617,268.3620},
	{-729.3406,1538.0480,40.3969,2.6762},
	{-732.8348,1538.6995,40.4118,263.7181},
	{-730.0102,1539.9668,40.5042,164.1335},
	{-734.8888,1544.8472,39.0736,264.7473},
	{-734.6887,1547.8004,38.9713,266.9969},
	{-734.5697,1545.9861,41.5462,266.4031},
	{-734.1703,1555.2683,39.8209,272.7589}
};

new Float:drugSpawnsType1[][] = {
	{386.3043,2548.5906,16.5391,174.1982},
	{386.2205,2546.2419,16.5391,177.9582},
	{386.1368,2543.9036,16.5391,177.9582},
	{386.0403,2541.1985,16.5391,177.9582},
	{385.9525,2538.7400,16.5391,177.9582},
	{385.8694,2536.4104,16.5391,177.9582},
	{385.7797,2533.8972,16.5391,177.9582},
	{385.6798,2531.1011,16.5491,177.9582},
	{383.5614,2530.6782,16.5759,177.9582},
	{383.5607,2533.7908,16.5391,177.9582},
	{383.8788,2536.5457,16.5391,177.9582},
	{383.9685,2539.5559,16.5391,177.9582},
	{383.9574,2542.3435,16.5391,177.9582},
	{383.9225,2544.8630,16.5391,177.9582},
	{383.7946,2547.6460,16.5391,177.9582},
	{381.6566,2547.5417,16.5391,177.9582},
	{381.5372,2544.2039,16.5391,177.9582},
	{381.4406,2541.4956,16.5391,177.9582},
	{381.3459,2538.8496,16.5391,177.9582},
	{381.2657,2536.6025,16.5391,177.9582},
	{381.1742,2534.0408,16.5482,177.9582},
	{381.0813,2531.4390,16.5880,177.9582},
	{379.1826,2531.0791,16.5973,177.9582},
	{379.3771,2533.8757,16.5763,177.9582},
	{379.3782,2536.8149,16.5391,177.9582},
	{378.6484,2539.3767,16.5391,177.9582},
	{379.3178,2540.9807,16.5391,177.9582},
	{379.2309,2544.4143,16.5391,177.9582},
	{379.1219,2547.0881,16.5391,177.9582},
	{379.1389,2548.8113,16.5391,177.9582}
};

new Float:drugSpawnsType2[][] = {
	{1754.4464,-1886.6516,13.5569,271.7347},
	{1756.4623,-1886.5906,13.5564,271.7347},
	{1759.0895,-1886.5109,13.5558,271.7347},
	{1761.2360,-1886.4458,13.5553,271.7347},
	{1763.8300,-1886.3678,13.5546,271.7347},
	{1766.9156,-1886.2738,13.5539,271.7347},
	{1769.2448,-1886.2031,13.5533,271.7347},
	{1769.6971,-1888.5441,13.5601,271.7347},
	{1767.4825,-1888.3868,13.5537,271.7347},
	{1765.1946,-1888.3080,13.5543,271.7347},
	{1762.0735,-1888.4391,13.5551,271.7347},
	{1758.4504,-1887.7513,13.5559,271.7347},
	{1755.7251,-1888.0513,13.5566,271.7347},
	{1752.6431,-1888.3499,13.5574,271.7347},
	{1752.7349,-1890.3278,13.5573,271.7347},
	{1755.6147,-1890.4915,13.5566,271.7347},
	{1758.5013,-1890.4045,13.5559,271.7347},
	{1761.5813,-1890.3114,13.5552,271.7347},
	{1764.6033,-1890.2196,13.5544,271.7347},
	{1767.3138,-1890.1372,13.5603,271.7347},
	{1770.0690,-1890.0535,13.5610,271.7347},
	{1770.9042,-1892.0048,13.5621,271.7347},
	{1768.0706,-1891.3242,13.5611,271.7347},
	{1765.2567,-1891.3208,13.5604,271.7347},
	{1763.0635,-1891.2950,13.5548,271.7347},
	{1760.6603,-1891.1453,13.5554,271.7347},
	{1758.0073,-1891.5461,13.5561,271.7347},
	{1755.7379,-1891.1418,13.5566,271.7347},
	{1753.4752,-1891.4116,13.5572,271.7347},
	{1753.9664,-1893.4374,13.5570,271.7347},
	{1755.9385,-1893.3779,13.5566,271.7347}
};

new Float:navySealsBoat[][] = {
	{-1475.6034,1483.3225,1.5800,228.1285},
	{-1476.3745,1481.5135,1.5800,247.6117},
	{-1477.0802,1479.5178,1.5800,246.7279}, // Boatspawn_3
	{-1444.9019,1501.1514,1.7366,98.2065}, // Boatspawn_4
	{-1447.0107,1503.8995,1.7366,140.2498}, // Boatspawn_5
	{-1456.7163,1481.0428,7.1016,87.0388}, // Boatspawn_6
	{-1456.1177,1485.5995,7.1016,84.1065}, // Boatspawn_7
	{-1456.3177,1497.4828,7.1016,104.9317}, // Boatspawn_8
	{-1463.0660,1497.6965,8.2578,268.1799}, // Boatspawn_9
	{-1463.1732,1494.8063,8.2578,266.3562}, // Boatspawn_10
	{-1463.2122,1491.9156,8.2578,267.6658}, // Boatspawn_11
	{-1463.1044,1489.0294,8.2501,266.1552}, // Boatspawn_12
	{-1463.2954,1486.1844,8.2501,267.7782}, // Boatspawn_13
	{-1463.3452,1480.7723,8.2578,268.8307}, // Boatspawn_14
	{-1463.4204,1483.3024,8.2578,268.4611}, // Boatspawn_15
	{-1452.0812,1477.6252,1.3031,269.8831}, // Boatspawn_16
	{-1446.9612,1477.6980,1.3031,271.1364} // Boatspawn_17
};

new Float:terroristsBoat[][] = {
	{-1434.3325,1481.8838,1.8672,276.5517},
	{-1434.2948,1484.1460,1.8672,268.4611},
	{-1434.2507,1486.6434,1.8672,268.5173},
	{-1434.2252,1489.7177,1.8672,268.5735},
	{-1434.3741,1494.6810,1.8672,267.6897},
	{-1433.8632,1498.0852,1.8672,263.3593},
	{-1413.2545,1497.2257,1.8672,265.6650},
	{-1406.1989,1497.3625,1.8672,271.3051},
	{-1394.2034,1497.2762,1.8735,271.3051},
	{-1390.7335,1493.5171,1.8735,86.3641},
	{-1390.7863,1490.1801,1.8735,88.0595},
	{-1391.1282,1486.5408,1.8672,82.7890},
	{-1391.2137,1483.8008,1.8672,84.7253},
	{-1391.6104,1480.9357,1.8672,85.0948},
	{-1400.5376,1482.9449,1.8672,90.7348},
	{-1408.2819,1483.0409,1.8672,90.7348}
};

new Float:swatoilrigspawns1[][] = {
	{-4989.2671,-1060.4849,62.3481,268.9522}, // SWATspawn1
	{-4989.2139,-1058.8197,62.3481,269.9485}, // SWATspawn2
	{-4989.2607,-1056.6619,62.3481,265.9313}, // SWATspawn3
	{-4989.2803,-1054.1078,62.3481,269.1208}, // SWATspawn4
	{-4989.1377,-1051.6665,62.3481,267.9237}, // SWATspawn5
	{-4989.0537,-1049.2660,62.3481,268.2932}, // SWATspawn6
	{-4989.0015,-1046.9961,62.3481,268.3495}, // SWATspawn7
	{-4988.9907,-1044.8541,62.3481,269.0324}, // SWATspawn8
	{-4989.0864,-1042.5729,62.3481,269.0886}, // SWATspawn9
	{-4984.8403,-1042.4364,62.3481,269.1448}, // SWATspawn10
	{-4984.7739,-1044.3013,62.3481,268.5744}, // SWATspawn11
	{-4984.6982,-1046.3790,62.3481,268.6869}, // SWATspawn12
	{-4984.5972,-1048.5526,62.3481,268.7432}, // SWATspawn13
	{-4984.3262,-1051.0364,62.3481,268.4861}, // SWATspawn14
	{-4984.2212,-1053.4729,62.3481,271.9891}, // SWATspawn15
	{-4984.1616,-1055.9543,62.3481,269.2253}, // SWATspawn16
	{-4984.1226,-1058.9647,62.3481,267.7148} // SWATspawn17
};

new Float:terroristoilrigspawns1[][] = { // terrorissts
	{-4848.1548,-1105.7831,52.1931,89.7017}, // Terrorspawn1
	{-4848.2217,-1104.4656,52.1929,87.5171}, // Terrorspawn2
	{-4848.2749,-1102.7365,52.1956,89.8487}, // Terrorspawn4
	{-4848.3560,-1101.0161,52.2002,89.0294}, // Terrorspawn3
	{-4848.4229,-1099.3506,52.2047,88.4292}, // Terrorspawn5
	{-4848.5532,-1097.4938,52.2097,88.2838}, // Terrorspawn6
	{-4848.5591,-1095.4310,52.2152,88.8179}, // Terrorspawn7
	{-4848.6245,-1093.4357,52.2206,87.7901}, // Terrorspawn8
	{-4854.3359,-1106.2627,52.1862,93.3493}, // Terrorspawn9
	{-4854.3325,-1104.7566,52.1902,89.1057}, // Terrorspawn10
	{-4854.3599,-1103.3361,52.1940,87.8238}, // Terrorspawn11
	{-4854.4463,-1101.3271,52.1994,91.0379}, // Terrorspawn12
	{-4854.5317,-1099.6100,52.2040,89.9278}, // Terrorspawn13
	{-4854.5986,-1097.7080,52.2283,89.0495}, // Terrorspawn14
	{-4854.8691,-1095.8661,52.2276,93.9821}, // Terrorspawn15
	{-4854.9053,-1094.2699,52.2275,89.5147}, // Terrorspawn16
	{-4854.8970,-1092.4136,52.2275,85.0473} // Terrorspawn17
};

#define MAX_EVENTS 16
enum events
{
	eventID,
	eventName[30]
};
#define EVENT_LIST "0:Bigsmoke\n1:Brawl\n2:Sumo\n3:Hydra Wars\n4:Mad Dogs Mansion\n5:Jefferson Motel Team DM\n6:Army vs. Terrorists\n7:Minigun Wars\n8:Team Drug Run\n9:Pursuit\n10:Area 51 DM\n11:Navy Seals Vs. Terrorists\n12:Oil Rig Terrorists\n13:Compound Attack\n14:GunGame"

new event_IRC_Array[MAX_EVENTS][ events ] = {
	{0, "Bigsmoke"},
	{1, "Brawl"},
	{2, "SUMO"},
	{3, "Hydra Wars"},
	{4, "Mad Dogs Mansion"},
	{5, "Jefferson Motel"},
	{6, "Army Vs. Terrorists"},
	{7, "Minigun Wars"},
	{8, "Team Drug Run"},
	{9, "Pursuit"},
	{10, "Area 51 DM"},
	{11, "Navy Seals Vs. Terrorists"},
	{12, "Oil Rig Terrorists"},
	{13, "Compound Attack"},
	{14, "Gun Game"},
	{15, "Custom Event"}
};
//===============================[FUNCTIONS]====================================
forward PlayerLeftEvent(playerid);
public PlayerLeftEvent(playerid)
{
	SetPlayerHealth(playerid, 99);
	if(GetPVarInt(playerid, "PlayerStatus") == 0)
	{
		return 1;
	}
	new winner, msg[71];
	FoCo_Event_Died[playerid]++;
	death[playerid] = 1;
	Iter_Remove(Event_Players, playerid);
	if(FoCo_Event == 5)
	{
		if(GetPlayerSkin(playerid) == 285)
		{
			Team2_Motel++;
		}
		else if(GetPlayerSkin(playerid) == 50)
		{
			Team1_Motel++;
		}

		format(msg, sizeof(msg), "[EVENT SCORE]: S.W.A.T %d - %d Criminals", Team1_Motel, Team2_Motel);
		SendClientMessageToAll(COLOR_NOTICE, msg);
	}
	if(FoCo_Event == 6)
	{
		if(GetPlayerSkin(playerid) == 287)
		{
			Team2_Motel++;
		}
		else if(GetPlayerSkin(playerid) == 73)
		{
			Team1_Motel++;
		}

		format(msg, sizeof(msg), "[EVENT SCORE]: Army %d - %d Terrorists", Team1_Motel, Team2_Motel);
		SendClientMessageToAll(COLOR_NOTICE, msg);
	}
	if(FoCo_Event == 10)
	{
		if(GetPlayerSkin(playerid) == 70)
		{
			Team1_Motel++;
		}
		else if(GetPlayerSkin(playerid) == 287)
		{
			Team2_Motel++;
		}

		format(msg, sizeof(msg), "[EVENT SCORE]: US Special Forces %d - %d Nuclear Scientists", Team1_Motel, Team2_Motel);
		SendClientMessageToAll(COLOR_NOTICE, msg);
	}
	if(FoCo_Event == 11)
	{
		if(GetPlayerSkin(playerid) == 221)
		{
			Team1_Motel++;
		}
		else if(GetPlayerSkin(playerid) == 287)
		{
			Team2_Motel++;
		}

		format(msg, sizeof(msg), "[EVENT SCORE]: Navy Seals %d - %d Terrorists", Team1_Motel, Team2_Motel);
		SendClientMessageToAll(COLOR_NOTICE, msg);
	}
	if(FoCo_Event == 12)
	{
		if(GetPlayerSkin(playerid) == 221)
		{
			Team1_Motel++;
		}
		else if(GetPlayerSkin(playerid) == 287)
		{
			Team2_Motel++;
		}

		format(msg, sizeof(msg), "[EVENT SCORE]: SWAT %d - %d Terrorists", Team1_Motel, Team2_Motel);
		SendClientMessageToAll(COLOR_NOTICE, msg);
	}
	if(FoCo_Event == 13)
	{
		if(GetPlayerSkin(playerid) == 221)
		{
			Team1_Motel++;
		}
		else if(GetPlayerSkin(playerid) == 287)
		{
			Team2_Motel++;
		}

		format(msg, sizeof(msg), "[EVENT SCORE]: SWAT %d - %d Terrorists", Team1_Motel, Team2_Motel);
		SendClientMessageToAll(COLOR_NOTICE, msg);
	}
	if(FoCo_Event == 8)
	{
		if(GetPlayerSkin(playerid) == 285)
		{
			Team2_Motel++;
		}
		else if(GetPlayerSkin(playerid) == 21)
		{
			Team1_Motel++;
		}

		format(msg, sizeof(msg), "[EVENT SCORE]: SWAT %d - %d Drug Runners", Team1_Motel, Team2_Motel);
		SendClientMessageToAll(COLOR_NOTICE, msg);
		DisablePlayerCheckpoint(playerid);

		if(GetPVarInt(playerid, "PlayerStatus") == 1)
		{
			SetPVarInt(playerid, "MotelTeamIssued", 0);
			SetPlayerSkin(playerid, GetPVarInt(playerid, "MotelSkin"));
			SetPlayerColor(playerid, GetPVarInt(playerid, "MotelColor"));

			SetPlayerPos(playerid, FoCo_Teams[FoCo_Team[playerid]][team_spawn_x], FoCo_Teams[FoCo_Team[playerid]][team_spawn_y], FoCo_Teams[FoCo_Team[playerid]][team_spawn_z]);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, FoCo_Teams[FoCo_Team[playerid]][team_spawn_interior]);
			increment = 0;
			increment2 = 0;
			ResetPlayerWeapons(playerid);
			GiveGuns(playerid);
			TogglePlayerControllable(playerid, 1);
		}

	}

	if(GetPVarInt(playerid, "FellOffEvent") == 1)
	{
		death[playerid] = 0;
		SetPlayerPos(playerid, FoCo_Teams[FoCo_Team[playerid]][team_spawn_x], FoCo_Teams[FoCo_Team[playerid]][team_spawn_y], FoCo_Teams[FoCo_Team[playerid]][team_spawn_z]);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, FoCo_Teams[FoCo_Team[playerid]][team_spawn_interior]);
		GiveGuns(playerid);
		SetPVarInt(playerid, "FellOffEvent", 0);
	}
	switch(FoCo_Event)
	{
		case 2:
		{
			SetPVarInt(playerid, "LeftEventJust", 1);
			if(Iter_Count(Event_Players) == 1)
			{
				winner = Iter_Random(Event_Players);
				format(msg, sizeof(msg), "				%s has won the Sumo event!", PlayerName(winner));
				SendClientMessageToAll(COLOR_NOTICE, msg);
				SendClientMessage(winner, COLOR_NOTICE, "You have won Sumo event! You have earnt 10 score!");
				FoCo_Player[winner][score] = FoCo_Player[winner][score] + 10;
				lastEventWon = winner;
				EndEvent();
			}
		}
		case 3:
		{
			SetPVarInt(playerid, "LeftEventJust", 1);
			if(Iter_Count(Event_Players) == 1)
			{
				winner = Iter_Random(Event_Players);
				format(msg, sizeof(msg), "				%s has won the Hydra Wars event!", PlayerName(winner));
				SendClientMessageToAll(COLOR_NOTICE, msg);
				SendClientMessage(winner, COLOR_NOTICE, "You have won the Hydra Wars event! You have earnt 10 score!");
				FoCo_Player[winner][score] = FoCo_Player[winner][score] + 10;
				lastEventWon = winner;
				EndEvent();
			}
		}
		case 5:
		{
			SetPVarInt(playerid, "MotelTeamIssued", 0);
			new t1, t2;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(GetPVarInt(i, "MotelTeamIssued") == 1)
					{
						t1++;
					}
					else if(GetPVarInt(i, "MotelTeamIssued") == 2)
					{
						t2++;
					}
				}
			}
			if(t1 == 0)
			{
				EndEvent();
				increment = 0;
				increment2 = 0;
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: Criminals have won the event!");
				return 1;
			}
			else if(t2 == 0)
			{
				EndEvent();
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: S.W.A.T have won the event!");
				increment = 0;
				increment2 = 0;
				return 1;
			}
			if(Iter_Count(Event_Players) == 1)
			{
				EndEvent();

			}
		}
		case 6:
		{
			SetPVarInt(playerid, "MotelTeamIssued", 0);
			new t1, t2;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(GetPVarInt(i, "MotelTeamIssued") == 1)
					{
						t1++;
					}
					else if(GetPVarInt(i, "MotelTeamIssued") == 2)
					{
						t2++;
					}
				}
			}
			if(t1 == 0)
			{
				EndEvent();
				increment = 0;
				increment2 = 0;
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Terrorists have won the event!");
				return 1;
			}
			else if(t2 == 0)
			{
				EndEvent();
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Army have won the event!");
				increment = 0;
				increment2 = 0;
				return 1;
			}
			if(Iter_Count(Event_Players) == 1)
			{
				EndEvent();

			}
		}
		case 7:
		{
			SetPVarInt(playerid, "LeftEventJust", 1);
			if(Iter_Count(Event_Players) == 1)
			{
				winner = Iter_Random(Event_Players);
				format(msg, sizeof(msg), "				%s has won the Minigun Wars event!", PlayerName(winner));
				SendClientMessageToAll(COLOR_NOTICE, msg);
				SendClientMessage(winner, COLOR_NOTICE, "You have won the Minigun Wars event! You have earnt 10 score!");
				FoCo_Player[winner][score] = FoCo_Player[winner][score] + 10;
				lastEventWon = winner;
				EndEvent();
			}
		}
		case 8:
		{
			SetPVarInt(playerid, "MotelTeamIssued", 0);
			new t1, t2;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(GetPVarInt(i, "MotelTeamIssued") == 1)
					{
						t1++;
					}
					else if(GetPVarInt(i, "MotelTeamIssued") == 2)
					{
						t2++;
					}
				}
			}
			if(t2 == 0)
			{
				EndEvent();
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: S.W.A.T have won the event!");
				increment = 0;
				increment2 = 0;
				return 1;
			}
			if(Iter_Count(Event_Players) == 1)
			{
				EndEvent();

			}
		}
		case 9:
		{
			if(GetPVarInt(playerid, "MotelTeamIssued") == 1)
			{
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the criminal being caught!");
				EndEvent();
				return 1;
			}

			new team_issue;
			foreach(Player, i)
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
		case 10:
		{
			SetPVarInt(playerid, "MotelTeamIssued", 0);
			new t1, t2;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(GetPVarInt(i, "MotelTeamIssued") == 1)
					{
						t1++;
					}
					else if(GetPVarInt(i, "MotelTeamIssued") == 2)
					{
						t2++;
					}
				}
			}
			if(t1 == 0)
			{
				EndEvent();
				increment = 0;
				increment2 = 0;
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Nuclear Scientists have won the event!");
				return 1;
			}
			else if(t2 == 0)
			{
				EndEvent();
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The US Special Forces have won the event!");
				increment = 0;
				increment2 = 0;
				return 1;
			}
			if(Iter_Count(Event_Players) == 1)
			{
				EndEvent();

			}
		}
		case 11:
		{
			SetPVarInt(playerid, "MotelTeamIssued", 0);
			new t1, t2;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(GetPVarInt(i, "MotelTeamIssued") == 1)
					{
						t1++;
					}
					else if(GetPVarInt(i, "MotelTeamIssued") == 2)
					{
						t2++;
					}
				}
			}
			if(t1 == 0)
			{
				EndEvent();
				increment = 0;
				increment2 = 0;
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Terrorists have won the event!");
				return 1;
			}
			else if(t2 == 0)
			{
				EndEvent();
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Navy Seals have won the event!");
				increment = 0;
				increment2 = 0;
				return 1;
			}
			if(Iter_Count(Event_Players) == 1)
			{
				EndEvent();

			}
		}
		case 12:
		{
			SetPVarInt(playerid, "MotelTeamIssued", 0);
			new t1, t2;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(GetPVarInt(i, "MotelTeamIssued") == 1)
					{
						t1++;
					}
					else if(GetPVarInt(i, "MotelTeamIssued") == 2)
					{
						t2++;
					}
				}
			}
			if(t1 == 0)
			{
				EndEvent();
				increment = 0;
				increment2 = 0;
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Terrorists have won the event!");
				return 1;
			}
			else if(t2 == 0)
			{
				EndEvent();
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: SWAT have won the event!");
				increment = 0;
				increment2 = 0;
				return 1;
			}
			if(Iter_Count(Event_Players) == 1)
			{
				EndEvent();

			}
		}
		case 13:
		{
			SetPVarInt(playerid, "MotelTeamIssued", 0);
			new t1, t2;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(GetPVarInt(i, "MotelTeamIssued") == 1)
					{
						t1++;
					}
					else if(GetPVarInt(i, "MotelTeamIssued") == 2)
					{
						t2++;
					}
				}
			}
			if(t1 == 0)
			{
				EndEvent();
				increment = 0;
				increment2 = 0;
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Terrorists have won the event!");
				return 1;
			}
			else if(t2 == 0)
			{
				EndEvent();
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: SWAT have won the event!");
				increment = 0;
				increment2 = 0;
				return 1;
			}
			if(Iter_Count(Event_Players) == 1)
			{
				EndEvent();

			}
		}
	}
	SetPVarInt(playerid,"PlayerStatus",0);
	return 1;
}

forward EndEvent();
public EndEvent()
{
	if(FoCo_Event == 3)
	{
		KillTimer(hydraTime);
	}

	if(FoCo_Event == 14)
	{
		foreach(Player, i)
		{
			TextDrawHideForPlayer(i, CurrLeader[i]);
			TextDrawHideForPlayer(i, CurrLeaderName[i]);
			TextDrawHideForPlayer(i, GunGame_MyKills[i]);
			TextDrawHideForPlayer(i, GunGame_Weapon[i]);
			GunGameKills[i] = 0;
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(GetPVarInt(i, "PlayerStatus") == 1 && death[i] == 0)
		{
			if(FoCo_Event == 5 || FoCo_Event == 6 || FoCo_Event == 8 || FoCo_Event == 9 || FoCo_Event == 10 || FoCo_Event == 11 || FoCo_Event == 12 || FoCo_Event == 13)
			{
				SetPVarInt(i, "MotelTeamIssued", 0);
				SetPlayerSkin(i, GetPVarInt(i, "MotelSkin"));
				SetPlayerColor(i, GetPVarInt(i, "MotelColor"));
				SetPlayerArmour(i, 0);
			}

			if(FoCo_Event == 11) {
				DisablePlayerCheckpoint(i);
			}

			if(Event_PlayerVeh[i] != -1)
			{
				DestroyVehicle(Event_PlayerVeh[i]);
				Event_PlayerVeh[i] = -1;
			}

			if(FoCo_Event == 9)
			{
				SetPlayerMarkerForPlayer( i, FoCo_Criminal, GetPVarInt(FoCo_Criminal, "MotelColor"));
				if(PlayerPursuitTimer[i]) {
					KillTimer(PlayerPursuitTimer[i]);
				}
			}

			SetPlayerPos(i, FoCo_Teams[FoCo_Team[i]][team_spawn_x], FoCo_Teams[FoCo_Team[i]][team_spawn_y], FoCo_Teams[FoCo_Team[i]][team_spawn_z]);
			SetPlayerVirtualWorld(i, 0);
			SetPlayerInterior(i, FoCo_Teams[FoCo_Team[i]][team_spawn_interior]);
			increment = 0;
			increment2 = 0;
			Motel_Team = 0;
			ResetPlayerWeapons(i);
			GiveGuns(i);
			TogglePlayerControllable(i, 1);
		}
	}

	if(lastEventWon != -1)
	{
		EventGift(lastEventWon);
		lastEventWon = -1;
	}
	if(FoCo_Event == 8)
	{
		new c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16;
		sscanf(DrugEventVehicles, "iiiiiiiiiiiiiiii", c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16);
		DestroyVehicle(c1); DestroyVehicle(c2); DestroyVehicle(c3); DestroyVehicle(c4); DestroyVehicle(c5); DestroyVehicle(c6);
		DestroyVehicle(c7); DestroyVehicle(c8); DestroyVehicle(c9); DestroyVehicle(c10); DestroyVehicle(c11); DestroyVehicle(c12);
		DestroyVehicle(c13); DestroyVehicle(c14); DestroyVehicle(c15); DestroyVehicle(c16);
		format(DrugEventVehicles, strlen(DrugEventVehicles), " ");
	}

	if(FoCo_Event == 9)
	{
		Motel_Team = 0;
		new c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11;
		sscanf(DrugEventVehicles, "iiiiiiiiiii", c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11);
		DestroyVehicle(c1); DestroyVehicle(c2); DestroyVehicle(c3); DestroyVehicle(c4); DestroyVehicle(c5); DestroyVehicle(c6);
		DestroyVehicle(c7); DestroyVehicle(c8); DestroyVehicle(c9); DestroyVehicle(c10); DestroyVehicle(c11);
		format(DrugEventVehicles, strlen(DrugEventVehicles), " ");
	}

	if(FoCo_Event == 5 || FoCo_Event == 6 || FoCo_Event == 8 || FoCo_Event == 10 || FoCo_Event == 11 || FoCo_Event == 12 || FoCo_Event == 13)
	{
		Team1_Motel = 0;
		Team2_Motel = 0;
	}

	if(FoCo_Event == 15) clearevent();

	FoCo_Criminal = -1;
	FoCo_Event = -1;
	FoCo_Event_Rejoin = 0;
	if(Iter_Count(Event_Players) > 0)
	{
		Iter_Clear(Event_Players);
	}

	// Bodge Job fix for some errors (existing and new).
	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
		SetPVarInt(i, "PlayerStatus", 0);
	}
	increment = 0;
	return 1;
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

forward EventGift(playerid);
public EventGift(playerid)
{
	new ran = random(8);
	switch(ran)
	{
		case 0:
		{
			GivePlayerMoney(playerid, 1000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $1000");
		}
		case 1:
		{
			GivePlayerMoney(playerid, 4000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $4000");
		}
		case 2:
		{
			GivePlayerMoney(playerid, 10000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $10000");
		}
		case 3:
		{
			GivePlayerMoney(playerid, 20000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $20000");
		}
		case 4:
		{
			SetPlayerArmour(playerid, 99);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 100 armour");
		}
		case 5:
		{
			GivePlayerWeapon(playerid, 38, 100);
			new string[82];
			format(string, sizeof(string), "[NOTICE]: %s has won an event and won the random Minigun.", PlayerName(playerid));
			SendAdminMessage(1,string);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a minigun");
		}
		case 6:
		{
			FoCo_Playerstats[playerid][kills] = FoCo_Playerstats[playerid][kills] + 10;
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 10 extra kills");
		}
		case 7:
		{
			FoCo_Playerstats[playerid][deaths] = FoCo_Playerstats[playerid][deaths] - 10;
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 10 less deaths");
		}
		case 8:
		{
			GivePlayerMoney(playerid, 50000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $50000");
		}
	}
	return 1;
}

forward Random_Pursuit_Vehicle();
public Random_Pursuit_Vehicle()
{
	new randVeh, vehicle;
	randVeh = random(8);
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
	}
	return vehicle;
}
//===============================[CALLBACKS]====================================
forward Event_OnGameModeInit();
public Event_OnGameModeInit()
{
//	Dev_Chilco_ctf_OnGameModeInit();
	return 1;
}

forward Event_OnGameModeExit();
public Event_OnGameModeExit()
{
	return 1;
}

forward Event_OnPlayerRequestClass(playerid, classid);
public Event_OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

forward Event_OnPlayerConnect(playerid);
public Event_OnPlayerConnect(playerid)
{
    SetPVarInt(playerid,"PlayerStatus",0);
	return 1;
}

forward Event_OnPlayerDisconnect(playerid, reason);
public Event_OnPlayerDisconnect(playerid, reason)
{
	if(Event_PlayerVeh[playerid] != -1)
	{
		DestroyVehicle(Event_PlayerVeh[playerid]);
		Event_PlayerVeh[playerid] = -1;
	}
	if(FoCo_Event != -1)
	{
		if(GetPVarInt(playerid, "PlayerStatus") == 1)
		{
			if(PlayerPursuitTimer[playerid])
			{
				KillTimer(PlayerPursuitTimer[playerid]);
			}
			PlayerLeftEvent(playerid);
		}
	}
	return 1;
}

forward Event_OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid);
public Event_OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
	return 1;
}

forward Event_OnPlayerSpawn(playerid);
public Event_OnPlayerSpawn(playerid)
{
	if(Event_PlayerVeh[playerid] != -1)
	{
		DestroyVehicle(Event_PlayerVeh[playerid]);
		Event_PlayerVeh[playerid] = -1;
	}
	if(GetPVarInt(playerid, "PlayerStatus") == 1 && FoCo_Event == 14)
	{
		SetPlayerArmour(playerid, 0);
		SetPlayerHealth(playerid, 99);
		SetPlayerVirtualWorld(playerid, 1500);
		SetPlayerInterior(playerid, 0);
		new randomnum = random(250);
		SetPlayerPos(playerid, GunGameSpawns[randomnum][0], GunGameSpawns[randomnum][1], GunGameSpawns[randomnum][2]);
		SetPlayerFacingAngle(playerid, GunGameSpawns[randomnum][3]);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, GunGameWeapons[GunGameKills[playerid]], 500);
		GameTextForPlayer(playerid, "~R~~n~~n~ Gun ~h~ Game!", 800, 3);
	}
	return 1;
}

forward Event_PickUpDynamicPickup(playerid, pickupid);
public Event_PickUpDynamicPickup(playerid, pickupid)
{
	return 1;
}

forward Event_OnPlayerDeath(playerid, killerid, reason);
public Event_OnPlayerDeath(playerid, killerid, reason)
{
//	Dev_Chilco_ctf_OnPlayerDeath(playerid, killerid, reason);
	if(EventDrugDelay[playerid] != -1)
	{
		EventDrugDelay[playerid] = -1;
	}
	if(FoCo_Event != -1)
	{
		if(GetPVarInt(playerid, "PlayerStatus") == 1)
		{
			if(PlayerPursuitTimer[playerid])
			{
				KillTimer(PlayerPursuitTimer[playerid]);
			}
			if(FoCo_Event != 14)
			{
				PlayerLeftEvent(playerid);
			}
			if(FoCo_Event == 2)
			{
				SpawnPlayer(playerid);
				return 1;
			}
			if(FoCo_Event == 14)
			{
				if(killerid != INVALID_PLAYER_ID && GetPVarInt(killerid, "PlayerStatus") == 1 && lastGunGameWeapon[killerid] != reason)
				{
					PlayerLeftEvent(playerid);
					GunGameKills[killerid]++;
					ResetPlayerWeapons(killerid);
					GivePlayerWeapon(killerid, GunGameWeapons[GunGameKills[killerid]], 500);
					lastGunGameWeapon[killerid] = GunGameWeapons[GunGameKills[killerid]-1];
					new tmpString[63];
					format(tmpString, sizeof(tmpString), "(%d / 16)", GunGameKills[killerid]);
					TextDrawSetString(GunGame_MyKills[killerid], tmpString);

					new varHigh = 0;
					foreach(Player, i)
					{
						if(GetPVarInt(playerid, "PlayerStatus") == 1)
						{
							if(GunGameKills[killerid] < GunGameKills[i])
							{
								varHigh = 1;
							}
						}
					}

					if(varHigh == 0)
					{
						format(tmpString, sizeof(tmpString), "%s (%d / 16)", PlayerName(killerid), GunGameKills[killerid]);
						foreach(Player, i)
						{
							if(GetPVarInt(playerid, "PlayerStatus") == 1)
							{
								TextDrawSetString(CurrLeaderName[i], tmpString);
							}
						}
					}

					if(GunGameKills[killerid] >= 17)
					{
						format(tmpString, sizeof(tmpString), "[Event Notice]: %s has won the Gun Game.", PlayerName(killerid));
						SendClientMessageToAll(COLOR_NOTICE, tmpString);
						lastEventWon = killerid;
						EndEvent();
					}
				}
			}
		}
	}
	return 1;
}

forward Event_OnVehicleSpawn(vehicleid);
public Event_OnVehicleSpawn(vehicleid)
{
	return 1;
}

forward Event_OnVehicleDeath(vehicleid, killerid);
public Event_OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

forward Event_OnPlayerText(playerid, text[]);
public Event_OnPlayerText(playerid, text[])
{
	return 1;
}

forward Event_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
public Event_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

forward Event_OnPlayerExitVehicle(playerid, vehicleid);
public Event_OnPlayerExitVehicle(playerid, vehicleid)
{
    if(vehicleid == Event_PlayerVeh[playerid])
	{
		switch(FoCo_Event)
		{
			case 2,3:
			{
				if(FoCo_Event != -1)
				{
					if(GetPVarInt(playerid, "PlayerStatus") == 1)
					{
						SetPVarInt(playerid, "FellOffEvent", 1);
						PlayerLeftEvent(playerid);
						SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: You have been removed from the event for leaving your vehicle.");
					}
				}
			}
		}
	}
	return 1;
}

forward Event_OnPlayerPrivmsg(playerid, recieverid, text[]);
public Event_OnPlayerPrivmsg(playerid, recieverid, text[])
{
	return 1;
}

forward Event_OnPlayerStateChange(playerid, newstate, oldstate);
public Event_OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

forward Event_OnPlayerEnterCheckpoint(playerid);
public Event_OnPlayerEnterCheckpoint(playerid)
{
    if(FoCo_Event == 8 && GetPVarInt(playerid, "PlayerStatus") == 1 && GetPVarInt(playerid, "MotelTeamIssued") != 1)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid, COLOR_WARNING, "Get out the vehicle!");
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 1421.5542,2773.9951,10.8203, 4.0);
			return 1;
		}
		EventDrugDelay[playerid] = 15;
		SendClientMessage(playerid, COLOR_NOTICE, "Stay alive for fifteen seconds to win!");
		new string[83];
		foreach(Event_Players, i)
		{
			format(string, sizeof(string), "%s has entered the checkpoint, kill him within 15 seconds!", PlayerName(playerid));
			SendClientMessage(i, COLOR_NOTICE, string);
		}
	}
	return 1;
}

forward Event_OnPlayerLeaveCheckpoint(playerid);
public Event_OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

forward Event_OnPlayerRequestSpawn(playerid);
public Event_OnPlayerRequestSpawn(playerid)
{
	return 1;
}

forward Event_OnObjectMoved(objectid);
public Event_OnObjectMoved(objectid)
{
	return 1;
}

forward Event_OnPlayerUpdate(playerid);
public Event_OnPlayerUpdate(playerid)
{
	if(FoCo_Event == 14)
	{
		if(GetPVarInt(playerid, "PlayerStatus") == 1)
		{
			new tmpStr[30];
			format(tmpStr, sizeof(tmpStr), "%s", WeapNames[GetPlayerWeapon(playerid)]);
			TextDrawSetString(GunGame_Weapon[playerid], tmpStr);
		}
	}
	return 1;
}

forward Event_OnPlayerObjectMoved(playerid, objectid);
public Event_OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

forward Event_OnPlayerPickUpPickup(playerid, pickupid);
public Event_OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

forward Event_OnVehicleMod(playerid, vehicleid, componentid);
public Event_OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

forward Event_OnVehiclePaintjob(playerid, vehicleid, paintjobid);
public Event_OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

forward Event_OnVehicleRespray(playerid, vehicleid, color1, color2);
public Event_OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

forward Event_OnPlayerSelectedMenuRow(playerid, row);
public Event_OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

forward Event_OnPlayerExitedMenu(playerid);
public Event_OnPlayerExitedMenu(playerid)
{
	return 1;
}

forward Event_OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid);
public Event_OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

forward Event_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
public Event_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
//	Dev_Chilco_ctf_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    return 1;
}

forward Event_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
public Event_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new string[180];
//	Dev_Chilco_ctf_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
	switch(dialogid)
	{
	    case DIALOG_EVENTSTART:
		{
			if(!response) return 1;
			DialogOptionVar1[playerid] = listitem;
			switch(listitem)
			{
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_EVENTSTART2, DIALOG_STYLE_LIST, "Event Options", "1. Monster\n2. Banger\n3. Sandking\n4. Destruction Derby", "OK", "CLOSE");
					//ShowPlayerDialog(playerid, DIALOG_EVENTSTART2, DIALOG_STYLE_LIST, "Event Options", "1. Monster\n2. Banger\n3. Sandking\n4. Destruction Derby\n5. SandKing Reloaded.", "OK", "CLOSE");
					return 1;
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_EVENTSTART2, DIALOG_STYLE_MSGBOX, "Event Options", "Which type of Hydra War should this be? Currently only LV is scripted.", "LV", "None");
					return 1;
				}
				case 4:
				{
					ShowPlayerDialog(playerid, DIALOG_EVENTSTART22, DIALOG_STYLE_INPUT, "Event Options", "Which weapon should be used?", "Confirm", "Close");
					return 1;
				}
				case 5:
				{
					new adname[56];
					GetPlayerName(playerid, adname, sizeof(adname));
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}

					FoCo_Event_Rejoin = 0;
					foreach(Player, i)
					{
						FoCo_Event_Died[i] = 0;
					}

					FoCo_Event = 5;
					format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Jefferson Motel Team DM {%06x}event.  Type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
					Event_Delay = 30;
					return 1;
				}
				case 6:
				{
					new adname[56];
					GetPlayerName(playerid, adname, sizeof(adname));
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}

					FoCo_Event_Rejoin = 0;
					foreach(Player, i)
					{
						FoCo_Event_Died[i] = 0;
					}

					FoCo_Event = 6;
					format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Army vs. Terrorists Team DM {%06x}event.  Type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
					Event_Delay = 30;
					return 1;
				}
				case 7:
				{
					new adname[56];
					GetPlayerName(playerid, adname, sizeof(adname));
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}
					FoCo_Event = 7;
					format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Minigun Wars {%06x}event. 30 seconds before it starts, type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
					Event_Delay = 30;
					return 1;
				}
				case 8:
				{
					new adname[56];
					GetPlayerName(playerid, adname, sizeof(adname));
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}

					FoCo_Event_Rejoin = 0;
					foreach(Player, i)
					{
						FoCo_Event_Died[i] = 0;
					}

					FoCo_Event = 8;
					format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Team Drug Run {%06x}event.  Type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
					Event_Delay = 30;

					new c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16;
					c1 = CreateVehicle(431,1804.9897,-1928.3383,13.4915,359.5247,1,1, 600000); // crimcar1
					c2 = CreateVehicle(567,1805.2609,-1911.4696,13.2676,359.9748,1,1, 600000); // crimcar2
					c3 = CreateVehicle(567,1796.8599,-1931.1780,13.2519,2.8630,1,1, 600000); // crimcar3
					c4 = CreateVehicle(536,1785.3833,-1931.5442,13.1238,0.4821,1,1, 600000); // crimcar4
					c5 = CreateVehicle(567,1790.4397,-1931.3499,13.2531,359.2782,1,1, 600000); // crimcar5
					c6 = CreateVehicle(560,1778.6602,-1932.2065,13.0915,359.6266,1,1, 600000); // crimcar6
					c7 = CreateVehicle(522,1775.8104,-1925.5791,12.9557,228.7756,1,1, 600000); // crimcar7
					c8 = CreateVehicle(455,1776.7750,-1911.1565,13.8224,182.1264,1,1, 600000); // crimcar8
					c9 = CreateVehicle(433,325.4319,2541.5896,17.2446,178.8733,1,1, 600000); // carpos1swat
					c10 = CreateVehicle(433,291.5707,2542.2861,17.2572,181.1078,1,1, 600000); // carpos2swat
					c11 = CreateVehicle(470,331.9542,2527.1885,16.7732,89.7045,1,1, 6000000); // carpos2swat
					c12 = CreateVehicle(470,339.5666,2527.3247,16.7636,89.7131,1,1, 6000000); // carpos2swat
					c13 = CreateVehicle(470,345.7501,2527.4158,16.7324,90.8450,1,1, 6000000); // carpos2swat
					c14 = CreateVehicle(470,352.0356,2527.3730,16.7001,90.3715,1,1, 6000000); // carpos2swat
					c15 = CreateVehicle(470,358.3670,2527.4417,16.6720,91.0383,1,1, 6000000); // carpos2swat
					c16 = CreateVehicle(470,364.3454,2527.4082,16.6404,89.8504,1,1, 6000000); // carpos2swat

					SetVehicleVirtualWorld(c1, 1500); SetVehicleVirtualWorld(c2, 1500); SetVehicleVirtualWorld(c3, 1500); SetVehicleVirtualWorld(c4, 1500);
					SetVehicleVirtualWorld(c5, 1500);	SetVehicleVirtualWorld(c6, 1500);	SetVehicleVirtualWorld(c7, 1500);	SetVehicleVirtualWorld(c8, 1500);
					SetVehicleVirtualWorld(c9, 1500);	SetVehicleVirtualWorld(c10, 1500);	SetVehicleVirtualWorld(c11, 1500);	SetVehicleVirtualWorld(c12, 1500);
					SetVehicleVirtualWorld(c13, 1500);	SetVehicleVirtualWorld(c14, 1500);	SetVehicleVirtualWorld(c15, 1500); SetVehicleVirtualWorld(c16, 1500);

					format(DrugEventVehicles, sizeof(DrugEventVehicles), "%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d", c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16);
					return 1;
				}
				case 9:
				{
					new adname[56];
					GetPlayerName(playerid, adname, sizeof(adname));
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}

					FoCo_Event_Rejoin = 0;
					foreach(Player, i)
					{
						FoCo_Event_Died[i] = 0;
					}

					increment = 0;
					FoCo_Event = 9;
					format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Pursuit {%06x}event.  Type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
					Event_Delay = 30;

					new car;
					for(new i = 0; i < 11; i++)
					{
						if(i == 10)
						{
							car = CreateVehicle(Random_Pursuit_Vehicle(), pursuitVehicles[i][0], pursuitVehicles[i][1], pursuitVehicles[i][2], pursuitVehicles[i][3], 1, 0, 600000);
							SetVehicleVirtualWorld(car, 1500);
							format(DrugEventVehicles, sizeof(DrugEventVehicles), "%s %d ", DrugEventVehicles, car);
							E_Pursuit_Criminal = car;
						}
						else
						{
							car = CreateVehicle(596, pursuitVehicles[i][0], pursuitVehicles[i][1], pursuitVehicles[i][2], pursuitVehicles[i][3], 1, 0, 600000);
							SetVehicleVirtualWorld(car, 1500);
							format(DrugEventVehicles, sizeof(DrugEventVehicles), "%s %d ", DrugEventVehicles, car);
						}
					}
					return 1;
				}
				case 10:
				{
					new adname[56];
					GetPlayerName(playerid, adname, sizeof(adname));
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}

					FoCo_Event_Rejoin = 0;
					foreach(Player, i)
					{
						FoCo_Event_Died[i] = 0;
					}

					FoCo_Event = 10;
					format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}United Special Forces vs. Nuclear Scientists Team DM {%06x}event.  Type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
					Event_Delay = 30;
					return 1;
				}
				case 11:
				{
					new adname[56];
					GetPlayerName(playerid, adname, sizeof(adname));
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}

					FoCo_Event_Rejoin = 0;
					foreach(Player, i)
					{
						FoCo_Event_Died[i] = 0;
					}

					FoCo_Event = 11;
					format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Navy Seals vs. Terrorists {%06x}event.  Type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
					Event_Delay = 30;
					return 1;
				}
				case 12:
				{
					new adname[56];
					GetPlayerName(playerid, adname, sizeof(adname));
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}

					FoCo_Event_Rejoin = 0;
					foreach(Player, i)
					{
						FoCo_Event_Died[i] = 0;
					}

					FoCo_Event = 12;
					format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Oil Rig Terrorists {%06x}event.  Type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
					Event_Delay = 30;
					return 1;
				}
				case 13:
				{
					new adname[56];
					GetPlayerName(playerid, adname, sizeof(adname));
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}

					FoCo_Event_Rejoin = 0;
					foreach(Player, i)
					{
						FoCo_Event_Died[i] = 0;
					}

					FoCo_Event = 13;
					format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Compound Attack {%06x}event.  Type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
					Event_Delay = 30;
					return 1;
				}
			}
			ShowPlayerDialog(playerid, DIALOG_EVENTSTART2, DIALOG_STYLE_MSGBOX, "Event Rejoinable", "Should this event be rejoinable after death or not?", "Yes", "No");
			return 1;
		}
		case DIALOG_EVENTSTART22:
		{
			if(!response)
			{
				return 1;
			}

			if(strval(inputtext) > 39 || strval(inputtext) < 1) {
				SendClientMessage(playerid, COLOR_WARNING, "Invalid value");
				return 1;
			}

			MadDogsWeapon = strval(inputtext);
			ShowPlayerDialog(playerid, DIALOG_EVENTSTART2, DIALOG_STYLE_MSGBOX, "Event Rejoinable", "Should this event be rejoinable after death or not?", "Yes", "No");
			return 1;
		}
		case DIALOG_EVENTSTART2:
		{
			new adname[56];
			GetPlayerName(playerid, adname, sizeof(adname));
			if(response)
			{
				FoCo_Event_Rejoin = 1;
				foreach(Player, i)
				{
					FoCo_Event_Died[i] = 0;
				}
			}
			else
			{
				FoCo_Event_Rejoin = 0;
				foreach(Player, i)
				{
					FoCo_Event_Died[i] = 0;
				}
			}
			switch(DialogOptionVar1[playerid])
			{
				case 0:
				{
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}
					FoCo_Event = 0;
					format(string, sizeof(string), "[EVENT]: %s %s has started the Bigsmoke event.  Type /join!", GetPlayerStatus(playerid), adname);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
				}
				case 1:
				{
					if(Brawl_X == 0.0)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Set the brawl point first");
						return 1;
					}
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}
					FoCo_Event = 1;
					format(string, sizeof(string), "[EVENT]: %s %s has started the brawl event. Type /join!", GetPlayerStatus(playerid), adname);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
				}
				case 2:
				{
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}

					if(!response)
					{
						return 1;
					}

					switch(listitem)
					{
						case 0:
						{
							FoCo_Event = 2;
							Sumo_Type = 1;
							format(string, sizeof(string), "[EVENT]: %s %s has started the Monster Sumo event. 30 seconds before it starts, type /join! Map by {%06x}Rayoo.",GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8);
							SendClientMessageToAll(COLOR_CMDNOTICE, string);
							IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
							Event_InProgress = 0;
							Event_Delay = 30;
						}
						case 1:
						{
							FoCo_Event = 2;
							Sumo_Type = 0;
							format(string, sizeof(string), "[EVENT]: %s %s has started the Banger Sumo event. 30 seconds before it starts, type /join! Map by {%06x}Tsar.", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8);
							SendClientMessageToAll(COLOR_CMDNOTICE, string);
							IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
							Event_InProgress = 0;
							Event_Delay = 30;
						}
						case 2:
						{
							FoCo_Event = 2;
							Sumo_Type = 2;
							format(string, sizeof(string), "[EVENT]: %s %s has started the SandKing Sumo event. 30 seconds before it starts, type /join! Map by {%06x}RakGuy.", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8);
							SendClientMessageToAll(COLOR_CMDNOTICE, string);
							IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
							Event_InProgress = 0;
							Event_Delay = 30;
						}
						case 3:
						{
							FoCo_Event = 2;
							Sumo_Type = 3;
							format(string, sizeof(string), "[EVENT]: %s %s has started the Destruction Derby event. 30 seconds before it starts, type /join! Map by {%06x}Hiro.", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8);
							SendClientMessageToAll(COLOR_CMDNOTICE, string);
							IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
							Event_InProgress = 0;
							Event_Delay = 30;

						}
						case 4:
						{
							FoCo_Event = 2;
							Sumo_Type = 4;
							format(string, sizeof(string), "[EVENT]: %s %s has started the SandKing Sumo Reloaded event. 30 seconds before it starts, type /join! Map by {%06x}RakGuy.", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8);
							SendClientMessageToAll(COLOR_CMDNOTICE, string);
							IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
							Event_InProgress = 0;
							Event_Delay = 30;
						}
					}
					return 1;
				}
				case 3:
				{
					if(response)
					{
						if(FoCo_Event != -1)
						{
							SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
							return 1;
						}
						FoCo_Event = 3;
						format(string, sizeof(string), "[EVENT]: %s %s has started the hydra wars event. 30 seconds before it starts, type /join!", GetPlayerStatus(playerid), adname);
						SendClientMessageToAll(COLOR_CMDNOTICE, string);
						IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
						Event_InProgress = 0;
						Event_Delay = 30;
					}
					else return 1;
				}
				case 4:
				{
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}
					FoCo_Event = 4;
					format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Mad Dogg's Mansion DM {%06x}event.  Type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
				}
				case 14:
				{
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}

					FoCo_Event = 14;
					format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Gun Game {%06x}event.  Type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
					return 1;
				}
			}
			return 1;
		}
	}
	return 1;
}

forward Event_OnPlayerClickPlayer(playerid, clickedplayerid, source);
public Event_OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

forward Event_OneSecond();
public Event_OneSecond()
{
    Event_Delay --;
	if(Event_Delay == 0)
	{
		Event_InProgress = 1;
		switch(FoCo_Event)
		{
			case 2:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Sumo is now in progress and can not be joined.");
				foreach(Event_Players, player)
				{
					SetVehicleParamsEx(Event_PlayerVeh[player], true, false, false, true, false, false, false);
					TogglePlayerControllable(player, 1);
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
					increment = 0;
				}
			}
			case 3:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Hydra wars is now in progress and can not be joined");
				hydraTime = SetTimer("EndEvent", 480000, false);
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					increment = 0;
				}
			}
			case 5:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Jefferson Motel DM is now in progress and can not be joined");
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					increment = 0;
					increment2 = 0;
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
				}
			}
			case 6:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Army vs. Terrorists DM is now in progress and can not be joined");
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					increment = 0;
					increment2 = 0;
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
				}
			}
			case 7:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Minigun wars is now in progress and can not be joined");
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					SendClientMessage(player, COLOR_NOTICE, "Fuck them bitches up playa!");
					increment = 0;
				}
			}
			case 8:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Team Drug Run is now in progress and can not be joined");
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					increment = 0;
					increment2 = 0;
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
					SetPlayerCheckpoint(player, 1421.5542,2773.9951,10.8203, 4.0);
				}
			}
			case 9:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Pursuit is now in progress and can not be joined");
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					increment = 0;
					increment2 = 0;
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
				}
			}
			case 10:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Area 51 DM is now in progress and can not be joined");
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					increment = 0;
					increment2 = 0;
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
				}
			}
			case 11:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Navy Seals Vs. Terrorists is now in progress and can not be joined");
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					increment = 0;
					increment2 = 0;
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
					DisablePlayerCheckpoint(player);
					if(GetPVarInt(player, "MotelTeamIssued") == 1)
					{
						SetPlayerCheckpoint(player, -1446.6353,1502.6423,1.7366, 4.0);
					}
				}
			}
			case 12:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Oil Rig Terrorists is now in progress and can not be joined");
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					increment = 0;
					increment2 = 0;
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
				}
			}
			case 13:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Compound Attack is now in progress and can not be joined");
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					increment = 0;
					increment2 = 0;
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
					if(GetPVarInt(player, "MotelTeamIssued") == 1)
					{
						SetPlayerCheckpoint(player, -2126.5669,-84.7937,35.3203,2.3031);
					}
				}
			}
			case 14:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Gun Game is now in progress and can not be joined");
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					increment = 0;
					increment2 = 0;
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
				}
			}
			case 15:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Custom event is now in progress and can not be joined");
				Event_InProgress = 1;
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
				}
			}
		}
	}
	else if(Event_Delay >= 0 && Event_Delay <= 5)
	{
		switch(FoCo_Event)
		{
			case 2:
			{
				new Float:vehx, Float:vehy, Float:vehz, Float:vang;
				foreach(Event_Players, player)
				{
					GetPlayerPos(player, vehx, vehy, vehz);
					GetPlayerFacingAngle(player, vang);
					SetVehiclePos(Event_PlayerVeh[player], vehx, vehy, vehz);
					SetVehicleZAngle(player, vang);
					PutPlayerInVehicle(player, Event_PlayerVeh[player], 0);
					SetVehicleParamsEx(Event_PlayerVeh[player], false, false, false, true, false, false, false);
					TogglePlayerControllable(player, 0);
				}
			}
		}
	}
	else if(Event_Delay > 0)
	{
		foreach(Event_Players, player)
		{
			if(FoCo_Event == 5)
			{
				SetCameraBehindPlayer(player);
			}
			TogglePlayerControllable(player, 0);
		}
	}
	foreach(Player,i)
	{
		if(EventDrugDelay[i] != -1)
		{
			if(EventDrugDelay[i] == 0)
			{
				SetPVarInt(i, "MotelTeamIssued", 0);
				EndEvent();
				increment = 0;
				increment2 = 0;
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: Criminals succesfully dropped off the drugs!");
				EventDrugDelay[i] = -1;
				return 1;
			}

			EventDrugDelay[i]--;
		}
		if(GetPVarInt(i, "PlayerStatus") == 1 && Event_InProgress == 1)
		{
			switch(FoCo_Event)
			{
				case 2:
				{
					new Float:vx, Float:vy, Float:vz;
					GetVehiclePos(Event_PlayerVeh[i], vx, vy, vz);
					if(vz < 3.0 || GetPlayerState(i) != PLAYER_STATE_DRIVER)
					{
						SetPVarInt(i, "FellOffEvent", 1);
						PlayerLeftEvent(i);
					}
				}
				case 3:
				{
					if(GetPlayerState(i) != PLAYER_STATE_DRIVER)
					{
						PlayerLeftEvent(i);
					}
				}
				case 12:
				{
					new Float:vx, Float:vy, Float:vz;
					GetPlayerPos(i, vx, vy, vz);
					if(vz < 3.0)
					{
						SetPVarInt(i, "FellOffEvent", 1);
						PlayerLeftEvent(i);
					}
				}
			}
		}
	}
	return 1;
}

forward Event_TenMinutes();
public Event_TenMinutes()
{
	return 1;
}
//================================[COMMANDS]====================================
CMD:event(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new option[50], string[86], adname[MAX_PLAYER_NAME];
		if (sscanf(params, "s[50] ", option))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "	[USAGE]: /event [Parameter]");
			SendClientMessage(playerid, COLOR_GRAD1, " [PARAMS]: Start - End - SetBrawlPoint");
			return 1;
	    }

		GetPlayerName(playerid, adname, sizeof(adname));

		if(strcmp(option,"Start", true) == 0)
		{
			if(FoCo_Event != -1)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  There is already an event running, end it first.");
				return 1;
			}
			ShowPlayerDialog(playerid, DIALOG_EVENTSTART, DIALOG_STYLE_LIST, "Event Starting", EVENT_LIST, "Select", "Cancel");
			return 1;

		}
		else if(strcmp(option,"End", true) == 0)
		{
			if(FoCo_Event == -1)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  There is no event to stop.");
				return 1;
			}
			EndEvent();
			increment = 0;
			MadDogsWeapon = 0;
			format(string, sizeof(string), "[EVENT]: %s %s has stopped the event!", GetPlayerStatus(playerid), adname);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendClientMessageToAll(COLOR_NOTICE, string);
			return 1;
		}
		else if(strcmp(option,"SetBrawlPoint", true) == 0)
		{
			GetPlayerPos(playerid, Brawl_X, Brawl_Y, Brawl_Z);
			GetPlayerFacingAngle(playerid, Brawl_Angle);
			Brawl_World = GetPlayerVirtualWorld(playerid);
			Brawl_Int = GetPlayerInterior(playerid);
			SendClientMessage(playerid, COLOR_ADMIN, "[NOTICE]: Brawl Point has now been set to here.");
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, "[AdmCMD]: Brawl Point has been set ingame.");
			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid param.");
		}
	}
	return 1;
}


CMD:join(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerStatus") == 2)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are in a duel, leave that first...");
		return 1;
	}
	if(FoCo_Player[playerid][jailed] != 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please wait until your admin jail is over.");
		return 1;
	}
	if(FoCo_Event == -1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No event has been started.");
		return 1;
	}
	if(FoCo_Event_Rejoin == 0 && FoCo_Event_Died[playerid] != 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You died and this is not rejoinable.");
		return 1;
	}
	if(Event_InProgress == 1)
	{
		SendClientMessage(playerid, COLOR_NOTICE, "This event is in progress now and can not be joined.");
		return 1;
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_WASTED || GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
		return 1;
	}
	if(GetPVarInt(playerid, "PlayerStatus") == 1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are already at the event!");
		return 1;
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
		RemovePlayerFromVehicle(playerid);
	}

	//DeleteAllAttachedWeapons(playerid);
	if(HaveCap(playerid) == 1)
	{
		RemovePlayerAttachedObject(playerid, pObject[playerid][oslot]);
		pObject[playerid][oslot] = -1;
		pObject[playerid][slotreserved] = false;
	}

	switch(FoCo_Event)
	{
		case 0:
		{
			SetPVarInt(playerid,"PlayerStatus",1);
			new randomnum = random(20);
			SetPlayerArmour(playerid, 0);
			SetPlayerHealth(playerid, 99);
			SetPlayerInterior(playerid, 2);
			SetPlayerPos(playerid, BigSmokeSpawns[randomnum][0], BigSmokeSpawns[randomnum][1], BigSmokeSpawns[randomnum][2]);
			SetPlayerVirtualWorld(playerid, 1500);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 500);
			GameTextForPlayer(playerid, "~R~~n~~n~ Big ~h~ Smoke!", 800, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 1:
		{
			GiveAchievement(playerid, 24);
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerPos(playerid, Brawl_X, Brawl_Y, Brawl_Z);
			SetPlayerFacingAngle(playerid, Brawl_Angle);
			SetPlayerInterior(playerid, Brawl_Int);
			SetPlayerHealth(playerid, 99);
			SetPlayerArmour(playerid, 0);
			SetPlayerVirtualWorld(playerid, Brawl_World);
			ResetPlayerWeapons(playerid);
			GameTextForPlayer(playerid, "~R~~n~~n~ The ~h~ Brawl!", 800, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 2:
		{
			if(Iter_Count(Event_Players) == 25)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 505);
			if(Sumo_Type == 0)
			{
				SetPlayerPos(playerid, sumoSpawnsType2[increment][0], sumoSpawnsType2[increment][1], sumoSpawnsType2[increment][2]+5);
				SetPlayerFacingAngle(playerid, sumoSpawnsType2[increment][3]);
				Event_PlayerVeh[playerid] = CreateVehicle(504, sumoSpawnsType2[increment][0], sumoSpawnsType2[increment][1], sumoSpawnsType2[increment][2], sumoSpawnsType2[increment][3], -1, -1, 15);
			}
			else if(Sumo_Type == 1)
			{
				SetPlayerPos(playerid, sumoSpawnsType1[increment][0], sumoSpawnsType1[increment][1], sumoSpawnsType1[increment][2]+5);
				SetPlayerFacingAngle(playerid, sumoSpawnsType1[increment][3]);
				Event_PlayerVeh[playerid] = CreateVehicle(556, sumoSpawnsType1[increment][0], sumoSpawnsType1[increment][1], sumoSpawnsType1[increment][2], sumoSpawnsType1[increment][3], -1, -1, 15);
				SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType1[increment][3]);
			}
			else if(Sumo_Type == 2)
			{
				SetPlayerPos(playerid, sumoSpawnsType3[increment][0], sumoSpawnsType3[increment][1], sumoSpawnsType3[increment][2]+5);
				SetPlayerFacingAngle(playerid, sumoSpawnsType3[increment][3]);
				Event_PlayerVeh[playerid] = CreateVehicle(495, sumoSpawnsType3[increment][0], sumoSpawnsType3[increment][1], sumoSpawnsType3[increment][2], sumoSpawnsType3[increment][3], -1, -1, 15);
				SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType3[increment][3]);
			}
			else if(Sumo_Type == 4)
			{
				SetPlayerPos(playerid, sumoSpawnsType5[increment][0], sumoSpawnsType5[increment][1], sumoSpawnsType5[increment][2]+5);
				SetPlayerFacingAngle(playerid, sumoSpawnsType5[increment][3]);
				Event_PlayerVeh[playerid] = CreateVehicle(495, sumoSpawnsType5[increment][0], sumoSpawnsType5[increment][1], sumoSpawnsType5[increment][2], sumoSpawnsType5[increment][3], -1, -1, 15);
				SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType5[increment][3]);
			}
			else
			{
				SetPlayerInterior(playerid, 15);
				SetPlayerPos(playerid, sumoSpawnsType4[increment][0], sumoSpawnsType4[increment][1], sumoSpawnsType4[increment][2]+5);
				SetPlayerFacingAngle(playerid, sumoSpawnsType4[increment][3]);
				Event_PlayerVeh[playerid] = CreateVehicle(504, sumoSpawnsType4[increment][0], sumoSpawnsType4[increment][1], sumoSpawnsType4[increment][2], sumoSpawnsType4[increment][3], -1, -1, 15);
				SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType4[increment][3]);
				LinkVehicleToInterior(Event_PlayerVeh[playerid], 15);
			}
			SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
			Iter_Add(Event_Players, playerid);
			SetPlayerArmour(playerid, 0);
			SetPlayerHealth(playerid, 99);
			ResetPlayerWeapons(playerid);
			GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
			TogglePlayerControllable(playerid, 0);
			SetCameraBehindPlayer(playerid);
			increment++;
		}
		case 3:
		{
			if(Iter_Count(Event_Players) == 12)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerVirtualWorld(playerid, 1500);
			SetPlayerPos(playerid, hydraSpawnsType1[increment][0], hydraSpawnsType1[increment][1], hydraSpawnsType1[increment][2]);
			Event_PlayerVeh[playerid] = CreateVehicle(520, hydraSpawnsType1[increment][0], hydraSpawnsType1[increment][1], hydraSpawnsType1[increment][2], hydraSpawnsType1[increment][3], -1, -1, 15);
			SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 1500);
			SetPlayerArmour(playerid, 0);
			SetPlayerHealth(playerid, 99);
			ResetPlayerWeapons(playerid);
			PutPlayerInVehicle(playerid, Event_PlayerVeh[playerid], 0);
			GameTextForPlayer(playerid, "~R~~n~~n~ HYDRA ~n~ WARS", 1500, 3);
			Iter_Add(Event_Players, playerid);
			TogglePlayerControllable(playerid, 0);
			increment++;
		}
		case 4:
		{
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerArmour(playerid, 0);
			SetPlayerHealth(playerid, 99);
			SetPlayerVirtualWorld(playerid, 1500);
			SetPlayerInterior(playerid, 5);
			new randomnum = random(25);
			SetPlayerPos(playerid, MadDogSpawns[randomnum][0], MadDogSpawns[randomnum][1], MadDogSpawns[randomnum][2]);
			SetPlayerFacingAngle(playerid, MadDogSpawns[randomnum][3]);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, MadDogsWeapon, 500);
			GameTextForPlayer(playerid, "~R~~n~~n~ Mad ~h~ Dogs!", 800, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 5:
		{
			if(Iter_Count(Event_Players) == 30)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerArmour(playerid, 99);
			SetPlayerHealth(playerid, 99);
			SetPlayerVirtualWorld(playerid, 1500);
			SetPlayerInterior(playerid, 15);
			if(Motel_Team == 0)
			{
				new randomnum = increment;
				SetPVarInt(playerid, "MotelTeamIssued", 1);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 285);
				SetPlayerColor(playerid, COLOR_BLUE);
				SetPlayerPos(playerid, motelSpawnsType1[randomnum][0], motelSpawnsType1[randomnum][1], motelSpawnsType1[randomnum][2]);
				SetPlayerFacingAngle(playerid, motelSpawnsType1[randomnum][3]);
				Motel_Team = 1;
				increment++;
			}
			else
			{
				new randomnum = increment2;
				SetPVarInt(playerid, "MotelTeamIssued", 2);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 50);
				SetPlayerColor(playerid, COLOR_RED);
				SetPlayerPos(playerid, motelSpawnsType2[randomnum][0], motelSpawnsType2[randomnum][1], motelSpawnsType2[randomnum][2]);
				SetPlayerFacingAngle(playerid, motelSpawnsType2[randomnum][3]);
				Motel_Team = 0;
				increment2++;
			}
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 31, 500);
			GameTextForPlayer(playerid, "~R~~n~~n~ Motel ~h~ TDM!~n~~n~ ~w~You are now in the queue", 4000, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 6:
		{
			if(Iter_Count(Event_Players) == 20)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerArmour(playerid, 99);
			SetPlayerHealth(playerid, 99);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			if(Motel_Team == 0)
			{
				new randomnum = increment;
				SetPVarInt(playerid, "MotelTeamIssued", 1);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 287);
				SetPlayerColor(playerid, COLOR_BLUE);
				SetPlayerPos(playerid, armySpawnsType1[randomnum][0], armySpawnsType1[randomnum][1], armySpawnsType1[randomnum][2]);
				SetPlayerFacingAngle(playerid, armySpawnsType1[randomnum][3]);
				Motel_Team = 1;
				increment++;
			}
			else
			{
				new randomnum = increment2;
				SetPVarInt(playerid, "MotelTeamIssued", 2);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 73);
				SetPlayerColor(playerid, COLOR_RED);
				SetPlayerPos(playerid, armySpawnsType2[randomnum][0], armySpawnsType2[randomnum][1], armySpawnsType2[randomnum][2]);
				SetPlayerFacingAngle(playerid, armySpawnsType2[randomnum][3]);
				Motel_Team = 0;
				increment2++;
			}
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 31, 750);
			GivePlayerWeapon(playerid, 34, 50);
			GameTextForPlayer(playerid, "~R~~n~~n~ Army vs. Terrorists ~h~ TDM!~n~~n~ ~w~You are now in the queue", 4000, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 7:
		{
			if(Iter_Count(Event_Players) == 17)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerVirtualWorld(playerid, 1500);
			SetPlayerPos(playerid, minigunSpawnsType1[increment][0], minigunSpawnsType1[increment][1], minigunSpawnsType1[increment][2]);
			SetPlayerFacingAngle(playerid, minigunSpawnsType1[increment][3]);
			SetPlayerArmour(playerid, 99);
			SetPlayerHealth(playerid, 99);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 38, 3000);
			GameTextForPlayer(playerid, "~R~~n~~n~ MINIGUN ~n~ WARS", 1500, 3);
			Iter_Add(Event_Players, playerid);
			TogglePlayerControllable(playerid, 0);
			increment++;
		}
		case 8:
		{
			if(Iter_Count(Event_Players) == 30)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerArmour(playerid, 99);
			SetPlayerHealth(playerid, 99);
			SetPlayerVirtualWorld(playerid, 1500);
			SetPlayerInterior(playerid, 0);
			if(Motel_Team == 0)
			{
				new randomnum = increment;
				SetPVarInt(playerid, "MotelTeamIssued", 1);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 285);
				SetPlayerColor(playerid, COLOR_BLUE);
				SetPlayerPos(playerid, drugSpawnsType1[randomnum][0], drugSpawnsType1[randomnum][1], drugSpawnsType1[randomnum][2]);
				SetPlayerFacingAngle(playerid, drugSpawnsType1[randomnum][3]);
				SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the checkpoint, don't let a drug runner enter ...");
				SendClientMessage(playerid, COLOR_GREEN, ".. it else they will win, you will win by eliminating there team..");
				Motel_Team = 1;
				increment++;
			}
			else
			{
				new randomnum = increment2;
				SetPVarInt(playerid, "MotelTeamIssued", 2);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 21);
				SetPlayerColor(playerid, COLOR_RED);
				SetPlayerPos(playerid, drugSpawnsType2[randomnum][0], drugSpawnsType2[randomnum][1], drugSpawnsType2[randomnum][2]);
				SetPlayerFacingAngle(playerid, drugSpawnsType2[randomnum][3]);
				SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the checkpoint, don't let the SWAT team ...");
				SendClientMessage(playerid, COLOR_GREEN, ".. kill you else you will lose. Your team MUST drop off the package..");
				Motel_Team = 0;
				increment2++;
			}
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 31, 500);
			GameTextForPlayer(playerid, "~R~~n~~n~ Team Drug ~h~ Run!~n~~n~ ~w~You are now in the queue", 4000, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 9:
		{
			if(Iter_Count(Event_Players) == 11)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
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
				new c1, c2, c3, c4, c5, c6, c7, c8, c9, c10;
				sscanf(DrugEventVehicles, "iiiiiiiiii", c1, c2, c3, c4, c5, c6, c7, c8, c9, c10);
				switch(increment)
				{
					case 0: { PutPlayerInVehicle(playerid, c1, 0); LastVehicle[playerid] = c1; }
					case 1: { PutPlayerInVehicle(playerid, c2, 0); LastVehicle[playerid] = c2; }
					case 2: { PutPlayerInVehicle(playerid, c3, 0); LastVehicle[playerid] = c3; }
					case 3: { PutPlayerInVehicle(playerid, c4, 0); LastVehicle[playerid] = c4; }
					case 4: { PutPlayerInVehicle(playerid, c5, 0); LastVehicle[playerid] = c5; }
					case 5: { PutPlayerInVehicle(playerid, c6, 0); LastVehicle[playerid] = c6; }
					case 6: { PutPlayerInVehicle(playerid, c7, 0); LastVehicle[playerid] = c7; }
					case 7: { PutPlayerInVehicle(playerid, c8, 0); LastVehicle[playerid] = c8; }
					case 8: { PutPlayerInVehicle(playerid, c9, 0); LastVehicle[playerid] = c9; }
					case 9: { PutPlayerInVehicle(playerid, c10, 0); LastVehicle[playerid] = c10; }
				}
				SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Take out the criminal car at all costs ...");
				if(FoCo_Criminal != INVALID_PLAYER_ID)
				{
					SetPlayerMarkerForPlayer( playerid, FoCo_Criminal, 0xFFFFFF00);
				}
				increment++;
			}
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 31, 500);
			GameTextForPlayer(playerid, "~R~~n~~n~ Pursuit ~h~ ~n~~n~ ~w~You are now in the queue", 4000, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 10:
		{
			if(Iter_Count(Event_Players) == 30)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerArmour(playerid, 99);
			SetPlayerHealth(playerid, 99);
			SetPlayerVirtualWorld(playerid, 1500);
			SetPlayerInterior(playerid, 0);
			if(Motel_Team == 0)
			{
				new randomnum = increment;
				SetPVarInt(playerid, "MotelTeamIssued", 1);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 287);
				SetPlayerColor(playerid, COLOR_BLUE);
				SetPlayerPos(playerid, area51SpawnsAF[randomnum][0], area51SpawnsAF[randomnum][1], area51SpawnsAF[randomnum][2]);
				SetPlayerFacingAngle(playerid, area51SpawnsAF[randomnum][3]);
				Motel_Team = 1;
				increment++;
			}
			else
			{
				new randomnum = increment2;
				SetPVarInt(playerid, "MotelTeamIssued", 2);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 70);
				SetPlayerColor(playerid, COLOR_RED);
				SetPlayerPos(playerid, area51SpawnsCrim[randomnum][0], area51SpawnsCrim[randomnum][1], area51SpawnsCrim[randomnum][2]);
				SetPlayerFacingAngle(playerid, area51SpawnsCrim[randomnum][3]);
				Motel_Team = 0;
				increment2++;
			}
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 27, 500);
			GivePlayerWeapon(playerid, 31, 500);
			GameTextForPlayer(playerid, "~R~~n~~n~ Area 51 ~h~ TDM!~n~~n~ ~w~You are now in the queue", 4000, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 11:
		{
			if(Iter_Count(Event_Players) == 30)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerArmour(playerid, 99);
			SetPlayerHealth(playerid, 99);
			SetPlayerVirtualWorld(playerid, 1500);
			SetPlayerInterior(playerid, 0);
			if(Motel_Team == 0)
			{
				new randomnum = increment;
				SetPVarInt(playerid, "MotelTeamIssued", 1);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 287);
				SetPlayerColor(playerid, COLOR_BLUE);
				SetPlayerPos(playerid, navySealsBoat[randomnum][0], navySealsBoat[randomnum][1], navySealsBoat[randomnum][2]);
				SetPlayerFacingAngle(playerid, navySealsBoat[randomnum][3]);
				Motel_Team = 1;
				increment++;
				SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the boat in the checkpoint and eliminate all terrorist activity.");
			}
			else
			{
				new randomnum = increment2;
				SetPVarInt(playerid, "MotelTeamIssued", 2);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 221);
				SetPlayerColor(playerid, COLOR_RED);
				SetPlayerPos(playerid, terroristsBoat[randomnum][0], terroristsBoat[randomnum][1], terroristsBoat[randomnum][2]);
				SetPlayerFacingAngle(playerid, terroristsBoat[randomnum][3]);
				Motel_Team = 0;
				increment2++;
				SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the boat at all costs ...");
			}
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 27, 500);
			GivePlayerWeapon(playerid, 31, 500);
			DisablePlayerCheckpoint(playerid);
			GameTextForPlayer(playerid, "~R~~n~~n~ Navy Seals Vs. Terrorists ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 12:
		{
			if(Iter_Count(Event_Players) == 30)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerArmour(playerid, 99);
			SetPlayerHealth(playerid, 99);
			SetPlayerVirtualWorld(playerid, 1500);
			SetPlayerInterior(playerid, 0);
			if(Motel_Team == 0)
			{
				new randomnum = increment;
				SetPVarInt(playerid, "MotelTeamIssued", 1);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 287);
				SetPlayerColor(playerid, COLOR_BLUE);
				SetPlayerPos(playerid, swatoilrigspawns1[randomnum][0], swatoilrigspawns1[randomnum][1], swatoilrigspawns1[randomnum][2] + 4);
				SetPlayerFacingAngle(playerid, swatoilrigspawns1[randomnum][3]);
				Motel_Team = 1;
				increment++;
				SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the Oil Rig.");
			}
			else
			{
				new randomnum = increment2;
				SetPVarInt(playerid, "MotelTeamIssued", 2);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 221);
				SetPlayerColor(playerid, COLOR_RED);
				SetPlayerPos(playerid, terroristoilrigspawns1[randomnum][0], terroristoilrigspawns1[randomnum][1], terroristoilrigspawns1[randomnum][2]);
				SetPlayerFacingAngle(playerid, terroristoilrigspawns1[randomnum][3]);
				Motel_Team = 0;
				increment2++;
				SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the Oil Rig ...");
			}
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 27, 500);
			GivePlayerWeapon(playerid, 31, 500);
			DisablePlayerCheckpoint(playerid);
			GameTextForPlayer(playerid, "~R~~n~~n~ Oil Rig Terrorists ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 13:
		{
			if(Iter_Count(Event_Players) == 30)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerArmour(playerid, 99);
			SetPlayerHealth(playerid, 99);
			SetPlayerVirtualWorld(playerid, 1500);
			SetPlayerInterior(playerid, 0);
			if(Motel_Team == 0)
			{
				new randomnum = increment;
				SetPVarInt(playerid, "MotelTeamIssued", 1);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 287);
				SetPlayerColor(playerid, COLOR_BLUE);
				SetPlayerPos(playerid, swatcompoundattack[randomnum][0], swatcompoundattack[randomnum][1], swatcompoundattack[randomnum][2]);
				SetPlayerFacingAngle(playerid, swatcompoundattack[randomnum][3]);
				Motel_Team = 1;
				increment++;
				SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the Compound.");
			}
			else
			{
				new randomnum = increment2;
				SetPVarInt(playerid, "MotelTeamIssued", 2);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 221);
				SetPlayerColor(playerid, COLOR_RED);
				SetPlayerPos(playerid, terroristcoumpoundattack[randomnum][0], terroristcoumpoundattack[randomnum][1], terroristcoumpoundattack[randomnum][2]);
				SetPlayerFacingAngle(playerid, terroristcoumpoundattack[randomnum][3]);
				Motel_Team = 0;
				increment2++;
				SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the Compound ...");
			}
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 27, 500);
			GivePlayerWeapon(playerid, 31, 500);
			DisablePlayerCheckpoint(playerid);
			GameTextForPlayer(playerid, "~R~~n~~n~ Compound Attack ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 14:
		{
			if(Iter_Count(Event_Players) == 30)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerArmour(playerid, 0);
			SetPlayerHealth(playerid, 99);
			SetPlayerVirtualWorld(playerid, 1500);
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, GunGameSpawns[increment+5][0], GunGameSpawns[increment+5][1], GunGameSpawns[increment+5][2]);
			SetPlayerFacingAngle(playerid, GunGameSpawns[increment][3]);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, GunGameWeapons[0], 500);
			GameTextForPlayer(playerid, "~R~~n~~n~ Gun ~h~ Game!", 800, 3);
			Iter_Add(Event_Players, playerid);
			GunGameKills[playerid] = 0;
			lastGunGameWeapon[playerid] = 38;
			TextDrawShowForPlayer(playerid, CurrLeader[playerid]);
			TextDrawShowForPlayer(playerid, CurrLeaderName[playerid]);
			TextDrawShowForPlayer(playerid, GunGame_MyKills[playerid]);
			TextDrawShowForPlayer(playerid, GunGame_Weapon[playerid]);

			new tmpStr[30];
			format(tmpStr, sizeof(tmpStr), "%s", WeapNames[0]);
			TextDrawSetString(GunGame_Weapon[playerid], tmpStr);
			format(tmpStr, sizeof(tmpStr), "(%d / 16)", GunGameKills[playerid]);
			TextDrawSetString(GunGame_MyKills[playerid], tmpStr);
			TextDrawSetString(CurrLeaderName[playerid], "No Kills");

			increment++;
		}
		case 15:
		{
			if(CEM[MaxPlayers] > CEM_Players)
			{
				if(GetPVarInt(playerid,"PlayerStatus") == 0 && GetPlayerVirtualWorld(playerid) != 1500)
				{
					SetPVarInt(playerid,"PlayerStatus",1);
					GameTextForPlayer(playerid, "~R~~n~~n~Custom ~h~ Event", 800, 3);
					Iter_Add(Event_Players, playerid);
					if(CEM[Gamemode] == 1) CEM_Players = 0;
					else CEM_Players ++;
					JoinCEM(playerid);
					PlayerColor[playerid] = GetPlayerColor(playerid);//because color is over 255 i guess
					PlayerTeamID{playerid} = GetPlayerTeam(playerid);
					PlayerSkinID[playerid] = GetPlayerSkin(playerid);// because skins get over 255
					if(CEM[Gamemode] != 1) TogglePlayerControllable(playerid,0);
					if(CEM[Gamemode] != 1) SendClientMessage(playerid, COLOR_GREEN, "You're frozen now, wait until the event starts.");
				}
				else SendClientMessage(playerid, COLOR_NOTICE, "Cant re-join the event");
			}
			else SendClientMessage(playerid, COLOR_NOTICE, "Event is full.");
		}
	}
	return 1;
}

CMD:leaveevent(playerid, params[])
{
	if(FoCo_Event != -1 && GetPVarInt(playerid, "PlayerStatus") == 1)
	{
		new Float:Health;
		GetPlayerHealth(playerid, Health);
		if(Health < 75.0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot leave an event without more than 75 health.");
			return 1;
		}
		SetPVarInt(playerid, "FellOffEvent", 1);
		PlayerLeftEvent(playerid);
		SetPVarInt(playerid, "MotelTeamIssued", 0);
		if(GetPVarInt(playerid, "MotelSkin") > 0)
		{
			SetPlayerSkin(playerid, GetPVarInt(playerid, "MotelSkin"));
			SetPlayerColor(playerid, GetPVarInt(playerid, "MotelColor"));
		}
		TogglePlayerControllable(playerid, 1);
		if(FoCo_Event == 14)
		{
			TextDrawHideForPlayer(playerid, CurrLeader[playerid]);
			TextDrawHideForPlayer(playerid, CurrLeaderName[playerid]);
			TextDrawHideForPlayer(playerid, GunGame_MyKills[playerid]);
			TextDrawHideForPlayer(playerid, GunGame_Weapon[playerid]);
			GunGameKills[playerid] = 0;
		}
		if(FoCo_Event == 15)
		{
			leavecevent(playerid);
			SetPlayerHealth(playerid,99);
			CEM_Players = CEM_Players - 1;
			if(CEM_Players == 0)clearevent();
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not at an event, thereofe cannot leave.");
	}
	return 1;
}












/*
NOTES:
- TEST GUN GAME TD (%d / 16)
- TEST PURSUIT
*/
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
* Filename:  eventsystem.pwn                                                     *
* Author:    Marcel                                                              *
*********************************************************************************/

//===============================[ADDON-FILES]==================================
//#include                        "../ftdm/Dev/events/subfiles/chilco_ctf.pwn"


//===============================[VARIABLES]====================================
/*
NOTE:
PlayerStatus - 0 normal, 1 in event, 2 Duel, 3 AFK
*/
new PursuitCars[128];						// This is the variable where the vehicles are being stored for the drug event on creation.
new E_Pursuit_Criminal;							// This stores the carID of the criminals vehicle.
new ManHuntID = -1;								// This stores the userID of who is currently the ManHunt target.
new ManHuntFail;								// This stores the amount of times manhunt has failed to set a target, due to it selecting online admins or false players.
new ManHuntTwenty;								// This is used for manhunt in the TenMinuteTimer(). It will be ++'d then when it hits 2, it will be reset to 0 and manhunt will begin.
new ManHuntSeconds; 							// This stores the UNIX timestamp of the player, when he is assigned manhunt.
new Motel_Team = 0;								// When set to 0 assigns a player to Team 1, when set to 1, assigns a player to Team 2.
new Team1_Motel = 0;							// This is used for storing the amount of players on team 1, in different events. (Not just MOTEL event!!)
new increment2 = 0;								// This is an incrimental value used when people type /join for deciding which team the user will go on.
new Team2_Motel = 0; 							// This is used for storing the amount of players on team 2, in different events. (Not just MOTEL event!!)
new MadDogsWeapon;								// This will store the weapon used in the mad dogs event.
new FoCo_Event = -1;							// This will store the current event that is running.
new FoCo_Event_Rejoin;							// This will store whether you can or cannot rejoin Mad Dogs.
new FoCo_Event_Died[MAX_PLAYERS];				// This stores if you died in an  event or not recently, used for the re joining if death is disabled.
new Event_Delay;								// this stores the timer for the delay after /event start has been selected.
new Event_InProgress;							// This stores 1 or 0 depending on whether the event is running or not.
new Event_PlayerVeh[MAX_PLAYERS] = -1;			// This stores the vehicle ID of the players car during SUMO events.
new Sumo_Type;									// Chooses which SUMO you have began.
new PlayerPursuitTimer[MAX_PLAYERS];			// Stores the timer for the puruist event;
new FoCo_Criminal = -1;							// Stores the criminal id for the pursuit
new GunGameKills[MAX_PLAYERS];
new lastKillReason[MAX_PLAYERS];
new spawnSeconds[MAX_PLAYERS] = -1;
new lastGunGameWeapon[MAX_PLAYERS] = 38;

#define MAX_EVENTS 10
enum events
{
	eventID,
	eventName[30]
};

#define EVENT_LIST "0:Bigsmoke\n1:Sumo\n2:Mad Dogs Mansion\n3:Jefferson Motel Team DM\n4:Minigun Wars\n5:Pursuit\n6:Area 51 DM\n7:Compound Attack\n8:GunGame"

new const event_IRC_Array[MAX_EVENTS][ events ] = {
	{0, "Bigsmoke"},
	{1, "SUMO"},
	{2, "Mad Dogs Mansion"},
	{3, "Jefferson Motel"},
	{4, "Minigun Wars"},
	{5, "Pursuit"},
	{6, "Area 51 DM"},
	{7, "Compound Attack"},
	{8, "Gun Game"},
	{9, "Custom Event"}
};

//===============================[FUNCTIONS]====================================
forward PlayerLeftEvent(playerid);
public PlayerLeftEvent(playerid)
{
	SetPlayerHealth(playerid, 99);
	if(GetPVarInt(playerid, "PlayerStatus") == 0)
	{
		return 1;
	}
	new winner, msg[71];
	FoCo_Event_Died[playerid]++;
	death[playerid] = 1;
	Iter_Remove(Event_Players, playerid);
	switch(FoCo_Event)
	{
		case 3:
		{
			if(GetPlayerSkin(playerid) == 285)
			{
				Team2_Motel++;
			}
			else if(GetPlayerSkin(playerid) == 50)
			{
				Team1_Motel++;
			}
			format(msg, sizeof(msg), "[EVENT SCORE]: S.W.A.T %d - %d Criminals", Team1_Motel, Team2_Motel);
			SendClientMessageToAll(COLOR_NOTICE, msg);
		}
		case 6:
		{
			if(GetPlayerSkin(playerid) == 70)
			{
				Team1_Motel++;
			}
			else if(GetPlayerSkin(playerid) == 287)
			{
				Team2_Motel++;
			}
			format(msg, sizeof(msg), "[EVENT SCORE]: US Special Forces %d - %d Nuclear Scientists", Team1_Motel, Team2_Motel);
			SendClientMessageToAll(COLOR_NOTICE, msg);
		}
		case 7:
		{
			if(GetPlayerSkin(playerid) == 221)
			{
				Team1_Motel++;
			}
			else if(GetPlayerSkin(playerid) == 287)
			{
				Team2_Motel++;
			}
			format(msg, sizeof(msg), "[EVENT SCORE]: SWAT %d - %d Terrorists", Team1_Motel, Team2_Motel);
			SendClientMessageToAll(COLOR_NOTICE, msg);
		}
	}
	if(GetPVarInt(playerid, "FellOffEvent") == 1)
	{
		death[playerid] = 0;
		SetPlayerPos(playerid, FoCo_Teams[FoCo_Team[playerid]][team_spawn_x], FoCo_Teams[FoCo_Team[playerid]][team_spawn_y], FoCo_Teams[FoCo_Team[playerid]][team_spawn_z]);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, FoCo_Teams[FoCo_Team[playerid]][team_spawn_interior]);
		GiveGuns(playerid);
		SetPVarInt(playerid, "FellOffEvent", 0);
	}
	switch(FoCo_Event)
	{
		case 1:
		{
			SetPVarInt(playerid, "LeftEventJust", 1);
			if(Iter_Count(Event_Players) == 1)
			{
				winner = Iter_Random(Event_Players);
				format(msg, sizeof(msg), "				%s has won the Sumo event!", PlayerName(winner));
				SendClientMessageToAll(COLOR_NOTICE, msg);
				SendClientMessage(winner, COLOR_NOTICE, "You have won Sumo event! You have earnt 10 score!");
				FoCo_Player[winner][score] = FoCo_Player[winner][score] + 10;
				lastEventWon = winner;
				EndEvent();
			}
		}
		case 3:
		{
			SetPVarInt(playerid, "MotelTeamIssued", 0);
			new t1, t2;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(GetPVarInt(i, "MotelTeamIssued") == 1)
					{
						t1++;
					}
					else if(GetPVarInt(i, "MotelTeamIssued") == 2)
					{
						t2++;
					}
				}
			}
			if(t1 == 0)
			{
				EndEvent();
				increment = 0;
				increment2 = 0;
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: Criminals have won the event!");
				return 1;
			}
			else if(t2 == 0)
			{
				EndEvent();
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: S.W.A.T have won the event!");
				increment = 0;
				increment2 = 0;
				return 1;
			}
			if(Iter_Count(Event_Players) == 1)
			{
				EndEvent();

			}
		}
		case 4:
		{
			SetPVarInt(playerid, "LeftEventJust", 1);
			if(Iter_Count(Event_Players) == 1)
			{
				winner = Iter_Random(Event_Players);
				format(msg, sizeof(msg), "				%s has won the Minigun Wars event!", PlayerName(winner));
				SendClientMessageToAll(COLOR_NOTICE, msg);
				SendClientMessage(winner, COLOR_NOTICE, "You have won the Minigun Wars event! You have earnt 10 score!");
				FoCo_Player[winner][score] = FoCo_Player[winner][score] + 10;
				lastEventWon = winner;
				EndEvent();
			}
		}
		case 5:
		{
			if(GetPVarInt(playerid, "MotelTeamIssued") == 1)
			{
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the criminal being caught!");
				EndEvent();
				return 1;
			}

			new team_issue;
			foreach(Player, i)
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
		case 6:
		{
			SetPVarInt(playerid, "MotelTeamIssued", 0);
			new t1, t2;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(GetPVarInt(i, "MotelTeamIssued") == 1)
					{
						t1++;
					}
					else if(GetPVarInt(i, "MotelTeamIssued") == 2)
					{
						t2++;
					}
				}
			}
			if(t1 == 0)
			{
				EndEvent();
				increment = 0;
				increment2 = 0;
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Nuclear Scientists have won the event!");
				return 1;
			}
			else if(t2 == 0)
			{
				EndEvent();
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The US Special Forces have won the event!");
				increment = 0;
				increment2 = 0;
				return 1;
			}
			if(Iter_Count(Event_Players) == 1)
			{
				EndEvent();

			}
		}
		case 7:
		{
			SetPVarInt(playerid, "MotelTeamIssued", 0);
			new t1, t2;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(GetPVarInt(i, "MotelTeamIssued") == 1)
					{
						t1++;
					}
					else if(GetPVarInt(i, "MotelTeamIssued") == 2)
					{
						t2++;
					}
				}
			}
			if(t1 == 0)
			{
				EndEvent();
				increment = 0;
				increment2 = 0;
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Terrorists have won the event!");
				return 1;
			}
			else if(t2 == 0)
			{
				EndEvent();
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: SWAT have won the event!");
				increment = 0;
				increment2 = 0;
				return 1;
			}
			if(Iter_Count(Event_Players) == 1)
			{
				EndEvent();

			}
		}
	}
	SetPVarInt(playerid,"PlayerStatus",0);
	return 1;
}

forward EndEvent();
public EndEvent()
{
	if(FoCo_Event == 8)
	{
		foreach(Player, i)
		{
			TextDrawHideForPlayer(i, CurrLeader[i]);
			TextDrawHideForPlayer(i, CurrLeaderName[i]);
			TextDrawHideForPlayer(i, GunGame_MyKills[i]);
			TextDrawHideForPlayer(i, GunGame_Weapon[i]);
			GunGameKills[i] = 0;
		}
	}
	foreach(Player, i)
	{
		if(GetPVarInt(i, "PlayerStatus") == 1 && death[i] == 0)
		{
			if(FoCo_Event == 3 || FoCo_Event == 6 || FoCo_Event == 7)
			{
				SetPVarInt(i, "MotelTeamIssued", 0);
				SetPlayerSkin(i, GetPVarInt(i, "MotelSkin"));
				SetPlayerColor(i, GetPVarInt(i, "MotelColor"));
				SetPlayerArmour(i, 0);
			}

			if(Event_PlayerVeh[i] != -1)
			{
				DestroyVehicle(Event_PlayerVeh[i]);
				Event_PlayerVeh[i] = -1;
			}

			if(FoCo_Event == 5)
			{
				SetPlayerMarkerForPlayer( i, FoCo_Criminal, GetPVarInt(FoCo_Criminal, "MotelColor"));
				if(PlayerPursuitTimer[i])
				{
					KillTimer(PlayerPursuitTimer[i]);
				}
			}

			SetPlayerPos(i, FoCo_Teams[FoCo_Team[i]][team_spawn_x], FoCo_Teams[FoCo_Team[i]][team_spawn_y], FoCo_Teams[FoCo_Team[i]][team_spawn_z]);
			SetPlayerVirtualWorld(i, 0);
			SetPlayerInterior(i, FoCo_Teams[FoCo_Team[i]][team_spawn_interior]);
			increment = 0;
			increment2 = 0;
			Motel_Team = 0;
			ResetPlayerWeapons(i);
			GiveGuns(i);
			TogglePlayerControllable(i, 1);
		}
	}
	
	if(FoCo_Event == 5)
	{
		Motel_Team = 0;
		new c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11;
		sscanf(PursuitCars, "iiiiiiiiiii", c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11);
		DestroyVehicle(c1); DestroyVehicle(c2); DestroyVehicle(c3); DestroyVehicle(c4); DestroyVehicle(c5); DestroyVehicle(c6);
		DestroyVehicle(c7); DestroyVehicle(c8); DestroyVehicle(c9); DestroyVehicle(c10); DestroyVehicle(c11);
		format(PursuitCars, strlen(PursuitCars), " ");
	}

	if(lastEventWon != -1)
	{
		EventGift(lastEventWon);
		lastEventWon = -1;
	}
	if(FoCo_Event == 3 || FoCo_Event == 6 || FoCo_Event == 7)
	{
		Team1_Motel = 0;
		Team2_Motel = 0;
	}
	
	if(FoCo_Event == 9) clearevent();
	
	FoCo_Criminal = -1;
	FoCo_Event = -1;
	FoCo_Event_Rejoin = 0;
	if(Iter_Count(Event_Players) > 0)
	{
		Iter_Clear(Event_Players);
	}

	// Bodge Job fix for some errors (existing and new).
	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
		SetPVarInt(i, "PlayerStatus", 0);
	}
	increment = 0;
	return 1;
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

forward EventGift(playerid);
public EventGift(playerid)
{
	new ran = random(8);
	switch(ran)
	{
		case 0:
		{
			GivePlayerMoney(playerid, 1000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $1000");
		}
		case 1:
		{
			GivePlayerMoney(playerid, 4000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $4000");
		}
		case 2:
		{
			GivePlayerMoney(playerid, 10000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $10000");
		}
		case 3:
		{
			GivePlayerMoney(playerid, 20000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $20000");
		}
		case 4:
		{
			SetPlayerArmour(playerid, 99);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 100 armour");
		}
		case 5:
		{
			GivePlayerWeapon(playerid, 38, 100);
			new string[82];
			format(string, sizeof(string), "[NOTICE]: %s has won an event and won the random Minigun.", PlayerName(playerid));
			SendAdminMessage(1,string);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a minigun");
		}
		case 6:
		{
			FoCo_Playerstats[playerid][kills] = FoCo_Playerstats[playerid][kills] + 10;
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 10 extra kills");
		}
		case 7:
		{
			FoCo_Playerstats[playerid][deaths] = FoCo_Playerstats[playerid][deaths] - 10;
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 10 less deaths");
		}
		case 8:
		{
			GivePlayerMoney(playerid, 50000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $50000");
		}
	}
	return 1;
}

forward Random_Pursuit_Vehicle();
public Random_Pursuit_Vehicle()
{
	new randVeh, vehicle;
	randVeh = random(8);
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
	}
	return vehicle;
}
//===============================[CALLBACKS]====================================
forward Event_OnGameModeInit();
public Event_OnGameModeInit()
{
//	Dev_Chilco_ctf_OnGameModeInit();
	return 1;
}

forward Event_OnGameModeExit();
public Event_OnGameModeExit()
{
	return 1;
}

forward Event_OnPlayerRequestClass(playerid, classid);
public Event_OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

forward Event_OnPlayerConnect(playerid);
public Event_OnPlayerConnect(playerid)
{
    SetPVarInt(playerid,"PlayerStatus",0);
	return 1;
}

forward Event_OnPlayerDisconnect(playerid, reason);
public Event_OnPlayerDisconnect(playerid, reason)
{
	if(Event_PlayerVeh[playerid] != -1)
	{
		DestroyVehicle(Event_PlayerVeh[playerid]);
		Event_PlayerVeh[playerid] = -1;
	}
	if(FoCo_Event != -1)
	{
		if(GetPVarInt(playerid, "PlayerStatus") == 1)
		{
			if(PlayerPursuitTimer[playerid])
			{
				KillTimer(PlayerPursuitTimer[playerid]);
			}
			PlayerLeftEvent(playerid);
		}
	}
	return 1;
}

forward Event_OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid);
public Event_OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
	return 1;
}

forward Event_OnPlayerSpawn(playerid);
public Event_OnPlayerSpawn(playerid)
{
	if(GetPVarInt(playerid, "PlayerStatus") == 1 && FoCo_Event == 8)
	{
		SetPlayerArmour(playerid, 0);
		SetPlayerHealth(playerid, 99);
		SetPlayerVirtualWorld(playerid, 1500);
		SetPlayerInterior(playerid, 0);
		new randomnum = random(250);
		SetPlayerPos(playerid, GunGameSpawns[randomnum][0], GunGameSpawns[randomnum][1], GunGameSpawns[randomnum][2]);
		SetPlayerFacingAngle(playerid, GunGameSpawns[randomnum][3]);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, GunGameWeapons[GunGameKills[playerid]], 500);
		GameTextForPlayer(playerid, "~R~~n~~n~ Gun ~h~ Game!", 800, 3);
	}
	if(Event_PlayerVeh[playerid] != -1)
	{
		DestroyVehicle(Event_PlayerVeh[playerid]);
		Event_PlayerVeh[playerid] = -1;
	}
	return 1;
}

forward Event_PickUpDynamicPickup(playerid, pickupid);
public Event_PickUpDynamicPickup(playerid, pickupid)
{
	return 1;
}

forward Event_OnPlayerDeath(playerid, killerid, reason);
public Event_OnPlayerDeath(playerid, killerid, reason)
{
//	Dev_Chilco_ctf_OnPlayerDeath(playerid, killerid, reason);
	if(FoCo_Event != -1)
	{
		if(GetPVarInt(playerid, "PlayerStatus") == 1)
		{
			if(PlayerPursuitTimer[playerid])
			{
				KillTimer(PlayerPursuitTimer[playerid]);
			}
			if(FoCo_Event != 8)
			{
				PlayerLeftEvent(playerid);
			}
			if(FoCo_Event == 1)
			{
				SpawnPlayer(playerid);
				return 1;
			}
			if(FoCo_Event == 8)
			{
				if(killerid != INVALID_PLAYER_ID && GetPVarInt(killerid, "PlayerStatus") == 1 && lastGunGameWeapon[killerid] != reason)
				{
					//PlayerLeftEvent(playerid);
					GunGameKills[killerid]++;
					ResetPlayerWeapons(killerid);
					GivePlayerWeapon(killerid, GunGameWeapons[GunGameKills[killerid]], 500);
					lastGunGameWeapon[killerid] = GunGameWeapons[GunGameKills[killerid]-1];
					new tmpString[63];
					format(tmpString, sizeof(tmpString), "(%d / 16)", GunGameKills[killerid]);
					TextDrawSetString(GunGame_MyKills[killerid], tmpString);

					new varHigh = 0;
					foreach(Player, i)
					{
						if(GetPVarInt(playerid, "PlayerStatus") == 1)
						{
							if(GunGameKills[killerid] < GunGameKills[i])
							{
								varHigh = 1;
							}
						}
					}

					if(varHigh == 0)
					{
						format(tmpString, sizeof(tmpString), "%s (%d / 16)", PlayerName(killerid), GunGameKills[killerid]);
						foreach(Player, i)
						{
							if(GetPVarInt(playerid, "PlayerStatus") == 1)
							{
								TextDrawSetString(CurrLeaderName[i], tmpString);
							}
						}
					}

					if(GunGameKills[killerid] >= 17)
					{
						format(tmpString, sizeof(tmpString), "[Event Notice]: %s has won the Gun Game.", PlayerName(killerid));
						SendClientMessageToAll(COLOR_NOTICE, tmpString);
						lastEventWon = killerid;
						EndEvent();
					}
				}
			}
		}
	}
	return 1;
}

forward Event_OnVehicleSpawn(vehicleid);
public Event_OnVehicleSpawn(vehicleid)
{
	return 1;
}

forward Event_OnVehicleDeath(vehicleid, killerid);
public Event_OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

forward Event_OnPlayerText(playerid, text[]);
public Event_OnPlayerText(playerid, text[])
{
	return 1;
}

forward Event_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
public Event_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

forward Event_OnPlayerExitVehicle(playerid, vehicleid);
public Event_OnPlayerExitVehicle(playerid, vehicleid)
{
    if(vehicleid == Event_PlayerVeh[playerid])
	{
		switch(FoCo_Event)
		{
			case 1:
			{
				if(FoCo_Event != -1)
				{
					if(GetPVarInt(playerid, "PlayerStatus") == 1)
					{
						SetPVarInt(playerid, "FellOffEvent", 1);
						PlayerLeftEvent(playerid);
						SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: You have been removed from the event for leaving your vehicle.");
					}
				}
			}
		}
	}
	return 1;
}

forward Event_OnPlayerPrivmsg(playerid, recieverid, text[]);
public Event_OnPlayerPrivmsg(playerid, recieverid, text[])
{
	return 1;
}

forward Event_OnPlayerStateChange(playerid, newstate, oldstate);
public Event_OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

forward Event_OnPlayerLeaveCheckpoint(playerid);
public Event_OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

forward Event_OnPlayerRequestSpawn(playerid);
public Event_OnPlayerRequestSpawn(playerid)
{
	return 1;
}

forward Event_OnObjectMoved(objectid);
public Event_OnObjectMoved(objectid)
{
	return 1;
}

forward Event_OnPlayerUpdate(playerid);
public Event_OnPlayerUpdate(playerid)
{
	/*if(FoCo_Event == 8)     //Moved to Event_OneSecond
	{
		if(GetPVarInt(playerid, "PlayerStatus") == 1)
		{
			new tmpStr[30];
			format(tmpStr, sizeof(tmpStr), "%s", WeapNames[GetPlayerWeapon(playerid)]);
			TextDrawSetString(GunGame_Weapon[playerid], tmpStr);
		}
	}*/
	return 1;
}

forward Event_OnPlayerObjectMoved(playerid, objectid);
public Event_OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

forward Event_OnPlayerPickUpPickup(playerid, pickupid);
public Event_OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

forward Event_OnVehicleMod(playerid, vehicleid, componentid);
public Event_OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

forward Event_OnVehiclePaintjob(playerid, vehicleid, paintjobid);
public Event_OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

forward Event_OnVehicleRespray(playerid, vehicleid, color1, color2);
public Event_OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

forward Event_OnPlayerSelectedMenuRow(playerid, row);
public Event_OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

forward Event_OnPlayerExitedMenu(playerid);
public Event_OnPlayerExitedMenu(playerid)
{
	return 1;
}

forward Event_OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid);
public Event_OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

forward Event_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
public Event_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
//	Dev_Chilco_ctf_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    return 1;
}

forward Event_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
public Event_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new string[180];
//	Dev_Chilco_ctf_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
	switch(dialogid)
	{
	    case DIALOG_EVENTSTART:
		{
			if(!response) return 1;
			DialogOptionVar1[playerid] = listitem;
			switch(listitem)
			{
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_EVENTSTART2, DIALOG_STYLE_LIST, "Event Options", "1. Monster\n2. Banger\n3. Sandking\n4. Destruction Derby", "OK", "CLOSE");
					//ShowPlayerDialog(playerid, DIALOG_EVENTSTART2, DIALOG_STYLE_LIST, "Event Options", "1. Monster\n2. Banger\n3. Sandking\n4. Destruction Derby\n5. SandKing Reloaded.", "OK", "CLOSE");
					return 1;
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_EVENTSTART22, DIALOG_STYLE_INPUT, "Event Options", "Which weapon should be used?", "Confirm", "Close");
					return 1;
				}
				case 3:
				{
					new adname[56];
					GetPlayerName(playerid, adname, sizeof(adname));
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}

					FoCo_Event_Rejoin = 0;
					foreach(Player, i)
					{
						FoCo_Event_Died[i] = 0;
					}

					FoCo_Event = 3;
					format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Jefferson Motel Team DM {%06x}event.  Type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
					Event_Delay = 30;
					return 1;
				}
				case 4:
				{
					new adname[56];
					GetPlayerName(playerid, adname, sizeof(adname));
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}
					FoCo_Event = 4;
					format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Minigun Wars {%06x}event. 30 seconds before it starts, type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
					Event_Delay = 30;
					return 1;
				}
				case 5:
				{
					new adname[56];
					GetPlayerName(playerid, adname, sizeof(adname));
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}

					FoCo_Event_Rejoin = 0;
					foreach(Player, i)
					{
						FoCo_Event_Died[i] = 0;
					}

					increment = 0;
					FoCo_Event = 5;
					format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Pursuit {%06x}event.  Type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
					Event_Delay = 30;

					new car;
					for(new i = 0; i < 11; i++)
					{
						if(i == 10)
						{
							car = CreateVehicle(Random_Pursuit_Vehicle(), pursuitVehicles[i][0], pursuitVehicles[i][1], pursuitVehicles[i][2], pursuitVehicles[i][3], 1, 0, 600000);
							SetVehicleVirtualWorld(car, 1500);
							format(PursuitCars, sizeof(PursuitCars), "%s %d ", PursuitCars, car);
							E_Pursuit_Criminal = car;
						}
						else
						{
							car = CreateVehicle(596, pursuitVehicles[i][0], pursuitVehicles[i][1], pursuitVehicles[i][2], pursuitVehicles[i][3], 1, 0, 600000);
							SetVehicleVirtualWorld(car, 1500);
							format(PursuitCars, sizeof(PursuitCars), "%s %d ", PursuitCars, car);
						}
					}
					return 1;
				}
				case 6:
				{
					new adname[56];
					GetPlayerName(playerid, adname, sizeof(adname));
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}

					FoCo_Event_Rejoin = 0;
					foreach(Player, i)
					{
						FoCo_Event_Died[i] = 0;
					}

					FoCo_Event = 6;
					format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}United Special Forces vs. Nuclear Scientists Team DM {%06x}event.  Type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
					Event_Delay = 30;
					return 1;
				}
				case 7:
				{
					new adname[56];
					GetPlayerName(playerid, adname, sizeof(adname));
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}

					FoCo_Event_Rejoin = 0;
					foreach(Player, i)
					{
						FoCo_Event_Died[i] = 0;
					}

					FoCo_Event = 7;
					format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Compound Attack {%06x}event.  Type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
					Event_Delay = 30;
					return 1;
				}
			}
			ShowPlayerDialog(playerid, DIALOG_EVENTSTART2, DIALOG_STYLE_MSGBOX, "Event Rejoinable", "Should this event be rejoinable after death or not?", "Yes", "No");
			return 1;
		}
		case DIALOG_EVENTSTART22:
		{
			if(!response)
			{
				return 1;
			}

			if(strval(inputtext) > 39 || strval(inputtext) < 1) {
				SendClientMessage(playerid, COLOR_WARNING, "Invalid value");
				return 1;
			}

			MadDogsWeapon = strval(inputtext);
			ShowPlayerDialog(playerid, DIALOG_EVENTSTART2, DIALOG_STYLE_MSGBOX, "Event Rejoinable", "Should this event be rejoinable after death or not?", "Yes", "No");
			return 1;
		}
		case DIALOG_EVENTSTART2:
		{
			new adname[56];
			GetPlayerName(playerid, adname, sizeof(adname));
			if(response)
			{
				FoCo_Event_Rejoin = 1;
				foreach(Player, i)
				{
					FoCo_Event_Died[i] = 0;
				}
			}
			else
			{
				FoCo_Event_Rejoin = 0;
				foreach(Player, i)
				{
					FoCo_Event_Died[i] = 0;
				}
			}
			switch(DialogOptionVar1[playerid])
			{
				case 0:
				{
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}
					FoCo_Event = 0;
					format(string, sizeof(string), "[EVENT]: %s %s has started the Bigsmoke event.  Type /join!", GetPlayerStatus(playerid), adname);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
				}
				case 1:
				{
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}

					if(!response)
					{
						return 1;
					}

					switch(listitem)
					{
						case 0:
						{
							FoCo_Event = 1;
							Sumo_Type = 1;
							format(string, sizeof(string), "[EVENT]: %s %s has started the Monster Sumo event. 30 seconds before it starts, type /join! Map by {%06x}Rayoo.",GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8);
							SendClientMessageToAll(COLOR_CMDNOTICE, string);
							IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
							Event_InProgress = 0;
							Event_Delay = 30;
						}
						case 2:
						{
							FoCo_Event = 1;
							Sumo_Type = 2;
							format(string, sizeof(string), "[EVENT]: %s %s has started the SandKing Sumo event. 30 seconds before it starts, type /join! Map by {%06x}RakGuy.", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8);
							SendClientMessageToAll(COLOR_CMDNOTICE, string);
							IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
							Event_InProgress = 0;
							Event_Delay = 30;
						}
						case 3:
						{
							FoCo_Event = 1;
							Sumo_Type = 3;
							format(string, sizeof(string), "[EVENT]: %s %s has started the Destruction Derby event. 30 seconds before it starts, type /join! Map by {%06x}Hiro.", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8);
							SendClientMessageToAll(COLOR_CMDNOTICE, string);
							IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
							Event_InProgress = 0;
							Event_Delay = 30;

						}
						case 4:
						{
							FoCo_Event = 1;
							Sumo_Type = 4;
							format(string, sizeof(string), "[EVENT]: %s %s has started the SandKing Sumo Reloaded event. 30 seconds before it starts, type /join! Map by {%06x}RakGuy.", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8);
							SendClientMessageToAll(COLOR_CMDNOTICE, string);
							IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
							Event_InProgress = 0;
							Event_Delay = 30;
						}
					}
					return 1;
				}
				case 3:
				{
					if(response)
					{
						if(FoCo_Event != -1)
						{
							SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
							return 1;
						}
						FoCo_Event = 3;
						format(string, sizeof(string), "[EVENT]: %s %s has started the hydra wars event. 30 seconds before it starts, type /join!", GetPlayerStatus(playerid), adname);
						SendClientMessageToAll(COLOR_CMDNOTICE, string);
						IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
						Event_InProgress = 0;
						Event_Delay = 30;
					}
					else return 1;
				}
				case 2:
				{
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}
					FoCo_Event = 2;
					format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Mad Dogg's Mansion DM {%06x}event.  Type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
				}
				case 8:
				{
					if(FoCo_Event != -1)
					{
						SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
						return 1;
					}
					FoCo_Event = 8;
					format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Gun Game {%06x}event.  Type /join!", GetPlayerStatus(playerid), adname, COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
					SendClientMessageToAll(COLOR_CMDNOTICE, string);
					IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
					Event_InProgress = 0;
					return 1;
				}
			}
			return 1;
		}
	}
	return 1;
}

forward Event_OnPlayerClickPlayer(playerid, clickedplayerid, source);
public Event_OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

forward Event_OneSecond();
public Event_OneSecond()
{
    Event_Delay --;
	if(Event_Delay == 0)
	{
		Event_InProgress = 1;
		switch(FoCo_Event)
		{
			case 1:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Sumo is now in progress and can not be joined.");
				foreach(Event_Players, player)
				{
					SetVehicleParamsEx(Event_PlayerVeh[player], true, false, false, true, false, false, false);
					TogglePlayerControllable(player, 1);
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
					increment = 0;
				}
			}
			case 3:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Jefferson Motel DM is now in progress and can not be joined");
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					increment = 0;
					increment2 = 0;
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
				}
			}
			case 4:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Minigun wars is now in progress and can not be joined");
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					SendClientMessage(player, COLOR_NOTICE, "Fuck them bitches up playa!");
					increment = 0;
				}
			}
			case 5:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Pursuit is now in progress and can not be joined");
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					increment = 0;
					increment2 = 0;
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
				}
			}
			case 6:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Area 51 DM is now in progress and can not be joined");
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					increment = 0;
					increment2 = 0;
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
				}
			}
			case 7:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Compound Attack is now in progress and can not be joined");
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					increment = 0;
					increment2 = 0;
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
					if(GetPVarInt(player, "MotelTeamIssued") == 1)
					{
						SetPlayerCheckpoint(player, -2126.5669,-84.7937,35.3203,2.3031);
					}
				}
			}
			case 8:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Gun Game is now in progress and can not be joined");
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					increment = 0;
					increment2 = 0;
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
				}
			}
			case 9:
			{
				SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Custom event is now in progress and can not be joined");
				Event_InProgress = 1;
				foreach(Event_Players, player)
				{
					TogglePlayerControllable(player, 1);
					GameTextForPlayer(player, "~R~Event Started!", 1000, 3);
				}
			}
		}
	}
	else if(Event_Delay >= 0 && Event_Delay <= 5)
	{
		switch(FoCo_Event)
		{
			case 1:
			{
				new Float:vehx, Float:vehy, Float:vehz, Float:vang;
				foreach(Event_Players, player)
				{
					GetPlayerPos(player, vehx, vehy, vehz);
					GetPlayerFacingAngle(player, vang);
					SetVehiclePos(Event_PlayerVeh[player], vehx, vehy, vehz);
					SetVehicleZAngle(player, vang);
					PutPlayerInVehicle(player, Event_PlayerVeh[player], 0);
					SetVehicleParamsEx(Event_PlayerVeh[player], false, false, false, true, false, false, false);
					TogglePlayerControllable(player, 0);
				}
			}
		}
	}
	else if(Event_Delay > 0)
	{
		foreach(Event_Players, player)
		{
			if(FoCo_Event == 3)
			{
				SetCameraBehindPlayer(player);
			}
			TogglePlayerControllable(player, 0);
		}
	}
	foreach(Player,i)
	{
		if(GetPVarInt(i, "PlayerStatus") == 1 && Event_InProgress == 1)
		{
			switch(FoCo_Event)
			{
				case 1:
				{
					new Float:vx, Float:vy, Float:vz;
					GetVehiclePos(Event_PlayerVeh[i], vx, vy, vz);
					if(vz < 3.0 || GetPlayerState(i) != PLAYER_STATE_DRIVER)
					{
						SetPVarInt(i, "FellOffEvent", 1);
						PlayerLeftEvent(i);
					}
				}
			}
		}
		else if(GetPVarInt(i, "PlayerStatus") == 1 && Event_InProgress == 0)
		{
			switch(FoCo_Event)
			{
				case 8:
				{
					new tmpStr[30];
					format(tmpStr, sizeof(tmpStr), "%s", WeapNames[GetPlayerWeapon(i)]);
					TextDrawSetString(GunGame_Weapon[i], tmpStr);
				}
			}
		}
	}
	return 1;
}

forward Event_TenMinutes();
public Event_TenMinutes()
{
	return 1;
}
//================================[COMMANDS]====================================
CMD:event(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new option[50], string[86], adname[MAX_PLAYER_NAME];
		if (sscanf(params, "s[50] ", option))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "	[USAGE]: /event [Parameter]");
			SendClientMessage(playerid, COLOR_GRAD1, " [PARAMS]: Start - End");
			return 1;
	    }

		GetPlayerName(playerid, adname, sizeof(adname));

		if(strcmp(option,"Start", true) == 0)
		{
			if(FoCo_Event != -1)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  There is already an event running, end it first.");
				return 1;
			}
			ShowPlayerDialog(playerid, DIALOG_EVENTSTART, DIALOG_STYLE_LIST, "Event Starting", EVENT_LIST, "Select", "Cancel");
			return 1;

		}
		else if(strcmp(option,"End", true) == 0)
		{
			if(FoCo_Event == -1)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  There is no event to stop.");
				return 1;
			}
			EndEvent();
			increment = 0;
			MadDogsWeapon = 0;
			format(string, sizeof(string), "[EVENT]: %s %s has stopped the event!", GetPlayerStatus(playerid), adname);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SendClientMessageToAll(COLOR_NOTICE, string);
			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid param.");
		}
	}
	return 1;
}


CMD:join(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerStatus") == 2)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are in a duel, leave that first...");
		return 1;
	}
	if(FoCo_Player[playerid][jailed] != 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please wait until your admin jail is over.");
		return 1;
	}
	if(FoCo_Event == -1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No event has been started.");
		return 1;
	}
	if(FoCo_Event_Rejoin == 0 && FoCo_Event_Died[playerid] != 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You died and this is not rejoinable.");
		return 1;
	}
	if(Event_InProgress == 1)
	{
		SendClientMessage(playerid, COLOR_NOTICE, "This event is in progress now and can not be joined.");
		return 1;
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_WASTED || GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
		return 1;
	}
	if(GetPVarInt(playerid, "PlayerStatus") == 1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are already at the event!");
		return 1;
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
		RemovePlayerFromVehicle(playerid);
	}

	if(HaveCap(playerid) == 1)
	{
		RemovePlayerAttachedObject(playerid, pObject[playerid][oslot]);
		pObject[playerid][oslot] = -1;
		pObject[playerid][slotreserved] = false;
	}

	switch(FoCo_Event)
	{
		case 0:
		{
			SetPVarInt(playerid,"PlayerStatus",1);
			new randomnum = random(20);
			SetPlayerArmour(playerid, 0);
			SetPlayerHealth(playerid, 99);
			SetPlayerInterior(playerid, 2);
			SetPlayerPos(playerid, BigSmokeSpawns[randomnum][0], BigSmokeSpawns[randomnum][1], BigSmokeSpawns[randomnum][2]);
			SetPlayerVirtualWorld(playerid, 1500);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 500);
			GameTextForPlayer(playerid, "~R~~n~~n~ Big ~h~ Smoke!", 800, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 2:
		{
			if(Iter_Count(Event_Players) == 25)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 505);
			if(Sumo_Type == 0)
			{
				SetPlayerPos(playerid, sumoSpawnsType2[increment][0], sumoSpawnsType2[increment][1], sumoSpawnsType2[increment][2]+5);
				SetPlayerFacingAngle(playerid, sumoSpawnsType2[increment][3]);
				Event_PlayerVeh[playerid] = CreateVehicle(504, sumoSpawnsType2[increment][0], sumoSpawnsType2[increment][1], sumoSpawnsType2[increment][2], sumoSpawnsType2[increment][3], -1, -1, 15);
			}
			else if(Sumo_Type == 1)
			{
				SetPlayerPos(playerid, sumoSpawnsType1[increment][0], sumoSpawnsType1[increment][1], sumoSpawnsType1[increment][2]+5);
				SetPlayerFacingAngle(playerid, sumoSpawnsType1[increment][3]);
				Event_PlayerVeh[playerid] = CreateVehicle(556, sumoSpawnsType1[increment][0], sumoSpawnsType1[increment][1], sumoSpawnsType1[increment][2], sumoSpawnsType1[increment][3], -1, -1, 15);
				SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType1[increment][3]);
			}
			else if(Sumo_Type == 2)
			{
				SetPlayerPos(playerid, sumoSpawnsType3[increment][0], sumoSpawnsType3[increment][1], sumoSpawnsType3[increment][2]+5);
				SetPlayerFacingAngle(playerid, sumoSpawnsType3[increment][3]);
				Event_PlayerVeh[playerid] = CreateVehicle(495, sumoSpawnsType3[increment][0], sumoSpawnsType3[increment][1], sumoSpawnsType3[increment][2], sumoSpawnsType3[increment][3], -1, -1, 15);
				SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType3[increment][3]);
			}
			else if(Sumo_Type == 4)
			{
				SetPlayerPos(playerid, sumoSpawnsType5[increment][0], sumoSpawnsType5[increment][1], sumoSpawnsType5[increment][2]+5);
				SetPlayerFacingAngle(playerid, sumoSpawnsType5[increment][3]);
				Event_PlayerVeh[playerid] = CreateVehicle(495, sumoSpawnsType5[increment][0], sumoSpawnsType5[increment][1], sumoSpawnsType5[increment][2], sumoSpawnsType5[increment][3], -1, -1, 15);
				SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType5[increment][3]);
			}
			else
			{
				SetPlayerInterior(playerid, 15);
				SetPlayerPos(playerid, sumoSpawnsType4[increment][0], sumoSpawnsType4[increment][1], sumoSpawnsType4[increment][2]+5);
				SetPlayerFacingAngle(playerid, sumoSpawnsType4[increment][3]);
				Event_PlayerVeh[playerid] = CreateVehicle(504, sumoSpawnsType4[increment][0], sumoSpawnsType4[increment][1], sumoSpawnsType4[increment][2], sumoSpawnsType4[increment][3], -1, -1, 15);
				SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType4[increment][3]);
				LinkVehicleToInterior(Event_PlayerVeh[playerid], 15);
			}
			SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
			Iter_Add(Event_Players, playerid);
			SetPlayerArmour(playerid, 0);
			SetPlayerHealth(playerid, 99);
			ResetPlayerWeapons(playerid);
			GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
			TogglePlayerControllable(playerid, 0);
			SetCameraBehindPlayer(playerid);
			increment++;
		}
		case 4:
		{
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerArmour(playerid, 0);
			SetPlayerHealth(playerid, 99);
			SetPlayerVirtualWorld(playerid, 1500);
			SetPlayerInterior(playerid, 5);
			new randomnum = random(25);
			SetPlayerPos(playerid, MadDogSpawns[randomnum][0], MadDogSpawns[randomnum][1], MadDogSpawns[randomnum][2]);
			SetPlayerFacingAngle(playerid, MadDogSpawns[randomnum][3]);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, MadDogsWeapon, 500);
			GameTextForPlayer(playerid, "~R~~n~~n~ Mad ~h~ Dogs!", 800, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 5:
		{
			if(Iter_Count(Event_Players) == 30)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerArmour(playerid, 99);
			SetPlayerHealth(playerid, 99);
			SetPlayerVirtualWorld(playerid, 1500);
			SetPlayerInterior(playerid, 15);
			if(Motel_Team == 0)
			{
				new randomnum = increment;
				SetPVarInt(playerid, "MotelTeamIssued", 1);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 285);
				SetPlayerColor(playerid, COLOR_BLUE);
				SetPlayerPos(playerid, motelSpawnsType1[randomnum][0], motelSpawnsType1[randomnum][1], motelSpawnsType1[randomnum][2]);
				SetPlayerFacingAngle(playerid, motelSpawnsType1[randomnum][3]);
				Motel_Team = 1;
				increment++;
			}
			else
			{
				new randomnum = increment2;
				SetPVarInt(playerid, "MotelTeamIssued", 2);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 50);
				SetPlayerColor(playerid, COLOR_RED);
				SetPlayerPos(playerid, motelSpawnsType2[randomnum][0], motelSpawnsType2[randomnum][1], motelSpawnsType2[randomnum][2]);
				SetPlayerFacingAngle(playerid, motelSpawnsType2[randomnum][3]);
				Motel_Team = 0;
				increment2++;
			}
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 31, 500);
			GameTextForPlayer(playerid, "~R~~n~~n~ Motel ~h~ TDM!~n~~n~ ~w~You are now in the queue", 4000, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 7:
		{
			if(Iter_Count(Event_Players) == 17)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerVirtualWorld(playerid, 1500);
			SetPlayerPos(playerid, minigunSpawnsType1[increment][0], minigunSpawnsType1[increment][1], minigunSpawnsType1[increment][2]);
			SetPlayerFacingAngle(playerid, minigunSpawnsType1[increment][3]);
			SetPlayerArmour(playerid, 99);
			SetPlayerHealth(playerid, 99);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 38, 3000);
			GameTextForPlayer(playerid, "~R~~n~~n~ MINIGUN ~n~ WARS", 1500, 3);
			Iter_Add(Event_Players, playerid);
			TogglePlayerControllable(playerid, 0);
			increment++;
		}
		case 9:
		{
			if(Iter_Count(Event_Players) == 11)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
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
				new c1, c2, c3, c4, c5, c6, c7, c8, c9, c10;
				sscanf(DrugEventVehicles, "iiiiiiiiii", c1, c2, c3, c4, c5, c6, c7, c8, c9, c10);
				switch(increment)
				{
					case 0: { PutPlayerInVehicle(playerid, c1, 0); LastVehicle[playerid] = c1; }
					case 1: { PutPlayerInVehicle(playerid, c2, 0); LastVehicle[playerid] = c2; }
					case 2: { PutPlayerInVehicle(playerid, c3, 0); LastVehicle[playerid] = c3; }
					case 3: { PutPlayerInVehicle(playerid, c4, 0); LastVehicle[playerid] = c4; }
					case 4: { PutPlayerInVehicle(playerid, c5, 0); LastVehicle[playerid] = c5; }
					case 5: { PutPlayerInVehicle(playerid, c6, 0); LastVehicle[playerid] = c6; }
					case 6: { PutPlayerInVehicle(playerid, c7, 0); LastVehicle[playerid] = c7; }
					case 7: { PutPlayerInVehicle(playerid, c8, 0); LastVehicle[playerid] = c8; }
					case 8: { PutPlayerInVehicle(playerid, c9, 0); LastVehicle[playerid] = c9; }
					case 9: { PutPlayerInVehicle(playerid, c10, 0); LastVehicle[playerid] = c10; }
				}
				SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Take out the criminal car at all costs ...");
				if(FoCo_Criminal != INVALID_PLAYER_ID)
				{
					SetPlayerMarkerForPlayer( playerid, FoCo_Criminal, 0xFFFFFF00);
				}
				increment++;
			}
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 31, 500);
			GameTextForPlayer(playerid, "~R~~n~~n~ Pursuit ~h~ ~n~~n~ ~w~You are now in the queue", 4000, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 10:
		{
			if(Iter_Count(Event_Players) == 30)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerArmour(playerid, 99);
			SetPlayerHealth(playerid, 99);
			SetPlayerVirtualWorld(playerid, 1500);
			SetPlayerInterior(playerid, 0);
			if(Motel_Team == 0)
			{
				new randomnum = increment;
				SetPVarInt(playerid, "MotelTeamIssued", 1);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 287);
				SetPlayerColor(playerid, COLOR_BLUE);
				SetPlayerPos(playerid, area51SpawnsAF[randomnum][0], area51SpawnsAF[randomnum][1], area51SpawnsAF[randomnum][2]);
				SetPlayerFacingAngle(playerid, area51SpawnsAF[randomnum][3]);
				Motel_Team = 1;
				increment++;
			}
			else
			{
				new randomnum = increment2;
				SetPVarInt(playerid, "MotelTeamIssued", 2);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 70);
				SetPlayerColor(playerid, COLOR_RED);
				SetPlayerPos(playerid, area51SpawnsCrim[randomnum][0], area51SpawnsCrim[randomnum][1], area51SpawnsCrim[randomnum][2]);
				SetPlayerFacingAngle(playerid, area51SpawnsCrim[randomnum][3]);
				Motel_Team = 0;
				increment2++;
			}
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 27, 500);
			GivePlayerWeapon(playerid, 31, 500);
			GameTextForPlayer(playerid, "~R~~n~~n~ Area 51 ~h~ TDM!~n~~n~ ~w~You are now in the queue", 4000, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 13:
		{
			if(Iter_Count(Event_Players) == 30)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerArmour(playerid, 99);
			SetPlayerHealth(playerid, 99);
			SetPlayerVirtualWorld(playerid, 1500);
			SetPlayerInterior(playerid, 0);
			if(Motel_Team == 0)
			{
				new randomnum = increment;
				SetPVarInt(playerid, "MotelTeamIssued", 1);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 287);
				SetPlayerColor(playerid, COLOR_BLUE);
				SetPlayerPos(playerid, swatcompoundattack[randomnum][0], swatcompoundattack[randomnum][1], swatcompoundattack[randomnum][2]);
				SetPlayerFacingAngle(playerid, swatcompoundattack[randomnum][3]);
				Motel_Team = 1;
				increment++;
				SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the Compound.");
			}
			else
			{
				new randomnum = increment2;
				SetPVarInt(playerid, "MotelTeamIssued", 2);
				SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
				SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
				SetPlayerSkin(playerid, 221);
				SetPlayerColor(playerid, COLOR_RED);
				SetPlayerPos(playerid, terroristcoumpoundattack[randomnum][0], terroristcoumpoundattack[randomnum][1], terroristcoumpoundattack[randomnum][2]);
				SetPlayerFacingAngle(playerid, terroristcoumpoundattack[randomnum][3]);
				Motel_Team = 0;
				increment2++;
				SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the Compound ...");
			}
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 500);
			GivePlayerWeapon(playerid, 27, 500);
			GivePlayerWeapon(playerid, 31, 500);
			DisablePlayerCheckpoint(playerid);
			GameTextForPlayer(playerid, "~R~~n~~n~ Compound Attack ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
			Iter_Add(Event_Players, playerid);
		}
		case 14:
		{
			if(Iter_Count(Event_Players) == 30)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
				return 1;
			}
			SetPVarInt(playerid,"PlayerStatus",1);
			SetPlayerArmour(playerid, 0);
			SetPlayerHealth(playerid, 99);
			SetPlayerVirtualWorld(playerid, 1500);
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, GunGameSpawns[increment+5][0], GunGameSpawns[increment+5][1], GunGameSpawns[increment+5][2]);
			SetPlayerFacingAngle(playerid, GunGameSpawns[increment][3]);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, GunGameWeapons[0], 500);
			GameTextForPlayer(playerid, "~R~~n~~n~ Gun ~h~ Game!", 800, 3);
			Iter_Add(Event_Players, playerid);
			GunGameKills[playerid] = 0;
			lastGunGameWeapon[playerid] = 38;
			TextDrawShowForPlayer(playerid, CurrLeader[playerid]);
			TextDrawShowForPlayer(playerid, CurrLeaderName[playerid]);
			TextDrawShowForPlayer(playerid, GunGame_MyKills[playerid]);
			TextDrawShowForPlayer(playerid, GunGame_Weapon[playerid]);

			new tmpStr[30];
			format(tmpStr, sizeof(tmpStr), "%s", WeapNames[0]);
			TextDrawSetString(GunGame_Weapon[playerid], tmpStr);
			format(tmpStr, sizeof(tmpStr), "(%d / 16)", GunGameKills[playerid]);
			TextDrawSetString(GunGame_MyKills[playerid], tmpStr);
			TextDrawSetString(CurrLeaderName[playerid], "No Kills");

			increment++;
		}
		case 15:
		{
			if(CEM[MaxPlayers] > CEM_Players)
			{
				if(GetPVarInt(playerid,"PlayerStatus") == 0 && GetPlayerVirtualWorld(playerid) != 1500)
				{
					SetPVarInt(playerid,"PlayerStatus",1);
					GameTextForPlayer(playerid, "~R~~n~~n~Custom ~h~ Event", 800, 3);
					Iter_Add(Event_Players, playerid);
					if(CEM[Gamemode] == 1) CEM_Players = 0;
					else CEM_Players ++;
					JoinCEM(playerid);
					PlayerColor[playerid] = GetPlayerColor(playerid);//because color is over 255 i guess
					PlayerTeamID{playerid} = GetPlayerTeam(playerid);
					PlayerSkinID[playerid] = GetPlayerSkin(playerid);// because skins get over 255
					if(CEM[Gamemode] != 1) TogglePlayerControllable(playerid,0);
					if(CEM[Gamemode] != 1) SendClientMessage(playerid, COLOR_GREEN, "You're frozen now, wait until the event starts.");
				}
				else SendClientMessage(playerid, COLOR_NOTICE, "Cant re-join the event");
			}
			else SendClientMessage(playerid, COLOR_NOTICE, "Event is full.");
		}
	}
	return 1;
}

CMD:leaveevent(playerid, params[])
{
	if(FoCo_Event != -1 && GetPVarInt(playerid, "PlayerStatus") == 1)
	{
		new Float:Health;
		GetPlayerHealth(playerid, Health);
		if(Health < 75.0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot leave an event without more than 75 health.");
			return 1;
		}
		SetPVarInt(playerid, "FellOffEvent", 1);
		PlayerLeftEvent(playerid);
		SetPVarInt(playerid, "MotelTeamIssued", 0);
		if(GetPVarInt(playerid, "MotelSkin") > 0)
		{
			SetPlayerSkin(playerid, GetPVarInt(playerid, "MotelSkin"));
			SetPlayerColor(playerid, GetPVarInt(playerid, "MotelColor"));
		}
		TogglePlayerControllable(playerid, 1);
		if(FoCo_Event == 14)
		{
			TextDrawHideForPlayer(playerid, CurrLeader[playerid]);
			TextDrawHideForPlayer(playerid, CurrLeaderName[playerid]);
			TextDrawHideForPlayer(playerid, GunGame_MyKills[playerid]);
			TextDrawHideForPlayer(playerid, GunGame_Weapon[playerid]);
			GunGameKills[playerid] = 0;
		}
		if(FoCo_Event == 15)
		{
			leavecevent(playerid);
			SetPlayerHealth(playerid,99);
			CEM_Players = CEM_Players - 1;
			if(CEM_Players == 0)clearevent();
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not at an event, thereofe cannot leave.");
	}
	return 1;
}

/*
new Float:armySpawnsType1[][] = {
	{-536.6452,1309.3185,3.7102,143.2186},
	{-535.7869,1307.3175,3.6655,144.8415},
	{-534.9776,1304.9730,3.5959,138.3177},
	{-534.4557,1302.6029,3.6028,133.0472},
	{-880.8651,1621.5620,30.8952,152.0271},
	{-880.4622,1617.4822,33.4015,245.7476},
	{-873.7017,1618.7975,33.4030,60.9587},
	{-883.3175,1615.1110,35.7468,240.8466},
	{-854.6778,1376.1045,1.2741,311.1262},
	{-851.0994,1372.8354,1.2741,315.1996}
};

new Float:armySpawnsType2[][] = {
	{-726.8176,1533.9048,40.1724,353.1638},
	{-729.1471,1534.0126,40.1633,356.0400},
	{-731.5231,1535.9725,40.2617,268.3620},
	{-729.3406,1538.0480,40.3969,2.6762},
	{-732.8348,1538.6995,40.4118,263.7181},
	{-730.0102,1539.9668,40.5042,164.1335},
	{-734.8888,1544.8472,39.0736,264.7473},
	{-734.6887,1547.8004,38.9713,266.9969},
	{-734.5697,1545.9861,41.5462,266.4031},
	{-734.1703,1555.2683,39.8209,272.7589}
};

new Float:drugSpawnsType1[][] = {
	{386.3043,2548.5906,16.5391,174.1982},
	{386.2205,2546.2419,16.5391,177.9582},
	{386.1368,2543.9036,16.5391,177.9582},
	{386.0403,2541.1985,16.5391,177.9582},
	{385.9525,2538.7400,16.5391,177.9582},
	{385.8694,2536.4104,16.5391,177.9582},
	{385.7797,2533.8972,16.5391,177.9582},
	{385.6798,2531.1011,16.5491,177.9582},
	{383.5614,2530.6782,16.5759,177.9582},
	{383.5607,2533.7908,16.5391,177.9582},
	{383.8788,2536.5457,16.5391,177.9582},
	{383.9685,2539.5559,16.5391,177.9582},
	{383.9574,2542.3435,16.5391,177.9582},
	{383.9225,2544.8630,16.5391,177.9582},
	{383.7946,2547.6460,16.5391,177.9582},
	{381.6566,2547.5417,16.5391,177.9582},
	{381.5372,2544.2039,16.5391,177.9582},
	{381.4406,2541.4956,16.5391,177.9582},
	{381.3459,2538.8496,16.5391,177.9582},
	{381.2657,2536.6025,16.5391,177.9582},
	{381.1742,2534.0408,16.5482,177.9582},
	{381.0813,2531.4390,16.5880,177.9582},
	{379.1826,2531.0791,16.5973,177.9582},
	{379.3771,2533.8757,16.5763,177.9582},
	{379.3782,2536.8149,16.5391,177.9582},
	{378.6484,2539.3767,16.5391,177.9582},
	{379.3178,2540.9807,16.5391,177.9582},
	{379.2309,2544.4143,16.5391,177.9582},
	{379.1219,2547.0881,16.5391,177.9582},
	{379.1389,2548.8113,16.5391,177.9582}
};

new Float:drugSpawnsType2[][] = {
	{1754.4464,-1886.6516,13.5569,271.7347},
	{1756.4623,-1886.5906,13.5564,271.7347},
	{1759.0895,-1886.5109,13.5558,271.7347},
	{1761.2360,-1886.4458,13.5553,271.7347},
	{1763.8300,-1886.3678,13.5546,271.7347},
	{1766.9156,-1886.2738,13.5539,271.7347},
	{1769.2448,-1886.2031,13.5533,271.7347},
	{1769.6971,-1888.5441,13.5601,271.7347},
	{1767.4825,-1888.3868,13.5537,271.7347},
	{1765.1946,-1888.3080,13.5543,271.7347},
	{1762.0735,-1888.4391,13.5551,271.7347},
	{1758.4504,-1887.7513,13.5559,271.7347},
	{1755.7251,-1888.0513,13.5566,271.7347},
	{1752.6431,-1888.3499,13.5574,271.7347},
	{1752.7349,-1890.3278,13.5573,271.7347},
	{1755.6147,-1890.4915,13.5566,271.7347},
	{1758.5013,-1890.4045,13.5559,271.7347},
	{1761.5813,-1890.3114,13.5552,271.7347},
	{1764.6033,-1890.2196,13.5544,271.7347},
	{1767.3138,-1890.1372,13.5603,271.7347},
	{1770.0690,-1890.0535,13.5610,271.7347},
	{1770.9042,-1892.0048,13.5621,271.7347},
	{1768.0706,-1891.3242,13.5611,271.7347},
	{1765.2567,-1891.3208,13.5604,271.7347},
	{1763.0635,-1891.2950,13.5548,271.7347},
	{1760.6603,-1891.1453,13.5554,271.7347},
	{1758.0073,-1891.5461,13.5561,271.7347},
	{1755.7379,-1891.1418,13.5566,271.7347},
	{1753.4752,-1891.4116,13.5572,271.7347},
	{1753.9664,-1893.4374,13.5570,271.7347},
	{1755.9385,-1893.3779,13.5566,271.7347}
};

new Float:terroristoilrigspawns1[][] = { // terrorissts
	{-4848.1548,-1105.7831,52.1931,89.7017}, // Terrorspawn1
	{-4848.2217,-1104.4656,52.1929,87.5171}, // Terrorspawn2
	{-4848.2749,-1102.7365,52.1956,89.8487}, // Terrorspawn4
	{-4848.3560,-1101.0161,52.2002,89.0294}, // Terrorspawn3
	{-4848.4229,-1099.3506,52.2047,88.4292}, // Terrorspawn5
	{-4848.5532,-1097.4938,52.2097,88.2838}, // Terrorspawn6
	{-4848.5591,-1095.4310,52.2152,88.8179}, // Terrorspawn7
	{-4848.6245,-1093.4357,52.2206,87.7901}, // Terrorspawn8
	{-4854.3359,-1106.2627,52.1862,93.3493}, // Terrorspawn9
	{-4854.3325,-1104.7566,52.1902,89.1057}, // Terrorspawn10
	{-4854.3599,-1103.3361,52.1940,87.8238}, // Terrorspawn11
	{-4854.4463,-1101.3271,52.1994,91.0379}, // Terrorspawn12
	{-4854.5317,-1099.6100,52.2040,89.9278}, // Terrorspawn13
	{-4854.5986,-1097.7080,52.2283,89.0495}, // Terrorspawn14
	{-4854.8691,-1095.8661,52.2276,93.9821}, // Terrorspawn15
	{-4854.9053,-1094.2699,52.2275,89.5147}, // Terrorspawn16
	{-4854.8970,-1092.4136,52.2275,85.0473} // Terrorspawn17
};

new Float:swatoilrigspawns1[][] = {
	{-4989.2671,-1060.4849,62.3481,268.9522}, // SWATspawn1
	{-4989.2139,-1058.8197,62.3481,269.9485}, // SWATspawn2
	{-4989.2607,-1056.6619,62.3481,265.9313}, // SWATspawn3
	{-4989.2803,-1054.1078,62.3481,269.1208}, // SWATspawn4
	{-4989.1377,-1051.6665,62.3481,267.9237}, // SWATspawn5
	{-4989.0537,-1049.2660,62.3481,268.2932}, // SWATspawn6
	{-4989.0015,-1046.9961,62.3481,268.3495}, // SWATspawn7
	{-4988.9907,-1044.8541,62.3481,269.0324}, // SWATspawn8
	{-4989.0864,-1042.5729,62.3481,269.0886}, // SWATspawn9
	{-4984.8403,-1042.4364,62.3481,269.1448}, // SWATspawn10
	{-4984.7739,-1044.3013,62.3481,268.5744}, // SWATspawn11
	{-4984.6982,-1046.3790,62.3481,268.6869}, // SWATspawn12
	{-4984.5972,-1048.5526,62.3481,268.7432}, // SWATspawn13
	{-4984.3262,-1051.0364,62.3481,268.4861}, // SWATspawn14
	{-4984.2212,-1053.4729,62.3481,271.9891}, // SWATspawn15
	{-4984.1616,-1055.9543,62.3481,269.2253}, // SWATspawn16
	{-4984.1226,-1058.9647,62.3481,267.7148} // SWATspawn17
};


new Float:hydraSpawnsType1[][] = {
	{1939.58178711,1365.82348633,16.76304626,272.00000000},
	{1939.77551270,1323.51635742,16.76304626,271.50000000},
	{1968.00170898,1185.41442871,63.80590057,0.00000000},
	{1955.27209473,1173.72131348,63.80590439,180.00000000},
	{2163.80175781,1502.10534668,32.08264542,320.00000000},
	{2164.01171875,1463.47900391,32.08404922,222.00000000},
	{2106.23974609,1462.88977051,32.08428955,124.00000000},
	{2106.60009766,1502.69543457,32.08437729,52.00000000},
	{1950.36877441,1628.54748535,23.68749237,272.00000000},
	{1953.65820312,1603.13574219,73.17739105,39.99572754},
	{1906.02832031,1628.63964844,73.17739105,270.00000000},
	{1955.29699707,1655.69946289,73.17520905,39.99572754}
};

new Float:navySealsBoat[][] = {
	{-1475.6034,1483.3225,1.5800,228.1285},
	{-1476.3745,1481.5135,1.5800,247.6117},
	{-1477.0802,1479.5178,1.5800,246.7279}, // Boatspawn_3
	{-1444.9019,1501.1514,1.7366,98.2065}, // Boatspawn_4
	{-1447.0107,1503.8995,1.7366,140.2498}, // Boatspawn_5
	{-1456.7163,1481.0428,7.1016,87.0388}, // Boatspawn_6
	{-1456.1177,1485.5995,7.1016,84.1065}, // Boatspawn_7
	{-1456.3177,1497.4828,7.1016,104.9317}, // Boatspawn_8
	{-1463.0660,1497.6965,8.2578,268.1799}, // Boatspawn_9
	{-1463.1732,1494.8063,8.2578,266.3562}, // Boatspawn_10
	{-1463.2122,1491.9156,8.2578,267.6658}, // Boatspawn_11
	{-1463.1044,1489.0294,8.2501,266.1552}, // Boatspawn_12
	{-1463.2954,1486.1844,8.2501,267.7782}, // Boatspawn_13
	{-1463.3452,1480.7723,8.2578,268.8307}, // Boatspawn_14
	{-1463.4204,1483.3024,8.2578,268.4611}, // Boatspawn_15
	{-1452.0812,1477.6252,1.3031,269.8831}, // Boatspawn_16
	{-1446.9612,1477.6980,1.3031,271.1364} // Boatspawn_17
};

new Float:terroristsBoat[][] = {
	{-1434.3325,1481.8838,1.8672,276.5517},
	{-1434.2948,1484.1460,1.8672,268.4611},
	{-1434.2507,1486.6434,1.8672,268.5173},
	{-1434.2252,1489.7177,1.8672,268.5735},
	{-1434.3741,1494.6810,1.8672,267.6897},
	{-1433.8632,1498.0852,1.8672,263.3593},
	{-1413.2545,1497.2257,1.8672,265.6650},
	{-1406.1989,1497.3625,1.8672,271.3051},
	{-1394.2034,1497.2762,1.8735,271.3051},
	{-1390.7335,1493.5171,1.8735,86.3641},
	{-1390.7863,1490.1801,1.8735,88.0595},
	{-1391.1282,1486.5408,1.8672,82.7890},
	{-1391.2137,1483.8008,1.8672,84.7253},
	{-1391.6104,1480.9357,1.8672,85.0948},
	{-1400.5376,1482.9449,1.8672,90.7348},
	{-1408.2819,1483.0409,1.8672,90.7348}
};
*/
