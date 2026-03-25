%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Obtention des valeurs et des minima régionaux (ou des minima de profondeur h) d'un signal
%
% [ val_min , IdxList_min , val_hMin , IdxList_hMin ] = SGN_minima( s_in , h )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% s_in          # signal d'entrée
% h             # (optionnel) Minima de hauteur h
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% val_min       # valeurs des minima (ou des minima des h-minima)
% IdxList_min   # Liste des pixels des différents minima (ou des minima des h-minima)
% val_hMin      # Ensemble des valeurs des h-minima
% IdxList_hMin  # Liste des pixels des différents h-minima
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SGN_minima.m
% Guillaume NOYEL June 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ val_min , IdxList_min , val_hMin , IdxList_hMin ] = SGN_minima( s_in , h )

if isa( s_in , 'double' ) % gestion de la double précision
    maxi = max(s_in(:));
    s_in = my_imcomplement( s_in , maxi ); % On complémente sur le maxima
else
    s_in = imcomplement( s_in );
end

nb_arg_fixe = 1;
if nargin == nb_arg_fixe
    [ val_min , IdxList_min , val_hMin , IdxList_hMin ] = SGN_maxima( s_in );
else
    [ val_min , IdxList_min , val_hMin , IdxList_hMin ] = SGN_maxima( s_in , h );
end
    
% On complémente les valeurs des minima et h-minima
val_min = my_imcomplement( val_min , maxi );
for n = 1:length(val_hMin)
    val_hMin{n} = my_imcomplement( val_hMin{n} , maxi );
end

end

function [im] = my_imcomplement( im , M ) 

im = M + 1 - im ;

end