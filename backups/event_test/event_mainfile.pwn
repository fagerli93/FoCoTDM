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
*                                                                                *
*			######## ##     ## ######## ##    ## ########  ######                *
*			##       ##     ## ##       ###   ##    ##    ##    ##               *
*			##       ##     ## ##       ####  ##    ##    ##                     *
*			######   ##     ## ######   ## ## ##    ##     ######                *
*			##        ##   ##  ##       ##  ####    ##          ##               *
*			##         ## ##   ##       ##   ###    ##    ##    ##               *
*			########    ###    ######## ##    ##    ##     ######                *
*                                                                                *
*                                                                                *
*                        (c) Copyright                                           *
*  Owners: Simon Fagerli (pEar) - Lee Percox (Shaney) - Warren Bickley (WazzaJB) *
*         Developers: Marcel, RakGuy, FKu, Chilco, dr_vista, Fletcher            *
*                                                                                *
* Filename: events.pwn                                                           *
* Author: Marcel & dr_vista -> pEar has re-added everything to seperate files etc*
*********************************************************************************/
#include <YSI\y_hooks>
#include "eConnectEvents.pwn"

forward SetEventTeamNames(type);
forward event_OnGameModeInit();
forward event_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
forward event_OnPlayerConnect(playerid);
forward event_OnPlayerDisconnect(playerid, reason);
forward Event_Currently_On();
forward event_OnPlayerSpawn(playerid);
forward event_OnPlayerDeath(playerid, killerid, reason);
forward event_OnPlayerExitVehicle(playerid, vehicleid);
forward event_OnPlayerEnterCheckpoint(playerid);
//forward Event_OneSecond();
forward EventStart(type, playerid);
forward PlayerJoinEvent(playerid);
forward PlayerLeftEvent(playerid);
forward EndEvent();
forward RespawnPlayer(playerid);


/* Event types:

	- FFA
	- TDM
	- Sumo
	- Pursuit
	- Races
*/

/* Events list:

	- FFA:

		- Mad Dogg's Mansion
		- Big Smoke
		- Minigun Wars
		- Brawl
		- Hydra Wars
		- Gun Game

	- TDM:

		- Jefferson Motel
		- Area 51
		- Army vs. Terrorists
		- Navy Seals vs. Terrorists (Ship)
		- Compound Attack
		- Oil Rig Terrorists
		- Team Drug Run
		- Construction

	- Sumo:

	    - Monster Sumo
	    - Banger Sumo
	    - SandKing Sumo
	    - SandKing Sumo (Reloaded)
	    - Destruction Derby

	- Pursuit:

		- Pursuit

	- Races:

		- TBA



*/

/* File Structure

	\events
	|
	|	events.pwn
	|
 	|	\subfiles
 	|   |
	|	|    area51.pwn
	|	|    armyvsterrorists.pwn
	|	|    bigsmoke.pwn
	|	|    brawl.pwn
	|   |    compound.pwn
	|   |    drugrun.pwn
	|   |    hydra.pwn
	|   |    jefftdm.pwn
	|   |    md.pwn
    |   |    minigun.pwn
    |   |    navyvsterrorists.pwn
    |   |    oilrig.pwn
    |   |    pursuit.pwn
    |   |    SUMO.pwn
	|	|	 plane.pwn
	| 	|	 construction.pwn
    |


*/

#define MAX_EVENT_PLAYERS 50
#define EVENTLIST "Mad Dogg's Mansion\nBig Smoke\nMinigun Wars\nBrawl\nHydra Wars\nGun Game\nJefferson Motel TDM\nArea 51 TDM\nArmy vs. Terrorists\nNavy Seals vs. Terrorists\nCompound Attack\nOil Rig Terrorists\nTeam Drug Run\nMonster Sumo\nBanger Sumo\nSandKing Sumo\nSandKing Sumo (Reloaded)\n Destruction Derby\nPursuit\nPlane-Survival\nConstruction-TDM\nHighSpeed Pursuit\nLabyrinth of Doom"

#define MAX_EVENTS 23
#define MAX_EVENT_VEHICLES 30

#define SUMO_EVENT_SLOTS 15
#define AREA51_EVENT_SLOTS 42
#define ARMY_EVENT_SLOTS 18
#define COMPOUND_EVENT_SLOTS 32
#define DRUGRUN_EVENT_SLOTS 58
#define HYDRA_EVENT_SLOTS 11
#define JEFFTDM_EVENT_SLOTS 28
#define MINIGUN_EVENT_SLOTS 16
#define SEALS_EVENT_SLOTS 31
#define OILRIG_EVENT_SLOTS 32
#define PURSUIT_EVENT_SLOTS 26
#define PLANE_EVENT_SLOTS 30
#define CONSTRUCTION_SLOTS 30
#define HIGHSPEED_PURSUIT_EVENT_SLOTS 26
#define LOD_EVENT_SLOTS 50
#define MAX_LOD_PICKUPS 24
#define VIP_EVENT_SLOTS 2



enum events
{
	eventID,
	eventName[30]
};

new const event_IRC_Array[MAX_EVENTS][ events ] = {
 {0, "Mad Doggs Mansion"},
 {1, "Bigsmoke"},
 {2, "Minigun Wars"},
 {3, "Brawl"},
 {4, "Hydra Wars"},
 {5, "Gun Game"},
 {6, "Jefferson TDM"},
 {7, "Area 51 TDM"},
 {8, "Army vs. Terrorists"},
 {9, "Navy Seals Vs. Terrorists"},
 {10, "Compound Attack"},
 {11, "Oil Rig Terrorists"},
 {12, "Team Drug Run"},
 {13, "Monster Sumo"},
 {14, "Banger Sumo"},
 {15, "SandKing Sumo"},
 {16, "SandKing Sumo Reloaded"},
 {17, "Destruction Derby"},
 {18, "Pursuit"},
 {19, "Plane-ram"},
 {20, "Construction-TDM"},
 {21, "High-speed pursuit"},
 {22, "Labyrinth of Doom"}
};
/* Enumerations */

	/* Master event enum */

enum
{
	MADDOGG,            // 0
	BIGSMOKE,           // 1
	MINIGUN,            // 2
	BRAWL,              // 3
	HYDRA,              // 4
	GUNGAME,            // 5
	JEFFTDM,            // 6
	AREA51,             // 7
	ARMYVSTERRORISTS,   // 8
	NAVYVSTERRORISTS,   // 9
	COMPOUND,           // 10
	OILRIG,             // 11
	DRUGRUN,            // 12
	MONSTERSUMO,        // 13
	BANGERSUMO,         // 14
	SANDKSUMO,          // 15
	SANDKSUMORELOADED,  // 16
	DESTRUCTIONDERBY,   // 17
	PURSUIT,            // 18
	PLANE,              // 19
	CONSTRUCTION,       // 20
	HIGHSPEEDPURSUIT,   // 21
	LOD					// 22
};

new const eventSlots[MAX_EVENTS] = {-1, -1, 16, -1, 11, -1, 28, 42, 18, 31, 32, 32, 58, 15, 15, 15, 15, 15, 26, 33, 30, 26, 50}; /* -1 = unlimited slots */



	/* Drug Run */

enum e_DrugRunVehicles
{
	modelID,
	Float:dX,
	Float:dY,
	Float:dZ,
	Float:Rotation
};

/* Variables */

	/* Master event variables */

new
	Event_Players[MAX_PLAYERS],
	Iterator:Event_Vehicles<50>;
	
new
	Position[3];

new
	Event_InProgress = -1;
	
new
	Event_FFA = 0,
	Maze_Killer = -1,
	rotate_pickups_lod = 0,
	event_count = 0,
	Event_Kills[MAX_PLAYERS],
	Event_Died[MAX_PLAYERS],
	AutoJoin[MAX_PLAYERS],
	LOD_Pickups[MAX_LOD_PICKUPS];
	
	
 /* Event_InProgress values:

	- 0 : Event has been started and can be joined
	- 1 : Event has been started but cannot be joined (30 secs after event start)
	- (-1) : No event is running
*/

new
	Event_ID,
	DialogIDOption[MAX_PLAYERS];

new
	Float:BrawlX,
	Float:BrawlY,
	Float:BrawlZ,
	Float:BrawlA,
	BrawlInt,
	BrawlVW;

new
	team_issue;

new
    Event_Delay,
    E_Pursuit_Criminal,
    E_HSPursuit_Criminal;

new
    FoCo_Event_Died[MAX_PLAYERS];
	
new 
	Float:Maze_X,
	Float:Maze_Y,
	Float:Maze_Z,
	Timer_MazeKiller;

