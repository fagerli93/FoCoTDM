/*********************************************************************************
*																				 *
*				 ______     _____        _______ _____  __  __                   *
*				|  ____|   / ____|      |__   __|  __ \|  \/  |                  *
*				| |__ ___ | |     ___      | |  | |  | | \  / |                  *
*				|  __/ _ \| |    / _ \     | |  | |  | | |\/| |                  *
*				| | | (_) | |___| (_) |    | |  | |__| | |  | |                  *
*				|_|  \___/ \_____\___/     |_|  |_____/|_|  |_|                  *
*                                                                                *
*                                                                                *
*								(c) Copyright				 					 *
*  Owners: Simon Fagerli (pEar) - Lee Percox (Shaney) - Warren Bickley (WazzaJB) *
*         Developers: Marcel, RakGuy, FKu, Chilco, dr_vista, Fletcher            *
*																				 *
* Filename: ac_weaponhack.pwn                                                    *
* Created by: -                                                                  *
*********************************************************************************/

#include <YSI\y_hooks>

#define WEAP_MAX_SLOTS 13
forward OnPlayerSwitchWeapon(playerid, weaponid, ammo);

enum WH_WeaponStats
{
	WH_WeaponID,
	WH_Ammo,
	WH_Ammo_Given,
	bool:WH_WeaponScrolled,
	WH_BulletShot,
	WH_WStrike,
	WH_WTime,
	WH_AStrike,
	WH_ATime
};

new bool:WH_Akicked[MAX_PLAYERS];
new LastRLShot[MAX_PLAYERS];
new PossessedWeapons[MAX_PLAYERS][WEAP_MAX_SLOTS][WH_WeaponStats];
new WeapFreeze[MAX_PLAYERS];
new PlayerHeldWeapon[MAX_PLAYERS];
stock HWeaponName(weaponid)
{
	new wpname[32];
	if(weaponid == 0)
	{
	    wpname = "Fist";
	    return wpname;
	}
	GetWeaponName(weaponid, wpname, sizeof(wpname));
	return wpname;
}

new WH_BulletSlot[23][2] =
{
	//THROWN
	  {5, 3}, //16
	  {5, 3}, //17
	  {5, 3}, //18
	//INVALID_WEAPONS
	  {-1, -1}, //19
	  {-1, -1}, //20
	  {-1, -1}, //21
	// Pistols 
	  {020, 4}, //22
	  {017, 3}, //23
	  {007, 4}, //24
	// Shotgun
	  {005, 5}, //25
	  {004, 5}, //26
	  {007, 5}, //27
	// Automatic
	  {030, 3}, //28
	  {030, 3}, //29
	  {030, 3}, //30
	  {030, 3}, //31
	  {030, 3}, //32
	// Rifle
	  {010, 2}, //33
	  {010, 2}, //34
	 //Minigun + RPG
	  {05, 2}, //35
	  {05, 2}, //36
	  {050, 2}, //37
	  {070, 2}  //38
//Usage : RF_MagSize[weaponid-16]
};

stock GetWeaponSlot(weaponid)
{
	new slot;
	switch(weaponid)
	{
		case 0, 1: 
			return slot = 0;
		case 2 .. 9: 
			return slot = 1;
		case 10 .. 15: 
			return slot = 10;
		case 16 .. 18, 39: 
			return slot = 8;
		case 22 .. 24: 
			return slot = 2;
		case 25 .. 27: 
			return slot = 3;
		case 28, 29, 32: 
			return slot = 4;
		case 30, 31: 
			return slot = 5;
		case 33, 34: 
			return slot = 6;
		case 35 .. 38: 
			return slot = 7;
		case 40: 
			return slot = 12;
		case 41 .. 43: 
			return slot = 9;
		case 44 .. 46: 
			return slot = 11;
		default:
			return slot = -1;
	}
	return slot;
}

stock IsSameBulletWeapon(slotid)
{
	switch(slotid)
	{
	    case 3, 4, 5:
	        return 1;
		default:
		    return 0;
	}
	return 0;
}

