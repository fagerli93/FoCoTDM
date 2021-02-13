#define ADMIN_NICK_COLOR 0x587B9500
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD3 0xCBCCCEFF
#define COLOR_GRAD4 0xD8D8D8FF
#define COLOR_GRAD5 0xE3E3E3FF
#define COLOR_GRAD6 0xF0F0F0FF
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_LIME 0x10F441AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_FADE1 0xE6E6E6E6
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_FADE5 0x6E6E6E6E
#define COLOR_PURPLE 0xC2A2DAAA
#define COLOR_DBLUE 0x33CCFFAA
#define COLOR_ALLDEPT 0xFF8282AA
#define COLOR_MAGENTA 0xFF00FFFF
#define COLOR_PINK 0xFFC0CBAA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BLUE 0x0000BBAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_RED 0xFF6347AA
#define COLOR_LIME 0x10F441AA
#define COLOR_MAGENTA 0xFF00FFFF
#define COLOR_NAVY 0x000080AA
#define COLOR_AQUA 0xF0F8FFAA
#define COLOR_AQUA1 0xE2FFFFAA
#define COLOR_AQUA2 0xCCE6E6AA
#define COLOR_CRIMSON 0xDC143CAA
#define COLOR_FLBLUE 0x6495EDAA
#define COLOR_BISQUE 0xFFE4C4AA
#define COLOR_BLACK 0x000000AA
#define COLOR_CHARTREUSE 0x7FFF00AA
#define COLOR_BROWN 0XA52A2AAA
#define COLOR_CORAL 0xFF7F50AA
#define COLOR_GOLD 0xB8860BAA
#define COLOR_GREENYELLOW 0xADFF2FAA
#define COLOR_INDIGO 0x4B00B0AA
#define COLOR_IVORY 0xFFFF82AA
#define COLOR_LAWNGREEN 0x7CFC00AA
#define COLOR_SEAGREEN 0x20B2AAAA
#define COLOR_LIMEGREEN 0x32CD32AA
#define COLOR_MIDNIGHTBLUE 0x191970AA
#define COLOR_MAROON 0x800000AA
#define COLOR_OLIVE 0x808000AA
#define COLOR_ORANGERED 0xFF4500AA
#define COLOR_PINK 0xFFC0CBAA
#define COLOR_SPRINGGREEN 0x00FF7FAA
#define COLOR_TOMATO 0xFF6347AA
#define COLOR_YELLOWGREEN 0x9ACD32AA
#define COLOR_MEDIUMAQUA 0x83BFBFAA
#define COLOR_MEDIUMMAGENTA 0x8B008BAA
#define COLOR_BUSF 0xFBA16C00
#define COLOR_OOC 0xB0E2FFFF
#define COLOR_OOC2 0xCAE1FFFF
#define COLOR_GROVERS 0xBCED91FF
#define COLOR_BLACK_COLOR 0x28282800
#define OBJECTIVE_COLOR 0x64000064
#define TEAM_GREEN_COLOR 0xFFFFFF00
#define TEAM_GREEN10_COLOR 0xFFFFFF00
#define TEAM_PCSO_COLOR 0x87CEFA00
#define TEAM_BLUE_COLOR 0x8D8DFFC8
#define TEAM_BLUE1_COLOR 0x8D8DFF99
#define TEAM_BLUE2_COLOR 0x8D8DFF88
#define TEAM_BLUE3_COLOR 0x8D8DFF77
#define TEAM_BLUE4_COLOR 0x8D8DFF66
#define TEAM_BLUE5_COLOR 0x8D8DFF55
#define TEAM_BLUE6_COLOR 0x8D8DFF44
#define TEAM_BLUE7_COLOR 0x8D8DFF33
#define TEAM_BLUE8_COLOR 0x8D8DFF22
#define TEAM_BLUE9_COLOR 0x8D8DFF11
#define TEAM_BLUE10_COLOR 0x8D8DFF00
#define COLOR_ADD 0x63FF60AA
#define TEAM_CYAN_COLOR 0xFF828200
#define TEAM_GROVE_COLOR 0x00D900C8
#define TEAM_GROVE1_COLOR 0x00D90099
#define TEAM_GROVE2_COLOR 0x00D90088
#define TEAM_GROVE3_COLOR 0x00D90077
#define TEAM_GROVE4_COLOR 0x00D90066
#define TEAM_GROVE5_COLOR 0x00D90055
#define TEAM_GROVE6_COLOR 0x00D90044
#define TEAM_GROVE7_COLOR 0x00D90033
#define TEAM_GROVE8_COLOR 0x00D90022
#define TEAM_GROVE9_COLOR 0x00D90011
#define TEAM_GROVE10_COLOR 0x00D90000
#define TEAM_VAGOS_COLOR 0x5B0606C8
#define TEAM_VAGOS1_COLOR 0x5B060699
#define TEAM_VAGOS2_COLOR 0x5B060688
#define TEAM_VAGOS3_COLOR 0x5B060677
#define TEAM_VAGOS4_COLOR 0x5B060666
#define TEAM_VAGOS5_COLOR 0x5B060655
#define TEAM_VAGOS6_COLOR 0x5B060644
#define TEAM_VAGOS7_COLOR 0x5B060633
#define TEAM_VAGOS8_COLOR 0x5B060622
#define TEAM_VAGOS9_COLOR 0x5B060611
#define TEAM_VAGOS10_COLOR 0x5B060600
#define TEAM_AZTECAS_COLOR 0x01FCFFC8
#define ICRADIO_COLOR 0x59B5E6FF
#define ICRADIO2_COLOR 0xFFEC8BFF
#define TRIADS_COLOR 0xFFFF0000
#define COLOR_INVIS 0xAFAFAF00
#define COLOR_SPEC 0xBFC0C200
#define COLOR_NOTES 0xFFEC8BFF
#define COLOR_POKER 0x9dff96AA

