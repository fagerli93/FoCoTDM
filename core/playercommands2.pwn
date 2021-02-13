#if !defined MAIN_INIT
#error "Compiling from wrong script. (foco.pwn)"
#endif

#define IFISNTSPECIALPEEP if(FoCo_Player[playerid][id] != 2 && FoCo_Player[playerid][id] != 3 && FoCo_Player[playerid][id] != 4)

CMD:help(playerid, params[])
{
	new options[2][128];
	new optioni[1];
	
	new string[256], pname[MAX_PLAYER_NAME];
	
	if(sscanf(params, "s ", options[0]))
	{
		format(string, sizeof(string), "|_______________________________________________ {%06x}HELP{%06x} _______________________________________________|", COLOR_WHITE >>> 8, COLOR_GREEN >>> 8);
		SendClientMessage(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "[Command Categories]: {%06x}/info - /p[layer] - /v[eh] - /clan - /duel - /settings", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "[Further Commands]: {%06x}/kill - /vote - /me - /join - /leave", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "[More Help]: {%06x}For further assistance you can use '/help me', '/help report'", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "[More Help]: {%06x}To view online Trial Admin or admins you can use '/help trialadmins' or '/help admins'", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_GREEN, string);
		return 1;
	}
	
	if(!strcmp(options[0], "me", true, 2))
	{
		if(sscanf(params, "s[128]s[128]", options[0], options[1]))
		{
			ShowPlayerTreeDialog(playerid, DIALOG_STYLE_INPUT, "help", params, "Help Me", "Please enter your question below and any online Trial Admin staff will endeavor to help you.", "Send", "Cancel");
			return 1;
		}
		
		GetPlayerName(playerid, pname, sizeof(pname));
		format(string, sizeof(string), "[HELP ME]: {%06x}%s (%d): %s", COLOR_NOTICE >>> 8, pname, playerid, options[1]);
		SendHelpMe(string);
		SendClientMessage(playerid, COLOR_GREEN, "Your request has been sent.");
		return 1;
	}
	
	if(!strcmp(options[0], "report", true, 6))
	{
		if(sscanf(params, "s[128]us", options[0], optioni[0]))
		{
			ShowPlayerTreeDialog(playerid, DIALOG_STYLE_INPUT, "help", params, "Help - Report", "Please enter the name or ID of the player you wish to report.", "Okay", "Cancel");
			return 1;
		}
		
		new result[128], vari[128], targetname[MAX_PLAYER_NAME];
		
		if(IsPlayerConnected(optioni[0])) 
		{
			if(sscanf(params, "s[128]us[128]", options[0], optioni[0], options[1]))
			{
				ShowPlayerTreeDialog(playerid, DIALOG_STYLE_INPUT, "help", params, "Help - Report", "Please enter the reason you wish to report this player.", "Send", "Cancel");
				return 1;
			}
			if(optioni[0] != INVALID_PLAYER_ID) 
			{
				GetPlayerName(optioni[0], targetname, sizeof(targetname));
				
				format(string, sizeof(string), "[REPORT %d]: %s(%d) has reported %s(%d), Reason: %s", playerid, pname, playerid, targetname, optioni[0], result);
				SendReportMessage(1, string);
				
				format(vari, sizeof(vari), "%s", result);
				ReportStr[playerid] = vari;
				reportID[playerid] = optioni[0];
				ReportLog(string);
				format(string, sizeof(string), "                You have reported %s (ID:%d), Reason: %s", targetname, optioni[0], result);
				
				SendClientMessage(playerid, COLOR_WHITE, string);
			}
			else 
			{
				SendClientMessage(playerid,COLOR_WARNING,"[ERROR]: The person you tried to report is not connected.");
			}
		}
		return 1;
	}
	
	if(!strcmp(options[0], "tradmins", true, 10))
	{
		format(string, sizeof(string), "|-------------------- {%06x}Trial Admins{%06x} --------------------|", COLOR_WHITE >>> 8, COLOR_GREEN >>> 8);
		SendClientMessage(playerid, COLOR_GREEN, string);
		foreach(Player, i)
		{
			if(FoCo_Player[i][tester] >= 1 && FoCo_Player[i][admin] == 0)
			{
				GetPlayerName(i, pname, sizeof(pname));
				format(string, 256, "Trial Admins: %s", pname);
				SendClientMessage(playerid, COLOR_ADMIN, string);
			}
		}
		SendClientMessage(playerid, COLOR_GREEN, "|---------------------------------------------------------------------|");
		return 1;
	}
	
	if(!strcmp(options[0], "admins", true, 6))
	{
		new adcount;
		format(string, sizeof(string), "|-------------- {%06x}ADMINISTRATORS{%06x} --------------|", COLOR_WHITE >>> 8, COLOR_GREEN >>> 8);
		SendClientMessage(playerid, COLOR_GREEN, string);
		foreach(Player, i)
		{
			if(FoCo_Player[i][admin] >= 1 && FoCo_Player[i][id] != 2)
			{
				if(ADuty[i] == 0)
				{
					if(FoCo_Player[i][admin] != 5)
					{	
						GetPlayerName(i, pname, sizeof(pname));
						format(string, 256, "Administrator: %s - [Administrator Level: %d]", pname,FoCo_Player[i][admin]);
						SendClientMessage(playerid, COLOR_WHITE, string);
						adcount++;
					}
				}
				else
				{
					GetPlayerName(i, pname, sizeof(pname));
					format(string, 256, "Administrator: %s - [Administrator Level: %d]", pname,FoCo_Player[i][admin]);
					SendClientMessage(playerid, COLOR_ADMIN, string);
					adcount++;
				}
			}
		}
		if(adcount == 0)
		{
			SendClientMessage(playerid, COLOR_ADMIN, "        There are currently no administrators online.");
		}
		SendClientMessage(playerid, COLOR_GREEN, "|-----------------------------------------------------------------------|");
		return 1;
	}
	return cmd_help(playerid, "");
}

