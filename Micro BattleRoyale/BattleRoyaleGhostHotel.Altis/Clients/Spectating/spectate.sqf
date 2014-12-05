//--- Classic camera script, enhanced by Karel Moricky, edited by lazyink and lystic for Battle Royale


//Configurations
BR_CamEnableThermal = true; //allow the use of thermal mode
BR_CamThermalModes = [0,1]; //thermal visions to toggle between (listed on wiki)
BR_CamEnableNightVision = true; //allow the use of nightvision
//End Configuration

if (!isNil "BIS_DEBUG_CAM") exitwith {};

//--- Is FLIR available
if (isnil "BIS_DEBUG_CAM_ISFLIR") then {
	BIS_DEBUG_CAM_ISFLIR = isclass (configfile >> "cfgpatches" >> "A3_Data_F");
};

{player reveal [_x,4];} foreach allunits;

BIS_DEBUG_CAM_MAP = false;
BR_MAPDRAW = -1;
BIS_DEBUG_CAM_VISION = 0;
BIS_DEBUG_CAM_FOCUS = 0;
BIS_DEBUG_CAM_COLOR = ppEffectCreate ["colorCorrections", 1600];
if (isnil "BIS_DEBUG_CAM_PPEFFECTS") then {
	BIS_DEBUG_CAM_PPEFFECTS = [
		[1, 1, -0.01, [1.0, 0.6, 0.0, 0.005], [1.0, 0.96, 0.66, 0.55], [0.95, 0.95, 0.95, 0.0]],
		[1, 1.02, -0.005, [0.0, 0.0, 0.0, 0.0], [1, 0.8, 0.6, 0.65],  [0.199, 0.587, 0.114, 0.0]],
		[1, 1.15, 0, [0.0, 0.0, 0.0, 0.0], [0.5, 0.8, 1, 0.5],  [0.199, 0.587, 0.114, 0.0]],
		[1, 1.06, -0.01, [0.0, 0.0, 0.0, 0.0], [0.44, 0.26, 0.078, 0],  [0.199, 0.587, 0.114, 0.0]]
	];
};

