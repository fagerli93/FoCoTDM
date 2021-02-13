#if !defined MAIN_INIT
#error "Compiling from wrong script. (foco.pwn)"
#endif

#include                ".\systemvars.inc"

new	
	rulestxt[7800];

new con;

new RconAttempt[MAX_PLAYERS] = 0;
new ManHuntID = -1;								// This stores the userID of who is currently the ManHunt target.
/*
* Mod Script
*/
new ModdingCar[MAX_PLAYERS] = 0; //Indicates if the player is in the modification menus
new ModPosition[MAX_PLAYERS]; //The position (0-17) the player is in terms of the attatchment array position
new ModCartTotal[MAX_PLAYERS]; //Increments the cost of the cart.

/*
* Connection Messages variable
*/

new ConLog[MAX_PLAYERS] = 0;
new bool:IsPlayerAuthenticated[MAX_PLAYERS]; //To Avoid AdminSecurity From being Bypassed
/*
	Mute system, found in ../Developer/pEar/pEar_mute.pwn
	Had to add the variables here as some external files were whining.
*/
enum muted_info {
	muted,					// Toggles if muted or not.
	mutedBy,				// Stores the admin that muted a player -> -1 if muted due to spam.
	muteTime,				// Stores time (unixtime) of when a player was muted.
	unmuteTime,				// Stores mute time in minutes
	spam 					// Stores spam amount
};

new mutedPlayers[MAX_PLAYERS][muted_info];

/*
* Achievements
*/
new ShowingAchievement[MAX_PLAYERS] = -1;			// Stores if there is an achievement currently showing.
new CurrentKillStreak[MAX_PLAYERS];					// Stores the killstreak value a user is on. Will ++ on killing.
new CurrentDeathStreak[MAX_PLAYERS];                // Stores the deathstreak value a user is on. Will ++ on death.
new AchievementTimer[MAX_PLAYERS];             		//Used to hide the textdraws after a certain amount of time


/*
* Dialog Vars
*/
new DialogOptionVar1[MAX_PLAYERS];					// A variable to store random things a player is doing in a dialog. This is universal.
new DialogOptionVar2[MAX_PLAYERS];					// A variable to store random things a player is doing in a dialog. This is universal.
new DialogOptionVar5[MAX_PLAYERS];
new DialogOptionVar3[MAX_PLAYERS][128];				// A variable (String) to store random things a player is doing in a dialog. This is universal.
new DialogOptionVar4[MAX_PLAYERS][128];	

/*
* Pickups
*/
new pickupdelID[MAX_PLAYERS];						// Stores the ID fo the pickup your about to delete.
new pickupModel[MAX_PLAYERS];						// Stores the model ID of the pickup your editing.
new pickup_type[MAX_PLAYERS];						// Stores the type of the pickup your editing.
new pickup_list_selection[MAX_PLAYERS];				// The list you have selected.
new pickup_list_var1[MAX_PLAYERS];					// The variable selected within the list.

/*
* ManHunt Vars
*/
new ManHuntFail;								// This stores the amount of times manhunt has failed to set a target, due to it selecting online admins or false players.
new ManHuntTwenty;								// This is used for manhunt in the TenMinuteTimer(). It will be ++'d then when it hits 2, it will be reset to 0 and manhunt will begin.
new ManHuntSeconds; 							// This stores the UNIX timestamp of the player, when he is assigned manhunt.

/*
* For Admin Commands.
*/
new aUndercover[MAX_PLAYERS] = 0;
new ShopSys = 0;								// 0 = Enabled / 1 = Disabled. For the Shop System.
new ADuty[MAX_PLAYERS];							// Stores if the player is on admin duty or not.  1 /  0
new AdutyOldColor[MAX_PLAYERS];					// Stores the color the player had before going on aduty.
new Spectated[MAX_PLAYERS] = -1;				// will store the ID of the person spectating you.
new WatchPMAdmin[MAX_PLAYERS] = -1;				// Will store the ID of the person your watching PM's of.
new WatchGAdmin[MAX_PLAYERS] = -1; 				// Will store the ID of the team your watching the chat of..
new noname[MAX_PLAYERS];						// Will toggle whether the name is hidden or not of the player.
new Froze[MAX_PLAYERS]; 						// Will toggle if your frozen or not. 
new Spectating[MAX_PLAYERS] = -1;				// This will store the ID of the person your spectating.
new NitrousBoostEn[MAX_PLAYERS];				// Will toggle if you can nitro boost or not.
new BotsConnected = -1; 						// Are the Bots connected ?
new ForcedCriminal = -1;                		// Forcing of criminals for pursuit event.
new OnPlayerDeathMsg[MAX_PLAYERS];              // For watching OnPlayerDisconnect
new OnPlayerDisconnectMsg[MAX_PLAYERS];         // For watching OnPlayerDeath

/*
* Guardian - Anticheat - Wazza;
*/
new SpawnAttempts[MAX_PLAYERS];					// Stores amount of spawn attempts you have made without logging in.
new death[MAX_PLAYERS];							// Toggles if dead or no.
new surfdeath[MAX_PLAYERS];						// Will save if you died on a vechile or not.
new FailedLoginAttempts[MAX_PLAYERS];

/*
* Unix Time Related.
*/
new vehtimerspawning[MAX_PLAYERS];  			// This is used for storing the time since last /mycar or relevant commands.
//new updatecarkey[MAX_PLAYERS]; 					// This is used to store how long since using /updatekey. (Don't remove.. else SQL could be spammed).
new AdutyTimer[MAX_PLAYERS];					// Stores how long you have been on aduty.
new countdown = -1;								// This is a timer function, set to an amount and it will decrease by 1 each time in OneSecondTimer.
new carsettimer[MAX_PLAYERS];					// This stores the timestamp on when you last used a vehicle command.
new deathSpec[MAX_PLAYERS];	

/*
* Clan War Variables
*/
new ClanWar_Joining[MAX_PLAYERS];
new ClanWar_Clan[MAX_PLAYERS];
new ClanWar_Members[MAX_PLAYERS];
new ClanWar_Package[MAX_PLAYERS];
new ClanWar[MAX_PLAYERS];
new ClanWar_Trial[MAX_PLAYERS];
new Text:ClanOneTD[MAX_PLAYERS];
new Text:ClanTwoTD[MAX_PLAYERS];
new Text:CW_ScoreTD;

/*
* SQL Related Variables.
*/
new OnlineConnectionSave[MAX_PLAYERS][32];			// This will store the randomly generated number for the connection storage, this matches the one in the SQL.
new teamSize[MAX_PLAYERS][50];
new nameThread[MAX_PLAYERS][MAX_PLAYER_NAME]; 	// used by the SQL for passing a name accross.
new ircActionThread[MAX_PLAYER_NAME];
new ircActionThreadtwo[50];

/*
* Random Variables
*/
new LastVehicle[MAX_PLAYERS] = -1;				// This will store the vehicle ID of the last vehicle you were inside of.
new antifallveh[MAX_PLAYERS];
new antifallcheck[MAX_PLAYERS];
new antifall[MAX_PLAYERS];
new oldskin[MAX_PLAYERS];                       // Stores the old skin ID for reusing in commands such as /resetskin
new healAmount[MAX_PLAYERS];                    // Stores amount of times a player has healed during one lifetime to change price of /heal.
new specHP[MAX_PLAYERS];                        // Stores amount of HP an admin has before he uses /spec so it can reset after.
new specArmour[MAX_PLAYERS];                    // ^Same, just with armour
new afkHP[MAX_PLAYERS];                        // Stores amount of HP a player has before using /afk so it resets after to avoid abooooose.
new isAFK[MAX_PLAYERS];
new afkArmour[MAX_PLAYERS];
new ClanSkinSwitch[MAX_TEAMS];
new canAFK[MAX_PLAYERS];


//new randommessagetimer;							// This is a timer which will decrease to count amount of seconds since the last random message.
new increment;									// This is used in places to just ++ when required. MAINLY in the event code.
new clanselectid;								// This will store the private clan skin selection ID.
//new endroundtimer;								// This is a timer for the end round command. Which will -- from whatever it's set as.
new TempVeh[MAX_VEHICLES];
new lastEventWon = -1;								// Won last event.
new 
	Team1 = 0,
	Team2 = 0;


new clanCheck[MAX_PLAYERS]; 
new carSQLCol[MAX_PLAYERS];	
new lastMessage[MAX_PLAYERS];
new bool:hitSound[MAX_PLAYERS];
new lastKiller[MAX_PLAYERS] = -1;
new IsLastKillTK[MAX_PLAYERS] = -1;

new LastWeapon[MAX_PLAYERS];
new weaponEditing[MAX_PLAYERS];
new bool:wepObjEnable[MAX_PLAYERS] = true;

/*
* Ne-on Lights Sys
*/
new neon[MAX_VEHICLES]; 
new neon2[MAX_VEHICLES];

/*
* For Each
*/
new Iterator:FoCoTeams<MAX_TEAMS>; 				// Stores the teams in the foreach function.


/*
* Animation Variables
*/
new gPlayerUsingLoopingAnim[MAX_PLAYERS]; 		// This is the loop check value for animations.
new gPlayerAnimLibsPreloaded[MAX_PLAYERS];		// This is for the Animation Systems and pre-loading on anims.

/*
* Trans System
*/
new trans[MAX_PLAYERS]; 						// Trans enabled? Yes/No
new transveh[MAX_PLAYERS]; 						// ID of the vehicle that is currently associated with trans. (Beanz should have merged this with trans and used -1 as unused. Dick)
new transslot[MAX_PLAYERS]; 					// Slot of trans.(Wtf?)
new transmodel[MAX_PLAYERS][3]; 				// Array for vehicle ID's in each slot.
new transcolor[MAX_PLAYERS][2]; 				// Array for colour ID's.
	
/*
* IRC Related
*/	
new FoCo_Spam;									// This will store the unix time since !foco was last used.
new IRC_TOG_PM;									// Whether you can or cannot PM IRC.
new gBotID[MAX_BOTS];							// IGNORE THIS, This needs to be here for IRC default.
new gEcho;										// gEcho channel ID
new gLeads;										// gLeads channel ID
new gMain;										// gMain channel ID
new gAdmin;                                     // gAdmin channel ID
new gTRAdmin;                                   // gTRAdmin channel ID
	

/*
* Report System
*/
/*
new ReportStr[MAX_PLAYERS][256];				// The string of the /report.
new reportID[MAX_PLAYERS] = -1;					// The ID of the report.
*/

/*
* Textdraws
*/
//new Text:SelectionTD[MAX_PLAYERS];
new Text:AchieveInfoTD[MAX_PLAYERS];
new Text:AchieveAqcTD;
new Text:AchieveBoxTD;
new Text:AchieveFoCoTD;
new Text:FoCoTDMTD;	
new Text:MoneyDeathTD[MAX_PLAYERS];
new Text:MoneyDeathVIPTD[MAX_PLAYERS];
new Text:Blackout3[MAX_PLAYERS];
new Text3D:vehicle3Dtext[MAX_PLAYERS];

new Text:CurrLeader;
new Text:CurrLeaderName;
new Text:GunGame_MyKills[MAX_PLAYERS];
new Text:GunGame_Weapon[MAX_PLAYERS];

new Text:KillTD[MAX_PLAYERS];

