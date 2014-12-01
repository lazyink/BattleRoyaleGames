/*
	File: fn_simpleFog.sqf
	Description: Realistic Fog Simulation for BRGH
	Created By: PlayerUnknown & Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/
[] spawn {
	_initialHeight = 80;
	_fog = (random br_maxFogStrength) max 0.005;
    _density = (random br_maxFogDensity) max 0.005;  
	
	_minDelay = 60;
	_maxDelay = 120;
	
	_maxChange = 80;
	_minChange = 20;
	
	_maxHeight = 150;
	_minHeight = 0;
	
	_minTransition = 10;
	_maxTransition = 30;

	
	
	diag_log format["BR ROLLING FOG: fog strength: %1", _fog];
    diag_log format["BR ROLLING FOG: density: %1", _density]; 
	
	
	
	BR_SF_PVAR = [_fog,_density,_initialHeight,0];
	publicvariable "BR_SF_PVAR";
	
	_currentHeight = _initialHeight;
	
	while{true} do {
		if(!BRMini_ServerOn) exitWith {};
		_delay = _minDelay;
        _rdelay = floor (random(_maxDelay-_minDelay));        
        _timeToChange = serverTime + _delay + _rdelay;
		while{serverTime < _timeToChange} do {
			uiSleep 1;
			if(!BRMini_ServerOn) exitWith {};
		};
		
		if(!BRMini_ServerOn) exitWith {};
		
		_change = _minChange + floor(random(_maxChange-_minChange));
		_dir = if(floor(random(2)) == 1) then {1} else {-1};
		_change = _change * _dir;
		
		if( (_currentHeight + _change > _maxHeight) || (_currentHeight + _change < _minHeight) ) then {
			_change = _change * -1;
		};
		
		_currentHeight = _currentHeight + _change;
		
		(_minTransition + random(_maxTransition-_minTransition)) setFog [_fog,_density,_currentHeight]; //sync with clients plz oh plz
	};
	
};