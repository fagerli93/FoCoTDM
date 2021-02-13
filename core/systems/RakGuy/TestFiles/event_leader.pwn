#include <YSI\y_hooks>

#define EVENT_SPREE 5
enum event_kdr_det
{
	e_kills,
	e_deaths,
	e_spree,
	e_maxspree,
	e_totspree
};
new Event_KDR[MAX_PLAYERS][event_kdr_det];

enum event_topspreedet
{
	p_name[24],
	p_spree
}
new Event_TopSpree[event_topspreedet]; //To avoid bugging it if he logs..
new bool:e_LeaderBoard;

/*DEBUG*/
#if defined PTS
CMD:debugsek(playerid, params[])
{
	Event_KDR[playerid][e_kills] = 10;
	Event_KDR[playerid][e_deaths] = 10;
	Event_KDR[playerid][e_spree] = 10;
	Event_KDR[playerid][e_maxspree] = 10;
	Event_KDR[playerid][e_totspree] = 1;
	return 1;
}
CMD:checkeldr(playerid, params[])
{
	new dbmsg[128];
	format(dbmsg, sizeof(dbmsg), "%i : %i : %i : %i : %i", Event_KDR[playerid][e_kills], Event_KDR[playerid][e_deaths], Event_KDR[playerid][e_spree], Event_KDR[playerid][e_maxspree], Event_KDR[playerid][e_totspree]);
	SendClientMessage(playerid, COLOR_WARNING, dbmsg);
	return 1;
}
#endif
/*ENDOFDEBUG*/
forward AddToEventKills(playerid, killerid);
public AddToEventKills(playerid, killerid)
{
	if(GetPVarInt(playerid, "InEvent") == 1 && GetPVarInt(killerid, "InEvent") == 1)
	{
		if(killerid != INVALID_PLAYER_ID)
		{
			Event_KDR[killerid][e_kills]++;
			Event_KDR[killerid][e_spree]++;
			if(Event_KDR[killerid][e_spree] > Event_TopSpree[p_spree])
			{
				Event_TopSpree[p_name] = PlayerName(killerid);
				Event_TopSpree[p_spree] = Event_KDR[killerid][e_spree];
			}
		}
		if(playerid != INVALID_PLAYER_ID)
		{
			Event_KDR[playerid][e_deaths]++;
			if(Event_KDR[playerid][e_spree] >= EVENT_SPREE)
			{
				Event_KDR[playerid][e_totspree]++;
			}
			if(Event_KDR[playerid][e_maxspree] < Event_KDR[playerid][e_spree])
			{
				Event_KDR[playerid][e_maxspree] = Event_KDR[playerid][e_spree];
			}
			Event_KDR[playerid][e_spree] = 0;		
		}
	}
	return 1;
}

stock ResetEventKills(playerid)
{
    Event_KDR[playerid][e_kills] = 0;
    Event_KDR[playerid][e_deaths] = 0;
    Event_KDR[playerid][e_spree] = 0;
    Event_KDR[playerid][e_kills] = 0;
    Event_KDR[playerid][e_maxspree] = 0;
    Event_KDR[playerid][e_totspree] = 0;
}

hook OnPlayerConnect(playerid)
{
	ResetEventKills(playerid);
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	ResetEventKills(playerid);
	return 1;
}

stock ResetEKForEvent()
{
	foreach(Player, i)
	{
	    ResetEventKills(i);
	}
	format(Event_TopSpree[p_name], sizeof(Event_TopSpree[p_name]), "%s", "NONE");
	Event_TopSpree[p_spree] = 0;
	e_LeaderBoard = false;
}

enum event_leader_det
{
	kill_lead,
	death_lead,
	kdr_lead,
	spree_lead,
	totspree_lead
}

new dialogmessage[300];

