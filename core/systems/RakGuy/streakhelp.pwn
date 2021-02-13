#include <YSI\y_hooks>


new K_STREAK[870];
		
new D_STREAK[128]="Deaths\tArmour/HP\tWeapon\
				\n5-9\t-\tMP5[90]\
				\n10-19\t-\tM4[100]\
				\n20+\tArmour+50\tSpaz[50]\
				\n{ff0000}Only Valid for Players below Level-5";

hook OnGameModeInit()
{
	strcat(K_STREAK, "Kills\tArmour/HP\tWeapon");
	strcat(K_STREAK, "\n0-4\t-\t-");
	strcat(K_STREAK, "\n5-9\tHP+25\t-");
	strcat(K_STREAK, "\n10\tHP/Armour+25\tGrenade[2]");
	strcat(K_STREAK, "\n11-19\tHP/Armour+25\t-");
	strcat(K_STREAK, "\n20\tHP/Armour+25\tGrenade[5]");
	strcat(K_STREAK, "\n21-29\tHP/Armour+25\t-");
	strcat(K_STREAK, "\n30\tHP/Armour+25\tRPG[2]");
	strcat(K_STREAK, "\n31-39\tHP/Armour+2\t5-");
	strcat(K_STREAK, "\n40\tHP/Armour+25\tRPG[5]");
	strcat(K_STREAK, "\n41-49\tHP/Armour+25\t-");
	strcat(K_STREAK, "\n50\tHP/Armour+25\tMinigun[50]");
	strcat(K_STREAK, "\n51-59\tHP/Armour+25\t-");
	strcat(K_STREAK, "\n60\tHP/Armour+25\tMinigun[50]");
	strcat(K_STREAK, "\n61-69\tHP/Armour+25\t-");
	strcat(K_STREAK, "\n70\tHP/Armour+25\tHeatSeaker-RPG[15]");
	strcat(K_STREAK, "\n71-79\tHP/Armour+25\t-");
	strcat(K_STREAK, "\n80\tHP/Armour+25\tMinigun[50]");
	strcat(K_STREAK, "\n81-89\tHP/Armour+25\t-");
	strcat(K_STREAK, "\n90\tHP/Armour+25\tMinigun[50]");
	strcat(K_STREAK, "\n91-99\tHP/Armour+25\t-");
	strcat(K_STREAK, "\n100\tHP/Armour+25\tMinigun[100]");
	strcat(K_STREAK, "\n100+\tHP/Armour+25\t-");
}

CMD:streakhelp(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_NORETURN, DIALOG_STYLE_TABLIST_HEADERS, "Kill Streaks:", K_STREAK, "Close", "");
	return 1;
}

CMD:spreehelp(playerid, params[])
{
	return cmd_streakhelp(playerid, params);
}

CMD:dstreakhelp(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		ShowPlayerDialog(playerid, DIALOG_NORETURN, DIALOG_STYLE_TABLIST_HEADERS, "Kill Streaks:", D_STREAK, "Close", "");
		return 1;
	}
	return 1;
}




















