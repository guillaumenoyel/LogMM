%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Map of Asplund Distances for grey-level images (additive)
%   the greatest lower probe and  the smallest upper probe are looked for
%   with a tolerance on the number of points (morphological method with rank filters)
%
% [im_dist, im_c1 , im_c2] = imDistAsplundAddTol_morpho( imin , SE_probe , tol_pts )
% [im_dist, im_c1 , im_c2] = imDistAsplundAddTol_morpho( imin , SE_probe , tol_pts , flag_c1_leader )
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
% imDistAsplundAddTol_morpho.m
% Guillaume NOYEL 20/01/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [im_dist, im_c1 , im_c2] = imDistAsplundAddTol_morpho( imin , SE_probe , tol_pts , varargin )


%% Management of Inputs

[imin , SE_probe , tol_pts , flag_c1_leader] = ParseInputs(imin , SE_probe , tol_pts , varargin{:} );

%% Program



imin = double(imin);



%% Preparation of data and parameters

Nb_pts_probe    = sum(SE_probe.Neighborhood(:));
nb_pts_suppr    = round((1-tol_pts) * Nb_pts_probe);
if flag_c1_leader % the advantage is given to c1 over c2
    nb_pts_suppr_c1 = round(nb_pts_suppr/2);
    nb_pts_suppr_c2 = nb_pts_suppr - nb_pts_suppr_c1;
else
    nb_pts_suppr_c2 = round(nb_pts_suppr/2);
    nb_pts_suppr_c1 = nb_pts_suppr - nb_pts_suppr_c2;
end

%% Going through the neighbourhood

SE_probe_neg    = strel_imneg( SE_probe );

im_c1           = imdilate_tol( imin , SE_probe_neg.reflect() , [] , nb_pts_suppr_c1 );
im_c2           = imerode_tol(  imin , SE_probe , [] , nb_pts_suppr_c2 );

im_dist         = imsubtract( im_c1 , im_c2 );



end


%% Parse inputs

function [imin , SE_probe , tol_pts , flag_c1_leader] = ParseInputs(imin , SE_probe , tol_pts , varargin )

p = inputParser;
default_flag_c1_leader = true;


addRequired(p,'imin',@(x) isnumeric(x));
addRequired(p,'SE_probe',@(x) isa(x,'strel'));
addRequired(p,'tol_pts',@(x) isnumeric(x) && (x>=0) && (x<=1));
addOptional(p,'flag_c1_leader',default_flag_c1_leader,@(x) islogical(x) && (numel(x)==1));

parse( p , imin , SE_probe , tol_pts , varargin{:} );
flag_c1_leader = p.Results.flag_c1_leader;

end