#include <a_samp>

stock GetXYZInFrontOfPlayer(playerid, Float:range, &Float:x, &Float:y, &Float:z)
{
    new Float:fPX, Float:fPY, Float:fPZ,Float:fVX, Float:fVY, Float:fVZ;
    GetPlayerCameraPos(playerid, fPX, fPY, fPZ);
    GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);
    x = fPX + floatmul(fVX, range);
    y = fPY + floatmul(fVY, range);
    z = fPZ + floatmul(fVZ, range);
}

stock GetBXYZInFrontOfPlayer(playerid, Float:range, &Float:x, &Float:y, &Float:z)
{
    new Float:fVX, Float:fVY, Float:fVZ;
    GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);
    x = x + floatmul(fVX, range);
    y = y + floatmul(fVY, range);
    z = z + floatmul(fVZ, range);
}


stock Float:GetDistanceBetweenVectors(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    return VectorSize(x1-x2, y1-y2, z1-z2);
}

stock Float:GetDistance(Float:x1,Float:y1,Float:z1, Float:x2,Float:y2,Float:z2)
{
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
   	new MSG[150];
    new Float:fOriginX, Float:fOriginY, Float:fOriginZ,Float:fHitPosX, Float:fHitPosY, Float:fHitPosZ;
	GetPlayerLastShotVectors(playerid, fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);
	format(MSG, sizeof(MSG), "Orig: %f %f %f Hit: %f %f %f HVector: %f %f %f",fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ, fX, fY, fZ);
	SendClientMessage(playerid, -1, MSG);
	new Float:BulletDistance = GetDistanceBetweenVectors(fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);
	new Float:AB_PlayerLoc[3];
	GetPlayerPos(playerid,AB_PlayerLoc[0],AB_PlayerLoc[1],AB_PlayerLoc[2]);
	format(MSG, sizeof(MSG), "Pos: %f %f %f", AB_PlayerLoc[0],AB_PlayerLoc[1],AB_PlayerLoc[2]);
	SendClientMessage(playerid, -1, MSG);
	GetXYZInFrontOfPlayer(playerid, BulletDistance, AB_PlayerLoc[0],AB_PlayerLoc[1],AB_PlayerLoc[2]);
	new Float:RayDistance=GetDistance(AB_PlayerLoc[0],AB_PlayerLoc[1],AB_PlayerLoc[2],fHitPosX, fHitPosY, fHitPosZ);
	format(MSG, sizeof(MSG), "R1 Distance: %f :: R1 End: %f %f %f", BulletDistance,fHitPosX, fHitPosY, fHitPosZ);
	SendClientMessage(playerid, -1, MSG);
	format(MSG, sizeof(MSG), "Met1: Difference: %f :: R2 End: %f %f %f", RayDistance,AB_PlayerLoc[0],AB_PlayerLoc[1],AB_PlayerLoc[2]);
	SendClientMessage(playerid, -1, MSG);
	GetBXYZInFrontOfPlayer(playerid, BulletDistance, fOriginX, fOriginY, fOriginZ);
	RayDistance=GetDistance(fOriginX, fOriginY, fOriginZ,fHitPosX, fHitPosY, fHitPosZ);
	format(MSG, sizeof(MSG), "Met2: Difference: %f :: R2 End: %f %f %f", RayDistance,fOriginX, fOriginY, fOriginZ);
	SendClientMessage(playerid, -1, MSG);
	return 1;
}

























