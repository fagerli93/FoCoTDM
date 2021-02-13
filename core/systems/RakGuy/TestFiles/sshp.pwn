#include <YSI\y_hooks>

#define	INVALID_DAMAGE_WEAPON	-1.0
#define	RANGE_DAMAGE_WEAPON		-1.0
#define	MAX_SHOOTING_WEAPONS	55
#define INVALID_RANGE 0.0

#define NORMAL_SHOTGUN_DAMAGE(%1)		-1.05	* %1  + 49
#define SAWN_OFF_SHOTGUN_DAMAGE(%1)		-0.825 	* %1  + 39
#define COMBAT_SHOTGUN_DAMAGE(%1)		-0.775 	* %1  + 39

new Float:WDamage_Amount[MAX_SHOOTING_WEAPONS]=
{
	4.62, 					// 0 - Fist
	4.62, 					// 1 - Brass knuckles
	4.62, 					// 2 - Golf club
	4.62, 					// 3 - Nitestick
	4.62, 					// 4 - Knife
	4.62, 					// 5 - Bat
	4.62, 					// 6 - Shovel
	4.62, 					// 7 - Pool cue
	4.62, 					// 8 - Katana
	6.62, 					// 9 - Chainsaw
	4.62, 					// 10 - Dildo
	4.62, 					// 11 - Dildo 2
	4.62, 					// 12 - Vibrator
	4.62, 					// 13 - Vibrator 2
	4.62, 					// 14 - Flowers
	4.62, 					// 15 - Cane
	82.5, 					// 16 - Grenade
	0.0, 					// 17 - Teargas
	0.33, 					// 18 - Molotov
	INVALID_DAMAGE_WEAPON,	// 19
	INVALID_DAMAGE_WEAPON,	// 20
	INVALID_DAMAGE_WEAPON,	// 21
	8.25, 					// 22 - Colt 45
	13.2, 					// 23 - Silenced
	46.2, 					// 24 - Deagle
	49.0,					//Normal ShotGun
	38.5,					//Sawn-Off
	38.5,					//Combat-ShotGun
	6.6, 					// 28 - UZI
	8.25, 					// 29 - MP5
	9.9, 					// 30 - AK47
	9.9, 					// 31 - M4
	6.6, 					// 32 - Tec9
	24.75, 					// 33 - Cuntgun
	41.25, 					// 34 - Sniper
	82.5, 					// 35 - Rocket launcher
	82.5, 					// 36 - Heatseeker
	0.33, 					// 37 - Flamethrower
	46.2, 					// 38 - Minigun
	82.5, 					// 39 - Satchel
	0.0, 					// 40 - Detonator
	0.33, 					// 41 - Spraycan
	0.33, 					// 42 - Fire extinguisher
	0.0, 					// 43 - Camera
	0.0, 					// 44 - Night vision
	0.0, 					// 45 - Infrared
	0.0, 					// 46 - Parachute
	0.0, 					// 47 - Fake pistol
	INVALID_DAMAGE_WEAPON, 	// 48
	9.9, 					// 49 - Vehicle
	INVALID_DAMAGE_WEAPON, 	// 50 - Helicopter blades
	82.5, 					// 51 - Explosion
	0.0, 					// 52
	1.0, 					// 53 - Drowning
	165.0  					// 54 - Splat
};

new Float:WDamage_IncPercentage[MAX_SHOOTING_WEAPONS]=
{
	0.0,			// 0 - Fist
	0.0,			// 1 - Brass knuckles
	0.0,			// 2 - Golf club
	0.0,			// 3 - Nitestick
	0.0,			// 4 - Knife
	0.0,			// 5 - Bat
	0.0,			// 6 - Shovel
	0.0,			// 7 - Pool cue
	0.0,			// 8 - Katana
	0.0,			// 9 - Chainsaw
	0.0,			// 10 - Dildo
	0.0,			// 11 - Dildo 2
	0.0,			// 12 - Vibrator
	0.0,			// 13 - Vibrator 2
	0.0,			// 14 - Flowers
	0.0,			// 15 - Cane
	0.0,			// 16 - Grenade
	0.0,			// 17 - Teargas
	0.0,			// 18 - Molotov
	INVALID_DAMAGE_WEAPON,			// 19
	INVALID_DAMAGE_WEAPON,			// 20
	INVALID_DAMAGE_WEAPON,			// 21
	0.10,			// 22 - Colt 45
	0.15,			// 23 - Silenced
	0.0,			// 24 - Deagle
	0.0,			//Normal ShotGun
	-0.25,			//Sawn-Off
	-0.50,			//Combat-ShotGun
	0.0,			// 28 - UZI
	0.15,			// 29 - MP5
	0.15,			// 30 - AK47
	0.0,			// 31 - M4
	0.0,			// 32 - Tec9
	0.65,			// 33 - Cuntgun
	0.0,			// 34 - Sniper
	0.0,			// 35 - Rocket launcher
	0.0,			// 36 - Heatseeker
	0.0,			// 37 - Flamethrower
	0.0,			// 38 - Minigun
	0.0,			// 39 - Satchel
	0.0,			// 40 - Detonator
	0.0,			// 41 - Spraycan
	0.0,			// 42 - Fire extinguisher
	0.0,			// 43 - Camera
	0.0,			// 44 - Night vision
	0.0,			// 45 - Infrared
	0.0,			// 46 - Parachute
	0.0,			// 47
	INVALID_DAMAGE_WEAPON, 			//48
	0.0,			// 49 - Vehicle
	INVALID_DAMAGE_WEAPON, 			//50
	0.0,			// 51 - Explosion
	0.0,			// 52
	0.0,			// 53 - Drowning
	0.0				// 54 - Splat
};

