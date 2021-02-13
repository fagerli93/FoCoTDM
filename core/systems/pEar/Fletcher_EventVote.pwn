#include <YSI\y_hooks>
#include <YSI\y_timers>

/*
	Event overview: (Remember that it starts with 0, so maddogs = 0 in listitem.)
	Mad Dogg's Mansion\nBig Smoke\nMinigun Wars\nBrawl\nHydra Wars\nGun Game\nJefferson Motel TDM\nArea 51 TDM\nArmy vs. Terrorists\nNavy Seals vs. Terrorists\nCompound Attack\nOil Rig Terrorists\nTeam Drug Run\nMonster Sumo\nBanger Sumo\nSandKing Sumo\nSandKing Sumo (Reloaded)\n Destruction Derby\nPursuit\nPlane-Survival\nConstruction-TDM\nHighSpeed Pursuit\nLabyrinth of Doom\nHotLava\nDeathRace\nDomination
*/

new e_vote[MAX_PLAYERS];
#define DIALOG_EVENTVOTE 345 // Dont change this :)
#define EVENTTIMER_INTERVAL 30 // 30 seconds. This is how long the vote will be up for before starting the event.
#define EVENTLIST "Mad Dogg's Mansion\nBig Smoke\nMinigun Wars\nBrawl\nHydra Wars\nGun Game\nJefferson Motel TDM\nArea 51 TDM\nArmy vs. Terrorists\nNavy Seals vs. Terrorists\nCompound Attack\nOil Rig Terrorists\nTeam Drug Run\nMonster Sumo\nBanger Sumo\nSandKing Sumo\nSandKing Sumo (Reloaded)\n Destruction Derby\nPursuit\nPlane-Survival\nConstruction-TDM\nHighSpeed Pursuit\nLabyrinth of Doom\nHotLava\nDeathRace\nDomination"

// For the admin
CMD:starteventvote(playerid, params[])
{
	defer EventVoteTimer();
	return 1;
}

// For each player
CMD:eventvote(playerid, params[])
{
	// Do error checking etc.
	ShowPlayerDialog(playerid, DIALOG_EVENTVOTE, DIALOG_STYLE_LIST, "Event vote", EVENTLIST, "Vote", "Cancel");
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	e_vote[playerid] = 0;
	return 1;
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	print("ODR_F_E");
	if(dialogid == DIALOG_EVENTVOTE)
	{
		if(response)
		{
			// Not allowed to vote for gungame as its currently disabled.
			if(listitem == 5)
			{
				// Show the initial dialog again.
				ShowPlayerDialog(playerid, DIALOG_EVENTVOTE, DIALOG_STYLE_LIST, "Event vote", EVENTLIST, "Vote", "Cancel");
				// Send an error message. This takes in playerid and then the message to send
				SendErrorMessage();
				return 1;
			}
			// The player has voted for the event with ID listitem. 
			e_vote[playerid] = listitem;
			// The player voted for something, send him a message about it.
			SendClientMessage();
			return 1;
		}	
		else
		{
			return 1;
		}
	}
	return 1;
}

timer EventVoteTimer[EVENTTIMER_INTERVAL*1000]()
{
	// admin has to be set to the admin that started the vote or an online admin. Make sure this is set!
	new event, admin;
	foreach(Player, i)
	{
		// Collect the votes. i = playerid
	}
	// Error check if need be.
	EventStart(event, admin);
	return 1;
}

forward EventStart(event, playerid);
public EventStart(event, playerid)
{
	SendClientMessage(playerid, COLOR_SYNTAX, "Started some event..");
	return 1;
}
