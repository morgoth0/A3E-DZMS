/*																					//
	Weapons Cache Mission by lazyink (Original Full Code by TheSzerdi & TAW_Tonic)
	New Mission Format by Vampire
	Edited by Fuchs for EMS
*/	

private ["_missName","_coords","_crate"];

//Name of the Mission
_missName = "Large Ammo Cache";

//DZMSFindPos loops BIS_fnc_findSafePos until it gets a valid result
_coords = call DZMSFindPos;

_DZMSARRAYPICS = ["LMG_Mk200_F"];
_MISSIONIMAGE = selectRandom _DZMSARRAYPICS; 

_picture = getText (configFile >> "cfgWeapons" >> _MISSIONIMAGE >> "picture"); //this will be %1
_msg = parseText format ["
<t size='2'font='TahomaB'align='Center'color='#66CDAA'>Large Ammo Cache</t><br/><br/>
<t align='center'><img size='7' image='%1'/></t><br/>
<t size='1'font='TahomaB'align='Center'color='#FFFFFF'>A gear cache has been airdropped! Secure it for yourself!</t><br/>",
_picture
];

_msg remoteexec ["DZMS_Remote_Message",-2];

//DZMSAddMajMarker is a simple script that adds a marker to the location
[_coords,_missName] ExecVM DZMSAddMajMarker;

_crate = createVehicle ["Box_NATO_AmmoVeh_F",_coords,[], 0, "CAN_COLLIDE"];

//DZMSBoxFill fills the box, DZMSProtectObj prevents it from disappearing
[_crate,"weapons2"] ExecVM DZMSBoxSetup;
[_crate] call DZMSProtectObj;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, unitArray]
[[(_coords select 0) + 0.0352,(_coords select 1) - 6.8799, 0],6,1,"DZMSUnitsMajor"] call DZMSAISpawn;
sleep 5;
[[(_coords select 0) + 0.0352,(_coords select 1) - 6.8799, 0],6,1,"DZMSUnitsMajor"] call DZMSAISpawn;
sleep 5;
[[(_coords select 0) + 0.0352,(_coords select 1) - 6.8799, 0],4,1,"DZMSUnitsMajor"] call DZMSAISpawn;
sleep 5;
[[(_coords select 0) + 0.0352,(_coords select 1) - 6.8799, 0],4,1,"DZMSUnitsMajor"] call DZMSAISpawn;
sleep 5;

//Wait until the player is within 30meters and also meets the kill req
[_coords,"DZMSUnitsMajor"] call DZMSWaitMissionComp;

//Let everyone know the mission is over
_picture = getText (configFile >> "cfgWeapons" >> _MISSIONIMAGE >> "picture"); //this will be %1
_msg = parseText format ["
<t size='2'font='TahomaB'align='Center'color='#66CDAA'>Large Ammo Cache</t><br/><br/>
<t align='center'><img size='7' image='%1'/></t><br/>
<t size='1'font='TahomaB'align='Center'color='#FFFFFF'>The gear cache has been found, nice work, enjoy the spoils!</t><br/>",
_picture
];

_msg remoteexec ["DZMS_Remote_Message",-2];
diag_log text format["[DZMS]: Major SM7 Weapon Cache Mission has Ended."];
deleteMarker "DZMSMajMarker";
deleteMarker "DZMSMajDot";

//Let the timer know the mission is over
DZMSMajDone = true;
