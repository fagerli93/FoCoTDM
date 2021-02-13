#include <YSI\y_hooks>

#define CAM_MAX_DISTANCE 9.0

new AFK_GHOST[MAX_PLAYERS][2]; // 0 - Strike \\\ 1 - Time
new agmsg[100];
new bool:IGNORE_CAMHACK[MAX_PLAYERS];

stock IsPlayerAiming(playerid)
{
	if(GetPlayerCameraMode(playerid) == 7 || GetPlayerCameraMode(playerid) == 8 || GetPlayerCameraMode(playerid) == 46 || GetPlayerCameraMode(playerid) == 51 || GetPlayerCameraMode(playerid) == 53)
		return 1;
	return 0;
}

hook OnPlayerConnect(playerid)
{
    AFK_GHOST[playerid][0] = 0;
    AFK_GHOST[playerid][1] = 0;
    IGNORE_CAMHACK[playerid] = false;
}

hook OnPlayerDisconnect(playerid)
{
    AFK_GHOST[playerid][0] = 0;
    AFK_GHOST[playerid][1] = 0;
    IGNORE_CAMHACK[playerid] = false;
}

ptask AFK[2000](playerid)
{
	//SendClientMessageToAll(-1, "Called");
	if(IsPlayerAiming(playerid) && !IGNORE_CAMHACK[permid])
	{
	    AFK_GHOST[playerid][1]++;
		if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING && AFK_GHOST[playerid][1] > 1)
		{
		    if(GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID)
		    {
				new Float:C_Pos[3];
				GetPlayerCameraPos(playerid, C_Pos[0], C_Pos[1], C_Pos[2]);
				if(GetPlayerDistanceFromPoint(playerid, C_Pos[0], C_Pos[1], C_Pos[2]) >= CAM_MAX_DISTANCE)
				{
					AFK_GHOST[playerid][0]++;
					if(AFK_GHOST[playerid][0] % 2 == 0)
					{
						format(agmsg, sizeof(agmsg), "%s(%i) is possibly using AFK-Ghost / CamHack.", PlayerName(playerid), playerid);
						AntiCheatMessage(agmsg);
					}
				}
			}
		}
	}
	else
	{
	    AFK_GHOST[playerid][1] = 0;
	    AFK_GHOST[playerid][0] = 0;
	}
}


IRCCMD:permitcamhack(botid, channel[], user[], host[], params[])
{
    if (IRC_IsOwner(botid, IRC_FOCO_LEADS, user))
	{
        new permid;
		if (sscanf(params, "u",permid))
		{
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, "[USAGE]: !permitcamhack [PlayerName/PlayerID]");
			return 1;
		}
		else
		{
			if(permid == INVALID_PLAYER_ID)
			{
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, "[ERROR]: Invalid Playername/PlayerID");
				return 1;
			}
			if(!IsPlayerConnected(permid))
			{
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, "[ERROR]: Player is not connected.");
				return 1;
			}
			new pch_msg[150];
			if(IGNORE_CAMHACK[permid] == false)
			{
			    format(pch_msg, sizeof(pch_msg), "iAdmCmd(1337): %s %s has given %s(%i) permission to use CamHack.", "Lead Admin", user, PlayerName(permid), permid);
                IRC_GroupSay(gLeads, IRC_FOCO_LEADS, pch_msg);
                SendAdminMessage(1, pch_msg);
			    format(pch_msg, sizeof(pch_msg), "[NOTICE]: %s %s has given you permission to use CamHack.", "Lead Admin", user);
                SendClientMessage(permid, COLOR_NOTICE, pch_msg);
                IRC_GroupSay(gLeads, IRC_FOCO_LEADS, "[NOTICE]: Use !permitcamhack again to revoke the permission.");
                IGNORE_CAMHACK[permid] = true;
			}
			else
			{
			    format(pch_msg, sizeof(pch_msg), "iAdmCmd(1337): %s %s has revoked %s(%i) permission to use CamHack.", "Lead Admin", user, PlayerName(permid), permid);
                IRC_GroupSay(gLeads, IRC_FOCO_LEADS, pch_msg);
			    format(pch_msg, sizeof(pch_msg), "[NOTICE]: %s %s has revoked your permission to use CamHack.", "Lead Admin", user);
                SendClientMessage(permid, COLOR_NOTICE, pch_msg);
                IGNORE_CAMHACK[permid] = false;
			}
		}
	}
	return 1;
}


CMD:permitcamhack(playerid, params[])
{
    if(IsAdmin(playerid, 5))
	{
        new permid;
		if (sscanf(params, "u",permid))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: !permitcamhack [PlayerName/PlayerID]");
		}
		else
		{
			if(permid == INVALID_PLAYER_ID)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid Playername/PlayerID");
			}
			if(!IsPlayerConnected(permid))
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player is not connected.");
			}
			new pch_msg[150];
			if(IGNORE_CAMHACK[playerid] == false)
			{
			    format(pch_msg, sizeof(pch_msg), "AdmCmd(5): %s %s has given %s(%i) permission to use CamHack.", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(permid), permid);
                SendAdminMessage(1, pch_msg);
                IRC_GroupSay(gLeads, IRC_FOCO_LEADS, pch_msg);
			    format(pch_msg, sizeof(pch_msg), "[NOTICE]: %s %s has given you permission to use CamHack.", GetPlayerStatus(playerid), PlayerName(playerid));
                SendClientMessage(permid, COLOR_NOTICE, pch_msg);
                SendAdminMessage(5, "[NOTICE]: Use /permitcamhack again to revoke the permission.");
                IGNORE_CAMHACK[playerid] = true;
			}
			else
			{
			    format(pch_msg, sizeof(pch_msg), "iAdmCmd(1337): %s %s has revoked %s(%i) permission to use CamHack.", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(permid), permid);
                IRC_GroupSay(gLeads, IRC_FOCO_LEADS, pch_msg);
                SendAdminMessage(1, pch_msg);
			    format(pch_msg, sizeof(pch_msg), "[NOTICE]: %s %s has revoked your permission to use CamHack. Do not use it from now!!!", GetPlayerStatus(playerid), PlayerName(playerid));
                SendClientMessage(permid, COLOR_NOTICE, pch_msg);
                IGNORE_CAMHACK[playerid] = false;
			}
		}
	}
	return 1;
}
