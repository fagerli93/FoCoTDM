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
* Filename: irc.pwn                                                              *
* Created by: -                                                                  *
*********************************************************************************/

#if !defined MAIN_INIT
#error "Compiling from wrong script. (foco.pwn)"
#endif

public IRC_OnConnect(botid, ip[], port)
{
	#if !defined PTS
	{
		printf("*** IRC_OnConnect: Bot ID %d connected to %s:%d", botid, ip, port);
		switch(botid)
		{
			case 1: 
			{
				IRC_JoinChannel(botid, IRC_FOCO_MAIN); 
				IRC_AddToGroup(gMain, botid);
			}
			case 2: 
			{
				IRC_JoinChannel(botid, IRC_FOCO_MAIN); 
				IRC_AddToGroup(gMain, botid);
			}
			case 3: 
			{
				IRC_JoinChannel(botid, IRC_FOCO_MAIN); 
				IRC_AddToGroup(gMain, botid);
			}
			case 4: 
			{
				IRC_JoinChannel(botid, IRC_FOCO_ECHO, IRC_FOCO_ECHO_PASS); 
				IRC_AddToGroup(gEcho, botid);
			}
			case 5: 
			{
				IRC_JoinChannel(botid, IRC_FOCO_ECHO, IRC_FOCO_ECHO_PASS); 
				IRC_AddToGroup(gEcho, botid);
			}
			case 6: 
			{
				IRC_JoinChannel(botid, IRC_FOCO_ECHO, IRC_FOCO_ECHO_PASS); 
				IRC_AddToGroup(gEcho, botid);
			}
			case 7: 
			{
				IRC_JoinChannel(botid, IRC_FOCO_LEADS, IRC_FOCO_LEADS_PASS); 
				IRC_AddToGroup(gLeads, botid);
			}
			case 8: 
			{
				IRC_JoinChannel(botid, IRC_FOCO_LEADS, IRC_FOCO_LEADS_PASS); 
				IRC_AddToGroup(gLeads, botid);
			}
			case 9: 
			{
				IRC_JoinChannel(botid, IRC_FOCO_LEADS, IRC_FOCO_LEADS_PASS); 
				IRC_AddToGroup(gLeads, botid);
			}
			case 10:
			{
				IRC_JoinChannel(botid, IRC_FOCO_ADMIN, IRC_FOCO_ADMIN_PASS);
				IRC_AddToGroup(gAdmin, botid);
			}
			case 11:
			{
				IRC_JoinChannel(botid, IRC_FOCO_ADMIN, IRC_FOCO_ADMIN_PASS);
				IRC_AddToGroup(gAdmin, botid);
			}
			case 12:
			{
				IRC_JoinChannel(botid, IRC_FOCO_TRADMIN, IRC_FOCO_TRADMIN_PASS);
				IRC_AddToGroup(gTRAdmin, botid);
			}
			case 13:
			{
				IRC_JoinChannel(botid, IRC_FOCO_TRADMIN, IRC_FOCO_TRADMIN_PASS);
				IRC_AddToGroup(gTRAdmin, botid);
			}
		}
	
	}
	#endif
	
	return 1;
}

public IRC_OnDisconnect(botid, ip[], port, reason[])
{
	printf("*** IRC_OnDisconnect: Bot ID %d disconnected from %s:%d (%s)", botid, ip, port, reason);
	IRC_RemoveFromGroup(gEcho, botid);
	IRC_RemoveFromGroup(gLeads, botid);
	IRC_RemoveFromGroup(gMain, botid);
	IRC_RemoveFromGroup(gAdmin, botid);
	return 1;
}

public IRC_OnConnectAttempt(botid, ip[], port)
{
	printf("*** IRC_OnConnectAttempt: Bot ID %d attempting to connect to %s:%d...", botid, ip, port);
	return 1;
}

public IRC_OnConnectAttemptFail(botid, ip[], port, reason[])
{
	printf("*** IRC_OnConnectAttemptFail: Bot ID %d failed to connect to %s:%d (%s)", botid, ip, port, reason);
	return 1;
}

public IRC_OnJoinChannel(botid, channel[])
{
	printf("*** IRC_OnJoinChannel: Bot ID %d joined channel %s", botid, channel);
	return 1;
}

public IRC_OnLeaveChannel(botid, channel[], message[])
{
	printf("*** IRC_OnLeaveChannel: Bot ID %d left channel %s (%s)", botid, channel, message);
	return 1;
}

