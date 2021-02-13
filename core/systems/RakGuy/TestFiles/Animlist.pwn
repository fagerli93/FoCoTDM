/*
Credits:
    G.O (SA-MP) - Animations
	RakGuy (FTDM) - Script
*/
// Includes
#include <YSI\y_hooks>

// Specific Anims defines
#define PLAYER_STATUS_NORMAL 0
#define SPECIAL_ACTION_PISSING 68



/*debug

public OnPlayerConnect(playerid)
{
    SetPVarInt(playerid, "PlayerStatus", PLAYER_STATUS_NORMAL);
	return 1;
}

CMD:status(playerid, params[])
{
    SetPVarInt(playerid, "PlayerStatus", (GetPVarInt(playerid, "PlayerStatus") == PLAYER_STATUS_NORMAL) ? (1) : (PLAYER_STATUS_NORMAL));
	return 1;
}
End of Debug*/


CMD:animlist(playerid, params[])
{
	SendClientMessage(playerid, COLOR_WARNING, "//-----------------------------------ANIM LIST------------------------------------------//");
	SendClientMessage(playerid, COLOR_SYNTAX, "/aim[1-2], /akick, /angry, /bar[1-4], /basket[1-6], /bat[1-5], /bed[1-4], /benddown,");
	SendClientMessage(playerid, COLOR_SYNTAX, "/bitchslap, /bj[1-4], /bomb, /box, /carsit[1-2], /carsmoke, /celebrate[1-2], /cellin,");
	SendClientMessage(playerid, COLOR_SYNTAX, "/cellout, /chairsit[1-2], /chant, /chat, /checkout, /cockgun, /cpr, /crack[1-2],");
	SendClientMessage(playerid, COLOR_SYNTAX, "/crossarms[1-3], /cry[1-2], /dance [1-4], /deal[1-2], /die[1-2], /drunk, /eat, /eatsit,");
	SendClientMessage(playerid, COLOR_SYNTAX, "/exhausted, /follow, /fsit, /fucku, /fwalk, /gang[1-7], /getarrested, /getup, /ghand[1-5],");
	SendClientMessage(playerid, COLOR_SYNTAX, "/gift, /greet, /gsign[1-5], /gwalk[1-2], /handsup, /hitch, /injured[1-2], /ainvite[1-2],");
	SendClientMessage(playerid, COLOR_SYNTAX, "/joint, /kiss[1-7], /laugh, /lay[1-2], /lean, /liftup, /limp, /lookout, /msit, /mwalk,");
	SendClientMessage(playerid, COLOR_SYNTAX, "/nod, /piss, /putdown, /rap[1-3], /relax, /robman, /scratch, /sexy[1-8], /shakehead,");
	SendClientMessage(playerid, COLOR_SYNTAX, "/sit, /skate, /slapass, /slapped, /smokef, /smokem, /stand, /stopanim, /strip[1-7],");
	SendClientMessage(playerid, COLOR_SYNTAX, "/stretch, /taichi, /thankyou, /vomit, /wank, /wankoff, /wave, /win, /win2, /yes");
	SendClientMessage(playerid, COLOR_WARNING, "//-----------------------------------ANIM LIST------------------------------------------//");
	return 1;
}

stock C_ApplyAnimation(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 1)
{
	if(GetPVarInt(playerid, "PlayerStatus") == PLAYER_STATUS_NORMAL)
	{
	    new Float:Speeed[3];
		GetPlayerVelocity(playerid, Speeed[0], Speeed[1], Speeed[2]);
		if(Speeed[0] == 0.0 &&  Speeed[1] == 0.0 && Speeed[2] == 0.0)
		{
		    if(!IsPlayerInAnyVehicle(playerid))
		    {
				if(GetPVarInt(playerid, "PlayerStatus") == 2 || GetPVarInt(playerid, "PlayerStatus") == 1) return 1;
				if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
				{
					return 1;
				}

				if(playerid == vista_CarePackage_Main[pCapturing])
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command while capturing the care package.");
					return 1;
				}
		        ClearAnimations(playerid);
		        ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
		    }
		    else
		        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not use this command while you are in a vehicle.");
		}
		else
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not use this command while you are moving");
	}
	else
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can only use this command in Normal-World");
	return 1;
}