br_fnc_spectator = {
	//By lystic & lazyink & infistar
	_show = _this select 0;
	_doWork = _this select 1;
		
	player addWeapon "ItemGPS";
	br_fnc_MapIcons = {

		disableSerialization;
		_map = (findDisplay 12) displayCtrl 51;
		
		if (isnil "fnc_MapIcons_run") then
		{
			
			fnc_MapIcons_run = true;
			
			_map ctrlSetEventHandler ["Draw", "_this call br_fnc_mapIconsDraw;"];

		} 
		else 
		{
			fnc_MapIcons_run = nil;
			_map ctrlSetEventHandler ["Draw", ""];
		};
		br_fnc_mapIconsDraw = {
			private["_ctrl"];
			_ctrl =  _this select 0;
			_iscale = (1 - ctrlMapScale _ctrl) max .2;
			_irad = 27;
			_color = [0, 0, 0, 1];

			_getNearPlayers = {
				_range = _this select 0;
				_objects = [];
				{
					if((player distance _x) <= _range) then {
						_objects set [count(_objects),_x];
					};
				} forEach playableUnits;
				_objects;
			};

			_allvehicles = [];
			if (!visibleMap) then {
				_allvehicles = [150] call _getNearPlayers;
			} else {
				_allvehicles = [1000000] call _getNearPlayers;
			};

			{
				if (!isNull _x) then
				{
					_type = typeOf _x;
					_iconp = gettext (configfile >> "cfgmarkers" >> "mil_start" >> "icon");
					if (((_x isKindOf "Man") && (str(side _x) != "CIV")) && (getPlayerUID _x != "")) then
					{
						if (_x == player) then {_color = [0, 0, 1, 0.8];} else {_color = [0, 0, 0, 0.8];};
						if (_x getVariable ["BRHit",false]) then {_color = [1,0.35,0.15,0.8];}; //taking damage
						if (_x getVariable ["BRFired",false]) then {_color = [1,0,0,0.8];}; //shooting
						_ctrl drawIcon [_iconp, _color, getPosASL _x, _iscale*30, _iscale*30, getDir _x, name _x, 1];
					};
				};
			} forEach _allvehicles;
		};
	};
	br_esp_toggle = _doWork;
	if(br_esp_toggle) then {
			call br_fnc_MapIcons;
			oneachframe {
				disableSerialization;
				LayerID = 2732;
				{	
					LayerID = LayerID + 1;
					LayerID cutText ["","PLAIN"]; //clear the layer
					if(alive _x && (str(side _x) != "CIV")) then {

						br_fireTrigger = _x getVariable ["BRFired",false];
						br_inCombat = _x getVariable ["BRHit",false];

						LayerID cutRsc ["rscDynamicText", "PLAIN"];
						_ctrl = ((uiNamespace getvariable "BIS_dynamicText") displayctrl 9999);
						_screenDiff = safezoneW / 2;
						
						// Get the players weapon. todo mags
						_pweapon = primaryWeapon _x;
						_sweapon = handgunweapon _x;
						_cfgPWeapon = configfile >> "CfgWeapons" >> _pweapon;
						_cfgSWeapon = configfile >> "CfgWeapons" >> _sweapon;
						_pName = gettext (_cfgPWeapon >> "displayname");							
						_sName = gettext (_cfgSWeapon >> "displayname");
						if(format["%1 ",_pName] == " ") then {_pName = "-"};
						if(format["%1 ",_sName] == " ") then {_sName = "-"};
						
						_info = magazinesAmmoFull _x;
						_primaryWeaponMagCount = 0;
						_primaryWeaponCurrentAmmo = 0;
						_handgunWeaponMagCount = 0;
						_handgunWeaponCurrentAmmo = 0;

						_hgunMags = getArray(_cfgSWeapon >> "Magazines");
						_pgunMags = getArray(_cfgPWeapon >> "Magazines");
						{
							_mag = _x select 0;
							_ammoCount = _x select 1;
							_isLoaded = _x select 2;
							_holder = _x select 4;
							if(_mag in _hgunMags) then {
								_handgunWeaponMagCount = _handgunWeaponMagCount + 1;
							};
							if(_mag in _pgunMags) then {
								_primaryWeaponMagCount = _primaryWeaponMagCount + 1;
								
							};
							if(_isLoaded) then {
								if(_holder == _pweapon) then {
									_primaryWeaponCurrentAmmo = _ammoCount;
								};
								if(_holder == _sweapon) then {
									_handgunWeaponCurrentAmmo = _ammoCount;
								};	
							};
						} forEach _info;
						

						_handgunWeaponMagCount = (_handgunWeaponMagCount - 1) max 0;
						_primaryWeaponMagCount = (_primaryWeaponMagCount - 1) max 0;
						_HP = (100 - floor((damage _x) * 100));
						// Map Marker for player
						_playername = name _x;
						_playerpos = getPos _x;
						_veh = vehicle _x;
						_cpos = (positionCameraToWorld [0,0,0]);
						_posU = getPos _x;
						_dist = round(_cpos distance _posU);
						_posU2 = [(getPosATL _veh) select 0, (getPosATL _veh) select 1, ((getPosATL _veh) select 2) + (((boundingBox _veh) select 1) select 2) + 1.8];
						_pos2D = worldToScreen _posU2;
						_pos = getposatl _x; //get player pos
						_eyepos = ASLtoATL eyepos _x; //get eye pos
						if((getTerrainHeightASL [_pos select 0,_pos select 1]) < 0) then { //correct position when above water
							_eyepos = eyepos _x;
							_pos = getposasl _x;
						};
						//get coordinates for teh arrow
						_1 = _x modelToWorld [-0.03,0,0];
						_2 = _x modelToWorld [0.03,0,0];
						_3 = _x modelToWorld [-0.045,0,0];
						_4 = _x modelToWorld [0.045,0,0];
						_5 = _x modelToWorld [-0.06,0,0];
						_6 = _x modelToWorld [0.06,0,0];
						_7 = _x modelToWorld [-0.075,0,0];
						_8 = _x modelToWorld [0.075,0,0];
						_9 = _x modelToWorld [-0.09,0,0];
						_10 = _x modelToWorld [0.09,0,0];
						_11 = _x modelToWorld [-0.105,0,0];
						_12 = _x modelToWorld [0.105,0,0];
						_13 = _x modelToWorld [-0.12,0,0];
						_14 = _x modelToWorld [0.12,0,0];
						//fix coordinates 
						_1 set [2,(_eyepos select 2)+1.24];
						_2 set [2,(_eyepos select 2)+1.24];
						_3 set [2,(_eyepos select 2)+1.26];
						_4 set [2,(_eyepos select 2)+1.26];
						_5 set [2,(_eyepos select 2)+1.28];
						_6 set [2,(_eyepos select 2)+1.28];
						_7 set [2,(_eyepos select 2)+1.30];
						_8 set [2,(_eyepos select 2)+1.30];
						_9 set [2,(_eyepos select 2)+1.32];
						_10 set [2,(_eyepos select 2)+1.32];
						_11 set [2,(_eyepos select 2)+1.34];
						_12 set [2,(_eyepos select 2)+1.34];
						_13 set [2,(_eyepos select 2)+1.36];
						_14 set [2,(_eyepos select 2)+1.36];
						
						
						
						if (count _pos2D > 0 &&  !visibleMap) then {
							
							if (_dist <= 100) then {_ctrl ctrlSetFade 0;};
							if (_dist > 250) then {_ctrl ctrlSetFade 0.2;};
							if (_dist > 500) then {_ctrl ctrlSetFade 0.4;};
							if (_dist > 1000) then {_ctrl ctrlSetFade 0.6;};
							if (_dist > 1500) then {_ctrl ctrlSetFade 1;};
							_Tsize = 0.35;

							//draw bounding box
							if (!br_fireTrigger && !br_inCombat) then {
								drawLine3D[_2,_1,[1,1,1,0.8]];
								drawLine3D[_4,_3,[1,1,1,0.8]];
								drawLine3D[_6,_5,[1,1,1,0.8]];
								drawLine3D[_8,_7,[1,1,1,0.8]];
								drawLine3D[_10,_9,[1,1,1,0.8]];
								drawLine3D[_12,_11,[1,1,1,0.8]];
								drawLine3D[_14,_13,[1,1,1,0.8]];
								_text = format ["<t size='%3'font='EtelkaMonospacePro'color='#fafafa'>%1</t><br /><t size='%3'font='EtelkaMonospacePro'color='#dddddd'>%2 M : %4 HP</t><br />",name _x,round _dist,_Tsize,_HP];
								if(BR_SpectatorMode == 1) then {
									_text = format["%8<t size='%1'font='EtelkaMonospacePro'color='#d5d5d5'>%2 [%3-%4]</t><br /><t size='%1'font='EtelkaMonospacePro'color='#d5d5d5'>%5 [%6-%7]</t><br />",_Tsize,_pName,_primaryWeaponCurrentAmmo,_primaryWeaponMagCount,_sName,_handgunWeaponCurrentAmmo,_handgunWeaponMagCount,_text];
									hintSilent parseText _text;
								};
								_ctrl ctrlShow true;_ctrl ctrlEnable true;
								_ctrl ctrlSetStructuredText parseText _text;
								_ctrl ctrlSetPosition [(_pos2D select 0) - _screenDiff, (_pos2D select 1), safezoneW, safezoneH];
								_ctrl ctrlCommit 0;
							};
							if (br_inCombat) then {
								drawLine3D[_2,_1,[1,0.35,0.15,0.8]];
								drawLine3D[_4,_3,[1,0.35,0.15,0.8]];
								drawLine3D[_6,_5,[1,0.35,0.15,0.8]];
								drawLine3D[_8,_7,[1,0.35,0.15,0.8]];
								drawLine3D[_10,_9,[1,0.35,0.15,0.8]];
								drawLine3D[_12,_11,[1,0.35,0.15,0.8]];
								drawLine3D[_14,_13,[1,0.35,0.15,0.8]];
								_text = format ["<t size='%3'font='EtelkaMonospacePro'color='#d77f27'>%1</t><br /><t size='%3'font='EtelkaMonospacePro'color='#d77f27'>%2 M : %4 HP</t><br />",name _x,round _dist,_Tsize,_HP];
								if(BR_SpectatorMode == 1) then {
									_text = format["%8<t size='%1'font='EtelkaMonospacePro'color='#d77f27'>%2 [%3-%4]</t><br /><t size='%1'font='EtelkaMonospacePro'color='#d77f27'>%5 [%6-%7]</t><br />",_Tsize,_pName,_primaryWeaponCurrentAmmo,_primaryWeaponMagCount,_sName,_handgunWeaponCurrentAmmo,_handgunWeaponMagCount,_text];
									hintSilent parseText _text;
								};
								_ctrl ctrlShow true;_ctrl ctrlEnable true;
								_ctrl ctrlSetStructuredText parseText _text;
								_ctrl ctrlSetPosition [(_pos2D select 0) - _screenDiff, (_pos2D select 1), safezoneW, safezoneH];
								_ctrl ctrlCommit 0;
							};
							if (br_fireTrigger) then {
								drawLine3D[_2,_1,[1,0,0,0.8]];
								drawLine3D[_4,_3,[1,0,0,0.8]];
								drawLine3D[_6,_5,[1,0,0,0.8]];
								drawLine3D[_8,_7,[1,0,0,0.8]];
								drawLine3D[_10,_9,[1,0,0,0.8]];
								drawLine3D[_12,_11,[1,0,0,0.8]];
								drawLine3D[_14,_13,[1,0,0,0.8]];
								_text = format ["<t size='%3'font='EtelkaMonospacePro'color='#ff0000'>%1</t><br /><t size='%3'font='EtelkaMonospacePro'color='#ff0000'>%2 M : %4 HP</t><br />",name _x,round _dist,_Tsize,_HP];
								if(BR_SpectatorMode == 1) then {
									_text = format["%8<t size='%1'font='EtelkaMonospacePro'color='#ff0000'>%2 [%3-%4]</t><br /><t size='%1'font='EtelkaMonospacePro'color='#ff0000'>%5 [%6-%7]</t><br />",_Tsize,_pName,_primaryWeaponCurrentAmmo,_primaryWeaponMagCount,_sName,_handgunWeaponCurrentAmmo,_handgunWeaponMagCount,_text];
									hintSilent parseText _text;
								};
								_ctrl ctrlShow true;_ctrl ctrlEnable true;
								_ctrl ctrlSetStructuredText parseText _text;
								_ctrl ctrlSetPosition [(_pos2D select 0) - _screenDiff, (_pos2D select 1), safezoneW, safezoneH];
								_ctrl ctrlCommit 0;
							};

						}
						else
						{	
							_ctrl ctrlShow false;_ctrl ctrlEnable false;
						};
					};						
				} forEach allUnits;
				//remove extra layers 
				for '_i' from 1 to 50 do {
					LayerID = LayerID + 1;
					LayerID cutText["","PLAIN"]; //clear the layer
				};
					
			};
	} else {
		LayerID = 2732;
		oneachframe {};
		for '_i' from 1 to 50 do {
			LayerID = LayerID + 1;
			LayerID cutText["","PLAIN"]; //clear the layer
		};
	};
};
	