public IRC_OnKickedFromChannel(botid, channel[], oppeduser[], oppedhost[], message[])
{
	printf("*** IRC_OnKickedFromChannel: Bot ID %d kicked by %s (%s) from channel %s (%s)", botid, oppeduser, oppedhost, channel, message);
	switch(botid)
	{
			case 1, 2, 3:
			{
				IRC_JoinChannel(botid, IRC_FOCO_MAIN);
				IRC_AddToGroup(gMain, botid);
			}
			/*case 2:
			{
				IRC_JoinChannel(botid, IRC_FOCO_MAIN);
				IRC_AddToGroup(gMain, botid);
			}
			case 3:
			{
				IRC_JoinChannel(botid, IRC_FOCO_MAIN);
				IRC_AddToGroup(gMain, botid);
			}*/
			case 4, 5, 6:
			{
				IRC_JoinChannel(botid, IRC_FOCO_ECHO, IRC_FOCO_ECHO_PASS);
				IRC_AddToGroup(gEcho, botid);
			}
			/*case 5:
			{
				IRC_JoinChannel(botid, IRC_FOCO_ECHO, IRC_FOCO_ECHO_PASS);
				IRC_AddToGroup(gEcho, botid);
			}
			case 6:
			{
				IRC_JoinChannel(botid, IRC_FOCO_ECHO, IRC_FOCO_ECHO_PASS);
				IRC_AddToGroup(gEcho, botid);
			}*/
			case 7, 8, 9:
			{
				IRC_JoinChannel(botid, IRC_FOCO_LEADS, IRC_FOCO_LEADS_PASS);
				IRC_AddToGroup(gLeads, botid);
			}
			/*case 8:
			{
				IRC_JoinChannel(botid, IRC_FOCO_LEADS, IRC_FOCO_LEADS_PASS);
				IRC_AddToGroup(gLeads, botid);
			}
			case 9:
			{
				IRC_JoinChannel(botid, IRC_FOCO_LEADS, IRC_FOCO_LEADS_PASS);
				IRC_AddToGroup(gLeads, botid);
			}*/
			case 10, 11:
			{
				IRC_JoinChannel(botid, IRC_FOCO_ADMIN, IRC_FOCO_ADMIN_PASS);
				IRC_AddToGroup(gAdmin, botid);
			}
			/*case 11:
			{
				IRC_JoinChannel(botid, IRC_FOCO_ADMIN, IRC_FOCO_ADMIN_PASS);
				IRC_AddToGroup(gAdmin, botid);
			}*/
			case 12, 13:
			{
				IRC_JoinChannel(botid, IRC_FOCO_TRADMIN, IRC_FOCO_TRADMIN_PASS);
				IRC_AddToGroup(gTRAdmin, botid);
			}
			/*case 13:
			{
				IRC_JoinChannel(botid, IRC_FOCO_TRADMIN, IRC_FOCO_TRADMIN_PASS);
				IRC_AddToGroup(gTRAdmin, botid);
			}*/
	
	}
	return 1;
}

public IRC_OnUserDisconnect(botid, user[], host[], message[])
{
	return 1;
}

public IRC_OnUserJoinChannel(botid, channel[], user[], host[])
{
	return 1;
}

public IRC_OnUserLeaveChannel(botid, channel[], user[], host[], message[])
{
	return 1;
}

public IRC_OnUserKickedFromChannel(botid, channel[], kickeduser[], oppeduser[], oppedhost[], message[])
{
	return 1;
}

public IRC_OnUserNickChange(botid, oldnick[], newnick[], host[])
{
	return 1;
}

public IRC_OnUserSetChannelMode(botid, channel[], user[], host[], mode[])
{
	return 1;
}

public IRC_OnUserSetChannelTopic(botid, channel[], user[], host[], topic[])
{
	return 1;
}

public IRC_OnUserSay(botid, recipient[], user[], host[], message[])
{
	#if !defined PTS
	{
		if (!strcmp(recipient, BOT_1_NICKNAME))
		{
			IRC_Say(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_2_NICKNAME))
		{
			IRC_Say(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_3_NICKNAME))
		{
			IRC_Say(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_4_NICKNAME))
		{
			IRC_Say(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_5_NICKNAME))
		{
			IRC_Say(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_6_NICKNAME))
		{
			IRC_Say(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_7_NICKNAME))
		{
			IRC_Say(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_8_NICKNAME))
		{
			IRC_Say(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_9_NICKNAME))
		{
			IRC_Say(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_10_NICKNAME))
		{
			IRC_Say(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_11_NICKNAME))
		{
			IRC_Say(botid, user, "I am a bot!");
		}
	}
	#endif
	
	return 1;
}

public IRC_OnUserNotice(botid, recipient[], user[], host[], message[])
{
	#if !defined PTS
	{
		if (!strcmp(recipient, BOT_1_NICKNAME))
		{
			IRC_Notice(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_2_NICKNAME))
		{
			IRC_Notice(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_3_NICKNAME))
		{
			IRC_Notice(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_4_NICKNAME))
		{
			IRC_Notice(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_5_NICKNAME))
		{
			IRC_Notice(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_6_NICKNAME))
		{
			IRC_Notice(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_7_NICKNAME))
		{
			IRC_Notice(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_8_NICKNAME))
		{
			IRC_Notice(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_9_NICKNAME))
		{
			IRC_Notice(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_10_NICKNAME))
		{
			IRC_Say(botid, user, "I am a bot!");
		}
		if (!strcmp(recipient, BOT_11_NICKNAME))
		{
			IRC_Say(botid, user, "I am a bot!");
		}
	}
	#endif
	
	return 1;
}

