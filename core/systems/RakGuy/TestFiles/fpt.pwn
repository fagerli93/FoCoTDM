#include <YSI\y_hooks>

#define MAX_FPS_STRIKE 5
#define abs(%1) \
		(((%1) < 0) ? (-(%1)) : ((%1)))
#define COLOR_FPT 			0xCCCCCCFF
#define MINIMUM_FPS_LIMIT 	20
#define MAXIMUM_FPS_LIMIT	103
#define MAXIMUM_PING_JUMP	60

new Text3D:FPT_ID[MAX_PLAYERS];
new bool:FPT_Disabled[MAX_PLAYERS];
new bool:FPT_DisableOverRide[MAX_PLAYERS];
new FPT_PF[MAX_PLAYERS][2]; 		//	0 = Ping - 1 = FPS
new FPT_PFStrike[MAX_PLAYERS][2];	//		^^^^^^^^^^
new LastPing_Drunk[MAX_PLAYERS][2]; //	0 = Ping - 1 = Drunk
new FPS_HackStrike[MAX_PLAYERS];
new FPT_msg[196];

stock FPT_RemovePlayer3D(playerid)
{
	if(_:FPT_ID[playerid] != -1)
	{
		if(IsValidDynamic3DTextLabel(FPT_ID[playerid]))
		{
		    FPT_Disabled[playerid]=true;
			DestroyDynamic3DTextLabel(FPT_ID[playerid]);
			FPT_ID[playerid] = Text3D:-1;
		}
	}
	return 1;
}

stock FPT_RemoveFromAll(playerid)
{
	foreach(Player, targetid)
	{
	    if(IsValidDynamic3DTextLabel(FPT_ID[targetid]) && targetid!=playerid)
			Streamer_RemoveArrayData(STREAMER_TYPE_3D_TEXT_LABEL, FPT_ID[targetid], E_STREAMER_PLAYER_ID, playerid), Streamer_Update(targetid);
	}
    Streamer_Update(playerid);
	return 1;
}

stock FPT_AppendToAll(playerid)
{
	foreach(Player, targetid)
	{
		if(FPT_Disabled[playerid] == false)
			if(IsValidDynamic3DTextLabel(FPT_ID[targetid])&& targetid!=playerid)
				Streamer_AppendArrayData(STREAMER_TYPE_3D_TEXT_LABEL, FPT_ID[targetid], E_STREAMER_PLAYER_ID, playerid), Streamer_Update(targetid);
	}
    Streamer_Update(playerid);
	return 1;
}

stock UpdateCreateTextLableForAll(targetid)
{
	if(FPT_DisableOverRide[targetid] == false)
	{
		new MSG_FPT[25];
		format(MSG_FPT, sizeof(MSG_FPT), "PING: %i\nFPS: %i", FPT_PF[targetid][0], FPT_PF[targetid][1]);
		if(_:FPT_ID[targetid] == -1)
		{
			FPT_ID[targetid]=CreateDynamic3DTextLabelEx(MSG_FPT, COLOR_FPT, 0.0, 0.0, -0.5, 50.0, targetid, INVALID_VEHICLE_ID,1, 150.0, {-1}, {-1}, {MAX_PLAYERS - 1});
			foreach(Player, playerid)
			{
			    if(FPT_Disabled[playerid] == false)
					Streamer_AppendArrayData(STREAMER_TYPE_3D_TEXT_LABEL, FPT_ID[targetid], E_STREAMER_PLAYER_ID, playerid);
				else
				    Streamer_RemoveArrayData(STREAMER_TYPE_3D_TEXT_LABEL, FPT_ID[targetid], E_STREAMER_PLAYER_ID, playerid);
				Streamer_Update(playerid);
			}
			FPT_AppendToAll(targetid);
			Streamer_Update(targetid);
			//Attach3DTextLabelToPlayer(FPT_ID[targetid], targetid, 0.0, 0.0,0.3);
		}
		else
		{
		    UpdateDynamic3DTextLabelText(FPT_ID[targetid], COLOR_FPT, MSG_FPT);
		}
	}
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	FPT_RemoveFromAll(playerid);
	FPT_RemovePlayer3D(playerid);
	return 1;
}

