# define the sets
set G; # GHGs
set M; # methods of reduction

# define the parameters
param R{G,M}; # reduction of gas g when method m is used with one unit of intensity
param C{M}; # Cost of using one unit of intensity of method m
param RMin{G}; # Minimum reduction goal for gas g given by the government

# Define the decision variables
var u{M} >= 0; # units of intensity used of method m

# define the objective function
minimize cost:
	sum{m in M}C[m]*u[m];
	
# define the constraints
subject to

# meet the government regulations
reduction_constraint{g in G}:
	sum{m in M}R[g,m]*u[m] >= RMin[g];



