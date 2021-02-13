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
* Filename: FKu_gotop.pwn                                                        *
* Author: pEar?                                                                  *
*********************************************************************************/
#include <YSI\y_hooks>
#define MAX_TP_NAME 20
new gstr[129];

enum exEn
{
	exName[MAX_TP_NAME],
	Float:exPos[3],
}
new const LSArray[][exEn] = //LOS SANTOS
{//   NAME                X        Y       Z
	{"Airport", {1919.1832,-2426.6667,13.5391}},
	{"Abandoned pier", {833.3463,-2062.1094,12.8672}},
	{"ASGH", {1186.1935,-1323.7750,13.5591}},
	{"BB Apartment", {193.5043,-107.9239,1.5494}},
	{"BB Farm", {-55.3739,7.5705,3.1172}},
	{"BB Woods", {-534.9530,-175.8594,78.4047}},
	{"Bank", {589.4120,-1237.1758,17.8538}},
	{"Beach parking", {333.5710,-1800.8680,4.6548}},
	{"Dillimore", {633.4914,-571.7029,16.3359}},
	{"El Corona", {1884.2126,-2032.8379,13.3906}},
	{"EC Dead-End", {1693.7479,-2113.3591,13.3828}},
	{"Fishing pier", {383.7556,-2078.2415,7.8359}},
	{"Garage", {1529.2799,-1670.6650,6.2188}},
	{"Ganton gym", {2225.4790,-1724.3229,13.5629}},
	{"Groove street", {2513.0276,-1673.4939,13.5177}},
	{"Graveyard", {919.8347,-1101.9336,24.2908}},
	{"Glen park", {1970.1521,-1143.1650,25.8047}},
	{"Hunting cabin", {2361.2678,-655.5005,128.0619}},
	{"Hilltop farm", {1043.8314,-338.2837,73.9922}},
	{"Idlegas", {1954.7271,-1773.5103,13.5469}},
	{"Idlepizza", {2113.3887,-1780.8114,13.3891}},
	{"Jefferson motel", {2223.9778,-1159.3099,25.7461}},
	{"Jefferson church", {2217.0688,-1344.3031,23.9843}},
	{"Las Colinas Hill", {2550.4636,-970.4691,82.3126}},
	{"Lighthouse", {155.3284,-1961.1338,3.7734}},
	{"Las Colinas", {2173.8271,-1000.1455,62.9690}},
	{"Mulholland parking", {1648.1420,-1048.7286,23.8984}},
	{"Marina Canal", {726.9936,-1436.8564,13.5391}},
	{"Main street", {1365.6711,-1279.7058,13.5469}},
	{"Mall", {1129.6412,-1460.5597,15.7969}},
	{"Montgomery", {1250.0557,180.9534,19.5547}},
	{"Ocean docks", {2491.1096,-2669.0549,13.6328}},
	{"Pershing Square", {1542.9431,-1674.2968,13.5555}},
	{"Parking lot E-LS", {2800.0076,-1441.1334,40.0507}},
	{"Palomino creek", {2274.7595,-86.7986,26.4964}},
	{"Rodeo motel", {331.2349,-1514.1139,35.8672}},
	{"Sixth street", {2430.1785,-1234.1687,24.7905}},
	{"Santa Maria Beach", {576.1298,-1868.2877,4.3852}},
	{"Skatepark", {1910.5310,-1408.3129,13.5703}},
	{"SAN Tower", {1544.7054,-1353.1078,329.4747}},
	{"Star factory", {920.1529,-1219.3483,16.9766}},
	{"Seville", {2707.1086,-1996.6086,13.5547}},
	{"SWAT", {-508.1007,2592.9358,53.4154}},
	{"Unity", {1837.8876,-1859.7657,13.3828}},
	{"Vinewood Mansion", {1281.0676,-828.3901,83.1406}},
	{"Vinewood gas", {1004.8558,-947.7883,42.1871}},
	{"Verdant Bluffs", {1133.6212,-2036.8741,69.0078}}
};

