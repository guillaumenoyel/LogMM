%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the surface of a probe and an image around the probe
%
% [h_fig, h_surf_im , h_surf_probe] = surf_imAndProbe( imin , im_probe , Pt , msk_probe , im_msk , h_fig , flag_disp_ctc_points )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imin                # input image
% im_probe            # height of the structuring element
% Pt                  # Pt : considred point of the image to compute the
%                       distance [x,y]
% msk_probe           # (option) binary mask of the structuring element
%                        Default: the whole image strel.
%                           msk_probe = [] gives the default value
% im_msk              # (optional) 2D binary mask image.
%                        Default value: the whole image
%                           im_msk = [] gives the default value
% h_fig               # (option) figure handle
%                        Default: creation of a new figure
%                           h_fig = [] gives the default value
% flag_disp_ctc_points # (option) flag to display contact points (true or
%                       false). 
%                       Default value: true;
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% h_fig                # figure handle
% h_surf_im            # handle of the surf plot of the image
% h_surf_probe         # handle of the surf plot of the probe
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% surf_imAndProbe.m
% Guillaume NOYEL 13-12-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [h_fig, h_surf_im , h_surf_probe] = surf_imAndProbe( imin , im_probe , Pt , varargin )


%% Input management

[ imin , im_probe , Pt , msk_probe , im_msk , h_fig , flag_disp_ctc_points ] = parse_inputs( imin , im_probe , Pt , varargin{:} );

%% Checking the data

SZ_im = size(imin);

%Nb_can = 3;%size(imin,3);

SZ_ZOI = size(im_probe);
if (mod(SZ_ZOI(1),2)==0) || (mod(SZ_ZOI(1),2)==0)
    error('Probe size has to be odd');
end

%% Management of the points outside of the mask
imin(~im_msk) = NaN;

%% Program
DP = 1;

%% Extracting the ZOI

centre_se = get_strel_centre(im_probe); % centre of the probe

BB_ini = [ Pt(1)-(centre_se(2)-1) , ...
    Pt(1)+(centre_se(2)-1) , ...
    Pt(2)-(centre_se(1)-1) , ...
    Pt(2)+(centre_se(1)-1) ]; % Bounding box

BB = [ max( 1 , BB_ini(1) ) , ...
    min( SZ_im(2) , BB_ini(2) ) , ...
    max( 1 , BB_ini(3) ) , ...
    min( SZ_im(1) , BB_ini(4) ) ]; % Bounding box

[xx,yy] = meshgrid( BB_ini(1):BB_ini(2) , BB_ini(3):BB_ini(4) );
msk_ZOI = repmat( and( and( xx > 0 , xx<= SZ_im(2) ) , and( yy >0 , yy <= SZ_im(1) ) ) , [1 1 DP]);
clear xx yy;
imZOI = NaN(SZ_ZOI);
imZOI(msk_ZOI) = imin( BB(3):BB(4) , BB(1):BB(2) , : );


%% Image por the probe
im_probe( ~msk_probe ) = NaN;
%imZOI(~SE_probe.getnhood()) = NaN;


%% Finding the points which are in contact
ind_ctc_c1 = find(abs(double(imZOI(:)) - im_probe(:))<1e-12);%indices of the contact points
[ Y_ctc_c1 , X_ctc_c1 ] = ind2sub(SZ_ZOI,ind_ctc_c1);

% Pts_ctc_c1 = cell(1,DP);
% for k=1
%     msk_ind = C_ctc_c1==k;
%     if any(msk_ind)
%         Pts_ctc_c1{k} = [X_ctc_c1(msk_ind) , Y_ctc_c1(msk_ind)];
%     else
%         Pts_ctc_c1{k} = zeros(0,DP);
%     end
% end

%% Displaying upper and lower probe
%imZOI(isnan(imZOI))=0;
figure(h_fig);
set(h_fig,'Name',sprintf('Point (%d,%d)',Pt(1) , Pt(2)));
hold on
h_surf_im = surf(double(imZOI)); shading interp; %axis equal;
h_surf_probe = surf(double(im_probe)); 
if ~isempty(Y_ctc_c1) && flag_disp_ctc_points
    plot3( X_ctc_c1 , Y_ctc_c1 , imZOI(sub2ind(SZ_ZOI,Y_ctc_c1,X_ctc_c1)) , 'm*' );
    plot3( X_ctc_c1 , Y_ctc_c1 , imZOI(sub2ind(SZ_ZOI,Y_ctc_c1,X_ctc_c1)) , 'co' );
    title('Image and probe');
else
    title('Image and upper probe (no contact pts)');
end
set(gca_fig(h_fig),'YDir','reverse');


end

%% parse_inputs

function [ imin , im_probe , Pt , msk_probe , im_msk , h_fig , flag_disp_ctc_points ] = parse_inputs( imin , im_probe , Pt , varargin )

p = inputParser;
default_msk_probe = true(size(im_probe));
default_im_msk = true(size(imin));
default_h_fig = figure();
default_flag_disp_ctc_points = true;

addRequired(p,'imin',@(x) isnumeric(x));
addRequired(p,'im_probe',@(x) isnumeric(x));
addRequired(p,'Pt',@(x) isvector(x) && (length(x)==2) );
addOptional(p,'msk_probe',default_msk_probe,@(x) islogical(x) && isequal(size(x),size(im_probe)) );
addOptional(p,'im_msk',default_im_msk,@(x) isempty(x) || (islogical(x) && isequal(size(x),size(imin))) );
addOptional(p,'h_fig',default_h_fig,@(x) isempty(x) || ishandle(x) );
addOptional(p,'flag_disp_ctc_points',default_flag_disp_ctc_points,@(x) isempty(x) || (islogical(x) && isscalar(x)) );


parse( p , imin , im_probe , Pt , varargin{:} );
msk_probe = p.Results.msk_probe;
im_msk = p.Results.im_msk;
h_fig = p.Results.h_fig;
flag_disp_ctc_points = p.Results.flag_disp_ctc_points;

if isempty(im_msk)
    im_msk = default_im_msk;
end
if isempty(h_fig)
    h_fig = default_h_fig;
end


end