CMD:anim(playerid, params[]){return cmd_animation(playerid, params);}
CMD:animation(playerid, params[])
{
	new options[1][128];
	
	if(sscanf(params, "s ", options[0]))
	{
		ShowPlayerTreeDialog(playerid, DIALOG_STYLE_LIST, "animation", params, "Animations", "Handsup\nLaugh\nCrossArms\nLay\nHide\nWave\nlapass\nCrack\nSit\nChat\nFuckYou\nDrink\nSleep\nTaichi\nVomit\nDance\nStop", "Select", "Cancel");
		return 1;
	}
	
	if(!strcmp(options[0], "handsup", true, 7))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		{
			return 1;
		}
		
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
		return 1;
	}

	if(!strcmp(options[0], "laugh", true, 5))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		{
			return 1;
		}
		
		OnePlayAnim(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0);
		return 1;
	}

	if(!strcmp(options[0], "crossarms", true, 9))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		{
			return 1;
		}
		
		LoopingAnim(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
		return 1;
	}

	if(!strcmp(options[0], "lay", true, 3))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		{
			return 1;
		}
		
		LoopingAnim(playerid,"BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
		return 1;
	}

	if(!strcmp(options[0], "hide", true, 4))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		{
			return 1;
		}
		
		LoopingAnim(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0); 
		return 1;
	}

	if(!strcmp(options[0], "vomit", true, 5))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		{
			return 1;
		}
		
		OnePlayAnim(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0);
		return 1;
	}

	if(!strcmp(options[0], "wave", true, 4))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		{
			return 1;
		}
		
		LoopingAnim(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0);
		return 1;
	}

	if(!strcmp(options[0], "slapass", true, 7))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		{
			return 1;
		}
		
		OnePlayAnim(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0); 
		return 1;
	}

	if(!strcmp(options[0], "crack", true, 5))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		{
			return 1;
		}
		
		LoopingAnim(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
		return 1;
	}

	if(!strcmp(options[0], "sit", true, 3))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		{
			return 1;
		}
		
		LoopingAnim(playerid,"BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0); 
		return 1;
	}

	if(!strcmp(options[0], "chat", true, 4))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		{
			return 1;
		}
		
		OnePlayAnim(playerid,"PED","IDLE_CHAT",4.0,0,0,0,0,0);
		return 1;
	}

	if(!strcmp(options[0], "fu", true, 2) || !strcmp(options[0], "fuckyou", true, 7))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		{
			return 1;
		}
		
		OnePlayAnim(playerid,"PED","fucku",4.0,0,0,0,0,0);
		return 1;
	}

	if(!strcmp(options[0], "taichi", true, 6))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		{
			return 1;
		}
		
		LoopingAnim(playerid,"PARK","Tai_Chi_Loop",4.0,1,0,0,0,0);
		return 1;
	}

	if(!strcmp(options[0], "drink", true, 5))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		{
			return 1;
		}
		
		LoopingAnim(playerid,"BAR","dnk_stndF_loop",4.0,1,0,0,0,0);
		return 1;
	}

	if(!strcmp(options[0], "sleep", true, 5))
	{ 
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		{
			return 1;
		}
		
		LoopingAnim(playerid,"INT_HOUSE","BED_Loop_R",4.0,1,0,0,0,0);
		return 1;
	}
	if(!strcmp(options[0], "stop", true, 4))
	{ 
		ClearAnimations(playerid, 0);
		StopLoopingAnim(playerid);
		return 1;
	}
	return cmd_animation(playerid, "");
}

