%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Struturing function with 3 oriented segments
%
%   [SE , idx_ctr , idx_l , idx_r] = strel_3_oriented_segments( len , DEG , width , height_val , tab_flag_seg_activated , flag_centred )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% len               #   length of each segment
% DEG               #   orientation (in degrees) in the trigonometric direction of the image reference
%                       (y-axis top to bottom) dans le sens
%
%                       |------------> X
%                       |
%                       |
%                       |
%                       |
%                       V  Y
%
%                       WARNING the orientation angle is the opposite of
%                       the one used for the strel line : strel('line',LEN,-DEG)
% width             # width between the external segments
% height_val        # (option) height values of the segments. Vector of length 3:
%                       [left, central, right]
%                       Default: [0, 0, 0].
% tab_flag_seg_activated # (option) logical table of the activated
%                           segments [flag_act_left , falg_act_centre, flag_act_right]
%                           Choose which segment(s) is (are) activated.
%                           Default: the 3 segments are activated [true , true , true]
%
% flag_centred      # (option) is the struturing element centred or not
%                       Default: not centred.
%
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% SE                #   structuring function
% idx_ctr           # indices of the central segment
% idx_l             # indices of the left segment
% idx_r             # indices of the right segment
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% strel_3_oriented_segments.m
% Guillaume NOYEL 24-05-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [SE, idx_ctr , idx_l , idx_r] = strel_3_oriented_segments( len , DEG , width , varargin )

%% Parameters

flag_disp       = false;%true; % display flag

%% Input parser

[len , DEG , width , height_val , tab_flag_seg_activated , flag_centred] = ParseInputs(len , DEG , width , varargin{:} );

%% Program

val_l = height_val(1); % left height
val_c = height_val(2); % central height
val_r = height_val(3); % right height
d_left  = floor( (width+1)/2 )-1; % distance bewteen the central line and the left line
d_right = d_left; % distance bewteen the central line and the rightt line

if (len >= 1)
    % The line is constructed so that it is always symmetric with respect
    % to the origin.
    %central line
    theta = DEG * pi / 180;
    co = cos(theta);    si = sin(theta);
    
    x_st  = 0;
    y_st  = 0;
    
    x_end = round(x_st + (len-1) * co);% -1 is subtracted from the length because the origin starts at zero
    y_end = round(y_st + (len-1) * si);% -1 is subtracted from the length because the origin starts at zero
    [c,r] = iptui.intline(x_st,x_end,y_st,y_end);
    
    %left line
    xl_st   = round(x_st + d_left *   si);
    yl_st   = round(y_st + d_left * (-co));
    cl  = xl_st + c;    rl  = yl_st + r;
    
    % right line
    xr_st   = round(x_st + d_right * (-si));
    yr_st   = round(y_st + d_right *   co);
    cr      = xr_st + c;    rr  = yr_st + r;
    
    % creation of the neighbourhood mask
    if flag_centred
        max_r   = max( [r; rl; rr] );% maximum raw index
        max_c   = max( [c; cl; cr] );% maximum column index
        min_r   = min( [r; rl; rr] );% minimum raw index
        min_c   = min( [c; cl; cr] );% minimum column index
        
        M = max_r - min_r + 1;
        N = max_c - min_c + 1;
        idx_ctr = sub2ind([M N], r - min_r + 1,     c - min_c  + 1); %centre line
        idx_l = sub2ind([M N],  rl - min_r + 1,    cl - min_c + 1); %left line
        idx_r = sub2ind([M N],  rr - min_r + 1,    cr - min_c + 1); %right line
    else
        max_r   = max( abs([r; rl; rr]) );% maximum raw index
        max_c   = max( abs([c; cl; cr]) );% maximum column index
        
        M = 2*max_r + 1;
        N = 2*max_c + 1;
        idx_ctr = sub2ind([M N], r + max_r + 1, c + max_c + 1); %centre line
        idx_l = sub2ind([M N], rl + max_r + 1, cl + max_c + 1); %left line
        idx_r = sub2ind([M N], rr + max_r + 1, cr + max_c + 1); %right line
    end
    se_nhood = false(M,N);
    se_height = zeros(M,N);
    
    %centre line
    if tab_flag_seg_activated(2)
        se_nhood(idx_ctr) = true;
        se_height(idx_ctr) = val_c;
    end
    %left line
    if tab_flag_seg_activated(1)
        se_nhood(idx_l) = true;
        se_height(idx_l) = val_l;
    end
    %right line
    if tab_flag_seg_activated(3)
        se_nhood(idx_r) = true;
        se_height(idx_r) = val_r;
    end
    
