#include <YSI\y_hooks>
#define PAB_CountLimit 7

new PAB_MSG[180];
new PAB_Count[MAX_PLAYERS];
new Float:PAB_LOG[MAX_PLAYERS][7][2];

stock Float:GetDistanceBetweenVectors(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    return VectorSize(x1-x2, y1-y2, z1-z2);
}

hook OnPlayerConnect(playerid)
{
	for(new i=0; i<7; i++)
	{
	    PAB_LOG[playerid][i][0]=0.0;
	    PAB_LOG[playerid][i][1]=0.0;
	}
    PAB_Count[playerid]=0;
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
    for(new i=0; i<7; i++)
	{
	    PAB_LOG[playerid][i][0]=0.0;
	    PAB_LOG[playerid][i][1]=0.0;
	}
    PAB_Count[playerid]=0;
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
		if(BulletDistance<=2.3 && AB_Distance>=10.0 && AB_Distance<250.0 && AB_Distance - BulletDistance > 5.0)
		{
		    PAB_LOG[playerid][PAB_Count[playerid]][0]=BulletDistance;
		    PAB_LOG[playerid][PAB_Count[playerid]][1]=AB_Distance;
		    PAB_Count[playerid]++;
		    if(PAB_Count[playerid] > PAB_CountLimit && NetStats_PacketLossPercent(playerid)== 0.0)
		    {
	       		format(PAB_MSG, sizeof(PAB_MSG), "[BAN_LOG:] PlayerName: %s BulletDistance: %f • PlayerDistance: %f • Ping: %i • P/L: %f", PlayerName(playerid),BulletDistance, AB_Distance, GetPlayerPing(playerid), NetStats_PacketLossPercent(playerid));
				IRC_GroupSay(gEcho, IRC_FOCO_ECHO, PAB_MSG);
				PAB_Log(playerid);
				format(PAB_MSG, sizeof(PAB_MSG), "[GUARDIAN]: %s has been banned for using aimbot.", PlayerName(playerid));
	     		SendAdminMessage(1, PAB_MSG);
	   		 	ABanPlayer(-1, playerid, "Aimbot(Code 0)");
				PAB_Count[playerid]=0;
			}
			else if(PAB_Count[playerid] > PAB_CountLimit && NetStats_PacketLossPercent(playerid) > 0.0)
			{
			    format(PAB_MSG, sizeof(PAB_MSG), "[GUARDIAN]: %s is possibly using Poor-Aim.cs. Proceed to ban if player is not desynced[(%0.2f,%0.2f), (%0.2f,%0.2f)].", PlayerName(playerid),BulletDistance, AB_Distance,PAB_LOG[playerid][5][0],PAB_LOG[playerid][5][1]);
				SendAdminMessage(1, PAB_MSG);
                PAB_Log(playerid)
				PAB_Count[playerid]=0;
			}
		}
	}
	return 1;
}

stock PAB_Log(playerid)
{
	format(PAB_MSG, sizeof(PAB_MSG), "[BAN_LOG:] PN: %s |", PlayerName(playerid));
	for(new i=0; i<7; i++)
	{
		format(PAB_MSG, sizeof(PAB_MSG), "%s BD: %f • PD: %f |", PAB_MSG,PAB_LOG[playerid][i][0],PAB_LOG[playerid][i][0]);
	}
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, PAB_MSG);
}

/*public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(hittype == BULLET_HIT_TYPE_PLAYER)
	{
		if(ADuty[hitid] == 1)
		{
			GameTextForPlayer(playerid, "Admin On-Duty", 500, 3);
		    return 0;
		}
	}
	return 1;
}*/

























