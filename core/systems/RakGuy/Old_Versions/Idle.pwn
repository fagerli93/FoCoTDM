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

#define IDLE_TIME_LIMIT 120
#define ACMD_IDLE 1
#define DIALOG_IDLE 534

new Float:Idle_Pos_Old[MAX_PLAYERS][3];
new IdleTime[MAX_PLAYERS];
//////////////////////////////HOOKS/////////////////////////////////////////////
hook OnPlayerConnect(playerid)
{
	IdleTime[playerid]=0;
	Idle_Pos_Old[playerid][0]=0.0;
	Idle_Pos_Old[playerid][1]=0.0;
	Idle_Pos_Old[playerid][2]=0.0;
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	IdleTime[playerid]=0;
	Idle_Pos_Old[playerid][0]=0.0;
	Idle_Pos_Old[playerid][1]=0.0;
	Idle_Pos_Old[playerid][2]=0.0;
	return 1;
}
/////////////////////////////////TIMERS/////////////////////////////////////////
ptask IdleTimer[1000](playerid)
{
	new Float:Idle_Pos_New[3];
	GetPlayerPos(playerid, Idle_Pos_New[0], Idle_Pos_New[1], Idle_Pos_New[2]);
	if(Idle_Pos_Old[playerid][0]==Idle_Pos_New[0] && Idle_Pos_Old[playerid][1]==Idle_Pos_New[1] && Idle_Pos_Old[playerid][2]==Idle_Pos_New[2])
	{
		IdleTime[playerid]++;
	}
	else
	{
		IdleTime[playerid]=0;
		Idle_Pos_Old[playerid][0]=Idle_Pos_New[0];
		Idle_Pos_Old[playerid][1]=Idle_Pos_New[1];
		Idle_Pos_Old[playerid][2]=Idle_Pos_New[2];
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

CMD:idlelist(playerid)
{
	if(IsAdmin(playerid, ACMD_IDLE)==1||IsTrialAdmin(playerid) == 1)
	{
	    new IDLE_MESSAGE[2000];
		new IDLE_SEC, IDLE_MIN;
		new bool:IDLE_ANY;
		for(new i=0; i<MAX_PLAYERS; i++)
	    {
	        if(IdleTime[i]>IDLE_TIME_LIMIT)
			{
			    IDLE_SEC=IdleTime[i]%60;
			    IDLE_MIN=IdleTime[i]/60;
				format(IDLE_MESSAGE, sizeof(IDLE_MESSAGE), "%s%s[%i] - %i:%i\n", IDLE_MESSAGE, PlayerName(i), i,IDLE_MIN, IDLE_SEC);
				IDLE_ANY=true;
			}
	    }
		if(IDLE_ANY==true)
		{
			format(IDLE_MESSAGE, sizeof(IDLE_MESSAGE), "IDLE PLAYER[ID] - TIME\n%s", IDLE_MESSAGE);
		    ShowPlayerDialog(playerid, DIALOG_IDLE, 0, "Idle Players", IDLE_MESSAGE, "Close", "Close");
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Nobody has been AFK for more than AFK limit.[120Sec Default].");
		}
	}
	return 1;
}
