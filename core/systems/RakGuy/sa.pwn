#include <YSI\y_hooks>

#define DIALOG_NORETURN DIALOG_NO_RESPONSE

new SA_MSG[228];

enum sa_strike_det
{
	STR_CNT,
	Float:SA_LAST_VALUE,
	SA_PStrike
}
new SA_Strike[MAX_PLAYERS][sa_strike_det];
new bool:WatchSALog[MAX_PLAYERS];

stock IsWeaponFast(weaponid)
{
	switch(weaponid)
	{
	    case 22:
	        return 1;
	    case 28 .. 32:
	        return 1;
		case 38:
		    return 1;
	}
	return 0;
}

stock SA_IsPlayerAiming(playerid)
{
	if(GetPlayerCameraMode(playerid) == 7 || GetPlayerCameraMode(playerid) == 8 || GetPlayerCameraMode(playerid) == 46 || GetPlayerCameraMode(playerid) == 51 || GetPlayerCameraMode(playerid) == 53)
		return 1;
	return 0;
}

new SA_AutoBan[MAX_PLAYERS];

//Shifting to RakGuy WeaponShots
/*forward SilentAim_OnPlayerWeaponShot (playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public SilentAim_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
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
			}
   			format(SA_MSG, sizeof(SA_MSG), "[GUARDIAN]: %s shot at %s [Silent Aim Value: %.9f]", PlayerName(playerid), PlayerName(hitid), fHitPosX);
		    CheatLog(RF_MSG);
		}
		else
		    SA_Strike[playerid][SA_LAST_VALUE] = fHitPosX;
		//SUpposed to Removed From
		else if(fOriginX > 0.10 && posplayer < 0.10)
		{
 			if(WatchSALog[playerid] == true)
			{
			    format(SA_MSG, sizeof(SA_MSG), "[GUARDIAN]: %s shot at %s [Silent Aim Value:[ShotAt: %.9f] || [HitAt: %.9f]", PlayerName(playerid), PlayerName(hitid), fHitPosX, fOriginX);
   				SendAdminMessage(1, SA_MSG);
			}
		    SA_Strike[playerid][SA_LAST_VALUE] = fOriginX;
		    SA_Strike[playerid][SA_PStrike]= SA_Strike[playerid][SA_PStrike] + 1;
			if(SA_Strike[playerid][SA_PStrike]%5 == 0)
			{
				format(SA_MSG, sizeof(SA_MSG), "%s is possibly using Silentaimbot.", PlayerName(playerid));
				AntiCheatMessage(SA_MSG);
			}
			format(SA_MSG, sizeof(SA_MSG), "[GUARDIAN]: %s shot at %s [Silent Aim Value: %.9f]", PlayerName(playerid), PlayerName(hitid), fOriginX);
		    CheatLog(RF_MSG);
		}
		//TILL HERE
	}
	return 1;
}*/
hook OnPlayerConnect(playerid)
{
    SA_Strike[playerid][SA_LAST_VALUE] = 999.0;
    SA_Strike[playerid][SA_PStrike]=0;
    WatchSALog[playerid] = false;
    SA_AutoBan[playerid] = 0;
	return 1;
}
hook OnPlayerDisconnect(playerid)
{
	if(WatchSALog[playerid] == true)
	{
		format(SA_MSG, sizeof(SA_MSG), "[AntiCheat]: %s has logged while being in SilentAim-Watch.", PlayerName(playerid));
        WatchSALog[playerid] = false;
		return SendAdminMessage(1, SA_MSG);
	}
	if(SA_Strike[playerid][SA_PStrike]>=4)
	{
        WatchSALog[playerid] = false;
		format(SA_MSG, sizeof(SA_MSG), "[AntiCheat]: %s has logged with SilentAim Value.", PlayerName(playerid));
		return SendAdminMessage(1, SA_MSG);
	}
	SA_AutoBan[playerid] = 0;
	return 1;
}


CMD:salist(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new lmsg[2400]="PID\tPlayerName\tAmount";
		new flag=0;
		foreach(Player, i)
		{
		    if(SA_Strike[i][SA_PStrike]>=4)
		    {
		        format(lmsg, sizeof(lmsg), "%s\n%i\t%s\t%i", lmsg, i, PlayerName(i),SA_Strike[i][SA_PStrike]);
		        flag++;
		    }
		}
		if(flag==0)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[GUARDIAN]: Nobody is possibly using detectable SilentAim.");
		}
		else
		{
		    ShowPlayerDialog(playerid, DIALOG_NORETURN, DIALOG_STYLE_TABLIST_HEADERS, "SilentAim List", lmsg, "Cancel", "");
		}
	}
	return 1;
}

CMD:watchsa(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new targetid;
		if(sscanf(params, "u", targetid))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /watchsa [PlayerName/PlayerID]");
		}
		if(targetid != INVALID_PLAYER_ID && IsPlayerConnected(targetid))
		{
		    if(WatchSALog[targetid] == false)
		    {
		        SendAdminMessage(1, "[GUARDIAN]: Hey ladies, The [ShotAt: Value can not be 0.0] || [HitAt: Value can not be greater than 0.1]");
		        WatchSALog[targetid] = true;
		        format(SA_MSG, sizeof(SA_MSG), "AdmCmd(1): %s %s has enabled SilentAim-Watch for %s.", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
		    }
			else
			{
		        WatchSALog[targetid] = false;
		        format(SA_MSG, sizeof(SA_MSG), "AdmCmd(1): %s %s has disabled SilentAim-Watch for %s.", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
			}
			SendAdminMessage(1, SA_MSG);
		}
		else
		{
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerName/PlayerID");
		}
	}
	return 1;
}

