%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graphic colours
%
%  s = graphic_colours()
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%  s        # Structure with graphic colours in the range [0,1]
%               s.graphicR     = [136 0 34]/255;     graphic Red
%               s.graphicG     = [0 85 68]/255;      graphic Green
%               s.graphicB     = [0 43 92]/255;      graphic Blue
%               s.graphicDrBr  = [153 85 34]/255;    graphic Dark Brown
%               s.graphicMdBr  = [204 170 102]/255;  graphic Medium Brown
%               s.graphicLBr   = [238 221 170]/255;  graphic Light Brown
%               s.graphicOrange = [239 142 31]/255;  graphic Orange
%               s.graphicPink = [255 87 129]/255;    graphic Pink
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graphic_colours.m
% Guillaume NOYEL 19-12-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function s = graphic_colours()


s.graphicR      = [136 0 34]/255;
s.graphicG      = [0 85 68]/255;
s.graphicB      = [0 43 92]/255;
s.graphicDrBr   = [153 85 34]/255;
s.graphicMdBr   = [204 170 102]/255;
s.graphicLBr    = [238 221 170]/255;
s.graphicOrange = [239 142 31]/255;
s.graphicPink   = [255 87 129]/255;