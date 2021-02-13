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
* Filename: vista_gotomark.pwn                                                   *
* Author: dr_vista                                                               *
*********************************************************************************/


/********************************************************************************
	OVERVIEW: Mark System


	- Maxium of 10 marks
	- Using text to define a mark (e.g: /mark LSPD)
	- Marks can be reset at any time

	Last changes:
	-Will tp your car too if you're in a car


********************************************************************************/
#include <YSI\y_hooks>
/* Defines */

#define MAX_MARKS 10

/* Variables */

enum E_Mark_System /* Mark system enumeration */
{
	MS_TEXT[16],
	Float:MS_X,
	Float:MS_Y,
	Float:MS_Z,
	MS_INT,
	MS_WORLD
};

new Mark[MAX_PLAYERS][MAX_MARKS][E_Mark_System]; /* Main three-dimensional array */

/* Functions & Callbacks */

hook OnPlayerConnect(playerid)
{
	for(new i; i < MAX_MARKS; i++)
	{
	    Mark[playerid][i][MS_TEXT] = -1;
	    Mark[playerid][i][MS_X] = 0.0;
	    Mark[playerid][i][MS_Y] = 0.0;
	    Mark[playerid][i][MS_Z] = 0.0;
	}
	return 1;
}


/* Commands */

CMD:mark(playerid, params[]) /* /mark command */
{
	if (FoCo_Player[playerid][admin] < 1) /* Admin check */
	{
		SendClientMessage(playerid , COLOR_WARNING , "[ERROR]:  You are not authorized to use this command." );
		return 1;
	}

	new buffer, string[128], comment[16];
	if (sscanf(params, "iS[16] ", buffer, comment)) /* i: integer ; S : optional string */
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /mark [0-9] [Optional: Comment]");
	}

	if(buffer < 10) /* checks if [ID] in /mark [ID] is < 10 */
	{
        if(!strlen(comment)) /* If there was no comment assosciated with the mark */
	    {
	        new Float:Px, Float:Py, Float:Pz;
			GetPlayerPos(playerid, Px, Py, Pz); /* Get player position */
			Mark[playerid][buffer][MS_X] = Px; /* Set Mark variable positions */
			Mark[playerid][buffer][MS_Y] = Py;
		    Mark[playerid][buffer][MS_Z] = Pz;
		    Mark[playerid][buffer][MS_INT] = GetPlayerInterior(playerid);
		    Mark[playerid][buffer][MS_WORLD] = GetPlayerVirtualWorld(playerid);
		    format(string, sizeof(string),"[INFO:] Your position was successfully saved into Mark ID: (%d).", buffer);
		    
		    return SendClientMessage(playerid, COLOR_NOTICE, string);
		}

		else if(strlen(comment) > 16)
		{
		    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] The comment can only be as long as 15 characters.");
		}

		else /* If a comment was associated with the mark */
		{
		    for(new i; i < MAX_MARKS; i++) /* Loop through all mark IDs and check if a different ID than the one entered is already associated with the same comment */
		    {
		        if(strcmp(Mark[playerid][i][MS_TEXT], comment, true) == 0)
		        {
		            if(buffer != i)
					{
					    format(string, sizeof(string), "[ERROR:] Mark ID: (%d) is already assigned to comment (%s)", i, comment);
		            	return SendClientMessage(playerid, COLOR_WARNING, string);
		            }
		        }
		    }

			new Float:Px, Float:Py, Float:Pz;
			GetPlayerPos(playerid, Px, Py, Pz); /* Get player position */
			Mark[playerid][buffer][MS_X] = Px; /* Set Mark variable positions */
			Mark[playerid][buffer][MS_Y] = Py;
		    Mark[playerid][buffer][MS_Z] = Pz;
		    Mark[playerid][buffer][MS_INT] = GetPlayerInterior(playerid);
		    Mark[playerid][buffer][MS_WORLD] = GetPlayerVirtualWorld(playerid);

		    Mark[playerid][buffer][MS_TEXT] = comment;
		    //format(Mark[playerid][buffer][MS_TEXT], sizeof(Mark[playerid][buffer][MS_TEXT]), "%s", comment);
		    format(string, sizeof(string),"[INFO:] Your position was successfully saved into Mark ID: (%d) (Comment: %s).", buffer, comment);
		    return SendClientMessage(playerid, COLOR_NOTICE, string);
		}
	}

	else if(buffer >= 10)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You can only use mark IDs 0-9");
	}
	return 1;
}

