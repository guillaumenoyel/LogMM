
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Vessel detection by bump detector (LIP-Mathematical Morphology)
%
% [] = DR_INT_vessel_detection_LMM( kprob , kpack , filename_in , coeff_D1 , coeff_D2 , flag_darken_images )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%   kprob  : problem number data web
%           10  DRIVE database (public) - 2 packages
%
%   kpack  : number of acquisition package
%            1  first package of images
%            1  second package of images
%            i  i-th package of images
%
%   filename_in : full image filename
%
%   coeff_D1         # coefficient of the average diameter of the optic disc : d1 = D*coeff_D1
%   coeff_D2         # coefficient of the maximal width of vessels : d2 = D*coeff_D2
%
%   flag_darken_images    # flag to use the darken images or normal images
%                               - false : use normal images
%                               - true  : use darken images
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DR_INT_vessel_detection_LMM.m
% Guillaume NOYEL 09-09-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [] = DR_INT_vessel_detection_LMM( kprob , kpack , filename_in , coeff_D1 , coeff_D2 , flag_darken_images )


%% Parameters



para_disp.flag_display              = false;%true;%false
para_disp.flag_detail               = false;

para_disp.flag_save_final_display   = true;
para_disp.tab_fig                   = NaN(1,100);
para_disp.cpt_fig                   = 0; 
para_disp.cpt_pos                   = 0;
para_disp.flag_darken_images        = flag_darken_images; %false;%   



%% Influential parameters 



[~,im_name_in] = fileparts(filename_in);


%% Program

try

% Position of the figures
pos_fenetre = FIG_get_pos_figs();


%%  10  DRIVE database : the mask is given with the image
kfile = 11011; % Mask given with the image database
[lefic] = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
im_msk = imread( lefic )>0;


%% Field of view diameter

[~ , R_c] = DR_IM_fit_disk( im_msk ); 
D = 2*R_c;

%% Reading the darken image


if para_disp.flag_darken_images 

    kfile =2161; % Darkened image by LIP-adding an exponential drift up to 230 in PNG format  

    [lefic] = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
    fprintf('Processed file %s\n',lefic);
    im_dark = imread( lefic );

    if para_disp.flag_display
        para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
        fig_ref = para_disp.tab_fig(para_disp.cpt_fig);
        para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_pos,:));
        imagesc(im_dark); colormap gray; hold on;
        title(sprintf('image %s darkened',im_name_in));
        axis equal
    end
    im = im_dark;
else
    % % image file
    im = imread(filename_in);
end
SZ = size(im);

%% Image bouding box
BB = get_1_BoundingBox(im_msk);
x_min = BB(1); x_max = BB(2); y_min = BB(3); y_max = BB(4);

if para_disp.flag_display
    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    fig_ref = para_disp.tab_fig(para_disp.cpt_fig);
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_pos,:));
    imagesc(im); colormap gray; hold on;
    title(sprintf('image %s',im_name_in));
    axis equal
    %pause(0.5);
    if para_disp.flag_detail
        border_msk = bwboundaries(im_msk);
        border_msk = [border_msk{1}(:,2) , border_msk{1}(:,1)];
        plot( border_msk(:,1) , border_msk(:,2) , 'b-' );
        plot( [x_min-1 x_min-1] , [y_min-1 y_max+1] , 'b-' );
        plot( [x_max+1 x_max+1] , [y_min-1 y_max+1] , 'b-' );
    end
end

%% Cropping the image

% Cropping the image
im_ZOI      = im( BB(3):BB(4) , BB(1):BB(2) , : );
im_msk_ZOI  = im_msk( BB(3):BB(4) , BB(1):BB(2) , : );


%% VEssel extraction

M = 256;
im_grey_ZOI = rgb2gray(double(im_ZOI)/(M-1))*(M-1);

[map_vessel_detector_ZOI, map_vessel_detector_norm_ZOI, mu, th, im_ang_or_detector_ZOI , msk_vessels_ZOI , para_disp ] = ...
    DR_VES_map_bump_detector( im_grey_ZOI , im_msk_ZOI , M , coeff_D1 , coeff_D2 , D , para_disp );



[ Dx, Dy , xx , yy , alpha ] = DR_VES_map_vesselness_with_orientations( ...
    map_vessel_detector_ZOI, mu , im_ang_or_detector_ZOI , im_msk_ZOI , msk_vessels_ZOI  );

if para_disp.flag_display
    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_pos,:));
    imagesc( map_vessel_detector_ZOI ); axis equal;  hold on; title(sprintf('Map of bumb detectors with orientations'));
    quiver( xx(msk_vessels_ZOI) , yy(msk_vessels_ZOI) , Dx(msk_vessels_ZOI) , Dy(msk_vessels_ZOI) , 0 , 'r' );
end



%% Go back to the original image size
map_vessel_detector = zeros(SZ(1:2),'like',map_vessel_detector_ZOI);
map_vessel_detector( BB(3):BB(4) , BB(1):BB(2) , : ) = map_vessel_detector_ZOI;
map_vessel_detector_norm = zeros(SZ(1:2),'like',map_vessel_detector_norm_ZOI);
map_vessel_detector_norm( BB(3):BB(4) , BB(1):BB(2) , : ) = map_vessel_detector_norm_ZOI;
im_ang_or_detector = zeros(SZ(1:2),'like',im_ang_or_detector_ZOI);
im_ang_or_detector( BB(3):BB(4) , BB(1):BB(2) , : ) = im_ang_or_detector_ZOI;
msk_vessels = false(SZ(1:2));
msk_vessels( BB(3):BB(4) , BB(1):BB(2) , : ) = msk_vessels_ZOI;