new
	FFAArmour,
	FFAWeapons;
	
new increment2;
new mycounter;

//new DrugEventVehicles[128], /unused
new	Event_PlayerVeh[MAX_PLAYERS] = -1;

new
	 Motel_Team = 0,
	 Team1_Motel = 0,
	 Team2_Motel = 0,
	 Team1 = 0,
	 Team2 = 0;

new
    EventDrugDelay[MAX_PLAYERS];

new
	//lastGunGameWeapon[MAX_PLAYERS] = 38,
	GunGameKills[MAX_PLAYERS];

new
    spawnSeconds[MAX_PLAYERS];

new
	lastKillReason[MAX_PLAYERS];


new	winner,
	FoCo_Criminal = -1,
	FoCo_Event_Rejoin;
//new Pursuit_Car;
	
new
	eventVehicles[MAX_EVENT_VEHICLES] = {0},
	caridx;
	
//new reservedSlotsQueue[VIP_EVENT_SLOTS];

	/* Timer Definitions */
	
new Timer:DelayTimer;


/* Event stats */

enum e_PlayerEventStats
{
	joinedevent,
	pteam,
	kills,
	damage
};		

static
		PlayerEventStats[MAX_PLAYERS][e_PlayerEventStats];

enum e_TeamName
{
	team_a[30],
	team_b[30]
};

static
		TeamNames[e_TeamName];
		
/* Callbacks */




public event_OnGameModeInit()
{
	//SetTimer("Event_OneSecond", 1000, true);
	foreach(new i : Player)
	{
	    EventDrugDelay[i] = -1;
	    Event_Players[i] = -1;
	}
	return 1;
}


public event_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_EVENTS)
	{
	    if(!response)
	    {
	        return 1;
	    }

	    DialogIDOption[playerid] = listitem;

	    switch(listitem)
	    {
	        case MADDOGG:
	        {
	            ShowPlayerDialog(playerid, DIALOGID_MDWEAPON, DIALOG_STYLE_INPUT, "Event Options", "Which weapon should be used?", "Confirm", "Close");
	        }

	        case BIGSMOKE:
	        {
	            ShowPlayerDialog(playerid, DIALOGID_MDWEAPON, DIALOG_STYLE_INPUT, "Event Options", "Which weapon should be used?", "Confirm", "Close");
	        }

	        case MINIGUN:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

				EventStart(MINIGUN, playerid);
	        }

	        case BRAWL:
	        {
	            if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

				EventStart(BRAWL, playerid);
	        }

	        case HYDRA:
	        {
	            if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

				EventStart(HYDRA, playerid);
	        }

	        case JEFFTDM:
	        {
            	if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

				EventStart(JEFFTDM, playerid);
	        }

	        case AREA51:
	        {
            	if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

				EventStart(AREA51, playerid);
	        }

	        case ARMYVSTERRORISTS:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

				EventStart(ARMYVSTERRORISTS, playerid);
	        }

	        case NAVYVSTERRORISTS:
	        {
	            if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

				EventStart(NAVYVSTERRORISTS, playerid);
	        }

	        case COMPOUND:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(COMPOUND, playerid);
	        }

	        case OILRIG:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(OILRIG, playerid);
	        }

	        case DRUGRUN:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(DRUGRUN, playerid);
	        }

	        case MONSTERSUMO:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(MONSTERSUMO, playerid);
	        }

	        case BANGERSUMO:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(BANGERSUMO, playerid);
	        }

	        case SANDKSUMO:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(SANDKSUMO, playerid);
	        }

	        case SANDKSUMORELOADED:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(SANDKSUMORELOADED, playerid);
	        }

	        case DESTRUCTIONDERBY:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(DESTRUCTIONDERBY, playerid);
	        }

	        case PURSUIT:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(PURSUIT, playerid);
	        }
	        
	        case HIGHSPEEDPURSUIT:
	        {
	            if(Event_InProgress != -1)
	            {
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
	            }
	            EventStart(HIGHSPEEDPURSUIT, playerid);
	        }
	        
	        case PLANE:
			{
			    if(Event_InProgress != -1)
			    {
			        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
			        return 1;
			    }
			    
			    EventStart(PLANE, playerid);
			}
			
			case CONSTRUCTION:
			{
			    if(Event_InProgress != -1)
			    {
			        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
			        return 1;
			    }
			    
			    EventStart(CONSTRUCTION, playerid);
			}
			
			case LOD:
			{
				if(Event_InProgress != -1)
			    {
			        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
			        return 1;
			    }
			    EventStart(LOD, playerid);
			}
			
			case GUNGAME: SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Gun Game is currently disabled due to performance issues.");
			
	    }
	}

	else if(dialogid == DIALOG_REJOINABLE)
	{
 	    if(response)
	    {
	        FoCo_Event_Rejoin = 1;
			foreach(Player, i)
			{
				FoCo_Event_Died[i] = 0;
			}
	    }

	    else
	    {
			FoCo_Event_Rejoin = 0;

			foreach(Player, i)
			{
				FoCo_Event_Died[i] = 0;
			}
	    }

	    if(Event_InProgress != -1)
	    {
	        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: An event is already in progress.");
	    }

    	EventStart(DialogIDOption[playerid], playerid);
	}

	else if(dialogid == DIALOGID_MDWEAPON)
	{
	    if(!response)
		{
			return 1;
		}

		if(strval(inputtext) > 39 || strval(inputtext) < 1)
		{
			SendClientMessage(playerid, COLOR_WARNING, "Invalid value");
			return 1;
		}

		FFAWeapons = strval(inputtext);


		ShowPlayerDialog(playerid, DIALOG_FFAARMOUR, DIALOG_STYLE_MSGBOX, "Event Armour", "Should players spawn with armour or not?", "Yes", "No");

	}

	else if(dialogid == DIALOG_FFAARMOUR)
	{
		if(response)
		{
		    FFAArmour = 1;
		}

		else
		{
		    FFAArmour = 0;
		}

	    ShowPlayerDialog(playerid, DIALOG_REJOINABLE, DIALOG_STYLE_MSGBOX, "Event Rejoinable", "Should this event be rejoinable after death or not?", "Yes", "No");
	}
	return 1;
}


public event_OnPlayerConnect(playerid)
{
    return 1;
}


public event_OnPlayerDisconnect(playerid, reason)
{
	if(Event_PlayerVeh[playerid] != -1)
	{
		DestroyVehicle(Event_PlayerVeh[playerid]);
		Event_PlayerVeh[playerid] = -1;
	}

	if(Event_ID != -1)
	{
		if(GetPVarInt(playerid, "InEvent") == 1)
		{
			PlayerLeftEvent(playerid);
		}
	}
	return 1;
}



public Event_Currently_On()
{
	new temp = Event_ID;
	return temp;
}


public event_OnPlayerSpawn(playerid)
{
	if(Event_PlayerVeh[playerid] != -1)
	{
		DestroyVehicle(Event_PlayerVeh[playerid]);
		Event_PlayerVeh[playerid] = -1;
	}
	
	if(GetPVarInt(playerid, "JustDied") == 1)
	{
	    if(GetPVarInt(playerid, "Resetskin") == 1)
	    {
	        SetPlayerSkin(playerid, oldskin[playerid]);
	    }
		SetPlayerSkin(playerid, GetDefaultSkin(playerid));
		SetPVarInt(playerid, "JustDied", 0);
	}
	return 1;
}


