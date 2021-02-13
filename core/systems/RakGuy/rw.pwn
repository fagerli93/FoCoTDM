#define CMD_RGLMT 1
#define CMD_LRGLMT 3

new RW_MSG[150];

CMD:removegun(playerid, params[])
{
	if(IsAdmin(playerid, CMD_RGLMT)==1)
	{
		new targetid, gun[56], gunid;
  		if (sscanf(params, "us[56]i", targetid, gun))
    	{
     		SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /removeweapon [Player ID/Name] [Weapon ID/Name]");
            return 1;
       	}
       	if(targetid == INVALID_PLAYER_ID)
       	{
       		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid Player ID/Name.");
            return 1;
       	}
       	if(GetWeaponModelIDFromName(gun) == -1)
       	{
       		gunid = strval(gun);
         	if(gunid < 0 || gunid > 48)
          	{
           		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid Weapon ID/Name.");
                return 1;
            }
            if(gunid == 19||gunid == 20||gunid == 21)
            {
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid Weapon ID/Name.");
                return 1;
			}
      	}
      	else gunid = GetWeaponModelIDFromName(gun);
		SetPlayerAmmo(targetid, gunid, 0);
		format(RW_MSG, sizeof(RW_MSG), "AdmCmd(%i) %s %s has removed %s from %s.", CMD_RGLMT, GetPlayerStatus(playerid), PlayerName(playerid), WeapNames[gunid][WeapName], PlayerName(targetid));
		SendAdminMessage(CMD_RGLMT, RW_MSG);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, RW_MSG);
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
		new gun[56], gunid;
  		if (sscanf(params, "fs[56]i", radius, gun))
    	{
     		SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /removelocalgun [Radius] [Weapon ID/Name]");
            return 1;
       	}
       	if(GetWeaponModelIDFromName(gun) == -1)
       	{
       		gunid = strval(gun);
         	if(gunid < 0 || gunid > 48)
          	{
           		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid Weapon ID/Name.");
                return 1;
            }
            if(gunid == 19||gunid == 20||gunid == 21)
            {
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  Invalid Weapon ID/Name.");
                return 1;
			}
      	}
      	else gunid = GetWeaponModelIDFromName(gun);
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
		        	SetPlayerAmmo(i, gunid, 0);
				}
			}
		}
		format(RW_MSG, sizeof(RW_MSG), "AdmCmd(%i) %s %s has removed %s from people around radius %f.", CMD_LRGLMT, GetPlayerStatus(playerid), PlayerName(playerid), WeapNames[gunid][WeapName], radius);
		SendAdminMessage(1, RW_MSG);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, RW_MSG);
  		return 1;
	}
	return 1;
}








