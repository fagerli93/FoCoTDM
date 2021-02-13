#include <foco>

#define CMD_RFWCH 1

new LastShotTime[MAX_PLAYERS];
new RapidFireS[MAX_PLAYERS];
new bool:RF_Loghim[MAX_PLAYERS];
new RapidFireSession[MAX_PLAYERS][70];
new RapidFireBulletC[MAX_PLAYERS];
new RapidFireMagC[MAX_PLAYERS];
new LastCTime[MAX_PLAYERS];
new RapidFire_AlreadyBanned[MAX_PLAYERS];
new RF_MSG[580];
new RF_LastWeapon[MAX_PLAYERS];
new bool:RF_WatchAvg[MAX_PLAYERS];
new RF_Delay[13]=
{
   //Pistols
	  160,
	  250,
	  690,
  // Shotgun
	  1030,
	  300,
	  300,
  //Automatic
	  110,
	  80,
	  100,
	  100,
	  105,
    //Rifle
	  1060,
	  1060
//Usage : RF_Delay[weaponid-22]
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
//Usage : RF_MagSize[weaponid-22]
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


hook OnPlayerConnect(playerid)
{
	LastShotTime[playerid]=0;
	RapidFireS[playerid]=0;
	RF_LastWeapon[playerid]=0;
	RF_Loghim[playerid]=false;
	for(new i=0; i<70; i++)
		RapidFireSession[playerid][i]=0;
	RapidFireBulletC[playerid]=0;
	RapidFireMagC[playerid]=0;
	LastCTime[playerid]=0;
	RapidFire_AlreadyBanned[playerid]=0;
	RF_WatchAvg[playerid]=false;
	return 1;
}
hook OnPlayerDisconnect(playerid)
{
	LastShotTime[playerid]=0;
	RapidFireS[playerid]=0;
	RF_LastWeapon[playerid]=0;
	RF_Loghim[playerid]=false;
	for(new i=0; i<70; i++)
		RapidFireSession[playerid][i]=0;
	RapidFireBulletC[playerid]=0;
	RapidFireMagC[playerid]=0;
	LastCTime[playerid]=0;
	RapidFire_AlreadyBanned[playerid]=0;
	if(RF_WatchAvg[playerid]==true)
 	{
 	    format(RF_MSG, sizeof(RF_MSG), "[GUARDIAN]: %s logged during RapidFire-Watch.", PlayerName(playerid));
        RF_WatchAvg[playerid]=false;
	}
	return 1;
}
stock LastSessionAverage(playerid, weaponid)
{
	if(RapidFireBulletC[playerid]>3)
	{
	    RF_MSG="";
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
                format(RF_MSG, sizeof(RF_MSG), "%s%i ",RF_MSG,RapidFireSession[playerid][i]);
			}
			RapidFireSession[playerid][i]=0;
		}
		if(RF_WatchAvg[playerid]==true)
		{
		    format(RF_MSG, sizeof(RF_MSG), "[GUARDIAN]: %s (%i) shooting delay's average - [Avg: %i/%i][Weapon: %i]",PlayerName(playerid), playerid,(RF_Average/(RF_GreenF+RF_RedF)),RF_Delay[weaponid-22],weaponid);
			SendAdminMessage(CMD_RFWCH, RF_MSG);
		}
		if((RF_Average/(RF_GreenF+RF_RedF))<RF_Delay[weaponid-22])
		{
  			format(RF_MSG, sizeof(RF_MSG), "[RF_LOG]: %s (%i) has been striked by RapidFire Script. [Avg: %i][Normal: %i][Weapon: %i][TotBullets:%i/%i/%i]",PlayerName(playerid), playerid,(RF_Average/(RF_GreenF+RF_RedF)),RF_Delay[weaponid-22],weaponid,RapidFireBulletC[playerid],RapidFireMagC[playerid],RF_MagSize[weaponid-22]);
            CheatLog(RF_MSG);
		    format(RF_MSG, sizeof(RF_MSG), "%s (%i) is possibly using RapidFire.", PlayerName(playerid), playerid);
      		AntiCheatMessage(RF_MSG);
		    RapidFireS[playerid]++;
		}
		if(RapidFireS[playerid]%5==0 && RapidFireS[playerid]!=0)
		{
			if(RapidFire_AlreadyBanned[playerid]==0)
		    {
		        if(TAdminsOnline()==0 && AdminsOnline()==0)
				{
  					format(RF_MSG, sizeof(RF_MSG), "[RF_AutoBan]: %s (%i) has been striked-banned by RapidFire Script. [Avg: %i][Normal: %i][Weapon: %i][TotBullets:%i/%i/%i]",PlayerName(playerid), playerid,(RF_Average/(RF_GreenF+RF_RedF)),RF_Delay[weaponid-22],weaponid,RapidFireBulletC[playerid],RapidFireMagC[playerid],RF_MagSize[weaponid-22]);
            		CheatLog(RF_MSG);
					RapidFire_AlreadyBanned[playerid]=1;
					ABanPlayer(-1, playerid, "RapidFire[AC]");
				}
			}
 		}
		if(IsAutoBannableWeapon(weaponid)==1 && (RF_Average/(RF_GreenF+RF_RedF))<100)
		{
			if(RapidFire_AlreadyBanned[playerid]==0)
	        {
	            if(TAdminsOnline()==0 && AdminsOnline()==0)
				{
                    format(RF_MSG, sizeof(RF_MSG), "[RF_AutoBan]: %s (%i) has been banned by RapidFire Script. [Avg: %i][Normal: %i][Weapon: %i][TotBullets:%i/%i/%i]",PlayerName(playerid), playerid,(RF_Average/(RF_GreenF+RF_RedF)),RF_Delay[weaponid-22],weaponid,RapidFireBulletC[playerid],RapidFireMagC[playerid],RF_MagSize[weaponid-22]);
                    CheatLog(RF_MSG);
					RapidFire_AlreadyBanned[playerid]=1;
					ABanPlayer(-1, playerid, "RapidFire[AC]");
				}
			}
		}
	}
	else
	{
	    for(new i=0; i< RapidFireBulletC[playerid]; i++)
			RapidFireSession[playerid][i]=0;
	}
	RapidFireBulletC[playerid]=0;
	return 1;
}