new Float:WDamage_Range[MAX_SHOOTING_WEAPONS]=
{
	2.0, 					// 0 - Fist
	2.0, 					// 1 - Brass knuckles
	2.0, 					// 2 - Golf club
	2.0, 					// 3 - Nitestick
	2.0, 					// 4 - Knife
	2.0, 					// 5 - Bat
	2.0, 					// 6 - Shovel
	2.0, 					// 7 - Pool cue
	2.0, 					// 8 - Katana
	2.0, 					// 9 - Chainsaw
	2.0, 					// 10 - Dildo
	2.0, 					// 11 - Dildo 2
	2.0, 					// 12 - Vibrator
	2.0, 					// 13 - Vibrator 2
	2.0, 					// 14 - Flowers
	2.0, 					// 15 - Cane
	INVALID_RANGE, 			// 16 - Grenade
	0.0, 					// 17 - Teargas
	INVALID_RANGE, 			// 18 - Molotov
	INVALID_RANGE,			// 19
	INVALID_RANGE,			// 20
	INVALID_RANGE,			// 21
	35.0, 					// 22 - Colt 45
	35.0, 					// 23 - Silenced
	35.0, 					// 24 - Deagle
	40.0, 					// 25 - Shotgun
	35.0, 					// 26 - Sawed-off
	40.0, 					// 27 - Spas
	35.0, 					// 28 - UZI
	45.0, 					// 29 - MP5
	70.0,					// 30 - AK47
	90.0, 					// 31 - M4
	35.0, 					// 32 - Tec9
	100.0, 					// 33 - Cuntgun
	200.0, 					// 34 - Sniper
	INVALID_RANGE,			// 35 
	INVALID_RANGE,			// 36
	INVALID_RANGE,			// 37
	75.0,  					// 38 - Minigun
	0.0,					// 39 - Satchel
	0.0,					// 40 - Detonator
	5.0,					// 41 - Spraycan
	10.0,					// 42 - Fire extinguisher
	INVALID_RANGE,			// 43 - Camera
	INVALID_RANGE,			// 44 - Night vision
	INVALID_RANGE,			// 45 - Infrared
	INVALID_RANGE,			// 46 - Parachute
	INVALID_RANGE,			// 47
	INVALID_RANGE,			//48
	1.0,					// 49 - Vehicle
	INVALID_RANGE,			//50
	0.0,					// 51 - Explosion
	0.0,					// 52
	0.0,					// 53 - Drowning
	0.0						// 54 - Splat
};

enum
{
	SS_CRASHER,
	SS_ADUTY,
	SS_RAPID,
	SS_SPREAD,
	SS_INVALID_WEAPON,
	SS_DEAD_PLAYER,
	SS_NOTSTREAMED,
	SS_OUTOFRANGE,
	SS_UNKNOWN_SHOT,
	SS_DEAD_BODY,
 	SS_SILENTAIM,
 	SS_KNIFEBUG,
 	SS_KNIFE_BODY,
 	SS_NONE_HIT,
	SS_POORAIM,
	SS_RAPIDCARRAM,
	SS_INVALIDSHOTWEAPON,
	SS_HACKEDWEAPON
}

new const IgnoredMessage[][]=
{
	"Bullet ignored from %s for shooting Crasher-Bullet, at %s",
	"Damage ignored from %s for shooting Admin On-Duty, at %s",
	"Damage ignored from %s for Rapid-Fire, at %s",
	"Damage ignored from %s for shooting No Spread, at %s",
	"Bullet ignored from %s for shooting Invalid Weapon, at %s",
	"Damage ignored from %s for shooting while being Dead, at %s",
	"Damage ignored from %s for shooting unstreamed player, at %s",
	"Damage ignored from %s for shooting out-of-range player, at %s",
	"Damage ignored from %s for shooting invalid-shot, at %s",
	"Damage ignored from %s for shooting dead-body, at %s",
	"Damage ignored from %s for possible SilentAim, at %s",
	"Damage ignored from %s for being Knife-bugged, at %s",
	"Damage ignored from %s for shooting Knife-Bugged Player, at %s",
	"Damage ignored from %s for Hitting no Player in GiveDamage, at %s",
	"Damage ignored from %s for possible PoorAim, at %s",
	"Damage ignored from %s for ramming excessive ramming, at %s",
	"Damage ignored from %s for Invalid Weapon shot, at %s",
	"Damage ignored from %s for Hacker Weapon shot, at %s"
};
enum
{
	WEAPON_TYPE_NULL,
	WEAPON_TYPE_BULLET,
	WEAPON_TYPE_RANGED,
	WEAPON_TYPE_HAND,
	WEAPON_TYPE_FIRE,
	WEAPON_TYPE_BANNED,
	WEAPON_CAR_RAM
}
new bool:KnifeBugged[MAX_PLAYERS];
new bool:SS_DeadPlayer[MAX_PLAYERS];
new CarRamDelay[MAX_PLAYERS];
new bool:AntiDoubleDeath[MAX_PLAYERS];

stock GetTypeOfWeapon(weaponid)
{
	switch(weaponid)
	{
	    case 0 .. 15:
	        return WEAPON_TYPE_HAND;
		case 16 .. 18:
		    return WEAPON_TYPE_FIRE;
		case 22 .. 24:
			return WEAPON_TYPE_BULLET;
		case 25 .. 27:
			return WEAPON_TYPE_RANGED;
		case 28 .. 34:
			return WEAPON_TYPE_BULLET;
		case 35 .. 37:
		    return WEAPON_TYPE_FIRE;
		case 38:
			return WEAPON_TYPE_BULLET;
		case 39, 51:
		    return WEAPON_TYPE_FIRE;
		case 40:
		    return WEAPON_TYPE_NULL;
		case 41, 42:
            return WEAPON_TYPE_HAND;
		case 43 .. 48:
		    return WEAPON_TYPE_NULL;
		case 49:
		    return WEAPON_CAR_RAM;
		case 50:
		    return WEAPON_TYPE_BANNED;
		case 52 .. 55:
		    return WEAPON_TYPE_NULL;
		default:
			return WEAPON_TYPE_NULL;
	}
	return WEAPON_TYPE_NULL;
}

/****************************DAMAGE VIEWER**********************************/
#define MAX_ADMINWATCH 3
#define MAX_PLAYERWATCHED 10

enum DamageWatchDet
{
	DW_PID, //ID of Player/Admin
	DW_MEM_ID, //Array_ID in which the player id is stored for the other party..
	bool:DW_Type //Type of Watch.. True = Given.. False = Taken..
}

new DV_MSG[256];
new AdminWatchingDamage[MAX_PLAYERS][MAX_ADMINWATCH][DamageWatchDet];
new PlayerWatchedDamage[MAX_PLAYERS][MAX_PLAYERWATCHED][DamageWatchDet];

