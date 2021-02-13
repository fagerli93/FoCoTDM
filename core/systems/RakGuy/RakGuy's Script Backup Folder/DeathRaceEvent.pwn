#include <foco>
#define NILVALUE -1


#define KEY_MISSILE 	KEY_FIRE
#define KEY_BOOST 		KEY_ACTION
#define KEY_FIXCAR 		KEY_SUBMISSION
#define KEY_SMOKE 		KEY_CROUCH
#define KEY_FLIP    	KEY_YES
#define KEY_EXPLOSIVE 	KEY_NO

#define DR_VEH          411//Debug

#define EVENT_DRACE 16
#define DR_VWORLD   -1

#define DR_SMOKETIMER 25000
#define DR_ROCKETTIMER 100
#define DR_PICKUPTIMER 120000

////////////////////////////////////////////////////////////////////////////////
/*******************************FORWARDS**************************************/
////////////////////////////////////////////////////////////////////////////////
forward DR_EventEnd(playerid);
forward DR_EventStart(playerid);
forward DR_EventJoin(playerid);
forward DR_PlayerDeath(playerid);
forward DR_LeaveEvent(playerid);
////////////////////////////////////////////////////////////////////////////////
/****************************End Of Forwards***********************************/
////////////////////////////////////////////////////////////////////////////////

/*============================================================================*/

////////////////////////////////////////////////////////////////////////////////
/*******************************VARIABLES**************************************/
////////////////////////////////////////////////////////////////////////////////
enum DR_PickDet
{
	Float:DR_X,
	Float:DR_Y,
	Float:DR_Z,
	DR_Pid,
	DR_Ptype,
	bool:DR_Taken
}

new Timer:DR_PickupTimer;

new DR_Picks[15][DR_PickDet]=
{
	{1533.3300,-1679.0680,13.3828,-1,0,false},
	{1533.6327,-1674.4513,13.3828,-1,0,false},
	{1533.9600,-1669.4618,13.3828,-1,0,false},
	{1533.5663,-1663.1279,13.3828,-1,0,false},
	{1533.9484,-1658.6921,13.3828,-1,0,false},
	{1534.3801,-1653.7681,13.3828,-1,0,false},
	{1534.7858,-1649.1384,13.5469,-1,0,false},
	{1535.1591,-1644.8760,13.5469,-1,0,false},
	{1535.5155,-1640.8113,13.5469,-1,0,false},
	{1535.8037,-1637.5228,13.5469,-1,0,false},
	{1536.0723,-1634.4615,13.5469,-1,0,false},
	{1536.3226,-1631.6049,13.3828,-1,0,false},
	{1536.5746,-1628.7225,13.3828,-1,0,false},
	{1536.8478,-1625.5999,13.3828,-1,0,false},
	{1537.1196,-1622.4995,13.3828,-1,0,false}
};

enum DR_PlPicks
{
	DR_NoExpl,
	DR_NoFlip,
	DR_NoRket,
	DR_NoSmok,
	DR_NoRepr,
	DR_NoBost,
	DR_VehID,
	DR_RocketPickupID,
	DR_Kills
}
new DR_PlayerInfo[MAX_PLAYERS][DR_PlPicks];
new DRace_JoinCount;
new DRace_Alive;
enum DR_VehDet
{
	Float:DR_VX,
	Float:DR_VY,
	Float:DR_VZ,
	Float:DR_VA,
	DR_VehID,
	bool:DR_VehSmoke,
	DR_SmokeObjIDs[4],
	DR_MissileObjID,
	DR_ExplosiveID,
	Timer:DR_MissileT,
	Timer:DR_SmokeT
}
new DR_Vehicles[50][DR_VehDet];
new DR_MSG[200];
new Float:SmokePos[4][3]=
{
	{0.199999, -1.899998, -0.374999},
	{-0.199999, -1.899998, -0.374999},
	{0.694999, -1.899998, -0.374999},
	{-0.694999, -1.899998, -0.374999}
};
////////////////////////////////////////////////////////////////////////////////
/*******************************End Of Variables*******************************/
////////////////////////////////////////////////////////////////////////////////

