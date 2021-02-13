#include <YSI\y_hooks>
hook OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
	if(FoCo_Team[playerid] == FoCo_Team[i])
	{
		new Float:HealthAm = GetPlayerHealth(playerid);
		SetPlayerHealth(playerid,HealthAm+amount);
		HealthAm = GetPlayerHealth(issuerid);
		SetPlayerHealth(issuerid,HealthAm-amount);
	}
    return 1;
}

