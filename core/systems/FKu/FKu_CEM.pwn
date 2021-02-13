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
* Filename:CEM.pwn																 *
* Author:FKu																   	 *
*********************************************************************************/
/*------------------------------------------------------------------------------
Gamemodes:
TDM - 0
FFA - 1
Race - 2
Parkour - 3

Team:
A - SWAT
B - Terrorist
------------------------------------------------------------------------------*/
#include <YSI\y_hooks>

#define MAIN_DIALOG 510//defined dialogs id
#define GAMEMODE_DIALOG 511
#define LOADOUT_DIALOG 512
#define WEAPON1_DIALOG 513
#define WEAPON2_DIALOG 514
#define WEAPON3_DIALOG 515
#define WEAPON4_DIALOG 516
#define REJOINOPTION_DIALOG 517
#define MAXPLAYERS_DIALOG 518
#define SKINA_DIALOG 519
#define SKINB_DIALOG 520
#define VEHICLEID_DIALOG 521
#define SETSPAWN_DIALOG 522
#define TEAMA 50//TDM event TEAM A
#define TEAMB 51//TDM event TEAM B
#define NOTEAM 255

new CEM[Custom_event_maker];

new CEM_Players;

new PlayerColor[MAX_PLAYERS],
	PlayerTeamID[MAX_PLAYERS char],
	PlayerSkinID[MAX_PLAYERS];

new Float:FKu_Position[66][3];
new Float:FKu_TDMPos[3][MAX_PLAYERS];
new Float:FKu_Checkpoint[66][3];
new Float:EventAngle[3];
new const RacePosString[][] = {
	{"1st"},
	{"2nd"},
	{"3rd"},
	{"4th"},
	{"5th"}
};
new const CEM_spawntimes[] ={0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10};// Part of the TDM spawning algorithm
//,11,11,12,12,13,13,14,14,15,15

new const Float:CEM_spawnalg[][] = {// Part of the TDM spawning algorithm
	{-0.75, 0.0},
	{0.0, 0.75},
	{0.75, 0.0},
	{0.0, -0.75}
};
new CountTEAMA;
new SetTEAMA;//4
new cTEAMA;//25
new pTEAMA;//100
new CountTEAMB;
new SetTEAMB;//4
new cTEAMB;//25
new pTEAMB;//100
new RacePos;
new PosSet;
new ChSet;
new ChPassed[MAX_PLAYERS char];
new VehiclesID[MAX_PLAYERS];

//Player veriables ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

// -----------------------------------------------------------------------------

