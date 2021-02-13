/*********************************************************************************
*																				 *
*				 ______     _____        _______ _____  __  __                   *
*				|  ____|   / ____|      |__   __|  __ \|  \/  |                  *
*				| |__ ___ | |     ___      | |  | |  | | \  / |                  *
*				|  __/ _ \| |    / _ \     | |  | |  | | |\/| |                  *
*				| | | (_) | |___| (_) |    | |  | |__| | |  | |                  *
*				|_|  \___/ \_____\___/     |_|  |_____/|_|  |_|                  *
*                                                                                *
*                                                                                *
*								(c) Copyright				 					 *
*  Owners: Simon Fagerli (pEar) - Lee Percox (Shaney) - Warren Bickley (WazzaJB) *
*         Developers: Marcel, RakGuy, FKu, Chilco, dr_vista, Fletcher            *
*																				 *
* Filename: foco.pwn                                                             *
*********************************************************************************/
/*UNCOMMENT THIS LINE TO SWITCH SCRIPT OVER TO PTS*/

//#define 	PTS // PTS defined = focotdm_test database, PTS not defined = focotdm_game database
#define 	GuardianProtected
#define 	FTDM_USE_SALT		0 // 1 = Enabled.. 0 = Disabled


#if !defined PTS
	#define IRC_ENABLE
#endif

#if defined PTS
	//#define DEBUGOPD //Debug OnPlayerDeath(callback.pwn) to see if its crashing.
	//#define DEBUGSPAWNSEC
#endif

//#define FTDM_CUSTOM_TEAM_SELECTION
#define DMZONE_TO_TDMZONE
#define DM_ZONE_SYSTEM

#define GAMEMODE_TEXT "FoCo TDM V5 | Rev: 0007"

//#define RAKGUY_WEAPONHACKS //Joined with GuardianProtected.
// test
#define SERVERSIDED_HP //Comment out to disable Server Sided HP.

#include <crashdetect>
#include <a_samp>

#undef MAX_PLAYERS
#define MAX_PLAYERS 200

//#pragma dynamic 1073741824

#pragma unused FoCo_Playerstats_UCP //Bugfix
#pragma unused clanselectid //Bugfix

#include <a_mysql>
#include <core>
#include <float>
#include <time>
#include <file>
#include <streamer>
#include <zcmd>
#include <sscanf2>
#include <strlib>
#include <irc>
#include <foreach>
#include <YSI\y_td>
#include <YSI\y_timers>
#include <YSI\y_ini>
//#include <SKY> //Causing AntiCbug to act weird


//new invalidcapsskins[] = {1,2,3,4,5,7,12,15,17,18,21,23,26,27,30,32,33,34,40,41,50,51,60,64,73,76,85,98,103,106,114,118,136,142,148,152,154,157,160,166,172,197,204,207,214,241,245,248,252,254,259,268,269,272,276,277,278,282,283,284,286,287,288,292};

native WP_Hash(buffer[], len, const str[]);
native IsValidVehicle(vehicleid); //Added it for Vista
native gpci(playerid, serial[], len); //Added for Serial in FoCo_Connections
stock const NOT_ALLOWED_WARNINGMSG[53] = "[ERROR]: You are not authorized to use this command.";

#define GetUnixTime() gettime()

AntiDeAMX()
{
    new a[][] =
    {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}

/*
* MySQL
*/

#if defined PTS
	#define SQL_HOST 				""
	#define SQL_DB 					""
	#define SQL_USER 				""
	#define SQL_PASS 				""
#else
	#define SQL_HOST 				""
	#define SQL_DB 					""
	#define SQL_USER 				""
	#define SQL_PASS 				""
#endif


#define TABLENAME 				"FoCo_Players"

#define MAIN_INIT
/*
* File Concatenation
*/

#include 						".\core\defines.pwn"
#include 						".\core\variables.pwn"
#include                        ".\core\forwards.pwn"

#if defined GuardianProtected
#include 						".\anticheat\ac_weaponhack.pwn" //To remove: Edit Vista's anticheat as well. Search for 'RakGuy' in Vista's file
#include                        ".\anticheat\anticheat_vista.pwn"
//#include                        ".\anticheat\ac_fakedeath.pwn"
//#include                        ".\..\ftdmLeadDevs\lead\anticheat\ac_trollboss.pwn"
#endif

#include                        ".\core\adminsettings.pwn"
#include                        ".\core\Dev_Callbacks.pwn"
#include                        ".\core\systems.pwn"

#include 						".\core\functions.pwn"
#include                        ".\core\callbacks.pwn"
#include 						".\core\addons\filesystem.pwn"
#include 						".\core\playercommands.pwn"
#include 						".\core\admincommands.pwn"
#include 						".\core\objects.pwn"


/*
* Main Console Print
*/

main()
{
    print("~~~~~~~~~~~~~~~~~FoCo TDM ~~~~~~~~~~~~~~~~~~~~~~~~");
	print("~~Scripted By: Lee Percox (Shaney) - Warren Bickley (Wazza)~~");
	print("~~Scripted By: Simon Fagerli (pEar) - Marcel Weinel (Marcel)~~");
	print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
}
