#include <foco>

#define CMD_SAVEMOD 4
#define SQ_cMultiplier 25000
#define MOD_TYPE_PUBLIC_VEHICLE 0
#define MOD_TYPE_PRIVATE_VEHICLE 1

new SQ_CmdTime[MAX_PLAYERS];
new VehicleModDetails[MAX_VEHICLES][15];
new VehiclePaintJob[MAX_VEHICLES];
new SQ_MSG[190];

stock N_GetVehicleComponentInSlot(vehicleid, slot)
{
	new CompID;
	if(slot>=0 && slot<=13)
	{
	    CompID = GetVehicleComponentInSlot(vehicleid, slot);
	}
	else if(slot==14)
	{
	    CompID = VehiclePaintJob[vehicleid];
	}
	return CompID;
}

stock N_AddVehicleComponent(vehicleid, slot, compid)
{
	if(slot>=0 && slot<=13)
	{
	    AddVehicleComponent(vehicleid, compid);
	}
	else if(slot==14)
	{
	    ChangeVehiclePaintjob(vehicleid, compid);
	}
	return 1;
}

stock SaveCarData(vehicleid)
{
	new flag;
	for(new mod=0; mod<15; mod++)
	{
	    VehicleModDetails[vehicleid][mod] = N_GetVehicleComponentInSlot(vehicleid, mod);
		if(mod<=13)
		{
		    if(VehicleModDetails[vehicleid][mod] != 0)
		        flag++;
		}
		if(mod==14)
		{
		    if(VehicleModDetails[vehicleid][mod] != 3)
		        flag++;
		}
	}
	if(flag==0)
	    return 2;
	return 1;
}

stock RemoveCarData(vehicleid)
{
	new flag;
	for(new mod=0; mod<15; mod++)
	{
		if(mod<=13)
		{
		    if(VehicleModDetails[vehicleid][mod] != 0)
			{
				flag++;
				RemoveVehicleComponent(vehicleid,VehicleModDetails[vehicleid][mod]);
	            VehicleModDetails[vehicleid][mod] = 0;
			}
		}
		if(mod==14)
		{
		    if(VehicleModDetails[vehicleid][mod] != 3)
			{
				flag++;
				ChangeVehiclePaintjob(vehicleid, 3);
	            VehicleModDetails[vehicleid][mod] = 3;
			}
		}

	}
	if(flag==0)
	    return 2;
	return 1;
}

