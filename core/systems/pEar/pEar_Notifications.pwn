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
* Filename: pEar_ACP.pwn                                                         *
* Author: pEar	                                                                 *
*********************************************************************************/

#include <YSI\y_timers>
#include <YSI\y_hooks>

hook OnPlayerConnect(playerid) {
	show_notifications(playerid);
	return 1;
}

forward show_notifications(playerid);
public show_notifications(playerid) {
	return 1;
}

public getNotifications(playerid) {
	new query[128];
	format(query, sizeof(query), "SELECT * FROM FoCo_Notifications WHERE ID='%d' AND status='0' ORDER BY `ID` DESC LIMIT 1", FoCo_Player[playerid][id]);
	mysql_query(query, MYSQL_NOTIFICATIONS, playerid, con);
	return 1;
}	

/*
#define MYSQL_NOTIFICATIONS 109
#define MYSQL_NOTIFICATIONS_READ 110


case MYSQL_NOTIFICATIONS_READ: return 1;
case MYSQL_NOTIFICATIONS: {
	mysql_store_result();
	new result[512];
	new ID;
	new msg;
	new by[56];
	new status;
	new date[56];
	if(mysql_fetch_row(result)) {
		sscanf(result, "p<|>ds[512]s[56]ds[56]", ID, msg, by, status, date);
		new title[128];
		format(title, sizeof(title), "Offline notification from %s - %s", by, date);
		ShowPlayerDialog(extraid, DIALOG_NOTIFICATIONS, DIALOG_STYLE_MSGBOX, title, msg, "Okay!", "");
		new query[256];
		format(query, sizeof(query), "UPDATE FoCo_Notifications SET status='1' WHERE `ID`='%d'", ID);
		mysql_query(query, MYSQL_NOTIFICATIONS_READ, extraid, con);
	} 
	mysql_free_result();
	return 1;
}

*/