stock SendDamageMessageToWatchers(playerid, damagerid, Float:damage, weaponid)
{
	for(new i = 0; i < MAX_PLAYERWATCHED; i++)
	{
		if(PlayerWatchedDamage[playerid][i][DW_PID] != -1)
		{
			if(AdminLvl(PlayerWatchedDamage[playerid][i][DW_PID]) > 0)
			{
				if(PlayerWatchedDamage[playerid][i][DW_Type] == false)
				{
					format(DV_MSG, sizeof(DV_MSG), "[DAMAGE]: %s(%i) has taken %.3f damage from %s(%i) with a %s", PlayerName(playerid), playerid, damage, PlayerName(damagerid), damagerid, WeaponName(weaponid));
					SendClientMessage(PlayerWatchedDamage[playerid][i][DW_PID], COLOR_NOTICE, DV_MSG);

				}
			}
		}
		if(damagerid != INVALID_PLAYER_ID)
		{
			if(PlayerWatchedDamage[damagerid][i][DW_PID] != -1)
			{
				if(AdminLvl(PlayerWatchedDamage[damagerid][i][DW_PID]) > 0)
				{
					if(PlayerWatchedDamage[damagerid][i][DW_Type] == true)
					{
						format(DV_MSG, sizeof(DV_MSG), "[DAMAGE]: %s(%i) has given %.3f damage to %s(%i) with a %s", PlayerName(damagerid), damagerid, damage, PlayerName(playerid), playerid, WeaponName(weaponid));
						SendClientMessage(PlayerWatchedDamage[damagerid][i][DW_PID], COLOR_NOTICE, DV_MSG);

					}
				}
			}
		}
	}
}

stock ClearWatchingVariables(playerid)
{
	for(new i = 0; i < MAX_ADMINWATCH; i++)
	{
		if(AdminWatchingDamage[playerid][i][DW_PID] == playerid)
		{
		    new targetid = AdminWatchingDamage[playerid][i][DW_MEM_ID];
			PlayerWatchedDamage[targetid][AdminWatchingDamage[playerid][i][DW_MEM_ID]][DW_PID] = -1;
			PlayerWatchedDamage[targetid][AdminWatchingDamage[playerid][i][DW_MEM_ID]][DW_MEM_ID] = -1;
			AdminWatchingDamage[playerid][i][DW_MEM_ID] = -1;
			AdminWatchingDamage[playerid][i][DW_PID] = -1;
		}
	}
	for(new i = 0; i < MAX_PLAYERWATCHED; i++)
	{
		if(PlayerWatchedDamage[playerid][i][DW_PID] != -1)
		{
			new targetid = PlayerWatchedDamage[playerid][i][DW_PID],
				mem_id	 = PlayerWatchedDamage[playerid][i][DW_MEM_ID];
			AdminWatchingDamage[targetid][mem_id][DW_PID] = -1;
			PlayerWatchedDamage[playerid][i][DW_PID] = -1;
			AdminWatchingDamage[targetid][mem_id][DW_MEM_ID] = -1;
			PlayerWatchedDamage[playerid][i][DW_MEM_ID] = -1;
			if(AdminLvl(targetid) > 0)
			{
				format(DV_MSG, sizeof(DV_MSG), "[NOTICE]: %s has logged during taken/given damage watch.", PlayerName(playerid));
				SendClientMessage(targetid, COLOR_NOTICE, DV_MSG);
			}
		}
	}
	return 1;
}
/////////////////////////////////////////////////////////////////////////////

/*
By pass GetPlayerHealth @anticheat_vista.pwn
*/
/*stock SSHP_GetPlayerHealth(playerid, &Float:health)
{
	health = ServerSideHP[playerid];
	return 1;
}

stock SSHP_GetPlayerArmour(playerid, &Float:Armour)
{
	Armour = ServerSideAM[playerid];
	return 1;
}

stock SSHP_SetPlayerHealth(playerid, Float:Health)
{
    ServerSideHP[playerid] = Health;
	SetPlayerHealth(playerid, Health);
	return 1;
}

stock SSHP_SetPlayerArmour(playerid, Float:Armour)
{
    ServerSideAM[playerid] = Armour;
    SetPlayerArmour(playerid, Armour);
	return 1;
}*/

enum ShotAtDetails
{
	SAD_Shooter,
	SAD_Time,
	SAD_Reason
}
new LastShotAtPlayer[MAX_PLAYERS][ShotAtDetails];

#define SHOT_STACK_RESET 15000

forward IsPlayerDead(playerid);
public IsPlayerDead(playerid)
{
	return SS_DeadPlayer[playerid];
}
forward SS_PlayerDeath(playerid, killerid, reason);

public SS_PlayerDeath(playerid, killerid, reason)
{
	SS_DeadPlayer[playerid] = true;
	KnifeBugged[playerid] = false;
 	ApplyAnimation(playerid, "PED", "KO_shot_front", 4.1, 0, 0, 0, 0, 1000, 1);
	SetPlayerHealth(playerid, 0.0);
	return 1;
}

