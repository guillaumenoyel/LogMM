function [ln_i,ln_j,ln_off,msq_ne_offs] = get_Idx_vois( offs, SZ, les )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Obtention des indices et des offset d'un voisinage sur l'image défini par un élément structurant
% [ln_i,ln_j,ln_off,msq_ne_offs] = get_Idx_vois( offs, SZ, les )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%+
%
% offs            # offset central
% SZ              # taille de l'image [nblig,nbcol] obtenue par size(im)
% les # liste des offsets du voisinage défini par l'élement
% structurant (getneighbors(se))
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% ln_i         #liste des voisins en i (vertical)
% ln_j         #liste des voisins en j (horizontal)
% ln_off         #liste des offsets des voisins
% msq_ne_offs  # masque des offsets des voisins conservés
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Remarque : pour indexer une image utiliser :
% im( ln(1,1):ln(end,1) , ln(1,2):ln(end,2) ) (l'image est mise sous forme de matrice)
% ou  im( ln(:,3) ) (l'image est mise sous forme de vecteur)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_Idx_vois.m
% Guillaume NOYEL June 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Programme

[i,j] = ind2sub(SZ,offs); % Ajouter les offsets pour parcourir l'image
%ln = cat( 2 , i+les(:,1) , j+les(:,2) );
ln_i = i+les(:,1);
ln_j = j+les(:,2);
msq_ne_offs = (ln_i>0) & (ln_j>0) & (ln_i<=SZ(1)) & (ln_j<=SZ(2));
ln_i = ln_i(msq_ne_offs);
ln_j = ln_j(msq_ne_offs);
ln_off = sub2ind(SZ,ln_i,ln_j);


end