/*============================================================================*/

////////////////////////////////////////////////////////////////////////////////
/*********************************TIMERS***************************************/
////////////////////////////////////////////////////////////////////////////////
timer DR_DeleteMissile[DR_ROCKETTIMER](DR_vid)
{
	new Float:Pos[3];
	GetDynamicObjectPos(DR_Vehicles[DR_vid][DR_MissileObjID], Pos[0], Pos[1], Pos[2]);
	foreach(Player, i)
	{
		if(GetPlayerVehicleID(i)!=DR_Vehicles[DR_vid][DR_VehID]&&GetPVarInt(i, "InEvent")==1&&IsPlayerInRangeOfPoint(i, 10.0, Pos[0], Pos[1], Pos[2]))
		{
			StopDynamicObject(DR_Vehicles[DR_vid][DR_MissileObjID]);
			DestroyDynamicObject(DR_Vehicles[DR_vid][DR_MissileObjID]);
            DR_Vehicles[DR_vid][DR_MissileObjID]=-1;
			GetPlayerPos(i, Pos[0] ,Pos[1], Pos[2]);
			CreateExplosion(Pos[0] ,Pos[1], Pos[2], 10, 10.0);

			DR_PlayerInfo[DR_GetMissileOwner(DR_vid)][DR_Kills]++;
			stop DR_Vehicles[DR_vid][DR_MissileT];
			break;
		}
	}
}

stock DR_GetMissileOwner(vehicleslot)
{
	new DR_VFlag;
	foreach(Player, i)
	{
	    if(DR_Vehicles[vehicleslot][DR_VehID]==DR_PlayerInfo[i][DR_VehID])
		{
		    DR_VFlag=i;
		    break;
		}
	}
	return DR_VFlag;
}

timer DR_DeleteSmokeMachine[DR_SMOKETIMER](vehid)
{
	SendClientMessageToAll(-1, "SmokeMachineDeleted");//Debug
	for(new i=0; i<4; i++)
	{
	    DestroyDynamicObject(DR_Vehicles[vehid][DR_SmokeObjIDs][i]);
	}
	DR_Vehicles[vehid][DR_VehSmoke]=false;
	stop DR_Vehicles[vehid][DR_SmokeT];
}

timer RemakePickups[DR_PICKUPTIMER]()
{
    DR_DestroyPickups();
    SendClientMessageToAll(-1, "Remaking Pickups");//Debug
    DR_CreatePickups();
}

/******************************END OF TIMERS***********************************/
////////////////////////////////////////////////////////////////////////////////

/*============================================================================*/

////////////////////////////////////////////////////////////////////////////////
/*****************************EVENT FUNCTIONS**********************************/
public DR_EventStart(playerid)
{
	foreach(Player, i)
    {
    	DR_PlayerInfo[i][DR_NoExpl]=0;
		DR_PlayerInfo[i][DR_NoFlip]=0;
		DR_PlayerInfo[i][DR_NoRket]=0;
		DR_PlayerInfo[i][DR_NoSmok]=0;
		DR_PlayerInfo[i][DR_NoRepr]=0;
		DR_PlayerInfo[i][DR_NoBost]=0;
		DR_PlayerInfo[i][DR_VehID]=0;
		DR_PlayerInfo[i][DR_RocketPickupID]=-1;
		DR_PlayerInfo[i][DR_Kills]=0;
	    SetPVarInt(i, "InEvent", 0);
    }
    DR_DestroyPickups();
    format(DR_MSG, sizeof(DR_MSG), "[EVENT]: %s %s has started {%06x}Death Race {%06x}event.  Type /join to join event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_NOTICE >>> 8);
    SendClientMessageToAll(COLOR_NOTICE, DR_MSG);
    Event_InProgress = 0;
	Event_ID = EVENT_DRACE;
	DRace_JoinCount=0;
	DRace_Alive=0;
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, DR_MSG);
	DR_CreatePickups();
	DR_PickupTimer = repeat RemakePickups();
	return 1;
}

