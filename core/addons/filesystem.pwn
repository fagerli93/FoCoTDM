/*********************************************************************************
*																				 *
*				 ______     _____        _______ _____  __  __                   *
*				|  ____|   / ____|      |__   __|  __ \|  \/  |                  *
*				| |__ ___ | |     ___      | |  | |  | | \  / |                  *
*				|  __/ _ \| |    / _ \     | |  | |  | | |\/| |                  *
*				| | | (_) | |___| (_) |    | |  | |__| | |  | |                  *
*				|_|  \___/ \_____\___/     |_|  |_____/|_|  |_|                  *
*                                                                                *
*                                                                                *
*								(c) Copyright				 					 *
*  Owners: Simon Fagerli (pEar) - Lee Percox (Shaney) - Warren Bickley (WazzaJB) *
*         Developers: Marcel, RakGuy, FKu, Chilco, dr_vista, Fletcher            *
*																				 *
* Filename: filesystem.pwn                                                       *
* Created by: -                                                                  *
*********************************************************************************/

#if !defined MAIN_INIT
#error "Compiling from wrong script. (foco.pwn)"
#endif

forward Saving_Connect();
public Saving_Connect()
{
    con = mysql_connect(SQL_HOST, SQL_USER, SQL_DB, SQL_PASS);
    mysql_debug(1);
	return 1;
}

forward Saving_Disconnect();
public Saving_Disconnect()
{
	return 1;
}

forward LoadScript();
public LoadScript()
{
	mysql_query("SELECT * FROM `FoCo_Vehicles` ORDER BY `ID` ASC",THREAD_LOAD_CARS);
	mysql_query("SELECT * FROM `FoCo_Pickups` ORDER BY `ID` ASC", THREAD_LOAD_PICKUPS);
	mysql_query("SELECT * FROM `FoCo_Turfs` ORDER BY `ID` ASC", THREAD_LOAD_TURFS);
    return 1;
}

/*
forward AchievementSave(playerid);
public AchievementSave(playerid)
{
	new query[800], stage[50], achval, db[56];
	format(query, sizeof(query), "UPDATE `FoCo_Achievements` SET ");
	for(new i = 1; i < AMOUNT_ACHIEVEMENTS+1; i++)
	{
		if(FoCo_PlayerAchievements[playerid][i] > 0)
		{
            achval = 1;
		}
		else
		{
            achval = 0;
		}
		
		format(stage, sizeof(stage), "`ach%d`='%d', ", i, achval);
		
		strcat(query, stage, sizeof(stage));

		if(i >= AMOUNT_ACHIEVEMENTS)
		{
			strdel(query, strlen(query) - 2, strlen(query));
			
			format(stage, sizeof(stage), " WHERE `ID` = '%d' LIMIT 1", FoCo_Player[playerid][id]);
			
			strins(query, stage, sizeof(stage));
			
			mysql_query(query, MYSQL_ACHIUPDATE, playerid, con);
			
			break;
		}
	}
	return 1;
}
*/

// Edited by Mr. pEar. It will take pergo achievements at a time, as the query it sends will be too long otherwise.
forward AchievementSave(playerid);
public AchievementSave(playerid)
{
	new rounds, i, k, achval, start, end, pergo;
	new query[800], stage[50];
	pergo = 40;
	rounds = floatround((AMOUNT_ACHIEVEMENTS / pergo), floatround_ceil);
	
	for(i = 0; i <= rounds; i++)
	{
	    format(query, sizeof(query), "UPDATE FoCo_Achievements SET ");
	    start = (i * pergo) + 1;
		end = (i + 1) * pergo;
		if(end > AMOUNT_ACHIEVEMENTS)
		{
		    end = AMOUNT_ACHIEVEMENTS;
		}
		for(k = start; k <= end; k++)
		{
		    if(FoCo_PlayerAchievements[playerid][k] > 0)
		    {
		        achval = 1;
		    }
		    else
		    {
		        achval = 0;
		    }
		    format(stage, sizeof(stage), "ach%d='%d', ", k, achval);
		    strins(query, stage, strlen(query), sizeof(stage));
		    if(k >= end)
		    {
		        strdel(query, strlen(query) - 2, strlen(query));
		        format(stage, sizeof(stage), " WHERE ID='%d' LIMIT 1;", FoCo_Player[playerid][id]);
		        strins(query, stage, strlen(query), sizeof(stage));
		        mysql_query(query, MYSQL_ACHIUPDATE, playerid, con);
		        break;
		    }
		}
	}
	return 1;
}

forward DuelSave(playerid);
public DuelSave(playerid)
{
	new query[256];
	format(query, sizeof(query), "UPDATE FoCo_Duels SET fd_wins='%d', fd_lost='%d', fd_total='%d';", FoCo_Player[playerid][duels_won], FoCo_Player[playerid][duels_lost], (FoCo_Player[playerid][duels_won]+FoCo_Player[playerid][duels_lost]));
	mysql_query(query, MYSQL_DUELUPDATE, playerid, con);
	return 1;
}
/*
forward LoadPlayerDuels(playerid);
public LoadPlayerDuels(playerid)
{	
	new query[256];
	format(query, sizeof(query), "SELECT * FROM FoCo_Duels WHERE ID='%d;", FoCo_Player[playerid][id]);
	mysql_query(query, MYSQL_LOAD_DUELS, playerid, con);
	return 1;
}
*/

forward LoadPlayerAchievements(playerid);
public LoadPlayerAchievements(playerid)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `FoCo_Achievements` WHERE `ID`='%d'", FoCo_Player[playerid][id]);
	printf("Calling MYSQL_LOAD_ACHIEVEMENTS:: Initial Call :: %s", string);
	mysql_query(string, MYSQL_LOAD_ACHIEVEMENTS, playerid, con);
	return 1;
}

stock LoadPickups()
{
	mysql_store_result();
    new pickups[12][100];
	new results[290];
	new string[150];
	new pickupsid;
	while(mysql_fetch_row(results))
	{
		split(results, pickups, '|');
  		pickupsid = CreateDynamicPickup(strval(pickups[1]), strval(pickups[2]), floatstr(pickups[3]), floatstr(pickups[4]), floatstr(pickups[5]), strval(pickups[6]), strval(pickups[7]), -1, FLOAT_PICKUP_DISTANCE);
  		FoCo_Pickups[pickupsid][LP_DBID] = strval(pickups[0]);
		FoCo_Pickups[pickupsid][LP_pickupid] = strval(pickups[1]);
		FoCo_Pickups[pickupsid][LP_type] = strval(pickups[2]);
		FoCo_Pickups[pickupsid][LP_x] = floatstr(pickups[3]);
		FoCo_Pickups[pickupsid][LP_y] = floatstr(pickups[4]);
		FoCo_Pickups[pickupsid][LP_z] = floatstr(pickups[5]);
		FoCo_Pickups[pickupsid][LP_world] = strval(pickups[6]);
		FoCo_Pickups[pickupsid][LP_interior] = strval(pickups[7]);
		
		format(string, sizeof(string), "%s", pickups[8]);
		FoCo_Pickups[pickupsid][LP_message] = string;
		
		format(string, sizeof(string), "%s", pickups[9]);
		FoCo_Pickups[pickupsid][LP_addedby] = string;
		
		FoCo_Pickups[pickupsid][LP_Option_one] = strval(pickups[10]);
		FoCo_Pickups[pickupsid][LP_Selected_Type] = strval(pickups[11]);
		
		FoCo_Pickups[pickupsid][LP_IGID] = pickupsid;
		
        printf("[DYNAMIC Pickups:] Pickup ID: %d, Model: %d, Type: %d, World: %d, Interior: %d", pickupsid, FoCo_Pickups[pickupsid][LP_pickupid], FoCo_Pickups[pickupsid][LP_type], FoCo_Pickups[pickupsid][LP_world], FoCo_Pickups[pickupsid][LP_interior]);
		printf("[DYNAMIC Pickups DEBUG:] PICKUP X: %f - PICKUP Y: %f - PICKUP Z - %f", FoCo_Pickups[pickupsid][LP_x], FoCo_Pickups[pickupsid][LP_y], FoCo_Pickups[pickupsid][LP_z]);
	}
	mysql_free_result();
    return 1;
}


forward LoadClassString(playerid, type);
public LoadClassString(playerid, type) // type 0 == Give Class ..  type 1 == Edit Class
{
	new string[200];
	DialogOptionVar1[playerid] = type;
	format(string, sizeof(string), "select * from FoCo_Classes where player_id = '%d' limit 5", FoCo_Player[playerid][id]);
	mysql_query(string, MYSQL_LOAD_CLASS_STRING, playerid, con);
	return 1;
}

