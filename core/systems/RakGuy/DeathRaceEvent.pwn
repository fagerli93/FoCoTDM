#include <YSI\y_hooks>

#define NILVALUE -1

#define EVENT_DRACE 24

#define KEY_MISSILE 	KEY_FIRE
#define KEY_BOOST 		KEY_ACTION
#define KEY_FIXCAR 		KEY_SUBMISSION
#define KEY_SMOKE 		KEY_CROUCH
#define KEY_FLIP    	KEY_YES
#define KEY_EXPLOSIVE 	KEY_NO

#define DR_CPCount 37
#define DR_SPCount 50
#define DR_PKCount 56

#define DR_VEH          495

#define DR_TotalLaps 3

#define DR_VWORLD   1400

#define DR_SMOKETIMER 25000
#define DR_ROCKETTIMER 100
#define DR_PICKUPTIMER 120000

////////////////////////////////////////////////////////////////////////////////
/*******************************FORWARDS**************************************/
////////////////////////////////////////////////////////////////////////////////
forward DR_EventEnd(playerid);
forward DR_EventStart(playerid);
forward DR_EventJoin(playerid);
forward DR_PlayerDeath(playerid);
forward DR_LeaveEvent(playerid);
////////////////////////////////////////////////////////////////////////////////
/****************************End Of Forwards***********************************/
////////////////////////////////////////////////////////////////////////////////

/*============================================================================*/

////////////////////////////////////////////////////////////////////////////////
/*******************************VARIABLES**************************************/
////////////////////////////////////////////////////////////////////////////////

new Float:DR_CheckPoints[DR_CPCount][3]=
{
	{1396.64099, -1035.26111, 23.38942},
	{979.91583, -1039.52185, 28.82310},
	{962.70343, -983.44916, 37.42579},
	{1456.54358, -962.85754, 34.66057},
	{1585.77710, -1083.82739, 55.46940},
	{1626.84839, -1015.14935, 49.97887},
	{1779.78906, -955.29321, 42.12716},
	{1704.23047, -760.70667, 51.16949},
	{1646.72339, -829.97528, 57.06594},
	{1458.14575, -943.35162, 34.65803},
	{1416.32654, -862.13214, 46.44249},
	{1371.57007, -693.80530, 89.35403},
	{995.88403, -788.40924, 98.85836},
	{755.45087, -804.59528, 65.14220},
	{503.41794, -990.54828, 87.30168},
	{671.71393, -1066.44739, 47.79745},
	{580.18213, -1178.79138, 43.62141},
	{96.15796, -1514.96191, 5.31932},
	{285.52917, -1696.01660, 6.25783},
	{855.52411, -1776.79761, 12.29257},
	{1054.74158, -1891.50525, 11.80235},
	{1244.94250, -2449.96558, 7.72959},
	{1376.69910, -2653.27148, 12.13638},
	{2166.79199, -2550.52808, 12.17477},
	{2224.90112, -2553.22510, 12.07494},
	{2454.64087, -2663.60034, 12.10192},
	{2528.35498, -2504.78369, 12.22134},
	{2576.71484, -2405.80200, 12.38318},
	{2411.57910, -2427.03076, 12.02024},
	{2289.17041, -2304.80640, 11.96022},
	{2823.01514, -2095.98022, 9.68699},
	{2858.61987, -1137.37146, 9.52850},
	{2191.18335, -1123.83887, 23.43152},
	{2069.29150, -1191.69775, 22.27859},
	{1848.23718, -1181.36609, 22.26856},
	{1675.51355, -1160.81042, 22.25823},
	{1633.44421, -1061.85840, 22.54801}
};

enum DR_PickDet
{
	Float:DR_X,
	Float:DR_Y,
	Float:DR_Z,
	DR_Pid,
	DR_Ptype,
	bool:DR_Taken
}
new DR_FinishCount;
new Timer:DR_PickupTimer;

new DR_Picks[DR_PKCount][DR_PickDet]=
{
	{1236.13684, -1039.20459, 31.45606,-1,0,false},
	{973.64130, -966.50989, 39.67673,-1,0,false},
	{1000.44653, -943.02618, 41.91649,-1,0,false},
	{1538.19470, -1016.79889, 43.72987,-1,0,false},
	{1769.63782, -948.14319, 45.78976,-1,0,false},
	{1398.99792, -886.59271, 39.14612,-1,0,false},
	{1525.34766, -812.93829, 71.19678,-1,0,false},
	{1433.87048, -741.90790, 84.43425,-1,0,false},
	{1111.03857, -768.96503, 109.16089,-1,0,false},
	{936.17566, -757.22272, 106.14787,-1,0,false},
	{923.47388, -784.41669, 114.43939,-1,0,false},
	{505.49155, -1002.48090, 89.39697,-1,0,false},
	{693.68085, -994.91644, 51.91307,-1,0,false},
	{474.63528, -1227.27405, 47.23481,-1,0,false},
	{176.14923, -1409.84583, 45.27814,-1,0,false},
	{106.85001, -1526.32080, 6.58233,-1,0,false},
	{385.73541, -1709.23364, 7.40346,-1,0,false},
	{831.63696, -1776.49121, 13.26884,-1,0,false},
	{1018.72681, -1842.82776, 13.04958,-1,0,false},
	{988.72333, -2153.83643, 13.40328,-1,0,false},
	{1000.81097, -2224.46631, 12.78825,-1,0,false},
	{1283.86560, -2504.89404, 12.94464,-1,0,false},
	{1523.72717, -2684.77173, 9.04590,-1,0,false},
	{1522.27869, -2669.90479, 9.42433,-1,0,false},
	{1537.57410, -2711.56226, 13.26654,-1,0,false},
	{2204.75854, -2517.64209, 13.92463,-1,0,false},
	{2224.35840, -2512.60864, 13.56966,-1,0,false},
	{2248.55029, -2647.38232, 13.10924,-1,0,false},
	{2498.27686, -2613.62769, 13.47891,-1,0,false},
	{2760.56812, -2432.66772, 13.34785,-1,0,false},
	{2761.65161, -2479.80444, 13.27712,-1,0,false},
	{2538.94385, -2484.46362, 14.36125,-1,0,false},
	{2300.69873, -2316.60571, 13.18062,-1,0,false},
	{2360.05469, -2205.83203, 13.76915,-1,0,false},
	{2829.75098, -2068.25562, 10.75088,-1,0,false},
	{2856.42505, -1982.92786, 11.21539,-1,0,false},
	{2848.29102, -1727.59106, 11.00056,-1,0,false},
	{2906.00562, -1412.27869, 10.95658,-1,0,false},
	{2926.05249, -1411.69788, 10.95658,-1,0,false},
	{2878.21997, -1153.59680, 10.94895,-1,0,false},
	{2660.78711, -1153.53528, 53.62396,-1,0,false},
	{2474.17261, -1162.69922, 36.86304,-1,0,false},
	{2436.23853, -1143.52771, 32.84914,-1,0,false},
	{2219.59253, -1141.19177, 25.37399,-1,0,false},
	{2156.84424, -1171.69958, 23.60568,-1,0,false},
	{2069.92139, -1115.96167, 24.06579,-1,0,false},
	{2032.64343, -1136.14502, 23.94324,-1,0,false},
	{2048.77759, -1191.00745, 23.27960,-1,0,false},
	{1977.68848, -1157.39404, 20.87598,-1,0,false},
	{1980.91968, -1233.98523, 19.83696,-1,0,false},
	{1996.63977, -1260.98389, 23.67936,-1,0,false},
	{1970.18652, -1206.70581, 25.14516,-1,0,false},
	{1768.24036, -1167.49573, 23.30041,-1,0,false},
	{1603.27478, -1054.41223, 23.77611,-1,0,false},
	{1546.74426, -1054.38025, 23.57288,-1,0,false},
	{1394.75195, -1025.17749, 24.78643,-1,0,false}
};


