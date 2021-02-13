#include <YSI\y_ini>
#include <foco>

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#define CHRISTMAS_LOGIN "CHRISTMAS_LOGIN.ini"
#define CHRISTMAS_GIFT_LOG "CHRISTMAS_GIFT.ini"
#define CHRISTMAS_COUNT "TOTALLOGS"
#define GIFT_RADIUS 8.0

new cPlayerDetails[MAX_PLAYERS][10];
new cPlayerJoinDet[MAX_PLAYERS][2];
new cTotalCount[2];
new bool:Gift_Taken[MAX_PLAYERS];

new Float:GiftPosition[13][3]=
{
	{2112.52026, -1773.38110, 12.38170},
	{2445.52612, -1556.74927, 22.97270},
	{2224.33130, -2210.30396, 12.54440},
	{1678.16602, -2105.39063, 12.54280},
	{1178.97852, -2036.99683, 68.02900},
	{1952.62512, -1771.40271, 12.54170},
	{2031.68481, -1447.63574, 16.09470},
	{2238.03931, -1322.15906, 22.98256},
	{1786.12598, -1394.08020, 14.75120},
	{1514.40771, -1190.18152, 23.33740},
	{1146.77271, -1298.95630, 12.67550},
	{1586.81274, -1605.86145, 12.15710},
	{1245.42273, -1839.45337, 12.70639}
};
new bool:IsGift[MAX_VEHICLES];
new Gifts[4][70]=
{
{20000,30000,10000,50070,5000,20000,5000,1000,1000,100000,30000,20000,1000,30000,5000,
50000,5000,5000,1000,1000,20000,30000,5000,30000,150000,1000,1000,10000,50000,
20000,10000,50000,10000,20000,5000,1000,5000,30000,1000,100000,1000,10000,50000,
5000,10000,5000,30000,20000,5000,30000,5000,10000,10000,200000,20000,10000,
30000,10000,30000,20000,5000,5000,1000,1000,1000,20000,50000,1000,1000,250000},
{-1,30000,-1,20000,300000,20000,-1,25000,10000,30000,50000,10000,-1,100000,50000,
30000,-1,50000,100000,200000,50000,25000,10000,10000,30000,100000,-1,20000,
10000,20000,20000,50000,20000,250000,10000,100000,30000,50000,-1,10000,100000,
10000,-1,25000,25000,25000,-1,-1,250000,-1,10000,-1,100000,10000,20000,-1,
150000,30000,-1,30000,10000,250000,10000,50000,20000,50000,250000,50000,-1,
10000},
{50000,10000,-1,30000,100000,30000,-2,100000,100000,10000,25000,100000,20000,
200000,10000,-2,20000,300000,50000,10000,250000,30000,50000,-2,30000,-2,100000,
10000,-1,30000,-1,10000,-1,20000,50000,20000,30000,20000,250000,30000,10000,
10000,-1,25000,50000,10000,-1,25000,20000,20000,25000,50000,50000,50000,250000,
-1,25000,25000,250000,50000,-1,20000,10000,-1,150000,10000,10000,-2,10000,100000},
{-1,10000,-1,30000,-2,30000,-2,100000,100000,-2,25000,100000,20000,
200000,10000,-2,20000,-2,-1,10000,250000,-2,50000,-2,30000,-2,100000,
10000,-1,30000,-1,10000,-1,20000,50000,-1,30000,20000,-2,30000,10000,
10000,-1,25000,50000,10000,-1,25000,20000,20000,25000,50000,50000,50000,250000,
-1,25000,25000,250000,50000,-1,20000,10000,-1,150000,10000,10000,-2,10000,100000}
};

enum gVehDet
{
	Vid,
	Vname[17]
};
new Gift_Veh[2][gVehDet]={{447,"Sea Sparrow"}, {432, "Rhino"}};
enum gWeapDet
{
	Wid,
	Wammo,
	Wname[17]
};
new Gift_Weap[5][gWeapDet]={{35, 10, "RPG"},{36, 10, "HeatSeaker RPG"},	{39, 10, "Satchel Charges"},{16, 10, "Granades"},{38, 500, "Minigun"}};
new vGift[MAX_PLAYERS];



forward Christmas(playerid,name[],value[]);
forward GetTheCount(Type, name[], value[]);


