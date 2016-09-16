bsm_fnc_inaccurate = {
	_deviation = 20;
	_proj = _this select 6;
	_rx = (random _deviation) - ((_deviation) / 2);
	_ry = (random _deviation) - ((_deviation) / 2);
	_rz = (random _deviation) - ((_deviation) / 2);
	_vX = _rx + ((velocity _proj) select 0);
	_vY = _ry + ((velocity _proj) select 1);
	_vZ = _rz + ((velocity _proj) select 2);
	_newVelocity = [_vX, _vY, _vZ];
	_proj setVelocity _newVelocity;
};

vehicleNameHere addEventHandler ["fired",bsm_fnc_inaccurate];