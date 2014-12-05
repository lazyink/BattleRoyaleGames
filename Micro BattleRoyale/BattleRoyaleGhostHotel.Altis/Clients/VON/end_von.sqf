/*
	File: kill_von.sqf
	Description: Stop VON display
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

Diag_LOG "<ENDVON>: REMOVING VON";
["VON_ESP","onEachFrame"] call BIS_fnc_removeStackedEventHandler;
VoN_Enabled = false;