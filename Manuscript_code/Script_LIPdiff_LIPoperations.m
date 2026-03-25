%Script_LIPdiff_LIPoperations.m
% Guillaume NOYEL
% 22/09/2021

close all; clearvars;


oldpath = addpath('Function_sources');


flag_display = true;
flag_write_res = true;%true; % to write the results

%% Flags for the different parts to be run


flag(1) = true;%true;%false; % signal 2 - strel as a bump


%% Paths

[cur_dir,racine_filename] = fileparts(mfilename('fullpath'));
out_dir = fullfile(cur_dir,'Res','L-Differo'); % output directory
ajout_dossier_depuis_nom_dossier(out_dir);


%% Colours

s = graphic_colours();
graphicR = s.graphicR;
graphicG = s.graphicG;
graphicB = s.graphicB;
graphicDrBr = s.graphicDrBr;
graphicMdBr = s.graphicMdBr;
graphicLBr =  s.graphicLBr;

%% Figure properties

%% Display parameters
% fsz = 34;
% lw = 5;
% Linewidth_val_probe = 4;


% 	Default	Paper	Presentation
% Width         5.6	varies	varies
% Height        4.2	varies	varies
% AxesLineWidth	0.5	0.75	1
% FontSize      10	8       14
% LineWidth     0.5	1.5     2
% MarkerSize	6	8       12

% Choose parameters (line width, font size, picture size, etc.)
width = 5;     % Width in cm
height = 4;    % Height in cm

alw = 1;    % AxesLineWidth
fsz = 18;      % Fontsize
fsz_leg = fsz;%fsz+6;      % Fontsize
lw =  3;         % LineWidth
Linewidth_val_probe = lw;
msz = 8;       % MarkerSize
MarkerSize_val_probe = msz-2;

FontName_val = 'Times New Roman';
factor_smaller_fonts = 0.7;
LabelFontSizeMultiplier_val = 1/factor_smaller_fonts;

% The properties we've been using in the figures
set(0,'defaultLineLineWidth',lw);   % set the default line width to lw
set(0,'defaultLineMarkerSize',msz); % set the default line marker size to msz
% set(0,'defaultLineLineWidth',lw);   % set the default line width to lw
% set(0,'defaultLineMarkerSize',msz); % set the default line marker size to msz

% Set the default Size for display
defpos = get(0,'defaultFigurePosition');
set(0,'defaultFigurePosition', [defpos(1) defpos(2) width*100, height*100]);

% Set the defaults for saving/printing to a file
set(0,'defaultFigureInvertHardcopy','on'); % This is the default anyway
set(0,'defaultFigurePaperUnits','centimeters'); % This is the default anyway
defsize = get(gcf, 'PaperSize');
left = (defsize(1)- width)/2;
bottom = (defsize(2)- height)/2;
defsize = [left, bottom, width, height];
set(0, 'defaultFigurePaperPosition', defsize);

set(0,'defaultAxesFontName',FontName_val);
% setappdata(gca, 'DefaultAxesXLabelFontSize', fsz)
% setappdata(gca, 'DefaultAxesTitleFontFontSize', fsz)
% setappdata(gca, 'DefaultLegendFontSize', fsz)

close(gcf);

