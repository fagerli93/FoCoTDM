#include <YSI\y_hooks>

#define CMD_RFWCH 1

new RF_MSG[580];
new LastCTime[MAX_PLAYERS];
new RapidFireS[MAX_PLAYERS];
new bool:cwatch[MAX_PLAYERS];
new NR_AntiSpam[MAX_PLAYERS];
new LastShotTime[MAX_PLAYERS];
new RapidFireMagC[MAX_PLAYERS];
new RF_LastWeapon[MAX_PLAYERS];
new bool:RF_Loghim[MAX_PLAYERS];
new bool:RF_WatchAvg[MAX_PLAYERS];
new RapidFireBulletC[MAX_PLAYERS];
new RapidFireSession[MAX_PLAYERS][70];
new RapidFire_AlreadyBanned[MAX_PLAYERS];
new PlayerBeingCWatched[MAX_PLAYERS][10];
new PlayerCWatching[MAX_PLAYERS][5];

new RF_Delay[13]=
{
   //Pistols
	  155,
	  245,
	  685,
  // Shotgun
	  1025,
	  295,
	  295,
  //Automatic
	  115,
	  75,
	  95,
	  95,
	  100,
    //Rifle
	  995,
	  995
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
	cwatch[playerid]=false;
	for(new i = 0; i < 10; i++)
	{
		PlayerBeingCWatched[playerid][i]=-1;
		if(i < 5)
			PlayerCWatching[playerid][i]=-1;
	}
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
		SendAdminMessage(1, RF_MSG);
		RF_WatchAvg[playerid]=false;
	}
	if(cwatch[playerid]==true)
	{
		format(RF_MSG, sizeof(RF_MSG), "[Guardian]: %s has logged during Crouch Stroke Watch. Logging disabled.", PlayerName(playerid));
		if(!IsArrayEmpty(PlayerBeingCWatched[playerid], 10, -1))
		{
			SendAdminMessageToArray(PlayerBeingCWatched[playerid], 10, RF_MSG, 1);
		}
		new tempid;
		for(new i=0; i<10; i++)
		{
		    if(PlayerBeingCWatched[playerid][i] != -1)
		    {
		       	tempid = PlayerBeingCWatched[playerid][i];
				PlayerBeingCWatched[playerid][i]=-1;
				new SlotID = FindValueInArray(playerid, PlayerCWatching[tempid][i], 5);
				if(SlotID != -1)
				{
					PlayerCWatching[tempid][SlotID] = -1;
				}
			}
		}
		for(new i=0; i<5; i++)
		{
		    if(!IsArrayEmpty(PlayerCWatching[playerid][i], 5, -1))
		    {
		        break;
		    }
			if(PlayerCWatching[playerid][i] != -1)
			{
				tempid = PlayerCWatching[playerid][i];
				format(RF_MSG, sizeof(RF_MSG), "[Guardian]: %s has stopped watching %s(%i)'s crouch strokes.", PlayerName(playerid), PlayerName(tempid), tempid);
				PlayerCWatching[playerid][i]=-1;
				if(!IsArrayEmpty(PlayerBeingCWatched[tempid], 10, -1))
				{
					SendAdminMessageToArray(PlayerBeingCWatched[tempid], 10, RF_MSG, 1);
				}
				else
				{
					cwatch[tempid] = false;
				}
			}
		}
	}
	return 1;
}
stock LastSessionAverage(playerid, weaponid)
{
	if(RapidFireBulletC[playerid]>3&&GetPlayerVehicleID(playerid)==0&&weaponid>=22)
	{
	    RF_MSG="";
		new RF_GreenF, RF_RedF,RF_Average;
		for(new i = 1; i < RapidFireBulletC[playerid]; i++)
		{
		    if(RapidFireSession[playerid][i] < RF_Delay[weaponid-22] * 2)
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
		    format(RF_MSG, sizeof(RF_MSG), "%s (%i) is possibly using RapidFire. [Avg: %i][Normal: %i][Weapon: %i][TotBullets:%i/%i/%i]", PlayerName(playerid), playerid, (RF_Average/(RF_GreenF+RF_RedF)),RF_Delay[weaponid-22],weaponid,RapidFireBulletC[playerid],RapidFireMagC[playerid],RF_MagSize[weaponid-22]);
      		AntiCheatMessage(RF_MSG);
		    RapidFireS[playerid]++;
		}
		/*if(RapidFireS[playerid]%5==0 && RapidFireS[playerid]!=0)
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
		}*/
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
	if(weaponid<35 && weaponid>21 && GetPlayerVehicleID(playerid)==0)
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
			if(RapidFireMagC[playerid]>(RF_MagSize[weaponid-22]+1)&&(NetStats_GetConnectedTime(playerid)-NR_AntiSpam[playerid]>5000))
			{
			    NR_AntiSpam[playerid]=NetStats_GetConnectedTime(playerid);
  			 	format(RF_MSG, sizeof(RF_MSG), "[RF_AutoBan]: %s (%i) has been striked by RapidFire Script for no-reload.[WeaponID:%i] [TotBullets: %i | %i | %i]",PlayerName(playerid), playerid,weaponid,RapidFireBulletC[playerid],RapidFireMagC[playerid], RF_MagSize[weaponid-22]);
    			CheatLog(RF_MSG);
				if(RapidFire_AlreadyBanned[playerid]==0)
     			{
				    format(RF_MSG, sizeof(RF_MSG), "%s (%i) is possibly using No-Reload hack.", PlayerName(playerid), playerid);
                    AntiCheatMessage(RF_MSG);
			 	    /if(TAdminsOnline()==0 && AdminsOnline()==0)
     			    {
						RapidFire_AlreadyBanned[playerid]=1;
						ABanPlayer(-1, playerid, "NoReload[AC]");
					}
					else
					{
					    format(RF_MSG, sizeof(RF_MSG), "%s (%i) is possibly using No-Reload hack.", PlayerName(playerid), playerid);
                        AntiCheatMessage(RF_MSG);
					}/
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
	if(oldkeys&KEY_CROUCH && !(newkeys&KEY_CROUCH) && GetPlayerVehicleID(playerid)==0)
	{
	    LastCTime[playerid]=NetStats_GetConnectedTime(playerid);
	    if(cwatch[playerid]==true)
	    {
			format(RF_MSG, sizeof(RF_MSG), "[C_Watch]: %s(%i) has pressed Crouch Key.", PlayerName(playerid), playerid);
			SendAdminMessageToArray(PlayerCWatching[playerid], 10, RF_MSG, 1);
	    }
	}
	if(newkeys & KEY_FIRE == KEY_FIRE && RF_Loghim[playerid]==false && GetPlayerVehicleID(playerid)==0)
	{
	    if(GetPlayerWeapon(playerid)>21 && GetPlayerWeapon(playerid)<35)
		{
		    LastShotTime[playerid]=0;
			RF_Loghim[playerid]=true;
		}
	}
	else if(!(newkeys & KEY_FIRE) && RF_Loghim[playerid]==true && GetPlayerVehicleID(playerid)==0)
	{
        LastSessionAverage(playerid, GetPlayerWeapon(playerid));
        RapidFireMagC[playerid]=0;
		RF_Loghim[playerid]=false;
  	}
	return 1;
}

hook OnPlayerUpdate(playerid)
{
	if(GetPlayerWeapon(playerid)>21 && GetPlayerWeapon(playerid)<35 && GetPlayerVehicleID(playerid)==0)
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
	        if(RF_WatchAvg[targetid]==true)
	        {
	            RF_WatchAvg[targetid]=false;
	            format(RF_MSG, sizeof(RF_MSG), "AdmCmd(%i): %s %s has disabled RapidFire-Watch for %s(%i).",CMD_RFWCH, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
	        }
	        else
	        {
	            RF_WatchAvg[targetid]=true;
	            format(RF_MSG, sizeof(RF_MSG), "AdmCmd(%i): %s %s has enabled RapidFire-Watch for %s(%i).",CMD_RFWCH, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
	        }
	        SendAdminMessage(CMD_RFWCH, RF_MSG);
	    }
	}
	return 1;
}

CMD:cwatch(playerid, params[])
{
    if(IsAdmin(playerid, 1)==1)
	{
		new targetid;
		if(sscanf(params, "u", targetid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /givendamage [PlayerID/Part_of_PlayerName]");
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid playerID");
		}
		if(!IsPlayerConnected(targetid))
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player is not connected");
		}
		new CurrSlot = FindValueInArray(playerid, PlayerBeingCWatched[targetid], 10);
		new CurrPSlot = FindValueInArray(targetid, PlayerCWatching[playerid], 5);
		if(CurrSlot == -1 && CurrPSlot == -1)
		{
			if(IsArrayEmpty(PlayerBeingCWatched[targetid], 10, -1) == 9)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: WatchLog slot for this player is full. Use /whoiswatching [playerid][Log_Type] to know who.");
			}
			if(IsArrayEmpty(PlayerCWatching[playerid], 5, -1) == 4)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your Watchlog slot is full. Use /whoiswatching [playerid][Log_Type] to know who.");
			}
			if(IsArrayEmpty(PlayerBeingCWatched[targetid], 10, -1) == 0)
			{
				format(RF_MSG, sizeof(RF_MSG), "[Guardian]: GivenDamage Watch for %s(%i) has been enabled. Use /givendamage [ID/PlayerName]", PlayerName(targetid), targetid);
				SendAdminMessage(1, RF_MSG);
				cwatch[targetid] = true;
			}
			new SlotID = GetEmptySlot(PlayerBeingCWatched[targetid], 10, -1);
			new PSlotID = GetEmptySlot(PlayerCWatching[playerid], 5, -1);
			if(SlotID != -1 && PSlotID != -1)
			{
				format(RF_MSG, sizeof(RF_MSG), "[Guardian]: %s %s has started watching %s's crouch stroke.", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
				SendAdminMessageToArray(PlayerCWatching[playerid], 10, RF_MSG, 1);
				PlayerBeingCWatched[targetid][SlotID]=playerid;
				PlayerCWatching[playerid][PSlotID]=targetid;
				format(RF_MSG, sizeof(RF_MSG), "[NOTICE]: You are now watching %s's crouch stroke.", PlayerName(targetid));
				SendClientMessage(playerid, COLOR_NOTICE, RF_MSG);
			}
		}
		else
		{
			format(RF_MSG, sizeof(RF_MSG), "[NOTICE]: You have stopped watching %s's crouch stroke.", PlayerName(targetid));
			SendClientMessage(playerid, COLOR_NOTICE, RF_MSG);
			PlayerBeingCWatched[targetid][CurrSlot]=-1;
			PlayerCWatching[playerid][CurrPSlot]=-1;
			format(RF_MSG, sizeof(RF_MSG), "[NOTICE]: %s %s has stopped watching %s's crouch stroke.", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
	        SendAdminMessageToArray(PlayerCWatching[targetid], 10, RF_MSG, 1);
			if(IsArrayEmpty(PlayerBeingCWatched[targetid], 10, -1) == 0)
			{
				cwatch[targetid] = false;
				format(RF_MSG, sizeof(RF_MSG), "[Guardian]: Crouch Watch for %s(%i) is disabled.", PlayerName(targetid), targetid);
				SendAdminMessage(1, RF_MSG);
		    }
		}
	}
	return 1;
}

#if defined PTS
CMD:checkwatchslot(playerid, params[])
{
	for(new i =0; i<10; i++)
	{
	    format(RF_MSG, sizeof(RF_MSG), "%s BW - %i", RF_MSG, PlayerBeingCWatched[playerid][i]);
     	if(i<5)
	    {
	    	format(RF_MSG, sizeof(RF_MSG), "%s WG - %i", RF_MSG, PlayerCWatching[playerid][i]);
      	}
	}
	DebugMsg(RF_MSG);
	return 1;
}
#endif

