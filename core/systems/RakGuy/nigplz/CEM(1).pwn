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
* Filename: cem.pwn                                                              *
* Author:  RakGuy                                                                *
*********************************************************************************/
#include <YSI\y_hooks>
/*******************************************************************************
	  				Custom Event Maker - Version 1.0
*******************************************************************************/
#define DIALOG_CEM 534
#define CEM_YN ("{00FF00}Yes") : ("{FF0000}No")
#define EVENT_CEM 22
#define CEM_TDM_TEAMA   0x0080FFFF
#define CEM_TDM_TEAMB   0xFF8000FF

/******************************************************************************/
/////////////////////////////GLOBAL VARIABLES///////////////////////////////////
/******************************************************************************/
	/*************************************************
 					DIALOG VARIABLES
	*************************************************/
enum CEM_Dialog_Det
{
	dialog_type,
	dialog_head[50],
	dialog_content[400],
	button1[10],
	button2[10]
};
new CEM_Dialogs[5][CEM_Dialog_Det]=
{
						//MAIN DIALOG
{2, "Custom Event Maker:", "Team DeathMatch\nRace\nFFA","Select","Exit"},
						//TDM
{2, "Team DeathMatch","Spawns \t\t{00ff00}%s\nSkin[Team A] \t\t{00ff00}%i\nSkin[Team B] \t\t{00ff00}%i\nWeapon1:  {0000ff}ID:  {00ff00}%i {0000ff}Ammo:  {00ff00}%i\nWeapon2:  {0000ff}ID:  {00ff00}%i {0000ff}Ammo:  {00ff00}%i\nWeapon3:  {0000ff}ID:  {00ff00}%i {0000ff}Ammo:  {00ff00}%i\nWeapon4:  {0000ff}ID:  {00ff00}%i {0000ff}Ammo:  {00ff00}%i","Select","Exit"},
						//Race
{2, "Race", "Spawn Points \t\t{00ff00}%i\nCheckPointType \t{00FF00}%s\nCheckPoints \t\t{00ff00}%i\nVehicleID \t\t{00ff00}%i","Select","Exit"},
						//FFA - Sumo
{2, "Free-For-All : Sumo", "Type \t\t\t{00ff00}Sumo\nSpawnPoints \t\t{00ff00}%i\nVehicleID \t\t{00ff00}%i","Select","Exit"},
						//FFA - DM
{2, "Free-For-All : DeathMatch", "Type \t\t\t{00ff00}DeathMatch\nSpawnPoints \t\t{00ff00}%i\nRejoinable \t\t{00ff00}%s\nWeapon1:  {0000ff}ID:  {00ff00}%i {0000ff}Ammo:  {00ff00}%i\nWeapon2:  {0000ff}ID:  {00ff00}%i {0000ff}Ammo:  {00ff00}%i\nWeapon3:  {0000ff}ID:  {00ff00}%i {0000ff}Ammo:  {00ff00}%i\nWeapon4:  {0000ff}ID:  {00ff00}%i {0000ff}Ammo:  {00ff00}%i\nArmour \t\t\t{00ff00}%s","Select","Exit"}
};
new CEM_Event_Type[MAX_PLAYERS];
new CEM_Selected_list[MAX_PLAYERS];
new CEM_Selected_list_dialog_show[MAX_PLAYERS];
	/*************************************************
		ENUM[Credits to Vista for info] VARIABLES
	*************************************************/
enum
{
	NILVALUE,
	TDM,
	RACE,
	FFA_SUMO,
	FFA_DM
};
	/*************************************************
 					COMMON VARIABLES
	*************************************************/
new CEM_RUNNING;
new CEM_Player_JoinID[MAX_PLAYERS];
new CEM_MSG[500];
new CEM_Startable[4];
new CEM_JoinCount;

	/*************************************************
 					Variables for TDM
	*************************************************/
new Float:CEM_TDM_Spawns[2][4];
new CEM_Team_Skins[2];
new CEM_TDM_Weapons[4][2];
new CEM_AliveCount[2];
new CEM_TDM_JoinCount;
new CEM_TDM_PTeam[MAX_PLAYERS];
new CEM_Spawns_Set;
new CEM_TDM_INT;
new CEM_TDM_LSTSpawner;
	/*************************************************
 					Variables for RACE
	*************************************************/
new Float:CEM_Race_Spawns[MAX_PLAYERS][4];
new CEM_Race_SpawnCount;
new Float:CEM_Race_CP[50][3];
new CEM_Race_CPCount;
new CEM_Race_VehID;
new CEM_Race_CPType;
new CEM_Race_INT;
new CEM_Race_VEHIDList[MAX_PLAYERS];
new CEM_Race_Alive;
new CEM_Race_JoinCount;
new CEM_Race_CPIDs[50];
new CEM_Race_CurrCP[MAX_PLAYERS];
new CEM_Race_CPNames[2][30]=
{
	"Normal - [Horizontal-Road]", "Circle - [Circular-Air]"
};
new CEM_FinishedCount;

	/*************************************************
 					Variables for FFA
	*************************************************/
new Float:CEM_FFA_Spawns[MAX_PLAYERS][4];
new CEM_FFA_INT;
new CEM_FFA_SpawnCount;
new CEM_FFA_JoinCount;
new CEM_FFA_VehID;
new CEM_FFA_Weapons[4][2];
new CEM_FFA_Rejoin;
new bool:CEM_FFA_Armour;
new CEM_FFA_Alive;
new CEM_FFA_VEHIDList[200];


/*******************************************************************************
////////////////////CUSTOM EVENT MAKER PUBLIC CALLBACKS/////////////////////////
*******************************************************************************/
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid==DIALOG_CEM)
	{
	    CEM_GetDetails(playerid, response, listitem, inputtext);
		return 1;
	}
	return 0;
}

hook OnPlayerExitVehicle(playerid, vehicleid)
{
	if(Event_InProgress!=-1)
 	{
		if(Event_ID==EVENT_CEM)
		{
			if(GetPVarInt(playerid, "InEvent")==1)
			{
		   		if(CEM_RUNNING==FFA_SUMO)
				{
					CEM_FFS_EventLeave(playerid);
	    		}
				else if(CEM_RUNNING==RACE)
				{
    				CEM_Race_EventLeave(playerid);
        		}
			}
		}
	}
	return 1;
}

