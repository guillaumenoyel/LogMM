
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Informations are determined according to the filename the problem
%   number end the campaign number
%
%    [ROOT_D, DATA_D] = DR_GEN_directory_management( kprob , kpack )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% INPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%   kprob  : problem number données web
%           10  DRIVE database (public) - 2 packages
%
%   kpack  : number of acquisition package
%            1  first package of images
%            2  second package of images
%            i  i-th package of images
%
%   filename : image filename
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% OUTPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%   ROOT_D       : root path
%   DATA_D       : DATA_path
%   RES_D        : Result directory
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Guillaume NOYEL
% DR_GEN_directory_management.m
% 18-09-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [ROOT_D, DATA_D , extension_F , RES_D] = DR_GEN_directory_management( kprob , kpack )

%% Database diaretb (Finland)
if kprob == 10 % DRIVE database

   ROOT_D = fullfile(fileparts(mfilename("fullpath")),'../../'); % Root directory
    extension_F = '*.tif';
    if kpack == 1
        str_pack ='training';
    elseif kpack == 2
        str_pack ='test';
    else
        error('kpack number %d not (yet) existing',kpack);
    end

    DATA_D  = fullfile(ROOT_D,'Input','im','DRIVE',str_pack); % data directory
    RES_D   = fullfile(ROOT_D,'Results'); % results directory
else
    error('kprob number %d not (yet) existing',kprob);
end


end

