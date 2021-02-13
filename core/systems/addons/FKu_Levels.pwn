/*********************************************************************************
*																				 *
*				 ______     _____        _______ _____  __  __                   *
*				|  ____|   / ____|      |__   __|  __ \|  \/  |                  *
*				| |__ ___ | |     ___      | |  | |  | | \  / |                  *
*				|  __/ _ \| |    / _ \     | |  | |  | | |\/| |                  *
*				| | | (_) | |___| (_) |    | |  | |__| | |  | |                  *
*				|_|  \___/ \_____\___/     |_|  |_____/|_|  |_|                  *
*                                                                                *
*                                                                                *
*								(c) Copyright				 					 *
*  Owners: Simon Fagerli (pEar) - Lee Percox (Shaney) - Warren Bickley (WazzaJB) *
*         Developers: Marcel, RakGuy, FKu, Chilco, dr_vista, Fletcher            *
*																				 *
* Filename: FKu_levels.pwn                                                       *
* Author: FKu                                                                    *
*********************************************************************************/
#include <YSI\y_hooks>
#define DIALOG_LEVELS 500
#define DIALOG_WNAMES 501

new const WeaponNames[][32] = {
		{"Brass Knuckles"}, // 1
		{"Golf Club"}, // 2
		{"Night Stick"}, // 3
		{"Knife"}, // 4
		{"Baseball Bat"}, // 5
		{"Shovel"}, // 6
		{"Pool Cue"}, // 7
		{"Katana"}, // 8
		{"Chainsaw"}, // 9
		{"Purple Dildo"}, // 10
		{"Big White Vibrator"}, // 11
		{"Medium White Vibrator"}, // 12
		{"Small White Vibrator"}, // 13
		{"Flowers"}, // 14
		{"Cane"}, // 15
		{"Grenade"}, // 16
		{"Teargas"}, // 17
		{"Molotov"}, // 18
		{"Colt 45"}, // 22
		{"Colt 45 (Silenced)"}, // 23
		{"Desert Eagle"}, // 24
		{"Normal Shotgun"}, // 25
		{"Sawnoff Shotgun"}, // 26
		{"Combat Shotgun"}, // 27
		{"Micro Uzi (Mac 10)"}, // 28
		{"MP5"}, // 29
		{"AK47"}, // 30
		{"M4"}, // 31
		{"Tec9"}, // 32
		{"Country Rifle"}, // 33
		{"Sniper Rifle"}, // 34
		{"Rocket Launcher"}, // 35
		{"Heat-Seeking Rocket Launcher"}, // 36
		{"Flamethrower"}, // 37
		{"Minigun"}, // 38
		{"Satchel Charge"}, // 39
		{"Detonator"}, // 40
		{"Spray Can"}, // 41
		{"Fire Extinguisher"}, // 42
		{"Camera"}, // 43
		{"Night Vision Goggles"}, // 44
		{"Infrared Vision Goggles"}, // 45
		{"Parachute"} // 46
};

CMD:levels(playerid, params[])
{
	new string[750], req;
	for(new i = 0; i <= 10; i++)
	{
		if(FoCo_Player[playerid][level] >= i)
		{
			format(string, sizeof(string), "%s{008000}Level %d\t%d kills\tReached this level!\n", string, i, level_requirement[i]);
		}
		else
		{
			req = level_requirement[i] - FoCo_Playerstats[playerid][kills];
			format(string, sizeof(string), "%s{FF0000}Level %d\t%d kills\t%d kills required\n", string, i, level_requirement[i], req);
		}
	}
	strdel(string, strlen(string)-1, strlen(string));
	format(string, sizeof(string), "Level:\tTotal Kills Required:\tKills Missing:\n%s", string);
	ShowPlayerDialog(playerid,DIALOG_LEVELS ,DIALOG_STYLE_TABLIST_HEADERS,"Levels", string,"Select","Close");
	return 1;
}
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    print("ODR_FK_Levels");
	if(dialogid == DIALOG_LEVELS)
	{
		if(response)
		{
			SetLevelString(playerid,listitem);
		}
	}
	if(dialogid == DIALOG_WNAMES)
	{
		if(response)
		{
			new string[750], req;
			for(new i = 0; i <= 10; i++)
			{
				if(FoCo_Player[playerid][level] >= i)
				{
					format(string, sizeof(string), "%s{008000}Level %d\t%d kills\tReached this level!\n", string, i, level_requirement[i]);
				}
				else
				{
					req = level_requirement[i] - FoCo_Playerstats[playerid][kills];
					format(string, sizeof(string), "%s{FF0000}Level %d\t%d kills\t%d kills required\n", string, i, level_requirement[i], req);
				}
			}
			strdel(string, strlen(string)-1, strlen(string));
			format(string, sizeof(string), "Level:\tTotal Kills Required:\tKills Missing:\n%s", string);
			ShowPlayerDialog(playerid,DIALOG_LEVELS ,DIALOG_STYLE_TABLIST_HEADERS,"Levels", string, "Select","Close");
		}
	}
	return 1;
}

stock SetLevelString(playerid,levell)
{
	new text[300],text2[32];
	for(new i; i<sizeof(class_slots) ; i++)
	{
		if(class_slots[i][2] == levell)
		{
			format(text2,sizeof(text2),"%s\n",WeaponNames[i]);
			strcat(text,text2,sizeof(text));
		}
	}
	//if(levell == 6)strcat(text,"\nArmour",sizeof(text));
	if(levell == 7)
	{
		format(text, sizeof(text), "%s\n Armor ~ 65%",text);
	}
	else if(levell == 8)
	{
		format(text, sizeof(text), "%s\n Armor ~ 75%",text);
	}
	else if(levell == 9)
	{
		format(text, sizeof(text), "%s\n Armor ~ 85%",text);
	}
	else if(levell >= 10)
	{
		format(text, sizeof(text), "%s\n Armor ~ 100%",text);
	}
	else{
		format(text, sizeof(text), "%s\n Armor ~ 50%",text);
	}
	format(text2,sizeof(text2),"Level %d",levell);
	ShowPlayerDialog(playerid,DIALOG_WNAMES,DIALOG_STYLE_MSGBOX,text2,text,"Close","");
	return 1;
}

