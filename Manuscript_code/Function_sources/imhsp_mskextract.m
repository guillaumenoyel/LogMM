%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract vector pixels of an hyperspectral image from a mask
%
% [ Spectral_matrix ] = imhsp_mskextract( im , msk_2D )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% INPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im             # hyperspectral input image
% msk_2D         # 2D binary mask corresponding to vectors to extract
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% OUTPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% Spectral_matrix # matrix of vectors extracted [Nb_pixels x Nb_channels]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% imhsp_mskextract.m
% Guillaume NOYEL 23-06-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ Spectral_matrix ] = imhsp_mskextract( im , msk_2D )

Nb_pix = sum(msk_2D(:));
Nb_chan = size(im,3);

Spectral_matrix = reshape( im(repmat(msk_2D,[1 1 Nb_chan])) , Nb_pix , Nb_chan );




end

