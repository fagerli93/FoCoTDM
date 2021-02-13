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
* Filename: pEar_ChangePassEmail.pwn                                             *
* Author: pEar	                                                                 *
*********************************************************************************/

/* 
#define MYSQL_CHANGEPASSWORD 124
#define MYSQL_CHANGEPASSWORD_CONFIRM 125
#define MYSQL_CHANGEPASSWORD_FINISH 126
#define MYSQL_UPDATE_MAIL 127
#define DIALOG_CHANGEPASSWORD 402
#define DIALOG_CHANGEPASSWORD_NEW 403
#define DIALOG_CHANGEPASSWORD_CONFIRM 404
#define DIALOG_CHANGEEMAIL 405
*/

#include <YSI\y_hooks>

CMD:changepassword(playerid, params[]) {
	ShowPlayerDialog(playerid, DIALOG_CHANGEPASSWORD, DIALOG_STYLE_PASSWORD, "Change password", "Enter your old password", "Next", "Cancel");
	return 1;
}

CMD:changeemail(playerid, params[]) {
	SetPVarInt(playerid, "change_email", 1);
	ShowPlayerDialog(playerid, DIALOG_CHANGEPASSWORD, DIALOG_STYLE_PASSWORD, "Change email", "In order to change your email, you need to enter your password", "Next", "Cancel");
	return 1;
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid) {
		case DIALOG_CHANGEPASSWORD: {
			if(response) {
				new query[256];
				SetPVarString(playerid, "password_change", inputtext);
				format(query, sizeof(query), "SELECT `ID`, `salt` FROM `FoCo_Players` WHERE `ID`='%d' LIMIT 1", FoCo_Player[playerid][id]);
				mysql_query(query, MYSQL_CHANGEPASSWORD, playerid, con);
			} else {
				if(GetPVarInt(playerid, "change_email") == 1) {
					DeletePVar(playerid, "change_email");
					SendClientMessage(playerid, COLOR_WARNING, "Cancelled email change.");
				} else {
					SendClientMessage(playerid, COLOR_WARNING, "Cancelled password change.");
				}
				
			}
			return 1;
		}
		case DIALOG_CHANGEPASSWORD_NEW: {
			if(response) {
				if(strlen(inputtext) > 128) {
					return ShowPlayerDialog(playerid, DIALOG_CHANGEPASSWORD_NEW, DIALOG_STYLE_PASSWORD, "Change password", "Enter your new password\nMax password length is 128 characters.", "Next", "Cancel");
				}
				if(strlen(inputtext) < 6) {
					return ShowPlayerDialog(playerid, DIALOG_CHANGEPASSWORD_NEW, DIALOG_STYLE_PASSWORD, "Change password", "Enter your new password\nMinimum password length is 6 characters.", "Next", "Cancel");
				}
				SetPVarString(playerid, "password_new", inputtext);
				ShowPlayerDialog(playerid, DIALOG_CHANGEPASSWORD_CONFIRM, DIALOG_STYLE_PASSWORD, "Change password", "Confirm your new password by entering it again", "Save", "Cancel");
			} else {
				return SendClientMessage(playerid, COLOR_WARNING, "Cancelled password change.");
			}
			return 1;
		}
		case DIALOG_CHANGEPASSWORD_CONFIRM: {
			if(response) {
				new password[128];
				GetPVarString(playerid, "password_new", password, sizeof(password));
				DeletePVar(playerid, "password_new");
				if(strcmp(password, inputtext) == 0) {
					new hash[512], query[512], salt[128];
					GetPVarString(playerid, "password_salt", salt, sizeof(salt));
					DeletePVar(playerid, "password_salt");
					strcat(password, salt);
					WP_Hash(hash, sizeof(hash), password);
					format(query, sizeof(query), "UPDATE `FoCo_Players` SET `password`='%s' WHERE `ID`='%d'", hash, FoCo_Player[playerid][id]);
					mysql_query(query, MYSQL_CHANGEPASSWORD_FINISH, playerid, con);
				} else {
					ShowPlayerDialog(playerid, DIALOG_CHANGEPASSWORD_NEW, DIALOG_STYLE_PASSWORD, "Change password", "Enter your new password\nThe passwords didn't match - try again", "Next", "Cancel");
				}
				
			} else {
				return SendClientMessage(playerid, COLOR_WARNING, "Cancelled password change.");
			}
			return 1;
		}
		case DIALOG_CHANGEEMAIL: {
			if(response) {
				new start[50], mid[50], end[50];
				DebugMsg("Before sscanf");
				if(sscanf(inputtext, "s@s.s", start, mid, end)) {
					new query[512];
					format(query, sizeof(query), "Start: %s, mid: %s, end: %s", start, mid, end);
					DebugMsg(query);
					format(query, sizeof(query), "UPDATE `FoCo_Players` SET `email`='%s' WHERE `ID`='%d'", inputtext, FoCo_Player[playerid][id]);
					mysql_query(query, MYSQL_UPDATE_MAIL, playerid, con);
					return 1;
				} else {
					return ShowPlayerDialog(playerid, DIALOG_CHANGEEMAIL, DIALOG_STYLE_INPUT, "Change email", "Enter your new email\nYou entered an invalid email", "Save", "Cancel");
				}
			} else {
				DeletePVar(playerid, "change_email");
				return SendClientMessage(playerid, COLOR_WARNING, "Cancelled email change.");
			}
		}
	}
	return 1;
}

