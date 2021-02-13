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
* Filename:  carepackage_vista.pwn                                               *
* Author:    dr_vista                                                            *
*********************************************************************************/
#include <YSI\y_hooks>

new Float:vista_CarePackage_Spawns[][] = /* Zone Names & Co-ordinates*/
{
   {2134.0527, -1739.2377, 17.2891}, // Idlewood
   {2158.5520,-1801.5583,13.3736}, // Idlewood
   {2352.2861,-1660.2561,13.4221}, // Ganton
   {2456.3823,-1807.9246,17.3341}, // Ganton
   {2399.2288,-1742.3354,13.5469}, // Ganton
   {2481.0530,-1746.4188,13.5469}, // Ganton
   {2573.4680,-1766.4124,1.6406}, // LS Sewers
   {2489.9109,-1948.5088,13.4687}, // Willowfield
   {2404.8059,-1922.9388,13.3828}, // Willowfield
   {2452.4294,-1975.4675,13.5469}, // Willowfield
   {2511.8796,-2010.6112,13.2813}, // Willowfield
   {1699.0448,-1053.2911,23.9063}, // Mulholland Parking Lot
   {1715.7915,-1288.1487,13.3828}, // Downtown Los Santos
   {1455.4764,-1163.3516,23.6563}, // Downtown Los Santos
   {2400.0374,-1539.9302,23.9925}, // East Los Santos
   {2520.6646,-1465.7085,23.9779}, // East Los Santos
   {2404.6182,-1383.0782,24.2303}, // East Los Santos
   {2585.5391,-1323.0989,40.3123}, // Los Flores
   {2641.0378,-1184.5812,66.4723}, // Los Flores
   {2761.6506,-1176.6537,69.4057}, // Los Flores
   {2697.4844,-1122.4059,69.5781}, // Las Colinas
   {2601.6660,-1076.2494,69.5845}, // Las Colinas
   {2494.2502,-973.7180,82.1058}, // Las Colinas
   {2270.1067,-1041.4669,50.7674}, // Las Colinas
   {2102.7871,-987.8544,53.9817}, // Las Colinas
   {1906.3596,-1084.3073,24.1681}, // Glen Park
   {1941.2686,-1156.0596,21.3403}, // Glen Park
   {1978.8353,-1217.2109,25.3184}, // Glen Park
   {2082.3384,-1223.2936,23.8125}, // Glen Park
   {2152.9812,-1167.3767,23.8236}, // Jefferson
   {2255.5986,-1300.1708,23.8203}, // Jefferson
   {2241.4426,-1431.8300,24.8787}, // Jefferson
   {2335.0845,-1369.5900,24.0057}, // Jefferson
   {2222.5627,-1348.0468,23.9852}, // Jefferson Church
   {2224.3152,-1170.3551,25.7266}, // Jefferson Motel
   {2241.0408,-1171.8352,33.5313}, //  Jefferson Motel
   {2193.6226,-1161.4651,33.5240}, //  Jefferson Motel
   {2648.4397,-1998.3252,13.5547}, // Seville
   {2778.2180,-2015.0520,13.5547}, // Seville
   {2698.3965,-1965.0496,13.5469}, // Seville
   {2761.7756,-1943.5035,13.5469}, // Seville
   {1977.3798,-1990.2913,13.5469}, // El Corona
   {2000.4946,-2041.3820,13.5469}, // El Corona
   {1739.9175,-2071.4167,13.6308}, // El Corona
   {1677.3488,-2112.8872,13.5469}, // El Corona
   {2025.7100,-2280.8398,13.5469}, // Los Santos Airport
   {1734.7592,-2407.0085,13.5547}, // Los Santos Airport
   {1699.6157,-2530.9028,13.5469}, // Los Santos Airport
   {1916.5626,-2631.9119,13.5469}, // Los Santos Airport
   {2149.8132,-2375.7056,13.5469}, // Los Santos Airport
   {2078.9700,-2237.9429,13.5469}, // Los Santos Airport
   {1162.7794,-2040.4479,69.0078}, // Verdant Bluffs
   {901.2043,-1531.3986,13.5459}, // Marina
   {766.7553,-1436.1007,13.5302}, // Marina
   {992.6754,-1300.0134,13.3828}, // Market
   {1022.2145,-1128.0372,23.8697}, // Star Street
   {1209.2529,-1094.6320,25.5970}, // Temple
   {399.6721,-1232.2468,51.7238}, // Richman
   {251.3302,-1254.8877,70.7032}, // Richman
   {479.9882,-1087.2158,82.5326}, // Richman
   {775.4351,-913.8091,56.5118}, // Richman
   {1089.5243,-784.4504,107.3543}, // Mulholland
   {1051.7061,-689.9586,119.6319}, // Mulholland
   {1281.6417,-679.4422,100.7307}, // Mulholland
   {920.3625,-787.3459,114.3504}, // Mulholland
   {1698.9203,-1045.2778,23.9063}, // Mulholland Parking Lot
   {1686.5258,-1017.8967,23.9063}, // Mulholland Parking Lot
   {1602.0265,-1021.4746,23.9063}, // Mulholland Parking Lot
   {1570.5430,-1013.3079,23.9063}, // Mulholland Parking Lot
   {1801.2949,-1076.9756,23.9686}, // Mulholland Parking Lot
   {1903.7324,-1085.6604,24.1580}, // Glen Park
   {1974.8611,-1091.3334,25.2109}, // Glen Park
   {2010.8682,-1096.4274,24.784}, // Glen Park
   {2068.7058,-1138.8831,23.7337}, // Glen Park
   {2117.3403,-1176.6367,24.1594}, // Glen Park
   {2013.0371,-1261.8138,23.8138}, // Glen Park
   {2168.5994,-1272.3538,23.820}, // Jefferson
   {2272.9954,-1323.8927,23.8281}, // Jefferson
   {2275.8328,-1408.3846,23.9406}, // Jefferson
   {2240.5320,-1485.0142,23.4460}, // Jefferson
   {2129.9553,-1465.5760,23.8118}, // Jefferson
   {2342.6208,-1300.0956,24.0280}, // East Los Santos
   {2352.8586,-1337.8605,27.8125}, // East Los Santos
   {2404.4348,-1381.4636,24.2357}, // East Los Santos
   {2453.4292,-1395.9614,23.8326}, // East Los Santos
   {2480.4995,-1405.0103,28.8358}, // East Los Santos
   {2516.8132,-1357.3557,28.5313}, // East Los Santos
   {2494.8079,-1351.7905,38.6685}, // East Los Santos
   {2491.9070,-1363.5280,34.5681}, // East Los Santos
   {2396.0713,-1487.0010,23.8281}, // East Los Santos
   {2387.2402,-1552.5652,28.0000}, // East Los Santos
   {2395.8757,-1554.0702,31.5000}, // East Los Santos
   {2412.8223,-1717.0134,13.7285}, // Ganton
   {2482.1045,-1748.6233,13.5469}, // Ganton
   {2484.9070,-1782.1235,13.5545}, // Ganton
   {2452.8596,-1771.4177,13.5789}, // Ganton
   {2537.2986,-1956.3715,13.5469}, // Willowfield
   {2857.6799,-1862.3279,11.0954}, // East Beach
   {2885.3015,-1945.5450,6.0008}, // East Beach
   {2911.1309,-2051.7285,3.5480}, // East Beach
   {2886.1514,-2127.2339,3.5507}, // East Beach
   {2854.5718,-2124.8499,10.2529}, // East Beach
   {2806.6274,-2183.0923,14.3749}, // East Beach
   {1765.2118,-1897.8575,13.5636}, // Unity
   {1761.6213,-1920.6453,13.5738}, // Unity
   {1714.7649,-1923.7737,13.5666}, // Unity
   {1715.2159,-1857.4521,13.5781}, // Unity
   {1679.4918,-1933.0422,21.9542}, // Unity
   {1918.7939,-1718.6337,13.5358}, // Idlewood
   {1761.4055,-1668.4266,13.5594}, // Little Mexico
   {1738.9601,-1741.4542,13.5469}, // Little Mexico
   {1480.4028,-1615.6239,14.0393}, // Pershing Square
   {1429.4042,-1703.8661,13.3828}, // Pershing Square
   {1538.8750,-1722.8312,13.5469}, // Pershing Square
   {1350.0033,-1747.7581,13.3729}, // Commerce
   {1093.8490,-1761.8115,13.3587}, // Los Santos Conference Center
   {1065.8854,-1822.5304,13.6911}, // Los Santos Conference Center
   {1178.8285,-1843.9435,13.4106}, // Los Santos Conference Center
   {962.6501,-1858.9535,11.4490}, // Verona Beach
   {843.7081,-1827.7168,12.1286}, // Verona Beach
   {830.7383,-1939.9080,12.8672}, // Verona Beach
   {847.3395,-2046.6055,12.8672}, // Verona Beach
   {800.1756,-1842.6587,8.3941}, // Verona Beach
   {680.6278,-1827.1571,6.1795}, // Santa Maria Beach
   {550.2965,-1857.9717,4.7309}, // Santa Maria Beach
   {319.7975,-1859.4136,3.1090}, // Santa Maria Beach
   {326.0677,-1798.4620,4.6993}, // Santa Maria Beach
   {157.8368,-1791.8694,3.9279}, // Santa Maria Beach
   {372.4501,-1807.8298,7.6744}, // Santa Maria Beach
   {365.8294,-2061.0273,15.3971}, // Santa Maria Beach
   {350.2336,-1588.1804,32.6498}, // Rodeo
   {391.0112,-1558.2012,29.7540}, // Rodeo
   {418.9253,-1553.6084,27.5781}, // Rodeo
   {402.5434,-1534.3423,32.2734}, // Rodeo
   {384.4060,-1451.2151,33.3355}, // Rodeo
   {445.9338,-1370.0587,24.8758}, // Rodeo
   {446.9255,-1356.3671,24.2467}, // Rodeo
   {536.6649,-1405.1636,15.7202}, // Rodeo
   {488.4321,-1497.5696,20.2468}, // Rodeo
   {743.6622,-1342.4143,13.5230}, // Vinewood
   {811.2985,-1151.1022,23.7691}, // Vinewood
   {926.1448,-1222.4647,16.9722}, // Vinewood
   {859.2372,-1289.4967,13.7824}, // Vinewood
   {1016.6199,-1090.5601,23.8281}, // Vinewood
   {1083.6848,-1103.3052,24.6477}, // Vinewood
   {816.6447,-1324.6455,13.4954}, // Market Station
   {1104.1764,-1206.5084,17.8047}, // Market
   {1024.2351,-1359.5232,13.7266}, // Market
   {1091.9135,-1382.6102,13.7813}, // Market
   {1100.2120,-1316.1416,13.7101}, // Market
   {1137.9119,-1323.7487,13.6079}, // Market
   {1184.3729,-1215.9368,18.7689}, // Market
   {1278.7992,-1320.2318,13.3608} // Market
};