forward DisplayEventLeader();
public DisplayEventLeader()
{
	new event_leader[event_leader_det] = {-1, -1, -1, -1, -1};
	new leadermessage[356];
	foreach(Player, i)
	{
	    if(Event_KDR[i][e_kills] == 0 && Event_KDR[i][e_deaths] == 0)
		{
		    SendClientMessage(i, COLOR_NOTICE, "[NOTICE]: You have 0.0 KDR since you have neither killed nor died.");
		}
		else
		{
            if(event_leader[kill_lead] == -1)
				event_leader[kill_lead] = i;
            else
				if(Event_KDR[i][e_kills] > Event_KDR[event_leader[kill_lead]][e_kills])
				    event_leader[kill_lead] = i;
				    
				    
            if(event_leader[death_lead] == -1)
				event_leader[death_lead] = i;
            else
				if(Event_KDR[i][e_deaths] > Event_KDR[event_leader[death_lead]][e_kills])
				    event_leader[death_lead] = i;

			if(Event_KDR[i][e_kills] > 7)
			{
	            if(event_leader[kdr_lead] == -1)
					event_leader[kdr_lead] = i;
				else if(Event_KDR[i][e_deaths] == 0)
				{
				    if(Event_KDR[i][e_kills] > Event_KDR[event_leader[kdr_lead]][e_kills])
				    {
				        event_leader[kdr_lead] = i;
				    }
				    else if(floatdiv(Event_KDR[event_leader[kdr_lead]][e_kills], Event_KDR[i][e_kills]) > 0.50)
				    {
				        event_leader[kdr_lead] = i;
				    }
				}
	            else
					if(floatdiv(Event_KDR[i][e_kills], Event_KDR[i][e_deaths]) > floatdiv(Event_KDR[event_leader[kdr_lead]][e_kills],Event_KDR[event_leader[kdr_lead]][e_deaths]))
					    event_leader[kdr_lead] = i;
			}

			if(Event_KDR[i][e_maxspree] > Event_TopSpree[p_spree] || Event_KDR[i][e_spree] > Event_TopSpree[p_spree])
				    event_leader[spree_lead] = i;
			if(Event_KDR[i][e_spree] > 5)
			    Event_KDR[i][e_totspree]++;
            if(event_leader[totspree_lead] == -1)
				event_leader[totspree_lead] = i;
            else
				if(Event_KDR[i][e_totspree] > Event_KDR[event_leader[totspree_lead]][e_totspree])
				    event_leader[totspree_lead] = i;
			format(leadermessage, sizeof(leadermessage), "[EVENT]: Kills: %i | Deaths: %i | KDR: %.3f | MAX Spree: %i | No. Of Sprees: %i", Event_KDR[i][e_kills], Event_KDR[i][e_deaths], (Event_KDR[i][e_deaths]!=0)?(floatdiv(Event_KDR[i][e_kills], Event_KDR[i][e_deaths])):(1.0), Event_KDR[i][e_maxspree], Event_KDR[i][e_totspree]);
			SendClientMessage(i, COLOR_GREEN, leadermessage);
		}
	}
	dialogmessage = "Lead Type\tLeaderName\tScore\n";
	if(event_leader[kill_lead] != -1)
	    format(dialogmessage, sizeof(dialogmessage), "%sKills\t%s\t%i\n", dialogmessage, PlayerName(event_leader[kill_lead]), Event_KDR[event_leader[kill_lead]][e_kills]);
	else
	    format(dialogmessage, sizeof(dialogmessage), "%sKills\tNONE\t0\n", dialogmessage);

	if(event_leader[death_lead] != -1)
	    format(dialogmessage, sizeof(dialogmessage), "%sDeaths\t%s\t%i\n", dialogmessage, PlayerName(event_leader[death_lead]), Event_KDR[event_leader[death_lead]][e_deaths]);
	else
	    format(dialogmessage, sizeof(dialogmessage), "%sDeaths\tNONE\t0\n", dialogmessage);

	if(event_leader[kdr_lead] != -1)
	    format(dialogmessage, sizeof(dialogmessage), "%sKDR\t%s\t%.3f\n", dialogmessage, PlayerName(event_leader[kdr_lead]), (Event_KDR[event_leader[kdr_lead]][e_deaths] != 0) ? (floatdiv(Event_KDR[event_leader[kdr_lead]][e_kills], Event_KDR[event_leader[kdr_lead]][e_deaths])):(floatmul(Event_KDR[event_leader[kdr_lead]][e_kills], 1.0)));
	else
	    format(dialogmessage, sizeof(dialogmessage), "%sKDR\tNONE\t0.0\n", dialogmessage);

	if(event_leader[spree_lead] != -1)
	    format(dialogmessage, sizeof(dialogmessage), "%sSpree\t%s\t%i\n", dialogmessage, PlayerName(event_leader[spree_lead]), Event_KDR[event_leader[spree_lead]][e_maxspree]);
	else
	    format(dialogmessage, sizeof(dialogmessage), "%sSpree\t%s\t%i\n", dialogmessage, Event_TopSpree[p_name], Event_TopSpree[p_spree]);

	if(event_leader[totspree_lead] != -1)
	    format(dialogmessage, sizeof(dialogmessage), "%sNo.Of Spree\t%s\t%i\n", dialogmessage,  PlayerName(event_leader[totspree_lead]), Event_KDR[event_leader[totspree_lead]][e_totspree]);
	else
	    format(dialogmessage, sizeof(dialogmessage), "%No.Of Spree\tNONE\t0\n", dialogmessage);
	    
	e_LeaderBoard = true;
	SendClientMessageToAll(COLOR_GREEN, "[EVENT]: Leaderboard is now ready. Use /showeventleaders to view it");
}


CMD:showeventleaders(playerid, params[])
{
	if(e_LeaderBoard == true)
	{
	    ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_TABLIST_HEADERS, "Event Leaderboard", dialogmessage, "Close", "");
	}
	else
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Event leaderboard is not yet ready. Its made after event.");
	}
	return 1;
}