else
    % Do nothing here, which effectively returns the empty strel.
    se_nhood = [];
    se_height = [];
end

SE = strel('arbitrary', se_nhood , se_height) ;

if flag_disp
    disp('Distance between centre line and left line');
    distEuclid( [c + max_c,r + max_r + 1]   , [cl + max_c,rl + max_r + 1] )
    disp('Distance between centre line and right line');
    distEuclid( [c + max_c,r + max_r + 1]   , [cr + max_c,rr + max_r + 1] )
    disp('Distance between left line and right line');
    distEuclid( [cr + max_c,rr + max_r + 1] , [cl + max_c,rl + max_r + 1] )
    
    figure;
    subplot(1,2,1)
    vois = SE.getnhood;
    imagesc(vois); colormap gray; hold on; axis equal
    title(sprintf('SE (angle %.02f°)',DEG))
    [ij_centre]=get_strel_centre(SE); ycen = ij_centre(1); xcen = ij_centre(2);
    quiver(xcen,ycen,xcen,0,'g');
    %quiver(xcen,ycen,x_end,y_end,'b');
    quiver(xcen,ycen,c(end),r(end),0,'b');
    if flag_centred
        quiver(xcen,ycen,round((len-1)/2*co),round((len-1)/2*si),0,'r');
    else
        quiver(xcen,ycen,round((len-1)*co),round((len-1)*si),0,'r');
    end
    
    subplot(1,2,2)
    imagesc(SE.getheight); colormap gray; hold on; axis equal
    title('Structuring function image')
end

end

%% Input parser

% len               #   length of each segment
% DEG               #   orientation (in degrees) in the trigonometric direction of the image reference
%                       (y-axis top to bottom) dans le sens
%
%                       |------------> X
%                       |
%                       |
%                       |
%                       |
%                       V  Y
%
%                       WARNING the orientation angle is the opposite of
%                       the one used for the strel line : strel('line',LEN,-DEG)
% width             # width between the external segments
% height_val        # (option) height values of the segments. Vector of length 3:
%                       [left, central, right]
%                       Default: [0, 0, 0].
% flag_centred      # (option) is the struturing element centred or not
%                       Default: not centred.

function [len , DEG , width , height_val , tab_flag_seg_activated , flag_centred] = ParseInputs( len , DEG , width , varargin )

p = inputParser;

default_height_val = [ 0 0 0 ];
default_tab_flag_seg_activated = [true , true , true];
default_flag_centred = false;

addRequired(p,'len',@(x) isscalar(x) && (x >= 0));
addRequired(p,'DEG',@isscalar);
addRequired(p,'width',@(x) isscalar(x) && (x >= 0));
addOptional(p,'height_val',default_height_val,@(x) isnumeric(x) && isvector(x) && length(x)==3);
addOptional(p,'tab_flag_seg_activated',default_tab_flag_seg_activated,@(x) isvector(x) && length(x)==3);
addOptional(p,'flag_centred',default_flag_centred,@(x) isscalar(x) && islogical(x));

parse( p , len , DEG , width , varargin{:} );
height_val              = p.Results.height_val;
tab_flag_seg_activated  = p.Results.tab_flag_seg_activated;
flag_centred            = p.Results.flag_centred;

tab_flag_seg_activated = logical(tab_flag_seg_activated);

end
