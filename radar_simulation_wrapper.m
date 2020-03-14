%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                FMCW Radar Simulator               %
%                                                   %
% Author: Lin Junyang                               %
% Email : linjy@163.com                             %
% Date  : 2019-6-15                                 %
%                                                   %
% All Rights Reserved.                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
function [RX1_CHIRPS_I,RX1_CHIRPS_Q,RX2_CHIRPS_I,RX2_CHIRPS_Q,TargetTracks] = radar_simulation_wrapper(target_num)

    disp('Generating simulation data...');
    if target_num==0
        radar_simulation_core_handwave
    else
        radar_simulation_core_multi_target
        TargetTracks.X = X;
        TargetTracks.Y = Y;
        TargetTracks.Z = Z;
    end
    disp('Simulation data is successfully generated.');
    
end