forward CheckSilentAim(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public CheckSilentAim(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(hittype == 1 && hitid != INVALID_PLAYER_ID && IsPlayerConnected(hitid))
	{
		new Float:fOriginX, Float:fOriginY, Float:fOriginZ,
		Float:fHitPosX, Float:fHitPosY, Float:fHitPosZ;
	    GetPlayerLastShotVectors(playerid, fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);
		GetPlayerPos(hitid, fOriginX, fOriginY, fOriginZ);
		fHitPosX = fHitPosZ-fOriginZ;
		fOriginX = fZ - (fHitPosZ-fOriginZ);
		new Float:posplayer;
		new Float:useless[2];
		GetPlayerPos(playerid, useless[0],  useless[1], posplayer);
		posplayer = fOriginZ - posplayer;
	    posplayer = floatabs(posplayer);
	    fOriginX  = floatabs(fOriginX);
		if(fHitPosX == 0.000000 || fHitPosX == SA_Strike[playerid][SA_LAST_VALUE])
		{
	 		if(WatchSALog[playerid] == true)
			{
			    format(SA_MSG, sizeof(SA_MSG), "[GUARDIAN]: %s shot at %s [Silent Aim Value:[ShotAt: %.9f] || [HitAt: %.9f]", PlayerName(playerid), PlayerName(hitid), fHitPosX, fOriginX);
   				SendAdminMessage(1, SA_MSG);
			}
		    SA_Strike[playerid][SA_LAST_VALUE] = fHitPosX;
		    SA_Strike[playerid][SA_PStrike]= SA_Strike[playerid][SA_PStrike] + 1;
			if(SA_Strike[playerid][SA_PStrike]%5 == 0)
			{
				format(SA_MSG, sizeof(SA_MSG), "%s is using Silentaimbot(%.9f).", PlayerName(playerid), fHitPosX);
				AntiCheatMessage(SA_MSG);
				SA_AutoBan[playerid]++;
				if(SA_AutoBan[playerid] == 2)
				{
				    ABanPlayer(-1, playerid, "SilentAim", 1);
				}
			}
   			format(SA_MSG, sizeof(SA_MSG), "[GUARDIAN]: %s shot at %s [Silent Aim Value: %.9f]", PlayerName(playerid), PlayerName(hitid), fHitPosX);
		    CheatLog(RF_MSG);
			return 0;
		}
		else
		    SA_Strike[playerid][SA_LAST_VALUE] = fHitPosX;
	}
	return 1;
}

forward CheckPoorAim(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public CheckPoorAim(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(hittype == BULLET_HIT_TYPE_PLAYER)
	{
		if(GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID && !IsPlayerInAnyVehicle(playerid))
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
				if(PAB_Count[playerid] % PAB_CountLimit == 0)
				{
					format(PAB_MSG, sizeof(PAB_MSG), "%s (%i) is using pro/poor-aim.cs(Count: %d)[(BulletDist.: %f | PlayerDist.: %f)].", PlayerName(playerid), playerid, PAB_TCount[playerid], BulletDistance, AB_Distance);
					AntiCheatMessage(PAB_MSG);
					if(PAB_Count[playerid]==PAB_LOGLMT)
					{
						PAB_Count[playerid]=0;
					}
				}
				return 0;
			}
		}
	}
	return 1;
}

forward CheckNoSpread(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public CheckNoSpread(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(NS_Toggled==false)
	{
		new bool:flag = false;
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
				    if(TempNSTime<3)
				    {
						format(NS_MSG, sizeof(NS_MSG), "[GUARDIAN]: %s has shot accurately.[Time: %i | Accuracy: %f]", PlayerName(playerid),TempNSTime,BulletDistance);
						CheatLog(NS_MSG);
					    NoSpreadStrike[playerid]++;
					    NoSpreadKeyStrike[playerid]++;
						if(NoSpreadKeyStrike[playerid] > 1)
						{
							flag = true;
						}
						if(NS_AdminW[playerid]==true)
						{
							SendAdminMessage(NS_CMDLMT, NS_MSG);
						}
						if(NoSpreadStrike[playerid]%5==0&&NoSpreadStrike[playerid]>4 && NoSpreadKeyStrike[playerid]!=1)
					    {
							format(NS_MSG, sizeof(NS_MSG), "%s (%i) is possibly using nospread.cs[TotalAccurateShots(%i):LastSession(%i)]", PlayerName(playerid), playerid,NoSpreadStrike[playerid],NoSpreadKeyStrike[playerid]);
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
				        format(NS_MSG, sizeof(NS_MSG), "%s (%i) is using SilentAim.cs.", PlayerName(playerid), playerid);
				        AntiCheatMessage(NS_MSG);
				        //ABanPlayer(-1, playerid, "SilentAim.cs");
				    }
				}
			}
		}
		if(flag == true)
		{
			return 0;
		}
	}
	//End of NoSpread
	return 1;
}

