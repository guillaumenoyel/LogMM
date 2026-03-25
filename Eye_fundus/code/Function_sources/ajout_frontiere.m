%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ajout de la frontière d'un masque sur l'image
% [im_col] = ajout_frontiere( im , masque , col , n_dilatation )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im            #image d'entrée en niveau de gris      
% masque        #image de masque
% col           # couleur. Par défaut : [ 0 0 255 ], i.e. bleu
% n_dilatation  #Nombre de dilatations pour l'épaisseur du trait de la frontière (épaisseur de 1 pixel par défaut en 8-connexité)
%                   Pad défaut 1;
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%im_col        #image 2D couleur avec les contours des frontières du masque en rouge
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ajout_frontiere.m
% Guillaume NOYEL June 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [im_col] = ajout_frontiere( im , masque , col , n_dilatation )


%% Paramètres
Affichage = 0;

%% Arguments et Sorties par défaut

nb_arg_fixe = 2;
switch nargin
    case nb_arg_fixe
        col = [0 0 255];
        n_dilatation = 1;
    case nb_arg_fixe + 1
        n_dilatation = 1;
    case nb_arg_fixe + 2
        % OK
    otherwise
        error(mfilename, '##Pbm : Nombre d''arguments incorrect');
end

%% Programme

% Si l'image d'entrée n'est pas en 8 bits on fait un ajustement
% d'histogramme
if ~isa(im,'uint8')
    im = stretchimage(im);
end

switch size(im,3) 
    case 1
        im_col = cat(3,im,im,im);
    case 3
        im_col = im;
    otherwise
        error('size(im,3) = %d : type d''image non supporté',size(im,3) );
end

%% Ajout de la frontière

if any(masque(:))
    if n_dilatation > 1
        masque2 = xor( bwmorph(masque,'erode',1) , bwmorph(masque,'dilate',n_dilatation-1) );
    else
       masque2  = xor( bwmorph(masque,'erode',1) , masque ); 
    end
    %il faudrait mettre imsubtract mais comme masque est inclus dans son dilaté
    % xor est plus rapide

    temp = im_col(:,:,1);
    temp(masque2) = col(1);
    im_col(:,:,1) = temp;

    temp = im_col(:,:,2);
    temp(masque2) = col(2);
    im_col(:,:,2) = temp;

    temp = im_col(:,:,3);
    temp(masque2) = col(3);
    im_col(:,:,3) = temp;
end

if Affichage == 2
    figure;
    imagesc(im_col);
    title('image + contours');
    axis equal
end