public IRC_OnUserRequestCTCP(botid, user[], host[], message[])
{
	#if !defined PTS
	{
		printf("*** IRC_OnUserRequestCTCP (Bot ID %d): User %s (%s) sent CTCP request: %s", botid, user, host, message);
		// Someone sent a CTCP VERSION request
		if (!strcmp(message, "VERSION"))
		{
			IRC_ReplyCTCP(botid, user, "VERSION SA-MP IRC Plugin v" #PLUGIN_VERSION "");
		}
	
	}
	#endif
	
	return 1;
}

public IRC_OnUserReplyCTCP(botid, user[], host[], message[])
{
	printf("*** IRC_OnUserReplyCTCP (Bot ID %d): User %s (%s) sent CTCP reply: %s", botid, user, host, message);
	return 1;
}

public IRC_OnReceiveRaw(botid, message[])
{
	return 1;
}

IRCCMD:foco(botid, channel[], user[], host[], params[])
{
	if(FoCo_Spam+5 > GetUnixTime())
	{
		IRC_Notice(botid, user, "[ERROR]: Command already used, wait 5 seconds");
		return 1;
	}
	FoCo_Spam = GetUnixTime();
	new string[150], admins, testers, users, foco_events[56], spree, higheststreak = 0, streakname[MAX_PLAYER_NAME];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(FoCo_Player[i][admin] > 0)
			{
				admins++;
			}
			
			if(FoCo_Player[i][tester] > 0 && FoCo_Player[i][admin] == 0)
			{
				testers++;
			}
			
			if(CurrentKillStreak[i] >= 5)
			{
				spree++;
				if(CurrentKillStreak[i] > higheststreak)
				{
					higheststreak = i;
				}
			}
			
			users++;
		}
	}
	
	if(Event_InProgress == -1)
	{
		format(foco_events, sizeof(foco_events), "No event is running!");
	}
	else
	{
		format(foco_events, sizeof(foco_events), "Event %s is running", event_IRC_Array[Event_ID][eventName]);
	}
	
	GetPlayerName(higheststreak, streakname, sizeof(streakname));
	
	if(!IsPlayerConnected(higheststreak))
	{
		format(streakname, sizeof(streakname), "no-one");
	}
	
	format(string, sizeof(string), "[FoCo-Stats]: %d admins are online  | %d testers are online | %d players online | %s", admins, testers, users, foco_events);
	IRC_GroupSay(gMain, IRC_FOCO_MAIN, string);
	format(string, sizeof(string), "[FoCo-Stats]: %s is on the highest kill spree. | %d people are also on a 5+ kill spree's", streakname, spree);
	IRC_GroupSay(gMain, IRC_FOCO_MAIN, string);
	return 1;
}

IRCCMD:aendround(botid, channel[], user[], host[], params[])
{
	if (IRC_IsOwner(botid, IRC_FOCO_LEADS, user))
	{
		//endroundtimer = 30;
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, "[RESTART]: Game Server Will Restart In 30 Seconds");
		GameTextForAll("~r~ SERVER RESTART IN 30 SECONDS", 1500, 3);
		return 1;
	}
	return 1;
}

IRCCMD:amute(botid, channel[], user[], host[], params[])
{
	if (IRC_IsHalfop(botid, IRC_FOCO_ECHO, user))
	{
		new playerid, time;
		if (sscanf(params, "ud", playerid, time))
		{
			IRC_GroupSay(gEcho, channel, "[USAGE]: !amute [id] [time](-1 for perm)");
			return 1;
		}
		if (IsPlayerConnected(playerid))
		{
			mutePlayer(playerid, -1, time);		}
		else
		{
			IRC_GroupSay(gEcho, channel, "4[ERROR]: Invalid ID.");
		}
	}
	return 1;
}

IRCCMD:aunban(botid, channel[], user[], host[], params[])
{
	if (IRC_IsHalfop(botid, IRC_FOCO_ECHO, user))
	{
		new banname[MAX_PLAYER_NAME];
		if (sscanf(params, "s[24]",banname))
		{
			IRC_GroupSay(gEcho, IRC_FOCO_ECHO, "[USAGE]: !aunban [UserName] (Itll auto unban last IP)");
			return 1;
		}
		new string[256];
        format(string, sizeof(string), "[IRC] AdmCmd(%d): %s has unbanned User: %s", ACMD_UNBAN, user, banname);
		SendAdminMessage(ACMD_UNBAN,string);
		AdminLog(string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, string);
		format(string, sizeof(string), "SELECT * FROM `FoCo_Players` WHERE `username`='%s'", banname);
		mysql_query(string, MYSQL_UNBAN_THREAD, -1, con);
	}
	return 1;
}

