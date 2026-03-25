%Script_LIP_morpho_disque.m
% Guillaume NOYEL
% 19/12/2021

close all; clearvars;

oldpath = addpath('Function_sources');

flag_display = true;

%% Flags for the different parts to be run

flag_write_res = true;%false;


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


close(gcf);

%% LIP model
M =  256;



%% Paths

% [~,racine_filename] = fileparts(mfilename);

folder_out = 'Res/Disk';


dossier = 'im/Disk/P7';
filename_in_fix         = fullfile(dossier,'DSC00639_fix_1o013.JPG'); % image of fixed disk
filename_in_mov_long_ET = fullfile(dossier,'DSC00641_mov_1o013.JPG'); % image of moving disk with long  exposure time - blurred
filename_in_mov_shor_ET = fullfile(dossier,'DSC00658_mov_1o160.JPG'); % image of moving disk with short exposure time - dark


[~,r_fname]     = fileparts(filename_in_fix);
[~,r_fname_fix] = fileparts(filename_in_mov_long_ET); r_fname_fix = r_fname(end-8:end);
[~,r_fname_lET] = fileparts(filename_in_mov_long_ET); r_fname_lET = r_fname_lET(end-8:end);
[~,r_fname_sET] = fileparts(filename_in_mov_shor_ET); r_fname_sET = r_fname_sET(end-8:end);

%% LIP model
M = 256;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Reading of the images
im_fix_col      = imread(filename_in_fix);
im_mov_lET_col  = imread(filename_in_mov_long_ET);
im_mov_sET_col  = imread(filename_in_mov_shor_ET);

% Exposure time of the images
info = imfinfo(filename_in_fix);            ET_fix = info.DigitalCamera.ExposureTime;
info = imfinfo(filename_in_mov_long_ET);    ET_mov_lET = info.DigitalCamera.ExposureTime;
info = imfinfo(filename_in_mov_shor_ET);    ET_mov_sET = info.DigitalCamera.ExposureTime;

% Resizing
scale_resize    = 1/6;%1/4;
im_fix_col      = imresize(im_fix_col,scale_resize);
im_mov_lET_col  = imresize(im_mov_lET_col,scale_resize);
im_mov_sET_col  = imresize(im_mov_sET_col,scale_resize);

% Cropping
y_max           = 700;
im_fix_col      = im_fix_col(:,1:y_max,:);
im_mov_lET_col  = im_mov_lET_col(:,1:y_max,:);
im_mov_sET_col  = im_mov_sET_col(:,1:y_max,:);

% conversion to grey-level
im_fix          = rgb2gray(im_fix_col);
im_mov_lET      = rgb2gray(im_mov_lET_col);
im_mov_sET      = rgb2gray(im_mov_sET_col);
SZ              = size(im_fix);


pos = [413.5797   82.8872   54.3612   54.3678];
pos_zoi = [45.1004   20.9144  606.5951  552.5049];

if flag_display
    fig_1 = figure();
    imagesc(im_fix); colormap gray; axis equal
    title('Fixed oobject')
    
    h = imellipse(gca_fig(fig_1), pos);
    addNewPositionCallback(h,@(p) title(mat2str(p,3)));
    fcn = makeConstrainToRectFcn('imellipse',get(gca,'XLim'),get(gca,'YLim'));
    setPositionConstraintFcn(h,fcn);
    setFixedAspectRatioMode(h,true);
%      position = wait(h);
%      pos = h.getPosition();
    msk_probe_global = createMask(h);
    h_zoi = imellipse(gca_fig(fig_1), pos_zoi);
%     position_zoi = wait(h_zoi);
%     pos_zoi = h_zoi.getPosition();
    msk_zoi_global = createMask(h_zoi);
end



