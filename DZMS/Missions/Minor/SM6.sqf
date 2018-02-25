/*
	Weapon Truck Crash by lazyink (Full credit for code to TheSzerdi & TAW_Tonic)
	Updated to new format by Vampire
*/
private ["_missName","_coords","_crash","_crate","_crate1","_crate2"];

//Name of the Mission
_missName = "Weapons Van";

//DZMSFindPos loops BIS_fnc_findSafePos until it gets a valid result
_coords = call DZMSFindPos;

_DZMSARRAYPICS = ["C_Van_01_transport_F"];
_MISSIONIMAGE = selectRandom _DZMSARRAYPICS; 

_picture = getText (configFile >> "cfgVehicles" >> _MISSIONIMAGE >> "picture"); //this will be %1
_msg = parseText format ["
<t size='2'font='TahomaB'align='Center'color='#66CDAA'>Weapons Van</t><br/><br/>
<t align='center'><img size='7' image='%1'/></t><br/>
<t size='1'font='TahomaB'align='Center'color='#FFFFFF'>A Weapons Van has Crashed! Go Recover the Supplies!</t><br/>",
_picture
];

_msg remoteexec ["DZMS_Remote_Message",-2];

//DZMSAddMinMarker is a simple script that adds a marker to the location
[_coords,_missName] ExecVM DZMSAddMinMarker;

//Add scenery
_crash = createVehicle ["Land_Wreck_Truck_dropside_F",_coords,[], 0, "CAN_COLLIDE"];

//DZMSProtectObj prevents it from disappearing
[_crash] call DZMSProtectObj;

//Add and fill the boxes
_crate = createVehicle ["Box_NATO_WpsSpecial_F",[(_coords select 0) + 3, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate,"weapons"] ExecVM DZMSBoxSetup;
[_crate] call DZMSProtectObj;

_crate1 = createVehicle ["Box_NATO_WpsSpecial_F",[(_coords select 0) - 3, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate1,"weapons"] ExecVM DZMSBoxSetup;
[_crate1] call DZMSProtectObj;

_crate2 = createVehicle ["Box_NATO_AmmoVeh_F",[(_coords select 0) - 6, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate2,"weapons"] ExecVM DZMSBoxSetup;
[_crate2] call DZMSProtectObj;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, unitArray]
[_coords,3,0,"DZMSUnitsMinor"] call DZMSAISpawn;
sleep 1;
[_coords,3,0,"DZMSUnitsMinor"] call DZMSAISpawn;
sleep 1;
[_coords,3,0,"DZMSUnitsMinor"] call DZMSAISpawn;
sleep 1;
[_coords,3,0,"DZMSUnitsMinor"] call DZMSAISpawn;
sleep 1;

//Wait until the player is within 30 meters and also meets the kill req
[_coords,"DZMSUnitsMinor"] call DZMSWaitMissionComp;

//Let everyone know the mission is over
_picture = getText (configFile >> "cfgVehicles" >> _MISSIONIMAGE >> "picture"); //this will be %1
_msg = parseText format ["
<t size='2'font='TahomaB'align='Center'color='#66CDAA'>Weapons Van</t><br/><br/>
<t align='center'><img size='7' image='%1'/></t><br/>
<t size='1'font='TahomaB'align='Center'color='#FFFFFF'>The Weapons Van has been Secured by Survivors!</t><br/>",
_picture
];

_msg remoteexec ["DZMS_Remote_Message",-2];
diag_log text format["[DZMS]: Minor SM6 Weapons Truck Mission has Ended."];
deleteMarker "DZMSMinMarker";
deleteMarker "DZMSMinDot";

//Let the timer know the mission is over
DZMSMinDone = true;