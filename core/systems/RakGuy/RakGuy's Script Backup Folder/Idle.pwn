#define IDLE_TIME_LIMIT 180
#define DIALOG_IDLE 692

#include <a_samp>
#include <zcmd>
#include <YSI\y_timers>
#include <sscanf2>

new Float:Idle_Pos_Old[MAX_PLAYERS][3];
new IdleTime[MAX_PLAYERS];

public OnFilterScriptInit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	IdleTime[playerid]=0;
	Idle_Pos_Old[playerid][0]=0.0;
	Idle_Pos_Old[playerid][1]=0.0;
	Idle_Pos_Old[playerid][2]=0.0;
	print("Called Idle");
	return 1;
}

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
	if(IsAdmin(playerid, 1)==1/*||IsTrAdmin(playerid)==1*/)
	{
	    new IdleID;
		if(sscanf(params, "u", IdleID))
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /idletime [Playerid/Part-of-Name]");
		}
		else
		{
		    if(IsPlayerConnected(playerid))
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
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You are not authorized to use this command.");
	}
	return 1;
}

CMD:idlelist(playerid)
{
	if(IsAdmin(playerid, 1)==1/*||IsTrAdmin(playerid)==1*/)
	{
	    new IDLE_MESSAGE[2000];
		new IDLE_SEC, IDLE_MIN;
		for(new i=0; i<MAX_PLAYERS; i++)
	    {
	        if(IdleTime[i]>IDLE_TIME_LIMIT)
			{
			    IDLE_SEC=IdleTime[i]%60;
			    IDLE_MIN=IdleTime[i]/60;
				format(IDLE_MESSAGE, sizeof(IDLE_MESSAGE), "%s%s[%i] - %i:%i\n", IDLE_MESSAGE, PlayerName(i), i,IDLE_MIN, IDLE_SEC);
			}
	    }
		format(IDLE_MESSAGE, sizeof(IDLE_MESSAGE), "IDLE PLAYER[ID] - TIME\n%s", IDLE_MESSAGE);
	    ShowPlayerDialog(playerid, DIALOG_IDLE, 0, "Idle Players", IDLE_MESSAGE, "Thank you:)", "WhatEver");
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You are not authorized to use this command.");
	}
	return 1;
}















