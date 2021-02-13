stock IsTadmin(playerid)
{
	if(FoCo_Player[playerid][tester] > 0)
	    return 1;
	else
	    return 0;
}

stock TestersOnline()
{
	new Tcount;
	foreach(Player, i)
	{
	 	if(FoCo_Player[i][tester] > 0)
	 	    Tcount++;
	}
	return Tcount;
}
