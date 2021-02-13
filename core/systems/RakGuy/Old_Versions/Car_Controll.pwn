#include <YSI\y_hooks>

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(oldstate == PLAYER_STATE_PASSENGER && newstate == PLAYER_STATE_DRIVER) // Player entered a vehicle as a driver from PASSENGER
    {
        new vehicleid = GetPlayerVehicleID(playerid);
       	new MSGz[100];
		foreach (new i : Player)
		{
		    SendClientMessageToAll(-1, MSGz);
		    if(i!=playerid &&GetPlayerVehicleID(i)== vehicleid &&GetPlayerVehicleSeat(i)==0)
		    {
		        format(MSGz, sizeof(MSGz), "%s (%i) is possibly using car_control.cs. [Affected Player: %s[%i]]", PlayerName(playerid),playerid, PlayerName(i), i);
				AntiCheatMessage(MSGz);
				return 1;
			}
		}
    }
    return 1;
}















