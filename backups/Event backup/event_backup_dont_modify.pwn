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
*                                                                                *
*			######## ##     ## ######## ##    ## ########  ######                *
*			##       ##     ## ##       ###   ##    ##    ##    ##               *
*			##       ##     ## ##       ####  ##    ##    ##                     *
*			######   ##     ## ######   ## ## ##    ##     ######                *
*			##        ##   ##  ##       ##  ####    ##          ##               *
*			##         ## ##   ##       ##   ###    ##    ##    ##               *
*			########    ###    ######## ##    ##    ##     ######                *
*                                                                                *
*                                                                                *
*                        (c) Copyright                                           *
*  Owners: Simon Fagerli (pEar) - Lee Percox (Shaney) - Warren Bickley (WazzaJB) *
*         Developers: Marcel, RakGuy, FKu, Chilco, dr_vista, Fletcher            *
*                                                                                *
* Filename: events.pwn                                                           *
* Author: Marcel & dr_vista                                                      *
*********************************************************************************/

/* TO DO:

	- Add Gun Game
	
	- Put a different V-World for army vs terrorists
	-Navy seals event doesnt end when the last (second last player) suicided
	- you are already at the event during a rejoinable event when a player died and tried to rejoin
*/

/* Event types:

	- FFA
	- TDM
	- Sumo
	- Pursuit
	- Races
*/

/* Events list:

	- FFA:

		- Mad Dogg's Mansion
		- Big Smoke
		- Minigun Wars
		- Brawl
		- Hydra Wars
		- Gun Game

	- TDM:

		- Jefferson Motel
		- Area 51
		- Army vs. Terrorists
		- Navy Seals vs. Terrorists (Ship)
		- Compound Attack
		- Oil Rig Terrorists
		- Team Drug Run

	- Sumo:

	    - Monster Sumo
	    - Banger Sumo
	    - SandKing Sumo
	    - SandKing Sumo (Reloaded)
	    - Destruction Derby

	- Pursuit:

		- Pursuit

	- Races:

		- TBA



*/

/* File Structure

	\events
	|
	|	events.pwn
	|
 	|	\subfiles
 	|   |
	|	|    area51.pwn
	|	|    armyvsterrorists.pwn
	|	|    bigsmoke.pwn
	|	|    brawl.pwn
	|   |    compound.pwn
	|   |    drugrun.pwn
	|   |    hydra.pwn
	|   |    jefftdm.pwn
	|   |    md.pwn
    |   |    minigun.pwn
    |   |    navyvsterrorists.pwn
    |   |    oilrig.pwn
    |   |    pursuit.pwn
    |   |    SUMO.pwn
    |


*/

/* Structure:

	- Includes
	- Defines
	- Forwards
	- Enumerations
	- Variables
	- Callbacks
	- Functions
	- Commands
*/
#define MAX_EVENT_PLAYERS 30
#define EVENTLIST "Mad Dogg's Mansion\nBig Smoke\nMinigun Wars\nBrawl\nHydra Wars\nGun Game\nJefferson Motel TDM\nArea 51 TDM\nArmy vs. Terrorists\nNavy Seals vs. Terrorists\nCompound Attack\nOil Rig Terrorists\nTeam Drug Run\nMonster Sumo\nBanger Sumo\nSandKing Sumo\nSandKing Sumo (Reloaded)\n Destruction Derby\nPursuit"

#define MAX_EVENTS 19
#define MAX_EVENT_VEHICLES 30

#define SUMO_EVENT_SLOTS 15
#define AREA51_EVENT_SLOTS 42
#define ARMY_EVENT_SLOTS 18
#define COMPOUND_EVENT_SLOTS 32
#define DRUGRUN_EVENT_SLOTS 58
#define HYDRA_EVENT_SLOTS 11
#define JEFFTDM_EVENT_SLOTS 28
#define MINIGUN_EVENT_SLOTS 16
#define SEALS_EVENT_SLOTS 31
#define OILRIG_EVENT_SLOTS 32
#define PURSUIT_EVENT_SLOTS 10

#define VIP_EVENT_SLOTS 2

enum events
{
	eventID,
	eventName[30]
};

new const event_IRC_Array[MAX_EVENTS][ events ] = {
 {0, "Mad Doggs Mansion"},
 {1, "Bigsmoke"},
 {2, "Minigun Wars"},
 {3, "Brawl"},
 {4, "Hydra Wars"},
 {5, "Gun Game"},
 {6, "Jefferson TDM"},
 {7, "Area 51 TDM"},
 {8, "Army vs. Terrorists"},
 {9, "Navy Seals Vs. Terrorists"},
 {10, "Compound Attack"},
 {11, "Oil Rig Terrorists"},
 {12, "Team Drug Run"},
 {13, "Monster Sumo"},
 {14, "Banger Sumo"},
 {15, "SandKing Sumo"},
 {16, "SandKing Sumo Reloaded"},
 {17, "Destruction Derby"},
 {18, "Pursuit"}
};
/* Enumerations */

	/* Master event enum */

enum
{
	MADDOGG,
	BIGSMOKE,
	MINIGUN,
	BRAWL,
	HYDRA,
	GUNGAME,
	JEFFTDM,
	AREA51,
	ARMYVSTERRORISTS,
	NAVYVSTERRORISTS,
	COMPOUND,
	OILRIG,
	DRUGRUN,
	MONSTERSUMO,
	BANGERSUMO,
	SANDKSUMO,
	SANDKSUMORELOADED,
	DESTRUCTIONDERBY,
	PURSUIT
};

	/* Drug Run */

enum e_DrugRunVehicles
{
	modelID,
	Float:dX,
	Float:dY,
	Float:dZ,
	Float:Rotation
};

/* Variables */

	/* Master event variables */

new
	Event_Players[MAX_PLAYERS],
	Iterator:Event_Vehicles<50>;

new
	Event_InProgress = -1;

 /* Event_InProgress values:

	- 0 : Event has been started and can be joined
	- 1 : Event has been started but cannot be joined (30 secs after event start)
	- (-1) : No event is running
*/

new
	Event_ID,
	DialogIDOption[MAX_PLAYERS];

new
	Float:BrawlX,
	Float:BrawlY,
	Float:BrawlZ,
	Float:BrawlA,
	BrawlInt,
	BrawlVW;

new
    hydraTime,
    PursuitTimer;
    
new
	team_issue;

new
    Event_Delay,
    E_Pursuit_Criminal;

new
    FoCo_Event_Died[MAX_PLAYERS];

new
	FFAArmour,
	FFAWeapons;

//new DrugEventVehicles[128], /unused
new	Event_PlayerVeh[MAX_PLAYERS] = -1;

new
	 Motel_Team = 0,
	 Team1_Motel = 0,
	 Team2_Motel = 0;

new
    EventDrugDelay[MAX_PLAYERS];

new
	lastGunGameWeapon[MAX_PLAYERS] = 38,
	GunGameKills[MAX_PLAYERS];

new
    spawnSeconds[MAX_PLAYERS];

new
	lastKillReason[MAX_PLAYERS];


new	winner,
	FoCo_Criminal = -1,
	FoCo_Event_Rejoin;
//new Pursuit_Car;
	
new
	eventVehicles[MAX_EVENT_VEHICLES] = {0},
	caridx;
	
new reservedSlotsQueue[VIP_EVENT_SLOTS];

	/* Event spawns */

	/* Area 51*/

new Float:area51SpawnsCrim[][] = {
	{279.3872,1853.4196,8.7649,46.6290}, // scientists
	{279.3697,1857.1285,8.7578,86.3993}, // scientists
	{280.2726,1859.4811,8.7578,87.3393}, // scientists
	{280.0467,1863.3972,8.7578,132.7731}, // scientists
	{276.7597,1863.0476,8.7578,183.9194}, // scientists
	{273.2761,1862.8348,8.7649,176.0860}, // scientists
	{270.2394,1862.8462,8.7649,177.3394}, // scientists
	{266.1837,1862.7073,8.7649,177.3394}, // scientists
	{265.0922,1860.5519,8.7649,267.3394}, // scientists
	{264.8591,1858.8806,8.7578,267.3394}, // scientists
	{264.7762,1856.1311,8.7578,267.3394}, // scientists
	{264.8020,1853.6237,8.7578,267.2669}, // scientists
	{266.6061,1853.9335,8.7578,357.2668}, // scientists
	{268.2514,1852.7816,8.7578,357.2668}, // scientists
	{270.1913,1854.0057,8.7649,357.2668}, // scientists
	{272.4178,1854.2007,8.7649,357.2668}, // scientists
	{273.9746,1853.4885,8.7649,357.2668}, // scientists
	{275.8936,1854.1243,8.7649,357.2668}, // scientists
	{278.6028,1854.1470,8.7649,357.2668}, // scientists
	{271.3033,1857.2720,8.7578,356.8086}, // scientists
	{277.1699,1857.9691,8.7578,7.7753}, // scientists
	{274.6574,1870.0833,8.7578,188.0887} // scientists
};

new Float:area51SpawnsAF[][] = {
	{249.1421,1858.6547,14.0840,31.2755}, // specialforces
	{246.4541,1857.9417,14.0840,356.8085}, // specialforces
	{242.3931,1858.0775,14.0840,357.4352}, // specialforces
	{239.4496,1858.6327,14.0840,357.4352}, // specialforces
	{239.4159,1862.8751,14.0579,177.4352}, // specialforces
	{242.6534,1866.6704,11.4609,87.4352}, // specialforces
	{242.8867,1870.2795,11.4609,87.4352}, // specialforces
	{243.0420,1873.9398,11.4531,87.4352}, // specialforces
	{242.8285,1878.4154,11.4609,87.4352}, // specialforces
	{240.5322,1879.2211,11.4609,177.4352}, // specialforces
	{238.9083,1877.0898,11.4609,267.4352}, // specialforces
	{239.2016,1873.7242,11.4609,267.4352}, // specialforces
	{224.1701,1868.5939,13.1406,96.7394}, // specialforces
	{224.1644,1864.7734,13.1406,96.7394}, // specialforces
	{223.9597,1860.0316,13.1470,96.7394}, // specialforces
	{220.4644,1855.2480,12.9439,96.7394}, // specialforces
	{211.6315,1857.9827,13.1406,276.7394}, // specialforces
	{205.3705,1860.3811,13.1406,276.7394}, // specialforces
	{205.6592,1864.9984,13.1406,276.7394}, // specialforces
	{205.0756,1870.8951,13.1406,276.7394}, // specialforces
	{210.2287,1873.6332,13.1406,186.7395}, // specialforces
	{213.9226,1873.4716,13.1406,186.7395} // specialforces
};

	/* Army vs. Terrorists */

new Float:armySpawnsType1[][] = {
	{-536.6452,1309.3185,3.7102,143.2186},
	{-535.7869,1307.3175,3.6655,144.8415},
	{-534.9776,1304.9730,3.5959,138.3177},
	{-534.4557,1302.6029,3.6028,133.0472},
	{-880.8651,1621.5620,30.8952,152.0271},
	{-880.4622,1617.4822,33.4015,245.7476},
	{-873.7017,1618.7975,33.4030,60.9587},
	{-883.3175,1615.1110,35.7468,240.8466},
	{-854.6778,1376.1045,1.2741,311.1262},
	{-851.0994,1372.8354,1.2741,315.1996}
};

new Float:armySpawnsType2[][] = {
	{-726.8176,1533.9048,40.1724,353.1638},
	{-729.1471,1534.0126,40.1633,356.0400},
	{-731.5231,1535.9725,40.2617,268.3620},
	{-729.3406,1538.0480,40.3969,2.6762},
	{-732.8348,1538.6995,40.4118,263.7181},
	{-730.0102,1539.9668,40.5042,164.1335},
	{-734.8888,1544.8472,39.0736,264.7473},
	{-734.6887,1547.8004,38.9713,266.9969},
	{-734.5697,1545.9861,41.5462,266.4031},
	{-734.1703,1555.2683,39.8209,272.7589}
};

	/* Big Smoke */

new Float:BigSmokeSpawns[][] = {
	{2532.9614,-1281.3271,1048.2891},
	{2524.3040,-1281.9133,1048.2891},
	{2520.3289,-1280.6376,1054.6406},
	{2542.9700,-1282.7721,1054.6406},
	{2542.3420,-1300.4220,1054.6406},
	{2546.8904,-1288.1726,1054.6406},
	{2553.3010,-1281.7985,1054.6470},
	{2568.7739,-1306.1091,1054.6406},
	{2581.2690,-1301.6436,1060.9922},
	{2579.9753,-1285.3286,1065.3594},
	{2551.5872,-1294.1041,1060.9844},
	{2568.3835,-1283.0282,1044.1250},
	{2575.8843,-1283.1638,1044.1250},
	{2566.9451,-1297.7665,1037.7734},
	{2566.3384,-1282.9639,1031.4219},
	{2572.0032,-1304.9718,1031.4219},
	{2546.4976,-1301.6432,1031.4219},
	{2530.7329,-1289.0771,1031.4219},
	{2527.4521,-1289.3014,1031.4219},
	{2543.1543,-1321.8826,1031.4219}
};

	/* Compound */

new Float:terroristcoumpoundattack[][] = {
	{-2180.1060,-268.1125,36.5156,273.4774}, // terrorits
	{-2180.0811,-265.7807,36.5156,269.0100}, // terrorits
	{-2180.0684,-263.1395,36.5156,271.2192}, // terrorits
	{-2179.9485,-260.2129,36.5156,267.1994}, // terrorits
	{-2179.9487,-257.7114,36.5156,267.1044}, // terrorits
	{-2184.7568,-253.8005,36.5156,267.2739}, // terrorits
	{-2184.5247,-251.0279,36.5156,265.7572}, // terrorits
	{-2184.3416,-248.1582,36.5156,266.0979}, // terrorits
	{-2184.1201,-245.0245,36.5156,264.3055}, // terrorits
	{-2183.7273,-242.0624,36.5156,263.6901}, // terrorits
	{-2185.4993,-238.8463,36.5220,268.0169}, // terrorits
	{-2185.2302,-235.9542,36.5220,264.1762}, // terrorits
	{-2184.8584,-232.8474,36.5156,267.1653}, // terrorits
	{-2184.5327,-230.1497,36.5156,262.6979}, // terrorits
	{-2181.9202,-227.0722,36.5156,260.0210}, // terrorits
	{-2170.1748,-237.7798,36.5156,357.3499}, // terrorits
	{-2166.4485,-237.7726,36.5156,358.0706} // terrorits
};

new Float:swatcompoundattack[][] = {
	{-1572.7030,748.0657,-5.2422,93.3019}, // cop
	{-1572.6538,744.2728,-5.2422,93.1385}, // cop
	{-1572.8400,740.5297,-5.2422,85.7576}, // cop
	{-1573.1174,736.6428,-5.2422,85.6028}, // cop
	{-1573.5133,732.7161,-5.2422,82.8390}, // cop
	{-1573.8737,728.5589,-5.2422,83.8352}, // cop
	{-1574.3877,724.3843,-5.2422,82.0114}, // cop
	{-1574.6088,719.8906,-5.2422,84.5743}, // cop
	{-1574.9963,715.1602,-5.2422,83.6905}, // cop
	{-1575.2784,708.9619,-5.2422,91.8934}, // cop
	{-1575.7524,702.8419,-4.9063,83.4896}, // cop
	{-1575.9858,697.0717,-4.9063,87.6192}, // cop
	{-1576.4403,691.0716,-5.2422,86.7354}, // cop
	{-1582.4408,684.6136,-5.2422,87.4182}, // cop
	{-1582.5164,680.3119,-4.9063,85.9078}, // cop
	{-1583.1206,676.1038,-4.9063,80.6373}, // cop
	{-1592.8230,674.3566,-4.9140,352.2764} // cop
};

	/* Drug Run */

