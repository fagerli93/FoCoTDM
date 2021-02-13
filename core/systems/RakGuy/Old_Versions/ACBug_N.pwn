#define AC_AUTOCBUG newanim == 1179||newanim ==1224||newanim ==1228||newanim ==1230||newanim ==1231||newanim ==1249||newanim == 1276||newanim ==1277||newanim ==1280//||New Anim
#define AC_CHECKCBUG PlayerAnim[playerid] == 1167|| PlayerAnim[playerid] ==1163 || PlayerAnim[playerid] ==1162 || PlayerAnim[playerid] ==1161 || PlayerAnim[playerid] ==1160
#define AC_AUTOCBUG_SPAMLMT 5
#define AC_EAUTOCBUG_SPAMLMT 3
#define CMD_ACBUG_LMT 1

#include <YSI\y_hooks>

new PlayerAnim[MAX_PLAYERS];
new ACB_ASpam[MAX_PLAYERS];
new ACB_EASpam[MAX_PLAYERS];
new ACB_MSG[100];
new bool:ACBUG_TOG;

hook OnPlayerConnect(playerid)
{
    PlayerAnim[playerid]=0;
	ACB_ASpam[playerid]=0;
	ACB_EASpam[playerid]=0;
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    PlayerAnim[playerid]=0;
	ACB_ASpam[playerid]=0;
	ACB_EASpam[playerid]=0;
	return 1;
}

hook OnPlayerUpdate(playerid)
{
	if(GetPlayerAnimationIndex(playerid)!=PlayerAnim[playerid]&&GetPlayerWeapon(playerid)!=34&&ACBUG_TOG==false)
	{
	    /**********DEBUG FOR ANIM FINDER*********************************************
		new AnimLib[32], AnimName[32];
	    GetAnimationName(newanim, AnimLib, 32, AnimName, 32);
	    format(ACB_MSG, sizeof(ACB_MSG), "%s - %s - %i", AnimLib, AnimName, newanim);
	    SendClientMessageToAll(-1, ACB_MSG);
	    ****************END OF DEBUG************************************************/
		new newanim = GetPlayerAnimationIndex(playerid);
		if((AC_CHECKCBUG) && (AC_AUTOCBUG))//Defines are used here..
	    {
	        if(newanim == 1179)
			{
				ACB_ASpam[playerid]++;
			}
			else
			{
			    ACB_EASpam[playerid]++;
			}
			if(ACB_ASpam[playerid]==AC_AUTOCBUG_SPAMLMT)
			{
			    format(ACB_MSG, sizeof(ACB_MSG), "%s [%i] is using auto-cbug.cs.", PlayerName(playerid), playerid);
			    AntiCheatMessage(ACB_MSG);
			    ACB_ASpam[playerid]=0;
			}
			if(ACB_EASpam[playerid]==AC_EAUTOCBUG_SPAMLMT)
			{
   				format(ACB_MSG, sizeof(ACB_MSG), "%s [%i] is possibly using auto-cbug.exe/autoscroll.cs.", PlayerName(playerid), playerid);
			    AntiCheatMessage(ACB_MSG);
			    ACB_EASpam[playerid]=0;
			}
		}
		else if(ACB_EASpam[playerid]>0&&newanim==1266)
		{
		    ACB_EASpam[playerid]=0;
		}
		PlayerAnim[playerid]=newanim;

	}
	return 1;
}

CMD:antiacbug(playerid, params[])
{
	if(IsAdmin(playerid, CMD_ACBUG_LMT))
	{
	    if(ACBUG_TOG==false)
	    {
	        ACBUG_TOG=true;
            format(ACB_MSG, sizeof(ACB_MSG),"AdmCmd(%d): %s %s has disabled auto-cbug/scroll command.",CMD_ACBUG_LMT, GetPlayerStatus(playerid), PlayerName(playerid));
			SendAdminMessage(CMD_ACBUG_LMT, ACB_MSG);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, ACB_MSG);
		}
		else
		{
			ACBUG_TOG=false;
            format(ACB_MSG, sizeof(ACB_MSG),"AdmCmd(%d): %s %s has enabled auto-cbug/scroll command.",CMD_ACBUG_LMT, GetPlayerStatus(playerid), PlayerName(playerid));
			SendAdminMessage(CMD_ACBUG_LMT, ACB_MSG);
			IRC_GroupSay(gLeads, IRC_FOCO_LEADS, ACB_MSG);
		}
	}
	return 1;
}





