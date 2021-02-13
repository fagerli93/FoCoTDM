
	
	
	
	/* Pursuit */
	
	forward pursuit_EventStart(playerid);
	forward pursuit_PlayerJoinEvent(playerid);
	forward pursuit_PlayerLeftEvent(playerid);
	forward EndPursuit();
	forward pursuit_OneSecond();
	forward Random_Pursuit_Vehicle();
	
	forward hspursuit_EventStart(playerid);
	forward hspursuit_PlayerJoinEvent(playerid);
	forward hspursuit_PlayerLeftEvent(playerid);
	forward EndHSPursuit();
	forward hspursuit_OneSecond();
	forward RandomHS_Pursuit_Vehicle();
	
	/* Sumo */
	
	forward monster_EventStart(playerid);
	forward monster_PlayerJoinEvent(playerid);

	forward banger_EventStart(playerid);
	forward banger_PlayerJoinEvent(playerid);
	
	forward sandking_EventStart(playerid);
	forward sandking_PlayerJoinEvent(playerid);
	
	forward sandkingR_EventStart(playerid);
	forward sandkingR_PlayerJoinEvent(playerid);
	
	forward derby_EventStart(playerid);
    forward derby_PlayerJoinEvent(playerid);
    
   	forward sumo_PlayerLeftEvent(playerid);
   	forward sumo_OneSecond();
   	
   	/* Plane */
   	
   	forward plane_EventStart(playerid);
   	forward plane_PlayerJoinEvent(playerid);
   	forward plane_PlayerLeftEvent(playerid);
   	forward plane_OneSecond();
	
	/* Construction */
	
	forward construction_EventStart(playerid);
	forward construction_PlayerJoinEvent(playerid);
	forward construction_PlayerLeftEvent(playerid);
	forward construction_OneSecond();
	
	/* Labyrinth of Doom */
	
	forward lod_EventStart(playerid);
	forward lod_PlayerJoinEvent(playerid);
	forward lod_PlayerLeftEvent(playerid);
	forward lod_OneSecond();

/* Callbacks */

hook OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	new string[128];
	if(rotate_pickups_lod <= 0)
	{
		rotate_pickups_lod = LOD_EVENT_SLOTS-1;
	}
	if(pickupid >= LOD_Pickups[0] && pickupid <= LOD_Pickups[23])
	{
		if(pickupid ==  LOD_Pickups[0])
		{
			if(GetPVarInt(playerid, "PlayerStatus") == 1)
			{
				new Float:armour;
				GivePlayerWeapon(playerid, 38, 250);
				Maze_Killer = playerid;
				DestroyDynamicPickup(LOD_Pickups[0]);
				SetPlayerColor(playerid, 0xFFFFFF00);
				GetPlayerArmour(playerid, armour);
				if(armour+50 >= 100)
				{
					SetPlayerArmour(playerid, 99);
				}
				else
				{
					SetPlayerArmour(playerid, armour+50);
				}
				SetPlayerSkin(playerid, 149);
				format(string, sizeof(string), "[EVENT]: %s(%d) has found the minigun and is now the maze killer! He is invisible for 30 seconds, avoid at all cost!", PlayerName(playerid), playerid);
				SendClientMessageToAll(COLOR_GREEN, string);
				Timer_MazeKiller = SetTimer("LOD_MazeKillerTimer", 30000, false);	// 30 seconds
			}
		}
		else if(pickupid == LOD_Pickups[1])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[1][0], LOD_Pickups_Wpns[1][1]);
			DestroyDynamicPickup(LOD_Pickups[1]);
			LOD_Pickups[1] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[1][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[2])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[2][0], LOD_Pickups_Wpns[2][1]);
			DestroyDynamicPickup(LOD_Pickups[2]);
			LOD_Pickups[2] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[2][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[3])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[3][0], LOD_Pickups_Wpns[3][1]);
			DestroyDynamicPickup(LOD_Pickups[3]);
			LOD_Pickups[3] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[3][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[4])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[4][0], LOD_Pickups_Wpns[4][1]);
			DestroyDynamicPickup(LOD_Pickups[4]);
			LOD_Pickups[4] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[4][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[5])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[5][0], LOD_Pickups_Wpns[5][1]);
			DestroyDynamicPickup(LOD_Pickups[5]);
			LOD_Pickups[5] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[5][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[6])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[6][0], LOD_Pickups_Wpns[6][1]);
			DestroyDynamicPickup(LOD_Pickups[6]);
			LOD_Pickups[6] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[6][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[7])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[7][0], LOD_Pickups_Wpns[7][1]);
			DestroyDynamicPickup(LOD_Pickups[7]);
			LOD_Pickups[7] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[7][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[8])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[8][0], LOD_Pickups_Wpns[8][1]);
			DestroyDynamicPickup(LOD_Pickups[8]);
			LOD_Pickups[8] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[8][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[9])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[9][0], LOD_Pickups_Wpns[9][1]);
			DestroyDynamicPickup(LOD_Pickups[9]);
			LOD_Pickups[9] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[9][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[10])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[10][0], LOD_Pickups_Wpns[10][1]);
			DestroyDynamicPickup(LOD_Pickups[10]);
			LOD_Pickups[10] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[10][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[11])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[11][0], LOD_Pickups_Wpns[11][1]);
			DestroyDynamicPickup(LOD_Pickups[11]);
			LOD_Pickups[11] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[11][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[12])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[12][0], LOD_Pickups_Wpns[12][1]);
			DestroyDynamicPickup(LOD_Pickups[12]);
			LOD_Pickups[12] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[12][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[13])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[13][0], LOD_Pickups_Wpns[13][1]);
			DestroyDynamicPickup(LOD_Pickups[13]);
			LOD_Pickups[13] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[13][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[14])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[14][0], LOD_Pickups_Wpns[14][1]);
			DestroyDynamicPickup(LOD_Pickups[14]);
			LOD_Pickups[14] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[14][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[15])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[15][0], LOD_Pickups_Wpns[15][1]);
			DestroyDynamicPickup(LOD_Pickups[15]);
			LOD_Pickups[15] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[15][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[16])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[16][0], LOD_Pickups_Wpns[16][1]);
			DestroyDynamicPickup(LOD_Pickups[16]);
			LOD_Pickups[16] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[16][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[17])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[17][0], LOD_Pickups_Wpns[17][1]);
			DestroyDynamicPickup(LOD_Pickups[17]);
			LOD_Pickups[17] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[17][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[18])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[18][0], LOD_Pickups_Wpns[18][1]);
			DestroyDynamicPickup(LOD_Pickups[18]);
			LOD_Pickups[18] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[18][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[19])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[19][0], LOD_Pickups_Wpns[19][1]);
			DestroyDynamicPickup(LOD_Pickups[19]);
			LOD_Pickups[19] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[19][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[20])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[20][0], LOD_Pickups_Wpns[20][1]);
			DestroyDynamicPickup(LOD_Pickups[20]);
			LOD_Pickups[20] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[20][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[21])
		{
			GivePlayerWeapon(playerid, LOD_Pickups_Wpns[21][0], LOD_Pickups_Wpns[21][1]);
			DestroyDynamicPickup(LOD_Pickups[21]);
			LOD_Pickups[21] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[21][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[22])
		{
			new Float:health;
			GetPlayerHealth(playerid, health);
			if(health+20 >= 100)
			{
				SetPlayerHealth(playerid, 99);
			}
			else
			{
				SetPlayerHealth(playerid, health+20);
			}
			DestroyDynamicPickup(LOD_Pickups[22]);
			LOD_Pickups[22] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[22][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
		else if(pickupid == LOD_Pickups[23])
		{
			new Float:armour;
			GetPlayerArmour(playerid, armour);
			if(armour+20 >= 100)
			{
				SetPlayerArmour(playerid, 99);
			}
			else
			{
				SetPlayerArmour(playerid, armour+20);
			}
			SetPlayerArmour(playerid, armour+50);
			DestroyDynamicPickup(LOD_Pickups[23]);
			LOD_Pickups[23] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[23][0]), 19, LODSpawns[rotate_pickups_lod][0], LODSpawns[rotate_pickups_lod][1], LODSpawns[rotate_pickups_lod][2], 1400, 15, -1, 100);
			rotate_pickups_lod--;
		}
	}
	
	return 1;
}

forward event_OnGameModeInit();
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

forward event_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
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

forward event_OnPlayerConnect(playerid);
public event_OnPlayerConnect(playerid)
{
    return 1;
}

forward event_OnPlayerDisconnect(playerid, reason);
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


forward Event_Currently_On();
public Event_Currently_On()
{
	new temp = Event_ID;
	return temp;
}

