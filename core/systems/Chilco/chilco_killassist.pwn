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
* Filename: chilco_killassist. pwn                                               *
* Author: Chilco                                                                 *
*********************************************************************************/

/* NOTE TO FKU:
Make it so the assist 'expires' when the target heals in any possible way'


TBA: Give $150 and +1 kill assist in stats!

-----------------------------------------------------------*/

/* Callbacks used:
- public Dev_Chilco_KA_OnPlayerConnect(playerid)
- public Dev_Chilco_KA_OPTD(playerid, issuerid, Float: amount, weaponid)
- public Dev_Chilco_KA_OnPlayerDeath(playerid, killerid, reason)
*/
#include <YSI\y_hooks>
new Float:TakenDamage[MAX_PLAYERS][MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    foreach(Player,i)
	{
	    TakenDamage[playerid][i] = 0.0;
	}

	return 1;
}

hook OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
	TakenDamage[playerid][issuerid] = TakenDamage[playerid][issuerid]+amount;
	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	foreach(Player,i)
	{
	    if(i != killerid)
	    {
			if(FoCo_Team[i] != FoCo_Team[playerid])
			{
				if(TakenDamage[playerid][i] >= 45.0)
				{
					GameTextForPlayer(i, "~r~Kill Assist", 3000, 6);
					// TBA: Give $150 and +1 kill assist in stats.
				}
			}
	    }
	    TakenDamage[playerid][i] = 0.0;
	}
	return 1;
}
	

