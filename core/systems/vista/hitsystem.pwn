/*

					*********************************************************************************
					*                                                                                *
					*             ______     _____        _______ _____  __  __                      *
					*            |  ____|   / ____|      |__   __|  __ \|  \/  |                     *
					*            | |__ ___ | |     ___      | |  | |  | | \  / |                     *
					*            |  __/ _ \| |    / _ \     | |  | |  | | |\/| |                     *
					*            | | | (_) | |___| (_) |    | |  | |__| | |  | |                     *
					*            |_|  \___/ \_____\___/     |_|  |_____/|_|  |_|                     *
					*                                                                                *
					*                                                                                *
					*                        (c) Copyright                                           *
					*  Owners: Simon Fagerli (pEar) - Lee Percox (Shaney) - Warren Bickley (WazzaJB) *
*         Developers: Marcel, RakGuy, FKu, Chilco, dr_vista, Fletcher            *
					*                                                                                *
					* Filename: hitsystem.pwn                                                        *
					* Author: dr_vista                                                               *
					**********************************************************************************
					
					
	Overview:
	
	-Everyone can complete hit contracts
	
	-When a player places a hit on another player:
	    -If he kills the player he put a contract on, the hit gets cancelled and the money is refunded
	    -If the player already has a hit but the amount is smaller than the new amount
	        -The new amount is placed as a hit contract
	        -The player which placed the smaller amount is refunded
		-If the player which has a hit contract dies of natural causes, the hit is cancelled and the money refunded
		-If the player wich has a hit disconnects, the money is refunded

	-The hit contract can be cancelled and the money will then be refunded

	-If an admin, while on a-duty, kills a player which has a hit placed on him, the hit isn't cancelled
	
	-Upon killing someone with a hit, a global message will be sent to everyone, and a game text will appear on the killer's screen
	
	-Hit stats may be saved
	
	-A command will show the current hits
	
	-Player with a hit contract on their head will have a 3D text label attached to them, it will show the hit amount
	
	-A fee will be taken from the refund amount
	
*/
#include <YSI\y_hooks>
/*enum E_Hit_Info
{
	HS_AMOUNT,
	HS_PLACERID[MAX_PLAYERS],
};*/

//new HitSys[MAX_PLAYERS][E_Hit_Info];
new HitSys_Amount[MAX_PLAYERS];
new HitSys_PlacerID[MAX_PLAYERS];
new Text3D:HitLabel[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
	HitSys_Amount[playerid]= 0;
	HitSys_PlacerID[playerid] = -1;
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	foreach(Player, i)
	{
	    if(playerid == HitSys_PlacerID[i])
	    {
			SendClientMessage(i, COLOR_GREEN, "[HIT]: Your hit placer has disconnected and therefore the hit on you was cancelled.");

			Delete3DTextLabel(HitLabel[i]);

			HitSys_Amount[i] = 0;
			HitSys_PlacerID[i] = -1;
		}
	}
	
	if(HitSys_Amount[playerid]!= 0)
	{
	    HitSys_Amount[playerid] = floatround( (HitSys_Amount[playerid] - ( HitSys_Amount[playerid] * 0.1 )), floatround_ceil);
		GivePlayerMoney(HitSys_PlacerID[playerid], HitSys_Amount[playerid]);
		new moneystring[256];
		format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from HitSystem_OnPlayerDisconnect.", PlayerName(HitSys_PlacerID[playerid]), HitSys_PlacerID[playerid], HitSys_Amount[playerid]);
		MoneyLog(moneystring);
		SendClientMessage(HitSys_PlacerID[playerid], COLOR_GREEN, "[HIT]: Your hit has disconnected and your hit money was refunded minus a 10 percent fee.");
		
		Delete3DTextLabel(HitLabel[playerid]);

		HitSys_Amount[playerid] = 0;
		HitSys_PlacerID[playerid] = -1;
	}
	return 1;
}
forward hs_OnPlayerDeath(playerid, killerid, reason);
public hs_OnPlayerDeath(playerid, killerid, reason)
{
    new
		string[77 + MAX_PLAYER_NAME];
		
    if(killerid != INVALID_PLAYER_ID)
    {
		if(HitSys_Amount[playerid] != 0 && killerid == HitSys_PlacerID[playerid])
		{
		    new Float:Returned_Cash = (HitSys_Amount[playerid] * 0.8);
		    new Returned_Cash_Int = floatround(Returned_Cash, floatround_floor);
			GivePlayerMoney(killerid, Returned_Cash_Int);
			new moneystring[256];
			format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from HitSystem_PlacerKillBounty.", PlayerName(killerid), killerid, Returned_Cash_Int);
			MoneyLog(moneystring);
		    format(string, sizeof(string), "[HIT]: %s has been killed by the hit placer and therefore the hit is cancelled.", PlayerName(playerid));
		    SendClientMessageToAll(COLOR_GREEN, string);
		    format(string, sizeof(string), "~w~Hit contract completed, 80 percent back, ~n~ received ~g~$%d", Returned_Cash_Int);
		    GameTextForPlayer(killerid, string, 3000, 5);
		    HitSys_Amount[playerid] = 0;
		    HitSys_PlacerID[playerid] = -1;
		    Delete3DTextLabel(HitLabel[playerid]);
		}
		else if(HitSys_Amount[playerid] != 0 && ADuty[playerid] == 0)
		{
		    new
				hitquery[128 + MAX_PLAYER_NAME];
				
		    format(string, sizeof(string), "[HIT]: %s has completed the hit contract on %s", PlayerName(killerid), PlayerName(playerid));
		    SendClientMessageToAll(COLOR_GREEN, string);
		    GiveAchievement(killerid, 13);
            FoCo_PlayerStats_hitscompleted[killerid]++;
            new Float:Returned_Cash = (HitSys_Amount[playerid] * 0.9);
		    new Returned_Cash_Int = floatround(Returned_Cash, floatround_floor);
		    GivePlayerMoney(killerid, Returned_Cash_Int);
			new moneystring[256];
			format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from HitSystem_KillHit.", PlayerName(killerid), killerid, Returned_Cash_Int);
			MoneyLog(moneystring);
		    format(string, sizeof(string), "~w~Hit contract completed ~n~ received ~g~$%d", Returned_Cash_Int);
		    GameTextForPlayer(killerid, string, 3000, 5);
		    format(string, sizeof(string), "[HIT]: The hit contract on %s was completed.", PlayerName(playerid));
		    SendClientMessage(HitSys_PlacerID[playerid], COLOR_GREEN, string);
		    HitSys_Amount[playerid] = 0;
		    HitSys_PlacerID[playerid] = -1;
		    Delete3DTextLabel(HitLabel[playerid]);
		    format(hitquery, sizeof(hitquery), "UPDATE `TBLNAME` SET `FIELDNAME  = `FIELDNAME` + 1 WHERE `USERNAMEFIELD` = %s", PlayerName(killerid));
		}
	}
	return 1;
}

