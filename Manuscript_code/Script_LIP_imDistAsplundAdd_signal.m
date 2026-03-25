%Script_LIP_imDistAsplundAdd_signal.m
% Guillaume NOYEL
% 30/01/2021

close all; clearvars;

oldpath = addpath('Function_sources');

%% Flags

flag_write_result = true;%false;%true;
flag_display = true;

%% Flags for the different parts to be run

flag(1) = true; % signal 2

%% Paths

[cur_dir,racine_filename] = fileparts(mfilename);
input_folder = fullfile(cur_dir,'im');
dir_out = fullfile(cur_dir,'Res');


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
fsz_leg = fsz+6;      % Fontsize
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


lgt_half_probe = round(length(vect_pattern)/1.5);

% Circle
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

%% Asplund distance

[im_dist,im_c1 , im_c2] = LIP_imDistAsplundAdd( s_test , SE , M );

% verification with LIP-dilation and LIP-erosion
im_LIPdil = LIP_imdilate( s_test , SE_Lneg.reflect() , M );
im_LIPero = LIP_imerode( s_test , SE , M );

b1 = areImagesEqual( im_c1 , im_LIPdil , 1e-12 );
b2 = areImagesEqual( im_c2 , im_LIPero , 1e-12 );
b = b1 && b2;

if b
    disp 'Test succeeded'
else
    disp 'Test failed'
end


if flag_display

    fig_3 = figure();hold on;%figure(fig_1);
    %subplot(2,2,3);
    plot(im_dist,'-','Color',graphicB,'LineWidth',lw,'MarkerSize',msz);
    plot(im_c1,'--','Color',graphicDrBr,'LineWidth',lw,'MarkerSize',msz);
    plot(im_c2,'-.','Color',graphicDrBr,'LineWidth',lw,'MarkerSize',msz);
    xlim([1 L]); %ylim([min([im_dist(:);im_c1(:);im_c2(:)]) max([im_dist(:);im_c1(:);im_c2(:)])]);
    % title('Map of Asplund''s distances')
    %xlabel('\it x'); ylabel('\it Values');
    xticks([]);
    gca_fig_3 = gca_fig(fig_3);
    gca_fig_3.FontSize = fsz;
    gca_fig_3.FontName = 'Times New Roman';
end

if flag_display

    fig_4 = figure();hold on;%figure(fig_1);
    %subplot(2,2,3);
    plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz);
    plot(im_c1,'--','Color',graphicDrBr,'LineWidth',lw,'MarkerSize',msz);
    plot(im_c2,'-.','Color',graphicDrBr,'LineWidth',lw,'MarkerSize',msz);
    xlim([1 L]); %ylim([min([im_dist(:);im_c1(:);im_c2(:)]) max([im_dist(:);im_c1(:);im_c2(:)])]);
    %xlabel('\it x');  ylabel('\it Grey levels');
    %title('Input signal')
    xticks([]);
    gca_fig_4 = gca_fig(fig_4);
    gca_fig_4.FontSize = fsz;
    gca_fig_4.FontName = 'Times New Roman';
end



%% Positionnning the probes at peak locations
h = 0.5;
[ ~ , IdxList_max ] = SGN_maxima( s_test ); % extraction of the locations of the peaks

half_lgt_probe = floor(lgt_probe/2);

