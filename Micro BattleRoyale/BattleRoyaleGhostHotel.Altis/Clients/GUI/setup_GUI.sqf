/*
	File: setup_gui.sqf
	Description: Setup GUI variables in the UINAMESPACE
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/
with uinamespace do {
	CTRL_INGAME_HEADER = controlNull;
	CTRL_SPECTATOR_PLAYERLIST = []; 
	DATA_SPECTATOR_PLAYERNAMES = [];
	DATA_SPECTATOR_PLAYERDATA = [];
	CTRL_SPECTATOR_ISRUNNING = false;
	THREAD_SPECTATOR_START = scriptNull;
};