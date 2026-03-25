%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Liste toutes les entités dans une chaîne de caractères et renvoie le
% résulta dans une cell
%
% allEntities = list_entities_to_cell( inputString , delimiter )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% inputString          # chaîne de caractère d'entrée
% delimiter            # Chaîne de caractères servant de delimiter : ex. ';'
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% allEntities          # cell des chaînes de caractères trouvées
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ARB_liste_fichiers.m
% Guillaume NOYEL 04-06-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%the strtok function can be used to parse a string list delimited by
%delimiter (e.g. a sentence into words).



function allEntities = list_entities_to_cell( inputString , delimiter )

remainder = inputString;
N_ini = 1000;
allEntities = cell(N_ini,1);

cpt = 0;
while (any(remainder))
    [chopped,remainder] = strtok(remainder,delimiter);
    cpt = cpt+1;
    allEntities{cpt} = chopped; 
end

%cpt = cpt-1;
allEntities = allEntities(1:cpt);

end