hook OnPlayerDeath(playerid, killerid, reason)
{
	if(FoCo_Event == 9)
	{
		if(GetPVarInt(playerid,"PlayerStatus") == 1)
		{
			switch(CEM[Gamemode])
			{
				case 0://TDM
				{
					new string[40];
					if(GetPVarInt(playerid,"MotelTeamIssued") == 1) pTEAMA = pTEAMA - 1;
					else pTEAMB = pTEAMB - 1;
					
					format(string, sizeof(string), "[EVENT SCORE] SWAT: %d - Terrorists: %d",CEM_Players-pTEAMA-pTEAMB,CEM_Players-pTEAMB-pTEAMA);
					SendClientMessageToAll(COLOR_NOTICE,string);

					leavecevent(playerid);
					Iter_Remove(Event_Players, playerid);
					FoCo_Event_Died[playerid] = 1;
					if(pTEAMA  == 0 || pTEAMB == 0)
					{
						if(pTEAMA == 0) SendClientMessageToAll(COLOR_NOTICE,"Terrorists has won the event!");
						else SendClientMessageToAll(COLOR_NOTICE,"SWAT has won the event!");
						clearevent();
					}
					//}
				}
				case 1:
				{
					SetPVarInt(playerid,"PlayerStatus",0);
					Iter_Remove(Event_Players, playerid);
					if(CEM[Rejoinable] == 0) FoCo_Event_Died[playerid]++;
				}
				case 2 .. 3:
				{
					if(Event_PlayerVeh[playerid] != -1) DestroyVehicle(Event_PlayerVeh[playerid]);
					ChPassed{playerid} = 0;
					SetPVarInt(playerid,"PlayerStatus",0);
					Iter_Remove(Event_Players, playerid);
					if(Iter_Count(Event_Players) == 0) clearevent();
				}
			}
		}
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(FoCo_Event == 9)
	{
		if(GetPVarInt(playerid,"PlayerStatus") == 1 && CEM[Gamemode] == 0)
		{
			new string[40];
			
			if(GetPVarInt(playerid,"MotelTeamIssued") == 1) pTEAMA = pTEAMA - 1;
			else pTEAMB = pTEAMB - 1;
			
			format(string, sizeof(string), "[EVENT SCORE] SWAT: %d - Terrorists: %d",CEM_Players-pTEAMA-pTEAMB,CEM_Players-pTEAMB-pTEAMA);
			SendClientMessageToAll(COLOR_NOTICE,string);

			SetPVarInt(playerid,"PlayerStatus",0);
			SetPVarInt(playerid, "MotelTeamIssued", 0);
			Iter_Remove(Event_Players, playerid);
			
			if(Iter_Count(Event_Players) == 0) clearevent();
			
			if(pTEAMA  == 0 || pTEAMB == 0)
			{
				if(pTEAMA == 0) SendClientMessageToAll(COLOR_NOTICE,"Terrorists has won the event!");
				else SendClientMessageToAll(COLOR_NOTICE,"SWAT has won the event!");
				clearevent();
			}
		}
	}
	return 1;
}

// -----------------------------------------------------------------------------

//Race/Parkour PART ------------------------------------------------------------

// -----------------------------------------------------------------------------
hook OnPlayerEnterRaceCheckpoint(playerid)
{
	if(GetPVarInt(playerid,"PlayerStatus") == 1)
	{
		ChPassed{playerid} ++;
		if(ChPassed{playerid} == ChSet)
		{
			new string[65],name[MAX_PLAYER_NAME+1];
			GetPlayerName(playerid,name,sizeof(name));
			format(string, sizeof(string), "%s finished %s place in the race!",name,RacePosString[RacePos]);
			SendClientMessageToAll(COLOR_NOTICE, string);
			
			if(RacePos == 0) EventGift(playerid);
			
			RacePos++;
			leavecevent(playerid);
			Iter_Remove(Event_Players, playerid);
			
			if(Iter_Count(Event_Players) == 0) clearevent();
			if(RacePos == 5) clearevent();
		}
		else if (ChPassed{playerid} == ChSet - 1) SetPlayerRaceCheckpoint(playerid, 1, FKu_Checkpoint[ChPassed{playerid}][0], FKu_Checkpoint[ChPassed{playerid}][1], FKu_Checkpoint[ChPassed{playerid}][2], FKu_Checkpoint[ChPassed{playerid} + 1][0], FKu_Checkpoint[ChPassed{playerid} + 1][1], FKu_Checkpoint[ChPassed{playerid} + 1][2], 10);
		else	SetPlayerRaceCheckpoint(playerid, 0, FKu_Checkpoint[ChPassed{playerid}][0], FKu_Checkpoint[ChPassed{playerid}][1], FKu_Checkpoint[ChPassed{playerid}][2], FKu_Checkpoint[ChPassed{playerid} + 1][0], FKu_Checkpoint[ChPassed{playerid} + 1][1], FKu_Checkpoint[ChPassed{playerid} + 1][2], 10);
	}
	return 1;
}
// -----------------------------------------------------------------------------

// DIALOGS ---------------------------------------------------------------------

// -----------------------------------------------------------------------------
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case MAIN_DIALOG:// Main dialog
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						if(FoCo_Event == -1)
						{
							switch(CEM[Gamemode])
							{
								case 0://TDM
								{
									if(CEM[MaxPlayers] >= 2 && FKu_Position[64][0]+FKu_Position[64][1]+FKu_Position[64][2]!=0.0 && FKu_Position[65][0]+FKu_Position[65][1]+FKu_Position[65][2]!=0.0 && CEM[WeaponID]>0)
									{
										CountTEAMA = 0;
										CountTEAMB = 0;
										StartEventStuff();
										SendClientMessageToAll(COLOR_GREEN, "Custom TDM Event has been started type /join to join");
									}
									else SendClientMessage(playerid, COLOR_NOTICE, "Max players amount, spawn points or weapons arent set!");
								}
								case 1://FFA
								{
									if(CEM[MaxPlayers] >= 2  && CEM[WeaponID] > 0)
									{
										for(new i; i < CEM[MaxPlayers]/4;i++)
										{
											if(FKu_Position[i][0]+FKu_Position[i][1]+FKu_Position[i][2]==0.0)return SendClientMessage(playerid, COLOR_NOTICE, "Positions arent set!");
										}
										StartEventStuff();
										SendClientMessageToAll(COLOR_GREEN, "Custom FFA Event has been started type /join to join");
									}
									else SendClientMessage(playerid, COLOR_NOTICE, "Max players or Weapons arent set!");
								}
								case 2://Race
								{
									if(CEM[MaxPlayers] >= 2  && CEM[CEM_VehID] > 399)
									{
										if(ChSet == 0)return SendClientMessage(playerid, COLOR_NOTICE, "Checkpoints arent set!");
										for(new i; i < CEM[MaxPlayers];i++)
										{
											if(FKu_Position[i][0]+FKu_Position[i][1]+FKu_Position[i][2]==0.0)return SendClientMessage(playerid, COLOR_NOTICE, "Positions arent set!");
										}
										StartEventStuff();
										SendClientMessageToAll(COLOR_GREEN, "Custom Race Event has been started type /join to join");
									}
									else SendClientMessage(playerid, COLOR_NOTICE, "Max players or vehicle ID isnt set!");
								}
								case 3://Parkour
								{
									if(CEM[MaxPlayers] >= 2)
									{
										if(ChSet == 0)return SendClientMessage(playerid, COLOR_NOTICE, "Checkpoints arent set!");
										for(new i; i < CEM[MaxPlayers];i++)
										{
											if(FKu_Position[i][0]+FKu_Position[i][1]+FKu_Position[i][2]==0.0)return SendClientMessage(playerid, COLOR_NOTICE, "Positions arent set!");
										}
										StartEventStuff();
										SendClientMessageToAll(COLOR_GREEN, "Custom Parkour Event has been started type /join to join");
									}
									else SendClientMessage(playerid, COLOR_NOTICE, "Max players isnt set!");
								}
							}
						}
						else	SendClientMessage(playerid, COLOR_NOTICE, "Event already on");
					}
					case 1:	ShowPlayerDialog(playerid, GAMEMODE_DIALOG, DIALOG_STYLE_LIST,"Custom Event Maker 3000!","TDM\nFFA\nRace\nParkour","Select","Back");
					case 2:	ShowPlayerDialog(playerid, SETSPAWN_DIALOG, DIALOG_STYLE_MSGBOX,"Custom Event Maker 3000!","TDM : To set team spawn use /setteam(A/B)\n\nFFA/Race : Use /setpos","Back","");
					case 3:	ShowPlayerDialog(playerid, LOADOUT_DIALOG, DIALOG_STYLE_LIST,"Custom Event Maker 3000!", "Weapon 1\nWeapon 2\nWeapon 3\nWeapon 4", "Select", "Back");
					case 4:	ShowPlayerDialog(playerid, REJOINOPTION_DIALOG, DIALOG_STYLE_INPUT,"Custom Event Maker 3000!","Type re-join option (0-No / 1-Yes) :","Next","Back");
					case 5:	ShowPlayerDialog(playerid, MAXPLAYERS_DIALOG, DIALOG_STYLE_INPUT,"Custom Event Maker 3000!","Type the max amount of players :","Next","Back");
					case 6:	ShowPlayerDialog(playerid, SKINA_DIALOG, DIALOG_STYLE_INPUT,"Custom Event Maker 3000!","Type the skin ID for team A :","Next","Back");
					case 7:	ShowPlayerDialog(playerid, VEHICLEID_DIALOG, DIALOG_STYLE_INPUT,"Custom Event Maker 3000!","Type the vehicle ID (if no vehicle type 0) :","Next","Back");
					case 8:
					{
						clearevent();
						CEM[WeaponID] = 0;
						CEM[WeaponID2] = 0;
						CEM[WeaponID3] = 0;
						CEM[WeaponID4] = 0;
						CEM[MaxPlayers] = 24;//By default its going to be 24
						CEM[Rejoinable] = 0;
						CEM[Gamemode] = 0;
						CEM[SkinA] = 0;
						CEM[SkinB] = 0;
						CEM[CEM_VehID] = 0;
					}
				}
			}
		}
		case SETSPAWN_DIALOG:// Seting spawn dialog
		{
			if(response) ShowPlayerDialog(playerid, MAIN_DIALOG, DIALOG_STYLE_LIST,"Custom Event Maker 3000!","Start event!\nSet event mode\nMark spawns\nLoadout\nRe-join option\nMax players amount\nTDM skins\nVehicle option\nReset Settings","Select","Close");
 		}
		case GAMEMODE_DIALOG:// Seting Gamemode
		{
			if(response)
			{
				CEM[Gamemode] = listitem;//0 - TDM, 1 - FFA, 2 - Race, - 4 Parkour
				if(listitem == 1) ShowPlayerDialog(playerid, REJOINOPTION_DIALOG, DIALOG_STYLE_INPUT,"Custom Event Maker 3000!","Type re-join option (0-No / 1-Yes) :","Next","Back");
				else if(listitem == 2) ShowPlayerDialog(playerid, VEHICLEID_DIALOG, DIALOG_STYLE_INPUT,"Custom Event Maker 3000!","Type the vehicle ID (if no vehicle type 0) :","Next","Back");
				else ShowPlayerDialog(playerid, MAIN_DIALOG, DIALOG_STYLE_LIST,"Custom Event Maker 3000!","Start event!\nSet event mode\nMark spawns\nLoadout\nRe-join option\nMax players amount\nTDM skins\nVehicle option\nReset Settings","Select","Close");
			}

		}
		case LOADOUT_DIALOG:// Seting Loadout
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:	ShowPlayerDialog(playerid, WEAPON1_DIALOG, DIALOG_STYLE_INPUT,"Custom Event Maker 3000!","Enter weapon 1 ID :","Next","Back");
					case 1:	ShowPlayerDialog(playerid, WEAPON2_DIALOG, DIALOG_STYLE_INPUT,"Custom Event Maker 3000!","Enter weapon 2 ID :","Next","Back");
					case 2:	ShowPlayerDialog(playerid, WEAPON3_DIALOG, DIALOG_STYLE_INPUT,"Custom Event Maker 3000!","Enter weapon 3 ID :","Next","Back");
					case 3:	ShowPlayerDialog(playerid, WEAPON4_DIALOG, DIALOG_STYLE_INPUT,"Custom Event Maker 3000!","Enter weapon 4 ID :","Next","Back");
				}
			}
			else	ShowPlayerDialog(playerid,MAIN_DIALOG,DIALOG_STYLE_LIST,"Custom Event Maker 3000!","Start event!\nSet event mode\nMark spawns\nLoadout\nRe-join option\nMax players amount\nTDM skins\nVehicle option\nReset Settings","Select","Close");

		}
		case WEAPON1_DIALOG:// Weapon 1
		{
			if(response)
			{
				CEM[WeaponID] = strval(inputtext);
				SendClientMessage(playerid, COLOR_GREEN, "First weapon ID is set!");
				ShowPlayerDialog(playerid, LOADOUT_DIALOG, DIALOG_STYLE_LIST,"Custom Event Maker 3000!", "Weapon 1\nWeapon 2\nWeapon 3\nWeapon 4\n", "Select", "Back");
			}
			else	ShowPlayerDialog(playerid,MAIN_DIALOG,DIALOG_STYLE_LIST,"Custom Event Maker 3000!","Start event!\nSet event mode\nMark spawns\nLoadout\nRe-join option\nMax players amount\nTDM skins\nVehicle option\nReset Settings","Select","Close");

		}
		case WEAPON2_DIALOG:// Weapon 2
		{
			if(response)
			{
				CEM[WeaponID2] = strval(inputtext);
				SendClientMessage(playerid, COLOR_GREEN, "Second weapon ID is set!");
				ShowPlayerDialog(playerid, LOADOUT_DIALOG, DIALOG_STYLE_LIST,"Custom Event Maker 3000!", "Weapon 1\nWeapon 2\nWeapon 3\nWeapon 4\n", "Select", "Back");
			}
			else	ShowPlayerDialog(playerid,MAIN_DIALOG,DIALOG_STYLE_LIST,"Custom Event Maker 3000!","Start event!\nSet event mode\nMark spawns\nLoadout\nRe-join option\nMax players amount\nTDM skins\nVehicle option\nReset Settings","Select","Close");
		}
		case WEAPON3_DIALOG:// Weapon 3
		{
			if(response)
			{
				CEM[WeaponID3] = strval(inputtext);
				SendClientMessage(playerid, COLOR_GREEN, "Third weapon ID is set!");
				ShowPlayerDialog(playerid, LOADOUT_DIALOG, DIALOG_STYLE_LIST,"Custom Event Maker 3000!", "Weapon 1\nWeapon 2\nWeapon 3\nWeapon 4\n", "Select", "Back");
			}
			else	ShowPlayerDialog(playerid,MAIN_DIALOG,DIALOG_STYLE_LIST,"Custom Event Maker 3000!","Start event!\nSet event mode\nMark spawns\nLoadout\nRe-join option\nMax players amount\nTDM skins\nVehicle option\nReset Settings","Select","Close");
		}
		case WEAPON4_DIALOG:// Waepon 4
		{
			if(response)
			{
				CEM[WeaponID4] = strval(inputtext);
				SendClientMessage(playerid, COLOR_GREEN, "Fourth weapon ID is set!");
				ShowPlayerDialog(playerid, LOADOUT_DIALOG, DIALOG_STYLE_LIST,"Custom Event Maker 3000!", "Weapon 1\nWeapon 2\nWeapon 3\nWeapon 4\n", "Select", "Back");
			}
			else	ShowPlayerDialog(playerid,MAIN_DIALOG,DIALOG_STYLE_LIST,"Custom Event Maker 3000!","Start event!\nSet event mode\nMark spawns\nLoadout\nRe-join option\nMax players amount\nTDM skins\nVehicle option\nReset Settings","Select","Close");

		}
		case REJOINOPTION_DIALOG:// Rejoinable option
		{
			if(response)
			{
				CEM[Rejoinable] = strval(inputtext);
				FoCo_Event_Rejoin = CEM[Rejoinable];
				if(!CEM[Rejoinable])	SendClientMessage(playerid, COLOR_GREEN, "	 Not re-joinable it is!");
				else	SendClientMessage(playerid, COLOR_GREEN, "Re-joinable it is!");
			}
			ShowPlayerDialog(playerid,MAIN_DIALOG,DIALOG_STYLE_LIST,"Custom Event Maker 3000!","Start event!\nSet event mode\nMark spawns\nLoadout\nRe-join option\nMax players amount\nTDM skins\nVehicle option\nReset Settings","Select","Close");

		}
		case MAXPLAYERS_DIALOG:// Max amount of players
		{
			if(response)
			{
				CEM[MaxPlayers] = strval(inputtext);
				SendClientMessage(playerid, COLOR_GREEN, "Max players count is set!");
			}
			ShowPlayerDialog(playerid,MAIN_DIALOG,DIALOG_STYLE_LIST,"Custom Event Maker 3000!","Start event!\nSet event mode\nMark spawns\nLoadout\nRe-join option\nMax players amount\nTDM skins\nVehicle option\nReset Settings","Select","Close");

		}
		case SKINA_DIALOG:// Skin A
		{
			if(response)
			{
				CEM[SkinA] = strval(inputtext);
				SendClientMessage(playerid, COLOR_GREEN, "Team A skin is set!");
				ShowPlayerDialog(playerid, SKINB_DIALOG, DIALOG_STYLE_INPUT,"Custom Event Maker 3000!","Type the skind ID for team B :","Next","Back");
			}
			else	ShowPlayerDialog(playerid,MAIN_DIALOG,DIALOG_STYLE_LIST,"Custom Event Maker 3000!","Start event!\nSet event mode\nMark spawns\nLoadout\nRe-join option\nMax players amount\nTDM skins\nVehicle option\nReset Settings","Select","Close");

		}
		case SKINB_DIALOG:// Skin B
		{
			if(response)
			{
				CEM[SkinB] = strval(inputtext);
				SendClientMessage(playerid, COLOR_GREEN, "Team B skin is set!");
				ShowPlayerDialog(playerid,MAIN_DIALOG,DIALOG_STYLE_LIST,"Custom Event Maker 3000!","Start event!\nSet event mode\nMark spawns\nLoadout\nRe-join option\nMax players amount\nTDM skins\nVehicle option\nReset Settings","Select","Close");
			}
			else	ShowPlayerDialog(playerid, SKINA_DIALOG, DIALOG_STYLE_INPUT,"Custom Event Maker 3000!","Type the skin ID for team A :","Next","Back");

		}
		case VEHICLEID_DIALOG:// Vehicle ID
		{
			if(response)
			{
				CEM[CEM_VehID] = strval(inputtext);
				if(!CEM[CEM_VehID])	SendClientMessage(playerid, COLOR_GREEN, "	 No Vehicles in the event");
				else	SendClientMessage(playerid, COLOR_GREEN, "Vehicles in the event it is!");
			}
			ShowPlayerDialog(playerid,MAIN_DIALOG,DIALOG_STYLE_LIST,"Custom Event Maker 3000!","Start event!\nSet event mode\nMark spawns\nLoadout\nRe-join option\nMax players amount\nTDM skins\nVehicle option\nReset Settings","Select","Close");

		}
	}
	return 1;
}
// -----------------------------------------------------------------------------

