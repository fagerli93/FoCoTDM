#if !defined MAIN_INIT
#error "Compiling from wrong script. (foco.pwn)"
#endif

/*
* FoCo TDM Internal Color System:
* READ AND UNDERSTAND THE INTERNAL MESSAGING SYSTEM IT KEEPS THE UI CLEAN AND UNDERSTANDABLE
*/
#define COLOR_CMDNOTICE 0xB4B5B7FF
#define IRCCOL_CMDNOTICE "15"
/*Command notice is used to send notices to the player using the command, also notices require no [ :] at the begginning so instead add 16 spaces,
* for example you will want "SendClientMessage(playerid, COLOR_CMDNOTICE, "               You have just given yourself a jetpack");"*/

#define COLOR_GLOBALNOTICE 0xFF8000FF
#define COLOR_VIPNOTICE 0x895B2DFF
#define IRCCOL_GLOBALNOTICE "8"
/* This a brilliant orange color so that users see it clearly in chat, this should be used for important messages such as kicks, bans, jails or  announcements*/

#define COLOR_WARNING 0x800000FF
#define IRCCOL_WARNING "4"
/* This is a dark red color and should be used for attempted unathorized acces, like "SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not authorized to use this command.");"*/

#define COLOR_NOTICE 0xE0FFFFAA
#define IRCCOL_NOTICE "16"
/* This should be used to sent notifications to the player on the recieving end of a command or function, for example "SendClientMessage(playerid, COLOR_NOTICE, ""                Lead Administrator Shaney has muted you for being an asshole);"
* notice how this too used 16 spaces to push it out, this is so that the recipient notices it and as it looks cleans. Also this color can be used foir functions, as stated, 
* such as "SendClientMessage(playerid,COLOR_NOTICE,"               You must login before you can spawn!");"*/

#define COLOR_SYNTAX 0x969696FF
#define IRCCOL_SYNTAX "14"
/* This one is simple, it is used to show command syntax like "SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE:] /mute [ID/Name] [Optional: Reason]");", note the sections I have capitalised and those that I have not LEEEE*/

#define COLOR_ADMIN 0x00FF00FF
#define IRCCOL_ADMIN "9"
/* Color to be used when referring to an admin*/

#define COLOR_TESTER 0x0080FF
#define IRCCOL_TESTER "5"
/* Color to be used when referring to a tester */

#define COLOR_ANTICHEAT 0x650065FF
#define IRCCOL_ANTICHEAT "6"

#define PLAYERSTATUS_NORMAL 0
#define PLAYERSTATUS_INEVENT 1
#define PLAYERSTATUS_INDUEL 2
#define PLAYERSTATUS_AFK 3
#define MAX_LEVELS 10

#define ADM_AUTH_LOGIN 1
#define ADM_AUTH_CMD 2
#define ADM_AUTH_AUTHENTICATED 3

/*
* FoCo TDM General Color Systems;
*/
#define COLOR_LOCALMSG 0xEC5413AA
#define COLOR_ADMINCMD 0xF97804FF
#define COLOR_NOTLOGGED 0x00000000
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD3 0xCBCCCEFF
#define COLOR_GRAD4 0xD8D8D8FF
#define COLOR_GRAD5 0xE3E3E3FF
#define COLOR_GRAD6 0xF0F0F0FF
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xFF6347AA
#define COLOR_INVISRED 0xFF6347AA00
#define COLOR_DARKRED 0xCD000000
#define COLOR_LIGHTRED 0xFF6347AA
#define COLOR_LIGHTGREEN 0x9ACD32AA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_LIGHTBLUE2 0x0080FFAA
#define COLOR_LIGHTORANGE 0xFF8000FF
#define COLOR_DARKBROWN 0xB36C42FF
#define COLOR_MEDIUMBLUE 0x1ED5C7FF
#define COLOR_LIGHTYELLOW 0xE0E377AA
#define COLOR_LIGHTYELLOW2 0xE0EA64AA
#define COLOR_LIGHTYELLOW3 0xFF6347AA
#define COLOR_DARKPURPLE 0x5F56F8AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_YELLOW2 0xF5DEB3AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_FADE1 0xE6E6E6E6
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_FADE5 0x6E6E6E6E
#define COLOR_PURPLE 0xA900F6AA
#define COLOR_DBLUE 0x2641FEAA
#define COLOR_BLUE 0x008CF5AA
#define COLOR_NEWS 0xFFA500AA
#define COLOR_OOC 0xE0FFFFAA
#define COLOR_NEWOOC 0x0080FFAA
#define COLOR_ACTIONS 0x00FFFFCC
#define COLOR_ADWARNING 0xFFFF00AA
#define COLOR_LARED 0x990012
#define COLOR_BRONZE 0xCD7F32
#define COLOR_SILVER 0xCCCCCC
#define COLOR_GOLD 0xE5C100

