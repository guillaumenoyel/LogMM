
% Script_Eval_results_Drive_with_Matlab.m.m
% The average of ROC curves is computed with Matlab
% Guillaume NOYEL
% 02-09-2022

close all; clearvars;

%restoredefaultpath
oldpath = addpath('Function_sources');


% kprob
% 10: DRIVE database (public) - 2 packages

kprob = 10;
kpack = 2; % package number

flag_av_ROC = true; % flag to average the ROC curves


flag_write_res = true;
para_disp.flag_display  = true;%true;%false;
para_disp.flag_detail   = false;%true;%false;

%% Program

flag_generate_list_filenames_IDs = true; % flag to generate the lists "l_filename_im" and "l_ID"
[l_filename_im,l_relPath] = DR_DB_get_image_filename_list( kprob, kpack , flag_generate_list_filenames_IDs );

%% Get data directory
[ ~ , DATA_D ] = DR_GEN_directory_management( kprob , kpack );
s1 = dir(DATA_D);

%% Get image filename list


%% Parameters


para_disp.tab_fig                   = NaN(1,100);
para_disp.cpt_fig                   = 0;
para_disp.cpt_pos                   = 0;



%% Progammme


% % dialog box to select the folder


%--------- LMM segmentations (to be compared)

kfile = 510; % vessels_mask (LIP-Morpho Math)
[filename_seg] = DR_GEN_files_name( kprob,kpack, kfile, l_filename_im{1});
dir_analysed_LMM = fileparts(filename_seg);

%--------- RVGAN segmentations (to be compared)

kfile = 520; % vessels_mask (RVGAN)
[filename_seg] = DR_GEN_files_name( kprob,kpack, kfile, l_filename_im{1});
dir_analysed_RVGAN = fileparts(filename_seg);

%--------- RFUnet segmentations (to be compared)

kfile = 530; % vessels_mask (RFUnet)
[filename_seg] = DR_GEN_files_name( kprob,kpack, kfile, l_filename_im{1});
dir_analysed_RFUnet = fileparts(filename_seg);

%--------- SGL segmentations (to be compared)

kfile = 540; % vessels_mask (RFUnet)
[filename_seg] = DR_GEN_files_name( kprob,kpack, kfile, l_filename_im{1});
dir_analysed_SGL = fileparts(filename_seg);

list_dir_analysed = {fullfile(dir_analysed_LMM,'Published') ;  ...
    fullfile(dir_analysed_LMM,'Published_with_darken_images_exponential_to_230') ; ...      
    dir_analysed_RVGAN ; ...
    manage_path_str(fullfile(dir_analysed_RVGAN,'..','..','pred_drk_LP_exponential_to_230','Fine'));...
    dir_analysed_RFUnet; ...
    manage_path_str(fullfile(dir_analysed_RFUnet,'..','pred_drk_LP_exponential_to_230'));... 
    dir_analysed_SGL;
    manage_path_str(fullfile(dir_analysed_SGL,'..','..','pred_drk_LP_exponential_to_230','results-DRIVET'));
    };
list_plot = {'LMM';...
    'LMM dark exponential to 230';...
    'RVGAN';...
    'RVGAN dark exponential to 230';...
    'RF-Unet'; 
    'RF-Unet dark exponential to 230';
    'SGL';
    'SGL dark exponential to 230'};

%selected curves
list_select = {'LMM','LMM dark exponential to 230',...
   'RF-Unet','RF-Unet dark exponential to 230',...
   'RVGAN','RVGAN dark exponential to 230',...
   'SGL','SGL dark exponential to 230'};

[msk_select]= ismember(list_plot,list_select);
list_dir_analysed = list_dir_analysed(msk_select);
list_plot = list_plot(msk_select);

if para_disp.flag_display
    fig_ROC = figure; hold on
end

nim = length(l_filename_im);% number of images
l_filename_seg          = cell(1,nim);
l_filename_vesselness   = cell(1,nim);
l_filename_im_new       = cell(1,nim);
tab_rim_new             = NaN(nim,1);
nb_methods              = length(list_dir_analysed);
tab_results             = cell(nb_methods,9);
%% For each method

