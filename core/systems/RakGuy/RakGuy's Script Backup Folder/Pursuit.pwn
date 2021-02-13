#define FILTERSCRIPT
#define Event_ID_Pursuit 30
#define DIALOG_PURSUIT_VEH 111
#define DIALOG_PURSUIT_MOD 112

#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <foreach>

//TBD
enum TeamDet
{
	TSkinID,
	Float:team_spawn_x,
	Float:team_spawn_y,
	Float:team_spawn_z,
	Float:team_angle,
	TColor
};

new FoCo_Teams[6][TeamDet]=
{
{0, 1553.67480, -1675.83789, 16.09370, 0.0,0x001233},
{147,1176.52979, -1324.10461, 14.43604,90.0, 0x3F3E45FF},
{46, 1785.46399, -1369.94739, 15.62825, 270.0, 0x979592FF},
{129, 1269.12573, -1544.42224, 13.28697, 180.0, 0xA5A9A7FF},
{123,1367.66504, -1140.71863, 26.11647,90.0,0x231232ff},
{125,1569.87122, -1695.23340, 6.24655,0.0,0x223344ff}
};

new FoCo_Team[MAX_PLAYERS];
//TBD


new Float:Pursuit_Spawn[56][4]={
//Spawn Set-0
{601.6544, -1221.5585, 17.6686, -65.8200}, //Bank
{584.8384, -1237.2843, 17.6297, -58.6800},
{582.5258, 	-1233.8434, 17.6297, -62.5800},
{580.6802, -1229.9427, 17.6297, -66.7200},
{582.6182, -1224.5734, 17.6297, -66.7200},
{581.4221, -1221.0742, 17.6297, -66.7200},
{585.4248, -1215.8337, 17.6297, -98.2800},
//Spawn Set-1
{-25.5943, -308.5628, 5.1349, 179.8800}, //BB Paint
{-2.8352, -296.2281, 5.1349, 127.9800},  //Cop1
{-6.4613, -291.6866, 5.1349, 135.3600},
{-10.8418, -287.5560, 5.1349, 143.7000},
{-15.8344, -284.4158, 5.1349, 153.7200},
{-21.2785, -282.3856, 5.1349, 171.1799},
{-26.8256, -281.5997, 5.1349, 174.5999}, //Cop6
//Spawn Set-2
{71.5989, -232.2226, 1.7065, 0.0000}, //BB Paint
{81.7168, -252.8851, 1.7065, 18.6600},
{75.1267, -254.3385, 1.7065, 7.7400},
{68.7413, -254.2142, 1.7065, -3.6000},
{63.1218, -253.2878, 1.7065, -12.2400},
{57.5784, -251.0417, 1.7065, -20.8800},
{53.1610, -248.6138, 1.7065, -20.8800},
//Spawn Set-3
{643.3347, -600.4189, 16.0212, -86.4000},  //SDPD
{625.3323, -611.1033, 16.8052, -78.8400},
{624.9973, -606.6791, 16.8052, -84.8400},
{624.7409, -601.8693, 16.8052, -90.1200},
{625.0741, -597.3822, 16.8052, -92.7000},
{625.3820, -592.8582, 16.8052, -96.0000},
{625.6063, -588.6082, 16.8052, -96.0000},
//Spawn Set-4
{370.2968, -2005.6169, 7.7797, 0.0000}, //Pier
{362.0817, -2025.4276, 7.7797, -20.5800},
{365.2459, -2026.5979, 7.7797, -14.5200},
{368.9875, -2027.2687, 7.7797, -3.6600},
{372.7449, -2027.1581, 7.7797, 5.8800},
{376.2963, -2026.0109, 7.7797, 17.7600},
{379.5614, -2024.3810, 7.7797, 28.0200},
//Spawn Set-5
{1273.6012, -2056.4507, 58.7669, -93.8400}, //Old RFD spawn
{1257.8005, -2060.4753, 59.0445, -82.6200},
{1257.8093, -2056.7290, 59.0767, -90.7800},
{1258.3160, -2053.2810, 59.1517, -97.6200},
{1259.2382, -2049.5020, 58.9836, -107.2800},
{1259.2389, -2063.6208, 59.2495, -74.5200},
{1261.7574, -2045.9772, 59.2495, -125.5200},
//Spawn Set-6
{2485.1667, -1667.1708, 13.2988, 80.8800}, //Groove
{2509.1699, -1667.9279, 13.2988, 89.5200},
{2508.8167, -1671.9015, 13.2988, 79.4400},
{2507.8076, -1676.0338, 13.2988, 69.5400},
{2505.6873, -1679.5214, 13.2988, 59.9400},
{2508.6448, -1664.2582, 13.2988, 95.8800},
{2507.8955, -1660.8562, 13.2988, 102.1200},
//Spawn Set-7
{2520.2053, -1529.2079, 23.6692, 0.0000}, //PigPen
{2518.7820, -1550.0565, 23.6692, 0.0000},
{2523.4800, -1549.5759, 23.6692, 10.8600},
{2527.8481, -1548.2214, 23.6692, 12.4200},
{2513.6423, -1549.7048, 23.6692, -19.0800},
{2509.9038, -1547.8710, 23.6692, -25.2600},
{2531.8569, -1546.2130, 23.6692, 22.0200}
};
new Pursuit_CrimeVeh[29]=
{
    568,424,579,400,500,489,//Off-Road
    602,496,402,589,587,565,//Avg
    559,603,475,558,536,562,//Fast
    534,567,535,566,576,412,//lowRide
	429,506,451,477,494		//Real-Time-Fast
    
};

