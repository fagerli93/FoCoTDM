#include <a_samp>
#include <foreach>

//#define GUARDIAN_DEBUG

/*===============================
VEHICLE ANTICHEAT COMMENTED ATM
===============================*/

/* Defines for Guardian Codes*/
#define GUARDIAN_PLAYERHP	0 ////- Health Hacking
#define GUARDIAN_PLAYERARMOUR	1 //- Armour Hacking
#define GUARDIAN_PLAYERWEAP	2 //- Weapon Hacking
#define GUARDIAN_PLAYERAMMO	3 //- Ammo Hacking
#define GUARDIAN_PLAYERMONEY	4 //- Money Hacking
#define GUARDIAN_PLAYERJETPACK	5 //- Jetpack Hacking
#define GUARDIAN_PLAYERTP	6 //- Teleporting
#define GUARDIAN_PLAYERAIRBREAK	7 //- Airbreaking
#define GUARDIAN_PLAYERSPEED	8 //- Speed Hacking
#define GUARDIAN_PLAYERSPECACT	9 //- Special Action Hacks
#define GUARDIAN_PLAYERCJRUN	10 //- CJ Running
#define GUARDIAN_PLAYERALTTAB	11 //- Alt//-Tabbed
#define GUARDIAN_PLAYERDDB	12 //- Driver Driver//-By
#define GUARDIAN_PLAYERCBUG	13 //- C-bugging
#define GUARDIAN_PLAYERADVERTISE 14
	
#define GUARDIAN_VEHICLEHP	0 //- Health
#define GUARDIAN_VEHICLETP	1 //- Teleport Hacks
#define GUARDIAN_VEHICLEAIRBREAK	2 //- Airbreaking Hacks
#define GUARDIAN_VEHICLESPEED	3 //- Speed Hacks
#define GUARDIAN_VEHICLESPIDER	4 //- Spider Hack
#define GUARDIAN_VEHICLEMOD	5 //- Mod hacks

/* Callbacks*/
forward OnGuardianPlayerWarning(playerid, warncode, reason[]);
forward OnGuardianVehicleWarning(vehicleid, driver, warncode, reason[]);

/*Custom Functions*/
forward SetTabbedLimit(limit); // -1 to ignore Tab times, default 600
forward SetPlayerCheckInterval(checktime); //Set how long in seconds between each player check
forward SetWarningReNotificationTime(time); //Seconds
forward GetGuardianReportForPlayer(playerid, strdest[][]);
forward SendGuardianPlayerWarning(string[], playerid, warncode);

/* Functions */
forward AC_Delay(playerid);
forward ResetACData(playerid);

forward Guardian_UsePlayerPedAnims();

forward Guardian_GivePlayerMoney(playerid, amount);
forward Guardian_SetPlayerInterior(playerid, amount);
forward Guardian_SetPlayerVirtualWorld(playerid, amount);
forward Guardian_SetPlayerSkin(playerid, amount);
forward Guardian_SetPlayerMoney(playerid, amount);
forward Guardian_SetPlayerHealth(playerid, Float:amount);
forward Guardian_SetPlayerPos(playerid, Float:x, Float:y, Float:z);
forward Guardian_SetVehiclePos(vehicleid, Float:x, Float:y, Float:z);
forward Guardian_SetPlayerArmour(playerid, Float:amount);
forward Guardian_GetPlayerMoney(playerid);
forward Guardian_ResetPlayerWeapons(playerid);
forward Guardian_GivePlayerWeapon(playerid, weaponid, ammo);
forward Guardian_SetSpawnInfo(playerid, pteam, pskin, Float:px, Float:py, Float:pz, Float:pAngle, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo);
forward Guardian_SetPlayerSpecialAction(playerid, specialaction);
forward Guardian_AddStaticVehicle(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:angle, color1, color2);
forward Guardian_AddStaticVehicleEx(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:angle, color1, color2, respawn_delay);
forward Guardian_CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay);
forward Guardian_DestroyVehicle(vehicleid);
forward Guardian_ChangeVehicleColor(vehicleid, color1, color2);
forward Guardian_AddVehicleComponent(vehicleid, componentid);
forward Guardian_RemoveVehicleComponent(vehicleid, componentid);
forward Guardian_SetVehicleHealth(vehicleid, Float:health);

/* Internal Custom Functions */
forward GuardianPlayerCheck(playerid);
forward GuardianVehicleCheck(vehicleid);
forward GuardianDebug(string[]);

/* Defines */

#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xFF6347AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA

/* Variables */

new	aclastreload[MAX_PLAYERS];               //Currently unused, but intended for anti-reload and ammo hacks
new	acshotsfired[MAX_PLAYERS];               //Same as above
new	ignoreac[MAX_PLAYERS];                      //Created to avoid incostencies with death timings and function uses
new	AntiCheatTimer[MAX_PLAYERS];
new    AntiCheatPVehTimer[MAX_PLAYERS];
new	enterkey[MAX_PLAYERS];
new	UsePedAnims;

//Settings
new	Guardian_TabLimit = 600;
new	Guardian_PlayerCheckInterval = 5;
new	Guardian_ReNotificationTime = 120;