forward event_OnPlayerSpawn(playerid);
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

forward event_OnPlayerDeath(playerid, killerid, reason);
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

forward event_OnPlayerExitVehicle(playerid, vehicleid);
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

forward event_OnPlayerEnterCheckpoint(playerid);
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

//forward Event_OneSecond();
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

timer DrugDelay[1000]()
{
	foreach(Player, i)
	{
		if(EventDrugDelay[i] > -1)
		{
			if(EventDrugDelay[i] == 0)
			{
				SetPVarInt(i, "MotelTeamIssued", 0);
				EndEvent();
				increment = 0;
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: Criminals succesfully dropped off the drugs!");
				EventDrugDelay[i] = -1;
				stop DrugDelayTimer;
				return 1;
			}

			EventDrugDelay[i]--;
		}
	}
	return 1;
}

timer PlaneFallCheck[1000]()
{
	foreach(Player, i)
	{
	    if(GetPVarInt(i, "InEvent") == 1 && GetPVarInt(i,"MotelTeamIssued") == 2)
	    {
	        if (!IsPlayerInAnyVehicle(i))
	        {
		        if(!IsPlayerInRangeOfPoint(i,100.0,1925.0658,-2493.0122,13.5391))
		        {
		            SetPlayerPos(i,1925.0658,-2493.0122,13.5391);
		        }
	        }
		}
	    else if(GetPVarInt(i, "InEvent") == 1 && GetPVarInt(i, "MotelTeamIssued") == 1)
	    {
	    	new Float:vx, Float:vy, Float:vz;
	        GetPlayerPos(i, vx,vy,vz);
		    if(IsPlayerInAnyVehicle(i))
		    {
		        SetPlayerPos(i, vx,vy,vz+10);
		        SendClientMessage(i, COLOR_WARNING, "You are not allowed to get in any vehicles!");
		    }
		    else if(vz < 67.2072)
		    {
				SetPlayerHealth(i,0);
				PlayerLeftEvent(i);
		    }
	    }
	}
}

timer SumoFallCheck[1000]()
{
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			new Float:vx, Float:vy, Float:vz;
			GetVehiclePos(Event_PlayerVeh[i], vx, vy, vz);
			if(vz < 8.0 || GetPlayerState(i) != PLAYER_STATE_DRIVER)
			{
			    SetPlayerHealth(i, 0);
				PlayerLeftEvent(i);	
			}
		}
	}
}

timer HydraFallCheck[1000]()
{
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			if(GetPlayerState(i) != PLAYER_STATE_DRIVER)
			{
			    SetPlayerHealth(i, 0);
				PlayerLeftEvent(i);
			}
		}
	}
}

timer OilrigFallCheck[1000]()
{
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			new Float:vx, Float:vy, Float:vz;
			GetPlayerPos(i, vx, vy, vz);
			if(vz < 5.0)
			{
				SetPVarInt(i, "FellOffEvent", 1);
				SetPlayerHealth(i, 0);
				PlayerLeftEvent(i);
			}
		}
	}
}

timer HydraEnd[480000]()
{
	EndEvent();
}

timer EndPursuit[300000]()
{
	SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the criminal getting away!");
	GiveAchievement(FoCo_Criminal, 78);
	EndEvent();
	Motel_Team = 0;
}

timer EndHSPursuit[300000]()
{
	SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the criminal getting away!");
	GiveAchievement(FoCo_Criminal, 78);
	EndEvent();
	Motel_Team = 0;
}

/* Functions */

	/* Main functions */
	
forward EventStart(type, playerid);
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

forward PlayerJoinEvent(playerid);
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

forward PlayerLeftEvent(playerid);
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

forward EndEvent();
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

/* Event sub-functions */

/* Labyrinth of Doom */

forward LOD_MazeKillerTimer();
public LOD_MazeKillerTimer()
{
	SetPlayerColor(Maze_Killer, COLOR_RED);
	SendClientMessageToAll(COLOR_GREEN, "[EVENT]: The maze killer is marked in RED, he may have a minigun or he might've ran out of ammo.");
	SendClientMessageToAll(COLOR_GREEN, "[EVENT]: If you kill him, you will become the maze killer!");
	return 1;
}

public lod_EventStart(playerid)
{
	Maze_Killer = -1;
	lod_CreatePickups();
    FoCo_Event_Rejoin = 0;
	event_count = 0;
	rotate_pickups_lod = LOD_EVENT_SLOTS - 1;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	new
	    string[128];

	Event_ID = LOD;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Labyrinth of Doom {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	
	return 1;
}

forward lod_CreatePickups();
public lod_CreatePickups()
{
	new i;
	for(i = 0; i < MAX_LOD_PICKUPS; i++)
	{
		LOD_Pickups[i] = CreateDynamicPickup(Convert_Wpn_To_PickupID(LOD_Pickups_Wpns[i][0]), 19, LODWeapSpawns[i][0], LODWeapSpawns[i][1], LODWeapSpawns[i][2], 1400, 15, -1, 100);
	}
	return 1;
}

public lod_PlayerJoinEvent(playerid)
{
	event_count++;
	SetPlayerHealth(playerid, 50);
	SetPlayerArmour(playerid, 0);
	SetPlayerVirtualWorld(playerid, 1400);
	SetPlayerInterior(playerid, 15);
	ResetPlayerWeapons(playerid);
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ Labyrinth of Doom! ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
	SetPlayerPos(playerid, LODSpawns[increment][0], LODSpawns[increment][1], LODSpawns[increment][2]);
	SetPlayerFacingAngle(playerid, LODSpawns[increment][3]+180.0);

	SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
	SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
	SetPlayerSkin(playerid, 33);
	GivePlayerWeapon(playerid, 1, 1);
	SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: Your goal is to be the last survivor in the maze. Kill at any cost and avoid the maze killer!");
	SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: A minigun is spawned in the middle of the maze. Reach it first and receive a minigun and become the invisible maze killer!");
	SetPlayerColor(playerid, COLOR_BLUE);
	increment++;
	
	return 1;
}

public lod_PlayerLeftEvent(playerid)
{
	new string[128];
	event_count--;
	if(event_count == 1)
	{
		foreach(Player, i)
		{
			if(GetPVarInt(i, "PlayerStatus") == 1)
			{
				winner = i;
				break;
			}	
		}
		format(string, sizeof(string), "[EVENT]: %s(%d) won the Labyrinth of Doom event!", PlayerName(winner), winner);
		SendClientMessageToAll(COLOR_GREEN, string);
		EndEvent();
		return 1;
	}
    if(playerid == Maze_Killer)
	{
		format(string, sizeof(string), "[EVENT]: %s(%d) the maze killer was killed! His minigun is up for grabs! There are %d players left.", PlayerName(Maze_Killer), Maze_Killer, event_count);
		SendClientMessageToAll(COLOR_GREEN, string);
		DestroyDynamicPickup(LOD_Pickups[0]);
		LOD_Pickups[0] = CreateDynamicPickup(Convert_Wpn_To_PickupID(38), 19, Maze_X, Maze_Y, Maze_Z, 1400, 15, -1, 100);
		Maze_Killer = -1;
		KillTimer(Timer_MazeKiller);
	}
	else
	{
		format(string, sizeof(string), "[EVENT]: %s(%d) died, there are %d players alive.", PlayerName(playerid), playerid, event_count);
		SendClientMessageToAll(COLOR_GREEN, string);
	}
	return 1;
}

public lod_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Labyrinth of Doom is now in progress and can not be joined. The minigun has spawned in the middle of the maze!");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
	return 1;
}

/* Area 51 */

public area51_EventStart(playerid)
{
   	new
	    string[256];

	FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	Event_ID = AREA51;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}United Special Forces vs. Nuclear Scientists Team DM {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	
	return 1;
}


public area51_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);

	if(Motel_Team == 0)
	{

		SetPVarInt(playerid, "MotelTeamIssued", 1);
		PlayerEventStats[playerid][pteam] = 1;
		////SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 287);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, area51SpawnsAF[increment][0], area51SpawnsAF[increment][1], area51SpawnsAF[increment][2]);
		SetPlayerFacingAngle(playerid, area51SpawnsAF[increment][3]);
		Motel_Team = 1;
		increment++;
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		PlayerEventStats[playerid][pteam] = 2;
		////SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 70);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, area51SpawnsCrim[increment-1][0], area51SpawnsCrim[increment-1][1], area51SpawnsCrim[increment-1][2]);
		SetPlayerFacingAngle(playerid, area51SpawnsCrim[increment-1][3]);
		Motel_Team = 0;
	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 25, 500);
	GivePlayerWeapon(playerid, 31, 500);
	GameTextForPlayer(playerid, "~R~~n~~n~ Area 51 ~h~ TDM!~n~~n~ ~w~You are now in the queue", 4000, 3);
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}