forward AddedWeapon(playerid, weaponid, ammo);
public AddedWeapon(playerid, weaponid, ammo)
{
	DebugMsg("Adding");
	new slotid = GetWeaponSlot(weaponid);
	new bool:WS_Limit;
	if(slotid != -1)
	{
		if(PossessedWeapons[playerid][slotid][WH_WeaponID] == -1)
		{
            DebugMsg("ID -1");
			PossessedWeapons[playerid][slotid][WH_Ammo] = ammo;
			PossessedWeapons[playerid][slotid][WH_WeaponScrolled] = false;
		}
		else if(IsSameBulletWeapon(slotid) || weaponid == PossessedWeapons[playerid][slotid][WH_WeaponID])
		{
		    DebugMsg("SameSlot");
			PossessedWeapons[playerid][slotid][WH_Ammo] = PossessedWeapons[playerid][slotid][WH_Ammo] + ammo;
		}
		else
		{
		    DebugMsg("BS_Ammo");
		    PossessedWeapons[playerid][slotid][WH_Ammo] = ammo;
		}
		if(PossessedWeapons[playerid][slotid][WH_Ammo] > 9999)
		{
		    DebugMsg("Limit_reached");
		    PossessedWeapons[playerid][slotid][WH_Ammo] = 9999;
			WS_Limit = true;
		}
		DebugMsg("Setting Weapons");
		PossessedWeapons[playerid][slotid][WH_Ammo_Given] = PossessedWeapons[playerid][slotid][WH_Ammo];
   		PossessedWeapons[playerid][slotid][WH_WeaponID] = weaponid;
		PossessedWeapons[playerid][slotid][WH_BulletShot] = 0;
	}
	DebugMsg("Done Adding");
	if(WS_Limit == true)
	    return 0;
	return 1;
}

forward ResetedWeapon(playerid);
public ResetedWeapon(playerid)
{
	for(new i = 0; i < WEAP_MAX_SLOTS; i++)
	{
		PossessedWeapons[playerid][i][WH_WeaponID] = -1;
		PossessedWeapons[playerid][i][WH_Ammo] = -1;
		PossessedWeapons[playerid][i][WH_WeaponScrolled] = false;		
		PossessedWeapons[playerid][i][WH_BulletShot] = 0;
		PossessedWeapons[playerid][i][WH_WStrike] = 0;
		PossessedWeapons[playerid][i][WH_WTime] = 0;
		PossessedWeapons[playerid][i][WH_AStrike] = 0;
		PossessedWeapons[playerid][i][WH_ATime] = 0;
		PossessedWeapons[playerid][i][WH_Ammo_Given] = -1;
	}
	return 1;
}

forward RemoveWeapon(playerid, weaponid);
public RemoveWeapon(playerid, weaponid)
{
	new slotid = GetWeaponSlot(weaponid);
	if(slotid != -1)
	{
		PossessedWeapons[playerid][slotid][WH_WeaponID] = -1;
		PossessedWeapons[playerid][slotid][WH_Ammo] = -1;
		PossessedWeapons[playerid][slotid][WH_WeaponScrolled] = false;
		PossessedWeapons[playerid][slotid][WH_BulletShot] = 0;
		PossessedWeapons[playerid][slotid][WH_WStrike] = 0;
		PossessedWeapons[playerid][slotid][WH_WTime] = 0;
		PossessedWeapons[playerid][slotid][WH_AStrike] = 0;
		PossessedWeapons[playerid][slotid][WH_ATime] = 0;
		PossessedWeapons[playerid][slotid][WH_Ammo_Given] = 0;
	}	
}

forward SetAmmo(playerid, weaponid, ammo);
public SetAmmo(playerid, weaponid, ammo)
{
	new slotid = GetWeaponSlot(weaponid);
	if(slotid != -1)
	{
		PossessedWeapons[playerid][slotid][WH_WeaponID] = weaponid;
		PossessedWeapons[playerid][slotid][WH_Ammo] = ammo;
		PossessedWeapons[playerid][slotid][WH_Ammo_Given] = ammo;
	}
}

