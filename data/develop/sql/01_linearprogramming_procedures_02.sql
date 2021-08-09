CREATE SCHEMA LinearProgramming;
/
SET SCHEMA LinearProgramming;
/
CREATE PROCEDURE  clearModel()
NO SQL
LANGUAGE JAVA 
PARAMETER STYLE JAVA
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel02.clearModel'
/
CREATE PROCEDURE  addLinearObjectiveFunction(IN i INTEGER)
NO SQL
LANGUAGE JAVA 
PARAMETER STYLE JAVA
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel02.addLinearObjectiveFunction'
/
CREATE PROCEDURE  addLinearConstraint(IN i INTEGER, IN rel INT, IN amount DOUBLE)
NO SQL
LANGUAGE JAVA 
PARAMETER STYLE JAVA
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel02.addLinearConstraint'
/
CREATE PROCEDURE  setMaximize()
NO SQL
LANGUAGE JAVA 
PARAMETER STYLE JAVA
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel02.setMaximize'
/
CREATE PROCEDURE  solveModel()
NO SQL
LANGUAGE JAVA 
PARAMETER STYLE JAVA
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel02.solveModel'
/
CREATE FUNCTION getSolutionPointVariable(IN i INTEGER) RETURNS DOUBLE
LANGUAGE JAVA DETERMINISTIC NO SQL
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel02.getSolutionPointVariable'
/
CREATE FUNCTION getSolutionCost() RETURNS DOUBLE
LANGUAGE JAVA DETERMINISTIC NO SQL
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel02.getSolutionCost'
/
CREATE FUNCTION printModel() RETURNS LONGVARCHAR
LANGUAGE JAVA DETERMINISTIC NO SQL
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel02.printModel'
/
CREATE PROCEDURE  addCoefficientSpace(IN i INTEGER)
NO SQL
LANGUAGE JAVA 
PARAMETER STYLE JAVA
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel02.addCoefficientSpace'
/
CREATE PROCEDURE  setCoefficientSpace(IN i INTEGER)
NO SQL
LANGUAGE JAVA 
PARAMETER STYLE JAVA
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel02.setCoefficientSpace'
/
CREATE PROCEDURE  addCoefficient(IN c DOUBLE)
NO SQL
LANGUAGE JAVA 
PARAMETER STYLE JAVA
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel02.addCoefficient'
/


