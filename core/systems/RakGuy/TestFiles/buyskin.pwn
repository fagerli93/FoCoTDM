#include <YSI\y_hooks>

#define	MAX_BUYABLE_SKINS	5
#define	BUYSKIN_AMOUNT		100000

new PlayerBoughtSkins[MAX_PLAYERS][MAX_BUYABLE_SKINS];
new CurrentSelectionSkin[MAX_PLAYERS];

stock ClearPlayerBoughtSkins(playerid)
{
	for(new i = 0; i < MAX_BUYABLE_SKINS; i++)
	{
		PlayerBoughtSkins[playerid][i] = -1;
	}
	CurrentSelectionSkin[playerid] = -1;
	return 1;
}

hook OnPlayerConnect(playerid)
{
	ClearPlayerBoughtSkins(playerid);
	return 1;
}


hook OnPlayerDisconnect(playerid)
{
	ClearPlayerBoughtSkins(playerid);
	return 1;
}

CMD:buyskin(playerid, params[])
{
	if(ShopSys != 0)
 	{
  		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: The shop system is currently disabled.");
    	return 1;
     }

	if(IsPlayerInRangeOfPoint(playerid, 10.0, 315.6105,-143.2389,999.6016))
 	{
		if(GetPlayerMoney(playerid) < BUYSKIN_AMOUNT && isVIP(playerid) == 0)
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not have enough money to buy this skin.");
		for(new i = 0; i < MAX_BUYABLE_SKINS; i++)
		{
			if(PlayerBoughtSkins[playerid][i] == -1)
			{
				ShowPlayerDialog(playerid, DIALOG_BUYSKIN, DIALOG_STYLE_INPUT, "Skin Purchase", "{FFFFFF}Please type the {40BB00}ID {FFFFFF}of skin you want to buy.\n{00FF00}Reference: {FF0000}wiki.sa-mp.com/wiki/Skins", "Continue", "Cancel");
				return 1;
			}
		}
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have bought maximum amount of skins. /dropskin [SLOT] to free some space.");
	}
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_BUYSKIN)
	{
		if(!response)
		{
			if(CurrentSelectionSkin[playerid] != -1)
				SetPlayerSkin(playerid, GetPVarInt(playerid, "BUYSKIN_TEMPSTORE"));
			CurrentSelectionSkin[playerid] = -1;
			return SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: You have successfully closed the /buyskin dialog-box.");
		}
		else
		{
			if(CurrentSelectionSkin[playerid] == -1)
			{
				if(sscanf(inputtext, "d", CurrentSelectionSkin[playerid]))
				{
					CurrentSelectionSkin[playerid] = -1;
					ShowPlayerDialog(playerid, DIALOG_BUYSKIN, DIALOG_STYLE_INPUT, "Skin Purchase", "{FFFFFF}Please type the {40BB00}ID {FFFFFF}of skin you want to buy.\n{00FF00}Reference: {FF0000}wiki.sa-mp.com/wiki/Skins\n{FF0000}*Player enter a SkinID.", "Continue", "Cancel");
					return 1;
				}
				if(CurrentSelectionSkin[playerid] < 0 || CurrentSelectionSkin[playerid] > 311)
				{
					CurrentSelectionSkin[playerid] = -1;
					ShowPlayerDialog(playerid, DIALOG_BUYSKIN, DIALOG_STYLE_INPUT, "Skin Purchase", "{FFFFFF}Please type the {40BB00}ID {FFFFFF}of skin you want to buy.\n{00FF00}Reference: {FF0000}wiki.sa-mp.com/wiki/Skins\n{FF0000}*Player enter a valid SkinID.", "Continue", "Cancel");
					return 1;
				}
				if(RestrictedSkin[CurrentSelectionSkin[playerid]] == true)
				{
					CurrentSelectionSkin[playerid] = -1;
					ShowPlayerDialog(playerid, DIALOG_BUYSKIN, DIALOG_STYLE_INPUT, "Skin Purchase", "{FFFFFF}Please type the {40BB00}ID {FFFFFF}of skin you want to buy.\n{00FF00}Reference: {FF0000}wiki.sa-mp.com/wiki/Skins\n{FF0000}*This SkinID is not allowed. Try again!!.", "Continue", "Cancel");
					return 1;					
				}
				else
				{
					SetPVarInt(playerid, "BUYSKIN_TEMPSTORE", GetPlayerSkin(playerid));
					SetPlayerSkin(playerid, CurrentSelectionSkin[playerid]);
					ShowPlayerDialog(playerid, DIALOG_BUYSKIN, DIALOG_STYLE_MSGBOX, "Skin Purchase", "{FFFFFF}Are you sure you want to buy this skin?", "Continue", "No!!!!!!!");
					return 1;						
				}
			}
			else
			{
				if(GetPlayerMoney(playerid) < BUYSKIN_AMOUNT && isVIP(playerid) == 0)
					return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not have enough money to buy this skin.");
				for(new i = 0; i < MAX_BUYABLE_SKINS; i++)
				{
					if(PlayerBoughtSkins[playerid][i] == -1)
					{
						PlayerBoughtSkins[playerid][i] = CurrentSelectionSkin[playerid];
						GivePlayerMoney(playerid, -1 * BUYSKIN_AMOUNT);
						SetPVarInt(playerid, "Resetskin", 1);
						SetPVarInt(playerid, "TempSkin", CurrentSelectionSkin[playerid]);
						CurrentSelectionSkin[playerid] = -1;
						return SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You have successfully bought the skin!!!");
					}
				}
				return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not have any Free-Slot to buy anymore skins. /dropskin [SLOT] to free some space.");
			}
		}
	}
	if(dialogid == DIALOG_DROPSKIN)
	{
		if(!response)
		{
            CurrentSelectionSkin[playerid] = -1;
            return SendClientMessage(playerid, COLOR_WARNING, "[NOTICE]: You have successfully closed the /dropskin dialog-box.");
		}
		else
		{
			if(CurrentSelectionSkin[playerid] == -1)
			{
				if(sscanf(inputtext, "d", CurrentSelectionSkin[playerid]))
				{
					CurrentSelectionSkin[playerid] = -1;
					new msg[128]="Which skin-slot do you want to drop?\n";
					for(new i = 0; i < MAX_BUYABLE_SKINS; i++)
					{
						format(msg, sizeof(msg), "%s%i. %i\n", msg, i, PlayerBoughtSkins[playerid][i]);
					}
					format(msg, sizeof(msg), "%s{FF0000}*Use /switchskin to check Slots\n{FF0000}*Please choose a SlotID.", msg);
					ShowPlayerDialog(playerid, DIALOG_DROPSKIN, DIALOG_STYLE_INPUT, "Skin Purchase", msg, "Drop!", "Cancel");
					return 1;
				}
				if(CurrentSelectionSkin[playerid] < 1 || CurrentSelectionSkin[playerid] > 5)
				{
					CurrentSelectionSkin[playerid] = -1;
					new msg[128]="Which skin-slot do you want to drop?\n";
					for(new i = 0; i < MAX_BUYABLE_SKINS; i++)
					{
						format(msg, sizeof(msg), "%s%i. %i\n", msg, i, PlayerBoughtSkins[playerid][i]);
					}
					format(msg, sizeof(msg), "%s{FF0000}*Use /switchskin to check Slots\n{FF0000}*SlotID must be between 1 and 5.", msg);
					ShowPlayerDialog(playerid, DIALOG_DROPSKIN, DIALOG_STYLE_INPUT, "Skin Purchase", msg, "Drop!", "Cancel");
					return 1;
				}
				CurrentSelectionSkin[playerid]--;
				if(PlayerBoughtSkins[playerid][CurrentSelectionSkin[playerid]] == -1)
				{
					CurrentSelectionSkin[playerid] = -1;
					new msg[128]="Which skin-slot do you want to drop?\n";
					for(new i = 0; i < MAX_BUYABLE_SKINS; i++)
					{
						format(msg, sizeof(msg), "%s%i. %i\n", msg, i, PlayerBoughtSkins[playerid][i]);
					}
					format(msg, sizeof(msg), "%s{FF0000}*Use /switchskin to check Slots\n{FF0000}*You don't have any skin in that slot. Use brain please!.", msg);
					ShowPlayerDialog(playerid, DIALOG_DROPSKIN, DIALOG_STYLE_INPUT, "Skin Purchase", msg, "Drop!", "Cancel");
				}
				else
				{
					new msg[128];
					format(msg, sizeof(msg), "{FFFFFF}Are you sure you want to delete SkinID{FF0000}%i{FFFFFF}?", PlayerBoughtSkins[playerid][CurrentSelectionSkin[playerid]]);
					ShowPlayerDialog(playerid, DIALOG_DROPSKIN, DIALOG_STYLE_MSGBOX, "Skin Drop", msg, "Drop!", "Cancel");
					return 1;
				}
			}
			else
			{
			    PlayerBoughtSkins[playerid][CurrentSelectionSkin[playerid]] = -1;
			    CurrentSelectionSkin[playerid] = -1;
				OrderSlots(playerid);
				return SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You have successfully dropped the skin!!!");
			}
		}
	}
	return 0;
}

