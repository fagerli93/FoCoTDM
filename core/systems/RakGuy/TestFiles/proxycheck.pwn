#include <YSI\y_hooks>

#define 	DIALOG_PROXY        DIALOG_NO_RESPONSE
#define 	STATUS_CHECK_TIME1 	14400000            //4 Hours
#define 	PROXY_SITES_NUM		3
#define 	TEST_IP				"31.208.67.199"
#define 	PROXY_CHECK_CMD     1
#define 	PROXY_RECHECK_CMD 	3
#define 	MIN_RECHECK_TIME 	60
#define 	MIN_CHECK_TIME 		6

forward SiteOnlineStatus(serverid);
forward OnProxyServerStatusCheck(serverid, response, data[]);
forward OnPlayerProxyCheck(p_sid, response_code, data[]);

new LastProxyCheck;
enum PROXY_SITE_DETAILS
{
	Site_Name[24],
	Site_Url[256]
};

enum PROXY_PLAYER_DET
{
	proxyresponse[PROXY_SITES_NUM],
	Timer:TimerID,
	Responses,
	Sender_AdminID,
	CheckingServer
};

new PROXY_PLAYER[MAX_PLAYERS][PROXY_PLAYER_DET];
new PROXY_MSG[768];
new PROXY_SITES[PROXY_SITES_NUM][PROXY_SITE_DETAILS]=
{
	{"Lookupffs"	,	"lookupffs.com/api.php?ip=%s"},
	{"GetIPIntel"	,	"check.getipintel.net/check.php?ip=%s&contact=rrakguy@gmail.com"},
	{"IP-Hub"		,	"iphub.info/api.php?ip=%s&showtype=1"}
};

new SITE_STATUS[PROXY_SITES_NUM];
new ONLINE_PROXY_SERVERS;
new LastProxyReCheck;

task CheckProxyServerStatus[STATUS_CHECK_TIME1]()
{
	SendAdminMessage(1, "[GUARDIAN]: Proxy server status is being checked.. Please do not use the command for 30 seconds.");
    ONLINE_PROXY_SERVERS=0;
    for(new i=0; i < PROXY_SITES_NUM; i++)
    {
        SITE_STATUS[i] = 3;
    }
	SetTimerEx("SiteOnlineStatus", 0, false, "i", 0);
}

hook OnGameModeInit()
{
	SendAdminMessage(1, "[GUARDIAN]: Proxy server status is being checked.. Please do not use the command for 30 seconds.");
	print("Checking Proxy Sites");
	CheckProxyServerStatus();
}

hook OnPlayerConnect(playerid)
{
	if(PROXY_PLAYER[playerid][TimerID] != Timer:0)
	{
		new Timer:TempID = PROXY_PLAYER[playerid][TimerID];
		PROXY_PLAYER[playerid][TimerID] = Timer:0;
		stop TempID;
	}
	PROXY_PLAYER[playerid][Responses] = -1;
	PROXY_PLAYER[playerid][Sender_AdminID] = -1;
	DebugMsg("P_C_Connect");
	for(new i = 0; i < PROXY_SITES_NUM; i++)
	{
	    PROXY_PLAYER[playerid][proxyresponse][i] = 0;
	}
	PROXY_PLAYER[playerid][CheckingServer]=0;
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	if(PROXY_PLAYER[playerid][TimerID] != Timer:0)
	{
		new Timer:TempID = PROXY_PLAYER[playerid][TimerID];
		PROXY_PLAYER[playerid][TimerID] = Timer:0;
		stop TempID;
	}
	PROXY_PLAYER[playerid][Responses] = -1;
	PROXY_PLAYER[playerid][Sender_AdminID] = -1;
	for(new i = 0; i < PROXY_SITES_NUM; i++)
	{
	    PROXY_PLAYER[playerid][proxyresponse][i] = 0;
	}
	PROXY_PLAYER[playerid][CheckingServer]=0;
	return 1;
}