%% LIP model
M =  256;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Test 1 : signal 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag(1)

    
    %% Building a test signal
    
    vect_pattern = 0:50;
    sz_pad = floor(length(vect_pattern)/0.5);
    
    vect_pattern2 = 0:(4*vect_pattern(end));
    a = 5;
    Te =vect_pattern2(end);
    nbT = 1;
    f = 1/nbT;
    s_test_pattern = a*sin(2*pi*f/Te*vect_pattern2);
    
    vect_t = 0:(length(s_test_pattern)-1);
    if flag_display
        figure;
        plot(vect_t,s_test_pattern);
        title('pattern')
    end
    
    %% Creation of the input signal
    
    
    %s_test = 5 + cos(2*pi*f1*vect_t) + 1/2*sin(2*pi*f2*vect_t) ;
    fact_mult = 10;
    
    s_test_ini = fact_mult* s_test_pattern;
    val_step = -min(s_test_ini(:));
    s_test_ini = val_step + s_test_ini;
    
    s_test_ini_low = padarray(s_test_ini,[0 sz_pad],val_step,'pre');
    s_test_ini_hig = padarray(s_test_ini,[0 sz_pad],val_step,'post');
    
    c_min = min(s_test_ini_low);%0;
    c_max = M-1-max(s_test_ini_hig);%220;
    
    s_test = cat(2, LIP_imadd(s_test_ini_low,c_min,M) , LIP_imadd(s_test_ini_hig,c_max,M) );
    L = length(s_test); % length of the signal
    

    
    if flag_display
        fig_1 = figure(); hold on
        %subplot(2,2,1);
        plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz,'DisplayName','\it $f$');
        xlim([1 L]); %ylim([4, max(s_test(:))]);
        %xlabel('\it x');  ylabel('\it Grey levels');
        
        %title('Input signal')
        gca_fig_1 = gca_fig(fig_1);
        gca_fig_1.FontSize = fsz;
        gca_fig_1.FontName = 'Times New Roman';
    end
    
    %% Structuring element
    

    lgt_half_probe = round(length(vect_pattern2)/4);

    
    %% Ring and gaussian
    r_int = round(lgt_half_probe-5/100*lgt_half_probe); % internal radius
    r_ext = r_int;    

    sigma_pix = r_int/3-5;
    r_peak = sigma_pix;

    %r_int_RP = r_peak+3;

    h_ring = fact_mult*a;
    h_peak = 2 * h_ring+10;
    h_bot = h_ring;
    h_back = -Inf;
    delta_h_centre = h_peak-h_bot;
    %[se_RP, msk_peak, se_R] = strel_Ring_Peak( r_peak , r_ext , r_int_RP , h_peak , h_ring , h_back);
    [ se_RP, msk_peak, se_R ] = strel_Ring_Gaussian( sigma_pix , r_ext, r_int , delta_h_centre , h_ring, h_bot , h_back );
    
    % 1-dimensional strel
    [c_ij] = get_strel_centre(se_RP);
    msk_probe_se_RP = se_RP.Neighborhood(c_ij(1),:);
    im_probe_se_RP = se_RP.getheight();
    s_probe_se_RP = im_probe_se_RP(c_ij(1),:);
    se_RP = strel('arbitrary',msk_probe_se_RP,s_probe_se_RP);
    se_RP_Lneg = LIP_strel_imneg( se_RP , M );
    
    % length of the probe
    lgt_probe = length(msk_probe_se_RP);
    
    % Ring strel
    msk_probe_se_R = se_R.Neighborhood(c_ij(1),:);
    im_probe_se_R = se_R.getheight();
    s_probe_se_R = im_probe_se_R(c_ij(1),:);
    se_R = strel('arbitrary',msk_probe_se_R,s_probe_se_R);
    se_R_Lneg = LIP_strel_imneg( se_R , M );
    
    % Left ring segments
    msk_probe_se_R_l = bwselect( msk_probe_se_R , 1 , 1 );
    se_R_l = strel('arbitrary',msk_probe_se_R_l,s_probe_se_R);
    
    % left ring central peak
    msk_probe_se_RP_l_c = bwselect( msk_probe_se_RP , [1 c_ij(2)] , [1 1] ); 
    se_RP_l_c = strel('arbitrary',msk_probe_se_RP_l_c,s_probe_se_R); 
    
    % right ring central peak
    msk_probe_se_RP_r_c = bwselect( msk_probe_se_RP , [c_ij(2) lgt_probe] , [1 1] ); 
    se_RP_r_c = strel('arbitrary',msk_probe_se_RP_r_c,s_probe_se_R); 
    
    % Right ring segments
    msk_probe_se_R_r = bwselect( msk_probe_se_R , lgt_probe , 1 );
    se_R_r = strel('arbitrary',msk_probe_se_R_r,s_probe_se_R);
    
    
    
    if flag_display
        fig_2 = figure();%figure(fig_1);
        %subplot(2,2,2);hold on;
        plot(se_RP.getheight(),'-','Color',graphicR,'LineWidth',lw,'MarkerSize',msz);hold on
        plot(se_RP_Lneg.reflect.getheight(),'--','Color',graphicR,'LineWidth',lw,'MarkerSize',msz);
        
        plot(se_R.getheight(),'-','Color',graphicB,'LineWidth',lw,'MarkerSize',msz);hold on
        plot(se_R_Lneg.reflect.getheight(),'--','Color',graphicB,'LineWidth',lw,'MarkerSize',msz);
        title('Probe and LIP-negative probe')
        %xlim([1 lgt_probe]);
        %xlabel('\it x');  %ylabel('\it Grey levels');
        xticks([]);
        FIG_ajuste_xylim_plusieurs_fig( [fig_1,fig_2] );
        gca_fig_2 = gca_fig(fig_2);
        gca_fig_2.FontSize = fsz;
        gca_fig_2.FontName = 'Times New Roman';
        
