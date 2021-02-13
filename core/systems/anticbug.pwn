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
* Filename:  anticbug.pwn                                                        *
* Author:  	 dr_vista       													 *
* Credits:   Whitetiger (original script)                                        *
*********************************************************************************/

/* Includes */

#include <YSI\y_hooks>

/* Defines */

#define MAX_SLOTS 48

//new LastCSTime[MAX_PLAYERS];
new bool:PlayerCrouched[MAX_PLAYERS];

/* Variables */

static  NotMoving[MAX_PLAYERS],
		CBUG_WeaponID[MAX_PLAYERS],
		CheckCrouch[MAX_PLAYERS],
		Ammo[MAX_PLAYERS][MAX_SLOTS],
		CBugCoolDown[MAX_PLAYERS] = 0,
		CBugWarn[MAX_PLAYERS] = 0,
		Timer:cbugtimer,
		bool:nocbugenabled = false;
		

/* Forwards */

forward OnPlayerCBug(playerid);
forward OnPlayerCShootC(playerid);
/* Callbacks */

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(nocbugenabled && GetPVarInt(playerid, "PlayerStatus") != 2)
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			/*if(PlayerCrouched[playerid] == true)
			{
				if(((newkeys & KEY_JUMP || newkeys & KEY_SPRINT) && (GetPlayerWeapon(playerid) != 34 && GetPlayerWeapon(playerid) !=  43)) || newkeys & KEY_CROUCH)
				{
					if(NetStats_GetConnectedTime(playerid) - LastCSTime[playerid] < 2500)
					{
						OnPlayerCShootC(playerid);
					}
					PlayerCrouched[playerid] = false;
					LastCSTime[playerid] = NetStats_GetConnectedTime(playerid);
				}
			}
			else
			{
			    if(newkeys & KEY_FIRE || newkeys & KEY_HANDBRAKE)
			    {
					if(newkeys & KEY_CROUCH && !(oldkeys & KEY_SPRINT))
					{
						if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK)
						{
						    PlayerCrouched[playerid] = true;
						}
						if(NetStats_GetConnectedTime(playerid) - LastCSTime[playerid] < 2500)
						{
						    OnPlayerCShootC(playerid);
						}
						LastCSTime[playerid] = NetStats_GetConnectedTime(playerid);
					}
				}
			}*/
			if((newkeys & KEY_FIRE) && (oldkeys & KEY_CROUCH) && !((oldkeys & KEY_FIRE) || (newkeys & KEY_HANDBRAKE)) || (oldkeys & KEY_FIRE) && (newkeys & KEY_CROUCH) && !((newkeys & KEY_FIRE) || (newkeys & KEY_HANDBRAKE)) ) 
			{
				switch(GetPlayerWeapon(playerid)) 
				{
					case 23..25, 27, 29..34, 41: 
					{
						if(Ammo[playerid][GetPlayerWeapon(playerid)] > GetPlayerAmmo(playerid)) 
						{
							OnPlayerCBug(playerid);
						}
					}
				}
			}

			if(CheckCrouch[playerid] == 1) 
			{
				switch(CBUG_WeaponID[playerid]) 
				{
					case 23..25, 27, 29..34, 41: {
						if((newkeys & KEY_CROUCH) && !((newkeys & KEY_FIRE) || (newkeys & KEY_HANDBRAKE)) && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK ) 
						{
						    if(GetPlayerWeapon(playerid) != -1)
						    {
								if(Ammo[playerid][GetPlayerWeapon(playerid)] > GetPlayerAmmo(playerid))
								{
									OnPlayerCBug(playerid);
								}
							}
						}
					}
				}
			}

			else if(((newkeys & KEY_FIRE) && (newkeys & KEY_HANDBRAKE) && !((newkeys & KEY_SPRINT) 
			|| (newkeys & KEY_JUMP))) ||	(newkeys & KEY_FIRE) && !((newkeys & KEY_SPRINT) || (newkeys & KEY_JUMP)) || 	(NotMoving[playerid] && (newkeys & KEY_FIRE) && (newkeys & KEY_HANDBRAKE)) || (NotMoving[playerid] && (newkeys & KEY_FIRE)) ||	(newkeys & KEY_FIRE) && (oldkeys & KEY_CROUCH) && !((oldkeys & KEY_FIRE) || (newkeys & KEY_HANDBRAKE)) || (oldkeys & KEY_FIRE) && (newkeys & KEY_CROUCH) && !((newkeys & KEY_FIRE) || (newkeys & KEY_HANDBRAKE)) ) 
			{ 
				defer CrouchCheck(playerid);
				CheckCrouch[playerid] = 1;
				CBUG_WeaponID[playerid] = GetPlayerWeapon(playerid);
				Ammo[playerid][GetPlayerWeapon(playerid)] = GetPlayerAmmo(playerid);
			}
   		}
	}
}


