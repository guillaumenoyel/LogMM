%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Map of the supremum of the LIP-sum of the mglb (map of the least upper bounds) and of the probe on a sliding window
%
% [im_inf] = LIP_iminf_mlub_LP_probe( im_c1 , SE_probe , M )
%
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%   im_c1      # map of the least upper bounds
%   SE_probe   # structuring element corresponding to the probe
%                   msq_probe = SE_probe.getnhood
%                   im_probe = SE_probe.getheight
%   M          # maximal dynamic range of the image: e.g. 256 for uint8 images
%                   65536 for uint16 images
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% im_inf       # supremum of the LIP-sum of the mglb and of the probe on a sliding window
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIP_iminf_mlub_LP_probe.m
% Guillaume NOYEL 07/11/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




function [im_inf] = LIP_iminf_mlub_LP_probe( im_c1 , SE_probe , M )


M = double(M);

SE_probe = SE_probe.reflect();

msq_probe = SE_probe.getnhood;
im_probe = double(SE_probe.getheight);

SZ = size(msq_probe);
im_c1 = double(im_c1);

vect_probe = im_probe(msq_probe);

% Zero-padding is used to avoid the edge effects
im_out_neigh_t = zeros(SZ(1:2));
centre = get_strel_centre(msq_probe);
c_i = centre(1); c_j = centre(2);
sz_pad = [c_i-1 , c_j-1];


    function im_out_neigh = fun(block_struct)
        
        im_c1_win = block_struct.data(msq_probe);
        msq_val = ~isnan(im_c1_win);
        im_c1_win_val  = im_c1_win(msq_val); %suppression des points NaN
        vect_probe_val = vect_probe(msq_val);
        %Nb_pts_valid_tol = length(im_test_val);
        
        % LIP-sum between the mglb and the probe
        %im_Lsum = LIP_imadd( vect_probe_val , im_c1_win(c_i,c_j) , M );
        im_Lsum = LIP_imadd( vect_probe_val , im_c1_win_val , M );
        
        im_out_neigh = im_out_neigh_t;
        im_out_neigh( c_i,c_j ) = min(im_Lsum);
    end

im_inf = blockproc( im_c1 , [1 1],@fun, 'BorderSize' , sz_pad ,  'PadMethod' , NaN,'UseParallel',false);

end