new const SFArray[][exEn] = //SAN FIERRO
{//   NAME                X        Y       Z
	{"Angel Pine Factory", {-1967.0944,-2448.7295,30.6250}},
	{"Alley Chinatown", {-2212.0271,594.5231,35.1641}},
	{"Alley", {-2460.6013,-122.0931,25.8095}},
	{"Airport", {-1302.5625,-187.1935,14.1484}},
	{"Bayside", {-2508.9556,2428.3752,16.5998}},
	{"Bayside mountain", {-2873.7842,2805.5688,251.1867}},
	{"Baseball field", {-2307.2419,207.1387,35.3516}},
	{"Boat dock", {-2963.8647,472.5854,4.9141}},
	{"Chilliad(Bottom)", {-2390.7061,-2203.4575,33.2891}},
	{"Chilliad(Top)", {-2326.5903,-1609.4547,483.7431}},
	{"Chill Construction", {-1902.6200,-1720.1105,21.7500}},
	{"Cargo boat(Outside)", {-2313.1062,1543.6060,18.7734}},
	{"Cargo boat(Inside)", {-2426.5432,1546.7345,2.1172}},
	{"City hall", {-2706.2339,376.6865,4.9683}},
	{"Crane", {-1579.1125,90.0886,3.5547}},
	{"Carrier", {-1349.1072,505.3344,18.2344}},
	{"Car seller", {-1629.6910,1216.1436,7.0391}},
	{"Car park", {-1809.7384,1302.4053,59.7344}},
	{"Doherty Cars", {-1977.6112,286.9660,35.1719}},
	{"Doherty Contruction", {-2074.7256,210.9647,35.4195}},
	{"Donut shop", {-2757.4788,787.5327,53.8961}},
	{"Flint Tolls Camping", {-80.5074,-1571.6448,2.6107}},
	{"Golf", {-2468.8301,-259.0428,39.5442}},
	{"Gold delivery", {-2423.3230,515.2225,29.9297}},
	{"Hospital", {-2659.5378,608.3724,14.4531}},
	{"Hill sprint(Bottom)", {-2453.0596,1000.7522,46.9147}},
	{"Hill sprint(Top)", {-2492.2964,1002.9059,78.3594}},
	{"Missionary Hill", {-2519.1033,-614.0192,132.5625}},
	{"Parking lot(Queen)", {-2508.8752,352.7957,35.1172}},
	{"San Fierro PD", {-1598.1063,661.6432,7.1875}},
	{"3x S-turn", {-2014.5630,922.5939,45.2969}}
};

new const LVArray[][exEn] = //LAS VENTURAS
{//   NAME                X        Y       Z
	{"Big jump", {-719.7022,2320.6563,127.2614}},
	{"Ghost town", {-388.2978,2278.5291,41.0573}},
	{"Abandoned airport", {406.1753,2519.0723,16.4844}},
	{"Area 51", {173.5986,1908.6895,18.2220}},
	{"Satellitt station", {-293.0257,1565.1044,75.3594}},
	{"Navn", {93.1236,1195.7739,18.3287}},
	{"Airport", {1527.0692,1588.0990,10.8203}},
	{"LV", {1703.4346,1452.8380,10.8110}},
	{"Pirateship", {2003.8439,1544.1406,13.5908}},
	{"Emerald isle", {2061.8511,2434.3425,10.8203}},
	{"Emerald isle(Top)", {2107.2041,2428.7881,60.8169}}
};

