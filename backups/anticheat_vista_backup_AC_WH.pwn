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
* Filename:  anticheat.pwn                                                       *
* Author:  	 dr_vista       													 *
*********************************************************************************/

/*
	TODO:
			- Health Hacks => Done
			- Armour Hacks => Done
			- Money Hacks => Done
			- Weapon Hacks => Done
			- Ammo Hacks =>  Done
			- Fix parachute Issue => Done
			- Jetpack Hacks => Done
			- TP / Airbreak Hacks => Done, fixed falling through the map false-positive
			- Speed hacks => Peds & Cars done
			- Car hacks => HP done
*/

new
	Desync_Health,
	Desync_Armour,
	Desync_Weapons,
	Desync_Ammo;
	
/* Includes */
#include <YSI\y_hooks>

/* Defines */

#define NOTIFICATION_TIME 10
#define MAX_CAR_SPEED 230
#define MAX_PLANE_SPEED 260

//#define ADMIN_BYPASS /* Comment out if you want the anticheat to check admins. (Note: not checking admins saves CPU time). */
#define CrashPlayer(%0)  SetPlayerAttachedObject(%0, 0, %0, 0);

    
/* Cheat IDs */
#define CHEAT_HEALTH      0
#define CHEAT_ARMOUR      1
#define CHEAT_MONEY       2
#define CHEAT_WEAPONS     3
#define CHEAT_AMMO        4
#define CHEAT_AIRBREAK	  5
#define CHEAT_FLY	      6 
#define CHEAT_MAPCLICK    7
#define CHEAT_JETPACK     8
#define CHEAT_CARHP       9
#define CHEAT_CARSPEED    10
#define CHEAT_MODIFIEDDMG 11

/* Forwards */

forward AntiCheat_GivePlayerMoney(playerid, amount);
forward AntiCheat_SetPlayerMoney(playerid, amount);
forward AntiCheat_SendWarning(playerid, cheatid, extraid);
forward AntiCheat_SetPlayerHealth(playerid, Float:hp);
forward AntiCheat_SetPlayerArmour(playerid, Float:armor);
forward AntiCheat_ResetPlayerMoney(playerid);
forward AntiCheat_GivePlayerWeapon(playerid, weaponid, wpammo);
forward AntiCheat_ResetPlayerWeapons(playerid);
forward AntiCheat_SetPlayerAmmo(playerid, weaponid, wpammo);
forward AntiCheat_SetPlayerPos(playerid, Float:x, Float:z, Float:y);
forward AC_SetPlayerSpecialAction(playerid, specialaction);
forward AntiCheat_ClearAnimations(playerid);
forward AntiCheat_AddStaticVehicle(mdlid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:angle, color1, color2);
forward AntiCheat_AddStaticVehicleEx(mdlid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:angle, color1, color2, respawn_delay);
forward AntiCheat_CreateVehicle(mdlid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay);
forward AntiCheat_DestroyVehicle(vehicleid);
forward AntiCheat_SetVehicleHealth(vehicleid, Float:hp);
forward AntiCheat_RepairVehicle(vehicleid);
forward AntiCheat_SetVehiclePos(vehicleid, Float:x, Float:y, Float:z);
forward AntiCheat_GetPlayerMoney(playerid);
forward AntiCheat_SetSpawnInfo(playerid, pteam, pskin, Float:px, Float:py, Float:pz, Float:pAngle, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo);

forward ResetACData(playerid);

/* Anti-Cheat Notifications Toggle */
enum E_AC_NotificationData
{
	bool:ac_not_all,
	bool:ac_not_airbreak,
	bool:ac_not_ammo,
	bool:ac_not_armour,
	bool:ac_not_carhealth,
	bool:ac_not_carspeed,
	bool:ac_not_fly,
	bool:ac_not_health,
	bool:ac_not_jetpack,
	bool:ac_not_mapclick,
	bool:ac_not_modifieddmg,
	bool:ac_not_money,
	bool:ac_not_weapons
}

new 
	AC_NotificationDisabled[E_AC_NotificationData];

/* Player Data */

enum e_AntiCheatPlayerInfo
{
	Float:ac_health,
	Float:ac_armour,
	ac_money,
	ac_weapons[13],
	ac_ammo[13],
	ac_dead,
	Float:ac_x,
	Float:ac_y,
	Float:ac_z,
	ac_teleported,
	ac_surfing,
	ac_lastvehicle,
	ac_playerstate,
	ac_falling,
	ac_leftcar,
	ac_clickedmap,
	Float:click_X,
	Float:click_Y,
	Float:click_Z,
	ac_jetpack,
	ac_modshop,
	ac_int
};

static
		PlayerData[MAX_PLAYERS][e_AntiCheatPlayerInfo];
		
/* Vehicle Data */

enum e_AntiCheatVehicleInfo
{
	Float:acv_health,
	acv_modelid,
	acv_driver
};		

static
		VehicleData[MAX_VEHICLES][e_AntiCheatVehicleInfo];

new
	Iterator:Vehicle<MAX_VEHICLES>;
		
/* Cheats notification time */

enum e_NotificationTime
{
	acn_health,
	acn_armour,
	acn_money,
	acn_weapons,
	acn_ammo,
	acn_position,
	acn_jetpack,
	acn_vehicle,
	acn_damage
};

static
		CheatNotificationTime[MAX_PLAYERS][e_NotificationTime];

/* Sync system variables */

enum e_SyncSystem
{
	acs_health,
	acs_armour,
	acs_weapons[13],
	acs_ammo[13],
	acs_position,
	acs_vehicle
};

static
		PlayerLastUpdated[MAX_PLAYERS][e_SyncSystem],
		PlayerSynced[MAX_PLAYERS][e_SyncSystem],
		UpdateFail[MAX_PLAYERS][e_SyncSystem];
		
/* 					Warning system:

					Each time a player is flagged for cheating, he will receive a warning, 
					after a fixed amount of warnings within a period of time,
					admins will receive notifications about the player.
					
					If the player is not flagged by the anti cheat after a fixed amount of time, the warnings will reset.
					
					This will help resolve most false-positives, as in, a player getting slammed by a car and getting flagged for airbreak, etc..

*/					

#define RESET_WARN_TIME 60 // If no warnings are recorded during this time (seconds), the warnings will be reset.
#define AC_WARN_AMOUNT 3 // Amount of warnings before the admins are notified

enum e_PWarn
{
	pw_count,
	pw_lastwarn
};

static
		PWarn[MAX_PLAYERS][e_PWarn];
	
				
/* Weapons */