public area51_PlayerLeftEvent(playerid)
{
	new
	    t1,
	    t2;
	new
	    msg[128];

    if(GetPlayerSkin(playerid) == 70)
	{
		Team1_Motel++;
	}

	else if(GetPlayerSkin(playerid) == 287)
	{
		Team2_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: US Special Forces %d - %d Nuclear Scientists", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);

	SetPVarInt(playerid, "MotelTeamIssued", 0);

	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				t1++;
			}
			else if(GetPVarInt(i, "MotelTeamIssued") == 2)
			{
				t2++;
			}
		}
	}

	if(t1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Nuclear Scientists have won the event!");
		Event_Bet_End(1);
		return 1;
	}
	else if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The US Special Forces have won the event!");
		Event_Bet_End(0);
		return 1;
	}
	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}
	return 1;
}


public area51_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Area 51 DM is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
	return 1;
}

/* Army vs. Terrorists */

public army_EventStart(playerid)
{
   	new
	    string[256];

	FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	Event_ID = ARMYVSTERRORISTS;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Army vs. Terrorists Team DM {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
		
	for(new i; i < 3; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			new eCarID = CreateVehicle(NavyTerroristVehicles[i][modelID], NavyTerroristVehicles[i][dX], NavyTerroristVehicles[i][dY], NavyTerroristVehicles[i][dZ], NavyTerroristVehicles[i][Rotation], -1, -1, 600000);
			SetVehicleVirtualWorld(eCarID, 1500);
			eventVehicles[i] = eCarID;
			Iter_Add(Event_Vehicles, eCarID);
		}

		else
		{
			break;
		}
	}

	return 1;
}


public army_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);
	if(Motel_Team == 0)
	{
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		PlayerEventStats[playerid][pteam] = 1;
		////SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 287);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, armySpawnsType1[increment][0], armySpawnsType1[increment][1], armySpawnsType1[increment][2]);
		SetPlayerFacingAngle(playerid, armySpawnsType1[increment][3]);
		Motel_Team = 1;
		increment++;
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		PlayerEventStats[playerid][pteam] = 2;
		////SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 73);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, armySpawnsType2[increment-1][0], armySpawnsType2[increment-1][1], armySpawnsType2[increment-1][2]);
		SetPlayerFacingAngle(playerid, armySpawnsType2[increment-1][3]);
		Motel_Team = 0;
	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 31, 750);
	GivePlayerWeapon(playerid, 34, 50);
	GameTextForPlayer(playerid, "~R~~n~~n~ Army vs. Terrorists ~h~ TDM!~n~~n~ ~w~You are now in the queue", 4000, 3);
	new string[32];
    if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
  		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}


public army_PlayerLeftEvent(playerid)
{
    new
		t1,
		t2,
		msg[128];

	if(GetPlayerSkin(playerid) == 287)
	{
		Team2_Motel++;
	}
	else if(GetPlayerSkin(playerid) == 73)
	{
		Team1_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: Army %d - %d Terrorists", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);

	SetPVarInt(playerid, "MotelTeamIssued", 0);


	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				t1++;
			}
			else if(GetPVarInt(i, "MotelTeamIssued") == 2)
			{
				t2++;
			}
		}
	}

	if(t1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Terrorists have won the event!");
		Event_Bet_End(1);
		return 1;
	}

	else if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Army have won the event!");
		Event_Bet_End(0);
		return 1;
	}

	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}

	return 1;
}


public army_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Army vs. Terrorists DM is now in progress and can not be joined");
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
}

/* Big Smoke */

public bs_EventStart(playerid)
{
    new
	    string[256];

    Event_ID = BIGSMOKE;
    if(FoCo_Event_Rejoin == 1)
    {
        format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Bigsmoke {%06x}event.  ", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
        SendClientMessageToAll(COLOR_CMDNOTICE, string);
        format(string, sizeof(string), "[EVENT]: Type /(auto)join! - This event is rejoinable. Price: %d",FFA_COST);
        SendClientMessageToAll(COLOR_CMDNOTICE, string);
    }
    if(FoCo_Event_Rejoin == 0)
    {
        format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Bigsmoke {%06x}event.  ", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
        SendClientMessageToAll(COLOR_CMDNOTICE, string);
        format(string, sizeof(string), "[EVENT]: Type /(auto)join! - This event is NOT rejoinable. Price: %d",FFA_COST);
        SendClientMessageToAll(COLOR_CMDNOTICE, string);
    }
	foreach(Player, i)
	{
	    if(i != INVALID_PLAYER_ID)
	    {
	        Event_Died[i] = 0;
	    }
	}
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_FFA = 1;
	return 1;
}


public bs_PlayerJoinEvent(playerid)
{
	if(FFAArmour == 1)
    {
		SetPlayerArmour(playerid, 99);
	}

	else
	{
	    SetPlayerArmour(playerid, 0);
	}

    if(FoCo_Event_Died[playerid] == 0)
	{
 		Event_Kills[playerid] = 0;
	}
	new randomnum = random(20);
	SetPlayerHealth(playerid, 99);
	SetPlayerInterior(playerid, 2);
	SetPlayerPos(playerid, BigSmokeSpawns[randomnum][0], BigSmokeSpawns[randomnum][1], BigSmokeSpawns[randomnum][2]);
	SetPlayerVirtualWorld(playerid, 1500);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, FFAWeapons, 500);
	GameTextForPlayer(playerid, "~R~~n~~n~ Big ~h~ Smoke!", 800, 3);
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -FFA_COST);
	        format(string, sizeof(string), "~r~-%d",FFA_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
 		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level..");
	}
	return 1;
}

/* Brawl */

public brawl_EventStart(playerid)
{
    if(BrawlX == 0.0)
	{
		GetPlayerPos(playerid, BrawlX, BrawlY, BrawlZ);
		GetPlayerFacingAngle(playerid, BrawlA);
		BrawlInt = GetPlayerInterior(playerid);
		BrawlVW = GetPlayerVirtualWorld(playerid);
		SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: Since you're a dick and forgot to set brawl location, it has been set to your current position.");
	}
    FoCo_Event_Rejoin = 1;
   	new
	    string[256];

	Event_ID = BRAWL;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Brawl event. {%06x}Type /(auto)join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, FFA_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_FFA = 1;
	return 1;
}

public brawl_PlayerJoinEvent(playerid)
{
	
	GiveAchievement(playerid, 24);
	SetPVarInt(playerid,"PlayerStatus",1);
	SetPlayerPos(playerid, BrawlX, BrawlY, BrawlZ);
	SetPlayerFacingAngle(playerid, BrawlA);
	SetPlayerInterior(playerid, BrawlInt);
	SetPlayerHealth(playerid, 99);
	SetPlayerArmour(playerid, 0);
	SetPlayerVirtualWorld(playerid, BrawlVW);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ The ~h~ Brawl!", 800, 3);
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -FFA_COST);
	        format(string, sizeof(string), "~r~-%d",FFA_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
  		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}

/* Compound */

public compound_EventStart(playerid)
{
	FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

   	new
	    string[256];

	Event_ID = COMPOUND;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Compound Attack {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	
	for(new i; i < 9; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			new eCarID = CreateVehicle(compoundVehicles[i][modelID], compoundVehicles[i][dX], compoundVehicles[i][dY], compoundVehicles[i][dZ], compoundVehicles[i][Rotation], -1, -1, 600000);
			SetVehicleVirtualWorld(eCarID, 1500);
			eventVehicles[i] = eCarID;
			Iter_Add(Event_Vehicles, eCarID);
		}

		else
		{
			break;
		}
	}
	if(FoCo_Player[playerid][level] >= 3)
	{
	    if(GetPlayerMoney(playerid) > 5000)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	}
	return 1;
}


public compound_PlayerJoinEvent(playerid)
{
    SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);

	if(Motel_Team == 0)
	{
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		PlayerEventStats[playerid][pteam] = 1;
		////SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 287);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, swatcompoundattack[increment][0], swatcompoundattack[increment][1], swatcompoundattack[increment][2]);
		SetPlayerFacingAngle(playerid, swatcompoundattack[increment][3]);
		Motel_Team = 1;
		increment++;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the Compound.");
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		PlayerEventStats[playerid][pteam] = 2;
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 221);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, terroristcoumpoundattack[increment-1][0], terroristcoumpoundattack[increment-1][1], terroristcoumpoundattack[increment-1][2]);
		SetPlayerFacingAngle(playerid, terroristcoumpoundattack[increment-1][3]);
		Motel_Team = 0;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the Compound ...");
	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 33, 30);
	GivePlayerWeapon(playerid, 31, 500);
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ Compound Attack ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
  		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}


