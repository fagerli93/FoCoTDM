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
* Filename:  Dev_Callbacks.pwn                                                   *
* Author:    Marcel                                                              *
*********************************************************************************/
//TESTENTRY
/*
- Notes:
PlayerStatus - 0 normal, 1 in event, 2 Duel, 3 AFK
*/

/* Defines: Comment to disable */

// Add in here if only on the testserver
#if defined PTS
	#define RAKGUY_TESTDUEL
	//#define RAKGUY_WEAPDROP
	#define RAKGUY_TRUSTEDMEMBERS
	//#define RAKGUY_FPS_PING_TEXT
	#define RAKGUY_ASSISTK
	#define FLETCHER_GOTOP
	#define RAKGUY_ANIMLIST
	#define RAKGUY_NOTESYSTEM
#endif

#if !defined PTS
	#define CHILCODUEL
	#define FKUGOTOP
#endif

#define FKUTUTORIAL
#define VISTAHITSYSTEM
#define CHILCO_LOTTO
#define RAKVIPOBJECTS
#define CHILCOAMMUNATION

#define ANTIFAKEKILL
//#define FKUMUTELIST
#define VISTACAREP
#define FKULEVELS
#define FKUQSOUNDS
#define VISTAGOTOMARK
#define CLICKP
#define CHILCOHELPME
#define ANTICARWARP
#define VISTACAM

#define RAKTESTOBJ
#define RAKFIXCAR
#define RAKLOCVEH
#define RAKIPLOC
#define RAKCOUNTDOWN
#define RAKGUYIDLE
//#define RAKGUYTIMER
#define RAKGUYTSTOCK
#define RAKGUYSPEC
#define RAKGUYPOORAIM
//#define RAKGUYACBUG
#define RAKGUYCLANCMDS
//#define RAKGUYCHRISTMASGIFTS
#define RAKGUYCLICKMAPTP			// Added 04/01/2015 by pEar
#define RAKGUYARF					// Added 04/01/2015 by pEar
#define RAKGUY_TESTFILES			// Added 04/01/2015 by pEar	
#define RAKGUY_RAIN					// Added 04/01/2015 by pEar
#define RAKGUY_CSPREAD				// Added 06/01/2015 by pEar
#define RAKGUY_E_DEATHRACE			// Added 11/02/2015 by pEar
#define RAKGUY_REMOVEPLAYERWEAPON 	// Added 14/07/2015 by pEar
//#define RAKGUY_LAGCS				// Added 07/08/2015 by pEar
//#define RAKGUY_PROXYCHECK2
#define RAKGUY_ANTIDB
//#define RAKGUY_FOCOSERV 			//Added 18/01/2016 by RakGuy
#define RAKGUY_PROXYCHECK 			//Added 18/01/2016 by RakGuy
#define RAKGUY_TIMER 				//Added 18/01/2016 by RakGuy
#define RAKGUY_CEM 						//Edited by RakGuy
#define RAKGUY_SEARCHSTR 			//Added 24/01/2016 by RakGuy
#define RAKGUY_SILENTAIM 			//Added 26/01/2016 by RakGuy
#define RAKGUY_SWAPDETECTION 		//Added 26/01/2016 by RakGuy
#define RAKGUY_WEAPONIDS 			//Added 06/02/2016 by RakGuy
#define RAKGUY_TRIGGER 				//Added 22/03/2016 by RakGu
#define RAKGUY_SPREEH               //Added 19/04/2016 by RakGuy
//#define RAKGUY_CURREVENT			//Added 19/04/2016 by RakGuy      Shifted to event.pwn
#define RAKGUY_MULTIPLEGET
//#define RAKGUYFPK
//#define RAKGUY_CAMHACK            //Removed 06/06/2016 by RakGuy
//#define RAKGUY_SPAWNKILL          //Added 06/06/2016 by RakGuy || Removed 19/06/2016 by RakGuy
#define RAKGUY_CARMOD               //Added 06/06/2016 by RakGuy
#define RAKGUY_ARECORDLOAD               //Added 06/06/2016 by RakGuy
#define RAKGUY_TOGNAME               //Added 06/06/2016 by RakGuy
#define RAKGUY_EVENTLEADER               //Added 06/06/2016 by RakGuy
#define RAKGUY_FIRETP               //Added 06/06/2016 by RakGuy
#define RAKGUY_ALIAS               //Added 06/06/2016 by RakGuy
#define RAKGUY_JAILEVADE               //Added 06/06/2016 by RakGuy
#define RAKGUY_POPTYRE              //Added 23/06/2016 by RakGuy
#define RAKGUY_ACCCHECK              //Added 23/06/2016 by RakGuy
#define RAKGUY_PEAR_SKINS              //Added 23/06/2016 by RakGuy
#define RAKGUY_BUYSKINS              //Added 23/06/2016 by RakGuy
	
