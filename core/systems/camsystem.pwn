#include <YSI\y_hooks>
#define DIALOG_CAM 525

enum e_CamSys
{
	Float:CamPos[3],
	Float:CamLookAt[3]
};

new CamCoords[][e_CamSys] = 
{
	{{1972.4014,-1762.5679,21.8558}, {1942.3716,-1772.8252,13.6406}}, // IGS #1
	{{1931.3016,-1820.3651,29.9428}, {1930.9592,-1782.4478,13.5469}}, // IGS #2
	{{1972.9403,-1800.6720,26.1350}, {2003.9037,-1795.2568,26.1350}}, // IGS #3
	{{1871.6176,-1684.0519,57.8486}, {1885.8257,-1730.4169,31.8047}}, // Alhambra #1
	{{1798.4692,-1720.6849,28.3818}, {1824.9733,-1748.9296,13.3828}}, // Alhambra #2
	{{1703.4796,-1468.1770,18.7266}, {1702.5553,-1494.2880,13.3828}}, // Ammunation #1 
	{{1320.6721,-1279.9653,27.6348}, {1359.4867,-1278.3475,13.3798}}  // Ammunation #2
};	


/* OnDialogResponse */
hook OnDialogResponse(playerid,dialogid,response,listitem,inputtext[])
{
    print("ODR_camsys");
	if(dialogid == DIALOG_CAM)
	{
		if(response)
		{
			SetPlayerPos(playerid, CamCoords[listitem][CamPos][0], CamCoords[listitem][CamPos][1], -10);
			SetPlayerCameraPos(playerid, CamCoords[listitem][CamPos][0], CamCoords[listitem][CamPos][1], CamCoords[listitem][CamPos][2]);
			SetPlayerCameraLookAt(playerid, CamCoords[listitem][CamLookAt][0], CamCoords[listitem][CamLookAt][1], CamCoords[listitem][CamLookAt][2]);

			camera[playerid] = 1;
			TogglePlayerControllable(playerid, 0);
		}	
	}
	return 1;
}

/* CMD */


CMD:cam(playerid, params[])
{
	if(IsAdmin(playerid, ACMD_CAM))
	{
		if(!camera[playerid])
		{
			ShowPlayerDialog(playerid, DIALOG_CAM, DIALOG_STYLE_LIST, "Cameras", "IGS 1\nIGS 2\nIGS 3\nAlhambra 1\nAlhambra 2\nAmmu-Nation 1\nAmmu-Nation 2", "Okay", "Cancel");
		}

		else
		{
			SpawnPlayer(playerid);
			camera[playerid] = 0;
		}
	}	
	return 1;
}