public SiteOnlineStatus(serverid)
{
	if(serverid<PROXY_SITES_NUM)
	{
		format(PROXY_MSG, sizeof(PROXY_MSG), PROXY_SITES[serverid][Site_Url], TEST_IP);
		SITE_STATUS[serverid] = 3;
		HTTP(serverid, HTTP_POST, PROXY_MSG, "", "OnProxyServerStatusCheck");
		SetTimerEx("SiteOnlineStatus", 2000, false, "i", serverid+1);
	}
	return 1;
}

public OnProxyServerStatusCheck(serverid, response, data[])
{
	print(data);
	if(response==200)
	{
		SITE_STATUS[serverid] = 1;
		ONLINE_PROXY_SERVERS++;
	}
	else
	{
		SITE_STATUS[serverid] = 0;
	}
	return 1;
}

timer CheckPlayerIDForProxy[1000](playerid)
{
	new serverid = PROXY_PLAYER[playerid][CheckingServer];
	if(serverid < PROXY_SITES_NUM)
	{
		if(SITE_STATUS[serverid] == 1)
		{
		    DebugMsg("Sending");
			new cID = serverid*1000 + playerid;
			new PLAYER_IP[16];
			GetPlayerIp(playerid, PLAYER_IP, sizeof(PLAYER_IP));
			format(PROXY_MSG, sizeof(PROXY_MSG), PROXY_SITES[serverid][Site_Url], PLAYER_IP);
			PROXY_PLAYER[playerid][proxyresponse][serverid] = 3;
			HTTP(cID, HTTP_GET, PROXY_MSG, "", "OnPlayerProxyCheck");
		}
		serverid++;
		if(serverid == PROXY_SITES_NUM)
		{
			new Timer:TempID = PROXY_PLAYER[playerid][TimerID];
			PROXY_PLAYER[playerid][TimerID] = Timer:0;
			stop TempID;
		}
	}
	else
	{
		new Timer:TempID = PROXY_PLAYER[playerid][TimerID];
		PROXY_PLAYER[playerid][TimerID] = Timer:0;
		stop TempID;
	}
	PROXY_PLAYER[playerid][CheckingServer] = serverid;
}


public OnPlayerProxyCheck(p_sid, response_code, data[])
{
	new sid = p_sid / 1000;
	new pid = p_sid % 1000;
	PROXY_PLAYER[pid][Responses] += 1;
	if(response_code == 200)
	{
		switch(sid)
		{
			case 0,2:
			{
			    new proxyid = strfind(data, "<proxy>", false);
			    if(proxyid != -1)
			    {
					new response = strval(data[proxyid + 7]);
					if(response == 1)
					{
						PROXY_PLAYER[pid][proxyresponse][sid] = 1;
					}
					else
					{
						PROXY_PLAYER[pid][proxyresponse][sid] = 0;
					}
				}
				else
				{
				    PROXY_PLAYER[pid][proxyresponse][sid] = 2;
				}
			}
			case 1:
			{
				new Float:response = floatstr(data);
				if(response >= 0.98)
				{
					PROXY_PLAYER[pid][proxyresponse][sid] = 1;
				}
				else if(response >= 0.0)
				{
					PROXY_PLAYER[pid][proxyresponse][sid] = 0;
				}
				else
				{
				    PROXY_PLAYER[pid][proxyresponse][sid] = 2;
				}
			}
		}
	}
	if(PROXY_PLAYER[pid][Responses] == ONLINE_PROXY_SERVERS)
	{
		format(PROXY_MSG, sizeof(PROXY_MSG), "[GUARDIAN]: Server has got reply from all Proxy-Tester Sites for %s(%i). Please use /proxycheck %d to view result.", PlayerName(pid), pid, pid);
		SendAdminMessage(1, PROXY_MSG);
		PROXY_PLAYER[pid][CheckingServer]=0;
	}
	return 1;
}

