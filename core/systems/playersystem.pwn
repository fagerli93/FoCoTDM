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
* Filename:  playersystem.pwn                                                    *
* Author:    Marcel                                                              *
*********************************************************************************/

#include <YSI\y_hooks>

forward Saving_PlayerConnect(playerid);
public Saving_PlayerConnect(playerid)
{
	for(new i = 0; i < 40; i++)
	{
		SendClientMessage(playerid, COLOR_CMDNOTICE, " ");
	}

	new joinMsg[128], ips[20];
	GetPlayerIp(playerid, ips, sizeof(ips));
	ipstring[playerid] = ips;
	new	constr[128];
	format(constr, sizeof(constr), "%s has connected. ({%06x}IP: %s{%06x})", PlayerName(playerid), COLOR_GLOBALNOTICE >>> 8, ipstring[playerid], COLOR_SYNTAX >>> 8);

	foreach(new i : Player)
	{
		if(ConLog[i] == 1)
		{
			SendClientMessage(i, COLOR_SYNTAX, constr);
		}
	}
	format(joinMsg, sizeof(joinMsg), "3[CONNECTION]: %d %s joined the server. IP: %s", playerid, PlayerName(playerid), ipstring[playerid]);
	IRC_GroupSay(gEcho, IRC_FOCO_ECHO, joinMsg);
	format(joinMsg, sizeof(joinMsg), "[CONNECTION]: %d %s joined the server. IP: %s", playerid, PlayerName(playerid), ipstring[playerid]);
	ConnectionLog(joinMsg);

    ResetStats(playerid);
    SendClientMessage(playerid,COLOR_RED,"=======================================================");
    SendClientMessage(playerid,COLOR_WHITE,"              Welcome to FoCo TDM!                          ");
	new query[128];
	format(query,sizeof(query),"SELECT * FROM `FoCo_Players` WHERE `username` = '%s' LIMIT 1",PlayerName(playerid));
	mysql_query(query, MYSQL_PCONNECT, playerid, con);
	return 1;
}

forward DataSave(playerid);
public DataSave(playerid)
{
	//UCP_DataUpdate(playerid);
	if(gPlayerLogged[playerid])
	{
        new query[1250];

		format(query,sizeof(query),"UPDATE `FoCo_Players` SET `level`='%d', `admin`='%d', `money`='%d', `score`='%d', `register`='%d', `skin`='%d', `clan`='%d', `clanrank`='%d', `testers`='%d', `onlinetime`='%d', `admintime`='%d', `reports`='%d', `jail`='%d'",
			FoCo_Player[playerid][level], FoCo_Player[playerid][admin], FoCo_Player[playerid][cash], FoCo_Player[playerid][score], FoCo_Player[playerid][registered], FoCo_Player[playerid][skin], FoCo_Player[playerid][clan], FoCo_Player[playerid][clanrank], FoCo_Player[playerid][tester], FoCo_Player[playerid][onlinetime], FoCo_Player[playerid][admintime], FoCo_Player[playerid][reports], FoCo_Player[playerid][jailed]);

		format(query, sizeof(query), "%s, `carid`='%d', `email`='%s', `warns`='%d', `admin_kicks`='%d', `admin_jails`='%d', `admin_bans`='%d', `admin_warns`='%d', `banned`='%d', `tempban`='%d', `donation_id`='%d', `nchanges`='%d', `duels_won`='%d', `duels_lost`='%d', `duels_total`='%d'",
			query, FoCo_Player[playerid][users_carid], FoCo_Player[playerid][email], FoCo_Player[playerid][warns], FoCo_Player[playerid][admin_kicks], FoCo_Player[playerid][admin_jails], FoCo_Player[playerid][admin_bans], FoCo_Player[playerid][admin_warns], FoCo_Player[playerid][banned], FoCo_Player[playerid][tempban],FoCo_Player[playerid][donation],FoCo_Player[playerid][nchanges], FoCo_Player[playerid][duels_won], FoCo_Player[playerid][duels_lost], FoCo_Player[playerid][duels_total]);

		format(query, sizeof(query), "%s, `TrustedMember`='%d' WHERE `ID`='%d'", query, FoCo_Player[playerid][trusted], FoCo_Player[playerid][id]);
		FoCo_Player_LastUCP[playerid] = FoCo_Player[playerid];
		mysql_query(query, MYSQL_PLAYERSAVE, playerid, con);
		return 1;
    }
    return 1;
}

