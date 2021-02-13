/*********************************************************************************
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
* Filename: chilco_duel.pwn                                                      *
* Author: Chilco                                                                 *
*********************************************************************************/
#include <YSI\y_hooks>
#define MAX_DUELS 100
#define EXPIRE_TIME 30000

/*
Callbacks:
OnDialogResponse - foward Dev_Chilco_Duel_ODR(playerid, dialogid, response, listitem, inputtext[]);
OnPlayerDeath - foward Dev_Chilco_OPD(playerid, killerid, reason);


*/

forward DuelPlayerDeath(playerid,killerid,reason);

new Team_A_Amount[MAX_DUELS];
new Team_B_Amount[MAX_DUELS];
new Duel_Type[MAX_DUELS];
new Duel_Stake[MAX_DUELS];
new Team_A_1[MAX_DUELS];
new Team_A_2[MAX_DUELS];
new Team_A_3[MAX_DUELS];
new Team_B_1[MAX_DUELS];
new Team_B_2[MAX_DUELS];
new Team_B_3[MAX_DUELS];

new DuelExpireTimer[MAX_PLAYERS];



CMD:getpvar(playerid, params[])
{
	new PVar = GetPVarInt(playerid, "PlayerStatus");
	new string[128];

	format(string, sizeof(string), "[DEBUG]: PVarInt for %s(%d): %d", PlayerName(playerid), playerid, PVar);
	SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
	return 1;
}

CMD:duel(playerid, params[])
{
    if(GetPVarInt(playerid, "InEvent") == 1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't do that now.");
	}
	
    if(GetPVarInt(playerid, "PlayerStatus") != 0)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't do that whilst in a duel.");
	}
	
	
	if(!IsPlayerInAnyVehicle(playerid))
	{
		ShowPlayerDialog(playerid,550,DIALOG_STYLE_LIST,"Duel Configuration","1 vs. 1\n2 vs. 2\n3 vs. 3","Next","Cancel");
	}
	
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Leave your vehicle first.");
	}
	
	return 1;
}



new DuelMaps_Info[][] = // Name
{
    {"LV Rooftop 1"},
    {"LV Rooftop 2"},
    {"LS Rooftop 1"},
    {"Commerce"},
    {"Ghost Town"},
    {"RC Battleground"},
    {"Bloodbowl"},
    {"Paradiso Alleyway"},
    {"Meat Factory"},
    {"24/7 Store"},
    {"Willowfield"},
    {"Underground Garage"},
    {"Blueberry Acres"},
    {"SF Bridge"},
    {"Pleasure Domes"},
    {"Jefferson Motel"},
    {"LV PD"}
    
};

new DuelMaps_Info2[][] = // Interiors
{
    {0},{0},{0},{0},{0},{10},{15},{0},{1},{17},{0},{0},{0},{0},{3},{15},{3}
};

new Float:DuelMaps_Spawns_A[][] =
{
    {2343.1631,1743.4652,20.6406,269.4825},
    {2644.2043,1230.3147,26.9182,179.7432},
    {1804.6559,-1748.0149,52.4688,134.5653},
    {1547.7194,-1545.7653,13.5462,87.1496},
    {-409.3706,2279.7800,41.6843,190.6757},
    {-973.1579,1077.3397,1344.9962,91.2873},
    {-1340.7584,996.0392,1024.4777,87.6985},
    {-2463.7961,-100.2530,25.8606,181.4922},
    {949.7968,2110.9451,1011.0303,88.9832},
    {-32.7721,-185.3738,1003.5469,271.5138},
    {2343.0413,-2059.8743,21.2425,222.5102},
    {2337.1626,-1229.0807,22.5000,179.0879},
    {-37.4746,110.2308,3.1172,162.7083},
    {-1377.9521,660.5207,3.0703,38.0527},
    {-2637.3286,1406.1171,906.4609,87.1056},
    {2221.2847,-1148.3781,1025.7969,1.2538},
    {297.9829,174.2594,1007.1719,84.9071}

};
new Float:DuelMaps_Spawns_B[][] =
{
    {2407.6045,1742.8296,20.6406,89.4628},
    {2645.2397,1191.5135,26.9182,358.5536},
    {1753.0408,-1800.4835,52.4688,315.3810},
    {1459.2037,-1548.6002,13.5469,270.9294},
    {-386.3154,2173.0061,42.4766,9.5696},
    {-1132.0181,1041.7253,1345.7401,267.6307},
    {-1438.3345,995.3775,1024.1788,269.8948},
    {-2482.5520,-179.4104,25.6172,0.3026},
    {953.8614,2161.1318,1011.0234,90.9050},
    {-5.4394,-173.5894,1003.5469,91.5677},
    {2375.3474,-2092.1157,21.2425,43.9107},
    {2337.8313,-1260.5941,22.5076,359.3187},
    {-115.9792,-124.7456,3.1172,346.2477},
    {-1392.1119,679.9294,3.0703,215.5435},
    {-2675.4592,1420.9623,906.4647,271.7782},
    {2193.4644,-1144.5282,1029.7969,181.7543},
    {206.6256,168.1700,1003.0234,271.2097}
    
    
};