CMD:proxycheck(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new targetid;
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /pcheck [playerid]");
		}
		if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(playerid))
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerID/PlayerName");
		}
		if(PROXY_PLAYER[targetid][Responses] == -1)
		{
			if(gettime() - LastProxyCheck > MIN_CHECK_TIME)
	    	{
 	    		for(new i=0; i < PROXY_SITES_NUM; i++)
			    {
			        PROXY_PLAYER[targetid][proxyresponse][i] = 3;
			    }
			    PROXY_PLAYER[targetid][CheckingServer]=0;
				PROXY_PLAYER[targetid][TimerID] = repeat CheckPlayerIDForProxy(targetid);
				PROXY_PLAYER[targetid][Responses]=0;
				PROXY_PLAYER[targetid][Sender_AdminID]=playerid;
				format(PROXY_MSG, sizeof(PROXY_MSG), "AdmCmd(1): %s %s is checking %s(%d) for Proxy/VPN[Status: {FF6600}Pending].", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
				SendAdminMessage(1, PROXY_MSG);
				LastProxyCheck = gettime();
				AdminLog(PROXY_MSG);
            	IRC_GroupSay(gLeads,IRC_FOCO_LEADS,PROXY_MSG);
			}
			else
		    {
				format(PROXY_MSG, sizeof(PROXY_MSG), "[ERROR]: Please wait %d seconds before using Proxy-Check command.", MIN_CHECK_TIME - (gettime() - LastProxyCheck));
				SendClientMessage(playerid, COLOR_WARNING, PROXY_MSG);
			}
		}
		else
		{
		    if(PROXY_PLAYER[targetid][Responses]>1)
		    {
				PROXY_MSG = "{0000FF}Server Name\t{0000FF}Server Status\t{0000FF}Result\n";
				for(new i = 0; i < PROXY_SITES_NUM; i++)
				{
					format(PROXY_MSG, sizeof(PROXY_MSG), "%s{FF6600}%s\t", PROXY_MSG, PROXY_SITES[i][Site_Name]);
					if(SITE_STATUS[i] == 1)
					{
						if(PROXY_PLAYER[targetid][proxyresponse][i]==1)
						{
							format(PROXY_MSG, sizeof(PROXY_MSG), "%s{00FF00}ONLINE\t{ff0000}PROXY\n", PROXY_MSG);
						}
						else if(PROXY_PLAYER[targetid][proxyresponse][i]==2)
						{
						    format(PROXY_MSG, sizeof(PROXY_MSG), "%s{00FF00}ONLINE\t{FF0066}ERROR\n", PROXY_MSG);
						}
						else if(PROXY_PLAYER[targetid][proxyresponse][i]==3)
						{
          					format(PROXY_MSG, sizeof(PROXY_MSG), "%s{00FF00}ONLINE\t{FF6600}PENDING\n", PROXY_MSG);
						}
						else
						{
							format(PROXY_MSG, sizeof(PROXY_MSG), "%s{00FF00}ONLINE\t{00FF00}HOME\n", PROXY_MSG);
						}
					}
					else
					{
					    if(SITE_STATUS[i] == 3)
						{
						    format(PROXY_MSG, sizeof(PROXY_MSG), "%s{ff6600}PENDING\t{FF0000}NONE\n", PROXY_MSG);
						}
						else
						{
							format(PROXY_MSG, sizeof(PROXY_MSG), "%s{ff0000}OFFLINE\t{FF0000}NONE\n", PROXY_MSG);
						}
					}
				}
				new Dialog_Header[40];
				format(Dialog_Header, sizeof(Dialog_Header), "%.10s's Proxy Details:", PlayerName(targetid));
				ShowPlayerDialog(playerid, DIALOG_PROXY, DIALOG_STYLE_TABLIST_HEADERS, Dialog_Header, PROXY_MSG, "Close", "");
			}
			else
			{
			    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please wait. Server is collecting data from Proxy Checking Servers.");
			}
		}
	}
	return 1;
}

