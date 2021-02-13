#define EVENT_KILL_MONEY 50
#define DUEL_KILL_MONEY 50
#define MONEY_ON_TK_FOR_PID 100
#define MONEY_ON_TK_FOR_KILLERID 
#define KILL_MONEY 

forward TakeMoneyOnKill(playerid, killerid, money, death_bonus_playerid, death_bonus_killerid);
public TakeMoneyOnKill(playerid, killerid, money, death_bonus_playerid, death_bonus_killerid)
{
	new string[64], TK, deathLoss, money;
	if(playerid != INVALID_PLAYER_ID)
	{
		if(killerid != INVALID_PLAYERID)
		{
			/* They are in the same team -> Should get punished? */
			if(FoCo_Team[killerid] == FoCo_Team[playerid])
			{
				/* Players are not in any event, so punishable. */
				if(GetPVarInt(killerid, "PlayerStatus") != 1)
				{
					/* Duel exception? */
					if(GetPVarInt(playerid, "DuelException") != 1)
					{
						/* He was TKd outside a duel, so playerid gets 100 dollar */
						GivePlusMoney(playerid, MONEY_ON_TK_FOR_PID);
						TKPunishment(killerid);
						return 1;
					}
					/* He was killed in a duel, so not TKing.*/
					else
					{
						MoneyPlus(playerid, killerid, DUEL_KILL_MONEY);
						return 1;
					}
				}
				/* Players are in an event, punish accordingly.*/
				else
				{
					/* Events where they shouldn't get punished..*/
					if(Event_FFA == 1)
					{
						MoneyPlus(playerid, killerid, EVENT_KILL_MONEY);
						return 1;
					}
					/* Events where they should get punished for TKing! */
					else
					{
						/* Events may have an exception, has to check if they are on the same team. They are first.*/
						if(GetPVarInt(playerid, "MotelTeamIssued") == GetPVarInt(killerid, "MotelTeamIssued"))
						{
							GivePlusMoney(playerid, MONEY_ON_TK_FOR_PID);
							TKPunishment(killerid);
							return 1;
						}
						/* Not in the same team in the event.*/
						else
						{
							MoneyPlus(playerid, killerid, EVENT_KILL_MONEY);
							return 1;
						}
					}

					
				}
			}
			/* They are not in the same team. No punishment atleast.*/
			else
			{
				money = MoneyOnNormalKill(playerid, killerid);
				MoneyPlus(playerid, killerid, money);
				VIPBonus(playerid, VIPBonusCheck(playerid));
				BonusCheck(playerid, killerid);
			}
		}
		/* Invalid killerid, so they /kill'd, suicided or somehow died without a killer. Lose money.*/
		else
		{
			if(GetPlayerMoney(playerid) - KILL_SUICIDE >= 0)
			{
				GiveMinusMoney(playerid, KILL_SUICIDE);
			}
		}
	}
	else
	{
		return 1;
	}
	return 1;
}

forward MoneyOnNormalKill(playerid, killerid);
public MoneyOnNormalKill(playerid, killerid)
{
	new money = 0, money_int, spree_money;
	
	money = (KILL_CASH + (FoCo_Player[playerid][level]-FoCo_Player[killerid][level])*10);
	money_int = floatround(money, floatround_floor);
	if(CurrentKillStreak[killerid] >= 5)
	{
		if(CurrentKillStreak[killerid] >= 100)
		{
			spree_money = (money_int * 2);
			money_int = floatround(spree_money, floatround_floor);
			format(string, sizeof(string), "[INFO]: %s (%d) is currently on a %d spree! Use /loc to find his location and earn a MASSIVE reward for killing him!", PlayerName(killerid), killerid, CurrentKillStreak[killerid]);
			SendClientMessageToAll(COLOR_GREEN, string);
		}
		else if(CurrentKillStreak[killerid] >= 90)
		{
			spree_money = (money_int * 1.9);
			money_int = floatround(spree_money, floatround_floor);
		}
		else if(CurrentKillStreak[killerid] >= 80)
		{
			spree_money = (money_int * 1.8);
			money_int = floatround(spree_money, floatround_floor);
		}
		else if(CurrentKillStreak[killerid] >= 70)
		{
			spree_money = (money_int * 1.7);
			money_int = floatround(spree_money, floatround_floor);
		}
		else if(CurrentKillStreak[killerid] >= 60)
		{
			spree_money = (money_int * 1.6);
			money_int = floatround(spree_money, floatround_floor);
		}
		else if(CurrentKillStreak[killerid] >= 50)
		{
			spree_money = (money_int * 1.5);
			money_int = floatround(spree_money, floatround_floor);
		}
		else if(CurrentKillStreak[killerid] >= 40)
		{
			spree_money = (money_int * 1.4);
			money_int = floatround(spree_money, floatround_floor);
		}
		else if(CurrentKillStreak[killerid] >= 30)
		{
			spree_money = (money_int * 1.3);
			money_int = floatround(spree_money, floatround_floor);
		}
		else if(CurrentKillStreak[killerid] >= 20)
		{
			spree_money = (money_int * 1.2);
			money_int = floatround(spree_money, floatround_floor);
		}
		else
		{
			spree_money = (money_int * 1.1);
			money_int = floatround(spree_money, floatround_floor);
		}
	}
	return money_int;
}

forward MoneyPlus(playerid, killerid, amount);
public MoneyPlus(playerid, killerid, amount)
{
	new deathLoss;
	deathLoss = MoneyLossOnDeath(playerid);
	GiveMinusMoney(playerid, deathLoss);
	GivePlusMoney(killerid, amount);
}

