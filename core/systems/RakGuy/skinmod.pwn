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
* Filename: skinmod                                                       		 *
* Author: RakGuy                                                                 *
*********************************************************************************/
//EDITED AT LINE 250... stock Message(no) first LINE
#include <YSI\y_hooks>
#define 	Location 					0.0,0.0,0.0 //Edit here to Edit Location
#define 	RAD 						9999.0  //Edit here to Edit Radius



/////////////////////////////////ENUMS//////////////////////////////////////////
enum VIP_OBJ_DATA
{
	USED,
	MODEL,
	BONE,
	Float:ObjX,
	Float:ObjY,
	Float:ObjZ,
	Float:ObjRX,
	Float:ObjRY,
	Float:ObjRZ,
	Float:ObjSX,
	Float:ObjSY,
	Float:ObjSZ
};

enum OBJ
{
	ObjID,
	ObjName[19],
	ObjPrice
};


/////////////////////////////////////Global Variables///////////////////////////
new vipmodmsg[3200];
new VOD[MAX_PLAYERS][3][VIP_OBJ_DATA];
/////////////////////////////////////OBJECT LIST////////////////////////////////
new HAT[127][OBJ]={//Increase the Size when adding new objects
{19064, "SantaHat1", 200},
{19065, "SantaHat2", 200},
{19066, "SantaHat3", 200},
{18921, "Beret1	", 500},
{18922, "Beret2	", 500},
{18923, "Beret3	", 500},
{18924, "Beret4	", 500},
{18925, "Beret5	", 500},
{18891, "Bandana1", 500},
{18892, "Bandana2", 500},
{18893, "Bandana3", 500},
{18894, "Bandana4", 500},
{18895, "Bandana5", 500},
{18896, "Bandana6", 500},
{18897, "Bandana7", 500},
{18898, "Bandana8", 500},
{18899, "Bandana9", 500},
{18900, "Bandana10", 500},
{18901, "Bandana11", 500},
{18902, "Bandana12", 500},
{18903, "Bandana13", 500},
{18904, "Bandana14", 500},
{18905, "Bandana15", 500},
{18906, "Bandana16", 500},
{18907, "Bandana17", 500},
{18908, "Bandana18", 500},
{18909, "Bandana19", 500},
{18910, "Bandana20", 500},
{18640, "Hair1	", 800},
{18975, "Hair2	", 800},
{19077, "Hair3	", 800},
{19274, "Hair5	", 800},
{18639, "BlackHat1", 1000},
{19094,	"BurgerShot", 1000},
{18939, "CapBack1", 1000},
{18940, "CapBack2", 1000},
{18941, "CapBack3", 1000},
{18942, "CapBack4", 1000},
{18943, "CapBack5", 1000},
{18953, "CapKnit1", 1000},
{18954, "CapKnit2", 1000},
{18955, "CapOverEye1", 1000},
{18956, "CapOverEye2", 1000},
{18957, "CapOverEye3", 1000},
{18958, "CapOverEye4", 1000},
{18959, "CapOverEye5", 1000},
{18960, "CapRimUp1", 1000},
{18961, "CapTrucker1", 1000},
{18638, "HardHat1", 1000},
{19093, "HardHat2", 1000},
{19160, "HardHat3", 1000},
{18926, "Hat1	", 1000},
{18927, "Hat2	", 1000},
{18928, "Hat3	", 1000},
{18929, "Hat4	", 1000},
{18930, "Hat5	", 1000},
{18931, "Hat6	", 1000},
{18932, "Hat7	", 1000},
{18933, "Hat8	", 1000},
{18934, "Hat9	", 1000},
{18935, "Hat10	", 1000},
{18944, "HatBoater1", 1000},
{18945, "HatBoater2", 1000},
{18946, "HatBoater3", 1000},
{18947, "HatBowler1", 1000},
{18948, "HatBowler2", 1000},
{18949, "HatBowler3", 1000},
{18950, "HatBowler4", 1000},
{18951, "HatBowler5", 1000},
{19488, "HatBowler6", 1000},
{18967, "HatMan1", 1000},
{18968, "HatMan2", 1000},
{18969, "HatMan3", 1000},
{18970, "HatTiger1", 1000},
{19067, "HoodyHat1", 1000},
{19068, "HoodyHat2", 1000},
{19069, "HoodyHat3", 1000},
{19520, "pilotHat01", 1000},
{18964, "SkullyCap1", 1000},
{18965, "SkullyCap2", 1000},
{18966, "SkullyCap3", 1000},
{19352, "tophat01", 1000},
{19487, "tophat02", 1000},
{18636, "PoliceCap1", 1100},
{19099, "PoliceCap2", 1100},
{19100, "PoliceCap3", 1100},
{19521, "policeHat01", 1100},
{19161, "PoliceHat1", 1100},
{19162, "PoliceHat2", 1100},
{19095, "CowboyHat1", 1100},
{18962, "CowboyHat2", 1100},
{19096, "CowboyHat3", 1100},
{19097, "CowboyHat4", 1100},
{19098, "CowboyHat5", 1100},
{19137, "CluckinBell", 1200},
{18971, "HatCool1", 1300},
{18972, "HatCool2", 1300},
{18973, "HatCool3", 1300},
{19330, "fire_hat01", 1400},
{19331, "fire_hat02", 1400},
{19116, "PlainHelmet1", 1500},
{19117, "PlainHelmet2", 1500},
{19118, "PlainHelmet3", 1500},
{19119, "PlainHelmet4", 1500},
{19120, "PlainHelmet5", 1500},
{19113, "SillyHelmet1", 1500},
{19114, "SillyHelmet2", 1500},
{19115, "SillyHelmet3", 1500},
{19101, "ArmyHelmet1", 1500},
{19110, "ArmyHelmet10", 1500},
{19111, "ArmyHelmet11", 1500},
{19112, "ArmyHelmet12", 1500},
{19102, "ArmyHelmet2", 1500},
{19103, "ArmyHelmet3", 1500},
{19104, "ArmyHelmet4", 1500},
{19105, "ArmyHelmet5", 1500},
{19106, "ArmyHelmet6", 1500},
{19107, "ArmyHelmet7", 1500},
{19108, "ArmyHelmet8", 1500},
{19109, "ArmyHelmet9", 1500},
{18936, "Helmet1", 1500},
{18937, "Helmet2", 1500},
{18938, "Helmet3", 1500},
{19141, "SWATHelmet1", 2000},
{19514, "SWATHgrey", 2000},
{18952, "BoxingShield", 2000},
{19314, "bullhorns", 2000}
};

