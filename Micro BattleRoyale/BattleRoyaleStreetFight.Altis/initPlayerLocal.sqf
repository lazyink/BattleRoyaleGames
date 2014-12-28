onPreloadFinished {
	systemchat 'Player setup';
	systemchat 'Player start';
};

[] spawn {

	if ( isMultiplayer || { getNumber ( missionConfigFile >> "briefing" ) != 1 } ) then {

		if ( isMultiplayer ) then {

			if ( getClientState == "BRIEFING READ" ) exitWith {};

			waitUntil { getClientState == "BRIEFING SHOWN" };

		};

		private "_idd";
		_idd = switch true do { 

			case ( !isMultiplayer ): { 37 };
			case ( isServer ): { 52 };
			case ( !isServer ): { 53 };

		};

		if ( !isNull findDisplay _idd ) then {

			ctrlActivate ( ( findDisplay _idd ) displayCtrl 107 );

		};


	};

	if ( isMultiplayer ) then {

		waitUntil { getClientState == "BRIEFING READ" };

	};

	waitUntil { !isNull findDisplay 12 }; 

	ctrlActivate ( ( findDisplay 12 ) displayCtrl 107 );

};