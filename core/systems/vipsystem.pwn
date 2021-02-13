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
* Filename:  vipsystem.pwn                                                       *
* Author:    Marcel / pEar                                                       *
*********************************************************************************/
/*

Commands not included:
- /buycar (General command, no point putting it in here)
- /skinmod (RakGuy has a file of its own for that)
- /editmod (RakGuy has a file of its own for that)
- /placemod (RakGuy has a file of its own for that)
- /duel (3v3) (Chilco has a file of its own for that)
*/



/* Bronze donator commands */

#define DONATOR_CLAN 10

CMD:joindonatorclan(playerid, params[])
{
	switch(isVIP(playerid))
	{
		case 0: return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not a donator!");
		case 1:
		{
			FoCo_Team[playerid] = DONATOR_CLAN;
			FoCo_Player[playerid][clan] = DONATOR_CLAN;
			FoCo_Player[playerid][clanrank] = 4;
		}
		case 2:
		{
			FoCo_Team[playerid] = DONATOR_CLAN;
			FoCo_Player[playerid][clan] = DONATOR_CLAN;
			FoCo_Player[playerid][clanrank] = 3;
		}
		case 3:
		{
			FoCo_Team[playerid] = DONATOR_CLAN;
			FoCo_Player[playerid][clan] = DONATOR_CLAN;
			FoCo_Player[playerid][clanrank] = 2;
		}
	}
	SetPlayerHealth(playerid, 0);
	return SendClientMessage(playerid, COLOR_GREEN, "[INFO]: You have joined the donators clan!");
}
CMD:donators(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GREEN, "|--------------ONLINE DONATORS--------------|");
	new string[128], status[35], colour[10];
	new count = 0;
	foreach(Player, i)
	{
	    if(isVIP(i) > 0)
	    {
	        switch(isVIP(i))
	        {
	            case 1:
				{
					status = "Bronze Donator";
					colour = "CD7F32";
				}
	            case 2:
				{
				    status = "Silver Donator";
				    colour = "CCCCCC";
				}
	            case 3:
				{
					status = "Gold Donator";
					colour = "DAA520";
				} 
	        }
	        format(string, sizeof(string), "%s(%d) {%s}[%s]", PlayerName(i), i, colour, status);
	        SendClientMessage(playerid, COLOR_WHITE, string);
	        count++;
	    }
	}
	if(count == 0)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "       There are no online donators!");
	}                                       
	SendClientMessage(playerid, COLOR_GREEN,     "|-------------------------------------------|");
	return 1;
}

CMD:vip(playerid, params[])
{
	cmd_donators(playerid, params);
	return 1;
}

CMD:vips(playerid, params[])
{
	cmd_donators(playerid, params);
	return 1;
}

stock SendDonatorChat(string[])
{

	foreach(Player, i)
	{
		if(isVIP(i) >= 1 || AdminLvl(i) >= ACMD_BRONZE)
		{
			SendClientMessage(i, COLOR_GREEN, string);
		}
	}
	return 1;
}

