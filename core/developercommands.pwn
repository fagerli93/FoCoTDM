#if !defined MAIN_INIT
#error "Compiling from wrong script. (foco.pwn)"
#endif
// Testing

#define ACMD_3PD 1
#define ACMD_DEV 2
#define ACMD_SDEV 3
#define ACMD_LDEV 4
#define ACMD_HOD 5

#if defined PTS 

CMD:dsetadmin(playerid, params[])
{
	if(isDev(playerid, ACMD_DEV)) {
		new targetid, rank;
		if (sscanf(params, "ui", targetid, rank))
		{
			SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /dsetadmin [ID/Name] [Rank]");
			return 1;
		}
		if(targetid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
			return 1;
		}
		if(rank > 5)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid amount, must be below or equal to 5.");
			return 1;
		}
		new string[156];
		format(string, sizeof(string), "[AdmCMD]: %s %s has made you a %s (Rank %i).", GetPlayerStatus(playerid), PlayerName(playerid), AdRankNames[rank], rank);
		SendClientMessage(targetid, COLOR_NOTICE, string);
		format(string, sizeof(string), "Make sure you update yourself on the new commands by visiting the forum section for admins & /ahelp");
		SendClientMessage(targetid, COLOR_NOTICE, string);
		format(string, sizeof(string), "AdmCmd(%d): %s %s has made %s an admin(%d)",ACMD_SETADMIN, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), rank);
		SendAdminMessage(ACMD_SETADMIN,string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		FoCo_Player[targetid][admin] = rank;
		if(rank == 5)
		{
			GiveAchievement(targetid, 98);
		}
		else
		{
			GiveAchievement(targetid, 97);
		}
	}
	
	return 1;
}

CMD:test(playerid, params[]) {
	new string[512];
	format(string, sizeof(string), "Test: %d", FoCo_Playerstats[playerid][deaths]);
	//DebugMsg(string);
	return 1;
}

CMD:dgoto(playerid, params[])
{
	new targetid;
	if (sscanf(params, "u", targetid))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /goto [ID/Name]");
		return 1;
	}
	if(targetid == INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid ID/Name.");
		return 1;
	}
	if(GetPlayerState(targetid) == 9 || GetPlayerState(targetid) == 7)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  This player is currently spectating or not yet spawned.");
		return 1;
	}
	new string[128], Float:px, Float:py, Float:pz, vw_world, vw_int;
	GetPlayerPos(targetid, px, py, pz);
	vw_world = GetPlayerVirtualWorld(targetid);
	vw_int = GetPlayerInterior(targetid);
	SetPlayerVirtualWorld(playerid, vw_world);
	SetPlayerInterior(playerid, vw_int);
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		SetVehiclePos(GetPlayerVehicleID(playerid), px, py, pz);
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), vw_world);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), vw_int);
	}
	else
	SetPlayerPos(playerid, px+1, py, pz+1);
	format(string, sizeof(string), "                You teleported to %s.", PlayerName(targetid));
	SendClientMessage(playerid, COLOR_CMDNOTICE, string);
	return 1;
}




#endif