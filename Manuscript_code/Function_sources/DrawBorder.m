% DrawBorder.m 
% Guillaume NOYEL June 2021

function [imout] = DrawBorder(imin,const)
%[imout] = DrawBorder(imout,const)
%Met le cadre extérieur (d'épaisseur 1 pixel) de l'image à la valeur const

    imout = imin;
    imout( 1 , : ) = const ; % côté supérieur
    imout( size(imin,1) , : ) = const ; % côté inférieur
    imout( : , 1 ) = const ; % côté gauche
    imout( : , size(imin,2) ) = const ; % côté droit