static const
				WeapSlots[47] = {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 10, 10, 8, 8, 8, -1, -1, -1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 4, 6, 6, 7, 7, 7, 7, 8, 12, 9, 9, 9, 11, 11, 11},

				AC_WeapNames[][] = {
				{"Unarmed (Fist)"},
				{"Brass Knuckles"},
				{"Golf Club"},
				{"Night Stick"},
				{"Knife"},
				{"Baseball Bat"},
				{"Shovel"},
				{"Pool Cue"},
				{"Katana"},
				{"Chainsaw"},
				{"Purple Dildo"},
				{"Big White Vibrator"},
				{"Medium White Vibrator"},
				{"Small White Vibrator"},
				{"Flowers"},
				{"Cane"},
				{"Grenade"},
				{"Teargas"},
				{"Molotov"},
				{" "},
				{" "},
				{" "},
				{"Colt 45"},
				{"Colt 45(Silenced)"},
				{"Deagle"},
				{"Normal Shotgun"},
				{"Sawnoff Shotgun"},
				{"Combat Shotgun"},
				{"Micro SMG"},
				{"MP5"},
				{"AK47"},
				{"M4"},
				{"Tec9"},
				{"Country Rifle"},
				{"Sniper Rifle"},
				{"Rocket Launcher"},
				{"Heat-Seeking Rocket Launcher"},
				{"Flamethrower"},
				{"Minigun"},
				{"Satchel Charge"},
				{"Detonator"},
				{"Spray Can"},
				{"Fire Extinguisher"},
				{"Camera"},
				{"Night Vision Goggles"},
				{"Infrared Vision Goggles"},
				{"Parachute"},
				{"Fake Pistol"}
				};
				
/* Pay'n'Spray coordinates */

static const
				Float:PayNSpray[][] = {
				{1977.213378, 2162.535156, 10.796499},
				{-100.248992, 1118.425415, 19.468778},
				{-1420.163940, 2586.447753, 55.570343},
				{-2426.851074, 1018.130126, 50.124687},
				{-1904.987792, 280.658477, 40.773948},
				{487.026214, -1740.143676, 10.846820},
				{1024.983520, -1022.391418, 31.828529},
				{2065.067138, -1833.406250, 13.273938},
				{720.489135, -450.550811, 16.055030}
				};
				
/* Expected weapon damage */

	/* First Weapon: colt45 (ID 22) - Last weapon: minigun (ID 38) 
		
	   Offset by 22 when using 'weaponid' as index
	*/

static const 
				Float:expectedDmg[17] = {8.25, 13.2, 46.2, 0.0, 0.0, 0.0, 6.6, 8.25, 9.9, 9.9, 6.6, 24.750001, 41.25, 0.0, 0.0, 0.0, 46.2};
		
/* Stocks */

stock Float:GetDistanceBetweenPoints(Float:rx1,Float:ry1,Float:rz1,Float:rx2,Float:ry2,Float:rz2)
{
    return floatadd(floatadd(floatsqroot(floatpower(floatsub(rx1,rx2),2)),floatsqroot(floatpower(floatsub(ry1,ry2),2))),floatsqroot(floatpower(floatsub(rz1,rz2),2)));
}

/* Timers */

ptask playerCheck[1000](playerid)
{
	#if defined ADMIN_BYPASS
	if(FoCo_Player[playerid][admin] > 0) return 1;
	#endif
	
	if(GetPlayerMoney(playerid) > PlayerData[playerid][ac_money])
	{
		PWarn[playerid][pw_count]++;
		PWarn[playerid][pw_lastwarn] = gettime();
					
		if(PWarn[playerid][pw_count] > AC_WARN_AMOUNT)
		{	
			AntiCheat_SendWarning(playerid, CHEAT_MONEY, GetPlayerMoney(playerid) - PlayerData[playerid][ac_money]);
		}
	}

	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK && PlayerData[playerid][ac_jetpack] == 0)
	{
	     AntiCheat_SendWarning(playerid, CHEAT_JETPACK, 0);
	}
	
	if(PWarn[playerid][pw_count] > 0)
	{
		if(gettime() - PWarn[playerid][pw_lastwarn]  > 60)
		{
			PWarn[playerid][pw_count] = 0;
		}
	}
	
	return 1;
}
			
/* Function hooks */

public AntiCheat_GivePlayerMoney(playerid, amount)
{
	PlayerData[playerid][ac_money] += amount;
	FoCo_Player[playerid][cash] = PlayerData[playerid][ac_money]; // Added this so it temporarily stops breaking everyones money. Come talk to me on IRC and I can explain. 
	return GivePlayerMoney(playerid, amount);
}
#define GivePlayerMoney AntiCheat_GivePlayerMoney

public AntiCheat_ResetPlayerMoney(playerid)
{
	PlayerData[playerid][ac_money] = 0;
	return ResetPlayerMoney(playerid);
}


#define ResetPlayerMoney AntiCheat_ResetPlayerMoney


public AntiCheat_SetPlayerMoney(playerid, amount)
{
	ResetPlayerMoney(playerid);
	return GivePlayerMoney(playerid, amount);
}
#define SetPlayerMoney AntiCheat_SetPlayerMoney

public AntiCheat_SetPlayerHealth(playerid, Float:hp)
{
	if(PlayerData[playerid][ac_dead] == 1) return 1;
	if(hp > 99 && hp != INFINITY) hp = 99.0;

	PlayerData[playerid][ac_health] = hp;
	PlayerSynced[playerid][acs_health] = 0;
	return SetPlayerHealth(playerid, hp);
}
#define SetPlayerHealth AntiCheat_SetPlayerHealth

public AntiCheat_SetPlayerArmour(playerid, Float:armor)
{
	if(PlayerData[playerid][ac_dead] == 1) return 1;

	PlayerData[playerid][ac_armour] = armor;
	PlayerSynced[playerid][acs_armour] = 0;
	return SetPlayerArmour(playerid, armor);
}
#define SetPlayerArmour AntiCheat_SetPlayerArmour

public AntiCheat_GivePlayerWeapon(playerid, weaponid, wpammo)
{
	if(PlayerData[playerid][ac_dead] == 1) return 1;

	if(PlayerData[playerid][ac_weapons][WeapSlots[weaponid]] == weaponid)
	{
	    PlayerData[playerid][ac_ammo][WeapSlots[weaponid]] += wpammo;
	}

	else PlayerData[playerid][ac_ammo][WeapSlots[weaponid]] = wpammo;

    PlayerData[playerid][ac_weapons][WeapSlots[weaponid]] = weaponid;


	PlayerSynced[playerid][acs_weapons][WeapSlots[weaponid]] = 0;
	PlayerSynced[playerid][acs_ammo][WeapSlots[weaponid]] = 0;
	
	return GivePlayerWeapon(playerid, weaponid, wpammo);

}
#define GivePlayerWeapon AntiCheat_GivePlayerWeapon

