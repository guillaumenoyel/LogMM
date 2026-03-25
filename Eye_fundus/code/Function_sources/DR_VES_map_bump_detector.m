
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Map of bum detector
%
% [map_vessel_detector, map_vessel_detector_norm, mu , th, im_ang_or_detector , im_msk_vessels , para_disp ] = DR_VES_map_bump_detector( ...
%    im_grey , im_msk , M )
%
% [map_vessel_detector, map_vessel_detector_norm, mu , th, im_ang_or_detector , im_msk_vessels , para_disp ] = DR_VES_map_bump_detector( ...
%    im_grey , im_msk , coeff_D1 , coeff_D2 , D , para_disp )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% INPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im_grey                  # input grey level image
% im_msk                   # mask image (logical)
% M                        # maximal grey values for the LIP model. e.g. 256 for 8-bit images
% coeff_D1                 # (option)  coefficient of the average diameter of the optic disc : d1 = D*coeff_D1
%                                   Default 1/5
% coeff_D2                 # (option)  % coefficient of the maximal width of vessels : d2 = D*coeff_D2
%                                   Default 1/74
% D                        # (option) Diamteter of the Field of View (in pixels)
%                                   Default : D is computed by the function
% para_disp                # display parameters
%                                   para_disp.flag_display : display flag
%                                   para_disp.flag_detail  : details flag
%                                   para_disp.tab_fig      : array of figure handle
%                                   para_disp.cpt_fig      : figure counter
%                                   para_disp.cpt_pos      : figure position counter
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% OUTPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% map_vessel_detector      # Map of the vessel detector (map of vesselness)
% map_vessel_detector_norm # Map of the vessel detector normalised (map of vesselness normalised)
% mu                       # median of map_vessel_detector(im_msk_vessels)
% th                       # threshold
% im_ang_or_detector       # Map of the orientation angles (in degrees)
% im_msk_vessels           # Mask of the vessels
% para_disp                # display parameters updated
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DR_VES_map_bump_detector.m
% Guillaume NOYEL 06-09-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [map_vessel_detector, map_vessel_detector_norm, mu , th, im_ang_or_detector , im_msk_vessels , para_disp ] = DR_VES_map_bump_detector( ...
    im_grey , im_msk , M , varargin )




%% Parameters

%% Input management

[ im_grey , im_msk, M , coeff_D1 , coeff_D2 , D , para_disp ] = parse_inputs( im_grey , im_msk, M , varargin{:} );
im_grey(~im_msk) = 0;

%% Darkening of the images by LIP-adding a constant
% cte = 170;
% im_grey = LIP_imcomplement(LIP_imadd(LIP_imcomplement(im_grey,M),cte,M),M);
% im_grey(~im_msk) = 0;
% min(im_grey(im_msk))
% max(im_grey(im_msk))

%% Influential parameters

%% parameters of the reference probe
h_top_ref = 40;              % top value (in the grey scale)
h_bot_ref = h_top_ref-10;    % bottom value (in the grey scale)

%% Parameters for the estimation of the Field of View diameter

coeff_D2_up = coeff_D2 * 74/50;

%% diameter of the image and width of the probe

if isempty(D)
    BB = get_1_BoundingBox(im_msk); % bounding box
    D = BB(2) - BB(1);%image diameter
end
d1 = round(coeff_D1*D); % average diameter of the optic disc
d2 = round(coeff_D2_up*D); % largest vessel diameter

%% Step between the different angle of probing

step_angle = 20;%%10;%5; % step between angles

%% kept Points for the probing
% Tolerance on the points
pct_kept_pts  = 80/100;%80/100;

%% Processing

th_area_var = 40/100;%30/100; % variation of segmented area

%% Post processing on eccentricity
th_eccentricity = 95/100;%95/100;%95/100;%80/100;% % threshold on the eccentricity
th_solidity = 40/100;%20/100;%%
th_area_mini = round((d2/2)^2);  % minimum area



%% Display

