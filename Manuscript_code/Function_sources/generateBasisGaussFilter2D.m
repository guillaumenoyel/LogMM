
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  This function generates the separable basis filters of the    
%    of the Gaussian function G2 (X-Y separable version)
%
%   [filterG] = generateBasisGaussFilter2D( sigma_pix , Nb_sigma )
%
%   Filter are normalised in order to have an integral equal to 1
%         g0 = g0_y' * g0_x;
%
%         sum(g0(:)) == 1
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% INPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% sigma_pix         # standard deviation of the Gaussian filter : number of pixels for the standard deviation of the gaussian
% Nb_sigma          # number of sigma (standard deviation). Default 4.
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% OUTPUT %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% filterG           # Gaussian filter basis
%                         filterG.g0_x = g0_x;
%                         filterG.g0_y = g0_y;
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generateBasisGaussFilter2D.m
% Guillaume NOYEL 26-08-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% close all; clear all;
% sigma_pix = 6;
% Nb_sigma = 4;

function [filterG] = generateBasisGaussFilter2D( sigma_pix , Nb_sigma )

%% ------------------------- Input management


nb_fixed_arg = 1;
if nargin == nb_fixed_arg
    Nb_sigma = 4; % Number of sigma for the gaussian
end


%% ------------------------- Parameters

flag_display = false;%false;%true;%;

%% Program

% Determine necessary filter support (for Gaussian).
sigma = 1/sqrt(2); % standard deviation of the gaussian used
f0 = 1/sigma;
fe = sigma_pix*f0; % sampling frequency


Wx = Nb_sigma * sigma; 

x = [-Wx:1/fe:Wx];

%% - Gaussian

g0_x     = exp(-(x.^2) ) / (sigma*sqrt(2*pi)); 
g0_x     = g0_x / sum(g0_x);
g0_y     = g0_x;

if flag_display
    [xx,yy] = meshgrid(x,x);
    
    g0 = exp(-(xx.^2+yy.^2) );% / ((sigma^2)*2*pi);
    g0 = g0 / sum(g0(:));

    g0_xy = g0_y' * g0_x;
    
    sum(g0_xy(:))
    b1 = areImagesEqual( g0 , g0_xy , 1e-13 )

    figure;
    subplot(1,2,1)
    surf(g0_xy); shading interp;
    title('g0')
    set(gca,'YDir','reverse')
    
    subplot(1,2,2)
    imagesc(g0_xy);
    axis equal
end

filterG.g0_x = g0_x;
filterG.g0_y = g0_y;
