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
* Filename: chilco_ammunation.pwn                                                *
* Author: Chilco                                                                 *
*********************************************************************************/
#include <YSI\y_hooks>

#define RPG_COOLDOWN 900	// 15 minutes in seconds
#define MAX_RPGS 1
#define MAX_GRENADES 3
#define MAX_MOLOS 3
#define MAX_SATCHELS 5

//=====================================[PRICES]===========================================
#define PRICE_KNUCKLES 100
#define PRICE_SHOVEL 100
#define PRICE_KATANA 100
#define PRICE_CHAINSAW 5000
#define PRICE_GRENADE 2500
#define PRICE_TEARGAS 200
#define PRICE_MOLOTOV 2500
#define PRICE_LAUNCHER 5000
#define PRICE_SATCHEL 1000
#define PRICE_RPG 15000

#define PRICE_COLT 6
#define PRICE_SILENCE 5
#define PRICE_DEAGLE 10
#define PRICE_SHOTGUN 7
#define PRICE_SAWNOFF 9
#define PRICE_COMBAT 9
#define PRICE_SMG 7
#define PRICE_MP5 7
#define PRICE_AK47 9
#define PRICE_M4 10
#define PRICE_TEC9 5
#define PRICE_SNIPER 30
#define PRICE_FLAME 1000

new RPG_cooldown[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
	RPG_cooldown[playerid] = gettime();
	return 1;
}

