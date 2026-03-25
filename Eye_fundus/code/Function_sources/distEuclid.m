

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Distance Euclidienne entre deux ensembles de points (N D) de même dimension
% dist = distEuclid( Pt1 , Pt2 )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% Pt1                # points en ND [ x1,x2,...,xn  ; 
%                                     ... ; 
%                                     x1,x2,...,xn ]
% Pt1                # points en ND [ x1,x2,...,xn  ; 
%                                     ... ; 
%                                     x1,x2,...,xn ]
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% dit                # Distance Euclidienne [ dist1 ; 
%                                               ...;
%                                             distP ]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% distEuclid.m
% Guillaume NOYEL June 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dist = distEuclid( Pt1 , Pt2 )

% [NbPts1,dim1] = size(Pt1);
% [NbPts2,dim2] = size(Pt2);
% if NbPts1 ~= NbPts2 || dim1 ~= dim2
%    error('Pt1 et Pt2 doivent avoir la même taille').
% end

dist = sqrt( sum( (Pt1 - Pt2).^2 , 2 ) );


 