CMD:v(playerid, params[]){return cmd_veh(playerid, params);}
CMD:veh(playerid, params[])
{
	new options[2][128];
	new optioni[1];
	
	new string[256];
	
	
	if(sscanf(params, "s ", options[0]))
	{
		ShowPlayerTreeDialog(playerid, DIALOG_STYLE_LIST, "veh", params, "Vehicle Options", "Sell\nSpawn\nPark\nLock\nMod\nEject", "Select", "Cancel");
	}

	if(!strcmp(options[0], "sell", true, 4))
	{
		if(IsPlayerInRangeOfPoint(playerid, 10.0, 1702.7118,-1470.0952,13.5469))
		{
			if(FoCo_Vehicles[GetPlayerVehicleID(playerid)][coid] == FoCo_Player[playerid][id])
			{
				new price = CarPrice(GetVehicleModel(GetPlayerVehicleID(playerid)));
				format(string, sizeof(string), "DELETE FROM `FoCo_Player_Vehicles` WHERE `ID`='%d' LIMIT 1", FoCo_Player[playerid][users_carid]);
				mysql_query(string, MYSQL_THREAD_SELLCAR, playerid, con);
				FoCo_Player[playerid][users_carid] = -1;
				
				format(string, sizeof(string), "UPDATE `FoCo_Players` SET `carid`='-1' WHERE `ID`='%d'", FoCo_Player[playerid][id]);
				mysql_query(string, MYSQL_THREAD_SELLCAR_2, playerid, con);
				
				new Float:finalprice = price * 0.78;
				price = floatround(finalprice, floatround_ceil);
				GivePlayerMoney(playerid, price);
				DestroyVehicle(GetPlayerVehicleID(playerid));
				new moneystring[256];
				format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from SellCall.", PlayerName(playerid), playerid, price);
				MoneyLog(moneystring);
				format(string, sizeof(string), "Car Dealer says: Here is $%d for your vehicle, thank you for dealing with us.", price);
				SendClientMessage(playerid, COLOR_GRAD1, string);
				Delete3DTextLabel(vehicle3Dtext[playerid]);
				SetPVarInt(playerid, "VehSpawn", -1);
			}
			else
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be in your vehicle.");
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You must be at Commerce Dealership for this.");
		}
		return 1;
	}
	
	if(!strcmp(options[0], "spawn", true, 5))
	{ 
		if(FoCo_Player[playerid][users_carid] == -1)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You don't own a vehicle.");
			return 1;
		}
		
		if(FoCo_Player[playerid][jailed] != 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't spawn your vehicle in jail.");
			return 1;
		}
		
		new Float:health;
		GetPlayerHealth(playerid, health);
		if(health < 100.00 && !IsPlayerInRangeOfPoint(playerid, 40.0, 1929.5873,-1775.4641,13.5469) && Turf_Gang_Owned != FoCo_Team[playerid])
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot spawn your vehicle with less than 100 percent health.");
			return 1;
		}
		
		if(GetPlayerInterior(playerid) != 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're in an interior, you will need to leave before you can spawn your vehicle.");
			return 1;
		}
		
		if(GetPlayerVirtualWorld(playerid) != 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're in a different world, you will need to leave before you can spawn your vehicle.");
			return 1;
		}
		
		if(GetPlayerState(playerid) == PLAYER_STATE_WASTED)
		{
			return 1;
		}
		
		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are already in a vehicle");
			return 1;
		}
		
		new Float:cpos1, Float:cpos2, Float:cpos3, msg[128];
		if(GetPVarInt(playerid, "VehSpawn") > 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your vehicle is already spawned.");
			GetVehiclePos(GetPVarInt(playerid, "VehSpawn"), cpos1, cpos2, cpos3);
			SetPlayerCheckpoint(playerid, cpos1, cpos2, cpos3, 5.0);
			return 1;
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 20.0, FoCo_Teams[FoCo_Team[playerid]][team_spawn_x], FoCo_Teams[FoCo_Team[playerid]][team_spawn_y], FoCo_Teams[FoCo_Team[playerid]][team_spawn_z]))
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're too close to spawn.");
			return 1;
		}
		
		if(vehtimerspawning[playerid] + 60 > GetUnixTime())
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot spawn your vehicle within 60 seconds of parking it.");
			return 1;
		}
		
		vehtimerspawning[playerid] = GetUnixTime();
		format(msg, sizeof(msg), "SELECT * FROM `FoCo_Player_Vehicles` WHERE `ID`='%d' LIMIT 1", FoCo_Player[playerid][users_carid]);
		mysql_query(msg, MYSQL_THREAD_MYCAR, playerid, con);
		return 1;
	}
	
	if(!strcmp(options[0], "updatekey", true, 9))
	{ 
		if(updatecarkey[playerid] + 60 > GetUnixTime())
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No need to spam this command, if it does not work first time.. it won't work again.");
			return 1;
		}

		new msg[250];
		updatecarkey[playerid] = GetUnixTime();
		format(msg, sizeof(msg), "SELECT * FROM `FoCo_Player_Vehicles` WHERE `oname`='%s'", PlayerName(playerid));
		mysql_query(msg, MYSQL_THREAD_FIXMYCAR, playerid, con);
		return 1;
	}
	
	if(!strcmp(options[0], "park", true, 4))
	{ 
		if(FoCo_Player[playerid][users_carid] == -1)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You don't own a vehicle.");
			return 1;
		}
		
		if(GetPlayerVehicleID(playerid) != GetPVarInt(playerid, "VehSpawn"))
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be in your vehicle.");
			return 1;
		}
		
		if(!IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be in your vehicle.");
			return 1;
		}
		
		if(vehtimerspawning[playerid] + 60 > GetUnixTime())
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot park it within 60 seconds of spawning it");
			return 1;
		}
		vehtimerspawning[playerid] = GetUnixTime();
		
		foreach(Player, i)
		{
			if(GetPlayerSurfingVehicleID(i) == GetPlayerVehicleID(playerid))
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot do this right now, as people are on your roof!");
				return 1;
			}
		}
		
		new Float:health;
		GetPlayerHealth(playerid, health);
		
		if(health < 75.0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Health too low to park your vehicle");
			return 1;
		}
		
		Delete3DTextLabel(vehicle3Dtext[playerid]);
		DestroyVehicle(GetPlayerVehicleID(playerid));
		SetPVarInt(playerid, "VehSpawn", -1);
		SendClientMessage(playerid, COLOR_NOTICE, "You have parked your vehicle.");
		return 1;
	}
	
	if(!strcmp(options[0], "lock", true, 4))
	{ 
		if(FoCo_Player[playerid][users_carid] == -1)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You don't own a vehicle.");
			return 1;
		}
		
		new Float:xx, Float:yy, Float:zz;
		if(GetPVarInt(playerid, "VehSpawn") > 0)
		{
			GetVehiclePos(GetPVarInt(playerid, "VehSpawn"), xx, yy, zz);
			
			if(IsPlayerInRangeOfPoint(playerid, 5.0, xx, yy, zz))
			{
				if(FoCo_Vehicles[GetPVarInt(playerid, "VehSpawn")][clocked] == 1)
				{
					FoCo_Vehicles[GetPVarInt(playerid, "VehSpawn")][clocked] = 0;
					SendClientMessage(playerid, COLOR_NOTICE, "Your vehicle has now been un-locked.");
					SetVehicleParamsEx(GetPVarInt(playerid, "VehSpawn"), true, true, false, false, false, false, false);
				}
				else
				{
					FoCo_Vehicles[GetPVarInt(playerid, "VehSpawn")][clocked] = 1;
					SendClientMessage(playerid, COLOR_NOTICE, "Your vehicle has now been locked.");
					SetVehicleParamsEx(GetPVarInt(playerid, "VehSpawn"), true, true, false, true, false, false, false);
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your not in range of your vehicle.");
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That action isn't available right now.");
		}
		return 1;
	}
	
	if(!strcmp(options[0], "mod", true, 3))
	{ 
		if(ShowModMenu(playerid) == 0) return SendClientMessage(playerid, COLOR_WARNING,  "[ERROR]: You are not in a vehicle or this vehicle is unmodifiable.");
		else 
		{
			if(ModdingCar[playerid] == 1) return SendClientMessage(playerid, COLOR_WARNING,  "[ERROR]: You are already modifying your vehicle...");
			SendClientMessage(playerid, COLOR_CMDNOTICE, "                Use your look left & look right buttons to switch between mods. Use your enter key to select an item and your jump key to go back.");
			BackupMods(playerid);
			return 1;
		}
	}
	
	if(!strcmp(options[0], "eject", true, 5))
	{ 
		if(sscanf(params, "su", options[0], optioni[0]))
		{
			ShowPlayerTreeDialog(playerid, DIALOG_STYLE_INPUT, "veh", params, "Eject a Player", "Please enter the player ID or name of who you would like to eject from the vehicle.", "Select", "Cancel");
			return 1;
		}
		
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be the driver to do this.");
			return 1;
		}
		
		if(GetPlayerVehicleID(playerid) != GetPlayerVehicleID(optioni[0]))
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That user is not in your vehicle.");
			return 1;
		}
		
		RemovePlayerFromVehicle(optioni[0]);
		SendClientMessage(playerid, COLOR_NOTICE, "Player removed from the vehicle.");
		GameTextForPlayer(optioni[0], "~r~~n~Ejected", 3, 1000);
		return 1;
	}
	return cmd_veh(playerid, "");
}

