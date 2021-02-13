#include <YSI\y_hooks>

new bool:NameTagStatus[MAX_PLAYERS];

CMD:togglenames(playerid, params[])
{
	new bool:result = ((NameTagStatus[playerid] == true) ? (false) : (true));
	foreach(Player, i)
	{
		if(i != playerid)
			ShowPlayerNameTagForPlayer(playerid, i, result);
	}
	new nnmsg[128];
	format(nnmsg, sizeof(nnmsg), "~w~NameTag has been made %s.", ((result==false)?("~r~Invisible"):("~g~Visible")));
	NameTagStatus[playerid] = result;
	GameTextForPlayer(playerid, nnmsg, 2000, 4);
	return 1;
}

hook OnPlayerConnect(playerid)
{
	NameTagStatus[playerid] = true;
	foreach(Player, i)
	{
		if(i != playerid)
		{
			ShowPlayerNameTagForPlayer(i, playerid, NameTagStatus[i]);
			ShowPlayerNameTagForPlayer(playerid, i, true);
		}
 	}
	return 1;
}

hook OnPlayerStreamIn(playerid, forplayerid)
{
    ShowPlayerNameTagForPlayer(forplayerid, playerid, NameTagStatus[forplayerid]);
    ShowPlayerNameTagForPlayer(playerid, forplayerid, NameTagStatus[playerid]);
    return 1;
}
