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
* Filename: pEar_CheckGCPI.pwn                                                	 *
* Author: pEar	                                                                 *
*********************************************************************************/


native gpci (playerid, serial [], len); 

CMD:gpci(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_GPCI))
	{
		new playerip[16], playerserial[128], targetid, string[256];
		if (sscanf(params, "u", targetid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /gpci [ID/Name]");
			return 1;
		}
		gpci(targetid, playerserial, sizeof(playerserial));
		GetPlayerIp(playerid, playerip, sizeof(playerip));
		
		format(string, sizeof(string), "%s's(%d) gpci is '%s' and his IP is: %d", PlayerName(targetid), targetid, playerserial, playerip);
		SendClientMessage(playerid, COLOR_GREEN, string);
	}
	
	return 1;
}