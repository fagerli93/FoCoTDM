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
//#define MAX_TEAMS 7

#include <YSI\y_areas>
#include <YSI\y_hooks>

#define SpawnKill_Radius 100.0
#define ADMCMD_AREAS 4
#define ADMCMD_SK 1

new SpawnKill_MSG[150];
new bool:AtSpawn[MAX_PLAYERS];
new SpawnEntered[MAX_PLAYERS][2];//0 = Spawn ; 1 = Time
new LastSKWarn[MAX_PLAYERS][2];
new SK_LOG[MAX_PLAYERS][10][2];
new SK_LogCnt[MAX_PLAYERS];


new TeamAreaID[MAX_TEAMS];

stock SpawnKillLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/spawnkill.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
}

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
	SpawnEntered[playerid][0] = -1;
	SpawnEntered[playerid][1] = NetStats_GetConnectedTime(playerid);
	return 1;
}

hook OnGameModeInit()
{
	for(new i = 0; i<MAX_TEAMS; i++)
	{
		TeamAreaID[i]=-1;
	}
	defer LoadReloadTeamAreas[10000](); //To let Server Load Data and Save Teams..
	return 1;
}

forward SpawnKill_OnPlayerDeath(playerid, killerid, reason);

public SpawnKill_OnPlayerDeath(playerid, killerid, reason)
{
    print("SK_OPD");
	if(killerid != INVALID_PLAYER_ID)
	{
		if(IsPlayerConnected(killerid))
		{
			if(GetPVarInt(playerid, "PlayerStatus") == PLAYERSTATUS_NORMAL && GetPVarInt(killerid, "PlayerStatus") == PLAYERSTATUS_NORMAL)
			{
			   	if(AtSpawn[playerid] == true && killerid != INVALID_PLAYER_ID && FoCo_Team[playerid] != FoCo_Team[killerid])
				{
				    format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "%s has been spawnkilled by %s", PlayerName(playerid),PlayerName(killerid));
			        AntiCheatMessage(SpawnKill_MSG);
				}
				if(AtSpawn[killerid] == true && FoCo_Team[playerid]!=FoCo_Team[killerid] && killerid!=INVALID_PLAYER_ID)
				{
				    for (new i, areaid; (areaid = Area_GetPlayerAreas(playerid, i)) != NO_AREA; ++i)
					{
					    if(areaid!=TeamAreaID[FoCo_Team[playerid]])
					    {
					        format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "%s has been killed while being at spawn of %s[Victim Team ID: %i]", PlayerName(playerid),PlayerName(killerid),FoCo_Team[killerid]);
							AntiCheatMessage(SpawnKill_MSG);
						}
					}
				}
			}
		}
	}
	return 1;
}

timer LoadReloadTeamAreas[1000]()
{
	for(new i = 0; i<MAX_TEAMS; i++)
	{
	    if(TeamAreaID[i] != -1)
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
			//ID 0 is a bugged ID for areas.. So its bs..
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
}


public OnPlayerEnterArea(playerid, areaid)
{
    print("OPEA");
	if(areaid!=TeamAreaID[FoCo_Team[playerid]]&&(IsPlayerInAnyVehicle(playerid)==0||GetPlayerVehicleSeat(playerid)!=0)&&GetPVarInt(playerid, "PlayerStatus") == 0)
	{
	    format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "[Guardian:] %s has entered a spawn[Area TeamID: %i]", PlayerName(playerid),GetTeamArea(areaid));
	    //IRC_GroupSay(gEcho, IRC_FOCO_ECHO, SpawnKill_MSG);
	    SpawnKillLog(SpawnKill_MSG);
		if(LastSKWarn[playerid][1] - NetStats_GetConnectedTime(playerid) >= 5000)
		{
			format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "%s(%i) has entered a spawn.", PlayerName(playerid), playerid);
			LastSKWarn[playerid][1]=NetStats_GetConnectedTime(playerid);
			SpawnKillLog(SpawnKill_MSG);
		}
	}
    SpawnEntered[playerid][0] = areaid;
	SpawnEntered[playerid][1] = NetStats_GetConnectedTime(playerid);
	return 1;
}


public OnPlayerLeaveArea(playerid, areaid)
{
	print("OPLA");
	if(areaid==TeamAreaID[FoCo_Team[playerid]]&&AtSpawn[playerid]==true&&GetPVarInt(playerid, "PlayerStatus") == 0)
	{
	    format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "[Guardian:] %s has left his spawn place[Area TeamID: %i]", PlayerName(playerid),FoCo_Team[playerid]);
		//DebugMsg(SpawnKill_MSG);
		SpawnKillLog(SpawnKill_MSG);
	    AtSpawn[playerid]=false;
	}
	else if(areaid!=TeamAreaID[FoCo_Team[playerid]])
	{
	    format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "[Guardian:] %s has left the spawn he entered.[Area TeamID: %i]", PlayerName(playerid),GetTeamArea(areaid));
		SpawnKillLog(SpawnKill_MSG);
	}
	SpawnEntered[playerid][0] = -1;
	SpawnEntered[playerid][1] = NetStats_GetConnectedTime(playerid);
	return 1;
}