/* Other Definitions*/
#define REARM_TIME 600
#define AMOUNT_ACHIEVEMENTS 101

#define MAX_SPAWN_ATTEMPTS 4
#define DIALOG_ANITROUSBOOST 5

#define PAGE_NULL -1
#define PAGE_1 1
#define MAX_LOGIN_ATTEMPS 3 // Kick after they tried logging in 3 times and failed

#define MAX_BLOCK 10 // Maximum amount of people you can block PMs from.
//#define MAX_TELEPORTS 20
#define DEATH_SPAWN_TIME 4

#define FLOAT_PICKUP_DISTANCE 50.0

/* EVENT COST */

#define FFA_COST 50
#define TDM_COST 150
#define MIN_LVL 3
#define MIN_CASH 5000
#define MIN_EVENT_BET 2000
#define MAX_EVENT_BET 25000
#define FOCO_EVENT_BET_COST 0.9         // 10% is taken by the server when a player wins on a bet for events.

/* These next two are random used for min and max range for commands that include range. */
#define MIN_RANGE 1
#define MAX_RANGE 500

#define KILL_CASH 350
#define MIN_DEATH_CASH 25
#define MAX_DEATH_CASH 250
#define B_VIP_KILL_BONUS 20
#define S_VIP_KILL_BONUS 40
#define G_VIP_KILL_BONUS 60
#define MANHUNT_BONUS 5000
#define KILL_HEADSHOT 400
#define KILL_SNIPER 300
#define KILL_CHAINSAW 300
#define KILL_GRENADE 350
#define KILL_SUICIDE 200
#define KILL_KNIFE 350
#define KILL_BOUNTY 2500
#define SPREE_KILL_10 1000
#define SPREE_KILL_20 2000
#define SPREE_KILL_30 3000
#define SPREE_KILL_40 4000
#define SPREE_KILL_50 5000
#define SPREE_KILL_60 6000
#define SPREE_KILL_70 7000
#define SPREE_KILL_80 8000
#define SPREE_KILL_90 9000
#define SPREE_KILL_100 10000

/*Query Definitions*/

#define MYSQL_REGISTER 1
#define MYSQL_LOGIN1 2
#define MYSQL_LOGIN2 3
#define MYSQL_PCONNECT 4
#define MYSQL_PLAYERSAVE 5
#define MYSQL_PLAYERSTATSAVE 6
#define MYSQL_LOAD_PLAYER_STATS_INFO 7
#define MYSQL_LOAD_ACHIEVEMENTS 8
#define MYSQL_SAVE_PICKUP 10
#define MYSQL_SAVE_TEAMS 11
//12 unused