new Pursuit_CopVeh[5]=
{
    599,//Off-Road
    507,//Avg
    490,//Fast
    426,//LowRide
    541 //Real-Time-Fast
};
new bool:Pursuit_IsCriminal[MAX_PLAYERS];
new Pursuit_Event_Mod;
new Event_InProgress;
new Event_ID;
new FoCo_Event_Died[MAX_PLAYERS];
new Pursuit_CriminalCount;
new Pursuit_CopCount;
new Pursuit_TotalJoins;
new Pursuit_Join_ID[MAX_PLAYERS];
new Pursuit_CopCar, Pursuit_CrimCar;
new Pursuit_MSG[150];
new Pursuit_Vehicle_IDs[200];


stock Pursuit_PlayerLeave(playerid)
{
	if(Event_InProgress == 0)
	{
		SetPVarInt(playerid, "InEvent", 0);
		if(Pursuit_Event_Mod==1)
		{
		    Pursuit_DeleteCar(Pursuit_Vehicle_IDs[Pursuit_Join_ID[playerid]]);
		    Pursuit_Vehicle_IDs[Pursuit_Join_ID[playerid]]=0;
		}
		if(Pursuit_IsCriminal[playerid]==true)
		{
	    	Pursuit_CriminalCount--;
			format(Pursuit_MSG, sizeof(Pursuit_MSG), "[Event Notice:]%s has been caught by the police.", PlayerName(playerid));
		    SendClientMessageToAll(COLOR_NOTICE, Pursuit_MSG);
		    format(Pursuit_MSG, sizeof(Pursuit_MSG), "[Event Notice:]%i Criminals remaining.",Pursuit_CriminalCount);
		    foreach(Player, i)
		    {
		        if(GetPVarInt(i, "InEvent")==1)
		    	{
			        if(Pursuit_IsCriminal[playerid]==false)
			        {
						SendClientMessage(i,COLOR_NOTICE,Pursuit_MSG);
				    }
				}
			}
		}
		else
		{
		    Pursuit_CopCount--;
		    format(Pursuit_MSG, sizeof(Pursuit_MSG), "[Event Notice:]%i Cops remaining.",Pursuit_CopCount);
		    foreach(Player, i)
		    {
		        if(GetPVarInt(i, "InEvent")==1)
		    	{
			        if(Pursuit_IsCriminal[playerid]==true)
			        {
						SendClientMessage(i,COLOR_NOTICE,Pursuit_MSG);
				    }
				}
			}

		}
		if(Pursuit_CriminalCount==0)
		{
		    format(Pursuit_MSG, sizeof(Pursuit_MSG), "[Event Notice:]Event ended due to all criminals being caught.");
		    SendClientMessageToAll(COLOR_NOTICE, Pursuit_MSG);
		}
		else if(Pursuit_CopCount==0)
		{
		    format(Pursuit_MSG, sizeof(Pursuit_MSG), "[Event Notice:]Event ended due to all cops dying.");
		    SendClientMessageToAll(COLOR_NOTICE, Pursuit_MSG);
		}
		if(IsPlayerConnected(playerid)&&FoCo_Event_Died[playerid]==0)
		{
			SetPlayerColor(playerid,FoCo_Teams[FoCo_Team[playerid]][TColor]);
			RemovePlayerFromVehicle(playerid);
			SpawnPlayer(playerid);
			FoCo_Event_Died[playerid]=1;
		}
	}
	else
	{
	    RemovePlayerFromVehicle(playerid);
	    SetPlayerColor(playerid,FoCo_Teams[FoCo_Team[playerid]][TColor]);
	    SpawnPlayer(playerid);
	    FoCo_Event_Died[playerid]=1;
	}
	return 1;
}