stock C_ClearAnimations(playerid)
{
	if(GetPVarInt(playerid, "PlayerStatus") == PLAYER_STATUS_NORMAL)
	{
	    new Float:Speeed[3];
		GetPlayerVelocity(playerid, Speeed[0], Speeed[1], Speeed[2]);
		if(Speeed[2] == 0.0)
		{
		    if(!IsPlayerInAnyVehicle(playerid))
		    {
				if(GetPVarInt(playerid, "PlayerStatus") == 2 || GetPVarInt(playerid, "PlayerStatus") == 1) return 1;
				if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
				{
					return 1;
				}

				if(playerid == vista_CarePackage_Main[pCapturing])
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command while capturing the care package.");
					return 1;
				}
		        ClearAnimations(playerid);
		        StopLoopingAnim(playerid);
		    }
		    else
		        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not use this command while you are in a vehicle.");
		}
		else
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not use this command while you are moving");
	}
	else
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can only use this command in Normal-World");
	return 1;
}


stock C_SetPlayerSpecialAction(playerid, actionid)
{
	if(GetPVarInt(playerid, "PlayerStatus") == PLAYER_STATUS_NORMAL)
	{
	    new Float:Speeed[3];
		GetPlayerVelocity(playerid, Speeed[0], Speeed[1], Speeed[2]);
		if(Speeed[0] == 0.0 &&  Speeed[1] == 0.0 && Speeed[2] == 0.0)
		{
		    if(!IsPlayerInAnyVehicle(playerid))
		    {
				if(GetPVarInt(playerid, "PlayerStatus") == 2 || GetPVarInt(playerid, "PlayerStatus") == 1) return 1;
				if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
				{
					return 1;
				}

				if(playerid == vista_CarePackage_Main[pCapturing])
				{
					SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command while capturing the care package.");
					return 1;
				}
		        SetPlayerSpecialAction(playerid, actionid);
		    }
		    else
		        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not use this command while you are in a vehicle.");
		}
		else
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not use this command while you are moving");
	}
	else
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can only use this command in Normal-World");
	return 1;
}

CMD:stopanim(playerid, params[])
{
	C_ClearAnimations(playerid);
	return 1;
}

CMD:anims(playerid, params[])
{
	cmd_animlist(playerid, params);
	return 1;
}

CMD:hide(playerid, params[])
{
	C_ApplyAnimation(playerid, "ped", "cower",4.0,1,1,1,1,0);
	return 1;
}

CMD:fu(playerid, params[])
{
	C_ApplyAnimation(playerid, "PED","fucku",4.0,1,1,1,1,0);
	return 1;
}

CMD:drink(playerid, params[])
{
	C_ApplyAnimation(playerid, "BAR","dnk_stndF_loop",4.0,1,1,1,1,0);
	return 1;
}

CMD:sleep(playerid, params[])
{
	C_ApplyAnimation(playerid, "INT_HOUSE","BED_Loop_R",4.0,1,1,1,1,0);
	return 1;
}


CMD:handsup(playerid, params[])
{
	C_SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
	return 1;
}

CMD:dance(playerid, params[])
{
	new value;
	if(sscanf(params, "i", value))
	{
		new msgstring[128];
		format(msgstring, sizeof(msgstring), "[USAGE]: {%06x}/dance {%06x}[1-4]", COLOR_WHITE >>> 8, COLOR_SYNTAX >>> 8);
		SendClientMessage(playerid, COLOR_SYNTAX, msgstring);
		return 1;
	}

	switch(value)
	{
		case 1:
		{
			C_SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE1);
		}
		case 2:
		{
			C_SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE2);
		}
		case 3:
		{
			C_SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE3);
		}
		case 4:
		{
			C_SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE4);
		}
	}
	return 1;
}
CMD:rap1(playerid, params[])
{
	C_ApplyAnimation(playerid, "RAPPING", "RAP_A_Loop",4.0,1,1,1,1,0);
	return 1;
}

