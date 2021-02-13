stock CheckPlayerID(playerid, targetid, type = 1)
{
	if(targetid == INVALID_PLAYER_ID)
	{
		if(type == 1)
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Inavlid PlayerID/PlayerName");
		return 0;
	}
	if(!IsPlayerConnected(targetid))
	{
		if(type == 1)
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerID/PlayerName is not connected");
		return 0;
	}
	return 1;
}

new Tyres1[4] = {1, 2, 4, 8};
new Tyres2[6] = {3, 5, 6, 9, 10, 12};
new Tyres3[4] =	{7, 11, 13, 14};

CMD:poptyre(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new targetid, tyres;
		if(sscanf(params, "uI(1)", targetid, tyres))
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /poptyre [PlayerName/PlayerID] [Tyres(Optional: 1)]");
		if(!CheckPlayerID(playerid, targetid))
			return 1;
		if(tyres > 4 || tyres < 1)
		{
			tyres = 1;
			SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: There are only four breakable tyres in all vehicles. Tyre value changed to 1.");
		}
		new vehicleid = GetPlayerVehicleID(targetid);
		if(vehicleid == INVALID_VEHICLE_ID || !IsPlayerInAnyVehicle(targetid))
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The player is not in any vehicle.");
		new Panels, Doors, Lights, Tires;
		GetVehicleDamageStatus(vehicleid, Panels, Doors, Lights, Tires);
		switch(tyres)
		{
			case 1:
			{
				UpdateVehicleDamageStatus(vehicleid, Panels, Doors, Lights, Tyres1[random(4)]);
			}
			case 2:
			{
				UpdateVehicleDamageStatus(vehicleid, Panels, Doors, Lights, Tyres2[random(6)]);
			}
			case 3:
			{
				UpdateVehicleDamageStatus(vehicleid, Panels, Doors, Lights, Tyres3[random(4)]);
			}
			case 4:
			{
				UpdateVehicleDamageStatus(vehicleid, Panels, Doors, Lights, 15);
			}
		}
		new string[180];
		format(string, sizeof(string), "AdmCmd(%i): %s %s has popped %i tyre(s) of %s(%i)'s car.", AdminLvl(playerid), GetPlayerStatus(playerid), PlayerName(playerid), tyres, PlayerName(targetid), targetid);
		SendAdminMessage(AdminLvl(playerid), string);
	}
	return 1;
}

CMD:vhs(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new targetid, Float:slapamnt;
		if(sscanf(params, "uF(75.0)", targetid, slapamnt))
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /vhs [PlayerName/PlayerID] [Health]");
		if(!CheckPlayerID(playerid, targetid))
			return 1;
        new vehicleid = GetPlayerVehicleID(targetid);
		if(vehicleid == INVALID_VEHICLE_ID || !IsPlayerInAnyVehicle(targetid))
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The player is not in any vehicle.");
		if(slapamnt < 0.0)
		{
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Amount can not be less than 0.");
		}
		if(slapamnt > 250.0 && AdminLvl(playerid) < 3)
		{
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Amount can not be above 250.");
		}
		new Float:VehHealth;
		GetVehicleHealth(vehicleid, VehHealth);
		SetVehicleHealth(vehicleid, VehHealth-slapamnt);
		new string[180];
		format(string, sizeof(string), "AdmCmd(%i): %s %s has health slapped %s(%i)'s car(VehID: %i).", AdminLvl(playerid), GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid, vehicleid);
		SendAdminMessage(AdminLvl(playerid), string);
	}
	return 1;
}
