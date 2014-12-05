/*
	File: player_eventHandlers.sqf
	Description: Setup Unit EventHandlers
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

diag_log "<PEH>:  ADDING EVENT HANDLERS";
player addEventHandler ["Respawn",{_this spawn BRGH_fnc_clientReset;}];
//--- spectator unit coloring features
player addEventHandler ["Hit",{[] spawn {player setVariable ["BRHit",true,true]; uiSleep 5;player setVariable ["BRHit",false,true];};}];
player addEventHandler ["Fired",{[] spawn {player setVariable ["BRFired",true,true]; uiSleep 5;player setVariable ["BRFired",false,true];};}];