new bool:IsPickUpsOn;

enum DR_PlPicks
{
	DR_NoExpl,
	DR_NoFlip,
	DR_NoRket,
	DR_NoSmok,
	DR_NoRepr,
	DR_NoBost,
	DR_VehID,
	DR_RocketPickupID,
	DR_Kills,
	DR_Pending,
	Float:DR_ExplosivePos[3],
	DR_Laps,
	DR_CheckPoint
}

new DR_PlayerInfo[MAX_PLAYERS][DR_PlPicks];
new DRace_JoinCount;
new DRace_Alive;
new DR_CheckPIDs[DR_CPCount+1];


new PlayerText:DR_TextDrawIDs[MAX_PLAYERS];

enum DR_VehDet
{
	Float:DR_VX,
	Float:DR_VY,
	Float:DR_VZ,
	Float:DR_VA,
	DR_VehID,
	bool:DR_VehSmoke,
	DR_SmokeObjIDs[4],
	DR_MissileObjID,
	Timer:DR_MissileT,
	Timer:DR_SmokeT
}
new DR_Vehicles[DR_SPCount][DR_VehDet]=
{
	{1757.0861, -1021.8454, 23.5957, 89.7000},
	{1757.0157, -1016.3448, 23.5957, 89.7000},
	{1734.2283, -1047.1549, 23.5957, 89.7000},
	{1734.0768, -1052.2604, 23.5957, 89.7000},
	{1742.2938, -1049.8167, 23.5957, 89.8200},
	{1742.3477, -1054.7700, 23.5957, 89.7000},
	{1764.0945, -1024.6858, 23.5957, 89.7000},
	{1763.3278, -1019.1365, 23.5957, 89.8200},
	{1770.4303, -1021.4247, 23.5957, 89.7000},
	{1770.9094, -1015.0564, 23.5957, 89.7600},
	{1764.5112, -1047.8475, 23.5957, 89.8800},
	{1763.8285, -1052.4558, 23.5957, 89.7000},
	{1749.7140, -1052.3177, 23.5957, 89.7000},
	{1750.3845, -1047.6666, 23.5957, 89.7000},
	{1757.2659, -1049.8928, 23.5957, 89.7000},
	{1757.0701, -1054.5789, 23.5957, 89.7000},
	{1736.8414, -1025.7769, 23.5957, 89.7000},
	{1737.1636, -1019.9274, 23.5957, 89.7000},
	{1743.2732, -1022.7598, 23.5957, 89.8200},
	{1742.8743, -1028.9585, 23.5957, 89.7000},
	{1749.5642, -1025.3933, 23.5957, 89.7000},
	{1749.8264, -1019.0720, 23.5957, 89.7000},
	{1700.4161, -1049.4888, 23.5957, 89.7000},
	{1700.2906, -1044.3564, 23.5957, 89.7000},
	{1708.0947, -1046.9915, 23.5957, 89.8200},
	{1707.8876, -1051.9172, 23.5957, 89.7000},
	{1714.9897, -1049.4387, 23.5957, 89.7000},
	{1715.3922, -1044.7593, 23.5957, 89.7000},
	{1722.0037, -1046.9581, 23.5957, 89.7000},
	{1721.5359, -1051.6160, 23.5957, 89.7000},
	{1728.0187, -1049.4648, 23.5957, 89.7000},
	{1728.4224, -1044.8284, 23.5957, 89.8800},
	{1706.4824, -1035.3057, 23.5957, 89.7000},
	{1700.2502, -1032.2388, 23.5957, 89.7000},
	{1700.3890, -1026.5074, 23.5957, 89.7000},
	{1706.3135, -1029.4595, 23.5957, 89.8200},
	{1712.4163, -1032.2145, 23.5957, 89.7000},
	{1712.4871, -1026.0183, 23.5957, 89.7000},
	{1719.4816, -1023.4178, 23.5957, 89.7000},
	{1725.5966, -1026.3390, 23.5957, 89.8200},
	{1719.1534, -1029.1802, 23.5957, 89.7000},
	{1725.9583, -1032.1542, 23.5957, 89.7000},
	{1732.0864, -1029.0314, 23.5957, 89.7000},
	{1732.3546, -1022.8034, 23.5957, 89.7600},
	{1756.3756, -1028.5303, 23.5957, 89.7000},
	{1770.4303, -1021.4247, 23.5957, 89.7000},
	{1769.9840, -1027.8892, 23.5957, 89.7000},
	{1715.0167, -1054.8716, 23.5957, 89.7000},
	{1721.8082, -1057.2952, 23.5957, 89.7000},
	{1728.0232, -1054.4506, 23.5957, 89.7000}
};

new DR_MSG[1000];
new Float:SmokePos[4][3]=
{
	{0.199999, -1.899998, -0.374999},
	{-0.199999, -1.899998, -0.374999},
	{0.694999, -1.899998, -0.374999},
	{-0.694999, -1.899998, -0.374999}
};
////////////////////////////////////////////////////////////////////////////////
/*******************************End Of Variables*******************************/
////////////////////////////////////////////////////////////////////////////////
/*============================================================================*/

////////////////////////////////////////////////////////////////////////////////
/******************************Event Stocks************************************/
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////CHECK POINTS////////////////////////////////////

