
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eval ROC curves in Drive for 1 method
%
% [rocObj , tab_TPR_TNR_Acc, tab_AUC] = Eval_results_Drive_with_Matlab_for_1_method( ...
%                        kprob , kpack , l_filename_im , l_filename_seg , ...
%                        l_filename_vesselness , para_disp )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%   kprob  : problem number data web
%            1  diaretDB database : Finland
%            2  David Owens database
%            3  CLSA database
%            4  (public) E-ophta
%            5  (public) Messidor
%            6  (public) Fire (registration database)
%            7  HCL database
%            8  Kaggle database (public)
%            9  IDRID database (public) - 6 packages
%           10  DRIVE database (public) - 2 packages
%
%   kpack  : number of acquisition package
%            1  first package of images
%            1  second package of images
%            i  i-th package of images
%
%   l_filename_im : list of image filenames
%
%   l_filename_seg : list of the vessel mask filenames
%
%   l_filename_vesselness : list of the vesselness filenames
%
%   para_disp        # (option) display parameters updated
%                         para_disp.para_disp.flag_display : display flag
%                         para_disp.para_disp.flag_detail  : details flag
%                         para_disp.para_disp.tab_fig      : array of figure handle
%                         para_disp.para_disp.cpt_fig      : figure counter
%                         para_disp.cpt_pos      : figure position counter
%                         para_disp.filename_in  : input filename
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% rocObj : ROC object containing
%           rocObj.Metrics.FalsePositiveRate : average false postive rate over the DRIVE database
%           rocObj.Metrics.TruePositiveRate : average true postive rate over the DRIVE database 
%           Thresholds : array of thresholds on classifier scores
%           AUC : Area Under the Curve for the DRIVE database
% tab_TPR_TNR_Acc : Array [nim , 6] of sensitivity, specificity and
%                       Accuracy for each image
%                   TPR  : sensitivity, True Positive Rate (TPR), TPR = TP/(TP+FN);
%                   TNR  : specificity, True Negative Rate (TNR), TNR = TN/(TN+FP);
%                   Acc  : Accuracy : rate of pixels correctly classified Acc = (TP+TN)/(TP+TN+FP+FN);
%                   kappa_coeff : Kappa coefficient
%                   F1   : F1-score
%                   IoU  : Intersection over-union or Jacquard index
% tab_AUC  : array of Area Under ROC Curves
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eval_results_Drive_with_Matlab_for_1_method.m
% Guillaume NOYEL 05-09-2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [rocObj , tab_TPR_TNR_Acc, tab_AUC] = Eval_results_Drive_with_Matlab_for_1_method( ...
                        kprob , kpack , l_filename_im , l_filename_seg , ...
                        l_filename_vesselness , para_disp )

%% Parameters

flag_av_ROC = true; % flag to average the ROC curves
flag_write_res = true;% write results

%% Window locations
pos_windows = FIG_get_pos_figs(); % windows positions
screen_1 = get_screen_size();
screen_0 = get_screen_size(0);

if para_disp.flag_detail % display flag
    fig_comp = figure;
    set(fig_comp,'OuterPosition',screen_1);

    fig_im = figure;
    set(fig_im,'OuterPosition',pos_windows(1,:));

    fig_im_grey = figure; colormap gray
    set(fig_im_grey,'OuterPosition',pos_windows(2,:));
end

%Tvals_ROC = 0:0.01:1;%0:0.0005:1;

nim = length(l_filename_im);
tab_TPR_TNR_Acc  = NaN(nim,6);
tab_AUC = NaN(nim,1);
%tab_AUC_matlab = NaN(nim,1);

%l = length(Tvals_ROC);
tab_ROC_fpr = cell(nim,1);
tab_ROC_tpr = cell(nim,1);
%tab_ROC_fpr_matlab = cell(nim,1);
%tab_ROC_tpr_matlab = cell(nim,1);

tab_ROC_labels = cell(nim,1);
tab_ROC_proba  = cell(nim,1);
l_rocObj = cell(nim,1);
for rim=1:nim
    filename_in = l_filename_im{rim};
    if para_disp.flag_display
        fprintf('Image %d / %d \t %.02f %% \t filename = %s\n', rim , nim , rim/nim*100 , filename_in );
    end

    kfile = 11011; % Mask given with the image database
    [lefic] = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
    im_msk = imread( lefic )>0;
    im_msk(:) = true;

    kfile = 11012; % Manual segmentation 1 (reference segmentation)
    [filename_ref] = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
    msk_ref = imread(filename_ref)>0; % reference segmentation (gold_standard)

    % segmentation (to be compared)