#define THREAD_LOAD_CARS 20
#define THREAD_LOAD_PICKUPS 22
//#define THREAD_LOAD_TELEPORTS 23
#define MYSQL_HasAchievement 24
#define MYSQL_GiveAchievement 25
#define MYSQL_ACHIUPDATE 26
#define MYSQL_THREAD_SELLCAR 27
#define MYSQL_THREAD_MYCAR 28
#define MYSQL_THREAD_ADMINRECORD_INSERT 29
#define MYSQL_PLAYERSAVE_2 30
#define MYSQL_PLAYERSAVE_3 31
#define MYSQL_SAVE_TEAMS_2 32
#define MYSQL_SAVE_TEAMS_3 33
#define MYSQL_PLAYERSTATSAVE_2 34
#define MYSQL_THREAD_CHECKCLAN 35
#define MYSQL_THREAD_SELLCAR_2 36
#define MYSQL_THREAD_SEARCHMYCAR 37
#define MYSQL_THREAD_FIXMYCAR 38
#define MYSQL_DISCOUPDATE 39
#define MYSQL_CONNINSERT 40
#define MYSQL_ONLINE_UPDATE 41
#define MYSQL_SET_ONLINE_DEFAULT 42
#define MYSQL_UP_CAR_KEY 43
#define MYSQL_PICKUP_THREAD 44
#define MYSQL_DEL_TEAM 45
#define MYSQL_CREATE_TEAM_THREAD 46
#define MYSQL_THREAD_B_CAR 47
#define MYSQL_THREAD_INS_B_CAR 48
#define MYSQL_THREAD_U_CAR 49
#define MYSQL_THREAD_SET_ONLINE_DEFAULT 50
#define MYSQL_THREAD_U_P_CAR 51
#define MYSQL_U_CAR 52
#define MYSQL_INS_TEAM 53
#define MYSQL_INS_PSTATS 54
#define MYSQL_INSERT_ACHI 55
#define MYSQL_CREATE_PLAYER 56
#define MYSQL_UPDATE_SINGLE_VEHICLE 57
#define MYSQL_DEL_CAR 58
#define MYSQL_CLAN_CHECK 59
#define MYSQL_UNBAN_THREAD 60
#define MYSQL_UNBAN_THREAD_2 61
#define MYSQL_KEY_UPDATE 62
#define MYSQL_PLATE_ADMIN_UPDATE 63
#define MYSQL_THREAD_INSERT_NAMECHANGE 65
#define MYSQL_THREAD_UPDATE_NAME 66
#define MYSQL_THREAD_DEL_BUGGED_NAME 67
#define MYSQL_IRC_UNBAN_THREAD 68
#define MYSQL_FUNCTION_MOD 69
#define MYSQL_DEATH 70
#define MYSQL_LOAD_DUELS_INFO 71
#define MYSQL_LOAD_DUELS_INFO_2 72
#define MYSQL_LOAD_CLASSES 73
#define MYSQL_INSERT_CLASSES 74
#define MYSQL_LOAD_CLASS_STRING 75
#define MYSQL_GIVE_CLASS 76
#define MYSQL_UPDATE_CLASSES 77
#define MYSQL_INSERT_CW 78
#define THREAD_LOAD_TURFS 79
#define THREAD_RESET_TURF 80
#define THREAD_TURFSYS_UPDATE 81
#define THREAD_LOAD_TEAMS 82
#define MYSQL_THREAD_ADDRULES 83
#define MYSQL_THREAD_EDITRULE 84
#define MYSQL_ADMINACTION 85 //Ban,Tempban
#define MYSQL_THREAD_SHOWCARS 86
#define MYSQL_THREAD_DONATIONS 87
#define MYSQL_THREAD_COUNTCARS 88
#define MYSQL_RESETCLASS 89
#define MYSQL_TRANSFERNC 90
#define MYSQL_DUELUPDATE 91
#define MYSQL_UNBAN_THREAD_3 92
#define MYSQL_THREAD_BAN_HANDLER 93
#define MYSQL_THREAD_UNBANTEMP 94
#define MYSQL_THREAD_BANIP 95
#define MYSQL_UNBAN_THREAD_4 96
#define MYSQL_THREAD_UNBANIP 97
#define MYSQL_THREAD_TEMPBAN 98
#define MYSQL_THREAD_RESTRICED_SKINS 99
/*	In pEar_Stations
#define MYSQL_STATIONS_SET 100
#define MYSQL_STATIONS_CHECK 101
#define MYSQL_STATION_ADD 102
#define MYSQL_RADIO_SELECT 103
#define MYSQL_ARADIO_EDIT 104
#define MYSQL_ARADIO_REMOVE 105
#define MYSQL_ARADIO_ADD_SELECT 106
#define MYSQL_ARADIO_ADD_NEW 107
*/
#define MYSQL_ADMINSEC 108
#define	MYSQLTHREAD_JAILREC	109
#define	MYSQLTHREAD_KICKREC	110
#define	MYSQLTHREAD_BANREC	111
#define	MYSQLTHREAD_WARNREC	112
#define MYSQLTHREAD_GRABALIAS 113
#define MYSQLTHREAD_JAILEVADE 114
#define MYSQL_ONLINE_CHECK 115
#define MYSQLTHREAD_USERINFO 116
#define MYSQL_UCP_DELETE_JOB 117
#define MYSQL_UCP_UPDATES 118
#define MYSQL_UCP_DATAUPDATE 119
#define MYSQL_CHECK_UCP_UPDATE 120
#define MYSQL_UCP_PUNISHMENT 121
#define MYSQL_LOGIN3 122
#define MYSQL_LOGIN4 123
#define MYSQL_CHANGEPASSWORD 124
#define MYSQL_CHANGEPASSWORD_CONFIRM 125
#define MYSQL_CHANGEPASSWORD_FINISH 126
#define MYSQL_UPDATE_MAIL 127
//=======================================[KEY DETECTION]========================================
#define KEY_AIM 128
#define KEY_AIMFIRE 132

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define HOLDING(%0) \ 
    ((newkeys & (%0)) == (%0))

