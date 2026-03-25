%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Get the image table and the image filename list from the database
%
%   [l_filename_im, l_relPath] = DR_DB_get_image_filename_list( kprob, kpack , flag_rw_tmp )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% INPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%   kprob  : problem number data web
%
%   kpack  : number of acquisition package
%            1  first package of images
%            1  second package of images
%            i  i-th package of images
%
%   flag_rw_tmp     # flag to delete the temporary mat file with the
%   database tree
%
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% OUTPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%   l_filename_im   : list of the image filenames
%   l_relPath       : list of relatives paths from DATA_path
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DR_DB_get_image_filename_list.m
% Guillaume NOYEL 04-09-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [l_filename_im , l_relPath] = DR_DB_get_image_filename_list( kprob, kpack , flag_rw_tmp )




%% Default outputs

l_filename_im = {};
l_relPath = {};


%% Programme



kfile = 4; % list filenames
[filename] = DR_GEN_files_name(kprob,kpack, kfile);
if flag_rw_tmp
   Effacer_fichiers(filename);
end

if exist(filename,'file') == 2
    load(filename,'l_filename_im','l_relPath');
else
    [~ , DATA_D , extension_F ] = DR_GEN_directory_management( kprob , kpack );
    im_DIR = fullfile(DATA_D,'images');

    %[l_filename_im] = DR_DB_file_list( DATA_D , extension_F );
    [l_filename_im] = ARB_liste_fichiers_cell( {im_DIR} , extension_F(2:end) );

    % file list with a relative path
    lng_str = length(im_DIR)+1 + length(filesep);
    lng_str_DATA = length(DATA_D)+1 + length(filesep);
    nim = length(l_filename_im);
    l_relPath = cell(nim,1);
    for n = 1:nim
        l_relPath{n} = l_filename_im{n}(lng_str_DATA:lng_str-2);
        l_filename_im{n} = l_filename_im{n}(lng_str:end);
    end

    ajout_dossier(filename);
    save(filename,'l_filename_im','l_relPath');
end

end