forward GiveClass(playerid, class_db_id);
public GiveClass(playerid, class_db_id)
{
	new string[200];
	format(string, sizeof(string), "select * from FoCo_Classes where ID = '%d' limit 5", class_db_id);
	mysql_query(string, MYSQL_GIVE_CLASS, playerid, con);
	return 1;
}


stock SavePickups(pickupid)
{
	new string[405];
	format(string, sizeof(string), "UPDATE `FoCo_Pickups` SET `pickupid`='%d', `type`='%d', `x`='%f', `y`='%f', `z`='%f', `world`='%d', `interior`='%d', `message`='%s', `addedby`='%s', `option1`='%d', `option2`='%d' WHERE `ID`='%d'",
		FoCo_Pickups[pickupid][LP_pickupid], FoCo_Pickups[pickupid][LP_type], FoCo_Pickups[pickupid][LP_x], FoCo_Pickups[pickupid][LP_y], FoCo_Pickups[pickupid][LP_z], FoCo_Pickups[pickupid][LP_world], FoCo_Pickups[pickupid][LP_interior], FoCo_Pickups[pickupid][LP_message], FoCo_Pickups[pickupid][LP_addedby], FoCo_Pickups[pickupid][LP_Option_one], FoCo_Pickups[pickupid][LP_Selected_Type], FoCo_Pickups[pickupid][LP_DBID]);
		
	printf("Calling MYSQL_SAVE_PICKUP:: Initial Call :: %s", string);
	mysql_query(string, MYSQL_SAVE_PICKUP, pickupid, con);
	return 1;
}

public SaveTeam(team_use_ID)
{
	new string[405];
	format(string, sizeof(string), "UPDATE `FoCo_Teams` SET `team_color`='%s', `team_rank_amount`='%d', `team_rank_1`='%s', `team_rank_2`='%s', `team_rank_3`='%s', `team_rank_4`='%s', `team_rank_5`='%s' WHERE `ID`='%d'",
		FoCo_Teams[team_use_ID][team_color], FoCo_Teams[team_use_ID][team_rank_amount], FoCo_Teams[team_use_ID][team_rank_1], FoCo_Teams[team_use_ID][team_rank_2], FoCo_Teams[team_use_ID][team_rank_3], FoCo_Teams[team_use_ID][team_rank_4], FoCo_Teams[team_use_ID][team_rank_5], FoCo_Teams[team_use_ID][db_id]);
	
	printf("Calling MYSQL_SAVE_TEAMS:: Initial Call :: %s", string);
	mysql_query(string, MYSQL_SAVE_TEAMS, team_use_ID, con);
	return 1;
}

stock FirstLoadClasses(playerid)
{
	new string[200];
	format(string, sizeof(string), "SELECT ID FROM FoCo_Classes WHERE player_id = '%d'", FoCo_Player[playerid][id]);
	mysql_query(string, MYSQL_LOAD_CLASSES, playerid, con);
	return 1;
}

stock updateClasses(playerid, classID, slot, newwep)
{
	new string[200];
	switch(slot)
	{
		case 1:
		{
			format(string, sizeof(string), "UPDATE FoCo_Classes set `melee` = '%d' where ID = '%d'", newwep, classID);
		}
		case 2:
		{
			format(string, sizeof(string), "UPDATE FoCo_Classes set `handguns` = '%d' where ID = '%d'", newwep, classID);
		}
		case 3:
		{
			format(string, sizeof(string), "UPDATE FoCo_Classes set `shotguns` = '%d' where ID = '%d'", newwep, classID);
		}
		case 4:
		{
			format(string, sizeof(string), "UPDATE FoCo_Classes set `submachine` = '%d' where ID = '%d'", newwep, classID);
		}
		case 5:
		{
			format(string, sizeof(string), "UPDATE FoCo_Classes set `assault` = '%d' where ID = '%d'", newwep, classID);
		}
		case 6:
		{
			format(string, sizeof(string), "UPDATE FoCo_Classes set `rifle` = '%d' where ID = '%d'", newwep, classID);
		}
	}
	mysql_query(string, MYSQL_UPDATE_CLASSES, playerid, con);
	return 1;
}

stock LoadTeams()
{
	mysql_store_result();
    new teams[22][80];
	new results[600];
	new string[20];
	new string2[50];
	new teamid;
	while(mysql_fetch_row(results))
	{
		split(results, teams, '|');
  		teamid = strval(teams[0]);
		FoCo_Teams[teamid][db_id] = strval(teams[0]);
		
		format(string2, sizeof(string2), "%s", teams[1]);
		FoCo_Teams[teamid][team_name] = string2;
		
		format(string, sizeof(string), "%s", teams[2]);
		FoCo_Teams[teamid][team_color] = string;
		
		FoCo_Teams[teamid][team_rank_amount] = strval(teams[3]);
		
		format(string, sizeof(string), "%s", teams[4]);
		FoCo_Teams[teamid][team_rank_1] = string;
		format(string, sizeof(string), "%s", teams[5]);
		FoCo_Teams[teamid][team_rank_2] = string;
		format(string, sizeof(string), "%s", teams[6]);
		FoCo_Teams[teamid][team_rank_3] = string;
		format(string, sizeof(string), "%s", teams[7]);
		FoCo_Teams[teamid][team_rank_4] = string;
		format(string, sizeof(string), "%s", teams[8]);
		FoCo_Teams[teamid][team_rank_5] = string;
		
		FoCo_Teams[teamid][team_skin_1] = strval(teams[9]);
		FoCo_Teams[teamid][team_skin_2] = strval(teams[10]);
		FoCo_Teams[teamid][team_skin_3] = strval(teams[11]);
		FoCo_Teams[teamid][team_skin_4] = strval(teams[12]);
		FoCo_Teams[teamid][team_skin_5] = strval(teams[13]);
		
		/*Restricting TeamSkins*/
		if(FoCo_Teams[teamid][team_skin_1] >= 0 && FoCo_Teams[teamid][team_skin_1] <= 311) RestrictedSkin[FoCo_Teams[teamid][team_skin_1]] = true;
		if(FoCo_Teams[teamid][team_skin_2] >= 0 && FoCo_Teams[teamid][team_skin_2] <= 311) RestrictedSkin[FoCo_Teams[teamid][team_skin_2]] = true;
		if(FoCo_Teams[teamid][team_skin_3] >= 0 && FoCo_Teams[teamid][team_skin_3] <= 311) RestrictedSkin[FoCo_Teams[teamid][team_skin_3]] = true;
		if(FoCo_Teams[teamid][team_skin_4] >= 0 && FoCo_Teams[teamid][team_skin_4] <= 311) RestrictedSkin[FoCo_Teams[teamid][team_skin_4]] = true;
		if(FoCo_Teams[teamid][team_skin_5] >= 0 && FoCo_Teams[teamid][team_skin_5] <= 311) RestrictedSkin[FoCo_Teams[teamid][team_skin_5]] = true;

		
		FoCo_Teams[teamid][team_spawn_x] = floatstr(teams[14]);
		FoCo_Teams[teamid][team_spawn_y] = floatstr(teams[15]);
		FoCo_Teams[teamid][team_spawn_z] = floatstr(teams[16]);
		
		FoCo_Teams[teamid][team_spawn_interior] = strval(teams[17]);
		FoCo_Teams[teamid][team_spawn_world] = strval(teams[18]);
		FoCo_Teams[teamid][team_max_members] = strval(teams[19]);
		FoCo_Teams[teamid][team_type] = strval(teams[20]);
		
		Iter_Add(FoCoTeams, teamid);
		
        printf("[DYNAMIC TEAMS:] Team ID: %d, Team Name: %s, Team Color: %d, Team Type: %d", teamid, FoCo_Teams[teamid][team_name], FoCo_Teams[teamid][team_color], FoCo_Teams[teamid][team_type]);
	}
	mysql_free_result();
    return 1;
}