forward DamageMath(playerid, issuerid, Float:amount, weaponid);
public DamageMath(playerid, issuerid, Float:amount, weaponid)
{
	if(SS_DeadPlayer[playerid] != true)
	{
		if(issuerid != INVALID_PLAYER_ID)
		{
		    new Float:health, Float:armour, Float:fromHealth, Float:fromArmour;
			if(hitSound[issuerid] == true && weaponid != 0 && weaponid != 37 && death[playerid] == 0)
			{
				PlayerPlaySound(issuerid,17802,0.0,0.0,0.0);
			}
            LastShotAtPlayer[playerid][SAD_Shooter] = issuerid;
			LastShotAtPlayer[playerid][SAD_Time] = NetStats_GetConnectedTime(playerid);
			LastShotAtPlayer[playerid][SAD_Reason] = weaponid;
			GetPlayerHealth(playerid, health);
			GetPlayerArmour(playerid, armour);
			fromArmour = armour - amount;
			if(fromArmour < 0.0)
			{
				fromHealth = health + fromArmour;
				if(fromHealth <= 1.0)
				{
					SS_DeadPlayer[playerid] = true;
					SetPlayerHealth(playerid, 1.0);
					SS_PlayerDeath(playerid, issuerid, weaponid);
				}
				else
				{
					SetPlayerHealth(playerid, fromHealth);
					SetPlayerArmour(playerid, 0.0);
				}
			}
			else
			{
				SetPlayerArmour(playerid, fromArmour);
			}
			if(weaponid != 37 && weaponid != 0)
				ShowTextDrawDamage(issuerid, playerid, amount);

			#if defined RAKGUY_SPAWNKILL
	   			if(!IsPlayerSpawnKilling(issuerid, playerid, weaponid))
	   			{
					GameTextForPlayer(issuerid, "Do not ~r~SpawnKill", 1500, 6);
	   			}
			#endif
			#if defined RAKGUY_ASSISTK
			KA_OnPlayerDamagePlayer(playerid, issuerid, amount);
			#endif
			Zombie_OnPlayerTakeDamage(playerid, issuerid, weaponid);
            SendDamageMessageToWatchers(playerid, issuerid, amount, weaponid);
		}
		else
		{
		    new Float:health, Float:armour, Float:fromHealth, Float:fromArmour;
			GetPlayerHealth(playerid, health);
			GetPlayerArmour(playerid, armour);
			fromArmour = armour - amount;
			if(fromArmour < 0.0)
			{
				fromHealth = health + fromArmour;
				if(fromHealth <= 1.0)
				{
					SS_DeadPlayer[playerid] = true;
					SS_PlayerDeath(playerid, issuerid, weaponid);
				}
				else
				{
					SetPlayerHealth(playerid, fromHealth);
					SetPlayerArmour(playerid, 0.0);
				}
			}
			else
			{
				SetPlayerArmour(playerid, fromArmour);
			}
			SendDamageMessageToWatchers(playerid, issuerid, amount, weaponid);
		}
	}
	return 1;
}

stock Range_Check(playerid, hitid, weaponid, &Float:range)
{
	new Float:P_Pos[3];
	GetPlayerPos(playerid, P_Pos[0], P_Pos[1], P_Pos[2]);
	range = GetPlayerDistanceFromPoint(hitid, P_Pos[0], P_Pos[1], P_Pos[2]);
	if(range > WDamage_Range[weaponid] || WDamage_Range[weaponid] == INVALID_RANGE)
	{
		return 0;
	}
	return 1;
}


stock IG_PlayerName(playerid)
{
	new igname[24];
	if(playerid == INVALID_PLAYER_ID)
	{
		igname = "INVALID_PLAYER_ID";
	}
	else if(!IsPlayerConnected(playerid))
	{
		igname = "DISCONNECTED_PLAYER_ID";
	}
	else
	{
		GetPlayerName(playerid, igname, sizeof(igname));
	}
	return igname;
}

stock IgnoredBullet(playerid, hitid, ignore_type)
{
	new ignrmsg[256];
	format(ignrmsg, sizeof(ignrmsg), IgnoredMessage[ignore_type], IG_PlayerName(playerid), IG_PlayerName(hitid));
 	new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), ignrmsg);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/IgnoredBullets.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
	//DebugMsg(ignrmsg);
	return 1;
}

stock GetPlayerDamage(playerid, hitid, weaponid, &Float:Damage_Ttl)
{
	new Float:Sht_Distance, Shot_Range;
	new Sht_Type = GetTypeOfWeapon(weaponid);
	Shot_Range = Range_Check(playerid, hitid, weaponid, Sht_Distance);
	if(Sht_Type)
	{
		if(hitid != INVALID_PLAYER_ID && IsPlayerConnected(hitid))
		{
		    new Float:Weapon_Dmg;
			if(Shot_Range)
			{
				if(Sht_Type == 1)
			    {
					Weapon_Dmg = WDamage_Amount[weaponid];
					if(Weapon_Dmg == INVALID_DAMAGE_WEAPON)
					{
						IgnoredBullet(playerid, hitid, SS_INVALIDSHOTWEAPON);
						return 0;
					}
					Damage_Ttl = Weapon_Dmg + Weapon_Dmg*WDamage_IncPercentage[weaponid];
				}
				else if(Sht_Type == 2)
				{
					switch(weaponid)
					{
						case 25:
						{
							Weapon_Dmg = NORMAL_SHOTGUN_DAMAGE(Sht_Distance);
   						}
						case 26:
						{
					 		Weapon_Dmg = SAWN_OFF_SHOTGUN_DAMAGE(Sht_Distance);
						}
						case 27:
						{
							Weapon_Dmg = COMBAT_SHOTGUN_DAMAGE(Sht_Distance);
						}
					}
					Damage_Ttl = Weapon_Dmg + Weapon_Dmg*WDamage_IncPercentage[weaponid];
				}
				if(GetPVarInt(playerid, "ExtraDamage") == 1) // Turf-Sys Perk +5% damage
				{
					Damage_Ttl = Damage_Ttl + (Damage_Ttl * 0.05);
				}
				return 1;
			}
			else
			{
				IgnoredBullet(playerid, hitid, SS_OUTOFRANGE);
				return 0;
			}
		}
	}
	else if(Sht_Type == 0)
	{
		IgnoredBullet(playerid, hitid, SS_UNKNOWN_SHOT);
		return 0;
		
	}
	return 0;
}



timer ClearKnifeBug[4000](playerid, hitid)
{
	if(KnifeBugged[playerid] == true)
	{
		IgnoredBullet(playerid, hitid, SS_KNIFE_BODY);
		new Float:Pos[3], VW;
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		VW = GetPlayerVirtualWorld(playerid);
		SetPlayerPos(playerid, 0.0, 0.0, 0.0);
		SetPlayerVirtualWorld(playerid, 12);
		SetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		SetPlayerVirtualWorld(playerid, VW);
	}
	return 1;
}

forward IsFastWeapon(weaponid);
public IsFastWeapon(weaponid)
{
	switch(weaponid)
	{
	    case 22, 27, 28, 29, 30, 31, 32, 38:
	        return 1;
	}
	return 0;
}

