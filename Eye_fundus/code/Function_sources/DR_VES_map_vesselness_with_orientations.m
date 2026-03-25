
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Map of vesselness with orientations
%
% [ Dx, Dy , xx , yy , mu , alpha ] = DR_VES_map_vesselness_with_orientations( ...
%    map_vessel_detector, im_ang_or_detector , im_msk_vessels )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% INPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% map_vessel_detector       # Map of the vessel detector (map of vesselness)
% mu                        # median of map_vessel_detector(im_msk_vessels)
% im_ang_or_detector        # Map of the orientation angles (in degrees)
% im_msk                    # mask image (logical)
% im_msk_vessels            # Mask of the vessels
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% OUTPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% Dx                        # x-component of the orientation vectors
%                               Dx = exp( -map_vessel_detector/alpha ).*cos(im_ang_or_detector*pi/180)
% Dy                        # y-component of the orientation vectors
%                               Dy = exp( -map_vessel_detector/alpha ).*sin(im_ang_or_detector*pi/180)
% xx                        # x-origin of the orientation vectors
% yy                        # y-origin of the orientation vectors
%                               The oreintations vectors are weighted by the
%                               map of vessel detectors
% alpha                     # alpha parameter (mu/2)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DR_VES_map_vesselness_with_orientations.m
% Guillaume NOYEL 09-09-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ Dx, Dy , xx , yy , alpha ] = DR_VES_map_vesselness_with_orientations( ...
    map_vessel_detector, mu , im_ang_or_detector , im_msk, im_msk_vessels )


%% Parameters

flag_disp = false;%false;% display flag

%% Inputs management

%% Influential parameters


%% Direction

% Histogram
% [BinCounts,BinEdges] = histcounts(map_vessel_detector(im_msk), (0:(M-1))+0.5);
% 
% if flag_disp
%     figure;%
%     %hist_vesselness = histogram(map_vessel_detector(im_msk), (0:(M-1))+0.5);
%     histogram('BinEdges',BinEdges,'BinCounts',BinCounts);
%     title(sprintf('Histogram of the map of bum detectors'))
% end
% 
% [~,ind_max]=max(BinCounts);
% mu = ceil(BinEdges(ind_max));
%v = map_vessel_detector(im_msk);
%mu = max( round(v) );
%sigma = sqrt(sum((v-mu).^2)/(length(v)-1));

alpha = mu/2; % paramters to weigh the orientations vectors

SZim = size(im_msk);
im_r =  exp( -map_vessel_detector/alpha );
%im_r =  exp( -((map_vessel_detector)/(sqrt(2)*sigma)) );
im_r(~im_msk_vessels) = 0;
[xx,yy] = meshgrid(1:SZim(2) , 1:SZim(1));
Dx = im_r.*cos(im_ang_or_detector*pi/180); % x component
Dy = im_r.*sin(im_ang_or_detector*pi/180); % y component
% Dx = cos(im_ang_or_detector*pi/180); % x component
% Dy = sin(im_ang_or_detector*pi/180); % y component

if flag_disp
    t=0:M; % grey levels of the distance
    figure; plot( t, exp( -t/alpha ) )
    title('Directional intensity versus')
%     
%     figure; imagesc(im_r); axis equal
%     title('Vesselness')
    
    figure;
    imagesc( map_vessel_detector ); axis equal;  hold on; title(sprintf('Map of bumb detectors with orientations'));
    quiver( xx(im_msk_vessels) , yy(im_msk_vessels) , Dx(im_msk_vessels) , Dy(im_msk_vessels) , 0 , 'r' );
end

end