public event_OnPlayerDeath(playerid, killerid, reason)
{
	
	if(EventDrugDelay[playerid] != -1)
	{
		EventDrugDelay[playerid] = -1;
	}
	new didsomething = 0;
	if(Event_ID != -1)
	{
	    if(GetPVarInt(playerid, "PlayerStatus") == 1)
		{
		    SetPVarInt(playerid, "InEvent", 0);
			SetPVarInt(playerid, "JustDied", 1);
			if(Event_ID == BIGSMOKE || Event_ID == MADDOGG || Event_ID == BRAWL)
			{
			    Event_Died[playerid]++;
       			FoCo_Event_Died[playerid]++;
				if(killerid != INVALID_PLAYER_ID)
				{
    				Event_Kills[killerid]++;
				    /* Checking if position 1, 2 and 3 have not yet been taken by anyone, aka that Position[0]etc == -1 */
				    if(Position[0] == -1 && Position[1] != killerid && Position[2] != killerid)
				    {
						Position[0] = killerid;
				    }
					else if(Position[1] == -1 && Position[0] != killerid && Position[2] != killerid)
					{
					    Position[1] = killerid;
					}
					else if(Position[2] == -1 && Position[0] != killerid && Position[1] != killerid)
					{
					    Position[2] = killerid;
					}
					else
					{
					    /* Checking if they have 1st, 2nd or 3rd already and if they should move up a rank */
					    if(killerid == Position[2])
					    {
					        if(Event_Kills[killerid] > Event_Kills[Position[1]])
					        {
					            new temp = Position[1];
								Position[1] = killerid;
								Position[2] = temp;
					        }
							if(Event_Kills[killerid] > Event_Kills[Position[0]])
							{
							    new temp = Position[0];
							    Position[0] = killerid;
							    Position[1] = temp;
							}
							didsomething = 0;
					    }
						if(killerid == Position[1] && didsomething == 0)
						{
						    if(Event_Kills[killerid] > Event_Kills[Position[0]])
						    {
						        new temp = Position[0];
						        Position[0] = killerid;
						        Position[1] = temp;
						    }
						    didsomething = 1;
						}
						if(killerid == Position[0])
						{
						    didsomething = 1;
						}
						/* All tests to check if player already is 1st, 2nd or 3rd done. Checking if they should get first, second or third below. */
						if(didsomething == 0)
						{
						    if(Position[2] != -1)
						    {
						        if(Event_Kills[killerid] > Event_Kills[Position[2]])
						        {
									Position[2] = killerid;
								}
								if(Position[1] != -1)
								{
									if(Event_Kills[killerid] > Event_Kills[Position[1]])
									{
									    new temp = Position[1];
									    Position[1] = killerid;
									    Position[2] = temp;
									}
									if(Position[0] != -1)
									{
									    if(Event_Kills[killerid] > Event_Kills[Position[0]])
									    {
									        new temp = Position[0];
									        new temp1 = Position[1];
									        Position[0] = killerid;
									        Position[1] = temp;
									        Position[2] = temp1;
									    }
									}
								}
						    }
						}
			 		}
				}
			}
			if((Event_ID == JEFFTDM || Event_ID == AREA51 || Event_ID == ARMYVSTERRORISTS || Event_ID == NAVYVSTERRORISTS || Event_ID == COMPOUND || Event_ID == OILRIG || Event_ID == DRUGRUN || Event_ID == PURSUIT || Event_ID == HIGHSPEEDPURSUIT || Event_ID == PLANE) && killerid != INVALID_PLAYER_ID)
			{
			    if(killerid != INVALID_PLAYER_ID)
			    {
			        if(Event_ID == PURSUIT || Event_ID == HIGHSPEEDPURSUIT)
			        {
			            if(playerid == FoCo_Criminal)
			            {
			                GiveAchievement(killerid, 79);
			            }
			        }
			        new TK1 = GetPVarInt(playerid, "MotelTeamIssued");
				    new TK2 = GetPVarInt(killerid, "MotelTeamIssued");
					if(TK1 == TK2)
					{
						new string[128];
						format(string, sizeof(string), "[Guardian]: %s has team killed %s in an event", PlayerName(killerid), PlayerName(playerid));
						SendAdminMessage(1, string);
					}
			    }
			}
			if(Event_ID == LOD)
			{
				if(killerid != INVALID_PLAYER_ID)
				{
					if(Maze_Killer != killerid)
					{
						new Float:health;
						new string[56];
						GetPlayerHealth(killerid, health);
						format(string, sizeof(string), "[INFO]: Rewarded +10HP for killing %s(%d)", PlayerName(playerid), playerid);
						SendClientMessage(killerid, COLOR_SYNTAX, string);
						if(health+10 >= 100)
						{
							SetPlayerHealth(killerid, 99);
						}
						else{
							SetPlayerHealth(killerid, health+10);
						}
					}
				}
			}
			if(killerid != INVALID_PLAYER_ID)
			{
				PlayerEventStats[killerid][kills]++;
			}
			PlayerLeftEvent(playerid);

/*
			if(Event_ID == GUNGAME)
			{
				if(killerid != INVALID_PLAYER_ID)
				{
					if(GetPVarInt(killerid, "PlayerStatus") == 1 && lastGunGameWeapon[killerid] != reason)
					{
						GunGameKills[killerid]++;
						ResetPlayerWeapons(killerid);
						GivePlayerWeapon(killerid, GunGameWeapons[GunGameKills[killerid]], 500);
						lastGunGameWeapon[killerid] = GunGameWeapons[GunGameKills[killerid]-1];
						new tmpString[128];
						format(tmpString, sizeof(tmpString), "(%d / 16)", GunGameKills[killerid]);
						TextDrawSetString(GunGame_MyKills[killerid], tmpString);

						new varHigh = 0;
						foreach(new i : Player)
						{
							if(GetPVarInt(playerid, "PlayerStatus") == 1)
							{
								if(GunGameKills[killerid] < GunGameKills[i])
								{
									varHigh = 1;
								}
							}
						}

						if(varHigh == 0)
						{
							format(tmpString, sizeof(tmpString), "%s (%d / 16)", PlayerName(killerid), GunGameKills[killerid]);
							foreach(Player, i)
							{
								if(GetPVarInt(playerid, "PlayerStatus") == 1)
								{
									TextDrawSetString(CurrLeaderName[i], tmpString);
								}
							}
						}

						if(GunGameKills[killerid] >= 17)
						{
							format(tmpString, sizeof(tmpString), "[Event Notice]: %s has won the Gun Game.", PlayerName(killerid));
							SendClientMessageToAll(COLOR_NOTICE, tmpString);
							lastEventWon = killerid;
							EndEvent();
						}
					}
				}
			}*/
		}
	}

	return 1;
}

hook OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
	if(GetPVarInt(issuerid, "InEvent") == 1)
	{
		PlayerEventStats[issuerid][damage] += amount;
	}
}


public event_OnPlayerExitVehicle(playerid, vehicleid)
{
    if(vehicleid == Event_PlayerVeh[playerid])
	{
		if(Event_ID == MONSTERSUMO || Event_ID == BANGERSUMO || Event_ID == SANDKSUMO || Event_ID == SANDKSUMORELOADED || Event_ID == DESTRUCTIONDERBY || Event_ID == HYDRA)
		{
			if(GetPVarInt(playerid, "InEvent") == 1)
			{
				SetPVarInt(playerid, "FellOffEvent", 1);
				PlayerLeftEvent(playerid);
				SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: You have been removed from the event for leaving your vehicle.");
			}
		}
	}
		
	return 1;
}


public event_OnPlayerEnterCheckpoint(playerid)
{
    if(Event_ID == DRUGRUN && GetPVarInt(playerid, "PlayerStatus") == 1 && GetPVarInt(playerid, "MotelTeamIssued") != 1)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid, COLOR_WARNING, "Get out of the vehicle!");
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 1421.5542,2773.9951,10.8203, 4.0);
			return 1;
		}

		EventDrugDelay[playerid] = 60;
		SendClientMessage(playerid, COLOR_NOTICE, "Stay alive for sixty seconds to win!");
		/*ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 0, 0, 0, 0, 0);
		ClearAnimations(playerid);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 0, 0, 0, 0, 0);*/

		new string[128];

		format(string, sizeof(string), "%s has entered the checkpoint, kill him within 60 seconds!", PlayerName(playerid));

		SendEventPlayersMessage(string, COLOR_NOTICE);
	}
	return 1;
}

	/* Timers */


/*task Event_OneSecond[1000]()
{
	else if(Event_Delay == 5)
	{	
		switch(Event_ID)
		{	
			case MINIGUN:
			{
				new freeSlots = MINIGUN_EVENT_SLOTS - Event_PlayersCount();
				if(freeSlots > 0)
				{
					for(new i = 0; i < freeSlots; i++)
					{
						minigun_PlayerJoinEvent(reservedSlotsQueue[i]);
					}
				}
			}
		}
	}

	return 1;
}
*/

