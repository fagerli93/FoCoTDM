#define FILTERSCRIPT
#define M_S 	10
#define M_S_N 	30
#define M_S_M 	50
#define M_S_L 	5
#define A_C_L 	2 //Level 2+ admins can handle them..
#define MY_G    599
#define AL_G    600
#define M_List  601
#define AL_List 602


#include <a_samp>
#include <sscanf2>
#include <zcmd>
new COLOR[125] = {
0x46597AFF,0x5B5D5EFF,0x2A77A1FF,0x840410FF,0x263739FF,0x86446EFF,0xD78E10FF,0x4C75B7FF,
0xBDBEC6FF,0x5E7072FF/*,0xADB0B0FF,0x656A79FF,0x5D7E8DFF,0x58595AFF,0xD6DAD6FF,0x9CA1A3FF,
0x335F3FFF,0x730E1AFF,0x7B0A2AFF,0x9F9D94FF,0x3B4E78FF,0x732E3EFF,0x691E3BFF,0x96918CFF,
0x515459FF,0x3F3E45FF,0xA5A9A7FF,0x635C5AFF,0x3D4A68FF,0x979592FF,0x421F21FF,0x5F272BFF,
0x8494ABFF,0x767B7CFF,0x646464FF,0x5A5752FF,0x252527FF,0x2D3A35FF,0x93A396FF,0x6D7A88FF,
0x221918FF,0x6F675FFF,0x7C1C2AFF,0x5F0A15FF,0x193826FF,0x5D1B20FF,0x9D9872FF,0x7A7560FF,
0x989586FF,0x848988FF,0x304F45FF,0x4D6268FF,0x162248FF,0x272F4BFF,0x7D6256FF,0xEC6AAEFF,
0x9EA4ABFF,0x9C8D71FF,0x6D1822FF,0x4E6881FF,0x9C9C98FF,0x917347FF,0x661C26FF,0x949D9FFF,
0xA4A7A5FF,0x8E8C46FF,0x341A1EFF,0x6A7A8CFF,0xAAAD8EFF,0xAB988FFF,0x851F2EFF,0x6F8297FF,
0x585853FF,0x9AA790FF,0x601A23FF,0x20202CFF,0xA4A096FF,0xAA9D84FF,0x78222BFF,0x0E316DFF,
0x722A3FFF,0x7B715EFF,0x741D28FF,0x1E2E32FF,0x4D322FFF,0x7C1B44FF,0x2E5B20FF,0x395A83FF,
0x6D2837FF,0xA7A28FFF,0xAFB1B1FF,0x364155FF,0x6D6C6EFF,0x0F6A89FF,0x204B6BFF,0x2B3E57FF,
0x9B9F9DFF,0x6C8495FF,0x4D5D60FF,0xAE9B7FFF,0x406C8FFF,0x1F253BFF,0xAB9276FF,0x134573FF,
0x96816CFF,0x64686AFF,0x105082FF,0xA19983FF,0x385694FF,0x525661FF,0x7F6956FF,0x8C929AFF,
0x596E87FF,0x473532FF,0x44624FFF,0x730A27FF,0x223457FF,0x640D1BFF,0xA3ADC6FF,0x695853FF,
0x9B8B80FF,0x620B1CFF,0x624428FF,0x731827FF,0x1B376DFF*/};

enum RAD
{
	NAME[M_S_N],
	MEMB[M_S_M],
	LEAD,
	M_C,
};
enum GP
{
	GID[M_S],
	G_C,
	DEF,
	LEAD
};
new MyG[MAX_PLAYERS][GP];
new Radios[M_S][RAD];
new R_C;
new Aname[24];
new msg[200];
new ID,j,i;
/////////////////////////////USEFUL STOCKS//////////////////////////////////////
stock SendMessageToGroup(playerid, groupid, MSG[200])
{
	new mes[150];
	new namee[24];
	GetPlayerName(playerid, namee, sizeof(namee));
	format(mes, sizeof(mes), "[G-ID:%i][%i]%s: %s",groupid, playerid, namee, MSG);
	for(i=0; i<Radios[groupid][M_C];i++)
	{
	    ID=Radios[groupid][MEMB][i];
	    SendClientMessage(ID, COLOR[groupid], mes);
	}
	return 1;
}

stock IsPlayerInGroup(playerid, groupid)
{
	for(i=0;i<MyG[playerid][G_C];i++)
	{
	    if(MyG[playerid][GID][i]==groupid)
	    {
	        return 1;
	    }
	}
	return 0;
}