%         figure(fig_1); hold on
%         plot(L-lgt_probe+1:L,s_probe_se_RP,'-','Color',graphicR,'LineWidth',lw,'MarkerSize',msz);
%         plot(L-lgt_probe+1:L,s_probe_se_R,'-','Color',graphicB,'LineWidth',lw,'MarkerSize',msz);
    end
    
    
    % Positionnning the probe at the peak locations
    s_test_LIP_ero_RP = LIP_imerode( s_test , se_RP , M );
    h = 10;
    [ ~ , IdxList_max ] = SGN_maxima( s_test , h ); % extraction of the locations of the peaks
    %[ ~ , IdxList_min ] = SGN_minima( s_test , h ); % extraction of the locations of the peaks
    
    IdxList_peak = cat(1,IdxList_max{1:2});
    
    half_lgt_probe = floor(lgt_probe/2);
    max_s_probe = max(s_probe_se_RP);

    for k = 1:length(IdxList_peak)
        idx_peak            = IdxList_max{k};
        idx_ini_pr          = idx_peak-half_lgt_probe; %starting idx of the probe when located at a peak
        idx_end_pr          = idx_peak+half_lgt_probe; %ending   idx of the probe when located at a peak
        vect_t_probe_peak   = idx_ini_pr:idx_end_pr;
        %vect_t_probe_peak   = vect_t_probe_peak + (idx_end_pr-idx_ini_pr) + 20;
        ero_LIP_peak        = s_test_LIP_ero_RP(idx_peak);
        s_probe_ero_LIP_peak    = LIP_imadd( s_probe_se_RP , ero_LIP_peak, M);
        
        if flag_display
            %if k > 1; delete(hp_prev); end
            figure(fig_1); hold on
            hp_prev = plot(vect_t_probe_peak,s_probe_ero_LIP_peak,'-','Color',graphicR,'LineWidth',Linewidth_val_probe,'MarkerSize',MarkerSize_val_probe,'DisplayName','\it $b$');
            plot(vect_t_probe_peak(1),s_probe_ero_LIP_peak(1),'.','Color',graphicR,'LineWidth',Linewidth_val_probe,'MarkerSize',20,'DisplayName','\it $b$');
            plot(vect_t_probe_peak(end),s_probe_ero_LIP_peak(end),'.','Color',graphicR,'LineWidth',Linewidth_val_probe,'MarkerSize',20,'DisplayName','\it $b$');
            %legend('boxoff');
        end
    end
    
    if flag_display
        figure(fig_1); 
        %legend('Location','southeast','Interpreter','latex','FontSize',fsz_leg);
        %FIG_ajuste_xylim_plusieurs_fig( [fig_1,fig_2] );
        
        ylim([-30 280]);
        gca_fig_1 = gca_fig(fig_1);
        gca_fig_1.FontSize = fsz;
        gca_fig_1.FontName = 'Times New Roman';
        xticks([]);
    end
    
   if flag_write_res
       fname = fullfile(out_dir,'LIP_Diff_Lero_signal_and_2_probes.fig');
       ajout_dossier(fname);
       saveas( fig_1 , fname );
       fname = fullfile(out_dir,'LIP_Diff_Lero_signal_and_2_probes.svg');
       saveas( fig_1 , fname );    
    end    
    
    %% zoom for the peak and a transition
    ylim_zoom = [-20 130];
    IdxList_points = [IdxList_peak(1), IdxList_peak(1)+40];
    
    l_fig_peak = NaN(1,length(IdxList_points));
    for k = 1:length(IdxList_points)
        %idx_peak            = IdxList_max{k};
        idx_peak            = IdxList_points(k);
        idx_ini_pr          = idx_peak-half_lgt_probe; %starting idx of the probe when located at a peak
        idx_end_pr          = idx_peak+half_lgt_probe; %ending   idx of the probe when located at a peak
        vect_t_probe_peak   = idx_ini_pr:idx_end_pr;
        %vect_t_probe_peak   = vect_t_probe_peak + (idx_end_pr-idx_ini_pr) + 20;
        ero_LIP_peak        = s_test_LIP_ero_RP(idx_peak);
        s_probe_ero_LIP_peak    = LIP_imadd( s_probe_se_RP , ero_LIP_peak, M);
        
        if flag_display
            
            l_fig_peak(k) = figure(); hold on;
            plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz,'DisplayName','\it $f$');
            plot(vect_t_probe_peak,s_probe_ero_LIP_peak,'-','Color',graphicR,'LineWidth',Linewidth_val_probe,'MarkerSize',MarkerSize_val_probe,'DisplayName','\it $b$');
            plot(vect_t_probe_peak(1),s_probe_ero_LIP_peak(1),'.','Color',graphicR,'LineWidth',Linewidth_val_probe,'MarkerSize',20,'DisplayName','\it $b$');
            plot(vect_t_probe_peak(end),s_probe_ero_LIP_peak(end),'.','Color',graphicR,'LineWidth',Linewidth_val_probe,'MarkerSize',20,'DisplayName','\it $b$');
            plot(vect_t_probe_peak(1),s_test(vect_t_probe_peak(1)),'x','Color',graphicDrBr,'LineWidth',Linewidth_val_probe,'MarkerSize',20,'DisplayName','\it $b$');
            plot(vect_t_probe_peak(end),s_test(vect_t_probe_peak(end)),'x','Color',graphicDrBr,'LineWidth',Linewidth_val_probe,'MarkerSize',20,'DisplayName','\it $b$');
            xlim([100 250]); ylim(ylim_zoom);
            xticks([]);
            gca_fig_k = gca_fig(l_fig_peak(k));
            gca_fig_k.FontSize = fsz;
            gca_fig_k.FontName = 'Times New Roman';
        end
    end
    
   if flag_write_res
       fname = fullfile(out_dir,'LIP_Diff_Lero_zoom_bump_signal.fig');
       ajout_dossier(fname);
       saveas( l_fig_peak(1), fname );
       fname = fullfile(out_dir,'LIP_Diff_Lero_zoom_bump_signal.svg');
       saveas( l_fig_peak(1), fname );

       fname = fullfile(out_dir,'LIP_Diff_Lero_zoom_transition_signal.fig');
       saveas( l_fig_peak(2), fname );
       fname = fullfile(out_dir,'LIP_Diff_Lero_zoom_transition_signal.svg');
       saveas( l_fig_peak(2), fname );       
    end
    

    %% Morpho Math
    
    
    %%  Erosion with 3 points
    
    s_test_LIP_ero_RP = LIP_imerode( s_test , se_RP , M );
    s_test_LIP_ero_R = LIP_imerode( s_test , se_R , M );
    
    [im_dist,im_c1 , im_c2] = LIP_imDistAsplundAdd( s_test , se_RP , M );
    b = areImagesEqual( im_c2 , s_test_LIP_ero_RP , 1e-12 );
    
    if b
       disp 'Test succeeded' 
    else
        disp 'Test failed'
    end
    
    if flag_display
        
        fig_3 = figure();hold on;%figure(fig_1);
        hp1 = plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz,'DisplayName','\it $f$');
        hp2 = plot(s_test_LIP_ero_RP,'-','Color',graphicR,'LineWidth',lw,'MarkerSize',msz,'DisplayName','\it $\varepsilon_{b_{RP}}^{+}(f)$');
        hp3 = plot(s_test_LIP_ero_R,'-.','Color',graphicB,'LineWidth',lw,'MarkerSize',msz,'DisplayName','\it $\varepsilon_{b_{R}}^{+}(f)$');
        %hp5 = plot(im_c2,'.','Color',graphicLBr,'LineWidth',lw,'MarkerSize',msz);
        
        
        %plot([1 length(s_test)] , [M-1 M-1] , '-','Color',graphicB,'LineWidth',1,'MarkerSize',msz);
        xlim([1 length(s_test)]); ylim([-200 280]);
        
        title('Erosions')
        legend('Location','southeast','Interpreter','latex','FontSize',fsz_leg);%,'Box',
        
        xlabel('\it x'); %ylabel('\it Values');
        xticks([]);
        gca_fig_3 = gca_fig(fig_3);
        gca_fig_3.FontSize = fsz;
        gca_fig_3.FontName = 'Times New Roman';
    end
    


    %%  Erosion with 2 points
    
    % left detector
    s_test_LIP_ero_R_l = LIP_imerode( s_test , se_R_l , M );
    s_test_LIP_ero_R_r = LIP_imerode( s_test , se_R_r , M );
    
    
    if flag_display
        
        fig_4 = figure(); hold on
        hp1 = plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz,'DisplayName','\it $f$');
        hp2 = plot(s_test_LIP_ero_RP,'-','Color',graphicR,'LineWidth',lw,'MarkerSize',msz,'DisplayName','\it $\varepsilon_{b_{RP}}^{+}(f)$');
        hp3 = plot(s_test_LIP_ero_R_l,'-.','Color',graphicDrBr,'LineWidth',lw,'MarkerSize',msz,'DisplayName','\it $\varepsilon_{b_{R_{l}}}^{+}(f)$');
        hp4 = plot(s_test_LIP_ero_R_r,'-.','Color',graphicB,'LineWidth',lw,'MarkerSize',msz,'DisplayName','\it $\varepsilon_{b_{R_{r}}}^{+}(f)$');
        xlim([1 length(s_test)]); ylim([-200 280]);
        title('Erosions')
        legend('Location','southeast','Interpreter','latex','FontSize',fsz_leg);%,'Box',
        legend('boxoff');
        
        xlabel('\it x'); %ylabel('\it Values');
        xticks([]);
        gca_fig_4 = gca_fig(fig_4);
        gca_fig_4.FontSize = fsz;
        gca_fig_4.FontName = 'Times New Roman';
    end
    
    %%  LIP differences between erosions with 3 points
    
    im_LIP_diff = LIP_imsubtract( s_test_LIP_ero_R , s_test_LIP_ero_RP, M );
    
    if flag_display
        fig_5   = figure();hold on;%figure(fig_1);
        hp1     = plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz);
        hp2     = plot(im_LIP_diff,'-.','Color',graphicR,'LineWidth',lw,'MarkerSize',msz);
        %hp5     = plot(im_c1,'.','Color',graphicLBr,'LineWidth',lw,'MarkerSize',msz);
        
        %plot([1 length(s_test)] , [M-1 M-1] , '-','Color',graphicB,'LineWidth',1,'MarkerSize',msz);
        xlim([1 length(s_test)]); ylim([-30 280]);
        
        legend([hp1 hp2],'\it $f$','\it $\varepsilon_{b_{R}}^{+}(f)$ - $\varepsilon_{b_{RP}}^{+}(f)$',...
                'Location','northwest','Interpreter','latex','FontSize',fsz_leg);
            legend('boxoff');
        
        %title('Dilation')
        xlabel('\it x'); %ylabel('\it Values');
        xticks([]);
        gca_fig_5 = gca_fig(fig_5);
        gca_fig_5.FontSize = fsz;
        gca_fig_5.FontName = 'Times New Roman';
    end
    
    
    %%  LIP differences between erosions with 1 point
    
    im_LIP_diff_l = LIP_imsubtract( s_test_LIP_ero_R_l , s_test_LIP_ero_RP, M );
    im_LIP_diff_r = LIP_imsubtract( s_test_LIP_ero_R_r , s_test_LIP_ero_RP, M );
    im_LIP_diff_lr = max( im_LIP_diff_l , im_LIP_diff_r );
    
    
    if flag_display
        fig_6   = figure();hold on;%figure(fig_1);
        hp1     = plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz);
        hp2     = plot(im_LIP_diff_lr,'-.','Color',graphicB,'LineWidth',lw,'MarkerSize',msz);
        %hp5     = plot(im_c1,'.','Color',graphicLBr,'LineWidth',lw,'MarkerSize',msz);
        
        %plot([1 length(s_test)] , [M-1 M-1] , '-','Color',graphicB,'LineWidth',1,'MarkerSize',msz);
        xlim([1 length(s_test)]); ylim([-30 280]);
        
        %legend([hp1 hp2],'\it $f$','\it $\max( \varepsilon_{b_{R_l}}^{+}(f)$ - $\varepsilon_{b_{RP}}^{+}(f) , \varepsilon_{b_{R_r}}^{+}(f)$ - $\varepsilon_{b_{RP}}^{+}(f) )$',...
        %        'Location','northwest','Interpreter','latex','FontSize',fsz_leg);
        %    legend('boxoff');
        
        %title('Dilation')
        %xlabel('\it x'); %ylabel('\it Values');
        xticks([]);
        gca_fig_6 = gca_fig(fig_6);
        gca_fig_6.FontSize = fsz;
        gca_fig_6.FontName = 'Times New Roman';
    end  
    
   if flag_write_res
       fname = fullfile(out_dir,'LIP_Diff_Lero_detector.fig');
       saveas( fig_6, fname );
       fname = fullfile(out_dir,'LIP_Diff_Lero_detector.svg');
       saveas( fig_6, fname );    
    end    
    
    %% zoom
    if flag_display
        fig_7   = figure();hold on;%figure(fig_1);
        hp1     = plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz);
        %hp2     = plot(im_LIP_diff,'--','Color',graphicMdBr,'LineWidth',lw,'MarkerSize',msz);
        hp3     = plot(im_LIP_diff_lr,'-.','Color',graphicB,'LineWidth',lw,'MarkerSize',msz);
        xlim([100 250]); ylim(ylim_zoom);
        
        xticks([]);
        gca_fig_7 = gca_fig(fig_7);
        gca_fig_7.FontSize = fsz;
        gca_fig_7.FontName = 'Times New Roman';
    end
    
   if flag_write_res
       fname = fullfile(out_dir,'LIP_Diff_Lero_zoom_detector.fig');
       saveas( fig_7, fname );
       fname = fullfile(out_dir,'LIP_Diff_Lero_zoom_detector.svg');
       saveas( fig_7, fname );    
    end
    
  
     
end

%% Path management
path(oldpath);
pause(0.1); 