//=======================================[TEAMS]=============================================
#define MAX_TEAMS		100
#define TEAM_LSPD 		1
#define TEAM_424 		2
#define TEAM_LOCOTES 	3
#define TEAM_SEVILLE	4
#define TEAM_BPL		5
#define TEAM_VALENTI	6

//======================================[RANK DEFINES]=======================================
#define RANK_ONE 10
#define RANK_TWO 30
#define RANK_THREE 80
#define RANK_FOUR 150
#define RANK_FIVE 230
#define RANK_SIX 320
#define RANK_SEVEN 450
#define RANK_EIGHT 700
#define RANK_NINE 1000
#define RANK_TEN 1337

// Random fix
#define Spec_TimerFix Timer:-1

#define RANKLIST "Rank One - 10 Kills\nRank Two - 30 Kills\nRank Three - 80 Kills\nRank Four - 150 Kills\nRank Five - 230 Kills\nRank Six - 320 Kills\nRank Seven - 450 Kills\nRank Eight - 700 Kills\nRank Nine - 1000 Kills\nRank Ten - 1337 Kills"

//=======================================[DIALOGS]===========================================

#define DIALOG_REG 1
#define DIALOG_LOG 2

#define DIALOG_ASETSTAT1 3
#define DIALOG_ASETSTAT2 4

#define DIALOG_CARMOD1 55
#define DIALOG_CARMOD2 56
#define DIALOG_CARMOD3 57
#define DIALOG_CARMOD4 58
#define DIALOG_BUYCARMOD   59
#define DIALOGID_CARMODBUY 60

#define DIALOG_BUY	   70
#define DIALOG_WEAPONS 71

#define DIALOG_PICKUP1 72
#define DIALOG_PICKUP2 73
#define DIALOG_PICKUP3 74
#define DIALOG_PICKUP4 75
#define DIALOG_PICKUP5 76
#define DIALOG_PICKUP6 121

#define DIALOG_PICKUPDEL 77
#define DIALOG_PICKUPMOVE 78

#define DIALOG_TEAMDEL 79
#define DIALOG_TEAMINFO 80
#define DIALOG_TEAMINFO2 81
#define DIALOG_TEAMINFO3 82

#define DIALOG_CREATETEAM 83
#define DIALOG_CREATETEAM2 84
#define DIALOG_CREATETEAM3 85
#define DIALOG_CREATETEAM4 86
#define DIALOG_CREATETEAM5 87
#define DIALOG_CREATETEAM6 88
#define DIALOG_CREATETEAM7 89
#define DIALOG_CREATETEAM8 90
#define DIALOG_CREATETEAM9 91
#define DIALOG_CREATETEAM10 92
#define DIALOG_CREATETEAM11 93
#define DIALOG_CREATETEAM12 94
#define DIALOG_CREATETEAM13 95
#define DIALOG_CREATETEAM14 96
#define DIALOG_CREATETEAM15 97
#define DIALOG_CREATETEAM16 98
#define DIALOG_CREATETEAM17 99

