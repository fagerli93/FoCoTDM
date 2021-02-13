#include <YSI\y_hooks>

#define CHRISTMAS_LOGIN "CHRISTMAS_LOGIN%i.ini"
#define CHRISTMAS_GIFT_LOG "CHRISTMAS_GIFT.ini"
#define CHRISTMAS_COUNT "TOTALLOGS"
#define GIFT_RADIUS 8.0

new cDMSG[128];
new cTotalCount[2];
new vGift[MAX_PLAYERS];
new bool:IsGift[MAX_VEHICLES];
new bool:Tree_CPS[MAX_PLAYERS];
new bool:Gift_Taken[MAX_PLAYERS];
new cPlayerJoinDet[MAX_PLAYERS][3];
new cPlayerDetails[MAX_PLAYERS][10];
new cTotalPage;

stock CHRISTMAS_BLOGIN(pageid)
{
	format(cDMSG, sizeof(cDMSG), CHRISTMAS_LOGIN, pageid);
	return cDMSG;
}

stock GPlayerName(playerid)
{
	new FixName[24];
	FixName=PlayerName(playerid);
	if(strfind(FixName, "[")==0)
	{
		new Str=strfind(FixName, "]");
		if(FixName[Str+1]=='\0')
		{
		    FixName[Str+1]='*';
			return FixName;
		}
	}
	return FixName;
}


enum gVehDet{Vid,Vname[17]};
enum gWeapDet{Wid,Wammo,Wname[17]};

new Gift_Veh[2][gVehDet]={{447,"Sea Sparrow"}, {432, "Rhino"}};
new Gift_Weap[5][gWeapDet]={{35, 10, "RPG"},{36, 10, "HeatSeaker RPG"},	{39, 10, "Satchel Charges"},{16, 10, "Granades"},{38, 500, "Minigun"}};

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

new Gifts[4][70]=
{
	//Set 1: Day 1-9
	{10000,5000,6000,8000,5000,20000,5000,1000,1000,20000,10000,20000,1000,10000,5000,
	15000,5000,5000,1000,1000,20000,10000,5000,10000,18000,1000,1000,2000,15000,
	20000,2000,15000,2000,20000,5000,1000,5000,10000,1000,20000,1000,2000,15000,
	5000,2000,5000,10000,20000,5000,10000,5000,2000,2000,20000,20000,2000,
	10000,2000,10000,20000,5000,5000,1000,1000,1000,20000,15000,1000,1000,6000},
	//Set 2: Day 10-15
	{-1,-2,-1,20000,11000,20000,-1,25000,2000,10000,15000,2000,-1,20000,15000,
	10000,-1,15000,20000,20000,15000,25000,2000,2000,10000,20000,-1,20000,
	2000,20000,20000,15000,20000,6000,2000,20000,10000,15000,-1,2000,20000,
	2000,-1,25000,25000,25000,-1,-1,6000,-1,2000,-1,20000,2000,20000,-1,
	18000,10000,-1,10000,2000,6000,2000,15000,20000,15000,6000,15000,-1,
	2000},
	//Set 3: Day 17-20
	{15000,2000,-1,10000,20000,10000,-2,20000,20000,2000,25000,20000,20000,
	13000,2000,-2,20000,11000,15000,2000,6000,10000,15000,-2,10000,-1,20000,
	2000,-1,10000,-1,2000,-1,20000,15000,-1,10000,20000,6000,-2,2000,
	2000,-1,25000,15000,2000,-1,25000,20000,20000,25000,15000,15000,15000,6000,
	-1,25000,25000,6000,15000,-1,20000,2000,-1,18000,2000,2000,-1,2000,20000},
	//Set 4: Day 20-31
	{-1,2000,-1,10000,-2,10000,-2,20000,20000,-2,25000,20000,20000,
	20000,2000,-2,20000,-2,-1,2000,6000,-2,15000,-2,10000,-2,20000,
	2000,-1,-2,-1,2000,-1,20000,15000,-1,10000,20000,-2,10000,2000,
	2000,-1,25000,15000,2000,-1,25000,20000,20000,-2,15000,15000,15000,6000,
	-1,25000,-2,6000,15000,-1,20000,2000,-1,18000,2000,2000,-2,2000,20000}
};