new Float:drugSpawnsType1[][] = {
	{386.3043,2548.5906,16.5391,174.1982},
	{386.2205,2546.2419,16.5391,177.9582},
	{386.1368,2543.9036,16.5391,177.9582},
	{386.0403,2541.1985,16.5391,177.9582},
	{385.9525,2538.7400,16.5391,177.9582},
	{385.8694,2536.4104,16.5391,177.9582},
	{385.7797,2533.8972,16.5391,177.9582},
	{385.6798,2531.1011,16.5491,177.9582},
	{383.5614,2530.6782,16.5759,177.9582},
	{383.5607,2533.7908,16.5391,177.9582},
	{383.8788,2536.5457,16.5391,177.9582},
	{383.9685,2539.5559,16.5391,177.9582},
	{383.9574,2542.3435,16.5391,177.9582},
	{383.9225,2544.8630,16.5391,177.9582},
	{383.7946,2547.6460,16.5391,177.9582},
	{381.6566,2547.5417,16.5391,177.9582},
	{381.5372,2544.2039,16.5391,177.9582},
	{381.4406,2541.4956,16.5391,177.9582},
	{381.3459,2538.8496,16.5391,177.9582},
	{381.2657,2536.6025,16.5391,177.9582},
	{381.1742,2534.0408,16.5482,177.9582},
	{381.0813,2531.4390,16.5880,177.9582},
	{379.1826,2531.0791,16.5973,177.9582},
	{379.3771,2533.8757,16.5763,177.9582},
	{379.3782,2536.8149,16.5391,177.9582},
	{378.6484,2539.3767,16.5391,177.9582},
	{379.3178,2540.9807,16.5391,177.9582},
	{379.2309,2544.4143,16.5391,177.9582},
	{379.1219,2547.0881,16.5391,177.9582},
	{379.1389,2548.8113,16.5391,177.9582}
};

new Float:drugSpawnsType2[][] = {
	{1754.4464,-1886.6516,13.5569,271.7347},
	{1756.4623,-1886.5906,13.5564,271.7347},
	{1759.0895,-1886.5109,13.5558,271.7347},
	{1761.2360,-1886.4458,13.5553,271.7347},
	{1763.8300,-1886.3678,13.5546,271.7347},
	{1766.9156,-1886.2738,13.5539,271.7347},
	{1769.2448,-1886.2031,13.5533,271.7347},
	{1769.6971,-1888.5441,13.5601,271.7347},
	{1767.4825,-1888.3868,13.5537,271.7347},
	{1765.1946,-1888.3080,13.5543,271.7347},
	{1762.0735,-1888.4391,13.5551,271.7347},
	{1758.4504,-1887.7513,13.5559,271.7347},
	{1755.7251,-1888.0513,13.5566,271.7347},
	{1752.6431,-1888.3499,13.5574,271.7347},
	{1752.7349,-1890.3278,13.5573,271.7347},
	{1755.6147,-1890.4915,13.5566,271.7347},
	{1758.5013,-1890.4045,13.5559,271.7347},
	{1761.5813,-1890.3114,13.5552,271.7347},
	{1764.6033,-1890.2196,13.5544,271.7347},
	{1767.3138,-1890.1372,13.5603,271.7347},
	{1770.0690,-1890.0535,13.5610,271.7347},
	{1770.9042,-1892.0048,13.5621,271.7347},
	{1768.0706,-1891.3242,13.5611,271.7347},
	{1765.2567,-1891.3208,13.5604,271.7347},
	{1763.0635,-1891.2950,13.5548,271.7347},
	{1760.6603,-1891.1453,13.5554,271.7347},
	{1758.0073,-1891.5461,13.5561,271.7347},
	{1755.7379,-1891.1418,13.5566,271.7347},
	{1753.4752,-1891.4116,13.5572,271.7347},
	{1753.9664,-1893.4374,13.5570,271.7347},
	{1755.9385,-1893.3779,13.5566,271.7347}
};



new DrugRunVehicles[][e_DrugRunVehicles] =
{
	{431, 1804.9897, -1928.3383, 13.4915, 359.5247},
	{567,1805.2609,-1911.4696,13.2676,359.9748},
	{567,1796.8599,-1931.1780,13.2519,2.8630},
	{536,1785.3833,-1931.5442,13.1238,0.4821},
	{567,1790.4397,-1931.3499,13.2531,359.2782},
	{560,1778.6602,-1932.2065,13.0915,359.6266},
	{522,1775.8104,-1925.5791,12.9557,228.7756},
	{455,1776.7750,-1911.1565,13.8224,182.1264},
	{433,325.4319,2541.5896,17.2446,178.8733},
	{433,291.5707,2542.2861,17.2572,181.1078},
	{470,331.9542,2527.1885,16.7732,89.7045},
	{470,339.5666,2527.3247,16.7636,89.7131},
	{470,345.7501,2527.4158,16.7324,90.8450},
	{470,352.0356,2527.3730,16.7001,90.3715},
	{470,358.3670,2527.4417,16.6720,91.0383},
	{470,364.3454,2527.4082,16.6404,89.8504}
};

	/* Hydra */

new Float:hydraSpawnsType1[][] = {
	{1939.58178711,1365.82348633,16.76304626,272.00000000},
	{1939.77551270,1323.51635742,16.76304626,271.50000000},
	{1968.00170898,1185.41442871,63.80590057,0.00000000},
	{1955.27209473,1173.72131348,63.80590439,180.00000000},
	{2163.80175781,1502.10534668,32.08264542,320.00000000},
	{2164.01171875,1463.47900391,32.08404922,222.00000000},
	{2106.23974609,1462.88977051,32.08428955,124.00000000},
	{2106.60009766,1502.69543457,32.08437729,52.00000000},
	{1950.36877441,1628.54748535,23.68749237,272.00000000},
	{1953.65820312,1603.13574219,73.17739105,39.99572754},
	{1906.02832031,1628.63964844,73.17739105,270.00000000},
	{1955.29699707,1655.69946289,73.17520905,39.99572754}
};

	/* Jeff TDM */

new Float:motelSpawnsType1[][] = {
	{2189.9846,-1139.2814,1029.7969,238.2805},
	{2189.1294,-1143.9292,1029.7969,273.2783},
	{2191.0825,-1146.8323,1029.7969,3.2783},
	{2196.0771,-1147.2567,1029.7969,3.2783},
	{2199.7551,-1147.3477,1029.7969,3.2783},
	{2202.3135,-1144.9834,1029.7969,90.6991},
	{2201.8625,-1143.1967,1029.7969,90.6991},
	{2199.8345,-1142.1290,1029.7969,180.9399},
	{2199.4023,-1139.0775,1029.7969,180.9399},
	{2196.8816,-1138.9806,1029.7969,180.9399},
	{2194.9197,-1139.0475,1029.7969,180.9399},
	{2194.1277,-1143.8186,1029.7969,0.9399},
	{2197.0967,-1144.2506,1029.7969,267.8791},
	{2193.4351,-1145.3593,1029.7969,181.3983},
	{2190.3499,-1142.9524,1030.3516,265.8307}
};

new Float:motelSpawnsType2[][] = {
	{2221.1633,-1154.1404,1025.7969,357.2927}, // Spawn1
	{2219.7998,-1153.8639,1025.7969,351.7650}, // Spawn2
	{2218.6963,-1153.5408,1025.7969,346.4945}, // Spawn3
	{2216.5090,-1152.4301,1025.7969,305.1901}, // Spawn4
	{2215.8010,-1150.7072,1025.7969,268.6424}, // Spawn5
	{2215.8596,-1149.2339,1025.7969,270.2654}, // Spawn6
	{2216.0044,-1147.0659,1025.7969,269.3816}, // Spawn7
	{2218.3806,-1147.1096,1025.7969,178.2570}, // Spawn8
	{2219.6746,-1145.5049,1025.7969,272.0005}, // Spawn9
	{2224.2832,-1142.2668,1025.7969,178.9960}, // Spawn10
	{2225.2764,-1145.0853,1025.7969,138.9451}, // Spawn11
	{2226.0496,-1147.5005,1025.7969,108.6078}, // Spawn12
	{2226.9717,-1150.2124,1025.7969,90.1771}, // Spawn13
	{2224.8855,-1150.6051,1025.7969,83.0266},// Spawn14
	{2219.8657,-1149.2186,1025.7969,268.5779}, // Spawn15
	{2218.7021,-1150.7179,1025.7969,180.3060}, // Spawn16
	{2218.6985,-1148.3522,1025.7969,353.6372} // Spawn17
};

	/* Mad Doggs */

new Float:MadDogSpawns[][] = {
	{1263.6385,-785.9014,1091.9063,350.3100},
	{1286.0574,-773.1819,1091.9063,125.5029},
	{1273.1113,-786.8727,1089.9299,234.6888},
	{1287.5909,-787.6873,1089.9375,168.4299},
	{1275.2504,-806.2203,1089.9375,343.1032},
	{1287.5999,-803.9429,1089.9375,163.7300},
	{1274.9194,-812.7767,1089.9375,237.6540},
	{1287.4939,-817.5425,1089.9375,173.1067},
	{1283.2192,-836.4002,1089.9375,2.6517},
	{1278.3448,-811.8217,1085.6328,169.6600},
	{1291.7516,-826.0576,1085.6328,175.3000},
	{1258.6934,-836.8271,1084.0078,266.1441},
	{1247.4591,-828.0005,1084.0078,281.1843},
	{1241.9280,-821.6576,1083.1563,165.1048},
	{1231.1757,-808.4885,1084.0078,145.0280},
	{1243.5769,-817.6377,1084.0078,47.9172},
	{1267.7944,-812.7502,1084.0078,4.0501},
	{1245.6238,-803.8966,1084.0078,274.1459},
	{1270.5660,-795.3015,1084.1719,350.1416},
	{1253.7341,-793.5455,1084.2344,260.3591},
	{1234.2546,-756.3163,1084.0150,180.9400},
	{1256.3524,-767.4749,1084.0078,196.7027},
	{1261.5895,-779.9619,1084.0078,4.8685},
	{1276.6580,-765.4781,1084.0078,177.5891},
	{1303.3036,-781.4746,1084.0078,87.0349},
	{1297.5220,-794.7298,1084.0078,358.2882}
};

	/* Minigun  */

new Float:minigunSpawnsType1[][] = {
	{1360.8236,2197.9639,9.7578,171.2087},
	{1396.4573,2176.7610,9.7578,84.2131},
	{1397.0870,2157.2017,11.0234,188.2790},
	{1410.2015,2100.4004,12.0156,359.9406},
	{1406.4691,2123.8171,17.2344,90.5182},
	{1406.5967,2183.2200,17.2344,84.8548},
	{1296.8109,2212.5212,12.0156,265.6498},
	{1300.6083,2207.5505,17.2344,183.5323},
	{1359.4872,2208.0378,17.2344,179.7720},
	{1298.4968,2198.1011,11.0234,178.2052},
	{1304.8771,2101.3682,11.0156,275.3395},
	{1396.1423,2101.5391,11.0156,89.8678},
	{1384.2648,2185.5144,11.0234,134.6748},
	{1330.3446,2204.9385,13.3759,358.6869},
	{1403.9540,2153.5938,13.2266,274.7129},
	{1396.5599,2103.8850,39.0228,48.1240},
	{1302.0127,2197.8630,39.0228,225.1588}
};

	/* Navy vs. Terrorists */

new Float:navySealsBoat[][] = {
	{-1451.8934,489.2393,3.0414,0.9636},
	{-1439.5277,489.2123,3.0414,357.9584},
	{-1435.7106,491.3882,3.0391,93.1610}, // Boatspawn_3
	{-1436.4033,495.6390,3.0391,93.1610}, // Boatspawn_4
	{-1446.0100,501.4157,3.0414,87.9335}, // Boatspawn_5
	{-1439.6398,501.8853,3.0414,359.0356}, // Boatspawn_6
	{-1432.6844,504.3380,3.0414,88.6373}, // Boatspawn_7
	{-1433.0454,508.8413,3.0414,88.6373}, // Boatspawn_8
	{-1437.2540,513.3931,3.0414,174.5301}, // Boatspawn_9
	{-1453.8115,513.5035,3.0414,177.5172}, // Boatspawn_10
	{-1424.9127,513.7139,3.0391,88.2392}, // Boatspawn_11
	{-1424.7781,508.5562,3.0391,95.7319}, // Boatspawn_12
	{-1426.6696,503.5713,3.0391,89.7576 }, // Boatspawn_13
	{-1427.1627,497.9672,3.0391,89.7576}, // Boatspawn_14
	{-1428.3741,492.3010,3.0391,89.7576}, // Boatspawn_15
	{-1429.5172,488.9036,3.0391,103.5731}, // Boatspawn_16
	{-1347.6814,500.0701,18.2344,3.1124} // Boatspawn_17
};

new Float:navyVehicles[][e_DrugRunVehicles] = { // 9 vehicles
	{476,-1270.1177,499.6811,18.9408,269.5298},
	{476,-1293.3729,492.2342,18.9422,270.5231},
	{476,-1303.7994,508.0874,18.9414,269.9069},
	{476,-1404.7931,493.4467,18.9422,356.9377},
	{476,-1458.4177,501.1433,18.9834,270.8403},
	{497,-1418.0540,516.1037,18.4192,270.9501},
	{497,-1420.1477,492.0164,18.4092,357.8716},
	{430,-1445.0782,497.6998,-0.2108,89.1427},
	{430,-1438.6812,504.7648,-0.1138,93.3837},
	{430,-1438.7063,509.4692,-0.1682,91.9946},
	{430,-1471.4034,488.0244,-0.2879,90.2242},
	{473,-1444.8440,491.8952,-0.2713,90.8142}
};

new Float:NavyTerroristVehicles[][e_DrugRunVehicles] = {
	{473,-544.2135,1290.1025,-0.2869,60.3390},
	{473,-545.9045,1301.1432,-0.2776,69.1840},
	{473,-544.9697,1308.0038,-0.2525,64.3189}
};

new Float:compoundVehicles[][e_DrugRunVehicles] = {
 	{497,-1630.3750,654.6266,7.3591,268.2673},
 	{497,-1604.6624,655.1348,7.3591,273.0138},
 	{490,-1616.0300,742.7470,-4.9922,89.5245},
    {490,-1604.0100,741.7650,-4.9922,87.7661},
    {490,-1593.0900,741.0660,-4.9922,87.6814},
    {490,-1582.0300,740.5920,-4.9922,87.4882},
    {490,-1581.0500,724.7320,-4.9922,359.0400},
    {490,-1581.0800,710.8540,-4.9922,358.8570},
    {490,-1581.7600,699.9149,-4.9844,358.7741}
};
	