new GLASS[48][OBJ]=
{//Increase the Size when adding new objects
{19085,"EyePatch1", 500},
{19006,	"GlassesType1", 500},
{19007,	"GlassesType2", 500},
{19008,	"GlassesType3", 500},
{19009,	"GlassesType4", 500},
{19010,	"GlassesType5", 500},
{19011,	"GlassesType6", 500},
{19012,	"GlassesType7", 500},
{19013,	"GlassesType8", 500},
{19014,	"GlassesType9", 500},
{19015,	"GlassesType10", 500},
{19016,	"GlassesType11", 500},
{19017,	"GlassesType12", 500},
{19018,	"GlassesType13", 500},
{19019,	"GlassesType14", 500},
{19020,	"GlassesType15", 500},
{19021,	"GlassesType16", 500},
{19022,	"GlassesType17", 500},
{19023,	"GlassesType18", 500},
{19024,	"GlassesType19", 500},
{19025,	"GlassesType20", 500},
{19026,	"GlassesType21", 500},
{19027,	"GlassesType22", 500},
{19028,	"GlassesType23", 500},
{19029,	"GlassesType24", 500},
{19030,	"GlassesType25", 500},
{19031,	"GlassesType26", 500},
{19032,	"GlassesType27", 500},
{19033,	"GlassesType28", 500},
{19034,	"GlassesType29", 500},
{19035,	"GlassesType30", 500},
{19138,	"PoliceGlasses1", 500},
{19139,	"PoliceGlasses2", 500},
{19140,	"PoliceGlasses3", 500},
{18974,	"ZorroMask", 500},
{18911,	"Bandana1", 750},
{18912,	"Bandana2", 750},
{18913,	"Bandana3", 750},
{18914,	"Bandana4", 750},
{18915,	"Bandana5", 750},
{18916,	"Bandana6", 750},
{18917,	"Bandana7", 750},
{18918,	"Bandana8", 750},
{18919,	"Bandana9", 750},
{18920,	"Bandana10", 750},
{19036,	"HockeyMask1", 1000},
{19037,	"HockeyMask2", 1000},
{19038,	"HockeyMask3", 1000}
};

