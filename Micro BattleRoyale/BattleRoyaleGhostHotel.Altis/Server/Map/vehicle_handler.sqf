/*
	File: vehicle_handler.sqf
	Description: Vehicle handler for BRGH -- This will delete all vehicles and log vehicles created by clients
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/
[] spawn {
	while{true} do {
		{
			if !(local _x) then {_id = owner _x;{if(owner _x == _id) exitWith {diag_log format["<VEHICLE MONITOR>: POSSIBLE VEHICLE SPAWNED BY %1('%2')",name _x,getplayeruid _x];};} forEach playableUnits;};
			deleteVehicle _x;
		} forEach vehicles;
	};
};