CMD:clan(playerid, params[])
{
	new options[2][128];
	new optioni[1];
	
	
	new string[256], pname[MAX_PLAYER_NAME], tname[MAX_PLAYER_NAME];
	
	
	if(sscanf(params, "s ", options[0]))
	{
		format(string, 256, "Message\n");
		if(FoCo_Player[playerid][clan] != -1 || FoCo_Player[playerid][clanrank] == 1)
		{
			strins(string, "Invite\nUninvite\n", strlen(string), 256);
		}
		if(FoCo_Player[playerid][clan] != -1)
		{
			strins(string, "Members\nRanks\n", strlen(string), 256);
		}
		if(GetPVarInt(playerid, "ClanInvite") >= 1)
		{
			strins(string, "Invitation", strlen(string), 256);
		}
		ShowPlayerTreeDialog(playerid, DIALOG_STYLE_LIST, "clan", params, "Clan Options", string, "Select", "Cancel");
	}

	if(!strcmp(options[0], "message", true, 7))
	{
		if(sscanf(params, "s s", options[0], options[1]))
		{
			ShowPlayerTreeDialog(playerid, DIALOG_STYLE_INPUT, "clan", params, "Team Message", "Please type the message you wish to send your team.", "Send", "Cancel");
		}
		cmd_g(playerid, options[1]);
		return 1;
	}
	
	if(!strcmp(options[0], "invite", true, 6))
	{
		if(sscanf(params, "s u", options[0], optioni[0]))
		{
			ShowPlayerTreeDialog(playerid, DIALOG_STYLE_INPUT, "clan", params, "Invite Player", "Please type the name or ID of the player you wish to invite to your team.", "Send", "Cancel");
		}
		
		if(FoCo_Player[playerid][clan] == -1 || FoCo_Player[playerid][clanrank] != 1)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're not the leader of a clan.");
			return 1;
		}
		

		if(optioni[0] == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid ID/Name.");
			return 1;
		}
		
		if(FoCo_Player[optioni[0]][clan] > 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player is already in a clan.");
			return 1;
		}
		
		format(string, sizeof(string), "SELECT * FROM `FoCo_Players` WHERE `clan` = '%d'", FoCo_Player[playerid][clan]);
		mysql_query_callback(optioni[0], string, "OnClanInviteQuery", playerid, con);
		return 1;
	}
	
	if(!strcmp(options[0], "uninvite", true, 8))
	{
	
		if(sscanf(params, "s u", options[0], optioni[0]))
		{
			ShowPlayerTreeDialog(playerid, DIALOG_STYLE_INPUT, "clan", params, "Uninvite Player", "Please type the name or ID of the player you wish to remove from your team.", "Send", "Cancel");
		}
		
		if(FoCo_Player[playerid][clan] == -1 || FoCo_Player[playerid][clanrank] != 1)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're not the leader of a clan");
			return 1;
		}
		
		
		if(optioni[0] == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid ID/Name.");
			return 1;
		}
		if(FoCo_Player[playerid][clan] != FoCo_Player[optioni[0]][clan])
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That player is not in your clan.");
			return 1;
		}
		
		GetPlayerName(playerid, pname, sizeof(pname));
		GetPlayerName(optioni[0], tname, sizeof(tname));
		format(string, sizeof(string), "[NOTICE]: %s has uninvited you from '%s'!", pname, FoCo_Teams[FoCo_Player[playerid][clan]][team_name]);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		format(string, sizeof(string), "[NOTICE]: You have uninvited %s from your clan.", tname);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		FoCo_Player[optioni[0]][clan] = -1;
		FoCo_Player[optioni[0]][clanrank] = -1;
		FoCo_Team[optioni[0]] = 1;
		ForceClassSelection(optioni[0]);
		return 1;
	}
	
	if(!strcmp(options[0], "members", true, 7))
	{ 
		if(FoCo_Player[playerid][clan] == -1)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're not in a clan.");
			return 1;
		}
		
		SendClientMessage(playerid, COLOR_NOTICE, "======== Clan Online Members =======");
		foreach(Player, i)
		{
			if(FoCo_Player[i][clan] == FoCo_Player[playerid][clan])
			{
				format(string, sizeof(string), "[ID: %d] - %s %s", i, FoCo_Player[i][clanrank], PlayerName(i));
				SendClientMessage(playerid, COLOR_WHITE, string);
			}
		}
		SendClientMessage(playerid, COLOR_NOTICE, "====================================");
		return 1;
	}
	
	if(!strcmp(options[0], "ranks", true, 5))
	{ 
		if(FoCo_Player[playerid][clan] == -1)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're not in a clan.");
			return 1;
		}
		
		SendClientMessage(playerid, COLOR_NOTICE, "============= Ranks =============");
		format(string, sizeof(string), "Rank 1: %s", FoCo_Teams[FoCo_Player[playerid][clan]][team_rank_1]);
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Rank 2: %s", FoCo_Teams[FoCo_Player[playerid][clan]][team_rank_2]);
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Rank 3: %s", FoCo_Teams[FoCo_Player[playerid][clan]][team_rank_3]);
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Rank 4: %s", FoCo_Teams[FoCo_Player[playerid][clan]][team_rank_4]);
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Rank 5: %s", FoCo_Teams[FoCo_Player[playerid][clan]][team_rank_5]);
		SendClientMessage(playerid, COLOR_WHITE, string);
		SendClientMessage(playerid, COLOR_NOTICE, "====================================");
		return 1;
	}
	
	if(!strcmp(options[0], "invitation", true, 10))
	{ 
		if(sscanf(params, "s s ", options[0], options[1]))
		{
			if(GetPVarInt(playerid, "ClanInvite") >= 1)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have not been invited into any clan.");
			}
			if(sscanf(params, "s s d", options[0], options[1], optioni[0]))
			{
				format(string, 256, "You have been invited to join %s, you may accept or reject this offer.", FoCo_Teams[GetPVarInt(playerid, "ClanInvite")][team_name]);
				ShowPlayerTreeDialog(playerid, DIALOG_STYLE_MSGBOX, "clan", params, "Clan Invite", string, "Accept", "Reject");
			}
			
			if(optioni[0] == 1)
			{
				if(GetPVarInt(playerid, "ClanInvite") < 1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have not been invited to any clan.");
					return 1;
				}
				
				FoCo_Player[playerid][clan] = GetPVarInt(playerid, "ClanInvite");
				FoCo_Player[playerid][clanrank] = FoCo_Teams[FoCo_Player[playerid][clan]][team_rank_amount];
				
				format(string, sizeof(string), "                You have joined '%s'!", FoCo_Teams[FoCo_Player[playerid][clan]][team_name]);
				SendClientMessage(playerid, COLOR_NOTICE, string);
				DeletePVar(playerid, "ClanInvite");
			}
			else
			{
				if(GetPVarInt(playerid, "ClanInvite") < 1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have not been invited to any clan.");
					return 1;
				}
				
				format(string, sizeof(string), "                You have rejected the invite to join '%s'!", FoCo_Teams[FoCo_Player[playerid][clan]][team_name]);
				SendClientMessage(playerid, COLOR_NOTICE, string);
				DeletePVar(playerid, "ClanInvite");
			}
		}
		return 1;
	}
	return cmd_clan(playerid, "");
}