// COMMANDS --------------------------------------------------------------------

// -----------------------------------------------------------------------------
CMD:setch(playerid, params[])//Seting checkpoints for Race and Parkour events
{
	if(IsAdmin(playerid,1))
	{
		if(ChSet<65)
		{
			new string[30];
			GetPlayerPos(playerid, FKu_Checkpoint[ChSet][0], FKu_Checkpoint[ChSet][1], FKu_Checkpoint[ChSet][2]);
			format(string, 30, "Checkpoint %d saved!",ChSet + 1);
			ChSet++;
			SendClientMessage(playerid, COLOR_GREEN, string);
		}
		else SendClientMessage(playerid, COLOR_GREEN, "Max checkpoints are set!");
	}
	return 1;
}

CMD:setpos(playerid, params[])// Seting spawns for FFA, race and parkour events
{
	if(IsAdmin(playerid,1))
	{
		if(PosSet<63)
		{
			new string[30];
			GetPlayerPos(playerid, FKu_Position[PosSet][0], FKu_Position[PosSet][1], FKu_Position[PosSet][2]);
			GetPlayerFacingAngle(playerid, EventAngle[0]);
			format(string, 30, " %d Positions saved!",PosSet + 1);
			PosSet++;
			SendClientMessage(playerid, COLOR_GREEN, string);
			CEM[Interior] = GetPlayerInterior(playerid);
		}
		else SendClientMessage(playerid, COLOR_GREEN, "Max spawns are set!");
	}
	return 1;
}

