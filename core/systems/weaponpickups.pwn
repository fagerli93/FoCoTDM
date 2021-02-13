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
* Filename:  weaponpickups.pwn                                                   *
* Author:    dr_vista                                                            *
*********************************************************************************/

/* Comment out if using FoCo test/main server */
//#define LOCAL_TEST

/* INCLUDES */

#if defined LOCAL_TEST
#include <a_samp>
#include <streamer>
#include <YSI\y_ini>
#include <sscanf2>
#endif

#include <YSI\y_hooks>


/* Defines */
#define MAX_WEAPON_PICKUPS 57
#define DIALOG_WEAPONS_PICKUP 534

/* Enumerations */

enum e_WeaponPickups
{
	wp_id,
	wp_modelid,
	wp_weaponid,
	Float:wp_x,
	Float:wp_y,
	Float:wp_z,
	bool:wp_isSpecial
};

/* Forwards */

forward @SetSpecialPickup(pickupid);
forward @SetSpecialPickupEx(oldpickupid, newpickupid);

/* Variables */

/* Returns the pickup model ID to use for each weapon ID / 0 -> invalid weapon IDs / Non-existing weapons (19/20/21) */
static const PickupModelsFromWeaponID[40] = {0, 331, 333, 334, 335, 336, 337, 338, 339, 341, 321, 322, 323, 324, 325, 326, 342, 343, 344, 0, 0, 0, 346, 347, 348, 349, 350, 351, 352, 353, 355, 356, 372, 357, 358, 359, 360, 361, 362, 363};

static
	WeaponPickupsMain[MAX_WEAPON_PICKUPS][e_WeaponPickups],
	INI_WeaponsPickup_Counter = 0,
	wp_pickedUp[MAX_WEAPON_PICKUPS][MAX_PLAYERS];


/* INI Load */
INI:weaponspickup[pickups](name[], value[])
{
	new randwp;
	extract value -> new Float:pickupX, Float:pickupY, Float:pickupZ, pmodelid, weapid; /* alternative to sscanf / unformat */
	WeaponPickupsMain[INI_WeaponsPickup_Counter][wp_x] = pickupX;
	WeaponPickupsMain[INI_WeaponsPickup_Counter][wp_y] = pickupY;
	WeaponPickupsMain[INI_WeaponsPickup_Counter][wp_z] = pickupZ;

	do
	{
		randwp = random(35);
	} while(randwp == 0 || randwp == 16 || randwp == 18 || 19 <= randwp <= 21); /* Weapons with no model IDs / Not weapons  - > Added grenade and molo*/
	
	WeaponPickupsMain[INI_WeaponsPickup_Counter][wp_weaponid] = randwp;
	WeaponPickupsMain[INI_WeaponsPickup_Counter][wp_modelid] = PickupModelsFromWeaponID[randwp];
	

	INI_WeaponsPickup_Counter++;

}

#if defined LOCAL_TEST
main()
{
	printf("pickups local test\n");
}
#endif

hook OnGameModeInit()
{
    INI_WeaponsPickup_Counter = 0;

	INI_Load("weaponspickup.ini");
	#if defined LOCAL_TEST
	AddPlayerClass(0,1886.7324,-1802.7596,13.5469,54.0597,0,0,0,0,0,0);
	#endif
	
	@SetSpecialPickup(random(MAX_WEAPON_PICKUPS));
	
	for(new i = 0; i < MAX_WEAPON_PICKUPS; i++)
	{
		WeaponPickupsMain[i][wp_id] = CreateDynamicPickup(WeaponPickupsMain[i][wp_modelid], 19, WeaponPickupsMain[i][wp_x], WeaponPickupsMain[i][wp_y], WeaponPickupsMain[i][wp_z], 0, 0, -1, 100);
	}
}

hook OnPlayerSpawn(playerid)
{
	for(new i = 0; i < MAX_WEAPON_PICKUPS; i++)
	{
		wp_pickedUp[i][playerid] = 0;
	}
}

hook OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	for(new i = 0; i < MAX_WEAPON_PICKUPS; i++)
	{
		if(pickupid == WeaponPickupsMain[i][wp_id])
		{
			if(wp_pickedUp[i][playerid] == 0)
			{
				new random_ammo;
				
				if(35 <= WeaponPickupsMain[i][wp_weaponid] <= 37 || WeaponPickupsMain[i][wp_weaponid] == 16)
				{
				    do
				    {
                        random_ammo = random(5);
				    } while(random_ammo == 0);
				}
				
				else if(WeaponPickupsMain[i][wp_weaponid] > 37)
				{
				    do
				    {
						random_ammo = random(50);
					} while(random_ammo == 0);
				}
				
				else
				{
				    do
				    {
						random_ammo = random(200);
					} while(random_ammo == 0);
				}
				if(WeaponPickupsMain[i][wp_weaponid] == 16 || WeaponPickupsMain[i][wp_weaponid] == 35 || WeaponPickupsMain[i][wp_weaponid] == 36 || WeaponPickupsMain[i][wp_weaponid] == 37 || WeaponPickupsMain[i][wp_weaponid] == 38)
				{
					SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
				}
				GivePlayerWeapon(playerid, WeaponPickupsMain[i][wp_weaponid], random_ammo + 1);
				
				wp_pickedUp[i][playerid] = 1;
				
				if(WeaponPickupsMain[i][wp_isSpecial] == true)
				{
					new logstr[128];
					format(logstr, sizeof(logstr), "[Guardian]: {%06x}%s (%d) has found the %s pickup.", COLOR_RED >>> 8, PlayerName(playerid), playerid, WeapNames[WeaponPickupsMain[i][wp_weaponid]][WeapName]);
					SendAdminMessage(1, logstr);
					GiveAchievement(playerid, 66);
					AdminLog(logstr);
					format(logstr, sizeof(logstr), "[INFO]: %s (%d) has found the {%06x}%s{%06x} pickup.", PlayerName(playerid), playerid, COLOR_GREEN >>> 8, WeapNames[WeaponPickupsMain[i][wp_weaponid]][WeapName], COLOR_NOTICE >>> 8);
					SendClientMessageToAll(COLOR_NOTICE, logstr);
					@SetSpecialPickupEx(i, random(MAX_WEAPON_PICKUPS));
				}
			}
			#if !defined LOCAL_TEST
			else
			{
			    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have already picked up this pickup.");
			}
			#endif
			break;
		}
	}
}