public compound_PlayerLeftEvent(playerid)
{
    new
		t1,
		t2,
		msg[128];

	if(GetPlayerSkin(playerid) == 221)
	{
		Team1_Motel++;
	}
	else if(GetPlayerSkin(playerid) == 287)
	{
		Team2_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: SWAT %d - %d Terrorists", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);

	SetPVarInt(playerid, "MotelTeamIssued", 0);

	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				t1++;
			}
			else if(GetPVarInt(i, "MotelTeamIssued") == 2)
			{
				t2++;
			}
		}
	}

	if(t1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Terrorists have won the event!");
		Event_Bet_End(1);
		return 1;
	}

	else if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: SWAT have won the event!");
		Event_Bet_End(0);
		return 1;
	}

	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}
	return 1;
}


public compound_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Compound Attack is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				SetPlayerCheckpoint(i, -2126.5669,-84.7937,35.3203,2.3031);
			}
		}
	}
}

/* Drug Run */

public drugrun_EventStart(playerid)
{
    FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
		EventDrugDelay[i] = -1;
	}
	
	DrugDelayTimer = repeat DrugDelay();

   	new
	    string[256];

	Event_ID = DRUGRUN;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Team Drug Run {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;

	Iter_Clear(Event_Vehicles);

	for(new i; i < 16; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			new eCarID = CreateVehicle(DrugRunVehicles[i][modelID], DrugRunVehicles[i][dX], DrugRunVehicles[i][dY], DrugRunVehicles[i][dZ], DrugRunVehicles[i][Rotation], 1, 1, 600000);
			SetVehicleVirtualWorld(eCarID, 1500);
			eventVehicles[i] = eCarID;
			Iter_Add(Event_Vehicles, eCarID);
		}

		else 
		{
			break; 
		}
	}
	return 1;
}


public drugrun_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);

	if(Motel_Team == 0)
	{
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		PlayerEventStats[playerid][pteam] = 1;
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 285);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, drugSpawnsType1[increment][0], drugSpawnsType1[increment][1], drugSpawnsType1[increment][2]);
		SetPlayerFacingAngle(playerid, drugSpawnsType1[increment][3]);
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the checkpoint, don't let a drug runner enter ...");
		SendClientMessage(playerid, COLOR_GREEN, ".. it else they will win, you will win by eliminating there team..");
		Motel_Team = 1;
		increment++;
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		PlayerEventStats[playerid][pteam] = 2;
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 21);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, drugSpawnsType2[increment-1][0], drugSpawnsType2[increment-1][1], drugSpawnsType2[increment-1][2]);
		SetPlayerFacingAngle(playerid, drugSpawnsType2[increment-1][3]);
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the checkpoint, don't let the SWAT team ...");
		SendClientMessage(playerid, COLOR_GREEN, ".. kill you else you will lose. Your team MUST drop off the package..");
		Motel_Team = 0;
	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 31, 500);
	GameTextForPlayer(playerid, "~R~~n~~n~ Team Drug ~h~ Run!~n~~n~ ~w~You are now in the queue", 4000, 3);
    new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
    else
    {
    	SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}


public drugrun_PlayerLeftEvent(playerid)
{
   	new
	   t1,
	   t2,
	   msg[128];

    if(GetPlayerSkin(playerid) == 285)
	{
		Team2_Motel++;
	}
	else if(GetPlayerSkin(playerid) == 21)
	{
		Team1_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: SWAT %d - %d Drug Runners", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);
	DisablePlayerCheckpoint(playerid);

	SetPVarInt(playerid, "MotelTeamIssued", 0);

	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				t1++;
			}
			else if(GetPVarInt(i, "MotelTeamIssued") == 2)
			{
				t2++;
			}
		}
	}

	if(t1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: Criminals have won the event!");
        Event_Bet_End(1);
		return 1;
	}
	
	if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: S.W.A.T have won the event!");
		Event_Bet_End(0);
		return 1;
	}

	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}

	return 1;
}


public drugrun_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Team Drug Run is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
			SetPlayerCheckpoint(i, 1421.5542,2773.9951,10.8203, 4.0);
		}
	}
}

/* Hydra */

public hydra_EventStart(playerid)
{
    Event_ID = HYDRA;

	new
   	    string[256];
	
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Hydra wars event. Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	// SendClientMessageToAll(COLOR_CMDNOTICE, "[EVENT]: 30 seconds before it starts, type /join!");
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	HydraFallCheckTimer = repeat HydraFallCheck();
	Event_Delay = 30;
	
	return 1;
}


public hydra_PlayerJoinEvent(playerid)
{
    if(EventPlayersCount() == 12)
	{
		return SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
	}

	SetPlayerVirtualWorld(playerid, 505);
	SetPlayerPos(playerid, hydraSpawnsType1[increment][0], hydraSpawnsType1[increment][1], hydraSpawnsType1[increment][2]);
	Event_PlayerVeh[playerid] = CreateVehicle(520, hydraSpawnsType1[increment][0], hydraSpawnsType1[increment][1], hydraSpawnsType1[increment][2], hydraSpawnsType1[increment][3], -1, -1, 15);
	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	PutPlayerInVehicle(playerid, Event_PlayerVeh[playerid], 0);
	GameTextForPlayer(playerid, "~R~~n~~n~ HYDRA ~n~ WARS", 1500, 3);
	TogglePlayerControllable(playerid, 0);
	increment++;
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
 		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}


public hydra_PlayerLeftEvent(playerid)
{
	SetPVarInt(playerid, "LeftEventJust", 1);
	event_SpawnPlayer(playerid);

	new
	    msg[128];

	if(EventPlayersCount() == 1)
	{
		
		foreach(Player, i)
		{
			if(GetPVarInt(i, "InEvent") == 1)
			{
				winner = i;
				break;
			}
		}
	
		format(msg, sizeof(msg), "				%s has won the Hydra Wars event!", PlayerName(winner));
		SendClientMessageToAll(COLOR_NOTICE, msg);
		GiveAchievement(winner, 82);
		SendClientMessage(winner, COLOR_NOTICE, "You have won the Hydra Wars event! You have earnt 10 score!");
		FoCo_Player[winner][score] = FoCo_Player[winner][score] + 10;
		lastEventWon = winner;
		Event_Bet_End(winner);
		EndEvent();
	}

	return 1;
}


public hydra_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Hydra wars is now in progress and can not be joined");
	hydraTime = defer HydraEnd();
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
		}
	}
}

/* Jeff TDM */

public jefftdm_EventStart(playerid)
{

   	new
	    string[256];

	FoCo_Event_Rejoin = 0;

    foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	Event_ID = JEFFTDM;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Jefferson Motel Team DM {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;

	return 1;
}


public jefftdm_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 15);

	if(Motel_Team == 0)
	{
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		PlayerEventStats[playerid][pteam] = 1;
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 285);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, motelSpawnsType1[increment][0], motelSpawnsType1[increment][1], motelSpawnsType1[increment][2]);
		SetPlayerFacingAngle(playerid, motelSpawnsType1[increment][3]);
		Motel_Team = 1;
		increment++;
	}

	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		PlayerEventStats[playerid][pteam] = 2;
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 50);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, motelSpawnsType2[increment-1][0], motelSpawnsType2[increment-1][1], motelSpawnsType2[increment-1][2]);
		SetPlayerFacingAngle(playerid, motelSpawnsType2[increment-1][3]);
		Motel_Team = 0;
	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 31, 500);
    TogglePlayerControllable(playerid, 0);
	GameTextForPlayer(playerid, "~R~~n~~n~ Motel ~h~ TDM!~n~~n~ ~w~You are now in the queue", 4000, 3);
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
 		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}


public jefftdm_PlayerLeftEvent(playerid)
{
    new
		t1,
		t2,
		msg[128];

	if(GetPlayerSkin(playerid) == 285)
	{
		Team2_Motel++;
	}
	else if(GetPlayerSkin(playerid) == 50)
	{
		Team1_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: S.W.A.T %d - %d Criminals", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);

	SetPVarInt(playerid, "MotelTeamIssued", 0);

	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				t1++;
			}
			else if(GetPVarInt(i, "MotelTeamIssued") == 2)
			{
				t2++;
			}
		}
	}

	if(t1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: Criminals have won the event!");
		Event_Bet_End(1);
		return 1;
	}

	else if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: S.W.A.T have won the event!");
		Event_Bet_End(0);
		return 1;
	}

	/*if(EventPlayersCount() == 1)
	{
		EndEvent();
	}*/
	return 1;
}