% Position of the figures
pos_windows = FIG_get_pos_figs();

%% Program

%% Adjusting the parameters of the probe by the mean image value

h_top_ref_c = LIP_imcomplement(h_top_ref,M);
h_bot_ref_c = LIP_imcomplement(h_bot_ref,M);

mu_im = mean(im_grey(im_msk));
mu_im_c = LIP_imcomplement(mu_im,M);

h_top_c_scaled = mu_im_c;
ctr_top_c = LIP_imsubtract( h_top_c_scaled , h_top_ref_c , M );
h_bot_c_scaled = LIP_imadd( h_bot_ref_c, ctr_top_c , M );

h_top = LIP_imcomplement(h_top_c_scaled,M); %after scaling
h_bot = LIP_imcomplement(h_bot_c_scaled,M); %after scaling

% h_top = 60;%50;%55;%60;%105;%85;%60; % top values
% h_bot = 45; % bottom values
th_min_height_probe = 15;
if  0 %(h_top-h_bot)> th_min_height_probe
    %l_h_bot = [h_bot , h_top - (h_top-h_bot)/2 , h_top - (h_top-h_bot)/3];
    h_bot2 = LIP_imcomplement(LIP_imadd(h_top_c_scaled , LIP_immultScalar(LIP_imsubtract(h_bot_c_scaled,h_top_c_scaled,M),80/100,M) , M),M);
    h_bot3 = LIP_imcomplement(LIP_imadd(h_top_c_scaled , LIP_immultScalar(LIP_imsubtract(h_bot_c_scaled,h_top_c_scaled,M),50/100,M) , M),M);
    l_h_bot = [h_bot , h_bot2 , h_bot3];
else
    %l_h_bot = [h_top - (h_top-h_bot)/3];
    l_h_bot = h_bot;
end



%% Parameters of the probe

val_probe               = LIP_imcomplement([h_top h_bot h_top],M);
info_probe.val_probe    = val_probe;
info_probe.width        = d2;  % width of the probe
info_probe.len          = 2*floor(round(0.75*info_probe.width )/2)+1; % length of the probe in one directionr
%info_probe.len          = 2*floor(round(0.5*info_probe.width )/2)+1; % length of the probe in one directionr
%len     = 2*floor(round(1.2*width)/2)+1; % length of the lines in one direction
%len     = 2*floor(round(2*width)/2)+1; % length of the lines in one direction
info_probe.pct_kept_pts = pct_kept_pts;
info_probe.d1 = d1; % average diameter of the optic disc

if para_disp.flag_display
    val_probe   = LIP_imcomplement([h_top h_bot h_top],M);
    DEG         = -70; % initial orientation of the probe
    
    SE_3seg     = strel_3_oriented_segments( info_probe.len , DEG , info_probe.width , val_probe );
    
    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
    subplot(1,2,1)
    vois = SE_3seg.getnhood;
    imagesc(vois); hold on; axis equal; %colormap gray;
    title(sprintf('Probe 2D (angle %.02f°)',DEG))
    [ij_centre]=get_strel_centre(vois); ycen = ij_centre(1); xcen = ij_centre(2);
    quiver(xcen,ycen,xcen,0,'g');
    quiver(xcen,ycen,round((info_probe.len-1)*cos(DEG/180*pi)),round((info_probe.len-1)*sin(DEG/180*pi)),0,'r');
    
    subplot(1,2,2)
    imagesc(SE_3seg.getheight); hold on; axis equal; %colormap gray;
    title('Structuring function image')
end

