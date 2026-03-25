%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dans Module FIG (Affichage)
% Ajustement sur plusieurs subplot du ylim de chacune des sous-figures sur le plus grand y_lim
% ylim est la dynamique de l'axe des y sur un subplot
%
% FIG_ajuste_ylim_plusieurs_subplot( tab_subplot )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
% tab_subplot          # tableau des handle de figures
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% Subplots ajustés
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG_ajuste_ylim_plusieurs_subplot.m
% Guillaume Noyel 23-06-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ ] = FIG_ajuste_ylim_plusieurs_subplot( tab_subplot )

Nb_subplot = length(tab_subplot);

%% Récupération du ylim de chacune des subplots
tab_YLim = NaN(Nb_subplot,2); % tableau des limites Y des axes des subplots
for n = 1:Nb_subplot
    tab_YLim(n,:) = get( tab_subplot(n) , 'YLim' );
end

%% Détemination des dynamiques sur l'axe Y
mini_y = min(tab_YLim(:,1));
maxi_y = max(tab_YLim(:,2));

%% Ajustement de ylim
for n = 1:Nb_subplot
    set( tab_subplot(n) , 'YLim' , [ mini_y maxi_y ] );
end

end