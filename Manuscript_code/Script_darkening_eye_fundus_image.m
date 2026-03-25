
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Darkening of eye fundus images by using vignetting effect
%
% [] = Script_darkening_eye_fundus_image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script_darkening_eye_fundus_image.m
% Guillaume NOYEL 14-06-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all; 

oldpath = addpath('Function_sources');

filename_in = 'im/01_test.tif';
filename_msk = 'im/01_test_mask.gif';
filename_info = 'im/info_01_test.mat';



cur_dir = fileparts(mfilename("fullpath"));
dir_out = fullfile(cur_dir,'Res','Eye_fundus');


%% Parameters

flag_write_result = true;

para_disp.flag_display              = true;%false;%true;%false
para_disp.flag_detail               = true;%false;

para_disp.tab_fig                   = NaN(1,100);
para_disp.cpt_fig                   = 0; 
para_disp.cpt_pos                   = 0;
para_disp.flag_darken_images        = true;    

%% Influential parameters 

%coeff_D2 = 1/74;
%d2 = D/coeff_D2; %maximal width of vessels


[~,im_name_in] = fileparts(filename_in);

%% Figure parameters
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

%% Program

%try

% Position of the figures
pos_fenetre = FIG_get_pos_figs();



% % image file
im = imread(filename_in);
SZ = size(im);


%%  10  DRIVE database : the mask is given with the image

im_msk = imread( filename_msk )>0;

% Image bouding box
BB = get_1_BoundingBox(im_msk);
x_min = BB(1); x_max = BB(2); y_min = BB(3); y_max = BB(4);

load( filename_info , 'D' );

if para_disp.flag_display
    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    fig_ref = para_disp.tab_fig(para_disp.cpt_fig);
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_pos,:));
    imagesc(im); colormap gray; hold on;
    title(sprintf('image %s',im_name_in));
    axis equal

    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    fig_hist = para_disp.tab_fig(para_disp.cpt_fig);
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_pos,:));
    imhistcolor(im);
    set(fig_hist,'Name','Histrogram of the input image');
end

%% Vignetting Model


M = double(intmax(class(im)))+1;

[centre , R_c] = DR_IM_fit_disk(im_msk);

imR = double(im(:,:,1));


[xx,yy] = meshgrid(1:size(imR,2),1:size(imR,1));


[thetav,rv] = cart2pol(xx-centre(1),yy-centre(2));

I_add = 230*(1-exp(-1/(R_c/4)*rv));

I_drk = LIP_imadd(200 , I_add, M);
%I_drk(~im_msk) = 0;



if para_disp.flag_display
    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_pos,:));
    %plot(imR(round(centr
    % e(2)),:),'DisplayName','image profile'); hold on;
    plot(I_add(round(centre(2)),:),'DisplayName','dark image profile');
    legend('show');
    title('Vignetting profile')

    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    fig_1 = para_disp.tab_fig(para_disp.cpt_fig);
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_pos,:));
    s = surf(I_add,'DisplayName','darkening image');set (gca_fig(fig_1),'YDir','reverse');
    s.EdgeColor='none';
    xticks([]);  yticks([]);  
    %title('Darkening image'); 
    %xlabel('x');ylabel('y');%zlabel('Intensity');%map = colormap('gray'); colormap(map(end:-1:1));
    gca_fig_1 = gca_fig(fig_1);
    gca_fig_1.FontSize = fsz;
    gca_fig_1.FontName = 'Times New Roman';

    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_pos,:));
    %plot(imR(round(centre(2)),:)+1,'DisplayName','image profile'); hold on;
    imshow(I_add,[min(I_add(im_msk)) max(I_add(im_msk))]);
    title('Vignetting')

    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_pos,:));
    %plot(imR(round(centre(2)),:)+1,'DisplayName','image profile'); hold on;
    imshow(I_drk,[min(I_drk(im_msk)) max(I_drk(im_msk))]);
    title('Dark image')
end


%% Writing the results
if flag_write_result
    ajout_dossier_depuis_nom_dossier(dir_out);
    saveas(  fig_1              , fullfile( dir_out , 'Darkening_function.fig') );
    saveas(  fig_1              , fullfile( dir_out , 'Darkening_function.svg') );
    fprintf('<----------------- Writing : %s\n',fullfile( dir_out , 'Darkening_function.svg'));
end


%% Darkening of the images by LIP-adding a constant equal to 100