forward SavePlayerStatsInfo(playerid);
public SavePlayerStatsInfo(playerid)
{
    DebugMsg("sql_pstats saving");
	new string[1024];

	format(string, sizeof(string), "UPDATE `FoCo_Playerstats` SET `Deaths`='%d', `Kills`='%d', `Heli`='%d', `Streaks`='%d', `Suicides`='%d', `Helpups`='%d', `Deagle`='%d', `M4`='%d', `MP5`='%d'",
		FoCo_Playerstats[playerid][deaths], FoCo_Playerstats[playerid][kills], FoCo_Playerstats[playerid][heli], FoCo_Playerstats[playerid][streaks], FoCo_Playerstats[playerid][suicides], FoCo_Playerstats[playerid][helpups], FoCo_Playerstats[playerid][deagle], FoCo_Playerstats[playerid][m4], FoCo_Playerstats[playerid][mp5]);

	format(string, sizeof(string), "%s, `Knife`='%d', `RPG`='%d', `Flamethrower`='%d', `Chainsaw`='%d', `Colt`='%d', `Uzi`='%d', `Combatshotgun`='%d'",
		string, FoCo_Playerstats[playerid][knife], FoCo_Playerstats[playerid][rpg], FoCo_Playerstats[playerid][flamethrower], FoCo_Playerstats[playerid][chainsaw], FoCo_Playerstats[playerid][colt], FoCo_Playerstats[playerid][uzi], FoCo_Playerstats[playerid][combatshotgun]);

	format(string, sizeof(string), "%s, `SMG`='%d', `AK47`='%d', `Tec9`='%d', `Sniper`='%d', `cpgs_captured`='%d', `Assistkills` = '%d' WHERE `ID` = '%d'", 
		string, FoCo_Playerstats[playerid][smg], FoCo_Playerstats[playerid][ak47], FoCo_Playerstats[playerid][tec9], FoCo_Playerstats[playerid][sniper], FoCo_Playerstats[playerid][cpgs_captured], FoCo_Playerstats[playerid][assists], FoCo_Player[playerid][id]);
	FoCo_Playerstats_LastUCP[playerid] = FoCo_Playerstats[playerid];
	mysql_query(string, MYSQL_PLAYERSTATSAVE, playerid, con);
	return 1;
}

forward LoadPlayerStatsInfo(playerid);
public LoadPlayerStatsInfo(playerid)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `FoCo_Playerstats` WHERE `ID`='%d'", FoCo_Player[playerid][id]);
	printf("Calling MYSQL_LOAD_PLAYER_STATS_INFO:: Initial Call :: %s", string);
	mysql_query(string, MYSQL_LOAD_PLAYER_STATS_INFO, playerid, con);
	return 1;
}

stock FoCo_Connection(playerid)
{
	new query[200], conntime[32];
	format(conntime, sizeof(conntime), "%s", TimeStamp());
	OnlineConnectionSave[playerid] = conntime;
	// ----
 	format(query, sizeof(query), "UPDATE `FoCo_Players` SET `online` = '1' WHERE `ID` = '%d'", FoCo_Player[playerid][id]);
	mysql_query(query, MYSQL_ONLINE_UPDATE, playerid, con);
	return 1;
}

