/*
	File: fn_hasInventory
	Desc: Checks if a player has an inventory saved
	Author: PUBR-RYAN
	Usage: _hasInventory = call TA_fnc_hasInventory;
*/

if(isNil "Inventory_Key") then {Inventory_Key = "TeamAtomicInventory";};
_hasInventory = if(typename (profilenamespace getVariable [Inventory_Key,[]]) == typename "") then {true} else {false};
_hasInventory;