public DR_EventEnd(playerid)
{
	new DR_MostKills=-1;
	new DR_MostKiller;
	foreach(Player, i)
    {
        if(GetPVarInt(i, "InEvent")==1)
        {
            RemovePlayerFromVehicle(i);
            SetVehicleToRespawn(DR_PlayerInfo[i][DR_VehID]);
			SpawnPlayer(i);
			if(DR_PlayerInfo[i][DR_RocketPickupID]!=-1)
				DestroyDynamicPickup(DR_PlayerInfo[i][DR_RocketPickupID]);
		    DR_PlayerInfo[i][DR_RocketPickupID]=-1;
			DR_PlayerInfo[i][DR_NoExpl]=0;
			DR_PlayerInfo[i][DR_NoFlip]=0;
			DR_PlayerInfo[i][DR_NoRket]=0;
			DR_PlayerInfo[i][DR_NoSmok]=0;
			DR_PlayerInfo[i][DR_NoRepr]=0;
			DR_PlayerInfo[i][DR_NoBost]=0;
			new DR_PSlot=GetVehicleSlot(DR_PlayerInfo[i][DR_VehID]);
			if(DR_Vehicles[DR_PSlot][DR_VehSmoke]==true)
			{
			    for(new j = 0; j<4 ; j++)
			    {
			    	DestroyDynamicObject(DR_Vehicles[DR_PSlot][DR_SmokeObjIDs][j]);
			    	DR_Vehicles[DR_PSlot][DR_SmokeObjIDs][j]=-1;
			    	stop DR_Vehicles[DR_PSlot][DR_SmokeT];
			    }
			}
			if(IsValidDynamicObject(DR_Vehicles[DR_PSlot][DR_MissileObjID])&&IsDynamicObjectMoving(DR_Vehicles[DR_PSlot][DR_MissileObjID]))
			{
				StopDynamicObject(DR_Vehicles[DR_PSlot][DR_MissileObjID]);
				DR_Vehicles[DR_PSlot][DR_MissileObjID]=-1;
				DestroyDynamicObject(DR_Vehicles[DR_PSlot][DR_MissileObjID]);
				stop DR_Vehicles[DR_PSlot][DR_MissileT];
			}
			DestroyVehicle(DR_Vehicles[DR_PSlot][DR_VehID]);
			DR_Vehicles[DR_PSlot][DR_VehID]=0;
			DR_PlayerInfo[i][DR_VehID]=0;
        }
        if(FoCo_Event_Died[i]==1)
        {
 			format(DR_MSG, sizeof(DR_MSG), "[EVENT NOTICE]: You have killed %i players in DeathRace event. ", DR_PlayerInfo[i][DR_Kills]);
			SendClientMessage(i, COLOR_NOTICE,DR_MSG);
            if(DR_PlayerInfo[i][DR_Kills]>DR_MostKills)
			{
			    DR_MostKiller=i;
			    DR_MostKills=DR_PlayerInfo[i][DR_Kills];
			}
		}
	    FoCo_Event_Died[i] = 0;
	    SetPVarInt(i, "InEvent", 0);
    }
	for(new i; i<DRace_JoinCount; i++)
	{
	    if(GetVehicleModel(DR_Vehicles[i][DR_VehID])==DR_VEH&&DR_Vehicles[i][DR_VehID]!=0)
		{
			DestroyVehicle(DR_Vehicles[i][DR_VehID]);
		}
	}
	if(DR_MostKills>0)
	{
		format(DR_MSG, sizeof(DR_MSG), "[EVENT NOTICE]: %s has killed the most in Death-Race Event. Kills: %i", PlayerName(DR_MostKiller),DR_MostKills);
		SendClientMessageToAll(COLOR_GREEN,DR_MSG);
	}
	Event_ID=NILVALUE;
	SendClientMessageToAll(COLOR_NOTICE, "[NOTICE]: Death Race Event has been ended.");
	Event_InProgress = -1;
	DR_DestroyPickups();
	stop DR_PickupTimer;
	return 1;
}

