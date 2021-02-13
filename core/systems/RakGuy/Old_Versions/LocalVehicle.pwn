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
* Filename: localvehicle.pwn                                                     *
* Author:   RakGuy                                                               *
*********************************************************************************/

///////////////////Limit Changer for pEar[Dad]//////////////
#define ACMD_LOCALNOS 3 //Local commands
#define ACMD_ALLNOS 4 //Give/Remove Nos to/from all
#define ACMD_PLAYCOMP 1 //Remove/Add Player's Nos
#define ACMD_VEHCOMP 2 //Ramove/Add Vehicle Nos
////////////////////////////Till here///////////////////////
new ply_veh_id;
new LCL_NOS_MSG[150];
new Float:LCL_NOS_XYZRH[5];

CMD:givelocalnos(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_LOCALNOS)==1)
	{
		
		if(sscanf(params, "f", LCL_NOS_XYZRH[3]))
		{
			SendClientMessage(playerid, COLOR_SYNTAX,"Usage: /givelocalnos [Radius]");
		}
		else
		{
		    if((IsAdmin(playerid, ACMD_ALLNOS)==0&&LCL_NOS_XYZRH[3]>50.0)||LCL_NOS_XYZRH[3]<5.0)
		    {
		        SendClientMessage(playerid, COLOR_WARNING, "[ERROR] You have to select a radius between 5m and 50m");
		    }
		    else
			{
				GetPlayerPos(playerid, LCL_NOS_XYZRH[0], LCL_NOS_XYZRH[1], LCL_NOS_XYZRH[2]);
				for(new i=0; i<MAX_VEHICLES; i++)
				{
				    	if(GetVehicleModel(i) != 0)
						{
							if(GetVehicleDistanceFromPoint(i, LCL_NOS_XYZRH[0], LCL_NOS_XYZRH[1], LCL_NOS_XYZRH[2])<=LCL_NOS_XYZRH[3])
							{
							    if(GetVehicleVirtualWorld(i)==GetPlayerVirtualWorld(playerid))
							    {
									AddVehicleComponent(i, 1010);
								}
							}
						}
				}
				format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "AdmCmd(%i): %s %s has added NOS to cars around radius %f", ACMD_LOCALNOS, GetPlayerStatus(playerid),PlayerName(playerid),LCL_NOS_XYZRH[3]);
				SendAdminMessage(ACMD_LOCALNOS,LCL_NOS_MSG);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, LCL_NOS_MSG);
			}
		}
	}
	return 1;
}

CMD:givenostoall(playerid, params[])
{
    if(IsAdmin(playerid,  ACMD_ALLNOS)==1)
	{
		foreach(Player, i)
		{
			if(IsPlayerInAnyVehicle(i)==1)
			{
				AddVehicleComponent(GetPlayerVehicleID(i), 1010);
			}
		}
		format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "AdmCmd(%i): %s %s has added NOS to all players's current vehicles.", ACMD_ALLNOS, GetPlayerStatus(playerid),PlayerName(playerid),LCL_NOS_XYZRH[3]);
		SendAdminMessage(ACMD_ALLNOS,LCL_NOS_MSG);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, LCL_NOS_MSG);
		format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "[NOTICE:] %s %s has added NOS to all players' current vehicles.", GetPlayerStatus(playerid),PlayerName(playerid),LCL_NOS_XYZRH[3]);
		SendClientMessageToAll(COLOR_NOTICE, LCL_NOS_MSG);
	}
	return 1;
}

