#include <YSI\y_hooks>

enum vb_details
{
	bool:vb_enabled,
	vb_starter,
	vb_reason[31],
	vb_votes,
	vb_votedby[MAX_PLAYERS],
	vb_positive,
	vb_negative,
	vb_result
}

new VoteBan[MAX_PLAYERS][vb_details];
new bool:VotedOn[MAX_PLAYERS][MAX_PLAYERS];
new currvban[MAX_PLAYERS];
new vbmsg[MAX_PLAYERS * 6];
OnlineTrustedMembers(rank = 1)
{
	new count;
	foreach(Player, pid)
	{
		if(FoCo_Player[pid][trusted] >= rank && IdleTime[pid] <= 30)
		{
			count++;
		}
	}	
	return count;
}

stock ResetVoteBan(playerid)
{
	foreach(Player, pid)
	{
		if(VotedOn[playerid][pid] == true)
			VoteBan[pid][vb_votes]--;
		VotedOn[playerid][pid] = false;
		VoteBan[playerid][vb_votedby][pid] = -1;
		VoteBan[pid][vb_votedby][playerid] = -1;
	}
	if(VoteBan[playerid][vb_enabled] == true)
	{
		format(vbmsg, sizeof(vbmsg), "[VOTE BAN]: %s(%i) has logged during vote-ban. Kindly post the evidence at forum to get the player banned.", PlayerName(playerid), playerid);
        SendTrustedMemberChat(vbmsg);
	}
	VoteBan[playerid][vb_enabled] = false;
	VoteBan[playerid][vb_starter] = MAX_PLAYERS;
	VoteBan[playerid][vb_reason] = 0;
	VoteBan[playerid][vb_votes] = 0;
	VoteBan[playerid][vb_positive] = 0;
	VoteBan[playerid][vb_negative] = 0;
	return 1;
}

hook OnPlayerConnect(playerid)
{
	return ResetVoteBan(playerid);
}

hook OnPlayerDisconnect(playerid)
{
	return ResetVoteBan(playerid);
}

stock VoteBanLog(string[])
{
    new entry[256];
    format(entry, sizeof(entry), "Date %s | %s\r\n", TimeStamp(), string);
    new File:hFile;
    hFile = fopen("FoCo_Scriptfiles/Logs/voteban.txt", io_append);
    fwrite(hFile, entry);
    fclose(hFile);
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_VOTEBAN)
    {
        if(!response)
        {
            return SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Its always better to be sure than sorry. Do not mess up, we got no room for mistakes.");
        }
        else
        {
			if(FoCo_Player[playerid][trusted] >= 2)
			{
	            new targetid = currvban[playerid];
	 			if(IsValidPlayerID(playerid, targetid))
			    {
		            if(!AdminsOnline() && !TAdminsOnline())
				    {
						if(VoteBan[targetid][vb_enabled] == false)
					    	return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Vote-Ban is not enabled for the player.");
					    if(VoteBan[targetid][vb_result] == 2)
					    {
							format(vbmsg, sizeof(vbmsg), "%s[c/o [TMVB]%s]", VoteBan[targetid][vb_reason], PlayerName(playerid));
							ABanPlayer(-1, targetid, vbmsg, 1);
							format(vbmsg, sizeof(vbmsg), "%s has banned %s for %s", PlayerName(playerid), PlayerName(targetid), VoteBan[targetid][vb_reason]);
							VoteBanLog(vbmsg);
						}
						else
						    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player hasn't received enough positive-hack votes.");
					}
					else
					    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not use this command while a (trial)admin is online");
				}
			}
			else
			    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not authorized to use this command.");
        }
        return 1;
    }
    return 0;
}

