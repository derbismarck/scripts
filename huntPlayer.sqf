//This is incomplete
private ["_param_pursuitRange","_target","_nearEI"];

_param_pursuitRange = 250;
_target = _this;



_nearEI = (getPos _target) nearObjects ["All",_param_pursuitRange];

{
	if ((side _target == _x) || (isPlayer _x)) then {
		_nearEI = _nearEI - [_x];
	};
} forEach _nearEI;