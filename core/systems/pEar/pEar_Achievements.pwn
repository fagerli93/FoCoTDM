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
* Filename: AchievementSystem.pwn                                                *
* Author: pEar	                                                                 *
*********************************************************************************/
#include <YSI\y_hooks>

/*
Callback hooks:
- OnPlayerSpawn
- OnPlayerDeath
- OnPlayerRequestSpawn
*/

#define ACHIEVEMENT_PAGES 6
// forward public GetAchievementPage(playerid, page);

enum FoCo_Achievement_Info
{
	aid,
	aname[75],
	ascore,
	adescription[150]
};

new FoCo_Achievements[][FoCo_Achievement_Info] =
{
	{0, "N/A", 0, "N/A"},
	{1, "1) Registering In Game", 10, "Successfully registered in-game!"}, //  								:D If finished, they will have :D behind
	{2, "2) Getting started", 4, "Got your first kill"},//        							:D
	{3, "3) Going the wrong way", 2, "First suicide"},//                                :D
	{4, "4) Fruitinator", 10, "Killed pEar"},//                                        :D
	{5, "5) Sys-Admin Assassin", 50, "Killed Mow"},//                                :D
	{6, "6) More like Dr_Dead", 5, "Killed Dr_Death"},//                                 :D
	{7, "7) Lee PeeCock.. Hehe", 25, "Killed Shaney"},//                                 :D
	{8, "8) Rookie Killer", 5, "Killed a trial administrator"},//                         :D
	{9, "9) Admin Slayer", 6, "Killed an administrator"},//                     :D
	{10, "10) Dragon Slayer", 10, "Killed a lead administrator"},//                 :D
	{11, "11) Pow Pow", 5, "Killed a clan leader"},//                        :D
	{12, "12) Manhunt.. Suitable", 4, "Killed the manhunt target"},//                           :D
	{13, "13) Agent 47", 2, "Killed a player with a hit on them"},                  //                        :D Added under hitsystem.pwn, line 124.
	{14, "14) Baby Killing Machine", 2, "Get a kill streak of 5+"},//                              :D
	{15, "15) Killing Machine", 4, "Get a kill streak of 10+"},//                            :D
	{16, "16) God Like", 10, "Get a kill streak of 25+"},//                                   :D
	{17, "17) One Man Army!", 25, "Get a kill streak of 50+"},//                                     :D
	{18, "18) Fist Pump", 4, "Get a kill using your fists"},//                                         :D
	{19, "19) Backstab", 2, "Get a kill using a melee weapon"},//                                          :D
	{20, "20) Chainsaw Massacre", 1, "Get a kill using a chainsaw"},//                                 :D
	{21, "21) Small gun, big man", 1, "Get a kill using a pistol"},//      :D
	{22, "22) Ratatat", 1, "Get a kill using an SMG"},//                                           :D
	{23, "23) Bring out Bertha", 1, "Get a kill using a shotgun"},//                                  :D
	{24, "24) Serious Firepower", 1, "Get a kill using an assault rifle"},//                                 :D
	{25, "25) Marksman", 1, "Get a kill using a rifle"},  //                                        :D
	{26, "26) C4 Yourself", 1, "Get a kill an explosive device"}, //                                      :D
	{27, "27) Flower Power", 5, "Get a kill using flowers"},  //                                    :D
	{28, "28) Rapist", 10, "Get a kill using a dildo"},//                                            :D
	{29, "29) Compensating?", 2, "Get a kill using a minigun"},//                       :D
	{30, "30) Pyromaniac", 2, "Get a kill using a flamethrower or molotov"},//                                        :D
	{31, "31) al-Qaida", 2, "Get a kill using an RPG/HeatSeeker"},//                                          :D
	{32, "32) Rammed!", 5, "Get a kill using a vehicle"},//                            :D
	{33, "33) Pearl Harbour", 5, "Get a kill using a rustler"},//                                     :D
	{34, "34) One is not enough", 5, "Reach level 1"},//                                 :D
	{35, "35) Getting somewhere", 5, "Reach level 2"},//                                 :D
	{36, "36) Newborn Killer", 5, "Reach level 3"},//                                    :D
	{37, "37) Soldier", 5, "Reach level 4"},//                                           :D
	{38, "38) Exterminator", 5, "Reach level 5"},//                                      :D
	{39, "39) Executioner", 2, "Reach level 6"},   //                                    :D
	{40, "40) Mass Murderer", 7, "Reach level 7"},   //                                  :D
	{41, "41) Professional Hitman", 4, "Reach level 8"},//                               :D
	{42, "42) Gotta kill them all", 4, "Reach level 9"},//                               :D
	{43, "43) One to rule them all", 4, "Reach level 10"},//                              :D
	{44, "44) First deal", 4, "Buy a weapon in the ammunation"},//                                        :D Added under chilco_ammunation.pwn, line 468
	{45, "45) Karma's a bitch", 4, "End a 5+ kill streak"},//                                   :D}
	{46, "46) Not today!", 4, "End a 10+ kill streak"},//                         :D
	{47, "47) A real pain", 4, "End a 25+ kill streak"},//                            :D
	{48, "48) Killed Osama", 4, "End a 50+ kill streak"},//                                      :D
	{49, "49) Eye for an eye", 4, "Reach a K/D ratio of 1.0+"},//                                    :D
	{50, "50) Better than most", 4, "Reach a K/D ratio of 1.5+"},//                  :D
	{51, "51) Living Legend", 4, "Reach a K/D ratio of 2.0+"},//                                     :D
	{52, "52) Lagger", 4, "Reach a K/D ratio of 3.0+"},//                                            :D
	{53, "53) Hacker", 4, "Reach a K/D ratio of 5.0+"},//                                            :D
	{54, "54) 1337", 4, "Reach 1337 kills"},//                                              :D
	{55, "55) $k", 4, "Reach a total of 5,000 kills"},//                                             	:D
	{56, "56) 1Ok", 4, "Reach a total of 10,000 kills"},//                                             	:D
	{57, "57) $*4k", 4, "Reach a total of 20,000 kills"},//                                             	:D
	{58, "58) $0k", 4, "Reach a total of 50,000 kills"},//                                             	:D
	{59, "59) How many kills?..", 4, "Reach a total of 100,000 kills"},//                      :D
	{60, "60) Wealthy", 4, "Place a hit of 10,000$+"},//                                           :D Added under hitsystem.pwn, line 189
	{61, "61) Rich", 4, "Place a hit of 50,000$+"},//                                              :D ^
	{62, "62) Wanted", 4, "Have a hit placed on you for 10,000$+"},//                                            :D ^
	{63, "63) Most Wanted", 4, "Have a hit placed on you for 50,000$+"},//                                       :D ^
	{64, "64) Very Important Person", 4, "Get VIP status in-game"},//                             :D Added under case 4, admincommands.pwn, CMD:setstatnew & OnPlayerConnect
	{65, "65) Turfwar", 4, "Capture the turf during a turfwar"},//                                           :D Added under turfwar.pwn, line 545
	{66, "66) Looky here..", 4, "Find a special weapons pickup"},//                    :D Added under OnPlayerPickUpDinamicPickup, line 138, weaponpickups.pwn
	{67, "67) One down, many to go", 4, "Spend an hour in-game"},//                         :D
	{68, "68) Still new", 4, "Spend 10 hours in-game"},//                                         :D
	{69, "69) Now we're talking", 4, "Spend a day in-game"},//                                 :D
	{70, "70) Life is a game", 4, "Spend 5 days in-game"},//                                    :D
	{71, "71) Outside?", 4, "Spend 10 days in-game"},//               :D
	{72, "72) RL, what is that?", 4, "Spend 25 days in-game"},//                :D
	{73, "73) Married2myPC", 4, "Spend 50 days in-game"},//  :D
	{74, "74) Virtual > Real Life", 4, "Spend 100 days in-game"},//                          :D
	{75, "75) Never Alone", 4, "Join a clan"},//                                       :D Added under CMD:accept, line 879, playercommands.pwn
	{76, "76) Pimp my ride", 4, "Modify a vehicle"},//                                      :D Added under CMD:mod, line 1628, playercommands.pwn
	{77, "77) Join in on the fun", 4, "Join a event"},//                                :D Added under CMD:join, line 6069, event.pwn
	{78, "78) Prison Break", 4, "Evade the police in the pursuit event"},//                                      :D Added under timer endpursuit n highspeed, line 2113, event.pwn
	{79, "79) Call in the coroner", 4, "Kill the criminal in the pursuit event"},//                               :D Added under event_onplayerdeath, line 1666 event.pwn
	{80, "80) Bullets all over", 4, "Win the minigun event"},//            :D Added under minigun_playerleftevent, line 4258 event.pwn
	{81, "81) Heavyweight Champion", 4, "Win a sumo event"},//                              :D Added under sumo_playerleftevent, line 5702, event.pwn
	{82, "82) Thunderbirds are go!", 4, "Win the hydra event"},//                              :D Added under hydra_playerleftevent, line 3900 event.pwn
	{83, "83) The one and only", 4, "Come 1st in either the maddogs or the bigsmoke event"},//                                  :D Added under EndEvent, line 2520 event.pwn
	{84, "84) Runner-up", 4,"Come 2nd in either the maddogs or the bigsmoke event"},//                  :D ^
	{85, "85) Third works", 4, "Come 3rd in the maddogs or the bigsmoke event"},//                       :D ^
	{86, "86) leet", 4, "Buy 1337 ammo in the ammunation"},//                                              :D Added under chilco_ammunation.pwn, line 291
	{87, "87) Vrom Vrom", 4, "Buy a vehicle"},//                                         :D Added under filesystem.pwn, line 429 under MYSQL_THREAD_B_CAR
	{88, "88) Bling Vrom", 4, "Buy a vehicle that costs 100,000$+"},//                             ^
	{89, "89) My precious!", 4, "Capture a care package"},//                                      :D Added under vista_CaptureSuccessful, line 626 vista_carepackage.pwn
	{90, "90) No care for you", 4, "Kill a player that is capturing a care package"},//                                   :D ^, OnPlayerDeath, 276
	{91, "91) Sit down", 4, "Win a duel"},//                          :D Added under DuelPlayerDeath, line 1673 chilco.duel.pwn
	{92, "92) I was lagging", 4, "Lose a duel"},//                                     ^
	{93, "93) I'm on fire", 4, "Win 10 duels"},//                                       ^
	{94, "94) Duel, anyone?", 4, "Win 100 duels"},//                          ^
	{95, "95) This is what I do", 4, "Win 500 duels"},//                            ^
	{96, "96) /helpme for help..", 4, "Become a trial administrator"},//                             :D Added under CMD:settrialadmin, line 4648 admincommands.pwn
	{97, "97) I got the power, pow!", 4, "Become an administrator"},//                             :D Added under CMD:setadmin, line 4616 admincommands.pwn
	{98, "98) Ban Incorporated", 4, "Become a lead administrator"},//                                  :D Added under CMD:setadmin, line 4619 admincommands.pwn
	{99, "99) Fruit Smoothie", 4, "Join the Capital Fruits clan"},//                                    :D Added under CMD:accept, line 879 playercommands.pwn
	{100, "100) Helping out", 4, "Using the /report command"},//                            :D Added under CMD:report, line 1312 playercommands.pwn
	{101, "101) No wrong questions", 4, "Using the /helpme command"}//                           :D Added under CMD:helpme, line 35 chilco_helpme.pwn
};