CMD:setteama(playerid, params[])//Setting the team A spawn in TDM
{
	if(IsAdmin(playerid,1))
	{
		GetPlayerPos(playerid, FKu_Position[64][0], FKu_Position[64][1], FKu_Position[64][2]);
		GetPlayerFacingAngle(playerid, EventAngle[1]);
		CEM[Interior] = GetPlayerInterior(playerid);
		SendClientMessage(playerid, COLOR_GREEN, "Team A Positions saved!");
	}
	return 1;
}

CMD:setteamb(playerid, params[])//Setting the team B spawn in TDM
{
	if(IsAdmin(playerid,1))
	{
		GetPlayerPos(playerid, FKu_Position[65][0], FKu_Position[65][1], FKu_Position[65][2]);
		GetPlayerFacingAngle(playerid, EventAngle[2]);
		SendClientMessage(playerid, COLOR_GREEN, "Team B Positions saved!");
	}
	return 1;
}

CMD:cem(playerid, params[])//The menu command
{
	if(IsAdmin(playerid,1))
	{
		if(FoCo_Event == -1)
		{
			//ShowPlayerDialog(playerid,MAIN_DIALOG,DIALOG_STYLE_LIST,"Custom Event Maker 3000!","Start event!\nSet event mode\nMark spawns\nLoadout\nRe-join option\nMax players amount\nTDM skins\nVehicle option\nReset Settings","Select","Close");
			SendClientMessage(playerid,COLOR_NOTICE, "[INFO] Currently disabled!");
		}
		else	SendClientMessage(playerid, COLOR_NOTICE, "Event is on, try later.");
	}
	return 1;
}

