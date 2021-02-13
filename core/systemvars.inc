/*
AFK SYSTEM
*/
new Float:afkX[MAX_PLAYERS];					// Shows where the player went afk
new Float:afkY[MAX_PLAYERS];					// Shows where the player went afk
new Float:afkZ[MAX_PLAYERS];					// Shows where the player went afk
new lastHit[MAX_PLAYERS];						// When the player last took damage
new afkTimer[MAX_PLAYERS];						// The timer for going AFK
new afkReason[MAX_PLAYERS][50];

/*
VEHICLE SYSTEM
*/

enum
{
	VEHICLE_TYPE_TEMPORARY = 0,
	VEHICLE_TYPE_PRIVATE = 1,
	VEHICLE_TYPE_PUBLIC = 2
};

enum FoCo_Vehicle_Info
{
	cid,
	cmodel,
	Float:cx,
	Float:cy,
	Float:cz,
	Float:cangle,
	ccol1,
	ccol2,
	cplate[25],
	coname[MAX_PLAYER_NAME],
	coid,
	clocked,
	cvw,
	cint,
	special_mod,
	v_type
};
new FoCo_Vehicles[MAX_VEHICLES][FoCo_Vehicle_Info];

/*
PLAYER SYSTEM
*/

enum FoCo_Player_Info
{
	id,
	level,
	admin,
	cash,
	score,
	banned,
	registered,
	skin,
	username[30],
	user_password[128],
	clan,
	clanrank,
	tester,
	jailed,
	onlinetime,
	admintime,
	reports,
	admin_kicks,
	admin_jails,
	admin_bans,
	admin_warns,
	users_carid,
	email[80],
	warns,
	tempban,
	donation,
	nchanges,
	online,
	public_profile,
	register_date[20],
	lifetime_donator,
	last_namechange,
	cmt,
	staff_management,
	dev,
	duels_won,
	duels_lost,
	duels_total,
	trusted,
	failed_logins_ucp,
	saltfix[128],
	clan_name[50],
	clan_rank_name[20]
};
new FoCo_Player[MAX_PLAYERS][FoCo_Player_Info];
new FoCo_Player_UCP[MAX_PLAYERS][FoCo_Player_Info];
new FoCo_Player_LastUCP[MAX_PLAYERS][FoCo_Player_Info];

enum FoCo_PlayerStats_Info
{
	id,
	headshots,
	deaths,
	kills,
	heli,
	streaks,
	suicides,
	helpups,
	deagle,
	m4,
	mp5,
	knife,
	rpg,
	flamethrower,
	chainsaw,
	grenade,
	colt,
	uzi,
	combatshotgun,
	smg,
	ak47,
	tec9,
	sniper, 
	cpgs_captured,
	assists
};

new FoCo_Playerstats[MAX_PLAYERS][FoCo_PlayerStats_Info];
new FoCo_Playerstats_UCP[MAX_PLAYERS][FoCo_PlayerStats_Info];
new FoCo_Playerstats_LastUCP[MAX_PLAYERS][FoCo_PlayerStats_Info];

enum FoCo_Donation_Info
{
	did,
	dpid,
	dbuy,
	dexp,
	dtype,
	dcar1,
	dcar2,
	dcar3
};
new FoCo_Donations[MAX_PLAYERS][FoCo_Donation_Info];

new ipstring[MAX_PLAYERS][20];					// This will store the players IP on connection.
new gPlayerLogged[MAX_PLAYERS];					// Toggles if a player is logged in or not.
new OnlineTimer[MAX_PLAYERS];					// This stores how long a player has been online for.
new Spawned[MAX_PLAYERS];						// This toggles if the player is spawned or not.
new FoCo_Team[MAX_PLAYERS];						// Stores the team which the player is currently on.
new passPass[MAX_PLAYERS][50];					// passees the data for SQL OnPlayerLogin
new justConnected[MAX_PLAYERS] = 1;
/*
VOTE SYSTEM
*/
new FoCo_Vote_Question[128];					// This will store the question you are voting on.
new FoCo_Vote_Answer1[40]; 						// This will store answer number one.
new FoCo_Vote_Answer2[40];						// This will store answer number two.
new FoCo_Vote_Answer3[40];						// This will store answer number three.
new FoCo_Vote_Response1; 						// This will store amount of responses number 1 has achieved.
new FoCo_Vote_Response2;						// This will store amount of responses number 2 has achieved.
new FoCo_Vote_Response3;						// This will store amount of responses number 3 has achieved.
new FoCo_Vote;


enum sql_db_info
{
	bool:sql_pstats,
	bool:sql_achievements,
	bool:sql_data
}
new SQL_Loaded[MAX_PLAYERS][sql_db_info];