IRCCMD:id(botid, channel[], user[], host[], params[])
{
	new targetid, targetname[MAX_PLAYER_NAME], string[128];
	if(sscanf(params, "u", targetid))
	{
		IRC_GroupSay(gMain, channel, "[USAGE]: !id [Player_Name / ID]");
		return 1;
	}
		
	if(IsPlayerConnected(targetid))
	{
		GetPlayerName(targetid, targetname, sizeof(targetname));
		format(string, sizeof(string), "3[Cmd:] Player %s ID is %d", targetname, targetid);
		IRC_GroupSay(gMain, channel, string);
	}
	else
	{
		IRC_GroupSay(gMain, channel, "4[ERROR]: User is not connected.");
	}
	return 1;
}

IRCCMD:getip(botid, channel[], user[], host[], params[])
{
	if (IRC_IsHalfop(botid, IRC_FOCO_ECHO, user))
	{
		new targetid;
		if (sscanf(params, "u", targetid))
		{
			IRC_GroupSay(gEcho, IRC_FOCO_ECHO, "[PARAM:] !getip [id]");
			return 1;
		}

		if(IsPlayerConnected(targetid))
		{
			new string[128], targetname[56], ip[56];
			GetPlayerIp(targetid, ip, sizeof(ip));
			GetPlayerName(targetid, targetname, sizeof(targetname));
			format(string, sizeof(string), "3[AdmCmd:] Player %s's(%d) IP is %s", targetname, targetid, ip);
			IRC_GroupSay(gEcho, channel, string);
		}
		else
		{
			IRC_GroupSay(gEcho, channel, "4[ERROR]: Invalid ID.");
			return 1;
		}
	}
	return 1;
}

IRCCMD:aunmute(botid, channel[], user[], host[], params[])
{
	if (IRC_IsHalfop(botid, IRC_FOCO_ECHO, user))
	{
		new playerid;
		if (sscanf(params, "u", playerid))
		{
			IRC_GroupSay(gEcho, channel, "[PARAM:] !aunmute [id]");
			return 1;
		}
		if (IsPlayerConnected(playerid))
		{
			unmutePlayer(playerid, -2);
		}
		else
		{
			IRC_GroupSay(gEcho, channel, " 4[ERROR] : Invalid ID.");
		}
	}
	return 1;
}

IRCCMD:tradmins(botid, channel[], user[], host[], params[])
{
	if(FoCo_Spam+5 > GetUnixTime())
	{
		IRC_Notice(botid, user, "[ERROR]: Command already used, wait 5 seconds");
		return 1;
	}
	FoCo_Spam = GetUnixTime();
	new string[128], value, playa[MAX_PLAYER_NAME];
	foreach (Player, i)
	{
		if(IsPlayerConnected(i))
		{
			if(FoCo_Player[i][tester] >= 1 && FoCo_Player[i][admin] == 0)
			{
				value++;
				GetPlayerName(i, playa, sizeof(playa));
				format(string, sizeof(string), "%s - %s", string, playa);
			}
		}
	}
	if(value == 0)
	{
		format(string, sizeof(string), "--- There are no ingame Trial Admins --");
	}
	else
	{
		format(string, sizeof(string), " 3[TRIAL-ADMINS IN-GAME]3 %s", string);
	}
		
	if(botid == 1 || botid == 2 || botid == 3) {
		IRC_GroupSay(gMain, channel, string);
	} else {
		IRC_GroupSay(gEcho, channel, string);
	}
	return 1;
}

IRCCMD:admins(botid, channel[], user[], host[], params[])
{
	if(FoCo_Spam+5 > GetUnixTime())
	{
		IRC_Notice(botid, user, "[ERROR]: Command already used, wait 5 seconds");
		return 1;
	}
	FoCo_Spam = GetUnixTime();
	new string[128], value, playa[MAX_PLAYER_NAME];
	foreach (Player, i)
	{
		if(IsPlayerConnected(i))
		{
			if(FoCo_Player[i][admin] > 0 && aUndercover[i] != 1)
			{
				value++;
				GetPlayerName(i, playa, sizeof(playa));
				format(string, sizeof(string), "%s - %s", string, playa);
			}
		}
	}
	if(value == 0)
	{
		format(string, sizeof(string), "--- There are no ingame admins --");
	}
	else
	{
		format(string, sizeof(string), " 3[ADMINS IN-GAME]3 %s", string);
	}
		
	if(botid == 1 || botid == 2 || botid == 3)
	{
		IRC_GroupSay(gMain, channel, string);
	}
	else if(botid == 10 || botid == 11)
	{
		IRC_GroupSay(gAdmin, channel, string);
	}
	else
	{
	    IRC_GroupSay(gEcho, channel, string);
	}
	return 1;
}