CMD:rap2(playerid, params[])
{
	C_ApplyAnimation(playerid, "RAPPING", "RAP_B_Loop",4.0,1,1,1,1,0);
	return 1;
}

CMD:rap3(playerid, params[])
{
	C_ApplyAnimation(playerid, "RAPPING", "RAP_C_Loop",4.0,1,1,1,1,0);
	return 1;
}

CMD:wankoff(playerid, params[])
{
	C_ApplyAnimation(playerid, "PAULNMAC", "wank_in",4.0,1,1,1,1,0);
	return 1;
}

CMD:wank(playerid, params[])
{
	C_ApplyAnimation(playerid, "PAULNMAC", "wank_loop",4.0,1,1,1,1,0);
	return 1;
}

CMD:strip1(playerid, params[])
{
	C_ApplyAnimation(playerid, "STRIP", "strip_A",4.0,1,1,1,1,0);
	return 1;
}

CMD:strip2(playerid, params[])
{
	C_ApplyAnimation(playerid, "STRIP", "strip_B",4.0,1,1,1,1,0);
	return 1;
}

CMD:strip3(playerid, params[])
{
	C_ApplyAnimation(playerid, "STRIP", "strip_C",4.0,1,1,1,1,0);
	return 1;
}

CMD:strip4(playerid, params[])
{
	C_ApplyAnimation(playerid, "STRIP", "strip_D",4.0,1,1,1,1,0);
	return 1;
}

CMD:strip5(playerid, params[])
{
	C_ApplyAnimation(playerid, "STRIP", "strip_E",4.0,1,1,1,1,0);
	return 1;
}

CMD:strip6(playerid, params[])
{
	C_ApplyAnimation(playerid, "STRIP", "strip_F",4.0,1,1,1,1,0);
	return 1;
}

CMD:strip7(playerid, params[])
{
	C_ApplyAnimation(playerid, "STRIP", "strip_G",4.0,1,1,1,1,0);
	return 1;
}

CMD:sexy1(playerid, params[])
{
	C_ApplyAnimation(playerid, "SNM", "SPANKING_IDLEW",4.1,0,1,1,1,1);
	return 1;
}

CMD:sexy2(playerid, params[])
{
	C_ApplyAnimation(playerid, "SNM", "SPANKING_IDLEP",4.1,0,1,1,1,1);
	return 1;
}

CMD:sexy3(playerid, params[])
{
	C_ApplyAnimation(playerid, "SNM", "SPANKINGW",4.1,0,1,1,1,1);
	return 1;
}

CMD:sexy4(playerid, params[])
{
	C_ApplyAnimation(playerid, "SNM", "SPANKINGP",4.1,0,1,1,1,1);
	return 1;
}

CMD:sexy5(playerid, params[])
{
	C_ApplyAnimation(playerid, "SNM", "SPANKEDW",4.1,0,1,1,1,1);
	return 1;
}

CMD:sexy6(playerid, params[])
{
	C_ApplyAnimation(playerid, "SNM", "SPANKEDP",4.1,0,1,1,1,1);
	return 1;
}

CMD:sexy7(playerid, params[])
{
	C_ApplyAnimation(playerid, "SNM", "SPANKING_ENDW",4.1,0,1,1,1,1);
	return 1;
}

CMD:sexy8(playerid, params[])
{
	C_ApplyAnimation(playerid, "SNM", "SPANKING_ENDP",4.1,0,1,1,1,1);
	return 1;
}

CMD:bj1(playerid, params[])
{
	C_ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_START_P",4.1,0,1,1,1,1);
	return 1;
}

CMD:bj2(playerid, params[])
{
	C_ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_START_W",4.1,0,1,1,1,1);
	return 1;
}

CMD:bj3(playerid, params[])
{
	C_ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_P",4.1,0,1,1,1,1);
	return 1;
}

CMD:bj4(playerid, params[])
{
	C_ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_W",4.1,0,1,1,1,1);
	return 1;
}

CMD:cellin(playerid, params[])
{
	C_SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
	return 1;
}

CMD:cellout(playerid, params[])
{
	C_SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
	return 1;
}

