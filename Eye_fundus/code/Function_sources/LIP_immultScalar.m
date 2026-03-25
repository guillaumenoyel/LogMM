


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Multiplication LIP par un scalaire
% [imout] = LIP_immultScalar( im1 , alpha , M )
%
%
%   ATTENTION : on suppose que les images ont été complémentées pour être
%   des images en tons de gris
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
% im            #image d'entrée en niveau de gris      
% alpha         #Scalaire positif
% M              # dynamique maximale de l'image : exemple 256 pour les
%                  images uint8, 65536 pour les images uint16
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
% imout         #image de sortie en double
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIP_immultScalar.m
% Guillaume NOYEL 24-06-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [imout] = LIP_immultScalar( im , alpha , M )

validateattributes(im, {'numeric'}, {'nonempty'}, mfilename, 'im', 1);
%validateattributes(alpha, {'numeric'}, {'scalar', 'nonnegative'}, mfilename, 'alpha', 2);
%validateattributes(alpha, {'numeric'}, {'scalar'}, mfilename, 'alpha', 2);
validateattributes(M, {'numeric'}, {'scalar'}, mfilename, 'M', 3);
        
im = double(im);
alpha = double(alpha);
M = double(M);

%M = double(intmax(class(im)));
imout = M - M*( ( 1 - (im./M) ).^alpha ) ;

end