stock SaveSQLData(playerid, vehicleid, MOD_TYPE)
{
	new query[250];
	if(MOD_TYPE==MOD_TYPE_PRIVATE_VEHICLE)
	{
		format(query, sizeof(query), "UPDATE `FoCo_Player_Vehicles` SET `cmt_spoiler` = '%d',`cmt_hood` = '%d',`cmt_rood` = '%d',`cmt_sideskirt` = '%d',`cmt_lamps` = '%d'", VehicleModDetails[vehicleid][0], VehicleModDetails[vehicleid][1], VehicleModDetails[vehicleid][2], VehicleModDetails[vehicleid][3], VehicleModDetails[vehicleid][4]);
		format(query, sizeof(query), "%s `cmt_nitro` = '%d',`cmt_exhaust` = '%d',`cmt_wheels` = '%d',`cmt_sterio` = '%d',`cmt_hydraulics` = '%d',`cmt_fb` = '%d'", query, VehicleModDetails[vehicleid][5], VehicleModDetails[vehicleid][6], VehicleModDetails[vehicleid][7], VehicleModDetails[vehicleid][8], VehicleModDetails[vehicleid][9], VehicleModDetails[vehicleid][10]);
		format(query, sizeof(query), "%s `cmt_rb` = '%d',`cmt_ventr` = '%d',`cmt_ventl` = '%d',`cmt_paint` = '%d' WHERE `ID`='%d';", query,  VehicleModDetails[vehicleid][11], VehicleModDetails[vehicleid][12], VehicleModDetails[vehicleid][13], VehicleModDetails[vehicleid][14], FoCo_Vehicles[vehid][cid]);
	}
	else if(MOD_TYPE==MOD_TYPE_PUBLIC_VEHICLE)
	{
		format(query, sizeof(query), "UPDATE `FoCo_Vehicles` SET `cmt_spoiler` = '%d',`cmt_hood` = '%d',`cmt_rood` = '%d',`cmt_sideskirt` = '%d',`cmt_lamps` = '%d'", VehicleModDetails[vehicleid][0], VehicleModDetails[vehicleid][1], VehicleModDetails[vehicleid][2], VehicleModDetails[vehicleid][3], VehicleModDetails[vehicleid][4]);
		format(query, sizeof(query), "%s `cmt_nitro` = '%d',`cmt_exhaust` = '%d',`cmt_wheels` = '%d',`cmt_sterio` = '%d',`cmt_hydraulics` = '%d',`cmt_fb` = '%d'", query, VehicleModDetails[vehicleid][5], VehicleModDetails[vehicleid][6], VehicleModDetails[vehicleid][7], VehicleModDetails[vehicleid][8], VehicleModDetails[vehicleid][9], VehicleModDetails[vehicleid][10]);
		format(query, sizeof(query), "%s `cmt_rb` = '%d',`cmt_ventr` = '%d',`cmt_ventl` = '%d',`cmt_paint` = '%d' WHERE `ID`='%d';", query,  VehicleModDetails[vehicleid][11], VehicleModDetails[vehicleid][12], VehicleModDetails[vehicleid][13], VehicleModDetails[vehicleid][14], FoCo_Vehicles[vehid][cid]);
	}
	else
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Something went wrong. Can not save the vehicle mods.");
	}
	mysql_query(query, MYSQL_FUNCTION_MOD, vehid, con);
	if(playerid>=0&& playerid<MAX_PLAYERS)
	    SQ_CmdTime[playerid]=gettime();
	return 1;
}

stock SQ_ModVehicle(vehicleid)
{
	for(new mod=0; mod<15; mod++)
	{
	    N_AddVehicleComponent(vehicleid, mod, VehicleModDetails[vehicleid][mod]);
	}
	return 1;
}


stock SQ_CalcMoney(playerid, vehicleid, OldComponents[])
{
	new TCash;
	for(new mod=0; mod<=14; mod++)
	{
	    if(mod<=13)
	    {
	        if(VehicleModDetails[vehicleid][mod]!=0&&OldComponents[mod]!=VehicleModDetails[vehicleid][mod])
	        {
	            TCash++;
	        }
	    }
	    else if(mod==14)
	    {
	        if(VehicleModDetails[vehicleid][mod]!=3&&OldComponents[mod]!=VehicleModDetails[vehicleid][mod])
	            TCash++;
	    }
	}
	TCash=TCash*SQ_cMultiplier;
	if(isVIP(playerid>0))
	    TCash=0;
	return TCash;
}

stock SQ_RemoveMod(playerid, vehicleid)
{
	new TCash;
	for(new mod=0; mod<=14; mod++)
	{
	    if(mod<=13)
	    {
	        if(VehicleModDetails[vehicleid][mod]!=0)
	        {
				RemoveVehicleComponent(vehicleid, VehicleModDetails[vehicleid][mod]);
				VehicleModDetails[vehicleid][mod]=0;
				TCash++;
	        }
	    }
	    else if(mod==14)
	    {
	        if(VehicleModDetails[vehicleid][mod]!=3)
			{
				ChangeVehiclePaintjob(vehicleid, 3);
				VehicleModDetails[vehicleid][mod]=3;
			    TCash++;
			}
		}
	}
	TCash=TCash*SQ_cMultiplier/2;
	return TCash;
}

