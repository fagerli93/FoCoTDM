{"Elegy",	0 ,	0 ,	1172 ,	1171 ,	1148 ,	1149 ,	1041 ,	1036 ,	0 ,	0 ,	1035,	1038 ,	1146 ,	1147 ,	1037 ,	1034 },


GetPaintJobCount(vehid)
{
	switch(vehid)
	{
		case 483:
			return 1;
		case 575:
			return 2;
		case 534, 535, 536, 558, 559, 560, 561, 562, 565, 567, 576:
			return 3;
		default:
			return 0;
	}
	return 0;
}


public ShowModMenu(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid)) return 0;
	new vehmod = 0, moddialogstring[128], mod1 = 0;
	if(IsVehicleValidWheels(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Name])){vehmod = 1;}
	if(IsVehicleValidHydraulics(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Name])){vehmod = 1;}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights1] != 0){vehmod = 1;}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper1] != 0){vehmod = 1;}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper1] != 0){vehmod = 1;}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts1] != 0){vehmod = 1;}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood1] != 0){vehmod = 1;}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop1] != 0){vehmod = 1;}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler1] != 0){vehmod = 1;}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust1] != 0){vehmod = 1;}
	if(GetPaintJobCount(GetVehicleModel(GetPlayerVehicleID(playerid))) != 0) {vehmod = 1;}
	if(vehmod == 0) return 0;
	
	if(IsVehicleValidWheels(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Name]))
	{//Show wheel sub menu on list
		strins(moddialogstring, "Wheels", strlen(moddialogstring));
		mod1 = 1;
	}
	if(IsVehicleValidNOS(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Name]))
	{//Show wheel sub menu on list
		strins(moddialogstring, "\nNitrous Oxide", strlen(moddialogstring));
		mod1 = 1;
	}
	if(IsVehicleValidHydraulics(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Name]))
	{
		if(mod1 == 1){strins(moddialogstring, "\nHydraulics", strlen(moddialogstring));}else strins(moddialogstring, "Hydraulics", strlen(moddialogstring));
		mod1 = 1;
	}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Lights1] != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\nLights", strlen(moddialogstring));}else strins(moddialogstring, "Lights", strlen(moddialogstring));
		mod1 = 1;
	}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][FBumper1] != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\nFront Bumper", strlen(moddialogstring));}else strins(moddialogstring, "Front Bumper", strlen(moddialogstring));
		mod1 = 1;
	}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RBumper1] != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\nRear Bumper", strlen(moddialogstring));}else strins(moddialogstring, "Rear Bumper", strlen(moddialogstring));
		mod1 = 1;
	}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][SideSkirts1] != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\nSide Skirts", strlen(moddialogstring));}else strins(moddialogstring, "Side Skirts", strlen(moddialogstring));
		mod1 = 1;
	}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Hood1] != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\nHood", strlen(moddialogstring));}else strins(moddialogstring, "Hood", strlen(moddialogstring));
		mod1 = 1;
	}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][RoofScoop1] != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\nRoof Scoop", strlen(moddialogstring));}else strins(moddialogstring, "Roof Scoop", strlen(moddialogstring));
		mod1 = 1;
	}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Spoiler1] != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\nSpoiler", strlen(moddialogstring));}else strins(moddialogstring, "Spoiler", strlen(moddialogstring));
		mod1 = 1;
	}
	if(VehNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400][Exhaust1] != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\nExhaust", strlen(moddialogstring));}else strins(moddialogstring, "Exhaust", strlen(moddialogstring));
		mod1 = 1;
	}
	if(GetPaintJobCount(GetVehicleModel(GetPlayerVehicleID(playerid))) != 0)
	{
		if(mod1 == 1){strins(moddialogstring, "\PaintJob", strlen(moddialogstring));}else strins(moddialogstring, "Exhaust", strlen(moddialogstring));
		mod1 = 1;
	}
	if(IsVehicleModified(GetPlayerVehicleID(playerid)))
	{
		strins(moddialogstring, "\n{E31919}Empty Cart", strlen(moddialogstring));
	}
	if(mod1 == 1)
	{
		SetCameraBehindPlayer(playerid);
		strins(moddialogstring, "\n{1EE2E6}Checkout", strlen(moddialogstring));
		ShowPlayerDialog(playerid, DIALOG_CARMOD1, DIALOG_STYLE_LIST, "Vehicle Modification Menu", moddialogstring, "Select", "Cancel");
		TogglePlayerControllable(playerid, 0);
		return 1;
	}
	return 0;
}

