function COPT_conv_gen = outageProbTable(GENERATOR_CAPACITIES, GENERATOR_OUTAGE)

% Input Description:
% GENERATOR_CAPACITIES vector with capacity of each generator                                             [N x 1] (double)
% GENERATOR_OUTAGE the corresponding Equivalent Forced Outage Rate on Demand (EFORd) for each generator   [N x 1] (double)

% Output Description:
% Returns the capacity outage probability table (COPT): [System Capacity Available, State Probabilities]  [M x 2] (double)
% Generator Units In = COPT Units Out

% Notes:
% Computational efficiency is achieved by combining states that sum to the 
% same system capacity. The script automatically rounds all generators to 2 decimal 
% points; however, further rounding will achieve greater performance.
%
% Maximum # of System States = SUM(GENERATOR_CAPACITIES)/(smallest unit of measurement)
% i.e 500,000 possible generator states for a system of 500 MW measured to the nearest kW
% but only 500 possible generator states for a system of 500 MW measured to the nearest MW

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START SCRIPT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Rounds generator capacity to the nearest 10 kW for computational efficiency

GENERATOR_CAPACITIES = round(GENERATOR_CAPACITIES*100)/100;
%GENERATOR_CAPACITIES=[12;12;12;12;12;20;20;20;20;50;50;50;50;50;50;76;76;76;76;100;100;100;155;155;155;155;197;197;197;350;400;400];
%GENERATOR_OUTAGE=[0.02;0.02;0.02;0.02;0.02;0.10;0.10;0.10;0.10;0.01;0.01;0.01;0.01;0.01;0.01;0.02;0.02;0.02;0.02;0.04;0.04;0.04;0.04;0.04;0.04;0.04;0.05;0.05;0.05;0.08;0.12;0.12];
% Format "sum(generator availability)", "state probability"
% The routine starts with 0 generators and, by definition, a probability of 1
COPT = [0 1];

for i = 1:length(GENERATOR_CAPACITIES)
	% Initialize generator branches
	genOffBranch = COPT; %genOffBranch - branch that treats the next generator as being off
	genOnBranch = COPT; %genOnBranch - branch that treats the next generator as being on
	
	% Branch with generator off
	genOffBranch(:,2) = GENERATOR_OUTAGE(i) * genOffBranch(:,2); 
	
	% Branch with generator on
	genOnBranch(:,1) = GENERATOR_CAPACITIES(i) + genOnBranch(:,1); 
	genOnBranch(:,2) = (1-GENERATOR_OUTAGE(i)) * genOnBranch(:,2);
	
	[intersection, IA, IB] = intersect(genOffBranch(:,1),genOnBranch(:,1)); % Common states to the on and off branches
	[unique_off, I_0] = setdiff(genOffBranch(:,1), genOnBranch(:,1)); % Unique states on the off branch
	[unique_on, I_1] = setdiff(genOnBranch(:,1), genOffBranch(:,1)); % Unique states on the on branch;
	
	COPT =  sortrows([[intersection, genOffBranch(IA,2)+genOnBranch(IB,2)]; [unique_off, genOffBranch(I_0,2)]; [unique_on, genOnBranch(I_1,2)]],1); % Combine states together and sort
end
COPT1=flipud(COPT);
newColumn = ones(size(COPT1, 1), 1);
COPT2=[COPT1,newColumn];
COPT3=flip(COPT2,2);
COPT4 = COPT3;
COPT4(:, [2, 3]) = COPT3(:, [3, 2]);
COPT4(:,1)=sum(GENERATOR_CAPACITIES)-COPT4(:,2);
COPT_gen=COPT4;% COPT_gen in the form: capacity_out   capacity_in    ind_probability
cum_COPT_gen1=COPT_gen;
cum_COPT_gen1(:,4)=flipud(cumsum(flipud(COPT_gen(:,3))));
% columnToReverse = 4;
% % Reverse the order of rows for the selected column using flipud
% cum_COPT_gen1(:, columnToReverse) = flipud(cum_COPT_gen1(:, columnToReverse));
COPT_conv_gen=cum_COPT_gen1;% in the form: capacity_out   capacity_in    ind_probability  cumulative_probability
end