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
* Filename: adminsettings.pwn                                                    *
* Created by: Marcel                                                             *
*********************************************************************************/
#define ACMD_BRONZE 1
#define ACMD_SILVER 3
#define ACMD_GOLD 5

/*LEVEL 1 COMMADS BELOW:*/
#define ACMD_AREARM 1
#define ACMD_DEATHSTREAKS 1
#define ACMD_AS 1
#define ACMD_ASTOPANIM 1
#define ACMD_VIEWDAMAGE 1
#define ACMD_SPAWNPLAYER 1
#define ACMD_WVS 1
#define ACMD_A 1
#define ACMD_ADUTY 1
#define ACMD_GOTO 1
#define ACMD_GET 1
#define ACMD_FPS 1
#define ACMD_MINFPS 1
#define ACMD_ANTICBUG 1
#define ACMD_RESETGUNS 1
#define ACMD_GOTOLS 1
#define ACMD_GOTOLV 1
#define ACMD_GOTOSF 1
#define ACMD_GOTOPICKUP 1
#define ACMD_GOTOXYZ 1
#define ACMD_SETINT 1
#define ACMD_SETWORLD 1
#define ACMD_GOTOCAR 1
#define ACMD_DESPAWNCAR 1
#define ACMD_WARN 1
#define ACMD_KICK 1
#define ACMD_JAIL 1
#define ACMD_BAN 1
#define ACMD_BANIP 1 // This also applies to /unbanip !
#define ACMD_UNBAN 1
#define ACMD_UNJAIL 1
#define ACMD_FREEZE 1
#define ACMD_UNFREEZE 1
#define ACMD_FORCERULES 1
#define ACMD_TOGGLEAC 3
#define ACMD_GETIP 1
#define ACMD_SS 1
#define ACMD_SLAP 1
#define ACMD_FORCETEAM 1
#define ACMD_MUTE 1
#define ACMD_UNMUTE 1
#define ACMD_SPECTATE 1
#define ACMD_AWP 1
#define ACMD_ANNOUNCE 1
#define ACMD_ANN 1
#define ACMD_UP 1
#define ACMD_DOWN 1
#define ACMD_SRW 1
#define ACMD_REPORTS 1
#define ACMD_AR 1
#define ACMD_DR 1
#define ACMD_REPAIR 1
#define ACMD_CHECK 1
#define ACMD_COUNTDOWN 1
#define ACMD_MARK 1
#define ACMD_GOTOMARK 1
#define ACMD_PPK 1
#define ACMD_EVENT 1
#define ACMD_REMOVESKIN 1
#define ACMD_GOTOCLANSPAWN 1
#define ACMD_MUTELIST 1
#define ACMD_WEAPONDAMAGES 1
#define ACMD_PL 1
#define ACMD_GOTOGAS 1
#define ACMD_LOCALPLAYERS 1
#define ACMD_LASTCOMMANDS 1
#define ACMD_AUTH 1
/*LEVEL 2 COMMANDS BELOW:*/
#define ACMD_BOUNTY 2
#define ACMD_TOD 2
#define ACMD_WEATHER 2
#define ACMD_JETPACK 2
#define ACMD_CLEARCHAT 2
#define ACMD_STARTVOTE 2
#define ACMD_ENDVOTE 2
#define ACMD_AKILL 2
#define ACMD_REMOVEWARN 2
#define ACMD_DESPAWNALLCARS 2
#define ACMD_GETCAR 2
#define ACMD_SETHP 2
#define ACMD_SETARMOUR 2
#define ACMD_SSLAP 2
#define ACMD_SFREEZE 2
#define ACMD_SUNFREEZE 2
#define ACMD_FIXCAR 2
#define ACMD_CNN 2 //This also applies to /pcnn !
#define ACMD_ASKYDIVE 2
#define ACMD_ANTIFALL 2
#define ACMD_REMOVELOCALWEAPONS 2
#define ACMD_MOVEINTOCAR 2
#define ACMD_GPCI 2
/*LEVEL 3 COMMANDS BELOW:*/
#define ACMD_PLL 3
#define ACMD_SAVESTATSALL 3
#define ACMD_SAVESTATS 3
#define ACMD_UNDERCOVER 3
#define ACMD_GIVEGUN 3
#define ACMD_SETSKIN 3
#define ACMD_WATCHPM 3
#define ACMD_WATCHTEAMCHAT 3
#define ACMD_GIVELOCALWEAPON 3
#define ACMD_SETLOCALHP 3
#define ACMD_SETLOCALARMOUR 3
#define ACMD_AVEH 3
#define ACMD_TRANS 3
#define ACMD_TRANSPREF 3
#define ACMD_TRANSRESET 3
#define ACMD_SETCLANHEALTH 3
#define ACMD_SETCLANARMOUR 3
#define ACMD_REMOVECLANWEAPONS 3
#define ACMD_GOTOCLANSPAWN 1
#define ACMD_GIVECLANWEAPONS 3
#define ACMD_EXPLODE 3
#define ACMD_GETCLAN 3
#define ACMD_SUPERSLAP 3
#define ACMD_CAROWNERNAMEDB 3
#define ACMD_RESETWEAPPICKUPS 3
#define ACMD_FLIP 3
#define ACMD_CARCOLOR 3
#define ACMD_RHA 3
#define ACMD_ARESETCLASSES 3
#define ACMD_APPROVENC 3
#define ACMD_ADDSTATION 3
#define ACMD_BANIPRANGE 3
/*LEVEL 4 COMMANDS BELOW:*/
#define ACMD_REMOVEFROMCLAN 4
#define ACMD_DELETECAR 4
#define ACMD_CREATECAR 4
#define ACMD_DELETECAR 4
#define ACMD_GETALL 4
#define ACMD_SETHPALL 4
#define ACMD_SETARMOURALL 4
#define ACMD_GIVEALLWEAPON 4
#define ACMD_RESETKEY 4
#define ACMD_CONNECTBOTS 4
#define ACMD_DISCONNECTBOTS 4
#define ACMD_NONAME 4
#define ACMD_TOGMAIN 4
#define ACMD_ATEAM 4
#define ACMD_INSERTGROUP 4
#define ACMD_RESETSTATS 4
#define ACMD_ONPLAYERDISCONNECT 4
#define ACMD_ONPLAYERDEATH 4
#define ACMD_GCCP 4
#define ACMD_RELOAD_RESTRICTED_SKINS 4
#define ACMD_ACP 4
/*LEVEL 5 COMMANDS BELOW:*/
#define ACMD_SPECTATORS 5
#define ACMD_SETACH 5
#define ACMD_AGIVE 5
#define ACMD_SHOPSYS 5
#define ACMD_PICKUPS 5
#define ACMD_SETADMIN 5
#define ACMD_SETTRIALADMIN 5
#define ACMD_SETVIP 5
#define ACMD_NS 5
#define ACMD_GODCAR 5
#define ACMD_ENDROUND 5
#define ACMD_ASETSTATION 5
#define ACMD_ATURF 5
#define ACMD_QUICKSUMO 5
#define ACMD_MODIFY 5
#define ACMD_EAO 5
#define ACMD_MOTD 5
#define ACMD_SPINCAR 5
#define ACMD_KICKALL 5
#define ACMD_RULES 5
#define ACMD_DONATIONINFO 5
#define ACMD_MAXPLAYERSPERIP 5

