#include <a_samp>
#include <foreach>
#include <YSI\y_hooks>


/* Defines for Guardian Codes*/

/* PLAYERS */
#define GUARDIAN_PLAYERHP	0 //- Health Hacking
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
/* VEHICLES */
#define GUARDIAN_VEHICLEHP	0 //- Health
#define GUARDIAN_VEHICLETP	1 //- Teleport Hacks
#define GUARDIAN_VEHICLEAIRBREAK	2 //- Airbreaking Hacks
#define GUARDIAN_VEHICLESPEED	3 //- Speed Hacks
#define GUARDIAN_VEHICLESPIDER	4 //- Spider Hack
#define GUARDIAN_VEHICLEMOD	5 //- Mod hacks

#define MAX_SPEED	(198)

/* Player check timer */

new
	GuardianCheckTimer;

forward TeleportTimer(playerid);
forward GuardianCheck();

/* Callbacks*/
forward OnGuardianPlayerWarning(playerid, warncode, reason[]);
forward OnGuardianVehicleWarning(vehicleid, driver, warncode, reason[]);

/* Functions */
forward SetTabbedLimit(limit); // -1 to ignore Tab times, default 600
forward SetPlayerCheckInterval(checktime); //Set how long in seconds between each player check
forward SetWarningReNotificationTime(time); //Seconds
forward GetGuardianReportForPlayer(playerid, strdest[][]);
forward SendGuardianPlayerWarning(string[], playerid, warncode);

forward AC_Delay(playerid);
forward ResetACData(playerid);

/* Hooked Functions */
/*
//forward Guardian_UsePlayerPedAnims();
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
*/
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

new
	ignoreac[MAX_PLAYERS];

/* Settings */
new
	Guardian_CheatTimer[MAX_PLAYERS],
	Guardian_PlayerCheckInterval = 5,
	Guardian_ReNotificationTime = 120;

/*new
	Iterator:Vehicle<MAX_VEHICLES>;
*/
/* Weapon info */

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

/* Sprunk locations (currently not needed as sprunk machines are disabled) */
/*
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
*/

/* Enumerations */

/* Player Data */
enum Guardian_Player
{
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
	ac_spawned
};
new
	Guardian_PlayerData[MAX_PLAYERS][Guardian_Player];

/* Vehicle Data */
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
new
	Guardian_VehicleData[MAX_VEHICLES][Guardian_Vehicle];

/* *** Functions *** */

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
	Guardian_PlayerData[playerid][ac_teleport] = 0;
	Guardian_PlayerData[playerid][lastposx] = 0.0;
	Guardian_PlayerData[playerid][lastposy] = 0.0;
	Guardian_PlayerData[playerid][lastposz] = 0.0;
	Guardian_PlayerData[playerid][ac_int] = 0;
	Guardian_PlayerData[playerid][ac_vw] = 0;
	Guardian_PlayerData[playerid][ac_lastveh] = 0;
	Guardian_PlayerData[playerid][ac_dead] = 0;
	Guardian_PlayerData[playerid][ac_spawned] = 0;
	return 1;
}

public AC_Delay(playerid)
{
	Guardian_CheatTimer[playerid] = Guardian_ReNotificationTime - 10;
	return 1;
}

