#include <foco>

enum ckInfo
{
	Watchers[10],
	Watching[10],
	wiC,
	weC
}

new ckStorage[MAX_PLAYERS][ckInfo];

stock ckAdd(playerid, targetid)//Add a watcher/admin[playerid] for target[targetid]
{
	if(ckStorage[targetid][weC]==10)
	    return 0;
	for(new i=0; i<ckStorage[targetid][weC]; i++)
	{
	    if(ckStorage[targetid][Watchers][i]==playerid)
	        return 2;
	}
	ckStorage[targetid][Watchers][ckStorage[targetid][weC]]=playerid;
    ckStorage[targetid][weC]++;
	ckStorage[playerid][Watching][ckStorage[playerid][wiC]]=targetid;
    ckStorage[playerid][wiC]++;
	return 1;
}

stock ckRemove(playerid, targetid)
{
	if(ckStorage[targetid][weC]<=0)
	    return 0;
    new i;
	for(i=0; i<ckStorage[targetid][weC]; i++)
	{
	    if(ckStorage[targetid][Watchers][i]==playerid)
	        break;
		if(i==10&&ckStorage[targetid][Watchers][i]==playerid)
		    return 2;
	}
	ckStorage[targetid][weC]--;
	ckStorage[targetid][Watchers][i]=ckStorage[targetid][Watchers][ckStorage[targetid][weC]];
	ckStorage[targetid][Watchers][ckStorage[targetid][weC]]=-1;
	for(i=0; i<ckStorage[playerid][wiC]; i++)
	{
	    if(ckStorage[playerid][Watching][i]==targetid)
	        break;
	}
	ckStorage[playerid][wiC]--;
	ckStorage[playerid][Watching][i]=ckStorage[playerid][Watching][ckStorage[playerid][wiC]];
	ckStorage[playerid][Watching][ckStorage[playerid][wiC]]=-1;
	return 1;
}

stock ckClear(playerid)
{
	for(new i=0; i<10; i++)
	{
	    ckStorage[playerid][Watchers][i]=-1;
        ckStorage[playerid][Watching][i]=-1;
	}
	ckStorage[playerid][wiC]=0;
    ckStorage[playerid][weC]=0;
    return 1;
}

stock ckStopAllWatch(playerid)
{
	if(ckStorage[playerid][wiC]<=0)
	    return 0;
	for(new i=0; i<ckStorage[playerid][wiC]; i++)
	{
        ckRemove(playerid,ckStorage[playerid][Watching][i]);
	}
	return 1;
}

stock ckConDisc(playerid)
{
	if(ckStorage[playerid][wiC]=>1)
	{
	    ckStopAllWatch(playerid);
	}
	if(ckStorage[playerid][weC]=>1)
	{
	    new ckMSG[100];
	    format(ckMSG, sizeof(ckMSG), "[GUARDIAN]: %s has disconnected. You have stopping watching his C-Stroke.", PlayerName(playerid));
	    ckSendWarningMessage(playerid, ckMSG);
	    for(new i=0; i<ckStorage[playerid][weC]; i++)
	    {
	        ckRemove(ckStorage[playerid][Watchers][i],playerid);
	    }
	}
	return 1;
}


stock ckSendWarningMessage(playerid, ckMSG[])
{
    for(new i=0; i<ckStorage[playerid][weC]; i++)
	{
		SendClientMessage(ckStorage[playerid][Watchers][i], COLOR_SYNTAX, ckMSG);
	}
	return 1;
}