new legalmods[48][22] = {
    {400, 1024,1021,1020,1019,1018,1013,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {401, 1145,1144,1143,1142,1020,1019,1017,1013,1007,1006,1005,1004,1003,1001,0000,0000,0000,0000},
    {404, 1021,1020,1019,1017,1016,1013,1007,1002,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {405, 1023,1021,1020,1019,1018,1014,1001,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {410, 1024,1023,1021,1020,1019,1017,1013,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
    {415, 1023,1019,1018,1017,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {418, 1021,1020,1016,1006,1002,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {420, 1021,1019,1005,1004,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {421, 1023,1021,1020,1019,1018,1016,1014,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {422, 1021,1020,1019,1017,1013,1007,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {426, 1021,1019,1006,1005,1004,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {436, 1022,1021,1020,1019,1017,1013,1007,1006,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
    {439, 1145,1144,1143,1142,1023,1017,1013,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
    {477, 1021,1020,1019,1018,1017,1007,1006,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {478, 1024,1022,1021,1020,1013,1012,1005,1004,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {489, 1024,1020,1019,1018,1016,1013,1006,1005,1004,1002,1000,0000,0000,0000,0000,0000,0000,0000},
	{491, 1145,1144,1143,1142,1023,1021,1020,1019,1018,1017,1014,1007,1003,0000,0000,0000,0000,0000},
    {492, 1016,1006,1005,1004,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {496, 1143,1142,1023,1020,1019,1017,1011,1007,1006,1003,1002,1001,0000,0000,0000,0000,0000,0000},
    {500, 1024,1021,1020,1019,1013,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {516, 1021,1020,1019,1018,1017,1016,1015,1007,1004,1002,1000,0000,0000,0000,0000,0000,0000,0000},
    {517, 1145,1144,1143,1142,1023,1020,1019,1018,1017,1016,1007,1003,1002,0000,0000,0000,0000,0000},
    {518, 1145,1144,1143,1142,1023,1020,1018,1017,1013,1007,1006,1005,1003,1001,0000,0000,0000,0000},
    {527, 1021,1020,1018,1017,1015,1014,1007,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {529, 1023,1020,1019,1018,1017,1012,1011,1007,1006,1003,1001,0000,0000,0000,0000,0000,0000,0000},
    {534, 1185,1180,1179,1178,1127,1126,1125,1124,1123,1122,1106,1101,1100,0000,0000,0000,0000,0000},
    {535, 1121,1120,1119,1118,1117,1116,1115,1114,1113,1110,1109,0000,0000,0000,0000,0000,0000,0000},
    {536, 1184,1183,1182,1181,1128,1108,1107,1105,1104,1103,0000,0000,0000,0000,0000,0000,0000,0000},
    {540, 1145,1144,1143,1142,1024,1023,1020,1019,1018,1017,1007,1006,1004,1001,0000,0000,0000,0000},
    {542, 1145,1144,1021,1020,1019,1018,1015,1014,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {546, 1145,1144,1143,1142,1024,1023,1019,1018,1017,1007,1006,1004,1002,1001,0000,0000,0000,0000},
    {547, 1143,1142,1021,1020,1019,1018,1016,1003,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {549, 1145,1144,1143,1142,1023,1020,1019,1018,1017,1012,1011,1007,1003,1001,0000,0000,0000,0000},
    {550, 1145,1144,1143,1142,1023,1020,1019,1018,1006,1005,1004,1003,1001,0000,0000,0000,0000,0000},
    {551, 1023,1021,1020,1019,1018,1016,1006,1005,1003,1002,0000,0000,0000,0000,0000,0000,0000,0000},
    {558, 1168,1167,1166,1165,1164,1163,1095,1094,1093,1092,1091,1090,1089,1088,0000,0000,0000,0000},
    {559, 1173,1162,1161,1160,1159,1158,1072,1071,1070,1069,1068,1067,1066,1065,0000,0000,0000,0000},
    {560, 1170,1169,1141,1140,1139,1138,1033,1032,1031,1030,1029,1028,1027,1026,0000,0000,0000,0000},
    {561, 1157,1156,1155,1154,1064,1063,1062,1061,1060,1059,1058,1057,1056,1055,1031,1030,1027,1026},
    {562, 1172,1171,1149,1148,1147,1146,1041,1040,1039,1038,1037,1036,1035,1034,0000,0000,0000,0000},
    {565, 1153,1152,1151,1150,1054,1053,1052,1051,1050,1049,1048,1047,1046,1045,0000,0000,0000,0000},
    {567, 1189,1188,1187,1186,1133,1132,1131,1130,1129,1102,0000,0000,0000,0000,0000,0000,0000,0000},
    {575, 1177,1176,1175,1174,1099,1044,1043,1042,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {576, 1193,1192,1191,1190,1137,1136,1135,1134,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {580, 1023,1020,1018,1017,1007,1006,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {589, 1145,1144,1024,1020,1018,1017,1016,1013,1007,1006,1005,1004,1000,0000,0000,0000,0000,0000},
    {600, 1022,1020,1018,1017,1013,1007,1006,1005,1004,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {603, 1145,1144,1143,1142,1024,1023,1020,1019,1018,1017,1007,1006,1001,0000,0000,0000,0000,0000}
};


/*
* Enumerations/Arrays
*/

enum FoCo_Classes_Info
{
	fc_id,
	fc_player_dbid,
	fc_melee,
	fc_handguns,
	fc_shotguns,
	fc_submachine,
	fc_assault,
	fc_rifle
};
new FoCo_Classes[MAX_PLAYERS][FoCo_Classes_Info];

/*
* Player Stats System:
Note by pEar: Replaced with FoCo_Playerstats enum
*/


/*
	FoCo_PlayerStats_dbid[MAX_PLAYERS],
	FoCo_PlayerStats_deaths[MAX_PLAYERS],
	FoCo_PlayerStats_suicides[MAX_PLAYERS],
	FoCo_PlayerStats_helpups[MAX_PLAYERS],
	FoCo_PlayerStats_kills[MAX_PLAYERS],
	FoCo_PlayerStats_streaks[MAX_PLAYERS],
	FoCo_PlayerStats_heli[MAX_PLAYERS],
	FoCo_PlayerStats_deagle[MAX_PLAYERS],
	FoCo_PlayerStats_m4[MAX_PLAYERS],
	FoCo_PlayerStats_mp5[MAX_PLAYERS],
	FoCo_PlayerStats_knife[MAX_PLAYERS],
	FoCo_PlayerStats_rpg[MAX_PLAYERS],
	FoCo_PlayerStats_flamethrower[MAX_PLAYERS],
	FoCo_PlayerStats_chainsaw[MAX_PLAYERS],
	FoCo_PlayerStats_grenade[MAX_PLAYERS],
	FoCo_PlayerStats_colt[MAX_PLAYERS],
	FoCo_PlayerStats_uzi[MAX_PLAYERS],
	FoCo_PlayerStats_combatshotgun[MAX_PLAYERS],
	FoCo_PlayerStats_smg[MAX_PLAYERS],
	FoCo_PlayerStats_ak47[MAX_PLAYERS],
	FoCo_PlayerStats_tec9[MAX_PLAYERS],
	FoCo_PlayerStats_sniper[MAX_PLAYERS],
	*/
new	FoCo_PlayerStats_hitscompleted[MAX_PLAYERS];
new	FoCo_PlayerStats_turf[MAX_PLAYERS];
new FoCo_PlayerStats_carepackage[MAX_PLAYERS];
/* FoCo_PlayerStats_assistkills[MAX_PLAYERS];*/

new FoCo_PlayerAchievements[MAX_PLAYERS][AMOUNT_ACHIEVEMENTS+1];//0 = db-id, 1= ach 0

enum FoCo_Pickup_Info
{
	LP_DBID, // DB ID
	LP_IGID, // IG ID
	LP_pickupid, // Pickup Model ID
	LP_type,
	Float:LP_x,
	Float:LP_y,
	Float:LP_z,
	LP_world,
	LP_interior,
	LP_message[150],
	LP_addedby[150],
	LP_Option_one,
	LP_Selected_Type
};
new FoCo_Pickups[MAX_PICKUPS][FoCo_Pickup_Info];

enum FoCo_Team_Info
{
	db_id, // DB ID
	team_name[50],
	team_color[20],
	team_rank_amount,
	team_rank_1[20],
	team_rank_2[20],
	team_rank_3[20],
	team_rank_4[20],
	team_rank_5[20],
	team_skin_1,
	team_skin_2,
	team_skin_3,
	team_skin_4,
	team_skin_5,
	team_class,
	team_members,
	Float:team_spawn_x,
	Float:team_spawn_y,
	Float:team_spawn_z,
	team_spawn_interior,
	team_spawn_world,
	team_max_members,
	team_type,
	team_score,
	team_clanwar_attending,
	team_clanwar_enemy,
	team_clanwar_members,
	team_clanwar_kills,
	team_clanwar_deaths,
	team_clanwar_trial
};
new FoCo_Teams[MAX_TEAMS][FoCo_Team_Info]; // This is the teams errors...

/*=========================================================
        SLOT 2: Desert Eagle / 9MM / Silenced 9MM
        SLOT 3: Shotgun / Sawnoff Shotgun / Combat Shotgun
        SLOT 4: Micro SMG / MP5 / Tec 9
        SLOT 5: AK-47 / M4
        SLOT 6: Sniper Rifle / Country Rifle
=========================================================*/
 
/*======================================================================================================================================*/
/*======================================================================================================================================*/
 
// SKIN TYPE 1: Normal skins / CJ like.
new skins_normal[][] = {
        0,1,3,4,7,8,9,11,12,15,17,18,19,20,21,23,24,25,27,28,30,34,35,36,37,45,46,47,48,50,51,52,
        55,56,57,59,60,61,64,66,67,69,71,79,80,81,82,83,84,86,96,97,98,99,100,102,104,106,107,109,
        110, 111,112,113,114,115,116,117,118,119,120,122,123,126,127,130,135,142,143,144,151,154,155,
        156,158,159,161,162,163,164,165,166,167,168,169,170,171,173,174,175,176,177,179,180,181,182,184,
        185,186,189,192,193,194,195,198,200,203,204,206,207,208,213,217,220,221,222,223,227,228,232,234,239,
        240,248,250,252,258,259,260,261,262,265,266,268,270,271,272,273,274,275,276,280,281,282,283,284,285,
        289,288,290,291,292,293,294,295,296,297,298,299
};
 
// SKIN TYPE 2: Skins which consist of a hood.
new skins_hoods[][] = {
        2
};
 
// SKIN TYPE 3: Thin skins. (Mostly females)
new skins_thins[][] = {
        14,32,33,42,43,44,49,58,62,68,70,72,73,94,95,108,124,13,40,41,63,65,75,76,77,85,87,88,90,91,92,93,
        125,128,131,132,133,134,136,137,138, 139,149,141,145,146,147,148,150,152,153,157,160,172,178,183,187,
        188,190,191,201,202,209,210,211,212,214,215,216,219,224,225,226,229,230,231,233,236,237,238,244,246,247,
        251,253,255,256,257,263
};
 
// SKIN TYPE 4: Big skins.
new skins_big[][] = {
        5,103,105,149
};
 
// SKIN TYPE 5: Skins which consist of a backpack.
new skins_bag[][] = {
        26
};
 
// SKIN TYPE 6: Slightly bigger compared to normal skins.
new skins_bigger[][] = {
        6,16,22,29,78,101,121,205,241,242,243,245,249,254,264,267,269,277,278,279,286
};
 
// SKIN TYPE 7: Granny skins.
new skins_granny[][] = {
        10,31,38,39,53,54,89,129,196,197,199,218
};
 
// SKIN TYPE 8: Army Skin
new skins_army[][] = { 287 };


new level_requirement[MAX_LEVELS+1] = {0, 10, 30, 80, 150, 230, 320, 450, 700, 1000, 1337};
 

// Weapon ID, Slot, level gained   ( 1  = Main  |  2 = 2nd Main  |   3 = Side Arm    |   4 = Additional   5 = Donator 
new class_slots[][] = {
	{1, 0, 0},	
	{2, 1, 0},	
	{3, 1, 0},	
	{4, 1, 0},	
	{5, 1, 0},	
	{6, 1, 0},	
	{7, 1, 0},	
	{8, 1, 0},	
	{9, 1, 15},
	{10, 10, 0},
	{11, 10, 0}, 
	{12, 10, 0}, 
	{13, 10, 0}, 
	{14, 10, 0},	
	{15, 10, 0}, 
	{16, 8, 15}, 
	{17, 8, 15}, 
	{18, 8, 15}, 
	{22, 2, 0},
	{23, 2, 0},
	{24, 2, 0}, 
	{25, 3, 1}, 
	{26, 3, 2}, 
	{27, 3, 5}, 
	{28, 4, 3}, 
	{29, 4, 3}, 
	{30, 5, 4}, 
	{31, 5, 6}, 
	{32, 4, 3},
	{33, 6, 5}, 
	{34, 6, 7}, 
	{35, 7, 15}, 
	{36, 7, 15}, 
	{37, 7, 15}, 
	{38, 7, 15}, 
	{39, 8, 15}, 
	{40, 12, 15}, 
	{41, 9, 15}, 
	{42, 9, 15},	
	{43, 9, 15}, 
	{44, 11, 15}, 
	{45, 11, 15}, 
	{46, 11, 15}
};

/*
* Hats and Sunglasses
*/
/*
new Float: CapSkinOffSet[299][6] = {
{0.135928, 0.002891, -0.008518, 0.000000, 0.000000, 347.188201},//Skin - 0
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                 //Skin - 1
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                 //Skin - 2
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                 //Skin - 3
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                 //Skin - 4
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                 //Skin - 5
{0.155785, 0.005998, -0.014326, 0.000000, 0.000000, 347.188201},//Skin - 6
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                 //Skin - 7
{0.131067, -0.013737, -0.008518, 0.000000, 0.000000, 347.188201},//Skin - 8
{0.118922, -0.015322, -0.008518, 0.000000, 0.000000, 347.188201},//Skin - 9
{0.125779, -0.001459, -0.008518, 0.000000, 0.000000, 347.188201},//Skin - 10
{0.129249, -0.014101, -0.008518, 0.000000, 0.000000, 347.188201},//Skin - 11
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 12
{0.161076, -0.015624, -0.006768, 0.000000, 0.000000, 347.188201},//Skin - 13
{0.112204, -0.023196, -0.006768, 0.000000, 0.000000, 347.188201},//Skin - 14
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 15
{0.150166, -0.008718, -0.006768, 0.000000, 0.000000, 347.188201},//Skin - 16
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 17
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 18
{0.153609, -0.003207, -0.007717, 0.000000, 0.000000, 357.608825},//Skin - 19
{0.143831, 0.001813, -0.010588, 0.000000, 0.000000, 357.608825}, //Skin - 20
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 21
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 22
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   //Skin - 23
{0.127352, 0.009877, -0.006845, 0.726156, 359.666778, 348.825012},//Skin - 24
{0.124666, -0.029373, -0.006845, 0.726156, 359.666778, 329.940704},//Skin - 25
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 26
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 27
{0.128768, 0.041474, -0.007667, 0.726156, 359.666778, 355.429199}, //Skin - 28
{0.166457, -0.006228, -0.012669, 0.726156, 359.666778, 354.612152},//Skin - 29
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 30
{0.096077, -0.023233, -0.009101, 0.726156, 359.666778, 343.094055},//Skin - 31
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 32
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 33
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 34
{0.155565, 0.014400, -0.009101, 0.726156, 359.666778, 6.131487},   //Skin - 35
{0.156485, 0.013641, -0.009101, 0.726156, 359.666778, 6.131487},   //Skin - 36
{0.144815, 0.013641, -0.009374, 0.726156, 359.666778, 350.562103}, //Skin - 37
{0.113347, -0.006682, -0.009374, 0.726156, 359.666778, 350.562103},//Skin - 38
{0.147231, -0.014448, -0.004786, 0.726156, 359.666778, 357.303253},//Skin - 39
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 40
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 41
{0.082446, 0.004202, -0.004786, 0.726156, 359.666778, 357.303253}, //Skin - 42
{0.104901, 0.004013, -0.004786, 0.726156, 359.666778, 342.983184}, //Skin - 43
{0.116172, -0.001954, -0.004786, 0.726156, 359.666778, 357.100677},//Skin - 44
{0.153321, 0.025744, -0.008666, 0.726156, 359.666778, 10.704365},  //Skin - 45
{0.160556, 0.007781, -0.010438, 0.726156, 359.666778, 0.991972},   //Skin - 46
{0.179010, -0.035613, -0.010438, 0.726156, 359.666778, 347.956573},//Skin - 47
{0.123363, 0.008694, -0.010438, 0.726156, 359.666778, 347.956573}, //Skin - 48
{0.167061, -0.037899, -0.010438, 0.726156, 359.666778, 347.775817},//Skin - 49
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 50
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 51
{0.129040, 0.016069, -0.010438, 0.726156, 359.666778, 347.775817}, //Skin - 52
{0.129040, 0.016069, -0.006084, 0.726156, 359.666778, 347.775817}, //Skin - 53
{0.137743, -0.016369, -0.011731, 0.726156, 359.666778, 355.812011},//Skin - 54
{0.137743, -0.016369, -0.011731, 0.726156, 359.666778, 355.812011},//Skin - 55
{0.174539, -0.000662, -0.007289, 0.726156, 359.666778, 352.847045},//Skin - 56
{0.109382, -0.002955, -0.007289, 0.726156, 359.666778, 352.847045},//Skin - 57
{0.152276, -0.029331, -0.008357, 0.726156, 359.666778, 332.070648},//Skin - 58
{0.129599, -0.019172, -0.012204, 0.726156, 359.666778, 332.070648},//Skin - 59
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 60
{0.130350, 0.000897, -0.000747, 0.726156, 359.666778, 332.070648}, //Skin - 61
{0.150659, -0.035485, -0.006299, 0.726156, 359.666778, 341.617431},//Skin - 62
{0.119340, -0.006483, -0.006299, 0.726156, 359.666778, 341.617431},//Skin - 63
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 64
{0.133055, -0.000092, -0.006299, 0.726156, 359.666778, 341.617431},//Skin - 65
{0.129061, -0.006499, -0.006299, 0.726156, 359.666778, 341.617431},//Skin - 66
{0.127292, 0.010318, -0.006299, 0.726156, 359.666778, 341.617431}, //Skin - 67
{0.138791, -0.025311, -0.006299, 0.726156, 359.666778, 341.617431},//Skin - 68
{0.148132, 0.003970, -0.002304, 0.726156, 359.666778, 340.120025}, //Skin - 69
{0.129753, 0.006469, -0.006376, 0.726156, 359.666778, 354.029815}, //Skin - 70
{0.125663, 0.015428, -0.006376, 0.726156, 359.666778, 354.029815}, //Skin - 71
{0.125663, 0.015428, -0.009030, 0.726156, 359.666778, 354.029815}, //Skin - 72
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 73
{0.135729, -0.018656, -0.013554, 0.000000, 0.000000, 337.893737},  //Skin - 74
{0.141888, -0.042810, -0.006206, 0.000000, 0.000000, 337.893737},  //Skin - 75
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 76
{0.124348, -0.017813, -0.006206, 0.000000, 0.000000, 346.786865},  //Skin - 77
{0.124348, 0.000583, -0.006206, 0.000000, 0.000000, 346.786865},   //Skin - 78
{0.102654, -0.010906, -0.006206, 0.000000, 0.000000, 346.786865},  //Skin - 79
{0.102654, -0.010906, -0.006206, 0.000000, 0.000000, 346.786865},  //Skin - 81
{0.167928, 0.031601, -0.006206, 0.000000, 0.000000, 17.955888},    //Skin - 82
{0.159998, 0.023540, -0.006206, 0.000000, 0.000000, 17.955888},    //Skin - 83
{0.169630, 0.019315, -0.006206, 0.000000, 0.000000, 17.955888},    //Skin - 84
{0.163052, -0.039735, -0.006206, 0.000000, 0.000000, 341.169891},  //Skin - 85
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 86
{0.144811, -0.007521, -0.014207, 0.000000, 0.000000, 341.169891},  //Skin - 87
{0.129932, -0.007521, -0.007289, 0.000000, 0.000000, 341.169891},  //Skin - 88
{0.151147, -0.038608, -0.009597, 0.000000, 0.000000, 343.694549},  //Skin - 89
{0.147416, -0.031632, -0.009597, 0.000000, 0.000000, 343.694549},  //Skin - 90
{0.157728, -0.009677, -0.009597, 0.000000, 0.000000, 0.934848},    //Skin - 91
{0.136577, -0.015592, -0.009597, 0.000000, 0.000000, 341.013824},  //Skin - 92
{0.143821, 0.000631, -0.008385, 0.000000, 0.000000, 358.808868},   //Skin - 93
{0.100521, 0.003151, -0.007624, 0.000000, 0.000000, 358.808868},   //Skin - 94
{0.122833, -0.006031, -0.007624, 0.000000, 0.000000, 358.808868},  //Skin - 95
{0.145296, 0.003959, -0.007624, 0.000000, 0.000000, 358.808868},   //Skin - 96
{0.141658, 0.016474, -0.007624, 0.000000, 0.000000, 9.683902},     //Skin - 97
{0.145276, -0.002846, -0.007624, 0.000000, 0.000000, 340.239593},  //Skin - 98
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 99
{0.161745, -0.010244, -0.007624, 0.000000, 0.000000, 351.499267}, //Skin - 100
{0.151006, -0.030994, -0.005366, 0.000000, 0.000000, 340.428894}, //Skin - 101
{0.147111, 0.003794, -0.012433, 0.000000, 0.000000, 358.069244},  //Skin - 102
{0.154213, -0.052348, -0.003511, 356.299316, 0.000000, 336.751647},//Skin - 103
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 104
{0.153814, -0.039614, -0.006756, 356.299316, 0.000000, 336.930084},//Skin - 105
{0.153638, -0.039614, -0.013630, 356.299316, 0.000000, 336.930084},//Skin - 106
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 107
{0.140473, -0.026201, -0.000469, 0.390689, 355.405181, 335.554260},//Skin - 108
{0.140904, -0.007227, -0.008114, 0.390689, 355.405181, 335.554260},//Skin - 109
{0.140904, -0.007227, -0.008114, 0.390689, 355.405181, 335.554260},//Skin - 110
{0.134860, 0.001485, -0.010145, 0.390689, 358.632415, 347.730010},//Skin - 111
{0.124823, 0.001485, -0.009402, 0.390689, 358.632415, 347.730010},//Skin - 112
{0.157999, -0.012039, -0.006082, 0.390689, 358.632415, 347.730010},//Skin - 113
{0.144906, -0.005139, -0.009654, 0.390689, 358.632415, 336.830108},//Skin - 114
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                    //Skin - 116
{0.152829, -0.009735, -0.009654, 0.390689, 358.632415, 336.830108},//Skin - 117
{0.113804, 0.009252, -0.009654, 0.390689, 358.632415, 345.244384},//Skin - 118
{0.113804, 0.009252, -0.009654, 0.390689, 358.632415, 345.244384},//Skin - 119
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                   //Skin -120
{0.154275, -0.037484, -0.009654, 0.390689, 358.632415, 337.676666},//Skin - 121
{0.155674, -0.015613, -0.004339, 0.390689, 358.632415, 350.571228},//Skin - 122
{0.136433, -0.019181, -0.004339, 0.390689, 358.632415, 340.261840},//Skin - 123
{0.163258, -0.032386, -0.013128, 0.390689, 358.632415, 340.261840},//Skin - 124
{0.153242, -0.029651, -0.002434, 0.390689, 358.632415, 333.367614},//Skin - 125
{0.127978, -0.001961, -0.008867, 0.390689, 358.632415, 347.279052},//Skin - 126
{0.160856, -0.025356, -0.004428, 0.390689, 358.632415, 347.279052},//Skin - 127
{0.150266, -0.009032, -0.006781, 0.390689, 358.632415, 347.223754},//Skin - 128
{0.158060, 0.022907, -0.006781, 0.390689, 358.632415, 349.378875},//Skin - 129
{0.111739, 0.012673, -0.006781, 0.390689, 358.632415, 349.378875},//Skin - 130
{0.091638, -0.011600, -0.008686, 0.390689, 358.632415, 336.674468},//Skin - 131
{0.125788, 0.000635, -0.005915, 0.390689, 358.632415, 343.007751},//Skin - 132
{0.031324, -0.014154, -0.005915, 0.390689, 358.632415, 343.007751},//Skin - 133
{0.142321, 0.015417, -0.005915, 0.243191, 358.632415, 350.329559},//Skin - 133
{0.128780, -0.030750, 0.006687, 173.184967, 358.632415, 27.422966},//Skin - 134
{0.115882, -0.004931, -0.003807, 358.837646, 358.632415, 346.206237},//Skin - 135
{0.127531, -0.008916, -0.003807, 358.837646, 358.632415, 346.206237},//Skin - 136
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 137
{0.148992, -0.017748, -0.006509, 358.837646, 358.632415, 350.742156},//Skin - 138
{0.148992, -0.017748, -0.006509, 358.837646, 358.632415, 350.742156},//Skin - 139
{0.147315, 0.001708, -0.006509, 358.837646, 358.632415, 354.390045},//Skin - 140
{0.144315, -0.013571, -0.006509, 358.837646, 358.632415, 354.390045},//Skin - 141
{0.144315, -0.002729, -0.010357, 358.837646, 358.632415, 354.390045},//Skin - 142
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 143
{0.177516, -0.070868, -0.009114, 358.837646, 358.632415, 331.679321},//Skin - 144
{0.139578, -0.008750, -0.004405, 358.837646, 358.632415, 343.319335},//Skin - 145
{0.139578, -0.014406, -0.004405, 358.837646, 358.632415, 343.319335},//Skin - 146
{0.115592, -0.010754, -0.004405, 358.837646, 358.632415, 343.319335},//Skin - 147
{0.150735, -0.000459, -0.004405, 358.837646, 358.632415, 9.362450},//Skin - 148
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 149
{0.149485, -0.008709, -0.006168, 358.837646, 358.632415, 2.276566},//Skin - 150
{0.168162, -0.009708, -0.012160, 359.504821, 4.442328, 355.348114},//Skin - 151
{0.156369, -0.024521, -0.012160, 359.504821, 0.415596, 355.348114},//Skin - 152
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 153
{0.119297, -0.016080, -0.010776, 359.504821, 0.415596, 341.522827},//Skin - 154
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 155
{0.172295, -0.065549, -0.007187, 359.504821, 0.415596, 336.175567},//Skin - 156
{0.126340, -0.030764, -0.007187, 359.504821, 0.415596, 336.175567},//Skin - 157
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 158
{0.154280, 0.002166, -0.010436, 359.504821, 0.415596, 357.792144},//Skin - 159
{0.121469, -0.007383, -0.010436, 359.504821, 0.415596, 341.538574},//Skin - 160
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 161
{0.139495, -0.007383, -0.010436, 359.504821, 0.415596, 341.538574},//Skin - 162
{0.113212, -0.005302, -0.010436, 359.504821, 0.415596, 341.538574},//Skin - 163
{0.120208, 0.003533, -0.010436, 359.504821, 0.415596, 341.538574},//Skin - 164
{0.135111, 0.005091, -0.006407, 359.504821, 0.415596, 352.954559},//Skin - 165
{0.122118, 0.005091, -0.006407, 359.504821, 0.415596, 352.954559},//Skin - 166
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 167
{0.125229, 0.005091, -0.013084, 359.504821, 0.415596, 352.954559},//Skin - 168
{0.153451, -0.018119, -0.013276, 359.504821, 0.415596, 358.219451},//Skin - 169
{0.141395, -0.009131, -0.013276, 359.504821, 0.415596, 347.866027},//Skin - 170
{0.157631, -0.028753, -0.006450, 359.504821, 0.415596, 339.935516},//Skin - 171
{0.152687, -0.027057, -0.007731, 359.504821, 0.415596, 344.054809},//Skin - 172
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 173
{0.165146, 0.015393, -0.007731, 359.504821, 0.415596, 344.001678},//Skin - 174
{0.162788, -0.019696, -0.007731, 359.504821, 0.415596, 344.001678},//Skin - 175
{0.157728, -0.027188, -0.012891, 359.504821, 0.415596, 345.804748},//Skin - 176
{0.187507, 0.010472, -0.012891, 359.504821, 0.415596, 12.315887},//Skin - 177
{0.153901, -0.027720, -0.007884, 359.504821, 0.415596, 344.553527},//Skin - 178
{0.137445, -0.009757, -0.012987, 359.504821, 0.415596, 344.553527},//Skin - 179
{0.173041, -0.006323, -0.012987, 359.504821, 0.415596, 3.267552},//Skin - 180
{0.143467, 0.016897, -0.007831, 359.504821, 0.415596, 349.504974},//Skin - 181
{0.114480, 0.006202, -0.007831, 359.504821, 0.415596, 349.504974},//Skin - 182
{0.114480, 0.008813, -0.007831, 359.504821, 0.415596, 349.504974},//Skin - 183
{0.128122, -0.012152, -0.013144, 359.504821, 0.415596, 336.326538},//Skin - 184
{0.156171, 0.007268, -0.013144, 359.504821, 0.415596, 10.805211},//Skin - 185
{0.156409, -0.034861, -0.007927, 359.504821, 0.415596, 336.978668},//Skin - 186
{0.118034, -0.024105, -0.002947, 359.504821, 0.415596, 336.978668},//Skin - 187
{0.128686, -0.029632, -0.002947, 358.201873, 0.415596, 329.325042},//Skin - 188
{0.172639, -0.026749, -0.012705, 358.201873, 0.415596, 349.092590},//Skin - 189
{0.180897, -0.026749, -0.007224, 358.201873, 0.415596, 349.092590},//Skin - 190
{0.180897, -0.026749, -0.007224, 358.201873, 0.415596, 349.092590},//Skin - 191
{0.178725, -0.010278, -0.007224, 358.201873, 0.415596, 354.053405},//Skin - 192
{0.172020, -0.010278, -0.010734, 358.201873, 0.415596, 354.053405},//Skin - 193
{0.172020, -0.010278, -0.010734, 358.201873, 0.415596, 354.053405},//Skin - 194
{0.176089, -0.032526, -0.005110, 358.201873, 0.415596, 341.814422},//Skin - 195
{0.118042, 0.007002, -0.005110, 358.201873, 0.415596, 341.814422},//Skin - 196
{0.143840, -0.042712, -0.007556, 358.201873, 0.415596, 341.814422},//Skin - 197
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 198
{0.148060, -0.032384, -0.009754, 358.201873, 0.415596, 333.484924},//Skin - 199
{0.148060, -0.032384, -0.009754, 358.201873, 0.415596, 333.484924},//Skin - 200
{0.140799, 0.025145, -0.009754, 358.201873, 0.415596, 5.040688},//Skin - 201
{0.140799, 0.015851, -0.009754, 358.201873, 0.415596, 349.796478},//Skin - 202
{0.140799, -0.004372, -0.013685, 358.201873, 0.415596, 349.796478},//Skin - 203
{0.154274, 0.006245, -0.013685, 358.201873, 0.415596, 2.035465},//Skin - 204
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 205
{0.154274, 0.016669, -0.013685, 358.201873, 0.415596, 2.035465},//Skin - 206
{0.106604, 0.004805, -0.011840, 358.201873, 0.415596, 2.035465},//Skin - 207
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 208
{0.148378, -0.003807, -0.011840, 358.201873, 0.415596, 2.035465},//Skin - 209
{0.113854, 0.001969, -0.011840, 358.201873, 0.415596, 343.826263},//Skin - 210
{0.149539, -0.028623, -0.009621, 358.201873, 0.415596, 331.587280},//Skin - 211
{0.104024, -0.014549, -0.009621, 358.201873, 0.415596, 331.587280},//Skin - 212
{0.145820, -0.029160, -0.009621, 358.201873, 0.415596, 331.587280},//Skin - 213
{0.148646, -0.008515, -0.009621, 358.201873, 0.415596, 1.360260},//Skin - 214
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 215
{0.148646, -0.005935, -0.004058, 358.201873, 0.415596, 1.360260},//Skin - 216
{0.148646, -0.015611, -0.004058, 358.201873, 0.415596, 340.374938},//Skin - 217
{0.133952, -0.030138, -0.009880, 358.201873, 0.415596, 340.374938},//Skin - 218
{0.140503, -0.033425, -0.005693, 358.201873, 0.415596, 340.374938},//Skin - 219
{0.114608, 0.009020, -0.009135, 358.201873, 0.415596, 352.932006},//Skin - 220
{0.186516, -0.044762, -0.009135, 358.201873, 0.415596, 344.217132},//Skin - 221
{0.186516, -0.044762, -0.009135, 358.201873, 0.415596, 344.217132},//Skin - 222
{0.179908, -0.010779, -0.009135, 358.201873, 0.415596, 344.217132},//Skin - 223
{0.156689, -0.015437, -0.009135, 358.201873, 0.415596, 352.741638},//Skin - 224
{0.156689, -0.015437, -0.009135, 358.201873, 0.415596, 352.741638},//Skin - 225
{0.134990, -0.034685, -0.009135, 358.201873, 0.415596, 340.812927},//Skin - 226
{0.151760, 0.002680, -0.009135, 358.201873, 0.415596, 340.812927},//Skin - 227
{0.167410, -0.028664, -0.009135, 358.201873, 0.415596, 340.250427},//Skin - 228
{0.127699, -0.015571, -0.006103, 358.201873, 0.415596, 347.232238},//Skin - 229
{0.100555, -0.007753, -0.006103, 358.201873, 0.415596, 347.232238},//Skin - 230
{0.126940, 0.016886, -0.006103, 358.201873, 0.415596, 347.232238},//Skin - 231
{0.132949, -0.017515, -0.008594, 358.201873, 0.415596, 347.232238},//Skin - 232
{0.146124, -0.008425, -0.008594, 358.201873, 0.415596, 347.232238},//Skin - 233
{0.125714, -0.021018, -0.008594, 358.201873, 0.415596, 347.232238},//Skin - 234
{0.084982, -0.009809, -0.008594, 358.201873, 0.415596, 347.232238},//Skin - 235
{0.114669, -0.005190, -0.008594, 358.201873, 0.415596, 351.301177},//Skin - 236
{0.123264, -0.014946, -0.008594, 358.201873, 0.415596, 351.301177},//Skin - 237
{0.146656, -0.023925, -0.006749, 358.201873, 0.415596, 334.356781},//Skin - 238
{0.133769, -0.007373, -0.006749, 358.201873, 0.415596, 343.105895},//Skin - 239
{0.165378, -0.020173, -0.005869, 358.201873, 0.415596, 348.352233},//Skin - 240
{0.143331, -0.133577, -0.011472, 358.201873, 0.415596, 312.328857},//Skin - 241
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 242
{0.098602, 0.002084, -0.011472, 358.201873, 0.415596, 348.195495},//Skin - 243
{0.124240, -0.011682, -0.006423, 358.201873, 0.415596, 341.555999},//Skin - 244
{0.158155, -0.044311, -0.005439, 358.201873, 0.415596, 336.024902},//Skin - 245
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 246
{0.164307, -0.040974, -0.006797, 358.201873, 0.415596, 337.067047},//Skin - 247
{0.191578, -0.040435, -0.010605, 358.201873, 0.415596, 340.908203},//Skin - 248
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 249
{0.135208, -0.015243, -0.011916, 358.201873, 0.415596, 340.908203},//Skin - 250
{0.134272, -0.027377, -0.006035, 358.201873, 0.415596, 333.416168},//Skin - 251
{0.158813, -0.038977, -0.006035, 358.201873, 0.415596, 336.013519},//Skin - 252
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 253
{0.165106, -0.048880, -0.009719, 358.201873, 0.415596, 331.050933},//Skin - 254
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 255
{0.142586, 0.020829, -0.008549, 358.201873, 0.415596, 2.765411},//Skin - 256
{0.134018, -0.024462, -0.008549, 358.201873, 0.415596, 339.642486},//Skin - 257
{0.147750, -0.042854, -0.008114, 0.951334, 0.415596, 330.441131},//Skin - 258
{0.147750, -0.042854, -0.008114, 0.951334, 0.415596, 330.441131},//Skin - 259
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 260
{0.134710, 0.006798, -0.008114, 358.188964, 0.415596, 352.703582},//Skin - 261
{0.111691, 0.006798, -0.008114, 358.188964, 0.415596, 352.703582},//Skin - 262
{0.146077, -0.005195, -0.008114, 358.188964, 0.415596, 3.866970},//Skin - 263
{0.135858, -0.157842, -0.008114, 358.188964, 0.415596, 314.852203},//Skin - 264
{0.127964, 0.000132, -0.008114, 358.188964, 0.415596, 352.699432},//Skin - 265
{0.127964, -0.002646, -0.008114, 358.188964, 0.415596, 352.699432},//Skin - 266
{0.132329, -0.014261, -0.007384, 1.504234, 0.415596, 352.699432},//Skin - 267
{0.145951, -0.043442, -0.010053, 1.504234, 0.415596, 320.469390},//Skin - 268
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 269
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 270
{0.141851, -0.034538, -0.010580, 1.504234, 0.415596, 340.349456},//Skin - 271
{0.136473, -0.057088, -0.008204, 1.504234, 0.415596, 318.134399},//Skin - 272
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                 //Skin - 273
{0.124270, 0.003252, -0.008204, 1.504234, 0.415596, 346.744995},//Skin - 274
{0.131583, 0.007682, -0.008204, 1.504234, 0.415596, 346.744995},//Skin - 275
{0.131583, 0.007682, -0.008204, 1.504234, 0.415596, 346.744995},//Skin - 276
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 277
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 278
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 279
{0.131583, 0.007682, -0.008204, 1.504234, 0.415596, 346.744995},//Skin - 280
{0.131583, 0.007682, -0.008204, 1.504234, 0.415596, 346.744995},//Skin - 281
{0.140515, 0.009018, -0.008204, 1.504234, 0.415596, 346.744995},//Skin - 282
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 283
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 284
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 285
{0.140515, 0.001933, -0.008204, 1.504234, 0.415596, 346.744995}, //Skin - 286
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 287
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 288
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 289
{0.128789, -0.014062, -0.007850, 1.504234, 0.415596, 340.341094},//Skin - 290
{0.158929, -0.027358, -0.010655, 1.504234, 0.415596, 337.298858},//Skin - 291
{0.113309, -0.012434, -0.010655, 1.504234, 0.415596, 337.298858},//Skin - 292
{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},                                  //Skin - 293
{0.158438, -0.023891, -0.007217, 1.504234, 0.415596, 337.298858},//Skin - 294
{0.145000, -0.032054, -0.007217, 1.504234, 0.415596, 336.385589},//Skin - 295
{0.139293, -0.069554, -0.010619, 1.504234, 0.415596, 320.746429},//Skin - 296
{0.148252, -0.066463, -0.010619, 1.504234, 0.415596, 320.729705},//Skin - 297
{0.126423, -0.066463, -0.010619, 1.504234, 0.415596, 320.729705},//Skin - 298
{0.144949, -0.040691, -0.008599, 1.504234, 0.415596, 320.729705}//Skin - 299
};

enum cap_inf
{
	omodel,
	oslot,
	bool: slotreserved,
};

new pObject[MAX_PLAYERS][cap_inf];

new hats[] = {18926, 18928, 18929, 18930, 18931, 18932, 18933, 18934, 18935};
*/
//new GunGameWeapons[] = {22, 23, 24, 25, 26, 27, 29, 28, 32, 30, 31, 33, 34, 35, 38, 16, 9, 9};

/*
* Admin Rank Names
*/
new AdRankNames[][56] =
{
	{"Player"},
	{"Junior Administrator"},
	{"Administrator"},
	{"Senior Administrator"},
	{"In-Game Lead Administrator"},
	{"Lead Administrator"}
};
/*
*Player Ranks
*/
new PlayerRankNames[][56] =
{
	{"Newbie"},
	{"Outsider"},
	{"Youngen"},
	{"Jumped In"},
	{"DM'er"},
	{"FoCo Regular"},
	{"FoCo Kill Freak"},
	{"FoCo Extremist"},
	{"FoCo King"},
	{"FoCo God"},
	{"1337"}
};



new Float:ClanWar_Area59[][] = {
	{207.2166,1866.3237,13.1406,269.2193}, // Area69clan1
	{207.2234,1864.4501,13.1406,269.5889}, // Area69clan1
	{207.1502,1863.0369,13.1406,264.3184}, // Area69clan1
	{207.1982,1861.7997,13.1406,265.9414}, // Area69clan1
	{207.1370,1859.8147,13.1406,265.6843}, // Area69clan1
	{203.6398,1859.7968,13.1406,267.9338}, // Area69clan1
	{203.7767,1861.2876,13.1406,267.3634}, // Area69clan1
	{203.9566,1863.0192,13.1406,266.7930}, // Area69clan1
	{204.1042,1864.5563,13.1406,266.5359}, // Area69clan1
	{204.1559,1866.1055,13.1406,267.2188}, // Area69clan1
	{272.5414,1862.5969,8.7649,317.3521}, // Area69clan2
	{274.2082,1862.3533,8.7578,341.2219}, // Area69clan2
	{275.7183,1862.6655,8.7578,348.4849}, // Area69clan2
	{277.2656,1862.5238,8.7578,23.3214}, // Area69clan2
	{278.8548,1861.9923,8.7578,43.7444}, // Area69clan2
	{277.4832,1855.6289,8.7649,358.3106}, // Area69clan2
	{275.9837,1855.8159,8.7649,353.3535}, // Area69clan2
	{274.5835,1856.0161,8.7578,354.3497}, // Area69clan2
	{272.7070,1856.3552,8.7578,346.8858}, // Area69clan2
	{270.9086,1856.9176,8.7578,338.4820} // Area69clan2
};

new Float:ClanWar_RCBG[][] = {
	{-975.2999,1069.4296,1344.9907,90.2174}, // RCbattlegroundclan1
	{-975.3762,1070.7350,1344.9886,88.8725}, // RCbattlegroundclan1
	{-975.4297,1072.1177,1344.9866,87.4802}, // RCbattlegroundclan1
	{-975.4318,1073.5367,1344.9894,89.5489}, // RCbattlegroundclan1
	{-975.3804,1075.2789,1344.9872,87.0407}, // RCbattlegroundclan1
	{-972.9529,1075.1123,1344.9993,84.2743}, // RCbattlegroundclan1
	{-973.0897,1073.6719,1344.9994,90.3070}, // RCbattlegroundclan1
	{-973.0069,1071.9658,1345.0066,88.9664}, // RCbattlegroundclan1
	{-973.0462,1070.3190,1345.0039,87.7991}, // RCbattlegroundclan1
	{-973.0823,1069.0049,1345.0052,91.6546}, // RCbattlegroundclan1
	{-1131.4271,1046.5276,1345.7423,272.0258}, // RCbattlegroundclan2
	{-1131.3142,1045.2085,1345.7389,270.4552}, // RCbattlegroundclan2
	{-1131.2991,1043.7292,1345.7373,269.1011}, // RCbattlegroundclan2
	{-1131.2366,1042.0660,1345.7354,269.8077}, // RCbattlegroundclan2
	{-1131.1970,1040.4888,1345.7335,270.2237}, // RCbattlegroundclan2
	{-1132.9172,1039.7849,1345.7441,267.5938}, // RCbattlegroundclan2
	{-1132.9758,1041.0096,1345.7457,269.0031}, // RCbattlegroundclan2
	{-1133.0364,1042.7405,1345.7478,267.6083}, // RCbattlegroundclan2
	{-1133.1060,1044.4194,1345.7500,268.1730}, // RCbattlegroundclan2
	{-1133.0082,1045.9691,1345.7512,270.4497} // RCbattlegroundclan2
};

new Float:ClanWar_JeffMtl[][] = {
	{2220.4585,-1147.9430,1025.7969,5.0773}, // Jeffersonmtlclan1
	{2221.4795,-1147.7955,1025.7969,0.2599}, // Jeffersonmtlclan1
	{2222.6145,-1147.7059,1025.7969,358.9272}, // Jeffersonmtlclan1
	{2223.8408,-1147.6653,1025.7969,358.1866}, // Jeffersonmtlclan1
	{2225.1560,-1147.6261,1025.7969,356.7431}, // Jeffersonmtlclan1
	{2225.0623,-1149.8740,1025.7969,355.4091}, // Jeffersonmtlclan1
	{2223.7690,-1149.7081,1025.7969,3.2871}, // Jeffersonmtlclan1
	{2222.4443,-1149.6902,1025.7969,358.5739}, // Jeffersonmtlclan1
	{2221.2573,-1149.5989,1025.7969,356.0732}, // Jeffersonmtlclan1
	{2220.0498,-1149.5298,1025.7969,359.8109}, // Jeffersonmtlclan1
	{2197.4470,-1139.4824,1029.7969,181.8127}, // Jeffersonmtlclan2
	{2196.0742,-1139.5155,1029.7969,179.7816}, // Jeffersonmtlclan2
	{2194.4934,-1139.5768,1029.7969,179.7163}, // Jeffersonmtlclan2
	{2193.1133,-1139.6907,1029.7969,180.6115}, // Jeffersonmtlclan2
	{2191.5137,-1139.6732,1029.7969,178.5187}, // Jeffersonmtlclan2
	{2191.6543,-1141.9338,1029.7969,178.5187}, // Jeffersonmtlclan2
	{2192.9900,-1142.0854,1029.7969,177.9494}, // Jeffersonmtlclan2
	{2193.9783,-1143.1968,1029.7969,177.9494}, // Jeffersonmtlclan2
	{2195.2905,-1144.7578,1029.7969,143.1691}, // Jeffersonmtlclan2
	{2196.2202,-1146.3638,1029.7969,128.7556} // Jeffersonmtlclan2
};

new Float:ClanWar_LVWar[][] = {
	{2580.6523,2830.2502,10.8203,271.6370}, // LVwarehouseclan1
	{2580.6301,2828.7461,10.8203,267.0588}, // LVwarehouseclan1
	{2580.6448,2827.2197,10.8203,269.3568}, // LVwarehouseclan1
	{2580.5999,2825.5964,10.8203,267.6436}, // LVwarehouseclan1
	{2580.5576,2823.9561,10.8203,269.6093}, // LVwarehouseclan1
	{2577.9795,2824.0508,10.8203,87.4633}, // LVwarehouseclan1
	{2577.9534,2825.5327,10.8203,89.7784}, // LVwarehouseclan1
	{2577.9497,2827.3020,10.8203,89.9701}, // LVwarehouseclan1
	{2577.9719,2829.0103,10.8203,88.3227}, // LVwarehouseclan1
	{2577.9768,2830.7466,10.8203,88.8530}, // LVwarehouseclan1
	{2612.4456,2719.0391,36.5386,1.4883}, // LVwarehouseclan2
	{2613.9126,2719.0151,36.5386,357.0208}, // LVwarehouseclan2
	{2615.7695,2718.9031,36.5386,354.7468}, // LVwarehouseclan2
	{2617.5627,2718.8579,36.5386,356.0649}, // LVwarehouseclan2
	{2619.1990,2718.8992,36.5386,359.7442}, // LVwarehouseclan2
	{2620.9998,2716.3545,36.5386,353.9427}, // LVwarehouseclan2
	{2619.2976,2716.3865,36.5386,357.6220}, // LVwarehouseclan2
	{2617.1077,2716.2991,36.5386,357.0198}, // LVwarehouseclan2
	{2615.3774,2716.3130,36.5386,357.7370}, // LVwarehouseclan2
	{2613.2295,2716.3035,36.5386,359.3227} // LVwarehouseclan2
};




new Float:ClanWar_maddog[][] = {
	{1265.9325,-777.8663,1091.9063,266.8886}, // Maddogsmnsclan1
	{1265.8940,-779.3443,1091.9063,267.2265}, // Maddogsmnsclan1
	{1265.8557,-780.7413,1091.9063,266.6968}, // Maddogsmnsclan1
	{1265.7712,-782.3715,1091.9063,266.2648}, // Maddogsmnsclan1
	{1265.7721,-783.7912,1091.9063,266.7490}, // Maddogsmnsclan1
	{1263.2466,-783.5886,1091.9063,263.6066}, // Maddogsmnsclan1
	{1263.4067,-782.1759,1091.9063,267.5178}, // Maddogsmnsclan1
	{1263.3641,-780.6575,1091.9063,267.0949}, // Maddogsmnsclan1
	{1263.4739,-779.0472,1091.9063,264.8209}, // Maddogsmnsclan1
	{1263.6929,-778.0671,1091.9063,265.8767}, // Maddogsmnsclan1
	{1264.9297,-800.9785,1084.0078,175.9490}, // Maddogsmnsclan2
	{1263.6570,-800.9838,1084.0078,177.4429}, // Maddogsmnsclan2
	{1262.5948,-801.1310,1084.0078,180.1639}, // Maddogsmnsclan2
	{1261.8704,-801.2122,1084.0078,175.3923}, // Maddogsmnsclan2
	{1261.1367,-801.2700,1084.0078,176.1464}, // Maddogsmnsclan2
	{1261.2588,-798.4086,1084.0078,178.4710}, // Maddogsmnsclan2
	{1262.2460,-798.5554,1084.0078,175.3264}, // Maddogsmnsclan2
	{1263.1571,-798.7745,1084.0078,170.5371}, // Maddogsmnsclan2
	{1264.0470,-799.0715,1084.0078,162.8199}, // Maddogsmnsclan2
	{1265.0652,-799.3742,1084.0078,158.2975} // Maddogsmnsclan2
};

new Float:ClanWar_army[][] = {
	{-722.3430,1532.5582,40.1235,87.7342}, // ArmyTerrorclan1
	{-722.4221,1533.9948,40.2066,83.0613}, // ArmyTerrorclan1
	{-722.4257,1535.3320,40.2845,86.8302}, // ArmyTerrorclan1
	{-722.3608,1536.8994,40.3761,86.1228}, // ArmyTerrorclan1
	{-722.4493,1538.7739,40.4847,85.6785}, // ArmyTerrorclan1
	{-719.5137,1538.5421,40.4906,83.7625}, // ArmyTerrorclan1
	{-719.7092,1537.1686,40.4093,85.0188}, // ArmyTerrorclan1
	{-719.7245,1535.6249,40.3194,84.6248}, // ArmyTerrorclan1
	{-719.9990,1534.3092,40.2409,80.1574}, // ArmyTerrorclan1
	{-720.3884,1532.4761,40.1317,75.6900}, // ArmyTerrorclan1
	{-912.1266,1519.9966,25.9141,273.7186}, // ArmyTerrorclan2
	{-912.0173,1518.3673,25.9141,269.2512}, // ArmyTerrorclan2
	{-911.9700,1516.7731,25.9141,268.7428}, // ArmyTerrorclan2
	{-911.8562,1514.9265,25.9141,268.1755}, // ArmyTerrorclan2
	{-911.8393,1513.0604,25.9141,267.7873}, // ArmyTerrorclan2
	{-911.7211,1511.8855,25.9141,268.6357}, // ArmyTerrorclan2
	{-911.7098,1510.2407,25.9141,267.3379}, // ArmyTerrorclan2
	{-913.5555,1509.7773,26.2977,269.9430}, // ArmyTerrorclan2
	{-913.5206,1511.3082,26.2865,270.1756}, // ArmyTerrorclan2
	{-913.4507,1513.0891,26.2642,272.5345} // ArmyTerrorclan2
};

new Float:ClanWar_kss[][] = {
	{-1352.4587,1600.6711,1052.5313,88.3162}, // kickstartstadiumclan1
	{-1352.4783,1602.1571,1052.5313,89.2404}, // kickstartstadiumclan1
	{-1352.4872,1603.5575,1052.5313,84.9968}, // kickstartstadiumclan1
	{-1352.4467,1605.2412,1052.5313,88.7835}, // kickstartstadiumclan1
	{-1352.4136,1607.1493,1052.5313,84.3161}, // kickstartstadiumclan1
	{-1349.8572,1606.9017,1052.5313,84.1213}, // kickstartstadiumclan1
	{-1350.0624,1605.4764,1052.5313,86.0689}, // kickstartstadiumclan1
	{-1350.0747,1603.9714,1052.5313,89.9358}, // kickstartstadiumclan1
	{-1350.0474,1602.3541,1052.5313,88.8278}, // kickstartstadiumclan1
	{-1350.2177,1600.5713,1052.5313,84.3604}, // kickstartstadiumclan1
	{-1493.1538,1632.0874,1052.5313,270.4587}, // kickstartstadiumclan2
	{-1493.1105,1630.9113,1052.5313,267.5288}, // kickstartstadiumclan2
	{-1493.0798,1629.6478,1052.5313,266.3739}, // kickstartstadiumclan2
	{-1492.6541,1628.2388,1052.5313,264.4417}, // kickstartstadiumclan2
	{-1494.2820,1630.3607,1052.5313,265.4643}, // kickstartstadiumclan2
	{-1491.7240,1644.0051,1052.5313,267.2828}, // kickstartstadiumclan2
	{-1491.7000,1642.7450,1052.5313,265.2299}, // kickstartstadiumclan2
	{-1491.6655,1641.3386,1052.5313,267.5128}, // kickstartstadiumclan2
	{-1491.4542,1639.9026,1052.5313,267.5128}, // kickstartstadiumclan2
	{-1493.7655,1642.2865,1052.5313,267.5128} // kickstartstadiumclan2
};

new Float:ClanWar_Calig[][] = {
	{2173.9768,1620.7036,999.9794,272.2361}, // caligulasbasementclan1
	{2174.0825,1619.7378,999.9810,267.7687}, // caligulasbasementclan1
	{2174.1245,1618.4174,999.9766,269.2354}, // caligulasbasementclan1
	{2174.1890,1616.9180,999.9766,267.8143}, // caligulasbasementclan1
	{2174.2358,1615.6188,999.9766,266.7780}, // caligulasbasementclan1
	{2171.7183,1615.6681,999.9766,267.0822}, // caligulasbasementclan1
	{2171.7522,1616.9836,999.9766,268.8997}, // caligulasbasementclan1
	{2171.7856,1618.9315,999.9766,268.5101}, // caligulasbasementclan1
	{2171.8853,1620.6580,999.9794,267.2835}, // caligulasbasementclan1
	{2171.9475,1622.3126,999.9766,265.4370}, // caligulasbasementclan1
	{2216.3970,1554.4196,1004.7188,359.7276}, // caligulasbasementclan2
	{2218.1091,1554.4694,1004.7188,357.9038}, // caligulasbasementclan2
	{2219.6541,1554.7368,1004.7249,357.9600}, // caligulasbasementclan2
	{2221.6274,1554.8599,1004.7229,358.9561}, // caligulasbasementclan2
	{2223.6494,1554.8898,1004.7209,359.0123}, // caligulasbasementclan2
	{2215.0708,1550.5857,1004.7248,358.0724}, // caligulasbasementclan2
	{2216.9387,1550.7300,1004.7188,0.9486}, // caligulasbasementclan2
	{2219.0505,1551.0865,1004.7188,3.8248}, // caligulasbasementclan2
	{2220.8835,1551.1243,1004.7188,358.5543}, // caligulasbasementclan2
	{2222.9900,1551.1788,1004.7188,357.9838} // caligulasbasementclan2
};

new Float:ClanWar_Meat[][] = {
	{958.5619,2159.4749,1011.0303,0.1770}, // meatfacclan1
	{959.5351,2159.5400,1011.0303,356.4732}, // meatfacclan1
	{959.7006,2161.6790,1011.0234,355.2760}, // meatfacclan1
	{958.3759,2161.8745,1011.0234,357.2122}, // meatfacclan1
	{958.4807,2163.9365,1011.0303,357.8951}, // meatfacclan1
	{959.8227,2164.2151,1011.0303,358.8913}, // meatfacclan1
	{959.8138,2166.1868,1011.0234,357.3808}, // meatfacclan1
	{958.2870,2166.2910,1011.0234,359.0036}, // meatfacclan1
	{958.1918,2168.8037,1011.0234,1.1970}, // meatfacclan1
	{959.6872,2168.8428,1011.0234,355.9265}, // meatfacclan1
	{958.5669,2105.2571,1011.0234,93.0605}, // meatfacclan2
	{958.5582,2106.6782,1011.0234,87.4766}, // meatfacclan2
	{958.6584,2108.5020,1011.0234,85.3395}, // meatfacclan2
	{958.5540,2110.3259,1011.0303,89.7824}, // meatfacclan2
	{958.5129,2111.8271,1011.0303,86.3919}, // meatfacclan2
	{961.3224,2111.8662,1011.0234,85.8214}, // meatfacclan2
	{961.5397,2110.2871,1011.0303,88.0710}, // meatfacclan2
	{961.5302,2108.4221,1011.0303,87.1872}, // meatfacclan2
	{961.5148,2106.4102,1011.0234,87.2434}, // meatfacclan2
	{961.3179,2104.5750,1011.0234,85.4196} // meatfacclan2
};

new Float:ClanWar_SFCar[][] = {
	{-1301.3029,494.6999,11.1953,94.2165}, // SFcarrierclan1
	{-1301.3380,496.4466,11.1953,88.9459}, // SFcarrierclan1
	{-1301.3867,498.2962,11.1953,88.6888}, // SFcarrierclan1
	{-1301.5122,500.2177,11.1953,89.9984}, // SFcarrierclan1
	{-1301.5184,502.1829,11.1953,87.8612}, // SFcarrierclan1
	{-1304.9465,502.3110,11.1953,87.8612}, // SFcarrierclan1
	{-1305.0518,500.0212,11.1953,89.4841}, // SFcarrierclan1
	{-1305.3451,497.7041,11.1953,89.4841}, // SFcarrierclan1
	{-1305.5042,495.3939,11.1953,82.9603}, // SFcarrierclan1
	{-1305.7191,493.5800,11.1953,91.7899}, // SFcarrierclan1
	{-1365.1554,507.3232,18.2344,269.4280}, // SFcarrierclan2
	{-1365.1493,505.5633,18.2344,268.5443}, // SFcarrierclan2
	{-1365.0565,503.5504,18.2344,269.8539}, // SFcarrierclan2
	{-1364.8496,501.5110,18.2344,270.5368}, // SFcarrierclan2
	{-1364.8141,500.1662,18.2344,265.2663}, // SFcarrierclan2
	{-1368.3597,500.4146,18.2344,266.5759}, // SFcarrierclan2
	{-1368.3516,501.5840,18.2344,265.0654}, // SFcarrierclan2
	{-1368.2045,503.1646,18.2344,267.0017}, // SFcarrierclan2
	{-1368.1245,505.0658,18.2344,266.7446}, // SFcarrierclan2
	{-1368.0126,506.9152,18.2344,267.1143} // SFcarrierclan2
};


/* Moved to pEar_Achievements.pwn for better management
enum FoCo_Achievement_Info
{
	aid,
	adescription[75],
	ascore
};

new FoCo_Achievements[][FoCo_Achievement_Info] = {
	{0, "N/A", 0},
	{1, "Registering In Game", 2},//comment on end of lines for finished ones
	{2, "Getting started", 4},//
	{3, "Going the wrong way", 5},//
	{4, "Fruitinator", 5},//
	{5, "Sys-Admin Assassin", 10},//
	{6, "More like Dr_Dead", 15},//
	{7, "Lee PeeCock.. Hehe", 2},//
	{8, "All they ever did was help", 5},//
	{9, "Expect a lengthy jail sentence", 2},//
	{10, "Stuck in that ban-appeal section?", 2},//
	{11, "I'll have my peepz on you!", 2},//
	{12, "Manhunt.. Suitable name", 2},//
	{13, "Agent 47", 2},
	{14, "Baby Killing Machine", 2},//
	{15, "Junior Killing Machine", 2},//
	{16, "Killing Machine", 4},//
	{17, "One Man Army!", 4},//
	{18, "Fist Pump", 4},//
	{19, "Backstab", 4},//
	{20, "Chainsaw Massacre", 4},//
	{21, "My gun might be small, but you're still dead", 4},//
	{22, "Ratatat", 4},//
	{23, "Bring out Bertha", 2},//
	{24, "Serious Firepower", 2},//
	{25, "Marksman", 5},
	{26, "C4 Yourself", 5},
	{27, "Flower Power", 5},
	{28, "Rapist", 5},//
	{29, "Compensating for something?", 5},//
	{30, "Pyromaniac", 5},//
	{31, "al-Qaida", 5},//
	{32, "Vehicular Manslaughter", 5},//
	{33, "Pearl Harbour", 5},//
	{34, "One is not enough", 5},//
	{35, "Getting somewhere", 5},//
	{36, "Newborn Killer", 5},//
	{37, "Soldier", 5},//
	{38, "Exterminator", 5},
	{39, "Executioner", 2},
	{40, "Mass Murderer", 7},
	{41, "Professional Hitman", 4),//
	{42, "Gotta kill them all", 4),//
	{43, "One to rule them all", 4),//
	{44, "First deal", 4),//
	{45, "Karma's a bitch", 4),//
	{46, "You're not going anywhere", 4),//
	{47, "A real pain in the ass", 4),//
	{48, "Killed Osama", 4),//
	{49, "Eye for an eye", 4),//
	{50, "I'm more than what meets the eye", 4),//
	{51, "Living Legend", 4),//
	{52, "Lagger", 4),//
	{53, "Hacker", 4),//
	{54, "1337", 4),//
	{55, "$k", 4),//
	{56, "1Ok", 4),//
	{57, "$*4k", 4),//
	{58, "$0k", 4),//
	{59, "I've got more kills than you", 4),//
	{60, "Wealthy", 4),//
	{61, "Rich", 4),//
	{62, "Wanted", 4),//
	{63, "Most Wanted", 4),//
	{64, "Very Important Person", 4),//
	{65, "Turfwar", 4),//
	{66, "Say hello to my little friend!", 4),//
	{67, "One hour down, many to go", 4),//
	{68, "Still new", 4),//
	{69, "Now we're talking", 4),//
	{70, "Life is a game", 4),//
	{71, "But mom, I don't want to go outside", 4),//
	{72, "Real life, where can you buy that?", 4),//
	{73, "I got married to my PC. that's not weird, right?", 4),//
	{74, "Virtual Life > Real Life", 4),//
	{75, "Never Alone", 4),//
	{76, "Pimp my ride", 4),//
	{77, "Join in on the fun", 4),//
	{78, "Prison Break", 4),//
	{79, "Call in the coroner", 4),//
	{80, "Bullets flying all over, but not on me", 4),//
	{81, "Heavyweight Champion", 4),//
	{82, "Thunderbirds are go!", 4),//
	{83, "The one and only", 4),//
	{84, "Second is simply not good enough", 4),//
	{85, "All good things go by three", 4),//
	{86, "leet", 4),//
	{87, "Vrom Vrom", 4),//
	{88, "Vrom Vrom Bling Bling", 4),//
	{89, "My precious!", 4),//
	{90, "No care for you", 4),//
	{91, "First came, first served", 4),//
	{92, "I was lagging", 4),//
	{93, "I'm on fire", 4),//
	{94, "Do you feel lucky, punk?", 4),//
	{95, "I do this for a living", 4),//
	{96, "Helpme's is what I do", 4),//
	{97, "I got the power, pow!", 4),//
	{98, "Ban Incorporated", 4),//
	{99, "Fruit Smoothie", 4),//
	{100, "Giving a helping hand", 4),//
	{101, "Nothing wrong in asking", 4)//
	
};

*/
/*
*Vehicle Name & Mod Info
*/

/*enum VehCompList
{
	VehID,
	NOS, 
	Wheels, 
	Hydraulics,
	Lights,
	FBumper,
	RBumper,
	SideSkirts,
	Hood,
	RoofScoop,
	Spoiler,
	Exhaust
};
new VehBackupArray[MAX_PLAYERS][VehCompList];

enum WheelInfo
{
	mID,
	Name[56],
	Price
};
new ModWheelArray[17][WheelInfo] =
{
	{1079, 	"Wheel Arch Angels Type 1", 10},
	{1075, 	"Wheel Arch Angels Type 2", 10},
	{1074, 	"Wheel Arch Angels Type 3", 10},
	{1081, 	"Wheel Arch Angels Type 4", 10},
	{1080, 	"Wheel Arch Angels Type 5", 10},
	{1073, 	"Wheel Arch Angels Type 6", 10},
	{1077, 	"Loco' Low Co.  Type 1", 20},
	{1083, 	"Loco' Low Co. Type 2", 20},
	{1078, 	"Loco' Low Co. Type 3", 20},
	{1076, 	"Loco' Low Co. Type 4", 20},
	{1084, 	"Loco' Low Co. Type 5", 20},
	{1082, 	"Transfender Type 1", 50},
	{1085, 	"Transfender Type 2", 50},
	{1096, 	"Transfender Type 3", 50},
	{1097, 	"Transfender Type 4", 50},
	{1098, 	"Transfender Type 5", 50},
	{1025, 	"Off Road", 20}
};
enum ModInfo
{
	mID,
	Name[56],
	Price
};
new ModInfoArray[194][ModInfo] =
{
	{1000, "Pro", 45},
	{1001, "Win", 45},
	{1002, "Drag", 45},
	{1003, "Alpha", 45},
	{1004, "Champ Scoop", 45},
	{1005, "Fury Scoop", 45},
	{1006, "Roof Scoop", 45},
	{1007, "Sideskirt", 40},
	{1008, "5 Cans of Nitrous", 100},
	{1009, "2 Cans of Nitrous", 150},
	{1010, "10 Cans of Nitrous", 200},
	{1011, "Race Scoop", 45},
	{1012, "Worx Scoop", 45},
	{1013, "Round Fog", 50},
	{1014, "Champ", 85},
	{1015, "Race", 85},
	{1016, "Worx", 85},
	{1017, "Sideskirt", 40},
	{1018, "Upswept", 60},
	{1019, "Twin", 60},
	{1020, "Large", 60},
	{1021, "Medium", 60},
	{1022, "Small", 60},
	{1023, "Fury", 85},
	{1024, "Square Fog", 50},
	{1025, "Off Road", 50},
	{1026, "Alien", 40},
	{1027, "Alien", 40},
	{1028, "Alien", 60},
	{1029, "X-Flow", 60},
	{1030, "X-Flow", 40},
	{1031, "X-Flow", 40},
	{1032, "Alien Roof Vent", 45},
	{1033, "X-Flow Roof Vent", 45},
	{1034, "Alien", 60},
	{1035, "X-Flow Roof Vent", 45},
	{1036, "Alien", 40},
	{1037, "X-Flow", 60},
	{1038, "Alien Roof Vent", 45},
	{1039, "X-Flow", 40},
	{1040, "Alien", 40},
	{1041, "X-Flow", 40},
	{1042, "Chrome", 40},
	{1043, "Slamin", 60},
	{1044, "Chrome", 60},
	{1045, "X-Flow", 60},
	{1046, "Alien", 60},
	{1047, "Alien", 40},
	{1048, "X-Flow", 40},
	{1049, "Alien", 85},
	{1050, "X-Flow", 85},
	{1051, "Alien", 40},
	{1052, "X-Flow", 40},
	{1053, "X-Flow", 80},
	{1054, "Alien", 80},
	{1055, "Alien", 80},
	{1056, "Alien", 40},
	{1057, "X-Flow", 40},
	{1058, "Alien", 85},
	{1059, "X-Flow", 60},
	{1060, "X-Flow", 85},
	{1061, "X-Flow", 60},
	{1062, "Alien", 40},
	{1063, "X-Flow", 40},
	{1064, "Alien", 60},
	{1065, "Alien", 60},
	{1066, "X-Flow", 60},
	{1067, "Alien", 80},
	{1068, "X-Flow", 80},
	{1069, "Alien", 60},
	{1070, "X-Flow", 60},
	{1071, "Alien", 60},
	{1072, "X-Flow", 60},
	{1073, "Invalid", 0},
	{1074, "Invalid", 0},
	{1075, "Invalid", 0},
	{1076, "Invalid", 0},
	{1077, "Invalid", 0},
	{1078, "Invalid", 0},
	{1079, "Invalid", 0},
	{1080, "Invalid", 0},
	{1081, "Invalid", 0},
	{1082, "Invalid", 0},
	{1083, "Invalid", 0},
	{1084, "Invalid", 0},
	{1085, "Invalid", 0},
	{1086, "Stereo", 100},
	{1087, "Hydraulics", 500},
	{1088, "Alien", 80},
	{1089,  "X-Flow", 60},
	{1090, "Alien", 60},
	{1091, "X-Flow", 80},
	{1092, "Alien", 60},
	{1093, "X-Flow", 60},
	{1094, "Alien", 60},
	{1095, "X-Flow", 60},
	{1096, "Ahab", 70},
	{1097, "Virtual", 70},
	{1098, "Access", 70},
	{1099, "Chrome", 60},
	{1100, "Chrome Grill", 70},
	{1101, "Chrome Flames", 60},
	{1102, "Chrome Strip", 60},
	{1103, "Convertible", 80},
	{1104, "Chrome", 60},
	{1105, "Slamin", 60},
	{1106, "Chrome Arches", 60},
	{1107, "Chrome Strip", 60},
	{1108, "Chrome Strip", 60},
	{1109, "Bullbars Chrome", 70},
	{1110, "Bullbars Slamin", 70},
	{1111, "Front Sign? Little Sign?", 50},
	{1112, "Front Sign? Little Sign?", 50},
	{1113, "Chrome", 60},
	{1114, "Slamin", 60},
	{1115, "Bullbars Chrome", 70},
	{1116, "Bullbars Slamin", 70},
	{1117, "Bumper Chrome", 70},
	{1118, "Chrome Trim", 60},
	{1119, "Wheelcovers", 60},
	{1120, "Chrome Trim", 60},
	{1121, "Wheelcovers", 60},
	{1122, "Chrome Flames", 60},
	{1123, "Bullbars Bullbar Chrome Bars", 70},
	{1124, "Chrome Arches", 60},
	{1125, "Bullbar Chrome Lights", 70},
	{1126, "Chrome Exhaust", 60},
	{1127, "Slamin Exhaust", 60},
	{1128, "Vinyl Hardtop", 80},
	{1129, "Chrome", 60},
	{1130, "Hardtop", 80},
	{1131, "Softtop", 80},
	{1132, "Slamin", 60},
	{1133, "Chrome Strip", 60},
	{1134, "Chrome Strip", 60},
	{1135, "Slamin", 60},
	{1136, "Chrome", 60},
	{1137, "Chrome Strip", 60},
	{1138, "Alien", 85},
	{1139, "X-Flow", 85},
	{1140, "Bumper X-Flow", 70},
	{1141, "Bumper Alien", 70},
	{1142, "Oval Vents", 70},
	{1143, "Oval Vents", 70},
	{1144, "Square Vents", 70},
	{1145, "Square Vents", 70},
	{1146, "X-Flow", 85},
	{1147, "Alien", 85},
	{1148, "X-Flow", 70},
	{1149, "Alien", 70},
	{1150, "Alien", 70},
	{1151, "X-Flow", 70},
	{1152, "X-Flow", 70},
	{1153, "Alien", 70},
	{1154, "Alien", 70},
	{1155, "Alien", 70},
	{1156, "X-Flow", 70},
	{1157, "X-Flow", 70},
	{1158, "X-Flow", 85},
	{1159, "Alien", 70},
	{1160, "Alien", 70},
	{1161, "X-Flow", 70},
	{1162, "Alien", 85},
	{1163, "X-Flow", 85},
	{1164, "Alien", 85},
	{1165, "X-Flow", 70},
	{1166, "Alien", 70},
	{1167, "X-Flow", 70},
	{1168, "Alien", 70},
	{1169, "Alien", 70},
	{1170, "X-Flow", 70},
	{1171, "Alien", 70},
	{1172, "X-Flow", 70},
	{1173, "X-Flow", 70},
	{1174, "Chrome", 70},
	{1175, "Slamin", 70},
	{1176, "Chrome", 70},
	{1177, "Slamin", 70},
	{1178, "Slamin", 70},
	{1179, "Chrome", 70},
	{1180, "Chrome", 70},
	{1181, "Slamin", 70},
	{1182, "Chrome", 70},
	{1183, "Slamin", 70},
	{1184, "Chrome", 70},
	{1185, "Slamin", 70},
	{1186, "Slamin", 70},
	{1187, "Chrome", 70},
	{1188, "Slamin", 70},
	{1189, "Chrome", 70},
	{1190, "Slamin", 70},
	{1191, "Chrome", 70},
	{1192, "Chrome", 70},
	{1193, "Slamin", 70}
};*/
enum VehInfo
{
	Name[128],
	Lights1,
	Lights2,
	FBumper1,
	FBumper2,
	RBumper1,
	RBumper2,
	SideSkirts1,
	SideSkirts2,
	Hood1,
	Hood2,
	RoofScoop1,
	RoofScoop2,
	Spoiler1,
	Spoiler2,
	Exhaust1,
	Exhaust2
};
new VehNames[213][VehInfo] = 
{	
	{"Landstalker", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{"Bravura",1013, 0, 0, 0, 0, 0, 1007, 0, 1005, 1004, 1006, 0, 1001, 1003, 1020, 1019},
	{"Buffalo", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Linerunner", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Perrenial", 1013 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 0 , 0 , 0 , 0 , 1002 , 1016 , 1020 , 1021 },
	{"Sentinel", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1001 , 1014 , 1020 , 1021 },
	{"Dumper", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Firetruck", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Trashmaster", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Stretch", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Manana",1013 , 1024 , 0 , 0 , 0 , 0 , 1007 , 0 , 0 , 0 , 0 , 0 , 1001 , 1023 , 1020 , 1021 },
	{"Infernus", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Voodoo", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Pony", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Mule", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Cheetah", 0 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 0 , 0 , 0 , 0 , 1001 , 1023 , 1019 , 1018 },
	{"Ambulance", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Leviathan", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Moonbeam" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1006 , 0 , 1002 , 1016 , 1020 , 1021 },
	{"Esperanto", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Taxi", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1005 , 1004 , 0 , 0 , 1001 , 1003 , 1021 , 1019 },
	{"Washington", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1014 , 1023 , 1020 , 1021 },
	{"Bobcat" , 1013 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1020 , 1021 },
	{"Mr Whoopee", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"BF Injection" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Hunter", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Premier", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1005 , 1004 , 1006 , 0 , 1001 , 1003 , 1021 , 1019 },
	{"Enforcer", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Securicar", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Banshee", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Predator", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Bus", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Rhino", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Barracks", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Hotknife", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Trailer 1",  0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Previon", 1013 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1006 , 0 , 1001 , 1003 , 1020 , 1021 },
	{"Coach", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Cabbie", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Stallion", 1013 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1001 , 1023 , 0 , 0 },
	{"Rumpo", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"RC Bandit", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Romero", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Packer", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Monster", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Admiral", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Squalo", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Seasparrow", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Pizzaboy", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Tram", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Trailer 2",  0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Turismo", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Speeder", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Reefer", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Tropic",  0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Flatbed",  0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Yankee", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Caddy", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Solair", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Berkley's RC Van", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Skimmer", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"PCJ-600", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Faggio", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Freeway", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"RC Baron", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"RC Raider", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Glendale", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Oceanic", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Sanchez", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Sparrow", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Patriot", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Quad", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Coastguard", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Dinghy", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Hermes", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Sabre", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Rustler", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"ZR-350", 0 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 0 , 0 , 1006 , 0 , 0 , 0 , 1020 , 1018},
	{"Walton", 1013 , 1024 , 0 , 0 , 0 , 0 , 0 , 0 , 1005 , 1004 , 0 , 0 , 0 , 0 , 1020 , 1021 },
	{"Regina", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Comet", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"BMX", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Burrito", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Camper", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Marquis", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Baggage", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Dozer", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Maverick", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"News Chopper", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Rancher", 1013 , 1024 , 0 , 0 , 0 , 0 , 0 , 0 , 1005 , 1004 , 1006 , 0 , 1002 , 1016 , 1020 , 1019 },
	{"FBI Rancher", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Virgo", 0 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 0 , 0 , 0 , 0 , 1014 , 1023 , 1020 , 1018 },
	{"Greenwood", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1005 , 1004 , 1006 , 0 , 1016 , 1000 , 0 , 0 },
	{"Jetmax", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Hotring", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Sandking", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Blista Compact", 0 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 1011 , 0 , 1006 , 0 , 1001 , 0 , 1020 , 0 },
	{"Police Maverick", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Boxville" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Benson", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Mesa", 1013 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1020 , 0 },
	{"RC Goblin", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Hotring Racer A", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Hotring Racer B", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Bloodring Banger", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Rancher",1013 , 1024 , 0 , 0 , 0 , 0 , 0 , 0 , 1005 , 1004 , 1006 , 0 , 1002 , 1016 , 1020 , 1019 },
	{"Super GT", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Elegant", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Journey", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Bike", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Mountain Bike", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Beagle", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Cropdust", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Stunt", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Tanker" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Roadtrain" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Nebula", 0 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 1004 , 0 , 0 , 0 , 1002 , 0 , 1020 , 0 },
	{"Majestic", 0 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 0 , 0 , 0 , 0 , 1002 , 1023 , 1020 , 1019 },
	{"Buccaneer", 1013 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 1005 , 0 , 1006 , 0 , 1001 , 1023 , 1020 , 1018 },
	{"Shamal", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Hydra", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"FCR-900", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"NRG-500", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"HPV1000", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Cement Truck", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Tow Truck", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Fortune" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Cadrona", 0 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 0 , 0 , 0 , 0 , 1001 , 1014 , 1020 , 1021 },
	{"FBI Truck", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Willard" , 0 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 1012 , 1011 , 1006 , 0 , 1001 , 1023 , 1020 , 1019 },
	{"Forklift", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Tractor", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Combine", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Feltzer" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Remington", 0 , 0 , 1100 , 0 , 1180 , 0 , 1122 , 1106 , 0 , 0 , 0 , 0 , 0 , 0 , 1126 , 1127 },
	{"Slamvan", 0 , 0 , 1115 , 1116 , 1109 , 1110 , 1118 , 1119 , 0 , 0 , 0 , 0 , 0 , 0 , 1113 , 1114 },
	{"Blade", 0 , 0 , 1182 , 1181 , 1184 , 1183 , 1108 , 0 , 0 , 0 , 1128 , 1103 , 0 , 0 , 1104 , 1105 },
	{"Freight", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Streak", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Vortex", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Vincent", 1024 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 1004 , 0 , 1006 , 0 , 1001 , 1023 , 1020 , 1019 },
	{"Bullet", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Clover", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1014 , 1015 , 1020 , 1019 },
	{"Sadler", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Firetruck LA", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Hustler", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Intruder", 1024 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 1004 , 0 , 1006 , 0 , 1001 , 1002 , 1019 , 1018 },
	{"Primo", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1016 , 1003 , 1020 , 1018 },
	{"Cargobob", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Tampa", 0 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 1012 , 1011 , 0 , 0 , 1001 , 1023 , 1020 , 1018 },
	{"Sunrise" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1005 , 1004 , 1006 , 0 , 1001 , 1023 , 1020 , 1019 },
	{"Merit", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1005 , 0 , 1006 , 0 , 1002 , 1023 , 1020 , 1019 },
	{"Utility" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Nevada", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Yosemite" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Windsor", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Monster A", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Monster B" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Uranus" , 0 , 0 , 1166 , 1165 , 1168 , 1167 , 1090 , 1093 , 0 , 0 , 1088 , 1091 , 1164 , 1163 , 1092 , 1089 },
	{"Jester", 0 , 0 , 1160 , 1173 , 1159 , 1161 , 1069 , 1070 , 0 , 0 , 1067 , 1068 , 1162 , 1158 , 1065 , 1066 },
	{"Sultan", 0 , 0 , 1169 , 1170 , 1141 , 1140 , 1026 , 1031 , 0 , 0 , 1032 , 1033 , 1138 , 1139 , 1028 , 1029 },
	{"Stratum", 0 , 0 , 1155 , 1157 , 1154 , 1156 , 1056 , 1057 , 0 , 0 , 1055 , 1061 , 1058 , 1060 , 1064 , 1059 },
	{"Elegy", 0 , 0 , 0 , 1171 , 0 , 1149 , 0 , 1036 , 0 , 0 , 0 , 1038 , 0 , 1147 , 0 , 1034 },
	{"Raindance", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"RC Tiger" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Flash", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Tahoma", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Savanna", 0 , 0 , 1189 , 1188 , 1187 , 1186 , 1133 , 0 , 0 , 0 , 1130 , 1131 , 0 , 0 , 1129 , 1132 },
	{"Bandito", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Freight Flat", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Streak Carriage", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Kart", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Mower", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Duneride" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Sweeper" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Broadway", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Tornado",  0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"AT-400", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"DFT-30", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Huntley", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Stafford" , 0 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 0 , 0 , 1006 , 0 , 1001 , 1023 , 1020 , 1018 },
	{"BF-400", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Newsvan" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Tug", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Trailer 2" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Emperor", 1013 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 0 , 0 , 1006 , 0 , 1001 , 1023 , 1020 , 1019 },
	{"Wayfarer", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Euros", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Hotdog", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Club", 1013 , 1024 , 0 , 0 , 0 , 0 , 1007 , 0 , 1005 , 1004 , 1006 , 0 , 1016 , 1000 , 1020 , 1018 },
	{"Freight Carriage", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Trailer 3", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Andromada" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Dodo", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"RC Cam" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Launch", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Police Car (LSPD)", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Police Car (LVPD)", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Police Car (SFPD)", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Police Ranger", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Picador",1013 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 1005 , 1004 , 1006 , 0 , 0 , 0 , 1020 , 1018 },
	{"S.W.A.T.Van", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{"Alpha" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"PCJ-600", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Phoenix", 1024 , 0 , 0 , 0 , 0 , 0 , 1007 , 0 , 0 , 0 , 1006 , 0 , 1001 , 1023 , 1020 , 1018 },
	{"Glendale", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Sadler", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Luggage Trailer A", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Luggage Trailer B" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Stair Trailer", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Boxville", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Farm Plow", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 },
	{"Utility Trailer", 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 }
};
/*
* Weapon Names
*/
enum WeapInfo
{
	WeapName[30],
	weapslot,
	WeapType, //-1 = Unavailable, 0 = Primary, 1 = Secondary, 2 = Tactical, 3 = Melee
	AcquiType, //Check acquisition defines
	AcquiValue
};
new WeapNames[][WeapInfo] = {
	{"Unarmed (Fist)", 0, 3, ACQUISITION_AUTO, 0}, // 0
	{"Brass Knuckles", 0, 3, ACQUISITION_SCORE, }, // 1
	{"Golf Club", 1, 3, }, // 2
	{"Night Stick", 1, 3}, // 3
	{"Knife",1, 3, ACQUISITION_SCORE, }, // 4
	{"Baseball Bat",1, 3, ACQUISITION_ACHI, 2}, // 5
	{"Shovel",1, 3}, // 6
	{"Pool Cue",1, 3}, // 7
	{"Katana",1, 3, ACQUISITION_VIP, 0}, // 8
	{"Chainsaw",1, 3}, // 9
	{"Purple Dildo", 10, 3, ACQUISITION_ACHI, 7}, // 10 Earnt on killing an admin
	{"Big White Vibrator",10, 3}, // 11
	{"Medium White Vibrator", 10, 3}, // 12
	{"Small White Vibrator", 10, 3, ACQUISITION_SCORE, }, // 13
	{"Flowers", 10, 3}, // 14
	{"Cane", 10, 3}, // 15
	{"Grenade", 8, 2, ACQUISITION_SCORE,}, // 16
	{"Teargas", 8, -1, ACQUISITION_AUTO, 0}, // 17
	{"Molotov", 8, 2}, // 18
	{" ", 0, -1, ACQUISITION_AUTO, 0}, // 19
	{" ", 0, -1, ACQUISITION_AUTO, 0}, // 20
	{" ", 0, -1, ACQUISITION_AUTO, 0}, // 21
	{"Colt 45", 2, 1, ACQUISITION_SCORE,}, // 22
	{"Colt 45(Silenced)", 2, 1, ACQUISITION_VIP, 0}, // 23
	{"Deagle", 2, 1, ACQUISITION_AUTO, 0}, // 24
	{"Normal Shotgun", 3, 0, ACQUISITION_SCORE,}, // 25
	{"Sawnoff Shotgun", 3, 0}, // 26
	{"Combat Shotgun", 3, 0, ACQUISITION_SCORE,}, // 27
	{"Micro SMG", 4, 1, ACQUISITION_SCORE,}, // 28
	{"MP5", 4, 0, ACQUISITION_SCORE,}, // 29
	{"AK47", 5, 0, ACQUISITION_SCORE,}, // 30
	{"M4", 5, 0, ACQUISITION_SCORE,}, // 31
	{"Tec9", 4, 1, }, // 32
	{"Country Rifle", 6, 0}, // 33
	{"Sniper Rifle", 6, 0}, // 34
	{"Rocket Launcher", 7}, // 35
	{"Heat-Seeking Rocket Launcher", 7, -1, ACQUISITION_AUTO, 0}, // 36
	{"Flamethrower", 7}, // 37
	{"Minigun", 7, -1, ACQUISITION_AUTO, 0}, // 38
	{"Satchel Charge", 8, -1, ACQUISITION_AUTO, 0}, // 39
	{"Detonator", 12, -1, ACQUISITION_AUTO, 0}, // 40
	{"Spray Can", 9, -1, ACQUISITION_AUTO, 0}, // 41
	{"Fire Extinguisher", 9, -1, ACQUISITION_AUTO, 0}, // 42
	{"Camera", 9, -1, ACQUISITION_AUTO, 0}, // 43
	{"Night Vision Goggles", 11, -1, ACQUISITION_AUTO, 0}, // 44
	{"Infrared Vision Goggles", 11, -1, ACQUISITION_AUTO, 0}, // 45
	{"Parachute", 11, -1, ACQUISITION_AUTO, 0}, // 46
	{"Fake Pistol", 0, 3, ACQUISITION_SCORE}, // 47,
	{"Unknown", 0, 3, ACQUISITION_SCORE}, // 48
	{"Vehicle", 0, 3, ACQUISITION_SCORE}, // 49
	{"Helicopter Blades", 0, 3, ACQUISITION_SCORE}, // 50
	{"Explosion", 0, 3, ACQUISITION_SCORE}, // 51
	{"Unknown", 0, 3, ACQUISITION_SCORE}, // 52
	{"Drowned", 0, 3, ACQUISITION_SCORE}, // 53
	{"Splat", 0, 3, ACQUISITION_SCORE} // 54
};

new PeopleBlocking[MAX_PLAYERS][MAX_BLOCK]; // PM ID Block Array
new MessageOfTheDay[512]; // Message of the day, CMD:motd
new GlobalChatEnabled = 1;
new rules_text[5000]; // The rule string for the MSG BOX
new ahide[MAX_PLAYERS] = 0; // Admin hide from /admins
new LoginCMDVar[MAX_PLAYERS] = 1;
new pmwarned[MAX_PLAYERS] = 0;
new camera[MAX_PLAYERS] = 0;

/* CEM */

enum Custom_event_maker
{
 WeaponID,
 WeaponID2,
 WeaponID3,
 WeaponID4,
 MaxPlayers,
 Rejoinable,
 Gamemode,
 Interior,
 SkinA,
 SkinB,
 CEM_VehID
};


new LastPMID[MAX_PLAYERS] = -1;	

/* *** */
new Timer:CountDownTimer;
new Timer:DeathCamTimer[MAX_PLAYERS];

	/* Zone Names Array */

enum SAZONE_MAIN { //Betamaster
		SAZONE_NAME[28],
		Float:SAZONE_AREA[6]
};

new const gSAZones[][SAZONE_MAIN] = {  // Majority of names and area coordinates adopted from Mabako's 'Zones Script' v0.2
	//	NAME                            AREA (Xmin,Ymin,Zmin,Xmax,Ymax,Zmax)
	{"The Big Ear",	                {-410.00,1403.30,-3.00,-137.90,1681.20,200.00}},
	{"Aldea Malvada",               {-1372.10,2498.50,0.00,-1277.50,2615.30,200.00}},
	{"Angel Pine",                  {-2324.90,-2584.20,-6.10,-1964.20,-2212.10,200.00}},
	{"Arco del Oeste",              {-901.10,2221.80,0.00,-592.00,2571.90,200.00}},
	{"Avispa Country Club",         {-2646.40,-355.40,0.00,-2270.00,-222.50,200.00}},
	{"Avispa Country Club",         {-2831.80,-430.20,-6.10,-2646.40,-222.50,200.00}},
	{"Avispa Country Club",         {-2361.50,-417.10,0.00,-2270.00,-355.40,200.00}},
	{"Avispa Country Club",         {-2667.80,-302.10,-28.80,-2646.40,-262.30,71.10}},
	{"Avispa Country Club",         {-2470.00,-355.40,0.00,-2270.00,-318.40,46.10}},
	{"Avispa Country Club",         {-2550.00,-355.40,0.00,-2470.00,-318.40,39.70}},
	{"Back o Beyond",               {-1166.90,-2641.10,0.00,-321.70,-1856.00,200.00}},
	{"Battery Point",               {-2741.00,1268.40,-4.50,-2533.00,1490.40,200.00}},
	{"Bayside",                     {-2741.00,2175.10,0.00,-2353.10,2722.70,200.00}},
	{"Bayside Marina",              {-2353.10,2275.70,0.00,-2153.10,2475.70,200.00}},
	{"Beacon Hill",                 {-399.60,-1075.50,-1.40,-319.00,-977.50,198.50}},
	{"Blackfield",                  {964.30,1203.20,-89.00,1197.30,1403.20,110.90}},
	{"Blackfield",                  {964.30,1403.20,-89.00,1197.30,1726.20,110.90}},
	{"Blackfield Chapel",           {1375.60,596.30,-89.00,1558.00,823.20,110.90}},
	{"Blackfield Chapel",           {1325.60,596.30,-89.00,1375.60,795.00,110.90}},
	{"Blackfield Intersection",     {1197.30,1044.60,-89.00,1277.00,1163.30,110.90}},
	{"Blackfield Intersection",     {1166.50,795.00,-89.00,1375.60,1044.60,110.90}},
	{"Blackfield Intersection",     {1277.00,1044.60,-89.00,1315.30,1087.60,110.90}},
	{"Blackfield Intersection",     {1375.60,823.20,-89.00,1457.30,919.40,110.90}},
	{"Blueberry",                   {104.50,-220.10,2.30,349.60,152.20,200.00}},
	{"Blueberry",                   {19.60,-404.10,3.80,349.60,-220.10,200.00}},
	{"Blueberry Acres",             {-319.60,-220.10,0.00,104.50,293.30,200.00}},
	{"Caligula's Palace",           {2087.30,1543.20,-89.00,2437.30,1703.20,110.90}},
	{"Caligula's Palace",           {2137.40,1703.20,-89.00,2437.30,1783.20,110.90}},
	{"Calton Heights",              {-2274.10,744.10,-6.10,-1982.30,1358.90,200.00}},
	{"Chinatown",                   {-2274.10,578.30,-7.60,-2078.60,744.10,200.00}},
	{"City Hall",                   {-2867.80,277.40,-9.10,-2593.40,458.40,200.00}},
	{"Come-A-Lot",                  {2087.30,943.20,-89.00,2623.10,1203.20,110.90}},
	{"Commerce",                    {1323.90,-1842.20,-89.00,1701.90,-1722.20,110.90}},
	{"Commerce",                    {1323.90,-1722.20,-89.00,1440.90,-1577.50,110.90}},
	{"Commerce",                    {1370.80,-1577.50,-89.00,1463.90,-1384.90,110.90}},
	{"Commerce",                    {1463.90,-1577.50,-89.00,1667.90,-1430.80,110.90}},
	{"Commerce",                    {1583.50,-1722.20,-89.00,1758.90,-1577.50,110.90}},
	{"Commerce",                    {1667.90,-1577.50,-89.00,1812.60,-1430.80,110.90}},
	{"Conference Center",           {1046.10,-1804.20,-89.00,1323.90,-1722.20,110.90}},
	{"Conference Center",           {1073.20,-1842.20,-89.00,1323.90,-1804.20,110.90}},
	{"Cranberry Station",           {-2007.80,56.30,0.00,-1922.00,224.70,100.00}},
	{"Creek",                       {2749.90,1937.20,-89.00,2921.60,2669.70,110.90}},
	{"Dillimore",                   {580.70,-674.80,-9.50,861.00,-404.70,200.00}},
	{"Doherty",                     {-2270.00,-324.10,-0.00,-1794.90,-222.50,200.00}},
	{"Doherty",                     {-2173.00,-222.50,-0.00,-1794.90,265.20,200.00}},
	{"Downtown",                    {-1982.30,744.10,-6.10,-1871.70,1274.20,200.00}},
	{"Downtown",                    {-1871.70,1176.40,-4.50,-1620.30,1274.20,200.00}},
	{"Downtown",                    {-1700.00,744.20,-6.10,-1580.00,1176.50,200.00}},
	{"Downtown",                    {-1580.00,744.20,-6.10,-1499.80,1025.90,200.00}},
	{"Downtown",                    {-2078.60,578.30,-7.60,-1499.80,744.20,200.00}},
	{"Downtown",                    {-1993.20,265.20,-9.10,-1794.90,578.30,200.00}},
	{"Downtown Los Santos",         {1463.90,-1430.80,-89.00,1724.70,-1290.80,110.90}},
	{"Downtown Los Santos",         {1724.70,-1430.80,-89.00,1812.60,-1250.90,110.90}},
	{"Downtown Los Santos",         {1463.90,-1290.80,-89.00,1724.70,-1150.80,110.90}},
	{"Downtown Los Santos",         {1370.80,-1384.90,-89.00,1463.90,-1170.80,110.90}},
	{"Downtown Los Santos",         {1724.70,-1250.90,-89.00,1812.60,-1150.80,110.90}},
	{"Downtown Los Santos",         {1370.80,-1170.80,-89.00,1463.90,-1130.80,110.90}},
	{"Downtown Los Santos",         {1378.30,-1130.80,-89.00,1463.90,-1026.30,110.90}},
	{"Downtown Los Santos",         {1391.00,-1026.30,-89.00,1463.90,-926.90,110.90}},
	{"Downtown Los Santos",         {1507.50,-1385.20,110.90,1582.50,-1325.30,335.90}},
	{"East Beach",                  {2632.80,-1852.80,-89.00,2959.30,-1668.10,110.90}},
	{"East Beach",                  {2632.80,-1668.10,-89.00,2747.70,-1393.40,110.90}},
	{"East Beach",                  {2747.70,-1668.10,-89.00,2959.30,-1498.60,110.90}},
	{"East Beach",                  {2747.70,-1498.60,-89.00,2959.30,-1120.00,110.90}},
	{"East Los Santos",             {2421.00,-1628.50,-89.00,2632.80,-1454.30,110.90}},
	{"East Los Santos",             {2222.50,-1628.50,-89.00,2421.00,-1494.00,110.90}},
	{"East Los Santos",             {2266.20,-1494.00,-89.00,2381.60,-1372.00,110.90}},
	{"East Los Santos",             {2381.60,-1494.00,-89.00,2421.00,-1454.30,110.90}},
	{"East Los Santos",             {2281.40,-1372.00,-89.00,2381.60,-1135.00,110.90}},
	{"East Los Santos",             {2381.60,-1454.30,-89.00,2462.10,-1135.00,110.90}},
	{"East Los Santos",             {2462.10,-1454.30,-89.00,2581.70,-1135.00,110.90}},
	{"Easter Basin",                {-1794.90,249.90,-9.10,-1242.90,578.30,200.00}},
	{"Easter Basin",                {-1794.90,-50.00,-0.00,-1499.80,249.90,200.00}},
	{"Easter Bay Airport",          {-1499.80,-50.00,-0.00,-1242.90,249.90,200.00}},
	{"Easter Bay Airport",          {-1794.90,-730.10,-3.00,-1213.90,-50.00,200.00}},
	{"Easter Bay Airport",          {-1213.90,-730.10,0.00,-1132.80,-50.00,200.00}},
	{"Easter Bay Airport",          {-1242.90,-50.00,0.00,-1213.90,578.30,200.00}},
	{"Easter Bay Airport",          {-1213.90,-50.00,-4.50,-947.90,578.30,200.00}},
	{"Easter Bay Airport",          {-1315.40,-405.30,15.40,-1264.40,-209.50,25.40}},
	{"Easter Bay Airport",          {-1354.30,-287.30,15.40,-1315.40,-209.50,25.40}},
	{"Easter Bay Airport",          {-1490.30,-209.50,15.40,-1264.40,-148.30,25.40}},
	{"Easter Bay Chemicals",        {-1132.80,-768.00,0.00,-956.40,-578.10,200.00}},
	{"Easter Bay Chemicals",        {-1132.80,-787.30,0.00,-956.40,-768.00,200.00}},
	{"El Castillo del Diablo",      {-464.50,2217.60,0.00,-208.50,2580.30,200.00}},
	{"El Castillo del Diablo",      {-208.50,2123.00,-7.60,114.00,2337.10,200.00}},
	{"El Castillo del Diablo",      {-208.50,2337.10,0.00,8.40,2487.10,200.00}},
	{"El Corona",                   {1812.60,-2179.20,-89.00,1970.60,-1852.80,110.90}},
	{"El Corona",                   {1692.60,-2179.20,-89.00,1812.60,-1842.20,110.90}},
	{"El Quebrados",                {-1645.20,2498.50,0.00,-1372.10,2777.80,200.00}},
	{"Esplanade East",              {-1620.30,1176.50,-4.50,-1580.00,1274.20,200.00}},
	{"Esplanade East",              {-1580.00,1025.90,-6.10,-1499.80,1274.20,200.00}},
	{"Esplanade East",              {-1499.80,578.30,-79.60,-1339.80,1274.20,20.30}},
	{"Esplanade North",             {-2533.00,1358.90,-4.50,-1996.60,1501.20,200.00}},
	{"Esplanade North",             {-1996.60,1358.90,-4.50,-1524.20,1592.50,200.00}},
	{"Esplanade North",             {-1982.30,1274.20,-4.50,-1524.20,1358.90,200.00}},
	{"Fallen Tree",                 {-792.20,-698.50,-5.30,-452.40,-380.00,200.00}},
	{"Fallow Bridge",               {434.30,366.50,0.00,603.00,555.60,200.00}},
	{"Fern Ridge",                  {508.10,-139.20,0.00,1306.60,119.50,200.00}},
	{"Financial",                   {-1871.70,744.10,-6.10,-1701.30,1176.40,300.00}},
	{"Fisher's Lagoon",             {1916.90,-233.30,-100.00,2131.70,13.80,200.00}},
	{"Flint Intersection",          {-187.70,-1596.70,-89.00,17.00,-1276.60,110.90}},
	{"Flint Range",                 {-594.10,-1648.50,0.00,-187.70,-1276.60,200.00}},
	{"Fort Carson",                 {-376.20,826.30,-3.00,123.70,1220.40,200.00}},
	{"Foster Valley",               {-2270.00,-430.20,-0.00,-2178.60,-324.10,200.00}},
	{"Foster Valley",               {-2178.60,-599.80,-0.00,-1794.90,-324.10,200.00}},
	{"Foster Valley",               {-2178.60,-1115.50,0.00,-1794.90,-599.80,200.00}},
	{"Foster Valley",               {-2178.60,-1250.90,0.00,-1794.90,-1115.50,200.00}},
	{"Frederick Bridge",            {2759.20,296.50,0.00,2774.20,594.70,200.00}},
	{"Gant Bridge",                 {-2741.40,1659.60,-6.10,-2616.40,2175.10,200.00}},
	{"Gant Bridge",                 {-2741.00,1490.40,-6.10,-2616.40,1659.60,200.00}},
	{"Ganton",                      {2222.50,-1852.80,-89.00,2632.80,-1722.30,110.90}},
	{"Ganton",                      {2222.50,-1722.30,-89.00,2632.80,-1628.50,110.90}},
	{"Garcia",                      {-2411.20,-222.50,-0.00,-2173.00,265.20,200.00}},
	{"Garcia",                      {-2395.10,-222.50,-5.30,-2354.00,-204.70,200.00}},
	{"Garver Bridge",               {-1339.80,828.10,-89.00,-1213.90,1057.00,110.90}},
	{"Garver Bridge",               {-1213.90,950.00,-89.00,-1087.90,1178.90,110.90}},
	{"Garver Bridge",               {-1499.80,696.40,-179.60,-1339.80,925.30,20.30}},
	{"Glen Park",                   {1812.60,-1449.60,-89.00,1996.90,-1350.70,110.90}},
	{"Glen Park",                   {1812.60,-1100.80,-89.00,1994.30,-973.30,110.90}},
	{"Glen Park",                   {1812.60,-1350.70,-89.00,2056.80,-1100.80,110.90}},
	{"Green Palms",                 {176.50,1305.40,-3.00,338.60,1520.70,200.00}},
	{"Greenglass College",          {964.30,1044.60,-89.00,1197.30,1203.20,110.90}},
	{"Greenglass College",          {964.30,930.80,-89.00,1166.50,1044.60,110.90}},
	{"Hampton Barns",               {603.00,264.30,0.00,761.90,366.50,200.00}},
	{"Hankypanky Point",            {2576.90,62.10,0.00,2759.20,385.50,200.00}},
	{"Harry Gold Parkway",          {1777.30,863.20,-89.00,1817.30,2342.80,110.90}},
	{"Hashbury",                    {-2593.40,-222.50,-0.00,-2411.20,54.70,200.00}},
	{"Hilltop Farm",                {967.30,-450.30,-3.00,1176.70,-217.90,200.00}},
	{"Hunter Quarry",               {337.20,710.80,-115.20,860.50,1031.70,203.70}},
	{"Idlewood Gas Station",		{1896.3243,-1814.1318,-89,1977.8953,-1742.6628,110.90}},
	{"Idlewood",                    {1812.60,-1852.80,-89.00,1971.60,-1742.30,110.90}},
	{"Idlewood",                    {1812.60,-1742.30,-89.00,1951.60,-1602.30,110.90}},
	{"Idlewood",                    {1951.60,-1742.30,-89.00,2124.60,-1602.30,110.90}},
	{"Idlewood",                    {1812.60,-1602.30,-89.00,2124.60,-1449.60,110.90}},
	{"Idlewood",                    {2124.60,-1742.30,-89.00,2222.50,-1494.00,110.90}},
	{"Idlewood",                    {1971.60,-1852.80,-89.00,2222.50,-1742.30,110.90}},
	{"Jefferson",                   {1996.90,-1449.60,-89.00,2056.80,-1350.70,110.90}},
	{"Jefferson",                   {2124.60,-1494.00,-89.00,2266.20,-1449.60,110.90}},
	{"Jefferson",                   {2056.80,-1372.00,-89.00,2281.40,-1210.70,110.90}},
	{"Jefferson",                   {2056.80,-1210.70,-89.00,2185.30,-1126.30,110.90}},
	{"Jefferson",                   {2185.30,-1210.70,-89.00,2281.40,-1154.50,110.90}},
	{"Jefferson",                   {2056.80,-1449.60,-89.00,2266.20,-1372.00,110.90}},
	{"Julius Thruway East",         {2623.10,943.20,-89.00,2749.90,1055.90,110.90}},
	{"Julius Thruway East",         {2685.10,1055.90,-89.00,2749.90,2626.50,110.90}},
	{"Julius Thruway East",         {2536.40,2442.50,-89.00,2685.10,2542.50,110.90}},
	{"Julius Thruway East",         {2625.10,2202.70,-89.00,2685.10,2442.50,110.90}},
	{"Julius Thruway North",        {2498.20,2542.50,-89.00,2685.10,2626.50,110.90}},
	{"Julius Thruway North",        {2237.40,2542.50,-89.00,2498.20,2663.10,110.90}},
	{"Julius Thruway North",        {2121.40,2508.20,-89.00,2237.40,2663.10,110.90}},
	{"Julius Thruway North",        {1938.80,2508.20,-89.00,2121.40,2624.20,110.90}},
	{"Julius Thruway North",        {1534.50,2433.20,-89.00,1848.40,2583.20,110.90}},
	{"Julius Thruway North",        {1848.40,2478.40,-89.00,1938.80,2553.40,110.90}},
	{"Julius Thruway North",        {1704.50,2342.80,-89.00,1848.40,2433.20,110.90}},
	{"Julius Thruway North",        {1377.30,2433.20,-89.00,1534.50,2507.20,110.90}},
	{"Julius Thruway South",        {1457.30,823.20,-89.00,2377.30,863.20,110.90}},
	{"Julius Thruway South",        {2377.30,788.80,-89.00,2537.30,897.90,110.90}},
	{"Julius Thruway West",         {1197.30,1163.30,-89.00,1236.60,2243.20,110.90}},
	{"Julius Thruway West",         {1236.60,2142.80,-89.00,1297.40,2243.20,110.90}},
	{"Juniper Hill",                {-2533.00,578.30,-7.60,-2274.10,968.30,200.00}},
	{"Juniper Hollow",              {-2533.00,968.30,-6.10,-2274.10,1358.90,200.00}},
	{"K.A.C.C. Military Fuels",     {2498.20,2626.50,-89.00,2749.90,2861.50,110.90}},
	{"Kincaid Bridge",              {-1339.80,599.20,-89.00,-1213.90,828.10,110.90}},
	{"Kincaid Bridge",              {-1213.90,721.10,-89.00,-1087.90,950.00,110.90}},
	{"Kincaid Bridge",              {-1087.90,855.30,-89.00,-961.90,986.20,110.90}},
	{"King's",                      {-2329.30,458.40,-7.60,-1993.20,578.30,200.00}},
	{"King's",                      {-2411.20,265.20,-9.10,-1993.20,373.50,200.00}},
	{"King's",                      {-2253.50,373.50,-9.10,-1993.20,458.40,200.00}},
	{"LVA Freight Depot",           {1457.30,863.20,-89.00,1777.40,1143.20,110.90}},
	{"LVA Freight Depot",           {1375.60,919.40,-89.00,1457.30,1203.20,110.90}},
	{"LVA Freight Depot",           {1277.00,1087.60,-89.00,1375.60,1203.20,110.90}},
	{"LVA Freight Depot",           {1315.30,1044.60,-89.00,1375.60,1087.60,110.90}},
	{"LVA Freight Depot",           {1236.60,1163.40,-89.00,1277.00,1203.20,110.90}},
	{"Las Barrancas",               {-926.10,1398.70,-3.00,-719.20,1634.60,200.00}},
	{"Las Brujas",                  {-365.10,2123.00,-3.00,-208.50,2217.60,200.00}},
	{"Las Colinas",                 {1994.30,-1100.80,-89.00,2056.80,-920.80,110.90}},
	{"Las Colinas",                 {2056.80,-1126.30,-89.00,2126.80,-920.80,110.90}},
	{"Las Colinas",                 {2185.30,-1154.50,-89.00,2281.40,-934.40,110.90}},
	{"Las Colinas",                 {2126.80,-1126.30,-89.00,2185.30,-934.40,110.90}},
	{"Las Colinas",                 {2747.70,-1120.00,-89.00,2959.30,-945.00,110.90}},
	{"Las Colinas",                 {2632.70,-1135.00,-89.00,2747.70,-945.00,110.90}},
	{"Las Colinas",                 {2281.40,-1135.00,-89.00,2632.70,-945.00,110.90}},
	{"Las Payasadas",               {-354.30,2580.30,2.00,-133.60,2816.80,200.00}},
	{"Las Venturas Airport",        {1236.60,1203.20,-89.00,1457.30,1883.10,110.90}},
	{"Las Venturas Airport",        {1457.30,1203.20,-89.00,1777.30,1883.10,110.90}},
	{"Las Venturas Airport",        {1457.30,1143.20,-89.00,1777.40,1203.20,110.90}},
	{"Las Venturas Airport",        {1515.80,1586.40,-12.50,1729.90,1714.50,87.50}},
	{"Last Dime Motel",             {1823.00,596.30,-89.00,1997.20,823.20,110.90}},
	{"Leafy Hollow",                {-1166.90,-1856.00,0.00,-815.60,-1602.00,200.00}},
	{"Liberty City",                {-1000.00,400.00,1300.00,-700.00,600.00,1400.00}},
	{"Lil' Probe Inn",              {-90.20,1286.80,-3.00,153.80,1554.10,200.00}},
	{"Linden Side",                 {2749.90,943.20,-89.00,2923.30,1198.90,110.90}},
	{"Linden Station",              {2749.90,1198.90,-89.00,2923.30,1548.90,110.90}},
	{"Linden Station",              {2811.20,1229.50,-39.50,2861.20,1407.50,60.40}},
	{"Little Mexico",               {1701.90,-1842.20,-89.00,1812.60,-1722.20,110.90}},
	{"Little Mexico",               {1758.90,-1722.20,-89.00,1812.60,-1577.50,110.90}},
	{"Los Flores",                  {2581.70,-1454.30,-89.00,2632.80,-1393.40,110.90}},
	{"Los Flores",                  {2581.70,-1393.40,-89.00,2747.70,-1135.00,110.90}},
	{"Los Santos International",    {1249.60,-2394.30,-89.00,1852.00,-2179.20,110.90}},
	{"Los Santos International",    {1852.00,-2394.30,-89.00,2089.00,-2179.20,110.90}},
	{"Los Santos International",    {1382.70,-2730.80,-89.00,2201.80,-2394.30,110.90}},
	{"Los Santos International",    {1974.60,-2394.30,-39.00,2089.00,-2256.50,60.90}},
	{"Los Santos International",    {1400.90,-2669.20,-39.00,2189.80,-2597.20,60.90}},
	{"Los Santos International",    {2051.60,-2597.20,-39.00,2152.40,-2394.30,60.90}},
	{"Marina",                      {647.70,-1804.20,-89.00,851.40,-1577.50,110.90}},
	{"Marina",                      {647.70,-1577.50,-89.00,807.90,-1416.20,110.90}},
	{"Marina",                      {807.90,-1577.50,-89.00,926.90,-1416.20,110.90}},
	{"Market",                      {787.40,-1416.20,-89.00,1072.60,-1310.20,110.90}},
	{"Market",                      {952.60,-1310.20,-89.00,1072.60,-1130.80,110.90}},
	{"Market",                      {1072.60,-1416.20,-89.00,1370.80,-1130.80,110.90}},
	{"Market",                      {926.90,-1577.50,-89.00,1370.80,-1416.20,110.90}},
	{"Market Station",              {787.40,-1410.90,-34.10,866.00,-1310.20,65.80}},
	{"Martin Bridge",               {-222.10,293.30,0.00,-122.10,476.40,200.00}},
	{"Missionary Hill",             {-2994.40,-811.20,0.00,-2178.60,-430.20,200.00}},
	{"Montgomery",                  {1119.50,119.50,-3.00,1451.40,493.30,200.00}},
	{"Montgomery",                  {1451.40,347.40,-6.10,1582.40,420.80,200.00}},
	{"Montgomery Intersection",     {1546.60,208.10,0.00,1745.80,347.40,200.00}},
	{"Montgomery Intersection",     {1582.40,347.40,0.00,1664.60,401.70,200.00}},
	{"Mulholland",                  {1414.00,-768.00,-89.00,1667.60,-452.40,110.90}},
	{"Mulholland",                  {1281.10,-452.40,-89.00,1641.10,-290.90,110.90}},
	{"Mulholland",                  {1269.10,-768.00,-89.00,1414.00,-452.40,110.90}},
	{"Mulholland",                  {1357.00,-926.90,-89.00,1463.90,-768.00,110.90}},
	{"Mulholland",                  {1318.10,-910.10,-89.00,1357.00,-768.00,110.90}},
	{"Mulholland",                  {1169.10,-910.10,-89.00,1318.10,-768.00,110.90}},
	{"Mulholland",                  {768.60,-954.60,-89.00,952.60,-860.60,110.90}},
	{"Mulholland",                  {687.80,-860.60,-89.00,911.80,-768.00,110.90}},
	{"Mulholland",                  {737.50,-768.00,-89.00,1142.20,-674.80,110.90}},
	{"Mulholland",                  {1096.40,-910.10,-89.00,1169.10,-768.00,110.90}},
	{"Mulholland",                  {952.60,-937.10,-89.00,1096.40,-860.60,110.90}},
	{"Mulholland",                  {911.80,-860.60,-89.00,1096.40,-768.00,110.90}},
	{"Mulholland",                  {861.00,-674.80,-89.00,1156.50,-600.80,110.90}},
	{"Mulholland Intersection",     {1463.90,-1150.80,-89.00,1812.60,-768.00,110.90}},
	{"North Rock",                  {2285.30,-768.00,0.00,2770.50,-269.70,200.00}},
	{"Ocean Docks",                 {2373.70,-2697.00,-89.00,2809.20,-2330.40,110.90}},
	{"Ocean Docks",                 {2201.80,-2418.30,-89.00,2324.00,-2095.00,110.90}},
	{"Ocean Docks",                 {2324.00,-2302.30,-89.00,2703.50,-2145.10,110.90}},
	{"Ocean Docks",                 {2089.00,-2394.30,-89.00,2201.80,-2235.80,110.90}},
	{"Ocean Docks",                 {2201.80,-2730.80,-89.00,2324.00,-2418.30,110.90}},
	{"Ocean Docks",                 {2703.50,-2302.30,-89.00,2959.30,-2126.90,110.90}},
	{"Ocean Docks",                 {2324.00,-2145.10,-89.00,2703.50,-2059.20,110.90}},
	{"Ocean Flats",                 {-2994.40,277.40,-9.10,-2867.80,458.40,200.00}},
	{"Ocean Flats",                 {-2994.40,-222.50,-0.00,-2593.40,277.40,200.00}},
	{"Ocean Flats",                 {-2994.40,-430.20,-0.00,-2831.80,-222.50,200.00}},
	{"Octane Springs",              {338.60,1228.50,0.00,664.30,1655.00,200.00}},
	{"Old Venturas Strip",          {2162.30,2012.10,-89.00,2685.10,2202.70,110.90}},
	{"Palisades",                   {-2994.40,458.40,-6.10,-2741.00,1339.60,200.00}},
	{"Palomino Creek",              {2160.20,-149.00,0.00,2576.90,228.30,200.00}},
	{"Paradiso",                    {-2741.00,793.40,-6.10,-2533.00,1268.40,200.00}},
	{"Pershing Square",             {1440.90,-1722.20,-89.00,1583.50,-1577.50,110.90}},
	{"Pilgrim",                     {2437.30,1383.20,-89.00,2624.40,1783.20,110.90}},
	{"Pilgrim",                     {2624.40,1383.20,-89.00,2685.10,1783.20,110.90}},
	{"Pilson Intersection",         {1098.30,2243.20,-89.00,1377.30,2507.20,110.90}},
	{"Pirates in Men's Pants",      {1817.30,1469.20,-89.00,2027.40,1703.20,110.90}},
	{"Playa del Seville",           {2703.50,-2126.90,-89.00,2959.30,-1852.80,110.90}},
	{"Prickle Pine",                {1534.50,2583.20,-89.00,1848.40,2863.20,110.90}},
	{"Prickle Pine",                {1117.40,2507.20,-89.00,1534.50,2723.20,110.90}},
	{"Prickle Pine",                {1848.40,2553.40,-89.00,1938.80,2863.20,110.90}},
	{"Prickle Pine",                {1938.80,2624.20,-89.00,2121.40,2861.50,110.90}},
	{"Queens",                      {-2533.00,458.40,0.00,-2329.30,578.30,200.00}},
	{"Queens",                      {-2593.40,54.70,0.00,-2411.20,458.40,200.00}},
	{"Queens",                      {-2411.20,373.50,0.00,-2253.50,458.40,200.00}},
	{"Randolph Industrial Estate",  {1558.00,596.30,-89.00,1823.00,823.20,110.90}},
	{"Redsands East",               {1817.30,2011.80,-89.00,2106.70,2202.70,110.90}},
	{"Redsands East",               {1817.30,2202.70,-89.00,2011.90,2342.80,110.90}},
	{"Redsands East",               {1848.40,2342.80,-89.00,2011.90,2478.40,110.90}},
	{"Redsands West",               {1236.60,1883.10,-89.00,1777.30,2142.80,110.90}},
	{"Redsands West",               {1297.40,2142.80,-89.00,1777.30,2243.20,110.90}},
	{"Redsands West",               {1377.30,2243.20,-89.00,1704.50,2433.20,110.90}},
	{"Redsands West",               {1704.50,2243.20,-89.00,1777.30,2342.80,110.90}},
	{"Regular Tom",                 {-405.70,1712.80,-3.00,-276.70,1892.70,200.00}},
	{"Richman",                     {647.50,-1118.20,-89.00,787.40,-954.60,110.90}},
	{"Richman",                     {647.50,-954.60,-89.00,768.60,-860.60,110.90}},
	{"Richman",                     {225.10,-1369.60,-89.00,334.50,-1292.00,110.90}},
	{"Richman",                     {225.10,-1292.00,-89.00,466.20,-1235.00,110.90}},
	{"Richman",                     {72.60,-1404.90,-89.00,225.10,-1235.00,110.90}},
	{"Richman",                     {72.60,-1235.00,-89.00,321.30,-1008.10,110.90}},
	{"Richman",                     {321.30,-1235.00,-89.00,647.50,-1044.00,110.90}},
	{"Richman",                     {321.30,-1044.00,-89.00,647.50,-860.60,110.90}},
	{"Richman",                     {321.30,-860.60,-89.00,687.80,-768.00,110.90}},
	{"Richman",                     {321.30,-768.00,-89.00,700.70,-674.80,110.90}},
	{"Robada Intersection",         {-1119.00,1178.90,-89.00,-862.00,1351.40,110.90}},
	{"Roca Escalante",              {2237.40,2202.70,-89.00,2536.40,2542.50,110.90}},
	{"Roca Escalante",              {2536.40,2202.70,-89.00,2625.10,2442.50,110.90}},
	{"Rockshore East",              {2537.30,676.50,-89.00,2902.30,943.20,110.90}},
	{"Rockshore West",              {1997.20,596.30,-89.00,2377.30,823.20,110.90}},
	{"Rockshore West",              {2377.30,596.30,-89.00,2537.30,788.80,110.90}},
	{"Rodeo",                       {72.60,-1684.60,-89.00,225.10,-1544.10,110.90}},
	{"Rodeo",                       {72.60,-1544.10,-89.00,225.10,-1404.90,110.90}},
	{"Rodeo",                       {225.10,-1684.60,-89.00,312.80,-1501.90,110.90}},
	{"Rodeo",                       {225.10,-1501.90,-89.00,334.50,-1369.60,110.90}},
	{"Rodeo",                       {334.50,-1501.90,-89.00,422.60,-1406.00,110.90}},
	{"Rodeo",                       {312.80,-1684.60,-89.00,422.60,-1501.90,110.90}},
	{"Rodeo",                       {422.60,-1684.60,-89.00,558.00,-1570.20,110.90}},
	{"Rodeo",                       {558.00,-1684.60,-89.00,647.50,-1384.90,110.90}},
	{"Rodeo",                       {466.20,-1570.20,-89.00,558.00,-1385.00,110.90}},
	{"Rodeo",                       {422.60,-1570.20,-89.00,466.20,-1406.00,110.90}},
	{"Rodeo",                       {466.20,-1385.00,-89.00,647.50,-1235.00,110.90}},
	{"Rodeo",                       {334.50,-1406.00,-89.00,466.20,-1292.00,110.90}},
	{"Royal Casino",                {2087.30,1383.20,-89.00,2437.30,1543.20,110.90}},
	{"San Andreas Sound",           {2450.30,385.50,-100.00,2759.20,562.30,200.00}},
	{"Santa Flora",                 {-2741.00,458.40,-7.60,-2533.00,793.40,200.00}},
	{"Santa Maria Beach",           {342.60,-2173.20,-89.00,647.70,-1684.60,110.90}},
	{"Santa Maria Beach",           {72.60,-2173.20,-89.00,342.60,-1684.60,110.90}},
	{"Shady Cabin",                 {-1632.80,-2263.40,-3.00,-1601.30,-2231.70,200.00}},
	{"Shady Creeks",                {-1820.60,-2643.60,-8.00,-1226.70,-1771.60,200.00}},
	{"Shady Creeks",                {-2030.10,-2174.80,-6.10,-1820.60,-1771.60,200.00}},
	{"Sobell Rail Yards",           {2749.90,1548.90,-89.00,2923.30,1937.20,110.90}},
	{"Spinybed",                    {2121.40,2663.10,-89.00,2498.20,2861.50,110.90}},
	{"Starfish Casino",             {2437.30,1783.20,-89.00,2685.10,2012.10,110.90}},
	{"Starfish Casino",             {2437.30,1858.10,-39.00,2495.00,1970.80,60.90}},
	{"Starfish Casino",             {2162.30,1883.20,-89.00,2437.30,2012.10,110.90}},
	{"Temple",                      {1252.30,-1130.80,-89.00,1378.30,-1026.30,110.90}},
	{"Temple",                      {1252.30,-1026.30,-89.00,1391.00,-926.90,110.90}},
	{"Temple",                      {1252.30,-926.90,-89.00,1357.00,-910.10,110.90}},
	{"Temple",                      {952.60,-1130.80,-89.00,1096.40,-937.10,110.90}},
	{"Temple",                      {1096.40,-1130.80,-89.00,1252.30,-1026.30,110.90}},
	{"Temple",                      {1096.40,-1026.30,-89.00,1252.30,-910.10,110.90}},
	{"The Camel's Toe",             {2087.30,1203.20,-89.00,2640.40,1383.20,110.90}},
	{"The Clown's Pocket",          {2162.30,1783.20,-89.00,2437.30,1883.20,110.90}},
	{"The Emerald Isle",            {2011.90,2202.70,-89.00,2237.40,2508.20,110.90}},
	{"The Farm",                    {-1209.60,-1317.10,114.90,-908.10,-787.30,251.90}},
	{"The Four Dragons Casino",     {1817.30,863.20,-89.00,2027.30,1083.20,110.90}},
	{"The High Roller",             {1817.30,1283.20,-89.00,2027.30,1469.20,110.90}},
	{"The Mako Span",               {1664.60,401.70,0.00,1785.10,567.20,200.00}},
	{"The Panopticon",              {-947.90,-304.30,-1.10,-319.60,327.00,200.00}},
	{"The Pink Swan",               {1817.30,1083.20,-89.00,2027.30,1283.20,110.90}},
	{"The Sherman Dam",             {-968.70,1929.40,-3.00,-481.10,2155.20,200.00}},
	{"The Strip",                   {2027.40,863.20,-89.00,2087.30,1703.20,110.90}},
	{"The Strip",                   {2106.70,1863.20,-89.00,2162.30,2202.70,110.90}},
	{"The Strip",                   {2027.40,1783.20,-89.00,2162.30,1863.20,110.90}},
	{"The Strip",                   {2027.40,1703.20,-89.00,2137.40,1783.20,110.90}},
	{"The Visage",                  {1817.30,1863.20,-89.00,2106.70,2011.80,110.90}},
	{"The Visage",                  {1817.30,1703.20,-89.00,2027.40,1863.20,110.90}},
	{"Unity Station",               {1692.60,-1971.80,-20.40,1812.60,-1932.80,79.50}},
	{"Valle Ocultado",              {-936.60,2611.40,2.00,-715.90,2847.90,200.00}},
	{"Verdant Bluffs",              {930.20,-2488.40,-89.00,1249.60,-2006.70,110.90}},
	{"Verdant Bluffs",              {1073.20,-2006.70,-89.00,1249.60,-1842.20,110.90}},
	{"Verdant Bluffs",              {1249.60,-2179.20,-89.00,1692.60,-1842.20,110.90}},
	{"Verdant Meadows",             {37.00,2337.10,-3.00,435.90,2677.90,200.00}},
	{"Verona Beach",                {647.70,-2173.20,-89.00,930.20,-1804.20,110.90}},
	{"Verona Beach",                {930.20,-2006.70,-89.00,1073.20,-1804.20,110.90}},
	{"Verona Beach",                {851.40,-1804.20,-89.00,1046.10,-1577.50,110.90}},
	{"Verona Beach",                {1161.50,-1722.20,-89.00,1323.90,-1577.50,110.90}},
	{"Verona Beach",                {1046.10,-1722.20,-89.00,1161.50,-1577.50,110.90}},
	{"Vinewood",                    {787.40,-1310.20,-89.00,952.60,-1130.80,110.90}},
	{"Vinewood",                    {787.40,-1130.80,-89.00,952.60,-954.60,110.90}},
	{"Vinewood",                    {647.50,-1227.20,-89.00,787.40,-1118.20,110.90}},
	{"Vinewood",                    {647.70,-1416.20,-89.00,787.40,-1227.20,110.90}},
	{"Whitewood Estates",           {883.30,1726.20,-89.00,1098.30,2507.20,110.90}},
	{"Whitewood Estates",           {1098.30,1726.20,-89.00,1197.30,2243.20,110.90}},
	{"Willowfield",                 {1970.60,-2179.20,-89.00,2089.00,-1852.80,110.90}},
	{"Willowfield",                 {2089.00,-2235.80,-89.00,2201.80,-1989.90,110.90}},
	{"Willowfield",                 {2089.00,-1989.90,-89.00,2324.00,-1852.80,110.90}},
	{"Willowfield",                 {2201.80,-2095.00,-89.00,2324.00,-1989.90,110.90}},
	{"Willowfield",                 {2541.70,-1941.40,-89.00,2703.50,-1852.80,110.90}},
	{"Willowfield",                 {2324.00,-2059.20,-89.00,2541.70,-1852.80,110.90}},
	{"Willowfield",                 {2541.70,-2059.20,-89.00,2703.50,-1941.40,110.90}},
	{"Yellow Bell Station",         {1377.40,2600.40,-21.90,1492.40,2687.30,78.00}},
	// Main Zones
	{"Los Santos",                  {44.60,-2892.90,-242.90,2997.00,-768.00,900.00}},
	{"Las Venturas",                {869.40,596.30,-242.90,2997.00,2993.80,900.00}},
	{"Bone County",                 {-480.50,596.30,-242.90,869.40,2993.80,900.00}},
	{"Tierra Robada",               {-2997.40,1659.60,-242.90,-480.50,2993.80,900.00}},
	{"Tierra Robada",               {-1213.90,596.30,-242.90,-480.50,1659.60,900.00}},
	{"San Fierro",                  {-2997.40,-1115.50,-242.90,-1213.90,1659.60,900.00}},
	{"Red County",                  {-1213.90,-768.00,-242.90,2997.00,596.30,900.00}},
	{"Flint County",                {-1213.90,-2892.90,-242.90,44.60,-768.00,900.00}},
	{"Whetstone",                   {-2997.40,-2892.90,-242.90,-1213.90,-1115.50,900.00}}
};

new starttime;
new AdvStrike[MAX_PLAYERS];


new FakeDeath[MAX_PLAYERS]; //Anti-FakeDeath
new bool:IsDead[MAX_PLAYERS]; //Anti-FakeDeath
new HeliBladeStrike[MAX_PLAYERS]; //Anti-Heliblade

new Event_InProgress = -1;

new IgnoreOnline[MAX_PLAYERS]; //Anti-TimeSpawn
