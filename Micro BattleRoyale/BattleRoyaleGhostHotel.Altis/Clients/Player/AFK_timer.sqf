DIAG_LOG "AFK TIMER - IN TESTING - NOT IMPLEMENTED!";


_afkTime = 120;
_timeToNotify = 30;


while{true} do {
	_pos = getpos player;
	_dir = getdir player;
	_eyepos = eyepos player;
	uiSleep (_afkTime-_timeToNotify);
	_checkKick = false;
	if(str(_eyepos) == str(eyepos player) && str(_pos) == str(getposatl player) && _dir != _dir) then {
		_checkKick = true;
		hint format['You have %1 seconds before you are kicked for being AFK',_timeToNotify];
	};
	uiSleep _timeToNotify;
	if(str(_eyepos) == str(eyepos player) && str(_pos) == str(getposatl player) && _dir != _dir) exitWith {
		//--- USE BE TO KICK FROM SERVER
		player setVariable ["KICKMEAFK",true,true];
		hint format['You are being kicked for remaining AFK for %1 seconds;',_afkTime];
	};
};

endMission "FAIL";