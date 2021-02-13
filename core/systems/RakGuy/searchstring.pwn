
#define MAX_BANNABLE_WORDS 12
#define MAX_DISALLOWED_WORDS 4
new BannableWords[MAX_BANNABLE_WORDS][12] = {
	"multimart",
	"multlmart",
	"multmart",
	"multimrt",
	"multmrt",
	"muitlmart",
	"muitimart",
	"muitmart",
	"muitimrt",
	"muitmrt",
	"mutimart",
	"mutlmart"
};

new DisAllowedWords[MAX_DISALLOWED_WORDS][11] = {
	"ugbase",
	"ugbse",
	"nigger",
	"niqqer"
};

stock SearchString(S_T[])
{
	new TempText[256];
	TempText = strtr(S_T, "! ~#$%^&*(),<.>/?:;'[{}]|_-+=1234567890", "");
	new Occurance[2];
	for(new i = 0; i < MAX_BANNABLE_WORDS; i++)
	{
		TempText = str_ireplace(BannableWords[i], "*", TempText, Occurance[1]);
		Occurance[0] += Occurance[1];
	}
	if(Occurance[0] > 0)
	{
        return 1;
	}
	
	for(new i = 0; i < MAX_DISALLOWED_WORDS; i++)
	{
		TempText = str_ireplace(DisAllowedWords[i], "*", TempText, Occurance[1]);
		Occurance[0] += Occurance[1];
	}
	if(Occurance[0] > 0)
	{
        return 2;
	}
	return 0;
}
