#include <YSI\y_hooks>

#define PICKUP_ARMOUR 43
#define	PICKUP_REMOVAL_TIME	45000
#define MAX_WEAPONIDS 44

enum DW_Details
{
	dw_wid,
	dw_ammo,
	Float:dw_Pos[3],
	dw_pickupid,
	Timer:dw_TimerID,
	bool:dw_armour,
	bool:IsValid
};

new WeaponObjectIDs[MAX_WEAPONIDS] =
{	
	0, 331,333,334,335,336,337,338,339,341,321,322,323,324,
	325,326,342,343,344,0,0,0,346,347,348,349,350,351,352,
	353,355,356,372,357,358,359,360,361,362,363,0,365,366,373
};							

new DWP_Pickup[MAX_PLAYERS][DW_Details];

stock IsInvalidDropWeapon(weaponid)
{
	switch(weaponid)
	{
		case 1 .. 18:
			return 0;
		case 22 .. 39:
			return 0;
		case 41, 42:
			return 0;
		default:
			return 1;
	}
	return 1;
}

stock MaximumAmmo(weaponid)
{
	switch(weaponid)
	{
	    case 1 .. 18:
	        return 1;
		case 22 .. 32:
		    return 100;
		case 33, 34:
		    return 5;
		case 35, 36, 39:
		    return 1;
		case 38, 37, 41, 42:
		    return 100;
		default:
		    return 0;
	}
	return 0;
}

stock IsValidPlace(playerid)
{
	switch(GetPlayerVirtualWorld(playerid))
	{
		case 0:
		{
		
		}
		default:
		{
			return 0;
		}
	}
	switch(GetPlayerInterior(playerid))
	{
		case 0:
		{
		
		}
		default:
		{
			return 0;
		}
	}
	return 1;
}

timer DWT_DeletePlayerPickup[PICKUP_REMOVAL_TIME](playerid)
{
	if(IsValidDynamicPickup(DWP_Pickup[playerid][dw_pickupid]))
	{
		DestroyDynamicPickup(DWP_Pickup[playerid][dw_pickupid]);
	}
	DWP_Pickup[playerid][dw_pickupid] = -1;
	DWP_Pickup[playerid][dw_TimerID] = Timer:-1;
	DWP_Pickup[playerid][dw_wid] = 0;
	DWP_Pickup[playerid][dw_ammo] = 0;
	DWP_Pickup[playerid][dw_Pos][0] = 0.0;
	DWP_Pickup[playerid][dw_Pos][1] = 0.0;
	DWP_Pickup[playerid][dw_Pos][2] = 0.0;
	DWP_Pickup[playerid][IsValid] = false;
}

stock CreatPlayerPickup(playerid)
{
	if(playerid != INVALID_PLAYER_ID)
	{
	    //DebugMsg("Not Invalid");
		if(IsPlayerConnected(playerid))
		{
		    //DebugMsg("Connected");
			if(IsValidPlace(playerid))
			{
			    //DebugMsg("ValidPlace");
			    //Test Purpose
			    PlayerHeldWeapon[playerid] = GetPlayerWeapon(playerid);
				new DropWeapon = PlayerHeldWeapon[playerid];
				if(IsInvalidDropWeapon(DropWeapon))
					return 1;
				new DropAmmo = 100; //PossessedWeapons[playerid][GetWeaponSlot(DropWeapon)][WH_Ammo];
                //DebugMsg("Weapon Valid");
				if(DropAmmo < 1)
				{
					return 1;
				}
				else
				{
				    //DebugMsg("Else");
					if(DWP_Pickup[playerid][IsValid] == true)
					{	
						stop DWP_Pickup[playerid][dw_TimerID];
						DWT_DeletePlayerPickup(playerid);
					}
					if(WeaponObjectIDs[DropWeapon] != 0)
					{
						new Float:Ob_Pos[3];
						GetPlayerPos(playerid, Ob_Pos[0], Ob_Pos[1], Ob_Pos[2]);
					 	DWP_Pickup[playerid][dw_pickupid] = CreateDynamicPickup(WeaponObjectIDs[DropWeapon], 3, Ob_Pos[0], Ob_Pos[1], Ob_Pos[2], 0);
						DWP_Pickup[playerid][dw_wid] = DropWeapon;
						new TempAmmo = MaximumAmmo(DropWeapon);
						if(DropAmmo <= TempAmmo)
						{
							DWP_Pickup[playerid][dw_ammo] = DropAmmo;
						}
						else
						{
						    DWP_Pickup[playerid][dw_ammo] = TempAmmo;
						}
						DWP_Pickup[playerid][dw_Pos][0] = Ob_Pos[0];
						DWP_Pickup[playerid][dw_Pos][1] = Ob_Pos[1];
						DWP_Pickup[playerid][dw_Pos][2] = Ob_Pos[2];
						DWP_Pickup[playerid][IsValid] = true;
						if(FoCo_Player[playerid][level] >= 7)
						{
							DWP_Pickup[playerid][dw_armour] = true;
						}
						if(DWP_Pickup[playerid][dw_TimerID] != Timer:-1)
						{
							stop DWP_Pickup[playerid][dw_TimerID];
							DWP_Pickup[playerid][dw_TimerID] = Timer:-1;
						}
						//DebugMsg("Created");
						DWP_Pickup[playerid][dw_TimerID] = defer DWT_DeletePlayerPickup(playerid);
					}
				}
			}
		}
	}
	return 1;
}


stock GetPickupDropper(pickupid)
{
	foreach(Player, i)
	{
		if(DWP_Pickup[i][IsValid] == true)
		{
			if(DWP_Pickup[i][dw_pickupid] == pickupid)
			{
			    return i;
			}
		}
	}
	return -1;
}


hook OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    //DebugMsg("Chang1e");
	if(IsValidPlace(playerid))
	{
		new targetid = GetPickupDropper(pickupid);
		if(targetid == -1)
			return 1;
		else
		{
			new tempwid, tempammo;
			tempwid = DWP_Pickup[targetid][dw_wid];
			tempammo = DWP_Pickup[targetid][dw_ammo];
			new debugmfmsg[128];
			format(debugmfmsg, sizeof(debugmfmsg), "%s: Got %i | Giving %i | Should have %i", PlayerName(playerid), PossessedWeapons[playerid][GetWeaponSlot(tempwid)][WH_Ammo], tempammo, PossessedWeapons[playerid][GetWeaponSlot(tempwid)][WH_Ammo] + tempammo);
			DebugMsg(debugmfmsg);
			if(FoCo_Player[playerid][level] < 7)
			{
				if(DWP_Pickup[targetid][dw_armour] == true)
				{
					AddToPlayerHealth(playerid, 10.0);
				}
			}
			if(!IsInvalidDropWeapon(tempwid))
			{
				GivePlayerWeapon(playerid, tempwid, tempammo);
			}
			stop DWP_Pickup[targetid][dw_TimerID];
			DWT_DeletePlayerPickup(targetid);
		}
	}
	return 1;
}

hook OnPlayerConnect(playerid)
{
    DWT_DeletePlayerPickup(playerid);
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
    DWT_DeletePlayerPickup(playerid);
	return 1;
}

hook OnFilterScriptInit()
{
	for(new i = 0; i < MAX_PLAYERS;  i++)
	{
	    DWT_DeletePlayerPickup(i);
	}
	return 1;
}

/*hook OnPlayerDeath(playerid, killerid, reason)
{
    
	return 1;
}*/

