%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X,Y coordinates of a circle from paramters
%
% [X,Y] = get_X_Y_circle(x,y,R,N)
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%ENTREES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% x,y            # coordinates of the centre
% R              # radius of the circle
% N              # (optional) number of points 
%                   default : 40 :  angle step = 2*pi/N;
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%SORTIES%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%  X, Y          # coordinates X et Y of the circle
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_X_Y_circle.m
% Guillaume NOYEL 17-06-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [X,Y] = get_X_Y_circle(x,y,R,N)


%% Vérifications

nb_arg_fixe = 3;
switch nargin
    case nb_arg_fixe
        N = 40;
    case nb_arg_fixe+1
        %OK
    otherwise
        error(mfilename, '##Nombre d''arguments incorrects');
end


%% Programme

pas = 2*pi/N;

Theta = 0:pas:2*pi;
X = R*cos(Theta) + x;
Y = R*sin(Theta) + y;

X = X(:);
Y = Y(:);

end