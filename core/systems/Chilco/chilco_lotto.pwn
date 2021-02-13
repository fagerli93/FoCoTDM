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
* Filename: chilco_lotto  .pwn                                                   *
* Author: Chilco                                                                 *
*********************************************************************************/
#include <YSI\y_hooks>

#define LOTTO_MAX_POT 500000
//new LottoTimer;
new LottoPot;

// public OnGameModeInit()
hook OnGameModeInit()
{
	SetTimer("Lotto", 3000000, false); // 50 Minutes.
	LottoPot = 5000;
	return 1;
}

/* General information:
   The lotto is every hour. Ten as well as five minutes before the draw an announcement will be made
   with the time remaining until the next draw and what the amount of the pot is.

   Tickets cost $500 and the numbers of the tickets can range from 1-100. Players can only buy one ticket
   at the time and cannot buy a ticket that is already bought by another player.

   If the draw doesn't land on a bought number, the pot will over to the next draw with an additional
   15% of the pot at the time.

   If the draw does land on a number of a player, that player will win 75% of the pot as 25% goes to FoCo.
	- Possibly an achievement for winning the lottery?                                                     */
	
	
/* Commands added:
    - /buyticket [1-100]
	- /lotto (showing the current pot of the lottery as well as your own ticket number)
	                                                                                      */

new lotto_msg;
forward Lotto();
public Lotto()
{
	new message_string[180];
	if(lotto_msg == 0)
	{
     	lotto_msg ++;
     	format(message_string,sizeof(message_string),"[LOTTO]: The lottery draw will take place in 10 minutes! (Current pot: $%d) Use /buyticket to buy a ticket for $500!", LottoPot);
		SendClientMessageToAll(COLOR_LIGHTGREEN, message_string);
		SetTimer("Lotto", 300000, false); // 5 Minutes.
		return 1;
	}
	else if(lotto_msg == 1)
	{
	    lotto_msg ++;
		format(message_string,sizeof(message_string),"[LOTTO]: The lottery draw will take place in 5 minutes! (Current pot: $%d) Use /buyticket to buy a ticket for $500!", LottoPot);
		SendClientMessageToAll(COLOR_LIGHTGREEN, message_string);
		SetTimer("Lotto", 300000, false); // 5 Minutes.
		return 1;
	}
	else if(lotto_msg == 2)
	{
	    // Lottery draw.
	    lotto_msg = 0;

		new DrawnNumber = randomEx(1,100);
		
		new lotterywon;
		foreach(Player,i)
		{
	    	if(GetPVarInt(i, "LottoNumber") == DrawnNumber)
	    	{
	    	    new pName[MAX_PLAYER_NAME];
	    	    GetPlayerName(i, pName, sizeof(pName));
	    	    format(message_string,sizeof(message_string),"[LOTTO]: Number %d was drawn: %s has won $%d with the lottery!", DrawnNumber, pName, LottoPot);
				SendClientMessageToAll(COLOR_LIGHTGREEN, message_string);
				format(message_string,sizeof(message_string),"[NOTICE]: 25 percent of the pot will go to the server. You receive: $%d.", LottoPot/100*75);
				SendClientMessage(i, COLOR_NOTICE, message_string);
				
				format(message_string,sizeof(message_string),"~g~$$$ Congratulations! $$$~n~~w~YOU WON THE LOTTERY~n~~g~$%d", LottoPot/100*75);
				GameTextForPlayer(i, message_string, 6000, 3);
				GivePlayerMoney(i, LottoPot/100*75);
				new moneystring[256];
				format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ by winning the lottery.", PlayerName(i), i, LottoPot/100*75);
				MoneyLog(moneystring);
				
				// Achievement maybe?
				
				lotterywon ++;
				LottoPot = 5000;
	    	}
		}
		if(lotterywon == 0)
		{
			format(message_string,sizeof(message_string),"[LOTTO]: Number %d was drawn, but noone picked this number. The pot of $%d will roll over to the next draw.", DrawnNumber, LottoPot);
			SendClientMessageToAll(COLOR_LIGHTGREEN, message_string);
			
			if(LottoPot > 49999 && LottoPot < 100000)
			{
			    new RandomNewLottoPot = LottoPot/100*2; // The amount added to the pot. (2% of the pot + the pot)
				LottoPot = LottoPot+RandomNewLottoPot;
			}
			if(LottoPot < 50000)
			{
				new RandomNewLottoPot = LottoPot/100*8; // The amount added to the pot. (8% of the pot + the pot)
				LottoPot = LottoPot+RandomNewLottoPot;
			}
			
			if(LottoPot > LOTTO_MAX_POT)
			{
			    LottoPot = LOTTO_MAX_POT;
			}
		}
		foreach(Player,i)
		{
		    SetPVarInt(i, "LottoNumber", 0); // Reseting lotto number to 0 for everyone.
		}
		SetTimer("Lotto", 3000000, false); // 50 Minutes.
		return 1;
	}

	return 1;
}

CMD:lotto(playerid, params[])
{
    new message_string[180], ticketcount;
    format(message_string,sizeof(message_string),"[LOTTO]: Current prize pot: $%d. To get a chance to win this, use /buyticket for $500.", LottoPot);
	SendClientMessage(playerid, COLOR_NOTICE, message_string);
	foreach(Player,i)
	{
		if(GetPVarInt(i, "LottoNumber") > 0)
		{
		    ticketcount ++;
		}
	}
	format(message_string,sizeof(message_string),"[LOTTO]: Your number: None - Total tickets bought: %d.", GetPVarInt(playerid, "LottoNumber"), ticketcount);
	if(GetPVarInt(playerid, "LottoNumber") > 0)
	{
		format(message_string,sizeof(message_string),"[LOTTO]: Your number: %d % Total tickets bought: %d.", GetPVarInt(playerid, "LottoNumber"), ticketcount);
	}
	SendClientMessage(playerid, COLOR_NOTICE, message_string);
	return 1;
}


CMD:buyticket(playerid, params[])
{
	new number;
	if(sscanf(params, "d", number))
	{
 		SendClientMessage(playerid, 0x999999FF, "USAGE: /buyticket [1-100] (Price is $500)");
 		return 1;
	}
	
	if(GetPVarInt(playerid, "LottoNumber") > 0) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You already have a lottery ticket.");
	if(number < 1 || number > 100) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The number must be from 1-100.");
	foreach(Player,i)
	{
	    if(GetPVarInt(i, "LottoNumber") == number) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Somebody else has already taken this number.");
	}
	
	if(GetPlayerMoney(playerid) < 500) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need $500 to buy a lottery ticket.");
	
	GivePlayerMoney(playerid, -500);
	new moneystring[128];
	format(moneystring, sizeof(moneystring), "%s(%d) lost %d $ by entering the lottery.", PlayerName(playerid), playerid, 500);
	MoneyLog(moneystring);
	new message_string[180];
	format(message_string,sizeof(message_string),"[LOTTO]: You have bought lottery ticket number %d for $500.", number);
	LottoPot=LottoPot+500;
	SendClientMessage(playerid, COLOR_NOTICE, message_string);
	SetPVarInt(playerid, "LottoNumber", number);

	return 1;
}


stock randomEx(min, max)
{
    new rand9 = random(max-min)+min;
    return rand9;
} // Credits to YLess