stock DR_CreateCheckPoints()
{
	for(new i=0; i<DR_CPCount; i++)
	{
		if(DR_CheckPIDs[i]!=-1)
		{
		    DestroyDynamicRaceCP(DR_CheckPIDs[i]);
		}
	    if(i!=DR_CPCount-1)
			DR_CheckPIDs[i]=CreateDynamicRaceCP(0, DR_CheckPoints[i][0], DR_CheckPoints[i][1], DR_CheckPoints[i][2], DR_CheckPoints[i+1][0], DR_CheckPoints[i+1][1], DR_CheckPoints[i+1][2], 15.0, DR_VWORLD, -1, -1, 500.0);
		else
		    DR_CheckPIDs[i]=CreateDynamicRaceCP(1, DR_CheckPoints[i][0], DR_CheckPoints[i][1], DR_CheckPoints[i][2], DR_CheckPoints[0][0], DR_CheckPoints[0][1], DR_CheckPoints[0][2], 15.0, DR_VWORLD, -1, -1, 500.0);

	}
	if(DR_CheckPIDs[DR_CPCount]!=-1)
	{
	    DestroyDynamicRaceCP(DR_CheckPIDs[DR_CPCount]);
	}
	DR_CheckPIDs[DR_CPCount]=CreateDynamicRaceCP(1, DR_CheckPoints[DR_CPCount-1][0], DR_CheckPoints[DR_CPCount-1][1], DR_CheckPoints[DR_CPCount-1][2], DR_CheckPoints[0][0], DR_CheckPoints[0][1], DR_CheckPoints[0][2], 15.0, DR_VWORLD, -1, -1, 150.0);
	foreach(Player, i)
	{
    	TogglePlayerAllDynamicRaceCPs(i, 0);
	}
}

stock DR_DestroyRaceCPs()
{
	for(new i=0; i<DR_CPCount+1; i++)
	{
		DestroyDynamicRaceCP(DR_CheckPIDs[i]);
	}
	return 1;
}
////////////////////////////////Vehicle Stocks//////////////////////////////////
stock DR_CreateVehicle(playerid)
{
    DR_PlayerInfo[playerid][DR_VehID]=CreateVehicle(DR_VEH, DR_Vehicles[DRace_JoinCount][DR_VX], DR_Vehicles[DRace_JoinCount][DR_VY], DR_Vehicles[DRace_JoinCount][DR_VZ], DR_Vehicles[DRace_JoinCount][DR_VA], random(254), random(254), 100000);
	SetVehicleVirtualWorld(DR_PlayerInfo[playerid][DR_VehID], DR_VWORLD);
	SetPlayerPos(playerid, DR_Vehicles[DRace_JoinCount][DR_VX], DR_Vehicles[DRace_JoinCount][DR_VY], DR_Vehicles[DRace_JoinCount][DR_VZ]);
	SetCameraBehindPlayer(playerid);
	PutPlayerInVehicle(playerid, DR_PlayerInfo[playerid][DR_VehID], 0);
	DR_Vehicles[DRace_JoinCount][DR_VehID]=DR_PlayerInfo[playerid][DR_VehID];
	DR_Vehicles[DRace_JoinCount][DR_VehSmoke]=false;
	DR_Vehicles[DRace_JoinCount][DR_SmokeObjIDs]={0,0,0,0};
	DR_Vehicles[DRace_JoinCount][DR_MissileObjID]=0;
	return 1;
}

stock DR_DeleteVehicle(playerid)
{
	if(DR_PlayerInfo[playerid][DR_VehID]>0)
	{
		RemovePlayerFromVehicle(playerid);
		DestroyVehicle(DR_PlayerInfo[playerid][DR_VehID]);
	}
	return 1;
}

stock GetVehicleSlot(vehicleid)
{
	for(new i = 0; i<DR_SPCount;i++)
	{
	    if(vehicleid==DR_Vehicles[i][DR_VehID])
	        return i;
	}
	return -1;
}

/////////////////////////////////Pickup Stocks//////////////////////////////////

stock DR_IsEventPickup(pickupid)
{
	for(new i=0; i<DR_PKCount; i++)
	{
	    if(pickupid == DR_Picks[i][DR_Pid])
	        return i;
	}
	return -1;
}

stock DR_CreatePickups()
{
	new Pickups[6]={3884, 1240, 1241, 1254, 343,1273};
	for(new i=0; i<DR_PKCount; i++)
	{
		if(DR_Picks[i][DR_Pid]!= -1)
		{
			DestroyDynamicPickup(DR_Picks[i][DR_Pid]);
        	DR_Picks[i][DR_Pid]=-1;
        	DR_Picks[i][DR_Taken]=false;
		}
	    DR_Picks[i][DR_Ptype]=Pickups[random(6)];
		DR_Picks[i][DR_Pid]=CreateDynamicPickup(DR_Picks[i][DR_Ptype],14,DR_Picks[i][DR_X],DR_Picks[i][DR_Y],DR_Picks[i][DR_Z], DR_VWORLD);
        DR_Picks[i][DR_Taken]=false;
	}
	//
	return 1;
}

stock DR_DestroyPickups()
{
    for(new i=0; i<DR_PKCount; i++)
	{
		DestroyDynamicPickup(DR_Picks[i][DR_Pid]);
        DR_Picks[i][DR_Pid]=-1;
        DR_Picks[i][DR_Taken]=false;
	}
}

stock DR_IsPlayerPickup(pickupid)
{
	foreach(Player, i)
	{
	    if(pickupid==DR_PlayerInfo[i][DR_RocketPickupID])
			return i;
	}
	return -1;
}

////////////////////////////////OBJECT Stocks///////////////////////////////////
stock GetObjectSlot(objectid)
{
	for(new i = 0; i<DR_SPCount;i++)
	{
	    if(objectid==DR_Vehicles[i][DR_MissileObjID])
	        return i;
	}
	return -1;
}

//////////////////////////////TEXTDRAW Stocks///////////////////////////////////
stock CreateDRPText(playerid)
{
	format(DR_MSG, sizeof(DR_MSG), "Controls:~n~~b~MISSILE[%i]-~r~~k~~VEHICLE_FIREWEAPON~~n~~b~BOOST[%i]-~r~~k~~VEHICLE_FIREWEAPON_ALT~~n~~b~FIXCAR[%i]-~r~~k~~TOGGLE_SUBMISSIONS~",DR_PlayerInfo[playerid][DR_NoRket],DR_PlayerInfo[playerid][DR_NoBost],DR_PlayerInfo[playerid][DR_NoRepr]);
	format(DR_MSG, sizeof(DR_MSG), "%s~n~~b~SMOKE[%i]-~r~H/CAPSLOCK~n~~b~FLIP[%i]-~r~~k~~CONVERSATION_YES~~n~~b~EXPLOSIVE[%i]-~r~~k~~CONVERSATION_NO~",DR_MSG,DR_PlayerInfo[playerid][DR_NoSmok],DR_PlayerInfo[playerid][DR_NoFlip],DR_PlayerInfo[playerid][DR_NoExpl]);
	DR_TextDrawIDs[playerid] = CreatePlayerTextDraw(playerid, 518.0, 287.0 , DR_MSG);
   	PlayerTextDrawLetterSize(playerid, DR_TextDrawIDs[playerid], 0.4,1.8);
   	PlayerTextDrawFont(playerid, DR_TextDrawIDs[playerid], 1);
   	PlayerTextDrawAlignment(playerid, DR_TextDrawIDs[playerid], 2);
	PlayerTextDrawColor(playerid, DR_TextDrawIDs[playerid] , 0x349D22FF);
	PlayerTextDrawSetOutline(playerid, DR_TextDrawIDs[playerid] , 1);
	PlayerTextDrawSetProportional(playerid, DR_TextDrawIDs[playerid] , 1);
	PlayerTextDrawSetShadow(playerid, DR_TextDrawIDs[playerid] , 1);
	PlayerTextDrawShow(playerid, DR_TextDrawIDs[playerid]);
	return 1;
}