/* Functions */

@SetSpecialPickup(pickupid)
{
	new wp_rndm_weapon = random(6);
	
	switch(wp_rndm_weapon)
	{
		case 0: wp_rndm_weapon = 35;
		case 1: wp_rndm_weapon = 36;
		case 2: wp_rndm_weapon = 37;
		case 3: wp_rndm_weapon = 38;
		case 4: wp_rndm_weapon = 18; // Molo
		case 5: wp_rndm_weapon = 16;
	}
	
	WeaponPickupsMain[pickupid][wp_weaponid] = wp_rndm_weapon;
	WeaponPickupsMain[pickupid][wp_modelid] = PickupModelsFromWeaponID[wp_rndm_weapon];
	WeaponPickupsMain[pickupid][wp_isSpecial] = true;
}

@SetSpecialPickupEx(oldpickupid, newpickupid)
{
	new randwp;
	while(oldpickupid == newpickupid)
	{
		newpickupid = random(MAX_WEAPON_PICKUPS);
	}
	
	DestroyDynamicPickup(WeaponPickupsMain[oldpickupid][wp_id]);
	DestroyDynamicPickup(WeaponPickupsMain[newpickupid][wp_id]);
		
	do
	{
		randwp = random(35);
	} while(randwp == 0 || 19 <= randwp <= 21); /* Weapons with no model IDs / Not weapons */
			
	WeaponPickupsMain[oldpickupid][wp_weaponid] = randwp;
	WeaponPickupsMain[oldpickupid][wp_modelid] = PickupModelsFromWeaponID[randwp];
	WeaponPickupsMain[oldpickupid][wp_isSpecial] = false;
	WeaponPickupsMain[oldpickupid][wp_id] = CreateDynamicPickup(WeaponPickupsMain[oldpickupid][wp_modelid], 19, WeaponPickupsMain[oldpickupid][wp_x], WeaponPickupsMain[oldpickupid][wp_y], WeaponPickupsMain[oldpickupid][wp_z], 0, 0, -1, 100);
	
	@SetSpecialPickup(newpickupid);
	WeaponPickupsMain[newpickupid][wp_id] = CreateDynamicPickup(WeaponPickupsMain[newpickupid][wp_modelid], 19, WeaponPickupsMain[newpickupid][wp_x], WeaponPickupsMain[newpickupid][wp_y], WeaponPickupsMain[newpickupid][wp_z], 0, 0, -1, 100);
}


#if defined PTS
CMD:gotospecialpickup(playerid, params[])
{
	for(new i = 0; i < MAX_WEAPON_PICKUPS; i++)
	{
		if(WeaponPickupsMain[i][wp_isSpecial] == true)
		{
			SetPlayerPos(playerid, WeaponPickupsMain[i][wp_x], WeaponPickupsMain[i][wp_y], WeaponPickupsMain[i][wp_z]);
			break;
		}
	}
	
	return 1;
}
#endif

CMD:resetweaponpickups(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_RESETWEAPPICKUPS))
	{
		new
			string[128];
			
		for(new i = 0; i < MAX_WEAPON_PICKUPS; i++)
		{
			DestroyDynamicPickup(WeaponPickupsMain[i][wp_id]);
			WeaponPickupsMain[i][wp_modelid] = 0;
			WeaponPickupsMain[i][wp_weaponid] = 0;
			WeaponPickupsMain[i][wp_x] = 0.0;
			WeaponPickupsMain[i][wp_y] = 0.0;
			WeaponPickupsMain[i][wp_z] = 0.0;
			WeaponPickupsMain[i][wp_isSpecial] = false;
		}
		
		INI_WeaponsPickup_Counter = 0;

		INI_Load("weaponspickup.ini");
	
		@SetSpecialPickup(random(MAX_WEAPON_PICKUPS));
		
		for(new i = 0; i < MAX_WEAPON_PICKUPS; i++)
		{
			WeaponPickupsMain[i][wp_id] = CreateDynamicPickup(WeaponPickupsMain[i][wp_modelid], 19, WeaponPickupsMain[i][wp_x], WeaponPickupsMain[i][wp_y], WeaponPickupsMain[i][wp_z], 0, 0, -1, 100);
		}	
		
		format(string, sizeof(string), "AdmCmd(%d) %s %s has reset the weapon pickups.", ACMD_RESETWEAPPICKUPS, GetPlayerStatus(playerid), PlayerName(playerid));
		SendAdminMessage(ACMD_RESETWEAPPICKUPS, string);
		format(string, sizeof(string), "[NOTICE]: %s %s has reset the weapon pickups.", GetPlayerStatus(playerid), PlayerName(playerid));
		SendClientMessageToAll(COLOR_NOTICE, string);
	}

	return 1;
}
