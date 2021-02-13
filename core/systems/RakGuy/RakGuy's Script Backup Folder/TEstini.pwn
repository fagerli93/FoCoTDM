#include <YSI\y_ini>
#include <a_samp>
#include <sscanf2>

stock PlayerName(playerid)
{
	new string[24];
	GetPlayerName(playerid, string, sizeof(string));
	return string;
}

new cPlayerDetails[MAX_PLAYERS][10];
new cPlayerJoinDet[MAX_PLAYERS][2];

forward Christmas(playerid,name[],value[]);

public Christmas(playerid,name[],value[])
{
    INI_String(PlayerName(playerid),cPlayerDetails[playerid], 10);
    return 1;
}


public OnPlayerConnect(playerid)
{
	cPlayerJoinDet[playerid][0]=0;
	cPlayerJoinDet[playerid][1]=0;
	cPlayerDetails[playerid]="";
	new Days[3];
	getdate(Days[0], Days[1], Days[2]);
 	if(fexist("Christmaslogs.ini"))
    {
        INI_ParseFile("Christmaslogs.ini", "Christmas", .bExtra = true, .extra = playerid);
        if(sscanf(cPlayerDetails[playerid], "ii", cPlayerJoinDet[playerid][0],cPlayerJoinDet[playerid][1]))
        {
        	new pMSG[10];
			format(pMSG, sizeof(pMSG), "1 %i", Days[2]);
			new INI:cFile = INI_Open("Christmaslogs.ini");
			INI_WriteString(cFile, PlayerName(playerid), pMSG);
			INI_Close(cFile);
			print("Added and Wrote");
        }
        else
        {
            print(cPlayerDetails[playerid]);
           	new pMSG[10];
			format(pMSG, sizeof(pMSG), "%i %i",cPlayerJoinDet[playerid][0]+1, Days[2]);
			new INI:cFile = INI_Open("Christmaslogs.ini");
			INI_WriteString(cFile, PlayerName(playerid), pMSG);
			INI_Close(cFile);
			print("Added++");
        }
	}
    else
    {
        new pMSG[10];
		format(pMSG, sizeof(pMSG), "1 %i", Days[2]);
		new INI:cFile = INI_Open("Christmaslogs.ini");
		INI_WriteString(cFile, PlayerName(playerid), pMSG);
		INI_Close(cFile);
		print("Created and Wrote");
    }
	return 1;
}










