timer EventDelay[1000]()
{
	Event_Delay--;
	
	if(Event_Delay == 0)
	{		
		
		if(EventPlayersCount() <= 0)
		{
			foreach(Player, i)
			{
				if(GetPVarInt(i, "InEvent") == 1)
				{
					SendClientMessageToAll(COLOR_WARNING, "[Event ERROR]: Event has been ended due to a low amount of players participating.");
				}
			}
			
			EndEvent();
		}
		
		
		else
		{
			Event_InProgress = 1;
		    
			stop DelayTimer;
			/*
			    Event_Bet_NoCanDo will allow for no further bets to be placed for the events.
			*/
			
			switch(Event_ID)
			{
				case MONSTERSUMO:
				{
					//Event_Bet_NoCanDo();
					sumo_OneSecond();
				} 
				case BANGERSUMO:
				{
                    //Event_Bet_NoCanDo();
                    sumo_OneSecond();
				} 
				case SANDKSUMO:
				{
                    //Event_Bet_NoCanDo();
                    sumo_OneSecond();
				} 
				case SANDKSUMORELOADED:
				{
                    //Event_Bet_NoCanDo();
                    sumo_OneSecond();
				} 
				case DESTRUCTIONDERBY:
				{
                    //Event_Bet_NoCanDo();
                    sumo_OneSecond();
				} 
				case HYDRA:
				{
                    //Event_Bet_NoCanDo();
                    hydra_OneSecond();
				} 
				case JEFFTDM:
				{
                    //Event_Bet_NoCanDo();
                    jefftdm_OneSecond();
				} 
				case ARMYVSTERRORISTS:
				{
                    //Event_Bet_NoCanDo();
                    army_OneSecond();
				} 
				case MINIGUN:
				{
                    //Event_Bet_NoCanDo();
                    minigun_OneSecond();
				} 
				case DRUGRUN:
				{
                    //Event_Bet_NoCanDo();
                    drugrun_OneSecond();
				} 
				case PURSUIT:
				{
                    //Event_Bet_NoCanDo();
                    pursuit_OneSecond();
				} 
				case HIGHSPEEDPURSUIT:
				{
                    //Event_Bet_NoCanDo();
                    hspursuit_OneSecond();
				} 
				case AREA51:
				{
                    //Event_Bet_NoCanDo();
                    area51_OneSecond();
				} 
				case NAVYVSTERRORISTS:
				{
                    //Event_Bet_NoCanDo();
                    navy_OneSecond();
				} 
				case OILRIG:
				{
                    //Event_Bet_NoCanDo();
                    oilrig_OneSecond();
				} 
				case COMPOUND:
				{
                    //Event_Bet_NoCanDo();
                    compound_OneSecond();
				} 
				case PLANE:
				{
                    //Event_Bet_NoCanDo();
                    plane_OneSecond();
				} 
				case CONSTRUCTION:
				{
                    //Event_Bet_NoCanDo();
                    construction_OneSecond();
				}
				case LOD:
				{
					//Event_Bet_NoCanDo();
					lod_OneSecond();
				}
			}
		}
	}

	else if(Event_Delay > 0)
	{
			
		new string[8];
		
		switch(Event_Delay)
		{
			case 5: format(string, sizeof(string), "~r~%d", Event_Delay);
			case 4: format(string, sizeof(string), "~r~~h~%d", Event_Delay);
			case 3: format(string, sizeof(string), "~y~%d", Event_Delay);
			case 2: format(string, sizeof(string), "~y~~h~%d", Event_Delay);
			case 1: format(string, sizeof(string), "~g~%d", Event_Delay);
		}
		
		foreach(Player, i)
		{
			if(GetPVarInt(i, "InEvent") == 1)
			{
				GameTextForPlayer(i, string, 1000, 3);
			}
		}
		
		if(Event_Delay == 5)
		{
			if(Event_ID == MONSTERSUMO || Event_ID == BANGERSUMO || Event_ID == SANDKSUMO || Event_ID == SANDKSUMORELOADED || Event_ID == DESTRUCTIONDERBY)
			{
				new
					Float:vehx,
					Float:vehy,
					Float:vehz,
					Float:vang;

				foreach(Player, i)
				{
					if(GetPVarInt(i, "InEvent") == 1)
					{
						GetPlayerPos(i, vehx, vehy, vehz);
						GetPlayerFacingAngle(i, vang);
						SetVehiclePos(Event_PlayerVeh[i], vehx, vehy, vehz);
						SetVehicleZAngle(i, vang);
						PutPlayerInVehicle(i, Event_PlayerVeh[i], 0);
						SetVehicleParamsEx(Event_PlayerVeh[i], false, false, false, true, false, false, false);
						TogglePlayerControllable(i, 0);
					}
				}
			}
		}
		
		foreach(Player, i)
		{
			if(GetPVarInt(i, "InEvent") == 1)
			{
				//SetCameraBehindPlayer(i);
				TogglePlayerControllable(i, 0);
			}
		}
	}
}


public EventStart(type, playerid)
{
	if(Event_InProgress != -1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
	}

    increment = 0;
	
	
	if(type != BIGSMOKE && type != MADDOGG && type != BRAWL)
	{
		Event_Delay = 30;
		DelayTimer = repeat EventDelay();
		Event_FFA = 0;
	}
	
	/*
	for(new i = 0; i < VIP_EVENT_SLOTS; i++)
	{
		reservedSlotsQueue[i] = -1;
	}
	*/
	switch(type)
	{
		case MADDOGG:
		{
            md_EventStart(playerid);
            Position[0] = -1;
            Position[1] = -1;
            Position[2] = -1;
            //Event_Bet_Start(0);
		} 
		case BIGSMOKE:
		{
			bs_EventStart(playerid);
			//Event_Bet_Start(1);
		} 
		case MINIGUN:
		{
            minigun_EventStart(playerid);
            //Event_Bet_Start(2);
		}
		case BRAWL:
		{
            brawl_EventStart(playerid);
            //Event_Bet_Start(3);
		} 
		case HYDRA:
		{
            hydra_EventStart(playerid);
            //Event_Bet_Start(4);
		} 
		case JEFFTDM: 
		{
		    jefftdm_EventStart(playerid);
		    //Event_Bet_Start(6);
		}
		case AREA51: 
  		{
		    area51_EventStart(playerid);
		    //Event_Bet_Start(7);
		}
		case ARMYVSTERRORISTS: 
		{
		    army_EventStart(playerid);
		    //Event_Bet_Start(8);
		}
		case NAVYVSTERRORISTS: 
		{
		    navy_EventStart(playerid);
		    //Event_Bet_Start(9);
		}
		case COMPOUND: 
		{
		    compound_EventStart(playerid);
		    //Event_Bet_Start(10);
		}
		case OILRIG: 
		{
		    oilrig_EventStart(playerid);
		    //Event_Bet_Start(11);
		}
		case DRUGRUN: 
		{
		    drugrun_EventStart(playerid);
		    //Event_Bet_Start(12);
		}
		case MONSTERSUMO: 
		{
		    monster_EventStart(playerid);
		    //Event_Bet_Start(13);
		}
		case BANGERSUMO: 
		{
		    banger_EventStart(playerid);
		    //Event_Bet_Start(14);
		}
		case SANDKSUMO: 
		{
		    sandking_EventStart(playerid);
		    //Event_Bet_Start(15);
		}
		case SANDKSUMORELOADED: 
		{
		    sandkingR_EventStart(playerid);
		    //Event_Bet_Start(16);
		}
		case DESTRUCTIONDERBY: 
		{
            derby_EventStart(playerid);
            //Event_Bet_Start(17);
		}
		case PURSUIT: 
		{
		    pursuit_EventStart(playerid);
		    //Event_Bet_Start(18);
		}
		case HIGHSPEEDPURSUIT: 
		{
		    hspursuit_EventStart(playerid);
		    //Event_Bet_Start(21);
		}
		case PLANE: 
		{
		    plane_EventStart(playerid);
		    //Event_Bet_Start(19);
		}
		case CONSTRUCTION: 
		{
            construction_EventStart(playerid);
            //Event_Bet_Start(20);
		}
		case LOD:
		{
			lod_EventStart(playerid);
		}
 	}
	
	SetEventTeamNames(type);
 	
 	return 1;
}


