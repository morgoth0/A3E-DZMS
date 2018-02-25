/*
	Bandit Hunting Party by lazyink (Full credit to TheSzerdi & TAW_Tonic for the code)
	Updated to new format by Vampire
*/
private ["_missName","_coords","_vehicle","_DZMSARRAYPICS","_MISSIONIMAGE","_msg"];

//Name of the Mission
_missName = "Bandit Squad";

//DZMSFindPos loops BIS_fnc_findSafePos until it gets a valid result
_coords = call DZMSFindPos;

_DZMSARRAYPICS = ["akm_EPOCH"];
_MISSIONIMAGE = selectRandom _DZMSARRAYPICS; 

_picture = getText (configFile >> "cfgWeapons" >> _MISSIONIMAGE >> "picture"); //this will be %1
_msg = parseText format ["
<t size='2'font='TahomaB'align='Center'color='#66CDAA'>Bandit Squad</t><br/><br/>
<t align='center'><img size='7' image='%1'/></t><br/>
<t size='1'font='TahomaB'align='Center'color='#FFFFFF'>A Bandit Squad has been spotted! Stop them from completing their patrol!</t><br/>",
_picture
];

_msg remoteexec ["DZMS_Remote_Message",-2];

//DZMSAddMinMarker is a simple script that adds a marker to the location
[_coords,_missName] ExecVM DZMSAddMinMarker;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, unitArray]
[_coords,2,1,"DZMSUnitsMinor"] call DZMSAISpawn;
sleep 5;
[_coords,2,1,"DZMSUnitsMinor"] call DZMSAISpawn;
sleep 5;
[_coords,2,1,"DZMSUnitsMinor"] call DZMSAISpawn;
sleep 5;
[_coords,2,1,"DZMSUnitsMinor"] call DZMSAISpawn;
sleep 1;

//Wait until the player is within 30 meters and also meets the kill req
[_coords,"DZMSUnitsMinor"] call DZMSWaitMissionComp;

//Let everyone know the mission is over
_picture = getText (configFile >> "cfgWeapons" >> _MISSIONIMAGE >> "picture"); //this will be %1
_msg = parseText format ["
<t size='2'font='TahomaB'align='Center'color='#66CDAA'>Bandit Squad</t><br/><br/>
<t align='center'><img size='7' image='%1'/></t><br/>
<t size='1'font='TahomaB'align='Center'color='#FFFFFF'>The Bandit Squad has been wiped out!</t><br/>",
_picture
];

_msg remoteexec ["DZMS_Remote_Message",-2];

diag_log text format["[DZMS]: Minor SM1 Bandit Squad Mission has Ended."];
deleteMarker "DZMSMinMarker";
deleteMarker "DZMSMinDot";

//Let the timer know the mission is over
DZMSMinDone = true;