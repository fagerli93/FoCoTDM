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

new
	EventBet[MAX_PLAYERS],
	Total_ID_Bets[MAX_PLAYERS],
	Can_Bet,
	Total_Event_Bets,
	Team1_Bets,
	Team2_Bets,
	Total_Bets,
	Team_Bet;

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

forward Event_Bet_Start(EVENTID);
public Event_Bet_Start(EVENTID)
{
	Can_Bet = 0;
	if (EVENTID != 0 || EVENTID != 1 || EVENTID != 3 || EVENTID != 5)
	{
 		switch(EVENTID)
		{
		    case 2:
		    {
		        SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [ID] [Amount] on who-ever you believe will win!");
				Can_Bet = 1;
				Team_Bet = 0;
		    }
		    case 4:
			{
		        SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [ID] [Amount] on who-ever you believe will win!");
				Can_Bet = 1;
				Team_Bet = 0;
			}
			case 6:
			{
				SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where SWAT = 0 and Terrorists = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
			}
			case 7:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where Special Forces = 0 and Scientists = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
			}
			case 8:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where Army = 0 and Terrorists = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
			}
			case 9:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where Navy = 0 and Terrorists = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
			}
			case 10:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where SWAT = 0 and Terrorists = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
			}
			case 11:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where SWAT = 0 and Terrorists = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
			}
			case 12:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where SWAT = 0 and Terrorists = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
			}
			case 13:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [ID] [Amount] on who-ever you believe will win!");
				Can_Bet = 1;
				Team_Bet = 0;
			}
			case 14:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [ID] [Amount] on who-ever you believe will win!");
				Can_Bet = 1;
				Team_Bet = 0;
			}
			case 15:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [ID] [Amount] on who-ever you believe will win!");
				Can_Bet = 1;
				Team_Bet = 0;
			}
			case 16:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [ID] [Amount] on who-ever you believe will win!");
				Can_Bet = 1;
				Team_Bet = 0;
			}
			case 17:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [ID] [Amount] on who-ever you believe will win!");
				Can_Bet = 1;
				Team_Bet = 0;
			}
			case 18:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where Cops = 0 and Evader = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
			}
			case 19:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where Pilots = 0 and Hobos = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
			}
			case 20:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where Workers = 0 and Engineers = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
			}
			case 21:
			{
                SendClientMessageToAll(COLOR_GREEN, "[INFO]: You can place a bet for this event. Use /ebet [Team_ID] [Amount] where Cops = 0 and Evader = 1.");
				Can_Bet = 1;
				Team_Bet = 1;
			}
		}
		Total_Event_Bets = 0;
		Team1_Bets = 0;
		Team2_Bets = 0;
		Total_Bets = 0;
		new i;
		for(i = 0; i <= 200; i++)
		{
		    EventBet[i] = -1;
		    Total_ID_Bets[i] = -1;
		}
	}
	else
	{
	    Can_Bet = 0;
	}
	return 1;
}

forward Event_Bet_NoCanDo();
public Event_Bet_NoCanDo()
{
	Can_Bet = 0;
	new string[128];
	if(Team_Bet == 1)
	{
		format(string, sizeof(string), "[INFO]: The event is in progress and no further bets can be placed. Total pot %d$ (Team 0: %d - Team 1: %d). Good luck!", Total_Event_Bets, Team1_Bets, Team2_Bets);
		SendClientMessageToAll(COLOR_GREEN, string);
	}
	else
	{
	    format(string, sizeof(string), "[INFO]: The event is in progress and no further bets can be placed. Total pot %d$. Good luck!", Total_Event_Bets);
	    SendClientMessageToAll(COLOR_GREEN, string);
	}
}


