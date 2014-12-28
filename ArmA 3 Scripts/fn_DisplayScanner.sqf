/*
	File: fn_DisplayScanner
	Desc: Creates a dialog that shows all in game UI
	Author: PUBR-RYAN
	Usage: [] spawn TA_fnc_DisplayScanner;
*/

DS_Init = {
	if(isNull (findDisplay 3030)) then {
		disableserialization;
		createDialog "RscConfigEditor_Main";
		_display = findDisplay 3030;

		_ctrl = _display displayctrl -1;		
		_ctrl ctrlSetBackgroundColor [0,0,0,0];
		_ctrl ctrlCommit 0;

		_ctrl = _display displayctrl 1;
		_width = safezonew/4;
		_x = safezonex + _width-safezonew/150;
		_pos = ctrlposition _ctrl;
		_pos set[0,_x];
		_pos set[2,_width];
		_ctrl ctrlSetPosition _pos;
		for "_i" from 0 to (count configFile)-1 do {
			_cfg = configFile select _i;
			if(isClass _cfg) then {
				_name = configName _cfg;
				_cfg = configFile >> _name >> "controls";
				if(isClass _cfg) then {
					_ctrl lbAdd _name;
				};
			};
		};
		_ctrl ctrlAddEventHandler ["LBDblClick",{createDialog (lbText [1,(_this select 1)]);}];
		_ctrl ctrlAddEventHandler ["LBSelChanged",{(_this select 1) call DS_SELChanged;}];
		_ctrl ctrlCommit 0;

		_ctrl = _display displayctrl 2;
		_width = safezonew/4;
		_x = safezonex + (_width*2)+safezonew/150;
		_pos = ctrlposition _ctrl;
		_pos set[0,_x];
		_pos set[2,_width];
		_ctrl ctrlSetPosition _pos;
		_ctrl ctrlSetForegroundColor [0.4,0,0.4,0.7];
		lbClear _ctrl;
		_ctrl ctrlCommit 0;

		_ctrl = _display displayctrl 3;
		_ctrl ctrlSetPosition [safezonex,safezoney,safezonew,safezoneh/21];
		_ctrl ctrlSetBackgroundColor [0,0,0,1];
		_ctrl ctrlSetText "Display Scanner v1.0";
		_ctrl ctrlCommit 0;
	};
};
DS_SELChanged = {
	_text = lbText[1,_this];
	_cfg = configFile >> _text;
	if(isClass _cfg) then {
		lbClear 2;
		_displayID = getNumber(_cfg >> "idd");
		_moveable = getNumber(_cfg >> "movingEnable");
		_simulation = getNumber(_cfg >> "enableSimulation");
		_onLoad = getText(_cfg >> "onload");
		_onUnload = getText(_cfg >> "onunload");
		
		if(str(_displayID) != "") then {
			_IDD = format["IDD = %1",_displayID];
			lbAdd [2,_IDD];
		};
		if(str(_moveable) != "") then {
			_IDD = format["movingEnable = %1",_moveable];
			lbAdd [2,_IDD];
		};
		if(str(_simulation) != "") then {
			_IDD = format["enableSimulation = %1",_simulation];
			lbAdd [2,_IDD];
		};
		if(_onLoad != "") then {
			_IDD = format["onLoad = %1",_onLoad];
			lbAdd [2,_IDD];
		};
		if(_onUnload != "") then {
			_IDD = format["onUnload = %1",_onUnload];
			lbAdd [2,_IDD];
		};
		

		_controls = _cfg >> "Controls";
		lbAdd[2,""];
		lbAdd[2,"Controls:"];
		for "_i" from 0 to count(_controls)-1 do {
			
			_cfg = _controls select _i;
			if(isClass _cfg) then {
				_name = configName _cfg;
				lbAdd[2,format["-%1",_name]];
				_cfg = configFile >> _text >> "Controls" >> _name;
				_idc = getNumber(_cfg >> "idc");
				_type = getNumber(_cfg >> "type");
				_ctrlText = getText(_cfg >> "text");

				lbAdd[2,format["--IDC = %1",_idc]];
				lbAdd[2,format["--Type = %1",_type]];
				lbAdd[2,format["--Text = %1",_ctrlText]];
				lbAdd[2,""];
			};
		};

	};
};
[] spawn DS_Init;