CMD:dc(playerid, params[])
{
	if(isVIP(playerid) >= 1 || AdminLvl(playerid) >= ACMD_BRONZE)
	{
 		new string[128], message[128];
		if(sscanf(params, "s[128]", message))
		{
			format(string, sizeof(string), "[USAGE]: {%06x}/dc {%06x}[Message]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			return 1;
		}
		if(strlen(message) > 60)
		{
			new message2[300];
	 		strmid(message2,message,55,strlen(message),sizeof(message2));
			strmid(message,message,0,55,sizeof(message));
			format(string, sizeof(string), "[Donator Chat]: {%06x}%s %s:{%06x} %s", COLOR_NOTICE >>> 8, GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WHITE >>> 8, message);
        	SendDonatorChat(string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
			format(string, sizeof(string), "..{%06x} %s", COLOR_WHITE >>> 8, message2);
        	SendDonatorChat(string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		}
		else
		{
			format(string, sizeof(string), "[Donator Chat]: {%06x}%s %s:{%06x} %s", COLOR_NOTICE >>> 8, GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WHITE >>> 8, message);
        	SendDonatorChat(string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		}
		return 1;
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "You need to be a donator to use this command.");
		return 1;
	}
}

CMD:dh(playerid, params[])
{
	new string[256];
	if(isVIP(playerid) >= 1 || AdminLvl(playerid) >= ACMD_BRONZE)
	{
		format(string, sizeof(string), "[Bronze Donator]: {%06x}/dc - /buycar - /joindonatorclan", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	if(isVIP(playerid) >= 2 || AdminLvl(playerid) >= ACMD_SILVER)
	{
		format(string, sizeof(string), "[Silver Donator]: {%06x}/blockallpm - /togchat - /fighstyle - /switchcar - /showcars", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string), "[Silver Donator]: {%06x}/skinmod - /placemod - /editmod - /skin(reset)", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	if(isVIP(playerid) == 3 || AdminLvl(playerid) >= ACMD_GOLD)
	{
		format(string, sizeof(string), "[Gold Donator]: {%06x}/sd (skydive) - /vann - /duel (3vs3) - /nos - /neon", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	else if(isVIP(playerid) <= 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be a donator to use this command.");
		return 1;
	}
	return 1;
}

CMD:dhelp(playerid, params[])
{
	cmd_dh(playerid, params);
	return 1;
}

CMD:donatorhelp(playerid, params[])
{
	cmd_dh(playerid, params);
	return 1;
}

CMD:mydonation(playerid, params[])
{
	new string[512];
 	new buytimeHours, buytimeMinutes, buytimeSeconds, buytimeYear, buytimeMonth, buytimeDay;
 	new exptimeHours, exptimeMinutes, exptimeSeconds, exptimeYear, exptimeMonth, exptimeDay;
	gettime(buytimeHours, buytimeMinutes, buytimeSeconds);
	getdate(buytimeYear, buytimeMonth, buytimeDay);
	gettime(exptimeHours, exptimeMinutes, exptimeSeconds);
	getdate(exptimeYear, exptimeMonth, buytimeDay);
	format(string, sizeof(string), "Buy: %d, Exp: %d", FoCo_Donations[playerid][dbuy], FoCo_Donations[playerid][dexp]);
	//DebugMsg(string);
	TimestampToDate(FoCo_Donations[playerid][dbuy], buytimeYear, buytimeMonth, buytimeDay, buytimeHours, buytimeMinutes, buytimeSeconds, 2, 0);
	TimestampToDate(FoCo_Donations[playerid][dexp], exptimeYear, exptimeMonth, exptimeDay, exptimeHours, exptimeMinutes, exptimeSeconds, 2, 0);
	format(string, sizeof(string), "Donation Status \n Donation ID: %d \n pid: %d \n bought: %02d/%02d/%02d %02d:%02d:%02d \n expire: %02d/%02d/%02d %02d:%02d:%02d \n type: %d \n nchanges: %d",FoCo_Donations[playerid][did],FoCo_Donations[playerid][dpid], buytimeDay, buytimeMonth, buytimeYear, buytimeHours, buytimeMinutes, buytimeSeconds, exptimeDay, exptimeMonth, exptimeYear, exptimeHours, exptimeMinutes, exptimeSeconds, FoCo_Donations[playerid][dtype],FoCo_Player[playerid][nchanges]);
	ShowPlayerDialog(playerid, DIALOG_DONATORSTATUS, DIALOG_STYLE_MSGBOX, "Donation Information",string,"Ok","");
	return 1;
}

CMD:myvip(playerid, params[])
{
	cmd_mydonation(playerid, params);
	return 1;
}

CMD:donation(playerid, params[])
{
	if (IsAdmin(playerid, ACMD_DONATIONINFO))
	{
	    new targetid;
		if(sscanf(params, "u", targetid))
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /donationinfo [ID]");
		    return 1;
		}
		new string[512], string2[50];
	 	new buytimeHours, buytimeMinutes, buytimeSeconds, buytimeYear, buytimeMonth, buytimeDay;
	 	new exptimeHours, exptimeMinutes, exptimeSeconds, exptimeYear, exptimeMonth, exptimeDay;
		gettime(buytimeHours, buytimeMinutes, buytimeSeconds);
		getdate(buytimeYear, buytimeMonth, buytimeDay);
		gettime(exptimeHours, exptimeMinutes, exptimeSeconds);
		getdate(exptimeYear, exptimeMonth, buytimeDay);
		switch(FoCo_Donations[targetid][dtype])
		{
		    case 0: format(string2, sizeof(string2), "NONE");
		    case 1: format(string2, sizeof(string2), "Bronze");
		    case 2: format(string2, sizeof(string2), "Silver");
		    case 3: format(string2, sizeof(string2), "Gold");
		}
		TimestampToDate(FoCo_Donations[targetid][dbuy], buytimeYear, buytimeMonth, buytimeDay, buytimeHours, buytimeMinutes, buytimeSeconds, 2, 0);
		TimestampToDate(FoCo_Donations[targetid][dexp], exptimeYear, exptimeMonth, exptimeDay, exptimeHours, exptimeMinutes, exptimeSeconds, 2, 0);
		format(string, sizeof(string), "Donation Status \n Donation ID: %d \n Player ID: %d \n Bought: %02d/%02d/%02d %02d:%02d:%02d \n Expire: %02d/%02d/%02d %02d:%02d:%02d \n Type: %s \n Name-changes: %d",FoCo_Donations[targetid][did],FoCo_Donations[targetid][dpid], buytimeDay, buytimeMonth, buytimeYear, buytimeHours, buytimeMinutes, buytimeSeconds, exptimeDay, exptimeMonth, exptimeYear, exptimeHours, exptimeMinutes, exptimeSeconds, string2, FoCo_Player[targetid][nchanges]);
		ShowPlayerDialog(playerid, DIALOG_DONATORSTATUS, DIALOG_STYLE_MSGBOX, "Donation Information",string,"OK","");
		return 1;
	}
	return 1;
}

CMD:donationunix(playerid, params[])
{
	new string1[128];
	format(string1, sizeof(string1), "[INFO]: Buy: %d", FoCo_Donations[playerid][dbuy]);
	SendClientMessage(playerid, COLOR_SYNTAX, string1);
	format(string1, sizeof(string1), "[INFO]: Expire: %d", FoCo_Donations[playerid][dexp]);
	SendClientMessage(playerid, COLOR_SYNTAX, string1);
	return 1;
}

/* Silver donator commands */

CMD:blockallpm(playerid, params[])
{
    if(isVIP(playerid) >= 2 || AdminLvl(playerid) >= ACMD_SILVER)
	{
		if(GetPVarInt(playerid, "PMBLOCK") == 0)
		{
			SetPVarInt(playerid, "PMBLOCK", 1);
			SendClientMessage(playerid, COLOR_NOTICE, "Your PM's are now blocked.");
		}
		else
		{
			SetPVarInt(playerid, "PMBLOCK", 0);
			SendClientMessage(playerid, COLOR_NOTICE, "You have stopped blocking your PM's.");
		}
		return 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, NOT_ALLOWED_WARNINGMSG);
		return 1;
	}

}

CMD:togchat(playerid, params[])
{
	if(isVIP(playerid) >= 2 || AdminLvl(playerid) >= ACMD_SILVER)
	{
 		if(GetPVarInt(playerid, "TogMainChat") == -1)
		{
		    SendClientMessage(playerid, COLOR_NOTICE, "You disabled your main chat");
			SetPVarInt(playerid, "TogMainChat", 1);
		}
		else if(GetPVarInt(playerid, "TogMainChat") != -1)
		{
		    SendClientMessage(playerid, COLOR_NOTICE, "You enabled your main chat");
		    SetPVarInt(playerid, "TogMainChat", -1);
		}
		return 1;
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING,  NOT_ALLOWED_WARNINGMSG);
		return 1;
	}
}

CMD:fightstyle(playerid, params[])
{
	if(isVIP(playerid) >= 2 || AdminLvl(playerid) >= ACMD_GOLD)
	{
 		new BigD_fightingstyleopt[32];
		if(sscanf(params, "s[32]", BigD_fightingstyleopt))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /fightingstyle [normal/boxing/kungfu]");
			return 1;
		}
		if(strcmp(BigD_fightingstyleopt, "normal", true) == 0)
		{
			SetPlayerFightingStyle(playerid, FIGHT_STYLE_NORMAL);
			SendClientMessage(playerid, COLOR_CMDNOTICE ,"You are using the normal fighting style.");
		}
		else if(strcmp(BigD_fightingstyleopt, "boxing", true) == 0)
		{
			SetPlayerFightingStyle(playerid, FIGHT_STYLE_BOXING);
			SendClientMessage(playerid, COLOR_CMDNOTICE, "You are using the boxing fighting style.");
		}
		else if(strcmp(BigD_fightingstyleopt, "kungfu", true) == 0)
		{
			SetPlayerFightingStyle(playerid, FIGHT_STYLE_KUNGFU);
			SendClientMessage(playerid, COLOR_CMDNOTICE, "You are using the kungfu style.");
		}
		return 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be a silver donator for this command.");
	    return 1;
	}

}

/* Gold donator commands */

CMD:sd(playerid, params[])
{
	if(isVIP(playerid) == 3 || AdminLvl(playerid) >= ACMD_GOLD)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			new string[128];
			format(string, sizeof(string), "Please get out of your vehicle before skydiving!");
			SendClientMessage(playerid, COLOR_WARNING, string);
			return 1;
		}
		new Float:health;
		GetPlayerHealth(playerid, health);
		if(health < 85.0)
		{
		    new string[128];
			format(string, sizeof(string), "You need to be above 85 HP to skydive!");
			SendClientMessage(playerid, COLOR_WARNING, string);
			return 1;
		}
	 	new Float: px, Float:py, Float:pz;
	 	if(IsPlayerInRangeOfPoint(playerid, 15.0, 1544.7054,-1353.1078,329.4747))
		{
  			GameTextForPlayer(playerid, "~g~Green ~w~Light", 2500, 6);
			GivePlayerWeapon(playerid, 46 , 1);
			GetPlayerPos(playerid, px, py, pz);
			SetPlayerPos(playerid, px, py, pz+500);
			return 1;
  		}
		else
		{
			new string[128];
			format(string, sizeof(string), "You need to be on the top of SAN Tower to skydive!");
			SendClientMessage(playerid, COLOR_WARNING, string);
			return 1;
		}
	}
	else
 	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be a gold donator to use this feature");
		return 1;
	}
}

CMD:skydive(playerid, params[])
{
	cmd_sd(playerid, params);
	return 1;
}

CMD:vann(playerid, params[])
{
    if(isVIP(playerid) == 3 || AdminLvl(playerid) >= ACMD_GOLD)
	{
 		if(mutedPlayers[playerid][muted] == 1)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use /vann whilst muted");
		    return 1;
		}
		new announcement[144], msgstring[144];
		if(sscanf(params, "s[144]", announcement))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vann [message] (You can only make one each 20 minutes)");
			return 1;
		}
		else
		{
			new CurrentTime = gettime();
	 		new difference = CurrentTime - GetPVarInt(playerid, "LastTime_Vann_Sec");
	  		new totalsecleft = 1200-difference;
			new minutes = totalsecleft/60;
			new seconds = totalsecleft-minutes*60;

			if(minutes < 0)
			{
				SetPVarInt(playerid, "LastTime_Vann_Sec", 0);
			}
			if(CurrentTime - GetPVarInt(playerid, "LastTime_Vann_Sec") >= 1200000) // 20 min
			{
				SetPVarInt(playerid, "LastTime_Vann_Sec", CurrentTime);
				format(msgstring, sizeof(msgstring), "VIP Announcement by %s: %s", PlayerName(playerid), announcement);
	   			SendClientMessageToAll(COLOR_VIPNOTICE , msgstring);
			    return 1;
			}
			else
			{
				format(msgstring, sizeof(msgstring), "Please wait %d minute(s) and %d second(s) before making another VIP Announcement.", minutes, seconds);
				SendClientMessage(playerid, COLOR_SYNTAX, msgstring);
			}
			return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, NOT_ALLOWED_WARNINGMSG);
		return 1;
	}
}