stock UpdateDRPText(playerid)
{
	format(DR_MSG, sizeof(DR_MSG), "Controls:~n~~b~MISSILE[%i]-~r~~k~~VEHICLE_FIREWEAPON~~n~~b~BOOST[%i]-~r~~k~~VEHICLE_FIREWEAPON_ALT~~n~~b~FIXCAR[%i]-~r~~k~~TOGGLE_SUBMISSIONS~",DR_PlayerInfo[playerid][DR_NoRket],DR_PlayerInfo[playerid][DR_NoBost],DR_PlayerInfo[playerid][DR_NoRepr]);
	format(DR_MSG, sizeof(DR_MSG), "%s~n~~b~SMOKE[%i]-~r~H/CAPSLOCK~n~~b~FLIP[%i]-~r~~k~~CONVERSATION_YES~~n~~b~EXPLOSIVE[%i]-~r~~k~~CONVERSATION_NO~",DR_MSG,DR_PlayerInfo[playerid][DR_NoSmok],DR_PlayerInfo[playerid][DR_NoFlip],DR_PlayerInfo[playerid][DR_NoExpl]);
	PlayerTextDrawSetString(playerid, DR_TextDrawIDs[playerid], DR_MSG);
	return 1;
}

stock DeleteDRPText(playerid)
{
	PlayerTextDrawDestroy(playerid, DR_TextDrawIDs[playerid]);
	DR_TextDrawIDs[playerid]=PlayerText:-1;
	return 1;
}

///////////////////////////////////////MISSILE//////////////////////////////////
stock DR_GetMissileOwner(vehicleslot)
{
	new DR_VFlag;
	foreach(Player, i)
	{
	    if(DR_Vehicles[vehicleslot][DR_VehID]==DR_PlayerInfo[i][DR_VehID])
		{
		    DR_VFlag=i;
		    break;
		}
	}
	return DR_VFlag;
}

stock DR_ExplosionMark(playerid, Float:Radius, Float:PosX, Float:PosY, Float:PosZ)
{
	foreach(Player, i)
	{
		if(IsPlayerInRangeOfPoint(i, Radius,PosX, PosY, PosZ)&&i!=playerid)
		{
			DR_PlayerInfo[i][DR_Pending]=playerid;
		}
	}
	return 1;
}

////////////////////////////////////////////////////////////////////////////////
/**********************End of Event Stock Functions****************************/
////////////////////////////////////////////////////////////////////////////////

/*============================================================================*/

////////////////////////////////////////////////////////////////////////////////
/*********************************TIMERS***************************************/
////////////////////////////////////////////////////////////////////////////////
timer DR_DeleteMissile[DR_ROCKETTIMER](DR_vid)
{
	new Float:Pos[3];
	new playerid = DR_GetMissileOwner(DR_vid);
	GetDynamicObjectPos(DR_Vehicles[DR_vid][DR_MissileObjID], Pos[0], Pos[1], Pos[2]);
	foreach(Player, i)
	{
	    if(i!=playerid)
		{
			if(GetPlayerVehicleID(i)!=DR_vid && GetPVarInt(i, "InEvent")==1&&IsPlayerInRangeOfPoint(i, 10.0, Pos[0], Pos[1], Pos[2]))
			{
				StopDynamicObject(DR_Vehicles[DR_vid][DR_MissileObjID]);
				DestroyDynamicObject(DR_Vehicles[DR_vid][DR_MissileObjID]);
		        DR_Vehicles[DR_vid][DR_MissileObjID]=-1;
				GetPlayerPos(i, Pos[0] ,Pos[1], Pos[2]);
				if(IsPlayerInRangeOfPoint(playerid, 10.0, Pos[0], Pos[1], Pos[2]))
				{
				    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Missile diffused because you are too close to explosion point.");
				}
				else if(DR_PlayerInfo[i][DR_NoRepr]>=1)
				{
				    DR_PlayerInfo[i][DR_Pending]=playerid;
					CreateExplosion(Pos[0] ,Pos[1], Pos[2], 10, 15.0);
				}
				else
				{
	   				CreateExplosion(Pos[0] ,Pos[1], Pos[2], 10, 15.0);
					SetVehicleHealth(DR_PlayerInfo[i][DR_VehID], 149.0);
					DR_PlayerInfo[i][DR_Pending]=playerid;
				}
	   		    DR_ExplosionMark(playerid, 15.0, Pos[0],Pos[1],Pos[2]);
				stop DR_Vehicles[DR_vid][DR_MissileT];
				break;
			}
		}
	}
}

timer DR_DeleteSmokeMachine[DR_SMOKETIMER](vehid)
{
	for(new i=0; i<4; i++)
	{
	    DestroyDynamicObject(DR_Vehicles[vehid][DR_SmokeObjIDs][i]);
	}
	DR_Vehicles[vehid][DR_VehSmoke]=false;
	stop DR_Vehicles[vehid][DR_SmokeT];
}

timer RemakePickups[DR_PICKUPTIMER]()
{
    DR_DestroyPickups();
    DR_CreatePickups();
    if(IsPickUpsOn==false)
    {
        IsPickUpsOn=true;
		foreach(Player, i)
	    {
	        if(Event_ID == EVENT_DRACE && GetPVarInt(i, "InEvent") == 1)
	        {
	            SendClientMessage(i, COLOR_NOTICE, "[NOTICE]: Pickups have been Enabled.");
	        }
	    }
    }
	else
	{
		foreach(Player, i)
	    {
	        if(Event_ID == EVENT_DRACE && GetPVarInt(i, "InEvent") == 1)
	        {
	            SendClientMessage(i, COLOR_NOTICE, "[NOTICE]: New Pickups are now available.");
	        }
	    }
	 }
}

/******************************END OF TIMERS***********************************/
////////////////////////////////////////////////////////////////////////////////

/*============================================================================*/

