#include <YSI\y_hooks>

#define PROXYSTRINGIP "winmxunlimited.net/api/proxydetection/v1/query/?ip=%s"
#define PROXYSTRINGERROR "[ERROR]: Server is unavailable. Please contact RakGuy."

#define PD_ANTISPAM_DELAY 1000

forward ProxyDetection(playerid, response_code, data[]);
forward SendProxyRequest(playerid, targetid);
new PD_AntiSpamDelay;
new IP_MSG[300];

public ProxyDetection(playerid, response_code, data[])
{
    if(response_code == 200)
	{
	    new ResponseName[60];
	    switch(data[0])
	    {
	        case 'T':
	        {
				ResponseName="Tor"#"{CD0000}""(Proxy Internet)";
	        }
	        case 'P':
	        {
	            ResponseName="Public"#"{CD0000}""(Proxy Internet)";
	        }
	        case '0':
	        {
				ResponseName="Private"#"{33AA33}""(Home Internet)";
	        }
	        case 'I':
	        {
				ResponseName=""#"{800000}""Invalid IP";
			}
		}
		format(IP_MSG, sizeof(IP_MSG), "-Response for %s: "#"{2641FE}""%s", PlayerName(playerid), ResponseName);
		SendAdminMessage(1, IP_MSG);
	}
	else
	{
	    return SendAdminMessage(1, PROXYSTRINGERROR);
	}
	return 1;
}

CMD:proxytest(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new pd_targetid;
		if(sscanf(params, "u", pd_targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /proxytest [Player_ID/Name]");
		}
		if(pd_targetid == INVALID_PLAYER_ID)
       	{
       		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid Player ID/Name.");
       	}
		else
		{
		    PD_AntiSpamDelay+=PD_ANTISPAM_DELAY;
			format(IP_MSG, sizeof(IP_MSG), "AdmCmd(%i) %s %s has requested winmx to detect proxy of %s (%i).[Delay %i]",1, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(pd_targetid), pd_targetid, PD_AntiSpamDelay);
			SendAdminMessage(1, IP_MSG);
			SetTimerEx("SendProxyRequest", PD_AntiSpamDelay, false, "i", playerid, pd_targetid);
		}
	}
	return 1;
}

public SendProxyRequest(playerid, targetid)
{
    new TargetIP[16];
    GetPlayerIp(targetid, TargetIP, 16);
    format(IP_MSG, sizeof(IP_MSG), PROXYSTRINGIP, TargetIP);
   	HTTP(targetid, HTTP_GET, IP_MSG, "", "ProxyDetection");
    PD_AntiSpamDelay-=PD_ANTISPAM_DELAY;
	return 1;
}