//INTERIOR POSITIONS
enum inEn
{
	inName[MAX_TP_NAME],
	Float:inPos[3],
	inInt
}
new const InteriorArray[][inEn] =
{//   NAME                X        Y       Z     INTERIOR
	{"Area 51", {223.431976,1872.400268,13.734375}, 0},
	{"Alhambra",    {487.4,-14.0,1000.6}, 17},
	{"Ammunation", {286.148986,-40.644397,1001.515625}, 1},
	{"Binco", {207.737991,-109.019996,1005.132812}, 15},
	{"Bar", {501.980987,-69.150199,998.757812}, 11},
	{"Burger shot", {375.962463,-65.816848,1001.507812}, 10},
	{"Barn", {291.282989,310.031982,999.148437}, 3},
	{"Bloodbowl", {-1398.103515,937.631164,1036.479125}, 15},
	{"Bank", {2315.952880,-1.618174,26.742187}, 0},
	{"Cluckin' Bell", {369.579528,-4.487294,1001.858886}, 9},
	{"Crack factory", {2543.462646,-1308.379882,1026.728393}, 2},
	{"Crack den", {318.564971,1118.209960,1083.882812}, 5},
	{"Dirt track", {-1444.645507,-664.526000,1053.572998}, 4},
	{"Fetish room", {346.870025,309.259033,999.155700}, 6},
	{"Ganton gym", {772.111999,-3.898649,1000.728820}, 5},
	{"Jefferson motel", {22215.454833,-1147.475585,1025.796875}, 15},
	{"Nice house", {2324.419921,-1145.568359,1050.710083}, 12},
	{"Motel room", {444.646911,508.239044,1001.419494}, 12},
	{"Mansion", {1267.663208,-781.323242,1091.906250}, 5},
	{"Motel", {1710.433715,-1669.379272,20.225049}, 18},
	{"PD-SF", {246.375991,109.245994,1003.218750}, 10},
	{"PD-SF 2. Floor", {231.9055,79.4732,1016.8516}, 10},
	{"PD-SF Gym", {235.7924,90.4112,1024.4834}, 10},
	{"PD-LS", {246.783996,63.900199,1003.640625}, 6},
	{"PD-LV", {288.745971,169.350997,1007.171875}, 3},
	{"PD precinct", {322.197998,302.497985,999.148437}, 5},
	{"Pizza", {373.825653,-117.270904,1001.499511}, 5},
	{"RC Battleground", {-975.975708,1060.983032,1345.671875}, 10},
	{"Sex shop", {-103.559165,-24.225606,1000.718750}, 3},
	{"Slaughter house", {963.418762,2108.292480,1011.030273}, 1},
	{"Small room", {244.411987,305.032989,999.148437}, 1},
	{"Small room1", {271.884979,306.631988,999.148437}, 2},
	{"Small room2", {302.180999,300.722991,999.148437}, 4},
	{"Small room3", {1527.229980,-11.574499,1002.097106}, 3},
	{"Strip club", {1204.809936,-11.586799,1000.921875}, 2},
	{"Stunt", {-1465.268676,1557.868286,1052.531250}, 14},
	{"SAN", {384.808624,173.804992,1008.382812}, 3},
	{"Sherman dam", {-959.564392,1848.576782,9.000000}, 17},
	{"Pleasure domes", {-2640.762939,1406.682006,906.460937}, 3},
	{"Gang house", {2350.339843,-1181.649902,1027.976562}, 5},
	{"Warehouse", {1302.519897,-1.787510,1001.028259}, 18},
	{"Warehouse1", {1059.895996,2081.685791,10.820312}, 0},
	{"8-track", {-1398.065307,-217.028900,1051.115844}, 7},
	{"24/7", {-25.884498,-185.868988,1003.546875}, 17},
	{"Test harvey", {249.09960938,86.79980469,1021.00000000}, 10}
};


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    print("ODR_FKU_Gotop");
	switch(dialogid)
	{
		case DIALOG_TP_MAIN: //menu
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: //LS
					{
						//make string
						new string[sizeof(LSArray)*MAX_TP_NAME];
						strmid(string,LSArray[0][exName],0,MAX_TP_NAME+1,MAX_TP_NAME+1);
						for(new i=1; i<sizeof(LSArray); i++)
						{
							format(gstr,MAX_TP_NAME+4,"\n%s",LSArray[i][exName]);
							strcat(string,gstr);
						}
						//showdialog
						ShowPlayerDialog(playerid,DIALOG_TP_EX,DIALOG_STYLE_LIST,"TELEPORTS - LOS SANTOS",string,"Goto","Cancel");
						SetPVarInt(playerid,"tptype",1);
					}
					case 1: //SF
					{
						//make string
						new string[sizeof(SFArray)*MAX_TP_NAME];
						strmid(string,SFArray[0][exName],0,MAX_TP_NAME+1,MAX_TP_NAME+1);
						for(new i=1; i<sizeof(SFArray); i++)
						{
							format(gstr,MAX_TP_NAME+4,"\n%s",SFArray[i][exName]);
							strcat(string,gstr);
						}
						//showdialog
						ShowPlayerDialog(playerid,DIALOG_TP_EX,DIALOG_STYLE_LIST,"TELEPORTS - SAN FIERRO",string,"Goto","Cancel");
						SetPVarInt(playerid,"tptype",2);
					}
					case 2: //LV
					{
						//make string
						new string[sizeof(LVArray)*MAX_TP_NAME];
						strmid(string,LVArray[0][exName],0,MAX_TP_NAME+1,MAX_TP_NAME+1);
						for(new i=1; i<sizeof(LVArray); i++)
						{
							format(gstr,MAX_TP_NAME+4,"\n%s",LVArray[i][exName]);
							strcat(string,gstr);
						}
						//showdialog
						ShowPlayerDialog(playerid,DIALOG_TP_EX,DIALOG_STYLE_LIST,"TELEPORTS - LAS VENTURAS",string,"Goto","Cancel");
						SetPVarInt(playerid,"tptype",3);
					}
					case 3: //interior
					{
						//make string
						new string[sizeof(InteriorArray)*MAX_TP_NAME];
						strmid(string,InteriorArray[0][inName],0,MAX_TP_NAME+1,MAX_TP_NAME+1);
						for(new i=1; i<sizeof(InteriorArray); i++)
						{
							format(gstr,MAX_TP_NAME+4,"\n%s",InteriorArray[i][inName]);
							strcat(string,gstr);
						}
						//showdialog
						ShowPlayerDialog(playerid,DIALOG_TP_INT,DIALOG_STYLE_LIST,"TELEPORTS - INTERIORS",string,"Goto","Cancel");
					}
				}
			}
		}
		case DIALOG_TP_INT: //interior teleport
		{
			if(response)
			{
				SetPlayerPos(playerid,InteriorArray[listitem][inPos][0],InteriorArray[listitem][inPos][1],InteriorArray[listitem][inPos][2]);
				SetPlayerInterior(playerid,InteriorArray[listitem][inInt]);
				GameTextForPlayer(playerid,"~g~TELEPORTED",3000,4);
			}
		}
		case DIALOG_TP_EX: //exterior teleport
		{
			if(response)
			{
				switch(GetPVarInt(playerid,"tptype"))
				{
					case 1: SetPlayerPos(playerid,LSArray[listitem][exPos][0],LSArray[listitem][exPos][1],LSArray[listitem][exPos][2]);//LS
					case 2: SetPlayerPos(playerid,SFArray[listitem][exPos][0],SFArray[listitem][exPos][1],SFArray[listitem][exPos][2]);//SF
					case 3: SetPlayerPos(playerid,LVArray[listitem][exPos][0],LVArray[listitem][exPos][1],LVArray[listitem][exPos][2]);//LV				}
				}
				SetPlayerInterior(playerid,0);
				GameTextForPlayer(playerid,"~g~TELEPORTED",3000,4);
			}
		}
	}
	return 1;
}
CMD:gotop(playerid,params[])
{
    if(FoCo_Player[playerid][admin] < 1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not authorized to use this command.");
		return 1;
	}
	ShowPlayerDialog(playerid,DIALOG_TP_MAIN,DIALOG_STYLE_LIST,"TELEPORTS","Los Santos\nSan Fierro\nLas Venturas\nInterior positions","Select","Cancel");
	return 1;
}
