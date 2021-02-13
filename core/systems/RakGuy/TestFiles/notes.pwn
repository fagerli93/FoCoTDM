//#include <foco>
#include <YSI\y_hooks>

#define PATH "/Notes/%d.ini"

#if !defined isnull
    #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

#define DIALOG_NORESPONSE 111

new PlayerNotes[MAX_PLAYERS][10][50];

forward LoadUser_NOTES(playerid, tag[], name[],value[]);
public LoadUser_NOTES(playerid, tag[], name[],value[])
{
	INI_String("Note0",	PlayerNotes[playerid][0], 50);
	INI_String("Note1",	PlayerNotes[playerid][1], 50);
	INI_String("Note2",	PlayerNotes[playerid][2], 50);
	INI_String("Note3",	PlayerNotes[playerid][3], 50);
    INI_String("Note4",	PlayerNotes[playerid][4], 50);
	INI_String("Note5",	PlayerNotes[playerid][5], 50);
	INI_String("Note6",	PlayerNotes[playerid][6], 50);
	INI_String("Note7",	PlayerNotes[playerid][7], 50);
	INI_String("Note8",	PlayerNotes[playerid][8], 50);
    INI_String("Note9",	PlayerNotes[playerid][9], 50);
	for(new i = 0; i < 10;  i++)
	{
	    if(isnull(PlayerNotes[playerid][i]))
	    {
	        PlayerNotes[playerid][i] = "None";
	    }
	}
 	return 1;
}

stock UserPath(playerid)
{
	new string[128];
	format(string,sizeof(string),PATH, FoCo_Player[playerid][id]);
	return string;
}

forward LoadPlayerNotes(playerid);
public LoadPlayerNotes(playerid)
{
	if(fexist(UserPath(playerid)))
	{
		INI_ParseFile(UserPath(playerid), "LoadUser_NOTES", .bExtra = true, .extra = playerid);
  		//NoteLog(playerid, NOTE_LOAD);
	}
	else
	{
		new INI:File = INI_Open(UserPath(playerid));
		INI_WriteString(File, "Note0", "None");
		INI_WriteString(File, "Note1", "None");
		INI_WriteString(File, "Note2", "None");
		INI_WriteString(File, "Note3", "None");
		INI_WriteString(File, "Note4", "None");
		INI_WriteString(File, "Note5", "None");
		INI_WriteString(File, "Note6", "None");
		INI_WriteString(File, "Note7", "None");
		INI_WriteString(File, "Note8", "None");
		INI_WriteString(File, "Note9", "None");
		INI_Close(File);
		//Works till here..
		//INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
		for(new i = 0; i < 10; i++)
		{
			PlayerNotes[playerid][i] = "None";
		}
	}
	return 1;
}

hook OnPlayerConnect(playerid)
{
	LoadPlayerNotes(playerid);
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	SavePlayerNotes(playerid);
	return 1;
}

forward SavePlayerNotes(playerid);
public SavePlayerNotes(playerid)
{
	for(new i = 0; i < 10;  i++)
	{
	    if(isnull(PlayerNotes[playerid][i]))
	    {
	        PlayerNotes[playerid][i] = "None";
	    }
	}
	new INI:File = INI_Open(UserPath(playerid));
	INI_WriteString(File,"Note0", PlayerNotes[playerid][0]);
	INI_WriteString(File,"Note1", PlayerNotes[playerid][1]);
	INI_WriteString(File,"Note2", PlayerNotes[playerid][2]);
	INI_WriteString(File,"Note3", PlayerNotes[playerid][3]);
	INI_WriteString(File,"Note4", PlayerNotes[playerid][4]);
	INI_WriteString(File,"Note5", PlayerNotes[playerid][5]);
	INI_WriteString(File,"Note6", PlayerNotes[playerid][6]);
	INI_WriteString(File,"Note7", PlayerNotes[playerid][7]);
	INI_WriteString(File,"Note8", PlayerNotes[playerid][8]);
	INI_WriteString(File,"Note9", PlayerNotes[playerid][9]);
	INI_Close(File);
	return 1;
}

CMD:notes(playerid, params[])
{
	new option[128], flag;
	if(sscanf(params, "s[128]", option))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /notes [create/show/delete]");
	}
	if(!strcmp(option, "show", true, 4) || !strcmp(option, "display", true, 7))
	{
		flag = 0;
		new msg[600] = "{ff0000}NoteID\t\tNote Message\n";
		for(new i = 0; i < 10; i++)
		{
			if(strcmp(PlayerNotes[playerid][i], "None", false))
			{
				flag++;
				format(msg, sizeof(msg), "%s{00FF00}%i\t\t%s\n", msg, i+1,  PlayerNotes[playerid][i]);
			}
		}
		if(flag > 0)
			ShowPlayerDialog(playerid, DIALOG_NORESPONSE, DIALOG_STYLE_MSGBOX, "Notes", msg, "Close", "");
		else
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not have any notes. Use /notes create [/NOTE/]");
	}
	else if(!strcmp(option, "create", true, 6))
	{
		flag = 0;
		for(new i = 0; i < 10; i++)
		{
			if(!strcmp(PlayerNotes[playerid][i], "None", false) && !flag)
			{
				flag++;
				strdel(params, 0, 6);
				if(sscanf(params, "s[128]", option))
					return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /notes create [/NOTE/]");
				else
				{
					strmid(PlayerNotes[playerid][i], option, 0, 50);
					SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You have successfully created a NOTE. Use /notes show to view it");
				}
			}
		}
		if(!flag)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not have any more free Note-Space. Use /notes delete to clear some Slot.");
		}
	}
	else if(!strcmp(option, "delete", true, 6))
	{
	    strdel(params, 0, 6);
		if(sscanf(params, "i", flag))
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /notes delete [NoteID] (Use /notes show to check ID of Note)");
		}
		else
		{
		    flag--;
			if(flag >= 0 && flag <= 9)
			{
				new msg[256];
				format(msg, sizeof(msg), "[NOTICE]: You have successfully deleted NoteID:%i, Note:%s", flag + 1, PlayerNotes[playerid][flag]);
				PlayerNotes[playerid][flag] = "None";
				SendClientMessage(playerid, COLOR_NOTICE, msg);
			}
			else
			{
			    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid NoticeID. NoticeID must be between 1 - 10");
			}
		}
	}
	else
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /notes [create/show/delete]");
	return 1;
}

/*CMD:nload(playerid, params[])
{
    LoadPlayerNotes(playerid);
	return 1;
}

CMD:nsave(playerid, params[])
{
    SavePlayerNotes(playerid);
	return 1;
}

CMD:nlist(playerid, params[])
{
	for(new i = 0; i < 10;  i++)
	{
	    SendClientMessage(playerid, -1, PlayerNotes[playerid][i]);
	}
	return 1;
}*/
