_ant_a = createVehicle ["Sign_Sphere10cm_F",[5,5,0.1],[],0,"NONE"];
_ant_b = createVehicle ["Sign_Sphere10cm_F",[5,-5,0.1],[],0,"NONE"];
_ant_c = createVehicle ["Sign_Sphere10cm_F",[-5,-5,0.1],[],0,"NONE"];
_ant_d = createVehicle ["Sign_Sphere10cm_F",[-5,5,0.1],[],0,"NONE"];

sleep 0.1;

_ant_a setPos [5,5,0.1];
_ant_b setPos [5,-5,0.1];
_ant_c setPos [-5,-5,0.1];
_ant_d setPos [-5,5,0.1];

_simulationStepTime = 0.1; //run a step of the simulation every x seconds of real time
_velocity = 20; //velocity of the ants in m*s^-1
_timeStepSize = 0.005; //for every simulation step, this is how many seconds pass

[_ant_a,_ant_b,_ant_c,_ant_d,_simulationStepTime,_velocity,_timeStepSize] spawn {
	params ["_ant_a","_ant_b","_ant_c","_ant_d","_simulationStepTime","_velocity","_timeStepSize"];
	while {alive _ant_a} do {

		_ant_a_v = (getPos _ant_b) vectorDiff (getPos _ant_a);
		_ant_a_v = (vectorNormalized _ant_a_v) vectorMultiply _velocity;
		_ant_a_curPos = getPos _ant_a;
		_ant_a_newPos = ((_ant_a_v vectorMultiply _timeStepSize) vectorAdd _ant_a_curPos);
		_ant_a setPos _ant_a_newPos;
		
		_ant_b_v = (getPos _ant_c) vectorDiff (getPos _ant_b);
		_ant_b_v = (vectorNormalized _ant_b_v) vectorMultiply _velocity;
		_ant_b_curPos = getPos _ant_b;
		_ant_b_newPos = ((_ant_b_v vectorMultiply _timeStepSize) vectorAdd _ant_b_curPos);
		_ant_b setPos _ant_b_newPos;
		
		_ant_c_v = (getPos _ant_d) vectorDiff (getPos _ant_c);
		_ant_c_v = (vectorNormalized _ant_c_v) vectorMultiply _velocity;
		_ant_c_curPos = getPos _ant_c;
		_ant_c_newPos = ((_ant_c_v vectorMultiply _timeStepSize) vectorAdd _ant_c_curPos);
		_ant_c setPos _ant_c_newPos;
		
		_ant_d_v = (getPos _ant_a) vectorDiff (getPos _ant_d);
		_ant_d_v = (vectorNormalized _ant_d_v) vectorMultiply _velocity;
		_ant_d_curPos = getPos _ant_d;
		_ant_d_newPos = ((_ant_d_v vectorMultiply _timeStepSize) vectorAdd _ant_d_curPos);
		_ant_d setPos _ant_d_newPos;
		
		GV_LINES = GV_LINES + [[_ant_a_curPos,_ant_a_newPos]];
		GV_LINES = GV_LINES + [[_ant_b_curPos,_ant_b_newPos]];
		GV_LINES = GV_LINES + [[_ant_c_curPos,_ant_c_newPos]];
		GV_LINES = GV_LINES + [[_ant_d_curPos,_ant_d_newPos]];
		
		
		sleep _simulationStepTime;
	};
};

GV_LINES = [];
addMissionEventHandler ["Draw3D", {
	{drawLine3D [_x select 0, _x select 1, [1,0,0,1]]} forEach GV_LINES;
}];