forward WeaponHackNotify(playerid, slotid, weaponid, ammo, weaponhack, ammohack);

public WeaponHackNotify(playerid, slotid, weaponid, ammo, weaponhack, ammohack)
{
	if(weaponhack + ammohack > 0)
	{
		new WH_MSG[128];
		new WOldTime = PossessedWeapons[playerid][slotid][WH_WTime];
		new AOldTime = PossessedWeapons[playerid][slotid][WH_ATime];
		if(weaponhack == 1)
		{
			format(WH_MSG, sizeof(WH_MSG), "%s(%i) is hacking weapon %s", PlayerName(playerid), playerid, HWeaponName(weaponid));
			PossessedWeapons[playerid][slotid][WH_WStrike]++;
			PossessedWeapons[playerid][slotid][WH_WTime] = gettime();
		}
		else if(weaponhack == 2)
		{
			format(WH_MSG, sizeof(WH_MSG), "%s(%i) should have %s and is hacking %s", PlayerName(playerid), playerid, HWeaponName(PossessedWeapons[playerid][slotid][WH_WeaponID]), HWeaponName(weaponid));
			PossessedWeapons[playerid][slotid][WH_WStrike]++;
			PossessedWeapons[playerid][slotid][WH_WTime] = gettime();		
		}
		////////////////////////////////////////////////////////////////////////
		if(ammohack == 1)
		{
			DebugMsg("Supposed to notify");
			if(weaponhack == 0)
			{
				format(WH_MSG, sizeof(WH_MSG), "%s(%i) is hacking ammo for %s. HackedAmmo: %i",  PlayerName(playerid), playerid, HWeaponName(weaponid), ammo - PossessedWeapons[playerid][slotid][WH_Ammo]);
				PossessedWeapons[playerid][slotid][WH_AStrike]++;
				PossessedWeapons[playerid][slotid][WH_ATime] = gettime();
			}
			else
			{
				format(WH_MSG, sizeof(WH_MSG), "%s and its ammo. HackedAmmo: %i", WH_MSG, ammo - PossessedWeapons[playerid][slotid][WH_Ammo]);
				PossessedWeapons[playerid][slotid][WH_AStrike]++;
				PossessedWeapons[playerid][slotid][WH_ATime] = gettime();
			}
		}
		if(gettime() - WOldTime > 5 && gettime() - AOldTime > 5)
		{
			AntiCheatMessage(WH_MSG);
		}
		else
		{
			PossessedWeapons[playerid][slotid][WH_WTime] = WOldTime;
			PossessedWeapons[playerid][slotid][WH_ATime] = AOldTime;
		}
		CheatLog(WH_MSG);
		if(weaponid >= 16)
		{
			if(PossessedWeapons[playerid][slotid][WH_WStrike] >= WH_BulletSlot[weaponid-16][1] && PossessedWeapons[playerid][slotid][WH_WStrike] % WH_BulletSlot[weaponid-16][1] == 0)
			{
				if(AdminsOnline() <= 0 && WH_Akicked[playerid] == false)
				{
					AKickPlayer(-1, playerid, "WeaponHacks");
                    WH_Akicked[playerid] = true;
				}
			}
			else if(PossessedWeapons[playerid][slotid][WH_AStrike] >= WH_BulletSlot[weaponid-16][1] && PossessedWeapons[playerid][slotid][WH_AStrike] % WH_BulletSlot[weaponid-16][1] == 0)
			{
				if(AdminsOnline() <= 0 && WH_Akicked[playerid] == false)
				{
					AKickPlayer(-1, playerid, "AmmoHacks");
                    WH_Akicked[playerid] = true;
				}
			}
		}
	}
	return 1;
}

