#include <stdio.h>
#include <iostream.h>
#include <string.h>
#include <conio.h>
#include <fstream.h>

int Tot_Time[100][4];
int Count;

void GetDATEFromString(char String[],int &Days,int &Hours, int &Minutes,int &Seconds, int &Params)
{
	Params = sscanf (String, "%ld Days - %d - Hours - %d - Minutes - %d Seconds ",  &Days, &Hours, &Minutes, &Seconds);
	if(Params < 4)
	{
		Params = sscanf (String, "%i %i %i %i",  &Days, &Hours, &Minutes, &Seconds);
	}
}
void CalculateAC(int Days, int Hours, int Minutes, int Seconds)
{
	float Float_Hours=0.0;
	int Int_Hours=0;
	Int_Hours = Days*24+Hours;
	Float_Hours = Minutes / 60 + Seconds / 3600;
	float Tot_Hours = (float)Int_Hours + Float_Hours;
	cout<<"Total Hours: "<<Tot_Hours<<endl;
	cout<<"Total Members: "<<Count<<endl;
	float P_Mem = Tot_Hours / (float)Count;
	cout<<"Hours / Member: "<<P_Mem<<endl;
	int Activity = (int)(P_Mem * 100.0);
	cout<<"Clan Activity: "<<Activity<<endl;
}
int main()
{
	Count=0;
	ifstream myfile;
	myfile.open("TIME.TXT", ios::in);
	if (myfile)
	{
		char line[101];
		while(myfile.getline(line,100))
		{
			int Params=0;
			GetDATEFromString(line, Tot_Time[Count][0], Tot_Time[Count][1], Tot_Time[Count][2], Tot_Time[Count][3], Params);
			if(Params==4)
			{
				Count++;
			}
		}
		myfile.close();
	}
	else
	{
		cout << "Unable to open file";
		ofstream myfile;
		myfile.open ("TIME.TXT", ios::out);
		myfile.close();
		return 1;
	}
	int BuggedTotTime[4]={0,0,0,0};
	for(int k=0; k<Count; k++)
	{
		for(int j=0; j<4; j++)
		{
			BuggedTotTime[j]+=Tot_Time[k][j];
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
	CalculateAC(BuggedTotTime[0], BuggedTotTime[1], BuggedTotTime[2], BuggedTotTime[3]);
	getch();
	return 0;
}
