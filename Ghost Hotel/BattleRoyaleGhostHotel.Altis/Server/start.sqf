/*
	File: start.sqf
	Description: Server initialiaztion for BRGH
	Created By: PlayerUnknown & Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

BRMini_GamesPlayed = BRMini_GamesPlayed + 1;

call BRGH_fnc_lootConfig;


_fogThread = [] call BRGH_fnc_simpleFog;
_weatherThread = [] spawn BRGH_fnc_startWeather;

call BRGH_fnc_spawnLoot;
call BRGH_fnc_waitForPlayers;

uiSleep 10;
BR_DT_PVAR = ["THIS IS BATTLE ROYALE",0,0.45,5,0];
publicVariable "BR_DT_PVAR";
uiSleep 6;
BR_DT_PVAR = ["GHOST HOTEL",0,0.45,5,0];
publicVariable "BR_DT_PVAR";
uiSleep 10;
BR_DT_PVAR = ["A PLAYERUNKNOWN PRODUCTION",0,0.45,5,0];
publicVariable "BR_DT_PVAR";
uiSleep 10;

BRMini_GameStarted = true;
publicVariable "BRMini_GameStarted";

"DISABLE_EVENTS = (findDisplay 46) displayAddEventHandler ['KeyDown',{true}];" call BRMini_RE;

_pos = (getMarkerPos "BRMini_SafeZone");
_roads = _pos nearRoads 150;	
{
	_pos = getposatl (_roads select floor(random(count(_roads))));
	_x setposatl _pos;
} forEach playableUnits;

uiSleep 1;
BR_DT_PVAR = ["3",0,0.45,1,0];
publicVariable "BR_DT_PVAR";
uiSleep 1;
BR_DT_PVAR = ["2",0,0.45,1,0];
publicVariable "BR_DT_PVAR";
uiSleep 1;
BR_DT_PVAR = ["1",0,0.45,1,0];
publicVariable "BR_DT_PVAR";
uiSleep 1;
BRMini_InGame = true;
BR_DT_PVAR = ["GOOD LUCK!",0,0.45,1,0];
publicVariable "BR_DT_PVAR";

"(findDisplay 46) displayRemoveEventHandler ['KeyDown',DISABLE_EVENTS];" call BRMini_RE;

[] spawn BRGH_fnc_deathMessages;
[] spawn BRGH_fnc_startZoning;


waitUntil{!BRMini_InGame};

BRMini_ServerOn = false;

uiSleep 4;

_winners = (getMarkerPos "BRMini_SafeZone") nearObjects ["Man",300];
{
	if(alive _x && isplayer _x) then {
		_name = name _x;

		_index = BRMini_Winners find _name;
		if(_index == -1) then {
			_index = count(BRMini_Winners);
			BRMini_Winners set[count(BRMini_Winners),_name];
		};
		_score = 0;
		if(_index < count(BRMini_WinnerScores)) then {
			_score = (BRMini_WinnerScores select _index);
		};
		_score = _score + 1;
		BRMini_WinnerScores set[_index,_score];
	
		_txt = format["%1 - WINNER, WINNER, CHICKEN DINNER!",_name];
		BR_DT_PVAR = [ _txt,0,0.45,10,0];
		publicVariable "BR_DT_PVAR";
		uiSleep 5;
		BR_DT_PVAR = ["YOU ARE A BATTLE ROYALE: GHOST HOTEL WINNER!",0,0.45,10,0];
		publicVariable "BR_DT_PVAR";
		uiSleep 5;
		BR_DT_PVAR = ["CONGRATULATIONS!",0,0.45,10,0];
		publicVariable "BR_DT_PVAR";
		uiSleep 5;
		_x setDamage 1;
	};
} forEach _winners;

uiSleep 4;

[[_fogThread,_weatherThread],[]] spawn BRGH_fnc_serverReset;