public OnQueryFinish(query[], resultid, extraid, connectionHandle)
{
	ban_OnQueryFinish(query, resultid, extraid, connectionHandle);
	OnQueryFinishNew(query, resultid, extraid, connectionHandle);
	P_OnQueryFinish(query, resultid, extraid, connectionHandle);
	G_OnQueryFinish(query, resultid, extraid, connectionHandle);
	pEar_Stations_OnQueryFinish(query, resultid, extraid, connectionHandle);
	pEar_AdminSec_OnQueryFinish(query, resultid, extraid, connectionHandle);
	LoadRecord_OnQueryFinish(query, resultid, extraid, connectionHandle);
	LoadAlias_OnQueryFinish(query, resultid, extraid, connectionHandle);
	CheckJailEvade_OnQueryFinish(query, resultid, extraid, connectionHandle);
	LoadUACC_OnQueryFinish(query, resultid, extraid, connectionHandle);
	UCP_Update_OnQueryFinish(query, resultid, extraid, connectionHandle);
	ChangePass_OnQueryFinish(query, resultid, extraid, connectionHandle);
    switch(resultid)
	{
		case THREAD_LOAD_CARS: LoadDynamicCars();
		case THREAD_LOAD_PICKUPS: LoadPickups();
		case THREAD_LOAD_TEAMS: return 1;
		case MYSQL_THREAD_ADDRULES: return 1;
		case MYSQL_THREAD_EDITRULE: return 1;
		case MYSQL_THREAD_ADMINRECORD_INSERT: return 1;
		case MYSQL_ACHIUPDATE: return 1;
		case MYSQL_SAVE_PICKUP: return 1;
		case MYSQL_SAVE_TEAMS_3: return 1;
		case MYSQL_THREAD_SELLCAR: return 1;
		case MYSQL_THREAD_SELLCAR_2: return 1;	
		case MYSQL_FUNCTION_MOD: return 1;
		case MYSQL_DEL_CAR: return 1;
		case MYSQL_INSERT_CW: return 1;
		case MYSQL_KEY_UPDATE: return 1;
		case MYSQL_SET_ONLINE_DEFAULT: return 1;
		case MYSQL_INSERT_CLASSES: return 1;
		case MYSQL_UPDATE_CLASSES: return SendClientMessage(extraid, COLOR_NOTICE, "[NOTICE]: Class updated!");
		case THREAD_LOAD_TURFS: TurfSys_LoadGangZones();
		case MYSQL_ADMINACTION: return 1;
		case MYSQL_RESETCLASS: return 1;
		/*
		case MYSQL_UCP_DATAUPDATE: {
			mysql_store_result();
			if(mysql_num_rows() > 0) {
				new resultline[1024];
				new uname[30], passkey[128]; //Failed Logins getting in b/w.
				sscanf(resultline, "p<|>dddddddds[30]s[128]dddddddddddds[80]dddddds[20]ddddddddd",
						FoCo_Player_LogoutCheck[extraid][id], FoCo_Player_LogoutCheck[extraid][level], FoCo_Player_LogoutCheck[extraid][admin], FoCo_Player_LogoutCheck[extraid][cash], FoCo_Player_LogoutCheck[extraid][score],
						FoCo_Player_LogoutCheck[extraid][banned], FoCo_Player_LogoutCheck[extraid][registered], FoCo_Player_LogoutCheck[extraid][skin], uname, passkey,
						FoCo_Player_LogoutCheck[extraid][clan], FoCo_Player_LogoutCheck[extraid][clanrank], FoCo_Player_LogoutCheck[extraid][tester], FoCo_Player_LogoutCheck[extraid][jailed], FoCo_Player_LogoutCheck[extraid][onlinetime], 
						FoCo_Player_LogoutCheck[extraid][admintime], FoCo_Player_LogoutCheck[extraid][reports], FoCo_Player_LogoutCheck[extraid][admin_kicks], FoCo_Player_LogoutCheck[extraid][admin_jails], FoCo_Player_LogoutCheck[extraid][admin_bans],
						FoCo_Player_LogoutCheck[extraid][admin_warns], FoCo_Player_LogoutCheck[extraid][users_carid], FoCo_Player_LogoutCheck[extraid][email], FoCo_Player_LogoutCheck[extraid][warns], FoCo_Player_LogoutCheck[extraid][tempban], 
						FoCo_Player_LogoutCheck[extraid][donation], FoCo_Player_LogoutCheck[extraid][nchanges], FoCo_Player_LogoutCheck[extraid][online], FoCo_Player_LogoutCheck[extraid][public_profile], FoCo_Player_LogoutCheck[extraid][register_date], 
						FoCo_Player_LogoutCheck[extraid][lifetime_donator], FoCo_Player_LogoutCheck[extraid][last_namechange], FoCo_Player_LogoutCheck[extraid][cmt], FoCo_Player_LogoutCheck[extraid][staff_management], FoCo_Player_LogoutCheck[extraid][dev],
						FoCo_Player_LogoutCheck[extraid][duels_won], FoCo_Player_LogoutCheck[extraid][duels_lost], FoCo_Player_LogoutCheck[extraid][duels_total], FoCo_Player_LogoutCheck[extraid][trusted]);
				for(new i; FoCo_Player_Info:i < FoCo_Player_Info; i++) {
					if(FoCo_Player_LoginData[extraid][FoCo_Player_Info:i] != FoCo_Player_LogoutCheck[extraid][FoCo_Player_Info:i]) {
						FoCo_Player[extraid][FoCo_Player_Info:i] = FoCo_Player_LogoutCheck[extraid][FoCo_Player_Info:i];
					}
				}
			} 
			mysql_free_result();
			new query_dataupdate[1024]; */
			/* Doing a separate query for the playerstats as otherwise it would be verrrryyyy long.*/
			/*
			format(query_dataupdate, sizeof(query_dataupdate), "SELECT * FROM `FoCo_Playerstats` WHERE `ID`='%d'", extraid);
			mysql_query(query_dataupdate, MYSQL_UCP_DATAUPDATE2, extraid, con);
			
			return 1;
		}
		case MYSQL_UCP_DATAUPDATE2: {
			mysql_store_result();
			if(mysql_num_rows() > 0) {
				new resultline[1024];
				sscanf(resultline, "p<|>ddddddddddddddddddddddddd",
						FoCo_Playerstats_LogoutCheck[extraid][id], FoCo_Playerstats_LogoutCheck[extraid][headshots], FoCo_Playerstats_LogoutCheck[extraid][deaths], FoCo_Playerstats_LogoutCheck[extraid][kills], FoCo_Playerstats_LogoutCheck[extraid][heli],
						FoCo_Playerstats_LogoutCheck[extraid][streaks], FoCo_Playerstats_LogoutCheck[extraid][suicides], FoCo_Playerstats_LogoutCheck[extraid][helpups], 
						FoCo_Playerstats_LogoutCheck[extraid][deagle], FoCo_Playerstats_LogoutCheck[extraid][m4], FoCo_Playerstats_LogoutCheck[extraid][mp5], FoCo_Playerstats_LogoutCheck[extraid][knife], FoCo_Playerstats_LogoutCheck[extraid][rpg], 
						FoCo_Playerstats_LogoutCheck[extraid][flamethrower], FoCo_Playerstats_LogoutCheck[extraid][chainsaw], FoCo_Playerstats_LogoutCheck[extraid][grenade], FoCo_Playerstats_LogoutCheck[extraid][colt], FoCo_Playerstats_LogoutCheck[extraid][uzi],
						FoCo_Playerstats_LogoutCheck[extraid][combatshotgun], FoCo_Playerstats_LogoutCheck[extraid][smg], FoCo_Playerstats_LogoutCheck[extraid][ak47], FoCo_Playerstats_LogoutCheck[extraid][tec9], FoCo_Playerstats_LogoutCheck[extraid][sniper], 
						FoCo_Playerstats_LogoutCheck[extraid][cpgs_captured], FoCo_Playerstats_LogoutCheck[extraid][assists]);
			}
			for(new i; FoCo_PlayerStats_Info:i < FoCo_PlayerStats_Info; i++) {
				if(FoCo_Playerstats_LoginData[extraid][FoCo_PlayerStats_Info:i] != FoCo_Playerstats_LogoutCheck[extraid][FoCo_PlayerStats_Info:i]) {
					FoCo_Playerstats[extraid][FoCo_PlayerStats_Info:i] = FoCo_Playerstats_LogoutCheck[extraid][FoCo_PlayerStats_Info:i] + (FoCo_Playerstats[extraid][FoCo_PlayerStats_Info:i] - FoCo_Playerstats_LoginData[extraid][FoCo_PlayerStats_Info:i]);
				}
			}

			mysql_free_result();
			DataSave(extraid);
			return 1;
		}
		*/

		#if defined PEAR_SKINS
		case MYSQL_THREAD_RESTRICED_SKINS: 
		{
			mysql_store_result();
			if(mysql_num_rows() > 0)
			{
				new skins[5];
				new skin_amount;
				new ID;
				new resultline[512];
				while(mysql_fetch_row_format(resultline))
				{
					sscanf(resultline, "p<|>ddddddd", ID, skins[0], skins[1], skins[2], skins[3], skins[4], skin_amount);
					for(new i = 0; i < skin_amount; i++) {
						if(skins[i] != 0) {
							restricted_skins[restricted_skins_amount] = skins[i];
							restricted_skins_amount++;
						}
					}
				}
			}
			
			mysql_free_result();
			return 1;
		}
		#endif
        
		case MYSQL_THREAD_MYCAR:
		{
			mysql_store_result();
			new Float:xx, Float:yy, Float:zz, Float:aa, acol1, acol2, amod, aaid, field[128], vehid, string[10], name[25], owner[25], plate[25], spe_mod, playerid = extraid, oid, resultline[300];
			new mc_mods[15];
			if(mysql_fetch_row_format(resultline))
			{
				sscanf(resultline, "p<|>ddffffdds[25]s[25]dda<d>[15]", aaid, amod, xx, yy, zz, aa, acol1, acol2, plate, owner, oid,
				spe_mod, mc_mods);
			}
			
			if(aaid == 0)
			{
				SendClientMessage(extraid, COLOR_WARNING, "Car [ERROR]: Contact an admin: Debug: (Car DB ID set to 0");
				SendClientMessage(extraid, COLOR_WARNING, "Try and /updatekey and see if that will fix the issue.");
				return 1;
			}
			
			GetPlayerPos(playerid, xx, yy, zz);
			GetPlayerFacingAngle(playerid, aa);
			vehid = CreateVehicle(amod, xx, yy, zz, aa, acol1, acol2, 60);

			new pname[MAX_PLAYER_NAME];
			format(pname, sizeof(pname), "%s", PlayerName(playerid));

			FoCo_Vehicles[vehid][cid] = aaid; 
			FoCo_Vehicles[vehid][cmodel] = amod;
			FoCo_Vehicles[vehid][cx] = xx; 
			FoCo_Vehicles[vehid][cy] = yy;
			FoCo_Vehicles[vehid][cz] = zz; 
			FoCo_Vehicles[vehid][cangle] = aa;
			FoCo_Vehicles[vehid][ccol1] = acol1;
			FoCo_Vehicles[vehid][ccol2] = acol2;
			FoCo_Vehicles[vehid][cvw] = 0;
			FoCo_Vehicles[vehid][cint] = 0;
			FoCo_Vehicles[vehid][coname] = pname;
			FoCo_Vehicles[vehid][coid] = FoCo_Player[playerid][id];
			FoCo_Vehicles[vehid][clocked] = 1;
			FoCo_Vehicles[vehid][v_type] = VEHICLE_TYPE_PRIVATE;
			for(new i = 0; i < 15; i++)
			{
			    VehicleModDetails[vehid][i] = mc_mods[i];
			}
					
			format(string, sizeof(string), "%s", plate);
			strmid(FoCo_Vehicles[vehid][cplate], string, 0, sizeof(string), 128);
				
			format(name, sizeof(name), "%s", owner);
			strmid(FoCo_Vehicles[vehid][coname], name, 0, sizeof(name), 128);
			
			FoCo_Vehicles[vehid][coid] = oid;
			
			format(field, sizeof(field), "- Vehicle Owner -\n %s", owner);
			vehicle3Dtext[playerid] = Create3DTextLabel(field, COLOR_YELLOW, 0.0, 0.0, 0.0, 20.0, 0);
			
			LinkVehicleToInterior(vehid,0); 
			SetVehicleVirtualWorld(vehid, 0); 
			SetPlayerVirtualWorld(playerid, 0); 
			
			SetVehicleToRespawn(vehid);
			PutPlayerInVehicle(playerid, vehid, 0);
			SetVehicleParamsEx(vehid, true, true, false, true, false, false, false);
			SetPVarInt(playerid, "VehSpawn", vehid);
			SendClientMessage(playerid, COLOR_NOTICE, "Your vehicle has now been spawned.");
			Attach3DTextLabelToVehicle(vehicle3Dtext[playerid], vehid, 0.0, 0.0, 1.0);
			mysql_free_result();
			return 1;
		}
		case MYSQL_THREAD_SHOWCARS:
		{
		    new resultline[512], string[128];
			mysql_store_result();
			new tmp_db_id, tmp_modelid, tmp_color1, tmp_color2, tmp_plate[25],amount=0;
			while(mysql_fetch_row(resultline))
			{
				new list[512];
		    	sscanf(resultline, "p<|>dddds", tmp_db_id,tmp_modelid,tmp_color1,tmp_color2,tmp_plate);
		    	format(list, sizeof(list), "DB-ID: %d - Modelid: %d - Color 1: %d - Color 2: %d - Plate: %s",tmp_db_id,tmp_modelid,tmp_color1,tmp_color2,tmp_plate);
				SendClientMessage(extraid, COLOR_GREEN, list);
				amount++;
				if(amount == 1)
				{
				    FoCo_Donations[extraid][dcar1] = tmp_db_id;
				}
				else if(amount == 2)
				{
		            FoCo_Donations[extraid][dcar2] = tmp_db_id;
				}
				else if(amount == 3)
				{
				    FoCo_Donations[extraid][dcar2] = tmp_db_id;
				}
			}
			format(string, sizeof(string), "[INFO]: Currently owning %d cars",amount);
			SendClientMessage(extraid, COLOR_YELLOW, string);
			mysql_free_result();
			return 1;
		}
		case MYSQL_LOAD_CLASSES:
		{
			new string[200];
			mysql_store_result();
			if(mysql_num_rows() != 5) 
			{
				mysql_free_result();
				format(string, sizeof(string), "INSERT INTO FoCo_Classes (player_id, melee, handguns, shotguns, submachine, assault, rifle) VALUES ('%d', '4', '24', '0', '0', '0', '0')", FoCo_Player[extraid][id]);
				mysql_query(string, MYSQL_INSERT_CLASSES, extraid, con); // 1st time
				mysql_query(string, MYSQL_INSERT_CLASSES, extraid, con); // 2nd time
				mysql_query(string, MYSQL_INSERT_CLASSES, extraid, con); // 3rd time
				mysql_query(string, MYSQL_INSERT_CLASSES, extraid, con); // 4th time
				mysql_query(string, MYSQL_INSERT_CLASSES, extraid, con); // 5th time
				return 1;
			}
			mysql_free_result();
			return 1;
		}
		case MYSQL_CLAN_CHECK:
		{
			new playerid = extraid, targetid = clanCheck[playerid], string[200];
			mysql_store_result();
	
			if(mysql_num_rows() >= FoCo_Teams[FoCo_Player[playerid][clan]][team_max_members])
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have reached max number members in your clan set by administration.");
				mysql_free_result();
				return 1;
			}
			
			SetPVarInt(targetid, "ClanInvite", FoCo_Player[playerid][clan]);
			new pname[MAX_PLAYER_NAME], tname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, pname, sizeof(pname));
			GetPlayerName(targetid, tname, sizeof(tname));
			format(string, sizeof(string), "[NOTICE]: %s has invited you to join the clan %s, '/accept clan' to join!", pname, FoCo_Teams[FoCo_Player[playerid][clan]][team_name]);
			SendClientMessage(targetid, COLOR_NOTICE, string);
			format(string, sizeof(string), "[NOTICE]: You have invited %s to join your clan.", tname);
			SendClientMessage(playerid, COLOR_NOTICE, string);
			mysql_free_result();
			return 1;
		}
		case MYSQL_THREAD_B_CAR:
		{
			mysql_store_result();
						
			new sqlid[12];
			mysql_fetch_row(sqlid);
			mysql_free_result();
			new i = strval(sqlid)+1;
				
			FoCo_Player[extraid][users_carid] = i;
			new length[250];
			format(length, sizeof(length), "INSERT INTO `FoCo_Player_Vehicles` (`ID`, `model`, `x`, `y`, `z`, `angle`, `col1`, `col2`, `plate`, `oname`, `oid`) VALUES ('%d', '%d', '0.0', '0.0', '5.0', '0.0', '%d', '%d', 'FoCo TDM', '%s', '%d')", i, DialogOptionVar1[extraid], DialogOptionVar2[extraid], carSQLCol[extraid], PlayerName(extraid), FoCo_Player[extraid][id]);
			mysql_query(length, MYSQL_THREAD_INS_B_CAR, extraid, con);
				
			#if defined GuardianProtected
				if(isVIP(extraid) != 2) {
					SetPlayerMoney(extraid, GetPlayerMoney(extraid)-CarPrice(DialogOptionVar1[extraid]));
				}
			#endif
			SendClientMessage(extraid, COLOR_NOTICE, "Your vehicle has been purchased and can be spawned with /mycar");
			if(CarPrice(DialogOptionVar1[extraid]) >= 100000)
			{
			    GiveAchievement(extraid, 88);
			}
			else
			{
			    GiveAchievement(extraid, 87);
			}
			format(length, sizeof(length), "UPDATE `FoCo_Players` SET `carid`='%d' WHERE `ID`='%d'", i, FoCo_Player[extraid][id]); 
			mysql_query(length, MYSQL_THREAD_U_P_CAR, extraid, con);
			TogglePlayerControllable(extraid, 1);
			return 1;
		}
		
		case MYSQL_UNBAN_THREAD:
		{
			mysql_store_result();
			
			new string[256];
			
			if(mysql_num_rows() < 1)
			{
				if(extraid == -1){
					IRC_GroupSay(gEcho, IRC_FOCO_ECHO, "No such name in the database, unable to unban the user.");
				}
				else {
					SendClientMessage(extraid, COLOR_WARNING, "No such name in the database.");
				}
				
			}
			
			else
			{
				mysql_free_result();
				format(string,sizeof(string),"SELECT IP FROM FoCo_Connections WHERE UserID IN(SELECT ID FROM FoCo_Players WHERE username='%s') ORDER BY ID DESC LIMIT 1",DialogOptionVar3[extraid]);
				mysql_query(string, MYSQL_UNBAN_THREAD_2, extraid, con);
			}
			
			return 1;
		}
		
		case MYSQL_UNBAN_THREAD_2: 
		{
			new string[256], ip[36];
			mysql_store_result();
			
			if(mysql_fetch_row_format(string))
			{
				sscanf(string, "s", ip);
			}
			
			mysql_free_result();

			
			format(string,sizeof(string),"AdmCmd(%d): Last known IP: %s was unbanned.", ACMD_UNBAN,ip);
			SendAdminMessage(ACMD_UNBAN,string);
			IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);

			format(string, sizeof(string), "UPDATE `FoCo_Bans` SET `ib_banned`='0' WHERE `ib_ip`='%s' ORDER BY `ib_id` DESC LIMIT 1", ip, ip);
			mysql_query(string, MYSQL_UNBAN_THREAD_3, extraid, con);



			format(string, sizeof(string), "UPDATE `FoCo_Players` SET `banned`='0',`tempban`='0' WHERE `username`='%s'", DialogOptionVar3[extraid]);
			mysql_query(string, MYSQL_UNBAN_THREAD_4, extraid, con);
	
			return 1;	
		}
		/*
		case MYSQL_UNBAN_THREAD:
		{
			mysql_store_result();
			
			new string[256];
			
			if(mysql_num_rows() < 1)
			{
				SendClientMessage(extraid, COLOR_WARNING, "No such name in the database.");
			}
			
			else
			{
				mysql_free_result();
				format(string,sizeof(string),"SELECT IP FROM FoCo_Connections WHERE UserID IN(SELECT ID FROM FoCo_Players WHERE username='%s') ORDER BY ID DESC LIMIT 1",DialogOptionVar3[extraid]);
				//mysql_query(string);
				mysql_query(string, MYSQL_UNBAN_THREAD_2, extraid, con);
			}
			
			return 1;
		}
		
		case MYSQL_UNBAN_THREAD_2: 
		{
			new string[256], ip[36];
			mysql_store_result();
			
			if(mysql_fetch_row_format(string))
			{
				sscanf(string, "s", ip);
			}
			
			mysql_free_result();
			
			format(string,sizeof(string),"AdmCmd(%d): Last known IP: %s was unbanned.", ACMD_UNBAN,ip);
			SendAdminMessage(ACMD_UNBAN,string);
			format(string,sizeof(string),"unbanip %s",ip);
			SendRconCommand(string);
			SendRconCommand("reloadbans");
			format(string, sizeof(string), "UPDATE `FoCo_Players` SET `banned`='0',`tempban`='0' WHERE `username`='%s'", DialogOptionVar3[extraid]);
			mysql_query(string, MYSQL_UNBAN_THREAD_3, extraid, con);
	
			return 1;	
		}
		*/
		
		case MYSQL_UNBAN_THREAD_3: return 1;
		case MYSQL_UNBAN_THREAD_4: return 1;
		
		case MYSQL_THREAD_INS_B_CAR:
		{
			return 1;
		}
		case MYSQL_THREAD_U_P_CAR:
		{
			return 1;
		}
		case MYSQL_THREAD_FIXMYCAR:
		{
			mysql_store_result();
			
			new aaid, car_update[150], resultline[300];
			if(mysql_fetch_row_format(resultline))
			{
				sscanf(resultline, "p<|>d", aaid);
			}
			
			if(aaid == 0)
			{
				return 1;
			}
			
			FoCo_Player[extraid][users_carid] = aaid;
			format(car_update, sizeof(car_update), "UPDATE `FoCo_Players` SET `carid` = '%d' WHERE `ID` = '%d'", aaid, FoCo_Player[extraid][id]);
			mysql_query(car_update, MYSQL_U_CAR, extraid, con);
			mysql_free_result();
			return 1;
		}
		case MYSQL_U_CAR:
		{
			return 1;
		}
		case MYSQL_DEL_TEAM:
		{
			printf("Thread MYSQL_DEL_TEAM called.. value team(%d) Passed.", extraid);
			return 1;
		}
		case MYSQL_CREATE_TEAM_THREAD:
		{
			new playerid = extraid;
			mysql_store_result();
		
			new Float:team_x, Float:team_y, Float:team_z, pname[MAX_PLAYER_NAME], string[256];
			GetPlayerName(playerid, pname, sizeof(pname));
			GetPlayerPos(playerid, team_x, team_y, team_z);
		
			new sqlid[12];
			new size[50];
			mysql_fetch_row(sqlid);
			mysql_free_result();
			new i = strval(sqlid)+1;
				
			if(i >= MAX_TEAMS)
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Contact Shaney,  teams too much");
				return 1;
			}
				
			DialogOptionVar2[playerid] = i;
				
			Iter_Add(FoCoTeams, DialogOptionVar2[playerid] );
			
			FoCo_Teams[DialogOptionVar2[playerid]][db_id] = i;
				
			FoCo_Teams[DialogOptionVar2[playerid]][team_spawn_x] = team_x;
			FoCo_Teams[DialogOptionVar2[playerid]][team_spawn_y] = team_y;
			FoCo_Teams[DialogOptionVar2[playerid]][team_spawn_z] = team_z;
			format(size, sizeof(size), "%s", teamSize[playerid]);
			FoCo_Teams[DialogOptionVar2[playerid]][team_name] = size;
			mysql_real_escape_string(FoCo_Teams[DialogOptionVar2[playerid]][team_name],FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
			FoCo_Teams[DialogOptionVar2[playerid]][team_spawn_interior] = GetPlayerInterior(playerid);
			FoCo_Teams[DialogOptionVar2[playerid]][team_spawn_world] = GetPlayerVirtualWorld(playerid);
				
			format(string, sizeof(string), "INSERT INTO `FoCo_Teams` (`team_name`, `team_spawn_x`, `team_spawn_y`, `team_spawn_z`, `team_spawn_interior`, `team_spawn_world`, `team_type`) VALUES ('%s', '%f', '%f', '%f', '%d', '%d', '2')", 
				FoCo_Teams[DialogOptionVar2[playerid]][team_name], FoCo_Teams[DialogOptionVar2[playerid]][team_spawn_x], FoCo_Teams[DialogOptionVar2[playerid]][team_spawn_y], FoCo_Teams[DialogOptionVar2[playerid]][team_spawn_z], FoCo_Teams[DialogOptionVar2[playerid]][team_spawn_interior], FoCo_Teams[DialogOptionVar2[playerid]][team_spawn_world]);
			mysql_query(string, MYSQL_INS_TEAM, playerid, con);
				
			new size2[20];
			format(size2, sizeof(size2), "Team Member");
				
			FoCo_Teams[DialogOptionVar2[playerid]][team_rank_2] = size2;
			FoCo_Teams[DialogOptionVar2[playerid]][team_rank_3] = size2;
			FoCo_Teams[DialogOptionVar2[playerid]][team_rank_4] = size2;
			FoCo_Teams[DialogOptionVar2[playerid]][team_rank_5] = size2;
			FoCo_Teams[DialogOptionVar2[playerid]][team_skin_2] = 0;
			FoCo_Teams[DialogOptionVar2[playerid]][team_skin_3] = 0;
			FoCo_Teams[DialogOptionVar2[playerid]][team_skin_4] = 0;
			FoCo_Teams[DialogOptionVar2[playerid]][team_skin_5] = 0;
			FoCo_Teams[DialogOptionVar2[playerid]][team_type] = 2;
			format(string, sizeof(string), "AdmCmd(4): %s has begun creating a clan (%s)", pname, FoCo_Teams[DialogOptionVar2[playerid]][team_name]);
			SendAdminMessage(4,string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			ShowPlayerDialog(playerid, DIALOG_CREATETEAM2, DIALOG_STYLE_INPUT, "Team Creation", "Please choose below the HEXADECIMAL colour you wish to use for this clans tag color \n\n ENSURE TO USE A HEX COLOR ELSE IT WILL FUCK THINGS UP! (EXAMPLE: 0xFFFFFF) (NOT: #ffffff)", "Continue", "Close");
			return 1;
		}
		case MYSQL_INS_TEAM:
		{
			printf("Thread MYSQL_INS_TEAM called.. value playerid(%d) was passed", extraid);
			return 1;
		}
		case MYSQL_PICKUP_THREAD:
		{
			printf("Thread MYSQL_PICKUP_THREAD called.. value playerid(%d) was passed", extraid);
			new playerid = extraid;
			mysql_store_result();
						
			new sqlid[12];
			mysql_fetch_row(sqlid);
			mysql_free_result();
			new i = strval(sqlid)+1;
			
			new adname[MAX_PLAYER_NAME], val, Float:PosX, Float: PosY, Float: PosZ, size[150], string[160];
			GetPlayerName(playerid, adname, sizeof(adname));
			GetPlayerPos(playerid, PosX, PosY, PosZ);
			
			val = CreateDynamicPickup(pickupdelID[playerid], pickup_type[playerid], PosX, PosY, PosZ, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, FLOAT_PICKUP_DISTANCE);
			
			FoCo_Pickups[val][LP_IGID] = val;
			FoCo_Pickups[val][LP_pickupid] = pickupdelID[playerid];
			FoCo_Pickups[val][LP_type] = pickup_type[playerid];
			
			FoCo_Pickups[val][LP_x] = PosX;
			FoCo_Pickups[val][LP_y] = PosY;
			FoCo_Pickups[val][LP_z] = PosZ;
			
			FoCo_Pickups[val][LP_Option_one] = pickup_list_var1[playerid];
			FoCo_Pickups[val][LP_Selected_Type] = pickup_list_selection[playerid];
			
			FoCo_Pickups[val][LP_world] = GetPlayerVirtualWorld(playerid);
			FoCo_Pickups[val][LP_interior] = GetPlayerInterior(playerid);
			
			format(size, sizeof(size), "%s", adname);
			FoCo_Pickups[val][LP_addedby] = size;
			format(size, sizeof(size), "%s", DialogOptionVar3[playerid]);
			FoCo_Pickups[val][LP_message] = size;
			FoCo_Pickups[val][LP_DBID] = i;
			
			format(string, sizeof(string), "INSERT INTO `FoCo_Pickups` (`ID`, `pickupid`) VALUES ('%d', '%d')", i, pickupdelID[playerid]);
			mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con); // can use this
			
			format(string, sizeof(string), "AdmCmd(4): %s %s has created pickup ID: %d", GetPlayerStatus(playerid), adname, val);
			SendAdminMessage(4,string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			SavePickups(val);
			return 1;
		}
		case MYSQL_UP_CAR_KEY:
		{	
			printf("Thread MYSQL_UP_CAR_KEY called.. values playerid (%d) has been passed" , extraid);
			return 1;
		}
		case MYSQL_THREAD_SEARCHMYCAR:
		{
			mysql_store_result();
			mysql_retrieve_row();
			
			new aaid, string[128], resultline[300];
			if(mysql_fetch_row_format(resultline))
			{
				sscanf(resultline, "p<|>d", aaid);
			}
			
			format(string, sizeof(string), "NOTICE: That players car ID is %d", aaid);
			SendClientMessage(extraid, COLOR_GREEN, string);
			
			mysql_free_result();
			return 1;
		}
		case MYSQL_SAVE_TEAMS:
		{
			new string[400];
			format(string, sizeof(string), "UPDATE `FoCo_Teams` SET `team_skin_1`='%d', `team_skin_2`='%d', `team_skin_3`='%d', `team_skin_4`='%d', `team_skin_5`='%d', `team_spawn_x`='%f', `team_spawn_y`='%f', `team_spawn_z`='%f' WHERE `ID`='%d'",
				FoCo_Teams[extraid][team_skin_1], FoCo_Teams[extraid][team_skin_2], FoCo_Teams[extraid][team_skin_3], FoCo_Teams[extraid][team_skin_4], FoCo_Teams[extraid][team_skin_5], FoCo_Teams[extraid][team_spawn_x], FoCo_Teams[extraid][team_spawn_y], FoCo_Teams[extraid][team_spawn_z], FoCo_Teams[extraid][db_id]);
			mysql_query(string, MYSQL_SAVE_TEAMS_2, extraid, con);
			return 1;
		}
		case MYSQL_SAVE_TEAMS_2:
		{
			new string2[400];
			format(string2, sizeof(string2), "UPDATE `FoCo_Teams` SET `team_spawn_interior`='%d', `team_spawn_world`='%d', `team_max_members`='%d', `team_type`='%d', `team_name`='%s' WHERE `ID`='%d'",
				FoCo_Teams[extraid][team_spawn_interior], FoCo_Teams[extraid][team_spawn_world], FoCo_Teams[extraid][team_max_members], FoCo_Teams[extraid][team_type], FoCo_Teams[extraid][team_name], FoCo_Teams[extraid][db_id]);
			mysql_query(string2, MYSQL_SAVE_TEAMS_3, extraid, con);
		
			return 1;
		}
		case MYSQL_INS_PSTATS:
		{
			new string[140];
			format(string, sizeof(string), "SELECT * FROM `FoCo_Playerstats` WHERE `ID`='%d'", FoCo_Player[extraid][id]);
			mysql_query(string, MYSQL_LOAD_PLAYER_STATS_INFO, extraid, con);
			return 1;
		}
		case MYSQL_LOAD_PLAYER_STATS_INFO:
		{
			new string[256];
			mysql_store_result();
			if(mysql_num_rows() < 1)
			{
				mysql_free_result();
				format(string, sizeof(string), "INSERT INTO `FoCo_Playerstats` (`ID`) VALUES ('%d')", FoCo_Player[extraid][id]);
				mysql_query(string, MYSQL_INS_PSTATS, extraid, con);
				return 1;
			}
			new resultline[255];
			if(mysql_fetch_row_format(resultline))
			{
			    DebugMsg("sql_pstats setting");
				sscanf(resultline, "p<|>ddddddddddddddddddddddddd",
						FoCo_Playerstats[extraid][id], FoCo_Playerstats[extraid][headshots], FoCo_Playerstats[extraid][deaths], FoCo_Playerstats[extraid][kills], FoCo_Playerstats[extraid][heli],
						FoCo_Playerstats[extraid][streaks], FoCo_Playerstats[extraid][suicides], FoCo_Playerstats[extraid][helpups], 
						FoCo_Playerstats[extraid][deagle], FoCo_Playerstats[extraid][m4], FoCo_Playerstats[extraid][mp5], FoCo_Playerstats[extraid][knife], FoCo_Playerstats[extraid][rpg], 
						FoCo_Playerstats[extraid][flamethrower], FoCo_Playerstats[extraid][chainsaw], FoCo_Playerstats[extraid][grenade], FoCo_Playerstats[extraid][colt], FoCo_Playerstats[extraid][uzi],
						FoCo_Playerstats[extraid][combatshotgun], FoCo_Playerstats[extraid][smg], FoCo_Playerstats[extraid][ak47], FoCo_Playerstats[extraid][tec9], FoCo_Playerstats[extraid][sniper], 
						FoCo_Playerstats[extraid][cpgs_captured], FoCo_Playerstats[extraid][assists]);
				FoCo_Playerstats_LastUCP[extraid] = FoCo_Playerstats[extraid];
			}
			

			SetPlayerScore(extraid, FoCo_Playerstats[extraid][kills]);
			SQL_Loaded[extraid][sql_pstats] = true;
			DebugMsg("sql_pstats loaded");
			mysql_free_result();
			return 1;
		}
		case MYSQL_UPDATE_SINGLE_VEHICLE:
		{
			printf("THREAD: MYSQL_UPDATE_SINGLE_VEHICLE called.. passed params: vid(%d)", extraid);
			return 1;
		}
		case MYSQL_GIVE_CLASS:
		{
			mysql_store_result();
				
			new resultline[255];
			if(mysql_fetch_row_format(resultline))
			{
				new IntArray[23];
				intsplit(resultline, IntArray, '|');
				
				FoCo_Classes[extraid][fc_id] = IntArray[0];
				FoCo_Classes[extraid][fc_player_dbid] = IntArray[1];
				FoCo_Classes[extraid][fc_melee] = IntArray[2];
				FoCo_Classes[extraid][fc_handguns] = IntArray[3];
				FoCo_Classes[extraid][fc_shotguns] = IntArray[4];
				FoCo_Classes[extraid][fc_submachine] = IntArray[5];
				FoCo_Classes[extraid][fc_assault] = IntArray[6];
				FoCo_Classes[extraid][fc_rifle] = IntArray[7];
				GiveGuns(extraid);
			}
			return 1;
		}
		case MYSQL_LOAD_CLASS_STRING:
		{
			mysql_store_result();
			new string[650];
			new classes[8][80];
			new results[600];
			new count = 1;
			
			while(mysql_fetch_row(results))
			{
				split(results, classes, '|');
				if(count == 1) {
					format(string, sizeof(string), "%s%d ) %s, %s, %s, %s, %s, %s", string, strval(classes[0]), WeapNames[strval(classes[2])], WeapNames[strval(classes[3])], WeapNames[strval(classes[4])], WeapNames[strval(classes[5])], WeapNames[strval(classes[6])], WeapNames[strval(classes[7])]);
				} else {
					format(string, sizeof(string), "%s\n%d ) %s, %s, %s, %s, %s, %s", string, strval(classes[0]), WeapNames[strval(classes[2])], WeapNames[strval(classes[3])], WeapNames[strval(classes[4])], WeapNames[strval(classes[5])], WeapNames[strval(classes[6])], WeapNames[strval(classes[7])]);
				}
				count++;
			}
			
			mysql_free_result();
			if(DialogOptionVar1[extraid] == 0) {
				ShowPlayerDialog(extraid, DIALOG_CLASSES, DIALOG_STYLE_LIST, "Choose a class", string, "Select", "Back");
			} else {
				ShowPlayerDialog(extraid, DIALOG_CLASS_EDIT, DIALOG_STYLE_LIST, "Choose a class", string, "Select", "Back");
			}
			return 1;
		}
		case MYSQL_LOAD_ACHIEVEMENTS:
		{
			new sstring[256];
			mysql_store_result();
			if(mysql_num_rows() < 1)
			{
				mysql_free_result();
				format(sstring, sizeof(sstring), "INSERT INTO `FoCo_Achievements` (`ID`) VALUES ('%d')", FoCo_Player[extraid][id]);
				mysql_query(sstring, MYSQL_INSERT_ACHI, extraid, con);
				return 1;
			}
						
			new resultline[255];
			if(mysql_fetch_row_format(resultline))
			{
				new IntArray[AMOUNT_ACHIEVEMENTS+1];
				intsplit(resultline, IntArray, '|');
				for(new i = 0; i < AMOUNT_ACHIEVEMENTS+1; i++)
				{
					FoCo_PlayerAchievements[extraid][i] = IntArray[i];
				}
			}
			SQL_Loaded[extraid][sql_achievements] = true;
			mysql_free_result();
			GiveAchievement(extraid, 1);
			FoCo_Player[extraid][registered] = 1;
			return 1;
		}
		case MYSQL_INSERT_ACHI:
		{
			new sstring[160];
			printf("THREAD: MYSQL_INSERT_ACHI called.. passed params: userid(%d)", extraid);
			format(sstring, sizeof(sstring), "SELECT * FROM `FoCo_Achievements` WHERE `ID`='%d'", FoCo_Player[extraid][id]);
			mysql_query(sstring, MYSQL_LOAD_ACHIEVEMENTS, extraid, con);
			return 1;
		}
		case MYSQL_ONLINE_UPDATE:
		{
			return 1;
		}
	}
	return 1;
}

