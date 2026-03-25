%Script_signal_LIPoperators.m
% Guillaume NOYEL
% 29/01/2021

close all; clearvars;

oldpath = addpath('Function_sources');

flag_display = true;
flag_write_res = true;%true; % to write the results

%% Flags for the different parts to be run


flag(1) = true; % signal 2

%% Paths

[cur_dir,racine_filename] = fileparts(mfilename('fullpath'));
out_dir = fullfile(cur_dir,'Res'); % output directory
ajout_dossier_depuis_nom_dossier(out_dir);


%% Colours

s = graphic_colours();
graphicR = s.graphicR;
graphicG = s.graphicG;
graphicB = s.graphicB;
graphicDrBr = s.graphicDrBr;
graphicMdBr = s.graphicMdBr;
graphicLBr =  s.graphicLBr;
graphicOrange = s.graphicOrange;
graphicPink = s.graphicPink;

% LIP characters

LP = ['\mbox{',sprintf('\x2A39'),'}'];
%LP = sprintf('\x2A39');

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
lw =  1.5;         % LineWidth
Linewidth_val_probe = lw;
msz = 8;       % MarkerSize
MarkerSize_val_probe = msz-2;

FontName_val = 'Times New Roman';
factor_smaller_fonts = 0.7;
LabelFontSizeMultiplier_val = 1/factor_smaller_fonts;

