/*
	DZMSInit.sqf by Vampire
	This is the file that every other file branches off from.
	It checks that it is safe to run, sets relations, and starts mission timers.
*/

// Error Check
if (!isServer) exitWith { diag_log text format ["[DZMS]: <ERROR> DZMS is Installed Incorrectly! DZMS is not Running!"]; };
if (!isnil("DZMSInstalled")) exitWith { diag_log text format ["[DZMS]: <ERROR> DZMS is Installed Twice or Installed Incorrectly!"]; };

// Global for other scripts to check if DZMS is installed.
DZMSInstalled = true;

diag_log text format ["[DZMS]: Starting DayZ Mission System."];

// Let's Load the Mission Configuration
call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\DZMSConfig.sqf";

// These are Extended configuration files the user can adjust if wanted
call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\ExtConfig\DZMSCrateConfig.sqf";
call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\ExtConfig\DZMSAIConfig.sqf";

// Report the version
diag_log text format ["[DZMS]: Currently Running Version: %1", DZMSVersion];

// Lets check for a copy-pasted config file
if (DZMSVersion != "3.01_A3") then {
	diag_log text format ["[DZMS]: Outdated Configuration Detected! Please Update DZMS!"];
	diag_log text format ["[DZMS]: Old Versions are not supported by the Mod Author!"];
};

diag_log text format ["[DZMS]: Mission and Extended Configuration Loaded!"];

// Lets get the map name for mission location purposes
DZMSWorldName = toLower format ["%1", worldName];
diag_log text format["[DZMS]: %1 Detected. Map Specific Settings Adjusted!", DZMSWorldName];

DZMS_Remote_Message = compilefinal "
	_this spawn {
			
		hintSilent _this;
		playSound 'RadioAmbient6';
			
	};
";
publicvariable 'DZMS_Remote_Message';

// Lets load our functions
call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\DZMSFunctions.sqf";

// these arrays are used to hold units for each mission type
DZMSUnitsMinor = [];
DZMSUnitsMajor = [];

// Let's get the clocks running!
[] ExecVM DZMSMajTimer;
[] ExecVM DZMSMinTimer;
DZMSMajDone = false;
DZMSMinDone = false;

// Let's get the Marker Re-setter running for JIPs to stay updated
[] ExecVM DZMSMarkerLoop;