////////////////////////////////////////////////////////////////////////////////
/*****************************EVENT FUNCTIONS**********************************/
public DR_EventStart(playerid)
{
    DR_CreateCheckPoints();
	foreach(Player, i)
    {
    	DR_PlayerInfo[i][DR_NoExpl]=0;
		DR_PlayerInfo[i][DR_NoFlip]=0;
		DR_PlayerInfo[i][DR_NoRket]=0;
		DR_PlayerInfo[i][DR_NoSmok]=0;
		DR_PlayerInfo[i][DR_NoRepr]=0;
		DR_PlayerInfo[i][DR_NoBost]=0;
		DR_PlayerInfo[i][DR_VehID]=0;
		DR_PlayerInfo[i][DR_RocketPickupID]=-1;
		DR_PlayerInfo[i][DR_Pending]=-1;
		DR_PlayerInfo[i][DR_Kills]=0;
        DR_PlayerInfo[i][DR_Laps]=0;
		DR_PlayerInfo[i][DR_CheckPoint]=0;
		FoCo_Event_Died[i]=0;
	    SetPVarInt(i, "InEvent", 0);
	    DR_TextDrawIDs[i]=PlayerText:-1;
    }
    DR_FinishCount=0;
    IsPickUpsOn=false;
    DR_DestroyPickups();
    format(DR_MSG, sizeof(DR_MSG), "[EVENT]: %s %s has started {%06x}Death Race {%06x}event.  Type /join to join event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_NOTICE >>> 8);
    SendClientMessageToAll(COLOR_NOTICE, DR_MSG);
    Event_InProgress = 0;
	Event_ID = EVENT_DRACE;
	DRace_JoinCount=0;
	DRace_Alive=0;
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, DR_MSG);
	//SetTimer("deathr_OneSecond", 30000, false);
	DR_CreatePickups();
	DR_PickupTimer = repeat RemakePickups();
	return 1;
}

public DR_EventEnd(playerid)
{
	new DR_MostKills=-1;
	new DR_MostKiller;
	foreach(Player, i)
    {
		if(GetPVarInt(i, "InEvent")==1)
        {
            RemovePlayerFromVehicle(i);
            SetVehicleToRespawn(DR_PlayerInfo[i][DR_VehID]);
			SpawnPlayer(i);
			if(DR_PlayerInfo[i][DR_RocketPickupID]!=-1)
				DestroyDynamicPickup(DR_PlayerInfo[i][DR_RocketPickupID]);
		    DR_PlayerInfo[i][DR_RocketPickupID]=-1;
			DR_PlayerInfo[i][DR_NoExpl]=0;
			DR_PlayerInfo[i][DR_NoFlip]=0;
			DR_PlayerInfo[i][DR_NoRket]=0;
			DR_PlayerInfo[i][DR_NoSmok]=0;
			DR_PlayerInfo[i][DR_NoRepr]=0;
			DR_PlayerInfo[i][DR_NoBost]=0;
			DR_PlayerInfo[i][DR_Laps]=0;
			DR_PlayerInfo[i][DR_CheckPoint]=0;
			DR_PlayerInfo[i][DR_Pending]=-1;
			DeleteDRPText(i);
			new DR_PSlot=GetVehicleSlot(DR_PlayerInfo[i][DR_VehID]);
			if(DR_Vehicles[DR_PSlot][DR_VehSmoke]==true)
			{
			    for(new j = 0; j<4 ; j++)
			    {
			    	DestroyDynamicObject(DR_Vehicles[DR_PSlot][DR_SmokeObjIDs][j]);
			    	DR_Vehicles[DR_PSlot][DR_SmokeObjIDs][j]=-1;
			    	stop DR_Vehicles[DR_PSlot][DR_SmokeT];
			    }
			}
			if(IsValidDynamicObject(DR_Vehicles[DR_PSlot][DR_MissileObjID])&&IsDynamicObjectMoving(DR_Vehicles[DR_PSlot][DR_MissileObjID]))
			{
				StopDynamicObject(DR_Vehicles[DR_PSlot][DR_MissileObjID]);
				DR_Vehicles[DR_PSlot][DR_MissileObjID]=-1;
				DestroyDynamicObject(DR_Vehicles[DR_PSlot][DR_MissileObjID]);
				stop DR_Vehicles[DR_PSlot][DR_MissileT];
			}
			DestroyVehicle(DR_Vehicles[DR_PSlot][DR_VehID]);
			DR_Vehicles[DR_PSlot][DR_VehID]=0;
			DR_PlayerInfo[i][DR_VehID]=0;
        }
        if(FoCo_Event_Died[i]>=0)
        {
 			format(DR_MSG, sizeof(DR_MSG), "[EVENT NOTICE]: You have killed %i players in DeathRace event. ", DR_PlayerInfo[i][DR_Kills]);
			SendClientMessage(i, COLOR_NOTICE,DR_MSG);
            if(DR_PlayerInfo[i][DR_Kills]>DR_MostKills)
			{
			    DR_MostKiller=i;
			    DR_MostKills=DR_PlayerInfo[i][DR_Kills];
			}
		}
	    FoCo_Event_Died[i] = 0;
	    SetPVarInt(i, "InEvent", 0);
    }
   	DR_DestroyRaceCPs();
	for(new i; i<DRace_JoinCount; i++)
	{
	    if(GetVehicleModel(DR_Vehicles[i][DR_VehID])==DR_VEH&&DR_Vehicles[i][DR_VehID]!=0)
		{
			DestroyVehicle(DR_Vehicles[i][DR_VehID]);
		}
	}
	if(DR_MostKills>0)
	{
		format(DR_MSG, sizeof(DR_MSG), "[EVENT NOTICE]: %s has killed the most in Death-Race Event. Kills: %i", PlayerName(DR_MostKiller),DR_MostKills);
		SendClientMessageToAll(COLOR_GREEN,DR_MSG);
	}
	Event_ID=NILVALUE;
	SendClientMessageToAll(COLOR_NOTICE, "[NOTICE]: Death Race Event has been ended.");
	Event_InProgress = -1;
 	DR_FinishCount=0;
    IsPickUpsOn=false;
	DR_DestroyPickups();
	stop DR_PickupTimer;
	return 1;
}
public deathr_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Area 51 DM is now in progress and can not be joined");
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
 	Event_InProgress=1;
	return 1;
}

public DR_EventJoin(playerid)
{
	if(DRace_JoinCount==50)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "Event Full Mofocka");//Debug
	}
	ResetPlayerWeapons(playerid);
	DR_PlayerInfo[playerid][DR_CheckPoint]=0;
	SetPVarInt(playerid, "InEvent", 1);
	SetPlayerVirtualWorld(playerid, DR_VWORLD);
    SetPlayerInterior(playerid, 0);
	DR_CreateVehicle(playerid);
	CreateDRPText(playerid);
	SetPlayerHealth(playerid, 99.0);
	SetPlayerArmour(playerid, 99.0);
	DRace_JoinCount++;
	DRace_Alive++;
	TogglePlayerDynamicRaceCP(playerid, DR_CheckPIDs[DR_PlayerInfo[playerid][DR_CheckPoint]], 1);
	TogglePlayerControllable(playerid, 0);
	return 1;
}