CMD:voteban(playerid, params[])
{
	if(FoCo_Player[playerid][trusted] >= 2)
	{
	    new targetid;
	    if(sscanf(params, "u", targetid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /voteban [PlayerID/PlayerName]");
	    }
	    if(IsValidPlayerID(playerid, targetid))
	    {
            if(!AdminsOnline() && !TAdminsOnline())
		    {
				if(VoteBan[targetid][vb_enabled] == false)
			    	return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Vote-Ban is not enabled for the player.");
			    if(VoteBan[targetid][vb_result] == 2)
			    {
					format(vbmsg, sizeof(vbmsg), "{ffffff}Are you sure you want to ban {ff0000}%s(%i) {ffffff}for using hacks?\n{ff0000}If you wrongfully ban a player or ban a player without EVIDENCE, you will end up getting banned.\n{00ff00}If you agree to these terms, please mention the reason for the ban below. If you are doubtful about the reason, use /banreasons", PlayerName(targetid), targetid);
					currvban[playerid] = targetid;
					return ShowPlayerDialog(playerid, DIALOG_VOTEBAN, DIALOG_STYLE_MSGBOX, "Vote-Ban Confirmation", vbmsg, "I Agree", "I Disagree");
			    }
			    else
			        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player hasn't received enough votes for a voteban.");
			}
			else
			    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not use this command with (trial)admins IG.");
	    }
	}
	else
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not authorized to use this command.");
	return 1;
}

CMD:banreasons(playerid, params[])
{
	if(FoCo_Player[playerid][trusted]> 0)
	{
		format(vbmsg, sizeof(vbmsg),  "Valid Ban Reasons for Trusted Members are:\n•AirBreak/FlyHack\n•RapidFire\n•Advertisement Spam\n•Teleport Hack\n•Fake Death/Kill Spam\n•Vehicle Health Hack(Evidence with /dl)\n•Other Visible Hacks\nAll bans must have valid evidence, else you will get yourself banned.");
		ShowPlayerDialog(playerid, DIALOG_NORETURN, DIALOG_STYLE_MSGBOX, "Ban Reasons", vbmsg, "I Get it", "");
	}
	return 0;
}

CMD:endvoteban(playerid, params[])
{
	if(FoCo_Player[playerid][trusted] || AdminLvl(playerid) > 0)
	{
		if(FoCo_Player[playerid][trusted]> 1)
		{
			if(!AdminsOnline() && !TAdminsOnline())
		    {
				new targetid;
				if(sscanf(params, "u", targetid))
					return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /endvoteban [PlayerName/PlayerID]");
				if(targetid == INVALID_PLAYER_ID)
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: INVALID PLAYER ID.");
				if(!IsPlayerConnected(targetid))
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerID not connected.");
				if(VoteBan[targetid][vb_enabled] == false)
				    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Vote-Ban is not enabled for the player.");
				new svb[128];
				format(svb, sizeof(svb), "[VOTEBAN]: %s(%i) has ended vote-ban on %s(%i).", PlayerName(playerid), playerid, PlayerName(targetid), targetid);
				VoteBanLog(svb);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, svb);
				if(VoteBan[targetid][vb_negative] == 0)
				        VoteBan[targetid][vb_negative] = 1;
    			new Float:ratio = floatdiv(float(VoteBan[targetid][vb_positive]), float(VoteBan[targetid][vb_negative] + VoteBan[targetid][vb_positive]));
				if(ratio > 0.75 && (VoteBan[targetid][vb_positive]+VoteBan[targetid][vb_negative]) > 2)
				{
				  	format(svb, sizeof(svb), "[VOTEBAN]: %s(%i) has enough Positive votes for a ban. Use /voteban to ban the person.", PlayerName(targetid), targetid);
					if(VoteBan[playerid][vb_starter] != MAX_PLAYERS)
						SendClientMessage(VoteBan[targetid][vb_starter], COLOR_NOTICE, svb);
					else
					{
					    format(svb, sizeof(svb), "[VOTEBAN]: %s(%i) has enough votes for a ban. Since the original Rank-2 Member has logged, get another Rank 2 member or contact admin", PlayerName(targetid), targetid);
					    SendTrustedMemberChat(svb);
					}
					VoteBan[targetid][vb_result] = 2;
				}
				else
				{
	  				format(svb, sizeof(svb), "[VOTEBAN]: Everyone has voted on %s(%i) but it hasn't received enough Positive votes. Contact Admin(PM:1500)", PlayerName(targetid), targetid);
					SendTrustedMemberChat(svb);
	                VoteBan[targetid][vb_result] = 1;
				}
			}
		}
	}
	return 1;
}