CMD:g(playerid, params[])
{
	if(Muted[playerid] != 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You're muted.");
		return 1;
	}
	
	new result[275], result2[275], val[275], pname[MAX_PLAYER_NAME];
	if (sscanf(params, "s[275]", result))
	{
		format(result, sizeof(result), "[USAGE]: {%06x}/g {%06x}[Message]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, result);
		return 1;
	}
	GetPlayerName(playerid, pname, sizeof(pname));
	
	if(GetPVarInt(playerid, "AtEvent") == 1)
	{
		if(GetPVarInt(playerid, "MotelTeamIssued") != 0)
		{
			format(result2, sizeof(result2), "[G-Event]: Member %s says: %s", pname, result);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, result2);
			GChatLog(result2);
			
			foreach (Player, i)
			{
				if(gPlayerLogged[i] == 1)
				{
					if(GetPVarInt(i, "MotelTeamIssued") == GetPVarInt(playerid, "MotelTeamIssued"))
					{
						SendClientMessage(i, COLOR_LIGHTBLUE, result2);
					}
				}
			}
			
			return 1;
		}
	}
	
	switch(FoCo_Player[playerid][clanrank])
	{
		case 1: 
		{
			format(result2, sizeof(result2), "%s", FoCo_Teams[FoCo_Team[playerid]][team_rank_1]);
			val = result2;
		}
		case 2: 
		{
			format(result2, sizeof(result2), "%s", FoCo_Teams[FoCo_Team[playerid]][team_rank_2]);
			val = result2;
		}
		case 3: 
		{
			format(result2, sizeof(result2), "%s", FoCo_Teams[FoCo_Team[playerid]][team_rank_3]);
			val = result2;
		}
		case 4: 
		{
			format(result2, sizeof(result2), "%s", FoCo_Teams[FoCo_Team[playerid]][team_rank_4]);
			val = result2;
		}
		case 5: 
		{
			format(result2, sizeof(result2), "%s", FoCo_Teams[FoCo_Team[playerid]][team_rank_5]);
			val = result2;
		}
		default: 
		{
			format(result2, sizeof(result2), "%s", FoCo_Teams[FoCo_Team[playerid]][team_rank_1]);
			val = result2;
		}
	}
	
	format(result2, sizeof(result2), "[GANG]: %s %s says: %s", val, pname, result);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, result2);
	GChatLog(result2);

	foreach (Player, i)
	{
		if(gPlayerLogged[i] == 1)
		{
			if(FoCo_Team[i] == FoCo_Team[playerid])
			{
				SendClientMessage(i, COLOR_LIGHTBLUE, result2);
			}
			else if(WatchGAdmin[i] == FoCo_Team[playerid])
			{
				SendClientMessage(i, COLOR_LIGHTBLUE, result2);
			}
		}
	}
	return 1;
}