hook OnPlayerDisconnect(playerid, reason)
{
    if(GetPVarInt(playerid, "PlayerStatus") == 2)
	{
	    new duelid = GetPVarInt(playerid, "Duel_ID");

	    new messagestr[200];
	    format(messagestr,200, "[DUEL] %s disconnected, causing the duel to end.", PlayerName(playerid));
	    SendClientMessageToAll(COLOR_GREEN, messagestr);
	    
	    new stake = Duel_Stake[duelid];
	    foreach(Player,i)
		{
		    if(GetPVarInt(i, "Duel_ID") == duelid)
		    {
		        GivePlayerMoney(i, stake);
		    }
		}
		ResetDuel(duelid);
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    new dialog_str[356];
	if(dialogid == 550)
	{
	    if(response)
	    {
			if(listitem == 0) // 1 v 1
			{
			    ShowPlayerDialog(playerid,551,DIALOG_STYLE_INPUT,"Duel Configuration (1 vs 1)","Please insert the exact name of the player you wish to duel with:","Next","Cancel");
			}
			if(listitem == 1) // 2 v 2
			{
                ShowPlayerDialog(playerid,559,DIALOG_STYLE_INPUT,"Duel Configuration (2 vs 2)","Please insert the exact name of the player you wish to have in your team:","Next","Cancel");
			}
			if(listitem == 2) // 3 v 3
			{
			    if(isVIP(playerid) == 3 || AdminLvl(playerid) >= ACMD_GOLD)
			    {
					ShowPlayerDialog(playerid,563,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","Please insert the exact name of the FIRST player you wish to have in your team:","Next","Cancel");
			    }
				else
				{					
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be Gold Donator to use this feature.");
					return 1;
				}
			}
	    }

	}
	if(dialogid == 551)
	{
	    if(response)
	    {
		    if(strlen(inputtext)  == 0)
			{
	            ShowPlayerDialog(playerid,551,DIALOG_STYLE_INPUT,"Duel Configuration (1 vs 1)","Don't leave it blank!\n\nPlease insert the exact name of the player you wish to duel with:","Next","Cancel");
	            return 1;
			}
            SetPVarInt(playerid, "Duel_Type", 1);
		    foreach(Player,i)
		    {
				if(i != playerid)
				{
					if(!strcmp(inputtext, PlayerName(i), true))
					{
						if(GetPVarInt(i, "Duel_Invite_Pending") == 1)
						{
							ShowPlayerDialog(playerid,551,DIALOG_STYLE_INPUT,"Duel Configuration (1 vs 1)","This player already has an invite pending.\n\nPlease insert the exact name of the player you wish to duel with:","Next","Cancel");
							return 1;
						}
						if(GetPVarInt(i, "PlayerStatus") == 2)
						{
							ShowPlayerDialog(playerid,551,DIALOG_STYLE_INPUT,"Duel Configuration (1 vs 1)","This player is already dueling!\n\nPlease insert the exact name of the player you wish to duel with:","Next","Cancel");
							return 1;
						}
						
					    ShowPlayerDialog(playerid,552,DIALOG_STYLE_INPUT,"Duel Configuration", "Do you wish to have armour in the duel? Type Yes/No","Next","Cancel");
					    if(GetPVarInt(playerid, "Duel_Type") == 1)
					    {
					    	SetPVarInt(playerid, "Duel_1v1_Opponent_ID", i);
					    }
					    return 1;

					}
					else
					{
					    ShowPlayerDialog(playerid,551,DIALOG_STYLE_INPUT,"Duel Configuration (1 vs 1)","That player was not found!\n\nPlease insert the exact name of the player you wish to duel with:","Next","Cancel");
					}
				}
		    }
	    }
	}
	
	if(dialogid == 552)
	{
	    if(response)
	    {
	        if(strlen(inputtext)  == 0)
			{
	            ShowPlayerDialog(playerid,552,DIALOG_STYLE_INPUT,"Duel Configuration","Don't leave it blank!\n\nDo you wish to have armour in the duel? Type Yes/No","Next","Cancel");
	            return 1;
			}
	        if(!strcmp(inputtext, "Yes", true, 3)) SetPVarInt(playerid, "Duel_Armour", 1);
	        if(!strcmp(inputtext, "No", true, 2)) SetPVarInt(playerid, "Duel_Armour", 0);
	        
	        ShowPlayerDialog(playerid,553,DIALOG_STYLE_INPUT,"Duel Configuration", "Do you wish to have CJ-run enabled? Type Yes/No","Next","Cancel");
			    
	    }
	}
	if(dialogid == 553)
	{
	    if(response)
	    {
	        if(strlen(inputtext)  == 0)
			{
	            ShowPlayerDialog(playerid,553,DIALOG_STYLE_INPUT,"Duel Configuration","Don't leave it blank!\n\nDo you wish to have CJ-run enabled? Type Yes/No","Next","Cancel");
	            return 1;
			}
			if(!strcmp(inputtext, "Yes", true, 3)) SetPVarInt(playerid, "Duel_CJ", 1);
			if(!strcmp(inputtext, "No", true, 2)) SetPVarInt(playerid, "Duel_CJ", 0);
 
			format(dialog_str,sizeof(dialog_str), "Deagle\nMP5\nShotgun\nCombat Shotgun\nSawn-off Shotgun\nCountry Rifle\nSniper Rifle\nAK-47\nM4\nUZI\nTec-9");
   			ShowPlayerDialog(playerid,554,DIALOG_STYLE_LIST,"Duel Configuration - Weapon selection (1/2)", dialog_str,"Next","Cancel");
		}
	}
	if(dialogid == 554)
	{
	    if(response)
	    {
			switch(listitem)
        	{
        	    case 0: SetPVarInt(playerid, "Duel_Wep1", 24);
				case 1: SetPVarInt(playerid, "Duel_Wep1", 29);
        	    case 2: SetPVarInt(playerid, "Duel_Wep1", 25);
				case 3: SetPVarInt(playerid, "Duel_Wep1", 27);
        	    case 4: SetPVarInt(playerid, "Duel_Wep1", 26);
        	    case 5: SetPVarInt(playerid, "Duel_Wep1", 33);
        	    case 6: SetPVarInt(playerid, "Duel_Wep1", 34);
        	    case 7: SetPVarInt(playerid, "Duel_Wep1", 30);
        	    case 8: SetPVarInt(playerid, "Duel_Wep1", 31);
        	    case 9: SetPVarInt(playerid, "Duel_Wep1", 28);
        	    case 10: SetPVarInt(playerid, "Duel_Wep1", 32);
        	}
			format(dialog_str,sizeof(dialog_str), "{FF0000}No secondary weapon\n{000000}.{FFFFFF}\nDeagle\nMP5\nShotgun\nCombat Shotgun\nSawn-off Shotgun\nCountry Rifle\nSniper Rifle\nAK-47\nM4\nUZI\nTec-9");
   			ShowPlayerDialog(playerid,555,DIALOG_STYLE_LIST,"Duel Configuration - Weapon selection (2/2)", dialog_str,"Next","Cancel");
		}
	}
	if(dialogid == 555)
	{
	    if(response)
	    {
			switch(listitem)
        	{
        	    case 0: SetPVarInt(playerid, "Duel_Wep2", 0);
        	    case 1: SetPVarInt(playerid, "Duel_Wep2", 0);
        	    case 2: SetPVarInt(playerid, "Duel_Wep2", 24);
        	    case 3: SetPVarInt(playerid, "Duel_Wep2", 29);
        	    case 4: SetPVarInt(playerid, "Duel_Wep2", 25);
        	    case 5: SetPVarInt(playerid, "Duel_Wep2", 27);
        	    case 6: SetPVarInt(playerid, "Duel_Wep2", 26);
        	    case 7: SetPVarInt(playerid, "Duel_Wep2", 33);
        	    case 8: SetPVarInt(playerid, "Duel_Wep2", 34);
        	    case 9: SetPVarInt(playerid, "Duel_Wep2", 30);
        	    case 10: SetPVarInt(playerid, "Duel_Wep2", 31);
        	    case 11: SetPVarInt(playerid, "Duel_Wep2", 28);
        	    case 12: SetPVarInt(playerid, "Duel_Wep2", 32);
        	}
   			ShowPlayerDialog(playerid,556,DIALOG_STYLE_LIST,"Duel Configuration - Map Selection", "LV Rooftop 1\nLV Rooftop 2\nLS Rooftop 1\nCommerce\nGhost Town\nRC Battleground\nBloodbowl\nParadiso Alleyway\nMeat Factory\n24/7 Store\nWillowfield\nUnderground Garage\nBlueberry Acres\nSF Bridge\nPleasure Domes\nJefferson Motel\nLV PD","Next","Cancel");
		}
	}
	if(dialogid == 556)
	{
	    if(response)
	    {
			switch(listitem)
        	{
        	    case 0: SetPVarInt(playerid, "Duel_Map", 0);
        	    case 1: SetPVarInt(playerid, "Duel_Map", 1);
        	    case 2: SetPVarInt(playerid, "Duel_Map", 2);
        	    case 3: SetPVarInt(playerid, "Duel_Map", 3);
        	    case 4: SetPVarInt(playerid, "Duel_Map", 4);
        	    case 5: SetPVarInt(playerid, "Duel_Map", 5);
        	    case 6: SetPVarInt(playerid, "Duel_Map", 6);
        	    case 7: SetPVarInt(playerid, "Duel_Map", 7);
        	    case 8: SetPVarInt(playerid, "Duel_Map", 8);
        	    case 9: SetPVarInt(playerid, "Duel_Map", 9);
        	    case 10: SetPVarInt(playerid, "Duel_Map", 10);
        	    case 11: SetPVarInt(playerid, "Duel_Map", 11);
        	    case 12: SetPVarInt(playerid, "Duel_Map", 12);
        	    case 13: SetPVarInt(playerid, "Duel_Map", 13);
        	    case 14: SetPVarInt(playerid, "Duel_Map", 14);
        	    case 15: SetPVarInt(playerid, "Duel_Map", 15);
        	    case 16: SetPVarInt(playerid, "Duel_Map", 16);

        	}
        	ShowPlayerDialog(playerid,557,DIALOG_STYLE_INPUT,"Duel Configuration", "Do you wish to place a stake? (OPTIONAL)\n\n{FFFFFF}Min: $1.000 - Max $500.000\n{a9c4e4}Type in the amount you wish to place as a stake:","Stake","No stake");
        }
	}
	if(dialogid == 557)
	{
	    new Value;
	    if(response)
	    {
			Value = strval(inputtext);
			if(Value < 1000 || Value > 500000)
			{
			    ShowPlayerDialog(playerid,557,DIALOG_STYLE_INPUT,"Duel Configuration", "That is an invalid amount.\n\nDo you wish to place a stake? (OPTIONAL)\n\n{FFFFFF}Min: $1.000 - Max $500.000\n{a9c4e4}Type in the amount you wish to place as a stake:","Stake","No stake");
			    return 1;
			}
			else if(Value > GetPlayerMoney(playerid)) return SendClientMessage(playerid, COLOR_NOTICE, "You don't have enough money.");
			if(GetPVarInt(playerid, "Duel_Type") == 1)
			{
				if(Value > GetPlayerMoney(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"))) return SendClientMessage(playerid, COLOR_NOTICE, "This player doesn't have enough money.");
			}
			if(GetPVarInt(playerid, "Duel_Type") == 2)
			{
			    if(Value > GetPlayerMoney(GetPVarInt(playerid, "Duel_2v2_Teammate_ID")) || Value > GetPlayerMoney(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID")) || Value > GetPlayerMoney(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"))) return SendClientMessage(playerid, COLOR_NOTICE, "One or more players don't have enough money.");
			}
			
	    }
	    
	    SetPVarInt(playerid, "Duel_Stake", Value);
		new CJRun[4];
		if(GetPVarInt(playerid, "Duel_CJ") == 1)
		{
			format(CJRun, sizeof(CJRun), "On");
		}
		else
		{
			format(CJRun, sizeof(CJRun), "Off");
		}

		new Armour[4];
		if(GetPVarInt(playerid, "Duel_Armour") == 1)
		{
			format(Armour, sizeof(Armour), "On");
		}
		else
		{
			format(Armour, sizeof(Armour), "Off");
		}

		if(GetPVarInt(playerid, "Duel_Type") == 1)
		{
			format(dialog_str,sizeof(dialog_str), "You're about to duel: {FFFFFF}%s{a9c4e4}\nArmour: {FFFFFF}%s{a9c4e4}\nCJ Run: {FFFFFF}%s{a9c4e4}\n\n{FF0000}Stake: $%d{a9c4e4}\n\nWeapon 1: {FFFFFF}%s{a9c4e4}\nWeapon 2: {FFFFFF}%s{a9c4e4}\n\nMap: {FFFFFF}%s", PlayerName(GetPVarInt(playerid, "Duel_1v1_Opponent_ID")), Armour, CJRun, Value, WeaponName(GetPVarInt(playerid, "Duel_Wep1")), WeaponName(GetPVarInt(playerid, "Duel_Wep2")), DuelMaps_Info[GetPVarInt(playerid, "Duel_Map")][0]);
			ShowPlayerDialog(playerid,558,DIALOG_STYLE_MSGBOX,"Duel Configuration (1 vs 1)", dialog_str,"Request","Cancel");
		}
		if(GetPVarInt(playerid, "Duel_Type") == 2)
		{
			format(dialog_str,sizeof(dialog_str), "TEAM A: {FFFFFF}\n%s\n%s\n\n{a9c4e4}TEAM B: {FFFFFF}\n%s\n%s\n\n{a9c4e4}Armour: {FFFFFF}%s{a9c4e4}\nCJ Run: {FFFFFF}%s{a9c4e4}\n\n{FF0000}Stake: $%d{a9c4e4}\n\nWeapon 1: {FFFFFF}%s{a9c4e4}\nWeapon 2: {FFFFFF}%s{a9c4e4}\n\nMap: {FFFFFF}%s", PlayerName(playerid), PlayerName(GetPVarInt(playerid, "Duel_2v2_Teammate_ID")), PlayerName(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID")), PlayerName(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID")), Armour,
			CJRun, Value, WeaponName(GetPVarInt(playerid, "Duel_Wep1")), WeaponName(GetPVarInt(playerid, "Duel_Wep2")), DuelMaps_Info[GetPVarInt(playerid, "Duel_Map")][0]);
			// One line ^
			
			ShowPlayerDialog(playerid,558,DIALOG_STYLE_MSGBOX,"Duel Configuration (2 vs 2)", dialog_str,"Request","Cancel");
		
		}
		if(GetPVarInt(playerid, "Duel_Type") == 3)
		{
			format(dialog_str,sizeof(dialog_str), "TEAM A: {FFFFFF}\n1. %s\n2. %s\n3. %s\n\n{a9c4e4}TEAM B: {FFFFFF}\n1. %s\n2. %s\n3. %s\n\n{a9c4e4}Armour: {FFFFFF}%s{a9c4e4}\nCJ Run: {FFFFFF}%s{a9c4e4}\n\n{FF0000}Stake: $%d{a9c4e4}\n\nWeapon 1: {FFFFFF}%s{a9c4e4}\nWeapon 2: {FFFFFF}%s{a9c4e4}\n\nMap: {FFFFFF}%s", PlayerName(playerid), PlayerName(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID")),
			PlayerName(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID")), Armour, CJRun, Value, WeaponName(GetPVarInt(playerid, "Duel_Wep1")), WeaponName(GetPVarInt(playerid, "Duel_Wep2")), DuelMaps_Info[GetPVarInt(playerid, "Duel_Map")][0]);
			// One line ^
			
			ShowPlayerDialog(playerid,558,DIALOG_STYLE_MSGBOX,"Duel Configuration (3 vs 3)", dialog_str,"Request","Cancel");
		}
	}
	if(dialogid == 558)
	{
	    if(response)
	    {
	        if(GetPVarInt(playerid, "Duel_Type") == 1)
			{
		        if(GetPVarInt(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), "Duel_Invite_Pending") == 1)
				{
				    SendClientMessage(playerid, COLOR_NOTICE, "It seems this player already has a duel request pending.");
				    return 1;
				}
	   			if(GetPVarInt(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), "PlayerStatus") == 2)
				{
				    SendClientMessage(playerid, COLOR_NOTICE, "It seems this player is already dueling.");
				    return 1;
				}
			}
			if(GetPVarInt(playerid, "Duel_Type") == 2)
			{
			    if(GetPVarInt(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), "Duel_Invite_Pending") == 1 || GetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), "Duel_Invite_Pending") == 1 || GetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), "Duel_Invite_Pending") == 1)
				{
				    SendClientMessage(playerid, COLOR_NOTICE, "One or more players already have an invite pending.");
				    return 1;
				}
	   			if(GetPVarInt(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), "PlayerStatus") == 2 || GetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), "PlayerStatus") == 2 || GetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), "PlayerStatus") == 2)
				{
				    SendClientMessage(playerid, COLOR_NOTICE, "One or more players are already dueling.");
				    return 1;
				}
			
			}
			if(GetPVarInt(playerid, "Duel_Type") == 3)
			{
			    if(GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), "Duel_Invite_Pending") == 1 || GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), "Duel_Invite_Pending") == 1 || GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), "Duel_Invite_Pending") == 1 || GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), "Duel_Invite_Pending") == 1 || GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), "Duel_Invite_Pending") == 1)
				{
				    SendClientMessage(playerid, COLOR_NOTICE, "One or more players already have an invite pending.");
				    return 1;
				}
	   			if(GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), "PlayerStatus") == 2 || GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), "PlayerStatus") == 2 || GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), "PlayerStatus") == 2 || GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), "PlayerStatus") == 2 || GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), "PlayerStatus") == 2)
				{
				    SendClientMessage(playerid, COLOR_NOTICE, "One or more players are already dueling.");
				    return 1;
				}
			}
			
    		new CJRun[4];
			if(GetPVarInt(playerid, "Duel_CJ") == 1)
			{
				format(CJRun, sizeof(CJRun), "On");
			}
			else
			{
   				format(CJRun, sizeof(CJRun), "Off");
			}
			new Armour[4];
			if(GetPVarInt(playerid, "Duel_Armour") == 1)
			{
				format(Armour, sizeof(Armour), "On");
			}
			else
			{
   				format(Armour, sizeof(Armour), "Off");
			}
			if(GetPVarInt(playerid, "Duel_Type") == 1)
			{
				new messagestr[175];
				format(messagestr,sizeof(messagestr),"[DUEL] %s invites you for a 1 vs. 1 duel! Type /acceptduel to accept the request.", PlayerName(playerid));
				if(GetPVarInt(playerid, "Duel_Stake") > 0) format(messagestr,sizeof(messagestr),"[DUEL] %s invites you for a 1 vs. 1 duel! {FF0000}(Stake: $%d) {33AA33}Type /acceptduel to accept the request.", PlayerName(playerid), GetPVarInt(playerid, "Duel_Stake"));
				SendClientMessage(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), COLOR_GREEN, messagestr);
				format(messagestr,sizeof(messagestr),"[SETTINGS] Map: [%s] Wep 1: [%s] - Wep 2: [%s] Armour: [%s] CJ: [%s]", DuelMaps_Info[GetPVarInt(playerid, "Duel_Map")][0], WeaponName(GetPVarInt(playerid, "Duel_Wep1")), WeaponName(GetPVarInt(playerid, "Duel_Wep2")), Armour, CJRun);
				SendClientMessage(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), COLOR_NOTICE, messagestr);
	            SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You succesfully sent the duel request.");
				SendClientMessage(playerid, COLOR_NOTICE, messagestr);
				
    			DuelExpireTimer[GetPVarInt(playerid, "Duel_1v1_Opponent_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_1v1_Opponent_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), "Duel_Invite_Pending", 1);
			}
			if(GetPVarInt(playerid, "Duel_Type") == 2)
			{
			    new messagestr[175];
				format(messagestr,sizeof(messagestr),"[DUEL] %s invites you for a 2 vs. 2 duel! Type /acceptduel to accept the request.", PlayerName(playerid));
				if(GetPVarInt(playerid, "Duel_Stake") > 0) format(messagestr,sizeof(messagestr),"[DUEL] %s invites you for a 2 vs. 2 duel! {FF0000}(Stake: $%d) {33AA33}Type /acceptduel to accept the request.", PlayerName(playerid), GetPVarInt(playerid, "Duel_Stake"));
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), COLOR_GREEN, messagestr);
				format(messagestr,sizeof(messagestr),"[SETTINGS] Map: [%s] Wep 1: [%s] - Wep 2: [%s] Armour: [%s] CJ: [%s]", DuelMaps_Info[GetPVarInt(playerid, "Duel_Map")][0], WeaponName(GetPVarInt(playerid, "Duel_Wep1")), WeaponName(GetPVarInt(playerid, "Duel_Wep2")), Armour, CJRun);
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), COLOR_NOTICE, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), COLOR_NOTICE, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), COLOR_NOTICE, messagestr);
	            SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You succesfully sent the duel request.");
				SendClientMessage(playerid, COLOR_NOTICE, messagestr);
				
				format(messagestr,sizeof(messagestr),"[TEAMS] Team A: [%s and %s] - Team B: [%s and %s]", PlayerName(playerid), PlayerName(GetPVarInt(playerid, "Duel_2v2_Teammate_ID")), PlayerName(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID")), PlayerName(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID")));
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), COLOR_NOTICE, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), COLOR_NOTICE, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), COLOR_NOTICE, messagestr);
				SendClientMessage(playerid, COLOR_NOTICE, messagestr);
				
				DuelExpireTimer[GetPVarInt(playerid, "Duel_2v2_Teammate_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_2v2_Teammate_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), "Duel_Invite_Pending", 1);
				DuelExpireTimer[GetPVarInt(playerid, "Duel_2v2_Enemy1_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), "Duel_Invite_Pending", 1);
				DuelExpireTimer[GetPVarInt(playerid, "Duel_2v2_Enemy2_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), "Duel_Invite_Pending", 1);
			
			}
			if(GetPVarInt(playerid, "Duel_Type") == 3)
			{
			    new messagestr[175];
				format(messagestr,sizeof(messagestr),"[DUEL] %s invites you for a 3 vs. 3 duel! Type /acceptduel to accept the request.", PlayerName(playerid));
				if(GetPVarInt(playerid, "Duel_Stake") > 0) format(messagestr,sizeof(messagestr),"[DUEL] %s invites you for a 3 vs. 3 duel! {FF0000}(Stake: $%d) {33AA33}Type /acceptduel to accept the request.", PlayerName(playerid), GetPVarInt(playerid, "Duel_Stake"));
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), COLOR_GREEN, messagestr);
				format(messagestr,sizeof(messagestr),"[SETTINGS] Map: [%s] Wep 1: [%s] - Wep 2: [%s] Armour: [%s] CJ: [%s]", DuelMaps_Info[GetPVarInt(playerid, "Duel_Map")][0], WeaponName(GetPVarInt(playerid, "Duel_Wep1")), WeaponName(GetPVarInt(playerid, "Duel_Wep2")), Armour, CJRun);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), COLOR_GREEN, messagestr);
	            SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You succesfully sent the duel request.");
				SendClientMessage(playerid, COLOR_NOTICE, messagestr);

				format(messagestr,sizeof(messagestr),"[TEAMS] Team A: [%s, %s and %s] - Team B: [%s, %s and %s]", PlayerName(playerid), PlayerName(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID")));
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(playerid, COLOR_NOTICE, messagestr);

				DuelExpireTimer[GetPVarInt(playerid, "Duel_3v3_Teammate1_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), "Duel_Invite_Pending", 1);
				DuelExpireTimer[GetPVarInt(playerid, "Duel_3v3_Teammate2_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), "Duel_Invite_Pending", 1);
				DuelExpireTimer[GetPVarInt(playerid, "Duel_3v3_Enemy1_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), "Duel_Invite_Pending", 1);
				DuelExpireTimer[GetPVarInt(playerid, "Duel_3v3_Enemy2_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), "Duel_Invite_Pending", 1);
				DuelExpireTimer[GetPVarInt(playerid, "Duel_3v3_Enemy3_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), "Duel_Invite_Pending", 1);
			}
			DuelExpireTimer[playerid] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", playerid);
			SetPVarInt(playerid, "Duel_Invite_Pending", 1);
			SetPVarInt(playerid, "Duel_Requester", 1);
		}
	}
	if(dialogid == 559)
	{
		if(response)
  		{
    		if(strlen(inputtext)  == 0)
			{
 				ShowPlayerDialog(playerid,559,DIALOG_STYLE_INPUT,"Duel Configuration (2 vs 2)","Don't leave it blank.\n\nPlease insert the exact name of the player you wish to have in your team:","Next","Cancel");
     			return 1;
			}
   			SetPVarInt(playerid, "Duel_Type", 2);
		    foreach(Player,i)
		    {
				if(i != playerid)
				{
					if(!strcmp(inputtext, PlayerName(i), true))
					{
						if(GetPVarInt(i, "Duel_Invite_Pending") == 1)
						{
							ShowPlayerDialog(playerid,559,DIALOG_STYLE_INPUT,"Duel Configuration (2 vs 2)","This player already has an invite pending.\n\nPlease insert the exact name of the player you wish to have in your team:","Next","Cancel");
							return 1;
						}
						if(GetPVarInt(i, "PlayerStatus") == 2)
						{
							ShowPlayerDialog(playerid,559,DIALOG_STYLE_INPUT,"Duel Configuration (2 vs 2)","This player is already dueling.\n\nPlease insert the exact name of the player you wish to have in your team:","Next","Cancel");
							return 1;
						}
						SetPVarInt(playerid, "Duel_2v2_Teammate_ID", i);
						
						ShowPlayerDialog(playerid,560,DIALOG_STYLE_INPUT,"Duel Configuration (2 vs 2)","Please insert the exact name of FIRST player you wish to duel against:","Next","Cancel");
					}
					//else return ShowPlayerDialog(playerid,559,DIALOG_STYLE_INPUT,"Duel Configuration (2 vs 2)","Player was not found.\n\nPlease insert the exact name of the player you wish to have in your team:","Next","Cancel");
				}
			}
		}
	}
	if(dialogid == 560)
	{
		if(response)
  		{
    		if(strlen(inputtext)  == 0)
			{
 				ShowPlayerDialog(playerid,560,DIALOG_STYLE_INPUT,"Duel Configuration (2 vs 2)","Don't leave it blank!\n\nPlease insert the exact name of FIRST player you wish to duel against:","Next","Cancel");
     			return 1;
			}
		    foreach(Player,i)
		    {
				if(i != playerid)
				{
					if(!strcmp(inputtext, PlayerName(i), true))
					{
						if(GetPVarInt(i, "Duel_Invite_Pending") == 1)
						{
							ShowPlayerDialog(playerid,560,DIALOG_STYLE_INPUT,"Duel Configuration (2 vs 2)","This player already has an invite pending.\n\nPlease insert the exact name of FIRST player you wish to duel against:","Next","Cancel");
							return 1;
						}
						if(GetPVarInt(i, "PlayerStatus") == 2)
						{
							ShowPlayerDialog(playerid,560,DIALOG_STYLE_INPUT,"Duel Configuration (2 vs 2)","This player is already dueling.\n\nPlease insert the exact name of FIRST player you wish to duel against:","Next","Cancel");
							return 1;
						}
						SetPVarInt(playerid, "Duel_2v2_Enemy1_ID", i);

						ShowPlayerDialog(playerid,561,DIALOG_STYLE_INPUT,"Duel Configuration (2 vs 2)","Please insert the exact name of SECOND player you wish to duel against:","Next","Cancel");
					}
					//else return ShowPlayerDialog(playerid,560,DIALOG_STYLE_INPUT,"Duel Configuration (2 vs 2)","Player was not found.\n\nPlease insert the exact name of FIRST player you wish to duel against:","Next","Cancel");
				}
			}
		}
	}
	if(dialogid == 561)
	{
		if(response)
  		{
    		if(strlen(inputtext)  == 0)
			{
 				ShowPlayerDialog(playerid,561,DIALOG_STYLE_INPUT,"Duel Configuration (2 vs 2)","Don't leave it blank!\n\nPlease insert the exact name of SECOND player you wish to duel against:","Next","Cancel");
     			return 1;
			}
		    foreach(Player,i)
		    {
				if(i != playerid)
				{
					if(!strcmp(inputtext, PlayerName(i), true))
					{
						if(GetPVarInt(i, "Duel_Invite_Pending") == 1)
						{
							ShowPlayerDialog(playerid,561,DIALOG_STYLE_INPUT,"Duel Configuration (2 vs 2)","This player already has an invite pending.\n\nPlease insert the exact name of SECOND player you wish to duel against:","Next","Cancel");
							return 1;
						}
						if(GetPVarInt(i, "PlayerStatus") == 2)
						{
							ShowPlayerDialog(playerid,561,DIALOG_STYLE_INPUT,"Duel Configuration (2 vs 2)","This player is already dueling.\n\nPlease insert the exact name of SECOND player you wish to duel against:","Next","Cancel");
							return 1;
						}
						SetPVarInt(playerid, "Duel_2v2_Enemy2_ID", i);

						if(GetPVarInt(playerid, "Duel_2v2_Teammate_ID") == GetPVarInt(playerid, "Duel_2v2_Enemy1_ID") || GetPVarInt(playerid, "Duel_2v2_Teammate_ID") == GetPVarInt(playerid, "Duel_2v2_Enemy2_ID")) return SendClientMessage(playerid, COLOR_NOTICE, "You cannot use a player in a duel more than once.");
						else if(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID") == GetPVarInt(playerid, "Duel_2v2_Enemy2_ID")) return SendClientMessage(playerid, COLOR_NOTICE, "You cannot use a player in a duel more than once.");
						else
						{
							new msgstr[150];
							format(msgstr,sizeof(msgstr),"Are those teams correct?\n\nTEAM A:\n{FFFFFF}1. %s\n2. %s\n\n{a9c4e4}TEAM B:\n{FFFFFF}1. %s\n2. %s", PlayerName(playerid), PlayerName(GetPVarInt(playerid, "Duel_2v2_Teammate_ID")), PlayerName(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID")), PlayerName(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID")));
							ShowPlayerDialog(playerid,562,DIALOG_STYLE_MSGBOX,"Duel Configuration", msgstr,"Next", "Cancel");
						}
					}
				}
			}
		}
	}
	if(dialogid == 562)
	{
		if(response)
  		{
  		    ShowPlayerDialog(playerid,552,DIALOG_STYLE_INPUT,"Duel Configuration", "Do you wish to have armour in the duel? Type Yes/No","Next","Cancel");
  		}
  	}
  	
  	if(dialogid == 563)
	{
		if(response)
  		{
    		if(strlen(inputtext)  == 0)
			{
 				ShowPlayerDialog(playerid,563,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","Don't leave it blank.\n\nPlease insert the exact name of the FIRST player you wish to have in your team:","Next","Cancel");
     			return 1;
			}
   			SetPVarInt(playerid, "Duel_Type", 3);
		    foreach(Player,i)
		    {
				if(i != playerid)
				{
					if(!strcmp(inputtext, PlayerName(i), true))
					{
						if(GetPVarInt(i, "Duel_Invite_Pending") == 1)
						{
							ShowPlayerDialog(playerid,563,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","This player already has an invite pending.\n\nPlease insert the exact name of the FIRST player you wish to have in your team:","Next","Cancel");
						}
						if(GetPVarInt(i, "PlayerStatus") == 2)
						{
							ShowPlayerDialog(playerid,563,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","This player is already dueling.\n\nPlease insert the exact name of the FIRST player you wish to have in your team:","Next","Cancel");
							return 1;
						}
						SetPVarInt(playerid, "Duel_3v3_Teammate1_ID", i);

						ShowPlayerDialog(playerid,564,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","Please insert the exact name of the SECOND player you wish to have in your team:","Next","Cancel");
					}
				}
			}
		}
	}
	if(dialogid == 564)
	{
		if(response)
  		{
    		if(strlen(inputtext)  == 0)
			{
 				ShowPlayerDialog(playerid,564,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","Don't leave it blank.\n\nPlease insert the exact name of the SECOND player you wish to have in your team:","Next","Cancel");
     			return 1;
			}
		    foreach(Player,i)
		    {
				if(i != playerid)
				{
					if(!strcmp(inputtext, PlayerName(i), true))
					{
						if(GetPVarInt(i, "Duel_Invite_Pending") == 1)
						{
							ShowPlayerDialog(playerid,564,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","This player already has an invite pending.\n\nPlease insert the exact name of the SECOND player you wish to have in your team:","Next","Cancel");
						}
						if(GetPVarInt(i, "PlayerStatus") == 2)
						{
							ShowPlayerDialog(playerid,564,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","This player is already dueling.\n\nPlease insert the exact name of the SECOND player you wish to have in your team:","Next","Cancel");
							return 1;
						}
						SetPVarInt(playerid, "Duel_3v3_Teammate2_ID", i);

						ShowPlayerDialog(playerid,565,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","Please insert the exact name of the FIRST player you wish to fight against:","Next","Cancel");
					}
				}
			}
		}
	}
	if(dialogid == 565)
	{
		if(response)
  		{
    		if(strlen(inputtext)  == 0)
			{
 				ShowPlayerDialog(playerid,565,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","Don't leave it blank.\n\nPlease insert the exact name of the FIRST player you wish to fight against:","Next","Cancel");
     			return 1;
			}
		    foreach(Player,i)
		    {
				if(i != playerid)
				{
					if(!strcmp(inputtext, PlayerName(i), true))
					{
						if(GetPVarInt(i, "Duel_Invite_Pending") == 1)
						{
							ShowPlayerDialog(playerid,565,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","This player already has an invite pending.\n\nPlease insert the exact name of the FIRST player you wish to fight against:","Next","Cancel");
						}
						if(GetPVarInt(i, "PlayerStatus") == 2)
						{
							ShowPlayerDialog(playerid,565,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","This player is already dueling.\n\nPlease insert the exact name of the FIRST player you wish to fight against:","Next","Cancel");
							return 1;
						}
						SetPVarInt(playerid, "Duel_3v3_Enemy1_ID", i);

						ShowPlayerDialog(playerid,566,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","Please insert the exact name of the SECOND player you wish to fight against:","Next","Cancel");
					}
				}
			}
		}
	}
	if(dialogid == 566)
	{
		if(response)
  		{
    		if(strlen(inputtext)  == 0)
			{
 				ShowPlayerDialog(playerid,566,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","Don't leave it blank.\n\nPlease insert the exact name of the SECOND player you wish to fight against:","Next","Cancel");
     			return 1;
			}
		    foreach(Player,i)
		    {
				if(i != playerid)
				{
					if(!strcmp(inputtext, PlayerName(i), true))
					{
						if(GetPVarInt(i, "Duel_Invite_Pending") == 1)
						{
							ShowPlayerDialog(playerid,566,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","This player already has an invite pending.\n\nPlease insert the exact name of the SECOND player you wish to fight against:","Next","Cancel");
						}
						if(GetPVarInt(i, "PlayerStatus") == 2)
						{
							ShowPlayerDialog(playerid,566,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","This player is already dueling.\n\nPlease insert the exact name of the SECOND player you wish to fight against:","Next","Cancel");
							return 1;
						}
						SetPVarInt(playerid, "Duel_3v3_Enemy2_ID", i);

						ShowPlayerDialog(playerid,567,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","Please insert the exact name of the THIRD player you wish to fight against:","Next","Cancel");
					}
				}
			}
		}
	}
	if(dialogid == 567)
	{
		if(response)
  		{
    		if(strlen(inputtext)  == 0)
			{
 				ShowPlayerDialog(playerid,567,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","Don't leave it blank.\n\nPlease insert the exact name of the THIRD player you wish to fight against:","Next","Cancel");
     			return 1;
			}
		    foreach(Player,i)
		    {
				if(i != playerid)
				{
					if(!strcmp(inputtext, PlayerName(i), true))
					{
						if(GetPVarInt(i, "Duel_Invite_Pending") == 1)
						{
							ShowPlayerDialog(playerid,567,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","This player already has an invite pending.\n\nPlease insert the exact name of the THIRD player you wish to fight against:","Next","Cancel");
						}
						if(GetPVarInt(i, "PlayerStatus") == 2)
						{
							ShowPlayerDialog(playerid,567,DIALOG_STYLE_INPUT,"Duel Configuration (3 vs 3)","This player is already dueling.\n\nPlease insert the exact name of the THIRD player you wish to fight against:","Next","Cancel");
							return 1;
						}
						SetPVarInt(playerid, "Duel_3v3_Enemy3_ID", i);

                        if(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID") == GetPVarInt(playerid, "Duel_3v3_Enemy1_ID") || GetPVarInt(playerid, "Duel_3v3_Teammate1_ID") == GetPVarInt(playerid, "Duel_3v3_Enemy2_ID") || GetPVarInt(playerid, "Duel_3v3_Teammate1_ID") == GetPVarInt(playerid, "Duel_3v3_Enemy3_ID")) return SendClientMessage(playerid, COLOR_NOTICE, "You cannot use a player in a duel more than once.");
                        else if(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID") == GetPVarInt(playerid, "Duel_3v3_Enemy1_ID") || GetPVarInt(playerid, "Duel_3v3_Teammate2_ID") == GetPVarInt(playerid, "Duel_3v3_Enemy2_ID") || GetPVarInt(playerid, "Duel_3v3_Teammate2_ID") == GetPVarInt(playerid, "Duel_3v3_Enemy3_ID")) return SendClientMessage(playerid, COLOR_NOTICE, "You cannot use a player in a duel more than once.");
						else if(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID") == GetPVarInt(playerid, "Duel_3v3_Enemy2_ID") || GetPVarInt(playerid, "Duel_3v3_Enemy1_ID") == GetPVarInt(playerid, "Duel_3v3_Enemy3_ID")) return SendClientMessage(playerid, COLOR_NOTICE, "You cannot use a player in a duel more than once.");
						else if(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID") == GetPVarInt(playerid, "Duel_3v3_Enemy3_ID")) return SendClientMessage(playerid, COLOR_NOTICE, "You cannot use a player in a duel more than once.");
						else
						{
							new msgstr[150];
							format(msgstr,sizeof(msgstr),"Are those teams correct?\n\nTEAM A:\n{FFFFFF}1. %s\n2. %s\n3. %s\n\n{a9c4e4}TEAM B:\n{FFFFFF}1. %s\n2. %s\n3. %s", PlayerName(playerid), PlayerName(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID")));
							ShowPlayerDialog(playerid,568,DIALOG_STYLE_MSGBOX,"Duel Configuration", msgstr,"Next", "Cancel");
						}
					}
				}
			}
		}
	}
	if(dialogid == 568)
	{
		if(response)
  		{
  		    ShowPlayerDialog(playerid,552,DIALOG_STYLE_INPUT,"Duel Configuration", "Do you wish to have armour in the duel? Type Yes/No","Next","Cancel");
  		}
  	}
	
	return 1;
}

forward DuelInvite_Expire(playerid);
public DuelInvite_Expire(playerid)
{
	if(GetPVarInt(playerid, "Duel_Invite_Pending") == 1)
	{
    	SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Your duel request has expired.");
    	SetPVarInt(playerid, "Duel_Invite_Pending", 0);
    	SetPVarInt(playerid, "Accepted_Duel_Request", 0);
    	SetPVarInt(playerid, "Amount_Accepted", 0);
    	SetPVarInt(playerid, "Duel_Requester", 0);
    }
    return 1;

}

CMD:denyrequest(playerid, params[])
{
	if(GetPVarInt(playerid, "Duel_Requester") == 1) return SendClientMessage(playerid, COLOR_NOTICE, "[ERROR]: You can't deny a request you made yourself.");
    if(GetPVarInt(playerid, "Duel_Invite_Pending") == 1)
	{
	    KillTimer(DuelExpireTimer[playerid]);
    	SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: You denied the duel request.");
    	SetPVarInt(playerid, "Duel_Invite_Pending", 0);
    	SetPVarInt(playerid, "Accepted_Duel_Request", 0);
    	SetPVarInt(playerid, "Amount_Accepted", 0);
    }
    else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You don't have a duel invite pending.");
	}
	return 1;
}

CMD:leaveduel(playerid, params[])
{
	if(Team_A_Amount[GetPVarInt(playerid, "Duel_ID")] == 0 && Team_B_Amount[GetPVarInt(playerid, "Duel_ID")] == 0)
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your duel hasn't started yet.");
		return 1;
	}
	new Float:health;
	GetPlayerHealth(playerid, health);
	if(GetPVarInt(playerid, "PlayerStatus") == 2)
	{
	    if(health < 40.0)
		{
	 		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your HP is too low to leave the duel.");
	 		return 1;
	 	}
	
	    new duelid = GetPVarInt(playerid, "Duel_ID");
	    
	    new messagestr[200];
	    format(messagestr,sizeof(messagestr), "[DUEL] %s left the duel, causing the duel to end.", PlayerName(playerid));
	    SendClientMessageToAll(COLOR_GREEN, messagestr);

	    
	    new stake = Duel_Stake[duelid];
	    foreach(Player,i)
		{
		    if(GetPVarInt(i, "Duel_ID") == duelid)
		    {
		        GivePlayerMoney(i, stake);
		    }
		}
		ResetDuel(duelid);
		return 1;
	}

	return 1;
}


CMD:ad(playerid, params[])
{
	cmd_acceptduel(playerid, params);
 	return 1;
}



CMD:acceptduel(playerid, params[])
{
    if(GetPVarInt(playerid, "PlayerStatus") != 0)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't do that now.");
	}
	if(GetPVarInt(playerid, "InEvent") == 1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't do that now.");
	}
	if(FoCo_Player[playerid][jailed] > 0)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't do that when jailed.");
	}
	
	new Float:health;
	GetPlayerHealth(playerid, health);
	if(health < 1.0) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are dead.");
	
	if(GetPVarInt(playerid, "PlayerStatus") == 2)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't do that whilst in a duel.");
	}
	
	if(!IsPlayerInAnyVehicle(playerid))
	{
		if(!IsPlayerInAnyVehicle(GetPVarInt(playerid,"Duel_Inviter")))
		{
			if(health > 69.0)
			{
				if(GetPVarInt(playerid, "Duel_Invite_Pending") == 0) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You don't have a duel request pending.");
				if(GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Type") == 1) // 1 vs 1
				{
					if(GetPlayerMoney(playerid) < GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Stake"))
					{
					    if(GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Stake") != 0) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You don't have enough money to accept the request.");
					}

					ResetPlayerWeapons(playerid);
					ResetPlayerWeapons(GetPVarInt(playerid,"Duel_Inviter"));
					SetPVarInt(playerid, "Duel_Type", GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Type"));
					SetPVarInt(playerid, "Duel_1v1_Opponent_ID", GetPVarInt(playerid,"Duel_Inviter"));
					SetPVarInt(playerid, "Duel_Invite_Pending", 0);
					SetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Invite_Pending", 0);
					SetPVarInt(playerid, "PlayerStatus", 2);
					SetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "PlayerStatus", 2);
					SetPVarInt(playerid, "Duel_Stake", GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Stake"));
					GivePlayerMoney(playerid, -GetPVarInt(playerid, "Duel_Stake"));
					GivePlayerMoney(GetPVarInt(playerid,"Duel_Inviter"), -GetPVarInt(playerid, "Duel_Stake"));

					new messagestr[175];
					format(messagestr,sizeof(messagestr),"%s has accepted the duel request. It will start in ten seconds!", PlayerName(playerid));
					SendClientMessage(GetPVarInt(playerid,"Duel_Inviter"), COLOR_NOTICE, messagestr);
					SendClientMessage(playerid, COLOR_NOTICE, "You accepted the duel request. It will start in ten seconds!");

					SetPlayerPos(GetPVarInt(playerid,"Duel_Inviter"), DuelMaps_Spawns_A[GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Map")][0], DuelMaps_Spawns_A[GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Map")][1], DuelMaps_Spawns_A[GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Map")][2]);
					SetPlayerPos(playerid, DuelMaps_Spawns_B[GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Map")][0], DuelMaps_Spawns_B[GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Map")][1], DuelMaps_Spawns_B[GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Map")][2]);

					SetPlayerFacingAngle(GetPVarInt(playerid,"Duel_Inviter"), DuelMaps_Spawns_A[GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Map")][3]);
					SetPlayerFacingAngle(playerid, DuelMaps_Spawns_B[GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Map")][3]);
					SetPlayerInterior(playerid, DuelMaps_Info2[GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Map")][0]);
					SetPlayerInterior(GetPVarInt(playerid,"Duel_Inviter"), DuelMaps_Info2[GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Map")][0]);
					TogglePlayerControllable(playerid, 0);
					TogglePlayerControllable(GetPVarInt(playerid,"Duel_Inviter"), 0);
					SetTimerEx("Duel_Start", 10000, false, "d", GetPVarInt(playerid,"Duel_Inviter"));

					SetPVarInt(playerid, "SkinBeforeDuel", GetPlayerSkin(playerid));
					SetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "SkinBeforeDuel", GetPlayerSkin(GetPVarInt(playerid,"Duel_Inviter")));
					SetPlayerVirtualWorld(playerid, playerid*GetPVarInt(playerid,"Duel_Inviter")+1*1000);
					SetPlayerVirtualWorld(GetPVarInt(playerid,"Duel_Inviter"), playerid*GetPVarInt(playerid,"Duel_Inviter")+1*1000);
				}
				if(GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Type") == 2) // 2 vs 2
				{
					if(GetPVarInt(playerid, "Accepted_Duel_Request") == 0)
					{
						SetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Amount_Accepted", GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Amount_Accepted")+1);
						SetPVarInt(playerid, "Accepted_Duel_Request", 1);
						SendClientMessage(playerid, COLOR_NOTICE, "You accepted the duel request. Please wait for the other people to accept as well.");
					}
					if(GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Amount_Accepted") >= 3)
					{
						new inviter = GetPVarInt(playerid,"Duel_Inviter");
						ResetPlayerWeapons(inviter);
						ResetPlayerWeapons(GetPVarInt(inviter, "Duel_2v2_Teammate_ID"));
						ResetPlayerWeapons(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID"));
						ResetPlayerWeapons(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID"));
						
						SetPVarInt(playerid, "PlayerStatus", 2);
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Teammate_ID"), "PlayerStatus", 2);

					
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID"), "PlayerStatus", 2);
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID"), "PlayerStatus", 2);

						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Teammate_ID"), "Duel_Type", GetPVarInt(inviter, "Duel_Type"));
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID"), "Duel_Type", GetPVarInt(inviter, "Duel_Type"));
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID"), "Duel_Type", GetPVarInt(inviter, "Duel_Type"));

						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Teammate_ID"), "Duel_Invite_Pending", 0);
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID"), "Duel_Invite_Pending", 0);
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID"), "Duel_Invite_Pending", 0);
						SetPVarInt(inviter, "Duel_Invite_Pending", 0);

						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Teammate_ID"), "PlayerStatus", 2);
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID"), "PlayerStatus", 2);
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID"), "PlayerStatus", 2);
						SetPVarInt(inviter, "PlayerStatus", 2);
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Teammate_ID"), "Duel_Stake", GetPVarInt(inviter, "Duel_Stake"));
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID"), "Duel_Stake", GetPVarInt(inviter, "Duel_Stake"));
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID"), "Duel_Stake", GetPVarInt(inviter, "Duel_Stake"));
						GivePlayerMoney(GetPVarInt(inviter, "Duel_2v2_Teammate_ID"), -GetPVarInt(GetPVarInt(inviter, "Duel_2v2_Teammate_ID"), "Duel_Stake"));
						GivePlayerMoney(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID"), -GetPVarInt(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID"), "Duel_Stake"));
						GivePlayerMoney(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID"), -GetPVarInt(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID"), "Duel_Stake"));
						GivePlayerMoney(inviter, -GetPVarInt(inviter, "Duel_Stake"));
						SendClientMessage(inviter, COLOR_NOTICE, "Everyone participating accepted the duel request. It will begin in ten seconds!");
						SendClientMessage(GetPVarInt(inviter, "Duel_2v2_Teammate_ID"), COLOR_NOTICE, "Everyone participating accepted the duel request. It will begin in ten seconds!");
						SendClientMessage(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID"), COLOR_NOTICE, "Everyone participating accepted the duel request. It will begin in ten seconds!");
						SendClientMessage(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID"), COLOR_NOTICE, "Everyone participating accepted the duel request. It will begin in ten seconds!");

						SetPlayerPos(inviter, DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][0], DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][1], DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][2]);
						SetPlayerPos(GetPVarInt(inviter, "Duel_2v2_Teammate_ID"), DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][0]+1.0, DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][1]+1.0, DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][2]);
						SetPlayerPos(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID"), DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][0], DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][1], DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][2]);
						SetPlayerPos(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID"), DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][0]+1.0, DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][1]+1.0, DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][2]);
						SetPlayerFacingAngle(inviter, DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][3]);
						SetPlayerFacingAngle(GetPVarInt(inviter, "Duel_2v2_Teammate_ID"), DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][3]);
						SetPlayerFacingAngle(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID"), DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][3]);
						SetPlayerFacingAngle(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID"), DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][3]);

						SetPlayerInterior(inviter, DuelMaps_Info2[GetPVarInt(inviter, "Duel_Map")][0]);
						SetPlayerInterior(GetPVarInt(inviter, "Duel_2v2_Teammate_ID"), DuelMaps_Info2[GetPVarInt(inviter, "Duel_Map")][0]);
						SetPlayerInterior(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID"), DuelMaps_Info2[GetPVarInt(inviter, "Duel_Map")][0]);
						SetPlayerInterior(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID"), DuelMaps_Info2[GetPVarInt(inviter, "Duel_Map")][0]);
						TogglePlayerControllable(inviter, 0);
						TogglePlayerControllable(GetPVarInt(inviter, "Duel_2v2_Teammate_ID"), 0);
						TogglePlayerControllable(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID"), 0);
						TogglePlayerControllable(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID"), 0);

						SetTimerEx("Duel_Start", 10000, false, "d", inviter);

						SetPVarInt(inviter, "SkinBeforeDuel", GetPlayerSkin(inviter));
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Teammate_ID"), "SkinBeforeDuel", GetPlayerSkin(GetPVarInt(inviter, "Duel_2v2_Teammate_ID")));
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID"), "SkinBeforeDuel", GetPlayerSkin(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID")));
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID"), "SkinBeforeDuel", GetPlayerSkin(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID")));

						SetPlayerVirtualWorld(inviter, inviter+1*GetPVarInt(inviter, "Duel_2v2_Teammate_ID")+1*1000);
						SetPlayerVirtualWorld(GetPVarInt(inviter, "Duel_2v2_Teammate_ID"), inviter+1*GetPVarInt(inviter, "Duel_2v2_Teammate_ID")+1*1000);
						SetPlayerVirtualWorld(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID"), inviter+1*GetPVarInt(inviter, "Duel_2v2_Teammate_ID")+1*1000);
						SetPlayerVirtualWorld(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID"), inviter+1*GetPVarInt(inviter, "Duel_2v2_Teammate_ID")+1*1000);

					}
				}

				if(GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Duel_Type") == 3) // 3 vs 3
				{
					if(GetPVarInt(playerid, "Accepted_Duel_Request") == 0)
					{
						SetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Amount_Accepted", GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Amount_Accepted")+1);
						SetPVarInt(playerid, "Accepted_Duel_Request", 1);
						SendClientMessage(playerid, COLOR_NOTICE, "You accepted the duel request. Please wait for the other people to accept as well.");
					}
					if(GetPVarInt(GetPVarInt(playerid,"Duel_Inviter"), "Amount_Accepted") >= 5)
					{
						new inviter = GetPVarInt(playerid,"Duel_Inviter");
						ResetPlayerWeapons(inviter);
						ResetPlayerWeapons(GetPVarInt(inviter, "Duel_3v3_Teammate1_ID"));
						ResetPlayerWeapons(GetPVarInt(inviter, "Duel_3v3_Teammate2_ID"));
						ResetPlayerWeapons(GetPVarInt(inviter, "Duel_3v3_Enemy1_ID"));
						ResetPlayerWeapons(GetPVarInt(inviter, "Duel_3v3_Enemy2_ID"));
						ResetPlayerWeapons(GetPVarInt(inviter, "Duel_3v3_Enemy3_ID"));
						
						SetPVarInt(playerid, "PlayerStatus", 2);
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Teammate_ID"), "PlayerStatus", 2);
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Teammate2_ID"), "PlayerStatus", 2);

					
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Enemy1_ID"), "PlayerStatus", 2);
						SetPVarInt(GetPVarInt(inviter, "Duel_2v2_Enemy2_ID"), "PlayerStatus", 2);
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy3_ID"), "PlayerStatus", 2);

						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Teammate1_ID"), "Duel_Type", GetPVarInt(inviter, "Duel_Type"));
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Teammate2_ID"), "Duel_Type", GetPVarInt(inviter, "Duel_Type"));
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy1_ID"), "Duel_Type", GetPVarInt(inviter, "Duel_Type"));
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy2_ID"), "Duel_Type", GetPVarInt(inviter, "Duel_Type"));
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy3_ID"), "Duel_Type", GetPVarInt(inviter, "Duel_Type"));

						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Teammate1_ID"), "Duel_Invite_Pending", 0);
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Teammate2_ID"), "Duel_Invite_Pending", 0);
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy1_ID"), "Duel_Invite_Pending", 0);
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy2_ID"), "Duel_Invite_Pending", 0);
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy3_ID"), "Duel_Invite_Pending", 0);
						SetPVarInt(inviter, "Duel_Invite_Pending", 0);

						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Teammate1_ID"), "PlayerStatus", 2);
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Teammate2_ID"), "PlayerStatus",2);
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy1_ID"), "PlayerStatus", 2);
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy2_ID"), "PlayerStatus", 2);
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy3_ID"), "PlayerStatus", 2);
						SetPVarInt(inviter, "PlayerStatus", 2);
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Teammate1_ID"), "Duel_Stake", GetPVarInt(inviter, "Duel_Stake"));
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Teammate2_ID"), "Duel_Stake", GetPVarInt(inviter, "Duel_Stake"));
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy1_ID"), "Duel_Stake", GetPVarInt(inviter, "Duel_Stake"));
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy2_ID"), "Duel_Stake", GetPVarInt(inviter, "Duel_Stake"));
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy3_ID"), "Duel_Stake", GetPVarInt(inviter, "Duel_Stake"));

						GivePlayerMoney(GetPVarInt(inviter, "Duel_3v3_Teammate1_ID"), -GetPVarInt(GetPVarInt(inviter, "Duel_3v3_Teammate1_ID"), "Duel_Stake"));
						GivePlayerMoney(GetPVarInt(inviter, "Duel_3v3_Teammate2_ID"), -GetPVarInt(GetPVarInt(inviter, "Duel_3v3_Teammate2_ID"), "Duel_Stake"));
						GivePlayerMoney(GetPVarInt(inviter, "Duel_3v3_Enemy1_ID"), -GetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy1_ID"), "Duel_Stake"));
						GivePlayerMoney(GetPVarInt(inviter, "Duel_3v3_Enemy2_ID"), -GetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy2_ID"), "Duel_Stake"));
						GivePlayerMoney(GetPVarInt(inviter, "Duel_3v3_Enemy3_ID"), -GetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy3_ID"), "Duel_Stake"));
						GivePlayerMoney(inviter, -GetPVarInt(inviter, "Duel_Stake"));

						SendClientMessage(inviter, COLOR_NOTICE, "Everyone participating accepted the duel request. It will begin in ten seconds!");
						SendClientMessage(GetPVarInt(inviter, "Duel_3v3_Teammate1_ID"), COLOR_NOTICE, "Everyone participating accepted the duel request. It will begin in ten seconds!");
						SendClientMessage(GetPVarInt(inviter, "Duel_3v3_Teammate2_ID"), COLOR_NOTICE, "Everyone participating accepted the duel request. It will begin in ten seconds!");
						SendClientMessage(GetPVarInt(inviter, "Duel_3v3_Enemy1_ID"), COLOR_NOTICE, "Everyone participating accepted the duel request. It will begin in ten seconds!");
						SendClientMessage(GetPVarInt(inviter, "Duel_3v3_Enemy2_ID"), COLOR_NOTICE, "Everyone participating accepted the duel request. It will begin in ten seconds!");
						SendClientMessage(GetPVarInt(inviter, "Duel_3v3_Enemy3_ID"), COLOR_NOTICE, "Everyone participating accepted the duel request. It will begin in ten seconds!");

						SetPlayerPos(inviter, DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][0], DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][1], DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][2]);
						SetPlayerPos(GetPVarInt(inviter, "Duel_3v3_Teammate1_ID"), DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][0]+1.0, DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][1]+1.0, DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][2]);
						SetPlayerPos(GetPVarInt(inviter, "Duel_3v3_Teammate2_ID"), DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][0]-1.0, DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][1]-1.0, DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][2]);
						SetPlayerPos(GetPVarInt(inviter, "Duel_3v3_Enemy1_ID"), DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][0], DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][1], DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][2]);
						SetPlayerPos(GetPVarInt(inviter, "Duel_3v3_Enemy2_ID"), DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][0]+1.0, DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][1]+1.0, DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][2]);
						SetPlayerPos(GetPVarInt(inviter, "Duel_3v3_Enemy3_ID"), DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][0]-1.0, DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][1]-1.0, DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][2]);
						SetPlayerFacingAngle(inviter, DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][3]);
						SetPlayerFacingAngle(GetPVarInt(inviter, "Duel_3v3_Teammate1_ID"), DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][3]);
						SetPlayerFacingAngle(GetPVarInt(inviter, "Duel_3v3_Teammate2_ID"), DuelMaps_Spawns_A[GetPVarInt(inviter, "Duel_Map")][3]);
						SetPlayerFacingAngle(GetPVarInt(inviter, "Duel_3v3_Enemy1_ID"), DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][3]);
						SetPlayerFacingAngle(GetPVarInt(inviter, "Duel_3v3_Enemy2_ID"), DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][3]);
						SetPlayerFacingAngle(GetPVarInt(inviter, "Duel_3v3_Enemy3_ID"), DuelMaps_Spawns_B[GetPVarInt(inviter, "Duel_Map")][3]);

						SetPlayerInterior(inviter, DuelMaps_Info2[GetPVarInt(inviter, "Duel_Map")][0]);
						SetPlayerInterior(GetPVarInt(inviter, "Duel_3v3_Teammate1_ID"), DuelMaps_Info2[GetPVarInt(inviter, "Duel_Map")][0]);
						SetPlayerInterior(GetPVarInt(inviter, "Duel_3v3_Teammate2_ID"), DuelMaps_Info2[GetPVarInt(inviter, "Duel_Map")][0]);
						SetPlayerInterior(GetPVarInt(inviter, "Duel_3v3_Enemy1_ID"), DuelMaps_Info2[GetPVarInt(inviter, "Duel_Map")][0]);
						SetPlayerInterior(GetPVarInt(inviter, "Duel_3v3_Enemy2_ID"), DuelMaps_Info2[GetPVarInt(inviter, "Duel_Map")][0]);
						SetPlayerInterior(GetPVarInt(inviter, "Duel_3v3_Enemy3_ID"), DuelMaps_Info2[GetPVarInt(inviter, "Duel_Map")][0]);
						TogglePlayerControllable(inviter, 0);
						TogglePlayerControllable(GetPVarInt(inviter, "Duel_3v3_Teammate1_ID"), 0);
						TogglePlayerControllable(GetPVarInt(inviter, "Duel_3v3_Teammate2_ID"), 0);
						TogglePlayerControllable(GetPVarInt(inviter, "Duel_3v3_Enemy1_ID"), 0);
						TogglePlayerControllable(GetPVarInt(inviter, "Duel_3v3_Enemy2_ID"), 0);
						TogglePlayerControllable(GetPVarInt(inviter, "Duel_3v3_Enemy3_ID"), 0);

						SetTimerEx("Duel_Start", 10000, false, "d", inviter);

						SetPVarInt(inviter, "SkinBeforeDuel", GetPlayerSkin(inviter));
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Teammate1_ID"), "SkinBeforeDuel", GetPlayerSkin(GetPVarInt(inviter, "Duel_3v3_Teammate1_ID")));
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Teammate2_ID"), "SkinBeforeDuel", GetPlayerSkin(GetPVarInt(inviter, "Duel_3v3_Teammate2_ID")));
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy1_ID"), "SkinBeforeDuel", GetPlayerSkin(GetPVarInt(inviter, "Duel_3v3_Enemy1_ID")));
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy2_ID"), "SkinBeforeDuel", GetPlayerSkin(GetPVarInt(inviter, "Duel_3v3_Enemy2_ID")));
						SetPVarInt(GetPVarInt(inviter, "Duel_3v3_Enemy3_ID"), "SkinBeforeDuel", GetPlayerSkin(GetPVarInt(inviter, "Duel_3v3_Enemy3_ID")));

						SetPlayerVirtualWorld(inviter, inviter+1*GetPVarInt(inviter, "Duel_3v3_Teammate1_ID")+1*1000);
						SetPlayerVirtualWorld(GetPVarInt(inviter, "Duel_3v3_Teammate1_ID"), inviter+1*GetPVarInt(inviter, "Duel_3v3_Teammate1_ID")+1*1000);
						SetPlayerVirtualWorld(GetPVarInt(inviter, "Duel_3v3_Teammate2_ID"), inviter+1*GetPVarInt(inviter, "Duel_3v3_Teammate1_ID")+1*1000);
						SetPlayerVirtualWorld(GetPVarInt(inviter, "Duel_3v3_Enemy1_ID"), inviter+1*GetPVarInt(inviter, "Duel_3v3_Teammate1_ID")+1*1000);
						SetPlayerVirtualWorld(GetPVarInt(inviter, "Duel_3v3_Enemy2_ID"), inviter+1*GetPVarInt(inviter, "Duel_3v3_Teammate1_ID")+1*1000);
						SetPlayerVirtualWorld(GetPVarInt(inviter, "Duel_3v3_Enemy3_ID"), inviter+1*GetPVarInt(inviter, "Duel_3v3_Teammate1_ID")+1*1000);
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need atleast 70 healthpoints to accept the request.");
			}
		}
		
		else
		{
			SendClientMessage(GetPVarInt(playerid,"Duel_Inviter"), COLOR_WARNING, "[ERROR] You have to leave your vehicle before going to the duel area");
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR] The inviter has to leave his vehicle before going to the duel area");
		}
	}
	else
	{
 		SendClientMessage(playerid, COLOR_NOTICE, "Get out of your vehicle first!");
	}
	return 1;
}

forward Duel_Start(playerid);
public Duel_Start(playerid)
{
    if(GetPVarInt(playerid, "Duel_Type") == 1)
	{
	    GameTextForPlayer(playerid, "~w~duel started", 2000, 3);
	    GameTextForPlayer(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), "~w~duel started", 2000, 3);
		TogglePlayerControllable(playerid, 1);
		TogglePlayerControllable(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), 1);

		GivePlayerWeapon(playerid, GetPVarInt(playerid, "Duel_Wep2"), 5000);
		GivePlayerWeapon(playerid, GetPVarInt(playerid, "Duel_Wep1"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), GetPVarInt(playerid, "Duel_Wep2"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), GetPVarInt(playerid, "Duel_Wep1"), 5000);
		SetPlayerArmour(playerid, 0);
		if(GetPVarInt(playerid, "Duel_Armour") == 1)
		{
		    SetPlayerArmour(playerid, 100);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), 100);
		}
		else
		{
		    SetPlayerArmour(playerid, 0);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), 0);
		}
		if(GetPVarInt(playerid, "Duel_CJ") == 1)
		{
		    SetPlayerSkin(playerid, 0);
		    SetPlayerSkin(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), 0);
		}
		new messagestr[175];
		format(messagestr,sizeof(messagestr),"[DUEL: 1 VS 1] %s vs. %s (%s) has just started!", PlayerName(playerid), PlayerName(GetPVarInt(playerid, "Duel_1v1_Opponent_ID")), DuelMaps_Info[GetPVarInt(playerid, "Duel_Map")][0]);
		SendClientMessageToAll(COLOR_GREEN, messagestr);
		
		SetPlayerHealth(playerid, 100);
		SetPlayerHealth(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), 100);
		
        for(new d=0; d<MAX_DUELS; d++)
		{
			if(d > 0)
			{
			    if(Team_A_Amount[d] == 0 && Team_B_Amount[d] == 0)
			    {
			        SetPVarInt(playerid, "Duel_ID", d);
			        SetPVarInt(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), "Duel_ID", d);
			        Team_A_Amount[d] = 1;
			        Team_B_Amount[d] = 1;
			        Team_A_1[d] = playerid;
					Team_B_1[d] = GetPVarInt(playerid, "Duel_1v1_Opponent_ID");
					Duel_Type[d] = 1;
					Duel_Stake[d] = GetPVarInt(playerid, "Duel_Stake");


					return 1;
			    }
		    }
		}
		
	}
	if(GetPVarInt(playerid, "Duel_Type") == 2)
	{
	    GameTextForPlayer(playerid, "~w~duel started", 2000, 3);
	    GameTextForPlayer(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), "~w~duel started", 2000, 3);
	    GameTextForPlayer(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), "~w~duel started", 2000, 3);
	    GameTextForPlayer(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), "~w~duel started", 2000, 3);
	    
	    TogglePlayerControllable(playerid, 1);
	    TogglePlayerControllable(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), 1);
	    TogglePlayerControllable(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), 1);
	    TogglePlayerControllable(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), 1);
	    
	    GivePlayerWeapon(playerid, GetPVarInt(playerid, "Duel_Wep2"), 5000);
		GivePlayerWeapon(playerid, GetPVarInt(playerid, "Duel_Wep1"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), GetPVarInt(playerid, "Duel_Wep2"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), GetPVarInt(playerid, "Duel_Wep1"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), GetPVarInt(playerid, "Duel_Wep2"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), GetPVarInt(playerid, "Duel_Wep1"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), GetPVarInt(playerid, "Duel_Wep2"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), GetPVarInt(playerid, "Duel_Wep1"), 5000);
		SetPlayerArmour(playerid, 0);
		SetPlayerArmour(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), 0);
		SetPlayerArmour(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), 0);
		SetPlayerArmour(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), 0);
		if(GetPVarInt(playerid, "Duel_Armour") == 1)
		{
		    SetPlayerArmour(playerid, 100);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), 100);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), 100);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), 100);
		}
		else
		{
		    SetPlayerArmour(playerid, 0);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), 0);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), 0);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), 0);
		}
		if(GetPVarInt(playerid, "Duel_CJ") == 1)
		{
		    SetPlayerSkin(playerid, 0);
		    SetPlayerSkin(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), 0);
		    SetPlayerSkin(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), 0);
		    SetPlayerSkin(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), 0);
		}
		
		new messagestr[175];
		format(messagestr,sizeof(messagestr),"[DUEL: 2 VS 2] %s and %s vs. %s and %s (%s) has just started!", PlayerName(playerid), PlayerName(GetPVarInt(playerid, "Duel_2v2_Teammate_ID")),PlayerName(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID")), PlayerName(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID")),DuelMaps_Info[GetPVarInt(playerid, "Duel_Map")][0]);
		SendClientMessageToAll(COLOR_GREEN, messagestr);
		
		SetPlayerHealth(playerid, 100);
		SetPlayerHealth(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), 100);
		SetPlayerHealth(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), 100);
		SetPlayerHealth(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), 100);


        for(new d=0; d<MAX_DUELS; d++)
		{
		    if(d > 0)
			{
			    if(Team_A_Amount[d] == 0 && Team_B_Amount[d] == 0)
			    {
	   				SetPVarInt(playerid, "Duel_ID", d);
			        SetPVarInt(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), "Duel_ID", d);
					SetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), "Duel_ID", d);
					SetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), "Duel_ID", d);
			        Team_A_Amount[d] = 2;
			        Team_B_Amount[d] = 2;
			        Team_A_1[d] = playerid;
					Team_A_2[d] = GetPVarInt(playerid, "Duel_2v2_Teammate_ID");
					Team_B_1[d] = GetPVarInt(playerid, "Duel_2v2_Enemy1_ID");
					Team_B_2[d] = GetPVarInt(playerid, "Duel_2v2_Enemy2_ID");
					Duel_Type[d] = 2;
					Duel_Stake[d] = GetPVarInt(playerid, "Duel_Stake");
					return 1;
			    }
		    }
		}
	
	}
	if(GetPVarInt(playerid, "Duel_Type") == 3)
	{
	    GameTextForPlayer(playerid, "~w~duel started", 2000, 3);
	    GameTextForPlayer(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), "~w~duel started", 2000, 3);
	    GameTextForPlayer(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), "~w~duel started", 2000, 3);
	    GameTextForPlayer(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), "~w~duel started", 2000, 3);
	    GameTextForPlayer(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), "~w~duel started", 2000, 3);
	    GameTextForPlayer(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), "~w~duel started", 2000, 3);

	    TogglePlayerControllable(playerid, 1);
	    TogglePlayerControllable(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), 1);
	    TogglePlayerControllable(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), 1);
	    TogglePlayerControllable(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), 1);
	    TogglePlayerControllable(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), 1);
	    TogglePlayerControllable(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), 1);

	    GivePlayerWeapon(playerid, GetPVarInt(playerid, "Duel_Wep2"), 5000);
		GivePlayerWeapon(playerid, GetPVarInt(playerid, "Duel_Wep1"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), GetPVarInt(playerid, "Duel_Wep2"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), GetPVarInt(playerid, "Duel_Wep1"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), GetPVarInt(playerid, "Duel_Wep2"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), GetPVarInt(playerid, "Duel_Wep1"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), GetPVarInt(playerid, "Duel_Wep2"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), GetPVarInt(playerid, "Duel_Wep1"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), GetPVarInt(playerid, "Duel_Wep2"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), GetPVarInt(playerid, "Duel_Wep1"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), GetPVarInt(playerid, "Duel_Wep2"), 5000);
		GivePlayerWeapon(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), GetPVarInt(playerid, "Duel_Wep1"), 5000);

        SetPlayerArmour(playerid, 0);
		SetPlayerArmour(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), 0);
		SetPlayerArmour(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), 0);
		SetPlayerArmour(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), 0);
		SetPlayerArmour(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), 0);
		SetPlayerArmour(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), 0);
		    
		if(GetPVarInt(playerid, "Duel_Armour") == 1)
		{
		    SetPlayerArmour(playerid, 100);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), 100);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), 100);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), 100);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), 100);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), 100);
		}
		else
		{
		    SetPlayerArmour(playerid, 0);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), 0);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), 0);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), 0);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), 0);
		    SetPlayerArmour(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), 0);
		}
		if(GetPVarInt(playerid, "Duel_CJ") == 1)
		{
		    SetPlayerSkin(playerid, 0);
		    SetPlayerSkin(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), 0);
		    SetPlayerSkin(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), 0);
		    SetPlayerSkin(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), 0);
		    SetPlayerSkin(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), 0);
		    SetPlayerSkin(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), 0);
		}

		new messagestr[175];
		format(messagestr,sizeof(messagestr),"[DUEL: 3 VS 3] %s, %s and %s vs. %s, %s and %s (%s) has just started!", PlayerName(playerid), PlayerName(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID")),
		DuelMaps_Info[GetPVarInt(playerid, "Duel_Map")][0]); // One line < ^
		SendClientMessageToAll(COLOR_GREEN, messagestr);

		SetPlayerHealth(playerid, 100);
		SetPlayerHealth(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), 100);
		SetPlayerHealth(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), 100);
		SetPlayerHealth(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), 100);
		SetPlayerHealth(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), 100);
		SetPlayerHealth(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), 100);


        for(new d=0; d<MAX_DUELS; d++)
		{
		    if(d > 0)
			{
			
			    if(Team_A_Amount[d] == 0 && Team_B_Amount[d] == 0)
			    {
	   				SetPVarInt(playerid, "Duel_ID", d);
			        SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), "Duel_ID", d);
					SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), "Duel_ID", d);
					SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), "Duel_ID", d);
					SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), "Duel_ID", d);
					SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), "Duel_ID", d);
			        Team_A_Amount[d] = 3;
			        Team_B_Amount[d] = 3;
			        Team_A_1[d] = playerid;
					Team_A_2[d] = GetPVarInt(playerid, "Duel_3v3_Teammate1_ID");
					Team_A_3[d] = GetPVarInt(playerid, "Duel_3v3_Teammate2_ID");
					Team_B_1[d] = GetPVarInt(playerid, "Duel_3v3_Enemy1_ID");
					Team_B_2[d] = GetPVarInt(playerid, "Duel_3v3_Enemy2_ID");
					Team_B_3[d] = GetPVarInt(playerid, "Duel_3v3_Enemy3_ID");
					Duel_Type[d] = 3;
					Duel_Stake[d] = GetPVarInt(playerid, "Duel_Stake");

					return 1;
			    }
		    }
		}

	}
	return 1;
}


