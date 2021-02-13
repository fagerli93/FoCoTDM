#include <foco>
#define PAB_CountLimit 7
#define PAD_CMDLMT 1
#define DIALOG_PAB 58

new PAB_MSG[180];
new PAB_Count[MAX_PLAYERS];
new Float:PAB_LOG[MAX_PLAYERS][14][2];


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
	return 1;
}

stock AB_ShiftLog(playerid)
{
	for(new i=0; i<7; i++)
	{
        PAB_LOG[playerid][i+7][0]=PAB_LOG[playerid][i][0];
        PAB_LOG[playerid][i+7][1]=PAB_LOG[playerid][i][1];
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
    AB_ClearLog(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	AB_ClearLog(playerid);
	return 1;
}

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
		    PAB_LOG[playerid][PAB_Count[playerid]][0]=BulletDistance;
		    PAB_LOG[playerid][PAB_Count[playerid]][1]=AB_Distance;
		    PAB_Count[playerid]++;
		    if(PAB_Count[playerid] == PAB_CountLimit)
		    {
				format(PAB_MSG, sizeof(PAB_MSG), "[Aimbot]: %s[%i] is possibly using aimbot[PoorAim/ProAim].", PlayerName(playerid), playerid);
	     		SendAdminMessage(PAD_CMDLMT, PAB_MSG);
	     		AB_ShiftLog(playerid);
				PAB_Count[playerid]=0;
			}
		}
	}
	return 1;
}
CMD:ablog(playerid, params[])
{
    if(IsAdmin(playerid, PAD_CMDLMT)==1)
	{
	    new ab_targetid;
		if(sscanf(params, "u", ab_targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /ablog [P_ID]");
		}
		else
		{
		    if(PAB_Count[ab_targetid]==-1)
		    {
		        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No Warnings given to specified player.");
		    }
		    else
		    {
			    new AB_MESSAGE[990];
				for(new i=0; i<14; i++)
			    {
			        if(PAB_LOG[ab_targetid][i][0]!=0.0)
					{
						format(AB_MESSAGE, sizeof(AB_MESSAGE), "%sBulletDistance: %.2f && PlayerDistance: %.2f\n", AB_MESSAGE, PAB_LOG[ab_targetid][i][0],PAB_LOG[ab_targetid][i][1]);
					}
			    }
			    format(PAB_MSG, sizeof(PAB_MSG), "%s's aimbot bullet details.", PlayerName(ab_targetid));
			    ShowPlayerDialog(playerid, DIALOG_PAB, 0, PAB_MSG, AB_MESSAGE, "Close", "");
			}
		}
	}
	return 1;
}






