public AntiCheat_ResetPlayerWeapons(playerid)
{
	for(new i = 0; i < 13; i++)
	{
	    PlayerData[playerid][ac_weapons][i] = 0;
		PlayerData[playerid][ac_ammo][i] = 0;
		PlayerSynced[playerid][acs_weapons][i] = 0;
	}
    ResetedWeapon(playerid);
	return ResetPlayerWeapons(playerid);
}
#define ResetPlayerWeapons AntiCheat_ResetPlayerWeapons


public AntiCheat_SetPlayerAmmo(playerid, weaponid, wpammo)
{
	PlayerData[playerid][ac_ammo][WeapSlots[weaponid]] = wpammo;
	return SetPlayerAmmo(playerid, weaponid, wpammo);
}
#define SetPlayerAmmo AntiCheat_SetPlayerAmmo

public AntiCheat_SetPlayerPos(playerid, Float:x, Float:z, Float:y)
{
    PlayerSynced[playerid][acs_position] = 0;

    PlayerData[playerid][ac_teleported] = 1;
	PlayerData[playerid][ac_x] = x;
    PlayerData[playerid][ac_y] = y;
    PlayerData[playerid][ac_z] = z;

	return SetPlayerPos(playerid, Float:x, Float:z, Float:y);
}
#define SetPlayerPos AntiCheat_SetPlayerPos

public AC_SetPlayerSpecialAction(playerid, specialaction)
{
	if(specialaction == SPECIAL_ACTION_USEJETPACK)
	{
		PlayerData[playerid][ac_jetpack] = 1;
	}

	else
	{
		PlayerData[playerid][ac_jetpack] = 0;
	}

	return SetPlayerSpecialAction(playerid, specialaction);
}
#define SetPlayerSpecialAction AC_SetPlayerSpecialAction

public AntiCheat_ClearAnimations(playerid)
{
    PlayerData[playerid][ac_jetpack] = 0;
    return ClearAnimations(playerid);
}
#define ClearAnimations AntiCheat_ClearAnimations

public AntiCheat_AddStaticVehicle(mdlid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:angle, color1, color2)
{
	new vehicleid = AddStaticVehicle(mdlid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:angle, color1, color2);
	VehicleData[vehicleid][acv_health] = 1000;
	VehicleData[vehicleid][acv_modelid] = mdlid;
	Iter_Add(Vehicle, vehicleid);
	return vehicleid;
}
#define AddStaticVehicle AntiCheat_AddStaticVehicle


public AntiCheat_AddStaticVehicleEx(mdlid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:angle, color1, color2, respawn_delay)
{
	new vehicleid = AddStaticVehicleEx(mdlid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:angle, color1, color2, respawn_delay);
	VehicleData[vehicleid][acv_health] = 1000;
	VehicleData[vehicleid][acv_modelid] = mdlid;
	Iter_Add(Vehicle, vehicleid);
	return vehicleid;
}
#define AddStaticVehicleEx AntiCheat_AddStaticVehicleEx

public AntiCheat_CreateVehicle(mdlid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay)
{
	new vehicleid = CreateVehicle(mdlid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay);
	VehicleData[vehicleid][acv_health] = 1000;
	VehicleData[vehicleid][acv_modelid] = mdlid;
	Iter_Add(Vehicle, vehicleid);
	return vehicleid;
}
#define CreateVehicle AntiCheat_CreateVehicle

public AntiCheat_DestroyVehicle(vehicleid)
{
	VehicleData[vehicleid][acv_health] = 0;
	VehicleData[vehicleid][acv_modelid] = 0;
	Iter_Remove(Vehicle, vehicleid);
	return DestroyVehicle(vehicleid);
}
#define DestroyVehicle AntiCheat_DestroyVehicle

public AntiCheat_SetVehicleHealth(vehicleid, Float:hp)
{
	VehicleData[vehicleid][acv_health] = hp;
	return SetVehicleHealth(vehicleid, Float:hp);
}
#define SetVehicleHealth AntiCheat_SetVehicleHealth

public AntiCheat_RepairVehicle(vehicleid)
{
	VehicleData[vehicleid][acv_health] = 1000;
	return RepairVehicle(vehicleid);
}
#define RepairVehicle AntiCheat_RepairVehicle

public AntiCheat_SetVehiclePos(vehicleid, Float:x, Float:y, Float:z)
{
	foreach(Player, playerid)
	{
	    if(GetPlayerVehicleID(playerid) == vehicleid)
		{
			PlayerData[playerid][ac_teleported] = 1;
		}
	}

	return SetVehiclePos(vehicleid, Float:x, Float:y, Float:z);
}
#define SetVehiclePos AntiCheat_SetVehiclePos

public AntiCheat_GetPlayerMoney(playerid)
{
	return PlayerData[playerid][ac_money];
}
#define GetPlayerMoney AntiCheat_GetPlayerMoney 

public AntiCheat_SetSpawnInfo(playerid, pteam, pskin, Float:px, Float:py, Float:pz, Float:pAngle, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo)
{
	return SetSpawnInfo(playerid, pteam, pskin, Float:px, Float:py, Float:pz, Float:pAngle, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo);
}
#define SetSpawnInfo AntiCheat_SetSpawnInfo 

/* Anti Cheat Functions */