new Float:terroristsBoat[][] = {
	{-1434.3325,1481.8838,1.8672,276.5517},
	{-1434.2948,1484.1460,1.8672,268.4611},
	{-1434.2507,1486.6434,1.8672,268.5173},
	{-1434.2252,1489.7177,1.8672,268.5735},
	{-1434.3741,1494.6810,1.8672,267.6897},
	{-1433.8632,1498.0852,1.8672,263.3593},
	{-1413.2545,1497.2257,1.8672,265.6650},
	{-1406.1989,1497.3625,1.8672,271.3051},
	{-1394.2034,1497.2762,1.8735,271.3051},
	{-1390.7335,1493.5171,1.8735,86.3641},
	{-1390.7863,1490.1801,1.8735,88.0595},
	{-1391.1282,1486.5408,1.8672,82.7890},
	{-1391.2137,1483.8008,1.8672,84.7253},
	{-1391.6104,1480.9357,1.8672,85.0948},
	{-1400.5376,1482.9449,1.8672,90.7348},
	{-1408.2819,1483.0409,1.8672,90.7348}
};

	/* Oil Rig */

new Float:swatoilrigspawns1[][] = {
	{-4989.2671,-1060.4849,62.3481,268.9522}, // SWATspawn1
	{-4989.2139,-1058.8197,62.3481,269.9485}, // SWATspawn2
	{-4989.2607,-1056.6619,62.3481,265.9313}, // SWATspawn3
	{-4989.2803,-1054.1078,62.3481,269.1208}, // SWATspawn4
	{-4989.1377,-1051.6665,62.3481,267.9237}, // SWATspawn5
	{-4989.0537,-1049.2660,62.3481,268.2932}, // SWATspawn6
	{-4989.0015,-1046.9961,62.3481,268.3495}, // SWATspawn7
	{-4988.9907,-1044.8541,62.3481,269.0324}, // SWATspawn8
	{-4989.0864,-1042.5729,62.3481,269.0886}, // SWATspawn9
	{-4984.8403,-1042.4364,62.3481,269.1448}, // SWATspawn10
	{-4984.7739,-1044.3013,62.3481,268.5744}, // SWATspawn11
	{-4984.6982,-1046.3790,62.3481,268.6869}, // SWATspawn12
	{-4984.5972,-1048.5526,62.3481,268.7432}, // SWATspawn13
	{-4984.3262,-1051.0364,62.3481,268.4861}, // SWATspawn14
	{-4984.2212,-1053.4729,62.3481,271.9891}, // SWATspawn15
	{-4984.1616,-1055.9543,62.3481,269.2253}, // SWATspawn16
	{-4984.1226,-1058.9647,62.3481,267.7148} // SWATspawn17
};

new Float:terroristoilrigspawns1[][] = { // terrorissts
	{-4848.1548,-1105.7831,52.1931,89.7017}, // Terrorspawn1
	{-4848.2217,-1104.4656,52.1929,87.5171}, // Terrorspawn2
	{-4848.2749,-1102.7365,52.1956,89.8487}, // Terrorspawn4
	{-4848.3560,-1101.0161,52.2002,89.0294}, // Terrorspawn3
	{-4848.4229,-1099.3506,52.2047,88.4292}, // Terrorspawn5
	{-4848.5532,-1097.4938,52.2097,88.2838}, // Terrorspawn6
	{-4848.5591,-1095.4310,52.2152,88.8179}, // Terrorspawn7
	{-4848.6245,-1093.4357,52.2206,87.7901}, // Terrorspawn8
	{-4854.3359,-1106.2627,52.1862,93.3493}, // Terrorspawn9
	{-4854.3325,-1104.7566,52.1902,89.1057}, // Terrorspawn10
	{-4854.3599,-1103.3361,52.1940,87.8238}, // Terrorspawn11
	{-4854.4463,-1101.3271,52.1994,91.0379}, // Terrorspawn12
	{-4854.5317,-1099.6100,52.2040,89.9278}, // Terrorspawn13
	{-4854.5986,-1097.7080,52.2283,89.0495}, // Terrorspawn14
	{-4854.8691,-1095.8661,52.2276,93.9821}, // Terrorspawn15
	{-4854.9053,-1094.2699,52.2275,89.5147}, // Terrorspawn16
	{-4854.8970,-1092.4136,52.2275,85.0473} // Terrorspawn17
};

	/* Pursuit */

new Float:pursuitVehicles[][] = {
	{565.6188,-1244.3657,16.9157,295.8679},
	{566.4626,-1238.9558,16.9824,294.7580},
	{563.5314,-1232.3390,16.9785,293.8539},
	{562.1167,-1228.7739,16.9802,293.5553},
	{570.1106,-1219.6626,17.3587,264.5331},
	{581.5428,-1241.3715,17.4123,324.3894},
	{546.8007,-1234.5836,16.5933,301.3257},
	{548.7852,-1240.2753,16.5859,298.6667},
	{551.3083,-1245.8103,16.5883,298.6719},
	{553.7662,-1248.9722,16.6187,302.2399},
	{612.4984,-1224.6945,17.8323,289.7163}
};

	/* Sumo */

new Float:sumoSpawnsType1[15][4] =
{
	{3770.844238, -1525.422973, 36.218750, 165.782379},
	{3760.332275, -1526.346435, 36.218750, 165.782379},
	{3781.483886, -1496.333984, 36.218650, 165.782379},
	{3747.465820, -1493.134521, 36.218750, 165.782379},
	{3753.536376, -1434.557739, 36.169601, 165.782379},
	{3778.360351, -1435.679443, 36.169586, 165.782379},
	{3632.698974, -1549.674072, 36.247207, 170.496109},
	{3651.617675, -1549.627441, 36.247196, 170.496109},
	{3664.941894, -1527.715209, 36.247135, 170.496109},
	{3621.671630, -1490.709472, 36.247188, 170.496109},
	{3665.038574, -1485.096679, 36.247230, 170.496109},
	{3634.828857, -1405.810913, 36.234485, 170.496109},
	{3622.596191, -1338.279785, 36.238059, 170.496109},
	{3622.376708, -1264.447509, 36.170368, 170.496109},
	{3681.760498, -1316.780395, 36.240844, 170.496109}
};

new Float:sumoSpawnsType2[15][4] = {
	{4791.94726562,-2043.65002441,14.0,82.00000000},
	{4790.67578125,-2049.04931641,14.0,71.99597168},
	{4788.72070312,-2053.98779297,14.0,65.99340820},
	{4786.09472656,-2058.88867188,14.0,55.98986816},
	{4792.23144531,-2037.80468750,14.0,95.99597168},
	{4791.53466797,-2032.01013184,14.0,101.99304199},
	{4790.06250000,-2026.42871094,14.0,111.99157715},
	{4787.96728516,-2021.58862305,14.0,119.98913574},
	{4784.91601562,-2016.86865234,14.0,129.98718262},
	{4780.93212891,-2012.68615723,14.0,137.98461914},
	{4777.05224609,-2009.32250977,14.0,141.98266602},
	{4772.77148438,-2006.47973633,14.0,151.98132324},
	{4767.81347656,-2004.35412598,14.0,161.98144531},
	{4762.79931641,-2002.90576172,14.0,168.48138428},
	{4757.82128906,-2002.34020996,14.0,177.98120117}
};

new Float:sumoSpawnsType3[15][4] = {
	{1488.4178,6265.4429,27.5201,359.7072},
	{1488.2949,6232.3647,27.4989,359.8356},
	{1469.1898,6246.8521,27.2210,90.6164},
	{1502.7943,6247.6836,27.7414,88.2535},
	{1405.6884,6244.0596,25.9826,139.4007},
	{1320.5160,6202.5352,26.0507,96.7300},
	{1280.3342,6213.2788,26.0509,95.6704},
	{1257.2800,6277.6987,26.0462,358.0646},
	{1282.4304,6320.6533,26.0062,322.3025},
	{1401.2308,6351.6323,26.8068,275.0645},
	{1446.4875,6319.3984,23.5806,199.6965},
	{1478.3333,6296.5176,25.7071,270.5961},
	{1535.2900,6257.3018,25.6623,186.7137},
	{1531.9629,6193.7227,25.7719,16.0374},
	{1631.1805,6259.5181,25.7823,176.3534}
};

new Float:sumoSpawnsType4[15][4] = {
	{-1484.40002441,949.40002441,1037.90002441,334.00000000},
	{-1488.30004883,951.59997559,1037.90002441,333.99536133},
	{-1492.69995117,954.00000000,1037.90002441,333.99536133},
	{-1497.09997559,957.29998779,1037.90002441,333.99536133},
	{-1501.09997559,960.90002441,1037.90002441,327.99536133},
	{-1504.40002441,964.20001221,1038.00000000,333.99536133},
	{-1508.40002441,968.40002441,1037.80004883,333.99536133},
	{-1511.69995117,971.70001221,1038.09997559,333.99536133},
	{-1514.69995117,975.59997559,1038.19995117,325.99536133},
	{-1517.40002441,980.50000000,1038.19995117,309.99536133},
	{-1518.90002441,984.29998779,1038.19995117,293.99475098},
	{-1520.90002441,992.09997559,1038.30004883,283.99414062},
	{-1520.30004883,988.20001221,1038.19995117,289.99414062},
	{-1521.40002441,997.29998779,1038.40002441,277.99108887},
	{-1521.09997559,1002.00000000,1038.40002441,265.98706055}
};

new Float:sumoSpawnsType5[15][4] = {
	{4272.3604,999.4564,500.6275,86.5218},
	{4176.0195,945.9434,500.5341,101.3996},
	{4047.7341,999.1551,500.5143,86.9434},
	{4091.0955,1146.4822,500.4341,1.6999},
	{4012.9485,1277.9446,500.5084,89.1949},
	{4042.1272,1191.2253,476.9365,180.4632},
	{4213.5005,1279.0221,504.7436,266.9754},
	{4370.5264,1093.3694,500.5674,323.3853},
	{4194.9370,1094.6921,500.5842,179.4744},
	{4189.2437,907.8942,524.1190,273.7524},
	{4290.7930,913.4462,524.2849,2.1497},
	{4369.5400,1054.1501,524.1741,270.7135},
	{4169.1250,1095.0826,500.5882,182.0604},
	{4027.7532,999.4358,500.5151,357.7991},
	{4004.3616,1135.5791,500.4542,359.5936}
};


/* Forwards */

	/* Area 51 */
	
	forward area51_EventStart(playerid);
	forward area51_PlayerJoinEvent(playerid);
	forward area51_PlayerLeftEvent(playerid);
	forward area51_OneSecond();
	
	/* Army vs. Terrorists */
	
	forward army_EventStart(playerid);
	forward army_PlayerJoinEvent(playerid);
	forward army_PlayerLeftEvent(playerid);
	forward army_OneSecond();
	
	/* Big Smoke */
	
	forward bs_EventStart(playerid);
	forward bs_PlayerJoinEvent(playerid);
	
	/* Brawl */
	
	forward brawl_EventStart(playerid);
	forward brawl_PlayerJoinEvent(playerid);
	
	/* Compound */
	
	forward compound_EventStart(playerid);
	forward compound_PlayerJoinEvent(playerid);
	forward compound_PlayerLeftEvent(playerid);
	forward compound_OneSecond();
	
	/* Drug Run */
	
	forward drugrun_EventStart(playerid);
	forward drugrun_PlayerJoinEvent(playerid);
	forward drugrun_PlayerLeftEvent(playerid);
	forward drugrun_OneSecond();
	
	/* Hydra */
	
	forward hydra_EventStart(playerid);
	forward hydra_PlayerJoinEvent(playerid);
	forward hydra_PlayerLeftEvent(playerid);
	forward hydra_OneSecond();
	
	/* Jeff TDM */
	
	forward jefftdm_EventStart(playerid);
	forward jefftdm_PlayerJoinEvent(playerid);
	forward jefftdm_PlayerLeftEvent(playerid);
	forward jefftdm_OneSecond();
	
	/* Mad Doggs */
	
	forward md_EventStart(playerid);
	forward md_PlayerJoinEvent(playerid);
	
	/* Minigun */
	
	forward minigun_EventStart(playerid);
	forward minigun_PlayerJoinEvent(playerid);
	forward minigun_PlayerLeftEvent(playerid);
	forward minigun_OneSecond();
	
	/* Navy vs. Terrorists */
	
	forward navy_EventStart(playerid);
	forward navy_PlayerJoinEvent(playerid);
	forward navy_PlayerLeftEvent(playerid);
	forward navy_OneSecond();
	
	/* Oil Rig */
	
	forward oilrig_EventStart(playerid);
	forward oilrig_PlayerJoinEvent(playerid);
	forward oilrig_PlayerLeftEvent(playerid);
	forward oilrig_OneSecond();
	
	/* Pursuit */
	
	forward pursuit_EventStart(playerid);
	forward pursuit_PlayerJoinEvent(playerid);
	forward pursuit_PlayerLeftEvent(playerid);
	forward EndPursuit(playerid);
	forward pursuit_OneSecond();
	forward Random_Pursuit_Vehicle();
	
	/* Sumo */
	
	forward monster_EventStart(playerid);
	forward monster_PlayerJoinEvent(playerid);

	forward banger_EventStart(playerid);
	forward banger_PlayerJoinEvent(playerid);
	
	forward sandking_EventStart(playerid);
	forward sandking_PlayerJoinEvent(playerid);
	
	forward sandkingR_EventStart(playerid);
	forward sandkingR_PlayerJoinEvent(playerid);
	
	forward derby_EventStart(playerid);
    forward derby_PlayerJoinEvent(playerid);
    
   	forward sumo_PlayerLeftEvent(playerid);
   	forward sumo_OneSecond();

/* Callbacks */


forward event_OnGameModeInit();
public event_OnGameModeInit()
{
	//SetTimer("Event_OneSecond", 1000, true);
	foreach(new i : Player)
	{
	    EventDrugDelay[i] = -1;
	    Event_Players[i] = -1;
	}
	return 1;
}

