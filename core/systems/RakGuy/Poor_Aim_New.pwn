#include <YSI\y_hooks>

#define PAB_CountLimit 5
#define PAB_CMDLMT 1
#define PAB_LOGLMT 15
#define PAB_ClearLogLMT 4

#define DIALOG_PAB 536

new PAB_MSG[2400];
new PAB_Count[MAX_PLAYERS];
new PAB_TCount[MAX_PLAYERS];
new Float:PAB_LOG[MAX_PLAYERS][PAB_LOGLMT][2];


stock Float:GetDistanceBetweenVectors(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    return VectorSize(x1-x2, y1-y2, z1-z2);
}

stock AB_ClearLog(playerid)
{
	for(new i=0; i<14; i++)
	{
	    PAB_LOG[playerid][i][0]=0.0;
	    PAB_LOG[playerid][i][1]=0.0;
	}
    PAB_Count[playerid]=-1;
    PAB_TCount[playerid]=0;
	return 1;
}


hook OnPlayerConnect(playerid)
{
   	AB_ClearLog(playerid);
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	if(PAB_TCount[playerid]>3)
	{
		format(PAB_MSG, sizeof(PAB_MSG), "%s (%i) logged with aimbot warnings[Count: %d].", PlayerName(playerid), playerid,PAB_TCount[playerid]);
	    AntiCheatMessage(PAB_MSG);
	}
	AB_ClearLog(playerid);
	return 1;
}
/*
public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(hittype == BULLET_HIT_TYPE_PLAYER)
	{
		new Float:fOriginX, Float:fOriginY, Float:fOriginZ,Float:fHitPosX, Float:fHitPosY, Float:fHitPosZ;
		GetPlayerLastShotVectors(playerid, fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);
		new Float:BulletDistance = GetDistanceBetweenVectors(fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);
		new Float:AB_PlayerLoc[3];
		GetPlayerPos(hitid,AB_PlayerLoc[0],AB_PlayerLoc[1],AB_PlayerLoc[2]);
		new Float:AB_Distance = GetPlayerDistanceFromPoint(playerid, AB_PlayerLoc[0],AB_PlayerLoc[1],AB_PlayerLoc[2]);
		if(BulletDistance<=3.1 && AB_Distance>=10.0 && AB_Distance<250.0 && AB_Distance - BulletDistance > 5.0)
		{
		    if(PAB_Count[playerid]==-1)
		    {
		        PAB_Count[playerid]++;
		    }
		    PAB_TCount[playerid]++;
            format(PAB_MSG, sizeof(PAB_MSG), "[Poor/Pro_Aimbot]%s (%d) :(BulletDist.: %f | PlayerDist.: %f)].", PlayerName(playerid), playerid, BulletDistance, AB_Distance);
            CheatLog(PAB_MSG);
			PAB_LOG[playerid][PAB_Count[playerid]][0]=BulletDistance;
		    PAB_LOG[playerid][PAB_Count[playerid]][1]=AB_Distance;
		    PAB_Count[playerid]++;
		    if(PAB_Count[playerid]%PAB_CountLimit == 0)
		    {
				format(PAB_MSG, sizeof(PAB_MSG), "%s (%i) is using pro/poor-aim.cs(Count: %d)[(BulletDist.: %f | PlayerDist.: %f) | P/L: %.4f].", PlayerName(playerid), playerid, PAB_TCount[playerid], BulletDistance, AB_Distance, NetStats_PacketLossPercent(playerid));
	     		AntiCheatMessage(PAB_MSG);
				if(PAB_Count[playerid]==PAB_LOGLMT)
					PAB_Count[playerid]=0;
			}
		}
	}
	return 1;
}
*/
CMD:pablog(playerid, params[])
{
    if(IsAdmin(playerid, PAB_CMDLMT)==1)
	{
	    new ab_targetid;
		if(sscanf(params, "u", ab_targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /pablog [Player/Part_of_Name]");
		}
		else
		{
		    if(IsPlayerConnected(ab_targetid))
		    {
			    if(PAB_Count[ab_targetid]==-1)
			    {
			        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No Warnings given to specified player.");
			    }
			    else
			    {
				    new AB_MESSAGE[90];
				    PAB_MSG="";
					for(new i=0; i<PAB_LOGLMT; i++)
				    {
				        if(PAB_LOG[ab_targetid][i][0]!=0.0)
						{
							format(PAB_MSG, sizeof(PAB_MSG), "%sBulletDistance: %.2f && PlayerDistance: %.2f\n", PAB_MSG, PAB_LOG[ab_targetid][i][0],PAB_LOG[ab_targetid][i][1]);
						}
				    }
				    format(AB_MESSAGE, sizeof(AB_MESSAGE), "%s's aimbot bullet details[Total: %d].", PlayerName(ab_targetid), PAB_TCount[ab_targetid]);
				    ShowPlayerDialog(playerid, DIALOG_PAB, 0, AB_MESSAGE, PAB_MSG, "Close", "");
				}
			}
			else
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Invalid PlayerID/PlayerName.");
		}
	}
	return 1;
}

CMD:pablist(playerid, params[])
{
	if(IsAdmin(playerid, PAB_CMDLMT)==1)
	{
	    new PAB_SCount;
		PAB_MSG="";
		foreach(Player, i)
		{
			if(PAB_Count[i]!=-1)
			{
				format(PAB_MSG, sizeof(PAB_MSG), "%s%s[%i]\n", PAB_MSG, PlayerName(i), i);
                PAB_SCount++;
			}
		}
		if(PAB_SCount>0)
			ShowPlayerDialog(playerid, DIALOG_PAB, 0, "List of suspected Aimbotters", PAB_MSG, "Close", "");
		else
		    SendClientMessage(playerid, COLOR_SYNTAX, "[ERROR:] No player striked for aimbot.");
	}
	return 1;
}


CMD:pabclear(playerid, params[])
{
    if(IsAdmin(playerid, PAB_ClearLogLMT)==1)
	{
	    new ab_targetid;
		if(sscanf(params, "u", ab_targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /pabclear [Player/Part_of_Name]");
		}
		else
		{
		    if(IsPlayerConnected(ab_targetid))
		    {
			    if(PAB_TCount[ab_targetid]<3)
			    {
			        if(PAB_Count[ab_targetid]!=-1)
			        {
			            AB_ClearLog(ab_targetid);
			            format(PAB_MSG, sizeof(PAB_MSG), "AdmCmd(%d): %s %s has cleared %s's PAB_LOG.[He might be corrupt]", PAB_ClearLogLMT, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(ab_targetid));
						SendAdminMessage(PAB_ClearLogLMT, PAB_MSG);
						IRC_GroupSay(gLeads, IRC_FOCO_LEADS, PAB_MSG);
						format(PAB_MSG, sizeof(PAB_MSG), "[PAB_INFO:] %s's PAB_LOG has been cleared.",PlayerName(ab_targetid));
						return SendClientMessage(playerid, COLOR_SYNTAX, PAB_MSG);
					}
			    }
			    else
			    {
			        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Player might be toggling, please keep checking.");
			    }
			}
			else
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Invalid PlayerID/PlayerName.");
		}
	}
	return 1;
}
















