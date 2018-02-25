if (!isServer)exitWith{};

private ["_position","_skill","_wpRadius","_xpos","_ypos","_unitGroup","_aiskin","_weapon","_magazine","_wppos1","_wppos2","_wppos3","_wppos4","_wp1","_wp2","_wp3","_wp4","_wpfin","_unitArrayName","_unitMissionCount","_patrol","_pilot","_gunner"];

_position = _this select 0;
_wpRadius = _this select 1;
_skill = _this select 2;
_unitArrayName = _this select 3;

_xpos = _position select 0;
_ypos = _position select 1;

//diag_log text format ["[DZMS_Patrol]: AI Pos:%1 / AI SkillLev:%2",_position,_skill];

_unitGroup = createGroup DZMSAISide;

//diag_log text format ["[DZMS_Patrol]: Create the Driver"];

_pilot = _unitGroup createUnit [DZMSAIModel, [0,0,0], [], 1, "NONE"];
[_pilot] joinSilent _unitGroup;
	
	//Add the behaviour
	_pilot enableAI "TARGET";
	_pilot enableAI "AUTOTARGET";
	_pilot enableAI "MOVE";
	_pilot enableAI "ANIM";
	_pilot enableAI "FSM";
	_pilot setCombatMode "RED";
	_pilot setBehaviour "COMBAT";
	
	//Remove the items he spawns with by default
	removeAllWeapons _pilot;
	removeAllItems _pilot;
	removeAllAssignedItems _pilot;
	removeUniform _pilot;
	removeVest _pilot; 
	removeBackpack _pilot;
	removeHeadgear _pilot;
	removeGoggles _pilot;
		
	//Now we need to figure out their loadout, and assign it
	
	//Get the weapon array based on skill
	_weaponArray = [_skill - 1] call DZMSGetWeapon;

	_weapon = _weaponArray select 0;
	_magazine = _weaponArray select 1;

	// Select a random uniform and put it on
	_aiskin = selectRandom DZMSBanditSkins;
	_pilot forceAddUniform _aiskin;
	
	// If an array of helmets is provided then select a random one from that list
	// Otherwise select random vanilla headgear
	_aiheadgear = selectRandom DZMSBanditHelmets;
	if(_aiheadgear != "") then {
		_pilot addHeadgear _aiheadgear;
	} else {
		_pilot addHeadgear format ["H_%1_EPOCH", floor(random 91) + 1];
	};
	
	// If an array of vests is provided then select a random one from that list
	// Otherwise select a random vanilla vest
	_aivest = selectRandom DZMSBanditVests;
	if(_aivest != "") then {
		_pilot addvest _aivest;
	} else {
		_pilot addvest format ["V_%1_EPOCH", floor(random 39) + 1];
	};

	//Get the gear array
	_aigearArray = [DZMSGear0,DZMSGear1,DZMSGear2,DZMSGear3,DZMSGear4];
	_gearmagazines = _aigearArray call BIS_fnc_selectRandom;
	
	//Gear the AI backpack
	_aipack = selectRandom DZMSPacklist;

	//Lets add it to the Unit
	for "_i" from 1 to 3 do {
		_pilot addMagazine _magazine;
	};
	_pilot addWeapon _weapon;
	_pilot selectWeapon _weapon;
	
	_pilot addBackpack _aipack;
	
	if (DZMSUseNVG) then {
		_pilot addWeapon "NVGoggles";
	};
	
	{
		_pilot addMagazine _x
	} forEach _gearmagazines;
		
	
//diag_log text format ["[DZMS_Patrol]: Create Gunner"];
	