public OnQueryError(errorid, error[], resultid, extraid, callback[], query[], connectionHandle)
{
	printf("ERROR HAS OCCURED ::  errorid: %d || Error: %s || resultid: %d || extraid : %d || callback: %s || query: %s || connectionHandle: %d", errorid, error, resultid, extraid, callback, query, connectionHandle); 
	switch(errorid)
	{
		case CR_COMMAND_OUT_OF_SYNC:
		{
			printf("Commands out of sync for thread ID: %d",resultid);
		}
		case ER_SYNTAX_ERROR:
		{
			printf("Something is wrong in your syntax, query: %s",query);
		}
	}
	if(resultid == MYSQLTHREAD_GRABALIAS)
	{
	    LAST_ALIAS_CHECK = gettime();
	    SendAdminMessage(1, "[ERROR]: There was some error while fetching the details. If the problem persists, contact Developers.");
	}
	return 1;
}

stock MySQLUpdateVehSingle(table[], vid, field[], sqlupdate)
{
	new sql[256];
	new estring[MAX_PLAYER_NAME];
	mysql_real_escape_string(field, estring);
	format(sql, sizeof(sql), "UPDATE `%s` SET `%s`='%d' WHERE `ID`='%d'", table, estring, sqlupdate, vid);
	mysql_query(sql, MYSQL_UPDATE_SINGLE_VEHICLE, vid, con);
	return 1;
}

