//------------------------------------------
// Name: VVER-440 fuel assembly
// Autor: Tomas Korinek
// Last update: 6.9.2022
// Version: 3 - region type selection
//			2 - physical surfaces and volumes added
//			1 - basic 2D mesh for script debuging
//------------------------------------------
General.ExpertMode = 1;
Mesh.Algorithm = 8;


// region:
//	0 - multiregion
//	1 - coolant
//	2 - cladding
//	3 - fuel

region = 1;

nFA = 126 - 1; // max 126 fuel pin, index start from 0

// origin of fuel assembly
origXFA = 0;
origYFA = 0;

// fuel pin pitch
pitch = 1.2300 * 1e-2;

// cladding outer diameter
rCOut = 0.4575 * 1e-2;
// cladding inner diameter
rCIn  = 0.3945 * 1e-2;
// fuel outer diameter
rFOut = 0.3785 * 1e-2;
// fuel inner diameter
rFIn  = 0.0700 * 1e-2;

// center tube
rCenterOut = 0.515 * 1e-2;
rCenterIn = 0.44 * 1e-2;

// grid sizes
lc1 = 0.0025;
lc2 = 0.001;
lcHole = 0.001;

pi = 3.14159265359;

// spacing for Transfinite
nD4 = 8;
nInterClad = 2;  //4
nInterCenter = 2;  //4
nInterVoidFC = 2; 
nInterFuel = 2; //10
nInterVoid = 2; 
voidCirc = 0;

//Boundary layer thickness
ThickBL = 0.5e-3;
ThickBLS = 0.7e-3;
// height
zmax = 2.48;

//number of axial layers
nZ = 5;
// Outer hexagonal shroud

hexr = 7.1 * 1e-2;
hexR = 2*hexr/Sqrt(3);

// Creation of shroud
hexP1 = newp; Point(hexP1) = {origXFA + hexR, origYFA, 0, lc1};
hexP2 = newp; Point(hexP2) = {origXFA + hexR/2, origYFA + hexr, 0, lc1};
hexP3 = newp; Point(hexP3) = {origXFA - hexR/2, origYFA + hexr, 0, lc1};
hexP4 = newp; Point(hexP4) = {origXFA - hexR, origYFA, 0, lc1};
hexP5 = newp; Point(hexP5) = {origXFA - hexR/2, origYFA - hexr, 0, lc1};
hexP6 = newp; Point(hexP6) = {origXFA + hexR/2, origYFA - hexr, 0, lc1};

hexL1 = newll; Line(hexL1) = {hexP1,hexP2};
hexL2 = newll; Line(hexL2) = {hexP2,hexP3};
hexL3 = newll; Line(hexL3) = {hexP3,hexP4};
hexL4 = newll; Line(hexL4) = {hexP4,hexP5};
hexL5 = newll; Line(hexL5) = {hexP5,hexP6};
hexL6 = newll; Line(hexL6) = {hexP6,hexP1};
curveFluid = newl; Curve Loop(curveFluid) = {hexL1,hexL2,hexL3,hexL4,hexL5,hexL6};

// Fuel pins 
Include "pinHole_alter.geo";
// Center hole
Include "pinHole_center.geo";

pitchH = pitch * 0.5;
pitchY = pitch*0.5*Tan(pi/3);

// Fuel pins coordinates
Include "Coords.geo";


// Create fuel pins
t = 0;
For i In {0:nFA} //126
	x = origXFA + X[i];
	y = origYFA +Y[i];
	z = 0.0;

		
	Call pinHole;

	t += 1;
EndFor
Printf("Number of fuel pins: %g", t);

// create center hole pin
x = origXFA;
y = origYFA;
Call pinHole_center;
Printf("Center pin");
// Main coolant surface
surfFAins = news; Plane Surface(surfFAins) = {curveFluid, pinCladLoops[],pinCenterLoops};
Recombine Surface{surfFAins};

// coolant in center hole
surfCenter = news; Plane Surface(surfCenter) = {innerCenterLoopsCool};
Recombine Surface{surfCenter};

// Boundary layer for center pin
Field[1000] = BoundaryLayer;
Field[1000].CurvesList = {circPinCenterCout[]};
Field[1000].ExcludedSurfacesList = {pinCenterSurf[]};
Field[1000].NbLayers = 4;
Field[1000].Size = 2e-4;
//Field[1].SizeFar = 5e-4;
Field[1000].Ratio = 1.2;
Field[1000].Thickness = ThickBL;
BoundaryLayer Field = 1000;

// Boundary layer for shroud
Field[2000] = BoundaryLayer;
Field[2000].CurvesList = {hexL1,hexL2,hexL3,hexL4,hexL5,hexL6};
//Field[2000].ExcludedSurfacesList = {pinCenterSurf[]};
Field[2000].NbLayers = 3;
Field[2000].Size = 2e-4;
//Field[2000].SizeFar = 5e-4;
Field[2000].Ratio = 1.2;
Field[2000].Thickness = ThickBLS;
BoundaryLayer Field = 2000;

// Extrude coolant region
WsurfaceVector[]=Extrude {0, 0, zmax} {
 Surface{surfFAins};
 Layers{nZ};
 Recombine;
};

// Extrude coolant center region
WCsurfaceVector[]=Extrude {0, 0, zmax} {
 Surface{surfCenter};
 Layers{nZ};
 Recombine;
};

If ((region == 1) || (region == 0))
	Printf("Creating volume region for coolant.");
	Physical Volume("coolant") = WsurfaceVector[1];
	Physical Volume("coolant") += WCsurfaceVector[1];
EndIf


// first pin
Physical Surface("zmin") = {24,25,26,27};

Physical Surface("zmin") += {41, 42, 43, 44};
Physical Surface("cladding_to_coolant") = {57,101,145,189};
Physical Surface("cladding_to_fuel") = {65,109,153,197};
Physical Surface("fuel_to_void") = {87,131,175,219};
Physical Surface("zmax") = {66,110,154,198};
Physical Surface("zmax") += {88,132,176,220};

//center pin 476
Physical Surface("zmin") += {332+nFA*213};
Physical Surface("zmax") += {426+nFA*233};
Physical Surface("zmin") += {238+nFA*213,239+nFA*213,240+nFA*213,241+nFA*213};
Physical Surface("zmax") += {264+nFA*213,286+nFA*213,308+nFA*213,330+nFA*213};
Physical Surface("cladding_to_coolant") += {255+nFA*213,277+nFA*213,299+nFA*213,321+nFA*213};
Physical Surface("cladding_to_coolant") += {263+nFA*213,285+nFA*213,307+nFA*213,329+nFA*213};


For j In {0:nFA}
	For i In {0:3}
		Physical Surface("zmin") += {24+i+j*213};
		Physical Surface("zmin") += {41+i+j*213};
		Physical Surface("zmax") += {66+i*44+j*213};
		Physical Surface("zmax") += {88+i*44+j*213};
		Physical Surface("cladding_to_coolant") += {57+i*44+j*213};
		Physical Surface("cladding_to_fuel") += {65+i*44+j*213};
		Physical Surface("fuel_to_void") += {87+i*44+j*213};
	
	EndFor
EndFor
Physical Surface("zmin") += {331 +nFA*213};
Physical Surface("zmax") += {404 +nFA*233};

Physical Surface("xmaxR") = {351 +nFA*217};
Physical Surface("ymax") = {355 +nFA*217};
Physical Surface("xmaxL") = {359 +nFA*217};
Physical Surface("xminL") = {363 +nFA*217};
Physical Surface("ymin") = {367 +nFA*217};
Physical Surface("xminR") = {371 +nFA*217};

