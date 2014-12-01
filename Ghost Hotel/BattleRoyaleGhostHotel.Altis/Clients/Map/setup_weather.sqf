/*
	File: setup_weather.sqf
	Description: initialize client weather functions
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

BR_lightning = {

	_pos = _this;
	_bolt = "LightningBolt" createVehicleLocal _pos;
	_bolt setdamage 1;
	_light = "#lightpoint" createVehicleLocal _pos;
	_light setposatl [_pos select 0,_pos select 1,(_pos select 2) + 10];
	_light setLightDayLight true;
	_light setLightBrightness 300;
	_light setLightAmbient [0.05, 0.05, 0.1];
	_light setlightcolor [1, 1, 2];
	
	sleep 0.1;
	_light setLightBrightness 0;
	sleep (random 0.1);
	
	_class = ["lightning1_F","lightning2_F"] call bis_Fnc_selectrandom;
	_lightning = _class createVehicleLocal _pos;
	
	
	_duration = if (isnull cursortarget) then {(3 + random 1)} else {1};
	
	for "_i" from 0 to _duration do {
		_time = time + 0.1;
		_light setLightBrightness (100 + random 100);
		waituntil {
			time > _time
		};
	};
	
	deletevehicle _lightning;
	deletevehicle _light;
};