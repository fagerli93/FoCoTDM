#include <YSI\y_hooks>

#define TEN 10

enum
{
	givedamage=0,
	takedamage=1
};

new PlayerBeingWatched[MAX_PLAYERS][2][TEN]; //0 = Given Damage || 1 = Taken Damage
new PlayerWatching[MAX_PLAYERS][2][5]; //0 = Given Damage || 1 = Taken Damage
new bool:IsWatchTog[MAX_PLAYERS][2];
new DML_MSG[200];
new BodyPart[TEN][TEN]=
{
	"BODY",
	"BODY",
	"BODY",
	"TORSO",
	"CHEST",
	"LEFT_ARM",
	"RIGHT_ARM",
	"LEFT_LEG",
	"RIGHT_LEG",
	"HEAD"
};

hook OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	if(IsWatchTog[playerid][0] == true)
	{
		format(DML_MSG, sizeof(DML_MSG), "{E0E377}[Guardian]: %s(%i) has dealt %.2f damage to %s(%i) using %s on his %s", PlayerName(playerid), playerid, amount, PlayerName(damagedid), damagedid, (weaponid>=0 && weaponid<55)?(DeathReasons[weaponid]):("Unknown_Weapon"), (bodypart>=0&&bodypart<9)?(BodyPart[bodypart]):("Body"));
		SendAdminMessageToArray(PlayerBeingWatched[playerid][givedamage], TEN, DML_MSG, 1);
	}
   	return 1;
}


