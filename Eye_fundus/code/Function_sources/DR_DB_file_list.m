
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   List of images files
%
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% INPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%   DATA_D       : DATA_path
%   extension_F  : file extension
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% OUTPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%   l_files  : list of files with a relative path (related to the Data
%   path)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DR_DB_file_list.m
% Guillaume NOYEL  10-09-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [l_files] = DR_DB_file_list( DATA_D , extension_F )

liste_dossiers = list_entities_to_cell(genpath(DATA_D),';');
liste_dossiers = liste_dossiers(1:end-1);

[l_files] = ARB_liste_fichiers_cell( liste_dossiers , extension_F(2:end) );

% file list with a relative path
lng_str = length(DATA_D)+1 + length(filesep);
for n = 1:length(l_files)
    l_files{n} = l_files{n}(lng_str:end);
end


end