new HELMET[7][OBJ]={//Increase the Size when adding new objects
{18963,	"CJElvisHead	", 2500},
{18645,	"MotorcycleHelmet1", 2500},
{18976,	"MotorcycleHelmet2", 2500},
{18977,	"MotorcycleHelmet3", 2500},
{18978,	"MotorcycleHelmet4", 2500},
{18979,	"MotorcycleHelmet5", 2500},
{19163,	"GimpMask1	", 2500}
};
///////////////////////////////////STOCKS///////////////////////////////////////
/*****************************Message Creation Stock***************************/
stock Message(No)
{
    vipmodmsg=""; //ADD THIS BACK.. This resets the MSG string.. Please
	switch(No)
	{
		case 0:
		{
			for(new i=0; i<127; i++)
			{
				format(vipmodmsg, sizeof(vipmodmsg), "%s%s\t\t\t{FF0000}%i\n", vipmodmsg, HAT[i][ObjName],HAT[i][ObjPrice]);
			}
			format(vipmodmsg, sizeof(vipmodmsg), "%s{00FF00}Edit HAT\n{ff0000}Remove HAT", vipmodmsg);
		}
		case 1:
		{
			for(new i=0; i<48; i++)
			{
				format(vipmodmsg, sizeof(vipmodmsg), "%s%s\t\t\t{FF0000}%i\n", vipmodmsg, GLASS[i][ObjName], GLASS[i][ObjPrice]);
			}
			format(vipmodmsg, sizeof(vipmodmsg), "%s{00FF00}Edit Glass\n{ff0000}Remove Glass", vipmodmsg);
		}
		case 2:
		{
			for(new i=0; i<7; i++)
			{
				format(vipmodmsg, sizeof(vipmodmsg), "%s%s\t\t\t{FF0000}%i\n", vipmodmsg, HELMET[i][ObjName],HELMET[i][ObjPrice]);
			}
			format(vipmodmsg, sizeof(vipmodmsg), "%s{00FF00}Edit Helmet\n{ff0000}Remove Helmet", vipmodmsg);
		}
	}
}
/******************************************************************************/
/*****************************To get the Price of Skin Mod*********************/
stock GetObjectCost(playerid, Obj, ind) //Used @ line 641
{
	if(VOD[playerid][ind][USED]!=1)
	{
		format(vipmodmsg, sizeof(vipmodmsg), "[Notice]You can re-edit the object using [/editmod %i]", ind); //Message
    	SendClientMessage(playerid,COLOR_NOTICE, vipmodmsg);
		new Cost;
		VOD[playerid][ind][USED]=1;
		if(isVIP(playerid)<1)
		{
			switch(ind)
			{
			    case 0:
			    {
			        for(new i=0;i<127;i++)
			        {
			            if(HAT[i][ObjID]==Obj)
						{
							Cost=HAT[i][ObjPrice];
							break;
						}
			        }
			    }
			    case 1:
			    {
		     		for(new i=0;i<48;i++)
			        {
			            if(GLASS[i][ObjID]==Obj)
						{
							Cost=GLASS[i][ObjPrice];
							break;
						}
			        }
			    }
			    case 2:
			    {
			        for(new i=0;i<7;i++)
			        {
			            if(HELMET[i][ObjID]==Obj)
						{
							Cost=HELMET[i][ObjPrice];
							break;
						}
			        }
			    }
			}
		}
		else
		{
	        	format(vipmodmsg, sizeof(vipmodmsg), "~g~Free Object Purchased",Cost); //Message
				GameTextForPlayer(playerid, vipmodmsg, 5000, 1); /*HERE*/
				return 1;
		}
		format(vipmodmsg, sizeof(vipmodmsg), "~r~-$%i",Cost);
		GameTextForPlayer(playerid, vipmodmsg, 5000, 1);
		GivePlayerMoney(playerid, -Cost);
		new moneystring[256];
		format(moneystring, sizeof(moneystring), "%s(%d) lost %d$ by buying skinmod.", PlayerName(playerid), playerid, Cost);
		MoneyLog(moneystring);
	}
	else
	{
		format(vipmodmsg, sizeof(vipmodmsg), "[ServMSG]Skinmod edited and saved.", ind); //Message
    	SendClientMessage(playerid,COLOR_NOTICE, vipmodmsg);
	}
	return 1;
}
/******************************************************************************/
/********************Animation and Message during Editing**********************/
stock AnimMsg(playerid)
{
	format(vipmodmsg, sizeof(vipmodmsg), "{FFFFFF}Hold {00FF00}Sprint Key {FFFFFF}and move mouse to shift Camera position!"); //Message
	SendClientMessage(playerid, -1, vipmodmsg);
	ApplyAnimation(playerid, "GANGS", "DEALER_IDLE",0.0,1,0,0,0,0);
	return 1;
}
/******************************************************************************/
stock SetObjectBack(playerid)
{
	for(new i=0; i<3; i++)
	{
		if(VOD[playerid][i][USED]==1)
		{
    	    SetPlayerAttachedObject(playerid, i, VOD[playerid][i][MODEL],VOD[playerid][i][BONE], VOD[playerid][i][ObjX], VOD[playerid][i][ObjY], VOD[playerid][i][ObjZ],VOD[playerid][i][ObjRX],VOD[playerid][i][ObjRY],VOD[playerid][i][ObjRZ],VOD[playerid][i][ObjSX],VOD[playerid][i][ObjSY],VOD[playerid][i][ObjSZ]);
		}
	}
 	return 1;
}
//////////////////////////////////COMMANDS//////////////////////////////////////
/****************************Command for Main Dialog Box***********************/
CMD:skinmod(playerid, params)
{
	if(isVIP(playerid) >= 2 || AdminLvl(playerid) >= ACMD_SILVER)
	{
		if(IsPlayerInRangeOfPoint(playerid, RAD, Location))
		{
			ShowPlayerDialog(playerid, DIALOG_SKIN_MODS, 2, "Skin Modifications", "Hair\nFace\nHead\n{FF0000}Remove All", "Select", "Exit");
		}
		else
		{
			SendClientMessage(playerid, COLOR_WARNING , "You have to be near/around Skin-Mod Shop to use this command"); //Message
		}
		return 1;
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be a silver donator to use this command.");
	    return 1;
	}
}