% %% Pre filtering remowing the white exudates
% 
% se_disk = strel('disk',1);
% im_grey_ini = im_grey;
% im_grey(~im_msk) = 0;
% %im_grey_boundary = imdilate(im_grey,se_disk); % erosion on the boundary to remove the noise
% nb_homothety = 3;
% im_grey_boundary = ImASF(im_grey,se_disk,nb_homothety,'OpenClose'); % erosion on the boundary to remove the noise
% im_msk_boundary = xor( im_msk , MorphologicalOperationWithPad(im_msk,'imerode',HomotheticSE(se_disk,nb_homothety),false) );
% im_grey(im_msk_boundary) = im_grey_boundary(im_msk_boundary);
% im_grey(~im_msk) = 0;
% th_area_pre = d2^2;
% im_grey_ini = im_grey;
% im_grey = MorphM_T_imin_imout( im_grey , 'ImAreaOpening' , 'Square' , th_area_pre );
% %
% % [ im_grey ] = remove_salt_and_peper_noise( im_grey );
% % h = fspecial('gaussian', 5, 0.5);
% % im_grey = imfilter( im_grey , h );
% %
% if para_disp.flag_display
%     para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
%     para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
%     imagesc(im_grey_ini); hold on; axis equal; colormap gray;
%     title(sprintf('Original image'))
% 
%     para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
%     para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
%     imagesc(im_grey); hold on; axis equal; colormap gray;
%     title(sprintf('Area opening'))
% 
%     para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
%     para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
%     imagesc(im_grey_ini-im_grey); hold on; axis equal; %colormap gray;
%     title(sprintf('Difference with original'))
% end

%% Novel method of segmentation

SZim = size(im_grey);
im_grey_comp = LIP_imcomplement( im_grey , M );

if para_disp.flag_display
    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
    imagesc( im_grey_comp ); axis equal; title('Complemented image'); colormap parula
end

%% Probing for different angles

liste_angle = 0:step_angle:360-step_angle;
liste_angle_mod = mod(liste_angle,180);
[~,i_in,i_similar] = unique(liste_angle_mod,'stable');
Nb_angle = length(liste_angle); % Number of angles

map_vessel_detector = Inf(SZim); % infimum of the LAC between the erosion with 2 segments and 3 segments
im_c2               = Inf(SZim); % map of constant which are LIP-subtracted
im_ind_ang_map      = zeros(SZim,'uint8'); % image of direction angle indices
im_ind_ang_or       = zeros(SZim,'uint8'); % image of orientation angle indices
im_ind_probe_map    = zeros(SZim,'uint8'); % image of the probe indices

%l_width = [round(1.2*d2) d2 round(0.75*d2) round(0.5*d2)];
l_width = [d2 round(0.75*d2) round(0.5*d2)];
%l_width = d2;
%l_len = [0.75 0.5 0.4];

%Nb_probe = length(l_h_bot);
Nb_probe = length(l_width);
%Nb_probe = length(l_len);