stock GivePlayerChristmasGift(playerid)
{
	new MSG[120];
	new Days[3], GiftType, GiftName[17];
	getdate(Days[2], Days[1], Days[0]);
	if(Days[1]==12)
	{
		switch(Days[0])
		{
		    case 1..9:
		    {
		        GiftType=0;
		    }
		    case 10..15:
		    {
		        GiftType=1;
		    }
		    case 16..20:
			{
			    GiftType=2;
			}
			case 21..31:
			{
			    GiftType=3;
			}

		}
	}
	else if(Days[1]==1)
	{
	    GiftType=3;
	}

	new GiftID=(cTotalCount[1]<70)?(cTotalCount[1]):(cTotalCount[1]%70);
	GiftType=Gifts[GiftType][GiftID];
	switch(GiftType)
	{
	    case -1:
	    {
	        new gRand=random(5);
	        GiftName=Gift_Weap[gRand][Wname];
	        GivePlayerWeapon(playerid,Gift_Weap[gRand][Wid],Gift_Weap[gRand][Wammo]);
			//UpdateAC;
	        format(MSG, sizeof(MSG), "%s has won %s as Christmas Gift.", PlayerName(playerid), GiftName);
	        SendAdminMessage(1, MSG);
			format(MSG, sizeof(MSG), "[NOTICE:] %s", MSG);
			SendClientMessageToAll(COLOR_NOTICE, MSG);
	    }
	    case -2:
		{
		    new gRand=random(2);
		    GiftName = Gift_Veh[gRand][Vname];
			format(MSG, sizeof(MSG), "%s has won %s as Christmas Gift.", PlayerName(playerid), GiftName);
	        SendAdminMessage(1, MSG);
   			SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE:] Use /claimgift to spawn your vehicle");
			//
			vGift[playerid]=Gift_Veh[gRand][Vid];
		}
		default:
		{
			format(GiftName, sizeof(GiftName), "Money($%i)", GiftType);
			//GivePlayerCash(playerid, GiftType);
			//UpdateAC;
		}
	}
	format(MSG, sizeof(MSG), "[NOTICE:] You have won %s from the Christmas tree.[GiftID: %i]", GiftName, cTotalCount[1],GiftType);
	SendClientMessage(playerid, COLOR_NOTICE, MSG);
	format(MSG, sizeof(MSG), "%i. %s won %s.\r\n", cTotalCount[1], PlayerName(playerid), GiftName);
	new File:Gift_log=fopen(CHRISTMAS_GIFT_LOG,io_append);
	fwrite(Gift_log, MSG);
	fclose(Gift_log);
 	cTotalCount[1]++;
	new INI:cFile = INI_Open(CHRISTMAS_GIFT_LOG);
	INI_WriteInt(cFile, CHRISTMAS_COUNT, cTotalCount[1]);
	INI_Close(cFile);
	return 1;
}


public Christmas(playerid,name[],value[])
{
    INI_String(PlayerName(playerid),cPlayerDetails[playerid], 10);
    return 1;
}

public GetTheCount(Type, name[], value[])
{
	INI_Int(CHRISTMAS_COUNT, cTotalCount[Type]);
	return 1;
}

public OnFilterScriptInit()
{
	new GC_Type;
	if(!fexist(CHRISTMAS_LOGIN))
    {
		new INI:cFile = INI_Open(CHRISTMAS_LOGIN);
		INI_WriteInt(cFile, CHRISTMAS_COUNT, 0);
		INI_Close(cFile);
		cTotalCount[0]=0;
		print("Created and Wrote");
    }
    else
    {
        GC_Type=0;
    	INI_ParseFile(CHRISTMAS_LOGIN, "GetTheCount",.bExtra = true, .extra = GC_Type);
    }
    if(!fexist(CHRISTMAS_GIFT_LOG))
    {
  		new INI:cFile = INI_Open(CHRISTMAS_GIFT_LOG);
		INI_WriteInt(cFile, CHRISTMAS_COUNT, 0);
		INI_Close(cFile);
		cTotalCount[1]=0;
		print("Created and Wrote");
    }
    else
    {
        GC_Type=1;
    	INI_ParseFile(CHRISTMAS_GIFT_LOG, "GetTheCount",.bExtra = true, .extra = GC_Type);
    }
	return 1;
}