enum pInfo
{
	pID,
	pUsername[128],
	pPassword[128],
	pCash,
	pAccount,
	pAdmin,
	pLevel,
	pExp,
	gPupgrade,
	pKills, // Weapon 2 gun
	pCB, // Weapon 2 ammo
	pCBn, //Changed-2
	lstam,
	pHW,//radio set 1/0
	pSR,//gun license
	pWA,//spawn gun
	pPEN,//spawn ammo
	pPENn,//Changed-1
	pGun1,//Crashed or no
	lstam2,
	pGun2,//license
	pGun3,//drugs
	pGun4,//how long online
	pGun5,//job
	pGun6,//materials
	pAmmo1,//for htiman kill
	pAmmo2,//now cards
	pAmmo3,//stunt level
	pAmmo4,//car parts
	pAmmo5,//motel
	pPapartkey,
	Float:pSHealth,
	Float:pHealth,
	Float:pPos_x,
	Float:pPos_y,
	Float:pPos_z,
	pInt,
	pLocal,
//  pTeam,
	pModel,
	pPnumber,
	pPhousekey,
	pPbiskey,
	pFamily,
	pFamilyRank,
	pHealthRegen,
	pLeaveJob,
	pJailTime,
	pSex,
//	pSkate,
	pCar,
	pMelee,
	pWorld,
	pLoggedin,
	pDonator,
	pStrength,
	pSavings,
	pReported,
	pHourson,
	pMatLoad,
	pWorkOn,
	pJobBonus,
	pCrimes,
	pPrison,
    pCharAccepted,
    pCarD,
	pOrigin[41],
	pGender[16],
	pBorned_year,
	pSession,
	pChatStyle,
	pWalkStyle,
	pHUDStyle,
	pAdutyTime,
	pChatTime,
	pSpawnSpot,
	pPropKey,
	pOldColor,
	isTalkingToHouse
};

new PlayerInfo[MAX_PLAYERS][pInfo];

enum factInfo
{
	Float:fSpawn1x,
	Float:fSpawn1y,
	Float:fSpawn1z,
	fSpawn1int,
	fSpawnWorld1,
	fRank1Name[64],
	fRank2Name[64],
	fRank3Name[64],
	fRank4Name[64],
	fRank5Name[64],
	fRank6Name[64],
	fRank7Name[64],
	fRank8Name[64],
	fRank9Name[64],
	fRank10Name[64],
	fRank1Skin,
	fRank2Skin,
	fRank3Skin,
	fRank4Skin,
	fRank5Skin,
	fRank6Skin,
	fRank7Skin,
	fRank8Skin,
	fRank9Skin,
	fRank10Skin,
	fLeader[64],
	fName[64],
	fAmountRanks,
	fHQint,
	fWomenSkin,
	fMaxMembers,
	Float:fSpawn2x,
	Float:fSpawn2y,
	Float:fSpawn2z,
	fSpawn2int,
	fSpawnWorld2,
	Float:fEntx,
	Float:fEnty,
	Float:fEntz,
	Float:fExitx,
	Float:fExity,
	Float:fExitz,
	fHQWorld,
	fFunds,
	fMembers,
	fColor[10],
	fGun1,
	fGun2,
	fAmmo1,
	fAmmo2,
	fDelivered,
	Float:fGatex,
	Float:fGatey,
	Float:fGatez,
	Float:fGateSx,
	Float:fGateSy,
	Float:fGateSz,
	Float:fGateRot,
	fGateModel,
	gateID,
	gateOpen,
	fMaxVehicles,
	fType,
	fChatOff
};
new FactionInfo[50][factInfo];