// -----------------------------------------------------------------------------

// STOCK FUNCTIONS -------------------------------------------------------------

// -----------------------------------------------------------------------------

stock RejoinCEvent(playerid)
{
	switch(CEM[Gamemode])
	{
		case 0://TDM
		{
			SetPlayerPos(playerid, FKu_TDMPos[0][playerid], FKu_TDMPos[1][playerid], FKu_TDMPos[2][playerid] + 1);
			SetLoadout(playerid,99.0,99.0);
		}
		case 1://FFA
		{
			new num = random(PosSet);
			SetPlayerTeam(playerid,NOTEAM);
			if(FKu_Position[num][0]+FKu_Position[num][1]+FKu_Position[num][2] == 0.0) num = random(PosSet);
			SetPlayerPos(playerid, FKu_Position[num][0], FKu_Position[num][1], FKu_Position[num][2]);
			SetLoadout(playerid, 99.0, 0.0);
		}
	}
	return 1;
}

stock StartEventStuff()
{
	FoCo_Event = 9;
	Event_InProgress = 0;
	if(CEM[Gamemode]!=1) Event_Delay = 30;
	return 1;
}

stock SetLoadout(playerid, Float:Health, Float:Armour)//Seting the players loadout
{
	SetPlayerHealth(playerid, Health);
	SetPlayerArmour(playerid, Armour);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, CEM[WeaponID], 1500);
	GivePlayerWeapon(playerid, CEM[WeaponID2], 1500);
	GivePlayerWeapon(playerid, CEM[WeaponID3], 1500);
	GivePlayerWeapon(playerid, CEM[WeaponID4], 1500);
	return 0;
}