forward Event_Bet_End(win_team);
public Event_Bet_End(win_team)
{
	new string[128];
	if(Total_Event_Bets != 0)
	{
 		if(Team_Bet == 1)
		{
		    if(Team1_Bets == 0 || Team2_Bets == 0)
		    {
		        if(Team1_Bets == 0)
		        {
		            foreach(Player, i)
		            {
						if(GetPVarInt(i, "TeamBet") == 1)
						{
							format(string, sizeof(string), "[INFO]: There were no bets for the other team, therefore your bet on %d$ has been refunded.", EventBet[i]);
							SendClientMessage(i, COLOR_GREEN, string);
							GivePlayerMoney(i, EventBet[i]);
							EventBet[i] = -1;
							SetPVarInt(i, "TeamBet", -1);
							SetPVarInt(i, "PlayerBet", -1);
						}
		            }
		        }
		        else
		        {
	         		foreach(Player, i)
		            {
						if(GetPVarInt(i, "TeamBet") == 0)
						{
							format(string, sizeof(string), "[INFO]: There were no bets for the other team, therefore your bet on %d$ has been refunded.", EventBet[i]);
							SendClientMessage(i, COLOR_GREEN, string);
							GivePlayerMoney(i, EventBet[i]);
							EventBet[i] = -1;
							SetPVarInt(i, "TeamBet", -1);
							SetPVarInt(i, "PlayerBet", -1);
						}
		            }
		        }
		    }
		    else
		    {
			    if(win_team == 0)
			    {
			        foreach(Player, i)
			        {
			            if(GetPVarInt(i, "TeamBet") == 0)
			            {
			                new Float:Percentage_F;
			                Percentage_F = ((EventBet[i] / Team1_Bets) * 100);
							new Percentage = floatround(Percentage_F, floatround_floor);
			                new Float:Money_Won_F;
			                Money_Won_F = (((Team2_Bets / 100) * Percentage) * FOCO_EVENT_BET_COST);
			                new Money_Won = floatround(Money_Won_F, floatround_floor);
			                GivePlayerMoney(i, Money_Won);
			                GivePlayerMoney(i, EventBet[i]);
			                format(string, sizeof(string), "[INFO]: You have won %d$ extra to your orignal %d$ event bet. Congratulations!", Money_Won, EventBet[i]);
			                SendClientMessage(i, COLOR_GREEN, string);
			                EventBet[i] = -1;
							SetPVarInt(i, "TeamBet", -1);
							SetPVarInt(i, "PlayerBet", -1);
			            }
			            else if(GetPVarInt(i, "TeamBet") == 1)
			            {
			                format(string, sizeof(string), "[INFO]: You have lost %d$ on the event bet.",EventBet[i]);
			                SendClientMessage(i, COLOR_GREEN, string);
			                EventBet[i] = -1;
							SetPVarInt(i, "TeamBet", -1);
							SetPVarInt(i, "PlayerBet", -1);
			            }
			        }
			        return 1;
			    }
			    else
			    {
		     		foreach(Player, i)
			        {
			            if(GetPVarInt(i, "TeamBet") == 1)
			            {
			                new Float:Percentage_F;
			                Percentage_F = ((EventBet[i] / Team2_Bets) * 100);
							new Percentage = floatround(Percentage_F, floatround_floor);
			                new Float:Money_Won_F;
			                Money_Won_F = (((Team1_Bets / 100) * Percentage) * FOCO_EVENT_BET_COST);
			                new Money_Won = floatround(Money_Won_F, floatround_floor);
			                GivePlayerMoney(i, Money_Won);
			                GivePlayerMoney(i, EventBet[i]);
			                format(string, sizeof(string), "[INFO]: You have won %d$ extra to your orignal %d$ event bet. Congratulations!", Money_Won, EventBet[i]);
			                SendClientMessage(i, COLOR_GREEN, string);
			                EventBet[i] = -1;
							SetPVarInt(i, "TeamBet", -1);
							SetPVarInt(i, "PlayerBet", -1);
			            }
			            else if(GetPVarInt(i, "TeamBet") == 0)
			            {
			                format(string, sizeof(string), "[INFO]: You have lost %d$ on the event bet.",EventBet[i]);
			                SendClientMessage(i, COLOR_GREEN, string);
			                EventBet[i] = -1;
							SetPVarInt(i, "TeamBet", -1);
							SetPVarInt(i, "PlayerBet", -1);
			            }
			        }
			    }
      		}

		}
		else
		{
		    if(Total_Bets != 0)
		    {
			    if(Total_Bets != 1)
			    {
       				foreach(Player, i)
					{
					    if(GetPVarInt(i, "PlayerBet") == win_team)
					    {
			      			new Float:Percentage_F;
			  				Percentage_F = ((EventBet[i] / Total_ID_Bets[win_team]) * 100);
							new Percentage = floatround(Percentage_F, floatround_floor);
			  				new Float:Money_Won_F;
			  				new Float:Money_Tot;
			  				Money_Tot = (Total_Event_Bets - Total_ID_Bets[win_team]);
			  				Money_Won_F = (((Money_Tot / 100) * Percentage) * FOCO_EVENT_BET_COST);
			  				new Money_Won = floatround(Money_Won_F, floatround_floor);
			  				GivePlayerMoney(i, Money_Won);
			  				GivePlayerMoney(i, EventBet[i]);
					        format(string, sizeof(string), "[INFO]: You won %d$ on your %d$ event bet. Congratulations!", Money_Won, EventBet[i]);
					        SendClientMessage(i, COLOR_GREEN, string);
					        EventBet[i] = -1;
							SetPVarInt(i, "TeamBet", -1);
							SetPVarInt(i, "PlayerBet", -1);
					    }
					    else
					    {
					        if(EventBet[i] != -1)
					        {
					            format(string, sizeof(string), "[INFO]: You lost your bet on %d$", EventBet[i]);
						        SendClientMessage(i, COLOR_GREEN, string);
						        EventBet[i] = -1;
								SetPVarInt(i, "TeamBet", -1);
								SetPVarInt(i, "PlayerBet", -1);
					        }
					    }
					}
			    }
			    else
			    {
			        foreach(Player, i)
			        {
			            if(GetPVarInt(i, "PlayerBet") != -1)
			            {
			                format(string, sizeof(string), "[INFO]: You were the only one to put up a bet, therefore your %d$ has been refunded.", EventBet[i]);
			        		SendClientMessage(i, COLOR_GREEN, string);
			        		GivePlayerMoney(i, EventBet[i]);
			        		EventBet[i] = -1;
							SetPVarInt(i, "TeamBet", -1);
							SetPVarInt(i, "PlayerBet", -1);
			            }
			        }
			    }
		    }
		}
	}
	return 1;
}

