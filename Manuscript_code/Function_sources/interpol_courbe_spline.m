%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolation par spline d'une courbe
% c = interpol_courbe_spline( c , Nb_points )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% c             : courbe d'entrée [ x,y ; x,y ; ... ; x,y] ou [ x,y,z ; x,y,z ; ... ; x,y,z ]
% Nb_points     : (optionnel) nombre de point sur la nouvelle courbe.
%                 Nombre de points par défaut : longueur curviligne
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% c             : courbe interpolée [ x,y ; x,y ; ... ; x,y] ou [ x,y,z ; x,y,z ; ... ; x,y,z ]
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% interpol_courbe_spline.m
% Guillaume NOYEL June 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function c = interpol_courbe_spline( c , Nb_points )

%% Gestion des entrées
nb_arg_fixe = 1;

%% Paramètres

ivoir = 0;

%% Programme

if isempty(c) % on sort avec une matrice vide
    return;
end

if size(c,2) == 2
    
    if ivoir > 0
        fig_1 = figure;
        hp11 = plot(c(:,1),'b-'); hold on;
        title('x');
        
        fig_2 = figure;
        hp21 = plot(c(:,2),'b-'); hold on;
        title('y');        
    end
    
    c( 1+find(diff(c(:,1),1)==0) , : ) = []; % suppression des points ayant la même abscisse
    c( 1+find(diff(c(:,2),1)==0) , : ) = []; % suppression des points ayant la même ordonnée
    
    dx=[0 diff(c(:,1),1)']'; dy=[0 diff(c(:,2),1)']';  
    dr=sqrt(dx.^2+dy.^2); drr=cumsum(dr);
    dlon = drr(end); 
    if nargin == nb_arg_fixe
        pas = 1;
    else
        pas = dlon / (Nb_points-1);
    end
    rat=0:pas:dlon;
    xat=interp1(drr,c(:,1),rat,'spline');
    yat=interp1(drr,c(:,2),rat,'spline');
    c = horzcat( xat' , yat' );
    
    if ivoir > 0
       figure;
       plot(drr,'-r');
       title('drr');
       
       figure(fig_1);
       hp12 = plot(xat,'r-');
       legend([hp11 hp12],'x','xat');
       
       figure(fig_2);
       hp22 = plot(yat,'r-');
       legend([hp21 hp22],'y','yat');
    end
    
elseif size(c,2) == 3
    
    c( 1+find(diff(c(:,1),1)==0) , : ) = []; % suppression des points ayant la même abscisse    
    c( 1+find(diff(c(:,2),1)==0) , : ) = []; % suppression des points ayant la même ordonnée
    c( 1+find(diff(c(:,3),1)==0) , : ) = []; % suppression des points ayant la même côte    
    
    dx=[0 diff(c(:,1),1)']'; dy=[0 diff(c(:,2),1)']';  dz=[0 diff(c(:,3),1)']';
    dr=sqrt(dx.^2+dy.^2+dz.^2); drr=cumsum(dr);
    dlon = drr(end);
    if nargin == 1
        pas = 1;
    else
        pas = dlon / (Nb_points-1);
    end    
    rat=0:pas:dlon;
    xat=interp1(drr,c(:,1),rat,'spline');
    yat=interp1(drr,c(:,2),rat,'spline');
    zat=interp1(drr,c(:,3),rat,'spline');
    c = horzcat( xat' , yat' , zat' );
else
    error('c doit être un tableau avec 2 ou 3 colonnes');
end