public OnPlayerRegister(playerid, password[])
{
    if(IsPlayerConnected(playerid))
	{
		if(!isnull(password))
		{
			if(strlen(password) > 6)
			{
		        new pName[MAX_PLAYER_NAME];
		        format(pName, sizeof(pName), "%s", PlayerName(playerid));
		        new query1[256], pass[256];
		        mysql_real_escape_string(pName,pName);
		        mysql_real_escape_string(password,password);

				WP_Hash(pass, sizeof(pass), password);
				new pword[32];
				format(pword, sizeof(pword), "%s", password);
				passPass[playerid] = pword;

		        format(query1,sizeof(query1),"INSERT INTO `FoCo_Players` (`username`, `password`) VALUES ('%s','%s')",pName,pass);
		        mysql_query(query1, MYSQL_CREATE_PLAYER, playerid, con);
		        return 1;
			}
			else
			{
				return ShowPlayerDialog(playerid,DIALOG_REG,DIALOG_STYLE_INPUT,"Register","Hello, and welcome to FoCo TDM.\n It appears you are unregistered, so please put your password you want below.\n*[ERROR]: Password length can not be less than 6 characters.\nTry again!!!","Register","Cancel");
			}
		}
		else
		{
			return ShowPlayerDialog(playerid,DIALOG_REG,DIALOG_STYLE_INPUT,"Register","Hello, and welcome to FoCo TDM.\n It appears you are unregistered, so please put your password you want below.\n*[ERROR]: Password can not be left blank.\nTry again!!!","Register","Cancel");
		}
    }
    return 0;
}

