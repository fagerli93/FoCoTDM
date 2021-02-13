#include <YSI\y_hooks>

new CC_MSG[128];
hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(oldstate == PLAYER_STATE_PASSENGER && newstate == PLAYER_STATE_DRIVER) // Player entered a vehicle as a driver from PASSENGER
    {
        if(GetPlayerVehicleID(playerid)!=CurrentVehicle[playerid])
            CurrentVehicle[playerid]=GetPlayerVehicleID(playerid);
		foreach (new i : Player)
		{
		    if(i != playerid && GetPlayerVehicleID(i) == CurrentVehicle[playerid] && GetPlayerVehicleSeat(i)==0 )
		    {
		        format(CC_MSG, sizeof(CC_MSG), "%s (%i) is possibly using car_control.cs. [Affected Player: %s[%i]]", PlayerName(playerid),playerid, PlayerName(i), i);
				AntiCheatMessage(CC_MSG);
				return 1;
			}
		}
    }
    return 1;
}















