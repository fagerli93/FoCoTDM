w/*
* Duel Variables
*/
new E_Duel_ID[MAX_PLAYERS] = -1;				// This stores the ID of the player you have invited to a duel.
new E_Duel_POS[MAX_PLAYERS] = 0;				// This will store the value of the position chosen in the dialog before starting an event.
new E_Duel_Request[MAX_PLAYERS] = -1;			// This will store the ID of the person asking you to duel.
new E_Duel_Progress[MAX_PLAYERS] = -1;			// This will store the ID of the person requesting you or the person you are requesting for a duel.
new E_Duel_Freeze[MAX_PLAYERS] = -1; 			// This will be how many seconds you are frozen for at the start of every duel.
new E_Duel_Weapon[MAX_PLAYERS];


/* WHAT HAPPENS WHEN YOU /KILL DURING A DUEL */
if(GetPVarInt(playerid, "PlayerStatus") == 2)
{
	new duel_string[150], qryString[200], Float:health, Float:armour;
	GetPlayerHealth(E_Duel_Progress[playerid], health);
	GetPlayerArmour(E_Duel_Progress[playerid], armour);
	format(duel_string, sizeof(duel_string), "[DUEL]: %s has just won %s in a duel", PlayerName(E_Duel_Progress[playerid]), PlayerName(playerid));
	SendClientMessage(playerid, COLOR_NOTICE, duel_string);
	SendClientMessage(E_Duel_Progress[playerid], COLOR_NOTICE, duel_string);

	format(qryString, sizeof(qryString), "INSERT INTO FoCo_Duels (fd_player_id, fd_enemy, fd_win, fd_health, fd_armour, fd_weapon) VALUES ('%d', '%d', '%d', '%f', '%f', '%d')", FoCo_Player[playerid][id], FoCo_Player[E_Duel_Progress[playerid]][id], 0, 0.0, 0.0, 0);
	mysql_query(qryString, MYSQL_DEATH, playerid, con);

	format(qryString, sizeof(qryString), "INSERT INTO FoCo_Duels (fd_player_id, fd_enemy, fd_win, fd_health, fd_armour, fd_weapon) VALUES ('%d', '%d', '%d', '%f', '%f', '%d')", FoCo_Player[E_Duel_Progress[playerid]][id], FoCo_Player[playerid][id], 1, health, armour, 0);
	mysql_query(qryString, MYSQL_DEATH, playerid, con);

	FoCo_Player[playerid][duels_lost]++;
	FoCo_Player[E_Duel_Progress[playerid]][duels_won]++;
	GiveGuns(E_Duel_Progress[playerid]);
	SpawnPlayer(E_Duel_Progress[playerid]);
	SetPlayerHealth(E_Duel_Progress[playerid], 99.0);
	E_Duel_ID[E_Duel_Progress[playerid]] = -1;
	E_Duel_Request[E_Duel_Progress[playerid]] = -1;
	E_Duel_Progress[E_Duel_Progress[playerid]] = -1;
	E_Duel_ID[playerid] = -1;
	E_Duel_Request[playerid] = -1;
	E_Duel_Progress[playerid] = -1;
}
/* ______________ */



/* WHAT HAPPENS WHEN YOU /ACCEPT A DUEL */

