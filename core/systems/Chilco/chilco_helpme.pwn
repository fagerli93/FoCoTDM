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
* Filename: chilco_helpme .pwn                                                   *
* Author: Chilco                                                                 *
*********************************************************************************/
#define DIALOG_HELPMEMENU 508

CMD:helpme(playerid, params[])
{
	new issue_str[150], msgstring[150];
    if(sscanf(params, "s[150]", issue_str))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /helpme [issue]");
		return 1;
	}
	else
	{
	    format(msgstring, sizeof(msgstring), "{FF6347}[HELP REQUEST %d]: {cde9e9}%s asks: %s",playerid, PlayerName(playerid), issue_str);
	    SendClientMessage(playerid, COLOR_WHITE ,"Your help request has been sent to all online trial admins.");
	    HelpmeLog(msgstring);
	    SendTesterChat(msgstring);
	    SetPVarInt(playerid, "Helpme", 1);
	    SetPVarString(playerid, "Helpme_reason", issue_str);
	    GiveAchievement(playerid, 101);
	    return 1;
	}
}

CMD:ahr(playerid, params[])
{
    if(IsTrialAdmin(playerid))
    {
		new helpreq_id, msgstring[150];
	    if(sscanf(params, "d", helpreq_id))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /ahr [Help Request ID]");
		}
		else
		{
		    if(GetPVarInt(helpreq_id,"Helpme") == 1)
		    {
		        new reason[160];
		        GetPVarString(helpreq_id,"Helpme_reason", reason, 160);
		        format(msgstring, sizeof(msgstring), "{FFFF00}[HELP NOTICE]: %s %s accepted help request %d",GetPlayerStatus(playerid), PlayerName(playerid), helpreq_id);
		        HelpmeLog(msgstring);
		        SendTesterChat(msgstring);
		        format(msgstring, sizeof(msgstring), "[HELP NOTICE]: Question: %s", reason);
		        HelpmeLog(msgstring);
		        format(msgstring, sizeof(msgstring), "%s %s is now looking into your help request.", GetPlayerStatus(playerid), PlayerName(playerid));
		        SendClientMessage(helpreq_id, COLOR_CMDNOTICE , msgstring);
		        format(msgstring, sizeof(msgstring), "{FF6347}Your request was: {cde9e9}%s", reason);
		        SendClientMessage(helpreq_id, COLOR_WHITE , msgstring);
		        DeletePVar(helpreq_id, "Helpme");
		    	DeletePVar(helpreq_id, "Helpme_reason");
		    }
		    else
			{
				SendClientMessage(playerid, COLOR_CMDNOTICE , "This player has currently no help request pending.");
			}
		}
	}
	return 1;
}

CMD:dhr(playerid, params[])
{
    if(IsTrialAdmin(playerid))
    {
		new helpreq_id, msgstring[150];
	    if(sscanf(params, "d", helpreq_id))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /dhr [Help Request ID]");
		}
		else
		{
		    if(GetPVarInt(helpreq_id,"Helpme") == 1)
		    {
		        format(msgstring, sizeof(msgstring), "{FFFF00}[HELP NOTICE]: %s %s deleted help request %d",GetPlayerStatus(playerid), PlayerName(playerid), helpreq_id);
		        HelpmeLog(msgstring);
		        SendTesterChat(msgstring);
		        DeletePVar(helpreq_id, "Helpme");
		    	DeletePVar(helpreq_id, "Helpme_reason");
		    }
		    else
			{
				SendClientMessage(playerid, COLOR_CMDNOTICE , "This player has currently no help request pending.");
			}
		}
	}
	return 1;
}

CMD:helpmes(playerid, params[])
{
	if(IsTrialAdmin(playerid))
	{
		new helpcount, menu[1000]="Request ID\tPlayer Name\tQuestion\n", reason[160];
		foreach(Player,i)
		{
		    if(GetPVarInt(i,"Helpme") == 1)
		    {
		        new line[160];
		        GetPVarString(i,"Helpme_reason", reason, 160);
		        helpcount ++;
				format(line,sizeof(line),"[HELP REQ %d]\t%s\t%s\n", i, PlayerName(i), reason);
				new length = strlen(menu);
				strins(menu, line, length);
		    }
		}
		if(helpcount == 0)
		{
			SendClientMessage(playerid, COLOR_CMDNOTICE, "There are currently no help requests.");
		}
		ShowPlayerDialog(playerid,DIALOG_HELPMEMENU,DIALOG_STYLE_TABLIST_HEADERS,"Help Requests Menu",menu,"Close", ""); //Doesn't need OnPlayerDialogResponse since it only shows one menu.
	}
	return 1;
}
