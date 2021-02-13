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
* Filename: pEar_DamageViewer.pwn                                                *
* Author: pEar	                                                                 *
*********************************************************************************/

#include <YSI\y_hooks>

#define MAX_PLAYERS_WATCHING_DMG 3

new viewDamage[MAX_PLAYERS][MAX_PLAYERS_WATCHING_DMG];					// Admins that are watching his damage values.
new viewingDamage[MAX_PLAYERS][MAX_PLAYERS_WATCHING_DMG]; 			// Player id who's damage you are viewing

new GivenDamage[MAX_PLAYERS][MAX_PLAYERS_WATCHING_DMG];					// Admins that are watching his damage values.
new GivenDamageID[MAX_PLAYERS][MAX_PLAYERS_WATCHING_DMG];			// Player id who's damage you are viewing

/*
This is called within the actual callback, due to local variables (weapon_damage)
hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid)
{
	takeDamageMath(playerid, issuerid, overall, weaponid, weapon_damage);
	giveDamageMath(playerid, issuerid, overall, weaponid, weapon_damage);
	return 1;
}
*/

CMD:takendamage(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_VIEWDAMAGE))
	{
		new targetid, string[128], pos[2];
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /takendamage [id]");
			return 1;
		}
		for(new i = 0; i < MAX_PLAYERS_WATCHING_DMG; i++)
		{
			if(viewingDamage[playerid][i] == targetid)
			{
				format(string, sizeof(string), "[INFO]: Stopped watching %s's(%d) taken damage values.", PlayerName(viewingDamage[playerid][i]), viewingDamage[playerid][i]);
				SendClientMessage(playerid, COLOR_SYNTAX, string);
				viewingDamage[playerid][i] = -1;
				for(new j = 0; j < MAX_PLAYERS_WATCHING_DMG; j++)
				{
					if(viewDamage[targetid][j] == playerid)
					{
						viewDamage[targetid][j] = -1;
					}
				}
				return 1;
			}
		}
		pos[0] = -1;
		pos[1] = -1;
		for(new i = 0; i < MAX_PLAYERS_WATCHING_DMG; i++)
		{
			if(viewDamage[targetid][i] == -1)
			{
				pos[0] = i;
			}
			if(viewingDamage[playerid][i] == -1)
			{
				pos[1] = i;
			}
		}
		if(pos[0] == -1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This player already has the max amount of players watching his taken damage values.");
		}
		else if(pos[1] == -1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can only watch 3 player's damage at the same time, please use /takendamage [ID] to reset an old.");
		}
		viewingDamage[playerid][pos[1]] = targetid;
		viewDamage[targetid][pos[0]] = playerid;
		format(string, sizeof(string), "[Guardian]: You are now watching the damage that %s(%d) takes.", PlayerName(targetid), targetid);
		SendClientMessage(playerid, COLOR_NOTICE, string);
	}
	return 1;
}

CMD:givendamage(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_VIEWDAMAGE))
	{
		new targetid, string[128], pos[2];
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /givendamage [id]");
			return 1;
		}
		for(new i = 0; i < MAX_PLAYERS_WATCHING_DMG; i++)
		{
			if(GivenDamageID[playerid][i] == targetid)
			{
				format(string, sizeof(string), "[INFO]: Stopped watching %s(%d) given damage values.", PlayerName(GivenDamageID[playerid][i]), GivenDamageID[playerid][i]);
				SendClientMessage(playerid, COLOR_SYNTAX, string);
				GivenDamageID[playerid][i] = -1;
				for(new j = 0; j < MAX_PLAYERS_WATCHING_DMG; j++)
				{
					if(GivenDamage[targetid][j] == playerid)
					{
						GivenDamage[targetid][j] = -1;
					}
				}
				return 1;
			}
		}
		pos[0] = -1;
		pos[1] = -1;
		for(new i = 0; i < MAX_PLAYERS_WATCHING_DMG; i++)
		{
			if(GivenDamage[targetid][i] == -1)
			{
				pos[0] = i;
			}
			if(GivenDamageID[playerid][i] == -1)
			{
				pos[1] = i;
			}
		}
		if(pos[0] == -1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This player already has the max amount of players watching his given damage values.");
		}
		else if(pos[1] == -1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can only watch 3 player's damage at the same time, please use /givendamage [ID] to reset an old.");
		}
		GivenDamageID[playerid][pos[1]] = targetid;
		GivenDamage[targetid][pos[0]] = playerid;
		format(string, sizeof(string), "[Guardian]: You are now watching the damage that %s(%d)'s deals to others.", PlayerName(targetid), targetid);
		SendClientMessage(playerid, COLOR_NOTICE, string);
	}
	return 1;
}

