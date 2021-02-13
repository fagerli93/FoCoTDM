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
* Filename: pEar_ReloadBans.pwn                                                  *
* Author: pEar	                                                                 *
*********************************************************************************/


#include <YSI\y_hooks>
#include <YSI\y_timers>


#define RELOAD_TIME_TIMER 600000 	// Timer to check every 10 minutes
#define RELOAD_MAX_PLAYERS 2		// Only reload if less than 2 players online

new 
	reloadNight,
	reloadDay;


hook OnGameModeInit()
{
	reloadNight = 0;
	reloadDay = 0;
	repeat reloadBans();
	return 1;
}

timer reloadBans[RELOAD_TIME_TIMER]()
{
	new Hour, Min, Sec;	
	gettime(Hour, Min, Sec);
<<<<<<< .mine
	//new string[128];
=======
	//DebugMsg("Running reloadbans timer");
>>>>>>> .r62
	
	if(Hour >= 3 && Hour <= 7)
	{
		reloadDay = 0;
		if(reloadNight == 0)
		{
			if(GetOnlinePlayers() <= RELOAD_MAX_PLAYERS)
			{
				SendClientMessageToAll(COLOR_GLOBALNOTICE, "[INFO]: The server is updating, some lag and timeouts may occur in the next 30 seconds!");
				SendClientMessageToAll(COLOR_GLOBALNOTICE, "[INFO]: This is an automated message, we apologize for any inconvenience.");
				SendRconCommand("reloadbans");
				reloadNight = 1;
				return 1;
			}
			if(Hour == 7 && Min >= 40)
			{
				SendClientMessageToAll(COLOR_GLOBALNOTICE, "[INFO]: The server is updating, some lag and timeouts may occur in the next 30 seconds!");
				SendClientMessageToAll(COLOR_GLOBALNOTICE, "[INFO]: This is an automated message, we apologize for any inconvenience.");
				SendRconCommand("reloadbans");
				reloadNight = 1;
				return 1;
			}
		}
	}
	else
	{
		reloadNight = 0;
		if(reloadDay == 0)
		{
			if(GetOnlinePlayers() <= RELOAD_MAX_PLAYERS)
			{
				SendClientMessageToAll(COLOR_GLOBALNOTICE, "[INFO]: The server is updating, some lag and timeouts may occur in the next 30 seconds!");
				SendClientMessageToAll(COLOR_GLOBALNOTICE, "[INFO]: This is an automated message, we apologize for any inconvenience.");
				SendRconCommand("reloadbans");
				reloadDay = 1;
				return 1;
			}
		}
	}
	return 1;
}