BB_probe      = get_1_BoundingBox(msk_probe_global);
x_min   = BB_probe(1); x_max = BB_probe(2); y_min = BB_probe(3); y_max = BB_probe(4);
msk_probe = msk_probe_global( y_min:y_max , x_min:x_max );
im_probe  = im_fix( y_min:y_max , x_min:x_max );
im_probe(~msk_probe) = 0;
im_probe_col = im_fix_col(y_min:y_max , x_min:x_max , : );
im_probe_col = imhsp_mskfill(im_probe_col,[0 0 0],~msk_probe);


if flag_display
    fig_2 = figure();
    imagesc(im_probe); colormap gray; axis equal
    title('Probe')
end
SZ_probe = size(im_probe);

if flag_display
    fig_1 = figure();
    subplot(2,2,1)
    mini_fix = min(im_fix(:));  maxi_fix = max(im_fix(:));
    imagesc(im_fix); colormap gray; axis equal; %caxis([mini_fix maxi_fix]);
    title(sprintf('Fixed object ET = 1/%02.f',1/ET_fix));
    
    subplot(2,2,2)
    imagesc(im_mov_lET); colormap gray; axis equal; %caxis([mini_fix maxi_fix]);
    title(sprintf('Moving object ET = 1/%02.f',1/ET_mov_lET));
    
    subplot(2,2,3)
    imagesc(im_mov_sET); colormap gray; axis equal; %caxis([mini_fix maxi_fix]);
    title(sprintf('Moving object ET = 1/%02.f',1/ET_mov_sET));
    
    fig_1_bis = figure();
    subplot(2,2,1)
    mini_fix = min(im_fix(:));  maxi_fix = max(im_fix(:));
    imhist(im_fix); 
    title(sprintf('Fixed object ET = 1/%02.f',1/ET_fix));
    
    subplot(2,2,2)
    imhist(im_mov_lET); 
    title(sprintf('Moving object ET = 1/%02.f',1/ET_mov_lET));
    
    subplot(2,2,3)
    imhist(im_mov_sET); 
    title(sprintf('Moving object ET = 1/%02.f',1/ET_mov_sET));
end



%% Probe

SE_probe = strel('arbitrary',msk_probe,double(im_probe));

%% Cylindrical probe

r_centre = max(get_strel_centre(im_probe))-1;
val_cylinder =mean(im_probe(msk_probe));

if flag_display
    fig_3 = figure();
    subplot(1,3,1)
    imagesc(SE_probe.getheight()); colormap gray; axis equal
    title('Image probe')
    
    subplot(1,3,2)
    imagesc(SE_probe.getnhood()); colormap gray; axis equal
    title('mask probe')
    
    subplot(1,3,3)
    surf(SE_probe.getheight()); colormap default; shading interp
    set(gca,'YDir','reverse');
    title('Image probe')
end

%% Detection Asplund LIP_add


SE_probe_c = strel('arbitrary',SE_probe.getnhood(),LIP_imcomplement(SE_probe.getheight(),M)); % complement of the probe

tol = 80/100;%95/100;%75/100;%75/100;%75/100;%70/100;



r_detect = 2*round(min(SZ_probe)/4)+1;

[msk_disksLIPAdd_im_fix, border_disksLIPAdd_im_fix, imAsDistLIPAdd_im_fix, imAsDistAdd_im_fix] = Detector_moving_disks_LIP_imDistAsplund_Add_v2( im_fix , ...
    SE_probe , tol , r_detect, flag_display , M );
[msk_disksLIPAdd_im_mov_lET, border_disksLIPAdd_im_mov_lET, imAsDistLIPAdd_im_mov_lET, imAsDistAdd_im_mov_lET] = Detector_moving_disks_LIP_imDistAsplund_Add_v2( im_mov_lET , ...
    SE_probe , tol , r_detect , flag_display , M );
[msk_disksLIPAdd_im_mov_sET, border_disksLIPAdd_im_mov_sET, imAsDistLIPAdd_im_mov_sET, imAsDistAdd_im_mov_sET] = Detector_moving_disks_LIP_imDistAsplund_Add_v2( im_mov_sET , ...
    SE_probe , tol , r_detect , flag_display , M );