static AntiCheat_SendWarning(playerid, cheatid, extraid)
{
	if(AC_NotificationDisabled[ac_not_all]) return 1;

	new string[128], cheatstr[128], msgstring[128];

	switch(cheatid)
	{
		case CHEAT_HEALTH:
		{
			if(AC_NotificationDisabled[ac_not_health]) return 1;
			if(gettime() <= CheatNotificationTime[playerid][acn_health]) return 1;

			format(cheatstr, sizeof(cheatstr), "%s (%d) has %d health and should have %.0f.", PlayerName(playerid), playerid, extraid, PlayerData[playerid][ac_health]);
			CheatNotificationTime[playerid][acn_health] = gettime() + NOTIFICATION_TIME;

		}

		case CHEAT_ARMOUR:
		{
			if(AC_NotificationDisabled[ac_not_armour]) return 1;
			if(gettime() <= CheatNotificationTime[playerid][acn_armour]) return 1;

			format(cheatstr, sizeof(cheatstr), "%s (%d) has %d armour and should have %.0f.", PlayerName(playerid), playerid, extraid, PlayerData[playerid][ac_armour]);
			CheatNotificationTime[playerid][acn_armour] = gettime() + NOTIFICATION_TIME;
		}

		case CHEAT_MONEY:
		{
			if(AC_NotificationDisabled[ac_not_money]) return 1;
			if(gettime() <= CheatNotificationTime[playerid][acn_money]) return 1;

			format(cheatstr, sizeof(cheatstr), "%s (%d) has $%d more than they should. ($%d)", PlayerName(playerid), playerid, extraid, PlayerData[playerid][ac_money]);
			CheatNotificationTime[playerid][acn_money] = gettime() + NOTIFICATION_TIME;
		}
		
		case CHEAT_WEAPONS:
		{
			if(AC_NotificationDisabled[ac_not_weapons]) return 1;
		    if(gettime() <= CheatNotificationTime[playerid][acn_weapons]) return 1;
		    	

		    if(extraid != 0)
		    {
				if(extraid != 40 && extraid != 46)	// Tired of false positives for remote control when given a satchel lel.
				{
					format(cheatstr, sizeof(cheatstr), "%s (%d) is hacking a %s.", PlayerName(playerid), playerid, AC_WeapNames[extraid]);
				}
				if(extraid == 16 || extraid == 35 || extraid == 36 || extraid == 37 || extraid == 38)
				{
					if(AdminsOnline() == 0)
					{
						if(GetPVarInt(playerid, "sWepExc") != 1)
						{
							new banstr[56];
							format(banstr, sizeof(banstr), "Weapon hacking [%s]", AC_WeapNames[extraid]);
							ABanPlayer(-1, playerid, banstr);
						}
					}
				}
			}
			
			else
			{
			    format(cheatstr, sizeof(cheatstr), "%s (%d) is hacking multiple weapons.", PlayerName(playerid), playerid);
				new weapons[13][2];
				for(new i = 0; i <= 12; i++)
				{
					GetPlayerWeaponData(playerid, i, weapons[i][0], weapons[i][1]);
				}
				if(weapons[8][0] == 16 || weapons[7][0] == 35 || weapons[7][0] == 36 || weapons[7][0] == 37 || weapons[7][0] == 38)
				{
					if(AdminsOnline() == 0 && GetPVarInt(playerid, "sWepExc") != 1)
					{
						new guns[56];
						format(guns, sizeof(guns), "");
						if(weapons[8][0] == 16)
						{
							format(guns, sizeof(guns), "Grenades ", guns);
						}
						if(weapons[7][0] == 35)
						{
							if(strcmp(guns, "", true))
							{
								format(guns, sizeof(guns), "RPG ");
							}
							else
							{
								format(guns, sizeof(guns), "%sRPG ", guns);
							}
							
						}
						else if(weapons[7][0] == 36)
						{
							if(strcmp(guns, "", true))
							{
								format(guns, sizeof(guns), "H-RPG ");
							}
							else
							{
								format(guns, sizeof(guns), "%sH-RPG ", guns);
							}
						}
						else if(weapons[7][0] == 37)
						{
							if(strcmp(guns, "", true))
							{
								format(guns, sizeof(guns), "Flamethrower ");
							}
							else
							{
								format(guns, sizeof(guns), "%sFlamethrower ", guns);
							}
						}
						else if(weapons[7][0] == 38)
						{
							if(strcmp(guns, "", true))
							{
								format(guns, sizeof(guns), "Minigun ");
							}
							else
							{
								format(guns, sizeof(guns), "%sMinigun ", guns);
							}
						}
						
						new banstr[128];
						format(banstr, sizeof(banstr), "Weapon hacking [%s]", guns);
						ABanPlayer(-1, playerid, banstr);
					}
				}
			}

    		CheatNotificationTime[playerid][acn_weapons] = gettime() + NOTIFICATION_TIME;
		}
		
		case CHEAT_AMMO:
		{
			if(AC_NotificationDisabled[ac_not_ammo]) return 1;
		    if(gettime() <= CheatNotificationTime[playerid][acn_ammo]) return 1;
		    
		    if(extraid != 0)
		    {
		    	if(extraid != 40 && extraid != 46)	// Tired of false positives for remote control when given a satchel lel.
				{
					format(cheatstr, sizeof(cheatstr), "%s (%d) is hacking ammo for his %s.", PlayerName(playerid), playerid, AC_WeapNames[extraid]);
				}
		    }
		    
		    else
		    {
		        format(cheatstr, sizeof(cheatstr), "%s (%d) is hacking ammo for multiple weapons.", PlayerName(playerid), playerid);
		    }

		    CheatNotificationTime[playerid][acn_ammo] = gettime() + NOTIFICATION_TIME;
		}
		
		case CHEAT_AIRBREAK:
		{
			if(AC_NotificationDisabled[ac_not_airbreak]) return 1;
		    if(gettime() <= CheatNotificationTime[playerid][acn_position]) return 1;
		    
		    format(cheatstr, sizeof(cheatstr), "%s (%d) might be airbreaking.", PlayerName(playerid), playerid);
		    
		    CheatNotificationTime[playerid][acn_position] = gettime() + NOTIFICATION_TIME;
		}
		
		case CHEAT_FLY:
		{
			if(AC_NotificationDisabled[ac_not_fly]) return 1;
		    if(gettime() <= CheatNotificationTime[playerid][acn_position]) return 1;

		    format(cheatstr, sizeof(cheatstr), "%s (%d) might be using fly hacks.", PlayerName(playerid), playerid);

		    CheatNotificationTime[playerid][acn_position] = gettime() + NOTIFICATION_TIME;
		}
		
		case CHEAT_MAPCLICK:
		{
			if(AC_NotificationDisabled[ac_not_mapclick]) return 1;
		    if(gettime() <= CheatNotificationTime[playerid][acn_position]) return 1;

		    format(cheatstr, sizeof(cheatstr), "%s (%d) has used the map to teleport himself.", PlayerName(playerid), playerid);

		    CheatNotificationTime[playerid][acn_position] = gettime() + NOTIFICATION_TIME;
		}

		case CHEAT_JETPACK:
		{
			if(AC_NotificationDisabled[ac_not_jetpack]) return 1;
		    if(gettime() <= CheatNotificationTime[playerid][acn_jetpack]) return 1;

		    format(cheatstr, sizeof(cheatstr), "%s (%d) has a jetpack and shouldn't.", PlayerName(playerid), playerid);

		    CheatNotificationTime[playerid][acn_jetpack] = gettime() + NOTIFICATION_TIME;
		}
		
		case CHEAT_CARHP:
		{
			if(AC_NotificationDisabled[ac_not_carhealth]) return 1;
			if(gettime() <= CheatNotificationTime[playerid][acn_vehicle]) return 1;
			
			format(cheatstr, sizeof(cheatstr), "%s (%d)'s vehicle health is %d and should be %.0f.", PlayerName(playerid), playerid, extraid, VehicleData[PlayerData[playerid][ac_lastvehicle]][acv_health]);
		
			CheatNotificationTime[playerid][acn_vehicle] = gettime() + NOTIFICATION_TIME;
		}

		case CHEAT_CARSPEED:
		{
			if(AC_NotificationDisabled[ac_not_carspeed]) return 1;
			if(gettime() <= CheatNotificationTime[playerid][acn_vehicle]) return 1;

			format(cheatstr, sizeof(cheatstr), "%s (%d) might be speed hacking with his vehicle.", PlayerName(playerid), playerid);

			CheatNotificationTime[playerid][acn_vehicle] = gettime() + NOTIFICATION_TIME;
		}
		
		case CHEAT_MODIFIEDDMG:
		{
			if(AC_NotificationDisabled[ac_not_modifieddmg]) return 1;
			if(gettime() <= CheatNotificationTime[playerid][acn_damage]) return 1;

			format(cheatstr, sizeof(cheatstr), "%s (%d) might be using a modified damage data file.", PlayerName(playerid), playerid);

			CheatNotificationTime[playerid][acn_damage] = gettime() + NOTIFICATION_TIME;
		}
	}
	if(strlen(cheatstr) > 5)
	{
		format(string, sizeof(string), "[AntiCheat]: {%06x}%s", COLOR_RED >>> 8, cheatstr);
		CheatLog(string);
		format(msgstring, sizeof(msgstring), "6[AntiCheat]: %s", cheatstr);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, msgstring);
		SendAdminMessage(1, string);	
	}
	
	
	return 1;
}