//Callbacks.pwn OnPlayerDialogResponse DIALOG_CARMOD1
else if(strcmp(inputtext, "PaintJob", true) == 0)
{
	ModdingCar[playerid] = 12;
	ModPosition[playerid] = 0;
	ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 0);
	format(string, 128, "~r~<< ~w~PaintJob-%i~r~ >>~n~$500", ModPosition[playerid]+1);
	TextDrawSetString(SelectionTD[playerid], string);
	TextDrawShowForPlayer(playerid, SelectionTD[playerid]);
	GetVehiclePos(playveh, x, y, z);
	GetVehiclePos(playveh, vvx, vvy, vvz);
	GetVehicleZAngle(playveh, angle);
	x += (3 * floatsin(-angle, degrees));
	y += (3 * floatcos(-angle, degrees));
	SetPlayerCameraPos(playerid, x, y, z+3);
	SetPlayerCameraLookAt(playerid, vvx, vvy, vvz);
}


//Callback.pwn OnPlayerKeyStateChange
	if(ModdingCar[playerid] != 0)
	{
		new string[128];
		switch(oldkeys)
		{
			case 256:
			{
				//last mod
				switch(ModdingCar[playerid])
				{
					case 12:
					{
						new Total_PJs = GetPaintJobCount(GetVehicleModel(GetPlayerVehicleID(playerid)));
						switch(Total_PJs)
						{
							case 0:
							{
								GameTextForPlayer(playerid, "~r~Error rendering painjob....", 1000, 4);
								ShowModMenu(playerid);
								TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
							}
							case 1:
							{
								GameTextForPlayer(playerid, "~g~Only one paintjob available for this vehicle.", 1000, 4);
							}
							case 2:
							{
								(ModPosition[playerid] == 1) ? ((ModPosition[playerid]--) : (ModPosition[playerid] = 1));
							}
							case 3:
							{
								(ModPosition[playerid] == 2) ? (ModPosition[playerid]--) : ( (ModPosition[playerid] == 1) ? (ModPosition[playerid]--) : (ModPosition[playerid] = 2) );
							}
						}
						ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), ModPosition[playerid]);
						format(string, 128, "~r~<< ~w~PaintJob-%i~r~ >>~n~$500", ModPosition[playerid]+1);
						TextDrawSetString(SelectionTD[playerid], string);											
					}
				}
			}
			case 64://look right
			{
				//Next mod
				switch(ModdingCar[playerid])
				{
					case 12:
					{
						new Total_PJs = GetPaintJobCount(GetVehicleModel(GetPlayerVehicleID(playerid)));
						switch(Total_PJs)
						{
							case 0:
							{
								GameTextForPlayer(playerid, "~r~Error rendering painjob....", 1000, 4);
								ShowModMenu(playerid);
								TextDrawHideForPlayer(playerid, SelectionTD[playerid]);
							}
							case 1:
							{
								GameTextForPlayer(playerid, "~g~Only one paintjob available for this vehicle.", 1000, 4);
							}
							case 2:
							{
								(ModPosition[playerid] == 0) ? ((ModPosition[playerid]++) : (ModPosition[playerid] = 0));
							}
							case 3:
							{
								(ModPosition[playerid] == 0) ? (ModPosition[playerid]++) : ( (ModPosition[playerid] == 1) ? (ModPosition[playerid]++) : (ModPosition[playerid] = 0) );
							}
						}
						ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), ModPosition[playerid]);
						format(string, 128, "~r~<< ~w~PaintJob-%i~r~ >>~n~$500", ModPosition[playerid]+1);
						TextDrawSetString(SelectionTD[playerid], string);				
					}
				}
			

