
#define MAX_DISALLOWED_WORDS 2

new DisAllowedWords[MAX_DISALLOWED_WORDS][24] = {
	"multimart",
	"ugbase"
};

stock SearchString(S_T[])
{
	new TempText[256];
	TempText = strtr(S_T, "! ~#$%^&*(),<.>/?:;'[{}]|_-+=1234567890", "");
	new Occurance[2];
	for(new i = 0; i < MAX_DISALLOWED_WORDS; i++)
	{
		TempText = str_ireplace(DisAllowedWords[i], "*", TempText, Occurance[1]);
		Occurance[0] += Occurance[1];
	}
	if(Occurance[0] > 0)
	{
        return 1;
	}
	return 0;
}