public DR_EventJoin(playerid)
{
	ResetPlayerWeapons(playerid);
	SetPVarInt(playerid, "InEvent", 1);
	SetPlayerVirtualWorld(playerid, 0);
	/*Debug*/
	new Float:Pos[3];
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	/*End Debug*/
	DR_CreateVehicle(playerid);
	/*Debug*/
	SetVehiclePos(DR_PlayerInfo[playerid][DR_VehID],Pos[0], Pos[1], Pos[2]);
	/*End Debug*/
	SetPlayerHealth(playerid, 99.0);
	SetPlayerArmour(playerid, 99.0);
	DRace_JoinCount++;
	DRace_Alive++;
	return 1;
}

public DR_PlayerDeath(playerid)
{
    FoCo_Event_Died[playerid]=1;
    SetPVarInt(playerid, "InEvent", 0);
	if(DR_PlayerInfo[playerid][DR_RocketPickupID]!=-1)
		DestroyDynamicPickup(DR_PlayerInfo[playerid][DR_RocketPickupID]);
    DR_PlayerInfo[playerid][DR_RocketPickupID]=-1;
	DR_PlayerInfo[playerid][DR_NoExpl]=0;
	DR_PlayerInfo[playerid][DR_NoFlip]=0;
	DR_PlayerInfo[playerid][DR_NoRket]=0;
	DR_PlayerInfo[playerid][DR_NoSmok]=0;
	DR_PlayerInfo[playerid][DR_NoRepr]=0;
	DR_PlayerInfo[playerid][DR_NoBost]=0;
	new DR_PSlot=GetVehicleSlot(DR_PlayerInfo[playerid][DR_VehID]);
	if(DR_Vehicles[DR_PSlot][DR_VehSmoke]==true)
	{
	    for(new i = 0; i<4 ; i++)
	    {
	    	DestroyDynamicObject(DR_Vehicles[DR_PSlot][DR_SmokeObjIDs][i]);
	    	DR_Vehicles[DR_PSlot][DR_SmokeObjIDs][i]=-1;
	    	stop DR_Vehicles[DR_PSlot][DR_SmokeT];
	    }
	}
	if(IsValidDynamicObject(DR_Vehicles[DR_PSlot][DR_MissileObjID])&&IsDynamicObjectMoving(DR_Vehicles[DR_PSlot][DR_MissileObjID]))
	{
		StopDynamicObject(DR_Vehicles[DR_PSlot][DR_MissileObjID]);
		DR_Vehicles[DR_PSlot][DR_MissileObjID]=-1;
		DestroyDynamicObject(DR_Vehicles[DR_PSlot][DR_MissileObjID]);
		stop DR_Vehicles[DR_PSlot][DR_MissileT];
	}
	DestroyVehicle(DR_Vehicles[DR_PSlot][DR_VehID]);
	DR_Vehicles[DR_PSlot][DR_VehID]=0;
	DR_PlayerInfo[playerid][DR_VehID]=0;
	new DR_AntiBug;
	foreach(Player, i)
	{
        if(GetPVarInt(i, "InEvent")==1)
        {
            DR_AntiBug++;
        }
	}
	DRace_Alive--;
	if(DR_AntiBug==DRace_Alive)
	{
	    SendClientMessageToAll(-1, "Debug]: Working cool");
	}
	if(DRace_Alive<=1)
	{
	    DR_AntiBug=0;
	    foreach(Player, i)
	    {
	        if(GetPVarInt(i, "InEvent")==1)
	        {
	            format(DR_MSG, sizeof(DR_MSG), "[EVENT NOTICE]: %s has survived the DeathRace and thereby, has won the event.", PlayerName(i));
				SendClientMessageToAll(COLOR_NOTICE, DR_MSG);
				DR_AntiBug=1;
				break;
			}
	    }
	    if(DR_AntiBug==0)
	    {
     		format(DR_MSG, sizeof(DR_MSG), "[EVENT NOTICE]: %s has survived the DeathRace and thereby, has won the event.", PlayerName(playerid));
			SendClientMessageToAll(COLOR_NOTICE, DR_MSG);
	    }
    	SetTimerEx("DR_EventEnd", 0, false, "i", playerid);
	}
	return 1;
}