hook OnPlayerRequestSpawn(playerid)
{
    if(gPlayerLogged[playerid] == 1)
    {
    	if(FoCo_Player[playerid][donation] > 0)         // Is VIP
	    {
	        GiveAchievement(playerid, 64);
	    }
	    if(FoCo_Player[playerid][tester] == 1)          // Is a trial
	    {
	    	GiveAchievement(playerid, 96);
	    }
	    if(FoCo_Player[playerid][admin] > 0)        	// Is an admin / lead admin
	    {
	        GiveAchievement(playerid, 97);
	        if(FoCo_Player[playerid][admin] == 5)
	        {
	            GiveAchievement(playerid, 98);
	        }
		}
		if(FoCo_Playerstats[playerid][kills] >= RANK_TEN)
		{
		    new i;
		    for(i = 34; i < 44; i++)
		    {
		        GiveAchievement(playerid, i);
		    }
		    return 1;
		}
		else if(FoCo_Playerstats[playerid][kills] >= RANK_NINE)
		{
		    new i;
		    for(i = 34; i < 43; i++)
		    {
		        GiveAchievement(playerid, i);
		    }
		    return 1;
		}
		else if(FoCo_Playerstats[playerid][kills] >= RANK_EIGHT)
		{
		    new i;
		    for(i = 34; i < 42; i++)
		    {
		        GiveAchievement(playerid, i);
		    }
		    return 1;
		}
		else if(FoCo_Playerstats[playerid][kills] >= RANK_SEVEN)
		{
		    new i;
		    for(i = 34; i < 41; i++)
		    {
		        GiveAchievement(playerid, i);
		    }
		    return 1;
		}
		else if(FoCo_Playerstats[playerid][kills] >= RANK_SIX)
		{
		    new i;
		    for(i = 34; i < 40; i++)
		    {
		        GiveAchievement(playerid, i);
		    }
		    return 1;
		}
		else if(FoCo_Playerstats[playerid][kills] >= RANK_FIVE)
		{
		    new i;
		    for(i = 34; i < 39; i++)
		    {
		        GiveAchievement(playerid, i);
		    }
		    return 1;
		}
		else if(FoCo_Playerstats[playerid][kills] >= RANK_FOUR)
		{
		    new i;
		    for(i = 34; i < 38; i++)
		    {
		        GiveAchievement(playerid, i);
		    }
		    return 1;
		}
		else if(FoCo_Playerstats[playerid][kills] >= RANK_THREE)
		{
		    new i;
		    for(i = 34; i < 37; i++)
		    {
		        GiveAchievement(playerid, i);
		    }
		    return 1;
		}
		else if(FoCo_Playerstats[playerid][kills] >= RANK_TWO)
		{
		    new i;
		    for(i = 34; i < 36; i++)
		    {
		        GiveAchievement(playerid, i);
		    }
		    return 1;
		}
		else if(FoCo_Playerstats[playerid][kills] >= RANK_ONE)
		{
		    GiveAchievement(playerid, 34);
		    return 1;
		}
		return 1;
    }
    return 1;
}