forward event_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
public event_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_EVENTS)
	{
	    if(!response)
	    {
	        return 1;
	    }

	    DialogIDOption[playerid] = listitem;

	    switch(listitem)
	    {
	        case MADDOGG:
	        {
	            ShowPlayerDialog(playerid, DIALOGID_MDWEAPON, DIALOG_STYLE_INPUT, "Event Options", "Which weapon should be used?", "Confirm", "Close");
	        }

	        case BIGSMOKE:
	        {
	            ShowPlayerDialog(playerid, DIALOGID_MDWEAPON, DIALOG_STYLE_INPUT, "Event Options", "Which weapon should be used?", "Confirm", "Close");
	        }

	        case MINIGUN:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

				EventStart(MINIGUN, playerid);
	        }

	        case BRAWL:
	        {
	            if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

				EventStart(BRAWL, playerid);
	        }

	        case HYDRA:
	        {
	            if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

				EventStart(HYDRA, playerid);
	        }

	        case JEFFTDM:
	        {
            	if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

				EventStart(JEFFTDM, playerid);
	        }

	        case AREA51:
	        {
            	if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

				EventStart(AREA51, playerid);
	        }

	        case ARMYVSTERRORISTS:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

				EventStart(ARMYVSTERRORISTS, playerid);
	        }

	        case NAVYVSTERRORISTS:
	        {
	            if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

				EventStart(NAVYVSTERRORISTS, playerid);
	        }

	        case COMPOUND:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(COMPOUND, playerid);
	        }

	        case OILRIG:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(OILRIG, playerid);
	        }

	        case DRUGRUN:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(DRUGRUN, playerid);
	        }

	        case MONSTERSUMO:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(MONSTERSUMO, playerid);
	        }

	        case BANGERSUMO:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(BANGERSUMO, playerid);
	        }

	        case SANDKSUMO:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(SANDKSUMO, playerid);
	        }

	        case SANDKSUMORELOADED:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(SANDKSUMORELOADED, playerid);
	        }

	        case DESTRUCTIONDERBY:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(DESTRUCTIONDERBY, playerid);
	        }

	        case PURSUIT:
	        {
				if(Event_InProgress != -1)
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
					return 1;
				}

	            EventStart(PURSUIT, playerid);
	        }
			
			case GUNGAME: SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Gun Game is currently disabled due to performance issues.");
			
	    }
	}

	else if(dialogid == DIALOG_REJOINABLE)
	{
 	    if(response)
	    {
	        FoCo_Event_Rejoin = 1;
			foreach(Player, i)
			{
				FoCo_Event_Died[i] = 0;
			}
	    }

	    else
	    {
			FoCo_Event_Rejoin = 0;

			foreach(Player, i)
			{
				FoCo_Event_Died[i] = 0;
			}
	    }

	    if(Event_InProgress != -1)
	    {
	        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: An event is already in progress.");
	    }

    	EventStart(DialogIDOption[playerid], playerid);
	}

	else if(dialogid == DIALOGID_MDWEAPON)
	{
	    if(!response)
		{
			return 1;
		}

		if(strval(inputtext) > 39 || strval(inputtext) < 1)
		{
			SendClientMessage(playerid, COLOR_WARNING, "Invalid value");
			return 1;
		}

		FFAWeapons = strval(inputtext);


		ShowPlayerDialog(playerid, DIALOG_FFAARMOUR, DIALOG_STYLE_MSGBOX, "Event Armour", "Should players spawn with armour or not?", "Yes", "No");

	}

	else if(dialogid == DIALOG_FFAARMOUR)
	{
		if(response)
		{
		    FFAArmour = 1;
		}

		else
		{
		    FFAArmour = 0;
		}

	    ShowPlayerDialog(playerid, DIALOG_REJOINABLE, DIALOG_STYLE_MSGBOX, "Event Rejoinable", "Should this event be rejoinable after death or not?", "Yes", "No");
	}
	return 1;
}

forward event_OnPlayerConnect(playerid);
public event_OnPlayerConnect(playerid)
{
    return 1;
}

forward event_OnPlayerDisconnect(playerid, reason);
public event_OnPlayerDisconnect(playerid, reason)
{
	if(Event_PlayerVeh[playerid] != -1)
	{
		DestroyVehicle(Event_PlayerVeh[playerid]);
		Event_PlayerVeh[playerid] = -1;
	}

	if(Event_ID != -1)
	{
		if(GetPVarInt(playerid, "InEvent") == 1)
		{
			PlayerLeftEvent(playerid);
		}
	}
	return 1;
}

forward event_OnPlayerSpawn(playerid);
public event_OnPlayerSpawn(playerid)
{
	if(Event_PlayerVeh[playerid] != -1)
	{
		DestroyVehicle(Event_PlayerVeh[playerid]);
		Event_PlayerVeh[playerid] = -1;
	}
	
	if(GetPVarInt(playerid, "JustDied") == 1)
	{
		SetPlayerSkin(playerid, GetDefaultSkin(playerid));
		SetPVarInt(playerid, "JustDied", 0);
	}
	

	
	/*if(GetPVarInt(playerid, "PlayerStatus") == 1 && Event_ID == GUNGAME)
	{
		SetPlayerArmour(playerid, 0);
		SetPlayerHealth(playerid, 99);
		SetPlayerVirtualWorld(playerid, 1500);
		SetPlayerInterior(playerid, 0);
		new randomnum = random(250);
		SetPlayerPos(playerid, GunGameSpawns[randomnum][0], GunGameSpawns[randomnum][1], GunGameSpawns[randomnum][2]);
		SetPlayerFacingAngle(playerid, GunGameSpawns[randomnum][3]);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, GunGameWeapons[GunGameKills[playerid]], 500);
		GameTextForPlayer(playerid, "~R~~n~~n~ Gun ~h~ Game!", 800, 3);
	}*/
	return 1;
}

forward event_OnPlayerDeath(playerid, killerid, reason);
public event_OnPlayerDeath(playerid, killerid, reason)
{
	
	if(EventDrugDelay[playerid] != -1)
	{
		EventDrugDelay[playerid] = -1;
	}

	if(Event_ID != -1)
	{
	    if(GetPVarInt(playerid, "InEvent") == 1)
		{		
		    SetPVarInt(playerid, "InEvent", 0);
			SetPVarInt(playerid, "JustDied", 1);
			PlayerLeftEvent(playerid);
		    
			if(Event_ID == BIGSMOKE || Event_ID == MADDOGG)
			{
			    FoCo_Event_Died[playerid]++;
			}
			

			if(Event_ID == JEFFTDM || Event_ID == AREA51 || Event_ID == ARMYVSTERRORISTS || Event_ID == NAVYVSTERRORISTS || Event_ID == COMPOUND || Event_ID == OILRIG || Event_ID == DRUGRUN || Event_ID == PURSUIT)
			{
			
				if(GetPVarInt(playerid, "MotelTeamIssued") == GetPVarInt(killerid, "MotelTeamIssued"))
				{
					new string[128];
					GivePlayerMoney(playerid, 100);
					GivePlayerMoney(killerid, -1000);
					GameTextForPlayer(killerid, "~r~Team Killing~n~Is Not Allowed!",3000,5);
					format(string, sizeof(string), "[Guardian]: %s has team killed %s in an event", PlayerName(killerid), PlayerName(playerid));
					SendAdminMessage(1, string);
				}
			}
/*
			if(Event_ID == GUNGAME)
			{
				if(killerid != INVALID_PLAYER_ID)
				{
					if(GetPVarInt(killerid, "PlayerStatus") == 1 && lastGunGameWeapon[killerid] != reason)
					{
						GunGameKills[killerid]++;
						ResetPlayerWeapons(killerid);
						GivePlayerWeapon(killerid, GunGameWeapons[GunGameKills[killerid]], 500);
						lastGunGameWeapon[killerid] = GunGameWeapons[GunGameKills[killerid]-1];
						new tmpString[128];
						format(tmpString, sizeof(tmpString), "(%d / 16)", GunGameKills[killerid]);
						TextDrawSetString(GunGame_MyKills[killerid], tmpString);

						new varHigh = 0;
						foreach(new i : Player)
						{
							if(GetPVarInt(playerid, "PlayerStatus") == 1)
							{
								if(GunGameKills[killerid] < GunGameKills[i])
								{
									varHigh = 1;
								}
							}
						}

						if(varHigh == 0)
						{
							format(tmpString, sizeof(tmpString), "%s (%d / 16)", PlayerName(killerid), GunGameKills[killerid]);
							foreach(Player, i)
							{
								if(GetPVarInt(playerid, "PlayerStatus") == 1)
								{
									TextDrawSetString(CurrLeaderName[i], tmpString);
								}
							}
						}

						if(GunGameKills[killerid] >= 17)
						{
							format(tmpString, sizeof(tmpString), "[Event Notice]: %s has won the Gun Game.", PlayerName(killerid));
							SendClientMessageToAll(COLOR_NOTICE, tmpString);
							lastEventWon = killerid;
							EndEvent();
						}
					}
				}
			}*/
		}
	}

	return 1;
}

forward event_OnPlayerExitVehicle(playerid, vehicleid);
public event_OnPlayerExitVehicle(playerid, vehicleid)
{
    if(vehicleid == Event_PlayerVeh[playerid])
	{
		if(Event_ID == MONSTERSUMO || Event_ID == BANGERSUMO || Event_ID == SANDKSUMO || Event_ID == SANDKSUMORELOADED || Event_ID == DESTRUCTIONDERBY || Event_ID == HYDRA)
		{
			if(GetPVarInt(playerid, "InEvent") == 1)
			{
				SetPVarInt(playerid, "FellOffEvent", 1);
				PlayerLeftEvent(playerid);
				SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: You have been removed from the event for leaving your vehicle.");
			}
		}
	}
	return 1;
}

forward event_OnPlayerEnterCheckpoint(playerid);
public event_OnPlayerEnterCheckpoint(playerid)
{
    if(Event_ID == DRUGRUN && GetPVarInt(playerid, "PlayerStatus") == 1 && GetPVarInt(playerid, "MotelTeamIssued") != 1)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid, COLOR_WARNING, "Get out of the vehicle!");
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 1421.5542,2773.9951,10.8203, 4.0);
			return 1;
		}

		EventDrugDelay[playerid] = 30;
		SendClientMessage(playerid, COLOR_NOTICE, "Stay alive for thirty seconds to win!");

		new string[128];

		format(string, sizeof(string), "%s has entered the checkpoint, kill him within 30 seconds!", PlayerName(playerid));

		SendEventPlayersMessage(string, COLOR_NOTICE);
	}
	return 1;
}

//forward Event_OneSecond();
task Event_OneSecond[1000]()
{
    Event_Delay --;
	if(Event_Delay == 0)
	{
		if(EventPlayersCount() <= 2)
		{
			foreach(Player, i)
			{
				if(GetPVarInt(i, "InEvent") == 1)
				{
					SendClientMessage(i, COLOR_WARNING, "[Event ERROR]: Event has been ended due to a low amount of players participating.");
				}
			}
			
			EndEvent();
		}
		
		else
		{
			Event_InProgress = 1;

			switch(Event_ID)
			{
				case MONSTERSUMO: sumo_OneSecond();
				case BANGERSUMO: sumo_OneSecond();
				case SANDKSUMO: sumo_OneSecond();
				case SANDKSUMORELOADED: sumo_OneSecond();
				case DESTRUCTIONDERBY: sumo_OneSecond();
				case HYDRA: hydra_OneSecond();
				case JEFFTDM: jefftdm_OneSecond();
				case ARMYVSTERRORISTS: army_OneSecond();
				case MINIGUN: minigun_OneSecond();
				case DRUGRUN: drugrun_OneSecond();
				case PURSUIT: pursuit_OneSecond();
				case AREA51: area51_OneSecond();
				case NAVYVSTERRORISTS: navy_OneSecond();
				case OILRIG: oilrig_OneSecond();
				case COMPOUND: compound_OneSecond();
			}
		}
	}

	else if(Event_Delay >= 0 && Event_Delay <= 5)
	{
		if(Event_ID == MONSTERSUMO || Event_ID == BANGERSUMO || Event_ID == SANDKSUMO || Event_ID == SANDKSUMORELOADED || Event_ID == DESTRUCTIONDERBY)
		{
			new
				Float:vehx,
				Float:vehy,
				Float:vehz,
				Float:vang;

			foreach(Player, i)
			{
				if(GetPVarInt(i, "InEvent") == 1)
				{
					GetPlayerPos(i, vehx, vehy, vehz);
					GetPlayerFacingAngle(i, vang);
					SetVehiclePos(Event_PlayerVeh[i], vehx, vehy, vehz);
					SetVehicleZAngle(i, vang);
					PutPlayerInVehicle(i, Event_PlayerVeh[i], 0);
					SetVehicleParamsEx(Event_PlayerVeh[i], false, false, false, true, false, false, false);
					TogglePlayerControllable(i, 0);
				}
			}
		}
	}

	else if(Event_Delay > 0)
	{
		foreach(Player, i)
		{
			if(GetPVarInt(i, "InEvent") == 1)
			{
				if(Event_ID == JEFFTDM)
				{
					SetCameraBehindPlayer(i);
				}
				TogglePlayerControllable(i, 0);
			}
		}
	}
	
	/*else if(Event_Delay == 5)
	{	
		switch(Event_ID)
		{	
			case MINIGUN:
			{
				new freeSlots = MINIGUN_EVENT_SLOTS - Event_PlayersCount();
				if(freeSlots > 0)
				{
					for(new i = 0; i < freeSlots; i++)
					{
						minigun_PlayerJoinEvent(reservedSlotsQueue[i]);
					}
				}
			}
		}
	}
*/
	foreach(Player,i)
	{
		if(EventDrugDelay[i] > -1 && Event_ID == DRUGRUN)
		{
			if(EventDrugDelay[i] == 0)
			{
				SetPVarInt(i, "MotelTeamIssued", 0);
				EndEvent();
				increment = 0;
				SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: Criminals succesfully dropped off the drugs!");
				EventDrugDelay[i] = -1;
				return 1;
			}

			EventDrugDelay[i]--;
		}

		if(GetPVarInt(i, "PlayerStatus") == 1 && Event_InProgress == 1)
		{
			switch(Event_ID)
			{
				case MONSTERSUMO,BANGERSUMO,SANDKSUMO,SANDKSUMORELOADED,DESTRUCTIONDERBY:
				{
					new Float:vx, Float:vy, Float:vz;
					GetVehiclePos(Event_PlayerVeh[i], vx, vy, vz);
					if(vz < 5.0 || GetPlayerState(i) != PLAYER_STATE_DRIVER)
					{
						if(GetPVarInt(i, "PlayerStatus") == 1)
						{
							SetPVarInt(i, "FellOffEvent", 1);
							SetPlayerHealth(i, 0);
							PlayerLeftEvent(i);
						}	
					}
				}

				case HYDRA:
				{
					if(GetPlayerState(i) != PLAYER_STATE_DRIVER)
					{
						PlayerLeftEvent(i);
					}
				}

				case OILRIG:
				{
					new Float:vx, Float:vy, Float:vz;
					GetPlayerPos(i, vx, vy, vz);
					if(vz < 5.0)
					{
						SetPVarInt(i, "FellOffEvent", 1);
						SetPlayerHealth(i, 0);
						PlayerLeftEvent(i);
					}
				}
			}
		}
	}
	
	return 1;
}

/* Functions */

	/* Main functions */
	
forward EventStart(type, playerid);
public EventStart(type, playerid)
{
	if(Event_InProgress != -1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already an event running, end it first");
	}

    increment = 0;
	/*
	for(new i = 0; i < VIP_EVENT_SLOTS; i++)
	{
		reservedSlotsQueue[i] = -1;
	}
	*/
	switch(type)
	{
		case MADDOGG: md_EventStart(playerid);
		case BIGSMOKE: bs_EventStart(playerid);
		case MINIGUN: minigun_EventStart(playerid);
		case BRAWL: brawl_EventStart(playerid);
		case HYDRA: hydra_EventStart(playerid);
		case JEFFTDM: jefftdm_EventStart(playerid);
		case AREA51: area51_EventStart(playerid);
		case ARMYVSTERRORISTS: army_EventStart(playerid);
		case NAVYVSTERRORISTS: navy_EventStart(playerid);
		case COMPOUND: compound_EventStart(playerid);
		case OILRIG: oilrig_EventStart(playerid);
		case DRUGRUN: drugrun_EventStart(playerid);
		case MONSTERSUMO: monster_EventStart(playerid);
		case BANGERSUMO: banger_EventStart(playerid);
		case SANDKSUMO: sandking_EventStart(playerid);
		case SANDKSUMORELOADED: sandkingR_EventStart(playerid);
		case DESTRUCTIONDERBY: derby_EventStart(playerid);
		case PURSUIT: pursuit_EventStart(playerid);
 	}
 	
 	return 1;
}