else if(strcmp(result,"duel", true) == 0)
{
	if(!IsPlayerConnected(E_Duel_Request[playerid]))
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player no longer connected");
		return 1;
	}

	if(death[E_Duel_Request[playerid]] != 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That player is currently dead, try again shortly");
		return 1;
	}

	if(death[playerid] != 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Try again once you spawn..");
		return 1;
	}

	if(IsPlayerInAnyVehicle(playerid))
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Leave your vehicle first.");
		return 1;
	}

	if(IsPlayerInAnyVehicle(E_Duel_Request[playerid]))
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That player needs to leave there vehicle first.");
		return 1;
	}
	if(E_Duel_Progress[playerid] == E_Duel_Request[playerid])
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are already in a duel..");
		return 1;
	}
	if(GetPVarInt(playerid, "PlayerStatus") == 1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are in an event.. no..");
		return 1;
	}
	if(GetPVarInt(E_Duel_Request[playerid], "PlayerStatus") == 1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That player is in an event.. no..");
		return 1;
	}

    SetPVarInt(playerid, "PlayerStatus", 2);
    SetPVarInt(E_Duel_Request[playerid], "PlayerStatus", 2);

	format(string, sizeof(string), "[Duel]: %s has accepted your request for a duel", PlayerName(playerid));

	switch(E_Duel_POS[E_Duel_Request[playerid]])
	{
		case 1:
		{
			SetPlayerVirtualWorld(playerid, playerid);
			SetPlayerVirtualWorld(E_Duel_Request[playerid], playerid);

			SetPlayerInterior(playerid, 5);
			SetPlayerInterior(E_Duel_Request[playerid], 5);

			SetPlayerPos(playerid, 762.7089,9.0849,1001.1639);
			SetPlayerPos(E_Duel_Request[playerid], 762.7089,9.0849,1001.1639);

			SetPlayerFacingAngle(playerid, 41.3257);
			SetPlayerFacingAngle(E_Duel_Request[playerid], 224.2907);

			TogglePlayerControllable(playerid, 0);
			TogglePlayerControllable(E_Duel_Request[playerid], 0);

			SendClientMessage(playerid, COLOR_GREEN, "Duel will start in ten seconds");
			SendClientMessage(E_Duel_Request[playerid], COLOR_GREEN, "Duel will start in ten seconds");

			E_Duel_Progress[playerid] = E_Duel_Request[playerid];
			E_Duel_Progress[E_Duel_Request[playerid]] = playerid;

			ResetPlayerWeapons(playerid);
			ResetPlayerWeapons(E_Duel_Progress[playerid]);

			GivePlayerWeapon(playerid, E_Duel_Weapon[E_Duel_Progress[playerid]], 500);
			GivePlayerWeapon(E_Duel_Progress[playerid], E_Duel_Weapon[E_Duel_Progress[playerid]], 500);

			SetPlayerHealth(playerid, 99);
			SetPlayerHealth(E_Duel_Progress[playerid], 99);

			SetPlayerArmour(playerid, 0);
			SetPlayerArmour(E_Duel_Progress[playerid], 0);

			E_Duel_Freeze[playerid] = 10;
			return 1;
		}
		case 2:
		{
			SetPlayerVirtualWorld(playerid, playerid);
			SetPlayerVirtualWorld(E_Duel_Request[playerid], playerid);

			SetPlayerInterior(playerid, 1);
			SetPlayerInterior(E_Duel_Request[playerid], 1);

			SetPlayerPos(playerid, 1413.7787,3.5894,1000.9254);
			SetPlayerPos(E_Duel_Request[playerid], 1361.5017,-14.7729,1000.9219);

			SetPlayerFacingAngle(playerid, 143.5238);
			SetPlayerFacingAngle(E_Duel_Request[playerid], 273.7266);

			TogglePlayerControllable(playerid, 0);
			TogglePlayerControllable(E_Duel_Request[playerid], 0);

			SendClientMessage(playerid, COLOR_GREEN, "Duel will start in ten seconds");
			SendClientMessage(E_Duel_Request[playerid], COLOR_GREEN, "Duel will start in ten seconds");

			E_Duel_Progress[playerid] = E_Duel_Request[playerid];
			E_Duel_Progress[E_Duel_Request[playerid]] = playerid;

			ResetPlayerWeapons(playerid);
			ResetPlayerWeapons(E_Duel_Progress[playerid]);

			GivePlayerWeapon(playerid, E_Duel_Weapon[E_Duel_Progress[playerid]], 500);
			GivePlayerWeapon(E_Duel_Progress[playerid], E_Duel_Weapon[E_Duel_Progress[playerid]], 500);

			SetPlayerHealth(playerid, 99);
			SetPlayerHealth(E_Duel_Progress[playerid], 99);

			SetPlayerArmour(playerid, 0);
			SetPlayerArmour(E_Duel_Progress[playerid], 0);

			E_Duel_Freeze[playerid] = 10;
			return 1;
		}
		case 3:
		{
			SetPlayerVirtualWorld(playerid, playerid);
			SetPlayerVirtualWorld(E_Duel_Request[playerid], playerid);

			SetPlayerInterior(playerid, 2);
			SetPlayerInterior(E_Duel_Request[playerid], 2);

			SetPlayerPos(playerid, 2575.2112,-1304.2657,1060.9844);
			SetPlayerPos(E_Duel_Request[playerid], 2548.4167,-1288.9679,1060.9844);

			SetPlayerFacingAngle(playerid, 45.1204);
			SetPlayerFacingAngle(E_Duel_Request[playerid], 271.9526);

			TogglePlayerControllable(playerid, 0);
			TogglePlayerControllable(E_Duel_Request[playerid], 0);

			SendClientMessage(playerid, COLOR_GREEN, "Duel will start in ten seconds");
			SendClientMessage(E_Duel_Request[playerid], COLOR_GREEN, "Duel will start in ten seconds");

			E_Duel_Progress[playerid] = E_Duel_Request[playerid];
			E_Duel_Progress[E_Duel_Request[playerid]] = playerid;

			ResetPlayerWeapons(playerid);
			ResetPlayerWeapons(E_Duel_Progress[playerid]);

			GivePlayerWeapon(playerid, E_Duel_Weapon[E_Duel_Progress[playerid]], 500);
			GivePlayerWeapon(E_Duel_Progress[playerid], E_Duel_Weapon[E_Duel_Progress[playerid]], 500);

			SetPlayerHealth(playerid, 99);
			SetPlayerHealth(E_Duel_Progress[playerid], 99);

			SetPlayerArmour(playerid, 0);
			SetPlayerArmour(E_Duel_Progress[playerid], 0);

			E_Duel_Freeze[playerid] = 10;
			return 1;
		}
		case 4:
		{
			SetPlayerVirtualWorld(playerid, playerid);
			SetPlayerVirtualWorld(E_Duel_Request[playerid], playerid);

			SetPlayerInterior(playerid, 17);
			SetPlayerInterior(E_Duel_Request[playerid], 17);

			SetPlayerPos(playerid, 498.4060,-22.8580,1000.6797);
			SetPlayerPos(E_Duel_Request[playerid], 474.9359,-12.9472,1003.6953);

			SetPlayerFacingAngle(playerid, 54.5881);
			SetPlayerFacingAngle(E_Duel_Request[playerid], 246.9531);

			TogglePlayerControllable(playerid, 0);
			TogglePlayerControllable(E_Duel_Request[playerid], 0);

			SendClientMessage(playerid, COLOR_GREEN, "Duel will start in ten seconds");
			SendClientMessage(E_Duel_Request[playerid], COLOR_GREEN, "Duel will start in ten seconds");

			E_Duel_Progress[playerid] = E_Duel_Request[playerid];
			E_Duel_Progress[E_Duel_Request[playerid]] = playerid;

			ResetPlayerWeapons(playerid);
			ResetPlayerWeapons(E_Duel_Progress[playerid]);

			GivePlayerWeapon(playerid, E_Duel_Weapon[E_Duel_Progress[playerid]], 500);
			GivePlayerWeapon(E_Duel_Progress[playerid], E_Duel_Weapon[E_Duel_Progress[playerid]], 500);

			SetPlayerHealth(playerid, 99);
			SetPlayerHealth(E_Duel_Progress[playerid], 99);

			SetPlayerArmour(playerid, 0);
			SetPlayerArmour(E_Duel_Progress[playerid], 0);

			E_Duel_Freeze[playerid] = 10;
			return 1;
		}
		case 5:
		{
			SetPlayerVirtualWorld(playerid, playerid);
			SetPlayerVirtualWorld(E_Duel_Request[playerid], playerid);

			SetPlayerInterior(playerid, 3);
			SetPlayerInterior(E_Duel_Request[playerid], 3);

			SetPlayerPos(playerid, -2638.2664,1405.9395,906.4609);
			SetPlayerPos(E_Duel_Request[playerid], -2677.7673,1409.7185,907.5703);

			SetPlayerFacingAngle(playerid, 84.0182);
			SetPlayerFacingAngle(E_Duel_Request[playerid], 264.0182);

			TogglePlayerControllable(playerid, 0);
			TogglePlayerControllable(E_Duel_Request[playerid], 0);

			SendClientMessage(playerid, COLOR_GREEN, "Duel will start in ten seconds");
			SendClientMessage(E_Duel_Request[playerid], COLOR_GREEN, "Duel will start in ten seconds");

			E_Duel_Progress[playerid] = E_Duel_Request[playerid];
			E_Duel_Progress[E_Duel_Request[playerid]] = playerid;

			ResetPlayerWeapons(playerid);
			ResetPlayerWeapons(E_Duel_Progress[playerid]);

			SetPlayerHealth(playerid, 99);
			SetPlayerHealth(E_Duel_Progress[playerid], 99);

			SetPlayerArmour(playerid, 0);
			SetPlayerArmour(E_Duel_Progress[playerid], 0);

			GivePlayerWeapon(playerid, E_Duel_Weapon[E_Duel_Progress[playerid]], 500);
			GivePlayerWeapon(E_Duel_Progress[playerid], E_Duel_Weapon[E_Duel_Progress[playerid]], 500);

			E_Duel_Freeze[playerid] = 10;
			return 1;
		}
		case 6:
		{
			SetPlayerVirtualWorld(playerid, playerid);
			SetPlayerVirtualWorld(E_Duel_Request[playerid], playerid);

			SetPlayerInterior(playerid, 0);
			SetPlayerInterior(E_Duel_Request[playerid], 0);

			SetPlayerPos(playerid, 4791.7031,-2043.6146,12.7350);
			SetPlayerPos(E_Duel_Request[playerid], 4720.7412,-2032.7151,12.7057);

			SetPlayerFacingAngle(playerid, 81.9983);
			SetPlayerFacingAngle(E_Duel_Request[playerid], 261.3413);

			TogglePlayerControllable(playerid, 0);
			TogglePlayerControllable(E_Duel_Request[playerid], 0);

			SendClientMessage(playerid, COLOR_GREEN, "Duel will start in ten seconds");
			SendClientMessage(E_Duel_Request[playerid], COLOR_GREEN, "Duel will start in ten seconds");

			E_Duel_Progress[playerid] = E_Duel_Request[playerid];
			E_Duel_Progress[E_Duel_Request[playerid]] = playerid;

			ResetPlayerWeapons(playerid);
			ResetPlayerWeapons(E_Duel_Progress[playerid]);

			SetPlayerHealth(playerid, 99);
			SetPlayerHealth(E_Duel_Progress[playerid], 99);

			SetPlayerArmour(playerid, 0);
			SetPlayerArmour(E_Duel_Progress[playerid], 0);

			GivePlayerWeapon(playerid, E_Duel_Weapon[E_Duel_Progress[playerid]], 500);
			GivePlayerWeapon(E_Duel_Progress[playerid], E_Duel_Weapon[E_Duel_Progress[playerid]], 500);

			E_Duel_Freeze[playerid] = 10;
			return 1;
		}
	}
}
/*______________________*/