forward GivePlusMoney(pid, amount);
public GivePlusMoney(pid, amount)
{
	new string[10];
	GivePlayerMoney(pid, amount);
	new moneystring[256];
	format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from GivePlusMoney.", PlayerName(pid), pid, amount);
	MoneyLog(moneystring);
	format(string, sizeof(string), "~g~+%d", amount);
	TextDrawSetString(MoneyDeathTD[pid], string);
	TextDrawShowForPlayer(pid,MoneyDeathTD[pid]);
	defer cashTimer(pid);
	return 1;
}

forward GiveMinusMoney(pid, amount);
public GiveMinusMoney(pid, amount)
{
	new string[10];
	GivePlayerMoney(pid, -amount);
	new moneystring[256];
	format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ from GiveMinusMoney.", PlayerName(pid), pid, amount);
	MoneyLog(moneystring);
	format(string, sizeof(string), "~r~-%d", amount);
	TextDrawSetString(MoneyDeathTD[pid], string);
	TextDrawShowForPlayer(pid,MoneyDeathTD[pid]);
	defer cashTimer(pid);
	return 1;
}

forward MoneyLossOnDeath(pid);
public MoneyLossOnDeath(pid)
{
	new money = GetPlayerMoney(pid);
	new Float:death_money = ((money / 100) * 0.1);
	new death_money_int = floatround(death_money, floatround_floor);
	
	if (death_money_int > MAX_DEATH_CASH)
	{
		return 250;
	}
	else if(death_money_int < MIN_DEATH_CASH)
	{
		return 25;
	}
	else
	{
		return death_money_int;
	}
}

forward VIPBonus(playerid, amount);
public VIPBonus(playerid, amount)
{
	if(amount > 0)
	{
		format(string, sizeof(string), "~g~VIP +%d",amount);
		TextDrawSetString(MoneyDeathVIPTD[playerid], string);
		GivePlayerMoney(playerid,vip_bonus);
		new moneystring[256];
		format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from VIPBonus.", PlayerName(playerid), playerid, amount);
		MoneyLog(moneystring);
		TextDrawShowForPlayer(playerid, MoneyDeathVIPTD[playerid]);
		defer cashVIPTimer(playerid);
	}
	return 1;
}

forward BonusCheck(pid, killerid, death_bonus_playerid, death_bonus_killerid);
public BonusCheck(pid, killerid, death_bonus_playerid, death_bonus_killerid)
{
	new string[56];
	new death_bonus_team;
	if(death_bonus_playerid > 0)
	{
		format(string, sizeof(string), "~g~Bonus +%d",death_bonus_playerid);
		TextDrawSetString(MoneyDeathVIPTD[pid], string);
		GivePlayerMoney(pid,death_bonus_playerid);
		new moneystring[256];
		format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from death_bonus_playerid.", PlayerName(pid), pid, death_bonus_playerid);
		MoneyLog(moneystring);
		TextDrawShowForPlayer(pid, MoneyDeathVIPTD[pid]);
		defer cashVIPTimer(pid);
		death_bonus_team = death_bonus_playerid * 3;
		if(death_bonus_team > 480)
		{
			foreach(Player, i)
			{
				if(FoCo_Team[i] == FoCo_Team[pid])
				{
					format(string, sizeof(string), "~g~Bonus +1000");
					TextDrawSetString(MoneyDeathVIPTD[i], string);
					GivePlayerMoney(i,1000);
					new moneystring[256];
					format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from Team_Bonus_Foreach.", PlayerName(i), i, 1000);
					MoneyLog(moneystring);
					TextDrawShowForPlayer(i, MoneyDeathVIPTD[i]);
					defer cashVIPTimer(i);
				}
			}
		}
	}
	if(death_bonus_killerid > 0)
	{
		format(string, sizeof(string), "~g~Bonus +%d",death_bonus_killerid);
		TextDrawSetString(MoneyDeathVIPTD[killerid], string);
		GivePlayerMoney(killerid,death_bonus_killerid);
		new moneystring[256];
		format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from death_bonus_killerid.", PlayerName(killerid), killerid, death_bonus_killerid);
		MoneyLog(moneystring);
		TextDrawShowForPlayer(killerid, MoneyDeathVIPTD[killerid]);
		defer cashVIPTimer(killerid);
		death_bonus_team = death_bonus_killerid * 3;
		if(death_bonus_team > 480)
		{
			foreach(Player, i)
			{
				if(FoCo_Team[i] == FoCo_Team[killerid])
				{
					format(string, sizeof(string), "~g~Bonus +1000");
					TextDrawSetString(MoneyDeathVIPTD[i], string);
					GivePlayerMoney(i,1000);
					new moneystring[256];
					format(moneystring, sizeof(moneystring), "%s(%d) gained %d$ from Team_KillerID_Bonus_Foreach.", PlayerName(i), i, 1000);
					MoneyLog(moneystring);
					TextDrawShowForPlayer(i, MoneyDeathVIPTD[i]);
					defer cashVIPTimer(i);
				}
			}
		}
	}
	return 1;
}

forward VIPBonusCheck(playerid);
public VIPBonusCheck(playerid)
{
	if(isVIP(playerid) == 1 || AdminLvl(playerid) == 1 || AdminLvl(playerid) == 2)
	{
		return 20;
	}
	else if(isVIP(playerid) == 2 || AdminLvl(playerid) == 3 || AdminLvl(playerid) == 4)
	{
		return 40;

	}
	else if(isVIP(playerid) == 3 || AdminLvl(playerid) == 5)
	{
		return 60;
	}
	else
	{
		return 0;
	}
}