CMD:neon(playerid, params[])
{
    if(isVIP(playerid) == 3 || AdminLvl(playerid) >= ACMD_GOLD)
	{
 		if(!IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You must be in a vehicle to do this");
			return 1;
		}

		if(FoCo_Vehicles[GetPlayerVehicleID(playerid)][cid] != FoCo_Player[playerid][users_carid])
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This can only be done on your own vehicle.");
			return 1;
		}

		if(neon[GetPlayerVehicleID(playerid)] != 0)
		{
			GameTextForPlayer(playerid, "~w~NEON ~r~ DISABLED!", 4000, 3);
			DestroyObject(neon[GetPlayerVehicleID(playerid)]);
			DestroyObject(neon2[GetPlayerVehicleID(playerid)]);
			neon[GetPlayerVehicleID(playerid)] = 0;
			neon2[GetPlayerVehicleID(playerid)] = 0;
			return 1;
		}
		ShowPlayerDialog(playerid, DIALOG_NEON, DIALOG_STYLE_LIST, "Please Choose A Neon", "Blue\nRed\nGreen\nWhite\nPurple\nYellow", "Toggle", "Close");
		return 1;
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, NOT_ALLOWED_WARNINGMSG);
		return 1;
	}

}

CMD:nos(playerid, params[])
{
    if(isVIP(playerid) == 3 || AdminLvl(playerid) >= ACMD_GOLD)
	{
		new msgstring[150];
		if(IsPlayerInAnyVehicle(playerid))
		{
		    new CurrentTime = gettime();
		    new difference = CurrentTime - GetPVarInt(playerid, "LastTime_Nos_Sec");
		    new totalsecleft = 300-difference;
			new minutes = totalsecleft/60;
			new seconds = totalsecleft-minutes*60;

			if(minutes < 0)
			{
	  			SetPVarInt(playerid, "LastTime_Nos_Sec", 0);
			}
		    if(CurrentTime - GetPVarInt(playerid, "LastTime_Nos_Sec") >= 300000) // 15 min
		    {
			    SetPVarInt(playerid, "LastTime_Nos_Sec", CurrentTime);
			    new vehicleid = GetPlayerVehicleID(playerid);
	        	AddVehicleComponent(vehicleid, 1010);
			    SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: NOS has been added to your vehicle! You can use this command again in five minutes.");
			}
			else
			{
	            format(msgstring, sizeof(msgstring), "Please wait %d minute(s) and %d second(s) before getting NOS again.", minutes, seconds);
				SendClientMessage(playerid, COLOR_SYNTAX, msgstring);

			}

		    return 1;
		}
		else return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in a vehicle.");
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, NOT_ALLOWED_WARNINGMSG);
		return 1;
	}

}

