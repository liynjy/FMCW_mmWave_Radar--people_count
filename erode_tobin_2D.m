%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                FMCW Radar Simulator               %
%                                                   %
% Author: Lin Junyang                               %
% Email : linjy@163.com                             %
% Date  : 2020-3-14                                 %
%                                                   %
% All Rights Reserved.                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [img_b,num] = erode_tobin_2D(img_in)

% %     [row,col]=size(img_in);
% %     ep = fix(max(row,col)/2);
% %     
% %     img_b = img_in;
% %     img_b(img_b>0) = 1;
% %     img_b(1:2,:) = 0;
% %     img_b(row-1:row,:) = 0;
% %     img_b(:,1:2) = 0;
% %     img_b(:,col-1:col) = 0;
% % 
% %     % erode
% %     for k=1:2
% %         img_tmp = img_b;
% %         for i=3:row-2
% %             for j=3:col-2
% %                 if img_tmp(i-1,j) && img_tmp(i+1,j) && img_tmp(i,j-1) && img_tmp(i,j+1)
% %                     img_b(i,j) = 1;
% %                 else
% %                     img_b(i,j) = 0;
% %                 end
% %             end
% %         end
% %     end

    img_b = img_in;
    img_b(img_in>0) = 1;

    img_b = bwmorph(img_b,'shrink',inf);

    num = sum(sum(img_b));

end