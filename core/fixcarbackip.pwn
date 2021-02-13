CMD:fixcar(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_FIXCAR))
	{
		new targetid;
		new Float:health;
		if (sscanf(params, "if", targetid, health))
		{
			if(IsPlayerInAnyVehicle(playerid) == 0 && targetid == 0 && floatround(health) == 0)
			{
			    SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /fixcar [Optional: ID] [Optional: health (Requires ID)]");
				return 1;
			}
			else if(IsPlayerInAnyVehicle(playerid) == 1 && targetid == 0 && floatround(health) == 0)
			{
				new string[156];
				format(string, sizeof(string), "AdmCmd(%d): %s %s has repaired vehicle ID %d",ACMD_FIXCAR, GetPlayerStatus(playerid), PlayerName(playerid), GetPlayerVehicleID(playerid));
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
				SendAdminMessage(ACMD_FIXCAR,string);
				RepairVehicle(GetPlayerVehicleID(playerid));
				SendClientMessage(playerid, COLOR_CMDNOTICE, "[AdmCMD]: Vehicle fixed, remember you can use /fixcar [ID] to fix a different vehicle.");
				return 1;
			}
			if(targetid != 0)
			{
				RepairVehicle(targetid);
				new string[156];
				format(string, sizeof(string), "AdmCmd(%d): %s %s has repaired vehicle ID %d",ACMD_FIXCAR, GetPlayerStatus(playerid), PlayerName(playerid), targetid);
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
				SendAdminMessage(ACMD_FIXCAR,string);
				SendClientMessage(playerid, COLOR_CMDNOTICE, "[AdmCMD]: Vehicle fixed, remember you can use /fixcar on its own to fix the vehicle you're in.");
				return 1;
			}
			return 1;
		}
		if(GetVehicleModel(targetid) == 0)
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]:  That vehicle does not exist.");
			return 1;
		}
		SetVehicleHealth(targetid, health);
		if(health>=800.0)
		{
		    RepairVehicle(targetid);
		}
		new string[156];
		format(string, sizeof(string), "AdmCmd(%d): %s %s has repaired vehicle ID %d (%f)",ACMD_FIXCAR, GetPlayerStatus(playerid), PlayerName(playerid), targetid, health);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		SendAdminMessage(ACMD_FIXCAR,string);
	}
	return 1;
}