hook OnPlayerExitVehicle(playerid, vehicleid)
{
    print("OPEV");
	for (new i, areaid; (areaid = Area_GetPlayerAreas(playerid, i)) != NO_AREA; ++i)
	{
	    if(areaid!=TeamAreaID[FoCo_Team[playerid]])
	    {
	        format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "%s has entered a spawn[TeamID: %i]", PlayerName(playerid),GetTeamArea(areaid));
		    //IRC_GroupSay(gEcho, IRC_FOCO_ECHO, SpawnKill_MSG);
			/*if(LastSKWarn[playerid][1] - NetStats_GetConnectedTime(playerid) >= 5000)
			{
				format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "[Guardian]: %s(%i) has entered a spawn.", PlayerName(playerid), playerid);
				LastSKWarn[playerid][1]=NetStats_GetConnectedTime(playerid);
				SpawnKillLog(SpawnKill_MSG);
			}*/
		    SpawnKillLog(SpawnKill_MSG);
     	}
		SpawnEntered[playerid][0] = areaid;
		SpawnEntered[playerid][1] = NetStats_GetConnectedTime(playerid);
	}
	return 1;
}

stock IsPlayerSpawnKilling(damagerid, playerid, weaponid = -1)
{
    print("IPSK");
	new bool:flag;
	if(weaponid == -1)
	{
	    weaponid = GetPlayerWeapon(damagerid);
	    flag = true;
	}
	/*format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "SED/SEP: %i/%i | ASD/ASP: %i/%i | WID/WIP: %i/%i | TAD/TAP: %i/%i | Flag: %i", SpawnEntered[damagerid][0], SpawnEntered[playerid][0], AtSpawn[damagerid], AtSpawn[playerid], weaponid, GetPlayerWeapon(playerid), TeamAreaID[FoCo_Team[damagerid]], TeamAreaID[FoCo_Team[playerid]], flag);
	DebugMsg(SpawnKill_MSG);*/
	if(damagerid != INVALID_PLAYER_ID && SpawnEntered[damagerid][0] != -1 && SpawnEntered[damagerid][0] != TeamAreaID[FoCo_Team[damagerid]])
	{
		if(playerid != INVALID_PLAYER_ID)
		{
			if((TeamAreaID[FoCo_Team[playerid]] == SpawnEntered[damagerid][0] || weaponid == 34) && AtSpawn[playerid] == true)
			{
				LastSKWarn[damagerid][0]++;
				if(NetStats_GetConnectedTime(damagerid) - LastSKWarn[damagerid][1] >= 5000 && flag == false)
				{
					format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "%s(%i) is spawnkilling.", PlayerName(damagerid), damagerid);
					LastSKWarn[damagerid][1]=NetStats_GetConnectedTime(damagerid);
					AntiCheatMessage(SpawnKill_MSG);
				}
				if(SK_LOG[damagerid][SK_LogCnt[damagerid]][0] != playerid)
				{
					SK_LOG[damagerid][SK_LogCnt[damagerid]][0] = playerid;
					SK_LOG[damagerid][SK_LogCnt[damagerid]][1] = NetStats_GetConnectedTime(damagerid);
					SK_LogCnt[damagerid]++;
					if(SK_LogCnt[damagerid]%10 == 0)
					{
						SK_LogCnt[damagerid]=0;
					}
				}
				return 0;
			}
		}
	}
	return 1;
}


hook OnPlayerConnect(playerid)
{
    AtSpawn[playerid]=true;
	SpawnEntered[playerid][0] = -1;
	SpawnEntered[playerid][1] = 0;
	for(new i = 0; i < 10;  i++)
	{
	    SK_LOG[playerid][i][0] = -1;
	    SK_LOG[playerid][i][1] = -1;
	}
	SK_LogCnt[playerid] = 0;

	return 1;
}

CMD:reloadareas(playerid, params[])
{
	if(IsAdmin(playerid, ADMCMD_AREAS)==1)
	{
		LoadReloadTeamAreas();
		format(SpawnKill_MSG, sizeof(SpawnKill_MSG), "AdmCMD(%i): %s %s has reloaded spawnkill areas.",ADMCMD_AREAS,GetPlayerStatus(playerid), PlayerName(playerid));
        SendAdminMessage(ADMCMD_AREAS,SpawnKill_MSG);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You are not authorized to use this command.");
	}
	return 1;
}