stock RemovePlayerFromGroup(playerid, groupid, Mode)//MODE 1 = Removing player and finding new leader.
//If no Mode 1, its usefull for looping during trashing a GROUP..
{
	///////////Removing player from Group-List///////////
	for(i=0;i<Radios[groupid][M_C];i++)
	{
	    if(Radios[groupid][MEMB][i]==playerid)
	    {
	        Radios[groupid][MEMB][i]=-1;
	        break;
	    }
	}
	/////////Removing group from Player-List/////////
	for(i=0;i<MyG[playerid][G_C];i++)
	{
	    if(MyG[playerid][GID][i]==groupid)
	    {
	        MyG[playerid][GID][i]=-1;
	        break;
	    }
	}
	////////Repairing Player's List/////////
	for(i=0;i<MyG[playerid][G_C];i++)
	{
	    if(MyG[playerid][GID][i]==-1)
	    {
	        MyG[playerid][GID][i]=MyG[playerid][GID][i+1];
	        MyG[playerid][GID][i+1]=-1;
	    }
	}
	////////////////////////////////////////
	MyG[playerid][G_C]--;
	if(Mode>=1)//
	{
		/////Finding the latest Non-Occupied Leader//////
		if(Radios[groupid][LEAD]==playerid)
		{
		    for(j=1;j<Radios[groupid][M_C];j++)
			{
				if(MyG[Radios[groupid][MEMB][j]][LEAD]==-1)
				{
				    Radios[groupid][LEAD]=Radios[groupid][MEMB][j];
				    Radios[groupid][MEMB][0]=Radios[groupid][MEMB][j];
				    Radios[groupid][MEMB][j]=-1;
				    MyG[Radios[groupid][MEMB][j]][LEAD]=groupid;
					format(msg, sizeof(msg), "[NOTICE:] You are now the Leader of Group:%i - %s. Congratulations",groupid, Radios[groupid][NAME]);
					SendClientMessage(playerid, -1, msg);
				}
			}
		}
		//////////////Repairing Group///////////
		for(i=0;i<Radios[groupid][M_C];i++)
		{
		    if(Radios[groupid][MEMB][i]==-1)
		    {
		        Radios[groupid][MEMB][i]=Radios[groupid][MEMB][i+1];
				Radios[groupid][MEMB][i+1]=-1;
			}
		}
		////////////////////////////////////////
		Radios[groupid][M_C]--;
	}
	return 1;
}

DeleteGroup(groupid)
{
	for(i=0;i<Radios[groupid][M_C];i++)
	{
	    RemovePlayerFromGroup(i,groupid,0);
	}
	Radios[groupid][M_C]=0;
	Radios[groupid][LEAD]=-1;
	return 1;
}

stock IsGroupActive(groupid)
{
	if(Radios[groupid][M_C]>0)
	{
	    return 1;
	}
	return 0;
}
stock RemovePlayerFromAllGroups(playerid)
{
	for(i=0;i<MyG[playerid][G_C];i++)
	{
		RemovePlayerFromGroup(playerid, MyG[playerid][GID][i], 1);
	}
	return 1;
}
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////PUBLIC COMMANDS/////////////////////////////////
public OnFilterScriptInit()
{
	for(i=0;i<M_S;i++)
	{
	    Radios[i][LEAD]=-1;
	    for(j=0;j<M_S_M;j++)
	    {
	        Radios[i][MEMB][j]=-1;
	    }
	}
	for(i=0;i<MAX_PLAYERS;i++)
	{
	    MyG[i][DEF]=-1;
	    MyG[i][LEAD]=-1;
	    for(j=0;j<M_S;j++)
	    {
	        MyG[i][GID][j]=-1;
	    }
	}
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	RemovePlayerFromAllGroups(playerid);
}
////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////COMMANDS[Players]////////////////////////////
CMD:creategroup(playerid, params[])
{
	if(R_C==M_S)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Group chat limit reached!");
	}
	else if(MyG[playerid][LEAD]<-1)
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You can create only one group!");
	}
	else
	{
	    new nam[30];
	    if(sscanf(params,"s[30]",nam))
	    {
	    	SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Select a name of your choice!");
	    }
	    else
	    {
			new Cur;
			for(i=0;i<M_S;i++)
			{
			    if(Radios[i][M_C]==0)
			    {
			        Cur=i;
			        break;
			    }
			}
			Radios[Cur][NAME]=nam;
			Radios[Cur][MEMB][Radios[Cur][M_C]]=playerid;
			Radios[Cur][LEAD]=playerid;
			Radios[Cur][M_C]++;
			SendClientMessage(playerid, -1,"[NOTICE:] Group successfully created.");
			format(msg, sizeof(msg), "[G-NOTICE:] Details: Name - %s G-ID - %i",Radios[Cur][NAME], Cur);
			SendClientMessage(playerid, COLOR_NOTICE,msg);
			MyG[playerid][GID][MyG[playerid][G_C]]=Cur;
			MyG[playerid][LEAD]=Cur;
			MyG[playerid][DEF]=Cur;
			MyG[playerid][G_C]++;
			R_C++;
	    }
	}

	return 1;
}

