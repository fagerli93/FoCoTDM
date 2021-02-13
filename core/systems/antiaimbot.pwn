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
*                        (c) Copyright                                           *
*  Owners: Simon Fagerli (pEar) - Lee Percox (Shaney) - Warren Bickley (WazzaJB) *
*         Developers: Marcel, RakGuy, FKu, Chilco, dr_vista, Fletcher            *
*                                                                                *
* Filename: antiaimbot.pwn                                                       *
* Author: dr_vista                                                               *
*********************************************************************************/

new randstr[][30 char]
{
	{!"Cheating"},
	{!"Busted"},
	{!"Cheats detected"},
	{!"Hacks detected"},
	{!"Hacker"},
	{!"Cheating is not allowed"}
};


public AimbotCheck()
{
    new
		weapon,
		ammo;
	foreach(new playerid : Player)
	{	
		GetPlayerWeaponData(playerid, 0, weapon, ammo);
		
		if(weapon == 0 && ammo == 1000)
		{
			new
				string[128],
				unpacked[30],
				rand = random(5);
			
			strunpack(unpacked, randstr[rand]);
			format(string, sizeof(string), "[Guardian]: Banned %s(%d), Reason: %s", PlayerName(playerid), playerid, unpacked);
			SendClientMessageToAll(COLOR_GLOBALNOTICE, string);
			
			format(string, sizeof(string), "[Guardian]: {ff6347}Player %s has been banned by the anticheat for using an aimbot.", PlayerName(playerid));
			SendAdminMessage(1, string);
			
			format(string, sizeof(string), "[Guardian]: %s you have been banned by the anticheat.", PlayerName(playerid));
			SendClientMessage(playerid, COLOR_NOTICE, string);
			SendClientMessage(playerid, COLOR_NOTICE, "If you find this ban wrongful you can appeal at: forum.focotdm.com");
			format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', 'Anti-Cheat', '3', 'Aimbot', '%s')", FoCo_Player[playerid][id], TimeStamp());
			mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
			Ban(playerid);
		}
	}	
}
