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
* Filename: pEar_CommandWatch.pwn                                                *
* Author: pEar	                                                                 *
*********************************************************************************/

#include <YSI\y_hooks>

#define MAX_PER_CMD 20

forward LastCmdLog(playerid, cmdtext[]);

enum lastCmdsString {
	LC_1[20],
	LC_2[20],
	LC_3[20],
	LC_4[20],
	LC_5[20],
	LC_Count
};

new lastCmds[MAX_PLAYERS][lastCmdsString];

hook OnGameModeInit()
{
	
	for(new i = 0; i < MAX_PLAYERS; i++) {
		format(lastCmds[i][LC_1], MAX_PER_CMD, "");
		format(lastCmds[i][LC_2], MAX_PER_CMD, "");
		format(lastCmds[i][LC_3], MAX_PER_CMD, "");
		format(lastCmds[i][LC_4], MAX_PER_CMD, "");
		format(lastCmds[i][LC_5], MAX_PER_CMD, "");
		lastCmds[i][LC_Count] = 0;
	}

	
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    //DebugMsg("CW_Strt");
	format(lastCmds[playerid][LC_1], MAX_PER_CMD, "");
	format(lastCmds[playerid][LC_2], MAX_PER_CMD, "");
	format(lastCmds[playerid][LC_3], MAX_PER_CMD, "");
	format(lastCmds[playerid][LC_4], MAX_PER_CMD, "");
	format(lastCmds[playerid][LC_5], MAX_PER_CMD, "");
	lastCmds[playerid][LC_Count] = 0;
	//DebugMsg("CW_Done");
	return 1;
}


CMD:lastcommands(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_LASTCOMMANDS)) {
		new targetid;
		if(sscanf(params, "u", targetid)) {
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /lastcommands [PlayerName/ID]");
		}
		if(!IsPlayerConnected(playerid)) {
			return SendErrorMessage(playerid, "This player is not connected");
		}
		if(AdminLvl(targetid) >= AdminLvl(playerid) && FoCo_Player[playerid][id] != 368) {
			return SendErrorMessage(playerid, "You can only use this on people with a lower admin level");
		}
		new string[MAX_PER_CMD];
		new tmp = lastCmds[targetid][LC_Count];
		for(new i = 0; i < 5; i++) {
			switch(tmp)
			{
				case 0:
				{
					if(strlen(lastCmds[targetid][LC_1]) != 0)
					{
						format(string, sizeof(string), "%s", lastCmds[targetid][LC_1]);
						SendClientMessage(playerid, COLOR_SYNTAX, string);
					}
				}
				case 1:
				{
					if(strlen(lastCmds[targetid][LC_2]) != 0)
					{
						format(string, sizeof(string), "%s", lastCmds[targetid][LC_2]);
						SendClientMessage(playerid, COLOR_SYNTAX, string);
					}
				}
				case 2:
				{
					if(strlen(lastCmds[targetid][LC_3]) != 0)
					{
						format(string, sizeof(string), "%s", lastCmds[targetid][LC_3]);
						SendClientMessage(playerid, COLOR_SYNTAX, string);
					}
				}
				case 3:
				{
					if(strlen(lastCmds[targetid][LC_4]) != 0)
					{
						format(string, sizeof(string), "%s", lastCmds[targetid][LC_4]);
						SendClientMessage(playerid, COLOR_SYNTAX, string);
					}
				}
				case 4:
				{
					if(strlen(lastCmds[targetid][LC_5]) != 0)
					{
						format(string, sizeof(string), "%s", lastCmds[targetid][LC_5]);
						SendClientMessage(playerid, COLOR_SYNTAX, string);
					}
				}
			}
			tmp = (tmp+1)%5;
		}
	}
	return 1;
}


public LastCmdLog(playerid, cmdtext[])
{
	new cmdText[5];
	strmid(cmdText, cmdtext, 0, 4, 4);
	if(strcmp(cmdText, "/g ", true) == 0) {
		return 1;
	}
	if(strcmp(cmdText, "/r ", true) == 0) {
		return 1;
	}
	if(strcmp(cmdText, "/a ", true) == 0) {
		return 1;
	}
	strmid(cmdText, cmdtext, 0, 5, 5);
	if(strcmp(cmdText, "/pm ", true) == 0) {
		return 1;
	}
	if(strcmp(cmdText, "/gm ", true) == 0) {
		return 1;
	}
	if(strcmp(cmdText, "/la ", true) == 0) {
		return 1;
	}
	strmid(cmdText, cmdtext, 0, 6, 6);
	if(strcmp(cmdText, "/pdm ", true) == 0) {
		return 1;
	}
	if(strcmp(cmdText, "/pdmxyz ", true) == 0) {
		return 1;
	}
	switch(lastCmds[playerid][LC_Count])
	{
		case 0: format(lastCmds[playerid][LC_1], MAX_PER_CMD, "%s", cmdtext);
		case 1: format(lastCmds[playerid][LC_2], MAX_PER_CMD, "%s", cmdtext);
		case 2: format(lastCmds[playerid][LC_3], MAX_PER_CMD, "%s", cmdtext);
		case 3: format(lastCmds[playerid][LC_4], MAX_PER_CMD, "%s", cmdtext);
		case 4: format(lastCmds[playerid][LC_5], MAX_PER_CMD, "%s", cmdtext);
	}
	lastCmds[playerid][LC_Count] = (lastCmds[playerid][LC_Count] + 1) % 5;

	return 1;
}
