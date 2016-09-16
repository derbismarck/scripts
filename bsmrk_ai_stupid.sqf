{
	if !(isPlayer _x) then {
		_x setSkill ["aimingAccuracy",0];
		_x setSkill ["aimingShake",1];
		_x setSkill ["aimingSpeed",1];
		_x setSkill ["endurance",1];
		_x setSkill ["spotDistance",0.1];
		_x setSkill ["spotTime",0.1];
		_x setSkill ["reloadSpeed",0];
		_x setSkill ["commanding",0];
	};
} forEach allUnits;