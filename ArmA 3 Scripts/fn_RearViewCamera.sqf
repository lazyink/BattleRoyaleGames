/*
	File: fn_RearViewCamera
	Desc: Creates a rear-view camera for the player
	Author: PUBR-RYAN
	Usage: [] spawn TA_fnc_RearViewCamera;
*/

[] spawn {
	_SOURCE = (typeof player) createVehicleLocal (position player);
	_SOURCE hideObject true;
	[_SOURCE,player,player] call BIS_fnc_LiveFeed;
	vehicle player disableCollisionWith _SOURCE;
	while{true} do {
		detach _SOURCE;	
		if(vehicle player == player) then {
			_SOURCE attachTo [vehicle player,[0,2,3]];
		} else {
			_SOURCE attachTo [vehicle player,[0,5,5]];
		};
		_oldVeh = vehicle player;
		waitUntil{_oldVeh != vehicle player};
	};	
};