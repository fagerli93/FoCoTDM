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
* Filename: rulesystem.pwn                                                       *
* Author: dr_vista                                                               *
*********************************************************************************/

#include <YSI\y_hooks>

enum e_Rules
{
	rulestext[156],
	id
};

new
	rulescnt = 0,
	ruleslist[50][e_Rules];

new
	INI:ruleshandle;
	
/*	-> variables.pwn
new	
	rulestxt[7800];
*/

INI:rules[list](name[], value[])
{
	new rulename[8], pos, formatedstr[156];
	strcat(rulename, name);
	pos = strfind(rulename, "_", true);
	strdel(rulename, 0, pos + 1);
	ruleslist[rulescnt][id] = strval(rulename);
	format(ruleslist[rulescnt][rulestext], 156, "%s", value);
	
	if(!isnull(ruleslist[rulescnt][rulestext]))
	{
		format(formatedstr, sizeof(formatedstr), "%d ) %s \n", rulescnt, ruleslist[rulescnt][rulestext]);
		strcat(rulestxt, formatedstr);
	}
	
	rulescnt++;
}

hook OnGameModeInit()
{
	for(new i = 0; i < 50; i++)
	{
		for(new k = 0; k < 50; k++)
		{
			ruleslist[i][rulestext][k] = 0;
		}
	}

	format(rulestxt, sizeof(rulestxt), "\0");	
	INI_Load("rules.ini");

}

CMD:rules(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_RULES, DIALOG_STYLE_MSGBOX, "Rules", rulestxt, "Close","");

	return 1;
}

CMD:addrule(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_RULES))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new rule[156], namestr[9], lastid;
		if(sscanf(params, "s[156]", rule))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /addrule [rulestext]");
			return 1;
		}

		for(new i = 0; i < 50; i++)
		{
		    if(ruleslist[i][rulestext][0] != '\0')
		    {
		    	lastid = ruleslist[i][id];
			}
		}

		format(namestr, sizeof(namestr), "rule_%d", lastid+1);

		ruleshandle = INI_Open("rules.ini");
		INI_SetTag(ruleshandle, "list");
		INI_WriteString(ruleshandle, namestr, rule);
		INI_Close(ruleshandle);

		rulescnt = 0;

		for(new i = 0; i < 50; i++)
		{
			for(new k = 0; k < 50; k++)
			{
				ruleslist[i][rulestext][k] = 0;
			}
  		}

		format(rulestxt, sizeof(rulestxt), "\0");	
		INI_Load("rules.ini");
		
		SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: Rule successfully added.");
	}

	return 1;
}

CMD:editrule(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_RULES))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new rule[156], namestr[9], rid;

		if(sscanf(params, "ds[156]",rid,rule))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /editrule [id] [rulestext]");
			return 1;
		}

		ruleshandle = INI_Open("rules.ini");
		INI_SetTag(ruleshandle, "list");

		format(namestr, sizeof(namestr), "rule_%d", ruleslist[rid][id]);
		INI_RemoveEntry(ruleshandle, namestr);
		INI_WriteString(ruleshandle, namestr, rule);
		INI_Close(ruleshandle);

		rulescnt = 0;

		for(new i = 0; i < 50; i++)
		{
			for(new k = 0; k < 50; k++)
			{
				ruleslist[i][rulestext][k] = 0;
			}
  		}

		format(rulestxt, sizeof(rulestxt), "\0");	
		INI_Load("rules.ini");
		
		SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: Rule successfully edited.");
	}

	return 1;
}

CMD:removerule(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_RULES))
	{
		if(GetPVarInt(playerid, "AdmSec_Auth") != ADM_AUTH_AUTHENTICATED) {
			return SendErrorMessage(playerid, "You are accessing a sensitive command. Please use /auth to authenticate first.");
		}
		new namestr[9], rid;

		if(sscanf(params, "d",rid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /removerule [id]");
			return 1;
		}

		strdel(ruleslist[rid][rulestext], 0, 156);
	    format(namestr, sizeof(namestr), "rule_%d", ruleslist[rid][id]);
		ruleshandle = INI_Open("rules.ini");
		INI_SetTag(ruleshandle, "list");
	    INI_RemoveEntry(ruleshandle, namestr);

		INI_Close(ruleshandle);

		for(new i = 0; i < 50; i++)
		{
			for(new k = 0; k < 50; k++)
			{
				ruleslist[i][rulestext][k] = 0;
			}
  		}


		rulescnt = 0;
		format(rulestxt, sizeof(rulestxt), "\0");	
		INI_Load("rules.ini");
		
		SendClientMessage(playerid, COLOR_NOTICE, "[INFO]: Rule successfully removed.");
	}

	return 1;
}