#include <stdio.h>
#include <iostream.h>
#include <string.h>
#include <conio.h>
#include <fstream.h>

int Tot_Time[120][4];
int Count;
void GetDATEFromString(char String[],int &Days, int &Hours,int &Minutes, int &Seconds, int &Params)
{
	Params = sscanf (String, "%i Days - %i - Hours - %i - Minutes - %i Seconds ",  &Days, &Hours, &Minutes, &Seconds);
	if(Params < 4)
	{
		Params = sscanf (String, "%i %i %i %i",  &Days, &Hours, &Minutes, &Seconds);
	}
}

int main()
{
	string line;
	Count=0;
	ifstream myfile ("fixer.txt");
	if (myfile.open())
	{
		while ( getline (myfile,line) )
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
		myfile.open ("fixer.txt", ios::out);
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
	return 0;
}
