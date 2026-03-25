%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detector of the moving disks using the LIP-additive Asplund's distance
%
% [msk_balls, border_balls, im_AsDist_LIPAdd , im_AsDist_Add] = Detector_moving_disks_LIP_imDistAsplund_Add( imin , SE_probe , tol , r_int, flag_display , M )
%
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imin  # input image
% SE_probe     # stucturing element corresponding to the probe
%                   msk_probe = SE_probe.getnhood
%                   im_probe = SE_probe.getheight
% tol          # tolerance on the number of points to be kept
%                   (e.g. 95/100). tol_pts has to be in the interval [0,1]
% r_detect     # radius of the disk for the top hat detection
% flag_display # flag for image display
% M            # maximal range of the image: e.g. 256 for images
%                           uint8, 65536 for images uint16
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% msk_balls     # Mask of the b
% border_balls                     # List of borders
% im_AsDist_LIPAdd     # Map of LIP-additive Asplund distances
% im_AsDist_Add        # Map of additive Asplund distances
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detector_moving_disks_LIP_imDistAsplund_Add_v2.m
% Guillaume NOYEL 22/02/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%close all; clearvars

function [msk_balls, border_balls, im_AsDist_LIPAdd , im_AsDist_Add] = Detector_moving_disks_LIP_imDistAsplund_Add_v2( imin , ...
    SE_probe , tol , r_detect , flag_display , M )

SZ = size(imin);
%SE_probe_c = strel('arbitrary',SE_probe.getnhood(),LIP_imcomplement(SE_probe.getheight(),M));
SE_probe_c = LIP_strel_imcomplement( SE_probe , M );
im_AsDist_LIPAdd = LIP_imDistAsplundAddTol( LIP_imcomplement(imin,M) , SE_probe_c , tol , M );
%im_AsDist_LIPAdd_bis = LIP_imDistAsplundAddTol_morpho( LIP_imcomplement(imin,M) , SE_probe_c , tol , M );
%areImagesEqual( im_AsDist_LIPAdd , im_AsDist_LIPAdd , 1e-12 )

im_AsDist_Add = imDistAsplundAddTol_morpho( imin , SE_probe , tol );

%save('ws_moving_disks_1.mat');
%load('ws_moving_disks_1.mat');

if flag_display
    fig_4 = figure;
    subplot(121); image(im_AsDist_LIPAdd); axis equal
    title('Map LIP-additive Asplund')
    
    %fig_5= figure(); hold on;
    subplot(122);  h=histogram(im_AsDist_LIPAdd,M);
    title('Histogram of the map')
    
    fig_5 = figure;
    subplot(121); image(im_AsDist_Add); axis equal
    title('Map additive Asplund')
    
    %fig_5= figure(); hold on;
    subplot(122);  h=histogram(im_AsDist_Add,M);
    title('Histogram of the map')
end 


%% Detection of the minima
%load ws_matlab1.mat
% threshold
%th1 = 50;
%th1 = prctile(im_AsDist_LIPAdd(:),0.60);
%im_msk_mini_dist = im_AsDist_LIPAdd<=th1;
h =prctile(im_AsDist_LIPAdd(:),23);%30;%
im_msk_mini_dist = imextendedmin(im_AsDist_LIPAdd,h);

% Remove contours
msk1 = false(SZ);
msk1 = DrawBorder(msk1,true);
im_msk_mini_dist = xor(im_msk_mini_dist,imreconstruct(msk1,im_msk_mini_dist,8));
area_maxi = round(pi*(round(r_detect*2/3))^2)+1;
im_msk_mini_dist = xor(im_msk_mini_dist,bwareaopen(im_msk_mini_dist,area_maxi,8));
area_mini        = round(area_maxi/20);
im_msk_mini_dist = bwareaopen(im_msk_mini_dist,area_mini,8);

borders = bwboundaries(im_msk_mini_dist);
N_borders = length(borders);
if flag_display
    fig_5 = figure;
    imagesc(im_AsDist_LIPAdd); axis equal; hold on; colormap gray
    for n=1:N_borders
        plot(borders{n}(:,2),borders{n}(:,1),'r-');
    end
    title('Border thresholding of the distance')
end
 
%% Dilation of the mask
se_dil = strel('disk',round(r_detect*70/100),0);
msk_balls = imdilate(im_msk_mini_dist,se_dil);

border_balls = bwboundaries(msk_balls);
N_border_balls = length(border_balls);
if flag_display
    
    fig_8 = figure;
    imagesc(imin); axis equal; hold on; colormap gray
    for n=1:N_border_balls
        plot(border_balls{n}(:,2),border_balls{n}(:,1),'r-');
    end
    title('Border thresholding of the gradient of the distance')
end