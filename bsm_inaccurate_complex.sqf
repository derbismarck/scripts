_bsm_fnc_randomDeviation = {
	params ["_vector","_unit"];
	private _deviation = 0;
	
	_n = vectorNormalized _vector;	//axis of rotation
	_vMag = vectorMagnitude _vector;
	
	_vX = _vector select 0;
	_vY = _vector select 1;
	_vZ = _vector select 2;
	
	_nX = _n select 0;				//axis of rotation
	_nY = _n select 1;				//axis of rotation
	_nZ = _n select 2;				//axis of rotation
	_theta = _vY atan2 _vX;
	_phi = -acos (_vZ / _vMag);
	_phiNew = if (_phi >= 0) then {_phi + 90} else {_phi - 90};	//rotate to be perpendicular to our normalized velocity vector
	
	_pX = cos(_theta) * cos(_phi);	//point (vector) to rotate
	_pY = sin(_theta) * cos(_phi);	//point (vector) to rotate
	_pZ = sin(_phi);					//point (vector) to rotate
	
	_theta = random 360;
	_cosTheta = cos _theta;
	_sinTheta = sin _theta;
	/*
	_Pmatrix = [
		_pX,
		_pY,
		_pZ
	];
	
	_Rmatrix = [
		[(_cosTheta + ((_nX ^ 2) * (1 - _cosTheta))),				((_nX * _nY) * (1 - _cosTheta) - (_nZ * _sinTheta)),		((_nX * _nZ) * (1 - _cosTheta) + (_nY * _sinTheta))],
		[((_nY * _nX) * (1 - _cosTheta) + (_nZ * _sinTheta)),		(_cosTheta + ((_nY ^ 2) * (1 - _cosTheta))),				((_nY * _nZ) * (1 - _cosTheta) - (_nX * _sinTheta))],
		[((_nZ * _nX) * (1 - _cosTheta) - (_nY * _sinTheta)),		((_nZ * _nY) * (1 - _cosTheta) + (_nX * _sinTheta)),		(_cosTheta + ((_nZ ^ 2) * (1 - _cosTheta)))			]
	];
	*/
	//_Ematrix = _Pmatrix x _Rmatrix; <--cross product
	_Ematrix = [
		(_pZ * ((_nZ * _nX) * (1 - _cosTheta) - (_nY * _sinTheta))) + (_pY * ((_nY * _nX) * (1 - _cosTheta) + (_nZ * _sinTheta))) + (_pX * (_cosTheta + ((_nX ^ 2) * (1 - _cosTheta)))),
		(_pY * (_cosTheta + ((_nY ^ 2) * (1 - _cosTheta)))) + (_pZ * ((_nZ * _nY) * (1 - _cosTheta) + (_nX * _sinTheta))) + (_pX * ((_nX * _nY) * (1 - _cosTheta) - (_nZ * _sinTheta))),
		(_pY * ((_nY * _nZ) * (1 - _cosTheta) - (_nX * _sinTheta))) + (_pZ * (_cosTheta + ((_nZ ^ 2) * (1 - _cosTheta)))) + (_pX * ((_nX * _nZ) * (1 - _cosTheta) + (_nY * _sinTheta)))
	];
	
	_x = random (_vMag * (27 / 100));
	_deviation = (_x) ^ (1 / 3);
	
	_qVector = _Ematrix;
	_qVector = _qVector vectorMultiply _deviation;
	
	_resultant = _qVector vectorAdd _vector;
	_resultant
};


_bsm_fnc_inaccurate = {
	_proj = _this select 6;
	_rVector = [velocity _proj,_this select 0] call _bsm_fnc_randomDeviation;
	_proj setVelocity _rVector;
};


player addEventHandler ["fired",bsm_fnc_inaccurate];