stock FoCo_Disconnection(playerid)
{
	new query[512], Year, Month, Day;

	format(query, sizeof(query), "UPDATE `FoCo_Players` SET `online` = '0' WHERE `ID` = '%d'", FoCo_Player[playerid][id]);
	mysql_query(query, MYSQL_ONLINE_UPDATE, playerid, con);

	getdate(Year, Month, Day);
	OnlineTimer[playerid] = (GetUnixTime() - OnlineTimer[playerid]) - IgnoreOnline[playerid];

	format(query, sizeof(query), "INSERT INTO FoCo_Connections (UserID, `ip`, timestamp, LogoutTimestamp, TotalSeconds, adutysec, month, `serial`) VALUES ('%d', '%s', '%s', '%s', '%d', '%d', '%d', '%s')", FoCo_Player[playerid][id], ipstring[playerid], OnlineConnectionSave[playerid], TimeStamp(), OnlineTimer[playerid], AdutyTimer[playerid], Month, GetGPCI(playerid));
	mysql_query(query, MYSQL_DISCOUPDATE, playerid, con);
	
	if(GetPVarInt(playerid, "VehSpawn") > 0)
	{
		nullcar(GetPVarInt(playerid, "VehSpawn"));
		Update3DTextLabelText(vehicle3Dtext[playerid], COLOR_WHITE, " ");
		Delete3DTextLabel(vehicle3Dtext[playerid]);
		//vehicle3Dtext[playerid] = -1;
		DestroyVehicle(GetPVarInt(playerid, "VehSpawn"));
	}
	return 1;
}