CMD:castvoteban(playerid, params[])
{
	if(FoCo_Player[playerid][trusted] || AdminLvl(playerid) > 0)
	{
		if(FoCo_Player[playerid][trusted]> 0)
		{
			if(!AdminsOnline() && !TAdminsOnline())
		    {

				new targetid, bool:option;
				if(sscanf(params, "ul", targetid, option))
					return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /castvoteban [PlayerName/PlayerID] [Option(True/false | 0 / 1)]");
				if(targetid == INVALID_PLAYER_ID)
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: INVALID PLAYER ID.");
				if(!IsPlayerConnected(targetid))
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerID not connected.");
				if(VoteBan[targetid][vb_enabled] == false)
				    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Vote-Ban is not enabled for the player.");
				if(VoteBan[targetid][vb_votedby][playerid] != -1 || VotedOn[playerid][targetid])
				    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have already casted vote on this player. Use /changevote [PlayerID] to swap vote.");
				new svb[128];
				format(svb, sizeof(svb), "[VOTEBAN]: %s(%i) has casted voted on %s(%i)(Vote: %s).", PlayerName(playerid), playerid, PlayerName(targetid), targetid, (option == true) ? ("Positive") : ("Negative"));
				VoteBanLog(svb);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, svb);
				foreach(Player, pid)
				{
					if(FoCo_Player[pid][trusted])
					{
						SendClientMessage(pid, COLOR_GREEN, svb);
					}
				}
				VotedOn[playerid][targetid] = true;
				VoteBan[targetid][vb_votes]++;
				VoteBan[targetid][vb_votedby][playerid] = option;
				if(option == true)
				    VoteBan[targetid][vb_positive]++;
				else
				    VoteBan[targetid][vb_negative]++;
				if(OnlineTrustedMembers() <= VoteBan[targetid][vb_votes])
				{
				    new Float:ratio = floatdiv(float(VoteBan[targetid][vb_positive]), float(VoteBan[targetid][vb_negative] + VoteBan[targetid][vb_positive]));
					if(ratio > 0.75 && (VoteBan[targetid][vb_positive]+VoteBan[targetid][vb_negative]) > 2)
					{
					  	format(svb, sizeof(svb), "[VOTEBAN]: %s(%i) has enough Positive votes for a ban. Use /voteban to ban the person.", PlayerName(targetid), targetid);
						if(VoteBan[playerid][vb_starter] != MAX_PLAYERS)
							SendClientMessage(VoteBan[targetid][vb_starter], COLOR_NOTICE, svb);
						else
						{
						    format(svb, sizeof(svb), "[VOTEBAN]: %s(%i) has enough votes for a ban. Since the original Rank-2 Member has logged, get another Rank 2 member or contact admin", PlayerName(targetid), targetid);
						    SendTrustedMemberChat(svb);
						}
						VoteBan[targetid][vb_result] = 2;
					}
					else
					{
					  	format(svb, sizeof(svb), "[VOTEBAN]: Everyone has voted on %s(%i) but it hasn't received enough Positive votes. Contact Admin(PM:1500)", PlayerName(targetid), targetid);
						SendTrustedMemberChat(svb);
	                    VoteBan[targetid][vb_result] = 1;
					}
				}
			}
			else
			    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Command disabled while (trial)admins are online.");
		}
	}
	return 1;
}

