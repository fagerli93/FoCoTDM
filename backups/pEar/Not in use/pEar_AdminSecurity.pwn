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
* Filename:	pEar_AdminSecurity.pwn	                                             *
* Author: pEar                                                                   *
*********************************************************************************/
/*
FoCo_AdminSecurity Table Setup:
- ID, auto-increasement
- ReqSec, int(1) - Most people will have 1, but if someone were to bug up completely. Required Security or not.
- Range1, varchar(56) - Default NULL
- Range2, varchar(56) - DEFAULT NULL
- Range3, varchar(56) - DEFAUL NULL
- YOB, int(1) - Year of birth, like 1993 as first measure of security.
- SecHint, varchar(56) - Hint for those that want that.
- SecAnswer, varchar(56) - Answer for security question.
*/

#define ACMD_GRANTADMCMD 5

hook OnPlayerConnect(playerid)
{
	AdminSecurityConnect(playerid);
	return 1;
}


AdminSecurityConnect(playerid)
{
	if(AdminLvl(playerid) > 0)
	{
		new i, IP[16], len, del, first_string[6], second_string[6], first_dot = -1, second_dot = -1;
		GetPlayerIP(playerid, IP, sizeof(IP));
		len = strlen(IP);
		
		first_dot = strfind(IP, ".", true);
		second_dot = strfind(IP, ".", true, first_pos+1);
		if(first_dot == -1 || second_dot == -1)
		{
			format(debug, sizeof(debug), "[DEBUG]: Something went wrong, '.' was not found whilst searching IP: %s for %s(%s)", IP, PlayerName(playerid), playerid);
			SendClientMessageToAll(COLOR_GLOBALNOTICE, debug);
			return 1;
		}
		strdel(IP, second_dot, strlen(IP));			// Have found the actual first two ranges of IP. Original something: 187.98.232.23, new range: 187.98
		if(MatchIPRange(playerid, IP))
		{
			return 1;
		}
		else if(MatchIPRange(playerid, IP) == -1)
		{
			ShowPlayerDialog(playerid, DIALOG_ADMSECFIRST, DIALOG_STYLE_INPUT, "Admin Security Panel", "You have to edit your administrator security details\nPlease enter your YEAR of birth, 4 digits.", OK, "");
			return 1;
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_ADMSEC, DIALOG_STYLE_PASSWORD, "Unapproved IP Connection", "You have connected using a different IP than usual\nPlease fill in your YEAR of birth", "OK", "Cancel");
			return 1;
		}
	}
	
	return 1;
}

// Returns 1 if given IP Range compares to any of the 3 saved ranges.
MatchIPRange(playerid, IP_Range[])
{
	new i, Approved_Range[16]; 
	
	for(i = 1; i <= 3; i++)
	{
		Approved_Range = GetApprovedIPRange(playerid, i);
		if(strcmp(IP_Range, Approved_Range, true) == 0)
		{
			return 1;
		}
		else if(strcmp(Approved_Range, "-1", true) == 0)
		{
			return -1;
		}
	}
	
	return 0;
}

GetApprovedIPRange(playerid, IP_ID)
{
	new query[156], Approved_Range[16], check[56];
	
	format(query, sizeof(query), "SELECT Range%d FROM FoCo_AdminSecurity WHERE ID='%d';", IP_ID, FoCo_Player[playerid][id]);
	Approved_Range = mysql_query(query, MYSQL_ADMSECFETCH, playerid, con);
	if(strcmp(Approved_Range, "", true) == 0 || strcmp(Approved_Range, "-1", true))
	{
		format(Approved_Range, sizeof(Approved_Range), "-1");
		format(query, sizeof(query), "SELECT * FROM FoCo_AdminSecurity WHERE ID='%d';", FoCo_Player[playerid][id]);
		check = mysql_query(query, MYSQL_ADMSECFETCH, playerid, con);
		if(strcmp(check, "", true, strlen(check)) == 0)
		{
			format(query, sizeof(query), "INSERT INTO FoCo_AdminSecurity (ID, ReqSec, Range1, Range2, Range3, SecHint, SecAnswer) VALUES (%d, -1, '-1', '-1', '-1', 'TBA', 'TBA');", FoCo_Player[playerid][id]);
			mysql_query(query, MYSQL_ADMSECFETCH, playerid, con);
		}
	}
	format(query, sizeof(query), "[DEBUG]: %s's approved range: %d", PlayerName(playerid), Approved_Range);
	SendClientMessageToAll(COLOR_GLOBALNOTICE, query);
	
	return Approved_Range;
}

UpdateApprovedIPRange(playerid, IP_Range[], IP_ID)
{
	new Approved_Range, query[128];
	
	format(query, sizeof(query), "UPDATE FoCo_AdminSecurity  SET Range%d='%s' WHERE ID='%d';", IP_ID, IP_Range, FoCo_Player[playerid][id]);
	mysql_query(query, MYSQL_ADMSECUPDATE, playerid, con);
	
	return 1;
}

RemoveApprovedIPRange(playerid, IP_ID)
{
	new query[128];
	
	format(query, sizeof(query), "UPDATE FoCo_AdminSecurity  SET Range%d='-1' WHERE ID='%d';", IP_ID, FoCo_Player[playerid][id]);
	mysql_query(query, MYSQL_ADMSECUPDATE, playerid, con);
	
	return 1;
}

GetYearOfBirth(playerid)
{
	new YOB, query[128];
	
	format(query, sizeof(query), "SELECT YOB FROM FoCo_AdminSecurity WHERE ID='%d';", FoCo_Player[playerid][id]);
	YOB = mysql_query(query, MYSQL_ADMSECYOB, playerid, con);
	
	return YOB;
}