CMD:clothes(playerid, params)
{
	cmd_skinmod(playerid, params);
	return 1;
}
/******************************************************************************/
/**********************************To-Reuse Bought Objects*********************/
CMD:placemod(playerid, params[])
{
	if(isVIP(playerid) >= 2 || AdminLvl(playerid) >= ACMD_SILVER)
	{
		new index;
		if((sscanf(params, "i", index))||(index>=3))
			SendClientMessage(playerid, COLOR_SYNTAX , "[USAGE:] /placemod [SlotID](0-Hair/1-Face/2-Head)"); //Message
		else
		{
			if(VOD[playerid][index][MODEL]==0)
			{
	            SendClientMessage(playerid, COLOR_WARNING , "[ERROR:]You have no object saved on that Slot!!!"); //Message
			}
			else
			{
			    switch(index)
			    {
					case 0:
					{
					    RemovePlayerAttachedObject(playerid, 2);
					}
					case 1:
					{
					    RemovePlayerAttachedObject(playerid, 2);
					}
					case 2:
					{
					    RemovePlayerAttachedObject(playerid, 0);
					    RemovePlayerAttachedObject(playerid, 1);
					}
			    }
				SetPlayerAttachedObject(playerid, index, VOD[playerid][index][MODEL],VOD[playerid][index][BONE], VOD[playerid][index][ObjX], VOD[playerid][index][ObjY], VOD[playerid][index][ObjZ],VOD[playerid][index][ObjRX],VOD[playerid][index][ObjRY],VOD[playerid][index][ObjRZ],VOD[playerid][index][ObjSX],VOD[playerid][index][ObjSY],VOD[playerid][index][ObjSZ]);
			}
		}
		return 1;
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be a silver donator to use this command.");
	    return 1;
	}
}

