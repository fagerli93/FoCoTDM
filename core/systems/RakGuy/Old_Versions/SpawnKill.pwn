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
* Filename: spawnkill.pwn                                                        *
* Author:  RakGuy                                                                *
*********************************************************************************/
#include <YSI\y_areas>
#include <YSI\y_hooks>

#define SpawnKill_Radius 100.0
#define ADMCMD_AREAS 4
#define ADMCMD_SK 1

new SpawnKill_MSG[100];
new bool:AtSpawn[MAX_PLAYERS];

new TeamAreaID[MAX_TEAMS];

stock GetTeamArea(areaid)
{
	for(new i=0;i<MAX_TEAMS;i++)
	{
	    if(TeamAreaID[i]==areaid)
	    {
	        return i;
	    }
	}
	return 1;
}
hook OnPlayerSpawn(playerid)
{
    AtSpawn[playerid]=true;
	return 1;
}

hook OnGameModeInit()
{
	for(new i = 0; i<MAX_TEAMS; i++)
	{
		if(FoCo_Teams[i][team_type] != 0)
		{
		    TeamAreaID[i]=Area_AddSphere(FoCo_Teams[i][team_spawn_x],FoCo_Teams[i][team_spawn_y], FoCo_Teams[i][team_spawn_z],SpawnKill_Radius);
		    format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "AreaCreated: %i TeamID: %i", TeamAreaID[i], i);
			SendAdminMessage(ADMCMD_AREAS, SpawnKill_MSG);
		    Area_SetAllWorlds(TeamAreaID[i], false);
  			Area_SetWorld(TeamAreaID[i], 0, true);
		}
		else if(i==0)
		{
			//Area for Bug FIXING, please dont edit.
            TeamAreaID[i]=Area_AddSphere(0.0,0.0,10000.0,0.0);
		    format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "AreaCreated: %i TeamID: %i", TeamAreaID[i], i);
		    SendAdminMessage(ADMCMD_AREAS, SpawnKill_MSG);
		    Area_SetAllWorlds(TeamAreaID[i], false);
  			Area_SetWorld(TeamAreaID[i], 200, true);
		}
		else
		{
			TeamAreaID[i]=-1;
		}
	}
	return 1;
}


public OnPlayerEnterArea(playerid, areaid)
{
	if(areaid!=TeamAreaID[FoCo_Team[playerid]]&&(IsPlayerInAnyVehicle(playerid)==0||GetPlayerVehicleSeat(playerid)!=0)&&GetPVarInt(playerid, "PlayerStatus") == 0)
	{
	    format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "[Guardian:] %s has entered a spawn[Area TeamID: %i]", PlayerName(playerid),GetTeamArea(areaid));
	    IRC_GroupSay(gEcho, IRC_FOCO_ECHO, SpawnKill_MSG);
	    AdminLog(SpawnKill_MSG);
	    
	}
	return 1;
}
public OnPlayerLeaveArea(playerid, areaid)
{
	
	if(areaid==TeamAreaID[FoCo_Team[playerid]]&&AtSpawn[playerid]==true&&GetPVarInt(playerid, "PlayerStatus") == 0)
	{
	    format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "[Guardian:] %s has left his spawn place[Area TeamID: %i]", PlayerName(playerid),FoCo_Team[playerid]);
	    IRC_GroupSay(gEcho, IRC_FOCO_ECHO, SpawnKill_MSG);
	    AdminLog(SpawnKill_MSG);
	    AtSpawn[playerid]=false;
	}
	else if(areaid!=TeamAreaID[FoCo_Team[playerid]])
	{
	    format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "[Guardian:] %s has left the spawn.[Area TeamID: %i]", PlayerName(playerid),GetTeamArea(areaid));
	    IRC_GroupSay(gEcho, IRC_FOCO_ECHO, SpawnKill_MSG);
	    AdminLog(SpawnKill_MSG);

	}
	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
   	if(AtSpawn[playerid]==true&&killerid!=INVALID_PLAYER_ID&&FoCo_Team[playerid]!=FoCo_Team[killerid])
	{
	    format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "[Guardian]: %s has been spawnkilled by %s", PlayerName(playerid),PlayerName(killerid));
        SendAdminMessage(ADMCMD_SK,SpawnKill_MSG);
   	    IRC_GroupSay(gEcho, IRC_FOCO_ECHO, SpawnKill_MSG);
	    AdminLog(SpawnKill_MSG);
	}
	if(AtSpawn[killerid]==true&&FoCo_Team[playerid]!=FoCo_Team[killerid]&&killerid!=INVALID_PLAYER_ID)
	{
	    for (new i, areaid; (areaid = Area_GetPlayerAreas(playerid, i)) != NO_AREA; ++i)
		{
		    if(areaid!=TeamAreaID[FoCo_Team[playerid]])
		    {
		        format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "[Guardian:] %s has been killed while being at spawn of %s[Victim Team ID: %i]", PlayerName(playerid),PlayerName(killerid),FoCo_Team[killerid]);
				SendAdminMessage(ADMCMD_SK,SpawnKill_MSG);
			}
		}
	}
	return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid)
{
	for (new i, areaid; (areaid = Area_GetPlayerAreas(playerid, i)) != NO_AREA; ++i)
	{
	    if(areaid!=TeamAreaID[FoCo_Team[playerid]])
	    {
	        format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "%s has entered a spawn[TeamID: %i]", PlayerName(playerid),GetTeamArea(areaid));
		    IRC_GroupSay(gEcho, IRC_FOCO_ECHO, SpawnKill_MSG);
		    AdminLog(SpawnKill_MSG);
	    }
	}
	return 1;
}


CMD:reloadareas(playerid, params[])
{
	if(IsAdmin(playerid, ADMCMD_AREAS)==1)
	{
		for(new i = 0; i<MAX_TEAMS; i++)
		{
		    if(TeamAreaID[i]!= -1)
		    {
		        Area_Delete(TeamAreaID[i]);
		    }
			if(FoCo_Teams[i][team_type] != 0)
			{
			    TeamAreaID[i]=Area_AddSphere(FoCo_Teams[i][team_spawn_x],FoCo_Teams[i][team_spawn_y], FoCo_Teams[i][team_spawn_z],100.0);
			    format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "AreaCreated: %i TeamID: %i", TeamAreaID[i], i);
			    SendAdminMessage(ADMCMD_AREAS,SpawnKill_MSG);
			    Area_SetAllWorlds(TeamAreaID[i], false);
	  			Area_SetWorld(TeamAreaID[i], 0, true);
			}
			else if(i==0)
			{
				//Area for Bug FIXING, please dont edit.
	            TeamAreaID[i]=Area_AddSphere(0.0,0.0,10000.0,0.0);
			    format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "AreaCreated: %i TeamID: %i", TeamAreaID[i], i);
				SendAdminMessage(ADMCMD_AREAS,SpawnKill_MSG);
			    Area_SetAllWorlds(TeamAreaID[i], false);
	  			Area_SetWorld(TeamAreaID[i], 200, true);
			}
			else
			{
				TeamAreaID[i]=-1;
			}
		}
		format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "AdmCMD(%i): %s %s has reloaded spawnkill areas.",ADMCMD_AREAS,GetPlayerStatus(playerid), PlayerName(playerid));
        SendAdminMessage(ADMCMD_AREAS,SpawnKill_MSG);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You are not authorized to use this command.");
	}
	return 1;
}