public DR_LeaveEvent(playerid)
{
	RemovePlayerFromVehicle(playerid);
	SetVehicleToRespawn(DR_PlayerInfo[playerid][DR_VehID]);
	SpawnPlayer(playerid);
	SetTimerEx("DR_PlayerDeath", 0, false, "i", playerid);
	return 1;
}

/*public DR_EventAdd(playerid, targetid)
{
	if(DRace_JoinCount==50)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Event Full, adding player will bug event.");
	}
	else
	{
	    SetTimerEx("DR_EventJoin", 0, false, "i", targetid);
	}
}*/
////////////////////////////////////////////////////////////////////////////////
/**************************End of Event Functions******************************/
////////////////////////////////////////////////////////////////////////////////

/*============================================================================*/

////////////////////////////////////////////////////////////////////////////////
/******************************Event Stocks************************************/
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////Vehicle Stocks//////////////////////////////////
stock DR_CreateVehicle(playerid)
{
    DR_PlayerInfo[playerid][DR_VehID]=CreateVehicle(DR_VEH, DR_Vehicles[DRace_JoinCount][DR_VX], DR_Vehicles[DRace_JoinCount][DR_VY], DR_Vehicles[DRace_JoinCount][DR_VZ], DR_Vehicles[DRace_JoinCount][DR_VA], random(254), random(254), 100000);
	SetPlayerPos(playerid, DR_Vehicles[DRace_JoinCount][DR_VX], DR_Vehicles[DRace_JoinCount][DR_VY], DR_Vehicles[DRace_JoinCount][DR_VZ]);
	SetCameraBehindPlayer(playerid);
	PutPlayerInVehicle(playerid, DR_PlayerInfo[playerid][DR_VehID], 0);
	DR_Vehicles[DRace_JoinCount][DR_VehID]=DR_PlayerInfo[playerid][DR_VehID];
	DR_Vehicles[DRace_JoinCount][DR_VehSmoke]=false;
	DR_Vehicles[DRace_JoinCount][DR_SmokeObjIDs]={0,0,0,0};
	DR_Vehicles[DRace_JoinCount][DR_MissileObjID]=0;
	return 1;
}

stock DR_DeleteVehicle(playerid)
{
	if(DR_PlayerInfo[playerid][DR_VehID]>0)
	{
		RemovePlayerFromVehicle(playerid);
		DestroyVehicle(DR_PlayerInfo[playerid][DR_VehID]);
	}
	return 1;
}

stock GetVehicleSlot(vehicleid)
{
	for(new i = 0; i<15;i++)
	{
	    if(vehicleid==DR_Vehicles[i][DR_VehID])
	        return i;
	}
	return -1;
}

/////////////////////////////////Pickup Stocks//////////////////////////////////

stock DR_IsEventPickup(pickupid)
{
	for(new i=0; i<15; i++)
	{
	    if(pickupid == DR_Picks[i][DR_Pid])
	        return i;
	}
	return -1;
}

stock DR_CreatePickups()
{
	new Pickups[6]={3884, 1240, 1241, 1254, 343,1273};
	for(new i=0; i<15; i++)
	{
	    DR_Picks[i][DR_Ptype]=Pickups[random(6)];
		DR_Picks[i][DR_Pid]=CreateDynamicPickup(DR_Picks[i][DR_Ptype],14,DR_Picks[i][DR_X],DR_Picks[i][DR_Y],DR_Picks[i][DR_Z], DR_VWORLD);
        DR_Picks[i][DR_Taken]=false;
	}
	//
	return 1;
}

stock DR_DestroyPickups()
{
    for(new i=0; i<15; i++)
	{
		DestroyDynamicPickup(DR_Picks[i][DR_Pid]);
        DR_Picks[i][DR_Pid]=-1;
        DR_Picks[i][DR_Taken]=false;
	}
}

stock DR_IsPlayerPickup(pickupid)
{
	foreach(Player, i)
	{
	    if(pickupid==DR_PlayerInfo[i][DR_RocketPickupID])
			return i;
	}
	return -1;
}

////////////////////////////////OBJECT Stocks///////////////////////////////////
stock GetObjectSlot(objectid)
{
	for(new i = 0; i<15;i++)
	{
	    if(objectid==DR_Vehicles[i][DR_MissileObjID])
	        return i;
	}
	return -1;
}