public DR_PlayerDeath(playerid)
{
    FoCo_Event_Died[playerid]=1;
    SetPVarInt(playerid, "InEvent", 0);
	if(DR_PlayerInfo[playerid][DR_RocketPickupID]!=-1)
		DestroyDynamicPickup(DR_PlayerInfo[playerid][DR_RocketPickupID]);
    DR_PlayerInfo[playerid][DR_RocketPickupID]=-1;
	DR_PlayerInfo[playerid][DR_NoExpl]=0;
	DR_PlayerInfo[playerid][DR_NoFlip]=0;
	DR_PlayerInfo[playerid][DR_NoRket]=0;
	DR_PlayerInfo[playerid][DR_NoSmok]=0;
	DR_PlayerInfo[playerid][DR_NoRepr]=0;
	DR_PlayerInfo[playerid][DR_NoBost]=0;
	DeleteDRPText(playerid);
	if(DR_PlayerInfo[playerid][DR_Pending]>=0)
	{
	    DR_PlayerInfo[DR_PlayerInfo[playerid][DR_Pending]][DR_Kills]++;
	}
	new DR_PSlot=GetVehicleSlot(DR_PlayerInfo[playerid][DR_VehID]);
	if(DR_Vehicles[DR_PSlot][DR_VehSmoke]==true)
	{
	    for(new i = 0; i<4 ; i++)
	    {
	    	DestroyDynamicObject(DR_Vehicles[DR_PSlot][DR_SmokeObjIDs][i]);
	    	DR_Vehicles[DR_PSlot][DR_SmokeObjIDs][i]=-1;
	    	stop DR_Vehicles[DR_PSlot][DR_SmokeT];
	    }
	}
	if(IsValidDynamicObject(DR_Vehicles[DR_PSlot][DR_MissileObjID])&&IsDynamicObjectMoving(DR_Vehicles[DR_PSlot][DR_MissileObjID]))
	{
		StopDynamicObject(DR_Vehicles[DR_PSlot][DR_MissileObjID]);
		DR_Vehicles[DR_PSlot][DR_MissileObjID]=-1;
		DestroyDynamicObject(DR_Vehicles[DR_PSlot][DR_MissileObjID]);
		stop DR_Vehicles[DR_PSlot][DR_MissileT];
	}
	DestroyVehicle(DR_Vehicles[DR_PSlot][DR_VehID]);
	DR_Vehicles[DR_PSlot][DR_VehID]=0;
	DR_PlayerInfo[playerid][DR_VehID]=0;
	new DR_AntiBug;
	foreach(Player, i)
	{
        if(GetPVarInt(i, "InEvent")==1)
        {
            DR_AntiBug++;
        }
	}
	DRace_Alive--;
	if(DRace_Alive<=1)
	{
	    DR_AntiBug=0;
	    foreach(Player, i)
	    {
	        if(GetPVarInt(i, "InEvent")==1)
	        {
	            if(IsPlayerConnected(playerid)==1)
	        	{
		            if(DR_FinishCount==0)
		            	format(DR_MSG, sizeof(DR_MSG), "[EVENT NOTICE]: %s has survived the DeathRace and thereby, has won the event.", PlayerName(i));
					else
	                    format(DR_MSG, sizeof(DR_MSG), "[EVENT NOTICE]: %s has survived the DeathRace, by staying last like a pussy.", PlayerName(i));
					SendClientMessageToAll(COLOR_NOTICE, DR_MSG);
					DR_AntiBug=1;
					break;
				}
			}
	    }
	    if(DR_AntiBug==0)
	    {
	        if(IsPlayerConnected(playerid)==1)
	        {
	     		if(DR_FinishCount==0)
		          	format(DR_MSG, sizeof(DR_MSG), "[EVENT NOTICE]: %s has survived the DeathRace and thereby, has won the event.", PlayerName(playerid));
				else
	            	format(DR_MSG, sizeof(DR_MSG), "[EVENT NOTICE]: %s has survived the DeathRace, by staying last like a pussy.", PlayerName(playerid));
				SendClientMessageToAll(COLOR_NOTICE, DR_MSG);
			}
		}
    	SetTimerEx("DR_EventEnd", 0, false, "i", playerid);
	}
	return 1;
}

public DR_LeaveEvent(playerid)
{
	RemovePlayerFromVehicle(playerid);
	SetVehicleToRespawn(DR_PlayerInfo[playerid][DR_VehID]);
	SpawnPlayer(playerid);
	SetTimerEx("DR_PlayerDeath", 0, false, "i", playerid);
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
    if(Event_ID==EVENT_DRACE)
	{
	    if(GetPVarInt(playerid, "InEvent")==1)
	    {
    		SetTimerEx("DR_PlayerDeath", 0, false, "i", playerid);
		}
	}
}

/*public DR_EventAdd(playerid, targetid)
{
	if(DRace_JoinCount==50)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Event Full, adding player will bug event.");
	}
	else
	{
	    SetTimerEx("DR_EventJoin", 0, false, "i", targetid);
	}
}*/
////////////////////////////////////////////////////////////////////////////////
/**************************End of Event Functions******************************/
////////////////////////////////////////////////////////////////////////////////

/*============================================================================*/

////////////////////////////////////////////////////////////////////////////////
/*****************************Event Call Backs*********************************/
////////////////////////////////////////////////////////////////////////////////
hook OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(Event_ID==EVENT_DRACE)
	{
	    if(GetPVarInt(playerid, "InEvent")==1)
	    {
			if(IsPickUpsOn==true)
			{
				new DR_PickUpFlag=DR_IsEventPickup(pickupid);
				if(DR_PickUpFlag>=0)
				{
					if(Event_ID==EVENT_DRACE)
					{
					    //ifPlayerIsInEvent
					    if(DR_Picks[DR_PickUpFlag][DR_Taken]==false)
					    {
							switch(DR_Picks[DR_PickUpFlag][DR_Ptype])
							{
							    case 3884:
							    {
							        GameTextForPlayer(playerid, "~g~PickUp ~n~~r~ROCKET.", 3000, 3);
					                DR_PlayerInfo[playerid][DR_NoRket]++;
								}
							    case 1240:
							    {
			      					GameTextForPlayer(playerid, "~g~PickUp ~n~~r~REPAIR.", 3000, 3);
							        DR_PlayerInfo[playerid][DR_NoRepr]++;
							   }
							    case 1241:
							    {
							        GameTextForPlayer(playerid, "~g~PickUp ~n~~r~Boost.", 3000, 3);
							    	DR_PlayerInfo[playerid][DR_NoBost]++;
					      		}
							    case 1254:
							    {
							        GameTextForPlayer(playerid, "~g~PickUp ~n~~r~EXPLOSIVE.", 3000, 3);
					  		        DR_PlayerInfo[playerid][DR_NoExpl]++;
					      		}
							    case 343:
							    {
							        GameTextForPlayer(playerid, "~g~PickUp ~n~~r~SMOKE.", 3000, 3);
							        DR_PlayerInfo[playerid][DR_NoSmok]++;
							    }
							    case 1273:
							    {
					      			GameTextForPlayer(playerid, "~g~PickUp ~n~~r~FLIP.", 3000, 3);
							        DR_PlayerInfo[playerid][DR_NoFlip]++;
							    }
							}
							DR_Picks[DR_PickUpFlag][DR_Taken]=true;
							UpdateDRPText(playerid);
						}
						else
						{
			   				GameTextForPlayer(playerid, "PickUp Already taken.", 3000, 3);
						}
					}
				}
				else
				{
				    DR_PickUpFlag=DR_IsPlayerPickup(pickupid);
					if(DR_PickUpFlag>=0)
					{
						if(DR_PickUpFlag!=playerid)//DestroyPICKUP
						{
						    new Float:Pos[3];
						    DestroyDynamicPickup(DR_PlayerInfo[DR_PickUpFlag][DR_RocketPickupID]);
						    DR_PlayerInfo[DR_PickUpFlag][DR_RocketPickupID]=-1;
						    GetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]);
						    CreateExplosion(Pos[0],Pos[1],Pos[2], 10, 10.0);
						    DR_PlayerInfo[playerid][DR_Pending]=DR_PickUpFlag;
						    DR_ExplosionMark(playerid, 10.0, Pos[0],Pos[1],Pos[2]);
						}
					}
				}
			}
			else
			{
				GameTextForPlayer(playerid, "~g~PickUp ~n~~r~DISABLED.", 3000, 3);
			}
		}
	}
	return 1;
}

