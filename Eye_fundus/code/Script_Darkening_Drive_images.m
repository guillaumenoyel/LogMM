% Script_Darkening_Drive_images.m
% Guillaume NOYEL
% 01/09/2022

close all; clearvars; clear mex;

oldpath = addpath('Function_sources');

% kprob
% 10: DRIVE database (public) - 2 packages

kprob = 10;
kpack = 2; % package number

%% Method of darkening
%   method   : darkening method
%               - 'exponential' : LIP-add an exponential drift up from 100 to 230


method = 'exponential';

%% Flags for running different parts of the program

flag_write_res = false;
para_disp.flag_display  = false;%true;%false;
para_disp.flag_detail   = para_disp.flag_display;%true;%false;

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
%         @@@@     Darkening of the images                                       @@@@
%         @@@@                                                                   @@@@
%         @@@@                                                                   @@@@
%         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


disp 'Darkening of the images';
rim_ini = 1;
for rim = rim_ini:nim
    fprintf('Image %d / %d \t %.01f %%\n',rim,nim,rim/nim*100);
    filename = fullfile( DATA_D , l_relPath{rim} , l_filename_im{rim} );
    fprintf('Image %d / %d \t %.01f \n%s\n',rim,nim,rim/nim*100,filename);
    DR_INT_image_darkening( kprob , kpack , filename , method );
end


%% Path management
path(oldpath);
pause(0.1); 