stock Pursuit_DeleteCar(pursuit_vehicleid)
{
	if(pursuit_vehicleid!=0)
	{
		DestroyVehicle(pursuit_vehicleid);
	}
	return 1;
}

stock Pursuit_EventEnd()
{
    Event_InProgress = 1;
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent")==1)
	    {
	    	SetPlayerColor(i,FoCo_Teams[FoCo_Team[i]][TColor]);
		    SpawnPlayer(i);
		    FoCo_Event_Died[i]=0;
		}
    }
    for(new i=0; i<(Pursuit_TotalJoins/7)*7+7;i++)
    {
        if(Pursuit_Vehicle_IDs[i]!=0)
    	{
			Pursuit_DeleteCar(Pursuit_Vehicle_IDs[i]);
		}
		Pursuit_Vehicle_IDs[i]=0;
	}
	return 1;
}

stock Pursuit_EventDet(playerid)
{
	Pursuit_CriminalCount=0;
	Pursuit_Event_Mod=0;
	Pursuit_CopCount=0;
	Pursuit_TotalJoins=0;
	Pursuit_CopCar=0;
	Pursuit_CrimCar=0;
	for(new i=0; i<200; i++)
	{
	    Pursuit_Vehicle_IDs[i]=0;
	}
	ShowPlayerDialog(playerid, DIALOG_PURSUIT_VEH, 1,"Select Vehicle: ", "{FF0000}Format: {FFFFFF}Criminal_Car_ID/NAME<space>Cop_Car_ID", "Choose", "Random");
	return 1;
}
stock Pursuit_EventStart(playerid)
{
	foreach(Player, i)
    {
	    FoCo_Event_Died[i] = 0;
	    SetPVarInt(i, "InEvent", 0);
	    Pursuit_IsCriminal[playerid]=false;
		Pursuit_Join_ID[i]=-1;
	}
    Event_ID=Event_ID_Pursuit;
	Event_InProgress = 0;
    format(Pursuit_MSG, sizeof(Pursuit_MSG), "[EVENT]: %s %s has started {%06x}Pursuit {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_NOTICE >>> 8);
    SendClientMessageToAll(COLOR_NOTICE, Pursuit_MSG);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid==DIALOG_PURSUIT_VEH)
	{
	    if(sscanf(inputtext, "k<vehicle>k<vehicle>",Pursuit_CrimCar,Pursuit_CopCar)||!response||Pursuit_CrimCar<400||Pursuit_CopCar<400)
	    {
			new Pursuit_Random;
			Pursuit_Random=random(sizeof(Pursuit_CrimeVeh));
			Pursuit_CrimCar=Pursuit_CrimeVeh[Pursuit_Random];
			Pursuit_CopCar=Pursuit_CopVeh[Pursuit_Random/7];
			SendClientMessage(playerid, COLOR_WARNING, "[Event:] Random vehicle chosen!");
	    }
		ShowPlayerDialog(playerid,DIALOG_PURSUIT_MOD, 0, "Select MOD:", "{ffffff}1. {00ff00}Chase: {00ff00}Cannot get outtaf vehicle\n{ffffff}2. {00ff00}Mafia: {ff0000}Can get outtaf vehicle.\n",\
		"Chase", "Mafia");
		return 1;
	}
	if(dialogid==DIALOG_PURSUIT_MOD)
	{
	    if(!response)
		{
		    Pursuit_Event_Mod=2;
		}
		else
		{
		    Pursuit_Event_Mod=1;
		}
		Pursuit_EventStart(playerid);
		return 1;
	}
	return 0;
}

stock Pursuit_CreateVehicles(Pursuit_Veh)
{
	for(new i=Pursuit_Veh*7;i<Pursuit_Veh*7+7;i++)
	{
	    if(i%7==0)
	    {
			Pursuit_Vehicle_IDs[i]=CreateVehicle(Pursuit_CrimCar,Pursuit_Spawn[i][0],Pursuit_Spawn[i][1],Pursuit_Spawn[i][2], Pursuit_Spawn[i][3], random(250),random(250),0);
	    }
	    else
	    {
	    	Pursuit_Vehicle_IDs[i]=CreateVehicle(Pursuit_CopCar,Pursuit_Spawn[i][0],Pursuit_Spawn[i][1],Pursuit_Spawn[i][2], Pursuit_Spawn[i][3], 0,1,0);
	    }
	    SetVehicleVirtualWorld(Pursuit_Vehicle_IDs[i], 1500);
	}
	return 1;
}