forward PlayerJoinEvent(playerid);
public PlayerJoinEvent(playerid)
{
	/*if(EventPlayersCount() > 2-CountDonators(3))
	{
	    if(GetPVarInt(playerid, "Donation_Type") < 3)
	    {
			SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: The event is full and you're gay (gold VIP)");
			return 1;
		}
		else
		{
		    SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Using Donator slot!");
		}
	}*/
	
	if(FoCo_Event_Died[playerid] > 0 && FoCo_Event_Rejoin == 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: The event is not rejoinable.");
	 	return 1;
 	}
	
	switch(Event_ID)
	{
	    case MADDOGG: md_PlayerJoinEvent(playerid);
	    case BIGSMOKE: bs_PlayerJoinEvent(playerid);
	    case MINIGUN: 
		{/*
			if(EventPlayersCount() < MINIGUN_EVENT_SLOTS - VIP_EVENT_SLOTS)
			{*/
				minigun_PlayerJoinEvent(playerid);
		/*	}
			
			else
			{
				if(IsVIP(playerid) == 3)
				{
					if(Event_PlayersCount() < MINIGUN_EVENT_SLOTS)
					{
						minigun_PlayerJoinEvent(playerid);
					}
					
					else
					{
						return SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: The event is full");
					}
				}
				
				else
				{
					for(new i = 0; i < VIP_EVENT_SLOTS; i++)
					{
						if(reservedSlotsQueue[i] == -1)
						{
							reservedSlotsQueue[i] = playerid;
							SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Using reserved slot. You will join the event if this slot is free.");
							return 1;
						}
					}
					
					SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Reserved slots queue is full, you can't join the event.");
					return 1;
				}
			}*/
			
		}
	    case BRAWL: brawl_PlayerJoinEvent(playerid);
	    case HYDRA: hydra_PlayerJoinEvent(playerid);
	    case GUNGAME:
	    {

	    }
	    case JEFFTDM: jefftdm_PlayerJoinEvent(playerid);
	    case AREA51: area51_PlayerJoinEvent(playerid);
	    case ARMYVSTERRORISTS: army_PlayerJoinEvent(playerid);
	    case NAVYVSTERRORISTS: navy_PlayerJoinEvent(playerid);
	    case COMPOUND: compound_PlayerJoinEvent(playerid);
	    case OILRIG: oilrig_PlayerJoinEvent(playerid);
	    case DRUGRUN: drugrun_PlayerJoinEvent(playerid);
	    case MONSTERSUMO: monster_PlayerJoinEvent(playerid);
		case BANGERSUMO: banger_PlayerJoinEvent(playerid);
		case SANDKSUMO: sandking_PlayerJoinEvent(playerid);
		case SANDKSUMORELOADED: sandkingR_PlayerJoinEvent(playerid);
		case DESTRUCTIONDERBY: derby_PlayerJoinEvent(playerid);
		case PURSUIT:
	    {
	        if(EventPlayersCount() == 11)
			{
	    		return SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: The event is full.");
			}

	        pursuit_PlayerJoinEvent(playerid);
	    }
	}
 	
 	if(Event_ID == MADDOGG || Event_ID == BIGSMOKE)
 	{
 	    FoCo_Event_Died[playerid]++;
 	}
	
	SetPVarInt(playerid, "PlayerStatus", 1);
	SetPVarInt(playerid, "InEvent", 1);
	
	foreach(Player, i)
	{
		if(Event_Players[i] == -1)
		{
			Event_Players[i] = playerid;
			break;
		}
	}
	return 1;
}

forward PlayerLeftEvent(playerid);
public PlayerLeftEvent(playerid)
{
	if(GetPVarInt(playerid, "PlayerStatus") == 0)
	{
		return 1;
	}
	
	SetPVarInt(playerid, "InEvent", 0);
	SetPVarInt(playerid, "PlayerStatus", 0);
	death[playerid] = 1;

	foreach(Player, i)
	{
		if(Event_Players[i] == playerid)
		{
			Event_Players[i] = -1;
			break;
		}
	}

	
	switch(Event_ID)
	{
	    case MINIGUN: minigun_PlayerLeftEvent(playerid);
	    case HYDRA: hydra_PlayerLeftEvent(playerid);
	    case JEFFTDM: jefftdm_PlayerLeftEvent(playerid);
	    case AREA51: area51_PlayerLeftEvent(playerid);
	    case ARMYVSTERRORISTS: army_PlayerLeftEvent(playerid);
	    case NAVYVSTERRORISTS: navy_PlayerLeftEvent(playerid);
	    case COMPOUND: compound_PlayerLeftEvent(playerid);
	    case OILRIG: oilrig_PlayerLeftEvent(playerid);
	    case DRUGRUN: drugrun_PlayerLeftEvent(playerid);
	    case MONSTERSUMO: sumo_PlayerLeftEvent(playerid);
	    case BANGERSUMO: sumo_PlayerLeftEvent(playerid);
	    case SANDKSUMO: sumo_PlayerLeftEvent(playerid);
	    case SANDKSUMORELOADED: sumo_PlayerLeftEvent(playerid);
		case DESTRUCTIONDERBY: sumo_PlayerLeftEvent(playerid);
		case PURSUIT: pursuit_PlayerLeftEvent(playerid);
	}

	return 1;
}

forward EndEvent();
public EndEvent()
{
    Event_InProgress = -1;
	if(Event_ID == HYDRA)
	{
	    KillTimer(hydraTime);
	}
	
	else if(Event_ID == PURSUIT)
	{
		KillTimer(PursuitTimer);
	}
	

	else if(Event_ID == GUNGAME)
	{
	    foreach(new i : Player)
	    {
	        TextDrawHideForPlayer(i, CurrLeader[i]);
			TextDrawHideForPlayer(i, CurrLeaderName[i]);
			TextDrawHideForPlayer(i, GunGame_MyKills[i]);
			TextDrawHideForPlayer(i, GunGame_Weapon[i]);
			GunGameKills[i] = 0;
	    }
	}

	foreach(new i : Player)
	{
		if(GetPVarInt(i, "InEvent") == 1 && death[i] == 0)
		{
		    if(Event_ID == JEFFTDM || Event_ID == ARMYVSTERRORISTS || Event_ID == DRUGRUN || Event_ID == PURSUIT || Event_ID == AREA51 || Event_ID == NAVYVSTERRORISTS || Event_ID == OILRIG || Event_ID == COMPOUND)
		    {
		        SetPVarInt(i, "MotelTeamIssued", 0);
				SetPlayerSkin(i, GetPVarInt(i, "MotelSkin"));
				SetPlayerColor(i, GetPVarInt(i, "MotelColor"));
				SetPlayerArmour(i, 0);

				if(Event_ID == NAVYVSTERRORISTS)
				{
				    DisablePlayerCheckpoint(i);
				}

				else if(Event_ID == PURSUIT)
				{
					SetPlayerMarkerForPlayer(i, FoCo_Criminal, GetPVarInt(FoCo_Criminal, "MotelColor"));
				}
		    }

		    if(Event_PlayerVeh[i] != -1)
			{
				DestroyVehicle(Event_PlayerVeh[i]);
				Event_PlayerVeh[i] = -1;
			}
			increment = 0;
			Motel_Team = 0;
			TogglePlayerControllable(i, 1);
		}
		
		if(GetPVarInt(i, "InEvent") == 1)
		{	
			if(IsPlayerInAnyVehicle(i))
			{
				RemovePlayerFromVehicle(i);
			}
			SetPlayerArmour(i, 0);
			event_SpawnPlayer(i);
		}
	}

	if(Event_ID == DRUGRUN || Event_ID == PURSUIT || Event_ID == NAVYVSTERRORISTS || Event_ID == COMPOUND || Event_ID == ARMYVSTERRORISTS)
	{
		for(new i; eventVehicles[i] != 0; i++)
		{
			DestroyVehicle(eventVehicles[i]);
			eventVehicles[i] = 0;
		}
		Iter_Clear(Event_Vehicles);
	}

	if(Event_ID == JEFFTDM || Event_ID == ARMYVSTERRORISTS || Event_ID == DRUGRUN || Event_ID == AREA51 || Event_ID == NAVYVSTERRORISTS || Event_ID == OILRIG || Event_ID == COMPOUND)
	{
        Team1_Motel = 0;
		Team2_Motel = 0;
	}

	FoCo_Criminal = -1;
	Event_ID = -1;

	/*if(EventPlayersCount() > 0)
	{
	    foreach(Player, i)
	    {
				if(Event_Players[i] != -1)
				{
	        event_SpawnPlayer(Event_Players[i]);
	      }
	    }
	 */
	foreach(Player, i)
	{
		Event_Players[i] = -1;
	}
		

	// Bodge Job fix for some errors (existing and new).
	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
		SetPVarInt(i, "PlayerStatus", 0);
		SetPVarInt(i, "InEvent", 0);
	}
	increment = 0;
	
	if(lastEventWon != -1)
	{
		EventGift(lastEventWon);
		lastEventWon = -1;
	}
	
	return 1;
}

forward EventGift(playerid);
public EventGift(playerid)
{
    new ran = random(200);
    new string[150];
	switch(ran)
	{
		case 0..24: //5k 25% chance
		{
		    if(isVIP(playerid) < 1)
		    {
		    GivePlayerMoney(playerid, 5000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $5000");
		    }
		    if(isVIP(playerid) == 1)
		    {
		    GivePlayerMoney(playerid, 6000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $6000");
		    }
		    if(isVIP(playerid) == 2)
		    {
		    GivePlayerMoney(playerid, 6500);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $6500");
		    }
		    if(isVIP(playerid) == 3)
		    {
		    GivePlayerMoney(playerid, 6000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $7500");
		    }
		}
		case 25..35:    //10% chance
		{
			if(isVIP(playerid) < 1)
		    {
		    GivePlayerMoney(playerid, 7500);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $7500");
		    }
		    if(isVIP(playerid) == 1)
		    {
		    GivePlayerMoney(playerid, 9000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $9000");
		    }
		    if(isVIP(playerid) == 2)
		    {
		    GivePlayerMoney(playerid, 9750);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $9750");
		    }
		    if(isVIP(playerid) == 3)
		    {
		    GivePlayerMoney(playerid, 11250);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $11250");
		    }
		}
		case 36..45:    //10% chance
		{
			if(isVIP(playerid) < 1)
		    {
		    GivePlayerMoney(playerid, 10000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $10000");
		    }
		    if(isVIP(playerid) == 1)
		    {
		    GivePlayerMoney(playerid, 12000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $12000");
		    }
		    if(isVIP(playerid) == 2)
		    {
		    GivePlayerMoney(playerid, 13000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $13000");
		    }
		    if(isVIP(playerid) == 3)
		    {
		    GivePlayerMoney(playerid, 15000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $15000");
		    }
		}
		case 46..50:    //5% chance
		{
			if(isVIP(playerid) < 1)
		    {
		    GivePlayerMoney(playerid, 20000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $20000");
		    }
		    if(isVIP(playerid) == 1)
		    {
		    GivePlayerMoney(playerid, 24000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $24000");
		    }
		    if(isVIP(playerid) == 2)
		    {
		    GivePlayerMoney(playerid, 26000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $26000");
		    }
		    if(isVIP(playerid) == 3)
		    {
		    GivePlayerMoney(playerid, 30000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $30000");
		    }
		}
		case 51..70:        //20% chance
		{
			SetPlayerArmour(playerid, 99);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 100 armour");
		}
		case 71..80:        //10% chance
		{
			format(string, sizeof(string), "[NOTICE]: %s has won an event and won the random Minigun.", PlayerName(playerid));
			SendAdminMessage(1,string);
			if(isVIP(playerid) < 1)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a minigun");
			GivePlayerWeapon(playerid, 38, 150);
			}
			if(isVIP(playerid) == 1)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a minigun");
			GivePlayerWeapon(playerid, 38, 175);
			}
			if(isVIP(playerid) == 2)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a minigun");
			GivePlayerWeapon(playerid, 38, 200);
			}
			if(isVIP(playerid) == 3)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a minigun");
			GivePlayerWeapon(playerid, 38, 225);
			}
		}
		case 81..90:    //10% chance
		{
		    if(isVIP(playerid) < 1)
		    {
			FoCo_Playerstats[playerid][kills] = FoCo_Playerstats[playerid][kills] + 10;
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 10 extra kills");
			}
			if(isVIP(playerid) == 1)
			{
			FoCo_Playerstats[playerid][kills] = FoCo_Playerstats[playerid][kills] + 11;
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 11 extra kills");
			}
			if(isVIP(playerid) == 2)
			{
			FoCo_Playerstats[playerid][kills] = FoCo_Playerstats[playerid][kills] + 13;
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 13 extra kills");
			}
			if(isVIP(playerid) == 3)
			{
			FoCo_Playerstats[playerid][kills] = FoCo_Playerstats[playerid][kills] + 15;
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 15 extra kills");
			}
		}
		case 91..100:       //10% chance
		{
		    if(isVIP(playerid) < 1)
		    {
			FoCo_Playerstats[playerid][deaths] = FoCo_Playerstats[playerid][deaths] - 10;
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 10 less deaths");
			}
			if(isVIP(playerid) == 1)
		    {
			FoCo_Playerstats[playerid][deaths] = FoCo_Playerstats[playerid][deaths] - 11;
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 11 less deaths");
			}
			if(isVIP(playerid) == 2)
		    {
			FoCo_Playerstats[playerid][deaths] = FoCo_Playerstats[playerid][deaths] - 13;
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 13 less deaths");
			}
			if(isVIP(playerid) == 3)
		    {
			FoCo_Playerstats[playerid][deaths] = FoCo_Playerstats[playerid][deaths] - 15;
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted 15 less deaths");
			}
			
		}
		case 101..102:      //1% chance
		{
			if(isVIP(playerid) < 1)
		    {
		    GivePlayerMoney(playerid, 50000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $50000");
		    }
		    if(isVIP(playerid) == 1)
		    {
		    GivePlayerMoney(playerid, 60000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $60000");
		    }
		    if(isVIP(playerid) == 2)
		    {
		    GivePlayerMoney(playerid, 65000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $65000");
		    }
		    if(isVIP(playerid) == 3)
		    {
		    GivePlayerMoney(playerid, 75000);
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted $75000");
		    }
		}
		case 103..113:      //10% chance
		{
			format(string, sizeof(string), "[NOTICE]: %s has won an event and won the random RPG.", PlayerName(playerid));
			SendAdminMessage(1,string);
			if(isVIP(playerid) < 1)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an RPG");
			GivePlayerWeapon(playerid, 35, 5);
			}
			if(isVIP(playerid) == 1)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an RPG");
			GivePlayerWeapon(playerid, 35, 6);
			}
			if(isVIP(playerid) == 2)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an RPG");
			GivePlayerWeapon(playerid, 35, 7);
			}
			if(isVIP(playerid) == 3)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an RPG");
			GivePlayerWeapon(playerid, 35, 8);
			}
		}
		case 114..120:      //7% chance
		{
			format(string, sizeof(string), "[NOTICE]: %s has won an event and won the random heat-seeking RPG.", PlayerName(playerid));
			SendAdminMessage(1,string);
			if(isVIP(playerid) < 1)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an RPG");
			GivePlayerWeapon(playerid, 36, 5);
			}
			if(isVIP(playerid) == 1)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an RPG");
			GivePlayerWeapon(playerid, 36, 6);
			}
			if(isVIP(playerid) == 2)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an RPG");
			GivePlayerWeapon(playerid, 36, 7);
			}
			if(isVIP(playerid) == 3)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an RPG");
			GivePlayerWeapon(playerid, 36, 8);
   			}
		}
		case 121..130:      // 10% chance
		{
			format(string, sizeof(string), "[NOTICE]: %s has won an event and won the random flamethrower", PlayerName(playerid));
			SendAdminMessage(1,string);
			if(isVIP(playerid) < 1)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an flamethrower");
			GivePlayerWeapon(playerid, 37, 10);
			}
			if(isVIP(playerid) == 1)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an flamethrower");
			GivePlayerWeapon(playerid, 37, 12);
			}
			if(isVIP(playerid) == 2)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an flamethrower");
			GivePlayerWeapon(playerid, 37, 14);
			}
			if(isVIP(playerid) == 3)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted an flamethrower");
			GivePlayerWeapon(playerid, 37, 14);
   			}
		}
		case 131..140:      //10% chance
		{
			format(string, sizeof(string), "[NOTICE]: %s has won an event and won the random grenades", PlayerName(playerid));
			SendAdminMessage(1,string);
			if(isVIP(playerid) < 1)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted grenades");
			GivePlayerWeapon(playerid, 16, 5);
			}
			if(isVIP(playerid) == 1)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted grenades");
			GivePlayerWeapon(playerid, 16, 6);
			}
			if(isVIP(playerid) == 2)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted grenades");
			GivePlayerWeapon(playerid, 16, 7);
			}
			if(isVIP(playerid) == 3)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted grenades");
			GivePlayerWeapon(playerid, 16, 8);
   			}
		}
		case 141..150:      //10% chance
		{
			format(string, sizeof(string), "[NOTICE]: %s has won an event and won the random fire extinguisher", PlayerName(playerid));
			SendAdminMessage(1,string);
			if(isVIP(playerid) < 1)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a fire extinguisher");
			GivePlayerWeapon(playerid, 42, 15);
			}
			if(isVIP(playerid) == 1)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a fire extinguisher");
			GivePlayerWeapon(playerid, 42, 20);
			}
			if(isVIP(playerid) == 2)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a fire extinguisher");
			GivePlayerWeapon(playerid, 42, 25);
			}
			if(isVIP(playerid) == 3)
			{
			SendClientMessage(playerid, COLOR_NOTICE, "[Event Gift]: For winning the event you have been gifted a fire extinguisher");
			GivePlayerWeapon(playerid, 42, 30);
   			}
		}
		default:
		{
			format(string, sizeof(string), "[Event Notice]: Unfortunately there was no reward for winning this event.");
            SendClientMessage(playerid, COLOR_NOTICE, "string");
		}
	}

	return 1;
}

