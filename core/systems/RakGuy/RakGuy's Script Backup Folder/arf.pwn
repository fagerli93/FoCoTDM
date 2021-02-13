#define AC_RFS_ASM 20
#define AC_ABS_LMT 5
#include <foco>

forward OnPlayerWeaponChange(playerid, newweapon, oldweapon);

new LastShotTime[MAX_PLAYERS];
new RapidFireS[MAX_PLAYERS];
new bool:RF_Loghim[MAX_PLAYERS];
new RapidFireSession[MAX_PLAYERS][70];
new RapidFireBulletC[MAX_PLAYERS];
new RapidFireMagC[MAX_PLAYERS];
new LastCTime[MAX_PLAYERS];
new RapidFire_AlreadyBanned[MAX_PLAYERS];
new RF_MSG[180];
new RF_Delay[13]=
{
160,
250,
690,
// Shotgun
1030,
300, 
300, 
// Automatic
110,
80,
100,
100,
105,
// Rifle
1060,
1060
};
new RF_MagSize[13] =
{
	// Pistols
	034,
	017,
	007,
	// Shotgun
	001,
	02,
	007,
	// Automatic
	050,
	030,
	030,
	050,
	050,
	// Rifle
	001,
	001
};

stock IsAutoBannableWeapon(weaponid)
{
	if(weaponid==34 || weaponid == 33 || weaponid == 24 || weaponid == 25 || weaponid == 26 || weaponid == 27)
	{
		return 1;
	}
	return 0;
}

stock RapidFire_IsReloadable(playerid, weaponid)
{
	if(weaponid==34 || weaponid == 33 || weaponid == 25)
	{
        RapidFireMagC[playerid]=0;
		return 0;
	}
	return 1;
}


public OnPlayerConnect(playerid)
{
	LastShotTime[playerid]=0;
	RapidFireS[playerid]=0;
	RF_Loghim[playerid]=false;
	for(new i=0; i<70; i++)
		RapidFireSession[playerid][i]=0;
	RapidFireBulletC[playerid]=0;
	RapidFireMagC[playerid]=0;
	LastCTime[playerid]=0;
	RapidFire_AlreadyBanned[playerid]=0;
	return 1;
}
public OnPlayerDisconnect(playerid)
{
	LastShotTime[playerid]=0;
	RapidFireS[playerid]=0;
	RF_Loghim[playerid]=false;
	for(new i=0; i<70; i++)
		RapidFireSession[playerid][i]=0;
	RapidFireBulletC[playerid]=0;
	RapidFireMagC[playerid]=0;
	LastCTime[playerid]=0;
	RapidFire_AlreadyBanned[playerid]=0;
	return 1;
}
stock LastSessionAverage(playerid, weaponid)
{
	if(RapidFireBulletC[playerid]>3)
	{
		new RF_GreenF, RF_RedF,RF_Average;
		for(new i = 1; i < RapidFireBulletC[playerid]; i++)
		{
		    if(RapidFireSession[playerid][i]<RF_Delay[weaponid-22]+500)
		    {
			    if(RapidFireSession[playerid][i]>RF_Delay[weaponid-22])
			    {
				    RF_GreenF++;
				}
				else
				{
				    RF_RedF++;
				}
				RF_Average+=RapidFireSession[playerid][i];
			}
			RapidFireSession[playerid][i]=0;
		}
		if((RF_Average/(RF_GreenF+RF_RedF))<RF_Delay[weaponid-22])
		{
		    RapidFireS[playerid]++;
		}
		if(RapidFireS[playerid]%5==0 && RapidFireS[playerid]!=0)
		{
			if(AdminsOnline()>0 || TestersOnline()>0)
			{
			    format(RF_MSG, sizeof(RF_MSG), "%s (%i) is possibly using RapidFire.", PlayerName(playerid), playerid);
                AntiCheatMessage(RF_MSG);
			}
			else
			{
			    if(RapidFire_AlreadyBanned[playerid]==0)
	            {
				    RapidFire_AlreadyBanned[playerid]=1;
					ABanPlayer(-1, playerid, "RapidFire[AC]");
				}
			}
		}
		if(IsAutoBannableWeapon(weaponid)==1 && (RF_Average/(RF_GreenF+RF_RedF))<100)
		{
			if(RapidFire_AlreadyBanned[playerid]==0)
	        {
   				RapidFire_AlreadyBanned[playerid]=1;
				ABanPlayer(-1, playerid, "RapidFire[AC]");
			}
		}
	}
	else
	{
	    for(new i=0; i< RapidFireBulletC[playerid]; i++)
			RapidFireSession[playerid][i]=0;
		RapidFireBulletC[playerid]=0;
	}
	RapidFireBulletC[playerid]=0;
	return 1;
}


public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(RF_Loghim[playerid]==true)
	{
       	new NewShotTime=NetStats_GetConnectedTime(playerid);
	    if(LastShotTime[playerid]-LastCTime[playerid]>0)
	    {
		    RapidFireSession[playerid][RapidFireBulletC[playerid]]=NewShotTime-LastShotTime[playerid];
		    RapidFireBulletC[playerid]++;
		    RapidFireMagC[playerid]++;
		}
		if(RapidFireMagC[playerid]>RF_MagSize[GetPlayerWeapon(playerid)-22])
		{
				if(RapidFire_AlreadyBanned[playerid]==0)
	            {
				    RapidFire_AlreadyBanned[playerid]=1;
					ABanPlayer(-1, playerid, "NoReload[AC]");
				}
		}
		if(RapidFire_IsReloadable(playerid, weaponid)==0 && RapidFireBulletC[playerid] == 6)
		{
		    LastSessionAverage(playerid, weaponid);
		}
       	LastShotTime[playerid] = NewShotTime;
 }
 	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(oldkeys&KEY_CROUCH && !(newkeys&KEY_CROUCH))
	{
	    LastCTime[playerid]=NetStats_GetConnectedTime(playerid);
	}
	if(newkeys & KEY_FIRE == KEY_FIRE && RF_Loghim[playerid]==false)
	{
	    LastShotTime[playerid]=NetStats_GetConnectedTime(playerid);
		RF_Loghim[playerid]=true;
  	}
	else if(!(newkeys & KEY_FIRE) && RF_Loghim[playerid]==true)
	{
	    RapidFireMagC[playerid]=0;
        LastSessionAverage(playerid, GetPlayerWeapon(playerid));
		RF_Loghim[playerid]=false;
  	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(RF_Loghim[playerid]==true && GetPlayerWeaponState(playerid)==WEAPONSTATE_RELOADING && RapidFire_IsReloadable(playerid, GetPlayerWeapon(playerid))==1 &&  RapidFireBulletC[playerid] !=0 )
	{
	    RapidFireMagC[playerid]=0;
	    LastSessionAverage(playerid, GetPlayerWeapon(playerid));
	}
	return 1;
}

