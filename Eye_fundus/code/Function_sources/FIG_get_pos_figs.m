%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ecran = get_screen_size()
% Give the position for 12 figures on one or two screens
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% pos_fig    # array of figures position
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% EXEMPLE%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
% 
% pos_fig = FIG_get_pos_figs()
% fig_ref = figure();
% set(fig_ref,'OuterPosition',pos_fenetre(1,:));
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG_get_pos_figs.m 
% Guillaume NOYEL 30-06-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pos_fig = FIG_get_pos_figs()


screen_sz = get_screen_size(0);
screen_sz_1 = get_screen_size(1);

nb2 = 4; % Number of images on the second screen

pos_fig = [ 
    screen_sz(1) + 0*screen_sz(3)/3 , screen_sz(2) + 1*screen_sz(4)/2 , screen_sz(3)/3 , screen_sz(4)/2 
    screen_sz(1) + 1*screen_sz(3)/3 , screen_sz(2) + 1*screen_sz(4)/2 , screen_sz(3)/3 , screen_sz(4)/2 
    screen_sz(1) + 2*screen_sz(3)/3 , screen_sz(2) + 1*screen_sz(4)/2 , screen_sz(3)/3 , screen_sz(4)/2 
    
    screen_sz(1) + 0*screen_sz(3)/3 , screen_sz(2) + 0*screen_sz(4)/2 , screen_sz(3)/3 , screen_sz(4)/2 
    screen_sz(1) + 1*screen_sz(3)/3 , screen_sz(2) + 0*screen_sz(4)/2 , screen_sz(3)/3 , screen_sz(4)/2 
    screen_sz(1) + 2*screen_sz(3)/3 , screen_sz(2) + 0*screen_sz(4)/2 , screen_sz(3)/3 , screen_sz(4)/2 
    
    screen_sz_1(1) + 0*screen_sz_1(3)/nb2 , screen_sz_1(2) + 1*screen_sz_1(4)/2 , screen_sz_1(3)/nb2 , screen_sz_1(4)/2 
    screen_sz_1(1) + 1*screen_sz_1(3)/nb2 , screen_sz_1(2) + 1*screen_sz_1(4)/2 , screen_sz_1(3)/nb2 , screen_sz_1(4)/2 
    screen_sz_1(1) + 2*screen_sz_1(3)/nb2 , screen_sz_1(2) + 1*screen_sz_1(4)/2 , screen_sz_1(3)/nb2 , screen_sz_1(4)/2 
    screen_sz_1(1) + 3*screen_sz_1(3)/nb2 , screen_sz_1(2) + 1*screen_sz_1(4)/2 , screen_sz_1(3)/nb2 , screen_sz_1(4)/2 
    
    screen_sz_1(1) + 0*screen_sz_1(3)/nb2 , screen_sz_1(2) + 0*screen_sz_1(4)/2 , screen_sz_1(3)/nb2 , screen_sz_1(4)/2 
    screen_sz_1(1) + 1*screen_sz_1(3)/nb2 , screen_sz_1(2) + 0*screen_sz_1(4)/2 , screen_sz_1(3)/nb2 , screen_sz_1(4)/2 
    screen_sz_1(1) + 2*screen_sz_1(3)/nb2 , screen_sz_1(2) + 0*screen_sz_1(4)/2 , screen_sz_1(3)/nb2 , screen_sz_1(4)/2     
    screen_sz_1(1) + 3*screen_sz_1(3)/nb2 , screen_sz_1(2) + 0*screen_sz_1(4)/2 , screen_sz_1(3)/nb2 , screen_sz_1(4)/2     
    ];

pos_fig = cat( 1 , pos_fig , pos_fig );

end
