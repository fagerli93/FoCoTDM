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
* Filename: chilco_anticarwarp.pwn                                               *
* Author: Chilco                                                                 *
*********************************************************************************/
/*

Callbacks used:
* public Dev_Chilco_Acw_OnPlayerStateChange(playerid, newstate, oldstate)
* Acw = Anti car warp

*/

#include <YSI\y_hooks>
forward Two_Seconds_After_Entering_Veh(playerid);
forward Carwarpwarning_Cooldown(playerid);
new anti_carwarp_timer[MAX_PLAYERS];

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
    {
        if(FoCo_Player[playerid][admin] < 1)
        {
	    	if(GetPVarInt(playerid, "Entered_Vehicles_Amount") == 0) // If the player hasn't entered any cars recently.
	  		{
	 			anti_carwarp_timer[playerid] = SetTimerEx("Two_Seconds_After_Entering_Veh", 2000, false, "d", playerid); // 2 sec timer starts
			}
			new amount;
			amount = GetPVarInt(playerid, "Entered_Vehicles_Amount")+1;
			SetPVarInt(playerid, "Entered_Vehicles_Amount", amount); // Amount of cars entered +1.
		}
    }
	return 1;
}


public Two_Seconds_After_Entering_Veh(playerid)
{
	new str[170];
	if(GetPVarInt(playerid, "Entered_Vehicles_Amount") > 2) // Three or more vehicles entered within 2 sec.
	{
	    format(str,sizeof(str),"[Guardian]: {ff6347}Carwarper detected [Player: %s (%d)]", PlayerName(playerid), playerid);
	    if(GetPVarInt(playerid, "Recent_Carwarp_Warning") == 0)
	    {
	        SetPVarInt(playerid, "Recent_Carwarp_Warning", 1);
	    	SetTimerEx("Carwarpwarning_Cooldown", 20000, false, "d", playerid); // 20 sec cooldown timer until the warning appears again.
			SendAdminMessage(1, str);
			CheatLog(str);
		}
		SetPVarInt(playerid, "Entered_Vehicles_Amount", 0); // Resets the amount back to 0.
		KillTimer(anti_carwarp_timer[playerid]); // Kills the timer to avoid spam issues.
	}
	KillTimer(anti_carwarp_timer[playerid]);
	SetPVarInt(playerid, "Entered_Vehicles_Amount", 0); // Resets the amount back to 0.

}

public Carwarpwarning_Cooldown(playerid)
{
    SetPVarInt(playerid, "Recent_Carwarp_Warning", 0);
}
