%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Opération morphologique avec un paddaray
% [imout] = MorphologicalOperationWithPad( imin , morpho_name , se , padval, padsize, direction )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imin         # image d'entrée
% morpho_name  # Nom (string) de l'op"ration morphologique
%                   ex : 'imdilate', 'imerode', 'imclose', 'imopen'
% se           # élement structurant : ex : strel('disk',3)
%
%              # paramètres de paddaray
% padval       # (optional) pads array A where padval specifies the value to use as the pad value. padarray uses
%                the value 0 (zero) as the default. padval can be a scalar that specifies the pad value
%                directly or one of the following text strings that specifies the method padarray uses to
%                determine the values of the elements added as padding:
%                       'circular'  : Pad with circular repetition of elements within the dimension.
%                       'replicate' : Pad by repeating border elements of array.
%                       'symmetric' : Pad array with mirror reflections of itself.
% padsize      # (optional) padsize is a vector of nonnegative integers that specifies both the amount of padding
%                to add and the dimension along which to add it. The value of an element in the vector 
%                specifies the amount of padding to add. The order of the element in the vector specifies 
%                the dimension along which to add the padding.
%                For example, a padsize value of [2 3] means add 2 elements of padding along the first 
%                dimension and 3 elements of padding along the second dimension. By default, paddarray 
%                adds padding before the first element and after the last element along the specified 
%                dimension.
%                default : half size of the structuring element
% direction    # (optional) pads A in the direction specified by the string direction. direction can be one of 
%                the following strings. The default value is enclosed in braces ({}).
%                       'both' : Pads before the first element and after the last array element 
%                                along each dimension. This is the default.
%                       'post' : Pad after the last array element along each dimension.
%                       'pre'  : Pad before the first array element along each dimension. 
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imout      # image de sortie
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MorphologicalOperationWithPad
% Guillaume NOYEL 20-06-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [imout] = MorphologicalOperationWithPad( imin , morpho_name , se , padval , padsize, direction )

%% Gestion des entrées

nb_arg_fixe = 3;
switch nargin
    case nb_arg_fixe
        padval = 0;
        padsize = floor(size(se.getnhood)/2);
        direction = 'both';
    case nb_arg_fixe + 1
        padsize = floor(size(se.getnhood)/2);
        direction = 'both';
	case nb_arg_fixe + 2
        direction = 'both';
end

%% Programme
im_pad = padarray( imin , padsize , padval , direction );

eval( sprintf('im_pad = %s(im_pad,se);',morpho_name) );

imout = unpadarray( im_pad , padsize , direction );

