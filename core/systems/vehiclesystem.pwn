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
* Filename:  vehiclesystem.pwn                                                   *
* Author:    Marcel                                                              *
*********************************************************************************/

forward LoadDynamicCars();
public LoadDynamicCars()
{
 	mysql_store_result();
    new veh[29][60];
	new results[156];
	new string[10];
	new name[25];
	new vehid;
	while(mysql_fetch_row(results))
	{
		split(results, veh, '|');
  		vehid = CreateVehicle(strval(veh[1]), floatstr(veh[2]), floatstr(veh[3]), floatstr(veh[4]), floatstr(veh[5]), strval(veh[6]), strval(veh[7]), 60);
  		FoCo_Vehicles[vehid][cid] = strval(veh[0]);
		FoCo_Vehicles[vehid][cmodel] = strval(veh[1]);
		FoCo_Vehicles[vehid][cx] = floatstr(veh[2]);
		FoCo_Vehicles[vehid][cy] = floatstr(veh[3]);
		FoCo_Vehicles[vehid][cz] = floatstr(veh[4]);
		FoCo_Vehicles[vehid][cangle] = floatstr(veh[5]);
		SetVehicleZAngle(vehid, floatstr(veh[5]));
		FoCo_Vehicles[vehid][ccol1] = strval(veh[6]);
		FoCo_Vehicles[vehid][ccol2] = strval(veh[7]);

		format(string, sizeof(string), "%s", veh[8]);
		strmid(FoCo_Vehicles[vehid][cplate], string, 0, sizeof(string), 128);

		format(name, sizeof(name), "%s", veh[9]);
		strmid(FoCo_Vehicles[vehid][coname], name, 0, sizeof(name), 128);

		FoCo_Vehicles[vehid][coid] = strval(veh[10]);
		FoCo_Vehicles[vehid][cvw] = strval(veh[12]);
		FoCo_Vehicles[vehid][cint] = strval(veh[13]);

		FoCo_Vehicles[vehid][special_mod] = strval(veh[11]);
		if(FoCo_Vehicles[vehid][special_mod] > 0)
		{
			special_mods_add(vehid);
		}
		new sqmsg[128];
		for(new i = 14, j = 0; j < 15; i++, j++)
		{
		    VehicleModDetails[vehid][j] = strval(veh[i]);
		    format(sqmsg, sizeof(sqmsg), "%s %i -",	sqmsg, VehicleModDetails[vehid][j]);
		}
		FoCo_Vehicles[vehid][v_type] = VEHICLE_TYPE_PUBLIC;
		LinkVehicleToInterior(vehid, FoCo_Vehicles[vehid][cint]);
		SetVehicleVirtualWorld(vehid, FoCo_Vehicles[vehid][cvw]);
		SetVehicleToRespawn(vehid);
        printf("[STATIC Vehicle]: Vehicle ID: %d, Model: %d, Col1: %d, Col2: %d, Mods: %s", vehid, FoCo_Vehicles[vehid][cmodel], FoCo_Vehicles[vehid][ccol1], FoCo_Vehicles[vehid][ccol2], sqmsg);
	}
	mysql_free_result();
    return 1;
}
