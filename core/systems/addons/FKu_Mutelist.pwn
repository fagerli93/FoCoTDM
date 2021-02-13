#define MUTEL_DIALOG 510

/*
CMD:mutelist(playerid,params)
{
 	if(IsAdmin(playerid, 1))
 	{
	 	new text2[156],text[512];
	 	new count;
		foreach (new i : Player)
		{
			new mutedtime;
			if(Muted[i]  == 1)
			{
			    if (MutedByAdmin[i] == 1)
			    {
					mutedtime = (gettime() - MuteTime[i])/60;
					format(text2,sizeof(text2),"[%d] - %s muted by %s, %d minute(s) ago.\n",i,PlayerName(i),PlayerName(MutedBy[i]),mutedtime);
					strcat(text,text2,sizeof(text));
					count++;
				}
				else
				{
				    format(text2,sizeof(text2),"[%d] - %s is muted due to spam\n",i,PlayerName(i));
					strcat(text,text2,sizeof(text));
					count++;
				}
			}
		}
		ShowPlayerDialog(playerid,MUTEL_DIALOG,DIALOG_STYLE_MSGBOX,"Muted Players",text,"Close","");
		if (count == 0)
		{
		    SendClientMessage(playerid,COLOR_WARNING, "[ERROR]: Ain't nobody's mouth stuffed with cock.");
		}
	}
	return 1;
}
*/