/* Work in progress */


CMD:namechange(playerid, params[])
{
	if(isVIP(playerid) > 0)
	{
		new newname[MAX_PLAYER_NAME], string[255];
		if (sscanf(params, "s[20]", newname))
		{
			format(string, sizeof(string), "[USAGE]: {%06x}/namechange [new name]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			SendClientMessage(playerid, COLOR_WARNING, "[WARNING]: Only use valid letters and numbers. Invalid symbols /WILL/ break your account.");
			return 1;
		}

		if(strlen(newname) > 20)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Your name can't be longer than 20 characters.");
			return 1;
		}
		if(strlen(newname) < 4)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your name can't be shorter than 4 characters.");
		    return 1;
		}
		
		if(ValidNC(playerid) >= 1)
		{
			new name[MAX_PLAYER_NAME];
			format(name, sizeof(name), "%s", newname);
			nameThread[playerid] = name;
			format(string, sizeof(string), "SELECT * FROM `FoCo_Players` WHERE `username`='%s' LIMIT 1", newname);
			mysql_query_callback(playerid, string, "OnPlayerNameChangeThread", playerid, con);
			SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: Please check your name via tab to see if your name has changed. If it didn't, contact a level 4 admin and SS the NC");
		}
		else
  		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need atleast one valid namechange to change your name");
			return 1;
		}
	}
	return 1;
}

