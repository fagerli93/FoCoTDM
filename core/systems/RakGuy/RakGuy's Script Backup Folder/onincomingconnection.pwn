#include <a_samp>
#include <FileFunctions>
#include <sscanf2>

#define ATTACK_TYPE_PLAYERID 1
#define ATTACK_TYPE_IP 2

new File:ServerLogFile;
new addostimer;



public OnFilterScriptInit()
{
	ServerLogFile = fileOpen("server_log.txt", io_Read);
	if(ServerLogFile)
	{
	    print("Opened");
	}
	addostimer = SetTimer("AntiDDoS", 20, true);
	return 1;
}

public OnFilterScriptExit()
{
	KillTimer(addostimer);
	return 1;
}

forward AntiDDoS();
public AntiDDoS()
{
	if(!ServerLogFile)
	{
		print("Error opening server_log.txt!");
		KillTimer(addostimer);
	}
	else
	{
		new string[128];
		fileSeek(ServerLogFile, -128, seek_End);
		while(fileRead(ServerLogFile, string)){}
		new pos =strfind(string, "Incoming connection: ");
		if(pos != -1)//21
		{
		    new idx = 0;
		    new IncDet[30];
			IncDet=strtok(string[pos+21], idx);
			new IncIP[16], Port;
			sscanf(IncDet, "p<:>s[16]i", IncIP, Port);
			CallRemoteFunction("OnFuckingIncomingConnection", "si", IncIP, Port);
			fileSeek(ServerLogFile,-512, seek_End);
			new SpamStr;
			while(fileRead(ServerLogFile, string))
			{
			    pos =strfind(string, "Incoming connection: ");
				if(pos != -1)//21
				{
				    IncDet=strtok(string[pos+21], idx);
					new T_IncIP[16], T_Port;
					sscanf(IncDet, "p<:>s[16]i", T_IncIP, T_Port);
					if(strcmp(IncIP, T_IncIP, false)==0)
					{
					    SpamStr++;
					}
				    if(SpamStr>3)
				    {
						SetTimerEx("Blockitffs", 0, false, "s", IncIP);
						break;
					}
				}
			}
		}
	}
}
forward Blockitffs(IP[]);
public Blockitffs(IP[])
{
	new MSG[40];
	format(MSG, sizeof(MSG), "banip %s", IP);
	print(MSG);
	SendRconCommand(MSG);
	return 1;
}
forward OnFuckingIncomingConnection(playerip[], playerport);
public OnFuckingIncomingConnection(playerip[], playerport)
{
    printf("OnFuckingIncomingConnection called.String: %s, Int: %i.",playerip, playerport);
    return 1;
}

stock strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}










