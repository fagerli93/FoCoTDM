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
- OnDialogResponse
- OnPlayerConnect
- OnPlayerSpawn
- OnPlayerDeath
*/

forward GiveAchievement(playerid, achieveid);
#define AMOUNT_ACHIEVEMENTS 101

#define DIALOG_ACH1 227
#define DIALOG_ACH2 228
#define DIALOG_ACH3 229
#define DIALOG_ACH4 230
#define DIALOG_ACH5 231
#define DIALOG_ACH6 232
#define DIALOG_ACH7 233
#define DIALOG_ACH8 234
#define DIALOG_ACH9 235
#define DIALOG_ACH10 236
#define DIALOG_ACH11 237
#define DIALOG_ACH12 238
#define DIALOG_ACH13 239
#define DIALOG_ACH14 240
#define DIALOG_ACH15 241
#define DIALOG_ACH16 242
#define DIALOG_ACH17 243
#define DIALOG_ACH18 244
#define DIALOG_ACH19 245
#define DIALOG_ACH20 246
#define DIALOG_ACH21 247
#define DIALOG_ACH22 248
#define DIALOG_ACH23 249
#define DIALOG_ACH24 250
#define DIALOG_ACH25 251
#define DIALOG_ACH26 252
#define DIALOG_ACH27 253
#define DIALOG_ACH28 254
#define DIALOG_ACH29 255
#define DIALOG_ACH30 256
#define DIALOG_ACH31 257
#define DIALOG_ACH32 258
#define DIALOG_ACH33 259
#define DIALOG_ACH34 260
#define DIALOG_ACH35 261
#define DIALOG_ACH36 262
#define DIALOG_ACH37 263
#define DIALOG_ACH38 264
#define DIALOG_ACH39 265
#define DIALOG_ACH40 266
#define DIALOG_ACH41 267
#define DIALOG_ACH42 268
#define DIALOG_ACH43 269
#define DIALOG_ACH44 270
#define DIALOG_ACH45 271
#define DIALOG_ACH46 272
#define DIALOG_ACH47 273
#define DIALOG_ACH48 274
#define DIALOG_ACH49 275
#define DIALOG_ACH50 276
#define DIALOG_ACH51 277
#define DIALOG_ACH52 278
#define DIALOG_ACH53 279
#define DIALOG_ACH54 280
#define DIALOG_ACH55 281
#define DIALOG_ACH56 282
#define DIALOG_ACH57 283
#define DIALOG_ACH58 284
#define DIALOG_ACH59 285
#define DIALOG_ACH60 286
#define DIALOG_ACH61 287
#define DIALOG_ACH62 288
#define DIALOG_ACH63 289
#define DIALOG_ACH64 290
#define DIALOG_ACH65 291
#define DIALOG_ACH66 292
#define DIALOG_ACH67 293
#define DIALOG_ACH68 294
#define DIALOG_ACH69 295
#define DIALOG_ACH70 296
#define DIALOG_ACH71 297
#define DIALOG_ACH72 298
#define DIALOG_ACH73 299
#define DIALG_ACH74 300
#define DIALG_ACH75 301
#define DIALG_ACH76 302
#define DIALG_ACH77 303
#define DIALG_ACH78 304
#define DIALG_ACH79 3050
#define DIALG_ACH80 306
#define DIALG_ACH81 307
#define DIALG_ACH82 308
#define DIALG_ACH83 309
#define DIALG_ACH84 310
#define DIALG_ACH85 311
#define DIALG_ACH86 312
#define DIALG_ACH87 313
#define DIALG_ACH88 314
#define DIALG_ACH89 315
#define DIALG_ACH90 316
#define DIALG_ACH91 317
#define DIALG_ACH92 318
#define DIALG_ACH93 319
#define DIALG_ACH94 320
#define DIALG_ACH95 321
#define DIALG_ACH96 322
#define DIALG_ACH97 323
#define DIALG_ACH98 324
#define DIALG_ACH99 325
#define DIALG_ACH100 326
#define DIALG_ACH101 327

enum FoCo_Achievement_Info
{
	aid,
	adescription[75],
	ascore
};