public OnPlayerSwitchWeapon(playerid, weaponid, ammo)
{
	DebugMsg("Called SwitchWeapon");
	if(weaponid != -1)
	{
		new slotid = GetWeaponSlot(weaponid);
		DebugMsg("Called Checking Slot");
		PossessedWeapons[playerid][slotid][WH_BulletShot] = 0;
		if(slotid != -1)
		{
		    DebugMsg("Called Slot");
			new ammohack, weaponhack;
			if(PossessedWeapons[playerid][slotid][WH_WeaponID] != -1)
			{
			    new WH_MSG[128];
			    format(WH_MSG, sizeof(WH_MSG), "Ammo: %i || H_Ammo: %i", ammo, PossessedWeapons[playerid][slotid][WH_Ammo]);
                DebugMsg(WH_MSG);
				if(PossessedWeapons[playerid][slotid][WH_WeaponID] == weaponid)
				{
				    DebugMsg("Called Weapon-Same");
					if(PossessedWeapons[playerid][slotid][WH_Ammo] != ammo)
					{
					    DebugMsg("Called Not-Same Ammo");
					    if( (weaponid >= 16 && weaponid <= 18) || weaponid == 35 || weaponid == 36 )
					    {
					        DebugMsg("Called Custom Detection");
							if(PossessedWeapons[playerid][slotid][WH_Ammo_Given] < (ammo - PossessedWeapons[playerid][slotid][WH_Ammo]) || ammo < -1 || ammo > 9999)
							{
							    ammohack = 1;
							    DebugMsg("Hacking Ammo");
							    //HackingAmmo
							}
					    }
						else if(PossessedWeapons[playerid][slotid][WH_Ammo] < ammo)
						{
						    DebugMsg("Called Else");
						    if(weaponid == 38 && ammo - PossessedWeapons[playerid][slotid][WH_Ammo] <= 30)
							    return 1;
						    else
								ammohack = 1;
							DebugMsg("Hacking Ammo");
							//Hacking-Ammo
						}
						else
						{
							DebugMsg ("Called Ammo");
						    if(ammo < -1)
						        ammohack = 1;
							else
								if(!IsNonShootingWeapon(weaponid))
									ammohack = 2;
									//Desync-Maybe
						}
					}
				}
				else
				{
					weaponhack = 2;
					if(ammo != -1)
					    ammohack = 1;
					//Hacking-WrongWeapon
				}
			}
			else
			{
				weaponhack = 1;
				if(ammo != -1)
				    ammohack = 1;
				//Hacking-Weapon
			}
			WeaponHackNotify(playerid, slotid, weaponid, ammo, weaponhack, ammohack);
		}
	}
	return 1;
}


hook OnPlayerConnect(playerid)
{
	WH_Akicked[playerid] = false;
    PlayerHeldWeapon[playerid] = 0;
	ResetedWeapon(playerid);
	WeapFreeze[playerid] = 0;
	LastRLShot[playerid] = 0;
	return 1;
}


hook OnPlayerDisconnect(playerid)
{
	PlayerHeldWeapon[playerid] = 0;
	ResetedWeapon(playerid);
	WeapFreeze[playerid] = 0;
	LastRLShot[playerid] = 0;
	return 1;
}

/*hook OnPlayerDeath(playerid, killerid, reason)
{
	ResetedWeapon(playerid);
	return 1;
}*/

hook OnPlayerSpawn(playerid)
{
	if(WeapFreeze[playerid] == 1)
	{
		WeapFreeze[playerid] = 0;
	}
	PlayerHeldWeapon[playerid] = 0;
	return 1;
}


