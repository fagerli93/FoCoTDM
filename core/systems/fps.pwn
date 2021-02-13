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
* Filename:  fps.pwn                                                             *
* Author:    dr_vista                                                            *
*********************************************************************************/

#include <YSI\y_hooks>

#define MAX_FPS_WARNS 5

new
		pFPS[MAX_PLAYERS];
	
static
		pDrunkLevelLast[MAX_PLAYERS],
		fps_targetID[MAX_PLAYERS] = -1,
		fpswatch[MAX_PLAYERS] = 0,
		fpswatched[MAX_PLAYERS] = 0;

static 
		PlayerText:FPSTD[MAX_PLAYERS],
		Timer:fpsTimer[MAX_PLAYERS];

static
		minfps,
		fpswarned[MAX_PLAYERS],
		fpscooldown[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
	fpswatch[playerid] = 0;
	fpswatched[playerid] = 0;
	fpswarned[playerid] = 0;
	fpscooldown[playerid] = gettime();
	pFPS[playerid] = 100;
	
	FPSTD[playerid] = CreatePlayerTextDraw(playerid, 632.000183, 430.577789, "_");
	PlayerTextDrawLetterSize(playerid, FPSTD[playerid], 0.344666, 1.535289);
	PlayerTextDrawAlignment(playerid, FPSTD[playerid], 3);
	PlayerTextDrawColor(playerid, FPSTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, FPSTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, FPSTD[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, FPSTD[playerid], 51);
	PlayerTextDrawFont(playerid, FPSTD[playerid], 2);
	PlayerTextDrawSetProportional(playerid, FPSTD[playerid], 1);
	PlayerTextDrawHide(playerid, FPSTD[playerid]);	

	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(fps_targetID[playerid] != -1) 
	{
		PlayerTextDrawDestroy(fps_targetID[playerid], FPSTD[fps_targetID[playerid]]);
		fpswatched[fps_targetID[playerid]] = 0;
	}
	
	fps_targetID[playerid] = -1;
	fpswatch[playerid] = 0;
	fpscooldown[playerid] = 0;
	
	PlayerTextDrawDestroy(playerid, FPSTD[playerid]);
	stop fpsTimer[playerid];
}

hook OnPlayerSpawn(playerid)
{
	pFPS[playerid] = 100;
}

ptask updateFPS[500](playerid)
{
	if(fpswatched[playerid] || minfps > 0)
	{
		new drunknew = GetPlayerDrunkLevel(playerid);

		if (drunknew < 100)
		{
			SetPlayerDrunkLevel(playerid, 2000);
		}
		
		else
		{

			if(pDrunkLevelLast[playerid] != drunknew)
			{
				new wfps = pDrunkLevelLast[playerid] - drunknew;

				if ((wfps > 0) && (wfps < 200))
				{
					pFPS[playerid] = wfps - 1;			
				}
				
				pDrunkLevelLast[playerid] = drunknew;
			}
		}
		
		if(pFPS[playerid] < minfps && gettime() >= fpscooldown[playerid])
		{
			new
				string[128];
				
			fpswarned[playerid]++;
			
			format(string, sizeof(string), "[WARNING]: Your FPS is below the minimum FPS (%d). (Warning %d/%d).", minfps, fpswarned[playerid], MAX_FPS_WARNS);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
			
			fpscooldown[playerid] = gettime() + 30;
			if(fpswarned[playerid] > MAX_FPS_WARNS)
			{
				format(string, sizeof(string), "[NOTICE]: %s (%d) was kicked for having too low FPS.", PlayerName(playerid), playerid);
				SendClientMessageToAll(COLOR_NOTICE, string);
				Kick(playerid);
			}
		}
	}
}

timer updateTD[950](playerid)
{
	if(fpswatch[playerid])
	{
		new 
			string[128];

		if(pFPS[fps_targetID[playerid]] >= 60)  PlayerTextDrawColor(playerid, FPSTD[playerid], 16711850);
		else if(pFPS[fps_targetID[playerid]] >= 30 && pFPS[fps_targetID[playerid]] < 60) PlayerTextDrawColor(playerid, FPSTD[playerid],  -65366);
		else PlayerTextDrawColor(playerid, FPSTD[playerid],  -16777046);
		format(string, sizeof(string),  "%s's FPS: %d", PlayerName(fps_targetID[playerid]), pFPS[fps_targetID[playerid]]);
		PlayerTextDrawSetString(playerid, FPSTD[playerid], string);
		PlayerTextDrawShow(playerid, FPSTD[playerid]);
	}
}

CMD:fps(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_FPS))
	{
		new targetid;
		if(sscanf(params, "u", targetid))
		{
			if(fpswatch[playerid])
			{
				fpswatch[playerid] = 0;
				fpswatched[fps_targetID[playerid]] = 0;
				fps_targetID[playerid] = -1;
				stop fpsTimer[playerid];
				return PlayerTextDrawHide(playerid, FPSTD[playerid]);
			}
			
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /fps [ID]");
		}
		
	
		/*if(targetid == cellmin)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Multiple matches found. Be more specific.");
		}
		
		else */
		if(targetid == INVALID_PLAYER_ID)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player is not connected");
		}
		
		else
		{
			fpswatch[playerid] = 1;
			fpswatched[targetid] = 1;
			fps_targetID[playerid] = targetid;
			fpsTimer[playerid] = repeat updateTD(playerid);
		}

	}
	
	return 1;
}

CMD:minfps(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_MINFPS))
	{
		new 
			value;
		if(sscanf(params, "d", value))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /minfps [value] (Note: a value of 0 will disable the system.");
		}

		new
			string[128];
		
		if(value < 0 || value > 60) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Values have to be between 0 and 60.");
		
		minfps = value;
		
		format(string, sizeof(string), "AdmCmd(%d): %s %s has set the minimum fps to %d", ACMD_MINFPS, GetPlayerStatus(playerid), PlayerName(playerid), minfps);
		SendAdminMessage(ACMD_MINFPS, string);
		format(string, sizeof(string), "[NOTICE]: %s %s has set the minimum fps to %d", GetPlayerStatus(playerid), PlayerName(playerid), minfps);
		SendClientMessageToAll(COLOR_NOTICE, string);		
	}
	
	return 1;
}