hook OnPlayerEnterDynamicRaceCP(playerid, checkpointid)
{
	if(Event_InProgress!=-1)
	{
		if(checkpointid==CEM_Race_CPIDs[CEM_Race_CurrCP[playerid]])
		{
		    if(CEM_Race_CurrCP[playerid]==CEM_Race_CPCount-1)
		    {
		        TogglePlayerDynamicRaceCP(playerid, checkpointid, 0);
				CEM_FinishedCount++;
				if(CEM_FinishedCount==1)
				{
					format(CEM_MSG, sizeof(CEM_MSG), "[Event Notice:]%s won the race Event.", PlayerName(playerid));
					SendClientMessageToAll(COLOR_NOTICE, CEM_MSG);
				}
				else
				{
					format(CEM_MSG, sizeof(CEM_MSG), "[Event Notice:]%i - %s.",CEM_FinishedCount, PlayerName(playerid));
					SendClientMessageToAll(COLOR_NOTICE, CEM_MSG);
				}
    			if(CEM_FinishedCount==CEM_Race_JoinCount)
		        {
		            CEM_Race_EventEnd();
		        }
				CEM_Race_EventLeave(playerid);
			}
			else
			{
			    CEM_Race_CurrCP[playerid]++;
			    TogglePlayerDynamicRaceCP(playerid, checkpointid, 0);
			    TogglePlayerDynamicRaceCP(playerid, CEM_Race_CPIDs[CEM_Race_CurrCP[playerid]], 1);
			}
		}
	}
	return 0;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	if(GetPVarInt(playerid, "InEvent")==1)
	{
		if(Event_InProgress!=-1)
		{
			if(Event_ID==EVENT_CEM)
			{
			    CEM_CallFunction(2, playerid);
			}
		}
	}
	return 1;
}
hook OnPlayerSpawn(playerid)
{
	if(FoCo_Event_Died[playerid]==1)
	{
	    if(CEM_RUNNING==TDM)
	    {
			SetPlayerSkin(playerid, GetPVarInt(playerid, "MotelSkin"));
   			SetPlayerColor(playerid,GetPVarInt(playerid, "MotelColor"));
		}
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(GetPVarInt(playerid, "InEvent")==1)
	{
		if(Event_InProgress!=-1)
		{
			if(Event_ID==EVENT_CEM)
			{
			    CEM_CallFunction(2, playerid);
			}
		}
	}
	return 1;
}

hook OnPlayerConnect(playerid)
{
	SetPVarInt(playerid, "InEvent", 0);
	FoCo_Event_Died[playerid]=0;
	return 1;
}

hook OnGameModeInit()
{
	Event_InProgress=-1;
	CEM_TDM_LSTSpawner=-1;
}
/*******************************************************************************
/////////////////End of CUSTOM EVENT MAKER PUBLIC CALLBACKS/////////////////////
*******************************************************************************/
/******************************************************************************/
/////////////////////CUSTOM EVENT MAKER DIALOG *Special*////////////////////////
/******************************************************************************/

/*******************************************************************************
					CUSTOM EVENT MAKER MESSAGE MAKER
*******************************************************************************/
stock CreateMessage(CEM_ID)
{
	CEM_MSG="";
	if(CEM_ID==1)
	{
		format(CEM_MSG, sizeof(CEM_MSG),CEM_Dialogs[CEM_ID][dialog_content],(CEM_Spawns_Set==1) ? CEM_YN,CEM_Team_Skins[0],CEM_Team_Skins[1],CEM_TDM_Weapons[0][0],CEM_TDM_Weapons[0][1],CEM_TDM_Weapons[1][0],CEM_TDM_Weapons[1][1],CEM_TDM_Weapons[2][0],CEM_TDM_Weapons[2][1],CEM_TDM_Weapons[3][0],CEM_TDM_Weapons[3][1]);
	}
	else if(CEM_ID==2)
	{
	    format(CEM_MSG, sizeof(CEM_MSG),CEM_Dialogs[CEM_ID][dialog_content],CEM_Race_SpawnCount,CEM_Race_CPNames[CEM_Race_CPType/3],CEM_Race_CPCount,CEM_Race_VehID);
	}
	else if(CEM_ID==3)
	{
		format(CEM_MSG, sizeof(CEM_MSG),CEM_Dialogs[CEM_ID][dialog_content],CEM_FFA_SpawnCount,CEM_FFA_VehID);
	}
	else if(CEM_ID==FFA_DM)
	{
		format(CEM_MSG, sizeof(CEM_MSG),CEM_Dialogs[CEM_ID][dialog_content],CEM_FFA_SpawnCount,(CEM_FFA_Rejoin==1) ? CEM_YN,CEM_FFA_Weapons[0][0],CEM_FFA_Weapons[0][1],CEM_FFA_Weapons[1][0],CEM_FFA_Weapons[1][1],CEM_FFA_Weapons[2][0],CEM_FFA_Weapons[2][1],CEM_FFA_Weapons[3][0],CEM_FFA_Weapons[3][1],(CEM_FFA_Armour==true) ? CEM_YN);
	}
	if(CEM_Startable[CEM_ID-1]==1)
	{
	    format(CEM_MSG, sizeof(CEM_MSG), "%s\n{112233}Start Event",CEM_MSG);
	}
	return 1;
}

/*******************************************************************************
					CUSTOM EVENT MAKER DIALOG CREATOR
*******************************************************************************/
stock CEM_GetDetails(playerid, response, listitem, params[])
{
	/*************************************************
 				    DIALOG MAIN[/cem]
	*************************************************/

	if(CEM_Event_Type[playerid]==NILVALUE)
	{
		if(!response)
		{
		    SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE:] CEM tab closed!");
		    return 1;
		}
		else
		{
  			if(CEM_Spawns_Set==1&&(CEM_Team_Skins[0]!=CEM_Team_Skins[1]))
			{
			    CEM_Startable[0]=1;
			}
			else
			{
			    CEM_Startable[0]=0;
			}
			if(CEM_Race_SpawnCount!=0&&CEM_Race_CPCount!=0&&CEM_Race_VehID!=0)
			{
			    CEM_Startable[1]=1;
			}
			else
			{
			    CEM_Startable[1]=0;
			}
			if(CEM_FFA_SpawnCount!=0)
			{
			    CEM_Startable[2]=1;
                CEM_Startable[3]=1;
			}
			else
			{
			    CEM_Startable[2]=0;
                CEM_Startable[3]=0;
			}
			if(listitem+1==CEM_RUNNING||CEM_RUNNING-1==FFA_SUMO)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Do not edit while that event is running");
				return 1;
			}
			else
			{
				CEM_Event_Type[playerid]=listitem+1;
		        CreateMessage(CEM_Event_Type[playerid]);
				CEM_Selected_list_dialog_show[playerid]=-1;
	   			CEM_Selected_list[playerid]=-1;
				ShowPlayerDialog(playerid, DIALOG_CEM, CEM_Dialogs[CEM_Event_Type[playerid]][dialog_type], CEM_Dialogs[CEM_Event_Type[playerid]][dialog_head],CEM_MSG,CEM_Dialogs[CEM_Event_Type[playerid]][button1],CEM_Dialogs[CEM_Event_Type[playerid]][button2]);
			}
		}
	}
	/*************************************************
 					 DIALOG TDM
	*************************************************/
	else if(CEM_Event_Type[playerid]==TDM)
	{
	    if(CEM_Selected_list[playerid]==-1)
	    {

  			if(!response)
		    {
		      	CEM_Event_Type[playerid]=0;
				ShowPlayerDialog(playerid, DIALOG_CEM, CEM_Dialogs[CEM_Event_Type[playerid]][dialog_type], CEM_Dialogs[CEM_Event_Type[playerid]][dialog_head],CEM_Dialogs[CEM_Event_Type[playerid]][dialog_content],CEM_Dialogs[CEM_Event_Type[playerid]][button1],CEM_Dialogs[CEM_Event_Type[playerid]][button2]);
  			}
  			else
  			{
				CEM_Selected_list[playerid]=listitem;
			    switch(listitem)
			    {
			        case 0:
			        {
						CEM_Event_Type[playerid]=0;
						if(CEM_Spawns_Set!=1)
						{
						    SendClientMessage(playerid, COLOR_SYNTAX, "[Usage:] Use /ctdmspawn1 && /ctdmspawn2");
						}
						else
						{
						    SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE:] Another admin already set two Coordinates, use it or replace it using /ctdmspawn1 && /ctdmspawn2.");
						}
	    				return 1;
					}
			        case 1:
			        {
			            ShowPlayerDialog(playerid, DIALOG_CEM, 1, "Team Skin A:", "Please type the Skin ID of Team A:", "Next", "Reset");
					}
					case 2:
			        {
			            ShowPlayerDialog(playerid, DIALOG_CEM, 1, "Team Skin B:", "Please type the Skin ID of Team B:", "Next", "Reset");
					}
					case 3,4,5,6:
			        {
			            ShowPlayerDialog(playerid, DIALOG_CEM, 1, "Weapon ID:", "Please type the Weapon with Ammo:\nFormat:{ff0000}WeaponID<space>Ammo", "Next", "Reset");
					}
					case 7:
					{
					    if(Event_InProgress==-1)
					    {
						    CEM_RUNNING=TDM;
						    CEM_CallFunction(0, playerid);
						}
						else
						{
						    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Already one event in progress");
						}
					}
			    }
			}
		}
		else
		{
		    if(CEM_RUNNING!=TDM)
		    {
				switch(CEM_Selected_list[playerid])
			    {
					case 1:
					{
					    if(!response)
					    {
					        CEM_Event_Type[playerid]=0;
					        CEM_Team_Skins[0]=0;
					        //Skin A Reset
					        CEM_GetDetails(playerid, 1, 0, "");
					    }
					    else
					    {
	                        CEM_Event_Type[playerid]=0;
						    sscanf(params, "I(32)",CEM_Team_Skins[0]);
						    //Skin A Chosen
						    if(CEM_Team_Skins[0]>=300||CEM_Team_Skins[0]<=0)
							{
							    CEM_Team_Skins[0]=32;
							}
						    CEM_GetDetails(playerid, 1, 0, "");
						}
					}
					case 2:
					{
					    if(!response)
					    {
					        CEM_Event_Type[playerid]=0;
					        CEM_Team_Skins[1]=0;
					        //Skin B Reset
					        CEM_GetDetails(playerid, 1, 0, "");
					    }
					    else
					    {
	                        CEM_Event_Type[playerid]=0;
						    sscanf(params, "I(288)",CEM_Team_Skins[1]);
							if(CEM_Team_Skins[1]>=300||CEM_Team_Skins[1]<=0)
							{
							    CEM_Team_Skins[1]=288;
							}
							//Skin B Choose
						    CEM_GetDetails(playerid, 1, 0, "");
						}
					}
					case 3,4,5,6:
					{
					    if(!response)
					    {
					        CEM_Event_Type[playerid]=0;
	                        CEM_TDM_Weapons[CEM_Selected_list[playerid]-3][0]=0;
	                        CEM_TDM_Weapons[CEM_Selected_list[playerid]-3][1]=0;
					        //Weapon Reset
					        CEM_GetDetails(playerid, 1, 0, "");
					    }
					    else
					    {
	                        CEM_Event_Type[playerid]=0;
						    sscanf(params, "I(0)I(0)",CEM_TDM_Weapons[CEM_Selected_list[playerid]-3][0],CEM_TDM_Weapons[CEM_Selected_list[playerid]-3][1]);
						    //Weapon Choose
						    CEM_GetDetails(playerid, 1, 0, "");
						}
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Do not edit while that event is running");
				return 1;
			}
		}
	}
	/*************************************************
 					 DIALOG RACE
	*************************************************/
	else if(CEM_Event_Type[playerid]==RACE)
	{
	    if(CEM_Selected_list[playerid]==-1)
	    {
  			if(!response)
		    {
		      	CEM_Event_Type[playerid]=0;
				ShowPlayerDialog(playerid, DIALOG_CEM, CEM_Dialogs[CEM_Event_Type[playerid]][dialog_type], CEM_Dialogs[CEM_Event_Type[playerid]][dialog_head],CEM_Dialogs[CEM_Event_Type[playerid]][dialog_content],CEM_Dialogs[CEM_Event_Type[playerid]][button1],CEM_Dialogs[CEM_Event_Type[playerid]][button2]);
  			}
  			else
  			{
				CEM_Selected_list[playerid]=listitem;
			    switch(listitem)
			    {
			        case 0:
			        {
			            CEM_Event_Type[playerid]=0;
			            SendClientMessage(playerid, COLOR_NOTICE, "[CEM_NOTICE:]Use /setracespawn to create spawn and /resetracespawn to reset.");
						return 1;
					}
			        case 1:
			        {
			            if(CEM_RUNNING!=RACE)
			            {
				            CEM_Event_Type[playerid]=0;
				            CEM_Race_CPType=(CEM_Race_CPType==0)?(3):(0);
				            CEM_GetDetails(playerid, 1, 1, "");
						}
						else
						{
						    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You can not set it while event is running.");
						    return 1;
						}
					}
					case 2:
			        {
			            CEM_Event_Type[playerid]=0;
			            SendClientMessage(playerid, COLOR_NOTICE, "[CEM_NOTICE:]Use /setracecp to create spawn and /resetracecp to reset.");
						return 1;
					}
					case 3:
			        {
			            ShowPlayerDialog(playerid, DIALOG_CEM, 1, "Vehicle:", "Please type the Vehicle ID:", "Next", "Reset");
					}
					case 4:
					{
 						if(Event_InProgress==-1)
					    {
						    CEM_RUNNING=RACE;
						    CEM_CallFunction(0, playerid);
						}
						else
						{
						    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Already one event in progress");
						}
					}
			    }
			}
		}
		else
		{
  			if(CEM_RUNNING!=RACE)
			{
			    switch(CEM_Selected_list[playerid])
			    {
					case 3:
					{
					    if(!response)
					    {
					        CEM_Event_Type[playerid]=0;
					        CEM_Race_VehID=411;
					        //VehicleID Reset
					        CEM_GetDetails(playerid, 1,1, "");
					    }
					    else
					    {
	                        CEM_Event_Type[playerid]=0;
						    sscanf(params, "I(411)",CEM_Race_VehID);
						    //VehicleID Choose
						    CEM_GetDetails(playerid, 1,1, "");
						}
					}
			    }
			}
			else
			{
   				SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You can not set it while event is running.");
				return 1;
			}
		}
	}
	/*************************************************
				    DIALOG - FFA - SUMO
	*************************************************/
	else if(CEM_Event_Type[playerid]==FFA_SUMO)
	{
	    if(CEM_Selected_list[playerid]==-1)
	    {
  			if(!response)
		    {
		      	CEM_Event_Type[playerid]=0;
				ShowPlayerDialog(playerid, DIALOG_CEM, CEM_Dialogs[CEM_Event_Type[playerid]][dialog_type], CEM_Dialogs[CEM_Event_Type[playerid]][dialog_head],CEM_Dialogs[CEM_Event_Type[playerid]][dialog_content],CEM_Dialogs[CEM_Event_Type[playerid]][button1],CEM_Dialogs[CEM_Event_Type[playerid]][button2]);
  			}
  			else
  			{
				CEM_Selected_list[playerid]=listitem;
			    switch(listitem)
			    {
			        case 0:
			        {
						CEM_Event_Type[playerid]=4;
						CreateMessage(CEM_Event_Type[playerid]);
						CEM_Selected_list_dialog_show[playerid]=-1;
			   			CEM_Selected_list[playerid]=-1;
						ShowPlayerDialog(playerid, DIALOG_CEM, CEM_Dialogs[CEM_Event_Type[playerid]][dialog_type], CEM_Dialogs[CEM_Event_Type[playerid]][dialog_head],CEM_MSG,CEM_Dialogs[CEM_Event_Type[playerid]][button1],CEM_Dialogs[CEM_Event_Type[playerid]][button2]);
					}
			        case 1:
			        {
			            CEM_Event_Type[playerid]=0;
			            SendClientMessage(playerid, COLOR_NOTICE, "[CEM_NOTICE:]Use /setffaspawn to create spawn and /resetffaspawn to reset.:");
						return 1;
					}
					case 2:
			        {
			            ShowPlayerDialog(playerid, DIALOG_CEM, 1, "Vehicle:", "Please type the Vehicle ID:", "Next", "Reset");
					}
					case 3:
					{
 						if(Event_InProgress==-1)
					    {

						    if(CEM_FFA_VehID!=0)
						    {
							    CEM_RUNNING=FFA_SUMO;
							    CEM_CallFunction(0, playerid);
							}
							else
							{
							    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Select VEH BITCH");
							}
						}
						else
						{
						    	SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Already one event in progress");
						}
					}
			    }
			}
		}
		else
		{
			if(CEM_RUNNING!=FFA_SUMO)
			{
    		    switch(CEM_Selected_list[playerid])
			    {
					case 2:
					{
					    if(!response)
					    {
					        CEM_Event_Type[playerid]=0;
					        CEM_FFA_VehID=444;
					        //VehicleID Reset
					        CEM_GetDetails(playerid, 1,2, "");
					    }
					    else
					    {
	                        CEM_Event_Type[playerid]=0;
						    sscanf(params, "I(444)",CEM_FFA_VehID);
						    //VehicleID Choose
						    CEM_GetDetails(playerid, 1,2, params);
						}
					}
			    }
			}
			else
			{
   				SendClientMessage(playerid, COLOR_WARNING, "[ERROR:]  You can not set it while event running.");
				return 1;
			}
	
		}
	}
	/*************************************************
 					DIALOG - FFA - DM
	*************************************************/
	else if(CEM_Event_Type[playerid]==FFA_DM)
	{
	    if(CEM_Selected_list[playerid]==-1)
	    {
  			if(!response)
		    {
		      	CEM_Event_Type[playerid]=0;
				ShowPlayerDialog(playerid, DIALOG_CEM, CEM_Dialogs[CEM_Event_Type[playerid]][dialog_type], CEM_Dialogs[CEM_Event_Type[playerid]][dialog_head],CEM_Dialogs[CEM_Event_Type[playerid]][dialog_content],CEM_Dialogs[CEM_Event_Type[playerid]][button1],CEM_Dialogs[CEM_Event_Type[playerid]][button2]);
  			}
  			else
  			{
				CEM_Selected_list[playerid]=listitem;
			    switch(listitem)
			    {
			        case 0:
			        {
						CEM_Event_Type[playerid]=3;
						CreateMessage(CEM_Event_Type[playerid]);
						CEM_Selected_list_dialog_show[playerid]=-1;
			   			CEM_Selected_list[playerid]=-1;
						ShowPlayerDialog(playerid, DIALOG_CEM, CEM_Dialogs[CEM_Event_Type[playerid]][dialog_type], CEM_Dialogs[CEM_Event_Type[playerid]][dialog_head],CEM_MSG,CEM_Dialogs[CEM_Event_Type[playerid]][button1],CEM_Dialogs[CEM_Event_Type[playerid]][button2]);
					}
			        case 1:
			        {
			            CEM_Event_Type[playerid]=0;
			            SendClientMessage(playerid, COLOR_NOTICE, "[CEM_NOTICE:]Use /setffaspawn to create spawn and /resetffaspawn to reset.:");
						return 1;
					}
					case 2:
			        {
			            CEM_Event_Type[playerid]=0;
						//Edit required here. Main rejoin option
			            CEM_FFA_Rejoin=(CEM_FFA_Rejoin==1)?2:1;
                        CEM_GetDetails(playerid, 1, 3, "");
					}
					case 3,4,5,6:
			        {
			            ShowPlayerDialog(playerid, DIALOG_CEM, 1, "Weapon ID:", "Please type the Weapon with Ammo:\nFormat:{ff0000}WeaponID<space>Ammo", "Next", "Reset");
					}
					case 7:
					{
	    				CEM_Event_Type[playerid]=0;
					    CEM_FFA_Armour=(CEM_FFA_Armour==true)?false:true;
					    CEM_GetDetails(playerid, 1, 3, "");
					}
					case 8:
					{
	    				if(Event_InProgress==-1)
					    {
						    CEM_RUNNING=FFA_DM;
						    CEM_CallFunction(0, playerid);
						}
						else
						{
						    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Already one event in progress");
						}
					}
			    }
			}
		}
		else
		{
		    if(CEM_RUNNING!=FFA_DM)
		    {
			    switch(CEM_Selected_list[playerid])
			    {
					case 3,4,5,6:
					{
					    if(!response)
					    {
					        CEM_Event_Type[playerid]=0;
	                        CEM_FFA_Weapons[CEM_Selected_list[playerid]-3][0]=0;
	                        CEM_FFA_Weapons[CEM_Selected_list[playerid]-3][1]=0;
					        //Weapon Reset
					        CEM_GetDetails(playerid, 1, 3, "");
					    }
					    else
					    {
	                        CEM_Event_Type[playerid]=0;
						    sscanf(params, "I(0)I(0)",CEM_FFA_Weapons[CEM_Selected_list[playerid]-3][0],CEM_FFA_Weapons[CEM_Selected_list[playerid]-3][1]);
						    //Weapon Choose
						    CEM_GetDetails(playerid, 1, 3, params);
						}
					}
			    }
            			}
			else
			{
   				SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You can not set it while event running.");
				return 1;
			}
		}
	}
	return 1;
}

