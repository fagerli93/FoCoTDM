stock GivePlayerMoneyEx(playerid, amount)
{
	ResetPlayerMoney(playerid);
    AC[playerid][Money] = AC[playerid][Money] + amount;
    
    if(AC[playerid][Money] > AC[playerid][MaxMoney])
    {
		AC[playerid][MaxMoney] = AC[playerid][Money];
	}

    return GivePlayerMoney(playerid, AC[playerid][Money]);
}

#if defined _ALS_GivePlayerMoney
    #undef GivePlayerMoney
#else
    #define _ALS_GivePlayerMoney
#endif
#define GivePlayerMoney GivePlayerMoneyEx

enum E_AC_CHECK
{
	Money,
	MaxMoney,
	MoneyWrn
};

new AC[MAX_PLAYERS][E_AC_CHECK];

forward AC_MoneyCheck();

forward AC_OnGameModeInit();
public AC_OnGameModeInit()
{
	SetTimer("AC_MoneyCheck", 5000, true);
}

forward AC_OnPlayerConnect(playerid);
public AC_OnPlayerConnect(playerid)
{
	AC[playerid][Money] = 0;
	AC[playerid][MaxMoney] = 0;
	AC[playerid][MoneyWrn] = 0;
	return 1;
}

/* log in callback or whatever it is in the script */
forward AC_OnPlayerLogin(playerid);
public AC_OnPlayerLogin(playerid)
{
    AC[playerid][Money] = whatever the value in the db is;
    AC[playerid][MaxMoney] = AC[playerid][Money];
    return 1;
}

public AC_MoneyCheck()
{
	foreach(new i, Player)
	{
	    if(AC[i][Money] > AC[i][MaxMoney] || GetPlayerMoney(i) > AC[i][Money])
	    {
	        if(AC[i][MoneyWrn] > 3)
	        {
				new str[128];
				format(string, sizeof(string), "*** AC: %s has been banned for hacking money. ***", PlayerName(i));
				SendClientMessageToAll(COLOR_PURPLE, str);
				SendClientMessage(i, COLOR_PURPLE, "You have been banned for hacking money.");
				AC_BAN(i, "Money Hacks [AC]");
	        }
	        
	        else
	        {
	            AC[i][MoneyWrn]++;
	        }
	    }
	}
	
	return 1;
}

forward AC_BAN(playerid, const str[]);
public AC_BAN(playerid, const str[])
{
	SetTimerEx("AC_BanEx", 500, false, "ds", playerid, str);
	
}

forward AC_BanEx(playerid, const str[]);
public AC_BanEx(playerid, const str[])
{
	BanEx(playerid, str);
}


