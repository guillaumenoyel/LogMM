%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIP-additive opening on a grey level image (direct implementation).
%
% [ imout ] = LIP_imopen( imin , se , M )
%
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imin                # input image
%
% se                  # structuring element
%   M                 # maximal dynamic for the image:
%                       256 for uint8 bit images
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imout              # logarithmic-opening
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIP_imopen.m
% Guillaume NOYEL 24-01-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ imout ] = LIP_imopen( imin , se , M )

imout = LIP_imdilate( LIP_imerode( imin , se , M ) , se , M );

end
