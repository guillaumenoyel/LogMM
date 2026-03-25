
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tracker of the bump by LIP-erosion with tolerance (left right segments) in one orientation
%
% [Delta_eroTol_ang , E_eroTol_ang_l , E_eroTol_ang_r , E_eroTol_ang_2seg] =
% DR_VES_bump_tracker_one_ang( im_grey_comp , im_msk, info_probe, M )
%
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% INPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im_grey_comp     # complemented grey level image
% im_msk                   # mask image (logical)
% info_probe       # Struct with the information of the probe
%                       info_probe.len : length (in pixels)
%                       info_probe.ang : angle (in degrees)
%                       info_probe.width : width (in pixels),
%                       info_probe.val_probe : grey values of the segment of the probes
%                               vector of length 3 [h_bot h_top h_bot]
%                       info_probe.pct_kept_pts  : tolerance on the erosion
%                       with 2 vectors
%                       info_probe.d1 : average diameter of the optic disc
% M                # maximal grey values for the LIP model. e.g. 256 for 8-bit images
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% OUTPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% Delta_eroTol_ang  # bump tracker : max( E_eroTol_ang_l , E_eroTol_ang_r )
% E_eroTol_ang_l    # Logarithmic Additive Contrast (LAC) between the 3-segment erosion and the left-segment erosion
% E_eroTol_ang_r    # Logarithmic Additive Contrast (LAC) between the 3-segment erosion and the right-segment erosion
% E_eroTol_ang_2seg # LAC between the 3-segment erosion and the 2-segment erosion
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DR_VES_bump_tracker_one_ang.m
% Guillaume NOYEL 19-07-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Delta_eroTol_ang , E_eroTol_ang_l , E_eroTol_ang_r , E_eroTol_ang_2seg, im_LIPero_tol_3seg_fast] = ...
    DR_VES_bump_tracker_one_ang( im_grey_comp ,im_msk , info_probe, M )


%% Parameters

flag_disp = false;%true;%false;% display flag

%% Inputs management


%% Influential parameters

%% Program

len             = info_probe.len;
ang             = info_probe.ang;
width           = info_probe.width;
val_probe       = info_probe.val_probe;
pct_kept_pts    = info_probe.pct_kept_pts ;

%% LIP-erosion with the central segment
% fast erosion
SE_1seg_c                = strel_3_oriented_segments( len , ang , width , val_probe , [0 1 0] );
im_LIPero_1seg           = LIP_imerode( im_grey_comp , SE_1seg_c , M );
%im_LIPero_tol_1seg      = LIP_imerode_tol( im_grey_comp , SE_1seg_c , M , pct_kept_pts  );

% %% Detection of the Forbidden zones
% 
% if flag_disp
%     figure;
%     imagesc(im_LIPero_1seg); colormap parula; title('Central constants'); axis equal
%     
%     figure;
%     histogram(im_LIPero_1seg(im_msk), (round(min(im_LIPero_1seg(im_msk))):round(max(im_LIPero_1seg(im_msk))))+0.5);
%     title('Histogram of constants');
% end
% mu = mean(im_LIPero_1seg(im_msk));
% sigma = std(im_LIPero_1seg(im_msk));
% %msk_fbd = im_LIPero_1seg<mu-2*sigma;%forbidden zones
% msk_fbd = im_LIPero_1seg<mu-2*sigma;%forbidden zones
% 
% se = strel('disk',info_probe.width);
% msk_fbd_group = imclose(msk_fbd,se);
% CC = bwconncomp(msk_fbd_group);
% l_param = regionprops(CC,'Area','Eccentricity');
% areA_OD = (pi*info_probe.d1/2)^2;% area of the Optic Disk
% 
% if flag_disp
%     figure;
%     imagesc( msk_fbd ); axis equal; title('Zones with low constant'); colormap parula
%     
%     figure;
%     imagesc(msk_fbd_group); colormap parula; title('Grouped zones with low constant'); axis equal
% end
% 
% %th_eccentricity = 50/100;
% for n =1:length(l_param)
%    if (l_param(n).Area > (areA_OD*5/100) && l_param(n).Area < areA_OD)
%        %if l_param(n).Eccentricity < th_eccentricity
%            msk_fbd_group(CC.PixelIdxList{n}) = false;
%        %end
%     
%    end
% end
% msk_fbd = imreconstruct( and(msk_fbd_group,msk_fbd) , msk_fbd );
% 
% 
% cte_add = LIP_imsubtract( val_probe(2) , val_probe(1) , M );
% im_grey_comp(msk_fbd) = LIP_imadd( im_grey_comp(msk_fbd) , cte_add  , M);
% 
% if flag_disp
%     figure;
%     imagesc( msk_fbd ); axis equal; title('Forbidden zones'); colormap parula
%     
%     figure;
%     imagesc(im_grey_comp); colormap parula; title('Corrected images'); axis equal
% end