// Hooked functions
/*
public Guardian_GivePlayerMoney(playerid, amount)
{
	ignoreac[playerid] = 1;
	AC_Delay(playerid);
	Guardian_PlayerData[playerid][ac_money] = Guardian_PlayerData[playerid][ac_money]+amount;
	ResetPlayerMoney(playerid);
	ignoreac[playerid] = 0;
	return GivePlayerMoney(playerid, Guardian_PlayerData[playerid][ac_money]);
}

#define GivePlayerMoney Guardian_GivePlayerMoney
*/
public Guardian_SetPlayerMoney(playerid, amount)
{
	ignoreac[playerid] = 1;
	AC_Delay(playerid);
	ResetPlayerMoney(playerid);
	Guardian_PlayerData[playerid][ac_money] = amount;
	ignoreac[playerid] = 0;
	return GivePlayerMoney(playerid, Guardian_PlayerData[playerid][ac_money]);
}
#define SetPlayerMoney Guardian_SetPlayerMoney
/*
public Guardian_SetPlayerInterior(playerid, amount)
{
	if(Guardian_PlayerData[playerid][ac_dead] == 1)
	{
		return 1;
	}

	Guardian_PlayerData[playerid][ac_int] = amount;
	return SetPlayerInterior(playerid, amount);
}
#define SetPlayerInterior Guardian_SetPlayerInterior

public Guardian_SetPlayerVirtualWorld(playerid, amount)
{
	if(Guardian_PlayerData[playerid][ac_dead] == 1)
	{
		return 1;
	}
	
	Guardian_PlayerData[playerid][ac_vw] = amount;
	return SetPlayerVirtualWorld(playerid, amount);
}
#define SetPlayerVirtualWorld Guardian_SetPlayerVirtualWorld

public Guardian_SetPlayerHealth(playerid, Float:amount)
{
	if(Guardian_PlayerData[playerid][ac_dead] == 1)
	{
		return 1;
	}

	if(amount > 99.0 && amount != 9999.0)
	{
		amount = 99.0;
	}
	
	ignoreac[playerid] = 1;
	AC_Delay(playerid);
	Guardian_PlayerData[playerid][ac_health] = amount;
	ignoreac[playerid] = 0;

	return SetPlayerHealth(playerid, amount);
}
#define SetPlayerHealth Guardian_SetPlayerHealth

public Guardian_SetPlayerArmour(playerid, Float:amount)
{
	if(Guardian_PlayerData[playerid][ac_dead] == 1)
	{
		return 1;
	}
	
	ignoreac[playerid] = 1;
	AC_Delay(playerid);
	Guardian_PlayerData[playerid][ac_armour] = amount;
	ignoreac[playerid] = 0;
	return SetPlayerArmour(playerid, amount);
}
#define SetPlayerArmour Guardian_SetPlayerArmour

public Guardian_SetPlayerPos(playerid, Float:x, Float:y, Float:z)
{
	ignoreac[playerid] = 1;
	AC_Delay(playerid);
	Guardian_PlayerData[playerid][ac_teleport] = 1;
	SetTimerEx("TeleportTimer", 5000, false, "d", playerid);
	ignoreac[playerid] = 0;
	return SetPlayerPos(playerid, Float:x, Float:y, Float:z);
}
#define SetPlayerPos Guardian_SetPlayerPos

public Guardian_SetVehiclePos(vehicleid, Float:x, Float:y, Float:z)
{
	foreach(Player, playerid)
	{
		if(GetPlayerVehicleID(playerid) == vehicleid)
		{
			ignoreac[playerid] = 1;
			AC_Delay(playerid);
			Guardian_PlayerData[playerid][ac_teleport] = 1;
			SetTimerEx("TeleportTimer", 5000, false, "d", playerid);
			ignoreac[playerid] = 0;
		}
	}
	return SetVehiclePos(vehicleid, Float:x, Float:y, Float:z);
}
#define SetVehiclePos Guardian_SetVehiclePos

public Guardian_GetPlayerMoney(playerid)
{
	return Guardian_PlayerData[playerid][ac_money];
}
#define GetPlayerMoney Guardian_GetPlayerMoney

public Guardian_ResetPlayerWeapons(playerid)
{
	ignoreac[playerid] = 1;
	for(new wpslot = 0; wpslot < 12; wpslot++)
	{
		Guardian_PlayerData[playerid][ac_weap][wpslot] = 0;
		Guardian_PlayerData[playerid][ac_weapa][wpslot] = 0;
	}
	ignoreac[playerid] = 0;
	return ResetPlayerWeapons(playerid);
}
#define ResetPlayerWeapons Guardian_ResetPlayerWeapons

public Guardian_GivePlayerWeapon(playerid, weaponid, ammo)
{
	if(Guardian_PlayerData[playerid][ac_dead] == 1)
	{
		return 1;
	}
	
	ignoreac[playerid] = 1;
    AC_Delay(playerid);
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
#define GivePlayerWeapon Guardian_GivePlayerWeapon

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
#define SetSpawnInfo Guardian_SetSpawnInfo

public Guardian_SetPlayerSpecialAction(playerid, specialaction)
{
	if(Guardian_PlayerData[playerid][ac_dead] == 1)
	{
		return 1;
	}
	
	ignoreac[playerid] = 1;
	
	if(specialaction == SPECIAL_ACTION_USEJETPACK)
	{
	    AC_Delay(playerid);
		Guardian_PlayerData[playerid][ac_jetpack] = 1;
	}
	
	ignoreac[playerid] = 0;
	return SetPlayerSpecialAction(playerid, specialaction);
}
#define SetPlayerSpecialAction Guardian_SetPlayerSpecialAction
*/
/*
hook OnGameModeInit()
{
	GuardianCheckTimer = SetTimer("GuardianCheck", 1250, true);
}

hook OnPlayerConnect(playerid)
{
    ResetACData(playerid);
	Guardian_PlayerData[playerid][ac_money] = 0;
}

hook OnPlayerDisconnect(playerid)
{
	SendClientMessageToAll(COLOR_YELLOW, "[DEBUG] OnPlayerDisconnect - anticheat.pwn 1"
	ResetACData(playerid);
	SendClientMessageToAll(COLOR_YELLOW, "[DEBUG] OnPlayerDisconnect - anticheat.pwn 2"
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
	    Guardian_VehicleData[GetPlayerVehicleID(playerid)][ac_driver] = playerid;
		Guardian_PlayerData[playerid][ac_lastveh] = GetPlayerVehicleID(playerid);
	}
	
	else if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER) // If a player leaves a plane while in flight
	{
		if(IsAPlane(Guardian_PlayerData[playerid][ac_lastveh]))
		{
			Guardian_PlayerData[playerid][ac_weap][11] = 46; // Parachute
			Guardian_PlayerData[playerid][ac_weapa][11] = 1;
		}
		
		Guardian_VehicleData[Guardian_PlayerData[playerid][ac_lastveh]][ac_driver] = -1;
		Guardian_PlayerData[playerid][ac_lastveh] = -1;

		ignoreac[playerid] = 1;
		AC_Delay(playerid);
		Guardian_PlayerData[playerid][ac_teleport] = 1;
		SetTimerEx("TeleportTimer", 5000, false, "d", playerid);
		ignoreac[playerid] = 0;
	}
	if(newstate == PLAYER_STATE_PASSENGER)
	{
		Guardian_PlayerData[playerid][ac_lastveh] = GetPlayerVehicleID(playerid);
	}
}

hook OnPlayerSpawn(playerid)
{
	Guardian_PlayerData[playerid][ac_health] = 100.0;
	Guardian_PlayerData[playerid][ac_int] = 0;
	Guardian_PlayerData[playerid][ac_vw] = 0;
	Guardian_PlayerData[playerid][ac_spawned] = 1;
	Guardian_PlayerData[playerid][ac_dead] = 0;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    Guardian_PlayerData[playerid][ac_dead] = 1;
	Guardian_PlayerData[playerid][ac_spawned] = 0;
	
	if(killerid != INVALID_PLAYER_ID)
	{
		if(GetPlayerState(killerid) == PLAYER_STATE_DRIVER && FoCo_Player[killerid][admin] == 0)
		{
			new
				string[128];
			format(string, sizeof(string), "%s(%d) has killed %s(%d) whilst being the driver of a vehicle.", PlayerName(killerid), killerid, PlayerName(playerid), playerid);
			CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERDDB, string);
		}
	}
}

hook OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    Guardian_VehicleData[vehicleid][ac_sprayjob] = paintjobid;
}

hook OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
	if(!Guardian_PlayerData[playerid][ac_armour])
	{
	    Guardian_PlayerData[playerid][ac_health] -= amount;
	}
	
	else
	{
	    if(Guardian_PlayerData[playerid][ac_armour] - amount >= 0)
	    {
	        Guardian_PlayerData[playerid][ac_armour] -= amount;
	    }
	    
	    else
	    {
	        Guardian_PlayerData[playerid][ac_health] -= (amount - Guardian_PlayerData[playerid][ac_armour]);
	        Guardian_PlayerData[playerid][ac_armour] = 0;
	    }
	}
}*/
// Main player check timer 
/*
public GuardianCheck()
{
	foreach(new playerid : Player)
	{
	    if(FoCo_Player[playerid][admin] > 0)
	    {
	        return 1;
	    }
	    
		Guardian_CheatTimer[playerid] = Guardian_CheatTimer[playerid] + Guardian_PlayerCheckInterval;
		if(Guardian_CheatTimer[playerid] >= Guardian_ReNotificationTime)
		{
		    Guardian_CheatTimer[playerid] = 0;
  		}
  		
  		if(ignoreac[playerid] == 1 || Guardian_PlayerData[playerid][ac_spawned] == 0 || Guardian_PlayerData[playerid][ac_dead] == 1)
		{
			return 1;
		}
		
		new
		    string[128];
		    
 		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(GetVehicleSpeed(vehicleid) > MAX_SPEED)
            {
                if(GetVehicleModel(vehicleid) != 520)
                {
                    new Float: vehicleVelocity[3];
                    GetVehicleVelocity(vehicleid, vehicleVelocity[0], vehicleVelocity[1], vehicleVelocity[2]);
                    if(vehicleVelocity[2] > -0.5)
                    {
                       	format(string, sizeof(string), "%s is possibly speed hacking.", PlayerName(playerid));
						CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERSPEED, string);
		             
                    }
                }
            }
		}
		
		if(Guardian_PlayerData[playerid][ac_teleport] == 0) // If player wasn't teleported recently 
		{
            if(!IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) != PLAYER_STATE_SPECTATING && IsPlayerInRangeOfPoint(playerid, 20.0*Guardian_PlayerCheckInterval, Guardian_PlayerData[playerid][lastposx], Guardian_PlayerData[playerid][lastposy], Guardian_PlayerData[playerid][lastposz]) == 0 && GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID)
			{
				format(string, sizeof(string), "%s is possibly teleporting.", PlayerName(playerid));
				CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERTP, string);
				Guardian_PlayerData[playerid][ac_teleport] = 0;
			}
			
			if(GetPlayerInterior(playerid) != Guardian_PlayerData[playerid][ac_int])
	        {
				format(string, sizeof(string), "%s is possibly teleporting between interiors.", PlayerName(playerid));
				CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERTP, string);
				Guardian_PlayerData[playerid][ac_teleport] = 0;
			}

			if(GetPlayerVirtualWorld(playerid) != Guardian_PlayerData[playerid][ac_vw])
			{
				format(string, sizeof(string), "%s is possibly teleporting between virtual worlds.", PlayerName(playerid));
				CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERTP, string);
				Guardian_PlayerData[playerid][ac_teleport] = 0;
			}
		}
		
		if(Guardian_PlayerData[playerid][ac_money] + 50 < GetPlayerMoney(playerid))
		{
			new pmoney = GetPlayerMoney(playerid);
			pmoney = pmoney - Guardian_PlayerData[playerid][ac_money] ;
			format(string, sizeof(string), "%s has $%i more than they should.", PlayerName(playerid), pmoney);
			CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERMONEY, string);
		}
		
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK && Guardian_PlayerData[playerid][ac_jetpack] == 0)
		{
			format(string, sizeof(string), "%s has a jetpack, and shouldn't.", PlayerName(playerid));
			CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERJETPACK, string);
		}

		new
		    Float:tempfloat; // Temp float to check current HP/ARMOUR 
		    
		GetPlayerHealth(playerid, tempfloat);
		if(tempfloat > Guardian_PlayerData[playerid][ac_health] && GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
		{
 		        format(string, sizeof(string), "%s has %f health and should have %f.", PlayerName(playerid), tempfloat, Guardian_PlayerData[playerid][ac_health]);
				CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERHP, string);
		}
		
		GetPlayerArmour(playerid, tempfloat);
		if(tempfloat > Guardian_PlayerData[playerid][ac_armour] && GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
		{
			format(string, sizeof(string), "%s has %f armour and should have %f", PlayerName(playerid), tempfloat, Guardian_PlayerData[playerid][ac_armour]);
			CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERARMOUR, string);
		}
		
		new
			cweapons[13][2],
			weaphacks;
			
        for (new i = 0; i < 12; i++)
		{
			GetPlayerWeaponData(playerid, i, cweapons[i][0], cweapons[i][1]);

			if(cweapons[i][0] == 46) // Parachute 
			{
				GetPlayerPos(playerid, Guardian_PlayerData[playerid][lastposx], Guardian_PlayerData[playerid][lastposy], Guardian_PlayerData[playerid][lastposz]);
				return 1;
			}

			if(cweapons[i][0] != Guardian_PlayerData[playerid][ac_weap][i] && cweapons[i][0] != 0 && cweapons[i][1] != 0)
			{
				weaphacks ++;
				if(weaphacks > 1)
				{
					format(string, sizeof(string), "%s is hacking multiple weapons.", PlayerName(playerid));
				}
				else
				{
					format(string, sizeof(string), "%s has a %s and should have a %s.", PlayerName(playerid), Guardian_WeapNames[cweapons[i][0]][WeapName], Guardian_WeapNames[Guardian_PlayerData[playerid][ac_weap][i]][WeapName]);
				}
			}
		}
		
		if(weaphacks > 0)
		{
			CallRemoteFunction("OnGuardianPlayerWarning", "dds", playerid, GUARDIAN_PLAYERWEAP, string);
		}

		GetPlayerPos(playerid, Guardian_PlayerData[playerid][lastposx], Guardian_PlayerData[playerid][lastposy], Guardian_PlayerData[playerid][lastposz]);
	}
	
	return 1;
}
*/
/* Reset TP Var after a few seconds */
public TeleportTimer(playerid)
{
    Guardian_PlayerData[playerid][ac_teleport] = 0;
    return 1;
}


/* STOCK */

stock IsAPlane(carid)
{
	if(GetVehicleModel(carid) == 592 || GetVehicleModel(carid) == 577 || GetVehicleModel(carid) == 511 || GetVehicleModel(carid) == 512 || GetVehicleModel(carid) == 593 || GetVehicleModel(carid) == 520 || GetVehicleModel(carid) == 553 || GetVehicleModel(carid) == 476 || GetVehicleModel(carid) == 519 || GetVehicleModel(carid) == 460 || GetVehicleModel(carid) == 513)
	{
		return 1;
	}
	return 0;
}

stock GetVehicleSpeed(vehicleid)
{
    new Float: vVel[3];
	GetVehicleVelocity(vehicleid, vVel[0], vVel[1], vVel[2]);
	return floatround(floatsqroot((vVel[0]*vVel[1]+vVel[2]*vVel[2]))*100.0*1.6);
}