hook OnPlayerSpawn(playerid)
{
	GiveAchievement(playerid, 1);
	if(FoCo_Player[playerid][onlinetime] >= 3600)                               // Checking online time.
	{
	    GiveAchievement(playerid, 67);
	    if(FoCo_Player[playerid][onlinetime] >= 36000)
		{
		    GiveAchievement(playerid, 68);
		    if(FoCo_Player[playerid][onlinetime] >= 86400)
			{
			    GiveAchievement(playerid, 69);
			    if(FoCo_Player[playerid][onlinetime] >= 432000)
				{
				    GiveAchievement(playerid, 70);
				    if(FoCo_Player[playerid][onlinetime] >= 864000)
					{
					    GiveAchievement(playerid, 71);
					    if(FoCo_Player[playerid][onlinetime] >= 2160000)
						{
						    GiveAchievement(playerid, 72);
						    if(FoCo_Player[playerid][onlinetime] >= 4320000)
							{
							    GiveAchievement(playerid, 73);
							    if(FoCo_Player[playerid][onlinetime] >= 8640000)
								{
								    GiveAchievement(playerid, 74);
								}
							}
						}
					}
				}
			}
		}
	}
	
	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	//DebugMsg("pAchStart");
	if(killerid != INVALID_PLAYER_ID)
	{
        GiveAchievement(killerid, 2); //Getting started
        if(CurrentKillStreak[playerid] >= 5)            // Ending a kill streak
        {
            GameTextForPlayer(killerid, "You ended a kill streak!", 900, 4);
			FoCo_Player[killerid][score] = FoCo_Player[killerid][score]+3;
			GiveAchievement(killerid, 45);
			SetPVarInt(killerid, "IsOnKillStreak", 0);
			if(CurrentKillStreak[playerid] >= 10)
			{
                GiveAchievement(killerid, 46);
                if(CurrentKillStreak[playerid] >= 25)
				{
				    GiveAchievement(killerid, 47);
				    if(CurrentKillStreak[playerid] >= 50)
					{
					    GiveAchievement(killerid, 48);
					}
				}
			}
			
        }
        if(CurrentKillStreak[killerid] >= 5)            // Getting a killstreak
        {
            GiveAchievement(killerid, 14);
            if(CurrentKillStreak[killerid] >= 10)
            {
                GiveAchievement(killerid, 15);
                if(CurrentKillStreak[killerid] >= 25)
	            {
	                GiveAchievement(killerid, 16);
	                if(CurrentKillStreak[killerid] >= 50)
		            {
		                GiveAchievement(killerid, 17);
		            }
	            }
            }
        }
        if(FoCo_Player[playerid][tester] == 1)          // Killing a trial admin
        {
            GiveAchievement(killerid, 8);
        }
        if(FoCo_Player[playerid][admin] > 0)        	// Killing an admin or lead admin
        {
            if(FoCo_Player[playerid][admin] >= 1 && FoCo_Player[playerid][admin] < 5)
            {
            	GiveAchievement(killerid, 9);
            }
            else
            {
                GiveAchievement(killerid, 10);
            }
        }
        if(FoCo_Player[playerid][id] == 1)      // Killed Mow
        {
            GiveAchievement(killerid, 5);
        }
		if(FoCo_Player[playerid][id] == 368)    // Killed pEar
		{
		    GiveAchievement(killerid, 4);
		}
		if(FoCo_Player[playerid][id] == 28261)  // Killed Dr_Death
		{
		    GiveAchievement(killerid, 6);
		}
		if(FoCo_Player[playerid][id] == 4)      // Killed Shaney
		{
		    GiveAchievement(killerid, 7);
		}
		if(FoCo_Player[playerid][clan] != -1 && FoCo_Player[playerid][clanrank] == 1)       // Killed a clan leader
		{
		    GiveAchievement(killerid, 11);
		}
        if(ManHuntID == playerid)
        {
            GiveAchievement(killerid, 12);
        }
        switch(reason)                                  // Different weapons
        {
            case 0: GiveAchievement(killerid, 18);
            case 1..8: GiveAchievement(killerid, 19);
            case 9: GiveAchievement(killerid, 20);
            case 10..13: GiveAchievement(killerid, 28);
            case 14: GiveAchievement(killerid, 27);
            case 15: GiveAchievement(killerid, 19);
            case 51:
			{
				if(GetPlayerWeapon(killerid) != -1)
				{
				    if(GetPlayerWeapon(killerid) == 40 || GetPlayerWeapon(killerid) == 39 || GetPlayerWeapon(killerid) == 16)
				    {
				        GiveAchievement(killerid, 26);
				    }
				    if(GetPlayerWeapon(killerid) == 35 || GetPlayerWeapon(killerid) == 36)
				    {
                        GiveAchievement(killerid, 31);
				    }
				}
			}
            case 18: GiveAchievement(killerid, 30);
            case 22..24: GiveAchievement(killerid, 21);
            case 25..27: GiveAchievement(killerid, 23);
            case 28,29: GiveAchievement(killerid, 22);
            case 30:
            {
                GiveAchievement(killerid, 24);
            }
            case 31:
			{
                if(GetPlayerState(killerid) != PLAYER_STATE_DRIVER)      // M4 kill
				{
					GiveAchievement(killerid, 24);
				}
				else
				{
                    if(GetPlayerVehicleID(killerid) == 476)        // Rustler kill
					{
					    GiveAchievement(killerid, 33);
					}
				}
			} 
            case 32: GiveAchievement(killerid, 22);
            case 33,34: GiveAchievement(killerid, 25);
            case 37: GiveAchievement(killerid, 30);
            case 38: GiveAchievement(killerid, 29);
            case 49: GiveAchievement(killerid, 32);
		}
		
		if(FoCo_Playerstats[killerid][kills] == RANK_ONE-1)
		{
			GiveAchievement(killerid, 34);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_TWO-1)
		{
			GiveAchievement(killerid, 35);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_THREE-1)
		{
			GiveAchievement(killerid, 36);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_FOUR-1)
		{
            GiveAchievement(killerid, 37);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_FIVE-1)
		{
			GiveAchievement(killerid, 38);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_SIX-1)
		{
			GiveAchievement(killerid, 39);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_SEVEN-1)
		{
			GiveAchievement(killerid, 40);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_EIGHT-1)
		{
		    GiveAchievement(killerid, 41);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_NINE-1)
		{
		    GiveAchievement(killerid, 42);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_TEN-1)
		{
			GiveAchievement(killerid, 43);
			GiveAchievement(killerid, 54);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] >= 1336)
		{
		    GiveAchievement(killerid, 54);
  			if(FoCo_Playerstats[killerid][kills] >= 4999)
			{
			    GiveAchievement(killerid, 55);
	      		if(FoCo_Playerstats[killerid][kills] >= 9999)
				{
				    GiveAchievement(killerid, 56);
				    if(FoCo_Playerstats[killerid][kills] >= 24999)
					{
					    GiveAchievement(killerid, 57);
					    if(FoCo_Playerstats[killerid][kills] >= 49999)
						{
						    GiveAchievement(killerid, 58);
						    if(FoCo_Playerstats[killerid][kills] >= 99999)
							{
							    GiveAchievement(killerid, 59);
							}
						}
					}
				}
			}
		}
		
		new Float:KDR = floatdiv(FoCo_Playerstats[killerid][kills], FoCo_Playerstats[killerid][deaths]);
		if(KDR >= 1.0)                             														 // KDR
		{
		    GiveAchievement(killerid, 49);
		    if(KDR >= 1.5)
			{
			    GiveAchievement(killerid, 50);
			    if(KDR >= 2.0)
				{
                    GiveAchievement(killerid, 51);
				    if(KDR >= 3.0)
					{
                        GiveAchievement(killerid, 52);
					    if(KDR >= 5.0)
						{
						    GiveAchievement(killerid, 53);
						}
					}
				}
			}
		}
	}
	else
	{
	    GiveAchievement(playerid, 3);
	}
	//DebugMsg("pAchEnd");
	return 1;
}