CMD:transfernamechange(playerid, params[])
{
	new string[256], targetid, amount;
	if(sscanf(params, "ui", targetid, amount))
	{
	    format(string, sizeof(string), "[USAGE]: /transfernamechange [ID] [Amount]");
	    SendClientMessage(playerid, COLOR_SYNTAX, string);
	    return 1;
	}
	if(ValidNC(playerid) >= 1)
	{
	    if(ValidNC(playerid) < amount)
	    {
			format(string, sizeof(string), "[ERROR]: You only have %d valid namechanges left!", ValidNC(playerid));
			SendClientMessage(playerid, COLOR_WARNING, string);
			return 1;
	    }
	    if(targetid == INVALID_PLAYER_ID)
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid player ID.");
	        return 1;
	    }
	    if(targetid == playerid)
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot transfer namechanges to yourself!");
	        return 1;
	    }
	    format(string, sizeof(string), "SELECT nchanges from FoCo_Players where username='%s'", PlayerName(playerid));
   		new oldncsplayerid = mysql_query(string, MYSQL_TRANSFERNC, playerid, con);
	    format(string, sizeof(string), "UPDATE FoCo_Players SET nchanges ='%d' where username='%s'", (oldncsplayerid - amount), PlayerName(playerid));
	    mysql_query(string, MYSQL_TRANSFERNC, playerid, con);
	    new oldncstargetid = format(string, sizeof(string), "SELECT nchanges from FoCo_Players where username='%s'", PlayerName(targetid));
	    format(string, sizeof(string), "UPDATE FoCo_Players SET nchanges ='%d' where username='%s'", (oldncstargetid + amount), PlayerName(targetid));
	    mysql_query(string, MYSQL_TRANSFERNC, playerid, con);
	    
	    format(string, sizeof(string), "[INFO]: You have successfully transferred %d namechanges to %s(%d). You now have %d namechanges left.", amount, PlayerName(targetid), targetid, FoCo_Player[playerid][nchanges]);
	    SendClientMessage(playerid, COLOR_WHITE, string);
	    format(string, sizeof(string), "[INFO]: %s(%d) has transferred %d namechanges to your account. You now have %d valid namechanges.", PlayerName(playerid), playerid, FoCo_Player[targetid][nchanges]);
	    SendClientMessage(playerid, COLOR_WHITE, string);
	    format(string, sizeof(string), "[INFO]: %s(%d) has transferred %d namechanges to %s(%d).", PlayerName(playerid), playerid, amount, PlayerName(targetid), targetid);
	    SendAdminMessage(1, string);
	    IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	    return 1;
	}
	SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not have any valid namechanges!");
	return 1;
}






















