%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Maximisation of the histrogram range between 0 and 255
% [imout] = stretchimage( imin , mini , maxi )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imin            # image d'entrée en niveau de gris      
% mini            # (Optionnel) Point minimum de l'histogramme de sortie.
%                       Par défaut : minimimum de l'image d'entrée
% maxi            # (Optionnel) Point maximum de l'histogramme de sortie
%                       Par défaut : maximimum de l'image d'entrée
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imout           # image de sortie
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stretchimage.m
% Guillaume Noyel June 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%function [imout] = stretchimage(imin)
%     mini = min(min(imin));
%     maxi = max(max(imin));
%     imout = uint8(255.*(im2double(imin)-mini)/double(maxi-mini));

function [imout] = stretchimage(imin , varargin )
    if(nargin < 3)
        mini = min(imin(:));
        maxi = max(imin(:));
    elseif(nargin == 3)
        mini = varargin{1};%cell2mat(varargin(1))
        maxi = varargin{2};
        imin(imin < mini) = mini;
        imin(imin > maxi) = maxi;
    end
    imout = uint8(255.*(double(imin)-double(mini))/(double(maxi)-double(mini)));
    
    
    % ATTENTION : ne pas utiliser im2double qui fait une nouvelle
    % quantification des niveaux de gris l'image
    % NON !!!
    % imout = uint8(255.*(im2double(imin)-double(mini))/(double(maxi)-double(mini)));   
    % NON !!!
    