enum vista_e_CarePackage_Main /* infos enum*/
{
   carePackage,
   gCarePackageSpawnTimer,
   gCarePackageCaptureTimer,
   pCapturing,
   Float:oPos[3]
};



new
	vista_CarePackage_Main[vista_e_CarePackage_Main], /* Infos array */
	Random;

forward vista_CarePackageSpawn(); /* Will spawn the care package once triggered */
forward vista_CarePackageCapture(); /* Will trigger once the capture is done */

#define CARE_PACKAGE_RESPAWN_TIME       30 // Care package respawn time in minutes after successful capture
#define CARE_PACKAGE_CAPTURE_TIME       20 // Care package capture time in seconds
#define CARE_PACKAGE_CAPTURE_RANGE      5 // Sets the range at which you can capture the care package
#define CARE_PACKAGE_COOLDOWN_TIME 		5 // Capture cool down time to avoid spam

#define FAILED_CAPTURE_ENTERED_CAR      0 // Tried to enter a car while capturing
#define FAILED_CAPTURE_DIED             1 // Died while capturing
#define FAILED_CAPTURE_LEFT_ZONE        2 // If the player manages to get away from the capture zone
#define FAILED_CAPTURE_CANCELLED        3 // Capture was cancelled by player

forward Dev_vista_carep_cooldown(playerid);