forward ChangePass_OnQueryFinish(query[], resultid, extraid, connectionHandle);
public ChangePass_OnQueryFinish(query[], resultid, extraid, connectionHandle) {
	switch(resultid) {
		case MYSQL_CHANGEPASSWORD: {
			mysql_store_result();
			if(mysql_num_rows() > 0) {
				new resultline[128], ID, salt[64], cp_query[256];
				if(mysql_fetch_row_format(resultline)) {
					sscanf(resultline, "p<|>ds[64]", ID, salt);
					if(strcmp(salt, "0") != 0) {
						new pass[256], hash[256];
						GetPVarString(extraid, "password_change", pass, sizeof(pass));
						DeletePVar(extraid, "password_change");
						SetPVarString(extraid, "password_salt", salt);
						strcat(pass, salt);
						WP_Hash(hash, sizeof(hash), pass);
						format(cp_query, sizeof(cp_query), "SELECT * FROM FoCo_Players WHERE `ID`='%d' AND password='%s' LIMIT 1", FoCo_Player[extraid][id], hash);
						mysql_query(cp_query, MYSQL_CHANGEPASSWORD_CONFIRM, extraid, con);
					} else {
						return SendClientMessage(extraid, COLOR_WARNING, "Something went wrong - no salt found. Contact a developer about this.");
					}
				}
			} else {
				return SendClientMessage(extraid, COLOR_WARNING, "Something went wrong. Contact a developer about this.");
			}

			mysql_free_result();
			return 1;
		}
		case MYSQL_CHANGEPASSWORD_CONFIRM: {
			mysql_store_result();
			/* Old password correct - make new password */
			if(mysql_num_rows() > 0) {
				if(GetPVarInt(extraid, "change_email") == 1) {
					ShowPlayerDialog(extraid, DIALOG_CHANGEEMAIL, DIALOG_STYLE_INPUT, "Change email", "Enter your new email", "Save", "Cancel");
				} else {
					ShowPlayerDialog(extraid, DIALOG_CHANGEPASSWORD_NEW, DIALOG_STYLE_PASSWORD, "Change password", "Enter your new password", "Next", "Cancel");
				}
				
			} else {
				if(GetPVarInt(extraid, "change_email") == 1) {
					ShowPlayerDialog(extraid, DIALOG_CHANGEPASSWORD, DIALOG_STYLE_PASSWORD, "Change email", "In order to change your email, you need to enter your password\nYou entered an incorrect password, try again.", "Next", "Cancel");
				} else {
					ShowPlayerDialog(extraid, DIALOG_CHANGEPASSWORD, DIALOG_STYLE_PASSWORD, "Change password", "Enter your old password\n\nYou entered the wrong password!", "Next", "Cancel");
				}
				
			}

			mysql_free_result();
			return 1;
		}
		case MYSQL_CHANGEPASSWORD_FINISH: {
			mysql_store_result();
			SendClientMessage(extraid, COLOR_NOTICE, "Congratulations, your password has been changed!");
			mysql_free_result();
			return 1;
		}
		case MYSQL_UPDATE_MAIL: {
			mysql_store_result();
			SendClientMessage(extraid, COLOR_NOTICE, "Congratulations, your email has been changed!");
			mysql_free_result();
			return 1;
		}
	}
	return 1;
}