CMD:groupdefault(playerid, params[])
{
	if(sscanf(params,"i",ID))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE:]/groupdefault [GroupID]");
	}
	else
	{
	    if(IsPlayerInGroup(playerid, ID)==1)
	    {
	        MyG[playerid][DEF]=ID;
  			format(msg, sizeof(msg),"[NOTICE:] [GroupID:%i]%s has been made your default group.",ID,Radios[ID][NAME]);
			SendClientMessage(playerid, COLOR_NOTICE, msg);
			SendClientMessage(playerid, COLOR_NOTICE,"[NOTICE:]Use /groupdefault to change your default group.");
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR:]You are not in that specified group");
	    }
	}
	return 1;
}

CMD:gm(playerid, params[])
{
	if(sscanf(params,"s[100]",msg))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "[Usage:] /gm [Text]");
	}
	else
	{
	    SendMessageToGroup(playerid, MyG[playerid][DEF], msg);
	}
	return 1;
}

CMD:sm(playerid, params[])
{
	if(sscanf(params, "is[100]",ID, msg))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "[Usage:] /sm [GroupID] [Text]");
	}
	else if(IsPlayerInGroup(playerid, ID)==0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You are not in the specified group. Ask for invitation");
	}
	else
	{
	    SendMessageToGroup(playerid, ID,msg);
	}
	return 1;
}
CMD:groupleave(playerid, params[])
{
	if(sscanf(params, "i", ID))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "[Usage:] /groupleave [GroupID]");
	}
	else if(IsPlayerInGroup(playerid, ID)==0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You are not in the specified group. What a coincidence? :P");
	}
	else
	{
	    RemovePlayerFromGroup(playerid, ID,1);
	}
	return 1;
}
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////COMMANDS[G-Leaders]/////////////////////////
CMD:groupinvite(playerid, params[])
{
	if(MyG[playerid][LEAD]>-1)
	{
	    if(sscanf(params,"u", ID))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE:]/groupinvite [PlayerID/Part_of_name]");
	    }
	    else if(ID==playerid)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[INFORMATION:] You are dumb!");
		}
		else if(IsPlayerInGroup(ID, MyG[playerid][LEAD]))
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Player already in your group.");
		}
		else
	    {
	        MyG[ID][GID][MyG[ID][G_C]]=MyG[playerid][LEAD];
            MyG[ID][G_C]++;
			Radios[MyG[playerid][LEAD]][MEMB][Radios[MyG[playerid][LEAD]][M_C]]=ID;
            Radios[MyG[playerid][LEAD]][M_C]++;
			format(msg, sizeof(msg),"[NOTICE:] You have been added to GroupID:%i-%s, it has been made your default group.",MyG[playerid][LEAD],Radios[MyG[playerid][LEAD]][NAME]);
			SendClientMessage(ID, COLOR_NOTICE, msg);
			SendClientMessage(ID, COLOR_NOTICE,"[NOTICE:]Use /groupdefault to change your default group.");
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You have to be leader of any group to invite members");
	}
	return 1;
}
CMD:deletemygroup(playerid, params[])
{
	if(MyG[playerid][LEAD]>-1)
	{
	    if(sscanf(params,"i", ID))
	    {
	        SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE:]/deletemygroup [GroupID]-Confirmation");
	    }
	    else if(Radios[ID][LEAD]==playerid)
	    {
			DeleteGroup(ID);
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You have to be leader of any group to use this command");
	}
	return 1;
}
////////////////////////////////////////////////////////////////////////////////
/////////////////////////////ADMIN COMMANDS/////////////////////////////////////
CMD:forcedeletegroup(playerid, params[])
{
	if(isAdmin(playerid)>=A_C_L)
	{
		new reason[20];
		if(sscanf(params, "is[20](No Reason)", ID, reason))
		{
		    SendClientMessage(playerid, COLOR_SYNTAX, "[Usage:] /forcedeletegroup [GroupID] [Reason]");
		}
		else if(IsGroupActive(ID)==0)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Group is inactive.");
		}
		else
		{
		    DeleteGroup(ID);
		    GetPlayerName(playerid, Aname, sizeof(Aname));
		    format(msg, sizeof(msg), "[NOTICE:] GroupID:%i-%s has been successfully deleted.",ID, Radios[ID][NAME]);
		    SendClientMessage(playerid, COLOR_NOTICE, msg);
		    format(msg, sizeof(msg), "AdmCmd(%i): Level-%i Administrator %s has deleted GroupID:%i-%s, Reason: %s", A_C_L, GetPVarInt(playerid, "Admin"), Aname, ID, Radios[ID][NAME], reason);
			SendMessageToOnlineAdmin(msg);
			format(msg, sizeof(msg), "[NOTICE:] Level-%i Administrator %s has deleted GroupID:%i-%s, Reason:%s", GetPVarInt(playerid, "Admin"), Aname, ID, Radios[ID][NAME], reason);
			SendClientMessageToAll(COLOR_NOTICE, msg);
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You are not authorised to use the command");
	}
	return 1;
}
new Dmsg[56*M_S];

