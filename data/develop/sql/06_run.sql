--Model values are hard coded
call solveModel01();
call printModel();
call getSolutionCost();
call getSolutionPoint();
call clearModel();
--Model values are read from and saved to tables
call solveModel02();
call saveModel();
call printModel();
call getSolutionCost();
call getSolutionPoint();
call clearModel();
