%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Complement by M-1 of the structuring function (strel) height 
%
% [se_out] = LIP_strel_imcomplement( se_in , M )
%
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% se_in             # input structuring element (strel)
% M                 # maximal range of the image: e.g. 256 for images
%                       uint8, 65536 for images uint16
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% se_out            # Complemented structuring element 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIP_strel_imcomplement.m
% Guillaume NOYEL 06/12/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [se_out] = LIP_strel_imcomplement( se_in , M )

im_se_out = LIP_imcomplement( se_in.getheight , M );
msk_nhood = se_in.getnhood;
im_se_out(~msk_nhood) = 0;
se_out = strel( 'arbitrary' , msk_nhood , im_se_out );