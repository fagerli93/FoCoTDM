#include <YSI\y_hooks>

#define DUEL_RESPAWN_TIME 3000
#define DUEL_EXPIRE_TIME 15000
#define DUEL_START_TIME 10000
#define ACMD_DUEL_FORCE_END 3
#define MIN_DUEL_STAKE 1000
#define MAX_DUEL_STAKE 500000
#define MAX_LOCATIONS 19
#define DUEL_CMESSAGE 5
#define DIALOG_DUEL_SETTINGS 550
#define COLOR_DUEL COLOR_GREEN

#define DUEL_YN ("{00CD00}Yes") : ("{CD0000}No")
#define DUEL_YN2 ("Yes") : ("No")

enum //To be used for pd_duelstatus.
{
	DUEL_NONE,
	DUEL_REQUESTED,
	DUEL_ALLACCEPTED,
	DUEL_STARTPENDING,
	DUEL_STARTED
}

enum duelpset
{
	pd_type,
	bool:pd_armour,
	bool:pd_cjrun,
	pd_location,
	pd_weap1,
	pd_weap2,
	pd_stake,
	pd_partners[3], //Including playerid - To do things in a loop
	pd_opponents[3],
	pd_accptcnt,
	pd_duelstatus
}

//For saving whose settings his request is on..
new DuelCurrent_Set[MAX_PLAYERS char];
new pDuelState[MAX_PLAYERS char]; //./duel state of player..
new bool:pDuelAccept[MAX_PLAYERS];
new pDuelSettings[MAX_PLAYERS][duelpset];
new Duel_MSG[1400];
new Timer:duel_expire[MAX_PLAYERS];
new Timer:duel_start[MAX_PLAYERS];
new bool:DuelPlayerDead[MAX_PLAYERS];
new InDuelPlayerSettings[MAX_PLAYERS][2][4];

//Duel Location Informations
new Duel_Location_Names[MAX_LOCATIONS][30]=
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
    {"LV PD"},
	{"Area51"},
	{"BaseBall Stadium"}

}; //NAME
new Duel_Location_Det[MAX_LOCATIONS]=
{
	0,	//LV Rooftop 1
	0,	//LV Rooftop 2
	0,	//LS Rooftop 1
	0,	//Commerce
	0,	//Ghost Town
	10,	//RC Battleground
	15,	//Bloodbowl
	0,	//Paradiso Alleyway
	1,	//Meat Factory
	17,	//24/7 Store
	0,	//Willowfield
	0,	//Underground Garage
	0,	//Blueberry Acres
	0,	//SF Bridge
	3,	//Pleasure Domes
	15,	//Jefferson Motel
	3,	//LV PD
	0,
	0
}; //InteriorID
new Float:Duel_Location_Side1[MAX_LOCATIONS][4]=
{
	{2343.1631,1743.4652,20.6406,269.4825},//LV Rooftop 1
	{2644.2043,1230.3147,26.9182,179.7432},//LV Rooftop 2
	{1804.6559,-1748.0149,52.4688,134.5653},//LS Rooftop 1
	{1547.7194,-1545.7653,13.5462,87.1496},//Commerce
	{-409.3706,2279.7800,41.6843,190.6757},//Ghost Town
	{-973.1579,1077.3397,1344.9962,91.2873},//RC Battleground
	{-1340.7584,996.0392,1024.4777,87.6985},//Bloodbowl
	{-2463.7961,-100.2530,25.8606,181.4922},//Paradiso Alleyway
	{949.7968,2110.9451,1011.0303,88.9832},//Meat Factory
	{-32.7721,-185.3738,1003.5469,271.5138},//24/7 Store
	{2343.0413,-2059.8743,21.2425,222.5102},//Willowfield
	{2337.1626,-1229.0807,22.5000,179.0879},//Underground Garage
	{-37.4746,110.2308,3.1172,162.7083},//Blueberry Acres
	{-1377.9521,660.5207,3.0703,38.0527},//SF Bridge
	{-2637.3286,1406.1171,906.4609,87.1056},//Pleasure Domes
	{2221.2847,-1148.3781,1025.7969,1.2538},//Jefferson Motel
	{297.9829,174.2594,1007.1719,84.9071},//LV PD
	{240.78780, 1872.66956, 11.45940, 268.07997},//Area51
	{1300.27673, 2211.14941, 12.07717, 270.06000}//BasebalLStadium
}; //X1, Y1, Z1, F1

new Float:Duel_Location_Side2[MAX_LOCATIONS][4]=
{
	{2407.6045,1742.8296,20.6406,89.4628},//LV Rooftop 1
	{2645.2397,1191.5135,26.9182,358.5536},//LV Rooftop 2
	{1753.0408,-1800.4835,52.4688,315.3810},//LS Rooftop 1
	{1459.2037,-1548.6002,13.5469,270.9294},//Commerce
	{-386.3154,2173.0061,42.4766,9.5696},//Ghost Town
	{-1132.0181,1041.7253,1345.7401,267.6307},//RC Battleground
	{-1438.3345,995.3775,1024.1788,269.8948},//Bloodbowl
	{-2482.5520,-179.4104,25.6172,0.3026},//Paradiso Alleyway
	{953.8614,2161.1318,1011.0234,90.9050},//Meat Factory
	{-5.4394,-173.5894,1003.5469,91.5677},//24/7 Store
	{2375.3474,-2092.1157,21.2425,43.9107},//Willowfield
	{2337.8313,-1260.5941,22.5076,359.3187},//Underground Garage
	{-115.9792,-124.7456,3.1172,346.2477},//Blueberry Acres
	{-1392.1119,679.9294,3.0703,215.5435},//SF Bridge
	{-2675.4592,1420.9623,906.4647,271.7782},//Pleasure Domes
	{2193.4644,-1144.5282,1029.7969,181.7543},//Jefferson Motel
	{206.6256,168.1700,1003.0234,271.2097},//LV PD
	{275.52579, 1865.92383, 8.80556, -358.73990},//Area51
	{1410.18250, 2123.46240, 12.01770, -355.32001}//BasebalLStadium
}; //X2, Y2, Z2, F2

new DuelSpectate[MAX_PLAYERS char];
////////////////////////////////////////////////////////////////////////////////
new Duel_PMessage[DUEL_CMESSAGE][205] =
{
	{"[DUEL: %i VS %i] %s dropped %s like it's hot in a duel!"},
	{"[DUEL: %i VS %i] %s has just kicked %s's ass in a duel!"},
	{"[DUEL: %i VS %i] %s has just bested %s in a duel!"},
	{"[DUEL: %i VS %i] %s has just humiliated %s in a duel!"},
	{"[DUEL: %i VS %i] %s has just wrecked %s in a duel!"}
};

///////////////////////////////////USEFUL STOCKS////////////////////////////////
stock D_WeaponName(weaponid)
{
	new wname[32];
	if(weaponid == 0)
	{
	    wname = "Fist";
	}
	else
	{
	    GetWeaponName(weaponid, wname, sizeof(wname));
	}
	return wname;
	
}

stock D_PlayerName(playerid)
{
	new pname[24];
	if(playerid == INVALID_PLAYER_ID || playerid == MAX_PLAYERS || !IsPlayerConnected(playerid))
	{
	    pname = "UNKNOWN_PLAYER";
	}
	else
	{
	    GetPlayerName(playerid, pname, sizeof(pname));
	}
 	return pname;
}

stock CheckDuelReqPending(playerid)
{
	print("Duel Req Pending");
	for(new i = 0; i < pDuelSettings[playerid][pd_type]; i++)
	{
	    if(DuelCurrent_Set{pDuelSettings[playerid][pd_partners][i]} != MAX_PLAYERS || DuelCurrent_Set{pDuelSettings[playerid][pd_opponents][i]} != MAX_PLAYERS )
		{
			format(Duel_MSG, sizeof(Duel_MSG), "[LeaveDuel]: PID: %i || LID: %i || MP: %i", DuelCurrent_Set{pDuelSettings[playerid][pd_partners][i]}, DuelCurrent_Set{pDuelSettings[playerid][pd_opponents][i]}, MAX_PLAYERS);
			print(Duel_MSG);
			return 0;
		}
	}
	return 1;
}

stock IsAllPlayersConnected(playerid)
{
	 for(new i = 0; i < pDuelSettings[playerid][pd_type]; i++)
	 {
	    if(!IsPlayerConnected(pDuelSettings[playerid][pd_partners][i]))
		{
		    pDuelSettings[playerid][pd_partners][i] = MAX_PLAYERS;
			return 0;
		}
		else if(!IsPlayerConnected(pDuelSettings[playerid][pd_opponents][i]))
		{
		    pDuelSettings[playerid][pd_partners][i] = MAX_PLAYERS;
			return 0;
		}
	 }
	 return 1;
}

stock ToggleDuelSpectate(duelid, playerid)
{
	new teamid = GetPVarInt(playerid , "DuelTeamID");
	TogglePlayerSpectating(playerid, 1);
	new bool:flag;
	for(new i = 0; i < pDuelSettings[duelid][pd_type]; i++)
	{
		if(InDuelPlayerSettings[duelid][teamid][i] != playerid && DuelPlayerDead[InDuelPlayerSettings[duelid][teamid][i]] == false)
		{
			PlayerSpectatePlayer(playerid, InDuelPlayerSettings[duelid][teamid][i]);
			DuelSpectate{playerid} = InDuelPlayerSettings[duelid][teamid][i];
			flag = true;
			break;
		}
	}
	if(flag == false)
	{
	    GameTextForPlayer(playerid, "~w~No ~r~alive ~w~TeamMate to Spectate.~n~~b~You will be respawned soon.", 1999, 6);
		defer RespawnAfterSpectating[2000](playerid);
	}
	return 1;
}
/////////////////////////////////END OF USEFUL STOCKS///////////////////////////