new Iterator:Vehicle<MAX_VEHICLES>;
/*Data Arrays*/
enum Guardian_WeapInfo
{
	WeapName[30],
	WeapSlot
};
new Guardian_WeapNames[][Guardian_WeapInfo] = {
	{"Unarmed (Fist)", 0}, // 0
	{"Brass Knuckles", 0}, // 1
	{"Golf Club", 1}, // 2
	{"Night Stick", 1}, // 3
	{"Knife",1}, // 4
	{"Baseball Bat",1}, // 5
	{"Shovel",1}, // 6
	{"Pool Cue",1}, // 7
	{"Katana",1}, // 8
	{"Chainsaw",1}, // 9
	{"Purple Dildo", 10}, // 10
	{"Big White Vibrator",10}, // 11
	{"Medium White Vibrator", 10}, // 12
	{"Small White Vibrator", 10}, // 13
	{"Flowers", 10}, // 14
	{"Cane", 10}, // 15
	{"Grenade", 8}, // 16
	{"Teargas", 8}, // 17
	{"Molotov", 8}, // 18
	{" ", 0}, // 19
	{" ", 0}, // 20
	{" ", 0}, // 21
	{"Colt 45", 2}, // 22
	{"Colt 45(Silenced)", 2}, // 23
	{"Deagle",2}, // 24
	{"Normal Shotgun", 3}, // 25
	{"Sawnoff Shotgun", 3}, // 26
	{"Combat Shotgun", 3}, // 27
	{"Micro SMG", 4}, // 28
	{"MP5", 4}, // 29
	{"AK47", 5}, // 30
	{"M4", 5}, // 31
	{"Tec9", 4}, // 32
	{"Country Rifle", 6}, // 33
	{"Sniper Rifle", 6}, // 34
	{"Rocket Launcher", 7}, // 35
	{"Heat-Seeking Rocket Launcher", 7}, // 36
	{"Flamethrower", 7}, // 37
	{"Minigun", 7}, // 38
	{"Satchel Charge", 8}, // 39
	{"Detonator", 12}, // 40
	{"Spray Can", 9}, // 41
	{"Fire Extinguisher", 9}, // 42
	{"Camera", 9}, // 43
	{"Night Vision Goggles", 11}, // 44
	{"Infrared Vision Goggles", 11}, // 45
	{"Parachute", 11}, // 46
	{"Fake Pistol", 0} // 47
};
new Float:SprunkLocations[][] = {
	{2480.86,-1959.27,12.9609},
	{1634.11,-2237.53,12.8906},
	{2139.52,-1161.48,23.3594},
	{2153.23,-1016.15,62.2344},
	{-1350.12,493.859,10.5859},
	{-2229.19,286.414,34.7031},
	{1659.46,1722.86,10.2188},
	{2647.7,1129.66,10.2188},
	{2845.73,1295.05,10.7891},
	{1398.84,2222.61,10.4219},
	{-1455.12,2591.66,55.2344},
	{-76.0312,1227.99,19.125},
	{662.43,-552.164,15.7109},
	{-253.742,2599.76,62.2422},
	{2271.73,-76.4609,25.9609},
	{1789.21,-1369.27,15.1641},
	{1729.79,-1943.05,12.9453},
	{2060.12,-1897.64,12.9297},
	{1928.73,-1772.45,12.9453},
	{2325.98,-1645.13,14.2109},
	{2352.18,-1357.16,23.7734},
	{1154.73,-1460.89,15.1562},
	{-1350.12,492.289,10.5859},
	{-2118.97,-423.648,34.7266},
	{-2118.62,-422.414,34.7266},
	{-2097.27,-398.336,34.7266},
	{-2092.09,-490.055,34.7266},
	{-2063.27,-490.055,34.7266},
	{-2005.65,-490.055,34.7266},
	{-2034.46,-490.055,34.7266},
	{-2068.56,-398.336,34.7266},
	{-2039.85,-398.336,34.7266},
	{-2011.14,-398.336,34.7266},
	{-1980.79,142.664,27.0703},
	{2319.99,2532.85,10.2188},
	{1520.15,1055.27,10.00},
	{2503.14,1243.7,10.2188},
	{2085.77,2071.36,10.4531},
	{-862.828,1536.61,21.9844},
	{-14.7031,1175.36,18.9531},
	{-253.742,2597.95,62.2422},
	{201.016,-107.617,0.898438},
	{1277.84,372.516,18.9531}
};

 // Enumerations

enum Guardian_Player
{
	ac_timer,
	ac_msginterval[20],
	ac_money,
	ac_jetpack,
	ac_teleport,
	Float:ac_health,
	Float:ac_armour,
	Float:lastposx,
	Float:lastposy,
	Float:lastposz,
	ac_int,
	ac_vw,
	ac_weap[13],
	ac_weapa[13],
	ac_lastveh,
	ac_dead,
	ac_spawned,
	tab_timer,
	last_message[128]
};
new Guardian_PlayerData[MAX_PLAYERS][Guardian_Player];

enum Guardian_Vehicle
{
	ac_modelid,
	ac_driver,
	ac_msginterval[20],
	Float:ac_health,
	Float:ac_unnocx,
	Float:ac_unnocy,
	Float:ac_unnocz,
	ac_col1,
	ac_col2,
	ac_sprayjob,
	ac_comp[13]
};
new Guardian_VehicleData[MAX_VEHICLES][Guardian_Vehicle];

public SetTabbedLimit(limit)
{
	Guardian_TabLimit = limit;
	return 1;
}

public SetPlayerCheckInterval(checktime)
{
	if(checktime < 1)
	{
		print("ERROR: SetPlayerCheckInterval can not be set lower than 1");
		return 0;
	}
	foreach(Player, playerid)
	{
		KillTimer(Guardian_PlayerData[playerid][ac_timer]);
		Guardian_PlayerData[playerid][ac_timer] = SetTimerEx("GuardianPlayerCheck", checktime*1000, true, "d", playerid);
	}
	Guardian_PlayerCheckInterval = checktime*1000;
	return 1;
}
public SetWarningReNotificationTime(time)
{
	if(time < 10)
	{
		print("ERROR: SetWarningReNotificationTime can not be set lower than 10");
		return 0;
	}
	Guardian_ReNotificationTime = time;
	return 1;
}

