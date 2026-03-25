%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dans Module FIG (Affichage)
% Ajustement sur plusieurs figures du xlim, ylim et zlim de chacune des
% figures sur les plus grands xlim, y_lim et zlim
% des figures
% xlim est la dynamique de l'axe des x sur une figure
% ylim est la dynamique de l'axe des y sur une figure
% zlim est la dynamique de l'axe des z sur une figure
%
% FIG_ajuste_xylim_plusieurs_fig( tab_fig )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
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
% FIG_ajuste_xylim_plusieurs_fig.m
% Guillaume Noyel 25-11-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ ] = FIG_ajuste_xylim_plusieurs_fig( tab_fig )

Nb_fig = length(tab_fig);

%% Récupération du ylim de chacune des figures
tab_XLim = NaN(Nb_fig,2); % tableau des limites X des axes des figures
tab_YLim = NaN(Nb_fig,2); % tableau des limites Y des axes des figures
tab_ZLim = NaN(Nb_fig,2); % tableau des limites Z des axes des figures
for n = 1:Nb_fig
    tab_XLim(n,:) = get( get(tab_fig(n),'CurrentAxes') , 'XLim' );
    tab_YLim(n,:) = get( get(tab_fig(n),'CurrentAxes') , 'YLim' );
    tab_ZLim(n,:) = get( get(tab_fig(n),'CurrentAxes') , 'YLim' );
end

%% Détemination des dynamiques sur les axes X, Y et Z
mini_x = min(tab_XLim(:,1));
maxi_x = max(tab_XLim(:,2));
mini_y = min(tab_YLim(:,1));
maxi_y = max(tab_YLim(:,2));
mini_z = min(tab_ZLim(:,1));
maxi_z = max(tab_ZLim(:,2));

%% Ajustement de xlim, ylim et zlim
for n = 1:Nb_fig
    set( get(tab_fig(n),'CurrentAxes') , 'XLim' , [ mini_x maxi_x ] );
    set( get(tab_fig(n),'CurrentAxes') , 'YLim' , [ mini_y maxi_y ] );
    set( get(tab_fig(n),'CurrentAxes') , 'YLim' , [ mini_z maxi_z ] );
end

end