forward Christmas(playerid,name[],value[]);
forward GetTheCount(Type, name[], value[]);


stock GivePlayerChristmasGift(playerid)
{
	new GMSG[120];
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
	else if(Days[1]!=12)
	{
	    GiftType=0;
	}
	new GiftID=(cTotalCount[1]<70)?(cTotalCount[1]):(cTotalCount[1]%70);
	GiftType=Gifts[GiftType][GiftID];
	switch(GiftType)
	{
	    case -1:
	    {
	        SetPVarInt(playerid, "sWepExc", 1);//ADDED HERE
	        new gRand=random(5);
	        format(GiftName, sizeof(GiftName), "%s", Gift_Weap[gRand][Wname]);
	        GivePlayerWeapon(playerid,Gift_Weap[gRand][Wid],Gift_Weap[gRand][Wammo]);
			//UpdateAC;
	        format(GMSG, sizeof(GMSG), "%s has unpacked a %s from his daily Christmas present.", PlayerName(playerid), GiftName);
	        SendAdminMessage(1, GMSG);
			format(GMSG, sizeof(GMSG), "[NOTICE]: %s", GMSG);
			SendClientMessageToAll(COLOR_GREEN, GMSG);
	    }
	    case -2:
		{
		    new gRand=random(2);
		    format(GiftName, sizeof(GiftName), "%s", Gift_Veh[gRand][Vname]);
			format(GMSG, sizeof(GMSG), "%s has won a %s from his daily Christmas present. It's not hacked in..", PlayerName(playerid), GiftName);
	        SendAdminMessage(1, GMSG);
   			SendClientMessage(playerid, COLOR_GREEN, "[NOTICE]: You have won a vehicle! Use /claimgift somewhere safe to spawn your vehicle! Remember, you can get jacked.");
			vGift[playerid]=Gift_Veh[gRand][Vid];
		}
		default:
		{
		    if(GiftType>20000)
		    {
		        GiftType=20000;
		    }
			format(GiftName, sizeof(GiftName), "Money($%i)", GiftType);
            GivePlayerMoney(playerid, GiftType);
		}
	}
	format(GMSG, sizeof(GMSG), "[NOTICE]: You have unpacked %s$ from the Christmas tree.", GiftName);
	SendClientMessage(playerid, COLOR_NOTICE, GMSG);
	format(GMSG, sizeof(GMSG), "%i. %s won %s.\r\n", cTotalCount[1], PlayerName(playerid), GiftName);
	new File:Gift_log=fopen(CHRISTMAS_GIFT_LOG,io_append);
	fwrite(Gift_log, GMSG);
	fclose(Gift_log);
 	cTotalCount[1]++;
	new INI:cFile = INI_Open(CHRISTMAS_GIFT_LOG);
	INI_WriteInt(cFile, CHRISTMAS_COUNT, cTotalCount[1]);
	INI_Close(cFile);
	return 1;
}


public Christmas(playerid,name[],value[])
{
    INI_String(GPlayerName(playerid),cPlayerDetails[playerid], 10);
    return 1;
}

public GetTheCount(Type, name[], value[])
{
	INI_Int(CHRISTMAS_COUNT, cTotalCount[Type]);
	return 1;
}

hook OnGameModeInit()
{
	new GC_Type;
	if(!fexist(CHRISTMAS_BLOGIN(1)))
    {
		new INI:cFile = INI_Open(CHRISTMAS_BLOGIN(1));
		INI_WriteInt(cFile, CHRISTMAS_COUNT, 0);
		INI_Close(cFile);
		cTotalCount[0]=0;
		cTotalPage++;
    }
    else
    {
		GC_Type=0;
		do
		{
			cTotalPage++;
			if(fexist(CHRISTMAS_BLOGIN(cTotalPage)))
			{
				INI_ParseFile(CHRISTMAS_BLOGIN(cTotalPage), "GetTheCount",.bExtra = true, .extra = GC_Type);
			}
			else
			{
				new INI:cFile = INI_Open(CHRISTMAS_BLOGIN(cTotalPage));
				INI_WriteInt(cFile, CHRISTMAS_COUNT, 0);
				INI_Close(cFile);
				cTotalCount[0]=0;
				break;
			}
		}while(cTotalCount[0]>=999);
	}
    if(!fexist(CHRISTMAS_GIFT_LOG))
    {
  		new INI:cFile = INI_Open(CHRISTMAS_GIFT_LOG);
		INI_WriteInt(cFile, CHRISTMAS_COUNT, 0);
		INI_Close(cFile);
		cTotalCount[1]=0;
    }
    else
    {
        GC_Type=1;
    	INI_ParseFile(CHRISTMAS_GIFT_LOG, "GetTheCount",.bExtra = true, .extra = GC_Type);
    }
	return 1;
}

