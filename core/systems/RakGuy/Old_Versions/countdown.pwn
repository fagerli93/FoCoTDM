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
* Filename: countdown.pwn                                                      	 *
* Author: RakGuy                                                                 *
*********************************************************************************/
#include <YSI\y_hooks>

new CD_TimerTime;
new CD_Message[20];
new Timer:CD_TimerID;

hook OnGameModeInit()
{
	CD_TimerTime=-1;
	CD_Message="Begin";
	return 1;
}

timer Countdown[1000]()
{
	new CD_MSG[21];
	if(CD_TimerTime>0)
	{
	    format(CD_MSG, sizeof(CD_MSG), "~b~%i", CD_TimerTime);
	    GameTextForAll(CD_MSG, 500, 3);
		CD_TimerTime--;
	}
	else if(CD_TimerTime==0)
	{
	    format(CD_MSG, sizeof(CD_MSG), "~r~%s", CD_Message);
	    GameTextForAll(CD_MSG, 1000, 3);
		stop CD_TimerID;
		CD_TimerTime=-1;
	}

}

CMD:countdown(playerid, params[])
{
	if(IsAdmin(playerid, 1)==1)
	{
		if(CD_TimerTime==-1)
		{
		    new Temp_CD_TimerTime;
		  	if(sscanf(params, "iS(begin)[19]", Temp_CD_TimerTime, CD_Message))
		  	{
		  	    SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE:] /countdown [Time] [Opt: End_Message]");
		  	}
		  	else
		  	{
				if(Temp_CD_TimerTime>99||Temp_CD_TimerTime<2)
				{
				    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Timer has be above 2Seconds and below 99Seconds.");
				}
				else
				{
				    CD_TimerTime = Temp_CD_TimerTime;
				    new CD_MSG[20];
				    format(CD_MSG, sizeof(CD_MSG), "~b~%i", CD_TimerTime);
				    GameTextForAll(CD_MSG, 500, 3);
					CD_TimerTime--;
                    CD_TimerID = repeat Countdown();
				}
		  	}
		}
		else
		{
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Another timer currently running.");
		}
	}
	return 1;
}

CMD:endcountdown(playerid, params[])
{
	if(IsAdmin(playerid, 1)==1)
	{
	    if(CD_TimerTime!=-1)
	    {
   			new CD_MSG[20];
   			CD_TimerTime=-1;
			format(CD_MSG, sizeof(CD_MSG), "~r~Timer Stopped");
			GameTextForAll(CD_MSG, 1000, 3);
			stop CD_TimerID;
	    }
	    else
	    {
	        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] There is no timer currently running.");
	    }
	}
	return 1;
}