for k_dir = 1:nb_methods

    dir_analysed = list_dir_analysed{k_dir};

    fprintf('Analysed repository : %s\n',dir_analysed);

    
    for rim=1:nim
        filename_in = l_filename_im{rim};
        switch list_plot{k_dir}
            case {'LMM','LMM dark exponential to 230'}
                kfile = 510; % vessels_mask (LIP-Morpho Math)
                [filename_seg] = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
                [~,fname,ext] = fileparts(filename_seg);
                l_filename_seg{rim} = fullfile(dir_analysed,[fname,ext]);

                kfile = 511; % Vesselness (LIP-Morpho Math)
                [lefic] = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
                [~,fname,ext] = fileparts(lefic);
                l_filename_vesselness{rim} = fullfile(dir_analysed,[fname,ext]);

            case {'RVGAN','RVGAN dark exponential to 230'}
                kfile = 520; % vessels_mask (RVGAN)
                [filename_seg] = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
                [~,fname,ext] = fileparts(filename_seg);
                l_filename_seg{rim} = fullfile(dir_analysed,[fname,ext]);

                kfile = 521; % Vesselness (RVGAN)
                [lefic] = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
                [~,fname,ext] = fileparts(lefic);
                l_filename_vesselness{rim} = fullfile(dir_analysed,[fname,ext]); 
                
            case {'RF-Unet','RF-Unet dark exponential to 230'}
                kfile = 530; % vessels_mask (RF-Unet)
                filename_seg = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
                [~,fname,ext] = fileparts(filename_seg);
                l_filename_seg{rim} = fullfile(dir_analysed,[fname,ext]);

                kfile = 531; % Vesselness (RF-Unet)
                l_filename_vesselness{rim} = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
                [~,fname,ext] = fileparts(l_filename_vesselness{rim});
                l_filename_vesselness{rim} = fullfile(dir_analysed,[fname,ext]); 

                filename_ves = char(h5read( l_filename_vesselness{rim} ,'/fname'));

                [~,rim_new] = fileparts(filename_ves);
                l_ent = list_entities(rim_new,'_');
                rim_new = str2double(l_ent(2,:))+1;
                tab_rim_new(rim) = rim_new;
                l_filename_im_new{rim} = l_filename_im{rim_new}; % corresponding image filename 

            case {'SGL','SGL dark exponential to 230'}
                kfile = 540; % vessels_mask (SFL)
                [filename_seg] = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
                [~,fname,ext] = fileparts(filename_seg);
                l_filename_seg{rim} = fullfile(dir_analysed,[fname,ext]);

                kfile = 541; % Vesselness (SGL)
                [lefic] = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
                [~,fname,ext] = fileparts(lefic);
                l_filename_vesselness{rim} = fullfile(dir_analysed,[fname,ext]); 
        end
    end

    if ismember( list_plot{k_dir} , {'RF-Unet','RF-Unet dark exponential to 230'} )
        [~,ind_sort]=sort(l_filename_im_new');
        l_filename_seg = l_filename_seg(ind_sort)';
        l_filename_vesselness = l_filename_vesselness(ind_sort)';
    end


    [rocObj, tab_TPR_TNR_Acc, tab_AUC] = Eval_results_Drive_with_Matlab_for_1_method( kprob , kpack , l_filename_im , l_filename_seg , ...
        l_filename_vesselness , para_disp );

    tab_results{k_dir,1} = list_plot{k_dir};
    tab_results{k_dir,2} = mean(tab_AUC);
    tab_results{k_dir,3} = rocObj.AUC;
    tab_results{k_dir,4} = mean(tab_TPR_TNR_Acc(:,3));% Accuracy
    tab_results{k_dir,5} = mean(tab_TPR_TNR_Acc(:,1));% Sensitivity
    tab_results{k_dir,6} = mean(tab_TPR_TNR_Acc(:,2));% Specificity
    tab_results{k_dir,7} = mean(tab_TPR_TNR_Acc(:,4));% kappa
    tab_results{k_dir,8} = mean(tab_TPR_TNR_Acc(:,5));% F1
    tab_results{k_dir,9} = mean(tab_TPR_TNR_Acc(:,6));% IoU

    if ismember( list_plot{k_dir} , {'RF-Unet','RF-Unet dark exponential to 230'} )
        l_filename_vesselness(tab_rim_new);
        l_filename_im(tab_rim_new);
        tab_TPR_TNR_Acc(tab_rim_new,:);
        bsxfun(@times, cumsum(tab_TPR_TNR_Acc(tab_rim_new,:)) , (1./(1:nim))' );
    end

    if para_disp.flag_display
        figure(fig_ROC); hold on
        plot( rocObj.Metrics.FalsePositiveRate , rocObj.Metrics.TruePositiveRate , '-' ,'DisplayName',sprintf('%s mean AUC = %.04f',list_plot{k_dir},mean(tab_AUC)));
        legend('show','Location','east');
        title('Full set ROC curves');
    end
end

if para_disp.flag_display
    figure(fig_ROC);
    legend('show');
end

%% Saving the results
tab_results = cell2table(tab_results,"VariableNames",["Method","AUC","FullSetAUC","Acc","Se","Spe","Kappa","F1","IoU"]);

if flag_write_res
    fname_out = "Table_comparison_methods.xlsx";
    writetable(tab_results,fname_out);
    fprintf('<----------------- Writing %s\n',fname_out);
end

%% Path management
path(oldpath);
pause(0.1); 