static ResetACData(playerid)
{
	PlayerData[playerid][ac_health] = 0.0;
	PlayerData[playerid][ac_armour] = 0.0;
	PlayerData[playerid][ac_money] = 0;
	
	for(new i = 0; i < 13; i++)
	{
		PlayerData[playerid][ac_weapons][i] = 0;
		PlayerData[playerid][ac_ammo][i] = 0;
	}
	
	PlayerData[playerid][ac_dead] = 1;
	PlayerData[playerid][ac_x] = 0.0;
	PlayerData[playerid][ac_y] = 0.0;
	PlayerData[playerid][ac_z] = 0.0;
	PlayerData[playerid][ac_teleported] = 0;
	PlayerData[playerid][ac_surfing] = 0;
	PlayerData[playerid][ac_lastvehicle] = INVALID_VEHICLE_ID;
	PlayerData[playerid][ac_playerstate] = PLAYER_STATE_NONE;
	PlayerData[playerid][ac_falling] = 0;
	PlayerData[playerid][ac_leftcar] = 0;
	PlayerData[playerid][ac_clickedmap] = 0;
	PlayerData[playerid][click_X] = 0.0;
	PlayerData[playerid][click_Y] = 0.0;
	PlayerData[playerid][click_Z] = 0.0;
	PlayerData[playerid][ac_jetpack] = 0;
	PlayerData[playerid][ac_modshop] = 0;
}

/* Callback hooks */

hook OnPlayerConnect(playerid)
{
	ResetACData(playerid);
}

hook OnPlayerDisconnect(playerid, reason)
{
	DebugMsg("AVist_Start");
	ResetACData(playerid);
	DebugMsg("AVist_End");
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	PlayerData[playerid][ac_dead] = 1;
	PlayerData[playerid][ac_jetpack] = 0;
}

hook OnPlayerSpawn(playerid)
{
	PlayerData[playerid][ac_dead] = 0;
	GetPlayerPos(playerid, PlayerData[playerid][ac_x], PlayerData[playerid][ac_y], PlayerData[playerid][ac_z]);
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	PlayerData[playerid][ac_playerstate] = newstate;
	if(newstate == PLAYER_STATE_DRIVER && oldstate == PLAYER_STATE_ONFOOT)
	{
	    PlayerData[playerid][ac_lastvehicle] = GetPlayerVehicleID(playerid);
		VehicleData[PlayerData[playerid][ac_lastvehicle]][acv_driver] = playerid;
	}
	
	if(newstate == PLAYER_STATE_ONFOOT && (oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER))
	{
		VehicleData[PlayerData[playerid][ac_lastvehicle]][acv_driver] = -1;
	    PlayerData[playerid][ac_lastvehicle] = INVALID_VEHICLE_ID;
	    PlayerData[playerid][ac_leftcar] = 1;
	}
	
}

hook OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	PlayerData[playerid][ac_clickedmap] = 1;
	PlayerData[playerid][click_X] = fX;
	PlayerData[playerid][click_Y] = fY;
	PlayerData[playerid][click_Z] = fZ;
}

hook OnEnterExitModShop(playerid, enterexit, interiorid)
{
	PlayerData[playerid][ac_modshop] = (enterexit == 0) ?  0 : 1;
}

hook OnVehicleSpawn(vehicleid)
{
	VehicleData[vehicleid][acv_health] = 1000;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	new Float:carhp;
	GetVehicleHealth(vehicleid, carhp);
	VehicleData[vehicleid][acv_health] = carhp;
}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(issuerid != INVALID_PLAYER_ID)
	{
		switch(weaponid)
		{
			case WEAPON_COLT45, WEAPON_SILENCED, WEAPON_DEAGLE, WEAPON_UZI, WEAPON_MP5, WEAPON_AK47, WEAPON_M4, WEAPON_TEC9, WEAPON_RIFLE, WEAPON_SNIPER, WEAPON_MINIGUN:
			{
				if(amount < expectedDmg[weaponid - 22] - 1 || amount > expectedDmg[weaponid - 22] + 1)
				{
					new Float:x, Float:y, Float:z;
					GetPlayerPos(playerid, x, y, z);
					if(!IsPlayerInRangeOfPoint(issuerid, 1.0,  x, y, z))
					{
					    AntiCheat_SendWarning(issuerid, CHEAT_MODIFIEDDMG, floatround(amount));
					}
				}	
			}
		}
	}
}

hook OnGameModeInit()
{
	Desync_Health = 0;
	Desync_Armour = 0;
	Desync_Weapons = 0;
	Desync_Ammo = 0;
	
	return 1;
}

hook OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	PlayerData[playerid][ac_int] = newinteriorid;
	
	return 1;
}