hook OnDynamicObjectMoved(objectid)
{
	new objid=GetObjectSlot(objectid);
	if(objid>=0)
	{
		new Float:Pos[3];
		GetDynamicObjectPos(DR_Vehicles[objid][DR_MissileObjID], Pos[0], Pos[1], Pos[2]);
        CreateExplosion(Pos[0] ,Pos[1], Pos[2], 10, 10.0);
        DestroyDynamicObject(DR_Vehicles[objid][DR_MissileObjID]);
        DR_Vehicles[objid][DR_MissileObjID]=-1;
		stop DR_Vehicles[objid][DR_MissileT];
	}
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(Event_ID==EVENT_DRACE)
	{
	    if(GetPVarInt(playerid, "InEvent")==1)
	    {
			/*SMOKE*/
			if(newkeys&KEY_SMOKE)//Working
			{
				if(IsPlayerInAnyVehicle(playerid)==1)
				{
				    printf("%i",DR_PlayerInfo[playerid][DR_NoSmok]);
				    if(DR_PlayerInfo[playerid][DR_NoSmok]>0)
				    {
				        new vehid = GetVehicleSlot(GetPlayerVehicleID(playerid));
						if(DR_Vehicles[vehid][DR_VehSmoke]==false)
						{
							if(vehid>=0)
							{
							    for(new i=0; i<4; i++)
						        {
						        	DR_Vehicles[vehid][DR_SmokeObjIDs][i]=CreateDynamicObject(2780, 0.0, 0.0, 0.0, 0.0,0.0,0.0,DR_VWORLD);
						        	AttachDynamicObjectToVehicle(DR_Vehicles[vehid][DR_SmokeObjIDs][i], DR_Vehicles[vehid][DR_VehID], SmokePos[i][0], SmokePos[i][1], SmokePos[i][2], 0.0, 0.0, 0.0);
						        }
						        DR_Vehicles[vehid][DR_SmokeT] = repeat DR_DeleteSmokeMachine(vehid);
				                DR_Vehicles[vehid][DR_VehSmoke]=true;
				                DR_PlayerInfo[playerid][DR_NoSmok]--;
							}
						}
					}
				}
			}
		    /*FIXCAR*/
			if(newkeys&KEY_FIXCAR)//Working
			{
				if(IsPlayerInAnyVehicle(playerid)==1)
				{
				    printf("%i",DR_PlayerInfo[playerid][DR_NoRepr]);
				    if(DR_PlayerInfo[playerid][DR_NoRepr]>0)
				    {
				        new vehid = GetVehicleSlot(GetPlayerVehicleID(playerid));
						RepairVehicle(DR_Vehicles[vehid][DR_VehID]);
						DR_PlayerInfo[playerid][DR_Pending]=-1;
						DR_PlayerInfo[playerid][DR_NoRepr]--;
					}
				}
			}
		    /*BOOST*/
			if(newkeys&KEY_BOOST)//Working
			{
				if(IsPlayerInAnyVehicle(playerid)==1)
				{
				    if(DR_PlayerInfo[playerid][DR_NoBost]>0)
				    {
				        new vehid = GetVehicleSlot(GetPlayerVehicleID(playerid));
						new Float:vx,Float:vy,Float:vz;
		        		GetVehicleVelocity(DR_Vehicles[vehid][DR_VehID],vx,vy,vz);
		        		SetVehicleVelocity(DR_Vehicles[vehid][DR_VehID], vx * 1.8, vy *1.8, vz * 1.8);
		        		if(vx+vy+vz!=0.0)
		        		{
		        		    DR_PlayerInfo[playerid][DR_NoBost]--;
		        		}
					}
				}
			}
			/*MISSILE*/
			if(newkeys&KEY_MISSILE)//Working
			{
				if(IsPlayerInAnyVehicle(playerid)==1)
				{
				    if(DR_PlayerInfo[playerid][DR_NoRket]>0)
				    {
				        new vehid = GetVehicleSlot(GetPlayerVehicleID(playerid));
				        if(IsValidDynamicObject(DR_Vehicles[vehid][DR_MissileObjID])==0)
				        {
							new Float:fPX,Float:fPY,Float:fPZ,Float:fA;
							GetVehiclePos(DR_Vehicles[vehid][DR_VehID],fPX,fPY,fPZ);
				            GetVehicleZAngle(DR_Vehicles[vehid][DR_VehID],fA);
							DR_Vehicles[vehid][DR_MissileObjID]=CreateDynamicObject(345, fPX,fPY,fPZ, 0.0, 0.0, 0.0,DR_VWORLD);
                            DR_PlayerInfo[playerid][DR_RocketPickupID] = DR_Vehicles[vehid][DR_MissileObjID];
							fPX += (250.0 * floatsin(-fA, degrees));
				    		fPY += (250.0 * floatcos(-fA, degrees));
				    		MoveDynamicObject(DR_Vehicles[vehid][DR_MissileObjID], fPX,fPY,fPZ-3.0, 80.0);
				    		DR_Vehicles[vehid][DR_MissileT] = repeat DR_DeleteMissile(vehid);
			                DR_PlayerInfo[playerid][DR_NoRket]--;
		     			}
					}
		  		}
			}
			/*EXPLOSIVE*/
			if(newkeys&KEY_EXPLOSIVE)
			{
				if(IsPlayerInAnyVehicle(playerid)==1)
				{
				    if(DR_PlayerInfo[playerid][DR_NoExpl]>0 || DR_PlayerInfo[playerid][DR_RocketPickupID]!=-1)
				    {
				        if(IsValidDynamicPickup(DR_PlayerInfo[playerid][DR_RocketPickupID])==0)
				        {
							GetVehiclePos(DR_PlayerInfo[playerid][DR_VehID],DR_PlayerInfo[playerid][DR_ExplosivePos][0],DR_PlayerInfo[playerid][DR_ExplosivePos][1],DR_PlayerInfo[playerid][DR_ExplosivePos][2]);
							DR_PlayerInfo[playerid][DR_RocketPickupID]=CreateDynamicPickup(1225, 14, DR_PlayerInfo[playerid][DR_ExplosivePos][0],DR_PlayerInfo[playerid][DR_ExplosivePos][1],DR_PlayerInfo[playerid][DR_ExplosivePos][2], DR_VWORLD);
                            DR_PlayerInfo[playerid][DR_NoExpl]--;
						}
						else
						{
							DestroyDynamicPickup(DR_PlayerInfo[playerid][DR_RocketPickupID]);
						    CreateExplosion(DR_PlayerInfo[playerid][DR_ExplosivePos][0],DR_PlayerInfo[playerid][DR_ExplosivePos][1],DR_PlayerInfo[playerid][DR_ExplosivePos][2], 10, 10.0);
							DR_ExplosionMark(playerid, 10.0, DR_PlayerInfo[playerid][DR_ExplosivePos][0],DR_PlayerInfo[playerid][DR_ExplosivePos][1],DR_PlayerInfo[playerid][DR_ExplosivePos][2]);
						    DR_PlayerInfo[playerid][DR_RocketPickupID]=-1;
						}
					}
		  		}
			}
			if(newkeys&KEY_FLIP)
			{
				if(IsPlayerInAnyVehicle(playerid)==1)
				{
				    if(DR_PlayerInfo[playerid][DR_NoFlip]>0)
				    {
				        new Float:DR_angle;
				        new vehid = GetVehicleSlot(GetPlayerVehicleID(playerid));
                        GetVehicleZAngle(DR_Vehicles[vehid][DR_VehID], DR_angle);
    					SetVehicleZAngle(DR_Vehicles[vehid][DR_VehID], DR_angle);
                        DR_PlayerInfo[playerid][DR_NoFlip]--;
					}
		  		}
			}
			UpdateDRPText(playerid);
		}
	}
	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	if(Event_ID==EVENT_DRACE && GetPVarInt(playerid, "InEvent")==1)
	{
		SetTimerEx("DR_PlayerDeath", 0, false, "i", playerid);
		return 1;
	}
	return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid)
{
	if(Event_InProgress!=-1)
 	{
		if(Event_ID==EVENT_DRACE)
		{
			if(GetPVarInt(playerid, "InEvent")==1)
			{
		   		DR_LeaveEvent(playerid);
          	}
		}
	}
	return 1;
}

