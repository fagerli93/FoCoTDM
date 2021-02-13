#define CMDLMT_MPTP 1
#include <YSI\y_hooks>

forward ResetPlayerZ(playerid, Float:fX,Float:fY, Float:fZ);

new AllowMapTP[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
	AllowMapTP[playerid]=0;
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	AllowMapTP[playerid]=0;
	return 1;
}

hook OnPlayerSpawn(playerid)
{
	AllowMapTP[playerid]=0;
	return 1;
}


hook OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(AllowMapTP[playerid]==1)
	{
	    AllowMapTP[playerid]=2;
	    GameTextForPlayer(playerid, "~b~Press ~g~~k~~CONVERSATION_YES~ ~b~to Set Down. ~n~Press ~r~~k~~CONVERSATION_NO~ ~b~to Re-Set Map Value.", 3000, 3);
		if(IsPlayerInAnyVehicle(playerid))
		{
			RemovePlayerFromVehicle(playerid);
		}
		SetPlayerPosFindZ(playerid, fX, fY, 1000.0);
		TogglePlayerControllable(playerid,0);
	}
    return 1;
}

public ResetPlayerZ(playerid, Float:fX,Float:fY, Float:fZ)
{
    SetPlayerPosFindZ(playerid, fX, fY, 1000.0);
    SetCameraBehindPlayer(playerid);
    GameTextForPlayer(playerid, "~b~Press ~g~~k~~CONVERSATION_YES~ ~b~to Set Down. ~n~Press ~r~~k~~CONVERSATION_NO~ ~b~to Re-Set Map Value.", 3000, 3);
	AllowMapTP[playerid]=2;
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(AllowMapTP[playerid]==2)
	{
		if(newkeys&KEY_YES)
		{
		    AllowMapTP[playerid]=0;
			new TP_MSG[120];
			new MTP_2DLocation[28];
		    GetPlayer2DZone(playerid, MTP_2DLocation, sizeof(MTP_2DLocation));
			format(TP_MSG, sizeof(TP_MSG), "AdmCmd(%i): %s %s has used Map-Teleport to TP himself %s.", CMDLMT_MPTP, GetPlayerStatus(playerid), PlayerName(playerid), MTP_2DLocation);
			SendAdminMessage(CMDLMT_MPTP, TP_MSG);
		    TogglePlayerControllable(playerid,1);
		}
		if(newkeys&KEY_NO)
		{
            AllowMapTP[playerid]=3;
            new Float:Pos[3];
            GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			SetTimerEx("ResetPlayerZ", 500, false, "ifff", playerid, Pos[0], Pos[1], 1000.0);
		}
	}
	return 1;
}

CMD:maptp(playerid, params[])
{
	if(IsAdmin(playerid, CMDLMT_MPTP))
	{
	    if(AllowMapTP[playerid]==0)
	    {
	    	AllowMapTP[playerid]=1;
	    	return SendClientMessage(playerid, COLOR_SYNTAX, "[GUARDIAN]: Right-Click on Main-Map to TP to position.");
		}
		else if(AllowMapTP[playerid]==2)
		{
		    return GameTextForPlayer(playerid, "~b~Press ~g~~k~~CONVERSATION_YES~ ~b~to Set Down. ~n~Press ~r~~k~~CONVERSATION_NO~ ~b~to Re-Set Map Value.", 3000, 3);
		}
	}
	return 1;
}