hook OnGameModeInit()
{
	for(new i=0; i<MAX_PLAYERS; i++)
	{
	    for(new j=0; j<TEN; j++)
	    {
			PlayerBeingWatched[i][givedamage][j] = -1;
			PlayerBeingWatched[i][takedamage][j] = -1;
	        if(j<5)
	        {
	            PlayerWatching[i][givedamage][j]=-1;
	            PlayerWatching[i][takedamage][j]=-1;
	        }
	    }
        IsWatchTog[i][givedamage] = false;
        IsWatchTog[i][takedamage] = false;
	}
	return 1;
}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	printf("%i, %i, %.2f, %i, %i", playerid, issuerid, amount, weaponid, bodypart);
	if(IsWatchTog[playerid][1] == true)
	{
		new TempMSG[80];
		if(issuerid == INVALID_PLAYER_ID)
		{
			format(TempMSG, sizeof(TempMSG), "due to %s", (weaponid>=0 && weaponid<55)?(DeathReasons[weaponid]):("Unknown_Weapon"));
		}
		else
		{
			format(TempMSG, sizeof(TempMSG), "from %s(%i) using %s", PlayerName(issuerid), issuerid, (weaponid>=0 && weaponid<55)?(DeathReasons[weaponid]):("Unknown_Weapon"));
		}
		format(DML_MSG, sizeof(DML_MSG), "{B4B5B7}[Guardian]: %s(%i) has taken %.2f damage %s on his %s", PlayerName(playerid), playerid, amount, TempMSG, (bodypart>=0&&bodypart<=9)?(BodyPart[bodypart]):("Body"));
		SendAdminMessageToArray(PlayerBeingWatched[playerid][takedamage], TEN, DML_MSG, 1);
	}
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	format(DML_MSG, sizeof(DML_MSG), "[Guardian]: %s has logged during Given Damage Watch. Logging disabled.", PlayerName(playerid));
	if(!IsArrayEmpty(PlayerBeingWatched[playerid][givedamage], 10, -1))
	{
		SendAdminMessageToArray(PlayerBeingWatched[playerid][givedamage], TEN, DML_MSG, 1);
	}
	format(DML_MSG, sizeof(DML_MSG), "[Guardian]: %s has logged during Taken Damage Watch. Logging disabled.", PlayerName(playerid));
	if(!IsArrayEmpty(PlayerBeingWatched[playerid][givedamage], 10, -1))
	{
		SendAdminMessageToArray(PlayerBeingWatched[playerid][takedamage], TEN, DML_MSG, 1);
	}
	new tempid;
	if(IsWatchTog[playerid][0] == true)
	{
		for(new i=0; i<TEN; i++)
		{
		    if(PlayerBeingWatched[playerid][givedamage][i] != -1)
		    {
	           	tempid = PlayerBeingWatched[playerid][givedamage][i];
				PlayerBeingWatched[playerid][givedamage][i]=-1;
				new SlotID = FindValueInArray(playerid, PlayerWatching[tempid][givedamage][i], 5);
				if(SlotID != -1)
				{
					PlayerWatching[tempid][givedamage][SlotID] = -1;
				}
			}
		}
	}
	if(IsWatchTog[playerid][1] == true)
	{
		for(new i=0; i<TEN; i++)
		{
		    if(PlayerBeingWatched[playerid][takedamage][i] != -1)
		    {
	           	tempid = PlayerBeingWatched[playerid][takedamage][i];
				PlayerBeingWatched[playerid][takedamage][i]=-1;
				new SlotID = FindValueInArray(playerid, PlayerWatching[tempid][takedamage][i], 5);
				if(SlotID != -1)
				{
					PlayerWatching[tempid][takedamage][SlotID] = -1;
				}
			}
		}
	}
	for(new i=0; i<5; i++)
	{
	    if(!IsArrayEmpty(PlayerWatching[playerid][givedamage][i], 5, -1) && !IsArrayEmpty(PlayerWatching[playerid][takedamage][i], 5, -1))
	    {
	        break;
	    }
		if(IsArrayEmpty(PlayerWatching[playerid][givedamage][i], 5, -1))
		{
			if(PlayerWatching[playerid][givedamage][i] != -1)
			{
				tempid = PlayerWatching[playerid][givedamage][i];
				format(DML_MSG, sizeof(DML_MSG), "[Guardian]: %s has stopped watching %s(%i)'s given damage.", PlayerName(playerid), PlayerName(tempid), tempid);
				PlayerWatching[playerid][givedamage][i]=-1;
				if(!IsArrayEmpty(PlayerBeingWatched[tempid][givedamage], 10, -1))
				{
					SendAdminMessageToArray(PlayerBeingWatched[tempid][givedamage], TEN, DML_MSG, 1);
				}
				else
				{
					IsWatchTog[tempid][givedamage] = false;
				}
			}
		}
        if(IsArrayEmpty(PlayerWatching[playerid][takedamage][i], 5, -1))
        {
        
			if(PlayerWatching[playerid][takedamage][i] != -1)
			{
				tempid = PlayerWatching[playerid][takedamage][i];
				format(DML_MSG, sizeof(DML_MSG), "[Guardian]: %s has stopped watching %s(%i)'s taken damage.", PlayerName(playerid), PlayerName(tempid), tempid);
				PlayerWatching[playerid][takedamage][i]=-1;
				if(!IsArrayEmpty(PlayerBeingWatched[tempid][takedamage], 10, -1))
				{
					SendAdminMessageToArray(PlayerBeingWatched[tempid][takedamage], TEN, DML_MSG, 1);
				}
				else
				{
					IsWatchTog[tempid][takedamage] = false;
				}
			}
		}
	}
	return 1;
}


hook OnPlayerConnect(playerid)
{
	for(new i=0; i<TEN; i++)
	{

		if(i < 5)
		{
			new tempid;
			if(PlayerWatching[playerid][givedamage][i] != -1)
			{
				tempid = PlayerWatching[playerid][givedamage][i];
				if(IsArrayEmpty(PlayerBeingWatched[tempid][givedamage], 10, -1))
				{
					IsWatchTog[tempid][givedamage] = false;
				}
			}
			if(PlayerWatching[playerid][takedamage][i] != -1)
			{
				tempid = PlayerWatching[playerid][takedamage][i];
				if(IsArrayEmpty(PlayerBeingWatched[tempid][takedamage], 10, -1))
				{
					IsWatchTog[tempid][takedamage] = false;
				}
			}
		}
	}
	return 1;
}



