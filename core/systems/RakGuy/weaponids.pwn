#include <YSI\y_hooks>

new DIALOG_DONOTEDITMSG[1500];

hook OnGameModeInit()
{
    strcat(DIALOG_DONOTEDITMSG, "Name\tID\tSlot\n");
	strcat(DIALOG_DONOTEDITMSG, "Fist\t0\t0\n");
	strcat(DIALOG_DONOTEDITMSG, "Brass Knuckles\t1\t0\n");
	strcat(DIALOG_DONOTEDITMSG, "Golf Club\t2\t1\n");
	strcat(DIALOG_DONOTEDITMSG, "Nightstick\t3\t1\n");
	strcat(DIALOG_DONOTEDITMSG, "Knife\t4\t1\n");
	strcat(DIALOG_DONOTEDITMSG, "Baseball Bat\t5\t1\n");
	strcat(DIALOG_DONOTEDITMSG, "Shovel\t6\t1\n");
	strcat(DIALOG_DONOTEDITMSG, "Pool Cue\t7\t1\n");
	strcat(DIALOG_DONOTEDITMSG, "Katana\t8\t1\n");
	strcat(DIALOG_DONOTEDITMSG, "Chainsaw\t9\t1\n");
	strcat(DIALOG_DONOTEDITMSG, "Purple Dildo\t10\t10\n");
	strcat(DIALOG_DONOTEDITMSG, "Dildo\t11\t10\n");
	strcat(DIALOG_DONOTEDITMSG, "Vibrator\t12\t10\n");
	strcat(DIALOG_DONOTEDITMSG, "Silver Vibrator\t13\t10\n");
	strcat(DIALOG_DONOTEDITMSG, "Flowers\t14\t10\n");
	strcat(DIALOG_DONOTEDITMSG, "Cane\t15\t10\n");
	strcat(DIALOG_DONOTEDITMSG, "Grenade\t16\t8\n");
	strcat(DIALOG_DONOTEDITMSG, "Tear Gas\t17\t8\n");
	strcat(DIALOG_DONOTEDITMSG, "Molotov Cocktail\t18\t8\n");
	strcat(DIALOG_DONOTEDITMSG, "InvalidID\t19\t-1\n");
	strcat(DIALOG_DONOTEDITMSG, "InvalidID\t20\t-1\n");
	strcat(DIALOG_DONOTEDITMSG, "InvalidID\t21\t-1\n");
	strcat(DIALOG_DONOTEDITMSG, "9mm\t22\t2\n");
	strcat(DIALOG_DONOTEDITMSG, "Silenced 9mm\t23\t2\n");
	strcat(DIALOG_DONOTEDITMSG, "Desert Eagle\t24\t2\n");
	strcat(DIALOG_DONOTEDITMSG, "Shotgun\t25\t3\n");
	strcat(DIALOG_DONOTEDITMSG, "Sawnoff Shotgun\t26\t3\n");
	strcat(DIALOG_DONOTEDITMSG, "Combat Shotgun\t27\t3\n");
	strcat(DIALOG_DONOTEDITMSG, "Micro SMG/Uzi\t28\t4\n");
	strcat(DIALOG_DONOTEDITMSG, "MP5\t29\t4\n");
	strcat(DIALOG_DONOTEDITMSG, "AK-47\t30\t5\n");
	strcat(DIALOG_DONOTEDITMSG, "M4\t31\t5\n");
	strcat(DIALOG_DONOTEDITMSG, "Tec-9\t32\t4\n");
	strcat(DIALOG_DONOTEDITMSG, "Country Rifle\t33\t6\n");
	strcat(DIALOG_DONOTEDITMSG, "Sniper Rifle\t34\t6\n");
	strcat(DIALOG_DONOTEDITMSG, "RPG\t35\t7\n");
	strcat(DIALOG_DONOTEDITMSG, "HS Rocket\t36\t7\n");
	strcat(DIALOG_DONOTEDITMSG, "Flamethrower\t37\t7\n");
	strcat(DIALOG_DONOTEDITMSG, "Minigun\t38\t7\n");
	strcat(DIALOG_DONOTEDITMSG, "Satchel Charge\t39\t8\n");
	strcat(DIALOG_DONOTEDITMSG, "Detonator\t40\t12\n");
	strcat(DIALOG_DONOTEDITMSG, "Spraycan\t41\t9\n");
	strcat(DIALOG_DONOTEDITMSG, "Fire Extinguisher\t42\t9\n");
	strcat(DIALOG_DONOTEDITMSG, "Camera\t43\t9\n");
	strcat(DIALOG_DONOTEDITMSG, "Night Vis Goggles\t44\t11\n");
	strcat(DIALOG_DONOTEDITMSG, "Thermal Goggles\t45\t11\n");
	strcat(DIALOG_DONOTEDITMSG, "Parachute\t46\t11");
	print(DIALOG_DONOTEDITMSG);
	return 1;
}

CMD:weaponids(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
	    ShowPlayerDialog(playerid, DIALOG_NORETURN, DIALOG_STYLE_TABLIST_HEADERS, "Weapons", DIALOG_DONOTEDITMSG, "Close", "");
	}
	return 1;
}