public OnPlayerLoggin(playerid,password[]) // renamed to "..Loggin" due to y_hooks including a file that already has a OnPlayerLogin
{
	if(FoCo_Player[playerid][online] == 0)
	{
		DebugMsg("Login Attempt");
	    new query[1024];
	    mysql_real_escape_string(PlayerName(playerid),PlayerName(playerid));
	    mysql_real_escape_string(password,password);
	    format(query, sizeof(query), "SELECT `ID`, `username`, `salt` FROM `FoCo_Players` WHERE `username` = '%s' LIMIT 1", PlayerName(playerid));
	    SetPVarString(playerid, "pw", password);
	    mysql_query(query, MYSQL_LOGIN1, playerid, con);
	}
	else
	{
		AKickPlayer(-1, playerid, "Multiple Log-In", 1);
	}
	return 1;
}

forward OnClanInviteQuery(query[], index, extraid, connectionHandle) ;
public OnClanInviteQuery(query[], index, extraid, connectionHandle)
{
	printf("MYSQL THREADED QUERY OnClanInviteQuery Called | QRY: %s, Index: %d, Extraid: %d, ConnHandle: %d", query, index, extraid, connectionHandle);
	mysql_store_result();
	if(mysql_num_rows() >= FoCo_Teams[FoCo_Player[extraid][clan]][team_max_members])
	{
		SendClientMessage(extraid, COLOR_WARNING, "[ERROR]: You have reached max number members in your clan set by administration.");
		mysql_free_result();
		return 1;
	}

	new pname[MAX_PLAYER_NAME], tname[MAX_PLAYER_NAME], string[255];

	SetPVarInt(index, "ClanInvite", FoCo_Player[extraid][clan]);
	GetPlayerName(extraid, pname, sizeof(pname));
	GetPlayerName(index, tname, sizeof(tname));
	format(string, sizeof(string), "[NOTICE]: %s has invited you to join the clan %s, '/clan invitation' to view the invitation!", pname, FoCo_Teams[FoCo_Player[extraid][clan]][team_name]);
	SendClientMessage(index, COLOR_NOTICE, string);
	format(string, sizeof(string), "[NOTICE]: You have invited %s to join your clan.", tname);
	SendClientMessage(extraid, COLOR_NOTICE, string);
	mysql_free_result();
	return 1;
}

