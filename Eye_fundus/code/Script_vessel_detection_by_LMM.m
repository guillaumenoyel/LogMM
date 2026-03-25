% Script_essai_detection_DR.m
% Guillaume NOYEL
% 26-05-2021

close all; clearvars;

oldpath = addpath('Function_sources');

% kprob

% 10: DRIVE database (public) - 2 packages

kprob = 10;
kpack = 2;

%% Use normal or darken images
%   flag_darken_images    # flag to use the darken images or normal images
%                               - false : use normal images
%                               - true  : use darken images
flag_darken_images = true;%false;%true;

%% Fixed paramaters

% D : Field of View Diameter : FOV

coeff_D1 = 1/5;  % coefficient of the average diameter of the optic disc : d1 = D*coeff_D1
coeff_D2 = 1/74; % coefficient of the maximal width of vessels : d2 = D*coeff_D2


%% Program


%% Get image filename list
flag_generate_list_filenames_IDs = true; % flag to generate the lists "l_filename_im" and "l_ID"
[l_filename_im,l_relPath] = DR_DB_get_image_filename_list( kprob, kpack , flag_generate_list_filenames_IDs );

% Number of images
[nim] = length(l_filename_im);

%% Get data directory
[ ~ , DATA_D ] = DR_GEN_directory_management( kprob , kpack );

%%        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%         @@@@                                                                   @@@@
%         @@@@     Vessel detection  by bump detector                            @@@@
%         @@@@     (LIP-Mathematical Morphology)                                 @@@@
%         @@@@                                                                   @@@@
%         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


disp 'Vessel detection by bump detector (LIP-Mathematical Morphology)';
kim_ini = 1;
for kim = kim_ini:nim
    fprintf('Image %d / %d \t %.01f %%\n',kim,nim,kim/nim*100);
    filename = fullfile( DATA_D , l_relPath{kim} , l_filename_im{kim} );
    DR_INT_vessel_detection_LMM( kprob , kpack , filename , coeff_D1, coeff_D2 , flag_darken_images );
end

%% Moving all generated files into a folder
kfile = 510; % vessels_mask (LIP-Morpho Math)    
[lefic] = DR_GEN_files_name( kprob,kpack, kfile, filename);
rep_out = fileparts(lefic);
if ~flag_darken_images
    rep_out_new = fullfile(fileparts(lefic),"Results_with_initial_images");
else
    rep_out_new = fullfile(fileparts(lefic),"Results_with_darken_images");
end
% Ensure output directory exists
if exist(rep_out_new, 'dir')
    rmdir(rep_out_new,'s');
end
mkdir(rep_out_new);
% Get a list of all files in the source folder
files = dir(fullfile(rep_out, '*'));

% Move each file to the destination folder
for k = 1:length(files)
    if ~files(k).isdir  % Check if it's not a directory
        movefile(fullfile(rep_out, files(k).name), fullfile(rep_out_new, files(k).name));
    end
end

%% Path management
path(oldpath);
pause(0.1); 