CMD:givendamage(playerid, params[])
{
	new targetid;
	if(sscanf(params, "u", targetid))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /givendamage [PlayerID/Part_of_PlayerName]");
	}
	if(targetid == INVALID_PLAYER_ID)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid playerID");
	}
	if(!IsPlayerConnected(targetid))
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player is not connected");
	}
	new CurrSlot = FindValueInArray(playerid, PlayerBeingWatched[targetid][givedamage], TEN);
	new CurrPSlot = FindValueInArray(targetid, PlayerWatching[playerid][givedamage], 5);
	if(CurrSlot == -1 && CurrPSlot == -1)
	{
		if(IsArrayEmpty(PlayerBeingWatched[targetid][givedamage], TEN, -1) == 9)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: WatchLog slot for this player is full. Use /whoiswatching [playerid][Log_Type] to know who.");
		}
		if(IsArrayEmpty(PlayerWatching[playerid][givedamage], 5, -1) == 4)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your Watchlog slot is full. Use /whoiswatching [playerid][Log_Type] to know who.");
		}
		if(IsArrayEmpty(PlayerBeingWatched[targetid][givedamage], TEN, -1) == 0)
		{
			format(DML_MSG, sizeof(DML_MSG), "[Guardian]: GivenDamage Watch for %s(%i) has been enabled. Use /givendamage [ID/PlayerName]", PlayerName(targetid), targetid);
			SendAdminMessage(1, DML_MSG);
			IsWatchTog[targetid][givedamage] = true;
		}
		new SlotID = GetEmptySlot(PlayerBeingWatched[targetid][givedamage], TEN, -1);
		new PSlotID = GetEmptySlot(PlayerWatching[playerid][givedamage], 5, -1);
		if(SlotID != -1 && PSlotID != -1)
		{
			format(DML_MSG, sizeof(DML_MSG), "[Guardian]: %s %s has started watching %s's given damage.", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
			SendAdminMessageToArray(PlayerWatching[playerid][givedamage], TEN, DML_MSG, 1);
			PlayerBeingWatched[targetid][givedamage][SlotID]=playerid;
			PlayerWatching[playerid][givedamage][PSlotID]=targetid;
			format(DML_MSG, sizeof(DML_MSG), "[NOTICE]: You are now watching %s's given damage.", PlayerName(targetid));
			SendClientMessage(playerid, COLOR_NOTICE, DML_MSG);
		}
	}
	else
	{
		format(DML_MSG, sizeof(DML_MSG), "[NOTICE]: You have stopped watching %s's given damage.", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_NOTICE, DML_MSG);
		PlayerBeingWatched[targetid][givedamage][CurrSlot]=-1;
		PlayerWatching[playerid][givedamage][CurrPSlot]=-1;
		format(DML_MSG, sizeof(DML_MSG), "[NOTICE]: %s %s has stopped watching %s's given damage.", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
        SendAdminMessageToArray(PlayerWatching[playerid][givedamage], TEN, DML_MSG, 1);
		if(IsArrayEmpty(PlayerBeingWatched[targetid][givedamage], TEN, -1) == 0)
		{
			IsWatchTog[targetid][givedamage] = false;
			format(DML_MSG, sizeof(DML_MSG), "[Guardian]: GivenDamage Watch for %s(%i) is disabled.", PlayerName(targetid), targetid);
			SendAdminMessage(1, DML_MSG);
		}
	}
	return 1;
}


