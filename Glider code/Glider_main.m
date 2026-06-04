% -------------------------------------------------------------
% RUN THIS PROGRAM FROM HERE EACH TIME
% -------------------------------------------------------------
close all
clear all
%% INPUT DATA EXECUTION %%
run('Glider_data.m');
%% RUNGE-KUTTA METHOD EXECUTION %%
run('Runge_Kutta.m');
%% PLOTTER SCRIPT EXECUTION %%
run ('Glider_plotter.m'); % runs plotter script to show graphics
%% BATTERY SCRIPT EXECUTION %%
run ("Glider_batteries.m"); % runs batteries script to show configuration
%% PRINT RESULTS IN EXCEL
run ('print_results_excel');

