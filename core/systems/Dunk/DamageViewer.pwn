#include <YSI\y_hooks>

#define DV_TIMER_TIME 3000
#define ACMD_TOGDMG 2
#define ACMD_DAMAGEVIEW 3

new PlayerText:DamageTextdraws[MAX_PLAYERS][2];
new bool:HitsEnabled[MAX_PLAYERS];

new Timer:DamageTimer[MAX_PLAYERS][2];

new bool:HitCommand = true;

stock PrepareDamageTextDraws(playerid)
{
    DamageTextdraws[playerid][0] = CreatePlayerTextDraw(playerid, 143.000000, 370.000000, "~g~+46.6 damage to Player (0)");
    PlayerTextDrawBackgroundColor(playerid, DamageTextdraws[playerid][0], 255);
    PlayerTextDrawFont(playerid, DamageTextdraws[playerid][0], 1);
    PlayerTextDrawLetterSize(playerid, DamageTextdraws[playerid][0], 0.240000, 1.000000);
    PlayerTextDrawColor(playerid, DamageTextdraws[playerid][0], -1);
    PlayerTextDrawSetOutline(playerid, DamageTextdraws[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, DamageTextdraws[playerid][0], 1);

    DamageTextdraws[playerid][1] = CreatePlayerTextDraw(playerid, 144.000000, 381.000000, "~r~-46.6 damage from Player (0)");
    PlayerTextDrawBackgroundColor(playerid, DamageTextdraws[playerid][1], 255);
    PlayerTextDrawFont(playerid, DamageTextdraws[playerid][1], 1);
    PlayerTextDrawLetterSize(playerid, DamageTextdraws[playerid][1], 0.240000, 1.000000);
    PlayerTextDrawColor(playerid, DamageTextdraws[playerid][1], -1);
    PlayerTextDrawSetOutline(playerid, DamageTextdraws[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, DamageTextdraws[playerid][1], 1);
}

timer HideDamageTextDraws[DV_TIMER_TIME](playerid, HIDEID)
{
    PlayerTextDrawHide(playerid, DamageTextdraws[playerid][HIDEID]); //DYNAMIC
    DamageTimer[playerid][HIDEID] = Timer:-1;
}

hook OnPlayerConnect(playerid)
{
    HitsEnabled[playerid] = true;

    PrepareDamageTextDraws(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid)
{
	PlayerTextDrawDestroy(playerid, DamageTextdraws[playerid][0]);
    PlayerTextDrawDestroy(playerid, DamageTextdraws[playerid][1]);
	return 1;
}

//============[HIT SYSTEM]============

CMD:toggledamages(playerid, params[])
{
    if(!HitCommand)
    {
        return SendClientMessage(playerid, COLOR_GREY, "[INFO]: The hit notification system is currently disabled.");
    }
    else if(!HitsEnabled[playerid])
    {
        SendClientMessage(playerid, COLOR_GREY, "[INFO]: You have enabled hit notifications.");
        HitsEnabled[playerid] = true;
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "[INFO]: You have disabled hit notifications.");
        HitsEnabled[playerid] = false;
    }
    return 1;
}

CMD:atoggledamages(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_TOGDMG))
	{
	    new targetid, dv_string[128];

	    //ADD ADMIN LEVEL RESTRICTION HERE LATER!!!!!!

	    if(sscanf(params, "u", targetid))
	        return SendClientMessage(playerid, COLOR_GREY, "[USAGE]: /atogglehits [PlayerID/Name]");
		if(targetid == INVALID_PLAYER_ID)
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid PlayerID/Name");
	    if(!IsPlayerConnected(targetid))
	        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Playerid is not a valid playerid.");
	    if(!HitsEnabled[targetid])
	    {
	        format(dv_string, sizeof(dv_string), "AdmCmd(%i): %s %s has enabled hit notifications for %s(%d)", ACMD_DAMAGEVIEW,  GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
	        SendAdminMessage(ACMD_TOGDMG, dv_string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, dv_string);
	        HitsEnabled[targetid] = true;
			format(dv_string, sizeof(dv_string), "[NOTICE]: %s %s has enabled the hit notification for you.", GetPlayerStatus(playerid), PlayerName(playerid));
            SendClientMessage(targetid, COLOR_NOTICE, dv_string);
	    }
	    else
	    {
	        format(dv_string, sizeof(dv_string), "AdmCmd(%i): %s %s has disabled hit notifications for %s(%d)", ACMD_DAMAGEVIEW,  GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid), targetid);
	        SendAdminMessage(ACMD_TOGDMG, dv_string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, dv_string);
	    	AdminLog(dv_string);
	        HitsEnabled[playerid] = false;
			format(dv_string, sizeof(dv_string), "[NOTICE]: %s %s has disabled the hit notification for you.", GetPlayerStatus(playerid), PlayerName(playerid));
            SendClientMessage(targetid, COLOR_NOTICE, dv_string);
	    }
	}
    return 1;
}

