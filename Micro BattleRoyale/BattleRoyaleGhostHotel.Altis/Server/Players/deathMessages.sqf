/*
	File: deathMessages.sqf
	Description: Player death messages for BRGH
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

uiSleep 10;
_count = {alive _x && isplayer _x;} count((getMarkerPos "BRMini_SafeZone") nearObjects ["Man",1000]);
_original = _count;
while{true} do {
	waitUntil{!BRMini_InGame || _count != ({alive _x && isplayer _x;} count((getMarkerPos "BRMini_SafeZone") nearObjects ["Man",1000]))};
	_count = {alive _x && isplayer _x;} count((getMarkerPos "BRMini_SafeZone") nearObjects ["Man",1000]);
	if(!BRMini_InGame || _count <= 1) exitWith {};
	BR_DT_PVAR = [format["%2 DEAD, %1 TO GO!",_count,_original - _count],0,0.45,5,0];
	publicVariable "BR_DT_PVAR";
};
BRMini_InGame = false;