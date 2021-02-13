#define FILTERSCRIPT
#define COLOR_SYNTAX	0x969696FF

#include <a_samp>
#include <zcmd>
#include <sscanf2>

new count;
new Timer;
new Tcount;

forward CheckHim(aimbotter, tester);

CMD:abt(playerid, params[])
{
	count=0;
	new ID[2];
	if(sscanf(params, "uu", ID[0], ID[1]))//ID[0] - Aimboter  ID[1] - Tester
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "[Usage:] /abt [Aimboter] [Tester]");
	}
	else
	{
	    Tcount=0;
		Timer=SetTimerEx("CheckHim", 200, 1, "ii",ID[0], ID[1]);
	}
	return 1;
}
public CheckHim(aimbotter, tester)
{
    new Float:Radius;
	new Float:XYZ[3];
	GetPlayerPos(aimbotter, XYZ[0], XYZ[1], XYZ[2]);
	Radius=GetPlayerDistanceFromPoint(tester, XYZ[0], XYZ[1], XYZ[2]);
	SetPlayerPos(tester, XYZ[0]+(Radius*floatcos(Tcount*40, degrees)), XYZ[1]+(Radius*floatsin(Tcount*40, degrees)), XYZ[2]);
	if(GetPlayerTargetPlayer(aimbotter)==tester)
    {
	    count=count+1;
   		if(count>=4)
		{
			SendClientMessageToAll(-1, "He is aimboting");
			KillTimer(Timer);
		}
    }
	if(Tcount==10)
	{
	    KillTimer(Timer);
	}
	Tcount++;
	return 1;
}