/* NEWLY ADDED BY MARCEL */
#define ACMD_SETSTAT 4
#define ACMD_LA 4
#define ACMD_SETCAR 4
#define ACMD_CHANGENAME 4
#define ACMD_GETXYZ 1
#define ACMD_XYZLOG 5 //stores the admins current XYZ coords and Facing angle to a log file
#define ACMD_TEMPBAN 1 // not yet fully working, but you can already use the define. I'll announce availability on admin forum once its done
#define ACMD_AHIDE 3 // hides a admins name from the /admins list
#define ACMD_CAM 1 // Cam-System by Vista
#define ACMD_VINFO 1
#define ACMD_DISABLELOC 3
#define ACMD_SETDRUNK 5
#define ACMD_SETGROUP 2
#define ACMD_TOGGROUPS 1


CMD:ahelp(playerid, params[])
{
	cmd_ah(playerid, params);
	return 1;
}

CMD:ah(playerid, params[])
{
	new string[256];
	if(FoCo_Player[playerid][admin] >= 1)
	{
		format(string, sizeof(string), "{%06x}------------LEVEL 1 ADMIN COMMANDS------------", COLOR_GREEN >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /a(chat) - /aduty - /arearm - /anticbug - /ann(ounce) - /as - /specfix");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /(un)(temp)ban - /banip - /cam - /check - /countdown - /astopanim(ation) - /getplayerxyz (gxyz)");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /despawncar - /deathstreaks - /event (start/end/setbrawlpoint/add/forcecriminal)");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /fps - /(un)freeze - /forcerules - /forceteam - /(un)freezelocal (/l(un)freeze)");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /get - /goto(p/ls/sf/lv/xyz/car) - /getip - /(goto)mark - /gotoclanspawn(/gcs)");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /(un)jail - /kick - /(un)mute - /ppk(PARK.PLAYER.VEH) - /maptp - /localplayers - /lastcommands");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /repair - /removeskin - /resetguns  - /ss(SilentSlap) - /ssah(SilentH/ASlap)- /slap - /spec(tate)");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /srw (SILENT.REMOVE.WPN) - /spawnplayer - /setint - /setworld - /up - /down");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /warn - /wvs(WORLD.VEHICLE.SKIN) - /weapondamages - /reports - /ar(ACPT.REP) - /dr(DEL.REP)");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /advancedas(adas) - /forcescroll(fsg) - /weaponfreeze - /vinfo - /alias(2/3/4)");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[INF.ADMIN]: /teamids (/teaminfo) - /weapondamages(wdmg) - /weaponfreeze - /checkaccountstatus(cas)");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[HACK.BUST]: /anticbug - /(given/taken)damage - /getploc (IPLOC) - /proxycheck (pcheck) - /pservers ");
		SendClientMessage(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "[HACK.BUST]: /pablog(POOR.AIMBOT) - /pablist - /cwatch(CBUG.WARN) - /watchrf(RAPID.FIRE) - /salist - /watchsa");
		SendClientMessage(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "[HACK.BUST]: /watchns(NO.SPREAD) - /nslist - /togglens - /getploc(PLAYER.LOC) - /clearproxycheck");
		SendClientMessage(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "{%06x}++++++++++++++++++++++++++++++++++++++++++++++", COLOR_GREEN >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	if(FoCo_Player[playerid][admin] >= 2)
	{
		format(string, sizeof(string), "{%06x}------------LEVEL 2 ADMIN COMMANDS------------", COLOR_GREEN >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /akill - /despawnallcars - /clearchat - /getcar/tod(TIME.OF.DAY) - /fixcar");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /set(hp/armour) - /(start/end)vote - /ss(SILENT.SLAP) - /s(un)freeze");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /(p)cnn - /removelocalweapons - /removewarn - /moveintocar");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[MISC]: /bounty - /jetpack - /askydive - /antifall - /gpci");
		SendClientMessage(playerid, COLOR_BLUE, string);
		format(string, sizeof(string), "{%06x}++++++++++++++++++++++++++++++++++++++++++++++", COLOR_GREEN >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	if(FoCo_Player[playerid][admin] >= 3)
	{
		format(string, sizeof(string), "{%06x}------------LEVEL 3 ADMIN COMMANDS------------", COLOR_GREEN >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /aveh - /ahide - /aresetclasses - /disableloc - /carownernamedb - /explode");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /giveweapon - /(give/remove)localweapon - /setl(ocal)(hp/armour) - /rha");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /(give/remove)clanweapons - /setclan(health/armour) - /getclan");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /watch(pm/teamchat) - /savestats(all) - /superslap - /setskin");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[HACK.BUST]: /toggleac - /acs(AIMBOT.TEST) - /recheckserverstatus");
		SendClientMessage(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "[MISC]: /flip - /carcolor - /trans - /transpref - /transreset");
		SendClientMessage(playerid, COLOR_BLUE, string);
		format(string, sizeof(string), "{%06x}++++++++++++++++++++++++++++++++++++++++++++++", COLOR_GREEN >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	if(FoCo_Player[playerid][admin] >= 4)
	{
		format(string, sizeof(string), "{%06x}------------LEVEL 4 ADMIN COMMANDS------------", COLOR_GREEN >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /ateam - /(create/delete/set)car - /changename - /(dis)connectbots");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /reset(key/stats) - /removefromclan(rfclan) - /togmain - /la - /rcfocostatus");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /sethpall - /setarmourall - /giveallweapon - /getall - /setstat(new)");
		SendClientMessage(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[MISC]: /teleports - /noname - /gotoccp - /onplayerdeathmsg - /onplayerdisconnectmsg");
		SendClientMessage(playerid, COLOR_BLUE, string);
		format(string, sizeof(string), "[MISC]: /dev_note - /noname - /gotoccp - /onplayerdeathmsg - /onplayerdisconnectmsg");
		SendClientMessage(playerid, COLOR_BLUE, string);

		format(string, sizeof(string), "{%06x}++++++++++++++++++++++++++++++++++++++++++++++", COLOR_GREEN >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	if(FoCo_Player[playerid][admin] >= 5)
	{
		format(string, sizeof(string), "{%06x}------------LEVEL 5 ADMIN COMMANDS------------", COLOR_GREEN >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /agive - /donationinfo - /motd(MSG.OF.THE.DAY) - /endround(RESTART) - /savestatsall");
		SendClientMessage(playerid, COLOR_RED, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /savestats - /set(trial)admin - /setvip - /(goto)pickups - /shopsys");
		SendClientMessage(playerid, COLOR_RED, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /spectators - /aturf - /aeo - /xyzlog - /kickall");
		SendClientMessage(playerid, COLOR_RED, string);
		format(string, sizeof(string), "[GEN.ADMIN]: /addrule - /removerule - /editrule - /maxplayersperip");
		SendClientMessage(playerid, COLOR_RED, string);
		format(string, sizeof(string), "[MISC]: /ns - /godcar - /modify - /quicksumo - /spincar - /setdrunk - /pdm");
		SendClientMessage(playerid, COLOR_RED, string);
		format(string, sizeof(string), "{%06x}++++++++++++++++++++++++++++++++++++++++++++++", COLOR_GREEN >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	return 1;
}
/*
CMD:ah(playerid, params[])
{
	new string[200];

	if(FoCo_Player[playerid][admin] >= 1)
	{
		format(string, sizeof(string), "[ALL]: {%06x}/a[chat] - /aduty", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 1]: {%06x}/goto - /get - /gotop - /gotols - /gotolv - /gotosf - /gotopickup - /gotoxyz - /setint - /setworld - /getploc", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 1]: {%06x}/arearm - /tempban - /cam - /gotocar - /despawncar - /warn - /kick - /jail - /ban - /fps - /wvs - /locip - /proxycheck", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 1]: {%06x}/banip - /unban - /unjail - /freeze - /unfreeze - /forcerules - /getxyz - /getip - /anticbug - /actog", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 1]: {%06x}/ss - /slap - /mark - /gotomark - /mute - /unmute - /spectate - /ann(ounce) - /event (start/end/setbrawlpoint/add)", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 1]: {%06x}/forceteam - /up - /down - /srw(SilentRemoveWpn) - /reports - /ar - /dr - /repair - /check - /as - /countdown - /ppk - /deathstreaks", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 1]: {%06x}/(given/taken)damage - /mark - /gotomark - /removeskin - /gotoclanspawn(/gcs) - /spawnplayer - /resetguns - /cam - /weapondamages", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 1]: {%06x}/pablog (PoorAimBot) - /pablist (PoorAimBot) - /maptp - /cwatch (C-BugWatch) - /watchrf (RapidFire) - /watchns(NoSpread) - /nslist", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	if(FoCo_Player[playerid][admin] >= 2)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "---------------------------------------------------------------------------------------------------------------------");
		format(string, sizeof(string),  "[Level 2]: {%06x}/bounty - /tod - /weather - /jetpack - /clearchat - /startvote - /endvote - /akill", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 2]: {%06x}/despawnallcars - /getcar - /sethp - /setarmour - /sslap - /sfreeze - /sunfreeze - /fixcar", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 2]: {%06x}/(p)cnn - /askydive - /antifall  - /removelocalweapons - /removewarn, /moveintocar", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	if(FoCo_Player[playerid][admin] >= 3)
	{
 		SendClientMessage(playerid, COLOR_SYNTAX, "---------------------------------------------------------------------------------------------------------------------");
		format(string, sizeof(string),  "[Level 3]: {%06x}/flip - /carcolor - /giveweapon - /setskin - /watchpm - /savestats - /savestatsall", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 3]: {%06x}/givelocalweapon - /setlocalhp - /setlocalarmour - /rha", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 3]: {%06x}/explode - /trans - /transpref - /transreset - /aveh - /acs", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 3]: {%06x}/watchteamchat - /superslap - /carownernamedb - /ahide - /disableloc - /aresetclasses", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 3]: {%06x}/setclanhealth - /setclanarmour - /removeclanweapons - /giveclanweapons - /getclan", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 3]: {%06x}/toggleac", COLOR_WHITE >>> 8);
	}
	if(FoCo_Player[playerid][admin] >= 4)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "---------------------------------------------------------------------------------------------------------------------");
		format(string, sizeof(string),  "[Level 4]: {%06x}/createcar - /deletecar - /setcar - /teleports - /changename - /ateam - /setstat - /onplayerdisconnectmsg", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 4]: {%06x}/connectbots - /disconnectbots - /resetkey - /noname - /removefromclan - /carcolour - /onplayerdeathmsg", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 4]: {%06x}/sethpall - /setarmourall - /giveallweapon - /togmain - /getall - /la - /resetstats", COLOR_WHITE >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	if(FoCo_Player[playerid][admin] >= 5)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "---------------------------------------------------------------------------------------------------------------------");
		format(string, sizeof(string),  "[Level 5]: {%06x}/setadmin - /sett(rial)admin - /setvip - /ns - /godcar - /pickups - /shopsys - /modify - /motd - /donationinfo", COLOR_RED >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 5]: {%06x}/endround - /asetstation(Testing Only) - /agive - /spectators - /aturf - /quicksumo - /eao - /spincar", COLOR_RED >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		format(string, sizeof(string),  "[Level 5]: {%06x}/xyzlog (Stores xyz to log file) - /pdm - /kickall - /addrule - /removerule - /editrule - /aturf - /setdrunk", COLOR_RED >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
	}
	return 1;
}
*/



//===================================[IRC]=================================================
#if defined PTS
	#define IRC_FOCO_ECHO_PASS "testingsucks"
	#define IRC_FOCO_ADMIN_PASS "testingsucks"
	#define IRC_FOCO_TRADMIN_PASS "testingsucks"
	#define IRC_FOCO_LEADS_PASS "testingsucks"
#else
	#define IRC_FOCO_ADMIN_PASS "SUg4Rt1ttYNhk"
	#define IRC_FOCO_ECHO_PASS "T3Vatch1Sr3l"
    #define IRC_FOCO_LEADS_PASS "M00senRacooN$"
    #define IRC_FOCO_TRADMIN_PASS "PlebYoGat4La#f"
#endif

