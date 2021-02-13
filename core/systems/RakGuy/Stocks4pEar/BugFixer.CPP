#include <stdio.h>
#include <iostream.h>
#include <string.h>
#include <conio.h>

long int Bug_Time[10][4];
long int Tot_Time[4];

void GetDATEFromString(char String[],long int &Days,long int &Hours, long int &Minutes,long int &Seconds, int &Params)
{
	Params = sscanf (String, "%ld Days - %d - Hours - %d - Minutes - %d Seconds ",  &Days, &Hours, &Minutes, &Seconds);
	if(Params < 4)
	{
		Params = sscanf (String, "%i %i %i %i",  &Days, &Hours, &Minutes, &Seconds);
	}
}


int CalculateTotalTime(int Days, int Hours, int Minutes, int Seconds)
{
	int Fix_Time[4];
	if(Seconds>Tot_Time[3])
	{
		Tot_Time[2]-=1;
		Tot_Time[3]+=60;
	}
	Fix_Time[3]=Tot_Time[3]-Seconds;
	if(Minutes>Tot_Time[2])
	{
		Tot_Time[1]-=1;
		Tot_Time[2]+=60;
	}
	Fix_Time[2]=Tot_Time[2]-Minutes;
	if(Hours > Tot_Time[1])
	{
		Tot_Time[0]-=1;
		Tot_Time[1]+=24;
	}
	Fix_Time[1]=Tot_Time[1]-Hours;
	if(Days > Tot_Time[0])
	{
		cout<<"Total Time Less than Bugged Time. Suck dick."<<endl;
		return 1;
	}
	Fix_Time[0]=Tot_Time[0]-Days;
	cout<<"Total Time: "<<Fix_Time[0]<<" Days - "<<Fix_Time[1]<<" - Hours - "<<Fix_Time[2]<<" - Minutes - "<<Fix_Time[3]<<" Seconds"<<endl;
	return 1;
}
int main()
{
	cout<<"Time Can be mentioned in two formats:"<<endl;
	cout<<"1. 32842 Days - 1 - Hours - 25 - Minutes - 24 Seconds \t- Copy Paste"<<endl;
	cout<<"2. 32842 1 25 24\t\t\t\t\t- Manual"<<endl;
	char NiggaWanna='Y';
	while(NiggaWanna=='Y')
	{
		char P_input[101];
		char rimp[10];
		TotTime:
		cout<<"Enter Total time: ";
		cin.getline(P_input,100);
		cout<<endl;
		int Params;
		GetDATEFromString(P_input, Tot_Time[0], Tot_Time[1], Tot_Time[2], Tot_Time[3], Params);
		if(Params!=4)
		{
			NiggaWanna='Y';
			continue;
		}
		int BuggedTime=Tot_Time[0]/16000;
		if(BuggedTime==0)
		{
			BuggedTime=1;
		}
		for(int i = 0; i<BuggedTime; i++)
		{
			cout<<"Enter Bugged Time #"<<i+1<<": ";
			cin.getline(P_input,100);
			GetDATEFromString(P_input, Bug_Time[i][0], Bug_Time[i][1], Bug_Time[i][2], Bug_Time[i][3], Params);
			if(Params!=4)
			{
				cout<<endl<<"Error: Try Again."<<endl;
				i--;
			}
		}
		long int BuggedTotTime[4]={0,0,0,0};
		for(int k=0; k<BuggedTime; k++)
		{
			for(int j=0; j<4; j++)
			{
				BuggedTotTime[j]+=Bug_Time[k][j];
				if(j>1 && BuggedTotTime[j]>59)
				{
					BuggedTotTime[j-1]+=BuggedTotTime[j]/60;
					BuggedTotTime[j]=BuggedTotTime[j]%60;
				}
				if(j==1 && BuggedTotTime[j]>23)
				{
					BuggedTotTime[j-1]+=BuggedTotTime[j]/24;
					BuggedTotTime[j]=BuggedTotTime[j]%24;
				}
			}
		}
		CalculateTotalTime(BuggedTotTime[0],BuggedTotTime[1], BuggedTotTime[2],BuggedTotTime[3]);
		cout<<"You wanna fix another(Y/N)?";
		cin.getline(P_input,5);
		if(P_input[0]=='N' || P_input[0]=='0' || P_input[0]=='n')
		{
			NiggaWanna='N';
		}
		else
		{
			NiggaWanna='Y';
		}
	}
	getch();
	return 0;
}
