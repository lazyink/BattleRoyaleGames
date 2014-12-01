DIAG_LOG "AFK TIMER NOT IMPLEMENTED!";
/*
_timeTillKick = 30;
_timeNotify = 10;

KICKME = false;
AFKTHREAD = [] spawn {}; //null thread
(findDisplay 46) displayAddEventHandler ["KeyDown",{if(!KICKME) then {KICKME = true;};}];
(findDisplay 46) displayAddEventHandler ["KeyUp",{if(KICKME && (scriptDone AFKTHREAD)) then {AFKTHREAD = [] spawn {uiSleep 1;KICKME = false;};};}];
(findDisplay 46) displayAddEventHandler ["MouseMoving",{if(!KICKME) then {KICKME = true;};}];
(findDisplay 46) displayAddEventHandler ["MouseHolding",{if(KICKME && (scriptDone AFKTHREAD)) then {AFKTHREAD = [] spawn {uiSleep 1;KICKME = false;};};}];


_time = time + _timeTillKick;
_notify = _time - _timeNotify;
_wasNotified = false;
while{true} do {
	waitUntil{(time >= _time || (!_wasNotified && (time >= _notify)) ||  KICKME)};
	if(time >= _notify && !_wasNotified) then {_wasNotified = true;[format["YOU WILL BE KICKED FOR BEING AFK IN %1 SECONDS!",_timeNotify],0,0.7,10,0] call BIS_fnc_dynamicText;};
	if(time >= _time) exitWith {player setVariable ["KICKMEAFK",true,true];};
	if(KICKME) then {waitUntil{!KICKME};_time = time + _timeTillKick;_notify = _time - _timeNotify;_wasNotified = false;};
};
*/