/*
	File: start.sqf
	Description: Client initialiaztion for BRGH
	Created By: PlayerUnknown & Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/
call BRGH_fnc_playerSetup;

diag_log "<START>: START VON";
call BRGH_fnc_startVON;

[] spawn {
	while{true} do {
		waitUntil{BRMini_GameStarted || (player distance (getmarkerpos "Spawn_Area")) > (((getmarkersize "Spawn_Area") select 0)*20)};
		if(BRMini_GameStarted) exitWith {}; 
		
		_pos = (getmarkerpos "Spawn_Area");
		_x = (_pos select 0) + (random(20)-10);
		_y = (_pos select 1) + (random(20)-10);
		player setposatl [_x,_y,0];
	};
};

diag_log "<START>: CHECK GAME IN PROGRESS";
_count = ({alive _x && isplayer _x} count((getMarkerPos "BRMini_SafeZone") nearObjects ["Man",500]));
if(_count > 0) exitWith {
	["THE GAME IS IN PROGRESS! PLEASE WAIT!",0,0.45,5,0] call BIS_fnc_dynamicText;
	hintSilent "Press TAB To enter spectator mode!";	
	_keybinds = (findDisplay 46) displayAddEventHandler ["KeyDown",{if((_this select 1) == 15) then {(getMarkerPos "BRMini_SafeZone") spawn fnc_BRCamera;};false}];
	waitUntil {[] call BRGH_fnc_updateInGameGUI; ({alive _x && isplayer _x} count((getMarkerPos "BRMini_SafeZone") nearObjects ["Man",500])) == 0 || !(alive player)};
	(findDisplay 46) displayRemoveEventHandler ["KeyDown",_keybinds];
	call BRGH_fnc_endVON;
	call BRGH_fnc_endSpectate;
	if !(alive player) exitWith {};
	player setDamage 1;
};
["<t align='center' color='#FFFFFF'>WAITING FOR THE ROUND TO START</t>"] call BRGH_fnc_updateInGameGUI;
waitUntil{BRMini_GameStarted};
[""] call BRGH_fnc_updateInGameGUI;
call BRGH_fnc_endVON;
diag_log "<START>: VON STOPPED";

diag_log "<START>: CLEANING BLUEZONE";
_old = BRMINI_ZoneObjects;
BRMINI_ZoneObjects = [];
{
		deleteVehicle _x;
} forEach _old;

waitUntil{(player distance (getMarkerPos "BRMini_SafeZone")) < 500};
player allowDamage true;
[10,40] call BRGH_fnc_AntiTP; //--- [Distance(m),MaxVelocity(km/h)] (OMG SUCH BUGS)
diag_log "<START>: ROUND STARTED";