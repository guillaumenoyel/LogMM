% Script_gen_curve_light_var.m
%  Guillaume NOYEL 29/11/2021


close all; clearvars;


oldpath = addpath('Function_sources');

%% Flags of the different parts of the programme

flag_write_res = true;%true; % flag to write the results

%% Parameters

flag_disp = true; % display flag
SZ_im = [2^10-2^8 , 2^10];

M = 256;
%% Paths

cur_dir = fileparts(mfilename('fullpath'));
im_dir = fullfile(cur_dir , 'im' );
out_dir = fullfile(cur_dir , 'Res' );


%% Colours

s = graphic_colours();
graphicR = s.graphicR;
graphicG = s.graphicG;
graphicB = s.graphicB;
graphicDrBr = s.graphicDrBr;
graphicMdBr = s.graphicMdBr;
graphicLBr =  s.graphicLBr;

%% Figure properties

% 	Default	Paper	Presentation
% Width         5.6	varies	varies
% Height        4.2	varies	varies
% AxesLineWidth	0.5	0.75	1
% FontSize      10	8       14
% LineWidth     0.5	1.5     2
% MarkerSize	6	8       12

% Choose parameters (line width, font size, picture size, etc.)
width = 4;     % Width in cm
height = 4;    % Height in cm

alw = 1;    % AxesLineWidth
fsz = 25;      % Fontsize
lw =  3;         % LineWidth
msz = 8;       % MarkerSize
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

%% Programme

% generate the image
im = zeros(SZ_im,'uint8');

% draw a curve

x_lim = [-1 1];
y_lim = [-1 1];

xy = [   -0.7465   -0.4737   -0.3      -0.4479   -0.5604   -0.5124   -0.2894   -0.0700    0.0793    0.1843    0.2249    0.0442   -0.0719    0.0203    0.2488    0.4406    0.5751    0.6581    0.6359    0.40    0.5493    0.7336    0.8332
         -0.1216   -0.1731    0.0585    0.2292   -0.0047   -0.2994   -0.3181   -0.2596   -0.1520    0.0421    0.2550    0.3649    0.0702   -0.3111   -0.3228   -0.2409   -0.1357   -0.0070    0.2877    0.20   -0.2596   -0.2550   -0.0608];

figure;
spcv = cscvn( xy );
hold on
fnplt( spcv )
plot(xy(1,:),xy(2,:),'*-');
hold off    
title('Drawing the spline')
% h = imfreehand('Closed',false);
% wait(h);

xy_curve_hor = [
   -0.8387   -0.0829    0.4866    0.7889    0.7889    0.7889
   -0.7368   -0.8187   -0.6877   -0.8117   -0.8117   -0.8117];

     
%% scaling of the spline into the image size
xy2 = bsxfun( @minus , bsxfun( @plus , bsxfun( @times , xy , [SZ_im(2); SZ_im(2)]/2 ) , [SZ_im(2); SZ_im(2)]/2 ) , [0; 2^8]/2 );

xy_curve_hor2 = bsxfun( @plus , bsxfun( @plus , bsxfun( @times , xy_curve_hor , [SZ_im(2); SZ_im(1)]/2 ) , [SZ_im(2); SZ_im(1)]/2 ) , [0;0]);

spcv2 = cscvn( xy2 );
spcv2_curve_hor = cscvn( xy_curve_hor2 );

figure
hold on
[points, t]=fnplt( spcv2 );
[points_crv_hor, t_crv_hor]=fnplt( spcv2_curve_hor );

