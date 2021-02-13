#include <YSI\y_hooks>

#define COLOR_TL 		-1		//Color of 3DTextDraw
#define TL_PingJumpLimit 100	// Ping Jump limit
#define TL_PingCoolDown  7 		//Time to reduce one Strike
#define TL_PingStrikes 	 3 		//Number of Strikes that will result in a Kick or A-Notification.
#define TL_PingRedo  	 1		//From where the PingJumper will start re-striking after one A-Notification.
#define ACMD_TOGALL 	 4		//Have the right to Toggle Command for people + Disable it.
#define ACMD_FPTO 		 1		//Have the right to Over ride the TOG-All command by Lead. AKA Admins.
#define ACMD_FPTP 		 1  	//Have the Right to Toggle FPS/Ping or AutoKick for Players.
#define TL_MAXPLoss 	 0.3	//Maximum P/L allowed to hack, more will Cause Kick.
#define M_PacketStrike   7      //Number of strikes that will result in a Kick or A-Notification
#define M_PacketCoolDown 4      //Time to Reduce one Strike

new Text3D:TextIDs[MAX_PLAYERS];            //TextIDs of each player

new TL_FPS[MAX_PLAYERS][2];                 //[0] = Last Drunk Level || [1] = Last FPS
new TL_Ping[MAX_PLAYERS][2];                //[0] = Lowest Ping || [1] = Last Ping

new bool:TL_Toggle[MAX_PLAYERS];            //false = Player's 3DText is On[NOT Toggled]. True = Off[Toggled].

new bool:TL_AdminOR;                        //Admin Over Ride on FPS/Ping on Body. False = No[Override]. True = Yes.
new bool:TL_AdminORP[MAX_PLAYERS];          //Admin Over Ride on FPS/Ping for Player. ********^^^^^^^^^^^^^^^^^^****

new PingStrike[MAX_PLAYERS];                //Number of Strikes for Ping for [Player]
new PingCoolDown[MAX_PLAYERS];              //Number of Seconds remaining for CoolDown for [Player]

new bool:TL_PKickOverRide[MAX_PLAYERS];     //Auto-Kick toggled for [player]. True = Off[No_Kick/Warning]. False = On[Kick/Warning]
new bool:TL_KickOverRide;                   //Auto-Kick toggle for ALL.       ************************^^^^^^^^^^^^^****************

new Float:TL_PacketLoss[MAX_PLAYERS];
new PacketStrike[MAX_PLAYERS];
new PacketCoolDown[MAX_PLAYERS];

new TL_MSG[150];                            //Message store shit ma nigga.

hook OnPlayerConnect(playerid)
{
	PingStrike[playerid]=0;
	PingCoolDown[playerid]=0;
	TL_FPS[playerid][0]=0;
	TL_FPS[playerid][1]=0;
	TL_Ping[playerid][0]=0;
	TL_Ping[playerid][1]=0;
	TL_RemovePlayer3D(playerid);
	if(TL_AdminOR==false)
	{
		TL_Toggle[playerid]=false;
		TL_AppendToAll(playerid);
		TL_AdminORP[playerid]=false;
	}
	else
	{
	    TL_Toggle[playerid]=true;
	    TL_AdminORP[playerid]=true;
	}
	if(TL_KickOverRide==false)
	{
	    TL_PKickOverRide[playerid]=false;
	}
	else
	{
	    TL_PKickOverRide[playerid]=true;
	}
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	if(TL_Toggle[playerid]==false)
	{
	    TL_RemovePlayer3D(playerid);
		TL_RemoveFromAll(playerid);
	}
	return 1;
}


stock TL_RemovePlayer3D(playerid)
{
	if(IsValidDynamic3DTextLabel(TextIDs[playerid]))
	{
	    TL_Toggle[playerid]=true;
		DestroyDynamic3DTextLabel(TextIDs[playerid]);
	}
	return 1;
}

stock TL_RemoveFromAll(playerid)
{
	foreach(Player, targetid)
	{
	    if(IsValidDynamic3DTextLabel(TextIDs[targetid]) && targetid!=playerid)
			Streamer_RemoveArrayData(STREAMER_TYPE_3D_TEXT_LABEL, TextIDs[targetid], E_STREAMER_PLAYER_ID, playerid);
	}
	return 1;
}

