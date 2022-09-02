//------------------------------------------
// Name: VVER-440 fuel assembly
// Autor: Tomas Korinek
// Last update: 31.8.2022
//------------------------------------------
General.ExpertMode = 1;
Mesh.Algorithm = 8;

nFA = 126 - 1; // max 126

origXFA = 0;
origYFA = 0;

pitch = 1.2300 * 1e-2;
rCOut = 0.4575 * 1e-2;
rCIn  = 0.3945 * 1e-2;
rFOut = 0.3785 * 1e-2;
rFIn  = 0.0700 * 1e-2;

rCenterOut = 0.515 * 1e-2;
rCenterIn = 0.44 * 1e-2;

lc1 = 0.0025;
lc2 = 0.001;
lcHole = 0.001;

pi = 3.14159265359;

nD4 = 8;
nInterClad = 4; 
nInterCenter = 4; 
nInterVoidFC = 2; 
nInterFuel = 10;
nInterVoid = 2; 
voidCirc = 0;

ThickBL = 0.5e-3;

zmax = 2.48;
nZ = 25;
// Outer hexagonal shroud

hexr = 0.5*14.7 * 1e-2;
hexR = 2*hexr/Sqrt(3);

hexP1 = newp; Point(hexP1) = {hexR,0,0,lc1};
hexP2 = newp; Point(hexP2) = {hexR/2,hexr,0,lc1};
hexP3 = newp; Point(hexP3) = {-hexR/2,hexr,0,lc1};
hexP4 = newp; Point(hexP4) = {-hexR,0,0,lc1};
hexP5 = newp; Point(hexP5) = {-hexR/2,-hexr,0,lc1};
hexP6 = newp; Point(hexP6) = {hexR/2,-hexr,0,lc1};

hexL1 = newll; Line(hexL1) = {hexP1,hexP2};
hexL2 = newll; Line(hexL2) = {hexP2,hexP3};
hexL3 = newll; Line(hexL3) = {hexP3,hexP4};
hexL4 = newll; Line(hexL4) = {hexP4,hexP5};
hexL5 = newll; Line(hexL5) = {hexP5,hexP6};
hexL6 = newll; Line(hexL6) = {hexP6,hexP1};

curveFluid = newl; Curve Loop(curveFluid) = {hexL1,hexL2,hexL3,hexL4,hexL5,hexL6};

// Fuel pins 
Include "pinHole_alter.geo";
Include "pinHole_center.geo";

pitchH = pitch * 0.5;
pitchY = pitch*0.5*Tan(pi/3);
Include "Coords.geo";


// create fuel pins
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
x = 0;
y = 0;
Call pinHole_center;

surfFAins = news; Plane Surface(surfFAins) = {curveFluid, pinCladLoops[],pinCenterLoops};
Recombine Surface{surfFAins};

// Boundary layer for center pin
Field[1000] = BoundaryLayer;
Field[1000].CurvesList = {circPinCenterCout[]};
Field[1000].ExcludedSurfacesList = {pinCenterSurf[]};
Field[1000].NbLayers = 4;
Field[1000].Size = 1e-4;
//Field[1].SizeFar = 5e-4;
Field[1000].Ratio = 1.2;
Field[1000].Thickness = ThickBL;
BoundaryLayer Field = 1000;

// Boundary layer for shroud
Field[2000] = BoundaryLayer;
Field[2000].CurvesList = {hexL1,hexL2,hexL3,hexL4,hexL5,hexL6};
//Field[2000].ExcludedSurfacesList = {pinCenterSurf[]};
Field[2000].NbLayers = 4;
Field[2000].Size = 1e-4;
//Field[2000].SizeFar = 5e-4;
Field[2000].Ratio = 1.2;
Field[2000].Thickness = ThickBL;

BoundaryLayer Field = 2000;

// Extrude coolant region
WsurfaceVector[]=Extrude {0, 0, zmax} {
 Surface{surfFAins};
 Layers{nZ};
 Recombine;
};

Physical Volume("coolant") = WsurfaceVector[1];

// first pin
Physical Surface("zmin") = {24,25,26,27};
Physical Surface("zmin") += {41, 42, 43, 44};
Physical Surface("cladding_to_coolant") = {57,101,145,189};
Physical Surface("zmax") = {66,110,154,198};
Physical Surface("zmax") += {88,132,176,220};

//center pin 476
Physical Surface("zmin") += {237+nFA*213,238+nFA*213,239+nFA*213,240+nFA*213};
Physical Surface("zmax") += {263+nFA*213,285+nFA*213,307+nFA*213,329+nFA*213};
Physical Surface("cladding_to_coolant") += {254+nFA*213,276+nFA*213,298+nFA*213,320+nFA*213};


For j In {0:nFA}
	For i In {0:3}
		Physical Surface("zmin") += {24+i+j*213};
		Physical Surface("zmin") += {41+i+j*213};
		Physical Surface("zmax") += {66+i*44+j*213};
		Physical Surface("zmax") += {88+i*44+j*213};
		Physical Surface("cladding_to_coolant") += {57+i*44+j*213};
	
	EndFor
EndFor
Physical Surface("zmin") += {330 +nFA*213};
Physical Surface("zmax") += {402 +nFA*233};

Physical Surface("xmaxR") = {349 +nFA*217};
Physical Surface("ymax") = {353 +nFA*217};
Physical Surface("xmaxL") = {357 +nFA*217};
Physical Surface("xminL") = {361 +nFA*217};
Physical Surface("ymin") = {365 +nFA*217};
Physical Surface("xminR") = {369 +nFA*217};
/*
Mesh.Algorithm = 6;
MeshAlgorithm Surface {1} = 1;

Physical Curve("Outer") = {1};
Physical Curve("Inner") = {l1};
Physical Surface("domain") = {1};
Save "bundle.unv";
//Recombine Surface{s1}
*/