forward WH_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public WH_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if( (weaponid >= 22 && weaponid <= 38) || (weaponid >= 16 && weaponid <= 18))
	{
		new slotid = GetWeaponSlot(weaponid);
		new ammo = GetPlayerAmmo(playerid);
		PossessedWeapons[playerid][slotid][WH_WeaponScrolled] = true;
		PossessedWeapons[playerid][slotid][WH_BulletShot] = PossessedWeapons[playerid][slotid][WH_BulletShot] + 1;
		new WH_Type;
		if(PossessedWeapons[playerid][slotid][WH_WeaponID] == -1)
		{
			WH_Type = 1;
			//Hacking-Weapon
		}
		else if(PossessedWeapons[playerid][slotid][WH_WeaponID] != weaponid)
		{
			WH_Type = 2;
			//Hacking-WrongWeapon
		}
		if(WH_Type > 0)
 			WeaponHackNotify(playerid, slotid, weaponid, ammo, WH_Type, 0);
		if(PossessedWeapons[playerid][slotid][WH_BulletShot] == WH_BulletSlot[weaponid-16][0])
		{
			OnPlayerSwitchWeapon(playerid, weaponid, ammo);
		}
		/*if(PossessedWeapons[playerid][slotid][WH_Ammo] == -1 || PossessedWeapons[playerid][slotid][WH_Ammo] != ammo)
		{
			if(PossessedWeapons[playerid][slotid][WH_Ammo] != ammo)
			{
				if(PossessedWeapons[playerid][slotid][WH_Ammo] < ammo)
				{
					WH_Type[1] = 1;
					//Hacking-Ammo
				}
				else
				{
					WH_Type[1] = 2;
					//Desync-Maybe
				}
			}
		}*/
		if(PossessedWeapons[playerid][slotid][WH_Ammo] != -1)
			PossessedWeapons[playerid][slotid][WH_Ammo] = PossessedWeapons[playerid][slotid][WH_Ammo] - 1;
	}
    return 1;
}

stock IsNonShootingWeapon(weaponid)
{
	switch(weaponid)
	{
		case 1 .. 15:
		{
			return 1;
		}
		case 37:
		{
			return 1;
		}
		case 39 .. 46:
		{
			return 1;
		}
		default: 
			return 0;
	}
	return 0;
}

//WeaponLockOut
hook OnPlayerUpdate(playerid)
{
	if(WeapFreeze[playerid] != 0)
	{
		SetPlayerArmedWeapon(playerid, 0);
	}
	if(PlayerHeldWeapon[playerid] != GetPlayerWeapon(playerid))
	{
		new weaponid = GetPlayerWeapon(playerid);
		PlayerHeldWeapon[playerid] = weaponid;
		new slotid = GetWeaponSlot(weaponid);
		if(slotid != -1)
		{
			new ammo   = GetPlayerAmmo(playerid);
			PossessedWeapons[playerid][slotid][WH_WeaponScrolled] = true;
			if(IsNonShootingWeapon(weaponid) && weaponid != 40 && weaponid != 46)
			{
				OnPlayerSwitchWeapon(playerid, weaponid, ammo);
			}
		}
	}
	new keys, ud, lr;
	GetPlayerKeys(playerid, keys, ud, lr);
	new wstate, cmode, canim;
	wstate = GetPlayerWeaponState(playerid);
	cmode  = GetPlayerCameraMode(playerid);
	canim  = GetPlayerAnimationIndex(playerid);
	if(NetStats_GetConnectedTime(playerid) - LastRLShot[playerid] > 400)
	{
		if(GetPlayerWeapon(playerid) == 36 || GetPlayerWeapon(playerid) == 35)
		{
			if((wstate == 1 && wstate != 3) && (cmode == 8 || cmode == 51) && canim == 1167)
			{
			    if(keys & KEY_FIRE && keys & KEY_HANDBRAKE)
				{
			        WH_OnPlayerWeaponShot(playerid, GetPlayerWeapon(playerid), 1, 0, 0.0, 0.0, 0.0);
	                LastRLShot[playerid] = NetStats_GetConnectedTime(playerid);
				}
			}
		}
		if(GetPlayerWeapon(playerid) >= 16 && GetPlayerWeapon(playerid) <= 18)
		{
			if((wstate == 1 && wstate != 3) && (cmode == 4) && canim == 644)
			{
			    if(keys & KEY_FIRE)
				{
			        WH_OnPlayerWeaponShot(playerid, GetPlayerWeapon(playerid), 1, 0, 0.0, 0.0, 0.0);
	                LastRLShot[playerid] = NetStats_GetConnectedTime(playerid);
				}
			}
		}
	}
	return 1;
}

