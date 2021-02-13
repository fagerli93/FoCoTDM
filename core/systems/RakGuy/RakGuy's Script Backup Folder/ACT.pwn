// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>
#include <zcmd>
#include <sscanf2>
new bool:ABS_T[MAX_PLAYERS];
//new ABS_CL[MAX_PLAYERS];
//new Float:ABS_ANG[MAX_PLAYERS][50];

public OnPlayerConnect(playerid)
{
	ABS_T[playerid]=false;
	return 1;
}

CMD:act(playerid, params[])
{
	new target;
	if(sscanf(params, "u", target))
	{
	    return SendClientMessage(playerid, -1, "[SYNTAX:] /abt [Playerid/Part_of_Name");
	}
	else
	{
		if(ABS_T[target]==true)
		{
		    ABS_T[target]=false;
		    SendClientMessage(playerid, -1, "Disabled");
		}
		else
		{
		    ABS_T[target]=true;
		    SendClientMessage(playerid, -1, "Enabled");
		}
	}
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(ABS_T[playerid]==true)
	{
	    if(hittype==BULLET_HIT_TYPE_PLAYER)
	    {
	        new MSG[50];
	        format(MSG, sizeof(MSG), "%i @ %i HitID - %i", playerid, GetPlayerTargetPlayer(playerid), hitid);
	        SendClientMessageToAll(-1, MSG);
	    }
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(ABS_T[playerid]==true)
	{
		new MSG[50];
		new Float:Angle;
		GetPlayerFacingAngle(playerid, Angle);
	    format(MSG, sizeof(MSG), "%i @ %i Angle - %f", playerid, GetPlayerTargetPlayer(playerid), Angle);
	    SendClientMessageToAll(-1, MSG);
	}
	return 1;
}
