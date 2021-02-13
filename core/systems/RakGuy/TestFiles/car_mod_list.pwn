#include <YSI\y_hooks>

#define MAX_MODELS 212
/*
#define DIALOG_CARMOD1 2
#define DIALOG_CARMOD2 3
#define DIALOG_CARMOD3 4
#define DIALOG_CARMOD4 5
#define DIALOG_CARMOD5 6*/
#define MAX_WHEELS 17
#define CARMOD_VEHID 15
#define CARMODTYPE_NULL 15
#define CARMODTYPE_PAINT 14

new modmsg[256];
enum ModInfo
{
	ObjectID,
	Comp_Name[32]

};

new WheelComponents[MAX_WHEELS] = {	1025, 1073, 1074, 1075, 1076,
									1077, 1078, 1079,
									1080, 1081, 1082,
									1083, 1084, 1085,
									1096, 1097, 1098};
enum
{
	FRNT_BUMPER,
	REAR_BUMPER,
	ROOF,
	HOOD,
	SIDESKIRT,
	SPOILER,
	EXHAUST,
	WHEELS,
	PAINTJOB
}
new CurrentModCost[MAX_PLAYERS];

new Text:SelectionTD[MAX_PLAYERS];
//0-13 - Mods... 14 - PaintJob... 15 - VehicleID;

new TempModSave[MAX_PLAYERS][16];
new CurrentMods[MAX_VEHICLES][15];
new bool:IsPlayerModding[MAX_PLAYERS];
new CurrentModLocation[MAX_PLAYERS];
new CurrentModObjLocation[MAX_PLAYERS];
enum PosDetails
{
	Mod_Slot,
	Mod_Price,
	Mod_Name[24]
};

new ModPositionNames[12][PosDetails] =
{
	{CARMODTYPE_NULL, 0, "INVALID_MOD_NAME"},
	{CARMODTYPE_NITRO, 450, "Nitrous-Oxide"},
	{CARMODTYPE_PAINT, 1000, "PaintJob"},
	{CARMODTYPE_FRONT_BUMPER, 400, "Front Bumper"},
	{CARMODTYPE_REAR_BUMPER, 350, "Rear Bumper"},
	{CARMODTYPE_ROOF, 150, "Roof"},
	{CARMODTYPE_HOOD, 100, "Hood"},
	{CARMODTYPE_HYDRAULICS, 500, "Hydraulics"},
	{CARMODTYPE_SIDESKIRT, 250 ,"SideSkirt"},
	{CARMODTYPE_SPOILER, 300, "Spoiler"},
	{CARMODTYPE_EXHAUST, 200, "Exhaust"},
	{CARMODTYPE_WHEELS, 400, "Wheels"}
};

new ModInfoArray[194][ModInfo] =
{
	{1000, "Pro"},
	{1001, "Win"},
	{1002, "Drag"},
	{1003, "Alpha"},
	{1004, "Champ Scoop"},
	{1005, "Fury Scoop"},
	{1006, "Roof Scoop"},
	{1007, "Sideskirt"},
	{1008, "5 Cans of Nitrous"},
	{1009, "2 Cans of Nitrous"},
	{1010, "10 Cans of Nitrous"},
	{1011, "Race Scoop"},
	{1012, "Worx Scoop"},
	{1013, "Round Fog"},
	{1014, "Champ"},
	{1015, "Race"},
	{1016, "Worx"},
	{1017, "Sideskirt"},
	{1018, "Upswept"},
	{1019, "Twin"},
	{1020, "Large"},
	{1021, "Medium"},
	{1022, "Small"},
	{1023, "Fury"},
	{1024, "Square Fog"},
	{1025, "Off Road"},
	{1026, "Alien"},
	{1027, "Alien"},
	{1028, "Alien"},
	{1029, "X-Flow"},
	{1030, "X-Flow"},
	{1031, "X-Flow"},
	{1032, "Alien Roof Vent"},
	{1033, "X-Flow Roof Vent"},
	{1034, "Alien"},
	{1035, "X-Flow Roof Vent"},
	{1036, "Alien"},
	{1037, "X-Flow"},
	{1038, "Alien Roof Vent"},
	{1039, "X-Flow"},
	{1040, "Alien"},
	{1041, "X-Flow"},
	{1042, "Chrome"},
	{1043, "Slamin"},
	{1044, "Chrome"},
	{1045, "X-Flow"},
	{1046, "Alien"},
	{1047, "Alien"},
	{1048, "X-Flow"},
	{1049, "Alien"},
	{1050, "X-Flow"},
	{1051, "Alien"},
	{1052, "X-Flow"},
	{1053, "X-Flow"},
	{1054, "Alien"},
	{1055, "Alien"},
	{1056, "Alien"},
	{1057, "X-Flow"},
	{1058, "Alien"},
	{1059, "X-Flow"},
	{1060, "X-Flow"},
	{1061, "X-Flow"},
	{1062, "Alien"},
	{1063, "X-Flow"},
	{1064, "Alien"},
	{1065, "Alien"},
	{1066, "X-Flow"},
	{1067, "Alien"},
	{1068, "X-Flow"},
	{1069, "Alien"},
	{1070, "X-Flow"},
	{1071, "Alien"},
	{1072, "X-Flow"},
	{1073, "Shadow"},
	{1074, "Mega"},
	{1075, "Rimshine"},
	{1076, "Wires"},
	{1077, "Classic"},
	{1078, "Twist"},
	{1079, "Cutter"},
	{1080, "Switch"},
	{1081, "Grove"},
	{1082, "Import"},
	{1083, "Dollar"},
	{1084, "Trance"},
	{1085, "Atomic"},
	{1086, "Stereo"},
	{1087, "Hydraulics"},
	{1088, "Alien"},
	{1089,  "X-Flow"},
	{1090, "Alien"},
	{1091, "X-Flow"},
	{1092, "Alien"},
	{1093, "X-Flow"},
	{1094, "Alien"},
	{1095, "X-Flow"},
	{1096, "Ahab"},
	{1097, "Virtual"},
	{1098, "Access"},
	{1099, "Chrome"},
	{1100, "Chrome Grill"},
	{1101, "Chrome Flames"},
	{1102, "Chrome Strip"},
	{1103, "Convertible"},
	{1104, "Chrome"},
	{1105, "Slamin"},
	{1106, "Chrome Arches"},
	{1107, "Chrome Strip"},
	{1108, "Chrome Strip"},
	{1109, "Bullbars Chrome"},
	{1110, "Bullbars Slamin"},
	{1111, "Front Sign? Little Sign?"},
	{1112, "Front Sign? Little Sign?" },
	{1113, "Chrome"},
	{1114, "Slamin"},
	{1115, "Bullbars Chrome"},
	{1116, "Bullbars Slamin"},
	{1117, "Bumper Chrome"},
	{1118, "Chrome Trim"},
	{1119, "Wheelcovers"},
	{1120, "Chrome Trim"},
	{1121, "Wheelcovers"},
	{1122, "Chrome Flames"},
	{1123, "Bullbars Bullbar Chrome Bars"},
	{1124, "Chrome Arches"},
	{1125, "Bullbar Chrome Lights"},
	{1126, "Chrome Exhaust"},
	{1127, "Slamin Exhaust"},
	{1128, "Vinyl Hardtop"},
	{1129, "Chrome"},
	{1130, "Hardtop"},
	{1131, "Softtop"},
	{1132, "Slamin"},
	{1133, "Chrome Strip"},
	{1134, "Chrome Strip"},
	{1135, "Slamin"},
	{1136, "Chrome"},
	{1137, "Chrome Strip"},
	{1138, "Alien"},
	{1139, "X-Flow"},
	{1140, "Bumper X-Flow"},
	{1141, "Bumper Alien"},
	{1142, "Oval Vents"},
	{1143, "Oval Vents"},
	{1144, "Square Vents"},
	{1145, "Square Vents"},
	{1146, "X-Flow"},
	{1147, "Alien"},
	{1148, "X-Flow"},
	{1149, "Alien"},
	{1150, "Alien"},
	{1151, "X-Flow"},
	{1152, "X-Flow"},
	{1153, "Alien"},
	{1154, "Alien"},
	{1155, "Alien"},
	{1156, "X-Flow"},
	{1157, "X-Flow"},
	{1158, "X-Flow"},
	{1159, "Alien"},
	{1160, "Alien"},
	{1161, "X-Flow"},
	{1162, "Alien"},
	{1163, "X-Flow"},
	{1164, "Alien"},
	{1165, "X-Flow"},
	{1166, "Alien"},
	{1167, "X-Flow"},
	{1168, "Alien"},
	{1169, "Alien"},
	{1170, "X-Flow"},
	{1171, "Alien"},
	{1172, "X-Flow"},
	{1173, "X-Flow"},
	{1174, "Chrome"},
	{1175, "Slamin"},
	{1176, "Chrome"},
	{1177, "Slamin"},
	{1178, "Slamin"},
	{1179, "Chrome"},
	{1180, "Chrome"},
	{1181, "Slamin"},
	{1182, "Chrome"},
	{1183, "Slamin"},
	{1184, "Chrome"},
	{1185, "Slamin"},
	{1186, "Slamin"},
	{1187, "Chrome"},
	{1188, "Slamin"},
	{1189, "Chrome"},
	{1190, "Slamin"},
	{1191, "Chrome"},
	{1192, "Chrome"},
	{1193, "Slamin"}
};

