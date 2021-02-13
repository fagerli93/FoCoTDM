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
* Filename: pEar_skins.pwn                                                       *
* Author: pEar	                                                                 *
*********************************************************************************/

#include <YSI\y_hooks>

#define MAX_SKINS 312

forward reload_restricted_skins();

/*
	CJ
	Raider
	Scates
	Scates
*/

new static_restricted_skins[] = {0, 1, 2, 86, 92, 99, 74};

new bool:RestrictedSkin[MAX_SKINS];

hook OnGameModeInit()
{
	for(new i = 0; i < sizeof(static_restricted_skins); i++)
	{
		if(static_restricted_skins[i] >= 0 && static_restricted_skins[i] <= 311)
		{
			RestrictedSkin[static_restricted_skins[i]] = true;
		}
	}
	/*Rest of em blocked when the Teams are Loaded*/
	return 1;
}

CMD:skin(playerid, params[])
{
	if (isVIP(playerid) >= 2 || AdminLvl(playerid) >= ACMD_SILVER)
	{
 		if(GetPVarInt(playerid, "PlayerStatus") == 1)
		{
			SendClientMessage(playerid, COLOR_WARNING,  "[ERROR]:  You cannot use this in an event.");
			return 1;
		}
		new skinid;
		if (sscanf(params, "i", skinid))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /skin [Skin ID]");
			return 1;
		}
		if(skinid <= 0 || skinid > 311) {
			return SendErrorMessage(playerid, "This is not a valid skin!");
		}
		if(RestrictedSkin[skinid] == true)
		{
			return SendErrorMessage(playerid, "This skin is not selectable!");
		}
		new string[255];
		format(string, sizeof(string), "[NOTICE]: You have set your skin to %d, it will be kept until you log out.", skinid);
		SendClientMessage(playerid, COLOR_CMDNOTICE, string);
		if(GetPVarInt(playerid, "Resetskin") != 1)
		{
		    oldskin[playerid] = GetPlayerSkin(playerid);
		}
		SetPlayerSkin(playerid, skinid);
		SetPVarInt(playerid, "Resetskin", 1);
		SetPVarInt(playerid, "TempSkin", skinid);
		SetPVarInt(playerid, "ClanSkin", 0);
		DeleteAllAttachedWeapons(playerid);
		return 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be a silver donator to use this command");
		return 1;
	}
}




CMD:skinreset(playerid, params[])
{
	if(isVIP(playerid) >= 2 || AdminLvl(playerid) >= ACMD_SILVER)
	{
 		if(GetPVarInt(playerid, "Playerstatus") == 1)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command whilst in an event.");
		    return 1;
		}
		if(GetPVarInt(playerid, "Resetskin") != 1)
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You haven't used the /skin command, therefore cannot reset your skin.");
		    return 1;
		}
		else
		{
		    SetPlayerSkin(playerid, oldskin[playerid]);
		    SetPVarInt(playerid, "Resetskin", 0);
		    SetPVarInt(playerid, "TempSkin", 0);
		    SendClientMessage(playerid, COLOR_WHITE, "Your skin has been reset to your original skin ID.");
			return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be a silver donator to use this command");
		return 1;
	}
}

public reload_restricted_skins()
{
	for(new i = 0; i < MAX_SKINS; i++)
	{
	    RestrictedSkin[i] = false;
	}
	for(new i = 0; i < sizeof(static_restricted_skins); i++)
	{
		if(static_restricted_skins[i] >= 0 && static_restricted_skins[i] <= 311)
		{
			RestrictedSkin[static_restricted_skins[i]] = true;
		}
	}
	for(new i = 0; i < MAX_TEAMS; i++)
	{
		if(FoCo_Teams[i][team_skin_1] >= 0 && FoCo_Teams[i][team_skin_1] <= 311) RestrictedSkin[FoCo_Teams[i][team_skin_1]] = true;
		if(FoCo_Teams[i][team_skin_2] >= 0 && FoCo_Teams[i][team_skin_2] <= 311) RestrictedSkin[FoCo_Teams[i][team_skin_2]] = true;
		if(FoCo_Teams[i][team_skin_3] >= 0 && FoCo_Teams[i][team_skin_3] <= 311) RestrictedSkin[FoCo_Teams[i][team_skin_3]] = true;
		if(FoCo_Teams[i][team_skin_4] >= 0 && FoCo_Teams[i][team_skin_4] <= 311) RestrictedSkin[FoCo_Teams[i][team_skin_4]] = true;
		if(FoCo_Teams[i][team_skin_5] >= 0 && FoCo_Teams[i][team_skin_5] <= 311) RestrictedSkin[FoCo_Teams[i][team_skin_5]] = true;
	}
	return 1;	
}