public PlayerJoinEvent(playerid)
{
	/*if(EventPlayersCount() > 2-CountDonators(3))
	{
	    if(GetPVarInt(playerid, "Donation_Type") < 3)
	    {
			SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: The event is full and you're gay (gold VIP)");
			return 1;
		}
		else
		{
		    SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Using Donator slot!");
		}
	}*/
	
	if(FoCo_Event_Died[playerid] > 0 && FoCo_Event_Rejoin == 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: The event is not rejoinable.");
	 	return 1;
 	}
	
	switch(Event_ID)
	{
	    case MADDOGG: md_PlayerJoinEvent(playerid);
	    case BIGSMOKE: bs_PlayerJoinEvent(playerid);
	    case PLANE: plane_PlayerJoinEvent(playerid);
	    case MINIGUN: 
		{/*
			if(EventPlayersCount() < MINIGUN_EVENT_SLOTS - VIP_EVENT_SLOTS)
			{*/
				minigun_PlayerJoinEvent(playerid);
		/*	}
			
			else
			{
				if(IsVIP(playerid) == 3)
				{
					if(Event_PlayersCount() < MINIGUN_EVENT_SLOTS)
					{
						minigun_PlayerJoinEvent(playerid);
					}
					
					else
					{
						return SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: The event is full");
					}
				}
				
				else
				{
					for(new i = 0; i < VIP_EVENT_SLOTS; i++)
					{
						if(reservedSlotsQueue[i] == -1)
						{
							reservedSlotsQueue[i] = playerid;
							SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Using reserved slot. You will join the event if this slot is free.");
							return 1;
						}
					}
					
					SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Reserved slots queue is full, you can't join the event.");
					return 1;
				}
			}*/
			
		}
	    case BRAWL: brawl_PlayerJoinEvent(playerid);
	    case HYDRA: hydra_PlayerJoinEvent(playerid);
	    case GUNGAME:
	    {

	    }
	    case JEFFTDM: jefftdm_PlayerJoinEvent(playerid);
	    case AREA51: area51_PlayerJoinEvent(playerid);
	    case ARMYVSTERRORISTS: army_PlayerJoinEvent(playerid);
	    case NAVYVSTERRORISTS: navy_PlayerJoinEvent(playerid);
	    case COMPOUND: compound_PlayerJoinEvent(playerid);
	    case OILRIG: oilrig_PlayerJoinEvent(playerid);
	    case DRUGRUN: drugrun_PlayerJoinEvent(playerid);
	    case MONSTERSUMO: monster_PlayerJoinEvent(playerid);
		case BANGERSUMO: banger_PlayerJoinEvent(playerid);
		case SANDKSUMO: sandking_PlayerJoinEvent(playerid);
		case SANDKSUMORELOADED: sandkingR_PlayerJoinEvent(playerid);
		case DESTRUCTIONDERBY: derby_PlayerJoinEvent(playerid);
		case CONSTRUCTION:construction_PlayerJoinEvent(playerid);
		case PURSUIT:		
	    {
	        if(EventPlayersCount() == 26)
			{
	    		return SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: The event is full.");
			}

	        pursuit_PlayerJoinEvent(playerid);
	    }
	    case HIGHSPEEDPURSUIT:
	    {
	        if(EventPlayersCount() == 26)
	        {
	            return SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: The event is full.");
	        }
	        hspursuit_PlayerJoinEvent(playerid);
	    }
		case LOD: 
		{
			if(EventPlayersCount() == 50)
	        {
				return SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: The event is full.");
			}
			lod_PlayerJoinEvent(playerid);
		}
	}
 	
 	if(Event_ID == MADDOGG || Event_ID == BIGSMOKE)
 	{
 	    FoCo_Event_Died[playerid]++;
 	}
	
	SetPVarInt(playerid, "PlayerStatus", 1);
	SetPVarInt(playerid, "InEvent", 1);
	SetCameraBehindPlayer(playerid);
	
	PlayerEventStats[playerid][joinedevent] = 1;
	
	foreach(Player, i)
	{
		if(Event_Players[i] == -1)
		{
			Event_Players[i] = playerid;
			break;
		}
	}
	return 1;
}


public PlayerLeftEvent(playerid)
{
	if(GetPVarInt(playerid, "PlayerStatus") == 0)
	{
		return 1;
	}
	
	SetPlayerArmour(playerid, 0);
	SetPVarInt(playerid, "InEvent", 0);
	SetPVarInt(playerid, "PlayerStatus", 0);
	death[playerid] = 1;

	foreach(Player, i)
	{
		if(Event_Players[i] == playerid)
		{
			Event_Players[i] = -1;
			break;
		}
	}

	
	switch(Event_ID)
	{
	    case MINIGUN: minigun_PlayerLeftEvent(playerid);
	    case HYDRA: hydra_PlayerLeftEvent(playerid);
	    case JEFFTDM: jefftdm_PlayerLeftEvent(playerid);
	    case AREA51: area51_PlayerLeftEvent(playerid);
	    case ARMYVSTERRORISTS: army_PlayerLeftEvent(playerid);
	    case NAVYVSTERRORISTS: navy_PlayerLeftEvent(playerid);
	    case COMPOUND: compound_PlayerLeftEvent(playerid);
	    case OILRIG: oilrig_PlayerLeftEvent(playerid);
	    case DRUGRUN: drugrun_PlayerLeftEvent(playerid);
	    case MONSTERSUMO: sumo_PlayerLeftEvent(playerid);
	    case BANGERSUMO: sumo_PlayerLeftEvent(playerid);
	    case SANDKSUMO: sumo_PlayerLeftEvent(playerid);
	    case SANDKSUMORELOADED: sumo_PlayerLeftEvent(playerid);
		case DESTRUCTIONDERBY: sumo_PlayerLeftEvent(playerid);
		case PURSUIT: pursuit_PlayerLeftEvent(playerid);
		case HIGHSPEEDPURSUIT: hspursuit_PlayerLeftEvent(playerid);
		case PLANE: plane_PlayerLeftEvent(playerid);
		case CONSTRUCTION: construction_PlayerLeftEvent(playerid);
		case LOD: lod_PlayerLeftEvent(playerid);
	}

	return 1;
}


public EndEvent()
{
    Event_InProgress = -1;
	if(Event_ID == HYDRA)
	{
	    stop hydraTime;
		stop HydraFallCheckTimer;
	}
	
	else if(Event_ID == PURSUIT)
	{
		stop PursuitTimer;
		ForcedCriminal = -1;
	}
	else if(Event_ID == HIGHSPEEDPURSUIT)
	{
	    stop HSPursuitTimer;
	    ForcedCriminal = -1;
	}
	
	else if(Event_ID == PLANE)
	{
	    stop PlaneFallCheckTimer;
	}
	
	else if(Event_ID == OILRIG)
	{
		stop OilrigFallCheckTimer;
	}
	
	else if(Event_ID == LOD)
	{
		new i;
		for(i = 0; i < MAX_LOD_PICKUPS; i++)
		{
			DestroyDynamicPickup(LOD_Pickups[i]);
		}
		Maze_Killer = -1;
		KillTimer(Timer_MazeKiller);
	}
	
	else if(Event_ID == MONSTERSUMO || Event_ID == BANGERSUMO || Event_ID == SANDKSUMO || Event_ID == SANDKSUMORELOADED || Event_ID == DESTRUCTIONDERBY)
	{
		stop SumoFallCheckTimer;
	}
	if(Event_ID == BIGSMOKE || Event_ID == MADDOGG)
	{
		foreach(Player, i)
		{
			AutoJoin[i] = -1;
		}
		if(Position[0] != -1)
		{
			GiveAchievement(Position[0], 83);
		}
		if(Position[1] != -1)
		{
			GiveAchievement(Position[1], 84);
		}
		if(Position[2] != -1)
		{
			GiveAchievement(Position[2], 85);
		}
		Position[0] = -1;
		Position[1] = -1;
		Position[2] = -1;
	}
	
	if(DelayTimer) stop DelayTimer;
	

	else if(Event_ID == GUNGAME)
	{
	    foreach(new i : Player)
	    {
	        TextDrawHideForPlayer(i, CurrLeader[i]);
			TextDrawHideForPlayer(i, CurrLeaderName[i]);
			TextDrawHideForPlayer(i, GunGame_MyKills[i]);
			TextDrawHideForPlayer(i, GunGame_Weapon[i]);
			GunGameKills[i] = 0;
	    }
	}

	foreach(new i : Player)
	{
		if(GetPVarInt(i, "InEvent") == 1 && death[i] == 0)
		{
		    if(Event_ID == JEFFTDM || Event_ID == ARMYVSTERRORISTS || Event_ID == DRUGRUN || Event_ID == PURSUIT || Event_ID == HIGHSPEEDPURSUIT || Event_ID == AREA51 || Event_ID == NAVYVSTERRORISTS || Event_ID == OILRIG || Event_ID == COMPOUND || Event_ID == PLANE || CONSTRUCTION || Event_ID == LOD)
		    {
		        SetPVarInt(i, "MotelTeamIssued", 0);
				SetPlayerSkin(i, GetPVarInt(i, "MotelSkin"));
				SetPlayerColor(i, GetPVarInt(i, "MotelColor"));

				if(Event_ID == NAVYVSTERRORISTS)
				{
				    DisablePlayerCheckpoint(i);
				}

				else if(Event_ID == PURSUIT)
				{
					SetPlayerMarkerForPlayer(i, FoCo_Criminal, GetPVarInt(FoCo_Criminal, "MotelColor"));
				}
				else if(Event_ID == CONSTRUCTION)
				{
					SetPVarInt(i, "Team",0);
				}
		    }

		    if(Event_PlayerVeh[i] != -1)
			{
				DestroyVehicle(Event_PlayerVeh[i]);
				Event_PlayerVeh[i] = -1;
			}
			increment = 0;
			Motel_Team = 0;
			TogglePlayerControllable(i, 1);
		}
		
		if(GetPVarInt(i, "InEvent") == 1)
		{	
			if(IsPlayerInAnyVehicle(i))
			{
				RemovePlayerFromVehicle(i);
			}
			event_SpawnPlayer(i);
		}
	}

	if(Event_ID == DRUGRUN || Event_ID == PURSUIT || Event_ID == HIGHSPEEDPURSUIT || Event_ID == NAVYVSTERRORISTS || Event_ID == COMPOUND || Event_ID == ARMYVSTERRORISTS || Event_ID == PLANE)
	{
		for(new i; eventVehicles[i] != 0; i++)
		{
			DestroyVehicle(eventVehicles[i]);
			eventVehicles[i] = 0;
		}
		Iter_Clear(Event_Vehicles);
	}

	if(Event_ID == JEFFTDM || Event_ID == ARMYVSTERRORISTS || Event_ID == DRUGRUN || Event_ID == AREA51 || Event_ID == NAVYVSTERRORISTS || Event_ID == OILRIG || Event_ID == COMPOUND || CONSTRUCTION)
	{
        Team1_Motel = 0;
		Team2_Motel = 0;
		Team1 = 0;
		Team2 = 0;
	}

	FoCo_Criminal = -1;
	Event_ID = -1;

	/*if(EventPlayersCount() > 0)
	{
	    foreach(Player, i)
	    {
				if(Event_Players[i] != -1)
				{
	        event_SpawnPlayer(Event_Players[i]);
	      }
	    }
	 */
	foreach(Player, i)
	{
		Event_Players[i] = -1;
	}
		

	// Bodge Job fix for some errors (existing and new).
	// Fixed a bug here where it sets PVarInt PlayerStatus for everyone . . . People in duels & AFK zone got fucked over. Gee thanks Shaney/Marcel or w/e - pEar
	foreach(Player, i)
	{
	    if(GetPVarInt(i, "PlayerStatus") == 1)
	    {
			SetPVarInt(i, "PlayerStatus", 0);
	    }
	    FoCo_Event_Died[i] = 0;
	    SetPVarInt(i, "InEvent", 0);
	}
	increment = 0;
	
	if(lastEventWon != -1)
	{
		defer EventGift(lastEventWon);
		lastEventWon = -1;
	}
	
	/* Show event stats */
	
	
	/* Reset stats */
	
	foreach(Player, i)
	{
		PlayerEventStats[i][joinedevent] = 0;
		PlayerEventStats[i][kills] = 0;
		PlayerEventStats[i][damage] = 0;
		PlayerEventStats[i][pteam] = -1;
	}
	return 1;
}


