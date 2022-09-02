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
	pinPointCout1 = newp; Point(pinPointCout1) = {x+rCOut,y,z,lcHole};
	pinPointCout2 = newp; Point(pinPointCout2) = {x,y+rCOut,z,lcHole};
	pinPointCout3 = newp; Point(pinPointCout3) = {x-rCOut,y,z,lcHole};
	pinPointCout4 = newp; Point(pinPointCout4) = {x,y-rCOut,z,lcHole};
	circPinCout1 = newc; Circle(circPinCout1) = {pinPointCout1,pinPointC,pinPointCout2};
	circPinCout2 = newc; Circle(circPinCout2) = {pinPointCout2,pinPointC,pinPointCout3};
	circPinCout3 = newc; Circle(circPinCout3) = {pinPointCout3,pinPointC,pinPointCout4};
	circPinCout4 = newc; Circle(circPinCout4) = {pinPointCout4,pinPointC,pinPointCout1};
	
	// outer lines
	pinPointCin1 = newp; Point(pinPointCin1) = {x+rCIn,y,z,lcHole};
	pinPointCin2 = newp; Point(pinPointCin2) = {x,y+rCIn,z,lcHole};
	pinPointCin3 = newp; Point(pinPointCin3) = {x-rCIn,y,z,lcHole};
	pinPointCin4 = newp; Point(pinPointCin4) = {x,y-rCIn,z,lcHole};
	circPinCin1 = newc; Circle(circPinCin1) = {pinPointCin1,pinPointC,pinPointCin2};
	circPinCin2 = newc; Circle(circPinCin2) = {pinPointCin2,pinPointC,pinPointCin3};
	circPinCin3 = newc; Circle(circPinCin3) = {pinPointCin3,pinPointC,pinPointCin4};
	circPinCin4 = newc; Circle(circPinCin4) = {pinPointCin4,pinPointC,pinPointCin1};
	
	// inter lines
	lineInterClad1 = newll; Line(lineInterClad1) = {pinPointCin1,pinPointCout1};
	lineInterClad2 = newll; Line(lineInterClad2) = {pinPointCin2,pinPointCout2};
	lineInterClad3 = newll; Line(lineInterClad3) = {pinPointCin3,pinPointCout3};
	lineInterClad4 = newll; Line(lineInterClad4) = {pinPointCin4,pinPointCout4};

	Transfinite Line {circPinCin1} = nD4;
	Transfinite Line {circPinCin2} = nD4;
	Transfinite Line {circPinCin3} = nD4;
	Transfinite Line {circPinCin4} = nD4;
	
	Transfinite Line {circPinCout1} = nD4;
	Transfinite Line {circPinCout2} = nD4;
	Transfinite Line {circPinCout3} = nD4;
	Transfinite Line {circPinCout4} = nD4;
		
	Transfinite Line {lineInterClad1} = nInterClad;
	Transfinite Line {lineInterClad2} = nInterClad;
	Transfinite Line {lineInterClad3} = nInterClad;
	Transfinite Line {lineInterClad4} = nInterClad;
	
	innerCladLoops[0] = newl; Curve Loop(innerCladLoops[0]) = {lineInterClad1,circPinCout1,-lineInterClad2,-circPinCin1};
	innerCladLoops[1] = newl; Curve Loop(innerCladLoops[1]) = {lineInterClad2,circPinCout2,-lineInterClad3,-circPinCin2};
	innerCladLoops[2] = newl; Curve Loop(innerCladLoops[2]) = {lineInterClad3,circPinCout3,-lineInterClad4,-circPinCin3};
	innerCladLoops[3] = newl; Curve Loop(innerCladLoops[3]) = {lineInterClad4,circPinCout4,-lineInterClad1,-circPinCin4};
	
	For j In {0:3}
		pinCladSurf[j] = news; Surface(pinCladSurf[j]) = {innerCladLoops[j]};
		Recombine Surface{pinCladSurf[j]};
		Transfinite Surface{pinCladSurf[j]};
	EndFor

	pinCladLoops[t] = newl;
	Curve Loop(pinCladLoops[t]) = {circPinCout1,circPinCout2,circPinCout3,circPinCout4};

	// Void FC
	
	// Fuel outer lines
	pinPointFout[0] = newp; Point(pinPointFout[0]) = {x+rFOut,y,z,lcHole};
	pinPointFout[1] = newp; Point(pinPointFout[1]) = {x,y+rFOut,z,lcHole};
	pinPointFout[2] = newp; Point(pinPointFout[2]) = {x-rFOut,y,z,lcHole};
	pinPointFout[3] = newp; Point(pinPointFout[3]) = {x,y-rFOut,z,lcHole};
	circPinFout[0] = newc; Circle(circPinFout[0]) = {pinPointFout[0],pinPointC,pinPointFout[1]};
	circPinFout[1] = newc; Circle(circPinFout[1]) = {pinPointFout[1],pinPointC,pinPointFout[2]};
	circPinFout[2] = newc; Circle(circPinFout[2]) = {pinPointFout[2],pinPointC,pinPointFout[3]};
	circPinFout[3] = newc; Circle(circPinFout[3]) = {pinPointFout[3],pinPointC,pinPointFout[0]};
	
	// Void FC inter lines
	lineInterVoidFC[0] = newll; Line(lineInterVoidFC[0]) = {pinPointFout[0],pinPointCin1};
	lineInterVoidFC[1] = newll; Line(lineInterVoidFC[1]) = {pinPointFout[1],pinPointCin2};
	lineInterVoidFC[2] = newll; Line(lineInterVoidFC[2]) = {pinPointFout[2],pinPointCin3};
	lineInterVoidFC[3] = newll; Line(lineInterVoidFC[3]) = {pinPointFout[3],pinPointCin4};

	For j In {0:3}
		Transfinite Line {lineInterVoidFC[j]} = nInterVoidFC;
		Transfinite Line {circPinFout[j]} = nD4;
	EndFor
	
	innerVoidFCLoops[0] = newl; Curve Loop(innerVoidFCLoops[0]) = {lineInterVoidFC[0],circPinCin1,-lineInterVoidFC[1],-circPinFout[0]};
	innerVoidFCLoops[1] = newl; Curve Loop(innerVoidFCLoops[1]) = {lineInterVoidFC[1],circPinCin2,-lineInterVoidFC[2],-circPinFout[1]};
	innerVoidFCLoops[2] = newl; Curve Loop(innerVoidFCLoops[2]) = {lineInterVoidFC[2],circPinCin3,-lineInterVoidFC[3],-circPinFout[2]};
	innerVoidFCLoops[3] = newl; Curve Loop(innerVoidFCLoops[3]) = {lineInterVoidFC[3],circPinCin4,-lineInterVoidFC[0],-circPinFout[3]};
	
	For j In {0:3}
		pinVoidFCSurf[j] = news; Surface(pinVoidFCSurf[j]) = {innerVoidFCLoops[j]};
		Recombine Surface{pinVoidFCSurf[j]};
		Transfinite Surface{pinVoidFCSurf[j]};
	EndFor	
	
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
	lineInterFuel[0] = newll; Line(lineInterFuel[0]) = {pinPointFin[0],pinPointFout[0]};
	lineInterFuel[1] = newll; Line(lineInterFuel[1]) = {pinPointFin[1],pinPointFout[1]};
	lineInterFuel[2] = newll; Line(lineInterFuel[2]) = {pinPointFin[2],pinPointFout[2]};
	lineInterFuel[3] = newll; Line(lineInterFuel[3]) = {pinPointFin[3],pinPointFout[3]};
	
	For j In {0:3}
		Transfinite Line {lineInterFuel[j]} = nInterFuel;
		Transfinite Line {circPinFin[j]} = nD4;
	EndFor
	
	innerFuelLoops[0] = newl; Curve Loop(innerFuelLoops[0]) = {lineInterFuel[0],circPinFout[0],-lineInterFuel[1],-circPinFin[0]};
	innerFuelLoops[1] = newl; Curve Loop(innerFuelLoops[1]) = {lineInterFuel[1],circPinFout[1],-lineInterFuel[2],-circPinFin[1]};
	innerFuelLoops[2] = newl; Curve Loop(innerFuelLoops[2]) = {lineInterFuel[2],circPinFout[2],-lineInterFuel[3],-circPinFin[2]};
	innerFuelLoops[3] = newl; Curve Loop(innerFuelLoops[3]) = {lineInterFuel[3],circPinFout[3],-lineInterFuel[0],-circPinFin[3]};
	
	For j In {0:3}
		pinFuelSurf[j] = news; Surface(pinFuelSurf[j]) = {innerFuelLoops[j]};
		Recombine Surface{pinFuelSurf[j]};
		Transfinite Surface{pinFuelSurf[j]};
	EndFor	
	
	// Void
	
	rVoid = rFIn * 0.8;
	
	pinPointVin[0] = newp; Point(pinPointVin[0]) = {x+rVoid,y,z,lcHole};
	pinPointVin[1] = newp; Point(pinPointVin[1]) = {x,y+rVoid,z,lcHole};
	pinPointVin[2] = newp; Point(pinPointVin[2]) = {x-rVoid,y,z,lcHole};
	pinPointVin[3] = newp; Point(pinPointVin[3]) = {x,y-rVoid,z,lcHole};

	If (voidCirc == 1)
	circPinVin[0] = newc; Circle(circPinVin[0]) = {pinPointVin[0],pinPointC,pinPointVin[1]};
	circPinVin[1] = newc; Circle(circPinVin[1]) = {pinPointVin[1],pinPointC,pinPointVin[2]};
	circPinVin[2] = newc; Circle(circPinVin[2]) = {pinPointVin[2],pinPointC,pinPointVin[3]};
	circPinVin[3] = newc; Circle(circPinVin[3]) = {pinPointVin[3],pinPointC,pinPointVin[0]};
	EndIf
	
	If (voidCirc == 0)
	circPinVin[0] = newc; Line(circPinVin[0]) = {pinPointVin[0],pinPointVin[1]};
	circPinVin[1] = newc; Line(circPinVin[1]) = {pinPointVin[1],pinPointVin[2]};
	circPinVin[2] = newc; Line(circPinVin[2]) = {pinPointVin[2],pinPointVin[3]};
	circPinVin[3] = newc; Line(circPinVin[3]) = {pinPointVin[3],pinPointVin[0]};
	EndIf
	
	// Void inter lines
	lineInterVoid[0] = newll; Line(lineInterVoid[0]) = {pinPointVin[0],pinPointFin[0]};
	lineInterVoid[1] = newll; Line(lineInterVoid[1]) = {pinPointVin[1],pinPointFin[1]};
	lineInterVoid[2] = newll; Line(lineInterVoid[2]) = {pinPointVin[2],pinPointFin[2]};
	lineInterVoid[3] = newll; Line(lineInterVoid[3]) = {pinPointVin[3],pinPointFin[3]};
	
	For j In {0:3}
		Transfinite Line {lineInterVoid[j]} = nInterVoid;
		Transfinite Line {circPinVin[j]} = nD4;
	EndFor
	
	innerVoidLoops[0] = newl; Curve Loop(innerVoidLoops[0]) = {lineInterVoid[0],circPinFin[0],-lineInterVoid[1],-circPinVin[0]};
	innerVoidLoops[1] = newl; Curve Loop(innerVoidLoops[1]) = {lineInterVoid[1],circPinFin[1],-lineInterVoid[2],-circPinVin[1]};
	innerVoidLoops[2] = newl; Curve Loop(innerVoidLoops[2]) = {lineInterVoid[2],circPinFin[2],-lineInterVoid[3],-circPinVin[2]};
	innerVoidLoops[3] = newl; Curve Loop(innerVoidLoops[3]) = {lineInterVoid[3],circPinFin[3],-lineInterVoid[0],-circPinVin[3]};
	
	For j In {0:3}
		pinVoidSurf[j] = news; Surface(pinVoidSurf[j]) = {innerVoidLoops[j]};
		Recombine Surface{pinVoidSurf[j]};
		Transfinite Surface{pinVoidSurf[j]};
	EndFor
	
	voidLoop = newl; Curve Loop(voidLoop) = {circPinVin[0],circPinVin[1],circPinVin[2],circPinVin[3]};
	pinVoidSurf[4] = news; Surface(pinVoidSurf[j]) = {voidLoop};
	Recombine Surface{pinVoidSurf[4]};
	Transfinite Surface{pinVoidSurf[4]};
	
	
Return