/* Event sub-functions */

/* Area 51 */

public area51_EventStart(playerid)
{
   	new
	    string[128];

	FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	Event_ID = AREA51;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}United Special Forces vs. Nuclear Scientists Team DM {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
}


public area51_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);

	if(Motel_Team == 0)
	{

		SetPVarInt(playerid, "MotelTeamIssued", 1);
		////SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 287);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, area51SpawnsAF[increment][0], area51SpawnsAF[increment][1], area51SpawnsAF[increment][2]);
		SetPlayerFacingAngle(playerid, area51SpawnsAF[increment][3]);
		Motel_Team = 1;
		increment++;
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		////SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 70);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, area51SpawnsCrim[increment-1][0], area51SpawnsCrim[increment-1][1], area51SpawnsCrim[increment-1][2]);
		SetPlayerFacingAngle(playerid, area51SpawnsCrim[increment-1][3]);
		Motel_Team = 0;
	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 25, 500);
	GivePlayerWeapon(playerid, 31, 500);
	GameTextForPlayer(playerid, "~R~~n~~n~ Area 51 ~h~ TDM!~n~~n~ ~w~You are now in the queue", 4000, 3);
	return 1;
}


public area51_PlayerLeftEvent(playerid)
{
	new
	    t1,
	    t2;
	new
	    msg[128];

    if(GetPlayerSkin(playerid) == 70)
	{
		Team1_Motel++;
	}

	else if(GetPlayerSkin(playerid) == 287)
	{
		Team2_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: US Special Forces %d - %d Nuclear Scientists", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);

	SetPVarInt(playerid, "MotelTeamIssued", 0);

	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				t1++;
			}
			else if(GetPVarInt(i, "MotelTeamIssued") == 2)
			{
				t2++;
			}
		}
	}

	if(t1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Nuclear Scientists have won the event!");
		return 1;
	}
	else if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The US Special Forces have won the event!");
		return 1;
	}
	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}
	return 1;
}


public area51_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Area 51 DM is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
	return 1;
}

/* Army vs. Terrorists */

public army_EventStart(playerid)
{
   	new
	    string[128];

	FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	Event_ID = ARMYVSTERRORISTS;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Army vs. Terrorists Team DM {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	
	for(new i; i < 3; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			new eCarID = CreateVehicle(NavyTerroristVehicles[i][modelID], NavyTerroristVehicles[i][dX], NavyTerroristVehicles[i][dY], NavyTerroristVehicles[i][dZ], NavyTerroristVehicles[i][Rotation], -1, -1, 600000);
			SetVehicleVirtualWorld(eCarID, 1500);
			eventVehicles[i] = eCarID;
			Iter_Add(Event_Vehicles, eCarID);
		}

		else
		{
			break;
		}
	}

	return 1;
}


public army_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);
	if(Motel_Team == 0)
	{
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		////SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 287);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, armySpawnsType1[increment][0], armySpawnsType1[increment][1], armySpawnsType1[increment][2]);
		SetPlayerFacingAngle(playerid, armySpawnsType1[increment][3]);
		Motel_Team = 1;
		increment++;
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		////SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 73);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, armySpawnsType2[increment-1][0], armySpawnsType2[increment-1][1], armySpawnsType2[increment-1][2]);
		SetPlayerFacingAngle(playerid, armySpawnsType2[increment-1][3]);
		Motel_Team = 0;
	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 31, 750);
	GivePlayerWeapon(playerid, 34, 50);
	GameTextForPlayer(playerid, "~R~~n~~n~ Army vs. Terrorists ~h~ TDM!~n~~n~ ~w~You are now in the queue", 4000, 3);

	return 1;
}


public army_PlayerLeftEvent(playerid)
{
    new
		t1,
		t2,
		msg[128];

	if(GetPlayerSkin(playerid) == 287)
	{
		Team2_Motel++;
	}
	else if(GetPlayerSkin(playerid) == 73)
	{
		Team1_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: Army %d - %d Terrorists", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);

	SetPVarInt(playerid, "MotelTeamIssued", 0);


	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				t1++;
			}
			else if(GetPVarInt(i, "MotelTeamIssued") == 2)
			{
				t2++;
			}
		}
	}

	if(t1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Terrorists have won the event!");
		return 1;
	}

	else if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Army have won the event!");
		return 1;
	}

	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}

	return 1;
}


public army_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Army vs. Terrorists DM is now in progress and can not be joined");
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
}

/* Big Smoke */

public bs_EventStart(playerid)
{
    new
	    string[150];

    Event_ID = BIGSMOKE;
    if(FoCo_Event_Rejoin == 1)
    {
        format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Bigsmoke {%06x}event.  Type /join! - This event is rejoinable.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
    }
    if(FoCo_Event_Rejoin == 0)
    {
        format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Bigsmoke {%06x}event.  Type /join! - This event is NOT rejoinable.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
    }
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	return 1;
}


public bs_PlayerJoinEvent(playerid)
{
	if(FFAArmour == 1)
    {
		SetPlayerArmour(playerid, 99);
	}

	else
	{
	    SetPlayerArmour(playerid, 0);
	}

	new randomnum = random(20);
	SetPlayerHealth(playerid, 99);
	SetPlayerInterior(playerid, 2);
	SetPlayerPos(playerid, BigSmokeSpawns[randomnum][0], BigSmokeSpawns[randomnum][1], BigSmokeSpawns[randomnum][2]);
	SetPlayerVirtualWorld(playerid, 1500);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, FFAWeapons, 500);
	GameTextForPlayer(playerid, "~R~~n~~n~ Big ~h~ Smoke!", 800, 3);
	return 1;
}

/* Brawl */

public brawl_EventStart(playerid)
{
    if(BrawlX == 0.0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Set the brawl point first");
		return 1;
	}

   	new
	    string[128];

	Event_ID = BRAWL;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Brawl event. {%06x}Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	return 1;
}


public brawl_PlayerJoinEvent(playerid)
{
	GiveAchievement(playerid, 24);
	SetPVarInt(playerid,"PlayerStatus",1);
	SetPlayerPos(playerid, BrawlX, BrawlY, BrawlZ);
	SetPlayerFacingAngle(playerid, BrawlA);
	SetPlayerInterior(playerid, BrawlInt);
	SetPlayerHealth(playerid, 99);
	SetPlayerArmour(playerid, 0);
	SetPlayerVirtualWorld(playerid, BrawlVW);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ The ~h~ Brawl!", 800, 3);
	return 1;
}

/* Compound */

public compound_EventStart(playerid)
{
	FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

   	new
	    string[128];

	Event_ID = COMPOUND;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Compound Attack {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	
	for(new i; i < 9; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			new eCarID = CreateVehicle(compoundVehicles[i][modelID], compoundVehicles[i][dX], compoundVehicles[i][dY], compoundVehicles[i][dZ], compoundVehicles[i][Rotation], -1, -1, 600000);
			SetVehicleVirtualWorld(eCarID, 1500);
			eventVehicles[i] = eCarID;
			Iter_Add(Event_Vehicles, eCarID);
		}

		else
		{
			break;
		}
	}
	return 1;
}


public compound_PlayerJoinEvent(playerid)
{
    SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);

	if(Motel_Team == 0)
	{
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		////SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 287);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, swatcompoundattack[increment][0], swatcompoundattack[increment][1], swatcompoundattack[increment][2]);
		SetPlayerFacingAngle(playerid, swatcompoundattack[increment][3]);
		Motel_Team = 1;
		increment++;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the Compound.");
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 221);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, terroristcoumpoundattack[increment-1][0], terroristcoumpoundattack[increment-1][1], terroristcoumpoundattack[increment-1][2]);
		SetPlayerFacingAngle(playerid, terroristcoumpoundattack[increment-1][3]);
		Motel_Team = 0;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the Compound ...");
	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 33, 30);
	GivePlayerWeapon(playerid, 31, 500);
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ Compound Attack ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
	return 1;
}


public compound_PlayerLeftEvent(playerid)
{
    new
		t1,
		t2,
		msg[128];

	if(GetPlayerSkin(playerid) == 221)
	{
		Team1_Motel++;
	}
	else if(GetPlayerSkin(playerid) == 287)
	{
		Team2_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: SWAT %d - %d Terrorists", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);

	SetPVarInt(playerid, "MotelTeamIssued", 0);

	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				t1++;
			}
			else if(GetPVarInt(i, "MotelTeamIssued") == 2)
			{
				t2++;
			}
		}
	}

	if(t1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Terrorists have won the event!");
		return 1;
	}

	else if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: SWAT have won the event!");
		return 1;
	}

	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}
	return 1;
}


public compound_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Compound Attack is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				SetPlayerCheckpoint(i, -2126.5669,-84.7937,35.3203,2.3031);
			}
		}
	}
}

/* Drug Run */

public drugrun_EventStart(playerid)
{
    FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
		EventDrugDelay[i] = -1;
	}

   	new
	    string[128];

	Event_ID = DRUGRUN;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Team Drug Run {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;

	Iter_Clear(Event_Vehicles);

	for(new i; i < 16; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			new eCarID = CreateVehicle(DrugRunVehicles[i][modelID], DrugRunVehicles[i][dX], DrugRunVehicles[i][dY], DrugRunVehicles[i][dZ], DrugRunVehicles[i][Rotation], 1, 1, 600000);
			SetVehicleVirtualWorld(eCarID, 1500);
			eventVehicles[i] = eCarID;
			Iter_Add(Event_Vehicles, eCarID);
		}

		else 
		{
			break; 
		}
	}

	return 1;
}


public drugrun_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);

	if(Motel_Team == 0)
	{
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 285);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, drugSpawnsType1[increment][0], drugSpawnsType1[increment][1], drugSpawnsType1[increment][2]);
		SetPlayerFacingAngle(playerid, drugSpawnsType1[increment][3]);
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the checkpoint, don't let a drug runner enter ...");
		SendClientMessage(playerid, COLOR_GREEN, ".. it else they will win, you will win by eliminating there team..");
		Motel_Team = 1;
		increment++;
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 21);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, drugSpawnsType2[increment-1][0], drugSpawnsType2[increment-1][1], drugSpawnsType2[increment-1][2]);
		SetPlayerFacingAngle(playerid, drugSpawnsType2[increment-1][3]);
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the checkpoint, don't let the SWAT team ...");
		SendClientMessage(playerid, COLOR_GREEN, ".. kill you else you will lose. Your team MUST drop off the package..");
		Motel_Team = 0;
	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 31, 500);
	GameTextForPlayer(playerid, "~R~~n~~n~ Team Drug ~h~ Run!~n~~n~ ~w~You are now in the queue", 4000, 3);

	return 1;
}


public drugrun_PlayerLeftEvent(playerid)
{
   	new
	   t1,
	   t2,
	   msg[128];

    if(GetPlayerSkin(playerid) == 285)
	{
		Team2_Motel++;
	}
	else if(GetPlayerSkin(playerid) == 21)
	{
		Team1_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: SWAT %d - %d Drug Runners", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);
	DisablePlayerCheckpoint(playerid);

	SetPVarInt(playerid, "MotelTeamIssued", 0);

	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				t1++;
			}
			else if(GetPVarInt(i, "MotelTeamIssued") == 2)
			{
				t2++;
			}
		}
	}

	if(t1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: Criminals have won the event!");

		return 1;
	}
	
	if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: S.W.A.T have won the event!");

		return 1;
	}

	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}

	return 1;
}


public drugrun_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Team Drug Run is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
			SetPlayerCheckpoint(i, 1421.5542,2773.9951,10.8203, 4.0);
		}
	}
}

/* Hydra */

public hydra_EventStart(playerid)
{
    Event_ID = HYDRA;

	new
   	    string[128];
	
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Hydra wars event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	// SendClientMessageToAll(COLOR_CMDNOTICE, "[EVENT]: 30 seconds before it starts, type /join!");
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	return 1;
}


