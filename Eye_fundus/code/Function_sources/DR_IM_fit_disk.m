
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Disk fitting over the mask of the eye fundus image
%
% [centre , R_c] = DR_IM_fit_disk( im_msk )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% INPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im_msk                # mask of the image (after suppresion of white dots)
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% OUTPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% centre                # centre of the disk [x y]
% R_c                   # radius of the disk
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DR_IM_fit_disk.m
% Guillaume NOYEL 07-10-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [centre , R_c] = DR_IM_fit_disk( im_msk )


%% Parameters

flag_display = false;%true;%false;

%% Inputs management




%% Fit of a disk

SZ = size(im_msk);


% Extraction of the border
border_msk = bwboundaries(im_msk);
border_msk = [border_msk{1}(:,2) , border_msk{1}(:,1)];


%%  curvature estimation
BB = get_1_BoundingBox(im_msk);
d_appear = max( BB(2) - BB(1) , BB(4) - BB(3) ); %appearant diameter

dRayonMin = round(d_appear/6);
horizon = round(dRayonMin/3); % horizon of observation before and after the poiint
N_pts = size(border_msk,1);
vXYCentre = NaN(N_pts,2);
rCourbure = NaN(N_pts,1);
bLigne = false(N_pts,1);
err_moy = NaN(N_pts,1);
warning('off')
for n=1:N_pts
    vect_ind = (n-1-horizon):(n-1+horizon);
    vect_ind = mod(vect_ind,N_pts)+1; % circular horizon
    pts_xy = border_msk(vect_ind,:);
    [vXYCentre(n,:), rCourbure(n), bLigne(n), err_moy(n)] = estimerCourbure(pts_xy, dRayonMin);
end
warning;

% ind = (border_msk(:,2) ~= sz1+1);
% ind = ind & (border_msk(:,2) ~= SZ(1)-sz1);
% border_msk = border_msk(ind,:);

% removing the side effects of the line detection part
sz = round(dRayonMin/2);
sz = sz + 1*(mod(sz+1,2));
se = strel('line',sz,90);
bLigne = MorphologicalOperationWithPad(bLigne(:),'imdilate',se,'circular');

%% Circle fitting
Par_c = CircleFit_TaubinSVD(border_msk(~bLigne,:));
x_c = Par_c(1);
y_c = Par_c(2);
R_c = Par_c(3);
centre = [x_c,y_c];

if flag_display
    figure;
    imagesc(im_msk); colormap gray; hold on;
    plot( border_msk(:,1) , border_msk(:,2) , 'b-' );
    X_d = border_msk(:,1);
    Y_d = border_msk(:,2);
    plot( X_d(~bLigne) , Y_d(~bLigne) , 'g*' );
    plot_circle(x_c,y_c,R_c,'r');
    plot(x_c,y_c,'r*');
    title('Disk fitting over the mask')
    axis equal
end

end