CMD:placeclothes(playerid, params[])
{
	cmd_placemod(playerid, params);
	return 1;
}

/******************************************************************************/
/**********************************To-Edit Bought Objects*********************/
CMD:editmod(playerid, params[])
{
	if(isVIP(playerid) >= 2 || AdminLvl(playerid) >= ACMD_SILVER)
	{
 		new index;
		if((sscanf(params, "i", index))||(index>=3))
			SendClientMessage(playerid, COLOR_SYNTAX , "[USAGE:] /editmod [SlotID](0-Hair/1-Face/2-Head)"); //Message
		else
		{
			if(!IsPlayerAttachedObjectSlotUsed(playerid, index))
			{
	            SendClientMessage(playerid, COLOR_WARNING , "[ERROR:]You have no object in that specified Slot!!"); //Message
			}
			else
			{
				EditAttachedObject(playerid, index);
	            AnimMsg(playerid);
			}
		}
		return 1;
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You need to be a silver donator to use this command.");
	    return 1;
	}

}

CMD:editclothes(playerid, params[])
{
	cmd_editmod(playerid, params);
	return 1;
}

CMD:changeclothes(playerid, params[])
{
	cmd_editmod(playerid, params);
	return 1;
}
/******************************************************************************/

/////////////////////////////////PUBLIC/////////////////////////////////////////
/*********Deleting Saved objects so that next player can't use it**************/
hook OnPlayerDisconnect(playerid, reason)
{
 	for(new i=0; i<3; i++)
	{
        VOD[playerid][i][MODEL]=0;
	   	VOD[playerid][i][USED]=0;
	}
	return 1;
}
/******************************************************************************/
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_SKIN_MODS)
    {
        if(!response)
        {
            SendClientMessage(playerid, COLOR_NOTICE, "Skin Modification Cancelled."); //Message

        }
        else
        {

			switch(listitem)
			{
			    case 0:
			    {
			        Message(listitem);
			        ShowPlayerDialog(playerid, DIALOG_SKIN_MODS_HATS, 2, "HAIR MODS",vipmodmsg, "Select", "Back");
			    }
			    case 1:
			    {
			        Message(listitem);
			    	ShowPlayerDialog(playerid, DIALOG_SKIN_MODS_GLASSES, 2, "FACE MODS",vipmodmsg, "Select", "Back");
			    }
			    case 2:
			    {
			        Message(listitem);
			    	ShowPlayerDialog(playerid, DIALOG_SKIN_MODS_HELMETS, 2, "HEAD MODS",vipmodmsg, "Select", "Back");
			    }
			    case 3:
			    {
			        for(new i=0; i<3; i++)
					{
					    RemovePlayerAttachedObject(playerid, i);
				    	VOD[playerid][i][USED]=0;
					}
				}
			}
		}
    }
    if(dialogid == DIALOG_SKIN_MODS_HATS)
    {
    	if(!response)
        {
            ShowPlayerDialog(playerid, DIALOG_SKIN_MODS, 2, "Skin Modifications", "Hair\nFace\nHead\n{FF0000}Remove All", "Select", "Exit");
        }
		else
		{
		    if(listitem<sizeof(HAT))
			{
			    RemovePlayerAttachedObject(playerid, 2);
			    VOD[playerid][2][USED]=0;
		    	SetPlayerAttachedObject(playerid, 0, HAT[listitem][ObjID], 2, 0.0, 0.0, 0.0);
		    	VOD[playerid][0][USED]=0;
				EditAttachedObject(playerid, 0);
				AnimMsg(playerid);
			}
			if(listitem==sizeof(HAT))
			{
			    if(IsPlayerAttachedObjectSlotUsed(playerid, 0))
				{
			    	EditAttachedObject(playerid, 0);
			    	AnimMsg(playerid);
				}
			}
			if(listitem == sizeof(HAT)+1)
			{
			    SendClientMessage(playerid, COLOR_NOTICE, "[Notice:] Object Removed"); //Message
			    RemovePlayerAttachedObject(playerid, 0);
			    VOD[playerid][0][USED]=0;
			}
		}
    }

    if(dialogid == DIALOG_SKIN_MODS_GLASSES)
    {
    	if(!response)
        {
            ShowPlayerDialog(playerid, DIALOG_SKIN_MODS, 2, "Skin Modifications", "Hair\nFace\nHead\n{FF0000}Remove All", "Select", "Exit");
        }
		else
		{
		    if(listitem<sizeof(GLASS))
			{
			    RemovePlayerAttachedObject(playerid, 2);
			    VOD[playerid][2][USED]=0;
				SetPlayerAttachedObject(playerid, 1, GLASS[listitem][ObjID], 2, 0.0, 0.0, 0.0);
				VOD[playerid][1][USED]=0;
				EditAttachedObject(playerid, 1);
				AnimMsg(playerid);
			}
			if(listitem==7)
			{
			    if(IsPlayerAttachedObjectSlotUsed(playerid, 1))
				{

			    	EditAttachedObject(playerid, 1);
			    	AnimMsg(playerid);
				}
			}
			if(listitem==8)
			{
			    SendClientMessage(playerid, COLOR_NOTICE, "[Notice:] Object Removed"); //Message
			    RemovePlayerAttachedObject(playerid, 1);
			    VOD[playerid][1][USED]=0;
			}
		}
    }
    if(dialogid == DIALOG_SKIN_MODS_HELMETS)
    {
    	if(!response)
        {
            ShowPlayerDialog(playerid, DIALOG_SKIN_MODS, 2, "Skin Modifications", "Hair\nFace\nHead\n{FF0000}Remove All", "Select", "Exit");
        }
		else
		{
		    if(listitem<sizeof(HELMET))
			{
			    for(new i=0; i<2; i++)
			    {
					if(VOD[playerid][i][USED]==1)
					{
				    	RemovePlayerAttachedObject(playerid, i);
	                    VOD[playerid][i][USED]=0;
					}
				}
				SetPlayerAttachedObject(playerid, 2, HELMET[listitem][ObjID], 2, 0.0, 0.0, 0.0);
				VOD[playerid][2][USED]=0;
				EditAttachedObject(playerid, 2);
				AnimMsg(playerid);
			}
			if(listitem==sizeof(HELMET))
			{
				if(IsPlayerAttachedObjectSlotUsed(playerid, 2))
				{
			    	EditAttachedObject(playerid, 2);
			    	AnimMsg(playerid);
				}
			}
			if(listitem==sizeof(HELMET)+1)
			{
			    SendClientMessage(playerid, COLOR_NOTICE, "[Notice:] Object Removed"); //Message
			    RemovePlayerAttachedObject(playerid, 2);
			    VOD[playerid][2][USED]=0;
			}
		}
    }
	return 1;
}



