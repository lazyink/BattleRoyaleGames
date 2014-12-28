/*
	File: fn_saveInventory
	Desc: Saves the players inventory
	Author: PUBR-RYAN
	Usage: [] spawn TA_fnc_saveInventory;
*/

if(isNIl "Inventory_Key") then {Inventory_Key = "TeamAtomicInventory";};
_magazines = [];
{
		_magazines = _magazines + [[_x select 0,_x select 1]];
} forEach (magazinesAmmoFull player);
_weapons = weapons  player;
_items = items player;
_assignedItems = assignedItems player;
_headGear = headgear player;
_goggles = goggles player;
_vest = vest player;
_uniform = uniform player;
_backpack = backpack player;

_Items = [_magazines,_weapons,_items,_assignedItems,_headGear,_goggles,_vest,_uniform,_backpack];

_string = str(_Items);
_arr = toArray _string;
_keyArr = toArray Inventory_Key;
_keyIndex = 0;
{
		if(_keyIndex == count(_keyArr)) then {_keyIndex = 0;};
		_keyNum = _keyArr select _keyIndex;
		_arr set[_forEachIndex,_x + _keyNum];
		_keyIndex = _keyIndex + 1;
} forEach _arr;
_input = str(_arr);
profilenamespace setVariable [Inventory_Key,_input];
saveprofilenamespace;