IRCCMD:ah(botid, channel[], user[], host[], params[])
{
	if (IRC_IsVoice(botid, IRC_FOCO_ECHO, user))
	{
		new msg[128];
		format(msg, sizeof(msg), "07IRC Help Sys: USAGE:  ! needs to be put infront of each.");
		IRC_GroupSay(gEcho, channel, msg);
		format(msg, sizeof(msg), " 14COMMANDS:3 !getip - !a(un)mute - !akick  -  !aban  -  !ajail");
		IRC_GroupSay(gEcho, channel, msg);
		format(msg, sizeof(msg), " 14COMMANDS:3 !pm - !togpm - !aunban - !endevent - !ann");
		IRC_GroupSay(gEcho, channel, msg);
	}
	return 1;
}

IRCCMD:setadmin(botid, channel[], user[], host[], params[])
{
	if (IRC_IsVoice(botid, IRC_FOCO_LEADS, user))
	{
		new targetid, ulevel;
		if (sscanf(params, "ui", targetid, ulevel))
		{
			IRC_GroupSay(gLeads, channel, "[PARAM:] !setadmin [id] [level]");
			return 1;
		}
		
		if(ulevel > 5)
		{
			IRC_Notice(botid, user, "[ERROR]:  Invalid amount, must be below or equal to 5.");
			return 1;
		}
		new string[156], targetname[56];
		GetPlayerName(targetid, targetname, sizeof(targetname));
		format(string, sizeof(string), "[AdmCMD]: [IRC]%s has made you a %s (Rank %i).", user, AdRankNames[ulevel], ulevel);
		SendClientMessage(targetid, COLOR_NOTICE, string);
		format(string, sizeof(string), "AdmCmd(4): [IRC]%s has made %s a Level %d admin", user, targetname, ulevel);
		SendAdminMessage(4,string);
		AdminLog(string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		FoCo_Player[targetid][admin] = ulevel;
	}
	return 1;
}

IRCCMD:settrialadmin(botid, channel[], user[], host[], params[])
{
	if (IRC_IsVoice(botid, IRC_FOCO_LEADS, user))
	{
		new targetid, ulevel;
		if (sscanf(params, "ui", targetid, ulevel))
		{
			IRC_GroupSay(gLeads, channel, "[PARAM:] !settrialadmin [id] [level]");
			return 1;
		}
		
		if(ulevel > 5)
		{
			IRC_Notice(botid, user, "[ERROR]:  Invalid amount, must be below or equal to 5.");
			return 1;
		}
		new string[156];
		format(string, sizeof(string), "[AdmCMD]: [IRC]%s has made %s a Trial Admin.", user, PlayerName(targetid));
		AdminLog(string);
		SendClientMessage(targetid, COLOR_NOTICE, string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, "Trial Admin has been set for that name..");
		FoCo_Player[targetid][tester] = ulevel;
	}
	return 1;
}

IRCCMD:endevent(botid, channel[], user[], host[], params[]) 
{
	if (IRC_IsVoice(botid, IRC_FOCO_ECHO, user))
	{
		if(Event_InProgress == -1)
		{
			IRC_GroupSay(gLeads, channel, "There is no event to stop --");
			return 1;
		}
		new string[128];
		EndEvent();
		increment = 0;
		format(string, sizeof(string), "[EVENT]: [IRC]%s has stopped the event!", user);
		IRC_GroupSay(gEcho, IRC_FOCO_LEADS, string);
		SendClientMessageToAll(COLOR_NOTICE, string);
		return 1;
	}
	return 1;
}

IRCCMD:ann(botid, channel[], user[], host[], params[]) 
{
	if (IRC_IsVoice(botid, IRC_FOCO_ECHO, user))
	{
		new message[256];
		if (sscanf(params, "s[256]", message))
		{
			IRC_GroupSay(gEcho, channel, "[USAGE]: /ann[ounce] [Message]");
			return 1;
		}
		new string[256], val[128];
		format(string, sizeof(string), "Announcement by [IRC]%s: %s", user, message);
		SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
		AdminLog(string);
		format(val, sizeof(val), "AdmCmd(1): [IRC] %s has announced %s", user, message);
		IRC_GroupSay(gEcho, IRC_FOCO_ECHO, val);
	}
	return 1;
}

IRCCMD:cmds(botid, channel[], user[], host[], params[])
{
	if(FoCo_Spam+5 > GetUnixTime())
	{
		IRC_Notice(botid, user, "[ERROR]: Command already used, wait 5 seconds");
		return 1;
	}
	FoCo_Spam = GetUnixTime();
	
	new msg[128];
	format(msg, sizeof(msg), "COMMANDS: !foco - !players - !admins - !tradmins - !event - !spree - !say - !id");
	IRC_GroupSay(gMain, channel, msg);
	return 1;
}

IRCCMD:say(botid, channel[], user[], host[], params[])
{
	if (IRC_IsVoice(botid, channel, user))
	{
		if (!isnull(params))
		{
			if(FoCo_Spam+5 > GetUnixTime())
			{
				IRC_Notice(botid, user, "[ERROR]: Command already used, wait 5 seconds");
				return 1;
			}
			FoCo_Spam = GetUnixTime();
		
			new msg[128];
			format(msg, sizeof(msg), "3[MSG IG] sent :: (%s on IRC: %s)", user, params);
			if(botid == 1 || botid == 2 || botid == 3) {
				IRC_GroupSay(gMain, channel, msg);
			} else {
				IRC_GroupSay(gEcho, channel, msg);
			}
			format(msg, sizeof(msg), "[IRC] %s: %s", user, params);
			SendClientMessageToAll(COLOR_GLOBALNOTICE, msg);
			ChatLog(msg);
		}
	}
	return 1;
}

IRCCMD:a(botid, channel[], user[], host[], params[])
{
	if (IRC_IsVoice(botid, IRC_FOCO_ADMIN, user))
	{
		if (!isnull(params))
		{
			new msg[128];
			format(msg, sizeof(msg), "3[AChat](%s: %s)", user, params);
			IRC_GroupSay(gAdmin, channel, msg);
			format(msg, sizeof(msg), "[IRC] {%06x}%s:{%06x} %s", COLOR_GREEN >>> 8, user, COLOR_YELLOW >>> 8, params);
			SendAdminMessage(1, msg);
			AdminChatLog(msg);
		}
	}
	return 1;
}

IRCCMD:la(botid, channel[], user[], host[], params[])
{
	if (IRC_IsVoice(botid, IRC_FOCO_LEADS, user))
	{
		if (!isnull(params))
		{
			new msg[128];
			format(msg, sizeof(msg), "3[LEAD MSG IG] sent :: (%s on IRC: %s)", user, params);
			IRC_GroupSay(gLeads, channel, msg);
			format(msg, sizeof(msg), "[IRC-Leads] {%06x}%s:{%06x} %s", COLOR_GREEN >>> 8, user, COLOR_YELLOW >>> 8, params);
			SendAdminMessage(4, msg);
			LeadAdminChatLog(msg);
		}
	}
	return 1;
}

IRCCMD:z(botid, channel[], user[], host[], params[])
{
	if (IRC_IsVoice(botid, IRC_FOCO_TRADMIN, user))
	{
		if (!isnull(params))
		{
			new msg[128];
			format(msg, sizeof(msg), "3[SPRT MSG IG] sent :: (%s on IRC: %s)", user, params);
			IRC_GroupSay(gTRAdmin, channel, msg);
			format(msg, sizeof(msg), "[Trial Admin-IRC] {%06x}%s:{%06x} %s", COLOR_GREEN >>> 8, user, COLOR_YELLOW >>> 8, params);
			TrialAdminChatLog(msg);
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(FoCo_Player[i][tester] > 0)
					{
						SendClientMessage(i, COLOR_RED, msg);
					}
				}
			}
		}
	}
	return 1;
}

