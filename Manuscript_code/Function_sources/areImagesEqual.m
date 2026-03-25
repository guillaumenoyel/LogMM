
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if two images are equals between them (with a given tolerance)
%
% [answer] = areImagesEqual( imin1 , imin2 , tol )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im1            # input image 1
% im2            # input image 2
% tol            # tolerance on the absolute difference between every points of the images
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% answer         # logical indicating if images are equal (true) or not (false)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% areImagesEqual.m
% Guillaume NOYEL June 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [answer] = areImagesEqual( imin1 , imin2 , tol )

%% Input mangamement

if ~isequal(size(imin1),size(imin2))
    eid = sprintf('Images:%s:mismatchedSize', mfilename);
    error(eid, 'imin1 and imin2 must be the same size.');
end

nb_arg_fixe = 2;
if nargin == nb_arg_fixe
   use_tolerance = false;
else
    use_tolerance = true;
end

%% Program
if use_tolerance
    answer = max(abs( double(imin1(:)) - double(imin2(:)) ) ) <= tol;
else
    answer = isequal( imin1 , imin2 );
end

end