stock TL_AppendToAll(playerid)
{
	foreach(Player, targetid)
	{
	    if(IsValidDynamic3DTextLabel(TextIDs[targetid])&& targetid!=playerid)
			Streamer_AppendArrayData(STREAMER_TYPE_3D_TEXT_LABEL, TextIDs[targetid], E_STREAMER_PLAYER_ID, playerid);
	}
	return 1;
}

ptask TL_Updater[1000](playerid)
{
    new TL_TempPing = TL_Ping[playerid][1];
	TL_Ping[playerid][1]=GetPlayerPing(playerid);
	if(GetPlayerDrunkLevel(playerid)!= TL_FPS[playerid][0] && GetPlayerDrunkLevel(playerid) != 0)
	{
	    if(TL_FPS[playerid][0]==0)
	    {
	    	SetPlayerDrunkLevel(playerid, 2000);
		    TL_FPS[playerid][0]=2000;
			TL_FPS[playerid][1]=99;
		}
		else
		{
			new TL_TempDL = GetPlayerDrunkLevel(playerid);
			if(TL_FPS[playerid][0] - TL_TempDL <= 101&&TL_FPS[playerid][0] - TL_TempDL > 0)
			{
				TL_FPS[playerid][1]= TL_FPS[playerid][0] - TL_TempDL;
			}
			TL_FPS[playerid][0]=TL_TempDL;
		}
	}
	UpdateCreateTextLableForAll(playerid);
	if(TL_PKickOverRide[playerid]==false && TL_KickOverRide==false)
	{
		if(PingCoolDown[playerid]> 0)
		{
			PingCoolDown[playerid]--;
		    if(PingCoolDown[playerid]==0)
		    {
		       	PingStrike[playerid]--;
				if(PingStrike[playerid]>0)
				{                   ///////////Strike-Remove///////////////
					PingCoolDown[playerid]=TL_PingCoolDown;
				}
			}
		}
		if(TL_TempPing!=0)
		{
			new TL_TempDiff = TL_Ping[playerid][0] - TL_Ping[playerid][1];
			if((TL_TempDiff>=TL_PingJumpLimit || TL_TempDiff<=-TL_PingJumpLimit) && TL_Ping[playerid][1]!=TL_TempPing)
			{
				PingCoolDown[playerid]=TL_PingCoolDown;
				PingStrike[playerid]++;
/*Edit*/		SendClientMessage(playerid, COLOR_NOTICE, "[Guardian]: Please fix your ping, its too jumpy.");
								///////////Strike-Add///////////////
				format(TL_MSG, sizeof(TL_MSG), "[LADMIN NOTICE:] Strike added to %s(%i)[Strike: %i]", PlayerName(playerid), playerid, PingStrike[playerid]);
				SendClientMessageToAll(-1, TL_MSG);
				//IRC_GroupSay(gLeads, IRC_FOCO_LEADS, TL_MSG);
				if(PingStrike[playerid]==TL_PingStrikes)
				{
/*Edit*/			if(AdminsOnline()==0 && TestersOnline()==0)//EDIT NEEDED
		   			{
 		    			format(TL_MSG, sizeof(TL_MSG), "[PING KICK] %s(%i) has been kicked for Jumpy-Ping.", PlayerName(playerid), playerid);
/*Edit*/                //IRC_GroupSay(gAdmin, IRC_FOCO_ECHO, TL_MSG);
/*Edit*/			    PingStrike[playerid]=TL_PingRedo;//AKickPlayer(-1, playerid, "Auto-Kick for Jumpy Ping");
					    SendClientMessageToAll(-1, "No admin/tester online");
					}
					else
					{
						format(TL_MSG, sizeof(TL_MSG), "[Guardian]: %s(%i) has Jumpy-Ping.[Recommended Action: Kick/Ask mofo to Fix it.]", PlayerName(playerid), playerid);
					    SendAdminMessage(1, TL_MSG);
/*Edit*/                //IRC_GroupSay(gAdmin, IRC_FOCO_ECHO, TL_MSG);
					    PingStrike[playerid]=TL_PingRedo;
          				SendClientMessageToAll(-1, "Admin/tester online");
					}
				}
			}
		}
		if(TL_Ping[playerid][0]==0 || TL_Ping[playerid][1]<TL_Ping[playerid][0])
		{
		    TL_Ping[playerid][0] = TL_Ping[playerid][1];
		}
	}
	if(FoCo_Player[playerid][onlinetime]>30)
	{
		new Float:Temp_PLoss = NetStats_PacketLossPercent(playerid);
		if(Temp_PLoss > TL_MAXPLoss)
		{
		    if(Temp_PLoss != TL_PacketLoss[playerid])
		    {
		        if(Temp_PLoss >= TL_PacketLoss[playerid])
		        {
		            if(Temp_PLoss>0.3 && TL_PacketLoss[playerid]<=0.1)
		            {
		                SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE:]Ayo Bitch you Desynced!");
						format(TL_MSG, sizeof(TL_MSG), "[Guardian]: %s(%i) is desynced.[Recommended Action: Wait for further Instruction.]", PlayerName(playerid), playerid);
						SendAdminMessage(1, TL_MSG);
/*Edit*/                //IRC_GroupSay(gAdmin, IRC_FOCO_ECHO, TL_MSG);
		            }
		            if(Temp_PLoss - PacketStrike[playerid] >= 0.8)
						PacketStrike[playerid]+=2;
					else
					    PacketStrike[playerid]++;
					PacketCoolDown[playerid]=M_PacketCoolDown;
					if(PacketStrike[playerid]>=M_PacketStrike)
					{
/*Edit*/				if(AdminsOnline()==0 && TestersOnline()==0)//EDIT NEEDED
						{
		         		   	format(TL_MSG, sizeof(TL_MSG), "[PING KICK] %s(%i) has been kicked for PacketLoss[Desync].", PlayerName(playerid), playerid);
	           				SendClientMessageToAll(-1, TL_MSG);
/*Edit*/                	//IRC_GroupSay(gAdmin, IRC_FOCO_ECHO, TL_MSG);
/*Edit*/				   	PacketStrike[playerid]=TL_PingRedo;//AKickPlayer(-1, playerid, "Auto-Kick for P/L[Desync]");
						   	SendClientMessageToAll(-1, "No admin/tester online");
						}
						else
						{
							format(TL_MSG, sizeof(TL_MSG), "[Guardian]: %s(%i) has PacketLoss above limit.[Recommended Action: Kick/Ask Player to Fix it.]", PlayerName(playerid), playerid);
						    SendAdminMessage(1, TL_MSG);
/*Edit*/                	//IRC_GroupSay(gAdmin, IRC_FOCO_ECHO, TL_MSG);
						    PacketStrike[playerid]=TL_PingRedo;
	          				SendClientMessageToAll(-1, "Admin/tester online");
						}
					}
				}
				else
				{
					PacketCoolDown[playerid]--;
					if(PacketCoolDown[playerid]==0)
					{
						PacketStrike[playerid]--;
						if(Temp_PLoss<=0.5 && Temp_PLoss>=TL_MAXPLoss && TL_PacketLoss[playerid]-Temp_PLoss >=0.1)
						{
							format(TL_MSG, sizeof(TL_MSG), "[Guardian]: %s(%i) is re-synchronizing.[Recommended Action: Wait and STFU/Kick.]", PlayerName(playerid), playerid);
							SendAdminMessage(TL_MSG);
/*Edit*/                	//IRC_GroupSay(gAdmin, IRC_FOCO_ECHO, TL_MSG);
						}
					}
				}
				//MSG;
		    }
		}
		else
		{
		    if(TL_PacketLoss[playerid]>TL_MAXPLoss)
			{
				format(TL_MSG, sizeof(TL_MSG), "[Guardian]: %s(%i) has re-synchronized.[Recommended Action: Lick my Ass.]", PlayerName(playerid), playerid);
				SendAdminMessage(1, TL_MSG);
/*Edit*/        //IRC_GroupSay(gAdmin, IRC_FOCO_ECHO, TL_MSG);
			}
		}
		TL_PacketLoss[playerid]=Temp_PLoss;
	}
	if(GetPlayerDrunkLevel(playerid) <= 200)
	{
	    SetPlayerDrunkLevel(playerid, 2000);
	    TL_FPS[playerid][0]=2000;
	}
}

