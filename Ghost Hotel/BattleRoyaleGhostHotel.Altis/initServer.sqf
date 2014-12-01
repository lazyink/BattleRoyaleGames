/*
	File: initServer.sqf
	Description: Server on-start initializtion
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/
call BRGH_fnc_serverSetup;
[] spawn BRGH_fnc_serverStart;