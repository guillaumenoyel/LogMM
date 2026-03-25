%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Erosion with a tolerance (rank order filter)
%
% [imout , nb_pts_suppr] = imerode_tol( imin , se , tol_pts )
% [imout , nb_pts_suppr] = imerode_tol( imin , se , [] , nb_pts_suppr )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imin          # input image
% se            # stucturing element
%                   msk_probe = SE_probe.getnhood
%                   im_probe = SE_probe.getheight
% tol_pts       # tolerance on the number of points to be kept
%                   (e.g. 95/100). tol_pts has to be in the interval [0,1]
%                  tol_pts can be set to [] if nb_pts_suppr parameter is specified
% nb_pts_suppr  # (option) number of suppressed points in the neighbourhood of each pixel
%                       Nb_pts_probe    = sum(se.Neighborhood(:));
%                       nb_pts_suppr    = round((1-tol_pts) * Nb_pts_probe);
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imout         # image after rank erosion.
%                   the output image is always in double precision format
% nb_pts_suppr  # number of suppressed points in the neighbourhood of each pixel
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% imerode_tol.m
% Guillaume NOYEL 04/06/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [imout , nb_pts_suppr] = imerode_tol( imin , se , tol_pts , varargin )


%% Management of Inputs

[imin , se , order_ero , nb_pts_suppr] = ParseInputs( imin , se , tol_pts , varargin{:} );

%% Programme

msq_probe = se.getnhood();


%% Preparation of data and parameters


%% Going through the neighbourhood
maxi = double(max(imin(:)));
%mini = double(min(imin(:)));

%se_ref = se;%.reflect(); % in ordfilt2 the se is reflected
%c2_core       = imerode(im_hat,se_er);
% We want a positive signal beacause of the (forced) zero padding of
% ordfilt2. Threfore, we subtract mini and we add min_se_di_abs

im_se_er        = se.getheight();    %min_se_er_abs = abs(min(im_se_er(msq_probe))); % max_se_er = max(im_se_er(msq_probe));
max_se_er_abs   = max(abs(im_se_er(msq_probe)));
max_se_er       = max(im_se_er(msq_probe));
%imout         = maxi-ordfilt2( maxi-double(imin)+1+min_se_er_abs , order_ero , ...
%    se_ref.getnhood(), se_ref.getheight()) +1 + min_se_er_abs;
imout         = ordfilt2( maxi-double(imin)+1+max_se_er_abs , order_ero , ...
    se.getnhood(), im_se_er ) ;

msk_invalid = imout<(1+max_se_er); % invalid values on the boundaries
if any(msk_invalid(:)) % if there is invalid values they are replaced by the minimum value on boundary (i.e. the erosion)
    se_ref_neg = strel('arbitrary', se.getnhood() , -im_se_er );
    % erosion on the edges
    SZ_strel = size(se_ref_neg.getnhood);
    SZ = size(imin);
    if all(SZ>SZ_strel) % % Erosion on each edge
        im_ero = Inf(SZ);
        im_ero(1:SZ_strel(1),:) = min( im_ero(1:SZ_strel(1),:) , ...
            imerode( maxi- double(imin(1:SZ_strel(1),:)) +1+max_se_er_abs  , se_ref_neg ) ); % top
        im_ero(:,1:SZ_strel(2)) = min( im_ero(:,1:SZ_strel(2)) , ...
            imerode( maxi- double(imin(:,1:SZ_strel(2))) +1+max_se_er_abs  , se_ref_neg ) ); % left
        im_ero(end-SZ_strel(1)+1:end,:) = min( im_ero(end-SZ_strel(1)+1:end,:) , ...
            imerode( maxi- double(imin(end-SZ_strel(1)+1:end,:)) +1+max_se_er_abs  , se_ref_neg ) ); % bottom
        im_ero(:,end-SZ_strel(2)+1:end) = min( im_ero(:,end-SZ_strel(2)+1:end) , ...
            imerode( maxi- double(imin(:,end-SZ_strel(2)+1:end)) +1+max_se_er_abs  , se_ref_neg ) ); % right
    else
        im_ero = imerode( maxi- double(imin) +1+max_se_er_abs  , se_ref_neg );
    end
    im_ero(im_ero == Inf) = -Inf; % to replace the +Inf values by -Inf as in im_erode
    imout(msk_invalid) = im_ero(msk_invalid);
end
imout = maxi- imout +1 + max_se_er_abs;

%     padsize = floor(size(se.getnhood)/2);
%     imout = maxi- unpadarray(  ordfilt2( padarray( maxi-imin , padsize , -Inf ) , order_ero , ...
%        se.getnhood(),se.getheight()) ,   padsize );




end


%% Parse inputs
function [imin , se , order_ero , nb_pts_suppr] = ParseInputs( imin , se , tol_pts , varargin )

Nb_pts_probe            = sum(se.Neighborhood(:));
default_nb_pts_suppr    = round((1-tol_pts) * Nb_pts_probe);

p = inputParser;

addRequired(p,'imin',@(x) isnumeric(x));
addRequired(p,'se',@(x) isa(x,'strel'));
addRequired(p,'tol_pts',@(x) isempty(x) || (isnumeric(x) && (x>=0) && (x<=1)) );
addOptional(p,'nb_pts_suppr',default_nb_pts_suppr,@(x) isnumeric(x) && (x>=0) && (x<=Nb_pts_probe));

parse( p , imin , se , tol_pts , varargin{:} );
nb_pts_suppr = p.Results.nb_pts_suppr;

order_ero   = Nb_pts_probe-nb_pts_suppr;

end