public jefftdm_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Jefferson Motel DM is now in progress and can not be joined");
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
}

/* Mad Doggs */

public md_EventStart(playerid)
{
	   	new
		    string[256];

	    Event_ID = MADDOGG;
	    if(FoCo_Event_Rejoin == 1)
	    {
	        format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Mad Dogg's Mansion DM {%06x}event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	        SendClientMessageToAll(COLOR_CMDNOTICE, string);
         	format(string, sizeof(string), "[EVENT]: Type /(auto)join! - This event is rejoinable. Price: %d", FFA_COST);
         	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	    }
	    if(FoCo_Event_Rejoin == 0)
	    {
	        format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Mad Dogg's Mansion DM {%06x}event.",GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	        SendClientMessageToAll(COLOR_CMDNOTICE, string);
         	format(string, sizeof(string), "[EVENT]: Type /join! - This event is NOT rejoinable. Price: %d", FFA_COST);
         	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	    }
		foreach(Player, i)
		{
		    if(i != INVALID_PLAYER_ID)
		    {
		        Event_Died[i] = 0;
		    }
		}
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		Event_InProgress = 0;
		Event_FFA = 1;
		return 1;
}


public md_PlayerJoinEvent(playerid)
{
	if(Event_ID == MADDOGG)
	{
	    if(FFAArmour == 1)
        {
			SetPlayerArmour(playerid, 99);
		}

		else
		{
		    SetPlayerArmour(playerid, 0);
		}

		if(Event_Died[playerid] != 1)
		{
		    Event_Kills[playerid] = 0;
		}
		FoCo_Event_Died[playerid]++;
		SetPlayerHealth(playerid, 99);
		SetPlayerVirtualWorld(playerid, 1500);
		SetPlayerInterior(playerid, 5);
		new randomnum = random(25);
		SetPlayerPos(playerid, MadDogSpawns[randomnum][0], MadDogSpawns[randomnum][1], MadDogSpawns[randomnum][2]);
		SetPlayerFacingAngle(playerid, MadDogSpawns[randomnum][3]);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, FFAWeapons, 500);
		GameTextForPlayer(playerid, "~R~~n~~n~ Mad ~h~ Doggs!", 800, 3);
	}
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -FFA_COST);
	        format(string, sizeof(string), "~r~-%d",FFA_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
 		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}

/* Minigun */

public minigun_EventStart(playerid)
{
   	new
	    string[256];

	Event_ID = MINIGUN;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Minigun Wars {%06x}event. Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	SendClientMessageToAll(COLOR_CMDNOTICE,  "[EVENT]: 30 seconds before it starts, type /join!");
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	
	return 1;
}


public minigun_PlayerJoinEvent(playerid)
{
    if(EventPlayersCount() == 17)
	{
		return SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
	}

	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerPos(playerid, minigunSpawnsType1[increment][0], minigunSpawnsType1[increment][1], minigunSpawnsType1[increment][2]);
	SetPlayerFacingAngle(playerid, minigunSpawnsType1[increment][3]);
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	SetPVarInt(playerid, "sWepExc", 1);		// Special Weapons Exception, for anticheat.
	GivePlayerWeapon(playerid, 38, 3000);
	GameTextForPlayer(playerid, "~R~~n~~n~ MINIGUN ~n~ WARS", 1500, 3);
	TogglePlayerControllable(playerid, 0);
	increment++;
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
 		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}


public minigun_PlayerLeftEvent(playerid)
{
    SetPVarInt(playerid, "LeftEventJust", 1);

	if(EventPlayersCount() == 1)
	{
		new
				msg[128];
	        
		foreach(Player, i)
		{
			if(GetPVarInt(i, "InEvent") == 1)
			{
				winner = i;
				break;
			}
		}
		
		format(msg, sizeof(msg), "				%s has won the Minigun Wars event!", PlayerName(winner));
		SendClientMessageToAll(COLOR_NOTICE, msg);
		GiveAchievement(winner, 80);
		SendClientMessage(winner, COLOR_NOTICE, "You have won the Minigun Wars event! You have earnt 10 score!");
		FoCo_Player[winner][score] += 10;
		lastEventWon = winner;
		Event_Bet_End(winner);
		EndEvent();
	}
	return 1;
}


public minigun_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Minigun wars is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
		}
	}
}

/* Navy vs Terrorists */

public navy_EventStart(playerid)
{
	FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

   	new
	    string[256];
		
	Event_ID = NAVYVSTERRORISTS;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Navy Seals vs. Terrorists {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	
	
	for(new i; i < 12; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			new eCarID = CreateVehicle(navyVehicles[i][modelID], navyVehicles[i][dX], navyVehicles[i][dY], navyVehicles[i][dZ], navyVehicles[i][Rotation], -1, -1, 600000);
			SetVehicleVirtualWorld(eCarID, 1500);
			eventVehicles[i] = eCarID;
			Iter_Add(Event_Vehicles, eCarID);
		}

		else 
		{
			break; 
		}
	}
	
	return 1;
}


public navy_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);

	if(Motel_Team == 0)
	{
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		PlayerEventStats[playerid][pteam] = 1;
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 287);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, navySealsBoat[increment][0], navySealsBoat[increment][1], navySealsBoat[increment][2]);
		SetPlayerFacingAngle(playerid, navySealsBoat[increment][3]);
		Motel_Team = 1;
		increment++;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the boat in the checkpoint and eliminate all terrorist activity.");
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		PlayerEventStats[playerid][pteam] = 2;
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 221);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, terroristsBoat[increment-1][0], terroristsBoat[increment-1][1], terroristsBoat[increment-1][2]);
		SetPlayerFacingAngle(playerid, terroristsBoat[increment-1][3]);
		Motel_Team = 0;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the boat at all costs ...");
	}


	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 29, 750);
	GivePlayerWeapon(playerid, 31, 500);
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ Navy Seals Vs. Terrorists ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
 		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}


public navy_PlayerLeftEvent(playerid)
{
   	new
	   	t1,
		t2,
		msg[128];

    if(GetPlayerSkin(playerid) == 221)
	{
		Team1_Motel++;
	}
	else if(GetPlayerSkin(playerid) == 287)
	{
		Team2_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: Navy Seals %d - %d Terrorists", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);

	SetPVarInt(playerid, "MotelTeamIssued", 0);

	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				t1++;
			}
			else if(GetPVarInt(i, "MotelTeamIssued") == 2)
			{
				t2++;
			}
		}
	}
	if(t1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Terrorists have won the event!");
		Event_Bet_End(1);
		return 1;
	}
	else if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Navy Seals have won the event!");
		Event_Bet_End(0);
		return 1;
	}
	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}
	return 1;
}


public navy_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Navy Seals Vs. Terrorists is now in progress and can not be joined");
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
			DisablePlayerCheckpoint(i);
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				SetPlayerCheckpoint(i, -1446.6353,1502.6423,1.7366, 4.0);
			}
		}
	}
}

/* Oil Rig */

public oilrig_EventStart(playerid)
{
    FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	new
	    string[256];

	Event_ID = OILRIG;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Oil Rig Terrorists {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	OilrigFallCheckTimer = repeat OilrigFallCheck();
	
	return 1;
}


public oilrig_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);

	if(Motel_Team == 0)
	{
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		PlayerEventStats[playerid][pteam] = 1;
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 287);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, swatoilrigspawns1[increment][0], swatoilrigspawns1[increment][1], swatoilrigspawns1[increment][2] + 4);
		SetPlayerFacingAngle(playerid, swatoilrigspawns1[increment][3]);
		Motel_Team = 1;
		increment++;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the Oil Rig.");
	}
	else
	{
 		SetPVarInt(playerid, "MotelTeamIssued", 2);
		PlayerEventStats[playerid][pteam] = 2;
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 221);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, terroristoilrigspawns1[increment-1][0], terroristoilrigspawns1[increment-1][1], terroristoilrigspawns1[increment-1][2]);
		SetPlayerFacingAngle(playerid, terroristoilrigspawns1[increment-1][3]);
		Motel_Team = 0;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the Oil Rig ...");
	}
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 31, 500);
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ Oil Rig Terrorists ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
 		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}


public oilrig_PlayerLeftEvent(playerid)
{
    new
		t1,
		t2,
		msg[128];

	if(GetPlayerSkin(playerid) == 221)
	{
		Team1_Motel++;
	}
	else if(GetPlayerSkin(playerid) == 287)
	{
		Team2_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: SWAT %d - %d Terrorists", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);

	SetPVarInt(playerid, "MotelTeamIssued", 0);

	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				t1++;
			}
			else if(GetPVarInt(i, "MotelTeamIssued") == 2)
			{
				t2++;
			}
		}
	}

	if(t1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Terrorists have won the event!");
		Event_Bet_End(1);
		return 1;
	}

	else if(t2 == 0)
	{
		EndEvent();
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: SWAT have won the event!");
		Event_Bet_End(0);
		increment = 0;
		return 1;
	}

	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}
	return 1;
}


