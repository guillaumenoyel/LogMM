
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fill holes of the vessels
%
% [msk_vessels_out] = DR_VES_fill_holes( msk_vessels_in , n )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% INPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% msk_vessels_in     # binary mask of the vessels
% n                  # number of dilations to fill the holes
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% OUTPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% msk_vessels_out     # filtered binary mask of the vessels
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DR_VES_fill_holes.m
% Guillaume NOYEL 03-07-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [msk_vessels_out] = DR_VES_fill_holes( msk_vessels_in , n )


%% Parameters
flag_display = false;%false;

%% Inputs management




%% Influential parameters 


%% Program

%% Fill holes of the network
se_v8 = strel( 'square' , 3 );
se = HomotheticSE( se_v8 , n );
msk_vessels_out = imdilate( msk_vessels_in , se );
msk_vessels_out = ~imreconstruct( ~msk_vessels_out , ~msk_vessels_in , 4 );

if flag_display
    figure
    imagesc(msk_vessels_out); colormap gray; hold on;
    title('Fill holes')
    axis equal
end