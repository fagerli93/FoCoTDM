#include <YSI\y_hooks>

#define DIALOG_FoCo			DIALOG_NO_RESPONSE
#define STATUS_CHECK_TIME 	3600000
#define FoCo_SITES_NUM		8
#define WS_CMD_DELAY 4
#define MIN_FoCo_RECHECK_TIME 60
#define FoCo_RECHECK_CMD 4
forward FoCoSiteOnlineStatus(serverid);
forward OnFoCoServerStatusCheck(serverid, response, data[]);

enum FoCo_SITE_DETAILS
{
	Site_Name[24],
	Site_Url[256]
};

new LastFoCoReCheck;
new LastCommandUsed[MAX_PLAYERS];


new FoCo_MSG[768];
new FoCo_SITES[FoCo_SITES_NUM][FoCo_SITE_DETAILS]=
{
	{"FocoTDM - UCP"		,	"www.focotdm.com"},
	{"FocoTDM - Forum"		,	"forum.focotdm.com"},
	{"LS-RP - UCP" 			, 	"www.ls-rp.com"},
	{"LS-RP - Forum"		,	"forum.ls-rp.com"},
	{"FocoGaming"			,	"focogaming.com"},
	{"FocoGaming - Forum"	,	"forum.focogaming.com"},
	{"SA-MP"                ,   "www.sa-mp.com"},
	{"SA-MP - Forum"        ,   "forum.sa-mp.com"}
};

new bool:FoCo_SITE_STATUS[FoCo_SITES_NUM];

task CheckForFoCoServer[STATUS_CHECK_TIME]()
{
	SetTimerEx("FoCoSiteOnlineStatus", 0, false, "i", 0);
}

hook OnGameModeInit()
{
	SendAdminMessage(1, "[GUARDIAN]: FoCo Website(s)'s status is being re-checked..");
	print("Checking FoCo Websites");
	CheckForFoCoServer();
	return 1;
}


public FoCoSiteOnlineStatus(serverid)
{
	print("called");
	if(serverid<FoCo_SITES_NUM)
	{
		FoCo_SITE_STATUS[serverid] = false;
		HTTP(serverid, HTTP_HEAD, FoCo_SITES[serverid][Site_Url], "", "OnFoCoServerStatusCheck");
		SetTimerEx("FoCoSiteOnlineStatus", 2000, false, "i", serverid+1);
	}
	return 1;
}

public OnFoCoServerStatusCheck(serverid, response, data[])
{
	if(response == 200 || response == 5 || response == 6)
	{
		FoCo_SITE_STATUS[serverid] = true;
		printf("%i.%s is ONLINE.", serverid, FoCo_SITES[serverid][Site_Name]);
	}
	else
	{
		FoCo_SITE_STATUS[serverid] = false;
		printf("%s is OFFLINE.", FoCo_SITES[serverid][Site_Name]);
	}
	return 1;
}

CMD:websites(playerid, params[])
{
	new Delay = NetStats_GetConnectedTime(playerid) - LastCommandUsed[playerid];
	if(Delay > WS_CMD_DELAY)
	{
	    FoCo_MSG = "{0066FF}Website Name\t{990099}Website URL\t{996633}Status\n";
	    for(new i = 0; i < FoCo_SITES_NUM; i++)
	    {
			format(FoCo_MSG, sizeof(FoCo_MSG), "%s{0066FF}%s\t{FF6600}%s\t", FoCo_MSG, FoCo_SITES[i][Site_Name], FoCo_SITES[i][Site_Url]);
			if(FoCo_SITE_STATUS[i] == true)
			{
			    format(FoCo_MSG, sizeof(FoCo_MSG), "%s{00FF00}ONLINE\n", FoCo_MSG);
			}
			else
			{
				format(FoCo_MSG, sizeof(FoCo_MSG), "%s{FF0000}OFFLINE\n", FoCo_MSG);
			}
	    }
	    ShowPlayerDialog(playerid, DIALOG_FoCo, DIALOG_STYLE_TABLIST_HEADERS, "Website Status:", FoCo_MSG, "Close", "");
	}
	else
	{
	    format(FoCo_MSG, sizeof(FoCo_MSG), "[ERROR]: Please wait %d seconds before using the command again.", WS_CMD_DELAY - Delay);
		SendClientMessage(playerid, COLOR_WARNING, FoCo_MSG);
	}
	return 1;
}


CMD:rcfocostatus(playerid, params[])
{
	if(IsAdmin(playerid, FoCo_RECHECK_CMD))
	{
	    if(gettime() - LastFoCoReCheck > MIN_FoCo_RECHECK_TIME)
	    {
	        CheckForFoCoServer();
	        format(FoCo_MSG, sizeof(FoCo_MSG), "AdmCmd(%i): %s %s has forced system to check Foco Website Status.", FoCo_RECHECK_CMD, GetPlayerStatus(playerid), PlayerName(playerid));
			SendAdminMessage(FoCo_RECHECK_CMD, FoCo_MSG);
			LastFoCoReCheck = gettime();
			AdminLog(FoCo_MSG);
            IRC_GroupSay(gLeads,IRC_FOCO_LEADS,FoCo_MSG);
	    }
	    else
	    {
			format(FoCo_MSG, sizeof(FoCo_MSG), "[ERROR]: Please wait %d seconds before forcing system to re-check Foco Website Status.", MIN_FoCo_RECHECK_TIME - (gettime() - LastFoCoReCheck));
			SendClientMessage(playerid, COLOR_WARNING, FoCo_MSG);
		}
	}
	return 1;
}