public GetGuardianReportForPlayer(playerid, strdest[][])
{
	new currentitem,currentline, string[128], statstring[50], Float:health, Float:armour, int, vw, cweapons[13][2];
	GetPlayerHealth(playerid, health);
	GetPlayerArmour(playerid, armour);
	int = GetPlayerInterior(playerid);
	vw = GetPlayerVirtualWorld(playerid);
	
	if(Guardian_PlayerData[playerid][ac_money] >= GetPlayerMoney(playerid))
	{
		format(statstring, 50, "{%06x}Money: $%d {%06x}| ", COLOR_GREEN >>> 8, Guardian_PlayerData[playerid][ac_money], COLOR_WHITE >>> 8);
		strins(string, statstring, strlen(string), sizeof(string));
	}
	else
	{
		format(statstring, 50, "{%06x}Money: $%d (Should be $%d){%06x}| ", COLOR_RED >>> 8, GetPlayerMoney(playerid), Guardian_PlayerData[playerid][ac_money], COLOR_WHITE >>> 8);
		strins(string, statstring, strlen(string), sizeof(string));
	}
	
	if(health < Guardian_PlayerData[playerid][ac_health])
	{
		format(statstring, 50, "{%06x}Health: %d {%06x}| ", COLOR_GREEN >>> 8, floatround(health), COLOR_WHITE >>> 8);
		strins(string, statstring, strlen(string), sizeof(string));
	}
	else
	{
		format(statstring, 50, "{%06x}Health: %d (Should be %d){%06x}| ", COLOR_RED >>> 8, floatround(health), Guardian_PlayerData[playerid][ac_health], COLOR_WHITE >>> 8);
		strins(string, statstring, strlen(string), sizeof(statstring));
	}
	
	if(armour < Guardian_PlayerData[playerid][ac_armour])
	{
		format(statstring, 50, "{%06x}Armour: %d {%06x}| ", COLOR_GREEN >>> 8, floatround(armour), COLOR_WHITE >>> 8);
		strins(string, statstring, strlen(string), sizeof(string));
	}
	else
	{
		format(statstring, 50, "{%06x}Armour: %d (Should be %d){%06x}| ", COLOR_RED >>> 8, floatround(armour), Guardian_PlayerData[playerid][ac_armour], COLOR_WHITE >>> 8);
		strins(string, statstring, strlen(string), sizeof(statstring));
	}
	strins(strdest[0], string, 0, 150);
	strdel(string, 0, sizeof(string));
	
	if(Guardian_PlayerData[playerid][tab_timer] < 5)
	{
		format(statstring, 50, "{%06x}Tabbed: No {%06x}| ", COLOR_GREEN >>> 8, COLOR_WHITE >>> 8);
		strins(string, statstring, strlen(string), sizeof(string));
	}
	else
	{
		format(statstring, 50, "{%06x}Tabbed: Yes (%ds) {%06x}| ", COLOR_RED >>> 8, Guardian_PlayerData[playerid][tab_timer], COLOR_WHITE >>> 8);
		strins(string, statstring, strlen(string), sizeof(string));
	}
	
	if(int != Guardian_PlayerData[playerid][ac_int])
	{
		format(statstring, 50, "{%06x}Interior: %d {%06x}| ", COLOR_GREEN >>> 8, int, COLOR_WHITE >>> 8);
		strins(string, statstring, strlen(string), sizeof(string));
	}
	else
	{
		format(statstring, 50, "{%06x}Interior: %d (Should be %d){%06x}| ", COLOR_RED >>> 8, int, Guardian_PlayerData[playerid][ac_int], COLOR_WHITE >>> 8);
		strins(string, statstring, strlen(string), sizeof(statstring));
	}
	
	if(vw != Guardian_PlayerData[playerid][ac_vw])
	{
		format(statstring, 50, "{%06x}Virtual World: %d {%06x}| ", COLOR_GREEN >>> 8, vw, COLOR_WHITE >>> 8);
		strins(string, statstring, strlen(string), sizeof(string));
	}
	else
	{
		format(statstring, 50, "{%06x}Virtual World: %d (Should be %d){%06x}| ", COLOR_RED >>> 8, vw, Guardian_PlayerData[playerid][ac_vw], COLOR_WHITE >>> 8);
		strins(string, statstring, strlen(string), sizeof(statstring));
	}
	strins(strdest[1], string, 0, 150);
	strdel(string, 0, sizeof(string));
	
	currentline = 2;
	for(new weapsloti = 0; weapsloti < 12; weapsloti++)
	{
		if(cweapons[weapsloti][0] != Guardian_PlayerData[playerid][ac_weap][weapsloti] && cweapons[weapsloti][0] != 0)
		{
			format(statstring, sizeof(statstring), "{%06x}Weapon %d: %s (%s) {%06x}| ", COLOR_RED >>> 8, weapsloti+1, Guardian_WeapNames[cweapons[weapsloti][0]][WeapName], Guardian_WeapNames[Guardian_PlayerData[playerid][ac_weap][weapsloti]][WeapName], COLOR_WHITE >>> 8);
		}
		else
		{
			format(statstring, sizeof(statstring), "{%06x}Weapon %d: %s {%06x}| ", COLOR_GREEN >>> 8,  weapsloti+1, Guardian_WeapNames[cweapons[weapsloti][0]][WeapName],  COLOR_WHITE >>> 8);
		}
		strins(string, statstring, strlen(string), sizeof(string));
		
		currentitem++;
		if(currentitem == 3 || currentitem == 6 || currentitem == 9 || currentitem == 12)
		{
			strins(strdest[currentline], string, 0, 150);
			strdel(string, 0, sizeof(string));
			currentline ++;
			if(currentitem == 12) return 1;
		}
	}
	return 1;
}
public SendGuardianPlayerWarning(string[], playerid, warncode)
{
	CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, warncode, string);
	return 1;
}
public AC_Delay(playerid)
{
	AntiCheatTimer[playerid] = Guardian_ReNotificationTime - 10;
	return 1;
}

public ResetACData(playerid)
{
	Guardian_PlayerData[playerid][ac_jetpack] = 0;
	Guardian_PlayerData[playerid][ac_health] = 100.0;
	Guardian_PlayerData[playerid][ac_armour] = 0.0;
	for(new weapsloti = 0; weapsloti < 12; weapsloti++)
	{
		Guardian_PlayerData[playerid][ac_weap][weapsloti] = 0;
		Guardian_PlayerData[playerid][ac_weapa][weapsloti] = 0;
	}
	for(new msgint = 0; msgint < 20; msgint++)
	{
		Guardian_PlayerData[playerid][ac_msginterval][msgint] = 0;
	}
	Guardian_PlayerData[playerid][ac_jetpack] = 0;
	Guardian_PlayerData[playerid][ac_teleport] = 0;
	Guardian_PlayerData[playerid][lastposx] = 0.0;
	Guardian_PlayerData[playerid][lastposy] = 0.0;
	Guardian_PlayerData[playerid][lastposz] = 0.0;
	Guardian_PlayerData[playerid][ac_int] = 0;
	Guardian_PlayerData[playerid][ac_vw] = 0;
	Guardian_PlayerData[playerid][ac_lastveh] = 0;
	Guardian_PlayerData[playerid][ac_dead] = 0;
	Guardian_PlayerData[playerid][ac_spawned] = 0;
	Guardian_PlayerData[playerid][tab_timer] = 0;
	AntiCheatPVehTimer[playerid] = 0;
	return 1;
}

public Guardian_UsePlayerPedAnims()
{
	UsePedAnims = 1;
	return UsePlayerPedAnims();
}

public Guardian_GivePlayerMoney(playerid, amount)
{
	ignoreac[playerid] = 1;
	AC_Delay(playerid);
	Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERMONEY] = 1;
	Guardian_PlayerData[playerid][ac_money] = Guardian_PlayerData[playerid][ac_money]+amount;
	ResetPlayerMoney(playerid);
	ignoreac[playerid] = 0;
	return GivePlayerMoney(playerid, Guardian_PlayerData[playerid][ac_money]);
}

public Guardian_SetPlayerInterior(playerid, amount)
{
	if(Guardian_PlayerData[playerid][ac_dead] == 1) return 1;
	Guardian_PlayerData[playerid][ac_int] = amount;
	return SetPlayerInterior(playerid, amount);
}

public Guardian_SetPlayerVirtualWorld(playerid, amount)
{
	if(Guardian_PlayerData[playerid][ac_dead] == 1) return 1;
	Guardian_PlayerData[playerid][ac_vw] = amount;
	return SetPlayerVirtualWorld(playerid, amount);
}

public Guardian_SetPlayerSkin(playerid, amount)
{
	if(Guardian_PlayerData[playerid][ac_dead] == 1) return 1;
	return SetPlayerSkin(playerid, amount);
}

public Guardian_SetPlayerMoney(playerid, amount)
{
	ignoreac[playerid] = 1;
	AC_Delay(playerid);
	Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERMONEY] = 1;
	ResetPlayerMoney(playerid);
	Guardian_PlayerData[playerid][ac_money] = amount;
	ignoreac[playerid] = 0;
	return GivePlayerMoney(playerid, Guardian_PlayerData[playerid][ac_money]);
}

public Guardian_SetPlayerHealth(playerid, Float:amount)
{
	if(Guardian_PlayerData[playerid][ac_dead] == 1) return 1;
	if(amount > 99 && amount != 9999) amount = 99.0;
	ignoreac[playerid] = 1;
	AC_Delay(playerid);
	Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERHP] = 1;
	Guardian_PlayerData[playerid][ac_health] = amount;
	ignoreac[playerid] = 0;
	return SetPlayerHealth(playerid, amount);
}

