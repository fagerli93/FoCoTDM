#include <foco>

#define CMD_RGLMT 1
#define CMD_LRGLMT 3

new RW_MSG[150];

CMD:removegun(playerid, params[])
{
	if(IsAdmin(playerid, CMD_RGLMT)==1)
	{
		new targetid, targetweap;
		if(sscanf(params, "ik<weapon>", targetid, targetweap))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE:] /removegun [PlayerID/Name][WeaponID/Name]");
		}
		else
		{
		    SetPlayerAmmo(targetid, targetweap, 0);
		    format(RW_MSG, sizeof(RW_MSG), "AdmCmd(%i) %s %s has removed weapon id %i from %s.", CMD_RGLMT, GetPlayerStatus(playerid), PlayerName(playerid), targetweap, PlayerName(targetid));
			SendAdminMessage(CMD_RGLMT, RW_MSG);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, RW_MSG);
		}
	}
	return 1;
}

CMD:removeweapon(playerid, params[])
{
	return cmd_removegun(playerid, params);
}



CMD:removelocalgun(playerid, params[])
{
	if(IsAdmin(playerid, CMD_LRGLMT)==1)
	{
		new Float:radius;
		new targetweap;
		if(sscanf(params, "k<weapon>f", targetweap, radius))
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE:] /removelocalgun [WeaponID/Name] [Radius]");
		}
		else
		{
		    if((radius<5.0 || radius>50.0) && AdminLvl(playerid)<4)
			{
			    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Radius can not be less than 5m or greater than 50m.");
			}
			if(radius>800.0 || radius <5.0)
			{
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Radius can not be less than 5m or greater than 800m.");
			}
			new Float:RW_Pos[3];
			new RW_VW = GetPlayerVirtualWorld(playerid);
			GetPlayerPos(playerid, RW_Pos[0], RW_Pos[1], RW_Pos[2]);
			foreach(Player, i)
			{
			    if(IsPlayerInRangeOfPoint(i, radius, RW_Pos[0], RW_Pos[1], RW_Pos[2]))
			    {
			        if(GetPlayerVirtualWorld(i)==RW_VW)
			        {
			        	SetPlayerAmmo(i, targetweap, 0);
					}
				}
			}
			format(RW_MSG, sizeof(RW_MSG), "AdmCmd(%i) %s %s has removed weapon id %i from people around radius %f.", CMD_LRGLMT, GetPlayerStatus(playerid), PlayerName(playerid), targetweap, radius);
			SendAdminMessage(1, RW_MSG);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, RW_MSG);
		}
		return 1;
	}
	return 1;
}








