%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Minimum of a matrix 2D or of two matrices 2d
%
% [ mini , IJ ] = min2( im )
% [ mini , msk_mini ] = min2( im0 , im1 )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im             #image d'entrée 2D scalaire
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% mini           # minimum of the image 2D
% IJ             # coordinates I and J of the minimum
% msk_mini       # mask of the pointwise minimum 
%                   0 minimum is in the point of im0
%                   1 minimum is in the point of im1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% min2.m
% Guillaume NOYEL - 17/11/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ mini , IJ ] = min2( im0 , im1 )

nb_arg_fix = 1;
if nargin == nb_arg_fix
    [mini_col , IX_lig] = min(im0);
    [mini, IX_col] = min(mini_col);
    IX_lig = IX_lig(IX_col);
    IJ = [IX_lig(:) , IX_col(:)];
else
    SZ = size(im0);
    [mini , ind_mini] = min([im0(:),im1(:)],[],2);
    mini = reshape(mini,SZ);
    IJ = reshape(logical(ind_mini-1),SZ);
end

end