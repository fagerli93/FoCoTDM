#include <YSI\y_hooks>

#define NS_CMDLMT 1
#define DIALOG_NS 537
//Added Autoban for Silentaim.cs
new NS_MSG[900];
new bool:NoSpreadTest[MAX_PLAYERS],
	SilentAimWarnings[MAX_PLAYERS],
	NoSpreadStrike[MAX_PLAYERS],
	NoSpreadKeyStrike[MAX_PLAYERS],
	NoSpreadTime[MAX_PLAYERS],
	bool:NS_AdminW[MAX_PLAYERS],
	bool:NS_Toggled;

hook OnPlayerConnect(playerid)
{
    NoSpreadTest[playerid]=false;
    SilentAimWarnings[playerid]=0;
    NoSpreadStrike[playerid]=0;
	NoSpreadKeyStrike[playerid]=0;
	NoSpreadTime[playerid]=0;
	NS_AdminW[playerid]=false;
}


stock GetBXYZInFrontOfPlayer(playerid, Float:range, &Float:x, &Float:y, &Float:z)
{
    new Float:fVX, Float:fVY, Float:fVZ;
    GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);
    x = x + floatmul(fVX, range);
    y = y + floatmul(fVY, range);
    z = z + floatmul(fVZ, range);
}

hook OnPlayerDisconnect(playerid)
{
	if(NS_AdminW[playerid]==true)
	{
	    format(NS_MSG, sizeof(NS_MSG), "[GUARDIAN]: %s (%i) has logged during nospread.cs watch.", PlayerName(playerid), playerid);
	    SendAdminMessage(NS_CMDLMT, NS_MSG);
	}
    NoSpreadTest[playerid]=false;
    SilentAimWarnings[playerid]=0;
    NoSpreadStrike[playerid]=0;
	NoSpreadKeyStrike[playerid]=0;
	NoSpreadTime[playerid]=0;
	NS_AdminW[playerid]=false;
	return 1;
}

stock Float:GetDistance(Float:x1,Float:y1,Float:z1, Float:x2,Float:y2,Float:z2)
{
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

/*hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(NS_Toggled==false)
	{
		if(NoSpreadTest[playerid]==true)
		{
			if(weaponid==24)
			{
			    new Float:fOriginX, Float:fOriginY, Float:fOriginZ,Float:fHitPosX, Float:fHitPosY, Float:fHitPosZ;
				GetPlayerLastShotVectors(playerid, fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);
			    new Float:BulletDistance = GetDistanceBetweenVectors(fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);
			    if(BulletDistance>=105.0)
			    {
			        return 1;
			    }
				GetBXYZInFrontOfPlayer(playerid, BulletDistance, fOriginX, fOriginY, fOriginZ);
				new Float:RayDistance=GetDistance(fOriginX, fOriginY, fOriginZ,fHitPosX, fHitPosY, fHitPosZ);
				BulletDistance=BulletDistance/RayDistance;
				if(BulletDistance>=8.880 && BulletDistance<8.890)
				{
				    new TempNSTime=gettime()-NoSpreadTime[playerid];
				    format(NS_MSG, sizeof(NS_MSG), "[NoSpread]: %s - TimeInt: %i - Accuracy: %f", PlayerName(playerid),TempNSTime,BulletDistance);
				    if(TempNSTime<4)
				    {
					    NoSpreadStrike[playerid]++;
					    NoSpreadKeyStrike[playerid]++;
						if(NS_AdminW[playerid]==true)
						{
							format(NS_MSG, sizeof(NS_MSG), "[GUARDIAN]: %s has shot accurately.[Time: %i | Accuracy: %f]", PlayerName(playerid),TempNSTime,BulletDistance);
							SendAdminMessage(NS_CMDLMT, NS_MSG);
						}
						if(NoSpreadStrike[playerid]%5==0&&NoSpreadStrike[playerid]>4 && NoSpreadKeyStrike[playerid]!=1)
					    {
							format(NS_MSG, sizeof(NS_MSG), "%s (%i) is possibly using nospread.cs[TotalAccurateShots(%i):LastSession(%i)", PlayerName(playerid), playerid,NoSpreadStrike[playerid],NoSpreadKeyStrike[playerid]);
		                    AntiCheatMessage(NS_MSG);
						}
					}
				}
				NoSpreadTime[playerid]=gettime();
				if(BulletDistance==1.5 && RayDistance==0.689237)
				{
				    SilentAimWarnings[playerid]++;
				    if(SilentAimWarnings[playerid]==8)
				    {
				        format(NS_MSG, sizeof(NS_MSG), "%s has been banned for SilentAim.cs.", PlayerName(playerid));
				        AntiCheatMessage(NS_MSG);
				        ABanPlayer(-1, playerid, "SilentAim.cs");
				    }
				}
			}
		}
	}
	return 1;
}*/

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(NS_Toggled==false)
	{
		if(newkeys&KEY_HANDBRAKE && oldkeys&KEY_HANDBRAKE)
		{
		    if(newkeys&KEY_FIRE)
		    {
				NoSpreadTest[playerid]=true;
		    }
		}
		else if(oldkeys&KEY_HANDBRAKE)
		{
		    if(NoSpreadKeyStrike[playerid]>=1)
		    {
			    if(NoSpreadKeyStrike[playerid]==1)
			    {
					NoSpreadStrike[playerid]--;
					if(NS_AdminW[playerid]==true)
					{
						format(NS_MSG, sizeof(NS_MSG), "[GUARDIAN]: %s's strike removed. Reason: First Bullet accuracy.", PlayerName(playerid));
						SendAdminMessage(NS_CMDLMT, NS_MSG);
					}
				}
				else if((NoSpreadStrike[playerid]-NoSpreadKeyStrike[playerid])%5==4&&NoSpreadKeyStrike[playerid]<6)
				{
					format(NS_MSG, sizeof(NS_MSG), "%s (%i) is possibly using nospread.cs[TotalAccurateShots(%i):LastSession(%i)", PlayerName(playerid), playerid,NoSpreadStrike[playerid],NoSpreadKeyStrike[playerid]);
		            AntiCheatMessage(NS_MSG);
				}
			    NoSpreadKeyStrike[playerid]=0;
			    NoSpreadTest[playerid]=false;
			}
		}
	}
	return 1;
}

