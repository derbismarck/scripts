// This script was written by Bismarck
// It is meant to block off the entire map except one area.
// Name the markers fill_1, fill_2, fill_3, etc.
private ["_markers","_found","_i"];
_markers = [];
_found = true;
_i = 1;

while {_found} do {
	if (getMarkerColor format["fill_%1",_i] != "") then {
		_markers = _markers + [format["fill_%1",_i]];
		_i = _i + 1;
	} else {
		_found = false;
	};
};

for "_i" from 0 to ((count _markers) - 1) do {
	_mrkStart = getMarkerPos (_markers select ((_i + 0) mod (count _markers)));
	_mrkMiddle = getMarkerPos (_markers select ((_i + 1) mod (count _markers)));
	_mrkEnd = getMarkerPos (_markers select ((_i + 2) mod (count _markers)));
	
	_azi1 = [_mrkStart, _mrkMiddle] call BIS_fnc_dirTo;
	_azi2 = [_mrkMiddle, _mrkEnd] call BIS_fnc_dirTo;
	_size = _mrkStart vectorDistance _mrkMiddle;
	
	_tazi1 = (-(_azi1) + 3600) mod 360;
	_tazi2 = (-(_azi2) + 3600) mod 360;
	
	_trigRektankle = (-(_azi1) + 3600) mod 360;
	_aziRektankle = _azi1 + 90;
	
	_pos1 = _mrkMiddle vectorDiff _mrkStart;
	_pos1 = _pos1 vectorMultiply 0.5;
	_pos2 = [_size * cos(_trigRektankle),_size * sin(_trigRektankle),0];
	_pos2 = _pos2 vectorMultiply 0.5;
	_posDiff = _pos1 vectorAdd _pos2;
	_finalPos = _posDiff vectorAdd _mrkStart;
	
	
	_mrk = createMarker [("mrk_blocker_" + (str _i)), _finalPos];
	_mrk setMarkerPos _finalPos;
	_mrk setMarkerColor "ColorBlack";
	_mrk setMarkerDir _aziRektankle;
	_mrk setMarkerShape "RECTANGLE";
	_mrk setMarkerSize [(_size / 2),(_size / 2)];
	_mrk setMarkerBrush "SolidFull";
	
	_azi3 = ((cos(_tazi1) + cos(_tazi2)) / 2) atan2 ((sin(_tazi1) + sin(_tazi2)) / 2);
	_trigBigRektangle = (-(_azi3) + 3600 + 90) mod 360;
	
	_size2 = 20000;
	
	_pos3 = [_size2 * (sqrt(2)) * cos(_trigBigRektangle),_size2 * (sqrt(2)) * sin(_trigBigRektangle),0];
	_pos3 = _pos3 vectorMultiply 0.5;
	_finalPos2 = _mrkMiddle vectorAdd _pos3;
	
	_mrk2 = createMarker [("mrk_blockerBig_" + (str _i)), _finalPos2];
	_mrk2 setMarkerPos _finalPos2;
	_mrk2 setMarkerColor "ColorBlack";
	_mrk2 setMarkerDir (_azi3 + 45);
	_mrk2 setMarkerShape "RECTANGLE";
	_mrk2 setMarkerSize [_size2 / 2,_size2 / 2];
	_mrk2 setMarkerBrush "SolidFull";
};