timer EventGift[7000](playerid)
{
    new ran = random(200);
    new string[150];
	switch(ran)
	{
		case 0..24: //5k 25% chance
		{
		    if(isVIP(playerid) < 1)
		    {
				GivePlayerMoney(playerid, 5000);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $5000");
		    }
		    else if(isVIP(playerid) == 1)
		    {
				GivePlayerMoney(playerid, 6000);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $6000");
		    }
		    else if(isVIP(playerid) == 2)
		    {
				GivePlayerMoney(playerid, 6500);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $6500");
		    }
		    else if(isVIP(playerid) == 3)
		    {
				GivePlayerMoney(playerid, 6000);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $7500");
		    }
		}
		case 25..35:    //10% chance
		{
			if(isVIP(playerid) < 1)
		    {
				GivePlayerMoney(playerid, 7500);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $7500");
		    }
		    else if(isVIP(playerid) == 1)
		    {
				GivePlayerMoney(playerid, 9000);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $9000");
		    }
		    else if(isVIP(playerid) == 2)
		    {
				GivePlayerMoney(playerid, 9750);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $9750");
		    }
		    else if(isVIP(playerid) == 3)
		    {
				GivePlayerMoney(playerid, 11250);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $11250");
		    }
		}
		case 36..45:    //10% chance
		{
			if(isVIP(playerid) < 1)
		    {
				GivePlayerMoney(playerid, 10000);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $10000");
		    }
		    else if(isVIP(playerid) == 1)
		    {
				GivePlayerMoney(playerid, 12000);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $12000");
		    }
		    else if(isVIP(playerid) == 2)
		    {
				GivePlayerMoney(playerid, 13000);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $13000");
		    }
		    else if(isVIP(playerid) == 3)
		    {
				GivePlayerMoney(playerid, 15000);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $15000");
		    }
		}
		case 46..50:    //5% chance
		{
			if(isVIP(playerid) < 1)
		    {
				GivePlayerMoney(playerid, 20000);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $20000");
		    }
		    else if(isVIP(playerid) == 1)
		    {
				GivePlayerMoney(playerid, 24000);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $24000");
		    }
		    else if(isVIP(playerid) == 2)
		    {
				GivePlayerMoney(playerid, 26000);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $26000");
		    }
		    else if(isVIP(playerid) == 3)
		    {
				GivePlayerMoney(playerid, 30000);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $30000");
		    }
		}
		case 51..70:        //20% chance
		{
			SetPlayerArmour(playerid, 99);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 100 armour");
		}
		case 71..80:        //10% chance
		{
			format(string, sizeof(string), "[NOTICE]: %s has won an event and won the random Minigun.", PlayerName(playerid));
			SendAdminMessage(1,string);
			SendClientMessageToAll(COLOR_WHITE, string);
			SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			if(isVIP(playerid) < 1)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a minigun");
				GivePlayerWeapon(playerid, 38, 150);
			}
			else if(isVIP(playerid) == 1)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a minigun");
				GivePlayerWeapon(playerid, 38, 175);
			}
			else if(isVIP(playerid) == 2)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a minigun");
				GivePlayerWeapon(playerid, 38, 200);
			}
			else if(isVIP(playerid) == 3)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a minigun");
				GivePlayerWeapon(playerid, 38, 225);
			}
		}
		case 81..90:    //10% chance
		{
		    if(isVIP(playerid) < 1)
		    {
				FoCo_Playerstats[playerid][kills] = FoCo_Playerstats[playerid][kills] + 10;
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 10 extra kills");
			}
			else if(isVIP(playerid) == 1)
			{
				FoCo_Playerstats[playerid][kills] = FoCo_Playerstats[playerid][kills] + 11;
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 11 extra kills");
			}
			else if(isVIP(playerid) == 2)
			{
				FoCo_Playerstats[playerid][kills] = FoCo_Playerstats[playerid][kills] + 13;
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 13 extra kills");
			}
			else if(isVIP(playerid) == 3)
			{
				FoCo_Playerstats[playerid][kills] = FoCo_Playerstats[playerid][kills] + 15;
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 15 extra kills");
			}
		}
		case 91..100:       //10% chance
		{
		    if(isVIP(playerid) < 1)
		    {
				FoCo_Playerstats[playerid][deaths] = FoCo_Playerstats[playerid][deaths] - 10;
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 10 less deaths");
			}
			else if(isVIP(playerid) == 1)
		    {
				FoCo_Playerstats[playerid][deaths] = FoCo_Playerstats[playerid][deaths] - 11;
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 11 less deaths");
			}
			else if(isVIP(playerid) == 2)
		    {
				FoCo_Playerstats[playerid][deaths] = FoCo_Playerstats[playerid][deaths] - 13;
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 13 less deaths");
			}
			else if(isVIP(playerid) == 3)
		    {
				FoCo_Playerstats[playerid][deaths] = FoCo_Playerstats[playerid][deaths] - 15;
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 15 less deaths");
			}
			
		}
		case 101..102:      //1% chance
		{
			if(isVIP(playerid) < 1)
		    {
				GivePlayerMoney(playerid, 50000);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $50000");
		    }
		    else if(isVIP(playerid) == 1)
		    {
				GivePlayerMoney(playerid, 60000);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $60000");
		    }
		    else if(isVIP(playerid) == 2)
		    {
				GivePlayerMoney(playerid, 65000);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $65000");
		    }
		    else if(isVIP(playerid) == 3)
		    {
				GivePlayerMoney(playerid, 75000);
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $75000");
		    }
		}
		case 103..113:      //10% chance
		{
			format(string, sizeof(string), "[NOTICE]: %s has won an event and won the random RPG.", PlayerName(playerid));
			SendAdminMessage(1,string);
			SendClientMessageToAll(COLOR_WHITE, string);
			SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			if(isVIP(playerid) < 1)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an RPG");
				GivePlayerWeapon(playerid, 35, 5);
			}
			else if(isVIP(playerid) == 1)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an RPG");
				GivePlayerWeapon(playerid, 35, 6);
			}
			else if(isVIP(playerid) == 2)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an RPG");
				GivePlayerWeapon(playerid, 35, 7);
			}
			else if(isVIP(playerid) == 3)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an RPG");
				GivePlayerWeapon(playerid, 35, 8);
			}
		}
		case 114..120:      //7% chance
		{
			format(string, sizeof(string), "[NOTICE]: %s has won an event and won the random heat-seeking RPG.", PlayerName(playerid));
			SendAdminMessage(1,string);
			SendClientMessageToAll(COLOR_WHITE, string);
			SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			if(isVIP(playerid) < 1)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an RPG");
				GivePlayerWeapon(playerid, 36, 5);
			}
			else if(isVIP(playerid) == 1)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an RPG");
				GivePlayerWeapon(playerid, 36, 6);
			}
			else if(isVIP(playerid) == 2)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an RPG");
				GivePlayerWeapon(playerid, 36, 7);
			}
			else if(isVIP(playerid) == 3)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an RPG");
				GivePlayerWeapon(playerid, 36, 8);
   			}
		}
		case 121..130:      // 10% chance
		{
			format(string, sizeof(string), "[NOTICE]: %s has won an event and won the random flamethrower", PlayerName(playerid));
			SendAdminMessage(1,string);
			SendClientMessageToAll(COLOR_WHITE, string);
			SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
			if(isVIP(playerid) < 1)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an flamethrower");
				GivePlayerWeapon(playerid, 37, 10);
			}
			else if(isVIP(playerid) == 1)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an flamethrower");
				GivePlayerWeapon(playerid, 37, 12);
			}
			else if(isVIP(playerid) == 2)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an flamethrower");
				GivePlayerWeapon(playerid, 37, 14);
			}
			else if(isVIP(playerid) == 3)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an flamethrower");
				GivePlayerWeapon(playerid, 37, 14);
   			}
		}
		case 131..140:      //10% chance
		{
			format(string, sizeof(string), "[NOTICE]: %s has won an event and won the random grenades", PlayerName(playerid));
			SendAdminMessage(1,string);
			SendClientMessageToAll(COLOR_WHITE, string);
			SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat
			if(isVIP(playerid) < 1)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted grenades");
				GivePlayerWeapon(playerid, 16, 5);
			}
			else if(isVIP(playerid) == 1)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted grenades");
				GivePlayerWeapon(playerid, 16, 6);
			}
			else if(isVIP(playerid) == 2)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted grenades");
				GivePlayerWeapon(playerid, 16, 7);
			}
			else if(isVIP(playerid) == 3)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted grenades");
				GivePlayerWeapon(playerid, 16, 8);
   			}
		}
		case 141..150:      //10% chance
		{
			format(string, sizeof(string), "[NOTICE]: %s has won an event and won the random fire extinguisher", PlayerName(playerid));
			SendAdminMessage(1,string);
			SendClientMessageToAll(COLOR_WHITE, string);
			if(isVIP(playerid) < 1)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a fire extinguisher");
				GivePlayerWeapon(playerid, 42, 15);
			}
			else if(isVIP(playerid) == 1)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a fire extinguisher");
				GivePlayerWeapon(playerid, 42, 20);
			}
			else if(isVIP(playerid) == 2)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a fire extinguisher");
				GivePlayerWeapon(playerid, 42, 25);
			}
			else if(isVIP(playerid) == 3)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a fire extinguisher");
				GivePlayerWeapon(playerid, 42, 30);
   			}
		}
		default:
		{
			format(string, sizeof(string), "[Event Notice]: Unfortunately there was no reward for winning this event.");
            SendClientMessage(playerid, COLOR_NOTICE, string);
		}
	}

	return 1;
}

