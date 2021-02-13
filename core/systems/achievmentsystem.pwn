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
* Filename:  achievementystem.pwn                                                *
* Author:    Marcel                                                              *
*********************************************************************************/
#include <YSI\y_hooks>

hook OnPlayerSpawn(playerid)
{
   	GiveAchievement(playerid, 1);
   	return 1;
}

hook OnPlayerDeath(playerid,killerid,reason)
{
	//FIRST DEATH
	GiveAchievement(playerid, 11);
	if(killerid != INVALID_PLAYER_ID)
	{
		GiveAchievement(killerid, 2);
		if(CurrentKillStreak[playerid] >= 5)
		{
			GameTextForPlayer(killerid, "You ended a kill streak!", 900, 4);
			FoCo_Player[killerid][score] = FoCo_Player[killerid][score]+3;
			GiveAchievement(killerid, 40);
			SetPVarInt(killerid, "IsOnKillStreak", 0);
		}
		//FIRST ADMIN KILL
		if(FoCo_Player[playerid][admin] > 0)
		{
			GiveAchievement(killerid, 7);
		}
		//KILLED MOW
		if(FoCo_Player[playerid][id] == 1)
		{
			GiveAchievement(killerid, 8);
		}
		//KILLED DAMIAN
		if(FoCo_Player[playerid][id] == 847)
		{
			GiveAchievement(killerid, 38);
		}
		//KILLED PEAR
		if(FoCo_Player[playerid][id] == 368)
		{
		    GiveAchievement(killerid, 4);
		}
		if(CurrentKillStreak[killerid] >= 5)
		{
   			GiveAchievement(killerid, 5);
   			if(CurrentKillStreak[killerid] >= 10)
   			{
   				GiveAchievement(killerid, 6);
			}
		}
		switch(reason)
		{
		    case 4: GiveAchievement(killerid, 20);
		    case 9: GiveAchievement(killerid, 17);
		    case 22,23: GiveAchievement(killerid, 19);
		    case 27: GiveAchievement(killerid, 18);
		    case 29: GiveAchievement(killerid, 14);
		    case 30: GiveAchievement(killerid, 10);
		    case 31: GiveAchievement(killerid, 9);
		    case 32: GiveAchievement(killerid, 21);
		    case 34: GiveAchievement(killerid, 22);
		    case 35,36: GiveAchievement(killerid, 15);
		    case 37: GiveAchievement(killerid, 16);
		}
		
		if(FoCo_Playerstats[killerid][kills] == RANK_ONE)
		{
			GiveAchievement(killerid, 28);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_TWO)
		{
			GiveAchievement(killerid, 29);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_THREE)
		{
			GiveAchievement(killerid, 30);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_FOUR)
		{
			GiveAchievement(killerid, 31);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_FIVE)
		{
			GiveAchievement(killerid, 32);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_SIX)
		{
			GiveAchievement(killerid, 33);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_SEVEN)
		{
			GiveAchievement(killerid, 34);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_EIGHT)
		{
			GiveAchievement(killerid, 35);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_NINE)
		{
			GiveAchievement(killerid, 36);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_TEN)
		{
			GiveAchievement(killerid, 37);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
	}
	if(killerid == INVALID_PLAYER_ID) //SWITCH NON PLAYER INOLVED DEATHS
	{
	    GiveAchievement(playerid, 12); // Suicide Achievement
	}
	
	return 1;
}