forward CheckRapidFire(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public CheckRapidFire(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	//RapidFire
	if(weaponid<35 && weaponid>21 && GetPlayerVehicleID(playerid)==0)
	{
		new bool:flag = false;
		if(RF_Loghim[playerid]==true)
		{
	       	new NewShotTime=NetStats_GetConnectedTime(playerid);
		    if(LastShotTime[playerid]-LastCTime[playerid]>400)
		    {
			    RapidFireSession[playerid][RapidFireBulletC[playerid]]=NewShotTime-LastShotTime[playerid];
				if(RF_Delay[weaponid-22] - 20 > RapidFireSession[playerid][RapidFireBulletC[playerid]])
				{
					flag = true;
				}
       			//format(RF_MSG, sizeof(RF_MSG), "%i - %i", RapidFireSession[playerid][RapidFireBulletC[playerid]], LastShotTime[playerid]);
                //DebugMsg(RF_MSG);
				RapidFireBulletC[playerid]++;
			    RapidFireMagC[playerid]++;
			}
			if(RapidFireMagC[playerid]>(RF_MagSize[weaponid-22]+10)&&(NetStats_GetConnectedTime(playerid)-NR_AntiSpam[playerid]>5000))
			{
			    NR_AntiSpam[playerid]=NetStats_GetConnectedTime(playerid);
  			 	format(RF_MSG, sizeof(RF_MSG), "[RF_AutoBan]: %s (%i) has been striked by RapidFire Script for no-reload.[WeaponID:%i] [TotBullets: %i | %i | %i]",PlayerName(playerid), playerid,weaponid,RapidFireBulletC[playerid],RapidFireMagC[playerid], RF_MagSize[weaponid-22]);
    			CheatLog(RF_MSG);
				if(RapidFire_AlreadyBanned[playerid]==0)
     			{
				    format(RF_MSG, sizeof(RF_MSG), "%s (%i) is possibly using No-Reload hack.", PlayerName(playerid), playerid);
                    AntiCheatMessage(RF_MSG);
			 	    if(TAdminsOnline()==0 && AdminsOnline()==0)
     			    {
						RapidFire_AlreadyBanned[playerid]=1;
						AKickPlayer(-1, playerid, "NoReload", 1);
					}
					/*else
					{
					    format(RF_MSG, sizeof(RF_MSG), "%s (%i) is possibly using No-Reload hack.", PlayerName(playerid), playerid);
                        AntiCheatMessage(RF_MSG);
					}*/
				}
			}
			if(RapidFire_IsReloadable(playerid, weaponid)==0 && RapidFireBulletC[playerid] == 6)
			{
			    LastSessionAverage(playerid, weaponid);
			}
	       	LastShotTime[playerid] = NewShotTime;
	 	}
		if(flag == true)
		{
			return 0;
		}
	}
	return 1;
}

forward CheckKnifeBug(playerid, hitid);
public CheckKnifeBug(playerid, hitid)
{
	if(KnifeBugged[playerid] == true)
	{
	 	IgnoredBullet(playerid, hitid, SS_KNIFEBUG);
	 	return 0;
	}
	if(KnifeBugged[hitid] == true)
	{
		IgnoredBullet(playerid, hitid, SS_KNIFE_BODY);
		return 0;
	}
	return 1;
}

forward CheckCrasher(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public CheckCrasher(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	new string[156];
	if(weaponid < 22 || weaponid > 34 && weaponid != 38)
	{
		format(string, sizeof(string), "[AdmCMD]: The Guardian has banned %s(%d), Reason: AimCrasher (WpnID)[WpnID: %d, Hittype: %d, HitID: %d]", PlayerName(playerid), playerid, weaponid, hittype, hitid);
		AdminLog(string);
		format(string, sizeof(string), "AimCrasher");
		ABanPlayer(-1, playerid, string, 1);
		return 0;
	}
	if(hittype < 0 || hittype > 4)
	{
		format(string, sizeof(string), "[AdmCMD]: The Guardian has banned %s(%d), Reason: AimCrasher (HitType)[WpnID: %d, Hittype: %d, HitID: %d]", PlayerName(playerid), playerid, weaponid, hittype, hitid);
		AdminLog(string);
		format(string, sizeof(string), "AimCrasher");
		ABanPlayer(-1, playerid, string, 1);
		return 0;
	}
	// For bulletcrasher, made by mr pEar. Accurate, so allowed it to autoban
	if(hittype == 1)
	{
		if(fX >= 10000 || fY >= 10000 || fZ >= 10000)
		{
			format(string, sizeof(string), "[AdmCMD]: The Guardian has banned %s(%d), Reason: BulletCrasher [fX: %f, fY: %f, fZ: %f]", PlayerName(playerid), playerid, fX, fY, fZ);
			AdminLog(string);
			format(string, sizeof(string), "BulletCrasher");
			ABanPlayer(-1, playerid, string, 1);
			return 0;
		}
	}
	return 1;
}

forward CheckDeathAndAdmin(playerid, hitid);
public CheckDeathAndAdmin(playerid, hitid)
{
	if(SS_DeadPlayer[playerid] == true)
	{
	   	if(GetPVarInt(playerid, "PlayerStatus") != 2)
		{
			ApplyAnimation(playerid, "PED", "KO_shot_front", 4.1, 0, 1, 1, 1, 300000, 1);
		}
		IgnoredBullet(playerid, hitid, SS_DEAD_PLAYER);
		return 0;
	}
 	if(SS_DeadPlayer[hitid] == true)
	{
		IgnoredBullet(playerid, hitid, SS_DEAD_BODY);
		return 0;
	}
	if(ADuty[hitid] == 1)
	{
		IgnoredBullet(playerid, hitid, SS_ADUTY);
		return 0;
	}
	return 1;
}