CMD:leaveduel(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerStatus") != 2)
	{
		SendClientMessage(playerid, COLOR_WARNING, "Your not in a duel");
		return 1;
	}

	E_Duel_ID[E_Duel_Progress[playerid]] = -1;
	SetPVarInt(E_Duel_Progress[playerid], "PlayerStatus", -1);
	E_Duel_ID[playerid] = -1;
	SetPVarInt(playerid, "PlayerStatus",-1);
	SendClientMessage(playerid, COLOR_WARNING, "You have left your duel");
	SendClientMessage(E_Duel_Progress[playerid], COLOR_WARNING, "The other member of your duel has left.");
	SpawnPlayer(playerid);
	SpawnPlayer(E_Duel_Progress[playerid]);
	return 1;
}

CMD:duel(playerid, params[])
{
	new targetid, string[128];
	if (sscanf(params, "u", targetid))
	{
		format(string, sizeof(string), "[USAGE]: {%06x}/duel {%06x}[ID/Name]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, string);
		return 1;
	}

	if(targetid == INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: Player is not connected");
		return 1;
	}

	if(GetPVarInt(playerid, "PlayerStatus") == 1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You are in an event, wait for that to finish first");
		return 1;
	}

	if(GetPVarInt(targetid, "PlayerStatus") == 1)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That player is in an event, wait for that to finish first");
		return 1;
	}

	if(targetid == playerid)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not duel yourself.");
		return 1;
	}

	if(GetPVarInt(targetid, "PlayerStatus") == 2)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: That player is currently in a duel.");
		return 1;
	}

	if(FoCo_Player[targetid][jailed] != 0 || FoCo_Player[playerid][jailed] != 0)
	{
		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You or the player you want to duel is jailed.");
		return 1;
	}
	E_Duel_ID[playerid] = targetid;
	ShowPlayerDialog(playerid, DIALOG_DUEL_WEAPON, DIALOG_STYLE_LIST, "Select Weapon", "9 - Chainsaw\n24 - Deagle\n25 - Shotgun\n26 - Sawnoff\n27 - Combat SG\n28 - Uzi\n30 - AK\n31 - M4\n33 - Country Rifle\n34 - Sniper", "Select", "Cancel");
	return 1;
}