CMD:reduel(playerid, params[])
{
    if(GetPVarInt(playerid, "Duel_Invite_Pending") == 1) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You still have a request pending.");
    
    if(GetPVarInt(playerid, "Duel_Type") == 0)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to duel atleast once to use this command.");
	}
    if(GetPVarInt(playerid, "InEvent") == 1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't do that now.");
	}

    if(GetPVarInt(playerid, "PlayerStatus") != 0)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't do that whilst in a duel.");
	}


	if(!IsPlayerInAnyVehicle(playerid))
	{
        if(!IsPlayerInAnyVehicle(playerid))
 		{
	        if(GetPVarInt(playerid, "Duel_Type") == 1)
			{
				if(GetPVarInt(playerid, "Duel_Stake") > GetPlayerMoney(playerid))
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not have enough money for that");
				}
				if(GetPVarInt(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), "Duel_Stake") > GetPlayerMoney(GetPVarInt(playerid, "Duel_1v1_Opponent_ID")))
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your opponent doesn't have enough money for this");
				}
		        if(GetPVarInt(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), "Duel_Invite_Pending") == 1)
				{
				    SendClientMessage(playerid, COLOR_NOTICE, "It seems this player already has a duel request pending.");
				    return 1;
				}
	   			if(GetPVarInt(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), "PlayerStatus") == 2)
				{
				    SendClientMessage(playerid, COLOR_NOTICE, "It seems this player is already dueling.");
				    return 1;
				}
			}
			if(GetPVarInt(playerid, "Duel_Type") == 2)
			{
				if(GetPVarInt(playerid, "Duel_Stake") > GetPlayerMoney(playerid))
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not have enough money for that");
				}
				if(GetPVarInt(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), "Duel_Stake") > GetPlayerMoney(GetPVarInt(playerid, "Duel_2v2_Teammate_ID")))
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your team-mate doesn't have enough money for this.");
				}
				if((GetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), "Duel_Stake") > GetPlayerMoney(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"))) || (GetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), "Duel_Stake") > GetPlayerMoney(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"))))
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: One of your opponents doesn't have enough money");
				}
			    if(GetPVarInt(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), "Duel_Invite_Pending") == 1 || GetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), "Duel_Invite_Pending") == 1 || GetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), "Duel_Invite_Pending") == 1)
				{
				    SendClientMessage(playerid, COLOR_NOTICE, "One or more players already have an invite pending.");
				    return 1;
				}
	   			if(GetPVarInt(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), "PlayerStatus") == 2 || GetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), "PlayerStatus") == 2 || GetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), "PlayerStatus") == 2)
				{
				    SendClientMessage(playerid, COLOR_NOTICE, "One or more players are already dueling.");
				    return 1;
				}

			}
			if(GetPVarInt(playerid, "Duel_Type") == 3)
			{
				if(GetPVarInt(playerid, "Duel_Stake") > GetPlayerMoney(playerid))
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not have enough money for that");
				}
				if((GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), "Duel_Stake") > GetPlayerMoney(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"))) || (GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), "Duel_Stake") > GetPlayerMoney(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"))))
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: One of your team-mates doesn't have enough money for this.");
				}
				if((GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), "Duel_Stake") > GetPlayerMoney(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"))) || (GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), "Duel_Stake") > GetPlayerMoney(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"))) || (GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), "Duel_Stake") > GetPlayerMoney(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"))))
				{
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: One of your opponents doesn't have enough money for this.");
				}
				
			    if(GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), "Duel_Invite_Pending") == 1 || GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), "Duel_Invite_Pending") == 1 || GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), "Duel_Invite_Pending") == 1 || GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), "Duel_Invite_Pending") == 1 || GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), "Duel_Invite_Pending") == 1)
				{
				    SendClientMessage(playerid, COLOR_NOTICE, "One or more players already have an invite pending.");
				    return 1;
				}
	   			if(GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), "PlayerStatus") == 2 || GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), "PlayerStatus") == 2 || GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), "PlayerStatus") == 2 || GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), "PlayerStatus") == 2 || GetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), "PlayerStatus") == 2)
				{
				    SendClientMessage(playerid, COLOR_NOTICE, "One or more players are already dueling.");
				    return 1;
				}
			}

    		new CJRun[4];
			if(GetPVarInt(playerid, "Duel_CJ") == 1)
			{
				format(CJRun, sizeof(CJRun), "On");
			}
			else
			{
   				format(CJRun, sizeof(CJRun), "Off");
			}
			new Armour[4];
			if(GetPVarInt(playerid, "Duel_Armour") == 1)
			{
				format(Armour, sizeof(Armour), "On");
			}
			else
			{
   				format(Armour, sizeof(Armour), "Off");
			}
			
			if(GetPVarInt(playerid, "Duel_Type") == 1)
			{
				new messagestr[175];
				format(messagestr,sizeof(messagestr),"[DUEL] %s invites you for a 1 vs. 1 duel! Type /acceptduel to accept the request.", PlayerName(playerid));
				if(GetPVarInt(playerid, "Duel_Stake") > 0) format(messagestr,sizeof(messagestr),"[DUEL] %s invites you for a 1 vs. 1 duel! (Stake: $%d) Type /acceptduel to accept the request.", PlayerName(playerid), GetPVarInt(playerid, "Duel_Stake"));
				SendClientMessage(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), COLOR_GREEN, messagestr);
				format(messagestr,sizeof(messagestr),"[SETTINGS] Map: [%s] Wep 1: [%s] - Wep 2: [%s] Armour: [%s] CJ: [%s]", DuelMaps_Info[GetPVarInt(playerid, "Duel_Map")][0], WeaponName(GetPVarInt(playerid, "Duel_Wep1")), WeaponName(GetPVarInt(playerid, "Duel_Wep2")), Armour, CJRun);
				SendClientMessage(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), COLOR_NOTICE, messagestr);
	            SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You succesfully sent a reduel request with the same settings as your previous duel.");
				SendClientMessage(playerid, COLOR_NOTICE, messagestr);

    			DuelExpireTimer[GetPVarInt(playerid, "Duel_1v1_Opponent_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_1v1_Opponent_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), "Duel_Invite_Pending", 1);
			}
			if(GetPVarInt(playerid, "Duel_Type") == 2)
			{
			    new messagestr[175];
				format(messagestr,sizeof(messagestr),"[DUEL] %s invites you for a 2 vs. 2 duel! Type /acceptduel to accept the request.", PlayerName(playerid));
				if(GetPVarInt(playerid, "Duel_Stake") > 0) format(messagestr,sizeof(messagestr),"[DUEL] %s invites you for a 2 vs. 2 duel! (Stake: $%d) Type /acceptduel to accept the request.", PlayerName(playerid), GetPVarInt(playerid, "Duel_Stake"));
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), COLOR_GREEN, messagestr);
				format(messagestr,sizeof(messagestr),"[SETTINGS] Map: [%s] Wep 1: [%s] - Wep 2: [%s] Armour: [%s] CJ: [%s]", DuelMaps_Info[GetPVarInt(playerid, "Duel_Map")][0], WeaponName(GetPVarInt(playerid, "Duel_Wep1")), WeaponName(GetPVarInt(playerid, "Duel_Wep2")), Armour, CJRun);
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), COLOR_NOTICE, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), COLOR_NOTICE, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), COLOR_NOTICE, messagestr);
	            SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You succesfully sent a reduel request with the same settings as your previous duel.");
				SendClientMessage(playerid, COLOR_NOTICE, messagestr);

				format(messagestr,sizeof(messagestr),"[TEAMS] Team A: [%s and %s] - Team B: [%s and %s]", PlayerName(playerid), PlayerName(GetPVarInt(playerid, "Duel_2v2_Teammate_ID")), PlayerName(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID")), PlayerName(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID")));
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), COLOR_NOTICE, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), COLOR_NOTICE, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), COLOR_NOTICE, messagestr);
				SendClientMessage(playerid, COLOR_NOTICE, messagestr);

				DuelExpireTimer[GetPVarInt(playerid, "Duel_2v2_Teammate_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_2v2_Teammate_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_2v2_Teammate_ID"), "Duel_Invite_Pending", 1);
				DuelExpireTimer[GetPVarInt(playerid, "Duel_2v2_Enemy1_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy1_ID"), "Duel_Invite_Pending", 1);
				DuelExpireTimer[GetPVarInt(playerid, "Duel_2v2_Enemy2_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_2v2_Enemy2_ID"), "Duel_Invite_Pending", 1);

			}
			if(GetPVarInt(playerid, "Duel_Type") == 3)
			{
			    new messagestr[175];
				format(messagestr,sizeof(messagestr),"[DUEL] %s invites you for a 3 vs. 3 duel! Type /acceptduel to accept the request.", PlayerName(playerid));
				if(GetPVarInt(playerid, "Duel_Stake") > 0) format(messagestr,sizeof(messagestr),"[DUEL] %s invites you for a 3 vs. 3 duel! (Stake: $%d) Type /acceptduel to accept the request.", PlayerName(playerid), GetPVarInt(playerid, "Duel_Stake"));
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), COLOR_GREEN, messagestr);
				format(messagestr,sizeof(messagestr),"[SETTINGS] Map: [%s] Wep 1: [%s] - Wep 2: [%s] Armour: [%s] CJ: [%s]", DuelMaps_Info[GetPVarInt(playerid, "Duel_Map")][0], WeaponName(GetPVarInt(playerid, "Duel_Wep1")), WeaponName(GetPVarInt(playerid, "Duel_Wep2")), Armour, CJRun);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), COLOR_GREEN, messagestr);
	            SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You succesfully sent a reduel request with the same settings as your previous duel.");
				SendClientMessage(playerid, COLOR_NOTICE, messagestr);

				format(messagestr,sizeof(messagestr),"[TEAMS] Team A: [%s, %s and %s] - Team B: [%s, %s and %s]", PlayerName(playerid), PlayerName(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID")), PlayerName(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID")));
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), COLOR_GREEN, messagestr);
				SendClientMessage(playerid, COLOR_NOTICE, messagestr);

				DuelExpireTimer[GetPVarInt(playerid, "Duel_3v3_Teammate1_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate1_ID"), "Duel_Invite_Pending", 1);
				DuelExpireTimer[GetPVarInt(playerid, "Duel_3v3_Teammate2_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Teammate2_ID"), "Duel_Invite_Pending", 1);
				DuelExpireTimer[GetPVarInt(playerid, "Duel_3v3_Enemy1_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy1_ID"), "Duel_Invite_Pending", 1);
				DuelExpireTimer[GetPVarInt(playerid, "Duel_3v3_Enemy2_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy2_ID"), "Duel_Invite_Pending", 1);
				DuelExpireTimer[GetPVarInt(playerid, "Duel_3v3_Enemy3_ID")] = SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"));
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), "Duel_Inviter", playerid);
				SetPVarInt(GetPVarInt(playerid, "Duel_3v3_Enemy3_ID"), "Duel_Invite_Pending", 1);
			}
			SetPVarInt(playerid, "Duel_Requester", 1);
			SetTimerEx("DuelInvite_Expire", EXPIRE_TIME, false, "d", playerid);
			DuelExpireTimer[playerid] = SetPVarInt(playerid, "Duel_Invite_Pending", 1);
		}
	}

	else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Leave your vehicle first.");
	}

	return 1;
}