enum Mod_Details
{
	f_bump[2],
	r_bump[2],
	roof[2],
	hood[6],
	l_sskirt[4],
	r_sskirt[4],
	spoiler[7],
	exhaust[5]
}

new CarModList[MAX_MODELS][Mod_Details];

stock IsModdable(modelid)
{
	switch(modelid)
	{
		case 406, 417, 425, 430, 432, 435, 441, 444, 446, 447, 448, 449, 450, 452, 453, 454, 460, 461, 462,
			 463, 464, 465, 468, 472, 473, 476, 481, 484, 486, 487, 493, 497, 501, 509, 510, 511, 512, 513,
			 519, 520, 521, 522, 523, 531, 532, 537, 538, 548, 553, 556, 557, 563, 564, 569, 570, 577, 581,
			 584, 586, 590, 591, 592, 593, 595, 606, 607, 608, 610, 611:
		{
			return 0;
		}
		default:
		{
			return 1;
		}
	}
	return 0;
}

stock IsHydrualics(modelid)
{
	switch(modelid)
	{
			case 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418,
			419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 431, 432, 433, 434, 435, 436, 437, 438, 439,
			440, 441, 442, 443, 444, 445, 447, 450, 451, 455, 456, 457, 458, 459, 460, 464, 465, 466, 467, 469,
			470, 471, 474, 475, 476, 477, 478, 479, 480, 482, 483, 485, 486, 487, 488, 489, 490, 491, 492, 494,
			495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 511, 512, 513, 514, 515, 516,
			517, 518, 519, 520, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 539, 540, 541,
			542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561,
			562, 563, 564, 565, 566, 567, 568, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 582, 583, 584,
			585, 587, 588, 589, 591, 592, 593, 594, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610,
			611:
			    return 1;
			default:
			    return 0;
	}
	return 0;
}

/*GetPaintJobCount(modelid)
{
	switch(modelid)
	{
		case 483:
			return 1;
		case 575:
			return 2;
		case 534, 535, 536, 558, 559, 560, 561, 562, 565, 567, 576:
		{
			return 3;
		}
		default:
			return 0;
	}
	return 0;
}*/

HasWheels(modelid)
{
	switch(modelid)
	{
	    case 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412,
			413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425,
			426, 427, 428, 429, 431, 432, 433, 434, 435, 436, 437, 438, 439,
			440, 441, 442, 443, 444, 445, 447, 450, 451, 455, 456, 457, 458,
			459, 460, 464, 465, 466, 467, 469, 470, 471, 474, 475, 476, 477,
			478, 479, 480, 482, 483, 485, 486, 487, 488, 489, 490, 491, 492,
			494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506,
			507, 508, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 524,
			525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 539,
			540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552,
			553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565,
			566, 567, 568, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580,
			582, 583, 584, 585, 587, 588, 589, 591, 592, 593, 594, 599, 600,
			601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611:
			return 1;
		default:
			return 0;
	}
	return 0;
}

stock ModRequirements(playerid)
{
	if(Event_Currently_On() == 13, 14, 15, 16, 17, 18, 21 && GetPVarInt(playerid, "PlayerStatus") == 1 && Event_InProgress == 0)
	{
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You cannot use this command before the event starts.");
	}	
	if(IsPlayerInAnyVehicle(playerid) == 0)
		return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You have to be in a vehicle to use this command.");
	return 1;
}

stock ModSetTextDraw(Text:textid, msg[])
{
    TextDrawSetString(textid, msg);
	return 1;
}

stock CreateModText(playerid)
{
	SelectionTD[playerid] = TextDrawCreate(328.000000, 381.000000, "~r~<< ~w~ItemName~r~>>~n~Extra Info");
	TextDrawAlignment(SelectionTD[playerid], 2);
	TextDrawBackgroundColor(SelectionTD[playerid], 255);
	TextDrawFont(SelectionTD[playerid], 2);
	TextDrawLetterSize(SelectionTD[playerid], 0.619999, 2.200000);
	TextDrawSetOutline(SelectionTD[playerid], 1);
	TextDrawSetProportional(SelectionTD[playerid], 1);//Centered for each resolution
}