hook OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if(response)
    {
	    VOD[playerid][index][MODEL] = modelid;
		VOD[playerid][index][BONE] = boneid;
  		VOD[playerid][index][ObjX] = fOffsetX;
  		VOD[playerid][index][ObjY] = fOffsetY;
	    VOD[playerid][index][ObjZ] = fOffsetZ;
     	VOD[playerid][index][ObjRX] = fRotX;
      	VOD[playerid][index][ObjRY] = fRotY;
       	VOD[playerid][index][ObjRZ] = fRotZ;
       	if(fScaleX<2.5&&fScaleY<2.5&&fScaleZ<2.5)
       	{
	       	VOD[playerid][index][ObjSX] = fScaleX;
		    VOD[playerid][index][ObjSY] = fScaleY;
		    VOD[playerid][index][ObjSZ] = fScaleZ;
		}
		else
		{
		    format(vipmodmsg, sizeof(vipmodmsg), "[Error]Over-Sized Object, Kindly re-edit it using [/editmod %i]", index); //Message
		    SendClientMessage(playerid,COLOR_NOTICE, vipmodmsg);
			if(VOD[playerid][index][USED]==1)
			{
				fScaleX=VOD[playerid][index][ObjSX];
			    fScaleY=VOD[playerid][index][ObjSY];
			    fScaleZ=VOD[playerid][index][ObjSZ];
			}
			else
		    {
			    fScaleX=fScaleY=fScaleZ=1.0;
				VOD[playerid][index][ObjSX] = 1.0;
			    VOD[playerid][index][ObjSY] = 1.0;
			    VOD[playerid][index][ObjSZ] = 1.0;
			}
		}
		SetPlayerAttachedObject(playerid, index, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ,fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
		GetObjectCost(playerid, VOD[playerid][index][MODEL],index); //Stock at Line 304
		ClearAnimations(playerid);
 	}
 	else
 	{
		RemovePlayerAttachedObject(playerid, index);
		VOD[playerid][index][USED]=0;
 		ClearAnimations(playerid);
 	    if(VOD[playerid][index][USED]==1)
		{
		    format(vipmodmsg, sizeof(vipmodmsg), "Object Removed, use [/placemod %i] to place it back on.", index); //Message
 			SendClientMessage(playerid,COLOR_NOTICE,vipmodmsg);
		}
		else
		{
  			SendClientMessage(playerid, COLOR_NOTICE, "[Notice:] Object Removed"); //Message
		}
 	}
 	return 1;
}
/*********************Re-Spawning Objects if they were used********************/
hook OnPlayerSpawn(playerid)
{
	SetObjectBack(playerid);
	return 1;
}
/******************************************************************************/
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(IsPlayerAttachedObjectSlotUsed(playerid, 0)||IsPlayerAttachedObjectSlotUsed(playerid, 1)||IsPlayerAttachedObjectSlotUsed(playerid, 2))
	{
		if((newkeys & KEY_HANDBRAKE) && !(oldkeys & KEY_HANDBRAKE) && (GetPlayerWeapon(playerid)==34))
		{
		    for(new i=0; i<3; i++)
		    {
		        if(VOD[playerid][i][USED]==1)
				{
					RemovePlayerAttachedObject(playerid, i);
				}
			}
		}
	}
	if((oldkeys & KEY_HANDBRAKE) && !(newkeys & KEY_HANDBRAKE)&& (GetPlayerWeapon(playerid)==34))
	{
        SetObjectBack(playerid);
	}
	return 1;
}

