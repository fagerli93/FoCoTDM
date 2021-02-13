/*

	The Protector By Lee Percox, Warren Bickly, FoCo TDM
		Also Credits: JernelJ for flood protect ideas / tut

*/

#include <a_samp>
#include <foreach>

// ================================= [ CUSTOMISEABLE DEFINES ] ===============================
#define 		TheProtectorLoopTimer 			1 // 1 second
#define 		max_joins_log 					37

#define 		THEPROTECTOR_HEALTH				1
#define 		THEPROTECTOR_ARMOUR				2
#define 		THEPROTECTOR_INVALID_MOD		3
#define 		THEPROTECTOR_FAKEDEATH			4
#define 		THEPROTECTOR_FLOOD				5
#define 		THEPROTECTOR_SERVERADVERT		6
#define 		THEPROTECTOR_DRIVERDRIVEBY		7
#define 		THEPROTECTOR_CJRUN				8
#define 		THEPROTECTOR_ALTTAB				9

// ================================= [ DEFINES ] =============================================
//#define 		debugs
#define 		GetUnixTime() 					gettime()
#define 		floodprotect

#define 		COLOR_WARNING 					0x800000FF
#define 		IRCCOL_WARNING 					"4"
#define 		COLOR_NOTICE 					0xE0FFFFAA
#define 		IRCCOL_NOTICE 					"16"
#define 		COLOR_GREEN 					0x33AA33AA
#define 		COLOR_GRAD1 					0xB4B5B7FF

// ================================== [ FORWARDS ] ===========================================
forward 		TheProtectorLoop(playerid);
forward 		TheProtector_GetTabInfo(playerid);
forward 		TheProtector_Ban(playerid, string[]);
forward 		TheProtector_Admin_Inform(playerid, warncode, string[]);
forward 		OnTheProtectorPlayerWarning(playerid, warncode, reason[]);

// ================================== [ NEWS ] ===============================================

new autoinc_join_sequence = 0;
new deathval[MAX_PLAYERS];
new lastDeathTime[MAX_PLAYERS];
new ignore_anticheat[MAX_PLAYERS] = 0;