plot(xy2(1,:),xy2(2,:),'-');
[~,dlon] = abscisse_curviligne_courbe( points' );
c = round(interpol_courbe_spline( points' , dlon ));
c = unique(c,'rows');
plot(c(:,1),c(:,2),'+');
[~,dlon] = abscisse_curviligne_courbe( points_crv_hor' );
c_crv_hor = round(interpol_courbe_spline( points_crv_hor' , round(dlon+10/100*dlon) ));
c_crv_hor = unique(c_crv_hor,'rows');
plot(c_crv_hor(:,1),c_crv_hor(:,2),'+');
axis([1 SZ_im(2) 1 SZ_im(1)])
hold off 
title('Scaling the spline into the image size')


%% Insertion of the curve in an image
c_im = [c(:,1),SZ_im(1)-c(:,2)];
c_crv_hor_im = [c_crv_hor(:,1),SZ_im(1)-c_crv_hor(:,2)];

% vertical translation
min_radius = 10 ; %minimal radius
r_max= 3; % maximum radius
Nb_sigma = 3; % Number of std for the Gaussian
c_crv_hor_im_trans = [c_crv_hor_im(:,1),c_crv_hor_im(:,2)+(min_radius+r_max)]; % translated coordinates

ind_c = sub2ind( SZ_im,  c_im(:,2) ,c_im(:,1) );
ind_c_crv_hor = sub2ind( SZ_im,  c_crv_hor_im(:,2) ,c_crv_hor_im(:,1) );
ind_c_crv_hor_trans = sub2ind( SZ_im,  c_crv_hor_im_trans(:,2) ,c_crv_hor_im_trans(:,1) );
im_msk_c_spir = false(SZ_im);
im_msk_c_spir(ind_c) = true;
im_msk_c_crv_hor = false(SZ_im);
im_msk_c_crv_hor(ind_c_crv_hor) = true;
im_msk_c_crv_hor(ind_c_crv_hor_trans) = true;

CC = bwconncomp(im_msk_c_spir);
if CC.NumObjects > 1
   error('There are more than 1 curve');
end

CC_crv_hor = bwconncomp(im_msk_c_crv_hor);
if CC_crv_hor.NumObjects > 2
   error('There are more than 2 curves');
end

im_msk_c = or(im_msk_c_spir,im_msk_c_crv_hor);

figure;
imagesc(im_msk_c); colormap gray
title('Mask of the curve')

%% Enlargement of the spiral curve
Nb_pts_curve = length(ind_c);

min_h = 20; % minimum intensity
l_h_max= randi(min_h+[0 5],Nb_pts_curve,1); % maximum height
min_radius = 10 ; %minimal radius
l_r = 10+(1:r_max); % list of the radius

Nb_r= length(l_r);
l_grain = cell(Nb_r,1);
l_se = cell(Nb_r,1);
for k=1:Nb_r
    filterG = generateBasisGaussFilter2D( l_r(k) , Nb_sigma );
    l_grain{k} = filterG.g0_y' * filterG.g0_x;
    size(l_grain{k})
    l_se{k} = strel('square',size(l_grain{k},1));
end

l_k = round(rand(Nb_pts_curve,1)*(Nb_r-1)+1);
for n=1:Nb_pts_curve
    k = l_k(n);
    grain_n = l_grain{k};
    SZ_grain_n = size(grain_n);
    se = l_se{k};
    [ln_i,ln_j,ln_off,msq_ne_offs] = get_Idx_vois( ind_c(n) , SZ_im, getneighbors(se) );
    im(ln_off) = max( im(ln_off) , uint8(round(grain_n(:)/max(grain_n(:))*l_h_max(n))) ); 
end

figure;
imagesc(im); colormap gray
title('Initial Image')

%% Enlargement of the horizontal curve
Nb_pts_curve = length(ind_c_crv_hor);

l_h_max= randi(min_h+[0 5],Nb_pts_curve,1); % maximum height
l_r = unique(round((min_radius+(1:r_max))/6)); % list of the radius

%number of structuring elements
Nb_sigma = 3;
Nb_r= length(l_r);
l_grain = cell(Nb_r,1);
l_se = cell(Nb_r,1);
for k=1:Nb_r
    filterG = generateBasisGaussFilter2D( l_r(k) , Nb_sigma );
    l_grain{k} = filterG.g0_y' * filterG.g0_x;
    l_se{k} = strel('square',size(l_grain{k},1));
end

ind_c_crv = [ind_c_crv_hor,ind_c_crv_hor_trans];
for m=1:size(ind_c_crv,2) % for each curve
    l_k = round(rand(Nb_pts_curve,1)*(Nb_r-1)+1);
    for n=1:Nb_pts_curve
        k = l_k(n);
        grain_n = l_grain{k};
        SZ_grain_n = size(grain_n);
        se = l_se{k};
        %[ im_win , reduction_win ] = get_centered_window( im , [c_im(n,2),c_im(n,1)] , SZ_grain_n );
        [ln_i,ln_j,ln_off,msq_ne_offs] = get_Idx_vois( ind_c_crv(n,m) , SZ_im, getneighbors(se) );
        %im_win = im( ln_i(1):ln_i(end) , ln_j(1):ln_j(end))
        im(ln_off) = max( im(ln_off) , uint8(round(grain_n(:)/max(grain_n(:))*l_h_max(n))) ); 
        %disp ''
    end
end

figure;
imagesc(im); colormap gray
title('Initial Image')

if flag_write_res
   fname = fullfile(out_dir,'initial_image.png');
   ajout_dossier(fname);
   imwrite(im,fname);
   
   fname = fullfile(out_dir,'initial_image_scaled.png');
   ajout_dossier(fname);
   imwrite(stretchimage(im),fname);
end


%% Light variations


[xx,yy] = meshgrid( 1:(SZ_im(2)-1)/2:SZ_im(2) , 1:(SZ_im(1)-1)/4:SZ_im(1) );

zz = [
        30    35      40
        30    35      40
        30    35      40
        30    35      40
        30    35      40
];
zz = max(zz(:)) - zz;
zz = zz + (M-1)-max(zz(:))-2;

figure;
surf(xx,yy,zz); xlabel('x'); ylabel('y'); zlabel('z');
set(gca,'Ydir','reverse')
title('Background')


[xx_im,yy_im] = meshgrid( 1:SZ_im(2) , 1:SZ_im(1) );

zz_im = griddata(xx,yy,zz,xx_im,yy_im,'linear');




figure
hold on
surf(xx_im,yy_im,zz_im); xlabel('x'); ylabel('y'); zlabel('z'); shading interp
set(gca,'Ydir','reverse')
title('Fitted Background')

if flag_write_res
   fname = fullfile(out_dir,'background.png');
   imwrite(uint8(zz_im),fname);
   
   fname = fullfile(out_dir,'background_scaled.png');
   imwrite(stretchimage(zz_im),fname);
end

%% Darkened images

im_drk_Ls = LIP_imadd( im , zz_im , M );  % LIP scale

im_drk_n = LIP_imcomplement(im_drk_Ls,M); % normal scale

figure
subplot(2,2,1)
imagesc(im_drk_Ls); colormap gray; %caxis([0 M-1]);
title('Darkened image LIP scale'); axis equal

subplot(2,2,2)
imagesc(im_drk_n); colormap gray; %caxis([0 M-1]);
title('Darkened image'); axis equal

subplot(2,2,3)
surf(im_drk_Ls); set(gca,'Ydir','reverse'); shading interp; %caxis([0 M-1]);
title('Darkened image LIP scale'); 

subplot(2,2,4)
surf(im_drk_n); set(gca,'Ydir','reverse'); shading interp; %caxis([0 M-1]);
title('Darkened image'); 

if flag_write_res
   fname = fullfile(out_dir,'dark_image.png');
   imwrite(uint8(im_drk_n),fname);
   
   fname = fullfile(out_dir,'dark_image_scaled.png');
   imwrite(uint8(stretchimage(im_drk_n)),fname);
    
   fig_im_n = figure;
   surf(im_drk_n); set(gca,'Ydir','reverse'); shading interp; colormap gray
   fname = fullfile(out_dir,'dark_image.fig');
   savefig(fig_im_n,fname,'compact');
   
   fname = fullfile(out_dir,'dark_image.svg');
   saveas(fig_im_n,fname);
   
   fname = fullfile(out_dir,'dark_image_LIPScale.png');
   imwrite(uint8(im_drk_Ls),fname);
   
   fname = fullfile(out_dir,'dark_image_scaled_LIPScale.png');
   imwrite(uint8(stretchimage(im_drk_Ls)),fname);
    
   fig_im_n = figure;
   surf(im_drk_Ls); set(gca,'Ydir','reverse'); shading interp; colormap gray
   fname = fullfile(out_dir,'dark_image_LIPScale.fig');
   savefig(fig_im_n,fname,'compact');
   
   fname = fullfile(out_dir,'dark_image_LIPScale.svg');
   saveas(fig_im_n,fname);   
end

%% LIP-top_hat

figure;
subplot(2,2,1)
imagesc(im_drk_n);
title('Darkened image'); colormap gray; axis equal

x_min = 150;    x_max = 200;
y_min = 410;    y_max = 510;
imrect(gca,[x_min y_min x_max-x_min y_max-y_min]);

subplot(2,2,2)
surf( im_drk_n(y_min:y_max,x_min:x_max) ); set(gca,'Ydir','reverse'); shading interp
title('zoom')

subplot(2,2,3)
plot( im_drk_n(y_min:y_max,round(mean([x_min x_max]) )) );
title('Profile')

% Structuring function ring peak
r_int = (81-9)/2; % internal radius

sigma_pix = r_int/3;
r_peak = sigma_pix;

r_int_RP = r_peak+3;
r_int = r_int+3;
r_ext = r_int+2;

% h_peak = 19;
% h_ring = 21.5;
h_peak = 3.3;
h_ring = 4.1;
h_bot = h_ring;
h_back = M-1;
delta_h_centre = h_peak-h_bot;
[ se_RP, msk_peak, se_R ] = strel_Ring_Gaussian( sigma_pix , r_ext, r_int , delta_h_centre , h_ring, h_bot , h_back );

subplot(2,2,4); im_probe = se_RP.getheight(); im_probe( ~se_RP.Neighborhood() ) = NaN;
surf(im_probe); set(gca,'Ydir','reverse'); shading interp

if flag_write_res
    fname = fullfile(out_dir,'dark_image.png');
    imwrite(uint8(im_drk_n),fname);
    
    fig_probe = figure; 
    fig_probe.Renderer = 'painters';
    s_probe= surf(im_probe); set(gca,'Ydir','reverse'); shading interp; colormap jet
    xticks([]); yticks([]); zticks([]);
    
    fname = fullfile(out_dir,'probe.fig');
    savefig(fig_probe,fname,'compact');
    
    fname = fullfile(out_dir,'probe.svg');
    saveas(fig_probe,fname);
    

    fig_probe = figure; 
    fig_probe.Renderer = 'painters';
    s_probe= surf(LIP_imcomplement(im_probe,M)); set(gca,'Ydir','reverse'); shading interp; colormap jet
    xticks([]); yticks([]); zticks([]);

    
    fname = fullfile(out_dir,'probe_LIPscale.fig');
    savefig(fig_probe,fname,'compact');
    
    fname = fullfile(out_dir,'probe_LIPscale.svg');
    saveas(fig_probe,fname);    
end


Pt = [ round(mean([x_min x_max])) , 466 ];
[h_fig, h_surf_im , h_surf_probe] = surf_imAndProbe( im_drk_n , se_RP.getheight() , Pt , se_RP.Neighborhood );

se_RP_comp = LIP_strel_imcomplement(se_RP,M);
se_R_comp = LIP_strel_imcomplement(se_R,M);
se_disk = strel('disk',r_ext+1);

im_drk_Lopen_RP = LIP_imopen( im_drk_Ls , se_RP_comp , M );
im_drk_Lopen_R  = LIP_imopen( im_drk_Ls , se_R_comp , M );% this the same operation as an opening because the strel is constant% areImagesEqual( imopen( im_drk_Ls , se_R_comp) , im_drk_Lopen_R , 1e-12 )
im_drk_open_RP = imopen( im_drk_Ls , se_RP_comp );
im_drk_open_R  = imopen( im_drk_Ls , se_R_comp );
im_drk_open_D   = imopen( im_drk_Ls , se_disk );


figure;
subplot(2,3,1); imagesc(im_drk_Ls);
title('Dark image (LIP scale)'); colormap gray; axis equal

subplot(2,3,2); imagesc(im_drk_Lopen_RP);
title('Dark image LIP-open RP (LIP scale)'); colormap gray; axis equal

subplot(2,3,3); imagesc(im_drk_Lopen_R);
title('Dark image LIP-open R (LIP scale)'); colormap gray; axis equal

subplot(2,3,5); imagesc(im_drk_open_RP);
title('Dark image open RP (LIP scale)'); colormap gray; axis equal

subplot(2,3,6); imagesc(im_drk_open_R);
title('Dark image open R (LIP scale)'); colormap gray; axis equal


if flag_write_res 
    fname = fullfile(out_dir,'im_spiral_Lopen_RingGaussian_scaled_comp.png');
    imwrite(uint8(stretchimage(im_drk_Lopen_RP)),fname);    
    
    fname = fullfile(out_dir,'im_spiral_Lopen_Ring_scaled_comp.png');
    imwrite(uint8(stretchimage(im_drk_Lopen_R)),fname);
end
 
figure;
subplot(1,2,1); surf(se_RP_comp.getheight()); set(gca,'Ydir','reverse'); shading interp
title('Complemented se Ring + Peak'); zlim([LIP_imcomplement(h_bot,M)-10 ,M-1])
subplot(1,2,2); surf(se_R_comp.getheight()); set(gca,'Ydir','reverse'); shading interp
title('Complemented se Ring'); zlim([LIP_imcomplement(h_bot,M)-10 ,M-1])

fig_im_pts = figure();
imagesc(im_drk_Ls);
title('Dark image (LIP scale)'); colormap gray; axis equal; hold on;

%% Contact points between the probes and the images

im_drk_Lerode_RP = LIP_imerode( im_drk_Ls , se_RP_comp , M );
im_drk_Lerode_R = LIP_imerode( im_drk_Ls , se_R_comp , M );
Pt = [184, 458];%x,y 1


Pt = [405,539];
[h_fig_spiral_RP, h_surf_im_spiral_RP , h_surf_probe_spiral_RP] = surf_imAndProbe( im_drk_Ls , ...
    LIP_imadd(im_drk_Lerode_RP(Pt(2),Pt(1)),se_RP_comp.getheight(),M) , Pt , se_RP_comp.Neighborhood, [] , [], false );
figure(fig_im_pts); plot(Pt(1), Pt(2),'+','DisplayName',sprintf('Pt [%d,%d]',Pt(1),Pt(2)));

[h_fig_spiral_R, h_surf_im_spiral_R , h_surf_probe_spiral_R] = surf_imAndProbe( im_drk_Ls , ...
    LIP_imadd(im_drk_Lerode_R(Pt(2),Pt(1)),se_R_comp.getheight(),M) , Pt , se_R_comp.Neighborhood, [] , [], false );
figure(fig_im_pts); plot(Pt(1), Pt(2),'+','DisplayName',sprintf('Pt [%d,%d]',Pt(1),Pt(2)));

Pt = [238,691];
[h_fig_curves_RP, h_surf_im_curves_RP , h_surf_probe__curves_RP] = surf_imAndProbe( im_drk_Ls , ...
    LIP_imadd(im_drk_Lerode_RP(Pt(2),Pt(1)),se_RP_comp.getheight(),M) , Pt , se_RP_comp.Neighborhood, [] , [], false );
figure(fig_im_pts); plot(Pt(1), Pt(2),'+','DisplayName',sprintf('Pt [%d,%d]',Pt(1),Pt(2)));

[h_fig_curves_R, h_surf_im_curves_R , h_surf_probe_curves_R] = surf_imAndProbe( im_drk_Ls , ...
    LIP_imadd(im_drk_Lerode_R(Pt(2),Pt(1)),se_R_comp.getheight(),M) , Pt , se_R_comp.Neighborhood, [] , [], false );
figure(fig_im_pts); plot(Pt(1), Pt(2),'+','DisplayName',sprintf('Pt [%d,%d]',Pt(1),Pt(2)));

legend('show')




figure(fig_im_pts);
legend('off')
xticks([]); yticks([]); zticks([]); box off; axis off; title('');

if flag_write_res
    fname = fullfile(out_dir,'im_spiral_select_points.fig');
    savefig(fig_im_pts,fname,'compact');
    fname = fullfile(out_dir,'im_spiral_select_points.svg');
    saveas(fig_im_pts,fname);
    fname = fullfile(out_dir,'im_spiral_select_points.png');
    saveas(fig_im_pts,fname);
end


figure(h_fig_spiral_RP);
h_fig_spiral_RP.Renderer = 'painters';

xticks([]); yticks([]); zticks([]); title('');

gca_h_fig_spiral_RP = gca_fig(h_fig_spiral_RP);
campos(gca_h_fig_spiral_RP,[ -649.8282  -18.5271  255.6701]);


if flag_write_res
    fname = fullfile(out_dir,'probe_contact_spiral.fig');
    savefig(h_fig_spiral_RP,fname,'compact');
    
    fname = fullfile(out_dir,'probe_contact_spiral.svg');
    saveas(h_fig_spiral_RP,fname);
end

figure(h_fig_spiral_R);
h_fig_spiral_R.Renderer = 'painters';
xticks([]); yticks([]); zticks([]); title('');
gca_h_fig_spiral_R = gca_fig(h_fig_spiral_R);
campos(gca_h_fig_spiral_R,[ -649.8282  -18.5271  255.6701]);

if flag_write_res
    fname = fullfile(out_dir,'probe_contact_spiral_probe_Ring.fig');
    savefig(h_fig_spiral_R,fname,'compact');
    
    fname = fullfile(out_dir,'probe_contact_spiral_probe_Ring.svg');
    saveas(h_fig_spiral_R,fname);
end


figure(h_fig_curves_RP);
h_fig_curves_RP.Renderer = 'painters';

xticks([]); yticks([]); zticks([]); title('');
gca_h_fig_curves_RP = gca_fig(h_fig_curves_RP);
gca_h_fig_curves_RP.CameraPosition = gca_h_fig_spiral_RP.CameraPosition;

if flag_write_res
    fname = fullfile(out_dir,'probe_contact_curve.fig');
    savefig(h_fig_curves_RP,fname,'compact');
    
    fname = fullfile(out_dir,'probe_contact_curve.svg');
    saveas(h_fig_curves_RP,fname);
end


figure(h_fig_curves_R);
h_fig_curves_R.Renderer = 'painters';
xticks([]); yticks([]); zticks([]); title('');
gca_h_fig_curves_R = gca_fig(h_fig_curves_R);
gca_h_fig_curves_R.CameraPosition = gca_h_fig_spiral_R.CameraPosition;

if flag_write_res
    fname = fullfile(out_dir,'probe_contact_curve_probe_Ring.fig');
    savefig(h_fig_curves_R,fname,'compact');
    
    fname = fullfile(out_dir,'probe_contact_curve_probe_Ring.svg');
    saveas(h_fig_curves_R,fname);
end
    


% LIP-top-hat by a ring = LIP-difference between the image and a LIP-opening by a ring
TH_L_R = LIP_imsubtract( im_drk_Ls , im_drk_Lopen_R , M );

% LIP difference between LIP-openings by a Gaussian+Ring and a Ring
Diff_L_open_R = LIP_imsubtract( im_drk_Lopen_RP , im_drk_Lopen_R , M );

% difference between openings by a Gaussian+Ring and a Ring
Diff_open_R = im_drk_open_RP - im_drk_open_R;

% Top hat by a disk (image - opening)
TH_D = im_drk_Ls - im_drk_open_D;

% LIP-Top hat by a disk (image - opening)
TH_L_D = LIP_imsubtract( im_drk_Ls , im_drk_open_D , M );

% Absolute value of the LIP-difference betwen LIP-openings
LIPabs_Diff_L_open_R = max(Diff_L_open_R,LIP_imneg(Diff_L_open_R,M));

figure;
subplot(2,3,1); imagesc(TH_L_R); axis equal; % LIP-TH
title('LIP-TH Ring')
subplot(2,3,2); Image_Diff_L_open_R = imagesc(Diff_L_open_R); axis equal;% Diff_L_open
title('Diff L-open')
subplot(2,3,3); Image_TH_L_D = imagesc(TH_L_D); axis equal; % LIP-TH
title('LIP-TH Disk')
subplot(2,3,4); imagesc(LIPabs_Diff_L_open_R); axis equal;% Diff_L_open
title('Labs(Diff L-open)')
subplot(2,3,5); Image_Diff_open_R = imagesc(Diff_open_R); axis equal;% Diff_L_open
title('Diff open')

figure;
Image_TH_D = imagesc(TH_D); axis equal;% Diff_L_open
title('TH D')

if flag_write_res
    fname = fullfile(out_dir,'LIP_Diff_Lopen_RingGauss.png');
    imwrite(uint8(Diff_L_open_R),fname);
    fname = fullfile(out_dir,'LIP_Diff_Lopen_RingGauss_scaled.png');
    imwrite(uint8(stretchimage(Diff_L_open_R)),fname);
    fname = fullfile(out_dir,'LIP_Diff_Lopen_RingGauss_col.png');
    imwrite(ImageObject_to_RGB(Image_Diff_L_open_R),fname);
    
    fname = fullfile(out_dir,'Diff_open_RingGauss.png');
    imwrite(uint8(Diff_open_R),fname);
    fname = fullfile(out_dir,'Diff_open_RingGauss_scaled.png');
    imwrite(uint8(stretchimage(Diff_open_R)),fname);
    fname = fullfile(out_dir,'Diff_open_RingGauss_col.png');
    imwrite(ImageObject_to_RGB(Image_Diff_open_R),fname);
    
    fname = fullfile(out_dir,'LIP_TopHat_Disk.png');
    imwrite(uint8(TH_L_D),fname);
    fname = fullfile(out_dir,'LIP_TopHat_Disk_scaled.png');
    imwrite(uint8(stretchimage(TH_L_D)),fname);
    fname = fullfile(out_dir,'LIP_TopHat_Disk_col.png');
    imwrite(ImageObject_to_RGB(Image_TH_L_D),fname);
    
    fname = fullfile(out_dir,'TopHat_Disk.png');
    imwrite(uint8(TH_D),fname);
    fname = fullfile(out_dir,'TopHat_Disk_scaled.png');
    imwrite(uint8(stretchimage(TH_D)),fname);
    fname = fullfile(out_dir,'TopHat_Disk_col.png');
    imwrite(ImageObject_to_RGB(Image_TH_D),fname);
end

%% Differences of erosions

im_drk_Lero_RP = LIP_imerode( im_drk_Ls , se_RP_comp , M );
im_drk_Lero_R = LIP_imerode( im_drk_Ls , se_R_comp , M );

im_Ldiff_Lero = LIP_imsubtract( im_drk_Lero_R , im_drk_Lero_RP , M );

figure;
Image_im_Ldiff_Lero = imagesc(im_Ldiff_Lero); axis equal;% Diff_L_open
title('LIP diff erosion')

if flag_write_res
    ajout_dossier_depuis_nom_dossier(out_dir);
    fname = fullfile(out_dir,'LIP_Diff_Lero_RingGauss.png');
    imwrite(uint8(im_Ldiff_Lero),fname);
    fname = fullfile(out_dir,'LIP_Diff_Lero_RingGauss_scaled.png');
    imwrite(uint8(stretchimage(im_Ldiff_Lero)),fname);
    fname = fullfile(out_dir,'LIP_Diff_Lero_RingGauss_col.png');
    imwrite(ImageObject_to_RGB(Image_im_Ldiff_Lero),fname);
end

%% Path management
path(oldpath);
pause(0.1); 