/*
hook OnQueryFinish(query[], resultid, extraid, connectionHandle)
{
    switch(resultid)
	{
		case MYSQL_THREAD_RESTRICED_SKINS: 
		{
			mysql_store_result();
			if(mysql_num_rows() > 0) {
				new resultline[512];
				while(mysql_fetch_row_format(resultline))
				{
					
					new skins[5];
					new skin_amount;
					new ID;
					new string[20];
					sscanf(resultline, "ddddddd", ID, skins[0], skins[1], skins[2], skins[3], skins[4], skin_amount);
					format(string, sizeof(string), "ID: %d Skins[%d %d %d %d %d %d] A:%d", ID, skins[0], skins[1], skins[2], skins[3], skins[4], skin_amount);
					for(new i = 0; i < skin_amount; i++) {
						if(skins[i] != 0) {
							restricted_skins[restricted_skins_amount] = skins[i];
							restricted_skins_amount++;
							format(string, sizeof(string), "Team(%d): RS -> %d", ID, skins[i]);
							DebugMsg(string);
						}
					}
				}
				mysql_free_result();
			}
		}
	}
	return 1;
}
*/

stock IsValidSkin(skinid)
{
	if (skinid < 0 || skinid > 311)
	{	
		return 0;
	}
	return 1;
}

CMD:reload_restricted_skins(playerid, params[])
{	
	if(IsAdmin(playerid, ACMD_RELOAD_RESTRICTED_SKINS))
	{
		reload_restricted_skins();
		new string[156];
		format(string, sizeof(string), "AdmCmd(%d): %s %s reloaded all restricted skins", ACMD_RELOAD_RESTRICTED_SKINS, GetPlayerStatus(playerid), PlayerName(playerid));
		SendAdminMessage(ACMD_RELOAD_RESTRICTED_SKINS, string);
		AdminLog(string);
	}
	return 1;
}

/*CMD:restricted_skins(playerid, params[])
{
	new string[10];
	for(new i = 0; i < restricted_skins_amount; i++)
	{
		if(restricted_skins[i] != -1)
		{
			format(string, sizeof(string), "[%d] - %d", i, restricted_skins[i]);
			DebugMsg(string);	
		}
		
	}
	return 1;
}*/

CMD:restrictskin(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_RELOAD_RESTRICTED_SKINS))
	{
		new skinid;
		if(sscanf(params, "d", skinid))
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /restrictskin [SkinID]");
		if(skinid < 0 || skinid > 311)
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid SkinID. Refer http://wiki.sa-mp.com/wiki/Skins:All");
		for(new i = 0; i < sizeof(static_restricted_skins); i++)
		{
			if(skinid == static_restricted_skins[i] && AdminLvl(playerid) < 5)
			    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not allow permanently restricted skins.");
		}
		if(RestrictedSkin[skinid] == true)
		{
		    RestrictedSkin[skinid] = false;
		}
		else
		    RestrictedSkin[skinid] = true;
		new msg[128];
		format(msg, sizeof(msg), "AdmCmd(%i): %s %s has %s SkinID: %i", ACMD_RELOAD_RESTRICTED_SKINS, GetPlayerStatus(playerid), PlayerName(playerid), (RestrictedSkin[skinid] == true) ? ("Restricted") : ("Allowed"), skinid);
		SendAdminMessage(AdminLvl(playerid), msg);
	}
	return 1;
}