stock UpdateCreateTextLableForAll(targetid)
{
	new MSG_TL[25];
	format(MSG_TL, sizeof(MSG_TL), "Ping: %i ·· FPS: %i", TL_Ping[targetid][1], TL_FPS[targetid][1]);
    if(!IsValidDynamic3DTextLabel(TextIDs[targetid]))
	{
		TextIDs[targetid]=CreateDynamic3DTextLabelEx(MSG_TL, COLOR_TL, 0.0, 0.0, 0.0, 25.0, targetid, INVALID_VEHICLE_ID,1, 50.0, {-1}, {-1}, {1});
   		Streamer_RemoveArrayData(STREAMER_TYPE_3D_TEXT_LABEL, TextIDs[targetid], E_STREAMER_PLAYER_ID, 1);
		foreach(Player, playerid)
		{
		    if(TL_Toggle[playerid]==false)
				Streamer_AppendArrayData(STREAMER_TYPE_3D_TEXT_LABEL, TextIDs[targetid], E_STREAMER_PLAYER_ID, playerid);
		}
		//Attach3DTextLabelToPlayer(TextIDs[targetid], targetid, 0.0, 0.0,0.3);
	}
	else
	{
		UpdateDynamic3DTextLabelText(TextIDs[targetid], COLOR_TL, MSG_TL);
	}
	return 1;
}

