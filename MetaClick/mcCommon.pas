unit mcCommon;

interface

type
  TClickMode=(
    cmOrbit,
    cmLeftSingle,
    cmLeftDouble,
    cmLeftDrag,
    cmRightSingle,
    cmRightDouble,
    cmRightDrag,
    cmWheel);

  TClickState=(
    csFirst,
    csFirstDone,
    csSecond,
    csAllDone,
    csIgnoredFirstMove,
    csOrbit,
    csOrbitCross
  );

implementation

end.