stock IsNOSable(modelid)
{
	switch(modelid)
	{
		case 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411,
			412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423,
			424, 425, 426, 427, 428, 429, 431, 432, 433, 434, 435, 436,
			437, 438, 439, 440, 441, 442, 443, 444, 445, 447, 450, 451,
			455, 456, 457, 458, 459, 460, 464, 465, 466, 467, 469, 470,
			471, 474, 475, 476, 477, 478, 479, 480, 482, 483, 485, 486,
			487, 488, 489, 490, 491, 492, 494, 495, 496, 497, 498, 499,
			500, 501, 502, 503, 504, 505, 506, 507, 508, 511, 512, 513,
			514, 515, 516, 517, 518, 519, 520, 524, 525, 526, 527, 528,
			529, 530, 531, 532, 533, 534, 535, 536, 539, 540, 541, 542,
			543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554,
			555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566,
			567, 568, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580,
			582, 583, 584, 585, 587, 588, 589, 591, 592, 593, 594, 599,
			600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611:
			return 1;
		default:
			return 0;
	}
	return 0;
}

stock GetPartTypeObjectList(modelid, objecttype)
{
	new partcnt;
	switch(objecttype)
	{
		case FRNT_BUMPER:
		{
			for(new i = 0; i < 2; i++)
			{
				if(CarModList[modelid-400][f_bump][i] >= 1000)
					partcnt++;
			}
		}
		case REAR_BUMPER:
		{
			for(new i = 0; i < 2; i++)
			{
				if(CarModList[modelid-400][r_bump][i] >= 1000)
					partcnt++;
			}
		}
		case ROOF:
		{
			for(new i = 0; i < 2; i++)
			{
				if(CarModList[modelid-400][roof][i] >= 1000)
					partcnt++;
			}
		}
		case HOOD:
		{
			for(new i = 0; i < 6; i++)
			{
				if(CarModList[modelid-400][hood][i] >= 1000)
					partcnt++;
			}
		}
		case SIDESKIRT:
		{
			for(new i = 0; i < 4; i++)
			{
				if(CarModList[modelid-400][l_sskirt][i] >= 1000)
					partcnt++;
			}
		}
		case SPOILER:
		{
			for(new i = 0; i < 7; i++)
			{
				if(CarModList[modelid-400][spoiler][i] >= 1000)
					partcnt++;
			}
		}
		case EXHAUST:
		{
			for(new i = 0; i < 5; i++)
			{
				if(CarModList[modelid-400][exhaust][i] >= 1000)
					partcnt++;
			}
		}
		case WHEELS:
		{
			if(!HasWheels(modelid))
				partcnt = 0;
			else
				partcnt = 17;
		}
		case PAINTJOB:
		{
			switch(modelid)
			{
				case 483:
					partcnt = 1;
				case 575:
					partcnt = 2;
				case 534, 535, 536, 558, 559, 560, 561, 562, 565, 567, 576:
				{
					partcnt = 3;
				}
				default:
					partcnt = 0;
			}
		}
		default:
			partcnt = 0;
	}
	return partcnt;
}

stock ClearCarMods(playerid)
{
	for(new i = 0; i < 16; i++)
	{
		if(i < 15)
		{
			if(i != 14)
			{
				RemoveVehicleComponent(TempModSave[playerid][15], TempModSave[playerid][i]);
				AddVehicleComponent(TempModSave[playerid][15], CurrentMods[TempModSave[playerid][15]][i]);
			}
			else
			{
			
				ChangeVehiclePaintjob(TempModSave[playerid][15], 3);
				ChangeVehiclePaintjob(TempModSave[playerid][15], CurrentMods[TempModSave[playerid][15]][i]);
			}
		}
		TempModSave[playerid][i] = -1;
		if(i == 14)
		    TempModSave[playerid][i] = -1;
	}
	CurrentModLocation[playerid] = -1;
	return 1;
}

stock BuyCarMods(playerid)
{
	for(new i = 0; i < 16; i++)
	{
		if(i < 15)
		{
		    if(TempModSave[playerid][i] != -1)
				CurrentMods[TempModSave[playerid][15]][i] = TempModSave[playerid][i];
		}
		TempModSave[playerid][i] = 0;
	}	
	CurrentModLocation[playerid] = -1;
	return 1;
}

