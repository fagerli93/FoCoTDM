//#include <YSI\y_hooks>


#define Spec_TimerFix Timer:-1 //THIS IS THE FIX
//LINES EDITED: 8 , 14, 46
stock EndSpecTimer(playerid)
{
	if(DeathCamTimer[playerid]!=Spec_TimerFix) //PLACE EDITED
	{
	    TextDrawSetString(KillTD[playerid], " ");
		TextDrawHideForPlayer(playerid, KillTD[playerid]);
	    stop DeathCamTimer[playerid];
	    spawnSeconds[playerid]=-1;
		DeathCamTimer[playerid] = Spec_TimerFix; //PLACE EDITED
	}
	return 1;
}



public OnPlayerConnect(playerid)
{
    EndSpecTimer(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	EndSpecTimer(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	EndSpecTimer(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	//This below shit has to be replaced on two places. Below IF part and Else part.. :'(.. I dont see any difference in both.. wtf :P
    if(GetPVarInt(playerid,"PlayerStatus") != 2)
    {
		//Make sure you add the TEXT DRAW ACCORDINGLY..
		new string[120];
		if(DeathCamTimer[playerid]==Spec_TimerFix) //PLACE EDITED
		{
		    TogglePlayerSpectating(playerid, 1);
	        spawnSeconds[playerid]=7;
		    DeathCamTimer[playerid]=repeat SpawnSeconds(playerid);
		}
		else
		{
		    if(GetPlayerState(playerid)!=PLAYER_STATE_SPECTATING)
		    {
		        TogglePlayerSpectating(playerid, 1);
		    }
			EndSpecTimer(playerid);
		    spawnSeconds[playerid]=7;
		    DeathCamTimer[playerid]=repeat SpawnSeconds(playerid);
		}
	 	if(reason < 46 && reason > 0)
	    {
	    	format(string, sizeof(string), "~b~~h~~h~You were killed by ~y~~h~%s~b~~h~~h~ with a ~y~~h~%s~b~~h~~h~, respawning ~y~%d seconds..", PlayerName(killerid), WeapNames[reason][WeapName], spawnSeconds[playerid]);
	    }
	    else
	    {
			format(string, sizeof(string), "~b~~h~~h~You were killed by ~y~~h~%s~b~~h~~h~, respawning ~y~%d seconds..", PlayerName(killerid), spawnSeconds[playerid]);
		}
		TextDrawSetString(KillTD[playerid], string);
		TextDrawShowForPlayer(playerid, KillTD[playerid]);
	}
	//If its posted in IF part and Else part.. WHY even bother posting in both?
	//Just post it at the bottom or top.. if you know what i mean.. :P
	return 1;
}

timer SpawnSeconds[1000](playerid)
{
	SendClientMessageToAll(-1, "Working");
    new string[128];
	if(IsPlayerConnected(lastKiller[playerid]))
	{
		if(lastKillReason[playerid] > 45 && lastKillReason[playerid] < 0)
		{
			lastKillReason[playerid] = 0;
		}
		if(spawnSeconds[playerid] < 6 && spawnSeconds[playerid] > 2)
		{
			format(string, sizeof(string), "~b~~h~~h~You were killed by ~y~~h~%s~b~~h~~h~ with a ~y~~h~%s~b~~h~~h~, respawning ~y~%d seconds..", PlayerName(lastKiller[playerid]), WeapNames[lastKillReason[playerid]][WeapName], spawnSeconds[playerid]-1);
		}
		else if(spawnSeconds[playerid] < 3)
		{
			format(string, sizeof(string), "~b~~h~~h~You were killed by ~y~~h~%s~b~~h~~h~ with a ~y~~h~%s~b~~h~~h~, respawning ~g~~h~%d seconds..", PlayerName(lastKiller[playerid]), WeapNames[lastKillReason[playerid]][WeapName], spawnSeconds[playerid]-1);
		}
		else
		{
			format(string, sizeof(string), "~b~~h~~h~You were killed by ~y~~h~%s~b~~h~~h~ with a ~y~~h~%s~b~~h~~h~, respawning ~r~~h~%d seconds..", PlayerName(lastKiller[playerid]), WeapNames[lastKillReason[playerid]][WeapName], spawnSeconds[playerid]-1);
		}
	}
	else
	{
		format(string, sizeof(string), "~b~~h~~h~Your last killer has logged off, respawning ~r~~h~%d seconds..", spawnSeconds[playerid]-1);
	}
	TextDrawSetString(KillTD[playerid], string);
	//Till here - It wont cause any shit..
	//From here its edited.
	if((IsPlayerConnected(playerid)==0)|| spawnSeconds[playerid] <= 1 || GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
	{
		TogglePlayerSpectating(playerid, 0);
		EndSpecTimer(playerid);
	}
	else
	{
		spawnSeconds[playerid]--;
	}
}