forward OnVehicleSpawnQueryAdmin(query[], index, extraid, connectionHandle);
public OnVehicleSpawnQueryAdmin(query[], index, extraid, connectionHandle)
{
	printf("MYSQL THREADED QUERY OnVehicleSpawnQueryAdmin Called | QRY: %s, Index: %d, Extraid: %d, ConnHandle: %d", query, index, extraid, connectionHandle);
	return 1;
}

forward OnCreateVehicleThread(query[], index, extraid, connectionHandle);
public OnCreateVehicleThread(query[], index, extraid, connectionHandle)
{
	printf("MYSQL THREADED QUERY OnCreateVehicleThread Called | QRY: %s, Index: %d, Extraid: %d, ConnHandle: %d", query, index, extraid, connectionHandle);
	mysql_store_result();
	new playerid = index;

	new sqlid[12], vehid = extraid, modelid, col1, col2;
	sscanf(nameThread[playerid], "iii", modelid, col1, col2);
	mysql_fetch_row(sqlid);
	mysql_free_result();
	new i = strval(sqlid)+1;

	new Float:x, Float:y, Float:z, Float:angle, vw, interior, string[256];
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);
	vw = GetPlayerVirtualWorld(playerid);
	interior = GetPlayerInterior(playerid);
	vehid = CreateVehicle(modelid, x, y, z, angle, col1, col2, 120);
	GetVehiclePos(vehid, x, y, z);
	GetVehicleZAngle(vehid, angle);

	LinkVehicleToInterior(vehid, interior);
	SetVehicleVirtualWorld(vehid, vw);
	PutPlayerInVehicle(playerid, vehid, 0);

	FoCo_Vehicles[vehid][cid] = i;
	FoCo_Vehicles[vehid][cmodel] = modelid;
	FoCo_Vehicles[vehid][cx] = x;
	FoCo_Vehicles[vehid][cy] = y;
	FoCo_Vehicles[vehid][cz] = z;
	FoCo_Vehicles[vehid][cangle] = angle;
	FoCo_Vehicles[vehid][ccol1] = col1;
	FoCo_Vehicles[vehid][ccol2] = col2;
	FoCo_Vehicles[vehid][cint] = interior;
	FoCo_Vehicles[vehid][cvw] = vw;
	FoCo_Vehicles[vehid][clocked] = 0;
	FoCo_Vehicles[vehid][v_type] = VEHICLE_TYPE_PUBLIC;

	new stringg[MAX_PLAYER_NAME];
	format(stringg,MAX_PLAYER_NAME,"No-One");
	FoCo_Vehicles[vehid][coname] = stringg;

	FoCo_Vehicles[vehid][coid] = 0;

	format(string, sizeof(string), "INSERT INTO `FoCo_Vehicles` (`model`, `x`, `y`, `z`, `angle`, `col1`, `col2`, `vw`, `interior`) VALUES ('%d', '%f', '%f', '%f', '%f', '%d', '%d', '%d', '%d')", modelid, x, y, z, angle, col1, col2, vw, interior);
	mysql_query(string, MYSQL_KEY_UPDATE, playerid, con);

	format(string, sizeof(string), "AdmCmd(4): %s has spawned a %s", PlayerName(playerid), VehNames[modelid-400][Name]);
	SendAdminMessage(4,string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	return 1;
}