//hook OnPlayerDeath(playerid, killerid, reason)
public DuelPlayerDeath(playerid,killerid,reason)
{
		if(GetPVarInt(playerid, "PlayerStatus") == 2)
		{
		    if(GetPVarInt(playerid, "Duel_Type") == 1) // 1v1
		    {

		        new duelid = GetPVarInt(playerid, "Duel_ID");
		        ResetDuel(duelid);

	     		new messagestr[175];
				new rand = random(5);
				if(rand == 0) format(messagestr,sizeof(messagestr),"[DUEL: 1 VS 1] %s dropped %s like it's hot in a duel!", PlayerName(GetPVarInt(playerid, "Duel_1v1_Opponent_ID")), PlayerName(playerid));
				if(rand == 1) format(messagestr,sizeof(messagestr),"[DUEL: 1 VS 1] %s has just kicked %s's ass in a duel!", PlayerName(GetPVarInt(playerid, "Duel_1v1_Opponent_ID")), PlayerName(playerid));
				if(rand == 2) format(messagestr,sizeof(messagestr),"[DUEL: 1 VS 1] %s has just bested %s in a duel!", PlayerName(GetPVarInt(playerid, "Duel_1v1_Opponent_ID")), PlayerName(playerid));
				if(rand == 3) format(messagestr,sizeof(messagestr),"[DUEL: 1 VS 1] %s has just humiliated %s in a duel!", PlayerName(GetPVarInt(playerid, "Duel_1v1_Opponent_ID")), PlayerName(playerid));
                if(rand == 4) format(messagestr,sizeof(messagestr),"[DUEL: 1 VS 1] %s has just wrecked %s in a duel!", PlayerName(GetPVarInt(playerid, "Duel_1v1_Opponent_ID")), PlayerName(playerid));
                GiveAchievement(playerid, 92);
                GiveAchievement(killerid, 91);
                FoCo_Player[killerid][duels_won]++;
                FoCo_Player[playerid][duels_lost]++;
                if(FoCo_Player[killerid][duels_won] >= 10)
                {
					GiveAchievement(killerid, 93);
					if(FoCo_Player[killerid][duels_won] >= 100)
					{
					    GiveAchievement(killerid, 94);
					    if(FoCo_Player[killerid][duels_won] >= 500)
					    {
                            GiveAchievement(killerid, 95);
					    }
					}
                }
                SetPVarInt(playerid, "PlayerStatus", 0);
                SetPVarInt(playerid, "DuelException", 1);
                SetPVarInt(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), "PlayerStatus", 0);
				SendClientMessageToAll(COLOR_GREEN, messagestr);
				if(GetPVarInt(playerid, "Duel_Stake") > 0)
				{
					format(messagestr,sizeof(messagestr), "[DUEL STAKE] You won $%d!", GetPVarInt(playerid, "Duel_Stake"));
					SendClientMessage(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), COLOR_NOTICE, messagestr);
					format(messagestr, sizeof(messagestr), "[DUEL]: %s (%d) gained %d$ by winning in a duel against %s (%d)", PlayerName(GetPVarInt(playerid, "Duel_1v1_Opponent_ID")), GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), GetPVarInt(playerid, "Duel_Stake"), PlayerName(playerid), playerid);
					MoneyLog(messagestr);
					GivePlayerMoney(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), GetPVarInt(playerid, "Duel_Stake")*2);
					format(messagestr,sizeof(messagestr), "[DUEL STAKE] You lost $%d!", GetPVarInt(playerid, "Duel_Stake"));
					SendClientMessage(playerid, COLOR_NOTICE, messagestr);
					format(messagestr, sizeof(messagestr), "[DUEL]: %s (%d) lost %d$ by losing in a duel against %s (%d)",PlayerName(playerid), playerid, GetPVarInt(playerid, "Duel_Stake"), PlayerName(GetPVarInt(playerid, "Duel_1v1_Opponent_ID")), GetPVarInt(playerid, "Duel_1v1_Opponent_ID"));
					MoneyLog(messagestr);
				}
				
						
				//SetPVarInt(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), "PlayerStatus", 2);
				SetPVarInt(GetPVarInt(playerid, "Duel_1v1_Opponent_ID"), "LastDiedInDuel", 1);
			    // armour if he unlocked it
		    }
		    if(GetPVarInt(playerid, "Duel_Type") == 2) // 2v2
		    {
		        new messagestr[175];
				new duelid = GetPVarInt(playerid, "Duel_ID");
	            SetPVarInt(playerid, "PlayerStatus", 0);
				if(playerid == Team_A_1[duelid] || playerid == Team_A_2[duelid]) // Someone of Team A died.
	   			{
		            Team_A_Amount[duelid] --;
	           		if(Team_A_Amount[duelid] == 0)
	           		{
						new rand = random(5);
						if(rand == 0) format(messagestr,sizeof(messagestr),"[DUEL: 2 VS 2] %s and %s dropped %s and %s like it's hot in a duel!", PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]),PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]));
						if(rand == 1) format(messagestr,sizeof(messagestr),"[DUEL: 2 VS 2] %s and %s have just kicked %s and %s's asses in a duel!", PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]),PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]));
						if(rand == 2) format(messagestr,sizeof(messagestr),"[DUEL: 2 VS 2] %s and %s have just bested %s and %s in a duel!", PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]),PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]));
						if(rand == 3) format(messagestr,sizeof(messagestr),"[DUEL: 2 VS 2] %s and %s have just humiliated %s and %s in a duel!", PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]),PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]));
						if(rand == 4) format(messagestr,sizeof(messagestr),"[DUEL: 2 VS 2] %s and %s have just wrecked %s and %s in a duel!", PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]),PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]));
                        SetPVarInt(Team_A_1[duelid], "PlayerStatus", 0);
                        SetPVarInt(Team_A_2[duelid], "PlayerStatus", 0);
                        SetPVarInt(Team_B_1[duelid], "PlayerStatus", 0);
                        SetPVarInt(Team_B_2[duelid], "PlayerStatus", 0);
                        
						SendClientMessageToAll(COLOR_GREEN, messagestr);
	                    if(Duel_Stake[duelid] > 0)
						{
							format(messagestr,sizeof(messagestr), "[DUEL STAKE] You won $%d!", Duel_Stake[duelid]);
							SendClientMessage(Team_B_1[duelid], COLOR_NOTICE, messagestr);
							SendClientMessage(Team_B_2[duelid], COLOR_NOTICE, messagestr);
							format(messagestr, sizeof(messagestr), "[DUEL]: %s (%d) and %s (%d) gained %d$ by winning a duel against %s (%d) and %s (%d)", PlayerName(Team_B_1[duelid]), Team_B_1[duelid], PlayerName(Team_B_2[duelid]), Team_B_2[duelid], Duel_Stake[duelid], PlayerName(Team_A_1[duelid]), Team_A_1[duelid], PlayerName(Team_A_2[duelid]), Team_A_2[duelid]);
							MoneyLog(messagestr);
							GivePlayerMoney(Team_B_1[duelid], Duel_Stake[duelid]);
							GivePlayerMoney(Team_B_2[duelid], Duel_Stake[duelid]);

							format(messagestr,sizeof(messagestr), "[DUEL STAKE] You lost $%d!", GetPVarInt(playerid, "Duel_Stake"));
							SendClientMessage(Team_A_1[duelid], COLOR_NOTICE, messagestr);
							SendClientMessage(Team_A_2[duelid], COLOR_NOTICE, messagestr);
							format(messagestr, sizeof(messagestr), "[DUEL]: %s (%d) and %s (%d) lost %d$ by losing a duel against %s (%d) and %s (%d)", PlayerName(Team_A_1[duelid]), Team_A_1[duelid], PlayerName(Team_A_2[duelid]), Team_A_2[duelid], Duel_Stake[duelid], PlayerName(Team_B_1[duelid]), Team_B_1[duelid], PlayerName(Team_B_2[duelid]), Team_B_2[duelid]);
							MoneyLog(messagestr);
						}
						ResetDuel(duelid);
						return 1;

		            }
		            TogglePlayerSpectating(playerid, 1);
		            if(playerid == Team_A_1[duelid])
		            {
		            	PlayerSpectatePlayer(playerid, Team_A_2[duelid]);
		            }
		            else
		            {
		                PlayerSpectatePlayer(playerid, Team_A_1[duelid]);
		            }
				}
				if(playerid == Team_B_1[duelid] || playerid == Team_B_2[duelid]) // Someone of Team B died.
	   			{
		            Team_B_Amount[duelid] --;
	           		if(Team_B_Amount[duelid] == 0)
	           		{
						new rand = random(5);
						if(rand == 0) format(messagestr,sizeof(messagestr),"[DUEL: 2 VS 2] %s and %s dropped %s and %s like it's hot in a duel!", PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]),PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]));
						if(rand == 1) format(messagestr,sizeof(messagestr),"[DUEL: 2 VS 2] %s and %s have just kicked %s and %s's asses in a duel!", PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]),PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]));
						if(rand == 2) format(messagestr,sizeof(messagestr),"[DUEL: 2 VS 2] %s and %s have just bested %s and %s in a duel!", PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]),PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]));
						if(rand == 3) format(messagestr,sizeof(messagestr),"[DUEL: 2 VS 2] %s and %s have just humiliated %s and %s in a duel!", PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]),PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]));
						if(rand == 4) format(messagestr,sizeof(messagestr),"[DUEL: 2 VS 2] %s and %s have just wrecked %s and %s in a duel!", PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]),PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]));
      					SetPVarInt(Team_A_1[duelid], "PlayerStatus", 0);
                        SetPVarInt(Team_A_2[duelid], "PlayerStatus", 0);
                        SetPVarInt(Team_B_1[duelid], "PlayerStatus", 0);
                        SetPVarInt(Team_B_2[duelid], "PlayerStatus", 0);
                        
						SendClientMessageToAll(COLOR_GREEN, messagestr);
						if(Duel_Stake[duelid] > 0)
						{
							format(messagestr,sizeof(messagestr), "[DUEL STAKE] You won $%d!", Duel_Stake[duelid]);
							SendClientMessage(Team_A_1[duelid], COLOR_NOTICE, messagestr);
							SendClientMessage(Team_A_2[duelid], COLOR_NOTICE, messagestr);
							GivePlayerMoney(Team_A_1[duelid], Duel_Stake[duelid]);
							GivePlayerMoney(Team_A_2[duelid], Duel_Stake[duelid]);
							format(messagestr, sizeof(messagestr), "[DUEL]: %s (%d) and %s (%d) gained %d$ by winning in a duel against %s (%d) and %s (%d).", PlayerName(Team_A_1[duelid]), Team_A_1[duelid], PlayerName(Team_A_2[duelid]), Team_A_2[duelid], Duel_Stake[duelid], PlayerName(Team_B_1[duelid]), Team_B_1[duelid], PlayerName(Team_B_2[duelid]), Team_B_2[duelid]);
							MoneyLog(messagestr);
							format(messagestr,sizeof(messagestr), "[DUEL STAKE] You lost $%d!", GetPVarInt(playerid, "Duel_Stake"));
							SendClientMessage(Team_B_1[duelid], COLOR_NOTICE, messagestr);
							SendClientMessage(Team_B_2[duelid], COLOR_NOTICE, messagestr);
							format(messagestr, sizeof(messagestr), "[DUEL]: %s (%d) and %s (%d) lost %d$ by losing in a duel against %s (%d) and %s (%d).", PlayerName(Team_B_1[duelid]), Team_B_1[duelid], PlayerName(Team_B_2[duelid]), Team_B_2[duelid], Duel_Stake[duelid], PlayerName(Team_A_1[duelid]), Team_A_1[duelid], PlayerName(Team_A_2[duelid]), Team_A_2[duelid]);
							MoneyLog(messagestr);
						}
						ResetDuel(duelid);
						
						return 1;

		            }
		            TogglePlayerSpectating(playerid, 1);
		            if(playerid == Team_B_1[duelid])
		            {
		            	PlayerSpectatePlayer(playerid, Team_B_2[duelid]);
		            }
		            else
		            {
		                PlayerSpectatePlayer(playerid, Team_B_1[duelid]);
		            }

				}

		    }

		    if(GetPVarInt(playerid, "Duel_Type") == 3) // 3v3
		    {
		        SetPVarInt(playerid, "PlayerStatus", 0);
		        new messagestr[175];
				new duelid = GetPVarInt(playerid, "Duel_ID");

                SetPVarInt(playerid, "Died_In_Duel", 1);
				if(GetPVarInt(playerid, "Duel_Speccedby_ID") > 0)
	   			{
	      			ToggleDuelSpectate(GetPVarInt(playerid, "Duel_Speccedby_ID")-1, duelid);
			    }

				if(playerid == Team_A_1[duelid] || playerid == Team_A_2[duelid] || playerid == Team_A_3[duelid]) // Someone of Team A died.
	   			{
		            Team_A_Amount[duelid] --;
	           		if(Team_A_Amount[duelid] == 0)
	           		{
						new rand = random(5);
						if(rand == 0) format(messagestr,sizeof(messagestr),"[DUEL: 3 VS 3] %s, %s and %s dropped %s, %s and %s like it's hot in a duel!", PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]), PlayerName(Team_B_3[duelid]),PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]),PlayerName(Team_A_3[duelid]));
						if(rand == 1) format(messagestr,sizeof(messagestr),"[DUEL: 3 VS 3] %s, %s and %s have just kicked %s, %s and %s's asses in a duel!", PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]), PlayerName(Team_B_3[duelid]),PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]),PlayerName(Team_A_3[duelid]));
						if(rand == 2) format(messagestr,sizeof(messagestr),"[DUEL: 3 VS 3] %s, %s and %s have just bested %s, %s and %s in a duel!", PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]), PlayerName(Team_B_3[duelid]),PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]),PlayerName(Team_A_3[duelid]));
						if(rand == 3) format(messagestr,sizeof(messagestr),"[DUEL: 3 VS 3] %s, %s and %s have just humiliated %s, %s and %s in a duel!", PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]), PlayerName(Team_B_3[duelid]),PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]),PlayerName(Team_A_3[duelid]));
						if(rand == 4) format(messagestr,sizeof(messagestr),"[DUEL: 3 VS 3] %s, %s and %s have just wrecked %s, %s and %s in a duel!", PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]), PlayerName(Team_B_3[duelid]),PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]),PlayerName(Team_A_3[duelid]));
      					SetPVarInt(Team_A_1[duelid], "PlayerStatus", 0);
                        SetPVarInt(Team_A_2[duelid], "PlayerStatus", 0);
                        SetPVarInt(Team_A_3[duelid], "PlayerStatus", 0);
                        SetPVarInt(Team_B_1[duelid], "PlayerStatus", 0);
                        SetPVarInt(Team_B_2[duelid], "PlayerStatus", 0);
                        SetPVarInt(Team_B_3[duelid], "PlayerStatus", 0);

						SendClientMessageToAll(COLOR_GREEN, messagestr);
	                    if(Duel_Stake[duelid] > 0)
						{
							format(messagestr,sizeof(messagestr), "[DUEL STAKE] You won $%d!", Duel_Stake[duelid]);
							SendClientMessage(Team_B_1[duelid], COLOR_NOTICE, messagestr);
							SendClientMessage(Team_B_2[duelid], COLOR_NOTICE, messagestr);
							SendClientMessage(Team_B_3[duelid], COLOR_NOTICE, messagestr);
							GivePlayerMoney(Team_B_1[duelid], Duel_Stake[duelid]);
							GivePlayerMoney(Team_B_2[duelid], Duel_Stake[duelid]);
							GivePlayerMoney(Team_B_3[duelid], Duel_Stake[duelid]);
							format(messagestr, sizeof(messagestr), "[DUEL]: %s (%d), %s (%d) and %s (%d) gained %d$ by winning in a duel against %s (%d), %s (%d) and %s (%d).", PlayerName(Team_B_1[duelid]), Team_B_1[duelid], PlayerName(Team_B_2[duelid]), Team_B_2[duelid], PlayerName(Team_B_3[duelid]), Team_B_3[duelid], Duel_Stake[duelid], PlayerName(Team_A_1[duelid]), Team_A_1[duelid], PlayerName(Team_A_2[duelid]), Team_A_2[duelid], PlayerName(Team_A_3[duelid]), Team_A_3[duelid]);
							MoneyLog(messagestr);
							
							format(messagestr,sizeof(messagestr), "[DUEL STAKE] You lost $%d!", GetPVarInt(playerid, "Duel_Stake"));
							SendClientMessage(Team_A_1[duelid], COLOR_NOTICE, messagestr);
							SendClientMessage(Team_A_2[duelid], COLOR_NOTICE, messagestr);
							SendClientMessage(Team_A_3[duelid], COLOR_NOTICE, messagestr);
							format(messagestr, sizeof(messagestr), "[DUEL]: %s (%d), %s (%d) and %s (%d) lost %d$ by losing in a duel against %s (%d), %s (%d) and %s (%d).", PlayerName(Team_A_1[duelid]), Team_A_1[duelid], PlayerName(Team_A_2[duelid]), Team_A_2[duelid], PlayerName(Team_A_3[duelid]), Team_A_3[duelid], Duel_Stake[duelid], PlayerName(Team_B_1[duelid]), Team_B_1[duelid], PlayerName(Team_B_2[duelid]), Team_B_2[duelid], PlayerName(Team_B_3[duelid]), Team_B_3[duelid]);
							MoneyLog(messagestr);
						}
						ResetDuel(duelid);
						
						return 1;
		            }
		            ToggleDuelSpectate(playerid, duelid);

				}
				if(playerid == Team_B_1[duelid] || playerid == Team_B_2[duelid] || playerid == Team_B_3[duelid]) // Someone of Team B died.
	   			{
		            Team_B_Amount[duelid] --;
	           		if(Team_B_Amount[duelid] == 0)
	           		{
						new rand = random(5);
						if(rand == 0) format(messagestr,sizeof(messagestr),"[DUEL: 3 VS 3] %s, %s and %s dropped %s, %s and %s like it's hot in a duel!", PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]), PlayerName(Team_A_3[duelid]),PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]),PlayerName(Team_B_3[duelid]));
						if(rand == 1) format(messagestr,sizeof(messagestr),"[DUEL: 3 VS 3] %s, %s and %s have just kicked %s, %s and %s's asses in a duel!", PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]), PlayerName(Team_A_3[duelid]),PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]),PlayerName(Team_B_3[duelid]));
						if(rand == 2) format(messagestr,sizeof(messagestr),"[DUEL: 3 VS 3] %s, %s and %s have just bested %s, %s and %s in a duel!", PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]), PlayerName(Team_A_3[duelid]),PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]),PlayerName(Team_B_3[duelid]));
						if(rand == 3) format(messagestr,sizeof(messagestr),"[DUEL: 3 VS 3] %s, %s and %s have just humiliated %s, %s and %s in a duel!", PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]), PlayerName(Team_A_3[duelid]),PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]),PlayerName(Team_B_3[duelid]));
						if(rand == 4) format(messagestr,sizeof(messagestr),"[DUEL: 3 VS 3] %s, %s and %s have just wrecked %s, %s and %s in a duel!", PlayerName(Team_A_1[duelid]), PlayerName(Team_A_2[duelid]), PlayerName(Team_A_3[duelid]),PlayerName(Team_B_1[duelid]), PlayerName(Team_B_2[duelid]),PlayerName(Team_B_3[duelid]));
 						SetPVarInt(Team_A_1[duelid], "PlayerStatus", 0);
                        SetPVarInt(Team_A_2[duelid], "PlayerStatus", 0);
                        SetPVarInt(Team_A_3[duelid], "PlayerStatus", 0);
                        SetPVarInt(Team_B_1[duelid], "PlayerStatus", 0);
                        SetPVarInt(Team_B_2[duelid], "PlayerStatus", 0);
                        SetPVarInt(Team_B_3[duelid], "PlayerStatus", 0);

						SendClientMessageToAll(COLOR_GREEN, messagestr);
	                    if(Duel_Stake[duelid] > 0)
						{
							format(messagestr,sizeof(messagestr), "[DUEL STAKE] You won $%d!", Duel_Stake[duelid]);
							SendClientMessage(Team_A_1[duelid], COLOR_NOTICE, messagestr);
							SendClientMessage(Team_A_2[duelid], COLOR_NOTICE, messagestr);
							SendClientMessage(Team_A_3[duelid], COLOR_NOTICE, messagestr);
							GivePlayerMoney(Team_A_1[duelid], Duel_Stake[duelid]);
							GivePlayerMoney(Team_A_2[duelid], Duel_Stake[duelid]);
							GivePlayerMoney(Team_A_3[duelid], Duel_Stake[duelid]);
							format(messagestr, sizeof(messagestr), "[DUEL]: %s (%d), %s (%d) and %s (%d) gained %d$ by winning in a duel against %s (%d), %s (%d) and %s (%d).", PlayerName(Team_A_1[duelid]), Team_A_1[duelid], PlayerName(Team_A_2[duelid]), Team_A_2[duelid], PlayerName(Team_A_3[duelid]), Team_A_3[duelid], Duel_Stake[duelid], PlayerName(Team_B_1[duelid]), Team_B_1[duelid], PlayerName(Team_B_2[duelid]), Team_B_2[duelid], PlayerName(Team_B_3[duelid]), Team_B_3[duelid]);
							MoneyLog(messagestr);

							format(messagestr,sizeof(messagestr), "[DUEL STAKE] You lost $%d!", GetPVarInt(playerid, "Duel_Stake"));
							SendClientMessage(Team_B_1[duelid], COLOR_NOTICE, messagestr);
							SendClientMessage(Team_B_2[duelid], COLOR_NOTICE, messagestr);
							SendClientMessage(Team_B_3[duelid], COLOR_NOTICE, messagestr);
							format(messagestr, sizeof(messagestr), "[DUEL]: %s (%d), %s (%d) and %s (%d) lost %d$ by losing in a duel against %s (%d), %s (%d) and %s (%d).", PlayerName(Team_B_1[duelid]), Team_B_1[duelid], PlayerName(Team_B_2[duelid]), Team_B_2[duelid], PlayerName(Team_B_3[duelid]), Team_B_3[duelid], Duel_Stake[duelid], PlayerName(Team_A_1[duelid]), Team_A_1[duelid], PlayerName(Team_A_2[duelid]), Team_A_2[duelid], PlayerName(Team_A_3[duelid]), Team_A_3[duelid]);
							MoneyLog(messagestr);
						}
						ResetDuel(duelid);
						
						return 1;

		            }
		            ToggleDuelSpectate(playerid, duelid);
				}

		    }

		}
    	return 1;

}