_aiskin = DZMSBanditSkins call BIS_fnc_selectRandom;
_gunner = _unitGroup createUnit [DZMSAIModel, [0,0,0], [], 1, "NONE"];
[_gunner] joinSilent _unitGroup;
	
	//Add the behaviour
	_gunner enableAI "TARGET";
	_gunner enableAI "AUTOTARGET";
	_gunner enableAI "MOVE";
	_gunner enableAI "ANIM";
	_gunner enableAI "FSM";
	_gunner setCombatMode "RED";
	_gunner setBehaviour "COMBAT";
	
	//Remove the items he spawns with by default
	removeAllWeapons _gunner;
	removeAllItems _gunner;
	removeAllAssignedItems _gunner;
	removeUniform _gunner;
	removeVest _gunner; 
	removeBackpack _gunner;
	removeHeadgear _gunner;
	removeGoggles _gunner;
	
	//Now we need to figure out their loadout, and assign it
	
	//Get the weapon array based on skill
	_weaponArray = [_skill - 1] call DZMSGetWeapon;

	_weapon = _weaponArray select 0;
	_magazine = _weaponArray select 1;

	// Select a random uniform and put it on
	_aiskin = selectRandom DZMSBanditSkins;
	_gunner forceAddUniform _aiskin;
	
	// If an array of helmets is provided then select a random one from that list
	// Otherwise select random vanilla headgear
	_aiheadgear = selectRandom DZMSBanditHelmets;
	if(_aiheadgear != "") then {
		_gunner addHeadgear _aiheadgear;
	} else {
		_gunner addHeadgear format ["H_%1_EPOCH", floor(random 91) + 1];
	};
	
	// If an array of vests is provided then select a random one from that list
	// Otherwise select a random vanilla vest
	_aivest = selectRandom DZMSBanditVests;
	if(_aivest != "") then {
		_gunner addvest _aivest;
	} else {
		_gunner addvest format ["V_%1_EPOCH", floor(random 39) + 1];
	};

	//Get the gear array
	_aigearArray = [DZMSGear0,DZMSGear1,DZMSGear2,DZMSGear3,DZMSGear4];
	_gearmagazines = _aigearArray call BIS_fnc_selectRandom;
	
	//Gear the AI backpack
	_aipack = selectRandom DZMSPacklist;

	//Lets add it to the Unit
	for "_i" from 1 to 3 do {
		_gunner addMagazine _magazine;
	};
	_gunner addWeapon _weapon;
	_gunner selectWeapon _weapon;
	
	_gunner addBackpack _aipack;
	
	if (DZMSUseNVG) then {
		_gunner addWeapon "NVGoggles";
	};
	
	{
		_gunner addMagazine _x
	} forEach _gearmagazines;
	
	_aicskill = DZMSSkills1;
	
	//Lets set the skills
	switch (_skill) do {
		case 0: {_aicskill = DZMSSkills0;};
		case 1: {_aicskill = DZMSSkills1;};
		case 2: {_aicskill = DZMSSkills2;};
		case 3: {_aicskill = DZMSSkills3;};
	};
	
	{_gunner setSkill [(_x select 0),(_x select 1)]} forEach _aicskill;
	{_pilot setSkill [(_x select 0),(_x select 1)]} forEach _aicskill;


	//Lets prepare the unit for cleanup
	_pilot addEventHandler ["Killed",{ [(_this select 0), (_this select 1)] ExecVM DZMSAIKilled; }];
	_pilot setVariable ["DZMSAI", true];
	_gunner addEventHandler ["Killed",{ [(_this select 0), (_this select 1)] ExecVM DZMSAIKilled; }];
	_gunner setVariable ["DZMSAI", true];

//diag_log text format ["[DZMS_Patrol]: Create the Vehicle"];

_patrol = ["patrol"] call DZMSGetVeh;
_patrol = createVehicle [_patrol, [(_position select 0) + _wpRadius,(_position select 1) + _wpRadius, 0], [], 0, "CAN_COLLIDE"];
[_patrol] call DZMSSetupVehicle;
_patrol setFuel 1;
_patrol engineOn true;
_patrol setVehicleAmmo 1;
_patrol allowCrewInImmobile true;
clearWeaponCargoGlobal _patrol;
clearMagazineCargoGlobal _patrol;
clearBackpackCargoGlobal _patrol;
clearItemCargoGlobal _patrol;

//PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_patrol];

_pilot assignAsDriver _patrol;
_pilot moveInDriver _patrol;
_gunner assignAsGunner _patrol;
_gunner moveingunner _patrol;

//diag_log text format ["[DZMS_Patrol]: Spawn the Patrol Group"];
_patrol call EPOCH_server_setVToken;
addToRemainsCollector [_patrol]; 	// Add the vehicle to ARMA's wreck handler

_unitGroup allowFleeing 0;
_unitGroup setBehaviour "AWARE";
// These are 4 waypoints in a NorthSEW around the center
_wppos1 = [_xpos, _ypos+50, 0];
_wppos2 = [_xpos+50, _ypos, 0];
_wppos3 = [_xpos, _ypos-50, 0];
_wppos4 = [_xpos-50, _ypos, 0];


//diag_log text format ["[DZMS_Patrol]: Add Waypoints"];

// We add the 4 waypoints
_wp1 = _unitGroup addWaypoint [_wppos1, _wpRadius];
_wp1 setWaypointType "MOVE";
_wp2 = _unitGroup addWaypoint [_wppos2, _wpRadius];
_wp2 setWaypointType "MOVE";
_wp3 = _unitGroup addWaypoint [_wppos3, _wpRadius];
_wp3 setWaypointType "MOVE";
_wp4 = _unitGroup addWaypoint [_wppos4, _wpRadius];
_wp4 setWaypointType "MOVE";


// Then we add a center waypoint that tells them to visit the rest
_wpfin = _unitGroup addWaypoint [[_xpos,_ypos, 0], _wpRadius];
_wpfin setWaypointType "CYCLE";
_wpfin setWaypointCompletionRadius 150;

// load the unit groups into a passed array name so they can be cleaned up later
call compile format["
%1 = %1 + (units _unitGroup); 
_unitMissionCount = count %1;
",_unitArrayName];

diag_log text format["[DZMS]: (%3) %1 AI Spawned in patrol vehicle, %2 units in mission.",count (units _unitGroup),_unitMissionCount,_unitArrayName];

//diag_log text format ["[DZMS_Patrol]: Finished the Patrol Create"];