hook OnPlayerUpdate(playerid)
{
	#if defined ADMIN_BYPASS
	if(FoCo_Player[playerid][admin] > 0) return 1;
  	#endif
	if(FoCo_Player[playerid][banned] == 1) return 1;
	if(PlayerData[playerid][ac_dead] == 1) return 1;
	if(PlayerData[playerid][ac_playerstate] == PLAYER_STATE_SPECTATING) return 1;
	
	new time = gettime();

	if(PlayerLastUpdated[playerid][acs_health] < time)
	{
		PlayerLastUpdated[playerid][acs_health] = time;
		
		new
			Float:currentHealth,
			currentHealthInt,
			healthShouldBe;

		GetPlayerHealth(playerid, currentHealth);

		currentHealthInt = floatround(currentHealth, floatround_round);
		healthShouldBe = floatround(PlayerData[playerid][ac_health], floatround_round);

		if(currentHealthInt == healthShouldBe || ADuty[playerid] == 1)
		{
			PlayerSynced[playerid][acs_health] = 1;
		}

		if(!PlayerSynced[playerid][acs_health])
		{
		    if(ADuty[playerid] != 0)
		    {
   				if(currentHealthInt > healthShouldBe)
				{
					UpdateFail[playerid][acs_health]++;
					switch(UpdateFail[playerid][acs_health])
					{
						case 30, 45:
						{
						    if(Desync_Health == 0)
						    {
						        new string[128];
								format(string, sizeof(string), "[AntiCheat]: {%06x} %s (%d)'s health is desynced for %d seconds. Attempting to resync.", COLOR_RED >>> 8, PlayerName(playerid), playerid, UpdateFail[playerid][acs_health]);
								SendAdminMessage(1, string);
								SetPlayerHealth(playerid, healthShouldBe);
						    }
						}

						case 60:
						{
						    if(Desync_Health == 0)
						    {
						        new string[128];
								format(string, sizeof(string), "[AntiCheat]: {%06x} %s (%d)'s health has been desynced for too long. Recommending a kick for the player.", COLOR_RED >>> 8, PlayerName(playerid), playerid);
								SendAdminMessage(1, string);
			//					Kick(playerid);
								return 1;
						    }
							
						}
					}
				}
		    }

		}

		else
		{
			UpdateFail[playerid][acs_health] = 0;

			if(healthShouldBe > currentHealthInt)
			{
				PlayerData[playerid][ac_health] = currentHealth;
			}

			else if(currentHealthInt > healthShouldBe && currentHealthInt <= 100 && currentHealthInt  > 0 && ADuty[playerid] == 0)
			{
				 AntiCheat_SendWarning(playerid, CHEAT_HEALTH, currentHealthInt);
			}

		}

		return 1;
	}

	if(PlayerLastUpdated[playerid][acs_armour] < time)
	{
		PlayerLastUpdated[playerid][acs_armour] = time;

		new
			Float:currentArmour,
			currentArmourInt,
			armourShouldBe;

		GetPlayerArmour(playerid, currentArmour);

		currentArmourInt = floatround(currentArmour, floatround_round);
		armourShouldBe = floatround(PlayerData[playerid][ac_armour], floatround_round);

		if(currentArmourInt == armourShouldBe)
		{
			PlayerSynced[playerid][acs_armour] = 1;
		}

		if(!PlayerSynced[playerid][acs_armour])
		{
			if(currentArmourInt > armourShouldBe)
			{
				UpdateFail[playerid][acs_armour]++;
				switch(UpdateFail[playerid][acs_armour])
				{
					case 30, 45:
					{
					    if(Desync_Armour == 0)
					    {
					        new string[128];
							format(string, sizeof(string), "[AntiCheat]: {%06x} %s (%d)'s armour is desynced for %d seconds. Attempting to resync.", COLOR_RED >>> 8, PlayerName(playerid), playerid, UpdateFail[playerid][acs_armour]);
							SendAdminMessage(1, string);
							SetPlayerHealth(playerid, armourShouldBe);
					    }
					}

					case 60:
					{
					    if(Desync_Armour == 0)
					    {
					        new string[128];
							format(string, sizeof(string), "[AntiCheat]: {%06x} %s (%d)'s armour has been desynced for too long. Recommend kicking the player.", COLOR_RED >>> 8, PlayerName(playerid), playerid);
							SendAdminMessage(1, string);
	//						Kick(playerid);
							return 1;
					    }
						
					}
				}
			}
		}

		else
		{
			UpdateFail[playerid][acs_armour] = 0;

			if(armourShouldBe > currentArmourInt)
			{
				PlayerData[playerid][ac_armour] = currentArmour;
			}

			else if(currentArmourInt > armourShouldBe && currentArmourInt  > 0)
			{
				 AntiCheat_SendWarning(playerid, CHEAT_ARMOUR, currentArmourInt);
			}

		}

		return 1;
	}

	if(PlayerLastUpdated[playerid][acs_weapons] < time)
	{
		PlayerLastUpdated[playerid][acs_weapons] = time;

		new
			checkWeapons[13][2],
			hackedweapon[2] = {0};
			
		for(new i = 0 ; i < 13; i++)
		{
			GetPlayerWeaponData(playerid, i, checkWeapons[i][0], checkWeapons[i][1]);
			
			if(PlayerData[playerid][ac_weapons][i] == checkWeapons[i][0])
			{
                PlayerSynced[playerid][acs_weapons][i] = 1;
			}
			
			if(!PlayerSynced[playerid][acs_weapons][i])
			{
			    if(PlayerData[playerid][ac_weapons][i] != checkWeapons[i][0])
			    {
					UpdateFail[playerid][acs_weapons][i]++;
					
					switch(UpdateFail[playerid][acs_weapons][i])
					{
						case 30, 45:
						{
							if(Desync_Weapons == 0)
							{
								new string[128];
								format(string, sizeof(string), "[AntiCheat]: {%06x} %s (%d)'s %s is desynced for %d seconds. Attempting to resync.", COLOR_RED >>> 8, PlayerName(playerid), playerid, AC_WeapNames[PlayerData[playerid][ac_weapons][i]], UpdateFail[playerid][acs_weapons][i]);
								SendAdminMessage(1, string);
								GivePlayerWeapon(playerid, PlayerData[playerid][ac_weapons][i], 10);
							}
							
						}
						
						case 60:
						{
							if(Desync_Weapons == 0)
							{
								new string[128];
								format(string, sizeof(string), "[AntiCheat]: {%06x} %s (%d)'s %s has been desynced for too long. Recommend kicking the player", COLOR_RED >>> 8, PlayerName(playerid), playerid, AC_WeapNames[PlayerData[playerid][ac_weapons][i]]);
								SendAdminMessage(1, string);
	//							Kick(playerid);
								return 1;
							}							
						}	
					}
				}
			}
			
			else
			{
			    UpdateFail[playerid][acs_weapons][i] = 0;

				if(PlayerData[playerid][ac_weapons][i] != checkWeapons[i][0])
				{
				    if(checkWeapons[i][0] != 46 && checkWeapons[i][0] != 40 && checkWeapons[i][0] != 0)
				    {
				    	hackedweapon[0]++;
				    	hackedweapon[1] = checkWeapons[i][0];
					}
				}
			}
		}
		
		if(hackedweapon[0] == 1 && hackedweapon[1] != WEAPON_GOLFCLUB)
		{
		    AntiCheat_SendWarning(playerid, CHEAT_WEAPONS, hackedweapon[1]);
		}
		
		else if(hackedweapon[0] > 1)
		{
		    AntiCheat_SendWarning(playerid, CHEAT_WEAPONS, 0);
		}
		
		return 1;
	}
	
	if(PlayerLastUpdated[playerid][acs_ammo] < time)
	{
		PlayerLastUpdated[playerid][acs_ammo] = time;

		new
			checkAmmo[13][2],
			hackedAmmo[3] = {0};

		for(new i = 0 ; i < 13; i++)
		{
			GetPlayerWeaponData(playerid, i, checkAmmo[i][0], checkAmmo[i][1]);

			if(PlayerData[playerid][ac_ammo][i] == checkAmmo[i][1])
			{
                PlayerSynced[playerid][acs_ammo][i] = 1;
                if(PlayerSynced[playerid][acs_ammo][i] == 0) PlayerSynced[playerid][acs_weapons][i] = 0;
			}

			if(!PlayerSynced[playerid][acs_ammo][i])
			{
			    if(PlayerData[playerid][ac_ammo][i] < checkAmmo[i][1])
			    {
					// Ammu-nation
					if(PlayerData[playerid][ac_int] == 7 && (checkWeapons[i][0] == WEAPON_AK47 || checkWeapons[i][0] == WEAPON_M4))
					{
						PlayerData[playerid][ac_weapons][i] = checkWeapons[i][0];
						PlayerData[playerid][ac_ammo][i] = checkWeapons[i][1];
					}
					
					else
					{
						UpdateFail[playerid][acs_ammo][i]++;

						switch(UpdateFail[playerid][acs_ammo][i])
						{
							case 30, 45:
							{
								if(Desync_Ammo == 0)
								{
									new string[128];
									format(string, sizeof(string), "[AntiCheat]: {%06x} %s (%d)'s %s's ammo is desynced for %d seconds. Attempting to resync.", COLOR_RED >>> 8, PlayerName(playerid), playerid, AC_WeapNames[PlayerData[playerid][ac_weapons][i]], UpdateFail[playerid][acs_ammo][i]);
									SendAdminMessage(1, string);
									GivePlayerWeapon(playerid, PlayerData[playerid][ac_weapons][i], 10);
								}
							}

							case 60:
							{
								if(Desync_Ammo == 0)
								{
									new string[128];
									format(string, sizeof(string), "[AntiCheat]: {%06x} %s (%d)'s %s's ammo has been desynced for too long. Recommend kicking the player", COLOR_RED >>> 8, PlayerName(playerid), playerid, AC_WeapNames[PlayerData[playerid][ac_weapons][i]]);
									SendAdminMessage(1, string);
					//				Kick(playerid);
									return 1;
								}
								
							}
						}
					}
				}
			}

			else
			{
			    UpdateFail[playerid][acs_ammo][i] = 0;

				if(PlayerData[playerid][ac_ammo][i] < checkAmmo[i][1])
				{
				    if(checkAmmo[i][0] != 46)
				    {
					    hackedAmmo[0]++;
					    hackedAmmo[1] = checkAmmo[i][0];
					    hackedAmmo[2] = checkAmmo[i][1];
					}
				}
				
				else
				{
				    PlayerData[playerid][ac_ammo][i] = checkAmmo[i][1];
				}
			}
		}

		if(hackedAmmo[0] == 1 || hackedAmmo[2] < -1)
		{
		    AntiCheat_SendWarning(playerid, CHEAT_AMMO, hackedAmmo[1]);
		}

		else if(hackedAmmo[0] > 1)
		{
		    AntiCheat_SendWarning(playerid, CHEAT_AMMO, 0);
		}

		return 1;
	}

	if(PlayerLastUpdated[playerid][acs_position] < time)
	{
		PlayerLastUpdated[playerid][acs_position] = time;

		new
			Float:pX,
			Float:pY,
			Float:pZ;
			
		GetPlayerPos(playerid, pX, pY, pZ);

		if(!PlayerSynced[playerid][acs_position] && GetDistanceBetweenPoints(pX, pY, pZ, PlayerData[playerid][ac_x], PlayerData[playerid][ac_y], PlayerData[playerid][ac_z]) < 100)
		{
			PlayerSynced[playerid][acs_position] = 1;
		}

		UpdateFail[playerid][acs_position] = 0;
		new Float:vX, Float:vY, Float:vZ;
		GetPlayerVelocity(playerid, vX, vY, vZ);
		
		if(vZ < 0)	PlayerData[playerid][ac_falling] = 1;

		else if(vZ >= 0 && PlayerData[playerid][ac_falling] == 1) PlayerData[playerid][ac_falling] = 2; /* Fixed falling through the map false-posititve by making the anticheat ignore the pass right after the player got teleported to the ground */
		
		else PlayerData[playerid][ac_falling] = 0;
		
		if(PlayerData[playerid][ac_clickedmap])
		{
			if(GetDistanceBetweenPoints(pX, pY, pZ, PlayerData[playerid][click_X], PlayerData[playerid][click_Y], PlayerData[playerid][click_Z]) < 10)
			{
				AntiCheat_SendWarning(playerid, CHEAT_MAPCLICK, 0);
			}
			
			else PlayerData[playerid][ac_clickedmap] = 0;
		}
		
		if(GetPlayerSurfingVehicleID(playerid) != INVALID_VEHICLE_ID)
		{
			PlayerData[playerid][ac_surfing] = 1;
			return 1;
		}
		
		else if(PlayerData[playerid][ac_playerstate] == PLAYER_STATE_DRIVER || PlayerData[playerid][ac_playerstate] == PLAYER_STATE_PASSENGER)
		{

			return 1;
		}

		else
		{
			if(PlayerData[playerid][ac_jetpack] == 0)
			{
				if((vX > 0.3 || vY > 0.3 || vX < -0.3 || vY < -0.3) && PlayerData[playerid][ac_leftcar] == 0 && PlayerData[playerid][ac_surfing] == 0)
				{
					PWarn[playerid][pw_count]++;
					PWarn[playerid][pw_lastwarn] = gettime();
					
					if(PWarn[playerid][pw_count] > AC_WARN_AMOUNT)
					{	
						AntiCheat_SendWarning(playerid, CHEAT_FLY, 0);
					}
				}
				
				else if(vX < 0.3 && vY < 0.3)
				{
					
					//if(GetDistanceBetweenPoints(pX, pY, pZ, PlayerData[playerid][ac_x], PlayerData[playerid][ac_y], PlayerData[playerid][ac_z]) > 20 && GetPlayerWeapon(playerid) != 46 && PlayerData[playerid][ac_falling] == 0 && PlayerData[playerid][ac_surfing] == 0 && PlayerData[playerid][ac_leftcar] == 0 && PlayerData[playerid][ac_teleported] == 0)
					if(!IsPlayerInRangeOfPoint(playerid, 70, PlayerData[playerid][ac_x], PlayerData[playerid][ac_y], PlayerData[playerid][ac_z]) && GetPlayerWeapon(playerid) != 46 && PlayerData[playerid][ac_falling] == 0 && PlayerData[playerid][ac_surfing] == 0 && PlayerData[playerid][ac_leftcar] == 0 && PlayerData[playerid][ac_teleported] == 0)
					{
						PWarn[playerid][pw_count]++;
						PWarn[playerid][pw_lastwarn] = gettime();
					
						if(PWarn[playerid][pw_count] > AC_WARN_AMOUNT)
						{
							AntiCheat_SendWarning(playerid, CHEAT_AIRBREAK, 0);
						}
					}
					
					if(PlayerData[playerid][ac_surfing] == 1)
					{
						PlayerData[playerid][ac_surfing] = 0;	    
					}
					
					else if(PlayerData[playerid][ac_leftcar] == 1)
					{
						PlayerData[playerid][ac_leftcar] = 0;
					}
					
					else if(PlayerData[playerid][ac_teleported] >= 1)
					{
						if(PlayerData[playerid][ac_teleported] == 2)
						{
							PlayerData[playerid][ac_teleported] = 0;
						}
						
						else PlayerData[playerid][ac_teleported] = 2;
					}
				
				}
			}

			GetPlayerPos(playerid, PlayerData[playerid][ac_x], PlayerData[playerid][ac_y], PlayerData[playerid][ac_z]);
		}

		return 1;
	}
	
	if(PlayerLastUpdated[playerid][acs_vehicle]  < time)
	{
		PlayerLastUpdated[playerid][acs_vehicle] = time;
		
		if(PlayerData[playerid][ac_playerstate] == PLAYER_STATE_DRIVER || PlayerData[playerid][ac_playerstate] == PLAYER_STATE_PASSENGER)
		{
			new
				Float:hp;

			GetVehicleHealth(PlayerData[playerid][ac_lastvehicle], hp);

			if(VehicleData[PlayerData[playerid][ac_lastvehicle]][acv_health] < hp)
			{
				new nearPayNSpray = 0;

				for(new i = 0; i < 8; i++)
				{
					if(IsPlayerInRangeOfPoint(playerid, 30, PayNSpray[i][0], PayNSpray[i][1], PayNSpray[i][2]))
					{
						nearPayNSpray = 1;
						break;
					}
				}

				if(PlayerData[playerid][ac_modshop] == 0 && nearPayNSpray == 0)
				{
					AntiCheat_SendWarning(playerid, CHEAT_CARHP, floatround(hp));
				}

				else VehicleData[PlayerData[playerid][ac_lastvehicle]][acv_health] = hp;
			}

			else VehicleData[PlayerData[playerid][ac_lastvehicle]][acv_health] = hp;
		}

		if(!NitrousBoostEn[playerid])
		{
			new
				Float:vX,
				Float:vY,
				Float:vZ;
				
			GetVehicleVelocity(PlayerData[playerid][ac_lastvehicle], vX, vY, vZ);

			if(GetVehicleSpeed(PlayerData[playerid][ac_lastvehicle]) > MAX_CAR_SPEED && !IsAPlane(PlayerData[playerid][ac_lastvehicle]) && vZ >= 0)
			{
				AntiCheat_SendWarning(playerid, CHEAT_CARSPEED, 0);
			}
			
			else if(GetVehicleSpeed(PlayerData[playerid][ac_lastvehicle]) > MAX_PLANE_SPEED && IsAPlane(PlayerData[playerid][ac_lastvehicle]))
			{
				AntiCheat_SendWarning(playerid, CHEAT_CARSPEED, 0);
			}
		}

		return 1;
	}

	return 1;
}

