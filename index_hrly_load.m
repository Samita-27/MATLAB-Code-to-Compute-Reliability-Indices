clear all;
clc;
tot_gen=3405;%MW
GENERATOR_CAPACITIES=[12;12;12;12;12;20;20;20;20;50;50;50;50;50;50;76;76;76;76;100;100;100;155;155;155;155;197;197;197;350;400;400];
GENERATOR_OUTAGE=[0.02;0.02;0.02;0.02;0.02;0.10;0.10;0.10;0.10;0.01;0.01;0.01;0.01;0.01;0.01;0.02;0.02;0.02;0.02;0.04;0.04;0.04;0.04;0.04;0.04;0.04;0.05;0.05;0.05;0.08;0.12;0.12];
hrly_load=xlsread('C:\Users\kiit\Documents\MATLAB\RP_RI\IO_files_REL\hrly_load_peak_2850.xlsx','LoadH', 'C6:C8765');
t=length(hrly_load);
timeVector = 1:8760;
% Plot the load curve
figure;
plot(timeVector, hrly_load, 'LineWidth', 2);
title('Load Curve');
xlabel('Hour of the Year');
ylabel('Load (in MW)');
grid on;
%% plot the load duration curve
% Sort the load data in descending order
sortedLoadData = sort(hrly_load, 'descend');

% Calculate the percentage of time for each data point
percentageOfTime = (1:8760) / 8760 * 100;

% Plot the Load Duration Curve
figure;
plot(percentageOfTime, sortedLoadData, 'LineWidth', 2);
title('Load Duration Curve');
xlabel('Percentage of Time (%)');
ylabel('Load (in MW)');
grid on;
areaUnderCurve = trapz(percentageOfTime, sortedLoadData);
tot_energy=(areaUnderCurve/100)*8760;
COPT_conv_gen=outageProbTable(GENERATOR_CAPACITIES, GENERATOR_OUTAGE);
Peak_load=2850;%MW
for i=1:t
loss_of_load(i)=tot_gen-hrly_load(i);
lole(i)=findCorrespondingValues(COPT_conv_gen, loss_of_load(i));
end
LOLE=sum(lole);
for j=1:length(COPT_conv_gen)
     MWh_in=COPT_conv_gen(j,2)*8760;
       if tot_energy>=MWh_in
          eens(j)=(tot_energy-MWh_in)*COPT_conv_gen(j,3);
       end
end
          EENS=sum(eens);
