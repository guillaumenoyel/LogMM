%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ecran = get_screen_size()
% Obtention de la taille et des coodonnées de l'écran d'affichage
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%          # (optionnel) n° de l'écran (0 ou 1)
%               valeur par défaut : 0 si un seul écran
%                                   1 si plusieurs écran
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% ecran    # taille de l'écran [ x_bas , y_bas , largeur_x , hauteur_y ]
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% EXEMPLE%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
% 
% ecran = get_screen_size();
% pos_fenetre = [ ecran(1) , ecran(2) , ecran(3) , ecran(4) ];
% figure(fig_ref);
% set(fig_ref,'OuterPosition',pos_fenetre);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_screen_size.m 
% Guillaume NOYEL 12-06-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ecran = get_screen_size(no_ecran)

scrsz = get(0,'MonitorPositions');
Nb_ecrans = size(scrsz,1); % Nombre d'écrans

nb_arg_fixe = 0;
switch nargin
    case nb_arg_fixe
       if Nb_ecrans > 1
           no_ecran = 1;
       else
           no_ecran = 0;
       end
    case nb_arg_fixe + 1;
        % OK
    otherwise
        error('Nombre d''arguments incorrect');
end

if no_ecran+1 > Nb_ecrans
    no_ecran = Nb_ecrans-1;
end

% Taille de l'écran
tab_ecrans = zeros( Nb_ecrans , 4 );
ecran_0 = scrsz(1,:);
tab_ecrans( 0+1 , : ) = ecran_0;% écran 0

if Nb_ecrans > 1
    ecran_1 = scrsz(2,:);
%     ecran_1(3) = ecran_1(3) - ecran_1(1)+1;%abs(ecran_1(1));%abs(ecran_1(3) - ecran_0(3));
%     ecran_1(2) = ecran_1(2)-(ecran_1(4)-ecran_0(4));
    tab_ecrans( 1+1 , : ) = ecran_1;% écran 1
end

ecran = tab_ecrans( no_ecran+1 , : );
