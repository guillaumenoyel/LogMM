%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Threshold on the percentage of pixels staying in the thresholded image
% above the computed threshold
%
% [th] = ThresholdAreaPercentage( imin , rel_area ) 
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im           # input image
% rel_area     # percentage of pixels kept. Example 13/100
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% th           # threshold values : 
%                   the thresholded image : im_bin = (imin >= th)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ThresholdAreaPercentage.m
% Guillaume NOYEL 20-06-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [th] = ThresholdAreaPercentage( imin , rel_area ) 

%% Parameters

flag_display = false;

%% Program

if isa( imin , 'double' ) 
    [counts,x] = hist( imin(:) , 256 ); % histogram of the FOV (Field Of View)
else
    [counts,x] = imhist( imin ); % histogram of the FOV (Field Of View)
end
Area = numel(imin);
F_rep = cumsum(counts)/Area;% repartition function normalised
F_rep_c = 1 - F_rep; % complementary of the repartition function


[~,ind] = min(abs(F_rep_c - rel_area ));
th = x(ind);



if flag_display
    figure
    bar(x,counts); hold on
    plot( [th th] , [0 max(counts)] , 'r-');
    title('Histogram')

    figure
    bar(x,F_rep_c); hold on
    plot( [th th] , [0 max(F_rep_c)] , 'r-');
    title('Complementary of the repartition function')
end

end

    