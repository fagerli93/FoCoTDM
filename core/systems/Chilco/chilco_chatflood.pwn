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
* Filename: chilco_chatflood .pwn                                                *
* Author: Chilco                                                                 *
*********************************************************************************/

new Chilco_LastTime[MAX_PLAYERS char];

forward Chilco_AF_OnPlayerText(playerid, text[]);
public Chilco_AF_OnPlayerText(playerid, text[])
{
	new ChatFlood = gettime();
	if(ChatFlood - Chilco_LastTime{playerid}<2)
	{
		SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Wait 1 second before sending another message.");
		return 0;
	}
	Chilco_LastTime{playerid} = ChatFlood;
	return 1;
}
