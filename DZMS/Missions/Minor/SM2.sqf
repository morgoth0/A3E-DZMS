/*
	Medical Outpost by lazyink (Full credit for code to TheSzerdi & TAW_Tonic)
	Updated to new format by Vampire
*/
private ["_missName","_coords","_base","_base1","_base2","_base3","_veh1","_veh2","_vehicle","_vehicle1","_crate","_crate2"];

//Name of the Mission
_missName = "Medical Outpost";

//DZMSFindPos loops BIS_fnc_findSafePos until it gets a valid result
_coords = call DZMSFindPos;

_DZMSARRAYPICS = ["Land_Medevac_house_V1_F"];
_MISSIONIMAGE = selectRandom _DZMSARRAYPICS; 

_picture = getText (configFile >> "cfgVehicles" >> _MISSIONIMAGE >> "picture"); //this will be %1
_msg = parseText format ["
<t size='2'font='TahomaB'align='Center'color='#66CDAA'>Medical Outpost</t><br/><br/>
<t align='center'><img size='7' image='%1'/></t><br/>
<t size='1'font='TahomaB'align='Center'color='#FFFFFF'>Bandits have established a Medical Outpost! Go Secure their Medical Supplies!</t><br/>",
_picture
];

_msg remoteexec ["DZMS_Remote_Message",-2];

//DZMSAddMinMarker is a simple script that adds a marker to the location
[_coords,_missName] ExecVM DZMSAddMinMarker;

//We create the scenery
_base = createVehicle ["Land_Medevac_house_V1_F",[(_coords select 0) +2, (_coords select 1)+5,-0.3],[], 0, "CAN_COLLIDE"];
_base1 = createVehicle ["Land_MedicalTent_01_digital_closed_F",[(_coords select 0) - 40, (_coords select 1) - 10,0],[], 0, "CAN_COLLIDE"];
_base2 = createVehicle ["Land_MedicalTent_01_digital_closed_F",[(_coords select 0) - 30, (_coords select 1) - 10,0],[], 0, "CAN_COLLIDE"];
_base3 = createVehicle ["Land_MedicalTent_01_digital_closed_F",[(_coords select 0) - 20, (_coords select 1) - 10,0],[], 0, "CAN_COLLIDE"];

//DZMSProtectObj prevents it from disappearing
[_base] call DZMSProtectObj;
[_base1] call DZMSProtectObj;
[_base2] call DZMSProtectObj;
[_base3] call DZMSProtectObj;

//We create the vehicles
_veh1 = ["small"] call DZMSGetVeh;
_veh2 = ["small"] call DZMSGetVeh;
_vehicle = createVehicle [_veh1,[(_coords select 0) + 10, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_vehicle1 = createVehicle [_veh2,[(_coords select 0) + 15, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];

//DZMSSetupVehicle prevents the vehicle from disappearing and sets fuel and such
[_vehicle] call DZMSSetupVehicle;
[_vehicle1] call DZMSSetupVehicle;

//We create and fill the crates
_crate = createVehicle ["Box_IDAP_Equip_F",[(_coords select 0) - 3, _coords select 1,0],[], 0, "CAN_COLLIDE"];

//DZMSBoxFill fills the box, DZMSProtectObj prevents it from disappearing
[_crate,"medical"] ExecVM DZMSBoxSetup;
[_crate] call DZMSProtectObj;

_crate2 = createVehicle ["Box_IND_Ammo_F",[(_coords select 0) - 8, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate2,"weapons"] ExecVM DZMSBoxSetup;
[_crate2] call DZMSProtectObj;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, unitArray]
[[(_coords select 0) - 20, (_coords select 1) - 15,0],4,0,"DZMSUnitsMinor"] call DZMSAISpawn;
sleep 3;
[[(_coords select 0) + 10, (_coords select 1) + 15,0],4,0,"DZMSUnitsMinor"] call DZMSAISpawn;
sleep 3;
[[(_coords select 0) - 10, (_coords select 1) - 15,0],4,0,"DZMSUnitsMinor"] call DZMSAISpawn;
sleep 3;
[[(_coords select 0) + 20, (_coords select 1) + 15,0],4,0,"DZMSUnitsMinor"] call DZMSAISpawn;
sleep 3;

//Wait until the player is within 30 meters and also meets the kill req
[_coords,"DZMSUnitsMinor"] call DZMSWaitMissionComp;

//Call DZMSSaveVeh to attempt to save the vehicles to the database
//If saving is off, the script will exit.
[_vehicle] ExecVM DZMSSaveVeh;
[_vehicle1] ExecVM DZMSSaveVeh;

//Let everyone know the mission is over
_picture = getText (configFile >> "cfgVehicles" >> _MISSIONIMAGE >> "picture"); //this will be %1
_msg = parseText format ["
<t size='2'font='TahomaB'align='Center'color='#66CDAA'>Medical Outpost</t><br/><br/>
<t align='center'><img size='7' image='%1'/></t><br/>
<t size='1'font='TahomaB'align='Center'color='#FFFFFF'>The Medical Outpost is under Survivor Control!</t><br/>",
_picture
];

_msg remoteexec ["DZMS_Remote_Message",-2];
diag_log text format["[DZMS]: Minor SM2 Medical Outpost Mission has Ended."];

deleteMarker "DZMSMinMarker";
deleteMarker "DZMSMinDot";

//Let the timer know the mission is over
DZMSMinDone = true;