public Guardian_SetPlayerPos(playerid, Float:x, Float:y, Float:z)
{
	ignoreac[playerid] = 1;
	AC_Delay(playerid);
	Guardian_PlayerData[playerid][ac_teleport] = 1;
	Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERTP] = 1;
	ignoreac[playerid] = 0;
	return SetPlayerPos(playerid, Float:x, Float:y, Float:z);
}

public Guardian_SetVehiclePos(vehicleid, Float:x, Float:y, Float:z)
{
	foreach(Player, playerid)
	{
		if(GetPlayerVehicleID(playerid) == vehicleid)
		{
			ignoreac[playerid] = 1;
			AC_Delay(playerid);
			Guardian_PlayerData[playerid][ac_teleport] = 1;
			Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERTP] = 1;
			ignoreac[playerid] = 0;
		}
	}
	return SetVehiclePos(vehicleid, Float:x, Float:y, Float:z);
}

public Guardian_SetPlayerArmour(playerid, Float:amount)
{
	if(Guardian_PlayerData[playerid][ac_dead] == 1) return 1;
	ignoreac[playerid] = 1;
	AC_Delay(playerid);
	Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERARMOUR] = 1;
	Guardian_PlayerData[playerid][ac_armour] = amount;
	ignoreac[playerid] = 0;
	return SetPlayerArmour(playerid, amount);
}

public Guardian_GetPlayerMoney(playerid)
{
	return Guardian_PlayerData[playerid][ac_money];
}

public Guardian_ResetPlayerWeapons(playerid)
{
	ignoreac[playerid] = 1;
	AntiCheatTimer[playerid] = 0;
	for(new weapsloti = 0; weapsloti < 12; weapsloti++)
	{
		Guardian_PlayerData[playerid][ac_weap][weapsloti] = 0;
		Guardian_PlayerData[playerid][ac_weapa][weapsloti] = 0;
	}
	
	ignoreac[playerid] = 0;
	return ResetPlayerWeapons(playerid);
}

public Guardian_GivePlayerWeapon(playerid, weaponid, ammo)
{
	if(Guardian_PlayerData[playerid][ac_dead] == 1) return 1;
	ignoreac[playerid] = 1;
	AC_Delay(playerid);
	Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERWEAP] = 1;
	Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERAMMO] = 1;
	new wslot = Guardian_WeapNames[weaponid][WeapSlot];
	if(Guardian_WeapNames[Guardian_PlayerData[playerid][ac_weap][wslot]][WeapSlot] == wslot)
	{
		Guardian_PlayerData[playerid][ac_weapa][Guardian_WeapNames[weaponid][WeapSlot]] += ammo;
	}
	else Guardian_PlayerData[playerid][ac_weapa][Guardian_WeapNames[weaponid][WeapSlot]] = ammo;
	
	Guardian_PlayerData[playerid][ac_weap][Guardian_WeapNames[weaponid][WeapSlot]] = weaponid;
	ignoreac[playerid] = 0;
	return GivePlayerWeapon(playerid, weaponid, ammo);
}

public Guardian_SetSpawnInfo(playerid, pteam, pskin, Float:px, Float:py, Float:pz, Float:pAngle, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo)
{
	ignoreac[playerid] = 1;
	Guardian_PlayerData[playerid][ac_weap][Guardian_WeapNames[weapon1][WeapSlot]] = weapon1;
	Guardian_PlayerData[playerid][ac_weapa][Guardian_WeapNames[weapon1][WeapSlot]] = weapon1_ammo;
	Guardian_PlayerData[playerid][ac_weap][Guardian_WeapNames[weapon2][WeapSlot]] = weapon2;
	Guardian_PlayerData[playerid][ac_weapa][Guardian_WeapNames[weapon2][WeapSlot]] = weapon2_ammo;
	Guardian_PlayerData[playerid][ac_weap][Guardian_WeapNames[weapon3][WeapSlot]] = weapon3;
	Guardian_PlayerData[playerid][ac_weapa][Guardian_WeapNames[weapon3][WeapSlot]] = weapon3_ammo;
	ignoreac[playerid] = 0;
	return SetSpawnInfo(playerid, pteam, pskin, Float:px, Float:py, Float:pz, Float:pAngle, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo);
}

public Guardian_SetPlayerSpecialAction(playerid, specialaction)
{
	if(Guardian_PlayerData[playerid][ac_dead] == 1) return 1;
	ignoreac[playerid] = 1;
	switch(specialaction)
	{
		case SPECIAL_ACTION_USEJETPACK:
		{
			AC_Delay(playerid);
			Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERJETPACK] = 1;
			Guardian_PlayerData[playerid][ac_jetpack] = 1;
		}
	}
	ignoreac[playerid] = 0;
	return SetPlayerSpecialAction(playerid, specialaction);
}

public Guardian_AddStaticVehicle(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:angle, color1, color2)
{
	new ac_vehid = AddStaticVehicle(modelid, spawn_x, spawn_y, spawn_z, angle, color1, color2);
	Guardian_VehicleData[ac_vehid][ac_modelid] = modelid;
	Guardian_VehicleData[ac_vehid][ac_health] = 1000.0;
	Guardian_VehicleData[ac_vehid][ac_unnocx] = spawn_x;
	Guardian_VehicleData[ac_vehid][ac_unnocy] = spawn_y;
	Guardian_VehicleData[ac_vehid][ac_unnocz] = spawn_z;
	Guardian_VehicleData[ac_vehid][ac_col1] = color1;
	Guardian_VehicleData[ac_vehid][ac_col2] = color2;
	Guardian_VehicleData[ac_vehid][ac_sprayjob] = 0;
	for(new compslot = 0; compslot < 13; compslot++)
	{
		Guardian_VehicleData[ac_vehid][ac_comp][compslot] = GetVehicleComponentInSlot(ac_vehid, compslot);
	}
	Iter_Add(Vehicle, ac_vehid);
	return ac_vehid;
}

public Guardian_AddStaticVehicleEx(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:angle, color1, color2, respawn_delay)
{
	new ac_vehid = AddStaticVehicleEx(modelid, spawn_x, spawn_y, spawn_z, angle, color1, color2, respawn_delay);
	Guardian_VehicleData[ac_vehid][ac_modelid] = modelid;
	Guardian_VehicleData[ac_vehid][ac_health] = 1000.0;
	Guardian_VehicleData[ac_vehid][ac_unnocx] = spawn_x;
	Guardian_VehicleData[ac_vehid][ac_unnocy] = spawn_y;
	Guardian_VehicleData[ac_vehid][ac_unnocz] = spawn_z;
	Guardian_VehicleData[ac_vehid][ac_col1] = color1;
	Guardian_VehicleData[ac_vehid][ac_col2] = color2;
	Guardian_VehicleData[ac_vehid][ac_sprayjob] = 0;
	for(new compslot = 0; compslot < 13; compslot++)
	{
		Guardian_VehicleData[ac_vehid][ac_comp][compslot] = GetVehicleComponentInSlot(ac_vehid, compslot);
	}
	Iter_Add(Vehicle, ac_vehid);
	return ac_vehid;
}