/* Commands */
/*
CMD:event_kills(playerid, params[])
{
	new string[128];
	foreach(Player, i)
	{
		if(i != INVALID_PLAYER_ID)
		{
		    format(string, sizeof(string), "[DEBUG]: %s(%d) has %d kills in the event!", PlayerName(i), i, Event_Kills[i]);
		    SendClientMessage(playerid, COLOR_SYNTAX, string);
		}
	}
	return 1;
}

CMD:event_position(playerid, params[])
{
	new string[128];
	if(Position[0] != -1)
	{
	    format(string, sizeof(string), "1st: %s(%d) with %d kills.", PlayerName(Position[0]), Position[0], Event_Kills[Position[0]]);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "1st: NOONE HAS THIS YET!");
	}
	if(Position[1] != -1)
	{
	    format(string, sizeof(string), "2nd: %s(%d) with %d kills.", PlayerName(Position[1]), Position[1], Event_Kills[Position[1]]);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "2nd: NOONE HAS THIS YET!");
	}
	if(Position[2] != -1)
	{
	    format(string, sizeof(string), "3rd: %s(%d) with %d kills.", PlayerName(Position[2]), Position[2], Event_Kills[Position[2]]);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "3rd: NOONE HAS THIS YET!");
	}
	return 1;
}
*/

CMD:event(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new
			result[50],
			string[128],
			targetid = -1;

		if(sscanf(params, "s[50]R(-1)", result, targetid))
		{
		    format(string, sizeof(string), "[USAGE]: {%06x}/event {%06x}[Start/End/Setbrawlpoint/Add/Forcecriminal]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		    return SendClientMessage(playerid, COLOR_SYNTAX, string);
		}

		if(strcmp(result, "start", true) == 0)
		{
		    if(Event_InProgress == -1)
		    {
				ShowPlayerDialog(playerid, DIALOG_EVENTS, DIALOG_STYLE_LIST, "Events:", EVENTLIST, "Start", "Cancel");
			}

			else
			{
			    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already another event in progress.");
			}
		}

		else if(strcmp(result, "end", true) == 0)
		{
		    if(Event_InProgress != -1)
		    {
				if(FoCo_Criminal != -1) stop PursuitTimer;			
				
		    	EndEvent();
		    	format(string, sizeof(string), "[EVENT]: %s %s has stopped the event!", GetPlayerStatus(playerid), PlayerName(playerid));
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
				SendClientMessageToAll(COLOR_NOTICE, string);
				Event_Bet_CancelEvent();    // Refunds event bets.
		    }

		    else
		    {
		        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is no event to end.");
		    }
		}

		else if(strcmp(result, "Setbrawlpoint", true) == 0)
		{
			GetPlayerPos(playerid, BrawlX, BrawlY, BrawlZ);
			GetPlayerFacingAngle(playerid, BrawlA);
			BrawlInt = GetPlayerInterior(playerid);
			BrawlVW = GetPlayerVirtualWorld(playerid);

			SendClientMessage(playerid, COLOR_ADMIN, "[SUCCESS]: Brawlpoint set to your position.");
		}
		
		else if(strcmp(result, "add", true) == 0)
		{		
			if(targetid == INVALID_PLAYER_ID)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player is not connected");
			}
			
			if(targetid == cellmin)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Multiple matches found. Be more specific.");
			}
			
			if(targetid == -1)
			{
				return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /event add [ID/Name]");				
			}
			
			if(Event_InProgress != -1)
			{
				if(GetPVarInt(targetid, "InEvent") == 1) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The player is already in the event.");				 
				if(IsPlayerInAnyVehicle(targetid))
				{
					RemovePlayerFromVehicle(targetid);
				}
				
				SetPVarInt(targetid, "MotelSkin", GetPlayerSkin(targetid));
				SetPVarInt(targetid, "MotelColor", GetPlayerColor(targetid));
				PlayerJoinEvent(targetid);
				format(string, sizeof(string), "AdmCmd(%d): %s %s has added %s to the event.", ACMD_EVENT, GetPlayerStatus(playerid), PlayerName(playerid),PlayerName(targetid));
				SendAdminMessage(ACMD_EVENT, string);
				format(string, sizeof(string), "[INFO]: %s %s has added you to the event.", GetPlayerStatus(playerid), PlayerName(playerid));
				SendClientMessage(targetid, COLOR_NOTICE, string);
			}
			
			else
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No event has been started yet.");
			}
		}
		else if (strcmp(result, "forcecriminal", true) == 0)
		{
			if(targetid == cellmin)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Multiple matches found. Be more specific.");
			}

			if(targetid == -1)
			{
				return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /event forcecriminal [ID/Name]");
			}
			if(targetid == INVALID_PLAYER_ID)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player is not connected");
			}
			else
			{
                ForcedCriminal = targetid;
                format(string, sizeof(string), "[Guardian]: %s(%d) has been forced to be the criminal for next event by %s", PlayerName(targetid),targetid,PlayerName(playerid));
				SendAdminMessage(1, string);
				AdminLog(string);
			}
		}
	}

	return 1;
}