_ppos = [0,0,0];	
_change = 2;
//--- Undefined
if (typename _this == typename []) then {
	if(count(_this) == 3) then {
		_ppos = _this;
		_change = 100;
	} else {
		if (typename _this != typename objnull) then {_this = cameraon};
		_ppos = getPosATL _this;
	};
} else {
	if (typename _this != typename objnull) then {_this = cameraon};
	_ppos = getPosATL _this;
};
private ["_ppos", "_pX", "_pY"];
_pX = _ppos select 0;
_pY = _ppos select 1;
_pZ = _ppos select 2;

private ["_local"];


_local = "camera" camCreate [_pX, _pY, _pZ + _change];
BIS_DEBUG_CAM = _local;
_local camCommand "MANUAL ON";
_local camCommand "INERTIA OFF";
_local cameraEffect ["INTERNAL", "BACK"];				//Switch chamera to BIS_DEBUG_CAM
showCinemaBorder false;
if(typename _this == typename []) then {
	BIS_DEBUG_CAM setDir 0;
} else {
	BIS_DEBUG_CAM setDir direction (vehicle _this);
};


//--- For auto follow fire.

br_toggleFollowAction = false;
br_moveCam = false;

//--- Marker
BIS_DEBUG_CAM_MARKER = createmarkerlocal ["BIS_DEBUG_CAM_MARKER",_ppos];
BIS_DEBUG_CAM_MARKER setmarkertypelocal "mil_start";
BIS_DEBUG_CAM_MARKER setmarkercolorlocal "colorblue";
BIS_DEBUG_CAM_MARKER setmarkersizelocal [.5,.5];
BIS_DEBUG_CAM_MARKER setmarkertextlocal "CAMERA";