CMD:startvoteban(playerid, params[])
{
	if(FoCo_Player[playerid][trusted] || AdminLvl(playerid) > 0)
	{
		if(FoCo_Player[playerid][trusted] == 2)
		{
		    if(!AdminsOnline() && !TAdminsOnline())
		    {
				new targetid, reason[31];
				if(sscanf(params, "us[30]", targetid, reason))
				{
					SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /startvoteban [PlayerName/PlayerID] [Reason(Short and accurate)]");
	                return SendClientMessage(playerid, COLOR_SYNTAX, "[NOTICE]: Use /banreasons to find list of rule-breaks you are permitted to use /voteban for");
				}
				if(targetid == INVALID_PLAYER_ID)
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: INVALID PLAYER ID.");
				if(!IsPlayerConnected(targetid))
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerID not connected.");
				if(OnlineTrustedMembers() < 3)
				    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need atleast 3 trusted members online to start vote-ban. Contact an admin.");
				new svb[128];
				format(svb, sizeof(svb), "[VOTEBAN]: %s(%i) has started a vote-ban on %s(%i) for %s. Use /castvoteban %i to vote.", PlayerName(playerid), playerid, PlayerName(targetid), targetid, reason, targetid);
				VoteBanLog(svb);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, svb);
				foreach(Player, pid)
				{
					if(FoCo_Player[pid][trusted])
					{
						SendClientMessage(pid, COLOR_GREEN, svb);
						SendClientMessage(pid, COLOR_GREEN, "[NOTICE]: Any false bans will result in permanent Ban. Use /banreasons before voting.");
					}
					VotedOn[pid][targetid] = false;
					VoteBan[targetid][vb_votedby][pid] = -1;
				}
				VoteBan[targetid][vb_enabled] = true;
				VoteBan[targetid][vb_starter] = playerid;
				VoteBan[targetid][vb_reason] = reason;
				VoteBan[targetid][vb_votes] = 0;
				VoteBan[targetid][vb_positive] = 0;
	            VoteBan[targetid][vb_negative] = 0;
				return 1;
			}
			else
			    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is (Trial)Admin(s) online. Please use /report or /helpme.");
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to be a Rank-2 trusted member to start vote-bans.");
		}
		if(OnlineTrustedMembers(2) == 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: Use IRC to gather help from an admin or a Rank-2 Trusted Member. (/pm 1500 [Message])");
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: Please contact a Rank-2 Trusted-Player. There is one of more of them online.");
		}
		return 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not authorized to use this command.");
	}
	return 1;
}

CMD:settrustedmemberrank(playerid, params[])
{
	if(IsAdmin(playerid, 3))
	{
		new targetid, rank;
		if(sscanf(params, "ud", targetid, rank))
			return SendClientMessage(playerid, COLOR_SYNTAX, "[SYNTAX]: /settrustedmemberrank [PlayerName/PlayerID] [Rank1-3]");
		if(targetid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerName/PlayerID.");
		if(!IsPlayerConnected(targetid))
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerID not connected.");
		if(!FoCo_Player[targetid][trusted])
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player is not a Trusted-Member.");
		if(rank >= 3 && AdminLvl(playerid) < 5)
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to be Lead Admin to Set Rank 3/+.");
		if(rank < 1 && rank > 3)
		{
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid RankID (1 - 3).");
		}
		new atm_msg[128];
		format(atm_msg, sizeof(atm_msg), "AdmCmd(4): %s %s has set %s(%i) to Rank %i Trusted Member.", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid, rank);
		SendAdminMessage(3, atm_msg);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, atm_msg);
		format(atm_msg, sizeof(atm_msg), "[NOTICE]: %s %s has set your Rank in Trusted Member as %i.", GetPlayerStatus(playerid), PlayerName(playerid), rank);
		FoCo_Player[targetid][trusted] = rank;
	}
	return 1;
}

