%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                FMCW Radar Simulator               %
%                                                   %
% Author: Lin Junyang                               %
% Email : linjy@163.com                             %
% Date  : 2020-3-14                                 %
%                                                   %
% All Rights Reserved.                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear

%%
target_num = 5;
disp(['Simulation number of targets: [',num2str(target_num),']'])
%%
[I1,Q1,I2,Q2,TargetTracks] = radar_simulation_wrapper(target_num);
close all

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Develop your Radar Data Processing Algorithm here:           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RANGE_MIN = 16;
RANGE_MAX = 64;
DPL_FFT_POINTS = 32;
DPL_FFT_INTVERAL = 32;
DPL_FFT_ELSIZE = 128;

disp('Radar data processing...');
radar_data_processing_multi_target
disp('Radar data processing finished.');