/* ON PLAYER CONNECT */
	E_Duel_ID[playerid] = -1;
	E_Duel_POS[playerid] = 0;
	E_Duel_Request[playerid] = -1;
	E_Duel_Progress[playerid] = -1;
	E_Duel_Freeze[playerid] = -1;
/*_________________*/


/* ON PLAYER DISCONNECT */


	if(GetPVarInt(playerid, "PlayerStatus") == 2)
	{
		OnPlayerDeath(playerid, E_Duel_ID[playerid], 0);
	}
		E_Duel_ID[playerid] = -1;
	E_Duel_POS[playerid] = 0;
	E_Duel_Request[playerid] = -1;
	E_Duel_Progress[playerid] = -1;
	E_Duel_Freeze[playerid] = -1;
/*____________________*/

/* ON PLAYER DEATH */
	if(killerid != INVALID_PLAYER_ID)
	{
		if(E_Duel_Progress[playerid] >= 0)
		{
			new duel_string[150];
			format(duel_string, sizeof(duel_string), "[DUEL]: %s has just won against %s in a duel", PlayerName(E_Duel_Progress[playerid]), PlayerName(playerid));
			SendClientMessage(playerid, COLOR_NOTICE, duel_string);
			SendClientMessage(E_Duel_Progress[playerid], COLOR_NOTICE, duel_string);

			SetPVarInt(playerid, "InDuel", 0);
			SetPVarInt(E_Duel_Progress[playerid], "InDuel", 0);

			format(qryString, sizeof(qryString), "INSERT INTO FoCo_Duels (fd_player_id, fd_enemy, fd_win, fd_health, fd_armour, fd_weapon) VALUES ('%d', '%d', '%d', '%f', '%f', '%d')", FoCo_Player[playerid][id], FoCo_Player[killerid][id], 0, 0.0, 0.0, reason);
			mysql_query(qryString, MYSQL_DEATH, playerid, con);

			format(qryString, sizeof(qryString), "INSERT INTO FoCo_Duels (fd_player_id, fd_enemy, fd_win, fd_health, fd_armour, fd_weapon) VALUES ('%d', '%d', '%d', '%f', '%f', '%d')", FoCo_Player[killerid][id], FoCo_Player[playerid][id], 1, health, armour, reason);
			mysql_query(qryString, MYSQL_DEATH, playerid, con);

			FoCo_Player[playerid][duels_lost]++;
			FoCo_Player[killerid][duels_won]++;
			GiveGuns(E_Duel_Progress[playerid]);
			SpawnPlayer(E_Duel_Progress[playerid]);
			SetPlayerHealth(E_Duel_Progress[playerid], 99);
			E_Duel_ID[E_Duel_Progress[playerid]] = -1;
			E_Duel_Request[E_Duel_Progress[playerid]] = -1;
			E_Duel_Progress[E_Duel_Progress[playerid]] = -1;
			E_Duel_ID[playerid] = -1;
			E_Duel_Request[playerid] = -1;
			E_Duel_Progress[playerid] = -1;
		}
	}
