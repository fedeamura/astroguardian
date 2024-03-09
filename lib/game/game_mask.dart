get shipCategory => 0x00000001;

get satelliteCategory => 0x00000010;

get shipBagCategory => 0x00000100;

get particleCategory => 0x00001000;

get planetCategory => 0x00010000;

get ghostCategory => 0x00100000;


get shipMask => shipBagCategory | satelliteCategory | planetCategory;

get shipBagMask => planetCategory | shipCategory | planetCategory | satelliteCategory | particleCategory;

get satelliteMask => shipCategory | shipBagCategory | particleCategory | planetCategory;

get particleMask => satelliteCategory | shipBagCategory | planetCategory;

get planetMask => shipBagCategory | shipCategory | satelliteCategory | particleCategory;

get ghostMask => 0;
