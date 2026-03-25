%Script_LIP_morpho_monstre.m
% Guillaume NOYEL
% 14/12/2021

close all; clearvars;


oldpath = addpath('Function_sources');


flag_display = true;

%% Flags for the different parts to be run



flag(9) = true;  % Nessie

%% Paths

% [~,racine_filename] = fileparts(mfilename);
dossier = 'im';
folder_out = 'Res/Monstre';
ajout_dossier_depuis_nom_dossier(folder_out);

filename_in_9_1   = fullfile(dossier,'Nessie_40ms.JPG'); % Nessie bright
filename_in_9_2   = fullfile(dossier,'Nessie_400ms.JPG'); % Nessie dark 400
filename_in_9_3   = fullfile(dossier,'Nessie_800ms.JPG'); % Nessie dark 800


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

%% LIP model
M =  256;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Test 9 Nessie
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag(9)
    flag_write_results = false;%false;%true;
    %% Reading the image
    filename_bright = filename_in_9_1;
    filename_dark   = filename_in_9_3;
    im_col_bright   = imread(filename_bright);
    
    if flag_display
       figure;
       imagesc(im_col_bright); axis equal;
       pos_rect = [960 519 3351 2543]; BB = [pos_rect(1:2) pos_rect(1)+pos_rect(3) pos_rect(2)+pos_rect(4)];
       h = imrect(gca,pos_rect);
       title('ROI');
    end
    
    im_col_bright   = im_col_bright( BB(2):BB(4) , BB(1):BB(3) , : );
    im_col_bright   = imresize(im_col_bright,1024/size(im_col_bright,2));
    
    im_col_dark     = imread(filename_dark);
    im_col_dark     = im_col_dark( BB(2):BB(4) , BB(1):BB(3) , : );
    im_col_dark     = imresize(im_col_dark,1024/size(im_col_dark,2));
    
    % conversion to grey-level
    im_bright       = rgb2gray(im_col_bright);
    im_dark         = rgb2gray(im_col_dark);
    imb_c           = LIP_imcomplement( im_bright , M );
    imd_c           = LIP_imcomplement( im_dark , M );
    
    
    if flag_write_results
        [~,root_fname]  = fileparts(filename_bright);
        fname_out       = fullfile(folder_out,sprintf('%s_bright.png',root_fname));
        imwrite(im_bright,fname_out);
        fname_out       = fullfile(folder_out,sprintf('%s_bright_comp.png',root_fname));
        imwrite(imb_c,fname_out);
        fname_out       = fullfile(folder_out,sprintf('%s_bright_col.png',root_fname));
        imwrite(im_col_bright,fname_out);

        [~,root_fname]  = fileparts(filename_dark);
        fname_out       = fullfile(folder_out,sprintf('%s_dark.png',root_fname));
        imwrite(im_dark,fname_out);
        fname_out       = fullfile(folder_out,sprintf('%s_dark_comp.png',root_fname));
        imwrite(imd_c,fname_out);
        fname_out       = fullfile(folder_out,sprintf('%s_dark_col.png',root_fname));
        imwrite(im_col_dark,fname_out);
    end
    
    ct_1 = LIP_imsubtract( mean2(imd_c) , mean2(imb_c) , M );
    
    if flag_display
        figure();
        subplot(2,2,1)
        imagesc(im_bright); colormap gray; axis equal
        title('Input image (bright)')
        caxis([0 M-1])
        
        subplot(2,2,2)
        imagesc(imb_c); colormap gray; axis equal
        title('Input image complement (bright)')
        caxis([0 M-1])
        
        subplot(2,2,3)
        imagesc(im_dark); colormap gray; axis equal
        title('Input image (dark)')
        caxis([0 M-1])
        
        subplot(2,2,4)
        imagesc(imd_c); colormap gray; axis equal
        title('Input image complement (dark)')
        caxis([0 M-1])
    end
    
    imb_c = double(imb_c);
    imd_c = double(imd_c);
    %% Building a structuring element
    radius  = 3;%16;
    se1     = strel('disk',radius,0);
    msk1    = se1.getnhood;
    msk_in  = msk1;
    msk_se  = msk_in;
    SZ_se   = size(msk_se);
    

    centre_se = get_strel_centre(se1);
    [x_grid,y_grid] = meshgrid((1:SZ_se(1))-centre_se(1),(1:SZ_se(2))-centre_se(2));
    shift_height_se = round(M/2);
    im_se_ball = -sqrt(radius.^2 - (x_grid.^2+y_grid.^2)) + shift_height_se;
    im_se_ball(~msk1) = 0;     
    
    se = strel('arbitrary',msk_se);
    se_c = LIP_strel_imcomplement(se,M);
    shift_height_se_c = LIP_imcomplement(shift_height_se,M);
    
    if flag_display
       figure;
       imagesc(se.getheight()); axis equal; %colormap gray
       title('Se function')
       
       figure
       im_se = se.getheight();
       im_se(~se.Neighborhood) = NaN;
       surf(im_se); %axis equal
       title('Se function')
       set(gca,'Ydir','reverse');
       
       fig_se_c = figure;
       im_se = se_c.getheight();
       im_se(~se_c.Neighborhood) = NaN;
       surf(im_se); axis equal
       title('');%title('Se function (LIP-scale)')
       set(gca,'Ydir','reverse');
       gca_fig_se_c = gca_fig(fig_se_c);
       gca_fig_se_c.FontSize = fsz;
       gca_fig_se_c.FontName = 'Times New Roman';
    end
    
    if flag_write_results
        [~,root_fname]  = fileparts(filename_bright);
        fname_out       = fullfile(folder_out,sprintf('%s_se_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(se.getheight()),fname_out);
        
        fname_out       = fullfile(folder_out,sprintf('%s_surf_se_comp_radius_%d_height_%d.fig',root_fname,radius,shift_height_se_c));
        savefig(fig_se_c,fname_out,'compact');
        fname_out       = fullfile(folder_out,sprintf('%s_surf_se_comp_radius_%d_height_%d.svg',root_fname,radius,shift_height_se_c));
        saveas(fig_se_c,fname_out);
    end
    
    im2b_ero_c = imerode(imb_c , se_c);
    im2b_dil_c = imdilate(imb_c , se_c);
    im2b_LIP_ero_c = LIP_imerode(imb_c , se_c , M);
    im2b_LIP_dil_c = LIP_imdilate(imb_c , se_c , M);
    
    
    im2d_ero_c = imerode(imd_c , se_c);
    im2d_dil_c = imdilate(imd_c , se_c);
    im2d_LIP_ero_c = LIP_imerode(imd_c , se_c , M);
    im2d_LIP_dil_c = LIP_imdilate(imd_c , se_c , M);    
    
    
    
    se_c_neg = strel_imneg( se_c );
    im2b_dil_c_se_trsp = imdilate( imb_c , se_c_neg.reflect() );
    im2d_dil_c_se_trsp = imdilate( imd_c , se_c_neg.reflect() );    
    se_c_Lneg = LIP_strel_imneg( se_c , M );
    im2b_LIP_dil_c_se_trsp = LIP_imdilate( imb_c , se_c_Lneg.reflect() , M );
    im2d_LIP_dil_c_se_trsp = LIP_imdilate( imd_c , se_c_Lneg.reflect() , M);    
    
    if flag_display
        figure();
        subplot(2,2,1)
        imagesc(im2b_ero_c); colormap gray; axis equal
        title('Erosion (bright image)')
        caxis([0 M-1])
        
        subplot(2,2,2)
        imagesc(im2d_ero_c); colormap gray; axis equal
        title('Erosion (dark image)')
        caxis([0 M-1])
        
        subplot(2,2,3)
        imagesc(im2b_LIP_ero_c); colormap gray; axis equal
        title('Logarithmic-Erosion (bright image)')
        caxis([0 M-1])
        
        subplot(2,2,4)
        imagesc(im2d_LIP_ero_c); colormap gray; axis equal
        title('Logarithmic-Erosion (dark image)')
        caxis([0 M-1])
        
        
        figure();
        subplot(4,2,1)
        imagesc(im2b_dil_c); colormap gray; axis equal
        title('Dilation (bright image)')
        caxis([0 M-1])
        
        subplot(4,2,2)
        imagesc(im2d_dil_c); colormap gray; axis equal
        title('Dilation (dark image)')
        caxis([0 M-1])
        
        subplot(4,2,3)
        imagesc(im2b_dil_c_se_trsp); colormap gray; axis equal
        title('Dilation trsp (bright image)')
        caxis([0 M-1])
        
        subplot(4,2,4)
        imagesc(im2d_dil_c_se_trsp); colormap gray; axis equal
        title('Dilation trsp (dark image)')
        caxis([0 M-1])        
        
        subplot(4,2,5)
        imagesc(im2b_LIP_dil_c); colormap gray; axis equal
        title('Logarithmic-Dilation (bright image)')
        caxis([0 M-1])
        
        subplot(4,2,6)
        imagesc(im2d_LIP_dil_c); colormap gray; axis equal
        title('Logarithmic-Dilation (dark image)')
        caxis([0 M-1])
        
        subplot(4,2,7)
        imagesc(im2d_LIP_dil_c_se_trsp); colormap gray; axis equal
        title('Logarithmic-Dilation trsp (bright image)')
        caxis([0 M-1])        
        
        subplot(4,2,8)
        imagesc(im2d_LIP_dil_c_se_trsp); colormap gray; axis equal
        title('Logarithmic-Dilation trsp (dark image)')
        caxis([0 M-1])
        
    end
    
   % gradient
    im3b_grad = im2b_dil_c - im2b_ero_c;
    im3b_grad_LIP = LIP_imsubtract( im2b_dil_c , im2b_ero_c , M );
    im3b_LIP_grad_a = LIP_imsubtract( im2b_LIP_dil_c , im2b_LIP_ero_c , M );
    
    im3d_grad = im2d_dil_c - im2d_ero_c;
    im3d_grad_LIP = LIP_imsubtract( im2d_dil_c , im2d_ero_c , M );
    im3d_LIP_grad_a = LIP_imsubtract( im2d_LIP_dil_c , im2d_LIP_ero_c , M );    
    
    
    if flag_display
        figure();
        subplot(2,2,1)
        imagesc(im3b_grad); colormap gray; axis equal
        title('Gradient (bright image)')
        %caxis([min(im3b_grad(:)) max(im3b_grad(:))]);
        
        subplot(2,2,2)
        imagesc(im3d_grad); colormap gray; axis equal
        title('Gradient (dark image)')
        %caxis([min(im3b_grad(:)) max(im3b_grad(:))]);
        
        subplot(2,2,3)
        imagesc(im3b_LIP_grad_a); colormap gray; axis equal
        title('Logarithmic-gradient (bright image)')
        %caxis([min(im3b_LIP_grad_a(:)) M-1]);
        
        subplot(2,2,4)
        imagesc(im3d_LIP_grad_a); colormap gray; axis equal
        title('Logarithmic-gradient (dark image)')
        %caxis([min(im3b_LIP_grad_a(:)) M-1]);
        
        figure();
        subplot(2,2,1)
        imhist(stretchimageTo(im3b_grad,[0 1]),255); 
        title('Histo Gradient (bright image)')
        %caxis([min(im3b_grad(:)) max(im3b_grad(:))]);
        
        subplot(2,2,3)
        imhist(stretchimageTo(im3b_LIP_grad_a,[0 1]),255);
        title('Histo Logarithmic-gradient (bright image)')
        %caxis([min(im3b_LIP_grad_a(:)) M-1]);
        
        subplot(2,2,2)
        imhist(stretchimageTo(im3d_grad,[0 1]),255); 
        title('Histo Gradient (dark image)')
        %caxis([min(im3b_grad(:)) max(im3b_grad(:))]);
        
        subplot(2,2,4)
        imhist(stretchimageTo(im3d_LIP_grad_a,[0 1]),255); 
        title('Histo Logarithmic-gradient (dark image)')
    end    
    
    
    %% Map of LIP-additive Asplund distances

    im3b_addAspl = im2b_dil_c_se_trsp - im2b_ero_c ;
    fprintf('im3b_addAspl \t min = %d \t max = %d\n',min2(im3b_addAspl),max2(im3b_addAspl));
    im3d_addAspl = im2d_dil_c_se_trsp - im2d_ero_c ;
    fprintf('im3d_addAspl \t min = %d \t max = %d\n',min2(im3d_addAspl),max2(im3d_addAspl));
    
    im3b_LIPaddAspl = LIP_imsubtract( im2b_LIP_dil_c_se_trsp , im2b_LIP_ero_c , M );
    fprintf('im3b_LIPaddAspl \t min = %d \t max = %d\n',min2(im3b_LIPaddAspl),max2(im3b_LIPaddAspl));
    im3d_LIPaddAspl = LIP_imsubtract( im2d_LIP_dil_c_se_trsp , im2d_LIP_ero_c , M );
    fprintf('im3b_LIPaddAspl \t min = %d \t max = %d\n',min2(im3d_LIPaddAspl),max2(im3d_LIPaddAspl));
    
    if flag_display
        figure();
        subplot(2,2,1)
        image(im3b_addAspl); colormap gray; axis equal; caxis([0 M-1]);
        title('add Asplund dist (bright image)')
        
        subplot(2,2,2)
        image(im3d_addAspl); colormap gray; axis equal; caxis([0 M-1]);
        title('add Asplund dist (dark image)')
        
        subplot(2,2,3)
        image(im3b_LIPaddAspl); colormap gray; axis equal; caxis([0 M-1]);
        title('LIP-add Asplund dist (bright image)')
        
        subplot(2,2,4)
        image(im3d_LIPaddAspl); colormap gray; axis equal; caxis([0 M-1]);
        title('LIP-add Asplund dist (dark image)')
    end
    
    
    
    if flag_write_results
        [~,root_fname] = fileparts(filename_bright);
        fname_out = fullfile(folder_out,sprintf('%s_addAsplDist_radius_%d_height_%d.mat',root_fname,radius,shift_height_se_c));
        save(fname_out,'im3b_addAspl');
        fname_out = fullfile(folder_out,sprintf('%s_addAsplDist_radius_%d_height_%d.png',root_fname,radius,shift_height_se_c));
        imwrite(uint8(im3b_addAspl),fname_out);
        fname_out = fullfile(folder_out,sprintf('%s_LIPaddAsplDist_radius_%d_height_%d.mat',root_fname,radius,shift_height_se_c));
        save(fname_out,'im3b_LIPaddAspl');
        fname_out = fullfile(folder_out,sprintf('%s_LIPaddAsplDist_radius_%d_height_%d.png',root_fname,radius,shift_height_se_c));
        imwrite(uint8(im3b_LIPaddAspl),fname_out);
        
        
        [~,root_fname] = fileparts(filename_dark);
        fname_out = fullfile(folder_out,sprintf('%s_addAsplDist_radius_%d_height_%d.mat',root_fname,radius,shift_height_se_c));
        save(fname_out,'im3d_addAspl');
        fname_out = fullfile(folder_out,sprintf('%s_addAsplDist_radius_%d_height_%d.png',root_fname,radius,shift_height_se_c));
        imwrite(uint8(im3d_addAspl),fname_out);
        fname_out = fullfile(folder_out,sprintf('%s_LIPaddAsplDist_radius_%d_height_%d.mat',root_fname,radius,shift_height_se_c));
        save(fname_out,'im3d_LIPaddAspl');
        fname_out = fullfile(folder_out,sprintf('%s_LIPaddAsplDist_radius_%d_height_%d.png',root_fname,radius,shift_height_se_c));
        imwrite(uint8(im3d_LIPaddAspl),fname_out);      
    end    
    
    
     %% Opening closing
     
    %% Building a structuring element
    radius  = 16;
    se1     = strel('disk',radius,0);
    msk1    = se1.getnhood;

    msk_in  = msk1;
    msk_se  = msk_in;
    SZ_se   = size(msk_se);
    
   
    centre_se = get_strel_centre(se1);
    [x_grid,y_grid] = meshgrid((1:SZ_se(1))-centre_se(1),(1:SZ_se(2))-centre_se(2));
    shift_height_se = round(M/2);
    im_se_ball = -sqrt(radius.^2 - (x_grid.^2+y_grid.^2)) + shift_height_se;

    im_se_ball(~msk1) = 0;     
    
    se = strel('arbitrary',msk_se,im_se_ball);
    se_c = LIP_strel_imcomplement(se,M);
    
    if flag_display
       figure;
       imagesc(se.getheight()); axis equal; %colormap gray
       title('Se function')
       
       figure
       im_se = se.getheight();
       im_se(~se.Neighborhood) = NaN;
       surf(im_se); %axis equal
       title('Se function')
       set(gca,'Ydir','reverse');
       
       fig_se_c = figure;
       im_se = se_c.getheight();
       im_se(~se_c.Neighborhood) = NaN;
       surf(im_se); axis equal
       title('');%title('Se function (LIP-scale)')
       set(gca,'Ydir','reverse');
       gca_fig_se_c = gca_fig(fig_se_c);
       gca_fig_se_c.FontSize = fsz;
       gca_fig_se_c.FontName = 'Times New Roman';
    end
    
    if flag_write_results
        [~,root_fname]  = fileparts(filename_bright);
        fname_out       = fullfile(folder_out,sprintf('%s_se_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(se.getheight()),fname_out);
        
        fname_out       = fullfile(folder_out,sprintf('%s_surf_se_comp_radius_%d_height_%d.fig',root_fname,radius,shift_height_se));
        savefig(fig_se_c,fname_out,'compact');
        fname_out       = fullfile(folder_out,sprintf('%s_surf_se_comp_radius_%d_height_%d.svg',root_fname,radius,shift_height_se));
        saveas(fig_se_c,fname_out);
    end
     
    im4b_open_c  = imopen(imb_c , se_c);                        im4b_open  = LIP_imcomplement(im4b_open_c,M);
    im4b_top_hat_c = imb_c - im4b_open_c;
    im4b_close_c = imclose(imb_c , se_c);                       im4b_close = LIP_imcomplement(im4b_close_c,M);
    im4b_bot_hat_c = im4b_close_c - imb_c;
    im4b_LIP_open_c  = LIP_imopen(imb_c , se_c , M);            im4b_LIP_open  = LIP_imcomplement(im4b_LIP_open_c,M);
    im4b_LIP_top_hat_c = LIP_imsubtract( imb_c , im4b_LIP_open_c , M);
    im4b_LIP_close_c = LIP_imclose(imb_c , se_c , M);           im4b_LIP_close = LIP_imcomplement(im4b_LIP_close_c,M);
    im4b_LIP_bot_hat_c = LIP_imsubtract( im4b_LIP_close_c , imb_c , M);
    
    im4d_open_c  = imopen(imd_c , se_c);                        im4d_open  = LIP_imcomplement(im4d_open_c,M);
    im4d_top_hat_c = imd_c - im4d_open_c;
    im4d_close_c = imclose(imd_c , se_c);                       im4d_close = LIP_imcomplement(im4d_close_c,M);
    im4d_bot_hat_c = im4d_close_c - imd_c;
    im4d_LIP_open_c  = LIP_imopen(imd_c , se_c , M);            im4d_LIP_open  = LIP_imcomplement(im4d_LIP_open_c,M);
    im4d_LIP_top_hat_c = LIP_imsubtract( imd_c , im4d_LIP_open_c , M);
    im4d_LIP_close_c = LIP_imclose(imd_c , se_c , M);           im4d_LIP_close = LIP_imcomplement(im4d_LIP_close_c,M);
    im4d_LIP_bot_hat_c = LIP_imsubtract( im4d_LIP_close_c , imd_c , M);
    
    %% Ajouter le Top-hat  et regarder l'échelle de représentation -----------------------------------------------------------------
    
    if flag_display
        figure();
        subplot(2,2,1)
        imagesc(im4b_open_c); colormap gray; axis equal
        title('Opening (bright) comp')
        
        subplot(2,2,2)
        imagesc(im4d_open_c); colormap gray; axis equal
        title('Opening (dark)  comp')
        
        subplot(2,2,3)
        imagesc(im4b_LIP_open_c); colormap gray; axis equal
        title('Logarithmic-Opening (bright)  comp')
        
        subplot(2,2,4)
        imagesc(im4d_LIP_open_c); colormap gray; axis equal
        title('Logarithmic-Opening (dark)  comp')

        figure();
        subplot(2,2,1)
        imagesc(im4b_open); colormap gray; axis equal
        title('Opening (bright)')
        
        subplot(2,2,2)
        imagesc(im4d_open); colormap gray; axis equal
        title('Opening (dark)')
        
        subplot(2,2,3)
        imagesc(im4b_LIP_open); colormap gray; axis equal
        title('Logarithmic-Opening (bright)')
        
        subplot(2,2,4)
        imagesc(im4d_LIP_open); colormap gray; axis equal
        title('Logarithmic-Opening (dark)')
                
       
        
        figure();
        subplot(2,2,1)
        imshow(uint8(im4b_top_hat_c)); colormap gray; axis equal
        title('Top-hat (bright) comp')
        fprintf('im4b_top_hat_c \t min = %d \t max = %d\n',min(im4b_top_hat_c(:)) , max(im4b_top_hat_c(:)));
        
        subplot(2,2,2)
        imshow(uint8(im4d_top_hat_c)); colormap gray; axis equal
        title('Top-hat (dark) comp')
        pos_rect = [719 1 305 320]; BB_4d = [pos_rect(1:2) pos_rect(1)+pos_rect(3) pos_rect(2)+pos_rect(4)];
        imrect(gca,pos_rect);
        fprintf('im4d_top_hat_c \t min = %d \t max = %d\n',min(im4d_top_hat_c(:)) , max(im4d_top_hat_c(:)));
        
        subplot(2,2,3)
        imshow(uint8(im4b_LIP_top_hat_c)); colormap gray; axis equal
        title('Logarithmic-Top-hat (bright) comp')
        fprintf('im4b_LIP_top_hat_c \t min = %d \t max = %d\n',min(im4b_LIP_top_hat_c(:)) , max(im4b_LIP_top_hat_c(:)));
        
        subplot(2,2,4)
        imshow(uint8(im4d_LIP_top_hat_c)); colormap gray; axis equal
        title('Logarithmic-Top-hat (dark) comp')
        fprintf('im4d_LIP_top_hat_c \t min = %d \t max = %d\n',min(im4d_LIP_top_hat_c(:)) , max(im4d_LIP_top_hat_c(:)));
        
        
        figure();
        subplot(2,2,1)
        imhist(uint8(im4b_top_hat_c),255); 
        title('Histo Top-hat (bright image)')
        %caxis([min(im3b_grad(:)) max(im3b_grad(:))]);
        
        subplot(2,2,2)
        imhist(uint8(im4d_top_hat_c),255);
        title('Histo Top-hat (dark image)')
        %caxis([min(im3b_LIP_grad_a(:)) M-1]);
        
        subplot(2,2,3)
        imhist(uint8(im4b_LIP_top_hat_c),255); 
        title('Histo LIP-Top-hat (bright image)')
        %caxis([min(im3b_grad(:)) max(im3b_grad(:))]);
        
        subplot(2,2,4)
        imhist(uint8(im4d_LIP_top_hat_c),255); 
        title('Histo LIP-Top-hat (dark image)')
        

        fig_im4d_top_hat_c_ROI_back = figure;
        image(uint8(im4d_top_hat_c)); colormap gray; axis equal        
        %title('Top-hat (dark) comp')
        pos_rect = [719 1 305 320]; BB_4d = [pos_rect(1:2) pos_rect(1)+pos_rect(3) pos_rect(2)+pos_rect(4)];
        %imrect(gca,pos_rect);
        h = rectangle(gca_fig(fig_im4d_top_hat_c_ROI_back),'Position',pos_rect,'LineStyle','--','EdgeColor',graphicR,'LineWidth',lw,'FaceColor','none');
        box off; axis off; title('');
        set(gca_fig(fig_im4d_top_hat_c_ROI_back), 'defaultFigurePaperPosition', defsize);
        
        figure
        im4d_top_hat_c_ROI_back = im4d_top_hat_c( BB_4d(2):BB_4d(4) , BB_4d(1):BB_4d(3) );
        imagesc(im4d_top_hat_c_ROI_back); colormap gray; axis equal
        title('Top-hat (dark) background comp')
        
        
        
        figure();
        subplot(2,2,1)
        imagesc(im4b_close_c); colormap gray; axis equal
        title('Closing (bright) comp')
        
        subplot(2,2,2)
        imagesc(im4d_close_c); colormap gray; axis equal
        title('Closing (dark) comp')
        
        subplot(2,2,3)
        imagesc(im4b_LIP_close_c); colormap gray; axis equal
        title('Logarithmic-Closing (bright) comp')
        
        subplot(2,2,4)
        imagesc(im4d_LIP_close_c); colormap gray; axis equal
        title('Logarithmic-Closing (dark) comp')
        
        figure();
        subplot(2,2,1)
        imagesc(im4b_close); colormap gray; axis equal
        title('Closing (bright)')
        
        subplot(2,2,2)
        imagesc(im4d_close); colormap gray; axis equal
        title('Closing (dark)')
        
        subplot(2,2,3)
        imagesc(im4b_LIP_close); colormap gray; axis equal
        title('Logarithmic-Closing (bright)')
        
        subplot(2,2,4)
        imagesc(im4d_LIP_close); colormap gray; axis equal
        title('Logarithmic-Closing (dark)')        

        
        figure();
        subplot(2,2,1)
        imshow(uint8(im4b_bot_hat_c)); colormap gray; axis equal
        title('Bottom-hat (bright) comp')
        
        subplot(2,2,2)
        imshow(uint8(im4d_bot_hat_c)); colormap gray; axis equal
        title('Bottom-hat (dark) comp')
        
        subplot(2,2,3)
        imshow(uint8(im4b_LIP_bot_hat_c)); colormap gray; axis equal
        title('Logarithmic-Bottom-hat (bright) comp')
        
        subplot(2,2,4)
        imshow(uint8(im4d_LIP_bot_hat_c)); colormap gray; axis equal
        title('Logarithmic-Bottom-hat (dark) comp')
        
    end
    
    if flag_write_results
        % Classical greyscale
        [~,root_fname] = fileparts(filename_bright);
        fname_out = fullfile(folder_out,sprintf('%s_open_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4b_open');
        fname_out = fullfile(folder_out,sprintf('%s_open_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(im4b_open),fname_out);
        fname_out = fullfile(folder_out,sprintf('%s_LIP_open_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4b_LIP_open');
        fname_out = fullfile(folder_out,sprintf('%s_LIP_open_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(im4b_LIP_open),fname_out);
        
        fname_out = fullfile(folder_out,sprintf('%s_close_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4b_close');
        fname_out = fullfile(folder_out,sprintf('%s_close_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(im4b_close),fname_out);
        fname_out = fullfile(folder_out,sprintf('%s_LIP_close_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4b_LIP_close');
        fname_out = fullfile(folder_out,sprintf('%s_LIP_close_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(im4b_LIP_close),fname_out);
        
        
        [~,root_fname] = fileparts(filename_dark);
        fname_out = fullfile(folder_out,sprintf('%s_open_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4d_open');
        fname_out = fullfile(folder_out,sprintf('%s_open_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(im4d_open),fname_out);
        fname_out = fullfile(folder_out,sprintf('%s_LIP_open_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4d_LIP_open');
        fname_out = fullfile(folder_out,sprintf('%s_LIP_open_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(im4d_LIP_open),fname_out);  
        
        [~,root_fname] = fileparts(filename_dark);
        fname_out = fullfile(folder_out,sprintf('%s_close_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4d_close');
        fname_out = fullfile(folder_out,sprintf('%s_close_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(im4d_close),fname_out);
        fname_out = fullfile(folder_out,sprintf('%s_LIP_close_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4d_LIP_close');
        fname_out = fullfile(folder_out,sprintf('%s_LIP_close_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(im4d_LIP_close),fname_out);
        
        
        % LIP scale
        [~,root_fname] = fileparts(filename_bright);
        fname_out = fullfile(folder_out,sprintf('%s_open_comp_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4b_open_c');
        fname_out = fullfile(folder_out,sprintf('%s_open_comp_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(im4b_open_c),fname_out);
        fname_out = fullfile(folder_out,sprintf('%s_LIP_open_comp_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4b_LIP_open_c');
        fname_out = fullfile(folder_out,sprintf('%s_LIP_open_comp_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(im4b_LIP_open_c),fname_out);
        
        fname_out = fullfile(folder_out,sprintf('%s_close_comp_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4b_close_c');
        fname_out = fullfile(folder_out,sprintf('%s_close_comp_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(im4b_close_c),fname_out);
        fname_out = fullfile(folder_out,sprintf('%s_LIP_close_comp_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4b_LIP_close_c');
        fname_out = fullfile(folder_out,sprintf('%s_LIP_close_comp_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(im4b_LIP_close_c),fname_out);
        
        
        [~,root_fname] = fileparts(filename_dark);
        fname_out = fullfile(folder_out,sprintf('%s_open_comp_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4d_open_c');
        fname_out = fullfile(folder_out,sprintf('%s_open_comp_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(im4d_open_c),fname_out);
        fname_out = fullfile(folder_out,sprintf('%s_LIP_open_comp_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4d_LIP_open_c');
        fname_out = fullfile(folder_out,sprintf('%s_LIP_open_comp_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(im4d_LIP_open_c),fname_out);  
        
        [~,root_fname] = fileparts(filename_dark);
        fname_out = fullfile(folder_out,sprintf('%s_close_comp_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4d_close_c');
        fname_out = fullfile(folder_out,sprintf('%s_close_comp_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(im4d_close_c),fname_out);
        fname_out = fullfile(folder_out,sprintf('%s_LIP_close_comp_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4d_LIP_close_c');
        fname_out = fullfile(folder_out,sprintf('%s_LIP_close_comp_radius_%d.png',root_fname,radius));
        imwrite(stretchimage(im4d_LIP_close_c),fname_out);
        
        % Top-hats and bottom-hats
        [~,root_fname] = fileparts(filename_bright);
        fname_out = fullfile(folder_out,sprintf('%s_top_hat_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4b_top_hat_c');
        fname_out = fullfile(folder_out,sprintf('%s_top_hat_radius_%d.png',root_fname,radius));
        imwrite(uint8(im4b_top_hat_c),fname_out);
        fname_out = fullfile(folder_out,sprintf('%s_LIP_top_hat_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4b_LIP_top_hat_c');
        fname_out = fullfile(folder_out,sprintf('%s_LIP_top_hat_radius_%d.png',root_fname,radius));
        imwrite(uint8(im4b_LIP_top_hat_c),fname_out);
        
        fname_out = fullfile(folder_out,sprintf('%s_bot_hat_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4b_bot_hat_c');
        fname_out = fullfile(folder_out,sprintf('%s_bot_hat_radius_%d.png',root_fname,radius));
        imwrite(uint8(im4b_bot_hat_c),fname_out);
        fname_out = fullfile(folder_out,sprintf('%s_LIP_bot_hat_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4b_LIP_bot_hat_c');
        fname_out = fullfile(folder_out,sprintf('%s_LIP_bot_hat_radius_%d.png',root_fname,radius));
        imwrite(uint8(im4b_LIP_bot_hat_c),fname_out);
        
        
        [~,root_fname] = fileparts(filename_dark);
        fname_out = fullfile(folder_out,sprintf('%s_top_hat_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4d_top_hat_c');
        fname_out = fullfile(folder_out,sprintf('%s_top_hat_radius_%d.png',root_fname,radius));
        imwrite(uint8(im4d_top_hat_c),fname_out);
        fname_out = fullfile(folder_out,sprintf('%s_LIP_top_hat_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4d_LIP_top_hat_c');
        fname_out = fullfile(folder_out,sprintf('%s_LIP_top_hat_radius_%d.png',root_fname,radius));
        imwrite(uint8(im4d_LIP_top_hat_c),fname_out);  
        
        fname_out = fullfile(folder_out,sprintf('%s_top_hat_radius_%d_Stretched.png',root_fname,radius));
        imwrite(stretchimage(im4d_top_hat_c),fname_out);
        
        fname_out = fullfile(folder_out,sprintf('%s_top_hat_radius_%d_ROI_back.png',root_fname,radius));
        imwrite(stretchimage(im4d_top_hat_c_ROI_back),fname_out);  
        
        fname_out = fullfile(folder_out,sprintf('%s_top_hat_radius_%d_with_ROI_back.fig',root_fname,radius));
        savefig(fig_im4d_top_hat_c_ROI_back,fname_out,'compact');
        fname_out = fullfile(folder_out,sprintf('%s_top_hat_radius_%d_with_ROI_back.svg',root_fname,radius));
        saveas(fig_im4d_top_hat_c_ROI_back,fname_out);
        
        
        [~,root_fname] = fileparts(filename_dark);
        fname_out = fullfile(folder_out,sprintf('%s_bot_hat_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4d_bot_hat_c');
        fname_out = fullfile(folder_out,sprintf('%s_bot_hat_radius_%d.png',root_fname,radius));
        imwrite(uint8(im4d_bot_hat_c),fname_out);
        fname_out = fullfile(folder_out,sprintf('%s_LIP_bot_hat_radius_%d.mat',root_fname,radius));
        save(fname_out,'im4d_LIP_bot_hat_c');
        fname_out = fullfile(folder_out,sprintf('%s_LIP_bot_hat_radius_%d.png',root_fname,radius));
        imwrite(uint8(im4d_LIP_bot_hat_c),fname_out);
    end
    

end

%% Path management
path(oldpath);
pause(0.1); 