if flag_display
    fig_4 = figure;
    subplot(2,2,1);
    mini_imAsDistLIPAdd_im_fix = 0;%min(imAsDistLIPAdd_im_fix(:));     
    maxi_imAsDistLIPAdd_im_fix = M-1;%max(imAsDistLIPAdd_im_fix(:));
    image(imAsDistLIPAdd_im_fix);  axis equal; colormap gray
    caxis([mini_imAsDistLIPAdd_im_fix maxi_imAsDistLIPAdd_im_fix]);
    title('Map LIP-Distance (fixed object)')
    
    subplot(2,2,2);
    image(imAsDistLIPAdd_im_mov_lET); axis equal
    caxis([mini_imAsDistLIPAdd_im_fix maxi_imAsDistLIPAdd_im_fix]);
    title('Map LIP-Distance (moving object - long ET)')
    
    subplot(2,2,3);
    image(imAsDistLIPAdd_im_mov_sET); axis equal
     caxis([mini_imAsDistLIPAdd_im_fix maxi_imAsDistLIPAdd_im_fix]);
    title('Map LIP-Distance (moving object - short ET)')
    
    fig_5 = figure;
    subplot(2,2,1);    
    mini_imAsDistAdd_im_fix = 0;%min(imAsDistAdd_im_fix(:));     
    maxi_imAsDistAdd_im_fix = M-1;%max(imAsDistAdd_im_fix(:));
    image(imAsDistAdd_im_fix);  axis equal; colormap gray
    caxis([mini_imAsDistAdd_im_fix maxi_imAsDistAdd_im_fix]);
    title('Map Distance (fixed object)')
    
    subplot(2,2,2);
    image(imAsDistAdd_im_mov_lET); axis equal
    caxis([mini_imAsDistAdd_im_fix maxi_imAsDistAdd_im_fix]);
    title('Map Distance (moving object - long ET)')
    
    subplot(2,2,3);
    image(imAsDistAdd_im_mov_sET); axis equal
     caxis([mini_imAsDistAdd_im_fix maxi_imAsDistAdd_im_fix]);
    title('Map Distance (moving object - short ET)')    
    
end

if flag_display
    fig_6 = figure;
    subplot(2,2,1)
    imagesc(im_fix); axis equal; hold on; colormap gray
    for n=1:length(border_disksLIPAdd_im_fix)
        plot(border_disksLIPAdd_im_fix{n}(:,2),border_disksLIPAdd_im_fix{n}(:,1),'r-');
    end
    title(sprintf('Borders (fixed object ET = 1/%02.f)',1/ET_fix));
    
    subplot(2,2,2)
    imagesc(im_mov_lET); axis equal; hold on; colormap gray
    for n=1:length(border_disksLIPAdd_im_mov_lET)
        plot(border_disksLIPAdd_im_mov_lET{n}(:,2),border_disksLIPAdd_im_mov_lET{n}(:,1),'r-');
    end
    title(sprintf('Borders (moving object - long ET = 1/%02.f)',1/ET_mov_lET));
    
    subplot(2,2,3)
    imagesc(im_mov_sET); axis equal; hold on; colormap gray
    for n=1:length(border_disksLIPAdd_im_mov_sET)
        plot(border_disksLIPAdd_im_mov_sET{n}(:,2),border_disksLIPAdd_im_mov_sET{n}(:,1),'r-');
    end
    title(sprintf('Borders (moving object - short ET = 1/%02.f)',1/ET_mov_sET));    
end

