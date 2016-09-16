GV_ACT_RANGE = 1000; //how close you get before the zones activate/deactivate
GV_POP_DENSITY = 10; //civs per square kilometer

if (!hasInterface && !isDedicated) then {	//run for HC only
waitUntil {time > 0; sleep 1};

_locations = [loc1,loc2,loc3];	//names of triggers on map for each location

bsm_fnc_aziToTrig = {
	//Takes azimuth input and outputs trig angle
	//azimuth call bsm_fnc_aziToTrig;
	_azi = _this;
	_tAngle = ((0 - _azi) + 3600) mod 360;
	
	_tAngle
};

bsm_fnc_randPos = {
	//Generates a uniformly random position inside a trigger with a specific major and minor axis with some rotation theta (in bearing, not trigonometric form)
	//_trig1 call bsm_fnc_randPos;
	private ["_trig","_xSize","_ySize","_azi","_isRect","_theta","_xF","_yF"];
	_trig = _this;
	_xSize = (triggerArea _trig) select 0;
	_ySize = (triggerArea _trig) select 1;
	_azi = (triggerArea _trig) select 2;
	_isRect = (triggerArea _trig) select 3;
	
	_theta = _azi call bsm_fnc_aziToTrig;
	
	
	if _isRect then {
		//rectangle
		//1. uniform 'unit' square
		_x1 = (random 1) - 0.5;
		_y1 = (random 1) - 0.5;
		//2. stretch to rectangle
		_x2 = _x1 * _xSize * 2;
		_y2 = _y1 * _ySize * 2;
		//3. rotate point around origin by theta degrees
		_xF = (_x2 * cos(_theta)) - (_y2 * sin(_theta));
		_yF = (_x2 * sin(_theta)) + (_y2 * cos(_theta));
	} else {
		//ellipse
		//1. uniform unit circle
		_r = random 1;
		_ang = random 360;
		_x1 = _r * cos(_ang);
		_y1 = _r * sin(_ang);
		//2. stretch to ellipse
		_x2 = _x1 * _xSize;
		_y2 = _y1 * _ySize;
		//3. rotate point around origin by theta degrees
		_xF = (_x2 * cos(_theta)) - (_y2 * sin(_theta));
		_yF = (_x2 * sin(_theta)) + (_y2 * cos(_theta));
	};
	_pos = [_xF + ((getPos _trig) select 0), _yF + ((getPos _trig) select 1), 0];
	
	_pos;
};

bsm_fnc_populate = {
	//Populates within the area of a trigger
	//_trig1 call bsm_fnc_populate;
	private ["_trig","_civpool","_xSize","_ySize","_area","_civCount"];
	_trig = _this;
	_civpool = ["C_man_1"]; //list of classnames to use for civilians
	_xSize = ((triggerArea _trig) select 0) / 1000;
	_ySize = ((triggerArea _trig) select 1) / 1000;
	
	_area = pi * _xSize * _ySize;
	_civCount = round (_area / GV_POP_DENSITY);
	
	for "_i" from 1 to _civCount do {
		_pos = _trig call bsm_fnc_randPos;
	};
};

bsm_fnc_depopulate = {
	//Depopulates within the area of a trigger
	//_trig1 call bsm_fnc_depopulate;
	
	
};

bsm_fnc_isInRange = {
	//Checks if any players are within mindist of object
	//[mindist, object] call bsm_fnc_isInRange;
	params [_minDist, _obj];
	private ["_czech"];
	_czech = false;
	{
		if ((_x distance _obj) < _minDist) then {_czech = true};
	} forEach playableUnits;
	
	_czech
};

{
	_x spawn {
		private ["_loc"];
		_loc = _this;
		while {true} do {
			waitUntil {[GV_ACT_RANGE, _loc] call bsm_fnc_isInRange; sleep 10;}; //check every 10 seconds
			//is within range
			_loc call bsm_fnc_populate;
			sleep 5;
			waitUntil {!([GV_ACT_RANGE, _loc] call bsm_fnc_isInRange); sleep 10;}; //check every 10 seconds
			//is no longer within range
			_loc call bsm_fnc_depopulate;
			sleep 5;
		};
	};
} forEach _locations;
};