////////////////////////////////////////////////////////////////////////////////
/**********************End of Event Stock Functions****************************/
////////////////////////////////////////////////////////////////////////////////

/*============================================================================*/

////////////////////////////////////////////////////////////////////////////////
/*****************************Event Call Backs*********************************/
////////////////////////////////////////////////////////////////////////////////
public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	new DR_PickUpFlag=DR_IsEventPickup(pickupid);
	if(DR_PickUpFlag>=0)
	{
		if(Event_ID==EVENT_DRACE)
		{
		    //ifPlayerIsInEvent
		    if(DR_Picks[DR_PickUpFlag][DR_Taken]==false)
		    {
				switch(DR_Picks[DR_PickUpFlag][DR_Ptype])
				{
				    case 3884:
				    {
				        GameTextForPlayer(playerid, "~g~PickUp ~n~~r~ROCKET.", 3000, 3);
		                DR_PlayerInfo[playerid][DR_NoRket]++;
					}
				    case 1240:
				    {
      					GameTextForPlayer(playerid, "~g~PickUp ~n~~r~REPAIR.", 3000, 3);
				        DR_PlayerInfo[playerid][DR_NoRepr]++;
				   }
				    case 1241:
				    {
				        GameTextForPlayer(playerid, "~g~PickUp ~n~~r~FLIP.", 3000, 3);
				    	DR_PlayerInfo[playerid][DR_NoBost]++;
		      		}
				    case 1254:
				    {
				        GameTextForPlayer(playerid, "~g~PickUp ~n~~r~EXPLOSIVE.", 3000, 3);
		  		        DR_PlayerInfo[playerid][DR_NoExpl]++;
		      		}
				    case 343:
				    {
				        GameTextForPlayer(playerid, "~g~PickUp ~n~~r~SMOKE.", 3000, 3);
				        DR_PlayerInfo[playerid][DR_NoSmok]=1;
				    }
				    case 1273:
				    {
		      			GameTextForPlayer(playerid, "~g~PickUp ~n~~r~FLIP.", 3000, 3);
				        DR_PlayerInfo[playerid][DR_NoFlip]++;
				    }
				}
				DR_Picks[DR_PickUpFlag][DR_Taken]=true;
			}
			else
			{
   				GameTextForPlayer(playerid, "PickUp Already taken.", 3000, 3);
			}
		}
	}
	else
	{
	    DR_PickUpFlag=DR_IsPlayerPickup(pickupid);
		if(DR_PickUpFlag>=0)
		{
		    new Float:Pos[3];
		    GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		    CreateExplosion(Pos[0], Pos[1], Pos[2], 10, 10.0);
		    DR_PlayerInfo[DR_PickUpFlag][DR_Kills]++;
		}
	}
	return 1;
}