%     kfile = 510; % vessels_mask (LIP-Morpho Math)
%     [filename_seg] = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
%     [~,fname,ext] = fileparts(filename_seg);
%     filename_seg = fullfile(dir_analysed,[fname,ext]);

    msk_seg = imread(l_filename_seg{rim})>0; % segmentation (to be compared)

    [ TPR , TNR , Acc , Ntab , msk_TP , msk_FP , msk_FN , msk_TN ] = SensibilitySpecificity2imseg( msk_ref , msk_seg , im_msk );
    %cp = classperf( msk_ref , msk_seg );
    TP = Ntab(1,1);
    FP = Ntab(1,2);
    FN = Ntab(2,1);
    TN = Ntab(2,2);
    F1 = 2*TP/(2*TP+FP+FN);%F1-score
    IoU = TP/(TP+FP+FN); %Intersection over-union or Jacquard index

    kappa_coeff = kappa_coefficient(Ntab);
    tab_TPR_TNR_Acc(rim,1) = TPR;%cp.Sensitivity;%sensitivity
    tab_TPR_TNR_Acc(rim,2) = TNR;%cp.Specificity;%specificity
    tab_TPR_TNR_Acc(rim,3) = Acc;%accuracy
    tab_TPR_TNR_Acc(rim,4) = kappa_coeff;%kappa_coefficient
    tab_TPR_TNR_Acc(rim,5) = F1;%F1-score
    tab_TPR_TNR_Acc(rim,6) = IoU;%Intersection over-union or Jacquard index

    
    im_ves_comp = im_comparison_segmentations( msk_TP , msk_FP , msk_TN , msk_FN );

    if flag_write_res
        [dir_analysed,fname] = fileparts(l_filename_seg{rim});
        filename_out = fullfile(dir_analysed,[fname,'_comp','.png']);
        imwrite(im_ves_comp,filename_out);
        fprintf("<---------------- Saving :%s\n",filename_out);
    end

    if para_disp.flag_detail
        figure(fig_comp);clf;
        imagesc(im_ves_comp); axis equal
        title('Comparison: white (TN), black (TP), cyan (FP), red (FN)')

    end

    %% ROC curve


    [~,~,ext] = fileparts(l_filename_vesselness{rim});
    switch ext
        case '.mat'
            load( l_filename_vesselness{rim} , 's_ves' );
            map_vessel_detector_proba2 = s_ves.map_vessel_detector_norm;
        case '.h5'
            map_vessel_detector_proba2 = double(squeeze(h5read( l_filename_vesselness{rim} ,'/y_pred_proba'))');
    end

    true_labels = msk_ref(im_msk);% class 0
    score_classif2 = map_vessel_detector_proba2(im_msk)';% proba of class 1
    posclass = true; % positive class

    %[fpr,tpr,Thresholds,AUC_matlab] = perfcurve(true_labels,score_classif2,posclass,'Tvals',Tvals_ROC);
    l_rocObj{rim} = rocmetrics( true_labels , score_classif2 , posclass);
    %tab_AUC_matlab(rim) = rocObj_rim.AUC;
    if flag_av_ROC
        %[ tFPR , tTPR , AUC ] = mapROCcurv( msk_ref(im_msk) , map_vessel_detector_proba2(im_msk) , Tvals_ROC );

        tab_AUC(rim) = l_rocObj{rim}.AUC;
        tab_ROC_fpr{rim} = l_rocObj{rim}.Metrics.FalsePositiveRate;%fpr(:)';%tFPR(:)';
        tab_ROC_tpr{rim} = l_rocObj{rim}.Metrics.TruePositiveRate;%tpr(:)';tTPR(:)';

        % tab_ROC_fpr_matlab{rim} = rocObj.Metrics.FalsePositiveRate;
        % tab_ROC_tpr_matlab{rim} = rocObj.Metrics.TruePositiveRate;
    end

    if para_disp.flag_detail
        fig_proba = figure;
        imagesc(map_vessel_detector_proba2); axis equal; title('Proba of vessel detector')

        fig_ROC_im = figure;
        plot(l_rocObj{rim})
        %plotroc(targets_classif,output_classif);
        %plot(fpr,tpr); xlabel('False positive rate')
        %ylabel('True positive rate')
        title(sprintf('ROC image %d',rim));

        %fprintf('AUC : %.04f\n',tab_AUC(rim));
    end

    if para_disp.flag_detail
        pause(1);
        close(fig_proba,fig_ROC_im);
    end
end

fprintf('Mean sensitivity (TPR) : %.04f\n',mean(tab_TPR_TNR_Acc(:,1)));
fprintf('Mean specificity (TNR) : %.04f\n',mean(tab_TPR_TNR_Acc(:,2)));
fprintf('Mean accuracy : %.04f std (%.04f)\n',mean(tab_TPR_TNR_Acc(:,3)),std(tab_TPR_TNR_Acc(:,3)) );
fprintf('Mean Kappa coefficient = %.04f\n',mean(tab_TPR_TNR_Acc(:,4)));
fprintf('Mean F1-score : %.04f\n',mean(tab_TPR_TNR_Acc(:,5)));
fprintf('Mean IoU : %.04f\n',mean(tab_TPR_TNR_Acc(:,6)));
fprintf('Mean AUC matlab : %.04f\n',mean(tab_AUC));


if flag_av_ROC
    %[fpr_av,tpr_av,Thresholds_av,AUC_av] = perfcurve(cat(1,tab_ROC_labels{:}),cat(2,tab_ROC_proba{:})',true);%posclass,'Tvals',Tvals_ROC);
    tab_labels = [];
    tab_Scores = [];
    for rim=1:nim
        tab_labels = [tab_labels;l_rocObj{rim}.Labels(:)];
        tab_Scores = [tab_Scores;l_rocObj{rim}.Scores(:)];
    end
    rocObj = rocmetrics( tab_labels(:) , tab_Scores(:) , posclass);
    fprintf('Full set AUC : %.04f\n',rocObj.AUC);

    if para_disp.flag_detail
        % figure;
        % plot( mean(tab_ROC_fpr) , mean(tab_ROC_tpr) , '-*' ); hold on
        % plot( mean(tab_ROC_fpr) , mean(tab_ROC_tpr) , '-*' ); hold on
        % %axis equal;   xlim([0 1]);ylim([0 1]);
        % xlabel('False positive Rate (1-specificity)');
        % ylabel('True Positive Rate (sensitivity)');
        % title('Average ROC curve');

        figure;
        %plot( rocObj.Metrics.FalsePositiveRate , rocObj.Metrics.TruePositiveRate , '-*' ); hold on
        plot( rocObj );
        %axis equal;   xlim([0 1]);ylim([0 1]);
        % xlabel('False positive Rate (1-specificity)');
        % ylabel('True Positive Rate (sensitivity)');
        title('Full set ROC curve');
    end
end


end