CMD:nslist(playerid, params[])
{
	if(IsAdmin(playerid, NS_CMDLMT))
	{
	    new NS_SCount;
	    NS_MSG="";
		foreach(Player, i)
		{
			if(NoSpreadStrike[i]>=1)
			{
				format(NS_MSG, sizeof(NS_MSG), "%s%s[%i]-TotalStrikes:%i\n", NS_MSG, PlayerName(i), i,NoSpreadStrike[i]);
                NS_SCount++;
			}
		}
		if(NS_SCount>0)
			ShowPlayerDialog(playerid, DIALOG_NS, 0, "Suspected NoSpread Users", NS_MSG, "Close", "");
		else
		    SendClientMessage(playerid, COLOR_SYNTAX, "[ERROR:] No player striked for NoSpread.cs.");
	}
	return 1;
}

CMD:watchns(playerid, params[])
{
	if(IsAdmin(playerid, NS_CMDLMT))
	{
	    new targetid;
	    if(sscanf(params, "u", targetid))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /watchns [PlayerID/Part_Of_Name]");
	    }
	    if(targetid == INVALID_PLAYER_ID)
       	{
       		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid Player ID/Name.");
       	}
	    else
	    {
	        if(NS_AdminW[targetid]==true)
	        {
	            NS_AdminW[targetid]=false;
	            format(NS_MSG, sizeof(NS_MSG), "AdmCmd(%i): %s %s has disabled NoSpread-Watch for %s(%i).",NS_CMDLMT, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
	        }
	        else
	        {
	            NS_AdminW[targetid]=true;
	            format(NS_MSG, sizeof(NS_MSG), "AdmCmd(%i): %s %s has enabled NoSpread-Watch for %s(%i).",NS_CMDLMT, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
	        }
	        SendAdminMessage(NS_CMDLMT, NS_MSG);
	    }
	}
	return 1;
}

CMD:togglens(playerid, params[])
{
    if(IsAdmin(playerid, NS_CMDLMT))
	{
		if(NS_Toggled==false)
	    {
     		NS_Toggled=true;
	        format(NS_MSG, sizeof(NS_MSG), "AdmCmd(%i): %s %s has disabled NoSpread.cs detector.",NS_CMDLMT, GetPlayerStatus(playerid), PlayerName(playerid));
       	}
	    else
	    {
	    	NS_Toggled=false;
	        format(NS_MSG, sizeof(NS_MSG), "AdmCmd(%i): %s %s has enabled NoSpread.cs detector.",NS_CMDLMT, GetPlayerStatus(playerid), PlayerName(playerid));
      	}
	    SendAdminMessage(NS_CMDLMT, NS_MSG);
  	}
	return 1;
}