stock Pursuit_EventJoin(playerid)
{
	SetPVarInt(playerid, "InEvent", 1);
	Pursuit_Join_ID[playerid]=Pursuit_TotalJoins;
	RemovePlayerFromVehicle(playerid);
	SetPlayerVirtualWorld(playerid, 1500);
	if(Pursuit_TotalJoins%7==0)
	{
	    SendClientMessage(playerid,COLOR_NOTICE, "[Objective:] Evade cops at all cost.");
	    SetPlayerSkin(playerid, 32);
	    SetPlayerColor(playerid, 0xD78E10FF);
	    Pursuit_IsCriminal[playerid]=true;
		Pursuit_CreateVehicles(Pursuit_TotalJoins/7);
        Pursuit_CriminalCount++;
	}
	else
	{
	    SetPlayerSkin(playerid, 282);
	    SetPlayerColor(playerid, 0x4C75B7FF );
	    Pursuit_IsCriminal[playerid]=false;
	    Pursuit_CopCount++;
	    PutPlayerInVehicle(playerid,Pursuit_Vehicle_IDs[Pursuit_Join_ID[playerid]],0);
	}
	if(Pursuit_Event_Mod==1)
	{
	    SendClientMessage(playerid, COLOR_NOTICE, "[Event Notice:] Getting outtaf vehicle can get your ass outtaf event!");
	}
	else
	{
		SendClientMessage(playerid, COLOR_NOTICE, "[Event Notice:] Mafia mod, you can get outta vehicle to shoot.");
		GivePlayerWeapon(playerid, 32, 500);
		GivePlayerWeapon(playerid, 24, 500);
		GivePlayerWeapon(playerid, 31, 1000);
        GivePlayerWeapon(playerid, 25, 500);
	}
	SetPlayerPos(playerid, Pursuit_Spawn[Pursuit_TotalJoins][0],Pursuit_Spawn[Pursuit_TotalJoins][1],Pursuit_Spawn[Pursuit_TotalJoins][2]);
    PutPlayerInVehicle(playerid,Pursuit_Vehicle_IDs[Pursuit_Join_ID[playerid]],0);
	Pursuit_TotalJoins++;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(Event_InProgress==0)
	{
	    SendClientMessage(playerid, -1, "[Debug:] First If");
	    if(GetPVarInt(playerid, "InEvent")==1)
	    {
	        SendClientMessage(playerid, -1, "[Debug:] Second If");
	        if(Event_ID==Event_ID_Pursuit)
	        {
	            SendClientMessage(playerid, -1, "[Debug:] Third If");
	            if(Pursuit_Event_Mod==1)
	            {
	                SendClientMessage(playerid, -1, "[Debug:] Fourth If");
					SendClientMessage(playerid, COLOR_NOTICE, "[Event Notice:] You are outtaf event for leaving your vehicle.");
		            Pursuit_PlayerLeave(playerid);
				}
			}
	    }
	}
	return 1;
}

stock Pursuit_PlayerDeath(playerid)
{
	FoCo_Event_Died[playerid]=1;
	Pursuit_PlayerLeave(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    if(GetPVarInt(playerid, "InEvent")==1)
	{
		if(Event_ID==Event_ID_Pursuit)
		{
			Pursuit_PlayerDeath(playerid);
		}
	}
	return 1;
}

CMD:pursuitstart(playerid)
{
    if(Event_InProgress == 1)
	{
    	Pursuit_EventDet(playerid);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Event already in progress.");
	}
	return 1;
}

CMD:pursuitend(playerid)
{
    if(Event_InProgress == 0)
	{
    	Pursuit_EventEnd();
    	format(Pursuit_MSG, sizeof(Pursuit_MSG), "[Event:] %s has stopped the event.", PlayerName(playerid));
    	SendClientMessageToAll(COLOR_NOTICE, Pursuit_MSG);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] No event in progress to end.");
	}
	return 1;
}

CMD:join(playerid, params[])
{
	if(Event_InProgress == 0)
	{
	    if(GetPVarInt(playerid, "InEvent")==0)
	    {
		    if(FoCo_Event_Died[playerid]==0)
		    {
			    if(Event_ID==Event_ID_Pursuit)
				{
					Pursuit_EventJoin(playerid);
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You died in event nigga.");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You are already in event.");
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] No event in progress.");
	}
	return 1;
}

CMD:pursuitleave(playerid, params[])
{ 		
	if(Event_InProgress == 0)
	{
		if(GetPVarInt(playerid, "InEvent")==1||FoCo_Event_Died[playerid]==1)
	    {
			if(Event_ID==Event_ID_Pursuit)
			{
				Pursuit_PlayerLeave(playerid);
   			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You are not in any event.");
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] No event in progress.");
	}
	return 1;
}

public OnFilterScriptInit()
{
	Event_InProgress=1;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	FoCo_Team[playerid]=GetPVarInt(playerid, "TeamID");
}