CMD:weaponfreeze(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new targetid, option[5];
		if(sscanf(params, "uS(Temp)[4]", targetid, option))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /forcescroll [PlayerID/PlayerName] [Temporary/Permanent]");
		}
		if(IsPlayerConnected(targetid) == 0 || targetid == INVALID_PLAYER_ID)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerID/PlayerName");
		}
		if(!strcmp(option, "temp", true, 3) || !strcmp(option, "perm", true, 3))
		{
			new WEAP_string[128];
		    if(WeapFreeze[targetid] == 0)
		    {
				SetPlayerArmedWeapon(targetid, 0);
				format(WEAP_string, sizeof(WEAP_string), "AdmCmd(1) %s %s has force-frozen %s(%i)'s weapon", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
				if(!strcmp(option, "temp", true, 3))
				{
					format(WEAP_string, sizeof(WEAP_string), "%s Temporarily", WEAP_string);
				    WeapFreeze[targetid] = 1;
				}
				else if(!strcmp(option, "perm", true, 3))
				{
					format(WEAP_string, sizeof(WEAP_string), "%s Permanently", WEAP_string);
				    WeapFreeze[targetid] = 2;
				}
				else
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Type. (Permanent/Temporary)");
			}
			else
			{
				format(WEAP_string, sizeof(WEAP_string), "AdmCmd(1) %s %s has un-frozen %s(%i)'s weapons.", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
                WeapFreeze[targetid] = 0;
			}
			SendAdminMessage(AdminLvl(playerid), WEAP_string);
			AdminLog(WEAP_string);
        	IRC_GroupSay(gLeads,IRC_FOCO_LEADS,WEAP_string);
		}
	}
	return 1;
}

IRCCMD:aweaponfreeze(botid, channel[], user[], host[], params[])
{
	if (IRC_IsHalfop(botid, IRC_FOCO_ADMIN, user))
	{
		new playerid, reason[5];
		if (sscanf(params, "uS(Temp)[4]", playerid, reason))
		{
			IRC_GroupSay(gEcho, channel, "5[USAGE]: !aweaponfreeze [PlayerID/PlayerName] [Type: Temporary/Permanent]");
			return 1;
		}
		if (IsPlayerConnected(playerid))
		{
			if(!strcmp(reason, "temp", true, 3) || !strcmp(reason, "perm", true, 3))
			{
				new WEAP_string[128];
			    if(WeapFreeze[playerid] == 0)
			    {
					SetPlayerArmedWeapon(playerid, 0);
					format(WEAP_string, sizeof(WEAP_string), "AdmCmd(1) IRC_%s has force-frozen %s(%i)'s weapon", user, PlayerName(playerid), playerid);
					if(!strcmp(reason, "temp", true, 3))
					{
						format(WEAP_string, sizeof(WEAP_string), "%s Temporarily", WEAP_string);
						WeapFreeze[playerid]=1;
					}
					else if(!strcmp(reason, "perm", true, 3))
					{
						format(WEAP_string, sizeof(WEAP_string), "%s Permanently", WEAP_string);
						WeapFreeze[playerid]=2;
					}
					else
					{
						IRC_GroupSay(gEcho, channel, "4[ERROR]: Invalid Type. (Permanent/Temporary)");
					}
				}
				else
				{
					format(WEAP_string, sizeof(WEAP_string), "AdmCmd(1) IRC_%s has un-frozen %s(%i)'s weapon.", user, PlayerName(playerid), playerid);
                    WeapFreeze[playerid]=0;
				}
				SendAdminMessage(1, WEAP_string);
				AdminLog(WEAP_string);
        		IRC_GroupSay(gEcho,channel,WEAP_string);
        		IRC_GroupSay(gLeads,IRC_FOCO_LEADS,WEAP_string);
			}
		}
	}
	return 1;
}