/////////////////////////////////TIMERS/////////////////////////////////////////
timer DelaySpawnPlayer[1000](playerid)
{
	SpawnPlayer(playerid);
}
timer RespawnAfterSpectating[7000](playerid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
	    TogglePlayerSpectating(playerid, 0);
	    GameTextForPlayer(playerid, "~w~Successfully re-spawned.", 2000, 4);
	}
}

timer Duel_TimerExpire[DUEL_EXPIRE_TIME](playerid)
{
	for(new i = 0; i < pDuelSettings[playerid][pd_type]; i++)
	{
	    SendClientMessage(pDuelSettings[playerid][pd_partners][i], COLOR_NOTICE, "[DUEL NOTICE]: Duel request has expired.");
		SendClientMessage(pDuelSettings[playerid][pd_opponents][i], COLOR_NOTICE, "[DUEL NOTICE]: Duel request has expired.");
		//Partners
        DuelCurrent_Set{pDuelSettings[playerid][pd_partners][i]} = MAX_PLAYERS;
        DuelCurrent_Set{pDuelSettings[playerid][pd_opponents][i]} = MAX_PLAYERS;
        //State
        pDuelState{pDuelSettings[playerid][pd_partners][i]} = DUEL_NONE;
        pDuelState{pDuelSettings[playerid][pd_opponents][i]} = DUEL_NONE;
	}
	pDuelSettings[playerid][pd_duelstatus] = DUEL_NONE;
}

timer SetBackDuelVariables[1000](playerid)
{
	DebugMsg("SettingBackDuelVariables");
	for(new i = 0; i < pDuelSettings[playerid][pd_type]; i++)
	{
	    if(pDuelSettings[playerid][pd_opponents][i] != MAX_PLAYERS)
	    {
			if(GetPlayerState(pDuelSettings[playerid][pd_opponents][i]) == PLAYER_STATE_SPECTATING || DuelPlayerDead[pDuelSettings[playerid][pd_opponents][i]] == true)
			{
			    print("ToggleSpecOpp");
				defer RespawnAfterSpectating[2000](pDuelSettings[playerid][pd_opponents][i]);
			}
			else if(DuelPlayerDead[pDuelSettings[playerid][pd_opponents][i]] == false)
			{
			    print("SpawnOp");
			    defer DelaySpawnPlayer(pDuelSettings[playerid][pd_opponents][i]);
			}
		}
		if(pDuelSettings[playerid][pd_opponents][i] != MAX_PLAYERS)
	    {
			if(GetPlayerState(pDuelSettings[playerid][pd_partners][i]) == PLAYER_STATE_SPECTATING && DuelPlayerDead[pDuelSettings[playerid][pd_partners][i]] == true)
			{
			    print("TogglePart");
				defer RespawnAfterSpectating[2000](pDuelSettings[playerid][pd_partners][i]);
			}
			else if(DuelPlayerDead[pDuelSettings[playerid][pd_partners][i]] == false)
			{
			    print("SpawnOpp");
			    defer DelaySpawnPlayer(pDuelSettings[playerid][pd_partners][i]);
			}
		}
		DebugMsg("SettingBackDuelVariables2");
		SetPVarInt(pDuelSettings[playerid][pd_partners][i], "PlayerStatus", 0);
		SetPVarInt(pDuelSettings[playerid][pd_opponents][i], "PlayerStatus", 0);
		pDuelState{pDuelSettings[playerid][pd_partners][i]} = DUEL_NONE;
		pDuelState{pDuelSettings[playerid][pd_opponents][i]}  = DUEL_NONE;
		DuelCurrent_Set{pDuelSettings[playerid][pd_partners][i]} = MAX_PLAYERS;
		DuelCurrent_Set{pDuelSettings[playerid][pd_opponents][i]} = MAX_PLAYERS;
		pDuelAccept[pDuelSettings[playerid][pd_partners][i]] = false;
		pDuelAccept[pDuelSettings[playerid][pd_opponents][i]] = false;
		DuelPlayerDead[pDuelSettings[playerid][pd_partners][i]] = false;
		DuelPlayerDead[pDuelSettings[playerid][pd_opponents][i]] = false;
		InDuelPlayerSettings[playerid][0][i] = MAX_PLAYERS;
		InDuelPlayerSettings[playerid][1][i] = MAX_PLAYERS;
	}
	pDuelState{playerid} = DUEL_NONE; //./duel state of player..
	InDuelPlayerSettings[playerid][0][3] = 3;
	InDuelPlayerSettings[playerid][1][3] = 3;
	return 1;
}

timer DuelBegin[DUEL_START_TIME](playerid)
{
    print("DuelBegin");
    for(new i = 0; i < pDuelSettings[playerid][pd_type]; i++)
	{
	    ResetPlayerWeapons(pDuelSettings[playerid][pd_partners][i]);
	    ResetPlayerWeapons(pDuelSettings[playerid][pd_opponents][i]);
		TogglePlayerControllable(pDuelSettings[playerid][pd_partners][i], 1);
		TogglePlayerControllable(pDuelSettings[playerid][pd_opponents][i], 1);
		DuelPlayerDead[pDuelSettings[playerid][pd_partners][i]] = false;
		DuelPlayerDead[pDuelSettings[playerid][pd_opponents][i]] = false;
		GivePlayerWeapon(pDuelSettings[playerid][pd_partners][i], pDuelSettings[playerid][pd_weap1], 5000);
        GivePlayerWeapon(pDuelSettings[playerid][pd_partners][i], pDuelSettings[playerid][pd_weap2], 5000);
		GivePlayerWeapon(pDuelSettings[playerid][pd_opponents][i], pDuelSettings[playerid][pd_weap1], 5000);
        GivePlayerWeapon(pDuelSettings[playerid][pd_opponents][i], pDuelSettings[playerid][pd_weap2], 5000);
        pDuelState{pDuelSettings[playerid][pd_partners][i]} = DUEL_STARTED;
        pDuelState{pDuelSettings[playerid][pd_opponents][i]} = DUEL_STARTED;
        if(pDuelSettings[playerid][pd_armour] == true)
        {
			SetPlayerHealth(pDuelSettings[playerid][pd_partners][i], 99.0);
			SetPlayerArmour(pDuelSettings[playerid][pd_partners][i], 99.0);
			SetPlayerHealth(pDuelSettings[playerid][pd_opponents][i], 99.0);
			SetPlayerArmour(pDuelSettings[playerid][pd_opponents][i], 99.0);
        }
        else
        {
			SetPlayerHealth(pDuelSettings[playerid][pd_partners][i], 99.0);
			SetPlayerArmour(pDuelSettings[playerid][pd_partners][i], 0.0);
			SetPlayerHealth(pDuelSettings[playerid][pd_opponents][i], 99.0);
			SetPlayerArmour(pDuelSettings[playerid][pd_opponents][i], 0.0);
        }
        if(pDuelSettings[playerid][pd_cjrun] == true)
        {
            SetPVarInt(playerid, "SkinBeforeDuel", GetPlayerSkin(pDuelSettings[playerid][pd_partners][i]));
			SetPlayerSkin(pDuelSettings[playerid][pd_partners][i], 0);
			SetPVarInt(playerid, "SkinBeforeDuel", GetPlayerSkin(pDuelSettings[playerid][pd_opponents][i]));
			SetPlayerSkin(pDuelSettings[playerid][pd_opponents][i], 0);
        }
        else
        {
            SetPVarInt(playerid, "SkinBeforeDuel", GetPlayerSkin(pDuelSettings[playerid][pd_partners][i]));
			SetPlayerSkin(pDuelSettings[playerid][pd_partners][i], 137);
			SetPVarInt(playerid, "SkinBeforeDuel", GetPlayerSkin(pDuelSettings[playerid][pd_opponents][i]));
			SetPlayerSkin(pDuelSettings[playerid][pd_opponents][i], 32);
        }
	}
	pDuelSettings[playerid][pd_duelstatus] = DUEL_STARTED;
    print("DuelBeginOver");
}
///////////////////////////////End of Timers////////////////////////////////////