stock IsNumberEven(Number)//Checking if the number is even or odd
{
	new num = Number % 2;
	if(0 < num)	return 1;
	return 0;
}

stock leavecevent(playerid)
{
	SetPlayerColor(playerid,PlayerColor[playerid]);
	//SetPlayerTeam(playerid,PlayerTeamID[playerid]);
	SetPlayerSkin(playerid,PlayerSkinID[playerid]);
	DestroyVehicle(Event_PlayerVeh[playerid]);
	ChPassed{playerid} = 0;
	SetPVarInt(playerid,"PlayerStatus",0);
	SetPVarInt(playerid, "MotelTeamIssued", 0);
	ResetPlayerWeapons(playerid);
	GiveGuns(playerid);
	SetPlayerHealth(playerid,99);
	SetPlayerPos(playerid, FoCo_Teams[FoCo_Team[playerid]][team_spawn_x], FoCo_Teams[FoCo_Team[playerid]][team_spawn_y], FoCo_Teams[FoCo_Team[playerid]][team_spawn_z]);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, FoCo_Teams[FoCo_Team[playerid]][team_spawn_interior]);
	if(CEM[Gamemode] == 2||CEM[Gamemode] == 3) DisablePlayerRaceCheckpoint(playerid);
	if(CEM[Gamemode] == 2||CEM[Gamemode] == 3) DisablePlayerRaceCheckpoint(playerid);
	return 1;
}

