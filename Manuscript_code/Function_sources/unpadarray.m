%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Un-pad array
% [imout] = unpadarray( im_pad , padsize, direction )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im_pad       # input image to unpad
% padsize      # padsize is a vector of nonnegative integers that specifies both the amount of padding
%                to add and the dimension along which to add it. The value of an element in the vector 
%                specifies the amount of padding to add. The order of the element in the vector specifies 
%                the dimension along which to add the padding.
%                For example, a padsize value of [2 3] means add 2 elements of padding along the first 
%                dimension and 3 elements of padding along the second dimension. By default, paddarray 
%                adds padding before the first element and after the last element along the specified 
%                dimension.
% direction    # pads A in the direction specified by the string direction. direction can be one of 
%                the following strings. The default value is enclosed in braces ({}).
%                       'both' : Pads before the first element and after the last array element 
%                                along each dimension. This is the default.
%                       'post' : Pad after the last array element along each dimension.
%                       'pre'  : Pad before the first array element along each dimension. 
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imout      # output image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% unpadarray
% Guillaume NOYEL 19-06-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [imout] = unpadarray( im_pad , padsize, direction )

%% Gestion of inputs

nb_arg_fixe = 2;
switch nargin
    case nb_arg_fixe
        direction = 'both';
	case nb_arg_fixe+1
        % OK
end

%% Program

switch direction
    case 'pre'
        imout = im_pad( padsize(1)+1 : end , padsize(2)+1 : end );
    case 'post'
        imout = im_pad( 1 : end - padsize(1) , 1 : end - padsize(2) );
    case 'both'
        imout = im_pad(  padsize(1)+1 : end - padsize(1) , padsize(2)+1 : end - padsize(2) );
end