forward Event_Bet_CancelEvent();
public Event_Bet_CancelEvent()
{
	new string[128];
	foreach(Player, i)
	{
	    if(EventBet[i] != -1)
	    {
	        format(string, sizeof(string), "[INFO]: The event was cancelled so your bet on %d$ has been refunded.", EventBet[i]);
	        GivePlayerMoney(i, EventBet[i]);
	        SetPVarInt(i, "TeamBet", -1);
	        SetPVarInt(i, "PlayerBet", -1);
	        EventBet[i] = -1;
	    }
	}
	Total_Event_Bets = -1;
	return 1;
}

CMD:ebet(playerid, params[])
{
	if (Can_Bet == 1)
 	{
  		if(EventBet[playerid] > -1)
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
   	    	if(amount < MIN_EVENT_BET || amount > MAX_EVENT_BET)
    	    {
    	        format(string, sizeof(string), "[ERROR]: Bet must be higher than %d$ and lower than %d$.", MIN_EVENT_BET, MAX_EVENT_BET);
				SendClientMessage(playerid, COLOR_WARNING, string);
				return 1;
    		}
 	    	if(option != 0 || option != 1)
  	    	{
        		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Team ID must be either 0 or 1");
 	        	return 1;
  	    	}
  	    	if(option == 0)
  	    	{
  	    	    SetPVarInt(playerid, "TeamBet", option);
   	    		EventBet[playerid] = amount;
   	    		new money = (GetPlayerMoney(playerid) - amount);
	    	    SetPlayerMoney(playerid, money);
	    	    format(string, sizeof(string), "[INFO]: Your bet on team ID %d for %d$ has been set. Good luck!", option, amount);
	    	    SendClientMessage(playerid, COLOR_GREEN, string);
	    	    Total_Event_Bets = Total_Event_Bets + amount;
	    	    Team1_Bets = Team1_Bets + amount;
	    	    return 1;
  	    	}
  	    	else
  	    	{
  	    	    SetPVarInt(playerid, "TeamBet", option);
   	    		EventBet[playerid] = amount;
   	    		new money = (GetPlayerMoney(playerid) - amount);
	    	    SetPlayerMoney(playerid, money);
	    	    format(string, sizeof(string), "[INFO]: Your bet on team ID %d for %d$ has been set. Good luck!", option, amount);
	    	    SendClientMessage(playerid, COLOR_GREEN, string);
	    	    Total_Event_Bets = Total_Event_Bets + amount;
	    	    Team2_Bets = Team2_Bets + amount;
	    	    return 1;
  	    	}
       	}
       	else
       	{
   	    	if(sscanf(params, "ui", targetid, amount))
    	    {
	        	SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /ebet [ID] [Amount]");
	        	return 1;
     	    }
          	if(amount < MIN_EVENT_BET || amount > MAX_EVENT_BET)
      	    {
					format(string, sizeof(string), "[ERROR]: Bet must be higher than %d$ and lower than %d$.", MIN_EVENT_BET, MAX_EVENT_BET);
					SendClientMessage(playerid, COLOR_WARNING, string);
					return 1;
    		}
    		if(targetid == playerid)
    		{
    		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot put a bet on yourself!");
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
       	    new money = (GetPlayerMoney(playerid) - amount);
       	    SetPlayerMoney(playerid, money);
       	    format(string, sizeof(string), "[INFO]: Your bet on %s(%d) for %d$ has been set. Good luck!", PlayerName(targetid), targetid, amount);
       	    SendClientMessage(playerid, COLOR_GREEN, string);
       	    Total_ID_Bets[targetid] = Total_ID_Bets[targetid] + amount;
       	    Total_Bets = Total_Bets + 1;
       	    Total_Event_Bets = Total_Event_Bets + amount;
       	    return 1;
       	}
    }
    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is no valid event to bet on!");
    return 1;
}

CMD:cancelebet(playerid, params[])
{
	new string[128];
	if(Can_Bet == 1)
	{
 		GivePlayerMoney(playerid, EventBet[playerid]);
		format(string, sizeof(string), "[INFO]: You have cancelled your hit for %d$.", EventBet[playerid]);
		SendClientMessage(playerid, COLOR_GREEN, string);
		Total_Event_Bets = (Total_Event_Bets - EventBet[playerid]);
		if(Team_Bet == 1)
		{
		    if(GetPVarInt(playerid, "Teambet") == 0)
		    {
		        Team1_Bets = (Team1_Bets - EventBet[playerid]);
		    }
		    else
		    {
		        Team2_Bets = (Team2_Bets - EventBet[playerid]);
		    }
		}
		else
		{
		    new who;
		    who = GetPVarInt(playerid, "PlayerBet");
		    Total_ID_Bets[who] = (Total_ID_Bets[who] - EventBet[playerid]);
		}
		SetPVarInt(playerid, "TeamBet", -1);
		SetPVarInt(playerid, "PlayerBet", -1);
		EventBet[playerid] = -1;
		return 1;
	}
	SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The event is in progress and you can't cancel your bet");
	return 1;
}