hook OnGameModeInit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		for(new j = 0; j < MAX_PLAYERS_WATCHING_DMG; j++)
		{
			viewDamage[i][j] = -1;
			GivenDamage[i][j] = -1;
			viewingDamage[i][j] = -1;
			GivenDamageID[i][j] = -1;
		}
	}
	return 1;
}



hook OnPlayerDisconnect(playerid, reason)
{
    //DebugMsg("DV_BG");
	new string[128];
	for(new i = 0; i < MAX_PLAYERS_WATCHING_DMG; i++)
	{
		for(new j = 0; j < MAX_PLAYERS_WATCHING_DMG; j++)
		{
			if(viewDamage[playerid][i] != -1)
			{
				if(viewingDamage[viewDamage[playerid][i]][j] == playerid)
				{
					format(string, sizeof(string), "[INFO]: %s(%d) has logged off and you are no longer watching his taken damage values.", PlayerName(playerid), playerid);
					SendClientMessage(viewDamage[playerid][i], COLOR_SYNTAX, string);
					// Resetting the values for the admin spectating.
					viewingDamage[viewDamage[playerid][i]][j] = -1;
				}	
			}
			if(GivenDamage[playerid][i] != -1)
			{
				if(GivenDamageID[GivenDamage[playerid][i]][j] == playerid)
				{
					format(string, sizeof(string), "[INFO]: %s(%d) has logged off and you are no longer watching his given damage values.", PlayerName(playerid), playerid);
					SendClientMessage(viewDamage[playerid][i], COLOR_SYNTAX, string);
					// Resetting the values for the admin spectating.
					GivenDamageID[GivenDamage[playerid][i]][j] = -1;
				}	
			}
		}
	}

	for(new i = 0; i < MAX_PLAYERS_WATCHING_DMG; i++)
	{
		if(viewingDamage[playerid][i] != -1)
		{
		    for(new j=0; j<MAX_PLAYERS_WATCHING_DMG; j++)
		    {
		        if(viewDamage[viewingDamage[playerid][i]][j] == playerid)
		            viewDamage[viewingDamage[playerid][i]][j] = -1;
		    }
		}
		if(GivenDamageID[playerid][i] != -1)
		{
		    for(new j=0; j<MAX_PLAYERS_WATCHING_DMG; j++)
		    {
		        if(GivenDamage[GivenDamageID[playerid][i]][j] == playerid)
		            GivenDamage[GivenDamageID[playerid][i]][j] = -1;
		    }
		}
		viewDamage[playerid][i] = -1;
		GivenDamageID[playerid][i] = -1;
		viewingDamage[playerid][i] = -1;
		GivenDamage[playerid][i] = -1;
	}
	//DebugMsg("CW_Done");
	return 1;
}

forward takeDamageMath(playerid, issuerid, Float:amount, weaponid, Float:addDam);
public takeDamageMath(playerid, issuerid, Float:amount, weaponid, Float:addDam)
{	
	if(issuerid != INVALID_PLAYER_ID)
	{
		new Float:health, Float:armour, Float:fromHealth, Float:fromArmour;
	
		GetPlayerHealth(playerid, health);
		GetPlayerArmour(playerid, armour);

		fromArmour = armour - amount;
		if(fromArmour < 0.0)
		{
			fromHealth = health + fromArmour;
			SetPlayerArmour(playerid, 0.0);
			SetPlayerHealth(playerid, fromHealth);
		}
		else 
		{
			SetPlayerArmour(playerid, fromArmour);
		}

		new str[250];

		for(new i = 0; i < MAX_PLAYERS_WATCHING_DMG; i++)
		{
			if(viewDamage[playerid][i] != -1 && viewDamage[playerid][i] != INVALID_PLAYER_ID && weaponid != 0 && weaponid != 37)
			{
				if(AdminLvl(viewDamage[playerid][i]) < 1)
				{
					return 1;
				}
				if(issuerid == INVALID_PLAYER_ID)
				{
					format(str, sizeof(str), "[Guardian]: %s has taken %f damage, possibly from falling from a height or dying (Wont show player..)", PlayerName(playerid), amount);
					SendClientMessage(viewDamage[playerid][i], COLOR_WHITE, str);
				}
				else
				{
					format(str, sizeof(str), "[Guardian]: %s has taken %f damage from %s(%d) using a %s", PlayerName(playerid), amount, PlayerName(issuerid), issuerid, WeapNames[weaponid]);
					SendClientMessage(viewDamage[playerid][i], COLOR_WHITE, str);
				}
			}
		}
	}
	return 1;
}

