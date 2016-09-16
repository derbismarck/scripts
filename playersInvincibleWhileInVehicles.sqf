[] spawn {
	if !(isDedicated) then {
		waitUntil {time > 0; sleep 0.5};
		waitUntil {(!isNil "PABST_ADMIN_SAFESTART_public_isSafe" && {!PABST_ADMIN_SAFESTART_public_isSafe})};
		while {alive player} do {
			waitUntil {sleep 0.2; (vehicle player) == player};
			player allowDamage true;
			waitUntil {sleep 0.2; (vehicle player) != player};
			player allowDamage false;
		};
	};
};