CMD:togtext(playerid, params[])
{
	if(TL_AdminOR==false || IsAdmin(playerid, ACMD_FPTO))
	{
		if(TL_AdminORP[playerid]==false || IsAdmin(playerid, ACMD_FPTO))
		{
			if(TL_Toggle[playerid]==true)
			{
				SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE:] FPS/Ping on body "#"{00ff00}""Enabled");
				TL_Toggle[playerid]=false;
			    TL_AppendToAll(playerid);
			}
			else
			{
			    TL_Toggle[playerid]=true;
				SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE:] FPS/Ping on body "#"{ff0000}""Disabled");
			    TL_RemoveFromAll(playerid);
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] An admin has disabled the command for you.");
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] Command disabled by admin.");
	}
	return 1;
}

CMD:togptext(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_FPTP))
	{
	    if(IsAdmin(playerid, ACMD_TOGALL)|| TL_AdminOR==false)
	    {
			new TL_Target;
			if(sscanf(params, "u", TL_Target))
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE:] /togptext [Player_ID/User_Name]");
			}
			else
			{
			    if(TL_Toggle[TL_Target]==true)
				{
					TL_Toggle[TL_Target]=false;
	                TL_AppendToAll(TL_Target);
					format(TL_MSG, sizeof(TL_MSG), "[NOTICE:] %s %s has enabled FPS/Ping On-Body for you.", GetPlayerStatus(playerid), PlayerName(playerid));
					SendClientMessage(TL_Target, COLOR_NOTICE, TL_MSG);
					format(TL_MSG, sizeof(TL_MSG), "AdmCmd(%i): %s %s has enabled FPS/Ping on-body for %s",ACMD_FPTP, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(TL_Target));
					SendAdminMessage(ACMD_FPTP, TL_MSG);
					//IRC_GroupSay(gLeads, IRC_FOCO_LEADS, TL_MSG);
				}
				else
				{
	                TL_RemoveFromAll(TL_Target);
                    TL_Toggle[TL_Target]=true;
					format(TL_MSG, sizeof(TL_MSG), "[NOTICE:] %s %s has disabled FPS/Ping On-Body for you.", GetPlayerStatus(playerid), PlayerName(playerid));
					SendClientMessage(TL_Target, COLOR_NOTICE, TL_MSG);
					format(TL_MSG, sizeof(TL_MSG), "AdmCmd(%i): %s %s has disabled FPS/Ping on-body for %s",ACMD_FPTP, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(TL_Target));
					SendAdminMessage(ACMD_FPTP, TL_MSG);
					//IRC_GroupSay(gLeads, IRC_FOCO_LEADS, TL_MSG);
				}
			}
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You can not use this command till its re-added by admin.");
	    }
	}
	return 1;
}