stock clearevent()
{
	CEM_Players = 0;
	CountTEAMA = 0;
	SetTEAMA = 0;
	cTEAMA = 0;
	CountTEAMB = 0;
	SetTEAMB = 0;
	cTEAMB = 0;
	RacePos = 0;
	PosSet = 0;
	ChSet = 0;
	foreach(Player, i)
	{
		if(GetPVarInt(i,"PlayerStatus") == 1)
		{
			leavecevent(i);
		}
	}
	for(new i;i<66;i++)
	{
		FKu_Position[i][0] = 0;
		FKu_Position[i][1] = 0;
		FKu_Position[i][2] = 0;
		FKu_Checkpoint[i][0] = 0;
		FKu_Checkpoint[i][1] = 0;
		FKu_Checkpoint[i][2] = 0;
	}
	return 1;
}

forward JoinCEM(playerid);
public JoinCEM(playerid)//This is the events systems setting all the stuff that are needed for the players in the event
{
	SetPlayerVirtualWorld(playerid,1500);
	SetPlayerInterior(playerid,CEM[Interior]);
	ResetPlayerWeapons(playerid);

	switch(CEM[Gamemode])
	{
		case 0://TDM
		{
			if(!IsNumberEven(CEM_Players))//To split the players to team A
			{
				FKu_Position[64][0] = FKu_Position[64][0] + CEM_spawnalg[SetTEAMA][0];
				FKu_Position[64][1] = FKu_Position[64][1] + CEM_spawnalg[SetTEAMA][1];

				SetPlayerPos(playerid, FKu_Position[64][0], FKu_Position[64][1], FKu_Position[64][2] + 0.5);
				if(CountTEAMA == CEM_spawntimes[cTEAMA])
				{
					SetTEAMA ++;
					CountTEAMA = 1;
					if(SetTEAMA == 4)SetTEAMA = 0;
					cTEAMA ++;
				}
				else CountTEAMA ++;
				//	 a	=-	 -=			b				 =-	 -=		  c		   =-
				0 < CEM[SkinA] && SetPlayerSkin(playerid, CEM[SkinA]) || SetPlayerSkin(playerid, 285);// if a run b, otherwise c

				SetPlayerColor(playerid, 0x008CF5FF);
				//SetPlayerTeam(playerid,TEAMA);
				SetPVarInt(playerid, "MotelTeamIssued", 1);
				SetPlayerFacingAngle(playerid, EventAngle[1]);
				pTEAMA ++;
			}
			else//To split the players to team B
			{
				FKu_Position[65][0] = FKu_Position[65][0] + CEM_spawnalg[SetTEAMB][0];
				FKu_Position[65][1] = FKu_Position[65][1] + CEM_spawnalg[SetTEAMB][1];

				SetPlayerPos(playerid, FKu_Position[65][0], FKu_Position[65][1], FKu_Position[65][2] + 0.25);
				if(CountTEAMB == CEM_spawntimes[cTEAMB])
				{
					SetTEAMB ++;
					CountTEAMB = 1;
					if(SetTEAMB == 4)SetTEAMB = 0;
					cTEAMB ++;
				}
				else CountTEAMB ++;
				//	a	=-	 -=			b				 =-	 -=		  c		   =-
				0 < CEM[SkinB] && SetPlayerSkin(playerid, CEM[SkinB]) || SetPlayerSkin(playerid, 73);// if A run B, otherwise C

				SetPlayerColor(playerid, 0xFF6347FF);
				SetPlayerFacingAngle(playerid, EventAngle[2]);
				//SetPlayerTeam(playerid,TEAMB);
				SetPVarInt(playerid, "MotelTeamIssued", 2);
				pTEAMB++;
			}
			SetLoadout(playerid, 99.0, 99.0);
		}
		case 1://FFA
		{
			new num = random(PosSet);
			if(FKu_Position[num][0]+FKu_Position[num][1]+FKu_Position[num][2] == 0.0) num = random(PosSet);
			SetPlayerPos(playerid, FKu_Position[num][0], FKu_Position[num][1], FKu_Position[num][2]);
			SetLoadout(playerid, 99.0, 0.0);
		}
		case 2, 3://Race, Parkour
		{
			SetPlayerPos(playerid, FKu_Position[CEM_Players - 1][0], FKu_Position[CEM_Players - 1][1], FKu_Position[CEM_Players - 1][2] + 0.5);
			SetPlayerRaceCheckpoint(playerid, 0, FKu_Checkpoint[0][0], FKu_Checkpoint[0][1], FKu_Checkpoint[0][2], FKu_Checkpoint[1][0], FKu_Checkpoint[1][1], FKu_Checkpoint[1][2], 10);
			SetPlayerRaceCheckpoint(playerid, 0, FKu_Checkpoint[0][0], FKu_Checkpoint[0][1], FKu_Checkpoint[0][2], FKu_Checkpoint[1][0], FKu_Checkpoint[1][1], FKu_Checkpoint[1][2], 10);

			SetPlayerHealth(playerid,99.0);
			SetPlayerArmour(playerid,99.0);
			SetPlayerFacingAngle(playerid, EventAngle[0]);
			if(CEM[Gamemode] == 2)// If racing mode then it spawns a vehicle
			{
				Event_PlayerVeh[playerid] = CreateVehicle(CEM[CEM_VehID], FKu_Position[CEM_Players - 1][0], FKu_Position[CEM_Players - 1][1], FKu_Position[CEM_Players - 1][2], EventAngle[0], random(150), random(150), 0);
				SetVehicleVirtualWorld(Event_PlayerVeh[playerid],1500);
				PutPlayerInVehicle(playerid, Event_PlayerVeh[playerid], 0);
				AddVehicleComponent(Event_PlayerVeh[playerid], 1010);
			}
		}
	}
	return 1;
}