public oilrig_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Oil Rig Terrorists is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
}

new increment2;
new mycounter;
public plane_EventStart(playerid)
{
	increment2 = 0;
	FoCo_Event_Rejoin = 0;
	Team1_Motel = 0;
	Team2_Motel = 0;
	mycounter = 0;
	
	foreach(Player, i)
	{
	    FoCo_Event_Died[i] = 0;
	}
	
	new
	    string[256];

	Event_ID = PLANE;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Plane Survival {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	
	for(new i; i < 33; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			new eCarID = CreateVehicle(PlaneVehicles[i][modelID], PlaneVehicles[i][dX], PlaneVehicles[i][dY], PlaneVehicles[i][dZ], PlaneVehicles[i][Rotation], -1, -1, 600000);
			SetVehicleVirtualWorld(eCarID, 1500);
			eventVehicles[i] = eCarID;
			Iter_Add(Event_Vehicles, eCarID);
		}

		else
		{
			break;
		}
	}
	
    PlaneFallCheckTimer = repeat PlaneFallCheck();
	return 1;
}

public plane_PlayerJoinEvent(playerid)
{
	new string[128];
    if(mycounter == 30)
	{
		return SendClientMessage(playerid, COLOR_NOTICE, "This event is full");
	}
	
    SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);
	
	if(mycounter == 0 || mycounter == 10 || mycounter == 20)
	{
		Team1_Motel++;          // Pilots.
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerSkin(playerid, 61);
		SetPlayerPos(playerid, planeSpawnsType2[increment2][0], planeSpawnsType2[increment2][1], planeSpawnsType2[increment2][2]);
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Ram the hobos off the roof with a plane of your own choosing.");
		increment2++;
	}
    else
	{
	    Team2_Motel++;          // Hobos team
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		SetPlayerSkin(playerid, 137);
		SetPlayerColor(playerid, COLOR_RED);
        SetPlayerPos(playerid, PlaneSpawnType1[increment][0], PlaneSpawnType1[increment][1], PlaneSpawnType1[increment][2]);
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Stay alive!");
		increment++;
 	}
 	ResetPlayerWeapons(playerid);
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ Plane Survival! ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
	mycounter++;
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
 		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
	
}

public plane_PlayerLeftEvent(playerid)
{
	new msg[128];
	
    if(GetPVarInt(playerid, "MotelTeamIssued") == 2)
	{
	    Team2_Motel--;
		format(msg, sizeof(msg), "[EVENT SCORE]: Pilots %d - %d Hobos", Team1_Motel, Team2_Motel);
		SendClientMessageToAll(COLOR_NOTICE, msg);
	}

	if(GetPVarInt(playerid, "MotelTeamIssued") == 1)
	{
		Team1_Motel--;
		format(msg, sizeof(msg), "[EVENT SCORE]: Pilots %d - %d Hobos", Team1_Motel, Team2_Motel);
		SendClientMessageToAll(COLOR_NOTICE, msg);
	}

	if(Team2_Motel == 0)
	{
	    SendClientMessageToAll(COLOR_NOTICE, "[NOTICE]: The event ended due to all hobos falling off the roof.");
	    Event_Bet_End(0);
		EndEvent();
	}
	
	else if(Team1_Motel == 0)
	{
     	SendClientMessageToAll(COLOR_NOTICE, "[NOTICE]: The event ended due to all pilots dying.");
     	Event_Bet_End(1);
		EndEvent();
	}

	SetPVarInt(playerid, "MotelTeamIssued", 0);
	return 1;
}

public plane_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Plane Survival is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
}

public hspursuit_EventStart(playerid)
{
	FoCo_Event_Rejoin = 0;
    team_issue = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}
	
	new string[256];

	Event_ID = HIGHSPEEDPURSUIT;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}High-speed Pursuit {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	
	new car;
	caridx = 0;
	Iter_Clear(Event_Vehicles);
	for(new i = 0; i <= 24; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			if(i == 0)     // If you change this, also change the ones on top!!
			{
				car = CreateVehicle(RandomHS_Pursuit_Vehicle(), HSpursuitVehicles[i][0], HSpursuitVehicles[i][1], HSpursuitVehicles[i][2], HSpursuitVehicles[i][3], -1, -1, 600000);
				SetVehicleVirtualWorld(car, 1500);
				E_HSPursuit_Criminal = car;
				eventVehicles[i] = car;
			}
			else if (i == 10 || i == 24)    // If this is changed, change accordingly on top. Mavericks
 			{
   				car = CreateVehicle(497, HSpursuitVehicles[i][0], HSpursuitVehicles[i][1], HSpursuitVehicles[i][2], HSpursuitVehicles[i][3], 125, 125, 600000);
   				SetVehicleVirtualWorld(car, 1500);
      			eventVehicles[i] = car;
	        	Iter_Add(Event_Vehicles, car);
    		}
    		else if (i % 4 == 0)    // Cheetahs
    		{
    			car = CreateVehicle(415, HSpursuitVehicles[i][0], HSpursuitVehicles[i][1], HSpursuitVehicles[i][2], HSpursuitVehicles[i][3], 125, 125, 600000);
   				SetVehicleVirtualWorld(car, 1500);
      			eventVehicles[i] = car;
	        	Iter_Add(Event_Vehicles, car);
    		}
		    else        // Sultans
		    {
	    		car = CreateVehicle(560, HSpursuitVehicles[i][0], HSpursuitVehicles[i][1], HSpursuitVehicles[i][2], HSpursuitVehicles[i][3], 0, 1, 600000);
				SetVehicleVirtualWorld(car, 1500);
				eventVehicles[i] = car;
				Iter_Add(Event_Vehicles, car);
  			}
		}
		else
		{
			break;
		}
	}
	if (ForcedCriminal != -1)
	{
		PlayerJoinEvent(ForcedCriminal);
	    hspursuit_PlayerJoinEvent(ForcedCriminal);
	}
	return 1;
}

public hspursuit_PlayerJoinEvent(playerid)
{
	new string[128];
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);

	if(ForcedCriminal != -1)
	{
 		if(ForcedCriminal == playerid)
   		{
        	Motel_Team = 1;
			SetPVarInt(playerid, "MotelTeamIssued", 1);
			SetPlayerColor(playerid, COLOR_RED);
			FoCo_Criminal = playerid;
			HSPursuitTimer = defer EndHSPursuit();
			SetPlayerSkin(playerid, 50);
			PutPlayerInVehicle(playerid, E_HSPursuit_Criminal, 0);
			SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Stay alive, evade the PD ...");
			format(string, sizeof(string), "%s was chosen to be the criminal, kill him at all costs!",PlayerName(playerid));
			SendClientMessageToAll(COLOR_GREEN, string);
			SendClientMessage(playerid, COLOR_NOTICE, "You have been chosen by an admin to be the criminal");
			ForcedCriminal = -1;
     	}
	}
	else if(Motel_Team == 0 && ForcedCriminal == -1)
	{
		Motel_Team = 1;
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		SetPlayerColor(playerid, COLOR_RED);
		FoCo_Criminal = playerid;
		HSPursuitTimer = defer EndHSPursuit();
		SetPlayerSkin(playerid, 50);
		PutPlayerInVehicle(playerid, E_HSPursuit_Criminal, 0);
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Stay alive, evade the PD ...");
		format(string, sizeof(string), "%s was chosen to be the criminal, kill him at all costs!",PlayerName(playerid));
		SendClientMessageToAll(COLOR_GREEN, string);
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		SetPlayerSkin(playerid, 280);
		SetPlayerColor(playerid, COLOR_BLUE);
		team_issue++;
		caridx++;
        PutPlayerInVehicle(playerid, eventVehicles[caridx], 0);
        

		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Take out the criminal car at all costs ...");

		if(FoCo_Criminal != INVALID_PLAYER_ID)
		{
			SetPlayerMarkerForPlayer( playerid, FoCo_Criminal, 0xFFFFFF00);
		}
 	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 25, 500);
	GameTextForPlayer(playerid, "~R~~n~~n~ Pursuit ~h~ ~n~~n~ ~w~You are now in the queue", 4000, 3);
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
 		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}


