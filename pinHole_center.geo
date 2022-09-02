//------------------------------------------
// Name: Simple pinHole
// Autor: Tomas Korinek
// Date: 3.2.2022
// version: 2 - fuel, cladding, void included
//			1-  simple hole
//------------------------------------------

Macro pinHole_center
	// Cladding
	
	// inner lines
	pinCenterPointC = newp; Point(pinCenterPointC) = {x,y,z,lcHole};
	pinCenterPointCout[0] = newp; Point(pinCenterPointCout[0]) = {x+rCenterOut,y,z,lcHole};
	pinCenterPointCout[1] = newp; Point(pinCenterPointCout[1]) = {x,y+rCenterOut,z,lcHole};
	pinCenterPointCout[2] = newp; Point(pinCenterPointCout[2]) = {x-rCenterOut,y,z,lcHole};
	pinCenterPointCout[3] = newp; Point(pinCenterPointCout[3]) = {x,y-rCenterOut,z,lcHole};
	circPinCenterCout[0] = newc; Circle(circPinCenterCout[0]) = {pinCenterPointCout[0],pinCenterPointC,pinCenterPointCout[1]};
	circPinCenterCout[1] = newc; Circle(circPinCenterCout[1]) = {pinCenterPointCout[1],pinCenterPointC,pinCenterPointCout[2]};
	circPinCenterCout[2] = newc; Circle(circPinCenterCout[2]) = {pinCenterPointCout[2],pinCenterPointC,pinCenterPointCout[3]};
	circPinCenterCout[3] = newc; Circle(circPinCenterCout[3]) = {pinCenterPointCout[3],pinCenterPointC,pinCenterPointCout[0]};
	
	// outer lines
	pinCenterPointCin[0] = newp; Point(pinCenterPointCin[0]) = {x+rCenterIn,y,z,lcHole};
	pinCenterPointCin[1] = newp; Point(pinCenterPointCin[1]) = {x,y+rCenterIn,z,lcHole};
	pinCenterPointCin[2] = newp; Point(pinCenterPointCin[2]) = {x-rCenterIn,y,z,lcHole};
	pinCenterPointCin[3] = newp; Point(pinCenterPointCin[3]) = {x,y-rCenterIn,z,lcHole};
	circPinCenterCin[0] = newc; Circle(circPinCenterCin[0]) = {pinCenterPointCin[0],pinCenterPointC,pinCenterPointCin[1]};
	circPinCenterCin[1] = newc; Circle(circPinCenterCin[1]) = {pinCenterPointCin[1],pinCenterPointC,pinCenterPointCin[2]};
	circPinCenterCin[2] = newc; Circle(circPinCenterCin[2]) = {pinCenterPointCin[2],pinCenterPointC,pinCenterPointCin[3]};
	circPinCenterCin[3] = newc; Circle(circPinCenterCin[3]) = {pinCenterPointCin[3],pinCenterPointC,pinCenterPointCin[0]};
	
	// inter lines
	lineCenterInter[0] = newll; Line(lineCenterInter[0]) = {pinCenterPointCin[0],pinCenterPointCout[0]};
	lineCenterInter[1] = newll; Line(lineCenterInter[1]) = {pinCenterPointCin[1],pinCenterPointCout[1]};
	lineCenterInter[2] = newll; Line(lineCenterInter[2]) = {pinCenterPointCin[2],pinCenterPointCout[2]};
	lineCenterInter[3] = newll; Line(lineCenterInter[3]) = {pinCenterPointCin[3],pinCenterPointCout[3]};

	Transfinite Line {circPinCenterCin[0]} = nD4;
	Transfinite Line {circPinCenterCin[1]} = nD4;
	Transfinite Line {circPinCenterCin[2]} = nD4;
	Transfinite Line {circPinCenterCin[3]} = nD4;
	
	Transfinite Line {circPinCenterCout[0]} = nD4;
	Transfinite Line {circPinCenterCout[1]} = nD4;
	Transfinite Line {circPinCenterCout[2]} = nD4;
	Transfinite Line {circPinCenterCout[3]} = nD4;
		
	Transfinite Line {lineCenterInter[0]} = nInterCenter;
	Transfinite Line {lineCenterInter[1]} = nInterCenter;
	Transfinite Line {lineCenterInter[2]} = nInterCenter;
	Transfinite Line {lineCenterInter[3]} = nInterCenter;

	innerCenterLoops[0] = newl; Curve Loop(innerCenterLoops[0]) = {lineCenterInter[0],circPinCenterCout[0],-lineCenterInter[1],-circPinCenterCin[0]};
	innerCenterLoops[1] = newl; Curve Loop(innerCenterLoops[1]) = {lineCenterInter[1],circPinCenterCout[1],-lineCenterInter[2],-circPinCenterCin[1]};
	innerCenterLoops[2] = newl; Curve Loop(innerCenterLoops[2]) = {lineCenterInter[2],circPinCenterCout[2],-lineCenterInter[3],-circPinCenterCin[2]};
	innerCenterLoops[3] = newl; Curve Loop(innerCenterLoops[3]) = {lineCenterInter[3],circPinCenterCout[3],-lineCenterInter[0],-circPinCenterCin[3]};

	innerCenterLoopsCool = newl; Curve Loop(innerCenterLoopsCool) = {circPinCenterCin[0],circPinCenterCin[1],circPinCenterCin[2],circPinCenterCin[3]};

	For j In {0:3}
		pinCenterSurf[j] = news; Surface(pinCenterSurf[j]) = {innerCenterLoops[j]};
		Recombine Surface{pinCenterSurf[j]};
		Transfinite Surface{pinCenterSurf[j]};
	EndFor

	pinCenterLoops = newl;	Curve Loop(pinCenterLoops) = {circPinCenterCout[0],circPinCenterCout[1],circPinCenterCout[2],circPinCenterCout[3]};

			
	For j In {0:3}
		CentersurfaceVector[]=Extrude {0, 0, zmax} {
		 Surface{pinCenterSurf[j]};
		 Layers{nZ};
		 Recombine;
		};

		If ((region == 2) || (region == 0))
			If ((j == 0))
				Physical Volume("cladding") = CentersurfaceVector[1];
			Else
				Physical Volume("cladding") += CentersurfaceVector[1];
			EndIf	
		EndIf		
	EndFor
	
Return



