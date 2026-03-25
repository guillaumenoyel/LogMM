
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  2D symmetric Gaussian probe with a ring
%  The Gaussian is scaled
%
% [ SE_probe , msk_not_tol ] = strel_Ring_Gaussian( sigma_pix , r_ext, r_int , 
%       delta_h_centre , h_ring , h_bot , h_back )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%   sigma_pix           % standard deviation (in pixels) of the central peak
%   r_ext               % external radius of the ring in pixels : ex : 15
%   r_int               % internal radius of the ring in pixels : ex : 10
%   delta_h_centre      # variation of the height of the Gaussian top from the
%                           height of the bottom (or h_ring)
%                           could be a n-vector for a color [15 250 21] or
%                           a n-vector [15 250]
%   h_ring              # the height of the ring
%                           could be a n-vector for a color [15 250 21] or
%                           a n-vector [15 250]
%   h_bot               # (option) height of the bottom of the gaussian
%                           Default h_ring
%   h_back              # (option) height of the background of the probe
%                           default : zero  
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%   SE_probe             # probe as a structuring element
%                           msq_probe = SE_probe.getnhood;
%                           im_probe = SE_probe.getheight;
%   msk_not_tol         # mask of the points not submitted to the tolerance
%                           (i.e. the peak)
%   SE_R                # structuring element ring
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% strel_Ring_Gaussian.m
% Guillaume NOYEL 15-12-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ SE_probe , msk_not_tol , SE_R ] = strel_Ring_Gaussian( sigma_pix , r_ext , r_int, delta_h_centre , h_ring , varargin )

%% Input management

[sigma_pix , r_ext , r_int , delta_h_centre , h_ring , h_bot , h_back , DP] = ...
    parse_inputs( sigma_pix , r_ext , r_int, delta_h_centre , h_ring , varargin{:} );

%% Paramètres

flag_disp = false;%false;


%% Program
flag_colour = DP>1; % flag for a n-vector


Nb_sigma = 3;

[xx,yy]                 = meshgrid(-r_ext:r_ext);
SZ_probe                = size(xx);
nhood_ring_support      = and( (xx.^2 + yy.^2 <= r_ext^2) , (xx.^2 + yy.^2 >= r_int^2) );
nhood_centre_support    = (xx.^2 + yy.^2 <= (Nb_sigma*sigma_pix)^2);
% nhood_back_support      = imfill(nhood_ring_support,'holes');
% nhood_back_support      = minus_binary_images(nhood_back_support,nhood_ring_support);
% nhood_back_support      = minus_binary_images(nhood_back_support,nhood_centre_support);

if flag_colour
    nhood_ring          = repmat(nhood_ring_support   , [1 1 DP]);
    nhood_centre        = repmat(nhood_centre_support , [1 1 DP]);
    %nhood_back          = repmat(nhood_back_support   , [1 1 DP]);
else
    nhood_ring          = nhood_ring_support; 
    nhood_centre        = nhood_centre_support;
    %nhood_back          = nhood_back_support;
end
%clear nhood_ring_support nhood_centre_support nhood_back_support;

% Neighbourhood
%nhood_ini           = or( or(nhood_ring,nhood_centre) , nhood_back );
nhood       = or(nhood_ring,nhood_centre);

% Gaussian
%G_can = fspecial('gaussian', sz_support, sigma_pix) ;

filterG = generateBasisGaussFilter2D( sigma_pix , Nb_sigma );
G_can = filterG.g0_y' * filterG.g0_x;
G_can = padarray( G_can , (SZ_probe-size(G_can))/2 );

if flag_colour
    im_Gaussian             = zeros([SZ_probe,DP]);
    %Gaussian scaling
    for k = 1:DP
        im_Gaussian(:,:,k)  = (G_can/max(G_can(:)))*delta_h_centre(k) + h_bot(k);
    end
else
    im_Gaussian = (G_can/max(G_can(:)))*delta_h_centre + h_bot;
end

