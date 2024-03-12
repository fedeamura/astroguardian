get shipCategory => 0x00000001;

get satelliteCategory => 0x00000010;

get particleCategory => 0x00001000;

get planetCategory => 0x00010000;

get ghostCategory => 0x00100000;

get shipMask => satelliteCategory | planetCategory;

get shipNoSatelliteMask => planetCategory;

get satelliteMask => shipCategory | particleCategory | planetCategory;

get particleMask => satelliteCategory | planetCategory;

get planetMask => shipCategory | satelliteCategory | particleCategory;

get ghostMask => 0;