/////////////////////////Required Stocks for Duel System////////////////////////
stock CheckDuelSettings(playerid, type)
{
	new flag;
	if(type == 1)
	{
		for(new i = 0; i < pDuelSettings[playerid][pd_type]; i++)
		{
		    if(flag == 0)
		    {
				if(pDuelSettings[playerid][pd_opponents][i] == INVALID_PLAYER_ID || !IsPlayerConnected(pDuelSettings[playerid][pd_opponents][i]) || pDuelSettings[playerid][pd_opponents][i] == MAX_PLAYERS)
				{
				    flag = 1;
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: One of the playerid/name is invalid. Please edit settings.");
					break;
				}
				if(pDuelSettings[playerid][pd_partners][i] == INVALID_PLAYER_ID || !IsPlayerConnected(pDuelSettings[playerid][pd_partners][i]) || pDuelSettings[playerid][pd_opponents][i] == MAX_PLAYERS)
				{
				    flag = 1;
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: One of the playerid/name is invalid. Please edit settings.");
                    break;
				}
				if((pDuelSettings[playerid][pd_stake] > GetPlayerMoney(pDuelSettings[playerid][pd_partners][i]) || pDuelSettings[playerid][pd_stake] > GetPlayerMoney(pDuelSettings[playerid][pd_opponents][i])) && pDuelSettings[playerid][pd_stake] != 0)
				{
					flag = 1;
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: One of the player(s) doesn't have enough money. Please change him/reduce stake.");
                    break;
				}
				if(FoCo_Player[pDuelSettings[playerid][pd_partners][i]][jailed] > 0 || FoCo_Player[pDuelSettings[playerid][pd_opponents][i]][jailed] > 0)
				{
				    flag = 1;
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: One of the player(s) is already is in Jail. Please wait.");
                    break;
				}
				if(GetPVarInt(pDuelSettings[playerid][pd_partners][i], "PlayerStatus") == 2 || GetPVarInt(pDuelSettings[playerid][pd_opponents][i], "PlayerStatus") == 2)
				{
				    flag = 1;
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: One of the player(s) is already in a duel. Please wait.");
                    break;
				}
				if(GetPVarInt(pDuelSettings[playerid][pd_partners][i], "InEvent") == 1 || GetPVarInt(pDuelSettings[playerid][pd_opponents][i], "InEvent") == 1)
				{
				    flag = 1;
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: One of the player(s) is in event. Please wait.");
                    break;
				}
			}
		}
	}
	if(flag)
	    return 0;
	//Checking for Equal IDs || Part 1.
	for(new i = 0; i < pDuelSettings[playerid][pd_type]; i++)
	{
 		if(pDuelSettings[playerid][pd_partners][i] == INVALID_PLAYER_ID || pDuelSettings[playerid][pd_partners][i] == MAX_PLAYERS)
	    {
	    	flag = 1;
	        break;
      	}
      	if(pDuelSettings[playerid][pd_opponents][i] == INVALID_PLAYER_ID || pDuelSettings[playerid][pd_opponents][i] == MAX_PLAYERS)
	    {
	    	flag = 1;
	        break;
      	}
	    for(new j = 0; j < pDuelSettings[playerid][pd_type]; j++)
	    {
	        if(pDuelSettings[playerid][pd_partners][i] == pDuelSettings[playerid][pd_partners][j] && i != j)
			{
			    flag = 1;
			    break;
			}
			if(pDuelSettings[playerid][pd_partners][i] == pDuelSettings[playerid][pd_opponents][j])
			{
			    flag = 1;
			    break;
			}
	        if(pDuelSettings[playerid][pd_opponents][i] == pDuelSettings[playerid][pd_opponents][j]  && i != j)
			{
			    flag = 1;
			    break;
			}
			if(pDuelSettings[playerid][pd_partners][j] == pDuelSettings[playerid][pd_opponents][i])
			{
			    flag = 1;
			    break;
			}
	    }
	}
	if(flag)
	    return 0;
	return 1;
}

stock Duel_ShowCurrentSettings(playerid)
{
	if(pDuelState{playerid} != DUEL_NONE)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't edit duel now.");
	}
	pDuelState{playerid} = 0;
	if(pDuelSettings[playerid][pd_type] == 0)
	    pDuelSettings[playerid][pd_type] = 1;
	Duel_MSG = "{D78E10}Setting\t{D78E10}Value\n";
	/*Type*/
	format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Duel Type:\t{00ff00}%s\n", Duel_MSG, (pDuelSettings[playerid][pd_type]==1) ? ("1 v 1") : ((pDuelSettings[playerid][pd_type]==2) ? ("2 v 2") : ("3 v 3")));
	for(new i = 0; i < 3; i++)
	{
	    if(i >= pDuelSettings[playerid][pd_type])
	        format(Duel_MSG, sizeof(Duel_MSG), "%s{CD0000}Duel Mate(%i):\t{CD0000}DISABLED\n", Duel_MSG, i);
		else if(pDuelSettings[playerid][pd_partners][i] == MAX_PLAYERS)
			format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Duel Mate(%i):\t{CD0000}NONE\n", Duel_MSG, i);
		else
			format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Duel Mate(%i):\t{00ff00}%s\n", Duel_MSG, i, D_PlayerName(pDuelSettings[playerid][pd_partners][i]));
	}
	for(new i = 0; i < 3; i++)
	{
		if(i >= pDuelSettings[playerid][pd_type])
	        format(Duel_MSG, sizeof(Duel_MSG), "%s{CD0000}Duel Opponent(%i):\t{CD0000}DISABLED\n", Duel_MSG, i);
		else if(pDuelSettings[playerid][pd_opponents][i] == MAX_PLAYERS)
			format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Duel Opponent(%i):\t{CD0000}NONE\n", Duel_MSG, i);
		else
			format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Duel Opponent(%i):\t{00ff00}%s\n", Duel_MSG, i, D_PlayerName(pDuelSettings[playerid][pd_opponents][i]));
	}
	/*Armour*/
	format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Armor:\t%s\n", Duel_MSG, (pDuelSettings[playerid][pd_armour]==true) ? DUEL_YN );
	/*CJ_Run*/
	format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}CJ Run:\t%s\n", Duel_MSG, (pDuelSettings[playerid][pd_cjrun]==true) ? DUEL_YN);
	/*Location*/
	format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Location:\t{00ff00}%s\n", Duel_MSG, Duel_Location_Names[pDuelSettings[playerid][pd_location]]);
	/*Weapon1*/
	format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Weapon(1):\t{00ff00}%s\n", Duel_MSG, D_WeaponName(pDuelSettings[playerid][pd_weap1]));
	/*Weapon2*/
	format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Weapon(2):\t{00ff00}%s\n", Duel_MSG, D_WeaponName(pDuelSettings[playerid][pd_weap2]));
	/*Stake*/
	format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Stake:\t{00ff00}%i", Duel_MSG, pDuelSettings[playerid][pd_stake]);
	if(CheckDuelSettings(playerid, 0))
	{
	    format(Duel_MSG, sizeof(Duel_MSG), "%s\n{4C75B7}START DUEL", Duel_MSG);
	}
	ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS, "Duel Settings:", Duel_MSG, "Next", "Cancel");
	return 1;
}

stock ShowRequestSummary(playerid, senderid)
{
    DuelCurrent_Set{playerid} = senderid;
    new duel_tempstake[15];
	if(pDuelSettings[senderid][pd_stake] == 0)
	{
		duel_tempstake = "NONE";
	}
	else
	{
		valstr(duel_tempstake, pDuelSettings[senderid][pd_stake]);
	}
	if(senderid == playerid)
	{
	    pDuelAccept[playerid] = true;
        SendClientMessage(playerid, COLOR_NOTICE, "[Duel Settings]: You have sent a duel request to Players.");
	}
	else
	{
        format(Duel_MSG, sizeof(Duel_MSG), "[Duel Settings]: %s has sent you a duel request ({FF0000}Stake: %s{%06x}).", D_PlayerName(senderid), duel_tempstake, COLOR_NOTICE >>> 8);
		SendClientMessage(playerid, COLOR_NOTICE, Duel_MSG);
	}
	//Rest Common settings
	switch(pDuelSettings[senderid][pd_type])
	{
		case 1: 
	 		format(Duel_MSG, sizeof(Duel_MSG), "[Duel Settings]: Type: (1 v 1) :: %s vs %s", Duel_MSG,  D_PlayerName(pDuelSettings[senderid][pd_partners][0]), D_PlayerName(pDuelSettings[senderid][pd_opponents][0]));
		case 2:
			format(Duel_MSG, sizeof(Duel_MSG), "[Duel Settings]: Type: (2 v 2) :: TeamA: %s - %s vs TeamB: %s %s", Duel_MSG, D_PlayerName(pDuelSettings[senderid][pd_partners][0]), D_PlayerName(pDuelSettings[senderid][pd_partners][1]), D_PlayerName(pDuelSettings[senderid][pd_opponents][0]), D_PlayerName(pDuelSettings[senderid][pd_opponents][1]));
		case 3:
			format(Duel_MSG, sizeof(Duel_MSG), "[Duel Settings]: Type: (3 v 3) :: TeamA: %s - %s - %s vs TeamB: %s %s %s", Duel_MSG, D_PlayerName(pDuelSettings[senderid][pd_partners][0]), D_PlayerName(pDuelSettings[senderid][pd_partners][1]), D_PlayerName(pDuelSettings[senderid][pd_partners][2]), D_PlayerName(pDuelSettings[senderid][pd_opponents][0]), D_PlayerName(pDuelSettings[senderid][pd_opponents][1]), D_PlayerName(pDuelSettings[senderid][pd_opponents][2]));

	}
	SendClientMessage(playerid, COLOR_DUEL, Duel_MSG);
	format(Duel_MSG, sizeof(Duel_MSG), "[Duel Settings]: Armour: [%s] - CJ-Run: [%s] - Location: [%s] - Stake: [%s] - Weapon.1: [%s] - Weapon.2: [%s].", (pDuelSettings[senderid][pd_armour]==true) ? DUEL_YN2, (pDuelSettings[senderid][pd_cjrun]==true) ? DUEL_YN2, Duel_Location_Names[pDuelSettings[senderid][pd_location]], duel_tempstake, D_WeaponName(pDuelSettings[senderid][pd_weap1]), D_WeaponName(pDuelSettings[senderid][pd_weap2]));
	SendClientMessage(playerid, COLOR_DUEL, Duel_MSG);
	if(senderid == playerid)
	{
		SendClientMessage(playerid, COLOR_NOTICE, "[DUEL NOTICE]: Duel request sent with your latest duel settings. Please wait till they/he accept(s) the duel.");
		return 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_NOTICE, "[DUEL NOTICE]: Type /acceptduel(ad) to accept the duel request.");
		return 1;
	}
}