// Giacomand Note: Not sure this is the original name in LS-RP's headers since the link is broken.
new AvailableCars[] = {

560, // Sultan
579, // Huntley
445, // Admiral
405, // Sentinel
603, // Phoenix
402, // Buffalo
415, // Cheetah
480, // Comet
475, // Sabre
533, // Feltzer
567, // Savannah
566, // Tahoma
517, // Majestic
492, // Greenwood
412, // Voodoo
596, // Police cruiser
497, // Police helicopter
487, // Maverick
431, // Bus
438, // Cabbie
463, // Freeway
490, // FBI Rancher
525, // Towtruck
532, // Combine
534, // Remington
535, // Slamvan
559, // Jester
562, // Elegy
582, // News van
601, // SWAT van
454, // Tropic (boat)
416, // Ambulance
523, // Cop bike
427, // Enforcer
462, // Faggio
482, // Burrito
409, // Limo
496, // Blista
481, // BMX
426, // Premier
422, //Bobcat
554, //Yosemite
400, //Landstalker
600, //Picador
421, //Washington
474, //Hermes
491, //Virgo
589, //Club
408, //Trashmaster
423, //Mr. Whoopee
588, //Hotdog
446, //Squallo
//=======================//
404, //Perenniel
479, //Regina
467, //Oceanic
418, //Moonbeam
500, //Mesa
478, //Walton
561, //Stratum
458, //Solair
550, //Sunrise
419, //Esperanto
473, //Dinghy
453, //Reefer
586, //Wayfarer
483, //Camper
585, //Emperor
536, //Blade
545, //Hustler
575, //Broadway
489, //Rancher
549, //Tampa
508, //Journey
401, //Bravura
518, //Buccaneer
527, //Cadrona
542, //Clover
507, //Elegant
526, //Fortune
466, //Glendale
546, //Intruder
410, //Manana
551, //Merit
516, //Nebula
436, //Previon
547, //Primo
580, //Stafford
540, //Vincent
529, //Willard

598, //Police Car (LVPD)
599, //Police Ranger
563, //Raindancer
430, //Predator
417, //Leviathon
528, //FBI Truck
488, //SAN
420  //Taxi

};

new gTied[MAX_PLAYERS], gKilledWithGun[MAX_PLAYERS], gKnocked[MAX_PLAYERS], gPlayerLogged[MAX_PLAYERS];

stock GetClientName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	return name;
}

#define GetICName(%1) \
			GetClientName(%1)
			
#define GetIC2Name(%1) \
			GetClientName(%1)
			
#define CreateDynamicOjb(%1,%2,%3,%4,%5,%6,%7,%8)	/* modelid, Float:X, Float:Y, Float:Z, Float:rX, Float:rY, Float:rZ, titties*/ \
			CreateObject(%1, %2, %3, %4, %5, %6, %6)

#define SetDynamicObjectRot(%1, %2, %3, %4) /* objectid, Float:RotX, Float:RotY, Float:RotZ */ \
			SetObjectRot(objectid, RotX, RotY, RotZ)
			
#define GetUnixTime()	\
			gettime()

stock SetupPlayerMoney(playerid, money)
{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, money);
}	

stock GetPlayerRealMoney(playerid)
{
	GetPlayerMoney(playerid);
}

stock ProxDetector(Float:radi, playerid, string[], col1, col2, col3, col4, col5)
{
	new Float:posx, Float:posy, Float:posz;
	new Float:oldposx, Float:oldposy, Float:oldposz;
	new Float:tempposx, Float:tempposy, Float:tempposz;
	GetPlayerPos(playerid, oldposx, oldposy, oldposz);
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPlayerVirtualWorld(i)==GetPlayerVirtualWorld(playerid))
			{
				GetPlayerPos(i, posx, posy, posz);
				tempposx = (oldposx -posx);
				tempposy = (oldposy -posy);
				tempposz = (oldposz -posz);
				if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
					SendClientMessage(i, col1, string);
				else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
					SendClientMessage(i, col2, string);
				else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
					SendClientMessage(i, col3, string);
				else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
					SendClientMessage(i, col4, string);
				else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
					SendClientMessage(i, col5, string);
			}
		}
		else
			SendClientMessage(i,col1,string);
	}
	return 1;
}

stock strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}