#define MAX_RNDMSGS 24
// Remember to update the number (Which is now 23) if you want to add or take away any lines. Otherwise it won't work.

new RandomMessages[MAX_RNDMSGS][128] =
{
	{"Did you know? If you require help, there are (trial) admins available. Use /helpme for questions"},
	{"Did you know? You can use /help to bring up a list of commands available to you."},
	{"Did you know? You can use /hits to see a list of active hits."},
	{"Did you know? There are plenty of achievements to finish. Use /achievements ([ID])."},
	{"Did you know? You can buy vehicles at commerce with the command /buycar."},
	{"Did you know? You can use /mod to modify the car you're in."},
	{"Did you know? You can go to an ammunation to /buy guns."},
	{"Did you know? All game kill stats are saved, from Fist through to explosions."},
	{"Did you know? We are currently recruiting for the FoCoTDM mapping team. See our forums for more information"},
	{"Did you know? You can duel another player by using the command /duel"},
	{"Did you know? FoCoTDM has been running since January 2011!"},
	{"Did you know? Spawn-killing is against the rules - regardless if you are only defending yourself."},
	{"Did you know? /setstation allows you to listen to real radios!"},
	{"Did you know? You can join official clans by checking out their section on the forums for more instructions."},
	{"Did you know? Hacking or using any CLEO list not on the whitelisted CLEO list will get you banned."},
	{"Did you know? We have a forum! www.forum.focotdm.com."},
	{"Did you know? If there are hackers online whilst no admins are online, you can always contact one via IRC or team-speak."},
	{"Did you know? As you rank up you get access to armour and better weaponry. Check /levels for more information."},
	{"Did you know? /rules gives you a list of all current rules."},
	{"Did you know? /levels tells you about how many kills it takes to level up."},
	{"Did you know? /spree will tell you who is currently on a spree."},
	{"Did you know? You will be awarded if you get on a killing-spree."},
	{"Did you know? You can place a hit on someones head with /hit."},
	{"Never give your password to other players, not even admins."}
};


/* VARIABLE DEFINED AND USED IN pEar_Stations.pwn (Dev folder)
enum stations
{
	stationID,
	stationName[50],
	stationURL[255]
};*/

/*
#define MAX_STATIONS 29
// Remember to update the number if you add or remove a radio station. Also remember the number at the bottom is not the MAX number, cause it starts with 0 !
new setstations[MAX_STATIONS][ stations ] = {
   {0, "-ENTER YOUR OWN STATION-" ,"0"},
   {1, "Defjay DE", "http://tunein.defjay.de/listen.pls"},
   {2, "idobi Radio", "http://www.idobi.com/radio/iradio.pls"},
   {3, "HPR1: The Classic Country Channel", "http://loudcity.com/stations/hpr1-classic-country/files/show/hpr1mp3.pls"},
   {4, "sky.fm - All Hit 70s", "http://www.sky.fm/mp3/hit70s.pls"},
   {5, "Music Rock EXTREME", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=2483"},
   {6, "Radio Hunter The Hitz", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=122032"},
   {7, "181.FM The Power", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1283896"},
   {8, "Defjay USA", "http://www.defjay.com/listen128k.pls"},
   {9, "PowerHitz", "http://www.powerhitz.com/ph.pls"},
   {10, "ChartHitz FM", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=43280"},
   {11, "HT104 Your Top 40 Channel", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=395541"},
   {12, "Eternal Music", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1407303"},
   {13, "Roots Reggae", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=279923"},
   {14, "BlackBeats FM", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=111772"},
   {15, "181 FM The Beat", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1283896"},
   {16, "Nova 100", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=34972"},
   {17, "181 The Office", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=26002"},
   {18, "BreakZ", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=83155"},
   {19, "181 True RnB", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=366480"},
   {20, "Gay FM", "http://sc1.streamfox.com:8010/listen.pls"},
   {21, "Westcoast RAP", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1462312"},
   {22, "TechnoBase.FM", "http://listen.technobase.fm/dsl.pls"},
   {23, "HouseTime.FM", "http://listen.housetime.fm/dsl.pls"},
   {24, "HardBase.FM", "http://listen.hardbase.fm/dsl.pls"},
   {25, "TranceBase.FM", "http://listen.trancebase.fm/dsl.pls"},
   {26, "CoreTime.FM", "http://listen.coretime.fm/dsl.pls"},
   {27, "ClubTime.FM", "http://listen.clubtime.fm/dsl.pls"},
   {28, "FoCo FM", "http://78.129.224.21:11008/listen.pls"}
};
*/
