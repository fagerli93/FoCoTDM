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
*																				 *	
*                                                                                *
*                        (c) Copyright                                           *
*  Owners: Simon Fagerli (pEar) - Lee Percox (Shaney) - Warren Bickley (WazzaJB) *
*         Developers: Marcel, RakGuy, FKu, Chilco, dr_vista, Fletcher            *
*                                                                                *
* Filename: loccmd.pwn                                                           * 
* Author: dr_vista                                                               *
*********************************************************************************/

#include <YSI\y_hooks>

static
		locenabled;
		
forward GetPlayerBearing(Float:pX, Float:pY, Float:tX, Float:tY);
		
hook OnGameModeInit()
{
	locenabled = true;
}

CMD:loc(playerid, params[])
{
	if(!locenabled)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The command is disabled at the moment.");
	}
	
	static 
			pID;
			
	if(sscanf(params, "u", pID))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /loc [ID]");
	}
	
	if(pID == INVALID_PLAYER_ID)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player not connected.");
	}
	
	/*if(pID == cellmin)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Multiple matches found, be more specific.");
	}*/
	
	static
			zoneStr[28], 
			string[128],
			bearingString[11],
			Float:pX,
			Float:pY,
			Float:tX,
			Float:tY,
			Float:tZ;
			
	GetPlayer2DZone(pID, zoneStr, sizeof(zoneStr));
	GetPlayerPos(playerid, pX, pY, tZ);
	GetPlayerPos(pID, tX, tY, tZ);
	format(bearingString, sizeof(bearingString), "%s", GetPlayerBearing(pX, pY, tX, tY));
	format(string, sizeof(string), "[INFO]: %s (%d)'s Location: %s (%s)", PlayerName(pID), pID, zoneStr, bearingString);
	SendClientMessage(playerid, COLOR_NOTICE, string);
			
	return 1;
}

CMD:disableloc(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_DISABLELOC))
	{
		if(locenabled)
		{
			static
					string[128];
					
			locenabled = false;
			SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: /loc has been disabled");
			format(string, sizeof(string), "AdmCmd(%d): %s %s has disabled /loc.", ACMD_DISABLELOC, GetPlayerStatus(playerid), PlayerName(playerid));
			SendAdminMessage(ACMD_DISABLELOC, string);
		}
		
		else
		{
			static
					string[128];
					
			locenabled = true;
			SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: /loc has been enabled");
			format(string, sizeof(string), "AdmCmd(%d): %s %s has enabled /loc.", ACMD_DISABLELOC, GetPlayerStatus(playerid), PlayerName(playerid));
			SendAdminMessage(ACMD_DISABLELOC, string);
		}
	}
	
	return 1;

}

static GetPlayerBearing(Float:pX, Float:pY, Float:tX, Float:tY)
{
	new bearingStr[11], Float:bearing;

	bearing =-(90+(atan2(pY - tY, pX - tX)));
	if(bearing < 0)
	{
	    bearing += 360;
	}
	
	if(bearing >= 0 && bearing < 45)
	{
	    bearingStr = "North";
	}
	
	else if(bearing >= 45 && bearing < 90)
	{
		bearingStr = "North East";
	}
	
	else if(bearing >= 90 && bearing < 135)
	{
		bearingStr = "East";
	}

	else if(bearing >= 135 && bearing < 180)
	{
		bearingStr = "South East";
	}
	
	else if(bearing >= 180 && bearing < 225)
	{
	    bearingStr = "South";
	}
	
	else if(bearing >= 225 && bearing < 270)
	{
	    bearingStr = "South West";
	}
	
	else if(bearing >= 270 && bearing < 315)
	{
	    bearingStr = "West";
	}
	
	else if(bearing >= 315 && bearing < 360)
	{
	    bearingStr = "North West";
	}
	
	return bearingStr;
}