//--- Key Down

_keyDown = (finddisplay 46) displayaddeventhandler ["keydown","
	_key = _this select 1;
	_ctrl = _this select 3;

	if (_key in (actionkeys 'showmap')) then {
		if (BIS_DEBUG_CAM_MAP) then {
			openmap [false,false];
			BIS_DEBUG_CAM_MAP = false;
		} else {
			openmap [true,true];
			BIS_DEBUG_CAM_MAP = true;
			BIS_DEBUG_CAM_MARKER setmarkerposlocal position BIS_DEBUG_CAM;
			BIS_DEBUG_CAM_MARKER setmarkerdirlocal direction BIS_DEBUG_CAM;
			mapanimadd [0,0.1,position BIS_DEBUG_CAM];
			mapanimcommit;
		};
	};

	if (_key == 55) then {
		_worldpos = screentoworld [.5,.5];
		if (_ctrl) then {
			vehicle player setpos _worldpos;
		} else {
			copytoclipboard str _worldpos;
		};
	};
	if (_key == 83 && !isnil 'BIS_DEBUG_CAM_LASTPOS') then {
		BIS_DEBUG_CAM setpos BIS_DEBUG_CAM_LASTPOS;
	};

	if (_key == 41) then {
		BIS_DEBUG_CAM_COLOR ppeffectenable false;
	};
	if (_key >= 2 && _key <= 11) then {
		_id = _key - 2;
		if (_id < count BIS_DEBUG_CAM_PPEFFECTS) then {
			BIS_DEBUG_CAM_COLOR ppEffectAdjust (BIS_DEBUG_CAM_PPEFFECTS select _id);
			BIS_DEBUG_CAM_COLOR ppEffectCommit 0;
			BIS_DEBUG_CAM_COLOR ppeffectenable true;
		};
	};
	
"];
BR_CamMode = 0;
BR_SpectatorMode = 2;
BR_CamTarget = objnull;
BR_ThermalMode = -1;
BR_CamNightVision = false;
if(isNil "br_cam_runonce") then {
	["Player Lock For Spectator (Stops Player Movement)"] spawn {
		waituntil{alive player};
		_pos = getpos player;
		_dir = getdir player;
		while{true} do {
			waitUntil{!isNull BR_CamTarget};
			player setDir _dir;
			player setPos _pos;
		};
	};
};
BRGH_Spectate_Keydown = (findDisplay 46) displayaddeventhandler ["keydown","
	_key = _this select 1;
	switch(_key) do {
		case 46: {
			if(BR_CamEnableThermal) then {
				if(BR_ThermalMode == (count(BR_CamThermalModes)-1)) then {
					BR_ThermalMode = -1;
				} else {
					BR_ThermalMode = BR_ThermalMode + 1;
				};
				if(BR_ThermalMode != -1) then {
					true setCamUseTi (BR_CamThermalModes select BR_ThermalMode);
				} else {
					false setCamUseTi 0;
				};
			};
			true;
		};
		case 49: {
			if(BR_CamEnableNightVision) then {
				BR_CamNightVision = !BR_CamNightVision;
				camUseNVG BR_CamNightVision;
			};
		};
		case 48: {
			if(BR_SpectatorMode == 2) then {
				BR_SpectatorMode = 0;
				[BR_SpectatorMode,true] call br_fnc_spectator;
			} else {
				if(BR_SpectatorMode == 0) then {
					BR_SpectatorMode = 1;
					[BR_SpectatorMode,true] call br_fnc_spectator;
				} else {
					BR_SpectatorMode = 2;
					[BR_SpectatorMode,false] call br_fnc_spectator;
				};
			};
				
			true;
		};
		case 203: {
			_units = [];
			{
				if(alive _x && side _x != civilian) then {_units set [count(_units),_x];};
			} forEach playableUnits;

			if(!isNull BR_CamTarget) then {
				_index = _units find BR_CamTarget;
				if(_index != -1) then {
					if(_index <= 0) then {_index == (count(_units)-1);} else {_index = _index - 1;};
					_unit = _units select _index;
					if(!isNull _unit) then {
						BR_CamTarget = _unit;
						if(BR_CamMode == 1) then {
							BR_CamTarget switchCamera 'EXTERNAL';
						} else {
							BR_CamTarget switchCamera 'INTERNAL';
						};
					};
				};
			};
		};	
		case 205: {
			_units = [];
			{
				if(alive _x && side _x != civilian) then {_units set [count(_units),_x];};
			} forEach playableUnits;

			if(!isNull BR_CamTarget) then {
				_index = playableUnits find BR_CamTarget;
				if(_index != -1) then {
					if(_index >= (count(_units)-1)) then {_index == 0;} else {_index = _index + 1;};
					_unit = _units select _index;
					if(!isNull _unit) then {
						BR_CamTarget = _unit;
						if(BR_CamMode == 1) then {
							BR_CamTarget switchCamera 'EXTERNAL';
						} else {
							BR_CamTarget switchCamera 'INTERNAL';
						};
					};
				};
			};
		};
		case 47: {
			if(isNull BR_CamTarget) then {
				_cursorTarget = screenToWorld[0.5,0.5];

				_object = objnull;
				{
					if(alive _x && side _x != civilian) exitWith {_object = _x;};
				} forEach (nearestObjects [_cursorTarget,['Man'],100]);

				if(!isNull _object) then {
					BIS_DEBUG_CAM = objnull;
					BR_CamTarget = _object;
					BR_CamTarget switchCamera 'INTERNAL';
				};
			} else {
				BR_CamTarget call fnc_BRCamera;
				BR_CamTarget = objnull;
			};
			true;
		};
		default {false;};
	};
	
"];
//--- Mouse wheel moving
_mousezchanged = (finddisplay 46) displayaddeventhandler ["mousezchanged","
	_n = _this select 1;
	BIS_DEBUG_CAM_FOCUS = BIS_DEBUG_CAM_FOCUS + _n/10;
	if (_n > 0 && BIS_DEBUG_CAM_FOCUS < 0) then {BIS_DEBUG_CAM_FOCUS = 0};
	if (BIS_DEBUG_CAM_FOCUS < 0) then {BIS_DEBUG_CAM_FOCUS = -1};
	BIS_DEBUG_CAM camcommand 'manual off';
	BIS_DEBUG_CAM campreparefocus [BIS_DEBUG_CAM_FOCUS,1];
	BIS_DEBUG_CAM camcommitprepared 0;
	BIS_DEBUG_CAM camcommand 'manual on';
"];

_map_mousebuttonclick = ((finddisplay 12) displayctrl 51) ctrladdeventhandler ["mousebuttonclick","
	_button = _this select 1;
	_ctrl = _this select 5;
	if (_button == 0) then {
		_x = _this select 2;
		_y = _this select 3;
		_worldpos = (_this select 0) posscreentoworld [_x,_y];
		if (!_ctrl) then {
			BIS_DEBUG_CAM setpos [_worldpos select 0,_worldpos select 1,position BIS_DEBUG_CAM select 2];
			BIS_DEBUG_CAM_MARKER setmarkerposlocal _worldpos;
		};
	};
"];




//Wait until destroy is forced or camera auto-destroyed.
[_local,_keyDown,_mousezchanged,_map_mousebuttonclick] spawn {
	private ["_local","_keyDown","_mousezchanged","_map_mousebuttonclick","_lastpos"];

	_local = _this select 0;
	_keyDown = _this select 1;
	_mousezchanged = _this select 2;
	_map_mousebuttonclick = _this select 3;
	_lastpos = [0,0,0];

	waituntil {
		if (!isnull BIS_DEBUG_CAM) then {_lastpos = position BIS_DEBUG_CAM};
		isNull BIS_DEBUG_CAM
	};

	
	
	player cameraEffect ["TERMINATE", "BACK"];
	deletemarkerlocal BIS_DEBUG_CAM_MARKER;
	BIS_DEBUG_CAM = nil;
	BIS_DEBUG_CAM_MAP = nil;
	BIS_DEBUG_CAM_MARKER = nil;
	BIS_DEBUG_CAM_VISION = nil;
	camDestroy _local;
	
	BIS_DEBUG_CAM_LASTPOS = _lastpos;
	
	fnc_MapIcons_run = true;
	call br_fnc_MapIcons;
	
	ppeffectdestroy BIS_DEBUG_CAM_COLOR;
	(finddisplay 46) displayremoveeventhandler ["keydown",BRGH_Spectate_Keydown];
	(finddisplay 46) displayremoveeventhandler ["keydown",_keyDown];
	(finddisplay 46) displayremoveeventhandler ["mousezchanged",_mousezchanged];
	((finddisplay 12) displayctrl 51) ctrlremoveeventhandler ["mousebuttonclick",_map_mousebuttonclick];

};