CMD:autojoin(playerid, params[])    // Made by pEar
{
	if(AutoJoin[playerid] == 0 || AutoJoin[playerid] == -1)
	{
		if(GetPVarInt(playerid, "PlayerStatus") == 2)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are in a duel, leave it first.");
		}
		if(FoCo_Player[playerid][jailed] != 0)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please wait until your admin jail is over.");
		}
		if(GetPlayerState(playerid) == PLAYER_STATE_WASTED || GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		{
			return 1;
		}
		if(Event_InProgress == -1)
		{
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No event has been started yet.");
		}
		if(GetPVarInt(playerid, "PlayerStatus") == 1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are already at the event, please wait until you die before using the command again.");
	 	}
  		if(Event_InProgress == 0)
		{
			if(eventSlots[Event_ID] == -1 || eventSlots[Event_ID] > EventPlayersCount())
			{
				if(IsPlayerInAnyVehicle(playerid))
				{
					RemovePlayerFromVehicle(playerid);
				}
				new ID = Event_Currently_On();
				if(ID == 0 || ID == 1 || ID == 3) // If event ID is maddogs, bigsmoke or brawl.
				{
				    if(FoCo_Event_Rejoin == 1)
				    {
				        SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
						SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
						PlayerJoinEvent(playerid);
		    			AutoJoin[playerid] = 1;
						SendClientMessage(playerid, COLOR_WHITE, "[INFO]: Auto-Join has been enabled!");
				    }
				    else
				    {
				        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The event is not rejoinable, please use /join!");
				    }
                    
				    
				}
				else
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This may only be enabled with maddogs or bigsmoke!");
				}
			}
		}
	}
	else
	{
	    AutoJoin[playerid] = 0;
	    SendClientMessage(playerid, COLOR_WHITE, "[INFO]: Auto-Join has been disabled!");
	}
	return 1;
}

CMD:join(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerStatus") == 2)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are in a duel, leave it first.");
	}

	if(FoCo_Player[playerid][jailed] != 0)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please wait until your admin jail is over.");
	}

	if(GetPlayerState(playerid) == PLAYER_STATE_WASTED || GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
		return 1;
	}

	if(GetPVarInt(playerid, "PlayerStatus") == 1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are already at the event!");
 	}

	if(Event_InProgress == -1)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No event has been started yet.");
	}

	if(Event_InProgress == 1)
	{
        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The event is already in progress");
	}
	if(FoCo_Event_Rejoin == 0)
	{
	    if(Event_Currently_On() == 0 || Event_Currently_On() == 1)
	    {
	        if(Event_Died[playerid] > 0)
	        {
	        	return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The event is not rejoinable!");
	        }
	    }
	}

    if(Event_InProgress == 0)
	{
		if(eventSlots[Event_ID] == -1 || eventSlots[Event_ID] > EventPlayersCount())
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
				RemovePlayerFromVehicle(playerid);
			}
			
			SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
			SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
			PlayerJoinEvent(playerid);
			GiveAchievement(playerid, 77);
		}
		
		else
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The event is full.");
		}
	
	}
	return 1;
}


stock GetVehicleDriver(vid)
{
     foreach(new i : Player)
     {
          if(!IsPlayerConnected(i)) continue;
          if(GetPlayerVehicleID(i) == vid && GetPlayerVehicleSeat(i) == 0) return 1;
          break;
     }
     return 0;
}


CMD:leaveevent(playerid, params[])
{
	if(GetPVarInt(playerid, "InEvent") == 1)
	{
	    new Float:health;
	    GetPlayerHealth(playerid, health);
	   		
		if(Event_InProgress == 0 && Event_FFA == 0)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "You cannot leave the event before it starts.");
		}
		
		if(EventPlayersCount() <= 2 && Event_ID != MADDOGG && Event_ID != BIGSMOKE && Event_ID != BRAWL)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "You cannot leave the event with less than 2 players in the event.");
		}
	    
	    if(health < 75)
	    {
			return SendClientMessage(playerid, COLOR_WARNING, "You cannot leave the event with less than 75HP, use /kill (it will add a death)");
	    }

		else
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
				RemovePlayerFromVehicle(playerid);
			}
			
			if(GetPVarInt(playerid, "MotelTeamIssued") == 1)
			{
				SetPVarInt(playerid, "MotelTeamIssued", 0);
			}

			PlayerLeftEvent(playerid);
			event_SpawnPlayer(playerid);
			if(AutoJoin[playerid] == 1)
			{
			    AutoJoin[playerid] = 0;
				SendClientMessage(playerid, COLOR_WHITE, "[INFO]: Auto-Join has been disabled.");
			}
		}
	}
	
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not at an event, therefore cannot leave.");
	}
	return 1;
}

stock SendEventPlayersMessage(str[], color)
{
	foreach(Player, i)
	{	
		if(GetPVarInt(i, "InEvent") == 1)
		{
			SendClientMessage(i, color, str);
		}
	}

	return 1;
}

stock EventPlayersCount()
{
	new cnt = 0;
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{	
			cnt++;
		}
	}

	return cnt;
}

/* Spawn Player Fix by Y_Less */

stock event_SpawnPlayer(playerid)
{
	new
		vid = GetPlayerVehicleID(playerid);
		
	if (vid)
	{
		new
			Float:x,
			Float:y,
			Float:z;
		// Remove them without the animation.
		GetVehiclePos(vid, x, y, z),
		SetPlayerPos(playerid, x, y, z);
	}
	new Float:HP;
	GetPlayerHealth(playerid, HP);
	if(HP == 0.0)
	{
		return 1;
	}
	else
	{
		return SpawnPlayer(playerid);
	}
}


public RespawnPlayer(playerid)
{
	return event_SpawnPlayer(playerid);
}


public SetEventTeamNames(type)
{
	switch(type)
	{
		case MADDOGG, BIGSMOKE, MINIGUN, BRAWL, HYDRA, GUNGAME, MONSTERSUMO, BANGERSUMO, SANDKSUMO, SANDKSUMORELOADED, DESTRUCTIONDERBY, PLANE, PURSUIT:
		{
			format(TeamNames[team_a], sizeof(TeamNames[team_a]), "DM");
			format(TeamNames[team_b], sizeof(TeamNames[team_b]), "DM");
		}
		
		case JEFFTDM:
		{
			format(TeamNames[team_a], sizeof(TeamNames[team_a]), "SWAT");
			format(TeamNames[team_b], sizeof(TeamNames[team_b]), "Criminals");
		}
		
		case CONSTRUCTION:
		{
			format(TeamNames[team_a], sizeof(TeamNames[team_a]), "Workers");
			format(TeamNames[team_b], sizeof(TeamNames[team_b]), "Engineers");
		}
		
		case AREA51:
		{
			format(TeamNames[team_a], sizeof(TeamNames[team_a]), "US Special Forces" );
			format(TeamNames[team_b], sizeof(TeamNames[team_b]), "Nuclear Scientists" );
		}
		
		case ARMYVSTERRORISTS:
		{
			format(TeamNames[team_a], sizeof(TeamNames[team_a]), "Army" );
			format(TeamNames[team_b], sizeof(TeamNames[team_b]), "Terrorists" );
		}
		
		case NAVYVSTERRORISTS:
		{
			format(TeamNames[team_a], sizeof(TeamNames[team_a]), "Navy Seals" );
			format(TeamNames[team_b], sizeof(TeamNames[team_b]), "Terrorists" );
		}
		
		case COMPOUND:
		{
			format(TeamNames[team_a], sizeof(TeamNames[team_a]), "SWAT" );
			format(TeamNames[team_b], sizeof(TeamNames[team_b]), "Terrorists" );
		}
		
		case OILRIG:
		{
			format(TeamNames[team_a], sizeof(TeamNames[team_a]), "SWAT" );
			format(TeamNames[team_b], sizeof(TeamNames[team_b]), "Terrorists" );
		}	
		
		case DRUGRUN:
		{
			format(TeamNames[team_a], sizeof(TeamNames[team_a]), "SWAT" );
			format(TeamNames[team_b], sizeof(TeamNames[team_b]), "Terrorists" );
		}
	}
}
		