forward P_OnQueryFinish(query[], resultid, extraid, connectionHandle);
public P_OnQueryFinish(query[], resultid, extraid, connectionHandle)
{
	switch(resultid)
	{
	    case MYSQL_PLAYERSTATSAVE_2: return 1;
		case MYSQL_DISCOUPDATE: return 1;
		case MYSQL_CONNINSERT: return 1;
		case MYSQL_PLAYERSTATSAVE: return 1;
		case MYSQL_PLAYERSAVE: return 1;
		case MYSQL_LOGIN4: return 1; 		// Used for updating passwords when people get new salt
		case MYSQL_PCONNECT:
	    {
	        new playerid = extraid;
	        mysql_store_result();
	        if(mysql_num_rows() > 0)
			{
				mysql_free_result();
	            SendClientMessage(playerid, COLOR_WHITE, "[ It appears that your already registered, type your password to login! ]");
	            ShowPlayerDialog(playerid,DIALOG_LOG,DIALOG_STYLE_PASSWORD,"Login","Enter your password below:","Login","Cancel");
	        }
	        else
			{
				mysql_free_result();
	            SendClientMessage(playerid, COLOR_WHITE, "[ You're not registered, please follow the instructions on the dialog!]");
	            ShowPlayerDialog(playerid,DIALOG_REG,DIALOG_STYLE_INPUT,"Register","Hello, and welcome to FoCo TDM.\n It appears you are unregistered, so please put your password you want below.","Register","Cancel");
	        }

	        SendClientMessage(playerid,COLOR_RED,"=======================================================");
			return 1;
	    }
	    case MYSQL_CREATE_PLAYER:
		{
			printf("THREAD: MYSQL_CREATE_PLAYER called.. passed params: userid(%d)", extraid);
			SendClientMessage(extraid, COLOR_YELLOW2, "Registration successful.");
			OnPlayerLoggin(extraid, passPass[extraid]);
			SetPVarInt(extraid, "just_registered", 1);
			return 1;
		}
		/* Check if user needs a new salt. */
		case MYSQL_LOGIN1: {
			mysql_store_result();
			if(mysql_num_rows() > 0) {
				new resultline[512];
				if(mysql_fetch_row_format(resultline)) {

					new ID, uname[30], salt[128];
					sscanf(resultline, "p<|>ds[30]s[65]", ID, uname, salt);
					/* No salt yet, create a new one.*/
					if(strcmp(salt, "0", true) == 0) {
						new salt_query[256], pass[128];
						GetPVarString(extraid, "pw", pass, sizeof(pass));
						new hash[256];
						WP_Hash(hash, sizeof(hash), pass);
						/* Check that he has the correct password before creating the new salt */
						format(salt_query, sizeof(salt_query), "SELECT `ID` FROM `FoCo_Players` WHERE `username` = '%s' AND `password` = '%s' LIMIT 1", uname, hash);
						mysql_query(salt_query, MYSQL_LOGIN3, extraid, con);
					} else { /* User already has a hash, let's put em together for the full password */
						new salt_query[256], pass[516];
						GetPVarString(extraid, "pw", pass, sizeof(pass));
						strcat(pass, salt);
						FoCo_Player_UCP[extraid][saltfix] = salt;
						new hash[256];
						WP_Hash(hash, sizeof(hash), pass);
					    format(salt_query, sizeof(salt_query), "SELECT * FROM `FoCo_Players` WHERE `username` = '%s' AND `password` = '%s' LIMIT 1",PlayerName(extraid), hash);
					    mysql_query(salt_query, MYSQL_LOGIN2, extraid, con);
					}
					
				}
			} else {
				AKickPlayer(-1, extraid, "Bugged login", 1);
			}

			mysql_free_result();
			return 1;
		}
		/* Default login. */
	    case MYSQL_LOGIN2:
	    {
	       	new playerid = extraid;//, uname[30], passkey[128]; //Failed Logins getting in b/w.
			new money;
			new resultline[1250];

	        mysql_store_result();
	        if(mysql_num_rows() > 0)
			{
				if(mysql_fetch_row_format(resultline))
				{ //39
					sscanf(resultline, "p<|>dddddddds[30]s[128]dddddddddddds[80]dddddds[20]dddddddddds[128]",
						FoCo_Player[playerid][id], FoCo_Player[playerid][level], FoCo_Player[playerid][admin], FoCo_Player[playerid][cash], FoCo_Player[playerid][score],
						FoCo_Player[playerid][banned], FoCo_Player[playerid][registered], FoCo_Player[playerid][skin], FoCo_Player[playerid][username], FoCo_Player[playerid][user_password],
						FoCo_Player[playerid][clan], FoCo_Player[playerid][clanrank], FoCo_Player[playerid][tester], FoCo_Player[playerid][jailed], FoCo_Player[playerid][onlinetime], 
						FoCo_Player[playerid][admintime], FoCo_Player[playerid][reports], FoCo_Player[playerid][admin_kicks], FoCo_Player[playerid][admin_jails], FoCo_Player[playerid][admin_bans],
						FoCo_Player[playerid][admin_warns], FoCo_Player[playerid][users_carid], FoCo_Player[playerid][email], FoCo_Player[playerid][warns], FoCo_Player[playerid][tempban], 
						FoCo_Player[playerid][donation], FoCo_Player[playerid][nchanges], FoCo_Player[playerid][online], FoCo_Player[playerid][public_profile], FoCo_Player[playerid][register_date], 
						FoCo_Player[playerid][lifetime_donator], FoCo_Player[playerid][last_namechange], FoCo_Player[playerid][cmt], FoCo_Player[playerid][staff_management], FoCo_Player[playerid][dev],
						FoCo_Player[playerid][duels_won], FoCo_Player[playerid][duels_lost], FoCo_Player[playerid][duels_total], FoCo_Player[playerid][trusted],
						FoCo_Player[playerid][failed_logins_ucp], FoCo_Player[playerid][saltfix]);
					FoCo_Player_LastUCP[playerid] = FoCo_Player[playerid];
				}
				SQL_Loaded[playerid][sql_data] = true;
                DebugMsg("sql_data loaded");
				money = FoCo_Player[playerid][cash];
				OnlineTimer[playerid] = GetUnixTime();
				mysql_free_result();
				if(FoCo_Player[playerid][banned] != 0)
				{
				    new string[256];
                    SendClientMessage(playerid, COLOR_RED, "You are banned from this server.");
					format(string,sizeof(string), "[Guardian] %s tried logging into his banned account, IP:%s",PlayerName(playerid), ipstring[playerid]);
					SendAdminMessage(1,string);
					new IP[16];
					GetPlayerIp(playerid, IP, sizeof(IP));
					format(string, sizeof(string), "AdmCmd(%d): The Guardian has banned IP: %s for being connected to banned player %s(%d)", ACMD_KICK, IP, PlayerName(playerid), FoCo_Player[playerid][id]);
					SendAdminMessage(1, string);
					AdminLog(string);
					format(string, sizeof(string), "INSERT INTO `FoCo_Bans` (`ib_ip`, `ib_reason`, `ib_admin`) VALUES ('%s', 'Banned account %s(%d) attempted connecting.', 'The Guardian')", IP, PlayerName(playerid), FoCo_Player[playerid][id]);
					mysql_query(string);
					SetTimerEx("KickPlayer", 1000, false, "d", playerid);
				}
				if(FoCo_Player[playerid][tempban]!= 0)
				{
				    if(FoCo_Player[playerid][tempban] > gettime())
				    {
				        SendClientMessage(playerid, COLOR_YELLOW2, "[INFO] You are temporarily banned from this server");
                        SetTimerEx("KickPlayer", 1000, false, "d", playerid);
					}
					else
					{
                        FoCo_Player[playerid][tempban] = 0;
					}
				}
				/* User successfully logged in and not banned. */
				OnPlayerLoginSuccess(playerid);
			}
		    else
			{
				FailedLoginAttempts[playerid]++;
				if(FailedLoginAttempts[playerid] >= MAX_LOGIN_ATTEMPS)
				{
					new string[164];
					SendClientMessage(playerid, COLOR_RED, "You exceeded the maximum amount of login attempts.");
					format(string,sizeof(string), "[Guardian] %s exceeded the maximum login attempts, IP:%s",PlayerName(playerid), ipstring[playerid]);
					SendAdminMessage(1,string);
					AdminLog(string);
					SetTimerEx("KickPlayer", 1000, false, "d", playerid);
					mysql_free_result();
					return 1;
				}
				mysql_free_result();
		        ShowPlayerDialog(playerid,DIALOG_LOG,DIALOG_STYLE_PASSWORD,"Login","Enter your password below:","Login","Cancel");
		    	return 1;
		    }
			mysql_free_result();
	        gPlayerLogged[playerid] = 1;

	        if(FoCo_Player[playerid][registered] == 0)
			{
	            FoCo_Player[playerid][level] = 1;
	            money = 0;
	            FoCo_Player[playerid][skin] = 200;
	            TogglePlayerControllable(playerid,0);
	        }
			#if defined GuardianProtected
				SetPlayerMoney(playerid, money);
			#endif
			FoCo_Player[playerid][online] = 1;
	        SendClientMessage(playerid, COLOR_YELLOW2, "[INFO] Successfully logged in.");
	        if(AdminLvl(playerid) > 0) {
	        	FailedLoginAttempts[playerid] = 0;
				IsPlayerAuthenticated[playerid] = false;
	        	SetPVarInt(playerid, "AdmSec_Auth", ADM_AUTH_LOGIN);
	        	AdminSecurity(playerid);
	        }
	        
	    }
	    /* Login if they are missing a salt and a new has to be created. */
	    case MYSQL_LOGIN3: {
			mysql_store_result();
			// Correct password, create new salt. 
			if(mysql_num_rows() > 0) {
				new resultline[10];
				if(mysql_fetch_row_format(resultline)) {
					new ID, salt[128], salty_query[512], salty_query2[256], pass[512];
					sscanf(resultline, "p<|>d", ID);

					salt = randomString(64);
					GetPVarString(extraid, "pw", pass, sizeof(pass));
					DeletePVar(extraid, "pw");
					strcat(pass, salt);
					FoCo_Player_UCP[extraid][saltfix] = salt;
					new hash[512];
					WP_Hash(hash, sizeof(hash), pass);
					/* Update current salt and password*/
					format(salty_query, sizeof(salty_query), "UPDATE `FoCo_Players` SET `salt`='%s', `password`='%s' WHERE `ID`='%d'", salt, hash, ID);
					mysql_query(salty_query, MYSQL_LOGIN4, extraid, con);
					/* Login with the new password */
					format(salty_query2,sizeof(salty_query2),"SELECT * FROM `FoCo_Players` WHERE `username` = '%s' AND `password` = '%s' LIMIT 1", PlayerName(extraid), hash);
				    mysql_query(salty_query2, MYSQL_LOGIN2, extraid, con);
				    if(GetPVarInt(extraid, "just_registered") != 1) {
				    	SendClientMessage(extraid, COLOR_NOTICE, "Congratulations, your account security was just upgraded! Don't worry though, you don't need to do anything.");
				    	SendClientMessage(extraid, COLOR_NOTICE, "See www.forum.focotdm.com for more details.");
				    	DeletePVar(extraid, "just_registered");
				    }
				    
				}

			} else { /* Default kick if wrong. */
				FailedLoginAttempts[extraid]++;
				if(FailedLoginAttempts[extraid] >= MAX_LOGIN_ATTEMPS)
				{
					new string[164];
					SendClientMessage(extraid, COLOR_RED, "You exceeded the maximum amount of login attempts.");
					format(string,sizeof(string), "[Guardian] %s exceeded the maximum login attempts, IP:%s",PlayerName(extraid), ipstring[extraid]);
					SendAdminMessage(1,string);
					AdminLog(string);
					SetTimerEx("KickPlayer", 1000, false, "d", extraid);
					mysql_free_result();
					return 1;
				}
				mysql_free_result();
		        ShowPlayerDialog(extraid,DIALOG_LOG,DIALOG_STYLE_PASSWORD,"Login","Enter your password below:","Login","Cancel");
		    	return 1;
			}

			mysql_free_result();
		}
	    case MYSQL_THREAD_DONATIONS:
	    {
	        mysql_store_result();
	        new donations[5][32];
	        new results[256];
	        while(mysql_fetch_row(results))
	        {
	            split(results, donations, '|');
				FoCo_Donations[extraid][did] = strval(donations[0]);
				FoCo_Donations[extraid][dpid] = strval(donations[1]);
				FoCo_Donations[extraid][dbuy] = strval(donations[2]);
				FoCo_Donations[extraid][dexp] = strval(donations[3]);
				FoCo_Donations[extraid][dtype] = strval(donations[4]);
			}
			mysql_free_result();
			if(FoCo_Donations[extraid][dexp] < gettime())
			{
			    SendClientMessage(extraid, COLOR_YELLOW, "[INFO] Your donation has expired !");
			    FoCo_Player[extraid][donation] = 0;
			    nullvip(extraid);
			}
		}
	}
	return 1;
}