CMD:pcheck(playerid, params[])
{
	return cmd_proxycheck(playerid, params);
}

CMD:pservers(playerid, params[])
{
	return cmd_proxyservers(playerid, params);
}

CMD:proxyservers(playerid, params[])
{
	if(IsAdmin(playerid, PROXY_CHECK_CMD))
	{
		PROXY_MSG = "{0000FF}Server Name\t{0000FF}Server Status\n";
		for(new i = 0; i < PROXY_SITES_NUM; i++)
		{
			format(PROXY_MSG, sizeof(PROXY_MSG), "%s{FF6600}%s\t", PROXY_MSG, PROXY_SITES[i][Site_Name]);
			if(SITE_STATUS[i] == 1)
			{
				format(PROXY_MSG, sizeof(PROXY_MSG), "%s{00FF00}ONLINE\n", PROXY_MSG);
			}
			else if(SITE_STATUS[i] == 3)
			{
			    format(PROXY_MSG, sizeof(PROXY_MSG), "%s{ff6600}PENDING\n", PROXY_MSG);
			}
			else
			{
				format(PROXY_MSG, sizeof(PROXY_MSG), "%s{ff0000}OFFLINE\n", PROXY_MSG);
			}
		}
		ShowPlayerDialog(playerid, DIALOG_PROXY, DIALOG_STYLE_TABLIST_HEADERS, "Proxy Servers", PROXY_MSG, "Close", "");
  	}
	return 1;
}

CMD:recheckserverstatus(playerid, params[])
{
	if(IsAdmin(playerid, PROXY_RECHECK_CMD))
	{
	    if(gettime() - LastProxyReCheck > MIN_RECHECK_TIME)
	    {
	        CheckProxyServerStatus();
	        format(PROXY_MSG, sizeof(PROXY_MSG), "AdmCmd(%i): %s %s has forced system to check Proxy Website Status.", PROXY_RECHECK_CMD, GetPlayerStatus(playerid), PlayerName(playerid));
			SendAdminMessage(PROXY_RECHECK_CMD, PROXY_MSG);
			LastProxyReCheck = gettime();
			AdminLog(PROXY_MSG);
            IRC_GroupSay(gLeads,IRC_FOCO_LEADS,PROXY_MSG);
	    }
	    else
	    {
			format(PROXY_MSG, sizeof(PROXY_MSG), "[ERROR]: Please wait %d seconds before forcing system to re-check Proxy Website Status.", MIN_RECHECK_TIME - (gettime() - LastProxyReCheck));
			SendClientMessage(playerid, COLOR_WARNING, PROXY_MSG);
		}
	}
	return 1;
}

CMD:clearproxycheck(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new targetid;
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /pcheck [playerid]");
		}
		if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(playerid))
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerID/PlayerName");
		}
		if(PROXY_PLAYER[targetid][TimerID] != Timer:0)
		{
			new Timer:TempID = PROXY_PLAYER[targetid][TimerID];
			PROXY_PLAYER[targetid][TimerID] = Timer:0;
			stop TempID;
		}
		PROXY_PLAYER[targetid][Responses] = -1;
		PROXY_PLAYER[targetid][Sender_AdminID] = -1;
		for(new i = 0; i < PROXY_SITES_NUM; i++)
		{
		    PROXY_PLAYER[targetid][proxyresponse][i] = 0;
		}
		PROXY_PLAYER[targetid][CheckingServer]=0;
		format(PROXY_MSG, sizeof(PROXY_MSG), "AdmCmd(1): %s %s has cleared ProxyCheck details of %s(%i).", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
		SendAdminMessage(1, PROXY_MSG);
		AdminLog(PROXY_MSG);
        IRC_GroupSay(gLeads,IRC_FOCO_LEADS,PROXY_MSG);
	}
	return 1;
}