public Guardian_CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay)
{
	new ac_vehid = CreateVehicle(modelid, x, y, z, angle, color1, color2, respawn_delay);
	Guardian_VehicleData[ac_vehid][ac_modelid] = modelid;
	Guardian_VehicleData[ac_vehid][ac_health] = 1000.0;
	Guardian_VehicleData[ac_vehid][ac_unnocx] = x;
	Guardian_VehicleData[ac_vehid][ac_unnocy] = y;
	Guardian_VehicleData[ac_vehid][ac_unnocz] = z;
	Guardian_VehicleData[ac_vehid][ac_col1] = color1;
	Guardian_VehicleData[ac_vehid][ac_col2] = color2;
	Guardian_VehicleData[ac_vehid][ac_sprayjob] = 0;
	for(new compslot = 0; compslot < 13; compslot++)
	{
		Guardian_VehicleData[ac_vehid][ac_comp][compslot] = GetVehicleComponentInSlot(ac_vehid, compslot);
	}
	Iter_Add(Vehicle, ac_vehid);
	return ac_vehid;
}

public Guardian_DestroyVehicle(vehicleid)
{
	Guardian_VehicleData[vehicleid][ac_modelid] = 0;
	Guardian_VehicleData[vehicleid][ac_health] = 0.0;
	Guardian_VehicleData[vehicleid][ac_unnocx] = 0.0;
	Guardian_VehicleData[vehicleid][ac_unnocy] = 0.0;
	Guardian_VehicleData[vehicleid][ac_unnocz] = 0.0;
	Guardian_VehicleData[vehicleid][ac_col1] = 0;
	Guardian_VehicleData[vehicleid][ac_col2] = 0;
	Guardian_VehicleData[vehicleid][ac_sprayjob] = 0;
	for(new compslot = 0; compslot < 13; compslot++)
	{
		Guardian_VehicleData[vehicleid][ac_comp][compslot] = 0;
	}
	Iter_Remove(Vehicle, vehicleid);
	return DestroyVehicle(vehicleid);
}

public Guardian_ChangeVehicleColor(vehicleid, color1, color2)
{
	Guardian_VehicleData[vehicleid][ac_col1] = color1;
	Guardian_VehicleData[vehicleid][ac_col2] = color2;
	return ChangeVehicleColor(vehicleid, color1, color2);
}

public Guardian_AddVehicleComponent(vehicleid, componentid)
{
	new compslot = GetVehicleComponentType(componentid);
	Guardian_VehicleData[vehicleid][ac_comp][compslot] = componentid;
	return AddVehicleComponent(vehicleid, componentid);
}

public Guardian_RemoveVehicleComponent(vehicleid, componentid)
{
	new compslot = GetVehicleComponentType(componentid);
	Guardian_VehicleData[vehicleid][ac_comp][compslot] = 0;
	return RemoveVehicleComponent(vehicleid, componentid);
}

public Guardian_SetVehicleHealth(vehicleid, Float:health)
{
	Guardian_VehicleData[vehicleid][ac_health] = health;
	return SetVehicleHealth(vehicleid, Float:health);
}
/*
*AntiCheat CallBack Hooks
*/