public hspursuit_PlayerLeftEvent(playerid)
{
    if(playerid == FoCo_Criminal)
	{
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the criminal being caught!");
		Event_Bet_End(0);
		EndEvent();
	}

	if(GetPVarInt(playerid, "MotelTeamIssued") == 2)
	{
     	team_issue--;
	}

	if(team_issue == 0)
	{
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the police being killed!");
		Event_Bet_End(1);
		EndEvent();
	}
	SetPVarInt(playerid, "MotelTeamIssued", 0);

	return 1;
}


public hspursuit_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Pursuit is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
}

/* Pursuit */

public pursuit_EventStart(playerid)
{
    FoCo_Event_Rejoin = 0;
    team_issue = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

   	new
	    string[256];

	Event_ID = PURSUIT;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Pursuit {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;


	new car;
	caridx = 0;
	Iter_Clear(Event_Vehicles);
	for(new i = 0; i < 25; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			if(i == 0)     // If you change this, also change the ones on top!!
			{
				car = CreateVehicle(Random_Pursuit_Vehicle(), pursuitVehicles[i][0], pursuitVehicles[i][1], pursuitVehicles[i][2], pursuitVehicles[i][3], -1, -1, 600000);
				SetVehicleVirtualWorld(car, 1500);
				E_Pursuit_Criminal = car;
				eventVehicles[i] = car;
			}
			else if (i == 10 || i == 24)    // If this is changed, change accordingly on top
 			{
   				car = CreateVehicle(497, pursuitVehicles[i][0], pursuitVehicles[i][1], pursuitVehicles[i][2], pursuitVehicles[i][3], 0, 1, 600000);
   				SetVehicleVirtualWorld(car, 1500);
      			eventVehicles[i] = car;
	        	Iter_Add(Event_Vehicles, car);
    		}
		    else
		    {
	    		car = CreateVehicle(596, pursuitVehicles[i][0], pursuitVehicles[i][1], pursuitVehicles[i][2], pursuitVehicles[i][3], 0, 1, 600000);
				SetVehicleVirtualWorld(car, 1500);
				eventVehicles[i] = car;
				Iter_Add(Event_Vehicles, car);
  			}
		}
		else
		{
			break;
		}
	}
	if (ForcedCriminal != -1)
	{
		PlayerJoinEvent(ForcedCriminal);
	    pursuit_PlayerJoinEvent(ForcedCriminal);
	}
	return 1;
}

public pursuit_PlayerJoinEvent(playerid)
{
	new string[128];
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);
	
	if(ForcedCriminal != -1)
	{
 		if(ForcedCriminal == playerid)
   		{
        	Motel_Team = 1;
			SetPVarInt(playerid, "MotelTeamIssued", 1);
			SetPlayerColor(playerid, COLOR_RED);
			FoCo_Criminal = playerid;
			PursuitTimer = defer EndPursuit();
			SetPlayerSkin(playerid, 50);
			PutPlayerInVehicle(playerid, E_Pursuit_Criminal, 0);
			SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Stay alive, evade the PD ...");
			format(string, sizeof(string), "%s was chosen to be the criminal, kill him at all costs!",PlayerName(playerid));
			SendClientMessageToAll(COLOR_GREEN, string);
			SendClientMessage(playerid, COLOR_NOTICE, "You have been chosen by an admin to be the criminal");
			ForcedCriminal = -1;
     	}
	}
	else if(Motel_Team == 0 && ForcedCriminal == -1)
	{
		Motel_Team = 1;
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		SetPlayerColor(playerid, COLOR_RED);
		FoCo_Criminal = playerid;
		PursuitTimer = defer EndPursuit();
		SetPlayerSkin(playerid, 50);
		PutPlayerInVehicle(playerid, E_Pursuit_Criminal, 0);
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Stay alive, evade the PD ...");
		format(string, sizeof(string), "%s was chosen to be the criminal, kill him at all costs!",PlayerName(playerid));
		SendClientMessageToAll(COLOR_GREEN, string);
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
	//	//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
	//	//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 280);
		SetPlayerColor(playerid, COLOR_BLUE);
		team_issue++;
		
		caridx++;
        PutPlayerInVehicle(playerid, eventVehicles[caridx], 0);
        

		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Take out the criminal car at all costs ...");

		if(FoCo_Criminal != INVALID_PLAYER_ID)
		{
			SetPlayerMarkerForPlayer( playerid, FoCo_Criminal, 0xFFFFFF00);
		}
 	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 25, 500);
	GameTextForPlayer(playerid, "~R~~n~~n~ Pursuit ~h~ ~n~~n~ ~w~You are now in the queue", 4000, 3);
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
 		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}


public pursuit_PlayerLeftEvent(playerid)
{
    if(playerid == FoCo_Criminal)
	{
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the criminal being caught!");
		Event_Bet_End(0);
		EndEvent();
	}

	if(GetPVarInt(playerid, "MotelTeamIssued") == 2)
	{
     	team_issue--;
	}
	
	if(team_issue == 0)
	{
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the police being killed!");
		Event_Bet_End(1);
		EndEvent();
	}
	

	SetPVarInt(playerid, "MotelTeamIssued", 0);
	//SetPlayerSkin(playerid, GetPVarInt(playerid, "MotelSkin"));
	//SetPlayerColor(playerid, GetPVarInt(playerid, "MotelColor"));

	return 1;
}


public pursuit_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Pursuit is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
}

public construction_EventStart(playerid)
{
    FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	new
	    string[256];

	Event_ID = CONSTRUCTION;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Construction-TDM {%06x}event. Type /join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, TDM_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	Team1 = 0;
	Team2 = 0;
	
	return 1;
}

public construction_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1400);
	SetPlayerInterior(playerid, 0);
	
	if(Motel_Team == 0)
	{
		Team1++;
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 27);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, constructionspawn1[increment][0], constructionspawn1[increment][1], constructionspawn1[increment][2] + 4);
		SetPlayerFacingAngle(playerid, constructionspawn1[increment][3]);
		Motel_Team = 1;
		increment++;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Kill the engineers!");
	}
	else
	{
		Team2++;
 		SetPVarInt(playerid, "MotelTeamIssued", 2);
		SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 153);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, constructionspawn2[increment-1][0], constructionspawn2[increment-1][1], constructionspawn2[increment-1][2]);
		SetPlayerFacingAngle(playerid, constructionspawn2[increment-1][3]);
		Motel_Team = 0;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Kill the workers!");
	}
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 25, 250);
	GivePlayerWeapon(playerid, 33, 150);
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ Oil Rig Terrorists ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
 		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}

public construction_PlayerLeftEvent(playerid)
{
	new msg[128];

	if(GetPVarInt(playerid, "MotelTeamIssued") == 1)
	{
		Team1--;
		format(msg, sizeof(msg), "[EVENT SCORE]: Workers %d - %d Engineers", Team1, Team2);
		SendClientMessageToAll(COLOR_NOTICE, msg);
	}
	else if(GetPVarInt(playerid, "MotelTeamIssued") == 2)
	{
		Team2--;
		format(msg, sizeof(msg), "[EVENT SCORE]: Workers %d - %d Engineers", Team1, Team2);
		SendClientMessageToAll(COLOR_NOTICE, msg);
	}
	
	
	if(Team1 == 0)
	{
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The engineers have won the event!");
		increment = 0;
		Event_Bet_End(1);
		EndEvent();
	}
	else if(Team2 == 0)
	{
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The workers have won the event!");
		increment = 0;
		Event_Bet_End(0);
		EndEvent();
	}
	
	SetPVarInt(playerid, "MotelTeamIssued", 0);
	
	return 1;
}

public construction_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Construction TDM is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
}

public Random_Pursuit_Vehicle()
{
	new randVeh, vehicle;
	randVeh = random(50);
	switch(randVeh)
	{
		case 0: { vehicle = 402; }
		case 1: { vehicle = 405; }
		case 2: { vehicle = 402; }
		case 3: { vehicle = 426; }
		case 4: { vehicle = 434; }
		case 5: { vehicle = 439; }
		case 6: { vehicle = 402; }
		case 7: { vehicle = 489; }
		case 8: { vehicle = 495; }
		case 9: { vehicle = 412; }
		case 10: { vehicle = 419; }
		case 11: { vehicle = 421; }
		case 12: { vehicle = 422; }
		case 13: { vehicle = 426; }
		case 14: { vehicle = 436; }
		case 15: { vehicle = 445; }
		case 16: { vehicle = 466; }
		case 17: { vehicle = 467; }
		case 18: { vehicle = 470; }
		case 19: { vehicle = 474; }
		case 20: { vehicle = 475; }
		case 21: { vehicle = 477; }
		case 22: { vehicle = 491; }
		case 23: { vehicle = 492; }
		case 24: { vehicle = 500; }
		case 25: { vehicle = 506; }
		case 26: { vehicle = 508; }
		case 27: { vehicle = 516; }
		case 28: { vehicle = 517; }
		case 29: { vehicle = 526; }
		case 30: { vehicle = 527; }
		case 31: { vehicle = 529; }
		case 32: { vehicle = 533; }
		case 33: { vehicle = 534; }
		case 34: { vehicle = 535; }
		case 35: { vehicle = 536; }
		case 36: { vehicle = 537; }
		case 37: { vehicle = 540; }
		case 38: { vehicle = 542; }
		case 39: { vehicle = 549; }
		case 40: { vehicle = 550; }
		case 41: { vehicle = 555; }
		case 42: { vehicle = 566; }
		case 43: { vehicle = 567; }
		case 44: { vehicle = 575; }
		case 45: { vehicle = 576; }
		case 46: { vehicle = 579; }
		case 47: { vehicle = 580; }
		case 48: { vehicle = 587; }
		case 49: { vehicle = 602; }
		case 50: { vehicle = 603; }
	}
	return vehicle;
}