CMD:info(playerid, params[])
{
	new targetid;
	if (sscanf(params, "u", targetid))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /info [ID/Name]");
		return 1;
	}
	if(targetid == INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
		return 1;
	}
	if(aUndercover[targetid] == 1) {
		return underCover(playerid, targetid, 0);
	}
	new string[164];
	format(string, sizeof(string), "|-------------------------------- {%06x}%s(%d){%06x} --------------------------------|", COLOR_WARNING >>> 8, PlayerName(targetid), targetid, COLOR_CMDNOTICE >>> 8);
	SendClientMessage(playerid, COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "DB-ID: %d - Status: %s - Level: %d - Rank: %s  - VIP Rank: %d", FoCo_Player[targetid][id], GetPlayerStatus(targetid), FoCo_Player[targetid][level], PlayerRankNames[FoCo_Player[targetid][level]], FoCo_Player[targetid][vip]);
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Money: $%d - Car DB-ID: %d Car IG-ID: %d - Score: %d - Kills: %d - Deaths: %d - KDR: %02f", GetPlayerMoney(targetid), FoCo_Player[targetid][users_carid], GetPVarInt(playerid, "VehSpawn"), FoCo_Player[targetid][score], FoCo_Playerstats[targetid][kills], FoCo_Playerstats[targetid][deaths], floatdiv(FoCo_Playerstats[targetid][kills], FoCo_Playerstats[targetid][deaths]));
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Suicides: %d - Longest Streak: %d - Current Streak: %d", FoCo_Playerstats[targetid][suicides], FoCo_Playerstats[targetid][streaks], CurrentKillStreak[targetid]);
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Duels Won: %d - Duels Lost: %d - Total Duels: %d", FoCo_Player[targetid][duels_won], FoCo_Player[targetid][duels_lost], (FoCo_Player[targetid][duels_won]+FoCo_Player[targetid][duels_lost]));
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "%s", TimerOnline(FoCo_Player[targetid][onlinetime], 0));
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Helicopter: %d - Deagle: %d - M4: %d - MP5: %d - Knife: %d", FoCo_Playerstats[targetid][heli], FoCo_Playerstats[targetid][deagle], FoCo_Playerstats[targetid][m4], FoCo_Playerstats[targetid][mp5], FoCo_Playerstats[targetid][knife]);
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Flamethrower: %d - Chainsaw: %d - Colt: %d", FoCo_Playerstats[targetid][flamethrower], FoCo_Playerstats[targetid][chainsaw], FoCo_Playerstats[targetid][colt]);
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Uzi: %d - Combat Shotgun: %d - AK47: %d - Tec9: %d - Sniper: %d", FoCo_Playerstats[targetid][uzi], FoCo_Playerstats[targetid][combatshotgun], FoCo_Playerstats[targetid][ak47], FoCo_Playerstats[targetid][tec9], FoCo_Playerstats[targetid][sniper]);
	SendClientMessage(playerid, COLOR_NOTICE, string);
	return 1;
}

CMD:rp(playerid, params[])
{
	ResetPlayerWeaponsEx(playerid, 9,16,17,18,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45);
	return 1;
}

CMD:para(playerid, params[])
{
	cmd_rp(playerid, params);
	return 1;
}

