%Script_interpretation_imDistAspAdd.m
% Guillaume NOYEL
% 04/09/2021

close all; clearvars;

oldpath = addpath('Function_sources');

flag_display = true;
flag_write_res = true;%true; % to write the results


%% Paths

[cur_dir,racine_filename] = fileparts(mfilename('fullpath'));
out_dir = fullfile(cur_dir,'Res'); % output directory


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
%       Program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



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
    plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz);
    xlim([1 L]); %ylim([4, max(s_test(:))]);
    %xlabel('\it x');  ylabel('\it Grey levels');
    xticks([]);
    %title('Input signal')
    gca_fig_1 = gca_fig(fig_1);
    gca_fig_1.FontSize = fsz;
    gca_fig_1.FontName = 'Times New Roman';
end

%% Structuring element

%lgt_half_probe = length(vect_pattern);
%lgt_half_probe = round(length(vect_pattern)/2);
lgt_half_probe = round(length(vect_pattern)/1.5);



% Circle
%vect_t_probe_pattern = 0:(floor(lgt_probe/2));
vect_t_probe_pattern = -lgt_half_probe:lgt_half_probe;
s_probe = sqrt(lgt_half_probe^2 - vect_t_probe_pattern.^2);

lgt_probe = length(vect_t_probe_pattern);
msk_probe = true(1,lgt_probe);

SE = strel('arbitrary',msk_probe,s_probe);
SE_Lneg = LIP_strel_imneg( SE , M );



if flag_display
    fig_2 = figure();%figure(fig_1);
    %subplot(2,2,2);hold on;
    plot(SE.getheight(),'-','Color',graphicR,'LineWidth',lw,'MarkerSize',msz);hold on
    plot(SE_Lneg.reflect.getheight(),'--','Color',graphicR,'LineWidth',lw,'MarkerSize',msz);
    title('Probe and LIP-negative probe')
    %xlim([1 lgt_probe]);
    %xlabel('\it x');  %ylabel('\it Grey levels');
    xticks([]);
    FIG_ajuste_xylim_plusieurs_fig( [fig_1,fig_2] );
    gca_fig_2 = gca_fig(fig_2);
    gca_fig_2.FontSize = fsz;
    gca_fig_2.FontName = 'Times New Roman';

    figure(fig_1); hold on
    plot(L-lgt_probe+1:L,s_probe,'-','Color',graphicR,'LineWidth',lw,'MarkerSize',msz);
end

%% Flat structuring element
SE_flat = strel('arbitrary',msk_probe);

%% Morpho Math


%%  Erosion

s_test_ero = imerode( s_test , SE );
s_test_ero_flat = imerode( s_test , SE_flat );
s_test_LIP_ero = LIP_imerode( s_test , SE , M );

[imdistAsp , im_c1 , im_c2] = LIP_imDistAsplundAdd( s_test , SE , M );
areImagesEqual( s_test_LIP_ero , im_c2 , 1e-12 )


if flag_display

    fig_3 = figure();hold on;%figure(fig_1);
    hp1 = plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz);
    hp2 = plot(s_test_ero,'-.','Color',graphicR,'LineWidth',lw,'MarkerSize',msz);
    hp3 = plot(s_test_LIP_ero,'-','Color',graphicMdBr,'LineWidth',lw,'MarkerSize',msz);
    hp4 = plot(s_test_ero_flat,'-.','Color',graphicB,'LineWidth',lw,'MarkerSize',msz);
    %hp5 = plot(im_c2,'.','Color',graphicLBr,'LineWidth',lw,'MarkerSize',msz);


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
        plot(vect_t_probe_peak,s_probe_ero_peak,'-.' ,'Color',graphicR,'LineWidth',Linewidth_val_probe,'MarkerSize',MarkerSize_val_probe);
        plot(vect_t_probe_peak,s_probe_ero_LIP_peak,'-','Color',graphicMdBr,'LineWidth',Linewidth_val_probe,'MarkerSize',MarkerSize_val_probe);
        legend([hp1 hp2 hp3 hp4],'\it $f$','\it $\varepsilon_b(f)$','\it $\varepsilon_b^{+}(f)$','\it $\varepsilon_B(f)$',...
            'Location','southeast','Interpreter','latex','FontSize',fsz_leg);%,'Box',
        legend('boxoff');

        FIG_ajuste_xylim_plusieurs_fig( [fig_1,fig_2] );
        gca_fig_1 = gca_fig(fig_1);
        gca_fig_1.FontSize = fsz;
        gca_fig_1.FontName = 'Times New Roman';
    end