#define DIALOG_EDITTEAM1 100
#define DIALOG_EDITTEAM2 101
#define DIALOG_EDITTEAM3 103

#define DIALOG_RESTART 104
//#define DIALOG_SETSTATION 105 -> Defined in pEar_Stations.pwn
#define DIALOG_RULES 106
#define DIALOG_LEVEL 107

#define DIALOG_VOTE 108
#define DIALOG_VOTE2 109
#define DIALOG_VOTE3 110
#define DIALOG_VOTE4 111

#define DIALOG_LEVEL_GUNS 112
#define DIALOG_PLAYERTOG 113
//#define DIALOG_SETSTATION2 114 -> Defined in pEar_Stations.pwn
#define DIALOG_WEAPONAMMO 115
#define DIALOG_WEAPONCONF 116
#define DIALOG_DONATORSTATUS 117

#define DIALOG_EVENTSTART 118
#define DIALOG_EVENTSTART2 119

#define DIALOG_REPORT_VIEW 120
#define DIALOG_REPORT_DETAILS 122

#define DIALOG_EVENTSTART22 123

#define DIALOG_BUYCAR_1 124
#define DIALOG_BUYCAR_2 125
#define DIALOG_BUYCAR_3 126
#define DIALOG_BUYCAR_4 127
#define DIALOG_BUYCAR_5 128
#define DIALOG_BUYCAR_6 129
#define DIALOG_BUYCAR_7 130

#define DIALOG_DUEL 131

#define DIALOG_TRANSSYS_1 200
#define DIALOG_TRANSSYS_2 201
#define DIALOG_TRANSSYS_3 202
#define DIALOG_TRANSSYS_4 203
#define DIALOG_TRANSSYS_5 204
#define DIALOG_TRANSSYS_6 205
#define DIALOG_NEON 207
#define DIALOG_CLASS_TOOLS 208
#define DIALOG_CLASSES 209
#define DIALOG_CLASS_EDIT 210
#define DIALOG_CLASS_GUN 211
#define DIALOG_EDIT_CLASS 213

#define DIALOG_DUEL_WEAPON 214
#define DIALOG_SHOW_CLANS_WAR 215
#define DIALOG_SHOW_CLANS_WAR_LOCATION 216
#define DIALOG_SHOW_CLANS_WAR_WEAPONS 217
#define DIALOG_MOTD 218
#define DIALOG_AFKLIST 219
#define DIALOGID_PMADM 220
#define DIALOGID_PM 221


#define DIALOG_EVENTS 222
#define DIALOGID_MDWEAPON 223
#define DIALOG_REJOINABLE 224
#define DIALOG_FFAARMOUR 225

