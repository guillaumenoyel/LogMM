%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Maximum of a matrix 2D or of two matrices 2d
%
% [ maxi , IJ ] = max2( im )
% [ maxi , msk_maxi ] = max2( im0 , im1 )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im             #image d'entrée 2D scalaire
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% maxi           # maximum of the image 2D
% IJ             # coordinates I and J of the maximum
% msk_maxi       # mask of the pointwise maximum 
%                   0 maximum is in the point of im0
%                   1 maximum is in the point of im1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% max2.m
% Guillaume NOYEL - 17/11/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ maxi , IJ ] = max2( im0 , im1 )


nb_arg_fix = 1;
if nargin == nb_arg_fix
    [maxi_col , IX_lig] = max(im0);
    [maxi, IX_col] = max(maxi_col);
    IX_lig = IX_lig(IX_col);
    IJ = [IX_lig(:) , IX_col(:)];
else
    SZ = size(im0);
    [maxi , ind_maxi] = max([im0(:),im1(:)],[],2);
    maxi = reshape(maxi,SZ);
    IJ = reshape(logical(ind_maxi-1),SZ);
end

end

