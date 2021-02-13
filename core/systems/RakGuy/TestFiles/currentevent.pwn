
//Added to event.pwn

#include <YSI\y_hooks>

hook OnPlayerConnect(playerid)
{
	if(Event_InProgress > -1 && Event_InProgress < 2)
	{
		cmd_currentevent(playerid);
	}
	return 1;
}

new Event_Status_Name[2][9] = {"Joinable", "Started"};

CMD:currentevent(playerid)
{
	new temp_msg[128];
	if(Event_InProgress > -1 && Event_InProgress < 2)
	{
		format(temp_msg, sizeof(temp_msg), "[NOTICE]: Currently running event is: %s - Status: %s", event_IRC_Array[EVENT_ID][eventName], Event_Status_Name[Event_InProgress]);
		SendClientMessage(playerid, COLOR_NOTICE, temp_msg);
	}
	else
	{
		SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: There is no event running.");
	}
	return 1;
}