stock GetAchievementStatus(playerid, ach_id)
{
	return FoCo_PlayerAchievements[playerid][ach_id];
}

CMD:resetachievements(playerid, params[])
{
	new i;
	for(i = 1; i < AMOUNT_ACHIEVEMENTS; i++)
	{
	    UpdateAchievementStatus(playerid, i, 0);
	}
	return 1;
}

/* Leaving this here for review. Its found under functions.pwn

public GiveAchievement(playerid, achieveid)
{
	if(FoCo_PlayerAchievements[playerid][achieveid] != 0)
	{
		return 1;
	}
	new string[128], description[56], cell1[12];
	format(string, sizeof(string), "[ACHIEVEMENT]: '%s' - You have gained %d score", FoCo_Achievements[achieveid][aname], FoCo_Achievements[achieveid][ascore]);
	SendClientMessage(playerid, COLOR_NOTICE, string);

	FoCo_PlayerAchievements[playerid][achieveid] = 1;

	format(description, sizeof(description), "%s", substr(FoCo_Achievements[achieveid][aname], 1, strlen(FoCo_Achievements[achieveid][aname])));
	format(cell1, sizeof(cell1), "%s", substr(FoCo_Achievements[achieveid][aname], 0, 1));
	format(string, sizeof(string), "~r~%s~w~%s!~n~~r~+~w~%i score", cell1, description, FoCo_Achievements[achieveid][ascore]);

	TextDrawSetString(AchieveInfoTD[playerid], string);
	TextDrawShowForPlayer(playerid, AchieveBoxTD);
	TextDrawShowForPlayer(playerid, AchieveInfoTD[playerid]);
	TextDrawShowForPlayer(playerid, AchieveAqcTD);
	TextDrawShowForPlayer(playerid, AchieveFoCoTD);

	defer achievementTimer(playerid);
	//AchievementTimer[playerid] = 6;
	return 1;
}
*/
stock GetAchievementPage(playerid, page)
{
	new i, pagestring[80], val, finished_ach;
	finished_ach = 0;
	for(i = 1; i < AMOUNT_ACHIEVEMENTS+1; i++)
	{
	    val = GetAchievementStatus(playerid, i);
	    if(val == 1)
	    {
	        finished_ach++;
	    }
	}
	format(pagestring, sizeof(pagestring), "%s's(%d) Achievements. Page: %d/%d - Completed: %d/%d",PlayerName(playerid), playerid, page, ACHIEVEMENT_PAGES, finished_ach, AMOUNT_ACHIEVEMENTS);
	return pagestring;
}

