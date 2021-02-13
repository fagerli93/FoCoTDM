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
* Filename:  RakGuy_testfiles.pwn                                                *
* Author:    pEar                                                              *
*********************************************************************************/
#if !defined MAIN_INIT
#error "Compiling from wrong script. (foco.pwn)"
#endif

forward RakGuy_OnPlayerWeaponShot_Test(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public RakGuy_OnPlayerWeaponShot_Test(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	#if defined PTS
	F_TP_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, fX, fY, fZ);
	/*if(weaponid<35 && weaponid>21 && GetPlayerVehicleID(playerid)==0 && weaponid == RF_LastWeapon[playerid])
	{
		if(RF_Loghim[playerid]==true)
		{
	       	new NewShotTime=NetStats_GetConnectedTime(playerid);
		    if(LastShotTime[playerid]-LastCTime[playerid]>450)
		    {
				if(NewShotTime-LastShotTime[playerid]<RF_Delay[weaponid-22]+500)
		        {
				    RapidFireSession[playerid][RapidFireBulletC[playerid]]=NewShotTime-LastShotTime[playerid];
				    RapidFireBulletC[playerid]++;
				    RapidFireMagC[playerid]++;
				}
			    if(RapidFireBulletC[playerid]>=70)
			    {
			        LastSessionAverage(playerid, weaponid);
			    }
			}
			if(RapidFireMagC[playerid]>(RF_MagSize[weaponid-22]+1)&&(NetStats_GetConnectedTime(playerid)-NR_AntiSpam[playerid]>5000))
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
						AKickPlayer(-1, playerid, "NoReload");
					}
				}
			}
			if(RapidFire_IsReloadable(playerid, weaponid)==0 && RapidFireBulletC[playerid] == 6)
			{
			    LastSessionAverage(playerid, weaponid);
			}
	       	LastShotTime[playerid] = NewShotTime;
	 	}
	}
	//LAG.cs
	if(hittype == 1 && hitid != INVALID_PLAYER_ID && IsNotStanding(hitid)==1 && ADuty[playerid]!=1)
	{
		SetTimerEx("CheckSimilarHP", GetPlayerPing(playerid)+500, false, "ii", hitid,  GetPlayerAnimationIndex(hitid));
	}
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
				    if(TempNSTime<3)
				    {
						format(NS_MSG, sizeof(NS_MSG), "[GUARDIAN]: %s has shot accurately.[Time: %i | Accuracy: %f]", PlayerName(playerid),TempNSTime,BulletDistance);
						CheatLog(NS_MSG);
					    NoSpreadStrike[playerid]++;
					    NoSpreadKeyStrike[playerid]++;
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
	}
	//End of NoSpread
	//Start of SilentAim
	SilentAim_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
	//End of Silentaim :P*/
	//WH_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
	#endif
	return 1;
}

forward RakGuy_OnPlayerWeaponShot_Main(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public RakGuy_OnPlayerWeaponShot_Main(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    F_TP_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, fX, fY, fZ);
	//RapidFire
	/*if(weaponid<35 && weaponid>21 && GetPlayerVehicleID(playerid)==0)
	{
		if(RF_Loghim[playerid]==true)
		{
	       	new NewShotTime=NetStats_GetConnectedTime(playerid);
		    if(LastShotTime[playerid]-LastCTime[playerid]>400)
		    {
			    RapidFireSession[playerid][RapidFireBulletC[playerid]]=NewShotTime-LastShotTime[playerid];
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
						AKickPlayer(-1, playerid, "NoReload");
					}

				}
			}
			if(RapidFire_IsReloadable(playerid, weaponid)==0 && RapidFireBulletC[playerid] == 6)
			{
			    LastSessionAverage(playerid, weaponid);
			}
	       	LastShotTime[playerid] = NewShotTime;
	 	}
	}
	//End of RapidFire
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
				    if(TempNSTime<3)
				    {
						format(NS_MSG, sizeof(NS_MSG), "[GUARDIAN]: %s has shot accurately.[Time: %i | Accuracy: %f]", PlayerName(playerid),TempNSTime,BulletDistance);
						CheatLog(NS_MSG);
					    NoSpreadStrike[playerid]++;
					    NoSpreadKeyStrike[playerid]++;
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
	}
	//End of NoSpread
	// PoorAim / ProAim 
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
			if(PAB_Count[playerid] % PAB_CountLimit == 0)
			{
				format(PAB_MSG, sizeof(PAB_MSG), "%s (%i) is using pro/poor-aim.cs(Count: %d)[(BulletDist.: %f | PlayerDist.: %f)].", PlayerName(playerid), playerid, PAB_TCount[playerid], BulletDistance, AB_Distance);
				AntiCheatMessage(PAB_MSG);
				if(PAB_Count[playerid]==PAB_LOGLMT)
				{
					PAB_Count[playerid]=0;
				}
			}
		}
	}
	// End proaim/pooraim
	//Start of SilentAim
	SilentAim_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
	//End of Silentaim :P*/
	//WeaponHacks
	//WH_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
	//WeaponHacks
	return 1;
}