stock ToggleDuelSpectate(playerid, duelid)
{
    if(playerid == Team_B_1[duelid] || playerid == Team_B_2[duelid] || playerid == Team_B_3[duelid]) // Someone of Team B
    {
        TogglePlayerSpectating(playerid, 1);
        if(playerid != Team_B_1[duelid] && playerid != Team_B_2[duelid])
        {
        	if(GetPVarInt(Team_B_1[duelid], "Died_In_Duel") == 1)
         	{
        		PlayerSpectatePlayer(playerid, Team_B_2[duelid]);
        		SetPVarInt(Team_B_2[duelid], "Duel_Speccedby_ID", playerid+1);
         	}
         	else if(GetPVarInt(Team_B_2[duelid], "Died_In_Duel") == 1)
         	{
     	    	PlayerSpectatePlayer(playerid, Team_B_1[duelid]);
     	    	SetPVarInt(Team_B_1[duelid], "Duel_Speccedby_ID", playerid+1);
           	}
           	else
           	{
           	    PlayerSpectatePlayer(playerid, Team_B_1[duelid]);
           	    SetPVarInt(Team_B_1[duelid], "Duel_Speccedby_ID", playerid+1);
           	}

        }
		else if(playerid != Team_B_2[duelid] && playerid != Team_B_3[duelid])
  		{
   			if(GetPVarInt(Team_B_2[duelid], "Died_In_Duel") == 1)
     		{
     			PlayerSpectatePlayer(playerid, Team_B_3[duelid]);
      			SetPVarInt(Team_B_3[duelid], "Duel_Speccedby_ID", playerid+1);
        	}
         
       		else if(GetPVarInt(Team_B_3[duelid], "Died_In_Duel") == 1)
           	{
       	    	PlayerSpectatePlayer(playerid, Team_B_2[duelid]);
        	    SetPVarInt(Team_B_2[duelid], "Duel_Speccedby_ID", playerid+1);
           	}
           	else
           	{
           	    PlayerSpectatePlayer(playerid, Team_B_2[duelid]);
      			SetPVarInt(Team_B_2[duelid], "Duel_Speccedby_ID", playerid+1);
           	}
        }
		else if(playerid != Team_B_1[duelid] && playerid != Team_B_3[duelid])
		{
			if(GetPVarInt(Team_B_1[duelid], "Died_In_Duel") == 1)
 			{
 				PlayerSpectatePlayer(playerid, Team_B_3[duelid]);
  				SetPVarInt(Team_B_3[duelid], "Duel_Speccedby_ID", playerid+1);
     		}
      		else if(GetPVarInt(Team_B_3[duelid], "Died_In_Duel") == 1)
       		{
   	    		PlayerSpectatePlayer(playerid, Team_B_1[duelid]);
    	    	SetPVarInt(Team_B_1[duelid], "Duel_Speccedby_ID", playerid+1);
         	}
         	else
         	{
         	    PlayerSpectatePlayer(playerid, Team_B_1[duelid]);
  				SetPVarInt(Team_B_1[duelid], "Duel_Speccedby_ID", playerid+1);
         	}
		}
    }
    if(playerid == Team_A_1[duelid] || playerid == Team_A_2[duelid] || playerid == Team_A_3[duelid]) // Someone of Team A
    {
        TogglePlayerSpectating(playerid, 1);
        if(playerid != Team_A_1[duelid] && playerid != Team_A_2[duelid])
        {
        	if(GetPVarInt(Team_A_1[duelid], "Died_In_Duel") == 1)
         	{
        		PlayerSpectatePlayer(playerid, Team_A_2[duelid]);
        		SetPVarInt(Team_A_2[duelid], "Duel_Speccedby_ID", playerid+1);
         	}
         	else if(GetPVarInt(Team_A_2[duelid], "Died_In_Duel") == 1)
         	{
     	    	PlayerSpectatePlayer(playerid, Team_A_1[duelid]);
      	    	SetPVarInt(Team_A_1[duelid], "Duel_Speccedby_ID", playerid+1);
           	}
           	else
           	{
           	    PlayerSpectatePlayer(playerid, Team_A_1[duelid]);
        		SetPVarInt(Team_A_1[duelid], "Duel_Speccedby_ID", playerid+1);
           	}
        }
		else if(playerid != Team_A_2[duelid] && playerid != Team_A_3[duelid])
  		{
   			if(GetPVarInt(Team_A_2[duelid], "Died_In_Duel") == 1)
     		{
     			PlayerSpectatePlayer(playerid, Team_A_3[duelid]);
      			SetPVarInt(Team_A_3[duelid], "Duel_Speccedby_ID", playerid+1);
        	}

       		else if(GetPVarInt(Team_A_3[duelid], "Died_In_Duel") == 1)
           	{
       	    	PlayerSpectatePlayer(playerid, Team_A_2[duelid]);
        	    SetPVarInt(Team_A_2[duelid], "Duel_Speccedby_ID", playerid+1);
           	}
           	else
           	{
           	    PlayerSpectatePlayer(playerid, Team_A_2[duelid]);
        		SetPVarInt(Team_A_2[duelid], "Duel_Speccedby_ID", playerid+1);
           	}
        }
		else if(playerid != Team_A_1[duelid] && playerid != Team_A_3[duelid])
		{
			if(GetPVarInt(Team_A_1[duelid], "Died_In_Duel") == 1)
 			{
 				PlayerSpectatePlayer(playerid, Team_A_3[duelid]);
  				SetPVarInt(Team_A_3[duelid], "Duel_Speccedby_ID", playerid+1);
     		}
      		else if(GetPVarInt(Team_A_3[duelid], "Died_In_Duel") == 1)
       		{
   	    		PlayerSpectatePlayer(playerid, Team_A_1[duelid]);
    	    	SetPVarInt(Team_A_1[duelid], "Duel_Speccedby_ID", playerid+1);
         	}
         	else
           	{
           	    PlayerSpectatePlayer(playerid, Team_A_1[duelid]);
        		SetPVarInt(Team_A_1[duelid], "Duel_Speccedby_ID", playerid+1);
           	}
		}
    }

}

