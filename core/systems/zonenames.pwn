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
* Filename: zonenames.pwn                                                        *
* Author: dr_vista                                                               *
*********************************************************************************/

#include <YSI\y_hooks>

new PlayerText:ZoneTD[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
	ZoneTD[playerid] = CreatePlayerTextDraw(playerid, 84.000000, 429.625000, "_");
	PlayerTextDrawLetterSize(playerid, ZoneTD[playerid], 0.239500, 0.838747);
	PlayerTextDrawTextSize(playerid, ZoneTD[playerid], -1.000000, 200.375000);
	PlayerTextDrawAlignment(playerid, ZoneTD[playerid], 2);
	PlayerTextDrawColor(playerid, ZoneTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ZoneTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ZoneTD[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ZoneTD[playerid], 51);
	PlayerTextDrawFont(playerid, ZoneTD[playerid], 2);
	PlayerTextDrawSetProportional(playerid, ZoneTD[playerid], 1);
}

hook OnPlayerDisconnect(playerid)
{
	PlayerTextDrawDestroy(playerid, ZoneTD[playerid]);
}

hook OnPlayerSpawn(playerid)
{
	PlayerTextDrawShow(playerid, ZoneTD[playerid]);
}

hook OnPlayerDeath(playerid)
{
	PlayerTextDrawHide(playerid, ZoneTD[playerid]);
}

ptask zoneUpdate[1000](playerid)
{
	new zoneStr[28];
	GetPlayer2DZone(playerid, zoneStr, sizeof(zoneStr));
	PlayerTextDrawSetString(playerid, ZoneTD[playerid], zoneStr);
}