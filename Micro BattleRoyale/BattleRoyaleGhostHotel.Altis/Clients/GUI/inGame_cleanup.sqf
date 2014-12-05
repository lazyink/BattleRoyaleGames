/*
	File: inGame_cleanup.sqf
	Description: Remove inGame UI
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/
with uinamespace do {
	ctrlDelete CTRL_INGAME_HEADER;
	CTRL_INGAME_HEADER = controlNull;
};