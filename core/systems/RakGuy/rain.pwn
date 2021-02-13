#include <YSI\y_hooks>

new CurrentVehicle[MAX_PLAYERS],JumpToCar[MAX_PLAYERS],JumpToCarStrike[MAX_PLAYERS];
new JTC_MSG[128];
new JTC_AntiSpam[MAX_PLAYERS];

forward OnPlayerSwitchCar(playerid, oldvehicleid, newvehicleid);

hook OnPlayerConnect(playerid)
{
    CurrentVehicle[playerid]=0;
    JumpToCar[playerid]=0;
	JumpToCarStrike[playerid]=0;
	JTC_AntiSpam[playerid]=0;
    return 1;
}

public OnPlayerSwitchCar(playerid, oldvehicleid, newvehicleid)
{
	if(NetStats_GetConnectedTime(playerid)-JumpToCar[playerid]<100)
	{
		JumpToCarStrike[playerid]++;
		if(JumpToCarStrike[playerid]%5==0)
		{
		    if(NetStats_GetConnectedTime(playerid)-JTC_AntiSpam[playerid]>3000)
		    {
		        JTC_AntiSpam[playerid]=NetStats_GetConnectedTime(playerid);
				format(JTC_MSG, sizeof(JTC_MSG), "%s (%i) is possibly using Car-Rain/CarWrapper.", PlayerName(playerid),playerid);
	          	AntiCheatMessage(JTC_MSG);
			}
	 	}
	}
	else
		JumpToCarStrike[playerid]=0;
	return 1;
}

hook OnPlayerUpdate(playerid)
{
	if(CurrentVehicle[playerid]!= GetPlayerVehicleID(playerid))
	{
		CallRemoteFunction("OnPlayerSwitchCar", "iii", playerid, CurrentVehicle[playerid], GetPlayerVehicleID(playerid));
        JumpToCar[playerid]=NetStats_GetConnectedTime(playerid);
        CurrentVehicle[playerid]=GetPlayerVehicleID(playerid);
	}
	
	return 1;
}






