forward RespawnAfterDuel(playerid);
public RespawnAfterDuel(playerid)
{
    SpawnPlayer(playerid);
    SetPlayerSkin(playerid, GetPVarInt(playerid, "SkinBeforeDuel"));

    return 1;
}


stock ResetDuel(duelid)
{
    Team_A_Amount[duelid] = 0;
    Team_B_Amount[duelid] = 0;
    
    SetPVarInt(Team_A_1[duelid], "Amount_Accepted", 0);
    SetPVarInt(Team_A_1[duelid], "Duel_Requester", 0);
    SetPVarInt(Team_A_1[duelid], "Duel_ID", 0);
    SetPVarInt(Team_A_2[duelid], "Duel_ID", 0);
    SetPVarInt(Team_A_3[duelid], "Duel_ID", 0);
    
    SetPVarInt(Team_B_1[duelid], "Duel_ID", 0);
    SetPVarInt(Team_B_2[duelid], "Duel_ID", 0);
    SetPVarInt(Team_B_3[duelid], "Duel_ID", 0);
    SetPVarInt(Team_A_1[duelid], "Duel_Speccedby_ID", 0);
    SetPVarInt(Team_A_2[duelid], "Duel_Speccedby_ID", 0);
    SetPVarInt(Team_A_3[duelid], "Duel_Speccedby_ID", 0);
    SetPVarInt(Team_B_1[duelid], "Duel_Speccedby_ID", 0);
    SetPVarInt(Team_B_2[duelid], "Duel_Speccedby_ID", 0);
    SetPVarInt(Team_B_3[duelid], "Duel_Speccedby_ID", 0);


    if(Duel_Type[duelid] == 1)
	{
	    //SetPVarInt(Team_A_1[duelid], "Duel_1v1_Opponent_ID", 0);

	    SetPVarInt(Team_A_1[duelid], "PlayerStatus", 0);
	    SetTimerEx("RespawnAfterDuel", 4000, false, "d", Team_A_1[duelid]);

	    SetPlayerHealth(Team_A_1[duelid], 99);
	    
	    SetTimerEx("RespawnAfterDuel", 4000, false, "d", Team_B_1[duelid]);
	    SetPVarInt(Team_B_1[duelid], "PlayerStatus", 0);

	    SetPlayerHealth(Team_B_1[duelid], 99);

    	SetPVarInt(Team_A_1[duelid], "Accepted_Duel_Request", 0);
    	SetPVarInt(Team_B_1[duelid], "Accepted_Duel_Request", 0);

    	SetPlayerArmour(Team_A_1[duelid], 0);
    	SetPlayerArmour(Team_B_1[duelid], 0);
    	
    	SetPVarInt(Team_B_1[duelid], "Duel_Type", 0);


	}
	else if(Duel_Type[duelid] == 2)
	{
	    SetPlayerArmour(Team_A_1[duelid], 0);
    	SetPlayerArmour(Team_A_2[duelid], 0);
    
	    TogglePlayerSpectating(Team_A_1[duelid], 0);
	    TogglePlayerSpectating(Team_A_2[duelid], 0);
	    TogglePlayerSpectating(Team_B_1[duelid], 0);
	    TogglePlayerSpectating(Team_B_2[duelid], 0);
	    
	    //SetPVarInt(Team_A_1[duelid], "Duel_2v2_Teammate_ID", 0);
	   // SetPVarInt(Team_A_1[duelid], "Duel_2v2_Enemy1_ID", 0);
	    //SetPVarInt(Team_A_1[duelid], "Duel_2v2_Enemy2_ID", 0);
	    //SetPVarInt(Team_A_1[duelid], "Duel_2v2_Enemy3_ID", 0);
	    SetPVarInt(Team_A_1[duelid], "Amount_Accepted", 0);
	    SetTimerEx("RespawnAfterDuel", 4000, false, "d", Team_A_1[duelid]);
	    SetPlayerHealth(Team_A_1[duelid], 100);
	    SetPVarInt(Team_A_1[duelid], "PlayerStatus", 0);
	    //SetPlayerInterior(Team_A_1[duelid], 0);
	    SetTimerEx("RespawnAfterDuel", 4100, false, "d", Team_A_2[duelid]);
	    SetPlayerHealth(Team_A_2[duelid], 100);
	    SetPVarInt(Team_A_2[duelid], "PlayerStatus", 0);
	    //SetPlayerInterior(Team_A_2[duelid], 0);
	    SetTimerEx("RespawnAfterDuel", 4200, false, "d", Team_B_1[duelid]);
	    SetPlayerHealth(Team_B_1[duelid], 100);
	    SetPVarInt(Team_B_1[duelid], "PlayerStatus", 0);
	    //SetPlayerInterior(Team_B_1[duelid], 0);
	    SetTimerEx("RespawnAfterDuel", 4300, false, "d", Team_B_2[duelid]);
	    SetPlayerHealth(Team_B_2[duelid], 100);
	    SetPVarInt(Team_B_2[duelid], "PlayerStatus", 0);
	    //SetPlayerInterior(Team_B_2[duelid], 0);
	    SetPVarInt(Team_A_1[duelid], "Accepted_Duel_Request", 0);
    	SetPVarInt(Team_B_1[duelid], "Accepted_Duel_Request", 0);
    	SetPVarInt(Team_A_2[duelid], "Accepted_Duel_Request", 0);
    	SetPVarInt(Team_B_2[duelid], "Accepted_Duel_Request", 0);
    	
    	
    	SetPVarInt(Team_A_2[duelid], "Duel_Type", 0);
    	SetPVarInt(Team_B_1[duelid], "Duel_Type", 0);
    	SetPVarInt(Team_B_2[duelid], "Duel_Type", 0);

	}
	else if(Duel_Type[duelid] == 3)
	{
	
		SetPVarInt(Team_A_1[duelid], "Duel_Type", 0);
    	/*SetPVarInt(Team_B_1[duelid], "Duel_Type", 0);
    	SetPVarInt(Team_A_2[duelid], "Duel_Type", 0);
    	SetPVarInt(Team_B_2[duelid], "Duel_Type", 0);
    	SetPVarInt(Team_A_3[duelid], "Duel_Type", 0);
    	SetPVarInt(Team_B_3[duelid], "Duel_Type", 0);*/
    	
	    TogglePlayerSpectating(Team_A_1[duelid], 0);
	    TogglePlayerSpectating(Team_A_2[duelid], 0);
	    TogglePlayerSpectating(Team_A_3[duelid], 0);
	    TogglePlayerSpectating(Team_B_1[duelid], 0);
	    TogglePlayerSpectating(Team_B_2[duelid], 0);
	    TogglePlayerSpectating(Team_B_3[duelid], 0);
	    
	    //SetPVarInt(Team_A_1[duelid], "Duel_3v3_Teammate1_ID", 0);
	    //SetPVarInt(Team_A_1[duelid], "Duel_3v3_Teammate2_ID", 0);
	    //SetPVarInt(Team_A_1[duelid], "Duel_3v3_Enemy1_ID", 0);
	    //SetPVarInt(Team_A_1[duelid], "Duel_3v3_Enemy2_ID", 0);
	    //SetPVarInt(Team_A_1[duelid], "Duel_3v3_Enemy3_ID", 0);
	    
	    SetPVarInt(Team_A_1[duelid], "Amount_Accepted", 0);
	    SetTimerEx("RespawnAfterDuel", 2000, false, "d", Team_A_1[duelid]);
	    //SetPlayerSkin(Team_A_1[duelid], GetPVarInt(Team_A_1[duelid], "SkinBeforeDuel"));
	    SetPlayerHealth(Team_A_1[duelid], 100);
	    SetPVarInt(Team_A_1[duelid], "PlayerStatus", 0);
	    //SetPlayerInterior(Team_A_1[duelid], 0);
	    SetTimerEx("RespawnAfterDuel", 4000, false, "d", Team_A_2[duelid]);
	    SetPlayerHealth(Team_A_2[duelid], 100);
	    SetPVarInt(Team_A_2[duelid], "PlayerStatus", 0);
	    //SetPlayerInterior(Team_A_2[duelid], 0);
	    SetTimerEx("RespawnAfterDuel", 4100, false, "d", Team_A_3[duelid]);
	    SetPlayerHealth(Team_A_3[duelid], 100);
	    SetPVarInt(Team_A_3[duelid], "PlayerStatus", 0);
	    //SetPlayerInterior(Team_A_3[duelid], 0);
	    SetTimerEx("RespawnAfterDuel", 4200, false, "d", Team_B_1[duelid]);
	    SetPlayerHealth(Team_B_1[duelid], 100);
	    SetPVarInt(Team_B_1[duelid], "PlayerStatus", 0);
	    //SetPlayerInterior(Team_B_1[duelid], 0);
	    SetTimerEx("RespawnAfterDuel", 4300, false, "d", Team_B_2[duelid]);
	    SetPlayerHealth(Team_B_2[duelid], 100);
	    SetPVarInt(Team_B_2[duelid], "PlayerStatus", 0);
	    //SetPlayerInterior(Team_B_2[duelid], 0);
	    SetTimerEx("RespawnAfterDuel", 4400, false, "d", Team_B_3[duelid]);
	    SetPlayerHealth(Team_B_3[duelid], 100);
	    SetPVarInt(Team_B_3[duelid], "PlayerStatus", 0);
	    //SetPlayerInterior(Team_B_3[duelid], 0);
	    
	    SetPVarInt(Team_A_1[duelid], "Accepted_Duel_Request", 0);
    	SetPVarInt(Team_B_1[duelid], "Accepted_Duel_Request", 0);
    	SetPVarInt(Team_A_2[duelid], "Accepted_Duel_Request", 0);
    	SetPVarInt(Team_B_2[duelid], "Accepted_Duel_Request", 0);
    	SetPVarInt(Team_A_3[duelid], "Accepted_Duel_Request", 0);
    	SetPVarInt(Team_B_3[duelid], "Accepted_Duel_Request", 0);
    	
    	SetPVarInt(Team_A_1[duelid], "Died_In_Duel", 0);
    	SetPVarInt(Team_A_2[duelid], "Died_In_Duel", 0);
    	SetPVarInt(Team_A_3[duelid], "Died_In_Duel", 0);
    	SetPVarInt(Team_B_1[duelid], "Died_In_Duel", 0);
    	SetPVarInt(Team_B_2[duelid], "Died_In_Duel", 0);
    	SetPVarInt(Team_B_3[duelid], "Died_In_Duel", 0);
    	
    	SetPVarInt(Team_A_2[duelid], "Duel_Type", 0);
    	SetPVarInt(Team_A_3[duelid], "Duel_Type", 0);
    	SetPVarInt(Team_B_1[duelid], "Duel_Type", 0);
    	SetPVarInt(Team_B_2[duelid], "Duel_Type", 0);
    	SetPVarInt(Team_B_3[duelid], "Duel_Type", 0);

	}
	Team_A_1[duelid] = 0;
	Team_A_2[duelid] = 0;
	Team_A_3[duelid] = 0;
	Team_B_1[duelid] = 0;
	Team_B_2[duelid] = 0;
	Team_B_3[duelid] = 0;
	

}
stock WeaponName(weaponid)
{
    new gunname[32];
	if(weaponid == 0)
	{
	    format(gunname,32,"None");
	    return gunname;
	}
    GetWeaponName(weaponid,gunname,sizeof(gunname));
    return gunname;
}

