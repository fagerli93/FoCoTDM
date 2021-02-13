#include <YSI\y_hooks>

forward OnPlayerMoveOutofVehicle(playerid, vehid, SeatID);
forward DBWODriver(playerid, vehid, seatid);
forward OnPlayerMoveIntoVehicle(playerid, vehid, SeatID);

#define MAX_SEATS 10
//#define INVALID_WEAPON_ID 200

new InCarPlayerID[MAX_VEHICLES][MAX_SEATS];
new PlayerCar[MAX_PLAYERS];

hook OnGameModeInit()
{
	for(new i=0; i<MAX_VEHICLES; i++)
	{
	    for(new j=0; j<MAX_SEATS; j++)
			InCarPlayerID[i][j]=-1;
	}
	return 1;
}

hook OnPlayerConnect(playerid)
{
    PlayerCar[playerid]=0;
	return 1;
}

public OnPlayerMoveOutofVehicle(playerid, vehid, SeatID)
{
   	PlayerCar[playerid]=0;
    //DebugMsg("Move Out");
	new DB_MSG[50];
	format(DB_MSG, sizeof(DB_MSG), "%i %i %i", playerid, vehid, SeatID);
	//DebugMsg(DB_MSG);
	if(SeatID!=-1)
	{
		if(InCarPlayerID[vehid][SeatID]==playerid)
		{
			InCarPlayerID[vehid][SeatID]=-1;
			if(SeatID == 0)
			{
				for(new i = 1 ; i<MAX_SEATS; i++)
				{
					if(InCarPlayerID[vehid][i]!=-1)
					{
						if(IsPlayerConnected(InCarPlayerID[vehid][i]))
						{
						    if(IsPlayerInVehicle(InCarPlayerID[vehid][i], vehid))
							{
								GameTextForPlayer(InCarPlayerID[vehid][i],"~g~Do not Drive-By w/o driver. ~r~Please exit the vehicle.",3000,5);
								SetTimerEx("DBWODriver", 3000, false, "iii", InCarPlayerID[vehid][i], vehid, i);
								format(DB_MSG, sizeof(DB_MSG), "%i %i %i", i, InCarPlayerID[vehid][i], vehid);
								//DebugMsg(DB_MSG);
							}
							else
								InCarPlayerID[vehid][i]=-1;
						}
					}

				}
			}
		}
	}
	return 1;
}



public DBWODriver(playerid, vehid, seatid)
{
    //DebugMsg("TimerShit");
	if(IsPlayerInVehicle(playerid, vehid) && GetPlayerCameraMode(playerid)==55 && InCarPlayerID[vehid][0] == -1)
	{
	    SetPlayerArmedWeapon(playerid,0);
	    RemovePlayerFromVehicle(playerid);
   		PutPlayerInVehicle(playerid, vehid, seatid);
		GameTextForPlayer(playerid, "~r~Do not ~w~Drive-By w/o driver. ~n~~g~Your weapons have been reset.",3000,5);
		return 1;
	}
	else if(GetPlayerWeapon(playerid)!= 0 && GetPlayerCameraMode(playerid)!=55 && InCarPlayerID[vehid][0] == -1)
	{
	    SetPlayerArmedWeapon(playerid,0);
	}
	return 1;
}


public OnPlayerMoveIntoVehicle(playerid, vehid, SeatID)
{
	InCarPlayerID[vehid][SeatID]=playerid;
	//DebugMsg("Set");
	new DB_MSG[50];
	format(DB_MSG, sizeof(DB_MSG), "%i %i %i", playerid, vehid, SeatID);
	//DebugMsg(DB_MSG);
	if(InCarPlayerID[vehid][0]==-1)
	{
		if(IsPlayerInVehicle(playerid, vehid) && InCarPlayerID[vehid][0] == -1)
		{
		    SetPlayerArmedWeapon(playerid,0);
			GameTextForPlayer(playerid, "~r~Do not ~w~Drive-By w/o driver. ~n~~g~Your weapons reset.",3000,5);
			return 1;
		}
	}
	PlayerCar[playerid]=vehid;
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(oldstate == PLAYER_STATE_ONFOOT && (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER))
    {
		CallLocalFunction("OnPlayerMoveIntoVehicle", "iii", playerid, GetPlayerVehicleID(playerid), GetPlayerVehicleSeat(playerid));
	}
	if((newstate != PLAYER_STATE_DRIVER && newstate != PLAYER_STATE_PASSENGER) && (oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER))
	{
	    //DebugMsg("Called it");
		new MSG[50];
		format(MSG, sizeof(MSG), "%i %i",playerid, PlayerCar[playerid]);
		//DebugMsg(MSG);
		if(PlayerCar[playerid]!=0)
	    {
			new SeatID;
			for(new j=0; j<MAX_SEATS; j++)
			{
			    if(InCarPlayerID[PlayerCar[playerid]][j]==playerid)
				{
			        SeatID=j;
			        break;
				}
			}

			CallLocalFunction("OnPlayerMoveOutofVehicle", "iii", playerid, PlayerCar[playerid], SeatID);
			//DebugMsg("Called LocalShit");
	    }
	}
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	if(PlayerCar[playerid]!=0)
	{
		new SeatID;
		for(new j=0; j<MAX_SEATS; j++)
		{
		    if(InCarPlayerID[PlayerCar[playerid]][j]==playerid)
			{
		        SeatID=j;
		        break;
			}
		}
		CallLocalFunction("OnPlayerMoveOutofVehicle", "iii", playerid, PlayerCar[playerid], SeatID);
	}
}


