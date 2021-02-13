#include <YSI\y_hooks>

#define ADMCMD_FIRETP 1
new bool:FireTP[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    FireTP[playerid] = false;
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
    FireTP[playerid] = false;
	return 1;
}

CMD:firetp(playerid, params[])
{
	if(IsAdmin(playerid, ADMCMD_FIRETP))
	{
		if(ADuty[playerid])
		{
			new ftp_msg[150];
			if(FireTP[playerid] == true)
			{
				format(ftp_msg, sizeof(ftp_msg), "AdmCmd(%d): %s %s has disabled his automatic Fire-TP.", ADMCMD_FIRETP, GetPlayerStatus(playerid), PlayerName(playerid));
				FireTP[playerid] = false;
				SendAdminMessage(ADMCMD_FIRETP, ftp_msg);
				SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You have successfully disabled Fire-TP");
                SetPlayerAmmo(playerid, 34, 0);
				GivePlayerWeapon(playerid, GetPVarInt(playerid, "FTP_Sniper_1"), GetPVarInt(playerid, "FTP_Sniper_2"));
			}
			else
			{
				format(ftp_msg, sizeof(ftp_msg), "AdmCmd(%d): %s %s has enabled his automatic Fire-TP.", ADMCMD_FIRETP, GetPlayerStatus(playerid), PlayerName(playerid));
				FireTP[playerid] = true;
				SendAdminMessage(ADMCMD_FIRETP, ftp_msg);
				SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You have successfully enabled Fire-TP.");
				SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: Aim and Shoot with Sniper(Sniper[34]) to TP.");
				SetPVarInt(playerid, "FTP_Sniper_1", PossessedWeapons[playerid][6][WH_WeaponID]);
				SetPVarInt(playerid, "FTP_Sniper_2", PossessedWeapons[playerid][6][WH_Ammo]);
				GivePlayerWeapon(playerid, 34, 9999);
			}
		}
		else
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to be on Admin-Duty to use this command.");
		}
	}
	return 1;
}
forward F_TP_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public F_TP_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(FireTP[playerid] == true && ADuty[playerid])
	{
	    if(weaponid == WEAPON_SNIPER)
	    {
			new Float:fOriginX,
				Float:fOriginY,
				Float:fOriginZ,
				Float:fHitPosX,
				Float:fHitPosY,
				Float:fHitPosZ;
		    GetPlayerLastShotVectors(playerid, fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);
			SetPlayerPosFindZ(playerid, fHitPosX, fHitPosY, fHitPosZ);
			return 0;
		}
		else
		{
		    GameTextForPlayer(playerid, "~r~You can TP only using ~g~Sniper.", 1000, 4);
			return 0;
		}
	}
	return 1;
}