%for l=1:Nb_probe
%l_h_bot_comp_ref = LIP_imcomplement(l_h_bot(1),M); % reference value for the central segment value of the probe
flag_continue = true;
l = 1;
while ( l<=Nb_probe && flag_continue )
    info_probe.width        = l_width(l);  % width of the probe
    %info_probe.width        = d2;  % width of the probe
    info_probe.len          = 2*floor(round(0.75*info_probe.width )/2)+1; % length of the probe in one directionr
    %info_probe.len          = 2*floor(round(l_len(l)*info_probe.width )/2)+1; % length of the probe in one directionr
    val_probe   = LIP_imcomplement([h_top l_h_bot h_top],M);
    %val_probe   = LIP_imcomplement([h_top l_h_bot(l) h_top],M);
    info_probe.val_probe = val_probe;
    %gamma = LIP_imsubtract( l_h_bot_comp_ref , val_probe(2) , M )
    
    %fprintf('val_probe %d / %d \t %.02f %% \t width = %.02f \n',l,Nb_probe, l/Nb_probe*100 , info_probe.width);
    fprintf('val_probe %d / %d \t %.02f %% \t width = %.02f \t len = %.02f \n',l,Nb_probe, l/Nb_probe*100 , info_probe.width, info_probe.len);
    for k = 1:Nb_angle
        
        % information for the probe
        info_probe.ang = liste_angle(k);
        if para_disp.flag_detail
            fprintf('\t%d / %d \t %.02f %% \t angle = %.02f °\n',k,Nb_angle, k/Nb_angle*100 , info_probe.ang);
        end
        
        %% Finding the infimum of the LAC between the erosions with 2 segments and 3 segments
        [map_ang,~,~,~,im_c2_ang]                   = DR_VES_bump_tracker_one_ang( im_grey_comp , ...
            im_msk, info_probe, M );
        %map_ang                                     = LIP_imadd( map_ang , gamma , M );
        msk_map_vessel_detector                     = map_ang < map_vessel_detector;
        map_vessel_detector(msk_map_vessel_detector)= map_ang(msk_map_vessel_detector);
        im_c2(msk_map_vessel_detector)              = im_c2_ang(msk_map_vessel_detector);
        im_ind_ang_map(msk_map_vessel_detector)     = k;    % direction angle
        k_or                                        = i_similar(k);
        im_ind_ang_or(msk_map_vessel_detector)      = k_or; % orientation angle
        im_ind_probe_map(msk_map_vessel_detector)   = l;
    end
    %% Map of vessel detectors
    im_ind_ang_or(~im_msk)          = 1;
    im_ang_or_detector              = liste_angle(im_ind_ang_or); % image of the angles
    im_ind_probe_map(~im_msk)       = 0;
    map_vessel_detector(~im_msk)    = 0;
    im_c2(~im_msk)                  = 0;
    
    %% Display
    if para_disp.flag_display
        para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
        para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
        imagesc( map_vessel_detector ); axis equal; title(sprintf('Map vessel detector iter %d',l)); colormap parula
        
%         para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
%         para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
%         imagesc( im_c2 ); axis equal; title(sprintf('Image of constants iter %d',l)); colormap parula
%         
%         para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
%         para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
%         histogram(im_c2(im_msk), (round(min(im_c2(im_msk))):round(max(im_c2(im_msk))))+0.5);
%         title(sprintf('Histogram of constants iter %d',l));
%         mu = mean(im_c2(im_msk));
%         sigma = std(im_c2(im_msk));
%         msk_fbd = im_c2<mu-2*sigma;%forbidden zones
%         
%         para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
%         para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
%         imagesc( msk_fbd ); axis equal; title(sprintf('Forbidden zones iter %d',l)); colormap parula
    end
    
    %% Threshold
    
    %if 1%l==1
    [th , mu , para_disp] = compute_threshold_map( map_vessel_detector , im_msk , M , para_disp);
    %th = LIP_immultScalar( LIP_imsubtract( val_probe(2) , val_probe(1) , M ) , 0.85, M);
    %end
    im_msk_vessels = map_vessel_detector<th;
    im_msk_vessels(~im_msk) = false;
    im_msk_vessels = bwareaopen(im_msk_vessels,th_area_mini,8);
    
    if para_disp.flag_display
        para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
        para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
        imagesc( im_msk_vessels ); axis equal;  hold on; %colormap gray
        %title(sprintf('threshold of bump detector map (elongation) iter = %d',l));
        title(sprintf('threshold of bump detector map iter %d',l));
    end

    %% break on the variation of area between segmentations
    if l>1
        area_var = sum(xor(im_msk_vessels(im_msk),im_msk_vessels_ini(im_msk)))/area_seg_ini;
        fprintf('area variation = %.02f %%\n',area_var*100);
        %isequal(im_msk_vessels,im_msk_vessels_prev)
    else
        im_msk_vessels_ini = im_msk_vessels;
        area_seg_ini = sum(im_msk_vessels(im_msk));
    end
    
    if (l>1) &&( area_var > th_area_var )
        fprintf('Stop iteration at l = %d\n',l);
        fprintf('Segmentation of iteration  %d is kept\n',l-1);
        flag_continue = false;%false;
        
        % choosing the correct results
        im_ind_ang_or = im_ind_ang_or_prev;
        im_ang_or_detector = im_ang_or_detector_prev;
        map_vessel_detector = map_vessel_detector_prev;
        im_c2 = im_c2_prev;
        im_msk_vessels = im_msk_vessels_prev;
        mu = mu_prev;
        th = th_prev;
    else
        % saving the previous results
        im_ind_ang_or_prev = im_ind_ang_or;
        im_ang_or_detector_prev = im_ang_or_detector;
        map_vessel_detector_prev = map_vessel_detector;
        im_c2_prev = im_c2;
        im_msk_vessels_prev = im_msk_vessels;
        mu_prev = mu;
        th_prev = th;
    end
    
    l = l+1;