public GuardianPlayerCheck(playerid)
{
	if(enterkey[playerid] > 0) enterkey[playerid] --;
	AntiCheatTimer[playerid] = AntiCheatTimer[playerid] + Guardian_PlayerCheckInterval;
	Guardian_PlayerData[playerid][tab_timer] = Guardian_PlayerData[playerid][tab_timer] + Guardian_PlayerCheckInterval;
	if(AntiCheatTimer[playerid] >= Guardian_ReNotificationTime)
	{
		AntiCheatTimer[playerid] = 0;
		for(new msgint = 0; msgint < 20; msgint++)
		{
			Guardian_PlayerData[playerid][ac_msginterval][msgint] = 0;
		}
	}
	if(ignoreac[playerid] == 1 || Guardian_PlayerData[playerid][ac_spawned] == 0 || Guardian_PlayerData[playerid][ac_dead] == 1) return 1;
	new pname[MAX_PLAYER_NAME+5], string[128], Float:tempfloat;
	GetPlayerName(playerid, pname, sizeof(pname));
	format(pname, sizeof(pname), "%s (%d)", pname, playerid);
	aclastreload[playerid] ++;
	if(Guardian_PlayerData[playerid][tab_timer]  > Guardian_TabLimit && Guardian_PlayerData[playerid][tab_timer]  < Guardian_TabLimit + Guardian_PlayerCheckInterval) 
	{
		format(string, sizeof(string), "%s is alt-tabbed", pname);
		CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERALTTAB, string);
		return 1;
	}
	if(Guardian_PlayerData[playerid][tab_timer]  > 10)  return 1;
	
	if(IsPlayerInAnyVehicle(playerid))
	{
		AntiCheatPVehTimer[playerid]++;
		if(AntiCheatPVehTimer[playerid] >= Guardian_ReNotificationTime)
		{
			for(new i = 0; i < 20; i++)
			{
				Guardian_VehicleData[GetPlayerVehicleID(playerid)][ac_msginterval][i] = 0;
			}
		}
		//GuardianVehicleCheck(GetPlayerVehicleID(playerid));
	}
	if(Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERTP] == 0)
	{
		if(!IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) != PLAYER_STATE_SPECTATING && IsPlayerInRangeOfPoint(playerid, 20.0*Guardian_PlayerCheckInterval, Guardian_PlayerData[playerid][lastposx], Guardian_PlayerData[playerid][lastposy], Guardian_PlayerData[playerid][lastposz]) == 0 && GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID)
		{
			format(string, sizeof(string), "%s is possibly teleporting.", pname);
			CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERTP, string);
			Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERTP] = 1;
			Guardian_PlayerData[playerid][ac_teleport]= 0;
		}
		
		if(GetPlayerInterior(playerid) != Guardian_PlayerData[playerid][ac_int])
		{
			format(string, sizeof(string), "%s is possibly teleporting between interiors.", pname);
			CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERTP, string);
			Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERTP]= 1;
			Guardian_PlayerData[playerid][ac_teleport]= 0;
		}
		
		if(GetPlayerVirtualWorld(playerid) != Guardian_PlayerData[playerid][ac_vw])
		{
			format(string, sizeof(string), "%s is possibly teleporting between virtual worlds.", pname);
			CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERTP, string);
			Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERTP] = 1;
			Guardian_PlayerData[playerid][ac_teleport]= 0;
		}
		
		if(Guardian_PlayerCheckInterval <= 5)
		{
			
		}
	}
	
	GetPlayerName(playerid, pname, sizeof(pname));
	if(Guardian_PlayerData[playerid][ac_money] + 50 < GetPlayerMoney(playerid))
	{
		if(Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERMONEY]  == 0)
		{
			new pmoney = GetPlayerMoney(playerid);
			pmoney = pmoney - Guardian_PlayerData[playerid][ac_money] ;
			format(string, sizeof(string), "%s has $%i more than they should.", pname, pmoney);
			CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERMONEY, string);
			Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERMONEY] = 1;
		}
	}

	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK && Guardian_PlayerData[playerid][ac_jetpack] == 0)
	{
		if(Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERJETPACK]  != 1)
		{
			format(string, sizeof(string), "%s has a jetpack, and shouldn't.", pname);
			CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERJETPACK, string);
			Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERJETPACK] = 1;
		}
	}

	GetPlayerHealth(playerid, tempfloat);
	if(tempfloat > Guardian_PlayerData[playerid][ac_health])
	{
		new hackedhp = 1;
		if(Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERHP] == 0)
		{
			if(IsNearSprunk(playerid) && enterkey[playerid] > 0)
			{
				if(tempfloat > 100 && Guardian_PlayerData[playerid][ac_health] < 100)
				{
				
				}
				else
				{
					Guardian_PlayerData[playerid][ac_health] = tempfloat;
					hackedhp = 0;
				}
			}
			if(hackedhp == 1 && GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
			{
				format(string, sizeof(string), "%s has %f health and should have %f.", pname, tempfloat, Guardian_PlayerData[playerid][ac_health]);
				CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERHP, string);
				Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERHP] = 1;
			}
		}
	}else Guardian_PlayerData[playerid][ac_health] = tempfloat;

	GetPlayerArmour(playerid, tempfloat);
	if(tempfloat > Guardian_PlayerData[playerid][ac_armour] && GetPlayerState(playerid) != 9)
	{
		if(Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERARMOUR]  == 0)
		{
			format(string, sizeof(string), "%s has %f armour and should have %f", pname, tempfloat, Guardian_PlayerData[playerid][ac_armour]);
			CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERARMOUR, string);
			Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERARMOUR] = 1;
		}
	}
	if(GetPlayerWeaponState(playerid) == 3 || GetPlayerWeaponState(playerid) == 0)
	{
		aclastreload[playerid] = 0;
		acshotsfired[playerid] = 0;
	}
	/*if(aclastreload[playerid] > 30 && acshotsfired[playerid] > 50)
	{
	
	}*/

	if(Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERWEAP]  == 0)
	{
		new cweapons[13][2], weaphacks, weapwarn[128]; //removed "ammohacks" cause it gave an error while compiling foco.pwn
		for (new i = 0; i < 12; i++)
		{
			GetPlayerWeaponData(playerid, i, cweapons[i][0], cweapons[i][1]);
		
			if(i == 11 && cweapons[i][0] == 46)//Parachute
			{
				GetPlayerPos(playerid, Guardian_PlayerData[playerid][lastposx], Guardian_PlayerData[playerid][lastposy], Guardian_PlayerData[playerid][lastposz]);
				return 1;
			}
			
			if(cweapons[i][0] != Guardian_PlayerData[playerid][ac_weap][i] && cweapons[i][0] != 0 && cweapons[i][1] != 0)
			{
				
				weaphacks ++;
				if(weaphacks > 1)
				{
					format(weapwarn, sizeof(weapwarn), "%s is hacking multiple weapons.", pname);
				}
				else
				{
					format(weapwarn, sizeof(weapwarn), "%s has a %s and should have a %s.", pname, Guardian_WeapNames[cweapons[i][0]][WeapName], Guardian_WeapNames[Guardian_PlayerData[playerid][ac_weap][i]][WeapName]);
				}
			}
		
			/*if(cweapons[i][1] > Guardian_PlayerData[playerid][ac_weapa][i] && Guardian_WeapNames[cweapons[i][0]][WeapSlot] != 0 && Guardian_WeapNames[cweapons[i][0]][WeapSlot] != 1)
			{
				ammohacks ++;
				if(ammohacks > 1)
				{
					format(string, sizeof(string), "%s is hacking ammo in multiple weapons.", pname);
				}
				else
				{
					format(string, sizeof(string), "%s has %i ammo in their %s and should have around %i.", pname, cweapons[i][1], Guardian_WeapNames[cweapons[i][0]][WeapName], Guardian_PlayerData[playerid][ac_weapa][i]);

				}
			}else Guardian_PlayerData[playerid][ac_weapa][i] = cweapons[i][1];*/
		}
		if(weaphacks > 0 )
		{
			CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERWEAP, weapwarn);
			Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERWEAP] = 1;
		}
		/*if(ammohacks > 0)
		{
			CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERAMMO, string);
			Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERAMMO] = 1;
		}*/
	}
	
	/*Position reloading*/
	GetPlayerPos(playerid, Guardian_PlayerData[playerid][lastposx], Guardian_PlayerData[playerid][lastposy], Guardian_PlayerData[playerid][lastposz]);
	return 1;
}

public GuardianVehicleCheck(vehicleid)
{
	/*new occustring[128], pname[56], Float:tempfloat, string[128];
	if(Guardian_VehicleData[vehicleid][ac_driver] != -1)
	{
		format(occustring, sizeof(occustring), "Driver: %s [%d]", pname, Guardian_VehicleData[vehicleid][ac_driver]);
	}
	else format(occustring, sizeof(occustring), "No Driver");
	
	if(Guardian_VehicleData[vehicleid][ac_modelid] == 0) return 1;
	
	GetVehicleHealth(vehicleid, tempfloat);
	if(tempfloat > Guardian_VehicleData[vehicleid][ac_health] && Guardian_VehicleData[vehicleid][ac_msginterval][GUARDIAN_VEHICLEHP] == 0)
	{
		format(string, sizeof(string), "Vehicle ID %d (%s) has %f health and should have %f.", vehicleid, occustring, tempfloat, Guardian_VehicleData[vehicleid][ac_health]);
		//CallRemoteFunction("OnGuardianVehicleWarning", "ddds", vehicleid, Guardian_VehicleData[vehicleid][ac_driver], GUARDIAN_VEHICLEHP, string);
		Guardian_VehicleData[vehicleid][ac_msginterval][GUARDIAN_VEHICLEHP] = 1;
	}else Guardian_VehicleData[vehicleid][ac_health] = tempfloat;
	
	new currentcomp[20], shouldcomp[20];
	for(new compslot = 0; compslot < 13; compslot++)
	{
		if(GetVehicleComponentInSlot(vehicleid, compslot) != Guardian_VehicleData[vehicleid][ac_comp][compslot] && Guardian_VehicleData[vehicleid][ac_msginterval][GUARDIAN_VEHICLEMOD] == 0)
		{
			if(GetVehicleComponentInSlot(vehicleid, compslot) == 0)
			{
				format(currentcomp, sizeof(currentcomp), "Standard %s", Guardian_CompSlotNames[compslot]);
			}else format(currentcomp, sizeof(currentcomp), "%s %s", Guardian_ModInfoArray[GetVehicleComponentInSlot(vehicleid, compslot)][Name], Guardian_CompSlotNames[compslot]);
			
			if(Guardian_VehicleData[vehicleid][ac_comp][compslot] == 0)
			{
				format(shouldcomp, sizeof(shouldcomp), "Standard %s", Guardian_CompSlotNames[compslot]);
			}else format(shouldcomp, sizeof(shouldcomp), "%s %s", Guardian_ModInfoArray[Guardian_VehicleData[vehicleid][ac_comp][compslot]][Name], Guardian_CompSlotNames[compslot]);
			format(string, sizeof(string), "Vehicle ID %d (%s) has a '%s' and should have a '%s'", vehicleid, occustring, currentcomp, shouldcomp);
			CallRemoteFunction("OnGuardianVehicleWarning", "ddds", vehicleid, Guardian_VehicleData[vehicleid][ac_driver], GUARDIAN_VEHICLEMOD, string);
			Guardian_VehicleData[vehicleid][ac_msginterval][GUARDIAN_VEHICLEMOD] = 1;
		}
	}*/
	return 1;
}