public OnPlayerConnect(playerid)
{
    RemoveBuildingForPlayer(playerid, 647, 1244.5000, -1839.8125, 14.0703, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1513.9922, -1190.1094, 24.6797, 0.25);
	cPlayerJoinDet[playerid][0]=0;
	cPlayerJoinDet[playerid][1]=0;
	cPlayerDetails[playerid]="";
	new Days[3];
	getdate(Days[0], Days[1], Days[2]);
 	if(fexist(CHRISTMAS_LOGIN))
    {
        INI_ParseFile(CHRISTMAS_LOGIN, "Christmas", .bExtra = true, .extra = playerid);
        if(sscanf(cPlayerDetails[playerid], "ii", cPlayerJoinDet[playerid][0],cPlayerJoinDet[playerid][1]))
        {
        	new pMSG[10];
        	cTotalCount[0]++;
        	cPlayerJoinDet[playerid][0]=1;
			format(pMSG, sizeof(pMSG), "1 -%i", Days[2]);
			new INI:cFile = INI_Open(CHRISTMAS_LOGIN);
			INI_WriteString(cFile, PlayerName(playerid), pMSG);
			INI_WriteInt(cFile, CHRISTMAS_COUNT, cTotalCount[0]);
			INI_Close(cFile);
			Gift_Taken[playerid]=false;
        }
        else
        {
			if(Days[2]!=cPlayerJoinDet[playerid][1]||cPlayerJoinDet[playerid][1]<0)
			{
		        print(cPlayerDetails[playerid]);
	           	new pMSG[10];
				format(pMSG, sizeof(pMSG), "%i -%i",cPlayerJoinDet[playerid][0]+1, Days[2]);
				new INI:cFile = INI_Open(CHRISTMAS_LOGIN);
				INI_WriteString(cFile, PlayerName(playerid), pMSG);
				INI_Close(cFile);
                Gift_Taken[playerid]=false;
			}
			else
			{
			    Gift_Taken[playerid]=true;
			}
        }
	}
    else
    {
        new pMSG[10];
        cTotalCount[0]++;
        cPlayerJoinDet[playerid][0]=1;
		format(pMSG, sizeof(pMSG), "1 %i", Days[2]);
		new INI:cFile = INI_Open(CHRISTMAS_LOGIN);
		INI_WriteString(cFile, PlayerName(playerid), pMSG);
		INI_WriteInt(cFile, CHRISTMAS_COUNT, cTotalCount[0]);
		INI_Close(cFile);
		print("Created and Wrote");
		Gift_Taken[playerid]=false;
    }
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(Gift_Taken[playerid]==false)
	{
		SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE:] /getgift is available.");
	}
	return 1;
}


CMD:getgift(playerid, params[])
{
	if(Gift_Taken[playerid]==false)
	{
		new MSG[120];
	    new Float:Range=10000.0;
	    new CloserR;
		for(new g=0; g<13; g++)
		{
		    new Float:TempRange=GetPlayerDistanceFromPoint(playerid, GiftPosition[g][0], GiftPosition[g][1], GiftPosition[g][2]);
		    if(TempRange<Range)
		    {
		        Range=TempRange;
		        CloserR=g;
		    }
			format(MSG, sizeof(MSG), "R: %f TR: %f.. %f-%f-%f", Range, TempRange,GiftPosition[g][0], GiftPosition[g][1], GiftPosition[g][2]);
			SendClientMessage(playerid, -1, MSG);
            if(Range<GIFT_RADIUS||Range<50.0)
			{
				SendClientMessage(playerid, -1, "Supposed to end");
				break;
			}
		}
		if(Range<GIFT_RADIUS)
		{
			GivePlayerChristmasGift(playerid);
			new Days[3];
			getdate(Days[0], Days[1], Days[2]);
			format(MSG, sizeof(MSG), "%i %i",cPlayerJoinDet[playerid][0],Days[2]);
			new INI:cFile = INI_Open(CHRISTMAS_LOGIN);
			INI_WriteString(cFile, PlayerName(playerid), MSG);
			INI_Close(cFile);
			Gift_Taken[playerid]=true;
            return SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE:] Here you go mofocka.");
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You can use this command only near a Christmas tree.");
			SetPlayerCheckpoint(playerid, GiftPosition[CloserR][0], GiftPosition[CloserR][1], GiftPosition[CloserR][2],GIFT_RADIUS);
			return SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE:] Closest Christmas tree has been marked on you map. Follow the checkpoint.");
		}
	}
	else
	{
 		SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You have already taken your gift for today.");
	}
	return 1;
}
CMD:claimgift(playerid, params[])
{
	if(Gift_Taken[playerid]==false)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You haven't taken your gift yet.");
	}
	else
	{
	    if(vGift[playerid]>400 && vGift[playerid]<609)
	    {
	        new Float:CPos[3];
	        GetPlayerPos(playerid, CPos[0], CPos[1], CPos[2]);
			new vehicleid=CreateVehicle(vGift[playerid], 0.0, 0.0, 0.0, 90.0, 0, 0, 45000);
			IsGift[vehicleid]=true;
			SetVehiclePos(vehicleid, CPos[0], CPos[1], CPos[2]+2.0);
            GetPlayerFacingAngle(playerid, CPos[0]);
			SetVehicleZAngle(vehicleid, CPos[0]);
			PutPlayerInVehicle(playerid, vehicleid, 0);
	    }
	    else
	    {
	        return SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You do not have any vehicle pending to be claimed.");
	    }
	}
	return 1;
}
CMD:gototree(playerid, params[])
{
	new Treeid;
	if(sscanf(params, "i", Treeid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE:] /gototree [treeid]");
	}
	else
	{
	    SetPlayerPos(playerid,GiftPosition[Treeid][0]+3.0, GiftPosition[Treeid][1]+1.0, GiftPosition[Treeid][2]+2.0);
	}
	return 1;
}


public OnPlayerEnterCheckpoint(playerid)
{
    SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE:] /getgift to take gift.");
	DisablePlayerCheckpoint(playerid);
    return 1;
}

































