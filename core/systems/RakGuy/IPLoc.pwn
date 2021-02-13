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
* Filename: iploc.pwn                                                        	 *
* Author:  RakGuy                                                                *
*********************************************************************************/
#define LOC_ID DIALOG_NO_RESPONSE
#define LOC_CMD_LMT 1
new LOC_MSG[2000];

forward IPResponse(index, response_code, data[]);

enum GetDeT
{
	L_SUCCESS[8],
	L_COUNTRY[25],
	L_COUNTRY_CODE[10],
	L_REGION_CODE[10],
	L_REGION_NAME[25],
	L_CITY[25],
	L_IP_CODE[20],
	L_LATITUDE[25],
	L_LONGITUDE[25],
	L_TIME_ZONE[20],
	L_ISP_NAME[60],
	L_ORGANIZATION_NAME[60],
	L_AS_NAME[60],
	L_IP_ADDRESS[16]
};

new PlayerLoc[GetDeT];

stock CheckIP(playerid, IP[])
{
	format(LOC_MSG, sizeof(LOC_MSG), "ServMsg: Server requested IP-API for details of IP:%s [Req By: %s].", IP, PlayerName(playerid));
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, LOC_MSG);
 	format(LOC_MSG, sizeof(LOC_MSG), "ip-api.com/csv/%s", IP);
	HTTP(playerid, HTTP_GET, LOC_MSG, "", "IPResponse");
	return 1;
}

CMD:getploc(playerid, params[])
{
    new L_IPADD[16];
	new L_PID;
	if(IsAdmin(playerid, 1)==1)
	{
	    if(sscanf(params, "u", L_PID))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /getip [PlayerID/Part_of_Name]");
	    }
	    if(L_PID == INVALID_PLAYER_ID)
       	{
       		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid Player ID/Name.");
       	}
	    else
	    {
	        format(LOC_MSG, sizeof(LOC_MSG), "AdmCmd(%i): %s %s used the location finder command on %s[%i].", LOC_CMD_LMT, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(L_PID), L_PID);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, LOC_MSG);
			SendAdminMessage(4, LOC_MSG);
			GetPlayerIp(L_PID, L_IPADD, sizeof(L_IPADD));
			format(LOC_MSG, sizeof(LOC_MSG), "Name: %s[%i] IP: %s", PlayerName(L_PID), L_PID, L_IPADD);
			SendClientMessage(playerid, COLOR_SYNTAX, LOC_MSG);
		    CheckIP(playerid, L_IPADD);
		}
	}
	return 1;
}


CMD:iploc(playerid, params[])
{
	new IPADD[4];
	if(IsAdmin(playerid, 1)==1)
	{
		if(sscanf(params, "p<.>iiii", IPADD[0], IPADD[1], IPADD[2], IPADD[3]))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /iploc IP_Address[xxx.xxx.xxx.xxx]");
		}
		else
		{
			new IPAD_S[24];
			format(IPAD_S, sizeof(IPAD_S), "%i.%i.%i.%i",IPADD[0], IPADD[1], IPADD[2], IPADD[3]);
			CheckIP(playerid, IPAD_S);
			return 1;
		}
	}
	return 1;
}


public IPResponse(index, response_code, data[])
{
    if(response_code == 200)
    {
        if(data[0]=='s')
        {
            new s_Cnt;
            for(new i=0; i<=14; i++)
			{
			    if(strfind(data, ",,",true)!=-1)
			    {
			        s_Cnt=strfind(data, ",,",true);
			        new S_Size;
					S_Size=strlen(data)+10;
					new MSG_Splitter[200];
					strmid(MSG_Splitter, data, 0, s_Cnt+1);
					strdel(data, 0, s_Cnt+1);
					format(data, S_Size, "%sNo_Info%s", MSG_Splitter, data);
				}
			}
			new L_Cont[200];
			sscanf(data, "p<,>s[8]s[25]s[10]s[10]s[25]s[25]s[10]s[200]",PlayerLoc[L_SUCCESS],PlayerLoc[L_COUNTRY],PlayerLoc[L_COUNTRY_CODE],PlayerLoc[L_REGION_CODE],PlayerLoc[L_REGION_NAME],PlayerLoc[L_CITY],PlayerLoc[L_IP_CODE], L_Cont);
			sscanf(L_Cont, "p<,>s[25]s[25]s[20]s[60]s[60]s[60]s[16]",PlayerLoc[L_LATITUDE],PlayerLoc[L_LONGITUDE],PlayerLoc[L_TIME_ZONE],PlayerLoc[L_ISP_NAME],PlayerLoc[L_ORGANIZATION_NAME],PlayerLoc[L_AS_NAME],PlayerLoc[L_IP_ADDRESS]);
			format(LOC_MSG, sizeof(LOC_MSG), "{%06x}Status\t\t\t\t%s\n{%06x}COUNTRY\t\t\t%s\nCOUNTRY_CODE\t\t%s\nREGION_CODE\t\t\t%s\nREGION_NAME\t\t\t%s\nCITY\t\t\t\t%s\nIP_CODE\t\t\t%s\n",0x43BFC7>>>8,PlayerLoc[L_SUCCESS],-1>>>8,PlayerLoc[L_COUNTRY],PlayerLoc[L_COUNTRY_CODE],PlayerLoc[L_REGION_CODE],PlayerLoc[L_REGION_NAME],PlayerLoc[L_CITY],PlayerLoc[L_IP_CODE]);
			format(LOC_MSG, sizeof(LOC_MSG), "%sLATITUDE\t\t\t%s\nLONGITUDE\t\t\t%s\nTIME_ZONE\t\t\t%s\nISP_NAME\t\t\t%s\nORGANIZATION_NAME\t\t%s\nAS_NAME\t\t\t%s\nIP_ADDRESS\t\t\t%s",LOC_MSG,PlayerLoc[L_LATITUDE],PlayerLoc[L_LONGITUDE],PlayerLoc[L_TIME_ZONE],PlayerLoc[L_ISP_NAME],PlayerLoc[L_ORGANIZATION_NAME],PlayerLoc[L_AS_NAME],PlayerLoc[L_IP_ADDRESS]);
  		}
		else
		{
		    sscanf(data, "p<,>s[8]s[60]s[16]",PlayerLoc[L_SUCCESS],PlayerLoc[L_AS_NAME],PlayerLoc[L_IP_ADDRESS]);
			format(LOC_MSG, sizeof(LOC_MSG), "{%06x}Status\t\t\t%s\n{%06x}IP_ADDRESS\t\t%s",COLOR_WARNING>>>8,PlayerLoc[L_SUCCESS],-1>>>8,PlayerLoc[L_IP_ADDRESS]);
		}
		ShowPlayerDialog(index, LOC_ID, DIALOG_STYLE_MSGBOX, "IP Information:", LOC_MSG, "Close", "");
	}
    else
    {
		SendClientMessage(index, 0xFFFFFFFF, "Error: Please contact the scripter.");
    }
	return 1;
}