if flag_write_res
    n_dil = 6;
    col_white = [255 255 255];
    im_sup_ball_LIP_add_im_fix   = ajout_frontiere(uint8(im_fix_col),msk_disksLIPAdd_im_fix,col_white,n_dil);
    im_sup_ball_LIP_add_im_mov_sET    = ajout_frontiere(uint8(im_mov_sET_col) ,msk_disksLIPAdd_im_mov_sET,col_white,n_dil);
    col_green = [0 255 0];
	im_sup_probe_im_fix          = ajout_frontiere(uint8(im_fix_col),msk_probe_global,col_white,n_dil);
    im_sup_ball_and_probe_LIP_add_im_fix   = ajout_frontiere(uint8(im_sup_ball_LIP_add_im_fix),msk_probe_global,col_green,n_dil);
    
    ajout_dossier_depuis_nom_dossier(folder_out);
    f_name = fullfile(folder_out,sprintf('Moving_disk_col_seg_AsLIPAdd_im_%s.png',r_fname_fix));
    imwrite(im_sup_ball_LIP_add_im_fix,f_name);
    f_name = fullfile(folder_out,sprintf('Moving_disk_col_seg_AsLIPAdd_im_%s.png',r_fname_sET));
    imwrite(im_sup_ball_LIP_add_im_mov_sET,f_name);
	f_name = fullfile(folder_out,sprintf('Moving_disk_probe_col_im_%s.png',r_fname_fix));
    imwrite(im_probe_col,f_name);
    f_name = fullfile(folder_out,sprintf('Moving_disk_select_probe_col_im_%s.png',r_fname_fix));
    imwrite(im_sup_probe_im_fix,f_name);
    f_name = fullfile(folder_out,sprintf('Moving_disk_col_seg_and_probe_AsLIPAdd_im_%s.png',r_fname_fix));
    imwrite(im_sup_ball_and_probe_LIP_add_im_fix,f_name);
    
    f_name = fullfile(folder_out,sprintf('Moving_disk_col_im_%s.png',r_fname_fix));
    imwrite(im_fix_col,f_name);
    f_name = fullfile(folder_out,sprintf('Moving_disk_col_im_%s.png',r_fname_sET));
    imwrite(im_mov_sET_col,f_name);
    f_name = fullfile(folder_out,sprintf('Moving_disk_col_im_%s.png',r_fname_lET));
    imwrite(im_mov_lET_col,f_name);
    
    %% Map of LIP-additive Asplund distances

    imAsDistLIPAdd_im_fix_disp = uint8(imAsDistLIPAdd_im_fix); 
    f_name = fullfile(folder_out,sprintf('Moving_disk_AsDistLIPAdd_im_%s.png',r_fname_fix));
    imwrite( imAsDistLIPAdd_im_fix_disp , f_name );
    
    imAsDistLIPAdd_im_mov_lET_disp = uint8(imAsDistLIPAdd_im_mov_lET); 
    f_name = fullfile(folder_out,sprintf('Moving_disk_AsDistLIPAdd_im_%s.png',r_fname_lET));
    imwrite( imAsDistLIPAdd_im_mov_lET_disp , f_name );

    imAsDistLIPAdd_im_mov_sET_disp = uint8(imAsDistLIPAdd_im_mov_sET);
    f_name = fullfile(folder_out,sprintf('Moving_disk_AsDistLIPAdd_im_%s.png',r_fname_sET));
    imwrite( imAsDistLIPAdd_im_mov_sET_disp , f_name )

    
    %% Map of additive Asplund distances (without the LIP model)

    imAsDistAdd_im_fix_disp = uint8(imAsDistAdd_im_fix); 
    f_name = fullfile(folder_out,sprintf('Moving_disk_AsDistAdd_im_%s.png',r_fname_fix));
    imwrite( imAsDistAdd_im_fix_disp , f_name );
    
    imAsDistAdd_im_mov_lET_disp = uint8(imAsDistAdd_im_mov_lET); 
    f_name = fullfile(folder_out,sprintf('Moving_disk_AsDistAdd_im_%s.png',r_fname_lET));
    imwrite( imAsDistAdd_im_mov_lET_disp , f_name );

    imAsDistAdd_im_mov_sET_disp = uint8(imAsDistAdd_im_mov_sET);
    f_name = fullfile(folder_out,sprintf('Moving_disk_AsDistAdd_im_%s.png',r_fname_sET));
    imwrite( imAsDistAdd_im_mov_sET_disp , f_name ); 
end

%% Path management
path(oldpath);
pause(0.1); 