CMD:buycarmod(playerid, params[])
{
	new TimeInt = gettime()-SQ_CmdTime[playerid];
	new vehicleid = GetPlayerVehicleID(playerid);
	if(TimeInt<=60)
	{
		format(SQ_MSG, sizeof(SQ_MSG), "[ERROR]: Please wait %d seconds before using the command again.", TimeInt);
		return SendClientMessage(playerid, COLOR_WARNING, SQ_MSG);
	}
	else
	{
		if(FoCo_Player[playerid][users_carid] == -1)
		{
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not own a vehicle.");
		}
		if(GetPVarInt(playerid, "VehSpawn")<=0)
		{
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your vehicle is not spawned yet.");
		}
		if(vehicleid != GetPVarInt(playerid, "VehSpawn"))
		{
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to be in your vehicle to use this command.");
		}
		if(FoCo_Vehicles[vehicleid][type] != VEHICLE_TYPE_PRIVATE)
		{
		    return SendClientMessage(plaeyrid, COLOR_WARNING, "[ERROR]: Looks like there has been a mixup b/w your vehicle and vehicleIDs. Contact IG-Lead Admin+.");
		}
		else if(vehicleid==GetPVarInt(playerid, "VehSpawn"))
		{
		    new SQ_TempModDetails[15];
		    for(new mod=0; mod<15; mod++)
		    {
				SQ_TempModDetails[mod] = VehicleModDetails[vehicleid][mod];
		    }
			if(SaveCarData(vehicleid)==1)
			{
			    new SQ_cRequired=SQ_CalcMoney(playerid, vehicleid, SQ_TempModDetails);
				if(GetPlayerMoney(playerid) > SQ_cRequired || SQ_cRequired == 0 )
				{
				    GivePlayerMoney(playerid, -1 * SQ_cRequired);
				    format(SQ_MSG, sizeof(SQ_MSG), "[NOTICE]: You have successfully bought the mods for $%i", SQ_cRequired);
				    SendClientMessage(playerid, COLOR_NOTICE, SQ_MSG);
					SaveSQLData(playerid, vehicleid, MOD_TYPE_PRIVATE_VEHICLE);
				}
				else
				{
	    		    for(new mod=0; mod<15; mod++)
				    {
						VehicleModDetails[vehicleid][mod] = SQ_TempModDetails[mod];
				    }
				    format(SQ_MSG, sizeof(SQ_MSG), "[ERROR]: You do not have enough money to buy these mods($%i).",SQ_cRequired);
				    return SendClientMessage(playerid, COLOR_WARNING, SQ_MSG);
				}
			}
			else
			{
			    SaveSQLData(playerid, vehicleid, MOD_TYPE_PRIVATE_VEHICLE);
			    return SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: No modifications found on vehicle.");
			}
		}
	}
	return 1;
}

CMD:savecarmod(playerid, params[])
{
	if(IsAdmin(playerid, CMD_SAVEMOD))
	{
		new TimeInt = gettime()-SQ_CmdTime[playerid];
		new vehicleid = GetPlayerVehicleID(playerid);
		if(TimeInt<=5)
		{
			format(SQ_MSG, sizeof(SQ_MSG), "[ERROR]: Please wait %d seconds before using the command.", TimeInt);
			return SendClientMessage(playerid, COLOR_WARNING, SQ_MSG);
		}
		else
		{
		    if(vehicleid!=0)
		    {
		        if(GetPlayerVehicleSeat(playerid)==0)
		        {
				    if(FoCo_Vehicles[vehicleid][type]==0)
					{
					    if(SaveCarData(vehicleid)==1)
						{
	    					format(SQ_MSG, sizeof(SQ_MSG), "AdmCmd(%d): %s %s has saved mods for Public Vehicle.(VehID:%i)", CMD_SAVEMOD, GetPlayerStatus(playerid), PlayerName(playerid), vehicleid);
				    		SendAdminMessage(CMD_SAVEMOD, SQ_MSG);
				    		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, SQ_MSG);
							format(SQ_MSG, sizeof(SQ_MSG), "[NOTICE]: You have successfully bought the mods for VehID:%i", vehicleid);
				    		SendClientMessage(playerid, COLOR_NOTICE, SQ_MSG);
							SaveSQLData(playerid, vehicleid, MOD_TYPE_PUBLIC_VEHICLE);
						}
						else
						{
						    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No modification found on vehicle.");
						}
					}
					else if(FoCo_Vehicles[vehicleid][type]==1)
					{
					    if(SaveCarData(vehicleid)==1)
						{
	    					format(SQ_MSG, sizeof(SQ_MSG), "AdmCmd(%d): %s %s has saved mods for Private Vehicle,(VehID: %i)", CMD_SAVEMOD, GetPlayerStatus(playerid), PlayerName(playerid), vehicleid);
				    		SendAdminMessage(CMD_SAVEMOD, SQ_MSG);
				    		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, SQ_MSG);
							format(SQ_MSG, sizeof(SQ_MSG), "[NOTICE]: You have successfully bought the mods for the Private Vehicle.");
				    		SendClientMessage(playerid, COLOR_NOTICE, SQ_MSG);
							SaveSQLData(playerid, vehicleid, MOD_TYPE_PRIVATE_VEHICLE);
						}
						else
						{
						    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No modification found on vehicle.");
						}
					}
					else
					{
					    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can save/remove only private/public vehicle mods.");
					}
				}
				else
				{
				    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to be the driver to use this command.");
				}
			}
			else
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to be in a vehicle to use this command.");
			}
		}
	}
	return 1;
}