IRCCMD:akick(botid, channel[], user[], host[], params[])
{
	if (IRC_IsHalfop(botid, IRC_FOCO_ECHO, user))
	{
		new playerid, reason[64];
		if (sscanf(params, "uS(Reason not specified)[64]", playerid, reason))
		{
			IRC_GroupSay(gEcho, channel, "[USAGE]: !akick [id] [reason]");
			return 1;
		}
		if (IsPlayerConnected(playerid))
		{
		    if(AdminLvl(playerid) >= 5 && !IRC_IsOwner(botid, IRC_FOCO_ECHO, user))
		    {
		        IRC_GroupSay(gEcho, channel, "[ERROR]: You can't kick Level 5/+ without being Owner of Channel");
				return 1;
			}
			else if(AdminLvl(playerid) >= 4 && !IRC_IsAdmin(botid, IRC_FOCO_ECHO, user))
			{
				IRC_GroupSay(gEcho, channel, "[ERROR]: You can't kick Level 4/+ without being Admin of Channel");
		    	return 1;
			}
			else if(AdminLvl(playerid) >= 3 && !IRC_IsAdmin(botid, IRC_FOCO_ECHO, user))
		    {
			    IRC_GroupSay(gEcho, channel, "[ERROR]: You can't kick Level 3/+ without being Admin of Channel");
		    	return 1;
			}
			else if(AdminLvl(playerid) >= 1 && !IRC_IsOp(botid, IRC_FOCO_ECHO, user))
		    {
			    IRC_GroupSay(gEcho, channel, "[ERROR]: You can't kick Level 1/+ without being Operator of Channel");
				return 1;
			}
			new msg[256], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));
			format(msg, sizeof(msg), "4%s has been kicked by %s on IRC. (%s)", name, user, reason);
			IRC_GroupSay(gEcho, channel, msg);
			IRC_GroupSay(gLeads, channel, msg);
			format(msg, sizeof(msg), "[AdmCMD]: %s(IRC) has kicked %s(%d), Reason: %s", user, name, playerid, reason);
			SendClientMessageToAll(COLOR_GLOBALNOTICE, msg);
			AdminLog(msg);
			mysql_real_escape_string(reason, reason);
			format(msg, sizeof(msg), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', '%s', '2', '%s', '%s')", FoCo_Player[playerid][id], user, reason, TimeStamp());
			mysql_query(msg, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
			Kick(playerid);
		}
		else
		{
			IRC_GroupSay(gEcho, channel, "4[ERROR]: Invalid ID.");
		}
	}
	return 1;
}