/*_________________________*/

/* ON DIALOG RESPONSE */
case DIALOG_DUEL_WEAPON:
		{
			if(!response)
			{
				E_Duel_ID[playerid] = -1;
				return 1;
			}

			new item;
			sscanf(inputtext, "i", item);

			E_Duel_Weapon[playerid] = item;
			ShowPlayerDialog(playerid, DIALOG_DUEL, DIALOG_STYLE_LIST, DUEL_LIST, "Select", "Cancel");
			return 1;
		}
		case DIALOG_DUEL:
		{
			if(!response)
			{
				E_Duel_ID[playerid] = -1;
				E_Duel_Weapon[playerid] = 0;
				return 1;
			}

			new duelstr[140];

			E_Duel_Request[E_Duel_ID[playerid]] = playerid;
			switch(listitem)
			{
				case 0:
				{
					E_Duel_POS[playerid] = 1;
					format(duelstr, sizeof(duelstr), "[Duel] %s wants to fight you at %s. /accept duel to join", PlayerName(playerid), DuelPos(E_Duel_POS[playerid]));
					SendClientMessage(E_Duel_ID[playerid], COLOR_GREEN, duelstr);
				}
				case 1:
				{
					E_Duel_POS[playerid] = 2;
					format(duelstr, sizeof(duelstr), "[Duel] %s wants to fight you at %s. /accept duel to join", PlayerName(playerid), DuelPos(E_Duel_POS[playerid]));
					SendClientMessage(E_Duel_ID[playerid], COLOR_GREEN, duelstr);
				}
				case 2:
				{
					E_Duel_POS[playerid] = 3;
					format(duelstr, sizeof(duelstr), "[Duel] %s wants to fight you at %s. /accept duel to join", PlayerName(playerid), DuelPos(E_Duel_POS[playerid]));
					SendClientMessage(E_Duel_ID[playerid], COLOR_GREEN, duelstr);
				}
				case 3:
				{
					E_Duel_POS[playerid] = 4;
					format(duelstr, sizeof(duelstr), "[Duel] %s wants to fight you at %s. /accept duel to join", PlayerName(playerid), DuelPos(E_Duel_POS[playerid]));
					SendClientMessage(E_Duel_ID[playerid], COLOR_GREEN, duelstr);
				}
				case 4:
				{
					E_Duel_POS[playerid] = 5;
					format(duelstr, sizeof(duelstr), "[Duel] %s wants to fight you at %s. /accept duel to join", PlayerName(playerid), DuelPos(E_Duel_POS[playerid]));
					SendClientMessage(E_Duel_ID[playerid], COLOR_GREEN, duelstr);
				}
				case 5:
				{
					E_Duel_POS[playerid] = 6;
					format(duelstr, sizeof(duelstr), "[Duel] %s wants to fight you at %s. /accept duel to join", PlayerName(playerid), DuelPos(E_Duel_POS[playerid]));
					SendClientMessage(E_Duel_ID[playerid], COLOR_GREEN, duelstr);
				}
			}
			SendClientMessage(playerid, COLOR_GREEN, "[DUEL]: Duel invite has been sent");
			return 1;
		}

