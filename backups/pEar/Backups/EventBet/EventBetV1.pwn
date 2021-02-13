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
	    OnPlayerConnect
	    OnPlayerDisconnect
*/

new EventBet[MAX_PLAYERS];

new
    Can_Bet,
	Team_Bet,
	User_Bet;



hook OnPlayerConnect(playerid)
{
	EventBet[playerid] = -1;
}
hook OnPlayerDisconnect(playerid)
{
	EventBet[playerid] = -1;
}

/*
	Starts the betting process.
*/

forward Event_Bet_Start(playerid, Event_ID);
public Event_Bet_Start(playerid, Event_ID)
{
	new string[128];
	Can_Bet = 0;
	if (Event_ID != MADDOGG || Event_ID != BIGSMOKE || Event_ID != BRAWL || Event_ID != GUNGAME)
	{
 		switch(Event_ID)
		{
		    case MINIGUN:
		    {
		        SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [ID] [Amount] on who-ever you believe will win!");
				Can_Bet = 1;
				Team_Bet = 0;
				User_Bet = 1;
		    }
		    case HYDRA:
			{
		        SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [ID] [Amount] on who-ever you believe will win!");
				Can_Bet = 1;
				Team_Bet = 0;
				User_Bet = 1;
			}
			case JEFFTDM:
			{
				SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where SWAT = 0 and Terrorists = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
				User_Bet = 0;
			}
			case AREA51:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where Special Forces = 0 and Scientists = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
				User_Bet = 0;
			}
			case ARMYVSTERRORISTS:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where Army = 0 and Terrorists = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
				User_Bet = 0;
			}
			case NAVYVSTERRORISTS:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where Navy = 0 and Terrorists = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
				User_Bet = 0;
			}
			case COMPOUND:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where SWAT = 0 and Terrorists = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
				User_Bet = 0;
			}
			case OILRIG:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where SWAT = 0 and Terrorists = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
				User_Bet = 0;
			}
			case DRUGRUN:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where SWAT = 0 and Terrorists = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
				User_Bet = 0;
			}
			case MONSTERSUMO:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [ID] [Amount] on who-ever you believe will win!");
				Can_Bet = 1;
				Team_Bet = 0;
				User_Bet = 1;
			}
			case BANGERSUMO:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [ID] [Amount] on who-ever you believe will win!");
				Can_Bet = 1;
				Team_Bet = 0;
				User_Bet = 1;
			}
			case SANDSUMO:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [ID] [Amount] on who-ever you believe will win!");
				Can_Bet = 1;
				Team_Bet = 0;
				User_Bet = 1;
			}
			case SANDKSUMORELOADED:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [ID] [Amount] on who-ever you believe will win!");
				Can_Bet = 1;
				Team_Bet = 0;
				User_Bet = 1;
			}
			case DESTRUCTIONDERBY:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [ID] [Amount] on who-ever you believe will win!");
				Can_Bet = 1;
				Team_Bet = 0;
				User_Bet = 1;
			}
			case PURSUIT:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where Cops = 0 and Evader = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
				User_Bet = 0;
			}
			case PLANE:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where Pilots = 0 and Hobos = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
				User_Bet = 0;
			}
			case CONSTRUCTION:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where Workers = 0 and Engineers = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
				User_Bet = 0;
			}
			case HIGHSPEEDPURSUIT:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where Cops = 0 and Evader = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
				User_Bet = 0;
			}
		}
		return 1;
	}
	else
	{
	    Can_Bet = 0;
	    return 1;
	}
}

CMD:ebet(playerid, params[])
{
	if(Event_InProgress != -1)
	{
	    if (Can_Bet != 1)
	    {
	        if(Event_Bet[playerid] > -1)
	        {
	            SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have already placed a bet on for this event. Use /cancelebet if you wish to re-do it.");
	            return 1;
        	}
        	new targetid, option, amount, string[128];
        	if(Team_Bet == 1)
        	{
        	    if(sscanf(params, "ii", option, amount))
        	    {
        	        SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /ebet [Team ID] [Amount]");
        	        return 1;
        	    }
        	    if(amount < 2000 || amount > 25000)
        	    {
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Bet must be higher than 2,000 and lower than 25,000");
					return 1;
        	    }
        	    if(option != 0 || option != 1)
        	    {
        	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Team ID must be either 0 or 1");
        	        return 1;
        	    }
        	    SetPVarInt(playerid, "TeamBet", option);
        	    EventBet[playerid] = amount;
        	    new money = (GetPlayerMoney(playerid) - EventBet[playerid]);
        	    SetPlayerMoney(playerid, money);
        	    format(string, sizeof(string), "[INFO]: Your bet on team ID %d for %d$ has been set. Good luck!", option, amount);
        	    SendClientMessage(playerid, COLOR_GREEN, string);
        	    Total_Event_Bets = Total_Event_Bets + EventBet[playerid];
        	    return 1;
        	}
        	else
        	{
        	    if(sscanf(params, "ui", targetid, amount))
        	    {
        	        SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /ebet [ID] [Amount]");
        	        return 1;
        	    }
                if(amount < 2000 || amount > 25000)
        	    {
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Bet must be higher than 2,000 and lower than 25,000");
					return 1;
        	    }
        	    if(targetid == INVALID_PLAYER_ID)
        	    {
        	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid ID/Name");
        	        return 1;
        	    }
        	    if(GetPVarInt(targetid, "InEvent") != 1)
        	    {
        	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This player has not joined  the event yet");
        	        return 1;
        	    }
        	    SetPVarInt(playerid, "PlayerBet", targetid);
        	    EventBet[playerid] = amount;
        	    new money = (GetPlayerMoney(playerid) - EventBet[playerid]);
        	    SetPlayerMoney(playerid, money);
        	    format(string, sizeof(string), "[INFO]: Your bet on %s(%d) for %d$ has been set. Good luck!", PlayerName(targetid), targetid, amount);
        	    SendClientMessage(playerid, COLOR_GREEN, string);
        	    Total_Event_Bets = Total_Event_Bets + EventBet[playerid];
        	    return 1;
        	}
	    }
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot place a bet on this event!");
	    return 1;
	}
	SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is no event in progress!");
	return 1;
}

CMD:cancelebet(playerid, params[])
{
	SetPVarInt(playerid, "TeamBet", -1);
	SetPVarInt(playerid, "PlayerBet", -1);
	GivePlayerMoney(playerid, EventBet[playerid]);
	EventBet[playerid] = -1;
}