IRCCMD:aban(botid, channel[], user[], host[], params[])
{
	if (IRC_IsOp(botid, IRC_FOCO_ECHO, user))
	{
		new playerid, reason[64];
		if (sscanf(params, "uS(Reason not specified)[64]", playerid, reason))
		{
			IRC_GroupSay(gEcho, channel, "[USAGE]: !aban [id] [reason]");
			return 1;
		}
		if (IsPlayerConnected(playerid))
		{
		    if(AdminLvl(playerid) >= 5 && !IRC_IsOwner(botid, IRC_FOCO_ECHO, user))
		    {
		        IRC_GroupSay(gEcho, channel, "[ERROR]: You can't ban Level 5/+ without being Owner of Channel");
				return 1;
			}
			else if(AdminLvl(playerid) >= 4 && !IRC_IsAdmin(botid, IRC_FOCO_ECHO, user))
			{
				IRC_GroupSay(gEcho, channel, "[ERROR]: You can't ban Level 4/+ without being Admin of Channel");
		    	return 1;
			}
			else if(AdminLvl(playerid) >= 3 && !IRC_IsAdmin(botid, IRC_FOCO_ECHO, user))
		    {
			    IRC_GroupSay(gEcho, channel, "[ERROR]: You can't ban Level 3/+ without being Admin of Channel");
		    	return 1;
			}
			else if(AdminLvl(playerid) >= 1 && !IRC_IsOp(botid, IRC_FOCO_ECHO, user))
		    {
			    IRC_GroupSay(gEcho, channel, "[ERROR]: You can't ban Level 1/+ without being Operator of Channel");
				return 1;
			}
			new reason2[512];
			format(reason2, sizeof(reason2), "[IRC by %s]: %s", user, reason);
			if(FoCo_Player[playerid][id] == 368 || FoCo_Player[playerid][id] == 28261)
				return 1;
			BanPlayer(-1, playerid, reason2, 1);
		}
		else
		{
			IRC_GroupSay(gEcho, channel, "4[ERROR]: Invalid ID.");
		}
	}
	return 1;
}

IRCCMD:abanip(botid, channel[], user[], host[], params[])
{
	if(IRC_IsOp(botid, IRC_FOCO_ECHO, user)) {
		new IPADD[4], reason[156];
		if(sscanf(params, "p<.>iiiis[128]", IPADD[0], IPADD[1], IPADD[2], IPADD[3], reason))
		{
			IRC_GroupSay(gEcho, channel, "[USAGE]: !abanip [XX.XX.XX.XX] [reason]");
			return 1;
		}
		if(IPADD[0] > 255 || IPADD[1] > 255 || IPADD[2] > 255 || IPADD[3] > 255)
		{
			IRC_GroupSay(gEcho, channel, "[ERROR]: IP's can only go to 255, please try again with a valid IP address.");
			return 1;
		}
		if(strlen(reason) < 5) {
			IRC_GroupSay(gEcho, channel, "[ERROR]: Reason has to be more than 5 characters.");
			return 1;
		}
		new string[256];
		format(string, sizeof(string), "[IRC] AdmCmd(%d): %s has banned IP %d.%d.%d.%d, Reason: %s",ACMD_BANIP, user, IPADD[0], IPADD[1], IPADD[2], IPADD[3], reason);
		SendAdminMessage(ACMD_BANIP,string);
		format(string, sizeof(string), "[IRC] BANIP : %s has banned IP: %d.%d.%d.%d , Reason: %s", user, IPADD[0], IPADD[1], IPADD[2], IPADD[3], reason);
		AdminLog(string);
		mysql_real_escape_string(reason, reason);

		format(string, sizeof(string), "INSERT INTO `FoCo_Bans` (`ib_ip`, `ib_reason`, `ib_admin`) VALUES ('%d.%d.%d.%d', '%s', '%s')", IPADD[0], IPADD[1], IPADD[2], IPADD[3], reason, user);
		mysql_query(string);
	}
	return 1;
}