public GuardianDebug(string[])
{
	#if defined GUARDIAN_DEBUG
		SendClientMessageToAll(COLOR_RED, string);
		print(string);
	#endif
	return 1;
}


/* Callbacks*/

public OnGameModeInit()
{
	GuardianDebug("G_OnGameModeInIt");
	CallRemoteFunction("Guardian_OnGameModeInit", "");
	return 1;
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Guardian_OnGameModeInit
forward Guardian_OnGameModeInit();

public OnPlayerConnect(playerid)
{
	GuardianDebug("G_OnPlayerConnect");
	ResetACData(playerid);
	Guardian_PlayerData[playerid][ac_money] = 0;
	Guardian_PlayerData[playerid][ac_timer] = SetTimerEx("GuardianPlayerCheck", Guardian_PlayerCheckInterval*1000, true, "d", playerid);
	CallRemoteFunction("Guardian_OnPlayerConnect", "d", playerid);
	return 1;
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Guardian_OnPlayerConnect
forward Guardian_OnPlayerConnect(playerid);

public OnPlayerDisconnect(playerid, reason)
{
	GuardianDebug("G_OnPlayerDisconnect");
	KillTimer(Guardian_PlayerData[playerid][ac_timer]);
	ResetACData(playerid);
	CallRemoteFunction("Guardian_OnPlayerDisconnect", "dd", playerid, reason);
	return 1;
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Guardian_OnPlayerDisconnect
forward Guardian_OnPlayerDisconnect(playerid, reason);

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	GuardianDebug("G_OnPlayerStateChange");
	if(newstate == PLAYER_STATE_DRIVER)
	{
		Guardian_VehicleData[GetPlayerVehicleID(playerid)][ac_driver] = playerid;
		Guardian_PlayerData[playerid][ac_lastveh] = GetPlayerVehicleID(playerid);
		for(new i = 0; i < 20; i++)
		{
			Guardian_VehicleData[GetPlayerVehicleID(playerid)][ac_msginterval][i] = 0;
		}
	}
	else if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
	{
		if(IsAPlane(Guardian_PlayerData[playerid][ac_lastveh]))
		{
			Guardian_PlayerData[playerid][ac_weap][11] = 46;
			Guardian_PlayerData[playerid][ac_weapa][11] = 1;
		}
		Guardian_VehicleData[Guardian_PlayerData[playerid][ac_lastveh]][ac_driver] = -1;
		Guardian_PlayerData[playerid][ac_lastveh] = -1;
		
		ignoreac[playerid] = 1;
		AC_Delay(playerid);
		Guardian_PlayerData[playerid][ac_teleport] = 1;
		Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERTP] = 1;
		ignoreac[playerid] = 0;
	}
	if(newstate == PLAYER_STATE_PASSENGER)
	{
		Guardian_PlayerData[playerid][ac_lastveh] = GetPlayerVehicleID(playerid);
		for(new i = 0; i < 20; i++)
		{
			Guardian_VehicleData[GetPlayerVehicleID(playerid)][ac_msginterval][i] = 0;
		}
	}
	CallRemoteFunction("Guardian_OnPlayerStateChange", "ddd", playerid, newstate, oldstate);
	return 1;
}
#if defined _ALS_OnPlayerStateChange
    #undef OnPlayerStateChange
#else
    #define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange Guardian_OnPlayerStateChange
forward Guardian_OnPlayerStateChange(playerid, newstate, oldstate);

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	//new weaponID = GetPlayerWeapon(playerid), string[128];
	
	new pname[MAX_PLAYER_NAME+5];
	GetPlayerName(playerid, pname, sizeof(pname));
	format(pname, sizeof(pname), "%s (%d)", pname, playerid);
		
	if ((newkeys & KEY_SECONDARY_ATTACK) && !(oldkeys & KEY_SECONDARY_ATTACK) && !IsPlayerInAnyVehicle(playerid))
	{
		enterkey[playerid] = 2;
	}
	
	CallRemoteFunction("Guardian_OnPlayerKeyStateChange", "ddd", playerid, newkeys, oldkeys);
	return 1;
}
#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange Guardian_OnPlayerKeyStateChange
forward Guardian_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);

public OnPlayerSpawn(playerid)
{
	Guardian_PlayerData[playerid][ac_health] = 100.0;
	Guardian_PlayerData[playerid][ac_int] = 0;
	Guardian_PlayerData[playerid][ac_vw] = 0;
	GuardianDebug("G_OnPlayerSpawn");
	Guardian_PlayerData[playerid][ac_spawned] = 1;
	Guardian_PlayerData[playerid][ac_dead] = 0;
	CallRemoteFunction("Guardian_OnPlayerSpawn", "d", playerid);
	return 1;
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn Guardian_OnPlayerSpawn
forward Guardian_OnPlayerSpawn(playerid);

public OnPlayerDeath(playerid, killerid, reason)
{
	GuardianDebug("G_OnPlayerDeath");
	Guardian_PlayerData[playerid][ac_dead] = 1;
	Guardian_PlayerData[playerid][ac_spawned] = 0;
	if(GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
	{
		new killername[56], name[56], string[255]; 
		GetPlayerName(killerid, killername, sizeof(killername));
		GetPlayerName(playerid, name, sizeof(name));
		format(string, sizeof(string), "%s has killed %s(%d) whilst being the driver of a vehicle.", killername, name, playerid);
		CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERDDB	, string);
	}
	CallRemoteFunction("Guardian_OnPlayerDeath", "ddd", playerid, killerid, reason);
	return 1;
}
#if defined _ALS_OnPlayerDeath
    #undef OnPlayerDeath
#else
    #define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath Guardian_OnPlayerDeath
forward Guardian_OnPlayerDeath(playerid, killerid, reason);

public OnPlayerUpdate(playerid)
{
	Guardian_PlayerData[playerid][tab_timer] = 0;
	
	if(UsePedAnims == 1 && Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERCJRUN] == 0 && GetPlayerAnimationIndex(playerid))
	{
		new animlib[32],animname[32];
		GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,animname,32);
		if(strcmp(animlib, "PED", true) == 0)
		{
			if(strcmp(animname, "RUN_PLAYER", true) == 0)
			{
				new pname[MAX_PLAYER_NAME+5], string[128];
				GetPlayerName(playerid, pname, sizeof(pname));
				format(pname, sizeof(pname), "%s (%d)", pname, playerid);
	
				format(string, sizeof(string), "%s is using CJ's running style, possible hacks.", pname);
				CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERCJRUN, string);
				Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERCJRUN] = 1;
			}
		}
	}
	
	CallRemoteFunction("Guardian_OnPlayerUpdate", "d", playerid);
	return 1;
}
#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate Guardian_OnPlayerUpdate
forward Guardian_OnPlayerUpdate(playerid);

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	GuardianDebug("G_OnVehiclePaintjob");
	Guardian_VehicleData[vehicleid][ac_sprayjob] = paintjobid;
	CallRemoteFunction("Guardian_OnVehiclePaintjob", "ddd", playerid, vehicleid, paintjobid);
	return 1;
}
#if defined _ALS_OnVehiclePaintjob
    #undef OnVehiclePaintjob
