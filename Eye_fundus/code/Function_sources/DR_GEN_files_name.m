
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   The file_out is determined from the problem number (kprob), the
%   acquisition package number (kpack) and the file number (kfile)
%
%   [file_out] = DR_GEN_files_name( kprob,kpack, kfile, filename_im )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% INPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%   kprob  : problem number data web
%           10  DRIVE database (public) - 2 packages
%
%   kpack  : number of acquisition package
%            1  first package of images
%            1  second package of images
%            i  i-th package of images
%
%   kfile  : number of the file name to generate
%
%   filename_im : full image file name
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% OUTPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%   file_out : name of the chosen file
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Guillaume NOYEL
% DR_GEN_files_name.m
% 18-09-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [file_out] = DR_GEN_files_name( kprob,kpack, kfile, filename_im )

[ ~ , DATA_D , ~ , RES_D ] = DR_GEN_directory_management( kprob , kpack );

if nargin==3
    filename_im = '';
end

if kfile == 4 % list filenames
    file_out = fullfile(RES_D,'Res/list_filenames.mat');
end    
    %% Results

 
%% kprob = 10: DRIVE database (public) - 2 packages
[~,r_f] = fileparts(filename_im); %root of filemane_in
if kprob == 10
    
    
    if kfile==510
        file_out=sprintf('%s/LMM/mask_vessels_LMM_%s.png',RES_D,r_f);% Mask of the extracted vessels (LIP-Morpho Math)
    elseif kfile==511
        file_out=sprintf('%s/LMM/vesselness_LMM_%s.mat',RES_D,r_f);% Vesselness (LIP-Morpho Math)
    elseif kfile==512
        file_out=sprintf('%s/LMM/im_vessels_LMM_%s.png',RES_D,r_f);% Image with the border of the vessels (LIP-Morpho Math)
    elseif kfile==513
        file_out=sprintf('%s/LMM/fig_vesselness_LMM_%s.fig',RES_D,r_f);% Figure vesselness (LIP-Morpho Math)
    elseif kfile==514
        file_out=sprintf('%s/LMM/fig_vesselness_LMM_%s.svg',RES_D,r_f);% Figure vesselness (LIP-Morpho Math) - svg
    elseif kfile==515
        file_out=sprintf('%s/LMM/fig_vesselness_LMM_%s.png',RES_D,r_f);% Figure vesselness (LIP-Morpho Math) - png
    elseif kfile==516
        file_out=sprintf('%s/LMM/fig_vesselness_norm_LMM_%s.png',RES_D,r_f);% Figure vesselness normalised (LIP-Morpho Math) - png            
    elseif kfile==517
        file_out=sprintf('%sLMM/fig_vesselness_im_LMM_%s.png',RES_D,r_f);% Image vesselness (LIP-Morpho Math) - png


    elseif kfile==520
        file_out=sprintf('%s/RVGAN/pred_ini/Fine/%s.png',RES_D,r_f(1:2));% Mask of the extracted vessels (RVGAN)
    elseif kfile==521
        file_out=sprintf('%s/RVGAN/pred_ini/Fine/%s_vesselness_map.h5',RES_D,r_f(1:2));% Vesselness (RVGAN)

    elseif kfile==530
        file_out=sprintf('%s/RF-Unet/pred_ini/pre_b%d.png',RES_D,str2double(r_f(1:2))-1);% Mask of the extracted vessels (RF-UNet)
    elseif kfile==531
        file_out=sprintf('%s/RF-Unet/pred_ini/pre%d.h5',RES_D,str2double(r_f(1:2))-1);% Vesselness (RF-UNet)
    elseif kfile==532
        file_out=sprintf('%s/RF-Unet/pred_ini/gt%d.png',RES_D,str2double(r_f(6:end)));% Ground truth Vesselness (RF-UNet)            


    elseif kfile==540
        file_out=sprintf('%s/SGL/pred_ini/results-DRIVET/%s_training_x1_vessel_map.png',RES_D,r_f(1:2));% Mask of the extracted vessels (SGL)
    elseif kfile==541
        file_out=sprintf('%s/SGL/pred_ini/results-DRIVET/%s_training_x1_vesselness_map.h5',RES_D,r_f(1:2));% Vesselness (SGL)

    elseif kfile==61
    

    elseif kfile==210
        file_out=sprintf('%s/im_dark/im_dark_LP_100_%s.png',RES_D,r_f);% Darkened image by LIP-adding a constant of 100 in PNG format
    elseif kfile==2100
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_100/%s.tif',RES_D,r_f);% Darkened image by LIP-adding a constant of 100 in TIF format     
    elseif kfile==211
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_170/%s.png',RES_D,r_f);% Darkened image by LIP-adding a constant of 170 in PNG format                          
    elseif kfile==2110
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_170/%s.tif',RES_D,r_f);% Darkened image by LIP-adding a constant of 170 in TIF format    
    elseif kfile==212
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_linear_170_to_200/%s.png',RES_D,r_f);% Darkened image by LIP-adding a linear drift from 170 to 200 in PNG format                          
    elseif kfile==2120
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_linear_170_to_200/%s.tif',RES_D,r_f);% Darkened image by LIP-adding a linear drift from 170 to 200 in TIF format                                  
    elseif kfile==213
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_quadratic_170_to_200/%s.png',RES_D,r_f);% Darkened image by LIP-adding a quadratic drift from 170 to 200 in PNG format                          
    elseif kfile==2130
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_quadratic_170_to_200/%s.tif',RES_D,r_f);% Darkened image by LIP-adding a quadratic drift from 170 to 200 in TIF format                      

    elseif kfile==214
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_linear_30_to_200/%s.png',RES_D,r_f);% Darkened image by LIP-adding a linear drift from 30 to 200 in PNG format                          
    elseif kfile==2140
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_linear_30_to_200/%s.tif',RES_D,r_f);% Darkened image by LIP-adding a linear drift from 30 to 200 in TIF format                                  
    elseif kfile==215
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_quadratic_30_to_200/%s.png',RES_D,r_f);% Darkened image by LIP-adding a quadratic drift from 30 to 200 in PNG format                          
    elseif kfile==2150
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_quadratic_30_to_200/%s.tif',RES_D,r_f);% Darkened image by LIP-adding a quadratic drift from 30 to 200 in TIF format   

    elseif kfile==216
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_exponential_to_170/%s.png',RES_D,r_f);% Darkened image by LIP-adding an exponential drift up to 170 in PNG format                            
    elseif kfile==2160
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_exponential_to_170/%s.tif',RES_D,r_f);% Darkened image by LIP-adding an exponential drift up to 170 in TIF format            
    elseif kfile==2161
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_exponential_to_230/%s.png',RES_D,r_f);% Darkened image by LIP-adding an exponential drift up to 230 in PNG format                            
    elseif kfile==21610
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_exponential_to_230/%s.tif',RES_D,r_f);% Darkened image by LIP-adding an exponential drift up to 230 in TIF format 
    elseif kfile==216100
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_exponential_to_230_diam_1s8/%s.png',RES_D,r_f);% Darkened image by LIP-adding an exponential drift up to 230 diameter Rc/8 in PNG format                            
    elseif kfile==216101
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_exponential_to_230_diam_1s8/%s.tif',RES_D,r_f);% Darkened image by LIP-adding an exponential drift up to 230 diameter Rc/8 in TIF format 

    elseif kfile==21611
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_exponential_to_225/%s.png',RES_D,r_f);% Darkened image by LIP-adding an exponential drift up to 225 in PNG format                            
    elseif kfile==21612
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_exponential_to_225/%s.tif',RES_D,r_f);% Darkened image by LIP-adding an exponential drift up to 225 in TIF format 
    elseif kfile==21613
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_exponential_to_235/%s.png',RES_D,r_f);% Darkened image by LIP-adding an exponential drift up to 235 in PNG format                            
    elseif kfile==21614
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_exponential_to_235/%s.tif',RES_D,r_f);% Darkened image by LIP-adding an exponential drift up to 235 in TIF format 


    elseif kfile==2162
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_exponential_100_to_230/%s.png',RES_D,r_f);% Darkened image by LIP-adding an exponential drift from 100 to 230 in PNG format                            
    elseif kfile==21620
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_exponential_100_to_230/%s.tif',RES_D,r_f);% Darkened image by LIP-adding 3 exponentials drift from 100 to 230 in TIF format  
    elseif kfile==2163
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_exponential_110_to_240/%s.png',RES_D,r_f);% Darkened image by LIP-adding an exponential drift from 110 to 240 in PNG format                            
    elseif kfile==21630
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_exponential_110_to_240/%s.tif',RES_D,r_f);% Darkened image by LIP-adding 3 exponentials drift from 110 to 240 in TIF format  

    elseif kfile==217
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_3_exponentials_100_to_230/%s.png',RES_D,r_f);% Darkened image by LIP-adding 3 exponentials drift up to 170 in PNG format                            
    elseif kfile==2170
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_3_exponentials_100_to_230/%s.tif',RES_D,r_f);% Darkened image by LIP-adding 3 exponentials drift up to 170 in TIF format 
    
    elseif kfile==218
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_3_gaussians_100_to_230/%s.png',RES_D,r_f);% Darkened image by LIP-adding 3 dark gaussians drift from 100 to 230 in PNG format                            
    elseif kfile==2180
        file_out=sprintf('%s/im_dark/DRIVE/test/images/im_dark_LP_3_gaussians_100_to_230/%s.tif',RES_D,r_f);% Darkened image by LIP-adding 3 dark gaussians  drift up from 100 to 230 in TIF format 
    end
    
    
    
    
    %% kprob = 10: DRIVE database (public) - 2 packages
    if kprob == 10 %
        if kfile == 11011 % Mask given with the image database
            file_out=sprintf('%s/mask/%s_mask.gif',DATA_D,r_f);% mask given with the data
        elseif kfile == 11012 % Manual segmentation 1 (reference)
            file_out=sprintf('%s/1st_manual/%s_manual1.gif',DATA_D,r_f(1:2));% mask given with the data
        elseif kfile == 11013 % Manual segmentation 2
            if kpack == 2
                file_out=sprintf('%s/2nd_manual/%s_manual2.gif',DATA_D,r_f(1:2));% mask given with the data                
            else
                error('Drive database, no 2nd manual segmentation')
            end
            
        end
    end
    
else
    error('Error kprob %d',kprob);
end
    
end