/* =============================================================================*/
// ||||||||||||||||              VIP commands part:             |||||||||||||||||
/* =============================================================================*/
/*
CMD:vann(playerid, params[])
{
    new announcement[144], msgstring[144];
    if(sscanf(params, "s[144]", announcement))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /vann [message] (You can only make one each 20 minutes)");
		return 1;
	}
	else
	{
	    new CurrentTime = gettime();
	    new difference = CurrentTime - GetPVarInt(playerid, "LastTime_Vann_Sec");
	    new totalsecleft = 1200-difference;
		new minutes = totalsecleft/60;
		new seconds = totalsecleft-minutes*60;

		if(minutes < 0)
		{
  			SetPVarInt(playerid, "LastTime_Vann_Sec", 0);
		}
	    if(CurrentTime - GetPVarInt(playerid, "LastTime_Vann_Sec") >= 1200000) // 20 min
	    {
		    SetPVarInt(playerid, "LastTime_Vann_Sec", CurrentTime);
		    format(msgstring, sizeof(msgstring), "VIP Announcement by %s: %s", PlayerName(playerid), announcement);
		    SendClientMessageToAll(COLOR_GLOBALNOTICE , msgstring);
		    return 1;
		}
		else
		{
            format(msgstring, sizeof(msgstring), "Please wait %d minute(s) and %d second(s) before making another VIP Announcement.", minutes, seconds);
			SendClientMessage(playerid, COLOR_SYNTAX, msgstring);
		}

	    return 1;
	}
}

CMD:nos(playerid, params[])
{
	new msgstring[150];
	if(IsPlayerInAnyVehicle(playerid))
	{
	    new CurrentTime = gettime();
	    new difference = CurrentTime - GetPVarInt(playerid, "LastTime_Nos_Sec");
	    new totalsecleft = 300-difference;
		new minutes = totalsecleft/60;
		new seconds = totalsecleft-minutes*60;

		if(minutes < 0)
		{
  			SetPVarInt(playerid, "LastTime_Nos_Sec", 0);
		}
	    if(CurrentTime - GetPVarInt(playerid, "LastTime_Nos_Sec") >= 300000) // 15 min
	    {
		    SetPVarInt(playerid, "LastTime_Nos_Sec", CurrentTime);
		    new vehicleid = GetPlayerVehicleID(playerid);
        	AddVehicleComponent(vehicleid, 1010);
		    SendClientMessageToAll(COLOR_NOTICE, "[NOTICE]: NOS has been added to your vehicle! You can use this command again in five minutes.");
		}
		else
		{
            format(msgstring, sizeof(msgstring), "Please wait %d minute(s) and %d second(s) before getting NOS again.", minutes, seconds);
			SendClientMessage(playerid, COLOR_SYNTAX, msgstring);

		}

	    return 1;
	}
	else return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in a vehicle.");
}*/
/* =============================================================================*/
// ||||||||||||||||               Ammunation part:             |||||||||||||||||
/* ============================================================================*/
CMD:buy(playerid, params[])
{
	if(ShopSys != 0)
 	{
  		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The shop system is currently disabled.");
    	return 1;
     }

	if(IsPlayerInRangeOfPoint(playerid, 10.0, 315.6105,-143.2389,999.6016))
 	{
  		new string[350];
    	format(string, sizeof(string), "1. Brass Nuckles ($%d) \n2. Shovel ($%d) \n3. Katana ($%d) \n4. Chainsaw ($%d) \n5. Tear Gas ($%d/ea) \n6. Molotov Cocktail ($%d/ea - max %d) \n7. Satchel Charge ($%d/ea - max %d) \n8. Grenades ($%d/ea - max %d)\n9. RPG ($%d/ea - max %d - NO DISCOUNT)\n10. Main Weaponary",PRICE_KNUCKLES, PRICE_SHOVEL, PRICE_KATANA, PRICE_CHAINSAW, PRICE_TEARGAS, PRICE_MOLOTOV, MAX_MOLOS, PRICE_SATCHEL, MAX_SATCHELS, PRICE_GRENADE, MAX_GRENADES, PRICE_RPG, MAX_RPGS);
     	ShowPlayerDialog(playerid, DIALOG_BUY, DIALOG_STYLE_LIST, "Weapon Purchase", string, "Purchase", "Cancel");
    }
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	print("Chilco_Ammunation");
	new old_wep, old_ammo, ammo_diff;
	new string[256];
    if(dialogid == DIALOG_BUY)
	{
		if(!response)
		{
			return 1;
		}
		switch(listitem)
		{
			case 0:
			{
				if(GetPlayerMoney(playerid) < PRICE_KNUCKLES)
				{
					SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
					return 1;
				}

				GivePlayerMoney(playerid, -PRICE_KNUCKLES);
				new moneystring[256];
				format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ by buying weapon.", PlayerName(playerid), playerid, PRICE_KNUCKLES);
				MoneyLog(moneystring);
				GivePlayerWeapon(playerid, 1, 1);
			}
			case 1:
			{
				if(GetPlayerMoney(playerid) < PRICE_SHOVEL)
				{
					SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
					return 1;
				}

				GivePlayerMoney(playerid, -PRICE_SHOVEL);
				new moneystring[256];
				format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ by buying weapon.", PlayerName(playerid), playerid, PRICE_SHOVEL);
				MoneyLog(moneystring);
				GivePlayerWeapon(playerid, 6, 1);
			}
			case 2:
			{
				if(GetPlayerMoney(playerid) < PRICE_KATANA)
				{
					SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
					return 1;
				}

				GivePlayerMoney(playerid, -PRICE_KATANA);
				new moneystring[256];
				format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ by buying weapon.", PlayerName(playerid), playerid, PRICE_KATANA);
				MoneyLog(moneystring);
				GivePlayerWeapon(playerid, 8, 1);
			}
			case 3:
			{
				if(GetPlayerMoney(playerid) < PRICE_CHAINSAW)
				{
					SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
					return 1;
				}
				new moneystring[256];
				format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ by buying weapon.", PlayerName(playerid), playerid, PRICE_CHAINSAW);
				MoneyLog(moneystring);
				GivePlayerMoney(playerid, -PRICE_CHAINSAW);
				GivePlayerWeapon(playerid, 9, 1000);
			}
			case 4:
			{
				format(string, sizeof(string), "Specify the amount of Teargas you want. The price is $%d each:",PRICE_TEARGAS);
				ShowPlayerDialog(playerid, DIALOG_WEAPONAMMO, DIALOG_STYLE_INPUT, "Weapons List - Purchase", string, "Purchase", "Cancel");
				SetPVarInt(playerid, "Ammunation_WepID_Select", 17);
			}
			case 5:
			{
				GetPlayerWeaponData(playerid, 8, old_wep, old_ammo);
				
				if(old_wep == 18)
				{
					ammo_diff = MAX_MOLOS - old_ammo;
					if(ammo_diff <= 0)
					{
						SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: Sorry, you already have the max amount of ammo for this!");
						return 1;
					}
				}
				else
				{
					ammo_diff = MAX_MOLOS;
				}
 				format(string, sizeof(string), "Specify the amount of Molotov Cocktails you want. You can max buy %d and the price is $%d each:", ammo_diff, PRICE_MOLOTOV);
				ShowPlayerDialog(playerid, DIALOG_WEAPONAMMO, DIALOG_STYLE_INPUT, "Weapons List - Purchase", string, "Purchase", "Cancel");
				SetPVarInt(playerid, "Ammunation_WepID_Select", 18);
				SetPVarInt(playerid, "Ammunation_MaxAmmo", ammo_diff);
			}
			case 6:
			{
				GetPlayerWeaponData(playerid, 8, old_wep, old_ammo);
				
				if(old_wep == 39)
				{
					ammo_diff = MAX_SATCHELS - old_ammo;
					if(ammo_diff <= 0)
					{
						SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: Sorry, you already have the max amount of ammo for this!");
						return 1;
					}
				}
				else
				{
					ammo_diff = MAX_SATCHELS;
				}
				format(string, sizeof(string), "Specify the amount of Satchel Charges you want. You can max buy %d and the price is $%d each:",ammo_diff, PRICE_SATCHEL);
				ShowPlayerDialog(playerid, DIALOG_WEAPONAMMO, DIALOG_STYLE_INPUT, "Weapons List - Purchase", string, "Purchase", "Cancel");
				SetPVarInt(playerid, "Ammunation_WepID_Select", 39);
				SetPVarInt(playerid, "Ammunation_MaxAmmo", ammo_diff);
			}
			case 7:
			{
				GetPlayerWeaponData(playerid, 8, old_wep, old_ammo);
				
				if(old_wep == 16)
				{
					ammo_diff = MAX_GRENADES - old_ammo;
					if(ammo_diff <= 0)
					{
						SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: Sorry, you already have the max amount of ammo for this!");
						return 1;
					}
				}
				else
				{
					ammo_diff = MAX_GRENADES;
				}
				format(string, sizeof(string), "Specify the amount of Grenades you want. You can max buy %d and the price is $%d each:",ammo_diff, PRICE_GRENADE);
				ShowPlayerDialog(playerid, DIALOG_WEAPONAMMO, DIALOG_STYLE_INPUT, "Weapons List - Purchase", string, "Purchase", "Cancel");
				SetPVarInt(playerid, "Ammunation_WepID_Select", 16);
				SetPVarInt(playerid, "Ammunation_MaxAmmo", ammo_diff);
			}
			case 8:
			{
				if(GetPlayerMoney(playerid) < PRICE_RPG)
				{
					SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
					return 1;
				}
				
				GetPlayerWeaponData(playerid, 7, old_wep, old_ammo);
				if(old_wep == 35 && old_ammo >= 1)
				{
					SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You already have one of these, piss off!");
					return 1;
				}
				new diff = (RPG_cooldown[playerid] + RPG_COOLDOWN) - gettime();
				if(diff > 0)
				{
					new Float:mins = diff / 60.0;
					if(mins > 1.0){
						format(string, sizeof(string), "Shop keeper says: You have to wait %d minutes to buy that!", floatround(mins, floatround_floor));
						SendClientMessage(playerid, COLOR_GRAD1, string);
						return 1;
					}
					else{
						format(string, sizeof(string), "Shop keeper says: You have to wait %d seconds to buy that!", diff);
						SendClientMessage(playerid, COLOR_GRAD1, string);
						return 1;
					}
					
				}
				format(string, sizeof(string), "Purchase confirmation:\n\nWeapon: RPG\nAmmo: 1\n\nPrice: $%d", PRICE_RPG);
				ShowPlayerDialog(playerid, DIALOG_RPGCONF, DIALOG_STYLE_MSGBOX, "Weapons List - Purchase", string, "Purchase", "Cancel");
				
			}
			case 9:
			{
				format(string, sizeof(string), "1. Colt45 ($%d/ea) \n2. Silenced ($%d/ea) \n3. Deagle ($%d/ea) \n4. Shotgun ($%d/ea) \n5. Sawn Off ($%d/ea) \n6. Combat Shotgun ($%d/ea) \n7. UZI ($%d/ea) \n8. MP5 ($%d/ea) \n9. AK47 ($%d/ea) \n10. M4 ($%d/ea) \n11. Tec9 ($%d/ea) \n12. Sniper Rifle ($%d/ea)",PRICE_COLT, PRICE_SILENCE, PRICE_DEAGLE, PRICE_SHOTGUN, PRICE_SAWNOFF, PRICE_COMBAT, PRICE_SMG, PRICE_MP5, PRICE_AK47, PRICE_M4, PRICE_TEC9, PRICE_SNIPER);

				ShowPlayerDialog(playerid, DIALOG_WEAPONS, DIALOG_STYLE_LIST, "Weapons List - Purchase", string, "Purchase", "Cancel");
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONS)
	{
		if(!response)
		{
			return 1;
		}

		switch(listitem)
		{
			case 0:
			{
				format(string, sizeof(string), "Specify the amount of Colt ammo you want. The price is $%d each:",PRICE_COLT);
				ShowPlayerDialog(playerid, DIALOG_WEAPONAMMO, DIALOG_STYLE_INPUT, "Weapons List - Purchase", string, "Purchase", "Cancel");
				SetPVarInt(playerid, "Ammunation_WepID_Select", 22);
			}
			case 1:
			{
				format(string, sizeof(string), "Specify the amount of Silenced Pistol ammo you want. The price is $%d each:",PRICE_SILENCE);
				ShowPlayerDialog(playerid, DIALOG_WEAPONAMMO, DIALOG_STYLE_INPUT, "Weapons List - Purchase", string, "Purchase", "Cancel");
				SetPVarInt(playerid, "Ammunation_WepID_Select", 23);
			}
			case 2:
			{
				format(string, sizeof(string), "Specify the amount of Desert Eagle ammo you want. The price is $%d each:",PRICE_DEAGLE);
				ShowPlayerDialog(playerid, DIALOG_WEAPONAMMO, DIALOG_STYLE_INPUT, "Weapons List - Purchase", string, "Purchase", "Cancel");
				SetPVarInt(playerid, "Ammunation_WepID_Select", 24);
			}
			case 3:
			{
				format(string, sizeof(string), "Specify the amount of Shotgun ammo you want. The price is $%d each:",PRICE_SHOTGUN);
				ShowPlayerDialog(playerid, DIALOG_WEAPONAMMO, DIALOG_STYLE_INPUT, "Weapons List - Purchase", string, "Purchase", "Cancel");
				SetPVarInt(playerid, "Ammunation_WepID_Select", 25);
			}
			case 4:
			{
				format(string, sizeof(string), "Specify the amount of Sawn Off ammo you want. The price is $%d each:",PRICE_SAWNOFF);
				ShowPlayerDialog(playerid, DIALOG_WEAPONAMMO, DIALOG_STYLE_INPUT, "Weapons List - Purchase", string, "Purchase", "Cancel");
				SetPVarInt(playerid, "Ammunation_WepID_Select", 26);
			}
			case 5:
			{
				format(string, sizeof(string), "Specify the amount of Combat Shotgun ammo you want. The price is $%d each:",PRICE_COMBAT);
				ShowPlayerDialog(playerid, DIALOG_WEAPONAMMO, DIALOG_STYLE_INPUT, "Weapons List - Purchase", string, "Purchase", "Cancel");
				SetPVarInt(playerid, "Ammunation_WepID_Select", 27);
			}
			case 6:
			{
				format(string, sizeof(string), "Specify the amount of Micro SMG ammo you want. The price is $%d each:",PRICE_SMG);
				ShowPlayerDialog(playerid, DIALOG_WEAPONAMMO, DIALOG_STYLE_INPUT, "Weapons List - Purchase", string, "Purchase", "Cancel");
				SetPVarInt(playerid, "Ammunation_WepID_Select", 28);
			}
			case 7:
			{
				format(string, sizeof(string), "Specify the amount of MP5 ammo you want. The price is $%d each:",PRICE_MP5);
				ShowPlayerDialog(playerid, DIALOG_WEAPONAMMO, DIALOG_STYLE_INPUT, "Weapons List - Purchase", string, "Purchase", "Cancel");
				SetPVarInt(playerid, "Ammunation_WepID_Select", 29);
			}
			case 8:
			{
				format(string, sizeof(string), "Specify the amount of AK-47 ammo you want. The price is $%d each:",PRICE_AK47);
				ShowPlayerDialog(playerid, DIALOG_WEAPONAMMO, DIALOG_STYLE_INPUT, "Weapons List - Purchase", string, "Purchase", "Cancel");
				SetPVarInt(playerid, "Ammunation_WepID_Select", 30);
			}
			case 9:
			{
				format(string, sizeof(string), "Specify the amount of M4 ammo you want. The price is $%d each:",PRICE_M4);
				ShowPlayerDialog(playerid, DIALOG_WEAPONAMMO, DIALOG_STYLE_INPUT, "Weapons List - Purchase", string, "Purchase", "Cancel");
				SetPVarInt(playerid, "Ammunation_WepID_Select", 31);
			}
			case 10:
			{
				format(string, sizeof(string), "Specify the amount of TEC-9 ammo you want. The price is $%d each:",PRICE_TEC9);
				ShowPlayerDialog(playerid, DIALOG_WEAPONAMMO, DIALOG_STYLE_INPUT, "Weapons List - Purchase", string, "Purchase", "Cancel");
				SetPVarInt(playerid, "Ammunation_WepID_Select", 32);
			}
			case 11:
			{
				format(string, sizeof(string), "Specify the amount of Sniper ammo you want. The price is $%d each:",PRICE_SNIPER);
				ShowPlayerDialog(playerid, DIALOG_WEAPONAMMO, DIALOG_STYLE_INPUT, "Weapons List - Purchase", string, "Purchase", "Cancel");
				SetPVarInt(playerid, "Ammunation_WepID_Select", 34);
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONAMMO)
	{
		if(!response)
		{
			return 1;
		}

		new Value = strval(inputtext);
		if(Value < 0) return SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: This doesn't make sense, sir.");
		if(Value == 0) return SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: A weapon with no ammo? You silly bastard!");
		if(Value == 1337)
		{
            SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: L33T ammo for the real boss.");
            GiveAchievement(playerid, 86);
		} 
		if(Value > 10000) SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: I'll bring it down to 10000 ammo, that's more than enough.");
		if(Value > 10000) Value = 10000;


		new buy_percentage = 100;
		if(isVIP(playerid) == 1) buy_percentage = 75; // Bronze
		if(isVIP(playerid) == 2) buy_percentage = 50; // Silver
		if(isVIP(playerid) == 3) buy_percentage = 25; // Gold


		new weaponid = GetPVarInt(playerid, "Ammunation_WepID_Select");
		new max_ammo = -1;
		if(weaponid == 18 || weaponid == 39 || weaponid == 16)
		{
			max_ammo = GetPVarInt(playerid, "Ammunation_MaxAmmo");
		}
		
		if(max_ammo != -1)
		{
			if(Value > max_ammo)
			{
				format(string, sizeof(string), "Shop keeper says: You can buy max %d, I told you that!", max_ammo);
				SendClientMessage(playerid, COLOR_GRAD1, string);
				return 1;
			}
		}
		
		if(weaponid == 16)
		{
			if(GetPlayerMoney(playerid) < PRICE_GRENADE*Value/100*buy_percentage)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
				return 1;
			}
			SetPVarInt(playerid, "Weapon_Price", PRICE_GRENADE*Value/100*buy_percentage);
			
		}	
		if(weaponid == 17)
		{
		    if(GetPlayerMoney(playerid) < PRICE_TEARGAS*Value/100*buy_percentage)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
				return 1;
			}
			SetPVarInt(playerid, "Weapon_Price", PRICE_TEARGAS*Value/100*buy_percentage);
		}
		if(weaponid == 18)
		{
			if(GetPlayerMoney(playerid) < PRICE_MOLOTOV*Value/100*buy_percentage)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
				return 1;
			}
			SetPVarInt(playerid, "Weapon_Price", PRICE_MOLOTOV*Value/100*buy_percentage);
		}
		if(weaponid == 39)
		{
			if(GetPlayerMoney(playerid) < PRICE_SATCHEL*Value/100*buy_percentage)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
				return 1;
			}
			SetPVarInt(playerid, "Weapon_Price", PRICE_SATCHEL*Value/100*buy_percentage);
		}
		if(weaponid == 22)
		{
		    if(GetPlayerMoney(playerid) < PRICE_COLT*Value/100*buy_percentage)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
				return 1;
			}
			SetPVarInt(playerid, "Weapon_Price", PRICE_COLT*Value/100*buy_percentage);
		}
		if(weaponid == 23)
		{
		    if(GetPlayerMoney(playerid) < PRICE_SILENCE*Value/100*buy_percentage)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
				return 1;
			}
			SetPVarInt(playerid, "Weapon_Price", PRICE_SILENCE*Value/100*buy_percentage);
		}
		if(weaponid == 24)
		{
			if(GetPlayerMoney(playerid) < PRICE_DEAGLE*Value/100*buy_percentage)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
				return 1;
			}
			SetPVarInt(playerid, "Weapon_Price", PRICE_DEAGLE*Value/100*buy_percentage);
		}
		if(weaponid == 25)
		{
		    if(GetPlayerMoney(playerid) < PRICE_SHOTGUN*Value/100*buy_percentage)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
				return 1;
			}
			SetPVarInt(playerid, "Weapon_Price", PRICE_SHOTGUN*Value/100*buy_percentage);
		}
		if(weaponid == 26)
		{
		    if(GetPlayerMoney(playerid) < PRICE_SAWNOFF*Value/100*buy_percentage)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
				return 1;
			}
			SetPVarInt(playerid, "Weapon_Price", PRICE_SAWNOFF*Value/100*buy_percentage);
		}
		if(weaponid == 27)
		{
            if(GetPlayerMoney(playerid) < PRICE_COMBAT*Value/100*buy_percentage)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
				return 1;
			}
			SetPVarInt(playerid, "Weapon_Price", PRICE_COMBAT*Value/100*buy_percentage);
		}
		if(weaponid == 28)
		{
		    if(GetPlayerMoney(playerid) < PRICE_SMG*Value/100*buy_percentage)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
				return 1;
			}
			SetPVarInt(playerid, "Weapon_Price", PRICE_SMG*Value/100*buy_percentage);
		}
		if(weaponid == 29)
		{
		    if(GetPlayerMoney(playerid) < PRICE_MP5*Value/100*buy_percentage)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
				return 1;
			}
			SetPVarInt(playerid, "Weapon_Price", PRICE_MP5*Value/100*buy_percentage);
		}
		if(weaponid == 30)
		{
		    if(GetPlayerMoney(playerid) < PRICE_AK47*Value/100*buy_percentage)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
				return 1;
			}
			SetPVarInt(playerid, "Weapon_Price", PRICE_AK47*Value/100*buy_percentage);
		}
		if(weaponid == 31)
		{
		    if(GetPlayerMoney(playerid) < PRICE_M4*Value/100*buy_percentage)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
				return 1;
			}
			SetPVarInt(playerid, "Weapon_Price", PRICE_M4*Value/100*buy_percentage);
		}
		if(weaponid == 32)
		{
		    if(GetPlayerMoney(playerid) < PRICE_TEC9*Value/100*buy_percentage)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
				return 1;
			}
			SetPVarInt(playerid, "Weapon_Price", PRICE_TEC9*Value/100*buy_percentage);
		}
		if(weaponid == 34)
		{
		    if(GetPlayerMoney(playerid) < PRICE_SNIPER*Value/100*buy_percentage)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: You can't afford this, piss off!");
				return 1;
			}
			SetPVarInt(playerid, "Weapon_Price", PRICE_SNIPER*Value/100*buy_percentage);
		}
		SetPVarInt(playerid, "Weapon_Ammo", Value);
		new gunname[32];
		new WPrice = GetPVarInt(playerid, "Weapon_Price");
		if(WPrice < 0)
		{
			return SendClientMessage(playerid, COLOR_GRAD1, "Shop keeper says: This doesn't make sense, sir.");
		}
		
		GetWeaponName(GetPVarInt(playerid, "Ammunation_WepID_Select"),gunname,sizeof(gunname));
		if(GetPVarInt(playerid, "Ammunation_WepID_Select") == 18)
		{
			format(string, sizeof(string), "Purchase confirmation:\n\nWeapon: Molotov Cocktail\nAmmo: %d\n\nPrice: $%d", Value, WPrice);
		}
		format(string, sizeof(string), "Purchase confirmation:\n\nWeapon: %s\nAmmo: %d\n\nPrice: $%d", gunname, Value, WPrice);
		ShowPlayerDialog(playerid, DIALOG_WEAPONCONF, DIALOG_STYLE_MSGBOX, "Weapons List - Purchase", string, "Purchase", "Cancel");
	}
	if(dialogid == DIALOG_WEAPONCONF)
	{
		if(!response)
		{
			return 1;
		}
		new gunname[32];
		new Price2 = GetPVarInt(playerid, "Weapon_Price");
		if(Price2 == 0) return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can't buy this low ammo for this weapon.");
		new Value2 = GetPVarInt(playerid, "Weapon_Ammo");
		GetWeaponName(GetPVarInt(playerid, "Ammunation_WepID_Select"),gunname,sizeof(gunname));
		GivePlayerMoney(playerid, -Price2);
		new moneystring[256];
		format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ by buying %s.", PlayerName(playerid), playerid, Price2,gunname);
		MoneyLog(moneystring);
		GiveAchievement(playerid, 44);
		GivePlayerWeapon(playerid, GetPVarInt(playerid, "Ammunation_WepID_Select"), Value2);
		if(GetPVarInt(playerid, "Ammunation_WepID_Select") == 39) GivePlayerWeapon(playerid,40, Value2);
		format(string, sizeof(string), "[NOTICE]: You bought a(n) %s with %d ammo for $%d.", gunname,Value2, Price2);
		if(GetPVarInt(playerid, "Ammunation_WepID_Select") == 17) format(string, sizeof(string), "[NOTICE]: You bought %d Teargas for $%d.", Value2, Price2);
		if(GetPVarInt(playerid, "Ammunation_WepID_Select") == 18) format(string, sizeof(string), "[NOTICE]: You bought %d Molotov Cocktails for $%d.", Value2, Price2);
		if(GetPVarInt(playerid, "Ammunation_WepID_Select") == 39) format(string, sizeof(string), "[NOTICE]: You bought %d Satchel Charges for $%d.", Value2, Price2);
		SendClientMessage(playerid, COLOR_NOTICE, string);
		if(isVIP(playerid) == 1) SendClientMessage(playerid, COLOR_NEWS, "[VIP DISCOUNT]: 25 percent off due to Bronze VIP.");
		if(isVIP(playerid) == 2) SendClientMessage(playerid, COLOR_NEWS, "[VIP DISCOUNT]: 50 percent off due to Silver VIP.");
		if(isVIP(playerid) == 3) SendClientMessage(playerid, COLOR_NEWS, "[VIP DISCOUNT]: 75 percent off due to Gold VIP.");

	}
	if(dialogid == DIALOG_RPGCONF)
	{
		if(!response)
		{
			SendClientMessage(playerid, COLOR_NOTICE, "Shop keeper says: Alright then, pussy..");
			return 1;
		}
		format(string, sizeof(string), "[NOTICE]: You bought an RPG for $%d.", PRICE_RPG);
		GivePlayerMoney(playerid, -PRICE_RPG);
		new moneystring[256];
		format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ by buying RPG.", PlayerName(playerid), playerid, PRICE_RPG);
		MoneyLog(moneystring);
		GivePlayerWeapon(playerid, 35, 1);
		RPG_cooldown[playerid] = gettime();
	}
	return 1;
}