CMD:hit(playerid, params[])
{
	new targetid, amount;
	if(sscanf(params, "ud", targetid, amount))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /hit [ID] [Amount]");
	}
	
	else if(targetid == cellmin)
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Multiple matches found.");
	}
	else if(targetid == INVALID_PLAYER_ID)
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The player you entered is not connected.");
	}
	else if(targetid == playerid)
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot place a hit on yourself.");
	}
	else if(GetPlayerMoney(playerid) < amount)
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not have that much cash.");
	}
	else if(amount > 10000000 || amount < 10000)
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The minimum amount is $10,000 and the maximum amount is $10,000,000.");
	}
	else
	{
	    new string[100 + MAX_PLAYER_NAME];
	    if(HitSys_Amount[targetid] >= amount)
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The player has already a hit contract with a bigger amount than yours.");
		}
		else if(HitSys_Amount[targetid] == 0)
		{
		    HitSys_Amount[targetid] = amount;
		    HitSys_PlacerID[targetid] = playerid;
		    
		    format(string, sizeof(string), "Hit contract: {FF0000}$%d", amount);
		    HitLabel[targetid] = Create3DTextLabel(string, 0xC0C0C0FF, 0.0, 0.0, 0.0, 40.0, 0, 1);
            Attach3DTextLabelToPlayer(HitLabel[targetid], targetid, 0, 0, 0);
            
			GivePlayerMoney(playerid, -amount);
			format(string, sizeof(string), "[HIT]: %s has placed a hit on %s for $%d", PlayerName(playerid), PlayerName(targetid), amount);
			SendClientMessageToAll(COLOR_GREEN, string);
			format(string, sizeof(string), "[HIT]: %s (%d) lost %d$ by placing a hit contract on %s (%d).", PlayerName(playerid), playerid, amount, PlayerName(targetid), targetid);
			MoneyLog(string);
			if(amount >= 10000)
			{
			    GiveAchievement(playerid, 60);
			    GiveAchievement(targetid, 62);
			    if(amount >= 50000)
			    {
			        GiveAchievement(playerid, 61);
			        GiveAchievement(targetid, 63);
			    }
			}
			
			format(string, sizeof(string), "[HIT]: %s has placed a hit on you for $%d", PlayerName(playerid), amount);
			SendClientMessage(targetid, COLOR_NOTICE, string);
		}
		else if(HitSys_Amount[targetid] < amount)
		{
 			GivePlayerMoney(HitSys_PlacerID[targetid], HitSys_Amount[targetid]);
			new moneystring[256];
			format(moneystring, sizeof(moneystring), "%s(%d) gained-back %d$ from Higher_PlaceHit on %s(%d).", PlayerName(HitSys_PlacerID[targetid]), HitSys_PlacerID[targetid], HitSys_Amount[targetid], PlayerName(targetid), targetid);
			MoneyLog(moneystring);
		    format(string, sizeof(string), "[HIT]: Someone has placed a bigger hit than yours on player %s, therefore your $%d were returned.", PlayerName(targetid), HitSys_Amount[targetid]);
		    SendClientMessage(HitSys_PlacerID[targetid], COLOR_NOTICE, string);
		    
		    HitSys_Amount[targetid] = amount;
		    HitSys_PlacerID[targetid] = playerid;
		    
		    format(string, sizeof(string), "Hit contract: {FF0000}$%d", amount);
            Update3DTextLabelText(HitLabel[targetid], 0xC0C0C0FF, string);
            
			GivePlayerMoney(playerid, -amount);
			format(string, sizeof(string), "[HIT]: %s (%d) lost %d$ by placing a hit contract on %s (%d).", PlayerName(playerid), playerid, amount, PlayerName(targetid), targetid);
			MoneyLog(string);
			format(string, sizeof(string), "[HIT]: %s has placed a hit on %s for $%d", PlayerName(playerid), PlayerName(targetid), amount);
			SendClientMessageToAll(COLOR_GREEN, string);
			
			format(string, sizeof(string), "[HIT]: %s has placed a hit on you for $%d", PlayerName(playerid), amount);
			SendClientMessage(targetid, COLOR_NOTICE, string);
		}
	}
	return 1;
}

