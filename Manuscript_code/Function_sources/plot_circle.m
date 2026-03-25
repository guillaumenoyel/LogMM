%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot a circle from paramters
%
%  h = plot_circle(x,y,R,color,h)
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% x,y            # coordinates of the centre
% R              # radius of the circle
% color          # (optional) = colour of the plot : default 'b'
% h              # (optional) figure handle : default current figure;
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%  X, Y          # coordinates X et Y of the circle
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot_circle.m
% Guillaume NOYEL 17-06-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h = plot_circle(x,y,R,color,h)


%% Checkings

nb_arg_fixe = 3;
switch nargin
    case nb_arg_fixe
        color = 'b';
        h = gcf;
    case nb_arg_fixe+1
        h = gcf;
    case nb_arg_fixe+2
        %OK
    otherwise
        error(mfilename, '##Incorrect argument number');
end

%% Program

thetaResolution = 2; % degrees
N = 360/thetaResolution + 1; % number of points

[X,Y] = get_X_Y_circle(x,y,R,N);
figure(h);
plot(X,Y,color);

end