stock DisplayModMenu(playerid)
{
	new modelid = GetVehicleModel(GetPlayerVehicleID(playerid));
	if(modelid < 400 || modelid > 611)
	    return 1;
	if(!IsModdable(modelid))
	{
		return print("You can not mod this fucking vehicle");
	}
	SendClientMessage(playerid, COLOR_CMDNOTICE, "                Use your look left & look right buttons to switch between mods. Use your enter key to select an item.");
	SetCameraBehindPlayer(playerid);
	TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
	new mod;
	modmsg = "";
	if(IsNOSable(modelid)) strins(modmsg, "Nitrous Oxide(NOS)\n", strlen(modmsg)), mod = 1;
	if(GetPartTypeObjectList(modelid, PAINTJOB)) strins(modmsg, "PaintJob\n", strlen(modmsg)), mod = 1;
	if(CarModList[modelid-400][f_bump][0] >= 1000) strins(modmsg, "Front Bumper\n", strlen(modmsg)), mod = 1;
	if(CarModList[modelid-400][r_bump][0] >= 1000) strins(modmsg, "Rear Bumper\n", strlen(modmsg)), mod = 1;
	if(CarModList[modelid-400][roof][0] >= 1000) strins(modmsg, "Roof\n", strlen(modmsg)), mod = 1;
	if(CarModList[modelid-400][hood][0] >= 1000) strins(modmsg, "Hood\n", strlen(modmsg)), mod = 1;
	if(IsHydrualics(modelid)) strins(modmsg, "Hydraulics\n", strlen(modmsg)), mod = 1;
	if(CarModList[modelid-400][l_sskirt][0] >= 1000) strins(modmsg, "SideSkirt\n", strlen(modmsg)), mod = 1;
	if(CarModList[modelid-400][spoiler][0] >= 1000) strins(modmsg, "Spoiler\n", strlen(modmsg)), mod = 1;
	if(CarModList[modelid-400][exhaust][0] >= 1000) strins(modmsg, "Exhaust\n", strlen(modmsg)), mod = 1;
	if(HasWheels(modelid) == 1) strins(modmsg, "Wheels\n", strlen(modmsg)), mod = 1;
	//printf("%i - %i - %i - %i - %i - %i - %i - %i - %i - %i", IsNOSable(modelid), GetPaintJobCount(modelid), CarModList[modelid-400][f_bump][0], CarModList[modelid-400][r_bump][0], CarModList[modelid-400][roof][0], CarModList[modelid-400][hood][0], IsHydrualics(modelid), CarModList[modelid-400][l_sskirt][0], CarModList[modelid-400][spoiler][0], CarModList[modelid-400][exhaust][0]);
	print(modmsg);
	if(!IsPlayerModding[playerid])
	{
		for(new i = 0; i < 16; i++)
		{
      		TempModSave[playerid][i] = 0;
		}
		TempModSave[playerid][14] = 3;
		CurrentModLocation[playerid] = 0;
		CurrentModObjLocation[playerid] = 0;
		TempModSave[playerid][15] = GetPlayerVehicleID(playerid);
		for(new i = 0; i < 15; i++)
		{
		    if(i != 14)
			{
				RemoveVehicleComponent(TempModSave[playerid][15], CurrentMods[TempModSave[playerid][15]][i]);
			}
			else
			{
				ChangeVehiclePaintjob(TempModSave[playerid][15], 3);
			}
        }
        SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You won't be asked to pay again for mods you had. Please re-mod fully.");
	}
	if(mod == 0)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: This vehicle is not modifiable.");
	}
	else
	{
	    for(new i = 0; i < 15; i++)
	    {
			if(i != 14)
			{
			   	if(TempModSave[playerid][i] != 0)
		        {
                    strins(modmsg, "{FF6600}Remove Part(s)", strlen(modmsg));
					break;
				}
			}
			else
			{
				if(TempModSave[playerid][i] != 3)
		        {
                    strins(modmsg, "{FF6600}Remove Part(s)", strlen(modmsg));
					break;
				}
			}
	    }
		SetCameraBehindPlayer(playerid);
		strins(modmsg, "\n{1EE2E6}Checkout", strlen(modmsg));
        IsPlayerModding[playerid] = true;
		ShowPlayerDialog(playerid, DIALOG_CARMOD1, DIALOG_STYLE_LIST, "Vehicle Modification Menu", modmsg, "Select", "Cancel");
		TogglePlayerControllable(playerid, 0);
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    print("ODR_Rak_CMList");
	if(dialogid == DIALOG_CARMOD1)
	{
	    if(!response)
	    {
	        IsPlayerModding[playerid] = false;
	        CurrentModLocation[playerid] = -1;
	        TogglePlayerControllable(playerid, 1);
			ClearCarMods(playerid);
			TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
	        return SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: You have closed the Vehicle Modification Menu");
	    }
	    else
	    {
	        new Float:angle, Float:x, Float:y, Float:z, Float:vvx, Float:vvy, Float:vvz;
			new vehid = GetPlayerVehicleID(playerid),
			    modelid = GetVehicleModel(GetPlayerVehicleID(playerid));
			if(vehid != TempModSave[playerid][CARMOD_VEHID])
			    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There has been some error in retrieving mods. Contact Developers if the problem persists");
			if(strcmp(inputtext, "Nitrous Oxide(NOS)", true) == 0)
			{
			    CurrentModLocation[playerid] = 1;
				new nos1;
				modmsg = "";
				if(GetVehicleComponentInSlot(vehid, CARMODTYPE_NITRO) != 1009)
				{
					nos1 = 1;
					strins(modmsg, "2 Cans of Nitrous Oxide", strlen(modmsg));
				}
				if(GetVehicleComponentInSlot(vehid, CARMODTYPE_NITRO) != 1008)
				{
					if(nos1 == 1)
					{
						strins(modmsg, "\n5 Cans of Nitrous Oxide", strlen(modmsg));
					}
					else
					{
						strins(modmsg, "5 Cans of Nitrous Oxide", strlen(modmsg));
						nos1 = 1;
					}
				}
				if(GetVehicleComponentInSlot(vehid, CARMODTYPE_NITRO) != 1010)
				{
					if(nos1 == 1)
					{
						strins(modmsg, "\n10 Cans of Nitrous Oxide", strlen(modmsg));
					}
					else
					{
						strins(modmsg, "10 Cans of Nitrous Oxide", strlen(modmsg));
					}
				}
				ShowPlayerDialog(playerid, DIALOG_CARMOD2, DIALOG_STYLE_LIST, "Vehicle Modification - Nitrous Oxide", modmsg, "Purchase", "Go Back");
				return 1;
			}
			else if(strcmp(inputtext, "PaintJob", true) == 0)
			{
			    CurrentModLocation[playerid] = 2;
			    if(GetPartTypeObjectList(modelid, PAINTJOB) == 0)
			    {
			        DisplayModMenu(playerid);
			    }
				CurrentModObjLocation[playerid] = 0;
				TempModSave[playerid][CARMODTYPE_PAINT] = CurrentModObjLocation[playerid];
				ChangeVehiclePaintjob(vehid, CurrentModObjLocation[playerid]);
				format(modmsg, sizeof(modmsg), "~r~<< ~w~%s-%i~r~ >>~n~$%i", ModPositionNames[CurrentModLocation[playerid]][Mod_Name], CurrentModObjLocation[playerid]+1, ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
				ModSetTextDraw(SelectionTD[playerid], modmsg);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(vehid, x, y, z);
				GetVehiclePos(vehid, vvx, vvy, vvz);
				GetVehicleZAngle(vehid, angle);
				x += (5 * floatsin(-angle, degrees));
				y += (5 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z+3);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);
			}
			else if(strcmp(inputtext, "Front Bumper", true) == 0)
			{
			    CurrentModLocation[playerid] = 3;
                if(CarModList[modelid-400][f_bump][0] < 1000)
			    {
			        DisplayModMenu(playerid);
			    }
				CurrentModObjLocation[playerid] = 0;
				AddVehicleComponent(vehid, CarModList[modelid-400][f_bump][CurrentModObjLocation[playerid]]);
				TempModSave[playerid][CARMODTYPE_FRONT_BUMPER] = CarModList[modelid-400][f_bump][CurrentModObjLocation[playerid]];
				format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][f_bump][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
				ModSetTextDraw(SelectionTD[playerid], modmsg);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(vehid, x, y, z);
				GetVehiclePos(vehid, vvx, vvy, vvz);
				GetVehicleZAngle(vehid, angle);
				x += (5 * floatsin(-angle, degrees));
				y += (5 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);
			}
			else if(strcmp(inputtext, "Rear Bumper", true) == 0)
			{
			    CurrentModLocation[playerid] = 4;
                if(CarModList[modelid-400][r_bump][0] < 1000)
			    {
			        DisplayModMenu(playerid);
			    }
				CurrentModObjLocation[playerid] = 0;
				AddVehicleComponent(vehid, CarModList[modelid-400][r_bump][CurrentModObjLocation[playerid]]);
				TempModSave[playerid][CARMODTYPE_REAR_BUMPER] = CarModList[modelid-400][r_bump][CurrentModObjLocation[playerid]];
				format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][r_bump][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
				ModSetTextDraw(SelectionTD[playerid], modmsg);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(vehid, x, y, z);
				GetVehiclePos(vehid, vvx, vvy, vvz);
				GetVehicleZAngle(vehid, angle);
				angle = angle + 180.0;
				x += (5 * floatsin(-angle, degrees));
				y += (5 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);
			}
			else if(strcmp(inputtext, "Roof", true) == 0)
			{
			    CurrentModLocation[playerid] = 5;
                if(CarModList[modelid-400][roof][0] < 1000)
			    {
			        DisplayModMenu(playerid);
			    }
				CurrentModObjLocation[playerid] = 0;
				AddVehicleComponent(vehid, CarModList[modelid-400][roof][CurrentModObjLocation[playerid]]);
				TempModSave[playerid][CARMODTYPE_ROOF] = CarModList[modelid-400][roof][CurrentModObjLocation[playerid]];
				format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][roof][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
				ModSetTextDraw(SelectionTD[playerid], modmsg);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(vehid, x, y, z);
				GetVehiclePos(vehid, vvx, vvy, vvz);
				GetVehicleZAngle(vehid, angle);
				x += (3 * floatsin(-angle, degrees));
				y += (3 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z+4);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);
			}
			else if(strcmp(inputtext, "Hood", true) == 0)
			{
			    CurrentModLocation[playerid] = 6;
                if(CarModList[modelid-400][hood][0] < 1000)
			    {
			        DisplayModMenu(playerid);
			    }
				CurrentModObjLocation[playerid] = 0;
				AddVehicleComponent(vehid, CarModList[modelid-400][hood][CurrentModObjLocation[playerid]]);
				TempModSave[playerid][CARMODTYPE_HOOD] = CarModList[modelid-400][hood][CurrentModObjLocation[playerid]];
				format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][hood][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
				ModSetTextDraw(SelectionTD[playerid], modmsg);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(vehid, x, y, z);
				GetVehiclePos(vehid, vvx, vvy, vvz);
				GetVehicleZAngle(vehid, angle);
				x += (3 * floatsin(-angle, degrees));
				y += (3 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z+3);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);
			}
			else if(strcmp(inputtext, "Hydraulics", true) == 0)
			{
			    CurrentModLocation[playerid] = 7;
			    ShowPlayerDialog(playerid, DIALOG_CARMOD3, DIALOG_STYLE_MSGBOX, "Vehicle Modification - Hydraulics", "{ffffff}Are you sure you want to Purchase Hydraulics for {FF0000}$500{ffffff}?", "Purchase", "Go Back");
				return 1;
			}
			else if(strcmp(inputtext, "SideSkirt", true) == 0)
			{
			    CurrentModLocation[playerid] = 8;
                if(CarModList[modelid-400][l_sskirt][0] < 1000)
			    {
			        DisplayModMenu(playerid);
			    }
				CurrentModObjLocation[playerid] = 0;
				AddVehicleComponent(vehid, CarModList[modelid-400][l_sskirt][CurrentModObjLocation[playerid]]);
				TempModSave[playerid][CARMODTYPE_SIDESKIRT] = CarModList[modelid-400][l_sskirt][CurrentModObjLocation[playerid]];
				format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][l_sskirt][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
				ModSetTextDraw(SelectionTD[playerid], modmsg);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(vehid, x, y, z);
				GetVehiclePos(vehid, vvx, vvy, vvz);
				GetVehicleZAngle(vehid, angle);
				angle = angle + 105.0;
				x += (5 * floatsin(-angle, degrees));
				y += (5 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);
			}
			else if(strcmp(inputtext, "Spoiler", true) == 0)
			{
                CurrentModLocation[playerid] = 9;
                if(CarModList[modelid-400][spoiler][0] < 1000)
			    {
			        DisplayModMenu(playerid);
			    }
				CurrentModObjLocation[playerid] = 0;
				AddVehicleComponent(vehid, CarModList[modelid-400][spoiler][CurrentModObjLocation[playerid]]);
				TempModSave[playerid][CARMODTYPE_SPOILER] = CarModList[modelid-400][spoiler][CurrentModObjLocation[playerid]];
				format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][spoiler][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
				ModSetTextDraw(SelectionTD[playerid], modmsg);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(vehid, x, y, z);
				GetVehiclePos(vehid, vvx, vvy, vvz);
				GetVehicleZAngle(vehid, angle);
				angle = angle + 165.0;
				x += (5 * floatsin(-angle, degrees));
				y += (5 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z+3);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);
			}
			else if(strcmp(inputtext, "Exhaust", true) == 0)
			{
                CurrentModLocation[playerid] = 10;
                if(CarModList[modelid-400][exhaust][0] < 1000)
			    {
			        DisplayModMenu(playerid);
			    }
				CurrentModObjLocation[playerid] = 0;
				AddVehicleComponent(vehid, CarModList[modelid-400][exhaust][CurrentModObjLocation[playerid]]);
				TempModSave[playerid][CARMODTYPE_EXHAUST] = CarModList[modelid-400][exhaust][CurrentModObjLocation[playerid]];
				format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][exhaust][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
				ModSetTextDraw(SelectionTD[playerid], modmsg);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(vehid, x, y, z);
				GetVehiclePos(vehid, vvx, vvy, vvz);
				GetVehicleZAngle(vehid, angle);
				angle = angle + 180.0;
				x += (5 * floatsin(-angle, degrees));
				y += (5 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);
			}
			else if(strcmp(inputtext, "Wheels", true) == 0)
			{
                CurrentModLocation[playerid] = 11;
                if(!HasWheels(modelid))
			    {
			        DisplayModMenu(playerid);
			    }
				CurrentModObjLocation[playerid] = 0;
				AddVehicleComponent(vehid, WheelComponents[CurrentModObjLocation[playerid]]);
				TempModSave[playerid][CARMODTYPE_WHEELS] = WheelComponents[CurrentModObjLocation[playerid]];
				format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[WheelComponents[CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
				ModSetTextDraw(SelectionTD[playerid], modmsg);
				TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				GetVehiclePos(vehid, x, y, z);
				GetVehiclePos(vehid, vvx, vvy, vvz);
				GetVehicleZAngle(vehid, angle);
				angle = angle + 105.0;
				x += (5 * floatsin(-angle, degrees));
				y += (5 * floatcos(-angle, degrees));
				SetPlayerCameraPos(playerid, x, y, z);
				SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);
			}
			else if(strcmp(inputtext, "Remove Part(s)", true) == 0)
			{
			    CurrentModLocation[playerid] = 12;
			    ShowPlayerDialog(playerid, DIALOG_CARMOD4, DIALOG_STYLE_MSGBOX, "Vehicle Modification - Remove Mods", "Are you sure you want to Remove all mods?", "Go Ahead", "Go Back");
			}
			else if(strcmp(inputtext, "Checkout", true) == 0)
			{
			    modmsg = "";
			    new totprice;
				for(new i = 1; i < 12; i++)
				{
					if(ModPositionNames[i][Mod_Slot] != CARMODTYPE_PAINT)
					{	
						if(TempModSave[playerid][ModPositionNames[i][Mod_Slot]] >= 1000 && (CurrentMods[TempModSave[playerid][15]][ModPositionNames[i][Mod_Slot]] < 1000 || CurrentMods[TempModSave[playerid][15]][ModPositionNames[i][Mod_Slot]] != TempModSave[playerid][ModPositionNames[i][Mod_Slot]]))
						{
							totprice += ModPositionNames[i][Mod_Price];
						}
					}
					else
					{
						if(TempModSave[playerid][ModPositionNames[i][Mod_Slot]] != 3 && (CurrentMods[TempModSave[playerid][15]][ModPositionNames[i][Mod_Slot]] == 3 || CurrentMods[TempModSave[playerid][15]][ModPositionNames[i][Mod_Slot]] != TempModSave[playerid][ModPositionNames[i][Mod_Slot]]))
						{
							totprice += ModPositionNames[i][Mod_Price];
						}						
					}
				}
				if(totprice == 0)
				{
					new removeparts;
					for(new i = 1; i < 12; i++)
					{
						if(ModPositionNames[i][Mod_Slot] != CARMODTYPE_PAINT)
						{
							if(CurrentMods[TempModSave[playerid][15]][ModPositionNames[i][Mod_Slot]] >= 1000)
							{
								removeparts++;
							}
						}
						else
						{
							if(CurrentMods[TempModSave[playerid][15]][ModPositionNames[i][Mod_Slot]] != 3)
							{
								removeparts++;
							}
						}
					}
					if(removeparts == 0)
					{
						DisplayModMenu(playerid);
					}
					else
					{
					    BuyCarMods(playerid);
						SetCameraBehindPlayer(playerid);
						TogglePlayerControllable(playerid, 1);
						IsPlayerModding[playerid] = false;
						CurrentModLocation[playerid] = -1;
						return SendClientMessage(playerid, COLOR_NOTICE, "[NOTICE]: Mods have been successfully removed/changed.");
					}
				}
				else
				{
					if(GetPlayerMoney(playerid) < totprice)
					{
						return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: You do not have enough cash to check-out. Kill more Playa'.");
					}
					else
					{
						format(modmsg, sizeof(modmsg), "Are you sure you want to mod your car for $%i.", totprice);
						ShowPlayerDialog(playerid, DIALOG_BUYCARMOD, DIALOG_STYLE_MSGBOX, "Buy Car Mods?", modmsg, "Yes", "No");
						CurrentModCost[playerid] = totprice;
						//TransferMods(playerid, vehid);
					}
				}
			}
			
	    }
	}
	if(dialogid == DIALOG_BUYCARMOD)
	{
	    if(!response)
	    {
	        CurrentModLocation[playerid] = 0;
            return DisplayModMenu(playerid);
	    }
	    else
	    {
	        new totprice = CurrentModCost[playerid];
			GivePlayerMoney(playerid, -1 * totprice);
			BuyCarMods(playerid);
			format(modmsg, sizeof(modmsg), "[NOTICE]: You have successfully modded your car for $%i. You can save the mods by using /buycarmod command", totprice);
			SendClientMessage(playerid, COLOR_NOTICE, modmsg);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 1);
			IsPlayerModding[playerid] = false;
			CurrentModLocation[playerid] = -1;
	    }
	}
	if(dialogid == DIALOG_CARMOD2)
	{
	    if(!response)
	    {
	        CurrentModLocation[playerid] = 0;
            return DisplayModMenu(playerid);
		}
		else
		{
			new vehid = GetPlayerVehicleID(playerid),
			    modelid = GetVehicleModel(GetPlayerVehicleID(playerid));
			if(vehid != TempModSave[playerid][CARMOD_VEHID])
			    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There has been some error in retrieving mods. Contact Developers if the problem persists");
		    if(IsNOSable(modelid))
		    {
                if(strcmp(inputtext, "2 Cans of Nitrous Oxide", true) == 0)
                {
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1009);
                    TempModSave[playerid][CARMODTYPE_NITRO] = 1009;
                }
                else if(strcmp(inputtext, "5 Cans of Nitrous Oxide", true) == 0)
                {
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1008);
                    TempModSave[playerid][CARMODTYPE_NITRO] = 1008;
                }
                else if(strcmp(inputtext, "10 Cans of Nitrous Oxide", true) == 0)
                {
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
                    TempModSave[playerid][CARMODTYPE_NITRO] = 1010;
                }
                return DisplayModMenu(playerid);
		    }
		    else
		    	return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There has been some error in adding NOS. Contact Developers if the problem persists.");
		}
	    
	}
	if(dialogid == DIALOG_CARMOD3)
	{
	    if(!response)
	    {
	        CurrentModLocation[playerid] = 0;
            return DisplayModMenu(playerid);
		}
		else
		{
			new vehid = GetPlayerVehicleID(playerid),
			    modelid = GetVehicleModel(GetPlayerVehicleID(playerid));
			if(vehid != TempModSave[playerid][CARMOD_VEHID])
			    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There has been some error in retrieving mods. Contact Developers if the problem persists");
		    if(IsHydrualics(modelid))
		    {
		        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);
		        TempModSave[playerid][CARMODTYPE_HYDRAULICS] = 1087;
		        DisplayModMenu(playerid);
		    }
		    else
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR]: There has been some error in adding HYDRAULICS. Contact Developers if the problem persists.");
		}
		return 1;
	}
	if(dialogid == DIALOG_CARMOD4)
	{
		if(!response)
	    {
	        CurrentModLocation[playerid] = 0;
            return DisplayModMenu(playerid);
		}
		else
		{
			ClearCarMods(playerid);
			DisplayModMenu(playerid);
		}
	}
	return 0;
}

