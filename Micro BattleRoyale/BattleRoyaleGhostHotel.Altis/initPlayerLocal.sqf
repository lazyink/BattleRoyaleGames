/*
	File: initPlayerLocal.sqf
	Description: Client On Join Initialiaztion
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/
onPreloadFinished {
	enableEnvironment false;
	TRUE_UID = getplayeruid player;
	call BRGH_fnc_clientSetup;
	[] spawn BRGH_fnc_clientStart;
	
};		

//--- Map Texture Fix

/* 
* @Author:  DnA
* @Profile: http://steamcommunity.com/id/dna_uk
* @Date:    2014-05-10 15:52:48
* @Last Modified by:   DnA
* @Last Modified time: 2014-05-11 03:17:48
* @Version: 0.1b
*/

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
