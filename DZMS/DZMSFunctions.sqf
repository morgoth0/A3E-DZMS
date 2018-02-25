/*
	DayZ Mission System Functions
	by Vampire
*/

diag_log text "[DZMS]: Loading ExecVM Functions.";
DZMSMajTimer = "\z\addons\dayz_server\DZMS\Scripts\DZMSMajTimer.sqf";
DZMSMinTimer = "\z\addons\dayz_server\DZMS\Scripts\DZMSMinTimer.sqf";
DZMSMarkerLoop = "\z\addons\dayz_server\DZMS\Scripts\DZMSMarkerLoop.sqf";

DZMSAddMajMarker = "\z\addons\dayz_server\DZMS\Scripts\DZMSAddMajMarker.sqf";
DZMSAddMinMarker = "\z\addons\dayz_server\DZMS\Scripts\DZMSAddMinMarker.sqf";

DZMSAIKilled = "\z\addons\dayz_server\DZMS\Scripts\DZMSAIKilled.sqf";

DZMSBoxSetup = "\z\addons\dayz_server\DZMS\Scripts\DZMSBox.sqf";
DZMSSaveVeh = "\z\addons\dayz_server\DZMS\Scripts\DZMSSaveToHive.sqf";

diag_log text "[DZMS]: Loading Compiled Functions.";
// compiled functions
DZMSAISpawn = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSAISpawn.sqf";
DZMSVehiclePatrol = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSVehiclePatrol.sqf";

diag_log text "[DZMS]: Loading All Other Functions.";
//Attempts to find a mission location
//If findSafePos fails it searches again until a position is found
//This fixes the issue with missions spawning in Novy Sobor on Chernarus
DZMSFindPos = {
    private["_mapHardCenter","_mapRadii","_centerPos","_pos","_disCorner","_hardX","_hardY","_findRun","_posX","_posY","_feel1","_feel2","_feel3","_feel4","_noWater","_disMaj","_disMin","_okDis","_isBlack","_playerNear","_objectNear"];
  
	_mapHardCenter = true;
	_centerPos = epoch_centerMarkerPosition;
	_mapRadii = EPOCH_dynamicVehicleArea;;

    if (!(DZMSStaticPlc)) then {
   
        _hardX = _centerPos select 0;
        _hardY = _centerPos select 1;
   
        //We need to loop findSafePos until it doesn't return the map center
        _findRun = true;
        while {_findRun} do
        {
            _pos = [_centerPos,0,_mapRadii,60,0,20,0] call BIS_fnc_findSafePos;
           
            //Apparently you can't compare two arrays and must compare values
            _posX = _pos select 0;
            _posY = _pos select 1;
           
            //Water Feelers. Checks for nearby water within 50meters.
            _feel1 = [_posX, _posY+50, 0];
            _feel2 = [_posX+50, _posY, 0];
            _feel3 = [_posX, _posY-50, 0];
            _feel4 = [_posX-50, _posY, 0];
           
            //Water Check
            _noWater = (!surfaceIsWater _pos && !surfaceIsWater _feel1 && !surfaceIsWater _feel2 && !surfaceIsWater _feel3 && !surfaceIsWater _feel4);
						
			//Lets check for minimum mission separation distance
			_disMaj = (_pos distance DZMSMajCoords);
			_disMin = (_pos distance DZMSMinCoords);
			_okDis = ((_disMaj > 1000) AND (_disMin > 1000));
		   
            //make sure the point is not blacklisted
            _isBlack = false;
            {
                if ((_pos distance (_x select 0)) <= (_x select 1)) then {_isBlack = true;};
            } forEach DZMSBlacklistZones;
			
			_playerNear = {isPlayer _x} count (_pos nearEntities [["Epoch_Male_F","Epoch_Female_F"], 1000]) > 0;

			_objectNear = nearestObjects [_pos,  ["PlotPole_EPOCH","ProtectionZone_Invisible_F","Debug_static_F"], 1000];
            
			//Lets combine all our checks to possibly end the loop
            if ((_posX != _hardX) AND (_posY != _hardY) AND _noWater AND _okDis AND !_isBlack AND !_playerNear AND (count _objectNear == 0)) then {
				_findRun = false;
            };
			// If the missions never spawn after running, use this to debug the loop.
			// Will Complete if: noWater = true / Distance > 1000 / TaviHeight <= 185 / Blacklisted = false / PlayerNear = false
			//diag_log text format ["[DZMS]: DEBUG: Pos:[%1,%2] / noWater?:%3 / okDistance?:%4 / isBlackListed:%5 / isPlayerNear:%6", _posX, _posY, _noWater, _okDis, _isBlack, _playerNear];
            sleep 2;
        };
       
    };
	
	if (DZMSStaticPlc) then {
		_pos = selectRandom DZMSStatLocs;
	};
   
    _fin = [(_pos select 0), (_pos select 1), 0];
    _fin
};