/* ******************************************************************************************** */

hook OnGameModeInit()
{
   vista_CarePackage_Main[gCarePackageSpawnTimer] = SetTimer("vista_CarePackageSpawn", CARE_PACKAGE_RESPAWN_TIME*1000, true); /* Spawns the care package after the server starts (In seconds here) */
   vista_CarePackage_Main[carePackage] = -1; /* For use in care package spawn checks */
   vista_CarePackage_Main[pCapturing] = -1; /* Returns who is currently capturing the package */
}

public vista_CarePackageSpawn() /* Will spawn the care package after the respawn time */
{
	if(vista_CarePackage_Main[carePackage] != -1) /* Checks if there is already a care package spawned, in theory it wouldn't happen, but who knows */
	{
		return 1;
	}
	else
	{
		new
			string[94],
			zName[30];
			
		Random = random(sizeof(vista_CarePackage_Spawns)); /* Random spawns */
		
		vista_CarePackage_Main[carePackage] = CreateDynamicObject(18849, vista_CarePackage_Spawns[Random][0], vista_CarePackage_Spawns[Random][1], vista_CarePackage_Spawns[Random][2]+500, 0, 0, 0, 0, 0, -1, 200); /* Create the object at random co-ordinates */
		MoveDynamicObject(vista_CarePackage_Main[carePackage],vista_CarePackage_Spawns[Random][0], vista_CarePackage_Spawns[Random][1], vista_CarePackage_Spawns[Random][2]+6, 50, 0, 0, 0); /* Make it fall from the sky */
		GetDynamicObjectPos(vista_CarePackage_Main[carePackage], vista_CarePackage_Main[oPos][0], vista_CarePackage_Main[oPos][1], vista_CarePackage_Main[oPos][2]);
		vista_CarePackage_Main[oPos][2] = vista_CarePackage_Main[oPos][2] - 500;
		
		KillTimer(vista_CarePackage_Main[gCarePackageSpawnTimer]); /* The respawn timer will only be re-triggered after successful capture, there's no need to keep it running */
		
		vista_CarePackage_Main[pCapturing] = -1;

		//strunpack(zName, vista_CarePackage_Spawns[Random][ZONE_NAME]);
		GetCarePackagePos(zName, sizeof(zName));
		format(string, sizeof(string), "[INFO]: A care package has been located around %s, go capture it!", zName);
		SendClientMessageToAll(COLOR_NOTICE, string);
	}
	return 1;
}

