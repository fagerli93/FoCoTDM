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
* Filename: chilco_antispawnkill. pwn                                            *
* Author: Chilco                                                                 *
*********************************************************************************/

/* What actually needs to be done:
The teams to be directly loaded from the database instead of from this script. As well a copy of the edit area cmd of the turfwar system to change the spawn areas (which also need
to be stored on the database. The idea is to make it fully dynamic so no server restarts are necessary when editing teams.

< Dr_Death agrees! */

/* Callbacks:
-	public Dev_Chilco_ASP_OnPlayerDeath(playerid, killerid, reason)
-   public Dev_Chilco_ASP_OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
-   public Dev_Chilco_ASP_OnPlayerUpdate(playerid)
*/

forward SpawnkillWarning_Cooldown(playerid);
public SpawnkillWarning_Cooldown(playerid)
{
    SetPVarInt(playerid, "Spawnkillwarning_Cooldown", 0);
    return 1;
}


new SpawnArea_Team[][] = // ID, Name
{
	{1, "SWAT"},
	{2, "Hobos"}, 
	{3, "Medics"},
	{4, "Mobsters"},
	{5, "Gangsters"},
	{6, "We Run This!"},
	{16, "Trained To Go Hard"},
	{22, "Triads"},
	{24, "Pornstars"},
	{28, "Retired from Death"},
	{34, "Guerilla Squad"},
	{35, "Lethal Projectiles"}


};

new Float:SpawnArea_XY_XY[][] = // Smallest XY, Highest XY
{
	{1540.3042, -1721.4354, 1606.0471, 1603.7964},
	{2189.3396,-2088.3132, 2262.0718,-2040.9364},
	{1997.1732,-1450.8978, 2051.6951,-1399.5000},
	{1496.0947, -1212.9569, 1573.8689, -1172.0610},
	{1659.9656,-2135.3123, 1745.7043,-2089.6516},
	{2248.9099,-2034.6371, 2311.3389,-2011.3143},
	{2720.8315, -2482.1807, 2773.8337, -2395.2261},
	{1202.3545, -1842.8379, 1264.2643,-1792.6571},
	{859.9456,-1274.7009, 918.6884,-1210.4415},
	{1213.5004,-1677.1952, 1302.2145,-1629.2673},
	{2424.0708,-2145.0862, 2472.8955,-2077.7356},
	{2458.3840,-1690.4563, 2524.0693,-1647.8815},
	{0.0, 0.0, 0.0,0.0}


};

public Dev_Chilco_ASP_OnPlayerDeath(playerid, killerid, reason)
{
    SetPVarInt(playerid, "Spawnkillwarning_Cooldown", 0);
    SetPVarInt(playerid, "SpawnArea", 0);
    return 1;
}

public Dev_Chilco_ASP_OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
	if(GetPVarInt(playerid, "SpawnArea") == FoCo_Team[playerid]) // If player is in the spawn area of his own team.
	{
	    if(FoCo_Team[issuerid] != FoCo_Team[playerid]) // No teamkilling.
	    {
	        if(GetPVarInt(playerid, "SpawnkillInvulnerable") == 1)
	        {
	            if(GetPVarInt(playerid, "Spawnkillwarning_Cooldown") == 0)
	            {

		            new pName[MAX_PLAYER_NAME], iName[MAX_PLAYER_NAME];
		            GetPlayerName(playerid, pName, sizeof(pName));
		            GetPlayerName(issuerid, iName, sizeof(iName));

		            new string[160];
		            format(string,sizeof(string),"[Guardian]: {ff6347}%s (ID: %d) is possibly spawnkilling %s.", iName, issuerid, pName);
		            SendClientMessageToAll(0xFFFF00FF,string);
		            for(new d=0; d<sizeof(SpawnArea_Team); d++)
					{
					    if(FoCo_Team[playerid] == SpawnArea_Team[d][0])
					    {
		            		format(string,sizeof(string),"You are spawnkilling, stop it! You're shooting someone who is part of %s.", SpawnArea_Team[d][1]);
		            		SendClientMessage(issuerid, 0xFF6347FF,string);
		            	}
		            }
		            SetPVarInt(playerid, "Spawnkillwarning_Cooldown", 1);
		            SetTimerEx("SpawnkillWarning_Cooldown", 20000, false, "d", playerid);
		            return 1;
	            }
	        }

	    }

	}
	return 1;
}

public Dev_Chilco_ASP_OnPlayerUpdate(playerid)
{
	new Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid, X,Y,Z);
	for(new d=0; d<sizeof(SpawnArea_Team); d++)
	{
	    if(GetPVarInt(playerid, "SpawnArea") > 0)
		{
		    if(SpawnArea_Team[d][0] == GetPVarInt(playerid, "SpawnArea"))
		    {
			    if(X >=  SpawnArea_XY_XY[d][0] && X <= SpawnArea_XY_XY[d][2] && Y >= SpawnArea_XY_XY[d][1] && Y <= SpawnArea_XY_XY[d][3])
				{
			 		return 1;
				}
				else
				{
					SetPVarInt(playerid, "SpawnArea", 0);
					if(GetPVarInt(playerid, "SpawnkillInvulnerable") == 1 && FoCo_Team[playerid] == SpawnArea_Team[d][0])
					{
					    SetPVarInt(playerid, "SpawnkillInvulnerable", 0);
					}
					return 1;

				}
			}
		}
		if(X >=  SpawnArea_XY_XY[d][0] && X <= SpawnArea_XY_XY[d][2] && Y >= SpawnArea_XY_XY[d][1] && Y <= SpawnArea_XY_XY[d][3])
		{
		    if(GetPVarInt(playerid, "SpawnArea") == 0)
			{
			    SetPVarInt(playerid, "SpawnArea", SpawnArea_Team[d][0]);
		    }
		}
	}
	return 1;
}