hook OnPlayerConnect(playerid)
{
    Tree_CPS[playerid]=false;
	cPlayerJoinDet[playerid][0]=0;
	cPlayerJoinDet[playerid][1]=0;
	cPlayerJoinDet[playerid][1]=0;
	cPlayerDetails[playerid]="";
    vGift[playerid]=0;
	new Days[3];
	getdate(Days[0], Days[1], Days[2]);
 	if(fexist(CHRISTMAS_BLOGIN(cTotalPage))&&cTotalPage>0)
    {
        new PageC=1;
        do
        {
        	INI_ParseFile(CHRISTMAS_BLOGIN(PageC), "Christmas", .bExtra = true, .extra = playerid);
			if(sscanf(cPlayerDetails[playerid], "ii", cPlayerJoinDet[playerid][0],cPlayerJoinDet[playerid][1]))
			{
				if(PageC==cTotalPage)
				{
                    cPlayerJoinDet[playerid][2]=PageC;
				    break;
				}
			}
			else
			{
			    cPlayerJoinDet[playerid][2]=PageC;
			    break;
			}
        	PageC++;
		}while(PageC<=cTotalPage);
		INI_ParseFile(CHRISTMAS_BLOGIN(PageC), "Christmas", .bExtra = true, .extra = playerid);
		if(sscanf(cPlayerDetails[playerid], "ii", cPlayerJoinDet[playerid][0],cPlayerJoinDet[playerid][1]))
        {
        	new pMSG[10];
        	cTotalCount[0]++;
        	cPlayerJoinDet[playerid][0]=0;
			format(pMSG, sizeof(pMSG), "0 -%i", Days[2]);
			cPlayerJoinDet[playerid][2]=cTotalPage;
			new INI:cFile = INI_Open(CHRISTMAS_BLOGIN(cPlayerJoinDet[playerid][2]));
			INI_WriteString(cFile, GPlayerName(playerid), pMSG);
			INI_WriteInt(cFile, CHRISTMAS_COUNT, cTotalCount[0]);
			INI_Close(cFile);
			Gift_Taken[playerid]=false;
			if(cTotalCount[0]>=999)
			{
                cTotalPage++;
  				cTotalCount[0]=0;
				cFile=INI_Open(CHRISTMAS_BLOGIN(cTotalPage));
				INI_WriteInt(cFile, CHRISTMAS_COUNT, 0);
				INI_Close(cFile);
			}
        }
        else
        {
			if(Days[2]!=cPlayerJoinDet[playerid][1]||cPlayerJoinDet[playerid][1]<0)
			{
	           	new pMSG[10];
				format(pMSG, sizeof(pMSG), "%i -%i",cPlayerJoinDet[playerid][0], Days[2]);
				new INI:cFile = INI_Open(CHRISTMAS_BLOGIN(cPlayerJoinDet[playerid][2]));
				INI_WriteString(cFile, GPlayerName(playerid), pMSG);
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
        cPlayerJoinDet[playerid][0]=0;
		format(pMSG, sizeof(pMSG), "0 -%i", Days[2]);
		new INI:cFile = INI_Open(CHRISTMAS_BLOGIN(cTotalPage));
		INI_WriteString(cFile, GPlayerName(playerid), pMSG);
		INI_WriteInt(cFile, CHRISTMAS_COUNT, cTotalCount[0]);
		INI_Close(cFile);
		Gift_Taken[playerid]=false;
    }
	return 1;
}

hook OnPlayerSpawn(playerid)
{
	if(Gift_Taken[playerid]==false)
	{
		return SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Use /getgift in order to receive a gift.");
	}
	if(vGift[playerid]>400 && vGift[playerid]<609)
	{
	    SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Use /claimgift in order to spawn your Christmas vehicle.");
	}
	return 1;
}

CMD:getgift(playerid, params[])
{
	if(GetPVarInt(playerid, "InEvent")==1)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not use this command in event.");
	}
	if(GetPlayerInterior(playerid)!=0 || GetPlayerVirtualWorld(playerid)!=0)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can use this command in Normal world only.");
	}
	if(Gift_Taken[playerid]==false)
	{
		new GMSG[120];
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
            if(Range<GIFT_RADIUS||Range<100.0)
			{
				break;
			}
		}
		if(Range<GIFT_RADIUS)
		{
			GivePlayerChristmasGift(playerid);
			new Days[3];
			getdate(Days[0], Days[1], Days[2]);
			format(GMSG, sizeof(GMSG), "%i %i",cPlayerJoinDet[playerid][0]+1,Days[2]);
			new INI:cFile = INI_Open(CHRISTMAS_BLOGIN(cPlayerJoinDet[playerid][2]));
			INI_WriteString(cFile, GPlayerName(playerid), GMSG);
			INI_Close(cFile);
			Gift_Taken[playerid]=true;
            return 1;
		}
		else
		{
		    DisablePlayerCheckpoint(playerid);
			Tree_CPS[playerid]=true;
			SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can only use this command close to a Christmas tree.");
			SetPlayerCheckpoint(playerid, GiftPosition[CloserR][0], GiftPosition[CloserR][1], GiftPosition[CloserR][2],GIFT_RADIUS);
		    return SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Closest Christmas tree has been marked on you map. Follow the checkpoint.");
		}
	}
	else
	{
 		SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have already taken your gift for today.");
	}
	return 1;
}
CMD:claimgift(playerid, params[])
{
	if(GetPVarInt(playerid, "InEvent")==1)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can not use this command in event.");
	}
	if(GetPlayerInterior(playerid)!=0 || GetPlayerVirtualWorld(playerid)!=0)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You can use this command in Normal world only.");
	}
	if(Gift_Taken[playerid]==false)
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You haven't taken your gift yet.");
	    return cmd_getgift(playerid, params);
	}
	else
	{
	    if(vGift[playerid]>400 && vGift[playerid]<609)
	    {
	        new vehName[30];
	        if(vGift[playerid]== 447)
	            vehName="SeaSparrow";
			else if(vGift[playerid]==432)
			    vehName="Rhino";
			new GMSG[120];
			new Float:CPos[3];
	        GetPlayerPos(playerid, CPos[0], CPos[1], CPos[2]);
			new vehicleid=CreateVehicle(vGift[playerid], 0.0, 0.0, 0.0, 90.0, 0, 0, 45000);
			IsGift[vehicleid]=true;
			SetVehiclePos(vehicleid, CPos[0], CPos[1], CPos[2]+2.0);
            GetPlayerFacingAngle(playerid, CPos[0]);
			SetVehicleZAngle(vehicleid, CPos[0]);
			PutPlayerInVehicle(playerid, vehicleid, 0);
			format(GMSG, sizeof(GMSG), "[NOTICE]: %s has claimed his %s from his daily Christmas present. It's powerful, but not invincible!", PlayerName(playerid), vehName);
			SendClientMessageToAll(COLOR_GREEN, GMSG);
            vGift[playerid]=0;
			return SendClientMessage(playerid, COLOR_SYNTAX, "[NOTICE]: You can get vehicle-jacked, so be careful!");
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not have any vehicle pending to be claimed.");
	    }
	}
	return 1;
}
CMD:gototree(playerid, params[])
{
	if(IsAdmin(playerid, 1)==1)
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
	}
	return 1;
}

hook OnVehicleDeath(vehicleid)
{
	if(IsGift[vehicleid]==true)
	{
		SetVehicleToRespawn(vehicleid);
		DestroyVehicle(vehicleid);
		IsGift[vehicleid]=false;
	}
	return 1;
}
hook OnPlayerEnterCheckpoint(playerid)
{
	if(Tree_CPS[playerid]==true)
	{
	    Tree_CPS[playerid]=false;
	    SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Use /getgift to receive a gift.");
		DisablePlayerCheckpoint(playerid);
	}
	return 1;
}