s_ves.map_vessel_detector       = map_vessel_detector;
s_ves.map_vessel_detector_norm  = map_vessel_detector_norm;
s_ves.map_or_DEG                = im_ang_or_detector;
s_ves.msk_vessels               = msk_vessels;
s_ves.mu                        = mu;
s_ves.th                        = th;
s_ves.alpha                     = alpha;
s_ves.Dx                        = Dx;
s_ves.Dy                        = Dy;

if para_disp.flag_display
    % Superposition des résultats sur l'image à ndg
    figure(fig_ref);
    border_vessels = bwboundaries(msk_vessels);
    for n=1:length(border_vessels)
       bv_ij = border_vessels{n};
       plot( bv_ij(:,2) , bv_ij(:,1), 'w-' );
    end
end

%% Saving results

kfile = 510; % vessels_mask (LIP-Morpho Math)    
[lefic] = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
ajout_dossier(lefic);
imwrite( msk_vessels , lefic );
fprintf('<------------------- Saved : %s\n',lefic);

kfile = 511; % Vesselness (LIP-Morpho Math)    
[lefic] = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
save( lefic , 's_ves' );
fprintf('<------------------- Saved : %s\n',lefic);

if para_disp.flag_save_final_display
    im_col_out = ajout_frontiere( im , msk_vessels , [255 255 255]);
    kfile = 512; % Image with the border of the vessels (LIP-Morpho Math) 
    [lefic] = DR_GEN_files_name( kprob, kpack, kfile, filename_in);
    imwrite( im_col_out , lefic );
    fprintf('<------------------- Saved : %s\n',lefic);
    
    
    % Choose parameters (line width, font size, picture size, etc.)
    width = 4;     % Width in cm
    height = 4;    % Height in cm
    %alw = 1;    % AxesLineWidth
    %fsz = 25;      % Fontsize
    lw =  3;         % LineWidth
    msz = 8;       % MarkerSize
    FontName_val = 'Times New Roman';
    %factor_smaller_fonts = 0.7;
    %LabelFontSizeMultiplier_val = 1/factor_smaller_fonts;

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
    %close(gcf);
    
    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    fig_vesselness = para_disp.tab_fig(para_disp.cpt_fig);
    para_disp.cpt_pos = para_disp.cpt_pos + 1;
    %fig_vesselness = figure;
    Image_map_vessel_detector = imagesc( map_vessel_detector_ZOI ); axis equal;  hold on; title(sprintf('Map of bumb detectors with orientations'));
    quiver( xx(msk_vessels_ZOI) , yy(msk_vessels_ZOI) , Dx(msk_vessels_ZOI) , Dy(msk_vessels_ZOI) , 0 , 'r' );
    set(gca_fig(fig_vesselness),'Visible','off')
    
    kfile = 513; % Figure vesselness (LIP-Morpho Math) 
    [lefic] = DR_GEN_files_name( kprob, kpack, kfile, filename_in);
    savefig( fig_vesselness , lefic , 'compact' );
    fprintf('<------------------- Saved : %s\n',lefic);   
    
%     kfile = 514; % Figure vesselness (LIP-Morpho Math) - svg
%     [lefic] = DR_GEN_files_name( kprob, kpack, kfile, filename_in);
%     saveas( fig_vesselness , lefic );
%     fprintf('<------------------- Saved : %s\n',lefic);   
    
    kfile = 515; % Figure vesselness (LIP-Morpho Math) - png
    [lefic] = DR_GEN_files_name( kprob, kpack, kfile, filename_in);
    saveas( fig_vesselness , lefic );
    fprintf('<------------------- Saved : %s\n',lefic);    
    %pause(1);
    
    kfile = 515; % Figure vesselness (LIP-Morpho Math) - png
    [lefic] = DR_GEN_files_name( kprob, kpack, kfile, filename_in);
    imwrite( ImageObject_to_RGB( Image_map_vessel_detector , [] , colormap('parula') ) , lefic );
    fprintf('<------------------- Saved : %s\n',lefic);    
    
    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf; hold on
    fig_vesselness_norm = para_disp.tab_fig(para_disp.cpt_fig);
    set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_fig,:));
    Image_map_vessel_detector_norm = imagesc( map_vessel_detector_norm ); axis equal; title('normed Vesselness'); %colormap gray

    kfile = 516; % Figure vesselness normalised (LIP-Morpho Math) - png            
    [lefic] = DR_GEN_files_name( kprob, kpack, kfile, filename_in);
    imwrite( ImageObject_to_RGB( Image_map_vessel_detector_norm , [] , colormap('parula') )  , lefic );
    fprintf('<------------------- Saved : %s\n',lefic);   

    kfile = 517; % Image vesselness (LIP-Morpho Math) - png
    [lefic] = DR_GEN_files_name( kprob, kpack, kfile, filename_in);
    imwrite( ImageObject_to_RGB( Image_map_vessel_detector , [] , colormap('parula') ) , lefic );
    fprintf('<------------------- Saved : %s\n',lefic);    
    
    close(fig_vesselness,fig_vesselness_norm);
end

if para_disp.flag_display
   pause;
   close all;
end


%% Error management
catch ME
    disp(ME.message);
end
