forward brawl_EventStart(playerid);
forward brawl_PlayerJoinEvent(playerid);

public brawl_EventStart(playerid)
{
    if(BrawlX == 0.0)
	{
		GetPlayerPos(playerid, BrawlX, BrawlY, BrawlZ);
		GetPlayerFacingAngle(playerid, BrawlA);
		BrawlInt = GetPlayerInterior(playerid);
		BrawlVW = GetPlayerVirtualWorld(playerid);
		SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: Since you're a dick and forgot to set brawl location, it has been set to your current position.");
	}
    FoCo_Event_Rejoin = 1;
   	new
	    string[256];

	Event_ID = BRAWL;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Brawl event. {%06x}Type /(auto)join! Price: %d", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8, FFA_COST);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_FFA = 1;
	return 1;
}

public brawl_PlayerJoinEvent(playerid)
{
	
	GiveAchievement(playerid, 24);
	SetPVarInt(playerid,"PlayerStatus",1);
	SetPlayerPos(playerid, BrawlX, BrawlY, BrawlZ);
	SetPlayerFacingAngle(playerid, BrawlA);
	SetPlayerInterior(playerid, BrawlInt);
	SetPlayerHealth(playerid, 99);
	SetPlayerArmour(playerid, 0);
	SetPlayerVirtualWorld(playerid, BrawlVW);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ The ~h~ Brawl!", 800, 3);
	new string[32];
	if(FoCo_Player[playerid][level] >= MIN_LVL)
	{
	    if(GetPlayerMoney(playerid) > MIN_CASH)
	    {
	        GivePlayerMoney(playerid, -FFA_COST);
	        format(string, sizeof(string), "~r~-%d",FFA_COST);
			TextDrawSetString(MoneyDeathTD[playerid], string);
			TextDrawShowForPlayer(playerid, MoneyDeathTD[playerid]);
			defer cashTimer(playerid);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low amount of money.");
		}
	}
	else
 	{
  		SendClientMessage(playerid, COLOR_GREEN, "[INFO]: No entrance fee paid due to low level.");
	}
	return 1;
}