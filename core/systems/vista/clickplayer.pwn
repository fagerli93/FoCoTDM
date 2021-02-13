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
* Filename: clickplayer.pwn                                                      *
* Author: dr_vista                                                               *
*********************************************************************************/
#include <YSI\y_hooks>
#define    DIALOG_ACTIONS              530
#define    DIALOG_REASON               531
#define    DIALOG_NETSTATS             532
#define    DIALOG_JAILTIME             533

enum
{
  	ACTION_KICK,
	ACTION_BAN,
	ACTION_WARN,
	ACTION_MUTE,
	ACTION_JAIL
};

new
	pClickedID[MAX_PLAYERS],
	jailtime[MAX_PLAYERS],
	pAction[MAX_PLAYERS];
	

hook OnPlayerConnect(playerid)
{
    pClickedID[playerid] = -1;
	pAction[playerid] = -1;
	jailtime[playerid] = -1;

	return 1;
}

hook OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(FoCo_Player[playerid][admin] < 1)
	{
	    ShowNetStats(playerid, clickedplayerid);
	}
	
	else
	{
    	pClickedID[playerid] = clickedplayerid;
		ShowPlayerDialog(playerid, DIALOG_ACTIONS, DIALOG_STYLE_LIST, "Actions:", "Kick\nBan\nWarn\n(Un)Mute\nJail\nNetwork stats", "Okay", "Cancel");
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    print("ODR_Vista_ClickP");
	switch(dialogid)
	{
		case DIALOG_ACTIONS:
		{
			if(response)
			{
				if(listitem < 5)
				{
				    switch(listitem)
				    {
				        case 0: pAction[playerid] = ACTION_KICK;
				        case 1: pAction[playerid] = ACTION_BAN;
				        case 2: pAction[playerid] = ACTION_WARN;
				        case 3: pAction[playerid] = ACTION_MUTE;
				        case 4:
						{
							pAction[playerid] = ACTION_JAIL;
							return ShowPlayerDialog(playerid, DIALOG_JAILTIME, DIALOG_STYLE_INPUT, "Time:", "Enter the amount of time:", "Okay", "Cancel");
						}
					}
					ShowPlayerDialog(playerid, DIALOG_REASON, DIALOG_STYLE_INPUT, "Reason:", "Enter the reason:", "Okay", "Cancel");
				}

				else if(listitem == 5)
				{
                    ShowNetStats(playerid, pClickedID[playerid]);
				}
			}
		}
		
		case DIALOG_REASON:
        {
            if(!response)
			{
			    return 1;
			}
			
            if(0 < strlen(inputtext) <= 100)
            {
                new
                    retstr[128];
                    
                format(retstr, sizeof(retstr), "%d %s", pClickedID[playerid], inputtext);
                
	            switch(pAction[playerid])
	            {
					case ACTION_KICK:
					{
						return cmd_kick(playerid, retstr);
					}

					case ACTION_BAN:
					{
                        return cmd_ban(playerid, retstr);
					}

					case ACTION_WARN:
					{
                        return cmd_warn(playerid, retstr);
					}

					case ACTION_MUTE:
					{
					    format(retstr, sizeof(retstr), "%d", pClickedID[playerid]);
					    if(mutedPlayers[pClickedID[playerid]][muted] == 0)
					    {
					    	mutePlayer(pClickedID[playerid], playerid, -1);
					    }
						
						else
						{
                        	return cmd_unmute(playerid, retstr);
                        }
					}

					case ACTION_JAIL:
					{
					    format(retstr, sizeof(retstr), "%d %d %s", pClickedID[playerid], jailtime[playerid], inputtext);
						return cmd_jail(playerid, retstr);
					}
	            }
			}
			

			else
			{
			    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Reason too short or too long. (Max 100 chars)");
			}
		}
		
		case DIALOG_JAILTIME:
		{
		    if(IsNumeric(inputtext))
		    {
				jailtime[playerid] = strval(inputtext);
				ShowPlayerDialog(playerid, DIALOG_REASON, DIALOG_STYLE_INPUT, "Reason:", "Enter the reason:", "Okay", "Cancel");
			}
		}
			
	}
	return 1;
}


/*

ShowNetStats (playerid, targetid);

Shows a player's netstats to another player (or even himself)

by vista

*/

forward ShowNetStats(playerid, targetid);
public ShowNetStats(playerid, targetid)
{
	new
		stats[400+1],
		pName[MAX_PLAYER_NAME],
		string[MAX_PLAYER_NAME + 20];

	GetPlayerName(targetid, pName, sizeof(pName));
	format(string, sizeof(string), "%s's network stats", pName);
	GetPlayerNetworkStats(targetid, stats, sizeof(stats));
	ShowPlayerDialog(playerid, DIALOG_NETSTATS, DIALOG_STYLE_MSGBOX, string, stats, "Okay", "");

	return 1;
}
