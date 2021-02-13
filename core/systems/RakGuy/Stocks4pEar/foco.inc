#define COLOR_WARNING 0x800000FF
#define COLOR_NOTICE 0xE0FFFFFF
#define COLOR_SYNTAX 0xE03344FF
/*------------------------------------------*/
#define COLOR_ADMIN	0x00FF00FF
#define COLOR_TESTER	0x000080FF
#define COLOR_ANTICHEAT	0x650065FF
#define COLOR_LOCALMSG	0xEC5413FF
#define COLOR_ADMINCMD	0xF97804FF
#define COLOR_NOTLOGGED	0x000000FF
#define COLOR_GRAD1	0xB4B5B7FF
#define COLOR_GRAD2	0xBFC0C2FF
#define COLOR_GRAD3	0xCBCCCEFF
#define COLOR_GRAD4	0xD8D8D8FF
#define COLOR_GRAD5	0xE3E3E3FF
#define COLOR_GRAD6	0xF0F0F0FF
#define COLOR_GREY	0xAFAFAFFF
#define COLOR_GREEN	0x33AA33FF
#define COLOR_RED	0xFF6347FF
#define COLOR_INVISRED	0xFF6347FF
#define COLOR_DARKRED	0xCD0000FF
#define COLOR_LIGHTRED	0xFF6347FF
#define COLOR_LIGHTGREEN	0x9ACD32FF
#define COLOR_LIGHTRED	0xFF6347FF
#define COLOR_LIGHTBLUE	0x33CCFFFF
#define COLOR_LIGHTBLUE2	0x0080FFFF
#define COLOR_LIGHTORANGE	0xFF8000FF
#define COLOR_DARKBROWN	0xB36C42FF
#define COLOR_MEDIUMBLUE	0x1ED5C7FF
#define COLOR_LIGHTYELLOW	0xE0E377FF
#define COLOR_LIGHTYELLOW2	0xE0EA64FF
#define COLOR_LIGHTYELLOW3	0xFF6347FF
#define COLOR_DARKPURPLE	0x5F56F8FF
#define COLOR_YELLOW	0xFFFF00FF
#define COLOR_YELLOW2	0xF5DEB3FF
#define COLOR_WHITE	0xFFFFFFFF
#define COLOR_FADE1	0xE6E6E6FF
#define COLOR_FADE2	0xC8C8C8FF
#define COLOR_FADE3	0xAAAAAAFF
#define COLOR_FADE4	0x8C8C8CFF
#define COLOR_FADE5	0x6E6E6EFF
#define COLOR_PURPLE	0xA900F6FF
#define COLOR_DBLUE	0x2641FEFF
#define COLOR_BLUE	0x008CF5FF
#define COLOR_NEWS	0xFFA500FF
#define COLOR_OOC	0xE0FFFFFF
#define COLOR_NEWOOC	0x0080FFFF
#define COLOR_ACTIONS	0x00FFFFFF
#define COLOR_ADWARNING	0xFFFF00FF

#include <a_samp>
#include <sscanf2>
#include <zcmd>
#include <streamer>
#include <YSI\y_timers>
#include <YSI\y_iterate>


new Event_ID;
new FoCo_Event_Died[MAX_PLAYERS];
new Event_InProgress;


stock PlayerName(playerid)
{
	new string[24];
	GetPlayerName(playerid, string, sizeof(string));
	return string;
}


new P_Status[6][40]=
{
"Junior Admin", "Administrator", "Senior Admin", "Lead Admin", "Mofo Admin", "Pro Admin"
};

stock AdminLvl(playerid)
{
	return GetPVarInt(playerid, "Admin");
}

stock AdminsOnline()
{
	new count;
	foreach(Player, i)
	{
	    if(GetPlayerSkin(i)>0)
	    {
	        count++;
	    }
	}
	return count;
}

stock TAdminsOnline()
{
	new count;
	foreach(Player, i)
	{
	    if(GetPlayerSkin(i)>0)
	    {
	        count++;
	    }
	}
	return count;
}
stock GetPlayerStatus(playerid)
{
	return P_Status[GetPVarInt(playerid, "Admin")];
}

stock IsAdmin(playerid, Level)
{
	return 1;
}
#define gEcho 1
#define gLeads 2
#define IRC_FOCO_ECHO 3
#define IRC_FOCO_LEADS 4
stock IRC_GroupSay(Type, LOL, MSG[])
{
	if(Type==1)
	{
	    SendAdminMessage(1, MSG);
	}
	if(Type==2)
	{
	    SendTesterChat(MSG);
	}
}

stock SendAdminMessage(Level, MSG[])
{
	
	return SendClientMessageToAll(COLOR_WARNING, MSG);
}

stock SendTesterChat(MSG[])
{
	return SendClientMessageToAll(COLOR_SYNTAX, MSG);
}

stock AntiCheatMessage(MSG[])
{
	return SendClientMessageToAll(COLOR_WARNING, MSG);
}

stock ABanPlayer(Banner, Target, Reason[])
{
	return 1;
}


enum FoCoD
{
	onlinetime
}
stock DebugMsg(MSG[])
{
	return SendClientMessageToAll(-1, MSG);
}

stock CheatLog(MSG[])
{
    DebugMsg(MSG);
	return 1;
}

new FoCo_Player[MAX_PLAYERS][FoCoD];