#else
    #define _ALS_OnVehiclePaintjob
#endif
#define OnVehiclePaintjob Guardian_OnVehiclePaintjob
forward Guardian_OnVehiclePaintjob(playerid, vehicleid, paintjobid);

/*
public OnPlayerText(playerid, text[])
{
	GuardianDebug("G_OnPlayerText");

	if(!strcmp(text, Guardian_PlayerData[playerid][last_message], false, strlen(text)) && strlen(Guardian_PlayerData[playerid][last_message]) != 0)
	{
		SendClientMessage(playerid, 0xfffff, "No need to repeat yourself.");
		return 0;
	}
	if(containsip(text))
	{
		if(Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERADVERTISE]  != 1)
		{
			new pname[MAX_PLAYER_NAME+5], string[128];
			GetPlayerName(playerid, pname, sizeof(pname));
			format(string, sizeof(string), "%s has just tried to advertise his server with '%s'", pname, text);
			CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERADVERTISE, string);
			Guardian_PlayerData[playerid][ac_msginterval][GUARDIAN_PLAYERADVERTISE] = 1;
		}
		return 0;
	}
	if(Muted[playerid] == 0)
	{
		CallRemoteFunction("Guardian_OnPlayerText", "ds", playerid, text);
		return 1;
	}
}
#if defined _ALS_OnPlayerText
    #undef OnPlayerText
#else
    #define _ALS_OnPlayerText
#endif
#define OnPlayerText Guardian_OnPlayerText
forward Guardian_OnPlayerText(playerid, text[]);
*/
// FUNCTIONS
#define UsePlayerPedAnims Guardian_UsePlayerPedAnims
#define GivePlayerMoney Guardian_GivePlayerMoney
#define SetPlayerInterior Guardian_SetPlayerInterior
#define SetPlayerVirtualWorld Guardian_SetPlayerVirtualWorld
#define SetPlayerSkin Guardian_SetPlayerSkin
#define SetPlayerMoney Guardian_SetPlayerMoney
#define SetPlayerHealth Guardian_SetPlayerHealth
#define SetPlayerPos Guardian_SetPlayerPos
#define SetVehiclePos Guardian_SetVehiclePos
#define SetPlayerArmour Guardian_SetPlayerArmour
#define GetPlayerMoney Guardian_GetPlayerMoney
#define ResetPlayerWeapons Guardian_ResetPlayerWeapons
#define GivePlayerWeapon Guardian_GivePlayerWeapon
#define SetSpawnInfo Guardian_SetSpawnInfo
#define SetPlayerSpecialAction Guardian_SetPlayerSpecialAction

#define AddStaticVehicle Guardian_AddStaticVehicle
#define AddStaticVehicleEx Guardian_AddStaticVehicleEx
#define CreateVehicle Guardian_CreateVehicle
#define DestroyVehicle Guardian_DestroyVehicle
#define ChangeVehicleColor Guardian_ChangeVehicleColor
#define AddVehicleComponent Guardian_AddVehicleComponent
#define RemoveVehicleComponent Guardian_RemoveVehicleComponent
#define SetVehicleHealth Guardian_SetVehicleHealth

// STOCKS

stock IsAPlane(carid)
{
	if(GetVehicleModel(carid) == 592 || GetVehicleModel(carid) == 577 || GetVehicleModel(carid) == 511 || GetVehicleModel(carid) == 512 || GetVehicleModel(carid) == 593 || GetVehicleModel(carid) == 520 || GetVehicleModel(carid) == 553 || GetVehicleModel(carid) == 476 || GetVehicleModel(carid) == 519 || GetVehicleModel(carid) == 460 || GetVehicleModel(carid) == 513)
	{
		return 1;
	}
	return 0;
}
stock IsNearSprunk(playerid)
{
	for(new sprunk = 0; sprunk < 43; sprunk++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5, SprunkLocations[sprunk][0] , SprunkLocations[sprunk][1], SprunkLocations[sprunk][2]))
		{
			return 1;
		}
	}
	return 0;
}

stock containsip(text[]) {
	
	new numbers[255] = {0, 0, ... };
	new adding_at_arr_idx = 0;
	
	new tstate = 0;
	new starting = -1;
	new longnums = 0;
	//new possible_port = false;
	//new good_port_candidate = -1;
	new i;
	new slen;
	slen = strlen(text);
	
	for (i = 0; i <= slen; i++) {
		
		new news = 0;
		new check_it = false;
		
		if (i == slen) { // last one
			
			// TODO: should only do it if last char was a numeric one!
			
			check_it = true;
		} else {
			
			new onechar[2]; onechar[0] = text[i]; // get just 1 character
			onechar[1] = 0;
			
			if ((onechar[0] == '0') || (strval(onechar[0]) > 0)) { // is a numeric character
				news = 1;
				
				//printf("found a numeric char %s (%d) at %d", onechar, strval(onechar), i);
				
				if (tstate != news) // switched into numbers
					starting = i;
				
			} else {
				
				//printf("%s - %s is not very numeric.", onechar[0]);
				
				check_it = true;
			}
		}
		
		if (check_it) {
			news = 2;
			
			if (tstate != news) { // hit text again
				
				new numeric[255];
				new numasnum;
				
				if (starting == -1)
					continue; // WTF? no starting position?
				
				strCopy(numeric, text[starting], i - starting + 1);
				
				numasnum = strval(numeric);
				
				// 1..255 or 1000..9999
				if (((numasnum > 0) && (numasnum < 255)) || ((numasnum > 999) && (numasnum < 10000))) {
					numbers[adding_at_arr_idx] = numasnum;
					adding_at_arr_idx++;
					
					if (numasnum > 9) // see how many are 2 or more chars so we filter out shitty leetspeak
						longnums++;
					
				}
			}
			
		}
		
		tstate = news;
	}
	
	if ((longnums < 2) || (adding_at_arr_idx < 4)) // need at least 4 parts.
		return false;
	
	// if you want to print out the IP address + port found..
	
	/*
	printf("testing string: %s", text);
	printf("total: %d", adding_at_arr_idx);
	
	foreach(numbers, anum) {
		if (anum >= adding_at_arr_idx)
			break;
		
		printf("got %d", numbers[anum]);
	}
	*/
	
	return true;
}

 stock strCopy(sDest[], const sSource[], lMaxLength = sizeof(sDest)) 
 {
	new lSrcLength = min(strlen(sSource), lMaxLength==1?cellmax:lMaxLength-1);
	memcpy(sDest, sSource, 0, lSrcLength * 4, lSrcLength);
	sDest[lSrcLength] = 0;
}
