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
#include <YSI\y_hooks>

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
/*
#define ADM_AUTH_LOGIN 1
#define ADM_AUTH_CMD 2
#define ADM_AUTH_AUTHENTICATED 3
*/

forward CMD_Auth(playerid);
public CMD_Auth(playerid)
{
	/* Need to authenticate!*/
	if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
		SetPVarInt(playerid, "AdmSec_Auth", ADM_AUTH_CMD);
		SendClientMessage(playerid, COLOR_YELLOW, "[AdmSec]: You are accessing a sensitive command, please authenticate.");
		AdminSecurity(playerid);
		return -1;
	} else {
		return 1;
	}
}

CMD:auth(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_AUTH)) {
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			SetPVarInt(playerid, "AdmSec_Auth", ADM_AUTH_CMD);
			return AdminSecurity(playerid);
		} else {
			return SendClientMessage(playerid, COLOR_GREEN, "[AdmSec]: You have already authenticated.");
		}
	}
	return 1;
}

CMD:admsec(playerid, params[]) 
{
	return cmd_auth(playerid, params);
}


forward AdminSecurity(playerid);
public AdminSecurity(playerid)
{
	new query[512];
	format(query, sizeof(query), "SELECT * FROM FoCo_AdminSec WHERE ID='%d' LIMIT 1", FoCo_Player[playerid][id]);
	mysql_query(query, MYSQL_ADMINSEC, playerid, con);
	return 1;
}

forward pEar_AdminSec_OnQueryFinish(query[], resultid, extraid, connectionHandle);
public pEar_AdminSec_OnQueryFinish(query[], resultid, extraid, connectionHandle)
{
	switch(resultid) {
		case MYSQL_ADMINSEC: {
			mysql_store_result();
			new resultline[512], ID, ASec_IPs[3][45], IPtype[3], question, answer[240], enabled;
			if(mysql_num_rows() > 0) {
				mysql_fetch_row_format(resultline);
				sscanf(resultline, "p<|>ds[45]s[45]s[45]dddds[240]d", ID, ASec_IPs[0], ASec_IPs[1], ASec_IPs[2], IPtype[0], IPtype[1], IPtype[2], question, answer, enabled);
				if(enabled != 1)
				{
                    IsPlayerAuthenticated[extraid] = true;
					return SendErrorMessage(extraid, "AdminSecurity is NOT enabled, you need to enable this ASAP or pEar will KILL you.");
				} else {
					if(GetPVarInt(extraid, "AdmSec_Auth") == ADM_AUTH_LOGIN) {
						new IP[16];
						GetPlayerIp(extraid, IP, sizeof(IP));
						for(new i = 0; i < 3; i++) {
							if(strcmp(ASec_IPs[i], "-1", false) == 0) {
								continue;
							}
							// IP range
							if(IPtype[i] == 1)
							{
								new len = strlen(ASec_IPs[i]);
								new tmp[16];
								format(tmp, sizeof(tmp), "%s", IP);
								strdel(tmp, len, strlen(tmp));
								if(strcmp(ASec_IPs[i], tmp, false) == 0)
								{
								    IsPlayerAuthenticated[extraid] = true;
									mysql_free_result();
									return 1;
								}
							}
							else
							{
								if(strcmp(ASec_IPs[i], IP, false) == 0)
								{
								    IsPlayerAuthenticated[extraid] = true;
									mysql_free_result();
									return 1;
								}
							}
						}
					}
				}
			} else
			{
			    IsPlayerAuthenticated[extraid] = true;
				return SendErrorMessage(extraid, "Something went wrong, you should check the Admin Security Tab on the UCP!");
			}
			SetPVarInt(extraid, "ASec_Question", question);
			SetPVarString(extraid, "ASec_Answer", answer);
			pEar_AdminSec_Authenticate(extraid);
			mysql_free_result();
			return 1;
		}
	}
	return 1;
}

forward pEar_AdminSec_Authenticate(playerid);
public pEar_AdminSec_Authenticate(playerid) 
{
	new string[1024];
	format(string, sizeof(string), "What was the house number and street name you lived in as a child?\nWhat were the last four digits of your childhood telephone number?\nWhat primary school did you attend?\nIn what town or city did you get your first job?\nIn what town or city did you meet your spouse/partner?\nWhat are the last five digits of your drivers licence number?");
	return ShowPlayerDialog(playerid, DIALOG_ADMINSEC_QUESTION, DIALOG_STYLE_LIST, "Admin Authentication - Select correct security question", string, "Next", "Cancel");
}

