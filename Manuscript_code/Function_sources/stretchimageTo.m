%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Maximisation de la dynamique de l'histogramme
% [imout] = stretchimageTo( imin , [low_out high_out] , [low_in high_in] )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imin                  # input image
% [low_out high_out]    # Minimum and maximum of the output image
% [low_in high_in]      # (Optional) Minimum and maximum of the input image
%                           Default : low_in  = min(imin(:))
%                                     low_out = max(imin(:))
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% imout                 # output image (in double)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stretchimageTo.m
% Guillaume Noyel 30/01/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [imout] = stretchimageTo(imin , out_bounds , varargin )


%% Input management
[ imin , low_out , high_out , low_in , high_in ] = parse_inputs(imin , out_bounds , varargin{:});

%% Stretch
imin(imin < low_in) = low_in;
imin(imin > high_in) = high_in;

imout = (high_out-low_out)*((imin-low_in)/(high_in - low_in));


end

%% Input management
function [ imin , low_out , high_out , low_in , high_in ] = parse_inputs(imin , out_bounds , varargin)

p = inputParser;
mini_in = min(imin(:));
maxi_in = max(imin(:));
default_in_bounds = [ mini_in maxi_in ];

addRequired(p,'imin',@isnumeric);
addRequired(p,'out_bounds',@(x) (isnumeric(x) && (numel(x) == 2) && (out_bounds(1) <= out_bounds(2))) );
addOptional(p,'in_bounds',default_in_bounds,@(x) (isnumeric(x) && (numel(x) == 2) && ...
    (default_in_bounds(1)>= mini_in) && (default_in_bounds(1)<= maxi_in) && ...
    (default_in_bounds(2)>= mini_in) && (default_in_bounds(2)<= maxi_in) && ...
    (default_in_bounds(1) <= default_in_bounds(2)) ));

parse( p , imin , out_bounds , varargin{:} );

imin        = double(p.Results.imin);
low_out     = double(p.Results.out_bounds(1));
high_out    = double(p.Results.out_bounds(2));
low_in      = double(p.Results.in_bounds(1));
high_in     = double(p.Results.in_bounds(2));

end