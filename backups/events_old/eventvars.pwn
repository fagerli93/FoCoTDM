/* Variables */

/* event IDs  (Enum allows dynamic ID changes without redefining every ID) */

enum
{
	MADDOGG,
	BIGSMOKE,
	MINIGUN,
	BRAWL,
	HYDRA,
	GUNGAME,
	JEFFTDM,
	AREA51,
	ARMYVSTERRORISTS,
	NAVYVSTERRORISTS,
	COMPOUND,
	OILRIG,
	DRUGRUN,
	MONSTERSUMO,
	BANGERSUMO,
	SANDKSUMO,
	SANDKSUMORELOADED,
	DESTRUCTIONDERBY,
	PURSUIT
};


new
	Iterator:Event_Players<MAX_PLAYERS>,
	Iterator:Event_Vehicles<50>;

new
	Event_InProgress;

 /* Event_InProgress values:

	- 0 : Event has been started and can be joined
	- 1 : Event has been started but cannot be joined (30 secs after event start)
	- (-1) : No event is running
*/

new
	Event_ID,
	DialogIDOption[MAX_PLAYERS];

new
	Float:BrawlX,
	Float:BrawlY,
	Float:BrawlZ,
	Float:BrawlA,
	BrawlInt,
	BrawlVW;

new
    hydraTime,
    PlayerPursuitTimer[MAX_PLAYERS];

new
    FoCo_Event_Rejoin,
    Event_Delay,
    E_Pursuit_Criminal;
//    lastEventWon;

new
    FoCo_Event_Died[MAX_PLAYERS];

new
	FFAArmour,
	FFAWeapons;

new
	DrugEventVehicles[128],
	Event_PlayerVeh[MAX_PLAYERS] = -1;

new
	 Motel_Team = 0,
	 Team1_Motel = 0,
	 Team2_Motel = 0;

new
    EventDrugDelay[MAX_PLAYERS];

new
	lastGunGameWeapon[MAX_PLAYERS] = 38,
	GunGameKills[MAX_PLAYERS];

new
    spawnSeconds[MAX_PLAYERS];
    
new
	lastKillReason[MAX_PLAYERS];
	
new
	FoCo_Event_Rejoin;
