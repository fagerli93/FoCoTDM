// This is a comment
// uncomment the line below if you want to write a filterscript
#define FILTERSCRIPT
#define COLOR_YELLOW 0xF0DC82FF

#include <a_samp>
#include <zcmd>
#include <sscanf2>

CMD:pa(playerid, params[])
{
    new Float:rad, Float:Pos[3], msg[53], name[MAX_PLAYER_NAME];
    new pCount = 0;
    if(sscanf(params, "f", rad))
    {
        SendClientMessage(playerid, 0xFF0000FF, "ServMSG: Usage - /pa [Radius(<100)]");
  		return 1;
    }
	else
	{
		if(rad > 100) return SendClientMessage(playerid, 0xFF0000FF, "Radius amount may not be above 100.");
		for(new i=0; i<MAX_PLAYERS; i++)
        {
   			if(IsPlayerConnected(i))
         	{
         	    GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
   	     		if(IsPlayerInRangeOfPoint(i, rad, Pos[0], Pos[1], Pos[2]))
            	{
	                if(i!=playerid)
	                {
                        pCount ++;
						new car[4];
						GetPlayerName(i, name, sizeof(name));
						valstr(car, GetPlayerVehicleID(i));
						car=(GetPlayerVehicleID(i)==0)?("Nil"):(car);
	                   	format(msg, sizeof(msg), "ServMSG: %i. %s [playerID: %i] [vehicleID: %s]", pCount, name, i, car);
	                    SendClientMessage(playerid, COLOR_YELLOW, msg);
	                }
				}
            }
		}
	}
	if(pCount == 0)
   	{
   		SendClientMessage(playerid, 0x837050FF, "ServMSG: No Player around within the given radius. Try increasing.");
	}
    return 1;
}


