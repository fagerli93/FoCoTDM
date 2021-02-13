#include <foco>
new CurrentVehicle[MAX_PLAYERS],JumpToCar[MAX_PLAYERS],JumpToCarStrike[MAX_PLAYERS];
new JTC_MSG[128];

forward OnPlayerSwitchCar(playerid, oldvehicleid, newvehicleid);

public OnPlayerConnect(playerid)
{
    CurrentVehicle[playerid]=0;
    JumpToCar[playerid]=0;
	JumpToCarStrike[playerid]=0;
    return 1;
}

public OnPlayerSwitchCar(playerid, oldvehicleid, newvehicleid)
{
	format(JTC_MSG, sizeof(JTC_MSG), "old: %i - %i ;; new %i - %i",oldvehicleid,JumpToCar[playerid], newvehicleid,NetStats_GetConnectedTime(playerid));
	SendClientMessage(playerid, -1, JTC_MSG);
	if(NetStats_GetConnectedTime(playerid)-JumpToCar[playerid]<200)
	{
		JumpToCarStrike[playerid]++;
		if(JumpToCarStrike[playerid]-1%10==0)
		{
			format(JTC_MSG, sizeof(JTC_MSG), "%s (%i) is possibly using Car-Rain/CarWrapper.", PlayerName(playerid),playerid);
          	AntiCheatMessage(JTC_MSG);
 		}
	}
	else
		JumpToCarStrike[playerid]=0;
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(CurrentVehicle[playerid]!= GetPlayerVehicleID(playerid))
	{
		CallRemoteFunction("OnPlayerSwitchCar", "iii", playerid, CurrentVehicle[playerid], GetPlayerVehicleID(playerid));
        JumpToCar[playerid]=NetStats_GetConnectedTime(playerid);
        CurrentVehicle[playerid]=GetPlayerVehicleID(playerid);
	}
	return 1;
}






















