//--- Extended Event Handlers (EEH) By PUBR-RYAN



BR_fnc_initExtendedEventHandlers = {
	BR_var_EventHandlers = []; //--- Array storing event handlers
};
BR_fnc_addExtendedEventHandler = {
	_type = toLower(_this select 0);
	_target = _this select 1;
	_handlerCode = _this select 2;
	
	_index = BR_var_EventHandlers pushBack [_type,_target,_handlerCode];
	
	if(_index == 0) then {
		//--- First init of EventHandlers
		[] spawn BR_fnc_execEventHandlers;
	};
	
	
	_index;
};
BR_fnc_ExtenededEventHandler = {
	_type = _x select 0;
	_target = _x select 1;
	_code = _x select 2;
	if(_type == "playerentered") then {
	
		while{true} do {
			_crew = crew _target;
			waitUntil{count(_crew) != count(crew _target)};
			if(count(crew _target) > count(_crew) ) then {
				_newMembers = [];
				{
					if !(_x in _crew) then {
						_newMembers pushBack _x;
					};	
				} forEach (crew _target);
				
				_info = [];
				_crewInfo = fullCrew _target;
				{
					_obj = _x select 0;
					if (_obj in _newMembers) then {
						_info pushBack _x;
					};
				} forEach _crewInfo;
				
				_info spawn _code;
			};	
		};
		
	};
	if(_type == "playerleft") then {
	
		while{true} do {
			_crew = crew _target;
			waitUntil{count(_crew) != count(crew _target)};
			if(count(crew _target) < count(_crew) ) then {
				_leftMembers = [];
				{
					if !(_x in (crew _target)) then {
						_leftMembers pushBack _x;
					};	
				} forEach _crew;
				
				_leftMembers spawn _code;
			};	
		};
		
	};
	
};
BR_fnc_execEventHandlers = {
	_threads = [];
	{
		_thread = _x spawn BR_fnc_ExtenededEventHandler;
		_threads pushBack _thread;
	} forEach BR_var_EventHandlers;
	_oldEHs = +BR_var_EventHandlers;
	
	while{count(BR_var_EventHandlers) > 0} do {
		//--- While EventHandlers Exist
		_count = count(BR_var_EventHandlers);
		
		
		waitUntil{count(BR_var_EventHandlers) != _count};
		if(count(BR_var_EventHandlers)  < _count) then {
			_cleanupIf = false;
			if(count(BR_var_EventHandlers) == 0) then {BR_var_EventHandlers = [[]];_cleanupIf = true;};
			{
				_maxReached = false;
				while{true} do {		
					if(count(_oldEHs) == _forEachIndex) exitWith{_maxReached = true;};
					_oldEvent = str(_oldEHs select _forEachIndex);
					_newEvent = str(_x);
					_thread = _threads select _forEachIndex;
					
					if(_oldEvent == _newEvent) exitWith {};
					if(_oldEvent != _newEvent) then {
						_threads deleteAt _forEachIndex;
						_oldEHs deleteAt _forEachIndex;
						terminate _thread;
					};
				};
				if(_maxReached) exitWith {};
			} forEach BR_var_EventHandlers;
			
			if(_cleanupIf) then {BR_var_EventHandlers = [];};
			
			
		} else {
			//--- Initialize New Threads
			for "_i" from _count to count(BR_var_EventHandlers)-1 do {
				_event = BR_var_EventHandlers select _i;
				_threads pushBack (_event spawn BR_fnc_ExtenededEventHandler);
			};
		};
	};
};
BR_fnc_removeExtendedEventHandler = {
	_index = _this select 0;
	
	BR_var_EventHandlers deleteAt _index;
};
BR_fnc_removeAllExtendedEventHandlers = {
	_type = _this select 0;
	_target = _this select 1;
	
	_newArray = [];
	{
		_array = _x;
		_t = _array select 0;
		_ta = _array select 1;
		
		if(_t != _type || _ta != _target) then {
			_newArray pushBack _x;
		};
	} forEach BR_var_EventHandlers;
	BR_var_EventHandlers = _newArray;
};