CMD:removenosfromall(playerid, params[])
{
    if(IsAdmin(playerid,  ACMD_ALLNOS)==1)
	{
		foreach(Player, i)
		{
			if(IsPlayerInAnyVehicle(i)==1)
			{
				RemoveVehicleComponent(GetPlayerVehicleID(i), 1010);
				RemoveVehicleComponent(GetPlayerVehicleID(i), 1009);
   				RemoveVehicleComponent(GetPlayerVehicleID(i), 1008);
			}
		}
		format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "AdmCmd(%i): %s %s has removed NOS from all players' current vehicles.", ACMD_ALLNOS, GetPlayerStatus(playerid),PlayerName(playerid),LCL_NOS_XYZRH[3]);
		SendAdminMessage(ACMD_ALLNOS,LCL_NOS_MSG);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, LCL_NOS_MSG);
		format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "[NOTICE:] %s %s has removed NOS from all players' current vehicles.", GetPlayerStatus(playerid),PlayerName(playerid),LCL_NOS_XYZRH[3]);
		SendClientMessageToAll(COLOR_NOTICE, LCL_NOS_MSG);
	}
	return 1;
}

CMD:removelocalnos(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_LOCALNOS)==1)
	{

		if(sscanf(params, "f", LCL_NOS_XYZRH[3]))
		{
			SendClientMessage(playerid, COLOR_SYNTAX,"Usage: /removelocalnos [Radius]");
		}
		else
		{
  			if((IsAdmin(playerid, ACMD_ALLNOS)==0&&LCL_NOS_XYZRH[3]>50.0)||LCL_NOS_XYZRH[3]<5.0)
		    {
		        SendClientMessage(playerid, COLOR_WARNING, "[ERROR] You have to select a radius between 5m and 50m");
		    }
		    else
			{
	   			GetPlayerPos(playerid, LCL_NOS_XYZRH[0], LCL_NOS_XYZRH[1], LCL_NOS_XYZRH[2]);
				for(new i=0; i<MAX_VEHICLES; i++)
				{
			 			if(GetVehicleModel(i) != 0)
						{
							if(GetVehicleDistanceFromPoint(i, LCL_NOS_XYZRH[0], LCL_NOS_XYZRH[1], LCL_NOS_XYZRH[2])<=LCL_NOS_XYZRH[3])
							{
							    if(GetVehicleVirtualWorld(i)==GetPlayerVirtualWorld(playerid))
							    {
									RemoveVehicleComponent(i, 1010);
						            RemoveVehicleComponent(i, 1009);
						           	RemoveVehicleComponent(i, 1008);
								}
							}
						}
				}
				format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "AdmCmd(%i): %s %s has removed NOS from cars around radius %f", ACMD_LOCALNOS, GetPlayerStatus(playerid),PlayerName(playerid), LCL_NOS_XYZRH[3]);
				SendAdminMessage(ACMD_LOCALNOS,LCL_NOS_MSG);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, LCL_NOS_MSG);
			}
		}
	}
	return 1;
}

CMD:givenos(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_PLAYCOMP)==1)
	{
		if(sscanf(params, "u",ply_veh_id))
		{
		    if(IsPlayerInAnyVehicle(playerid)==0)
		    {
				return SendClientMessage(playerid, COLOR_SYNTAX,"Usage: /givenos [PlayerID/PartOfName]");
			}
			else
			{
			    format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "[NOTICE:] You have added 10x NOS to your vehicle.");
				SendClientMessage(playerid, COLOR_CMDNOTICE, LCL_NOS_MSG);
                format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "AdmCmd(%i): %s %s has given 10xNos to %s",ACMD_PLAYCOMP, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(playerid));
                SendAdminMessage(ACMD_PLAYCOMP,LCL_NOS_MSG);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, LCL_NOS_MSG);
                return 1;
			}
		}
		else
		{
		    if(!IsPlayerConnected(ply_veh_id))
			{
			    SendClientMessage(playerid, COLOR_WARNING, "Invalid PlayerID/PartOfName");
			}
			else if(IsPlayerInAnyVehicle(ply_veh_id)==1)
		    {
		    	AddVehicleComponent(GetPlayerVehicleID(ply_veh_id), 1010);
				format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "[NOTICE:] %s %s has added 10xNOS to your vehicle.",GetPlayerStatus(playerid),PlayerName(playerid));
				SendClientMessage(ply_veh_id, COLOR_NOTICE, LCL_NOS_MSG);
				format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "[NOTICE:] You have given 10x NOS to %s", PlayerName(ply_veh_id));
				SendClientMessage(playerid, COLOR_CMDNOTICE, LCL_NOS_MSG);
                format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "AdmCmd(%i): %s %s has given 10xNos to %s",ACMD_PLAYCOMP, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(ply_veh_id));
                SendAdminMessage(ACMD_PLAYCOMP,LCL_NOS_MSG);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, LCL_NOS_MSG);
			}
			else
			{
				SendClientMessage(playerid, COLOR_WARNING, "Player is not in any vehicle");
			}
		}
	}
	return 1;
}