stock SendDuelRequest(playerid)
{
	if(CheckDuelSettings(playerid, 1))
	{
	    if(CheckDuelReqPending(playerid))
	    {
		    for(new i = 0; i < pDuelSettings[playerid][pd_type]; i++)
			{
				//Partners
				if(pDuelSettings[playerid][pd_partners][i] != MAX_PLAYERS)
				{
				    pDuelState{pDuelSettings[playerid][pd_partners][i]} = DUEL_REQUESTED;
					pDuelAccept[pDuelSettings[playerid][pd_partners][i]] = false;
				    ShowRequestSummary(pDuelSettings[playerid][pd_partners][i], playerid);
				}
				else
				{
				    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: One or more IDs specified in Duel is not correct. Contact Testers if problem persists (CODE: 570)");
                    Duel_TimerExpire(playerid);
                    return 1;
				}
			    //Opponents
			    if(pDuelSettings[playerid][pd_opponents][i] != MAX_PLAYERS)
				{
				    pDuelState{pDuelSettings[playerid][pd_opponents][i]} = DUEL_REQUESTED;
					pDuelAccept[pDuelSettings[playerid][pd_opponents][i]] = false;
					ShowRequestSummary(pDuelSettings[playerid][pd_opponents][i], playerid);
				}
				else
				{
				    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: One or more IDs specified in Duel is not correct. Contact Testers if problem persists (CODE: 570)");
                    Duel_TimerExpire(playerid);
                    return 1;
				}
			}
			duel_expire[playerid] = defer Duel_TimerExpire[DUEL_EXPIRE_TIME](playerid);
			pDuelSettings[playerid][pd_accptcnt] = 1;
			//pDuelSettings[DuelCurrent_Set{playerid}][pd_duelstatus] = DUEL_REQUESTED;
			pDuelSettings[playerid][pd_duelstatus] = DUEL_REQUESTED;
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: One or more player(s) seem to have duel request pending.");
		    return Duel_ShowCurrentSettings(playerid);
		}
	}
	return 1;
}

/*
 pDuelState{playerid}
	0 = MainPage
	1 = HisMate
	2 = Hismate2
	3 = HisOpp1
	4 = HisOpp2
	5 = HisOpp3
	6 = Location
	7 = weap1
	8 = weap2
	9 = Stake
*/

stock Duel_Set_Setting(playerid, response, listitem, params[])
{
	if(DuelCurrent_Set{playerid} != MAX_PLAYERS)
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can set up duel while you are in a duel.");
	switch(pDuelState{playerid})
	{
	    case 0:
	    {
			if(!response)
			{
				return SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Duel setting tab closed.");
			}
			else
			{
				switch (listitem)
				{
				    //Changing Type:>
				    case 0:
				    {
				        if(pDuelSettings[playerid][pd_type] == 1)
				        {
				            pDuelSettings[playerid][pd_type] = 2;
				            return Duel_ShowCurrentSettings(playerid);
				        }
				        else if(pDuelSettings[playerid][pd_type] == 2)
				        {
				            if(isVIP(playerid) == 3 || AdminLvl(playerid) >= ACMD_GOLD)
				            {
					            pDuelSettings[playerid][pd_type] = 3;
					            return Duel_ShowCurrentSettings(playerid);
				            }
				            else
				            {
					            pDuelSettings[playerid][pd_type] = 1;
					            return Duel_ShowCurrentSettings(playerid);
				            }
				        }
				        else if(pDuelSettings[playerid][pd_type] == 3)
				        {
            				pDuelSettings[playerid][pd_type] = 1;
				        	return Duel_ShowCurrentSettings(playerid);
				        }
				    }
////////////////////////////////////////////////////////////////////////////////
				    //Cant Change.. Its himself
				    case 1:
				    {
				        return Duel_ShowCurrentSettings(playerid);
				    }
				    //TeamMate1
				    case 2:
				    {
				        if(pDuelSettings[playerid][pd_type] > 1)
				        {
					        pDuelState{playerid} = 1;
					        return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel TeamMate:", "Please insert the exact name of the player you wish to duel {00ff00}with:","Next","Cancel");
						}
						else
						    return Duel_ShowCurrentSettings(playerid);
					}
				    //TeamMate2
				    case 3:
				    {
				    	if(pDuelSettings[playerid][pd_type] > 2)
				        {
					        pDuelState{playerid} = 2;
					        return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel TeamMate:", "Please insert the name/player_id of the player you wish to duel {00ff00}with:","Next","Cancel");
                        }
						else
						    return Duel_ShowCurrentSettings(playerid);
					}
				    //Opponent1
				    case 4:
				    {
				        if(pDuelSettings[playerid][pd_type] > 0)
				        {
					        pDuelState{playerid} = 3;
				        	return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel Opponent:", "Please insert the exact name of the player you wish to duel {ff0000}against:","Next","Cancel");
						}
						else
						    return Duel_ShowCurrentSettings(playerid);
					}
				    //Opponent2
				    case 5:
				    {
				    	if(pDuelSettings[playerid][pd_type] > 1)
				        {
							pDuelState{playerid} = 4;
				        	return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel Opponent:", "Please insert the name/player_id of the second player you wish to duel {ff0000}against:","Next","Cancel");
				    	}
						else
						    return Duel_ShowCurrentSettings(playerid);
					}
				    //Opponent3
				    case 6:
				    {
				        if(pDuelSettings[playerid][pd_type] > 2)
				        {
					        pDuelState{playerid} = 5;
				        	return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel Opponent:", "Please insert the exact name of the player you wish to duel {ff0000}against:","Next","Cancel");
                        }
						else
						    return Duel_ShowCurrentSettings(playerid);
					}
////////////////////////////////////////////////////////////////////////////////
				    case 7:
				    {
				        if(pDuelSettings[playerid][pd_armour] == true)
				            pDuelSettings[playerid][pd_armour] = false;
						else
						    pDuelSettings[playerid][pd_armour] = true;
				        return Duel_ShowCurrentSettings(playerid);
				    }
				    case 8:
				    {
				        if(pDuelSettings[playerid][pd_cjrun] == true)
				            pDuelSettings[playerid][pd_cjrun] = false;
						else
						    pDuelSettings[playerid][pd_cjrun] = true;
				        return Duel_ShowCurrentSettings(playerid);
				    }
				    case 9:
				    {
				        Duel_MSG = "";
				        for(new i = 0; i < MAX_LOCATIONS; i++)
				        {
				            if(i != MAX_LOCATIONS-1)
				            	format(Duel_MSG, sizeof(Duel_MSG), "%s%s\n", Duel_MSG, Duel_Location_Names[i]);
							else
							    format(Duel_MSG, sizeof(Duel_MSG), "%s%s", Duel_MSG, Duel_Location_Names[i]);
				        }
				        pDuelState{playerid} = 6;
				        return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_LIST, "Duel Location:", Duel_MSG ,"Next","Cancel");
				    }
				    case 10:
				    {
				        pDuelState{playerid} = 7;
        				return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_LIST, "Duel Weapon 1:", "Deagle\nMP5\nShotgun\nCombat Shotgun\nSawn-off Shotgun\nCountry Rifle\nSniper Rifle\nAK-47\nM4\nUZI\nTec-9", "Next", "Cancel");
				    }
				    case 11:
				    {
				        pDuelState{playerid} = 8;
        				return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_LIST, "Duel Weapon 2:", "(Empty)\nDeagle\nMP5\nShotgun\nCombat Shotgun\nSawn-off Shotgun\nCountry Rifle\nSniper Rifle\nAK-47\nM4\nUZI\nTec-9", "Next", "Cancel");
				    }
				    case 12:
				    {
				        pDuelState{playerid} = 9;
						return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel Stake:", "Please insert the amount you want to put as stake.\n\n\n{ff0000}Press Cancel for No-Stake.:","Next","Cancel");
				    }
				    case 13:
				    {
				    
						pDuelState{playerid} = 10;
						Duel_MSG = "Are you sure you want to send the duel request?";
						format(Duel_MSG, sizeof(Duel_MSG), "%s\n{D78E10}Duel Type:\t\t{00ff00}%s\n", Duel_MSG, (pDuelSettings[playerid][pd_type]==1) ? ("1 v 1") : ((pDuelSettings[playerid][pd_type]==2) ? ("2 v 2") : ("3 v 3")));
						for(new i = 0; i < pDuelSettings[playerid][pd_type]; i++)
						{
						    format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Duel Mate(%i):\t\t{00ff00}%s\n", Duel_MSG, i, D_PlayerName(pDuelSettings[playerid][pd_partners][i]));
						}
						for(new i = 0; i < pDuelSettings[playerid][pd_type]; i++)
						{
							format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Duel Opponent(%i):\t{00ff00}%s\n", Duel_MSG, i, D_PlayerName(pDuelSettings[playerid][pd_opponents][i]));
						}
						format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Armor:\t\t\t%s\n", Duel_MSG, (pDuelSettings[playerid][pd_armour]==true) ? DUEL_YN );
						format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}CJ Run:\t\t%s\n", Duel_MSG, (pDuelSettings[playerid][pd_cjrun]==true) ? DUEL_YN);
						format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Location:\t\t{00ff00}%s\n", Duel_MSG, Duel_Location_Names[pDuelSettings[playerid][pd_location]]);
						format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Weapon(1):\t\t{00ff00}%s\n", Duel_MSG, D_WeaponName(pDuelSettings[playerid][pd_weap1]));
						format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Weapon(2):\t\t{00ff00}%s\n", Duel_MSG, D_WeaponName(pDuelSettings[playerid][pd_weap2]));
						format(Duel_MSG, sizeof(Duel_MSG), "%s{D78E10}Stake:\t\t\t{00ff00}%i", Duel_MSG, pDuelSettings[playerid][pd_stake]);
						return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_MSGBOX, "Duel FINAL:", Duel_MSG,"Send","Chicken");
				    }
				}
			}
		}
		case 1:
		{
			if(!response)
			{
    			return Duel_ShowCurrentSettings(playerid);
			}
			else
			{
				new targetid;
				if(sscanf(params, "u", targetid))
				{
                    return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel Settings:", "Please try again...\n\nPlease insert the exact name of the player you wish to duel with:","Next","Cancel");
				}
				else
				{
				    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid) || targetid == playerid)
				    {
				        return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel Settings:", "Invalid PlayerName/ID...\nPlease try again...\n\nPlease insert the exact name of the player you wish to duel with:","Next","Cancel");
				    }
				    else
				    {
				        pDuelSettings[playerid][pd_partners][1] = targetid;
				        pDuelState{playerid} = 0;
				        return Duel_ShowCurrentSettings(playerid);
				    }
				}
				
			}
		}
		case 2:
		{
			if(!response)
			{
    			return Duel_ShowCurrentSettings(playerid);
			}
			else
			{
				new targetid;
				if(sscanf(params, "u", targetid))
				{
                    return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel Settings:", "Please try again...\n\nPlease insert the exact name of the player you wish to duel with:","Next","Cancel");
				}
				else
				{
				    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid) || targetid == playerid)
				    {
				        return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel Settings:", "Invalid PlayerName/ID...\nPlease try again...\n\nPlease insert the exact name of the player you wish to duel with:","Next","Cancel");
				    }
				    else
				    {
				        pDuelSettings[playerid][pd_partners][2] = targetid;
				        pDuelState{playerid} = 0;
				        return Duel_ShowCurrentSettings(playerid);
				    }
				}

			}
		}
		case 3:
		{
			if(!response)
			{
    			return Duel_ShowCurrentSettings(playerid);
			}
			else
			{
				new targetid;
				if(sscanf(params, "u", targetid))
				{
                    return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel Settings:", "Please try again...\n\nPlease insert the exact name of the player you wish to duel against:","Next","Cancel");
				}
				else
				{
				    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid) || targetid == playerid)
				    {
				        return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel Settings:", "Invalid PlayerName/ID...\nPlease try again...\n\nPlease insert the exact name of the player you wish to duel :","Next","Cancel");
				    }
				    else
				    {
				        pDuelSettings[playerid][pd_opponents][0] = targetid;
				        pDuelState{playerid} = 0;
				        return Duel_ShowCurrentSettings(playerid);
				    }
				}

			}
		}
		case 4:
		{
   			if(!response)
			{
    			return Duel_ShowCurrentSettings(playerid);
			}
			else
			{
				new targetid;
				if(sscanf(params, "u", targetid))
				{
                    return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel Settings:", "Please try again...\n\nPlease insert the exact name of the player you wish to duel against:","Next","Cancel");
				}
				else
				{
				    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid) || targetid == playerid)
				    {
				        return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel Settings:", "Invalid PlayerName/ID...\nPlease try again...\n\nPlease insert the exact name of the player you wish to duel against:","Next","Cancel");
				    }
				    else
				    {
				        pDuelSettings[playerid][pd_opponents][1] = targetid;
				        pDuelState{playerid} = 0;
				        return Duel_ShowCurrentSettings(playerid);
				    }
				}
			}
		}
		case 5:
		{
			if(!response)
			{
    			return Duel_ShowCurrentSettings(playerid);
			}
			else
			{
				new targetid;
				if(sscanf(params, "u", targetid))
				{
                    return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel Settings:", "Please try again...\n\nPlease insert the exact name of the player you wish to duel against:","Next","Cancel");
				}
				else
				{
				    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid) || targetid == playerid)
				    {
				        return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel Settings:", "Invalid PlayerName/ID...\nPlease try again...\n\nPlease insert the exact name of the player you wish to duel against:","Next","Cancel");
				    }
				    else
				    {
				        pDuelSettings[playerid][pd_opponents][2] = targetid;
				        pDuelState{playerid} = 0;
				        return Duel_ShowCurrentSettings(playerid);
				    }
				}

			}
		}
		case 6:
		{
			if(!response)
			{
				return Duel_ShowCurrentSettings(playerid);
			}
			else
			{
                pDuelSettings[playerid][pd_location] = listitem;
                pDuelState{playerid} = 0;
                return Duel_ShowCurrentSettings(playerid);
			}
		}
		case 7:
		{
			if(!response)
			{
				return Duel_ShowCurrentSettings(playerid);
			}
			else
			{
			    pDuelState{playerid} = 0;
				switch(listitem)
	        	{
	        	    case 0: pDuelSettings[playerid][pd_weap1] = 24;
					case 1: pDuelSettings[playerid][pd_weap1] = 29;
	        	    case 2: pDuelSettings[playerid][pd_weap1] = 25;
					case 3: pDuelSettings[playerid][pd_weap1] = 27;
	        	    case 4: pDuelSettings[playerid][pd_weap1] = 26;
	        	    case 5: pDuelSettings[playerid][pd_weap1] = 33;
	        	    case 6: pDuelSettings[playerid][pd_weap1] = 34;
	        	    case 7: pDuelSettings[playerid][pd_weap1] = 30;
	        	    case 8: pDuelSettings[playerid][pd_weap1] = 31;
	        	    case 9: pDuelSettings[playerid][pd_weap1] = 28;
	        	    case 10: pDuelSettings[playerid][pd_weap1] = 32;
	        	}
	        	return Duel_ShowCurrentSettings(playerid);
			}
		}
		case 8:
		{
			if(!response)
			{
				return Duel_ShowCurrentSettings(playerid);
			}
			else
			{
			    pDuelState{playerid} = 0;
				switch(listitem)
	        	{
	        	    case 0: pDuelSettings[playerid][pd_weap2] = 0;
	        	    case 1: pDuelSettings[playerid][pd_weap2] = 24;
					case 2: pDuelSettings[playerid][pd_weap2] = 29;
	        	    case 3: pDuelSettings[playerid][pd_weap2] = 25;
					case 4: pDuelSettings[playerid][pd_weap2] = 27;
	        	    case 5: pDuelSettings[playerid][pd_weap2] = 26;
	        	    case 6: pDuelSettings[playerid][pd_weap2] = 33;
	        	    case 7: pDuelSettings[playerid][pd_weap2] = 34;
	        	    case 8: pDuelSettings[playerid][pd_weap2] = 30;
	        	    case 9: pDuelSettings[playerid][pd_weap2] = 31;
	        	    case 10: pDuelSettings[playerid][pd_weap2] = 28;
	        	    case 11: pDuelSettings[playerid][pd_weap2] = 32;
	        	}
	        	return Duel_ShowCurrentSettings(playerid);
			}
		}
		case 9:
		{
			if(!response)
			{
				pDuelSettings[playerid][pd_stake] = 0;
				return Duel_ShowCurrentSettings(playerid);
			}
			else
			{
			    new amount;
				if(sscanf(params, "d", amount))
					return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel Stake:", "Please insert the amount you want to put as stake.\n*Please enter a value between $1000 and $500,000.\n{ff0000}Press Cancel for No-Stake.:","Next","Cancel");
				else if(amount < 1000 || amount > 500000)
				    return ShowPlayerDialog(playerid, DIALOG_DUEL_SETTINGS, DIALOG_STYLE_INPUT, "Duel Stake:", "Please insert the amount you want to put as stake.\n*Please enter a value between $1000 and $500,000.\n{ff0000}Press Cancel for No-Stake.:","Next","Cancel");
				else
				{
				    pDuelSettings[playerid][pd_stake] = 0;
				    pDuelSettings[playerid][pd_stake] = amount;
					return Duel_ShowCurrentSettings(playerid);
				}
			}
		}
		case 10:
		{
			if(!response)
			{
				return Duel_ShowCurrentSettings(playerid);
			}
			else
			{
				SendDuelRequest(playerid);
			}
		}

	}
	return 1;
}