stock OrderSlots(playerid)
{
	new OpenSlot = -1, OpenSlots;
	for(new i = 0; i < MAX_BUYABLE_SKINS; i++)
	{
		if(PlayerBoughtSkins[playerid][i] == -1)
		{
		    if(OpenSlot == -1)
		    {
		        OpenSlot = i;
		        OpenSlots++;
		    }
		}
		else
		{
		    if(OpenSlot != -1)
		    {
		        PlayerBoughtSkins[playerid][OpenSlot] = PlayerBoughtSkins[playerid][i];
                OpenSlot = i;
                PlayerBoughtSkins[playerid][i] = -1;
		    }
		}
	}
	if(OpenSlots == MAX_BUYABLE_SKINS)
	    return 0;
	return 1;
}

CMD:dropskin(playerid, params[])
{
	if(!OrderSlots(playerid))
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You don't own any skin.");
	new msg[128]="Which skin-slot do you want to drop?\n";
	for(new i = 0; i < MAX_BUYABLE_SKINS; i++)
	{
	    if(PlayerBoughtSkins[playerid][i] != -1)
			format(msg, sizeof(msg), "%s%i. %i\n", msg, i+1, PlayerBoughtSkins[playerid][i]);
	}
	format(msg, sizeof(msg), "%s{FF0000}*Use /switchskin to check Slots.", msg);
	ShowPlayerDialog(playerid, DIALOG_DROPSKIN, DIALOG_STYLE_INPUT, "Skin Purchase", msg, "Drop!", "Cancel");
	return 1;
}

CMD:switchskin(playerid, params[])
{
	if(!OrderSlots(playerid))
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You don't own any skin.");
	new slotid;
	if(sscanf(params, "d", slotid))
	    return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /switchskin (1 - 5)");
	else
	{
	    if(slotid < 1 || slotid > 5)
	        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: SlotID must be between 1 and 5");
		slotid = slotid - 1;
		if(PlayerBoughtSkins[playerid][slotid] == -1)
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have no skin in that slot.");
        SetPlayerSkin(playerid, PlayerBoughtSkins[playerid][slotid]);
		SetPVarInt(playerid, "Resetskin", 1);
		SetPVarInt(playerid, "TempSkin", PlayerBoughtSkins[playerid][slotid]);
		SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You have successfully switched you skin.");
  	}
	return 1;
}
