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
* Filename: chilco_acs    .pwn                                                   *
* Author: Chilco                                                                 *
*********************************************************************************/
#include <YSI\y_hooks>

CMD:acs(playerid, params[])
{
	new target;
	if(IsAdmin(playerid,3))
	{
		if(sscanf(params, "u",target))
		{
			SendClientMessage(playerid, 0x999999FF, "USAGE: /acs [playerID]");
		}
		else
		{
	 		if(target == INVALID_PLAYER_ID)
		 	{
	 			SendClientMessage(playerid, 0x999999FF, "Invalid ID.");
		 		return 1;
			}
			new Float:XPose,Float:YPose,Float:ZPose;
			GetPlayerPos(target, XPose, YPose, ZPose);
			SetPVarFloat(target, "XPos", XPose);
			SetPVarFloat(target, "YPos", YPose);
			SetPVarFloat(target, "ZPos", ZPose);
			SetPlayerVelocity(target,2.0,0.0,0.1);
			SetTimerEx("ACS", 100, false, "d", target);
		}
	}
	return 1;
}

forward ACS(playerid);
public ACS(playerid)
{
	new Float:XPose,Float:YPose,Float:ZPose;
	XPose = GetPVarFloat(playerid, "XPos");
	YPose = GetPVarFloat(playerid, "YPos");
	ZPose = GetPVarFloat(playerid, "ZPos");
    SetPlayerPos(playerid, XPose, YPose, ZPose);

}
