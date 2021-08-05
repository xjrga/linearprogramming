CREATE PROCEDURE  addLinearObjectiveFunction(IN a DOUBLE ARRAY)
NO SQL
LANGUAGE JAVA 
PARAMETER STYLE JAVA
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel.addLinearObjectiveFunction'
/
CREATE PROCEDURE  addLinearConstraint(IN coefficients DOUBLE ARRAY, IN rel INT, IN amount DOUBLE)
NO SQL
LANGUAGE JAVA 
PARAMETER STYLE JAVA
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel.addLinearConstraint'
/
CREATE PROCEDURE  solveModel()
NO SQL
LANGUAGE JAVA 
PARAMETER STYLE JAVA
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel.solveModel'
/
CREATE FUNCTION printModel() RETURNS LONGVARCHAR
LANGUAGE JAVA DETERMINISTIC NO SQL
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel.printModel'
/
CREATE FUNCTION getSolutionCost() RETURNS DOUBLE
LANGUAGE JAVA DETERMINISTIC NO SQL
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel.getSolutionCost'
/
CREATE FUNCTION getSolutionPoint() RETURNS DOUBLE ARRAY
LANGUAGE JAVA DETERMINISTIC NO SQL
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel.getSolutionPoint'
/
CREATE PROCEDURE  clearModel()
NO SQL
LANGUAGE JAVA 
PARAMETER STYLE JAVA
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel.clearModel'
/