stock GetAchievementsListStr(name[], value)
{
	new str[56];
	
	if(!value)
	{
	    format(str, sizeof(str), "%s {FF0000}[Incomplete]{FF0000}\n", name);
	}
	else
	{
	    format(str, sizeof(str), "%s {15ED9A}[Completed]{15ED9A}\n", name);
	}
	return str;
}

stock GetAchievementsList(playerid)
{
	new list[1024];
	strcat(list, GetAchievementsListStr(FoCo_Achievements[1][aname], GetAchievementStatus(playerid, 1)));                             	// If it has // after it, it is completed and implemented. This is not yet completed though.....
	strcat(list, GetAchievementsListStr(FoCo_Achievements[2][aname], GetAchievementStatus(playerid, 2)));                                	// First kill / kill another player
	strcat(list, GetAchievementsListStr(FoCo_Achievements[3][aname], GetAchievementStatus(playerid, 3)));                            	// First suicide
	strcat(list, GetAchievementsListStr(FoCo_Achievements[4][aname], GetAchievementStatus(playerid, 4)));                                    	// Killed pEar
	strcat(list, GetAchievementsListStr(FoCo_Achievements[5][aname], GetAchievementStatus(playerid, 5)));                               	// Killed Mow
	strcat(list, GetAchievementsListStr(FoCo_Achievements[6][aname], GetAchievementStatus(playerid, 6)));                                 	// Kill Dr_Death
	strcat(list, GetAchievementsListStr(FoCo_Achievements[7][aname], GetAchievementStatus(playerid, 7)));                              // Kill Shaney
	strcat(list, GetAchievementsListStr(FoCo_Achievements[8][aname], GetAchievementStatus(playerid, 8)));                         // Killed a trial admin
	strcat(list, GetAchievementsListStr(FoCo_Achievements[9][aname], GetAchievementStatus(playerid, 9)));                     // Killed an administrator
	strcat(list, GetAchievementsListStr(FoCo_Achievements[10][aname], GetAchievementStatus(playerid, 10)));                 // Killed a lead administator
	strcat(list, GetAchievementsListStr(FoCo_Achievements[11][aname], GetAchievementStatus(playerid, 11)));                         // Killed a clan leader
	strcat(list, GetAchievementsListStr(FoCo_Achievements[12][aname], GetAchievementStatus(playerid, 12)));                           // Killed the manhunt target
	strcat(list, GetAchievementsListStr(FoCo_Achievements[13][aname], GetAchievementStatus(playerid, 13)));                							// Killed someone with a hit on them
	strcat(list, GetAchievementsListStr(FoCo_Achievements[14][aname], GetAchievementStatus(playerid, 14)));                           	// Get a kill spree of 5
	strcat(list, GetAchievementsListStr(FoCo_Achievements[15][aname], GetAchievementStatus(playerid, 15)));                        	// Get a kill spree of 10
	strcat(list, GetAchievementsListStr(FoCo_Achievements[16][aname], GetAchievementStatus(playerid, 16)));                           		// Get a kill spree of 25
	strcat(list, GetAchievementsListStr(FoCo_Achievements[17][aname], GetAchievementStatus(playerid, 17)));                                     // Get a kill spree of 50
	strcat(list, GetAchievementsListStr(FoCo_Achievements[18][aname], GetAchievementStatus(playerid, 18)));                                         // Get a kill using your fists only
	strcat(list, "NEXT->\n");
	strdel(list, strlen(list)-1, strlen(list));
	return list;
}