#define DUNK_DAMAGEVIEWER
#define DUNK_CLANCMDS

#define PEAR_BAN_HANDLER 			//
//#define PEAR_ACTIVITY_CHECKER
#define PEAREBET
#define PEARACHIEVEMENTS
//#define PEARPAYDAY
#define PEARADMSEC

#if !defined SERVERSIDED_HP
	#define PEARDAMAGEVIEWER		// Added 21.02.2015 by pEar
#endif

#define PEAR_MAXPLAYERSPERIP
#define PEAR_REPORTSYS 				// Added 14.07.2015 by pEar
#define PEAR_MUTESYS				// Added 15.07.2015 by pEar
//#define PEAR_CLANWARSYS			// Added 16.07.2015 by pEar
#define PEAR_PACKETLOSSKICKER		// Added 16.07.2015 by pEar
#define PEAR_DEVMESSAGES
#define PEAR_LASTCMDS
#define PEAR_STATIONS
//#define PEAR_TRIGGERBOT
#define PEAR_ACP 					// 06/11/2015 pEar
#define PEAR_UCP_UPDATES 			// 02/02/2016 pEar
#define PEAR_CHANGEPASS				// 13/07/2016 pEar

//#define CHILCOPROXYCHECK

//#define BIGDRULESCMD


//#define RICOCHETSYS
//#define FKUCEM
//#define FKUSHOWDMG
//#define KILLASSIST

/*
addons
*/

#if defined ANTIFAKEKILL
#include                        ".\systems\addons\Anti_FakeKill.pwn"
#endif

#if defined FKUMUTELIST
#include                        ".\systems\addons\FKu_Mutelist.pwn"
#endif

#if defined FKUTUTORIAL
#include                        ".\systems\addons\FKu_Tutorial.pwn"
#endif

#if defined FKUGOTOP
#include                        ".\systems\addons\FKu_Gotop.pwn"
#endif

#if defined VISTACAREP
#include                        ".\systems\addons\vista_carepackage.pwn"
#endif

#if defined FKULEVELS
#include                        ".\systems\addons\FKu_Levels.pwn"
#endif

#if defined RICOCHETSYS
#include                        ".\systems\addons\RicochetSys.pwn"
#endif


/*
FKu
*/
#if defined FKUCEM
#include                        ".\systems\FKu\FKu_CEM.pwn"
#endif

#if defined FKUQSOUNDS
#include                        ".\systems\FKu\FKu_QuakeSounds.pwn"
#endif

#if defined FKUSHOWDMG
#include                        ".\systems\FKu\FKu_ShowDmg.pwn"
#endif


/*
dr_vista
*/
#if defined VISTAGOTOMARK
#include                        ".\systems\vista\vistagotomark.pwn"
#endif

#if defined VISTAHITSYSTEM
#include						".\systems\vista\hitsystem.pwn"
#endif

#if defined CLICKP
#include						".\systems\vista\clickplayer.pwn"
#endif

#if defined VISTACAM
#include                        ".\systems\camsystem.pwn"
#endif