#define DIALOG_TOGGLEAC 226
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
#define DIALOG_ACH74 300
#define DIALOG_ACH75 301
#define DIALOG_ACH76 302
#define DIALOG_ACH77 303
#define DIALOG_ACH78 304
#define DIALOG_ACH79 3050
#define DIALOG_ACH80 306
#define DIALOG_ACH81 307
#define DIALOG_ACH82 308
#define DIALOG_ACH83 309
#define DIALOG_ACH84 310
#define DIALOG_ACH85 311
#define DIALOG_ACH86 312
#define DIALOG_ACH87 313
#define DIALOG_ACH88 314
#define DIALOG_ACH89 315
#define DIALOG_ACH90 316
#define DIALOG_ACH91 317
#define DIALOG_ACH92 318
#define DIALOG_ACH93 319
#define DIALOG_ACH94 320
#define DIALOG_ACH95 321
#define DIALOG_ACH96 322
#define DIALOG_ACH97 323
#define DIALOG_ACH98 324
#define DIALOG_ACH99 325
#define DIALOG_ACH100 326
#define DIALOG_ACH101 327
#define DIALOG_ACHIEVEMENTS 328
#define DIALOG_ACHIEVEMENTS1 329
#define DIALOG_ACHIEVEMENTS2 330
#define DIALOG_ACHIEVEMENTS3 331
#define DIALOG_ACHIEVEMENTS4 332
#define DIALOG_ACHIEVEMENTS5 333
// 334 taken
#define DIALOG_RPGCONF 334 // New to the ammunation sys.
#define DIALOG_TEMPBANIP 335
#define DIALOG_TEMPBANIP_TIME 336
#define DIALOG_TEMPBANIP_CONFIRM 337
#define DIALOG_TEMPBAN 338
#define DIALOG_TEMPBAN_TIME 339
#define DIALOG_TEMPBAN_CONFIRM 340
#define DIALOG_REPORT_HANDLE 341
#define DIALOG_REPORT_VIEW_PLAYER 342
#define DIALOG_CLANWAR_EDIT 343
#define DIALOG_WEATHER 344
/* -> pEar_ACP.pwn
#define DIALOG_ACP 345
#define DIALOG_ACP_ATEAM 346
#define DIALOG_ACP_RFC 347
#define DIALOG_ACP_DELETECAR 348
#define DIALOG_ACP_CREATECAR 349
#define DIALOG_ACP_SETHPALL 350
#define DIALOG_ACP_SETARMOURALL 351
#define DIALOG_ACP_GIVEALLWEAPON 352
#define DIALOG_ACP_BOTS 353
#define DIALOG_ACP_RESETSTATS 354
#define DIALOG_ACP_BANIPRANGE 355
#define DIALOG_ACP_SETSTAT 356
#define DIALOG_ACP_CHANGENAME 357
#define DIALOG_ACP_SETCAR 358
#define DIALOG_ACP_SETACH 359
#define DIALOG_ACP_AGIVE 360
#define DIALOG_ACP_SETADMIN 361
#define DIALOG_ACP_SETTRIALADMIN 362
#define DIALOG_ACP_ATURF 363
#define DIALOG_ACP_MOTD 364
#define DIALOG_ACP_RULES 365
#define DIALOG_ACP_MAXPLAYERSPERIP 366
#define DIALOG_ACP_GIVEALLWEAPONAMMO 367
#define DIALOG_ACP_SETCAR_PLATE 368
#define DIALOG_ACP_SETCAR_C1 369
#define DIALOG_ACP_SETCAR_C2 370
#define DIALOG_ACP_AGIVE_NAME 371
#define DIALOG_ACP_AGIVE_MONEY 372
#define DIALOG_ACP_AGIVE_KILLSTREAK 373
#define DIALOG_ACP_SETADMIN_NAME 374
#define DIALOG_ACP_SETTRIALADMIN_NAME 375
#define DIALOG_ACP_RULES_ADD 376
#define DIALOG_ACP_RULES_REMOVE 377
#define DIALOG_ACP_RULES_EDIT 378
#define DIALOG_ACP_RULES_EDIT2 379
*/
#define DIALOG_ADMINSEC_QUESTION 380
#define DIALOG_ADMINSEC_ANSWER 381
/* -> pEar.Stations.pwn
#define DIALOG_SETSTATION 105
#define DIALOG_SETSTATION2 114
#define DIALOG_ARADIO 382
#define DIALOG_ARADIO_ADD 383
#define DIALOG_ARADIO_ADD_URL 384
#define DIALOG_ARADIO_REMOVE 385
#define DIALOG_ARADIO_EDIT 386
#define DIALOG_ARADIO_EDIT_NAME 387
#define DIALOG_ARADIO_EDIT_URL 388
#define DIALOG_ARADIO_CONFIRM 389
*/
#define DIALOG_NO_RESPONSE 390
#define DIALOG_TOGGLEAC1 391
#define DIALOG_CEM 392
#define DIALOG_GROUP_LIST 393
#define DIALOG_AREC_OPTIONS 394
#define DIALOG_BUYSKIN		395
#define DIALOG_DROPSKIN     396
#define 	DIALOG_SKIN_MODS 			397
#define 	DIALOG_SKIN_MODS_HATS 		398
#define 	DIALOG_SKIN_MODS_GLASSES 	399
#define 	DIALOG_SKIN_MODS_HELMETS 	400
#define 	DIALOG_SKIN_MODS_BANDANAS   401
#define DIALOG_CHANGEPASSWORD 402
#define DIALOG_CHANGEPASSWORD_NEW 403
#define DIALOG_CHANGEPASSWORD_CONFIRM 404
#define DIALOG_CHANGEEMAIL 405
#define DIALOG_VOTEBAN  406