end



%%  Dilation
SE_neg = strel( 'arbitrary' , SE.getnhood , -SE.getheight );

s_test_dil = imdilate( s_test , SE_neg.reflect() );
s_test_dil_flat = imdilate( s_test , SE_flat.reflect() );
s_test_LIP_dil = LIP_imdilate( s_test , SE_Lneg.reflect() , M );

areImagesEqual( s_test_LIP_dil , im_c1 , 1e-12 )

if flag_display
    fig_4   = figure();hold on;%figure(fig_1);
    hp1     = plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz);
    hp2     = plot(s_test_dil,'-.','Color',graphicR,'LineWidth',lw,'MarkerSize',msz);
    hp3     = plot(s_test_LIP_dil,'-','Color',graphicMdBr,'LineWidth',lw,'MarkerSize',msz);
    hp4     = plot(s_test_dil_flat,'-.','Color',graphicB,'LineWidth',lw,'MarkerSize',msz);
    %hp5     = plot(im_c1,'.','Color',graphicLBr,'LineWidth',lw,'MarkerSize',msz);

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
        %subplot(2,2,1);
        %plot(vect_t(idx_peak),s_test(idx_peak),'+','Color',graphicMdBr,'LineWidth',lw,'MarkerSize',msz);
        plot(vect_t_probe_peak,s_probe_dil_peak,'-.' ,'Color',graphicR,'LineWidth',Linewidth_val_probe,'MarkerSize',MarkerSize_val_probe);
        %plot([vect_t_probe_peak(1),vect_t_probe_peak(end)],[s_probe_dil_peak(1),s_probe_dil_peak(end)],'-.' ,'Color',graphicR,'LineWidth',Linewidth_val_probe,'MarkerSize',MarkerSize_val_probe);
        plot(vect_t_probe_peak,s_probe_dil_LIP_peak,'-','Color',graphicMdBr,'LineWidth',Linewidth_val_probe,'MarkerSize',MarkerSize_val_probe);
        %plot([vect_t_probe_peak(1),vect_t_probe_peak(end)],[s_probe_dil_LIP_peak(1),s_probe_dil_LIP_peak(end)],'-' ,'Color',graphicMdBr,'LineWidth',Linewidth_val_probe,'MarkerSize',MarkerSize_val_probe);
        %xlim([vect_t(1) vect_t(end)]); %ylim([4, max(max(s_test(:)),max(s_probe_up_peak(:)))]);
        legend([hp1 hp2 hp3 hp4],'\it $f$','\it $\delta_{-\overline{b}}(f)$','\it $\delta_{-\overline{b}}^{+}(f)$','\it $\delta_{\overline{B}}(f)$',...
            'Location','southeast','Interpreter','latex','FontSize',fsz_leg);
        legend('boxoff');

        FIG_ajuste_xylim_plusieurs_fig( [fig_1,fig_2] );
        gca_fig_1 = gca_fig(fig_1);
        gca_fig_1.FontSize = fsz;
        gca_fig_1.FontName = 'Times New Roman';
    end
end


%%  Gradient and map of Asplund distance

im_Beucher_grad = s_test_dil_flat - s_test_ero_flat;
im_LIP_Beucher_grad = LIP_imsubtract( s_test_dil_flat , s_test_ero_flat , M );
imdistAsp_grad = LIP_imsubtract( s_test_LIP_dil , s_test_LIP_ero , M );
areImagesEqual( imdistAsp , imdistAsp_grad , 1e-12 )