/*
Chilco
*/
#if defined CHILCOHELPME
#include                        ".\systems\Chilco\chilco_helpme.pwn"
#endif

#if defined ANTICARWARP
#include                        ".\systems\Chilco\chilco_anticarwarp.pwn"
#endif

#if defined KILLASSIST
#include  						".\systems\Chilco\chilco_killassist.pwn"
#endif

#if defined CHILCODUEL
#include                        ".\systems\RakGuy\BugFix\Chilco_duel.pwn"
#endif

#if defined CHILCOAMMUNATION
#include                        ".\systems\Chilco\chilco_ammunation.pwn"
#endif

#if defined CHILCO_LOTTO
#include                        ".\systems\Chilco\chilco_lotto.pwn"
#endif

#if defined CHILCOPROXYCHECK
#include                        ".\systems\Chilco\chilco_proxycheck.pwn"
#endif



/*
DUNK
*/

#if defined DUNK_DAMAGEVIEWER
#include                        ".\systems\Dunk\DamageViewer.pwn"
#endif
#if defined DUNK_CLANCMDS
#include                        ".\systems\Dunk\cbu.pwn"
#endif

/*
RakGuy
*/
#if defined RAKVIPOBJECTS
#include                        ".\systems\RakGuy\skinmod.pwn"
#endif
#if defined RAKTESTOBJ
#include                        ".\systems\RakGuy\testobjects.pwn"
#endif
#if defined RAKLOCVEH
#include                        ".\systems\RakGuy\LocalVehicle.pwn"
#endif
#if defined RAKFIXCAR
#include                        ".\systems\RakGuy\FixCar.pwn"
#endif
#if defined RAKIPLOC
#include                        ".\systems\RakGuy\IPLoc.pwn"
#endif
#if defined RAKCOUNTDOWN
#include                        ".\systems\RakGuy\countdown.pwn"
#endif
#if defined RAKGUY_CEM
#include                        ".\systems\RakGuy\CEMv1.pwn"
#endif
#if defined RAKGUYIDLE
#include 						".\systems\RakGuy\Idle.pwn"
#endif
#if defined RAKGUYTIMER
#include 						".\systems\RakGuy\Timer.pwn"
#endif
#if defined RAKGUYTSTOCK
#include 						".\systems\RakGuy\TStock.pwn"
#endif
#if defined RAKGUYSPEC
#include						".\systems\RakGuy\Spec.pwn"
#endif
#if defined RAKGUYPOORAIM
#include 						".\systems\RakGuy\Poor_Aim_New.pwn"
#endif
#if defined RAKGUYACBUG
#include 						".\systems\RakGuy\ACBug_N.pwn"
#endif
#if defined RAKGUYCLANCMDS
#include						".\systems\RakGuy\Clan_Cmds.pwn"
#endif
#if defined RAKGUYCHRISTMASGIFTS
#include 						".\systems\RakGuy\cSaver_BUGFIX.pwn"
#endif
#if defined RAKGUYCLICKMAPTP
#include 						".\systems\RakGuy\ClickMapTP.pwn"
#endif
#if defined RAKGUY_CSPREAD
#include 						".\systems\RakGuy\cspreads.pwn"
#endif
#if defined RAKGUYARF
#include 						".\systems\RakGuy\arf.pwn"
#endif
#if defined RAKGUYPROXY
#include 						".\systems\RakGuy\proxy.pwn"
#endif
#if defined RAKGUY_TESTFILES
#include 						".\systems\RakGuy\RakGuy_testfiles.pwn"
#endif	
#if defined RAKGUY_RAIN
#include 						".\systems\RakGuy\rain.pwn"
#endif
#if defined RAKGUY_E_DEATHRACE
#include 						".\systems\RakGuy\TestFiles\DeathRaceEvent.pwn"
#endif
#if defined RAKGUY_REMOVEPLAYERWEAPON
#include 						".\systems\RakGuy\rw.pwn"
#endif
#if defined RAKGUY_LAGCS
#include 						".\systems\RakGuy\lagcs.pwn"
#endif
#if defined RAKGUY_PROXYCHECK2
#include 						".\systems\RakGuy\proxycheck.pwn"
#endif
#if defined RAKGUY_ANTIDB
#include 						".\systems\RakGuy\antidb.pwn"
#endif
//New Tests for Rev 994/+ by RakGuy
#if defined RAKGUY_FOCOSERV
#include 						".\systems\RakGuy\foco_servers.pwn"
#endif
#if defined RAKGUY_PROXYCHECK
#include 						".\systems\RakGuy\proxycheck.pwn"
#endif
#if defined RAKGUY_TIMER
#include 						".\systems\RakGuy\Timer.pwn"
#endif
#if defined RAKGUY_SEARCHSTR
#include 						".\systems\RakGuy\searchstring.pwn"
#endif
#if defined RAKGUY_SILENTAIM
#include 						".\systems\RakGuy\sa.pwn"
#endif
#if defined RAKGUY_SWAPDETECTION
#include 						".\systems\RakGuy\swap.pwn"
#endif
#if defined RAKGUY_WEAPONIDS
#include 						".\systems\RakGuy\weaponids.pwn"
#endif
#if defined RAKGUY_TESTDUEL
#include 						".\systems\RakGuy\testfiles\duel_new.pwn"
#endif
#if defined RAKGUY_SPAWNKILL
#include 						".\systems\RakGuy\SpawnKill.pwn"
#endif
#if defined SERVERSIDED_HP
#include 						".\systems\RakGuy\testfiles\sshp.pwn"
#include 						".\systems\RakGuy\testfiles\sshp_opwsfuncs.pwn"
#endif
#if defined RAKGUY_TRIGGER
#include 						".\systems\RakGuy\testfiles\trigger.pwn"
#endif
#if defined RAKGUY_SPREEH
#include 						".\systems\RakGuy\streakhelp.pwn"
#endif
#if defined RAKGUY_CURREVENT
#include 						".\systems\RakGuy\testfiles\currentevent.pwn"
#endif
#if defined RAKGUY_MULTIPLEGET
#include 						".\systems\RakGuy\testfiles\multipleget.pwn"
#endif
#if defined RAKGUYFPK
#include 						".\systems\RakGuy\testfiles\FPK.pwn"
#endif
#if defined RAKGUY_WEAPDROP
#include 						".\systems\RakGuy\testfiles\dropweap_arm.pwn"
#endif
#if defined RAKGUY_CAMHACK
#include 						".\systems\RakGuy\testfiles\camhack.pwn"
#endif
#if defined RAKGUY_TRUSTEDMEMBERS
#include 						".\systems\RakGuy\testfiles\trustedmembers.pwn"
#endif
#if defined RAKGUY_CARMOD
#include 						".\systems\RakGuy\testfiles\car_mod_list.pwn"
#include 						".\systems\RakGuy\testfiles\MOD_SQL.pwn"
#endif
#if defined RAKGUY_ARECORDLOAD
#include 						".\systems\RakGuy\testfiles\loadarecord.pwn"
#endif
#if defined RAKGUY_FPS_PING_TEXT
#include 						".\systems\RakGuy\testfiles\fpt.pwn"
#endif
#if defined RAKGUY_TOGNAME
#include 						".\systems\RakGuy\testfiles\nametag.pwn"
#endif
#if defined RAKGUY_EVENTLEADER
#include 						".\systems\RakGuy\testfiles\event_leader.pwn"
#endif
#if defined RAKGUY_FIRETP
#include 						".\systems\RakGuy\testfiles\fireTP.pwn"
#endif
#if defined RAKGUY_ALIAS
#include 						".\systems\RakGuy\testfiles\alias.pwn"
#endif
#if defined RAKGUY_JAILEVADE
#include 						".\systems\RakGuy\testfiles\jailevade.pwn"
#endif
#if defined RAKGUY_POPTYRE
#include 						".\systems\RakGuy\testfiles\poptyre.pwn"
#endif
#if defined RAKGUY_ASSISTK
#include 						".\systems\RakGuy\testfiles\assistkill.pwn"
#endif
#if defined RAKGUY_ACCCHECK
#include 						".\systems\RakGuy\testfiles\useraccountcheck.pwn"
#endif
#if defined RAKGUY_PEAR_SKINS
#include 						".\systems\RakGuy\BugFix\pEar_skins.pwn"
#endif
#if defined RAKGUY_BUYSKINS
#include 						".\systems\RakGuy\testfiles\buyskin.pwn"
#endif

