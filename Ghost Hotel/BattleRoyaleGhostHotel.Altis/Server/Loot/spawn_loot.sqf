/*
	
*/

//all loot objects attach to masterObject so their positioning is correct 100% of the time
_masterObject = "Sign_Sphere10cm_F" createVehicle [0,0,0];
_masterObject enableSimulationGlobal false;
_masterObject setdir 0;
_masterObject setposatl [0,0,0];

LOOT_OBJECTS = [];

/*
_offsetFix = 0;
if(BRMini_GamesPlayed == 1) then {
	 _offsetFix = 0.65;
};
*/
 _offsetFix = 0.65;

_time = time;
{
	_obj = createVehicle ["groundWeaponHolder", [0,0,0], [], 0, "CAN_COLLIDE"];
	LOOT_OBJECTS set [count(LOOT_OBJECTS),_obj];
	_pos = _x;
	_z = _pos select 2;
	_z = _z + _offsetFix;
	_pos set[2,_z];
	_obj attachTo [_masterObject,_x]; //sets position
	detach _obj;
	for "_i" from 1 to (2 max floor(random(5))) do {
		_usedTypes = [];
		while{true} do {
			_loot = BRMini_Loot select floor(random(count(BRMini_Loot)));
			_lootName = _loot select 0;
			_lootType = _loot select 1;
			_lootChance = _loot select 2;
			_lootAmount = _loot select 3;
			if(_lootChance == 1) then {_lootChance = floor(random(2));} else { //50%
				if(_lootChance == 2) then {_lootChance = floor(random(4));} else { //25%
					if(_lootChance == 3) then {_lootChance = floor(random(8));}; //12.5%
				};
			};
			if(_lootChance == 0 && !(_lootType in _usedTypes)) exitWith {
				_usedTypes set [count(_usedTypes),_lootType];
				switch(_lootType) do {
					case 0: {_obj addMagazineCargoGlobal[_lootName,_lootAmount];};
					case 1: {
						_obj addWeaponCargoGlobal[_lootName,_lootAmount];
						_arr = getArray(configFile >> "cfgWeapons" >> _lootName >> "Magazines");
						_magType = _arr select floor(random(count(_arr)));
						_obj addMagazineCargoGlobal[_magType,3];
					};
					case 2: {_obj addItemCargoGlobal[_lootName,_lootAmount];};
					case 3: {_obj addBackpackCargoGlobal[_lootName,_lootAmount];};
				};
			};
		};
	};
} forEach BRMini_Loot_Offsets;

diag_log ("Spawned loot in " + str(time-_time) + " seconds");
hint ("Spawned loot in " + str(time-_time) + " seconds");

deleteVehicle _masterObject; //cleanup masterobject