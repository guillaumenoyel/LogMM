
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Segmentation comparison between the masks of the True Positive, Flase Positive, True
% Negative and False Positive pixels
%
% [im_ves_comp ] = im_comparison_segmentations( msk_TP , msk_FP , msk_TN , msk_FN )
%
% [im_ves_comp ] = im_comparison_segmentations( msk_TP , msk_FP , msk_TN , msk_FN , c_TN , c_TP , c_FP , c_FN , c_other )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% INPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% msk_TP            : binary image of the true negatives (TP)
% msk_FP            : binary image of the false positives (FP)
% msk_FN            : binary image of the false negatives (FN)
% msk_TN            : binary image of the true negatives (TN)
% c_TN              : (option) colour of the TN. Default white [255 255 255]
% c_TP              : (option) colour of the TP. Default black [0 0 0]
% c_FP              : (option) colour of the FP. Default cyan [0 255 255]
% c_FN              : (option) colour of the FN. Default red [255 0 0];
% c_other           : (option) colour of the other pixels. Default white [0 0 0]
%                       Could be e.g. [127 127 127]; 
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% OUTPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im_ves_comp      # colour image for the segmentation comparison
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% im_comparison_segmentations.m
% Guillaume NOYEL 17-09-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ im_ves_comp ] = im_comparison_segmentations( msk_TP , msk_FP , msk_TN , msk_FN ,  varargin )


%% Parameters

% diplay flag

flag_disp = false;%true;

%% Input management

[ c_TN , c_TP , c_FP , c_FN , c_other ] = parse_inputs( varargin{:} );

%% Programme

SZ = size(msk_TP);


im_ves_comp = repmat(reshape(uint8(c_other),1,1,3),SZ);  % other values
im_ves_comp = imhsp_mskfill(im_ves_comp,c_TN,msk_TN); % true negatives
im_ves_comp = imhsp_mskfill(im_ves_comp,c_TP,msk_TP); % true positives
im_ves_comp = imhsp_mskfill(im_ves_comp,c_FP,msk_FP); % FP
im_ves_comp = imhsp_mskfill(im_ves_comp,c_FN,msk_FN); % FN

if flag_disp
    figure;
    imagesc(im_ves_comp); axis equal
    title('Comparison: white (TN), black (TP), cyan (FP), red (FN)');
end

end

%% Parse inputs


function [ c_TN , c_TP , c_FP , c_FN , c_other ] = parse_inputs( varargin )

p = inputParser;
M = 256;
default_c_TN    = repmat(M-1,1,3); % colour of the TN - white
default_c_TP    = zeros(1,3); % colour of the TP - black
default_c_FP    = [0 M-1 M-1];% colour of the FP - cyan
default_c_FN    = [M-1 0 0];% colour of the FN - red
default_c_other = repmat(M-1,1,3);%repmat(M/2,1,3); % colour of the other pixels default - white

addOptional(p,'c_TN',default_c_TN,@(x) isvector(x) && isequal(3,length(x)));
addOptional(p,'c_TP',default_c_TP,@(x) isvector(x) && isequal(3,length(x)));
addOptional(p,'c_FP',default_c_FP,@(x) isvector(x) && isequal(3,length(x)));
addOptional(p,'c_FN',default_c_FN,@(x) isvector(x) && isequal(3,length(x)));
addOptional(p,'c_other',default_c_other,@(x) isvector(x) && isequal(3,length(x)));

parse( p , varargin{:} );
c_TN    = p.Results.c_TN; c_TN = c_TN(:)';
c_TP    = p.Results.c_TP; c_TP = c_TP(:)';
c_FP    = p.Results.c_FP; c_FP = c_FP(:)';
c_FN    = p.Results.c_FN; c_FN = c_FN(:)';
c_other = p.Results.c_other; c_other = c_other(:)';

end