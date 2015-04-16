//--- ARMA SERVER NEXUS HANDLING SCRIPT - Proof Of Concept By Ryan

/*
	This script handles map zoning for a multi-server nexus
	Basically if you wanted altis life and wanted to have
	100 players on each side of the map you could create
	a host server for when players connect and some game servers
	that handle the gameplay
*/

Zones = [
	// [[ Y MIN, HEIGHT, X MIN, WIDTH ], SERVER IP ]
	[[0,10000,0,5000],"192.168.1.1:2402"], 		//--- Left side of map
	[[0,10000,5000,5000],"192.168.1.1:2502"] 	//--- Right side of map
];	


OurZone = 1; //--- CHANGE THIS WITH THE CURRENT ZONE

//--- Calculate Zone Boundries
_zone = Zones select (OurZone - 1);
_bounds = _zone select 0;
_ip = _zone select 1;
_xLow = _bounds select 0;
_xHigh = _xLow + (_bounds select 1);

while{true} do {
	{
		_pos = getposatl _x;
		
		_playerID = owner _x;
		
		_xP = _pos select 0;
		
		//--- Check X Handling
		if(_xP < _xLow) then {
			//--- Player moved left of current zone
			if( (OurZone - 2) >= 0) then {
				_newZone = Zones select (OurZone - 2);
				_newIP = _newZone select 1;
				sendAUMessage[[_playerID],format["ConnectTo: %1",_newIP]];
			};
		} else {
			if(_xP > _xHigh) then {
				//--- Player moved right of current zone
				if ( count(Zones) < OurZone) then {
					_newZone = Zones select OurZone;
					_newIP = _newZOne select 1;
					sendAUMessage[[_playerID],format["ConnectTo: %1",_newIP]];
				};
			};
		};
	} forEach playableunits;
};