stock IsAPlane(carid)
{
	new model = GetVehicleModel(carid);
	switch(model)
	{
	    case 417, 425, 447, 460, 469, 476, 487, 488, 497, 511, 512, 513, 519, 520, 548, 553, 563, 577, 592, 593: return  1;
	}
	return 0;
}

stock GetAntiCheatNotificationList()
{
	new list[512];
	
	strcat(list, GetAntiCheatNotificationListStr("All Notices", AC_NotificationDisabled[ac_not_all]));
	strcat(list, GetAntiCheatNotificationListStr("Air Break", AC_NotificationDisabled[ac_not_airbreak]));
	strcat(list, GetAntiCheatNotificationListStr("Weapon Ammo", AC_NotificationDisabled[ac_not_ammo]));
	strcat(list, GetAntiCheatNotificationListStr("Player Armour", AC_NotificationDisabled[ac_not_armour]));
	strcat(list, GetAntiCheatNotificationListStr("Car Health", AC_NotificationDisabled[ac_not_carhealth]));
	strcat(list, GetAntiCheatNotificationListStr("Car Speed", AC_NotificationDisabled[ac_not_carspeed]));
	strcat(list, GetAntiCheatNotificationListStr("Fly", AC_NotificationDisabled[ac_not_fly]));
	strcat(list, GetAntiCheatNotificationListStr("Player Health", AC_NotificationDisabled[ac_not_health]));
	strcat(list, GetAntiCheatNotificationListStr("Jetpack", AC_NotificationDisabled[ac_not_jetpack]));
	strcat(list, GetAntiCheatNotificationListStr("Map Click", AC_NotificationDisabled[ac_not_mapclick]));
	strcat(list, GetAntiCheatNotificationListStr("Modified Damage", AC_NotificationDisabled[ac_not_modifieddmg]));
	strcat(list, GetAntiCheatNotificationListStr("Player Money", AC_NotificationDisabled[ac_not_money]));
	strcat(list, GetAntiCheatNotificationListStr("Player Weapons", AC_NotificationDisabled[ac_not_weapons]));
	strcat(list, "Next Page ->.");
		
	strdel(list, strlen(list)-1, strlen(list));
	return list;
}

