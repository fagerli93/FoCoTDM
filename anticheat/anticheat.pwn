#if !defined MAIN_INIT
#error "Compiling from wrong script. (foco.pwn)"
#endif
	
/*AC DEFINES*/
#define GUARDIAN_PLAYERPAY 14

public OnGuardianPlayerWarning(playerid, warncode, reason[])
{
	new msgstring[256];
	format(msgstring, 256, "[Guardian]: {%06x}%s", COLOR_RED >>> 8,reason);
	SendAdminMessage(1, msgstring);
	CheatLog(msgstring);
	format(msgstring, 256, "6[Guardian]: %s", reason);
	IRC_GroupSay(gEcho, IRC_FOCO_ECHO, msgstring);
	return 1;
}

public OnGuardianVehicleWarning(vehicleid, driver, warncode, reason[])
{
	new msgstring[256];
	format(msgstring, 256, "[Guardian]: {%06x}%s", COLOR_RED >>> 8,reason);
	SendAdminMessage(1, msgstring);
	CheatLog(msgstring);
	format(msgstring, 256, "6[Guardian]: %s", reason);
	IRC_GroupSay(gEcho, IRC_FOCO_ECHO, msgstring);
	return 1;
}