CMD:placenos(playerid, params[])
{
	if(IsAdmin(playerid,ACMD_VEHCOMP)==1)
	{
		if(sscanf(params, "i",ply_veh_id))
		{
		    if(IsPlayerInAnyVehicle(playerid)==0)
		    {
				return SendClientMessage(playerid, COLOR_SYNTAX,"Usage: /placenos [VehicleID]");
			}
			else
			{
				ply_veh_id=GetPlayerVehicleID(playerid);
				AddVehicleComponent(ply_veh_id, 1010);
				format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "[NOTICE:] You have placed 10x NOS in your vehicle, VehID:%i", ply_veh_id);
				SendClientMessage(playerid, COLOR_CMDNOTICE, LCL_NOS_MSG);
	    		format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "AdmCmd(%i): %s %s has placed 10xNos in VehID(%i)",ACMD_VEHCOMP, GetPlayerStatus(playerid), PlayerName(playerid),ply_veh_id);
	            SendAdminMessage(ACMD_VEHCOMP,LCL_NOS_MSG);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, LCL_NOS_MSG);
				return 1;
			}
		}
		else
		{
			if(GetVehicleModel(ply_veh_id) == 0)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  That vehicle does not exist.");
				return 1;
			}
			else
			{
			    AddVehicleComponent(ply_veh_id, 1010);
				format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "[NOTICE:] You have placed 10x NOS in VehID:%i", ply_veh_id);
				SendClientMessage(playerid, COLOR_CMDNOTICE, LCL_NOS_MSG);
				format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "AdmCmd(%i): %s %s has placed 10xNos in VehID(%i)",ACMD_VEHCOMP, GetPlayerStatus(playerid), PlayerName(playerid),ply_veh_id);
	            SendAdminMessage(ACMD_VEHCOMP,LCL_NOS_MSG);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, LCL_NOS_MSG);
				return 1;
			}
		}
	}
	return 1;
}

CMD:removenos(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_PLAYCOMP)==1)
	{
		if(sscanf(params, "u",ply_veh_id))
		{
			SendClientMessage(playerid, COLOR_SYNTAX,"Usage: /removenos [PlayerID/PartOfName]");
		}
		else
		{
  			if(!IsPlayerConnected(ply_veh_id))
			{
			    SendClientMessage(playerid, COLOR_WARNING, "Invalid PlayerID/PartOfName");
			}
			else if(IsPlayerInAnyVehicle(ply_veh_id)==1)
		    {
		    	RemoveVehicleComponent(GetPlayerVehicleID(ply_veh_id), 1010);
                RemoveVehicleComponent(GetPlayerVehicleID(ply_veh_id), 1009);
                RemoveVehicleComponent(GetPlayerVehicleID(ply_veh_id), 1008);
				format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "[NOTICE:] %s %s has removed NOS from your vehicle.",GetPlayerStatus(playerid), PlayerName(playerid));
				SendClientMessage(ply_veh_id, COLOR_NOTICE, LCL_NOS_MSG);
    			format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "[NOTICE:] You have removed NOS from %s", PlayerName(ply_veh_id));
				SendClientMessage(playerid, COLOR_CMDNOTICE, LCL_NOS_MSG);
				format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "AdmCmd(%i): %s %s has removed NOS from %s",ACMD_PLAYCOMP, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(ply_veh_id));
                SendAdminMessage(ACMD_PLAYCOMP,LCL_NOS_MSG);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, LCL_NOS_MSG);
			}
			else
			{
				SendClientMessage(playerid, COLOR_WARNING, "Player is not in any vehicle");
			}
		}
	}
	return 1;
}