CMD:givendamage(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new targetid;
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[USAGE]: /givendamage [PlayerName/PlayerID]");
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerName/PlayerID");
		}
		if(!IsPlayerConnected(targetid))
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerName is not connected.");
		}
		new flag = -1;
		for(new i = 0; i < MAX_ADMINWATCH; i++)
		{
			if(AdminWatchingDamage[playerid][i][DW_PID] == -1 && flag == -1)
			{
				flag = i;
			}
			if(AdminWatchingDamage[playerid][i][DW_PID] == targetid && AdminWatchingDamage[playerid][i][DW_Type] == true)
			{
				format(DV_MSG, sizeof(DV_MSG), "[NOTICE]: You have stopped watching %s's given damage.", PlayerName(targetid));
				PlayerWatchedDamage[targetid][AdminWatchingDamage[playerid][i][DW_MEM_ID]][DW_PID] = -1;
				PlayerWatchedDamage[targetid][AdminWatchingDamage[playerid][i][DW_MEM_ID]][DW_MEM_ID] = -1;
				AdminWatchingDamage[playerid][i][DW_MEM_ID] = -1;
				AdminWatchingDamage[playerid][i][DW_PID] = -1;
				return SendClientMessage(playerid, COLOR_NOTICE, DV_MSG);
			}
		}
		if(flag == -1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not view any more given/taken damage. Limit is 3 Player/admin.");
		}
		for(new i = 0; i < MAX_PLAYERWATCHED; i++)
		{
			if(PlayerWatchedDamage[targetid][i][DW_PID] == -1)
			{
				AdminWatchingDamage[playerid][flag][DW_PID] = targetid;
				PlayerWatchedDamage[targetid][i][DW_PID] = playerid;
				AdminWatchingDamage[playerid][flag][DW_MEM_ID] = i;
				PlayerWatchedDamage[targetid][i][DW_MEM_ID] = flag;
				AdminWatchingDamage[playerid][flag][DW_Type] = true;
				PlayerWatchedDamage[targetid][i][DW_Type] = true;
				format(DV_MSG, sizeof(DV_MSG), "[NOTICE]: You have started watching %s's given damage.", PlayerName(targetid));
				return SendClientMessage(playerid, COLOR_NOTICE, DV_MSG);
			}
		}
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The Player has reached the limit of admin watchers allowed. Limit is 10 Watchers/Player");
	}
	return 1;
}



CMD:takendamage(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new targetid;
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[USAGE]: /takendamage [PlayerName/PlayerID]");
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerName/PlayerID");
		}
		if(!IsPlayerConnected(targetid))
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerName is not connected.");
		}
		new flag = -1;
		for(new i = 0; i < MAX_ADMINWATCH; i++)
		{
			if(AdminWatchingDamage[playerid][i][DW_PID] == -1 && flag == -1)
			{
				flag = i;
			}
			if(AdminWatchingDamage[playerid][i][DW_PID] == targetid && AdminWatchingDamage[playerid][i][DW_Type] == false)
			{
				format(DV_MSG, sizeof(DV_MSG), "[NOTICE]: You have stopped watching %s's taken damage.", PlayerName(targetid));
				PlayerWatchedDamage[targetid][AdminWatchingDamage[playerid][i][DW_MEM_ID]][DW_PID] = -1;
				PlayerWatchedDamage[targetid][AdminWatchingDamage[playerid][i][DW_MEM_ID]][DW_MEM_ID] = -1;
				AdminWatchingDamage[playerid][i][DW_MEM_ID] = -1;
				AdminWatchingDamage[playerid][i][DW_PID] = -1;
				return SendClientMessage(playerid, COLOR_NOTICE, DV_MSG);
			}
		}
		if(flag == -1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not view any more given/taken damage. Limit is 3 Player/admin.");
		}
		for(new i = 0; i < MAX_PLAYERWATCHED; i++)
		{
			if(PlayerWatchedDamage[targetid][i][DW_PID] == -1)
			{
				AdminWatchingDamage[playerid][flag][DW_PID] = targetid;
				PlayerWatchedDamage[targetid][i][DW_PID] = playerid;
				AdminWatchingDamage[playerid][flag][DW_MEM_ID] = i;
				PlayerWatchedDamage[targetid][i][DW_MEM_ID] = flag;
				AdminWatchingDamage[playerid][flag][DW_Type] = false;
				PlayerWatchedDamage[targetid][i][DW_Type] = false;
				format(DV_MSG, sizeof(DV_MSG), "[NOTICE]: You have started watching %s's taken damage.", PlayerName(targetid));
				return SendClientMessage(playerid, COLOR_NOTICE, DV_MSG);
			}
		}
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The Player has reached the limit of admin watchers allowed. Limit is 10 Watchers/Player");

	}
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	ClearWatchingVariables(playerid);
	return 1;
}

hook OnPlayerConnect(playerid)
{
	ClearWatchingVariables(playerid);
	return 1;
}

hook OnGameModeInit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    for(new j = 0; j < MAX_PLAYERWATCHED; j++)
	    {
	        if(j < MAX_ADMINWATCH)
	        {
				AdminWatchingDamage[i][j][DW_PID] = -1;
				AdminWatchingDamage[i][j][DW_MEM_ID] = -1;
				AdminWatchingDamage[i][j][DW_Type] = false;
			}
			PlayerWatchedDamage[i][j][DW_PID] = -1;
			PlayerWatchedDamage[i][j][DW_MEM_ID] = -1;
			PlayerWatchedDamage[i][j][DW_Type] = false;
	    }
	}
	return 1;
}

//BUG FIX//
CMD:cleardamagevariables(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new targetid;
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[USAGE]: /cleardamagevariables [PlayerName/PlayerID]");
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerName/PlayerID");
		}
		if(!IsPlayerConnected(targetid))
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerName is not connected.");
		}
        ClearWatchingVariables(targetid);
	}
	return 1;
}

CMD:debugdamages(playerid)
{
	for(new i = 0; i < MAX_PLAYERWATCHED ; i ++)
	{
		format(DV_MSG, sizeof(DV_MSG), "%i - %i - %i", PlayerWatchedDamage[playerid][i][DW_PID], PlayerWatchedDamage[playerid][i][DW_MEM_ID], PlayerWatchedDamage[playerid][i][DW_Type]);
		SendClientMessage(playerid, COLOR_NOTICE, DV_MSG);
	}
	return 1;
}

