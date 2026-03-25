%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Map of Asplund's distances on a grey image (LIP-additive)
% (Morphological version)
%
% [im_dist , im_c1 , im_c2] = LIP_imDistAsplundAdd( imin , SE_probe , M )
%
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imin              # input image (in grey tones)
%
% SE_probe          # structuring element corresponding to the probe
%                       msq_probe = SE_probe.getnhood
%                       im_probe = SE_probe.getheight
% M                 # maximal range of the image: e.g. 256 for images
%                       uint8, 65536 for images uint16
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im_dist           # Map of Asplund's distances
% im_c1             # map of the least upper bounds
% im_c2             # map of the greatest lower bounds
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIP_imDistAsplundAdd.m
% Guillaume NOYEL 14/11/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [im_dist , im_c1 , im_c2] = LIP_imDistAsplundAdd( imin , SE_probe , M )


M = double(M);

msq_probe = SE_probe.getnhood;
im_probe = double(SE_probe.getheight);

imin = double(imin);


%% Going through the neighbourhood
if isImageConstant( im_probe( msq_probe ) )
    se = strel('arbitrary',msq_probe);
    im_c1  = imdilate( imin ,se.reflect() );% the se is reflected
    im_c2  = imerode( imin, se );
    
    val_probe = im_probe( msq_probe ); val_probe = val_probe(1);
    im_dist = LIP_imsubtract(im_c1 , im_c2 , M);
    
    im_c1   = LIP_imsubtract( im_c1 , val_probe , M );
    im_c2   = LIP_imsubtract( im_c2 , val_probe , M );
else
    im_hat          = log( M./(M - imin) ); % = -log(1 - imin/M);
    im_probe_hat    = log( M./(M - im_probe) ); % = -log(1 - im_probe/M)
    se_di           = strel('arbitrary',msq_probe,-im_probe_hat);
    se_er           = strel('arbitrary',msq_probe,im_probe_hat);
    im_c2_core      = imerode(im_hat,se_er);
    im_c1_core      = imdilate(im_hat,se_di.reflect()); % the se is reflected
    im_dist         = M * ( 1 - exp(-(im_c1_core-im_c2_core)) );
    im_c1           = M*(1 - exp(-im_c1_core));
    im_c2           = M*(1 - exp(-im_c2_core));
    %im_dist        = LIP_imsubtract(im_c1 , im_c2 , M);
end


end