/*public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(weaponid<35 && weaponid>21)
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
			if(RapidFireMagC[playerid]>(RF_MagSize[weaponid-22]+10))
			{
				if(RapidFire_AlreadyBanned[playerid]==0)
     			{
     			    if(TAdminsOnline()==0 && AdminsOnline()==0)
     			    {
	          			format(RF_MSG, sizeof(RF_MSG), "[RF_AutoBan]: %s (%i) has been striked by RapidFire Script for no-reload.[WeaponID:%i] [TotBullets: %i | %i | %i]",PlayerName(playerid), playerid,weaponid,RapidFireBulletC[playerid],RapidFireMagC[playerid], RF_MagSize[weaponid-22]);
            			CheatLog(RF_MSG);
						//RapidFire_AlreadyBanned[playerid]=1;
						ABanPlayer(-1, playerid, "NoReload[AC]");
					}
					else
					{
					    format(RF_MSG, sizeof(RF_MSG), "%s (%i) is possibly using No-Reload hack.", PlayerName(playerid), playerid);
                        SendAdminMessage(CMD_RFWCH, RF_MSG);
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
	return 1;
}*/

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(oldkeys&KEY_CROUCH && !(newkeys&KEY_CROUCH))
	{
	    LastCTime[playerid]=NetStats_GetConnectedTime(playerid);
	}
	if(newkeys & KEY_FIRE == KEY_FIRE && RF_Loghim[playerid]==false)
	{
	    if(GetPlayerWeapon(playerid)>21 && GetPlayerWeapon(playerid)<35)
		{
		    LastShotTime[playerid]=NetStats_GetConnectedTime(playerid);
			RF_Loghim[playerid]=true;
		}
	}
	else if(!(newkeys & KEY_FIRE) && RF_Loghim[playerid]==true)
	{
        LastSessionAverage(playerid, GetPlayerWeapon(playerid));
        RapidFireMagC[playerid]=0;
		RF_Loghim[playerid]=false;
  	}
	return 1;
}

hook OnPlayerUpdate(playerid)
{
	if(GetPlayerWeapon(playerid)>21 && GetPlayerWeapon(playerid)<35)
	{
		if((GetPlayerWeapon(playerid)!=RF_LastWeapon[playerid])||(RF_Loghim[playerid]==true && GetPlayerWeaponState(playerid)==WEAPONSTATE_RELOADING && RapidFire_IsReloadable(playerid, GetPlayerWeapon(playerid))==1 &&  RapidFireBulletC[playerid] !=0))
		{
		    LastSessionAverage(playerid, RF_LastWeapon[playerid]);
            RapidFireMagC[playerid]=0;
		    RF_LastWeapon[playerid]=GetPlayerWeapon(playerid);
		}
	}
 	return 1;
}

CMD:watchrf(playerid, params[])
{
    if(IsAdmin(playerid, CMD_RFWCH)==1)
	{
	    new targetid;
	    if(sscanf(params, "u", targetid))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /watchrf [PlayerID/Part_Of_Name]");
	    }
	    else
	    {
	        if(RF_WatchAvg[playerid]==true)
	        {
	            RF_WatchAvg[playerid]=false;
	            format(RF_MSG, sizeof(RF_MSG), "AdmCmd(%i): %s %s has disabled RapidFire-Watch for %s(%i).",CMD_RFWCH, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
	        }
	        else
	        {
	            RF_WatchAvg[playerid]=true;
	            format(RF_MSG, sizeof(RF_MSG), "AdmCmd(%i): %s %s has enabled RapidFire-Watch for %s(%i).",CMD_RFWCH, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
	        }
	        SendAdminMessage(CMD_RFWCH, RF_MSG);
	    }
	}
	return 1;
}