CMD:gotomark(playerid, params[])
{
	if (FoCo_Player[playerid][admin] < 1)
	{
		SendClientMessage(playerid , COLOR_WARNING , "[ERROR]:  You are not authorized to use this command." );
		return 1;
	}

   	new buffer[16], string[128], val;
	if (sscanf(params, "s[16]", buffer))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /gotomark [0-9] [Optional: Comment]");
	}

	if(Vista_IsNumeric(buffer) && strlen(buffer) < 10) /* If no characters were entered (comment) */
	{
	    val = strval(buffer);
		if(IsPlayerInAnyVehicle(playerid))
		{
		    new veh = GetPlayerVehicleID(playerid);
		    SetPlayerPos(playerid, Mark[playerid][val][MS_X], Mark[playerid][val][MS_Y], Mark[playerid][val][MS_Z]);
		    SetPlayerInterior(playerid, Mark[playerid][val][MS_INT]);
		    SetPlayerVirtualWorld(playerid, Mark[playerid][val][MS_WORLD]);
		    SetVehiclePos(veh, Mark[playerid][val][MS_X], Mark[playerid][val][MS_Y], Mark[playerid][val][MS_Z]);
		    SetVehicleVirtualWorld(veh, Mark[playerid][val][MS_WORLD]);
		    PutPlayerInVehicle(playerid, veh, 0);
		}
		
		else
		{
	    	SetPlayerPos(playerid, Mark[playerid][val][MS_X], Mark[playerid][val][MS_Y], Mark[playerid][val][MS_Z]);
	    	SetPlayerInterior(playerid, Mark[playerid][val][MS_INT]);
		    SetPlayerVirtualWorld(playerid, Mark[playerid][val][MS_WORLD]);
	    }
	    
		format(string, sizeof(string), "[INFO:] You have been teleported to Mark ID: (%d)'s position.", val);
	    SendClientMessage(playerid, COLOR_NOTICE, string);
	    return 1;
	}

	else if(!Vista_IsNumeric(buffer))
	{
	    for(new i; i < MAX_MARKS; i++) /* Loop through all marks and see if a mark is associated with the entered comment */
	    {
	        if(strcmp(Mark[playerid][i][MS_TEXT], buffer, true) == 0)
	        {
				if(IsPlayerInAnyVehicle(playerid))
				{
				    new veh = GetPlayerVehicleID(playerid);
				    SetPlayerPos(playerid, Mark[playerid][val][MS_X], Mark[playerid][val][MS_Y], Mark[playerid][val][MS_Z]);
				    SetPlayerInterior(playerid, Mark[playerid][val][MS_INT]);
				    SetPlayerVirtualWorld(playerid, Mark[playerid][val][MS_WORLD]);
				    SetVehiclePos(veh, Mark[playerid][val][MS_X], Mark[playerid][val][MS_Y], Mark[playerid][val][MS_Z]);
				    SetVehicleVirtualWorld(veh, Mark[playerid][val][MS_WORLD]);
				    PutPlayerInVehicle(playerid, veh, 0);
				}

				else
				{
			    	SetPlayerPos(playerid, Mark[playerid][val][MS_X], Mark[playerid][val][MS_Y], Mark[playerid][val][MS_Z]);
			    	SetPlayerInterior(playerid, Mark[playerid][val][MS_INT]);
				    SetPlayerVirtualWorld(playerid, Mark[playerid][val][MS_WORLD]);
			    }

				format(string, sizeof(string), "[INFO:] You have been teleported to Mark ID: (%d)'s position.", val);
			    SendClientMessage(playerid, COLOR_NOTICE, string);

				break;

			}
   		}
	    return 1;
	}

	else if(strlen(buffer) >= 10)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You can only use mark IDs 0-9");
	}
	return 1;
}

CMD:resetmark(playerid, params[])
{
    if (FoCo_Player[playerid][admin] < 1)
	{
		return SendClientMessage(playerid , COLOR_WARNING , "[ERROR]:  You are not authorized to use this command." );
	}

   	new buffer, string[38];

	if (sscanf(params, "i", buffer))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "[USAGE]: /resetmark [0-9]");
	}

	if(buffer >= 10)
	{
	    return SendClientMessage(playerid, COLOR_WARNING, "[ERROR:] You can only use mark IDs 0-9");
	}

    Mark[playerid][buffer][MS_TEXT] = -1; /* Variable initialization */
    Mark[playerid][buffer][MS_X] = 0.0;
    Mark[playerid][buffer][MS_Y] = 0.0;
    Mark[playerid][buffer][MS_Z] = 0.0;

	format(string, sizeof(string),"[INFO:] Mark ID: (%d) has been reset.", buffer);
	SendClientMessage(playerid, COLOR_NOTICE, string);

    return 1;
}

/* Functions */

Vista_IsNumeric(const string[])
{
    for (new i = 0, j = strlen(string); i < j; i++)
    {
        if (string[i] > '9' || string[i] < '0') return 0;
    }

    return 1;
}