%% LIP-Erosion with the 2 segments (reduced probe)

SE_1seg_l             = strel_3_oriented_segments( len , ang , width , val_probe , [1 0 0] );
SE_1seg_r             = strel_3_oriented_segments( len , ang , width , val_probe , [0 0 1] );
if pct_kept_pts  < 1
    im_LIPero_tol_1seg_l  = LIP_imerode_tol( im_grey_comp , SE_1seg_l , M , pct_kept_pts  );       % Erosion left segment
    im_LIPero_tol_1seg_r  = LIP_imerode_tol( im_grey_comp , SE_1seg_r , M , pct_kept_pts  );       % Erosion right segment
else
    im_LIPero_tol_1seg_l  = LIP_imerode( im_grey_comp , SE_1seg_l , M );       % Erosion left segment
    im_LIPero_tol_1seg_r  = LIP_imerode( im_grey_comp , SE_1seg_r , M );       % Erosion right segment
end

im_LIPero_tol_2seg    = min( im_LIPero_tol_1seg_l , im_LIPero_tol_1seg_r ); % combination of the erosion by infimum

%     [im_dist_2seg , im_c1_2seg , im_c2_2seg] = LIP_imDistAsplundAdd( im_grey_comp , SE_2seg , M );
%     l_b1(k) = areImagesEqual( im_LIPero_2seg , im_c2_2seg , 1e-12 ); % equality LIP-dilation and mlub


%% LIP-Erosion with the 3 segments
%im_LIPero_3seg_fast     = min( im_LIPero_2seg , im_LIPero_1seg );
im_LIPero_tol_3seg_fast = min( im_LIPero_tol_2seg , im_LIPero_1seg );

% %     % standard erosion (slow)
% 	SE_3seg                 = strel_3_oriented_segments( len , ang , width , val_probe );
%im_LIPero_3seg  = LIP_imerode( im_grey_comp , SE_3seg , M );
%l_b2(k)         = areImagesEqual( im_LIPero_3seg , im_LIPero_3seg_fast , 1e-12 );

%     [im_dist_3seg , im_c1_3seg , im_c2_3seg] = LIP_imDistAsplundAdd( im_grey_comp , SE_3seg , M );
%     l_b3(k)         = areImagesEqual( im_LIPero_3seg_fast , im_c2_3seg , 1e-12 );

%% Finding the infimum of the LAC between the erosions with 2 segments and 3 segments



%Delta_eroTol_ang                               = LIP_imsubtract( im_LIPero_tol_2seg , im_LIPero_tol_3seg_fast , M );
% LAC differences between erosions, left seg
E_eroTol_ang_l                               = LIP_imsubtract( im_LIPero_tol_1seg_l , im_LIPero_tol_3seg_fast , M );
% LAC differences between erosions, right seg
E_eroTol_ang_r                               = LIP_imsubtract( im_LIPero_tol_1seg_r , im_LIPero_tol_3seg_fast , M );

% Bump detector
%Delta_eroTol_ang                             = (E_eroTol_ang_l + E_eroTol_ang_r ) / 2;
Delta_eroTol_ang                             = max(E_eroTol_ang_l , E_eroTol_ang_r );
%Delta_eroTol_ang                             = min(E_eroTol_ang_l , E_eroTol_ang_r ); %%%% REPLACEMENT of MAX by MIN

%% Finding the infimum of the LAC between the erosions with 2 segments and 3 segments
if nargout >= 4
    E_eroTol_ang_2seg                        = LIP_imsubtract( im_LIPero_tol_2seg , im_LIPero_tol_3seg_fast , M );
end



%% LIP-contrast : LIP-Difference


if flag_disp
    figure();
    imagesc( Delta_eroTol_ang ); title('Min LAC erosions tol left right seg'); axis equal
end
