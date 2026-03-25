%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Négatif LIP d'une fonction im1
% [imout] = LIP_imneg( im1 , M )
%
%
%   ATTENTION : on suppose que les images ont été complémentées pour être
%   des images en tons de gris
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im1            #image d'entrée en niveau de gris      
% M              # dynamique maximale de l'image : exemple 256 pour les
%                  images uint8, 65536 pour les images uint16
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imout         #image de sortie en double
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIP_imsubtract.m
% Guillaume NOYEL June 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [imout] = LIP_imneg( im1 , M )

validateattributes(im1, {'numeric'}, {'nonempty'}, mfilename, 'im1', 1);
validateattributes(M, {'numeric'}, {'scalar', 'nonnegative'}, mfilename, 'M', 2);

M = double(M);
im1 = double(im1);

imout = (- im1) ./ (1 - im1/M);

%% -Infinite values

imout(im1==-Inf) = M;

end