stock DuelDenyRequest(playerid, denierid)
{

	if(duel_expire[playerid] != Timer:-1)
	{
	    stop duel_expire[playerid];
	    duel_expire[playerid] = Timer:-1;
    }
	if(denierid == -1)
	{
 		for(new i = 0; i < pDuelSettings[playerid][pd_type]; i++)
		{
		    if(pDuelSettings[playerid][pd_partners][i] != MAX_PLAYERS)
		    {
                DuelCurrent_Set{pDuelSettings[playerid][pd_partners][i]} = MAX_PLAYERS;
				SendClientMessage(pDuelSettings[playerid][pd_partners][i], COLOR_NOTICE, "[DUEL NOTICE]: Duel request expired due to error in settings.");
			}
			if(pDuelSettings[playerid][pd_opponents][i] != MAX_PLAYERS)
			{
			    DuelCurrent_Set{pDuelSettings[playerid][pd_opponents][i]} = MAX_PLAYERS;
				SendClientMessage(pDuelSettings[playerid][pd_opponents][i], COLOR_NOTICE, "[DUEL NOTICE]: Duel request expired due to error in settings.");
			}
		}
	}
	else
	{
 		for(new i = 0; i < pDuelSettings[playerid][pd_type]; i++)
		{
			if(pDuelSettings[playerid][pd_partners][i] != MAX_PLAYERS)
			{
	            DuelCurrent_Set{pDuelSettings[playerid][pd_partners][i]} = MAX_PLAYERS;
			    if(pDuelSettings[playerid][pd_partners][i] == denierid)
			        SendClientMessage(pDuelSettings[playerid][pd_partners][i], COLOR_NOTICE, "[DUEL NOTICE]: You have sucessfully denied the request");
			    else
					SendClientMessage(pDuelSettings[playerid][pd_partners][i], COLOR_NOTICE, "[DUEL NOTICE]: Duel request expired due to one of the player(s) denying it.");
			}
			if(pDuelSettings[playerid][pd_opponents][i] != MAX_PLAYERS)
			{
			    DuelCurrent_Set{pDuelSettings[playerid][pd_opponents][i]} = MAX_PLAYERS;
				if(pDuelSettings[playerid][pd_partners][i] == denierid)
			        SendClientMessage(pDuelSettings[playerid][pd_opponents][i], COLOR_NOTICE, "[DUEL NOTICE]: You have sucessfully denied the request");
			    else
					SendClientMessage(pDuelSettings[playerid][pd_opponents][i], COLOR_NOTICE, "[DUEL NOTICE]: Duel request expired due to error in settings.");
			}
		}
	}
	defer SetBackDuelVariables[1000](playerid);
	return 1;
}