hook OnPlayerExitVehicle(playerid, vehicleid)
{
	new SeatID;
	for(new j=0; j<MAX_SEATS; j++)
	{
	    if(InCarPlayerID[vehicleid][j]==playerid)
		{
	        SeatID=j;
	        break;
		}
	}
	CallLocalFunction("OnPlayerMoveOutofVehicle", "iii", playerid, vehicleid, SeatID);
	return 1;
}

CMD:sg(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to be a vehicle to use this command.");
	}
	if(GetPlayerVehicleSeat(playerid) == 0)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not use this command while being the driver of the vehicle");
	}
	if(InCarPlayerID[GetPlayerVehicleID(playerid)][0]==-1)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not use this command without a driver in vehicle.");
	}
	if(!IsPlayerInVehicle(InCarPlayerID[GetPlayerVehicleID(playerid)][0], GetPlayerVehicleID(playerid)) || GetPlayerVehicleSeat(InCarPlayerID[GetPlayerVehicleID(playerid)][0]) != 0)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player in driver seat might be bugged. Advice to re-enter.");
	}
	if(!IsCarDriveBy(GetVehicleModel(GetPlayerVehicleID(playerid))))
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not use this command in this vehicle");
	}
	new Type[10];
	if(sscanf(params, "S[9](Machine)", Type))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /scrollgun(sg) [WeaponType(default:SMG)]");
		SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: 1. Semi-Machine Gun - Mp5 | Uzi | Tec-9");
		SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: 2. Machine Gun - M4 | AK-47");
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: 3. Sniper - Country Rifle | Normal Sniper");
	}
	new SlotID;
	if(!isnull(Type))
	{
		if(!strcmp(Type, "28", true, 2) || !strcmp(Type, "29", true, 2) ||!strcmp(Type, "32", true, 2) || Type[0] == '1' || !strcmp(Type, "SMG", true, 3) || !strcmp(Type, "Semi", true, 3) || !strcmp(Type, "mp5", true, 2) || !strcmp(Type, "uzi", true, 3) || !strcmp(Type, "tec", true, 3))
		{
			//Semi-MachineGun;
			SlotID=4;
		}
		else if(!strcmp(Type, "31", true, 2)||!strcmp(Type, "30", true, 2) ||Type[0] == '2' || !strcmp(Type, "Machine", true, 4) || !strcmp(Type, "M4", true, 2) || !strcmp(Type, "AK47", true, 2))
		{
			//MachineGun;
			SlotID=5;
		}
		else if(!strcmp(Type, "33", true, 2) ||!strcmp(Type, "34", true, 2) || Type[0] == '3' || !strcmp(Type, "Sniper", true, 3) || !strcmp(Type, "Rifle", true, 3) || !strcmp(Type, "Country", true, 3))
		{
			//Sniper;
			SlotID=6;
		}
		else
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /scrollgun(sg) [WeaponType(default:Machine Gun)]");
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: 1. Semi-Machine Gun - Mp5 | Uzi | Tec-9");
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: 2. Machine Guy - M4 | AK-47");
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: 3. Sniper - Country Rifle | Normal Sniper");
		}
		GetPlayerWeaponData(playerid, SlotID, Type[0], Type[1]);
		if(Type[0] == 0)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not have any weapon of the specified type.");
		}
		SetPlayerArmedWeapon(playerid, Type[0]);
		return SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Weapon sucessfully swapped for Drive-By. Press H to Drive-By.");
	}
	return 1;
}

CMD:scrollgun(playerid, params[])
{
	cmd_sg(playerid, params);
	return 1;
}

CMD:switchgun(playerid, params[])
{
	cmd_sg(playerid, params);
	return 1;
}

CMD:swapgun(playerid, params[])
{
	cmd_sg(playerid, params);
	return 1;
}


stock IsCarDriveBy(modelid)
{
	switch(modelid)
	{
		case 406,417,425,430,435,441,446,447,449,450,452,453,454,460,464,465,469,472,473,476,484,486,487,488,493,497,501,511,512,513,519,520,530,532,537,538,539,548,553,563,564,569,570,571,572,577,584,590,591,592,593,594,595,606,607,608,610,611:
		{
			return 0;
		}
	}
	return 1;
}

/*stock GetWeaponSlot(weaponid)
{
	switch(weaponid)
	{
		case 0, 1: 
			return 0;
		case 2 ... 9: 
			return 1;
		case 22 ... 24: 
			return 2;
		case 25 ... 27: 
			return 3;
		case 28, 29, 32: 
			return 4;
		case 30, 31: 
			return 5;
		case 33, 34: 
			return 6;
		case 35 ... 38: 
			return 7;
		case 16, 17, 18, 39: 
			return 8;
		case 41 ... 43: 
			return 9;
		case 10 ... 15: 
			return 10;
		case 44 ... 46: 
			return 11;
		case 40: 	
			return 12;
		default: 
			return INVALID_WEAPON_ID;
	}
	return INVALID_WEAPON_ID;
}*/














