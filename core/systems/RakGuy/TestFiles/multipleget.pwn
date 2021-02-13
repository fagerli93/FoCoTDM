#include <YSI\y_hooks>

CMD:gets(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new TargetIDs[25], Float:APos[3], IntVW[2];
		sscanf(params, "p< >A<u>(-1)[25]", TargetIDs);
		if(TargetIDs[0] == -1 || TargetIDs[0] == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /gets [PlayerName1/ID1] [PlayerName2/ID2] ... [PlayerName25/ID25]");
		GetPlayerPos(playerid, APos[0], APos[1], APos[2]);
		IntVW[1] = GetPlayerVirtualWorld(playerid);
		IntVW[0] = GetPlayerInterior(playerid);
		for(new i = 0; i < 25;  i++)
		{
		    if(TargetIDs[i] != -1 && TargetIDs[i] != INVALID_PLAYER_ID)
		    {
				SetPlayerInterior(TargetIDs[i], IntVW[0]);
				SetPlayerVirtualWorld(TargetIDs[i], IntVW[1]);
				SetPlayerPos(TargetIDs[i], APos[0]+1.0, APos[1]+1.0, APos[2]+1.0);
		    }
		}
		SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Players has been TPed.");
	}
	return 1;
}
