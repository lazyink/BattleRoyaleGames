/*
	File: fn_Preprocess
	Desc: Preprocess an in game string to remove comments
	Author: PUBR-Ryan
	Usage:
		_this select 0: Text to preprocess (string)
*/

_string = _this select 0;

_lines = [_string,toString [13,10]] call BIS_fnc_splitString;

_code = "";
_isCommenting = false;
{	
	_line = _x;
	_array = toArray _line;
	_checkType = 0;
	_check = false;
	_string = "";
	_letters = [];
	_removeLastChar = false;
	_exitLine = false;
	_stopRemoveLastChar = false;
	{
		_foundChar = false;
		if(_x == 47) then { 	
			if(_check) then {
				if(_checkType == 1) then {_isCommenting = false;_removeLastChar = true;};
				if(_checkType == 0 && !_isCommenting) then {_exitLine = true;_removeLastChar = true;};
				_check = false;
			} else {
				_checkType = 0;
				_check = true;
			};
			_foundChar = true;
		};
		if(_x == 42) then {
			if(_check) then {
				_isCommenting = true;
				_check = false;
				_removeLastChar = true;
			} else {
				_checkType = 1;
				_check = true;
			};
			_foundChar = true;
		};
		if(!_foundChar && _check) then {_check = false;};
		if (!_isCommenting && !_exitLine) then {
			_letters pushBack _x;
		};
		if(_removeLastChar && !_stopRemoveLastChar) then {
			_temp = [];
			for '_i' from 0 to ((count _letters) - 2) do {
				_temp pushBack (_letters select _i);
			};
			_letters = _temp;
			_removeLastChar = false;
		};
		if(_exitLine) then {_stopRemoveLastChar = true;};
	} forEach _array;
	_string = toString _letters;
	_code = _code + _string;
} forEach _lines;
_code;