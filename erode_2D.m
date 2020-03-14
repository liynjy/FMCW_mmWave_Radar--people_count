%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                FMCW Radar Simulator               %
%                                                   %
% Author: Lin Junyang                               %
% Email : linjy@163.com                             %
% Date  : 2020-3-14                                 %
%                                                   %
% All Rights Reserved.                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function img_er = erode_2D(img_in,ep)

    [row,col]=size(img_in);
    
    img_er = img_in;
    img_er(1:2,:) = 0;
    img_er(row-1:row,:) = 0;
    img_er(:,1:2) = 0;
    img_er(:,col-1:col) = 0;

    % erode
    for k=1:ep
        img_tmp = img_er;
        for i=3:row-2
            for j=3:col-2
                if img_tmp(i-1,j) && img_tmp(i+1,j) && img_tmp(i,j-1) && img_tmp(i,j+1)
%                     img_er(i,j) = 1;
                else
                    img_er(i,j) = 0;
                end
            end
        end
    end

end