CMD:stats(playerid, params[])
{
	new string[128];
	format(string, sizeof(string), "|-------------------------------- {%06x}%s(%d){%06x} --------------------------------|", COLOR_WARNING >>> 8, PlayerName(playerid), playerid, COLOR_CMDNOTICE >>> 8);
	SendClientMessage(playerid, COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "|======================|{%06x}GENERAL{%06x}|======================|", COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessage(playerid, COLOR_CMDNOTICE, string);
	if(FoCo_Player[playerid][tester] > 0) {
		format(string, sizeof(string), "Status: %s - Level: %d - Rank: %s  - VIP Rank: %s", GetPlayerStatus(playerid), FoCo_Player[playerid][level], PlayerRankNames[FoCo_Player[playerid][level]], DonationType(playerid));
	} else {
		format(string, sizeof(string), "Status: %s - Trial Admin - Level: %d - Rank: %s  - VIP Rank: %s", GetPlayerStatus(playerid), FoCo_Player[playerid][level], PlayerRankNames[FoCo_Player[playerid][level]], DonationType(playerid));
	}
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Money: $%d - Score: %d - Kills: %d - Deaths: %d - KDR: %02f", GetPlayerMoney(playerid), FoCo_Player[playerid][score], FoCo_Playerstats[playerid][kills], FoCo_Playerstats[playerid][deaths], floatdiv(FoCo_Playerstats[playerid][kills], FoCo_Playerstats[playerid][deaths]));
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Suicides: %d - Longest Streak: %d - Current Streak: %d, Skin: %d, Vehicle ID: %d", FoCo_Playerstats[playerid][suicides], FoCo_Playerstats[playerid][streaks], CurrentKillStreak[playerid], GetPlayerSkin(playerid), GetPVarInt(playerid, "VehSpawn"));
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Clan: %d - Clan Rank: %d", FoCo_Player[playerid][clan], FoCo_Player[playerid][clanrank]);
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "|======================|{%06x}ADMIN RECORD{%06x}|======================|", COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessage(playerid, COLOR_CMDNOTICE, string);
	new tbanned[4], ttempban[4];
	if(FoCo_Player[playerid][banned] == 1) {
		format(tbanned, sizeof(tbanned), "Yes");
	} else {
		format(tbanned, sizeof(tbanned), "No");
	}
	if(FoCo_Player[playerid][tempban] == 1) {
		format(ttempban, sizeof(ttempban), "Yes");
	} else {
		format(ttempban, sizeof(ttempban), "No");
	}
	format(string, sizeof(string), "Jailtime: %d - Warnings: %d - Banned: %s - Tempbanned: %s", FoCo_Player[playerid][jailed], FoCo_Player[playerid][warns], tbanned, ttempban);
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "|======================|{%06x}ONLINE TIME{%06x}|======================|", COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessage(playerid, COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "Online Time: %s", TimerOnline(FoCo_Player[playerid][onlinetime], 0));
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "|======================|{%06x}WEAPONS ETC{%06x}|======================|", COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessage(playerid, COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "Duels Won: %d - Duels Lost: %d - Total Duels: %d", FoCo_Player[playerid][duels_won], FoCo_Player[playerid][duels_lost], (FoCo_Player[playerid][duels_won]+FoCo_Player[playerid][duels_lost]));
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Helicopter: %d - Deagle: %d - M4: %d - MP5: %d - Knife: %d", FoCo_Playerstats[playerid][heli], FoCo_Playerstats[playerid][deagle], FoCo_Playerstats[playerid][m4], FoCo_Playerstats[playerid][mp5], FoCo_Playerstats[playerid][knife]);
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Flamethrower: %d - Chainsaw: %d - Colt: %d", FoCo_Playerstats[playerid][flamethrower], FoCo_Playerstats[playerid][chainsaw], FoCo_Playerstats[playerid][colt]);
	SendClientMessage(playerid, COLOR_NOTICE, string);
	format(string, sizeof(string), "Uzi: %d - Combat Shotgun: %d - AK47: %d - Tec9: %d - Sniper: %d - Carepackages captured: %d", FoCo_Playerstats[playerid][uzi], FoCo_Playerstats[playerid][combatshotgun], FoCo_Playerstats[playerid][ak47], FoCo_Playerstats[playerid][tec9], FoCo_Playerstats[playerid][tec9], FoCo_Playerstats[playerid][cpgs_captured]);
	SendClientMessage(playerid, COLOR_NOTICE, string);

	if(FoCo_Player[playerid][admin] > 0)
	{
		format(string, sizeof(string), "|======================|{%06x}ADMIN{%06x}|======================|", COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		format(string, sizeof(string), "Admin Time: %s - Kicks: %d - Jails: %d - Bans: %d - Warns: %d", TimerOnline(FoCo_Player[playerid][admintime], 1), FoCo_Player[playerid][admin_kicks], FoCo_Player[playerid][admin_jails], FoCo_Player[playerid][admin_bans], FoCo_Player[playerid][admin_warns]);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		new tcmt[4], tstaff_management[4], tdev[56];
		if(FoCo_Player[playerid][cmt] > 0) {
			format(tcmt, sizeof(tcmt), "Yes");
		} else {
			format(tcmt, sizeof(tcmt), "No");
		}
		if(FoCo_Player[playerid][staff_management] > 0) {
			format(tstaff_management, sizeof(tstaff_management), "Yes");
		} else {
			format(tstaff_management, sizeof(tstaff_management), "No");
		}
		switch(FoCo_Player[playerid][dev]) {
			case 1: format(tdev, sizeof(tdev), "3rd Party Developer");
			case 2: format(tdev, sizeof(tdev), "Developer");
			case 3: format(tdev, sizeof(tdev), "Senior Developer");
			case 4: format(tdev, sizeof(tdev), "Lead Developer");
			case 5: format(tdev, sizeof(tdev), "Head of Development");
			default: format(tdev, sizeof(tdev), "No");
		}
		format(string, sizeof(string), "CMT: %s - Staff Management: %s - Developer: %s", tcmt, tstaff_management, tdev);
		SendClientMessage(playerid, COLOR_NOTICE, string);
	}
	SendClientMessage(playerid, COLOR_NOTICE, "|------------------------------------------------------------------------|");
	return 1;
}
    