/*__________________*/

/* INSIDE THE ONE_SECOND_TIMER */
		if(E_Duel_Progress[i] != -1)
		{
			if(E_Duel_Freeze[i] > 0)
			{
				E_Duel_Freeze[i]--;
			}
			if(E_Duel_Freeze[i] == 0)
			{
				TogglePlayerControllable(E_Duel_Progress[i], 1);
				if(E_Duel_Progress[E_Duel_Request[i]] != INVALID_PLAYER_ID || E_Duel_Progress[E_Duel_Request[i]] != -1)
				{
					TogglePlayerControllable(E_Duel_Progress[E_Duel_Request[i]], 1);
				}
				E_Duel_Freeze[i] = -1;

				SendClientMessage(E_Duel_Progress[i], COLOR_GREEN, "BEGIN!!");
				SendClientMessage(E_Duel_Progress[E_Duel_Request[i]], COLOR_GREEN, "BEGIN!!");/*
				new debug_str[128];
				format(debug_str, sizeof(debug_str), "DEBUG:   E_Duel_Progress[i]: %d  -   E_Duel_Progress[E_Duel_Request[i]]: %d", E_Duel_Progress[i], E_Duel_Progress[E_Duel_Request[i]]);
				SendClientMessageToAll(COLOR_GREEN, debug_str);*/
			}
		}
/* _______________________ */

/* INSIDE THE Manhunt_Event() Function */

	if(E_Duel_Request[rand] >= 0)
	{
		if(ManHuntFail == 3)
		{
			SendAdminMessage(1,"Manhunt event has failed due to ManHunt Member chosen");
			return 1;
		}
		ManHuntFail++;
		Manhunt_Event();
		return 1;
	}
/* ___________________ */


		
