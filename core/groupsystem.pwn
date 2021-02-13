/*

					*********************************************************************************
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
					* Filename: groupsystem.pwn                                                      *
					* Author: Marcel                                                                 *
					**********************************************************************************
	OVERVIEW:
	
	    Group system:
		The group system will allow people to create a group in-game, not necessarily connected to an unofficial clan.
		You'll create a group, the creator will be the group leader and once the group leader quits the server the
		oldest member will be set as new group leader. Once all group members left the server, the group will be
		disbanded and it can once again be created. This could for example be used to chat with friends from different
		teams or to chat with people from the same country. A user can only be in 1 group at the same time.

		-/groupcreate <groupname> (creates a group)
		-/grouplist <groupname> (shows the members in the group)
		-/gm <message> (allows you to send a message to your fellow group members)
		-/groups (allows you to see all current groups)
		-/groupinvite <playername/id> (allows the groupleader to invite a member to the group)
		-/groupremove <playername/id> (allows the groupleader to remove a member from the group)
		-/groupjoin <groupname> (sends a request to the groupleader that user of the command wants to join the group, the leader can then accept or deny the request)




	TODO:

		-Basic System for dynamic groups, define a MAX_GROUPS of 10-15?
		-Remove /g? And make "Static Groups" with non Leader for the existing Teams?
		-SQL Table for Static Groups / Static Group System for unofficial Clans
		    *Static Group field for Unofficial Clan Members (FoCo_Players)
		    *Only unofficial Clan Leader can add Members to the group, leader defined in Static Group Table "leader"
		    *Admins Lvl 3+ can change any member anyways and join/leave any group whenever they want

*/