public OnDynamicObjectMoved(objectid)
{
	new objid=GetObjectSlot(objectid);
	if(objid>=0)
	{
		new Float:Pos[3];
		GetDynamicObjectPos(DR_Vehicles[objid][DR_MissileObjID], Pos[0], Pos[1], Pos[2]);
        CreateExplosion(Pos[0] ,Pos[1], Pos[2], 10, 10.0);
        DestroyDynamicObject(DR_Vehicles[objid][DR_MissileObjID]);
        DR_Vehicles[objid][DR_MissileObjID]=-1;
		stop DR_Vehicles[objid][DR_MissileT];
	}
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(Event_ID==EVENT_DRACE)
	{
	    if(GetPVarInt(playerid, "InEvent")==1)
	    {
			/*SMOKE*/
			if(newkeys&KEY_SMOKE)//Working
			{
			    SendClientMessage(playerid, -1, "Cr");//Debug
				if(IsPlayerInAnyVehicle(playerid)==1)
				{
				    SendClientMessage(playerid, -1, "Inv");//Debug
				    printf("%i",DR_PlayerInfo[playerid][DR_NoSmok]);
				    if(DR_PlayerInfo[playerid][DR_NoSmok]>0)
				    {
				        SendClientMessage(playerid, -1, "Smoke");//Debug
				        new vehid = GetVehicleSlot(GetPlayerVehicleID(playerid));
						if(DR_Vehicles[vehid][DR_VehSmoke]==false)
						{
						    SendClientMessage(playerid, -1, "Free");//Debug
							if(vehid>=0)
							{
							    for(new i=0; i<4; i++)
						        {
						            SendClientMessage(playerid, -1, "for");//Debug
						        	DR_Vehicles[vehid][DR_SmokeObjIDs][i]=CreateDynamicObject(2780, 0.0, 0.0, 0.0, 0.0,0.0,0.0,DR_VWORLD);
						        	AttachDynamicObjectToVehicle(DR_Vehicles[vehid][DR_SmokeObjIDs][i], DR_Vehicles[vehid][DR_VehID], SmokePos[i][0], SmokePos[i][1], SmokePos[i][2], 0.0, 0.0, 0.0);
						        }
						        DR_Vehicles[vehid][DR_SmokeT] = repeat DR_DeleteSmokeMachine(vehid);
				                DR_Vehicles[vehid][DR_VehSmoke]=true;
				                DR_PlayerInfo[playerid][DR_NoSmok]--;
				                SendClientMessage(playerid, -1, "TimerMade");//Debug
							}
						}
					}
				}
			}
		    /*FIXCAR*/
			if(newkeys&KEY_FIXCAR)//Working
			{
			    SendClientMessage(playerid, -1, "Cr");//Debug
				if(IsPlayerInAnyVehicle(playerid)==1)
				{
				    SendClientMessage(playerid, -1, "Inv");//Debug
				    printf("%i",DR_PlayerInfo[playerid][DR_NoRepr]);
				    if(DR_PlayerInfo[playerid][DR_NoRepr]>0)
				    {
				        SendClientMessage(playerid, -1, "Repair");//Debug
				        new vehid = GetVehicleSlot(GetPlayerVehicleID(playerid));
						RepairVehicle(DR_Vehicles[vehid][DR_VehID]);
						DR_PlayerInfo[playerid][DR_NoRepr]--;
					}
				}
			}
		    /*BOOST*/
			if(newkeys&KEY_BOOST)//Working
			{
			    SendClientMessage(playerid, -1, "Cr");//Debug
				if(IsPlayerInAnyVehicle(playerid)==1)
				{
				    SendClientMessage(playerid, -1, "Inv");//Debug
				    if(DR_PlayerInfo[playerid][DR_NoBost]>0)
				    {
				        SendClientMessage(playerid, -1, "Boost");//Debug
				        new vehid = GetVehicleSlot(GetPlayerVehicleID(playerid));
						new Float:vx,Float:vy,Float:vz;
		        		GetVehicleVelocity(DR_Vehicles[vehid][DR_VehID],vx,vy,vz);
		        		SetVehicleVelocity(DR_Vehicles[vehid][DR_VehID], vx * 1.8, vy *1.8, vz * 1.8);
		        		if(vx+vy+vz!=0.0)
		        		{
		        		    DR_PlayerInfo[playerid][DR_NoBost]--;
		        		}
					}
				}
			}
			/*MISSILE*/
			if(newkeys&KEY_MISSILE)//Working
			{
			    SendClientMessage(playerid, -1, "Cr");//Debug
				if(IsPlayerInAnyVehicle(playerid)==1)
				{
				    SendClientMessage(playerid, -1, "Inv");//Debug
				    if(DR_PlayerInfo[playerid][DR_NoRket]>0)
				    {
				        SendClientMessage(playerid, -1, "Rocket");//Debug
				        new vehid = GetVehicleSlot(GetPlayerVehicleID(playerid));
				        if(IsValidDynamicObject(DR_Vehicles[vehid][DR_MissileObjID])==0)
				        {
				            SendClientMessage(playerid, -1, "Made");//Debug
							new Float:fPX,Float:fPY,Float:fPZ,Float:fA;
							GetVehiclePos(DR_Vehicles[vehid][DR_VehID],fPX,fPY,fPZ);
				            GetVehicleZAngle(DR_Vehicles[vehid][DR_VehID],fA);
							DR_Vehicles[vehid][DR_MissileObjID]=CreateDynamicObject(345, fPX,fPY,fPZ, 0.0, 0.0, 0.0,DR_VWORLD);
							fPX += (250.0 * floatsin(-fA, degrees));
				    		fPY += (250.0 * floatcos(-fA, degrees));
				    		MoveDynamicObject(DR_Vehicles[vehid][DR_MissileObjID], fPX,fPY,fPZ-3.0, 80.0);
				    		DR_Vehicles[vehid][DR_MissileT] = repeat DR_DeleteMissile(vehid);
			                DR_PlayerInfo[playerid][DR_NoRket]--;
		     			}
					}
		  		}
			}
			/*EXPLOSIVE*/
			if(newkeys&KEY_EXPLOSIVE)
			{
				SendClientMessage(playerid, -1, "Cr");//Debug
				if(IsPlayerInAnyVehicle(playerid)==1)
				{
				    SendClientMessage(playerid, -1, "Inv");//Debug
				    if(DR_PlayerInfo[playerid][DR_NoExpl]>0)
				    {
				        SendClientMessage(playerid, -1, "Explosive");//Debug
				        new vehid = GetVehicleSlot(GetPlayerVehicleID(playerid));
				        if(IsValidDynamicPickup(DR_PlayerInfo[playerid][DR_RocketPickupID])==0)
				        {
				            SendClientMessage(playerid, -1, "Made");//Debug
							new Float:fPX,Float:fPY,Float:fPZ;
							GetVehiclePos(DR_Vehicles[vehid][DR_VehID],fPX,fPY,fPZ);
							DR_PlayerInfo[playerid][DR_RocketPickupID]=CreateDynamicPickup(1225, 14, fPX, fPY, fPZ-0.45, DR_VWORLD);
                            DR_PlayerInfo[playerid][DR_NoExpl]--;
						}
					}
		  		}
			}
			if(newkeys&KEY_FLIP)
			{
				SendClientMessage(playerid, -1, "Cr");//Debug
				if(IsPlayerInAnyVehicle(playerid)==1)
				{
				    SendClientMessage(playerid, -1, "Inv");//Debug
				    if(DR_PlayerInfo[playerid][DR_NoFlip]>0)
				    {
				        SendClientMessage(playerid, -1, "Flip");//Debug
				        new Float:DR_angle;
				        new vehid = GetVehicleSlot(GetPlayerVehicleID(playerid));
                        GetVehicleZAngle(DR_Vehicles[vehid][DR_VehID], DR_angle);
    					SetVehicleZAngle(DR_Vehicles[vehid][DR_VehID], DR_angle);
                        DR_PlayerInfo[playerid][DR_NoFlip]--;
					}
		  		}
			}
		}
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(Event_ID==EVENT_DRACE && GetPVarInt(playerid, "InEvent")==1)
	{
		SetTimerEx("DR_PlayerDeath", 0, false, "i", playerid);
		return 1;
	}
	return 1;
}
////////////////////////////////////////////////////////////////////////////////
/*****************************End of Event Callbacks***************************/
////////////////////////////////////////////////////////////////////////////////

/*============================================================================*/

////////////////////////////////////////////////////////////////////////////////
/********************************DEBUG COMMANDS********************************/
////////////////////////////////////////////////////////////////////////////////
CMD:event(playerid, params[])
{
	SetTimerEx("DR_EventStart", 0, false, "i", playerid);
	return 1;
}

CMD:join(playerid, params[])
{
    SetTimerEx("DR_EventJoin", 0, false, "i", playerid);
	return 1;
}

CMD:end(playerid, params[])
{
    SetTimerEx("DR_EventEnd", 0, false, "i", playerid);
	return 1;
}

CMD:leave(playerid, params[])
{
	SetTimerEx("DR_LeaveEvent", 0, false, "i", playerid);
	return 1;
}
////////////////////////////////////////////////////////////////////////////////
/*****************************End of Debug Commands****************************/
////////////////////////////////////////////////////////////////////////////////
/*============================================================================*/

