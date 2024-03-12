# define the sets
set R; # Regions
set F; # Facilities
set K; # Markets

# define the parameters
param Cpurch{R,F}; # Cost of shipping one unit from region r to facility f
param D{K}; # Demand in market k
param Cship{F,K}; # Cost of shipping one unit from facility f to market k
param Mpurch{R}; # Maximum purchasing limit from region r
param Mproc{F}; # Maximum processing capacity at facility f

# define the decision variables
var x{R,F} >= 0; # tonnes purchased from region r to facility f
var y{F,K} >= 0; # tonnes shipped from facility f to market k

# define the objective function
minimize trans_cost:
	sum{r in R, f in F}Cpurch[r,f]*x[r,f]
	+ sum{f in F, k in K}Cship[f,k]*y[f,k];

# define the constraints	
subject to	

# supply constraint from regions
supply_constraint{r in R}:
	sum{f in F}x[r,f] <= Mpurch[r];
	
# production constraint in facilities
prod_constraint{f in F}:
	sum{k in K}y[f,k] <= Mproc[f];
	
# outgoing shipment constraint
ship_constraint{f in F}:
	sum{k in K}y[f,k] <= sum{r in R}x[r,f];
	
# Demand constraint
demand_constraint{k in K}:
	sum{f in F}y[f,k] = D[k];		