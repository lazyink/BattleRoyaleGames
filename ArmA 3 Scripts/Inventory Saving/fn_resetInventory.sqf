/*
	File: fn_resetInventory
	Desc: Wipes the players inventory from their namespace
	Author: PUBR-RYAN
	Usage: [] spawn TA_fnc_resetInventory;
*/

if(isNil "Inventory_Key") then {Inventory_Key = "TeamAtomicInventory";};
profilenamespace setVariable [Inventory_Key,nil];
saveprofilenamespace;