GetSecurityHint(playerid)
{
	new hint[56], query[128];
	
	format(query, sizeof(query), "SELECT SecHint FROM FoCo_AdminSecurity WHERE ID='%d';", FoCo_Player[playerid][id]);
	hint = mysql_query(query, MYSQL_ADMSECHINT, playerid, con);
	
	return hint;
}

GetSecurityAnswer(playerid)
{
	new answer[56], query[128];
	
	format(query, sizeof(query), "SELECT SecAnswer FROM FoCo_AdminSecurity WHERE ID='%d';", FoCo_Player[playerid][id]);
	answer = mysql_query(query, MYSQL_ADMSECANSWER, playerid, con);
	
	return answer;
}

CheckYearOfBirth(playerid, YOB)			// Returns 1 if given YOB is equal to the one in the DB. Returns 0 if false.
{
	new A_YOB;
	
	A_YOB = GetYearOfBirth(playerid);
	if(A_YOB == YOB)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

CheckSecurityAnswer(playerid, SecAnswer[])				// Returns 1 if correct answer, 0 if wrong.
{
	new A_SecAnswer[56];
	
	A_SecAnswer = GetSecurityAnswer(playerid);
	if(strcmp(A_SecAnswer, SecAnswer, false) == 0)
	{
		return 1;
	}
	else
	{
		return 0; 
	}
}

CMD:requestadmsec(playerid, params[])
{
	if(AdminLvl(playerid) > 0)
	{
		new targetid, string[128];
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: /requestadmsec [ID]");
		}
		if(AdminLvl(targetid) < ACMD_GRANTADMCMD)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can only request admin security from a level 4+");
		}
		if(GetPVarInt(targetid, "ASecAdm") != -1)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This admin already has an unfinished admin security request.");
		}
		SetPVarInt(playerid, "SecAdm", targetid);
		format(string, sizeof(string), "[INFO]: You have sent a request for admin security to %s(%d)", PlayerName(targetid), targetid);
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[INFO]: %s(%d) have requested his admin security to be updated. /allowadmsec [ID] to allow, or /disallowadmsec to disallow", PlayerName(playerid), playerid);
		SendClientMessage(targetid, COLOR_GLOBALNOTICE, string);
		SetPVarInt(targetid, "ASecAdm", playerid);
	}
	return 1;
}

CMD:allowadmsec(playerid, params[])
{
	if(AdminLvl(playerid) >= 4)
	{
		new string[128], targetid;
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: /allowadmsec [ID]");
		}
		if(GetPVarInt(targetid, "ASecAdm") != playerid)
		{
			format(string, sizeof(string), "[ERROR]: %s(%d) haven't requested admsec, or he has already requested this from another admin.", PlayerName(targetid), targetid);
			return SendClientMessage(playerid, COLOR_WARNING, string); 
		}
		else
		{
			if(AdminLvl(targetid) == 0)
			{
				format(string, sizeof(string), "[ERROR]: %s's(%d) admin level is 0.", PlayerName(targetid), targetid);
				return SendClientMessage(playerid, COLOR_WARNING, string);
			}
			ShowPlayerDialog(targetid, DIALOG_UPDATEADMSEC, DIALOG_STYLE_LIST, "Admin Security Panel", "Year of Birth\nSecurity Hint\nSecurity Answer\nApproved Range 1\nApproved Range 2\nApproved Range 3", "Select", "Cancel");
			format(string, sizeof(string), "[INFO]: %s %s(%) has approved your admin security settings update request.", PlayerName(playerid), playerid);
			SendClientMessage(targetid, COLOR_YELLOW, string);
			format(string, sizeof(string), "[INFO]: You have allowed %s(%d) to edit his admin security settings.", PlayerName(targetid), targetid);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			DeletePVar(targetid, "AdmSec");
			return 1;
		}
	}
	
	return 1;
}

CMD:disallowadmsec(playerid, params[])
{
	if(AdminLvl(playerid) >= 4)
	{
		new string[128], targetid;
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: /disallowadmsec");
		}
		else
		{
			if(AdminLvl(targetid) == 0)
			{
				format(string, sizeof(string), "[ERROR]: %s's(%d) admin level is 0.", PlayerName(targetid), targetid);
				return SendClientMessage(playerid, COLOR_WARNING, string);
			}
			format(string, sizeof(string), "[INFO]: %s %s(%) has rejected your admin security settings update request.", PlayerName(playerid), playerid);
			SendClientMessage(targetid, COLOR_YELLOW, string);
			format(string, sizeof(string), "[INFO]: You have rejected %s's(%d) admsec update request.", PlayerName(targetid), targetid);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			DeletePVar(targetid, "AdmSec");
			return 1;
		}
	}
	return 1;
}

CMD:admsec(playerid, params[])
{
	if(AdminLvl(playerid) >= 4)
	{
		new targetid, string[128];
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: /admsec [ID]");
		}
		else
		{
			if(AdminLvl(targetid) == 0)
			{
				format(string, sizeof(string), "[ERROR]: %s's(%d) admin level is 0.", PlayerName(targetid), targetid);
				return SendClientMessage(playerid, COLOR_WARNING, string);
			}
			ShowPlayerDialog(targetid, DIALOG_UPDATEADMSEC, DIALOG_STYLE_LIST, "Admin Security Panel", "Year of Birth\nSecurity Hint\nSecurity Answer\nApproved Range 1\nApproved Range 2\nApproved Range 3", "Select", "Cancel");
			format(string, sizeof(string), "[INFO]: %s %s(%) has forced you to edit your admin security settings.", PlayerName(playerid), playerid);
			SendClientMessage(targetid, COLOR_YELLOW, string);
			return 1;
		}
	}
	
	return 1;
}