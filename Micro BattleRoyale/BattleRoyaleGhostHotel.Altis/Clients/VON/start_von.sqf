/*
	File: start_von.sqf
	Description: Realistic Weather Simulation for BRGH
	Created By: Lystic -> inputAction EventHandler + Stability Update
	Credits: KILLZONEKID -> Idea and Functions
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/


diag_log "<VON>: DEFINE FUNCTIONS";
VoN_ChannelId_fnc = {
	switch _this do {
		case localize "str_channel_global" : {["str_channel_global",0]};
		case localize "str_channel_side" : {["str_channel_side",1]};
		case localize "str_channel_command" : {["str_channel_command",2]};
		case localize "str_channel_group" : {["str_channel_group",3]};
		case localize "str_channel_vehicle" : {["str_channel_vehicle",4]};
		case localize "str_channel_direct" : {["str_channel_direct",5]};
		default {["",-1]};
	};
};
VoN_Event_fnc = {
	VoN_currentTxt = _this;
	VoN_channelId = VoN_currentTxt call VoN_ChannelId_fnc;
	_chID = VoN_channelId select 1;
	if(_chID == 5) then {
		diag_log "speaking";
		player setVariable ["Speaking",true,true];
	};
	if(_chID < 0) then {
		diag_log "not";
		player setVariable ["Speaking",false,true];
	};
};
VoN_Enabled = true;
diag_log "<VON>: ADD KEYBINDS";
0 = [] spawn {
	VoN_isOn = false;
	VoN_currentTxt = "";
	VoN_channelId = -1;
	while{VoN_Enabled} do {
		waitUntil{inputAction "pushToTalk" > 0 || !VoN_Enabled};
		if(!VoN_Enabled) exitWith {};
		uiSleep 0.001;
		if (!isNull findDisplay 55 && !isNull findDisplay 63) then {
			if (!VoN_isOn) then {
				VoN_isOn = true;
				ctrlText (findDisplay 63 displayCtrl 101)
				call VoN_Event_fnc;
				findDisplay 55 displayAddEventHandler ["Unload", {
					VoN_isOn = false;
					"" call VoN_Event_fnc;
				}]; 
			};
		};
		waitUntil{inputAction "pushToTalk" == 0  || !VoN_Enabled};
		if(!VoN_Enabled) exitWith {};
		uiSleep 0.001;
		if (VoN_isOn) then {
			_ctrlText = ctrlText (findDisplay 63 displayCtrl 101);
			if (VoN_currentTxt != _ctrlText) then {
				_ctrlText call VoN_Event_fnc;
			};
		};
	};
};
diag_log "<VON>: START ONEACHFRAME";
["VON_ESP", "onEachFrame", {
	{
		if(_x getVariable ["Speaking",false]) then {
			_pos = getposatl _x;
			_eyepos = ASLtoATL eyepos _x;
			_3 = _x modelToWorld [-0.5,0,0];
			_3 set [2,(_eyepos select 2) + 0.25];
			_fontsize = 0.03;
			_eyepos set [2,(_3 select 2) + 0.15];
			drawIcon3D["",[1,1,1,1],_eyepos,0.1,0.1,45,format["%1",name _x],1,_fontsize,'EtelkaNarrowMediumPro'];
		};
	} forEach playableUnits;
}] call BIS_fnc_addStackedEventHandler;