/*
	Medical C-130 Crash by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
	Modified to new format by Vampire
*/

private ["_missName","_coords","_wreck","_trash","_trash1","_trash2","_trash3","_trash4","_trash5","_veh1","_veh2","_vehicle","_vehicle1","_crate","_crate1","_DZMSARRAYPICS","_MISSIONIMAGE","_msg"];

//Name of the Mission
_missName = "C-192 Crash";

//DZMSFindPos loops BIS_fnc_findSafePos until it gets a valid result
_coords = call DZMSFindPos;

_DZMSARRAYPICS = ["Land_Wreck_Plane_Transport_01_F"];
_MISSIONIMAGE = selectRandom _DZMSARRAYPICS; 

_picture = getText (configFile >> "cfgVehicles" >> _MISSIONIMAGE >> "picture"); //this will be %1
_msg = parseText format ["
<t size='2'font='TahomaB'align='Center'color='#66CDAA'>C-192 Crash</t><br/><br/>
<t align='center'><img size='7' image='%1'/></t><br/>
<t size='1'font='TahomaB'align='Center'color='#FFFFFF'>A C-192 Carrying Supplies has Crashed. Bandits are Securing the Cargo!</t><br/>",
_picture
];

_msg remoteexec ["DZMS_Remote_Message",-2];

//DZMSAddMajMarker is a simple script that adds a marker to the location
[_coords,_missname] ExecVM DZMSAddMajMarker;

//We create the mission scenery
_wreck = createVehicle ["Land_Wreck_Plane_Transport_01_F",[(_coords select 0) - 8.8681, (_coords select 1) + 15.3554,0],[], 0, "NONE"];
_wreck setDir -30.165445;
[_wreck] call DZMSProtectObj;

_trash = createVehicle ["CargoNet_01_barrels_F",[(_coords select 0) - 7.4511, (_coords select 1) + 3.8544,0],[], 0, "NONE"];
_trash setDir 61.911976;
[_trash] call DZMSProtectObj;

_trash1 = createVehicle ["Land_Pallets_stack_F",[(_coords select 0) + 4.062, (_coords select 1) + 4.7216,0],[], 0, "NONE"];
_trash1 setDir -29.273479;
[_trash1] call DZMSProtectObj;

_trash2 = createVehicle ["Land_Pallets_F",[(_coords select 0) - 3.4033, (_coords select 1) - 2.2256,0],[], 0, "NONE"];
[_trash2] call DZMSProtectObj;

_trash3 = createVehicle ["Land_Tyre_F",[(_coords select 0) + 1.17, (_coords select 1) + 1.249,0],[], 0, "NONE"];
[_trash3] call DZMSProtectObj;

_trash4 = createVehicle ["Land_CratesWooden_F",[(_coords select 0) + 3.9029, (_coords select 1) - 1.8477,0],[], 0, "NONE"];
_trash4 setDir -70.372086;
[_trash4] call DZMSProtectObj;

_trash5 = createVehicle ["Land_WoodenCrate_01_F",[(_coords select 0) - 2.1181, (_coords select 1) + 5.9765,0],[], 0, "NONE"];
_trash5 setDir -28.122475;
[_trash5] call DZMSProtectObj;

//We create the mission vehicles
_veh1 = ["small"] call DZMSGetVeh;
_veh2 = ["small"] call DZMSGetVeh;
_vehicle = createVehicle [_veh1,[(_coords select 0) + 14.1426, (_coords select 1) - 0.6202,0],[], 0, "CAN_COLLIDE"];
_vehicle1 = createVehicle [_veh2,[(_coords select 0) - 6.541, (_coords select 1) - 11.5557,0],[], 0, "CAN_COLLIDE"];

//DZMSSetupVehicle prevents the vehicle from disappearing and sets fuel and such
[_vehicle] call DZMSSetupVehicle;
[_vehicle1] call DZMSSetupVehicle;

//DZMSBoxFill fills the box, DZMSProtectObj prevents it from disappearing
_crate = createVehicle ["Box_NATO_WpsSpecial_F",[(_coords select 0) - 1.5547,(_coords select 1) + 2.3486,0],[], 0, "CAN_COLLIDE"];
[_crate,"supply2"] ExecVM DZMSBoxSetup;
[_crate] call DZMSProtectObj;

_crate1 = createVehicle ["Box_NATO_AmmoVeh_F",[(_coords select 0) + 0.3428,(_coords select 1) - 1.8985,0],[], 0, "CAN_COLLIDE"];
[_crate1,"supply"] ExecVM DZMSBoxSetup;
[_crate1] call DZMSProtectObj;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, unitArray]
[[(_coords select 0) - 10.5005,(_coords select 1) - 2.6465,0],6,1,"DZMSUnitsMajor"] call DZMSAISpawn;
sleep 5;
[[(_coords select 0) + 4.7027,(_coords select 1) + 12.2138,0],6,1,"DZMSUnitsMajor"] call DZMSAISpawn;
sleep 5;
[[(_coords select 0) + 2.918,(_coords select 1) - 9.0342,0],4,1,"DZMSUnitsMajor"] call DZMSAISpawn;
sleep 5;
[[(_coords select 0) + 2.918,(_coords select 1) - 9.0342,0],4,1,"DZMSUnitsMajor"] call DZMSAISpawn;

//Spawn AI vehicle patrol
//Usage: [_coords, PatrolRadius ,  skillLevel, unitArray]
[_coords, 50, 3, "DZMSUnitsMajor"] call DZMSVehiclePatrol;

//Wait until the player is within 30 meters and also meets the kill req
[_coords,"DZMSUnitsMajor"] call DZMSWaitMissionComp;

//Call DZMSSaveVeh to attempt to save the vehicles to the database
//If saving is off, the script will exit.
[_vehicle] ExecVM DZMSSaveVeh;
[_vehicle1] ExecVM DZMSSaveVeh;

//Let everyone know the mission is over
_picture = getText (configFile >> "cfgVehicles" >> _MISSIONIMAGE >> "picture"); //this will be %1
_msg = parseText format ["
<t size='2'font='TahomaB'align='Center'color='#66CDAA'>C-192 Crash</t><br/><br/>
<t align='center'><img size='7' image='%1'/></t><br/>
<t size='1'font='TahomaB'align='Center'color='#FFFFFF'>The Crash Site has been Secured by Survivors!</t><br/>",
_picture
];

_msg remoteexec ["DZMS_Remote_Message",-2];

diag_log text format["[DZMS]: Major EM1 C130 Mission has Ended."];
deleteMarker "DZMSMajMarker";
deleteMarker "DZMSMajDot";

//Let the timer know the mission is over
DZMSMajDone = true;