for k = 1:2
    idx_peak            = IdxList_max{k};
    idx_ini_pr          = idx_peak-half_lgt_probe; %starting idx of the probe when located at a peak
    idx_end_pr          = idx_peak+half_lgt_probe; %ending   idx of the probe when located at a peak
    vect_t_probe_peak   = idx_ini_pr:idx_end_pr;
    c1_peak             = im_c1(idx_peak);
    s_probe_up_peak     = LIP_imadd(s_probe,c1_peak,M);
    dyn_probe_up_peak   = max(s_probe_up_peak(:)) - min(s_probe_up_peak(:));
    c2_peak             = im_c2(idx_peak);
    s_probe_low_peak    = LIP_imadd(s_probe,c2_peak,M);
    dyn_probe_low_peak   = max(s_probe_low_peak(:)) - min(s_probe_low_peak(:));
    disp('Dynamic of the upper probe');disp(dyn_probe_up_peak);
    disp('Dynamic of the lower probe');disp(dyn_probe_low_peak);


    if flag_display
        figure(fig_1); hold on
        %subplot(2,2,1);
        %plot(vect_t(idx_peak),s_test(idx_peak),'+','Color',graphicMdBr,'LineWidth',Linewidth_val,'MarkerSize',MarkerSize_val);
        plot(vect_t_probe_peak,s_probe_up_peak,'-.' ,'Color',graphicR,'LineWidth',lw,'MarkerSize',msz);
        plot(vect_t_probe_peak,s_probe_low_peak,'-.','Color',graphicR,'LineWidth',lw,'MarkerSize',msz);
        xlim([vect_t(1) vect_t(end)]); %ylim([4, max(max(s_test(:)),max(s_probe_up_peak(:)))]);
        gca_fig_1 = gca_fig(fig_1);
        gca_fig_1.FontSize = fsz;
        gca_fig_1.FontName = 'Times New Roman';
    end
end

vect_const = [-255:1:255];
dyn_probe_add = NaN(size(vect_const));
for n=1:length(vect_const)
    const = vect_const(n);
    s_probe_add         = LIP_imadd(s_probe,const,M);
    dyn_probe_add(n)    = max(s_probe_add(:)) - min(s_probe_add(:));
end

figure;
plot(vect_const,dyn_probe_add);
title('Dynamic of the probe after the LIP-addition of a constant')




%% Opening

im_Lop = LIP_imopen( s_test , SE , M );

% supremum of LIP_imadd( probe , im_c2 , M );

[im_sup_Lsum_c2_probe] = LIP_imsup_mglb_LP_probe( im_c2 , SE , M );

b3 = areImagesEqual( im_sup_Lsum_c2_probe , im_Lop , 1e-12 );

if flag_display
    fig_5 = figure(); hold on
    %subplot(2,2,1);
    plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz,'DisplayName','\it $f$');
    plot(im_Lop,'-.','Color',graphicMdBr,'LineWidth',lw,'MarkerSize',msz,'DisplayName','\it $\gamma_b^{+}(f)$');
    %plot(im_sup_Lsum_c2_probe,'-.','Color',graphicR,'LineWidth',lw,'MarkerSize',msz,'DisplayName','sup( c2 L+ probe )');
    %plot(im_c2,'.','Color',graphicDrBr,'LineWidth',lw,'MarkerSize',msz,'DisplayName','c2');
    legend('show','Location','southeast','Interpreter','latex','FontSize',fsz_leg);%,'Box',
    legend('boxoff');

    %xlim([vect_t(1) vect_t(end)]); %ylim([4, max(s_test(:))]);
    %xlabel('\it x');  ylabel('\it Grey levels');
    %title('Input signal')
    xticks([]);
    gca_fig_5 = gca_fig(fig_5);
    gca_fig_5.FontSize = fsz;
    gca_fig_5.FontName = 'Times New Roman';
end


%% Closing
im_Lcl_neg = LIP_imclose( s_test , SE_Lneg.reflect() , M );

% infimum of LIP_imadd( LIP_imneg(probe).reflect() , im_c1 , M );

[im_inf_Lsum_c1_probe] = LIP_iminf_mlub_LP_probe( im_c1 , SE , M );

b4 = areImagesEqual( im_inf_Lsum_c1_probe , im_Lcl_neg , 1e-12 );

if flag_display
    fig_6 = figure(); hold on
    %subplot(2,2,1);
    plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz,'DisplayName','\it $f$');
    plot(im_Lcl_neg,'-.','Color',graphicMdBr,'LineWidth',lw,'MarkerSize',msz,'DisplayName','\it $\varphi_{-\overline{b}}^{+}(f)$');
    %plot(im_inf_Lsum_c1_probe,'-.','Color',graphicR,'LineWidth',lw,'MarkerSize',msz,'DisplayName','inf( c1 L+ probe )');
    %plot(im_c1,'.','Color',graphicDrBr,'LineWidth',lw,'MarkerSize',msz,'DisplayName','c1');
    legend('show','Location','southeast','Interpreter','latex','FontSize',fsz_leg);%,'Box',
    legend('boxoff');

    %xlim([vect_t(1) vect_t(end)]); %ylim([4, max(s_test(:))]);
    %xlabel('\it x');  ylabel('\it Grey levels');
    %title('Input signal')
    xticks([]);
    gca_fig_6 = gca_fig(fig_6);
    gca_fig_6.FontSize = fsz;
    gca_fig_6.FontName = 'Times New Roman';
    FIG_ajuste_xylim_plusieurs_fig( [fig_1,fig_3,fig_4,fig_5,fig_6] );
