%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Map of Asplund's Distance for grey-level images (LIP-additive)
%   the greatest lower probe and  the smallest upper probe are looked for
%   with a tolerance on the number of points (morphological method)
%
% [im_dist, im_c1 , im_c2] = LIP_imDistAsplundAddTol( imin , SE_probe , tol_pts , M )
% [im_dist, im_c1 , im_c2] = LIP_imDistAsplundAddTol( imin , SE_probe , tol_pts , M , flag_c1_leader )
%
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imin          # input image
% SE_probe      # stucturing element corresponding to the probe
%                   msk_probe = SE_probe.getnhood
%                   im_probe = SE_probe.getheight
% tol_pts       # tolerance on the number of points to be kept
%                   (e.g. 95/100). tol_pts has to be in the interval [0,1]
% M             # maximal range of the image: e.g. 256 for images
%                           uint8, 65536 for images uint16
% flag_c1_leader # (option) flag which gives an advantage of 1 suppressed points to
%                   the upper probe c1 with respect to the lower probe c2 (if the number
%                   points to be supressed is odd).
%                   Default : true.
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im_dist       # Map of Asplund's distances (LIP-additive)
% im_c1         # map of the least upper bounds 
% im_c2         # map of the greatest lower bounds 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIP_imDistAsplundAddTol.m
% Guillaume NOYEL 17/10/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [im_dist, im_c1 , im_c2] = LIP_imDistAsplundAddTol( imin , SE_probe , tol_pts , M , varargin )


%% Management of Inputs

[imin , SE_probe , tol_pts , M , flag_c1_leader] = ParseInputs(imin , SE_probe , tol_pts , M , varargin{:} );

%% Programme

msq_probe = SE_probe.getnhood();
im_probe = double(SE_probe.getheight);

imin = double(imin);

% Zero-padding is used to avoid the edge effects
% padsize = floor((SZ+1)/2); % taille de padding (centre of the structuring element)
M = double(M);



%% Preparation of data and parameters

im_hat          = -log( 1 - imin/M );
Nb_pts_probe    = sum(msq_probe(:));
nb_pts_suppr    = round((1-tol_pts) * Nb_pts_probe);
if flag_c1_leader % the advantage is given to c1 over c2
    nb_pts_suppr_c1 = round(nb_pts_suppr/2);
    nb_pts_suppr_c2 = nb_pts_suppr - nb_pts_suppr_c1;
else
    nb_pts_suppr_c2 = round(nb_pts_suppr/2);
    nb_pts_suppr_c1 = nb_pts_suppr - nb_pts_suppr_c2;
end
order_c2        = nb_pts_suppr_c2+1;%1
order_c1        = Nb_pts_probe-nb_pts_suppr_c1;
order_c2_comp   = Nb_pts_probe-order_c2 + 1; % We complement because of the (forced) zero padding of ordfilt2

%% Going through the neighbourhood
if isImageConstant( im_probe( msq_probe ) )
    maxi = max(imin(:));  mini = min(imin(:));
    
    se = strel('arbitrary',msq_probe);
    %im_c2   = imerode( imin, se );
    
    im_c2       = maxi-ordfilt2( maxi-imin , order_c2_comp , se.getnhood() );
    
    %im_c1      = imdilate( imin ,se.reflect() ); % the se is reflected
    im_c1       = ordfilt2( imin-mini , order_c1 , se.getnhood() )+mini;  % No reflection in ordfilt2 (because the se is already reflected)
    
    im_dist     = LIP_imsubtract( im_c1 , im_c2 , M );
    val_probe   = im_probe( msq_probe ); val_probe = val_probe(1);
    im_c1       = LIP_imsubtract( im_c1 , val_probe , M );
    im_c2       = LIP_imsubtract( im_c2 , val_probe , M );    
else
    maxi = max(im_hat(:));  mini = min(im_hat(:));
    
    im_probe_hat    = -(log( 1 - im_probe/M ));
    se_di           = strel('arbitrary',msq_probe,-im_probe_hat);
    %se_di_ref       = se_di.reflect();
    se_er           = strel('arbitrary',msq_probe,im_probe_hat);
    
    %c2_core       = imerode(im_hat,se_er);
    im_se_er        = se_er.getheight();    min_se_er_abs = abs(min(im_se_er(msq_probe))); % max_se_er = max(im_se_er(msq_probe));
    %c2_core         = maxi-ordfilt2( maxi-im_hat+max_se_er ,order_c2_comp,se_er.getnhood(),se_er.getheight())+max_se_er;
    c2_core         = maxi-ordfilt2( maxi-im_hat+min_se_er_abs ,order_c2_comp,se_er.getnhood(),se_er.getheight())+min_se_er_abs;
    %c2_core       = ordfilt2(im_hat,order_c2,se_er.getnhood(),se_er.getheight());
    %padsize = floor(size(se_di.getnhood)/2);
    %c2_core2 = maxi- unpadarray(  ordfilt2( padarray( maxi-im_hat , padsize , -Inf ) , order_c2_comp,se_er.getnhood(),se_er.getheight()) ,  padsize );
    
    %c1_core      = imdilate(im_hat,se_di.reflect()); % the se is reflected
    %c1_core      = ordfilt2(im_hat,order_c1,se_di_ref.getnhood(),se_di_ref.getheight());
    % We want a positive signal beacause of the (forced) zero padding of
    % ordfilt2. Threfore, we subtract mini and we add min_se_di_abs
    im_se_di        = se_di.getheight();     min_se_di_abs = abs(min(im_se_di(msq_probe)));
    c1_core         = ordfilt2( im_hat-mini+min_se_di_abs ,order_c1,se_di.getnhood(),se_di.getheight())+ mini- min_se_di_abs ; 
    %c1_core = ordfilt2( im_hat-maxi-max_se_di ,order_c1,se_di.getnhood(),se_di.getheight()) + maxi + max_se_di ; 
    %padsize = floor(size(se_di.getnhood)/2)+1;
    %c1_core2 = unpadarray(  ordfilt2( padarray(im_hat-min_se_di , padsize , -Inf ) , order_c1,se_di.getnhood(),se_di.getheight()) ,  padsize ) + min_se_di;
    
    im_dist         = M*(1-exp(-(c1_core - c2_core)));
    im_c1           = M*(1-exp(-(c1_core)));
    im_c2           = M*(1-exp(-(c2_core)));
end

end


%% Parse inputs

function [imin , SE_probe , tol_pts , M , flag_c1_leader] = ParseInputs(imin , SE_probe , tol_pts , M , varargin )

p = inputParser;
default_flag_c1_leader = true;

M = double(M);

addRequired(p,'M',@(x) isnumeric(x) && ismember( M ,  [ 2^8  2^16  2^32  2^64 ] ));
%addRequired(p,'imin',@(x) isnumeric(x) && all(imin(:)<=M));
%addRequired(p,'SE_probe',@(x) isa(x,'strel') && all(reshape(x.getheight(),[numel(x.getheight()),1])<=M));
addRequired(p,'imin',@(x) isnumeric(x));
addRequired(p,'SE_probe',@(x) isa(x,'strel'));
addRequired(p,'tol_pts',@(x) isnumeric(x) && (x>=0) && (x<=1));
addOptional(p,'flag_c1_leader',default_flag_c1_leader,@(x) islogical(x) && (numel(x)==1));

parse( p , M , imin , SE_probe , tol_pts , varargin{:} );
flag_c1_leader = p.Results.flag_c1_leader;

end