if flag_display

    fig_5 = figure();hold on;%figure(fig_1);
    hp1 = plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz);
    hp4 = plot(imdistAsp_grad,'-','Color',graphicB,'LineWidth',lw,'MarkerSize',msz);
    hp2 = plot(im_Beucher_grad,'-+','Color',graphicMdBr,'LineWidth',lw,'MarkerSize',msz,'MarkerIndices',1:round(length(im_Beucher_grad)/10):length(im_Beucher_grad));
    hp3 = plot(im_LIP_Beucher_grad, '-','Color',graphicR,'LineWidth',lw,'MarkerSize',msz);
    %hp5 = plot(s_probe,'-.' ,'Color',graphicG,'LineWidth',Linewidth_val_probe,'MarkerSize',MarkerSize_val_probe);
    % Positionnning the probes at peak locations
    [ ~ , IdxList_max ] = SGN_maxima( s_test ); % extraction of the locations of the peaks
    xlim([1 length(s_test)]); ylim([-50 200]);
    legend([hp1 hp2 hp3 hp4],'\it $f$','\it $\varrho_{B}(f)$','\it $\varrho_{B}^{LIP}(f)$','\it $Asp_b^+f$',...
        'Location','northwest','Interpreter','latex','FontSize',fsz_leg);
    legend('boxoff');

    xticks([]);
    gca_fig_5 = gca_fig(fig_5);
    gca_fig_5.FontSize = fsz;
    gca_fig_5.FontName = 'Times New Roman';


end

if flag_write_res
    fname = fullfile(out_dir,'Comparison_mapAsp_grad.fig');
    saveas( fig_5, fname );
    fname = fullfile(out_dir,'Comparison_mapAsp_grad.svg');
    saveas( fig_5, fname );
end

half_lgt_probe = floor(lgt_probe/2);
idx_centre_probe = length(s_test)-half_lgt_probe;
for k = 1
    idx_peak                = IdxList_max{k};
    idx_ini_pr              = idx_centre_probe-half_lgt_probe; %starting idx of the probe when located at a peak
    idx_end_pr              = idx_centre_probe+half_lgt_probe; %ending   idx of the probe when located at a peak
    vect_t_probe_peak       = idx_ini_pr:idx_end_pr;
    %vect_t_probe_peak       = vect_t_probe_peak + (idx_end_pr-idx_ini_pr) + 20;
    s_test_peak             = s_test(idx_peak);
    s_probe_dil_peak        = s_test_peak+s_probe;
    dyn_probe_dil_peak      = max(s_probe_dil_peak(:)) - min(s_probe_dil_peak(:));
    %dil_LIP_peak            = s_test_LIP_dil(idx_peak);
    s_probe_dil_LIP_peak    = LIP_imsubtract(LIP_imadd(s_test_peak,s_probe,M),dyn_probe_dil_peak,M);
    dyn_probe_dil_LIP_peak  = max(s_probe_dil_LIP_peak(:)) - min(s_probe_dil_LIP_peak(:));
    disp('Dynamic of the upper probe');disp(dyn_probe_dil_peak);
    disp('Dynamic of the lower probe');disp(dyn_probe_dil_LIP_peak);

    if flag_display
        figure(fig_5); hold on
        hp5 = plot(vect_t_probe_peak,s_probe_dil_LIP_peak,'-.' ,'Color',graphicG,'LineWidth',Linewidth_val_probe,'MarkerSize',MarkerSize_val_probe);
        legend([hp1 hp2 hp3 hp4 hp5],'\it $f$','\it $\varrho_{B}(f)$','\it $\varrho_{B}^{LIP}(f)$','\it $Asp_b^+f$','$b$',...
            'Location','northwest','Interpreter','latex','FontSize',fsz_leg);
        legend('boxoff');
    end
end

if flag_write_res
    fname = fullfile(out_dir,'Comparison_mapAsp_grad_with_probe.fig');
    saveas( fig_5, fname );
    fname = fullfile(out_dir,'Comparison_mapAsp_grad_with_probe.svg');
    saveas( fig_5, fname );
end





%% Path management
path(oldpath);
pause(0.1);