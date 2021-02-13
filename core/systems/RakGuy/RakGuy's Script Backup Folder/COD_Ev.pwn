#define FILTERSCRIPT
#define Event_ID_COD 20 //Random.. DUnno shit :@
/*
To be Deleted
*/
#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <foreach>

enum TeamDet
{
	TSkinID,
	Float:team_spawn_x,
	Float:team_spawn_y,
	Float:team_spawn_z,
	Float:team_angle,
	TColor
};

new FoCo_Teams[6][TeamDet]=
{
{0, 1553.67480, -1675.83789, 16.09370, 0.0,0x001233},
{147,1176.52979, -1324.10461, 14.43604,90.0, 0x3F3E45FF},
{46, 1785.46399, -1369.94739, 15.62825, 270.0, 0x979592FF},
{129, 1269.12573, -1544.42224, 13.28697, 180.0, 0xA5A9A7FF},
{123,1367.66504, -1140.71863, 26.11647,90.0,0x231232ff},
{125,1569.87122, -1695.23340, 6.24655,0.0,0x223344ff}
};

new FoCo_Team[MAX_PLAYERS];
new Event_InProgress;
new Event_ID;
new FoCo_Event_Died[MAX_PLAYERS];
/*
To be Deleted till here
*/
enum CODTeamDet
{
	Text:TeamText,
	TeamScore,
	MemberCo
};
enum CODPlayerDet
{
	SpawnID,
	Kills,
	Deaths,
	Spree,
	PTeam
};
enum CODTeamInfo
{
	Team_Name[18],
	Team_Skin,
	Team_Color
};
new Text:CODLeadTeam;
new CODTeams[2][CODTeamDet];
new CODPlayers[MAX_PLAYERS][CODPlayerDet];
new COD_TeamInfo[2][CODTeamInfo]=
{
	{"San Andreas Army", 288, 0x11223311},
	{"Local Terrorists", 107, 0x22113311}
};
new COD_PCurr_Streak[MAX_PLAYERS];
new COD_PlCount;
new COD_Kill_Target;
new Float:COD_TSpawn_1[100][4]=
{
//
};
new Float:COD_TSpawn_2[100][4]=
{
//
};

new FoCo_Event_Leader;
new CODWEAPONS[6][2]={{24,100},{25,25},{32,75},{31,100},{33,25},{9,1}};
new COD_MSG[150];