#if defined RAKGUY_ANIMLIST
#include 						".\systems\RakGuy\testfiles\animlist.pwn"
#endif
#if defined RAKGUY_NOTESYSTEM
#include 						".\systems\RakGuy\testfiles\notes.pwn"
#endif
/*
pEar
*/
#if defined PEAREBET
#include                        ".\systems\pEar\EventBet.pwn"
#endif
#if defined PEARACHIEVEMENTS
#include                        ".\systems\pEar\pEar_Achievements.pwn"
#endif
#include                        ".\systems\pEar\unixtime.pwn"
#if defined PEARPAYDAY
#include 						".\systems\pEar\pEar_PayDay.pwn"
#endif
#if defined PEAR_ACTIVITY_CHECKER
#include						".\systems\pEar\pEar_ActivityChecker.pwn"
#endif
#if defined PEARADMSEC
#include 						".\systems\pEar\pEar_AdminSecurity.pwn"
#endif
#if defined PEARDAMAGEVIEWER
#include 						".\systems\pEar\pEar_DamageViewer.pwn"
#endif
#if defined PEAR_MAXPLAYERSPERIP
#include 						".\systems\pEar\pEar_MaxPlayersPerIP.pwn"
#endif
#if defined PEAR_RELOADBANS
#include 						".\systems\pEar\pEar_ReloadBans.pwn"
#endif	
#if defined PEAR_BAN_HANDLER
#include 						".\systems\pEar\pEar_BanHandler.pwn"
#endif
#if defined PEAR_REPORTSYS
#include 						".\systems\pEar\pEar_ReportSys.pwn"
#endif
#if defined PEAR_MUTESYS
#include 						".\systems\pEar\pEar_mute.pwn"
#endif
#if defined PEAR_CLANWARSYS
#include 						".\systems\pEar\pEar_ClanWar.pwn"
#endif
#if defined PEAR_PACKETLOSSKICKER
#include 						".\systems\pEar\pEar_PacketLossAutoKicker.pwn"
#endif
#if defined PEAR_DEVDEBUGS
#include 						".\systems\pEar\pEar_DevDebugs.pwn"
#endif
#if defined PEAR_DEVMESSAGES
#include 						".\systems\pEar\pEar_DevMessages.pwn"
#endif
#if defined PEAR_LASTCMDS
#include 						".\systems\pEar\pEar_CommandWatch.pwn"
#endif
#if defined PEAR_SKINS
#include 						".\systems\pEar\pEar_skins.pwn"
#endif
#if defined PEAR_TRIGGERBOT
#include 						".\systems\pEar\pEar_TriggerBot.pwn"
#endif
#if defined PEAR_STATIONS
#include 						".\systems\pEar\pEar_Stations.pwn"
#endif
#if defined PEAR_ACP
#include 						".\systems\pEar\pEar_ACP.pwn"
#endif
#if defined PEAR_UCP_UPDATES
#include 						".\systems\pEar\pEar_UCP_UpdateData.pwn"
#endif
#if defined PEAR_CHANGEPASS
#include 						".\systems\pEar\pEar_ChangePassEmail.pwn"
#endif			

//FLETCHER's CODES
#if defined FLETCHER_GOTOP
#include 						".\systems\Fletcher\gotop.pwn"
#endif