CMD:togtextall(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_TOGALL))
	{
	    if(TL_AdminOR==false)
	    {
	        TL_AdminOR=true;
	        foreach(Player, i)
	        {
	            TL_Toggle[i]=true;
	            TL_RemoveFromAll(i);
	        }
	        format(TL_MSG, sizeof(TL_MSG), "[NOTICE:] %s %s has disabled FPS/Ping On-Body.", GetPlayerStatus(playerid), PlayerName(playerid));
			SendClientMessageToAll(COLOR_NOTICE, TL_MSG);
			format(TL_MSG, sizeof(TL_MSG), "AdmCmd(%i): %s %s has disabled FPS/Ping on-body.",ACMD_TOGALL, GetPlayerStatus(playerid), PlayerName(playerid));
			SendAdminMessage(ACMD_FPTP, TL_MSG);
			//IRC_GroupSay(gLeads, IRC_FOCO_LEADS, TL_MSG);
	    }
	    else
	    {
	        TL_AdminOR=false;
			foreach(Player, i)
			{
                TL_Toggle[i]=false;
                TL_AppendToAll(i);
			}
			format(TL_MSG, sizeof(TL_MSG), "[NOTICE:] %s %s has enabled FPS/Ping On-Body.", GetPlayerStatus(playerid), PlayerName(playerid));
			SendClientMessageToAll(COLOR_NOTICE, TL_MSG);
			format(TL_MSG, sizeof(TL_MSG), "AdmCmd(%i): %s %s has enabled FPS/Ping on-body for all.",ACMD_TOGALL, GetPlayerStatus(playerid), PlayerName(playerid));
			SendAdminMessage(ACMD_FPTP, TL_MSG);
          	//IRC_GroupSay(gLeads, IRC_FOCO_LEADS, TL_MSG);
		}
	}
	return 1;
}

CMD:togkickall(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_TOGALL))
	{
	    if(TL_KickOverRide==false)
	    {
	        TL_KickOverRide=true;
	        foreach(Player, i)
	        {
	            TL_PKickOverRide[i]=true;
	        }
			format(TL_MSG, sizeof(TL_MSG), "AdmCmd(%i): %s %s has disabled Auto-Kick.",ACMD_TOGALL, GetPlayerStatus(playerid), PlayerName(playerid));
			SendAdminMessage(ACMD_FPTP, TL_MSG);
			//IRC_GroupSay(gLeads, IRC_FOCO_LEADS, TL_MSG);
	    }
	    else
	    {
	        TL_KickOverRide=false;
			foreach(Player, i)
			{
				TL_PKickOverRide[i]=false;
			}
			format(TL_MSG, sizeof(TL_MSG), "[NOTICE:] %s %s has enabled Auto-Kick.", GetPlayerStatus(playerid), PlayerName(playerid));
			SendClientMessageToAll(COLOR_NOTICE, TL_MSG);
          	//IRC_GroupSay(gLeads, IRC_FOCO_LEADS, TL_MSG);
		}
	}
	return 1;
}


CMD:togpkick(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_FPTP))
	{
	    if(IsAdmin(playerid, ACMD_TOGALL) || TL_KickOverRide==false)
	    {
			new TL_Target;
			if(sscanf(params, "u", TL_Target))
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE:] /togpkick [Player_ID/User_Name]");
			}
			else
			{
			    if(TL_PKickOverRide[TL_Target]==true)
				{
					TL_PKickOverRide[TL_Target]=false;
					format(TL_MSG, sizeof(TL_MSG), "AdmCmd(%i): %s %s has enabled Auto-Kick for %s",ACMD_FPTP, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(TL_Target));
					SendAdminMessage(ACMD_FPTP, TL_MSG);
					//IRC_GroupSay(gLeads, IRC_FOCO_LEADS, TL_MSG);
				}
				else
				{
				    TL_PKickOverRide[TL_Target]=true;
	                format(TL_MSG, sizeof(TL_MSG), "AdmCmd(%i): %s %s has disabled Auto-Kick for %s",ACMD_FPTP, GetPlayerStatus(playerid), PlayerName(playerid), PlayerName(TL_Target));
					SendAdminMessage(ACMD_FPTP, TL_MSG);
					//IRC_GroupSay(gLeads, IRC_FOCO_LEADS, TL_MSG);
				}
			}
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You can not use this command till its enabled by admin.");
	    }
	}
	return 1;
}

CMD:bugfix(playerid, params[])
{
	Streamer_Update(playerid);
	return 1;
}