stock DuelLeaveDuel(playerid, leaverid)
{
	format(Duel_MSG, sizeof(Duel_MSG), "[LeaveDuel]: PID: %i || LID: %i || Status: %i", playerid, leaverid, pDuelSettings[playerid][pd_duelstatus]);
	print(Duel_MSG);
	if(pDuelSettings[playerid][pd_duelstatus] == DUEL_REQUESTED && playerid != leaverid)
	{
	    return DuelDenyRequest(playerid, leaverid);
	}
	if(DuelPlayerDead[leaverid] == true && DuelCurrent_Set{leaverid} == playerid && playerid != leaverid)
	{
		format(Duel_MSG, sizeof(Duel_MSG), "[DUEL NOTICE]: %s has left the duel after dying. Duel will continue. Be a gentleman and give her a tissue.", PlayerName(leaverid));
		for(new i = 0; i < pDuelSettings[playerid][pd_type]; i++)
		{
			if(InDuelPlayerSettings[playerid][0][i] == leaverid)
			{
			    pDuelSettings[playerid][pd_partners][i] = MAX_PLAYERS;
			    InDuelPlayerSettings[playerid][0][i] = MAX_PLAYERS;
			}
			else
			{
			    SendClientMessage(InDuelPlayerSettings[playerid][0][i], COLOR_NOTICE, Duel_MSG);
			}
			if(InDuelPlayerSettings[playerid][1][i] == leaverid)
			{
			    pDuelSettings[playerid][pd_opponents][i] = MAX_PLAYERS;
			    InDuelPlayerSettings[playerid][1][i] = MAX_PLAYERS;
			}
			else
			{
			    SendClientMessage(InDuelPlayerSettings[playerid][1][i], COLOR_NOTICE, Duel_MSG);
			}
		}
		pDuelState{leaverid} = DUEL_NONE;
		FoCo_Player[leaverid][duels_lost]++;
		FoCo_Player[leaverid][duels_total]++;
	}
	else
	{
		if(pDuelSettings[playerid][pd_duelstatus] == DUEL_STARTPENDING)
	    {
			if(duel_start[playerid] != Timer:-1)
			{
		  		stop duel_start[playerid];
			    duel_start[playerid] = Timer:-1;
			}
		}
		for(new i = 0; i < pDuelSettings[playerid][pd_type]; i++)
		{
		    if(GetPlayerState(pDuelSettings[playerid][pd_opponents][i]) != PLAYER_STATE_SPECTATING && DuelPlayerDead[pDuelSettings[playerid][pd_opponents][i]] != true)
		    {
	 			defer DelaySpawnPlayer[1000](pDuelSettings[playerid][pd_opponents][i]);
			}
			else
			{
			    TogglePlayerSpectating(pDuelSettings[playerid][pd_opponents][i], 0);
			}
			if(GetPlayerState(pDuelSettings[playerid][pd_partners][i]) != PLAYER_STATE_SPECTATING && DuelPlayerDead[pDuelSettings[playerid][pd_partners][i]] != true)
			{
    		    defer DelaySpawnPlayer[1000](pDuelSettings[playerid][pd_partners][i]);
			}
			else
			{
    			TogglePlayerSpectating(pDuelSettings[playerid][pd_partners][i], 0);
			}
			if(pDuelSettings[playerid][pd_stake] > 0)
			{
				if(pDuelSettings[playerid][pd_partners][i] != leaverid && IsPlayerConnected(pDuelSettings[playerid][pd_partners][i]))
					GivePlayerMoney(pDuelSettings[playerid][pd_partners][i], pDuelSettings[playerid][pd_stake]);
                if(pDuelSettings[playerid][pd_partners][i] != leaverid && IsPlayerConnected(pDuelSettings[playerid][pd_partners][i]))
					GivePlayerMoney(pDuelSettings[playerid][pd_opponents][i], pDuelSettings[playerid][pd_stake]);
			}
			SetPVarInt(pDuelSettings[playerid][pd_partners][i], "PlayerStatus", 0);
            SetPVarInt(pDuelSettings[playerid][pd_opponents][i], "PlayerStatus", 0);
		}
		format(Duel_MSG, sizeof(Duel_MSG), "[DUEL NOTICE]: %s has left the duel, causing it to end.", PlayerName(leaverid));
		SendClientMessageToAll(COLOR_DUEL, Duel_MSG);
		defer SetBackDuelVariables[1000](playerid);
	}
	pDuelSettings[playerid][pd_duelstatus] = DUEL_NONE;
	return 1;
}