/*******************************************************************************
///////////////////////////////FUNCTION DETOUR//////////////////////////////////
*******************************************************************************/
new Timer:TimerID;
new TimerTime;
timer CEM_EventStart[1000]()
{
	if(Event_InProgress==0)
	{
		TimerTime--;
	}
	else
	{
	    stop TimerID;
	}
	if(TimerTime==0)
	{
		stop TimerID;
	    if(CEM_JoinCount>1)
	    {
		    foreach(Player,i)
		    {
			    if(GetPVarInt(i, "InEvent")==1)
		        {
					GameTextForPlayer(i, "~r~Custom Event Started", 3, 1);
					TogglePlayerControllable(i, 1);
		        }
		    }
			SendClientMessageToAll(COLOR_NOTICE, "[Event Notice:] Custom event has started.");
		    Event_InProgress=1;
		}
		else if(CEM_JoinCount<=1)
		{
		    SendClientMessageToAll(COLOR_NOTICE, "[Event Notice:] Event ended due to less number of players.");
		    CEM_CallFunction(3, -1);
		}
	}
}
stock CEM_TIMER()
{
    TimerID = repeat CEM_EventStart();
	return 1;
}

stock CEM_CallFunction(FuncID, playerid)
{
	if(FuncID==0&&CEM_RUNNING!=FFA_DM)
	{
	    CEM_JoinCount=0;
		TimerTime=30;
	    CEM_TIMER();
	}
	if(FuncID==1&&Event_InProgress==0&&CEM_RUNNING!=FFA_DM)
	{
	    CEM_JoinCount++;
	    format(CEM_MSG, sizeof(CEM_MSG), "[Notice]Event will start in %i seconds.", TimerTime);
	    SendClientMessage(playerid, COLOR_NOTICE,CEM_MSG);
		TogglePlayerControllable(playerid, 0);
	}
	if(FuncID==2 || FuncID ==4)
	{
	    SetPVarInt(playerid, "PlayerStatus", 0);
	}
	/*************************************************
	                      TDM
	*************************************************/
	if(CEM_RUNNING==TDM)
	{
	    if(FuncID==0)
	    {
	        CEM_TDM_EventStart(playerid);
	    }
   	    if(FuncID==1)
	    {
            CEM_TDM_Join(playerid);
	    }
   	    if(FuncID==2)
	    {
            CEM_TDM_EventDeath(playerid);
	    }
	    if(FuncID==3)
	    {
            CEM_TDM_EventEnd();
	    }
	    if(FuncID==4)
	    {
            CEM_TDM_EventLeave(playerid);
	    }
	}
	/*************************************************
	                      RACE
	*************************************************/
	if(CEM_RUNNING==RACE)
	{
	    if(FuncID==0)
	    {
	        CEM_Race_EventStart(playerid);
	    }
   	    if(FuncID==1)
	    {
            CEM_Race_Join(playerid);
	    }
   	    if(FuncID==2)
	    {
            CEM_Race_EventDeath(playerid);
	    }
	    if(FuncID==3)
	    {
            CEM_Race_EventEnd();
	    }
	    if(FuncID==4)
	    {
            CEM_Race_EventLeave(playerid);
	    }
	}
	/*************************************************
					   FFA - SUMO
	*************************************************/
	if(CEM_RUNNING==FFA_SUMO)
	{
	    if(FuncID==0)
	    {
	        CEM_FFS_EventStart(playerid);
	    }
   	    if(FuncID==1)
	    {
            CEM_FFS_Join(playerid);
	    }
   	    if(FuncID==2)
	    {
            CEM_FFS_EventDeath(playerid);
	    }
	    if(FuncID==3)
	    {
            CEM_FFS_EventEnd();
	    }
	    if(FuncID==4)
	    {
            CEM_FFS_EventLeave(playerid);
	    }
	}
	/*************************************************
					   FFA - DM
	*************************************************/
	if(CEM_RUNNING==FFA_DM)
	{
	    if(FuncID==0)
	    {
	        CEM_FFDM_EventStart(playerid);
	    }
   	    if(FuncID==1)
	    {
            CEM_FFDM_Join(playerid);
	    }
   	    if(FuncID==2)
	    {
            CEM_FFDM_EventDeath(playerid);
	    }
	    if(FuncID==3)
	    {
            CEM_FFDM_EventEnd();
	    }
	    if(FuncID==4)
	    {
            CEM_FFDM_EventLeave(playerid);
	    }
	}
	return 1;
}
/*******************************************************************************
///////////////////CUSTOM EVENT MAKER MAIN STOCK FUNCTIONS//////////////////////
*******************************************************************************/
/*******************************************************************************
							TEAM DEATH MATCH
*******************************************************************************/