public vista_CarePackageCapture() /* Triggers after capture time is complete */
{
   if(IsPlayerInRangeOfPoint(vista_CarePackage_Main[pCapturing], CARE_PACKAGE_CAPTURE_RANGE, vista_CarePackage_Main[oPos][0], vista_CarePackage_Main[oPos][1], vista_CarePackage_Main[oPos][2])) /* checks if the player is still in range of the object before flagging a successful capture (in case of an animation error the player could run away) */
   {
      vista_CaptureSuccessful(vista_CarePackage_Main[pCapturing]); /* Capture was successful */
   }

   else
   {
       vista_FailedCarePackageCapture(FAILED_CAPTURE_LEFT_ZONE); /* Capture failed because the player left the capture zone */
   }

   return 1;
}

hook OnPlayerSpawn(playerid)
{
	if(vista_CarePackage_Main[carePackage] != -1) /* Will only tell the player about the care package if one is spawned */
	{
		new string[77],zName[30];
		GetCarePackagePos(zName, sizeof(zName));
		format(string, sizeof(string), "[INFO]: There's a care package at %s, go get it!", zName);
		SendClientMessage(playerid, COLOR_NOTICE, string);
	}
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	if(playerid == vista_CarePackage_Main[pCapturing]) /* if the player dies while capturing, the capture has failed */
	{
	    GiveAchievement(killerid, 90);
		vista_FailedCarePackageCapture(FAILED_CAPTURE_DIED);
	}
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(vista_CarePackage_Main[pCapturing] == playerid) /* If the player enters a car, the capture failed, he has to stay on foot */
	{
		vista_FailedCarePackageCapture(FAILED_CAPTURE_ENTERED_CAR);
	}
}

