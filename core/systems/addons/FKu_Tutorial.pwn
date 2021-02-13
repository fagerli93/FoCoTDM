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
* Filename: FKU_tutorial.pwn                                                     *
* Author: FKu                                                                    *
*********************************************************************************/
#include <YSI\y_hooks>
#define DIALOG_TUT 502
#define AMOUNT_OF_TUT 9


new InTutorial[MAX_PLAYERS] = -1,fku_a[MAX_PLAYERS];

new const Float:fku_location[][] =
{
	{0.0,0.0,0.0},//Starting
	{1967.6342,-1827.6594,35.6638},//IGS
	{1703.1172,-1482.5660,17.3828},//Ammunation + dealership
	{1350.0719,-1280.2190,17.3828},// Ammunation 2
	{1931.1523,-2355.8684,35.1541},// Airport
	{-2333.9050,-1671.9163,492.1759},//Vortex
	{-2447.7520,728.7117,41.0156},//Monster truck
	{-2742.1941,1806.8612,121.4267},//Golden bridge
	{-2742.1941,1806.8612,121.4267}//Golden bridge
};

new const Float:lookat[][] = {
	{0.0,0.0,0.0},//Starting
	{1932.0155,-1783.0994,18.6485},//IGS look at
	{1702.6571,-1470.6740,13.5469},//Ammunation + dealership look at
	{1367.9725,-1279.9274,13.5469},//Ammunation 2 look at
	{1976.3711,-2428.8799,13.5469},//Airport look at
	{-2331.6563,-1627.4834,483.7045},//Vortex lookat
	{-2427.2122,740.1760,35.0156},//Monster trcuk look at
	{-2657.3555,1451.7407,67.4726},//Golden bridge look at
	{-2657.3555,1451.7407,67.4726}//Golden bridge look at
};

new const explain[][] = { //fixed version
        "{ffffff}Oh, hello there!\nThis tutorial will explain you some basic stuff about the server, so lets get started!\n\nPress next when you're done reading\nUse ESC to exit the tutorial.",//starting
        "{ffffff}This is the {ffea00}Idlewood Gas-Station {ffffff}turf, the turf allows you to get all kind of advantages over other players so make sure you get it for your team!\nUse ESC to exit the tutorial.",//IGS
        "{ffffff}This is the {ffea00}FoCo dealership{ffffff}, here you can buy your own vehicle and spawn it with {ffea00}/mycar{ffffff}.\nTo buy a car just type {ffea00}/buycar{ffffff} and a menu with all the vehicles will pop up.\n\nYou can also buy weapons here, just type {ffea00}/enter{ffffff} near the {ffea00}'i' {ffffff}mark and it will send you to the store.\nUse ESC to exit the tutorial.",//Ammunation +dealership
        "{ffffff}This is the second ammunation where you can buy weapons, just type {ffea00}/enter{ffffff} near the {ffea00}arrow{ffffff} and it will send you to the store.\nTo buy weapons in the ammunation type {ffea00}/buy {ffffff}and choose the weapons you want {aaaaab}(the weapons are temporary).\nUse ESC to exit the tutorial.",// Ammunation 2
        "{ffffff}There are vehicles scattered all over LS and there are a few in the other cities, feel free to take them for a spin.\nUse ESC to exit the tutorial.",// Airport
        "{ffffff}From time to time admins will start random events so type {ffea00}/join{ffffff} quickly to join them!\n\nTo talk with your teammates in the team chat just type {ffea00}/g [text]{ffffff}.\nUse ESC to exit the tutorial.",//vortex
        "{ffffff}To get permanent weapons all you need to do is to kill other players and level up! Once you level up they will show in the {ffea00}/class{ffffff} menu\nUse ESC to exit the tutorial.",//monster
        "{ffffff}I guess we are done here for now, if you have any questions use {ffea00}/helpme{ffffff} and we will make sure someone helps you.\n\nTo see all the commands on the server type {ffea00}/help{ffffff} and they will appear on the chat.\nUse ESC to exit the tutorial.",//bridge
        "{ffffff}Now off you go to kill some noobs! \nDont forget to type {ffea00}/class{ffffff} when you spawn to set and get your weapons!\nUse ESC to exit the tutorial or press next to re-do the tutorial."//bridge
};

CMD:tutorial(playerid, params[])
{
	new Float:health;
	GetPlayerHealth(playerid, health);
	
	if(health < 95.00)    {
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command whilst under 95 health");
		return 1;
	}
	if(FoCo_Playerstats[playerid][kills] >= 500)
	{
	    SendClientMessage(playerid, COLOR_WARNING, "You have 500+ kills, you should know your way around here by now! You may utilize /helpme for questions.");
	    return 1;
	}
	if(GetPVarInt(playerid,"PlayerStatus")!=0) return 1;
	if(InTutorial[playerid] == -1)
	{
		TogglePlayerSpectating(playerid,1);
		InTutorial[playerid] = 1;
		ShowTutorial(playerid);
	}
	else
	{
		SendClientMessage(playerid,0xcccfccff,"You are already in a tutorial!");
	}
	return 1;
}

hook OnPlayerDisconnect(playerid,reason)
{
	InTutorial[playerid] = -1;
	fku_a[playerid] = 0;
	return 1;
}
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    print("ODR_FKU_Tut");
	if(dialogid == DIALOG_TUT)
	{
		if(response)
		{
			ShowTutorial(playerid);
		}
		else
		{
			TogglePlayerSpectating(playerid,0);
			SpawnPlayer(playerid);
			InTutorial[playerid] = -1;
		}
	}
	return 1;
}

stock ShowTutorial(playerid)
{
	if(fku_a[playerid] == AMOUNT_OF_TUT)
	{
		TogglePlayerSpectating(playerid,0);
		SetCameraBehindPlayer(playerid);
		InTutorial[playerid] = -1;
		fku_a[playerid] = 0;
	}
	SetPlayerCameraPos(playerid, fku_location[fku_a[playerid]][0], fku_location[fku_a[playerid]][1], fku_location[fku_a[playerid]][2]);
	SetPlayerCameraLookAt(playerid, lookat[fku_a[playerid]][0], lookat[fku_a[playerid]][1], lookat[fku_a[playerid]][2]);
	ShowPlayerDialog(playerid,DIALOG_TUT,DIALOG_STYLE_MSGBOX,"FoCo Tutorial",explain[fku_a[playerid]],"Next","");
	fku_a[playerid]++;
}
