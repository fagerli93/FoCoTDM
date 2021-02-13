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
* Filename:  votesystem.pwn                                                      *
* Author:    Marcel                                                              *
*********************************************************************************/


CMD:startvote(playerid, params[])
{
	if(IsAdmin(playerid, 2))
	{
		ShowPlayerDialog(playerid, DIALOG_VOTE, DIALOG_STYLE_INPUT, "Vote", "Please put the question you wish to ask for the vote.", "Continue", "Close");
	}
	return 1;
}

CMD:endvote(playerid, params[])
{
	if(IsAdmin(playerid, 2))
	{
		if(FoCo_Vote == 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "There is no vote question set.");
			return 1;
		}
		FoCo_Vote = 0;
		FoCo_Vote_Response1 = 0;
		FoCo_Vote_Response2 = 0;
		FoCo_Vote_Response3 = 0;
		SendClientMessage(playerid, COLOR_WHITE, "Vote Ended");
	}
	return 1;
}

CMD:vote(playerid, params[])
{
	if(FoCo_Vote == 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "There is nothing to vote on");
		return 1;
	}
	if(GetPVarInt(playerid, "Voted_Yet") == 1)
	{
		SendClientMessage(playerid, COLOR_WARNING,  "[ERROR]: You have already voted.");
		return 1;
	}
	new string[128], response;
	if (sscanf(params, "i", response))
	{
		SendClientMessage(playerid, COLOR_GREEN, "=================[VOTE]================");
		format(string, sizeof(string), "Question: %s", FoCo_Vote_Question);
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Answer 1: %s", FoCo_Vote_Answer1);
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Answer 2: %s", FoCo_Vote_Answer2);
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Answer 3: %s", FoCo_Vote_Answer3);
		SendClientMessage(playerid, COLOR_WHITE, string);
		SendClientMessage(playerid, COLOR_GREEN, "=======================================");
		format(string, sizeof(string), "[USAGE]: {%06x}/vote{%06x} [Answer Number]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		return 1;
	}

	if(response > 3 || response < 1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: 1 - 3 only");
		return 1;
	}

	switch(response)
	{
		case 1:
		{
			FoCo_Vote_Response1++;
		}
		case 2:
		{
			FoCo_Vote_Response2++;
		}
		case 3:
		{
			FoCo_Vote_Response3++;
		}
	}
	SendClientMessage(playerid, COLOR_WHITE, "[VOTE]: Vote submitted!");
	SetPVarInt(playerid, "Voted_Yet", 1);
	return 1;
}

CMD:votes(playerid, params[])
{
	if(FoCo_Vote == 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "There is no vote question set.");
		return 1;
	}
	new string[128];
	SendClientMessage(playerid, COLOR_GREEN, "================[VOTES]================");
	format(string, sizeof(string), "Question: %s", FoCo_Vote_Question);
	SendClientMessage(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "A1 Responses: %d", FoCo_Vote_Response1);
	SendClientMessage(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "A2 Responses: %d", FoCo_Vote_Response2);
	SendClientMessage(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "A3 Responses: %d", FoCo_Vote_Response3);
	SendClientMessage(playerid, COLOR_WHITE, string);
	SendClientMessage(playerid, COLOR_GREEN, "=======================================");
	return 1;
}

hook OnDialogResponse(playerid,dialogid,response,listitem,inputtext[])
{
	switch(dialogid)
	{
	    case DIALOG_VOTE:
		{
			if(!response)
			{
				return 1;
			}

			new ssstring[128];
			format(ssstring, sizeof(ssstring), "%s", inputtext);
			FoCo_Vote_Question = ssstring;
			ShowPlayerDialog(playerid, DIALOG_VOTE2, DIALOG_STYLE_INPUT, "Answer 1", "Select the first answer", "Continue", "Close");
			return 1;
		}
		case DIALOG_VOTE2:
		{
			if(!response)
			{
				return 1;
			}

			new ssstring[40];
			format(ssstring, sizeof(ssstring), "%s", inputtext);
			FoCo_Vote_Answer1 = ssstring;
			ShowPlayerDialog(playerid, DIALOG_VOTE3, DIALOG_STYLE_INPUT, "Answer 2", "Select second answer", "Continue", "Close");
			return 1;
		}
		case DIALOG_VOTE3:
		{
			if(!response)
			{
				return 1;
			}

			new ssstring[40];
			format(ssstring, sizeof(ssstring), "%s", inputtext);
			FoCo_Vote_Answer2 = ssstring;
			ShowPlayerDialog(playerid, DIALOG_VOTE4, DIALOG_STYLE_INPUT, "Answer 3", "Select third answer", "Continue", "Close");
			return 1;
		}
		case DIALOG_VOTE4:
		{
			if(!response)
			{
				return 1;
			}

			new ssstring[40];
			format(ssstring, sizeof(ssstring), "%s", inputtext);
			FoCo_Vote_Answer3 = ssstring;

			new sssstring[128], adname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, adname, sizeof(adname));
			format(sssstring, sizeof(sssstring), "[AdmCMD]: %s %s has started a vote. /vote for more information!", GetPlayerStatus(playerid), adname);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, sssstring);
			SendAdminMessage(0,sssstring);
			foreach(Player, i)
			{
				SetPVarInt(i, "Voted_Yet", 0);
			}
			FoCo_Vote = 1;
			return 1;
		}
	}
	return 1;
}
