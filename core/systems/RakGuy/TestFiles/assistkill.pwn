#include <YSI\y_hooks>

new Float:DamageTaken[MAX_PLAYERS][MAX_PLAYERS];


stock ClearDamageTaken(playerid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    DamageTaken[playerid][i] = 0.0;
	}
}

stock ClearDamageGiven(playerid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    DamageTaken[i][playerid] = 0.0;
	}
}

CMD:lasttakendamages(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
	    new targetid;
		if(sscanf(params, "u", targetid))
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /lasttakendamages [PlayerID/PlayerName]");
		if(targetid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerName/ID.");
		if(!IsPlayerConnected(targetid))
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerName/ID is not connected.");
	    new dmmsg[2700] = "[ID]Damager Name\tDamage\n";
		foreach(Player, i)
		{
		    if(DamageTaken[targetid][i] > 0.0 && i != targetid)
		    {
		        format(dmmsg, sizeof(dmmsg), "%s{00FF00}[%i]%s\t%.2f\n", dmmsg, i, PlayerName(i), DamageTaken[targetid][i]);
		    }
		}
		ShowPlayerDialog(playerid, DIALOG_NORETURN, DIALOG_STYLE_TABLIST_HEADERS, "Taken Damage of Player", dmmsg, "Close", "");
	}
	return 1;
}

CMD:lastgivendamages(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
	    new targetid;
		if(sscanf(params, "u", targetid))
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /lasttakendamages [PlayerID/PlayerName]");
		if(targetid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerName/ID.");
		if(!IsPlayerConnected(targetid))
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerName/ID is not connected.");
	    new dmmsg[2700] = "[ID]Victim Name\tDamage\n";
		foreach(Player, i)
		{
		    if(DamageTaken[i][targetid] > 0.0 && i != targetid)
		    {
		        format(dmmsg, sizeof(dmmsg), "%s{00FF00}[%i]%s\t%.2f\n", dmmsg, i, PlayerName(i), DamageTaken[i][targetid]);
		    }
		}
		ShowPlayerDialog(playerid, DIALOG_NORETURN, DIALOG_STYLE_TABLIST_HEADERS, "Given Damage of Player", dmmsg, "Close", "");
	}
	return 1;
}

CMD:damagegiven(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
	    new targetid, victimid;
		if(sscanf(params, "uu", targetid, victimid))
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /damagegiven [PlayerID/PlayerName] [VictimID/VictimName]");
		if(targetid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerName/ID.");
		if(!IsPlayerConnected(targetid))
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerName/ID is not connected.");
	    new dmmsg[128];
		format(dmmsg, sizeof(dmmsg), "[INFO]: Damage dealt to %s(%i) by %s(%i) is %.3f", PlayerName(victimid), victimid, PlayerName(targetid), targetid, DamageTaken[victimid][targetid]);
		SendClientMessage(playerid, COLOR_NOTICE, dmmsg);
	}
	return 1;
}

CMD:damagetaken(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
	    new targetid, victimid;
		if(sscanf(params, "uu", victimid, targetid))
		    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /damagetaken [PlayerID/PlayerName] [DamagerID/DamagerName]");
		if(targetid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerName/ID.");
		if(!IsPlayerConnected(targetid))
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: PlayerName/ID is not connected.");
	    new dmmsg[128];
		format(dmmsg, sizeof(dmmsg), "[INFO]: Damage dealt to %s(%i) by %s(%i) is %.3f", PlayerName(victimid), victimid, PlayerName(targetid), targetid, DamageTaken[victimid][targetid]);
		SendClientMessage(playerid, COLOR_NOTICE, dmmsg);
	}
	return 1;
}

hook OnPlayerConnect(playerid)
{
	ClearDamageTaken(playerid);
	ClearDamageGiven(playerid);
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	ClearDamageTaken(playerid);
	ClearDamageGiven(playerid);
	return 1;
}

forward KA_OnPlayerDamagePlayer(playerid, issuerid, Float:amount);
public KA_OnPlayerDamagePlayer(playerid, issuerid, Float:amount)
{
	DamageTaken[playerid][issuerid] = DamageTaken[playerid][issuerid]+amount;
	return 1;
}

forward KA_GivePlayerAssistKill(playerid, killerid);
public KA_GivePlayerAssistKill(playerid, killerid)
{
	if(killerid != INVALID_PLAYER_ID)
	{
		if(IsPlayerConnected(killerid))
		{
			if(ADuty[killerid] == 0)
			{
				if(FoCo_Team[playerid] != FoCo_Team[killerid])
				{
				    new string[128];
					format(string, sizeof(string), "[NOTICE]: You have been awarded %i for assisting kill on %s with %s.", 500, PlayerName(playerid), PlayerName(killerid));
					foreach(Player, i)
					{
					    if(FoCo_Team[i] == FoCo_Team[killerid])
					    {
							if(DamageTaken[playerid][i] >= 75.0 && i != killerid)
							{
							    FoCo_Playerstats[i][assists]++;
								SendClientMessage(i, COLOR_NOTICE, string);
								GivePlayerMoney(i, 75);
								if(FoCo_Playerstats[i][assists] % 3 == 0 && FoCo_Playerstats[i][assists] > 0)
								{
								    GivePlayerMoney(i, 150);
									FoCo_Playerstats[i][kills]++;
									SendClientMessage(i, COLOR_NOTICE, "[NOTICE]: You have been awarded a kill for assisting THREE kills.");
								}
							}
						}
					}
				}
			}
		}

	}
}

hook OnPlayerSpawn(playerid)
{
  	ClearDamageTaken(playerid);
	ClearDamageGiven(playerid);
	return 1;
}