new legalmods[48][22] = {
    {400, 1024,1021,1020,1019,1018,1013,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {401, 1145,1144,1143,1142,1020,1019,1017,1013,1007,1006,1005,1004,1003,1001,0000,0000,0000,0000},
    {404, 1021,1020,1019,1017,1016,1013,1007,1002,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {405, 1023,1021,1020,1019,1018,1014,1001,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {410, 1024,1023,1021,1020,1019,1017,1013,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
    {415, 1023,1019,1018,1017,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {418, 1021,1020,1016,1006,1002,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {420, 1021,1019,1005,1004,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {421, 1023,1021,1020,1019,1018,1016,1014,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {422, 1021,1020,1019,1017,1013,1007,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {426, 1021,1019,1006,1005,1004,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {436, 1022,1021,1020,1019,1017,1013,1007,1006,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
    {439, 1145,1144,1143,1142,1023,1017,1013,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
    {477, 1021,1020,1019,1018,1017,1007,1006,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {478, 1024,1022,1021,1020,1013,1012,1005,1004,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {489, 1024,1020,1019,1018,1016,1013,1006,1005,1004,1002,1000,0000,0000,0000,0000,0000,0000,0000},
	{491, 1145,1144,1143,1142,1023,1021,1020,1019,1018,1017,1014,1007,1003,0000,0000,0000,0000,0000},
    {492, 1016,1006,1005,1004,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {496, 1143,1142,1023,1020,1019,1017,1011,1007,1006,1003,1002,1001,0000,0000,0000,0000,0000,0000},
    {500, 1024,1021,1020,1019,1013,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {516, 1021,1020,1019,1018,1017,1016,1015,1007,1004,1002,1000,0000,0000,0000,0000,0000,0000,0000},
    {517, 1145,1144,1143,1142,1023,1020,1019,1018,1017,1016,1007,1003,1002,0000,0000,0000,0000,0000},
    {518, 1145,1144,1143,1142,1023,1020,1018,1017,1013,1007,1006,1005,1003,1001,0000,0000,0000,0000},
    {527, 1021,1020,1018,1017,1015,1014,1007,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {529, 1023,1020,1019,1018,1017,1012,1011,1007,1006,1003,1001,0000,0000,0000,0000,0000,0000,0000},
    {534, 1185,1180,1179,1178,1127,1126,1125,1124,1123,1122,1106,1101,1100,0000,0000,0000,0000,0000},
    {535, 1121,1120,1119,1118,1117,1116,1115,1114,1113,1110,1109,0000,0000,0000,0000,0000,0000,0000},
    {536, 1184,1183,1182,1181,1128,1108,1107,1105,1104,1103,0000,0000,0000,0000,0000,0000,0000,0000},
    {540, 1145,1144,1143,1142,1024,1023,1020,1019,1018,1017,1007,1006,1004,1001,0000,0000,0000,0000},
    {542, 1145,1144,1021,1020,1019,1018,1015,1014,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {546, 1145,1144,1143,1142,1024,1023,1019,1018,1017,1007,1006,1004,1002,1001,0000,0000,0000,0000},
    {547, 1143,1142,1021,1020,1019,1018,1016,1003,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {549, 1145,1144,1143,1142,1023,1020,1019,1018,1017,1012,1011,1007,1003,1001,0000,0000,0000,0000},
    {550, 1145,1144,1143,1142,1023,1020,1019,1018,1006,1005,1004,1003,1001,0000,0000,0000,0000,0000},
    {551, 1023,1021,1020,1019,1018,1016,1006,1005,1003,1002,0000,0000,0000,0000,0000,0000,0000,0000},
    {558, 1168,1167,1166,1165,1164,1163,1095,1094,1093,1092,1091,1090,1089,1088,0000,0000,0000,0000},
    {559, 1173,1162,1161,1160,1159,1158,1072,1071,1070,1069,1068,1067,1066,1065,0000,0000,0000,0000},
    {560, 1170,1169,1141,1140,1139,1138,1033,1032,1031,1030,1029,1028,1027,1026,0000,0000,0000,0000},
    {561, 1157,1156,1155,1154,1064,1063,1062,1061,1060,1059,1058,1057,1056,1055,1031,1030,1027,1026},
    {562, 1172,1171,1149,1148,1147,1146,1041,1040,1039,1038,1037,1036,1035,1034,0000,0000,0000,0000},
    {565, 1153,1152,1151,1150,1054,1053,1052,1051,1050,1049,1048,1047,1046,1045,0000,0000,0000,0000},
    {567, 1189,1188,1187,1186,1133,1132,1131,1130,1129,1102,0000,0000,0000,0000,0000,0000,0000,0000},
    {575, 1177,1176,1175,1174,1099,1044,1043,1042,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {576, 1193,1192,1191,1190,1137,1136,1135,1134,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {580, 1023,1020,1018,1017,1007,1006,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {589, 1145,1144,1024,1020,1018,1017,1016,1013,1007,1006,1005,1004,1000,0000,0000,0000,0000,0000},
    {600, 1022,1020,1018,1017,1013,1007,1006,1005,1004,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {603, 1145,1144,1143,1142,1024,1023,1020,1019,1018,1017,1007,1006,1001,0000,0000,0000,0000,0000}
};

// ================================= [ ENUMS ] ===============================================

enum core_ipjoin {
    ip_add,
    timestamp
}
new ipjoinlog[max_joins_log][core_ipjoin];

enum protector_info {
	ac_tabTimer,
	ac_timer
}
new AntiCheat[MAX_PLAYERS][protector_info];

enum warned_info {
	health_warn,
	armour_warn,
	teleport_warn,
	jetpack_warn,
	weapon_warn,
	tabbed_warn,
	speedhack_warn
}
new AntiWarn[MAX_PLAYERS][warned_info];

// ================================= [ Callbacks ] =============================================

public OnPlayerConnect(playerid)
{
	print("TheProtector_OnPlayerConnect");
	
	AntiCheat[playerid][ac_timer] = SetTimerEx("TheProtectorLoop", TheProtectorLoopTimer*1000, true, "d", playerid);
	
	RemoveBuildingForPlayer(playerid, 1302, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1209, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 955, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 956, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1775, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1776, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1977, 0.0, 0.0, 0.0, 6000.0);
	
	#if defined debugs
		SendClientMessageToAll(COLOR_NOTICE, "TheProtector_OnPlayerConnect");
	#endif
	#if defined floodprotect
		log_new_join(playerid);
		new intjoins = number_joins_time_range(playerid, 5);
		new pname[MAX_PLAYER_NAME];
			
		GetPlayerName(playerid, pname, sizeof(pname));
		printf("TheProtector: ID %d has connected with nickname %s and has joined from same ip in last 5 seconds Amount: %d", playerid, pname, intjoins);
	
		if(intjoins > 4) {
			new str[150];
			format(str, sizeof(str), "ID %d has connected with nickname %s and has joined from same ip in last 5 seconds Amount: %d", playerid, pname, intjoins);
			TheProtector_Admin_Inform(playerid, THEPROTECTOR_FLOOD, str);
			TheProtector_Ban(playerid, "Flooding the server");
		}
	#endif
	CallRemoteFunction("TheProtector_OnPlayerConnect", "d", playerid);
	return 1;
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect TheProtector_OnPlayerConnect
forward TheProtector_OnPlayerConnect(playerid);

public OnPlayerDeath(playerid, killerid, reason)
{
	print("TheProtector_OnPlayerDeath");
	#if defined debugs
		SendClientMessageToAll(COLOR_NOTICE, "TheProtector_OnPlayerDeath");
	#endif
	
	if(killerid != INVALID_PLAYER_ID) {
		if(GetUnixTime() + 1 > lastDeathTime[playerid]) {
			deathval[playerid] = 0;
		} else {
			deathval[playerid]++;
			new string[128];
			if(deathval[playerid] > 1) {
				format(string, sizeof(string), "[FakeDeath] %s is possible causing fake deaths from %s(%d) (amount caused: %d)", PlayerName(playerid), PlayerName(killerid), killerid, deathval[playerid]);
				TheProtector_Admin_Inform(playerid, THEPROTECTOR_FAKEDEATH, string);
			}
			if(deathval[playerid] > 3) {
				format(string, sizeof(string), "[FakeDeath] %s has been banned for possible causing fake deaths from %s(%d) (amount caused: %d)", PlayerName(playerid), PlayerName(killerid), killerid, deathval[playerid]);
				TheProtector_Admin_Inform(playerid, THEPROTECTOR_FAKEDEATH, string);
				TheProtector_Ban(playerid, "You have been banned for causing FakeDeaths.. please submit an unban appeal.");
			}
		}
		lastDeathTime[playerid] = GetUnixTime();
	}
	
	CallRemoteFunction("TheProtector_OnPlayerDeath", "ddd", playerid, killerid, reason);
	return 1;
}
#if defined _ALS_OnPlayerDeath
    #undef OnPlayerDeath
#else
    #define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath TheProtector_OnPlayerDeath
forward TheProtector_OnPlayerDeath(playerid, killerid, reason);

public OnPlayerDisconnect(playerid, reason)
{
	print("TheProtector_OnPlayerDisconnect");
	
	KillTimer(AntiCheat[playerid][ac_timer]);
	resetAntiWarn(playerid);

	CallRemoteFunction("TheProtector_OnPlayerDisconnect", "dd", playerid, reason);
	return 1;
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect TheProtector_OnPlayerDisconnect
forward TheProtector_OnPlayerDisconnect(playerid, reason);

public OnPlayerUpdate(playerid)
{
	print("TheProtector_OnPlayerUpdate");
	
	AntiCheat[ playerid ][ ac_tabTimer ] = 0;
	
	CallRemoteFunction("TheProtector_OnPlayerUpdate", "d", playerid);
	return 1;
}
#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate TheProtector_OnPlayerUpdate
forward TheProtector_OnPlayerUpdate(playerid);

public OnVehicleMod(playerid, vehicleid, componentid)
{
	print("TheProtector_OnVehicleMod");
	#if defined debugs
		SendClientMessageToAll(COLOR_NOTICE, "TheProtector_OnVehicleMod");
	#endif
	
	new vehicleide = GetVehicleModel(vehicleid);
    new modok = islegalcarmod(vehicleide, componentid);
    
    if (!modok) {
		new string[150];
        format(string, sizeof(string), "[Invalid Mod Found] %s(%d) is possibly using a hacking tool on vehicle(%d) model(%d) component(%d)", PlayerName(playerid), playerid, vehicleid, vehicleide, componentid);
		TheProtector_Admin_Inform(playerid, THEPROTECTOR_INVALID_MOD, string);
        TheProtector_Ban(playerid, "Hacking Illegal Server Mods");
    }
	
	CallRemoteFunction("TheProtector_OnVehicleMod", "ddd", playerid, vehicleid, componentid);
	return 1;
}
#if defined _ALS_OnVehicleMod
    #undef OnVehicleMod
#else
    #define _ALS_OnVehicleMod
#endif
#define OnVehicleMod TheProtector_OnVehicleMod
forward TheProtector_OnVehicleMod(playerid, vehicleid, componentid);

public TheProtectorLoop(playerid)
{
	AntiCheat[ playerid ][ ac_tabTimer ]++;
	return 1;
}

public TheProtector_Ban(playerid, string[])
{
	if(isPlayerAdmin(playerid))
	{
		return 1;
	}
	if(ignore_anticheat[playerid] == 1)
	{
		return 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_NOTICE, "========== The Protector Anti-Cheat ===========");
		SendClientMessage(playerid, COLOR_WARNING, "You have been banned by the anti-cheat, please see reason below.");
		BanEx(playerid, string);
		SendClientMessage(playerid, COLOR_NOTICE, "=====================================================");
	}
	return 1;
}

public TheProtector_Admin_Inform(playerid, warncode, string[])
{
	return CallRemoteFunction("OnTheProtectorPlayerWarning", "iis", playerid, warncode, string);
}

// ================================= [ FUNCTIONS ] =============================================

iswheelmodel(modelid) {
    new wheelmodels[17] = {1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1096,1097,1098};
	for(new I = 0; I < sizeof(wheelmodels); I++) {
        if (modelid == wheelmodels[I])
            return true;     
    }
    return false;
}

IllegalCarNitroIde(carmodel) {  
    new illegalvehs[29] = { 581, 523, 462, 521, 463, 522, 461, 448, 468, 586, 509, 481, 510, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 590, 569, 537, 538, 570, 449 };
    for(new I = 0; I < sizeof(illegalvehs); I++) {
        if (carmodel == illegalvehs[I])
            return true;
    }   
    return false;
}
/*
// assumes player is in a car - make sure it is.
illegal_nos_vehicle(PlayerID) {
    new carid = GetPlayerVehicleID(PlayerID);
    new playercarmodel = GetVehicleModel(carid);
    return IllegalCarNitroIde(playercarmodel); 
}*/

stock islegalcarmod(vehicleide, componentid) {
    new modok = false;
    if ( (iswheelmodel(componentid)) || (componentid == 1086) || (componentid == 1087) || ((componentid >= 1008) && (componentid <= 1010))) {
        new nosblocker = IllegalCarNitroIde(vehicleide);
        if (!nosblocker)
            modok = true;
    } else { 
		for(new I = 0; I < sizeof(legalmods); I++) {
            if (legalmods[I][0] == vehicleide) {        
                for(new J = 1; J < 22; J++) { 
                    if (legalmods[I][J] == componentid)
                        modok = true;
                }            
            }
        }
    }
    return modok;
}
stock resetAntiCheat(playerid)
{
	AntiCheat[playerid][ac_tabTimer] = 0;
	return 1;
}
stock resetAntiWarn(playerid)
{
	AntiWarn[playerid][health_warn] = 0;
	AntiWarn[playerid][armour_warn] = 0;
	AntiWarn[playerid][teleport_warn] = 0;
	AntiWarn[playerid][jetpack_warn] = 0;
	AntiWarn[playerid][weapon_warn] = 0;
	AntiWarn[playerid][tabbed_warn] = 0;
	AntiWarn[playerid][speedhack_warn] = 0;
	return 1;
}

public TheProtector_GetTabInfo(playerid)
{
	SendClientMessage(playerid, COLOR_GREEN, "==================[ Tab Info ]===============");
	new string[80];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(AntiCheat[ i ][ ac_tabTimer ] > 3)
			{
				format(string, sizeof(string), "[ID: %d] %s (Tabbed: %d)", i, PlayerName(i), AntiCheat[ i ][ ac_tabTimer ]);
				SendClientMessage(playerid, COLOR_GRAD1, string);
			}
		}
	}
	
	SendClientMessage(playerid, COLOR_GREEN, "=============================================");
	return 1;
}

stock intabs(innumber) { 
    if (innumber < 0)
        return -innumber;
    
    return innumber;
}

stock Distance1Dint(fPos1, fPos2) {
    if (fPos1 > fPos2)
        return intabs(fPos1 - fPos2);
    else
        return intabs(fPos2 - fPos1);  
}

stock GetTimeDistance(a, b) {
    if ((a < 0) && (b > 0)) {       
        new dist;
        dist = Distance1Dint(a, b);
        if (dist > 2147483647)
            return Distance1Dint(a - 2147483647, b - 2147483647);
        else
            return dist;      
    } else {       
        return Distance1Dint(a, b);   
    }   
}

stock inet_aton(ips[]) {
    new ipv = strval(ips) << 24, pos = 0;
    while (pos < 15 && ips[pos++] != '.') {}
    ipv += strval(ips[pos]) << 16;
    while (pos < 15 && ips[pos++] != '.') {}
    ipv += strval(ips[pos]) << 8;
    while (pos < 15 && ips[pos++] != '.') {}
    ipv += strval(ips[pos]);
    return ipv;
}

stock log_new_join(PlayerID) {    
    new ip[18];
    GetPlayerIp(PlayerID, ip, sizeof(ip));
    new ipv = inet_aton(ip);
    
    ipjoinlog[autoinc_join_sequence][ip_add]    = ipv;
    ipjoinlog[autoinc_join_sequence][timestamp] = GetUnixTime();
    
    autoinc_join_sequence++;
    
    if (autoinc_join_sequence >= max_joins_log)
        autoinc_join_sequence = 0;    
}

stock number_joins_time_range(PlayerID, max_time) {  
    new ip[18];
    GetPlayerIp(PlayerID, ip, sizeof(ip));
    
    new ipv = inet_aton(ip);
    new counted = 0;
    
    for(new I = 0; I < sizeof(ipjoinlog); I++) {
        
        if (ipjoinlog[I][ip_add] != ipv) // different IP.
            continue;
        
        if (GetTimeDistance(GetUnixTime(), ipjoinlog[I][timestamp]) <= max_time)
            counted++;
        
    }   
    return counted;
}