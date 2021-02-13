#include <YSI\y_hooks>

new const FKu_QuakeSounds[][] = {
	{"http://k002.kiwi6.com/hotlink/82c0967k7x/firstblood.mp3"},//First Blood sound
	{"http://k002.kiwi6.com/hotlink/gtjna40610/doublekill.mp3"},//Double kill
	{"http://k002.kiwi6.com/hotlink/6151tvgv3r/triplekill.mp3"},//Triple Kill
	{"http://k002.kiwi6.com/hotlink/f3qm6l9387/multikill.mp3"},//Multi Kill
	{"http://k002.kiwi6.com/hotlink/0p1j309r26/killingspree.mp3"},//Killing Spree
	{"http://k002.kiwi6.com/hotlink/0l8px9vzh0/impressive.mp3"},//Impressive
	{"http://k002.kiwi6.com/hotlink/i71lg39cd6/ludicrouskill.mp3"},//Ludicrous Kill
	{"http://k002.kiwi6.com/hotlink/bw73a14xzw/monsterkill.mp3"},//Monster Kill
	{"http://k002.kiwi6.com/hotlink/w6zh1kwr51/rampage.mp3"},//Rampage
	{"http://k002.kiwi6.com/hotlink/e741shmhsx/combowhore.mp3"},//Combo Whore
	{"http://k002.kiwi6.com/hotlink/ogv2l59z8j/headhunter.wav"},//Head Hunter
	{"http://k002.kiwi6.com/hotlink/2ft724ib51/holyshit.mp3"},//Holy shit!
	{"http://k002.kiwi6.com/hotlink/td581yqb45/ultrakill.mp3"},//Ultra kill
	{"http://k002.kiwi6.com/hotlink/gb4blikqyv/unstoppable.mp3"},//Unstoppable
	{"http://k002.kiwi6.com/hotlink/37fo8i2yug/godlike.mp3"}//God like
};

new bool:QSoundsT[MAX_PLAYERS];

CMD:qsounds(playerid, params[])
{
	if(QSoundsT[playerid] == false)
	{
		SendClientMessage(playerid,COLOR_CMDNOTICE,"Quake sounds are now {33cc00}on.");
		QSoundsT[playerid] = true;
	}
	else
	{
		SendClientMessage(playerid,COLOR_CMDNOTICE,"Quake sounds are now {cc3333}off.");
		QSoundsT[playerid] = false;
	}
	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID)
	{
		if(QSoundsT[killerid] == true) PlayAudioStreamForPlayer(killerid,FKu_QuakeSounds[CurrentKillStreak[killerid]]);
	}
	return 1;
}
