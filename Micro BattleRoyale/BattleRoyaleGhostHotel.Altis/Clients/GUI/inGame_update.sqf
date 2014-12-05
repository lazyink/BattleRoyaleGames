/*
	File: inGame_update.sqf
	Description: update in game UI with custom message / number of players remaining
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/
if(count(_this) == 0) then {
	_getCount = {
		_objects = ((getMarkerPos "BRMini_SafeZone") nearObjects ["Man",1000]);
		_players = 0;
		{
			if(alive _x && isplayer _x) then {
				_players = _players + 1;
			};
		} forEach _objects;
		_players;
	};
	_count = call _getCount;
	_text = format["<t align='center' color='#FFFFFF'>%1 PLAYERS REMAINING</t>",_count];
	with uinamespace do {
		if(!isNull CTRL_INGAME_HEADER) then {
			CTRL_INGAME_HEADER ctrlSetStructuredText parseText _text;
		};
	};
	waitUntil{_count != (call _getCount);};
} else {
	with uinamespace do {
		if(!isNull CTRL_INGAME_HEADER) then {
			CTRL_INGAME_HEADER ctrlSetStructuredText parseText (_this select 0);
		};
	};
};