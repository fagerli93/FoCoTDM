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
* Filename: pEar_UCP_UpdateData.pwn                                              *
* Author: pEar	                                                                 *
*********************************************************************************/

/*
	Enabled UCP database updates whilst players are in-game.
	#define MYSQL_UCP_DELETE_JOB 117
	#define MYSQL_UCP_UPDATES 118
	#define MYSQL_UCP_DATAUPDATE 119
	#define MYSQL_CHECK_UCP_UPDATE 120 
	#define MYSQL_UCP_PUNISHMENT 121
	====> In defines.pwn
*/

#include <YSI\y_timers>
#include <YSI\y_hooks>


/* Timer called every second to check for UCP updates.*/
task task_UCP[1000]()
{
	new string[156];
	format(string, sizeof(string), "SELECT * FROM `FoCo_UCP_Updates`");
	mysql_query(string, MYSQL_UCP_UPDATES, -1, con);
	return 1;
}

forward UCP_Update_OnQueryFinish(query[], resultid, extraid, connectionHandle);
public UCP_Update_OnQueryFinish(query[], resultid, extraid, connectionHandle) {
	switch(resultid)
	{
		case MYSQL_UCP_DELETE_JOB: return 1;
		case MYSQL_UCP_UPDATES: {
			mysql_store_result();
			if(mysql_num_rows() > 0) {
				DebugMsg("More than 0 UCP updates");
				new resultline[12];
				while(mysql_fetch_row_format(resultline)) {
					DebugMsg("Fetching UCP Update");
					new niggercunt_id, pid;
					sscanf(resultline, "p<|>dd", niggercunt_id, pid);
					new ds[56];
					format(ds, sizeof(ds), "ID: %d, PID: %d", niggercunt_id, pid);
					DebugMsg(ds);
					foreach (Player, i) {
						new dbug[56];
						format(dbug, sizeof(dbug), "Iterating through: %d", i);
						if(FoCo_Player[i][id] == pid) {
							DebugMsg("Found correct");
							UCP_DataUpdate(i);
						}
					}
					new query2[156];
					format(query2, sizeof(query2), "DELETE FROM `FoCo_UCP_Updates` WHERE ID='%d'", niggercunt_id);
					mysql_query(query2, MYSQL_UCP_DELETE_JOB, extraid, con);
				}
			}
			mysql_free_result();
			return 1;
		}
		case MYSQL_UCP_DATAUPDATE: {
			mysql_store_result();
			new dstr[56], string[256];
			format(dstr, sizeof(dstr), "Results and in %d", mysql_num_rows());
			DebugMsg(dstr);
			if(mysql_num_rows() > 0) {
				new resultline[1024];
				while(mysql_fetch_row_format(resultline)) {
					sscanf(resultline, "p<|>dddddddds[30]s[128]dddddddddddds[80]dddddds[20]dddddddddds[64]ddddddddddddddddddddddddd",
						FoCo_Player_UCP[extraid][id], FoCo_Player_UCP[extraid][level], FoCo_Player_UCP[extraid][admin], FoCo_Player_UCP[extraid][cash], FoCo_Player_UCP[extraid][score],
						FoCo_Player_UCP[extraid][banned], FoCo_Player_UCP[extraid][registered], FoCo_Player_UCP[extraid][skin], FoCo_Player_UCP[extraid][username], FoCo_Player_UCP[extraid][user_password],
						FoCo_Player_UCP[extraid][clan], FoCo_Player_UCP[extraid][clanrank], FoCo_Player_UCP[extraid][tester], FoCo_Player_UCP[extraid][jailed], FoCo_Player_UCP[extraid][onlinetime], 
						FoCo_Player_UCP[extraid][admintime], FoCo_Player_UCP[extraid][reports], FoCo_Player_UCP[extraid][admin_kicks], FoCo_Player_UCP[extraid][admin_jails], FoCo_Player_UCP[extraid][admin_bans],
						FoCo_Player_UCP[extraid][admin_warns], FoCo_Player_UCP[extraid][users_carid], FoCo_Player_UCP[extraid][email], FoCo_Player_UCP[extraid][warns], FoCo_Player_UCP[extraid][tempban], 
						FoCo_Player_UCP[extraid][donation], FoCo_Player_UCP[extraid][nchanges], FoCo_Player_UCP[extraid][online], FoCo_Player_UCP[extraid][public_profile], FoCo_Player_UCP[extraid][register_date], 
						FoCo_Player_UCP[extraid][lifetime_donator], FoCo_Player_UCP[extraid][last_namechange], FoCo_Player_UCP[extraid][cmt], FoCo_Player_UCP[extraid][staff_management], FoCo_Player_UCP[extraid][dev],
						FoCo_Player_UCP[extraid][duels_won], FoCo_Player_UCP[extraid][duels_lost], FoCo_Player_UCP[extraid][duels_total], FoCo_Player_UCP[extraid][trusted],
						FoCo_Player_UCP[extraid][failed_logins_ucp], FoCo_Player_UCP[extraid][saltfix], //Added these two cuz these whores were fucking shit up..
						//FoCo_Playerstats_UCP[extraid][id], The ID will come only once when u join them..
						FoCo_Playerstats_UCP[extraid][headshots], FoCo_Playerstats_UCP[extraid][deaths], FoCo_Playerstats_UCP[extraid][kills], FoCo_Playerstats_UCP[extraid][heli],
						FoCo_Playerstats_UCP[extraid][streaks], FoCo_Playerstats_UCP[extraid][suicides], FoCo_Playerstats_UCP[extraid][helpups], 
						FoCo_Playerstats_UCP[extraid][deagle], FoCo_Playerstats_UCP[extraid][m4], FoCo_Playerstats_UCP[extraid][mp5], FoCo_Playerstats_UCP[extraid][knife], FoCo_Playerstats_UCP[extraid][rpg], 
						FoCo_Playerstats_UCP[extraid][flamethrower], FoCo_Playerstats_UCP[extraid][chainsaw], FoCo_Playerstats_UCP[extraid][grenade], FoCo_Playerstats_UCP[extraid][colt], FoCo_Playerstats_UCP[extraid][uzi],
						FoCo_Playerstats_UCP[extraid][combatshotgun], FoCo_Playerstats_UCP[extraid][smg], FoCo_Playerstats_UCP[extraid][ak47], FoCo_Playerstats_UCP[extraid][tec9], FoCo_Playerstats_UCP[extraid][sniper], 
						FoCo_Playerstats_UCP[extraid][cpgs_captured], FoCo_Playerstats_UCP[extraid][assists]);
					FoCo_Playerstats_UCP[extraid][id] = FoCo_Player_UCP[extraid][id];
					if(FoCo_Player[extraid][cash] != FoCo_Player_UCP[extraid][cash] && FoCo_Player_LastUCP[extraid][cash] != FoCo_Player_UCP[extraid][cash]) {
						SetPlayerMoney(extraid, FoCo_Player_UCP[extraid][cash]);
					}
					if(FoCo_Player[extraid][username] != FoCo_Player_UCP[extraid][username] && FoCo_Player_LastUCP[extraid][username] != FoCo_Player_UCP[extraid][username]) {
						format(string, sizeof(string), "[NOTICE]: Your name has been changed by an admin via the UCO, we advise you to reconnect with the new name (%s).", FoCo_Player_UCP[extraid][username]);
						SendClientMessage(extraid, COLOR_NOTICE, string);
						SetPlayerName(extraid, FoCo_Player_UCP[extraid][username]);
					}
					if(FoCo_Player[extraid][cash] != FoCo_Player_UCP[extraid][cash] && FoCo_Player_LastUCP[extraid][cash] != FoCo_Player_UCP[extraid][cash]) {
						SetPlayerMoney(extraid, FoCo_Player_UCP[extraid][cash]);
					}
					if(FoCo_Playerstats[extraid][kills] != FoCo_Playerstats_UCP[extraid][kills] && FoCo_Playerstats_LastUCP[extraid][kills] != FoCo_Playerstats_UCP[extraid][kills]) {
						SetPlayerScore(extraid, FoCo_Playerstats_UCP[extraid][kills]);
					}
					/* Fetch last admin record entry and handle from there.*/
					if((FoCo_Player[extraid][warns] != FoCo_Player_UCP[extraid][warns] && FoCo_Player_LastUCP[extraid][warns] != FoCo_Player_UCP[extraid][warns]) || (FoCo_Player[extraid][jailed] != FoCo_Player_UCP[extraid][jailed] && FoCo_Player_LastUCP[extraid][jailed] != FoCo_Player_UCP[extraid][jailed]))
					{
						new punishment_query[256];
						format(punishment_query, sizeof(punishment_query), "SELECT * FROM FoCo_AdminRecords WHERE user='%d' ORDER BY ID DESC LIMIT 1", FoCo_Player[extraid][id]);
						mysql_query(punishment_query, MYSQL_UCP_PUNISHMENT, extraid, con);
					}
					else if((FoCo_Player[extraid][banned] != FoCo_Player_UCP[extraid][banned] && FoCo_Player_LastUCP[extraid][banned] != FoCo_Player_UCP[extraid][banned]) ||(FoCo_Player[extraid][tempban] != FoCo_Player_UCP[extraid][tempban] && FoCo_Player_LastUCP[extraid][tempban] != FoCo_Player_UCP[extraid][tempban]))
					{
						new punishment_query[256];
						format(punishment_query, sizeof(punishment_query), "SELECT * FROM FoCo_AdminRecords WHERE user='%d' ORDER BY ID DESC LIMIT 1", FoCo_Player[extraid][id]);
						mysql_query(punishment_query, MYSQL_UCP_PUNISHMENT, extraid, con);
					}

				}

				
				new d2[56];
				for(new i; FoCo_Player_Info:i < FoCo_Player_Info; i++) {
					if(FoCo_Player[extraid][FoCo_Player_Info:i] != FoCo_Player_UCP[extraid][FoCo_Player_Info:i] && FoCo_Player_LastUCP[extraid][FoCo_Player_Info:i] != FoCo_Player_UCP[extraid][FoCo_Player_Info:i]) {
						
						format(d2, sizeof(d2), "Different[%d]: Changing from %d -> %d", i, FoCo_Player[extraid][FoCo_Player_Info:i], FoCo_Player_UCP[extraid][FoCo_Player_Info:i]);
						DebugMsg(d2);
						FoCo_Player[extraid][FoCo_Player_Info:i] = FoCo_Player_UCP[extraid][FoCo_Player_Info:i];
					}
					
				}
				
				
				for(new i; FoCo_PlayerStats_Info:i < FoCo_PlayerStats_Info; i++) {
					if(FoCo_Playerstats[extraid][FoCo_PlayerStats_Info:i] != FoCo_Playerstats_UCP[extraid][FoCo_PlayerStats_Info:i] && FoCo_Playerstats_LastUCP[extraid][FoCo_PlayerStats_Info:i] != FoCo_Playerstats_UCP[extraid][FoCo_PlayerStats_Info:i]) {
						format(d2, sizeof(d2), "Different[%d]: Changing from %d -> %d", i, FoCo_Playerstats[extraid][FoCo_PlayerStats_Info:i], FoCo_Playerstats_UCP[extraid][FoCo_PlayerStats_Info:i]);
						DebugMsg(d2);
						FoCo_Playerstats[extraid][FoCo_PlayerStats_Info:i] = FoCo_Playerstats_UCP[extraid][FoCo_PlayerStats_Info:i];
					}
				}
				
			}
			mysql_free_result();
			DataSave(extraid);
			
			return 1;
		}
		case MYSQL_CHECK_UCP_UPDATE: {
			DebugMsg("In MYSQL CHECK UCP UPDATE");
			mysql_store_result();
			new dstr[512];
			format(dstr, sizeof(dstr), "Results: %d", mysql_num_rows());
			DebugMsg(dstr);
			if(mysql_num_rows() > 0) { /* Still data not yet updated by the UCP, update that first before using datasave */
				new resultline[12];
				while(mysql_fetch_row_format(resultline))
				{
					new niggercunt_id, pid;
					sscanf(resultline, "p<|>dd", niggercunt_id, pid);
					new query2[156];
					format(query2, sizeof(query2), "Deleting on logout ID: %d, pid: %d", niggercunt_id, pid);
					DebugMsg(query2);
					format(query2, sizeof(query2), "DELETE FROM `FoCo_UCP_Updates` WHERE ID='%d'", niggercunt_id);
					mysql_query(query2, MYSQL_UCP_DELETE_JOB, extraid, con);
				}

				new fuck_query[156];
				format(fuck_query, sizeof(fuck_query), "Extraid: %d", extraid);
				DebugMsg(fuck_query);
				format(fuck_query, sizeof(fuck_query), "SELECT * FROM `FoCo_Players` NATURAL JOIN `FoCo_Playerstats` WHERE `ID`='%d'", extraid);
				mysql_query(fuck_query, MYSQL_UCP_DATAUPDATE, extraid, con);
			} else { /* No new data, can go straight to saving the data that the player has already */
				DataSave(extraid);
			}
			mysql_free_result();
			return 1;
		}
		case MYSQL_UCP_PUNISHMENT: {
			mysql_store_result();
			if(mysql_num_rows() > 0) {
				new resultline[512];
				if(mysql_fetch_row_format(resultline)) {
					new rid, ruser, radmin[30], rtype, rreason[128], rtime, rdate[20];
					sscanf(resultline, "p<|>dds[30]ds[128]ds[20]", rid, ruser, radmin, rtype, rreason, rtime, rdate);
					new string[512];
					format(string, sizeof(string), "[UCP - %s] - %s", radmin, rreason);
					switch(rtype) {
						case 1: AJailPlayer(-1, extraid, string, rtime/60, 0);  	// Jail
						case 2: AKickPlayer(-1, extraid, string, 0); 			// Kick
						case 3: ABanPlayer(-1, extraid, string, 0); 				// Ban
						case 4: ATempBanPlayer(-1, extraid, string, rtime, 0); 	// Tempban
						case 5: AWarnPlayer(-1, extraid, string, 0);			// Warn
					}
				}
			}

			mysql_free_result();
		}
	}
	return 1;
}

/* Read data that has been updated using the UCP and update the FoCo_Player so that its saved correctly.*/
forward UCP_DataUpdate(playerid);
public UCP_DataUpdate(playerid) {
	DebugMsg("In function UCP DataUpdate");
	new query[256];
	format(query, sizeof(query), "SELECT * FROM `FoCo_Players` NATURAL JOIN `FoCo_Playerstats` WHERE `ID`='%d'", FoCo_Player[playerid][id]);
	DebugMsg(query);
	mysql_query(query, MYSQL_UCP_DATAUPDATE, playerid, con);
	return 1;
}

/* This gets called before the player logs out. */
forward UCP_Check_Update(playerid);
public UCP_Check_Update(playerid) {
	DebugMsg("UCP Check Update on Logout");
	new query[156];
	format(query, sizeof(query), "SELECT * FROM `FoCo_UCP_Updates` WHERE `pid`='%d'", FoCo_Player[playerid][id]);
	mysql_query(query, MYSQL_CHECK_UCP_UPDATE, playerid, con);
	return 1;
}