/*
Moved to Different File or Main_CallBack.pwn


forward CheckSilentAim(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public CheckSilentAim(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(hittype == 1 && hitid != INVALID_PLAYER_ID && IsPlayerConnected(hitid))
	{
		new Float:fOriginX, Float:fOriginY, Float:fOriginZ,
		Float:fHitPosX, Float:fHitPosY, Float:fHitPosZ;
	    GetPlayerLastShotVectors(playerid, fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);
		GetPlayerPos(hitid, fOriginX, fOriginY, fOriginZ);
		fHitPosX = fHitPosZ-fOriginZ;
		fOriginX = fZ - (fHitPosZ-fOriginZ);
		new Float:posplayer;
		new Float:useless[2];
		GetPlayerPos(playerid, useless[0],  useless[1], posplayer);
		posplayer = fOriginZ - posplayer;
	    posplayer = floatabs(posplayer);
	    fOriginX  = floatabs(fOriginX);
		if(fHitPosX == 0.000000 || fHitPosX == SA_Strike[playerid][SA_LAST_VALUE])
		{
	 		if(WatchSALog[playerid] == true)
			{
			    format(SA_MSG, sizeof(SA_MSG), "[GUARDIAN]: %s shot at %s [Silent Aim Value:[ShotAt: %.9f] || [HitAt: %.9f]", PlayerName(playerid), PlayerName(hitid), fHitPosX, fOriginX);
   				SendAdminMessage(1, SA_MSG);
			}
		    SA_Strike[playerid][SA_LAST_VALUE] = fHitPosX;
		    SA_Strike[playerid][SA_PStrike]= SA_Strike[playerid][SA_PStrike] + 1;
			if(SA_Strike[playerid][SA_PStrike]%5 == 0)
			{
				format(SA_MSG, sizeof(SA_MSG), "%s is using Silentaimbot(%.9f).", PlayerName(playerid), fHitPosX);
				AntiCheatMessage(SA_MSG);
			}
   			format(SA_MSG, sizeof(SA_MSG), "[GUARDIAN]: %s shot at %s [Silent Aim Value: %.9f]", PlayerName(playerid), PlayerName(hitid), fHitPosX);
		    CheatLog(RF_MSG);
			return 0;
		}
		else
		    SA_Strike[playerid][SA_LAST_VALUE] = fHitPosX;
	}
	return 1;
}

forward CheckPoorAim(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public CheckPoorAim(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(hittype == BULLET_HIT_TYPE_PLAYER)
	{
		if(GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID && !IsPlayerInAnyVehicle(playerid))
		{
			new Float:fOriginX, Float:fOriginY, Float:fOriginZ,Float:fHitPosX, Float:fHitPosY, Float:fHitPosZ;
			GetPlayerLastShotVectors(playerid, fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);
			new Float:BulletDistance = GetDistanceBetweenVectors(fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);
			new Float:AB_PlayerLoc[3];
			GetPlayerPos(hitid,AB_PlayerLoc[0],AB_PlayerLoc[1],AB_PlayerLoc[2]);
			new Float:AB_Distance = GetPlayerDistanceFromPoint(playerid, AB_PlayerLoc[0],AB_PlayerLoc[1],AB_PlayerLoc[2]);
			if(BulletDistance<=3.1 && AB_Distance>=10.0 && AB_Distance<250.0 && AB_Distance - BulletDistance > 5.0)
			{
				if(PAB_Count[playerid]==-1)
				{
					PAB_Count[playerid]++;
				}
				PAB_TCount[playerid]++;
				format(PAB_MSG, sizeof(PAB_MSG), "[Poor/Pro_Aimbot]%s (%d) :(BulletDist.: %f | PlayerDist.: %f)].", PlayerName(playerid), playerid, BulletDistance, AB_Distance);
				CheatLog(PAB_MSG);
				PAB_LOG[playerid][PAB_Count[playerid]][0]=BulletDistance;
				PAB_LOG[playerid][PAB_Count[playerid]][1]=AB_Distance;
				PAB_Count[playerid]++;
				if(PAB_Count[playerid] % PAB_CountLimit == 0)
				{
					format(PAB_MSG, sizeof(PAB_MSG), "%s (%i) is using pro/poor-aim.cs(Count: %d)[(BulletDist.: %f | PlayerDist.: %f)].", PlayerName(playerid), playerid, PAB_TCount[playerid], BulletDistance, AB_Distance);
					AntiCheatMessage(PAB_MSG);
					if(PAB_Count[playerid]==PAB_LOGLMT)
					{
						PAB_Count[playerid]=0;
					}
				}
				return 0;
			}
		}
	}
	return 1;
}

forward CheckNoSpread(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public CheckNoSpread(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(NS_Toggled==false)
	{
		new bool:flag = false;
		if(NoSpreadTest[playerid]==true)
		{
			if(weaponid==24)
			{
			    new Float:fOriginX, Float:fOriginY, Float:fOriginZ,Float:fHitPosX, Float:fHitPosY, Float:fHitPosZ;
				GetPlayerLastShotVectors(playerid, fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);
			    new Float:BulletDistance = GetDistanceBetweenVectors(fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);
			    if(BulletDistance>=105.0)
			    {
			        return 1;
			    }
				GetBXYZInFrontOfPlayer(playerid, BulletDistance, fOriginX, fOriginY, fOriginZ);
				new Float:RayDistance=GetDistance(fOriginX, fOriginY, fOriginZ,fHitPosX, fHitPosY, fHitPosZ);
				BulletDistance=BulletDistance/RayDistance;
				if(BulletDistance>=8.880 && BulletDistance<8.890)
				{
				    new TempNSTime=gettime()-NoSpreadTime[playerid];
				    if(TempNSTime<3)
				    {
						format(NS_MSG, sizeof(NS_MSG), "[GUARDIAN]: %s has shot accurately.[Time: %i | Accuracy: %f]", PlayerName(playerid),TempNSTime,BulletDistance);
						CheatLog(NS_MSG);
					    NoSpreadStrike[playerid]++;
					    NoSpreadKeyStrike[playerid]++;
						if(NoSpreadKeyStrike[playerid] > 1)
						{
							flag = true;
						}
						if(NS_AdminW[playerid]==true)
						{
							SendAdminMessage(NS_CMDLMT, NS_MSG);
						}
						if(NoSpreadStrike[playerid]%5==0&&NoSpreadStrike[playerid]>4 && NoSpreadKeyStrike[playerid]!=1)
					    {
							format(NS_MSG, sizeof(NS_MSG), "%s (%i) is possibly using nospread.cs[TotalAccurateShots(%i):LastSession(%i)]", PlayerName(playerid), playerid,NoSpreadStrike[playerid],NoSpreadKeyStrike[playerid]);
		                    AntiCheatMessage(NS_MSG);
						}
					}
				}
				NoSpreadTime[playerid]=gettime();
				if(BulletDistance==1.5 && RayDistance==0.689237)
				{
				    SilentAimWarnings[playerid]++;
				    if(SilentAimWarnings[playerid]==8)
				    {
				        format(NS_MSG, sizeof(NS_MSG), "%s (%i) is using SilentAim.cs.", PlayerName(playerid), playerid);
				        AntiCheatMessage(NS_MSG);
				        //ABanPlayer(-1, playerid, "SilentAim.cs");
				    }
				}
			}
		}
		if(flag == true)
		{
			return 0;
		}
	}
	//End of NoSpread
	return 1;
}

forward CheckRapidFire(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public CheckRapidFire(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	//RapidFire
	if(weaponid<35 && weaponid>21 && GetPlayerVehicleID(playerid)==0)
	{
		new bool:flag = false;
		if(RF_Loghim[playerid]==true)
		{
	       	new NewShotTime=NetStats_GetConnectedTime(playerid);
		    if(LastShotTime[playerid]-LastCTime[playerid]>400)
		    {
			    RapidFireSession[playerid][RapidFireBulletC[playerid]]=NewShotTime-LastShotTime[playerid];
				if(RapidFireSession[playerid][RapidFireBulletC[playerid]] < RF_Delay[weaponid-22])
				{
					flag = true;
				}
			    RapidFireBulletC[playerid]++;
			    RapidFireMagC[playerid]++;
			}
			if(RapidFireMagC[playerid]>(RF_MagSize[weaponid-22]+10)&&(NetStats_GetConnectedTime(playerid)-NR_AntiSpam[playerid]>5000))
			{
			    NR_AntiSpam[playerid]=NetStats_GetConnectedTime(playerid);
  			 	format(RF_MSG, sizeof(RF_MSG), "[RF_AutoBan]: %s (%i) has been striked by RapidFire Script for no-reload.[WeaponID:%i] [TotBullets: %i | %i | %i]",PlayerName(playerid), playerid,weaponid,RapidFireBulletC[playerid],RapidFireMagC[playerid], RF_MagSize[weaponid-22]);
    			CheatLog(RF_MSG);
				if(RapidFire_AlreadyBanned[playerid]==0)
     			{
				    format(RF_MSG, sizeof(RF_MSG), "%s (%i) is possibly using No-Reload hack.", PlayerName(playerid), playerid);
                    AntiCheatMessage(RF_MSG);
			 	    if(TAdminsOnline()==0 && AdminsOnline()==0)
     			    {
						RapidFire_AlreadyBanned[playerid]=1;
						AKickPlayer(-1, playerid, "NoReload");
					}
					
				}
			}
			if(RapidFire_IsReloadable(playerid, weaponid)==0 && RapidFireBulletC[playerid] == 6)
			{
			    LastSessionAverage(playerid, weaponid);
			}
	       	LastShotTime[playerid] = NewShotTime;
	 	}
		if(flag == true)
		{
			return 0;
		}
	}
	return 1;
}

forward CheckKnifeBug(playerid, hitid);
public CheckKnifeBug(playerid, hitid)
{
	if(KnifeBugged[playerid] == true)
	{
	 	IgnoredBullet(playerid, hitid, SS_KNIFEBUG);
	 	return 0;
	}
	if(KnifeBugged[hitid] == true)
	{
		IgnoredBullet(playerid, hitid, SS_KNIFE_BODY);
		return 0;
	}
	return 1;
}

forward CheckCrasher(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public CheckCrasher(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	new string[156];
	if(weaponid < 22 || weaponid > 34 && weaponid != 38)
	{
		format(string, sizeof(string), "[AdmCMD]: The Guardian has banned %s(%d), Reason: AimCrasher (WpnID)[WpnID: %d, Hittype: %d, HitID: %d]", PlayerName(playerid), playerid, weaponid, hittype, hitid);
		AdminLog(string);
		format(string, sizeof(string), "AimCrasher");
		ABanPlayer(-1, playerid, string);
		return 0;
	}
	if(hittype < 0 || hittype > 4)
	{
		format(string, sizeof(string), "[AdmCMD]: The Guardian has banned %s(%d), Reason: AimCrasher (HitType)[WpnID: %d, Hittype: %d, HitID: %d]", PlayerName(playerid), playerid, weaponid, hittype, hitid);
		AdminLog(string);
		format(string, sizeof(string), "AimCrasher");
		ABanPlayer(-1, playerid, string);
		return 0;
	}
	// For bulletcrasher, made by mr pEar. Accurate, so allowed it to autoban
	if(hittype == 1)
	{
		if(fX >= 10000 || fY >= 10000 || fZ >= 10000)
		{
			format(string, sizeof(string), "[AdmCMD]: The Guardian has banned %s(%d), Reason: BulletCrasher [fX: %f, fY: %f, fZ: %f]", PlayerName(playerid), playerid, fX, fY, fZ);
			AdminLog(string);
			format(string, sizeof(string), "BulletCrasher");
			ABanPlayer(-1, playerid, string);
			return 0;
		}
	}
	return 1;
}

forward CheckDeathAndAdmin(playerid, hitid);
public CheckDeathAndAdmin(playerid, hitid)
{
	if(SS_DeadPlayer[playerid] == true)
	{
		IgnoredBullet(playerid, hitid, SS_DEAD_PLAYER);
		return 0;
	}
 	if(SS_DeadPlayer[hitid] == true)
	{
		IgnoredBullet(playerid, hitid, SS_DEAD_BODY);
		return 0;
	}
	if(Aduty[hitid] == 1)
	{
		IgnoredBullet(playerid, hitid, SS_ADUTY);
		return 0;
	}
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	IdleTime[playerid] = 0;
	if(!CheckCrasher(playerid, weaponid, hittype, hitid, fX, fY, fZ))
	{
		IgnoredBullet(playerid, hitid, SS_CRASHER);
		return 0;
	}
	if(hittype == BULLET_HIT_TYPE_PLAYER)
	{
		if(!CheckDeathAndAdmin(playerid, hitid))
		{
			return 1;
		}
		if(!IsFastWeapon(weaponid)
		{
			if(!CheckRapidFire(playerid, weaponid, hittype, hitid, fX, fY, fZ))
			{
				IgnoredBullet(playerid, hitid, SS_RAPID);
				return 1;
			}
		}
		if(weaponid==24)
		{
			if(!CheckNoSpread(playerid, weaponid, hittype, hitid, fX, fY, fZ))
			{
				IgnoredBullet(playerid, hitid, SS_SPREAD);
				return 1;
			}
		}
		if(weaponid!=38)
		{
			if(!CheckSilentAim(playerid, weaponid, hittype, hitid, fX, fY, fZ))
			{
				IgnoredBullet(playerid, hitid, SS_SILENTAIM);
				return 1;
			}
		}
		if(!CheckPoorAim(playerid, weaponid, hittype, hitid, fX, fY, fZ))
		{
			IgnoredBullet(playerid, hitid, SS_POORAIM);
			return 1;
		}
		if(!CheckKnifeBug(playerid, hitid))
		{
		    return 1;
		}
		if(!IsPlayerStreamedIn(hitid, playerid))
		{
			IgnoredBullet(playerid, hitid, SS_NOTSTREAMED);
			return 0;
		}
		new Float:Damage_Ttl;
		if(GetPlayerDamage(playerid, hitid, weaponid, Damage_Ttl))
		{
			DamageMath(hitid, playerid, Damage_Ttl, weaponid);
		}
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	SS_DeadPlayer[playerid] = true;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SS_DeadPlayer[playerid] = false;
	SetPlayerTeam(playerid, 1);
}


public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid, bodypart)
{
	format(sshp_msg, sizeof(sshp_msg), "GD: %i %i %f %i %i", playerid, damagedid, amount, weaponid, bodypart);
	DebugMsg(sshp_msg);
	if(SS_DeadPlayer[playerid] != true)
	{
	    if(damagedid != INVALID_PLAYER_ID)
	    {
			if(!IsPlayerStreamedIn(damagedid, playerid))
			{
				IgnoredBullet(playerid, damagedid, SS_NOTSTREAMED);
				return 1;
			}
			if(!CheckDeathAndAdmin(playerid, damagedid))
			{
				return 1;
			}
			if(!CheckKnifeBug(playerid, damagedid))
			{
			    return 1;
			}
			if(IsPlayerInAnyVehicle(damagedid))
			{
			    new Float:Damage_Ttl;
				if(GetPlayerDamage(playerid, damagedid, weaponid, Damage_Ttl))
				{
					DamageMath(damagedid, playerid, Damage_Ttl, weaponid);
				}
			}
			if(GetTypeOfWeapon(weaponid) == WEAPON_TYPE_HAND)
			{
				if(weaponid == 4 && amount == 0.0)
				{
	                 KnifeBugged[damagedid] = true;
					 defer ClearKnifeBug(damagedid, playerid);
				}
				else if(weaponid == 4 && amount > 0.0 && KnifeBugged[damagedid] == true)
				{
				    DamageMath(damagedid, playerid, 999.0, weaponid);
				}
				else
				{
					if(KnifeBugged[damagedid] == true)
					{
                        IgnoredBullet(playerid, damagedid, SS_KNIFE_BODY);
                        return 1;
					}
					if(KnifeBugged[playerid] == true)
					{
                        IgnoredBullet(playerid, damagedid, SS_KNIFEBUG);
                        return 1;
					}
					DamageMath(damagedid, playerid, WDamage_Amount[weaponid], weaponid);
				}
			}
		}
		else
		{
		    IgnoredBullet(playerid, damagedid, SS_NONE_HIT);
		}
	}
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
	if(SS_DeadPlayer[playerid] != true)
	{
	    if(issuerid != INVALID_PLAYER_ID)
	    {
			if(weaponid == 4 && amount == 0.0 && KnifeBugged[issuerid] == true)
			{
				KnifeBugged[issuerid] = false;
				DamageMath(issuerid, playerid, 999.0, weaponid);
			}
		}
		if(GetTypeOfWeapon(weaponid) == WEAPON_TYPE_FIRE)
		{
			DamageMath(playerid, issuerid, WDamage_Amount[weaponid], weaponid);
		}
		if(GetTypeOfWeapon(weaponid) == WEAPON_TYPE_BANNED)
		{
			new Float:CarPark_HB[3];
		    GetPlayerPos(playerid, CarPark_HB[0], CarPark_HB[1], CarPark_HB[2]);
			SetPlayerPos(playerid, CarPark_HB[0], CarPark_HB[1], CarPark_HB[2]+2.0);
			ClearAnimations(playerid);
		    GameTextForPlayer(playerid, "~w~You've been slapped to ~g~fix~n~~w~HeliBlade/Car Park Anim.", 500, 3);
			if(issuerid != INVALID_PLAYER_ID)
			{
   				GameTextForPlayer(issuerid, "~w~Do not ~r~HeliBlade/CarPark", 500, 3);
			    GetPlayerPos(issuerid, CarPark_HB[0], CarPark_HB[1], CarPark_HB[2]);
				SetPlayerPos(issuerid, CarPark_HB[0], CarPark_HB[1], CarPark_HB[2]);
				ClearAnimations(issuerid);
			}
		}
		if(GetTypeOfWeapon(weaponid) == WEAPON_CAR_RAM)
		{
			if(gettime() - CarRamDelay[issuerid] < 5)
			{
			    IgnoredBullet(playerid, issuerid, SS_RAPIDCARRAM);
			}
			else
			{
			    DamageMath(playerid, issuerid, WDamage_Amount[weaponid], weaponid);
			}
			CarRamDelay[playerid] = gettime();
		}
	}
	return 1;
}
*/