stock DuelStartDuel(playerid)
{
	if(pDuelSettings[DuelCurrent_Set{playerid}][pd_duelstatus] == DUEL_REQUESTED)
	{
		print("Starting");
		if(duel_expire[playerid] != Timer:-1)
		{
			stop duel_expire[playerid];
			duel_expire[playerid] = Timer:-1;
		    for(new i = 0; i < pDuelSettings[playerid][pd_type]; i++)
			{
			    new Float:dbf_Pos[3];
			    if(IsPlayerInAnyVehicle(pDuelSettings[playerid][pd_partners][i]))
			    {
			        GetPlayerPos(pDuelSettings[playerid][pd_partners][i], dbf_Pos[0], dbf_Pos[1], dbf_Pos[2]);
					SetPlayerPos(pDuelSettings[playerid][pd_partners][i], dbf_Pos[0], dbf_Pos[1], dbf_Pos[2]);

				}
				if(IsPlayerInAnyVehicle(pDuelSettings[playerid][pd_opponents][i]))
				{
				    GetPlayerPos(pDuelSettings[playerid][pd_opponents][i], dbf_Pos[0], dbf_Pos[1], dbf_Pos[2]);
		            SetPlayerPos(pDuelSettings[playerid][pd_opponents][i], dbf_Pos[0], dbf_Pos[1], dbf_Pos[2]);
				}
				SetPlayerHealth(pDuelSettings[playerid][pd_partners][i], 99.0);
				SetPlayerHealth(pDuelSettings[playerid][pd_opponents][i], 99.0);
				
				SetPlayerArmour(pDuelSettings[playerid][pd_partners][i], 0.0);
				SetPlayerArmour(pDuelSettings[playerid][pd_opponents][i], 0.0);
				
				ResetPlayerWeapons(pDuelSettings[playerid][pd_partners][i]);
				ResetPlayerWeapons(pDuelSettings[playerid][pd_opponents][i]);
				
				RemovePlayerFromVehicle(pDuelSettings[playerid][pd_partners][i]);
				RemovePlayerFromVehicle(pDuelSettings[playerid][pd_opponents][i]);
				
				pDuelState{pDuelSettings[playerid][pd_partners][i]} = DUEL_STARTPENDING;
				pDuelState{pDuelSettings[playerid][pd_opponents][i]} = DUEL_STARTPENDING;
				
				SetPlayerPos(pDuelSettings[playerid][pd_partners][i], Duel_Location_Side1[pDuelSettings[playerid][pd_location]][0] + float(i), Duel_Location_Side1[pDuelSettings[playerid][pd_location]][1] + float(i), Duel_Location_Side1[pDuelSettings[playerid][pd_location]][2]);
				SetPlayerPos(pDuelSettings[playerid][pd_opponents][i], Duel_Location_Side2[pDuelSettings[playerid][pd_location]][0],  Duel_Location_Side2[pDuelSettings[playerid][pd_location]][1] + float(i),  Duel_Location_Side2[pDuelSettings[playerid][pd_location]][2]);

				SetPlayerFacingAngle(pDuelSettings[playerid][pd_partners][i], Duel_Location_Side1[pDuelSettings[playerid][pd_location]][3]);
				SetPlayerFacingAngle(pDuelSettings[playerid][pd_opponents][i], Duel_Location_Side2[pDuelSettings[playerid][pd_location]][3]);

				SetPVarInt(pDuelSettings[playerid][pd_partners][i], "PlayerStatus", 2);
				SetPVarInt(pDuelSettings[playerid][pd_opponents][i], "PlayerStatus", 2);
				
				SetPlayerInterior(pDuelSettings[playerid][pd_partners][i], Duel_Location_Det[pDuelSettings[playerid][pd_location]]);
				SetPlayerInterior(pDuelSettings[playerid][pd_opponents][i], Duel_Location_Det[pDuelSettings[playerid][pd_location]]);

				SetPlayerVirtualWorld(pDuelSettings[playerid][pd_partners][i], 1000 + playerid);
				SetPlayerVirtualWorld(pDuelSettings[playerid][pd_opponents][i], 1000 + playerid);

				GivePlayerMoney(pDuelSettings[playerid][pd_partners][i], -pDuelSettings[playerid][pd_stake]);
				GivePlayerMoney(pDuelSettings[playerid][pd_opponents][i], -pDuelSettings[playerid][pd_stake]);

				TogglePlayerControllable(pDuelSettings[playerid][pd_partners][i], 0);
				TogglePlayerControllable(pDuelSettings[playerid][pd_opponents][i], 0);

				SetCameraBehindPlayer(pDuelSettings[playerid][pd_partners][i]);
				SetCameraBehindPlayer(pDuelSettings[playerid][pd_opponents][i]);

				SendClientMessage(pDuelSettings[playerid][pd_partners][i], COLOR_NOTICE, "[DUEL NOTICE]: Duel will start in 10 seconds.");
	            SendClientMessage(pDuelSettings[playerid][pd_opponents][i], COLOR_NOTICE, "[DUEL NOTICE]: Duel will start in 10 seconds.");

                InDuelPlayerSettings[playerid][0][i] = pDuelSettings[playerid][pd_partners][i];
                InDuelPlayerSettings[playerid][1][i] = pDuelSettings[playerid][pd_opponents][i];

				SetPVarInt(pDuelSettings[playerid][pd_partners][i], "DuelTeamID", 0);
				SetPVarInt(pDuelSettings[playerid][pd_opponents][i], "DuelTeamID", 1);
			}
			InDuelPlayerSettings[playerid][0][3] = pDuelSettings[playerid][pd_type];
			InDuelPlayerSettings[playerid][1][3] = pDuelSettings[playerid][pd_type];
			duel_start[playerid] = defer DuelBegin[DUEL_START_TIME](playerid);
			pDuelSettings[DuelCurrent_Set{playerid}][pd_duelstatus] = DUEL_STARTPENDING;

		}
		else
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Error in settings. Please contact Tester Team if the problem persists(Code #TDE).");
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Error in settings. Please contact Tester Team if the problem persists.(Code #PDS)");
	}
	print("FunctionOver");
	return 1;
}

forward DuelPlayerDeath(deadman, killid, reason);
public DuelPlayerDeath(deadman, killid, reason)
{
	if(GetPVarInt(deadman, "PlayerStatus") == 2)
	{
		new duelidK, killerid;
		new duelidD = DuelCurrent_Set{deadman};
        if(killid == INVALID_PLAYER_ID)
        {
			killerid = duelidD;
			duelidK = duelidD;
        }
        else
        {
			killerid = killid;
			duelidK = DuelCurrent_Set{killid};
        }
		format(Duel_MSG, sizeof(Duel_MSG), "DeadMan : %i -  Killerid : %i - DuelIDK : %i -  DuelIDD : %i || DA[0]: %i || DA[1]", deadman, killerid, duelidK, duelidD, InDuelPlayerSettings[duelidD][0][3], InDuelPlayerSettings[duelidD][1][3]);
		DebugMsg(Duel_MSG);
		if(duelidK == duelidD)
		{
			new playerid = duelidK;
		    new TeamIDK = GetPVarInt(killerid, "DuelTeamID");
			new TeamIDD = GetPVarInt(deadman , "DuelTeamID");
			if(TeamIDK == TeamIDD) //TK Fix, incase.. Event is bugged or shit..
			{
				if(TeamIDK == 0)
				{
					TeamIDK = 1;
				}
				else
				{
					TeamIDK = 0;
				}
			}
			if(DuelPlayerDead[deadman] == false)
			{
				InDuelPlayerSettings[playerid][TeamIDD][3]--;
      		    DuelPlayerDead[deadman] = true;
			}
			else
			    return 1;
			format(Duel_MSG, sizeof(Duel_MSG), "DIDK : %i -  DIDD : %i - DTDK : %i -  DTDD : %i || DA: %i KA: %i", duelidK, duelidD, TeamIDK, TeamIDD, InDuelPlayerSettings[playerid][TeamIDD][3], InDuelPlayerSettings[playerid][TeamIDK][3]);
			DebugMsg(Duel_MSG);
			if(InDuelPlayerSettings[playerid][TeamIDD][3] == 0)
			{
				ToggleDuelSpectate(duelidD, playerid);
				new strlooser[80];
				new strwinner[80];
				switch(pDuelSettings[playerid][pd_type])
				{
					case 1:
					{
						format(strwinner, sizeof(strwinner), "%s", D_PlayerName(InDuelPlayerSettings[playerid][TeamIDK][0]));
						format(strlooser, sizeof(strlooser), "%s's", D_PlayerName(InDuelPlayerSettings[playerid][TeamIDD][0]));
					}
					case 2:
					{
						format(strwinner, sizeof(strwinner), "%s and %s", D_PlayerName(InDuelPlayerSettings[playerid][TeamIDK][0]), D_PlayerName(InDuelPlayerSettings[playerid][TeamIDK][1]));
						format(strlooser, sizeof(strlooser), "%s's and %s's", D_PlayerName(InDuelPlayerSettings[playerid][TeamIDD][0]), D_PlayerName(InDuelPlayerSettings[playerid][TeamIDD][1]));
					}
					case 3:
					{
						format(strwinner, sizeof(strwinner), "%s, %s and %s", D_PlayerName(InDuelPlayerSettings[playerid][TeamIDK][0]), D_PlayerName(InDuelPlayerSettings[playerid][TeamIDK][1]), D_PlayerName(InDuelPlayerSettings[playerid][TeamIDK][2]));
						format(strlooser, sizeof(strlooser), "%s's, %s's and %s's", D_PlayerName(InDuelPlayerSettings[playerid][TeamIDD][0]), D_PlayerName(InDuelPlayerSettings[playerid][TeamIDD][1]), D_PlayerName(InDuelPlayerSettings[playerid][TeamIDD][2]));
					}
				}
				new randomid = random(DUEL_CMESSAGE);
				format(Duel_MSG, sizeof(Duel_MSG), Duel_PMessage[randomid], pDuelSettings[duelidK][pd_type], pDuelSettings[duelidK][pd_type], strwinner, strlooser);
				for(new i = 0; i < pDuelSettings[duelidK][pd_type]; i++)
				{
					SetPVarInt(InDuelPlayerSettings[playerid][TeamIDK][i], "PlayerStatus", 0);
					SetPVarInt(InDuelPlayerSettings[playerid][TeamIDD][i], "PlayerStatus", 0);
					FoCo_Player[InDuelPlayerSettings[playerid][TeamIDK][i]][duels_won]++;
					FoCo_Player[InDuelPlayerSettings[playerid][TeamIDD][i]][duels_lost]++;

					FoCo_Player[InDuelPlayerSettings[playerid][TeamIDK][i]][duels_total]++;
					FoCo_Player[InDuelPlayerSettings[playerid][TeamIDD][i]][duels_total]++;
					//Edit Death Shit
					if(pDuelSettings[playerid][pd_stake] > 0)
					{
						if(InDuelPlayerSettings[playerid][TeamIDD][i] != MAX_PLAYERS)
						{
							format(Duel_MSG,sizeof(Duel_MSG), "[DUEL STAKE] You lost $%d!", pDuelSettings[playerid][pd_stake]);
							SendClientMessage(InDuelPlayerSettings[playerid][TeamIDD][i], COLOR_NOTICE, Duel_MSG);
						}
						if(InDuelPlayerSettings[playerid][TeamIDK][i] != MAX_PLAYERS)
						{
							format(Duel_MSG,sizeof(Duel_MSG), "[DUEL STAKE] You won $%d!", pDuelSettings[playerid][pd_stake]);
							SendClientMessage(InDuelPlayerSettings[playerid][TeamIDK][i], COLOR_NOTICE, Duel_MSG);
							GivePlayerMoney(InDuelPlayerSettings[playerid][TeamIDK][i], pDuelSettings[playerid][pd_stake]); //His Stake
							GivePlayerMoney(InDuelPlayerSettings[playerid][TeamIDK][i], pDuelSettings[playerid][pd_stake]); //His Win
						}
					}
					/*ResetDuel(duelid);
					return 1;*/
				}
				SendClientMessageToAll(COLOR_GREEN, Duel_MSG);
				format(Duel_MSG, sizeof(Duel_MSG), "[DUEL]: %s gained %d$ by winning in a duel against %s.", strwinner, pDuelSettings[duelidK][pd_stake], strlooser);
				MoneyLog(Duel_MSG);
				format(Duel_MSG, sizeof(Duel_MSG), "[DUEL]: %s lost %d$ by losing in a duel against %s.", strlooser, pDuelSettings[duelidK][pd_stake], strwinner);
				MoneyLog(Duel_MSG);
				for(new i = 0; i < pDuelSettings[playerid][pd_type]; i++)
				{
					format(Duel_MSG, sizeof(Duel_MSG), "[%i]: %i || %i + %i || %i.", PLAYER_STATE_SPECTATING, GetPlayerState(pDuelSettings[playerid][pd_partners][i]), DuelPlayerDead[pDuelSettings[playerid][pd_partners][i]], GetPlayerState(pDuelSettings[playerid][pd_opponents][i]), DuelPlayerDead[pDuelSettings[playerid][pd_opponents][i]]);
					print(Duel_MSG);
					if(pDuelSettings[playerid][pd_opponents][i] != deadman)
	    			{
						if(GetPlayerState(pDuelSettings[playerid][pd_opponents][i]) != PLAYER_STATE_SPECTATING && DuelPlayerDead[pDuelSettings[playerid][pd_opponents][i]] != true)
						{
						    print("Supposed to Spawn");
					    	defer DelaySpawnPlayer[1000](pDuelSettings[playerid][pd_opponents][i]);
					    }
						else
						{
	     					print("Supposed to ToggleSpec1");
						    TogglePlayerSpectating(pDuelSettings[playerid][pd_opponents][i], 0);
						}
					}
					else
					{
					    defer RespawnAfterSpectating[2000](deadman);
					    TogglePlayerSpectating(deadman, 1);
					}
					
					if(pDuelSettings[playerid][pd_partners][i] != deadman)
	    			{
						if(GetPlayerState(pDuelSettings[playerid][pd_partners][i]) != PLAYER_STATE_SPECTATING && DuelPlayerDead[pDuelSettings[playerid][pd_partners][i]] != true)
						{
						    print("Supposed to Spawn");
							defer DelaySpawnPlayer[1000](pDuelSettings[playerid][pd_partners][i]);
	         			}
						else
						{
						    print("Supposed to ToggleSpec1");
						    TogglePlayerSpectating(pDuelSettings[playerid][pd_partners][i], 0);
						}
					}
					else
					{
					    defer RespawnAfterSpectating[2000](deadman);
					    TogglePlayerSpectating(deadman, 1);
					}
				}
				print("SetBackDuelShits");
				defer SetBackDuelVariables[1000](playerid);
			}
			else
			{
				ToggleDuelSpectate(playerid, deadman);
			}
		}
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    print("ODR_RakG_Duel_Ne");
	if(dialogid == DIALOG_DUEL_SETTINGS)
	{
	    Duel_Set_Setting(playerid, response, listitem, inputtext);
	    return 1;
	}
	return 0;
}

stock ClearDuelSettings(playerid)
{
	for(new i = 0; i < 3; i++)
	{
		pDuelSettings[playerid][pd_partners][i] = MAX_PLAYERS;
		pDuelSettings[playerid][pd_opponents][i] = MAX_PLAYERS;
		InDuelPlayerSettings[playerid][0][i] = MAX_PLAYERS;
		InDuelPlayerSettings[playerid][1][i] = MAX_PLAYERS;
	}
	for(new k = 0; k < MAX_PLAYERS; k++)
	{
		for(new i = 0; i < 3; i++)
		{
			if(pDuelSettings[k][pd_partners][i] == playerid)
			    pDuelSettings[k][pd_partners][i] = MAX_PLAYERS;
			    
			if(pDuelSettings[k][pd_opponents][i] == playerid)
			  	pDuelSettings[k][pd_opponents][i] = MAX_PLAYERS;
			  	
			if(InDuelPlayerSettings[k][0][i] == playerid)
			    InDuelPlayerSettings[k][0][i] = MAX_PLAYERS;
			    
			if(InDuelPlayerSettings[k][1][i] == playerid)
			    InDuelPlayerSettings[k][1][i] = MAX_PLAYERS;
		}
	}
	InDuelPlayerSettings[playerid][0][3] = 0;
	InDuelPlayerSettings[playerid][1][3] = 0;
	pDuelSettings[playerid][pd_accptcnt] = 0;
	pDuelSettings[playerid][pd_duelstatus] = DUEL_NONE;
	DuelCurrent_Set{playerid} = MAX_PLAYERS;
	pDuelState{playerid} = 0; //./duel state of player..
	pDuelAccept[playerid] = false;
	DuelPlayerDead[playerid] = false;
	duel_expire[playerid] = Timer:-1;
	duel_start[playerid] = Timer:-1;
	pDuelSettings[playerid][pd_armour] = false;
	pDuelSettings[playerid][pd_cjrun] = false;
	pDuelSettings[playerid][pd_location] = 0;
	pDuelSettings[playerid][pd_weap1] = 24;
	pDuelSettings[playerid][pd_weap2] = 0;
	pDuelSettings[playerid][pd_partners][0] = playerid;
}

hook OnGameModeInit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		ClearDuelSettings(i);
	}
	printf("Reset-Duel Info for All");
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	if(DuelCurrent_Set{playerid} != MAX_PLAYERS)
	{
		if(pDuelSettings[DuelCurrent_Set{playerid}][pd_duelstatus] == DUEL_REQUESTED)
		{
		    if(pDuelAccept[playerid] == true)
		    {
		        pDuelSettings[DuelCurrent_Set{playerid}][pd_accptcnt]--;
		    }
		    DuelDenyRequest(DuelCurrent_Set{playerid}, playerid);
		}
		if(pDuelSettings[DuelCurrent_Set{playerid}][pd_duelstatus] > DUEL_REQUESTED)
		{
		    if(pDuelAccept[playerid] == true)
		    {
		        pDuelSettings[DuelCurrent_Set{playerid}][pd_accptcnt]--;
		    }
		    DuelLeaveDuel(DuelCurrent_Set{playerid}, playerid);
		}
	}
	ClearDuelSettings(playerid);
}

hook OnPlayerConnect(playerid)
{
	ClearDuelSettings(playerid);
}
/***********************COMMANDS FOR DUEL*****************************/

CMD:duel(playerid, params[])
{
	if(DuelCurrent_Set{playerid} != MAX_PLAYERS)
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not do this now.");
	pDuelState{playerid} = 0;
	Duel_ShowCurrentSettings(playerid);
	return 1;
}

CMD:sendduel(playerid, params[])
{
	if(DuelCurrent_Set{playerid} != MAX_PLAYERS)
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not do this now.");
	if(CheckDuelSettings(playerid, 0))
	{
		pDuelState{playerid} = 0;
		Duel_Set_Setting(playerid, 1, 13, "");
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please Finish the Duel-Settings.");
	}
	return 1;
}

CMD:sdr(playerid, params[])
{
	if(DuelCurrent_Set{playerid} != MAX_PLAYERS)
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not do this now.");
	cmd_sendduel(playerid, params);
	return 1;
}

CMD:reduel(playerid, params[])
{
	if(DuelCurrent_Set{playerid} != MAX_PLAYERS)
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not do this now.");
	pDuelState{playerid} = 0;
	Duel_Set_Setting(playerid, 1, 13, "");
	return 1;
}

CMD:acceptduel(playerid, params[])
{
	if(FoCo_Player[playerid][jailed] > 0)
	{
		SendClientMessage(DuelCurrent_Set{playerid}, COLOR_NOTICE, "[DUEL NOTICE]: One of the players in duel settings is in jail. Please edit it.");
		DuelDenyRequest(DuelCurrent_Set{playerid}, playerid);
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't do whilst you're in jail");
	}
    if(GetPVarInt(playerid, "PlayerStatus") != 0)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't duel while you are not in normal world.");
	}
	if(GetPVarInt(playerid, "InEvent") == 1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't duel while you are in event.");
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please wait till you have spawned to do this!");
	}
	new Float:health;
	GetPlayerHealth(playerid, health);
	if(health < 1.0)
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are dead.");

	if(GetPVarInt(playerid, "PlayerStatus") == 2)
	{
		SendClientMessage(DuelCurrent_Set{playerid}, COLOR_NOTICE, "[DUEL NOTICE]: One of the players in duel settings is in duel. Please edit it.");
		DuelDenyRequest(DuelCurrent_Set{playerid}, playerid);
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't do that whilst in another duel.");
	}
	if(DuelCurrent_Set{playerid} == MAX_PLAYERS)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You don't have any pending duel request.");
	}
	if(DuelCurrent_Set{playerid} == playerid)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not accept your own duel request. Please wait ...");
	}
	if(pDuelSettings[DuelCurrent_Set{playerid}][pd_duelstatus] != DUEL_REQUESTED)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Duel status has gone past accepting-state. Contact Tester Team if you never did /acceptduel(Code: #DPAWA.");
	}
	if(pDuelAccept[playerid] == true)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have already accepted the request. Please wait ...");
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please exit your vehicle before accepting duels.");
	}
	if(GetPlayerMoney(playerid) < pDuelSettings[DuelCurrent_Set{playerid}][pd_stake] && pDuelSettings[DuelCurrent_Set{playerid}][pd_stake] != 0)
	{
	    DuelDenyRequest(DuelCurrent_Set{playerid}, playerid);
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not have enough money to accept it.");
	}
	if(!CheckDuelSettings(DuelCurrent_Set{playerid}, 1))
	{
	    SendClientMessage(DuelCurrent_Set{playerid}, COLOR_WARNING, "[ERROR]: It looks like there is error in Duel Settings.");
	    return DuelDenyRequest(DuelCurrent_Set{playerid}, -1);
	}
	pDuelSettings[DuelCurrent_Set{playerid}][pd_accptcnt]++;
	SendClientMessage(playerid, COLOR_NOTICE, "[DUEL NOTICE]: You have sucessfully accepted the duel request.");
	if(pDuelSettings[DuelCurrent_Set{playerid}][pd_accptcnt] == pDuelSettings[DuelCurrent_Set{playerid}][pd_type] * 2)
	{
	    pDuelAccept[playerid] = true;
	    DuelStartDuel(DuelCurrent_Set{playerid});
	}
	else
	{
	    pDuelAccept[playerid] = true;
	    SendClientMessage(playerid, COLOR_NOTICE, "[DUEL NOTICE]: Duel accepeted!!! Do not enter a vehicle till everyone accepts the duel or, it expires. Please wait ...");
	}
	return 1;
}

