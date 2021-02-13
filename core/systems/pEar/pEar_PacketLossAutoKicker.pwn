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
* Filename: pEar_PacketLossAutoKicker.pwn                                        *
* Author: pEar	                                                                 *
*********************************************************************************/

#include <YSI\y_hooks>

#define MAX_PL 0.3
#define PL_KICK_TIME 30

//new Float:max_PL;
//new PL_Time[MAX_PLAYERS];

/*
hook OnGameModeInit()
{
	max_PL = MAX_PL;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		PL_Time[i] = 0;
	}
	return 1;
}

hook OnPlayerConnect(playerid)
{
	PL_Time[playerid] = 0;
	return 1;
}

ptask AutoPLKicker[1000](playerid)
{
	if(max_PL != 0.0)
	{
		if(IsPlayerConnected(playerid) && AdminLvl(playerid) == 0)
		{
			if(NetStats_PacketLossPercent(playerid) > max_PL)
			{
				if(PL_Time[playerid] == 0)
				{
					PL_Time[playerid] = gettime();	
				}
				else
				{
					if(gettime() - PL_Time[playerid] >= PL_KICK_TIME)
					{
						new string[56];
						format(string, sizeof(string), "Exceeding %.1f packetloss for %d+ seconds", max_PL, PL_KICK_TIME);
						AKickPlayer(-1, playerid, string);
					}
				}
			}
			else
			{
				PL_Time[playerid] = 0; 
			}
		}
	}
}


CMD:packetlosslimit(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_PLL))
	{
		new Float:pl, string[128];
		if(sscanf(params, "f", pl))
		{
			
			format(string, sizeof(string), "[INFO]: Current packetlosslimit is: %.2f, use /packetlosslimit [Decimal] to change. Use 0.0 to disable.", max_PL);
			return SendClientMessage(playerid, COLOR_SYNTAX, string);
		}
		if(pl >= 20.0 || pl < 0.0)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Max: 20.0, minimum: 0.0");
		}
		max_PL = pl;
		format(string, sizeof(string), "AdmCmd(%d): %s %s changed the packetloss limit to %.2f", ACMD_PLL, GetPlayerStatus(playerid), PlayerName(playerid), max_PL);
		SendAdminMessage(ACMD_PLL, string);
		AdminLog(string);
	}
	return 1;
}


CMD:pll(playerid, params[])
{
	cmd_packetlosslimit(playerid, params);
	return 1;
}

*/

CMD:packetloss(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_PL))
	{
		new targetid;
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /pl [ID]");
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid player name/ID");
		}
		new string[56];
		format(string, sizeof(string), "[INFO]: %s's(%d) packetloss: %.2f", PlayerName(targetid), targetid, NetStats_PacketLossPercent(targetid));
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	return 1;
}

CMD:pl(playerid, params[])
{
	cmd_packetloss(playerid, params);
	return 1;
}