end

%% Display
if para_disp.flag_display
    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
    imagesc( map_vessel_detector ); axis equal; title('Minimum of LAC erosions tol'); colormap parula
    
    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
    imagesc( im_c2 ); axis equal; title(sprintf('Image of constants',l)); colormap parula    

    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
    imagesc(im_ind_probe_map); axis equal; title('Optimal val_probe indices'); colormap parula

    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
    imagesc(im_ind_ang_or); axis equal; title('Optimal orientation indices'); colormap hsv

    liste_angle_orienta = liste_angle(i_in);
    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
    histogram(im_ind_ang_or(im_msk), (0:length(liste_angle_orienta))+0.5);
    ticks=xticks();  xticklabels(liste_angle_orienta(ticks+1));   title('Histogram of the orientation angles (LIP-dilation)')
end

%% Post processing of the segmentation

[im_msk_vessels , para_disp] = map_threshold_post_process( im_msk_vessels , ...
   th_eccentricity , th_solidity , D , para_disp);

if para_disp.flag_display
    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
    imagesc( im_msk_vessels ); axis equal;  hold on; %colormap gray
    title('threshold of bump detector map (elongation)');

    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
    imagesc(im_grey_comp); axis equal; hold on; colormap gray
    border_vessels = bwboundaries(im_msk_vessels);
    for n=1:length(border_vessels);       bv_ij = border_vessels{n};    plot( bv_ij(:,2) , bv_ij(:,1), 'w-' );    end
    title('Complemented image with vessels')

    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
    imagesc(map_vessel_detector); axis equal; hold on
    for n=1:length(border_vessels);       bv_ij = border_vessels{n};    plot( bv_ij(:,2) , bv_ij(:,1), 'w-' );    end
    title('bump detector map with vessels');
end

%% Normalisation of the map detector
map_vessel_detector_norm = map_vessel_detector;
map_vessel_detector_norm( map_vessel_detector_norm > mu ) = mu;
map_vessel_detector_norm = 1-stretchimageTo(map_vessel_detector_norm,[0 1]);
map_vessel_detector_norm(~im_msk)    = 0;

if para_disp.flag_display
    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
    imagesc( map_vessel_detector_norm ); axis equal;  hold on; %colormap gray
    title('Normalisation of the map of bump detector');
end

%% Direction

%[ Dx, Dy , xx , yy ] = DR_VES_map_vesselness_with_orientations( map_vessel_detector, im_ang_or_detector , im_msk , im_msk_vessels , M );

end
%% Parse inputs

function [ im_grey , im_msk, M , coeff_D1 , coeff_D2 , D , para_disp ] = parse_inputs( im_grey , im_msk, M , varargin )

p = inputParser;
default_coeff_D1 = 1/5;
default_coeff_D2 = 1/74;
default_D = [];
default_para_disp.flag_display              = false;%true;%false
default_para_disp.flag_detail               = false;
default_para_disp.tab_fig                   = NaN(1,100);
default_para_disp.cpt_fig                   = 0;
default_para_disp.cpt_pos                   = 0;

addRequired(p,'imin',@isnumeric);
addRequired(p,'im_msk',@(x) islogical(x) && isequal(size(im_grey),size(x)) );
addRequired(p,'M',@(x) isnumeric(x) && ismember( M ,  [ 2^8  2^16  2^32  2^64 ] ));
addOptional(p,'coeff_D1',default_coeff_D1,@(x) isscalar(x) && (x>=0) && (x<=1));
addOptional(p,'coeff_D2',default_coeff_D2,@(x) isscalar(x) && (x>=0) && (x<=1));
addOptional(p,'D',default_D,@(x) isnumeric(x));
addOptional(p,'para_disp',default_para_disp,@isstruct);