hook OnPlayerConnect(playerid)
{
	CBugCoolDown[playerid] = 0;
	CBugWarn[playerid] = 0;
	PlayerCrouched[playerid] = false;
	return 1;
}

hook OnPlayerSpawn(playerid)
{
	PlayerCrouched[playerid] = false;
	return 1;
}

hook OnGameModeInit()
{
	nocbugenabled = true;
	cbugtimer = repeat CBugCheck();
	print("[INFO]: Anti c-bug has been enabled");
	return 1;
}

/* Functions */

public OnPlayerCShootC(playerid)
{
	if(AdminsOnline() <= 0)
	{
		if(GetPVarInt(playerid, "PlayerStatus") != 2)
		{
			SetPlayerArmedWeapon(playerid, 0);
			PlayerCrouched[playerid] = false;
			GameTextForPlayer(playerid, "~r~Do not ~w~C-Bug.",3000,5);
		}
	}
	return 1;
}

static OnPlayerCBug(playerid) 
{
	if(AdminsOnline() > 0)
	{
		if(gettime() >= CBugCoolDown[playerid] && ++CBugWarn[playerid] > 2)
		{
			new reasonstr[75];
			format(reasonstr, sizeof(reasonstr), "[AntiCheat]: {%06x}%s (%d) is possibly C-Bugging.", COLOR_RED >>> 8, PlayerName(playerid), playerid);
			SendAdminMessage(1, reasonstr);
			CBugCoolDown[playerid] = gettime() + 10;
			CBugWarn[playerid] = 0;
		}
	}
	
	else
	{	
	    OnPlayerCShootC(playerid);
		if(!IsPlayerInAnyVehicle(playerid))
		{
			if(++CBugWarn[playerid] > 10)
			{
				new string[128];
				CBugWarn[playerid] = 0;

				format(string, sizeof(string), "[Guardian]: Kicked %s(%d), Reason: Excessive C-bugging.", PlayerName(playerid), playerid);
				SendClientMessageToAll(COLOR_GLOBALNOTICE, string);

				format(string, sizeof(string), "[Guardian]: %s you have been kicked by the anticheat for C-Bugging.", PlayerName(playerid));
				SendClientMessage(playerid, COLOR_NOTICE, string);
				Kick(playerid);
			}
		}
	}
	
	return 1;
}

CMD:anticbug(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_ANTICBUG))
	{
		if(nocbugenabled)
		{
			static
					string[128];
					
			nocbugenabled = false;
			SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: Anti c-bug has been disabled");
			format(string, sizeof(string), "AdmCmd(%d): %s %s has disabled the anti c-bug script.", ACMD_ANTICBUG, GetPlayerStatus(playerid), PlayerName(playerid));
			SendAdminMessage(ACMD_ANTICBUG, string);
			stop cbugtimer;
		}
		
		else
		{
			static
					string[128];
					
			nocbugenabled = true;
			SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: Anti c-bug has been enabled");
			format(string, sizeof(string), "AdmCmd(%d): %s %s has enabled the anti c-bug script.", ACMD_ANTICBUG, GetPlayerStatus(playerid), PlayerName(playerid));
			SendAdminMessage(ACMD_ANTICBUG, string);
			cbugtimer = repeat CBugCheck();
		}
	}
	
	return 1;
}

timer CrouchCheck[3000](playerid)
{
	CheckCrouch[playerid] = 0;
		
	return 1;
}

timer CBugCheck[50]()
{
	foreach(new playerid : Player)
	{
		if(GetPVarInt(playerid, "PlayerStatus") != 2)
		{
			new Keys, ud, lr;
			GetPlayerKeys(playerid, Keys, ud, lr);
			
			if(CheckCrouch[playerid] == 1) 
			{
				switch(CBUG_WeaponID[playerid]) 
				{
					case 23..25, 27, 29..34, 41: 
					{				
						if((Keys & KEY_CROUCH) && !((Keys & KEY_FIRE) || (Keys & KEY_HANDBRAKE)) && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK ) 
						{
							if(Ammo[playerid][GetPlayerWeapon(playerid)] > GetPlayerAmmo(playerid))
							{
								OnPlayerCBug(playerid);
							}
						}
					}
				}
			}

			if(!ud && !lr) 
			{
				NotMoving[playerid] = 1; /*OnPlayerKeyStateChange(playerid, Keys, 0);*/ 
			}
			
			else 
			{
				NotMoving[playerid] = 0; /*OnPlayerKeyStateChange(playerid, Keys, 0);*/ 
			}
		}
	}
}
