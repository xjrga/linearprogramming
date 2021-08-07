--Model values are hard coded
call model.solveModelHardCoded();
call linearprogramming.printModel();
call linearprogramming.getSolutionCost();
call linearprogramming.getSolutionPoint();
call linearprogramming.clearModel();
--Model values are read from and saved to tables
call model.solveModel(0);
call model.Problem_Select(0);
call model.Variable_Select(0);
call model.ConstraintLhs_Select(0);

