%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abscisse curviligne d'une courbe
% [drr,dlon] = abscisse_curviligne_courbe( c )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% c             : courbe d'entrée [ x,y ; x,y ; ... ; x,y] ou [ x,y,z ; x,y,z ; ... ; x,y,z ]
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% drr           : abscisse curviligne après suppression des points ayant la
%                 même abscisse et la même ordonnée
% dlon          : longueur curviligne après suppression des points ayant la
%                 même abscisse et la même ordonnée
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% abscisse_curviligne_courbe.m
% Guillaume NOYEL June 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [drr,dlon] = abscisse_curviligne_courbe( c )

if size(c,2) == 2
    
    c( 1+find(diff(c(:,1),1)==0) , : ) = []; % suppression des points ayant la même abscisse
    c( 1+find(diff(c(:,2),1)==0) , : ) = []; % suppression des points ayant la même ordonnée
    
    dx=[0 diff(c(:,1),1)']'; dy=[0 diff(c(:,2),1)']';
    dr=sqrt(dx.^2+dy.^2);
    drr=cumsum(dr);     dlon = drr(end); 
elseif size(c,2) == 3
    
    c( 1+find(diff(c(:,1),1)==0) , : ) = []; % suppression des points ayant la même abscisse    
    c( 1+find(diff(c(:,2),1)==0) , : ) = []; % suppression des points ayant la même ordonnée
    c( 1+find(diff(c(:,3),1)==0) , : ) = []; % suppression des points ayant la même côte    
    
    dx=[0 diff(c(:,1),1)']'; dy=[0 diff(c(:,2),1)']';  dz=[0 diff(c(:,3),1)']';
    dr=sqrt(dx.^2+dy.^2+dz.^2); 
    drr=cumsum(dr);    dlon = drr(end);
else
    error('c doit être un tableau avec 2 ou 3 colonnes');
end