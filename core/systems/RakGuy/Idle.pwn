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
* Filename: idle.pwn                                                             *
* Author:  RakGuy                                                                *
*********************************************************************************/
#include <YSI\y_hooks>

#define IDLE_TIME_LIMIT 300
#define ACMD_IDLE 1
#define IDLE_KICK_TIME IDLE_TIME_LIMIT
#define AFK_KICK_TIME 600
#define LOGIN_TIME 60
#define ACMD_IDLE_OD 4

new Float:Idle_Pos_Old[MAX_PLAYERS][3];
new IdleTime[MAX_PLAYERS];
new OverRideKickTime;
new AFK_OD_KICK_TIME;
//////////////////////////////HOOKS/////////////////////////////////////////////
hook OnPlayerConnect(playerid)
{
    IgnoreOnline[playerid] = false;
	IdleTime[playerid]=0;
	Idle_Pos_Old[playerid][0]=0.0;
	Idle_Pos_Old[playerid][1]=0.0;
	Idle_Pos_Old[playerid][2]=0.0;
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
    IgnoreOnline[playerid] = false;
	IdleTime[playerid]=0;
	Idle_Pos_Old[playerid][0]=0.0;
	Idle_Pos_Old[playerid][1]=0.0;
	Idle_Pos_Old[playerid][2]=0.0;
	return 1;
}

hook OnGameModeInit()
{
    OverRideKickTime = IDLE_KICK_TIME;
    AFK_OD_KICK_TIME = AFK_KICK_TIME;
    return 1;
}
/////////////////////////////////TIMERS/////////////////////////////////////////
ptask IdleTimer[1000](playerid)
{
	new Float:Idle_Pos_New[3];
	GetPlayerPos(playerid, Idle_Pos_New[0], Idle_Pos_New[1], Idle_Pos_New[2]);
	if(Idle_Pos_Old[playerid][0] == Idle_Pos_New[0] && Idle_Pos_Old[playerid][1] == Idle_Pos_New[1] && Idle_Pos_Old[playerid][2] == Idle_Pos_New[2])
	{
		IdleTime[playerid]++;
	}
	else
	{
	    IgnoreOnline[playerid] += IdleTime[playerid];
	    IdleTime[playerid]=0;
		Idle_Pos_Old[playerid][0]=Idle_Pos_New[0];
		Idle_Pos_Old[playerid][1]=Idle_Pos_New[1];
		Idle_Pos_Old[playerid][2]=Idle_Pos_New[2];
	}
	if(gPlayerLogged[playerid] == 1)
	{
		if(IdleTime[playerid] >= OverRideKickTime && GetPVarInt(playerid, "PlayerStatus") != 3)
		{
			IgnoreOnline[playerid]++;
		}
		else if(GetPVarInt(playerid, "PlayerStatus") == 3 && (gettime() - GetPVarInt(playerid,"afktime")) >= AFK_OD_KICK_TIME)
		{
			IgnoreOnline[playerid]++;
		}
	}
	else
	{
	    if(IdleTime[playerid] >= 120)
		{
			IdleTime[playerid]=0;
			AKickPlayer(-1, playerid, "Failure to log-in/register.", 1);
		}
	}
}

CMD:idletime(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_IDLE)==1||IsTrialAdmin(playerid) == 1)
	{
	    new IdleID;
		if(sscanf(params, "u", IdleID))
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /idletime [Playerid/Part-of-Name]");
		}
		else
		{
		    if(IsPlayerConnected(IdleID))
		    {
			    new IDLE_MESSAGE[80];
			    new IDLE_SEC=IdleTime[IdleID]%60;
				new IDLE_MIN=IdleTime[IdleID]/60;
			    format(IDLE_MESSAGE, sizeof(IDLE_MESSAGE), "[IDLE TIMER:] Player: %s[%i] - IdleTime: %i:%i.", PlayerName(IdleID), IdleID, IDLE_MIN, IDLE_SEC);
				SendClientMessage(playerid, COLOR_NOTICE, IDLE_MESSAGE);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] InValid PlayerID/Part-Of-Name");
			}
		}
	}
	return 1;
}

CMD:ignoretime(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_IDLE)==1||IsTrialAdmin(playerid) == 1)
	{
	    new IdleID;
		if(sscanf(params, "u", IdleID))
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ignoretime [Playerid/Part-of-Name]");
		}
		else
		{
		    if(IsPlayerConnected(IdleID) && IdleID != INVALID_PLAYER_ID)
		    {
			    new IDLE_MESSAGE[80];
			    new IDLE_SEC=IgnoreOnline[IdleID]%60;
				new IDLE_MIN=IgnoreOnline[IdleID]/60;
			    format(IDLE_MESSAGE, sizeof(IDLE_MESSAGE), "[IGNORE TIMER:] Player: %s[%i] - IdleTime: %i:%i.", PlayerName(IdleID), IdleID, IDLE_MIN, IDLE_SEC);
				SendClientMessage(playerid, COLOR_NOTICE, IDLE_MESSAGE);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] InValid PlayerID/Part-Of-Name");
			}
		}
	}
	return 1;
}