CMD:lean(playerid, params[])
{
	C_ApplyAnimation(playerid, "GANGS", "leanIDLE", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:piss(playerid, params[])
{
	C_SetPlayerSpecialAction(playerid, 68);
	return 1;
}

CMD:follow(playerid, params[])
{
	C_ApplyAnimation(playerid, "WUZI", "Wuzi_follow",4.0,0,0,0,0,0);
	return 1;
}

CMD:greet(playerid, params[])
{
	C_ApplyAnimation(playerid, "WUZI", "Wuzi_Greet_Wuzi",4.0,0,0,0,0,0);
	return 1;
}

CMD:stand(playerid, params[])
{
	C_ApplyAnimation(playerid, "WUZI", "Wuzi_stand_loop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:injured2(playerid, params[])
{
	C_ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:hitch(playerid, params[])
{
	C_ApplyAnimation(playerid, "MISC", "Hiker_Pose", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:bitchslap(playerid, params[])
{
	C_ApplyAnimation(playerid, "MISC", "bitchslap",4.0,0,0,0,0,0);
	return 1;
}

CMD:cpr(playerid, params[])
{
	C_ApplyAnimation(playerid, "MEDIC", "CPR", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:gsign1(playerid, params[])
{
	C_ApplyAnimation(playerid, "GHANDS", "gsign1",4.0,0,1,1,1,1);
	return 1;
}

CMD:gsign2(playerid, params[])
{
	C_ApplyAnimation(playerid, "GHANDS", "gsign2",4.0,0,1,1,1,1);
	return 1;
}

CMD:gsign3(playerid, params[])
{
	C_ApplyAnimation(playerid, "GHANDS", "gsign3",4.0,0,1,1,1,1);
	return 1;
}

CMD:gsign4(playerid, params[])
{
	C_ApplyAnimation(playerid, "GHANDS", "gsign4",4.0,0,1,1,1,1);
	return 1;
}

CMD:gsign5(playerid, params[])
{
	C_ApplyAnimation(playerid, "GHANDS", "gsign5",4.0,0,1,1,1,1);
	return 1;
}

CMD:gift(playerid, params[])
{
	C_ApplyAnimation(playerid, "KISSING", "gift_give",4.0,0,0,0,0,0);
	return 1;
}

CMD:chairsit1(playerid, params[])
{
	C_ApplyAnimation(playerid, "PED", "SEAT_idle", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:injured1(playerid, params[]) {

	C_ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:slapped(playerid, params[])
{
	C_ApplyAnimation(playerid, "SWEET", "ho_ass_slapped",4.0,0,0,0,0,0);
	return 1;
}

CMD:slapass(playerid, params[])
{
	C_ApplyAnimation(playerid, "SWEET", "sweet_ass_slap",4.0,0,0,0,0,0);
	return 1;
}

CMD:drunk(playerid, params[])
{
	C_ApplyAnimation(playerid, "PED", "WALK_DRUNK",4.1,1,1,1,1,1);
	return 1;
}

CMD:skate(playerid, params[])
{
	C_ApplyAnimation(playerid, "SKATE", "skate_run",4.1,1,1,1,1,1);
	return 1;
}

CMD:gwalk1(playerid, params[]) {
	C_ApplyAnimation(playerid, "PED", "WALK_gang1",4.1,1,1,1,1,1);
	return 1;
}

CMD:gwalk2(playerid, params[])
{
	C_ApplyAnimation(playerid, "PED", "WALK_gang2",4.1,1,1,1,1,1);
	return 1;
}

CMD:limp(playerid, params[])
{
	C_ApplyAnimation(playerid, "PED", "WALK_old",4.1,1,1,1,1,1);
	return 1;
}

CMD:eatsit(playerid, params[])
{
	C_ApplyAnimation(playerid, "FOOD", "FF_Sit_Loop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:celebrate1(playerid, params[])
{
	C_ApplyAnimation(playerid, "benchpress", "gym_bp_celebrate", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:win(playerid, params[])
{
	C_ApplyAnimation(playerid, "CASINO", "cards_win", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:win2(playerid, params[])
{
	C_ApplyAnimation(playerid, "CASINO", "Roulette_win", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:yes(playerid, params[])
{
	C_ApplyAnimation(playerid, "CLOTHES", "CLO_Buy", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:deal2(playerid, params[])
{
	C_ApplyAnimation(playerid, "DEALER", "DRUGS_BUY", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:thankyou(playerid, params[])
{
	C_ApplyAnimation(playerid, "FOOD", "SHP_Thank", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:invite1(playerid, params[])
{
	C_ApplyAnimation(playerid, "GANGS", "Invite_Yes",4.1,0,1,1,1,1);
	return 1;
}

CMD:invite2(playerid, params[])
{
	C_ApplyAnimation(playerid, "GANGS", "Invite_No",4.1,0,1,1,1,1);
	return 1;
}

CMD:celebrate2(playerid, params[])
{
	C_ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_celebrate", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:sit(playerid, params[])
{
	C_ApplyAnimation(playerid, "INT_OFFICE", "OFF_Sit_Type_Loop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:scratch(playerid, params[])
{
	C_ApplyAnimation(playerid, "MISC", "Scratchballs_01", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:bomb(playerid, params[])
{
	ClearAnimations(playerid);
	C_ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0); // Place Bomb
	return 1;
}

CMD:getarrested(playerid, params[])
{
	C_ApplyAnimation(playerid, "ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1); // Gun Arrest
	return 1;
}

CMD:laugh(playerid, params[])
{
	C_ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0); // Laugh
	return 1;
}

CMD:lookout(playerid, params[])
{
	C_ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0); // Rob Lookout
	return 1;
}

CMD:robman(playerid, params[])
{
	C_ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0); // Rob
	return 1;
}

CMD:crossarms1(playerid, params[])
{
	C_ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1); // Arms crossed
	return 1;
}

CMD:crossarms2(playerid, params[])
{
	C_ApplyAnimation(playerid, "DEALER", "DEALER_IDLE", 4.0, 0, 1, 1, 1, -1); // Arms crossed 2
	return 1;
}

CMD:crossarms3(playerid, params[])
{
	C_ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_01", 4.0, 0, 1, 1, 1, -1); // Arms crossed 3
	return 1;
}

CMD:lay1(playerid, params[])
{
	C_ApplyAnimation(playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0); // Lay down
	return 1;
}

CMD:vomit(playerid, params[])
{
	C_ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0); // Vomit
	return 1;
}

CMD:eat(playerid, params[])
{
	C_ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0); // Eat Burger
	return 1;
}

CMD:wave(playerid, params[])
{
	C_ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0); // Wave
	return 1;
}

CMD:deal1(playerid, params[])
{
	C_ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 3.0, 0, 0, 0, 0, 0); // Deal Drugs
	return 1;
}

CMD:crack1(playerid, params[])
{
	C_ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0); // Dieing of Crack
	return 1;
}

CMD:smokem(playerid, params[])
{
	C_ApplyAnimation(playerid, "SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0); // Smoke
	return 1;
}

CMD:smokef(playerid, params[])
{
	C_ApplyAnimation(playerid, "SMOKING", "F_smklean_loop", 4.0, 1, 0, 0, 0, 0); // Female Smoking
	return 1;
}

CMD:msit(playerid, params[])
{
	C_ApplyAnimation(playerid, "BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0); // Male Sit
	return 1;
}

CMD:fsit(playerid, params[])
{
	C_ApplyAnimation(playerid, "BEACH", "ParkSit_W_loop", 4.0, 1, 0, 0, 0, 0); // Female Sit
	return 1;
}

CMD:chat(playerid, params[])
{
	C_ApplyAnimation(playerid, "PED", "IDLE_CHAT",4.1,1,1,1,1,1);
	return 1;
}

CMD:fucku(playerid, params[])
{
	C_ApplyAnimation(playerid, "PED", "fucku",4.0,0,0,0,0,0);
	return 1;
}

CMD:taichi(playerid, params[])
{
	C_ApplyAnimation(playerid, "PARK", "Tai_Chi_Loop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:chairsit2(playerid, params[])
{
	C_ApplyAnimation(playerid, "BAR", "dnk_stndF_loop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:relax(playerid, params[])
{
	C_ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:bat1(playerid, params[])
{
	C_ApplyAnimation(playerid, "BASEBALL", "Bat_IDLE", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:bat2(playerid, params[])
{
	C_ApplyAnimation(playerid, "BASEBALL", "Bat_M", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:bat3(playerid, params[])
{
	C_ApplyAnimation(playerid, "BASEBALL", "BAT_PART", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:bat4(playerid, params[])
{
	C_ApplyAnimation(playerid, "CRACK", "Bbalbat_Idle_01", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:bat5(playerid, params[])
{
	C_ApplyAnimation(playerid, "CRACK", "Bbalbat_Idle_02", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:nod(playerid, params[])
{
	C_ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_nod",4.0,0,0,0,0,0);
	return 1;
}

CMD:gang1(playerid, params[])
{
	C_ApplyAnimation(playerid, "GANGS", "hndshkaa",4.0,0,0,0,0,0);
	return 1;
}

CMD:gang2(playerid, params[])
{
	C_ApplyAnimation(playerid, "GANGS", "hndshkba",4.0,0,0,0,0,0);
	return 1;
}

CMD:gang3(playerid, params[])
{
	C_ApplyAnimation(playerid, "GANGS", "hndshkca",4.0,0,0,0,0,0);
	return 1;
}

CMD:gang4(playerid, params[])
{
	C_ApplyAnimation(playerid, "GANGS", "hndshkcb",4.0,0,0,0,0,0);
	return 1;
}

CMD:gang5(playerid, params[])
{
	C_ApplyAnimation(playerid, "GANGS", "hndshkda",4.0,0,0,0,0,0);
	return 1;
}

CMD:gang6(playerid, params[])
{
	C_ApplyAnimation(playerid, "GANGS", "hndshkea",4.0,0,0,0,0,0);
	return 1;
}

CMD:gang7(playerid, params[])
{
	C_ApplyAnimation(playerid, "GANGS", "hndshkfa",4.0,0,0,0,0,0);
	return 1;
}

CMD:cry1(playerid, params[])
{
	C_ApplyAnimation(playerid, "GRAVEYARD", "mrnF_loop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:cry2(playerid, params[])
{
	C_ApplyAnimation(playerid, "GRAVEYARD", "mrnM_loop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:bed1(playerid, params[])
{
	C_ApplyAnimation(playerid, "INT_HOUSE", "BED_In_L",4.1,0,1,1,1,1);
	return 1;
}

CMD:bed2(playerid, params[])
{
	C_ApplyAnimation(playerid, "INT_HOUSE", "BED_In_R",4.1,0,1,1,1,1);
	return 1;
}

CMD:bed3(playerid, params[])
{
	C_ApplyAnimation(playerid, "INT_HOUSE", "BED_Loop_L", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:bed4(playerid, params[])
{
	C_ApplyAnimation(playerid, "INT_HOUSE", "BED_Loop_R", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:kiss2(playerid, params[])
{
	C_ApplyAnimation(playerid, "BD_FIRE", "Grlfrd_Kiss_03",4.0,0,0,0,0,0);
	return 1;
}

CMD:kiss3(playerid, params[])
{

	C_ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_01",4.0,0,0,0,0,0);
	return 1;
}

CMD:kiss4(playerid, params[])
{
	C_ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_02",4.0,0,0,0,0,0);
	return 1;
}

CMD:kiss5(playerid, params[])
{
	C_ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_03",4.0,0,0,0,0,0);
	return 1;
}

CMD:kiss6(playerid, params[])
{
	C_ApplyAnimation(playerid, "KISSING", "Playa_Kiss_01",4.0,0,0,0,0,0);
	return 1;
}

CMD:kiss7(playerid, params[])
{
	C_ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02",4.0,0,0,0,0,0);
	return 1;
}

CMD:kiss1(playerid, params[])
{
	C_ApplyAnimation(playerid, "KISSING", "Playa_Kiss_03",4.0,0,0,0,0,0);
	return 1;
}

CMD:carsit1(playerid, params[])
{
	C_ApplyAnimation(playerid, "CAR", "Tap_hand", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:carsit2(playerid, params[])
{
	C_ApplyAnimation(playerid, "LOWRIDER", "Sit_relaxed", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:fwalk(playerid, params[])
{
	C_ApplyAnimation(playerid, "ped", "WOMAN_walksexy",4.1,1,1,1,1,1);
	return 1;
}

CMD:mwalk(playerid, params[])
{
	C_ApplyAnimation(playerid, "ped", "WALK_player",4.1,1,1,1,1,1);
	return 1;
}

CMD:stretch(playerid, params[])
{
	C_ApplyAnimation(playerid, "PLAYIDLES", "stretch",4.0,0,0,0,0,0);
	return 1;
}

CMD:chant(playerid, params[])
{
	C_ApplyAnimation(playerid, "RIOT", "RIOT_CHANT", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:angry(playerid, params[])
{
	C_ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY",4.0,0,0,0,0,0);
	return 1;
}

CMD:crack2(playerid, params[])
{
	C_ApplyAnimation(playerid, "CRACK", "crckidle2", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:ghand1(playerid, params[])
{
	C_ApplyAnimation(playerid, "GHANDS", "gsign1LH",4.0,0,1,1,1,1);
	return 1;
}

CMD:ghand2(playerid, params[])
{
	C_ApplyAnimation(playerid, "GHANDS", "gsign2LH",4.0,0,1,1,1,1);
	return 1;
}
CMD:ghand3(playerid, params[])
{
	C_ApplyAnimation(playerid, "GHANDS", "gsign3LH",4.0,0,1,1,1,1);
	return 1;
}

CMD:ghand4(playerid, params[])
{
	C_ApplyAnimation(playerid, "GHANDS", "gsign4LH",4.0,0,1,1,1,1);
	return 1;
}

CMD:ghand5(playerid, params[])
{
	C_ApplyAnimation(playerid, "GHANDS", "gsign5LH",4.0,0,1,1,1,1);
	return 1;
}

CMD:exhausted(playerid, params[])
{
	C_ApplyAnimation(playerid, "FAT", "IDLE_tired", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:carsmoke(playerid, params[])
{
	C_ApplyAnimation(playerid, "PED", "Smoke_in_car", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:aim1(playerid, params[])
{
	C_ApplyAnimation(playerid, "PED", "gang_gunstand", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:getup(playerid, params[])
{
	C_ApplyAnimation(playerid, "PED", "getup",4.0,0,0,0,0,0);
	return 1;
}

CMD:basket1(playerid, params[])
{
	C_ApplyAnimation(playerid, "BSKTBALL", "BBALL_def_loop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:basket2(playerid, params[])
{
	C_ApplyAnimation(playerid, "BSKTBALL", "BBALL_idleloop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

CMD:basket3(playerid, params[])
{
	C_ApplyAnimation(playerid, "BSKTBALL", "BBALL_pickup",4.0,0,0,0,0,0);
	return 1;
}

CMD:basket4(playerid, params[])
{
	C_ApplyAnimation(playerid, "BSKTBALL", "BBALL_Jump_Shot",4.0,0,0,0,0,0);
	return 1;
}

CMD:basket5(playerid, params[])
{
	C_ApplyAnimation(playerid, "BSKTBALL", "BBALL_Dnk",4.1,0,1,1,1,1);
	return 1;
}

CMD:basket6(playerid, params[])
{
	C_ApplyAnimation(playerid, "BSKTBALL", "BBALL_run",4.1,1,1,1,1,1);
	return 1;
}

CMD:akick(playerid, params[])
{
	C_ApplyAnimation(playerid, "FIGHT_E", "FightKick",4.0,0,0,0,0,0);
	return 1;
}

CMD:box(playerid, params[])
{
	C_ApplyAnimation(playerid, "GYMNASIUM", "gym_shadowbox",4.1,1,1,1,1,1);
	return 1;
}

CMD:cockgun(playerid, params[])
{
	C_ApplyAnimation(playerid, "SILENCED", "Silence_reload", 3.0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:bar1(playerid, params[])
{
	C_ApplyAnimation(playerid, "BAR", "Barcustom_get", 3.0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:bar2(playerid, params[])
{
	C_ApplyAnimation(playerid, "BAR", "Barcustom_order", 3.0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:bar3(playerid, params[])
{
	C_ApplyAnimation(playerid, "BAR", "Barserve_give", 3.0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:bar4(playerid, params[])
{
	C_ApplyAnimation(playerid, "BAR", "Barserve_glass", 3.0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:lay2(playerid, params[])
{
	C_ApplyAnimation(playerid, "BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0); // Lay down
	return 1;
}

CMD:liftup(playerid, params[])
{
	C_ApplyAnimation(playerid, "CARRY", "liftup", 3.0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:putdown(playerid, params[])
{
	C_ApplyAnimation(playerid, "CARRY", "putdwn", 3.0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:joint(playerid, params[])
{
	C_ApplyAnimation(playerid, "GANGS", "smkcig_prtl",4.0,0,1,1,1,1);
	return 1;
}

CMD:die1(playerid, params[])
{
	C_ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die",4.1,0,1,1,1,1);
	return 1;
}

CMD:shakehead(playerid, params[])
{
	C_ApplyAnimation(playerid, "MISC", "plyr_shkhead", 3.0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:die2(playerid, params[])
{
	C_ApplyAnimation(playerid, "PARACHUTE", "FALL_skyDive_DIE", 4.0, 0, 1, 1, 1, -1);
	return 1;
}

CMD:aim2(playerid, params[])
{
	C_ApplyAnimation(playerid, "SHOP", "SHP_Gun_Aim", 4.0, 0, 1, 1, 1, -1);
	return 1;
}

CMD:benddown(playerid, params[])
{
	C_ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:checkout(playerid, params[])
{
	C_ApplyAnimation(playerid, "GRAFFITI", "graffiti_Chkout", 4.0, 0, 0, 0, 0, 0);
	return 1;
}
//Additional
CMD:aim(playerid, params[])
{
	return cmd_aim1(playerid, params);
}

CMD:bar(playerid, params[])
{
	return cmd_bar1(playerid, params);
}

CMD:basket(playerid, params[])
{
	return cmd_basket(playerid, params);
}


CMD:bat(playerid, params[])
{
	return cmd_bat1(playerid, params);
}


CMD:bed(playerid, params[])
{
	return cmd_bed1(playerid, params);
}


CMD:bj(playerid, params[])
{
	return cmd_bj1(playerid, params);
}


CMD:carsit(playerid, params[])
{
	return cmd_carsit1(playerid, params);
}

CMD:crack(playerid, params[])
{
	return cmd_crack1(playerid, params);
}

CMD:celebrate(playerid, params[])
{
	return cmd_celebrate1(playerid, params);
}

CMD:chairsit(playerid, params[])
{
	return cmd_chairsit1(playerid, params);
}

CMD:crossarms(playerid, params[])
{
	return cmd_crossarms1(playerid, params);
}

CMD:cry(playerid, params[])
{
	return cmd_cry1(playerid, params);
}

CMD:deal(playerid, params[])
{
	return cmd_deal1(playerid, params);
}


CMD:die(playerid, params[])
{
	return cmd_die1(playerid, params);
}

CMD:gang(playerid, params[])
{
	return cmd_gang1(playerid, params);
}

CMD:ghand(playerid, params[])
{
	return cmd_ghand1(playerid, params);
}


CMD:gsign(playerid, params[])
{
	return cmd_gsign1(playerid, params);
}


CMD:gwalk(playerid, params[])
{
	return cmd_gwalk1(playerid, params);
}


CMD:injured(playerid, params[])
{
	return cmd_injured1(playerid, params);
}

CMD:ainvite(playerid, params[])
{
	return cmd_invite1(playerid, params);
}

CMD:kiss(playerid, params[])
{
	return cmd_kiss1(playerid, params);
}


CMD:lay(playerid, params[])
{
	return cmd_lay1(playerid, params);
}


CMD:rap(playerid, params[])
{
	return cmd_rap1(playerid, params);
}


CMD:sexy(playerid, params[])
{
	return cmd_sexy1(playerid, params);
}

CMD:strip(playerid, params[])
{
	return cmd_strip1(playerid, params);
}