stock CEM_TDM_EventStart(playerid)
{
	foreach(Player, i)
    {
	    FoCo_Event_Died[i] = 0;
	    SetPVarInt(i, "InEvent", 0);
    }
    format(CEM_MSG, sizeof(CEM_MSG), "[EVENT]: %s %s has started {%06x}Custom TDM {%06x}event.  Type /cemjoin!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_NOTICE >>> 8);
    SendClientMessageToAll(COLOR_NOTICE, CEM_MSG);
    Event_InProgress = 0;
	Event_ID = EVENT_CEM;
	CEM_RUNNING=TDM;
	CEM_AliveCount[0]=CEM_AliveCount[1]=CEM_TDM_JoinCount=0;
    IRC_GroupSay(gLeads, IRC_FOCO_LEADS, CEM_MSG);
    return 1;
}


stock CEM_TDM_Join(playerid)
{
	ResetPlayerWeapons(playerid);
	SetPVarInt(playerid, "InEvent", 1);
	SetPlayerInterior(playerid, CEM_TDM_INT);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
 	SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
	CEM_Player_JoinID[playerid]=CEM_TDM_JoinCount;
	if(CEM_TDM_JoinCount%2==0)
	{
	    SetPVarInt(playerid, "MotelTeamIssued", 1);
		CEM_TDM_PTeam[playerid]=0;
		SetPlayerSkin(playerid, CEM_Team_Skins[0]);
		SetPlayerColor(playerid, CEM_TDM_TEAMA);
  		SetPlayerPos(playerid, CEM_TDM_Spawns[0][0]+(1.0*floatcos(90.0+(CEM_TDM_Spawns[0][0]+CEM_AliveCount[0]*1.8), degrees)), CEM_TDM_Spawns[0][1]+(1.0*floatsin(90.0-(CEM_TDM_Spawns[0][1]+CEM_AliveCount[0]*1.8), degrees)), CEM_TDM_Spawns[0][2]+2.0);
  		SetPlayerFacingAngle(playerid, float(random(360)));
		SetPlayerHealth(playerid, 99.0);
		SetPlayerArmour(playerid, 99.0);
		CEM_AliveCount[0]++;
	}
	else
	{
	    SetPVarInt(playerid, "MotelTeamIssued", 2);
	    CEM_TDM_PTeam[playerid]=1;
		SetPlayerSkin(playerid, CEM_Team_Skins[1]);
		SetPlayerColor(playerid, CEM_TDM_TEAMB);
		SetPlayerPos(playerid, CEM_TDM_Spawns[1][0]+(1.0*floatcos(90.0+(CEM_TDM_Spawns[1][0]+CEM_AliveCount[1]*1.8), degrees)), CEM_TDM_Spawns[1][1]+(1.0*floatsin(90.0-(CEM_TDM_Spawns[1][1]+CEM_AliveCount[1]*1.8), degrees)), CEM_TDM_Spawns[1][2]+2.0);
	    SetPlayerFacingAngle(playerid, float(random(360)));
		SetPlayerHealth(playerid, 99.0);
		SetPlayerArmour(playerid, 99.0);
		CEM_AliveCount[1]++;
	}
	for(new i=0; i<4; i++)
	{
	    GivePlayerWeapon(playerid, CEM_TDM_Weapons[i][0], CEM_TDM_Weapons[i][1]);
	}
	CEM_TDM_JoinCount++;
	return 1;
}
stock CEM_TDM_EventLeave(playerid)
{
    CEM_AliveCount[CEM_TDM_PTeam[playerid]]--;
   	format(CEM_MSG, sizeof(CEM_MSG), "Team A : %i - %i : Team B", CEM_AliveCount[0], CEM_AliveCount[1]);
	SendClientMessageToAll(COLOR_NOTICE, CEM_MSG);
	SetPlayerSkin(playerid, GetPVarInt(playerid, "MotelSkin"));
	SetPlayerColor(playerid,GetPVarInt(playerid, "MotelColor"));
	if(CEM_AliveCount[0]==0||CEM_AliveCount[1]==0)
	{
	    if(CEM_AliveCount[0]==0)
	    {
	        SendClientMessageToAll(-1, "[Event Notice:] Team B has won the event.");
	    }
		else
	    {
	        SendClientMessageToAll(-1, "[Event Notice:] Team A has won the event.");
	    }
        CEM_TDM_EventEnd();
	}
	FoCo_Event_Died[playerid]=1;
	SpawnPlayer(playerid);
}
stock CEM_TDM_EventDeath(playerid)
{
    CEM_AliveCount[CEM_TDM_PTeam[playerid]]--;
	format(CEM_MSG, sizeof(CEM_MSG), "Team A : %i - %i : Team B", CEM_AliveCount[0], CEM_AliveCount[1]);
	SendClientMessageToAll(COLOR_NOTICE, CEM_MSG);
    FoCo_Event_Died[playerid]=1;
    SetPVarInt(playerid, "InEvent",0);
	if(CEM_AliveCount[0]==0||CEM_AliveCount[1]==0)
	{
	    if(CEM_AliveCount[0]==0)
	    {
	        SendClientMessageToAll(-1, "[Event Notice:] Team B has won the event.");
	    }
		else
	    {
	        SendClientMessageToAll(-1, "[Event Notice:] Team A has won the event.");
	    }
        CEM_TDM_EventEnd();
	}
	return 1;
}
stock CEM_TDM_EventEnd()
{
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent")==1)
	    {
	    	FoCo_Event_Died[i] = 0;
			SetPVarInt(i, "InEvent", 0);
   			SetPlayerSkin(i, GetPVarInt(i, "MotelSkin"));
			SetPlayerColor(i,GetPVarInt(i, "MotelColor"));
   			SpawnPlayer(i);
		}
	}
	CEM_RUNNING=NILVALUE;
	Event_InProgress = -1;
	return 1;
}

