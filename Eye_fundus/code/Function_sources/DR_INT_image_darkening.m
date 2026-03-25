
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Darkening of eye fundus images
%
% [] = DR_INT_image_darkening( kprob , kpack , filename_in , method , )
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
%   method   : darkening method
%               - 'exponential' : LIP-add an exponential drift up from 100 to 230
%
%   LogId    : (Optional) ID of the LOG file (> 2) /Display (1) / Nothing (0)
%               Default : 0
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DR_INT_image_darkening.m
% Guillaume NOYEL 01-09-2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% close all; clear all; clear mex;
% kprob = 1; kpack = 1; kim = 5; 
% coeff_D2 = 1/74;

function [] = DR_INT_image_darkening( kprob , kpack , filename_in , method , varargin )


%% Parameters


para_disp.flag_display              = false;%true;%false
para_disp.flag_detail               = false;

para_disp.tab_fig                   = NaN(1,100);
para_disp.cpt_fig                   = 0; 
para_disp.cpt_pos                   = 0;
para_disp.flag_darken_images        = true;    

%% Inputs management

[ kprob , kpack , filename_in , method ] = parse_inputs( kprob , kpack , filename_in , method , varargin{:} );


[~,im_name_in] = fileparts(filename_in);


%% Program


% Position of the figures
pos_fenetre = FIG_get_pos_figs();


% % image file
im = imread(filename_in);
SZ = size(im);


%%  10  DRIVE database : the mask is given with the image

kfile = 11011; % Mask given with the image database
[lefic] = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
im_msk = imread( lefic )>0;



% kfile = 21; % Field of view diameter
% [lefic] = DR_GEN_files_name( kprob,kpack, kfile, filename_in);
% load( lefic , 'D' );

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

%% Darkening of the images

if para_disp.flag_darken_images

    M = double(intmax(class(im)))+1;
    switch method
        case 'constant'
            I_add = 170;%100;
        case {'exponential'}
            [centre , R_c] = DR_IM_fit_disk(im_msk);

            [xx,yy] = meshgrid(1:size(im,2),1:size(im,1));
            [~,rv] = cart2pol(xx-centre(1),yy-centre(2));
            rv(~im_msk) = 0;


            I_add = 230*(1-exp(-1/(R_c/4)*rv));


            if para_disp.flag_display
                I_drk = LIP_imadd(200 , I_add, M);
                I_drk(~im_msk) = 0;
                para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
                para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_pos,:));
                %plot(imR(round(centre(2)),:),'DisplayName','image profile'); hold on;
                plot(I_add(round(centre(2)),:),'DisplayName','dark image profile');
                legend('show');
                title('Vignetting profile')

                para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
                para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_fenetre(para_disp.cpt_pos,:));
                %plot(imR(round(centre(2)),:)+1,'DisplayName','image profile'); hold on;
                imshow(I_drk,[min(I_drk(im_msk)) max(I_drk(im_msk))]);
                title('Dark image')
            end
    end
    im_dark_c = LIP_imadd( LIP_imcomplement( im , M ) , I_add , M );
    min(imhsp_mskextract(im_dark_c,im_msk))
    max(imhsp_mskextract(im_dark_c,im_msk))
    im_dark = LIP_imcomplement( uint8(im_dark_c) , M );
    im_dark = imhsp_mskfill(im_dark,repmat(max(min(imhsp_mskextract(im_dark,im_msk))),1,3),~im_msk);% external value


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

%% Saving results

kfile1 =2161; % Darkened image by LIP-adding an exponential drift up to 230 in PNG format                            
kfile2 =21610;% Darkened image by LIP-adding an exponential drift up to 230 in TIF format   


[lefic] = DR_GEN_files_name( kprob,kpack, kfile1, filename_in);
ajout_dossier(lefic);
imwrite( im_dark , lefic );
fprintf('<------------------- Saved : %s\n',lefic);

[lefic] = DR_GEN_files_name( kprob,kpack, kfile2, filename_in);
imwrite( im_dark , lefic );
fprintf('<------------------- Saved : %s\n',lefic);


if para_disp.flag_display
   pause;
   close all;
end


end

%% parse_inputs

function [ kprob , kpack , filename_in , method ] = parse_inputs( kprob , kpack , filename_in , method , varargin )

p = inputParser;

addRequired(p,'kprob',@isscalar);
addRequired(p,'kpack',@isscalar);
addRequired(p,'filename_in',@ischar);
addRequired(p,'method',@(x) ischar(x) && ismember(x,{'constant','linear','quadratic','exponential','3 exponentials','3 gaussians'}));

parse( p , kprob , kpack , filename_in , method , varargin{:} );

end 