public hydra_PlayerJoinEvent(playerid)
{
    if(EventPlayersCount() == 12)
	{
		return SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
	}

	SetPlayerVirtualWorld(playerid, 505);
	SetPlayerPos(playerid, hydraSpawnsType1[increment][0], hydraSpawnsType1[increment][1], hydraSpawnsType1[increment][2]);
	Event_PlayerVeh[playerid] = CreateVehicle(520, hydraSpawnsType1[increment][0], hydraSpawnsType1[increment][1], hydraSpawnsType1[increment][2], hydraSpawnsType1[increment][3], -1, -1, 15);
	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	PutPlayerInVehicle(playerid, Event_PlayerVeh[playerid], 0);
	GameTextForPlayer(playerid, "~R~~n~~n~ HYDRA ~n~ WARS", 1500, 3);
	TogglePlayerControllable(playerid, 0);
	increment++;
	return 1;
}


public hydra_PlayerLeftEvent(playerid)
{
	SetPVarInt(playerid, "LeftEventJust", 1);
	event_SpawnPlayer(playerid);

	new
	    msg[128];

	if(EventPlayersCount() == 1)
	{
		
		foreach(Player, i)
		{
			if(GetPVarInt(i, "InEvent") == 1)
			{
				winner = i;
				break;
			}
		}
	
		format(msg, sizeof(msg), "				%s has won the Hydra Wars event!", PlayerName(winner));
		SendClientMessageToAll(COLOR_NOTICE, msg);
		SendClientMessage(winner, COLOR_NOTICE, "You have won the Hydra Wars event! You have earnt 10 score!");
		FoCo_Player[winner][score] = FoCo_Player[winner][score] + 10;
		lastEventWon = winner;
		EndEvent();
	}

	return 1;
}


public hydra_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Hydra wars is now in progress and can not be joined");
	hydraTime = SetTimer("EndEvent", 480000, false);
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
		}
	}
}

/* Jeff TDM */

public jefftdm_EventStart(playerid)
{

   	new
	    string[128];

	FoCo_Event_Rejoin = 0;

    foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	Event_ID = JEFFTDM;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Jefferson Motel Team DM {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	return 1;
}


public jefftdm_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 15);

	if(Motel_Team == 0)
	{
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 285);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, motelSpawnsType1[increment][0], motelSpawnsType1[increment][1], motelSpawnsType1[increment][2]);
		SetPlayerFacingAngle(playerid, motelSpawnsType1[increment][3]);
		Motel_Team = 1;
		increment++;
	}

	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 50);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, motelSpawnsType2[increment-1][0], motelSpawnsType2[increment-1][1], motelSpawnsType2[increment-1][2]);
		SetPlayerFacingAngle(playerid, motelSpawnsType2[increment-1][3]);
		Motel_Team = 0;
	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 31, 500);
    TogglePlayerControllable(playerid, 0);
	GameTextForPlayer(playerid, "~R~~n~~n~ Motel ~h~ TDM!~n~~n~ ~w~You are now in the queue", 4000, 3);
	return 1;
}


public jefftdm_PlayerLeftEvent(playerid)
{
    new
		t1,
		t2,
		msg[128];

	if(GetPlayerSkin(playerid) == 285)
	{
		Team2_Motel++;
	}
	else if(GetPlayerSkin(playerid) == 50)
	{
		Team1_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: S.W.A.T %d - %d Criminals", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);

	SetPVarInt(playerid, "MotelTeamIssued", 0);

	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				t1++;
			}
			else if(GetPVarInt(i, "MotelTeamIssued") == 2)
			{
				t2++;
			}
		}
	}

	if(t1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: Criminals have won the event!");
		return 1;
	}

	else if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: S.W.A.T have won the event!");
		return 1;
	}

	/*if(EventPlayersCount() == 1)
	{
		EndEvent();
	}*/
	return 1;
}


public jefftdm_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Jefferson Motel DM is now in progress and can not be joined");
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
}

/* Mad Doggs */

public md_EventStart(playerid)
{
	   	new
		    string[150];

	    Event_ID = MADDOGG;
	    if(FoCo_Event_Rejoin == 1)
	    {
	        format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Mad Dogg's Mansion DM {%06x}event.  Type /join! - This event is rejoinable.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	    }
	    if(FoCo_Event_Rejoin == 0)
	    {
	        format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Mad Dogg's Mansion DM {%06x}event.  Type /join! - This event is NOT rejoinable.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	    }
		SendClientMessageToAll(COLOR_CMDNOTICE, string);
		IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
		Event_InProgress = 0;
		return 1;
}


public md_PlayerJoinEvent(playerid)
{
	if(Event_ID == MADDOGG)
	{
	    if(FFAArmour == 1)
        {
			SetPlayerArmour(playerid, 99);
		}

		else
		{
		    SetPlayerArmour(playerid, 0);
		}

		SetPlayerHealth(playerid, 99);
		SetPlayerVirtualWorld(playerid, 1500);
		SetPlayerInterior(playerid, 5);
		new randomnum = random(25);
		SetPlayerPos(playerid, MadDogSpawns[randomnum][0], MadDogSpawns[randomnum][1], MadDogSpawns[randomnum][2]);
		SetPlayerFacingAngle(playerid, MadDogSpawns[randomnum][3]);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, FFAWeapons, 500);
		GameTextForPlayer(playerid, "~R~~n~~n~ Mad ~h~ Doggs!", 800, 3);
	}
	return 1;
}

/* Minigun */

public minigun_EventStart(playerid)
{
   	new
	    string[128];

	Event_ID = MINIGUN;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Minigun Wars {%06x}event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	SendClientMessageToAll(COLOR_CMDNOTICE,  "[EVENT]: 30 seconds before it starts, type /join!");
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	return 1;
}


public minigun_PlayerJoinEvent(playerid)
{
    if(EventPlayersCount() == 17)
	{
		return SendClientMessage(playerid, COLOR_NOTICE, "                This event is full");
	}

	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerPos(playerid, minigunSpawnsType1[increment][0], minigunSpawnsType1[increment][1], minigunSpawnsType1[increment][2]);
	SetPlayerFacingAngle(playerid, minigunSpawnsType1[increment][3]);
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 38, 3000);
	GameTextForPlayer(playerid, "~R~~n~~n~ MINIGUN ~n~ WARS", 1500, 3);
	TogglePlayerControllable(playerid, 0);
	increment++;
	return 1;
}


public minigun_PlayerLeftEvent(playerid)
{
    SetPVarInt(playerid, "LeftEventJust", 1);

	if(EventPlayersCount() == 1)
	{
		new
				msg[128];
	        
		foreach(Player, i)
		{
			if(GetPVarInt(i, "InEvent") == 1)
			{
				winner = i;
				break;
			}
		}
		
		format(msg, sizeof(msg), "				%s has won the Minigun Wars event!", PlayerName(winner));
		SendClientMessageToAll(COLOR_NOTICE, msg);
		SendClientMessage(winner, COLOR_NOTICE, "You have won the Minigun Wars event! You have earnt 10 score!");
		FoCo_Player[winner][score] += 10;
		lastEventWon = winner;
		EndEvent();
	}
	return 1;
}


public minigun_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Minigun wars is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
		}
	}
}

/* Navy vs Terrorists */

public navy_EventStart(playerid)
{
	FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

   	new
	    string[128];
		
	Event_ID = NAVYVSTERRORISTS;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Navy Seals vs. Terrorists {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	
	for(new i; i < 12; i++)
	{
		if(i < MAX_EVENT_VEHICLES)
		{
			new eCarID = CreateVehicle(navyVehicles[i][modelID], navyVehicles[i][dX], navyVehicles[i][dY], navyVehicles[i][dZ], navyVehicles[i][Rotation], -1, -1, 600000);
			SetVehicleVirtualWorld(eCarID, 1500);
			eventVehicles[i] = eCarID;
			Iter_Add(Event_Vehicles, eCarID);
		}

		else 
		{
			break; 
		}
	}
	
	return 1;
}


public navy_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);

	if(Motel_Team == 0)
	{
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 287);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, navySealsBoat[increment][0], navySealsBoat[increment][1], navySealsBoat[increment][2]);
		SetPlayerFacingAngle(playerid, navySealsBoat[increment][3]);
		Motel_Team = 1;
		increment++;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the boat in the checkpoint and eliminate all terrorist activity.");
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 221);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, terroristsBoat[increment-1][0], terroristsBoat[increment-1][1], terroristsBoat[increment-1][2]);
		SetPlayerFacingAngle(playerid, terroristsBoat[increment-1][3]);
		Motel_Team = 0;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the boat at all costs ...");
	}


	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 29, 750);
	GivePlayerWeapon(playerid, 31, 500);
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ Navy Seals Vs. Terrorists ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
	return 1;
}


public navy_PlayerLeftEvent(playerid)
{
   	new
	   	t1,
		t2,
		msg[128];

    if(GetPlayerSkin(playerid) == 221)
	{
		Team1_Motel++;
	}
	else if(GetPlayerSkin(playerid) == 287)
	{
		Team2_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: Navy Seals %d - %d Terrorists", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);

	SetPVarInt(playerid, "MotelTeamIssued", 0);

	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				t1++;
			}
			else if(GetPVarInt(i, "MotelTeamIssued") == 2)
			{
				t2++;
			}
		}
	}
	if(t1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Terrorists have won the event!");
		return 1;
	}
	else if(t2 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Navy Seals have won the event!");
		return 1;
	}
	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}
	return 1;
}


public navy_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Navy Seals Vs. Terrorists is now in progress and can not be joined");
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
			DisablePlayerCheckpoint(i);
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				SetPlayerCheckpoint(i, -1446.6353,1502.6423,1.7366, 4.0);
			}
		}
	}
}

/* Oil Rig */

public oilrig_EventStart(playerid)
{
    FoCo_Event_Rejoin = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

	new
	    string[128];

	Event_ID = OILRIG;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Oil Rig Terrorists {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	return 1;
}


public oilrig_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);

	if(Motel_Team == 0)
	{
		SetPVarInt(playerid, "MotelTeamIssued", 1);
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 287);
		SetPlayerColor(playerid, COLOR_BLUE);
		SetPlayerPos(playerid, swatoilrigspawns1[increment][0], swatoilrigspawns1[increment][1], swatoilrigspawns1[increment][2] + 4);
		SetPlayerFacingAngle(playerid, swatoilrigspawns1[increment][3]);
		Motel_Team = 1;
		increment++;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Attack the Oil Rig.");
	}
	else
	{
 		SetPVarInt(playerid, "MotelTeamIssued", 2);
		//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 221);
		SetPlayerColor(playerid, COLOR_RED);
		SetPlayerPos(playerid, terroristoilrigspawns1[increment-1][0], terroristoilrigspawns1[increment-1][1], terroristoilrigspawns1[increment-1][2]);
		SetPlayerFacingAngle(playerid, terroristoilrigspawns1[increment-1][3]);
		Motel_Team = 0;
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Defend the Oil Rig ...");
	}
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 27, 50);
	GivePlayerWeapon(playerid, 31, 500);
	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, "~R~~n~~n~ Oil Rig Terrorists ~h~~n~~n~ ~w~You are now in the queue", 4000, 3);
	return 1;
}


public oilrig_PlayerLeftEvent(playerid)
{
    new
		t1,
		t2,
		msg[128];

	if(GetPlayerSkin(playerid) == 221)
	{
		Team1_Motel++;
	}
	else if(GetPlayerSkin(playerid) == 287)
	{
		Team2_Motel++;
	}

	format(msg, sizeof(msg), "[EVENT SCORE]: SWAT %d - %d Terrorists", Team1_Motel, Team2_Motel);
	SendClientMessageToAll(COLOR_NOTICE, msg);

	SetPVarInt(playerid, "MotelTeamIssued", 0);

	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "MotelTeamIssued") == 1)
			{
				t1++;
			}
			else if(GetPVarInt(i, "MotelTeamIssued") == 2)
			{
				t2++;
			}
		}
	}

	if(t1 == 0)
	{
		EndEvent();
		increment = 0;
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The Terrorists have won the event!");
		return 1;
	}

	else if(t2 == 0)
	{
		EndEvent();
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: SWAT have won the event!");
		increment = 0;
		return 1;
	}

	if(EventPlayersCount() == 1)
	{
		EndEvent();
	}
	return 1;
}


public oilrig_OneSecond()
{
    SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Oil Rig Terrorists is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
}

/* Pursuit */

public pursuit_EventStart(playerid)
{
    FoCo_Event_Rejoin = 0;
    team_issue = 0;

	foreach(Player, i)
	{
		FoCo_Event_Died[i] = 0;
	}

   	new
	    string[128];

	Event_ID = PURSUIT;
	format(string, sizeof(string), "[EVENT]: %s %s has started {%06x}Pursuit {%06x}event.  Type /join!", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8, COLOR_CMDNOTICE >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;

	new car;
	caridx = 0;
	Iter_Clear(Event_Vehicles);
	for(new i = 0; i < 11; i++)
	{
		if(i == 10)
		{
			car = CreateVehicle(Random_Pursuit_Vehicle(), pursuitVehicles[i][0], pursuitVehicles[i][1], pursuitVehicles[i][2], pursuitVehicles[i][3], -1, -1, 600000);
			SetVehicleVirtualWorld(car, 1500);
			E_Pursuit_Criminal = car;
			eventVehicles[i] = car;
		}
		else
		{
			if(i < MAX_EVENT_VEHICLES)
			{
				car = CreateVehicle(596, pursuitVehicles[i][0], pursuitVehicles[i][1], pursuitVehicles[i][2], pursuitVehicles[i][3], 0, 1, 600000);
				SetVehicleVirtualWorld(car, 1500);
				eventVehicles[i] = car;
				Iter_Add(Event_Vehicles, car);
				
				/*if(i == 0)
				{
					Pursuit_Car = car;
				}*/
			}

			else
			{
				break;
			}
		}

		
	}
	return 1;
}


public pursuit_PlayerJoinEvent(playerid)
{
	SetPlayerArmour(playerid, 99);
	SetPlayerHealth(playerid, 99);
	SetPlayerVirtualWorld(playerid, 1500);
	SetPlayerInterior(playerid, 0);

	if(Motel_Team == 0)
	{
		Motel_Team = 1;
		SetPVarInt(playerid, "MotelTeamIssued", 1);
	//	//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
	//	//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerColor(playerid, COLOR_RED);
		FoCo_Criminal = playerid;
		PursuitTimer = SetTimer("EndPursuit", 300000, false);
		SetPlayerSkin(playerid, 50);
		PutPlayerInVehicle(playerid, E_Pursuit_Criminal, 0);
		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Stay alive, evade the PD ...");
	}
	else
	{
		SetPVarInt(playerid, "MotelTeamIssued", 2);
	//	//SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
	//	//SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
		SetPlayerSkin(playerid, 280);
		SetPlayerColor(playerid, COLOR_BLUE);
		team_issue++;

        PutPlayerInVehicle(playerid, eventVehicles[caridx], 0);
        caridx++;

		SendClientMessage(playerid, COLOR_GREEN, "[OBJECTIVE]: Take out the criminal car at all costs ...");

		if(FoCo_Criminal != INVALID_PLAYER_ID)
		{
			SetPlayerMarkerForPlayer( playerid, FoCo_Criminal, 0xFFFFFF00);
		}
 	}

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 25, 500);
	GameTextForPlayer(playerid, "~R~~n~~n~ Pursuit ~h~ ~n~~n~ ~w~You are now in the queue", 4000, 3);
	return 1;
}