if para_disp.flag_darken_images 
    cte = 170;%100;
    M = double(intmax(class(im)))+1;
    %im_dark_c = LIP_imadd( LIP_imcomplement( im , M ) , cte , M );
    im_dark_c = LIP_imadd( LIP_imcomplement( im , M ) , I_add , M );
    min(imhsp_mskextract(im_dark_c,im_msk))
    max(imhsp_mskextract(im_dark_c,im_msk))
    im_dark = LIP_imcomplement( uint8(im_dark_c) , M );
    %im_dark(~im_msk) = 0;
    im_dark = imhsp_mskfill(im_dark,repmat(max(min(imhsp_mskextract(im_dark,im_msk))),1,3),~im_msk);

    fprintf('Mean of the input image : %.02f\n',mean2(imhsp_mskextract(im,im_msk)));
    fprintf('Mean of the darkened image : %.02f\n',mean2(imhsp_mskextract(im_dark,im_msk)));

    if para_disp.flag_display
        para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
        fig_drk = para_disp.tab_fig(para_disp.cpt_fig);
        para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_pos,:));
        imagesc(im_dark); colormap gray; hold on;
        title(sprintf('darkened image %s',im_name_in));
        axis equal

        para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
        fig_hist2 = para_disp.tab_fig(para_disp.cpt_fig);
        para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_pos,:));
        imhistcolor(im_dark);
        set(fig_hist2,'Name','Histrogram of the darkened image');
    end
end


%% Writing the results
if flag_write_result
    im_ZOI = im( y_min:y_max , x_min:x_max , : );
    fname = fullfile( dir_out , [im_name_in,'_crop.png']);
    imwrite(  im_ZOI            , fname );
    fprintf('<----------------- Writing : %s\n',fname);


    fname = fullfile( dir_out , [im_name_in,'_drk_LP_exp_to_230.png']);
    imwrite(  im_dark            , fname );
    fprintf('<----------------- Writing : %s\n',fname);

    im_dark_ZOI = im_dark( y_min:y_max , x_min:x_max , : );
    fname = fullfile( dir_out , [im_name_in,'_crop_drk_LP_exp_to_230.png']);
    imwrite(  im_dark_ZOI            , fname );
    fprintf('<----------------- Writing : %s\n',fname);
end

%% Normalisation
im_g = rgb2gray(double(im)/(M-1));
im_g = reshape(normalize(im_g(:)),SZ(1:2));
im_g = (im_g - min(im_g(:)))./((max(im_g(:)) - min(im_g(:))));

im_dark_g = rgb2gray(double(im_dark)/(M-1));
im_dark_g = reshape(normalize(im_dark_g(:)),SZ(1:2));
im_dark_g = (im_dark_g - min(im_dark_g(:)))./((max(im_dark_g(:)) - min(im_dark_g(:))));

if para_disp.flag_darken_images 
    fprintf('Mean of the input image : %.02f\n',mean2(imhsp_mskextract(im_dark_g,im_msk)));
    fprintf('Mean of the darkened image : %.02f\n',mean2(imhsp_mskextract(im_dark_g,im_msk)));

    if para_disp.flag_display
        para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
        para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_pos,:));
        %plot(imR(round(centr
        % e(2)),:),'DisplayName','image profile'); hold on;
        plot(im_dark_g(round(centre(2)),:),'DisplayName','normalized dark image profile'); hold on
        plot(im_g(round(centre(2)),:),'DisplayName','normalized image profile'); hold on
        legend('show');
        title('profile normalized darkened image')

        para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
        fig_drk_a = para_disp.tab_fig(para_disp.cpt_fig);
        para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_pos,:)); hold on;
        subplot(1,2,1); surf(im_g,'EdgeColor','none'); colormap gray; title(sprintf('normalized image %s',im_name_in));  set(gca_fig(fig_drk_a),'YDir','reverse'); 
        subplot(1,2,2); surf(im_dark_g,'EdgeColor','none'); colormap gray; title(sprintf('normalized darkened image %s',im_name_in));  set(gca_fig(fig_drk_a),'YDir','reverse')

        para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
        fig_drk = para_disp.tab_fig(para_disp.cpt_fig);
        para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_pos,:)); hold on;
        subplot(1,2,1); imagesc(im_g); colormap gray; title(sprintf('normalized image %s',im_name_in)); axis equal
        subplot(1,2,2); imagesc(im_dark_g); colormap gray; title(sprintf('normalized darkened image %s',im_name_in)); axis equal
        axis equal
    end
end

%% Path management
path(oldpath);
pause(0.1); 
