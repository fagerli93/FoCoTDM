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
* Filename: pEar_PayDay.pwn                                                      *
* Author: pEar                                                                   *
*********************************************************************************/

/*
Public callbacks used:
- OnGameModeInit
- OnGameModeExit
*/

#include <YSI\y_timers>
new 
	Timer:PayDayPreMsg1Timer,
	Timer:PayDayPreMsg2Timer,
	Timer:PayDayTimer,
	Timer:PayDayTimeTimer;
	
new
	T1 = 0,
	T2 = 0,
	T3 = 0;
	
	
/*
This timer is checked every minute at server start to get that payday is on HH:00, and not just an hour after restart.
*/
timer PayDayTime[60000]() 
{
	new Hour, Minute, Second, minutes, pay, string[128];
	gettime(Hour, Minute, Second);
	if(Minute == 0)
	{
		foreach(Player, i)
		{
			if(GetUnixTime() - OnlineTimer[i] >=  1200)
			{
				format(string, sizeof(string), "[DEBUG]: timer PayDayTime, time: %d:%d:%d", Hour, Minute, Second);
				SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
				minutes = ((GetUnixTime() - OnlineTimer[i]) / 60);
				pay = ((minutes - 15) * 35);
				GivePlayerMoney(i, pay);
				format(string, sizeof(string), "[PAY DAY]: Your have received a paycheck of %d$, minutes: %d.", pay, minutes);
				SendClientMessage(i, COLOR_GREEN, string);
			}
			else
			{
				SendClientMessage(i, COLOR_GREEN, "[PAY DAY]: You have not been online long enough to earn a pay.");
			}
			PayDayTimer = repeat PayDay();
			T1 = 1;
			if(T1 == 1 && T2 == 1 && T3 == 1)
			{
				stop PayDayTimeTimer;
			}
		}
	}
	else if(Minute == 55)
	{
		SendClientMessageToAll(COLOR_GREEN, "[PAY DAY]: Pay Day is in 5 minutes!");
		PayDayPreMsg2Timer = repeat PayDayPreMsg2();
		T2 = 1;
		if(T1 == 1 && T2 == 1 && T3 == 1)
		{
			stop PayDayTimeTimer;
		}
	}
	else if(Minute == 50)
	{
		SendClientMessageToAll(COLOR_GREEN, "[PAY DAY]: PayDay is in 10 minutes!");
		PayDayPreMsg1Timer = repeat PayDayPreMsg1();
		T3 = 1;
		if(T1 == 1 && T2 == 1 && T3 == 1)
		{
			stop PayDayTimeTimer;
		}
	}
	else
	{
		if(T1 == 1 && T2 == 1 && T3 == 1)
		{
			stop PayDayTimeTimer;
		}
	}
}
	
timer PayDayPreMsg1[3600000]()
{
	SendClientMessageToAll(COLOR_GREEN, "[PAY DAY]: PayDay is in 10 minutes!");
}

timer PayDayPreMsg2[3600000]()
{
	SendClientMessageToAll(COLOR_GREEN, "[PAY DAY]: PayDay is in 5 minutes!");
}

timer PayDay[3600000]()
{
	new Hour, Minute, Second;
	gettime(Hour, Minute, Second);
	new minutes, pay, string[128];
	foreach(Player, i)
	{
		if(GetUnixTime() - OnlineTimer[i] >=  1200)
		{
			format(string, sizeof(string), "[DEBUG]: timer PayDay, time: %d:%d:%d", Hour, Minute, Second);
			SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
			minutes = ((GetUnixTime() - OnlineTimer[i]) / 60);
			pay = ((minutes - 15) * 35);
			GivePlayerMoney(i, pay);
			format(string, sizeof(string), "[PAY DAY]: Your have received a paycheck of %d$ minutes %d", pay, minutes);
			SendClientMessage(i, COLOR_GREEN, string);
		}
		else
		{
			SendClientMessage(i, COLOR_GREEN, "[PAY DAY]: You have not been online long enough to earn a pay.");
		}
	}
}
	
hook OnGameModeInit()
{
	PayDayTimeTimer = repeat PayDayTime();
	return 1;
}

hook OnGameModeExit()
{
	stop PayDayPreMsg1Timer;
	stop PayDayPreMsg2Timer;
	stop PayDayTimer;
	stop PayDayTimeTimer;
	return 1;
}




