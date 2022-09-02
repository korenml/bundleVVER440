//------------------------------------------
// Name: Simple pinHole
// Autor: Tomas Korinek
// Date: 3.2.2022
// version: 2 - fuel, cladding, void included
//			1-  simple hole
//------------------------------------------

Macro pinHole
	// Cladding
	
	// inner lines
	pinPointC = newp; Point(pinPointC) = {x,y,z,lcHole};
	pinPointCout[0] = newp; Point(pinPointCout[0]) = {x+rCOut,y,z,lcHole};
	pinPointCout[1] = newp; Point(pinPointCout[1]) = {x,y+rCOut,z,lcHole};
	pinPointCout[2] = newp; Point(pinPointCout[2]) = {x-rCOut,y,z,lcHole};
	pinPointCout[3] = newp; Point(pinPointCout[3]) = {x,y-rCOut,z,lcHole};
	circPinCout[0] = newc; Circle(circPinCout[0]) = {pinPointCout[0],pinPointC,pinPointCout[1]};
	circPinCout[1] = newc; Circle(circPinCout[1]) = {pinPointCout[1],pinPointC,pinPointCout[2]};
	circPinCout[2] = newc; Circle(circPinCout[2]) = {pinPointCout[2],pinPointC,pinPointCout[3]};
	circPinCout[3] = newc; Circle(circPinCout[3]) = {pinPointCout[3],pinPointC,pinPointCout[0]};
	
	// outer lines
	pinPointCin[0] = newp; Point(pinPointCin[0]) = {x+rCIn,y,z,lcHole};
	pinPointCin[1] = newp; Point(pinPointCin[1]) = {x,y+rCIn,z,lcHole};
	pinPointCin[2] = newp; Point(pinPointCin[2]) = {x-rCIn,y,z,lcHole};
	pinPointCin[3] = newp; Point(pinPointCin[3]) = {x,y-rCIn,z,lcHole};
	circPinCin[0] = newc; Circle(circPinCin[0]) = {pinPointCin[0],pinPointC,pinPointCin[1]};
	circPinCin[1] = newc; Circle(circPinCin[1]) = {pinPointCin[1],pinPointC,pinPointCin[2]};
	circPinCin[2] = newc; Circle(circPinCin[2]) = {pinPointCin[2],pinPointC,pinPointCin[3]};
	circPinCin[3] = newc; Circle(circPinCin[3]) = {pinPointCin[3],pinPointC,pinPointCin[0]};
	
	// inter lines
	lineInterClad[0] = newll; Line(lineInterClad[0]) = {pinPointCin[0],pinPointCout[0]};
	lineInterClad[1] = newll; Line(lineInterClad[1]) = {pinPointCin[1],pinPointCout[1]};
	lineInterClad[2] = newll; Line(lineInterClad[2]) = {pinPointCin[2],pinPointCout[2]};
	lineInterClad[3] = newll; Line(lineInterClad[3]) = {pinPointCin[3],pinPointCout[3]};

	Transfinite Line {circPinCin[0]} = nD4;
	Transfinite Line {circPinCin[1]} = nD4;
	Transfinite Line {circPinCin[2]} = nD4;
	Transfinite Line {circPinCin[3]} = nD4;
	
	Transfinite Line {circPinCout[0]} = nD4;
	Transfinite Line {circPinCout[1]} = nD4;
	Transfinite Line {circPinCout[2]} = nD4;
	Transfinite Line {circPinCout[3]} = nD4;
		
	Transfinite Line {lineInterClad[0]} = nInterClad;
	Transfinite Line {lineInterClad[1]} = nInterClad;
	Transfinite Line {lineInterClad[2]} = nInterClad;
	Transfinite Line {lineInterClad[3]} = nInterClad;
	
	innerCladLoops[0] = newl; Curve Loop(innerCladLoops[0]) = {lineInterClad[0],circPinCout[0],-lineInterClad[1],-circPinCin[0]};
	innerCladLoops[1] = newl; Curve Loop(innerCladLoops[1]) = {lineInterClad[1],circPinCout[1],-lineInterClad[2],-circPinCin[1]};
	innerCladLoops[2] = newl; Curve Loop(innerCladLoops[2]) = {lineInterClad[2],circPinCout[2],-lineInterClad[3],-circPinCin[2]};
	innerCladLoops[3] = newl; Curve Loop(innerCladLoops[3]) = {lineInterClad[3],circPinCout[3],-lineInterClad[0],-circPinCin[3]};
	
	For j In {0:3}
		pinCladSurf[j] = news; Surface(pinCladSurf[j]) = {innerCladLoops[j]};
		Recombine Surface{pinCladSurf[j]};
		Transfinite Surface{pinCladSurf[j]};
	EndFor

	pinCladLoops[t] = newl;
	Curve Loop(pinCladLoops[t]) = {circPinCout[0],circPinCout[1],circPinCout[2],circPinCout[3]};

		
	// Fuel
	
	pinPointFin[0] = newp; Point(pinPointFin[0]) = {x+rFIn,y,z,lcHole};
	pinPointFin[1] = newp; Point(pinPointFin[1]) = {x,y+rFIn,z,lcHole};
	pinPointFin[2] = newp; Point(pinPointFin[2]) = {x-rFIn,y,z,lcHole};
	pinPointFin[3] = newp; Point(pinPointFin[3]) = {x,y-rFIn,z,lcHole};
	circPinFin[0] = newc; Circle(circPinFin[0]) = {pinPointFin[0],pinPointC,pinPointFin[1]};
	circPinFin[1] = newc; Circle(circPinFin[1]) = {pinPointFin[1],pinPointC,pinPointFin[2]};
	circPinFin[2] = newc; Circle(circPinFin[2]) = {pinPointFin[2],pinPointC,pinPointFin[3]};
	circPinFin[3] = newc; Circle(circPinFin[3]) = {pinPointFin[3],pinPointC,pinPointFin[0]};
	
	// Fuel inter lines
	lineInterFuel[0] = newll; Line(lineInterFuel[0]) = {pinPointFin[0],pinPointCin[0]};
	lineInterFuel[1] = newll; Line(lineInterFuel[1]) = {pinPointFin[1],pinPointCin[1]};
	lineInterFuel[2] = newll; Line(lineInterFuel[2]) = {pinPointFin[2],pinPointCin[2]};
	lineInterFuel[3] = newll; Line(lineInterFuel[3]) = {pinPointFin[3],pinPointCin[3]};
	
	For j In {0:3}
		Transfinite Line {lineInterFuel[j]} = nInterFuel;
		Transfinite Line {circPinFin[j]} = nD4;
	EndFor
	
	innerFuelLoops[0] = newl; Curve Loop(innerFuelLoops[0]) = {lineInterFuel[0],circPinCin[0],-lineInterFuel[1],-circPinFin[0]};
	innerFuelLoops[1] = newl; Curve Loop(innerFuelLoops[1]) = {lineInterFuel[1],circPinCin[1],-lineInterFuel[2],-circPinFin[1]};
	innerFuelLoops[2] = newl; Curve Loop(innerFuelLoops[2]) = {lineInterFuel[2],circPinCin[2],-lineInterFuel[3],-circPinFin[2]};
	innerFuelLoops[3] = newl; Curve Loop(innerFuelLoops[3]) = {lineInterFuel[3],circPinCin[3],-lineInterFuel[0],-circPinFin[3]};
	
	For j In {0:3}
		pinFuelSurf[j] = news; Surface(pinFuelSurf[j]) = {innerFuelLoops[j]};
		Recombine Surface{pinFuelSurf[j]};
		Transfinite Surface{pinFuelSurf[j]};
	EndFor	
	Field[t] = BoundaryLayer;
	Field[t].CurvesList = {circPinCout[]};
	Field[t].ExcludedSurfacesList = {pinCladSurf[]};
	Field[t].NbLayers = 4;
	Field[t].Size = 1e-4;
	//Field[t].SizeFar = 5e-4;
	Field[t].Ratio = 1.2;
	Field[t].Thickness = ThickBL;

	BoundaryLayer Field = t;
	For j In {0:3}
		CsurfaceVector[]=Extrude {0, 0, zmax} {
		 Surface{pinCladSurf[j]};
		 Layers{nZ};
		 Recombine;
		};
		FsurfaceVector[]=Extrude {0, 0, zmax} {
		 Surface{pinFuelSurf[j]};
		 Layers{nZ};
		 Recombine;
		};
		If ((t == 0) && (j == 0))
			//Printf("Pin: %g", t);
			//Physical Volume("cladding") = CsurfaceVector[1];
//			Physical Volume("fuel") = FsurfaceVector[1];	
		Else
			//Printf("Pin other: %g", t);
			//Physical Volume("cladding") += CsurfaceVector[1];
//			Physical Volume("fuel") += FsurfaceVector[1];		
		EndIf


		
		
	/*
	FtopSurface[j] = WsurfaceVector[0];
	FvolumeFluid[j] = WsurfaceVector[1];
	FcylinderSurface[j] = WsurfaceVector[5];
	FhexSurface[j] = WsurfaceVector[3];
	*/
	
	EndFor
	
Return