end

%% writing the results

if flag_write_result
    ajout_dossier_depuis_nom_dossier(dir_out);

    saveas(  fig_1              , fullfile( dir_out , 'Signal_and_probe.fig') );
    saveas(  fig_1              , fullfile( dir_out , 'Signal_and_probe.svg') );
    fprintf('<----------------- Writing : %s\n',fullfile( dir_out , 'Signal_and_probe.svg'));

    saveas(  fig_3              , fullfile( dir_out , 'Signal_and_mapAspAdd.fig') );
    saveas(  fig_3              , fullfile( dir_out , 'Signal_and_mapAspAdd.svg') );
    fprintf('<----------------- Writing : %s\n',fullfile( dir_out , 'Signal_and_mapAspAdd.svg'));

    saveas(  fig_4              , fullfile( dir_out , 'Signal_and_imc1_imc2.fig') );
    saveas(  fig_4              , fullfile( dir_out , 'Signal_and_imc1_imc2.svg') );
    fprintf('<----------------- Writing : %s\n',fullfile( dir_out , 'Signal_and_imc1_imc2.svg'));

    saveas(  fig_5              , fullfile( dir_out , 'Signal_opening_mapAspAdd.fig') );
    saveas(  fig_5              , fullfile( dir_out , 'Signal_opening_mapAspAdd.svg') );
    fprintf('<----------------- Writing : %s\n',fullfile( dir_out , 'Signal_opening_mapAspAdd.svg'));

    saveas(  fig_6              , fullfile( dir_out , 'Signal_closing_mapAspAdd.fig') );
    saveas(  fig_6              , fullfile( dir_out , 'Signal_closing_mapAspAdd.svg') );
    fprintf('<----------------- Writing : %s\n',fullfile( dir_out , 'Signal_closing_mapAspAdd.svg'));
end

%% LIP close Negative - LIP open

im_LTH_LclNeg_Lop = LIP_imsubtract( im_Lcl_neg , im_Lop , M );

if flag_display
    fig_7 = figure(); hold on
    %subplot(2,2,1);
    plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz,'DisplayName','Input');
    plot(im_dist,'-.','Color',graphicB,'LineWidth',lw,'MarkerSize',msz,'DisplayName','Aspl dist');
    plot(im_LTH_LclNeg_Lop,'-','Color',graphicMdBr,'LineWidth',lw,'MarkerSize',msz,'DisplayName','LIP Top-hat L-closeNeg L-open');

    %xlim([vect_t(1) vect_t(end)]); %ylim([4, max(s_test(:))]);
    %xlabel('\it x');  ylabel('\it Grey levels');
    legend('show');
    %title('Input signal')
end


%% LIP close - LIP open Negative

im_LTH_Lcl_LopNeg = LIP_imsubtract( LIP_imclose( s_test , SE , M ) , LIP_imopen( s_test , SE_Lneg.reflect() , M ) , M );

if flag_display
    fig_8 = figure(); hold on
    %subplot(2,2,1);
    plot(s_test,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz,'DisplayName','Input');
    plot(im_dist,'-.','Color',graphicB,'LineWidth',lw,'MarkerSize',msz,'DisplayName','Aspl dist');
    plot(im_LTH_Lcl_LopNeg,'-','Color',graphicMdBr,'LineWidth',lw,'MarkerSize',msz,'DisplayName','LIP Top-hat L-close L-openNeg');

    %xlim([vect_t(1) vect_t(end)]); %ylim([4, max(s_test(:))]);
    %xlabel('\it x');  ylabel('\it Grey levels');
    legend('show');
    %title('Input signal')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%% Adding noise to the signal
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Adding noise
d = 0.08; % noise points density