parse( p , im_grey , im_msk, M , varargin{:} );
coeff_D1    = p.Results.coeff_D1;
coeff_D2    = p.Results.coeff_D2;
D           = p.Results.D;
para_disp   = p.Results.para_disp;

end

%% Threshold function


function [im_msk_vessels , mu , para_disp] = map_threshold( map_vessel_detector ,  ...
    im_msk , M , th_area_mini, th_eccentricity , th_solidity , D , para_disp)

% Display
% Position of the figures
%pos_windows = FIG_get_pos_figs();

[ th , mu , para_disp] = compute_threshold_map( map_vessel_detector , im_msk , M , th_area_mini, para_disp);

im_msk_seg = map_vessel_detector<th;
im_msk_seg(~im_msk) = false;
im_msk_seg = bwareaopen(im_msk_seg,th_area_mini,8);

if para_disp.flag_display       
    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
    imagesc( im_msk_seg ); axis equal;  hold on; %colormap gray
    title('threshold of Vesselness th1');
end

%% Post processing of the segmentation

[im_msk_vessels , para_disp] = map_threshold_post_process( im_msk_seg , ...
    th_area_mini, th_eccentricity , th_solidity , D , para_disp);

end

%% compute Threshold function

function [th , mu , para_disp] = compute_threshold_map( map_vessel_detector ,  ...
    im_msk , M , para_disp)

% Display
% Position of the figures
pos_windows = FIG_get_pos_figs();

% Histogram
[BinCounts,BinEdges] = histcounts(map_vessel_detector(im_msk), (0:(M-1))+0.5);
BinCounts_norm = BinCounts/sum(BinCounts); % histogram normalisation

if para_disp.flag_detail
    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    fig_hist = para_disp.tab_fig(para_disp.cpt_fig);
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
    %hist_vesselness = histogram(map_vessel_detector(im_msk), (0:(M-1))+0.5);
    histogram('BinEdges',BinEdges,'BinCounts',BinCounts_norm); hold on;
    xlim([0 M-1]);
    title(sprintf('Histogram of the map of bum detectors'))
end

[maxi_hist,ind_max]=max(BinCounts_norm);
%mu = ceil(BinEdges(ind_max));
%mu = max(map_vessel_detector(im_msk));
%[~,ind_max2]=max(BinCounts_norm(1:ind_max-1));
%th1 = ceil(BinEdges(ind_max2));
% peak extraction on the left
% h = 0.1/100*maxi_hist;
% [~,IdxList_max ]=SGN_maxima(BinCounts_norm(1:ind_max-1) , h );
% if length(IdxList_max) > 2
%     th1 = IdxList_max{end-1};
% else
%     th1 = IdxList_max{1}
%     disp 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
% end
%sigma = std(map_vessel_detector(im_msk));
% nb_sigma = 1;
% th_low = (mu-nb_sigma*sigma);

mu = median(map_vessel_detector(im_msk));
map_vessel_detector_th = map_vessel_detector;
map_vessel_detector_th( map_vessel_detector_th > mu ) = mu;
map_vessel_detector_th(~im_msk)    = 0;

maxi = max(map_vessel_detector_th(im_msk));
pct_area_th = 12/100;
th2 = maxi-ThresholdAreaPercentage( maxi-map_vessel_detector_th(im_msk) , pct_area_th );

%th_diff_min = 5/60*mu;%minimal difference for the threshold
%[th,ind_min] = min([th1 , mu-th_diff_min , th2])
% [th,ind_min] = min([th1 , mu-th_diff_min])
%[mu-th_diff_min , th2]
%[th,ind_min] = min([mu-th_diff_min , th2])
%[th,ind_min] = min([th1 , th2])
% if ind_min==3
%    disp 'th percentage !!!!!!!!!!!';
% else
%     disp ''
% end
%th = th1
th = th2;%
%th = mu-th_diff_min;