stock GetAntiCheatNotificationList1()
{
    new list[512];

	strcat(list, GetAntiCheatNotificationListStr("Desync'd Health", Desync_Health));
	strcat(list, GetAntiCheatNotificationListStr("Desync'd Armour", Desync_Armour));
	strcat(list, GetAntiCheatNotificationListStr("Desync'd Weapons", Desync_Weapons));
	strcat(list, GetAntiCheatNotificationListStr("Desync'd Ammo", Desync_Ammo));
	strcat(list, "<- Previous Page.");

	strdel(list, strlen(list)-1, strlen(list));
	return list;
}

stock GetAntiCheatNotificationListStr(name[], value)
{
	new str[56];
	if(value) 
	{
		format(str, sizeof(str), "%s [{FF0000}Disabled{FFFFFF}]\n", name);
	} 
	else
	{
		format(str, sizeof(str), "%s [{15ED9A}Enabled{FFFFFF}]\n", name);
	}
	
	return str;
}

stock GetVehicleSpeed(vehicleid)
{
    new Float:xPos[3];
    GetVehicleVelocity(vehicleid, xPos[0], xPos[1], xPos[2]);
    return floatround(floatsqroot(xPos[0] * xPos[0] + xPos[1] * xPos[1] + xPos[2] * xPos[2]) * 170.00);
}
