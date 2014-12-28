/*
	File: fn_loadInventory
	Desc: Loads the players inventory
	Author: PUBR-RYAN
	Usage: [] spawn TA_fnc_loadInventory;
*/

if(isNil "Inventory_Key") then {Inventory_Key = "TeamAtomicInventory";};
removeAllContainers player;
removeAllWeapons player;
removeAllAssignedItems player;
removeAllItems player;
removeHeadgear player;
removeGoggles player;
_input = profilenamespace getVariable [Inventory_Key,[]];
if(typename _input == typename "") then {
	_arr = call compile _input;
	_keyArr = toArray Inventory_Key;
	_keyIndex = 0;
	{
			if(_keyIndex == count(_keyArr)) then {_keyIndex = 0;};
			_keyNum = _keyArr select _keyIndex;
			_arr set[_forEachIndex,_x - _keyNum];
			_keyIndex = _keyIndex + 1;
	} forEach _arr;
	_string = toString _arr;
	_items = call compile _string;
   
	_magazines = _items select 0;
	_weapons = _items select 1;
	_playeritems = _items select 2;
	_assignedItems = _items select 3;
	_headGear = _items select 4;
	_goggles = _items select 5;
	_vest = _items select 6;
	_uniform = _items select 7;
	_backpack = _items select 8;
	player addUniform _uniform;
	player addVest _vest;
	player addBackpack _backpack;
	player addHeadgear _headGear;
	player addGoggles _goggles;
	{
			player addMagazine _x;
	} forEach _magazines;
	{
			player addWeapon _x;
	} forEach _weapons;    
	{
			player addItem _x;
	} forEach _playeritems;
	{
			player addItem _x;
			player assignItem _x;
	} forEach _assignedItems;
};