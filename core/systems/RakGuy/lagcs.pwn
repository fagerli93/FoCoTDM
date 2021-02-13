#include <YSI\y_hooks>

#define Dev_Color 0x0033CCFF
#define IsTesting 1
#define LB_AdmLvl 4
#define DIALOG_LCS 599


forward CheckSimilarHP(playerid, AnimID);
new bool:GotShot_DWatch[MAX_PLAYERS];
new AdminsWatching[MAX_PLAYERS][10];
new GotShot_Count[MAX_PLAYERS];

new LB_MSG[250];
new Float:P_HPA[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
	for(new i=0; i<10; i++)
	{
	    AdminsWatching[playerid][i]=-1;
	}
	GotShot_DWatch[playerid]=false;
	GotShot_Count[playerid]=0;
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	format(LB_MSG, sizeof(LB_MSG), "[NOTICE]: %s has logged during DamageLog watch.", PlayerName(playerid));
	SendMessageToAdminsInArray(LB_AdmLvl, LB_MSG, AdminsWatching[playerid], 10);
	for(new i=0; i<10; i++)
	{
	    AdminsWatching[playerid][i]=-1;
	}
	GotShot_DWatch[playerid]=false;
	for(new i=0; i<GetPlayerPoolSize(); i++)
	{
	    new Loc=FindID(AdminsWatching[i], playerid, 10);
	    AdminsWatching[i][Loc]=-1;
	}
	GotShot_Count[playerid]=0;
	return 1;
}

stock FreeSlot(Array[], sizeofArray)
{
	new
		i = 0;
	while (i < sizeofArray && Array[i]!=-1)
	{
		i++;
	}
	if (i == sizeofArray)
	{
		return -1;
	}
	return i;
}

stock FindID(Array[], Number, sizeofArray)
{
	new	i = 0;
	while (i < sizeofArray && Array[i]!=Number)
	{
		i++;
	}
	if (i == sizeofArray)
	{
		return -1;
	}
	return i;
}

stock SendMessageToAdminsInArray(Level, MSG[], Array[], ArraySize)
{
	for(new i=0; i<ArraySize; i++)
	{
	    if(Array[i] != -1)
		{
		    if(IsAdmin(Array[i], Level)==1)
		    {
		        SendClientMessage(Array[i], Dev_Color, MSG);
			}
		}
	}
	return 1;
}

hook OnGameModeInit()
{
	for(new j=0; j<MAX_PLAYERS; j++)
	{
		for(new i=0; i<10; i++)
		{
		    AdminsWatching[j][i]=-1;
		}
	}
}

hook OnPlayerSpawn(playerid)
{
	new Float:T_HPA[2];
	GetPlayerHealth(playerid, T_HPA[0]);
	GetPlayerArmour(playerid, T_HPA[1]);
	P_HPA[playerid] = T_HPA[0] + T_HPA[1];
	
}



/*hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(hittype == 1 && hitid != INVALID_PLAYER_ID && IsNotStanding(hitid)==1)
	{
		SetTimerEx("CheckSimilarHP", GetPlayerPing(playerid)+500, false, "ii", hitid,  GetPlayerAnimationIndex(hitid));
	}
	return 1;
}
*/

public CheckSimilarHP(playerid, AnimID)
{
	new Float:T_HPA[3];
	GetPlayerHealth(playerid, T_HPA[0]);
	GetPlayerArmour(playerid, T_HPA[1]);
	T_HPA[2] = T_HPA[0] + T_HPA[1];
	if(P_HPA[playerid]==T_HPA[2] && GetPlayerState(playerid) != PLAYER_STATE_WASTED)
	{
		new HH_ALib[32], HH_AName[32];
		GetAnimationName(AnimID, HH_ALib, 32, HH_AName, 32);
		format(LB_MSG, sizeof(LB_MSG), "[OnPlayerWeaponShot] Player: %s[%i] striked [AnimID:%i - Name:%s][P/L: %0.2f // Ping: %i]", PlayerName(playerid), playerid, AnimID, HH_AName, NetStats_PacketLossPercent(playerid), GetPlayerPing(playerid));
		CheatLog(LB_MSG);
	    GotShot_Count[playerid]++;
		if(GotShot_DWatch[playerid]==true)
		{
	  		format(LB_MSG, sizeof(LB_MSG), "[OnPlayerWeaponShot] Player: %s[%i] is possibly HHing or is Desync[%i - %s : %s][P/L: %0.2f // Ping: %i]", PlayerName(playerid), playerid, AnimID, HH_ALib, HH_AName, NetStats_PacketLossPercent(playerid), GetPlayerPing(playerid));
	        SendMessageToAdminsInArray(LB_AdmLvl, LB_MSG, AdminsWatching[playerid], 10);
		}
	}
	P_HPA[playerid] = T_HPA[2];
	return 1;
}