CMD:hits(playerid, params[])
{
	new string[18 + (2*MAX_PLAYER_NAME)], count = 0;
	SendClientMessage(playerid, COLOR_GREEN, "============== {FFFFFF}[ HITS ] {33AA33}==============");
	foreach(Player, i)
	{
		if(HitSys_Amount[i] != 0)
		{
		    format(string, sizeof(string), "%s for $%d by %s", PlayerName(i), HitSys_Amount[i], PlayerName(HitSys_PlacerID[i]));
		    SendClientMessage(playerid, COLOR_GREEN, string);
		    count++;
		}
	}
	if(count == 0)
	{
	    SendClientMessage(playerid, COLOR_GREEN, "There is currently no hit contract.");
	}
	return 1;
}

CMD:cancelhit(playerid, params[])
{
	new targetid;

	if(sscanf(params, "?<CELLMIN_ON_MATCHES=1>?<MATCH_NAME_PARTIAL=1>u", targetid))
    {
		SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: {FFFFFF}/cancelhit{969696} [Player Name / ID] (This will return 70 percent of the total hit)");
	}
	
	else if(targetid == cellmin)
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Multiple matches found.");
	}
	else if(targetid == INVALID_PLAYER_ID)
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The player you entered is not connected.");
	}
	else if(targetid == playerid)
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot place a hit on yourself, therefore you can't cancel it.");
	}
	else
	{
	    if(HitSys_PlacerID[targetid] == playerid)
	    {
	        new string[128 + MAX_PLAYER_NAME];
	        
	        new Float:Returned_Cash = (HitSys_Amount[targetid] * 0.7);
		    new Returned_Cash_Int = floatround(Returned_Cash, floatround_floor);
			GivePlayerMoney(playerid, Returned_Cash_Int);
			new moneystring[256];
			format(moneystring, sizeof(moneystring), "%s(%d) gained-back %d$ from CancelHit on %s(%d).", PlayerName(playerid), playerid, Returned_Cash_Int, PlayerName(targetid), targetid);
			MoneyLog(moneystring);
		    format(string, sizeof(string), "[HIT]: You have cancelled the hit on %s and you 70 percent of the money has been refunded.", PlayerName(targetid));
		    SendClientMessage(playerid, COLOR_GREEN, string);
		    
		    GameTextForPlayer(targetid, "Hit contract cancelled", 2000, 3);
		    
		    format(string, sizeof(string), "[HIT]: %s has cancelled the hit contract on %s.", PlayerName(playerid), PlayerName(targetid));
		    SendClientMessageToAll(COLOR_GREEN, string);
		    
		    Delete3DTextLabel(HitLabel[targetid]);
		    HitSys_Amount[targetid] = 0;
		    HitSys_PlacerID[targetid] = -1;
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You haven't placed any hit contract on this player.");
	    }
	}
	return 1;
}
