/*
	File: spectator_start.sqf
	Description: Start spectator UI
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

with uinamespace do {
	CTRL_SPECTATOR_ISRUNNING = true;

	_equals = {
		switch (_this select 0) do {
			case (_this select 1) : {true};
			default {false};
		};
	};

	_getInGamePlayers = {
		_objects = ((getMarkerPos "BRMini_SafeZone") nearObjects ["Man",1000]);
		_players = [];
		{
			if(alive _x && isplayer _x) then {
				_players set [count(_players),_x];
			};
		} forEach _objects;
		_players;
	};
	while{CTRL_SPECTATOR_ISRUNNING} do {
		_xOff = safezonew/600;
		_yOff = safezoneh/600;
		_xPos = safezonex + _xOff;
		_yPos = safezoney + _yOff;
		_w = safezonew/10;
		_h = safezoneh/20;
		_players = call _getInGamePlayers;
		
		//--- Delete controls that are no longer in use
		_newPlayerList = [];
		{
			if(_forEachIndex < count(_players)) then {
				_newPlayerList set[_forEachIndex,_x];
			} else {
				ctrlDelete _x;
			};
		} forEach CTRL_SPECTATOR_PLAYERLIST;
		CTRL_SPECTATOR_PLAYERLIST = _newPlayerList;
		
		
		{
			_ctrl = controlNull;
			_update = false;
			
			//--- Create Control If It Doesn't Exist / Get Control From Array
			if(_forEachIndex == count(CTRL_SPECTATOR_PLAYERLIST)) then {
				_ctrl = (findDisplay 46) ctrlCreate ["RscButtonMenu",-1];
				_update = true;
			} else {
				_ctrl = CTRL_SPECTATOR_PLAYERLIST select _forEachIndex;
				if(isNull _ctrl) then {
					_ctrl = (findDisplay 46) ctrlCreate ["RscButtonMenu",-1];
					_update = true;
				};
			};
			
			_name = name _x;
			_index = DATA_SPECTATOR_PLAYERNAMES find _name;
			if(_index == -1) then { //--- create data because it doesnt exist
				_index = count(DATA_SPECTATOR_PLAYERNAMES);
				DATA_SPECTATOR_PLAYERNAMES set[_index,_name];
				DATA_SPECTATOR_PLAYERDATA set[_index,[100,false,false]];
			};
			//--- gather data from arrays
			_data = DATA_SPECTATOR_PLAYERDATA select _index;
			_isHit = _x getVariable ["BRHit",false];
			_hasFired = _x getVariable ["BRFired",false];
			_health = ceil((damage _x) * 100);
			
			_dH = _data select 0;
			_dIH = _data select 1;
			_dHF = _data select 2;
			
			//--- handle player position in list changing
			if(!_update) then {
				_goodText = format["%1 - %2HP",_name,_health];
				_text = ctrlText _ctrl;
				if(_text != _goodText) then {
					_update = true;
				};
			};
			
			//--- update control
			if((![_isHit,_dIH] call _equals) || (![_hasFired,_dHF] call _equals) || (![_health,_dH] call _equals)  || _update) then {
				DATA_SPECTATOR_PLAYERDATA set [_index,[_health,_isHit,_hasFired]];
				_update = true;
				_yPos = _yPos + (_h*_forEachIndex) + (_yOff*_forEachIndex);
				
				_ctrl ctrlSetPosition [_xPos,_yPos,_w,_h];
				_ctrl ctrlSetBackgroundColor [0,0,0,0.4];
				_textColor = [250/255,250/255,250/255,1];
				if(_isHit) then {
					_textColor = [215/255,127/255,39/255,1];
				};
				if(_hasFired) then {
					_textColor = [1,0,0,1];
				};
				_ctrl ctrlSetTextColor _textColor;
				_ctrl ctrlSetText format["%1 - %2HP",_name,_health];
				_ctrl ctrlCommit 0;
			};
			
			if(_update) then {
				CTRL_SPECTATOR_PLAYERLIST set[_forEachIndex,_ctrl]; //--- update control in list
			};
		} foreach _players;
		uiSleep 1; //--- delay execution for one second 
	};
};