IRCCMD:aunbanip(botid, channel[], user[], host[], params[])
{
	if(IRC_IsOp(botid, IRC_FOCO_ECHO, user)) {
		new IPADD[4];
		if(sscanf(params, "p<.>iiii", IPADD[0], IPADD[1], IPADD[2], IPADD[3]))
		{
			IRC_GroupSay(gEcho, channel, "[USAGE]: !aunbanip [XX.XX.XX.XX]");
			return 1;
		}
		if(IPADD[0] > 255 || IPADD[1] > 255 || IPADD[2] > 255 || IPADD[3] > 255)
		{
			IRC_GroupSay(gEcho, channel, "[ERROR]: IP's can only go to 255, please try again with a valid IP address.");
			return 1;
		}
		new string[256];
		format(string, sizeof(string), "[IRC] AdmCmd(%d): %s has unbanned IP %d.%d.%d.%d",ACMD_BANIP, user, IPADD[0], IPADD[1], IPADD[2], IPADD[3]);
		SendAdminMessage(ACMD_BANIP,string);
		format(string, sizeof(string), "[IRC] UNBANIP : %s has unbanned IP: %d.%d.%d.%d", user, IPADD[0], IPADD[1], IPADD[2], IPADD[3]);
		AdminLog(string);

		format(string, sizeof(string), "UPDATE `FoCo_Bans` SET `ib_banned`='0', `ib_tempbanned`='0' WHERE `ib_ip`='%d.%d.%d.%d' AND `ib_banned`='1'", IPADD[0], IPADD[1], IPADD[2], IPADD[3]);
		mysql_query(string);
	}
	return 1;
}



IRCCMD:pm(botid, channel[], user[], host[], params[])
{
	if (IRC_IsHalfop(botid, IRC_FOCO_ADMIN, user))
	{
		if(IRC_TOG_PM == 0)
		{
			new giveplayerid, result[256], string[256];
			if (sscanf(params, "us[256]", giveplayerid, result)) 
			{
				IRC_GroupSay(gAdmin, channel, "[USAGE]: !pm [playerid/name] [message]");
			}
			else
			{
				if (IsPlayerConnected(giveplayerid)) 
				{
					if(giveplayerid != INVALID_PLAYER_ID) 
					{
						OnPlayerIRCPrivmsg(user, giveplayerid, result);
						return 1;
					}
				}
				else 
				{
					format(string, sizeof(string), "4[ERROR]: No player with the ID %d is connected.", giveplayerid);
					IRC_GroupSay(gAdmin, channel, string);
					IRC_GroupSay(gEcho, channel, string);
				}
			}
		}
		else
		{
			IRC_GroupSay(gAdmin, channel, "PM's to IRC are togged!");
		}
	}
    return 1;
}

IRCCMD:togpm(botid, channel[], user[], host[], params[])
{
	if (IRC_IsHalfop(botid, IRC_FOCO_ECHO, user))
	{
		if(IRC_TOG_PM == 0)
		{
			IRC_TOG_PM = 1;
			IRC_GroupSay(gEcho, channel, "7[NOTE:] PM's toggled off.");
		}
		else
		{
			IRC_TOG_PM = 0;
			IRC_GroupSay(gEcho, channel, "7[NOTE:] PM's toggled on.");
		}
	}
	return 1;
}

IRCCMD:players(botid, channel[], user[], host[], params[])
{
	if(FoCo_Spam+5 > GetUnixTime())
	{
		IRC_Notice(botid, user, "[ERROR]: Command already used, wait 5 seconds");
		return 1;
	}
	FoCo_Spam = GetUnixTime();
	
	new msg[128], users = 0;
	
	for(new i = 0; i < MAX_PLAYERS; i++) {
		if(IsPlayerConnected(i)) {
			users++;
		}
	}
	
	format(msg, sizeof(msg), "There are %d current players in-game.", users);
	IRC_GroupSay(gMain, channel, msg);
	return 1;
}

IRCCMD:event(botid, channel[], user[], host[], params[])
{
	if(FoCo_Spam+5 > GetUnixTime())
	{
		IRC_Notice(botid, user, "[ERROR]: Command already used, wait 5 seconds");
		return 1;
	}
	FoCo_Spam = GetUnixTime();
	
	new msg[128];
	
	if(Event_InProgress == -1)
	{
		format(msg, sizeof(msg), "There is no current event running.");
	}
	else
	{
		format(msg, sizeof(msg), "Event: %s is currently running.", event_IRC_Array[Event_ID][eventName]);
	}
	IRC_GroupSay(gMain, channel, msg);
	return 1;
}

IRCCMD:spree(botid, channel[], user[], host[], params[])
{
	if(FoCo_Spam+5 > GetUnixTime())
	{
		IRC_Notice(botid, user, "[ERROR]: Command already used, wait 5 seconds");
		return 1;
	}
	FoCo_Spam = GetUnixTime();
		
	new msg[128], spree = 0, higheststreak = 0;
	
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i)) {
			if(CurrentKillStreak[i] >= 5)
			{
				spree++;
				if(CurrentKillStreak[i] > higheststreak)
				{
					higheststreak = i;
				}	
			}
		}
	}
		
	if(spree == 0) 
	{
		format(msg, sizeof(msg), "No one is on a kill spree");
	} 
	else 
	{
		format(msg, sizeof(msg), "%s is on the current highest killstreak (%d kills)", PlayerName(higheststreak), CurrentKillStreak[higheststreak]);
	}
	IRC_GroupSay(gMain, channel, msg);
	return 1;
}