CMD:codevent(playerid, params[])
{
	COD_Event_Start(playerid);
	return 1;
}
stock COD_CreateTextDraws()
{
	for(new x=0; x<2; x++)
	{
	    format(COD_MSG, sizeof(COD_MSG), "Det: ~w~Team Name - ~g~%s~n~~w~Team Score - ~g~ %i",COD_TeamInfo[x][Team_Name],CODTeams[x][TeamScore]);
	    CODTeams[x][TeamText] = TextDrawCreate(187.500000, 400.0, COD_MSG);
		TextDrawLetterSize(CODTeams[x][TeamText], 0.449999, 1.600000);
	   	TextDrawFont(CODTeams[x][TeamText], 1);
	   	TextDrawAlignment(CODTeams[x][TeamText], 1);
		TextDrawColor(CODTeams[x][TeamText] , 0xffbf00FF);
		TextDrawSetOutline(CODTeams[x][TeamText] , 1);
		TextDrawSetProportional(CODTeams[x][TeamText] , 1);
		TextDrawSetShadow(CODTeams[x][TeamText], 1);
	}
    format(COD_MSG, sizeof(COD_MSG), "Leading: ~w~Team Name - ~g~None~n~~w~Team Score - ~g~ 0~n~~b~Target Score: %i",COD_Kill_Target);
    CODLeadTeam=TextDrawCreate(187.500000, 353.937500, COD_MSG);
	TextDrawLetterSize(CODLeadTeam, 0.449999, 1.600000);
   	TextDrawFont(CODLeadTeam, 1);
   	TextDrawAlignment(CODLeadTeam, 1);
	TextDrawColor(CODLeadTeam , 0xffbf00FF);
	TextDrawSetOutline(CODLeadTeam , 1);
	TextDrawSetProportional(CODLeadTeam , 1);
	TextDrawSetShadow(CODLeadTeam, 1);
	return 1;
}
stock COD_Event_Start(playerid)
{
	Event_ID=Event_ID_COD;
	foreach(Player, i)
    {
	    FoCo_Event_Died[i] = 0;
	    SetPVarInt(i, "InEvent", 0);
		CODPlayers[i][SpawnID]=-1;
        CODPlayers[i][Kills]=0;
        CODPlayers[i][Deaths]=0;
        CODPlayers[i][Spree]=0;
        COD_PCurr_Streak[i]=0;
        CODPlayers[i][PTeam]=-1;
	}
	CODTeams[0][TeamScore]=CODTeams[1][TeamScore]=CODTeams[0][MemberCo]=CODTeams[1][MemberCo]=0;
	FoCo_Event_Leader=-1;
	Event_InProgress = 0;
	COD_Kill_Target=30;//+OnlinePlayers()/10 -----> Is it correct to use like that?;
	COD_PlCount=0;
	COD_CreateTextDraws();
    format(COD_MSG, sizeof(COD_MSG), "[EVENT]: %s %s has started {%06x}[COD]Army vs Terrorist {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_NOTICE >>> 8);
    SendClientMessageToAll(COLOR_NOTICE, COD_MSG);
	return 1;
}
CMD:codleave(playerid, params[])
{
	if(Event_InProgress == 0)
	{
		if(GetPVarInt(playerid, "InEvent")==1)
		{
		    if(Event_ID == Event_ID_COD)
		    {
				COD_Event_Leave(playerid);
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You are not in the event!");
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] There is no event in progress");
	}
	return 1;
}
stock COD_Event_Leave(playerid)
{
    FoCo_Event_Died[playerid] = 1;
	SetPVarInt(playerid, "InEvent", 0);
	CODPlayers[playerid][SpawnID]=-1;
    CODPlayers[playerid][Kills]=-1;
    CODPlayers[playerid][Deaths]=-1;
    CODPlayers[playerid][Spree]=-1;
    COD_PCurr_Streak[playerid]=0;
	TextDrawHideForPlayer(playerid,CODTeams[CODPlayers[playerid][PTeam]][TeamText]);
	TextDrawHideForPlayer(playerid,CODLeadTeam);
	CODPlayers[playerid][PTeam]=-1;
	if(IsPlayerConnected(playerid))
  	{
  	    SetSpawnInfo(playerid,NO_TEAM,FoCo_Teams[FoCo_Team[playerid]][TSkinID], FoCo_Teams[FoCo_Team[playerid]][team_spawn_x], FoCo_Teams[FoCo_Team[playerid]][team_spawn_y], FoCo_Teams[FoCo_Team[playerid]][team_spawn_z],FoCo_Teams[FoCo_Team[playerid]][team_angle], 0,0,0,0,0,0);
        SetPlayerColor(playerid, FoCo_Teams[FoCo_Team[playerid]][TColor]);
		SpawnPlayer(playerid);
  	}
	return 1;
}
stock COD_EditTeam_TextDraw(COD_TeamID)
{
    format(COD_MSG, sizeof(COD_MSG), "Det: ~w~Team Name - ~g~%s~n~~w~Team Score - ~g~ %i",COD_TeamInfo[COD_TeamID][Team_Name],CODTeams[COD_TeamID][TeamScore]);
	TextDrawSetString(CODTeams[COD_TeamID][TeamText], COD_MSG);
	return 1;
}
stock COD_EditLeader_TextDraw()
{
    format(COD_MSG, sizeof(COD_MSG), "Leading: ~w~Team Name - ~g~%s~n~~w~Team Score - ~g~ %i~n~~b~Target Score: %i",COD_TeamInfo[FoCo_Event_Leader][Team_Name],CODTeams[FoCo_Event_Leader][TeamScore],COD_Kill_Target);
	TextDrawSetString(CODLeadTeam, COD_MSG);
	return 1;
}
stock COD_Event_Death(playerid,killerid)
{
    CODPlayers[playerid][Deaths]++;
	if(killerid!=INVALID_PLAYER_ID)
	{
	    CODPlayers[killerid][Kills]++;
   		COD_PCurr_Streak[killerid]++;
	    CODTeams[CODPlayers[killerid][PTeam]][TeamScore]++;
		COD_EditTeam_TextDraw(CODPlayers[killerid][PTeam]);
		if(FoCo_Event_Leader!=-1)
		{
		    if(CODTeams[CODPlayers[killerid][PTeam]][TeamScore]>CODTeams[FoCo_Event_Leader][TeamScore])
		    {
		        FoCo_Event_Leader=CODPlayers[killerid][PTeam];
		        COD_EditLeader_TextDraw();
		    }
			else if(FoCo_Event_Leader==CODPlayers[killerid][PTeam])
			{
			    COD_EditLeader_TextDraw();
			}
		}
		else
		{
		    FoCo_Event_Leader=CODPlayers[killerid][PTeam];
            COD_EditLeader_TextDraw();
		}
		SendClientMessageToAll(-1, "Entering Tripple ifs..");
		if(CODPlayers[killerid][Spree]<COD_PCurr_Streak[killerid])
		{
			SendClientMessageToAll(-1, "Supposed to give him weapon");
		    GivePlayerWeapon(killerid,CODWEAPONS[COD_PCurr_Streak[killerid]][0],CODWEAPONS[COD_PCurr_Streak[killerid]][1]);
		}
		if(CODPlayers[playerid][Spree]<COD_PCurr_Streak[playerid])
		{
		    SendClientMessageToAll(-1, "Supposed to set longest spree");
		    CODPlayers[playerid][Spree]=COD_PCurr_Streak[playerid];
            COD_PCurr_Streak[playerid]=0;
		}
		if(CODTeams[CODPlayers[killerid][PTeam]][TeamScore]==COD_Kill_Target)
		{
		    SendClientMessageToAll(-1, "Supposed to end event");
            COD_Event_End();
		}
	}
	return 1;
}
CMD:codend(playerid, params[])
{
    format(COD_MSG, sizeof(COD_MSG), "[EVENT]: %s %s has ended the event.", GetPlayerStatus(playerid), PlayerName(playerid));
    SendClientMessageToAll(COLOR_NOTICE, COD_MSG);
	COD_Event_End();
	return 1;
}
stock COD_Event_End()
{
    Event_InProgress = 1;
	TextDrawHideForAll(CODLeadTeam);
	TextDrawDestroy(CODLeadTeam);
	if(FoCo_Event_Leader!=-1)
	{
	    format(COD_MSG, sizeof(COD_MSG), "[NOTICE]: %s has won the [COD]Army vs Terrorist", COD_TeamInfo[FoCo_Event_Leader][Team_Name]);
    	SendClientMessageToAll(COLOR_NOTICE, COD_MSG);
	}
	FoCo_Event_Leader=0;
	new Float:COD_KDR;
	foreach(Player, i)
	{
	    if(GetPVarInt(i, "InEvent")==1)
	    {
	       	TextDrawHideForPlayer(i, CODTeams[CODPlayers[i][PTeam]][TeamText]);
	        COD_KDR=((CODPlayers[i][Deaths]==0) ? (float(CODPlayers[i][Kills])/1.0) : (float(CODPlayers[i][Kills])/float(CODPlayers[i][Deaths])));
	        format(COD_MSG, sizeof(COD_MSG), "[EVENT:] Kills : %i - Deaths : %i - KDR : %f",CODPlayers[i][Kills],CODPlayers[i][Deaths],COD_KDR);
            SendClientMessage(i, COLOR_NOTICE, COD_MSG);
	        if(CODPlayers[i][Kills]>CODPlayers[FoCo_Event_Leader][Kills])
	        {
	            FoCo_Event_Leader=i;
	        }
		}
  	}
  	TextDrawDestroy(CODTeams[0][TeamText]);
  	TextDrawDestroy(CODTeams[1][TeamText]);
	COD_KDR=((CODPlayers[FoCo_Event_Leader][Deaths]==0) ? (float(CODPlayers[FoCo_Event_Leader][Kills])/1.0) : (float(CODPlayers[FoCo_Event_Leader][Kills])/float(CODPlayers[FoCo_Event_Leader][Deaths])));
   	format(COD_MSG, sizeof(COD_MSG), "[Player Of the Event:] %s - Kills : %i - Deaths : %i - KDR : %f",PlayerName(FoCo_Event_Leader),CODPlayers[FoCo_Event_Leader][Kills],CODPlayers[FoCo_Event_Leader][Deaths],COD_KDR);
	SendClientMessageToAll(COLOR_NOTICE, COD_MSG);
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent")==1)
	    {
            COD_Event_Leave(i);
		}
		FoCo_Event_Died[i] = 0;
    }
	return 1;
}
CMD:join(playerid, params[])
{
	if(Event_InProgress == 0)
	{
   	    if(FoCo_Event_Died[playerid]==0)
	    {
			if(Event_ID == Event_ID_COD)
			{
				COD_Event_Join(playerid);
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You left the event. And this event is non-rejoinable.");
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] There is no event in progress nigga!");
	}
	return 1;
}
stock COD_Event_Join(playerid)
{
    if(GetPVarInt(playerid, "InEvent")==0)
	{
	    /*To be deleted from*/
	    FoCo_Team[playerid]=GetPVarInt(playerid, "TeamID");
        /*To be deleted till*/
		SetPVarInt(playerid, "InEvent", 1);
		ResetPlayerWeapons(playerid);
		SetPlayerVirtualWorld(playerid, 1500);
		if(COD_PlCount%2==0)//COPS
		{
			CODPlayers[playerid][SpawnID]=CODTeams[0][MemberCo];
		    CODPlayers[playerid][Kills]=0;
		    CODPlayers[playerid][Deaths]=0;
		    CODPlayers[playerid][Spree]=0;
		    COD_PCurr_Streak[playerid]=0;
		  	CODPlayers[playerid][PTeam]=0;
			SetSpawnInfo(playerid, NO_TEAM,COD_TeamInfo[0][Team_Skin],COD_TSpawn_1[CODPlayers[playerid][SpawnID]][0],COD_TSpawn_1[CODPlayers[playerid][SpawnID]][1],COD_TSpawn_1[CODPlayers[playerid][SpawnID]][2],COD_TSpawn_1[CODPlayers[playerid][SpawnID]][3],0,0,0,0,0,0);
			SetPlayerPos(playerid,COD_TSpawn_1[CODPlayers[playerid][SpawnID]][0],COD_TSpawn_1[CODPlayers[playerid][SpawnID]][1],COD_TSpawn_1[CODPlayers[playerid][SpawnID]][2]);
			SetPlayerFacingAngle(playerid,COD_TSpawn_1[CODPlayers[playerid][SpawnID]][3]);
			SetPlayerSkin(playerid, COD_TeamInfo[0][Team_Skin]);
			SetPlayerColor(playerid,COD_TeamInfo[0][Team_Color]);
			CODTeams[0][MemberCo]++;
			TextDrawShowForPlayer(playerid,CODTeams[0][TeamText]);
		}
		else//Crim
		{
			CODPlayers[playerid][SpawnID]=CODTeams[1][MemberCo];
		    CODPlayers[playerid][Kills]=0;
		    CODPlayers[playerid][Deaths]=0;
		    CODPlayers[playerid][Spree]=0;
		    COD_PCurr_Streak[playerid]=0;
		  	CODPlayers[playerid][PTeam]=1;
		  	SetSpawnInfo(playerid, NO_TEAM,COD_TeamInfo[1][Team_Skin],COD_TSpawn_2[CODPlayers[playerid][SpawnID]][0],COD_TSpawn_2[CODPlayers[playerid][SpawnID]][1],COD_TSpawn_2[CODPlayers[playerid][SpawnID]][2],COD_TSpawn_2[CODPlayers[playerid][SpawnID]][3],0,0,0,0,0,0);
            SetPlayerPos(playerid,COD_TSpawn_2[CODPlayers[playerid][SpawnID]][0],COD_TSpawn_2[CODPlayers[playerid][SpawnID]][1],COD_TSpawn_2[CODPlayers[playerid][SpawnID]][2]);
			SetPlayerFacingAngle(playerid,COD_TSpawn_2[CODPlayers[playerid][SpawnID]][3]);
			SetPlayerSkin(playerid, COD_TeamInfo[1][Team_Skin]);
			SetPlayerColor(playerid,COD_TeamInfo[1][Team_Color]);
		  	CODTeams[1][MemberCo]++;
		  	TextDrawShowForPlayer(playerid,CODTeams[1][TeamText]);
		}
		TextDrawShowForPlayer(playerid,CODLeadTeam);
		GivePlayerWeapon(playerid,CODWEAPONS[0][0],CODWEAPONS[0][1]);
		COD_PlCount++;
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You are already in event.");
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
    FoCo_Event_Died[playerid] = 0;
    SetPVarInt(playerid, "InEvent", 0);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	COD_Event_Leave(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(GetPVarInt(playerid, "InEvent")==1&&Event_InProgress == 0)
	{
		if(Event_ID==Event_ID_COD)
		{
			COD_Event_Spawn(playerid);
		}
	}
	return 1;
}

stock COD_Event_Spawn(playerid)
{
	for(new i = 0; i<=CODPlayers[playerid][Spree]; i++)
	{
	    GivePlayerWeapon(playerid, CODWEAPONS[i][0], CODWEAPONS[i][1]);
	}
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(GetPVarInt(playerid, "InEvent")==1&&Event_InProgress == 0)
	{
		if(Event_ID==Event_ID_COD)
		{
			COD_Event_Death(playerid,killerid);
		}
	}
	return 1;
}

/////////////////////////////BELOW ARE TEST PURPOSE SHITS///////////////////////

CMD:eventinfo(playerid, params[])
{
	new CODID;
	if(sscanf(params, "u", CODID))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE:] /eventinfo [PlayerID/Part_Of_Name]");
	}
	else
	{
	    if(IsPlayerConnected(CODID))
	    {
			format(COD_MSG, sizeof(COD_MSG),"Name: %s - Kills: %i - Deaths: %i - TeamID: %i - Streak : %i",PlayerName(CODID), CODPlayers[CODID][Kills],CODPlayers[CODID][Deaths], CODPlayers[CODID][PTeam],COD_PCurr_Streak[CODID]);
			SendClientMessage(playerid, COLOR_NOTICE, COD_MSG);
	   		format(COD_MSG, sizeof(COD_MSG),"TeamName: %s - TeamSkin: %i - SpawnID: %i - Long-Streak: %i", COD_TeamInfo[CODPlayers[CODID][PTeam]][Team_Name],COD_TeamInfo[CODPlayers[CODID][PTeam]][Team_Skin],CODPlayers[CODID][SpawnID],CODPlayers[CODID][Spree]);
			SendClientMessage(playerid, COLOR_NOTICE, COD_MSG);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:]Player not online.");
		}
	}
	return 1;
}
CMD:codclear(playerid, params[])
{
    FoCo_Event_Died[playerid] = 0;
	SetPVarInt(playerid, "InEvent", 0);
	TextDrawHideForPlayer(playerid, CODTeams[CODPlayers[playerid][PTeam]][TeamText]);
	TextDrawHideForPlayer(playerid, CODLeadTeam);
	return 1;
}

CMD:help(playerid)
{
	SendClientMessageToAll(-1, "/codclear, /eventinfo, /join, /codend, /codleave, /codevent");
	return 1;
}

public OnFilterScriptInit()
{
    Event_InProgress = 1;
	return 1;
}

