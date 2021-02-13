#include <YSI\y_hooks>
//#include <foco>

new S_MSG[128];
new SwapCar[MAX_PLAYERS][10];
new SwapCarVar[MAX_PLAYERS][5];
new FakeDeath[MAX_PLAYERS];
new bool:IsDead[MAX_PLAYERS];
new bool:OPEV_Called[MAX_PLAYERS];
new bool:VehJacked[MAX_VEHICLES];
/*
0 = Switch Strike
1 = Switched Car
2 = Switch Time
3 = Anti-AntiCheat Spam
4 = AutoBan
*/

forward S_OnPlayerSwitchCar(playerid, oldvehicleid, newvehicleid);

hook OnGameModeInit()
{
	for(new i =0; i<MAX_PLAYERS; i++)
	    ClearTStrikes(i);
    return 1;
}

hook OnPlayerConnect(playerid)
{
    SwapCarVar[playerid][1] = 0;
    ClearTStrikes(playerid);
    SwapCarVar[playerid][2] = 0;
    SwapCarVar[playerid][3] = gettime() - 4;
    SwapCarVar[playerid][4] = 0;
    FakeDeath[playerid] = 0;
    IsDead[playerid] = true;
    OPEV_Called[playerid] = false;
    return 1;
}

stock ClearTStrikes(playerid)
{
	for(new i = 0; i<10; i++)
	    SwapCar[playerid][i] = INVALID_VEHICLE_ID;
    SwapCarVar[playerid][0] = 0;
	return 1;
}

public S_OnPlayerSwitchCar(playerid, oldvehicleid, newvehicleid)
{
	DebugMsg("1");
	new SwapTemp = SwapCarVar[playerid][1];
	SwapCarVar[playerid][2] = newvehicleid;
	SwapCarVar[playerid][1] = NetStats_GetConnectedTime(playerid);
	if(OPEV_Called[playerid] == true)
    {
        OPEV_Called[playerid] = false;
		return 1;
    }
    DebugMsg("2");
	if(NetStats_GetConnectedTime(playerid) - SwapTemp < 500)
	{
		if(SwapCarVar[playerid][0] >= 1 && gettime() - SwapCarVar[playerid][3] > 4)
		{
			format(S_MSG, sizeof(S_MSG), "%s(%i) is fast-switching cars.", PlayerName(playerid), playerid);
			AntiCheatMessage(S_MSG);
			SwapCarVar[playerid][3] = gettime();
            SwapCarVar[playerid][4]++;
			/*if(SwapCarVar[playerid][4] % 3 == 0 && AdminsOnline() == 0)
				ABanPlayer(-1, playerid, "SwitchCar");*/
		}
	}
	else
	{
	    ClearTStrikes(playerid);
	}
	SwapCarVar[playerid][0]++;
	return 1;
}
hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	OPEV_Called[playerid]=true;
	VehJacked[vehicleid]=true;
	return 1;
}


hook OnPlayerUpdate(playerid)
{
	if(SwapCarVar[playerid][2] != GetPlayerVehicleID(playerid))
	{
		CallRemoteFunction("S_OnPlayerSwitchCar", "iii", playerid, SwapCarVar[playerid][2], GetPlayerVehicleID(playerid));
	}
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	format(S_MSG, sizeof(S_MSG), "%s: OldID: %i NewID: %i [OPEV: %i || VEHJACK: %i]", PlayerName(playerid), SwapCarVar[playerid][2], GetPlayerVehicleID(playerid), OPEV_Called[playerid], VehJacked[GetPlayerVehicleID(playerid)]);
	DebugMsg(S_MSG);
	if(newstate == PLAYER_STATE_DRIVER)
		if(OPEV_Called[playerid] == true)
		    OPEV_Called[playerid] = false;
	if((oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER) && VehJacked[SwapCarVar[playerid][2]] == true)
	{
 		OPEV_Called[playerid] = true;
		VehJacked[SwapCarVar[playerid][2]] = false;
	}
	return 1;
}

/*hook OnPlayerDeath(playerid, killerid, reason)
{
	if(IsDead[playerid]==true)
	{
	    FakeDeath[playerid]++;
	    if(FakeDeath[playerid] %5 == 0)
	    {
	        ABanPlayer(-1, playerid, "FakeDeath");
	    }
	    return 1;
	}
	else
    	IsDead[playerid] = true;
	return 1;
}*/

hook OnPlayerSpawn(playerid)
{
	IsDead[playerid] = false;
	return 1;
}

















