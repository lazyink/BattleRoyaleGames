/*
	File: reset.sqf
	Description: Client reset code for BRGH
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

diag_log "<START>: PLAYER RESPAWN SETUP STARTED";

BRMini_GameStarted = false;

[] spawn {
	waitUntil{!isNull ((findDisplay 12) displayCtrl 51)};
	((findDisplay 12) displayCtrl 51) ctrlremovealleventhandlers "Draw";
};

if(count(_this) > 1) then {
	if((_this select 0) distance (_this select 1) < 100 ) then {
		player setPosATL (getMarkerPos "respawn_west");
	};
};
if((_this select 0) distance (getMarkerPos "respawn_west") > 300) then {
	player setPosATL (getMarkerPos "respawn	_west");
};
player removeAllEventHandlers "Respawn";
player removeAllEventHandlers "Fired";
player removeAllEventHandlers "Hit";

call BRGH_fnc_endVON;
[] spawn BRGH_fnc_clientStart; 