CMD:deletecarmod(playerid, params[])
{
	if(IsAdmin(playerid, CMD_SAVEMOD))
	{
		new TimeInt = gettime()-SQ_CmdTime[playerid];
		new vehicleid = GetPlayerVehicleID(playerid);
		if(TimeInt<=5)
		{
			format(SQ_MSG, sizeof(SQ_MSG), "[ERROR]: Please wait %d seconds before using the command.", TimeInt);
			return SendClientMessage(playerid, COLOR_WARNING, SQ_MSG);
		}
		else
		{
		    if(vehicleid!=0)
		    {
		        if(GetPlayerVehicleSeat(playerid)==0)
		        {
				    if(FoCo_Vehicles[vehicleid][type] == VEHICLE_TYPE_PUBLIC)
					{
					    if(RemoveCarData(vehicleid)==1)
					    {
							format(SQ_MSG, sizeof(SQ_MSG), "AdmCmd(%d): %s %s has deleted mods for Public Vehicle,(VehID: %i)", CMD_SAVEMOD, GetPlayerStatus(playerid), PlayerName(playerid), vehicleid);
				    		SendAdminMessage(CMD_SAVEMOD, SQ_MSG);
				    		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, SQ_MSG);
							format(SQ_MSG, sizeof(SQ_MSG), "[NOTICE]: You have successfully removed the mods for the Public Vehicle.");
				    		SendClientMessage(playerid, COLOR_NOTICE, SQ_MSG);
					    	SaveSQLData(playerid, vehicleid, MOD_TYPE_PUBLIC_VEHICLE);
						}
						else
						{
						    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No modification found on vehicle.");
						}
					}
					else if(FoCo_Vehicles[vehicleid][type]==VEHICLE_TYPE_PRIVATE)
					{
					    if(RemoveCarData(vehicleid)==1)
					    {
     						format(SQ_MSG, sizeof(SQ_MSG), "AdmCmd(%d): %s %s has deleted mods for Private Vehicle,(VehID: %i)", CMD_SAVEMOD, GetPlayerStatus(playerid), PlayerName(playerid), vehicleid);
				    		SendAdminMessage(CMD_SAVEMOD, SQ_MSG);
				    		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, SQ_MSG);
							format(SQ_MSG, sizeof(SQ_MSG), "[NOTICE]: You have successfully removed the mods for the Private Vehicle.");
				    		SendClientMessage(playerid, COLOR_NOTICE, SQ_MSG);
					    	SaveSQLData(playerid, vehicleid, MOD_TYPE_PRIVATE_VEHICLE);
						}
						else
						{
						    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No modification found on vehicle.");
						}
					}
					else
					{
					    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can save/remove only private/public vehicle mods.");
					}
				}
				else
				{
				    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to be the driver to use this command.");
				}
			}
			else
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to be in a vehicle to use this command.");
			}
		}
	}
	return 1;
}


public OnVehicleSpawn(vehicleid)
{
	SQ_ModVehicle(vehicleid);
	return 1;
}