CMD:capturecarepackage(playerid, params[])
{
	if (vista_CarePackage_Main[carePackage] != -1) /* check if care package was spawned*/
	{
	    if(GetPVarInt(playerid, "vista_carep_CoolDown") == 0)
	    {
			if(IsPlayerInRangeOfPoint(playerid, CARE_PACKAGE_CAPTURE_RANGE, vista_CarePackage_Main[oPos][0], vista_CarePackage_Main[oPos][1], vista_CarePackage_Main[oPos][2]) && !IsPlayerInAnyVehicle(playerid) && GetPlayerVirtualWorld(playerid) == 0) /* Check if in range of the capture zone & player is not passenger/driver */
			{
				if(GetPlayerSpecialAction(playerid) == 0)
				{
					if(vista_CarePackage_Main[pCapturing] == -1) /* If no one else is capturing */
					{
						new
							string[45+MAX_PLAYER_NAME];

						vista_CarePackage_Main[pCapturing] = playerid; /* returns the player id for use in other functions */

						vista_CarePackage_Main[gCarePackageCaptureTimer] = SetTimer("vista_CarePackageCapture", CARE_PACKAGE_CAPTURE_TIME*1000, 0); /* Start capture timer */

						ApplyAnimation(vista_CarePackage_Main[pCapturing], "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0, 0); /* Force the player into an animation */
						ClearAnimations(vista_CarePackage_Main[pCapturing]);
						ApplyAnimation(vista_CarePackage_Main[pCapturing], "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0, 0); /* Force the player into an animation */

						GameTextForPlayer(vista_CarePackage_Main[pCapturing], "~g~Capturing care package~n~press ~y~~k~~PED_LOOKBEHIND~ ~g~to ~r~abort.", 3000, 3);

						format(string, sizeof(string), "%s is capturing the care package, go kill him!", PlayerName(playerid));
						SendClientMessageToAll(COLOR_NOTICE, string); /* Tell the whole server someone is capturing the care package */
					}
					else if(vista_CarePackage_Main[pCapturing] == playerid) /* if the player is already capping and continues pressing MMB */
					{
						vista_FailedCarePackageCapture(FAILED_CAPTURE_CANCELLED);
						SetPVarInt(playerid, "vista_carep_CoolDown", 1);
						SetTimerEx("Dev_vista_carep_cooldown", CARE_PACKAGE_COOLDOWN_TIME*1000, false, "i", playerid);
					}
					else /* If the player tries to capture whilst someone else is already capturing */
					{
						return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Someone else is already capturing the care package.");
					}
				}
				
				else
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't capture the care package while performing an animation.");
				}
			}
			else if(IsPlayerInRangeOfPoint(playerid, CARE_PACKAGE_CAPTURE_RANGE, vista_CarePackage_Main[oPos][0], vista_CarePackage_Main[oPos][1], vista_CarePackage_Main[oPos][2]) && IsPlayerInAnyVehicle(playerid)) /* If in capture range but in a vehicle */
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't capture the care package from inside a vehicle.");
			}
		}
		
		else
		{
		    new
				string[63];
				
		    format(string, sizeof(string), "[ERROR:] You have to wait %d seconds before capturing again.", CARE_PACKAGE_COOLDOWN_TIME);
			SendClientMessage(playerid, COLOR_WARNING, string);
			return 1;
		}
	}
	
	return 1;
}

CMD:gotocurrentpackage(playerid, params[])
{
   if(IsAdmin(playerid, ACMD_GCCP))
   {  
      SetPlayerPos(playerid, vista_CarePackage_Spawns[Random][0], vista_CarePackage_Spawns[Random][1], vista_CarePackage_Spawns[Random][2]);
   } 
   return 1; 
}

CMD:gotoccp(playerid, params[])
{
   return cmd_gotocurrentpackage(playerid, params);
}

CMD:gccp(playerid, params[])
{
   return cmd_gotocurrentpackage(playerid, params);
}

CMD:ccp(playerid, params[])
{
  return cmd_capturecarepackage(playerid, params); //Fixed this. It's cmd_xxxx not just the cmd itself ;) -Marcel
}