% Height
im_probe                    = repmat(reshape(h_back,[1 1 DP]),SZ_probe(1:2));
im_probe                    = imhsp_mskfill( im_probe , repmat( h_ring   , sum(sum(nhood_ring(:,:,1)))   , 1 ) , nhood_ring(:,:,1)   );
im_probe                    = imhsp_mskfill( im_probe, imhsp_mskextract( im_Gaussian , nhood_centre(:,:,1) ) , nhood_centre(:,:,1) );
%im_probe(~nhood) = 0; % to remove the background points which are not useful

SE_probe = strel('arbitrary', nhood, im_probe);

% Mask of the probe pixels outside of the tolerance
msk_not_tol = nhood_centre;

% structuring function ring
msk_nhood = SE_probe.Neighborhood();
msk_nhood(msk_not_tol) = false;
im_nhood = SE_probe.getheight();
im_nhood(msk_not_tol) = 0;
SE_R = strel( 'arbitrary' , msk_nhood , im_nhood );

if flag_disp
    
    figure;
    subplot(1,3,1);
    imagesc(nhood(:,:,1));
    title('Mask of the probe')
    
    subplot(1,3,2);
    if flag_colour
        if DP == 3
            imagesc(uint8(im_probe));
        else
            imagesc(mean(im_probe,3));
        end
    else
        imagesc(im_probe);
    end
    title('Height of the probe')
    
    hp1_3 = subplot(1,3,3);
    if flag_colour
        if DP == 3
            surf(double(rgb2gray(uint8(im_probe))));
        else
            surf(mean(im_probe,3));
        end
    else
        surf(im_probe);
    end
    shading interp;
    set(hp1_3,'YDir','reverse');
    title('Height of the probe (in gray)')
    
    if flag_colour
        figure;
        hp2_1 = subplot(1,3,1);
        surf(im_probe(:,:,1)); shading interp;
        set(hp2_1,'YDir','reverse');
        title('Height of the probe (Red)');

        if(DP>1)
        hp2_2 = subplot(1,3,2);
        surf(im_probe(:,:,2)); shading interp;
        set(hp2_2,'YDir','reverse');
        title('Height of the probe (Green)');
        end

        if(DP>2)
        hp2_3 = subplot(1,3,3);
        surf(im_probe(:,:,3)); shading interp;
        set(hp2_3,'YDir','reverse');
        title('Height of the probe (Blue)');
        end
    else
        hp2 = figure;
        surf(im_probe); shading interp;
        set(gca_fig(hp2),'YDir','reverse');
        title('Height of the probe');
    end
end

end

%% Input management
function [sigma_pix , r_ext , r_int , delta_h_centre , h_ring , h_bot , h_back , DP] = ...
    parse_inputs( sigma_pix , r_ext , r_int, delta_h_centre , h_ring , varargin)


p = inputParser;
default_h_bot = h_ring;
default_h_back = zeros(size(h_ring));

addRequired(p,'sigma_pix',@(x) isscalar(x) && isnumeric(x));
addRequired(p,'r_ext',@(x) isscalar(x) && isnumeric(x));
addRequired(p,'r_int',@(x) isscalar(x) && isnumeric(x));
addRequired(p,'delta_h_centre',@(x) isnumeric(x) && isvector(x));
addRequired(p,'h_ring',@(x) isnumeric(x) && isvector(x) && isequal(length(x),length(delta_h_centre)) );
addOptional(p,'h_bot',default_h_bot,@(x) isnumeric(x) && isvector(x) && isequal(length(x),length(h_ring)));
addOptional(p,'h_back',default_h_back,@(x) isnumeric(x) && isvector(x) && isequal(length(x),length(h_ring)));

parse( p , sigma_pix , r_ext , r_int , delta_h_centre , h_ring , varargin{:} );
h_bot = p.Results.h_bot;
h_back = p.Results.h_back;

delta_h_centre    = delta_h_centre(:)';
h_ring            = h_ring(:)';
h_bot             = h_bot(:)';
h_back            = h_back(:)';

% flag for the colour mode (true) or the gray mode (false)
DP = length(delta_h_centre);
       

end
