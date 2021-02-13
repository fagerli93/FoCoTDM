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
* Filename: chilco_ctf.pwn                                                       *
* Author: Chilco                                                                 *
*********************************************************************************/

#include <a_samp>
#include <sscanf2>
#include <zcmd>
#include <sscanf2>
#include <foreach>


#define DIALOG_CTF_CONFIG_POINTS 503 (Chilco | chilco_ctf.pwn)
#define DIALOG_CTF_CONFIG_MAP 504 (Chilco | chilco_ctf.pwn)
#define MAX_CTF_ROUNDS 5
#define PRESSED(%0) \
		(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) \
		(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Capture The Flag v1.0 by Chilco");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
	print("\n----------------------------------");
	print(" Capture The Flag v1.0 by Chilco");
	print("----------------------------------\n");
}

#endif

public OnGameModeInit()
{
	// Don't use these lines if it's a filterscript
	SetGameModeText("Script Development");
	AddPlayerClass(60, 2038.0824,1342.6145,10.6719, 269.1425, 0, 0, 0, 0, 0, 0);
	AddStaticVehicle(411,1958.3783, 1343.1572, 15.3746, 269.1425,65,1); //

	CreateObject(8664,-746.3176880,1909.5915530,-0.4299710,0.0000000,0.0000000,-89.9999813); //object(casrylegrnd_lvs) (1)
	CreateObject(8210,-779.8767700,1925.5892330,2.7217280,0.0000000,0.0000000,-89.9999813); //object(vgsselecfence12) (1)
	CreateObject(8210,-779.8723140,1891.5845950,2.7295250,0.0000000,0.0000000,-89.9999813); //object(vgsselecfence12) (2)
	CreateObject(987,-780.0909420,1904.7022710,2.6035010,0.0000000,0.0000000,-359.9999824); //object(elecfence_bar) (1)
	CreateObject(987,-768.3126220,1904.6041260,2.6035070,0.0000000,0.0000000,-629.9998689); //object(elecfence_bar) (2)
	CreateObject(987,-768.2256470,1916.3796390,2.5534990,0.0000000,0.0000000,-540.0000595); //object(elecfence_bar) (3)
	CreateObject(11427,-771.1715700,1910.2399900,9.8433170,0.0000000,0.0000000,-180.0000198); //object(des_adobech) (1)
	CreateObject(8838,-763.1913450,1943.0253910,1.0979000,0.0000000,0.0000000,0.0000000); //object(vgehshade01_lvs) (1)
	CreateObject(8838,-759.5510860,1943.0362550,1.1228980,0.0000000,0.0000000,0.0000000); //object(vgehshade01_lvs) (2)
	CreateObject(8838,-759.5435790,1940.5117190,1.1729000,0.0000000,0.0000000,-179.9999626); //object(vgehshade01_lvs) (3)
	CreateObject(8838,-777.8557740,1928.9367680,1.1478880,0.0000000,0.0000000,-89.9999813); //object(vgehshade01_lvs) (4)
	CreateObject(8838,-772.8377690,1928.9240720,1.1979000,0.0000000,0.0000000,-89.9999813); //object(vgehshade01_lvs) (5)
	CreateObject(8838,-767.7361450,1909.7740480,1.1479000,0.0000000,0.0000000,-89.9999813); //object(vgehshade01_lvs) (6)
	CreateObject(8838,-766.2209470,1909.7723390,1.1729000,0.0000000,0.0000000,-89.9999813); //object(vgehshade01_lvs) (7)
	CreateObject(8838,-756.1756590,1912.5604250,1.1979000,0.0000000,0.0000000,-179.9999626); //object(vgehshade01_lvs) (8)
	CreateObject(8838,-756.1153560,1908.3084720,1.1854010,0.0000000,0.0000000,-179.9999626); //object(vgehshade01_lvs) (9)
	CreateObject(8838,-772.7852780,1889.6571040,1.1229000,0.0000000,0.0000000,-450.0000210); //object(vgehshade01_lvs) (10)
	CreateObject(8838,-777.8928830,1889.6655270,1.1229000,0.0000000,0.0000000,-450.0000210); //object(vgehshade01_lvs) (11)
	CreateObject(8838,-759.5379640,1875.5161130,1.1729000,0.0000000,0.0000000,-179.9999626); //object(vgehshade01_lvs) (12)
	CreateObject(8838,-759.5495610,1877.8847660,1.1478960,0.0000000,0.0000000,-179.9999626); //object(vgehshade01_lvs) (13)
	CreateObject(14416,-768.1778560,1936.1766360,-0.5339360,0.0000000,0.0000000,0.0000000); //object(carter-stairs07) (1)
	CreateObject(14416,-768.2686770,1882.2856450,-0.5261390,0.0000000,0.0000000,179.9999626); //object(carter-stairs07) (2)
	CreateObject(8210,-736.3186040,1966.7893070,2.7295250,0.0000000,0.0000000,-359.9999251); //object(vgsselecfence12) (3)
	CreateObject(8210,-736.0083010,1851.8037110,2.7295250,0.0000000,0.0000000,-539.9998877); //object(vgsselecfence12) (4)
	CreateObject(14416,-741.0029300,1940.0826420,-0.5511410,0.0000000,0.0000000,89.9999813); //object(carter-stairs07) (3)
	CreateObject(14416,-741.0269780,1943.6430660,-0.5511390,0.0000000,0.0000000,89.9999813); //object(carter-stairs07) (4)
	CreateObject(14416,-737.6680300,1907.7563480,-0.5261390,0.0000000,0.0000000,89.9999813); //object(carter-stairs07) (5)
	CreateObject(14416,-737.6699830,1911.7446290,-0.5261390,0.0000000,0.0000000,89.9999813); //object(carter-stairs07) (6)
	CreateObject(14416,-737.6809690,1913.1571040,-0.5261410,0.0000000,0.0000000,89.9999813); //object(carter-stairs07) (7)
	CreateObject(14416,-741.0245360,1874.9798580,-0.5248910,0.0000000,0.0000000,89.9999813); //object(carter-stairs07) (8)
	CreateObject(987,-708.7901000,1966.3414310,1.1284980,0.0000000,0.0000000,-450.0000210); //object(elecfence_bar) (4)
	CreateObject(987,-708.7218630,1864.0667720,1.1534960,0.0000000,0.0000000,-450.0000210); //object(elecfence_bar) (5)
	CreateObject(8838,-734.8245240,1909.7631840,-0.3599010,0.0000000,0.0000000,-270.0000011); //object(vgehshade01_lvs) (14)
	CreateObject(3565,-739.6947020,1884.2858890,-0.1685660,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (1)
	CreateObject(3565,-739.6825560,1876.2166750,-0.1735650,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (2)
	CreateObject(3565,-739.6848140,1871.1586910,-0.1485620,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (3)
	CreateObject(8838,-730.0423580,1909.7763670,-0.3270740,0.0000000,0.0000000,-270.0000011); //object(vgehshade01_lvs) (15)
	CreateObject(3565,-737.1943360,1884.2755130,-0.1735620,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (4)
	CreateObject(3565,-737.0961300,1876.2144780,-0.1735660,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (5)
	CreateObject(3565,-737.1156620,1871.1633300,-0.1735660,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (6)
	CreateObject(14416,-738.6708370,1889.9830320,-2.0261390,0.0000000,0.0000000,-89.9999813); //object(carter-stairs07) (9)
	CreateObject(14416,-738.6916500,1893.9516600,-2.0261390,0.0000000,0.0000000,-89.9999813); //object(carter-stairs07) (10)
	CreateObject(3565,-742.2821660,1884.2857670,-0.1635620,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (7)
	CreateObject(3565,-743.1893920,1884.2934570,-0.1735660,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (8)
	CreateObject(14416,-741.0283810,1878.4794920,-0.5261390,0.0000000,0.0000000,89.9999813); //object(carter-stairs07) (11)
	CreateObject(8838,-734.2127080,1883.7684330,-0.3521020,0.0000000,0.0000000,-270.0000011); //object(vgehshade01_lvs) (16)
	CreateObject(3565,-739.7156370,1947.3828130,-0.1710620,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (9)
	CreateObject(3565,-739.6843870,1941.3819580,-0.1735620,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (10)
	CreateObject(3565,-739.6765140,1935.1652830,-0.1673120,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (11)
	CreateObject(3565,-737.1380620,1947.4125980,-0.1735620,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (12)
	CreateObject(3565,-737.1175540,1939.3558350,-0.1735620,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (13)
	CreateObject(3565,-737.1214600,1935.1761470,-0.1698120,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (14)
	CreateObject(14416,-738.6276250,1929.1228030,-2.0511390,0.0000000,0.0000000,-89.9999813); //object(carter-stairs07) (12)
	CreateObject(14416,-738.6247560,1925.1440430,-2.0511210,0.0000000,0.0000000,-89.9999813); //object(carter-stairs07) (13)
	CreateObject(3565,-742.2439580,1935.1671140,-0.1735620,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (15)
	CreateObject(3565,-743.7365110,1935.1864010,-0.1685660,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (16)
	CreateObject(3565,-741.6203000,1871.1494140,-0.1735620,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (17)
	CreateObject(14416,-744.7993770,1869.0346680,-2.0511390,0.0000000,0.0000000,-89.9999813); //object(carter-stairs07) (14)
	CreateObject(3565,-742.2516480,1947.4053960,-0.1735620,0.0000000,0.0000000,-89.9999813); //object(lasdkrt1_la01) (18)
	CreateObject(14416,-745.4271850,1949.4260250,-2.0261390,0.0000000,0.0000000,-89.9999813); //object(carter-stairs07) (15)
	CreateObject(1684,-743.8283690,1953.4532470,1.2183760,0.0000000,0.0000000,0.0000000); //object(portakabin) (1)
	CreateObject(1684,-733.8709720,1953.5037840,1.2183740,0.0000000,0.0000000,-180.0000198); //object(portakabin) (2)
	CreateObject(1684,-743.8064580,1953.4945070,4.1741320,0.0000000,0.0000000,-179.9999626); //object(portakabin) (3)
	CreateObject(1684,-733.8906250,1953.4703370,4.1741300,0.0000000,0.0000000,0.0000000); //object(portakabin) (4)
	CreateObject(1684,-733.8266600,1864.9993900,1.2183740,0.0000000,0.0000000,0.0000000); //object(portakabin) (5)
	CreateObject(1684,-743.7619020,1865.0067140,1.2183740,0.0000000,0.0000000,-179.9999626); //object(portakabin) (6)
	CreateObject(1684,-733.8013310,1865.0336910,4.1741300,0.0000000,0.0000000,-179.9999626); //object(portakabin) (7)
	CreateObject(1684,-743.7700810,1864.9677730,4.1741300,0.0000000,0.0000000,-359.9999824); //object(portakabin) (8)
	CreateObject(8838,-722.8450320,1859.7460940,-0.3708550,0.0000000,0.0000000,-359.9999824); //object(vgehshade01_lvs) (17)
	CreateObject(8838,-722.8522950,1854.6468510,-0.3521050,0.0000000,0.0000000,-359.9999824); //object(vgehshade01_lvs) (18)
	CreateObject(8838,-722.8715820,1860.4473880,-0.3521120,0.0000000,0.0000000,-359.9999824); //object(vgehshade01_lvs) (19)
	CreateObject(8838,-722.8727420,1958.0493160,-0.3271060,0.0000000,0.0000000,-359.9999824); //object(vgehshade01_lvs) (20)
	CreateObject(8838,-722.8808590,1963.0834960,-0.3521020,0.0000000,0.0000000,-359.9999824); //object(vgehshade01_lvs) (21)
	CreateObject(8838,-722.9008180,1963.9410400,-0.3271080,0.0000000,0.0000000,-359.9999824); //object(vgehshade01_lvs) (22)
	CreateObject(14416,-741.4766240,1957.4547120,-2.0261370,0.0000000,0.0000000,-89.9999813); //object(carter-stairs07) (16)
	CreateObject(14416,-741.4818120,1961.0815430,-2.0261390,0.0000000,0.0000000,-89.9999813); //object(carter-stairs07) (17)
	CreateObject(14416,-741.4707640,1964.8212890,-2.0261390,0.0000000,0.0000000,-89.9999813); //object(carter-stairs07) (18)
	CreateObject(14416,-741.4437260,1860.9291990,-2.0339340,0.0000000,0.0000000,-89.9999813); //object(carter-stairs07) (19)
	CreateObject(14416,-741.4658810,1857.7239990,-2.0339340,0.0000000,0.0000000,-89.9999813); //object(carter-stairs07) (20)
	CreateObject(14416,-741.4810790,1854.0275880,-2.0339340,0.0000000,0.0000000,-89.9999813); //object(carter-stairs07) (21)
	CreateObject(3578,-744.7526250,1906.4149170,3.0315300,0.0000000,0.0000000,-179.9999626); //object(dockbarr1_la) (1)
	CreateObject(3578,-744.6259770,1914.4654540,3.0315300,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (2)
	CreateObject(3578,-755.0333250,1906.4299320,3.0315300,0.0000000,0.0000000,-179.9999626); //object(dockbarr1_la) (3)
	CreateObject(3578,-758.5214840,1906.4287110,3.0315300,0.0000000,0.0000000,-179.9999626); //object(dockbarr1_la) (4)
	CreateObject(3578,-754.9234010,1914.4736330,3.0315300,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (5)
	CreateObject(3578,-758.5156860,1914.4639890,3.0315300,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (6)
	CreateObject(3578,-748.0435790,1879.8295900,2.9815300,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (7)
	CreateObject(3578,-758.3290410,1879.8439940,2.9815260,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (8)
	CreateObject(3578,-761.0026860,1879.8416750,2.9815260,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (9)
	CreateObject(3578,-748.0260620,1873.6109620,2.9565300,0.0000000,0.0000000,-180.0000198); //object(dockbarr1_la) (10)
	CreateObject(3578,-758.2943120,1873.6224370,2.9565300,0.0000000,0.0000000,-179.9999626); //object(dockbarr1_la) (11)
	CreateObject(3578,-765.3212890,1873.6260990,2.9815300,0.0000000,0.0000000,-179.9999626); //object(dockbarr1_la) (12)
	CreateObject(3578,-748.0122070,1938.6586910,3.0315300,0.0000000,0.0000000,-179.9999626); //object(dockbarr1_la) (13)
	CreateObject(3578,-758.2687380,1938.6824950,3.0315300,0.0000000,0.0000000,-180.0000198); //object(dockbarr1_la) (14)
	CreateObject(3578,-760.8010250,1938.6822510,3.0315300,0.0000000,0.0000000,-180.0000198); //object(dockbarr1_la) (15)
	CreateObject(3578,-761.0679320,1944.9354250,3.0315300,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (16)
	CreateObject(3578,-750.8281860,1944.9155270,3.0315300,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (17)
	CreateObject(3578,-748.0258180,1944.8945310,3.0315280,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (18)
	CreateObject(3578,-771.0800170,1932.8458250,3.0315300,0.0000000,0.0000000,-89.9999813); //object(dockbarr1_la) (19)
	CreateObject(3578,-764.4119870,1920.2871090,3.0315300,0.0000000,0.0000000,-89.9999813); //object(dockbarr1_la) (20)
	CreateObject(3578,-764.4162600,1900.2164310,3.0315300,0.0000000,0.0000000,-89.9999813); //object(dockbarr1_la) (21)
	CreateObject(3578,-771.0171510,1885.5981450,3.0065300,0.0000000,0.0000000,-89.9999813); //object(dockbarr1_la) (22)
	CreateObject(3578,-771.3385010,1944.9448240,3.0315300,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (23)
	CreateObject(3578,-775.1373290,1944.9530030,3.0315300,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (24)
	CreateObject(3578,-775.3192750,1873.6430660,2.9815300,0.0000000,0.0000000,-179.9999626); //object(dockbarr1_la) (25)
	CreateObject(944,-768.5471800,1941.4919430,3.5632850,0.0000000,0.0000000,89.9999813); //object(packing_carates04) (1)
	CreateObject(944,-765.1766970,1910.5010990,3.5632850,0.0000000,0.0000000,89.9999813); //object(packing_carates04) (2)
	CreateObject(944,-768.5889280,1877.1148680,3.5632850,0.0000000,0.0000000,89.9999813); //object(packing_carates04) (3)
	CreateObject(1685,-742.4594730,1910.5187990,3.4284980,0.0000000,0.0000000,0.0000000); //object(blockpallet) (1)
	CreateObject(1685,-746.9092410,1942.3750000,3.4284980,0.0000000,0.0000000,0.0000000); //object(blockpallet) (2)
	CreateObject(1685,-749.1402590,1876.9667970,3.4284980,0.0000000,0.0000000,22.4999953); //object(blockpallet) (3)
	CreateObject(1685,-739.6683960,1893.9555660,1.9206970,0.0000000,0.0000000,0.0000000); //object(blockpallet) (4)
	CreateObject(8838,-739.1740720,1909.7619630,-0.3350000,0.0000000,0.0000000,-270.0000011); //object(vgehshade01_lvs) (23)
	CreateObject(2567,-747.7348020,1899.2188720,1.5600360,0.0000000,0.0000000,11.2500263); //object(ab_warehouseshelf) (1)
	CreateObject(3798,-757.4155270,1897.8881840,-0.3710220,0.0000000,0.0000000,11.2500263); //object(acbox3_sfs) (1)
	CreateObject(3799,-746.1671140,1921.9864500,-0.4857620,0.0000000,0.0000000,22.4999953); //object(acbox2_sfs) (1)
	CreateObject(3798,-748.8173828,1928.7099609,-0.3710240,0.0000000,0.0000000,11.2500000); //object(acbox3_sfs) (2)
	CreateObject(934,-756.8377690,1934.3546140,0.9607130,0.0000000,0.0000000,-89.9999813); //object(generator_big) (1)
	CreateObject(923,-752.6710820,1906.9492190,0.5121210,0.0000000,0.0000000,0.0000000); //object(packing_carates2) (1)
	CreateObject(922,-754.4904790,1924.4716800,0.5101790,0.0000000,0.0000000,-89.9999813); //object(packing_carates1) (1)
	CreateObject(3631,-760.9280400,1885.0626220,0.2107310,0.0000000,0.0000000,-89.9999813); //object(oilcrat_las) (1)
	CreateObject(14416,-745.4309690,1947.1433110,-2.0297860,0.0000000,0.0000000,-89.9999813); //object(carter-stairs07) (22)
	CreateObject(14416,-744.7996220,1870.7377930,-2.0587780,0.0000000,0.0000000,-89.9999813); //object(carter-stairs07) (23)
	CreateObject(973,-741.4202880,1921.8079830,0.4726540,0.0000000,0.0000000,-270.0000011); //object(sub_roadbarrier) (1)
	CreateObject(973,-741.4150390,1912.4287110,0.4726540,0.0000000,0.0000000,-270.0000011); //object(sub_roadbarrier) (2)
	CreateObject(973,-741.4271850,1903.0850830,0.4726540,0.0000000,0.0000000,-270.0000011); //object(sub_roadbarrier) (3)
	CreateObject(973,-741.4323120,1897.7160640,0.4726540,0.0000000,0.0000000,-270.0000011); //object(sub_roadbarrier) (4)
	CreateObject(973,-736.9418950,1893.2551270,0.4726540,0.0000000,0.0000000,-179.9999626); //object(sub_roadbarrier) (5)
	CreateObject(973,-736.9531250,1926.2994380,0.4726540,0.0000000,0.0000000,-359.9999251); //object(sub_roadbarrier) (6)
	CreateObject(1684,-765.8070070,1921.4514160,1.0973100,0.0000000,0.0000000,-89.9999813); //object(portakabin) (9)
	CreateObject(1684,-765.8246460,1911.5118410,1.0895140,0.0000000,0.0000000,-89.9999813); //object(portakabin) (10)
	CreateObject(1684,-765.8149410,1901.5604250,1.0973100,0.0000000,0.0000000,-89.9999813); //object(portakabin) (11)
	CreateObject(1684,-768.7096560,1895.1517330,1.0962120,0.0000000,0.0000000,-180.0000198); //object(portakabin) (12)
	CreateObject(1684,-772.4055180,1888.0097660,1.0973100,0.0000000,0.0000000,-89.9999813); //object(portakabin) (13)
	CreateObject(1684,-772.3892820,1878.0694580,1.0973100,0.0000000,0.0000000,-89.9999813); //object(portakabin) (14)
	CreateObject(1684,-772.7894290,1924.3774410,1.0973100,0.0000000,0.0000000,0.0000000); //object(portakabin) (15)
	CreateObject(1684,-772.4515380,1931.4156490,1.0973100,0.0000000,0.0000000,-89.9999813); //object(portakabin) (16)
	CreateObject(1684,-772.4416500,1941.3658450,1.0973100,0.0000000,0.0000000,-89.9999813); //object(portakabin) (17)
	CreateObject(3578,-771.0041500,1887.9879150,3.0065300,0.0000000,0.0000000,-89.9999813); //object(dockbarr1_la) (26)
	CreateObject(3578,-771.0731200,1931.5742190,3.0315300,0.0000000,0.0000000,-89.9999813); //object(dockbarr1_la) (27)
	CreateObject(3631,-761.0770260,1951.3063960,0.2107310,0.0000000,0.0000000,-78.7500123); //object(oilcrat_las) (2)
	CreateObject(1439,-764.0950320,1905.8347170,2.7942030,0.0000000,0.0000000,56.2500169); //object(dyn_dumpster_1) (1)
	CreateObject(1439,-764.1525880,1914.5444340,2.7942030,0.0000000,0.0000000,134.9999719); //object(dyn_dumpster_1) (2)
	CreateObject(3631,-767.6994020,1894.0668950,3.2567950,0.0000000,0.0000000,0.0000000); //object(oilcrat_las) (3)
	CreateObject(3631,-767.6666260,1925.4560550,3.2567950,0.0000000,0.0000000,0.0000000); //object(oilcrat_las) (4)
	CreateObject(738,-729.0438840,1916.9580080,1.6042020,0.0000000,0.0000000,0.0000000); //object(aw_streettree2) (1)
	CreateObject(738,-729.0295410,1903.0100100,1.6042020,0.0000000,0.0000000,0.0000000); //object(aw_streettree2) (2)
	CreateObject(936,-728.5451660,1911.9899900,1.6532360,0.0000000,0.0000000,0.0000000); //object(cj_df_worktop_2) (1)
	CreateObject(936,-728.5535280,1908.5976560,1.6532360,0.0000000,0.0000000,0.0000000); //object(cj_df_worktop_2) (2)
	CreateObject(936,-730.0493160,1911.8720700,1.6532360,0.0000000,0.0000000,89.9999813); //object(cj_df_worktop_2) (3)
	CreateObject(936,-730.0294800,1908.6701660,1.6532360,0.0000000,0.0000000,89.9999813); //object(cj_df_worktop_2) (4)
	CreateObject(3594,-754.3291020,1886.4288330,0.2636110,0.0000000,0.0000000,-78.7500123); //object(la_fuckcar1) (1)
	CreateObject(944,-776.8007810,1894.3668210,3.5632850,0.0000000,0.0000000,180.0000198); //object(packing_carates04) (4)
	CreateObject(944,-779.6209110,1894.3560790,3.5419640,0.0000000,0.0000000,180.0000198); //object(packing_carates04) (5)
	CreateObject(944,-776.8214720,1925.7574460,3.5591620,0.0000000,0.0000000,180.0000198); //object(packing_carates04) (6)
	CreateObject(944,-779.1475830,1925.7449950,3.5632720,0.0000000,0.0000000,180.0000198); //object(packing_carates04) (7)
	CreateObject(944,-772.9235230,1933.5411380,3.5632850,0.0000000,0.0000000,179.9999626); //object(packing_carates04) (8)
	CreateObject(944,-772.8787840,1885.3801270,3.5632850,0.0000000,0.0000000,179.9999626); //object(packing_carates04) (9)
	CreateObject(3798,-773.9778442,1878.8846436,2.6210437,0.0000000,0.0000000,0.0000000); //object(acbox3_sfs) (3)
	CreateObject(944,-738.4439700,1937.2164310,2.0606090,0.0000000,0.0000000,180.0000198); //object(packing_carates04) (10)
	CreateObject(944,-733.1800540,1945.5576170,2.0632840,0.0000000,0.0000000,180.0000198); //object(packing_carates04) (11)
	CreateObject(1685,-740.2116700,1925.5505370,1.9206950,0.0000000,0.0000000,0.0000000); //object(blockpallet) (5)
	CreateObject(944,-742.9674070,1936.4346920,2.0606090,0.0000000,0.0000000,270.0000011); //object(packing_carates04) (12)
	CreateObject(1439,-744.6335450,1931.8547360,1.2915230,0.0000000,0.0000000,89.9999813); //object(dyn_dumpster_1) (3)
	CreateObject(936,-737.6581420,1931.6835940,1.6505350,0.0000000,0.0000000,180.0000198); //object(cj_df_worktop_2) (5)
	CreateObject(1685,-743.6271970,1887.4396970,1.9008220,0.0000000,0.0000000,0.0000000); //object(blockpallet) (6)
	CreateObject(1685,-738.1287840,1887.4075930,1.9258220,0.0000000,0.0000000,0.0000000); //object(blockpallet) (7)
	CreateObject(936,-742.0214230,1881.5881350,1.6350650,0.0000000,0.0000000,89.9999813); //object(cj_df_worktop_2) (6)
	CreateObject(8838,-734.2360230,1934.6507570,-0.3849090,0.0000000,0.0000000,-270.0000011); //object(vgehshade01_lvs) (24)
	CreateObject(2094,-737.1591800,1923.2725830,1.1694760,0.0000000,0.0000000,-22.4999953); //object(swank_cabinet_4) (1)
	CreateObject(1762,-734.8078610,1923.8469240,1.1785300,0.0000000,0.0000000,33.7500216); //object(swank_single_2) (1)
	CreateObject(1765,-735.7592160,1899.3947750,1.1764760,0.0000000,0.0000000,-146.2499982); //object(low_single_2) (1)
	CreateObject(936,-734.6101680,1899.0194090,1.6532080,0.0000000,0.0000000,-213.7499842); //object(cj_df_worktop_2) (7)
	CreateObject(2530,-740.3648680,1905.0147710,1.1549770,0.0000000,0.0000000,0.0000000); //object(cj_off2_lic_2_r) (1)
	CreateObject(1348,-738.0972290,1905.1076660,1.8732220,0.0000000,0.0000000,0.0000000); //object(cj_o2tanks) (1)
	CreateObject(1431,-739.4205320,1915.4146730,1.7183090,0.0000000,0.0000000,0.0000000); //object(dyn_box_pile) (1)
	CreateObject(936,-746.0453490,1913.1827390,3.1532110,0.0000000,0.0000000,-270.0000011); //object(cj_df_worktop_2) (8)
	CreateObject(944,-754.6683350,1908.3145750,3.5632850,0.0000000,0.0000000,270.0000011); //object(packing_carates04) (13)
	CreateObject(3798,-765.2408450,1932.9630130,-0.4553030,0.0000000,0.0000000,0.0000000); //object(acbox3_sfs) (4)
	CreateObject(3798,-765.2737430,1885.6027830,-0.4038440,0.0000000,0.0000000,0.0000000); //object(acbox3_sfs) (5)
	CreateObject(7606,-765.7857060,1877.8436280,-2.8580130,0.0000000,0.0000000,0.0000000); //object(vegasbigsign1) (1)
	CreateObject(7606,-765.7658080,1940.7192380,-2.9077930,0.0000000,0.0000000,0.0000000); //object(vegasbigsign1) (2)
	CreateObject(3287,-743.5292360,1943.3171390,1.1675430,0.0000000,0.0000000,0.0000000); //object(cxrf_oiltank) (1)
	CreateObject(3287,-739.8445430,1913.1883540,1.1538440,0.0000000,0.0000000,0.0000000); //object(cxrf_oiltank) (2)
	CreateObject(3287,-739.8683470,1910.8132320,1.1346450,0.0000000,0.0000000,0.0000000); //object(cxrf_oiltank) (3)
	CreateObject(3287,-743.1691890,1878.2219240,1.1526120,0.0000000,0.0000000,0.0000000); //object(cxrf_oiltank) (4)
	CreateObject(12814,-780.3310547,1897.8505859,21.5579224,0.0000000,269.7583008,0.0000000); //object(cuntyeland04) (1)
	CreateObject(12814,-780.3064580,1929.8497310,21.4731200,0.0000000,-90.2408527,-359.9999824); //object(cuntyeland04) (2)
	CreateObject(5706,-776.6604000,1856.5009770,2.0943090,0.0000000,0.0000000,-89.9999813); //object(studiobld03_law) (1)
	CreateObject(5706,-776.6560670,1856.5096440,8.4315770,0.0000000,0.0000000,-89.9999813); //object(studiobld03_law) (2)
	CreateObject(5706,-777.1174320,1961.9705810,2.1700170,0.0000000,0.0000000,-89.9999813); //object(studiobld03_law) (3)
	CreateObject(5706,-777.1116940,1961.9677730,8.5073010,0.0000000,0.0000000,-89.9999813); //object(studiobld03_law) (4)
	CreateObject(5706,-715.1331790,1876.1488040,3.6395740,0.0000000,0.0000000,-180.0000198); //object(studiobld03_law) (5)
	CreateObject(5706,-715.2482910,1942.3740230,3.6702840,0.0000000,0.0000000,-359.9999824); //object(studiobld03_law) (6)
	CreateObject(5835,-710.0613400,1909.2674560,7.8885410,0.0000000,0.0000000,-269.9999438); //object(ci_astage) (1)
	CreateObject(1684,-736.8109130,1953.4686280,7.0411420,0.0000000,0.0000000,0.0000000); //object(portakabin) (18)
	CreateObject(1684,-736.7062990,1865.0023190,7.0398910,0.0000000,0.0000000,0.0000000); //object(portakabin) (19)
	CreateObject(987,-768.2997440,1904.5999760,6.6163820,0.0000000,0.0000000,-629.9998689); //object(elecfence_bar) (6)
	CreateObject(987,-780.0841060,1904.6582030,6.6196480,0.0000000,0.0000000,-719.9996783); //object(elecfence_bar) (7)
	CreateObject(987,-768.2530520,1916.3742680,6.6034970,0.0000000,0.0000000,-540.0000595); //object(elecfence_bar) (8)
	CreateObject(8168,-729.2559810,1889.5710450,3.0264690,0.0000000,0.0000000,-253.5160627); //object(vgs_guardhouse01) (1)
	CreateObject(8168,-729.2257690,1889.5635990,6.7306930,0.0000000,0.0000000,-253.5160054); //object(vgs_guardhouse01) (2)
	CreateObject(8168,-729.2474980,1929.9660640,2.9686620,0.0000000,0.0000000,-253.5160054); //object(vgs_guardhouse01) (3)
	CreateObject(8168,-729.2337040,1929.9748540,6.5728850,0.0000000,0.0000000,-253.5160054); //object(vgs_guardhouse01) (4)
	CreateObject(974,-778.7287600,1926.4338380,6.9021090,0.0000000,0.0000000,0.0000000); //object(tall_fence) (1)
	CreateObject(974,-778.7257080,1893.6618650,6.8271210,0.0000000,0.0000000,0.0000000); //object(tall_fence) (2)
	CreateObject(974,-742.6346440,1937.9105220,0.4234310,0.0000000,-90.2408527,0.0000000); //object(tall_fence) (3)
	CreateObject(974,-742.6499630,1945.6193850,0.4035630,0.0000000,-90.2408527,0.0000000); //object(tall_fence) (4)
	CreateObject(974,-742.6683960,1872.7696530,0.3535590,0.0000000,-90.2408527,-180.0000198); //object(tall_fence) (5)
	CreateObject(974,-742.6603390,1880.4849850,0.3535620,0.0000000,-90.2408527,-180.0000198); //object(tall_fence) (6)
	CreateObject(974,-739.4262700,1905.7182620,0.3983390,0.0000000,-90.2408527,-180.0000198); //object(tall_fence) (7)
	CreateObject(974,-739.4050900,1915.1351320,0.3885240,0.0000000,-90.2408527,-180.0000198); //object(tall_fence) (8)
	CreateObject(974,-768.1455690,1926.4730220,6.5640320,0.0000000,0.0000000,0.0000000); //object(tall_fence) (9)
	CreateObject(974,-764.1644900,1923.1809080,6.5640320,0.0000000,0.0000000,-89.9999813); //object(tall_fence) (10)
	CreateObject(974,-767.5095830,1926.4702150,6.5640320,0.0000000,0.0000000,0.0000000); //object(tall_fence) (11)
	CreateObject(974,-768.1489870,1893.0758060,6.5390320,0.0000000,0.0000000,0.0000000); //object(tall_fence) (12)
	CreateObject(974,-767.5125730,1893.0560300,6.5390320,0.0000000,0.0000000,0.0000000); //object(tall_fence) (13)
	CreateObject(974,-764.2064210,1896.3232420,6.5390320,0.0000000,0.0000000,-89.9999813); //object(tall_fence) (14)
	CreateObject(7073,-763.8919070,1871.8599850,30.5188100,0.0000000,0.0000000,44.9999906); //object(vegascowboy1) (1)
	CreateObject(7392,-768.9899290,1950.2655030,20.4478570,0.0000000,0.0000000,-44.9999906); //object(vegcandysign1) (1)
	CreateObject(1684,-743.7757570,1864.9653320,7.0548860,0.0000000,0.0000000,0.0000000); //object(portakabin) (20)
	CreateObject(1684,-743.8312380,1953.4633790,7.0548880,0.0000000,0.0000000,0.0000000); //object(portakabin) (21)
	CreateObject(13646,-713.2288208,1960.9259033,0.6694696,0.0000000,0.0000000,0.0000000); //object(ramplandpad) (1)
	CreateObject(13646,-712.6005249,1857.7008057,0.6694696,0.0000000,0.0000000,0.0000000); //object(ramplandpad) (2)
	CreateObject(3798,-751.4284668,1933.9533691,-0.3710240,0.0000000,0.0000000,53.2500000); //object(acbox3_sfs) (2)
	CreateObject(3798,-761.1990967,1929.5866699,-0.3710240,0.0000000,0.0000000,53.2452393); //object(acbox3_sfs) (2)
	CreateObject(3798,-758.4395142,1915.9779053,-0.3710240,0.0000000,0.0000000,53.2452393); //object(acbox3_sfs) (2)
	CreateObject(3798,-750.6016235,1916.4127197,-0.3710240,0.0000000,0.0000000,53.2452393); //object(acbox3_sfs) (2)
	CreateObject(3798,-747.1193237,1892.0687256,-0.3710240,0.0000000,0.0000000,53.2452393); //object(acbox3_sfs) (2)
	CreateObject(3798,-758.9218140,1891.7639160,-0.3710240,0.0000000,0.0000000,53.2452393); //object(acbox3_sfs) (2)

	/*
	Objects converted: 230
	Vehicles converted: 0
	Vehicle models found: 0
	----------------------
	convertFFS converted your input in 0.07 seconds - Chuck Norris could have done it in 0.0011 seconds!
	*/

	

	return 1;
}

forward CTFStart();
forward CTFScore(); // Also used for updating flag locations.
forward StopEvent();
new Text:Textdraw0;
new Text:Textdraw1;
new Text:Textdraw2;
new Event_InProgress;
new Event_started;
new Event_pointsamount;
new Event_SWATcount;
new Event_TERRORISTScount;
new Event_StartTimer;
new EventTeam[MAX_PLAYERS];
new Event_Map;
new CTF_Terroristsflag;
new CTF_Swatflag;
new CTF_Terroristsflagramp;
new CTF_Swatflagramp;
new CTF_Swatflag_atbase;
new CTF_Terroristsflag_atbase;
new CTF_Swatflag_Dropped;
new CTF_Terroristflag_Dropped;
new Event_SWAT_Points;
new Event_TERRORISTS_Points;
new Event_UpdateScoreTimer; // Also used for updating flag locations.
new Event_Swatflag_holder;
new Event_Terroristsflag_holder;
new Float:Event_SwatFlagX, Float:Event_SwatFlagY, Float:Event_SwatFlagZ;
new Float:Event_TerrorFlagX, Float:Event_TerrorFlagY, Float:Event_TerrorFlagZ;

new Float:Event_TerrorFlagDropOffX, Float:Event_TerrorFlagDropOffY, Float:Event_TerrorFlagDropOffZ;
new Float:Event_SwatFlagDropOffX, Float:Event_SwatFlagDropOffY, Float:Event_SwatFlagDropOffZ;
new lastweapons[MAX_PLAYERS][13][2];

new Float:TERRORISTS_SPAWN_Coords[][] =
{
    {-723.2717,1960.9885,2.1785}, // map id 0
	{-974.2782,1076.4524,1344.9893},
	{-1363.7135,1623.7998,1052.5313},
	{-953.2432,1867.6848,5.0000},
	{2487.5901,1850.5339,10.8203},
	{2424.6042,2779.3533,10.8203}

};

new Float:SWAT_SPAWN_Coords[][] =
{
    {-725.8029,1857.6003,2.1597}, // map id 0
    {-1131.0841,1042.4982,1345.7347},
    {-1486.8691,1583.8853,1052.5313},
    {-950.5016,1932.7545,5.0000},
    {2402.6919,1954.4036,6.0156},
    {2259.5957,2771.6082,10.8203}

};

new Float:algorithmxy[][] = { {0.0, 0.0}, {0.0, 2.0},{0.0, -2.0},{2.0, 0.0},{2.0, 2.0},{2.0, -2.0},{-2.0, 0.0},{-2.0, 2.0},{-2.0, -2.0},{4.0, 0.0},{4.0, -2.0},{4.0, 2.0},{-4.0, 0.0},{-4.0, -2.0},{-4.0, 2.0},{6.0, 0.0} };


new Float:TerrorflagXYZ[][] = // The drop off spot / default pos of the flag (( The Z-axis should be -1.0  else it floats))
{
    {-713.2154,1960.8621,1.3687}, // map id 0
	{-974.3445,1022.1892,1344.0454}, // id 1
	{-1352.6869,1639.2217,1051.5313}, // 2
	{-938.5987,1848.6022,4.0000},
	{2490.4077,1837.7935,9.8203},
	{2422.4419,2768.8987,9.8203}
};

new Float:SwatflagXYZ[][] = // The drop off spot / default pos of the flag (( The Z-axis should be -1.0 else it floats))
{
    {-712.5533, 1857.7362, 1.3687}, // map id 0
	{-1132.3231,1097.0183,1344.7986}, // id 1
	{-1484.7438,1569.1740,1051.5313}, // 2
	{-938.6971,1951.9521,4.0000},
	{2395.3215,1954.2437,5.0156},
	{2261.3374,2767.3909,9.8203}

};

new CTF_Maps[][] =
{
    {"Canals"},
    {"RC Battleground"},
    {"Kickstart Stadium"},
    {"Sherman Dam"},
    {"FinalBuild Construction"},
    {"Spinybed Warehouses"}

};

new CTF_Maps_Info[][] = // Interior, Angle SWAT, Angle Terrorists
{
    {0, 90, 90},
    {10, 0, 180},
    {14, 270, 90},
    {17,270,270},
    {0, 90,90},
    {0, 90,90}

};

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_NO))
	{
		if(EventTeam[playerid] > 0)
		{
		    new pName[MAX_PLAYER_NAME], msgstring[100];
		    GetPlayerName(playerid, pName,sizeof(pName));
		    if(Event_Swatflag_holder == playerid)
		    {
		        if(IsPlayerInRangeOfPoint(playerid, 2.0, Event_TerrorFlagDropOffX,Event_TerrorFlagDropOffY,Event_TerrorFlagDropOffZ))
				{
				    if(Event_TerrorFlagX == TerrorflagXYZ[Event_Map][0] && Event_TerrorFlagY == TerrorflagXYZ[Event_Map][1])
				    {
						format(msgstring,sizeof(msgstring), "%s succesfully dropped the SWAT flag off at their base! (+1 point for Terrorists)", pName);
			    		SendEventMessage(msgstring);
			    		RemovePlayerAttachedObject(playerid, 9);
			    		CTF_Swatflag = CreateObject(2914,SwatflagXYZ[Event_Map][0],SwatflagXYZ[Event_Map][1],SwatflagXYZ[Event_Map][2],0.0000000,0.0000000,-89.9999813);
					    Event_TERRORISTS_Points ++;
					    Event_Swatflag_holder = -1;
					    CTF_Swatflag_atbase = 1;
					    PlayEventSound(1137);
	                    for (new i = 0; i < 13; i++)
						{
						    GivePlayerWeapon(playerid, lastweapons[playerid][i][0], lastweapons[playerid][i][1]);
						}
						if(Event_TERRORISTS_Points == Event_pointsamount)
						{
						    SendClientMessageToAll(0xcde9e9FF, "[EVENT] Terrorists have won the Capture The Flag event!");
						    StopEvent();
						}
						return 1;
					}
					else return SendClientMessage(playerid, 0xcde9e9FF, "[EVENT] You can't drop the flag off because the flag of your team is missing!");
				}
		    }

		    if(Event_Terroristsflag_holder == playerid)
		    {
		        if(IsPlayerInRangeOfPoint(playerid, 2.0, Event_SwatFlagDropOffX,Event_SwatFlagDropOffY,Event_SwatFlagDropOffZ))
				{
        			if(Event_SwatFlagX == SwatflagXYZ[Event_Map][0] && Event_SwatFlagY == SwatflagXYZ[Event_Map][1])
				    {
						format(msgstring,sizeof(msgstring), "%s succesfully dropped the Terrorists flag off at their base! (+1 point for SWAT)", pName);
			    		SendEventMessage(msgstring);
			    		RemovePlayerAttachedObject(playerid, 9);
	           			CTF_Terroristsflag = CreateObject(2993,TerrorflagXYZ[Event_Map][0],TerrorflagXYZ[Event_Map][1],TerrorflagXYZ[Event_Map][2],0.0000000,0.0000000,-89.9999813);
					    Event_SWAT_Points ++;
					    Event_Terroristsflag_holder = -1;
					    CTF_Terroristsflag_atbase = 1;
					    PlayEventSound(1137);
					    for (new i = 0; i < 13; i++)
						{
						    GivePlayerWeapon(playerid, lastweapons[playerid][i][0], lastweapons[playerid][i][1]);
						}
						if(Event_SWAT_Points == Event_pointsamount)
						{
	                        SendClientMessageToAll(0xcde9e9FF, "[EVENT] SWAT has won the Capture The Flag event!");
						    StopEvent();
						}
						return 1;
					}
					else return SendClientMessage(playerid, 0xcde9e9FF, "[EVENT] You can't drop the flag off because the flag of your team is missing!");
				}
		    }
			if(EventTeam[playerid] == 1) // Team is SWAT
			{
			    if(IsPlayerInRangeOfPoint(playerid, 2.0, Event_SwatFlagX,Event_SwatFlagY,Event_SwatFlagZ))
				{
				    if(Event_SwatFlagX != SwatflagXYZ[Event_Map][0] && Event_SwatFlagY != SwatflagXYZ[Event_Map][1])
				    {
				        CTF_Swatflag_Dropped = 0;
				        format(msgstring,sizeof(msgstring), "%s picked up the SWAT flag and returned it to their base.", pName);
		    			SendEventMessage(msgstring);
		    			DestroyObject(CTF_Swatflag);
		    			PlayEventSound(1138);
         				CTF_Swatflag = CreateObject(2914,SwatflagXYZ[Event_Map][0],SwatflagXYZ[Event_Map][1],SwatflagXYZ[Event_Map][2],0.0000000,0.0000000,-89.9999813);

					    CTF_Swatflag_atbase = 1;
					    return 1;

				    }

				}

				if(IsPlayerInRangeOfPoint(playerid, 2.0, Event_TerrorFlagX,Event_TerrorFlagY,Event_TerrorFlagZ))
				{
				    CTF_Terroristflag_Dropped = 0;
				    SetPlayerAttachedObject(playerid, 9, 2993, 6, 0.108999, 0.019000, -0.022999, -0.600012, 4.400000, 83.699996, 1, 1, 1, 0xFF00FF00);
				    Event_Terroristsflag_holder = playerid;
				    DestroyObject(CTF_Terroristsflag);
				    PlayEventSound(1138);
					format(msgstring,sizeof(msgstring), "%s picked up the Terrorists flag!", pName);
		    		SendEventMessage(msgstring);

					for (new i = 0; i < 13; i++)
					{
					    GetPlayerWeaponData(playerid, i, lastweapons[playerid][i][0], lastweapons[playerid][i][1]);
					}
					ResetPlayerWeapons(playerid);
				    CTF_Terroristsflag_atbase = 0;
				    return 1;

				}
			}
			else if(EventTeam[playerid] == 2)
			{
			    if(IsPlayerInRangeOfPoint(playerid, 2.0, Event_TerrorFlagX,Event_TerrorFlagY,Event_TerrorFlagZ))
				{
				    if(Event_TerrorFlagX != TerrorflagXYZ[Event_Map][0] && Event_TerrorFlagY != TerrorflagXYZ[Event_Map][1])
				    {
				        CTF_Terroristflag_Dropped = 0;
				        format(msgstring,sizeof(msgstring), "%s picked up the Terrorists flag and returned it to their base.", pName);
		    			SendEventMessage(msgstring);
		    			DestroyObject(CTF_Terroristsflag);
		    			PlayEventSound(1138);
         				CTF_Terroristsflag = CreateObject(2993,TerrorflagXYZ[Event_Map][0],TerrorflagXYZ[Event_Map][1],TerrorflagXYZ[Event_Map][2],0.0000000,0.0000000,-89.9999813);
					    CTF_Terroristsflag_atbase = 1;
					    return 1;

				    }

				}
			    if(IsPlayerInRangeOfPoint(playerid, 2.0, Event_SwatFlagX,Event_SwatFlagY,Event_SwatFlagZ))
				{
				    CTF_Swatflag_Dropped = 0;
                    SetPlayerAttachedObject(playerid, 9, 2914, 6, 0.108999, 0.019000, -0.022999, -0.600012, 4.400000, 83.699996, 1, 1, 1, 0xFF00FF00);
				    Event_Swatflag_holder = playerid;
                    DestroyObject(CTF_Swatflag);
                    PlayEventSound(1138);
					format(msgstring,sizeof(msgstring), "%s picked up the SWAT flag!", pName);
		    		SendEventMessage(msgstring);

		    		for (new i = 0; i < 13; i++)
					{
					    GetPlayerWeaponData(playerid, i, lastweapons[playerid][i][0], lastweapons[playerid][i][1]);
					}
					ResetPlayerWeapons(playerid);
				    CTF_Swatflag_atbase = 0;
				    return 1;

				}
			}
		}
	}
	return 1;
}

public StopEvent()
{
	foreach(Player,i)
	{
	    if(EventTeam[i] > 0)
		{
		    SetPlayerInterior(i, 0);
		    Event_InProgress = 0;
	 		Event_started = 0;
	   		EventTeam[i] = 0;
	    	KillTimer(Event_UpdateScoreTimer);
	     	Event_Swatflag_holder = -1;
	      	Event_Terroristsflag_holder = -1;
	        TextDrawHideForPlayer(i, Textdraw0);
	        TextDrawHideForPlayer(i, Textdraw1);
	        TextDrawHideForPlayer(i, Textdraw2);
	        Event_SWAT_Points = 0;
			Event_TERRORISTS_Points = 0;
			Event_TERRORISTScount = 0;
			Event_SWATcount = 0;
	        SpawnPlayer(i);
	        DestroyObject(CTF_Terroristsflag);
			DestroyObject(CTF_Swatflag);
			DestroyObject(CTF_Terroristsflagramp);
			DestroyObject(CTF_Swatflagramp);

		}
	}


}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 501)
	{
	    if(response)
	    {
			new string[250], string2[350];
			format(string,sizeof(string), "{809AAB}The number you typed in is invalid. Please note that the max rounds available is: %d.\n\n{FFFFFF}Specify the amount of rounds necessary to win:", MAX_CTF_ROUNDS);
	        new Value = strval(inputtext);
	        if(Value > MAX_CTF_ROUNDS) return ShowPlayerDialog(playerid, 501, DIALOG_STYLE_INPUT, "Capture The Flag Event Configuration", string,"OK","Cancel");
	        if(Value == 0) return ShowPlayerDialog(playerid, 501, DIALOG_STYLE_INPUT, "Capture The Flag Event Configuration", string,"OK","Cancel");
	        else
	        {
	            Event_pointsamount = Value;

	            format(string,sizeof(string2), "");
	            for(new d=0; d<sizeof(CTF_Maps); d++)
				{
					new mapname[50];
					format(mapname,sizeof(mapname),"%s\n", CTF_Maps[d][0]);
					strins(string2,mapname,strlen(string2));
				}
	            ShowPlayerDialog(playerid, 502, DIALOG_STYLE_LIST, "Capture The Flag Event Configuration (Map)", string2,"Select","Cancel");

	        }
	    }

	}
	if(dialogid == 502)
	{
	    if(response)
	    {
	        new string[150];
	        new pName[MAX_PLAYER_NAME];
         	GetPlayerName(playerid, pName, sizeof(pName));
          	format(string,sizeof(string),"Admin %s started a {FFFFFF}Capture The Flag: %s (%d pts) {999999}Event. Type /join to join!", pName, CTF_Maps[listitem][0], Event_pointsamount);
            SendClientMessageToAll(0x999999FF,string);
            Event_Map = listitem;
	        Event_started = 1;
	        Event_Swatflag_holder = -1;
	        Event_Terroristsflag_holder = -1;
            Event_StartTimer = SetTimer("CTFStart", 30000, false); // Needs to be killed when stopping the event..
	    }

	}
	return 1;
}


public OnPlayerDeath(playerid, killerid, reason)
{

	if(EventTeam[playerid] > 0) // Team is SWAT
	{
	    new Float:X,Float:Y,Float:Z, msgstring[100], pName[MAX_PLAYER_NAME];
	    GetPlayerName(playerid, pName,sizeof(pName));
 		Event_TerrorFlagX = 0.0;
   		if(Event_Terroristsflag_holder == playerid)
   		{
   		    CTF_Terroristflag_Dropped = 1;
   		    Event_Terroristsflag_holder = -1;
			GetPlayerPos(playerid, X,Y,Z);
			Event_TerrorFlagX = X;
			Event_TerrorFlagY = Y;
			Event_TerrorFlagZ = Z-1.0;
    		CTF_Terroristsflag = CreateObject(2993,X,Y,Z-1.0,0.0000000,0.0000000,-89.9999813);

    		format(msgstring,sizeof(msgstring), "%s died and dropped the Terrorists flag!", pName);
    		SendEventMessage(msgstring);

		}
		else if(Event_Swatflag_holder == playerid)
		{
		    CTF_Swatflag_Dropped = 1;
		    Event_Swatflag_holder = -1;
		    GetPlayerPos(playerid, X,Y,Z);
		    Event_SwatFlagX = X;
			Event_SwatFlagY = Y;
			Event_SwatFlagZ = Z-1.0;
			CTF_Swatflag = CreateObject(2914,X,Y,Z-1.0,0.0000000,0.0000000,-89.9999813);

			format(msgstring,sizeof(msgstring), "%s died and dropped the SWAT flag!", pName);
    		SendEventMessage(msgstring);


		}
		if(EventTeam[playerid] == 1)
		{
		    new o = random(sizeof(algorithmxy));
		    SetPlayerHealth(playerid, 100);
		    SpawnPlayer(playerid);
		    SetPlayerSkin(playerid, 285);
		    SetPlayerPos(playerid, SWAT_SPAWN_Coords[Event_Map][0]+algorithmxy[o][0], SWAT_SPAWN_Coords[Event_Map][1]+algorithmxy[o][1], SWAT_SPAWN_Coords[Event_Map][2]);
		    SetPlayerFacingAngle(playerid, CTF_Maps_Info[Event_Map][1]);
		    SetPlayerInterior(playerid, CTF_Maps_Info[Event_Map][0]);

		}
		else if(EventTeam[playerid] == 2)
		{
		    new o = random(sizeof(algorithmxy));
		    SetPlayerHealth(playerid, 100);
		    SpawnPlayer(playerid);
		    SetPlayerSkin(playerid, 14);
		    SetPlayerPos(playerid, TERRORISTS_SPAWN_Coords[Event_Map][0]+algorithmxy[o][0], TERRORISTS_SPAWN_Coords[Event_Map][1]+algorithmxy[o][1], TERRORISTS_SPAWN_Coords[Event_Map][2]);
		    SetPlayerFacingAngle(playerid, CTF_Maps_Info[Event_Map][2]);
		    SetPlayerInterior(playerid, CTF_Maps_Info[Event_Map][0]);

		}
	}
	return 1;
}

CMD:startctf(playerid, params[])
{
    if(Event_started == 0)
	{
		ShowPlayerDialog(playerid, 501, DIALOG_STYLE_INPUT, "Capture The Flag Event Configuration","{FFFFFF}Specify the amount of points necessary to win:","OK","Cancel");
	}
	return 1;
}

CMD:join(playerid, params[])
{
	if(EventTeam[playerid] > 0) return SendClientMessage(playerid, 0xcde9e9FF,"[EVENT] You are already in the event!");
	if(Event_InProgress == 1) return SendClientMessage(playerid, 0xcde9e9FF,"[EVENT] You can't join because it's already in progress.");
	if(Event_started == 1)
	{
	    if(Event_SWATcount+Event_TERRORISTScount == 32) return SendClientMessage(playerid, 0xcde9e9FF,"[EVENT] Event is full!");
		if(Event_SWATcount < Event_TERRORISTScount)
		{
		    for (new d = 0; d < 16; d++)
			{
			    if(d == Event_SWATcount)
			    {
				    SetPlayerPos(playerid, SWAT_SPAWN_Coords[Event_Map][0]+algorithmxy[d][0], SWAT_SPAWN_Coords[Event_Map][1]+algorithmxy[d][1], SWAT_SPAWN_Coords[Event_Map][2]);
				    SetPlayerSkin(playerid, 285);
				    Event_SWATcount ++;
				    EventTeam[playerid] = 1;
				    SetPlayerFacingAngle(playerid, CTF_Maps_Info[Event_Map][1]);
					TogglePlayerControllable(playerid, 0);
			    }
		    }
		}
		else
		{
  			for (new d = 0; d < 16; d++)
			{
			    if(d == Event_TERRORISTScount)
			    {
				    SetPlayerPos(playerid, TERRORISTS_SPAWN_Coords[Event_Map][0]+algorithmxy[d][0], TERRORISTS_SPAWN_Coords[Event_Map][1]+algorithmxy[d][1], TERRORISTS_SPAWN_Coords[Event_Map][2]);
				    SetPlayerSkin(playerid, 14);
				    Event_TERRORISTScount ++;
				    EventTeam[playerid] = 2;
				    SetPlayerFacingAngle(playerid, CTF_Maps_Info[Event_Map][2]);
					TogglePlayerControllable(playerid, 0);
   				}
   			}
		}

		SetPlayerInterior(playerid, CTF_Maps_Info[Event_Map][0]);
		TogglePlayerControllable(playerid, 0);
		SendClientMessage(playerid, 0x999999FF,"This event has been scripted by Chilco.");
		SendClientMessage(playerid, 0xcde9e9FF,"[EVENT] The event will start in less then 30 seconds!");
	}
	return 1;
}

public CTFStart()
{
	Event_InProgress = 1;
    Event_Terroristsflag_holder = -1;
    Event_Swatflag_holder = -1;

    CTF_Swatflag_atbase = 1;
    CTF_Terroristsflag_atbase = 1;
// In OnGameModeInit prefferably, we procced to create our textdraws:
	Textdraw0 = TextDrawCreate(499.000000, 116.000000, "~b~SWAT: ~w~0");
	TextDrawBackgroundColor(Textdraw0, 255);
	TextDrawFont(Textdraw0, 1);
	TextDrawLetterSize(Textdraw0, 0.369999, 1.200000);
	TextDrawColor(Textdraw0, -1);
	TextDrawSetOutline(Textdraw0, 1);
	TextDrawSetProportional(Textdraw0, 1);

	Textdraw1 = TextDrawCreate(500.000000, 131.000000, "Points needed: ");
	TextDrawBackgroundColor(Textdraw1, 255);
	TextDrawFont(Textdraw1, 1);
	TextDrawLetterSize(Textdraw1, 0.299999, 1.400000);
	TextDrawColor(Textdraw1, -1);
	TextDrawSetOutline(Textdraw1, 1);
	TextDrawSetProportional(Textdraw1, 1);

	Textdraw2 = TextDrawCreate(499.000000, 104.000000, "~r~TERRORISTS: ~w~0"); //104
	TextDrawBackgroundColor(Textdraw2, 255);
	TextDrawFont(Textdraw2, 1);
	TextDrawLetterSize(Textdraw2, 0.369999, 1.200000);
	TextDrawColor(Textdraw2, -1);
	TextDrawSetOutline(Textdraw2, 1);
	TextDrawSetProportional(Textdraw2, 1);

	new string[30];
	format(string,sizeof(string),"Points needed: %d", Event_pointsamount);
	TextDrawSetString(Textdraw1, string);

    SendClientMessageToAll(0xcde9e9FF,"[EVENT] The Capture The Flag event is now in progress and can't be joined anymore!");
    CTF_Swatflag = CreateObject(2914,SwatflagXYZ[Event_Map][0],SwatflagXYZ[Event_Map][1],SwatflagXYZ[Event_Map][2],0.0000000,0.0000000,-89.9999813);
    CTF_Terroristsflag = CreateObject(2993,TerrorflagXYZ[Event_Map][0],TerrorflagXYZ[Event_Map][1],TerrorflagXYZ[Event_Map][2],0.0000000,0.0000000,-89.9999813);

    CTF_Swatflagramp = CreateObject(13646,SwatflagXYZ[Event_Map][0],SwatflagXYZ[Event_Map][1],SwatflagXYZ[Event_Map][2]-0.5,0.0000000,0.0000000,0.0000000); //object(ramplandpad) (2)
    CTF_Terroristsflagramp = CreateObject(13646,TerrorflagXYZ[Event_Map][0],TerrorflagXYZ[Event_Map][1],TerrorflagXYZ[Event_Map][2]-0.5,0.0000000,0.0000000,0.0000000); //object(ramplandpad) (2)


    CreateObject(8664,-746.3176880,1909.5915530,-0.4299710,0.0000000,0.0000000,-89.9999813); //object(casrylegrnd_lvs) (1)
    foreach(Player, i)
    {
        if(EventTeam[i] > 0)
        {
            TogglePlayerControllable(i, 1);
            TextDrawShowForPlayer(i, Textdraw2);
            GameTextForPlayer(i, "Capture the enemy flag!", 5000, 5);
        }
    }
    Event_UpdateScoreTimer = SetTimer("CTFScore", 100, true);

    Event_TerrorFlagDropOffX = TerrorflagXYZ[Event_Map][0];
    Event_TerrorFlagDropOffY = TerrorflagXYZ[Event_Map][1];
    Event_TerrorFlagDropOffZ = TerrorflagXYZ[Event_Map][2];
	Event_SwatFlagDropOffX = SwatflagXYZ[Event_Map][0];
	Event_SwatFlagDropOffY = SwatflagXYZ[Event_Map][1];
	Event_SwatFlagDropOffZ = SwatflagXYZ[Event_Map][2];


	Event_SWATcount = 0;
	Event_TERRORISTScount = 0;

}

public CTFScore()
{
    new string[120];
	format(string,sizeof(string),"~r~TERRORISTS: ~w~%d~n~~b~SWAT: ~w~%d~n~Points needed: %d", Event_TERRORISTS_Points, Event_SWAT_Points, Event_pointsamount);
	TextDrawSetString(Textdraw2, string);

	if(CTF_Swatflag_atbase == 1)
	{
 		Event_SwatFlagX = SwatflagXYZ[Event_Map][0];
   		Event_SwatFlagY = SwatflagXYZ[Event_Map][1];
	    Event_SwatFlagZ = SwatflagXYZ[Event_Map][2];
	}
	else
	{
	    if(CTF_Swatflag_Dropped != 1)
	    {
			Event_SwatFlagX = 0;
		    Event_SwatFlagY = 0;
		    Event_SwatFlagZ = 0;
  		}
	}
	if(CTF_Terroristsflag_atbase == 1)
	{
	    Event_TerrorFlagX = TerrorflagXYZ[Event_Map][0];
	    Event_TerrorFlagY = TerrorflagXYZ[Event_Map][1];
	    Event_TerrorFlagZ = TerrorflagXYZ[Event_Map][2];
	}
	else
	{
	    if(CTF_Terroristflag_Dropped != 1)
	    {
		    Event_TerrorFlagX = 0;
		    Event_TerrorFlagY = 0;
		    Event_TerrorFlagZ = 0;
	    }
	}
}

stock SendEventMessage(msg[])
{
    foreach(Player,i)
    {
        if(EventTeam[i] > 0)
        {
            new output[256];
            format(output,sizeof(output),"[EVENT] %s", msg);
            SendClientMessage(i, 0xcde9e9FF, output);

        }
    }
    return 1;
}

stock PlayEventSound(id)
{
    foreach(Player,i)
	{
	    if(EventTeam[i] > 0)
	    {
 			PlayerPlaySound(i, id, 0.0, 0.0, 0.0);
 		}
	}
}