public pursuit_PlayerLeftEvent(playerid)
{
    if(playerid == FoCo_Criminal)
	{
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the criminal being caught!");
		EndEvent();
	}

	if(GetPVarInt(playerid, "MotelTeamIssued") == 2)
	{
     	team_issue--;
	}
	
	if(team_issue == 0)
	{
		SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the police being killed!");
		EndEvent();
	}
	

	SetPVarInt(playerid, "MotelTeamIssued", 0);
	//SetPlayerSkin(playerid, GetPVarInt(playerid, "MotelSkin"));
	//SetPlayerColor(playerid, GetPVarInt(playerid, "MotelColor"));

	return 1;
}


public EndPursuit()
{
	SendClientMessageToAll(COLOR_NOTICE, "[EVENT NEWS]: The pursuit has ended due to the criminal getting away!");
	EndEvent();

	Motel_Team = 0;
	KillTimer(PursuitTimer);
	return 1;
}


public pursuit_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Pursuit is now in progress and can not be joined");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			TogglePlayerControllable(i, 1);
			increment = 0;
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
		}
	}
}


public Random_Pursuit_Vehicle()
{
	new randVeh, vehicle;
	randVeh = random(50);
	switch(randVeh)
	{
		case 0: { vehicle = 402; }
		case 1: { vehicle = 405; }
		case 2: { vehicle = 402; }
		case 3: { vehicle = 426; }
		case 4: { vehicle = 434; }
		case 5: { vehicle = 439; }
		case 6: { vehicle = 402; }
		case 7: { vehicle = 489; }
		case 8: { vehicle = 495; }
		case 9: { vehicle = 412; }
		case 10: { vehicle = 419; }
		case 11: { vehicle = 421; }
		case 12: { vehicle = 422; }
		case 13: { vehicle = 426; }
		case 14: { vehicle = 436; }
		case 15: { vehicle = 445; }
		case 16: { vehicle = 466; }
		case 17: { vehicle = 467; }
		case 18: { vehicle = 470; }
		case 19: { vehicle = 474; }
		case 20: { vehicle = 475; }
		case 21: { vehicle = 477; }
		case 22: { vehicle = 491; }
		case 23: { vehicle = 492; }
		case 24: { vehicle = 500; }
		case 25: { vehicle = 506; }
		case 26: { vehicle = 508; }
		case 27: { vehicle = 516; }
		case 28: { vehicle = 517; }
		case 29: { vehicle = 526; }
		case 30: { vehicle = 527; }
		case 31: { vehicle = 529; }
		case 32: { vehicle = 533; }
		case 33: { vehicle = 534; }
		case 34: { vehicle = 535; }
		case 35: { vehicle = 536; }
		case 36: { vehicle = 537; }
		case 37: { vehicle = 540; }
		case 38: { vehicle = 542; }
		case 39: { vehicle = 549; }
		case 40: { vehicle = 550; }
		case 41: { vehicle = 555; }
		case 42: { vehicle = 566; }
		case 43: { vehicle = 567; }
		case 44: { vehicle = 575; }
		case 45: { vehicle = 576; }
		case 46: { vehicle = 579; }
		case 47: { vehicle = 580; }
		case 48: { vehicle = 587; }
		case 49: { vehicle = 602; }
		case 50: { vehicle = 603; }
	}
	return vehicle;
}

/* Sumo */

public monster_EventStart(playerid)
{
   	new
	    string[128];

    Event_ID = MONSTERSUMO;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Monster Sumo event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "[EVENT]: 30 seconds before it starts, type /join! Map by {%06x}Rayoo.", COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	return 1;
}



public banger_EventStart(playerid)
{
   	new
	    string[128];

	Event_ID = BANGERSUMO;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Banger Sumo event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "[EVENT]: 30 seconds before it starts, type /join! Map by {%06x}Tsar.", COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	return 1;
}



public sandking_EventStart(playerid)
{
   	new
	    string[128];

	Event_ID = SANDKSUMO;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}SandKing Sumo event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "[EVENT]: 30 seconds before it starts, type /join! Map by {%06x}RakGuy.", COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	return 1;
}



public sandkingR_EventStart(playerid)
{
   	new
	    string[128];

	Event_ID = SANDKSUMORELOADED;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}SandKing Sumo Reloaded event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "[EVENT]: 30 seconds before it starts, type /join! Map by {%06x}RakGuy & Dr_Death.",COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	return 1;
}


public derby_EventStart(playerid)
{
   	new
	    string[128];

	Event_ID = DESTRUCTIONDERBY;
	format(string, sizeof(string), "[EVENT]: %s %s has started the {%06x}Destruction Derby event.", GetPlayerStatus(playerid), PlayerName(playerid), COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	format(string, sizeof(string), "30 seconds before it starts, type /join! Map by {%06x}Hiro.", COLOR_WARNING >>> 8);
	SendClientMessageToAll(COLOR_CMDNOTICE, string);
	IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
	Event_InProgress = 0;
	Event_Delay = 30;
	return 1;
}


public monster_PlayerJoinEvent(playerid)
{
    SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 505);

	SetPlayerPos(playerid, sumoSpawnsType1[increment][0], sumoSpawnsType1[increment][1], sumoSpawnsType1[increment][2]+5);
	SetPlayerFacingAngle(playerid, sumoSpawnsType1[increment][3]);
	Event_PlayerVeh[playerid] = CreateVehicle(556, sumoSpawnsType1[increment][0], sumoSpawnsType1[increment][1], sumoSpawnsType1[increment][2], sumoSpawnsType1[increment][3], -1, -1, 15);
	SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType1[increment][3]);

	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
	TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);
	increment++;
	return 1;

}


public banger_PlayerJoinEvent(playerid)
{
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 505);

	SetPlayerPos(playerid, sumoSpawnsType2[increment][0], sumoSpawnsType2[increment][1], sumoSpawnsType2[increment][2]+5);
	SetPlayerFacingAngle(playerid, sumoSpawnsType2[increment][3]);
	Event_PlayerVeh[playerid] = CreateVehicle(504, sumoSpawnsType2[increment][0], sumoSpawnsType2[increment][1], sumoSpawnsType2[increment][2], sumoSpawnsType2[increment][3], -1, -1, 15);

	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
	TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);
	increment++;
    return 1;

}


public sandking_PlayerJoinEvent(playerid)
{
    SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 505);

	SetPlayerPos(playerid, sumoSpawnsType3[increment][0], sumoSpawnsType3[increment][1], sumoSpawnsType3[increment][2]+5);
	SetPlayerFacingAngle(playerid, sumoSpawnsType3[increment][3]);
	Event_PlayerVeh[playerid] = CreateVehicle(495, sumoSpawnsType3[increment][0], sumoSpawnsType3[increment][1], sumoSpawnsType3[increment][2], sumoSpawnsType3[increment][3], -1, -1, 15);
	SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType3[increment][3]);

	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
	TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);
	increment++;
	return 1;
}


public sandkingR_PlayerJoinEvent(playerid)
{
    SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 505);

	SetPlayerPos(playerid, sumoSpawnsType5[increment][0], sumoSpawnsType5[increment][1], sumoSpawnsType5[increment][2]+5);
	SetPlayerFacingAngle(playerid, sumoSpawnsType5[increment][3]);
	Event_PlayerVeh[playerid] = CreateVehicle(495, sumoSpawnsType5[increment][0], sumoSpawnsType5[increment][1], sumoSpawnsType5[increment][2], sumoSpawnsType5[increment][3], -1, -1, 15);
	SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType5[increment][3]);

	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
	TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);
	increment++;
	return 1;
}


public derby_PlayerJoinEvent(playerid)
{
    SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 505);

	SetPlayerInterior(playerid, 15);
	SetPlayerPos(playerid, sumoSpawnsType4[increment][0], sumoSpawnsType4[increment][1], sumoSpawnsType4[increment][2]+5);
	SetPlayerFacingAngle(playerid, sumoSpawnsType4[increment][3]);
	Event_PlayerVeh[playerid] = CreateVehicle(504, sumoSpawnsType4[increment][0], sumoSpawnsType4[increment][1], sumoSpawnsType4[increment][2], sumoSpawnsType4[increment][3], -1, -1, 15);
	SetVehicleZAngle(Event_PlayerVeh[playerid], sumoSpawnsType4[increment][3]);
	LinkVehicleToInterior(Event_PlayerVeh[playerid], 15);

	SetVehicleVirtualWorld(Event_PlayerVeh[playerid], 505);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 99);
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~R~SUMO~n~~n~ ~w~You are now in the queue!", 4000, 3);
	TogglePlayerControllable(playerid, 0);
	SetCameraBehindPlayer(playerid);
	increment++;
	return 1;
}


public sumo_PlayerLeftEvent(playerid)
{
  	SetPVarInt(playerid, "LeftEventJust", 1);
	RemovePlayerFromVehicle(playerid);
	event_SpawnPlayer(playerid);

	if(EventPlayersCount() == 1)
	{
		new msg[128];
		foreach(Player, i)
	  	{
			if(GetPVarInt(i, "InEvent") == 1)
			{
				winner = i;
				break;
			}
		}
		format(msg, sizeof(msg), "				%s has won the Sumo event!", PlayerName(winner));
		SendClientMessageToAll(COLOR_NOTICE, msg);
		SendClientMessage(winner, COLOR_NOTICE, "You have won Sumo event! You have earnt 10 score!");
		FoCo_Player[winner][score] += 10;
		lastEventWon = winner;
		EndEvent();
		return 1;
	}
	
	return 1;
}



public sumo_OneSecond()
{
	SendClientMessageToAll(COLOR_NOTICE,"[EVENT]: Sumo is now in progress and can not be joined.");

	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{
			SetVehicleParamsEx(Event_PlayerVeh[i], true, false, false, true, false, false, false);
			TogglePlayerControllable(i, 1);
			GameTextForPlayer(i, "~R~Event Started!", 1000, 3);
			increment = 0;
		}
	}
	return 1;
}
	

/* Commands */

CMD:event(playerid, params[])
{
	if(IsAdmin(playerid, 1))
	{
		new
			result[50],
			string[64];

		if(sscanf(params, "s[50]", result))
		{
		    format(string, sizeof(string), "[USAGE]: {%06x}/event {%06x}[Start/End/Setbrawlpoint]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		    return SendClientMessage(playerid, COLOR_SYNTAX, string);
		}

		if(strcmp(result, "start", true) == 0)
		{
		    if(Event_InProgress == -1)
		    {
				ShowPlayerDialog(playerid, DIALOG_EVENTS, DIALOG_STYLE_LIST, "Events:", EVENTLIST, "Start", "Cancel");
			}

			else
			{
			    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is already another event in progress.");
			}
		}

		else if(strcmp(result, "end", true) == 0)
		{
		    if(Event_InProgress != -1)
		    {
				if(FoCo_Criminal != -1)
				{
					KillTimer(PursuitTimer);
				}
		    	EndEvent();
		    	format(string, sizeof(string), "[EVENT]: %s %s has stopped the event!", GetPlayerStatus(playerid), PlayerName(playerid));
				IRC_GroupSay(gLeads, IRC_FOCO_LEADS, string);
				SendClientMessageToAll(COLOR_NOTICE, string);
		    }

		    else
		    {
		        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There is no event to end.");
		    }
		}

		else if(strcmp(result, "Setbrawlpoint", true) == 0)
		{
			GetPlayerPos(playerid, BrawlX, BrawlY, BrawlZ);
			GetPlayerFacingAngle(playerid, BrawlA);
			BrawlInt = GetPlayerInterior(playerid);
			BrawlVW = GetPlayerVirtualWorld(playerid);

			SendClientMessage(playerid, COLOR_ADMIN, "[SUCCESS]: Brawlpoint set to your position.");
		}
	}

	return 1;
}

CMD:join(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerStatus") == 2)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are in a duel, leave it first.");
	}

	if(FoCo_Player[playerid][jailed] != 0)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Please wait until your admin jail is over.");
	}

	if(GetPlayerState(playerid) == PLAYER_STATE_WASTED || GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
		return 1;
	}

	if(GetPVarInt(playerid, "PlayerStatus") == 1)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are already at the event!");
 	}

	if(Event_InProgress == -1)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: No event has been started yet.");
	}

	if(Event_InProgress == 1)
	{
        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The event is already in progress");
	}

    if(Event_InProgress == 0)
	{
	    if(IsPlayerInAnyVehicle(playerid))
		{
			RemovePlayerFromVehicle(playerid);
		}
		
		SetPVarInt(playerid, "MotelSkin", GetPlayerSkin(playerid));
		SetPVarInt(playerid, "MotelColor", GetPlayerColor(playerid));
	    PlayerJoinEvent(playerid);
	}
	return 1;
}


stock GetVehicleDriver(vid)
{
     foreach(new i : Player)
     {
          if(!IsPlayerConnected(i)) continue;
          if(GetPlayerVehicleID(i) == vid && GetPlayerVehicleSeat(i) == 0) return 1;
          break;
     }
     return 0;
}


CMD:leaveevent(playerid, params[])
{
	if(GetPVarInt(playerid, "InEvent") == 1)
	{
	    new Float:health;
	    GetPlayerHealth(playerid, health);
	   		
		if(Event_InProgress == 0)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "You cannot leave the event before it starts.");
		}
		
		if(EventPlayersCount() <= 2)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "You cannot leave the event with less than 2 players in the event.");
		}
	    
	    if(health < 75)
	    {
			SendClientMessage(playerid, COLOR_WARNING, "You cannot leave the event with less than 75HP, use /kill (it will add a death)");
	    }

		else
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
				RemovePlayerFromVehicle(playerid);
			}
			
			if(GetPVarInt(playerid, "MotelTeamIssued") == 1)
			{
				SetPVarInt(playerid, "MotelTeamIssued", 0);
			}

			PlayerLeftEvent(playerid);
			event_SpawnPlayer(playerid);
		}
	}
	
	else
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are not at an event, therefore cannot leave.");
	}
	return 1;
}

stock SendEventPlayersMessage(str[], color)
{
	foreach(Player, i)
	{	
		if(GetPVarInt(i, "InEvent") == 1)
		{
			SendClientMessage(i, color, str);
		}
	}

	return 1;
}

stock EventPlayersCount()
{
	new cnt = 0;
	foreach(Player, i)
	{
		if(GetPVarInt(i, "InEvent") == 1)
		{	
			cnt++;
		}
	}

	return cnt;
}

/* Spawn Player Fix by Y_Less */

stock event_SpawnPlayer(playerid)
{
	new
		vid = GetPlayerVehicleID(playerid);
		
	if (vid)
	{
		new
			Float:x,
			Float:y,
			Float:z;
		// Remove them without the animation.
		GetVehiclePos(vid, x, y, z),
		SetPlayerPos(playerid, x, y, z);
	}
	
	return SpawnPlayer(playerid);
}

forward RespawnPlayer(playerid);
public RespawnPlayer(playerid)
{
	return event_SpawnPlayer(playerid);
}