forward OnNameChangeThread(query[], index, extraid, connectionHandle);
public OnNameChangeThread(query[], index, extraid, connectionHandle)
{
	printf("MYSQL THREADED QUERY OnNameChangeThread Called | QRY: %s, Index: %d, Extraid: %d, ConnHandle: %d", query, index, extraid, connectionHandle);
	mysql_store_result();
	if(mysql_num_rows() > 0)
	{
		SendClientMessage(index, COLOR_WARNING, "[ERROR]:  Name already in use, try again with a new one.");
		return 1;
	}
	mysql_free_result();

	new string[255], rname[MAX_PLAYER_NAME], pname[MAX_PLAYER_NAME], newname[MAX_PLAYER_NAME];
	newname = nameThread[index];
	GetPlayerName(extraid, rname, sizeof(rname));
	GetPlayerName(index, pname, sizeof(pname));

	nameThread[index] = rname;
	format(string, sizeof(string), "UPDATE `FoCo_Players` SET `username`='%s' WHERE `ID`='%d'", newname, FoCo_Player[extraid][id]);
	mysql_query(string, MYSQL_THREAD_UPDATE_NAME, index, con);
	format(string, sizeof(string), "INSERT INTO FoCo_NameChanges (UsersID, AdminID, OldName, NewName, Date) VALUES ('%d', '%d', '%s', '%s', '%s')", FoCo_Player[extraid][id], FoCo_Player[index][id], rname, newname, TimeStamp());
	mysql_query(string, MYSQL_THREAD_INSERT_NAMECHANGE, index, con);

	format(string, sizeof(string), "AdmCmd(4): %s %s has changed %s(%d) name to %s", GetPlayerStatus(index), pname, rname, extraid, newname);
	SendAdminMessage(4,string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);

	format(string, sizeof(string), "[NOTICE]: Your name has been changed by %s, we advise you to reconnect with the new name (%s).", pname, newname);
	SendClientMessage(extraid, COLOR_NOTICE, string);
	SetPlayerName(extraid, newname);
	return 1;
}


forward OnPlayerNameChangeThread(query[], index, playerid, connectionHandle);
public OnPlayerNameChangeThread(query[], index, playerid, connectionHandle)
{
	printf("MYSQL THREADED QUERY OnPlayerNameChangeThread Called | QRY: %s, Index: %d, playerid: %d, ConnHandle: %d", query, index, playerid, connectionHandle);
	mysql_store_result();
	if(mysql_num_rows() > 0)
	{
		SendClientMessage(index, COLOR_WARNING, "[ERROR]:  Name already in use, try again with a new one.");
		return 1;
	}
	mysql_free_result();

	new string[255], rname[MAX_PLAYER_NAME], pname[MAX_PLAYER_NAME], newname[MAX_PLAYER_NAME];
	newname = nameThread[index];
	GetPlayerName(playerid, rname, sizeof(rname));
	GetPlayerName(index, pname, sizeof(pname));

	nameThread[index] = rname;
	format(string, sizeof(string), "UPDATE `FoCo_Players` SET `username`='%s' WHERE `ID`='%d'", newname, FoCo_Player[playerid][id]);
	mysql_query(string, MYSQL_THREAD_UPDATE_NAME, index, con);
	format(string, sizeof(string), "INSERT INTO FoCo_NameChanges (UsersID, AdminID, OldName, NewName, Date) VALUES ('%d', '%d', '%s', '%s', '%s')", FoCo_Player[playerid][id], FoCo_Player[index][id], rname, newname, TimeStamp());
	mysql_query(string, MYSQL_THREAD_INSERT_NAMECHANGE, index, con);
	format(string, sizeof(string), "UPDATE 'FoCo_Players' SET 'nchanges'='%d' WHERE 'ID'='%d'", FoCo_Player[playerid][nchanges]--,FoCo_Player[playerid][id]);
	mysql_query(string, MYSQL_THREAD_INSERT_NAMECHANGE, index, con);

	format(string, sizeof(string), "NC: %s(%d) has changed name to %s",rname, playerid, newname);
	SendAdminMessage(4,string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);

	format(string, sizeof(string), "[NOTICE]: Your name has been changed, we advise you to reconnect with the new name (%s).", pname, newname);
	SendClientMessage(playerid, COLOR_NOTICE, string);
	SetPlayerName(playerid, newname);
	return 1;
}

forward OnIRCUnbanThread(query[], index, extraid, connectionHandle);
public OnIRCUnbanThread(query[], index, extraid, connectionHandle)
{
	printf("MYSQL THREADED QUERY OnIRCUnbanThread Called | QRY: %s, Index: %d, Extraid: %d, ConnHandle: %d", query, index, extraid, connectionHandle);
	mysql_store_result();
	new banname[MAX_PLAYER_NAME], reason[50], string[150];
	format(banname, sizeof(banname), "%s", ircActionThread);
	format(reason, sizeof(reason), "%s", ircActionThreadtwo);
	if(mysql_num_rows() < 1)
	{
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, "[BAN SYS]: No such name in the Database, though the IP has been unbanned.");
	}
	else if(mysql_num_rows() > 0)
	{
		mysql_free_result();
		format(string, sizeof(string), "UPDATE `FoCo_Players` SET `banned`='0' WHERE `username`='%s'", banname);
		mysql_query(string, MYSQL_IRC_UNBAN_THREAD, extraid, con);
	}

	format(string, sizeof(string), "unbanip %s", reason);
	SendRconCommand(string);
	SendRconCommand("reloadbans");
	return 1;
}

forward OnQueryFinishNew(query[], resultid, extraid, connectionHandle);
public OnQueryFinishNew(query[], resultid, extraid, connectionHandle)
{
	printf("MYSQL THREADED QUERY OnQueryFinishNow Called | QRY: %s, resultid: %d, Extraid: %d, ConnHandle: %d", query, resultid, extraid, connectionHandle);
	switch(resultid)
	{
		case MYSQL_PLATE_ADMIN_UPDATE: return 1;
		case MYSQL_THREAD_INSERT_NAMECHANGE: return 1;
		case MYSQL_THREAD_DEL_BUGGED_NAME: return 1;
		case MYSQL_IRC_UNBAN_THREAD: return 1;
		case MYSQL_DEATH: return 1;
		case MYSQL_THREAD_UPDATE_NAME:
		{
			new string[175];
			format(string, sizeof(string), "DELETE FROM FoCo_Players WHERE `ID` != '%d' AND `username` = '%s'", FoCo_Player[extraid][id], nameThread[extraid]);
			mysql_query(string, MYSQL_THREAD_DEL_BUGGED_NAME, extraid, con);
			return 1;
		}
	}
	return 1;
}