hook OnPlayerEnterDynamicRaceCP(playerid, checkpointid)
{
	if(Event_InProgress!=-1)
	{
		if(checkpointid==DR_CheckPIDs[DR_PlayerInfo[playerid][DR_CheckPoint]])
		{
		    new DR_LMSG[55];
		    if(DR_PlayerInfo[playerid][DR_CheckPoint]!=DR_CPCount)
		    {
		        DR_PlayerInfo[playerid][DR_CheckPoint]++;
		    }
		    if(DR_PlayerInfo[playerid][DR_CheckPoint]==DR_CPCount)
		    {
                DR_PlayerInfo[playerid][DR_Laps]++;
				if(DR_PlayerInfo[playerid][DR_Laps]==DR_TotalLaps)
				{
				    DR_FinishCount++;
					format(DR_MSG, sizeof(DR_MSG), "[Event Notice]:%s has finished %i in DeathRace.", PlayerName(playerid),DR_FinishCount);
					SendClientMessageToAll(COLOR_NOTICE, DR_MSG);
					DR_LeaveEvent(playerid);
				}
				else
				{
					if(DR_PlayerInfo[playerid][DR_Laps]<DR_TotalLaps)
					{
					    format(DR_LMSG, sizeof(DR_LMSG), "Lap: ~n~~r~%i ~w~of ~b~%i", DR_PlayerInfo[playerid][DR_Laps],DR_TotalLaps);
						GameTextForPlayer(playerid, DR_LMSG, 1000, 3);
					}
					else
					{
					    GameTextForPlayer(playerid, "~r~Final ~b~LAP", 1000, 3);
					}
					DR_PlayerInfo[playerid][DR_CheckPoint]=0;
			    	TogglePlayerDynamicRaceCP(playerid, checkpointid, 0);
			    	TogglePlayerDynamicRaceCP(playerid, DR_CheckPIDs[DR_PlayerInfo[playerid][DR_CheckPoint]], 1);
				}
			}
			else
			{
			    TogglePlayerDynamicRaceCP(playerid, checkpointid, 0);
			    if(DR_PlayerInfo[playerid][DR_Laps]==DR_TotalLaps-1 && DR_PlayerInfo[playerid][DR_CheckPoint] == DR_CPCount-1)
			    {
                    GameTextForPlayer(playerid, "~r~Final ~b~CheckPoint", 1000, 3);
                    TogglePlayerDynamicRaceCP(playerid, DR_CheckPIDs[DR_CPCount], 1);
					DR_PlayerInfo[playerid][DR_CheckPoint] = DR_CPCount;
				}
			    else
			    {
					TogglePlayerDynamicRaceCP(playerid, DR_CheckPIDs[DR_PlayerInfo[playerid][DR_CheckPoint]], 1);
					format(DR_LMSG, sizeof(DR_LMSG), "CheckPoint: ~n~~r~%i ~w~of ~b~%i",DR_PlayerInfo[playerid][DR_CheckPoint],DR_CPCount);
					GameTextForPlayer(playerid, DR_LMSG, 1000, 3);
				}
			}
			Streamer_Update(playerid);
		}
	}
	return 0;
}

////////////////////////////////////////////////////////////////////////////////
/*****************************End of Event Callbacks***************************/
////////////////////////////////////////////////////////////////////////////////

/*============================================================================*/

////////////////////////////////////////////////////////////////////////////////
/********************************DEBUG COMMANDS********************************/
////////////////////////////////////////////////////////////////////////////////
/*CMD:event(playerid, params[])
{
    if(Event_ID != EVENT_DRACE)
		SetTimerEx("DR_EventStart", 0, false, "i", playerid);
	return 1;
}

CMD:join(playerid, params[])
{
	if(Event_ID == EVENT_DRACE&&FoCo_Event_Died[playerid]==0&&GetPVarInt(playerid, "InEvent")==0)
	    SetTimerEx("DR_EventJoin", 0, false, "i", playerid);
	return 1;
}

CMD:end(playerid, params[])
{
    if(Event_ID == EVENT_DRACE)
    	SetTimerEx("DR_EventEnd", 0, false, "i", playerid);
	return 1;
}

CMD:leave(playerid, params[])
{
    if(Event_ID == EVENT_DRACE&&GetPVarInt(playerid, "InEvent")==1)
		SetTimerEx("DR_LeaveEvent", 0, false, "i", playerid);
	return 1;
}*/
////////////////////////////////////////////////////////////////////////////////
/*****************************End of Debug Commands****************************/
////////////////////////////////////////////////////////////////////////////////
/*============================================================================*/