CMD:sklog(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
	    new targetid, flag;
	    if(sscanf(params, "u", targetid))
	    {
	        return SendClientMessage(playerid, -1,  "[USAGE]: /sklog [PlayerID/Player Name]");
	    }
	    else
	    {
			new DialogMSG[2400] = "ID\tPlayer Name\tSK-ed Before(s)\n";
			for(new i=0; i<10; i++)
			{
				if(SK_LOG[targetid][i][0] != -1)
				{
					format(DialogMSG, sizeof(DialogMSG), "%s%i\t%s\t%i\n", DialogMSG, SK_LOG[targetid][i][0], PlayerName(SK_LOG[targetid][i][0]), (NetStats_GetConnectedTime(i)-SK_LOG[targetid][i][1])/1000);
					flag++;
				}
			}
			ShowPlayerDialog(playerid, DIALOG_NORETURN, DIALOG_STYLE_TABLIST_HEADERS, "List of players he SK-ed:", DialogMSG, "Close", "");
			if(flag == 0)
			{
			    return SendClientMessage(playerid, COLOR_SYNTAX, "[GUARDIAN]: He is a good fella. Let him be.");
			}
			return 1;
		}
	}
	return 1;
}


CMD:currentsk(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
	    new flag;
		new DialogMSG[2400] = "ID\tPlayer Name\tEntered Before(s)\n";
		foreach(Player, i)
		{
			if(SpawnEntered[i][0] != TeamAreaID[FoCo_Team[i]])
			{
				format(DialogMSG, sizeof(DialogMSG), "%s%i\t%s\t%i\n", DialogMSG, i, PlayerName(i), (NetStats_GetConnectedTime(i)-SpawnEntered[i][1])/1000);
                flag++;
			}
		}
		ShowPlayerDialog(playerid, DIALOG_NORETURN, DIALOG_STYLE_TABLIST_HEADERS, "List of players {ff0000}At Spawns:", DialogMSG, "Close", "");
		if(flag == 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[GUARDIAN]: All players are good.. Lets not distroy that..");
		}
		return 1;
	}
	return 1;
}

CMD:sklist(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new DialogMSG[2400] = "ID\tPlayer Name\tPlayers SK-ed\n";
		new flag;
		foreach(Player, i)
		{
			if(SK_LogCnt[i]>0)
			{
				format(DialogMSG, sizeof(DialogMSG), "%s%i\t%s\t%i\n", DialogMSG, i, PlayerName(i), SK_LogCnt[i]);
				flag++;
			}
		}
		ShowPlayerDialog(playerid, DIALOG_NORETURN, DIALOG_STYLE_TABLIST_HEADERS, "List of SK-ers:", DialogMSG, "Close", "");
		if(flag == 0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[GUARDIAN]: All players are good.. Lets not distroy that..");
		}
	}
	return 1;
}

CMD:sk(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new sk_er, sk_ed;
		if(sscanf(params,"p< >uu", sk_er, sk_ed))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /sk [RuleBreaker] [Victim]");
		}
		else
		{
			if(sk_er == INVALID_PLAYER_ID)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid RulebreakerName/ID");
			}
			if(sk_ed == INVALID_PLAYER_ID)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid VictimName/ID");
			}
			if(!IsPlayerConnected(sk_ed))
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: VictimName/ID is not connected");
			}
			if(!IsPlayerConnected(sk_er))
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: RuleBreakerName/ID is not connected");
			}
			new sk_msg[128];
			if(!IsPlayerSpawnKilling(sk_er, sk_ed))
			{
				format(sk_msg, sizeof(sk_msg), "[NOTICE]: Yes, %s(%i) is spawn-killing %s(%i), if he has shot him. Use /sklog [Name/ID] for log.", PlayerName(sk_er), sk_er, PlayerName(sk_ed), sk_ed);
			}
			else if(!IsPlayerSpawnKilling(sk_ed, sk_er))
			{
				format(sk_msg, sizeof(sk_msg), "[NOTICE]: No you piece of shit, %s is spawn-killing %s, if he has shot him. Use /sklog for log.", PlayerName(sk_ed), sk_ed, PlayerName(sk_er), sk_er);
			}
			else
			{
				format(sk_msg, sizeof(sk_msg), "[NOTICE]: No its not SpawnKilling. Leave the kids alone.");
			}
			SendClientMessage(playerid, COLOR_NOTICE, sk_msg);
		}
	}
	return 1;
}

#if defined PTS
CMD:teamareaids(playerid, params[])
{
	new TEST_MSG[2400];
	for(new i = 1; i < 20 ; i++)
	{
	    format(TEST_MSG, sizeof(TEST_MSG), "%s\n%i - %s\t %i", TEST_MSG, i, FoCo_Teams[i][team_name], TeamAreaID[i]);
	}
	return ShowPlayerDialog(playerid, DIALOG_NORETURN, DIALOG_STYLE_MSGBOX, "List of AREAIDs:", TEST_MSG, "Close", "");
}
#endif

