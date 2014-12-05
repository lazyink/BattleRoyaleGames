/*
	File: start_zoning.sqf
	Description: BRGH Blue and Black Zoning System
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

_minutes = 21;
_zoneChange = 7;
_changeTime = ceil(_minutes / _zoneChange);

_zoneCenter = (getMarkerPos "BRMini_SafeZone");
_zoneSize = 280;
_nextZoneCenter = [0,0,0];
	
_zoneSizeScaling = 35;

if(_zoneSizeScaling >= 1) then {
	_zoneSizeScaling = _zoneSizeScaling / 100; 
};
_timeTillChange = _changeTime;
for "_i" from 1 to _minutes do {
	_timeTillChange = _timeTillChange - 1;
	_time = time + 60;
	_nextTime = time+20;
	_total = [];
	{if(isPlayer _x && alive _x) then {_total set [count(_total),_x];};} forEach (_zoneCenter nearObjects ["Man",1000]);
	_inside = [];
	{if(isPlayer _x && alive _x) then {_inside set [count(_inside),_x];};} forEach (_zoneCenter nearObjects ["Man",_zoneSize]);
	_outside = _total - _inside;
	BR_DT_PVAR = ["YOU ARE OUTSIDE THE PLAY AREA! GET INSIDE NOW!",0,0.7,10,0];
	{(owner _x) publicVariableClient "BR_DT_PVAR";} forEach _outside;
	while{true} do {
		if(time >= _time) exitWith {};
		if(!BRMini_InGame) exitWith {};
		if(time >= _nextTime) then {
			_total = [];
			{if(isPlayer _x && alive _x) then {_total set [count(_total),_x];};} forEach (_zoneCenter nearObjects ["Man",1000]);
			_inside = [];
			{if(isPlayer _x && alive _x) then {_inside set [count(_inside),_x];};} forEach (_zoneCenter nearObjects ["Man",_zoneSize]);
			_outside = _total - _inside;
			_nextTime = time + 20;
			{_x setDamage (damage _x + (1/6));_x setVariable ["outside",true,false];} forEach _outside;
			{if(_x getVariable ["outside",false]) then {BR_DT_PVAR = ["YOU ARE BACK INSIDE THE PLAY AREA!",0,0.7,10,0];(owner _x) publicVariableClient "BR_DT_PVAR";_x setVariable ["outside",false];};} forEach _inside;
			BR_DT_PVAR = ["YOU ARE STILL OUTSIDE THE PLAY AREA! GET INSIDE NOW!",0,0.7,10,0];
			{(owner _x) publicVariableClient "BR_DT_PVAR";} forEach _outside;
		};
	};
	
	if(!BRMini_InGame) exitWith {};
	
	_isZoneChange = _timeTillChange == 0;
	if(_i <= _changeTime) then {
		if(_isZoneChange) then {
			_zoneCenter = _nextZoneCenter;
			_zoneSize = _zoneSize - (_zoneSize*_zoneSizeScaling);
			_blue = createMarker ["Blue_Zone",_zoneCenter];
			"Blue_Zone" setMarkerColor "ColorBlue";
			"Blue_Zone" setMarkerShape "ELLIPSE";
			"Blue_Zone" setMarkerBrush "BORDER";
			"Blue_Zone" setMarkerSize [_zoneSize,_zoneSize];
			deleteMarker "Temp_Zone";
			BRMini_ZoneStarted = true;
			publicVariable "BRMini_ZoneStarted";
			BR_DT_PVAR = ["PLAY IS NOW RESTRICTED TO THE AREA INSIDE THE BLUE ZONE!",0,0.7,10,0];
			publicVariable "BR_DT_PVAR";
		} else {
			_doUpdateMap = _timeTillChange == 1;
			if(_doUpdateMap) then {
				_scaleChange = (_zoneSize*_zoneSizeScaling);
				_tempSize = _zoneSize - _scaleChange;
				_nextZoneCenter = [(_zoneCenter select 0) + floor(random(_scaleChange*2)-(_scaleChange)),(_zoneCenter select 1) + floor(random(_scaleChange*2)-(_scaleChange)),0];
				_temp = createMarker ["Temp_Zone",_nextZoneCenter];
				"Temp_Zone" setMarkerColor "ColorBlue";
				"Temp_Zone" setMarkerShape "ELLIPSE";
				"Temp_Zone" setMarkerBrush "BORDER";
				"Temp_Zone" setMarkerSize [_tempSize,_tempSize];
				//draw new zones
				_steps = floor ((2 * pi * _tempSize) / 15);
				_radStep = 360 / _steps;
				_data = [];
				for [{_j = 0}, {_j < 360}, {_j = _j + _radStep}] do {
					_pos2 = [_nextZoneCenter, _tempSize, _j] call BIS_fnc_relPos;
					_pos2 set [2, 0];
					_data set[count(_data),["UserTexture10m_F",_pos2,_j,"#(argb,8,8,3)color(0,0,1,0.4)"]];
					_data set[count(_data),["UserTexture10m_F",_pos2,(_j + 180),"#(argb,8,8,3)color(0,0,1,0.4)"]];
				};
				BR_DRAWZONE = _data;
				publicVariable "BR_DRAWZONE";
				BR_DT_PVAR = ["YOUR MAP HAS BEEN UPDATED WITH THE BLUE ZONE!",0,0.7,10,0];
				publicVariable "BR_DT_PVAR";
			} else {
				BR_DT_PVAR = [format["IN %1 MINUTES THE PLAY AREA WILL BE RESTRICTED TO THE AREA INSIDE THE BLUE ZONE",_timeTillChange],0,0.7,5,0];
				publicVariable "BR_DT_PVAR";
			};
		};
	} else {
		if(_i <= (_minutes-_changeTime)) then {
			if(_isZoneChange) then {
				_zoneCenter = _nextZoneCenter;
				_zoneSize = _zoneSize - (_zoneSize*_zoneSizeScaling);
				"Blue_Zone" setMarkerPos _zoneCenter;
				"Blue_Zone" setMarkerSize [_zoneSize,_zoneSize];
				"Blue_Zone" setMarkerAlpha 1;
				deleteMarker "Temp_Zone";
				BR_DT_PVAR = ["PLAY IS NOW RESTRICTED TO THE AREA INSIDE THE BLUE ZONE!",0,0.7,10,0];
				publicVariable "BR_DT_PVAR";
			} else {
				_doUpdateMap = _timeTillChange == 1;
				if(_doUpdateMap) then {
					_scaleChange = (_zoneSize*_zoneSizeScaling);
					_tempSize = _zoneSize - _scaleChange;
					_nextZoneCenter = [(_zoneCenter select 0) + floor(random(_scaleChange*2)-(_scaleChange)),(_zoneCenter select 1) + floor(random(_scaleChange*2)-(_scaleChange)),0];
					_temp = createMarker ["Temp_Zone",_nextZoneCenter];
					"Temp_Zone" setMarkerColor "ColorBlue";
					"Temp_Zone" setMarkerShape "ELLIPSE";
					"Temp_Zone" setMarkerBrush "BORDER";
					"Temp_Zone" setMarkerSize [_tempSize,_tempSize];
					"Blue_Zone" setMarkerAlpha 0;	
					_steps = floor ((2 * pi * _tempSize) / 15);
					_radStep = 360 / _steps;
					_data = [];
					for [{_j = 0}, {_j < 360}, {_j = _j + _radStep}] do {
						_pos2 = [_nextZoneCenter, _tempSize, _j] call BIS_fnc_relPos;
						_pos2 set [2, 0];
						_data set[count(_data),["UserTexture10m_F",_pos2,_j,"#(argb,8,8,3)color(0,0,1,0.4)"]];
						_data set[count(_data),["UserTexture10m_F",_pos2,(_j + 180),"#(argb,8,8,3)color(0,0,1,0.4)"]];
					};
					BR_DRAWZONE = _data;
					publicVariable "BR_DRAWZONE";
					BR_DT_PVAR = ["YOUR MAP HAS BEEN UPDATED!",0,0.7,10,0];
					publicVariable "BR_DT_PVAR";
				} else {
					BR_DT_PVAR = [format["IN %1 MINUTES, THE BLUE ZONE WILL SHRINK AGAIN!",_timeTillChange],0,0.7,10,0];
					publicVariable "BR_DT_PVAR";
				};
			};
		} else {
			if(_i < (_minutes-1)) then {
				BR_DT_PVAR = [format["THERE IS %1 MINUTES LEFT IN THE ROUND!",_changeTime - _timeTillChange],0,0.7,10,0];
				publicVariable "BR_DT_PVAR";
			} else {
				if(_i != _minutes) then {
					BR_DT_PVAR = ["THERE IS 1 MINUTE LEFT IN THE ROUND!",0,0.7,10,0];
					publicVariable "BR_DT_PVAR";
				};
			};
		};
	};
	if(_isZoneChange) then {_timeTillChange = _changeTime;};

};
BRMini_InGame = false;
diag_log "<BRMINI>: ROUND ENDED!";
deleteMarker "Blue_Zone";
deleteMarker "Temp_Zone";