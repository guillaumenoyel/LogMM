%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To delete the files with a test of existnce of the file. This avoids the
% waring if the file is absent
%
% [] = Effacer_fichiers( fname1 , fname2, ... )
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% INPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
%   fname1  : filename 1 as a char
%   fname2  : filename 2 as a char
%
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-% OUTPUTS %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Effacer_fichiers.m
% Guillaume NOYEL 04-09-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Effacer_fichiers(varargin)


%% Vérification des entrées
for n=1:nargin
    if ~ischar(varargin{n})
       error(mfilename, '##Error inputs must be chars');
    end
end

%% Programme

for n=1:nargin
    if(exist(varargin{n},'file')==2)
        delete(varargin{n});
    end
end

end