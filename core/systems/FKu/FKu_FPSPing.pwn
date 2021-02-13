//FPS and Ping Textlabe on each player by FKu
forward Dev_FKu_FPSpingsystem(playerid);
new FKu_string[50],FPS[MAX_PLAYERS],LastFPS[MAX_PLAYERS],sFPS[MAX_PLAYERS char],LsFPS[MAX_PLAYERS char];
new Text3D:textid[MAX_PLAYERS char],Text:FPStd[MAX_PLAYERS char],timer;
// -----------------------------------------------------------------------------
forward Dev_FKu_OnGameModeInit();
public Dev_FKu_OnGameModeInit()
{
	timer = SetTimer("FKu_FPSpingsystem",1010,true);
	for(new i;i<MAX_PLAYERS;i++)
	{
		FPStd[i] = TextDrawCreate(8.000000, 428.000000, "FPS: 00");
		TextDrawBackgroundColor(FPStd[i], 255);
		TextDrawFont(FPStd[i], 3);
		TextDrawLetterSize(FPStd[i], 0.480000, 2.000000);
		TextDrawColor(FPStd[i], -65281);
		TextDrawSetOutline(FPStd[i], 1);
		TextDrawSetProportional(FPStd[i], 1);
		TextDrawShowForPlayer(i,FPStd[i]);
	}
	return 1;
}
fowrard Dev_FKu_OnGameModeExit();
public Dev_FKu_OnGameModeExit()
{
	KillTimer(timer);
	for(new i;i<MAX_PLAYERS;i++) TextDrawDestroy(FPStd[i]);
	return 1;
}
forward Dev_FKu_OnPlayerConnect(playerid);
public Dev_FKu_OnPlayerConnect(playerid)
{
	textid{playerid} = Create3DTextLabel("FKu",0x96969699,0,0,0,30.0,0,1);
	Attach3DTextLabelToPlayer(textid{playerid},playerid,0,0,-0.80);
	return 1;
}
forward Dev_FKu_OnPlayerDisconnect(playerid);
public Dev_FKu_OnPlayerDisconnect(playerid)
{
	Delete3DTextLabel(textid{playerid});
	return 1;
}
forward Dev_FKu_FKu_FPSpingsystem(playerid);
public Dev_FKu_FPSpingsystem(playerid)
{
	foreach (new i : Player)
	{
		FPS[i] = GetPlayerDrunkLevel(i);
		if(FPS[i] < 10)	SetPlayerDrunkLevel(i,2000);
		sFPS{i} = LastFPS[i] - FPS[i];
		if(sFPS{i} > 101 || sFPS{i} < 20) sFPS{i} = LsFPS{i};
		format (FKu_string,sizeof(FKu_string),"{95e24f}FPS:{FFFFFF} %d\n{95e24f}Ping: {FFFFFF}%d",sFPS{i}-2,GetPlayerPing(i));
		Update3DTextLabelText(textid{i}, 0x95e24f99, FKu_string);
		format(FKu_string,sizeof(FKu_string),"FPS: %d",sFPS{i}-2);
		TextDrawSetString(FPStd[i],FKu_string);
		LastFPS[i] = FPS[i];
		LsFPS{i} = sFPS{i}
	}
	return 1;
}