CMD:forcescroll(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new targetid, weaponid;
		if(sscanf(params, "uk<weapon>", targetid, weaponid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /forcescroll [PlayerID/PlayerName] [WeaponID/WeaponName]");
		}
		if(IsPlayerConnected(targetid) == 0 || targetid == INVALID_PLAYER_ID)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerID/PlayerName");
		}
		else
		{
			new WEAP_string[128];
			SetPlayerArmedWeapon(targetid, weaponid);
			format(WEAP_string, sizeof(WEAP_string), "AdmCmd(1) %s %s has force scrolled %s(%i)'s weapon to %i.", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid, weaponid);
			SendAdminMessage(AdminLvl(playerid), WEAP_string);
			AdminLog(WEAP_string);
        	IRC_GroupSay(gLeads,IRC_FOCO_LEADS,WEAP_string);
		}
	}
	return 1;
}

CMD:fsg(playerid, params[])
{
	cmd_forcescroll(playerid, params);
	return 1;
}

CMD:adas(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new targetid;
		if(sscanf(params, "uk<weapon>", targetid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /adas [PlayerID/PlayerName]");
		}
		if(IsPlayerConnected(targetid) == 0 || targetid == INVALID_PLAYER_ID)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerID/PlayerName");
		}
		else
		{
		    new wh_weap, wh_ammo;
			new wh_msg[1900] = "WeaponID\tAmmo\tScrolled\tGivenAmmo\n";
			for(new i = 0; i < WEAP_MAX_SLOTS; i++)
			{
			    GetPlayerWeaponData(targetid, i, wh_weap, wh_ammo);
			    if(wh_weap != 0)
			    {
					if(PossessedWeapons[targetid][i][WH_WeaponID] == wh_weap)
					{
					    if(PossessedWeapons[targetid][i][WH_Ammo] == wh_ammo)
					    {
							format(wh_msg, sizeof(wh_msg), "%s{000e6b}%s\t{000e6b}%i\t%s\t{000e6b}%i\n", wh_msg, HWeaponName(wh_weap), wh_ammo,(PossessedWeapons[targetid][i][WH_WeaponScrolled] == true) ? ("{006600}YES") : ("{990033}NO"), PossessedWeapons[targetid][i][WH_Ammo]);
						}
						else if(PossessedWeapons[playerid][i][WH_Ammo] < wh_ammo || wh_ammo < -1 || wh_ammo > 9999)
						{
   							format(wh_msg, sizeof(wh_msg), "%s{ff7e00}%s\t{ff7e00}%i\t%s\t{ff7e00}%i\n", wh_msg, HWeaponName(wh_weap), wh_ammo,(PossessedWeapons[targetid][i][WH_WeaponScrolled] == true) ? ("{006600}YES") : ("{990033}NO"), PossessedWeapons[targetid][i][WH_Ammo]);
						}
						else
						{
							format(wh_msg, sizeof(wh_msg), "%s{00aaff}%s\t{00aaff}%i\t%s\t{00aaff}%i\n", wh_msg, HWeaponName(wh_weap), wh_ammo,(PossessedWeapons[targetid][i][WH_WeaponScrolled] == true) ? ("{006600}YES") : ("{990033}NO"), PossessedWeapons[targetid][i][WH_Ammo]);
						}
					}
					else
					{
						format(wh_msg, sizeof(wh_msg), "%s{ff7e00}%s\t{ff7e00}%i\t%s\t{ff7e00}%i\n", wh_msg, HWeaponName(wh_weap), wh_ammo,(PossessedWeapons[targetid][i][WH_WeaponScrolled] == true) ? ("{006600}YES") : ("{990033}NO"), PossessedWeapons[targetid][i][WH_Ammo]);
					}
				}
			}
			ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_TABLIST_HEADERS, "Advanced Weapon info", wh_msg, "Cancel", "");
		}
	}
	return 1;
}

CMD:advancedas(playerid, params[])
{
	cmd_adas(playerid, params);
	return 1;
}

#if defined PTS
CMD:adcheck(playerid, params[])
{
    new wh_msg[190];
	for(new i=0; i<MAX_SLOTS; i++)
	{
		format(wh_msg, sizeof(wh_msg), "%i. %i - %i", i,  PossessedWeapons[targetid][i][WH_WeaponID], PossessedWeapons[targetid][i][WH_Ammo]);
		DebugMsg(wh_msg);
	}
	return 1;
}
#endif


