%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Homthétique d'un élément structurant : on a dilaté l'e.s. Homothetic_size-1 fois par
% son réfléchi
% [se_Homothetic] = HomotheticSE( se , Homothetic_size )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% se                # élément structurant unitaire
% Homothetic_size   # Taille de l'homothétique
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% se_Homothetic     # élément structurant homothétique
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HomotheticSE.m
% Guillaume NOYEL Juin 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [se_Homothetic] = HomotheticSE( se , Homothetic_size )


%% Paramètres

ivoir = 0;

%% Vérifications entrées
if Homothetic_size < 1
    error('Homothetic_size doit être supérieur ou égale à 1');
end

%% Programme
Nb = Homothetic_size - 1; % Nombre de dilatations

NHOOD = se.getnhood;
dim_se = size(NHOOD);


%SZ = [19 19];
SZ = Nb*round((dim_se-1)/2)*2 + dim_se;
se_dil_NHOOD = zeros(SZ);


se_reflect = se.reflect;

centre = round(SZ/2);
neighbors = se.getneighbors;

ind_neighbors = sub2ind( SZ , centre(1) + neighbors(:,1) , centre(2) + neighbors(:,2) );
se_dil_NHOOD( ind_neighbors )  = 1;

if ivoir > 0
    im_sum = se_dil_NHOOD;
end

if is_strel_hex(se)
    %     se_dil_NHOOD_i = se_dil_NHOOD; % Lignes paires
    %     se_dil_NHOOD_p = se_dil_NHOOD; % Lignes impaires
    %
    %     IX_i = mod(neighbors(:,1),2) == 1;
    %     IX_p = ~IX_i;
    %
    %     ind_neighbors_i = sub2ind( SZ , centre(1) + neighbors(IX_i,1) , centre(2) + neighbors(IX_i,2) );
    %     ind_neighbors_p = sub2ind( SZ , centre(1) + neighbors(IX_p,1) , centre(2) + neighbors(IX_p,2) );
    %
    %     se_dil_NHOOD_i( ind_neighbors_i )  = 1;
    %     se_dil_NHOOD_p( ind_neighbors_p )  = 1;
    
    nlig = SZ(1);
    
    if mod(centre(1),2) == 0 % centre pair
        ind_p = 2:2:nlig;
        ind_i = 1:2:nlig;
    else
        ind_i = 2:2:nlig;
        ind_p = 1:2:nlig;
    end

    
    for n=1:Nb
        se_dil_NHOOD_i =  zeros(SZ);
        se_dil_NHOOD_p =  zeros(SZ);
        se_dil_NHOOD_i( ind_i , : ) = se_dil_NHOOD( ind_i , : );
        se_dil_NHOOD_p( ind_p , : ) = se_dil_NHOOD( ind_p , : );
        
        se_dil_NHOOD_i = imdilate(se_dil_NHOOD_i,se_reflect); % dilatation des lignes impaires avec l'es symétrique
        se_dil_NHOOD_p = imdilate(se_dil_NHOOD_p,se);         % dilatation des lignes paires avec l'es
        se_dil_NHOOD = or( se_dil_NHOOD_i , se_dil_NHOOD_p );
        %se_dil_NHOOD( ind_i , : ) = se_dil_NHOOD_i( ind_i , : );
        %se_dil_NHOOD( ind_p , : ) = se_dil_NHOOD_p( ind_p , : );
        disp ''
    end
    
else
    
    for n=1:Nb
        se_dil_NHOOD = imdilate(se_dil_NHOOD,se_reflect);
    end
end


se_Homothetic = strel('arbitrary',se_dil_NHOOD);

%% Affichage

if ivoir > 0
    
    se_dil_NHOOD = im_sum;
    for n=1:Nb
        se_dil_NHOOD = imdilate(se_dil_NHOOD,se_reflect);
        im_sum = im_sum + se_dil_NHOOD;
    end
    
    figure;
    imagesc(im_sum); colormap gray
    title('Image somme')
    axis equal
end

end