CMD:deletenos(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_VEHCOMP)==1)
	{
		if(sscanf(params, "i", ply_veh_id))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX,"Usage: /deletenos [VehicleID]");
		}
		else
		{
		    if(GetVehicleModel(ply_veh_id) != 0)
			{
				RemoveVehicleComponent(ply_veh_id, 1010);
	            RemoveVehicleComponent(ply_veh_id, 1009);
	           	RemoveVehicleComponent(ply_veh_id, 1008);
				format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "[NOTICE:] You have removed NOS from VehID:%i", ply_veh_id);
				SendClientMessage(playerid, COLOR_CMDNOTICE, LCL_NOS_MSG);
				format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "AdmCmd(%i): %s %s has removed NOS from VehID(%i)", ACMD_VEHCOMP, GetPlayerStatus(playerid), PlayerName(playerid),ply_veh_id);
	            SendAdminMessage(ACMD_VEHCOMP,LCL_NOS_MSG);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, LCL_NOS_MSG);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  That vehicle does not exist.");
			}
			return 1;
		}
	}
	return 1;
}

CMD:repairlocalcars(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_LOCALNOS)==1)
	{
		if(sscanf(params, "fF(1000.0)", LCL_NOS_XYZRH[3], LCL_NOS_XYZRH[4]))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX,"Usage: /repairlocalcars [Radius] [Health[OPT]]");
		}
		else
		{
  			if((IsAdmin(playerid, ACMD_ALLNOS)==0&&LCL_NOS_XYZRH[3]>50.0)||LCL_NOS_XYZRH[3]<5.0)
		    {
		        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR] You have to select a radius between 5m and 50m");
		    }
		    else
			{
				GetPlayerPos(playerid, LCL_NOS_XYZRH[0], LCL_NOS_XYZRH[1], LCL_NOS_XYZRH[2]);
                for(new i=0; i<MAX_VEHICLES; i++)
				{
				    if(GetVehicleModel(i) != 0)
					{
						if(GetVehicleDistanceFromPoint(i, LCL_NOS_XYZRH[0], LCL_NOS_XYZRH[1], LCL_NOS_XYZRH[2])<=LCL_NOS_XYZRH[3])
						{
						    if(GetVehicleVirtualWorld(i)==GetPlayerVirtualWorld(playerid))
						    {
								if(LCL_NOS_XYZRH[4]>=1000.0)
								{
								    RepairVehicle(i);
								}
								SetVehicleHealth(i, LCL_NOS_XYZRH[4]);
							}
						}
					}
				}
				format(LCL_NOS_MSG, sizeof(LCL_NOS_MSG), "AdmCmd(%i): %s %s has set health of cars inside radius %f to %f", ACMD_LOCALNOS, GetPlayerStatus(playerid), PlayerName(playerid),LCL_NOS_XYZRH[3],LCL_NOS_XYZRH[4]);
				SendAdminMessage(ACMD_LOCALNOS,LCL_NOS_MSG);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, LCL_NOS_MSG);
				return 1;
			}
		}
	}
	return 1;
}

/////////////////////////////////Making command do same thing/////////////////////
CMD:setlocalnos(playerid, params[])
{
	cmd_givelocalnos(playerid, params);
	return 1;
}

CMD:placelocalnos(playerid, params[])
{
    cmd_givelocalnos(playerid, params);
	return 1;
}

CMD:deletelocalnos(playerid, params[])
{
    cmd_removelocalnos(playerid, params);
	return 1;
}
CMD:fixlocalcars(playerid, params[])
{
	cmd_repairlocalcars(playerid, params);
	return 1;
}