%mini = min(s_test(:)); maxi = max(s_test(:));
mini = 0; maxi = 255;
%var = 0.01; % variance
sigma = 20;% std of the neoise in grey levels
var = (sigma/(maxi-mini))^2; % variance

N_pix = L;
N_pix_noisy = round( d * N_pix ); % Number of noisy pixels
V = zeros(size(s_test));
ind_noise = randi([1,N_pix],1,N_pix_noisy);%indices of the noisy points

V(ind_noise)            = var;

s_test_noised = imnoise((s_test-mini)/(maxi-mini),'localvar',V)*(maxi-mini) + mini;
var_stretch = (sqrt(var)*(maxi-mini))^2;

%% Asplund distance

[im_dist_noise,im_c1_noise , im_c2_noise] = LIP_imDistAsplundAdd( s_test_noised , SE , M );
tol = 85/100;
[im_dist_noise_tol, im_c1_noise_tol , im_c2_noise_tol] = LIP_imDistAsplundAddTol( s_test_noised , SE , tol , M );

if flag_display
    fig_9 = figure(); hold on
    plot(s_test_noised,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz,'DisplayName','$f$');
    plot(im_c1_noise,'-','Color',graphicR,'LineWidth',lw,'MarkerSize',msz,'DisplayName','$c_{1_b}(f)$');
    plot(im_c2_noise,'-','Color',graphicR,'LineWidth',lw,'MarkerSize',msz,'DisplayName','$c_{2_b}(f)$');
    plot(im_c1_noise_tol,'-','Color',graphicMdBr,'LineWidth',lw,'MarkerSize',msz,'DisplayName','$c_{1_b,p}(f)$');
    plot(im_c2_noise_tol,'-','Color',graphicMdBr,'LineWidth',lw,'MarkerSize',msz,'DisplayName','$c_{2_b,p}(f)$');
    plot(L-lgt_probe+1:L,s_probe,'-','Color',graphicG,'LineWidth',lw,'MarkerSize',msz);

    xticks([]);%ylim([-50, 200]);
    gca_fig_9 = gca_fig(fig_9);
    gca_fig_9.FontSize = fsz;
    gca_fig_9.FontName = FontName_val;
    set(gca_fig_9,'FontName',FontName_val);
    %legend('show','Location','southeast','Interpreter','latex','FontSize',fsz_leg);
    %legend('boxoff');
    %title('Input signal')


    fig_10 = figure(); hold on
    plot(im_dist_noise,'-','Color',graphicR,'LineWidth',lw,'MarkerSize',msz,'DisplayName','$Asp^{LP}_b(f)$');
    plot(im_dist_noise_tol,'-','Color',graphicMdBr,'LineWidth',lw,'MarkerSize',msz,'DisplayName','$Asp^{LP}_{b,p}(f)$');

    xticks([]);%ylim([-50, 200]);
    gca_fig_10 = gca_fig(fig_10);
    gca_fig_10.FontSize = fsz;
    gca_fig_10.FontName = FontName_val;
    set(gca_fig_10,'FontName',FontName_val);
    FIG_ajuste_ylim_plusieurs_fig([fig_9 fig_10]);
end


if flag_write_result
    saveas(  fig_9              , fullfile( dir_out , sprintf('Signal_noised_mlub_mglb_Aspltol_pct%02.f_sigma%d.fig',tol*100,sigma) ));
    saveas(  fig_9              , fullfile( dir_out , sprintf('Signal_noised_mlub_mglb_Aspltol_pct%02.f_sigma%d.svg',tol*100,sigma)) );
    fprintf('<----------------- Writing : %s\n',fullfile( dir_out , sprintf('Signal_noised_mlub_mglb_Aspltol_pct%02.f_sigma%d.svg',tol*100,sigma)));

    saveas(  fig_10              , fullfile( dir_out , sprintf('Signal_noised_mapAspltol_pct%02.f_sigma%d.fig',tol*100,sigma) ));
    saveas(  fig_10              , fullfile( dir_out , sprintf('Signal_noised_mapAspltol_pct%02.f_sigma%d.svg',tol*100,sigma)) );
    fprintf('<----------------- Writing : %s\n',fullfile( dir_out , sprintf('Signal_noised_mapAspltol_pct%02.f_sigma%d.svg',tol*100)));
end



%% Path management
path(oldpath);
pause(0.1);