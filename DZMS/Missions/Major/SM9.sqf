/*
	Fire Base Camp by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
	Updated to New Mission Format by Vampire
	Edited by Fuchs for EMS
*/

private ["_missName","_coords","_crate","_base1","_base2"];

//Name of the Mission
_missName = "Bandit Firebase";

//DZMSFindPos loops BIS_fnc_findSafePos until it gets a valid result
_coords = call DZMSFindPos;

_DZMSARRAYPICS = ["B_HMG_01_F"];
_MISSIONIMAGE = selectRandom _DZMSARRAYPICS; 

_picture = getText (configFile >> "cfgVehicles" >> _MISSIONIMAGE >> "picture"); //this will be %1
_msg = parseText format ["
<t size='2'font='TahomaB'align='Center'color='#66CDAA'>Bandit Firebase</t><br/><br/>
<t align='center'><img size='7' image='%1'/></t><br/>
<t size='1'font='TahomaB'align='Center'color='#FFFFFF'>A firebase is being constructed! Stop the bandits and secure the construction materials for yourself!</t><br/>",
_picture
];

_msg remoteexec ["DZMS_Remote_Message",-2];

//DZMSAddMajMarker is a simple script that adds a marker to the location
[_coords,_missName] ExecVM DZMSAddMajMarker;

//Create the scenery
_base1 = createVehicle ["Land_BagBunker_Large_F",[(_coords select 0) - 20, (_coords select 1) - 10,-0.2],[], 0, "CAN_COLLIDE"];
_base2 = createVehicle ["Land_BagBunker_Tower_F",[(_coords select 0) - 10, (_coords select 1) + 10,-0.2],[], 0, "CAN_COLLIDE"];
[_base1] call DZMSProtectObj;
[_base2] call DZMSProtectObj;

_crate = createVehicle ["Box_NATO_AmmoVeh_F",[(_coords select 0) + 22, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate,"supply2"] ExecVM DZMSBoxSetup;
[_crate] call DZMSProtectObj;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, unitArray]
[[(_coords select 0) - 8.4614,(_coords select 1) - 5.0527,0],6,1,"DZMSUnitsMajor"] call DZMSAISpawn;
sleep 5;
[[(_coords select 0) - 8.4614,(_coords select 1) - 5.0527,0],4,1,"DZMSUnitsMajor"] call DZMSAISpawn;
sleep 5;
[[(_coords select 0) + 7.5337,(_coords select 1) + 4.2656,0],4,1,"DZMSUnitsMajor"] call DZMSAISpawn;
sleep 5;
[[(_coords select 0) + 7.5337,(_coords select 1) + 4.2656,0],4,1,"DZMSUnitsMajor"] call DZMSAISpawn;
sleep 5;

//Wait until the player is within 30 meters and also meets the kill req
[_coords,"DZMSUnitsMajor"] call DZMSWaitMissionComp;

//Call DZMSSaveVeh to attempt to save the vehicles to the database
//If saving is off, the script will exit.

//Let everyone know the mission is over
_picture = getText (configFile >> "cfgVehicles" >> _MISSIONIMAGE >> "picture"); //this will be %1
_msg = parseText format ["
<t size='2'font='TahomaB'align='Center'color='#66CDAA'>Bandit Firebase</t><br/><br/>
<t align='center'><img size='7' image='%1'/></t><br/>
<t size='1'font='TahomaB'align='Center'color='#FFFFFF'>Survivors have secured the construction materials!</t><br/>",
_picture
];

_msg remoteexec ["DZMS_Remote_Message",-2];
diag_log text format["[DZMS]: Major SM9 Fire Base Mission has Ended."];
deleteMarker "DZMSMajMarker";
deleteMarker "DZMSMajDot";

//Let the timer know the mission is over
DZMSMajDone = true;