CMD:addtrustedmember(playerid, params[])
{
	if(IsAdmin(playerid, 3))
	{
		new targetid;
		if(sscanf(params, "u", targetid))
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /addtrustedmember [PlayerName/PlayerID]");
		if(targetid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: INVALID PLAYER ID.");
		if(!IsPlayerConnected(targetid))
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerID not connected.");
		if(!FoCo_Player[targetid][trusted])
		{
			new atm_msg[128];
			format(atm_msg, sizeof(atm_msg), "AdmCmd(3): %s %s has made %s(%i) a Trusted-Member.", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
			SendAdminMessage(3, atm_msg);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, atm_msg);
			format(atm_msg, sizeof(atm_msg), "[NOTICE]: %s %s has made you a Trusted-Member.", GetPlayerStatus(playerid), PlayerName(playerid));
			FoCo_Player[targetid][trusted] = 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerID is already a Trusted-Member.");
		}
	}
	return 1;
}

CMD:removetrustedmember(playerid, params[])
{
	if(IsAdmin(playerid, 3))
	{
		new targetid;
		if(sscanf(params, "u", targetid))
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /addtrustedmember [PlayerName/PlayerID]");
		if(targetid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: INVALID PLAYER ID.");
		if(!IsPlayerConnected(targetid))
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerID not connected.");
		if(FoCo_Player[targetid][trusted])
		{
			new atm_msg[128];
			format(atm_msg, sizeof(atm_msg), "AdmCmd(3): %s %s has removed %s(%i)'s Trusted-Member status.", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
			SendAdminMessage(3, atm_msg);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, atm_msg);
			format(atm_msg, sizeof(atm_msg), "[NOTICE]: %s %s has removed your Trusted-Member status.", GetPlayerStatus(playerid), PlayerName(playerid));
			FoCo_Player[targetid][trusted] = 0;
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerID is not a Trusted-Member.");
		}
	}
	return 1;
}

CMD:trustedmembers(playerid, params[])
{
	vbmsg = "List of Online Trusted Members:";
	foreach(Player, pid)
	{
		if(FoCo_Player[pid][trusted] > 0)
		{
		    format(vbmsg, sizeof(vbmsg), "%s\n[%i]%s", vbmsg, pid, PlayerName(pid));
		}
        ShowPlayerDialog(playerid, DIALOG_NORETURN, DIALOG_STYLE_MSGBOX, "Trusted Members", vbmsg, "!!OK!!", "");
	}
	return 1;
}

SendTrustedMemberChat(msg[])
{
	foreach(Player, pid)
	{
	    if(FoCo_Player[pid][trusted] > 0 || AdminLvl(pid) > 0 || FoCo_Player[pid][tester] > 0)
	    {
	        SendClientMessage(pid, COLOR_PURPLE, msg);
	    }
	}
	return 1;
}

CMD:tm(playerid, params[])
{
	if(FoCo_Player[playerid][admin] < 1 && FoCo_Player[playerid][tester] < 1 && FoCo_Player[playerid][trusted] < 1)
	{
		SendClientMessage(playerid, COLOR_WARNING,  NOT_ALLOWED_WARNINGMSG);
		return 1;
	}
	new message[256], string[256];
	if(sscanf(params, "s[256]", message))
	{
		format(string, sizeof(string), "[USAGE]: {%06x}/tm {%06x}[Message]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		return 1;
	}
	if(strlen(message) > 55)
	{
		new message2[300];
 		strmid(message2,message,55,strlen(message),sizeof(message2));
		strmid(message,message,0,55,sizeof(message));
		format(string, sizeof(string), "[Trustee]: {%06x}%s %s:{%06x} %s", COLOR_GREEN >>> 8, GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WHITE >>> 8, message);
		SendTrustedMemberChat(string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		format(string, sizeof(string), "[Trustee]: %s %s: %s", GetPlayerStatus(playerid), PlayerName(playerid), message);
		TrustedMemberChatLog(string);
		format(string, sizeof(string), "..{%06x} %s", COLOR_WHITE >>> 8, message2);
		SendTrustedMemberChat(string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		format(string, sizeof(string), "[Trustee]: %s %s: %s", GetPlayerStatus(playerid), PlayerName(playerid), message2);
		TrustedMemberChatLog(string);
	}
	else
	{
		format(string, sizeof(string), "[Trustee]: {%06x}%s %s:{%06x} %s", COLOR_GREEN >>> 8, GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WHITE >>> 8, message);
		SendTesterChat(string);
		IRC_GroupSay(gTRAdmin, IRC_FOCO_TRADMIN, string);
		format(string, sizeof(string), "[Trustee]: %s %s: %s", GetPlayerStatus(playerid), PlayerName(playerid), message);
		TrialAdminChatLog(string);
	}
	return 1;
}