hook OnGameModeInit()
{
	new carid;
	new File:Mods = fopen("Vehicle_ModList.txt", io_readwrite);
	new buf[512];
	if(Mods)
	{
		print("Getting the Enum-Details from Vehicle_ModList.txt for car_mod_list.pwn, part of /mod command");
		while(fread(Mods, buf))
		{
  			if(sscanf(buf, "e<iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii>", CarModList[carid]))
  			{
  			    printf("Error Loading Mod Details of Veh: %i", carid+400);
  			}
  			//printf("%i - %i - %i - %i - %i - %i - %i", CarModList[carid][f_bump][0], CarModList[carid][r_bump][0], CarModList[carid][roof][0], CarModList[carid][hood][0], CarModList[carid][l_sskirt][0], CarModList[carid][spoiler][0], CarModList[carid][exhaust][0]);
  			carid++;
		}
	}
	fclose(Mods);
	for(new j = 0; j < MAX_PLAYERS; j++)
	{
		for(new i = 0; i < 16; i++)
		{
			TempModSave[j][i] = 0;
			if(i == 14)
			    TempModSave[j][i] = 3;
		}
		CurrentModLocation[j] = -1;
		CreateModText(j);
	}
	for(new j = 0; j < MAX_VEHICLES; j++)
	{
		for(new i = 0; i < 15; i++)
		{
			CurrentMods[j][i] = 0;
			if(i == 14)
			    CurrentMods[j][i] = 3;
		}
	}
	return 1;
}

