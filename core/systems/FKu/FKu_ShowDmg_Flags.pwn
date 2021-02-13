enum ShowDmgFlag:(<<=1)
{
	SHOW_DMG,
	DMG_DEALT,
};

new ShowDmgFlag:Flags[MAX_PLAYERS];

new PlayerText:FKu_HIT[MAX_PLAYERS];
new Float:FKu_dmgt[MAX_PLAYERS];
new FKu_string[17];
new Float:FKu_dmg[MAX_PLAYERS];
new PlayerText:FKu_DMG[MAX_PLAYERS];
new FKu_dmgdlttmr[MAX_PLAYERS];
//new bool:FKu_dmgdealt[MAX_PLAYERS];
//new bool:ShowDmg[MAX_PLAYERS];

new const Float:FKu_Wep_DMG[] ={1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,
1.10,1.15,1.0,1.0,1.20,0.80,1.23,1.15,1.15,1.31,1.23,1.65,1.35,1.0,1.0};

CMD:togdmg(playerid, params[])
{
	if(ShowDmgFlag:Flags[playerid] & ShowDmgFlag:SHOW_DMG == 0) SendClientMessage(playerid,COLOR_CMDNOTICE,"Show damage is now {33cc00}on.");
	else SendClientMessage(playerid,COLOR_CMDNOTICE,"Show damage is now {cc3333}off.");
	Flags[playerid] ^= SHOW_DMG;
	return 1;
}

forward Dev_FKu_Dmg_OnPlayerConnect(playerid);
public Dev_FKu_Dmg_OnPlayerConnect(playerid)
{
	FKu_HIT[playerid] = CreatePlayerTextDraw(playerid,450.000000, 370.000000, "HIT");//HIT
	PlayerTextDrawLetterSize(playerid,FKu_HIT[playerid], 0.350000, 1.200000);
	PlayerTextDrawFont(playerid,FKu_HIT[playerid],3);
	PlayerTextDrawColor(playerid,FKu_HIT[playerid], 0xcc3700FF);
	PlayerTextDrawSetOutline(playerid,FKu_HIT[playerid], 1);
	FKu_DMG[playerid] = CreatePlayerTextDraw(playerid,160.000000, 370.000000, "DMG");//DMG
	PlayerTextDrawLetterSize(playerid,FKu_DMG[playerid], 0.350000, 1.200000);
	PlayerTextDrawFont(playerid,FKu_DMG[playerid],3);
	PlayerTextDrawColor(playerid,FKu_DMG[playerid], 0x92d800FF);
	PlayerTextDrawSetOutline(playerid,FKu_DMG[playerid], 1);
	return 1;
}

forward Dev_FKu_Dmg_OnPlayerDisconnect(playerid);
public Dev_FKu_Dmg_OnPlayerDisconnect(playerid)
{
	PlayerTextDrawDestroy(playerid,FKu_HIT[playerid]);
	PlayerTextDrawDestroy(playerid,FKu_DMG[playerid]);
	Flags[playerid] &= ~SHOW_DMG;
	return 1;
}

forward Dev_FKu_Dmg_OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid);
public Dev_FKu_Dmg_OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
	FKu_dmg[issuerid] =  amount*FKu_Wep_DMG[weaponid] + FKu_dmg[issuerid];
	format(FKu_string,sizeof(FKu_string),"DMG >~w~~h~ %d",floatround(FKu_dmg[issuerid],floatround_ceil));
	PlayerTextDrawSetString(issuerid,FKu_DMG[issuerid],FKu_string);
	if(ShowDmgFlag:Flags[issuerid] & ShowDmgFlag:SHOW_DMG) PlayerTextDrawShow(issuerid,FKu_DMG[issuerid]);

	FKu_dmgt[playerid] =  amount*FKu_Wep_DMG[weaponid] + FKu_dmgt[playerid];
	format(FKu_string,sizeof(FKu_string),"HIT >~w~~h~ %d",floatround(FKu_dmgt[playerid],floatround_ceil));
	PlayerTextDrawSetString(playerid,FKu_HIT[playerid],FKu_string);
	if(ShowDmgFlag:Flags[playerid] & ShowDmgFlag:SHOW_DMG ) PlayerTextDrawShow(playerid,FKu_HIT[playerid]);

	if(ShowDmgFlag:Flags[issuerid] & ShowDmgFlag:DMG_DEALT) KillTimer(FKu_dmgdlttmr[issuerid]);
	FKu_dmgdlttmr[issuerid] = SetTimerEx("FKu_destroydmgTD",3000,false,"dd",issuerid,playerid);
	Flags[playerid] |= SHOW_DMG;
    return 1;
}

forward FKu_destroydmgTD(playerid,enemyid);
public FKu_destroydmgTD(playerid,enemyid)
{
	PlayerTextDrawHide(playerid, FKu_DMG[playerid]);
	PlayerTextDrawHide(enemyid, FKu_HIT[enemyid]);
	Flags[playerid] |= SHOW_DMG;
	FKu_dmg[playerid] = 0;
	FKu_dmgt[enemyid] = 0;
    return 1;
}
