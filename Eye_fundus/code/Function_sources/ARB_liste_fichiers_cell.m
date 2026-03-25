%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Recherche des fichiers aevc une extension donnée dans un ensemble de
% dossiers et renvoi une cell
%
% [liste_fichiers] = ARB_liste_fichiers_cell( liste_dossiers , extension_fichiers )
% 
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% liste_dossiers        # Liste de dossiers sous forme de cell
% extension_fichiers    # Chaîne de caractères de l'extension de fichiers à
%                         chercher. Exemple '.py'
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% liste_fichiers        # Liste de fichiers sous forme de cell
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ARB_liste_fichiers_cell.m
% Guillaume NOYEL 14-09-2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [liste_fichiers] = ARB_liste_fichiers_cell( liste_dossiers , extension_fichiers )

N_dossiers = length(liste_dossiers);

N_ini = 1000;
liste_fichiers = cell(N_ini,1);
Nf = 0;
for n = 1:N_dossiers
    nom_dossier = liste_dossiers{n};

    list_files = dir( nom_dossier  );
    N_fichiers = length(list_files);
    for ii = 1:N_fichiers
        if( ~list_files(ii).isdir )
            filename = list_files(ii).name;
            [~, ~, extension] = fileparts(filename);
            if( strcmp(extension, extension_fichiers) )% Si l'extension du fichier ne fait pas partie des exceptions
                Nf = Nf + 1;
                liste_fichiers{Nf} = fullfile(nom_dossier,filename);
            end
        end
    end
end

% Suppresion de ce qui a été alloué
liste_fichiers = liste_fichiers(1:Nf);