CMD:takendamage(playerid, params[])
{
	new targetid;
	if(sscanf(params, "u", targetid))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /takendamage [PlayerID/Part_of_PlayerName]");
	}
	if(targetid == INVALID_PLAYER_ID)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Invalid playerID");
	}
	if(!IsPlayerConnected(targetid))
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player is not connected");
	}
	new CurrSlot = FindValueInArray(playerid, PlayerBeingWatched[targetid][takedamage], TEN);
	new CurrPSlot = FindValueInArray(targetid, PlayerWatching[playerid][takedamage], 5);
	if(CurrSlot == -1 && CurrPSlot == -1)
	{
		if(IsArrayEmpty(PlayerBeingWatched[targetid][takedamage], TEN, -1) == 9)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: WatchLog slot for this player is full. Use /whoiswatching [playerid][Log_Type] to know who.");
		}
		if(IsArrayEmpty(PlayerWatching[playerid][takedamage], 5, -1) == 4)
		{
			return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Your Watchlog slot is full. Use /whoiswatching [playerid][Log_Type] to know who.");
		}
		if(IsArrayEmpty(PlayerBeingWatched[targetid][takedamage], TEN, -1) == 0)
		{
			format(DML_MSG, sizeof(DML_MSG), "[Guardian]: TakenDamage Watch for %s(%i) has been enabled. Use /takendamage [ID/PlayerName]", PlayerName(targetid), targetid);
			SendAdminMessage(1, DML_MSG);
			IsWatchTog[targetid][takedamage] = true;
		}
		new SlotID = GetEmptySlot(PlayerBeingWatched[targetid][takedamage], TEN, -1);
		new PSlotID = GetEmptySlot(PlayerWatching[playerid][takedamage], 5, -1);
		if(SlotID != -1 && PSlotID != -1)
		{
			format(DML_MSG, sizeof(DML_MSG), "[Guardian]: %s %s has started watching %s's taken damage.", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
			SendAdminMessageToArray(PlayerWatching[playerid][takedamage], TEN, DML_MSG, 1);
			PlayerBeingWatched[targetid][takedamage][SlotID]=playerid;
			PlayerWatching[playerid][takedamage][PSlotID]=targetid;
			format(DML_MSG, sizeof(DML_MSG), "[NOTICE]: You are now watching %s's taken damage.", PlayerName(targetid));
			SendClientMessage(playerid, COLOR_NOTICE, DML_MSG);
		}
	}
	else
	{
		format(DML_MSG, sizeof(DML_MSG), "[NOTICE]: You have stopped watching %s's taken damage.", PlayerName(targetid));
		SendClientMessage(playerid, COLOR_NOTICE, DML_MSG);
		PlayerBeingWatched[targetid][takedamage][CurrSlot]=-1;
		PlayerWatching[playerid][takedamage][CurrPSlot]=-1;
		format(DML_MSG, sizeof(DML_MSG), "[NOTICE]: %s %s has stopped watching %s's taken damage.", GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(targetid));
		SendAdminMessageToArray(PlayerWatching[playerid][takedamage], TEN, DML_MSG, 1);
		if(IsArrayEmpty(PlayerBeingWatched[targetid][takedamage], TEN, -1) == 0)
		{
			IsWatchTog[targetid][takedamage] = false;
			format(DML_MSG, sizeof(DML_MSG), "[Guardian]: TakenDamage Watch for %s(%i) is disabled.", PlayerName(targetid), targetid);
			SendAdminMessage(1, DML_MSG);
		}
	}
	return 1;
}


////////////////////ADD FROM HERE TO INC FILE OF FOCO///////////////////////////
/*stock GetEmptySlot(Array[], ArraySize, Empty_Value)
{
	for(new i = 0; i < ArraySize; i++)
	{
		if(Array[i] == Empty_Value)
			return i;
	}
	return -1;
}


stock FindValueInArray(value, Array[], ArraySize)
{
	for(new i = 0; i < ArraySize; i++)
	{
		if(Array[i] == value)
			return i;
	}
	return -1;
}


stock SendAdminMessageToArray(Array[], ArraySize, ArrayMSG[], AdmnLvl)
{
	for(new i = 0; i<ArraySize; i++)
	{
		if(Array[i] != -1)
		{
			if(AdminLvl(Array[i]) >= AdmnLvl)
			{
				SendClientMessage(Array[i], -1, ArrayMSG);
			}
		}
	}
	return 1;
}

stock IsArrayEmpty(Array[], ArraySize, Empty_Value)
{
	new flag=0;
	for(new i = 0; i < ArraySize; i++)
	{
		if(Array[i] != Empty_Value)
			flag++;
	}
	return flag;
}
*/
////////////////////////ADD TILL HERE TO INC FILE OF FOCO///////////////////////
