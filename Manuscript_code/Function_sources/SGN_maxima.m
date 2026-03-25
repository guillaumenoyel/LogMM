%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Obtention des valeurs et des maxima régionaux (ou des maxima de hauteur h) d'un signal
%
% [ val_max , IdxList_max , val_hMax , IdxList_hMax ] = SGN_maxima( s_in , h )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% s_in          # signal d'entrée
% h             # (optionnel) Maxima de hauteur h
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% val_max       # valeurs des maxima (ou des maxima des h-maxima)
% IdxList_max   # Liste des pixels des différents maxima (ou des maxima des h-maxima)
% val_hMax      # Ensemble des valeurs des h-maxima
% IdxList_hMax  # Liste des pixels des différents h-maxima
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SGN_maxima.m
% Guillaume NOYEL June 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ val_max , IdxList_max , val_hMax , IdxList_hMax ] = SGN_maxima( s_in , h )

nb_arg_fixe = 1;
if nargin == nb_arg_fixe
    regional_max_cov = imregionalmax(s_in);
else
    regional_max_cov = imextendedmax(s_in,h);
end

CC = bwconncomp(regional_max_cov);
list_val = regionprops( CC , s_in , 'PixelValues' );
val_max = zeros(1,CC.NumObjects);
IdxList_max = cell( 1 , CC.NumObjects );
val_hMax = cell( 1 , CC.NumObjects );
for n=1: CC.NumObjects
    [val_max(n),IX] = max(list_val(n).PixelValues);
    IdxList_max{n} = CC.PixelIdxList{n}(IX);
    val_hMax{n} = list_val(n).PixelValues;
end
IdxList_hMax = CC.PixelIdxList;