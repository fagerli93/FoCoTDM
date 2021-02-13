case MYSQL_LOAD_ACHIEVEMENTS:
		{
			new sstring[256];
			mysql_store_result();
			if(mysql_num_rows() < 1)
			{
				mysql_free_result();
				format(sstring, sizeof(sstring), "INSERT INTO `FoCo_Achievements` (`ID`) VALUES ('%d')", FoCo_Player[extraid][id]);
				mysql_query(sstring, MYSQL_INSERT_ACHI, extraid, con);
				return 1;
			}

			new resultline[255];
			if(mysql_fetch_row_format(resultline))
			{
				new IntArray[AMOUNT_ACHIEVEMENTS+1];
				intsplit(resultline, IntArray, '|');
				for(new i = 0; i < AMOUNT_ACHIEVEMENTS+1; i++)
				{
					FoCo_PlayerAchievements[extraid][i] = IntArray[i];
				}
			}

			mysql_free_result();
			GiveAchievement(extraid, 1);
			FoCo_Player[extraid][registered] = 1;
			return 1;
		}
		case MYSQL_INSERT_ACHI:
		{
			new sstring[160];
			printf("THREAD: MYSQL_INSERT_ACHI called.. passed params: userid(%d)", extraid);
			format(sstring, sizeof(sstring), "SELECT * FROM `FoCo_Achievements` WHERE `ID`='%d'", FoCo_Player[extraid][id]);
			mysql_query(sstring, MYSQL_LOAD_ACHIEVEMENTS, extraid, con);
			return 1;
		}