#define DIALOG_TP_MAIN 407
#define DIALOG_TP_INT 408
#define DIALOG_TP_EX 409





/*
DIALOG ID's 500-599 used by 3rd-Party Dev's -- See Forum Post in Dev Forum
*/


#define TREECMD_MSGBOX 2001
#define TREECMD_INPUT 2002
#define TREECMD_LIST 2003


//====================================[ACQUISITION]==========================================
#define ACQUISITION_AUTO 0 //Automatically earnt
#define ACQUISITION_SCORE 2 //Earnt through score
#define ACQUISITION_VIP 3 //Earnt through getting VIP
#define ACQUISITION_KILLSTREAK 3 // Earnt through a killstreak amount
#define ACQUISITION_ACHI 4 //Earnt through an achievement

//====================================[AMMO ON SPAWN AND VIP AMMO]==========================================
#define MELEE_AMMO_ONSPAWN 1.0
#define HANDGUN_AMMO_ONSPAWN 500.0
#define SHOTGUN_AMMO_ONSPAWN 200.0
#define SUBMACHINEGUN_AMMO_ONSPAWN 300.0
#define ASSAULTRIFLE_AMMO_ONSPAWN 500.0
#define RIFLE_AMMO_ONSPAWN 25.0
#define EXTRA_GOLD_AMMO 2.0
#define EXTRA_SILVER_AMMO 1.5
#define EXTRA_BRONZE_AMMO 1.25



#if defined PTS
	#define BOT_1_NICKNAME "TSTDM_BOT_ECHO1"
	#define BOT_1_REALNAME "Aero's Prowler"
	#define BOT_1_USERNAME "biebersux"

	#define BOT_2_NICKNAME "TSTDM_BOT_ECHO2"
	#define BOT_2_REALNAME "Shaney's Cool"
	#define BOT_2_USERNAME "biebersux"

	#define BOT_3_NICKNAME "TSTDM_BOT_ECHO3"
	#define BOT_3_REALNAME "Wazza Chea"
	#define BOT_3_USERNAME "biebersux"

	#define BOT_4_NICKNAME "TSTDM_BOT_ECHO4"
	#define BOT_4_REALNAME "Jack Vega"
	#define BOT_4_USERNAME "biebersux"

	#define BOT_5_NICKNAME "TSTDM_BOT_ECHO5"
	#define BOT_5_REALNAME "FKu"
	#define BOT_5_USERNAME "biebersux"

	#define BOT_6_NICKNAME "TSTDM_BOT_ECHO6"
	#define BOT_6_REALNAME "Chilco"
	#define BOT_6_USERNAME "biebersux"

	#define BOT_7_NICKNAME "TSTDM_BOT_ECHO7"
	#define BOT_7_REALNAME "dr_vista"
	#define BOT_7_USERNAME "biebersux"

	#define BOT_8_NICKNAME "TSTDM_BOT_ECHO8"
	#define BOT_8_REALNAME "pEar"
	#define BOT_8_USERNAME "biebersux"

	#define BOT_9_NICKNAME "TSTDM_BOT_ECHO9"
	#define BOT_9_REALNAME "Lee Peecock"
	#define BOT_9_USERNAME "biebersux"

	#define BOT_10_NICKNAME "TSTDM_BOT_ECHO10"
	#define BOT_10_REALNAME "Marcel Smith"
	#define BOT_10_USERNAME "biebersux"

	#define BOT_11_NICKNAME "TSTDM_BOT_ECHO11"
	#define BOT_11_REALNAME "Simon Pear"
	#define BOT_11_USERNAME "biebersux"
	
	#define BOT_12_NICKNAME "TSTDM_BOT_ECHO12"
	#define BOT_12_REALNAME "Mista Vista"
	#define BOT_12_USERNAME "biebersux"

	#define BOT_13_NICKNAME "TSTDM_BOT_ECHO13"
	#define BOT_13_REALNAME "Doctor Death"
	#define BOT_13_USERNAME "biebersux"

	#define IRC_SERVER "irc.tl"
	#define IRC_PORT (6667)
	#define IRC_FOCO_ECHO "#focotdm.test.echo"
	#define IRC_FOCO_LEADS "#focotdm.test.lecho"
	#define IRC_FOCO_MAIN "#focotdm.test.foco"
	#define IRC_FOCO_ADMIN "#focotdm.test.admin"
	#define IRC_FOCO_TRADMIN "#focotdm.test.tradmins"
	
