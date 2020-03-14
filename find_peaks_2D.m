%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                FMCW Radar Simulator               %
%                                                   %
% Author: Lin Junyang                               %
% Email : linjy@163.com                             %
% Date  : 2020-3-14                                 %
%                                                   %
% All Rights Reserved.                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function img_pk = find_peaks_2D(img_in)

    [row,col]=size(img_in);
    img_pk = img_in;
    img_pk(1:2,:) = 0;
    img_pk(row-1:row,:) = 0;
    img_pk(:,1:2) = 0;
    img_pk(:,col-1:col) = 0;

    % erode
    for i=3:row-2
        for j=3:col-2
            if img_pk(i,j)<img_pk(i-1,j) || ...
                    img_pk(i,j)<img_pk(i+1,j) || ...
                    img_pk(i,j)<img_pk(i,j-1) || ...
                    img_pk(i,j)<img_pk(i,j+1) || ...
                    img_pk(i,j)<img_pk(i-1,j-1) || ...
                    img_pk(i,j)<img_pk(i-1,j+1) || ...
                    img_pk(i,j)<img_pk(i+1,j-1) || ...
                    img_pk(i,j)<img_pk(i+1,j+1)
                img_pk(i,j) = 0;
            end
        end
    end