# define the sets
set P; # Products
set C; # Cardboards
set S; # Suppliers S1 and S2
set SN; # All suppliers including the new supplier S3
set Q; # Quality features
set A; # Products of Category A
set B; # products of Category B

# define the paramters
param Avail{C,SN}; # Maximum availability of cardboard c from supplier s (in tonnes per week)
param Cpurch{C,S}; # Purchasing cost of cardboard c from supplier s (per tonne)
param Mpurch{S}; # Minimum purchase amount from supplier s (in $ per weeks)
param Cprod{P}; # Production cost of product p (per tonne)
param Psale{P}; # Sale price of product p (per tonne)
param Dmin{P}; # Minimum Demand that must be met for product p (in tonnes per week)
param CapA; # Maximum production capacity for products in category A (in tonnes per week)
param CapB; # Maximum production capacity for products in category B (in tonnes per week)
param Qual{P,Q}; # Minimum quality requirement of quality feature q in product p
param IQual{C,Q}; # Input quality of quality feature q in cardboard c

param AvailS3; # fixed amount of C1 that must be taken purchased from S3
param Profmin; # mimimum profit that must be reached

# define the decision variables
var j{C,SN} >= 0; # Amount of cardboard c purchased from supplier s (in tonnes per week)
var u{C,P} >= 0; # Amount of cardboard c used in blending for product p (in tonnes per week)
var x{P} >= 0; # Amount of product p produced (in tonnes per week)
var CostS3 >= 0; # Cost for one unit of cardboard C1 purchased from supplier S3

# define objective function
maximize cost_s3: CostS3;

# define constraints
subject to

# can only purchase as much as the supply limit from all suppliers is
supply_constraint{c in C, n in SN}:
	j[c,n] <= Avail[c,n];	
	
# only can use as much cardboard in blending as you purchase in total from all suppliers	
blending_constraint{c in C}:
	sum{p in P}u[c,p] <= sum{n in SN}j[c,n]; 

# have to at least purchase an amount of Mpurch $ from each supplier
minpurch_constraint{s in S}:
	sum{c in C}Cpurch[c,s]*j[c,s] >= Mpurch[s];
	
# linearity of yield: sum of all cardboards that go into a product is equal to the amount of product that you get out
yield_constraint{p in P}:
	sum{c in C}u[c,p] = x[p];

# can only produce as much as the capacity for category A
capacity_constraintA:
	sum{a in A}x[a] <= CapA;
	
# can only produce as much as the capacity for category B
capacity_constraintB:
	sum{b in B}x[b] <= CapB;
	
# minimum demand satisfaction constraint
demand_constraint{p in P}:
	x[p] >= Dmin[p];
	
# minimum quality constraint
quality_constraint{p in P, q in Q}:
	sum{c in C}IQual[c,q]*u[c,p] >= (sum{c in C}u[c,p])*Qual[p,q];	
	
# Assume fixed purchase amount of C1 from S3 = 1000
S3purch_constraint:
	j['C1','S3'] = AvailS3;	
	
# constraint that the profit must be at least 2,5% higher than the profit in Task 1			
profit_constraint:
	sum{p in P}Psale[p]*x[p] # Revenue
	- sum{c in C, s in S}Cpurch[c,s]*j[c,s] # purchase cost from S1 and S2
	- sum{p in P}Cprod[p]*x[p] # production cost
	- AvailS3*CostS3
	>=
	Profmin;

	