forward failedloginAdminSec(playerid);
public failedloginAdminSec(playerid)
{
	FailedLoginAttempts[playerid]++;
	if(FailedLoginAttempts[playerid] >= MAX_LOGIN_ATTEMPS) {
		new IP[16], string[128];
		GetPlayerIp(playerid, IP, sizeof(IP));
		format(string, sizeof(string), "%s(%d) failed his admin authentication, IP: %s.", PlayerName(playerid), playerid, IP);
		SendErrorMessage(playerid, "This incident has been logged.");
		AntiCheatMessage(string);
		AdminLog(string);
		SetTimerEx("KickPlayer", 500, false, "d", playerid);
	} else {
		SendErrorMessage(playerid, "Incorrect question or answer, try again.");
		AdminSecurity(playerid);
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    print("pEar_AdminSec");
	//print("ODR_SEC_1");
	switch(dialogid)
	{
		case DIALOG_ADMINSEC_QUESTION: { //Crashes in this shit..
			//print("ODR_SEC_2");
			if(!response) {
			    //print("ODR_SEC_3");
				if(GetPVarInt(playerid, "AdmSec_Auth") == ADM_AUTH_LOGIN) {
				    //print("ODR_SEC_4");
					return failedloginAdminSec(playerid);	
				} else {
				    //print("ODR_SEC_5");
					return SendErrorMessage(playerid, "Didn't complete the authentication. Use /auth if you wish to try again.");
				}
				
			}
			//print("ODR_SEC_6");
			SetPVarInt(playerid, "ASec_QuestionGiven", listitem);
			//print("ODR_SEC_7");
			return ShowPlayerDialog(playerid, DIALOG_ADMINSEC_ANSWER, DIALOG_STYLE_PASSWORD, "Admin Authentication", "Please fill in your admin security authentication answer", "Verify", "Cancel");
		}
		case DIALOG_ADMINSEC_ANSWER: {
			//print("ODR_SEC_8");
			if(!response) {
			    //print("ODR_SEC_9");
				if(GetPVarInt(playerid, "AdmSec_Auth") == ADM_AUTH_LOGIN) {
					//print("ODR_SEC_10");
					return failedloginAdminSec(playerid);
				} else {
				    //print("ODR_SEC_11");
					return SendErrorMessage(playerid, "Didn't complete the authentication. Use /auth if you wish to try again.");
				}
				
			}
			//print("ODR_SEC_12");
			new pass[128];
			GetPVarString(playerid, "ASec_Answer", pass, sizeof(pass));
            //print("ODR_SEC_13");
			new pass_hash[256];
			WP_Hash(pass_hash, sizeof(pass_hash), inputtext);
            //print("ODR_SEC_14");
			if(GetPVarInt(playerid, "ASec_Question") != GetPVarInt(playerid, "ASec_QuestionGiven")) {
			    //print("ODR_SEC_15");
				if(GetPVarInt(playerid, "AdmSec_Auth") == ADM_AUTH_LOGIN) {
					return failedloginAdminSec(playerid);
				} else {
					return SendErrorMessage(playerid, "Failed authentication. Use /auth if you wish to try again.");
				}
				
			}
			//print("ODR_SEC_16");
		 	new cmp = strcmp(pass_hash, pass, false);
		 	//print("ODR_SEC_17");
			if (cmp != 0) {
			    //print("ODR_SEC_18");
				if(GetPVarInt(playerid, "AdmSec_Auth") == ADM_AUTH_LOGIN) {
					return failedloginAdminSec(playerid);
				} else {
					return SendErrorMessage(playerid, "Failed authentication. Use /auth if you wish to try again.");
				}
				
			} else {
			    //print("ODR_SEC_19");
				if(GetPVarInt(playerid, "AdmSec_Auth") == ADM_AUTH_LOGIN) {
					DeletePVar(playerid, "AdmSec_Auth");
				} else {
					SetPVarInt(playerid, "AdmSec_Auth", ADM_AUTH_AUTHENTICATED);
				}
				//print("ODR_SEC_20");
				IsPlayerAuthenticated[playerid] = true;
				SendClientMessage(playerid, COLOR_GREEN, "[AdmSec]: Successfully authenticated.");
				return 1;
			}
		}
	}
    //print("ODR_SEC_21");
	return 0;
}


/*
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