CMD:currentpackage(playerid, params[])
{
	if (vista_CarePackage_Main[carePackage] == -1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] There is no care package spawned yet.");
	}
	
	else
	{
	    new
			zName[30],
			string[70];
			
    	GetCarePackagePos(zName, sizeof(zName));
	    format(string, sizeof(string), "[INFO:] The current care package is at %s", zName);
	    SendClientMessage(playerid, COLOR_NOTICE, string);
	}
	
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (PRESSED(KEY_SUBMISSION) && vista_CarePackage_Main[carePackage] != -1) /* check if the middle mouse button was pressed & care package was spawned*/
	{
	    if(GetPVarInt(playerid, "vista_carep_CoolDown") == 0)
	    {
			if(IsPlayerInRangeOfPoint(playerid, CARE_PACKAGE_CAPTURE_RANGE, vista_CarePackage_Main[oPos][0], vista_CarePackage_Main[oPos][1], vista_CarePackage_Main[oPos][2]) && !IsPlayerInAnyVehicle(playerid) && GetPlayerVirtualWorld(playerid) == 0) /* Check if in range of the capture zone & player is not passenger/driver */
			{
				if(GetPlayerSpecialAction(playerid) == 0)
				{
					if(vista_CarePackage_Main[pCapturing] == -1) /* If no one else is capturing */
					{
						new
							string[45+MAX_PLAYER_NAME];

						vista_CarePackage_Main[pCapturing] = playerid; /* returns the player id for use in other functions */

						vista_CarePackage_Main[gCarePackageCaptureTimer] = SetTimer("vista_CarePackageCapture", CARE_PACKAGE_CAPTURE_TIME*1000, 0); /* Start capture timer */

						ApplyAnimation(vista_CarePackage_Main[pCapturing], "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0, 0); /* Force the player into an animation */
						ClearAnimations(vista_CarePackage_Main[pCapturing]);
						ApplyAnimation(vista_CarePackage_Main[pCapturing], "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0, 0); /* Force the player into an animation */

						GameTextForPlayer(vista_CarePackage_Main[pCapturing], "~g~Capturing care package~n~press ~y~~k~~PED_LOOKBEHIND~ ~g~to ~r~abort.", 3000, 3);

						format(string, sizeof(string), "%s is capturing the care package, go kill him!", PlayerName(playerid));
						SendClientMessageToAll(COLOR_NOTICE, string); /* Tell the whole server someone is capturing the care package */
					}
					else if(vista_CarePackage_Main[pCapturing] == playerid) /* if the player is already capping and continues pressing MMB */
					{
						vista_FailedCarePackageCapture(FAILED_CAPTURE_CANCELLED);
						SetPVarInt(playerid, "vista_carep_CoolDown", 1);
						SetTimerEx("Dev_vista_carep_cooldown", CARE_PACKAGE_COOLDOWN_TIME*1000, false, "i", playerid);
					}
					else /* If the player tries to capture whilst someone else is already capturing */
					{
						return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Someone else is already capturing the care package.");
					}
				}
				
				else
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't capture the care package while performing an animation.");
				}
			}
			else if(IsPlayerInRangeOfPoint(playerid, CARE_PACKAGE_CAPTURE_RANGE, vista_CarePackage_Main[oPos][0], vista_CarePackage_Main[oPos][1], vista_CarePackage_Main[oPos][2]) && IsPlayerInAnyVehicle(playerid)) /* If in capture range but in a vehicle */
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't capture the care package from inside a vehicle.");
			}
			
    	}
    	
    	else
    	{
            new string[63];
		    format(string, sizeof(string), "[ERROR:] You have to wait %d seconds before capturing again.", CARE_PACKAGE_COOLDOWN_TIME);
			SendClientMessage(playerid, COLOR_WARNING, string);
			return 1;
		}
 	}
 	return 1;
}