hook OnPlayerConnect(playerid)
{
	FPT_RemoveFromAll(playerid);
	FPT_RemovePlayer3D(playerid);
	UpdateCreateTextLableForAll(playerid);
	return 1;
}
		
ptask UpdateFPTText[1000](playerid)
{
	if(FPT_Disabled[playerid] == false && FPT_DisableOverRide[playerid] == false)
	{
		new drunklevel	= GetPlayerDrunkLevel(playerid),
			ping		= GetPlayerPing(playerid),
			fps 		= LastPing_Drunk[playerid][1] - drunklevel,
			pingdiff	= LastPing_Drunk[playerid][0] - ping;
		LastPing_Drunk[playerid][1] = drunklevel;
		LastPing_Drunk[playerid][0] = ping;
		////////////////////FPS//////////////////////
		if(drunklevel <= 200)
		{
			SetPlayerDrunkLevel(playerid, 2000);
			LastPing_Drunk[playerid][1] = 2000;
			if(drunklevel <= 100)
			{
				fps = 60;
			}
		}
		FPT_PF[playerid][1] = fps;
		if(fps <= MINIMUM_FPS_LIMIT && fps > 1)
		{
			FPT_PFStrike[playerid][1]++;
			format(FPT_msg, sizeof(FPT_msg), "~w~Please fix your FPS.~n~~r~Strike(%i/%i)", FPT_PFStrike[playerid][1], MAX_FPS_STRIKE);
			GameTextForPlayer(playerid, FPT_msg, 1000, 4);
			/*if(FPT_PFStrike[playerid][1] % MAX_FPS_STRIKE == 0 && FPT_PFStrike[playerid][1] > 0 && KICK_OVERDRIVE = false)
			{
				AKickPlayer(-1, playerid, "FPS-Unlocker");
			}*/
			if(FPT_PFStrike[playerid][1] % MAX_FPS_STRIKE == 0 && FPT_PFStrike[playerid][1] > 0)
			{
				format(FPT_msg, sizeof(FPT_msg), "%s(%i) has very low FPS.", PlayerName(playerid), playerid);
				AntiCheatMessage(FPT_msg);
			}
		}
		else if(fps >= MAXIMUM_FPS_LIMIT)
		{
			FPS_HackStrike[playerid]++;
			if(FPS_HackStrike[playerid] % MAX_FPS_STRIKE == 0 && FPS_HackStrike[playerid] > 0)
			{
				format(FPT_msg, sizeof(FPT_msg), "%s(%i) is possibly using FPS-unlocker.", PlayerName(playerid), playerid);
				AntiCheatMessage(FPT_msg);
			}
		}
		else
		{
			FPT_PFStrike[playerid][1] = 0;
			FPS_HackStrike[playerid] = 0;
		}
		////////////////END of FPS/////////////
		//////////////////PING/////////////////
		FPT_PF[playerid][0] = ping;
		if(abs(pingdiff) > MAXIMUM_PING_JUMP)
		{
			FPT_PFStrike[playerid][0]++;
			if(FPT_PFStrike[playerid][0] % MAX_FPS_STRIKE == 0 && FPT_PFStrike[playerid][0] > 0)
			{
				format(FPT_msg, sizeof(FPT_msg), "%s(%i) has jumpy ping.(Check for VPN before Kicking)", PlayerName(playerid), playerid);
				AntiCheatMessage(FPT_msg);
			}
		}
		else
		{
			FPT_PFStrike[playerid][0] = 0;
		}
		///////////////END of PING/////////////
		UpdateCreateTextLableForAll(playerid);
		Streamer_Update(playerid);
	}
}