stock GetAchievementsList1(playerid)
{
	new list[1024];
	strcat(list, GetAchievementsListStr(FoCo_Achievements[19][aname], GetAchievementStatus(playerid, 19)));              						// Get a kill using a melee weapon
	strcat(list, GetAchievementsListStr(FoCo_Achievements[20][aname], GetAchievementStatus(playerid, 20)));                                 // Get a kill using a chainsaw
	strcat(list, GetAchievementsListStr(FoCo_Achievements[21][aname], GetAchievementStatus(playerid, 21)));      // Get a kill using a pistol
	strcat(list, GetAchievementsListStr(FoCo_Achievements[22][aname], GetAchievementStatus(playerid, 22)));                                           // Get a kill using an SMG
	strcat(list, GetAchievementsListStr(FoCo_Achievements[23][aname], GetAchievementStatus(playerid, 23)));                        			// Get a kill using a shotgun
	strcat(list, GetAchievementsListStr(FoCo_Achievements[24][aname], GetAchievementStatus(playerid, 24)));                                 // Get a kill using an assault rifle
	strcat(list, GetAchievementsListStr(FoCo_Achievements[25][aname], GetAchievementStatus(playerid, 25)));                                          // Get a kill using a rifle
	strcat(list, GetAchievementsListStr(FoCo_Achievements[26][aname], GetAchievementStatus(playerid, 26)));                                   // Get a kill using an explosive device
	strcat(list, GetAchievementsListStr(FoCo_Achievements[27][aname], GetAchievementStatus(playerid, 27)));                                      // Get a kill using flowers
	strcat(list, GetAchievementsListStr(FoCo_Achievements[28][aname], GetAchievementStatus(playerid, 28)));                                			// Get a kill using a dildo
	strcat(list, GetAchievementsListStr(FoCo_Achievements[29][aname], GetAchievementStatus(playerid, 29)));                       // Get a kill using a minigun
	strcat(list, GetAchievementsListStr(FoCo_Achievements[30][aname], GetAchievementStatus(playerid, 30)));                                        // Get a kill using a flamethrower
	strcat(list, GetAchievementsListStr(FoCo_Achievements[31][aname], GetAchievementStatus(playerid, 31)));                                          // Get a kill using an RPG
	strcat(list, GetAchievementsListStr(FoCo_Achievements[32][aname], GetAchievementStatus(playerid, 32)));                            // Get a kill using a vehicle
	strcat(list, GetAchievementsListStr(FoCo_Achievements[33][aname], GetAchievementStatus(playerid, 33)));                                     // Get a kill using a rustler
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[34][aname], GetAchievementStatus(playerid, 34)));                                 // Rank 1
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[35][aname], GetAchievementStatus(playerid, 35)));                                 // Rank 2
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[36][aname], GetAchievementStatus(playerid, 36)));                                    // Rank 3
 	strcat(list, "NEXT ->\n");
 	strcat(list, "<- PREVIOUS.");
	strdel(list, strlen(list)-1, strlen(list));
	return list;
}