/*******************************************************************************
									RACE
*******************************************************************************/
stock CEM_CreatRaceCPs()
{
	for(new i = 0; i<CEM_Race_CPCount; i++)
	{
	    if(i==CEM_Race_CPCount-1)
	    {
	    	CEM_Race_CPIDs[i]=CreateDynamicRaceCP(CEM_Race_CPType+1, CEM_Race_CP[i][0],CEM_Race_CP[i][1],CEM_Race_CP[i][2],CEM_Race_CP[i][0],CEM_Race_CP[i][1],CEM_Race_CP[i][2],10.0,1500,CEM_Race_INT,-1,1000000000000.0);
	    }
	    else
	    {
		    CEM_Race_CPIDs[i]=CreateDynamicRaceCP(CEM_Race_CPType, CEM_Race_CP[i][0],CEM_Race_CP[i][1],CEM_Race_CP[i][2],CEM_Race_CP[i+1][0],CEM_Race_CP[i+1][1],CEM_Race_CP[i+1][2],10.0,1500,CEM_Race_INT,-1,1000000000000.0);
	    }
	}
	foreach(Player, i)
	{
		TogglePlayerAllDynamicRaceCPs(i, 0);
	}
	return 1;
}
stock CEM_DestroyRaceCPs()
{
	for(new i=0; i<CEM_Race_CPCount; i++)
	{
		DestroyDynamicRaceCP(CEM_Race_CPIDs[i]);
	}
	return 1;
}
stock CEM_Race_EventStart(playerid) //Sumo
{
    foreach(Player, i)
    {
	    FoCo_Event_Died[i] = 0;
	    SetPVarInt(i, "InEvent", 0);
    }
    format(CEM_MSG, sizeof(CEM_MSG), "[EVENT]: %s %s has started {%06x}Custom Race {%06x}event.  Type /cemjoin!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_NOTICE >>> 8);
    SendClientMessageToAll(COLOR_NOTICE, CEM_MSG);
    Event_InProgress = 0;
	Event_ID = EVENT_CEM;
	CEM_Race_JoinCount=0;
	for(new i=0; i<CEM_Race_SpawnCount; i++)
	{
	    CEM_Race_VEHIDList[i]=0;
	}
	CEM_CreatRaceCPs();
	CEM_FinishedCount=0;
	CEM_Race_Alive=0;
    IRC_GroupSay(gLeads, IRC_FOCO_LEADS, CEM_MSG);
	return 1;
}
stock CEM_Race_Join(playerid)
{
	if(CEM_Race_JoinCount!=CEM_Race_SpawnCount)
	{
     	SetPlayerVirtualWorld(playerid, 1500);
		CEM_Race_VEHIDList[CEM_Race_JoinCount]=CreateVehicle(CEM_Race_VehID,0.0,0.0,0.0,CEM_Race_Spawns[CEM_Race_JoinCount][3],random(254),random(254),36000);
		SetVehiclePos(CEM_Race_VEHIDList[CEM_Race_JoinCount],CEM_Race_Spawns[CEM_Race_JoinCount][0],CEM_Race_Spawns[CEM_Race_JoinCount][1],CEM_Race_Spawns[CEM_Race_JoinCount][2]+2.0);
		LinkVehicleToInterior(CEM_Race_VEHIDList[CEM_Race_JoinCount],CEM_Race_INT);
        SetVehicleVirtualWorld(CEM_Race_VEHIDList[CEM_Race_JoinCount], 1500);
  		SetPlayerInterior(playerid,CEM_Race_INT);
	    SetPlayerPos(playerid,CEM_Race_Spawns[CEM_Race_JoinCount][0],CEM_Race_Spawns[CEM_Race_JoinCount][1],CEM_Race_Spawns[CEM_Race_JoinCount][2]+2.0);
		PutPlayerInVehicle(playerid,CEM_Race_VEHIDList[CEM_Race_JoinCount],0);
	    SetVehicleZAngle(CEM_Race_VEHIDList[CEM_Race_JoinCount],CEM_Race_Spawns[CEM_Race_JoinCount][3]);
		CEM_Player_JoinID[playerid]=CEM_Race_JoinCount;
        CEM_Race_CurrCP[playerid]=0;
		CEM_Race_JoinCount++;
		CEM_Race_Alive++;
		TogglePlayerDynamicRaceCP(playerid, CEM_Race_CPIDs[CEM_Race_CurrCP[playerid]], 1);
		SetPVarInt(playerid, "InEvent",1);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Event is full.");
	}
	return 1;
}
stock CEM_Race_EventDeath(playerid)
{
    FoCo_Event_Died[playerid]=1;
	SetPVarInt(playerid, "InEvent", 0);
	RemovePlayerFromVehicle(playerid);
	DestroyVehicle(CEM_Race_VEHIDList[CEM_Player_JoinID[playerid]]);
	CEM_Race_Alive--;
	if(CEM_Race_Alive==0)
	{
	    if(CEM_FinishedCount!=0)
	    {
	        SendClientMessageToAll(COLOR_NOTICE, "[Event Notice:] Event ended due to all other racers dying.");
	    }
	    else
	    {
	        SendClientMessageToAll(COLOR_NOTICE, "[Event Notice:] Event ended due to all racers dying.");
	    }
	    CEM_Race_EventEnd();
	}
	return 1;
}
stock CEM_Race_EventLeave(playerid)
{
	FoCo_Event_Died[playerid]=1;
	SetPVarInt(playerid, "InEvent", 0);
	RemovePlayerFromVehicle(playerid);
	SetVehicleToRespawn(CEM_Race_VEHIDList[CEM_Player_JoinID[playerid]]);
	DestroyVehicle(CEM_Race_VEHIDList[CEM_Player_JoinID[playerid]]);
	CEM_Race_VEHIDList[CEM_Player_JoinID[playerid]]=0;
	CEM_Race_Alive--;
	if(CEM_Race_Alive==0)
	{
        if(CEM_FinishedCount!=0)
	    {
	        SendClientMessageToAll(COLOR_NOTICE, "[Event Notice:] Event ended due to all racers finishing the race or quiting it.");
	    }
	    else
	    {
		    SendClientMessageToAll(COLOR_NOTICE, "[Event Notice:] Event ended due to all racers quiting.");
	    }
	    CEM_Race_EventEnd();
	}
	SpawnPlayer(playerid);
	return 1;
}
stock CEM_Race_EventEnd()
{

	foreach(Player, i)
    {
        if(GetPVarInt(i, "InEvent")==1)
        {
            RemovePlayerFromVehicle(i);
            SetVehicleToRespawn(CEM_Race_VEHIDList[CEM_Player_JoinID[i]]);
			SpawnPlayer(i);
        }
	    FoCo_Event_Died[i] = 0;
	    SetPVarInt(i, "InEvent", 0);
    }
	for(new i; i<CEM_Race_SpawnCount; i++)
	{
	    if(CEM_Race_VEHIDList[i]!=0)
		{
			DestroyVehicle(CEM_Race_VEHIDList[i]);
		}
	}
	CEM_RUNNING=NILVALUE;
	Event_InProgress = -1;
	CEM_DestroyRaceCPs();
	return 1;
}
/*******************************************************************************
						     Free For All - Sumo
*******************************************************************************/
stock CEM_FFS_EventStart(playerid) //Sumo
{
    foreach(Player, i)
    {
	    FoCo_Event_Died[i] = 0;
	    SetPVarInt(i, "InEvent", 0);
    }
    format(CEM_MSG, sizeof(CEM_MSG), "[EVENT]: %s %s has started {%06x}Custom FFA[Sumo] {%06x}event.  Type /cemjoin!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_NOTICE >>> 8);
    SendClientMessageToAll(COLOR_NOTICE, CEM_MSG);
    Event_InProgress = 0;
	Event_ID = EVENT_CEM;
	CEM_FFA_JoinCount=0;
	for(new i=0; i<CEM_FFA_SpawnCount; i++)
	{
	    CEM_FFA_VEHIDList[i]=0;
	}
	CEM_FFA_Alive=0;
    IRC_GroupSay(gLeads, IRC_FOCO_LEADS, CEM_MSG);
	return 1;
}
stock CEM_FFS_Join(playerid)
{
	if(CEM_FFA_JoinCount!=CEM_FFA_SpawnCount)
	{
		SetPlayerVirtualWorld(playerid, 1500);
		CEM_FFA_VEHIDList[CEM_FFA_JoinCount]=CreateVehicle(CEM_FFA_VehID,0.0,0.0,0.0,CEM_FFA_Spawns[CEM_FFA_JoinCount][3],random(254),random(254),36000);
		format(CEM_MSG, sizeof(CEM_MSG), "Vehid : %i created", CEM_FFA_VEHIDList[CEM_FFA_JoinCount]);
		SendClientMessageToAll(-1, CEM_MSG);
		SetVehiclePos(CEM_FFA_VEHIDList[CEM_FFA_JoinCount],CEM_FFA_Spawns[CEM_FFA_JoinCount][0],CEM_FFA_Spawns[CEM_FFA_JoinCount][1],CEM_FFA_Spawns[CEM_FFA_JoinCount][2]+2.0);
		LinkVehicleToInterior(CEM_FFA_VEHIDList[CEM_FFA_JoinCount],CEM_FFA_INT);
        SetVehicleVirtualWorld(CEM_FFA_VEHIDList[CEM_FFA_JoinCount], 1500);
		SetPlayerInterior(playerid,CEM_FFA_INT);
	    SetPlayerPos(playerid,CEM_FFA_Spawns[CEM_FFA_JoinCount][0],CEM_FFA_Spawns[CEM_FFA_JoinCount][1],CEM_FFA_Spawns[CEM_FFA_JoinCount][2]+2.0);
   		PutPlayerInVehicle(playerid,CEM_FFA_VEHIDList[CEM_FFA_JoinCount],0);
        SetVehicleZAngle(CEM_FFA_VEHIDList[CEM_FFA_JoinCount],CEM_FFA_Spawns[CEM_FFA_JoinCount][3]);
        CEM_Player_JoinID[playerid]=CEM_FFA_JoinCount;
		CEM_FFA_JoinCount++;
		CEM_FFA_Alive++;
		SetPVarInt(playerid, "InEvent",1);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Event full.");
	}
	return 1;
}

stock CEM_FFS_EventDeath(playerid)
{
    FoCo_Event_Died[playerid]=1;
   	SetPVarInt(playerid, "InEvent", 0);
	CEM_FFA_Alive--;
	if(CEM_FFA_Alive==1)
	{
		foreach(Player, i)
		{
		    if(GetPVarInt(i, "InEvent")==1)
		    {
		        format(CEM_MSG, sizeof(CEM_MSG), "%s has won the Custom-Sumo event.", PlayerName(i));
		        SendClientMessageToAll(COLOR_NOTICE, CEM_MSG);
		    }
		}
	    CEM_FFS_EventEnd();
	}
	RemovePlayerFromVehicle(playerid);
	DestroyVehicle(CEM_FFA_VEHIDList[CEM_Player_JoinID[playerid]]);
	return 1;
}
stock CEM_FFS_EventLeave(playerid)
{
	FoCo_Event_Died[playerid]=1;
   	SetPVarInt(playerid, "InEvent", 0);
	CEM_FFA_Alive--;
	if(CEM_FFA_Alive<=1)
	{
		foreach(Player, i)
		{
		    if(GetPVarInt(i, "InEvent")==1)
		    {
		        format(CEM_MSG, sizeof(CEM_MSG), "[Event_Notice:]%s has won the Custom-Sumo event.", PlayerName(i));
		        SendClientMessageToAll(COLOR_NOTICE, CEM_MSG);
		    }
		}
	    CEM_FFS_EventEnd();
	}
	RemovePlayerFromVehicle(playerid);
	DestroyVehicle(CEM_FFA_VEHIDList[CEM_Player_JoinID[playerid]]);
	CEM_FFA_VEHIDList[CEM_Player_JoinID[playerid]]=0;
	SpawnPlayer(playerid);
}
stock CEM_FFS_EventEnd()
{
	foreach(Player, i)
    {
        if(GetPVarInt(i, "InEvent")==1)
        {
            RemovePlayerFromVehicle(i);
            DestroyVehicle(CEM_FFA_VEHIDList[CEM_Player_JoinID[i]]);
			SpawnPlayer(i);
        }
	    FoCo_Event_Died[i] = 0;
	    SetPVarInt(i, "InEvent", 0);
    }
	for(new i; i<CEM_FFA_SpawnCount; i++)
	{
	    if(CEM_FFA_VEHIDList[i]!=0)
		{
			DestroyVehicle(CEM_FFA_VEHIDList[i]);
		}
	}
	CEM_RUNNING=NILVALUE;
	Event_InProgress = -1;
	return 1;
}
/*******************************************************************************
						Free For All - Death Match
*******************************************************************************/
stock CEM_FFDM_EventStart(playerid)
{
	foreach(Player, i)
    {
	    FoCo_Event_Died[i] = 0;
	    SetPVarInt(i, "InEvent", 0);
    }
    format(CEM_MSG, sizeof(CEM_MSG), "[EVENT]: %s %s has started {%06x}Custom FFA[DeathMatch] {%06x}event.  Type /cemjoin!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_NOTICE >>> 8);
	format(CEM_MSG, sizeof(CEM_MSG), "%s This event is %sRejoinable.", CEM_MSG, (CEM_FFA_Rejoin==1)?(""):("Non-"));
	SendClientMessageToAll(COLOR_NOTICE, CEM_MSG);
	Event_InProgress = 0;
	Event_ID = EVENT_CEM;
	CEM_FFA_JoinCount=0;
    IRC_GroupSay(gLeads, IRC_FOCO_LEADS, CEM_MSG);
	return 1;
}
stock CEM_FFDM_Join(playerid)
{
	ResetPlayerWeapons(playerid);
	SetPVarInt(playerid, "InEvent", 1);
	SetPlayerInterior(playerid, CEM_FFA_INT);
	SetPlayerVirtualWorld(playerid, 1500);
	for(new i=0; i<4; i++)
	{
	    GivePlayerWeapon(playerid, CEM_FFA_Weapons[i][0], CEM_FFA_Weapons[i][1]);
	}
	SetPlayerPos(playerid, CEM_FFA_Spawns[CEM_FFA_JoinCount][0],CEM_FFA_Spawns[CEM_FFA_JoinCount][1],CEM_FFA_Spawns[CEM_FFA_JoinCount][2]);
	SetPlayerFacingAngle(playerid, CEM_FFA_Spawns[CEM_FFA_JoinCount][3]);
	CEM_FFA_JoinCount++;
	if(CEM_FFA_JoinCount==CEM_FFA_SpawnCount)
	{
	    CEM_FFA_JoinCount=0;
	}
	SetPlayerHealth(playerid, 99.0);
	SetPlayerArmour(playerid, (CEM_FFA_Armour==true) ? (99.0) : (0.0));
	return 1;
}
stock CEM_FFDM_EventDeath(playerid)
{
	FoCo_Event_Died[playerid]=0;
	if(CEM_FFA_Rejoin!=1)
	{
	    FoCo_Event_Died[playerid]=1;
	}
	SetPVarInt(playerid, "InEvent", 0);
	return 1;
}
stock CEM_FFDM_EventLeave(playerid)
{
	FoCo_Event_Died[playerid]=0;
	if(CEM_FFA_Rejoin!=1)
	{
	    FoCo_Event_Died[playerid]=1;
	}
	SetPVarInt(playerid, "InEvent", 0);
	SpawnPlayer(playerid);
}
stock CEM_FFDM_EventEnd()
{
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent")==1)
	    {
            CEM_FFDM_EventLeave(i);
		}
	}
	CEM_RUNNING=NILVALUE;
	Event_InProgress = -1;
	return 1;
}
/*******************************************************************************
//////////////////End of CUSTOM EVENT MAKER STOCK FUNCTIONS/////////////////////
*******************************************************************************/



/*******************************************************************************
///////////////////////CUSTOM EVENT MAKER COMMANDS//////////////////////////////
*******************************************************************************/
CMD:cem(playerid, params[])
{
    if(IsAdmin(playerid, 1)==1)
	{
		CEM_Event_Type[playerid]=0;
		ShowPlayerDialog(playerid, DIALOG_CEM, CEM_Dialogs[CEM_Event_Type[playerid]][dialog_type], CEM_Dialogs[CEM_Event_Type[playerid]][dialog_head],CEM_Dialogs[CEM_Event_Type[playerid]][dialog_content],CEM_Dialogs[CEM_Event_Type[playerid]][button1],CEM_Dialogs[CEM_Event_Type[playerid]][button2]);
	}
	return 1;
}

CMD:cemjoin(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerStatus")==0);
	{
		if(Event_InProgress!=-1)
		{
		    if(Event_InProgress==0)
		    {
			    if(FoCo_Event_Died[playerid]==0)
				{
					if(GetPVarInt(playerid, "InEvent")==0)
					{
						if(Event_ID==EVENT_CEM)
						{
						    SetPVarInt(playerid, "PlayerStatus", 1);
					    	CEM_CallFunction(1, playerid);
						}
					}
					else
					{
				    	SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You are already in event.");
					}
				}
				else
				{
			  		SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You died in event and is not rejoinable.");
				}
			}
			else
			{
				if(FoCo_Event_Died[playerid]==1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You died in event and is not rejoinable.");
				}
				else if(GetPVarInt(playerid, "InEvent")==1)
				{
				   	SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You are already in event.");
				}
				else
				{
			  		SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Event already started.");
				}
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] No event running.");
		}
	}
	return 1;
}

CMD:cemleave(playerid, params[])
{
	if(Event_InProgress!=-1)
	{
	    if(FoCo_Event_Died[playerid]==0)
	    {
			if(GetPVarInt(playerid, "InEvent")==1)
			{
				if(Event_ID==EVENT_CEM)
				{
		            CEM_CallFunction(4, playerid);
				}
			}
			else
			{
	            SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You are not in any event.!");
			}
		}
		else
		{
  			SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You already died in event.");
		}
	}
	return 1;
}

CMD:cemend(playerid, params[])
{
	if(IsAdmin(playerid, 1)==1)
	{
		if(Event_InProgress!=-1)
		{
			format(CEM_MSG, sizeof(CEM_MSG), "[Event Notice:] %s %s has stopped the custom event.", GetPlayerStatus(playerid), PlayerName(playerid));
			SendClientMessageToAll(COLOR_NOTICE, CEM_MSG);
            Event_InProgress=-1;
			if(Event_ID==EVENT_CEM)
			{
			    CEM_CallFunction(3, playerid);
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] No custom event to end!");
		}
	}
	return 1;
}

/*******************************************************************************
								Team DeathMatch
*******************************************************************************/
CMD:settdmspawna(playerid, params[])
{
	if(IsAdmin(playerid, 1)==1)
	{
	    if(CEM_RUNNING!=TDM)
	    {
			if(CEM_TDM_LSTSpawner!=playerid)
			{
			    CEM_Spawns_Set=-1;
			    format(CEM_MSG, sizeof(CEM_MSG), "[CEM_NOTICE:] SpawnPoint of Team-A Created. Last SpawnSet Created by %s", (CEM_TDM_LSTSpawner==-1)?("Unknown"):(PlayerName(CEM_TDM_LSTSpawner)));
				SendClientMessage(playerid, COLOR_NOTICE, CEM_MSG);
				GetPlayerPos(playerid, CEM_TDM_Spawns[0][0], CEM_TDM_Spawns[0][1], CEM_TDM_Spawns[0][2]);
				CEM_TDM_LSTSpawner=playerid;
			}
			else
			{
				if(CEM_Spawns_Set==-2)
				{
				    CEM_Spawns_Set=1;
				    CEM_TDM_INT=GetPlayerInterior(playerid);
				    GetPlayerPos(playerid, CEM_TDM_Spawns[0][0], CEM_TDM_Spawns[0][1], CEM_TDM_Spawns[0][2]);
				    format(CEM_MSG, sizeof(CEM_MSG), "[CEM_NOTICE:] SpawnPoint of Team-A Created. You can start the event after setting up Skin and Weapons.");
		            SendClientMessage(playerid, COLOR_NOTICE, CEM_MSG);
				}
				else
				{
				    GetPlayerPos(playerid, CEM_TDM_Spawns[0][0], CEM_TDM_Spawns[0][1], CEM_TDM_Spawns[0][2]);
				    format(CEM_MSG, sizeof(CEM_MSG), "[CEM_NOTICE:] SpawnPoint of Team-A Reset. You can start the event after setting up SpawnPoint of Team-B.");
		            SendClientMessage(playerid, COLOR_NOTICE, CEM_MSG);
		            CEM_Spawns_Set=-1;
				}
			}
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You cannot edit it while Custom-TDM event is running.");
	    }
	}
	return 1;
}

CMD:settdmspawnb(playerid, params[])
{
	if(IsAdmin(playerid, 1)==1)
	{
	    if(CEM_RUNNING!=TDM)
	    {
   			if(CEM_TDM_LSTSpawner!=playerid)
			{
			    CEM_Spawns_Set=-2;
				GetPlayerPos(playerid, CEM_TDM_Spawns[1][0], CEM_TDM_Spawns[1][1], CEM_TDM_Spawns[1][2]);
		  		format(CEM_MSG, sizeof(CEM_MSG), "[CEM_NOTICE:] SpawnPoint of Team-B Created. Last SpawnSet Created by %s", (CEM_TDM_LSTSpawner==-1)?("Unknown"):(PlayerName(CEM_TDM_LSTSpawner)));
				SendClientMessage(playerid, COLOR_NOTICE, CEM_MSG);
				CEM_TDM_LSTSpawner=playerid;
			}
			else
			{
				if(CEM_Spawns_Set==-1)
				{
				    CEM_Spawns_Set=1;
				    CEM_TDM_INT=GetPlayerInterior(playerid);
				    GetPlayerPos(playerid, CEM_TDM_Spawns[1][0], CEM_TDM_Spawns[1][1], CEM_TDM_Spawns[1][2]);
		   		    format(CEM_MSG, sizeof(CEM_MSG), "[CEM_NOTICE:] SpawnPoint of Team-B Created. You can start the event after setting up Skin and Weapons.");
		            SendClientMessage(playerid, COLOR_NOTICE, CEM_MSG);
				}
				else
				{
				    GetPlayerPos(playerid, CEM_TDM_Spawns[1][0], CEM_TDM_Spawns[1][1], CEM_TDM_Spawns[1][2]);
		    	    format(CEM_MSG, sizeof(CEM_MSG), "[CEM_NOTICE:] SpawnPoint of Team-B Reset. You can start the event after setting up SpawnPoint of Team-A.");
		            SendClientMessage(playerid, COLOR_NOTICE, CEM_MSG);
		            CEM_Spawns_Set=-2;
				}
			}
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You cannot edit it while Custom-TDM event is running.");
	    }
	}
	return 1;
}
/*******************************************************************************
								Free For All
*******************************************************************************/
CMD:setffaspawn(playerid, params[])
{
	if(IsAdmin(playerid, 1)==1)
	{
	    if(CEM_RUNNING!=FFA_SUMO&&CEM_RUNNING!=FFA_DM)
	    {
			GetPlayerPos(playerid, CEM_FFA_Spawns[CEM_FFA_SpawnCount][0], CEM_FFA_Spawns[CEM_FFA_SpawnCount][1], CEM_FFA_Spawns[CEM_FFA_SpawnCount][2]);
			GetPlayerFacingAngle(playerid,CEM_FFA_Spawns[CEM_FFA_SpawnCount][3]);
			CEM_FFA_SpawnCount++;
			format(CEM_MSG, sizeof(CEM_MSG), "[CEM_NOTICE:] SpawnPoint: %i Created. Use /resetffaspawn to clear it.",CEM_FFA_SpawnCount);
			SendClientMessage(playerid, COLOR_NOTICE, CEM_MSG);
			if(CEM_FFA_SpawnCount==0)
			{
				CEM_FFA_INT=GetPlayerInterior(playerid);
			}
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You cannot edit it while FFA event is running.");
	    }
	}
	return 1;
}

CMD:resetffaspawn(playerid, params[])
{
	if(IsAdmin(playerid, 1)==1)
	{
	    if(CEM_RUNNING!=FFA_SUMO&&CEM_RUNNING!=FFA_DM)
	    {
			CEM_FFA_SpawnCount=0;
			SendClientMessage(playerid, COLOR_NOTICE, "[CEM_NOTICE:] SpawnPoints wiped. use /setffaspawn to re-make it.");
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You cannot edit it while FFA event is running");
	    }
	}
	return 1;
}

/*******************************************************************************
									RACE
*******************************************************************************/

CMD:setracespawn(playerid, params[])
{
	if(IsAdmin(playerid, 1)==1)
	{
	    if(CEM_RUNNING!=RACE)
	    {
		    GetPlayerPos(playerid, CEM_Race_Spawns[CEM_Race_SpawnCount][0], CEM_Race_Spawns[CEM_Race_SpawnCount][1], CEM_Race_Spawns[CEM_Race_SpawnCount][2]);
			GetPlayerFacingAngle(playerid,CEM_Race_Spawns[CEM_Race_SpawnCount][3]);
			CEM_Race_SpawnCount++;
			format(CEM_MSG, sizeof(CEM_MSG), "[CEM_NOTICE:] SpawnPoint: %i Created. Use /resetracespawn to clear it.",CEM_Race_SpawnCount);
			SendClientMessage(playerid, COLOR_NOTICE, CEM_MSG);
			if(CEM_Race_SpawnCount==0)
			{
				CEM_Race_INT=GetPlayerInterior(playerid);
			}
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You cannot edit it while Race event is running.");
	    }
	}
	return 1;
}

CMD:resetracespawn(playerid, params[])
{
	if(IsAdmin(playerid, 1)==1)
	{
	    if(CEM_RUNNING!=RACE)
	    {
            CEM_Race_SpawnCount=0;
			SendClientMessage(playerid, COLOR_NOTICE, "[CEM_NOTICE:] SpawnPoints wiped. use /setracespawn to re-make it.");

	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You cannot edit it while Race event is running");
	    }
	}
	return 1;
}

CMD:setracecp(playerid, params[])
{
	if(IsAdmin(playerid, 1)==1)
	{
	    if(CEM_RUNNING!=RACE)
	    {
			GetPlayerPos(playerid, CEM_Race_CP[CEM_Race_CPCount][0], CEM_Race_CP[CEM_Race_CPCount][1], CEM_Race_CP[CEM_Race_CPCount][2]);
			CEM_Race_CPCount++;
			format(CEM_MSG, sizeof(CEM_MSG), "[CEM_NOTICE:] CheckPoint: %i Created. Use /resetracecp to clear it.",CEM_Race_CPCount);
			SendClientMessage(playerid, COLOR_NOTICE, CEM_MSG);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You cannot edit it while Race event is running.");
	    }
	}
	return 1;
}
CMD:resetracecp(playerid, params[])
{
	if(IsAdmin(playerid, 1)==1)
	{
	    if(CEM_RUNNING!=RACE)
	    {
			CEM_Race_CPCount=0;
		    SendClientMessage(playerid, COLOR_NOTICE, "[CEM_NOTICE:] CheckPoints wiped. use /setracecp to re-make it.");
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You cannot edit it while Race event is running.");
	    }
	}
	return 1;
}
/*******************************************************************************
////////////////////End Of - CUSTOM EVENT MAKER COMMANDS////////////////////////
*******************************************************************************/
