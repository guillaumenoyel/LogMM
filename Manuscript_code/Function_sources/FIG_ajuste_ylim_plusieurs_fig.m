%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dans Module FIG (Affichage)
% Ajustement sur plusieurs figures du ylim de chacune des figures sur le plus grand y_lim
% figures
% ylim est la dynamique de l'axe des y sur une figure
%
% FIG_ajuste_ylim_plusieurs_fig( tab_fig )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
% tab_fig          # tableau des handle de figures
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% Figures ajustées
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG_ajuste_ylim_plusieurs_fig.m
% Guillaume Noyel 23-06-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ ] = FIG_ajuste_ylim_plusieurs_fig( tab_fig )

Nb_fig = length(tab_fig);

%% Récupération du ylim de chacune des figures
tab_YLim = NaN(Nb_fig,2); % tableau des limites Y des axes des figures
for n = 1:Nb_fig
    tab_YLim(n,:) = get( get(tab_fig(n),'CurrentAxes') , 'YLim' );
end

%% Détemination des dynamiques sur l'axe Y
mini_y = min(tab_YLim(:,1));
maxi_y = max(tab_YLim(:,2));

%% Ajustement de ylim
for n = 1:Nb_fig
    set( get(tab_fig(n),'CurrentAxes') , 'YLim' , ...
        [ mini_y maxi_y ] );
end

end