stock GetAchievementsList2(playerid)
{
	new list[1024];
	strcat(list, GetAchievementsListStr(FoCo_Achievements[37][aname], GetAchievementStatus(playerid, 37)));                                    		// Rank 4
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[38][aname], GetAchievementStatus(playerid, 38)));                                    	// Rank 5
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[39][aname], GetAchievementStatus(playerid, 39)));                                    	// Rank 6
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[40][aname], GetAchievementStatus(playerid, 40)));                                    	// Rank 7
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[41][aname], GetAchievementStatus(playerid, 41)));                               // Rank 8
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[42][aname], GetAchievementStatus(playerid, 42)));                               // Rank 9
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[43][aname], GetAchievementStatus(playerid, 43)));                              // Rank 10
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[44][aname], GetAchievementStatus(playerid, 44)));                                        // Bought a weapon in the ammunation
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[45][aname], GetAchievementStatus(playerid, 45)));                                   // End a 5+ kill spree
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[46][aname], GetAchievementStatus(playerid, 46)));                         // End a 10+ kill spree
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[47][aname], GetAchievementStatus(playerid, 47)));                            // End  25+ kill spree
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[48][aname], GetAchievementStatus(playerid, 48)));                                      // End a 50+ kill spree
  	strcat(list, GetAchievementsListStr(FoCo_Achievements[49][aname], GetAchievementStatus(playerid, 49)));                                    // Reach a K/D of 1.0+
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[50][aname], GetAchievementStatus(playerid, 50)));                  // Reach a K/D of 1.5+
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[51][aname], GetAchievementStatus(playerid, 51)));                                     // Reached a K/D of 2.0+
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[52][aname], GetAchievementStatus(playerid, 52)));                                            // Reached a K/D of 3.0+
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[53][aname], GetAchievementStatus(playerid, 53)));                                            // Reach a K/D of 5.0+
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[54][aname], GetAchievementStatus(playerid, 54)));                                              // Reached 1337 kills
 	strcat(list, "NEXT ->\n");
 	strcat(list, "<- PREVIOUS.");
 	strdel(list, strlen(list)-1, strlen(list));
	return list;
}

