/*

To solve:
LPSolve IDE (windows)
lp_solve -S3 linear_programming_problem.lp (linux)


Problem

Acme Foods, Inc., wishes to minimize ingredient cost of its veggies and beans salad
while at the same time it wishes the product meets the minimum daily fiber requirement
for an adult. The ratio of veggies to beans must be 2 to 1.

Facts

1) Cost must be lowest.
2) Veggies amount must be twice as much as beans.
3) Veggies cost $4/Kg and they provide 4 g of fiber per 100 g serving.
4) Beans cost $2/Kg and they provide 9 g of fiber per 100 g serving.
5) Daily recommended fiber intake is 40g.

Questions

a) What is minimum cost combination of ingredients that satisfies all constraints?
b) What is the minimum cost?

Problem can be represented this way

                Minimize

                .002 x0 + 0.004 x1;

                subject to

                0.09 x0 + 0.04 x1 >=  40.0;
               -2.00 x0 + 1.00 x1  =  00.0;

Solution

              cost = $ 2.35294117647059
                x0 = 235.294117647059 g
                x1 = 470.588235294118 g

As an exercise, substitute the veggies and beans with your favorite foods to
find out how much you would have to eat to meet the minimum daily fiber requirement.

How much more or less would you have to eat?

*/

/* Objective function */
min: .002 x0 + .004 x1;

/* Variable bounds */

//Fiber constraint
0.09 x0 + 0.04 x1 >= 40.0;

//Ratio constraint
-2.0 x0 + 1.0 x1 = 0.0;
