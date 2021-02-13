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
* Filename: pEar_ActivityChecker.pwn                                             *
* Author: pEar	                                                                 *
*********************************************************************************/

#include <YSI\y_timers>
#include <YSI\y_hooks>

hook OnGameModeInit()
{
	ActivityChecker();
	return 1;
}

task ActivityChecker[60000]()
{
	//DebugMsg("Timer for activity checker activated!");
	new Hour, Min, Sec, Day, Month, Year;
	new entry[128], Players = 0, Admins = 0;
	gettime(Hour, Min, Sec);
	getdate(Year, Month, Day);
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(i != INVALID_PLAYER_ID)
		{
			Players++;
			if(AdminLvl(i) > 0)
			{
				Admins++;
			}
		}
	}
	format(entry, sizeof(entry), "%d.%d	%d	%d	%d	%d/%d/%d\r\n", Hour, Min, Players, Admins, (Players/Admins), Day, Month, Year);
	//DebugMsg(entry);
	/*
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/ActivityChecker.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
	*/
}