new FoCo_Achievements[][FoCo_Achievement_Info] = {
	{0, "N/A", 0},
	{1, "Registering In Game", 2}, //  								:D If finished, they will have :D behind
	{2, "Getting started", 4},//        							:D
	{3, "Going the wrong way", 5},//                                :D
	{4, "Fruitinator", 5},//                                        :D
	{5, "Sys-Admin Assassin", 10},//                                :D
	{6, "More like Dr_Dead", 15},//                                 :D
	{7, "Lee PeeCock.. Hehe", 2},//                                 :D
	{8, "All they ever did was help", 5},//                         :D
	{9, "Expect a lengthy jail sentence", 2},//                     :D
	{10, "Stuck in that ban-appeal section?", 2},//                 :D
	{11, "I'll have my peepz on you!", 2},//                        :D
	{12, "Manhunt.. Suitable name", 2},//                           :D
	{13, "Agent 47", 2},                  //                        :D Added under hitsystem.pwn, line 124.
	{14, "Baby Killing Machine", 2},//                              :D
	{15, "Junior Killing Machine", 2},//                            :D
	{16, "Killing Machine", 4},//                                   :D
	{17, "One Man Army!", 4},//                                     :D
	{18, "Fist Pump", 4},//                                         :D
	{19, "Backstab", 4},//                                          :D
	{20, "Chainsaw Massacre", 4},//                                 :D
	{21, "My gun might be small, but you're still dead", 4},//      :D
	{22, "Ratatat", 4},//                                           :D
	{23, "Bring out Bertha", 2},//                                  :D
	{24, "Serious Firepower", 2},//                                 :D
	{25, "Marksman", 5},  //                                        :D
	{26, "C4 Yourself", 5}, //                                      :D
	{27, "Flower Power", 5},  //                                    :D
	{28, "Rapist", 5},//                                            :D
	{29, "Compensating for something?", 5},//                       :D
	{30, "Pyromaniac", 5},//                                        :D
	{31, "al-Qaida", 5},//                                          :D
	{32, "Vehicular Manslaughter", 5},//                            :D
	{33, "Pearl Harbour", 5},//                                     :D
	{34, "One is not enough", 5},//                                 :D
	{35, "Getting somewhere", 5},//                                 :D
	{36, "Newborn Killer", 5},//                                    :D
	{37, "Soldier", 5},//                                           :D
	{38, "Exterminator", 5},//                                      :D
	{39, "Executioner", 2},   //                                    :D
	{40, "Mass Murderer", 7},   //                                  :D
	{41, "Professional Hitman", 4),//                               :D
	{42, "Gotta kill them all", 4),//                               :D
	{43, "One to rule them all", 4),//                              :D
	{44, "First deal", 4),//                                        :D Added under chilco_ammunation.pwn, line 468
	{45, "Karma's a bitch", 4),//                                   :D
	{46, "You're not going anywhere", 4),//                         :D
	{47, "A real pain in the ass", 4),//                            :D
	{48, "Killed Osama", 4),//                                      :D
	{49, "Eye for an eye", 4),//                                    :D
	{50, "I'm more than what meets the eye", 4),//                  :D
	{51, "Living Legend", 4),//                                     :D
	{52, "Lagger", 4),//                                            :D
	{53, "Hacker", 4),//                                            :D
	{54, "1337", 4),//                                              :D
	{55, "$k", 4),//                                             	:D
	{56, "1Ok", 4),//                                             	:D
	{57, "$*4k", 4),//                                             	:D
	{58, "$0k", 4),//                                             	:D
	{59, "I've got more kills than you", 4),//                      :D
	{60, "Wealthy", 4),//                                           :D Added under hitsystem.pwn, line 189
	{61, "Rich", 4),//                                              :D ^
	{62, "Wanted", 4),//                                            :D ^
	{63, "Most Wanted", 4),//                                       :D ^
	{64, "Very Important Person", 4),//                             :D Added under case 4, admincommands.pwn, CMD:setstatnew & OnPlayerConnect
	{65, "Turfwar", 4),//                                           :D Added under turfwar.pwn, line 545
	{66, "Say hello to my little friend!", 4),//                    :D Added under OnPlayerPickUpDinamicPickup, line 138, weaponpickups.pwn
	{67, "One hour down, many to go", 4),//                         :D
	{68, "Still new", 4),//                                         :D
	{69, "Now we're talking", 4),//                                 :D
	{70, "Life is a game", 4),//                                    :D
	{71, "But mom, I don't want to go outside", 4),//               :D
	{72, "Real life, where can you buy that?", 4),//                :D
	{73, "I got married to my PC. that's not weird, right?", 4),//  :D
	{74, "Virtual Life > Real Life", 4),//                          :D
	{75, "Never Alone", 4),//                                       :D Added under CMD:accept, line 879, playercommands.pwn
	{76, "Pimp my ride", 4),//                                      :D Added under CMD:mod, line 1628, playercommands.pwn
	{77, "Join in on the fun", 4),//                                :D Added under CMD:join, line 6069, event.pwn
	{78, "Prison Break", 4),//                                      :D Added under timer endpursuit n highspeed, line 2113, event.pwn
	{79, "Call in the coroner", 4),//                               :D Added under event_onplayerdeath, line 1666 event.pwn
	{80, "Bullets flying all over, but not on me", 4),//            :D Added under minigun_playerleftevent, line 4258 event.pwn
	{81, "Heavyweight Champion", 4),//                              :D Added under sumo_playerleftevent, line 5702, event.pwn
	{82, "Thunderbirds are go!", 4),//                              :D Added under hydra_playerleftevent, line 3900 event.pwn
	{83, "The one and only", 4),//                                  :D Added under EndEvent, line 2520 event.pwn
	{84, "Second is simply not good enough", 4),//                  :D ^
	{85, "All good things go by three", 4),//                       :D ^
	{86, "leet", 4),//                                              :D Added under chilco_ammunation.pwn, line 291
	{87, "Vrom Vrom", 4),//                                         :D Added under filesystem.pwn, line 429 under MYSQL_THREAD_B_CAR
	{88, "Vrom Vrom Bling Bling", 4),//                             ^
	{89, "My precious!", 4),//                                      :D Added under vista_CaptureSuccessful, line 626 vista_carepackage.pwn
	{90, "No care for you", 4),//                                   :D ^, OnPlayerDeath, 276
	{91, "First came, first served", 4),//                          :D Added under DuelPlayerDeath, line 1673 chilco.duel.pwn
	{92, "I was lagging", 4),//                                     ^
	{93, "I'm on fire", 4),//                                       ^
	{94, "Do you feel lucky, punk?", 4),//                          ^
	{95, "I do this for a living", 4),//                            ^
	{96, "Helpme's is what I do", 4),//                             :D Added under CMD:settrialadmin, line 4648 admincommands.pwn
	{97, "I got the power, pow!", 4),//                             :D Added under CMD:setadmin, line 4616 admincommands.pwn
	{98, "Ban Incorporated", 4),//                                  :D Added under CMD:setadmin, line 4619 admincommands.pwn
	{99, "Fruit Smoothie", 4),//                                    :D Added under CMD:accept, line 879 playercommands.pwn
	{100, "Giving a helping hand", 4),//                            :D Added under CMD:report, line 1312 playercommands.pwn
	{101, "Nothing wrong in asking", 4)//                           :D Added under CMD:helpme, line 35 chilco_helpme.pwn

};

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
					    GiveAchievement(playerid, 70);
					    if(FoCo_Player[playerid][onlinetime] >= 2160000)
						{
						    GiveAchievement(playerid, 71);
						    if(FoCo_Player[playerid][onlinetime] >= 4320000)
							{
							    GiveAchievement(playerid, 72);
							    if(FoCo_Player[playerid][onlinetime] >= 8640000)
								{
								    GiveAchievement(playerid, 73);
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
	if(killerid != INVALID_PLAYER_ID)
	{
        GiveAchievement(playerid, 2);
        if(CurrentKillStreak[playerid] >= 5)            // Ending a kill streak
        {
            GameTextForPlayer(killerid, "You ended a kill streak!", 900, 4);
			FoCo_Player[killerid][score] = FoCo_Player[killerid][score]+3;
			GiveAchievement(killerid, 45);
			SetPVarInt(killerid, "IsOnKillStreak", 0);
			if(CurrentKillStreak[playerid] >= 10)
			{
                GiveAchievement(killerid, 46);
			}
			if(CurrentKillStreak[playerid] >= 25)
			{
			    GiveAchievement(killerid, 47);
			}
			if(CurrentKillStreak[playerid] >= 50)
			{
			    GiveAchievement(killerid, 48);
			}
        }
        if(CurrentKillStreak[killerid] >= 5)            // Getting a killstreak
        {
            GiveAchievement(killerid, 14);
            if(CurrentKillStreak[killerid] >= 10)
            {
                GiveAchievement(killerid, 15);
            }
            if(CurrentKillStreak[killerid] >= 25)
            {
                GiveAchievement(killerid, 16);
            }
            if(CurrentKillStreak[killerid] >= 50)
            {
                GiveAchievement(killerid, 17);
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
            case 16: GiveAchievement(killerid, 26);
            case 18: GiveAchievement(killerid, 30);
            case 22..24: GiveAchievement(killerid, 21);
            case 25..27: GiveAchievement(killerid, 23);
            case 28,29: GiveAchievement(killerid, 22);
            case 30,31: GiveAchievement(killerid, 24);
            case 32: GiveAchievement(killerid, 22);
            case 33,34: GiveAchievement(killerid, 25);
            case 35,36: GiveAchievement(killerid, 31);
            case 37: GiveAchievement(killerid, 30);
            case 38: GiveAchievement(killerid, 29);
            case 39: GiveAchievement(killerid, 26);
		}
		if(GetPlayerState(killerid) == PLAYER_STATE_DRIVER && FoCo_Player[killerid][admin] == 0)            // Vehicle kill
		{
			GiveAchievement(killerid, 32);
			if(GetPlayerVehicleID(killerid) == 476)        // Rustler kill
			{
			    GiveAchievement(killerid, 33);
			}
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_ONE)
		{
			GiveAchievement(killerid, 34);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_TWO)
		{
			GiveAchievement(killerid, 35);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_THREE)
		{
			GiveAchievement(killerid, 36);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_FOUR)
		{
			GiveAchievement(killerid, 37);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_FIVE)
		{
			GiveAchievement(killerid, 38);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_SIX)
		{
			GiveAchievement(killerid, 39);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_SEVEN)
		{
			GiveAchievement(killerid, 40);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_EIGHT)
		{
			GiveAchievement(killerid, 41);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_NINE)
		{
			GiveAchievement(killerid, 42);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == RANK_TEN)
		{
			GiveAchievement(killerid, 43);
			GiveAchievement(killerid, 54);
			FoCo_Player[killerid][level]++;
			SendClientMessage(killerid, COLOR_NOTICE, "Congratulations on your Promotion !");
		}
		if(FoCo_Playerstats[killerid][kills] == 5000)
		{
		    GiveAchievement(killerid, 55);
		}
		if(FoCo_Playerstats[killerid][kills] == 10000)
		{
		    GiveAchievement(killerid, 56);
		}
		if(FoCo_Playerstats[killerid][kills] == 25000)
		{
		    GiveAchievement(killerid, 57);
		}
		if(FoCo_Playerstats[killerid][kills] == 50000)
		{
		    GiveAchievement(killerid, 58);
		}
		if(FoCo_Playerstats[killerid][kills] == 100000)
		{
		    GiveAchievement(killerid, 59);
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
	else
	{
	    GiveAchievement(killerid, 2);
	}
	return 1;
}

hook OnPlayerConnect(playerid)
{
    if(FoCo_Player[targetid][donation] > 0)
    {
        GiveAchievement(playerid, 64);
    }
    return 1;
}

stock GetAchievementStatus(playerid, ach_id)
{
	return FoCo_PlayerAchievements[playerid][ach_id];
}

stock UpdateAchievementStatus(playerid, ach_id, value)
{
    new query[256];
	format(query, sizeof(query), "UPDATE FoCo_Achivements SET ach%d='%d' WHERE ID='%d'", ach_id, value, FoCo_Player[playerid][id]);
	mysql_query(query, MYSQL_LOAD_ACHIEVEMENTS, playerid, con);
	return;
}

public GiveAchievement(playerid, achieveid)
{
	if(FoCo_PlayerAchievements[playerid][achieveid] != 0)
	{
		return 1;
	}
	new string[128], description[56], cell1[12];
	format(string, sizeof(string), "[ACHIEVEMENT]: '%s' - You have gained %d score", FoCo_Achievements[achieveid][adescription], FoCo_Achievements[achieveid][ascore]);
	SendClientMessage(playerid, COLOR_NOTICE, string);

	FoCo_PlayerAchievements[playerid][achieveid] = 1;

	format(description, sizeof(description), "%s", substr(FoCo_Achievements[achieveid][adescription], 1, strlen(FoCo_Achievements[achieveid][adescription])));
	format(cell1, sizeof(cell1), "%s", substr(FoCo_Achievements[achieveid][adescription], 0, 1));
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

public GiveAchievement(playerid, achieveid)
{
	if(FoCo_PlayerAchievements[playerid][achieveid] != 0)
	{
		return 1;
	}
	new string[128], description[56], cell1[12];
	format(string, sizeof(string), "[ACHIEVEMENT]: '%s' - You have gained %d score", FoCo_Achievements[achieveid][adescription], FoCo_Achievements[achieveid][ascore]);
	SendClientMessage(playerid, COLOR_NOTICE, string);

	FoCo_PlayerAchievements[playerid][achieveid] = 1;

	format(description, sizeof(description), "%s", substr(FoCo_Achievements[achieveid][adescription], 1, strlen(FoCo_Achievements[achieveid][adescription])));
	format(cell1, sizeof(cell1), "%s", substr(FoCo_Achievements[achieveid][adescription], 0, 1));
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

stock GetAchievementsListStr(name[], value)
{
	new str[56];
	
	if(value == 0)
	{
	    format(str, sizeof(str), "%s [{FF0000}Incomplete{FF0000}]\n", name);
	}
	else
	{
	    format(str, sizeof(str), "%s [{15ED9A}Completed{15ED9A}]\n", name);
	}
	return str;
}

stock GetAchievementsList(playerid)
{
	new list[512];
	strcat(list, GetAchievementsListStr("1) Registered In Game", GetAchievementStatus(playerid, 1));                             	// If it has // after it, it is completed and implemented. This is not yet completed though.....
	strcat(list, GetAchievementsListStr("2) Getting started", GetAchievementStatus(playerid, 2));                                	// First kill / kill another player
	strcat(list, GetAchievementsListStr("3) Going the wrong way", GetAchievementStatus(playerid, 3));                            	// First suicide
	strcat(list, GetAchievementsListStr("4) Fruitinator", GetAchievementStatus(playerid, 4));                                    	// Killed pEar
	strcat(list, GetAchievementsListStr("5) Sys-Admin Sssassin", GetAchievementStatus(playerid, 5));                               	// Killed Mow
	strcat(list, GetAchievementsListStr("6) More like Dr_Dead", GetAchievementStatus(playerid, 6));                                 	// Kill Dr_Death
	strcat(list, GetAchievementsListStr("7) Lee PeeCock.. Hehe", GetAchievementStatus(playerid, 7));                              // Kill Shaney
	strcat(list, GetAchievementsListStr("8) All they ever did was help", GetAchievementStatus(playerid, 8));                         // Killed a trial admin
	strcat(list, GetAchievementsListStr("9) Expect a lengthy jail sentence", GetAchievementStatus(playerid, 9));                     // Killed an administrator
	strcat(list, GetAchievementsListStr("10) Stuck in that ban-appeal section?", GetAchievementStatus(playerid, 10));                 // Killed a lead administator
	strcat(list, GetAchievementsListStr("11) I'll have my peepz on you", GetAchievementStatus(playerid, 11));                         // Killed a clan leader
	strcat(list, GetAchievementsListStr("12) Manhunt.. Suitable name", GetAchievementStatus(playerid, 12));                           // Killed the manhunt target
	strcat(list, GetAchievementsListStr("13) Agent 47", GetAchievementStatus(playerid, 13));                							// Killed someone with a hit on them
	strcat(list, GetAchievementsListStr("14) Baby Killing Machine", GetAchievementStatus(playerid, 14));                           	// Get a kill spree of 5
	strcat(list, GetAchievementsListStr("15) Junior Killing Machine", GetAchievementStatus(playerid, 15));                        	// Get a kill spree of 10
	strcat(list, GetAchievementsListStr("16) Killing Machine", GetAchievementStatus(playerid, 16));                           		// Get a kill spree of 25
	strcat(list, GetAchievementsListStr("17) One Man Army!", GetAchievementStatus(playerid, 17));                                     // Get a kill spree of 50
	strcat(list, GetAchievementsListStr("18) Fist Pump", GetAchievementStatus(playerid, 18));                                         // Get a kill using your fists only
	strcat(list, GetAchievementsListStr("19) Backstab", GetAchievementStatus(playerid, 19));                   						// Get a kill using a melee weapon
	strcat(list, GetAchievementsListStr("20) Chainsaw Massacre", GetAchievementStatus(playerid, 20));                                 // Get a kill using a chainsaw
	strcat(list, GetAchievementsListStr("21) My gun might be small, but you're still dead", GetAchievementStatus(playerid, 21));      // Get a kill using a pistol
	strcat(list, GetAchievementsListStr("22) Ratatat", GetAchievementStatus(playerid, 22));                                           // Get a kill using an SMG
	strcat(list, GetAchievementsListStr("23) Bring out Bertha", GetAchievementStatus(playerid, 23));                        			// Get a kill using a shotgun
	strcat(list, GetAchievementsListStr("24) Serious firepower", GetAchievementStatus(playerid, 24));                                 // Get a kill using an assault rifle
	strcat(list, GetAchievementsListStr("25) Marksman", GetAchievementStatus(playerid, 25));                                          // Get a kill using a rifle
	strcat(list, GetAchievementsListStr("26) C4 yourself", GetAchievementStatus(playerid, 26));                                   // Get a kill using an explosive device
	strcat(list, GetAchievementsListStr("27) Flower power", GetAchievementStatus(playerid, 27));                                      // Get a kill using flowers
	strcat(list, GetAchievementsListStr("28) Rapist", GetAchievementStatus(playerid, 28));                                			// Get a kill using a dildo
	strcat(list, GetAchievementsListStr("29) Compensating for something?", GetAchievementStatus(playerid, 29));                       // Get a kill using a minigun
	strcat(list, GetAchievementsListStr("30) Pyromaniac", GetAchievementStatus(playerid, 30));                                        // Get a kill using a flamethrower
	strcat(list, GetAchievementsListStr("31) al-Qaida", GetAchievementStatus(playerid, 31));                                          // Get a kill using an RPG
	strcat(list, GetAchievementsListStr("32) Vehicular manslaughter", GetAchievementStatus(playerid, 32));                            // Get a kill using a vehicle
	strcat(list, GetAchievementsListStr("33) Pearl Harbour", GetAchievementStatus(playerid, 33));                                     // Get a kill using a rustler
 	strcat(list, GetAchievementsListStr("34) One is not enough", GetAchievementStatus(playerid, 34));                                 // Rank 1
 	strcat(list, GetAchievementsListStr("35) Getting somewhere", GetAchievementStatus(playerid, 35));                                 // Rank 2
 	strcat(list, GetAchievementsListStr("36) Newborn killer", GetAchievementStatus(playerid, 36));                                    // Rank 3
 	strcat(list, GetAchievementsListStr("37) Soldier", GetAchievementStatus(playerid, 37));                                    		// Rank 4
 	strcat(list, GetAchievementsListStr("38) Exterminator", GetAchievementStatus(playerid, 38));                                    	// Rank 5
 	strcat(list, GetAchievementsListStr("39) Executioner", GetAchievementStatus(playerid, 39));                                    	// Rank 6
 	strcat(list, GetAchievementsListStr("40) Mass Murderer", GetAchievementStatus(playerid, 40));                                    	// Rank 7
 	strcat(list, GetAchievementsListStr("41) Professional Hitman", GetAchievementStatus(playerid, 41));                               // Rank 8
 	strcat(list, GetAchievementsListStr("42) Gotta kill them all", GetAchievementStatus(playerid, 42));                               // Rank 9
 	strcat(list, GetAchievementsListStr("43) One to rule them all", GetAchievementStatus(playerid, 43));                              // Rank 10
 	strcat(list, GetAchievementsListStr("44) First deal", GetAchievementStatus(playerid, 44));                                        // Bought a weapon in the ammunation
 	strcat(list, GetAchievementsListStr("45) Karma's a bitch", GetAchievementStatus(playerid, 45));                                   // End a 5+ kill spree
 	strcat(list, GetAchievementsListStr("46) You're not going anywhere", GetAchievementStatus(playerid, 46));                         // End a 10+ kill spree
 	strcat(list, GetAchievementsListStr("47) A real pain in the ass", GetAchievementStatus(playerid, 47));                            // End  25+ kill spree
 	strcat(list, GetAchievementsListStr("48) Killed Osama", GetAchievementStatus(playerid, 48));                                      // End a 50+ kill spree
 	strcat(list, GetAchievementsListStr("49) Eye for an eye", GetAchievementStatus(playerid, 49));                                    // Reach a K/D of 1.0+
 	strcat(list, GetAchievementsListStr("50) I'm more than what meets the eye", GetAchievementStatus(playerid, 50));                  // Reach a K/D of 1.5+
 	strcat(list, GetAchievementsListStr("51) Living legend", GetAchievementStatus(playerid, 51));                                     // Reached a K/D of 2.0+
 	strcat(list, GetAchievementsListStr("52) Lagger", GetAchievementStatus(playerid, 52));                                            // Reached a K/D of 3.0+
 	strcat(list, GetAchievementsListStr("53) Hacker", GetAchievementStatus(playerid, 53));                                            // Reach a K/D of 5.0+
 	strcat(list, GetAchievementsListStr("54) 1337", GetAchievementStatus(playerid, 54));                                              // Reached 1337 kills
 	strcat(list, GetAchievementsListStr("55) $k", GetAchievementStatus(playerid, 55));                                                // Reach 5k kills
 	strcat(list, GetAchievementsListStr("56) 1Ok", GetAchievementStatus(playerid, 56));                                               // Reach 10k kills
 	strcat(list, GetAchievementsListStr("57) $*4k", GetAchievementStatus(playerid, 57));                                              // Reach 20k kills
 	strcat(list, GetAchievementsListStr("58) $0k", GetAchievementStatus(playerid, 58));                                               // Reach 50k kills
 	strcat(list, GetAchievementsListStr("59) I've got more kills than you", GetAchievementStatus(playerid, 59));                      // Reach 100k kills
 	strcat(list, GetAchievementsListStr("60) Wealthy", GetAchievementStatus(playerid, 60));                                           // Place a hit of 10k+
 	strcat(list, GetAchievementsListStr("61) Rich", GetAchievementStatus(playerid, 61));                                              // Place a hit of 50k+
 	strcat(list, GetAchievementsListStr("62) Wanted", GetAchievementStatus(playerid, 62));                                            // Have a hit placed on you for 10k+
 	strcat(list, GetAchievementsListStr("63) Most wanted", GetAchievementStatus(playerid, 63));                                       // Have a hit placed on you for 50k+
 	strcat(list, GetAchievementsListStr("64) Very Important Person", GetAchievementStatus(playerid, 64));                             // Get VIP status IG
 	strcat(list, GetAchievementsListStr("65) Turfwar", GetAchievementStatus(playerid, 65));                                           // Capture a turf
 	strcat(list, GetAchievementsListStr("66) Special man, special weapon", GetAchievementStatus(playerid, 66));                       // Find a special weapons pickup
 	strcat(list, GetAchievementsListStr("67) One hour down, many to go", GetAchievementStatus(playerid, 67));                         // Spend an hour IG
 	strcat(list, GetAchievementsListStr("68) Still new", GetAchievementStatus(playerid, 68));                                         // Spend 10 hours IG
 	strcat(list, GetAchievementsListStr("69) Now we're talking", GetAchievementStatus(playerid, 69));                                 // Spend a day IG
 	strcat(list, GetAchievementsListStr("70) Life is a game", GetAchievementStatus(playerid, 70));                                    // Spend 5 days+ IG
 	strcat(list, GetAchievementsListStr("71) But mom, I don't want to go outside", GetAchievementStatus(playerid, 71));                 // 10+ days IG
 	strcat(list, GetAchievementsListStr("72) Real life, where can you buy that?", GetAchievementStatus(playerid, 72));                // 25 days+ IG
 	strcat(list, GetAchievementsListStr("73) I got married to my PC. That's not weird, right?", GetAchievementStatus(playerid, 73));  // 50 days+ IG
 	strcat(list, GetAchievementsListStr("74) Virtual Life > Real Life", GetAchievementStatus(playerid, 74));                          // 100 days+ IG
 	strcat(list, GetAchievementsListStr("75) Never alone", GetAchievementStatus(playerid, 75));                                     	// Joined a clan
 	strcat(list, GetAchievementsListStr("76) Pimp my ride", GetAchievementStatus(playerid, 76));                                      // Modified a vehicle
 	strcat(list, GetAchievementsListStr("77) Join in on the fun", GetAchievementStatus(playerid, 77));                                // Joined a event
 	strcat(list, GetAchievementsListStr("78) Prison break", GetAchievementStatus(playerid, 78));                                      // Evade the police in the pursuit event
 	strcat(list, GetAchievementsListStr("79) Call in the coroner", GetAchievementStatus(playerid, 79));                      			// Kill the criminal in the pursuit event
 	strcat(list, GetAchievementsListStr("80) Bullets flying all over, but not on me", GetAchievementStatus(playerid, 80));            // Win the minigun event
 	strcat(list, GetAchievementsListStr("81) Heavyweight Champion", GetAchievementStatus(playerid, 81));                     			// Win the sumo event
  	strcat(list, GetAchievementsListStr("82) Thunderbirds are go", GetAchievementStatus(playerid, 82));                               // Win the hydra event
 	strcat(list, GetAchievementsListStr("83) The one and only", GetAchievementStatus(playerid, 83));                                  // Come 1st in either maddogs or bigsmoke
 	strcat(list, GetAchievementsListStr("84) Second is simply not good enough", GetAchievementStatus(playerid, 84));                  // Come 2nd in either maddogs or bigsmoke
 	strcat(list, GetAchievementsListStr("85) All good things go by three", GetAchievementStatus(playerid, 85));                       // Come 3rd in either maddogs or bigsmoke
 	strcat(list, GetAchievementsListStr("86) leet", GetAchievementStatus(playerid, 86));                                              // Buy 1337 ammo in ammunation
 	strcat(list, GetAchievementsListStr("87) Vrom vrom", GetAchievementStatus(playerid, 87));                                         // Buy a vehicle
 	strcat(list, GetAchievementsListStr("88) Vrom vrom bling bling", GetAchievementStatus(playerid, 88));                             // Buy a vehicle to 100k+
 	strcat(list, GetAchievementsListStr("89) My precious!", GetAchievementStatus(playerid, 89));                            			// Capture a care package
 	strcat(list, GetAchievementsListStr("90) No care for you", GetAchievementStatus(playerid, 90));                                   // Kill a player that is capturing a care package
 	strcat(list, GetAchievementsListStr("91) First came, first served", GetAchievementStatus(playerid, 91));                          // Win a duel
 	strcat(list, GetAchievementsListStr("92) I was lagging", GetAchievementStatus(playerid, 92));                                     // Lose a duel
 	strcat(list, GetAchievementsListStr("93) I'm on fire", GetAchievementStatus(playerid, 93));                                       // Win 10 duels
 	strcat(list, GetAchievementsListStr("94) Do you feel lucky, punk?", GetAchievementStatus(playerid, 94));                          // Win 100 duels
 	strcat(list, GetAchievementsListStr("95) I do this for a living", GetAchievementStatus(playerid, 95));                            // Win 500 duels
 	strcat(list, GetAchievementsListStr("96) Helpme's is what I do", GetAchievementStatus(playerid, 96));                            	// Become a trial admin
 	strcat(list, GetAchievementsListStr("97) I got the power, pow!", GetAchievementStatus(playerid, 97));                            	// Become an admin
 	strcat(list, GetAchievementsListStr("98) Ban Incorporated", GetAchievementStatus(playerid, 98));                                 	// Become a lead admin
 	strcat(list, GetAchievementsListStr("99) Fruit Smoothie", GetAchievementStatus(playerid, 99));                                           	// Join capital fruits
 	strcat(list, GetAchievementsListStr("100) Giving a helping hand", GetAchievementStatus(playerid, 100));                            // Used the /report command
 	strcat(list, GetAchievementsListStr("101) Nothing wrong in asking", GetAchievementStatus(playerid, 101));                          // Used the /helpme command

	strdel(list, strlen(list)-1, strlen(list));
	return list;
}

CMD:achievements(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	return 1;
}

CMD:setachievement(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_SETACH))
	{
	    new targetid, ach_id, value;
	    if(sscanf(params, "uuu", targetid, ach_id, value))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "[INFO]: /setachievement [ID] [Ach_ID] [Value]");
	    }
	    if(ach_id < 0 || ach_id > 106)
	    {
	        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Achievement ID has to be between 0 and 106. See /achievements.");
	    }
	    if(targetid == INVALID_PLAYER_ID)
	    {
	        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid playerid/name.");
	    }
	    if(value < 0 || value > 1)
	    {
	        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Value has to be either 0 or 1.");
	    }
		UpdateAchivementStatus(playerid, ach_id, value);
		new string[256];
		if(value == 0)
		{
		    format(string, sizeof(string), "[INFO]: %s's(%d) achievement status for achievement number %d has been set to {FF0000}incomplete{FF0000}.", PlayerName(targetid), targetid, ach_id);
		    SendClientMessage(playerid, COLOR_SYNTAX, string);
		    format(string, sizeof(string), "AdmCmd(%d): %s(%d) has set %s's(%d) achievement status for achievement number %d to {FF0000}incomplete{FF0000}.", ACMD_SETACH, PlayerName(playerid), playerid, PlayerName(targetid), targetid, ach_id);
		    SendAdminMessage(ACMD_SETACH, string);
		    return 1;
		}
		else
		{
			format(string, sizeof(string), "[INFO]: %s's(%d) achievement status for achievement number %d has been set to {15ED9A}completed{15ED9A}.", PlayerName(targetid), targetid, ach_id);
			SendClientMessage(playerid, COLOR_SYNTAX, string);
			format(string, sizeof(string), "AdmCmd(%d): %s(%d) has set %s's(%d) achievement status for achievement number %d to {15ED9A}completed{15ED9A}.", ACMD_SETACH, PlayerName(playerid), playerid, PlayerName(targetid), targetid, ach_id);
		    SendAdminMessage(ACMD_SETACH, string);
		    return 1;
		}
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
	    case DIALOG_ACHIEVEMENTS:
	    {
			if(response)
			{
			    new string[128];
			    switch(listitem)
			    {
           			case 0:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH1, DIALOG_STYLE_MSGBOX, "1) Registered In-Game", "Successfully registered in-game!", "Back", "Close");
			        }
			        case 1:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH2, DIALOG_STYLE_MSGBOX, "2) Getting started", "Got your first kill", "Back", "Close");
			        }
			        case 2:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH3, DIALOG_STYLE_MSGBOX, "3) Going the wrong way", "First suicide.", "Back", "Close");
			        }
			        case 3:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH4, DIALOG_STYLE_MSGBOX, "4) Fruitinator", "Killed pEar", "Back", "Close");
			        }
			        case 4:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH5, DIALOG_STYLE_MSGBOX, "5) Sys-Admin Assassin", "Killed Mow", "Back", "Close");
			        }
			        case 5:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH6, DIALOG_STYLE_MSGBOX, "6) More like Dr_Dead", "Killed Dr_Death", "Back", "Close");
			        }
			        case 6:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH7, DIALOG_STYLE_MSGBOX, "7) Lee PeeCock.. Hehe", "Killed Shaney", "Back", "Close");
			        }
			        case 7:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH8, DIALOG_STYLE_MSGBOX, "8) All they ever did was help", "Killed a trial administrator", "Back", "Close");
			        }
			        case 8:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH9, DIALOG_STYLE_MSGBOX, "9) Expect a lengthy jail sentence", "Killed an administrator",  "Back", "Close");
			        }
			        case 9:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH10, DIALOG_STYLE_MSGBOX, "10) Stuck in that ban-appeal section?", "Killed a lead administrator",  "Back", "Close");
			        }
			        case 10:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH11, DIALOG_STYLE_MSGBOX, "11) I'll have my peepz on you", "Killed a clan leader",  "Back", "Close");
			        }
			        case 11:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH12, DIALOG_STYLE_MSGBOX, "12) Manhunt.. Suitable name", "Killed the manhunt target",  "Back", "Close");
			        }
			        case 12:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH13, DIALOG_STYLE_MSGBOX, "13) Agent 47", "Killed a player with a hit on them",  "Back", "Close");
			        }
			        case 13:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH14, DIALOG_STYLE_MSGBOX, "14) Baby Killing Machine", "Get a kill streak of 5+",  "Back", "Close");
			        }
			        case 14:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH15, DIALOG_STYLE_MSGBOX, "15) Junior Killing Machine", "Get a kill streak of 10+",  "Back", "Close");
			        }
			        case 15:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH16, DIALOG_STYLE_MSGBOX, "16) Killing Machine", "Get a kill streak of 25+",  "Back", "Close");
			        }
			        case 16:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH17, DIALOG_STYLE_MSGBOX, "17) One Man Army!", "Get a kill streak of 50+",  "Back", "Close");
			        }
			        case 17:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH18, DIALOG_STYLE_MSGBOX, "18) Fist Pump", "Get a kill using your fists",  "Back", "Close");
			        }
			        case 18:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH19, DIALOG_STYLE_MSGBOX, "19) Backstab", "Get a kill using a melee weapon",  "Back", "Close");
			        }
			        case 19:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH20, DIALOG_STYLE_MSGBOX, "20) Chainsaw Massacre", "Get a kill using a chainsaw",  "Back", "Close");
			        }
			        case 20:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH21, DIALOG_STYLE_MSGBOX, "21) My gun might be small, but you're still dead", "Get a kill using a pistol",  "Back", "Close");
			        }
			        case 21:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH22, DIALOG_STYLE_MSGBOX, "22) Ratatat", "Get a kill using an SMG",  "Back", "Close");
			        }
			        case 22:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH23, DIALOG_STYLE_MSGBOX, "23) Bring out Bertha", "Get a kill using a shotgun",  "Back", "Close");
			        }
			        case 23:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH24, DIALOG_STYLE_MSGBOX, "24) Serious Firepower", "Get a kill using an assault rifle",  "Back", "Close");
			        }
			        case 24:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH25, DIALOG_STYLE_MSGBOX, "25) Marksman", "Get a kill using a rifle",  "Back", "Close");
			        }
			        case 25:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH26, DIALOG_STYLE_MSGBOX, "26) C4 yourself", "Get a kill an explosive device",  "Back", "Close");
			        }
			        case 26:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH27, DIALOG_STYLE_MSGBOX, "27) Flower Power", "Get a kill using flowers",  "Back", "Close");
			        }
			        case 27:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH28, DIALOG_STYLE_MSGBOX, "28) Rapist", "Get a kill using a dildo",  "Back", "Close");
			        }
			        case 28:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH29, DIALOG_STYLE_MSGBOX, "29) Compensating for something?", "Get a kill using a minigun",  "Back", "Close");
			        }
			        case 29:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH30, DIALOG_STYLE_MSGBOX, "30) Pyromaniac", "Get a kill using a flamethrower or molotov",  "Back", "Close");
			        }
			        case 30:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH31, DIALOG_STYLE_MSGBOX, "31) al-Qaida", "Get a kill using an RPG/HeatSeeker",  "Back", "Close");
			        }
			        case 31:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH32, DIALOG_STYLE_MSGBOX, "32) Vehicular manslaughter", "Get a kill using a vehicle",  "Back", "Close");
			        }
			        case 32:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH33, DIALOG_STYLE_MSGBOX, "33) Pearl Harbour", "Get a kill using a rustler",  "Back", "Close");
			        }
			        case 33:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH34, DIALOG_STYLE_MSGBOX, "34) One is not enough", "Reach level 1",  "Back", "Close");
			        }
			        case 34:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH35, DIALOG_STYLE_MSGBOX, "35) Getting somewhere", "Reach level 2",  "Back", "Close");
			        }
			        case 35:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH36, DIALOG_STYLE_MSGBOX, "36) Newborn Killer", "Reach level 3",  "Back", "Close");
			        }
			        case 36:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH37, DIALOG_STYLE_MSGBOX, "37) Soldier", "Reach level 4",  "Back", "Close");
			        }
			        case 37:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH38, DIALOG_STYLE_MSGBOX, "38) Exterminator", "Reach level 5",  "Back", "Close");
			        }
			        case 38:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH39, DIALOG_STYLE_MSGBOX, "39) Executioner", "Reach level 6",  "Back", "Close");
			        }
			        case 39:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH40, DIALOG_STYLE_MSGBOX, "40) Mass Murderer", "Reach level 7",  "Back", "Close");
			        }
			        case 40:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH41, DIALOG_STYLE_MSGBOX, "41) Professional Hitman", "Reach level 8",  "Back", "Close");
			        }
			        case 41:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH42, DIALOG_STYLE_MSGBOX, "42) Gotta kill them all", "Reach level 9",  "Back", "Close");
			        }
			        case 42:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH43, DIALOG_STYLE_MSGBOX, "43) One to rule them all", "Reach level 10",  "Back", "Close");
			        }
			        case 43:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH44, DIALOG_STYLE_MSGBOX, "44) First Deal", "Buy a weapon in the ammunation",  "Back", "Close");
			        }
			        case 44:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH45, DIALOG_STYLE_MSGBOX, "45) Karma's a bitch", "End a 5+ kill streak",  "Back", "Close");
			        }
			        case 45:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH46, DIALOG_STYLE_MSGBOX, "46) You're not going anywhere", "End a 10+ kill streak",  "Back", "Close");
			        }
			        case 46:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH47, DIALOG_STYLE_MSGBOX, "47) A real pain in the ass", "End a 25+ kill streak",  "Back", "Close");
			        }
			        case 47:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH48, DIALOG_STYLE_MSGBOX, "48) Killed Osama", "End a 50+ kill streak",  "Back", "Close");
			        }
			        case 48:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH49, DIALOG_STYLE_MSGBOX, "49) Eye for an eye", "Reach a K/D ratio of 1.0+",  "Back", "Close");
			        }
			        case 49:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH50, DIALOG_STYLE_MSGBOX, "50) I'm more than what meets the eye", "Reach a K/D ratio of 1.5+",  "Back", "Close");
			        }
			        case 50:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH51, DIALOG_STYLE_MSGBOX, "51) Living Legend", "Reach a K/D ratio of 2.0+",  "Back", "Close");
			        }
			        case 51:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH52, DIALOG_STYLE_MSGBOX, "52) Lagger", "Reach a K/D ratio of 3.0+",  "Back", "Close");
			        }
			        case 52:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH53, DIALOG_STYLE_MSGBOX, "53) Hacker", "Reach a K/D ratio of 5.0+",  "Back", "Close");
			        }
			        case 53:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH54, DIALOG_STYLE_MSGBOX, "54) 1337", "Reach a total of 1337 kills",  "Back", "Close");
			        }
			        case 54:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH55, DIALOG_STYLE_MSGBOX, "55) $k", "Reach a total of 5,000 kills",  "Back", "Close");
			        }
					case 55:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH56, DIALOG_STYLE_MSGBOX, "56) 1Ok", "Reach a total of 10,000 kills",  "Back", "Close");
			        }
			        case 56:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH57, DIALOG_STYLE_MSGBOX, "57) $*4k", "Reach a total of 20,000 kills",  "Back", "Close");
			        }
			        case 57:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH58, DIALOG_STYLE_MSGBOX, "58) $0k", "Reach a total of 50,000 kills",  "Back", "Close");
			        }
			        case 58:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH59, DIALOG_STYLE_MSGBOX, "59) I've got more kills than you", "Reach a total of 100,000 kills",  "Back", "Close");
			        }
			        case 59:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH60, DIALOG_STYLE_MSGBOX, "60) Wealthy", "Place a hit of 10,000$+",  "Back", "Close");
			        }
			        case 60:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH61, DIALOG_STYLE_MSGBOX, "61) Rich", "Place a hit of 50,000$+",  "Back", "Close");
			        }
			        case 61:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH62, DIALOG_STYLE_MSGBOX, "62) Wanted", "Have a hit placed on you for 10,000$+",  "Back", "Close");
			        }
			        case 62:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH63, DIALOG_STYLE_MSGBOX, "63) Most Wanted", "Have a hit placed on you for 50,000$+",  "Back", "Close");
			        }
			        case 63:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH64, DIALOG_STYLE_MSGBOX, "64) Very Important Person", "Get VIP status in-game",  "Back", "Close");
			        }
			        case 64:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH65, DIALOG_STYLE_MSGBOX, "65) Turfwar", "Capture the turf during a turfwar",  "Back", "Close");
			        }
			        case 65:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH66, DIALOG_STYLE_MSGBOX, "66) Special man, special weapon", "Find a special weapons pickup",  "Back", "Close");
			        }
			        case 66:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH67, DIALOG_STYLE_MSGBOX, "67) One hour down, many to go", "Spend an hour in-game",  "Back", "Close");
			        }
			        case 67:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH68, DIALOG_STYLE_MSGBOX, "68) Still new", "Spend 10 hours in-game",  "Back", "Close");
			        }
			        case 68:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH69, DIALOG_STYLE_MSGBOX, "69) Now we're talking (yeeeeah..)", "Spend a day in-game",  "Back", "Close");
			        }
					case 69:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH70, DIALOG_STYLE_MSGBOX, "70) Life's a game", "Spend 5 days in-game",  "Back", "Close");
			        }
					case 70:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH71, DIALOG_STYLE_MSGBOX, "71) But mom, I don't want to go outside", "Spend 10 days in-game",  "Back", "Close");
			        }
			        case 71:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH72, DIALOG_STYLE_MSGBOX, "72) Real life, where can you buy that?", "Spend 25 days in-game",  "Back", "Close");
			        }
			        case 72:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH73, DIALOG_STYLE_MSGBOX, "73) I got married to my PC. That's not weird, right?", "Spend 50 days in-game",  "Back", "Close");
			        }
			        case 73:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH74, DIALOG_STYLE_MSGBOX, "74) Virtual Life > Real Life", "Spend 100 days in-game",  "Back", "Close");
			        }
			        case 74:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH75, DIALOG_STYLE_MSGBOX, "75) Never alone", "Join a clan",  "Back", "Close");
			        }
			        case 75:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH76, DIALOG_STYLE_MSGBOX, "76) Pimp my ride", "Modify a vehicle",  "Back", "Close");
			        }
			        case 76:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH77, DIALOG_STYLE_MSGBOX, "77) Join in on the fun", "Join a event",  "Back", "Close");
			        }
			        case 77:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH78, DIALOG_STYLE_MSGBOX, "78) Prison Break", "Evade the police in the pursuit event",  "Back", "Close");
			        }
			        case 78:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH79, DIALOG_STYLE_MSGBOX, "79) Call in the coroner", "Kill the criminal in the pursuit event",  "Back", "Close");
			        }
			        case 79:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH80, DIALOG_STYLE_MSGBOX, "80) Bullets flying all over, but not on me", "Win the minigun event",  "Back", "Close");
			        }
			        case 80:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH81, DIALOG_STYLE_MSGBOX, "81) Heavyweight Champion", "Win a sumo event",  "Back", "Close");
			        }
			        case 81:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH82, DIALOG_STYLE_MSGBOX, "82) Thunderbirds are go", "Win the hydra event",  "Back", "Close");
			        }
			        case 82:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH83, DIALOG_STYLE_MSGBOX, "83) The one and only", "Come 1st in either the maddogs or the bigsmoke event",  "Back", "Close");
			        }
			        case 83:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH84, DIALOG_STYLE_MSGBOX, "84) Second is simply not good enough", "Come 2nd in either the maddogs or the bigsmoke event",  "Back", "Close");
			        }
			        case 84:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH85, DIALOG_STYLE_MSGBOX, "85) All good things go by three", "Come 3rd in the maddogs or the bigsmoke event",  "Back", "Close");
			        }
			        case 85:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH86, DIALOG_STYLE_MSGBOX, "86) leet", "Buy 1337 ammo in the ammunation",  "Back", "Close");
			        }
			        case 86:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH87, DIALOG_STYLE_MSGBOX, "87) Vrom Vrom", "Buy a vehicle",  "Back", "Close");
			        }
			        case 87:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH88, DIALOG_STYLE_MSGBOX, "88) Vrom Vrom Bling Bling", "Buy a vehicle that costs 100,000$+",  "Back", "Close");
			        }
			        case 88:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH89, DIALOG_STYLE_MSGBOX, "89) My precious", "Capture a care package",  "Back", "Close");
			        }
			        case 89:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH90, DIALOG_STYLE_MSGBOX, "90) No care for you", "Kill a player that is capturing a care package",  "Back", "Close");
			        }
			        case 90:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH91, DIALOG_STYLE_MSGBOX, "91) First came, first served", "Win a duel",  "Back", "Close");
			        }
			        case 91:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH92, DIALOG_STYLE_MSGBOX, "92) I was lagging", "Lose a duel",  "Back", "Close");
			        }
			        case 92:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH93, DIALOG_STYLE_MSGBOX, "93) I'm on fire", "Win 10 duels",  "Back", "Close");
			        }
			        case 93:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH94, DIALOG_STYLE_MSGBOX, "94) Do you feel lucky, punk?", "Win 100 duels",  "Back", "Close");
			        }
			        case 94:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH95, DIALOG_STYLE_MSGBOX, "95) I do this for a living", "Win 500 duels",  "Back", "Close");
			        }
			        case 95:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH96, DIALOG_STYLE_MSGBOX, "96) Helpme's is what I do", "Become a trial administrator",  "Back", "Close");
			        }
			        case 96:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH97, DIALOG_STYLE_MSGBOX, "97) I got the power, pow!", "Become an administrator",  "Back", "Close");
			        }
			        case 97:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH98, DIALOG_STYLE_MSGBOX, "98) Ban Incorporated", "Become a lead administrator",  "Back", "Close");
			        }
			        case 98:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH99, DIALOG_STYLE_MSGBOX, "99) Fruit Smoothie", "Join the Capital Fruits clan",  "Back", "Close");
			        }
			        case 99:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH100, DIALOG_STYLE_MSGBOX, "100) Giving a helping hand", "Using the /report command",  "Back", "Close");
			        }
			        case 100:
			        {
			            ShowPlayerDialog(playerid, DIALOG_ACH101, DIALOG_STYLE_MSGBOX, "101) Nothing wrong in asking", "Using the /helpme command",  "Back", "Close");
			        }
			    }
			}
			else
			{
				return 1;
			}
	    }
	    case DIALOG_ACH1:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH2:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH3:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH4:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH5:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH6:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH7:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH8:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH9:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH10:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH11:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH12:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH13:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH14:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH15:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH15:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH16:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH17:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH18:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH19:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH20:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH21:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH22:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH23:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH24:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH25:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH26:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH27:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH28:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH29:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH30:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH31:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH32:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH33:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH34:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH35:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH36:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH37:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH38:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH39:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH40:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH41:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH42:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH43:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH44:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH45:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH46:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH47:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH48:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH49:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH50:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH51:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH52:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH53:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH54:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH55:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH56:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH57:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH58:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH59:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH60:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH61:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH62:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH63:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH64:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH65:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH66:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH67:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH68:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH69:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH70:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH71:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH72:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH73:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH74:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH75:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH76:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH77:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH78:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH79:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH80:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH81:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH82:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH83:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH84:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH85:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH86:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH87:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH88:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH89:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH90:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH91:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH92:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH93:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH94:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH95:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH96:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH97:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH98:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH99:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH100:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	    case DIALOG_ACH101:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Achievements", GetAchievementsList(playerid), "Info", "Close");
	        }
	        else
	        {
	            return 1;
	        }
	    }
	}
	return 1;
}
