%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fill an hyperspectral image with vector pixels whoses location is defined by a mask 
%
% [ im ] = imhsp_mskfill( im , Spectral_matrix , msk_2D )
% [ im ] = imhsp_mskfill( im , Spectral_vector , msk_2D )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% INPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im                # hyperspectral input image
% Spectral_matrix   # matrix of vectors used to fill the image
% or
% Spectral_vector   # 1 vector used to fill the image
% msk_2D            # 2D binary mask corresponding to vectors to extract
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% OUTPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im                # hyperspectral output image filled with Spectral_matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% imhsp_mskfill.m
% Guillaume NOYEL 23-06-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ im ] = imhsp_mskfill( im , Spectral_matrix , msk_2D )

Spectral_matrix = squeeze(Spectral_matrix);

SZ_msk = size(msk_2D);
SZ_im = size(im);
if( any( SZ_im(1:2) ~= SZ_msk ) )
   error('image and msk msut have compatible sizes');
end

DP = size(im,3);

if all(size(Spectral_matrix) == [1 3]) % Case of the spectral vector
    N_vectors = sum(msk_2D(:));
    Spectral_matrix = repmat( Spectral_matrix , [N_vectors 1] );
end

im( repmat(msk_2D,[1 1 DP]) ) = Spectral_matrix(:);



end

