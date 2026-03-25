%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIP-additive erosion on a grey level image (direct implementation).
%
% [ imout , nb_pts_suppr ] = LIP_imerode_tol( imin , se , M , tol_pts )
% [imout , nb_pts_suppr]   = LIP_imerode_tol( imin , se , M ,     [] , order )
%
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imin                # input image
%
% se                  # structuring element
%   M                 # maximal dynamic for the image:
%                       256 for uint8 bit images
% tol_pts             # tolerance on the number of points to be kept
%                         (e.g. 95/100). tol_pts has to be in the interval [0,1]
%                          1 : all points are kept.
% order               # (option) order of the filter: number between 1 and the number
%                           of points of se
%                       msk_se          = se.getnhood()
%                       Nb_pts_probe    = sum(msk_se(:));
%                       nb_pts_suppr    = round((1-tol_pts) * Nb_pts_probe);
%                       order           = Nb_pts_probe-nb_pts_suppr;
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imout              # logarithmic erosion
% nb_pts_suppr       # number of suppressed points in the neighbourhood of each pixel
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIP_imerode_tol.m
% Guillaume NOYEL 27-06-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ imout , nb_pts_suppr ] = LIP_imerode_tol( imin , se , M , tol_pts , varargin )


%% Input management

[imin , se , M , ~ , nb_pts_suppr ] = parse_inputs( imin , se , M , tol_pts , varargin{:} );

M = double(M);

msq_probe = se.getnhood;
im_probe = double(se.getheight);

imin = double(imin);


%% Going through the neighbourhood
if isImageConstant( im_probe( msq_probe ) )
    se                      = strel('arbitrary',msq_probe);
    val_probe               = im_probe( msq_probe ); val_probe = val_probe(1);
    [imout , nb_pts_suppr]  = imerode_tol( imin, se , [] , nb_pts_suppr );
    imout                   = LIP_imsubtract( imout , val_probe , M );
else
    se_er                   = strel('arbitrary',msq_probe, log( M./(M - im_probe) ) );
    [imout , nb_pts_suppr]  = imerode_tol( log( M./(M - imin)) , se_er , [] , nb_pts_suppr );
    imout                   = M*(1 - exp(-imout));
end

end

%% Parse inputs
function [ imin , se , M , order_ero , nb_pts_suppr ] = parse_inputs( imin , se , M , tol_pts , varargin )

Nb_pts_probe            = sum(se.Neighborhood(:));
default_nb_pts_suppr    = round((1-tol_pts) * Nb_pts_probe);

p = inputParser;

addRequired(p,'imin',@isnumeric);
addRequired(p,'se',@(x) isa(x,'strel'));
addRequired(p,'M',@(x) isnumeric(x) && ismember( M ,  [ 2^8  2^16  2^32  2^64 ] ));
addRequired(p,'tol_pts',@(x) isempty(x) || (isnumeric(x) && (x>=0) && (x<=1)) );
addOptional(p,'nb_pts_suppr',default_nb_pts_suppr,@(x) isnumeric(x) && (x>=0) && (x<=Nb_pts_probe));

parse( p , imin , se , M , tol_pts , varargin{:} );
nb_pts_suppr = p.Results.nb_pts_suppr;

order_ero   = Nb_pts_probe-nb_pts_suppr;

end

