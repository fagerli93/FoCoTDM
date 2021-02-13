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
* Filename: timer.pwn                                                             *
* Author:  RakGuy                                                                *
*********************************************************************************/

#define FILTERSCRIPT
#define TIMER_LIMIT 2

#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <YSI\y_timers>

new Timer_TimerStr[30],Timer_Time;
new bool:Timer_TimerActive;
new Timer_TimerMSG[150];
new Timer:TimerID;
new TDTimer_TimerStr[37];
new Text:Timer_TText;

////////////////////////////////STOCKS/////////////////////////////////////////
stock CreateText()
{
	format(TDTimer_TimerStr, sizeof(TDTimer_TimerStr), "%s~r~%i:00", Timer_TimerStr, Timer_Time);
   	Timer_TText = TextDrawCreate(10.0 , 329.0 , TDTimer_TimerStr);
   	TextDrawLetterSize(Timer_TText, 0.4,1.8);
   	TextDrawFont(Timer_TText, 1);
   	TextDrawAlignment(Timer_TText, 1);
	TextDrawColor(Timer_TText , 0xffbf00FF);
	TextDrawSetOutline(Timer_TText , 1);
	TextDrawSetProportional(Timer_TText , 1);
	TextDrawSetShadow(Timer_TText , 1);
	return 1;
}
stock EditText(EDIT_Mins, EDIT_Secs)
{
    format(TDTimer_TimerStr, sizeof(TDTimer_TimerStr),"%s~r~%i:%i", Timer_TimerStr, EDIT_Mins, EDIT_Secs);
    TextDrawSetString(Timer_TText, TDTimer_TimerStr);
	return 1;
}
stock EndTimer()
{
 	stop TimerID;
	TextDrawHideForAll(Timer_TText);
	TextDrawDestroy(Timer_TText);
	Timer_TimerActive=false;
}
//////////////////////////////////TIMERS////////////////////////////////////////
timer Interval[1000]()
{
	new Interval_Mins, Interval_Secs;
	Timer_Time--;
	Interval_Mins=floatround(Timer_Time/60, floatround_floor);
	Interval_Secs = Timer_Time%60;
	if(Timer_Time==0)
	{
	    format(Timer_TimerMSG, sizeof(Timer_TimerMSG), "[NOTICE:] Timer is now over. Details: '%s'", Timer_TimerStr);
		SendAdminMessage(TIMER_LIMIT,Timer_TimerMSG);
		EndTimer();
	}
	else
	{
		EditText(Interval_Mins, Interval_Secs);
	}
}
//////////////////////////////////////////HOOKS/////////////////////////////////
public OnGameModeInit()
{
    Timer_TimerActive=false;
}
public OnGameModeExit()
{
	if(Timer_TimerActive==true)
	{
	    EndTimer();
	}
	return 1;
}
public OnPlayerConnect(playerid)
{
	if(Timer_TimerActive==true)
	{
    	TextDrawShowForPlayer(playerid, Timer_TText);
	}
	print("Called Timer");
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	TextDrawHideForPlayer(playerid, Timer_TText);
	return 1;
}
////////////////////////////////COMMANDS////////////////////////////////////////
CMD:starttimer(playerid, params[])
{
	if(IsAdmin(playerid, TIMER_LIMIT)==1)
	{
		if(Timer_TimerActive==true)
		{
	 		SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] End the current timer first.");
	    }
		else if(sscanf(params, "is[30]", Timer_Time, Timer_TimerStr))
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "[Usage:] /starttimer [Time(mins)] [Comment] ");
		}
		else
		{
        	format(Timer_TimerMSG, sizeof(Timer_TimerMSG), "(AdmCmd %i) %s %s started a timer[%i:00 mins].", TIMER_LIMIT, GetPlayerStatus(playerid), PlayerName(playerid),Timer_Time);
			SendAdminMessage(TIMER_LIMIT,Timer_TimerMSG);
			Timer_TimerActive=true;
			CreateText();
		   	TextDrawShowForAll(Timer_TText);
			Timer_Time=Timer_Time*60;
			TimerID = repeat Interval();
	  }
	}
    else
    {
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You are not authorized to use this command.");
	}
	return 1;
}

CMD:endtimer(playerid, params[])
{
	if(IsAdmin(playerid, TIMER_LIMIT)==1)
	{
	    if(Timer_TimerActive==true)
	    {
			format(Timer_TimerMSG, sizeof(Timer_TimerMSG), "(AdmCmd %i) %s %s stopped the timer.",TIMER_LIMIT, GetPlayerStatus(playerid), PlayerName(playerid));
			SendAdminMessage(TIMER_LIMIT,Timer_TimerMSG);
			SendClientMessage(0, COLOR_SYNTAX, "[Notice:] You have stopped the timer!");
			EndTimer();
		}
		else
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] There are not active timers to end.");
		}
	}
    else
    {
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You are not authorized to use this command.");
	}
	return 1;
}