%th = (th1+mu)/2 -1;

%pct_area_th_select = 3/100;
%th_select = min(th-10,maxi-ThresholdAreaPercentage( maxi-map_vessel_detector(im_msk) , pct_area_th_select ));

if para_disp.flag_detail
    figure(fig_hist);
    plot([th th],[0 maxi_hist],'r-','Linewidth',1);
    %plot([th_select th_select],[0 maxi_hist],'g-');
    fprintf('th = %d\n',th);
end


end

%% Post processing of the segmentation

function [im_msk_vessels , para_disp] = map_threshold_post_process( im_msk_seg , ...
    th_eccentricity , th_solidity , D , para_disp)

% Display
% Position of the figures
pos_windows = FIG_get_pos_figs();

%% Filtering with elongation

%im_msk_seg = DR_VES_fill_holes( im_msk_seg , n_dil );

%th_area_max = ((D/2)^2)/20; % area for whic the structures are considered as vessels
th_MajorAxisLength = D*25/100;
% Removing the CC with a maximum less than
CC = bwconncomp(im_msk_seg);

if para_disp.flag_display
    para_disp.cpt_fig = para_disp.cpt_fig + 1; para_disp.tab_fig(para_disp.cpt_fig) = figure(para_disp.cpt_fig); clf;
    para_disp.cpt_pos = para_disp.cpt_pos + 1; set(para_disp.tab_fig(para_disp.cpt_fig),'OuterPosition',pos_windows(para_disp.cpt_pos,:));
    imagesc( labelmatrix(CC) ); axis equal;  hold on; %colormap gray
    title('Labels of the connected components');
end

%l_param = regionprops(CC, 'Area','MajorAxisLength','ConvexArea','Eccentricity');
%th_elong = 0.05; % threshold on elongation
%l_param = regionprops(CC, im_ind_ang_or, 'Area','Solidity','FilledArea',...
%    'Eccentricity','MajorAxisLength','PixelValues');
% l_param = regionprops(CC, 'Solidity','Eccentricity','MajorAxisLength');
% 
% %fig_hist = figure;
% for n =1:length(l_param)
%     %if l_param(n).Area < th_area_max
%     % if max(l_param(n).BoundingBox(3:4)) < th_MajorAxisLength
%     %if l_param(n).MajorAxisLength < th_MajorAxisLength
%         %if ((l_param(n).FilledArea)/(l_param(n).ConvexArea)) > th_solidity
%         if l_param(n).Solidity > th_solidity
%             %if (l_param(n).Area/l_param(n).FilledArea) > th_solidity
%             %elong = (l_param(n).ConvexArea/(pi*(l_param(n).MajorAxisLength)^2));
%             %if  elong > th_elong
%             if l_param(n).Eccentricity < th_eccentricity
%                 im_msk_seg(CC.PixelIdxList{n}) = false;
%             end
%         end
%         
%    % end
% end

% th_area_max= ((D/2)^2)/20; % area for whic the structures are considered as vessels
% % Removing the CC with a maximum less than
% CC = bwconncomp(im_msk_seg);
% l_param = regionprops(CC, 'Area','MajorAxisLength','ConvexArea');
% for n =1:length(l_param)
%     if l_param(n).Area < th_area_max
%         elong = (l_param(n).ConvexArea/(pi*(l_param(n).MajorAxisLength)^2));
%         if  elong > th_elong
%             im_msk_seg(CC.PixelIdxList{n}) = false;
%         end
%     end
% end

n_dil = 1;%2;%max(2,round(d2/6)); % number of dilations to fill the holes of the vessels
% Filling the holes a second time
%im_msk_seg = ImASF(im_msk_seg, strel('disk',1),2,'CloseOpen');
im_msk_seg = DR_VES_fill_holes( im_msk_seg , n_dil );
im_msk_vessels = im_msk_seg;

end