CMD:toggledamagesystem(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_DAMAGEVIEW))
    {

        new dv_string[128];

        if(!HitCommand)
        {
            format(dv_string, sizeof(dv_string), "[NOTICE]: %s %s has enabled the hit notification system.", GetPlayerStatus(playerid), PlayerName(playerid));
            SendClientMessageToAll(COLOR_DARKRED, dv_string);
            format(dv_string, sizeof(dv_string), "AdmCmd(%i): %s %s has enabled the hit notification system.", ACMD_DAMAGEVIEW,  GetPlayerStatus(playerid), PlayerName(playerid));
            SendClientMessageToAll(COLOR_DARKRED, dv_string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, dv_string);
	    	AdminLog(dv_string);
            HitCommand = true;
        }
        else
        {
            format(dv_string, sizeof(dv_string), "[NOTICE]: %s %s has disabled the hit notification system.", GetPlayerStatus(playerid), PlayerName(playerid));
            SendClientMessageToAll(COLOR_DARKRED, dv_string);
            format(dv_string, sizeof(dv_string), "AdmCmd(%i): %s %s has disabled the hit notification system.", ACMD_DAMAGEVIEW, GetPlayerStatus(playerid), PlayerName(playerid));
            SendClientMessageToAll(COLOR_DARKRED, dv_string);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, dv_string);
	    	AdminLog(dv_string);
            HitCommand = false;
        }
    }
    return 1;
}

hook OnPlayerSpawn(playerid)
{
 	HideDamageTextDraws(playerid, 0);
    HideDamageTextDraws(playerid, 1);
    return 1;
}

forward ShowTextDrawDamage(playerid, damagedid, Float:amount);

public ShowTextDrawDamage(playerid, damagedid, Float:amount)
{
	if(HitCommand == true)
	{
	    new dv_string[64];

	    if(HitsEnabled[playerid])
	    {
	        format(dv_string, sizeof(dv_string), "~g~+%.1f damage to %s (%i)", amount, PlayerName(damagedid), damagedid);
	        PlayerTextDrawSetString(playerid, DamageTextdraws[playerid][0], dv_string);

	        PlayerTextDrawShow(playerid, DamageTextdraws[playerid][0]);
	       	if(DamageTimer[playerid][0] != Timer:-1)
	        {
	        	stop DamageTimer[playerid][0];
	            DamageTimer[playerid][0] = Timer:-1;
			}
			DamageTimer[playerid][0] = defer HideDamageTextDraws(playerid, 0);
	    }
	    if(damagedid != INVALID_PLAYER_ID && IsPlayerConnected(damagedid))
	    {
		    if(HitsEnabled[damagedid])
		    {
			   	format(dv_string, sizeof(dv_string), "~r~-%.1f damage from %s (%i)", amount, PlayerName(playerid), playerid);
			    PlayerTextDrawSetString(damagedid, DamageTextdraws[damagedid][1], dv_string);

		        PlayerTextDrawShow(damagedid, DamageTextdraws[damagedid][1]);
		        if(DamageTimer[playerid][1] != Timer:-1)
				{
		        	stop DamageTimer[playerid][1];
		            DamageTimer[playerid][1] = Timer:-1;
				}
				DamageTimer[playerid][1] = defer HideDamageTextDraws(damagedid, 1);
			}
		}
	}
    return true;
}