stock GetAchievementsList3(playerid)
{
	new list[1024];

 	strcat(list, GetAchievementsListStr(FoCo_Achievements[55][aname], GetAchievementStatus(playerid, 55)));                                                // Reach 5k kills
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[56][aname], GetAchievementStatus(playerid, 56)));                                               // Reach 10k kills
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[57][aname], GetAchievementStatus(playerid, 57)));                                              // Reach 20k kills
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[58][aname], GetAchievementStatus(playerid, 58)));                                               // Reach 50k kills
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[59][aname], GetAchievementStatus(playerid, 59)));                      // Reach 100k kills
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[60][aname], GetAchievementStatus(playerid, 60)));                                           // Place a hit of 10k+
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[61][aname], GetAchievementStatus(playerid, 61)));                                              // Place a hit of 50k+
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[62][aname], GetAchievementStatus(playerid, 62)));                                            // Have a hit placed on you for 10k+
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[63][aname], GetAchievementStatus(playerid, 63)));                                       // Have a hit placed on you for 50k+
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[64][aname], GetAchievementStatus(playerid, 64)));                             // Get VIP status IG
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[65][aname], GetAchievementStatus(playerid, 65)));                                           // Capture a turf
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[66][aname], GetAchievementStatus(playerid, 66)));                       // Find a special weapons pickup
	strcat(list, GetAchievementsListStr(FoCo_Achievements[67][aname], GetAchievementStatus(playerid, 67)));                         // Spend an hour IG
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[68][aname], GetAchievementStatus(playerid, 68)));                                         // Spend 10 hours IG
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[69][aname], GetAchievementStatus(playerid, 69)));                                 // Spend a day IG
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[70][aname], GetAchievementStatus(playerid, 70)));                                    // Spend 5 days+ IG
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[71][aname], GetAchievementStatus(playerid, 71)));                 // 10+ days IG
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[72][aname], GetAchievementStatus(playerid, 72)));                // 25 days+ IG
 	strcat(list, "NEXT ->\n");
 	strcat(list, "<- PREVIOUS.");
 	strdel(list, strlen(list)-1, strlen(list));
	return list;
}

stock GetAchievementsList4(playerid)
{
	new list[1024];

 	strcat(list, GetAchievementsListStr(FoCo_Achievements[73][aname], GetAchievementStatus(playerid, 73)));  // 50 days+ IG
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[74][aname], GetAchievementStatus(playerid, 74)));                          // 100 days+ IG
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[75][aname], GetAchievementStatus(playerid, 75)));                                     	// Joined a clan
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[76][aname], GetAchievementStatus(playerid, 76)));                                      // Modified a vehicle
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[77][aname], GetAchievementStatus(playerid, 77)));                                // Joined a event
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[78][aname], GetAchievementStatus(playerid, 78)));                                      // Evade the police in the pursuit event
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[79][aname], GetAchievementStatus(playerid, 79)));                      			// Kill the criminal in the pursuit event
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[80][aname], GetAchievementStatus(playerid, 80)));            // Win the minigun event
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[81][aname], GetAchievementStatus(playerid, 81)));                     			// Win the sumo event
  	strcat(list, GetAchievementsListStr(FoCo_Achievements[82][aname], GetAchievementStatus(playerid, 82)));                               // Win the hydra event
	strcat(list, GetAchievementsListStr(FoCo_Achievements[83][aname], GetAchievementStatus(playerid, 83)));                                  // Come 1st in either maddogs or bigsmoke
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[84][aname], GetAchievementStatus(playerid, 84)));                  // Come 2nd in either maddogs or bigsmoke
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[85][aname], GetAchievementStatus(playerid, 85)));                       // Come 3rd in either maddogs or bigsmoke
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[86][aname], GetAchievementStatus(playerid, 86)));                                              // Buy 1337 ammo in ammunation
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[87][aname], GetAchievementStatus(playerid, 87)));                                         // Buy a vehicle
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[88][aname], GetAchievementStatus(playerid, 88)));                             // Buy a vehicle to 100k+
 	strcat(list, "NEXT ->\n");
 	strcat(list, "<- PREVIOUS.");
 	strdel(list, strlen(list)-1, strlen(list));
	return list;
}

stock GetAchievementsList5(playerid)
{
	new list[1024];

 	strcat(list, GetAchievementsListStr(FoCo_Achievements[89][aname], GetAchievementStatus(playerid, 89)));                            			// Capture a care package
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[90][aname], GetAchievementStatus(playerid, 90)));                                   // Kill a player that is capturing a care package
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[91][aname], GetAchievementStatus(playerid, 91)));                          // Win a duel
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[92][aname], GetAchievementStatus(playerid, 92)));                                     // Lose a duel
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[93][aname], GetAchievementStatus(playerid, 93)));                                       // Win 10 duels
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[94][aname], GetAchievementStatus(playerid, 94)));                          // Win 100 duels
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[95][aname], GetAchievementStatus(playerid, 95)));                            // Win 500 duels
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[96][aname], GetAchievementStatus(playerid, 96)));                            	// Become a trial admin
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[97][aname], GetAchievementStatus(playerid, 97)));                            	// Become an admin
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[98][aname], GetAchievementStatus(playerid, 98)));                                 	// Become a lead admin
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[99][aname], GetAchievementStatus(playerid, 99)));                                           	// Join capital fruits
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[100][aname], GetAchievementStatus(playerid, 100)));                            // Used the /report command
 	strcat(list, GetAchievementsListStr(FoCo_Achievements[101][aname], GetAchievementStatus(playerid, 101)));                          // Used the /helpme command
 	strcat(list, "<- PREVIOUS.");
 	strdel(list, strlen(list)-1, strlen(list));
	return list;
}