public RandomHS_Pursuit_Vehicle()
{
	new randVeh, vehicle;
	randVeh = random(30);
	switch(randVeh)
	{
		case 0: { vehicle = 402; }
		case 1: { vehicle = 411; }
		case 2: { vehicle = 415; }
		case 3: { vehicle = 424; }
		case 4: { vehicle = 429; }
		case 5: { vehicle = 451; }
		case 6: { vehicle = 461; }
		case 7: { vehicle = 463; }
		case 8: { vehicle = 468; }
		case 9: { vehicle = 471; }
		case 10: { vehicle = 477; }
		case 11: { vehicle = 494; }
		case 12: { vehicle = 495; }
		case 13: { vehicle = 496; }
		case 14: { vehicle = 502; }
		case 15: { vehicle = 503; }
		case 16: { vehicle = 506; }
		case 17: { vehicle = 509; }
		case 18: { vehicle = 541; }
		case 19: { vehicle = 555; }
		case 20: { vehicle = 556; }
		case 21: { vehicle = 559; }
		case 22: { vehicle = 560; }
		case 23: { vehicle = 562; }
		case 24: { vehicle = 565; }
		case 25: { vehicle = 568; }
		case 26: { vehicle = 581; }
		case 27: { vehicle = 587; }
		case 28: { vehicle = 589; }
		case 29: { vehicle = 602; }
		case 30: { vehicle = 603; }
	}
	return vehicle;
}


/* Sumo */

public monster_EventStart(playerid)
{
   	new
	    string[128];

    Event_ID = MONSTERSUMO;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Monster Sumo event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "[EVENT]: 30 seconds before it starts, type /join!", COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	
	return 1;
}



public banger_EventStart(playerid)
{
   	new
	    string[128];

	Event_ID = BANGERSUMO;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Banger Sumo event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "[EVENT]: 30 seconds before it starts, type /join!", COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
		
	return 1;
}



public sandking_EventStart(playerid)
{
   	new
	    string[128];

	Event_ID = SANDKSUMO;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}SandKing Sumo event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "[EVENT]: 30 seconds before it starts, type /join!", COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
		
	return 1;
}



public sandkingR_EventStart(playerid)
{
   	new
	    string[128];

	Event_ID = SANDKSUMORELOADED;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}SandKing Sumo Reloaded event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "[EVENT]: 30 seconds before it starts, type /join!",COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
		
	return 1;
}


public derby_EventStart(playerid)
{
   	new
	    string[128];

	Event_ID = DESTRUCTIONDERBY;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Destruction Derby event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "30 seconds before it starts, type /join!", COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
		
	return 1;
}


public monster_PlayerJoinEvent(playerid)
{
    SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 505);

	SetPlayerPos(playerid, sumoSpawnsType1[increment][0], sumoSpawnsType1[increment][1], sumoSpawnsType1[increment][2]+5);
	SetPlayerFacingAngle(playerid, sumoSpawnsType1[increment][3]);
	Event_PlayerVeh[playerid] = CreateVehicle(556, sumoSpawnsType1[increment][0], sumoSpawnsType1[increment][1], sumoSpawnsType1[increment][2], sumoSpawnsType1[increment][3], -1, -1, 15);
	SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType1[increment][3]);

	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
	TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);
	increment++;
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	}
	
	return 1;
}


public banger_PlayerJoinEvent(playerid)
{
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 505);

	SetPlayerPos(playerid, sumoSpawnsType2[increment][0], sumoSpawnsType2[increment][1], sumoSpawnsType2[increment][2]+5);
	SetPlayerFacingAngle(playerid, sumoSpawnsType2[increment][3]);
	Event_PlayerVeh[playerid] = CreateVehicle(504, sumoSpawnsType2[increment][0], sumoSpawnsType2[increment][1], sumoSpawnsType2[increment][2], sumoSpawnsType2[increment][3], -1, -1, 15);

	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
	TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);
	increment++;
    new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	}
    return 1;
}


public sandking_PlayerJoinEvent(playerid)
{
    SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 505);

	SetPlayerPos(playerid, sumoSpawnsType3[increment][0], sumoSpawnsType3[increment][1], sumoSpawnsType3[increment][2]+5);
	SetPlayerFacingAngle(playerid, sumoSpawnsType3[increment][3]);
	Event_PlayerVeh[playerid] = CreateVehicle(495, sumoSpawnsType3[increment][0], sumoSpawnsType3[increment][1], sumoSpawnsType3[increment][2], sumoSpawnsType3[increment][3], -1, -1, 15);
	SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType3[increment][3]);

	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
	TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);
	increment++;
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	}
	return 1;
}


public sandkingR_PlayerJoinEvent(playerid)
{
    SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 505);

	SetPlayerPos(playerid, sumoSpawnsType5[increment][0], sumoSpawnsType5[increment][1], sumoSpawnsType5[increment][2]+5);
	SetPlayerFacingAngle(playerid, sumoSpawnsType5[increment][3]);
	Event_PlayerVeh[playerid] = CreateVehicle(495, sumoSpawnsType5[increment][0], sumoSpawnsType5[increment][1], sumoSpawnsType5[increment][2], sumoSpawnsType5[increment][3], -1, -1, 15);
	SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType5[increment][3]);

	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
	TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);
	increment++;
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	}
	return 1;
}


public derby_PlayerJoinEvent(playerid)
{
    SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 505);

	SetPlayerInterior(playerid, 15);
	SetPlayerPos(playerid, sumoSpawnsType4[increment][0], sumoSpawnsType4[increment][1], sumoSpawnsType4[increment][2]+5);
	SetPlayerFacingAngle(playerid, sumoSpawnsType4[increment][3]);
	Event_PlayerVeh[playerid] = CreateVehicle(504, sumoSpawnsType4[increment][0], sumoSpawnsType4[increment][1], sumoSpawnsType4[increment][2], sumoSpawnsType4[increment][3], -1, -1, 15);
	SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType4[increment][3]);
	LinkVehicleToInterior(Event_PlayerVeh[playerid], 15);

	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
	TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);
	increment++;
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -TDM_COST);
	        format(string, sizeof(string), "~r~-%d",TDM_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	}
	return 1;
}


public sumo_PlayerLeftEvent(playerid)
{
  	SetPVarInt(playerid, "LeftEventJust", 1);
	RemovePlayerFromVehicle(playerid);
	event_SpawnPlayer(playerid);

	if(EventPlayersCount() == 1)
	{
		new msg[128];
		foreach(Player, i)
	  	{
			if(GetPVarInt(i, "InEvent") == 1)
			{
				winner = i;
				break;
			}
		}
		format(msg, sizeof(msg), "				%s has won the Sumo event!", PlayerName(winner));
		SendClientMessageToAll(COLOR_NOTICE, msg);
		GiveAchievement(winner, 81);
		SendClientMessage(winner, COLOR_NOTICE, "You have won Sumo event! You have earnt 10 score!");
		FoCo_Player[winner][score] += 10;
		lastEventWon = winner;
		Event_Bet_End(winner);
		EndEvent();
		return 1;
	}
	
	return 1;
}



public sumo_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Sumo is now in progress and can not be joined.");
	SumoFallCheckTimer = repeat SumoFallCheck();
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			SetVehicleParamsEx(Event_PlayerVeh[i], true, false, false, true, false, false, false);
			TogglePlayerControllable(i, 1);
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
			increment = 0;
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

forward RespawnPlayer(playerid);
public RespawnPlayer(playerid)
{
	return event_SpawnPlayer(playerid);
}

forward SetEventTeamNames(type);
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
