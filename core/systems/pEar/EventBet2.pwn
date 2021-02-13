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
* Filename: EventBet.pwn                                                         *
* Author: pEar	                                                                 *
*********************************************************************************/
#include <YSI\y_hooks>

/*
	Hooks
	    OnPlayerDisconnect
*/

/* Event ID's
	MADDOGG,            // 0
	BIGSMOKE,           // 1
	MINIGUN,            // 2
	BRAWL,              // 3
	HYDRA,              // 4
	GUNGAME,            // 5
	JEFFTDM,            // 6
	AREA51,             // 7
	ARMYVSTERRORISTS,   // 8
	NAVYVSTERRORISTS,   // 9
	COMPOUND,           // 10
	OILRIG,             // 11
	DRUGRUN,            // 12
	MONSTERSUMO,        // 13
	BANGERSUMO,         // 14
	SANDKSUMO,          // 15
	SANDKSUMORELOADED,  // 16
	DESTRUCTIONDERBY,   // 17
	PURSUIT,            // 18
	PLANE,              // 19
	CONSTRUCTION,       // 20
	HIGHSPEEDPURSUIT    // 21
*/

enum FoCo_Event_Bets_Info
{
	ID,
	Team_1[35],
	Team_2[35]
};

new FoCo_Event_Bets[][FoCo_Event_Bet_Info] = {
	{0, "N/A", "N/A"},
	{1, "N/A", "N/A"},
	{2, "N/A", "N/A"},
	{3, "N/A", "N/A"},
	{4, "N/A", "N/A"},
	{5, "N/A", "N/A"},
	{6, "SWAT", "Terrorists"},
	{7, "Special Forces", "Scientists"},
	{8, "Army", "Terrorists"},
	{9, "Navy", "Terrorists"},
	{10, "SWAT", "Terrorists"},
	{11, "SWAT", "Terrorists"},
	{12, "SWAT", "Terrorists"},
	{13, "N/A", "N/A"},
	{14, "N/A", "N/A"},
	{15, "N/A", "N/A"},
	{16, "N/A", "N/A"},
	{17, "N/A", "N/A"},
	{18, "Cops", "Criminal"},
	{19, "Pilots", "Hobos"},
	{20, "Workers", "Engineers"},
	{21, "Cops", "Criminal"}
};

new
	EventBet[MAX_PLAYERS],				// Valid bet per player
	Total_ID_Bets[MAX_PLAYERS],			// Total bets per ID (maddogs etc)
	Team_ID_Bet[MAX_PLAYERS], 			// What team ID the player betted for
	Player_ID_Bet[MAX_PLAYERS],			// What player ID the player betted for
	
	Can_Bet,							// When player can bet
	Total_Bets,							// Total bet for event
	Team1_Bets,							// Bets for team 1
	Team2_Bets,							// Bets for team 2
	Amount_Bets,						// How many betted
	Team_Bet;							// To determine if its a FFA or TDM
	
	
hook OnPlayerDisconnect(playerid)
{
	EventBet[playerid] = -1;
	return 1;
}

hook OnGameModeInit()
{
	Can_Bet = 0;
}

Bet_Start(EVENT_ID)
{
	Can_Bet = 0;
	switch(EVENT_ID)
	{
		case 2, 4, 13, 14, 15, 16, 17:		// FFA Events.
		{
			SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event using /ebet.");
			Can_Bet = 1;
			Team_Bet = 0;
			Total_Bets = 0;
		}
		case 6, 7, 8, 9, 10, 11, 12, 18, 19, 20, 21:	// Team Events
		{	
			SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event using /ebet.");
			Can_Bet = 1;
			Team_Bet = 1;
			Team1_Bets = 0;
			Team2_Bets = 0;
			Total_Bets = 0;
		}		
		foreach(Player, i)
		{
			EventBet[i] = -1;
			Total_ID_Bets[i] = -1;
			Team_ID_Bet[i] = -1;
			Player_ID_Bet[i] = -1;
		}
	}
	return 1;
}

Event_Started()
{
	Can_Bet = 0;
	new string[128];
	new string1[56];
	new Float:Percentage_F;
	new Percentage;
	new Float:Money_Won_F;
	new Money_Won;
	if(Total_Bets == 0)
	{
		return SendClientMessageToAll(COLOR_GREEN, "[INFO]: The event is in progress and no further bets can be placed. No bets were placed originally, so the pot is 0$.");
	}
	if(Team_Bet == 1)
	{
		if(Team1_Bets < MIN_EVENT_BET || Team2_Bets < MIN_EVENT_BET)
		{
			Refund_EventBet_Money();
			return SendClientMessageToAll(COLOR_GREEN, "[INFO]: The event is in progress and no further bets can be placed. No bets were placed originally, so the pot is 0$.");
		}
		format(string1, sizeof(string1), "(%s: %d - %s: %d). Good luck", FoCo_Event_Bets[Current_Event_On()][Team_1], Team1_Bets, FoCo_Event_Bets[Current_Event_On()][Team_2], Team2_Bets);
		format(string, sizeof(string), "[INFO]: The event is progress and no further bets can be placed. Total pot: %d$ %s", Total_Bets, string1);
		SendClientMessageToAll(COLOR_GREEN, string);
		foreach(Player, i)
		{
			if(EventBet[i] >= MIN_EVENT_BET)
			{
				if(Team_ID_Bet[i] == 1)
				{
					Percetage_F = ((Float:EventBet[i] / Float:Team1_Bets) * 100.0);
					Percentage = floatround(Percentage_F, floatround_ceil);
					Money_Won_F = (((Team2_Bets / 100) * 100.0) * Percentage) * FOCO_EVENT_BET_COST);
					Money_Won = floatround(Money_Won_F, floatround_floor);
					format(string, sizeof(string), "[INFO]: Your bet of %d has been registered. You have a chance at winning %d$ extra.", EventBet[i], Money_Won);
					SendClientMessage(i, COLOR_GREEN, string);
				}
				else
				{
					Percetage_F = ((Float:EventBet[i] / Float:Team2_Bets) * 100.0);
					Percentage = floatround(Percentage_F, floatround_ceil);
					Money_Won_F = (((Team1_Bets / 100) * 100.0) * Percentage) * FOCO_EVENT_BET_COST);
					Money_Won = floatround(Money_Won_F, floatround_floor);
					format(string, sizeof(string), "[INFO]: Your bet of %d has been registered. You have a chance at winning %d$ extra.", EventBet[i], Money_Won);
					SendClientMessage(i, COLOR_GREEN, string);
				}
				
			}
		}
	}
	else
	{
		format(string, sizeof(string), "[INFO]: The event is in progress and no further bets can be placed. Total pot: %d$. Good luck", Total_Bets);
		return SendClientMessageToAll(COLOR_GREEN, string);
	}
}








