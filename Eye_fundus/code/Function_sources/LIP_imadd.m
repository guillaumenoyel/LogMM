%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Addition LIP de deux fonctions
%[imout] = LIP_imadd( im1 , im2 , M )
%
%
%   ATTENTION : on suppose que les images ont été complémentées pour être
%   des images en tons de gris
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%im1            #image d'entrée en niveau de gris      
%im2            #image d'entrée en niveau de gris      
% M              # dynamique maximale de l'image : exemple 256 pour les
%                  images uint8, 65536 pour les images uint16
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%imout         #image de sortie en double
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIP_imadd.m
% Guillaume Noyel Juin 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[imout] = LIP_imadd( im1 , im2 , M)

validateattributes(im1, {'numeric'}, {}, mfilename, 'im1', 1);
validateattributes(im2, {'numeric'}, {}, mfilename, 'im2', 2);
validateattributes(M, {'numeric'}, {'scalar', 'nonnegative'}, mfilename, 'M', 3);
%VerificationImageTaille(im1,im2,mfilename);


%M = double(intmax(class(im1)));
%imout = feval(class(im1) , double(im1)+double(im2) - double(im1).*double(im2)/M );
M = double(M);
im1 = double(im1);
im2 = double(im2);

imout = im1 + im2 - (( im1 .* im2 )/M);

end

