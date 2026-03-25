%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIP-additive dilation on a grey level image (direct implementation).
%
% [ imout ] = LIP_imdilate( imin , se , M )
%
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imin                # input image
%
% se                  # structuring element
%   M                 # maximal dynamic for the image:
%                       256 for uint8 bit images
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imout              # logarithmic-dilation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIP_imdilate.m
% Guillaume NOYEL 24-01-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ imout ] = LIP_imdilate( imin , se , M )


%% Input management

[ imin , se , M ] = parse_inputs(imin , se , M);

M = double(M);

msq_probe = se.getnhood;
im_probe = double(se.getheight);

imin = double(imin);


%% Going through the neighbourhood
if isImageConstant( im_probe( msq_probe ) )
    se = strel('arbitrary',msq_probe);
    val_probe = im_probe( msq_probe ); val_probe = val_probe(1);
    imout   = LIP_imadd( imdilate( imin, se ) , val_probe , M );
else
    se_hat          = strel('arbitrary',msq_probe, log( M./(M - im_probe) ) ); % = -log( 1 - im_probe/M )
    imout           = M*(1 - exp(-imdilate( log( M./(M - imin) ) ,se_hat)));
end

end

function [ imin , se , M ] = parse_inputs(imin , se , M)

p = inputParser;

addRequired(p,'imin',@isnumeric);
addRequired(p,'se',@(x) isa(x,'strel'));
addRequired(p,'M',@(x) isnumeric(x) && ismember( M ,  [ 2^8  2^16  2^32  2^64 ] ));

parse( p , imin , se , M );

end
