stock IsTAdmin(playerid)
{
	if(FoCo_Player[playerid][tester] > 0)
	    return 1;
	else
	    return 0;
}

stock TAdminsOnline()
{
	new Tcount;
	foreach(Player, i)
	{
	    if(FoCo_Player[i][tester] > 0)
			Tcount++;
	}
	return Tcount++;
}


AJailPlayer(playerid, targetid, reason[], time);
AWarnPlayer(playerid, targetid, reason[]);
AKickPlayer(playerid, targetid, reason[]);
ABanPlayer(playerid, targetid, reason[]);
ATempBanPlayer(playerid, targetid, reason[], days);
playerid = -1 = Guardian
