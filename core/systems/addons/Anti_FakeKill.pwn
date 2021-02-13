#include <YSI\y_hooks>

new LastDeath[MAX_PLAYERS];
new DeathSpam[MAX_PLAYERS char];

hook OnPlayerConnect(playerid)
{
	DeathSpam{playerid} = 0;
	return 1;
}
forward a_fkOnPlayerDeath(playerid, killerid, reason);
public a_fkOnPlayerDeath(playerid, killerid, reason)
{
	new time = gettime();
	if(time - LastDeath[playerid]<2)
	{
		DeathSpam{playerid}++;
		if( DeathSpam{playerid} == 6)
		{
			ABanPlayer(-1, playerid, "FakeKill", 1);
			/*new string[256];

		    format(string, sizeof(string), "[AntiCheat]: Banned %s(%d), Reason: Fake Kills.", PlayerName(playerid), playerid);
		    SendClientMessageToAll(COLOR_GLOBALNOTICE, string);

		    format(string, sizeof(string), "[AntiCheat]: {ff6347}Player %s has been banned by the anticheat for using fake kills.", PlayerName(playerid));
            SendAdminMessage(1, string);

            format(string, sizeof(string), "[AntiCheat]: %s you have been banned by the anticheat for using: Fake Kills.", PlayerName(playerid));
  			SendClientMessage(playerid, COLOR_NOTICE, string);
  			SendClientMessage(playerid, COLOR_NOTICE, "If you find this ban wrongful you can appeal at: forum.focotdm.com");
			format(string, sizeof(string), "INSERT INTO `FoCo_AdminRecords` (`user`, `admin`, `actiontype`, `reason`, `date`) VALUES ('%d', 'Anti-Cheat', '3', 'Fake Kills', '%s')", FoCo_Player[playerid][id], TimeStamp());
			mysql_query(string, MYSQL_THREAD_ADMINRECORD_INSERT, playerid, con);
			format(string, sizeof(string), "UPDATE `FoCo_Players` SET `banned` = `1` WHERE `username` = '%s'",PlayerName(playerid));
			mysql_query(string);
			Ban(playerid);*/
			return 1;
		}
	}
	LastDeath[playerid] = time;
	return 1;
}


