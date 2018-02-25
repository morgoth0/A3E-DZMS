/*
	Save To Hive by Vampire
	This function attempts to save vehicles to the database if enabled when a mission ends.
	Usage: [Vehicle]
*/
_object = _this select 0;
_class = typeOf _object;
_dir = getDir _object;
_pos = getPos _object;
_worldspace = [_dir,_pos];

//If they have vehicle saving off, then this script needs to do nothing.
if (!(DZMSSaveVehicles)) exitWith {};

//Check if vehicle is null or dead
if (isNull _object OR !alive _object OR (damage _object) > .97) exitWith {};

//Get a random fuel count to set
_ranFuel = random 1;
if (_ranFuel < .1) then {_ranFuel = .1;};

//Lets get it ready for the user
_object setvelocity [0,0,1];
_object setFuel _ranFuel;
_object setVehicleLock "UNLOCKED";
	
clearWeaponCargoGlobal  _object;
clearMagazineCargoGlobal  _object;
clearBackpackCargoGlobal _object;
clearItemCargoGlobal _object;
	
//_object allowDamage false;
//_object setVariable ["lastUpdate", time];
//_object setVariable ["CharacterID", "0", true];
	
//sleep 1;
//_object allowDamage true;
	