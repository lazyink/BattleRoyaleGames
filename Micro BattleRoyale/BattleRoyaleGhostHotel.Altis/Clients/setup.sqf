/*
	File: setup.sqf
	Description: Client one-time Setup
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

diag_log "<START>: ONE TIME SETUP STARTED";
BRMINI_ZoneObjects = [];

call BRGH_fnc_setupGUI;
call BRGH_fnc_createInGameGUI;

call BRGH_fnc_clientWeather;

[] spawn BRGH_fnc_afkTimer;

enableRadio false;
enableSentences false;
showSubtitles false;
0 fadeRadio 0;
setObjectViewDistance [1000,0];
setViewDistance 1500;


[] spawn {
	while{true} do {
		_units = units (group player);
		setGroupIconsVisible [false,false];
		if(count _units > 1) then {
			_grp = group player;
			[player] joinSilent (creategroup (side player));
			deletegroup _grp;
		};
	};
};

[] spawn {
	waituntil{!isNil 'BR_DRAWBLACKZONE'};
	_data = BR_DRAWBLACKZONE;
	{
		_type = _x select 0;
		_position = _x select 1;
		_dir = _x select 2;
		_texture = _x select 3;
		
		_obj = _type createVehicleLocal _position;
		_obj setDir _dir;
		_obj setPosATL _position;
		_obj setObjectTexture [0,_texture];
		_obj enableSimulation false;
	} forEach _data;
};

"BR_LS_PVAR" addPublicVariableEventHandler {
	(_this select 1) spawn BR_lightning;
};

"BR_DRAWZONE" addPublicVariableEventHandler {
	_this spawn {
		_old = BRMINI_ZoneObjects;
		BRMINI_ZoneObjects = [];
		_data = _this select 1;
		_textures = [];
		{
			_type = _x select 0;
			_position = _x select 1;
			_dir = _x select 2;
			_texture = _x select 3;
			_obj = _type createVehicleLocal _position;
			_obj setDir _dir;
			_obj setPosATL _position;
			_obj enableSimulation false;
			_textures set [count(_textures),_texture];
			BRMINI_ZoneObjects set [count(BRMINI_ZoneObjects),_obj];
		} forEach _data;
		{	
			_x setObjectTexture[0,_textures select _forEachIndex];
		} forEach BRMINI_ZoneObjects;
		{
			deleteVehicle _x;
		} forEach _old;
	};
};

"BR_ServerRainValue" addPublicVariableEventHandler {
	10 setRain ((_this select 1) select 0);
	10 setGusts ((_this select 1) select 0);
};

"BR_SF_PVAR" addPublicVariableEventHandler {
	(_this select 1) spawn BRGH_fnc_clientFog;
};

"BR_DT_PVAR" addPublicVariableEventHandler {
	(_this select 1) spawn BIS_fnc_dynamicText;
};