CMD:ad(playerid, params[])
{
	cmd_acceptduel(playerid, params);
	return 1;
}

CMD:denyduel(playerid, params[])
{
	if(DuelCurrent_Set{playerid} == MAX_PLAYERS)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You dont have any pending duel request.");
	}
	if(pDuelSettings[DuelCurrent_Set{playerid}][pd_duelstatus] == DUEL_REQUESTED)
	{
	    if(pDuelAccept[playerid] == true)
	    {
	        pDuelSettings[DuelCurrent_Set{playerid}][pd_accptcnt]--;
	    }
	    DuelDenyRequest(DuelCurrent_Set{playerid}, playerid);
	}
	else
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not deny the request now. Use /leaveduel to leave duel.");
	}
	return 1;
}

CMD:leaveduel(playerid, params[])
{
	if(DuelCurrent_Set{playerid} == MAX_PLAYERS)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You dont have any pending duel request.");
	}
	new Float:health;
	GetPlayerHealth(playerid, health);
 	if(health < 40.0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your HP is too low to leave the duel.");
		return 1;
	}
	if(pDuelSettings[DuelCurrent_Set{playerid}][pd_duelstatus] == DUEL_STARTED)
	{
	    if(pDuelAccept[playerid] == true)
	    {
	        pDuelSettings[DuelCurrent_Set{playerid}][pd_accptcnt]--;
	    }
	    DuelLeaveDuel(DuelCurrent_Set{playerid}, playerid);
	}
	else if(pDuelSettings[DuelCurrent_Set{playerid}][pd_duelstatus] == DUEL_REQUESTED)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not leave the request yet. Use /denyduel to leave duel.");
	}
	else if(pDuelSettings[DuelCurrent_Set{playerid}][pd_duelstatus] == DUEL_STARTPENDING)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not leaveduel yet. Please wait till the duel starts.");
	}
	return 1;
}