% The properties we've been using in the figures
set(0,'defaultLineLineWidth',lw);   % set the default line width to lw
set(0,'defaultLineMarkerSize',msz); % set the default line marker size to msz
set(0,'defaultLineLineWidth',lw);   % set the default line width to lw
set(0,'defaultLineMarkerSize',msz); % set the default line marker size to msz

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
%       Test 2 : signal 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag(1)

    
    %% Building a test signal
    
    vect_pattern = 0:50;
    
    a = 0.1;
    s_test_pattern = a*vect_pattern;
    s_test_pattern = [s_test_pattern , s_test_pattern(end-1)-a*vect_pattern(1:end-1)];
    sz_pad = floor(length(vect_pattern)/3);
    s_test_pattern = [s_test_pattern , -s_test_pattern(2:end)];
    
    vect_t = 0:(length(s_test_pattern)-1);
    if flag_display
        figure;
        plot(vect_t,s_test_pattern);
        title('pattern')
    end
    
    %% Creation of the input signal
    
    
    fact_mult = 10;
    
    s_test_ini = fact_mult* s_test_pattern;
    val_step = -min(s_test_ini(:));
    s_test_ini = val_step + s_test_ini;
    
    s_test_ini = padarray(s_test_ini,[0 sz_pad],val_step);
   
    c_min = min(s_test_ini);%0;
    c_max = M-1-max(s_test_ini);%220;
    
    s_test = cat(2, s_test_ini+c_min , s_test_ini+c_max );

    
    if flag_display
        fig_1 = figure(); hold on
        %subplot(2,2,1);
        plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz);
        xlim([1 length(s_test)]); %ylim([4, max(s_test(:))]);
        xlabel('\it x');  ylabel('\it Grey levels');
        title('Input signal')
        gca_fig_1 = gca_fig(fig_1);
        gca_fig_1.FontSize = fsz;
        gca_fig_1.FontName = 'Times New Roman';
    end
    
    %% Structuring element
    
    lgt_probe = length(vect_pattern);
    msk_probe = true(1,lgt_probe);
    vect_t_probe = 0:(lgt_probe-1);

    % Circle
    vect_t_probe_pattern = 0:(floor(lgt_probe/2));
    s_probe_pattern = sqrt((length(vect_t_probe_pattern)-1)^2 - vect_t_probe_pattern.^2);
    s_probe = [s_probe_pattern(end:-1:2),s_probe_pattern];
    
    SE = strel('arbitrary',msk_probe,s_probe);

    
    if flag_display
        fig_2 = figure();
        plot(SE.getheight(),'-','Color',graphicR,'LineWidth',lw,'MarkerSize',msz);
        title('Probe')
        xlabel('\it x');  %ylabel('\it Grey levels');
        FIG_ajuste_xylim_plusieurs_fig( [fig_1,fig_2] );
        gca_fig_2 = gca_fig(fig_2);
        gca_fig_2.FontSize = fsz;
        gca_fig_2.FontName = 'Times New Roman';
    end
    
    %% Morpho Math
    
    
    %%  Erosion
    
    s_test_ero = imerode( s_test , SE );
    s_test_LIP_ero = LIP_imerode( s_test , SE , M );

    
    if flag_display
        
        fig_3 = figure();hold on;%figure(fig_1);
        hp1 = plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz);
        hp2 = plot(s_test_ero,'-.','Color',graphicR,'LineWidth',lw,'MarkerSize',msz);
        hp3 = plot(s_test_LIP_ero,'-','Color',graphicMdBr,'LineWidth',lw,'MarkerSize',msz);
        plot([1 length(s_test)] , [M-1 M-1] , '-','Color',graphicB,'LineWidth',1,'MarkerSize',msz);
        xlim([1 length(s_test)]); ylim([-30 280]);
        
        %title('Erosion')
        xlabel('\it x'); %ylabel('\it Values');
        xticks([]);
        gca_fig_3 = gca_fig(fig_3);
        gca_fig_3.FontSize = fsz;
        gca_fig_3.FontName = 'Times New Roman';
    end
    
    % Positionnning the probes at peak locations
    h = 10;
    [ ~ , IdxList_max ] = SGN_maxima( s_test , h ); % extraction of the locations of the peaks
    [ ~ , IdxList_min ] = SGN_minima( s_test , h ); % extraction of the locations of the peaks
    
    IdxList_peak = cat(1,IdxList_max{1:2});
    
    half_lgt_probe = floor(lgt_probe/2);
    max_s_probe = max(s_probe);
    
    for k = 1:length(IdxList_peak)
        %idx_peak            = IdxList_max{k};
        idx_peak            = IdxList_peak(k);
        idx_ini_pr          = idx_peak-half_lgt_probe; %starting idx of the probe when located at a peak
        idx_end_pr          = idx_peak+half_lgt_probe; %ending   idx of the probe when located at a peak
        vect_t_probe_peak   = idx_ini_pr:idx_end_pr;
        vect_t_probe_peak   = vect_t_probe_peak + (idx_end_pr-idx_ini_pr) + 20;
        ero_peak            = s_test_ero(idx_peak);
        s_probe_ero_peak     = ero_peak - s_probe + max_s_probe;
        dyn_probe_ero_peak   = max(s_probe_ero_peak(:)) - min(s_probe_ero_peak(:));
        ero_LIP_peak        = s_test_LIP_ero(idx_peak);
        s_probe_ero_LIP_peak    = LIP_imadd( LIP_imsubtract( ero_LIP_peak, s_probe , M) ,max_s_probe ,M );
        dyn_probe_ero_LIP_peak   = max(s_probe_ero_LIP_peak(:)) - min(s_probe_ero_LIP_peak(:)); 
        disp('Dynamic of the upper probe');disp(dyn_probe_ero_peak);
        disp('Dynamic of the lower probe');disp(dyn_probe_ero_LIP_peak);
        
        
        if flag_display
            figure(fig_3); hold on
            hp4 = plot(vect_t_probe_peak,s_probe_ero_peak,'-.' ,'Color',graphicPink,'LineWidth',Linewidth_val_probe,'MarkerSize',MarkerSize_val_probe);
            hp5 = plot(vect_t_probe_peak,s_probe_ero_LIP_peak,'-','Color',graphicOrange,'LineWidth',Linewidth_val_probe,'MarkerSize',MarkerSize_val_probe);
            legend([hp1 hp2 hp3 hp4 hp5],'$f$','$\varepsilon_b(f)$',['$\varepsilon_b^{','+','}(f)$'],'$b+f(x_i)$',['$b ','+',' f(x_i)$'],...
                'Location','southeast','Interpreter','latex','FontSize',fsz_leg);%,'Box',
            legend('boxoff');
            xticks(IdxList_peak)
            xticklabels({})
            %xticklabels({'\it x_1','\it x_2'})%,'Interpreter','latex','FontSize',fsz_leg)
            
            FIG_ajuste_xylim_plusieurs_fig( [fig_1,fig_2] );
            gca_fig_1 = gca_fig(fig_1);
            gca_fig_1.FontSize = fsz;
            gca_fig_1.FontName = 'Times New Roman';
        end
    end
    

    if flag_write_res
       fname = fullfile(out_dir,'LIP-erosion_signal.fig');
       saveas( fig_3, fname );
       fname = fullfile(out_dir,'LIP-erosion_signal.svg');
       saveas( fig_3, fname );
    end
    
    
    %%  Dilation
    
    s_test_dil = imdilate( s_test , SE );
    s_test_LIP_dil = LIP_imdilate( s_test , SE , M );
    
    if flag_display
        fig_4   = figure();hold on;%figure(fig_1);
        hp1     = plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz);
        hp2     = plot(s_test_dil,'-.','Color',graphicR,'LineWidth',lw,'MarkerSize',msz);
        hp3     = plot(s_test_LIP_dil,'-','Color',graphicMdBr,'LineWidth',lw,'MarkerSize',msz);
        plot([1 length(s_test)] , [M-1 M-1] , '-','Color',graphicB,'LineWidth',1,'MarkerSize',msz);
        xlim([1 length(s_test)]); ylim([-30 280]);
        
        %title('Dilation')
        xlabel('\it x'); %ylabel('\it Values');
        xticks([]);
        gca_fig_3 = gca_fig(fig_4);
        gca_fig_3.FontSize = fsz;
        gca_fig_3.FontName = 'Times New Roman';
    end
    
    % Positionnning the probes at peak locations
    [ ~ , IdxList_max ] = SGN_maxima( s_test ); % extraction of the locations of the peaks
    
    half_lgt_probe = floor(lgt_probe/2);
    
    l_Linewidth_val_probe = [Linewidth_val_probe, 3];
    for k = 1:2
        idx_peak                = IdxList_max{k};
        idx_ini_pr              = idx_peak-half_lgt_probe; %starting idx of the probe when located at a peak
        idx_end_pr              = idx_peak+half_lgt_probe; %ending   idx of the probe when located at a peak
        vect_t_probe_peak       = idx_ini_pr:idx_end_pr;
        vect_t_probe_peak       = vect_t_probe_peak + (idx_end_pr-idx_ini_pr) + 20;
        s_test_peak             = s_test(idx_peak);
        s_probe_dil_peak        = s_test_peak+s_probe;
        dyn_probe_dil_peak      = max(s_probe_dil_peak(:)) - min(s_probe_dil_peak(:));
        %dil_LIP_peak            = s_test_LIP_dil(idx_peak);
        s_probe_dil_LIP_peak    = LIP_imadd(s_test_peak,s_probe,M);
        dyn_probe_dil_LIP_peak  = max(s_probe_dil_LIP_peak(:)) - min(s_probe_dil_LIP_peak(:)); 
        disp('Dynamic of the upper probe');disp(dyn_probe_dil_peak);
        disp('Dynamic of the lower probe');disp(dyn_probe_dil_LIP_peak);
        
        if flag_display
            figure(fig_4); hold on
            hp4 = plot(vect_t_probe_peak,s_probe_dil_peak,'-.' ,'Color',graphicPink,'LineWidth',Linewidth_val_probe,'MarkerSize',MarkerSize_val_probe);
            hp5 = plot(vect_t_probe_peak,s_probe_dil_LIP_peak,'-','Color',graphicOrange,'LineWidth',Linewidth_val_probe,'MarkerSize',MarkerSize_val_probe);
            legend([hp1 hp2 hp3 hp4 hp5],'\it $f$','\it $\delta_b(f)$',['$\delta_b^{','+','}(f)$'],'$b+f(x_i)$',['$b ','+',' f(x_i)$'],...
                'Location','southeast','Interpreter','latex','FontSize',fsz_leg);
            legend('boxoff');
            xticks(IdxList_peak)
            xticklabels({})
            %xticklabels({'\it x_1','\it x_2'})%,'Interpreter','latex','FontSize',fsz_leg)
            
            FIG_ajuste_xylim_plusieurs_fig( [fig_1,fig_2] );
            gca_fig_1 = gca_fig(fig_1);
            gca_fig_1.FontSize = fsz;
            gca_fig_1.FontName = 'Times New Roman';
        end
    end
    
    if flag_write_res
       fname = fullfile(out_dir,'LIP-dilation_signal.fig');
       saveas( fig_4, fname );
       fname = fullfile(out_dir,'LIP-dilation_signal.svg');
       saveas( fig_4, fname );
    end    

    %%  Opening
    
    s_test_open = imopen( s_test , SE );
    s_test_LIP_open = LIP_imopen( s_test , SE , M );
    
    if flag_display
        
        fig_5 = figure();hold on;%figure(fig_1);
        hp1 = plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz);
        hp2 = plot(s_test_open,'-.','Color',graphicR,'LineWidth',lw,'MarkerSize',msz);
        hp3 = plot(s_test_LIP_open,'-','Color',graphicMdBr,'LineWidth',lw,'MarkerSize',msz);
        plot([1 length(s_test)] , [M-1 M-1] , '-','Color',graphicB,'LineWidth',1,'MarkerSize',msz);
        xlim([1 length(s_test)]); ylim([-30 280]);
        legend([hp1 hp2 hp3],'\it $f$','\it $\gamma_b(f)$','\it $\gamma_b^{+}(f)$',...
            'Location','southeast','Interpreter','latex','FontSize',fsz_leg);
        legend('boxoff');
        
        %title('Opening')
        xlabel('\it x'); %ylabel('\it Values');
        xticks([]);
        gca_fig_3 = gca_fig(fig_5);
        gca_fig_3.FontSize = fsz;
        gca_fig_3.FontName = 'Times New Roman';
    end
    
    if flag_write_res
       fname = fullfile(out_dir,'LIP-opening_signal.fig');
       saveas( fig_5, fname );
       fname = fullfile(out_dir,'LIP-opening_signal.svg');
       saveas( fig_5, fname );
    end      
    
    %%  Closing
    
    s_test_close = imclose( s_test , SE );
    s_test_LIP_close = LIP_imclose( s_test , SE , M );
    
    if flag_display
        
        fig_6 = figure();hold on;%figure(fig_1);
        hp1 = plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz);
        hp2 = plot(s_test_close,'-.','Color',graphicR,'LineWidth',lw,'MarkerSize',msz);
        hp3 = plot(s_test_LIP_close,'-','Color',graphicMdBr,'LineWidth',lw,'MarkerSize',msz);
        plot([1 length(s_test)] , [M-1 M-1] , '-','Color',graphicB,'LineWidth',1,'MarkerSize',msz);
        xlim([1 length(s_test)]); ylim([-30 280]);
        legend([hp1 hp2 hp3],'\it $f$','\it $\varphi_b(f)$','\it $\varphi_b^{+}(f)$',...
            'Location','southeast','Interpreter','latex','FontSize',fsz_leg);
        legend('boxoff');
        
        %title('Closing')
        xlabel('\it x'); %ylabel('\it Values');
        xticks([]);
        gca_fig_3 = gca_fig(fig_6);
        gca_fig_3.FontSize = fsz;
        gca_fig_3.FontName = 'Times New Roman';
    end  
    
    if flag_write_res
       fname = fullfile(out_dir,'LIP-closing_signal.fig');
       saveas( fig_6, fname );
       fname = fullfile(out_dir,'LIP-closing_signal.svg');
       saveas( fig_6, fname );
    end
    
    
end

%% Path management
path(oldpath);
pause(0.1); 