forward giveDamageMath(playerid, issuerid, Float:amount, weaponid, Float:addDam);
public giveDamageMath(playerid, issuerid, Float:amount, weaponid, Float:addDam)
{
	if(issuerid != INVALID_PLAYER_ID)
	{
	    new Float:health, Float:armour, Float:fromHealth, Float:fromArmour;

		GetPlayerHealth(playerid, health);
		GetPlayerArmour(playerid, armour);

		fromArmour = armour - amount;
		if(fromArmour < 0.0)
		{
			fromHealth = health + fromArmour;
			SetPlayerArmour(playerid, 0.0);
			SetPlayerHealth(playerid, fromHealth);
		}
		else
		{
			SetPlayerArmour(playerid, fromArmour);
		}
		new str[250];
		for(new i = 0; i < MAX_PLAYERS_WATCHING_DMG; i++)
		{
			if(GivenDamage[issuerid][i] != -1 && GivenDamage[issuerid][i] != INVALID_PLAYER_ID && weaponid != 0 && weaponid != 37)
			{
				if(AdminLvl(GivenDamage[issuerid][i]) < 1)
				{
					return 1;
				}
				if(playerid == INVALID_PLAYER_ID)
				{
					format(str, sizeof(str), "[Guardian]: %s has given %f damage, but not to a player(?..)", PlayerName(issuerid), amount);
					SendClientMessage(GivenDamage[issuerid][i], COLOR_WHITE, str);
				}
				else
				{
					format(str, sizeof(str), "[Guardian]: %s has given %f damage to %s(%d) using a %s", PlayerName(issuerid), amount, PlayerName(playerid), playerid, WeapNames[weaponid]);
					SendClientMessage(GivenDamage[issuerid][i], COLOR_WHITE, str);
				}
			}
		}
	}
	return 1;
}

#if defined PTS
CMD:givendamagep(playerid, params[])
{
	new targetid;
	if(!sscanf(params, "u", targetid))
	{
		new string[128];
		for(new i = 0; i < MAX_PLAYERS_WATCHING_DMG; i++)
		{
			format(string, sizeof(string), "[%d PLAYER]: %s(%d) is having his given damage watched by ID: %d", i, PlayerName(targetid), targetid, GivenDamage[playerid][i]);
			DebugMsg(string);
		}
	}
	return 1;
}

CMD:givendamagea(playerid, params[])
{
	new targetid;
	if(!sscanf(params, "u", targetid))
	{
		new string[128];
		for(new i = 0; i < MAX_PLAYERS_WATCHING_DMG; i++)
		{
			format(string, sizeof(string), "[%d ADMIN]: %s(%d) is watching given damage for ID: %d", i, PlayerName(targetid), targetid, GivenDamageID[targetid][i]);
			DebugMsg(string);
		}
	}
	return 1;
}

CMD:takendamagep(playerid, params[])
{
	new targetid;
	if(!sscanf(params, "u", targetid))
	{
		new string[128];
		for(new i = 0; i < MAX_PLAYERS_WATCHING_DMG; i++)
		{
			format(string, sizeof(string), "[%d PLAYER]: %s(%d) is having his taken damage watched by ID: %d", i, PlayerName(targetid), targetid, viewDamage[playerid][i]);
			DebugMsg(string);
		}
	}
	return 1;
}

CMD:takendamagea(playerid, params[])
{
	new targetid;
	if(!sscanf(params, "u", targetid))
	{
		new string[128];
		for(new i = 0; i < MAX_PLAYERS_WATCHING_DMG; i++)
		{
			format(string, sizeof(string), "[%d ADMIN]: %s(%d) is watching taken damage for ID: %d", i, PlayerName(targetid), targetid, viewingDamage[targetid][i]);
			DebugMsg(string);
		}
	}
	return 1;
}
#endif