stock vista_GivePlayerReward(playerid)
{
	new Randomnr = random(100);
	switch(Randomnr)
	{
		case 0..10: // Money (11%)
		{
			GivePlayerMoney(playerid, 10000);
			SendClientMessage(playerid, COLOR_NOTICE, "You have received $10,000!");
			new string[128];
			format(string, sizeof(string), "[CAREPACKAGE]: %s (%d) gained 10000$ after picking up a care-package.", PlayerName(playerid), playerid);
			MoneyLog(string);
		}
		case 11..16: //  Explosion (6%)
		{
			for(new i = 0; i < 5; i++)
			{
				CreateExplosion(vista_CarePackage_Main[oPos][0]+i, vista_CarePackage_Main[oPos][1]+i, vista_CarePackage_Main[oPos][2], 7, 10);
			}
			
			SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: The care package was rigged to explode upon opening.");
		}
		case 17..37: //  Ammo (21%)
		{
			new weapons[13][2];
			for (new i = 0; i < 13; i++)
			{
				GetPlayerWeaponData(playerid, i, weapons[i][0], weapons[i][1]);
				if(weapons[i][0] > 21 && weapons[i][0] < 35)
				{
					GivePlayerWeapon(playerid, weapons[i][0], weapons[i][1]+1000); /* Give ammo to the player */
				}
			}

			SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: You have received 1000 ammo for each weapon.");
		}
		case 38..73: //  Weapons (36%)
		{
			new   i = random(39);

			if(i == 0 || i == 38 || i < 22) /* Add weapon IDs that you don't want spawned */
			{
				vista_GivePlayerReward(playerid);
			}

			if(i >= 22 && i <= 34)  /* Pistols, rifles, etc.. */
			{
				GivePlayerWeapon(playerid, i, 500);
				SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: You have received a random weapon.");
			}

			else if(i > 34) /* Rocket launchers, flamethrower & satchel charges */
			{
				if(i < 37 || i == 39) /* RPGs & satchel charges */
				{
					
					if(i == 35 || i == 36)
					{
					    new
					        admstr[128];
						SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
						SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: You have received a RPG.");
						format(admstr, sizeof(admstr), "[Guardian]: {%06x} %s (%d) recieved a RPG from the carepackage. ", COLOR_RED >>> 8, PlayerName(playerid),playerid);
						SendAdminMessage(1, admstr);
						new string[256];
						format(string, sizeof(string), "5[NOTICE]: %s (%d) recieved a RPG from the carepackage. ", PlayerName(playerid),playerid);
						IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
					}
					
					else
					{
					    SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: You have received satchel charges.");
					}
					GivePlayerWeapon(playerid, i, 10);
					new string[256];
					format(string, sizeof(string), "5[NOTICE]: %s (%d) recieved a Satchel-Charges from the carepackage. ", PlayerName(playerid),playerid);
					IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
				}

				else if(i == 37) /* flamethrower */
				{
					SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
					GivePlayerWeapon(playerid, i, 200);
					SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: You have received a flame thrower.");
				    new
				        admstr[128];
					format(admstr, sizeof(admstr), "[Guardian]: {%06x} %s (%d) recieved a flamethrower from the carepackage. ", COLOR_RED >>> 8, PlayerName(playerid),playerid);
					SendAdminMessage(1, admstr);
					new string[256];
					format(string, sizeof(string), "5[NOTICE]: %s (%d) recieved a Flame-thrower from the carepackage. ", PlayerName(playerid),playerid);
					IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
				}
			}
		}

		case 74..86: //  Extra Health (11%)
		{
			new Float:Health;
			
			GetPlayerHealth(playerid, Health);
			
			if(Health < 80.0)
			{
				SetPlayerHealth(playerid, 99);
				SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: You have received additional health.");
			}

			else
			{
				vista_GivePlayerReward(playerid);
			}
		}
		case 87..93: //  Extra Armour (7%)
		{
			new Float:Armour;
			
			GetPlayerHealth(playerid, Armour);
			
			if(Armour < 80.0)
			{
				SetPlayerArmour(playerid, 99);
				SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: You have received additional armour.");
			}

			else
			{
				vista_GivePlayerReward(playerid);
			}
		}
		case 94..101: //  Minigun (6%)
		{
			SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			GivePlayerWeapon(playerid, 38, 200);
			SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: You have received a minigun.");
			new string[128];
			format(string, sizeof(string), "[Guardian]: {%06x}%s (%d) recieved a Minigun from the carepackage.", COLOR_RED >>> 8, PlayerName(playerid),playerid);
			SendAdminMessage(1,string);
			AdminLog(string);
			format(string, sizeof(string), "5[NOTICE]: %s (%d) recieved a MINIGUN from the carepackage. ", PlayerName(playerid),playerid);
			IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		}
	}
	return 1;
}

public Dev_vista_carep_cooldown(playerid)
{
	SetPVarInt(playerid, "vista_carep_CoolDown", 0);
	return 1;
}

