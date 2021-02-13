////////////////////////////FIX 4 pEar 1////////////////////////////////////////
public OnPlayerDeath(playerid,killerid, reason)
{
	new dmsg[15], Float:dpos[3];
	GetPlayerPos(playerid, dpos[0], dpos[1], dpos[2]);
	format(dmsg, sizeof(dmsg), "%.3f %.3f %.3f", dpos[0], dpos[1], dpos[2]);
	SetPVarString(playerid, "P_DeathPos", MSG);
	//Above the spec, asa he dies.
}


stock GetPDeathPos(playerid, &dposX, &dposY, &dposZ)
{
	new dmsg[15]
	GetPVarString(playerid, "P_DeathPos", MSG, sizeof(dmsg));
	sscanf(dmsg, "fff", dposX, dposY, dposZ);
}
////////////////////////////////////////////////////////////////////////////////

////////////////////////////FIX 4 pEar 2////////////////////////////////////////
//Consider, Addition of players to event is done with the help of a Stock function.
stock AddDickHeadToEvent(playerid, Adder/*Adding admin*/)
{
	if(Player_Not_In_Any_Event)
	{
		PlayerDead[playerid]=false;
		if(CurrentEvent == /*Any_TDM*/ Event_Type_TDM)
		{
		    if(Event_Full==false)
		    {
			    if(Event_Started == true)
			    {
			        if(Last_Join_Was_TeamA)
			        {
						SetPlayerPos(playerid, TeamB_Spawn[0][0],TeamB_Spawn[0][1],TeamB_Spawn[0][2]);
						Watever[TeamB]++;
			        }
			        else
			        {
			            SetPlayerPos(playerid, TeamB_Spawn[0][0],TeamB_Spawn[0][1],TeamB_Spawn[0][2]);
	                    Watever[TeamA]++;
					}
			    }
			    else
			    {
			        cmd_join(playerid, "");
			    }
			}
			else
			{
			    SendClientMessage(Adder, COLOR_WARNING, "[ERROR]: Nigga, event is full. Wait till it starts to add these dicks.");
			}
		}
		else if(CurrentEvent == FFA/Non_Rejoinable_FF)
		{
			cmd_join(playerid, "");
		}
		else if(CurrentEvent == Pursuit)
		{
			if(Event_Not_Full)
			{
				Pursuit_OnPlayerJoinEvent(playerid);
			}
			else
			{
				SendClientMessage(Adder, COLOR_WARNING, "[ERROR]: Mofocka, if you ass this bitch, you will fuck the whole event");
			}
		}
		else if(CurrentEvent == Plane_Survival)
		{
			if(Event_Started)
			{
				SetPlayerPos(playerid, TeamHoboSpawn[0][0],TeamHoboSpawn[0][1],TeamHoboSpawn[0][2]);
				Watever++;
			}
			else
			{
				cmd_join(playerid, "");
			}
		}
		else if(CurrentEvent == Sumo)
		{
		    if(Event_Full==true)
		    {
		        SendClientMessage(Adder, COLOR_WARNING, "[ERROR]: Bitch please, event full. Go suck a dick.");
		    }
		    else if(Event_Started==false && Event_Timer_Time > 7 )
		    {
		        cmd_join(playerid, "");
		    }
		    else
		    {
     			vehicleid[numberofjoins] = CreateCar(blablablabla);
		        PutHisAssInSumoCar(playerid, vehicleid[numberofjoins]);
		        numberofjoins++;
		    }
		}
	}
	else
	{
	    SendClientMessage(Adder, COLOR_WARNING, "[ERROR]: Neegro, he already in the event.");
	}
}
////////////////////////////////////////////////////////////////////////////////