CMD:togwatch(playerid, params[])
{
	if(IsAdmin(playerid, LB_AdmLvl)==1)
	{
	    new TargetID;
	    if(sscanf(params, "u", TargetID))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "/togwatch [PlayerID/Name]");
	    }
	    else
	    {
	        if(TargetID==INVALID_PLAYER_ID)
	        {
	            return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player is not connected");
	        }
			if(GotShot_DWatch[TargetID]==true)
			{
			    format(LB_MSG, sizeof(LB_MSG), "AdmCmd(%d) %s %s has disabled Lag.cs watch for %s(%i).", LB_AdmLvl, PlayerName(playerid), GetPlayerStatus(playerid), PlayerName(TargetID), TargetID);
				SendAdminMessage(LB_AdmLvl, LB_MSG);
				GotShot_DWatch[TargetID]=false;
			}
			else if(GotShot_DWatch[TargetID]==false)
			{
			    format(LB_MSG, sizeof(LB_MSG), "AdmCmd(%d) %s %s has enabled Lag.cs watch for %s(%i). /dwatch to spectate values.", LB_AdmLvl, PlayerName(playerid), GetPlayerStatus(playerid), PlayerName(TargetID), TargetID);
				SendAdminMessage(LB_AdmLvl, LB_MSG);
				GotShot_DWatch[TargetID]=true;
			}
	    }
	}
	return 1;
}

CMD:laglist(playerid, params[])
{
	if(IsAdmin(playerid, LB_AdmLvl)==1)
	{
	    new NS_SCount;
	    new LCS_MSG[2400];
		foreach(Player, i)
		{
			if(GotShot_Count[i]>=4)
			{
				format(LCS_MSG, sizeof(LCS_MSG), "%s%s[%i]-TotalStrikes:%i\n", LCS_MSG, PlayerName(i), i,GotShot_Count[i]);
                NS_SCount++;
			}
		}
		if(NS_SCount>0)
			ShowPlayerDialog(playerid, DIALOG_LCS, 0, "Suspected NoSpread Users", LCS_MSG, "Close", "");
		else
		    SendClientMessage(playerid, COLOR_SYNTAX, "[ERROR]: No player striked for NoSpread.cs.");
	}
	return 1;
}

CMD:dwatch(playerid, params[])
{
	if(IsAdmin(playerid, LB_AdmLvl)==1)
	{
	    
	    new TargetID;
	    if(sscanf(params, "u", TargetID))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "/dwatch [PlayerID/Name]");
	    }
	    else
	    {
	        if(TargetID==INVALID_PLAYER_ID)
	        {
	            return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player is not connected");
	        }
	        if(GotShot_DWatch[TargetID]==true)
			{
			    new AvailSlot=FreeSlot(AdminsWatching[TargetID], 10);
				if(AvailSlot==-1)
				{
				    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: WatchSlot Full.");
				}
				else
				{
				    new CurrentSlot=FindID(AdminsWatching[TargetID], playerid, 10);
				    if(CurrentSlot==-1)
				    {
				        format(LB_MSG, sizeof(LB_MSG), "[NOTICE]: %s has started watching ID %s's DamageLog.", PlayerName(playerid), PlayerName(TargetID));
                        SendMessageToAdminsInArray(LB_AdmLvl, LB_MSG, AdminsWatching[TargetID], 10);
					    AdminsWatching[TargetID][AvailSlot]=playerid;
					    format(LB_MSG, sizeof(LB_MSG), "[NOTICE]: You have now watching %s's DamageLog.", PlayerName(TargetID));
					    SendClientMessage(playerid, COLOR_NOTICE,LB_MSG);
					}
					else
					{
					    AdminsWatching[TargetID][CurrentSlot]=-1;
	    				format(LB_MSG, sizeof(LB_MSG), "[NOTICE]: %s has stopped watching ID %s's DamageLog.", PlayerName(playerid), PlayerName(TargetID));
					    SendMessageToAdminsInArray(LB_AdmLvl, LB_MSG, AdminsWatching[TargetID], 10);
					    format(LB_MSG, sizeof(LB_MSG), "[NOTICE]: You have stopped watching %s's DamageLog.", PlayerName(TargetID));
					    SendClientMessage(playerid, COLOR_NOTICE,LB_MSG);
					}
				}
			}
			else if(GotShot_DWatch[TargetID]==false)
			{
                return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Damage Watch is not Enabled. Use /togwatch.");
			}
	    }
	}
	return 1;

}