#else

	#define BOT_1_NICKNAME "TDM_BOT_ECHO1"
	#define BOT_1_REALNAME "Aero's Prowler"
	#define BOT_1_USERNAME "biebersux"

	#define BOT_2_NICKNAME "TDM_BOT_ECHO2"
	#define BOT_2_REALNAME "Shaney's Cool"
	#define BOT_2_USERNAME "biebersux"

	#define BOT_3_NICKNAME "TDM_BOT_ECHO3"
	#define BOT_3_REALNAME "Wazza Chea"
	#define BOT_3_USERNAME "biebersux"

	#define BOT_4_NICKNAME "TDM_BOT_ECHO4"
	#define BOT_4_REALNAME "Im Da Bot"
	#define BOT_4_USERNAME "biebersux"

	#define BOT_5_NICKNAME "TDM_BOT_ECHO5"
	#define BOT_5_REALNAME "Fucking_Metagamer"
	#define BOT_5_USERNAME "biebersux"

	#define BOT_6_NICKNAME "TDM_BOT_ECHO6"
	#define BOT_6_REALNAME "Uber nub"
	#define BOT_6_USERNAME "biebersux"

	#define BOT_7_NICKNAME "TDM_BOT_ECHO7"
	#define BOT_7_REALNAME "Liverpool is the best"
	#define BOT_7_USERNAME "biebersux"

	#define BOT_8_NICKNAME "TDM_BOT_ECHO8"
	#define BOT_8_REALNAME "Mow sux at TDM"
	#define BOT_8_USERNAME "biebersux"

	#define BOT_9_NICKNAME "TDM_BOT_ECHO9"
	#define BOT_9_REALNAME "Lee Peecock"
	#define BOT_9_USERNAME "biebersux"

	#define BOT_10_NICKNAME "TDM_BOT_ECHO10"
	#define BOT_10_REALNAME "Marcel Smith"
	#define BOT_10_USERNAME "biebersux"

	#define BOT_11_NICKNAME "TDM_BOT_ECHO11"
	#define BOT_11_REALNAME "Simon Pear"
	#define BOT_11_USERNAME "biebersux"
	
	#define BOT_12_NICKNAME "TDM_BOT_ECHO12"
	#define BOT_12_REALNAME "Mista Vista"
	#define BOT_12_USERNAME "biebersux"
	
	#define BOT_13_NICKNAME "TDM_BOT_ECHO13"
	#define BOT_13_REALNAME "Doctor Death"
	#define BOT_13_USERNAME "biebersux"

	#define IRC_SERVER "irc.tl"
	#define IRC_PORT (6667)
	#define IRC_FOCO_ECHO "#focotdm.echo"
	#define IRC_FOCO_LEADS "#focotdm.lecho"
	#define IRC_FOCO_MAIN "#focotdm.ig"
	#define IRC_FOCO_ADMIN "#focotdm.adm"
	#define IRC_FOCO_TRADMIN "#focotdm.tradmins"
#endif
#define MAX_BOTS (13)
#define PLUGIN_VERSION "1.4.3"

#define INFINITY (Float:0x7F800000)

//==============================[RULES]=================================================
//#define RULES "1. No using hack/cleo programs\n2. No bug abusing\n3. Keep the profane language to a minimum\n4. No insulting other players\n5. No boosting\n6. No spamming\n7. No spawn killing\n8. No drive-by without a driver\n9. Racism is not allowed\n10. No driver drive-by\n11. English only in main chat\n12. No excessive heli-blading\n13. No car parking\n14. No custom map objects"