CMD:mod(playerid, params[])
{
	if(ModRequirements(playerid))
	{
	    DisplayModMenu(playerid);
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(CurrentModLocation[playerid] > 0)
	{
		new vehid = GetPlayerVehicleID(playerid),
						modelid = GetVehicleModel(vehid);
		if(vehid != TempModSave[playerid][CARMOD_VEHID])
			return DisplayModMenu(playerid);
		switch(oldkeys)
		{
			case KEY_LOOK_LEFT: //Look Left //Backward
			{
				switch(CurrentModLocation[playerid])
				{
					case 2:
					{
						new Total_Types = GetPartTypeObjectList(modelid, PAINTJOB);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == 0)
								CurrentModObjLocation[playerid] = Total_Types - 1;
							else
								CurrentModObjLocation[playerid]--;		
						}
						TempModSave[playerid][CARMODTYPE_PAINT] = CurrentModObjLocation[playerid];
						ChangeVehiclePaintjob(vehid, CurrentModObjLocation[playerid]);
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s-%i~r~ >>~n~$%i", ModPositionNames[CurrentModLocation[playerid]][Mod_Name], CurrentModObjLocation[playerid]+1, ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 3:
					{
						new Total_Types = GetPartTypeObjectList(modelid, FRNT_BUMPER);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == 0)
								CurrentModObjLocation[playerid] = Total_Types - 1;
							else
								CurrentModObjLocation[playerid]--;		
						}
						AddVehicleComponent(vehid, CarModList[modelid-400][f_bump][CurrentModObjLocation[playerid]]);
						TempModSave[playerid][CARMODTYPE_FRONT_BUMPER] = CarModList[modelid-400][f_bump][CurrentModObjLocation[playerid]];
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][f_bump][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 4:
					{
						new Total_Types = GetPartTypeObjectList(modelid, REAR_BUMPER);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == 0)
								CurrentModObjLocation[playerid] = Total_Types - 1;
							else
								CurrentModObjLocation[playerid]--;		
						}
						AddVehicleComponent(vehid, CarModList[modelid-400][r_bump][CurrentModObjLocation[playerid]]);
						TempModSave[playerid][CARMODTYPE_REAR_BUMPER] = CarModList[modelid-400][r_bump][CurrentModObjLocation[playerid]];
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][r_bump][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				
					}
					case 5:
					{
						new Total_Types = GetPartTypeObjectList(modelid, ROOF);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == 0)
								CurrentModObjLocation[playerid] = Total_Types - 1;
							else
								CurrentModObjLocation[playerid]--;		
						}
						AddVehicleComponent(vehid, CarModList[modelid-400][roof][CurrentModObjLocation[playerid]]);
						TempModSave[playerid][CARMODTYPE_ROOF] = CarModList[modelid-400][roof][CurrentModObjLocation[playerid]];
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][roof][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				
					}
					case 6:
					{
						new Total_Types = GetPartTypeObjectList(modelid, HOOD);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == 0)
								CurrentModObjLocation[playerid] = Total_Types - 1;
							else
								CurrentModObjLocation[playerid]--;		
						}
						CurrentModObjLocation[playerid] = 0;
						AddVehicleComponent(vehid, CarModList[modelid-400][hood][CurrentModObjLocation[playerid]]);
						TempModSave[playerid][CARMODTYPE_HOOD] = CarModList[modelid-400][hood][CurrentModObjLocation[playerid]];
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][hood][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				
					}
					case 8:
					{
						new Total_Types = GetPartTypeObjectList(modelid, SIDESKIRT);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == 0)
								CurrentModObjLocation[playerid] = Total_Types - 1;
							else
								CurrentModObjLocation[playerid]--;		
						}
						AddVehicleComponent(vehid, CarModList[modelid-400][l_sskirt][CurrentModObjLocation[playerid]]);
						TempModSave[playerid][CARMODTYPE_SIDESKIRT] = CarModList[modelid-400][l_sskirt][CurrentModObjLocation[playerid]];
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][l_sskirt][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				
					}
					case 9:
					{
						new Total_Types = GetPartTypeObjectList(modelid, SPOILER);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == 0)
								CurrentModObjLocation[playerid] = Total_Types - 1;
							else
								CurrentModObjLocation[playerid]--;		
						}
						AddVehicleComponent(vehid, CarModList[modelid-400][spoiler][CurrentModObjLocation[playerid]]);
						TempModSave[playerid][CARMODTYPE_SPOILER] = CarModList[modelid-400][spoiler][CurrentModObjLocation[playerid]];
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][spoiler][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 10:
					{
						new Total_Types = GetPartTypeObjectList(modelid, EXHAUST);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == 0)
								CurrentModObjLocation[playerid] = Total_Types - 1;
							else
								CurrentModObjLocation[playerid]--;		
						}
						AddVehicleComponent(vehid, CarModList[modelid-400][exhaust][CurrentModObjLocation[playerid]]);
						TempModSave[playerid][CARMODTYPE_EXHAUST] = CarModList[modelid-400][exhaust][CurrentModObjLocation[playerid]];
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][exhaust][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 11:
					{
						new Total_Types = GetPartTypeObjectList(modelid, WHEELS);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == 0)
								CurrentModObjLocation[playerid] = Total_Types - 1;
							else
								CurrentModObjLocation[playerid]--;		
						}
						AddVehicleComponent(vehid, WheelComponents[CurrentModObjLocation[playerid]]);
						TempModSave[playerid][CARMODTYPE_WHEELS] = WheelComponents[CurrentModObjLocation[playerid]];
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[WheelComponents[CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					default:
						DisplayModMenu(playerid);
						
				}
			}
			case KEY_LOOK_RIGHT://look right //Forward
			{
				switch(CurrentModLocation[playerid])
				{
					case 2:
					{
						new Total_Types = GetPartTypeObjectList(modelid, PAINTJOB);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == Total_Types - 1)
								CurrentModObjLocation[playerid] = 0;
							else
								CurrentModObjLocation[playerid]++;		
						}
						TempModSave[playerid][CARMODTYPE_PAINT] = CurrentModObjLocation[playerid];
						ChangeVehiclePaintjob(vehid, CurrentModObjLocation[playerid]);
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s-%i~r~ >>~n~$%i", ModPositionNames[CurrentModLocation[playerid]][Mod_Name], CurrentModObjLocation[playerid]+1, ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 3:
					{
						new Total_Types = GetPartTypeObjectList(modelid, FRNT_BUMPER);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == Total_Types - 1)
								CurrentModObjLocation[playerid] = 0;
							else
								CurrentModObjLocation[playerid]++;		
						}
						AddVehicleComponent(vehid, CarModList[modelid-400][f_bump][CurrentModObjLocation[playerid]]);
						TempModSave[playerid][CARMODTYPE_FRONT_BUMPER] = CarModList[modelid-400][f_bump][CurrentModObjLocation[playerid]];
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][f_bump][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 4:
					{
						new Total_Types = GetPartTypeObjectList(modelid, REAR_BUMPER);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == Total_Types - 1)
								CurrentModObjLocation[playerid] = 0;
							else
								CurrentModObjLocation[playerid]++;		
						}
						AddVehicleComponent(vehid, CarModList[modelid-400][r_bump][CurrentModObjLocation[playerid]]);
						TempModSave[playerid][CARMODTYPE_REAR_BUMPER] = CarModList[modelid-400][r_bump][CurrentModObjLocation[playerid]];
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][r_bump][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				
					}
					case 5:
					{
						new Total_Types = GetPartTypeObjectList(modelid, ROOF);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == Total_Types - 1)
								CurrentModObjLocation[playerid] = 0;
							else
								CurrentModObjLocation[playerid]++;		
						}
						AddVehicleComponent(vehid, CarModList[modelid-400][roof][CurrentModObjLocation[playerid]]);
						TempModSave[playerid][CARMODTYPE_ROOF] = CarModList[modelid-400][roof][CurrentModObjLocation[playerid]];
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][roof][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				
					}
					case 6:
					{
						new Total_Types = GetPartTypeObjectList(modelid, HOOD);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == Total_Types - 1)
								CurrentModObjLocation[playerid] = 0;
							else
								CurrentModObjLocation[playerid]++;		
						}
						CurrentModObjLocation[playerid] = 0;
						AddVehicleComponent(vehid, CarModList[modelid-400][hood][CurrentModObjLocation[playerid]]);
						TempModSave[playerid][CARMODTYPE_HOOD] = CarModList[modelid-400][hood][CurrentModObjLocation[playerid]];
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][hood][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				
					}
					case 8:
					{
						new Total_Types = GetPartTypeObjectList(modelid, SIDESKIRT);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == Total_Types - 1)
								CurrentModObjLocation[playerid] = 0;
							else
								CurrentModObjLocation[playerid]++;		
						}
						AddVehicleComponent(vehid, CarModList[modelid-400][l_sskirt][CurrentModObjLocation[playerid]]);
						TempModSave[playerid][CARMODTYPE_SIDESKIRT] = CarModList[modelid-400][l_sskirt][CurrentModObjLocation[playerid]];
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][l_sskirt][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
				
					}
					case 9:
					{
						new Total_Types = GetPartTypeObjectList(modelid, SPOILER);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == Total_Types - 1)
								CurrentModObjLocation[playerid] = 0;
							else
								CurrentModObjLocation[playerid]++;		
						}
						AddVehicleComponent(vehid, CarModList[modelid-400][spoiler][CurrentModObjLocation[playerid]]);
						TempModSave[playerid][CARMODTYPE_SPOILER] = CarModList[modelid-400][spoiler][CurrentModObjLocation[playerid]];
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][spoiler][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 10:
					{
						new Total_Types = GetPartTypeObjectList(modelid, EXHAUST);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == Total_Types - 1)
								CurrentModObjLocation[playerid] = 0;
							else
								CurrentModObjLocation[playerid]++;		
						}
						AddVehicleComponent(vehid, CarModList[modelid-400][exhaust][CurrentModObjLocation[playerid]]);
						TempModSave[playerid][CARMODTYPE_EXHAUST] = CarModList[modelid-400][exhaust][CurrentModObjLocation[playerid]];
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[CarModList[modelid-400][exhaust][CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					case 11:
					{
						new Total_Types = GetPartTypeObjectList(modelid, WHEELS);
						if(Total_Types == 0)
						{
							CurrentModObjLocation[playerid] = -1;
							DisplayModMenu(playerid);
						}
						else if(Total_Types == 1)
							GameTextForPlayer(playerid, "~g~Only one mod available for this vehicle.", 1000, 4);
						else
						{
							if(CurrentModObjLocation[playerid] == Total_Types - 1)
								CurrentModObjLocation[playerid] = 0;
							else
								CurrentModObjLocation[playerid]++;		
						}
						AddVehicleComponent(vehid, WheelComponents[CurrentModObjLocation[playerid]]);
						TempModSave[playerid][CARMODTYPE_WHEELS] = WheelComponents[CurrentModObjLocation[playerid]];
						format(modmsg, sizeof(modmsg), "~r~<< ~w~%s~r~ >>~n~$%i", ModInfoArray[WheelComponents[CurrentModObjLocation[playerid]] - 1000][Comp_Name], ModPositionNames[CurrentModLocation[playerid]][Mod_Price]);
						ModSetTextDraw(SelectionTD[playerid], modmsg);
						TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
					}
					default:
						DisplayModMenu(playerid);
						
				}	
			}
			case KEY_SECONDARY_ATTACK: //enter key
			{
				DisplayModMenu(playerid);
				TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
			}
			case KEY_JUMP://JUMP_KEY
			{
			    //return to mod menu
				switch(CurrentModLocation[playerid])
				{
					case 2:
					{
						TempModSave[playerid][CARMODTYPE_PAINT]=-1;
						AddVehicleComponent(vehid, CurrentMods[vehid][CARMODTYPE_PAINT]);
					}
					case 3:
					{
						TempModSave[playerid][CARMODTYPE_FRONT_BUMPER]=-1;
						AddVehicleComponent(vehid, CurrentMods[vehid][CARMODTYPE_FRONT_BUMPER]);
					}
					case 4:
					{
						TempModSave[playerid][CARMODTYPE_REAR_BUMPER]=-1;
						AddVehicleComponent(vehid, CurrentMods[vehid][CARMODTYPE_REAR_BUMPER]);
					}
					case 5:
					{
						TempModSave[playerid][CARMODTYPE_ROOF]=-1;
						AddVehicleComponent(vehid, CurrentMods[vehid][CARMODTYPE_ROOF]);
					}
					case 6:
					{
						TempModSave[playerid][CARMODTYPE_HOOD]=-1;
						AddVehicleComponent(vehid, CurrentMods[vehid][CARMODTYPE_HOOD]);
					}
					case 8:
					{
						TempModSave[playerid][CARMODTYPE_SIDESKIRT]=-1;
						AddVehicleComponent(vehid, CurrentMods[vehid][CARMODTYPE_SIDESKIRT]);
					}
					case 9:
					{
						TempModSave[playerid][CARMODTYPE_SPOILER]=-1;
						AddVehicleComponent(vehid, CurrentMods[vehid][CARMODTYPE_SPOILER]);
					}
					case 10:
					{
						TempModSave[playerid][CARMODTYPE_EXHAUST]=-1;
						AddVehicleComponent(vehid, CurrentMods[vehid][CARMODTYPE_EXHAUST]);
					}
					case 11:
					{
						TempModSave[playerid][CARMODTYPE_WHEELS]=-1;
						AddVehicleComponent(vehid, CurrentMods[vehid][CARMODTYPE_WHEELS]);
					}
				}
				DisplayModMenu(playerid);
				TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
			}
		}
	}
	return 1;
}