stock vista_FailedCarePackageCapture(failure_id) /* In case of a failed capture */
{
	new
		string[55+MAX_PLAYER_NAME];
	
	KillTimer(vista_CarePackage_Main[gCarePackageCaptureTimer]); /* Kill capture timer */
	ClearAnimations(vista_CarePackage_Main[pCapturing]);
	
	switch(failure_id) /* What causes the capture to fail? */
	{
		case FAILED_CAPTURE_ENTERED_CAR: /* Player entered a car while capturing */
		{
			format(string, sizeof(string), "%s has failed to capture the care package!", PlayerName(vista_CarePackage_Main[pCapturing]));
			SendClientMessageToAll(COLOR_NOTICE, string);
			SendClientMessage(vista_CarePackage_Main[pCapturing], COLOR_WARNING, "[ERROR]: You failed to capture the care package because you entered a car.");
		}

		case FAILED_CAPTURE_DIED: /* Player died while capturing */
		{
			format(string, sizeof(string), "%s has died while capturing the care package. Go get it!", PlayerName(vista_CarePackage_Main[pCapturing]));
			SendClientMessageToAll(COLOR_NOTICE, string);
		}

		case FAILED_CAPTURE_LEFT_ZONE: /* Player left the zone while capturing */
		{
			format(string, sizeof(string), "%s has failed to capture the care package", PlayerName(vista_CarePackage_Main[pCapturing]));
			SendClientMessageToAll(COLOR_NOTICE, string);
		}

		case FAILED_CAPTURE_CANCELLED:
		{
			format(string, sizeof(string), "%s has cancelled the capture.", PlayerName(vista_CarePackage_Main[pCapturing]));
			SendClientMessageToAll(COLOR_NOTICE, string);
			SendClientMessage(vista_CarePackage_Main[pCapturing], COLOR_NOTICE,"[INFO]: You cancelled the capture.");
		}
	}
	
	vista_CarePackage_Main[pCapturing] = -1; /* Reset playerid */
	
	return 1;
}

stock vista_CaptureSuccessful(playerid) /* If the capture was successful */
{
	new
		string[45+MAX_PLAYER_NAME];
		//carepquery[128 + MAX_PLAYER_NAME];
	

	vista_CarePackage_Main[gCarePackageSpawnTimer] = SetTimer("vista_CarePackageSpawn", CARE_PACKAGE_RESPAWN_TIME*60000, true); /* Care package respawn timer, in minutes */
	format(string, sizeof(string), "%s has successfully captured the care package!", PlayerName(vista_CarePackage_Main[pCapturing]));
	SendClientMessageToAll(COLOR_NOTICE, string); /* Tell everyone the care package was captured */
	GiveAchievement(vista_CarePackage_Main[pCapturing], 89);
	
	GameTextForPlayer(playerid,"~g~Care Package captured", 2000, 3);
	
	vista_GivePlayerReward(vista_CarePackage_Main[pCapturing]); /* Give reward, can be done like the event rewards, random loot */
	
	ClearAnimations(vista_CarePackage_Main[pCapturing]); /* Clear animation after the capture is done */

	FoCo_PlayerStats_carepackage[vista_CarePackage_Main[pCapturing]]++;
	//format(carepquery, sizeof(carepquery), "UPDATE `TBLNAME` SET `FIELDNAME  = `FIELDNAME` + 1 WHERE `USERNAMEFIELD` = %s", PlayerName(playerid));
	
	DestroyDynamicObject(vista_CarePackage_Main[carePackage]); /* Destroy the care package object */
	vista_CarePackage_Main[carePackage] = -1; // Set to -1 (False) for use in care package spawn checks
	vista_CarePackage_Main[pCapturing] = -1; /* No one is capturing anymore, reset playerid */
	return 1;
}

stock GetCarePackagePos(str[], len)
{
 	for(new i = 0; i != sizeof(gSAZones); i++ )
 	{
		if(vista_CarePackage_Main[oPos][0] >= gSAZones[i][SAZONE_AREA][0] && vista_CarePackage_Main[oPos][0] <= gSAZones[i][SAZONE_AREA][3] && vista_CarePackage_Main[oPos][1] >= gSAZones[i][SAZONE_AREA][1] && vista_CarePackage_Main[oPos][1] <= gSAZones[i][SAZONE_AREA][4])
		{
		    return format(str, len, gSAZones[i][SAZONE_NAME], 0);
		}
	}
	return 0;

}
