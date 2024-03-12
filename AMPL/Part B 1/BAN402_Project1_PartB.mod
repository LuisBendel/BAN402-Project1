# define the sets
set P; # Products
set C; # Cardboards
set S; # Suppliers
set Q; # Quality features
set A; # Products of Category A
set B; # products of Category B

# define the paramters
param Avail{C,S}; # Maximum availability of cardboard c from supplier s (in tonnes per week)
param Cpurch{C,S}; # Purchasing cost of cardboard c from supplier s (per tonne)
param Mpurch{S}; # Minimum purchase amount from supplier s (in $ per weeks)
param Cprod{P}; # Production cost of product p (per tonne)
param Psale{P}; # Sale price of product p (per tonne)
param Dmin{P}; # Minimum Demand that must be met for product p (in tonnes per week)
param CapA; # Maximum production capacity for products in category A (in tonnes per week)
param CapB; # Maximum production capacity for products in category B (in tonnes per week)
param Qual{P,Q}; # Minimum quality requirement of quality feature q in product p
param IQual{C,Q}; # Input quality of quality feature q in cardboard c

# define the decision variables
var j{C,S} >= 0; # Amount of cardboard c purchased from supplier s (in tonnes per week)
var u{C,P} >= 0; # Amount of cardboard c used in blending for product p (in tonnes per week)
var x{P} >= 0; # Amount of product p produced (in tonnes per week)

# define objective function
maximize profit:
	sum{p in P}Psale[p]*x[p] # Revenue
	- sum{c in C, s in S}Cpurch[c,s]*j[c,s] # purchase cost
	- sum{p in P}Cprod[p]*x[p]; # production cost
	
# define constraints
subject to

# can only purchase as much as the supply limit from the suppliers is
supply_constraint{c in C, s in S}:
	j[c,s] <= Avail[c,s];	
	
# only can use as much cardboard in blending as you purchase in total from both suppliers	
blending_constraint{c in C}:
	sum{p in P}u[c,p] <= sum{s in S}j[c,s]; 

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



	