CMD:mygroups(playerid, params[])
{
	if(MyG[playerid][G_C]!=0)
	{
	    Dmsg="";
		for(i=0; i<MyG[playerid][G_C];i++)
		{
			format(Dmsg, sizeof(Dmsg), "%sGroupID%i-%s (%i/%i talking)\n", Dmsg, MyG[playerid][GID][i], Radios[MyG[playerid][GID][i]][NAME],Radios[MyG[playerid][GID][i]][M_C], M_S_M);
		}
		ShowPlayerDialog(playerid, AL_G, 2, "My Groups", Dmsg, "Details", "Cancel");
	}
	return 1;
}

new EMSG[109+32*M_S_M];
CMD:grouplist(playerid, params[])
{
	EMSG="";
	for(i=0; i<M_S; i++)
	{
        if(IsGroupActive(i)==1)
        {
			format(EMSG, sizeof(EMSG), "%s[GroupID:%i]%s (%i/%i talking)\n", EMSG, i, Radios[i][NAME], Radios[i][M_C], M_S_M);
		}
	}
	ShowPlayerDialog(playerid, AL_G, 2, "Group List", EMSG, "Details", "Cancel");
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid==MY_G)
	{
	    if(!response)
	    {
	        SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE:] Group list dialog box closed.");
	    }
		else
		{
			ID=GetGroupID(playerid, listitem);
			Dmsg="";
			GetPlayerName(Radios[ID][LEAD], Aname, sizeof(Aname));
			format(Dmsg, sizeof(Dmsg), "Group Name: %s\nCreated By: %s\nGroupID: %i\n\nMembers:\n",Radios[ID][NAME], Aname, ID);
			for(i=0; i<Radios[ID][M_C];i++)
			{
			    GetPlayerName(Radios[ID][MEMB][i], Aname, sizeof(Aname));
				format(Dmsg, sizeof(Dmsg), "%s[%i]%s\t", Dmsg,Radios[ID][MEMB][i], Aname);
				if(i==8)
				{
				    format(Dmsg, sizeof(Dmsg), "%s\n", Dmsg);
				}
			}
			ShowPlayerDialog(playerid, M_List,0, "Group Details", Dmsg, "-_-", "*_*");

		}
	}
	if(dialogid==AL_G)
	{
		if(!response)
	    {
	        SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE:] Group list dialog box closed.");
	    }
		else
		{
			ID=GetGroup(listitem);
			EMSG="";
			GetPlayerName(Radios[ID][LEAD], Aname, sizeof(Aname));
			format(EMSG, sizeof(EMSG), "Group Name: %s\nCreated By: %s\nGroupID: %i\n\nMembers:\n",Radios[ID][NAME], Aname, ID);
			for(i=0; i<Radios[ID][M_C];i++)
			{
			    GetPlayerName(Radios[ID][MEMB][i], Aname, sizeof(Aname));
				format(EMSG, sizeof(EMSG), "%s[%i]%s\t", EMSG,Radios[ID][MEMB][i], Aname);
				if(i==8)
				{
				    format(EMSG, sizeof(EMSG), "%s\n", EMSG);
				}
			}
			ShowPlayerDialog(playerid, AL_List,0, "Group Details",EMSG, "-_-", "*_*");

		}
	}
	return 0;
}


stock GetGroupID(playerid, ListNo)
{
	new count;
	for(i=0; i<MyG[playerid][G_C];i++)
	{
	    if(count==ListNo)
		{
			return MyG[playerid][GID][i];
		}
		count++;
	}
	return 1;
}

stock GetGroup(ListNo)
{
	new count;
	for(i=0; i<R_C; i++)
	{
	    if(IsGroupActive(i)==1)
	    {
	        if(ListNo==count)
	        {
	            return i;
	        }
	    	count++;
	    }
	}
	return 1;
}