//Clears the cargo and sets fuel, direction, and orientation
//Direction stops the awkwardness of every vehicle bearing 0
DZMSSetupVehicle = {
	private ["_object","_ranFuel"];
	_object = _this select 0;

	_object call EPOCH_server_setVToken;
	addToRemainsCollector [_object]; 	// Add the vehicle to ARMA's wreck handler
	
	waitUntil {(!isNull _object)};
	
	clearWeaponCargoGlobal _object;
	clearMagazineCargoGlobal _object;
	clearBackpackCargoGlobal _object;
	clearItemCargoGlobal _object;
	
	_ranFuel = random 1;
	if (_ranFuel < .1) then {_ranFuel = .1;};
	_object setFuel _ranFuel;
	_object setvelocity [0,0,1];
	_object setDir (round(random 360));
	
	//If saving vehicles to the database is disabled, lets warn players it will disappear
	if (!(DZMSSaveVehicles)) then {
		_object addEventHandler ["GetIn",{
			["Warning: This vehicle will disappear on server restart!", 5] call Epoch_message;
		}];
	};

	true
};

//Prevents an object being cleaned up by the server anti-hack
DZMSProtectObj = {
	private ["_object"];
	_object = _this select 0;
		
    if (!((typeOf _object) in ["Box_NATO_AmmoVeh_F","C_supplyCrate_F","Box_NATO_WpsSpecial_F"]) || DZMSSceneryDespawnLoot) then {
        _object setVariable["DZMSCleanup",true];
    };
	true
};

//Gets the weapon and magazine based on skill level
DZMSGetWeapon = {
	private ["_skill","_aiweapon","_weapon","_magazine","_fin"];
	
	_skill = _this select 0;
	
	//diag_log text format ["[DZMS]: AI Skill Func:%1",_skill];
	
	switch (_skill) do {
		case 0: {_aiweapon = DZMSWeps0;};
		case 1: {_aiweapon = DZMSWeps1;};
		case 2: {_aiweapon = DZMSWeps2;};
		case 3: {_aiweapon = DZMSWeps3;};
	};
	_weapon = selectRandom _aiweapon;
	_magazine = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines") select 0;
	
	_fin = [_weapon,_magazine];
	
	_fin
};

//This gets the random vehicle to spawn at a mission
DZMSGetVeh = {
	private ["_type","_vehArray","_choseVic"];
	
	_type = _this select 0;
	
	switch (_type) do {
		case "heli": {_vehArray = DZMSChoppers;};
		case "small": {_vehArray = DZMSSmallVic;};
		case "large": {_vehArray = DZMSLargeVic;};
		case "patrol": {_vehArray = DZMSPatrolVeh;};
	};
	
	_choseVic = selectRandom _vehArray;
	
	_choseVic
};

//function to wait for mission completion
DZMSWaitMissionComp = {
    private["_objective","_unitArrayName","_numSpawned","_numKillReq"];
	
    _objective = _this select 0;
    _unitArrayName = _this select 1;
	
    call compile format["_numSpawned = count %1;",_unitArrayName];
    _numKillReq = ceil(DZMSRequiredKillPercent * _numSpawned);
	
    diag_log text format["[DZMS]: (%3) Waiting for %1/%2 Units or Less to be Alive and a Player to be Near the Objective.",(_numSpawned - _numKillReq),_numSpawned,_unitArrayName];
	
    call compile format["waitUntil{sleep 1; ({isPlayer _x && _x distance _objective <= 30} count playableUnits > 0) && ({alive _x} count %1 <= (_numSpawned - _numKillReq));};",_unitArrayName];
	
    if (DZMSSceneryDespawnTimer > 0) then {_objective spawn DZMSCleanupThread;};
};

//sleep function that uses diag_tickTime for accuracy
DZMSSleep = {
    private["_sleepTime","_checkInterval","_startTime"];
	
    _sleepTime = _this select 0;
    _checkInterval = _this select 1;
	
    _startTime = diag_tickTime;
    waitUntil{sleep _checkInterval; (diag_tickTime - _startTime) > _sleepTime;};
};

//function to clean up mission objects
DZMSCleanupThread = {
    //sleep for the despawn timer length
    [DZMSSceneryDespawnTimer,20] call DZMSSleep;
	
    //delete flagged nearby objects
    {
        if (_x getVariable ["DZMSCleanup",false]) then {
            _x call DZMSScheduleCleanUp;
        };
    } forEach (_this nearObjects 50);
};

DZMSScheduleCleanUp = {
	private "_group";
	_this removeAllMPEventHandlers "mpkilled";
	_this removeAllMPEventHandlers "mphit";
	_this removeAllMPEventHandlers "mprespawn";
	_this removeAllEventHandlers "FiredNear";
	_this removeAllEventHandlers "HandleDamage";
	_this removeAllEventHandlers "Killed";
	_this removeAllEventHandlers "Fired";
	_this removeAllEventHandlers "GetIn";
	_this removeAllEventHandlers "GetOut";
	_this removeAllEventHandlers "Local";
	_this removeAllEventHandlers "Respawn";
	
	_group = group _this;
	deleteVehicle _this;
	if (count units _group == 0) then {
		deleteGroup _group;
	};
		
	_this = nil;
};

//------------------------------------------------------------------//
diag_log text format ["[DZMS]: Mission Functions Script Loaded!"];
